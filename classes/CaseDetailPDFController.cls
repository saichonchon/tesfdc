/****
************************************************************************************************************************
      Name : CaseDetailPDFController
       Org : C2S-ChannelDev
 Copyright : © 2013 TE Connectivity
========================================================================================================================
   Summary : Create case detail PDF
________________________________________________________________________________________________________________________
                                                        
________________________________________________________________________________________________________________________
 VERSION DEVELOPER             DATE       DETAIL                                  
________________________________________________________________________________________________________________________
     1.0                     09/10/2013   Class
***********************************************************************************************************************
****/
public class CaseDetailPDFController {
    public Case vCs{get;set;}
   
    public List<EmailMessage> vEMList{get;set;}
    public CaseDetailPDFController(ApexPages.StandardController controller) {
        vCs = (Case)Controller.getRecord();
         vEMList =  [select id,parentid,BccAddress,ccAddress,FromAddress,FromName,HasAttachment,Headers,HtmlBody,Incoming,Isdeleted,Messagedate,ReplyToEmailMessageId,status,subject,textbody,toaddress,activityid from EmailMessage where parentid =: vCs.id];
    
        
    }

}