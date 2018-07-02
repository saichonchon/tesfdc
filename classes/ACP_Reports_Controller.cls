/******************************************************************************************************************
Name: ACP_Reports_Controller
Copyright @ 2017 TE Connectivity
=============================================================================
Requirement:
ACP_Reports_Controller for ACP_Analytics_Admin_Page
=============================================================================
Purpose:
Controller for Analytics Admin Page, to edit, delete or add new records of analytics report charts
Test class:
ACP_Reports_Controller_Test
=============================================================================
History
-------
VERSION   AUTHOR        DATE         DETAIL
1.0 -    Anushka Bansal 06/05/17     INITIAL DEVELOPMENT
2.0 -    Anushka Bansal 11/02/17     Added header comments and comments 
********************************************************************************************************************/

public with sharing class ACP_Reports_Controller {

 public boolean editBlock {
  get;
  set;
 }
 public List < Report > reports {
  get;
  set;
 }
 public List < SelectOption > options {
  get;
  set;
 }
 public ACP_Analytics__c analytics = new ACP_Analytics__c();
 public String inputReportName {
  get;
  set;
 }
 public String selectedReportNum {
  get;
  set;
 }
 public String selectedReport {
  get;
  set;
 }
 public String error {
  get;
  set;
 }

 public ACP_Reports_Controller() {
  editBlock = false;
 }

 public List < ACP_Analytics__c > getAnalyticsRecords() {
   List < ACP_Analytics__c > analyticsList = new List < ACP_Analytics__c > ();
   try {
    analyticsList = [Select id, ACP_Business_Unit__c, Account_Plan_Type__c, ACP_Analytics_Page__c, ACP_Active__c, ACP_Report_1__c, ACP_Report_2__c, ACP_Report_3__c, ACP_Report_4__c, ACP_Report_5__c, ACP_Report_6__c from ACP_Analytics__c];
   } catch (Exception e) {
    ErrorLogging.Log(e, 'ACP_Reports_Controller', 'getAnalyticsRecords', '');
    ApexPages.addMessages(e);
   }

   return analyticsList;
  }
  // To edit an existing analytic record
 public pageReference editRecord() {
  editBlock = true;
  String id = ApexPages.currentPage().getParameters().get('recordId');
  try {
   analytics = [Select ACP_Business_Unit__c, Account_Plan_Type__c, ACP_Active__c, ACP_Analytics_Page__c, ACP_Report_1__c, ACP_Report_2__c, ACP_Report_3__c, ACP_Report_4__c, ACP_Report_5__c, ACP_Report_6__c
    from ACP_Analytics__c where id = : id
   ];
  } catch (Exception e) {
   ErrorLogging.Log(e, 'ACP_Reports_Controller', 'editRecord', '');
   ApexPages.addMessages(e);
  }
  return page.ACP_Analytics_Admin_Page;
 }

 // To delete an existing analytics record 
 public pageReference deleteAnalytics() {
  String id = ApexPages.currentPage().getParameters().get('recordId');
  try {
   analytics = [Select ACP_Business_Unit__c, ACP_Active__c, Account_Plan_Type__c, ACP_Analytics_Page__c, ACP_Report_1__c, ACP_Report_2__c, ACP_Report_3__c, ACP_Report_4__c, ACP_Report_5__c, ACP_Report_6__c
    from ACP_Analytics__c where id = : id
   ];
   delete analytics;
   return pageRedirection();
  } catch (Exception e) {
   ErrorLogging.Log(e, 'ACP_Reports_Controller', 'deleteAnalytis', id);
   ApexPages.addMessages(e);

  }
  return null;
 }

 // To load the page on click of cancel or save button
 public pageReference pageRedirection() {
  editBlock = false;

  PageReference pageref = new PageReference('/apex/ACP_Analytics_Admin_Page');
  pageref.setRedirect(true);

  return pageref;
 }

 public ACP_Analytics__c getAnalytics() {
  return analytics;
 }

 // Method to display block for adding new analytics record
 public pageReference addNewAnalytics() {
  editBlock = true;
  return null;
 }

 // Populate report number drop down list
 public List < SelectOption > getReportNumber() {
  List < SelectOption > options = new List < SelectOption > ();
  for (Integer i = 1; i < 7; i++)
   options.add(new SelectOption('' + i, 'Report ' + i));
  return options;
 }

 // Method to display reports from database based on the search keyword 
 public pageReference searchReports() {

  options = new List < SelectOption > ();
  options.add(new SelectOption(' ' + '//' + ' ', 'none'));
  reports = new List < Report > ();

  if (inputReportName != '' && inputReportName != null && inputReportName.length() > 3) {
   error = '';

   reports = [select id, name from report where name like: +'%' + inputReportName + '%'
    limit 500
   ];

   for (Report r: this.reports)
    options.add(new SelectOption(r.name + '//' + r.id, r.name));
  } else
   error = 'Please Enter atleast 4 characters';
  return null;
 }


 //Method to display and add the selected report names to analytics fields  
 public pageReference addReportToField() {
  if (selectedReportNum == '1') {

   analytics.ACP_Report_1__c = selectedReport.split('//')[0];
   analytics.ACP_Report_1_Id__c = selectedReport.split('//')[1];
  }

  if (selectedReportNum == '2') {
   analytics.ACP_Report_2__c = selectedReport.split('//')[0];
   analytics.ACP_Report_2_Id__c = selectedReport.split('//')[1];

  }

  if (selectedReportNum == '3') {
   analytics.ACP_Report_3__c = selectedReport.split('//')[0];
   analytics.ACP_Report_3_Id__c = selectedReport.split('//')[1];

  }
  if (selectedReportNum == '4') {
   analytics.ACP_Report_4__c = selectedReport.split('//')[0];
   analytics.ACP_Report_4_Id__c = selectedReport.split('//')[1];

  }
  if (selectedReportNum == '5') {
   analytics.ACP_Report_5__c = selectedReport.split('//')[0];
   analytics.ACP_Report_5_Id__c = selectedReport.split('//')[1];

  }
  if (selectedReportNum == '6') {
   analytics.ACP_Report_6__c = selectedReport.split('//')[0];
   analytics.ACP_Report_6_Id__c = selectedReport.split('//')[1];

  }
  return null;
 }

 // To save a new record or update an existing record
 public pageReference SaveAnalyticRecord() {

  try {
   upsert analytics;
   return pageRedirection();
  } catch (Exception e) {
   ErrorLogging.Log(e, 'ACP_Reports_Controller', 'SaveAnalyticRecord', '');
   ApexPages.addMessages(e);
  }

  return null;
 }


}