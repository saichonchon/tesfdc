/**
 *  This class is used to recalculate BBBM backlog.
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
 *
 */
global class ClsBatch_calculateBBBMBacklog implements Database.Batchable<SObject>, Database.stateful{
    global String query;
    global String bbbMQuery;
    global String filter;
    global String str_limit;
    global String currentYear;
    global String currentMonth; 	
    global Date startDate; 
    global Date endDate;
    
    public static final Integer PREVIOUSMONTH = 3;
    
    public ClsBatch_calculateBBBMBacklog(){
        filter = '';
        ClsFinancialFCBatchUtil.PageConfig pageConf = new ClsFinancialFCBatchUtil.PageConfig();
        ClsFinancialFCBatchUtil.setCurrent(pageConf);
		
        if(currentYear == null) currentYear = pageConf.currentYear;
        if(currentMonth == null) currentMonth = String.valueOf(pageConf.currentMonth);

    } 
      
    global Database.QueryLocator start(Database.BatchableContext BC){

    	endDate = Date.newinstance(Integer.valueOf(currentYear), Integer.valueOf(currentMonth), 15);
        startDate = endDate.addMonths(-PREVIOUSMONTH);     
        
        if(startDate != null && endDate != null) {
        	filter = 'Fiscal_date__c >= ' + startDate + ' And Fiscal_date__c <= ' + endDate;
        	filter = filter.replaceAll(' 00:00:00', '');
        }
        if(query == null || query.trim() == ''){
            query = 'Select Id, Fiscal_date__c, Fiscal_year__c, Fiscal_Month__c, Customer__c, IND_Profit_Centre_Groups__c, Bill_Type__c';
        	for (Integer i = 0; i<= 2*PREVIOUSMONTH; i++) {
        		query += ', Backlog_' + i + '__c';
        		//Backlog_0__c,Backlog_1__c,Backlog_2__c,Backlog_3__c,Backlog_4__c,Backlog_5__c,Backlog_6__c
        	}
        	query += ' From BBB_Month_Bill_Book_Cust__c';
        }
        if(filter != null && filter.trim() !=''){
            query += ' where ' + filter;
        }   
        query += ' and Monthly_BBB_External_Key__c != null and Bill_Type__c = \'Direct\'';
        bbbMQuery = query;
        query += ' order by Fiscal_date__c asc ';
        if(str_limit != null && str_limit.trim() !=''){
            query += ' ' + str_limit;
        }   
        system.debug('query:::;'+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<BBB_Month_Bill_Book_Cust__c> list_BBMonths){
        ClsFinancialFCBatchUtil.setBBBMonthBacklog(list_BBMonths, endDate, bbbMQuery);
        update list_BBMonths;
    }
    
    global void finish(Database.BatchableContext BC){ 
    	if(Test.isRunningTest()) return;
        ClsBatch_calculateBBBMCurrency batch = new ClsBatch_calculateBBBMCurrency();
		batch.currentYear = Integer.valueOf(currentYear);
		batch.currentMonth = Integer.valueOf(currentMonth);
		Database.executeBatch(batch);
    }
}