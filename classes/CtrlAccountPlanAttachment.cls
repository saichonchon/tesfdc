/**
 *  Controller class for page CtrlAccountPlanAttachment_generateAttach
 * 
 * @author Yuanyuan Zhang
 * @created 2012-05-18
 * @version 1.0
 * @since 23.0(ForceIDE Version)
 * 
 * 
 *
 * @changelog
 * 2012-05-18 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
 * - Created   
 *
 */

public class CtrlAccountPlanAttachment {

    public String accountPlanId{get;set;}
    public String parentName{get;set;}
    public Account_Plan_Attachment__c accountPlanAttachment{get;set;}
    public Attachment att{get;set;}
    Public String attachmentName{get;set;}
    Public Blob attachmentBody{get;set;}
    Public Blob attachmentSize{get;set;}
    Public Boolean finishedInsert{get;set;}
    Public Boolean error{get;set;}
    Public Boolean errorTwo{get;set;}
    
    //constructor
    public CtrlAccountPlanAttachment(){
        error = false;
        //finishedInsert = false;
        accountPlanAttachment = new Account_Plan_Attachment__c();
        att = new Attachment();
        accountPlanId = ApexPages.CurrentPage().getParameters().get('id');
        parentName = ApexPages.CurrentPage().getParameters().get('parentName');
        finishedInsert = false;
    }
             
    public pagereference save(){        
        if(att.Body == null){
            error = true;
            finishedInsert = false;
            return null;
        }  
        if(att.BodyLength > 3){
            error = true;
            finishedInsert = false;
            return null;
        }       
        else if(attachmentName == 'Logo.jpg'){
            errorTwo = true;
            finishedInsert = false;
            return null;
        }
        else if(attachmentName == 'VoiceOverview.wav'){
            errorTwo = true;
            finishedInsert = false;
            return null;
        }
        else if(attachmentName == 'Photo.jpg'){
            errorTwo = true;
            finishedInsert = false;
            return null;
        }
        else if(attachmentName.startsWith('Picture')){
        	errorTwo = true;
            finishedInsert = false;
            return null;
        }
        else{     
          att.Name = attachmentName;
          att.ParentId = accountPlanId;     
          try{      
            insert att;
          }
          catch(Exception ex){
            accountPlanAttachment = new Account_Plan_Attachment__c();
            att = new Attachment();
            error = true;
            finishedInsert = false;
            return null;
          }
        
          accountPlanAttachment.Name = att.Name;
          accountPlanAttachment.Account_Plan__c = accountPlanId;
          accountPlanAttachment.AttachmentId__c = att.Id;
          accountPlanAttachment.Type__c = 'Attachment';
          accountPlanAttachment.Content_Type__c = att.ContentType;
          insert accountPlanAttachment;       
        
          finishedInsert = true;
          error = false;
          accountPlanAttachment = new Account_Plan_Attachment__c();
          att = new Attachment();
        }
        return null;
    }
}