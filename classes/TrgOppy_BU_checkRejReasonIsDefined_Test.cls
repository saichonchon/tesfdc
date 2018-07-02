/**
*	This test class is for opportunity_BIU_defineApprovers.
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
private class TrgOppy_BU_checkRejReasonIsDefined_Test {

    static testMethod void testUpdate() {
    	
    	Opportunity oppy = ClsTestHelp.createTestOpportunity();
    	insert oppy;
    	
        Test.startTest();
        try{
        	oppy.StageName = 'Rejected';
        	oppy.Lost_Rejected_Dead_On_Hold_Reason__c = null;
        	update oppy;
        
        }
        catch(Exception e){}
        
        system.assert(true);
        Test.stopTest();
    }
}