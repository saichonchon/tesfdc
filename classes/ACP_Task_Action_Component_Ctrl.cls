/******************************************************************************************************************
Name: ACP_Task_Action_Component_Ctrl
Copyright @ 2017 TE Connectivity
==================================================================================================================
Requirement:
ACP_Task_Action_Component_Ctrl for  ACP_View_Customer_Page, ACP_Performance_Analytics_Page, ACP_Account_Plan_Summary_Page
==================================================================================================================
Purpose:
Controller for component ACP_Task_Action_Component to show all the task filtered as per the parameter passed for 
Account Plan Id and Category while calling the component
Test class:
ACP_Task_Action_Component_Ctrl_Test
==================================================================================================================
History
-------
VERSION   AUTHOR        DATE         DETAIL
1.0 -    Alka Kumari    06/01/17     INITIAL DEVELOPMENT
2.0 -    Anushka Bansal 11/02/17     Added header comments and added errorlogs in to catch block 
********************************************************************************************************************/
public with sharing class ACP_Task_Action_Component_Ctrl {

 public String accountPlanIdVar {
  get;
  set;
 }
 public String categoryVar {
  get;
  set;
 }
 public Boolean viewMore {
  get;
  set;
 }
 public List < Task > commonTaskList {
  get;
  set;
 }

 public List < Task > businessPerfTaskList {
  get;
  set;
 }

 public ACP_Task_Action_Component_Ctrl() {
  viewMore = false;
 }


 public String actStatus {
  get {
   if (actStatus == Null) actStatus = 'All';
   system.debug('acpid act status : ' + accountPlanIdVar);
   return actStatus;
  }
  set;
 }
 public static List < SelectOption > getStatusOptions() {
   List < SelectOption > actStat = new List < SelectOption > ();
   actStat.add(new SelectOption('All', 'All'));
   actStat.add(new SelectOption('In Progress', 'In Progress'));
   actStat.add(new SelectOption('Not Started', 'Not Started'));
   actStat.add(new SelectOption('Waiting on someone else', 'Waiting on someone else'));
   actStat.add(new SelectOption('Deferred', 'Deferred'));
   actStat.add(new SelectOption('Completed', 'Completed'));
   return actStat;
  }
  // methods to be called from ACP_Task_Action_Component_Ctrl for Action section when Add Button is clicked on UI
 public PageReference addTask() {
   PageReference pageref = new PageReference('/apex/ACP_New_Action?saveURL=/apex/ACP_AccountPlan_Page?acpId=' + accountPlanIdVar);
   pageref.getParameters().put('category', categoryVar);
   pageref.getParameters().put('acpId', accountPlanIdVar);
   pageref.setRedirect(true);
   return pageref;
  }
  //Get and Set method to show the Actions list on UI and hold the value when inline edit
 public List < Task > relatedActivitiesList {
   get {
    relatedActivitiesList = getTasksList(commonTaskList);
    return relatedActivitiesList;
   }
   set;
  }
  //used for Status filter to show Action values as per the Status selection on UI
 public void updatefilter() {
 system.debug('update filter');
  getTaskListMain();
 }

 //Methos to save the Task to database after inline is done and Save button is clicked
 public PageReference actionSave() {
  try {
  system.debug('entered save');
   update relatedActivitiesList;
   updatefilter();
  }
  Catch(Exception e) {
   ErrorLogging.Log(e, 'ACP_Task_Action_Component_Ctrl', 'actionSave', accountPlanIdVar);
   ApexPages.addMessages(e);
  }
  return null;
 }
 public string SelectedId {
  get;
  set;
 }
 public void DeleteAction() {
  if (SelectedId == null) {
   return;
  }
  Task tobeDeleted = null;
  for (Integer i = 0; i < commonTaskList.size(); i++)
  {
    if (commonTaskList[i].Id == SelectedId ) {
        tobeDeleted = commonTaskList[i];
        Delete tobeDeleted ;
        commonTaskList.remove(i);
        break;
      }
  }
 }
 public List < Task > getTaskListMain() {
  List < Task > taskList = new List < Task > ();

  if (categoryVar == 'All')
   taskList = commonTaskList;
  else
   taskList = getCategoryWiseTaskList();
  return getTasksList(taskList);
 }



 public List < Task > getCategoryWiseTaskList() {
  system.debug('category is : ' + categoryVar);
  List < Task > t = new List < Task > ();
  for (Task tsk: commonTaskList) {
   if (tsk.ACP_Category__c == categoryVar)
    t.add(tsk);
  }
  return t;

 }

 public List < Task > getTasksList(List < Task > taskList) {
  ACP_Actions_Row_Size__c rowSize = ACP_Actions_Row_Size__c.getValues('actions_row_size');

  viewMore = false;
  List < Task > tskList = new List < Task > ();
  if (actStatus != 'All') {
   for (Task tsk: taskList) {
    if (tsk.Status == actStatus)
     tskList.add(tsk);
   }
   if (tskList.size() > rowSize.ACP_Actions_Row_Size__c) {
    viewMore = true;
    List < Task > limitTaskList = new List < Task > ();
    for (Task tsk: tskList) {
     if (limitTaskList.size() < rowSize.ACP_Actions_Row_Size__c)
      limitTaskList.add(tsk);
    }
    return limitTaskList;
   } else {
    viewMore = false;
    return tskList;
   }
  } else {
   if (taskList.size() > rowSize.ACP_Actions_Row_Size__c) {
    viewMore = true;
    List < Task > limitTaskList = new List < Task > ();
    for (Task tsk: taskList) {
     if (limitTaskList.size() < rowSize.ACP_Actions_Row_Size__c)
      limitTaskList.add(tsk);
    }
    return limitTaskList;
   } else {
    viewMore = false;
    return taskList;
   }
  }
 }

 /**************** Code for delete functionality - End ******************************/


}