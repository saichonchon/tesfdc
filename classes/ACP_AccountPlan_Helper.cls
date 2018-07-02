/******************************************************************************************************************
Name: ACP_AccountPlan_Helper
Copyright @ 2017 TE Connectivity
==================================================================================================================
Requirement:
ACP_AccountPlan_Helper for  ACP_View_Customer_Page, ACP_Performance_Analytics_Page, ACP_Account_Plan_Summary_Page
==================================================================================================================
Purpose:
Helper class for Account Plan controllers
Test class:
ACP_AccountPlan_Helper_Test
==================================================================================================================
History
-------
VERSION   AUTHOR        DATE         DETAIL
1.0 -    Alka Kumari    04/25/17     INITIAL DEVELOPMENT
2.0 -    Anushka Bansal 11/02/17     Added header commentas and added errorlogs in to catch block 
********************************************************************************************************************/
public with sharing class ACP_AccountPlan_Helper {
 public static Map < string, id > oddRowImagesProd {
  get;
  set;
 }
 public static Map < string, id > evenRowImagesProd {
  get;
  set;
 }
 public transient static string nameFile {
  get;
  set;
 }
 public static String companyLogoId {
  get;
  set;
 }
 public static String managerImgId {
  get;
  set;
 }
 public static ACP_Account_Plan__c accPlan {
  get;
  set;
 }


 /************************************BU Admin Setting - Start*/
 //Method to get BU Admin setting detail for the Record Type and ACP Setting record passed as parameter


 public static ACP_Section_Detail__c getACPSectionRec(ACP_Setting__c acpsetting, String recordTypeName) {

  Id recordtypeid = Schema.SObjectType.ACP_Section_Detail__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
  system.debug('method started -- record type name ' + recordtypename + ' id : -- ' + recordtypeid);
  //system.debug(' section detail records ' + acpsetting.ACP_Section_Details__r);
  ACP_Section_Detail__c detailRec = new ACP_Section_Detail__c();
  for (ACP_Section_Detail__c acpS: acpsetting.ACP_Section_Details__r) {
   system.debug('entered ' + acps + ' record type id ' + recordtypeid);
   if (acpS.recordTypeid == recordtypeid) {
    return acpS;
   }
  }

  system.debug('exited ');
  return null;
 }

 //Method to get Account Plan setting record for the BU passed as parameter
 public static ACP_Setting__c getACPSettingsRecord(String userBU, String acctplanType) {
  system.debug('entered 2 acct plan type ---' + acctplanType);
  String acpSettingFields = getAllFields('ACP_Setting__c');
  String acpSectionFields = getAllFields('ACP_Section_Detail__c');
  String queryString = '';
  boolean isactive = true;
  queryString += 'SELECT ' + acpSettingFields + ', (SELECT ' + acpSectionFields + ' FROM ACP_Section_Details__r)';
  queryString += 'FROM ACP_Setting__c WHERE Business_Unit__c = :userBU and Account_Plan_Type__c =: acctplanType and ACP_Is_Active__c =: isactive limit 1';
  system.debug(' query abcd ' + queryString + ' --------- userBU ------ ' + userBU);

  List < ACP_Setting__c > busetting = new List < ACP_Setting__c > ();
  busetting = Database.query(queryString);
  if (busetting.size() > 0)
   return busetting[0];
  else
   return null;

 }


 /************************************BU Admin Setting - End*/
 /*************************************Generic Methods - Start*/
 //Method to return list of fields added in a field set which is passed as parameter of this method
 public static List < Schema.FieldSetMember > getFieldSetFields(String fieldSetName, String ObjectName) {

   system.debug('get field sets ');
   Map < String, Schema.SObjectType > GlobalDescribeMap = Schema.getGlobalDescribe();
   Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
   Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
   Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
   return fieldSetObj.getFields();
  }
  //Return all field separed by comma available on the object passed as parameter
 public static String getAllFields(String sobjectname) {
   Map < String, Schema.SObjectField > fields = Schema.getGlobalDescribe().get(sobjectname).getDescribe().SObjectType.getDescribe().fields.getMap();
   List < String > fieldsList = new List < String > ();
   for (Schema.SObjectField field: fields.values()) {
    fieldsList.add(field.getDescribe().getName());
    system.debug('fields list is ' + fieldsList);
   }
   String allfields = '';
   for (String fieldname: fieldsList)
    allfields += fieldname + ',';
   allfields = allfields.subString(0, allfields.length() - 1);
   system.debug('allfields : ' + allfields);
   return allfields;
  }
  /*************************************Generic Methods - End*/
  /*************************************Stakeholder & Relationship - Start*/
  //Return Stakeholder ad Relationship record's list as per the fieldset, and Account Plan passed as method parameter
 public static List < ACP_Relationship__c > getacpRelList(String fieldSetName, String sortOrder, String acpId) {
   String query = 'SELECT ';
   for (Schema.FieldSetMember f: getFieldSetFields(fieldSetName, 'ACP_Relationship__c')) {
    query += f.getFieldPath() + ',';
   }
   query += 'Id, Name,Relationship__c,ACP_Account_Plan__c,ACP_Name__r.name FROM ACP_Relationship__c where ACP_Account_Plan__c = :acpId';
   if (sortOrder != null)
    query += ' order by ' + sortOrder;
   try {
    return Database.query(query);
   }
   Catch(Exception e) { ErrorLogging.Log(e, 'ACP_AccountPlan_Helper', 'getacpRelList', acpId);
    return null;}
  }
  /*************************************Stakeholder & Relationship - End*/
  /*************************************Action Sections for Master Page - Start*/
  //Return list of Task related to the Account Plan which is passed as method parameter
 public static List < Task > getAllTasks(String acpId) {
   List < Task > taskList = new List < Task > ();
   String query = 'SELECT ';
   for (Schema.FieldSetMember f: ACP_AccountPlan_Helper.getFieldSetFields('ACP_Actions_Fieldset', 'Task')) {
    query += f.getFieldPath() + ',';
   }
   query += 'Id FROM Task where WhatId = ';
   query += ':acpId and ACP_Category__c != null ';
   try {
    taskList = Database.query(query);
    return taskList;
   }
   Catch(Exception e) {ErrorLogging.Log(e, 'ACP_AccountPlan_Helper', 'getAllTasks', acpId);
    return null;}
  }
  /*************************************Action Sections for Master Page - End*/
  /*************************************Business Performance - Start*/
  //return list of Revenue Growth data as per the method parameter passed
 public static List < ACP_Revenue_Growth_Perf__c > getPerfList(String bu, String revenueType, String sortOrder, String fieldSetName, String acpId) {
   List < String > arrTest = revenueType.split(';');
   List < ACP_Revenue_Growth_Perf__c > perfList = new List < ACP_Revenue_Growth_Perf__c > ();
   String query = 'SELECT ';
   for (Schema.FieldSetMember f: getFieldSetFields(fieldSetName, 'ACP_Revenue_Growth_Perf__c')) {
    query += f.getFieldPath() + ',';
   }
   query += 'Id FROM ACP_Revenue_Growth_Perf__c where ACP_Account_Plan__c = ';
   query += ':acpId and ACP_Refresh_Based_on__c = :bu and ACP_Sales_Mode__c = :arrTest';
   if (sortOrder != null)
    query += ' order by ' + sortOrder;
   try {
    perfList = Database.query(query);
    return perfList;
   }
   Catch(Exception e) {ErrorLogging.Log(e, 'ACP_AccountPlan_Helper', 'getPerfList', acpId);
    return null;}
  }
  /*************************************Business Performance - End*/
  /********************get accoutplan header fields to display in accout plan header section************/
 public static List < Schema.FieldSetMember > getAcctPlanFields(ACP_Setting__c acpsetting, String recordTypeName) {
   Id recordtypeid = Schema.SObjectType.ACP_Section_Detail__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
   ACP_Section_Detail__c detailRec = new ACP_Section_Detail__c();
   for (ACP_Section_Detail__c acpS: acpsetting.ACP_Section_Details__r) {
    if (acpS.recordTypeid == recordtypeid) {
     Map < String, Schema.Fieldset > fieldsetsMap = Schema.SObjectType.ACP_Account_Plan__c.fieldSets.getMap();
     return fieldsetsMap.get(acpS.ACP_Field_Set_Name__c).getFields();
    }
   }
   return null;
  }
  /*****************************End*****************************/
  /********************get Account Summary detail to display in accout plan header section***********/
 public static ACP_Account_Plan__c acctPlanHeaderRec(string acpId) {
   try {
    ACP_Account_Plan__c AccDet = [select id, ACP_Account_Name__r.id, ACP_Account_Manager__c, ACP_Account_Summary__c, ACP_Account_Name__r.name, ACP_Account_Name__r.AccountNumber, ACP_Account_Name__r.Description, ACP_Account_Name__r.Website, Account_Plan_Type__c
     from ACP_Account_Plan__c where id = : acpId
    ];
    //accountPlanType = AccDet.Account_Plan_Type__c;
    //system.debug('account plan type is  : ' + accountPlanType);
    accountPlanHeaderImages(acpId);
    return accDet;
   } catch (Exception e) {ErrorLogging.Log(e, 'ACP_AccountPlan_Helper', 'acctPlanHeaderRec', acpId);}
   return null;
  }
  /***************************End ****************/
  /********************get All product immages to display in accout plan header section************/

 public static void accountPlanHeaderImages(string acpId) {
  List < Attachment > evenRowAttachmentProd = new List < Attachment > ();
  List < Attachment > oddRowAttachmentProd = new List < Attachment > ();
  List < Attachment > mngrImgAttachment = new List < Attachment > ();
  List < Attachment > companyLogoAttachment = new List < Attachment > ();
  try {
   List < ACP_Account_Plan_Attachment__c > acpAccountPlanAttach = [SELECT Id, Name, ACP_Type__c, (SELECT Id, Name FROM Attachments order by CreatedDate desc)
    FROM ACP_Account_Plan_Attachment__c where ACP_Account_Plan__r.id = : acpId and ACP_Type__c in ('Product', 'Company Logo', 'Account Manager') order by ACP_Type__c, CreatedDate desc
   ];
   evenRowImagesProd = new Map < string, id > ();
   oddRowImagesProd = new Map < string, id > ();
   integer counter = 0;
   for (ACP_Account_Plan_Attachment__c acp: acpAccountPlanAttach) {
    if (acp.Attachments.size() > 0 && acp.ACP_Type__c == 'Company Logo') {
     CompanyLogoAttachment.add(acp.Attachments[0]);
     companyLogoId = CompanyLogoAttachment[0].id;
    }
    if (acp.Attachments.size() > 0 && acp.ACP_Type__c == 'Account Manager') {
     MngrImgAttachment.add(acp.Attachments[0]);
     ManagerImgId = MngrImgAttachment[0].id;
    }

    if (acp.Attachments.size() > 0 && acp.ACP_Type__c == 'Product') {
     counter = counter + 1;
     for (Integer i = 0; i < acp.Attachments.size(); i = i + 2) {
      //for (Integer i = 0; i < 9; i = i + 2) {
      oddRowAttachmentProd.add(acp.Attachments[i]);
      if (i < acp.Attachments.size() - 1)
       evenRowAttachmentProd.add(acp.Attachments[i + 1]);
     }
     if (counter == 5) {
      break;
     }
    }
   }
   for (Attachment atts: evenRowAttachmentProd) {
    String nameField = atts.Name;
    if (nameField.Contains('.')) {
     nameFile = nameField.substringBefore('.');
     evenRowImagesProd.put(nameFile, atts.id);
    }
   }
   for (Attachment atts: oddRowAttachmentProd) {
    String nameField = atts.Name;
    if (nameField.Contains('.')) {
     nameFile = nameField.substringBefore('.');
     oddRowImagesProd.put(nameFile, atts.id);
    }
   }
  } catch (DMLException e) {ErrorLogging.Log(e, 'ACP_AccountPlan_Helper', 'accountPlanHeaderImages', acpId);}

 }
 public static ACP_Account_Plan__c getAccPlan(String fieldSetName, String acpId) {
   String query = 'SELECT ';
   for (Schema.FieldSetMember f: getFieldSetFields(fieldSetName, 'ACP_Account_Plan__c')) {
    query += f.getFieldPath() + ',';
   }
   query += 'Id from ACP_Account_Plan__c where id  = \'' + acpid + '\' ';
   try {
    accPlan = Database.query(query);
   } catch (DMLException e) {ErrorLogging.Log(e, 'ACP_AccountPlan_Helper', 'getAccPlan', acpId);}
   return accPlan;
  }
  /*************************end*****************************/
}