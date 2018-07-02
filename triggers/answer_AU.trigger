/**
 * This trigger is on Quality_Assessment_Answer__c and that is used to calculate opportunity stage
 * 
 * @author Jinbo Shan
 * @created 2014-01-26
 * @version 1.0
 * @since 28.0
 * 
 * @changelog
 * 2014-01-26 Jinbo Shan <jinbo.shan@itbconsult.com>
 * - Created
 */
trigger answer_AU on Quality_Assessment_Answer__c (after insert, after update) {
	list<Opportunity> list_oppys4update = new list<Opportunity>();
	set<Id> set_answerIds = new set<Id>();
	map<string, string> map_oppyId_stageName = new map<string, string>();
	set<string> set_stageName = new set<string>();
	set<Id> set_oppyId = new set<Id>();
	map<Id, Opportunity> map_oppyId_oppy = new map<Id, Opportunity>();
	
	if(!ClsPMV_Util.dontChangeStage) {
		for(OpportunityStage os : [select MasterLabel from OpportunityStage where IsActive = true and IsClosed = true and IsWon = false]){
			set_stageName.add(os.MasterLabel);
		}
		//for recalculating Opportunity Stage
		for(Quality_Assessment_Answer__c qaa : [select Id, Opportunity__r.Approval_Status_PMV__c, 
												Opportunity__c from Quality_Assessment_Answer__c 
												where Opportunity__r.StageName NOT IN :set_stageName 
												and Id IN :trigger.newMap.keySet()]){
			if(qaa.Opportunity__r.Approval_Status_PMV__c != 'G0 In Approval' && qaa.Opportunity__r.Approval_Status_PMV__c != 'Conversion In Approval'){
				set_answerIds.add(qaa.Id);
			}
		}
		//for calculate All_Stage_Color and Overall_Progress for Opportunity
		for(Quality_Assessment_Answer__c qaa : [select Id, Opportunity__r.Approval_Status_PMV__c, 
												Opportunity__c 
												from Quality_Assessment_Answer__c 
												where Id IN :trigger.newMap.keySet()]) {
			set_oppyId.add(qaa.Opportunity__c);
		}
		
		if(set_oppyId.size()>0){
			map_oppyId_oppy.putAll(ClsPMV_Util.calculateOppyWhenAnswerChanged(set_oppyId));
		}
		if(set_answerIds.size()>0){
			map_oppyId_stageName.putAll(ClsPMV_Util.calculateOppyStage(set_answerIds));
		}
		
		if(map_oppyId_stageName.size()>0 || map_oppyId_oppy.size()>0){
			for(Opportunity oppy : [SELECT Id, StageName, Last_Modified_Date__c FROM Opportunity WHERE (Id IN : map_oppyId_stageName.keySet() OR Id IN :map_oppyId_oppy.keySet())  AND Approval_Status_PMV__c != 'G0 In Approval' AND Approval_Status_PMV__c != 'Conversion In Approval']){
				if(map_oppyId_stageName.containsKey(oppy.Id)){
					oppy.StageName = map_oppyId_stageName.get(oppy.Id);
				}
				if(map_oppyId_oppy.containsKey(oppy.Id)){
					oppy.All_Stage_Color__c = map_oppyId_oppy.get(oppy.Id).All_Stage_Color__c;
					oppy.Overall_Process__c = map_oppyId_oppy.get(oppy.Id).Overall_Process__c;
				}
				//oppy.Last_Modified_Date__c = system.now();
				list_oppys4update.add(oppy);
			}
		}
		if(list_oppys4update.size()>0){
			update list_oppys4update;
		}
	}
}