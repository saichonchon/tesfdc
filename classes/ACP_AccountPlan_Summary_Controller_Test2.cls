/***************************************************************************************
Name:ACP_AccountPlan_Summary_Controller_Test2
Class:ACP_AccountPlan_Summary_Controller
Copyright © 2017 TE Connectivity
=========================================================================================
Requirement:
Test Class for ACP_AccountPlan_Summary_Controller
=========================================================================================
Purpose:
Used for Strategy and Metrics Tab.
=========================================================================================
History
-------
Version      Author              Date              Detail
1.0          Ritika Pahwa        06/05/17          Added Strategy Section
2.0          Anushka Bansal      06/05/17          Added Analytics Report Section
****************************************************************************************/
@isTest(seeAlldata = true)
Private Class ACP_AccountPlan_Summary_Controller_Test2 {
  Contact con = ACP_TestDataFactory.createContact();
  static ACP_Setting__c acpsetting = createACPSetting('');
  static ACP_Section_Detail__c Rec = createSectionSettings('Strategy Settings', '', 'Strategy', 'createdDate desc', 'ACP_Status_Fieldset', 'Strategy');
  static ACP_Section_Detail__c accHeader = createSectionSettings('Account Plan Header', '', 'Account Plan Header', 'createdDate desc', 'ACP_Account_Plan_Fieldset', 'Account Plan Header');

  public static ACP_Setting__c createACPSetting(String BusinessUnit) {

    system.debug('business unit ' + BusinessUnit);
    ACP_Setting__c acpSetting = new ACP_Setting__c();
    acpSetting.Business_Unit__c = BusinessUnit;
    acpSetting.ACP_Is_Active__c = true;
    try {
      insert acpSetting;
      system.debug('ACPSetting Record summary ctrl' + acpSetting);
      return acpSetting;
    }
    Catch(Exception e) {
      System.debug('Exception occured inside ACP_TestDataFactory:' + e.getMessage());
      return null;
    }
  }

  public static ACP_Section_Detail__c createSectionSettings(String name, String GIBU, String headerLabel, String sortOrder, String fieldSetNm, String recTypeName) {
    Id recordtypeid = Schema.SObjectType.ACP_Section_Detail__c.getRecordTypeInfosByName().get(recTypeName).getRecordTypeId();
    system.debug('recordtypeid ======>' + recordtypeid);
    system.debug('recTypeName======>' + recTypeName);

    
    ACP_Section_Detail__c sectionSetting = new ACP_Section_Detail__c();
    sectionSetting.Name = name;
    sectionSetting.ACP_Setting__r = acpSetting;
    sectionSetting.ACP_Header_Label__c = headerLabel;
    sectionSetting.Default_Sort_Order__c = sortOrder;
    sectionSetting.ACP_Field_Set_Name__c = fieldSetNm;
    sectionSetting.ACP_Header_BG_Color__c = 'orange';
    sectionSetting.ACP_Header_Font_Color__c = 'white';
    sectionSetting.ACP_Setting__c = acpSetting.id;
    sectionSetting.RecordTypeId = recordtypeid;

    if (recTypeName == 'Strategy') {

      sectionSetting.ACP_No_Of_Records__c = 5;
    }
    try {
      insert sectionSetting;
      system.debug('sectionSetting======>' + sectionSetting);
      return sectionSetting;
    }
    Catch(Exception e) {
      System.debug('Exception occured inside ACP_TestDataFactory:' + e.getMessage());
      return null;
    }
  }


  static testMethod void AnalyticsTestRecord() {
    Test.setCurrentPageReference(new PageReference('Page.ACP_AccountPlan_Summary_Page'));
    RecordType rt1 = ClsTestHelp.createTestRecordType8();
    Account acct = ClsTestHelp.createtestAccounts();
    acct.RecordTypeId = rt1.Id;

    insert acct;

    ACP_Account_Plan__c accplan = new ACP_Account_Plan__c(
      Name = 'TestAccountPlan4',
      ACP_Account_Name__c = acct.Id,
      Account_Plan_Type__c = 'Sold-to Account',
      ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3564');
    insert accplan;
    System.Test.startTest();
    List < report > reportsList = new List < report > ();
    reportsList = [Select id, name from report limit 6];
    List < ACP_Analytics__c > analyticsList = new List < ACP_Analytics__c > ();
    for (Integer i = 0; i < 1; i++) {
      ACP_Analytics__c analyticsRecord = new ACP_Analytics__c(
        ACP_Report_1_Id__c = reportsList[0].id,
        ACP_Report_2_Id__c = reportsList[1].id,
        ACP_Report_3_Id__c = reportsList[2].id,
        ACP_Report_4_Id__c = reportsList[3].id,
        ACP_Report_5_Id__c = reportsList[4].id,
        ACP_Report_6_Id__c = reportsList[5].id,
        ACP_Report_1__c = reportsList[0].name,
        ACP_Report_2__c = reportsList[1].name,
        ACP_Report_3__c = reportsList[2].name,
        ACP_Report_4__c = reportsList[3].name,
        ACP_Report_5__c = reportsList[4].name,
        ACP_Report_6__c = reportsList[5].name,
        ACP_Analytics_Page__c = '1',
        ACP_Business_Unit__c = 'Medical',
        ACP_Active__c = false
      );
      analyticsList.add(analyticsRecord);
    }

    insert analyticsList;

           
    Apexpages.currentPage().getParameters().put('acpid', accplan.id);
    System.Test.stopTest();
    ApexPages.StandardController sc = new ApexPages.StandardController(accplan);
    ACP_AccountPlan_Summary_Controller relObj = new ACP_AccountPlan_Summary_Controller();
    relobj.addIdsToList(analyticsList[0]);
 //   relobj.getAnalyticRecord(analyticsList[0].ACP_Analytics_Page__c);

  }

  static testMethod void AnalyticsTestRecord2() {
    Test.setCurrentPageReference(new PageReference('Page.ACP_AccountPlan_Summary_Page'));
    Account acct = ClsTestHelp.createtestAccounts();
    acct.WWCORPACCT__c = 'W0007';
    acct.GAMCD__c = 'G0007';
    acct.IND_KAM_Code__c = 'K0007';
    insert acct;
    ACP_Account_Plan__c accplan = new ACP_Account_Plan__c(
      Name = 'TestAccountPlan3564',
      ACP_Account_Name__c = acct.Id,
      Account_Plan_Type__c = 'Kam Account',
      ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3564');
    insert accplan;
    System.Test.startTest();     
    Apexpages.currentPage().getParameters().put('acpid', accplan.id);
    System.Test.stopTest();
    ApexPages.StandardController sc = new ApexPages.StandardController(accplan);
    ACP_AccountPlan_Summary_Controller relObj = new ACP_AccountPlan_Summary_Controller(sc);

  }

  static testMethod void AnalyticsTestRecord3() {
    Test.setCurrentPageReference(new PageReference('Page.ACP_AccountPlan_Summary_Page'));
    Account acct = ClsTestHelp.createtestAccounts();
    acct.WWCORPACCT__c = 'W0007';
    acct.GAMCD__c = 'G0007';
    acct.IND_KAM_Code__c = 'K0007';
    insert acct;
    ACP_Account_Plan__c accplan = new ACP_Account_Plan__c(
      Name = 'TestAccountPlan3564',
      ACP_Account_Name__c = acct.Id,
      Account_Plan_Type__c = 'WW Account',
      ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3564');
    insert accplan;
    System.Test.startTest();
    List < report > reportsList = new List < report > ();
    reportsList = [Select id, name from report limit 6];
    List < ACP_Analytics__c > analyticsList = new List < ACP_Analytics__c > ();
    for (Integer i = 0; i < 1; i++) {
      ACP_Analytics__c analyticsRecord = new ACP_Analytics__c(
        ACP_Report_1_Id__c = reportsList[0].id,
        ACP_Report_2_Id__c = reportsList[1].id,
        ACP_Report_3_Id__c = reportsList[2].id,
        ACP_Report_4_Id__c = reportsList[3].id,
        ACP_Report_5_Id__c = reportsList[4].id,
        ACP_Report_6_Id__c = reportsList[5].id,
        ACP_Report_1__c = reportsList[0].name,
        ACP_Report_2__c = reportsList[1].name,
        ACP_Report_3__c = reportsList[2].name,
        ACP_Report_4__c = reportsList[3].name,
        ACP_Report_5__c = reportsList[4].name,
        ACP_Report_6__c = reportsList[5].name,
        ACP_Analytics_Page__c = '2',
        ACP_Business_Unit__c = 'Medical',
        ACP_Active__c = true
      );
      analyticsList.add(analyticsRecord);
    }

    insert analyticsList;    
    Apexpages.currentPage().getParameters().put('acpid', accplan.id);
    System.Test.stopTest();
    ApexPages.StandardController sc = new ApexPages.StandardController(accplan);
    ACP_AccountPlan_Summary_Controller relObj = new ACP_AccountPlan_Summary_Controller(sc);


    relobj.addIdsToList(analyticsList[0]);
    //relobj.getAnalyticRecord(analyticsList[0].ACP_Analytics_Page__c);
  }

}