/******************************************************************************************************************
Name: ACP_New_Action_Ext_Test
Copyright @ 2017 TE Connectivity
=============================================================================
Requirement:
Test class for ACP_New_Action_Ext
=============================================================================
Purpose:
Extension controller for page ACP_New_Action to override standard Save and Cancel button 

=============================================================================
History
-------
VERSION   AUTHOR        DATE         DETAIL
1.0 -    Alka Kumari    05/02/17     INITIAL DEVELOPMENT
2.0 -    Anushka Bansal 11/02/17     Added comments 
********************************************************************************************************************/
@isTest
Private Class ACP_New_Action_Ext_Test {
 @testSetup static void setup() {
  User u = ClsTestHelp.createtestUsers();
  insert u;
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

  ACP_Account_Plan__c newAccPlan = new ACP_Account_Plan__c(
   Name = 'TestAccountPlan3564',
   ACP_Account_Name__c = acct.Id,
   //Account_Plan_Type__c = 'Gam Account',        
   ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3564');
  insert newAccPlan;

 }


 static testMethod void addNewActionTest() {

  ACP_Account_Plan__c accPlan = [Select id from ACP_Account_Plan__c limit 1];
  //ACP_Account_Plan__c accPlan = ACP_TestDataFactory.createAccountPlan();
  Test.startTest();
  Test.setCurrentPageReference(new PageReference('Page.ACP_New_Action'));
  System.currentPageReference().getParameters().put('acpId', accPlan.id);
  System.currentPageReference().getParameters().put('category', 'Stakeholder and Relationship');
  Task acpTask1 = new Task();
  ApexPages.StandardController sc = new ApexPages.StandardController(acpTask1);
  ACP_New_Action_Ext ext = new ACP_New_Action_Ext(sc);

  Id tskRecordType = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Account Plan').getRecordTypeId();
  acpTask1.recordtypeid = tskRecordType;
  acpTask1.Subject = 'New Task Assigned';
  acpTask1.Escalation_Reason__c = 'ACP New Task';
  ext.tsk = acpTask1;
  PageReference savePage = ext.save();
  PageReference cancelPage = ext.cancel();
  Test.stopTest();

 }

 static testMethod void saveAndNewTest() {

  ACP_Account_Plan__c accPlan = [Select id from ACP_Account_Plan__c limit 1];
  Test.startTest();
  Test.setCurrentPageReference(new PageReference('Page.ACP_New_Action'));
  System.currentPageReference().getParameters().put('acpId', accPlan.id);
  System.currentPageReference().getParameters().put('category', 'Application Breakdown');
  //Task acpTask = ACP_TestDataFactory.createTask('Stakeholder and Relationship');
  Task tskNew = new Task();
  ApexPages.StandardController sc = new ApexPages.StandardController(tskNew);
  ACP_New_Action_Ext ext = new ACP_New_Action_Ext(sc);
  Id tskRecordType = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Account Plan').getRecordTypeId();
  tskNew.recordtypeid = tskRecordType;
  tskNew.Subject = 'Test Task';
  tskNew.Escalation_Reason__c = 'ACP New Task';
  ext.tsk = tskNew;
  PageReference savePage = ext.saveAndNew();

  Test.stopTest();

 }
 static testMethod void addNewActionTest2() {

  ACP_Account_Plan__c accPlan = [Select id from ACP_Account_Plan__c limit 1];
  Test.startTest();
  Test.setCurrentPageReference(new PageReference('Page.ACP_New_Action'));
  System.currentPageReference().getParameters().put('acpId', accPlan.id);
  System.currentPageReference().getParameters().put('category', 'Top Open Opportunities');
  Task acpTask1 = new Task();
  ApexPages.StandardController sc = new ApexPages.StandardController(acpTask1);
  ACP_New_Action_Ext ext = new ACP_New_Action_Ext(sc);
  PageReference cancelPage = ext.cancel();
  Test.stopTest();

 }
 static testMethod void addNewActionTest3() {

  ACP_Account_Plan__c accPlan = [Select id from ACP_Account_Plan__c limit 1];
  Test.startTest();
  Test.setCurrentPageReference(new PageReference('Page.ACP_New_Action'));
  System.currentPageReference().getParameters().put('acpId', accPlan.id);
  System.currentPageReference().getParameters().put('category', 'ADM Market & Competition');
  Task acpTask1 = new Task();
  ApexPages.StandardController sc = new ApexPages.StandardController(acpTask1);
  ACP_New_Action_Ext ext = new ACP_New_Action_Ext(sc);
  PageReference cancelPage = ext.cancel();
  Test.stopTest();

 }
 static testMethod void addNewActionTest4() {

  ACP_Account_Plan__c accPlan = [Select id from ACP_Account_Plan__c limit 1];
  Test.startTest();
  Test.setCurrentPageReference(new PageReference('Page.ACP_New_Action'));
  System.currentPageReference().getParameters().put('acpId', accPlan.id);
  System.currentPageReference().getParameters().put('category', 'Supplier Evaluation');
  Task acpTask1 = new Task();
  ApexPages.StandardController sc = new ApexPages.StandardController(acpTask1);
  ACP_New_Action_Ext ext = new ACP_New_Action_Ext(sc);
  PageReference savePage = ext.cancel();

  Test.stopTest();

 }
 static testMethod void addNewActionTest5() {

  ACP_Account_Plan__c accPlan = [Select id from ACP_Account_Plan__c limit 1];
  Test.startTest();
  Test.setCurrentPageReference(new PageReference('Page.ACP_New_Action'));
  System.currentPageReference().getParameters().put('acpId', accPlan.id);
  System.currentPageReference().getParameters().put('category', 'Market and Competition');
  Task acpTask1 = new Task();
  ApexPages.StandardController sc = new ApexPages.StandardController(acpTask1);
  ACP_New_Action_Ext ext = new ACP_New_Action_Ext(sc);
  PageReference savePage = ext.cancel();

  Test.stopTest();

 }
 static testMethod void addNewActionTest6() {

  ACP_Account_Plan__c accPlan = [Select id from ACP_Account_Plan__c limit 1];
  Test.startTest();
  Test.setCurrentPageReference(new PageReference('Page.ACP_New_Action'));
  System.currentPageReference().getParameters().put('acpId', accPlan.id);
  System.currentPageReference().getParameters().put('category', 'Application Breakdown');
  Task acpTask1 = new Task();
  ApexPages.StandardController sc = new ApexPages.StandardController(acpTask1);
  ACP_New_Action_Ext ext = new ACP_New_Action_Ext(sc);
  PageReference savePage = ext.cancel();
  Test.stopTest();

 }
 static testMethod void addNewActionTest7() {

  ACP_Account_Plan__c accPlan = [Select id from ACP_Account_Plan__c limit 1];
  Test.startTest();
  Test.setCurrentPageReference(new PageReference('Page.ACP_New_Action'));
  System.currentPageReference().getParameters().put('acpId', accPlan.id);
  System.currentPageReference().getParameters().put('category', 'Business Performance');
  Task acpTask1 = new Task();
  ApexPages.StandardController sc = new ApexPages.StandardController(acpTask1);
  ACP_New_Action_Ext ext = new ACP_New_Action_Ext(sc);
  PageReference savePage = ext.cancel();
  Test.stopTest();


 }

}