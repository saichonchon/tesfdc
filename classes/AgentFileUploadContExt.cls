/************************************************************************************************************************************************************************************************************************
Name: AgentFileUploadContExt 
===========================================================================================================================================================================================================
Purpose: This class was part of Central org and moved in C2S for PIC Migration. 
         This is extension class for page AgentFileUpload used to let agent upload file using quick text Url's during live chat for Pic 
===========================================================================================================================================================================================================
***********************************************************************************************************************************************************************************************************************/

public class AgentFileUploadContExt {
    private ApexPages.StandardController stdController;
    private LiveAgentModel liveAgentModel;
    private AgentFileUpload__c agentFileUploadStrings = AgentFileUpload__c.getInstance('Default');
    public Transient Blob fileBody {get; set;}
    public String agentId = ApexPages.currentPage().getParameters().get( 'agentId' );
    public Attachment attachment {
        get {
            if (attachment == null) attachment = new Attachment();
            return attachment;
        }
        set;
    }
    public Boolean renderFileUpload{
        get{
            if( renderFileUpload != null ){
                return renderFileUpload;
            } else {
                return true;
            }
        } 
        set;
    }
    public AgentFileUploadContExt( ApexPages.StandardController stdController ) {
        this.stdController = stdController;
    }
    
    public void init(){
        
        if( agentId != null && agentId != '' 
            && ( BluewolfDevUtils.isIdsObjectTypeEqualToStringObjectType( agentId, BluewolfDevUtils.GROUP_OBJECT_NAME_STRING )
                || BluewolfDevUtils.isIdsObjectTypeEqualToStringObjectType( agentId, BluewolfDevUtils.USER_OBJECT_NAME_STRING) ) ){
            liveAgentModel = new liveAgentModel( agentId );
        } else {
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, agentFileUploadStrings.Please_use_another_link__c ) );
            renderFileUpload = false;
        }
    }
    
    public void upload() {
        if( fileBody.size() > 5000000 ){
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'The file cannot be above 5MB.  Please try again with a smaller file size.' ) );
            return;
        }
        
        try{
            liveAgentModel.upsertRecord();
        } catch ( DMLException dmlEx ){
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, agentFileUploadStrings.Live_Agent_is_not_saved__c + dmlEx.getDmlMessage( 0 ) ) );
            return;
        }
        
        attachment.OwnerId = agentId;
        attachment.ParentId = liveAgentModel.recordId();
        attachment.IsPrivate = false;
        attachment.body = fileBody;

        try{
            upsert attachment;
            renderFileUpload = false;
            ApexPages.addMessage( new ApexPages.message( ApexPages.severity.CONFIRM, agentFileUploadStrings.Thank_you_for_upload__c ) );
        } catch ( DMLException dmlEx ){
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, agentFileUploadStrings.Please_choose_file_to_upload__c ) );
        }
    }
}