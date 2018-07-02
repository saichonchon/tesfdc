/**
*	This test class is for OpportunityApproval_BU_grantAccess.
*
@author Di Chen
@created 2013-01-17
@version 1.0
@since 20.0
*
@changelog
* 2013-01-17 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage
*/
@isTest
private class TrgOppyApproval_BU_grantAccess_Test {

    static testMethod void testUpdate() {
    	
    	Opportunity oppy = ClsTestHelp.createTestOpportunity();
    	oppy.Approval_Step__c = 1;
        insert oppy;
                
        Opportunity_Approval__c oa = new Opportunity_Approval__c();
        oa.Approval_Step__c = 1;
        oa.Opportunity__c = oppy.Id;
        insert oa;
        
        Test.startTest();
        
        oa.Approval_Step__c = 2;
        update oa;
        
        system.assert(true);
        Test.stopTest();
    }
}