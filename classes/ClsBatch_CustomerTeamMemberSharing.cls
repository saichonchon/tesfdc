/**
 *  This class is used for re-calculation of the Group Member.
 *  
 * @author Yinfeng Guo
 * @created 2012-02-28
 * @version 1.0 (Force.com ApiVersion)  
 * @since 23.0
 * 
 *
 * @changelog
 * 2014-04-24 Bin Yuan <bin.yuan@itbconsult.com>
 * - Modified to add account manager as a public group member   
 * 2012-02-28 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Created   
 *
 */

global class ClsBatch_CustomerTeamMemberSharing implements Database.Batchable<SObject>{
	public set<String> set_code;
	/**
  	 * the email address to tell people the status of the batch class after run the batch class
	 * before run the batch class, we can define the email manual
	 * if not define email address, after the batch completed, will not send email
	 */	
	public String email;

	/**
  	 * the sql query statement that will select the data will be used in this batch class
	 */		
	public String query;
	
	/**
  	 * the record type id for gam account, the value get from custom setting
	 */		
	global final Id rt_cis_gam = ClsSharingUtil.gamCustomSetting();
	
	global Database.QueryLocator start(Database.BatchableContext BC){ 
		if (query == '' || query == null){
			//query = 'Select Id, ParentId, RecordTypeId, Public_Group_Id__c from Account' ;
			query = 'Select Id, Sales_Hierarchy_GAM__c,Sales_Hierarchy_MM__c, RecordTypeId, GAMCD__c,MKTMGRCDE__c,Type,Public_Group_Id__c, Account_Manager__c from Account'; //where (RecordTypeId =\'' + rt_cis_gam + '\' or RecordTypeId =\'' + rt_cis_account + '\') and (GAMCD__c != null or MKTMGRCDE__c != null)' ;
		
		}
	    return Database.getQueryLocator(query);  
	}

	global void execute(Database.BatchableContext BC, List<Account> list_accounts){
		String uids;
		
		map<String, String> map_acctId_managerId = new map<String, String>();	//Added by bin yuan 2014-04-24 for put account manager into public group
		set<Id> set_gamAccountIds = new set<Id>();
		for(Account a: list_accounts){
			if(a.RecordTypeId != null && a.RecordTypeId == rt_cis_gam && a.Public_Group_Id__c != null){
				set_gamAccountIds.add(a.Id);
				if(a.Account_Manager__c != null) {	//Added by bin yuan 2014-04-24 for put account manager into public group
					map_acctId_managerId.put(a.Id, a.Account_Manager__c);
				}
			}
		}
		list<Customer_Focus_Team_Member__c> list_customerFocusTeams = new list<Customer_Focus_Team_Member__c>();
		if(!set_gamAccountIds.isEmpty()){
			list_customerFocusTeams = [Select Id, Global_Account_Lkp__c, Salesforce_User_Name__c  from Customer_Focus_Team_Member__c where Global_Account_Lkp__c in: set_gamAccountIds];					
		}
		map<id, string> map_aid_uidList_customer = new map<id, string>();
		for (Customer_Focus_Team_Member__c cusTeam : list_customerFocusTeams) { 
    		if(cusTeam.Global_Account_Lkp__c != null && cusTeam.Salesforce_User_Name__c != null) {
    			if(!map_aid_uidList_customer.containsKey(cusTeam.Global_Account_Lkp__c)) map_aid_uidList_customer.put(cusTeam.Global_Account_Lkp__c, cusTeam.Salesforce_User_Name__c);
    			else {
    				uids = map_aid_uidList_customer.get(cusTeam.Global_Account_Lkp__c);
    				//Added by bin yuan 2014-04-24 for put account manager into public group
    				if(map_acctId_managerId.containsKey(cusTeam.Global_Account_Lkp__c)) {
    					uids = uids + ',' + map_acctId_managerId.get(cusTeam.Global_Account_Lkp__c);
    				}
    				map_aid_uidList_customer.put(cusTeam.Global_Account_Lkp__c, uids + ',' + cusTeam.Salesforce_User_Name__c);
    			}
    		}
		}
		if(!map_aid_uidList_customer.isEmpty()) ClsSharingUtil.insertCustomerFocusTeamMemberBatch(map_aid_uidList_customer);
	}

    global void finish(Database.BatchableContext BC){ 
    	if(email != null) {
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setToAddresses(new String[] {email});
			mail.setReplyTo(Email);
			mail.setSenderDisplayName('Batch Processing');
			mail.setSubject('Batch Processing ClsBatch_CustomerTeamMemberSharing Completed');
			mail.setPlainTextBody('Batch Processing ClsBatch_CustomerTeamMemberSharing has completed');
			//Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
    	}
    }
}