/**
*   apex class: ClsBatch_OEM_MonthlyBBBtoMapping
*
@author Michael Cui
@version 1.0
*
@changelog
* 2014-09-04 Michael Cui
* update this for case 00733781 to ignore the DML query issue as total BBB query records was great than 50,000.
* 
* 2014-12-16 Nelson Zheng
* rewrite the logic to fix the bug of "others" and to match the priority change of the type.
*/
global class ClsBatch_OEM_MonthlyBBBtoMapping implements Database.Batchable<SObject>,Database.Stateful{
    
    public String query; 
    public String CurrentPeriodFMonth;
    public Integer iCurrentPeriodFMonth;
    public String CurrentPeriodFYear;
    public OEM_Mapping_Rule__c othersOEMMappingRule;
    
    public ClsBatch_OEM_MonthlyBBBtoMapping(String fiscalMonth, String fiscalYear)
    {        
        CurrentPeriodFMonth = fiscalMonth;
        CurrentPeriodFYear = fiscalYear; 
        iCurrentPeriodFMonth = Integer.valueOf(fiscalMonth); 
        
        //get the OEM_Mapping_Rule__c record of others in current fiscalMonth and fiscalYear
        List<OEM_Mapping_Rule__c> othersOEMMappingRuleList = [select Id from OEM_Mapping_Rule__c
                                                                where fiscal_month__c =: CurrentPeriodFMonth 
                                                                and fiscal_year__c =: CurrentPeriodFYear
                                                                and Active__c = true
                                                                and OEM__r.OEM__r.Name = 'NON OEM'
                                                                and type__c = 'Customer'
                                                                and Allocation__c = 100
                                                                limit 1];
        System.debug('---------------othersOEMMappingRuleList---------------'+othersOEMMappingRuleList);
        if(othersOEMMappingRuleList.size() > 0){
            othersOEMMappingRule = othersOEMMappingRuleList[0];
        }
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {            
        
       if (query == null || query == '')
       {
        Integer BBBMonth = Integer.valueOf(CurrentPeriodFMonth);
        query ='Select Id, Bill_Amount_USD__c , ' +
                      ' Customer__r.WWCORPACCT__c, Customer__r.AccountNumber, Part__c ' +
                      ' from BBB_Month_Bill_Book_Cust_PN__c ' +
                      ' where fiscal_month__c =: BBBMonth and fiscal_year__c =: CurrentPeriodFYear' +
                      ' and IsDeleted = false and Profit_Center__c = \'DND\'';// +
                      //'  and id = \'a1nE00000013pBA\' and (customer__r.AccountNumber in: soldtoaccountcodeset ' +
                      //' or customer__r.WWCORPACCT__c in: wwCusNumset or ' +
                      //' part__c in: partnumberset) ';
        System.debug('-------------------query---------------'+query);
                                         
       }       
        return Database.getQueryLocator(query);         
    }

    global void execute(Database.BatchableContext BC, list<BBB_Month_Bill_Book_Cust_PN__c> MBBBList)
    {
        //a list of CSD_OEM_Mapping_Monthly_BBB__c that should be inserted finally
        List<CSD_OEM_Mapping_Monthly_BBB__c> CSDOEMMappingMonthlyBBBList = new List<CSD_OEM_Mapping_Monthly_BBB__c>();
        //get the priority of type from customer settings
        Map<String,Type_Priority__c> typePriortyMap = Type_Priority__c.getAll();
        
        //Declare three set to hold WWCORPACCT__c/Tech_SoldToAccountCode__c/Part__c
        Set<String> wwacCodeSet = new Set<String>();
        Set<String> soldToAccountCodeSet = new Set<String>();
        Set<String> partNumberSet = new Set<String>();
        
        System.debug('---------------MBBBList------------------'+MBBBList);
        
        //add value to wwacCodeSet/soldToAccountCodeSet/partNumberSet
        for(BBB_Month_Bill_Book_Cust_PN__c monthBillBookCustPN : MBBBList){
            if(monthBillBookCustPN.Customer__r.WWCORPACCT__c != null && monthBillBookCustPN.Customer__r.WWCORPACCT__c != ''){
                wwacCodeSet.add(monthBillBookCustPN.Customer__r.WWCORPACCT__c);
            }
            
            if(monthBillBookCustPN.Part__c != null){
                partNumberSet.add(monthBillBookCustPN.Part__c);
            }
            //because Customer__r.AccountNumber contains org code , so we need to get the SoldToAccountCode only
            if(monthBillBookCustPN.Customer__r.AccountNumber != null && monthBillBookCustPN.Customer__r.AccountNumber != ''){
                System.debug('-----------monthBillBookCustPN.Customer__r.AccountNumber---------------' + monthBillBookCustPN.Customer__r.AccountNumber);
                if(monthBillBookCustPN.Customer__r.AccountNumber.indexOf(':') > -1){
                    String[] accountCodeList = monthBillBookCustPN.Customer__r.AccountNumber.split(':');
                    soldToAccountCodeSet.add(accountCodeList[1]);
                }else{
                    soldToAccountCodeSet.add(monthBillBookCustPN.Customer__r.AccountNumber);
                }
            }
        }
        
        //select corresponding OEM_mapping_rule__c with wwacCodeSet/soldToAccountCodeSet/partNumberSet
        List<OEM_Mapping_Rule__c> OEMMappingRuleList = [select Id,OEM__c,Allocation__c,Part_Number__c,WWAC__c,Sold_To_Account_Code__c,Type__c,wwac_in_8__c
                                                         from OEM_Mapping_Rule__c 
                                                        where (Part_Number__c in: partNumberSet 
                                                        or wwac_in_8__c in: wwacCodeSet
                                                        or Sold_To_Account_Code_Add_0__c in: soldToAccountCodeSet)
                                                        and fiscal_month__c =: CurrentPeriodFMonth and fiscal_year__c =: CurrentPeriodFYear
                                                        and Active__c = true];
       System.debug('---------------------OEMMappingRuleList-------------------'+OEMMappingRuleList);
       //declare five list for type: wwac/Customer/PN/wwac+PN/Customer+PN
       List<OEM_Mapping_Rule__c> oemWwacList = new List<OEM_Mapping_Rule__c>();
       List<OEM_Mapping_Rule__c> oemCustomerList = new List<OEM_Mapping_Rule__c>();
       List<OEM_Mapping_Rule__c> oemPNList = new List<OEM_Mapping_Rule__c>();
       List<OEM_Mapping_Rule__c> oemWwacPNList = new List<OEM_Mapping_Rule__c>();
       List<OEM_Mapping_Rule__c> oemCustomerPNList = new List<OEM_Mapping_Rule__c>();
       
       //seperate OEMMappingRuleList into diferent map by type
       for(OEM_Mapping_Rule__c oemMappingRule : OEMMappingRuleList){
            String preType = '';//hold the old type before change to number
            preType = oemMappingRule.type__c;
            System.debug('------------preType-----------'+preType);
            //change type__c to number.for easy to compare.
            oemMappingRule.type__c = typePriortyMap.get(oemMappingRule.type__c).priority__c;
            System.debug('----------oemMappingRule.type__c------------'+oemMappingRule.type__c);
           //seperate OEM_Mapping_Rule__c to deferent list
           if(preType == 'WWAC'){
               oemWwacList.add(oemMappingRule);
           }else if(preType == 'Customer'){
               oemCustomerList.add(oemMappingRule);
           }else if(preType == 'PN'){
               oemPNList.add(oemMappingRule);
           }else if(preType == 'WWAC+PN'){
               oemWwacPNList.add(oemMappingRule);
           }else if(preType == 'Customer+PN'){
               oemCustomerPNList.add(oemMappingRule);
           }
       }
       
       for(BBB_Month_Bill_Book_Cust_PN__c monthBillBookCustPN : MBBBList){
           //because one BBB_Month_Bill_Book_Cust_PN__c can match more than one OEM_Mapping_Rule__c 
           //so we need to get all of the match records
           //loop the list of BBB_Month_Bill_Book_Cust_PN__c to find whether the record is match wwac/Customer/PN/wwac+PN/Customer+PN
           List<OEM_Mapping_Rule__c> oemMappingRuleTempList = new List<OEM_Mapping_Rule__c>();
           Map<Id,OEM_Mapping_Rule__c> oemMappingRuleTempMap = new Map<Id,OEM_Mapping_Rule__c>();//use this map to remove lower priority type
           System.debug('----------------monthBillBookCustPN.Id--------------------'+monthBillBookCustPN.Id);
           //wwac
           for(OEM_Mapping_Rule__c oemMappingRuleTemp : oemWwacList){
               //just use wwac number to check if match or not
               
               if(monthBillBookCustPN.Customer__r.WWCORPACCT__c == oemMappingRuleTemp.wwac_in_8__c){
                   oemMappingRuleTempList.add(oemMappingRuleTemp);
               }
           }
           
           //Customer
           for(OEM_Mapping_Rule__c oemMappingRuleTemp : oemCustomerList){
               //just use AccountNumber number to check if match or not
               //because Customer__r.AccountNumber contains org number. So we use indexOf() to check 
               //whether Customer__r.AccountNumber contains oemMappingRuleTemp.Sold_To_Account_Code__c or not
               
               if(monthBillBookCustPN.Customer__r.AccountNumber.indexOf(oemMappingRuleTemp.Sold_To_Account_Code__c) > -1){
                   oemMappingRuleTempList.add(oemMappingRuleTemp);
               }
           }
           
           //pn
           for(OEM_Mapping_Rule__c oemMappingRuleTemp : oemPNList){
               //just use pn number to check if match or not
               
               if(monthBillBookCustPN.Part__c == oemMappingRuleTemp.Part_Number__c){
                   oemMappingRuleTempList.add(oemMappingRuleTemp);
               }
           }
           
           //wwac+pn
           for(OEM_Mapping_Rule__c oemMappingRuleTemp : oemWwacPNList){
               //use wwac number and pn to check if match or not
               if(monthBillBookCustPN.Customer__r.WWCORPACCT__c == oemMappingRuleTemp.wwac_in_8__c && monthBillBookCustPN.Part__c == oemMappingRuleTemp.Part_Number__c){
                   oemMappingRuleTempList.add(oemMappingRuleTemp);
               }
           }
           
           //customer+pn
           for(OEM_Mapping_Rule__c oemMappingRuleTemp : oemCustomerPNList){
               //just use AccountNumber number and pn to check if match or not
               //because Customer__r.AccountNumber contains org number. So we use indexOf() to check 
               //whether Customer__r.AccountNumber contains oemMappingRuleTemp.Sold_To_Account_Code__c or not
               if(monthBillBookCustPN.Customer__r.AccountNumber.indexOf(oemMappingRuleTemp.Sold_To_Account_Code__c) > -1
                    && monthBillBookCustPN.Part__c == oemMappingRuleTemp.Part_Number__c
               ){
                   oemMappingRuleTempList.add(oemMappingRuleTemp);
               }
           }
           
           //now we have a list of OEM_Mapping_Rule__c that match the current BBB_Month_Bill_Book_Cust_PN__c
           //Then we should remove duplicate OEM__c and retain the highest priority type
           //one OEM__c should have only one record
           if(oemMappingRuleTempList.size() > 0){
               for(OEM_Mapping_Rule__c oemMappingRuleTemp : oemMappingRuleTempList){
                   OEM_Mapping_Rule__c oemMappingRuleTemp1 = new OEM_Mapping_Rule__c();//temp
                   if(oemMappingRuleTempMap.containskey(oemMappingRuleTemp.OEM__c)){
                       oemMappingRuleTemp1 = oemMappingRuleTempMap.get(oemMappingRuleTemp.OEM__c);
                       //compare the type priority
                       if(oemMappingRuleTemp.type__c > oemMappingRuleTemp1.type__c){
                           //if the type of oemMappingRuleTemp is bigger, then put oemMappingRuleTemp to the map
                           oemMappingRuleTempMap.put(oemMappingRuleTemp.OEM__c,oemMappingRuleTemp);
                       }
                   }else{
                       oemMappingRuleTempMap.put(oemMappingRuleTemp.OEM__c,oemMappingRuleTemp);
                   }
               }
               
               //sum allocation__c of oemMappingRuleTempMap.value, check total allocation__c is 100% or not
               //if not 100%, the rest should be "others"
               Double totalAllocation = 0.0;
               List<OEM_Mapping_Rule__c> oemMappingRuleTemp1List = new List<OEM_Mapping_Rule__c>();
               for(Id oem : oemMappingRuleTempMap.keySet()){
                   totalAllocation += oemMappingRuleTempMap.get(oem).Allocation__c;
                   
                   oemMappingRuleTemp1List.add(oemMappingRuleTempMap.get(oem));//if totalAllocation > 100, use this list to compare the type
               }
               
               if(totalAllocation > 100){
                   //more than 100, should check priority of type again, reserve the highest level type
                   Map<Double,OEM_Mapping_Rule__c> oemMappingRuleTemp1Map = new Map<Double,OEM_Mapping_Rule__c>();
                   for(OEM_Mapping_Rule__c oemMappingRuleTemp1 : oemMappingRuleTemp1List){
                       OEM_Mapping_Rule__c oemMappingRuleTemp2;//temp
                       if(oemMappingRuleTemp1Map.containskey(oemMappingRuleTemp1.Allocation__c)){
                           oemMappingRuleTemp2 = oemMappingRuleTemp1Map.get(oemMappingRuleTemp1.Allocation__c);
                           if(oemMappingRuleTemp1.type__c > oemMappingRuleTemp2.type__c){
                               oemMappingRuleTemp1Map.put(oemMappingRuleTemp1.Allocation__c,oemMappingRuleTemp1);
                           }
                       }else{
                           oemMappingRuleTemp1Map.put(oemMappingRuleTemp1.Allocation__c,oemMappingRuleTemp1);
                       }
                   }
                   
                   for(Double oemAllocation : oemMappingRuleTemp1Map.keySet()){
                       CSD_OEM_Mapping_Monthly_BBB__c monthlyBBB = new CSD_OEM_Mapping_Monthly_BBB__c();
                       monthlyBBB.OEM_Mapping__c = oemMappingRuleTemp1Map.get(oemAllocation).id;
                       monthlyBBB.Monthly_Billings_Bookings_by_Part__c = monthBillBookCustPN.Id;
                       CSDOEMMappingMonthlyBBBList.add(monthlyBBB);
                   }
               }else{
                   for(Id oem : oemMappingRuleTempMap.keySet()){
                       CSD_OEM_Mapping_Monthly_BBB__c monthlyBBB = new CSD_OEM_Mapping_Monthly_BBB__c();
                       monthlyBBB.OEM_Mapping__c = oemMappingRuleTempMap.get(oem).id;
                       monthlyBBB.Monthly_Billings_Bookings_by_Part__c = monthBillBookCustPN.Id;
                       CSDOEMMappingMonthlyBBBList.add(monthlyBBB);
                   }
               }
               
               if(totalAllocation < 100){
                   //add to others
                   CSD_OEM_Mapping_Monthly_BBB__c monthlyBBB = new CSD_OEM_Mapping_Monthly_BBB__c();
                   monthlyBBB.OEM_Mapping__c = othersOEMMappingRule.id;
                   monthlyBBB.Monthly_Billings_Bookings_by_Part__c = monthBillBookCustPN.Id;
                   //for others we should set Allocation_For_Others__c
                   monthlyBBB.Allocation_For_Others__c = 100 - totalAllocation;
                   CSDOEMMappingMonthlyBBBList.add(monthlyBBB);
               }
           }else{
               //this part should be "others"
               CSD_OEM_Mapping_Monthly_BBB__c monthlyBBB = new CSD_OEM_Mapping_Monthly_BBB__c();
               monthlyBBB.OEM_Mapping__c = othersOEMMappingRule.id;
               monthlyBBB.Monthly_Billings_Bookings_by_Part__c = monthBillBookCustPN.Id;
               //for others we should set Allocation_For_Others__c
               //because of no match OEM_Mapping__Rule__c, So the Allocation_For_Others__c should be 100
               monthlyBBB.Allocation_For_Others__c = 100;
               CSDOEMMappingMonthlyBBBList.add(monthlyBBB);
           }
           
       }
       
       if(CSDOEMMappingMonthlyBBBList.size() > 0){
           insert CSDOEMMappingMonthlyBBBList;
       }
       
    }
    
    global void finish(Database.BatchableContext BC)
    {                               
    }      
}