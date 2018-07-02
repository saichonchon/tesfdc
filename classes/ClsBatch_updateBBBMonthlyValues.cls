/**
 *  This class is used to set the BBBMontly records when budgets are approved
 *  
 * @author  Min Liu
 * @created 2013-01-21
 * @version 1.0
 * @since 26.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2013-01-21 Min Liu<min.liu@itbconsult.com>
 * - Created   
 *
 */
global class ClsBatch_updateBBBMonthlyValues implements Database.Batchable<SObject>, Database.Stateful {
    
    // add lili 2013.12.03 begin   
    private String query = 'Select id,Budget__c,Budget_Direct__c,Budget_POS__c,Budget_CMA__c,Budget_Billings_LY__c,Budget_Billings_CYTD__c,Budget_Billing_CYRR__c,'
    // add lili 2013.12.03 end 
    // delete the field of forecast for budgetPlanning
                         + 'Budget_Direct_Disp__c,Budget_POS_Disp__c,Budget_CMA_Disp__c,Forecast_Disp__c,Budget_Billings_LY_Disp__c,Budget_Billings_CYTD_Disp__c,'
                         + 'Budget_Billing_CYRR_Disp__c,Customer__c,Fiscal_Month__c,CurrencyIsoCode, Original_Budget__c '
                         + 'from BBB_Month_Bill_Book_Cust__c where Fiscal_Year__c IN :set_years and Customer__c IN :set_accIds and Monthly_BBB_External_Key__c = null';
    
    global Map<String, Map<String,Decimal>> map_currency_type_Rate = new Map<String, Map<String,Decimal>>();
    global map<Id, map<String, Budget__c>> map_accId_year_budget = new map<Id, map<String, Budget__c>>();
    global map<Id, Budget__c> map_bId_budget = new map<Id, Budget__c>();
    global Set<Id> set_accIds = new Set<Id>();
    global Set<String> set_years = new Set<String>();
    public string filter;
    /** 
    * The contsructor
    *
    @author Min Liu
    @created 2013-01-21
    @version 1.0
    @since 26.0 (Force.com ApiVersion)
    *
    @changelog
    * 2013-01-21 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public ClsBatch_updateBBBMonthlyValues(map<Id, map<String, Budget__c>> map_accId_year_budget,Set<Id> set_accIds,Set<String> set_years){
        this.map_accId_year_budget = map_accId_year_budget;
        this.set_accIds = set_accIds;
        this.set_years = set_years;
        map_currency_type_Rate = ClsBudgetPlanningUtil.calBudgetRate();
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        if(filter != null) query += filter;
        return Database.getQueryLocator(query);  
    }
    
    global void execute(Database.BatchableContext BC, List<BBB_Month_Bill_Book_Cust__c> list_bbbMonthly){
        for(BBB_Month_Bill_Book_Cust__c bbbM: list_bbbMonthly){                         
            Map<String,Decimal> map_type_Rate = new  Map<String,Decimal>();
            if(map_currency_type_Rate.containsKey(bbbM.CurrencyIsoCode)) map_type_Rate = map_currency_type_Rate.get(bbbM.CurrencyIsoCode);
            
            if(bbbM.Budget_Direct_Disp__c == null) bbbM.Budget_Direct_Disp__c = 0;
            if(bbbM.Budget_POS_Disp__c == null) bbbM.Budget_POS_Disp__c = 0;
            if(bbbM.Budget_CMA_Disp__c == null) bbbM.Budget_CMA_Disp__c = 0;
            
            bbbM.Budget_Direct__c = bbbM.Budget_Direct_Disp__c;
            bbbM.Budget_POS__c = bbbM.Budget_POS_Disp__c;
            bbbM.Budget_CMA__c = bbbM.Budget_CMA_Disp__c;
            // add lili 2013.12.03 delete the field of forecast
            
            bbbM.Budget_Billings_LY__c = bbbM.Budget_Billings_LY_Disp__c;
            bbbM.Budget_Billings_CYTD__c = bbbM.Budget_Billings_CYTD_Disp__c;
            bbbM.Budget_Billing_CYRR__c = bbbM.Budget_Billing_CYRR_Disp__c;
            
            Decimal total = bbbM.Budget_Direct__c + bbbM.Budget_POS__c + bbbM.Budget_CMA__c;       
            /*
            if(bbbM.CurrencyIsoCode != 'USD'){
                //String ly = String.valueOf(Integer.valueOf(year) - 1);
                Decimal r = 1;
                Decimal s = 1;
                if(map_type_Rate.containsKey('Rate')) r = map_type_Rate.get(('Rate'));
                if(map_type_Rate.containsKey('Standard')) s = map_type_Rate.get('Standard');                             
        
                bbbM.Budget_TBR_NY__c = bbbM.Budget__c * r;
                bbbM.Budget_Document_Currency__c = bbbM.Budget__c * s;
            }
            else{
                
                bbbM.Budget_TBR_NY__c = bbbM.Budget__c;
                bbbM.Budget_Document_Currency__c = bbbM.Budget__c;
            }   
            */
            if(bbbM.Original_Budget__c == null || bbbM.Original_Budget__c == 0) {
                bbbM.Original_Budget__c = bbbM.Budget__c;
                system.debug('BBB M :: ' + bbbM);               
            }           
        }
        if(!list_bbbMonthly.isEmpty()) update list_bbbMonthly;
    }
    
    global void finish(Database.BatchableContext BC){
        // update budgets
        if(!map_accId_year_budget.isEmpty()) {
            ClsTriggerRecursionDefense.bbbMonthlyUpdate = false;
            //update map_bId_budget.values();
            ClsTriggerRecursionDefense.bbbMonthlyUpdate = true;
        }
    }
}