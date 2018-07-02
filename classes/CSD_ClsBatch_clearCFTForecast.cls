/**
 *  This class is used to clear outdated CFT forecast data.
 *  
 * @author Lei Tang
 * @created 2015-01-28
 * @version 1.0
 * @since 30.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2015-01-28 Lei Tang <lei.tang@itbconsult.com>
 * - Created   
 *
 */
global class CSD_ClsBatch_clearCFTForecast implements Database.Batchable<SObject>, Database.stateful{
    global String query;
    global String filter;
    global Date clearFiscalDate;
    
    public CSD_ClsBatch_clearCFTForecast(){
    	clearFiscalDate = CSD_ClsUtils.getCurrentFiscalDate().addMonths(-1).addDays(-1);
    } 
      
    global Database.QueryLocator start(Database.BatchableContext BC) { 
    	
    	if(query == null || query.trim() == '') {
    		query = ' Select Id, Fiscal_Date__c From CSD_CFT_Forecast__c '
	        	  +  ' Where Fiscal_Date__c < :clearFiscalDate ';
    	}
        if(filter != null && filter.trim() !=''){
            query += filter;
        }  
        system.debug('query :: ' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<CSD_CFT_Forecast__c> list_cftFCs){
    	if(list_cftFCs.size() > 0) {
        	delete list_cftFCs;
    	}
    }
    
    global void finish(Database.BatchableContext BC){ 
    }
}