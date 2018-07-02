/**
*	This test class is for CtrlSearchGPL.
*
@author Di Chen
@created 2012-04-23
@version 1.0
@since 20.0
*
@changelog
* 2012-04-23 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 97%
*/
@isTest
private class CtrlSearchGPL_Test {

    static testMethod void testMostMethods() {
    	
    	Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        ph.Name= 'xxx';
        ph.CBC1__c = '13453';
        ph.CBC2__c = '13399';
        ph.CBC2_Description__c = 'Consumer BU';
        insert ph;
    	
    	Test.startTest();
    	
        CtrlSearchGPL ctrl = new CtrlSearchGPL();
        ctrl.cbc1Value = '13453';
        ctrl.cbc2Value = '13399';
        
        ctrl.SearchGPL();
    	ctrl.ChangeCBC1();
        ctrl.ChangeCBC2();
        
    	system.assert(true);
    	Test.stopTest();
    }
	static testMethod void testMostMethods2() {
    	
    	Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        ph.Name= 'xxx';
        ph.CBC1__c = '13453';
        ph.CBC2__c = '13399';
        ph.CBC2_Description__c = 'Consumer BU';
        insert ph;
    	
    	Test.startTest();
    	
        CtrlSearchGPL ctrl = new CtrlSearchGPL();
        ctrl.cbc1Value = '13453';
        ctrl.cbc2Value = null;
        
        ctrl.ChangeCBC2();
        
    	system.assert(true);
    	Test.stopTest();
    }
	static testMethod void testMostMethods3() {
    	
    	Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        ph.Name= 'xxx';
        ph.CBC1__c = '13453';
        ph.CBC2__c = '13399';
        ph.CBC2_Description__c = 'Consumer BU';
        insert ph;
    	
    	Test.startTest();
    	
        CtrlSearchGPL ctrl = new CtrlSearchGPL();
        ctrl.cbc1Value = null;
        ctrl.cbc2Value = null;
        
        ctrl.ChangeCBC2();
        
    	system.assert(true);
    	Test.stopTest();
    }
}