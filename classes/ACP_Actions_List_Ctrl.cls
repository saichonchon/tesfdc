/******************************************************************************************************************
Name: ACP_Actions_List_Ctrl
Copyright @ 2017 TE Connectivity
==================================================================================================================
Requirement:
ACP_Actions_List_Ctrl for ACP_Account_Plan_Summary_Page
==================================================================================================================
Purpose:
Controller for VF Page ACP_Actions_List to show Actions list when there are more than 10 records
Test class:
ACP_Actions_List_Ctrl_Test
==================================================================================================================
History
-------
VERSION   AUTHOR        DATE         DETAIL
1.0 -    Alka Kumari    06/05/17     INITIAL DEVELOPMENT
2.0 -    Anushka Bansal 11/02/17     Added header comments and added errorlogs in to catch block 
********************************************************************************************************************/
public with sharing class ACP_Actions_List_Ctrl {

 public String accountPlanId {
  get;
  set;
 }
 public String category {
  get;
  set;
 }
 public String actionStatus {
  get;
  set;
 }
 public List < Task > taskList = new List < Task > ();
 Public Integer noOfRecords {
  get;
  set;
 }
 Public Integer size {
  get;
  set;
 }

 private integer counter {
  get;
  set;
 } //keeps track of the offset
 private integer list_size {
  get;
  set;
 } //sets the page size or number of rows
 public integer total_size {
  get;
  set;
 } //used to show user the total size of the list

 public Boolean isNext {
  get;
  set;
 }
 //Default constructor
 public ACP_Actions_List_Ctrl() {
   accountPlanId = ApexPages.currentPage().getParameters().get('acpId');
   category = ApexPages.currentPage().getParameters().get('category');
   if (category == null)
    category = 'All';
    
    
   actionStatus = ApexPages.currentPage().getParameters().get('actionStatus');
   system.debug('all -- '+ category + 'aa'+ actionstatus);
   counter = 0; //keeps track of the offset
   list_size = (Integer.valueof(System.Label.ACP_Actions_List_Size.trim())); //sets the page size or number of rows 
   try {
    taskList = Database.query(getQuery());
   }
   Catch(Exception e) {
    ErrorLogging.Log(e, 'ACP_Actions_List_Ctrl', 'ACP_Actions_List_Ctrl', accountPlanId);
   }
   total_size = taskList.size(); //set the total size in the constructor
   isNext = true;
  }
  //Method to get the query string
 private String getQuery() {
  String query = 'SELECT ';
  for (Schema.FieldSetMember f: this.getTaskFields()) {
   query += f.getFieldPath() + ',';
  }
  query += 'Id,whatid FROM Task where WhatId = ';
  query += ':accountPlanId ';
  if (category == 'All') {
  query += ' and ACP_Category__c != null ';
  }
  
 else if (category != 'All') {
   query += ' and ACP_Category__c=:category';
   }
   if (actionStatus != 'All')
    query += ' and Status = :actionStatus';
 
  system.debug('query -- ' +query);
  return query;
 }

 public List < Task > Tasks {
   get {
    if (isNext) {
     String query = getQuery();
     query += ' order by status,createdDate limit :list_size offset :counter';
     try {
      tasks = Database.query(query);
     }
     Catch(Exception e) {
      ErrorLogging.Log(e, 'ACP_Actions_List_Ctrl', 'Tasks', accountPlanId);
     }
     isNext = false;
     return tasks;
    }
    return tasks;
   }
   set;
  }
  //Method to return list of field from Task field set
 private List < Schema.FieldSetMember > getTaskFields() {
   return SObjectType.Task.FieldSets.ACP_Actions_Fieldset.getFields();
  }
  //when user clicked beginning
 public PageReference Beginning() {
   counter = 0;
   isNext = true;
   return null;
  }
  //user clicked previous button
 public PageReference Previous() {
   isNext = true;
   counter -= list_size;
   return null;
  }
  //user clicked next button
 public PageReference Next() {
   isNext = true;
   counter += list_size;
   return null;
  }
  //user clicked end
 public PageReference End() {
   counter = total_size - math.mod(total_size, list_size);
   isNext = true;
   return null;
  }
  //this will disable the previous and beginning buttons
 public Boolean getDisablePrevious() {
   if (counter > 0) return false;
   else return true;
  }
  //this will disable the next and end buttons
 public Boolean getDisableNext() {
   if (counter + list_size < total_size) return false;
   else return true;
  }
  //return total size of list
 public Integer getTotal_size() {
   return total_size;
  }
  //return the page number which user is seeing currently
 public Integer getPageNumber() {
   return counter / list_size + 1;
  }
  //return number of total pages for pagination
 public Integer getTotalPages() {
  if (math.mod(total_size, list_size) > 0) {
   return total_size / list_size + 1;
  } else {
   return (total_size / list_size);
  }
 }
}