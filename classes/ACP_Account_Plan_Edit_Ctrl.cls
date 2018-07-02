/******************************************************************************************************************
Name: ACP_Account_Plan_Edit_Ctrl
Copyright @ 2017 TE Connectivity
=============================================================================
Requirement:
ACP_Account_Plan_Edit_Ctrl for ACP_Account_Plan_Edit page
=============================================================================
Purpose:
This class is used for update the account plan record and add the account plan attachments.
Test Class:
ACP_Account_Plan_Edit_Ctrl _Test
=============================================================================
History
-------
VERSION   AUTHOR      DATE         DETAIL
1.0 -    Nagaraju    10/28/17      INITIAL DEVELOPMENT
2.0      Nagaraju    11/21/2017     Upadate the clas as per review comments.
*******************************************************************************************************************/
public class ACP_Account_Plan_Edit_Ctrl {
    public List<ACP_Account_Plan_Attachment__c> acpaList{get;set;} 
    public ACP_Account_Plan__c accplan{get;set;}
    public string accPlanId;
    public string SelectedAccountId { get; set;}
    public Map<Id, ACP_Account_Plan_Attachment__c>delMap= new Map<Id,ACP_Account_Plan_Attachment__c>();
    public ACP_Account_Plan_Edit_Ctrl(ApexPages.StandardController controller) {
        acpaList=new List<ACP_Account_Plan_Attachment__c>();
        accPlanId=ApexPages.currentPage().getParameters().get('id');
        //returl=ApexPages.currentPage().getParameters().get('retURL');
        if(accPlanId<>null){
            accplan=[SELECT Id,Name,ACP_Account_Name__c,ACP_Account_Manager__c ,ACP_Account_Summary__c,Account_Plan_Type__c 
                     FROM ACP_Account_Plan__c WHERE Id=:accPlanId];
            acpaList = [SELECT Id, Name, ACP_Type__c,ACP_Account_Plan__c,Conga_Attachment_Update__c, 
                        (SELECT Id,Name FROM Attachments)FROM ACP_Account_Plan_Attachment__c WHERE ACP_Account_Plan__c =:accPlanId ORDER BY createddate desc]; // this will return current record object(child) detail from that you can use parent Id .
            for(ACP_Account_Plan_Attachment__c acp:acpaList){
                delMap.put(acp.id,acp);
            }
        }
        
    }
    public pageReference gotoAttachmentPage(){
        PageReference pageref = new PageReference('/apex/ACP_Attachments_Page?ACPId='+accPlanId );//+'&retURL='+returl);
        //PageReference pageref = new PageReference(ApexPages.currentPage().getParameters().get('returl'));
        //pageref.getParameters().put('ACPId',accPlanId);
        pageref.setRedirect(true);
        return pageref;
    }
    
    public pageReference updateAccountPlan(){
        try{
            update accplan;
            
            PageReference pageref = new PageReference('/apex/ACP_View_Customer_Page?acpId='+accPlanId);
            pageref.setRedirect(true);
            return pageref;
        }Catch(Exception e) {ErrorLogging.Log(e, 'ACP_Account_Plan_Edit_Ctrl','updateAccountPlan',accplan.id); ApexPages.addMessages(e);} return null;
       
    } 
    public pageReference DeleteAccount(){
        
        if(SelectedAccountId<>null)
            delete (delMap.get(SelectedAccountId)); 
        
        PageReference pageref = new PageReference('/apex/ACP_Account_Plan_Edit?Id='+accPlanId );//+'&retURL='+returl);
        pageref.setRedirect(true);
        return pageref;
        
    } 
    public pageReference cancelEdit(){
        PageReference pageref = new PageReference('/apex/ACP_View_Customer_Page?acpId='+accPlanId);
        pageref.setRedirect(true);
        return pageref;
    }
    /* public pageReference cancelRec(){
PageReference pageref = new PageReference('/apex/ACP_View_Customer_Page?acpId='+accPlanId);
pageref.setRedirect(true);
return pageref;
}*/
}