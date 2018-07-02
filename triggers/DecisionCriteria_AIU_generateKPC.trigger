/**
    *   trigger to generate key player criteria records after decision criteria records are inserted or updated 
    *
    @author Yuanyuan Zhang
    @created 2014-03-18
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-11 Jinbo Shan <jinbo.shan@itbconsult.com>
    * Ability to win factor for related Opportunity
    * 2014-03-18 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>  
    * - Created  
    */

trigger DecisionCriteria_AIU_generateKPC on Decision_Criteria__c (after insert, after update) {
	
	set<Id> set_oppyIds = new set<Id>();
	
	if(trigger.isInsert){
		List<Decision_Criteria__c> list_dc = new List<Decision_Criteria__c>();
		for(Decision_Criteria__c dc : trigger.new){
			if(dc.Active__c){
				list_dc.add(dc);
			}
		}
		ClsPMV_Util.createKeyPlayerCriteriasWithDecision(list_dc);
		//Start:ability to win factor for related Opportunity
		for(Decision_Criteria__c dc : trigger.new) {
			set_oppyIds.add(dc.Opportunity__c);
		}
		//End:
	}
	else if(trigger.isUpdate){
		List<Decision_Criteria__c> list_dc = new List<Decision_Criteria__c>();
		for(Decision_Criteria__c dc : trigger.new){
			if(dc.Active__c && dc.Active__c != trigger.oldmap.get(dc.Id).Active__c){
				list_dc.add(dc);
			}
		}
		if(list_dc.size() > 0) ClsPMV_Util.createKeyPlayerCriteriasWithDecisionForUpdate(list_dc);
		
		//Start:ability to win factor for related Opportunity
		for(Decision_Criteria__c dc : trigger.new) {
			if(dc.Position__c != trigger.oldMap.get(dc.Id).Position__c) {
				set_oppyIds.add(dc.Opportunity__c);
			}
		}
		//End:
	}
	
	if(set_oppyIds.size() > 0) {
		ClsPMV_Util.abilityToWinCalculationForCriteria(set_oppyIds);
	}
	
}