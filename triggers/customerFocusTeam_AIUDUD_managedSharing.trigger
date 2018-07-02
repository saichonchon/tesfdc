/**
 * This trigger used to manage Sharing of Customer_Focus_Team_Member__c.
 *
 * @author      Yinfeng Guo
 * @created     2012-02-27
 * @since       23.0 (Force.com ApiVersion)      
 * @version     1.0 
 *
 * @changelog
 * 2012-02-27 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Created 
 * 
 */

trigger customerFocusTeam_AIUDUD_managedSharing on Customer_Focus_Team_Member__c (after delete, after insert, after undelete, 
after update) {

	String triggerName = 'Customer_Focus_Team_Member__c';
	//************************* BEGIN Pre-Processing **********************************************
	//System.debug('************************* ' + triggerName + ': BEGIN Pre-Processing ********');
	map<id, string> map_aid_uidList = new map<id, string>();
	map<id, string> map_new_aid_uidList = new map<id, string>();
	map<id, string> map_old_aid_uidList = new map<id, string>();
	String uids;
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
		if(trigger.isInsert || trigger.isUnDelete) {
			for (Customer_Focus_Team_Member__c cusTeam : trigger.new) { 
				if(cusTeam.Global_Account_Lkp__c != null && cusTeam.Salesforce_User_Name__c != null) {
	    			if(!map_aid_uidList.containsKey(cusTeam.Global_Account_Lkp__c)) map_aid_uidList.put(cusTeam.Global_Account_Lkp__c, cusTeam.Salesforce_User_Name__c);
	    			else {
	    				uids = map_aid_uidList.get(cusTeam.Global_Account_Lkp__c);
	    				map_aid_uidList.put(cusTeam.Global_Account_Lkp__c, uids + ',' + cusTeam.Salesforce_User_Name__c);
	    			}
	    		}
			}
			if(!map_aid_uidList.isEmpty()) ClsSharingUtil.insertCustomerFocusTeamMember(map_aid_uidList);
		}
		else if(trigger.isDelete){
			for(Customer_Focus_Team_Member__c cusTeam : trigger.old){
	    		if(cusTeam.Global_Account_Lkp__c != null && cusTeam.Salesforce_User_Name__c != null) {
	    			if(!map_aid_uidList.containsKey(cusTeam.Global_Account_Lkp__c)) map_aid_uidList.put(cusTeam.Global_Account_Lkp__c, cusTeam.Salesforce_User_Name__c);
	    			else {
	    				uids = map_aid_uidList.get(cusTeam.Global_Account_Lkp__c);
	    				map_aid_uidList.put(cusTeam.Global_Account_Lkp__c, uids + ',' + cusTeam.Salesforce_User_Name__c);
	    			}
	    		}
	    	}
	    	if(!map_aid_uidList.isEmpty()) ClsSharingUtil.deleteCustomerFocusTeamMember(map_aid_uidList);
		}
		else if(trigger.isUpdate){
			for(Customer_Focus_Team_Member__c cusTeam : trigger.new){
				if(cusTeam.Global_Account_Lkp__c != trigger.oldMap.get(cusTeam.Id).Global_Account_Lkp__c || 
				cusTeam.Salesforce_User_Name__c != trigger.oldMap.get(cusTeam.Id).Salesforce_User_Name__c ||
				cusTeam.Role__c != trigger.oldMap.get(cusTeam.Id).Role__c)
				{
					if(cusTeam.Global_Account_Lkp__c != null && cusTeam.Salesforce_User_Name__c != null) {
		    			if(!map_new_aid_uidList.containsKey(cusTeam.Global_Account_Lkp__c)) {
		    				map_new_aid_uidList.put(cusTeam.Global_Account_Lkp__c, cusTeam.Salesforce_User_Name__c);
		    			}
		    			else {
		    				uids = map_new_aid_uidList.get(cusTeam.Global_Account_Lkp__c);
		    				map_new_aid_uidList.put(cusTeam.Global_Account_Lkp__c, uids + ',' + cusTeam.Salesforce_User_Name__c);
		    			}
		    			
		    			if(!map_old_aid_uidList.containsKey(trigger.oldMap.get(cusTeam.id).Global_Account_Lkp__c)) {
		    				map_old_aid_uidList.put(trigger.oldMap.get(cusTeam.id).Global_Account_Lkp__c, trigger.oldMap.get(cusTeam.id).Salesforce_User_Name__c);
		    			}
		    			else {
		    				uids = map_old_aid_uidList.get(trigger.oldMap.get(cusTeam.id).Global_Account_Lkp__c);
		    				map_old_aid_uidList.put(trigger.oldMap.get(cusTeam.id).Global_Account_Lkp__c, uids + ',' + trigger.oldMap.get(cusTeam.id).Salesforce_User_Name__c);
		    			}
	    			}				
				}
	    		
	    	}
			if(!map_old_aid_uidList.isEmpty()) ClsSharingUtil.deleteCustomerFocusTeamMember(map_old_aid_uidList);
			if(!map_new_aid_uidList.isEmpty()) ClsSharingUtil.insertCustomerFocusTeamMember(map_new_aid_uidList);		
		}		
	}
	//************************* END After Trigger *************************************************
		
}