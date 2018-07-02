/******************************************************************************************************************
Name: ACP_Account_Plan_Edit_Ctrl_Test
Copyright @ 2017 TE Connectivity
=============================================================================
Requirement:
 ACP_Account_Plan_Edit_Ctrl for ACP_Account_Plan_Edit page
=============================================================================
Purpose:
 This class is used for update the account plan record and add the account plan attachments.
=============================================================================
History
-------
VERSION   AUTHOR      DATE         DETAIL
1.0 -    Nagaraju    10/30/17      INITIAL DEVELOPMENT
********************************************************************************************************************/
@isTest
Private Class ACP_Account_Plan_Edit_Ctrl_Test{
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
            
       
        Apexpages.currentPage().getParameters().put('id', accPlan.id);
        Apexpages.currentPage().getParameters().put('SelectedAccountId', accPlan.id);
        ApexPages.StandardController stdController = new ApexPages.StandardController(accPlan);
        ACP_Account_Plan_Edit_Ctrl acpEdit=new ACP_Account_Plan_Edit_Ctrl(stdController);
        acpEdit.gotoAttachmentPage();
        acpEdit.updateAccountPlan();
        acpEdit.DeleteAccount();
        acpEdit.cancelEdit();
         test.stopTest();
        
     }
     static testMethod void strategy_TestMethod1() {
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
            
       
        Apexpages.currentPage().getParameters().put('id', accPlan.id);
        Apexpages.currentPage().getParameters().put('SelectedAccountId', accPlan.id);
        ApexPages.StandardController stdController = new ApexPages.StandardController(accPlan);
        ACP_Account_Plan_Edit_Ctrl acpEdit=new ACP_Account_Plan_Edit_Ctrl(stdController);
        //acpEdit.SelectedAccountId=accPlan.id;
        //acpEdit.cancelRec();
        acpEdit.DeleteAccount();
        test.stopTest();
      
     }
    }