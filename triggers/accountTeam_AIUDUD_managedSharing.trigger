/**
 * This trigger used to manage Sharing of Account_Team__c.
 *
 * @author      Yinfeng Guo
 * @created     2012-02-09
 * @since       23.0 (Force.com ApiVersion)      
 * @version     1.0 
 *
 * @changelog
 * 2012-02-09 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Created
 * 2012-05-04 Frederic Faisst <frederic.faisst@itbconsult.com>
 * - New Requirement: The role "GAM" must be considered. Each "GAM" must be retrieved from custom account team object and stored in standard account team
 */
trigger accountTeam_AIUDUD_managedSharing on Account_Team__c (after delete, after insert, after undelete, after update) {

    String triggerName = 'Account_Team__c';

    String rolesList;
    set<String> set_roles = new set<String>();
	if(ClsSharingUtil.fireAccountTeamMemberTrigger){
	    //************************* BEGIN Pre-Processing **********************************************
	    //System.debug('************************* ' + triggerName + ': BEGIN Pre-Processing ********');
	    Id rt_sfdc_user = ClsSharingUtil.sfdcUserCustomSetting();
	    //************************* END Pre-Processing ************************************************
	    //System.debug('************************* ' + triggerName + ': END Pre-Processing **********');
	
	    //************************* BEGIN Before Trigger **********************************************
	    //************************* END Before Trigger ************************************************
	    
	    
	    //************************* BEGIN After Trigger *********************************************** 
	    if(rt_sfdc_user != null) {
	        
	        String uids;
	        //map<id, string> map_aid_uidList = new map<id, string>();
	        map<id, string> map_new_aid_uidList_ForAccountTeamMember = new map<id, string>();
	        map<id, string> map_old_aid_uidList_ForAccountTeamMember = new map<id, string>();
	        map<id, string> map_new_aid_uidList_ForAccountShare = new map<id, string>();
	        map<id, string> map_old_aid_uidList_ForAccountShare = new map<id, string>();
	        map<id, string> map_aid_uidList_ForAccountTeamMember = new map<id, string>();
	        map<id, string> map_aid_uidList_ForAccountShare = new map<id, string>();
	        if(trigger.isInsert || trigger.isUnDelete) {
	            for (Account_Team__c accTeam : trigger.new) { 
	                //if statement is to validate : whether is rt_sfdc_user, and the account id and the user id not null
	                if(accTeam.RecordTypeId != null && accTeam.RecordTypeId == rt_sfdc_user && accTeam.Account__c != null && accTeam.Team_Member__c != null) {
	
	                    if(!map_aid_uidList_ForAccountTeamMember.containsKey(accTeam.Account__c)) map_aid_uidList_ForAccountTeamMember.put(accTeam.Account__c, accTeam.Team_Member__c);
	                    else {
	                        uids = map_aid_uidList_ForAccountTeamMember.get(accTeam.Account__c);
	                        map_aid_uidList_ForAccountTeamMember.put(accTeam.Account__c, uids + ',' + accTeam.Team_Member__c);
	                    }
	                }
	            }
	            if(!map_aid_uidList_ForAccountTeamMember.isEmpty()) ClsSharingUtil.upsertAccountTeamMember(map_aid_uidList_ForAccountTeamMember);
	            if(!map_aid_uidList_ForAccountShare.isEmpty()) ClsSharingUtil.upsertAccountTeamShare(map_aid_uidList_ForAccountShare);
	        }
	
	        else if(trigger.isDelete){
	            for(Account_Team__c accTeam : trigger.old){
	                if(accTeam.RecordTypeId != null && accTeam.RecordTypeId == rt_sfdc_user && accTeam.Account__c != null && accTeam.Team_Member__c != null ) {
	                    //if(accTeam.Role__c == Role_AM || accTeam.Role__c == Role_FE  || accTeam.Role__c == Role_GAM ){
	                    /*if(set_roles.contains(accTeam.Role__c)){
	                    //Commented out 04.05.2012 by Frederic Faisst, ITBconsult because additional Role "GAM" must be considered.
	                    //if(accTeam.Role__c == Role_AM || accTeam.Role__c == Role_FE){
	                        if(!map_aid_uidList_ForAccountTeamMember.containsKey(accTeam.Account__c)) map_aid_uidList_ForAccountTeamMember.put(accTeam.Account__c, accTeam.Team_Member__c);
	                        else {
	                            uids = map_aid_uidList_ForAccountTeamMember.get(accTeam.Account__c);
	                            map_aid_uidList_ForAccountTeamMember.put(accTeam.Account__c, uids + ',' + accTeam.Team_Member__c);
	                        }   
	                    }
	                    else{
	                        if(!map_aid_uidList_ForAccountShare.containsKey(accTeam.Account__c)) map_aid_uidList_ForAccountShare.put(accTeam.Account__c, accTeam.Team_Member__c);
	                        else {
	                            uids = map_aid_uidList_ForAccountShare.get(accTeam.Account__c);
	                            map_aid_uidList_ForAccountShare.put(accTeam.Account__c, uids + ',' + accTeam.Team_Member__c);
	                        }
	                    }*/
	                    if(accTeam.Team_Member__c != null){
		                    if(!map_aid_uidList_ForAccountTeamMember.containsKey(accTeam.Account__c)) map_aid_uidList_ForAccountTeamMember.put(accTeam.Account__c, accTeam.Team_Member__c);
		                    else {
		                        uids = map_aid_uidList_ForAccountTeamMember.get(accTeam.Account__c);
		                        map_aid_uidList_ForAccountTeamMember.put(accTeam.Account__c, uids + ',' + accTeam.Team_Member__c);
		                    }	
	                    }
	                }
	                
	            }
	            if(!map_aid_uidList_ForAccountTeamMember.isEmpty()) ClsSharingUtil.deleteAccountTeamMember(map_aid_uidList_ForAccountTeamMember);
	            if(!map_aid_uidList_ForAccountShare.isEmpty()) ClsSharingUtil.deleteAccountTeamShare(map_aid_uidList_ForAccountShare);
	        }
	        
	        else if(trigger.isUpdate){
	            for(Account_Team__c accTeam : trigger.new){
	                if(accTeam.Team_Member__c != trigger.oldMap.get(accTeam.Id).Team_Member__c || accTeam.Role__c != trigger.oldMap.get(accTeam.Id).Role__c || accTeam.Opportunity_Access__c != trigger.oldMap.get(accTeam.Id).Opportunity_Access__c){
	                    if(accTeam.RecordTypeId != null && accTeam.RecordTypeId == rt_sfdc_user && accTeam.Account__c != null) {
	                        //if(accTeam.Role__c == Role_AM || accTeam.Role__c == Role_FE || accTeam.Role__c == Role_GAM){
	                        /*if(set_roles.contains(accTeam.Role__c)){    
	                        //Commented out 04.05.2012 by Frederic Faisst, ITBconsult because additional Role "GAM" must be considered.
	                        //if(accTeam.Role__c == Role_AM || accTeam.Role__c == Role_FE){
	                            if(!map_new_aid_uidList_ForAccountTeamMember.containsKey(accTeam.Account__c)) {
	                                map_new_aid_uidList_ForAccountTeamMember.put(accTeam.Account__c, accTeam.Team_Member__c);
	                            }
	                            else {
	                                uids = map_new_aid_uidList_ForAccountTeamMember.get(accTeam.Account__c);
	                                map_new_aid_uidList_ForAccountTeamMember.put(accTeam.Account__c, uids + ',' + accTeam.Team_Member__c);
	                            }
	                        }
	                        else{
	                            if(!map_new_aid_uidList_ForAccountShare.containsKey(accTeam.Account__c)) {
	                                map_new_aid_uidList_ForAccountShare.put(accTeam.Account__c, accTeam.Team_Member__c);
	                            }
	                            else {
	                                uids = map_new_aid_uidList_ForAccountShare.get(accTeam.Account__c);
	                                map_new_aid_uidList_ForAccountShare.put(accTeam.Account__c, uids + ',' + accTeam.Team_Member__c);
	                            }
	                        }*/
	                        if(accTeam.Team_Member__c != null){
		                        if(!map_new_aid_uidList_ForAccountTeamMember.containsKey(accTeam.Account__c)) {
		                        	map_new_aid_uidList_ForAccountTeamMember.put(accTeam.Account__c, accTeam.Team_Member__c);
		                        }
		                        else {
		                            uids = map_new_aid_uidList_ForAccountTeamMember.get(accTeam.Account__c);
		                            map_new_aid_uidList_ForAccountTeamMember.put(accTeam.Account__c, uids + ',' + accTeam.Team_Member__c);
		                        }	
	                        }
	                        
	                        //if(trigger.oldMap.get(accTeam.id).Role__c == Role_AM || trigger.oldMap.get(accTeam.id).Role__c == Role_FE){
	                        /*if(set_roles.contains(trigger.oldMap.get(accTeam.id).Role__c) ){
	                            if(!map_old_aid_uidList_ForAccountTeamMember.containsKey(trigger.oldMap.get(accTeam.id).Account__c)) {
	                                map_old_aid_uidList_ForAccountTeamMember.put(trigger.oldMap.get(accTeam.id).Account__c, trigger.oldMap.get(accTeam.id).Team_Member__c);
	                            }
	                            else {
	                                uids = map_old_aid_uidList_ForAccountTeamMember.get(trigger.oldMap.get(accTeam.id).Account__c);
	                                map_old_aid_uidList_ForAccountTeamMember.put(trigger.oldMap.get(accTeam.id).Account__c, uids + ',' + trigger.oldMap.get(accTeam.id).Team_Member__c);
	                            }
	                        }
	                        else if(trigger.oldMap.get(accTeam.id).Team_Member__c != accTeam.Team_Member__c){
	                            if(!map_old_aid_uidList_ForAccountShare.containsKey(trigger.oldMap.get(accTeam.id).Account__c)) {
	                                map_old_aid_uidList_ForAccountShare.put(trigger.oldMap.get(accTeam.id).Account__c, trigger.oldMap.get(accTeam.id).Team_Member__c);
	                            }
	                            else {
	                                uids = map_old_aid_uidList_ForAccountShare.get(trigger.oldMap.get(accTeam.id).Account__c);
	                                map_old_aid_uidList_ForAccountShare.put(trigger.oldMap.get(accTeam.id).Account__c, uids + ',' + trigger.oldMap.get(accTeam.id).Team_Member__c);
	                            }
	                        }*/
	                        if(trigger.oldMap.get(accTeam.id).Team_Member__c != null){
		                        if(!map_old_aid_uidList_ForAccountTeamMember.containsKey(trigger.oldMap.get(accTeam.id).Account__c)) {
		                            map_old_aid_uidList_ForAccountTeamMember.put(trigger.oldMap.get(accTeam.id).Account__c, trigger.oldMap.get(accTeam.id).Team_Member__c);
		                        }
		                        else {
		                            uids = map_old_aid_uidList_ForAccountTeamMember.get(trigger.oldMap.get(accTeam.id).Account__c);
		                            map_old_aid_uidList_ForAccountTeamMember.put(trigger.oldMap.get(accTeam.id).Account__c, uids + ',' + trigger.oldMap.get(accTeam.id).Team_Member__c);
		                        }	
	                        }
	                    }                   
	                }
	            }
	            if(!map_old_aid_uidList_ForAccountTeamMember.isEmpty()) ClsSharingUtil.deleteAccountTeamMember(map_old_aid_uidList_ForAccountTeamMember);
	            if(!map_new_aid_uidList_ForAccountTeamMember.isEmpty()) ClsSharingUtil.upsertAccountTeamMember(map_new_aid_uidList_ForAccountTeamMember);
	            if(!map_old_aid_uidList_ForAccountShare.isEmpty()) ClsSharingUtil.deleteAccountTeamShare(map_old_aid_uidList_ForAccountShare);
	            if(!map_new_aid_uidList_ForAccountShare.isEmpty()) ClsSharingUtil.upsertAccountTeamShare(map_new_aid_uidList_ForAccountShare);          
	        }
	    }
	}
    //************************* END After Trigger *************************************************
}