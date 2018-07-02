/**
*  This batch class to create capture result when yearly bb by part is inserted.
*  Please setting batch size 1;
*
@author Yimin Zheng
@created 2016-01-25
*
@changelog
coverage

2016-01-25 Yimin Zheng<yim in.zheng@te.com>
* - Created
*
*  @changelog
* 2016-4-14 Mingxing Qiu<mingxing.qiu@oinio.com>
* find match acctID ,partID  to create APL billing 
* - Created
*/
global class ClsBatch_captureBillingWhenbbInsert implements Database.Batchable<SObject>, Database.stateful {

  String queryStr;
    public set<String> isFinishCustomerPart {get;set;}

  global ClsBatch_captureBillingWhenbbInsert(){
    //queryStr = 'select id,Customer__c,Part__c from BBB_Year_Bill_Book_Cust_PN__c where Customer__c=\'001E000000BzQVYIA3\' and Part__c =\'a0HE0000003PTuAMAW\' and APL_need_to_capture_billing__c = true';
    queryStr = 'select Id ,Customer__c ,Part__c from BBB_Year_Bill_Book_Cust_PN__c where APL_need_to_capture_billing__c = true ';
    this.isFinishCustomerPart = new set<String>();
  }

    global Database.QueryLocator start(Database.BatchableContext BC){
    system.debug('!@# queryStr:'+queryStr);
    return database.getQueryLocator(queryStr);
  }
     
  global void execute(Database.BatchableContext BC, list<BBB_Year_Bill_Book_Cust_PN__c> arlist){
      Set<Id> accIdSet = new Set<Id>();
      Set<Id> partIdSet = new Set<Id>();
      List<BBB_Year_Bill_Book_Cust_PN__c> yearlyBBToUpdateList = new List<BBB_Year_Bill_Book_Cust_PN__c>();
      Map<String,List<BBB_Year_Bill_Book_Cust_PN__c>> yearlyBBListMap = new Map<String,List<BBB_Year_Bill_Book_Cust_PN__c>>();
      
      list<BBB_Year_Bill_Book_Cust_PN__c> yearlyBBList = new list<BBB_Year_Bill_Book_Cust_PN__c>();
      system.debug('!@# arlist:'+arlist);
      set<String> set_yearlyBBCustomer = new set<String>();
      set<String> set_yearlyBBPart = new set<String>();
      for(BBB_Year_Bill_Book_Cust_PN__c yearlyBB : arlist) {
      if(this.isFinishCustomerPart.contains(yearlyBB.Customer__c+';'+yearlyBB.Part__c)) {
          continue;
        }
        this.isFinishCustomerPart.add(yearlyBB.Customer__c+';'+yearlyBB.Part__c);
        if(!set_yearlyBBCustomer.contains(yearlyBB.Customer__c)) {
          set_yearlyBBCustomer.add(yearlyBB.Customer__c);
        }
        if(!set_yearlyBBPart.contains(yearlyBB.Part__c)) {
          set_yearlyBBPart.add(yearlyBB.Part__c);
        }
      } 
      
      
      for(BBB_Year_Bill_Book_Cust_PN__c yearbb : [select id,Customer__c,Part__c,APL_need_to_capture_billing__c 
                                from BBB_Year_Bill_Book_Cust_PN__c 
                                where Customer__c IN :set_yearlyBBCustomer 
                                  and Part__c IN :set_yearlyBBPart 
                                  and APL_need_to_capture_billing__c = true]) {
      yearlyBBList.add(yearbb);
    }
      
      
      system.debug('!@# yearlyBBList:'+yearlyBBList);
      for(BBB_Year_Bill_Book_Cust_PN__c yearlyBB : yearlyBBList){

      accIdSet.add(yearlyBB.Customer__c);
      partIdSet.add(yearlyBB.Part__c);
      yearlyBB.APL_need_to_capture_billing__c = false;
      yearlyBBToUpdateList.add(yearlyBB);
      
      if(yearlyBBListMap.get(yearlyBB.Customer__c+';'+yearlyBB.Part__c) == null){
        List<BBB_Year_Bill_Book_Cust_PN__c> tmpList = new List<BBB_Year_Bill_Book_Cust_PN__c>();
        tmpList.add(yearlyBB);
        yearlyBBListMap.put(yearlyBB.Customer__c+';'+yearlyBB.Part__c,tmpList);
      }else{
            yearlyBBListMap.get(yearlyBB.Customer__c+';'+yearlyBB.Part__c).add(yearlyBB);
      }
      }
      list<APL_Billing_Result_of_Covnerted_Opp__c> list_upinsertAPL_billing = new list<APL_Billing_Result_of_Covnerted_Opp__c>();
      if(accIdSet.size() > 0 && partIdSet.size() > 0) {
        //find APL billing accountId , partId and opportunityId group and create the APL billing  
        for(AggregateResult result : [select Opportunity_Partner__c acc, part__c part, opportunity__c oppy
                        from APL_Billing_Result_of_Covnerted_Opp__c 
                        where Opportunity_Partner__c IN :accIdSet and part__c IN :partIdSet
                        group by Opportunity_Partner__c, part__c, opportunity__c] ) {
          String acc = String.valueOf(result.get('acc'));
          String part = String.valueOf(result.get('part'));
          String oppy = String.valueOf(result.get('oppy'));
          
          if(yearlyBBListMap.containsKey(acc+';'+part)) {
            for(BBB_Year_Bill_Book_Cust_PN__c yearlyBBC : yearlyBBListMap.get(acc+';'+part)) {
              APL_Billing_Result_of_Covnerted_Opp__c APL_billing_new = new APL_Billing_Result_of_Covnerted_Opp__c();
                  APL_billing_new.opportunity__c = oppy;
                  APL_billing_new.Opportunity_Partner__c = acc;
                  APL_billing_new.part__c = part;
                  APL_billing_new.Yearly_Booking_Billings_By_Part__c = yearlyBBC.Id;
                  list_upinsertAPL_billing.add(APL_billing_new);
            }
          }
        }
        /*
        for(APL_Billing_Result_of_Covnerted_Opp__c apl_Billing : [select id,Opportunity_Partner__c, part__c, Yearly_Booking_Billings_By_Part__c,opportunity__c 
                                    from APL_Billing_Result_of_Covnerted_Opp__c where Opportunity_Partner__c IN :accIdSet and part__c IN :partIdSet]) { 
        
        if(yearlyBBListMap.containsKey(apl_Billing.Opportunity_Partner__c+';'+apl_Billing.Part__c)) {
          //If current apl_Billing's Yearly_BBB is null and yearlyBBListMap contains accountId , partId, only one yearlyBB. We only updata apl_Billing
            if(apl_Billing.Yearly_Booking_Billings_By_Part__c == NULL  && 
               yearlyBBListMap.get(apl_Billing.Opportunity_Partner__c+';'+apl_Billing.Part__c).size() == 1) {
                   apl_Billing.Yearly_Booking_Billings_By_Part__c = yearlyBBListMap.get(apl_Billing.Opportunity_Partner__c+';'+apl_Billing.Part__c)[0].Id;
                list_upinsertAPL_billing.add(apl_Billing);   
            }else {
              for(BBB_Year_Bill_Book_Cust_PN__c yearlyBBC : yearlyBBListMap.get(apl_Billing.Opportunity_Partner__c+';'+apl_Billing.Part__c)) {
                APL_Billing_Result_of_Covnerted_Opp__c APL_billing_new = new APL_Billing_Result_of_Covnerted_Opp__c();
                    APL_billing_new.opportunity__c = apl_Billing.opportunity__c;
                    APL_billing_new.Opportunity_Partner__c = apl_Billing.Opportunity_Partner__c;
                    APL_billing_new.part__c = apl_Billing.part__c;
                    APL_billing_new.Yearly_Booking_Billings_By_Part__c = yearlyBBC.Id;
                    list_upinsertAPL_billing.add(APL_billing_new);
              }
            }
          }  
        }*/
      }

   /* //query the Appliances Opportunity
    List<Opportunity> oppList = [select Id
      ,(select Id,Account__c from Opportunity_Partners__r where Account__c in: accIdSet) 
      ,(select Id,part__c from Parts__r where part__c in: partIdSet)
      from Opportunity where 
      Id in (select Opportunity__c from Opportunity_Partner__c where Account__c in: accIdSet)
      and isAPLOpp__c = true
    ];
    
    //change to map
    Map<String,Set<Id>> oppIdSetMap = new Map<String,Set<Id>>();
    for(Opportunity opp : oppList){
      List<Opportunity_Partner__c> partnerList = opp.Opportunity_Partners__r;
      List<Opportunity_part__c> partList = opp.Parts__r;
      
      for(Opportunity_Partner__c partner : partnerList){
        for(Opportunity_part__c part : partList){
          if(oppIdSetMap.get(partner.Account__c+';'+part.part__c) == null){
            Set<Id> tmpList = new Set<Id>();
            tmpList.add(opp.Id);
            oppIdSetMap.put(partner.Account__c+';'+part.part__c,tmpList);
          }else{
            oppIdSetMap.get(partner.Account__c+';'+part.part__c).add(opp.Id);
          }
        }
      }
    }
    
    List<APL_Billing_Result_of_Covnerted_Opp__c> convertList = new List<APL_Billing_Result_of_Covnerted_Opp__c>();
    
    for(String key : yearlyBBListMap.keySet()){
      List<BBB_Year_Bill_Book_Cust_PN__c> yearlyBBTMPList = yearlyBBListMap.get(key);
      String[] keySplit = key.split(';');
      for(BBB_Year_Bill_Book_Cust_PN__c yearlyBB : yearlyBBTMPList){
        Set<Id> oppIdSet = oppIdSetMap.get(key);
        if(oppIdSet != null){
          for(Id oppId : oppIdSet){
            System.debug('----2  -----');
            APL_Billing_Result_of_Covnerted_Opp__c convert = new APL_Billing_Result_of_Covnerted_Opp__c();
            convert.opportunity__c = oppId;
            convert.Opportunity_Partner__c = keySplit[0];
            convert.part__c = keySplit[1];
            convert.Yearly_Booking_Billings_By_Part__c = yearlyBB.Id;
            convertList.add(convert);
          }
        }
      }
    }
    */
    if(list_upinsertAPL_billing.size() > 0) {
        upsert list_upinsertAPL_billing;
      }
    //if(convertList.size() > 0) {
    //  insert convertList;
    //}
    if(yearlyBBToUpdateList.size() > 0) {
         update yearlyBBToUpdateList;
    }
    
  }
  
  global void finish(Database.BatchableContext BC){ 
        
    }
  
}