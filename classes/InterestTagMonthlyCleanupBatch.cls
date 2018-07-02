/**
* 
* This batch class is used to automated monthly cleanup process to clear Interest tag records.
* 
* @author      Nagaraju Gorli
* @created     2017-07-20                                                         
*     
*/
global class InterestTagMonthlyCleanupBatch implements Database.Batchable<sObject>,Database.Stateful{  
    global String Query;
    global String EmailBody;
    global list<String> toAddresses;
    global integer totalInterestTagRecordsDeleted= 0;
    global InterestTagMonthlyCleanupBatch(){
        try{
            toAddresses = new list<string>();
            Batch_Email_message_Users__c batchStatus= Batch_Email_message_Users__c.getValues('AITCleanUpActivity');
            toAddresses = new list<string>();
            string emailids=batchStatus.Email_ID__c;
            if(batchStatus.Email_ID__c != null && batchStatus.Email_ID__c.contains(';'))
                toAddresses = batchStatus.Email_ID__c.split(';');
            else    
                toAddresses.add(emailids);
            
            //create the query here from custom settings to get the date range.
            AIT_Clean_Up_Date_range__c rawdataRange=AIT_Clean_Up_Date_range__c.getValues('Raw data');
            AIT_Clean_Up_Date_range__c webActivityRange=AIT_Clean_Up_Date_range__c.getValues('Web Activity');
            AIT_Clean_Up_Date_range__c manualTagRange=AIT_Clean_Up_Date_range__c.getValues('Manual Tag');
            AIT_Clean_Up_Date_range__c opportunityRange=AIT_Clean_Up_Date_range__c.getValues('Opportunity tag');
            
            system.debug('===1 month old==='+integer.valueOf(rawdataRange.Months_old__c));
            
            query='SELECT Id ,CreatedDate  FROM Interest_Tag__c WHERE'; 
            
            // the below condition for getting 6months back record for record type ‘Raw Data’
            query+=' (Recordtype.Name=\'Raw Data\' AND Completely_Converted__c = true AND CreatedDate <LAST_N_MONTHS:'+integer.valueOf(rawdataRange.Months_old__c)+')'; //Here no age codition 
            // the below condition for getting 6months back record for record type ‘Web Activity’.
            //query+='OR (Recordtype.Name=\'Raw Data\' AND CreatedDate <LAST_N_MONTHS:'+integer.valueOf(webActivityRange.Months_old__c)+')';
            query+='OR (activity_class_code__c =\'Web\' AND CreatedDate <LAST_N_MONTHS:'+integer.valueOf(webActivityRange.Months_old__c)+')'; //this is pulling 6 months older records 
             
            // The below condition for getting 5 years back record for record type ‘Manual Tag’.
            query+='OR (Recordtype.Name=\'Manual Interest Tag\' AND CreatedDate < LAST_N_MONTHS:'+integer.valueOf(manualTagRange.Months_old__c)+')'; //this is pulling  60 months(5 years) older records
            
            // the below condition for getting 6months back record for record type ‘Opportunity’.
            query+='OR (Recordtype.Name=\'Opportunity Interest Tag\' AND CreatedDate < LAST_N_MONTHS:'+integer.valueOf(opportunityRange.Months_old__c)+')';//this is pulling 6 months older records
            
            if(Test.isRunningTest())
                query += ' limit 1';
         
        }catch(exception e){}
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
        
    }
    global void execute(  Database.BatchableContext BC,  List<sObject> scope){
        try {
            integer recordsdeleted = scope.size();
            delete (scope);
            totalInterestTagRecordsDeleted += recordsdeleted;
            Database.emptyRecycleBin(scope);
            
        } catch(Exception e) {
            EmailBody = e.getMessage() +' at '+e.getStackTraceString();
            EmailSender('Something Went Wrong With Activity stage Deletion Batch...!!!', toAddresses, EmailBody);
        }
    } 
    global void finish(Database.BatchableContext BC){
      
        AsyncApexJob ajob = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, 
                             TotalJobItems FROM AsyncApexJob WHERE Id = :BC.getJobId()];  
        
        String EmailBody = '<html><body>';
        EmailBody+= 'Hi,<br/><br/>';
        EmailBody+='The batch apex job processed ' + ajob.TotalJobItems +' batches with '+ ajob.NumberOfErrors + ' failures.Total ' + totalInterestTagRecordsDeleted + ' record(s) are deleted.<br/><br/> ';
        EmailBody+= 'Thanks,<br/>';  
        EmailBody+='TE Salesforce Team';
        EmailBody += '</p></body></html>';
       //Send an email to the User after your batch completes 
        EmailSender('Iterest tag old records deleted successfully ..!!', toAddresses, EmailBody); 
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