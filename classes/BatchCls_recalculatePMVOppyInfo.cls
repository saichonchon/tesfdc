/**
 * 
 *   This batch class is used to recalculate PMV Opportunities stage and other information
 *
 * @author      Jinbo Shan
 * @created     2014-04-11
 * @since       29.0     
 * @version     1.0                                                                
 * 
 * @changelog
 * 2014-04-11 Jinbo Shan <jinbo.shan@itbconsult.com>
 * - Created
 *    
 */
global class BatchCls_recalculatePMVOppyInfo implements Database.Batchable<SObject>, Database.Stateful{
	global Database.QueryLocator start(Database.BatchableContext BC){
		set<Id> set_oppyrtIds = ClsPMV_Util.getAllPMVRecordtypes();
		set<String> set_stages = new set<String>{'Lost', 'Dead', 'On Hold'};
		string sql = 'select Id from Opportunity where RecordTypeId IN :set_oppyrtIds and PMV_Type__c != null and StageName not IN :set_stages';
        system.debug('**@@@sql = ' + sql);
        return Database.getQueryLocator(sql);
    }
    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
    	set<Id> set_oppyIds = new set<Id>();
    	for(Opportunity oppy : scope) {
    		set_oppyIds.add(oppy.Id);
    	}
    	//try{
		ClsPMV_Util.recalculateOppyStage(set_oppyIds);
    	//}catch(Exception e){
    	//	system.debug(e);
    	//}
    }
    global void finish(Database.BatchableContext BC){  
    	
    }
}