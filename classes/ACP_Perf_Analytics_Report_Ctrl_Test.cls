/***************************************************************************************
Name:ACP_Perf_Analytics_Report_Ctrl_Test
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
2.0          Anushka Bansal             04/25/17          Covering methods of class
****************************************************************************************/
@isTest(SeeAllData = true)
Private Class ACP_Perf_Analytics_Report_Ctrl_Test {
  static testMethod void MarketComp_RunReport_Method() {
    Test.startTest();
    Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Grouped Accounts').getRecordTypeId();

    Account acct = new Account();
    acct.Name = 'TestAccount1PlanAccount289';
    acct.GAMCD__c = 'G0004';
    if (recType != null)
      acct.RecordTypeId = recType;
    acct.IND_KAM_Code__c = 'K0004';
    Insert acct;

    system.debug('account ---- ' + acct);
    ACP_Account_Plan__c accplan = new ACP_Account_Plan__c(
      Name = 'TestAcc4',
      ACP_Account_Name__c = acct.Id,
      Account_Plan_Type__c = 'GAM Account',
      ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3546');
    insert accplan;

    List < ACP_Market_and_Competition__c > Mark = ACP_TestDataFactory.createMarketCompetition(1, 'General Market and Competition');
    List < ACP_Market_and_Competition__c > markList = new List < ACP_Market_and_Competition__c > ();
    for (ACP_Market_and_Competition__c obj: mark) {
      obj.ACP_Account_Plan__c = accplan.id;
      obj.ACP_CBC__c = 'CBC1 - 30007 - Appliances';
      obj.ACP_LY_Bill__c = 200;
      obj.ACP_CY_YTD__c = 300;
      obj.ACP_LY_YTD__c = 400;
      markList.add(obj);
    }
    insert markList;
    system.debug('mark' + Mark);
    List < BBB_Year_Bill_Book_Cust_PN__c > yearlyBBBList = ACP_TestDataFactory.createYearlyBBB('13333', 'GAM Account', acct.id);
    List < BBB_Year_Bill_Book_Cust_PN__c > yearlyBBB = new List < BBB_Year_Bill_Book_Cust_PN__c > ();
    for (BBB_Year_Bill_Book_Cust_PN__c ybb: yearlyBBBList) {
      ybb.Customer__c = acct.id;
      yearlyBBB.add(ybb);
    }
    insert yearlyBBB;

    system.debug('yearlyBBBList' + yearlyBBBList);
    String reportName1 = 'ACP_Yearly_Billing_Report';
    Report report1 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName1');

    Apexpages.currentPage().getParameters().put('acpid', accplan.id);
    ACP_Performance_Analytics_ctrl ctrlObj = new ACP_Performance_Analytics_ctrl(new ApexPages.StandardController(accplan));
    ctrlObj.acpId = accPlan.id;
    ctrlObj.getCBC1();
    ctrlObj.getCBC2();
    ctrlObj.getCBC3();
    List < SelectOption > optionsCBC1 = ctrlObj.getCBC1;
    List < SelectOption > optionsCBC2 = ctrlObj.getCBC2;
    List < SelectOption > optionsCBC3 = ctrlObj.getCBC3;
    ctrlObj.cbc1Value = 'Appliances--30007';
    ctrlObj.cbc2Value = 'TUBING--30017';
    ctrlObj.cbc3Value = 'Tubing Materials--30049';
    ACP_Opportunity_Data_Automation_Ctrl.marketRunReport('CBC1', '13333', 'GAM Account', '00000', acct.id, report1.id);

    ctrlObj.YBBReportValue();
    ctrlObj.saveCommonMark();
    ctrlObj.saveMarkComp();
    ctrlObj.saveAndNewMark();
    ctrlObj.actionSaveMark();
    ctrlObj.DeleteMark();
    System.assertEquals(ctrlObj.cbc1Value, 'Appliances--30007');
    System.assertEquals(ctrlObj.cbc2Value, 'TUBING--30017');
    System.assertEquals(ctrlObj.cbc3Value, 'Tubing Materials--30049');
    Test.stopTest();
  }

  /******************************** 1st Test for report*************************************************************************************/
  static testMethod void MarketComp_RunReport_Method1() {
    Test.startTest();
    Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Grouped Accounts').getRecordTypeId();

    Account acct = new Account();
    acct.Name = 'TestAccount1PlanAccount289';
    acct.GAMCD__c = 'G0004';
    if (recType != null)
      acct.RecordTypeId = recType;
    acct.IND_KAM_Code__c = 'K0004';
    Insert acct;

    system.debug('account ---- ' + acct);
    ACP_Account_Plan__c accplan = new ACP_Account_Plan__c(
      Name = 'TestAcc4',
      ACP_Account_Name__c = acct.Id,
      Account_Plan_Type__c = 'KAM Account',
      ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3546');
    insert accplan;

    List < ACP_Market_and_Competition__c > Mark = ACP_TestDataFactory.createMarketCompetition(1, 'General Market and Competition');
    List < ACP_Market_and_Competition__c > markList = new List < ACP_Market_and_Competition__c > ();
    for (ACP_Market_and_Competition__c obj: mark) {
      obj.ACP_Account_Plan__c = accplan.id;
      obj.ACP_CBC__c = 'CBC1 - 30007 - Appliances';
      obj.ACP_LY_Bill__c = 200;
      obj.ACP_CY_YTD__c = 300;
      obj.ACP_LY_YTD__c = 400;
      markList.add(obj);
    }
    insert markList;
    system.debug('mark' + Mark);
    List < BBB_Year_Bill_Book_Cust_PN__c > yearlyBBBList = ACP_TestDataFactory.createYearlyBBB('13333', 'KAM Account', acct.id);
    List < BBB_Year_Bill_Book_Cust_PN__c > yearlyBBB = new List < BBB_Year_Bill_Book_Cust_PN__c > ();
    for (BBB_Year_Bill_Book_Cust_PN__c ybb: yearlyBBBList) {
      ybb.Customer__c = acct.id;
      yearlyBBB.add(ybb);
    }
    insert yearlyBBB;

    system.debug('yearlyBBBList' + yearlyBBBList);
    String reportName1 = 'ACP_Yearly_Billing_Report';
    Report report1 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName1');

    Apexpages.currentPage().getParameters().put('acpid', accplan.id);
    ACP_Performance_Analytics_ctrl ctrlObj = new ACP_Performance_Analytics_ctrl(new ApexPages.StandardController(accplan));
    ctrlObj.acpId = accPlan.id;
    ctrlObj.getCBC1();
    ctrlObj.getCBC2();
    ctrlObj.getCBC3();
    List < SelectOption > optionsCBC1 = ctrlObj.getCBC1;
    List < SelectOption > optionsCBC2 = ctrlObj.getCBC2;
    List < SelectOption > optionsCBC3 = ctrlObj.getCBC3;
    ctrlObj.cbc1Value = 'Appliances--30007';
    ctrlObj.cbc2Value = 'TUBING--30017';
    ctrlObj.cbc3Value = 'Tubing Materials--30049';
    ACP_Opportunity_Data_Automation_Ctrl.marketRunReport('CBC2', '13332', 'KAM Account', '00000', acct.id, report1.id);




    // ctrlObj.YBBReportValue();
    ctrlObj.saveCommonMark();
    ctrlObj.saveMarkComp();
    ctrlObj.saveAndNewMark();
    ctrlObj.actionSaveMark();
    ctrlObj.DeleteMark();
    System.assertEquals(ctrlObj.cbc1Value, 'Appliances--30007');
    System.assertEquals(ctrlObj.cbc2Value, 'TUBING--30017');
    System.assertEquals(ctrlObj.cbc3Value, 'Tubing Materials--30049');
    Test.stopTest();
  }
  /********************************2nd Test for report*************************************************************************************/
  static testMethod void MarketComp_RunReport_Method2() {
    Test.startTest();
    Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Grouped Accounts').getRecordTypeId();

    Account acct = new Account();
    acct.Name = 'TestAccount1PlanAccount289';
    acct.GAMCD__c = 'G0004';
    if (recType != null)
      acct.RecordTypeId = recType;
    acct.IND_KAM_Code__c = 'K0004';
    Insert acct;

    system.debug('account ---- ' + acct);
    ACP_Account_Plan__c accplan = new ACP_Account_Plan__c(
      Name = 'TestAcc4',
      ACP_Account_Name__c = acct.Id,
      Account_Plan_Type__c = 'WW Account',
      ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3546');
    insert accplan;

    List < ACP_Market_and_Competition__c > Mark = ACP_TestDataFactory.createMarketCompetition(1, 'General Market and Competition');
    List < ACP_Market_and_Competition__c > markList = new List < ACP_Market_and_Competition__c > ();
    for (ACP_Market_and_Competition__c obj: mark) {
      obj.ACP_Account_Plan__c = accplan.id;
      obj.ACP_CBC__c = 'CBC1 - 30007 - Appliances';
      obj.ACP_LY_Bill__c = 200;
      obj.ACP_CY_YTD__c = 300;
      obj.ACP_LY_YTD__c = 400;
      markList.add(obj);
    }
    insert markList;
    system.debug('mark' + Mark);
    List < BBB_Year_Bill_Book_Cust_PN__c > yearlyBBBList = ACP_TestDataFactory.createYearlyBBB('13331', 'WW Account', acct.id);
    List < BBB_Year_Bill_Book_Cust_PN__c > yearlyBBB = new List < BBB_Year_Bill_Book_Cust_PN__c > ();
    for (BBB_Year_Bill_Book_Cust_PN__c ybb: yearlyBBBList) {
      ybb.Customer__c = acct.id;
      yearlyBBB.add(ybb);
    }
    insert yearlyBBB;

    system.debug('yearlyBBBList' + yearlyBBBList);
    String reportName1 = 'ACP_Yearly_Billing_Report';
    Report report1 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName1');

    Apexpages.currentPage().getParameters().put('acpid', accplan.id);
    ACP_Performance_Analytics_ctrl ctrlObj = new ACP_Performance_Analytics_ctrl(new ApexPages.StandardController(accplan));

    ctrlObj.acpId = accPlan.id;
    ctrlObj.acpId = accPlan.id;
    ctrlObj.getCBC1();
    ctrlObj.getCBC2();
    ctrlObj.getCBC3();
    List < SelectOption > optionsCBC1 = ctrlObj.getCBC1;
    List < SelectOption > optionsCBC2 = ctrlObj.getCBC2;
    List < SelectOption > optionsCBC3 = ctrlObj.getCBC3;
    ctrlObj.cbc1Value = 'Appliances--30007';
    ctrlObj.cbc2Value = 'TUBING--30017';
    ctrlObj.cbc3Value = 'Tubing Materials--30049';
    ACP_Opportunity_Data_Automation_Ctrl.marketRunReport('CBC3', '13331', 'KAM Account', '00000', acct.id, report1.id);



    //  ctrlObj.YBBReportValue();
    ctrlObj.saveCommonMark();
    ctrlObj.saveMarkComp();
    ctrlObj.saveAndNewMark();
    ctrlObj.actionSaveMark();
    ctrlObj.DeleteMark();
    System.assertEquals(ctrlObj.cbc1Value, 'Appliances--30007');
    System.assertEquals(ctrlObj.cbc2Value, 'TUBING--30017');
    System.assertEquals(ctrlObj.cbc3Value, 'Tubing Materials--30049');
    Test.stopTest();
  }
  /********************************3rd Test for report*************************************************************************************/
  static testMethod void MarketComp_RunReport_Method3() {
    Test.startTest();
    Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account').getRecordTypeId();

    Account acct = new Account();
    acct.Name = 'TestAccount1PlanAccount289';
    acct.GAMCD__c = 'G0004';
    if (recType != null)
      acct.RecordTypeId = recType;
    acct.IND_KAM_Code__c = 'K0004';
    Insert acct;

    system.debug('account ---- ' + acct);
    ACP_Account_Plan__c accplan = new ACP_Account_Plan__c(
      Name = 'TestAcc4',
      ACP_Account_Name__c = acct.Id,
      Account_Plan_Type__c = 'Sold-to Account',
      ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3546');
    insert accplan;

    List < ACP_Market_and_Competition__c > Mark = ACP_TestDataFactory.createMarketCompetition(1, 'General Market and Competition');
    List < ACP_Market_and_Competition__c > markList = new List < ACP_Market_and_Competition__c > ();
    for (ACP_Market_and_Competition__c obj: mark) {
      obj.ACP_Account_Plan__c = accplan.id;
      obj.ACP_CBC__c = 'CBC1 - 30007 - Appliances';
      obj.ACP_LY_Bill__c = 200;
      obj.ACP_CY_YTD__c = 300;
      obj.ACP_LY_YTD__c = 400;
      markList.add(obj);
    }
    insert markList;
    system.debug('mark' + Mark);
    List < BBB_Year_Bill_Book_Cust_PN__c > yearlyBBBList = ACP_TestDataFactory.createYearlyBBB('13331', 'Sold-to Account', acct.id);
    List < BBB_Year_Bill_Book_Cust_PN__c > yearlyBBB = new List < BBB_Year_Bill_Book_Cust_PN__c > ();
    for (BBB_Year_Bill_Book_Cust_PN__c ybb: yearlyBBBList) {
      ybb.Customer__c = acct.id;
      yearlyBBB.add(ybb);
    }
    insert yearlyBBB;

    system.debug('yearlyBBBList' + yearlyBBBList);
    String reportName1 = 'ACP_Yearly_Billing_Report';
    Report report1 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName1');

    Apexpages.currentPage().getParameters().put('acpid', accplan.id);
    ACP_Performance_Analytics_ctrl ctrlObj = new ACP_Performance_Analytics_ctrl(new ApexPages.StandardController(accplan));
    ctrlObj.acpId = accPlan.id;
    ctrlObj.getCBC1();
    ctrlObj.getCBC2();
    ctrlObj.getCBC3();
    List < SelectOption > optionsCBC1 = ctrlObj.getCBC1;
    List < SelectOption > optionsCBC2 = ctrlObj.getCBC2;
    List < SelectOption > optionsCBC3 = ctrlObj.getCBC3;
    ctrlObj.cbc1Value = 'Appliances--30007';
    ctrlObj.cbc2Value = 'TUBING--30017';
    ctrlObj.cbc3Value = 'Tubing Materials--30049';
    ACP_Opportunity_Data_Automation_Ctrl.marketRunReport('CBC3', '13331', 'Sold-to Account', '000000000000000', acct.id, report1.id);


    // ctrlObj.YBBReportValue();
    ctrlObj.saveCommonMark();
    ctrlObj.saveMarkComp();
    ctrlObj.saveAndNewMark();
    ctrlObj.actionSaveMark();
    ctrlObj.DeleteMark();
    System.assertEquals(ctrlObj.cbc1Value, 'Appliances--30007');
    System.assertEquals(ctrlObj.cbc2Value, 'TUBING--30017');
    System.assertEquals(ctrlObj.cbc3Value, 'Tubing Materials--30049');
    Test.stopTest();
  }
  /*********************************************4th Test for report************************************************************************/
  static testMethod void MarketComp_RunReport_Method4() {
    Test.startTest();
    Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account').getRecordTypeId();
    Test.setCurrentPageReference(new PageReference('Page.ACP_Edit_Mkt_Product_CBC'));

    Account acct = new Account();
    acct.Name = 'TestAccount1PlanAccount289';
    acct.GAMCD__c = 'G0004';
    if (recType != null)
      acct.RecordTypeId = recType;
    acct.IND_KAM_Code__c = 'K0004';
    Insert acct;

    system.debug('account ---- ' + acct);
    ACP_Account_Plan__c accplan = new ACP_Account_Plan__c(
      Name = 'TestAcc4',
      ACP_Account_Name__c = acct.Id,
      Account_Plan_Type__c = 'Sold-to Account',
      ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3546');
    insert accplan;

    RecordType rcdType = [Select Id, name from RecordType where Name = 'General Market and Competition'];
    Id recordId = rcdType.Id;

    ACP_Market_and_Competition__c Mark = new ACP_Market_and_Competition__c();
    Mark.RecordTypeId = recordId;
    Mark.ACP_Account_Plan__c = accPlan.id;
    Mark.ACP_Main_Competitor_Share__c = 14;
    Mark.ACP_Market_Share__c = 12;
    Mark.ACP_NY_Fcst__c = 20;
    Mark.ACP_PAM__c = 200;
    Mark.ACP_SAM__c = 200;
    Mark.ACP_TAM__c = 200;
    Mark.ACP_TE_Position__c = 'Flat';
    Mark.ACP_CBC__c = 'CBC3 - 30017 - Tubing Materials';
    Mark.ACP_TAM_LY_Bill__c = 20.00;
    Mark.ACP_TAM_CYRR__c = 20.00;
    Mark.ACP_TAM_NY_Fcst__c = 20.00;
    Mark.ACP_LY_Bill__c = 200;
    Mark.ACP_CY_YTD__c = 300;
    Mark.ACP_LY_YTD__c = 400;

    insert Mark;
    system.debug('mark' + Mark);
    List < BBB_Year_Bill_Book_Cust_PN__c > yearlyBBBList = ACP_TestDataFactory.createYearlyBBB('13331', 'Sold-to Account', acct.id);
    List < BBB_Year_Bill_Book_Cust_PN__c > yearlyBBB = new List < BBB_Year_Bill_Book_Cust_PN__c > ();
    for (BBB_Year_Bill_Book_Cust_PN__c ybb: yearlyBBBList) {
      ybb.Customer__c = acct.id;
      yearlyBBB.add(ybb);
    }
    insert yearlyBBB;

    system.debug('yearlyBBBList' + yearlyBBBList);
    String reportName1 = 'ACP_Yearly_Billing_Report';
    Report report1 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName1');


    Apexpages.currentPage().getParameters().put('acpid', accplan.id);
    Apexpages.currentPage().getParameters().put('macid', Mark.id);
    ACP_Performance_Analytics_ctrl ctrlObj = new ACP_Performance_Analytics_ctrl(new ApexPages.StandardController(accplan));

    ctrlObj.acpId = accPlan.id;
    ctrlObj.getCBC1();
    ctrlObj.getCBC2();
    ctrlObj.getCBC3();

    List < SelectOption > optionsCBC1 = ctrlObj.getCBC1;
    List < SelectOption > optionsCBC2 = ctrlObj.getCBC2;
    List < SelectOption > optionsCBC3 = ctrlObj.getCBC3;
    ctrlObj.cbc1Value = 'Appliances--30007';
    ctrlObj.cbc2Value = 'TUBING--30017';
    ctrlObj.cbc3Value = 'Tubing Materials--30049';
    ACP_Opportunity_Data_Automation_Ctrl.marketRunReport('CBC3', '13331', 'Sold-to Account', '000000000000000', acct.id, report1.id);


    ctrlObj.YBBReportValue();
    ctrlObj.saveCommonMark();
    ctrlObj.saveMarkComp();
    ctrlObj.saveAndNewMark();
    ctrlObj.actionSaveMark();
   // ctrlObj.updateCommonCBC();
   // ctrlObj.saveCBCProd();
    System.assertEquals(ctrlObj.cbc1Value, 'Appliances--30007');
    System.assertEquals(ctrlObj.cbc2Value, 'TUBING--30017');
    System.assertEquals(ctrlObj.cbc3Value, 'Tubing Materials--30049');
    Test.stopTest();
  }

}