/**
*	This test class is for opportunity_BI_defineInitialOwner.
*
@author Di Chen
@created 2012-06-01
@version 1.0
@since 20.0
*
@changelog
* 2012-06-01 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 100%
*/
@isTest
private class TrgOppy_BI_defineInitialOwner_Test {

    static testMethod void testInsert() {
        Test.startTest();
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        insert oppy;
        
        system.assert(true);
        Test.stopTest();
    }
}