/******************************************************************************************************************
Name: ACP_Revenue_Growth_Ctrl_Test
Copyright @ 2017 TE Connectivity
=============================================================================
Requirement:
Test class for ACP_Revenue_Growth_Ctrl
=============================================================================
Purpose:
Controller to add and edit ACP_Revenue_Growth_Perf__c records and display data on 
Revenue and Growth table on ACP_Performance_Analytics_Page
=============================================================================
History
-------
VERSION   AUTHOR        DATE         DETAIL
1.0 -    Anushka Bansal 10/06/17     INITIAL DEVELOPMENT
2.0 -    Anushka Bansal 11/02/17     Added comments 
********************************************************************************************************************/
@isTest(seeAllData = true)
Private Class ACP_Revenue_Growth_Ctrl_Test {
 static ACP_Setting__c acpsetting = createACPSetting('');
  static ACP_Section_Detail__c businessPerformance = createSectionSettings('TE Business Performance Settings', '', 'TE Business Performance', 'ACP_Sales_Mode__c', 'ACP_Revenue_Growth_Fieldset', 'TE Business Performance');
  
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
   
    if (recTypeName == 'TE Business Performance') {
      sectionSetting.Revenue_and_Growth_Plan_Year_1__c = '2017';
      sectionSetting.Revenue_and_Growth_Plan_Year_1__c = '2018';
      sectionSetting.Revenue_and_Growth_Plan_Year_1__c = '2020';
      sectionSetting.Revenue_Type__c = 'Direct; POS; CMA';
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
 static testMethod void DataTable_RunReport_Method() {
  RecordType rt1 = ClsTestHelp.createTestRecordType8();
  Account acct = ClsTestHelp.createtestAccounts();
  acct.RecordTypeId = rt1.Id;

  insert acct;
  system.debug('account ---- ' + acct);
  ACP_Account_Plan__c accplan = new ACP_Account_Plan__c(
   Name = 'TestAcc4',
   ACP_Account_Name__c = acct.Id,
   Account_Plan_Type__c = 'Sold-to Account',
   ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3564');
  insert accplan;

  FiscalYearSettings fiscalYear = [select name, StartDate from FiscalYearSettings where StartDate <= : date.today() AND EndDate >= : date.today()];
  String fy = fiscalYear.name;
  List < BBB_Month_Bill_Book_Cust__c > monthlyBBBList = ACP_TestDataFactory.createMonthlyBBB(fy, 1, acct.id);

  for (BBB_Month_Bill_Book_Cust__c bbb: monthlyBBBList) {
   bbb.Customer__c = acct.id;
  }
  insert monthlyBBBList;
  system.debug('list : ' + monthlyBBBList);
  Test.startTest();
  String reportName1 = 'ACP_Revenue_Growth_Report1';
  Report report1 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName1');
  String reportName2 = 'ACP_Revenue_Growth_Report2';
  Report report2 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName2');



  ACP_Revenue_Growth_Ctrl ctrlObj = new ACP_Revenue_Growth_Ctrl();
  System.currentPageReference().getParameters().put('acpId', accplan.id);
  ctrlObj.acpId = accPlan.id;
  //ctrlObj.revenueGrowthList = 
  ctrlObj.runReport();
  ctrlObj.updatePerformance();
  Test.stopTest();
 }

 static testMethod void DataTable_RunReport_Method2() {

  Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Grouped Accounts').getRecordTypeId();

  Account acct = new Account(
   Name = 'TestAccount1PlanAccount1089',
   RecordTypeId = recType,
   GAMCD__c = 'G0007');
  Insert acct;

  // Create Account Plan
  ACP_Account_Plan__c accplan = new ACP_Account_Plan__c(
   Name = 'TestAccount1Plan3564',
   ACP_Account_Name__c = acct.Id,
   Account_Plan_Type__c = 'GAM Account',
   ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3564');
  insert accplan;

  FiscalYearSettings fiscalYear = [select name, StartDate from FiscalYearSettings where StartDate <= : date.today() AND EndDate >= : date.today()];
  String fy = fiscalYear.name;
  List < BBB_Month_Bill_Book_Cust__c > monthlyBBBList = ACP_TestDataFactory.createMonthlyBBB(fy, 1, acct.id);

  for (BBB_Month_Bill_Book_Cust__c bbb: monthlyBBBList) {
   bbb.Customer__c = acct.id;
  }
  insert monthlyBBBList;
  String reportName1 = 'ACP_Revenue_Growth_Report1';
  Report report1 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName1');
  String reportName2 = 'ACP_Revenue_Growth_Report2';
  Report report2 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName2');


  Test.startTest();
  ACP_Revenue_Growth_Ctrl ctrlObj = new ACP_Revenue_Growth_Ctrl();
  System.currentPageReference().getParameters().put('acpId', accplan.id);
  ctrlObj.acpId = accPlan.id;
  ctrlObj.runReport();
  ctrlObj.updatePerformance();
  Test.stopTest();
 }


 static testMethod void DataTable_RunReport_Method3() {

  Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Grouped Accounts').getRecordTypeId();

  Account acct = new Account(
   Name = 'TestAccount1PlanAccount1089',
   RecordTypeId = recType,
   IND_KAM_Code__c = 'K0007');
  Insert acct;

  // Create Account Plan
  ACP_Account_Plan__c accplan = new ACP_Account_Plan__c(
   Name = 'TestAccount1Plan3564',
   ACP_Account_Name__c = acct.Id,
   Account_Plan_Type__c = 'KAM Account',
   ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3564');
  insert accplan;

  FiscalYearSettings fiscalYear = [select name, StartDate from FiscalYearSettings where StartDate <= : date.today() AND EndDate >= : date.today()];
  String fy = fiscalYear.name;
  List < BBB_Month_Bill_Book_Cust__c > monthlyBBBList = ACP_TestDataFactory.createMonthlyBBB(fy, 1, acct.id);

  for (BBB_Month_Bill_Book_Cust__c bbb: monthlyBBBList) {
   bbb.Customer__c = acct.id;
  }
  insert monthlyBBBList;
  String reportName1 = 'ACP_Revenue_Growth_Report1';
  Report report1 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName1');
  String reportName2 = 'ACP_Revenue_Growth_Report2';
  Report report2 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName2');


  Test.startTest();
  ACP_Revenue_Growth_Ctrl ctrlObj = new ACP_Revenue_Growth_Ctrl();
  System.currentPageReference().getParameters().put('acpId', accplan.id);

  ctrlObj.acpId = accPlan.id;
  ctrlObj.revtype = businessPerformance.Revenue_Type__c;
  ctrlObj.refreshbasedOn = 'Billing';
  system.debug('run report method');
  ctrlObj.runReport();
  ctrlObj.updatePerformance();
  ctrlObj.runReport();
  Test.stopTest();
 }


}