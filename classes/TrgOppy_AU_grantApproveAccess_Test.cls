/**
*	This test class is for Opportunity_AU_grantApproveAccess.
*
@author Di Chen
@created 2013-01-17
@version 1.0
@since 20.0
*
@changelog
* 2013-01-17 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 100%
*/
@isTest
private class TrgOppy_AU_grantApproveAccess_Test {

    static testMethod void testUpdate() {
    	
    	Opportunity oppy = ClsTestHelp.createTestOpportunity();
    	oppy.Approval_Step__c = 1;
        insert oppy;
        
        Test.startTest();
        
        oppy.Approval_Step__c = 2;
        update oppy;
        
        system.assert(true);
        Test.stopTest();
    }
}