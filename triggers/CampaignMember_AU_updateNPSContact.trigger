/** 
*    trigger to update NPS contact
*
@author Xia Tong
@created 2012-12-18 
@version 1.0
@since 23.0 (Force.com ApiVersion)
*
@changelog
* 2012-12-18 Xia Tong <xia.tong@itbconsult.com>
* - Created
* 2013-01-10 Min Liu <min.liu@itbconsult.com>
* - Added: Generate Task
* 2013-01-31 Min Liu <min.liu@itbconsult.com>
* - Modified: Active campaign's campaign member id set on contact
* 2013-03-15 Xia Tong <xia.tong@itbconsult.com>
* - Modified: APL NPS custom setting    
* 2013-09-10 Bin Yu <bin.yu@itbconsult.com>
* - added: Enhance the actual code to create the follow-up tasks with a link to the NPS result.
* 2014-04-29 Bin Yuan <bin.yuan@itbconsult.com>
* - added: Enhance to create tasks for Campaign Name and Survey Name contains “TTI” and nsp score 0~6.
* 2014-05-04 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
* - added: Enhance to create tasks for Campaign Name and Survey Name contains “Medical” and nsp score 0~6.
* 2014-05-26 Lili Zhao <lili.zhao@itbconsult.com>
* - added: Enhance to create tasks for Campaign type equal “Medical” and nsp score 0~6.
* 2014-06-17 Lili Zhao <lili.zhao@itbconsult.com>
* - added: Enhance to set the recordType of tasks,if the Campaign type equal “Appliance”,the recordType is recordType rt of 'NPS Task Appliances';other Campaign type the recordType is recordType rt of 'NPS Task Industrial'.
* 2014-06-30 Lili Zhao <lili.zhao@itbconsult.com>
* - added: IF Campaign_Type__c = "none" than no follow up task should be created,add the code of (set_industriesType.contains(con.Id) || set_applianceType.contains(con.Id))
* 2014-06-30 Lili Zhao <lili.zhao@itbconsult.com>
* - added: new requirement to set Score 0 -> Territory Level 1 and Score 1-4 -> Territory Level 2 
* 2014-10-16 Lili Zhao <lili.zhao@itbconsult.com>
* - added: new requirement  
*/

trigger CampaignMember_AU_updateNPSContact on CampaignMember (after update, after insert) {
   
    set<String> set_compaignMembIds = new set<String>(); 
    //set<String> set_comMembIds = new set<String>();
    map<id,map<id,id>> map_campaignId_conId_memberId = new map<id,map<id,id>>();//added by xia 2013-01-31    
    map<Id,String> map_conId_language= new map<Id,String>();
    map<Id,boolean> map_conId_optout= new map<Id,boolean>();
    map<Id,Id> map_conId_campaignId = new map<Id,Id>();           
    map<String, String> map_rtName_rtId = new map<String, String>();
    
    for(RecordType recordType : [Select Name, Id 
                                 From RecordType 
                                 where SobjectType = 'Task' 
                                 and (Name='NPS Task Appliances' or Name='NPS Task Industrial' or Name='NPS Task Standard')]) {
        map_rtName_rtId.put(recordType.Name, recordType.Id);
    }    
     
    for(CampaignMember cm: trigger.new){
        if(Trigger.isUpdate){
            if(cm.NPS_OPT_OUT__c != trigger.oldMap.get(cm.Id).NPS_OPT_OUT__c){
                map_conId_optout.put(cm.ContactId,cm.NPS_OPT_OUT__c);
                set_compaignMembIds.add(cm.Id);
            }
            if(cm.Status == 'Responded' && cm.Status != trigger.oldMap.get(cm.Id).Status){
                map_conId_language.put(cm.ContactId,cm.NPS_Language__c);
                map_conId_campaignId.put(cm.ContactId,cm.CampaignId);
                set_compaignMembIds.add(cm.Id);
            }
            if(cm.ContactId != trigger.oldMap.get(cm.Id).ContactId){
                if(!map_campaignId_conId_memberId.containsKey(cm.CampaignId)){
                    map_campaignId_conId_memberId.put(cm.CampaignId,new map<id,id>());
                }
                map_campaignId_conId_memberId.get(cm.CampaignId).put(cm.ContactId,cm.Id);
                set_compaignMembIds.add(cm.Id);
            }
        }
        if(Trigger.isInsert){
            if(!map_campaignId_conId_memberId.containsKey(cm.CampaignId)){
                map_campaignId_conId_memberId.put(cm.CampaignId,new map<id,id>());
            }
            map_campaignId_conId_memberId.get(cm.CampaignId).put(cm.ContactId,cm.Id);
        }
    }

    if(!map_conId_campaignId.isEmpty() || !set_compaignMembIds.isEmpty() || !map_conId_language.isEmpty() || !map_conId_optout.isEmpty()){
        ClsCampaignMemberUtil.setContactTask(map_conId_optout, map_conId_language, map_conId_campaignId, set_compaignMembIds, map_rtName_rtId );
    }

    // update the contact
    if(!map_campaignId_conId_memberId.isEmpty()){
        ClsCampaignMemberUtil.updateContact(map_campaignId_conId_memberId);
    }  
    
}