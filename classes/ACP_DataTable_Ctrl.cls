/***************************************************************************************
Name:ACP_DataTable_Ctrl
Test Class:ACP_DataTable_Ctrl_Test
Copyright © 2017 TE Connectivity
=========================================================================================
Requirement:
Common Controller for the various components 
=========================================================================================
Purpose:
Used in Components.
=========================================================================================
History
-------
Version      Author                Date              Detail
1.0          Alka Kumari           06/05/17          Initial Development
2.0          Ritika Pahwa          06/05/17          Added methods used in components
3.0          Anushka Bansal        06/05/17          Added methods used in components
4.0          Esther Ethelbert      06/05/17          Added methods used in components
****************************************************************************************/
public with sharing class ACP_DataTable_Ctrl {

  ACP_Setting__c buSetting = new ACP_Setting__c();

  public String acpId {
    get;
    set;
  }

  public String userBU {
    get;
    set;
  }

  public ACP_DataTable_Ctrl() {

    buSetting = null;

    acpid = ApexPages.currentPage().getParameters().get('acpId');

    ACP_Account_Plan__c acntPlan = new ACP_Account_Plan__c();

  }

  /************************************************Stakeholder & Relationship - Start */
  public ACP_Section_Detail__c relrec {
    get;
    set;
  }
  public List < ACP_Relationship__c > commonRelationList {
    get {
      if (commonRelationList == null) {
        if (tableType == 'Engineering')
          commonRelationList = engRelationsList;
        if (tableType == 'Purchasing')
          commonRelationList = purRelationsList;
        if (tableType == 'Executive')
          commonRelationList = ExecRelationsList;
      }
      return commonRelationList;
    }
    set;
  }
  public List < ACP_Relationship__c > execRelationsList {
    get;
    set;
  }
  public List < ACP_Relationship__c > purRelationsList {
    get;
    set;
  }
  public List < ACP_Relationship__c > engRelationsList {
    get;
    set;
  }

  public List < ACP_Market_and_Competition__c > admData {
    get;
    set;
  }

  public List < ACP_Opportunity_TAM_Revenue__c > oppTAMList {
    get;
    set;
  }


  public String tableType {
    get;
    set;
  }

  public Boolean disableExecAdd {
    get;
    set;
  }
  public Boolean disablePurAdd {
   get;
    set;
  }
  public Boolean disableEngAdd {
   get;
    set;
  }
  public PageReference addExecRelationship() {
    PageReference pageref = new PageReference('/apex/ACP_AddNewRelationship?acpId=' + acpId);
    pageref.getParameters().put('relationType', tableType);
    pageref.getParameters().put('acpId', acpId);
    if (execRelationsList != null && relrec != null)
      if (execRelationsList.size() == relrec.ACP_No_Reds_Exe_Rel__c - 1)
        pageref.getParameters().put('enableSaveNew', 'true');
    pageref.setRedirect(true);
    return pageref;
  }
  public PageReference addPurRelationship() {
    PageReference pageref = new PageReference('/apex/ACP_AddNewRelationship?acpId=' + acpId);
    pageref.getParameters().put('relationType', tableType);
    pageref.getParameters().put('acpId', acpId);
    if (purRelationsList != null && relrec != null)
      if (purRelationsList.size() == relrec.ACP_Num_of_Rcds_Pur_Rel__c - 1)
        pageref.getParameters().put('enableSaveNew', 'true');

    pageref.setRedirect(true);
    return pageref;
  }
  public PageReference addEnggRelationship() {
    PageReference pageref = new PageReference('/apex/ACP_AddNewRelationship?acpId=' + acpId);
    pageref.getParameters().put('relationType', tableType);
    pageref.getParameters().put('acpId', acpId);
    if (engRelationsList != null && relrec != null)
      if (engRelationsList.size() == relrec.ACP_Num_Rerds_Eng_Rel__c - 1)
        pageref.getParameters().put('enableSaveNew', 'true');
    pageref.setRedirect(true);
    return pageref;
  }
  public void updateEnggRelations() {
    try {
      update engRelationsList;
    }
    Catch(Exception e) { ErrorLogging.Log(e, 'ACP_DataTable_Ctrl', 'updateEnggRelations', acpId); ApexPages.addMessages(e);}
     
  }
  public void updateExecRelations() {
    try {
      update execRelationsList;
    }
    Catch(Exception e) { ErrorLogging.Log(e, 'ACP_DataTable_Ctrl', 'updateExecRelations', acpId); ApexPages.addMessages(e);}
     
  }
  public void updatePurRelations() {
    try {
      update purRelationsList;
    }
    Catch(Exception e) {ErrorLogging.Log(e, 'ACP_DataTable_Ctrl', 'updatePurRelations', acpId); ApexPages.addMessages(e);}
      
  }



  /*********************************Market and Competition****************************************/


  public ACP_Section_Detail__c strrec {
    get;
    set;
  }
  public List < ACP_Market_and_Competition__c > markCompList {
    get;
    set;
  }


  public PageReference addMarketComp() {
    PageReference redirect = new PageReference('/apex/ACP_Add_Market_Competition');
    redirect.getParameters().put('acpId', acpId);
    redirect.setRedirect(true);
    return redirect;
  }



  /****************************Delete******************************************/




  public pagereference addADMMarketComp() {
    PageReference pageref = new PageReference('/apex/ACP_Add_ADM_Market_Competition?');
    pageref.getParameters().put('acpId', acpId);
    pageref.setRedirect(true);
    return pageref;

  }


  public PageReference actionSaveADM() {
    try {
      update admData;
    }
    Catch(Exception e) {ErrorLogging.Log(e, 'ACP_AccountPlan_Page_Controller', 'actionSaveADM', acpId); ApexPages.addMessages(e);}
      
    return null;
  }


  /******************************Market and Competition Summary - End**************************/

  /******************************Customer Overview  - Start**************************/
  public String recordtypenm {
    get;
    set;
  }
  public List < ACP_Customer_Overview__c > customerOverviewSource {
    get;
    set;
  }

  public PageReference actionSave1() {

    try {

      update customerOverviewSource;

    }
    Catch(Exception e) {ErrorLogging.Log(e, 'ACP_DataTable_Ctrl', 'actionSave1', acpId); ApexPages.addMessages(e);}
      
    return null;
  }
  public ACP_Section_Detail__c custrec {
    get;
    set;
  }

  public List < ACP_Strategy__c > strategyList {
    get;
    set;
  }

  public PageReference addStrategies() {
    PageReference redirect = new PageReference('/apex/ACP_Add_Strategy');
    redirect.getParameters().put('acpId', acpId);
    redirect.setRedirect(true);
    return redirect;
  }
  
  
  public PageReference actionSave() {


    try {
    
      update strategyList;
       }
    Catch(Exception e) {  ErrorLogging.Log(e, 'ACP_DataTable_Ctrl', 'actionSave', acpId); ApexPages.addMessages(e);}
    
    return null;
  }


  /**************** Code for delete functionality - End ******************************/

  /******************************Strategy  - End**************************/

  /************************************************Code for Actions detail Page - Start */
  public List < Task > commonTaskListAll {
    get;
    set;
  }
  public PageReference actionSaveAll() {
    try {

      update commonTaskListAll;
    }
    Catch(Exception e) { ErrorLogging.Log(e, 'ACP_DataTable_Ctrl', 'actionSaveAll', acpId); ApexPages.addMessages(e);}
     
      /** ErrorLogging.Log(e,'ACP_DataTable_Ctrl', 'actionSaveAll',commonTaskListAll[0].id);**/
    return null;
  }
  /************************************************Code for Actions detail Page - End */
  /*****************************************************Supplier Evaluation code Starts************************************/
  public List < ACP_TE_Supplier_Evaluation__c > supplierEvaluationList {
    get;
    set;
  }

  public pagereference addSupplierEvaluation() {


    PageReference pageref = new PageReference('/apex/ACP_New_Supplier_Evaluation');
    pageref.getParameters().put('acpId', acpId);
    pageref.setRedirect(true);
    return pageref;
  }
  public PageReference actionSaveEval() {
    try {
      update supplierEvaluationList;
    } catch (Exception e) {ErrorLogging.Log(e, 'ACP_DataTable_Ctrl', 'actionSaveEval', acpId);ApexPages.addMessages(e);}
      
    return null;
  }

  public ACP_Section_Detail__c evalrec {
    get;
    set;
  }


  /*****************************************************Suppliers Rating start**********************************************************/
  public List < ACP_TE_Suppliers_Rating__c > suppliersRatingList {
    get;
    set;
  }
  public pagereference addSuppliersRatings() {
    PageReference pageref = new PageReference('/apex/ACP_New_Suppliers_Rating');
    pageref.getParameters().put('acpId', acpId);
    pageref.setRedirect(true);
    return pageref;

  }
  public PageReference actionSaveRating() {
    try {
      update suppliersRatingList;

    }
    Catch(Exception e) {ErrorLogging.Log(e, 'ACP_AccountPlan_Page_Controller', 'actionSaveRating', acpId);ApexPages.addMessages(e);}

    return null;
  }

  /*****************************************************Suppliers Rating End**********************************************************/

  /**************************** Top Open Opportunities - Start***************/
  public List < ACP_Top_Open_Opportunity__c > topOpenOpportunityList {
    get;
    set;
  }

  public PageReference actionSaveOpenOpps() {
    try {
      update topOpenOpportunityList;

    }
    Catch(Exception e) {ErrorLogging.Log(e, 'ACP_DataTable_Ctrl', 'actionSaveOpenOpps', acpId);ApexPages.addMessages(e);}

    return null;
  }
  public pagereference AddNewTopOpenOpp() {
    PageReference pageref = new PageReference('/apex/ACP_Add_Top_Open_Opp');
    pageref.getParameters().put('acpid', acpId);
    pageref.setRedirect(true);
    return pageref;
  }

  public ACP_Section_Detail__c openOpprec {
    get;
    set;
  }

  /*****************************************************Application Breakdown code End************************************/
  /************************************************TE’s Business Performance - Start */
  public List < ACP_Revenue_Growth_Perf__c > perfList {
    get;
    set;
  }
  public PageReference updatePerformance() {
    try {
      update perfList;
    }
    Catch(Exception e) {ErrorLogging.Log(e, 'ACP_DataTable_Ctrl', 'updatePerformance', acpId); ApexPages.addMessages(e);}
      
    return null;
  }
  /************************************************TE’s Business Performance - End */


  public ACP_Section_Detail__c admMarkrec {
    get;
    set;
  }

  /**************** Code for delete functionality - Start ******************************/
  public string SelectedId {
    get;
    set;
  }

  /**************** Code for Actions detail delete - Start ******************************/
  public integer total_size {
    get {
      if (size != 0)
        total_size = size;
      return total_size;
    }
    set;
  }
  public Integer size = 0;
  public void DeleteActionfromDetail() {

    if (SelectedId == null) {
      return;
    }
    Task tobeDeleted = null;

    for (Integer i = 0; i < commonTaskListAll.size(); i++) {
      if (commonTaskListAll[i].Id == SelectedId) {
        tobeDeleted = commonTaskListAll[i];
        Delete tobeDeleted;
        commonTaskListAll.remove(i);
        break;
      }
    }
  }
  /**************** Code for delete functionality - End ******************************/

  /*****************************************************Application Breakdown code Starts************************************/
  public List < ACP_Application_Breakdown__c > applicationBreakdownList {
    get;
    set;
  }
  public String opptyId {get; set;}
  public List < ACP_Application_Breakdown__c > getappBreakdownList() {
   List < ACP_Application_Breakdown__c > appbrkList = new List < ACP_Application_Breakdown__c >();
    for(ACP_Application_Breakdown__c appList : applicationBreakdownList )
    {
    if(appList.ACP_Opportunity_Name__c == opptyId )
    appbrkList.add(appList);
    }
    return appbrkList;
  }
  
  
  public Integer count {
    get;
    set;
  }
  
  
  public pagereference addApplicationBreakdown() {


    PageReference pageref = new PageReference('/apex/ACP_Add_AppBrkdown');
    pageref.getParameters().put('acpId', acpId);
    pageref.setRedirect(true);
    return pageref;
  }
  public PageReference actionSaveAppBreakdown() {
    try {
      update applicationBreakdownList;
    } catch (Exception e) { ErrorLogging.Log(e, 'ACP_DataTable_Ctrl', 'actionSaveAppBreakdown', acpId); ApexPages.addMessages(e);}
  
    return null;
  }

  public ACP_Section_Detail__c appBrkrec {
    get;
    set;
  }

  /*****************************************************Application Breakdown code End************************************/
  /*******************************************Application Breakdown Delete ****************************/
  public string SelectedAppBrkId {
    get;
    set;
  }
  public void DeleteAppBrkdown() {


    if (SelectedAppBrkId == null) {
      return;
    }
    ACP_Application_Breakdown__c appBrkTobeDeleted = null;

    for (Integer i = 0; i < applicationBreakdownList.size(); i++) {
      if (applicationBreakdownList[i].Id == SelectedAppBrkId) {
        appBrkTobeDeleted = applicationBreakdownList[i];
        Delete appBrkTobeDeleted;
        applicationBreakdownList.remove(i);
        break;
      }
    }
  }
 
  /***********************Stakeholder Delete for Executive - Start************************/
  public string SelectedExecId {
    get;
    set;
  }
  public void DeleteExecRel() {
    if (SelectedExecId == null) {
      return;
    }
    ACP_Relationship__c tobeDeleted = null;

    for (Integer i = 0; i < execRelationsList.size(); i++) {
      if (execRelationsList[i].Id == SelectedExecId) {
        tobeDeleted = execRelationsList[i];
        Delete tobeDeleted;
        execRelationsList.remove(i);
        break;
      }
    }
  }
  /*************************Stakeholder Delete for Executive - End************************/
  /*************************Stakeholder Delete for Purchasing - Start************************/
  public string SelectedPurId {
    get;
    set;
  }
  public void DeletePurRel() {

    if (SelectedPurId == null) {
      return;
    }
    ACP_Relationship__c tobeDeleted = null;


    for (Integer i = 0; i < purRelationsList.size(); i++) {
      if (purRelationsList[i].Id == SelectedPurId) {
        tobeDeleted = purRelationsList[i];
        Delete tobeDeleted;
        purRelationsList.remove(i);
        break;
      }
    }
  }
  /*************************Stakeholder Delete for Purchasing - End************************/
  /*************************Stakeholder Delete for Engineering - Start************************/
  public string SelectedEngId {
    get;
    set;
  }
  public void DeleteEngRel() {

    if (SelectedEngId == null) {
      return;
    }
    ACP_Relationship__c tobeDeleted = null;

    for (Integer i = 0; i < engRelationsList.size(); i++) {
      if (engRelationsList[i].Id == SelectedEngId) {
        tobeDeleted = engRelationsList[i];
        Delete tobeDeleted;
        engRelationsList.remove(i);
        break;
      }
    }
  }



  /****************************Delete Market Summary******************************************/
  public string admId {
    get;
    set;
  }
  public void DeleteADM() {
    if (admId == null) {
      return;
    }

    ACP_Market_and_Competition__c toDeleteAdm = null;
    for (Integer i = 0; i < admData.size(); i++) {
      if (admData[i].Id == admId) {
        toDeleteAdm = admData[i];
        Delete toDeleteAdm;
        admData.remove(i);
        break;
      }
    }
  }
  /**************** Code for strategy delete functionality - Start ******************************/
  public string StrategyId {
    get;
    set;
  }
  public void DeleteStr() {
    if (StrategyId == null) {
      return;
    }
    ACP_Strategy__c toDeleted = null;
    for (Integer i = 0; i < strategyList.size(); i++) {
      if (strategyList[i].Id == StrategyId) {
        toDeleted = strategyList[i];
        Delete toDeleted;
        strategyList.remove(i);
        break;
      }
    }
  }

  /*********************Code for Supplier Rating delete **********************************/
  public string SelectedRatingId {
    get;
    set;
  }
  public void DeleteRating() {

    if (SelectedRatingId == null) {
      return;
    }
    ACP_TE_Suppliers_Rating__c ratingTobeDeleted = null;
    for (Integer i = 0; i < suppliersRatingList.size(); i++) {
      if (suppliersRatingList[i].Id == SelectedRatingId) {
        ratingTobeDeleted = suppliersRatingList[i];
        Delete ratingTobeDeleted;
        suppliersRatingList.remove(i);
        break;
      }
    }
  }

  /******************************************* Top OPen Opp Delete ****************************/
  public string SelectedOpenOppId {
    get;
    set;
  }

  public void DeleteOpenOpp() {

    if (SelectedOpenOppId == null) {
      return;
    }
    ACP_Top_Open_Opportunity__c OpenOppTobeDeleted = null;
    for (Integer i = 0; i < topOpenOpportunityList.size(); i++) {
      if (topOpenOpportunityList[i].Id == SelectedOpenOppId) {
        OpenOppTobeDeleted = topOpenOpportunityList[i];
        Delete OpenOppTobeDeleted;
        topOpenOpportunityList.remove(i);
        break;
      }
    }

  }

  /******************************************* Supplier Evaluation Delete ****************************/
  public string SelectedEvalId {
    get;
    set;
  }
  public void DeleteEvaluation() {

    if (SelectedEvalId == null) {
      return;
    }
    ACP_TE_Supplier_Evaluation__c EvalTobeDeleted = null;

    for (Integer i = 0; i < supplierEvaluationList.size(); i++) {
      if (supplierEvaluationList[i].Id == SelectedEvalId) {
        EvalTobeDeleted = supplierEvaluationList[i];
        Delete EvalTobeDeleted;
        supplierEvaluationList.remove(i);
        break;
      }
    }

  }

  /**************** Code for delete functionality For Customer Overview- Start ******************************/

 
  public string customerId {
    get;
    set;
  }
  public void DeleteCust() {
    if (customerId == null) {
      return;
    }
    ACP_Customer_Overview__c toDeletethat = null;
    for (Integer i = 0; i < customerOverviewSource.size(); i++) {
      if (customerOverviewSource[i].Id == customerId) {
        toDeletethat = customerOverviewSource[i];
        Delete toDeletethat;
        customerOverviewSource.remove(i);
        break;
      }
    }
  }
  
  /****************Code for delete functionality For Customer Overview  - End ******************************/

}