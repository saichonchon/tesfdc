/******************************************************************************************************************
Name: ACP_New_Action_Ext
Copyright @ 2017 TE Connectivity
=============================================================================
Requirement:
ACP_New_Action_Ext for ACP_New_Action 
=============================================================================
Purpose:
Extension controller for page ACP_New_Action to override standard Save and Cancel button 

Test class:
ACP_New_Action_Ext_Test
=============================================================================
History
-------
VERSION   AUTHOR        DATE         DETAIL
1.0 -    Alka Kumari    04/27/17     INITIAL DEVELOPMENT
2.0 -    Anushka Bansal 11/02/17     Added header comments and added errorlogs in to catch block 
********************************************************************************************************************/
public with sharing class ACP_New_Action_Ext {

 public Task tsk {
  get;
  set;
 }
 public String category {
  get;
  set;
 }
 Private ApexPages.StandardController con;
 public String acpid {
  get;
  set;
 }

 public ACP_New_Action_Ext(ApexPages.StandardController controller) {
  this.con = controller;
  acpid = ApexPages.currentPage().getParameters().get('acpid');
  category = ApexPages.currentPage().getParameters().get('category');
  system.debug('anushka category ' + category);
  tsk = (Task) controller.getRecord();
  tsk.OwnerId = UserInfo.getUserId();
 }

 //Method to save a new task
 public void saveCommon() {
  tsk.Whatid = acpid;
  tsk.ACP_Category__c = category;
  system.debug('date time reminder ' + tsk.ReminderDateTime);
  //if(tsk.ReminderDateTime != null )
  tsk.IsReminderSet = true;
  Id devRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Account Plan').getRecordTypeId();
  tsk.RecordTypeId = devRecordTypeId;
  try {
   insert tsk;
  } catch (Exception e) {ErrorLogging.Log(e, 'ACP_New_Action_Ext', 'saveCommon', acpId);}
 }

 // Method to save a task after inline editing
 public PageReference save() {
  try {
   saveCommon();

   return pageRedirection();
  } catch (Exception e) {ErrorLogging.Log(e, 'ACP_New_Action_Ext', 'save', acpId);}
  return null;
 }


 //Method to save a task and redirect user to add a new task
 public PageReference saveAndNew() {
  try {
   saveCommon();
   PageReference pageref = new PageReference('/apex/ACP_New_Action?saveURL=/apex/ACP_View_Customer_Page?acpId=' + acpid);
   pageref.getParameters().put('category', category);
   pageref.getParameters().put('acpId', acpid);
   pageref.setRedirect(true);
   return pageref;
  } catch (Exception e) {ErrorLogging.Log(e, 'ACP_New_Action_Ext', 'saveAndNew', acpId);}
  return null;
 }
 public PageReference cancel() {
  return pageRedirection();
 }


 //method to redirect user to the appropriate section on the VF page after saving the task record
 public PageReference pageRedirection() {
  PageReference pageRef;
  if (category == 'Stakeholder and Relationship')
   pageRef = new PageReference('/apex/ACP_View_Customer_Page?acpId=' + acpId + '#relationship');
  else if (category == 'Supplier Evaluation')
   pageRef = new PageReference('/apex/ACP_View_Customer_Page?acpId=' + acpId + '#rating');
  else if (category == 'Top Open Opportunities')
   pageRef = new PageReference('/apex/ACP_Performance_Analytics_page?acpId=' + acpId + '#topOpenOpp');
  else if (category == 'Market and Competition')
   pageRef = new PageReference('/apex/ACP_Performance_Analytics_page?acpId=' + acpId + '#MrktCompDetail');
  else if (category == 'ADM Market & Competition')
   pageRef = new PageReference('/apex/ACP_Performance_Analytics_page?acpId=' + acpId + '#MrktComp');
  else if (category == 'Application Breakdown')
   pageRef = new PageReference('/apex/ACP_Performance_Analytics_page?acpId=' + acpId + '#applicationBreakdown');
  else if (category == 'Business Performance')
   pageRef = new PageReference('/apex/ACP_Performance_Analytics_page?acpId=' + acpId + '#businessPerf');
  pageRef.setRedirect(true);
  return pageRef;
 }

}