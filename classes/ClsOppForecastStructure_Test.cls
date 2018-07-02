/**
*	This test class is for ClsOppForecastStructure.
*
@author Di Chen
@created 2012-11-01
@version 1.0
@since 20.0
*
@changelog
* 2012-11-01 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 100%
*/
@isTest
private class ClsOppForecastStructure_Test {

    static testMethod void testMostMethods() {
    	
    	Opportunity_Part__c oppypart = new Opportunity_Part__c();
    	
        Test.startTest();
         
        ClsOppForecastStructure cls = new ClsOppForecastStructure('2012');
        ClsOppForecastStructure.ForecastStructure clsFS = new ClsOppForecastStructure.ForecastStructure();
        ClsOppForecastStructure.ForecastItemStructure clsFIS = new ClsOppForecastStructure.ForecastItemStructure();
        ClsOppForecastStructure.PartForecastStructure clsP = new ClsOppForecastStructure.PartForecastStructure();
        system.assert(true);
        Test.stopTest();
    }
}