/**
 *  This class is used to calculate BBB_Month_Bill_Book_Cust__c currecny.
 *  
 * @author Yuda Zheng
 * @created 2013-12-06
 * @version 1.0
 * @since 28.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2013-12-06 Yuda Zheng <yuda.zheng@itbconsult.com>
 * - Created   
 * 2014-03-11 Bin Yuan <bin.yuan@itbconsult.com>
 * - Modified 
 * requirments example Monthy BB record for March
 * Currency 1 = (open Demand + Shipped Demand) of March BB record - Backlog 0 of March BB record
 * Currency 2 = (open Demand + Shipped Demand) of March BB record - Backlog 1 of February BB reocrd 
 * Currency 3 = (open Demand + Shipped Demand) of March BB record - Backlog 2 of January BB record
 * Currency 4 = (open Demand + Shipped Demand) of MArch BB record - Backlog 3 of December BB record
 */
global class ClsBatch_calculateBBBMCurrency implements Database.Batchable<SObject>, Database.stateful{
    global String query;
    global String bbbMQuery;
    global String filter;
    global Integer currentYear;
    global Integer currentMonth;
    global String startYear;
    global String startMonth;	
    global Date startDate; 
    global Date queryStartDate; 
    global Date endDate;
    
    public static final Integer PREVIOUSMONTH = 6;
    
    public ClsBatch_calculateBBBMCurrency(){
       	ClsFinancialFCBatchUtil.PageConfig pageConf = new ClsFinancialFCBatchUtil.PageConfig();
        ClsFinancialFCBatchUtil.setCurrent(pageConf);
        if(currentYear == null) currentYear = Integer.valueOf(pageConf.currentYear);
        if(currentMonth == null) currentMonth = pageConf.currentMonth;

    } 
      
    global Database.QueryLocator start(Database.BatchableContext BC){
    	if(startYear != null && startMonth != null) {
        	startDate = Date.newinstance(Integer.valueOf(startYear), Integer.valueOf(startMonth), 15);
        }
        else {
        	startDate = Date.newinstance(currentYear, currentMonth, 15);
        }
        //Added by bin yuan due to calc currency 1~4 begin for 6 months ago and 3 months later
        endDate = startDate.addMonths(0);
        startDate = startDate.addMonths(-6);
        queryStartDate = startDate.addMonths(-3);
        
		//generate query fields for Backlog_0__c,Backlog_1__c,Backlog_2__c,Backlog_3__c, Currency_1_USD__c, Currency_2_USD__c, Currency_3_USD__c, Currency_4_USD__c
        if(query == null || query.trim() == ''){
            query = 'Select Id, Fiscal_date__c, Fiscal_year__c, Fiscal_Month__c, Demand_Shipped__c, Demand_Open__c, SAP_Profit_Center_Code__c, Customer__c, CurrencyIsoCode ';
        	for (Integer i = 0; i<= 3; i++) {
        		query += ', Backlog_' + i + '__c, Currency_' + (i + 1) + '_USD__c ';
        	}
        	query += ' From BBB_Month_Bill_Book_Cust__c ';
        }
        // modify by lili zhao 2014-06-06 begin due to delete the String of 'and Customer__c = \'001E000000Ba9wm\'' from query
        //query += ' Where  Monthly_BBB_External_Key__c != null and Bill_Type__c = \'Direct\' and Customer__c = \'001E000000Ba9wm\' ';
        query += ' Where  Monthly_BBB_External_Key__c != null and Bill_Type__c = \'Direct\' ';
		// end
        if(startDate != null && endDate != null) {
        	if(startDate != endDate) {
        		query += ' and Fiscal_date__c >= ' + queryStartDate + ' And Fiscal_date__c <= ' + endDate;
        	}
        	query = query.replaceAll(' 00:00:00', '');
        }       
        
        bbbMQuery = query;
        if(filter != null && filter.trim() !=''){
            query += ' And ' + filter;
        }   
        query += ' order by Customer__c ';
        system.debug('query:' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<BBB_Month_Bill_Book_Cust__c> list_BBMonths){
		//ClsFinancialFCBatchUtil.setBBBMonthBillBookCust(list_BBMonths, index, currentYear, currentMonth);
		system.debug('list_BBMonths:::'+list_BBMonths);
        ClsFinancialFCBatchUtil.setBBBMonthCurrency(list_BBMonths, bbbMQuery, queryStartDate);
        //system.debug('list_BBMonths:::'+list_BBMonths);
        update list_BBMonths;
    }
    
    global void finish(Database.BatchableContext BC){ 
    	/*
    	if(Financial_Planning_Configuration__c.getInstance('Prev Forecast calc After Currency') != null 
    		&& Financial_Planning_Configuration__c.getInstance('Prev Forecast calc After Currency').Is_Active__c != null 
    		&& Financial_Planning_Configuration__c.getInstance('Prev Forecast calc After Currency').Is_Active__c == true ) {
    			
	        ClsBatch_recalculateAccountForecast amPrevForecastCls = new ClsBatch_recalculateAccountForecast();
			amPrevForecastCls.currentYear = String.valueOf(currentYear);
			amPrevForecastCls.currentMonth = String.valueOf(currentMonth);
	        database.executeBatch(amPrevForecastCls);
    	}
        */
        //after currency recalculation job finished   open AM and RSM forecasting
		ClsBatch_setLastASMFrozenDate cls= new ClsBatch_setLastASMFrozenDate();
		cls.frozenDate = system.today().addDays(-6);
		cls.isUnFrozen = true;
		if(!Test.isRunningTest()) {
			ID batchprocessid = Database.executeBatch(cls);
		}
    }
}