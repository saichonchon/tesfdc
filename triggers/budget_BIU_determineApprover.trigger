/**
 * This trigger is used to determine the Budget Owners Manager, to save it on the Budget Record for the Approval Process.
 * In addition when the Budget is submitted for Approval, the budget totals will be copied in the original fields.
 *
 * @author      Frederic Faisst
 * @created     2012-05-24
 * @since       23.0 (Force.com ApiVersion)      
 * @version     1.0 
 *
 * @changelog
 * 2012-05-24 Frederic Faisst <frederic.faisst@itbconsult.com>
 * - Created
 */

trigger budget_BIU_determineApprover on Budget__c (before insert, before update) {
	
	/*
	*	Collections & Variables
	*/
	Set<String> set_teNetworkIds = new Set<String>();
	Map<String, Id> map_teNetworkId_userId = new Map<String, Id>();
	
	//For all Budget records in Trigger loop
	for(Budget__c b : Trigger.new){
		//If Insert & Territory is linked
		if(Trigger.isInsert && b.Territory__c != null){
			//Add TE Network Id to set
			set_teNetworkIds.add(b.Level_6_Assigned_User_Network_Id__c);
		}
		//If Update & Territory is linked & Territory changed
		else if(Trigger.isUpdate && b.Territory__c != null && Trigger.oldMap.get(b.Id).Territory__c != b.Territory__c){
			//Add TE Network Id to set
			set_teNetworkIds.add(b.Level_6_Assigned_User_Network_Id__c);
		}
		
		/* TODO...
		//If Update & Stage equal to "Original" & Budget submitted for Approval
		if(Trigger.isUpdate && b.Stage__c == 'Original' && b.Status__c == 'Submitted'){
			//Copy Total Budget into Original
			b.Original_CMA_Budget__c = b.Final_CMA_Budget__c;
			b.Original_Direct_Budget__c = b.Final_Direct_Budget__c;
			b.Original_POS_Budget__c = b.Final_POS_Budget__c;
		}
		*/
	}
	
	if(!set_teNetworkIds.isEmpty()){
		//Retrieve User Ids related to TE Network Ids and store them in map
		for(User u : [Select Id, Te_Network_Id__c From User Where Te_Network_Id__c in :set_teNetworkIds]){
			map_teNetworkId_userId.put(u.Te_Network_Id__c, u.Id);
		}
		
		//For all Budget records in Trigger loop. Define Manager.
		for(Budget__c b : Trigger.new){
			if(Trigger.isInsert && b.Territory__c != null){
				if(map_teNetworkId_userId.containsKey(b.Level_6_Assigned_User_Network_Id__c)){
					//b.Manager__c = map_teNetworkId_userId.get(b.Level_6_Assigned_User_Network_Id__c);
				}
			}
			//If Update & Territory is linked & Territory changed
			else if(Trigger.isUpdate && b.Territory__c != null && Trigger.oldMap.get(b.Id).Territory__c != b.Territory__c){
				if(map_teNetworkId_userId.containsKey(b.Level_6_Assigned_User_Network_Id__c)){
					//b.Manager__c = map_teNetworkId_userId.get(b.Level_6_Assigned_User_Network_Id__c);
				}
			}			
		}
	}
}