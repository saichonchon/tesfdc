/**
    * This trigger is used to Calculate the average NPS_Sore__c for the related opportunity when Contact.NPS_Score__c changed
    *
    @author     Jinbo Shan
    @created    2014-06-06
    @version    1.0
    @since      29.0 (Force.com ApiVersion)
    *          
    *
    @changelog
    * 2014-06-06 Jinbo Shan <jinbo.shan@itbconsult.com>
    * - Created
    */
trigger Contact_AUBD_updateOpportunityNPSScore on Contact (after update, before delete) {
	
	set<Id> set_conIds = new set<Id>();
	set<Id> set_conIdsDeleted = new set<Id>();
	if(trigger.isUpdate) { 
		for(Contact con : trigger.new) {
			if(con.NPS_Score__c != trigger.oldMap.get(con.Id).NPS_Score__c) {
				set_conIds.add(con.Id);
			}
		}
	}else {
		for(Contact con : trigger.old) {
			set_conIds.add(con.Id);
			set_conIdsDeleted.add(con.Id);
		}
	}
	if(set_conIds.size() > 0){
		ClsPMV_Util.updateOpportunityNPSScoreWhenContactChanged(set_conIds, set_conIdsDeleted);
	}
	
}