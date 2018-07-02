/***********************************************************************************************************************
 Name: UtilEmailError
 Copyright © 2013 TE Connectivity | Salesforce Instance : Central Org
========================================================================================================================
 Purpose: Used for to send error email.                                                 
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
 VERSION AUTHOR                DATE       DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
     1.0 Ankit                 05/08/2013 Initial Development                                 
***********************************************************************************************************************/
public class UtilEmailError{
    //Methord 1#
    public static List<String> generateEmailLst(string emailadd){
        // Send an email notifying of job exception.
        emailadd = emailadd.deleteWhitespace();
        List<String> vEmailIdLst = new List<String>();
        while(emailadd.length() > 0 ){
            if(emailadd.contains(',') && emailadd.indexOf(',') != -1){
              string vTempEmail;
              vTempEmail = emailadd.substring(0,emailadd.indexOf(',')); 
              vEmailIdLst.add(vTempEmail);
              emailadd = emailadd.substring(emailadd.indexOf(',')+1,emailadd.length()); 
            }
            else{
                vEmailIdLst.add(emailadd );
                emailadd = ''; 
            }
        }
        return vEmailIdLst;
    }
    
    //Methord 2#
    public static void sendErroremail(List<String> emailLst,string excep,String clsName){
        if(emailLst.size() > 0 && emailLst != null){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage ();
            mail.setToAddresses(emailLst);
            mail.saveAsActivity = false;
            mail.setSubject('Apex Status for - '+clsName+' - EXCEPTION');
            mail.setHtmlBody
            ('The '+clsName+' with Errors!<br/> Following is the full stack trace of the exception -'+
            + '<hr/>'+excep);
            if(!test.isRunningTest()) {  
                Messaging.sendEmail(new Messaging.SingleEmailMessage [] { mail });
            }
        }
    }
}