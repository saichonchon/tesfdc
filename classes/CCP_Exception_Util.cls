public class CCP_Exception_Util{

    public static void CCP_Exception_Mail(Exception e){
        List<CCP_Exception_Email__c> vCEH = CCP_Exception_Email__c.getAll().values();
         list<Messaging.SingleEmailMessage> lstmail=new list<Messaging.SingleEmailMessage>();
    
        for(CCP_Exception_Email__c opp:vCEH){
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           mail.setTargetObjectId(opp.User_ID__c);
           mail.setSaveAsActivity(false);
           mail.setSubject('Exeption in CCP');
           mail.setUseSignature(false);
           String msgBody;
           msgBody = + '<html> Dear ' + opp.name + '<br/><br/><p> Following exception has occurred </p><br/>'+e
                     +'<br/> Exception type caught- '+e.getTypeName()+'<br/> Message- '+e.getMessage()+'<br/> StackTrace- '+e.getStackTraceString()+'<br/> at line no.'+e.getLineNumber()+'<br/> Cause- '+e.getCause()+'</html>';  
           mail.setHtmlBody(msgBody );
           lstmail.add(mail);
        }       
        if(!lstmail.isEmpty()){
            Messaging.SendEmail(lstmail);
        } 
        System.debug('Exception type caught: ' + e.getTypeName());    
        System.debug('Message: ' + e.getMessage());    
        System.debug('Cause: ' + e.getCause()); 
        System.debug('Line number: ' + e.getLineNumber());    
        System.debug('Stack trace: ' + e.getStackTraceString()); 
    }
}