/***************************************************************************************
Name:ACP_RGUpdate_Page_ctrl_Test
Class:ACP_RGUpdate_Page_ctrl
Copyright © 2017 TE Connectivity
=========================================================================================
Requirement:
Test Class for ACP_RGUpdate_Page_ctrl 
=========================================================================================
Purpose:
Test class for growth table in performance analytic tab.
=========================================================================================
History
-------
Version      Author                Date              Detail
1.0          Ritika Pahwa          10/23/17          Added methods used for revenue growth functionality. 
****************************************************************************************/
@isTest
Private Class ACP_RGUpdate_Page_ctrl_Test {
  static ACP_Section_Detail__c businessPerformance = createSectionSettings('TE Business Performance Settings', '', 'TE Business Performance', 'ACP_Sales_Mode__c', 'ACP_Revenue_Growth_Fieldset', 'TE Business Performance');
  ACP_Setting__c acpsetting = createACPSetting('');
  String UserBU = acpsetting.Business_Unit__c;
  String AcpSectionDetail = 'ACP_Section_Detail__c';


  /************************Test Market and Competition details ***********************************/
  public static ACP_Setting__c createACPSetting(String BusinessUnit) {
    ACP_Setting__c acpSetting = new ACP_Setting__c();
    acpSetting.Business_Unit__c = BusinessUnit;
    acpSetting.ACP_Is_Active__c = true;
    try {
      insert acpSetting;
      system.debug('ACPSetting Record' + acpSetting);
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

    ACP_Setting__c acpSetting = createACPSetting(GIBU);
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
   /** if (recTypeName == 'Stakeholder and Relationship') {
      sectionSetting.ACP_No_Reds_Exe_Rel__c = 2;
      sectionSetting.ACP_Num_of_Rcds_Pur_Rel__c = 2;
      sectionSetting.ACP_Num_Rerds_Eng_Rel__c = 2;
    }
    if (recTypeName == 'Market and Competition') {
      sectionSetting.ACP_Show_TAM_LY_CY_NY__c = false;
      sectionSetting.ACP_No_Of_Records__c = 5;
    }
    if (recTypeName == 'Opportunity TAM Revenue') {
      sectionSetting.ACP_Pipeline_4Q_Rolling__c = '00O0S000000JQvH';
      sectionSetting.ACP_Conversion_current_YTD__c = '00O0S000000JQvH';
      sectionSetting.ACP_L12M_Lost_1Yvalue__c = '00O0S000000JQvH';
      sectionSetting.ACP_L12M_Won_1Y_Value__c = '00O0S000000JQvH';
      sectionSetting.ACP_No_Of_Records__c = 5;
    }
    if (recTypeName == 'Market and Competition Summary') {
      sectionSetting.ACP_No_Of_Records__c = 5;
      system.debug('Market&Comp Sum' + sectionSetting);
    }**/
    if (recTypeName == 'TE Business Performance') {
      sectionSetting.Revenue_and_Growth_Plan_Year_1__c = '2017';
      sectionSetting.Revenue_and_Growth_Plan_Year_2__c = '2018';
      sectionSetting.Revenue_and_Growth_Plan_Year_3__c = '2020';
      sectionSetting.Revenue_Type__c = 'Direct; POS; CMA';
    }

  /**  if (recTypeName == 'Top Open Opportunities') {
      sectionSetting.ACP_Application__c = 'Platform Name';
      sectionSetting.ACP_No_Of_Records__c = 5;
    }
    if (recTypeName == 'TE Supplier Evaluation') {
      sectionSetting.ACP_Field_Set_1__c = 'ACP_Suppl_Rating_Fieldset';
      sectionSetting.ACP_No_Of_Records__c = 5;
    }

    if (recTypeName == 'Strategy') {

      sectionSetting.ACP_No_Of_Records__c = 5;
    }

    if (recTypeName == 'Customer Overview') {

      sectionSetting.Customer_Overview_2nd_Row__c = true;
    }
**/
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

  /************************Test for save growth method ***********************************/
  static testMethod void RGT_TestMethod() {

    Test.startTest();
    Test.setCurrentPageReference(new PageReference('Page.ACP_RGEdit_Page_Poc'));
    ClsTestCustomSettingHelper.getTrigger_Configuration();
    ClsTestCustomSettingHelper.getProfitBUCenterMapping();
    ClsTestCustomSettingHelper.getApex_Helper_Settings();
    ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
    ClsTestCustomSettingHelper.getOpportunity_Approvers();
    ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
    ClsTestCustomSettingHelper.getADMTerritoryCode();
    Account acct = ClsTestHelp.createtestAccounts();

    insert acct;

    ACP_Account_Plan__c accPlan = new ACP_Account_Plan__c(
      Name = 'TestAccountPlan3564',
      ACP_Account_Name__c = acct.Id,
      ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3564');
    insert accPlan;

    ACP_Revenue_Growth_Perf__c acprev = new ACP_Revenue_Growth_Perf__c();
    acprev.ACP_Past_Year_1_Revenue__c = 58217;
    acprev.ACP_Past_year_Revenue__c = 58889;
    acprev.ACP_Current_Year_to_Date__c = 23705;
    acprev.ACP_EOL_Lost_Business__c = 26251;
    acprev.ACP_Transfer_In_Out__c = 123;
    acprev.ACP_LY_Market_Growth__c = 25;
    acprev.ACP_LY_Price_Erosion__c = 25;

    acprev.ACP_Account_Plan__c = accPlan.id;
    acprev.ACP_Sales_Mode__c = 'Direct';
    acprev.ACP_Refresh_Based_on__c = 'Billing';
    acprev.ACP_Project_1__c = 20;
    acprev.ACP_Project_2__c = 10;
    acprev.ACP_Project_3__c = 30;
    acprev.ACP_Project_4__c = 40;
    acprev.ACP_Project_5__c = 25;
    acprev.ACP_Show_this_on_chart__c = false;


    acprev.ACP_Current_Year_3_Plan__c = 25;
    acprev.ACP_Current_Year_5_Plan__c = 25;
    acprev.ACP_Fiscal_Year__c = '0.0';


    insert(acprev);
    system.debug('acprev ritika' + acprev);

    Apexpages.currentPage().getParameters().put('acpid', accplan.id);
    Apexpages.currentPage().getParameters().put('SelectType', 'Direct');
    Apexpages.currentPage().getParameters().put('SelectType1', 'Billing');
    ApexPages.StandardController scm = new ApexPages.StandardController(accplan);
    ACP_RGUpdate_Page_ctrl revGrow = new ACP_RGUpdate_Page_ctrl(scm);
    ACP_Section_Detail__c detrec = revGrow.detrec;
    List < ACP_Revenue_Growth_Perf__c > getrev = revGrow.getrev();
    List < SelectOption > getRecordTypes = revGrow.getRecordTypes();
    List < SelectOption > getRecordTypes1 = revGrow.getRecordTypes1();
    system.debug('revGrow ritika' + revGrow);
    revGrow.acpId = accPlan.id;
    revGrow.SelectType = 'Direct';
    revGrow.SelectType1 = 'Billing';

    revGrow.saveGrowth();

    Test.stopTest();
    System.assertEquals(accplan.id, revGrow.acpId);

  }
  /************************Test for go growth method ***********************************/
  static testMethod void RGT_TestMethod1() {

    Test.startTest();
    Test.setCurrentPageReference(new PageReference('Page.ACP_RGEdit_Page_Poc'));
    ClsTestCustomSettingHelper.getTrigger_Configuration();
    ClsTestCustomSettingHelper.getProfitBUCenterMapping();
    ClsTestCustomSettingHelper.getApex_Helper_Settings();
    ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
    ClsTestCustomSettingHelper.getOpportunity_Approvers();
    ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
    ClsTestCustomSettingHelper.getADMTerritoryCode();
    Account acct = ClsTestHelp.createtestAccounts();

    insert acct;

    ACP_Account_Plan__c accPlan = new ACP_Account_Plan__c(
      Name = 'TestAccountPlan3564',
      ACP_Account_Name__c = acct.Id,
      ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3564');
    insert accPlan;

    ACP_Revenue_Growth_Perf__c acprev = new ACP_Revenue_Growth_Perf__c();
    acprev.ACP_Past_Year_1_Revenue__c = 58217;
    acprev.ACP_Past_year_Revenue__c = 58889;
    acprev.ACP_Current_Year_to_Date__c = 23705;
    acprev.ACP_EOL_Lost_Business__c = 26251;
    acprev.ACP_Transfer_In_Out__c = 123;
    acprev.ACP_LY_Market_Growth__c = 25;
    acprev.ACP_LY_Price_Erosion__c = 25;

    acprev.ACP_Account_Plan__c = accPlan.id;
    acprev.ACP_Sales_Mode__c = 'Direct';
    acprev.ACP_Refresh_Based_on__c = 'Billing';
    acprev.ACP_Project_1__c = 20;
    acprev.ACP_Project_2__c = 10;
    acprev.ACP_Project_3__c = 30;
    acprev.ACP_Project_4__c = 40;
    acprev.ACP_Project_5__c = 25;


    acprev.ACP_Current_Year_3_Plan__c = 25;
    acprev.ACP_Current_Year_5_Plan__c = 25;
    acprev.ACP_Fiscal_Year__c = '0.0';


    insert(acprev);
    system.debug('acprev ritika' + acprev);

    Apexpages.currentPage().getParameters().put('acpid', accplan.id);
    Apexpages.currentPage().getParameters().put('SelectType', 'Direct');
    Apexpages.currentPage().getParameters().put('SelectType1', 'Billing');
    ApexPages.StandardController scm = new ApexPages.StandardController(accplan);
    ACP_RGUpdate_Page_ctrl revGrow = new ACP_RGUpdate_Page_ctrl(scm);
    revGrow.acpId = accPlan.id;
    revGrow.SelectType = 'Direct';
    revGrow.SelectType1 = 'Billing';
    revGrow.goGrowthRevenue();

    Test.stopTest();
    System.assertEquals(accplan.id, revGrow.acpId);

  }
  /************************Test for cancel growth method ***********************************/
  static testMethod void RGT_TestMethod2() {

    Test.startTest();
    Test.setCurrentPageReference(new PageReference('Page.ACP_RGEdit_Page_Poc'));
    ClsTestCustomSettingHelper.getTrigger_Configuration();
    ClsTestCustomSettingHelper.getProfitBUCenterMapping();
    ClsTestCustomSettingHelper.getApex_Helper_Settings();
    ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
    ClsTestCustomSettingHelper.getOpportunity_Approvers();
    ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
    ClsTestCustomSettingHelper.getADMTerritoryCode();
    Account acct = ClsTestHelp.createtestAccounts();

    insert acct;

    ACP_Account_Plan__c accPlan = new ACP_Account_Plan__c(
      Name = 'TestAccountPlan3564',
      ACP_Account_Name__c = acct.Id,
      ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3564');
    insert accPlan;

    ACP_Revenue_Growth_Perf__c acprev = new ACP_Revenue_Growth_Perf__c();
    acprev.ACP_Past_Year_1_Revenue__c = 58217;
    acprev.ACP_Past_year_Revenue__c = 58889;
    acprev.ACP_Current_Year_to_Date__c = 23705;
    acprev.ACP_EOL_Lost_Business__c = 26251;
    acprev.ACP_Transfer_In_Out__c = 123;
    acprev.ACP_LY_Market_Growth__c = 25;
    acprev.ACP_LY_Price_Erosion__c = 25;

    acprev.ACP_Account_Plan__c = accPlan.id;
    acprev.ACP_Sales_Mode__c = 'Direct';
    acprev.ACP_Refresh_Based_on__c = 'Billing';
    acprev.ACP_Project_1__c = 20;
    acprev.ACP_Project_2__c = 10;
    acprev.ACP_Project_3__c = 30;
    acprev.ACP_Project_4__c = 40;
    acprev.ACP_Project_5__c = 25;
    acprev.ACP_Labels_1__c= '1';
    acprev.ACP_Labels_2__c= '1';
    acprev.ACP_Labels_3__c= '1';
    acprev.ACP_Labels_4__c= '1';
    

    acprev.ACP_Current_Year_3_Plan__c = 25;
    acprev.ACP_Current_Year_5_Plan__c = 25;
    acprev.ACP_Fiscal_Year__c = '0.0';


    insert(acprev);

    system.debug('acprev ritika' + acprev);

    Apexpages.currentPage().getParameters().put('acpid', accplan.id);
    Apexpages.currentPage().getParameters().put('SelectType', 'Direct');
    Apexpages.currentPage().getParameters().put('SelectType1', 'Billing');
    ApexPages.StandardController scm = new ApexPages.StandardController(accplan);
    ACP_RGUpdate_Page_ctrl revGrow = new ACP_RGUpdate_Page_ctrl(scm);
    List < ACP_Revenue_Growth_Perf__c > getrev = revGrow.getrev();
    revGrow.acpId = accPlan.id;
    revGrow.SelectType = 'Direct';
    revGrow.SelectType1 = 'Billing';
    revGrow.cancelGrowth();


    Test.stopTest();
    System.assertEquals(accplan.id, revGrow.acpId);
    // system.assertEquals(1,revGrow.size());

  }
  /************************Test for covering else part ***********************************/
  static testMethod void RGT_TestMethod3() {

    Test.startTest();
    Test.setCurrentPageReference(new PageReference('Page.ACP_RGEdit_Page_Poc'));
    ClsTestCustomSettingHelper.getTrigger_Configuration();
    ClsTestCustomSettingHelper.getProfitBUCenterMapping();
    ClsTestCustomSettingHelper.getApex_Helper_Settings();
    ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
    ClsTestCustomSettingHelper.getOpportunity_Approvers();
    ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
    ClsTestCustomSettingHelper.getADMTerritoryCode();
    Account acct = ClsTestHelp.createtestAccounts();

    insert acct;

    ACP_Account_Plan__c accPlan = new ACP_Account_Plan__c(
      Name = 'TestAccountPlan3564',
      ACP_Account_Name__c = acct.Id,
      ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3564');
    insert accPlan;


    Apexpages.currentPage().getParameters().put('acpid', accplan.id);
    Apexpages.currentPage().getParameters().put('SelectType', 'Direct');
    Apexpages.currentPage().getParameters().put('SelectType1', 'Billing');
    ApexPages.StandardController scm = new ApexPages.StandardController(accplan);
    ACP_RGUpdate_Page_ctrl revGrow = new ACP_RGUpdate_Page_ctrl(scm);
    List < ACP_Revenue_Growth_Perf__c > getrev = revGrow.getrev();
    revGrow.acpId = accPlan.id;
    revGrow.SelectType = 'Direct';
    revGrow.SelectType1 = 'Billing';
    revGrow.saveGrowth();
   // revGrow.getrev();

    Test.stopTest();
    System.assertEquals(accplan.id, revGrow.acpId);


  }
}