/** 
*    trigger to update the campaign member id on contact
*
@author Xia Tong
@created 2013-01-31 
@version 1.0
@since 23.0 (Force.com ApiVersion)
*
@changelog
* 2013-01-31 Xia Tong <xia.tong@itbconsult.com>
* - Created
*/

trigger Campaign_AU_updateCampaignMemberIdonContact on Campaign (after update) {
	set<Id> set_campaignId = new set<Id>();
	set<Id> set_inactiveCampaignId = new set<Id>();
	map<Id,Id> map_conId_memberId= new map<Id,Id>();
	List<Contact> list_contact = new List<Contact>();
	set<Id> set_inactiveConId = new set<Id>();
	for(Campaign cam: trigger.new){
		if(cam.IsActive && cam.IsActive != trigger.oldMap.get(cam.Id).IsActive){
			set_campaignId.add(cam.Id);
		}
		if(!cam.IsActive && cam.IsActive != trigger.oldMap.get(cam.Id).IsActive){
			set_inactiveCampaignId.add(cam.Id);
		}
	}
	
	if(!set_campaignId.isEmpty()){
		for(CampaignMember cm: [select id, ContactId,CampaignId from CampaignMember where CampaignId in: set_campaignId or CampaignId in: set_inactiveCampaignId]){
			if(set_campaignId.contains(cm.CampaignId)){
				map_conId_memberId.put(cm.ContactId,cm.Id);	
			}else{
				set_inactiveConId.add(cm.ContactId);
			}
		}
	}
	if(!set_inactiveConId.isEmpty()){
		for(CampaignMember cm: [select id, ContactId,CampaignId from CampaignMember where ContactId in:set_inactiveConId and Campaign.RecordType.DeveloperName='NPS' and Campaign.IsActive=true order by Campaign.StartDate desc]){
			map_conId_memberId.put(cm.ContactId,cm.Id);	
		}
	}
	
	if(!map_conId_memberId.isEmpty()){
        list<contact> list_con = new list<Contact>();
        for(Contact con: [SELECT id, Campaign_Member_ID__c FROM Contact where id in: map_conId_memberId.keySet()]){
            con.Campaign_Member_ID__c = map_conId_memberId.get(con.Id);
            list_con.add(con);
        }
        if(!list_con.isEmpty()) update list_con;
    }
    
    
}