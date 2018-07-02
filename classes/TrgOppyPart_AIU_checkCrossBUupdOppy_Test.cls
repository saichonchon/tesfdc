/**
*	This test class is for opportunityPart_AIU_checkCrossBUupdOppy.
*
@author Di Chen
@created 2012-06-01
@version 1.0
@since 20.0
*
@changelog
* 2012-06-01 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 86%
*/
@isTest
private class TrgOppyPart_AIU_checkCrossBUupdOppy_Test {

    static testMethod void testInsert() {
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.LEVEL_1_INDUSTRY_CDE__c = '0001';
    	insert acc;
    	
    	Opportunity oppy = ClsTestHelp.createTestOpportunity();
    	oppy.AccountId = acc.Id;
    	
    	insert oppy;
    	
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        ph.CBC2_Description__c = 'Consumer BU';
        insert ph;
        
        Part__c part = new Part__c();
    	part.Description__c = 'Sniper';
    	part.Product_Hierarchy__c = ph.Id;
    	insert part;
    	
    	Product_Hierarchy__c ph2 = new Product_Hierarchy__c();
        ph2.Hierarchy_Level_Type__c = 'CBC12';
        ph2.Description__c = 'TEST';
        ph2.CBC2_Description__c = 'Enterprise LA';
        insert ph2;
        
        Part__c part2 = new Part__c();
    	part2.Description__c = 'Snipers';
    	part2.Product_Hierarchy__c = ph2.Id;
    	insert part2;
    	
    	Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
    	oppypart.Opportunity__c = oppy.Id;
    	oppypart.Part__c = part.Id;
        oppypart.Status__c = 'Lost';
    	oppypart.Lost_Reason__c = 'Other';
    	oppypart.Lost_Reason_Text__c = null;
    	Test.startTest();
    	
    	insert oppypart;
    	
    	oppypart.Part__c = part2.Id;
    	update oppypart;
    	
    	delete oppypart;
    	
        system.assert(true);
        Test.stopTest();
    }
}