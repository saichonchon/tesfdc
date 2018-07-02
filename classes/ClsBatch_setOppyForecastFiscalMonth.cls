/** 
*    batch class for Fiscal_Month__c of Opportunity_Forecast__c object
*
@author Lili Zhao
@created 2014-04-18 
@version 1.0
@since 27.0 (Force.com ApiVersion)
*
@changelog
* 2014-04-09 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
global class ClsBatch_setOppyForecastFiscalMonth implements Database.Batchable<sObject>{
    public String query = '';
    public String filter = '';
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        if(query == null || query == ''){
            query = 'SELECT Fiscal_Month__c, Id, Date__c,opportunity__r.RecordType.Name, opportunity__r.level__c FROM Opportunity_Forecast__c WHERE Date__c != null ';
        }
        if(filter != '') query += filter;
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, list<Opportunity_Forecast__c > list_oppyForcasts){
        // *** set the Fiscal_Month__c as the Date__c of oppyForcast 
        ClsOppyForecastUtil.setFiscalMonthForBatch(list_oppyForcasts);
    }
    global void finish(Database.BatchableContext BC){
        
    }
}