/**
*	This test class is for ACustomerTrigger.
*
@author Di Chen
@created 2012-08-07
@version 1.0
@since 20.0
*
@changelog
* 2012-08-07 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 80%
*/
@isTest
private class ACustomerTrigger_Test {

    static testMethod void testMostMethods() {
    	
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
    	
    	A_Customer_Profile__c Acust2 = new A_Customer_Profile__c();
    	
    	A_Customer_Profile__c ACust3 = new A_Customer_Profile__c();
    	ACust3.Name='Test3';
    	ACust3.Sales_Breakdown_1_Percent__c=40;
    	ACust3.Sales_Breakdown_2_Percent__c=50;
    	ACust3.Sales_Breakdown_3_Percent__c=5;
    	ACust3.Sales_Breakdown_4_Percent__c=3;
    	ACust3.Sales_Breakdown_5_Percent__c=2;
        ACust3.BU_Customer_Plan__c=bucust.id;
        ACust3.Account_Definition__c='test';
        ACust3.Sales_Figures_Makeup__c='test';
        ACust3.Industry_Segment__c='test';
        ACust3.Key_Product_Percent_Title__c='test';
        ACust3.Key_Product_1__c='test';
        ACust3.Key_Product_1_Outlook__c='test';
        ACust3.Key_Product_1_Pct__c=10;
        ACust3.TE_Performance_Status__c='test';
        ACust3.TE_Revenue_Prior_Yr_Actual_M__c=10;
        ACust3.TE_Revenue_YTD_Actual_M__c=10;
        ACust3.TE_Revenue_CY_Forecast_M__c=10;
        ACust3.TE_Revenue_Fcst_Plan_Yr_M__c=10;
        ACust3.TE_Revenue_Fcst_Plan_Yr_1_M__c=10;
        ACust3.TE_Revenue_Fcst_Plan_Yr_4_M__c=10;
        ACust3.BU_Revenue_Prior_Yr_Actual_M__c=10;
        ACust3.BU_Revenue_YTD_Actual_M__c=10;
        ACust3.BU_Revenue_CY_Forecast_M__c=10;
        ACust3.BU_Revenue_Fcst_Plan_Yr_M__c=10;
        ACust3.BU_Revenue_Fcst_Plan_Yr_1_M__c=10;
        ACust3.BU_Revenue_Fcst_Plan_Yr_4_M__c=10;
        ACust3.Revenue_TAM_SAM__c='test';
        ACust3.TAM_Prior_Yr_M__c=10;
        ACust3.TAM_Plan_Year_M__c=10;
        ACust3.TAM_Plan_Yr_1_M__c=10;
        ACust3.TAM_Plan_Yr_4_M__c=10;
        ACust3.Sales_Breakdown_1_Description__c='test';
        ACust3.Sales_Breakdown_2_Description__c='test';
        ACust3.Executive_Relationship__c='test';
        ACust3.Purchasing_Relationship__c='test';
        ACust3.Engineering_Relationship__c='test';
        ACust3.Competitor_1__c='test';
        ACust3.Competitor_1_Market_Share__c=10;
        ACust3.Competitor_1_MS_Trend__c='test';
        ACust3.Account_Objective_1__c='test';
        ACust3.Strategic_Initiative_1__c='test';
        ACust3.Strategic_Initiative_1_Target__c='test';
        ACust3.Strategic_Initiative_1_Status__c='test';
        ACust3.Plan_Year__c='2011';
        ACust3.Total_Revenue_M_Plan_Yr_1__c=10;
        ACust3.Total_Revenue_M_Plan_Yr_2__c=10;
        ACust3.Total_Revenue_M_Plan_Yr_3__c=10;
        ACust3.Customer_Type__c = 'A Customer';
        ACust3.Approval_Status__c = 'Approved'; 
        insert ACust3;
    	
    	list<A_Customer_Profile__c> list_acust1 = new list<A_Customer_Profile__c>();
    	list_acust1.add(ACust1);
    	
    	list<A_Customer_Profile__c> list_acust2 = new list<A_Customer_Profile__c>();
    	list_acust1.add(ACust2);
    	
    	list<A_Customer_Profile__c> list_acust3 = new list<A_Customer_Profile__c>();
    	list_acust1.add(ACust3);
    	
    	
        Test.startTest();
        
        ACustomerTrigger.BUlookupfromACTrigger(list_acust2, list_acust3);
        ACustomerTrigger.BUlookupfromACTrigger(list_acust1, list_acust3);
        
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void testMostMethods2() {
    	
    	BU_Customer_Plan__c bucust = new BU_Customer_Plan__c(Business_Unit__c='Test BU',Disappointments_Challenges__c='test',Industry_Summary__c='test',Market_Trends__c='test',Momentum__c='test',Plan_Year__c='2011',Unique_BU_Year__c='test');
        insert bucust;
        
        
        list<A_Customer_Profile__c> list_acust1 = new list<A_Customer_Profile__c>();
        for(Integer i = 0; i<= 2; i++){
	    	A_Customer_Profile__c ACust1 = new A_Customer_Profile__c();
	    	ACust1.Name='Test1' + i;
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
	        ACust1.TE_Performance_Status__c='tests';
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
	        ACust1.Monthly_Update__c = 'ooo';
	        list_acust1.add(ACust1);
        }
        insert list_acust1;
    	
    	A_Customer_Profile__c Acust2 = new A_Customer_Profile__c();
    	
    	list<A_Customer_Profile__c> list_acust3 = new list<A_Customer_Profile__c>();
    	for(Integer j = 0; j < = 5; j++){
	    	A_Customer_Profile__c ACust3 = new A_Customer_Profile__c();
	    	ACust3.Name='hye' + j;
	    	ACust3.Sales_Breakdown_1_Percent__c=40;
	    	ACust3.Sales_Breakdown_2_Percent__c=50;
	    	ACust3.Sales_Breakdown_3_Percent__c=5;
	    	ACust3.Sales_Breakdown_4_Percent__c=3;
	    	ACust3.Sales_Breakdown_5_Percent__c=2;
	        ACust3.BU_Customer_Plan__c=bucust.id;
	        ACust3.Account_Definition__c='test';
	        ACust3.Sales_Figures_Makeup__c='test';
	        ACust3.Industry_Segment__c='test';
	        ACust3.Key_Product_Percent_Title__c='test';
	        ACust3.Key_Product_1__c='test';
	        ACust3.Key_Product_1_Outlook__c='test';
	        ACust3.Key_Product_1_Pct__c=10;
	        ACust3.TE_Performance_Status__c='test';
	        ACust3.TE_Revenue_Prior_Yr_Actual_M__c=10;
	        ACust3.TE_Revenue_YTD_Actual_M__c=10;
	        ACust3.TE_Revenue_CY_Forecast_M__c=10;
	        ACust3.TE_Revenue_Fcst_Plan_Yr_M__c=10;
	        ACust3.TE_Revenue_Fcst_Plan_Yr_1_M__c=10;
	        ACust3.TE_Revenue_Fcst_Plan_Yr_4_M__c=10;
	        ACust3.BU_Revenue_Prior_Yr_Actual_M__c=10;
	        ACust3.BU_Revenue_YTD_Actual_M__c=10;
	        ACust3.BU_Revenue_CY_Forecast_M__c=10;
	        ACust3.BU_Revenue_Fcst_Plan_Yr_M__c=10;
	        ACust3.BU_Revenue_Fcst_Plan_Yr_1_M__c=10;
	        ACust3.BU_Revenue_Fcst_Plan_Yr_4_M__c=10;
	        ACust3.Revenue_TAM_SAM__c='test';
	        ACust3.TAM_Prior_Yr_M__c=10;
	        ACust3.TAM_Plan_Year_M__c=10;
	        ACust3.TAM_Plan_Yr_1_M__c=10;
	        ACust3.TAM_Plan_Yr_4_M__c=10;
	        ACust3.Sales_Breakdown_1_Description__c='test';
	        ACust3.Sales_Breakdown_2_Description__c='test';
	        ACust3.Executive_Relationship__c='test';
	        ACust3.Purchasing_Relationship__c='test';
	        ACust3.Engineering_Relationship__c='test';
	        ACust3.Competitor_1__c='test';
	        ACust3.Competitor_1_Market_Share__c=10;
	        ACust3.Competitor_1_MS_Trend__c='test';
	        ACust3.Account_Objective_1__c='test';
	        ACust3.Strategic_Initiative_1__c='test';
	        ACust3.Strategic_Initiative_1_Target__c='test';
	        ACust3.Strategic_Initiative_1_Status__c='test';
	        ACust3.Plan_Year__c='2011';
	        ACust3.Total_Revenue_M_Plan_Yr_1__c=10;
	        ACust3.Total_Revenue_M_Plan_Yr_2__c=10;
	        ACust3.Total_Revenue_M_Plan_Yr_3__c=10;
	        ACust3.Customer_Type__c = 'A Customer';
	        ACust3.Approval_Status__c = 'Approved'; 
	        ACust3.Monthly_Update__c = 'xxx';
	        Acust3.Strategic_Initiative_2__c = 'xx';
	        Acust3.Strategic_Initiative_2_Status__c = null;
	        Acust3.Strategic_Initiative_2_Target__c = null;
	        Acust3.Strategic_Initiative_3__c = 'xx';
	        Acust3.Strategic_Initiative_3_Status__c = null;
	        Acust3.Strategic_Initiative_3_Target__c = null;
	        Acust3.Strategic_Initiative_4__c = 'xx';
	        Acust3.Strategic_Initiative_4_Status__c = null;
	        Acust3.Strategic_Initiative_4_Target__c = null;
	        Acust3.Strategic_Initiative_5__c = 'xx';
	        Acust3.Strategic_Initiative_5_Status__c = null;
	        Acust3.Strategic_Initiative_5_Target__c = null;
	        Acust3.Strategic_Initiative_6__c = 'xx';
	        Acust3.Strategic_Initiative_6_Status__c = null;
	        Acust3.Strategic_Initiative_6_Target__c = null;
	        Acust3.Strategic_Initiative_7__c = 'xx';
	        Acust3.Strategic_Initiative_7_Status__c = null;
	        Acust3.Strategic_Initiative_7_Target__c = null;
	        Acust3.Strategic_Initiative_8__c = 'xx';
	        Acust3.Strategic_Initiative_8_Status__c = null;
	        Acust3.Strategic_Initiative_8_Target__c = null;
	        Acust3.Strategic_Initiative_9__c = 'xx';
	        Acust3.Strategic_Initiative_9_Status__c = null;
	        Acust3.Strategic_Initiative_9_Target__c = null;
	        Acust3.Strategic_Initiative_10__c = 'xx';
	        Acust3.Strategic_Initiative_10_Status__c = null;
	        Acust3.Strategic_Initiative_10_Target__c = null;
	        list_acust3.add(ACust3);
    	}
    	insert list_acust3;
    	
    	list<A_Customer_Profile__c> list_acust2 = new list<A_Customer_Profile__c>();
    	list_acust1.add(ACust2);
    	
    	A_Customer_Profile_Attachment__c acp = new A_Customer_Profile_Attachment__c();
    	acp.A_Customer_Profile__c = list_acust3[0].Id;
    	acp.Name = 'te';
    	insert acp;
    	
    	list<A_Customer_Profile_Attachment__c> list_ac = new list<A_Customer_Profile_Attachment__c>();
    	list_ac.add(acp);
    	
        Test.startTest();
        ACustomerTrigger.BUlookupfromACTrigger(list_acust2, list_acust3);
        ACustomerTrigger.BUlookupfromACTrigger(list_acust1, list_acust3);
        ACustomerTrigger.RevenueSectionUpdate(list_acust1,list_acust3);
        ACustomerTrigger.MonthlyUpdateUpdate(list_acust1,list_acust3);
        ACustomerTrigger.ThrowStrategicInitiativeError(list_acust3);
        ACustomerTrigger.FlagUpdateStatusOnCustomerProfile(list_ac);
        system.assert(true);
        Test.stopTest();
    }
}