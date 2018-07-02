/**
*  This test class is for ClsAccountPlanUtility.
*
@author Di Chen
@created 2012-05-31
@version 1.0
@since 20.0
*
@changelog
* 2012-05-31 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 98%
*/
@isTest
private class ClsAccountPlanUtility_Test {

    static testMethod void testMostMethods() {
      Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
         Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();
      RecordType rt = ClsTestHelp.createTestRecordType6();
      RecordType rt2 = ClsTestHelp.createTestRecordType8();
      
      Account acc = ClsTestHelp.createTestAccounts();
      acc.Name = 'axx';
      acc.RecordTypeId = rt2.Id;
      acc.Customer_Classification__c = 'A';
      acc.Type = 'Competitor';
      acc.GAMCD__c = '1000';
      insert acc;
      
      Account acc1 = ClsTestHelp.createTestAccounts();
      acc1.Name = 'axx1';
      acc1.RecordTypeId = rt.Id;
      acc1.Customer_Classification__c = 'A';
      acc1.Type = 'Competitor';
      acc1.GAMCD__c = '1000';
      insert acc1;
      
      Account acc2 = ClsTestHelp.createTestAccounts();
      acc2.Name = 'axx2';
      acc2.RecordTypeId = rt.Id;
      acc2.Customer_Classification__c = 'A';
      acc2.Type = 'Competitor';
      acc2.GAMCD__c = '1000';
      insert acc2;
      
      Attachment att= ClsTestHelp.createTestAttachments();
        att.ParentId = acc1.Id;
        insert att;
      
      Opportunity oppy = ClsTestHelp.createTestOpportunity();
      oppy.AccountId = acc.Id;
      oppy.StageName = 'New';
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        insert oppy;
        
      Account_Plan__c apNew = ClsTestHelp.createTestAccountPlan();
      apNew.Customer__c = acc1.Id;
      //apNew.Competitor1__c = acc1.Id;
      apnew.Replicate_to_Central_Org__c = true;
      apnew.Account_Manager_Id__c = String.valueOf(att.Id).substring(0,15);
      apnew.Account_Objective_Active_1__c = true;
        apnew.Account_Objective_Active_2__c = true;
        apnew.Account_Objective_Active_3__c = true;
        apnew.Account_Objective_Active_4__c = true;
        apnew.Account_Objective_Active_5__c = true;
        apnew.Account_Objective_1__c = 'Objective1';
        apnew.Account_Objective_2__c = 'Objective2';
        apnew.Account_Objective_3__c = 'Objective3';
        apnew.Account_Objective_4__c = 'Objective4';
        apnew.Account_Objective_5__c = 'Objective5';
      
      apnew.Strategic_Initiative_10_Target__c = 'FY12Q1';
      apnew.Strategic_Initiative_1_Target__c = 'FY12Q1';
      apnew.Strategic_Initiative_2_Target__c = 'FY12Q1';
      apnew.Strategic_Initiative_3_Target__c = 'FY12Q1';
      apnew.Strategic_Initiative_4_Target__c = 'FY12Q1';
      apnew.Strategic_Initiative_5_Target__c = 'FY12Q1';
      apnew.Strategic_Initiative_6_Target__c = 'FY12Q1';
      apnew.Strategic_Initiative_7_Target__c = 'FY12Q1';
      apnew.Strategic_Initiative_8_Target__c = 'FY12Q1';
      apnew.Strategic_Initiative_9_Target__c = 'FY12Q1';
      
      apnew.Strategic_Initiative_10_Status__c = 'On target';
      apnew.Strategic_Initiative_9_Status__c = 'On target';
      apnew.Strategic_Initiative_8_Status__c = 'On target';
      apnew.Strategic_Initiative_7_Status__c = 'On target';
      apnew.Strategic_Initiative_6_Status__c = 'On target';
      apnew.Strategic_Initiative_5_Status__c = 'On target';
      apnew.Strategic_Initiative_4_Status__c = 'On target';
      apnew.Strategic_Initiative_3_Status__c = 'On target';
      apnew.Strategic_Initiative_2_Status__c = 'On target';
      apnew.Strategic_Initiative_1_Status__c = 'On target';
      
      apnew.Key_Project_1__c = oppy.Id;
      apnew.Key_Project_2__c = oppy.Id;
      apnew.Key_Project_3__c = oppy.Id;
      apnew.Key_Project_4__c = oppy.Id;
      apnew.Key_Project_5__c = oppy.Id;
      apnew.Key_Project_6__c = oppy.Id;
      apnew.Active__c = true;
      insert apNew;
      Attachment att1= ClsTestHelp.createTestAttachments();
        att1.ParentId = apNew.Id;
        insert att1;
        Note note1 = new note();
        note1.ParentId = apNew.Id;
        note1.Title = 'Test';
        note1.Body = 'Test';
        insert note1;
        
      Account_Plan__c apOld = ClsTestHelp.createTestAccountPlan();
      apOld.Customer__c = acc2.Id;
      //apOld.Competitor1__c = acc2.Id;
      apOld.Company_Logo_Id__c = 'xxx';
      apOld.Replicate_to_Central_Org__c = true;
      apOld.Account_Manager_Id__c = 'xxx';
      apOld.Strategic_Initiative_5_Status__c = 'On target';
      apOld.Active__c = true;
      insert apOld;
    Attachment att2= ClsTestHelp.createTestAttachments();
        att2.ParentId = apOld.Id;
        att2.name = 'VoiceOverview.wav';
        insert att2;
        Note note2 = new note();
        note2.ParentId = apOld.Id;
        note2.Title = 'Test';
        note2.Body = 'Test';
        insert note2;
        
        Account_Plan__c apNew2 = [Select Name,Account_Manager_Id__c, Account_Definition__c, Account_Objective_1__c, Account_Objective_2__c, Account_Objective_3__c, 
                             Account_Objective_4__c, Account_Objective_5__c,Account_Objective_6__c, Account_Objective_7__c, Account_Objective_8__c, 
                             Account_Objective_9__c, Account_Objective_10__c,Account_Objective_11__c, Account_Objective_12__c, Account_Objective_13__c, 
                             Account_Objective_14__c, Account_Objective_15__c,Account_Objective_16__c, Account_Objective_17__c, Account_Objective_18__c, 
                             Account_Objective_19__c, Account_Objective_20__c, 
                             Approval_Status__c, BU_Revenue_CY_Forecast_M__c, BU_Revenue_Fcst_Plan_Yr_M__c, BU_Revenue_Fcst_Plan_Yr_1_M__c, 
                             BU_Revenue_Fcst_Plan_Yr_4_M__c, BU_Revenue_Pct_Change_Plan_Yr_1__c, BU_Revenue_Pct_Change_Plan_Yr_4__c, 
                             BU_Revenue_Prior_Yr_Actual_M__c, BU_Revenue_YTD_Actual_M__c, BU_Revenue_Pct_Change_Plan_Yr__c, 
                             Breakthrough_Pgm_1_Comments__c, Breakthrough_Pgm_1_Status__c, Breakthrough_Pgm_2_Comments__c, 
                             Breakthrough_Pgm_2_Status__c, Breakthrough_Pgm_3_Comments__c, Breakthrough_Pgm_3_Status__c, 
                             Breakthrough_Pgm_4_Comments__c, Breakthrough_Pgm_4_Status__c, Breakthrough_Program_1__c, 
                             Breakthrough_Program_2__c, Breakthrough_Program_3__c, Breakthrough_Program_4__c, Business_Unit__c, 
                             Category1_Name__c, Category1_Rev_Pct_Chg_Plan_Yr_1__c, Category1_Rev_Pct_Chg_Plan_Yr_2__c, 
                             Category1_Revenue_M_Plan_Yr_1__c, Category1_Revenue_M_Plan_Yr_2__c, Category1_Revenue_M_Plan_Yr_3__c, 
                             Category2_Name__c, Category2_Rev_Pct_Chg_Plan_Yr_1__c, Category2_Rev_Pct_Chg_Plan_Yr_2__c, 
                             Category2_Revenue_M_Plan_Yr_1__c, Category2_Revenue_M_Plan_Yr_2__c, Category2_Revenue_M_Plan_Yr_3__c, 
                             Category3_Name__c, Category3_Rev_Pct_Chg_Plan_Yr_1__c, Category3_Rev_Pct_Chg_Plan_Yr_2__c, 
                             Category3_Revenue_M_Plan_Yr_1__c, Category3_Revenue_M_Plan_Yr_2__c, Category3_Revenue_M_Plan_Yr_3__c, 
                             Competitor_1__c, Competitor_1_Comments__c, Competitor_1_MS_Trend__c, Competitor_1_Market_Share__c, 
                             Competitor_2__c, Competitor_2_Comments__c, Competitor_2_MS_Trend__c, Competitor_2_Market_Share__c, 
                             Competitor_3__c, Competitor_3_Comments__c, Competitor_3_MS_Trend__c, Competitor_3_Market_Share__c, 
                             Competitor_4__c, Competitor_4_Comments__c, Competitor_4_MS_Trend__c, Competitor_4_Market_Share__c, 
                             Competitor_5__c, Competitor_5_Comments__c, Competitor_5_MS_Trend__c, Competitor_5_Market_Share__c, 
                             Competitor_6__c, Competitor_6_Comments__c, Competitor_6_MS_Trend__c, Competitor_6_Market_Share__c, 
                             CreatedById, CreatedDate, CurrencyIsoCode, Customer_Scorecard__c, Customer_Scorecard_Comments__c, 
                             Customer_Type__c, IsDeleted, Engineering_Relationship__c, Engineering_Relationship_Comments__c, 
                             Executive_Relationship__c, Executive_Relationship_Comments__c, GAM_Code__c, Gross_Margin_Pct_Plan_Yr__c, 
                             Gross_Margin_Pct_Plan_Yr_1__c, Gross_Margin_Pct_Plan_Yr_4__c, Gross_Margin_Pct_Prior_Yr__c, 
                             Hidden_Do_Not_Use__c, Industry_Segment__c, Key_Product_1__c, Key_Product_1_Outlook__c, Key_Product_1_Pct__c, 
                             Key_Product_2__c, Key_Product_2_Outlook__c, Key_Product_2_Pct__c, Key_Product_3__c, Key_Product_3_Outlook__c, 
                             Key_Product_3_Pct__c, Key_Product_4__c, Key_Product_4_Outlook__c, Key_Product_4_Pct__c, Key_Product_5__c, 
                             Key_Product_5_Outlook__c, Key_Product_5_Pct__c, Key_Product_6__c, Key_Product_6_Outlook__c, Key_Product_6_Pct__c, 
                             Key_Product_Percent_Title__c, Key_Project_1__c, Key_Project_1_Start_Date__c, Key_Project_1_Value_M__c, 
                             Key_Project_2__c, Key_Project_2_Start_Date__c, Key_Project_2_Value_M__c, Key_Project_3__c, Key_Project_3_Start_Date__c, 
                             Key_Project_3_Value_M__c, Key_Project_4__c, Key_Project_4_Start_Date__c, Key_Project_4_Value_M__c, 
                             Key_Project_5__c, Key_Project_5_Start_Date__c, Key_Project_5_Value_M__c, Key_Project_6__c, Key_Project_6_Start_Date__c, 
                             Key_Project_6_Value_M__c, LastModifiedById, LastModifiedDate, Manager__c, Market_Share_Plan_Yr__c, 
                             Market_Share_Plan_Yr_1__c, Market_Share_Plan_Yr_4__c, Market_Share_Prior_Yr__c, Monthly_Update__c, 
                             Monthly_Update_Last_Updated__c, Monthly_Update_Last_Updated_By__c, Obstacle_1__c, Obstacle_2__c, 
                             Obstacle_3__c, Obstacle_4__c, Obstacle_5__c, Plan_Year__c, Purchasing_Relationship__c, 
                             Purchasing_Relationship_Comments__c, ConnectionReceivedId, Recent_Big_Win_1__c, Recent_Big_Win_1_Comments__c, 
                             Recent_Big_Win_1_Date_Won__c, Recent_Big_Win_1_Value_M__c, Recent_Big_Win_2__c, Recent_Big_Win_2_Comments__c, 
                             Recent_Big_Win_2_Date_Won__c, Recent_Big_Win_2_Value_M__c, Recent_Big_Win_3__c, Recent_Big_Win_3_Comments__c, 
                             Recent_Big_Win_3_Date_Won__c, Recent_Big_Win_3_Value_M__c, Recent_Big_Win_4__c, Recent_Big_Win_4_Comments__c, 
                             Recent_Big_Win_4_Date_Won__c, Recent_Big_Win_4_Value_M__c, Recent_Loss_1__c, Recent_Loss_1_Comments__c, 
                             Recent_Loss_1_Date__c, Recent_Loss_1_Value_M__c, Recent_Loss_2__c, Recent_Loss_2_Comments__c, Recent_Loss_2_Date__c, 
                             Recent_Loss_2_Value_M__c, Recent_Loss_3__c, Recent_Loss_3_Comments__c, Recent_Loss_3_Date__c, Recent_Loss_3_Value_M__c, 
                             Recent_Loss_4__c, Recent_Loss_4_Comments__c, Recent_Loss_4_Date__c, Recent_Loss_4_Value_M__c, Id, 
                             Revenue_Section_Last_Updated__c, Revenue_Section_Last_Updated_By__c, Revenue_TAM_SAM__c, Sales_Breakdown_1_Description__c, 
                             Sales_Breakdown_1_Percent__c, Sales_Breakdown_2_Description__c, Sales_Breakdown_2_Percent__c, Sales_Breakdown_3_Description__c, 
                             Sales_Breakdown_3_Percent__c, Sales_Breakdown_4_Description__c, Sales_Breakdown_4_Percent__c, Sales_Breakdown_5_Description__c, 
                             Sales_Breakdown_5_Percent__c, ConnectionSentId, Strategic_Initiative_1__c, Strategic_Initiative_1_Status__c, 
                             Strategic_Initiative_1_Target__c, Strategic_Initiative_10__c, Strategic_Initiative_10_Status__c, 
                             Strategic_Initiative_10_Target__c, Strategic_Initiative_2__c, Strategic_Initiative_2_Status__c, 
                             Strategic_Initiative_2_Target__c, Strategic_Initiative_3__c, Strategic_Initiative_3_Status__c, 
                             Strategic_Initiative_3_Target__c, Strategic_Initiative_4__c, Strategic_Initiative_4_Status__c, 
                             Strategic_Initiative_4_Target__c, Strategic_Initiative_5__c, Strategic_Initiative_5_Status__c, 
                             Strategic_Initiative_5_Target__c, Strategic_Initiative_6__c, Strategic_Initiative_6_Status__c, 
                             Strategic_Initiative_6_Target__c, Strategic_Initiative_7__c, Strategic_Initiative_7_Status__c, 
                             Strategic_Initiative_7_Target__c, Strategic_Initiative_8__c, Strategic_Initiative_8_Status__c, 
                             Strategic_Initiative_8_Target__c, Strategic_Initiative_9__c, Strategic_Initiative_9_Status__c, 
                             Strategic_Initiative_9_Target__c, SystemModstamp, TAM_Pct_Change_Plan_Yr__c, TAM_Pct_Change_Plan_Yr_1__c, 
                             TAM_Pct_Change_Plan_Yr_4__c, TAM_Plan_Year_M__c, TAM_Plan_Yr_1_M__c, TAM_Plan_Yr_4_M__c, TAM_Prior_Yr_M__c, 
                             TE_Performance_Status__c, TE_Revenue_CY_Forecast_M__c, TE_Revenue_Fcst_Plan_Yr_M__c, TE_Revenue_Fcst_Plan_Yr_1_M__c, 
                             TE_Revenue_Fcst_Plan_Yr_4_M__c, TE_Revenue_Pct_Change_Plan_Yr__c, TE_Revenue_Pct_Change_Plan_Yr_1__c, 
                             TE_Revenue_Pct_Change_Plan_Yr_4__c, TE_Revenue_Prior_Yr_Actual_M__c, TE_Revenue_YTD_Actual_M__c, Sales_Figures_Makeup__c, 
                             Total_Rev_Pct_Chg_Plan_Yr_1__c, Total_Rev_Pct_Chg_Plan_Yr_2__c, Total_Revenue_M_Plan_Yr_1__c, 
                             Total_Revenue_M_Plan_Yr_2__c, Total_Revenue_M_Plan_Yr_3__c, Unique_A_Customer_Year__c,Replicate_to_Central_Org__c,Company_Logo_Id__c,BU_Revenue_CY_Manual_Forecast_M__c, 
                             Account_Objective_Location_1__c,Account_Objective_Location_2__c,Account_Objective_Location_3__c,Account_Objective_Location_4__c,Account_Objective_Location_5__c,Account_Objective_Location_6__c,
                             Account_Objective_Location_7__c,Account_Objective_Location_8__c,Account_Objective_Location_9__c,Account_Objective_Location_10__c,Account_Objective_Location_11__c,Account_Objective_Location_12__c,
                             Account_Objective_Location_13__c,Account_Objective_Location_14__c,Account_Objective_Location_15__c,Account_Objective_Location_16__c,Account_Objective_Location_17__c,Account_Objective_Location_18__c,
                             Account_Objective_Location_19__c,Account_Objective_Location_20__c,
                             Account_Objective_Active_1__c,Account_Objective_Active_2__c,Account_Objective_Active_3__c,Account_Objective_Active_4__c,Account_Objective_Active_5__c,Account_Objective_Active_6__c,Account_Objective_Active_7__c,
                             Account_Objective_Active_8__c,Account_Objective_Active_9__c,Account_Objective_Active_10__c,Account_Objective_Active_11__c,Account_Objective_Active_12__c,Account_Objective_Active_13__c,Account_Objective_Active_14__c,
                             Account_Objective_Active_15__c,Account_Objective_Active_16__c,Account_Objective_Active_17__c,Account_Objective_Active_18__c,Account_Objective_Active_19__c,Account_Objective_Active_20__c,
                             Strategic_Initiative_Active_1__c,Strategic_Initiative_Active_2__c,Strategic_Initiative_Active_3__c,Strategic_Initiative_Active_4__c,Strategic_Initiative_Active_5__c,Strategic_Initiative_Active_6__c,Strategic_Initiative_Active_7__c,
                             Strategic_Initiative_Active_8__c,Strategic_Initiative_Active_9__c,Strategic_Initiative_Active_10__c,Strategic_Initiative_Active_11__c,Strategic_Initiative_Active_12__c,Strategic_Initiative_Active_13__c,Strategic_Initiative_Active_14__c,
                             Strategic_Initiative_Active_15__c,Strategic_Initiative_Active_16__c,Strategic_Initiative_Active_17__c,Strategic_Initiative_Active_18__c,Strategic_Initiative_Active_19__c,Strategic_Initiative_Active_20__c,
                           Strategic_Initiative_11__c,Strategic_Initiative_12__c,Strategic_Initiative_13__c,Strategic_Initiative_14__c,Strategic_Initiative_15__c,Strategic_Initiative_16__c,Strategic_Initiative_17__c,
                           Strategic_Initiative_18__c,Strategic_Initiative_19__c,Strategic_Initiative_20__c, TE_Inside_Account_Plan__c                        
                             from Account_Plan__c where Id =: apNew.Id];
        apNew2.TE_Inside_Account_Plan__c = true;
        Update apNew2;
        Account_Plan__c apOld2 = [Select Name, Account_Definition__c, Account_Objective_1__c, Account_Objective_2__c, Account_Objective_3__c, 
                             Account_Objective_4__c, Account_Objective_5__c,Account_Objective_6__c, Account_Objective_7__c, Account_Objective_8__c, 
                             Account_Objective_9__c, Account_Objective_10__c,Account_Objective_11__c, Account_Objective_12__c, Account_Objective_13__c, 
                             Account_Objective_14__c, Account_Objective_15__c,Account_Objective_16__c, Account_Objective_17__c, Account_Objective_18__c, 
                             Account_Objective_19__c, Account_Objective_20__c,  
                             Approval_Status__c,BU_Revenue_CY_Forecast_M__c, BU_Revenue_Fcst_Plan_Yr_M__c, BU_Revenue_Fcst_Plan_Yr_1_M__c, 
                             BU_Revenue_Fcst_Plan_Yr_4_M__c, BU_Revenue_Pct_Change_Plan_Yr_1__c, BU_Revenue_Pct_Change_Plan_Yr_4__c, 
                             BU_Revenue_Prior_Yr_Actual_M__c, BU_Revenue_YTD_Actual_M__c, BU_Revenue_Pct_Change_Plan_Yr__c, 
                             Breakthrough_Pgm_1_Comments__c, Breakthrough_Pgm_1_Status__c, Breakthrough_Pgm_2_Comments__c, 
                             Breakthrough_Pgm_2_Status__c, Breakthrough_Pgm_3_Comments__c, Breakthrough_Pgm_3_Status__c, 
                             Breakthrough_Pgm_4_Comments__c, Breakthrough_Pgm_4_Status__c, Breakthrough_Program_1__c, 
                             Breakthrough_Program_2__c, Breakthrough_Program_3__c, Breakthrough_Program_4__c, Business_Unit__c, 
                             Category1_Name__c, Category1_Rev_Pct_Chg_Plan_Yr_1__c, Category1_Rev_Pct_Chg_Plan_Yr_2__c, 
                             Category1_Revenue_M_Plan_Yr_1__c, Category1_Revenue_M_Plan_Yr_2__c, Category1_Revenue_M_Plan_Yr_3__c, 
                             Category2_Name__c, Category2_Rev_Pct_Chg_Plan_Yr_1__c, Category2_Rev_Pct_Chg_Plan_Yr_2__c, 
                             Category2_Revenue_M_Plan_Yr_1__c, Category2_Revenue_M_Plan_Yr_2__c, Category2_Revenue_M_Plan_Yr_3__c, 
                             Category3_Name__c, Category3_Rev_Pct_Chg_Plan_Yr_1__c, Category3_Rev_Pct_Chg_Plan_Yr_2__c, 
                             Category3_Revenue_M_Plan_Yr_1__c, Category3_Revenue_M_Plan_Yr_2__c, Category3_Revenue_M_Plan_Yr_3__c, 
                             Competitor_1__c, Competitor_1_Comments__c, Competitor_1_MS_Trend__c, Competitor_1_Market_Share__c, 
                             Competitor_2__c, Competitor_2_Comments__c, Competitor_2_MS_Trend__c, Competitor_2_Market_Share__c, 
                             Competitor_3__c, Competitor_3_Comments__c, Competitor_3_MS_Trend__c, Competitor_3_Market_Share__c, 
                             Competitor_4__c, Competitor_4_Comments__c, Competitor_4_MS_Trend__c, Competitor_4_Market_Share__c, 
                             Competitor_5__c, Competitor_5_Comments__c, Competitor_5_MS_Trend__c, Competitor_5_Market_Share__c, 
                             Competitor_6__c, Competitor_6_Comments__c, Competitor_6_MS_Trend__c, Competitor_6_Market_Share__c, 
                             CreatedById, CreatedDate, CurrencyIsoCode, Customer_Scorecard__c, Customer_Scorecard_Comments__c, 
                             Customer_Type__c, IsDeleted, Engineering_Relationship__c, Engineering_Relationship_Comments__c, 
                             Executive_Relationship__c, Executive_Relationship_Comments__c, GAM_Code__c, Gross_Margin_Pct_Plan_Yr__c, 
                             Gross_Margin_Pct_Plan_Yr_1__c, Gross_Margin_Pct_Plan_Yr_4__c, Gross_Margin_Pct_Prior_Yr__c, 
                             Hidden_Do_Not_Use__c, Industry_Segment__c, Key_Product_1__c, Key_Product_1_Outlook__c, Key_Product_1_Pct__c, 
                             Key_Product_2__c, Key_Product_2_Outlook__c, Key_Product_2_Pct__c, Key_Product_3__c, Key_Product_3_Outlook__c, 
                             Key_Product_3_Pct__c, Key_Product_4__c, Key_Product_4_Outlook__c, Key_Product_4_Pct__c, Key_Product_5__c, 
                             Key_Product_5_Outlook__c, Key_Product_5_Pct__c, Key_Product_6__c, Key_Product_6_Outlook__c, Key_Product_6_Pct__c, 
                             Key_Product_Percent_Title__c, Key_Project_1__c, Key_Project_1_Start_Date__c, Key_Project_1_Value_M__c, 
                             Key_Project_2__c, Key_Project_2_Start_Date__c, Key_Project_2_Value_M__c, Key_Project_3__c, Key_Project_3_Start_Date__c, 
                             Key_Project_3_Value_M__c, Key_Project_4__c, Key_Project_4_Start_Date__c, Key_Project_4_Value_M__c, 
                             Key_Project_5__c, Key_Project_5_Start_Date__c, Key_Project_5_Value_M__c, Key_Project_6__c, Key_Project_6_Start_Date__c, 
                             Key_Project_6_Value_M__c, LastModifiedById, LastModifiedDate, Manager__c, Market_Share_Plan_Yr__c, 
                             Market_Share_Plan_Yr_1__c, Market_Share_Plan_Yr_4__c, Market_Share_Prior_Yr__c, Monthly_Update__c, 
                             Monthly_Update_Last_Updated__c, Monthly_Update_Last_Updated_By__c, Obstacle_1__c, Obstacle_2__c, 
                             Obstacle_3__c, Obstacle_4__c, Obstacle_5__c, Plan_Year__c, Purchasing_Relationship__c, 
                             Purchasing_Relationship_Comments__c, ConnectionReceivedId, Recent_Big_Win_1__c, Recent_Big_Win_1_Comments__c, 
                             Recent_Big_Win_1_Date_Won__c, Recent_Big_Win_1_Value_M__c, Recent_Big_Win_2__c, Recent_Big_Win_2_Comments__c, 
                             Recent_Big_Win_2_Date_Won__c, Recent_Big_Win_2_Value_M__c, Recent_Big_Win_3__c, Recent_Big_Win_3_Comments__c, 
                             Recent_Big_Win_3_Date_Won__c, Recent_Big_Win_3_Value_M__c, Recent_Big_Win_4__c, Recent_Big_Win_4_Comments__c, 
                             Recent_Big_Win_4_Date_Won__c, Recent_Big_Win_4_Value_M__c, Recent_Loss_1__c, Recent_Loss_1_Comments__c, 
                             Recent_Loss_1_Date__c, Recent_Loss_1_Value_M__c, Recent_Loss_2__c, Recent_Loss_2_Comments__c, Recent_Loss_2_Date__c, 
                             Recent_Loss_2_Value_M__c, Recent_Loss_3__c, Recent_Loss_3_Comments__c, Recent_Loss_3_Date__c, Recent_Loss_3_Value_M__c, 
                             Recent_Loss_4__c, Recent_Loss_4_Comments__c, Recent_Loss_4_Date__c, Recent_Loss_4_Value_M__c, Id, 
                             Revenue_Section_Last_Updated__c, Revenue_Section_Last_Updated_By__c, Revenue_TAM_SAM__c, Sales_Breakdown_1_Description__c, 
                             Sales_Breakdown_1_Percent__c, Sales_Breakdown_2_Description__c, Sales_Breakdown_2_Percent__c, Sales_Breakdown_3_Description__c, 
                             Sales_Breakdown_3_Percent__c, Sales_Breakdown_4_Description__c, Sales_Breakdown_4_Percent__c, Sales_Breakdown_5_Description__c, 
                             Sales_Breakdown_5_Percent__c, ConnectionSentId, Strategic_Initiative_1__c, Strategic_Initiative_1_Status__c, 
                             Strategic_Initiative_1_Target__c, Strategic_Initiative_10__c, Strategic_Initiative_10_Status__c, 
                             Strategic_Initiative_10_Target__c, Strategic_Initiative_2__c, Strategic_Initiative_2_Status__c, 
                             Strategic_Initiative_2_Target__c, Strategic_Initiative_3__c, Strategic_Initiative_3_Status__c, 
                             Strategic_Initiative_3_Target__c, Strategic_Initiative_4__c, Strategic_Initiative_4_Status__c, 
                             Strategic_Initiative_4_Target__c, Strategic_Initiative_5__c, Strategic_Initiative_5_Status__c, 
                             Strategic_Initiative_5_Target__c, Strategic_Initiative_6__c, Strategic_Initiative_6_Status__c, 
                             Strategic_Initiative_6_Target__c, Strategic_Initiative_7__c, Strategic_Initiative_7_Status__c, 
                             Strategic_Initiative_7_Target__c, Strategic_Initiative_8__c, Strategic_Initiative_8_Status__c, 
                             Strategic_Initiative_8_Target__c, Strategic_Initiative_9__c, Strategic_Initiative_9_Status__c, 
                             Strategic_Initiative_9_Target__c, SystemModstamp, TAM_Pct_Change_Plan_Yr__c, TAM_Pct_Change_Plan_Yr_1__c, 
                             TAM_Pct_Change_Plan_Yr_4__c, TAM_Plan_Year_M__c, TAM_Plan_Yr_1_M__c, TAM_Plan_Yr_4_M__c, TAM_Prior_Yr_M__c, 
                             TE_Performance_Status__c, TE_Revenue_CY_Forecast_M__c, TE_Revenue_Fcst_Plan_Yr_M__c, TE_Revenue_Fcst_Plan_Yr_1_M__c, 
                             TE_Revenue_Fcst_Plan_Yr_4_M__c, TE_Revenue_Pct_Change_Plan_Yr__c, TE_Revenue_Pct_Change_Plan_Yr_1__c, 
                             TE_Revenue_Pct_Change_Plan_Yr_4__c, TE_Revenue_Prior_Yr_Actual_M__c, TE_Revenue_YTD_Actual_M__c, Sales_Figures_Makeup__c, 
                             Total_Rev_Pct_Chg_Plan_Yr_1__c, Total_Rev_Pct_Chg_Plan_Yr_2__c, Total_Revenue_M_Plan_Yr_1__c, 
                             Total_Revenue_M_Plan_Yr_2__c, Total_Revenue_M_Plan_Yr_3__c, Unique_A_Customer_Year__c,Company_Logo_Id__c,Replicate_to_Central_Org__c,Account_Manager_Id__c,BU_Revenue_CY_Manual_Forecast_M__c,
                             Account_Objective_Location_1__c,Account_Objective_Location_2__c,Account_Objective_Location_3__c,Account_Objective_Location_4__c,Account_Objective_Location_5__c,Account_Objective_Location_6__c,
                             Account_Objective_Location_7__c,Account_Objective_Location_8__c,Account_Objective_Location_9__c,Account_Objective_Location_10__c,Account_Objective_Location_11__c,Account_Objective_Location_12__c,
                             Account_Objective_Location_13__c,Account_Objective_Location_14__c,Account_Objective_Location_15__c,Account_Objective_Location_16__c,Account_Objective_Location_17__c,Account_Objective_Location_18__c,
                             Account_Objective_Location_19__c,Account_Objective_Location_20__c,
                             Account_Objective_Active_1__c,Account_Objective_Active_2__c,Account_Objective_Active_3__c,Account_Objective_Active_4__c,Account_Objective_Active_5__c,Account_Objective_Active_6__c,Account_Objective_Active_7__c,
                             Account_Objective_Active_8__c,Account_Objective_Active_9__c,Account_Objective_Active_10__c,Account_Objective_Active_11__c,Account_Objective_Active_12__c,Account_Objective_Active_13__c,Account_Objective_Active_14__c,
                             Account_Objective_Active_15__c,Account_Objective_Active_16__c,Account_Objective_Active_17__c,Account_Objective_Active_18__c,Account_Objective_Active_19__c,Account_Objective_Active_20__c,
                           Strategic_Initiative_Active_1__c,Strategic_Initiative_Active_2__c,Strategic_Initiative_Active_3__c,Strategic_Initiative_Active_4__c,Strategic_Initiative_Active_5__c,Strategic_Initiative_Active_6__c,Strategic_Initiative_Active_7__c,
                             Strategic_Initiative_Active_8__c,Strategic_Initiative_Active_9__c,Strategic_Initiative_Active_10__c,Strategic_Initiative_Active_11__c,Strategic_Initiative_Active_12__c,Strategic_Initiative_Active_13__c,Strategic_Initiative_Active_14__c,
                             Strategic_Initiative_Active_15__c,Strategic_Initiative_Active_16__c,Strategic_Initiative_Active_17__c,Strategic_Initiative_Active_18__c,Strategic_Initiative_Active_19__c,Strategic_Initiative_Active_20__c,                             
                           Strategic_Initiative_11__c,Strategic_Initiative_12__c,Strategic_Initiative_13__c,Strategic_Initiative_14__c,Strategic_Initiative_15__c,Strategic_Initiative_16__c,Strategic_Initiative_17__c,
                           Strategic_Initiative_18__c,Strategic_Initiative_19__c,Strategic_Initiative_20__c,TE_Inside_Account_Plan__c
                             from Account_Plan__c where Id =: apOld.Id];
        
        list<Account_Plan__c> list_new = new list<Account_Plan__c>();
      list_new.add(apNew2);
      
      map<Id, Account_Plan__c> map_old = new map<Id, Account_Plan__c>();
      map_old.put(apOld2.Id,apOld2);
      
      set<date> set_date = new set<date>();
      set_date.add(system.today());
      
      Test.startTest();
      
      ClsAccountPlanUtility.getRateMap();
        ClsAccountPlanUtility.replicateAccountPlan2ACustomer(list_new, null);
        ClsAccountPlanUtility.replicateAccountPlan2ACustomer(list_new, map_old);
        ClsAccountPlanUtility.setNumberFormat('de', 1003, true);
        ClsAccountPlanUtility.setNumberFormat('en', 90, false);
        ClsAccountPlanUtility.getCorrespondingFiscalQuarter(set_date);
        
        system.assert(true);
        Test.stopTest();
    }
}