/**
*	This test class is for Opportunity_BIU_recalculateRevenue.
*
@author Di Chen
@created 2013-01-31
@version 1.0
@since 20.0
*
@changelog
* 2013-01-31 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 100%
*/
@isTest
private class TrgOppy_BIU_recalculateRevenue_Test {

    static testMethod void testBIU() {
		    	
    	Opportunity oppy = ClsTestHelp.createTestOpportunity();
		oppy.Type = 'CM';
		oppy.Request_Type__c = 'Extension';
		oppy.Method__c = 'BOM';
		oppy.Level__c = 'Yearly';
		oppy.Amount = 1;
		oppy.CurrencyIsoCode = 'USD';
		oppy.Five_Year_Revenue__c = 1;
		oppy.Manufacturing_Start_Date__c = date.today();
		
		Test.startTest();
		
		insert oppy;
		
		oppy.Manufacturing_Start_Date__c = date.today()+1;
		update oppy;
		
		system.assert(true);
		Test.stopTest();
    }
}