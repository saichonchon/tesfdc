/***************************************************************************************
Name:ACP_Performance_Analytics_ctrl_Test
Class:ACP_Performance_Analytics_ctrl
Copyright © 2017 TE Connectivity
=========================================================================================
Requirement:
Test Class for Performance and analytic tab.
=========================================================================================
Purpose:
Used for performance analytics functionality.
=========================================================================================
History
-------
Version      Author                     Date              Detail
1.0          Esther Ethelbert           04/25/17          Covering methods of class
2.0          Ritika Pahwa               04/25/17          Covering methods of class
3.0          Anushka Bansal             04/25/17          Covering methods of class
4.0          Alka Kumari                04/25/17          Covering methods of class
****************************************************************************************/
@isTest
private class ACP_Performance_Analytics_ctrl_Test {
  static ACP_Setting__c acpsetting = createACPSetting('');
  static ACP_Section_Detail__c openOppRec = createSectionSettings('Top Open Opportunities Settings', '', 'Top Open Opportunities', 'createdDate desc', 'ACP_Top_Open_Opportunity_Fieldset', 'Top Open Opportunities');
  static ACP_Section_Detail__c appBreakdownRec = createSectionSettings('Application Breakdown Settings', '', 'Application Breakdown', 'createdDate desc', 'ACP_TAM_CY_LY_NY_Field_Set', 'Application Breakdown');
  static ACP_Section_Detail__c businessPerformance = createSectionSettings('TE Business Performance Settings', '', 'TE Business Performance', 'ACP_Sales_Mode__c', 'ACP_Revenue_Growth_Fieldset', 'TE Business Performance');
  static ACP_Section_Detail__c marketSUmmary = createSectionSettings('Market and Competition Summary Settings', '', 'Market and Competition Summary', 'createdDate desc', 'ACP_ADM_Fieldset', 'Market and Competition Summary');
  static ACP_Section_Detail__c acpsection = createSectionSettings('Account Plan Header Settings', '', 'Account Plan Header', 'createdDate desc', 'ACP_Account_Plan_Fieldset', 'Account Plan Header');
  static ACP_Section_Detail__c markcomprec = createSectionSettings('Market and Competition Settings', '', 'Market and Competition', 'createdDate desc', 'ACP_Market_Competition_Fieldset', 'Market and Competition');
  static ACP_Section_Detail__c oppTamRevrec = createSectionSettings('Opportunity TAM Revenue Settings', '', 'Opportunity TAM Revenue', 'createdDate desc', 'ACP_Opp_TAM_Revenue_Fieldset', 'Opportunity TAM Revenue');

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
    if (recTypeName == 'Stakeholder and Relationship') {
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
    }
    if (recTypeName == 'TE Business Performance') {
      sectionSetting.Revenue_and_Growth_Plan_Year_1__c = '2017';
      sectionSetting.Revenue_and_Growth_Plan_Year_1__c = '2018';
      sectionSetting.Revenue_and_Growth_Plan_Year_1__c = '2020';
      sectionSetting.Revenue_Type__c = 'Direct; POS; CMA';
    }

    if (recTypeName == 'Top Open Opportunities') {
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
      oppList.add(oppy);
    }

