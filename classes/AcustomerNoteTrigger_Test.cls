@isTest(Seealldata=false)
private class AcustomerNoteTrigger_Test {
    static testMethod void testAcustomerNoteTrigger() {
        test.startTest();
        
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        
        BU_Customer_Plan__c bucust = new BU_Customer_Plan__c(Business_Unit__c='Test BU',Disappointments_Challenges__c='test',Industry_Summary__c='test',Market_Trends__c='test',Momentum__c='test',Plan_Year__c='2011',Unique_BU_Year__c='test');
        insert bucust;
        
        A_Customer_Profile__c ACust1 = new A_Customer_Profile__c();
    	ACust1.Name='Test1';
    	ACust1.Sales_Breakdown_1_Percent__c=40;
    	ACust1.Sales_Breakdown_2_Percent__c=50;
    	ACust1.Sales_Breakdown_3_Percent__c=5;
    	ACust1.Sales_Breakdown_4_Percent__c=3;
    	ACust1.Sales_Breakdown_5_Percent__c=2;
        ACust1.BU_Customer_Plan__c=bucust.id;
        ACust1.Account_Definition__c='test';
        ACust1.Sales_Figures_Makeup__c='test';
        ACust1.Industry_Segment__c='test';
        ACust1.Key_Product_Percent_Title__c='test';
        ACust1.Key_Product_1__c='test';
        ACust1.Key_Product_1_Outlook__c='test';
        ACust1.Key_Product_1_Pct__c=10;
        ACust1.TE_Performance_Status__c='test';
        ACust1.TE_Revenue_Prior_Yr_Actual_M__c=10;
        ACust1.TE_Revenue_YTD_Actual_M__c=10;
        ACust1.TE_Revenue_CY_Forecast_M__c=10;
        ACust1.TE_Revenue_Fcst_Plan_Yr_M__c=10;
        ACust1.TE_Revenue_Fcst_Plan_Yr_1_M__c=10;
        ACust1.TE_Revenue_Fcst_Plan_Yr_4_M__c=10;
        ACust1.BU_Revenue_Prior_Yr_Actual_M__c=10;
        ACust1.BU_Revenue_YTD_Actual_M__c=10;
        ACust1.BU_Revenue_CY_Forecast_M__c=10;
        ACust1.BU_Revenue_Fcst_Plan_Yr_M__c=10;
        ACust1.BU_Revenue_Fcst_Plan_Yr_1_M__c=10;
        ACust1.BU_Revenue_Fcst_Plan_Yr_4_M__c=10;
        ACust1.Revenue_TAM_SAM__c='test';
        ACust1.TAM_Prior_Yr_M__c=10;
        ACust1.TAM_Plan_Year_M__c=10;
        ACust1.TAM_Plan_Yr_1_M__c=10;
        ACust1.TAM_Plan_Yr_4_M__c=10;
        ACust1.Sales_Breakdown_1_Description__c='test';
        ACust1.Sales_Breakdown_2_Description__c='test';
        ACust1.Executive_Relationship__c='test';
        ACust1.Purchasing_Relationship__c='test';
        ACust1.Engineering_Relationship__c='test';
        ACust1.Competitor_1__c='test';
        ACust1.Competitor_1_Market_Share__c=10;
        ACust1.Competitor_1_MS_Trend__c='test';
        ACust1.Account_Objective_1__c='test';
        ACust1.Strategic_Initiative_1__c='test';
        ACust1.Strategic_Initiative_1_Target__c='test';
        ACust1.Strategic_Initiative_1_Status__c='test';
        ACust1.Plan_Year__c='2011';
        ACust1.Total_Revenue_M_Plan_Yr_1__c=10;
        ACust1.Total_Revenue_M_Plan_Yr_2__c=10;
        ACust1.Total_Revenue_M_Plan_Yr_3__c=10;
        ACust1.Customer_Type__c = 'A Customer';
        ACust1.Approval_Status__c = 'Approved'; 
        insert ACust1;
        
        Note newNote = new Note(Title='Test Note',ParentId = ACust1.Id);
        insert newNote;
        
        delete newNote;
        
        Test.stopTest();
    }

}