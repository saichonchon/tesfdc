/**
* 
* This batch class is used to automated monthly cleanup process to clear Key Activity Staging records.
* 
* @author      Nagaraju Gorli
* @created     2017-07-19                                                          
*     
*/
global class ActivityStagingMonthlyCleanupBatch implements Database.Batchable<sObject>,Database.Stateful{   
    global list<String> toAddresses;
    global String Query;
    global String EmailBody;
    global integer totalActivityStageRecordsDeleted= 0;
    global ActivityStagingMonthlyCleanupBatch(){
        
        //create the query here from custom settings to get toaddress.
        EmailBody=null;
        Batch_Email_message_Users__c batchStatus= Batch_Email_message_Users__c.getValues('AITCleanUpActivity');
        toAddresses = new list<string>();
        string emailids=batchStatus.Email_ID__c;
        if(batchStatus.Email_ID__c != null && batchStatus.Email_ID__c.contains(';'))
            toAddresses = batchStatus.Email_ID__c.split(';');
        else    
            toAddresses.add(emailids);
        
        //create the query here from custom settings to get the date range.
        AIT_Clean_Up_Date_range__c dateRange=AIT_Clean_Up_Date_range__c.getValues('ActivityStage');
        
        //building the query to get the key activity staging
        query='SELECT Id ,CreatedDate  FROM Key_Activity_Staging__c WHERE '; 
        query +='CreatedDate<LAST_N_MONTHS:'+integer.valueOf(dateRange.Months_old__c);
        
        system.debug('==>'+dateRange.Months_old__c);
        if(Test.isRunningTest())
            query += ' limit 1';
        
    }
    global Database.QueryLocator start(Database.BatchableContext BC){  
        return Database.getQueryLocator(query);
        
    }
    // Execute Method Logic
    global void execute(  Database.BatchableContext BC,List<Key_Activity_Staging__c>scope){ 
        try {
            integer recordsdeleted = scope.size();           
            delete (scope);
            totalActivityStageRecordsDeleted += recordsdeleted;
            Database.emptyRecycleBin(scope);
            
        } catch(Exception e) {
            EmailBody = e.getMessage() +' at '+e.getStackTraceString();
            EmailSender('Something Went Wrong With Activity stage Deletion Batch..!!', toAddresses, EmailBody);
        }
    }  

    global void finish(Database.BatchableContext BC){
        //Send an email to the User after your batch completes 
        
        AsyncApexJob ajob= [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems 
                            FROM AsyncApexJob WHERE Id = :BC.getJobId()];  
        system.debug('===total==='+totalActivityStageRecordsDeleted);
        String EmailBody = '<html><body>';
        EmailBody+= 'Hi,<br/><br/>';
        EmailBody+='The batch apex job processed ' + ajob.TotalJobItems +' batches with '+ ajob.NumberOfErrors + ' failures.Total ' + totalActivityStageRecordsDeleted + ' record(s) are deleted.<br/><br/> ';
        EmailBody+='Thanks,<br/>';
        EmailBody+='TE Salesforce Team';
        EmailBody += '</p></body></html>';
        
        EmailSender('Activity stage old records deleted successfully ..!!!', toAddresses, EmailBody); 
    }
    
    global void EmailSender(string subject, list<string> toAddresses, string body ){ 

        List<User> EmailUsers = [SELECT Id FROM User WHERE email IN :toAddresses];
        List<Id> EmailUserIds = new List<Id>(new Map<Id, User>(EmailUsers).keySet());
    
        if(!EmailUsers.isEmpty()){
        	 for (Id emailuserid: EmailUserIds){
      				Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();         
            		email.setTargetObjectId(emailuserid);
			        email.saveAsActivity = false;
			        email.setSubject(subject);
			        email.setHtmlBody(body);
			        if(!Test.isRunningTest())
			            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});    			                    		
        	 }
        }
        else
        {
      			Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();         
             	email.setTargetObjectId(Userinfo.getuserId());
             	email.saveAsActivity = false;
			    email.setSubject(subject);
			    email.setHtmlBody(body);
			    if(!Test.isRunningTest())
			    	Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});               
        }

    }
}