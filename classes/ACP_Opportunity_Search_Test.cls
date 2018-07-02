/******************************************************************************************************************
Name: ACP_Opportunity_Search_Test
Copyright @ 2017 TE Connectivity
=============================================================================
Requirement:
Test class for ACP_OpportunitySearchController
=============================================================================
Purpose:
Controller for Custom Opportunity Search page on ACP_Application_Breakdown__c 
and ACP_Top_Open_Opportunity__c objects
=============================================================================
History
-------
VERSION   AUTHOR        DATE         DETAIL
1.0 -    Anushka Bansal 06/22/17     INITIAL DEVELOPMENT
2.0 -    Anushka Bansal 11/02/17     Added comments 
********************************************************************************************************************/
@isTest
private class ACP_Opportunity_Search_Test {
 
 @testSetup static void setup() {
  User u = ClsTestHelp.createtestUsers();
  insert u;
  ClsTestCustomSettingHelper.getTrigger_Configuration();
  ClsTestCustomSettingHelper.getProfitBUCenterMapping();
  ClsTestCustomSettingHelper.getApex_Helper_Settings();
  ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
  ClsTestCustomSettingHelper.getOpportunity_Approvers();
  ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
  RecordType rt = Clstesthelp.createTestRecordType7();
  ClsTestCustomSettingHelper.getADMTerritoryCode();
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


 static testMethod void opportunitySearch_TestMethod() {
  Test.startTest();
  Test.setCurrentPageReference(new PageReference('Page.ACP_Opportunity_Search'));

  ACP_Account_Plan__c newAccPlan = [Select id from ACP_Account_Plan__c limit 1];
  newAccPlan.Account_Plan_Type__c = 'Gam Account';
  update newAccPlan;

  Apexpages.currentPage().getParameters().put('acpid', newAccPlan.id);
  ACP_OpportunitySearchController obj = new ACP_OpportunitySearchController();
  List < Opportunity > opportunity1 = obj.opportunities;
  obj.getFieldNames();
  obj.getOperator();
  obj.getOperatorCloseDate();
  obj.getFields();
  obj.getTextBox();
  obj.toggleSort();
  obj.getRecordTypeValues();
  obj.createSoqlQuery('name', '%', 'a');
  obj.createSoqlQuery('name', '=', 'a');
  obj.createSoqlQuery('name', '%%', 'a');
  obj.createSoqlQuery('name', '!=', 'a');
  obj.createSoqlQuery('closeDate', '=', '07/02/2017');
  obj.createSoqlQuery('Total_Opportunity_Value__c', '=', '34');

  obj.runSearch();
  Test.stopTest();
 }

 static testMethod void opportunitySearch_TestMethod2() {

  Test.startTest();
  Test.setCurrentPageReference(new PageReference('Page.ACP_Opportunity_Search'));

  ACP_Account_Plan__c newAccPlan = [Select id from ACP_Account_Plan__c limit 1];
  newAccPlan.Account_Plan_Type__c = 'Kam Account';
  update newAccPlan;

  Apexpages.currentPage().getParameters().put('acpid', newAccPlan.id);
  Apexpages.currentPage().getParameters().put('progOpp', 'yes');
  ACP_OpportunitySearchController obj = new ACP_OpportunitySearchController();
  List < Opportunity > opportunity1 = obj.opportunities;

  obj.getFieldNames();
  obj.getOperator();

  obj.getOperatorCloseDate();
  obj.getFields();
  obj.getTextBox();
  obj.getCurrentPhaseValues();
  obj.toggleSort();
  obj.createSoqlQuery('name', '%', 'a');
  obj.createSoqlQuery('closeDate', '=', '07/02/2017');
  obj.runSearch();
  obj.resetFIlters();
  Test.stopTest();

 }


 static testMethod void opportunitySearch_TestMethod3() {

  Test.startTest();
  Test.setCurrentPageReference(new PageReference('Page.ACP_Opportunity_Search'));

  ACP_Account_Plan__c newAccPlan = [Select id from ACP_Account_Plan__c limit 1];
  newAccPlan.Account_Plan_Type__c = 'WW Account';
  update newAccPlan;

  Apexpages.currentPage().getParameters().put('acpid', newAccPlan.id);
  Apexpages.currentPage().getParameters().put('progOpp', 'yes');
  ACP_OpportunitySearchController obj = new ACP_OpportunitySearchController();
  List < Opportunity > opportunity1 = obj.opportunities;
  Opportunity opp = obj.opp;
  obj.getFieldNames();
  obj.getOperator();
  obj.getOperatorCloseDate();
  obj.getFields();
  obj.getTextBox();
  obj.toggleSort();
  obj.createSoqlQuery('name', '%', 'a');
  obj.runSearch();
  Test.stopTest();

  Map < String, Schema.SObjectType > GlobalDescribeMap = Schema.getGlobalDescribe();
  Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get('ACP_Oppty_TAM_Report__c');
  Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
  Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get('ACP_ADM_Fieldset');
  system.debug('ACP_ADM_Fieldset ' + fieldSetObj.getFields());

  fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get('ACP_Appliances_FieldSet');
  system.debug('ACP_Appliances_FieldSet' + fieldSetObj.getFields());
 }
}