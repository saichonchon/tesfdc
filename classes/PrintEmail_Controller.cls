/************************************************************************************************************************************************************************************************************************************************
Name: PrintEmail_Controller
Copyright © 2014 TE Connectivity | Salesforce Instance : C2S Org
=================================================================================================================================================================================================================================================
Purpose: This controller will update the save name as Email Message record subject name.This controller 
         is used by PdfPage VF page.
=================================================================================================================================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
VERSION               AUTHOR                    DATE              DETAIL                           
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 1.0               Ramakrishna Singara         10/03/2014        Controller                         
*************************************************************************************************************************************************************************************************************************************************/

public class PrintEmail_Controller {
    
    public Id EmailMsg_ID{get;set;}
    public String RecSubject{get;set;}   
    EmailMessage Emsg = new EmailMessage();
    public PrintEmail_Controller(ApexPages.StandardController controller) {
        EmailMsg_ID = System.currentPageReference().getParameters().get( 'id' );        
        if(EmailMsg_ID!=null)       
        Emsg = [Select id,parentId,subject,status,HasAttachment,Incoming,ToAddress,FromAddress,MessageDate from EmailMessage where id =: EmailMsg_ID];
        if((Emsg.subject!=null) && (Emsg.subject.length()>78)){
            system.debug('*****************'+Emsg.subject);
            RecSubject = ((Emsg.subject.substring(0, 77)).replaceAll(',',' ')); 
            system.debug('*****************'+RecSubject);
        }
        else{
            RecSubject = Emsg.subject.replaceAll(',',' ');
        }       
        Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename='+RecSubject+'.pdf');        
    }   
}