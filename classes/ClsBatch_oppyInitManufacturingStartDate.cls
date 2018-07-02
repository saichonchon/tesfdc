/** 
*    batch class to migrate NPS answers
*
@author Xia Tong
@created 2013-01-14 
@version 1.0
@since 23.0 (Force.com ApiVersion)
*
@changelog
* 2013-01-14 Xia Tong <xia.tong@itbconsult.com>
* - Created
*/

global class ClsBatch_oppyInitManufacturingStartDate implements Database.Batchable<SObject>{
	private static string query ='select id, CloseDate, Manufacturing_Start_Date__c from Opportunity where CloseDate!= null and Manufacturing_Start_Date__c=null';	
	public String filter;
	global Database.QueryLocator start(Database.BatchableContext BC){ 
        if(filter != null) query += filter;
        return Database.getQueryLocator(query); 
    }
    global void execute(Database.BatchableContext BC, list<Opportunity> scope){
    	for(Opportunity oppy: scope){
    		oppy.Manufacturing_Start_Date__c = oppy.CloseDate;
    	}	
    	update scope;
    }
    global void finish(Database.BatchableContext BC){ 
    
    }
}