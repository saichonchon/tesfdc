/** 
 * this class use to populate Plan_group_Id
 *
 * @author      Wen Liu
 * @created     2012-09-10
 * @since       23.0    
 * @version     1.0                                                                 
 * 
 * @changelog
 * 2012-09-10 Wen Liu <wen.liu@itbconsult.com>
 * - Created
 *    
 */
global class ClsBatch_PopulatePlanGroupId implements Database.Batchable<SObject>{
	public String email;
	public String query;
	
	global Database.QueryLocator start(Database.BatchableContext BC){ 
		if (query == '' || query == null){
			//query = 'select Id, Individually_Planned__c, Plan_Group_Account__c, Plan_Group_Id__c, Plan_Group_Account__r.Individually_Planned__c from Account where Id in (\'001M000000DebfC\',\'001M000000Debf2\',\'001M000000Debf7\')';	
			query = 'select Id, Individually_Planned__c, Plan_Group_Account__c, Plan_Group_Id__c, Plan_Group_Account__r.Individually_Planned__c from Account where Plan_Group_Account__c != null or Plan_Group_Id__c != null or Individually_Planned__c = true';	
		}
	    return Database.getQueryLocator(query);   
	}
	
	global void execute(Database.BatchableContext BC, list<Account> list_accounts){
		ClsBudgetPlanningUtil.updatePlanGroupId(list_accounts,null,'batch','');
	}

    global void finish(Database.BatchableContext BC){ 
    	if(email != null) {
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setToAddresses(new String[] {email});
			mail.setReplyTo(Email);
			mail.setSenderDisplayName('Batch Processing');
			mail.setSubject('Batch Processing ClsBatch_PopulatePlanGroupId Completed');
			mail.setPlainTextBody('Batch Processing ClsBatch_PopulatePlanGroupId has completed');
			//Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
    	} 
    }
}