/******************************************************************************************************************
Name: ACP_TrgClassPlatformContent_Test
Copyright @ 2017 TE Connectivity
=============================================================================
Requirement:
Test class for ACP_TrgClassPlatformContent
=============================================================================
Purpose:
Handler class for trigger on Platform Content object
Updates the comments field on ACP_Application_Breakdown__c with the corresponding 
comments field of Platform_Content__c object.

=============================================================================
History
-------
VERSION   AUTHOR        DATE         DETAIL
1.0 -    Anushka Bansal 08/07/17     INITIAL DEVELOPMENT
2.0 -    Anushka Bansal 11/02/17     Added comments 
********************************************************************************************************************/
@isTest
public class ACP_TrgClassPlatformContent_Test {

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
   Account_Plan_Type__c = 'Gam Account',
   ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3564');
  insert newAccPlan;

  List < Opportunity > oppList = new List < Opportunity > ();
  for (Integer i = 0; i < 3; i++) {
   Opportunity oppy = ClsTestHelp.createTestOpportunity();
   oppy.Type = 'CM';
   oppy.RecordTypeId = rt.Id;
   oppy.Approval_Status_PMV__c = 'New';
   oppy.PMV_Type__c = 'IND Standard ENG opp';
   oppy.StageName = 'On Hold';
   oppy.OwnerId = u.Id;
   oppy.PMV_Migration_Setup__c = 'OnHold';
   oppy.Name = 'testjinte';
   oppy.AccountId = acct.id;
   oppList.add(oppy);
  }

  insert oppList;
  system.debug('opp inserted ' + oppList);

  Product_Hierarchy__c prodHier = new Product_Hierarchy__c(
   name = 'first',
   CBC1__c = '30004',
   CBC1_Description__c = 'Industrial',
   CBC2__c = '30008',
   CBC2_Description__c = 'IB products',
   CBC3__c = '30022',
   CBC3_Description__c = 'Switches'
  );
  insert prodHier;

    Trigger_Configuration__c tcp = new Trigger_Configuration__c();
         tcp.Name = 'PlatformContentUpdate';
         tcp.isRun__c = true;
         insert tcp;
         
  List < Platform_Content__c > pfcList = new List < Platform_Content__c > ();
  Platform_Content__c pfc;
  pfc = new Platform_Content__c(Program_Opportunity__c = oppList[0].id, CBC1__c = 'Industrial', Comments__c = 'abc');
  pfcList.add(pfc);
  pfc = new Platform_Content__c(Program_Opportunity__c = oppList[0].id, CBC1__c = 'Industrial', CBC2__c = 'IB products', CBC3__c = 'Switches', Comments__c = 'sample');
  pfcList.add(pfc);
  pfc = new Platform_Content__c(Program_Opportunity__c = oppList[0].id, CBC1__c = 'Industrial', CBC2__c = 'IB products', Comments__c = 'sample');
  pfcList.add(pfc);
  insert(pfcList);

 }

 private static testMethod void testUpdateComments() {
 
  ACP_Account_Plan__c newAccPlan = [select id from ACP_Account_Plan__c limit 1];
  List < Platform_Content__c > pfcList = [select id, Comments__c from Platform_Content__c];


  map < Id, Platform_Content__c > mapOldPC = new map < Id, Platform_Content__c > ();
  map < Id, Platform_Content__c > mapNewPC = new map < Id, Platform_Content__c > ();
  list < ACP_Application_Breakdown__c > listAppBreakdown = new list < ACP_Application_Breakdown__c > ();

  ACP_Application_Breakdown__c appbrk;
  appbrk = new ACP_Application_Breakdown__c(ACP_Account_Plan__c = newAccPlan.id, Platform_Content__c = pfcList[0].id);
  listAppBreakdown.add(appbrk);
  appbrk = new ACP_Application_Breakdown__c(ACP_Account_Plan__c = newAccPlan.id, Platform_Content__c = pfcList[1].id);
  listAppBreakdown.add(appbrk);
  appbrk = new ACP_Application_Breakdown__c(ACP_Account_Plan__c = newAccPlan.id, Platform_Content__c = pfcList[2].id);
  listAppBreakdown.add(appbrk);

  insert listAppBreakdown;

  mapOldPC.put(pfcList[0].id, pfcList[0]);
  mapOldPC.put(pfcList[1].id, pfcList[1]);
  mapOldPC.put(pfcList[2].id, pfcList[2]);
  pfcList[0].Comments__c = 'sample';
  pfcList[1].Comments__c = 'abcg';
  pfcList[2].Comments__c = 'qwerty';
  upsert(pfcList);
  mapNewPC.put(pfcList[0].id, pfcList[0]);
  mapNewPC.put(pfcList[1].id, pfcList[1]);
  mapNewPC.put(pfcList[2].id, pfcList[2]);

 }

}