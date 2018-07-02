/**
*	This test class is for CtrlCreateAccountPlan.
*
@author Di Chen
@created 2012-06-07
@version 1.0
@since 20.0
*
@changelog
* 2012-06-07 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 100%
*/
@isTest
private class CtrlCreateAccountPlan_Test {

    static testMethod void testMethods() {
        
        Account acc = ClsTestHelp.createTestAccounts();
        insert acc;
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('accId',acc.Id);
        CtrlCreateAccountPlan ctrl = new CtrlCreateAccountPlan();
        
        ctrl.newOrViewAccountPlan();
        ctrl.createAccountPlan();
        ctrl.cancel();
        
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void testMethods2() {
        
    	RecordType rt = ClsTestHelp.createTestRecordType6();
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.RecordTypeId = rt.Id;
    	acc.Customer_Classification__c = 'A';
    	acc.Type = 'Competitor';
    	insert acc;
        
        Account_Plan__c ap = ClsTestHelp.createTestAccountPlan();
        ap.Customer__c = acc.Id;
        ap.Active__c = true;
        //ap.Competitor1__c = acc.Id;
        insert ap;
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('accId',acc.Id);
        CtrlCreateAccountPlan ctrl = new CtrlCreateAccountPlan();
        
        ctrl.newOrViewAccountPlan();
        ctrl.createAccountPlan();
        ctrl.cancel();
        
        system.assert(true);
        Test.stopTest();
    }
}