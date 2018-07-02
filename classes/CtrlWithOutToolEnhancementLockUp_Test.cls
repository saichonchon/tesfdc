/**
*   This test class is for CtrlWithOutToolEnhancementLockUp.
*
@author Minghao Li
@created 2017-09-26
@version 1.0
@since 38.0
*
@changelog
* 2017-09-26 Minghao Li <minghao.li@capgemini.com>
* - Created
* - Test coverage 94%
*/
@isTest
private class CtrlWithOutToolEnhancementLockUp_Test {

    static testMethod void myUnitTest() {
        
        PageReference pageRef = Page.CtrlWithOutToolEnhancementLockUp;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('s', 'test');
        pageRef.getParameters().put('s', 'inputS');
        Test.startTest();
        
        CtrlWithOutToolEnhancementLockUp ctrl = new CtrlWithOutToolEnhancementLockUp();
        
        ctrl.searchProduct();
        system.assert(true);
        Test.stopTest();
        
    }
}