    insert oppList;
  }
  /************************************Test for application breakdown*******************************************************/
  static testMethod void createApplicationBreakdown1() {
    test.startTest();
    Account acc = [select id from account limit 1];

    ACP_Account_Plan__c accplan = ACP_TestDataFactory.createAccountPlan();
    accPlan.ACP_Account_Name__c = acc.id;
    insert accPlan;

    Opportunity oppy = [select id from opportunity limit 1];
    system.debug('opp found ' + oppy.id);
    
Trigger_Configuration__c tc = new Trigger_Configuration__c();
    tc.Name = 'PlatformContentUpdate';
    tc.isRun__c = true;
    insert tc;


    Product_Hierarchy__c newProduct = ACP_TestDataFactory.createProduct();

    Platform_Content__c pfc;
    pfc = new Platform_Content__c(Program_Opportunity__c = oppy.id, CBC1__c = 'Appliances', Comments__c = 'abc');
    insert pfc;

    List < ACP_Application_Breakdown__c > appList = new List < ACP_Application_Breakdown__c > ();
    for (Integer n = 0; n < 3; n++) {
      ACP_Application_Breakdown__c appbrk = new ACP_Application_Breakdown__c(

        ACP_Account_Plan__c = accPlan.id,
        ACP_Opportunity_Name__c = oppy.id,
        Platform_Content__c = pfc.id
      );
      appList.add(appbrk);
    }
    insert appList;
    system.debug('inserted app brk list' + appList);
    Test.setCurrentPageReference(new PageReference('Page.ACP_Performance_Analytics_Page'));
    Apexpages.currentPage().getParameters().put('acpid', accPlan.id);
    ApexPages.StandardController scmappl = new ApexPages.StandardController(accplan);
    ACP_Performance_Analytics_ctrl ApplBreak = new ACP_Performance_Analytics_ctrl(scmappl);
    ApplBreak.newAppBreakdown.ACP_Opportunity_Name__c = appList[0].ACP_Opportunity_Name__c;
    ApplBreak.getAppBrkdownList();
    PageReference savePage = ApplBreak.saveAppBreakdown();
    Opportunity opp1 = oppy;
    Opportunity opp2 = oppy;
    Opportunity opp3 = oppy;
    ACP_Application_Breakdown__c Appl = ApplBreak.getNewAppBreakdown();
    ApplBreak.getPlatform();
    test.stopTest();
  }

  static testMethod void createApplicationBreakdown2() {
    test.startTest();
    Account acc = [select id from account limit 1];
    system.debug('account found ' + acc.id);

    ACP_Account_Plan__c accplan = ACP_TestDataFactory.createAccountPlan();
    accPlan.ACP_Account_Name__c = acc.id;
    insert accPlan;

    List < opportunity > oppList = [select id from opportunity limit 2];
    system.debug('opp found ' + oppList);

Trigger_Configuration__c tc = new Trigger_Configuration__c();
    tc.Name = 'PlatformContentUpdate';
    tc.isRun__c = true;
    insert tc;


    Product_Hierarchy__c newProduct = ACP_TestDataFactory.createProduct();

    List < Platform_Content__c > pfcList = new List < Platform_Content__c > ();
    for (Integer i = 0; i < 2; i++) {
      Platform_Content__c pfc = new Platform_Content__c(Program_Opportunity__c = oppList[i].id, CBC1__c = 'Appliances', Comments__c = 'abc');
      pfcList.add(pfc);
    }
    insert pfcList;


    List < ACP_Application_Breakdown__c > appList = new List < ACP_Application_Breakdown__c > ();
    for (Integer n = 0; n < 2; n++) {
      ACP_Application_Breakdown__c appbrk = new ACP_Application_Breakdown__c(
        ACP_Account_Plan__c = accPlan.id,
        ACP_Opportunity_Name__c = oppList[n].id,
        Platform_Content__c = pfcList[n].id
      );

      appList.add(appbrk);
    }

    insert appList;
    system.debug('inserted app brk list' + appList);
    Test.setCurrentPageReference(new PageReference('Page.ACP_Performance_Analytics_Page'));
    Apexpages.currentPage().getParameters().put('acpid', accPlan.id);
    ApexPages.StandardController scmappl = new ApexPages.StandardController(accplan);
    ACP_Performance_Analytics_ctrl ApplBreak = new ACP_Performance_Analytics_ctrl(scmappl);
    ApplBreak.newAppBreakdown.ACP_Opportunity_Name__c = appList[0].ACP_Opportunity_Name__c;
    ApplBreak.getAppBrkdownList();
    PageReference savePage = ApplBreak.saveAppBreakdown();
    Opportunity opp1 = oppList[0];
    Opportunity opp2 = oppList[1];
    Opportunity opp3 = oppList[1];
    ACP_Application_Breakdown__c Appl = ApplBreak.getNewAppBreakdown();
    ApplBreak.getPlatform();
    test.stopTest();
  }

  static testMethod void createApplicationBreakdown3() {
    test.startTest();
    Account acc = [select id from account limit 1];
    system.debug('account found ' + acc.id);

    ACP_Account_Plan__c accplan = ACP_TestDataFactory.createAccountPlan();
    accPlan.ACP_Account_Name__c = acc.id;
    insert accPlan;

    List < opportunity > oppList = [select id from opportunity limit 3];
    system.debug('opp found ' + oppList);

Trigger_Configuration__c tc = new Trigger_Configuration__c();
    tc.Name = 'PlatformContentUpdate';
    tc.isRun__c = true;
    insert tc;


    Product_Hierarchy__c newProduct = ACP_TestDataFactory.createProduct();

    List < Platform_Content__c > pfcList = new List < Platform_Content__c > ();
    for (Integer i = 0; i < 3; i++) {
      Platform_Content__c pfc = new Platform_Content__c(Program_Opportunity__c = oppList[i].id, CBC1__c = 'Appliances', Comments__c = 'abc');
      pfcList.add(pfc);
    }
    insert pfcList;


    List < ACP_Application_Breakdown__c > appList = new List < ACP_Application_Breakdown__c > ();
    for (Integer n = 0; n < 3; n++) {
      ACP_Application_Breakdown__c appbrk = new ACP_Application_Breakdown__c(
        ACP_Account_Plan__c = accPlan.id,
        ACP_Opportunity_Name__c = oppList[n].id,
        Platform_Content__c = pfcList[n].id
      );

      appList.add(appbrk);
    }

    insert appList;
    system.debug('inserted app brk list' + appList);
    Test.setCurrentPageReference(new PageReference('Page.ACP_Performance_Analytics_Page'));
    Apexpages.currentPage().getParameters().put('acpid', accPlan.id);
    ApexPages.StandardController scmappl = new ApexPages.StandardController(accplan);
    ACP_Performance_Analytics_ctrl ApplBreak = new ACP_Performance_Analytics_ctrl(scmappl);
    ApplBreak.newAppBreakdown.ACP_Opportunity_Name__c = appList[0].ACP_Opportunity_Name__c;
    ApplBreak.getAppBrkdownList();
    PageReference savePage = ApplBreak.saveAppBreakdown();
    Opportunity opp1 = oppList[0];
    Opportunity opp2 = oppList[1];
    Opportunity opp3 = oppList[2];
    ACP_Application_Breakdown__c Appl = ApplBreak.getNewAppBreakdown();
    ApplBreak.getPlatform();
    test.stopTest();
  }
  /************************************Test for top open opportunity*********************************************************************/
  static testmethod void createTopOpenOpps() {
    Account acc = [select id from account limit 1];
    system.debug('account found ' + acc.id);

    ACP_Account_Plan__c accplan = ACP_TestDataFactory.createAccountPlan();
    accPlan.ACP_Account_Name__c = acc.id;
    insert accPlan;
    List < opportunity > oppList = [select id from opportunity limit 3];

    List < ACP_Top_Open_Opportunity__c > topOpportunities = new List < ACP_Top_Open_Opportunity__c > ();
    for (Integer i = 0; i < 3; i++) {
      ACP_Top_Open_Opportunity__c topOpportunity = new ACP_Top_Open_Opportunity__c(
        ACP_Account_Plan__c = accPlan.Id,
        ACP_Current_Status_Comment__c = 'test data',
        ACP_Opportunity_Name__c = oppList[i].id
      );
      topOpportunities.add(topOpportunity);
    }
    insert topOpportunities;
    Test.setCurrentPageReference(new PageReference('Page.ACP_Performance_Analytics_Page'));
    Test.startTest();
    Apexpages.currentPage().getParameters().put('acpid', accplan.id);
    ApexPages.StandardController sc = new ApexPages.StandardController(accplan);
    ACP_Performance_Analytics_ctrl ctrlObj1 = new ACP_Performance_Analytics_ctrl(sc);
    ACP_Top_Open_Opportunity__c getNewTopOpenOpp = ctrlObj1.getNewTopOpenOpp();
    ctrlObj1.saveTopOpenOpp();
    ACP_Performance_Analytics_ctrl ctrlObj2 = new ACP_Performance_Analytics_ctrl(sc);
    ctrlObj2.saveNewTopOpenOpp();
    ctrlObj2.getRevenueGrowthTotal();
    Test.stopTest();
  }
  /**************************Test for page references methods**************************************************************/
  static testmethod void pageReferences() {
    Account acc = [select id from account limit 1];
    system.debug('account found ' + acc.id);

    ACP_Account_Plan__c accplan = ACP_TestDataFactory.createAccountPlan();
    accPlan.ACP_Account_Name__c = acc.id;
    insert accPlan;

    Test.setCurrentPageReference(new PageReference('Page.ACP_Performance_Analytics_Page'));
    Test.startTest();
    Apexpages.currentPage().getParameters().put('acpid', accplan.id);
    ApexPages.StandardController sc = new ApexPages.StandardController(accPlan);
    ACP_Performance_Analytics_ctrl ctrlObj1 = new ACP_Performance_Analytics_ctrl();
    ctrlObj1.pageRedirect();

    ctrlObj1.masterPageRedirection();
    ctrlObj1.viewTab();
    ctrlObj1.performanceTab();
    ctrlObj1.cancelAddPage();
    ctrlObj1.editRevenueDetails();
    ctrlObj1.saveSummary();
    ctrlObj1.cancelSummary();
    ctrlObj1.addMarketComp();
    ctrlObj1.Tabpagetoset = 'abc';
    ctrlObj1.redirectTabpage();    
      /* Ghanshyam Choudhari conga test class start*/
       /*ACP_Performance_Analytics_ctrl.congaupdateattach('PDF',accplan.id);
        ACP_Performance_Analytics_ctrl.congaupdateattach('PPT',accplan.id);
       ACP_Performance_Analytics_ctrl.congaupdateattach('Revenue Bridge',accplan.id);*/
      
     ACP_congaHandlerUtilCtrl testAccPlan = new ACP_congaHandlerUtilCtrl(sc);
      try{
           ACP_congaHandlerUtilCtrl.congaupdateattachh('PDF',accplan.id);
    ACP_congaHandlerUtilCtrl.congaupdateattachh('PPT',accplan.id);
    ACP_congaHandlerUtilCtrl.congaupdateattachh('Revenue Bridge',accplan.id);
      ACP_congaHandlerUtilCtrl.congaupdateattachh('Bridge',accplan.id);
       ACP_congaHandlerUtilCtrl.congaupdateattachh('Bridge','123');
      }
       catch(DMLException e) {
            system.assertEquals(e.getMessage(), e.getMessage());
        }
      /* Ghanshyam Choudhari conga test class END*/
    ctrlObj1.summaryTab();
    // ctrlObj1.saveADMMarkComp();
    //  ctrlObj1.saveAndNewADM();
  //  ctrlObj1.saveCBCProd();
    List < Task > tskList6 = ACP_TestDataFactory.createTask('Stakeholder and Relationship', accPlan.id, 1, 'In Progress');
    for (Task obj: tskList6)
      obj.whatid = accPlan.id;
    insert tskList6;
    ctrlObj1.taskList = tskList6;
    system.debug('task listtt --' + tskList6);
    List < Task > tskList = ACP_TestDataFactory.createTask('Application Breakdown', accPlan.id, 1, 'In Progress');
    for (Task obj: tskList)
      obj.whatid = accPlan.id;
    insert tskList;
  }
  /************************************Test For Revenue Growth***************************************************************/
  static testMethod void RGTreeBarChart_TestMethod() {

    Account acc = [select id from account limit 1];
    system.debug('account found ' + acc.id);

    ACP_Account_Plan__c accplan = ACP_TestDataFactory.createAccountPlan();
    accPlan.ACP_Account_Name__c = acc.id;
    insert accPlan;

    Test.startTest();
    Test.setCurrentPageReference(new PageReference('Page.ACP_Performance_Analytics_Page'));

    List < ACP_Revenue_Growth_Perf__c > rgListUpdate = new List < ACP_Revenue_Growth_Perf__c > ();
    ACP_Revenue_Growth_Perf__c revenueGrowth = ACP_TestDataFactory.createACPRevenueGrowthPerfBilling();
    revenueGrowth.ACP_Account_Plan__c = accPlan.id;
    insert revenueGrowth;

    ACP_Revenue_Growth_Perf__c revenueGrowthBooking = ACP_TestDataFactory.createACPRevenueGrowthPerfBooking();
    revenueGrowthBooking.ACP_Account_Plan__c = accPlan.id;
    insert revenueGrowthBooking;


    Apexpages.currentPage().getParameters().put('acpid', revenueGrowth.ACP_Account_Plan__c);
    ApexPages.StandardController sctrl = new ApexPages.StandardController(accplan);
    ACP_Performance_Analytics_ctrl barChart = new ACP_Performance_Analytics_ctrl(sctrl);

    barChart.editRevenueDetails();

    revenueGrowth.ACP_Show_this_on_chart__c = true;
    rgListUpdate.add(revenueGrowth);
    update rgListUpdate;
    System.AssertEquals(revenueGrowth.ACP_Show_this_on_chart__c, true);

    ACP_Performance_Analytics_ctrl barChart1 = new ACP_Performance_Analytics_ctrl(sctrl);

    ACP_Performance_Analytics_ctrl.getFilterOptions();
    barChart1.updatefilter();
    Test.stopTest();
    System.assertEquals(revenueGrowth.ACP_Account_Plan__c, barChart.acpId);
  }

  /**********************************Test For Market Competition*********************************************************************************/
  static testMethod void Mark_TestMethod() {

    Test.startTest();
    Account gamAccount = [select id from account limit 1];

    ACP_Account_Plan__c accplan = ACP_TestDataFactory.createAccountPlan();
    accPlan.ACP_Account_Name__c = gamAccount.id;
    insert accPlan;


    List < BBB_Month_Bill_Book_Cust_PN__c > mbb = ACP_TestDataFactory.createMonthBB(1);
    for (BBB_Month_Bill_Book_Cust_PN__c obj: mbb) {
      obj.Customer__c = gamAccount.Id;
    }
    insert mbb;

 Trigger_Configuration__c tc = new Trigger_Configuration__c();
    tc.Name = 'MarketCompetitionDelete';
    tc.isRun__c = true;
    insert tc;
    
    List < ACP_Market_and_Competition__c > Mark = ACP_TestDataFactory.createMarketCompetition(1, 'General Market and Competition');
    for (ACP_Market_and_Competition__c obj: mark) {
      obj.ACP_Account_Plan__c = accPlan.id;

    }
    insert mark;

    Apexpages.currentPage().getParameters().put('acpid', accplan.id);
    ApexPages.StandardController scm = new ApexPages.StandardController(accplan);
    ACP_Performance_Analytics_ctrl MarkComp1 = new ACP_Performance_Analytics_ctrl(scm);
    String acpCBC = MarkComp1.acpCBC;
     List < ACP_Market_and_Competition__c > admData = MarkComp1.admData;

    ACP_Market_and_Competition__c Market = MarkComp1.getMarkComp();

    ACP_Section_Detail__c sectionDet = MarkComp1.markrec;

    MarkComp1.cbc1Value = '30007--Appliances';
    MarkComp1.cbc2Value = '30017--TUBING';
    MarkComp1.cbc3Value = '30049--Tubing Materials';
    system.debug('MarkComp1.cbc1Value' + MarkComp1.cbc1Value);

    List < SelectOption > optionsCBC1 = MarkComp1.getCBC1;
    List < SelectOption > optionsCBC2 = MarkComp1.getCBC2;
    List < SelectOption > optionsCBC3 = MarkComp1.getCBC3;
    MarkComp1.getCBC1();
    MarkComp1.getCBC2();
    MarkComp1.getCBC3();


    MarkComp1.inlineedit();
    MarkComp1.editAccountPlan();
    MarkComp1.getMarkFields();
   // MarkComp1.updatecongaattRevenue();



    MarkComp1.addMarketComp();
    MarkComp1.saveCommonADM();


    ACP_Performance_Analytics_ctrl MarkComp5 = new ACP_Performance_Analytics_ctrl(scm);

    MarkComp5.cbc1Value = '';
    MarkComp5.cbc2Value = '';
    MarkComp5.cbc3Value = '';


    ACP_Performance_Analytics_ctrl MarkComp2 = new ACP_Performance_Analytics_ctrl(scm);

    MarkComp2.cbc1Value = '30007--Appliances';
    MarkComp2.cbc2Value = '30017--TUBING';
    MarkComp2.cbc3Value = '30049--Tubing Materials';


    ACP_Performance_Analytics_ctrl MarkComp3 = new ACP_Performance_Analytics_ctrl(scm);

    MarkComp3.cbc1Value = '30007--Appliances';
    MarkComp3.cbc2Value = '30017--TUBING';
    MarkComp3.cbc3Value = '30049--Tubing Materials';
    //  MarkComp3.saveAndNewMark();

    ACP_Performance_Analytics_ctrl MarkComp4 = new ACP_Performance_Analytics_ctrl(scm);
    system.debug('ritikas market' + MarkComp2);
    try {
      MarkComp1.DeleteMark();
    } catch (Exception e) {
      system.assertEquals(e.getMessage(), e.getMessage());
    }

    Test.stopTest();

  }
  /***************************************Test for market***********************************************************************/
  static testMethod void Mark_TestMethod1() {

    Test.startTest();
    Account gamAccount = [select id from account limit 1];

    ACP_Account_Plan__c accplan = ACP_TestDataFactory.createAccountPlan();
    accPlan.ACP_Account_Name__c = gamAccount.id;
    insert accPlan;

    Test.setCurrentPageReference(new PageReference('Page.ACP_Edit_Mkt_Product_CBC'));

    Product_Hierarchy__c prod = ACP_TestDataFactory.createProduct();
    RecordType rcdType = [Select Id, name from RecordType where Name = 'General Market and Competition'];
    Id recordId = rcdType.Id;

 Trigger_Configuration__c tc = new Trigger_Configuration__c();
    tc.Name = 'MarketCompetitionDelete';
    tc.isRun__c = true;
    insert tc;
    
    List < ACP_Market_and_Competition__c > Mark = new List < ACP_Market_and_Competition__c > ();


    ACP_Market_and_Competition__c MarketCompetition = new ACP_Market_and_Competition__c();

    MarketCompetition.RecordTypeId = recordId;
    MarketCompetition.ACP_Account_Plan__c = accPlan.id;

    MarketCompetition.ACP_Main_Competitor_Share__c = 14;
    MarketCompetition.ACP_Market_Share__c = 12;
    MarketCompetition.ACP_NY_Fcst__c = 20;
    MarketCompetition.ACP_PAM__c = 200;
    MarketCompetition.ACP_Product_CBC__c = prod.id;
    MarketCompetition.ACP_SAM__c = 200;
    MarketCompetition.ACP_TAM__c = 200;

    MarketCompetition.ACP_TE_Position__c = 'Flat';
    MarketCompetition.ACP_CBC__c = 'CBC1 - 30049 - Tubing Materials'; //modified by Haripriya
    MarketCompetition.ACP_TAM_LY_Bill__c = 20.00;
    MarketCompetition.ACP_TAM_CYRR__c = 20.00;
    MarketCompetition.ACP_TAM_NY_Fcst__c = 20.00;


    insert MarketCompetition;

    Apexpages.currentPage().getParameters().put('acpid', accplan.id);
    Apexpages.currentPage().getParameters().put('macid', MarketCompetition.id);
    ApexPages.StandardController scm = new ApexPages.StandardController(accplan);
    ACP_Performance_Analytics_ctrl objAc1 = new ACP_Performance_Analytics_ctrl(scm);
    ACP_Performance_Analytics_ctrl dc = new ACP_Performance_Analytics_ctrl();

    ACP_Section_Detail__c sectionDet = objAc1.markrec;
    objAc1.cbc1Value = '30007--Appliances';
    objAc1.cbc2Value = '30017--TUBING';
    objAc1.cbc3Value = '30049--Tubing Materials';


    objAc1.getCBC2();
    objAc1.getCBC3();
    objAc1.DeleteMark();


    Test.stopTest();



  }

  /******************************************Test For Market***************************************************************************/
  static testMethod void MarkSum_TestMethod() {

    Test.startTest();
    Account gamAccount = [select id from account limit 1];

    ACP_Account_Plan__c accplan = ACP_TestDataFactory.createAccountPlan();
    accPlan.ACP_Account_Name__c = gamAccount.id;
    insert accPlan;
    
 Trigger_Configuration__c tc = new Trigger_Configuration__c();
    tc.Name = 'MarketCompetitionDelete';
    tc.isRun__c = true;
    insert tc;

    List < ACP_Market_and_Competition__c > MarkSum = ACP_TestDataFactory.createMarketCompetition(1, 'ADM Market and Competition');
    for (ACP_Market_and_Competition__c obj: marksum) {
      obj.ACP_Account_Plan__c = accPlan.id;

    }
    insert marksum;

    Apexpages.currentPage().getParameters().put('acpid', accplan.id);
    ApexPages.StandardController scm = new ApexPages.StandardController(accplan);
    ACP_Performance_Analytics_ctrl MarkCompSum = new ACP_Performance_Analytics_ctrl(scm);

    ACP_Market_and_Competition__c Market = MarkCompSum.getadmMarkComp();

    ACP_Section_Detail__c sectionDet = MarkCompSum.admmarkrec;

    MarkCompSum.getADMFields();

    ACP_Performance_Analytics_ctrl MarkCompSum2 = new ACP_Performance_Analytics_ctrl(scm);
    MarkCompSum2.saveADMMarkComp();

    ACP_Performance_Analytics_ctrl MarkCompSum3 = new ACP_Performance_Analytics_ctrl(scm);
    MarkCompSum3.saveAndNewADM();
    List < Task > tskList6 = ACP_TestDataFactory.createTask('Supplier Evaluation', accPlan.id, 1, 'In Progress');
    for (Task obj: tskList6)
      obj.whatid = accPlan.id;
    insert tskList6;
    Test.stopTest();
  }
  /***********************************Test For opportunity tam*******************************************************************/
  public static testMethod void OppTam_TestMethod() {

    Test.startTest();
    Account gamAccount = [select id from account limit 1];

    ACP_Account_Plan__c accplan = ACP_TestDataFactory.createAccountPlan();
    accPlan.ACP_Account_Name__c = gamAccount.id;
    insert accPlan;


    List < ACP_Opportunity_TAM_Revenue__c > OppTam = ACP_TestDataFactory.createOppTamRevenue(accPlan.id, 'CBC3 - 30049 - Tubing Materials');
    for (ACP_Opportunity_TAM_Revenue__c obj: OppTam) {
      obj.ACP_Account_Plan__c = accPlan.id;

    }
    insert OppTam;

    Apexpages.currentPage().getParameters().put('acpid', accplan.id);
    ApexPages.StandardController scm = new ApexPages.StandardController(accplan);
    ACP_Performance_Analytics_ctrl OppTamRev = new ACP_Performance_Analytics_ctrl(scm);


    ACP_Section_Detail__c sectionDet = OppTamRev.oppTAMrec;
    OppTamRev.getOppFields();
   // OppTamRev.actionSaveOpp();
    //OppTamRev.updateOppTamRev();
    // OppTamRev.updateOppTamRev();
    system.debug('task listtt ---vwhdg');
    List < Task > tskList6 = ACP_TestDataFactory.createTask('Top Open Opportunities', accPlan.id, 1, 'In Progress');
    for (Task obj: tskList6)
      obj.whatid = accPlan.id;
    insert tskList6;

    oppTamRev.taskList = tskList6;
    Test.stopTest();
    system.debug('task listtt --- ' + tskList6);
  }



}