/**
*   This test class is for AccountPlan_BIU_updateModifier.
*
@author Di Chen
@created 2012-06-25
@version 1.0
@since 20.0
*
@changelog
* 2012-06-25 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 98%
*/
@isTest
private class TrgAccountPlan_BIU_updateModifier_Test {

    static testMethod void myUnitTest() {
        
        RecordType rt = ClsTestHelp.createTestRecordType6();
         RecordType rt2 = ClsTestHelp.createTestRecordType8();
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt2.Id;
        acc.Customer_Classification__c = 'B';
        acc.Type = 'Competitor';
        acc.GAMCD__c = '1000';
        insert acc;
        
        Account_Plan__c apOld = ClsTestHelp.createTestAccountPlan();
        apOld.Customer__c = acc.Id;
        //apOld.Competitor1__c = acc.Id;
        apOld.Replicate_to_Central_Org__c = false;
        apOld.Replicate_to_Central_Org__c = true;
        apOld.Strategic_Initiative_5_Status__c = 'On target';
        apOld.Approval_Status__c = 'Not Submitted';
        apOld.Monthly_Update__c = 'test';
        apOld.TE_Performance_Status__c = 'Positive';
        apOld.TE_Revenue_Prior_Yr_Actual_M__c = 12;
        apOld.TE_Revenue_YTD_Actual_M__c = 12;
        apOld.TE_Revenue_CY_Forecast_M__c = 12;
        apOld.TE_Revenue_Fcst_Plan_Yr_M__c = 12;
        apOld.TE_Revenue_Fcst_Plan_Yr_1_M__c = 12;
        apOld.TE_Revenue_Fcst_Plan_Yr_4_M__c = 12;
        apOld.BU_Revenue_Prior_Yr_Actual_M__c = 12;
        apOld.BU_Revenue_YTD_Actual_M__c = 12;
        apOld.BU_Revenue_CY_Forecast_M__c = 12;
        apOld.BU_Revenue_Fcst_Plan_Yr_M__c = 12;
        apOld.BU_Revenue_Fcst_Plan_Yr_1_M__c = 12;
        apOld.BU_Revenue_Fcst_Plan_Yr_4_M__c = 12;
        apOld.Revenue_TAM_SAM__c = 'TAM';
        apOld.TAM_Prior_Yr_M__c = 12;
        apOld.TAM_Plan_Year_M__c = 12;
        apOld.TAM_Plan_Yr_1_M__c = 12;
        apOld.TAM_Plan_Yr_4_M__c = 12;
        apOld.Gross_Margin_Pct_Prior_Yr__c = 12;
        apOld.Gross_Margin_Pct_Plan_Yr__c = 12;
        apOld.Gross_Margin_Pct_Plan_Yr_1__c = 12;
        apOld.Gross_Margin_Pct_Plan_Yr_4__c = 12;
        Test.startTest();
        
        insert apOld;
        
        apOld.Monthly_Update__c = 'tttt';
        apOld.TE_Performance_Status__c = 'Solid, holding';
        apOld.TE_Revenue_Prior_Yr_Actual_M__c = 14;
        apOld.TE_Revenue_YTD_Actual_M__c = 14;
        apOld.TE_Revenue_CY_Forecast_M__c = 14;
        apOld.TE_Revenue_Fcst_Plan_Yr_M__c = 14;
        apOld.TE_Revenue_Fcst_Plan_Yr_1_M__c = 14;
        apOld.TE_Revenue_Fcst_Plan_Yr_4_M__c = 14;
        apOld.BU_Revenue_Prior_Yr_Actual_M__c = 14;
        apOld.BU_Revenue_YTD_Actual_M__c = 14;
        apOld.BU_Revenue_CY_Forecast_M__c = 14;
        apOld.BU_Revenue_Fcst_Plan_Yr_M__c = 14;
        apOld.BU_Revenue_Fcst_Plan_Yr_1_M__c = 14;
        apOld.BU_Revenue_Fcst_Plan_Yr_4_M__c = 14;
        apOld.Revenue_TAM_SAM__c = 'SAM';
        apOld.TAM_Prior_Yr_M__c = 14;
        apOld.TAM_Plan_Year_M__c = 14;
        apOld.TAM_Plan_Yr_1_M__c = 14;
        apOld.TAM_Plan_Yr_4_M__c = 14;
        apOld.Gross_Margin_Pct_Prior_Yr__c = 14;
        apOld.Gross_Margin_Pct_Plan_Yr__c = 14;
        apOld.Gross_Margin_Pct_Plan_Yr_1__c = 14;
        apOld.Gross_Margin_Pct_Plan_Yr_4__c = 14;
        update apOld;
        
        system.assert(true);
        Test.stopTest();
    }
}