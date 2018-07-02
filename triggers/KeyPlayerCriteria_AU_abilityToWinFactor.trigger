/**
 *  This trigger is used to ability to win factor for related Opportunity
 *  
 * @author Jinbo Shan
 * @created 2014-06-10
 * @version 1.0
 * @since 29.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2014-06-10 Jinbo Shan <jinbo.shan@itbconsult.com>
 * - Created   
 *
 */
trigger KeyPlayerCriteria_AU_abilityToWinFactor on Key_Player_Criteria__c (after update) {
	set<Id> set_oppyIds = new set<Id>();
	for(Key_Player_Criteria__c kpc : [select Id, Priority__c, Decision_Criteria__r.Opportunity__c from Key_Player_Criteria__c where Id IN : trigger.newMap.keySet()]) {
		if(kpc.Priority__c != trigger.oldMap.get(kpc.Id).Priority__c) { 
			set_oppyIds.add(kpc.Decision_Criteria__r.Opportunity__c);
		}
	}
	if(set_oppyIds.size() > 0){
		ClsPMV_Util.abilityToWinCalculationForCriteria(set_oppyIds);
	}
}