/******************************************************************************************************************
Name: ACP_TaskUtil_Test
Copyright @ 2017 TE Connectivity
=============================================================================
Requirement:
Test class for ACP_TaskUtil
=============================================================================
Purpose:
Task utility class for Account Plan, being used by Task Trigger
=============================================================================
History
-------
VERSION   AUTHOR        DATE         DETAIL
1.0 -    Alka Kumari    05/29/17     INITIAL DEVELOPMENT
2.0 -    Anushka Bansal 11/02/17     Added comments 
********************************************************************************************************************/
@isTest
Public Class ACP_TaskUtil_Test {


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

 static testMethod void test_TaskUtil() {
  try {
  List<Contact> contactList = new List<Contact>();
   Contact acpCon1 = ACP_TestDataFactory.createContact();
   contactList.add(acpCon1);

   Contact acpCon2 = ACP_TestDataFactory.createContact();
   contactList.add(acpCon2);
   
   insert contactList;
   ACP_Account_Plan__c acPlan = [Select id from ACP_Account_Plan__c limit 1];

   List < Task > acpTaskList = ACP_TestDataFactory.createTask('Stakeholder and Relationship', acPlan.id, 1, 'In Progress');
   for (Task t: acpTaskList) {
    t.whoId = acpCon1.id;
   }
   insert acpTaskList;

   Task acpTask = acpTaskList[0];
   acpTask.whoId = acpCon2.id;
   acpTask.Description = 'New Task Updated';
   update acpTask;
  }
  Catch(Exception e) {
   System.debug('Exception occured:' + e.getMessage());
  }
 }
}