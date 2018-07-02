/***************************************************************************
Name: ACP_Platform_Content_Ctrl_Test
==============================================================
Requirement: 
Test Class for ACP_Platform_Content_Ctrl
==============================================================
Purpose:
Allow user to create and edit record in Platform Content.
==============================================================
History
-------
VERSION AUTHOR DATE     DETAIL
1.0 -   Esther 10/24/17 INITIAL DEVELOPMENT
****************************************************************************/
@isTest
private class ACP_Platform_Content_Ctrl_Test {


  @testSetup static void setup() {
    User u = ClsTestHelp.createtestUsers();
    insert u;
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
    system.debug('rttt' + rt);
    Account acct = ClsTestHelp.createtestAccounts();
    acct.WWCORPACCT__c = 'W0008';
    acct.GAMCD__c = 'G0008';
    acct.IND_KAM_Code__c = 'K0008';
    insert acct;

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
      name = 'first1',
      CBC1__c = '30004',
      CBC1_Description__c = 'Industrial',
      CBC2__c = '30008',
      CBC2_Description__c = 'IB products',
      CBC3__c = '30022',
      CBC3_Description__c = 'Switches'
    );
    insert prodHier;
  }

  static testMethod void PlatContent_TestMethod() {
    test.startTest();
    
    Trigger_Configuration__c tc = new Trigger_Configuration__c();
    tc.Name = 'PlatformContentUpdate';
    tc.isRun__c = true;
    insert tc;
    
    Opportunity opp = [select id from opportunity limit 1];

   
     List < Platform_Content__c > pfc = ACP_TestDataFactory.createPlatCont();
    for(Platform_Content__c obj : pfc)
    {
    obj.Program_Opportunity__c = opp.id;
    obj.CBC1__c ='Industrial';
    obj.CBC2__c ='IB products';
    obj.CBC3__c ='Switches';
    obj.ACP_Name__c ='CBC3 - 30022 - Switches';
    }
    insert pfc;
 
    
    Test.setCurrentPageReference(new PageReference('Page.ACP_Add_Platform_Content'));
    ApexPages.StandardController scmplat = new ApexPages.StandardController(pfc[0]);
    ACP_Platform_Content_Ctrl PlatCont = new ACP_Platform_Content_Ctrl();
    ACP_Platform_Content_Ctrl PlatCont1 = new ACP_Platform_Content_Ctrl(scmplat);

    Platform_Content__c plat = PlatCont.getPlatCont();
    Plat.Program_Opportunity__c = opp.id;

    PlatCont1.cbc1Value = '30004--Industrial';
    PlatCont1.cbc2Value = '30008--IB products';
    PlatCont1.cbc3Value = '30022--Switches';

    List < SelectOption > optionsCBC1 = PlatCont1.getCBC1;
    List < SelectOption > optionsCBC2 = PlatCont1.getCBC2;
    List < SelectOption > optionsCBC3 = PlatCont1.getCBC3;
    PlatCont1.getCBC1();
    PlatCont1.getCBC2();
    PlatCont1.getCBC3();

    PlatCont1.CBCValue();
    PlatCont.SavePlatCont();
    PlatCont.saveCommonPlat();
    PlatCont.saveAndNew();
    PlatCont1.CancelPlatCont();
    PlatCont1.CancelPlatContEdit();

    test.stopTest();
  }

 
}