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
global class ClsBatch_AccountSharing implements Database.Batchable<SObject>{
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
			//query = 'Select Id, Sales_Hierarchy_GAM__c,Sales_Hierarchy_MM__c, RecordTypeId, GAMCD__c,MKTMGRCDE__c,Type from Account where RecordTypeId =\'' + rt_cis_gam + '\' and ((Sales_Hierarchy_GAM__c != null and Type = \'Global Account\') or (Sales_Hierarchy_MM__c != null and Type = \'Grouped B\'))' ;//added by xia 2013-03-28 
			
			//****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
			//query = 'Select Id, Sales_Hierarchy_GAM__c,Sales_Hierarchy_MM__c, RecordTypeId, GAMCD__c,MKTMGRCDE__c,Type,Public_Group_Id__c from Account'; //where (RecordTypeId =\'' + rt_cis_gam + '\' or RecordTypeId =\'' + rt_cis_account + '\') and (GAMCD__c != null or MKTMGRCDE__c != null)' ;
			query = 'Select Id, Sales_Hierarchy_GAM__c,Sales_Hierarchy_MM__c, RecordTypeId, IND_KAM_Code__c, GAMCD__c,MKTMGRCDE__c,Type,Public_Group_Id__c from Account'; //where (RecordTypeId =\'' + rt_cis_gam + '\' or RecordTypeId =\'' + rt_cis_account + '\') and (GAMCD__c != null or MKTMGRCDE__c != null)' ;			
			//****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
		}
	    return Database.getQueryLocator(query);  
	}

	global void execute(Database.BatchableContext BC, List<Account> list_accounts){

		
		//added by xia 2013-03-28 
		map<Id,String> map_shId_groupName = new map<Id,String>();
    	map<Id,Id> map_shId_accId = new map<Id,Id>();

		for(Account a: list_accounts){
			if(a.RecordTypeId == rt_cis_gam){
				if(a.Type == 'Global Account' && a.Sales_Hierarchy_GAM__c != null){
					map_shId_groupName.put(a.Sales_Hierarchy_GAM__c,ClsSharingUtil.NAME_PREFIX + a.GAMCD__c);
	    			map_shId_accId.put(a.Sales_Hierarchy_GAM__c,a.Id);
				}else if(a.Type == 'Grouped B' && a.Sales_Hierarchy_MM__c != null){
					//****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
					//map_shId_groupName.put(a.Sales_Hierarchy_MM__c,ClsSharingUtil.NAME_PREFIX_B + a.MKTMGRCDE__c);
					map_shId_groupName.put(a.Sales_Hierarchy_MM__c,ClsSharingUtil.NAME_PREFIX_B + a.IND_KAM_Code__c);
					//****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
	    			map_shId_accId.put(a.Sales_Hierarchy_MM__c,a.Id);
				}
			}	
		}
		ClsSharingUtil.insertPublicGroupSharing4Batch(map_shId_groupName, map_shId_accId);		
		 
	
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
    	ClsBatch_AccountSharingCheckParent batchCls = new ClsBatch_AccountSharingCheckParent();
    	batchCls.query = query;
    	batchCls.set_code = set_code; 
    	database.executeBatch(batchCls);//added by xia 2013-03-28
    }	
	
}