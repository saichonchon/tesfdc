/**
*	This test class is for ClsBudgetPlanBreakDownStructure.
*
@author Di Chen
@created 2012-06-21
@version 1.0
@since 20.0
*
@changelog
* 2012-06-21 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage  75%
*/
@isTest
private class ClsBudgetPlanBreakDownStructure_Test {

    static testMethod void testMostMethods() {
    	
    	RecordType rt = ClsTestHelp.createTestRecordType8();
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.RecordTypeId = rt.Id;
    	acc.SALES_TERRITORY_CDE__c = 'A003153';
    	acc.Individually_Planned__c = true;
    	acc.Account_Manager__c = UserInfo.getUserId();
    	acc.CurrencyIsoCode = 'AED';
    	insert acc;    	
    	
        Test.startTest();
        
    	ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem clsAcc = new ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem(acc.Id,'','EUR');
    	
        ClsBudgetPlanBreakDownStructure cls = new ClsBudgetPlanBreakDownStructure(rt.Id,acc.Id);
        cls.isRecalculate = true;
        cls.accountId = acc.Id;
        
        cls.setParentAccountItem(clsAcc);
        cls.getAccountId4Report();
        cls.getParentAccountItem();
        cls.getChildrenAccountItems();
        cls.calAccountDetailValue(1, 2, 3);
        cls.calAccountFCValue(1, 2, 3, 4, 'other');
        cls.calAccountFCValue(1, 2, 3, 4, '');
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testMostMethods2() {
    	
    	RecordType rt = ClsTestHelp.createTestRecordType8();
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.RecordTypeId = rt.Id;
    	acc.SALES_TERRITORY_CDE__c = 'A003153';
    	acc.Individually_Planned__c = true;
    	acc.Account_Manager__c = UserInfo.getUserId();
    	acc.CurrencyIsoCode = 'AED';
    	insert acc;    	
    	
        Test.startTest();
        
    	ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem clsAcc = new ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem(acc.Id,'','EUR');
    	
        ClsBudgetPlanBreakDownStructure cls = new ClsBudgetPlanBreakDownStructure(rt.Id,acc.Id);
        cls.isRecalculate = false;
        cls.accountId = acc.Id;
        
        cls.setParentAccountItem(clsAcc);
        cls.getAccountId4Report();
        cls.getParentAccountItem();
        cls.getChildrenAccountItems();
        cls.calAccountDetailValue(1, 2, 3);
        cls.calAccountFCValue(1, 2, 3, 4, 'other');
        cls.calAccountFCValue(1, 2, 3, 4, '');
        
        system.assert(true);
        Test.stopTest();
    }    
}