/**
 *  Batch class to copy all values for containing "PMV" fields 
 * 
 * @author Jinbo Shan
 * @created 2014-06-27
 * @version 1.0
 * @since 29.0
 * 
 * return
 *
 * @changelog    
 * 2014-06-27 Jinbo Shan <jinbo.shan@itbconsult.com>
 * - Created   
 *
 */     
global class ClsBatch_copyValuesForPMVFields implements Database.Batchable<SObject>,Database.Stateful {
	
	global string filter = '';
	global set<Id> set_rtIds = new set<Id>();
	global string ERROR;
	global string SUCCESS;
	
	global ClsBatch_copyValuesForPMVFields() {
		for(Opportunity_Record_Type_Groups__c ortg : Opportunity_Record_Type_Groups__c.getAll().values()) {
			if(ortg.RecordTypeID__c != null && ortg.RecordTypeID__c != '' && ortg.Group__c == 'PMV') {
				set_rtIds.add((Id)ortg.RecordTypeID__c);
			}
		}
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC){ 
		
		string query = 'select Id, SPIN_Type__c, PMV_Type__c from Sales_Process_Question_Assignment__c';
		if(filter != '') {
			query += filter;
		}
		return Database.getQueryLocator(query);
		
	}
	
	global void execute(Database.BatchableContext BC, list<Sales_Process_Question_Assignment__c> scope){
		list<Sales_Process_Question_Assignment__c> list_sojs = new list<Sales_Process_Question_Assignment__c>();
		
		for(Sales_Process_Question_Assignment__c s : scope) {
			if(s.get('SPIN_Type__c') != null){
				s.put('PMV_Type__c', string.valueOf(s.get('SPIN_Type__c')));
				list_sojs.add(s);
			}
		}
		
        if(list_sojs.size() > 0) {
			List<Database.SaveResult> srList = database.update(list_sojs, false);
			for (integer i = 0; i < srList.size(); i++) {
			    if (srList.get(i).isSuccess()) {
			    	if(SUCCESS == null) {
			    		SUCCESS = 'Successfully inserted Opportunity. Opportunity ID: </br>';
			    	}
			    	SUCCESS += srList.get(i).getId() + '</br>';
			    } else {
			    	if(ERROR == null) {
			    		ERROR = 'The following error has occurred: </br>';
			    	}
			    	ERROR += list_sojs.get(i).Id + ': ';
			        // Operation failed, so get all errors                
			        for(Database.Error err : srList.get(i).getErrors()) {                  
			            ERROR += err.getStatusCode() + ': ' + err.getMessage() + '</br>';
			            //System.debug('Account fields that affected this error: ' + err.getFields());
			        }
			    }
			}
		}
	}
	
	global void finish(Database.BatchableContext BC){
		if(UserInfo.getUserId() != null && (ERROR != null || SUCCESS != null)){
			if(ERROR == null) {
				ERROR = '';
			}
			if(SUCCESS == null) {
				SUCCESS = '';
			}
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(UserInfo.getUserId());
            mail.setToAddresses(new list<string>{'jinbo.shan@itbconsult.com', 'bin.yu@itbconsult.com'});
            mail.setSubject('Copying All PMV Field Values On Sales_Process_Question_Assignment__c is completed.');
			
            string htmlBody = SUCCESS + '</br></br>' + ERROR;
            mail.setHtmlBody(htmlBody);
            
            mail.setSaveAsActivity(false); //If "yes" Activity will be created for Visit Report, If "no" no Activity will be created
            mail.setUseSignature(false); //Sender Signature from SFDC           
            if(!test.isRunningTest()) {
            	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
		}
	}
}