/**
 *  This class is used to recalculate BBB_Month_Bill_Book_Cust__c.
 *  
 * @author Xiaona Liu
 * @created 2013-10-17
 * @version 1.0
 * @since 28.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2013-10-17 Xiaona Liu <xiaona.liu@itbconsult.com>
 * - Created   
 *
 */
global class ClsBatch_setLastASMFrozenDate implements Database.Batchable<SObject>, Database.stateful{
    public String query;
    public String filter;
    global Date frozenDate;
    global boolean isUnFrozen;
    private String currentYear;
    private Integer currentMonth;
    
    public ClsBatch_setLastASMFrozenDate(){        
        ClsFinancialFCBatchUtil.PageConfig pageConf = new ClsFinancialFCBatchUtil.PageConfig();
        ClsFinancialFCBatchUtil.setCurrent(pageConf);
        currentYear = pageConf.currentYear;
        currentMonth = pageConf.currentMonth;   
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        Date startDate = Date.newInstance(Integer.valueOf(currentYear), currentMonth, 15);
        system.debug('startDate : ' + startDate);
        if(query == null || query.trim() == ''){
            //profit center != null should use the field "IND_Profit_Centre_Groups__c"
            query = 'Select b.Name, b.Last_Frozen_Month_Date__c, b.Id, b.Fiscal_Year__c, b.Fiscal_Month__c From BBB_Month_Bill_Book_Cust__c b where b.Fiscal_Date__c >=: startDate and b.Bill_Type__c = \'Direct\' ' ;        
        }
        if(filter != null) query += filter;
        if(isUnFrozen == null) {
        	isUnFrozen = false;
        }
        for( Period per : [SELECT EndDate, FiscalYearSettingsId, IsForecastPeriod, Number, Id, PeriodLabel, QuarterLabel, StartDate, SystemModstamp, Type FROM Period where StartDate > Today and Type = 'Month' order by StartDate asc limit 1]){
            if(frozenDate == null)  {
            	frozenDate = per.StartDate;
            	frozenDate = frozenDate.addDays(6);
            }
        }   
        system.debug('frozenDate: ' + frozenDate);        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<BBB_Month_Bill_Book_Cust__c> list_BBMonths){   
        for(BBB_Month_Bill_Book_Cust__c bbMonth : list_BBMonths){
            bbMonth.Last_Frozen_Month_Date__c = frozenDate;    
        }
        update list_BBMonths;
    }
    
    global void finish(Database.BatchableContext BC){ 
        if(isUnFrozen) {
			ClsBatch_setLastRSMFrozenDate cls= new ClsBatch_setLastRSMFrozenDate();
			cls.frozenDate = system.today().addDays(-6);
			cls.isUnFrozen = isUnFrozen;
			ID batchprocessid = Database.executeBatch(cls);
        }
    }
}