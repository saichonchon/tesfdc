/***************************************************************************************
Name:ACP_Performance_Analytics_ctrl
Test Class:ACP_Perf_Analytics_Report_Ctrl_Test,ACP_Performance_Analytics_ctrl_Test
Copyright © 2017 TE Connectivity
========================================================================================
Requirement:
Controller for Performance and analytic tab.
========================================================================================
Purpose:
Used for performance analytics functionality.
=========================================================================================
History
-------
Version      Author                     Date              Detail
1.0          Esther Ethelbert           04/25/17          Initial Development
2.0          Ritika Pahwa               04/25/17          Added methods used in page
3.0          Anushka Bansal             04/25/17          Added methods used in page
4.0          Alka Kumari                04/25/17          Added methods used in page
****************************************************************************************/
public with sharing class ACP_Performance_Analytics_ctrl {

 private ApexPages.StandardController controller;
 ACP_Setting__c buSetting = new ACP_Setting__c();
 public Boolean editMode {
  get;
  set;
 }

 public List < ACP_Account_Plan__c > accDet;
 
 public String div {
  get;
  set;
 }

 public ACP_Account_Plan__c Record {
  get;
  set;
 }
 private final ACP_Account_Plan__c Act;
 public Boolean readonly {
  get;
  set;
 }
 private final ACP_Account_Plan__c acctPlan ;
 public String acpId {
  get;
  set;
 }
 /*****************for Market & Competition *************************/
 /*public ACP_Market_and_Competition__c Mark {
  get;
  set;
 }*/
 ACP_Market_and_Competition__c MarkComp = new ACP_Market_and_Competition__c();

 public string macid {
  get;
  set;
 }

 
 List < String > cbc1Arry = new List < String > ();
 List < String > cbc2Arry = new List < String > ();
 List < String > cbc3Arry = new List < String > ();
 public List < ACP_Market_and_Competition__c > admMarkCompList {
  get;
  set;
 }
  public List < ACP_Market_and_Competition__c > admData {
   get;
   set;
  } 
   public List < ACP_Opportunity_TAM_Revenue__c > oppTAMList{
    get;
    set;
  }
 
 public List < ACP_Market_and_Competition__c > admMarkList = new List<ACP_Market_and_Competition__c>();
public List < ACP_Market_and_Competition__c > markCompList {
    get;
    set;
  }


 public string acpCBC {
  get;
  set;
 }

 List < selectOption > options = new List < selectOption > ();
 List < selectOption > optionsCBC1 = new List < selectOption > ();
 List < selectOption > optionsCBC2 = new List < selectOption > ();
 List < selectOption > optionsCBC3 = new List < selectOption > ();
 list < Product_Hierarchy__c > prodHier = new list < Product_Hierarchy__c > ();
 list < AggregateResult > cbc1Desc = new list < AggregateResult > ();
 list < AggregateResult > cbc2Desc = new list < AggregateResult > ();
 list < AggregateResult > cbc3Desc = new list < AggregateResult > ();
 list < AggregateResult > yearbbList = new list < AggregateResult > ();
  Product_Hierarchy__c cbcDesc1Query;
  Product_Hierarchy__c cbcDesc2Query;
  Product_Hierarchy__c cbcDesc3Query;
  private String whereQuery;
 public string cbc1Value {
  get;
  set;
 }
 public string cbc2Value {
  get;
  set;
 }
 public string cbc3Value {
  get;
  set;
 }
 public List < selectOption > getCBC1 {
  get;
  set;
 }
 public List < selectOption > getCBC2 {
  get;
  set;
 }
 public List < selectOption > getCBC3 {
   get;
   set;
  }

  /*************************************to get CBC End****************************************/

 //=====Raju created for Account Header -Start==========================================
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
 //====created for Account Header -end==================================================

 /****************************** Business Performance*********************************/

/*****************************Chart Commented Code Start 1 *********************************************************/

 public String chartMessage {
  get;
  set;
 }


/*****************************Chart Commented Code End 1*********************************************************/


 public ACP_Section_Detail__c accPlanrec {
  get {
   accPlanrec = ACP_AccountPlan_Helper.getACPSectionRec(buSetting, 'Account Plan Header');
   return accPlanrec;
  }
  set;
 }
 
        
 public ACP_Performance_Analytics_ctrl() {
  accDet = new List < ACP_Account_Plan__c > ();
  acpid = ApexPages.currentPage().getParameters().get('acpId');

  macid = ApexPages.currentPage().getParameters().get('macId');


  try {
   if (macid != null && macid != '') {

    MarkComp = [select id, name, ACP_Product_Cbc__c, ACP_CBC1__c, ACP_CBC1_Description__c,ACP_CBC2_Description__c ,ACP_CBC3_Description__c , ACP_TAM_LY_Bill__c, ACP_TAM_CYRR__c, ACP_TAM__c, ACP_PAM__c, ACP_TAM_NY_Fcst__c, ACP_SAM__c, ACP_Main_Competitor__c, ACP_NY_Fcst__c, ACP_TE_Position__c, ACP_Main_Competitor_Share__c from ACP_Market_and_Competition__c where id = : macid];

   }
  } catch (DMLException e) {ErrorLogging.Log(e, 'ACP_Performance_Analytics_Ctrl', 'ACP_Performance_Analytics_Ctrl', '');ApexPages.addMessages(e);}
   
 
  try {
   record = [select ACP_GAMCode__c, ACP_KAMCode__c, ACP_Account_Name__c, ACP_WWAcNo__c,Account_Plan_Type__c , ACP_Customer_Strategy_Summary__c, ACP_Customer_Major_Growth_Areas__c, ACP_Customer_Challenges_and_Threats__c, TE_Business_Performance_Comment__c from ACP_Account_Plan__c where id = : acpId];
  } catch (Exception e) {ErrorLogging.Log(e, 'ACP_Performance_Analytics_ctrl', 'ACP_Performance_Analytics_ctrl', acpId);ApexPages.addMessages(e);}
   
   
 userBU = [Select GIBU__c, DefaultCurrencyIsoCode From User Where Id = : UserInfo.getUserId()][0].GIBU__c;
  
  
  buSetting = ACP_AccountPlan_Helper.getACPSettingsRecord(userBU, record.Account_Plan_Type__c );
  if (buSetting == null)
   buSetting = ACP_AccountPlan_Helper.getACPSettingsRecord('','');



  getTopOpenOppsList();
  marketCompetitionList();
  admMarketCompetitionList();
   opportunityTAMList();
  
//acctPlan = (ACP_Account_Plan__c) controller.getRecord();
  
 }
/*****************************Chart Commented Code Start 2*********************************************************/

 /*********************************************Chart Commented Code End 2*********************************************************************/
 
 public ACP_Performance_Analytics_ctrl(ApexPages.StandardController controller) {

  acpId = ApexPages.currentPage().getParameters().get('acpId');
  setCategoryWiseTask();
  readonly = true;
  editmode = false;

  acctPlan = (ACP_Account_Plan__c) controller.getRecord();
  try {
   record = [select ACP_GAMCode__c, ACP_KAMCode__c, ACP_Account_Name__c, ACP_WWAcNo__c,Account_Plan_Type__c , ACP_Customer_Strategy_Summary__c, ACP_Customer_Major_Growth_Areas__c, ACP_Customer_Challenges_and_Threats__c, TE_Business_Performance_Comment__c from ACP_Account_Plan__c where id = : acpId];
  } catch (Exception e) {ErrorLogging.Log(e, 'ACP_Performance_Analytics_ctrl', 'ACP_Performance_Analytics_ctrl', acpId);ApexPages.addMessages(e);}
    

  userBU = [Select GIBU__c, DefaultCurrencyIsoCode From User Where Id = : UserInfo.getUserId()][0].GIBU__c;
 
  //userBU = [Select GIBU__c From User Where Id = : UserInfo.getUserId()][0].GIBU__c;
 // if (userBU != null)
   buSetting = ACP_AccountPlan_Helper.getACPSettingsRecord(userBU, record.Account_Plan_Type__c );
    if (buSetting == null)
  {
   buSetting = ACP_AccountPlan_Helper.getACPSettingsRecord('','');

}


 
  marketCompetitionList();
  admMarketCompetitionList();
  opportunityTAMList();
  this.Act = (ACP_Account_Plan__c) controller.getRecord();
  this.controller = controller;
  getTopOpenOppsList();
  accountPlanHeader();
  getAppBrkdownList();
  isNext = true;

  //==to get account plan header informaton (account plan fieds,summmary ,Products)from helper class =Raju===
  headerAcctPlanFields = ACP_AccountPlan_Helper.getAcctPlanFields(buSetting, 'Account Plan Header');

  accountPlantHeaderRec = ACP_AccountPlan_Helper.acctPlanHeaderRec(acpId);

  accountPlanEvenRowImagesProd = ACP_AccountPlan_Helper.evenRowImagesProd;
  accountPlanOddRowImagesProd = ACP_AccountPlan_Helper.oddRowImagesProd;
  accountPlancompanyLogoId = ACP_AccountPlan_Helper.companyLogoId;
  accountPlanmanagerImgId = ACP_AccountPlan_Helper.managerImgId;
  try {
   accountPlanDet = ACP_AccountPlan_Helper.getAccPlan(accplanrec.ACP_Field_Set_Name__c, acpId);
  } catch (Exception e) { ErrorLogging.Log(e, 'ACP_Performance_Analytics_ctrl', 'ACP_Performance_Analytics_ctrl', acpId); ApexPages.addMessages(e);}
     

  //=====end== 
  
  /*****************************Chart Commented Code Start 3*********************************************************/
 
 /*****************************Chart Commented Code End 3*********************************************************/
 
 }




 Public void accountPlanHeader() {
  try {

   AccDet = [select id, ACP_Account_Name__r.id, ACP_Account_Manager__c, ACP_Account_Summary__c, ACP_Account_Name__r.name, ACP_Account_Name__r.AccountNumber, ACP_Account_Name__r.Description, ACP_Account_Name__r.Website
    from ACP_Account_Plan__c where id = : acpId
   ];
   


  } catch (DMLException e) {ErrorLogging.Log(e, 'ACP_Performance_Analytics_Ctrl', 'accountPlanHeader', acpId); ApexPages.addMessages(e);}
   
  
  
 }

 /**************************************************For edit *************************************************************************/

 public void inlineedit() {
  readonly = false;
  editmode = true;
 }
 public void saveSummary() {
  try {
   update record;
   readonly = true;
   editmode = false;
  } catch (Exception e) { ErrorLogging.Log(e, 'ACP_AccountPlan_Page_Controller', 'saveSummary', acpId); ApexPages.addMessages(e);
   
   //return null;
  }
 // return null;
 }
 public void cancelSummary() {
   readonly = true;
   editmode = false;
 //  return null;
  }
  /***********************************************Display tables ****************************************************/

/* Common method to redirect the main page */
 public pagereference masterPageRedirection() {

  STRING Tabpagetoset = apexpages.currentpage().getparameters().get('tabpage');
  PageReference pr = new pagereference('/apex/' + Tabpagetoset + '?acpId=' + acpId);
  pr.setredirect(true);
  return pr;
 }
// ACP_Market_and_Competition__c MarkComp = new ACP_Market_and_Competition__c();
 Public ACP_Market_and_Competition__c getmarkComp() {
  return markComp;
 }
 ACP_Market_and_Competition__c ADMMarkComp = new ACP_Market_and_Competition__c();
 Public ACP_Market_and_Competition__c getadmMarkComp() {
  return admMarkComp;
 }

 Id markCompRecordTypeId = Schema.SObjectType.ACP_Market_and_Competition__c.getRecordTypeInfosByName().get('General Market and Competition').getRecordTypeId();
 Id admMarkCompRecordTypeId = Schema.SObjectType.ACP_Market_and_Competition__c.getRecordTypeInfosByName().get('ADM Market and Competition').getRecordTypeId();



 /*******************************************Call the Page to Edit Account Plan*************************************/
 public PageReference editAccountPlan() {
  PageReference pageref = new PageReference('/apex/ACP_Account_Plan_Edit?retURL=/apex/ACP_Performance_Analytics_Page?acpid=' + acpid);
  pageref.getParameters().put('Id', acpId);
  pageref.setRedirect(true);
  return pageref;
 }
    Map<string,string>CBC1DescriptionMap=new Map<string,string>();
    Map<string,string>CBC2DescriptionMap=new Map<string,string>();
    Map<string,string>CBC3DescriptionMap=new Map<string,string>();
    String CBC1Description;
    String CBC2Description;
    String CBC3Description;
    public Map<String,String> cbcValueMap = new Map<String,String>();
   
 /*To get the picklist valuse for CBC1 */
 Public List < selectOption > getCBC1() {
        
        cbc1Desc = [select CBC1__c, CBC1_Description__c from Product_Hierarchy__c Group by CBC1__c, CBC1_Description__c];
        optionsCBC1.clear();
        optionsCBC1.add(new SelectOption('', 'Select'));
        
        for (AggregateResult c1: cbc1Desc) {
            
            string cbc1 = (string) c1.get('CBC1_Description__c');
            string cbc1Code = (string) c1.get('CBC1__c'); 
            String cbc1Val = cbc1Code + '--' + cbc1;
           
            if (cbc1 != null && cbc1 != ''){
                CBC1DescriptionMap.put(cbc1Code,cbc1);
                optionsCBC1.add(new selectOption(cbc1Val, cbc1)); 
            }
        }
        return optionsCBC1;
        
    }
/*To get the picklist valuse for CBC2 */
 Public List < selectOption > getCBC2() {
        
        if (cbc1Value != null && cbc1Value != '') {
            CBC1Description=CBC1DescriptionMap.get(cbc1Value.substringBefore('--'));
            cbc2Desc = [SELECT CBC2__c, CBC2_Description__c FROM Product_Hierarchy__c WHERE CBC1_Description__c =:CBC1Description Group by CBC2__c, CBC2_Description__c];
            optionsCBC2.clear();
            optionsCBC2.add(new SelectOption('', 'Select'));
            for (AggregateResult c2: cbc2Desc) {
                string cbc2 = (string) c2.get('CBC2_Description__c');
                string cbc2Code = (string) c2.get('CBC2__c');                
                String cbc2Val = cbc2Code + '--' + cbc2;
                if (cbc2 != null && cbc2 != ''){  
                    CBC2DescriptionMap.put(cbc2Code,cbc2);
                    optionsCBC2.add(new selectOption(cbc2Val, cbc2));
                }
            }
        }
    
        return optionsCBC2;
        
    }
/*To get the picklist valuse for CBC3 */
Public List < selectOption > getCBC3() {
        
        if (cbc2Value != null && cbc2Value != '') {
            CBC2Description=CBC2DescriptionMap.get(cbc2Value.substringBefore('--'));
            CBC1Description=CBC1DescriptionMap.get(cbc1Value.substringBefore('--'));
            cbc3Desc = [SELECT CBC3__c, CBC3_Description__c FROM Product_Hierarchy__c WHERE CBC2_Description__c =:CBC2Description and CBC1_Description__c =:CBC1Description Group by CBC3__c, CBC3_Description__c];
            optionsCBC3.clear();
            optionsCBC3.add(new SelectOption('', 'Select'));
            
            for (AggregateResult c3: cbc3Desc) {
                string cbc3 = (string) c3.get('CBC3_Description__c');
                string cbc3Code = (string) c3.get('CBC3__c');
                String cbc3Val = cbc3Code + '--' + cbc3;
                
                if (cbc3 != null && cbc3 != ''){
                    CBC3DescriptionMap.put(cbc3Code,cbc3);
                    optionsCBC3.add(new selectOption(cbc3Val, cbc3));
                }
            }
        }
     
        return optionsCBC3;
    }
 /* BU setting for Market and Competition Detail */
 public ACP_Section_Detail__c markrec {
  get {
  markrec = ACP_AccountPlan_Helper.getACPSectionRec(buSetting, 'Market and Competition');
   return markrec;
  }
  set;

 }


 /******************************************* To get record for Market and Competition Detail - Start *****************************************************/
  public List < Schema.FieldSetMember > getMarkFields() {
    Map < String, Schema.Fieldset > fieldsetsMapMark = Schema.SObjectType.ACP_Market_and_Competition__c.fieldSets.getMap();
    if (Markrec != null) {

      return fieldsetsMapMark.get(markrec.ACP_Field_Set_Name__c).getFields();

    } else
      return SObjectType.ACP_Market_and_Competition__c.FieldSets.ACP_Market_Competition_Fieldset.getFields();
  }

  public List < ACP_Market_and_Competition__c > getMarketData(String sortOrder, String acpId, Decimal noOfRecords) {

    try {
      String queryMark = 'SELECT ';
      for (Schema.FieldSetMember markVar: this.getMarkFields()) {
        queryMark += markVar.getFieldPath() + ',';
      }
    /* Fields in Fieldset are used to control the display in UI. Other required fields are fetched separately & they are not part of the fieldset. Adding these required fields like Id, Parent Id to fieldset will result in an error.  */

      queryMark += 'Id,RecordTypeId ,ACP_CBC__c,ACP_LY_Bill__c,ACP_LY_YTD__c,ACP_CY_YTD__c,ACP_TAM_CYRR__c,ACP_TAM_LY_Bill__c,ACP_TAM_NY_Fcst__c,ACP_TAM__c,ACP_PAM__c,ACP_SAM__c,ACP_Market_Share_TAM__c,ACP_Market_Share_TAMLY__c FROM ACP_Market_and_Competition__c where ACP_Account_Plan__c = ';
      queryMark += ':acpId and RecordTypeId = :markCompRecordTypeId';
      if (sortOrder != null)
        queryMark += ' order by ' + sortOrder;
      if (noOfRecords != null)
        queryMark += ' limit ' + noOfRecords;
      else
        queryMark += ' limit 10';
      return Database.query(queryMark);

    } catch (Exception e) { ErrorLogging.Log(e, 'ACP_Performance_Analytics_ctrl', 'getMarketData', acpid); ApexPages.addMessages(e); return null;
     
     
    }

  }

  public List < ACP_Market_and_Competition__c > markList = new List < ACP_Market_and_Competition__c > ();
  public void marketCompetitionList() {
    try {

      markCompList = new List < ACP_Market_and_Competition__c > ();
      markList = getmarketData(markrec.Default_Sort_Order__c, acpId, markrec.ACP_No_Of_Records__c);
      if (markList.size() > 0) {
        for (ACP_Market_and_Competition__c markVar: markList) {
          if (markVar.RecordTypeId == markCompRecordTypeId)
            markCompList.add(markVar);
         }
      }
    }
    Catch(Exception e) { ErrorLogging.Log(e, 'ACP_Performance_Analytics_ctrl', 'admMarketCompetitionList', acpId); ApexPages.addMessages(e);}
  }


  /******************************************* To get record for Market and Competition Detail - End *****************************************************/
  
 /************************************Call ACP_Add_market_Competition page to add records*********************************************/
 public PageReference addMarketComp() {
  PageReference redirect = new PageReference('/apex/ACP_Add_Market_Competition');
  redirect.getParameters().put('acpId', acpId);
  redirect.setRedirect(true);
  return redirect;
 }

 /********************Delete Market Competition**************************/
 public string MarkId { get; set; }
   public void DeleteMark(){
        if (MarkId == null) {
         return;
        }
       
        ACP_Market_and_Competition__c toDeleteMark = null;
       
        for(Integer i = 0; i< markCompList.size() ; i++)
        {
            if (markCompList[i].Id == MarkId ) {
                toDeleteMark = markCompList[i];
                Delete toDeleteMark;
                markCompList.remove(i);
                break;
            }
        }
      }
 
 
/*******************************************Logic to run the report and get Yearly BBB values**************************************/
public void YBBReportValue() {
    try{
    List < String > productArry = new List < String > ();
    String CBCType;
    String CBCValue;
    String accountId;
    String code;
//getting the value of CBC to pass as a parameter to run the report
    
    string strConc1;
    string strConc2;
    string strConc3;
     
    if (cbc3Value != null) {
        CBCType = 'CBC3';
        CBCValue=cbc3Value.substringBefore('--'); 
        CBC3Description=CBC3DescriptionMap.get(cbc3Value.substringBefore('--'));
        strConc3 = CBCType + ' - ' + cbc3Value.substringBefore('--') + ' - ' + CBC3Description;
    }  else if (cbc2Value != null) {
        CBCType = 'CBC2';
        CBCValue=cbc2Value.substringBefore('--');
        strConc2= CBCType + ' - ' + cbc2Value.substringBefore('--') + ' - ' + CBC2Description;
    } 
     else if (cbc1Value != null){
        CBCType = 'CBC1';
        CBCValue=cbc1Value.substringBefore('--');
        strConc1 =CBCType + ' - ' + cbc1Value.substringBefore('--') + ' - ' + CBC1Description;
    }   
    accountId = record.ACP_Account_Name__c;
        
    if (record.Account_Plan_Type__c == 'GAM Account') {
        code = record.ACP_GAMCode__c;
    
    } else if (record.Account_Plan_Type__c == 'KAM Account') {
        code = record.ACP_KAMCode__c;
    } else if (record.Account_Plan_Type__c == 'WW Account') {
        code = record.ACP_WWAcNo__c;
    } else if (record.Account_Plan_Type__c == 'Sold-to Account') {
        code = accountId;
    }

  
String markReportName = 'ACP_Yearly_Billing_Report';
Reports.ReportFactWithDetails factDetails;
  
    if (markReportName != null) {
    factDetails = ACP_Opportunity_Data_Automation_Ctrl.marketRunReport(CBCType, CBCValue, record.Account_Plan_Type__c, code, accountId, markReportName);    
     }
    
        Markcomp.ACP_LY_Bill__c = (Decimal)factDetails.getAggregates()[0].getValue(); // Store the values in fields at the time of adding/Editing the records
        Markcomp.ACP_CY_YTD__c = (Decimal)factDetails.getAggregates()[1].getValue();
        Markcomp.ACP_LY_YTD__c = (Decimal)factDetails.getAggregates()[2].getValue();
        
        if (cbc3Value != null) {
            Markcomp.ACP_CBC__c = strConc3;
            Markcomp.ACP_CBC3__c = cbcValueMap.get('CBC3');
            Markcomp.ACP_CBC3_Description__c = CBC3Description;
            Markcomp.ACP_CBC2_Description__c = CBC2Description;
            Markcomp.ACP_CBC1_Description__c = CBC1Description;
        } else if (cbc2Value != null) {
            Markcomp.ACP_CBC__c = strConc2;
            Markcomp.ACP_CBC2__c = cbcValueMap.get('CBC2');
            Markcomp.ACP_CBC3_Description__c = '';
            Markcomp.ACP_CBC2_Description__c = CBC2Description;
            Markcomp.ACP_CBC1_Description__c = CBC1Description;
        } else {
            Markcomp.ACP_CBC__c = strConc1;
            Markcomp.ACP_CBC1__c = cbcValueMap.get('CBC1');
            Markcomp.ACP_CBC3_Description__c = '';
            Markcomp.ACP_CBC2_Description__c = '';
            Markcomp.ACP_CBC1_Description__c = CBC1Description;
        }
   // }
    } catch (Exception e) { ErrorLogging.Log(e, 'ACP_Performance_Analytics_ctrl', 'YBBReportValue', acpId);ApexPages.addMessages(e);}
        
      }
/******************Inline editing for Market and Competition*********************************************/
public PageReference actionSaveMark() {
    try {
        update MarkCompList;
        return pageRedirectWithDivId('MrktCompDetail');
    }    Catch(Exception e) { ErrorLogging.Log(e, 'ACP_Performance_Analytics_ctrl', 'actionSaveMark', acpId); ApexPages.addMessages(e);}
       
    return null;
}
 /*******************************Save for adding Market and Competition records*************************************/
 public void saveCommonMark() {
    boolean flag = false;
    if (acpId != null) {
        markComp.RecordTypeId = MarkCompRecordTypeId;
        markComp.ACP_Account_Plan__c = acpId;

        YBBReportValue();
        try {
            upsert markComp;
        } catch (DMLException e) {ErrorLogging.Log(e, 'ACP_Performance_Analytics_ctrl', 'saveCommonMark', acpId); ApexPages.addMessages(e);}
            
        
    }
}

/*******************************Save for adding Market and Competition records*************************************/
 public PageReference saveMarkComp() {
    if (cbc1Value == null) {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please enter CBC Description'));
        return null;
    } else {
        saveCommonMark();
        return pageRedirectWithDivId('MrktCompDetail');
    }
}

 public pagereference pageRedirectWithDivId(String divId) {
  PageReference savePageRef = new PageReference('/apex/ACP_Performance_Analytics_page?acpId=' + acpId + '#' + divId);
  savePageRef.setRedirect(true);
  return savePageRef;
 }
/* Method to cancel the page */
 public pagereference cancelAddPage() {
  String div = ApexPages.currentPage().getParameters().get('div');

  PageReference savePageRef = new PageReference('/apex/ACP_Performance_Analytics_page?acpId=' + acpId + '#' + div);
  savePageRef.setRedirect(true);
  return savePageRef;
 }
/* Method to redirect to the page */
 public pagereference pageRedirect() {
  div = '';

  PageReference savePageRef = new PageReference('/apex/ACP_Performance_Analytics_page?acpId=' + acpId);
  savePageRef.setRedirect(true);
  return savePageRef;
 }
/*******************************Save and New for adding Market and Competition records*************************************/
 public PageReference saveAndNewMark() {
  if (cbc1Value == null) {
   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please enter CBC'));
   return null;
  } else {
   saveCommonMark();

   PageReference pagerefSN = new PageReference('/apex/ACP_Add_Market_Competition?saveURL=/apex/ACP_Performance_Analytics_Page?acpId=' + acpId);
   pagerefSN.getParameters().put('acpId', acpId);
   pagerefSN.setRedirect(true);
   return pagerefSN;
  }
 }

/* Bu Admin setting for Opportunity TAM VS Revenue*/
 public ACP_Section_Detail__c oppTAMrec {
  get {
   oppTAMrec = ACP_AccountPlan_Helper.getACPSectionRec(buSetting, 'Opportunity TAM Revenue');
   return oppTAMrec;
  }
  set;

 }
 
 /*************************************get Opp TAM Fields*****************************************************************************/
public List < Schema.FieldSetMember > getOppFields() {
   Map<String, Schema.Fieldset> fieldsetsMapOpp = Schema.SObjectType.ACP_Opportunity_TAM_Revenue__c.fieldSets.getMap();
    if(oppTAMrec!= null){
        
          system.debug('opp tem '+ oppTAMrec.ACP_Field_Set_Name__c);
         return fieldsetsMapOpp.get(oppTAMrec.ACP_Field_Set_Name__c).getFields();
         
   }
   else
    return SObjectType.ACP_Opportunity_TAM_Revenue__c.FieldSets.ACP_Opp_TAM_Revenue_Fieldset.getFields();       
    } 

public List < ACP_Opportunity_TAM_Revenue__c > getOppTAMData(String sortOrder, String acpId, Decimal noOfRecords)
   {
        try
      {
         String queryOpp = 'SELECT ';
         for (Schema.FieldSetMember oppVar: this.getOppFields())
         {
            queryOpp += oppVar.getFieldPath() + ',';
         }
         /* Fields in Fieldset are used to control the display in UI. Other required fields are fetched separately & they are not part of the fieldset. Adding these required fields like Id, Parent Id to fieldset will result in an error.  */
          queryOpp += 'Id,ACP_Product__r.Name,ACP_CBC__c,ACP_TAM__c,ACP_TAM_CY__c,ACP_TAM_NY__c,ACP_TAM_LY_Bill__c FROM ACP_Opportunity_TAM_Revenue__c where ACP_Account_Plan__c = ';
         queryOpp += ':acpId';
         if(sortOrder !=null )
        queryOpp +=' order by '+sortOrder;
        if(noOfRecords!= null)
        queryOpp +=' limit '+noOfRecords;
        else
        queryOpp +=' limit 10';
         return Database.query(queryOpp);
      }
      catch (Exception e){ ErrorLogging.Log(e, 'ACP_Performance_Analytics_ctrl', 'getOppTAM', acpid);ApexPages.addMessages(e);   return null;}
      
   }

 
   public void opportunityTAMList() {
    try {
        oppTAMList = new List < ACP_Opportunity_TAM_Revenue__c > ();
        oppTAMList = getOppTAMData(oppTAMrec.Default_Sort_Order__c, acpId, oppTAMrec.ACP_No_Of_Records__c);
    }
    Catch(Exception e) {
        ErrorLogging.Log(e, 'ACP_Performance_Analytics_ctrl', 'opportunityTAMList', acpId);
        ApexPages.addMessages(e);
    }
}

 Id admMarkCompRecTypeId = Schema.SObjectType.ACP_Section_Detail__c.getRecordTypeInfosByName().get('Market and Competition Summary').getRecordTypeId();
 public ACP_Section_Detail__c admMarkrec {
  get {
   admMarkrec = ACP_AccountPlan_Helper.getACPSectionRec(buSetting, 'Market and Competition Summary');
   return admMarkrec;
  }
  set;

 }
/* To get record for Market and Competition Summary*/
 public List < Schema.FieldSetMember > getADMFields() {
 Map < String, Schema.Fieldset > fieldsetsMapADM = Schema.SObjectType.ACP_Market_and_Competition__c.fieldSets.getMap();
  if (admMarkrec != null) {
 return fieldsetsMapADM.get(admMarkrec.ACP_Field_Set_Name__c).getFields();
  
  } else
   return SObjectType.ACP_Market_and_Competition__c.FieldSets.ACP_ADM_Fieldset.getFields();
 }

 public List < ACP_Market_and_Competition__c > getADMData(String sortOrder, String acpId, Decimal noOfRecords) {
try {
   String queryAdm = 'SELECT ';
   for (Schema.FieldSetMember admVar: this.getADMFields()) {
   queryAdm += admVar.getFieldPath() + ',';
     }
     /* Fields in Fieldset are used to control the display in UI. Other required fields are fetched separately & they are not part of the fieldset. Adding these required fields like Id, Parent Id to fieldset will result in an error.  */
   queryAdm += 'Id,recordtype.name,recordtype.id FROM ACP_Market_and_Competition__c where ACP_Account_Plan__c = ';
   queryAdm += ':acpid and RecordTypeId = :admMarkCompRecordTypeId';
   if (sortOrder != null)
    queryAdm += ' order by ' + sortOrder;
   if (noOfRecords != null)
    queryAdm += ' limit ' + noOfRecords;
   else
    queryAdm += ' limit 10';
    
     
   return Database.query(queryAdm);
  } catch (Exception e) {ErrorLogging.Log(e, 'ACP_Performance_Analytics_ctrl', 'getADMData', acpid);ApexPages.addMessages(e); return null;}
   
 }
 
/* To get record for Market and Competition Summary*/
 public void admMarketCompetitionList() {
  
  try {
   admMarkCompList = new List < ACP_Market_and_Competition__c > ();
 if (admmarkrec.Default_Sort_Order__c != null && admmarkrec.ACP_No_Of_Records__c != null)
   {
   admMarkList = getADMData(admmarkrec.Default_Sort_Order__c, acpId, admmarkrec.ACP_No_Of_Records__c);
    }

   if (admMarkList.size() > 0) {
    for (ACP_Market_and_Competition__c admVar: admMarkList) {
     if (admVar.RecordTypeId == admMarkCompRecordTypeId)
      admMarkCompList.add(admVar);

    }
   }   }Catch(Exception e) {ErrorLogging.Log(e, 'ACP_Performance_Analytics_ctrl', 'admMarketCompetitionList', acpId); ApexPages.addMessages(e);}
            
           
  }

 /***********************Save and Save and New for Market Competition Summary****************************/
 public void saveCommonADM() {
if (acpId != null) {
   admMarkComp.RecordTypeId = admMarkCompRecordTypeId;

   admMarkComp.ACP_Account_Plan__c = acpId;

   // commConcatenate();
   try {
  insert admMarkComp;
 } catch (DMLException e) { ErrorLogging.Log(e, 'ACP_Performance_Analytics_ctrl', 'saveCommonADM', acpId);ApexPages.addMessages(e);}
   
  }
 }
 public PageReference saveADMMarkComp() {
  saveCommonADM();
  return pageRedirectWithDivId('MrktCompSum');

  // }
 }

/***********************Save and Save and New for Market Competition Summary****************************/
 public PageReference saveAndNewADM() {
  saveCommonADM();
  PageReference pagerefSN = new PageReference('/apex/ACP_Add_ADM_Market_Competition?saveURL=/apex/ACP_Performance_Analytics_Page?acpId=' + acpId);
  pagerefSN.getParameters().put('acpId', acpId);
  pagerefSN.setRedirect(true);
  return pagerefSN;
  //  }
 }

 public List < ACP_Top_Open_Opportunity__c > OpenOppList = new List < ACP_Top_Open_Opportunity__c > ();
 public List < ACP_Top_Open_Opportunity__c > topOpenOpportunityList {
  get;
  set;
 }
 ACP_Top_Open_Opportunity__c newTopOpenOpp = new ACP_Top_Open_Opportunity__c();

 Public ACP_Top_Open_Opportunity__c getNewTopOpenOpp() {
  return newTopOpenOpp;
 }
 public ACP_Section_Detail__c openOpprec {
  get {
   openOpprec = ACP_AccountPlan_Helper.getACPSectionRec(buSetting, 'Top Open Opportunities');
   return openOpprec;
  }
  set;
 }
 public List < Schema.FieldSetMember > getOpenOppsFields() {
  Map < String, Schema.Fieldset > fieldsetsOpenOppMap = Schema.SObjectType.ACP_Top_Open_Opportunity__c.fieldSets.getMap();
  if (openOpprec != null) {
   return fieldsetsOpenOppMap.get(openOpprec.ACP_Field_Set_Name__c).getFields();
  } else
   return SObjectType.ACP_Top_Open_Opportunity__c.FieldSets.ACP_Top_Open_Opportunity_Fieldset.getFields();
 }

 public List < ACP_Top_Open_Opportunity__c > getTopOpenOpportunityList(String sortOrder, String acpId, Decimal noOfRecords) {

  transient String query = 'SELECT ';

  for (Schema.FieldSetMember f: getOpenOppsFields()) {
   query += f.getFieldPath() + ',';
  }
  /* Fields in Fieldset are used to control the display in UI. Other required fields are fetched separately & they are not part of the fieldset. Adding these required fields like Id, Parent Id to fieldset will result in an error.  */
  query += 'ACP_Opportunity_Name__r.Name,ACP_Account_Plan__c FROM ACP_Top_Open_Opportunity__c where ACP_Account_Plan__c = \'' + acpId + '\'';
  if (sortOrder != null)
   query += ' order by ' + sortOrder;
  if (noOfRecords != null)
   query += ' limit ' + noOfRecords;
  else
   query += ' limit 10';
  return Database.query(query);

 }

 public void getTopOpenOppsList() {
  try {
   topOpenOpportunityList = new List < ACP_Top_Open_Opportunity__c > ();

   openOppList = getTopOpenOpportunityList(openOpprec.Default_Sort_Order__c, acpId, openOpprec.ACP_No_Of_Records__c);


   if (OpenOppList.size() > 0) {
    for (ACP_Top_Open_Opportunity__c opp: OpenOppList) {

     TopOpenOpportunityList.add(opp);

    }
   }
  } catch (Exception e) { ErrorLogging.Log(e, 'ACP_AccountPlan_Summary_Controller', 'getTopOpenOppsList', acpId);ApexPages.addMessages(e);}
           
 }

 public pageReference saveTopOpenOpp() {

  try {
  List<AggregateResult> oppParts = [Select count(id), SUM(Current_Year_add_1__c) from Opportunity_Part__c where opportunity__r.Id =: NewTopOpenOpp.ACP_Opportunity_Name__c and Status__c != 'Dead'];
  
   if(oppParts.size()>0)
   NewTopOpenOpp.ACP_Next_Year_Value__c = (Double)oppParts[0].get('expr1');
   NewTopOpenOpp.ACP_Account_Plan__c = acpId;
   insert NewTopOpenOpp;
   return pageRedirectWithDivId('topOpenOpp');
  } catch (DMLException e) {ErrorLogging.Log(e, 'ACP_Performance_Analytics_ctrl', 'saveTopOpenOpp', acpId); ApexPages.addMessages(e);}
   
  return null;
 }


 public pageReference saveNewTopOpenOpp() {

  try {
   List<AggregateResult> oppParts = [Select count(id), SUM(Current_Year_add_1__c) from Opportunity_Part__c where opportunity__r.Id =: NewTopOpenOpp.ACP_Opportunity_Name__c and Status__c != 'Dead'];   
    if(oppParts.size()>0)
   NewTopOpenOpp.ACP_Next_Year_Value__c = (Double)oppParts[0].get('expr1');
   NewTopOpenOpp.ACP_Account_Plan__c = acpId;
   insert NewTopOpenOpp;
   PageReference pageref = new PageReference('/apex/ACP_Add_Top_Open_Opp');
   pageref.getParameters().put('acpid', acpId);
   pageref.setRedirect(true);
   return pageref;
  } catch (DMLException e) { ErrorLogging.Log(e, 'ACP_Performance_Analytics_ctrl', 'saveNewTopOpenOpp', acpId);ApexPages.addMessages(e);}

  return null;

 }


 /************************************************Top Open Opportunities - End */
 /************************************************Code for Actions scetion - Start */
 public List < Task > taskList {get; set;}

 public void setCategoryWiseTask() {
 
   taskList = ACP_AccountPlan_Helper.getAllTasks(acpId);
  
  }
  /************************************************Code for Actions scetion - End */
  /************************************************Code for Business Performance - Start */
 Public List < ACP_Revenue_Growth_Perf__c > perfList {
  get;
  set;
 }
 Private String fiscalYearList = '';
 public Boolean isNext {
  get;
  set;
 }
 public ACP_Section_Detail__c detrec {
  get {
   detrec = ACP_AccountPlan_Helper.getACPSectionRec(buSetting, 'TE Business Performance');
   return detrec;
  }
  set;
 }
 public List < ACP_Revenue_Growth_Perf__c > businessPerfList {
  get {
   if (isNext) {
    businessPerfList = getAllPerf(filterValue);
    isNext = false;
    return businessPerfList;
   }
   return businessPerfList;
  }
  set;
 }
 public List < ACP_Revenue_Growth_Perf__c > getAllPerf(String bu) {
  if (detrec != null)
   return ACP_AccountPlan_Helper.getPerfList(bu, detrec.Revenue_Type__c, detrec.Default_Sort_Order__c, detrec.ACP_Field_Set_Name__c, acpId);
  else {
   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, System.label.ACP_BU_Setting_Error));
   return null;
  }
 }
 public String filterValue {
  get {
   if (filterValue == Null) filterValue = 'Billing';
   return filterValue;
  }
  set;
 }
 public static List < SelectOption > getFilterOptions() {
  List < SelectOption > actStat = new List < SelectOption > ();
  actStat.add(new SelectOption(System.Label.ACP_Billing, System.Label.ACP_Billing));
  actStat.add(new SelectOption(System.Label.ACP_Booking, System.Label.ACP_Booking));
  return actStat;
 }
 public void updatefilter() {
   businessPerfList = getAllPerf(filterValue);
  }
  /************************************************Code for Business Performance - End */
 public String userBU {
  get;
  set;
 }





 /****************************************************************************Application Breakdown Code Starts*************************/
 public List < ACP_Application_Breakdown__c > applicationBreakdownList {get; set;}
 
 
 public Opportunity opp1 {get; set;}
 public Opportunity opp2 {get; set;}
 public Opportunity opp3 {get; set;}

 public Set < Opportunity > aset ;
 public Integer count {
  get;
  set;
 }
 public List < ACP_Application_Breakdown__c > appBreakdownList = new List < ACP_Application_Breakdown__c > ();
 ACP_Application_Breakdown__c newAppBreakdown = new ACP_Application_Breakdown__c();
 Platform_Content__c platform = new Platform_Content__c();
 public ACP_Section_Detail__c appBrkrec {
  get {
   appBrkrec = ACP_AccountPlan_Helper.getACPSectionRec(buSetting, 'Application Breakdown');
   return appBrkrec;
  }
  set;
 }

 Public ACP_Application_Breakdown__c getNewAppBreakdown() {

  return newAppBreakdown;
 }
 Public Platform_Content__c getPlatform() {

  return platform;
 }
 
 public void getAppBrkdownList() {
  try {
   //List < ACP_Application_Breakdown__c > opptyNames = new List < ACP_Application_Breakdown__c > ();
   //opptyNames = [Select ACP_Opportunity_name__c, ACP_Opportunity_name__r.name from ACP_Application_Breakdown__c where ACP_Account_Plan__c = : acpId order by createdDate desc];

   applicationBreakdownList = new List < ACP_Application_Breakdown__c > ();
  appBreakdownList = getApplicationBreakdownList(appBrkrec.ACP_Field_Set_Name__c, appBrkrec.Default_Sort_Order__c, acpId);
   if (appBreakdownList.size() > 0) {
    for (ACP_Application_Breakdown__c appBrk: appBreakdownList) {
     applicationBreakdownList.add(appBrk);
     
    }
   }

   aset = new Set < Opportunity > ();
   for (ACP_Application_Breakdown__c opp: applicationBreakdownList) {
    Opportunity oppty = new Opportunity();
    oppty.id = opp.ACP_Opportunity_Name__c;
    oppty.name = opp.ACP_Opportunity_Name__r.name;
    aset.add(oppty);
   }
     count = 0;
   for (Opportunity opp: aset) {
  if (count == 0) 
    opp1 = opp;
    else if (count == 1) 
    opp2 = opp;
    else if (count == 2) 
    opp3 = opp;
  
    count++;
   }
  } catch (Exception e) {  ErrorLogging.Log(e, 'ACP_AccountPlan_Summary_Controller', 'getAppBrkdownList', acpId); ApexPages.addMessages(e);}
          

 }
 public List < Schema.FieldSetMember > getApplicationBreakdownFields() {

  Map < String, Schema.Fieldset > fieldsetsAppBrkMap = Schema.SObjectType.ACP_Application_Breakdown__c.fieldSets.getMap();
  if (appBrkrec != null && appBrkrec.ACP_Field_Set_Name__c != null) {
   return fieldsetsAppBrkMap.get(appBrkrec.ACP_Field_Set_Name__c).getFields();
  } else
   return SObjectType.ACP_Application_Breakdown__c.FieldSets.ACP_Application_Breakdown_Fieldset.getFields();
 }

 public List < ACP_Application_Breakdown__c > getApplicationBreakdownList(String fieldSetName, String sortOrder, String acpId) {
  try {
   transient String query = 'SELECT ';

   for (Schema.FieldSetMember f: getApplicationBreakdownFields()) {
    query += f.getFieldPath() + ',';
   }
/* Fields in Fieldset are used to control the display in UI. Other required fields are fetched separately & they are not part of the fieldset. Adding these required fields like Id, Parent Id to fieldset will result in an error.  */
   query += 'Id, ACP_Account_Plan__c, ACP_Opportunity_Name__c, ACP_Platform_Content_Name__c,Platform_Content__c,ACP_Opportunity_name__r.name  FROM ACP_Application_Breakdown__c where ACP_Account_Plan__c = \'' + acpId + '\'';
   if (sortOrder != null)
    query += ' order by ' + sortOrder ;

   return Database.query(query);
  } catch (DMLException e) {ErrorLogging.Log(e, 'ACP_AccountPlan_Page_Controller', 'saveAppBreakdown', acpId); ApexPages.addMessages(e);}
   
  return null;
 }


 public pageReference saveAppBreakdown() {
  try {

  
   String oppId = newAppBreakdown.ACP_Opportunity_Name__c;

   List < Platform_Content__c > platformContents = new List < Platform_Content__c > ();
   platformContents = [Select id, Program_Opportunity__c,Comments__c from Platform_Content__c where Program_Opportunity__c = : oppId order by createdDate desc limit 10];
   List < ACP_Application_Breakdown__c > appBrkdownList = new List < ACP_Application_Breakdown__c > ();

   for (Platform_Content__c pf: platformContents) {
    ACP_Application_Breakdown__c app = new ACP_Application_Breakdown__c();
    app.ACP_Account_Plan__c = acpId;
    app.ACP_Opportunity_Name__c = oppId;
    app.Platform_Content__c = pf.id;
    app.ACP_Comments__c = pf.Comments__c;
   appBrkdownList.add(app);

}
insert appBrkdownList;

   return pageRedirectWithDivId('applicationBreakdown');
  } catch (DMLException e) {ErrorLogging.Log(e, 'ACP_AccountPlan_Page_Controller', 'saveAppBreakdown', acpId); ApexPages.addMessages(e);}

  return null;
 }


 /***********************************************************************Application Breakdown COde Ends*******************************/
  public pageReference editRevenueDetails() {
  PageReference pageref = new PageReference('/apex/ACP_RGUpdate_Page');
  pageref.getParameters().put('acpId', acpId);
  pageref.setRedirect(true);
  return pageref;
 }
 
  /*****************************Chart Commented Code Start 4*********************************************************/
 
