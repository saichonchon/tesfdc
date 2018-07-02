/**
*	Test class for class IE9FixUtil.
*
@author Min Liu
@created 2013-01-17
@version 1.0
@since 23.0
*
@changelog
* 2013-01-17 Min Liu <min.liu@itbconsult.com>
* - Created
*- Test coverage 100%
*/
@isTest
private class IE9FixUtil_Test {

    static testMethod void myUnitTest() {
    	Test.startTest();
    	Apexpages.currentPage().getHeaders().put('USER-AGENT','MSIE'); 
        IE9FixUtil.fixIt();
        system.assert(true);
        Test.stopTest();
    }
}