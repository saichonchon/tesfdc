/******************************************************************************************************************
Name: ACP_MarketCompTrgHandler_Test
=======================================================================================================
Requirement: 
Test class for ACP_MarketCompTrgHandler
=======================================================================================================
Purpose:
Test class to Delete Opportunity TAM Revenue Record when Market Competition record deleted.
=======================================================================================================
History
-------
VERSION   AUTHOR   DATE       DETAIL
1.0 -     Esther   09/18/17   INITIAL DEVELOPMENT
********************************************************************************************************************/
@isTest
public class ACP_MarketCompTrgHandler_Test {
  static testMethod void testBeforeTrigger() {
  User u = ClsTestHelp.createTestUsers4PMV();
        u.Username = 'jinbo@sdfasdf.cssddgrw2sddde3';
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
    Opportunity oppy = ClsTestHelp.createTestOpportunity();
    oppy.Name = 'TestOppy2';
    insert oppy;

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

// Insert Custom Setting
    Trigger_Configuration__c tc = new Trigger_Configuration__c();
    tc.Name = 'MarketCompetitionDelete';
    tc.isRun__c = true;
    insert tc;

    //insert Market and Competition
    List < ACP_Market_and_Competition__c > Mark = ACP_TestDataFactory.createMarketCompetition(1, 'General Market and Competition');
    for (ACP_Market_and_Competition__c obj: mark) {
      obj.ACP_Account_Plan__c = newAccPlan.id;

    }
    insert mark;

    List < ACP_Opportunity_TAM_Revenue__c > OppTam = ACP_TestDataFactory.createOppTamRevenue(newAccPlan.id, 'CBC3 - 30049 - Tubing Materials');
    for (ACP_Opportunity_TAM_Revenue__c obj: OppTam) {
      obj.ACP_Market_Competition__c = mark[0].id;
    }
    insert OppTam;

    Delete mark;
}

  }
}