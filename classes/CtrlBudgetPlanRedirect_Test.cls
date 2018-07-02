/**
*   This test class is for CtrlBudgetPlanRedirect.
*
@author Di Chen
@created 2012-06-07
@version 1.0
@since 20.0
*
@changelog
* 2012-06-07 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 97%
*/
@isTest(seealldata=false)
private class CtrlBudgetPlanRedirect_Test {

   static testMethod void TestCtrlBudgetPlanRedirect() {
       
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        
        RecordType rt = ClsTestHelp.createTestRecordType8();
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt.Id;
        acc.SALES_TERRITORY_CDE__c = 'A003153';
        acc.Individually_Planned__c = true;
        acc.Account_Manager__c = UserInfo.getUserId();
        insert acc;
        
        Sales_Hierarchy__c sh = new Sales_Hierarchy__c(Level_7_Territory_Code__c = 'A007357');
        insert sh;
       
        Test.startTest();
        
        CtrlBudgetPlanRedirect ctrl = new CtrlBudgetPlanRedirect();
        ctrl.deterRedirect();
        ctrl.backToView();
        ctrl.hasBudgets = true;
        
        Budget__c bg = new Budget__c(Year__c = '2012',Territory__c = sh.Id,Total_Direct_Budget_TBR_NY__c = 11,Total_Budget_TBR_NY__c = 12,Stage__c = 'Original',Manager__c = UserInfo.getUserId());
        insert bg;
        ctrl.deterRedirect();
        ctrl.list_budgets.add(bg);
        ctrl.deterRedirect();
        
        //Budget__c bg1 = new Budget__c(Year__c = String.valueOf(date.today().year()),Territory__c = sh.Id,Total_Direct_Budget_TBR_NY__c = 11,Total_Budget_TBR_NY__c = 12,Stage__c = 'Original',Manager__c = UserInfo.getUserId());
        //insert bg1;
        
        ctrl.deterRedirect();
                
        Test.stopTest();
    }
}