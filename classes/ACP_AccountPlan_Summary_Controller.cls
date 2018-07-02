/***************************************************************************************
Name:ACP_AccountPlan_Summary_Controller
Test Class:ACP_AccountPlan_Summary_Controller_Test , ACP_AccountPlan_Summary_Controller_Test2
Copyright © 2017 TE Connectivity
=========================================================================================
Requirement:
Controller for ACP_Account_Plan_Summary_Page
=========================================================================================
Purpose:
Used for Strategy and Metrics Tab.
=========================================================================================
History
-------
Version      Author              Date              Detail
1.0          Ritika Pahwa        06/05/17          Added Strategy Section
2.0          Anushka Bansal      06/05/17          Added Analytics Report Section
****************************************************************************************/

global with sharing class ACP_AccountPlan_Summary_Controller {
 private ApexPages.StandardController controller;
 public String userBU {
  get;
  set;
 }

 public String acpId {
  get;
  set;
 }
 ACP_Setting__c buSetting = new ACP_Setting__c();


String acctPlantype;

 public List < ACP_Account_Plan__c > accDet {
  get;
  set;
 }

 public List < Id > reportIdsPg1 {
  get;
  set;
 }
 public List < Id > reportIdsPg2 {
  get;
  set;
 }

 List < ACP_Analytics__c > analytics = new List < ACP_Analytics__c > ();
 public List < Id > reportIdList = new List < Id > ();
 
 private final ACP_Account_Plan__c Act;
 public String column {
  get;
  set;
 }
 public String filterValue {
  get;
  set;
 }

 public List < Schema.FieldSetMember > headerAcctPlanFields {
  get;
  set;
 }
 public ACP_Account_Plan__c accountPlantHeaderRec {
  get;
  set;
 }
 public Map < string, id > accountPlanEvenRowImagesProd {
  get;
  set;
 }
 public Map < string, id > accountPlanOddRowImagesProd {
  get;
  set;
 }
 public String accountPlancompanyLogoId {
  get;
  set;
 }
 public String accountPlanmanagerImgId {
  get;
  set;
 }
 public ACP_Account_Plan__c accountPlanDet {
  get;
  set;
 }

 /*************************************Default Constructor Starts *********************************/
 public ACP_AccountPlan_Summary_Controller() {
 acpid = ApexPages.currentPage().getParameters().get('acpId');
 AccDet = [select id, name, Account_Plan_Type__c from ACP_Account_Plan__c where id = : acpId ];
 
   userBU = [Select GIBU__c From User Where Id = : UserInfo.getUserId()][0].GIBU__c;
   buSetting = ACP_AccountPlan_Helper.getACPSettingsRecord(userBU, accDet[0].Account_Plan_Type__c );
   
   if (buSetting == null)
    buSetting = ACP_AccountPlan_Helper.getACPSettingsRecord('', '');
system.debug('bu setting ----- ' + busetting);
   accDet = new List < ACP_Account_Plan__c > ();
   

   getStrategiesList();


  }
  /*************************************Default Constructor Ends *********************************/
  /*************************************Parameterized Constructor Start *********************************/
 public ACP_AccountPlan_Summary_Controller(ApexPages.StandardController controller) {

   acpId = ApexPages.currentPage().getParameters().get('acpId');
   setCategoryWiseTask();
 
   AccDet = [select id, name, Account_Plan_Type__c, ACP_GAMCode__c, ACP_KAMCode__c, ACP_Account_Name__c, ACP_WWAcNo__c, ACP_Account_Name__r.id, ACP_Account_Manager__c, ACP_Account_Summary__c, ACP_Account_Name__r.name, ACP_Account_Name__r.AccountNumber, ACP_Account_Name__r.Description, ACP_Account_Name__r.Website
     from ACP_Account_Plan__c where id = : acpId
    ];
    
   userBU = [Select GIBU__c From User Where Id = : UserInfo.getUserId()][0].GIBU__c;

   buSetting = ACP_AccountPlan_Helper.getACPSettingsRecord(userBU,accDet[0].Account_Plan_Type__c);
   
   if (buSetting == null) 
   buSetting = ACP_AccountPlan_Helper.getACPSettingsRecord('','');


   this.Act = (ACP_Account_Plan__c) controller.getRecord();
   this.controller = controller;
   getStrategiesList();

    
   
   
    if(AccDet != null)
    {
   
   acctPlantype = AccDet[0].Account_Plan_Type__c;
   if (AccDet[0].Account_Plan_Type__c == 'GAM Account') {
    filterValue = AccDet[0].ACP_GAMCode__c;
    column = 'Account.GAMCD__c';
   } else if (AccDet[0].Account_Plan_Type__c == 'KAM Account') {
    filterValue = AccDet[0].ACP_KAMCode__c;
    column = 'Account.IND_KAM_Code__c';
   } else if (AccDet[0].Account_Plan_Type__c == 'WW Account') {
    column = 'Account.WWCORPACCT__c';
    filterValue = AccDet[0].ACP_WWAcNo__c;
   } else if (AccDet[0].Account_Plan_Type__c == 'Sold-to Account') {
    column = 'Account.Id';
    filterValue = AccDet[0].ACP_Account_Name__c;
   }
   
    }
   reportIdsPg1 = getReportIds('1');
   reportIdsPg2 = getReportIds('2');
   system.debug('page 2 ids ' + reportIdsPg2);
   //getReportIdsPg1();


   /*******************************************Get Account Details and Account Summary*********************************************/
   
   //==to get account plan header informaton (account plan fieds,summmary ,Products)from helper class ====
   headerAcctPlanFields = ACP_AccountPlan_Helper.getAcctPlanFields(buSetting, 'Account Plan Header');

   accountPlantHeaderRec = ACP_AccountPlan_Helper.acctPlanHeaderRec(acpId);

   accountPlanEvenRowImagesProd = ACP_AccountPlan_Helper.evenRowImagesProd;
   accountPlanOddRowImagesProd = ACP_AccountPlan_Helper.oddRowImagesProd;
   accountPlancompanyLogoId = ACP_AccountPlan_Helper.companyLogoId;
   accountPlanmanagerImgId = ACP_AccountPlan_Helper.managerImgId;
   try
   {
   system.debug('#1 ' + accplanrec);
   system.debug('#2 ' + accplanrec.ACP_Field_Set_Name__c);
   system.debug('12345687 ' + acpId);
   accountPlanDet = ACP_AccountPlan_Helper.getAccPlan(accplanrec.ACP_Field_Set_Name__c, acpId);
   
      } catch (Exception e) { ErrorLogging.Log(e, 'ACP_AccountPlan_Summary_Controller', 'ACP_AccountPlan_Summary_Controller', acpId); ApexPages.addMessages(e);
   
   
   }
   //=====end== 
  }
  /*************************************Parameterized Constructor Ends *********************************/



 /*********************************Common Methods for Cancel and Save Buttons for all new record creation pages *************/
 public pagereference masterPageRedirection() {
   PageReference pageref = new PageReference('/apex/ACP_Account_Plan_Summary_Page');
   pageref.getParameters().put('acpId', acpId);
   pageref.setRedirect(true);
   return pageref;
  }
  //-----------------------------------------------------------------------------------------------
  /* *****************************************Strategy Related Code  - Starts  */
 Id strategyRecTypeId = Schema.SObjectType.ACP_Section_Detail__c.getRecordTypeInfosByName().get('Strategy').getRecordTypeId();
 public ACP_Section_Detail__c strrec {
  get {
   strrec = getACPSectionRec(buSetting, strategyRecTypeId);
   return strrec;
  }
  set;
 }
 ACP_Strategy__c Strategy = new ACP_Strategy__c();
 transient public List < ACP_Strategy__c > strategyList {
  get;
  set;
 }
 Public ACP_Strategy__c getStrategy() {
  return Strategy;
 }
 public List < ACP_Strategy__c > acpStrategyList {
  get;
  set;
 }
 public List < ACP_Strategy__c > acpList = new List < ACP_Strategy__c > ();
 public void getStrategiesList() {
  acpStrategyList = new List < ACP_Strategy__c > ();
  acpList = getStrategyList();
  if (acpList.size() > 0) {
   for (ACP_Strategy__c acpStrategy: acpList) {
    acpStrategyList.add(acpStrategy);
   }
  }
 }
 public List < ACP_Strategy__c > getStrategyList() {

  acpid = ApexPages.currentPage().getParameters().get('acpId');


  String query = 'SELECT ';
  for (Schema.FieldSetMember f: this.getStrFields()) {
   query += f.getFieldPath() + ',';
  }

  try {
   query += 'Id,ACP_Account_Plan__c FROM ACP_Strategy__c where ACP_Account_Plan__c = \'' + acpId + '\'';
   if (strrec != null && strrec.Default_Sort_Order__c != null) query += ' order by ' + strrec.Default_Sort_Order__c;
   if (strrec != null && strrec.ACP_No_Of_Records__c != null) query += ' limit ' + strrec.ACP_No_Of_Records__c;
   else query += ' limit 10';

   return Database.query(query);

  }
  Catch(Exception e) {ErrorLogging.Log(e, 'ACP_AccountPlan_Summary_Controller', 'getStrategyList', acpId);ApexPages.addMessages(e);
        }
  return null;
 }

 public List < Schema.FieldSetMember > getStrFields() {
  Map < String, Schema.Fieldset > fieldsetsEvalMap = Schema.SObjectType.ACP_Strategy__c.fieldSets.getMap();

  if (strrec != null) {

   return fieldsetsEvalMap.get(strrec.ACP_Field_Set_Name__c).getFields();
  } else return SObjectType.ACP_Strategy__c.FieldSets.ACP_Status_Fieldset.getFields();

 }

 public pageReference addStrategy() {
  try {
  system.debug('strategy acpid ---- '+ acpId);
   Strategy.ACP_Account_Plan__c = acpId;
   
   insert Strategy;
   system.debug('success insert ---');
  return pageRedirectWithDivId('strategy');
  }
  Catch(Exception e) { ErrorLogging.Log(e, 'ACP_AccountPlan_Summary_Controller', 'addStrategy', acpId); ApexPages.addMessages(e);
  }
  return null;
 }
 public pageReference saveAndNewStrategy() {
  try {
   Strategy.ACP_Account_Plan__c = acpId;
   insert Strategy;
   PageReference pageref = new PageReference('/apex/ACP_Add_Strategy');
   pageref.getParameters().put('acpId', acpId);
   pageref.setRedirect(true);
   return pageref;
  }
  Catch(Exception e) { ErrorLogging.Log(e, 'ACP_AccountPlan_Page_Controller', 'saveAndNewStrategy', acpId);ApexPages.addMessages(e); 
  }
  return null;
 }

 /* *****************************************Strategy Related Code  - Ends  */
 /************************************************Code for Actions scetion - Start */
 public List < Task > taskList {
  get;
  set;
 }
 
 
 public void setCategoryWiseTask() {
 taskList = ACP_AccountPlan_Helper.getAllTasks(acpId);
   
  }
  /************************************************Code for Actions scetion - End */
  /************************************** Start of Analytics Code ***********************************/
 
  /**********************Method to add report ids to a list******************************/
 public List < Id > addIdsToList(ACP_Analytics__c record) {
 system.debug('analytics record  -- ' + record);
   List < Id > idList = new List < Id > ();
   if (record.ACP_Report_1_Id__c != null) {
    idList.add(record.ACP_Report_1_Id__c);
   }
   if (record.ACP_Report_2_Id__c != null) {
    idList.add(record.ACP_Report_2_Id__c);
   }
   if (record.ACP_Report_3_Id__c != null) {
    idList.add(record.ACP_Report_3_Id__c);
   }
   if (record.ACP_Report_4_Id__c != null) {
    idList.add(record.ACP_Report_4_Id__c);
   }
   if (record.ACP_Report_5_Id__c != null) {
    idList.add(record.ACP_Report_5_Id__c);
   }
   if (record.ACP_Report_6_Id__c != null) {
    idList.add(record.ACP_Report_6_Id__c);
   }
   return idList;
  }
  /**********************Method to get report Ids Lists  abcdef ******************************/
 
 public List < Id > getReportIds(String pageNum) {
     String BU = userBU;
   Integer count = [Select count() from ACP_Analytics__c where ACP_Analytics_Page__c = : pageNum and ACP_Business_Unit__c = : BU and Account_Plan_Type__c = : acctPlantype and ACP_Active__c = true];
  system.debug('count -- ' + count + ' page num ' + pageNum + 'usre BU' + userBU+ 'acct plan type ' + acctplantype);
   if (count == 0) BU = 'Default';
   analytics = [Select id, ACP_Analytics_Page__c, ACP_Report_1_Id__c, ACP_Report_2_Id__c, ACP_Report_3_Id__c, ACP_Report_4_Id__c, ACP_Report_5_Id__c,
    ACP_Report_6_Id__c from ACP_Analytics__c where ACP_Business_Unit__c = : BU and ACP_Active__c = true and ACP_Analytics_Page__c = : pageNum and Account_Plan_Type__c = : acctPlantype 
   ];
   ACP_Analytics__c analyticsRecord = new ACP_Analytics__c();
   if (analytics.size() > 0) {
   system.debug('hhhh -- ' + analytics[0]);
       analyticsRecord = analytics[0];
   }
   return addIdsToList(analyticsRecord);
  }
 
 
 
 /************************************** BU Admin Changes - Start ***********************************/
 private ACP_Section_Detail__c getACPSectionRec(ACP_Setting__c acpsetting, ID recordtypeid) {
   for (ACP_Section_Detail__c acpS: acpsetting.ACP_Section_Details__r) {
    if (acpS.recordTypeid == recordtypeid) return acps;
   }
   return null;
  }
  /************************************** BU Admin Changes - End ***********************************/
  /**********************************Account Plan Front Edit Code Starts*******************************************************************/
 public PageReference editAccountPlan() {
  PageReference pageref = new PageReference('/apex/ACP_Account_Plan_Edit?retURL=/apex/ACP_Account_Plan_Summary_Page?acpid=' + acpid);
  pageref.getParameters().put('Id', acpId);
  pageref.setRedirect(true);
  return pageref;
 }
 public List < Schema.FieldSetMember > getAcctPlanFields() {
  Map < String, Schema.Fieldset > fieldsetsMap = Schema.SObjectType.ACP_Account_Plan__c.fieldSets.getMap();
  if(accPlanrec != null)
  return fieldsetsMap.get(accPlanrec.ACP_Field_Set_Name__c).getFields();
  else 
  return null;
 }
 public ACP_Section_Detail__c accPlanrec {
  get {
  system.debug('bu setting is : '+ buSetting);
   accPlanrec = ACP_AccountPlan_Helper.getACPSectionRec(buSetting, 'Account Plan Header');
   return accPlanrec;
  }
  set;
 }
 /**********************************Account Plan Front Edit  Code Ends*******************************************************************/
 public pagereference pageRedirectWithDivId(String divId) {
  PageReference savePageRef = new PageReference('/apex/ACP_Account_Plan_Summary_Page?acpId=' + acpId + '#' + divId);
  savePageRef.setRedirect(true);
  return savePageRef;
 }
 public pagereference cancelAddPage() {
   String div = ApexPages.currentPage().getParameters().get('div');

   PageReference savePageRef = new PageReference('/apex/ACP_Account_Plan_Summary_Page?acpId=' + acpId + '#' + div);
   savePageRef.setRedirect(true);
   return savePageRef;
  }
  /***********************************************Tab start************************************************/
  /*This method is used for redirect to other pages from onclicking of main tabs */
 public string Tabpagetoset = '';
 Public Pagereference redirectTabpage() {
  pagereference pr;
  Tabpagetoset = apexpages.currentpage().getparameters().get('tabpage');
  if (Tabpagetoset != null && Tabpagetoset != '') { 
   pr = new pagereference('/apex/' + Tabpagetoset + '?acpId=' + acpId);
   pr.setredirect(true);
  }
  return pr;
 }
 
  public pagereference viewTab() {
      PageReference savePageRef = new PageReference('/apex/ACP_View_Customer_Page?acpId=' + acpId);
      savePageRef.getParameters().put('acpId', acpId);
      savePageRef.setRedirect(true);
      return savePageRef;
   }
   
     public pagereference performanceTab() {
      PageReference savePageRef = new PageReference('/apex/ACP_Performance_Analytics_Page?acpId=' + acpId);
      savePageRef.getParameters().put('acpId', acpId);
      savePageRef.setRedirect(true);
      return savePageRef;
   }
   
    public pagereference summaryTab() {
      PageReference savePageRef = new PageReference('/apex/ACP_Account_Plan_Summary_Page?acpId=' + acpId);
      savePageRef.getParameters().put('acpId', acpId);
      savePageRef.setRedirect(true);
      return savePageRef;
   }
 
}