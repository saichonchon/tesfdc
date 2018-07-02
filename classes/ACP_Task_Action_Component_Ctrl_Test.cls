/******************************************************************************************************************
Name: ACP_Task_Action_Component_Ctrl_Test
Copyright @ 2017 TE Connectivity
=============================================================================
Requirement:
Test class for ACP_Task_Action_Component_Ctrl
=============================================================================
Purpose:
Controller for component ACP_Task_Action_Component to show all the task filtered 
as per the parameter passed for Account Plan Id and Category while calling the component

=============================================================================
History
-------
VERSION   AUTHOR        DATE         DETAIL
1.0 -    Alka Kumari    05/02/17     INITIAL DEVELOPMENT
2.0 -    Anushka Bansal 11/02/17     Added comments 
********************************************************************************************************************/
@isTest
Public Class ACP_Task_Action_Component_Ctrl_Test {
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
  acct.WWCORPACCT__c = 'W0007';
  acct.GAMCD__c = 'G0007';
  acct.IND_KAM_Code__c = 'K0007';
  insert acct;

  ACP_Account_Plan__c newAccPlan = new ACP_Account_Plan__c(
   Name = 'TestAccountPlan3564',
   ACP_Account_Name__c = acct.Id,
   //Account_Plan_Type__c = 'Gam Account',        
   ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3564');
  insert newAccPlan;

 }

 static testMethod void TaskComp_TestMethod() {

  Test.startTest();
  ACP_Account_Plan__c accountPlanObj = [select id from ACP_Account_Plan__c limit 1];
  ACP_Actions_Row_Size__c cs = new ACP_Actions_Row_Size__c();
  cs.Name = 'actions_row_size';
  cs.ACP_Actions_Row_Size__c = 10;
  insert cs;
  ACP_Task_Action_Component_Ctrl ctrlObj = new ACP_Task_Action_Component_Ctrl();
  ctrlObj.accountPlanIdVar = accountPlanObj.id;
  ctrlObj.categoryVar = 'Stakeholder and Relationship';
  String status = ctrlObj.actStatus;
  ctrlObj.actStatus = 'In Progress';
  PageReference savePageRef1 = ctrlObj.addTask();
  List < SelectOption > options = ACP_Task_Action_Component_Ctrl.getStatusOptions();
  List < Task > tskList1 = new List < Task > ();
  tskList1 = ACP_TestDataFactory.createTask('Stakeholder and Relationship', accountPlanObj.id, 2, 'In Progress');
  insert tskList1;
  ctrlObj.commonTaskList = tskList1;
  ctrlObj.getTasksList(tskList1);
  ctrlObj.relatedActivitiesList = ctrlObj.getTasksList(tskList1);
  List < Task > relatedActivities = ctrlObj.relatedActivitiesList;
  ctrlObj.updatefilter();
  List < Task > tskList = new List < Task > ();
  ctrlObj.commonTaskList = tskList1;
  relatedActivities = ctrlObj.relatedActivitiesList;
  ctrlObj.actStatus = 'All';
  ctrlObj.commonTaskList = tskList1;
  relatedActivities = ctrlObj.relatedActivitiesList;
  ctrlObj.commonTaskList = tskList1;
  relatedActivities = ctrlObj.relatedActivitiesList;
  relatedActivities[0].subject = 'Test';
  PageReference savepageRef = ctrlObj.actionSave();
  ctrlObj.SelectedId = tskList1[0].id;
  ctrlObj.DeleteAction();
  System.assertEquals(([select id from Task where id = : ctrlObj.SelectedId]).size(), 0);
  Test.stopTest();

 }

 static testMethod void TaskComp1_TestMethod() {

  Test.startTest();
  ACP_Account_Plan__c accountPlanObj = [select id from ACP_Account_Plan__c limit 1];
  ACP_Actions_Row_Size__c cs = new ACP_Actions_Row_Size__c();
  cs.Name = 'actions_row_size';
  cs.ACP_Actions_Row_Size__c = 10;
  insert cs;
  ACP_Task_Action_Component_Ctrl ctrlObj = new ACP_Task_Action_Component_Ctrl();
  ctrlObj.accountPlanIdVar = accountPlanObj.id;
  ctrlObj.categoryVar = 'Stakeholder and Relationship';
  String status = ctrlObj.actStatus;
  ctrlObj.actStatus = 'In Progress';
  PageReference savePageRef1 = ctrlObj.addTask();
  List < SelectOption > options = ACP_Task_Action_Component_Ctrl.getStatusOptions();
  List < Task > tskList1 = new List < Task > ();
  tskList1 = ACP_TestDataFactory.createTask('Stakeholder and Relationship', accountPlanObj.id, 11, 'In Progress');
  insert tskList1;
  ctrlObj.commonTaskList = tskList1;
  ctrlObj.getTasksList(tskList1);
  ctrlObj.relatedActivitiesList = ctrlObj.getTasksList(tskList1);
  List < Task > relatedActivities = ctrlObj.relatedActivitiesList;
  ctrlObj.updatefilter();
  List < Task > tskList = new List < Task > ();
  ctrlObj.commonTaskList = tskList1;
  relatedActivities = ctrlObj.relatedActivitiesList;
  ctrlObj.actStatus = 'All';
  ctrlObj.commonTaskList = tskList1;
  relatedActivities = ctrlObj.relatedActivitiesList;
  ctrlObj.commonTaskList = tskList1;
  relatedActivities = ctrlObj.relatedActivitiesList;
  relatedActivities[0].subject = 'Test';
  PageReference savepageRef = ctrlObj.actionSave();
  ctrlObj.SelectedId = null;
  //ctrlObj.SelectedId = tskList[0].id; 
  ctrlObj.DeleteAction();
  System.assertEquals(([select id from Task where id = : ctrlObj.SelectedId]).size(), 0);

  Test.stopTest();

 }

}