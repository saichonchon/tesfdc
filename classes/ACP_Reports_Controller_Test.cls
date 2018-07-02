/******************************************************************************************************************
Name: ACP_Reports_Controller_Test
Copyright @ 2017 TE Connectivity
=============================================================================
Requirement:
Test class for ACP_Reports_Controller
=============================================================================
Purpose:
Controller for Analytics Admin Page, to edit, delete or add new records of 
analytics report charts
=============================================================================
History
-------
VERSION   AUTHOR        DATE         DETAIL
1.0 -    Suresh Aepoor  07/10/17     INITIAL DEVELOPMENT
2.0 -    Anushka Bansal 11/02/17     Added comments 
********************************************************************************************************************/
@isTest(seeAllData = true)
Private Class ACP_Reports_Controller_Test {

 static User defaultUser = ACP_TestDataFactory.createUser('System Administrator', null);

 static testMethod void adminReportsTestMethod() {
  Test.setCurrentPageReference(new PageReference('Page.ACP_Analytics_Admin_Page'));

  Test.startTest();
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

  ACP_Reports_Controller ctrl = new ACP_Reports_Controller();
  //ACP_TestDataFactory.createAnalyticPage1(10);
  ctrl.addNewAnalytics();
  ctrl.getReportNumber();
  ctrl.inputReportName = 'duch';
  ctrl.searchReports();
  ctrl.selectedReportNum = '1';
  ctrl.selectedReport = analyticsList[0].ACP_Report_1__c + '//' + analyticsList[0].ACP_Report_1_Id__c;
  ctrl.addReportToField();
  ctrl.selectedReportNum = '2';
  ctrl.selectedReport = analyticsList[0].ACP_Report_2__c + '//' + analyticsList[0].ACP_Report_2_Id__c;
  ctrl.addReportToField();
  ctrl.selectedReportNum = '3';
  ctrl.selectedReport = analyticsList[0].ACP_Report_3__c + '//' + analyticsList[0].ACP_Report_3_Id__c;
  ctrl.addReportToField();
  ctrl.selectedReportNum = '4';
  ctrl.selectedReport = analyticsList[0].ACP_Report_4__c + '//' + analyticsList[0].ACP_Report_4_Id__c;
  ctrl.addReportToField();
  ctrl.selectedReportNum = '5';
  ctrl.selectedReport = analyticsList[0].ACP_Report_5__c + '//' + analyticsList[0].ACP_Report_5_Id__c;
  ctrl.addReportToField();
  ctrl.selectedReportNum = '6';
  ctrl.selectedReport = analyticsList[0].ACP_Report_6__c + '//' + analyticsList[0].ACP_Report_6_Id__c;
  ctrl.addReportToField();
  ctrl.SaveAnalyticRecord();
  ctrl.editRecord();
  ctrl.deleteAnalytics();
  ctrl.getAnalyticsRecords();
  ctrl.getAnalyticsRecords();


  ACP_Reports_Controller ctrlObj2 = new ACP_Reports_Controller();
  ctrlObj2.inputReportName = 'fg';
  ctrlObj2.searchReports();

  ACP_Reports_Controller ctrlObj3 = new ACP_Reports_Controller();
  ctrlObj3.inputReportName = 'account';
  ctrlObj3.searchReports();
  ctrlObj3.selectedReportNum = '1';
  ctrlObj3.selectedReport = analyticsList[0].ACP_Report_1__c + '//' + analyticsList[0].ACP_Report_1_Id__c + 'sdhgfdshfghsdgfhghsdhdsfhsdjdhsfdfdfbdgfsdhfdfgdhgfdhf645745';
  ctrlObj3.addReportToField();
  ctrlObj3.SaveAnalyticRecord();
  Test.stopTest();
 }
}