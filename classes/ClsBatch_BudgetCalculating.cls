/**
 *  This class is used to Calculate Budget with Budget Rates of next year
 *  
 * @author Yinfeng Guo
 * @created 2012-07-09
 * @version 1.0
 * @since 23.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2012-07-09 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Created   
 *
 */
global class ClsBatch_BudgetCalculating implements Database.Batchable<SObject>, Database.Stateful{
    public String email;
    public String filter;
    public Integer fiscalYear;
    global map<String, Decimal> map_currencyISOCode_rate;
   /** 
    * The contsructor
    *
    @author Yinfeng Guo
    @created 2012-07-09
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @changelog
    * 2012-07-09 YinFeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */
    public ClsBatch_BudgetCalculating(){
        if(fiscalYear == null){
            Date runDate = Date.today();
            for(Period p: [select FiscalYearSettingsId, FiscalYearSettings.Name, PeriodLabel, Number, StartDate, EndDate from Period where type = 'year'  and FiscalYearSettings.IsStandardYear = false order by FiscalYearSettings.Name]){
                if(runDate >= p.StartDate && runDate <= p.EndDate){
                    fiscalYear = Integer.valueOf(p.FiscalYearSettings.Name);
                    break;
                }
            }
        }

        map_currencyISOCode_rate = new map<String, Decimal>();
        for(Budget_Rate__c rate: [SELECT  CurrencyIsoCode, Effective_Date__c, Expiration_Date__c, Rate__c FROM Budget_Rate__c]){
            map_currencyISOCode_rate.put(rate.CurrencyIsoCode, rate.Rate__c);
        }   
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        String query;   
        query = 'SELECT Customer_Currency__c, Budget_Document_Currency__c, Budget_TBR_NY__c, CurrencyIsoCode, Fiscal_Year__c FROM BBB_Month_Bill_Book_Cust__c WHERE Fiscal_Year__c ='+'\''+fiscalYear+'\' and Budget_Document_Currency__c != null and Monthly_BBB_External_Key__c = null';     //Id= \'a0CM0000003zv4KMAQ\' and
        if(filter != null) query += filter;
        return Database.getQueryLocator(query);  
    }

    global void execute(Database.BatchableContext BC, list<BBB_Month_Bill_Book_Cust__c> list_bbbBudgets){
        list<BBB_Month_Bill_Book_Cust__c> list_budgets2Update = new list<BBB_Month_Bill_Book_Cust__c>();
        
        for(BBB_Month_Bill_Book_Cust__c budget : list_bbbBudgets){
            if(map_currencyISOCode_rate.containsKey(budget.Customer_Currency__c)){
                Decimal actualRate = map_currencyISOCode_rate.get(budget.Customer_Currency__c);
                if(actualRate != 0 && budget.Budget_Document_Currency__c != null) budget.Budget_TBR_NY__c = budget.Budget_Document_Currency__c/actualRate;
            }
            else budget.Budget_TBR_NY__c = budget.Budget_Document_Currency__c;
            
            list_budgets2Update.add(budget);    
        }
        
        if(!list_budgets2Update.isEmpty()) update list_budgets2Update;
    }

    global void finish(Database.BatchableContext BC){ 
    	if(!test.isRunningTest()){
	        ClsBatch_BudgetDetailRateCalculating batchClass = new ClsBatch_BudgetDetailRateCalculating();
	        database.executeBatch(batchClass);
    	}
    }

}