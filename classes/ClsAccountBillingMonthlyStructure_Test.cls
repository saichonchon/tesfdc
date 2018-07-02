/**
*	This test class is for ClsAccountBillingMonthlyStructure.
*
@author Di Chen
@created 2012-05-31
@version 1.0
@since 20.0
*
@changelog
* 2012-05-31 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 100%
*/
@isTest
private class ClsAccountBillingMonthlyStructure_Test {

    static testMethod void testClass() {
        Test.startTest();
        
        ClsAccountBillingMonthlyStructure cls = new ClsAccountBillingMonthlyStructure();
        ClsAccountBillingMonthlyStructure.AccountBillingMonthlyItem clsAcc = new ClsAccountBillingMonthlyStructure.AccountBillingMonthlyItem();
        clsAcc = cls.parent;
        List<ClsAccountBillingMonthlyStructure.AccountBillingMonthlyItem> lstchild = cls.children;
        List<ClsAccountBillingMonthlyStructure.AccountBillingMonthlyItem> lstchild1 = new List<ClsAccountBillingMonthlyStructure.AccountBillingMonthlyItem>();
        lstchild1.add(new ClsAccountBillingMonthlyStructure.AccountBillingMonthlyItem());
        lstchild1[0].accountname='test';
        lstchild1[0].Budget4Direct = 10.00;
		lstchild1[0].Budget4POS = 10.00;
		lstchild1[0].Budget4CMA = 10.00;
		lstchild1[0].Budget4Total = 10.00;	
		lstchild1[0].ForecastCY = 10.00;	
		lstchild1[0].BillingsLY = 10.00;
		lstchild1[0].BillingsCY = 10.00;
		lstchild1[0].BillingsCYRR = 10.00;
		lstchild1[0].accountId = 'test';
		lstchild1[0].isLast = true;
        
        Test.stopTest();
    }
}