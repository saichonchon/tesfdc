/**
 *  This class is used for re-calculation of the AccountTeamMember.
 *  
 * @author Yinfeng Guo
 * @created 2012-02-28
 * @version 1.0
 * @since 23.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2012-02-28 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Created
 * 2012-05-04 Frederic Faisst <frederic.faisst@itbconsult.com>
 * - New Requirement: The role "GAM" must be considered. Each "GAM" must be retrieved from custom account team object and stored in standard account team
 *
 */

global class ClsBatch_AccountTeamMemberSharing implements Database.Batchable<SObject>{
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
	
	/**
  	 * the record type id for sfdc user, the value get from custom setting
	 */	
	global final Id rt_sfdc_user = ClsSharingUtil.sfdcUserCustomSetting();
	
	global Database.QueryLocator start(Database.BatchableContext BC){ 
		if (query == '' || query == null){
			//query = 'Select Id, ParentId, RecordTypeId, Public_Group_Id__c from Account' ;
			query = 'Select Id, Sales_Hierarchy_GAM__c,Sales_Hierarchy_MM__c, RecordTypeId, GAMCD__c,MKTMGRCDE__c,Type,Public_Group_Id__c from Account'; //where (RecordTypeId =\'' + rt_cis_gam + '\' or RecordTypeId =\'' + rt_cis_account + '\') and (GAMCD__c != null or MKTMGRCDE__c != null)' ;
		
		}
	    return Database.getQueryLocator(query);  
	}

	global void execute(Database.BatchableContext BC, List<Account> list_accounts){
		String uids;
		String Role_AM = 'Account Manager (AM)';
		String Role_FE = 'Field Engineer (FE)';
		//Added by Frederic Faisst, ITBconsult, 04.05.2012
		String Role_GAM = 'Global Account Manager (GAM)';
		set<Id> set_notGamAccountIds = new set<Id>();
		list<Account> list_accs2Update = new list<Account>();
		
		for(Account a: list_accounts){
			if(a.RecordTypeId != rt_cis_gam) set_notGamAccountIds.add(a.Id);
		}
		list<Account_Team__c> list_accTeams = new list<Account_Team__c>();
		if(!set_notGamAccountIds.isEmpty()){
			list_accTeams = [Select Id, RecordTypeId, Account__c, Team_Member__c,Role__c  from Account_Team__c where Account__c in: set_notGamAccountIds];
		}
		//map<id, string> map_aid_uidList_account = new map<id, string>();
		map<id, string> map_aid_uidList_ForAccountTeamMember = new map<id, string>();
		map<id, string> map_aid_uidList_ForAccountShare = new map<id, string>();
		//Added 04.05.2012 by Frederic Faisst, ITBconsult, that job only goes ahead if List contains data.
		if(!list_accTeams.isEmpty()){
			for (Account_Team__c accTeam : list_accTeams) { 
	    		if(accTeam.RecordTypeId != null && accTeam.RecordTypeId == rt_sfdc_user && accTeam.Account__c != null && accTeam.Team_Member__c != null) {
	    			if(accTeam.Role__c == Role_AM || accTeam.Role__c == Role_FE || accTeam.Role__c == Role_GAM ){
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
					}
	    		}
			}
		}
		
		if(!map_aid_uidList_ForAccountTeamMember.isEmpty()) ClsSharingUtil.upsertAccountTeamMemberBatch(map_aid_uidList_ForAccountTeamMember);
		if(!map_aid_uidList_ForAccountShare.isEmpty()) ClsSharingUtil.upsertAccountTeamShareBatch(map_aid_uidList_ForAccountShare);
	}

    global void finish(Database.BatchableContext BC){ 
    	/*
    	if(email != null) {
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setToAddresses(new String[] {email});
			mail.setReplyTo(Email);
			mail.setSenderDisplayName('Batch Processing');
			mail.setSubject('Batch Processing ClsBatch_AccountTeamMemberSharing Completed');
			mail.setPlainTextBody('Batch Processing ClsBatch_AccountTeamMemberSharing has completed');
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
    	} */
    	ClsBatch_CustomerTeamMemberSharing batchCls = new ClsBatch_CustomerTeamMemberSharing();
    	batchCls.query = query;
    	batchCls.set_code = set_code;
    	database.executeBatch(batchCls);//added by xia 2013-03-28
    }
}