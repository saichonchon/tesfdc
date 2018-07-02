/******************************************************************************************************************
Name: ACP_Attachments_Page_Ctrl_Test
Copyright @ 2017 TE Connectivity
=============================================================================
Requirement:
 ACP_Attachments_Page_Ctrl for ACP_Attachments_Page 
=============================================================================
Purpose:
 This class is used for creating attachment and store the attachment URL in account plan object.
=============================================================================
History
-------
VERSION   AUTHOR      DATE         DETAIL
1.0 -    Nagaraju    10/24/17      INITIAL DEVELOPMENT
********************************************************************************************************************/
@isTest
Private Class ACP_Attachments_Page_Ctrl_Test{
    static testMethod void strategy_TestMethod() {
      test.startTest();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();     
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        ClsTestCustomSettingHelper.getADMTerritoryCode();
         RecordType rt = Clstesthelp.createTestRecordType7();
         
        Account acct = ClsTestHelp.createtestAccounts();            
        insert acct;
        
        ACP_Account_Plan__c accplan = ACP_TestDataFactory.createAccountPlan(); 
        accPlan.ACP_Account_Name__c = acct.id;
        insert accPlan;
            
        ACP_Account_Plan_Attachment__c AccPlanAtt1 = new ACP_Account_Plan_Attachment__c();
        AccPlanAtt1.ACP_Account_Plan__c = accPlan.id;
        AccPlanAtt1.ACP_Type__c = 'Product';
        insert AccPlanAtt1;
        System.assertEquals('Product', AccPlanAtt1.ACP_Type__c);
       

        Attachment attach=new Attachment(); 
        attach.Name='Unit Test Attachment'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body'); 
        attach.body=bodyBlob; 
        attach.parentId=AccPlanAtt1.Id; 
        attach.ContentType = 'application/msword'; 
        attach.IsPrivate = false; 
        attach.Description = 'Test'; 
        insert attach; 
        //ACP_Attachments_Page_Ctrl.uniqueId = 'CF00N0S000000Qrt6_lkid';
         System.debug('Inserted: '+ attach.Id); 
         /* 
        List<ACP_Account_Plan_Attachment__c > acctlist = [SELECT id, Name, 
        (SELECT Id FROM c) 
        FROM ACP_Account_Plan_Attachment__c where id = :AccPlanAtt1.Id]; 
        test.stopTest();
          
        System.debug('Account Query : '+acctlist); */
        Apexpages.currentPage().getParameters().put('returl', accPlan.id);  
        Apexpages.currentPage().getParameters().put('ACPId', accPlan.id);
        ACP_Attachments_Page_Ctrl acp=new ACP_Attachments_Page_Ctrl();
       
        acp.acpa.ACP_Type__c = 'Product';
        acp.attachment.Name='Unit Test Attachment';
         Blob bodyBlob2=Blob.valueOf('Unit Test Attachment Body'); 
        acp.attachment.body=bodyBlob2; 
        acp.attachment.parentId=AccPlanAtt1.Id; 
        acp.attachment.ContentType = 'application/msword';    
            
        acp.saveAttachment();
        acp.cancelAttachment();
    }
     static testMethod void strategy_TestMethod1() {
      
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();     
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        ClsTestCustomSettingHelper.getADMTerritoryCode();
         RecordType rt = Clstesthelp.createTestRecordType7();
         
        Account acct = ClsTestHelp.createtestAccounts();            
        insert acct;
        
        ACP_Account_Plan__c accplan = ACP_TestDataFactory.createAccountPlan(); 
        accPlan.ACP_Account_Name__c = acct.id;
        insert accPlan;
            
        ACP_Account_Plan_Attachment__c AccPlanAtt1 = new ACP_Account_Plan_Attachment__c();
         
        AccPlanAtt1.ACP_Account_Plan__c = accPlan.id;
        AccPlanAtt1.ACP_Type__c = 'Competitor';
        insert AccPlanAtt1;
        System.assertEquals('Competitor', AccPlanAtt1.ACP_Type__c);
      
       Attachment attach=new Attachment(); 
        attach.Name='Unit Test Attachment'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body'); 
        attach.body=bodyBlob; 
        attach.parentId=AccPlanAtt1.Id; 
        attach.ContentType = 'application/msword'; 
        attach.IsPrivate = false; 
        attach.Description = 'Test'; 
        insert attach; 
        
         System.debug('Inserted: '+ attach.Id); 
        /*  
        List<ACP_Account_Plan_Attachment__c > acctlist = [SELECT id, Name, 
        (SELECT Id FROM CombinedAttachments) 
        FROM ACP_Account_Plan_Attachment__c where id = :AccPlanAtt1.Id]; 
    
          
        System.debug('Account Query : '+acctlist); */
        Apexpages.currentPage().getParameters().put('returl', accPlan.id);  
        Apexpages.currentPage().getParameters().put('ACPId', accPlan.id);
        ACP_Attachments_Page_Ctrl acp=new ACP_Attachments_Page_Ctrl();
        
        acp.acpa.ACP_Type__c = 'Competitor';
        acp.attachment.Name='Unit Test Attachment';
         Blob bodyBlob2=Blob.valueOf('Unit Test Attachment Body'); 
        acp.attachment.body=bodyBlob2; 
        acp.attachment.parentId=AccPlanAtt1.Id; 
        acp.attachment.ContentType = 'application/msword';
        acp.saveAttachment();
        acp.cancelAttachment1();
    }
     static testMethod void strategy_TestMethod2() {
      
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();     
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        ClsTestCustomSettingHelper.getADMTerritoryCode();
         RecordType rt = Clstesthelp.createTestRecordType7();
         
        Account acct = ClsTestHelp.createtestAccounts();            
        insert acct;
        
        ACP_Account_Plan__c accplan = ACP_TestDataFactory.createAccountPlan(); 
        accPlan.ACP_Account_Name__c = acct.id;
        insert accPlan;
            
        ACP_Account_Plan_Attachment__c AccPlanAtt1 = new ACP_Account_Plan_Attachment__c();
         
        AccPlanAtt1.ACP_Account_Plan__c = accPlan.id;
        AccPlanAtt1.ACP_Type__c = 'Competitor';
        insert AccPlanAtt1;
        System.assertEquals('Competitor', AccPlanAtt1.ACP_Type__c);
       
        Apexpages.currentPage().getParameters().put('returl', accPlan.id);  
        Apexpages.currentPage().getParameters().put('ACPId', accPlan.id);
        ACP_Attachments_Page_Ctrl acp=new ACP_Attachments_Page_Ctrl();
        
        acp.acpa.ACP_Type__c = 'Company Logo';
        acp.attachment.Name='Unit Test Attachment';
         Blob bodyBlob2=Blob.valueOf('Unit Test Attachment Body'); 
        acp.attachment.body=bodyBlob2; 
        acp.attachment.parentId=AccPlanAtt1.Id; 
        acp.attachment.ContentType = 'application/msword';
        acp.saveAttachment();

    }
    static testMethod void strategy_TestMethod3() {
      
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();     
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        ClsTestCustomSettingHelper.getADMTerritoryCode();
         RecordType rt = Clstesthelp.createTestRecordType7();
         
        Account acct = ClsTestHelp.createtestAccounts();            
        insert acct;
        
        ACP_Account_Plan__c accplan = ACP_TestDataFactory.createAccountPlan(); 
        accPlan.ACP_Account_Name__c = acct.id;
        insert accPlan;
            
        ACP_Account_Plan_Attachment__c AccPlanAtt1 = new ACP_Account_Plan_Attachment__c();
         
        AccPlanAtt1.ACP_Account_Plan__c = accPlan.id;
        AccPlanAtt1.ACP_Type__c = 'Competitor';
        insert AccPlanAtt1;
        System.assertEquals('Competitor', AccPlanAtt1.ACP_Type__c);
       
        Apexpages.currentPage().getParameters().put('returl', accPlan.id);  
        Apexpages.currentPage().getParameters().put('ACPId', accPlan.id);
        ACP_Attachments_Page_Ctrl acp=new ACP_Attachments_Page_Ctrl();
        
        acp.acpa.ACP_Type__c = 'Account Manager';
        acp.attachment.Name='Unit Test Attachment';
         Blob bodyBlob2=Blob.valueOf('Unit Test Attachment Body'); 
        acp.attachment.body=bodyBlob2; 
        acp.attachment.parentId=AccPlanAtt1.Id; 
        acp.attachment.ContentType = 'application/msword';
        acp.saveAttachment();
    }
}