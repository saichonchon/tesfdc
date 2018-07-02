/**
 *  A batch job to ReCalculation AccountTeam. 
 *  
 * @author Yinfeng Guo
 * @created 2012-06-21
 * @version 1.0
 * @since 23.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2012-06-21 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Created   
 *
 */
global class ClsBatch_ReCalculationAccountTeam implements Database.Batchable<SObject>{
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
	
	global Database.QueryLocator start(Database.BatchableContext BC){ 
		if (query == '' || query == null){
			query = 'SELECT Account__c, Name, CreatedById, CreatedDate, CurrencyIsoCode, IsDeleted, LastModifiedById, LastModifiedDate, Opportunity_Access__c, ConnectionReceivedId, Id, RecordTypeId, Role__c, ConnectionSentId, SystemModstamp, TE_Network_Id__c, Team_Member_Formula__c, Team_Member__c, Team_Member_Contact__c, Team_Member_txt__c, Team_Member_Key__c, View__c FROM Account_Team__c';	
		}
	    return Database.getQueryLocator(query);   
	}

	global void execute(Database.BatchableContext BC, list<Account_Team__c> list_accountTeams){
		Id rt_sfdc_user = ClsSharingUtil.sfdcUserCustomSetting();
		map<id, string> map_aid_uidList_ForAccountTeamMember = new map<id, string>();
		String uids;
		
		String rolesList;
		set<String> set_roles = new set<String>();
		if(Apex_Helper_Settings__c.getInstance('Custom Account Team Roles') != null) rolesList = Apex_Helper_Settings__c.getInstance('Custom Account Team Roles').Value__c;
		for(String role : rolesList.split(';')){
			set_roles.add(role);
		}
	
		for (Account_Team__c accTeam : list_accountTeams) { 
    		if(accTeam.RecordTypeId != null && accTeam.RecordTypeId == rt_sfdc_user && accTeam.Account__c != null && accTeam.Team_Member__c != null) {
				if(set_roles.contains(accTeam.Role__c)){
        			if(!map_aid_uidList_ForAccountTeamMember.containsKey(accTeam.Account__c)) map_aid_uidList_ForAccountTeamMember.put(accTeam.Account__c, accTeam.Team_Member__c);
        			else {
        				uids = map_aid_uidList_ForAccountTeamMember.get(accTeam.Account__c);
        				map_aid_uidList_ForAccountTeamMember.put(accTeam.Account__c, uids + ',' + accTeam.Team_Member__c);
        			}
				}
    		}
		}
		if(!map_aid_uidList_ForAccountTeamMember.isEmpty()) ClsSharingUtil.upsertAccountTeamMemberBatch(map_aid_uidList_ForAccountTeamMember);
	}

    global void finish(Database.BatchableContext BC){ 
    	if(email != null) {
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setToAddresses(new String[] {email});
			mail.setReplyTo(Email);
			mail.setSenderDisplayName('Batch Processing');
			mail.setSubject('Batch Processing ClsBatch_DeleteBacklogSnapshot Completed');
			mail.setPlainTextBody('Batch Processing ClsBatch_DeleteBacklogSnapshot has completed');
			//Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
    	} 
    	else{
    		email = 'yinfeng.guo@itbconsult.com';
    		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setToAddresses(new String[] {email});
			mail.setReplyTo(Email);
			mail.setSenderDisplayName('Batch Processing');
			mail.setSubject('Batch Processing ClsBatch_DeleteBacklogSnapshot Completed');
			mail.setPlainTextBody('Batch Processing ClsBatch_DeleteBacklogSnapshot has completed');
			//Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
    	}
    }  
    	
}