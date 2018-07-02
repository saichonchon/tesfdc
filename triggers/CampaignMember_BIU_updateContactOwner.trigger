/** 
*    trigger to update Contact Owner field on CampaignMember where contact changed.
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

trigger CampaignMember_BIU_updateContactOwner on CampaignMember (before insert, before update) {
	map<Id,set<CampaignMember>> map_conId_cm = new map<Id,set<CampaignMember>>();
	for(CampaignMember cm: trigger.new){
		if(cm.ContactId != null && !map_conId_cm.containsKey(cm.ContactId)){
			map_conId_cm.put(cm.ContactId, new set<CampaignMember>());
		}
		if(map_conId_cm.containsKey(cm.ContactId)) {
			map_conId_cm.get(cm.ContactId).add(cm);
		}
	
	}
	
	if(!map_conId_cm.isEmpty()){
		for(Contact con: [select id, OwnerId from Contact where id in: map_conId_cm.keySet()]){
			for(CampaignMember cm: map_conId_cm.get(con.Id)){
				cm.Contact_Owner__c = con.OwnerId;
			}
		}
	}
}