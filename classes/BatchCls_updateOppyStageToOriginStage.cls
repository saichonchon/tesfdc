/**
 * 
 *   This batch class is used to update PMV Opportunity Stage to Previous Stage
 *
 * @author      Jinbo Shan
 * @created     2015-07-21
 * @since       33.0     
 * @version     1.0                                                                
 * 
 * @changelog
 * 2014-04-11 Jinbo Shan <jinbo.shan@itbconsult.com>
 * - Created
 *    
 */
global class BatchCls_updateOppyStageToOriginStage implements Database.Batchable<SObject>, Database.Stateful{
	
	public set<String> set_stages = new set<String>{'Lost', 'Dead', 'On Hold'};
	
	global Database.QueryLocator start(Database.BatchableContext BC){
		set<Id> set_oppyrtIds = ClsPMV_Util.getAllPMVRecordtypes();
		string sql = 'select Id, Approval_Status_PMV__c, StageName from Opportunity where RecordTypeId IN :set_oppyrtIds and PMV_Type__c != null and StageName=\'Exploring Needs\'';
		return Database.getQueryLocator(sql);
	}
	global void execute(Database.BatchableContext BC, List<Opportunity> scope){
		
		list<Opportunity> list_oppy2update = new list<Opportunity>();
		
		set<Id> set_oppyIds = new set<Id>();
		set<Id> set_calculatedOppyId = new set<Id>();
		map<Id, String> map_oppyId_stageName = new map<Id, String>();
		for(Opportunity oppy : scope) {
			if(oppy.Approval_Status_PMV__c == 'G0 Rejected') {
				oppy.StageName='Lost';
				list_oppy2update.add(oppy);
			}else{
				set_oppyIds.add(oppy.Id);	
			}
		}
		
		for(OpportunityHistory oppyhis : [select OpportunityId, StageName from OpportunityHistory where OpportunityId IN :set_oppyIds order by CreatedDate desc]) {
			if(!set_calculatedOppyId.contains(oppyhis.OpportunityId)) {
				if (!map_oppyId_stageName.containsKey(oppyhis.OpportunityId)) {
					map_oppyId_stageName.put(oppyhis.OpportunityId, oppyhis.StageName);
				} else if(map_oppyId_stageName.get(oppyhis.OpportunityId) == 'Exploring Needs' && set_stages.contains(oppyhis.StageName)) {
					map_oppyId_stageName.put(oppyhis.OpportunityId, oppyhis.StageName);
				}else {
					set_calculatedOppyId.add(oppyhis.OpportunityId);
				}
			}
		}
		
		for(Opportunity oppy : [select Id, StageName from Opportunity where Id IN :map_oppyId_stageName.keySet()]) {
			if(set_stages.contains(map_oppyId_stageName.get(oppy.Id))) {
				oppy.StageName = map_oppyId_stageName.get(oppy.Id);
				list_oppy2update.add(oppy);
			}
		}
		if(list_oppy2update.size() > 0) {
			update list_oppy2update;
		}
	}
	global void finish(Database.BatchableContext BC){  
    	
    }
}