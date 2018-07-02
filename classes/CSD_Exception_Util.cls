public class CSD_Exception_Util{

    public static void CSD_Exception_Mail(Exception e){
        List<CSD_Exception_Email__c> vCEH = CSD_Exception_Email__c.getAll().values();
         list<Messaging.SingleEmailMessage> lstmail=new list<Messaging.SingleEmailMessage>();
    
        for(CSD_Exception_Email__c opp:vCEH){
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           mail.setTargetObjectId(opp.User_ID__c);
           mail.setSaveAsActivity(false);
           mail.setSubject('Exeption in CSD');
           mail.setUseSignature(false);
           String msgBody;
           msgBody = + '<html> Dear ' + opp.name + '<br/><br/><p>Following exception has occurred</p><br/>'+e+'<br/>'+e.getMessage()+'<br/>'+e.getStackTraceString()+' at line no.'+e.getLineNumber()+'</html>';  
           mail.setHtmlBody(msgBody );
           lstmail.add(mail);
        }
        if(!lstmail.isEmpty()){
            Messaging.SendEmail(lstmail);
        } 
    }
}