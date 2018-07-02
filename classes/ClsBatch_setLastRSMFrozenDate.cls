/**
 *  This class is used to recalculate Manager_Forecast__c.
 *  
 * @author Xiaona Liu
 * @created 2013-10-17
 * @version 1.0
 * @since 28.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 *
 * * 2014-06-06 Lili Zhao <lili.zhao@itbconsult.com>
 * - modify to delete the string of ' 00:00:00' from query
 *
 * 2013-10-17 Xiaona Liu <xiaona.liu@itbconsult.com>
 * - Created   
 *
 */
/**
 *  This class is used to recalculate BBB_Month_Bill_Book_Cust__c.
 *  
 * @author Xiaona Liu
 * @created 2013-10-17
 * @version 1.0
 * @since 28.0 (Force.com ApiVersion)  
 * 
 *  2014-06-06 Lili Zhao <lili.zhao@itbconsult.com>
 * - modify to delete the string of ' 00:00:00' from query
 * @changelog
 * 2013-10-17 Xiaona Liu <xiaona.liu@itbconsult.com>
 * - Created   
 *
 */
global class ClsBatch_setLastRSMFrozenDate implements Database.Batchable<SObject>, Database.stateful{
    public String query;
    public String filter;
    global Date frozenDate;
    global boolean isUnFrozen;
    private String currentYear;
    private Integer currentMonth;
    
    public ClsBatch_setLastRSMFrozenDate(){        
    	
        ClsFinancialFCBatchUtil.PageConfig pageConf = new ClsFinancialFCBatchUtil.PageConfig();
        ClsFinancialFCBatchUtil.setCurrent(pageConf);
        currentYear = pageConf.currentYear;
        currentMonth = pageConf.currentMonth;
        if(isUnFrozen == null) {
        	isUnFrozen = false;
        }   
        for( Period per : [SELECT EndDate, FiscalYearSettingsId, IsForecastPeriod, Number, Id, PeriodLabel, QuarterLabel, StartDate, SystemModstamp, Type FROM Period where StartDate > Today and Type = 'Month' order by StartDate asc limit 1]){
            if(frozenDate == null)  {
            	frozenDate = per.StartDate;
            	frozenDate = frozenDate.addDays(6);
            }
        }    
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
    	Date startDate = Date.newInstance(Integer.valueOf(currentYear), currentMonth, 15);
        if(query == null || query.trim() == ''){
			query = 'Select Name,Last_Frozen_Month_Date__c,Id,Fiscal_Date__c from Manager_Forecast__c where Fiscal_Date__c >=: startDate ';        
        	// add lili zhao 2014-06-06 delete the string of ' 00:00:00' from query
        	query = query.replaceAll(' 00:00:00', '');
        	// end
        }
        if(filter != null) query += filter;
        //system.debug('query:::'+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Manager_Forecast__c> list_MgForecasts){   
        for(Manager_Forecast__c mForecast : list_MgForecasts){
            mForecast.Last_Frozen_Month_Date__c = frozenDate;  
        }
        update list_MgForecasts;
    }
    
    global void finish(Database.BatchableContext BC){ 
    	if(isUnFrozen) {
    		String chatterGroupId = '';
    		if(Financial_Planning_Configuration__c.getInstance('Chatter Group') != null 
    		&& Financial_Planning_Configuration__c.getInstance('Chatter Group').Is_Active__c != null 
    		&& Financial_Planning_Configuration__c.getInstance('Chatter Group').Is_Active__c == true ) {
    			chatterGroupId = (String) Financial_Planning_Configuration__c.getInstance('Chatter Group').Parameter__c;
    		}
	        Date fiscalMonthStartDate;
	        for(Period p : [select EndDate, StartDate
	                        from Period 
	                        where Type = 'Month'
	                        and EndDate >=: system.today()
	                        and StartDate <=: system.today()]) {
	                            
	            fiscalMonthStartDate = p.StartDate;             
	        }
	        system.debug('fiscalMonthStartDate ::: ' + fiscalMonthStartDate);
	        // add lili 2014-06-30 begin due to get the add days from custom setting Financial_Planning_Configuration__c
	        Integer ASMFiscalMonthStartDate = 21;
	        Integer RSMFiscalMonthStartDate = 26;
	        // get the ASMFiscalMonthStartDate(22 days) from custom setting Financial_Planning_Configuration__c
	        if(Financial_Planning_Configuration__c.getInstance('AM Frozen Date') != null 
	            && Financial_Planning_Configuration__c.getInstance('AM Frozen Date').Is_Active__c  
	            && Financial_Planning_Configuration__c.getInstance('AM Frozen Date').Date_Parameter__c != null ) { 
	            ASMFiscalMonthStartDate = Integer.valueOf(Financial_Planning_Configuration__c.getInstance('AM Frozen Date').Date_Parameter__c);
	            ASMFiscalMonthStartDate = ASMFiscalMonthStartDate - 1;
	            
	        }
	        // get the RSMFiscalMonthStartDate(27 days) from custom setting Financial_Planning_Configuration__c
	        if(Financial_Planning_Configuration__c.getInstance('RSM Frozen Date') != null 
	            && Financial_Planning_Configuration__c.getInstance('RSM Frozen Date').Is_Active__c  
	            && Financial_Planning_Configuration__c.getInstance('RSM Frozen Date').Date_Parameter__c != null ) {
	                
	            RSMFiscalMonthStartDate = Integer.valueOf(Financial_Planning_Configuration__c.getInstance('RSM Frozen Date').Date_Parameter__c);
	            RSMFiscalMonthStartDate = RSMFiscalMonthStartDate - 1;
	        }
    		if(chatterGroupId != '') {
		        FeedItem item = new FeedItem();
		        item.Body = system.label.FinancialPlan_AMAndRSMunFrozenMsg;
		        item.Body = item.Body.replace('<AM_Close_Date>', fiscalMonthStartDate.addDays(ASMFiscalMonthStartDate) + '');
		        item.Body = item.Body.replace('<RSM_Close_Date>', fiscalMonthStartDate.addDays(RSMFiscalMonthStartDate) + '');
		        item.Body = item.Body.rePlaceAll(' 00:00:00', '');
		        item.ParentId = chatterGroupId;
		        insert item;
    		}
	        
    	}
    }
}