/***************************************************************************************
Name:ACP_AccountPlan_Summary_Controller_Test
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
@isTest
Private Class ACP_AccountPlan_Summary_Controller_Test {
  Contact con = ACP_TestDataFactory.createContact();
  static ACP_Setting__c acpsetting = createACPSetting('');
  static ACP_Section_Detail__c Rec = createSectionSettings('Strategy Settings', '', 'Strategy', 'createdDate desc', 'ACP_Status_Fieldset', 'Strategy');
  static ACP_Section_Detail__c accHeader = createSectionSettings('Account Plan Header', '', 'Account Plan Header', 'createdDate desc', 'ACP_Account_Plan_Fieldset', 'Account Plan Header');
  /*************************************Data For ACP setting*************************************************************/
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
      system.debug('full record  ------ ' + acpsetting.ACP_Section_Details__r);
      return sectionSetting;
    }
    Catch(Exception e) {
      System.debug('Exception occured inside ACP_TestDataFactory:' + e.getMessage());
      return null;
    }
  }

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

  }
  /***************************************************Test Methods for summary tab****************************************************/
  static testMethod void ACPSummaryControllerTestMethod() {

    Test.setCurrentPageReference(new PageReference('Page.ACP_AccountPlan_Summary_Page'));
    System.Test.startTest();

    ACP_Account_Plan__c accPlan = [select id from ACP_Account_Plan__c limit 1];

    List < ACP_Strategy__c > acpstgy = ACP_TestDataFactory.createStrategy(5);
    for (ACP_Strategy__c strategy: acpstgy) {
      strategy.ACP_Account_Plan__c = accplan.id;
    }
    insert acpstgy;
    system.debug('strategies inerted ' + acpstgy);


    ACP_account_Plan_attachment__c AccPlanAtt1 = new ACP_account_Plan_attachment__c();
    AccPlanAtt1.ACP_Account_Plan__c = accplan.id;
    AccPlanAtt1.ACP_Type__c = 'Product';
    insert AccPlanAtt1;
    Attachment attach = ACP_TestDataFactory.createAttachment();
    attach.parentId = AccPlanAtt1.Id;
    insert attach;
    ACP_account_Plan_attachment__c AccPlanAtt2 = new ACP_account_Plan_attachment__c();
    AccPlanAtt2.ACP_Account_Plan__c = accplan.id;
    AccPlanAtt2.ACP_Type__c = 'Account Manager';
    insert AccPlanAtt2;
    Attachment attach2 = ACP_TestDataFactory.createAttachment();
    attach2.parentId = AccPlanAtt2.Id;
    insert attach2;

    Apexpages.currentPage().getParameters().put('acpid', accplan.id);
    ApexPages.StandardController sc = new ApexPages.StandardController(accplan);
    system.debug('controler ' + sc);
    ACP_AccountPlan_Summary_Controller relObj = new ACP_AccountPlan_Summary_Controller(sc);
    pageReference pageRef1 = relobj.masterPageRedirection();
    relobj.addStrategy();
    relobj.editAccountPlan();
    relobj.redirectTabpage();
    relobj.cancelAddPage();
    relobj.pageRedirectWithDivId('strategy');
    relobj.getStrategy();
    relobj.getStrFields();
    relobj.getStrategiesList();
    relobj.getAcctPlanFields();

    List < Task > tskList1 = ACP_TestDataFactory.createTask('ADM Market & Competition', accplan.id, 2, 'In Progress');
    insert tskList1;
    relobj.taskList = tskList1;
    List < Task > relatedActivities = relobj.taskList;
    List < Task > tskList = ACP_TestDataFactory.createTask('Stakeholder and Relationship', accplan.id, 11, 'In Progress');
    insert tskList;
    relobj.taskList = tskList;
    relatedActivities = relobj.taskList;
    relobj.setCategoryWiseTask();

  }

  static testMethod void createStrategyMethod() {
    Test.setCurrentPageReference(new PageReference('Page.ACP_AccountPlan_Summary_Page'));
    System.Test.startTest();

    ACP_Account_Plan__c accPlan = [select id from ACP_Account_Plan__c limit 1];

    List < ACP_Strategy__c > acpstgy = ACP_TestDataFactory.createStrategy(5);
    for (ACP_Strategy__c strategy: acpstgy) {
      strategy.ACP_Account_Plan__c = accplan.id;
    }
    insert acpstgy;
    ACP_account_Plan_attachment__c AccPlanAtt1 = new ACP_account_Plan_attachment__c();
    AccPlanAtt1.ACP_Account_Plan__c = accplan.id;
    AccPlanAtt1.ACP_Type__c = 'Product';
    insert AccPlanAtt1;
    Attachment attach = ACP_TestDataFactory.createAttachment();
    attach.parentId = AccPlanAtt1.Id;
    insert attach;
    ACP_account_Plan_attachment__c AccPlanAtt2 = new ACP_account_Plan_attachment__c();
    AccPlanAtt2.ACP_Account_Plan__c = accplan.id;
    AccPlanAtt2.ACP_Type__c = 'Account Manager';
    insert AccPlanAtt2;
    Attachment attach2 = ACP_TestDataFactory.createAttachment();
    attach2.parentId = AccPlanAtt2.Id;
    insert attach2;

    system.debug('success' + accplan.id);
    Apexpages.currentPage().getParameters().put('acpid', accplan.id);
    Apexpages.currentPage().getParameters().put('tabpage', 'abc');
    System.Test.stopTest();

    ApexPages.StandardController sc = new ApexPages.StandardController(accplan);
    system.debug('controler ' + sc);
    ACP_AccountPlan_Summary_Controller relObj = new ACP_AccountPlan_Summary_Controller(sc);


    pageReference pageRef1 = relobj.masterPageRedirection();

    relobj.saveAndNewStrategy();


    relobj.redirectTabpage();
    relobj.cancelAddPage();
    relobj.pageRedirectWithDivId('strategy');
   
       /*ACP_AccountPlan_Summary_Controller.congaupdateattach('PDF',accplan.id);
        ACP_AccountPlan_Summary_Controller.congaupdateattach('PPT',accplan.id);*/
    relobj.viewTab();
    relobj.performanceTab();
    relobj.summaryTab();

  }
  /***********************************************************************************************************************/
}