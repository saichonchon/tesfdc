/***************************************************************************************
Name:ACP_RGUpdate_Page_ctrl
Test Class:ACP_RGUpdate_Page_ctrl_Test
Copyright © 2017 TE Connectivity
========================================================================================
Requirement:
Controller for ACP_RGUpdate_Page 
========================================================================================
Purpose:
Allow Users to update growth table in performance analytic tab.
========================================================================================
History
-------
Version      Author                Date              Detail
1.0          Ritika Pahwa          10/23/17          Added methods used for revenue growth functionality. 
****************************************************************************************/
public with sharing class ACP_RGUpdate_Page_ctrl {

  /************************************************Variables*********************************************************************/
  list < ACP_Revenue_Growth_Perf__c > rev;
  public ACP_Revenue_Growth_Perf__c revGrowth {
    get;
    set;
  }
  public List < ACP_Revenue_Growth_Perf__c > revGrowth2 {
    get;
    set;
  }
  public List < ACP_Revenue_Growth_Perf__c > revGrowth1 {
    get;
    set;
  }
  private final ACP_Account_Plan__c acctPlan {
    get;
    set;
  }
  public String acpId {
    get;
    set;
  }

  public String SelectType {
    get;
    set;
  }

  public String SelectType1 {
    get;
    set;
  }
  public ACP_Account_Plan__c Record {
    get;
    set;
  }
  public String userBU {
    get;
    set;
  }
  public ACP_Setting__c buSetting = new ACP_Setting__c();
  public ACP_Section_Detail__c detrec {
    get {
      detrec = ACP_AccountPlan_Helper.getACPSectionRec(buSetting, 'TE Business Performance');
      return detrec;
    }
    set;
  }
  /**************************************************the constructor********************************************************************************/
  public ACP_RGUpdate_Page_ctrl(ApexPages.StandardController stdController) {
   try {
    acpId = ApexPages.currentPage().getParameters().get('acpId');
    revGrowth1 = new List < ACP_Revenue_Growth_Perf__c > ();
    revGrowth = new ACP_Revenue_Growth_Perf__c();
    SelectType = ApexPages.currentPage().getParameters().get('SelectType');
    SelectType1 = ApexPages.currentPage().getParameters().get('SelectType1');
    acctPlan = (ACP_Account_Plan__c) stdController.getRecord();

   
      record = [select ACP_GAMCode__c, ACP_KAMCode__c, ACP_Account_Name__c, ACP_WWAcNo__c, Account_Plan_Type__c, ACP_Customer_Strategy_Summary__c, ACP_Customer_Major_Growth_Areas__c, ACP_Customer_Challenges_and_Threats__c, TE_Business_Performance_Comment__c from ACP_Account_Plan__c where id =: acpId];
    

    userBU = [Select GIBU__c From User Where Id =: UserInfo.getUserId()][0].GIBU__c;
    buSetting = ACP_AccountPlan_Helper.getACPSettingsRecord(userBU, record.Account_Plan_Type__c);
    if (buSetting == null)
      buSetting = ACP_AccountPlan_Helper.getACPSettingsRecord('', '');

    if (SelectType != null && SelectType1 != null && acpId <> null) {

      revGrowth1 = [select ACP_Labels_1__c,ACP_Labels_2__c,ACP_Labels_3__c,ACP_Labels_4__c,ACP_Project_1_Label__c, ACP_Project_2_Label__c, ACP_Project_3_Label__c, ACP_Project_4_Label__c, ACP_Project_5_Label__c, ACP_Past_Year_1_Revenue__c,
        ACP_Past_year_Revenue__c, ACP_EOL_Lost_Business__c, ACP_Transfer_In_Out__c, ACP_LY_Price_Erosion__c, ACP_LY_Market_Growth__c, ACP_Project_1__c,
        ACP_Project_2__c, ACP_Project_3__c, ACP_Project_4__c, ACP_Project_5__c, ACP_Current_Year_3_Plan__c, ACP_Current_Year_5_Plan__c, ACP_Sales_Mode__c, ACP_Refresh_Based_on__c,
        ACP_Forecast__c, ACP_Current_Year_Repeat_Business__c, ACP_Fiscal_Year__c,ACP_CYRR_Estimated_Final__c FROM ACP_Revenue_Growth_Perf__c where ACP_Account_Plan__c =: acpId and ACP_Sales_Mode__c =: SelectType and ACP_Refresh_Based_on__c =: SelectType1];
     

      if (!revGrowth1.isEmpty()) {
        revGrowth = revGrowth1[0];
        
  //changing to integer      
        if (revGrowth.ACP_Fiscal_Year__c <> null) {
          Decimal fiscalYearDecimal = Decimal.ValueOf(revGrowth.ACP_Fiscal_Year__c);
          revGrowth.ACP_Fiscal_Year__c = String.valueOf(fiscalYearDecimal.intValue());
         
        }
        
      }

    }
    } catch (Exception e) { ErrorLogging.Log(e, 'ACP_RGUpdate_Page_ctrl', 'ACP_RGUpdate_Page_ctrl', acpId); ApexPages.addMessages(e);
    }

  }
  /**************************************Created to filter the values based on sales mode and refresh based on**************************************************************************************/
  public List < SelectOption > getRecordTypes() {
  
    List < SelectOption > RecordOptions = new List < SelectOption > ();
    if (RecordOptions!=null) {
    String[] revenueTypesSplit = detrec.Revenue_Type__c.split(';');
    for (String optns: revenueTypesSplit) {
    RecordOptions.add(new SelectOption(optns, optns));
    }
    RecordOptions.add(new SelectOption('Combined', 'Combined'));
    } 
    
    return RecordOptions;
    
  }

  public List < SelectOption > getRecordTypes1() {
    List < SelectOption > RecordOptions = new List < SelectOption > ();
    if (RecordOptions!=null) {
    RecordOptions.add(new SelectOption('Billing', 'Billing'));
    RecordOptions.add(new SelectOption('Booking', 'Booking'));
    }
    return RecordOptions;
  }
/*****************Fetch the records for table on performance tab******************************************************************/
  public List < ACP_Revenue_Growth_Perf__c > getrev() {
   try {
    rev = [Select ACP_CYRR_Estimated_Final__c,ACP_Labels_1__c,ACP_Labels_2__c,ACP_Labels_3__c,ACP_Labels_4__c,ACP_Current_Year_1_Plan__c, ACP_Project_1_Label__c, ACP_Project_2_Label__c, ACP_Project_3_Label__c, ACP_Project_4_Label__c, ACP_Project_5_Label__c, ACP_Account_Plan__r.name, ACP_Past_Year_1_Revenue__c, ACP_Past_year_Revenue__c, ACP_EOL_Lost_Business__c, ACP_Transfer_In_Out__c, ACP_LY_Price_Erosion__c, ACP_LY_Market_Growth__c, ACP_Project_1__c, ACP_Project_2__c, ACP_Project_3__c, ACP_Project_4__c, ACP_Project_5__c, ACP_Current_Year_3_Plan__c, ACP_Current_Year_5_Plan__c, ACP_Sales_Mode__c, ACP_Refresh_Based_on__c, ACP_Fiscal_Year__c, ACP_Forecast__c, ACP_Current_Year_Repeat_Business__c FROM ACP_Revenue_Growth_Perf__c where ACP_Account_Plan__c =: acpId and ACP_Show_this_on_chart__c =: true];

   return rev;
    }catch (Exception e) {ErrorLogging.Log(e, 'ACP_RGUpdate_Page_ctrl', 'saveGrowth', acpId);ApexPages.addMessages(e);
   return null;
   }
  }



  /*****************************************************Created for saving updated records******************************************************************************/
  public PageReference saveGrowth() {
    try {
      if (!revGrowth1.isEmpty()) {
      
    //  Assigning the bu admin values to the object fields
    
        revGrowth1[0].ACP_Project_1_Label__c = detrec.ACP_Project_1__c;
        revGrowth1[0].ACP_Project_2_Label__c = detrec.ACP_Project_2__c;
        revGrowth1[0].ACP_Project_3_Label__c = detrec.ACP_Project_3__c;
        revGrowth1[0].ACP_Project_4_Label__c = detrec.ACP_Project_4__c;
        revGrowth1[0].ACP_Project_5_Label__c = detrec.ACP_Project_5__c;
        revGrowth1[0].ACP_Labels_1__c= detrec.ACP_Label_1__c;
        revGrowth1[0].ACP_Labels_2__c= detrec.ACP_Label_2__c;
        revGrowth1[0].ACP_Labels_3__c= detrec.ACP_Label_3__c;
        revGrowth1[0].ACP_Labels_4__c= detrec.ACP_Label_4__c;
        revGrowth1[0].ACP_Show_this_on_chart__c = true;
        update revGrowth1[0];
        
     // querying revgrowth again for other 7 records so to make ACP_Show_this_on_chart__c= false for that particular records
        
        revGrowth2 = [select ID,ACP_Account_Plan__c,ACP_Show_this_on_chart__c FROM ACP_Revenue_Growth_Perf__c where Id !=: revGrowth1[0].Id and ACP_Account_Plan__c =: acpId and ACP_Show_this_on_chart__c =: true];
     
       
        if (!revGrowth2.isEmpty()) {
          for (ACP_Revenue_Growth_Perf__c str: revGrowth2) {
            str.ACP_Show_this_on_chart__c = false;
            
          }

        }
        update revGrowth2;
       
      }
      PageReference pageref = new PageReference('/apex/ACP_Performance_Analytics_page?acpId=' + acpId + '#businessPerf');

      pageref.getParameters().put('SelectType', SelectType);
      pageref.getParameters().put('SelectType1', SelectType1);
      pageref.setRedirect(true);
      return pageref;
    } catch (Exception e) {ErrorLogging.Log(e, 'ACP_RGUpdate_Page_ctrl', 'saveGrowth', acpId);ApexPages.addMessages(e);
      return null;
    }
  }


  /*******************************************Created For GO Button***********************************************************************/
  public PageReference goGrowthRevenue() {


    PageReference pageref = new PageReference('/apex/ACP_RGUpdate_Page');
    pageref.getParameters().put('acpid', acpId);
    pageref.getParameters().put('SelectType', SelectType);
    pageref.getParameters().put('SelectType1', SelectType1);
    pageref.setRedirect(true);
    return pageref;


  }

  /*********************************************Created for cancel Button***********************************************************************/
  public PageReference cancelGrowth() {

    PageReference pageref = new PageReference('/apex/ACP_Performance_Analytics_page?acpId=' + acpId + '#businessPerf');
    pageref.setRedirect(true);
    return pageref;

  }

}