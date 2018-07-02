/******************************************************************************************************************
Name: ACP_Attachments_Page_Ctrl
Copyright @ 2017 TE Connectivity
=============================================================================
Requirement:
 ACP_Attachments_Page_Ctrl for ACP_Attachments_Page 
=============================================================================
Purpose:
 This class is used for creating attachment and store the attachment URL in account plan object.
Test Class:
ACP_Attachments_Page_Ctrl_Test
=============================================================================
History
-------
VERSION   AUTHOR      DATE         DETAIL
1.0 -    Nagaraju    10/24/17      INITIAL DEVELOPMENT
********************************************************************************************************************/
public with sharing class ACP_Attachments_Page_Ctrl{
    public ACP_Account_Plan_Attachment__c acpa{get;set;}
    @TestVisible  private ACP_Account_Plan__c acp;
    public Attachment attachment {get;set;}
    @TestVisible private List<ACP_Account_Plan__c>updatAcpList;
    @TestVisible private List<string>latestProductTypeAttachments;
    @TestVisible private List<Attachment> productTypeAttachments;
    @TestVisible private string attchmentUrl;
    /*public Boolean chooseFile {get; set;}
    public String attachmentType {get; set;}
    public String error {get; set;}*/
    public ACP_Attachments_Page_Ctrl() {
        acpa=new ACP_Account_Plan_Attachment__c();
        attachment = new Attachment();
        latestProductTypeAttachments=new List<string>();
        updatAcpList=new List<ACP_Account_Plan__c>();
        string accPlanId= System.currentPagereference().getParameters().get('ACPId');
        if(accPlanId<>null){
            acp=[select Id,Name,Conga_Account_Manager_Image__c ,ACP_Company_Logo_Image__c,ACP_Product_Image1__c,
                 ACP_Product_Image2__c,ACP_Product_Image3__c,ACP_Product_Image4__c,ACP_Product_Image5__c,
                 ACP_Competitor_Img1__c,ACP_Competitor_Img2__c,ACP_Competitor_Img3__c,ACP_Competitor_Img4__c,
                 ACP_Competitor_Img5__c,ACP_Product_Img1_Name__c FROM ACP_Account_Plan__c WHERE id=:accPlanId];

            acpa.ACP_Account_Plan__c=acp.id;
            
        }
    }
    public pageReference saveAttachment(){
        try {
            latestProductTypeAttachments.clear();
            insert acpa;
            try{
                attachment.OwnerId = UserInfo.getUserId();
                attachment.ParentId = acpa.id; 
                attachment.IsPrivate = false;
                if (Schema.sObjectType.Attachment.fields.body.isCreateable()){                
                    insert attachment;
                } 
            }catch(Exception e){            ErrorLogging.Log(e, 'ACP_Attachments_Page_Ctrl','saveAttachment',acp.id);            ApexPages.addMessages(e);
            }
           
            if(acpa.ACP_Type__c=='Product'||acpa.ACP_Type__c=='Competitor'){
                string acpType=acpa.ACP_Type__c;
                List<ACP_Account_Plan_Attachment__c>latestAccPlanAttachments=[SELECT Id,Name,(SELECT Id, Name FROM Attachments) FROM ACP_Account_Plan_Attachment__c
                                                                              WHERE ACP_Type__c=:acpType AND ACP_Account_Plan__c=:acp.id ORDER BY Createddate DESC LIMIT 5];
                
                for(ACP_Account_Plan_Attachment__c ac:latestAccPlanAttachments){
                    string attchmentUrl='https://' + System.URL.getSalesforceBaseUrl().getHost()+ '/'+'servlet/servlet.FileDownload?file='+ac.Attachments[0].Id +'/Name/'+ ac.Attachments[0].Name;
                    latestProductTypeAttachments.add(attchmentUrl);
                }
                System.debug('attachment===>'+latestProductTypeAttachments);
            }
            if(acpa.ACP_Type__c=='Account Manager' ||acpa.ACP_Type__c=='Company Logo'){
                attchmentUrl='https://' + System.URL.getSalesforceBaseUrl().getHost()+ '/'+'servlet/servlet.FileDownload?file='+attachment.Id;
            }
            
            if(acpa.ACP_Type__c=='Account Manager'){
                acp.Conga_Account_Manager_Image__c=attchmentUrl;
                updatAcpList.add(acp);
            }
            else if(acpa.ACP_Type__c=='Company Logo'){
                acp.ACP_Company_Logo_Image__c=attchmentUrl;
                updatAcpList.add(acp);
            }
            else if(acpa.ACP_Type__c=='Product'){
               
                if(!latestProductTypeAttachments.isEmpty()){
                    if(latestProductTypeAttachments.size()>=1)
                    {
                        acp.ACP_Product_Image1__c=latestProductTypeAttachments[0].substringbefore('/Name/');
                        acp.ACP_Product_Img1_Name__c = latestProductTypeAttachments[0].substringbetween('/Name/','.');
                        }
                    if(latestProductTypeAttachments.size()>=2)
                        {
                        acp.ACP_Product_Image2__c=latestProductTypeAttachments[1].substringbefore('/Name/');
                        acp.ACP_Product_Img2_Name__c = latestProductTypeAttachments[1].substringbetween('/Name/','.');
                        }
                    if(latestProductTypeAttachments.size()>=3)
                        {
                        acp.ACP_Product_Image3__c=latestProductTypeAttachments[2].substringbefore('/Name/');
                        acp.ACP_Product_Img3_Name__c = latestProductTypeAttachments[2].substringbetween('/Name/','.');
                        }
                    if(latestProductTypeAttachments.size()>=4)
                        {
                        acp.ACP_Product_Image4__c=latestProductTypeAttachments[3].substringbefore('/Name/');
                        acp.ACP_Product_Img4_Name__c = latestProductTypeAttachments[3].substringbetween('/Name/','.');
                        }
                    if(latestProductTypeAttachments.size()>=5)
                        {
                        acp.ACP_Product_Image5__c=latestProductTypeAttachments[4].substringbefore('/Name/');
                        acp.ACP_Product_Img5_Name__c = latestProductTypeAttachments[4].substringbetween('/Name/','.');
                        }
                }
                updatAcpList.add(acp);
                
            }
            else if(acpa.ACP_Type__c=='Competitor'){
               
                if(!latestProductTypeAttachments.isEmpty()){
                    
                    if(latestProductTypeAttachments.size()>=1)
                    {
                        acp.ACP_Competitor_Img1__c=latestProductTypeAttachments[0].substringbefore('/Name/');
                        acp.ACP_Competitor_Img1_Name__c = latestProductTypeAttachments[0].substringbetween('/Name/','.');
                    }
                    if(latestProductTypeAttachments.size()>=2) 
                        {
                        acp.ACP_Competitor_Img2__c=latestProductTypeAttachments[1].substringbefore('/Name/');
                        acp.ACP_Competitor_Img2_Name__c = latestProductTypeAttachments[1].substringbetween('/Name/','.');
                    }
                    if(latestProductTypeAttachments.size()>=3) 
                       {
                        acp.ACP_Competitor_Img3__c=latestProductTypeAttachments[2].substringbefore('/Name/');
                        acp.ACP_Competitor_Img3_Name__c = latestProductTypeAttachments[2].substringbetween('/Name/','.');
                    }
                    if(latestProductTypeAttachments.size()>=4)
                        {
                        acp.ACP_Competitor_Img4__c=latestProductTypeAttachments[3].substringbefore('/Name/');
                        acp.ACP_Competitor_Img4_Name__c = latestProductTypeAttachments[3].substringbetween('/Name/','.');
                    }
                    if(latestProductTypeAttachments.size()>=5) 
                        {
                        acp.ACP_Competitor_Img5__c=latestProductTypeAttachments[4].substringbefore('/Name/');
                        acp.ACP_Competitor_Img5_Name__c = latestProductTypeAttachments[4].substringbetween('/Name/','.');
                    }
                }
                updatAcpList.add(acp);
            }
            
            update updatAcpList;

            PageReference pageref = new PageReference('/apex/ACP_Account_Plan_Edit');
            pageref.getParameters().put('Id',acp.Id);
            pageref.setRedirect(true);
            return pageref;
        }
        Catch(Exception e) {    ErrorLogging.Log(e, 'ACP_Attachments_Page_Ctrl','cancelAttachment',acp.id);        ApexPages.addMessages(e);        }        return null;
    }
    
    public pageReference cancelAttachment(){
        PageReference pageref = new PageReference('/apex/ACP_Account_Plan_Edit');
        pageref.getParameters().put('Id',acp.id);
        pageref.setRedirect(true);
        return pageref;
    }
    public void cancelAttachment1(){
        integer i;
    }
    
   /* public void checkAttachment(){
    system.debug('type --- ' + acpa.ACP_Type__c);
     choosefile = true;
       error = '';
          Integer count = [SELECT count() FROM ACP_Account_Plan_Attachment__c WHERE ACP_Type__c=: acpa.ACP_Type__c AND ACP_Account_Plan__c=: acp.id ];
  
  if(acpa.ACP_Type__c == 'Account Manager' || acpa.ACP_Type__c == 'Company Logo')
    {
    if(count >0){
       choosefile = false;
       error = 'You cannot upload more than 1 image for ';
    }
    }
    else
    {
    if(count > 4) 
    {
     choosefile = false;
       error = 'You cannot upload more than 5 images for ';
    }
    
 }
    
    system.debug('count  --' + count);
}*/
}