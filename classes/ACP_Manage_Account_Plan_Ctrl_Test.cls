/***************************************************************************************
Name:ACP_Manage_Account_Plan_Ctrl_Test
Class:ACP_Manage_Account_Plan_Ctrl
Copyright © 2017 TE Connectivity
=========================================================================================
Requirement:
test class for ACP_Manage_Account_Plan_Ctrl
=========================================================================================
Purpose:
Used for ACP_Manage_Account_Plan_Ctrl.
=========================================================================================
History
-------
Version      Author                     Date              Detail
1.0          Ritika Pahwa           11/02/17          Covering methods of apex class
****************************************************************************************/
@isTest
private class ACP_Manage_Account_Plan_Ctrl_Test {

  static testMethod void testMethods() {


    Test.startTest();
    User u = ClsTestHelp.createTestUsers();
    insert u;
    Consumer_Device_Opportunity_Record_Types__c CDORT = ClsTestHelp.createTestCSD7();
    Consumer_Device_Opportunity_Record_Types__c CDORT1 = ClsTestHelp.createTestCSD3();
    Consumer_Device_Opportunity_Record_Types__c CDORT2 = ClsTestHelp.createTestCSD1();
    ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();

    ClsTestCustomSettingHelper.getApex_Helper_Settings();
    ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
    ClsTestCustomSettingHelper.getADMTerritoryCode();
    RecordType rt1 = ClsTestHelp.createTestRecordType();
    Account acc1 = ClsTestHelp.createTestAccounts();
    acc1.RecordTypeId = rt1.Id;
    acc1.Account_Manager__c = u.Id;
    acc1.OwnerId = u.Id;
    insert acc1;



    ApexPages.currentPage().getParameters().put('accId', acc1.Id);
    ACP_Manage_Account_Plan_Ctrl ctrl = new ACP_Manage_Account_Plan_Ctrl();
    ACP_Account_Plan__c getaccDet = ctrl.getaccDet();
    ctrl.newOrViewAccountPlan();
    ctrl.createAccountPlan();
    ctrl.cancel();

    ApexPages.currentPage().getParameters().put('acchgId', acc1.Id);
    ACP_Manage_Account_Plan_Ctrl ctrl2 = new ACP_Manage_Account_Plan_Ctrl();
    ACP_Account_Plan__c getaccDet2 = ctrl2.getaccDet();
    ctrl2.newOrViewAccountPlan();

    Test.stopTest();
  }
  static testMethod void testMethodsNegativeCase() {


    Test.startTest();
    User u = ClsTestHelp.createTestUsers();
    insert u;

    Consumer_Device_Opportunity_Record_Types__c CDORT = ClsTestHelp.createTestCSD7();
    Consumer_Device_Opportunity_Record_Types__c CDORT1 = ClsTestHelp.createTestCSD3();
    Consumer_Device_Opportunity_Record_Types__c CDORT2 = ClsTestHelp.createTestCSD1();
    ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
    ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
    ClsTestCustomSettingHelper.getApex_Helper_Settings();
    ClsTestCustomSettingHelper.getADMTerritoryCode();

    RecordType rt1 = ClsTestHelp.createTestRecordType();
    Account account = ClsTestHelp.createTestAccounts();
    account.RecordTypeId = rt1.Id;
    account.OwnerId = u.Id;
    insert account;

    ACP_Account_Plan__c newAccPlan = new ACP_Account_Plan__c(
      Name = 'TestAccountPlan3564',
      ACP_Account_Name__c = account.Id,
      ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3564');
    insert(newAccPlan);



    ApexPages.currentPage().getParameters().put('accId', account.Id);
    ACP_Manage_Account_Plan_Ctrl ctrlobj = new ACP_Manage_Account_Plan_Ctrl();
    ACP_Account_Plan__c getaccDet = ctrlobj.getaccDet();
    ctrlobj.newOrViewAccountPlan();

    Test.stopTest();

  }


}