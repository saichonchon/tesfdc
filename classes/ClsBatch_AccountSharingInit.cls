/**
 *  This class is used for initializing of the Account sharing, such as delete public group.
 *  
 * @author Yinfeng Guo
 * @created 2012-06-25
 * @version 1.0
 * @since 23.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2012-06-25 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Created   
 *
 */

global class ClsBatch_AccountSharingInit implements Database.Batchable<SObject>{
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
			//query = 'Select Id, ParentId, RecordTypeId, Public_Group_Id__c from Account' ;commented by xia 2013-03-28
			
			//****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
			//query = 'Select Id, Sales_Hierarchy_GAM__c,Sales_Hierarchy_MM__c, RecordTypeId, GAMCD__c,MKTMGRCDE__c,Type,Public_Group_Id__c from Account'; //where (RecordTypeId =\'' + rt_cis_gam + '\' or RecordTypeId =\'' + rt_cis_account + '\') and (GAMCD__c != null or MKTMGRCDE__c != null)' ;
			query = 'Select Id, Sales_Hierarchy_GAM__c,Sales_Hierarchy_MM__c, RecordTypeId, GAMCD__c, IND_KAM_Code__c, MKTMGRCDE__c,Type,Public_Group_Id__c from Account';
			//****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
		}
	    return Database.getQueryLocator(query);  
	}

	global void execute(Database.BatchableContext BC, List<Account> list_accounts){
		String uids;
		set<Id> set_groupIds = new set<Id>();
		set<Id> set_allAccountIds = new set<Id>();

		list<Account> list_accs2Update = new list<Account>();
		for(Account a: list_accounts){
			set_allAccountIds.add(a.Id);
			if(a.RecordTypeId != null && a.RecordTypeId == rt_cis_gam && a.Public_Group_Id__c != null){
				set_groupIds.add(a.Public_Group_Id__c);
				//a.Public_Group_Id__c = null;
				//list_accs2Update.add(a);
			}
		}
		
		//list<AccountShare> list_accShr2Delete = new list<AccountShare>();
		list<AccountTeamMember> list_accTemeb2Delete = new list<AccountTeamMember>();
		list<Group> list_groups2Delete = new list<Group>();	
		//for(AccountShare a : [Select Id from AccountShare where AccountId in: set_allAccountIds and RowCause = 'Manual']){
		//	list_accShr2Delete.add(a);
		//}
		for(AccountTeamMember atm: [Select Id from AccountTeamMember where AccountId in: set_allAccountIds]){	
			list_accTemeb2Delete.add(atm);
		}
		for(Group g : [Select Id from Group where Id in: set_groupIds]){
			list_groups2Delete.add(g);
		}
		system.debug('list_groups2Delete@@@@@@@@@@@:'+list_groups2Delete);
		if(!list_groups2Delete.isEmpty()) delete list_groups2Delete;
		if(!list_accTemeb2Delete.isEmpty()) delete list_accTemeb2Delete;
		//if(!list_accShr2Delete.isEmpty()) delete list_accShr2Delete;		
		
		/*if(!list_accs2Update.isEmpty()) {
			ClsSharingUtil.TriggerRecursionDefense = true;
			update list_accs2Update;
		}*/
		
	}

    global void finish(Database.BatchableContext BC){ 
    	if(email != null) {
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setToAddresses(new String[] {email});
			mail.setReplyTo(Email);
			mail.setSenderDisplayName('Batch Processing');
			mail.setSubject('Batch Processing ClsBatch_AccountSharing Completed');
			mail.setPlainTextBody('Batch Processing ClsBatch_AccountSharing has completed');
			//Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
    	} 
    	ClsBatch_AccountSharing batchCls = new ClsBatch_AccountSharing();
    	batchCls.query = query;
    	batchCls.set_code = set_code;
    	database.executeBatch(batchCls);//added by xia 2013-03-28
    }	
    
}