/**
 *  This class is used for initializing of the Account sharing.
 *  
 * @author Yinfeng Guo
 * @created 2012-02-16
 * @version 1.0
 * @since 23.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2012-02-16 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Created   
 *
 */
global class ClsBatch_AccountSharingCheckParent implements Database.Batchable<SObject>{

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
			//query = 'Select Id, ParentId, RecordTypeId, Public_Group_Id__c from Account' ;//commented by xia 2013-03-28
			//query = 'Select Id, Public_Group_Id__c,Sales_Hierarchy_GAM__c,Sales_Hierarchy_MM__c, RecordTypeId, GAMCD__c,MKTMGRCDE__c,Type from Account where RecordTypeId =\'' + rt_cis_gam + '\' and ((Sales_Hierarchy_GAM__c != null and Type = \'Global Account\') or (Sales_Hierarchy_MM__c != null and Type = \'Grouped B\'))' ;//added by xia 2013-03-28
			
			//****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
			//query = 'Select Id, Sales_Hierarchy_GAM__c,Sales_Hierarchy_MM__c, RecordTypeId, GAMCD__c,MKTMGRCDE__c,Type,Public_Group_Id__c from Account'; //where (RecordTypeId =\'' + rt_cis_gam + '\' or RecordTypeId =\'' + rt_cis_account + '\') and (GAMCD__c != null or MKTMGRCDE__c != null)' ;
			query = 'Select Id, Sales_Hierarchy_GAM__c,Sales_Hierarchy_MM__c, RecordTypeId, GAMCD__c, IND_KAM_Code__c, MKTMGRCDE__c,Type,Public_Group_Id__c from Account'; 
			//****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
		}
	    return Database.getQueryLocator(query);  
	}

	global void execute(Database.BatchableContext BC, List<Account> list_accounts){
		/*String uids;  
		set<Id> set_groupIds = new set<Id>();
		set<Id> set_allAccountIds = new set<Id>();

		list<Account> list_accs2Update = new list<Account>();
		for(Account a: list_accounts){
			set_allAccountIds.add(a.Id);
		}
		if(!set_allAccountIds.isEmpty()){
			grantParentAccess(set_allAccountIds);
		}*///commented by xia 2013-03-28
		map<String, Account> map_groupName_acc = new map<String, Account>();
		for(Account a: list_accounts){
			a.Public_Group_Id__c = null;
			if(a.RecordTypeId == rt_cis_gam){
				if(a.Type == 'Global Account' && a.GAMCD__c != null){
					map_groupName_acc.put(ClsSharingUtil.NAME_PREFIX + a.GAMCD__c,a);
				//****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
				}else if(a.Type == 'Grouped B' && a.IND_KAM_Code__c != null){
					map_groupName_acc.put(ClsSharingUtil.NAME_PREFIX_B + a.IND_KAM_Code__c,a);
				}
				/*
				else if(a.Type == 'Grouped B' && a.MKTMGRCDE__c != null){
					map_groupName_acc.put(ClsSharingUtil.NAME_PREFIX_B + a.MKTMGRCDE__c,a);
				}
				*/
				//****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
			}	
		}
		for(Group g: [select id,name from Group where name in: map_groupName_acc.keyset()]){
			Account a = map_groupName_acc.get(g.name);
			a.Public_Group_Id__c = g.Id;		
		}
		ClsSharingUtil.TriggerRecursionDefense = true;
		update list_accounts;
		
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
    	ClsBatch_AccountTeamMemberSharing batchCls = new ClsBatch_AccountTeamMemberSharing();
    	batchCls.query = query;
    	batchCls.set_code = set_code; 
    	database.executeBatch(batchCls);//added by xia 2013-03-28
    }	
	
	/*commented by xia 2013-03-28
	global void grantParentAccess(set<Id> set_ids){
		Id rt_cis_gam;
		if(Apex_Helper_Settings__c.getInstance('GAM Record Type Id') != null) rt_cis_gam = Apex_Helper_Settings__c.getInstance('GAM Record Type Id').Value__c;
		
		List<AccountShare> list_cAccShrs  = new List<AccountShare>();
		AccountShare cAccShr;
		
		map<Id,Id> map_childAccId_parentAccId = new map<Id,Id>();
		for(Account childAcc : [Select Id, Name, ParentId, RecordTypeId, Public_Group_Id__c From Account where Id in: set_ids]){ // why 
			if(childAcc.ParentId != null && String.valueOf(childAcc.ParentId) != ''){
				map_childAccId_parentAccId.put(childAcc.Id, childAcc.ParentId);
			}
		}
		
		map<Id, Account> map_parentAccId_parentAcc = new map<Id, Account>();
		for(Account a : [Select Id, RecordTypeId, Public_Group_Id__c from Account where Id in: map_childAccId_parentAccId.values()]){
			map_parentAccId_parentAcc.put(a.Id, a);
		}
		
		for(Id childId : map_childAccId_parentAccId.keySet()){
			Account a = map_parentAccId_parentAcc.get(map_childAccId_parentAccId.get(childId));
			if(a != null){
				if(a.RecordTypeId == rt_cis_gam && a.Public_Group_Id__c != null && String.valueOf(a.Public_Group_Id__c) != ''){
					system.debug('childId:aaa@@@@:'+childId);
					system.debug('a.Public_Group_Id__c:aaa@@@@:'+a.Public_Group_Id__c);
					cAccShr = new AccountShare();
				 	cAccShr.AccountId = childId;
				 	cAccShr.UserOrGroupId = a.Public_Group_Id__c;
				 	cAccShr.AccountAccessLevel = 'Edit';
				 	cAccShr.CaseAccessLevel = 'Edit';
				 	cAccShr.OpportunityAccessLevel = 'Edit';
				 	list_cAccShrs.add(cAccShr);
				}
			}	
		}
		system.debug('list_cAccShrs:aaa@@@@:'+list_cAccShrs);
		if(!list_cAccShrs.isEmpty()) insert list_cAccShrs;
	}*/
	 
}