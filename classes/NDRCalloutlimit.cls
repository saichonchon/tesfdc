/**********************************************************************************************************************************************
*******
Name: NDRCalloutlimit
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This class sends an mail to system administrator when callout exceeded for NDR Opportunity.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE       DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepatil   08/16/2013    Class                       
***********************************************************************************************************************************************
*****/
public class NDRCalloutlimit{
    public static void sendEmail(List<Opportunity> pOppLst,String email) {
        String[] emailRecipient = new String[]{email};
        String vOppname = '';
        for(Opportunity opp : pOppLst){
            vOppname = vOppname+opp.name+'('+opp.id+'),';
        }
         
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(emailRecipient);
        mail.setSenderDisplayName('System Administrator');
        mail.setSubject('NDR SFDC-SAP Callout limit');
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setPlainTextBody('Following opportunities are not transferred to SAP \n' + vOppname );
       // Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }  
}