@isTest(seealldata=false)
private class CtrlBudgetPlanningEmail_Test {
	static testMethod void TestCtrlBudgetPlanningEmail() {
        test.startTest();
        
        CtrlBudgetPlanningEmail objEmailcls = new CtrlBudgetPlanningEmail();
        objEmailcls.BudgetId = userinfo.getUserId();
        objEmailcls.EmailType = 'Test Email';
        
        test.stopTest();
    }
}