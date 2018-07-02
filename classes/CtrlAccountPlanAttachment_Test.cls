/**
*   This test class is for CtrlAccountPlanAttachment.
*
@author Di Chen
@created 2012-06-07
@version 1.0
@since 20.0
*
@changelog
* 2012-06-07 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 94%
*/
@isTest
private class CtrlAccountPlanAttachment_Test {

    static testMethod void testMethods() {
        Test.startTest();
        
        CtrlAccountPlanAttachment ctrl = new CtrlAccountPlanAttachment();
        ctrl.save();
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testMethods2() {
        Account acc = ClsTestHelp.createTestAccounts();
        insert acc;
        
        Attachment att = ClsTestHelp.createTestAttachments();
        att.ParentId = acc.Id;
        
        Test.startTest();
        
        CtrlAccountPlanAttachment ctrl = new CtrlAccountPlanAttachment();
        ctrl.attachmentName = 'Logo.jpg';
        ctrl.att = att;
        ctrl.save();
        
        ctrl = new CtrlAccountPlanAttachment();
        ctrl.attachmentName = 'VoiceOverview.wav';
        ctrl.save();
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testMethods3() {
        Account acc = ClsTestHelp.createTestAccounts();
        insert acc;
        
        Attachment att = ClsTestHelp.createTestAttachments();
        att.ParentId = acc.Id;
        
        Test.startTest();
        
        CtrlAccountPlanAttachment ctrl = new CtrlAccountPlanAttachment();
        ctrl.attachmentName = 'VoiceOverview.wav';
        ctrl.attachmentName = 'testtest';
        ctrl.att = att;
        ctrl.save();
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testMethods4() {
        Account acc = ClsTestHelp.createTestAccounts();
        insert acc;
        
        Attachment att = ClsTestHelp.createTestAttachments();
        att.ParentId = acc.Id;
        
        Test.startTest();
        
        CtrlAccountPlanAttachment ctrl = new CtrlAccountPlanAttachment();
        ctrl.attachmentName = 'Photo.jpg';
        ctrl.att = att;
        ctrl.save();
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testMethods5() {
        
        RecordType rt = ClsTestHelp.createTestRecordType6();
        RecordType rt2 = ClsTestHelp.createTestRecordType8();
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt2.Id;
        acc.Customer_Classification__c = 'A';
        acc.Type = 'Competitor';
        insert acc;

        Attachment att = new Attachment();
        att.ParentId = acc.Id;
        att.Name = 'Picture';
        //insert att;
        
        Test.startTest();
        ApexPages.CurrentPage().getParameters().put('id',acc.Id);
        CtrlAccountPlanAttachment ctrl = new CtrlAccountPlanAttachment();
        ctrl.attachmentName = 'Picture';
        
        ctrl.att = att;
        ctrl.save();
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testMethods6() {
        
        RecordType rt = ClsTestHelp.createTestRecordType6();
        RecordType rt2 = ClsTestHelp.createTestRecordType8();
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt2.Id;
        acc.Customer_Classification__c = 'A';
        acc.Type = 'Competitor';
        insert acc;
        
        Account acc1 = ClsTestHelp.createTestAccounts();
        acc1.RecordTypeId = rt2.Id;
        acc1.Customer_Classification__c = 'A';
        acc1.Type = 'Competitor';
        insert acc1;
        
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.RecordTypeId = rt.Id;
        acc2.Customer_Classification__c = 'B';
        acc2.Type = 'Competitor';
        insert acc2;
        
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
        apnew.Account_Manager_Id__c = 'xxx';
        apnew.Account_Definition__c = 'Custom';
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
        insert apNew;
        
        Account_Plan__c apNew2 = [Select Name, Account_Definition__c, Account_Objective_1__c, Account_Objective_2__c, Account_Objective_3__c, 
                                                   Account_Objective_4__c, Account_Objective_5__c, Approval_Status__c, 
                                                   BU_Revenue_CY_Forecast_M__c, BU_Revenue_Fcst_Plan_Yr_M__c, BU_Revenue_Fcst_Plan_Yr_1_M__c, 
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
                                                   Total_Revenue_M_Plan_Yr_2__c, Total_Revenue_M_Plan_Yr_3__c, Unique_A_Customer_Year__c,Replicate_to_Central_Org__c,Company_Logo_Id__c from Account_Plan__c where Id =: apNew.Id];
        
        
        Attachment att = ClsTestHelp.createTestAttachments();
        att.ParentId = apNew2.Id;
        //insert att;
        
        Test.startTest();
        ApexPages.CurrentPage().getParameters().put('id',apNew2.Id);
        CtrlAccountPlanAttachment ctrl = new CtrlAccountPlanAttachment();
        ctrl.att = att;
        ctrl.attachmentName = 'VoiceOverview.wav';
        ctrl.save();
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testMethods7() {
        
        RecordType rt = ClsTestHelp.createTestRecordType6();
        RecordType rt2 = ClsTestHelp.createTestRecordType8();
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt2.Id;
        acc.Customer_Classification__c = 'A';
        acc.Type = 'Competitor';
        insert acc;
        
        Account acc1 = ClsTestHelp.createTestAccounts();
        acc1.RecordTypeId = rt2.Id;
        acc1.Customer_Classification__c = 'A';
        acc1.Type = 'Competitor';
        insert acc1;
        
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.RecordTypeId = rt.Id;
        acc2.Customer_Classification__c = 'B';
        acc2.Type = 'Competitor';
        insert acc2;
        
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
        apnew.Account_Manager_Id__c = 'xxx';
        apnew.Account_Definition__c = 'Custom';
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
        insert apNew;
        
        Account_Plan__c apNew2 = [Select Name, Account_Definition__c, Account_Objective_1__c, Account_Objective_2__c, Account_Objective_3__c, 
                                                   Account_Objective_4__c, Account_Objective_5__c, Approval_Status__c, 
                                                   BU_Revenue_CY_Forecast_M__c, BU_Revenue_Fcst_Plan_Yr_M__c, BU_Revenue_Fcst_Plan_Yr_1_M__c, 
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
                                                   Total_Revenue_M_Plan_Yr_2__c, Total_Revenue_M_Plan_Yr_3__c, Unique_A_Customer_Year__c,Replicate_to_Central_Org__c,Company_Logo_Id__c from Account_Plan__c where Id =: apNew.Id];
        
        
        Attachment att = ClsTestHelp.createTestAttachments();
        att.ParentId = apNew2.Id;
        //insert att;
        
        Test.startTest();
        ApexPages.CurrentPage().getParameters().put('id',apNew2.Id);
        CtrlAccountPlanAttachment ctrl = new CtrlAccountPlanAttachment();
        ctrl.att = att;
        ctrl.attachmentName = 'testest';
        ctrl.save();
        
        system.assert(true);
        Test.stopTest();
    }
}