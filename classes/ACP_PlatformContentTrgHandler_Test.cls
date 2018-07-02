/******************************************************************************************************************
Name: ACP_PlatformContentTrgHandler_Test
=======================================================================================================
Requirement: 
Test class for ACP_PlatformContentTrgHandler
=======================================================================================================
Purpose:
Test class to update the comments in Application Breakdown when Platform Content comments updated.
=======================================================================================================
History
-------
VERSION   AUTHOR   DATE       DETAIL
1.0 -     Anushka   09/18/17   INITIAL DEVELOPMENT
********************************************************************************************************************/
@isTest
public class ACP_PlatformContentTrgHandler_Test {
  @testSetup static void setup() {
    User u = ClsTestHelp.createtestUsers();
    insert u;
    system.runAs(u){
    ClsTestCustomSettingHelper.getApex_Helper_Settings();
    ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
    ClsTestCustomSettingHelper.getOpportunity_Approvers();
    ClsTestCustomSettingHelper.getTrigger_Configuration();
    ClsTestCustomSettingHelper.getProfitBUCenterMapping();
    ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
    ClsTestCustomSettingHelper.getADMTerritoryCode();
    Channelinsightdata_test.Channelinsightdata_test();
    Opportunity oppty = ClsTestHelp.createTestOpportunity();
    oppty.Name = 'TestOppy2';
    insert oppty;
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
}

  }

  static testMethod void testAfterTrigger() {
    Trigger_Configuration__c tc = new Trigger_Configuration__c();
    tc.Name = 'PlatformContentUpdate';
    tc.isRun__c = true;
    insert tc;

    Opportunity opp = [select id from opportunity limit 1];
    system.debug('opp is : ' + opp.id);
    List < Platform_Content__c > pfcList = new List < Platform_Content__c > ();
    Platform_Content__c pfc;
    pfc = new Platform_Content__c(Program_Opportunity__c = opp.id, CBC1__c = 'Industrial', Comments__c = 'abc');
    pfcList.add(pfc);
    pfc = new Platform_Content__c(Program_Opportunity__c = opp.id, CBC1__c = 'Industrial', CBC2__c = 'IB products', CBC3__c = 'Switches', Comments__c = 'sample');
    pfcList.add(pfc);
    pfc = new Platform_Content__c(Program_Opportunity__c = opp.id, CBC1__c = 'Industrial', CBC2__c = 'IB products', Comments__c = 'sample');
    pfcList.add(pfc);
    insert pfcList;

    pfcList[0].Comments__c = 'sample';
    pfcList[1].Comments__c = 'abcg';
    pfcList[2].Comments__c = 'qwerty';
    update pfcList;


  }
}