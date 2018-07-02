/**********************************************************************************************************************************************
*******
Name: ZipfileController
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This controller create a zip file of selected attachments.This controller 
        is used by CreateZipFile VF page.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepatil   09/10/2013    Controller                       
***********************************************************************************************************************************************
*****/
global with sharing class ZipfileController{
    public Id case_id1;
    public Id AttachID{get;set;}
    public boolean showDownload{get;set;}
    public Case vCs;
    public List<Attachment> vCaseAttachmentList{get;set;}
    public Attachment doc{get;set;}
    public ZipfileController(ApexPages.StandardController controller) {
        case_id1 = ApexPages.currentpage().getParameters().get('id');
        vCs = [select id,CaseNumber,SAP_Document_Number__c from case where id =: case_id1];
        vCaseAttachmentList = new List<Attachment>();
        
        showDownload = false;
        runQuery();
       
    }
    public void show(){
    //delete vAttchtoDelete;
    }
   
     public String zipFileName {get; set;}
     transient public String zipContent {get; set;}
     //public List<Attachment> vAttchtoDelete{get;set;}
     public List<Attachment> vDetailAttchtoDelete{get;set;}
     public List<Attachment> CanclevDetailAttchtoDelete{get;set;}
     public List<Attachment> DownloadvDetailAttchtoDelete{get;set;}
     public Id case_id {get;set;}
     public Set<ID> attachmentID {get;set;}
     public PageReference runQuery(){
    
        case_id = ApexPages.currentpage().getParameters().get('id');
        List<EmailMessage> vEMAttachmentList =  [select id,parentid,BccAddress,ccAddress,FromAddress,FromName,HasAttachment,Headers,HtmlBody,Incoming,Isdeleted,Messagedate,ReplyToEmailMessageId,status,subject,textbody,toaddress,activityid 
        from EmailMessage 
        where parentid = : case_id1 and HasAttachment= true];
        attachmentID = new Set<ID>();
        for(EmailMessage eMail : vEMAttachmentList){
            attachmentID.add(eMail.id);
        }
       // vAttchtoDelete = new List <Attachment>();
        vDetailAttchtoDelete= new List<Attachment>();
    List<Attachment> vAttachmentList =[select Id, ParentId, Name, ContentType, BodyLength,IsDeleted
                                        from Attachment
                                        where Parentid=:case_id or ParentId in :attachmentID]; // 
    
                
                for(Attachment atch : vAttachmentList ){
                   /* if(atch.name.contains('.zip')  ){
                        vAttchtoDelete.add(atch);
                    } 
                    else{*/
                         if((atch.name.contains('.jpg') || atch.name.contains('.msg') ||atch.name.contains('.rtf') ||atch.name.contains('.htm') ||atch.name.contains('.html')   
    ||atch.name.contains('.xls')  ||atch.name.contains('.xlsx') ||atch.name.contains('.pdf') ||atch.name.contains('.txt') ||atch.name.contains('.ppt') ||atch.name.contains('.pptx')||atch.name.contains('.docx') ||atch.name.contains('.doc')
 
 
 ||atch.name.contains('#Detail.pdf') || atch.name.contains('.zip')) || atch.Parentid != case_id){
                           vCaseAttachmentList.add(atch);
                        }
                        
                        if(atch.name.contains('#Detail.pdf')){
                            vDetailAttchtoDelete.add(atch);
                        }
                    //}
                }
                
               
                return null;
    }
 public void DeleteDetailFile(){
     system.debug('Del'+vDetailAttchtoDelete);
     
     List<Attachment> DeletevAttachmentList =[select Id, ParentId, Name, ContentType, BodyLength,IsDeleted
                                        from Attachment
                                        where Parentid=:case_id or ParentId in :attachmentID];
     CanclevDetailAttchtoDelete= new List<Attachment>();
     for(Attachment att : DeletevAttachmentList){
         if(!att.IsDeleted && att.name.contains('#Detail.pdf')){
             CanclevDetailAttchtoDelete.add(att);
         }
     }    
     try{
         if(CanclevDetailAttchtoDelete.size()> 0 && CanclevDetailAttchtoDelete != null ) {   
             Delete CanclevDetailAttchtoDelete ;
          }
      }
      catch(Exception e){
           CCP_Exception_Util.CCP_Exception_Mail(e);
        
       }  
 }
    public PageReference uploadZip() {
        if(vCs.SAP_Document_Number__c == null){
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter SAP Document number first and Reclick on Create File for SAP'));
             return null;
        }
        else{
        
        system.debug('Create'+vDetailAttchtoDelete);
        DownloadvDetailAttchtoDelete = new List<Attachment>();
        doc = new Attachment();
        doc.Name = ''+vCs.SAP_Document_Number__c+'.zip'; //zipFileName;
        doc.ContentType = 'application/zip';
        doc.Body = EncodingUtil.base64Decode(zipContent);
        doc.parentid = case_id1;
        insert doc;
 
        AttachID = doc.ID;
        showDownload = true;
        this.zipFileName = null;
        this.zipContent = null;
        doc.Body = null;
        doc=new Attachment();
        PageReference pageRef = new PageReference('/'+case_id1);
        List<Attachment> CreatevAttachmentList =[select Id, ParentId, Name, ContentType, BodyLength,IsDeleted
                                        from Attachment
                                        where Parentid=:case_id or ParentId in :attachmentID];
        for(Attachment att : CreatevAttachmentList){
             if(!att.IsDeleted && att.name.contains('#Detail.pdf')){
                 DownloadvDetailAttchtoDelete.add(att);
             }
        }    
        system.debug('DownloadvDetailAttchtoDelete'+DownloadvDetailAttchtoDelete);
        
        try{
            if(DownloadvDetailAttchtoDelete.size()> 0 ) {   
                Delete DownloadvDetailAttchtoDelete;
            }
        }
        catch(Exception e){
           CCP_Exception_Util.CCP_Exception_Mail(e);
           return null;
       }
        //delete vDetailAttchtoDelete;
        return null;
        }
    }
 
   /* public List<Attachment> getAttachments() {
        List<EmailMessage> vEMAttachmentList =  [select id,parentid,BccAddress,ccAddress,FromAddress,FromName,HasAttachment,Headers,HtmlBody,Incoming,Isdeleted,Messagedate,ReplyToEmailMessageId,status,subject,textbody,toaddress,activityid 
        from EmailMessage 
        where parentid = : case_id1 and HasAttachment= true];
        Set<ID> attachmentID = new Set<ID>();
        for(EmailMessage eMail : vEMAttachmentList){
            attachmentID.add(eMail.id);
        }
        vAttchtoDelete = new List <Attachment>();
        List<Attachment> vAttachmentList =[select Id, ParentId, Name, ContentType, BodyLength
                                        from Attachment
                                        where Parentid=:case_id1 or ParentId in :attachmentID];
        List<Attachment> AttachmentList =new List<Attachment>();
                
                for(Attachment atch : vAttachmentList ){
                    if(atch.name.contains('.zip')  ){
                        vAttchtoDelete.add(atch);
                    }
                    else{
                        AttachmentList.add(atch);
                    }
                }
        return AttachmentList;
    }
    */ 
     
    @RemoteAction
    global static AttachmentWrapper getAttachment(String attId) {
         
        Attachment att = [select Id, Name, ContentType, Body
                          from Attachment
                          where Id = :attId];
         
        AttachmentWrapper attWrapper = new AttachmentWrapper();
        attWrapper.attEncodedBody = EncodingUtil.base64Encode(att.body);
        attWrapper.attName = att.Name;
                           
        return attWrapper;
    }
     
    global class AttachmentWrapper {
        public String attEncodedBody {get; set;}
        public String attName {get; set;}
    }
}