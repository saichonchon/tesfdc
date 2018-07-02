/************************************************************************************************************************************************************************************************************************
Name: LiveChat_sendEmailToCustomer 
===========================================================================================================================================================================================================
Purpose: This class was part of Outbound Chat and for Contact object. 
         This is used by LiveChat_sendEmailToCustomer class which is used to let agent Send Chat Invitation to customer based on Contact Email address for Service Console. 
===========================================================================================================================================================================================================
******************************************************************************************************************************************************************************************************************/

global class LiveChat_sendEmailToCustomer 
{
    webservice static void sendEmailfromContact(string conId) {
        List<Contact> getEmailAddress = [select Id,Email,Name,LinkExpiration__c,Is_Email_Send__c,contact.Full_Name__c FROM Contact WHERE id =:conId and Email!=null FOR UPDATE];

        if(getEmailAddress!=null && !getEmailAddress.isEmpty()){
            Contact objCon = getEmailAddress[0];
            try{
                if(objCon!= null && !objCon.Is_Email_Send__c && !String.isEmpty(objCon.Email)){
                    Live_Agent_Org_Settings__c dirUrl = Live_Agent_Org_Settings__c.getInstance();
                    System.debug('Contact Outbound Chat -->'+dirUrl.Contact_OutboundChat__c);
                    EmailTemplate sendchatinviteTemplate = [Select Id from EmailTemplate where developername=:dirUrl.Contact_OutboundChat__c];
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTemplateID(sendchatinviteTemplate.Id); 
                    mail.setTargetObjectId(conId);
                    mail.setSaveAsActivity(false);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
                    objCon.Is_Email_Send__c=true;
                    objCon.LinkExpiration__c=system.now();
                    update objCon;  
                }//if
            }catch(Exception e){
            	CCP_Exception_Util.CCP_Exception_Mail(e);                
            }            
        }//if
    }//webservice sendEmailfromContact
    
    webservice static void sendEmailfromCase(string caseId){
		List<Case> getEmailAddress = [select Id,contact.email,LinkExpiration__c,Is_Email_Send__c,contact.LastName,contact.Full_Name__c FROM Case WHERE id =:caseId and contact.email!=null FOR UPDATE];
			
		if(getEmailAddress!=null && !getEmailAddress.isEmpty()){
            Case objCase = getEmailAddress[0];
            try{
                if(objCase!= null && !objCase.Is_Email_Send__c && !String.isEmpty(objCase.contact.email)){
                    Live_Agent_Org_Settings__c dirUrl = Live_Agent_Org_Settings__c.getInstance();
                    EmailTemplate sendchatinviteTemplate = [Select Id from EmailTemplate where developername=:dirUrl.Case_OutboundChat__c];
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTemplateID(sendchatinviteTemplate.Id); 
					mail.setWhatId(caseId);
					mail.setTargetObjectId(objCase.ContactId);
                    mail.setSaveAsActivity(false);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
                    objCase.Is_Email_Send__c=true;
                    objCase.LinkExpiration__c=system.now();
                    update objCase;  
                }//if
            }catch(Exception e){
                CCP_Exception_Util.CCP_Exception_Mail(e);
                /*
                String vStrError         = '';
             	vStrError += 'Error Type = ' + e.getTypeName() + 
                ' Error Line = ' + e.getLineNumber() + '' + 
                ' Error Stack = ' + e.getStackTraceString() + 
                ' Error Message = ' + e.getMessage();
            
            	SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
                                         SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '',e.getStackTraceString());
				*/
            }//catch            
        }//if
	} 
   
}