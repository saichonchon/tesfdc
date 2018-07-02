/**
 *  A batch job which checks every 24 hours if there exists Opportunities with defined "Sent_to_PLM_Date__c" but missing PLM Project Id. 
 *  In this case, the batch job should re-start the creation of the PLM Project by resending the Oppy Id to Cast iron. 
 *  
 * @author Yinfeng Guo
 * @created 2012-06-18
 * @version 1.0
 * @since 23.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2012-06-18 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Created   
 *
 */

global class ClsBatch_PLMCreation implements Database.Batchable<SObject>{
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
	
	private String configName {get;
							   set {
							   	     for(realtime_Callout_Settings__c rcs : realtime_Callout_Settings__c.getAll().values()) {
                					 if(rcs.Active__c == true ) {
                    					if(rcs.Name == 'Prod PLM Picklist' || rcs.Name == 'QA PLM Picklist'){
											configName = rcs.Name;  
                    					}
                					 }
            					   }
							   }
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC){ 
		if (query == '' || query == null){
			query = 'SELECT Id,Sent_to_PLM_Date__c,PLM_Id__c FROM Opportunity WHERE Sent_to_PLM_Date__c != null AND PLM_Id__c = null';	
		}
	    return Database.getQueryLocator(query);   
	}

	global void execute(Database.BatchableContext BC, list<opportunity> list_opportunitys){
		if(list_opportunitys != null && !list_opportunitys.isEmpty()) {
			for(Opportunity opportunity : list_opportunitys){
				string RTcallResult = real_time_call.callOrchestrationRealTime('PushOpptyToPLM', opportunity.id, configName); 
			}
		}
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
    }  
    	
}