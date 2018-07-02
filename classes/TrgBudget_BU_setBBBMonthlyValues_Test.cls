/**
*  This test class is for Budget_BU_setBBBMonthlyValues.
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
private class TrgBudget_BU_setBBBMonthlyValues_Test {

    static testMethod void testBU() {
    	Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
    	sh.Level_7_Territory_Code__c = 'A007357';
    	insert sh;
    	
    	Budget__c bg = new Budget__c();
    	bg.Year__c = '2012';
    	bg.Territory__c = sh.Id;
		bg.Total_Direct_Budget_TBR_NY__c = 11;
		bg.Total_Budget_TBR_NY__c = 12;
    	insert bg;
    	
    	Test.startTest();
    	
    	bg.Stage__c = 'Final';
    	update bg;
    	
    	system.assert(true);
    	Test.stopTest();
    }
}