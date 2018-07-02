/** 
*    Controller for ExtBudgetPlanning page
*ƒ
@author Xia Tong
@created 2013-04-25
@version 1.0
@since 23.0 (Force.com ApiVersion)
*
@changelog
* 2013-04-25 Xia Tong <xia.tong@itbconsult.com>
* - Created
*/

public class ClsBudgetPlanBreakDownUtil { 
    public static final String BUDGETQUERYFIELDS = 'Id, OwnerId, Name, Manager__c, CurrencyIsoCode, Stage__c, Year__c, Territory__c, Territory__r.Level_7_Territory_Code__c, Status__c, Original_Direct_Budget__c, Original_POS_Budget__c, Original_CMA_Budget__c, Final_Direct_Budget__c, Final_POS_Budget__c, Final_CMA_Budget__c, Final_Total_Budget__c, Original_Total_Budget__c, FQ1_Direct__c, FQ1_POS__c, FQ1_CMA__c, FQ2_Direct__c, FQ2_POS__c, FQ2_CMA__c, FQ3_Direct__c, FQ3_POS__c, FQ3_CMA__c, FQ4_Direct__c, FQ4_POS__c, FQ4_CMA__c, FQ4_Total__c, FQ3_Total__c, FQ2_Total__c,FQ1_Total__c, Final_Total_Budget_TBR_NY__c, Original_Total_Budget_TBR_NY__c, Manager_Total_Budget__c, Total_Direct_Budget_TBR_NY__c, Total_CMA_Budget_TBR_NY__c, Total_POS_Budget_TBR_NY__c, Total_Budget_TBR_NY__c, Level_6_Assigned_User_Network_Id__c, Manager_Final_Budget__c';
    public static Map<String, Map<String, Map<String, Date>>> map_fiscalYear_fiscalMonth_SEDate;
    public static final map<String, Integer> MAP_MONTHLABELNUMBER = new map<String, Integer>{
        'Jan' => 4,
        'Feb' => 5,
        'Mar' => 6,
        'Apr' => 7,
        'May' => 8,
        'Jun' => 9,
        'Jul' => 10,
        'Aug' => 11,
        'Sep' => 12,
        'Oct' => 1,
        'Nov' => 2,
        'Dec' => 3
    };
    public static final map<Decimal, String> MAP_NUMBERMONTHLABEL = new map<Decimal, String>{
        1 => 'Jan',
        2 => 'Feb',
        3 => 'Mar',
        4 => 'Apr',
        5 => 'May',
        6 => 'Jun',
        7 => 'Jul',
        8 => 'Aug',
        9 => 'Sep',
        10 => 'Oct',
        11 => 'Nov',
        12 => 'Dec'
    };
    private static map<string, id> map_type_filterId; 
    /**
    * This method is used to get budget planning by id
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param      budget id
    *
    @return     budget by budget id      
    * 
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public static Budget__c getBudgetPlanById(Id bid){
        Budget__c budget = new Budget__c();
        String q = 'Select '+ BUDGETQUERYFIELDS + '  from Budget__c where Id = :bid';
        for(Budget__c b : database.query(q)){
            budget = b;
        }
        return budget;
    }
    /**
    * This method is used to get budget planning by id
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param      budget id
    *
    @return     budget by budget id      
    * 
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    //Added by Bin Yuan 2013-10-17 due to territory changed bug
    //public static void BuildBreakDownStructures(Id budgetId, List<ClsBudgetPlanBreakDownStructure>list_budgetPlanStructure, ClsBudgetPlanBreakDownStructure otherBudgetPlanStructure,map<String, ClsBudgetPlanBreakDownStructure> map_accId_budgetPlanStructures,map<String, Id> map_budgetDetail_recordTypeId, list<Budget_Detail__c> list_budgetDetail,set<Id> set_accId,map<Id,map<string,Budget_Detail__c>> map_accId_type_bd){
    public static void BuildBreakDownStructures(Id budgetId, String str_territory, List<ClsBudgetPlanBreakDownStructure>list_budgetPlanStructure, ClsBudgetPlanBreakDownStructure otherBudgetPlanStructure,map<String, ClsBudgetPlanBreakDownStructure> map_accId_budgetPlanStructures,map<String, Id> map_budgetDetail_recordTypeId, list<Budget_Detail__c> list_budgetDetail,set<Id> set_accId,map<Id,map<string,Budget_Detail__c>> map_accId_type_bd){
        //for(Budget_Detail__c bd: [select id, Budget_TBR_NY__c,Budget_Document_Currency__c,Account__c,Account__r.CurrencyIsoCode,Account__r.BillingCity,Account__r.Name,Account__r.AccountNumber, Account__r.Account_Combined_Data__c, Parent_Account__c, Parent_Account__r.Account_Combined_Data__c, Parent_Account__r.CurrencyIsoCode,Parent_Account__r.Name,Parent_Account__r.BillingCity,Parent_Account__r.AccountNumber,recordType.DeveloperName,recordTypeId,Type__c, Billings_LY__c, Billings_CYTD__c, Billings_CYRR__c, Backlog__c, Forecast_CY__c, Obsoletion_EOL__c, Transfer_Out__c, Transfer_In__c, TAM_DTAM__c, Run_Rate_Business__c, Market_Growth__c, Price_Change__c, Price_Increase__c, Adjusted_Business__c, Opportunities_Won__c, Opportunities_Likely__c, Opportunities50_50__c, Opportunities_Pipeline__c, Calculated_Budget__c, Adjustment__c, Total_Budget__c, Opportunities_Weak__c, Opportunities_Commit__c, Comments__c, Manager_Total_Budget__c, Manager_Final_Budget__c from Budget_Detail__c where Budget__c =: budgetId]){
        for(Budget_Detail__c bd: [select id, Budget_TBR_NY__c,Budget_Document_Currency__c,Account__c,Account__r.CurrencyIsoCode,Account__r.BillingCity,Account__r.Name,Account__r.AccountNumber, Account__r.Account_Combined_Data__c, Parent_Account__c, Parent_Account__r.Account_Combined_Data__c, Parent_Account__r.CurrencyIsoCode,Parent_Account__r.Name,Parent_Account__r.BillingCity,Parent_Account__r.AccountNumber,recordType.DeveloperName,recordTypeId,Type__c, Billings_LY__c, Billings_CYTD__c, Billings_CYRR__c, Backlog__c, Forecast_CY__c, Obsoletion_EOL__c, Transfer_Out__c, Transfer_In__c, TAM_DTAM__c, Run_Rate_Business__c, Market_Growth__c, Price_Change__c, Price_Increase__c, Adjusted_Business__c, Opportunities_Won__c, Opportunities_Likely__c, Opportunities50_50__c, Opportunities_Pipeline__c, Calculated_Budget__c, Adjustment__c, Total_Budget__c, Opportunities_Weak__c, Opportunities_Commit__c, Comments__c, Manager_Total_Budget__c, Manager_Final_Budget__c from Budget_Detail__c where Budget__c =: budgetId And Account_Territory_Code__c =: str_territory]){
    //End
            if(bd.Account__c != null && !map_accId_type_bd.containsKey(bd.Account__c)){
                map_accId_type_bd.put(bd.Account__c,new map<string,Budget_Detail__c>());
            }
            map_accId_type_bd.get(bd.Account__c).put(bd.Type__c,bd);
            list_budgetDetail.add(bd);
            if(bd.recordType.DeveloperName == 'Account' ){
                if(bd.Parent_Account__c != null){
                    set_accId.add(bd.Parent_Account__c);
                    if(!map_accId_budgetPlanStructures.containsKey(bd.Parent_Account__c)){
                
                        ClsBudgetPlanBreakDownStructure budgetPlanStructure = new ClsBudgetPlanBreakDownStructure(bd.recordTypeId, bd.Parent_Account__c);
                        ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem parentItem;
                        
                        budgetPlanStructure.accountId = bd.Parent_Account__c;
                        budgetPlanStructure.accountName = bd.Parent_Account__r.Name;
                        budgetPlanStructure.accountInfo = bd.Parent_Account__r.Account_Combined_Data__c;
                        parentItem  = new ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem(bd.Parent_Account__c, budgetPlanStructure.accountInfo, bd.Parent_Account__r.CurrencyIsoCode); 
                        budgetPlanStructure.parentAccountItem = parentItem;
                        list_budgetPlanStructure.add(budgetPlanStructure);
                        map_accId_budgetPlanStructures.put(bd.Parent_Account__c, budgetPlanStructure);
                    }
                    if(bd.Account__c != null){
                        set_accId.add(bd.Account__c);
                        ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem childItem;
                        if(map_accId_budgetPlanStructures.get(bd.Parent_Account__c).set_childIds.contains(bd.Account__c)){
                            childItem = map_accId_budgetPlanStructures.get(bd.Parent_Account__c).accountBillingMonthlyItems.get(bd.Account__c);
                            
                        }else{
                            String accInfo = bd.Account__r.Account_Combined_Data__c;
                            map_accId_budgetPlanStructures.get(bd.Parent_Account__c).set_childIds.add(bd.Account__c);             
                            childItem = new ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem(bd.Account__c, accInfo, bd.Account__r.CurrencyIsoCode);   
                            map_accId_budgetPlanStructures.get(bd.Parent_Account__c).accountBillingMonthlyItems.put(bd.Account__c,childItem);
                        }
                        if(bd.Type__c == 'Direct') childItem.BudgetDetail4Direct = bd;
                        else if(bd.Type__c == 'POS') childItem.BudgetDetail4POS = bd;
                        else if(bd.Type__c == 'CMA') childItem.BudgetDetail4CMA = bd;
                    }
                }
                
                if(bd.Parent_Account__c == null && bd.Account__c != null){
                    set_accId.add(bd.Account__c);
                    if(!map_accId_budgetPlanStructures.containsKey(bd.Account__c)){
            
                        ClsBudgetPlanBreakDownStructure budgetPlanStructure = new ClsBudgetPlanBreakDownStructure(bd.recordTypeId, bd.Account__c);
                        ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem parentItem;
                        
                        budgetPlanStructure.accountId = bd.Account__c;
                        budgetPlanStructure.accountName = bd.Account__r.Name;
                        budgetPlanStructure.accountInfo = bd.Account__r.Account_Combined_Data__c;
                        parentItem  = new ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem(bd.Account__c, budgetPlanStructure.accountInfo, bd.Account__r.CurrencyIsoCode); 
                        budgetPlanStructure.parentAccountItem = parentItem;
                        list_budgetPlanStructure.add(budgetPlanStructure);
                        map_accId_budgetPlanStructures.put(bd.Account__c, budgetPlanStructure);
                    }
                    if(bd.Type__c == 'Direct') map_accId_budgetPlanStructures.get(bd.Account__c).parentAccountItem.BudgetDetail4Direct = bd;
                    else if(bd.Type__c == 'POS') map_accId_budgetPlanStructures.get(bd.Account__c).parentAccountItem.BudgetDetail4POS = bd;
                    else if(bd.Type__c == 'CMA') map_accId_budgetPlanStructures.get(bd.Account__c).parentAccountItem.BudgetDetail4CMA = bd;
                }
            }
            
            else if(bd.recordType.DeveloperName == 'Other'){
                if(bd.Account__c == null){
                    otherBudgetPlanStructure.parentAccountItem = new ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem(null, null, null); 
                    if(bd.Type__c == 'Direct') otherBudgetPlanStructure.parentAccountItem.BudgetDetail4Direct = bd;
                    else if(bd.Type__c == 'POS') otherBudgetPlanStructure.parentAccountItem.BudgetDetail4POS = bd;
                    else if(bd.Type__c == 'CMA') otherBudgetPlanStructure.parentAccountItem.BudgetDetail4CMA = bd;  
                }   
                else if(bd.Account__c != null && bd.Parent_Account__c == null){
                    set_accId.add(bd.Account__c);
                    String accInfo = bd.Account__r.Account_Combined_Data__c;
                    
                    ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem childItem;
                    if(otherBudgetPlanStructure.set_childIds.contains(bd.Account__c)){
                        childItem = otherBudgetPlanStructure.accountBillingMonthlyItems.get(bd.Account__c); 
                    }else{
                        childItem = new ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem(bd.Account__c, accInfo, bd.Account__r.CurrencyIsoCode); 
                    }
                    otherBudgetPlanStructure.set_childIds.add(bd.Account__c);
                                 
                    if(bd.Type__c == 'Direct') childItem.BudgetDetail4Direct = bd;
                    else if(bd.Type__c == 'POS') childItem.BudgetDetail4POS = bd;
                    else if(bd.Type__c == 'CMA') childItem.BudgetDetail4CMA = bd;
                    
                    otherBudgetPlanStructure.accountBillingMonthlyItems.put(bd.Account__c,childItem);
                }   
            }
        }
    }
    /**
    * The method is used to calculate all formula values and total values in the budget structure
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return             
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public static void calAllValues(List<ClsBudgetPlanBreakDownStructure> list_budgetPlanStructure){
        // calculate all formula values and total values here
        for(ClsBudgetPlanBreakDownStructure budgetPlanStructure: list_budgetPlanStructure){
            
            // calculate total budget detail
            List<Budget_Detail__c> list_budgetDetails = new List<Budget_Detail__c>();
            if(budgetPlanStructure.parentAccountItem != null){
            list_budgetDetails.add(budgetPlanStructure.parentAccountItem.BudgetDetail4Direct);
            list_budgetDetails.add(budgetPlanStructure.parentAccountItem.BudgetDetail4POS);
            list_budgetDetails.add(budgetPlanStructure.parentAccountItem.BudgetDetail4CMA);
            //calcAccountItemValues(budgetPlanStructure.parentAccountItem, list_budgetDetails);
            }
            
            
            for(ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem childItem: budgetPlanStructure.accountBillingMonthlyItems.values() ){
                
                list_budgetDetails.add(childItem.BudgetDetail4Direct);
                list_budgetDetails.add(childItem.BudgetDetail4POS);
                list_budgetDetails.add(childItem.BudgetDetail4CMA);
            }
            
            calTotalBudgetDetail(list_budgetDetails,budgetPlanStructure);
        }
        
    }


    
    
    /**
    * The method is used to calculate the total budget detail values
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return             
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public static void calTotalBudgetDetail(List<Budget_Detail__c> list_budgetDetails,ClsBudgetPlanBreakDownStructure structure){
        //system.debug('tongxia accouninfo:' + structure.accountInfo);
        initDetailValues(structure.BudgetDetail4Total);
           
        for(Budget_Detail__c detail: list_budgetDetails){
            if(detail.Billings_LY__c != null){
                structure.BudgetDetail4Total.Billings_LY__c =
                    structure.BudgetDetail4Total.Billings_LY__c==null?detail.Billings_LY__c:detail.Billings_LY__c+structure.BudgetDetail4Total.Billings_LY__c;
            }
            if(detail.Billings_CYTD__c != null){
                structure.BudgetDetail4Total.Billings_CYTD__c =
                    structure.BudgetDetail4Total.Billings_CYTD__c==null?detail.Billings_CYTD__c:detail.Billings_CYTD__c+structure.BudgetDetail4Total.Billings_CYTD__c;
            }
            if(detail.Billings_CYRR__c != null){
                structure.BudgetDetail4Total.Billings_CYRR__c =
                    structure.BudgetDetail4Total.Billings_CYRR__c==null?detail.Billings_CYRR__c:detail.Billings_CYRR__c+structure.BudgetDetail4Total.Billings_CYRR__c;
            }
         
            if(detail.Forecast_CY__c != null){              
                structure.BudgetDetail4Total.Forecast_CY__c =
                    structure.BudgetDetail4Total.Forecast_CY__c==null?detail.Forecast_CY__c:detail.Forecast_CY__c+structure.BudgetDetail4Total.Forecast_CY__c;
            }
            if(detail.Total_Budget__c != null){
                if(detail.Type__c == 'Direct'){
                    //system.debug('55555555555555555555555555555:'+detail.Total_Budget__c);
                    structure.TotalBudget4Direct = structure.TotalBudget4Direct + detail.Total_Budget__c;
                
                }else if(detail.Type__c == 'POS'){
                    //system.debug('66666666666666666666666666666:'+detail.Total_Budget__c);
                    structure.TotalBudget4POS = structure.TotalBudget4POS + detail.Total_Budget__c;
                }else if(detail.Type__c == 'CMA'){
                    structure.TotalBudget4CMA = structure.TotalBudget4CMA + detail.Total_Budget__c;
                }
            }
                       
        }
        //system.debug('777777777777777777777777777:'+structure.TotalBudget4POS);
        
        
        structure.TotalBudget4Total = (structure.TotalBudget4Direct + structure.TotalBudget4POS + structure.TotalBudget4CMA).setScale(0);
        structure.TotalBudget4Direct = structure.TotalBudget4Direct.setScale(0);
        structure.TotalBudget4POS = structure.TotalBudget4POS.setScale(0);
        structure.TotalBudget4CMA = structure.TotalBudget4CMA.setScale(0);
        
    }
    

        /**
    * The method is used to intialize the value in the total budget detail
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param     budget detail          
    *
    @return             
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public static void initDetailValues(Budget_Detail__c detail){
        detail.Billings_LY__c = 0;
        detail.Billings_CYTD__c = 0;
        detail.Billings_CYRR__c = 0;
        detail.Forecast_CY__c = 0;
        
    }
    
    public static void calcAccountItemValues(ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem item,List<Budget_Detail__c> details){
        //system.debug('tongxia item.accountInfo :' + item.accountInfo );
        item.BillingsLY = 0;
        item.BillingsCY = 0;
        item.BillingsCYRR = 0;
        item.ForecastCY = 0;
        item.TotalBudget4Direct = 0;
        item.TotalBudget4POS = 0;
        item.TotalBudget4CMA = 0;
        item.TotalBudget4Total = 0;
        
        for(Budget_Detail__c detail:details){
            if(detail.Billings_LY__c != null){
               item.BillingsLY += detail.Billings_LY__c;
            }
            if(detail.Billings_CYTD__c != null){
                item.BillingsCY += detail.Billings_CYTD__c;
            }
            if(detail.Billings_CYRR__c != null){
                item.BillingsCYRR += detail.Billings_CYRR__c;
            }
         
            if(detail.Forecast_CY__c != null){              
                item.ForecastCY += detail.Forecast_CY__c;
            }
            
        }

        item.TotalBudget4Direct = item.BudgetDetail4Direct.Total_Budget__c == null ? 0:item.BudgetDetail4Direct.Total_Budget__c;
        item.TotalBudget4POS = item.BudgetDetail4POS.Total_Budget__c == null ? 0:item.BudgetDetail4POS.Total_Budget__c;
        item.TotalBudget4CMA = item.BudgetDetail4CMA.Total_Budget__c == null ? 0:item.BudgetDetail4CMA.Total_Budget__c;

        item.TotalBudget4Total = (item.TotalBudget4Direct + item.TotalBudget4POS + item.TotalBudget4CMA).setScale(0);
        item.TotalBudget4Direct = item.TotalBudget4Direct.setScale(0);
        
        item.TotalBudget4POS = item.TotalBudget4POS.setScale(0);
        item.TotalBudget4CMA = item.TotalBudget4CMA.setScale(0);
        item.BillingsLY = item.BillingsLY.setScale(0);
        item.BillingsCY = item.BillingsCY.setScale(0);
        item.BillingsCYRR = item.BillingsCYRR.setScale(0);
        item.ForecastCY = item.ForecastCY.setScale(0);
    }
        /**
    * This method is used to build billing monthly record
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param      map of billing type and month and billing monthly record, billing type, account id, budget record, total value, month rate, month, map of year and rate, isoCode
    *
    @return     billing monthly record   
    * 
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public static list<BBB_Month_Bill_Book_Cust__c> refreshBBBMonthlyRecord(map<Integer, map<string,BBB_Month_Bill_Book_Cust__c>> map_BBBMonthly, Id accId, Budget__c budget, Map<String, Map<Integer, Decimal>> map_billType_monthRate, Decimal FCMonthRate, Integer month, map<String,Decimal> map_type_Rate, ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem parentItem,map<string,Budget_Detail__c> map_type_bd){       
        BBB_Month_Bill_Book_Cust__c bbbMDirect;
        BBB_Month_Bill_Book_Cust__c bbbMCMA;
        BBB_Month_Bill_Book_Cust__c bbbMPOS;
        map<string,Id> map_filter = getFilterMap();
        map<string,BBB_Month_Bill_Book_Cust__c> map_type_bbbM = new map<string,BBB_Month_Bill_Book_Cust__c>();
        Decimal rate = 1;
        Decimal standard = 1;
        map_type_bbbM.put('Direct', null);
        map_type_bbbM.put('CMA', null);
        map_type_bbbM.put('POS', null);
        //START edit by Yuda <yuda.zheng@itbconsult.com> 2013-09-15
        //if(parentItem.accountIsoCode != 'USD'){
            //String ly = String.valueOf(Integer.valueOf(budget.Year__c) - 1);
            if(map_type_Rate.containsKey('Rate')) rate = map_type_Rate.get('Rate');
            if(map_type_Rate.containsKey('Standard')) standard = map_type_Rate.get('Standard'); 
        //}
        //END edit by Yuda <yuda.zheng@itbconsult.com> 2013-09-15
        if(map_BBBMonthly.size() > 0){
            if(map_BBBMonthly.containsKey(month)){
                for(string key: map_type_bbbM.keyset()){
                    if(map_BBBMonthly.get(month).containsKey(key)){
                        map_type_bbbM.put(key,map_BBBMonthly.get(month).get(key));
                    }       
                }  
            }       
        }
        String year = budget.Year__c; 
        for(string key: map_type_bbbM.keyset()){
            BBB_Month_Bill_Book_Cust__c bbbM = map_type_bbbM.get(key);
            if(bbbM == null){
                bbbM  = new BBB_Month_Bill_Book_Cust__c();
                bbbM = new BBB_Month_Bill_Book_Cust__c();
                bbbM.Customer__c = accId;
                bbbM.Fiscal_Year__c = year;
                bbbM.Fiscal_Month__c = month;
                bbbM.Bill_Type__c = key;   
                bbbM.CurrencyIsoCode = parentItem.accountIsoCode;
                
                map_type_bbbM.put(key,bbbM);
            }   
            bbbM.Sales_Period__c = salesPeriodDate(year, month);
            Budget_Detail__c bd = map_type_bd.get(key);
            if(key == 'Direct'){
                //bbbM.Budget_Direct_Disp__c = parentItem.TotalBudget4Direct * map_billType_monthRate.get('Direct').get(month); 
                bbbM.Budget__c = parentItem.TotalBudget4Direct * map_billType_monthRate.get('Direct').get(month); 
                bbbM.Forecast_Disp__c = calcItemFCY(parentItem.TotalBudget4Direct, parentItem.TotalBudget4Total,parentItem.ForecastCY * FCMonthRate);
                //budget.Total_Direct_Budget_TBR_NY__c += bbbM.Budget_Direct_Disp__c * rate;                
            }else if(key == 'POS'){
                //bbbM.Budget_POS_Disp__c = parentItem.TotalBudget4POS * map_billType_monthRate.get('POS').get(month);
                bbbM.Budget__c = parentItem.TotalBudget4POS * map_billType_monthRate.get('POS').get(month);
                bbbM.Forecast_Disp__c = calcItemFCY(parentItem.TotalBudget4POS, parentItem.TotalBudget4Total,parentItem.ForecastCY * FCMonthRate); 
                //budget.Total_POS_Budget_TBR_NY__c += bbbM.Budget_POS_Disp__c * rate;
            }else if(key == 'CMA'){
                //bbbM.Budget_CMA_Disp__c = parentItem.TotalBudget4CMA * map_billType_monthRate.get('CMA').get(month);
                bbbM.Budget__c = parentItem.TotalBudget4CMA * map_billType_monthRate.get('CMA').get(month);
                bbbM.Forecast_Disp__c = calcItemFCY(parentItem.TotalBudget4CMA, parentItem.TotalBudget4Total,parentItem.ForecastCY * FCMonthRate);
                //budget.Total_CMA_Budget_TBR_NY__c += bbbM.Budget_CMA_Disp__c * rate;
            }
            
            if(!test.isRunningTest() && bbbM.Budget__c != null){
                bbbM.Budget_TBR_NY__c = bbbM.Budget__c * rate;
                bbbM.Budget_Document_Currency__c = bbbM.Budget__c * standard;
            }
            else{
                bbbM.Budget_TBR_NY__c = 0;
                bbbM.Budget_Document_Currency__c = 0;
            }
            //budget.Total_Budget_TBR_NY__c += bbbM.Budget_TBR_NY__c;
            if(bd != null){
                if(bbbM.Budget_TBR_NY__c != null) bd.Budget_TBR_NY__c += bbbM.Budget_TBR_NY__c;
                if(bbbM.Budget_Document_Currency__c != null)  bd.Budget_Document_Currency__c += bbbM.Budget_Document_Currency__c;
            }
            if(map_filter.containsKey(key)){
                bbbM.Bill_Type_Filter__c = map_filter.get(key);
            }
            
        }      
        
        return map_type_bbbM.values();
    }
    
    public static void calcBudgetDetailToSave(ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem item){
        //calc total
        item.TotalBudget4Total = item.TotalBudget4Direct + item.TotalBudget4CMA + item.TotalBudget4POS;
        /*
        item.BudgetDetail4Direct.Forecast_CY__c = calcItemFCY(item.TotalBudget4Direct,item.TotalBudget4Total,item.ForecastCY);
        item.BudgetDetail4CMA.Forecast_CY__c = calcItemFCY(item.TotalBudget4CMA, item.TotalBudget4Total, item.ForecastCY);
        item.BudgetDetail4POS.Forecast_CY__c = calcItemFCY(item.TotalBudget4POS, item.TotalBudget4Total,item.ForecastCY);
        */
        // calc adjustment
        item.BudgetDetail4Direct.Adjustment__c = calAdjustmentValue(item.BudgetDetail4Direct,item.TotalBudget4Direct);
        item.BudgetDetail4CMA.Adjustment__c = calAdjustmentValue(item.BudgetDetail4CMA,item.TotalBudget4CMA);
        item.BudgetDetail4POS.Adjustment__c = calAdjustmentValue(item.BudgetDetail4POS,item.TotalBudget4POS);
        
    }
    
    public static Decimal calcItemFCY(Decimal typeTotal, Decimal total, Decimal FCYTotal){
        
        if(total != null && total != 0){
            return typeTotal/total * FCYTotal;
        }else{
            return 0;
        }
    }
    
    public static Decimal calRunRateBusiValue(Budget_Detail__c detail){
        // run rate business
        Decimal runRateBusiValue = 0;
        if(detail.Forecast_CY__c != null) {
            runRateBusiValue += detail.Forecast_CY__c;
        }
        if(detail.Obsoletion_EOL__c != null){
            runRateBusiValue += detail.Obsoletion_EOL__c;
        }
        if(detail.Transfer_Out__c != null){
            runRateBusiValue += detail.Transfer_Out__c;
        }
        if(detail.Transfer_In__c != null){
            runRateBusiValue += detail.Transfer_In__c;
        }
        if(detail.TAM_DTAM__c != null){
            runRateBusiValue += detail.TAM_DTAM__c;
        }       
        return runRateBusiValue;
    }
    
    public static Decimal calAdjustedBusiValue(Budget_Detail__c detail, Decimal runRateBusiValue){
        // run rate business
        Decimal adjustedBusiValue = runRateBusiValue;
        if(detail.Market_Growth__c != null){
            adjustedBusiValue += runRateBusiValue * (detail.Market_Growth__c / 100);
        }
        if(detail.Price_Change__c != null){
            adjustedBusiValue += runRateBusiValue * (detail.Price_Change__c / 100);
        }
        if(detail.Price_Increase__c != null){
            adjustedBusiValue += runRateBusiValue * (detail.Price_Increase__c / 100);
        }   
        return adjustedBusiValue;
    }
    
    public static Decimal calAdjustmentValue(Budget_Detail__c detail,Decimal total){
        Decimal runRate = calRunRateBusiValue(detail);
        Decimal adjustedBusiValue = calAdjustedBusiValue(detail,runRate);
        Decimal calcBudget = adjustedBusiValue + (detail.Opportunities_Won__c==null?0:detail.Opportunities_Won__c);
        Decimal adjustment =  total -  calcBudget;      
        return adjustment;
    }
    
    
    /**
    * This method is used to get the map of billing monthly records
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param      list of account ids, year
    *
    @return     map with account id, billing type, fiscal month, and billing monthly record    
    * 
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public static map<Id, map<Integer, map<string,BBB_Month_Bill_Book_Cust__c>>> getBBBMonthlyByAccountId(set<Id> set_accId, String year){
        map<Id, map<Integer, map<string,BBB_Month_Bill_Book_Cust__c>>> map_accountId_BBBMonthly = new map<Id, map<Integer, map<string,BBB_Month_Bill_Book_Cust__c>>>();  
        for(Id accId : set_accId){
            map_accountId_BBBMonthly.put(accId, new map<Integer, map<string,BBB_Month_Bill_Book_Cust__c>>());
            
        }   
        
        //for(BBB_Month_Bill_Book_Cust__c bbbMonth : [select Id, Name, Customer__c, Budget_Direct__c, Budget_POS__c, Budget_CMA__c, Original_Budget__c, Budget_TBR_NY__c, Budget_Document_Currency__c, Profit_Center__c, Bill_Amount_Document__c, Bill_Amount_USD__c, Bill_Cost_Amount__c, Bill_Type__c, Book_Amount_Document__c, Book_Amount_USD__c, Book_Cost_Amount__c, Fiscal_Year__c, Region__c, Reseller_Customer__c, SAP_Profit_Center__c, Sales_Period__c, Monthly_BBB_External_Key__c, Billings_Margin__c, Bookings_Margin__c, My_Sub_Vertical_BU__c, Quarter__c, Account_Name_Account_Number__c, Fiscal_Month__c from BBB_Month_Bill_Book_Cust__c where Fiscal_Year__c = :year and Customer__c in :list_accIds and Monthly_BBB_External_Key__c = null]){
        // add lili 2013.12.03 begin
        //for(BBB_Month_Bill_Book_Cust__c bbbMonth : [select Id, Name, Customer__c,  Budget_TBR_NY__c,Budget_Document_Currency__c,Budget_Direct_Disp__c, Budget_POS_Disp__c, Budget_CMA_Disp__c, Forecast_Disp__c, Bill_Amount_Document__c, Bill_Amount_USD__c, Bill_Cost_Amount__c, Bill_Type__c, Book_Amount_Document__c, Book_Amount_USD__c, Book_Cost_Amount__c, Fiscal_Year__c, Region__c, Reseller_Customer__c, SAP_Profit_Center__c, Sales_Period__c, Monthly_BBB_External_Key__c, Billings_Margin__c, Bookings_Margin__c, My_Sub_Vertical_BU__c, Quarter__c, Account_Name_Account_Number__c, Fiscal_Month__c,Bill_Type_Filter__c from BBB_Month_Bill_Book_Cust__c where Fiscal_Year__c = :year and Customer__c in :set_accId and Monthly_BBB_External_Key__c = null and SAP_Profit_Center__c = null]){
        for(BBB_Month_Bill_Book_Cust__c bbbMonth : [select Id, Name, Customer__c,  Budget_TBR_NY__c,Budget_Document_Currency__c,Budget_Direct_Disp__c, Budget_POS_Disp__c, Budget_CMA_Disp__c, Forecast_Disp__c, Bill_Amount_Document__c, Bill_Amount_USD__c, Bill_Cost_Amount__c, Bill_Type__c, Book_Amount_Document__c, Book_Amount_USD__c, Book_Cost_Amount__c, Fiscal_Year__c, Region__c, Reseller_Customer__c, SAP_Profit_Center__c, Sales_Period__c, Monthly_BBB_External_Key__c, Billings_Margin__c, Bookings_Margin__c, My_Sub_Vertical_BU__c, Quarter__c, Account_Name_Account_Number__c, Fiscal_Month__c,Bill_Type_Filter__c from BBB_Month_Bill_Book_Cust__c where Fiscal_Year__c = :year and Customer__c in :set_accId and Monthly_BBB_External_Key__c = null and SAP_Profit_Center__c = null]){
        // add lili 2013.12.03 end 
        // delete the field of forecas for budgetPlanning
        if(!map_accountId_BBBMonthly.get(bbbMonth.Customer__c).containsKey(Integer.valueOf(bbbMonth.Fiscal_Month__c))){
                map_accountId_BBBMonthly.get(bbbMonth.Customer__c).put(Integer.valueOf(bbbMonth.Fiscal_Month__c), new map<String,BBB_Month_Bill_Book_Cust__c>());
            }
            map_accountId_BBBMonthly.get(bbbMonth.Customer__c).get(Integer.valueOf(bbbMonth.Fiscal_Month__c)).put(bbbMonth.Bill_Type__c, bbbMonth);
        }
        return map_accountId_BBBMonthly;
    }
    
    public static map<string, id> getFilterMap(){
        if(map_type_filterId != null) return map_type_filterId;
        map_type_filterId = new map<string,id>();
        for(Cross_Dashboard_Filter__c filter :[select Id,  Filter_Value__c, Type__c from Cross_Dashboard_Filter__c where Type__c ='Bill Type']){
            map_type_filterId.put(filter.Filter_Value__c,filter.Id);
        }
        return map_type_filterId;
    }
    
        /**
    * This method is used to calculate billing monthly rate by quarter
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param      budget record
    *
    @return     map of billing type, month and monthly rate   
    * 
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */   
    public static Map<String, Map<Integer, Decimal>> calBBBMonthRateByQurater(Budget__c budget){ 
        Map<String, Map<Integer, Decimal>> map_billType_monthRate = new Map<String, Map<Integer, Decimal>>();
        map_billType_monthRate.put('Direct', new Map<Integer, Decimal>());
        map_billType_monthRate.put('POS', new Map<Integer, Decimal>());
        map_billType_monthRate.put('CMA', new Map<Integer, Decimal>());
        
        if(budget != null){
            Decimal totalDirect = 0;
            totalDirect += budget.FQ1_Direct__c==null?0:budget.FQ1_Direct__c; 
            totalDirect += budget.FQ2_Direct__c==null?0:budget.FQ2_Direct__c; 
            totalDirect += budget.FQ3_Direct__c==null?0:budget.FQ3_Direct__c; 
            totalDirect += budget.FQ4_Direct__c==null?0:budget.FQ4_Direct__c; 
            
            Decimal totalPOS = 0;
            totalPOS += budget.FQ1_POS__c==null?0:budget.FQ1_POS__c; 
            totalPOS += budget.FQ2_POS__c==null?0:budget.FQ2_POS__c; 
            totalPOS += budget.FQ3_POS__c==null?0:budget.FQ3_POS__c; 
            totalPOS += budget.FQ4_POS__c==null?0:budget.FQ4_POS__c; 

            Decimal totalCMA = 0;
            totalCMA += budget.FQ1_CMA__c==null?0:budget.FQ1_CMA__c; 
            totalCMA += budget.FQ2_CMA__c==null?0:budget.FQ2_CMA__c; 
            totalCMA += budget.FQ3_CMA__c==null?0:budget.FQ3_CMA__c; 
            totalCMA += budget.FQ4_CMA__c==null?0:budget.FQ4_CMA__c;                        
            
            map_billType_monthRate.get('Direct').putAll(calMonthRate(budget.FQ1_Direct__c, totalDirect, 1));
            map_billType_monthRate.get('Direct').putAll(calMonthRate(budget.FQ2_Direct__c, totalDirect, 4));
            map_billType_monthRate.get('Direct').putAll(calMonthRate(budget.FQ3_Direct__c, totalDirect, 7));
            map_billType_monthRate.get('Direct').putAll(calMonthRate(budget.FQ4_Direct__c, totalDirect, 10));
            
            map_billType_monthRate.get('POS').putAll(calMonthRate(budget.FQ1_POS__c, totalPOS, 1));
            map_billType_monthRate.get('POS').putAll(calMonthRate(budget.FQ2_POS__c, totalPOS, 4));
            map_billType_monthRate.get('POS').putAll(calMonthRate(budget.FQ3_POS__c, totalPOS, 7));
            map_billType_monthRate.get('POS').putAll(calMonthRate(budget.FQ4_POS__c, totalPOS, 10));
            
            map_billType_monthRate.get('CMA').putAll(calMonthRate(budget.FQ1_CMA__c, totalCMA, 1));
            map_billType_monthRate.get('CMA').putAll(calMonthRate(budget.FQ2_CMA__c, totalCMA, 4));
            map_billType_monthRate.get('CMA').putAll(calMonthRate(budget.FQ3_CMA__c, totalCMA, 7));
            map_billType_monthRate.get('CMA').putAll(calMonthRate(budget.FQ4_CMA__c, totalCMA,10));                     
        }
        //system.debug('map_billType_monthRate: ' + map_billType_monthRate);
        return map_billType_monthRate;
    }
    
        /**
    * This method is used to calculate forecast billing monthly rate by quarter
    *
    @author Min Liu
    @created 2012-10-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param      budget record
    *
    @return     map of billing type, month and monthly rate   
    * 
    @changelog
    * 2012-10-29 Min Liu <min.liu@itbconsult.com>
    * - Created
    */   
    public static Map<Integer, Decimal> calFCBBBMonthRateByQurater(Budget__c budget){ 
        Map<Integer, Decimal> map_FC_monthRate = new Map<Integer, Decimal>();
        
        if(budget != null){
            Decimal total = 0;
            
            Decimal q1Total = 0;
            q1Total += budget.FQ1_Direct__c==null?0:budget.FQ1_Direct__c; 
            q1Total += budget.FQ1_POS__c==null?0:budget.FQ1_POS__c; 
            q1Total += budget.FQ1_CMA__c==null?0:budget.FQ1_CMA__c; 
            total += q1Total;
            
            Decimal q2Total = 0;
            q2Total += budget.FQ2_Direct__c==null?0:budget.FQ2_Direct__c; 
            q2Total += budget.FQ2_POS__c==null?0:budget.FQ2_POS__c; 
            q2Total += budget.FQ2_CMA__c==null?0:budget.FQ2_CMA__c; 
            total += q2Total;            
            
            Decimal q3Total = 0;
            q3Total += budget.FQ3_Direct__c==null?0:budget.FQ3_Direct__c; 
            q3Total += budget.FQ3_POS__c==null?0:budget.FQ3_POS__c; 
            q3Total += budget.FQ3_CMA__c==null?0:budget.FQ3_CMA__c; 
            total += q3Total;
            
            Decimal q4Total = 0;
            q4Total += budget.FQ4_Direct__c==null?0:budget.FQ4_Direct__c; 
            q4Total += budget.FQ4_POS__c==null?0:budget.FQ4_POS__c; 
            q4Total += budget.FQ4_CMA__c==null?0:budget.FQ4_CMA__c; 
            total += q4Total;
                       
            map_FC_monthRate.putAll(calMonthRate(q1Total, total, 1));
            map_FC_monthRate.putAll(calMonthRate(q2Total, total, 4));
            map_FC_monthRate.putAll(calMonthRate(q3Total, total, 7));
            map_FC_monthRate.putAll(calMonthRate(q4Total, total, 10));
                                 
        }
        //system.debug('map_FC_monthRate: ' + map_FC_monthRate);
        return map_FC_monthRate;
    }
    
    
        /**
    * This method is used to get the map of budget rate
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param      year
    *
    @return     map with isoCode, year, budget rate   
    * 
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */  
    public static map<String, map<String,Decimal>> calBudgetRate(){
        map<String, map<String,Decimal>> map_currency_type_Rate = new map<String, map<String,Decimal>>(); 
        for(Budget_Rate__c br: [SELECT  CurrencyIsoCode, Rate__c FROM Budget_Rate__c where Rate__c != null and Rate__c != 0]){
            map_currency_type_Rate.put(br.CurrencyIsoCode, new map<String,Decimal>());
            map_currency_type_Rate.get(br.CurrencyIsoCode).put('Rate', br.Rate__c); 
        }    
            
        for(CurrencyType ct : [select Id, IsoCode, ConversionRate from CurrencyType where IsActive = true and ConversionRate != null]){
            if(map_currency_type_Rate.containsKey(ct.IsoCode)){
                Decimal r = ct.ConversionRate / map_currency_type_Rate.get(ct.IsoCode).get('Rate');
                map_currency_type_Rate.get(ct.IsoCode).put('Rate', r);
            }
            else {
                map_currency_type_Rate.put(ct.IsoCode, new map<String,Decimal>());
                map_currency_type_Rate.get(ct.IsoCode).put('Rate', 1); 
            } 
            
            map_currency_type_Rate.get(ct.IsoCode).put('Standard', ct.ConversionRate);          
        }        
        return map_currency_type_Rate;
    }
    
        /**
    * This method is used to calculate monthly rate
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param      quarter value, total value, month
    *
    @return     map of month and monthly rate
    * 
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public static Map<Integer, Decimal> calMonthRate(Decimal q, Decimal total, Integer qr){ 
        Map<Integer, Decimal> map_monthRates = new Map<Integer, Decimal>();
        Decimal q1 = 0; 
        Decimal q2 = 0;
        if(q != null && total != 0){
            q1 = (q * 4 / 13)/total;
            q2 = (q/total) - (2*q1); //q2 = (q/total) - 2*(q1);
        }
        map_monthRates.put(qr, q1);
        map_monthRates.put(qr+1, q2);
        map_monthRates.put(qr+2, q1);
        return map_monthRates;
    }
    
        /**
    * The method is used to get sales period
    *
    @author Min Liu
    @created 2012-10-10
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param             
    *
    @return     sales period date
    *
    @changelog
    * 2012-10-10 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public static Date salesPeriodDate(String fiscalYear, Decimal fiscalMonth){
        String monthLabel = '';
        Date salesPeriodDate;
        Date endDate;
        getAllFiscalMonthDateRange();   
        if(MAP_NUMBERMONTHLABEL.containsKey(Integer.valueOf(fiscalMonth))) monthLabel = MAP_NUMBERMONTHLABEL.get(Integer.valueOf(fiscalMonth));
        if(map_fiscalYear_fiscalMonth_SEDate.containsKey(fiscalYear) && map_fiscalYear_fiscalMonth_SEDate.get(fiscalYear).containsKey(monthLabel)){
            endDate = map_fiscalYear_fiscalMonth_SEDate.get(fiscalYear).get(monthLabel).get('End');
        }
        if(endDate != null){
            Date tmpDate = Date.newinstance(endDate.year(), endDate.month(), 15);
            if(endDate >= tmpDate) salesPeriodDate = tmpDate;
            else salesPeriodDate = tmpDate.addMonths(-1);
        }
        return salesPeriodDate;
    }
    
    public static void getAllFiscalMonthDateRange(){
        if(map_fiscalYear_fiscalMonth_SEDate == null){
            map_fiscalYear_fiscalMonth_SEDate = new Map<String, Map<String, Map<String, Date>>>();
            for(Period p: [select FiscalYearSettingsId, FiscalYearSettings.Name, PeriodLabel, Number, StartDate, EndDate from Period where type = 'month' and PeriodLabel != null]){
                if(!map_fiscalYear_fiscalMonth_SEDate.containsKey(p.FiscalYearSettings.Name)){
                    map_fiscalYear_fiscalMonth_SEDate.put(p.FiscalYearSettings.Name, new Map<String, Map<String, Date>>());
                }
                if(!map_fiscalYear_fiscalMonth_SEDate.get(p.FiscalYearSettings.Name).containsKey(p.PeriodLabel)){
                    map_fiscalYear_fiscalMonth_SEDate.get(p.FiscalYearSettings.Name).put(p.PeriodLabel, new Map<String, Date>());
                }
                map_fiscalYear_fiscalMonth_SEDate.get(p.FiscalYearSettings.Name).get(p.PeriodLabel).put('Start', p.StartDate);
                map_fiscalYear_fiscalMonth_SEDate.get(p.FiscalYearSettings.Name).get(p.PeriodLabel).put('End', p.EndDate);
            }
        }
    }
      
}