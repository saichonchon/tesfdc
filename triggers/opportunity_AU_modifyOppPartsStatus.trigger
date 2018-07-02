/**
 * This trigger used to modify Opportunity Parts Status after update opportunity. 
 *
 * @author      Yinfeng Guo
 * @created     2012-03-07
 * @since       23.0 (Force.com ApiVersion)      
 * @version     1.0 
 *
 * @changelog
 * 2012-03-07 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Created 
 * 2012-03-14 Frederic Faisst <frederic.faisst@itbconsult.com>
 * - Opportunity Part Status Update 
 * 2012-03-21 Frederic Faisst <frederic.faisst@itbconsult.com>
 * - Opportunity Competitor Update
 */

trigger opportunity_AU_modifyOppPartsStatus on Opportunity (after update) {
	
	/*
	 *	Collections and Variables
	 */
	/*
	String triggerName = 'Opportunity';
	//************************* BEGIN Pre-Processing **********************************************
	//System.debug('************************* ' + triggerName + ': BEGIN Pre-Processing ********');	
	Map<Id, String> map_oppdId_preProd = new Map<Id, String>();
	Map<Id, String> map_oppdId_new = new Map<Id, String>();
	Map<Id, String> map_oppdId_lost = new Map<Id, String>();
	Map<Id, String> map_oppdId_dead = new Map<Id, String>();
	Map<Id, String> map_oppdId_onHold = new Map<Id, String>();
	Map<Id, String> map_oppdId_other = new Map<Id, String>();
	Map<Id, String> map_oppdId_otherReason = new Map<Id, String>();
	Map<Id, String> map_oppdId_reason = new Map<Id, String>();
	Map<Id, Id> map_oppdId_competitorId = new Map<Id, Id>();
	set<Id> set_oppIds = new set<Id>();
	//************************* END Pre-Processing ************************************************
	//System.debug('************************* ' + triggerName + ': END Pre-Processing **********');
	
	
	//************************* BEGIN Before Trigger **********************************************
	if(Trigger.isBefore) {
		System.debug('************************* ' + triggerName + ': Before Trigger ************');
	}
	//************************* END Before Trigger ************************************************
	
	
	//************************* BEGIN After Trigger ***********************************************
	if(Trigger.isAfter) {
		System.debug('************************* ' + triggerName + ': After Trigger *************');
		for(Opportunity oppy : trigger.new){
			if(Trigger.oldMap.get(oppy.Id).StageName != oppy.StageName){
			
				set_oppIds.add(oppy.Id);
				
				if(oppy.StageName == 'Pre-prod'){
					map_oppdId_preProd.put(oppy.Id, 'Pre-prod');
				}
				else if(oppy.StageName == 'Lost'){
					map_oppdId_lost.put(oppy.Id, 'Lost');
					if(oppy.Lost_Rejected_Dead_On_Hold_Reason__c == 'Competitor' && oppy.Competitor__c != null){
						map_oppdId_competitorId.put(oppy.Id, oppy.Competitor__c);
					}
				}
				else if(oppy.StageName == 'Dead'){
					map_oppdId_dead.put(oppy.Id, 'Dead');
				}
				else if(oppy.StageName == 'On Hold'){
					map_oppdId_onHold.put(oppy.Id, 'On Hold');
				}
				else if(Trigger.oldMap.get(oppy.Id).StageName == 'Lost' && oppy.StageName == 'New'){
					map_oppdId_new.put(oppy.Id, '50/50');
				}
				
				if(oppy.Lost_Rejected_Dead_On_Hold_Reason__c == 'Other'){
					map_oppdId_other.put(oppy.Id, 'Other');
					map_oppdId_otherReason.put(oppy.Id, oppy.Other_Description__c);
				}
				else if(oppy.Lost_Rejected_Dead_On_Hold_Reason__c != ''){
					map_oppdId_reason.put(oppy.Id, oppy.Lost_Rejected_Dead_On_Hold_Reason__c);
				}
			}
			
			System.debug('MAP OTHER REASON: ' + map_oppdId_otherReason);
			System.debug('MAP REASON: ' + map_oppdId_reason);
		}
		
		list<Opportunity_Part__c> list_oppParts2Update = new list<Opportunity_Part__c>();
		if(!set_oppIds.isEmpty()){
			for(Opportunity_Part__c oppPart : [Select Id, Status__c, Lost_Reason__c, Lost_Reason_Text__c, Opportunity__c from Opportunity_Part__c where Opportunity__c in :set_oppIds]){
				if(map_oppdId_preProd.containsKey(oppPart.Opportunity__c)){
					if(oppPart.Status__c == 'Likely' || oppPart.Status__c == '50/50' || oppPart.Status__c == 'Commit' || oppPart.Status__c == 'Weak'){
						oppPart.Status__c = 'Won';
					}
				}
				else if(map_oppdId_lost.containsKey(oppPart.Opportunity__c)){
					oppPart.Status__c = map_oppdId_lost.get(oppPart.Opportunity__c);
					
					System.debug('LOST REASON: ' + oppPart.Lost_Reason__c);
					System.debug('MAP REASON: ' + map_oppdId_otherReason.containsKey(oppPart.Opportunity__c));
					
					if(map_oppdId_competitorId.containsKey(oppPart.Opportunity__c)){
						oppPart.Competitor__c = map_oppdId_competitorId.get(oppPart.Opportunity__c);
					}
					
					if(oppPart.Lost_Reason__c == null && map_oppdId_otherReason.containsKey(oppPart.Opportunity__c)){
						oppPart.Lost_Reason__c = map_oppdId_lost.get(oppPart.Opportunity__c);
						oppPart.Lost_Reason_Text__c = map_oppdId_otherReason.get(oppPart.Opportunity__c);	
					}
					else if(oppPart.Lost_Reason__c == null && map_oppdId_reason.containsKey(oppPart.Opportunity__c)){
						oppPart.Lost_Reason__c = map_oppdId_reason.get(oppPart.Opportunity__c);					
					}
				}
				else if(map_oppdId_dead.containsKey(oppPart.Opportunity__c)){
					oppPart.Status__c = map_oppdId_dead.get(oppPart.Opportunity__c);
					
					if(oppPart.Lost_Reason__c == null && map_oppdId_otherReason.containsKey(oppPart.Opportunity__c)){
						oppPart.Lost_Reason__c = map_oppdId_dead.get(oppPart.Opportunity__c);
						oppPart.Lost_Reason_Text__c = map_oppdId_otherReason.get(oppPart.Opportunity__c);	
					}
					else if(oppPart.Lost_Reason__c == null && map_oppdId_reason.containsKey(oppPart.Opportunity__c)){
						oppPart.Lost_Reason__c = map_oppdId_reason.get(oppPart.Opportunity__c);
					}
				}
				else if(map_oppdId_onHold.containsKey(oppPart.Opportunity__c)){
					if(oppPart.Status__c == 'Likely' || oppPart.Status__c == '50/50' || oppPart.Status__c == 'Commit' || oppPart.Status__c == 'Weak'){
						oppPart.Status__c = map_oppdId_onHold.get(oppPart.Opportunity__c);
						
						if(oppPart.Lost_Reason__c == null && map_oppdId_otherReason.containsKey(oppPart.Opportunity__c)){
							oppPart.Lost_Reason__c = map_oppdId_onHold.get(oppPart.Opportunity__c);
							oppPart.Lost_Reason_Text__c = map_oppdId_otherReason.get(oppPart.Opportunity__c);
						}
						else if(oppPart.Lost_Reason__c == null && map_oppdId_reason.containsKey(oppPart.Opportunity__c)){
							oppPart.Lost_Reason__c = map_oppdId_reason.get(oppPart.Opportunity__c);
						}
					}
				}
				else if(map_oppdId_new.containsKey(oppPart.Opportunity__c)){
					oppPart.Status__c = map_oppdId_new.get(oppPart.Opportunity__c);
				}
				
				list_oppParts2Update.add(oppPart);
			}
		}
		
		if(!list_oppParts2Update.isEmpty()) update list_oppParts2Update;	
	}
	//************************* END After Trigger *************************************************
	*/	

	

}