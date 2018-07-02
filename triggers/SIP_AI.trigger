/**
 *  This trigger is used to sharing records to the plan participant, participants manager and plan approvers.
 *
 @  author Bin Yuan
 @  created 2013-09-09
 @  version 1.0
 @  since 28.0 (Force.com ApiVersion)
 *
 @  changelog
 *  2012-09-09 Bin Yuan <bin.yuan@itbconsult.com>
 *  - Created
 *  2014-09-25 Bin Yuan <bin.yuan@itbconsult.com>
 *  - Added PM type GPL fill logic
 *  2015-08-10 Bin Yuan <bin.yuan@oinio.com>
 *  - Change sharing logic : During record creation we only want to create the read/edit sharing for the approver 
 		and the manager but the plan participant should not have accees. The plan participant just should get read 
 		access as soon as the Plan is apporved for target means when Status__c(NOT(OR('Not Submitted','In Approval for Target','Rejected for Target'). 
 		If field Status__c has any other value than the three mentioned the plan participant should have read access.
 		
 *  2015-08-19 Bin Yuan <bin.yuan@oinio.com>
 *  - extends PM record type ids
 *  2015-09-30 Bin Yuan <bin.yuan@oinio.com>
 *  - Avoid assign sharing to the inactive users
 */
trigger SIP_AI on SIP__c (after insert) {
    String triggerName = 'SIP_AI';
    //************************* BEGIN Pre-Processing **********************************************
    //System.debug('************************* ' + triggerName + ': BEGIN Pre-Processing ********');
    //map<String, map<String, map<String, String>>> map_sipId_map_rowCause_map_userIds_access = new map<String, map<String, map<String, String>>>();
    map<String,map<String, String>> map_sipId_map_userIds_access = new map<String,map<String, String>>();
    String rowCause = 'Participant_And_Manager__c';
    map<String,String> map_access = new map<String,String>();   
    map_access = ClsSIPUitl.getAccess();
    //Added by Bin Yuan due to extends PM record type ids
	//Id pmRecordTypeId = ClsSIPUitl.getPMRTId();
	set<Id> set_pmRecordTypeIds = new set<Id>();
	set_pmRecordTypeIds = ClsSIPUitl.getPMRTId();
	
    map<String, set<SIP__c>> map_user_set_sips = new map<String, set<SIP__c>>();
    //String access = 'Edit';
    //************************* END Pre-Processing ************************************************
    //System.debug('************************* ' + triggerName + ': END Pre-Processing **********');
    //Participant_And_Manager__c
    
    //************************* BEGIN After Trigger ***********************************************
    if(Trigger.isAfter && trigger.isInsert) {
        System.debug('************************* ' + triggerName + ': After Trigger *************');
        for(SIP__c sip : [Select Id, Approver__c, Approver__r.isActive, Plan_Participant__r.ManagerId, Plan_Participant__r.Manager.isActive, Plan_Participant__c, Plan_Participant__r.isActive, GPLs__c, RecordTypeId From SIP__c Where Id IN : trigger.newMap.keySet()]) {
            if(sip.Approver__c != null && sip.Approver__r.isActive) {
                if(!map_sipId_map_userIds_access.containsKey(sip.Id)) {
                    map_sipId_map_userIds_access.put(sip.Id, new map<String, String>());
                }
                map_sipId_map_userIds_access.get(sip.Id).put(sip.Approver__c,map_access.get('Approver'));
            }
            //Comment by Bin Yuan 2015-08-10 due to change the sharing logic
            /*
            if(sip.Plan_Participant__c != null) {
                if(!map_sipId_map_userIds_access.containsKey(sip.Id)) {
                    map_sipId_map_userIds_access.put(sip.Id, new map<String, String>());
                }
                if(sip.Plan_Participant__c != sip.Approver__c) {
                    map_sipId_map_userIds_access.get(sip.Id).put(sip.Plan_Participant__c,map_access.get('Participant'));
                }else if(sip.Plan_Participant__c == sip.Approver__c) {
                    map_sipId_map_userIds_access.get(sip.Id).put(sip.Plan_Participant__c,map_access.get('Approver'));
                }
                
            }
            */
            if(sip.Plan_Participant__r.ManagerId != null && sip.Plan_Participant__r.Manager.isActive) {
                if(!map_sipId_map_userIds_access.containsKey(sip.Id)) {
                    map_sipId_map_userIds_access.put(sip.Id, new map<String, String>());
                }
                map_sipId_map_userIds_access.get(sip.Id).put(sip.Plan_Participant__r.ManagerId,map_access.get('Participant Manager'));
            }
            //Added PM type GPL fill logic
        	//Added by Bin Yuan due to extends PM Record type ids
        	if(set_pmRecordTypeIds.contains(sip.RecordTypeId) && sip.Plan_Participant__c != null) {
        		sip.GPLs__c = '';
        		if(!map_user_set_sips.containsKey(sip.Plan_Participant__c)) {
        			map_user_set_sips.put(sip.Plan_Participant__c, new set<SIP__c>());
        		}
        		map_user_set_sips.get(sip.Plan_Participant__c).add(sip);
        	}
        }
        if(!map_sipId_map_userIds_access.isEmpty()) {
            ClsSIPUitl.sharingToParticipant(map_sipId_map_userIds_access);
        }
        
        if(!map_user_set_sips.isEmpty()) {
        	ClsSIPUitl.fillGPLCodesForPMSIP(map_user_set_sips);
        }
    }
    
}