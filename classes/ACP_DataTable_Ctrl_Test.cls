/***************************************************************************************
Name:ACP_DataTable_Ctrl_Test
Class:ACP_DataTable_Ctrl
Copyright © 2017 TE Connectivity
=========================================================================================
Requirement:
Test Class for ACP_DataTable_Ctrl 
=========================================================================================
Purpose:
Used for ACP_DataTable_Ctrl.
=========================================================================================
History
-------
Version      Author                Date              Detail
1.0          Alka Kumari           06/05/17          Covering methods of class
2.0          Ritika Pahwa          06/05/17          Covering methods of class
3.0          Anushka Bansal        06/05/17          Covering methods of class
4.0          Esther Ethelbert      06/05/17          Covering methods of class
****************************************************************************************/
@isTest
Private Class ACP_DataTable_Ctrl_Test {
  static ACP_Setting__c acpsetting = createACPSetting('');
  static ACP_Section_Detail__c stakeholderRec = createSectionSettings('Stakeholder and Relationship Settings', '', 'Stakeholder and Relationship', 'name', 'ACP_Relationship_Fieldset_BUAdmin', 'Stakeholder and Relationship');
  static ACP_Section_Detail__c supplierEvalRec = createSectionSettings('TE Supplier Evaluation Settings', '', 'TE Supplier Evaluation', 'createdDate desc', 'ACP_Suppl_Evaluation_Fieldset', 'TE Supplier Evaluation');
  static ACP_Section_Detail__c custOverviewRec = createSectionSettings('Customer Overview Settings', '', 'Customer Overview', 'LastModifiedDate desc', '', 'Customer Overview');
  static ACP_Section_Detail__c appBreakdownRec = createSectionSettings('Application Breakdown Settings', '', 'Application Breakdown', 'createdDate desc', 'ACP_TAM_CY_LY_NY_Field_Set', 'Application Breakdown');
  static ACP_Section_Detail__c Rec = createSectionSettings('Strategy Settings', '', 'Strategy', 'createdDate desc', 'ACP_Status_Fieldset', 'Strategy');

  static ACP_Section_Detail__c openOppRec = createSectionSettings('Top Open Opportunities Settings', '', 'Top Open Opportunities', 'createdDate desc', 'ACP_Top_Open_Opportunity_Fieldset', 'Top Open Opportunities');

  static ACP_Section_Detail__c businessPerformance = createSectionSettings('TE Business Performance Settings', '', 'TE Business Performance', 'ACP_Sales_Mode__c', 'ACP_Revenue_Growth_Fieldset', 'TE Business Performance');
  static ACP_Section_Detail__c marketSUmmary = createSectionSettings('Market and Competition Summary Settings', '', 'Market and Competition Summary', 'createdDate desc', 'ACP_ADM_Fieldset', 'Market and Competition Summary');
  static ACP_Section_Detail__c acpsection = createSectionSettings('Account Plan Header Settings', '', 'Account Plan Header', 'createdDate desc', 'ACP_Account_Plan_Fieldset', 'Account Plan Header');
  static ACP_Section_Detail__c markcomprec = createSectionSettings('Market and Competition Settings', '', 'Market and Competition', 'createdDate desc', 'ACP_Market_Competition_Fieldset', 'Market and Competition');
  static ACP_Section_Detail__c oppTamRevrec = createSectionSettings('Opportunity TAM Revenue Settings', '', 'Opportunity TAM Revenue', 'createdDate desc', 'ACP_Opp_TAM_Revenue_Fieldset', 'Opportunity TAM Revenue');

  String UserBU = acpsetting.Business_Unit__c;
  String AcpSectionDetail = 'ACP_Section_Detail__c';


  /************************Data for acp setting***********************************/
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
      oppList.add(oppy);
    }

    insert oppList;
    system.debug('opp inserted ' + oppList);
  }


  /*******************************************Test Method for Strategy **************************************/
  static testMethod void DataTable_Strategy() {

    Test.startTest();

    ACP_Account_Plan__c accplan = [select id from ACP_Account_Plan__c limit 1];
    ACP_DataTable_Ctrl ctrlObj = new ACP_DataTable_Ctrl();
    List < ACP_Strategy__c > strList = new List < ACP_Strategy__c > ();
    strList = ACP_TestDataFactory.createStrategy(5);
    for (ACP_Strategy__c strategy: strList) {
      strategy.ACP_Account_Plan__c = accplan.id;
    }
    insert strList;
    System.currentPageReference().getParameters().put('acpId', strList[0].ACP_Account_Plan__c);
    ctrlObj.strategyList = strList;
    ctrlObj.actionsave();
    ctrlObj.addStrategies();
    ctrlObj.StrategyId = strList[0].id;
    ctrlObj.DeleteStr();
    ctrlObj.strrec = Rec;
    ctrlObj.StrategyId = null;
    ctrlObj.DeleteStr();
    Test.stopTest();
  }
  /*******************************************Test Method for Supplier Evaluation **************************************/
  static testMethod void DataTable_SupplierEvaluation() {

    Test.startTest();

    ACP_Account_Plan__c accplan = [select id from ACP_Account_Plan__c limit 1];
    ACP_DataTable_Ctrl ctrlObj = new ACP_DataTable_Ctrl();
    List < ACP_TE_Supplier_Evaluation__c > supplierEvaluation = ACP_TestDataFactory.createsupplierEvaluation(1);
    for (ACP_TE_Supplier_Evaluation__c obj: supplierEvaluation) {
      obj.ACP_Account_Plan__c = accplan.id;

    }
    insert supplierEvaluation;
    system.debug('evaluation inserted' + supplierEvaluation);
    System.currentPageReference().getParameters().put('acpId', accplan.id);
    ctrlObj.addSupplierEvaluation();
    ctrlobj.supplierEvaluationList = supplierEvaluation;

    supplierEvaluation[0].ACP_Comments__c = 'updated';
    ctrlObj.actionSaveEval();
    ctrlObj.evalrec = supplierEvalRec;
    ctrlobj.SelectedEvalId = supplierEvaluation[0].id;
    ctrlobj.DeleteEvaluation();
    ctrlobj.SelectedEvalId = null;
    ctrlobj.DeleteEvaluation();
    Test.stopTest();
  }
  /*******************************************Test Method for Supplier Rating **************************************/
  static testMethod void DataTable_SupplierRating() {

    Test.startTest();

    ACP_Account_Plan__c accplan = [select id from ACP_Account_Plan__c limit 1];
    ACP_DataTable_Ctrl ctrlObj = new ACP_DataTable_Ctrl();
    List < ACP_TE_Suppliers_Rating__c > rating = ACP_TestDataFactory.createsupplierRatings(1);
    for (ACP_TE_Suppliers_Rating__c obj: rating) {
      obj.ACP_Account_Plan__c = accPlan.id;

    }
    insert rating;
    System.currentPageReference().getParameters().put('acpId', accplan.id);
    ctrlObj.suppliersRatingList = rating;
    ctrlObj.addSuppliersRatings();

    ctrlObj.actionSaveRating();
    ctrlObj.SelectedRatingId = rating[0].id;
    ctrlObj.DeleteRating();
    Test.stopTest();
  }
  /*******************************************Test Method for Application Breakdown **************************************/
  static testMethod void DataTable_ApplicationBeakdown() {

    Test.startTest();

    ACP_Account_Plan__c accplan = [select id from ACP_Account_Plan__c limit 1];
    ACP_DataTable_Ctrl ctrlObj = new ACP_DataTable_Ctrl();
    List < opportunity > oppList = [select id from opportunity limit 3];
    system.debug('opp found ' + oppList);

    Product_Hierarchy__c newProduct = ACP_TestDataFactory.createProduct();
    Trigger_Configuration__c tc = new Trigger_Configuration__c();
    tc.Name = 'PlatformContentUpdate';
    tc.isRun__c = true;
    insert tc;

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
    System.currentPageReference().getParameters().put('acpId', accplan.id);
    ctrlobj.applicationBreakdownList = appList;
    ctrlobj.addApplicationBreakdown();
    ctrlobj.actionSaveAppBreakdown();
    ctrlObj.getappBreakdownList();
    ctrlObj.appBrkrec = appBreakdownRec;
    ctrlobj.SelectedAppBrkId = appList[0].id;
   // ctrlobj.SelectedAppBrkId2 = appList[1].id;
    //ctrlobj.SelectedAppBrkId3 = applist[2].id;
    ctrlobj.DeleteAppBrkdown();
   // ctrlobj.DeleteAppBrkdownComp2();
   // ctrlobj.DeleteAppBrkdownComp3();

    Test.stopTest();
  }

  /*******************************************Test Method for Top Open Opportunity **************************************/

  static testMethod void DataTable_TopOpenOpportunity() {


    ACP_Account_Plan__c accplan = [select id from ACP_Account_Plan__c limit 1];
    ACP_DataTable_Ctrl ctrlObj = new ACP_DataTable_Ctrl();
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
    Test.startTest();
    System.currentPageReference().getParameters().put('acpId', accplan.id);
    ctrlobj.topOpenOpportunityList = topOpportunities;
    ctrlobj.actionSaveOpenOpps();
    ctrlobj.AddNewTopOpenOpp();
    ctrlObj.openOpprec = openOppRec;
    ctrlobj.SelectedOpenOppId = topOpportunities[0].id;
    ctrlobj.DeleteOpenOpp();

    ctrlobj.SelectedOpenOppId = null;
    ctrlobj.DeleteOpenOpp();

    Test.stopTest();
  }

  /*******************************************Test Method for Purchasing Relationship **************************************/
  static testMethod void DataTable_PuchasingRelationship() {

    ACP_Account_Plan__c accplan = [select id from ACP_Account_Plan__c limit 1];
    List < ACP_Relationship__c > PurRel = ACP_TestDataFactory.createStakeholderRelationship(3, 'Purchasing', accPlan.id);

    Test.startTest();
    ACP_DataTable_Ctrl ctrlObj = new ACP_DataTable_Ctrl();
    System.currentPageReference().getParameters().put('acpId', accplan.id);
    List < ACP_Relationship__c > relationshipList = new List < ACP_Relationship__c > ();
    ctrlObj.tableType = 'Purchasing';
    relationshipList = ctrlObj.commonRelationList;
    ctrlObj.relrec = stakeholderRec;

    ctrlObj.purRelationsList = PurRel;
    ctrlObj.updatePurRelations();
    Boolean disablPurAdd = ctrlObj.disablePurAdd;
    ctrlObj.SelectedPurId = PurRel[0].id;
    ctrlObj.DeletePurRel();
    ctrlObj.SelectedPurId = null;
    ctrlObj.DeletePurRel();
    ctrlObj.addPurRelationship();

    Test.stopTest();
  }

  /*******************************************Test Method for Executive Relationship **************************************/
  static testMethod void DataTable_ExecutiveRelationship() {

    ACP_Account_Plan__c accplan = [select id from ACP_Account_Plan__c limit 1];
    List < ACP_Relationship__c > ExecRel = ACP_TestDataFactory.createStakeholderRelationship(3, 'Executive', accPlan.id);

    Test.startTest();
    ACP_DataTable_Ctrl ctrlObj = new ACP_DataTable_Ctrl();
    System.currentPageReference().getParameters().put('acpId', accplan.id);
    List < ACP_Relationship__c > relationshipList = new List < ACP_Relationship__c > ();
    ctrlObj.tableType = 'Executive';
    relationshipList = ctrlObj.commonRelationList;
    ctrlObj.relrec = stakeholderRec;

    ctrlObj.execRelationsList = ExecRel;
    ctrlObj.updateExecRelations();

    Boolean disableExceAdd = ctrlObj.disableExecAdd;
    ctrlObj.SelectedExecId = ExecRel[0].id;
    ctrlObj.DeleteExecRel();
    ctrlObj.SelectedExecId = null;
    ctrlObj.DeleteExecRel();
    ctrlObj.addExecRelationship();

    Test.stopTest();
  }

  /*******************************************Test Method for Engineering Relationship **************************************/
  static testMethod void DataTable_EngineeringRelationship() {

    ACP_Account_Plan__c accplan = [select id from ACP_Account_Plan__c limit 1];
    List < ACP_Relationship__c > EnggRel = ACP_TestDataFactory.createStakeholderRelationship(3, 'Engineering', accPlan.id);

    Test.startTest();
    ACP_DataTable_Ctrl ctrlObj = new ACP_DataTable_Ctrl();
    System.currentPageReference().getParameters().put('acpId', accplan.id);
    List < ACP_Relationship__c > relationshipList = new List < ACP_Relationship__c > ();
    ctrlObj.tableType = 'Engineering';
    relationshipList = ctrlObj.commonRelationList;
    ctrlObj.relrec = stakeholderRec;

    ctrlObj.engRelationsList = EnggRel;
    ctrlObj.updateEnggRelations();
    Boolean disablEnggAdd = ctrlObj.disableEngAdd;
    ctrlObj.SelectedEngId = EnggRel[0].id;
    ctrlObj.DeleteEngRel();
    ctrlObj.SelectedEngId = null;
    ctrlObj.DeleteEngRel();
    ctrlObj.addEnggRelationship();

    Test.stopTest();
  }


  /*******************************************Test Methods for Customer Overview **************************************/
  static testMethod void DataTable_CustomerOverview1() {


    system.debug('abcdef');
    ACP_Account_Plan__c accplan = [select id from ACP_Account_Plan__c limit 1];
    system.debug('account plan id is : ' + accplan.id);
    ACP_Customer_Overview__c revenue = ACP_TestDataFactory.createCustomerOver(accplan.id, 'Revenue and Growth');
    system.debug('1st record ' + revenue);
    ACP_Customer_Overview__c markets = ACP_TestDataFactory.createCustomerOver(accplan.id, 'End Markets');
    ACP_Customer_Overview__c Regions = ACP_TestDataFactory.createCustomerOver(accplan.id, 'Regions');

    system.debug('records are ' + revenue + 'mrket ' + markets + 'regions ' + regions);
    List < ACP_Customer_Overview__c > overviewList = new List < ACP_Customer_Overview__c > ();
    overviewList.add(revenue);
    overviewList.add(markets);
    overviewList.add(regions);

    system.debug('overview list' + overviewList);
    Test.startTest();
    ACP_DataTable_Ctrl ctrlObj = new ACP_DataTable_Ctrl();
    System.currentPageReference().getParameters().put('acpId', accplan.id);

    ctrlObj.customerOverviewSource = overviewList;
    ctrlObj.actionSave1();
    ctrlObj.custrec = custOverviewRec;
    ctrlObj.customerId = overviewList[0].id;
   // ctrlObj.customerId1 = overviewList[1].id;
  //  ctrlObj.customerId2 = overviewList[2].id;
    ctrlObj.DeleteCust();
  //  ctrlObj.DeleteCust1();
  //  ctrlObj.DeleteCust2();

    Test.stopTest();
  }
  static testMethod void DataTable_CustomerOverview2() {

    ACP_Account_Plan__c accplan = [select id from ACP_Account_Plan__c limit 1];
    ACP_Customer_Overview__c revenue = ACP_TestDataFactory.createCustomerOver(accplan.id, 'Key Vendors in Supply Chain');
    ACP_Customer_Overview__c markets = ACP_TestDataFactory.createCustomerOver(accplan.id, 'Key Engineering /Design locations');
    ACP_Customer_Overview__c Regions = ACP_TestDataFactory.createCustomerOver(accplan.id, 'Key Manufacturing /Purchasing Locations');

    List < ACP_Customer_Overview__c > overviewList = new List < ACP_Customer_Overview__c > ();
    overviewList.add(revenue);
    overviewList.add(markets);
    overviewList.add(regions);

    Test.startTest();
    ACP_DataTable_Ctrl ctrlObj = new ACP_DataTable_Ctrl();
    System.currentPageReference().getParameters().put('acpId', accplan.id);

    ctrlObj.customerOverviewSource = overviewList;
    ctrlObj.actionSave1();
   // ctrlObj.customerId3 = overviewList[0].id;
  //  ctrlObj.customerId4 = overviewList[1].id;
  //  ctrlObj.customerId5 = overviewList[2].id;
  //  ctrlObj.DeleteCust3();
   // ctrlObj.DeleteCust4();
  //  ctrlObj.DeleteCust5();

    Test.stopTest();
  }
  /*******************************************Test Method for Market Competition **************************************/
  static testMethod void DataTable_MarketCompetition() {

    ACP_Account_Plan__c accplan = [select id from ACP_Account_Plan__c limit 1];
     Trigger_Configuration__c tc = new Trigger_Configuration__c();
    tc.Name = 'MarketCompetitionDelete';
    tc.isRun__c = true;
    insert tc;
    List < ACP_Market_and_Competition__c > Mark = ACP_TestDataFactory.createMarketCompetition(3, 'General Market and Competition');
    for (ACP_Market_and_Competition__c obj: mark) {
      obj.ACP_Account_Plan__c = accPlan.id;

    }
    insert mark;
    system.debug('inserted market ' + mark);
    Test.startTest();
    ACP_DataTable_Ctrl ctrlObj = new ACP_DataTable_Ctrl();
    System.currentPageReference().getParameters().put('acpId', accplan.id);

    ctrlObj.addMarketComp();
    ctrlObj.markCompList = mark;

    Test.stopTest();
  }

  static testMethod void DataTable_ADMMarketCompetition() {

    ACP_Account_Plan__c accplan = [select id from ACP_Account_Plan__c limit 1];
     Trigger_Configuration__c tc = new Trigger_Configuration__c();
    tc.Name = 'MarketCompetitionDelete';
    tc.isRun__c = true;
    insert tc;
    List < ACP_Market_and_Competition__c > Mark = ACP_TestDataFactory.createMarketCompetition(3, 'ADM Market and Competition');
    for (ACP_Market_and_Competition__c obj: mark) {
      obj.ACP_Account_Plan__c = accPlan.id;

    }
    insert mark;

    Test.startTest();
    ACP_DataTable_Ctrl ctrlObj = new ACP_DataTable_Ctrl();
    System.currentPageReference().getParameters().put('acpId', accplan.id);

    ctrlObj.addADMMarketComp();
    ctrlObj.admData = mark;
    ctrlObj.actionSaveADM();
    ctrlObj.admId = mark[0].id;
    ctrlObj.DeleteADM();
    ctrlObj.admId = null;
    ctrlObj.DeleteADM();

    Test.stopTest();
  }
  /*******************************************Test Method for Task **************************************/
  static testMethod void DataTable_Task() {

    ACP_Account_Plan__c accplan = [select id from ACP_Account_Plan__c limit 1];
    List < Task > tskList = ACP_TestDataFactory.createTask('Stakeholder and Relationship', accplan.id, 4, 'In Progress');
    insert tskList;

    Test.startTest();
    ACP_DataTable_Ctrl ctrlObj = new ACP_DataTable_Ctrl();
    System.currentPageReference().getParameters().put('acpId', accplan.id);
    ctrlObj.size = 3;
    Integer totalSize = ctrlObj.total_size;
    ctrlObj.commonTaskListAll = tskList;
    ctrlObj.SelectedId = tskList[0].id;
    ctrlObj.DeleteActionfromDetail();
    ctrlObj.actionSaveAll();

    List < ACP_Revenue_Growth_Perf__c > rgListUpdate = new List < ACP_Revenue_Growth_Perf__c > ();
    ACP_Revenue_Growth_Perf__c revenueGrowth = ACP_TestDataFactory.createACPRevenueGrowthPerfBilling();
    revenueGrowth.ACP_Account_Plan__c = accPlan.id;
    rgListUpdate.add(revenueGrowth);
    insert rgListUpdate;
    ctrlObj.perfList = rgListUpdate;
    ctrlObj.updatePerformance();

    Test.stopTest();
  }

}