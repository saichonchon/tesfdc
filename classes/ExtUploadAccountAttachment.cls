/**
 *  Class to upload a Attachment and save correspond value to Account_Attachment__c
 *  
 * @author Yinfeng Guo
 * @created 2012-02-14
 * @version 1.0
 * @since 23.0
 * 
 *
 * @changelog
 * 2012-02-14 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Created   
 *
 */

public class ExtUploadAccountAttachment {
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	/**
	 * object Account_Attachment__c variable 
	 */		
   	public Account_Attachment__c accountAttachment { set; get; }
   	
   	/**
	 * object Attachment variable 
	 */	
   	public Attachment attachment { set; get; }
   	
   	/**
	 * the account's name 
	 */	
   	public String accountName{ set; get; }
   	
    /**
	 * this variable to tell us whether is update
	 * if the standardAttachment already exist, then this variable is true
	 */   	
    public Boolean isUpdate { set; get; }
    
    /**
	 * this variable to tell us whether is view
	 */  
    public Boolean isView { set; get; }
    
    /**
	 * the account id
	 */ 
    public Id accountId { set; get; }
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
	/**
	 * the standard controller variable
	 */	        
    private final ApexPages.standardController controller;  
    
    /**
	 * the attachment id
	 */	
   	private Id attachmentId;
   	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   	
   	/////////////////////////////////// -=BEGIN CONSTRUCTOR=- ///////////////////////////////////// 
   /**
	* The contsructor
	*
	@author Yinfeng Guo
	@created 2012-02-14
	@version 1.0
	@since 23.0 (Force.com ApiVersion)
	*
	@changelog
	* 2012-02-14 Yinfeng Guo <yinfeng.guo@itbconsult.com>
	* - Created
	*/    	   
	public ExtUploadAccountAttachment (ApexPages.StandardController ctrl) {  
        this.controller = ctrl;
        attachment = new Attachment();
        this.isUpdate = false;
		this.isView = false;
		//this.accountId = '';
		
		/*new*/
        if(ApexPages.currentPage().getParameters().get('CF00NL0000000OWGE_lkid') != null){
        	 this.accountId = ApexPages.currentPage().getParameters().get('CF00NL0000000OWGE_lkid');
        }
        if(ApexPages.currentPage().getParameters().get('CF00NL0000000OWGE') != null){
        	 this.accountName = ApexPages.currentPage().getParameters().get('CF00NL0000000OWGE');
        }
        else if(ApexPages.currentPage().getParameters().get('retURL') == null){
        	this.isView = true;
        	this.attachmentId = ApexPages.currentPage().getParameters().get('id');
        }
        else if(ApexPages.currentPage().getParameters().get('id') != null){
            this.attachmentId = ApexPages.currentPage().getParameters().get('id');
            this.isUpdate = true;
        }

        if(this.isView || this.isUpdate){
        	accountAttachment = [select Open_Attachment__c, Account__c, Attachment_Name__c, Attachment_Id__c, OwnerId, CreatedById, LastModifiedById  from Account_Attachment__c where Id = :this.attachmentId];
        	attachment = [Select Id, Body, Name, ContentType From Attachment Where Id = :this.accountAttachment.Attachment_Id__c];
        	this.accountId = accountAttachment.Account__c;
            accountName = [Select Name From Account Where Id =: accountId].Name;
        }
        else {
            accountAttachment = new Account_Attachment__c();
        }

	}  
	/////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
	
	//********************************* -=BEGIN public methods=- **********************************
	/**
	 * This method is used when upload a account attachment,
	 * this method is used to upload attachment and replicate the attachment id and attachment name to Account_Attachment__c
	 *
	 @author Yinfeng Guo
	 @created 2012-02-14
	 @version 1.0
	 @since 23.0
  	 *
	 @return         the account's PageReference according to account's id	
	 *
	 @changelog
	 * 2012-02-14 Yinfeng Guo <yinfeng.guo@itbconsult.com>
	 * - Created
	 */	
	public PageReference uploadAccountAttachment(){
        try{
        	if(!this.isUpdate){
        		accountAttachment.Account__c = this.accountId;
        		insert accountAttachment;
        	}
        	
	        if (accountAttachment.Attachment_Name__c != null) {
	            this.attachment.Name = accountAttachment.Attachment_Name__c;
	        }
	        else {
	            this.attachment.Name = this.attachment.Name;
	        }
	        if(!this.isUpdate){
	        	this.attachment.ParentId = this.accountAttachment.Id;
	        }
	        upsert this.attachment;
	        
	       	Id attachId = [Select Id From Attachment Where Id =: this.attachment.Id].Id;
	        
            accountAttachment.Attachment_Name__c = this.attachment.Name;
            accountAttachment.Attachment_Id__c = String.valueOf(attachId);
            update accountAttachment;	
                     	
        }
        catch( Exception e ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }
        PageReference pageRef = new PageReference('/'+ this.accountId);
        pageRef.setRedirect( true );
        return pageRef;
    }

	/**
	 * This method is a get Method for Object ExtUploadAccountAttachment
	 *
	 @author Yinfeng Guo
	 @created 2012-02-14
	 @version 1.0
	 @since 23.0
  	 *
	 @return         ExtUploadAccountAttachment object	
	 *
	 @changelog
	 * 2012-02-14 Yinfeng Guo <yinfeng.guo@itbconsult.com>
	 * - Created
	 */	    
    public ExtUploadAccountAttachment getExtUploadAccountAttachment() {
    	return this;
    }

	/**
	 * This method is used when click 'Cancel' Button on vf page,
	 * this method is used to redirect the before page
	 *
	 @author Yinfeng Guo
	 @created 2012-02-13
	 @version 1.0
	 @since 23.0
  	 *
	 @return         the before page	
	 *
	 @changelog
	 * 2012-02-14 Yinfeng Guo <yinfeng.guo@itbconsult.com>
	 * - Created
	 */	    
    public PageReference cancel(){
        PageReference pageRef = new PageReference('/'+ this.accountId);
        pageRef.setRedirect( true );
        return pageRef;
    }

	/**
	 * This method is used when click 'Back' Button on vf page,
	 * this method is used to redirect the before page
	 *
	 @author Yinfeng Guo
	 @created 2012-02-13
	 @version 1.0
	 @since 23.0
  	 *
	 @return         the before page	
	 *
	 @changelog
	 * 2012-02-14 Yinfeng Guo <yinfeng.guo@itbconsult.com>
	 * - Created
	 */	     
    public PageReference back(){
        PageReference pageRef = new PageReference('/'+ this.accountId);
        pageRef.setRedirect( true );
        return pageRef;
    }
    //********************************* -=END public methods=- ************************************
}