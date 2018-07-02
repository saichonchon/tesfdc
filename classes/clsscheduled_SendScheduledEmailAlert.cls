/* -----------------------------------------------------------------------------------------------------------------------------------------
* Name : clsscheduled_SendScheduledEmailAlert 
* This Scheduled Class is used to schedule and send any email alert or email message to users defined in custom setting Batch_Email_message_Users__c at a specefied time. 

* Org : C2S  
* (Test coverage done by class UpdateYBBPartsVsOpptyPartB1_Test)                                                
----------------------------------------------------------------------------------------------------------------------------------------- */

global class clsscheduled_SendScheduledEmailAlert implements Schedulable 
{
    
    public string BatchName = '';
    public string EmailSubject = '';
    public string EmailBody = '';
    global void execute(SchedulableContext sc) 
    {
        if(BatchName != null && BatchName != '')
        {
            Batch_Email_message_Users__c oBatchEmailmessageUsers = Batch_Email_message_Users__c.getValues(BatchName);
            if(oBatchEmailmessageUsers != null && oBatchEmailmessageUsers.Email_ID__c != null)
            {                    
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> lstToAddresses = oBatchEmailmessageUsers.Email_ID__c.split(';');
                mail.setToAddresses(lstToAddresses);
                mail.setSubject(EmailSubject);
                mail.setPlainTextBody(EmailBody); 
                
                if(!test.isRunningTest()) { 
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                } 
            }
        }
    }
}