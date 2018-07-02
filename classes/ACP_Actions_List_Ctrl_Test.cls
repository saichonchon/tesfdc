/******************************************************************************************************************
Name: ACP_Actions_List_Ctrl_Test
Copyright @ 2017 TE Connectivity
=============================================================================
Requirement:
Test class for ACP_Actions_List_Ctrl
=============================================================================
Purpose:
Controller for VF Page ACP_Actions_List which is created to show Actions list 
when there are more than 10 records.
=============================================================================
History
-------
VERSION   AUTHOR        DATE         DETAIL
1.0 -    Alka Kumari    07/07/17     INITIAL DEVELOPMENT
2.0 -    Anushka Bansal 11/02/17     Added comments 
********************************************************************************************************************/
@isTest
Public Class ACP_Actions_List_Ctrl_Test {

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
   ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3564');
  insert newAccPlan;

 }


 static testMethod void Tasklistctrl_TestMethod() {

  ACP_Account_Plan__c accplan = [select id from ACP_Account_Plan__c limit 1];
  Test.setCurrentPageReference(new PageReference('Page.ACP_Actions_List'));
  System.currentPageReference().getParameters().put('actionStatus', 'All');
  System.currentPageReference().getParameters().put('acpId', 'All');
  // List<ACP_Relationship__c> EnggRel = ACP_TestDataFactory.createSuppRelationship(15,'Engineering');
  System.currentPageReference().getParameters().put('acpId', accplan.id);
  System.currentPageReference().getParameters().put('category', 'Stakeholder%20and%20Relationship');
  Test.startTest();
  ACP_Actions_List_Ctrl ctrlObj = new ACP_Actions_List_Ctrl();
  List < Task > tskList = ctrlObj.Tasks;
  Integer totalCount = ctrlObj.getTotal_size();
  Integer pageNo = ctrlObj.getPageNumber();
  Integer totalPages = ctrlObj.getTotalPages();
  Boolean disable = ctrlObj.getDisablePrevious();
  disable = ctrlObj.getDisableNext();
  PageReference pageRef = ctrlObj.Previous();


  System.currentPageReference().getParameters().put('actionStatus', 'All');
  System.currentPageReference().getParameters().put('acpId', 'All');
  System.currentPageReference().getParameters().put('acpId', accplan.id);
  System.currentPageReference().getParameters().put('category', null);

  ACP_Actions_List_Ctrl ctrlObj1 = new ACP_Actions_List_Ctrl();
  List < Task > tskList1 = ctrlObj1.Tasks;
  Test.stopTest();

 }

 static testMethod void Tasklistctrl_TestMethod2() {
  ACP_Account_Plan__c accplan = [select id from ACP_Account_Plan__c limit 1];
  Test.setCurrentPageReference(new PageReference('Page.ACP_Actions_List'));
  System.currentPageReference().getParameters().put('actionStatus', '');
  System.currentPageReference().getParameters().put('acpId', 'All');
  System.currentPageReference().getParameters().put('acpId', accplan.id);
  System.currentPageReference().getParameters().put('category', null);
  Test.startTest();
  ACP_Actions_List_Ctrl ctrlObj = new ACP_Actions_List_Ctrl();
  List < Task > tskList = ctrlObj.Tasks;
  Integer totalCount = ctrlObj.getTotal_size();
  PageReference pageRef = ctrlObj.Next();
  pageRef = ctrlObj.Beginning();
  pageRef = ctrlObj.End();

  System.currentPageReference().getParameters().put('actionStatus', '');
  System.currentPageReference().getParameters().put('acpId', 'All');
  System.currentPageReference().getParameters().put('acpId', accplan.id);
  System.currentPageReference().getParameters().put('category', 'Stakeholder%20and%20Relationship');

  ACP_Actions_List_Ctrl ctrlObj1 = new ACP_Actions_List_Ctrl();
  List < Task > tskList1 = ctrlObj1.Tasks;
  Test.stopTest();
 }

}