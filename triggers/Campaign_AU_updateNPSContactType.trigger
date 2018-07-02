/** 
*    trigger to update NPS Contact Type
*
@author lili zhao
@created 2014-10-08 
@version 1.0
@since 23.0 (Force.com ApiVersion)
*
@changelog
* 2014-10-08 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
trigger Campaign_AU_updateNPSContactType on Campaign (after update) {
    map<id,map<id,id>> map_camId_conId_type = new map<id,map<id,id>>(); 
    map<Id, String> map_conId_type = new map<Id, String>();
    list<Contact> list_cons = new list<Contact>();  
    set<String> set_camIds = new set<String>();
    // get the Campaign Id when the Campaign_Type__c changed
    for(Campaign cm: trigger.new){
        if(cm.Campaign_Type__c != trigger.oldMap.get(cm.Id).Campaign_Type__c && cm.IsActive) {
            set_camIds.add(cm.Id);
        }
    }
    //get the CampaignMember as the CampaignId
    if(set_camIds.size() > 0) {
        for(CampaignMember cm : [Select Id, CampaignId, Campaign.Campaign_Type__c, ContactId  
                                 From CampaignMember
                                 Where CampaignId in : set_camIds]) {
            map_conId_type.put(cm.ContactId, cm.Campaign.Campaign_Type__c);                             
         }
    }
    //get the contact as the CampaignMember.ContactId
    if(map_conId_type.size() > 0) {
        for(Contact con: [SELECT id, Campaign_Type__c  FROM Contact 
                          where (id in: map_conId_type.keySet())]){
            if(map_conId_type.containsKey(con.Id)) {
                con.Campaign_Type__c = map_conId_type.get(con.Id);    
                list_cons.add(con);             
            }   
        }
    }
    // update the contact
    if(list_cons.size() > 0) {
        update list_cons;
    }
    

}