/*****************************Chart Commented Code End 4*********************************************************/

 /***********************************************Tab start************************************************/
 /*This method is used for redirect to other pages from onclicking of main tabs */
 public string Tabpagetoset = '';
 Public Pagereference redirectTabpage() {
  pagereference pr;
  Tabpagetoset = apexpages.currentpage().getparameters().get('tabpage');

  if (Tabpagetoset != null && Tabpagetoset != '') {
   pr = new pagereference('/apex/' + Tabpagetoset + '?acpId=' + acpid);
   pr.setredirect(true);
   return pr;
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

    
        
      public ACP_Revenue_Growth_Perf__c getRevenueGrowthTotal()
        {
        
   List<ACP_Revenue_Growth_Perf__c> revenueGrowthList = [select id, ACP_Past_Year_1_Revenue__c, ACP_Past_Year_Revenue__c, ACP_YOY_Current_Year_Perc__c,ACP_Current_Year_1_Plan__c,ACP_Current_Year_3_Plan__c,ACP_Current_Year_5_Plan__c, ACP_Current_Year_to_Date__c, ACP_YOM_Growth_Perc__c  from ACP_Revenue_Growth_Perf__c  where ACP_Account_Plan__c = : acpid and ACP_Refresh_Based_on__c =: filterValue and ACP_Sales_Mode__c = 'Combined' limit 1];
           if(revenueGrowthList.size()>0)
           
           return revenueGrowthList[0];  
          
            else 
            return null;
            
          
        }
                
 
}