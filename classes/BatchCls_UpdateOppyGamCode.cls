/**
 * 
 *   This batch class is used to update Opportunity_Gam_Code__c on Opportunity
 *
 * @author      Chen Chen
 * @created     2017-01-24
 * @since       37.0 (Force.com ApiVersion)      
 * @version     1.0                                                                
 * 
 * @changelog
 * 2017-01-24 Chen Chen <chen.b.chen@capgemini.com>
 * - Created
 *    
 */
global class BatchCls_UpdateOppyGamCode implements Database.Batchable<sObject> {
    
    global String str_query;
    
    global Database.QueryLocator start(Database.BatchableContext BC){
    	str_query = 'select id From Opportunity';
    	str_query += ' where (RecordType.DeveloperName = \'Opportunity_Sales_Parts_Only\' Or RecordType.DeveloperName = \'Opportunity_Engineering_Project\') and  Owner.Profile.Name like \'%Appliance%\' and StageName != \'Lost/Dead – closed\' and StageName != \'Rejected – Closed\'';
        return Database.getQueryLocator(str_query);
    }
    
    global void execute(Database.BatchableContext BC, list<Opportunity> list_oppys){
    	set<String> set_oppyIds = new set<String>();
    	list<Opportunity> list_opps = new list<Opportunity>();
    	
    	for(Opportunity oppy : list_oppys) {
    		set_oppyIds.add(oppy.id);
    	}
    	
    	list_opps = ClsOppyPartnerUtil.updateOppyGamCode(set_oppyIds);
    	
    	if(list_opps.size() > 0) {
            update list_opps;
    	}
    }
    
    global void finish(Database.BatchableContext BC){
    	
    }
}