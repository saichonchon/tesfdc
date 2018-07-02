/** 
*    trigger to update Contact Owner field on CampaignMember where contact owner is changed.
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
trigger Contact_AU_updateCampaignMember on Contact (after update) {
	map<Id,Id> map_conId_ownerId = new map<Id,Id>();
	list<CampaignMember> list_cm2update = new list<CampaignMember>();
	for(Contact con: trigger.new){
		if(con.OwnerId != trigger.oldMap.get(con.Id).OwnerId){
			map_conId_ownerId.put(con.Id,con.OwnerId);
		}
	}
	
	if(!map_conId_ownerId.isEmpty()){
		for(CampaignMember cm: [select id, Contact_Owner__c, ContactId from CampaignMember where ContactId in: map_conId_ownerId.keySet()]){
			if(cm.Contact_Owner__c != map_conId_ownerId.get(cm.ContactId)){
				cm.Contact_Owner__c = map_conId_ownerId.get(cm.ContactId);
				list_cm2update.add(cm);
			}
		}
	}
	if(!list_cm2update.isEmpty()) update list_cm2update;
}