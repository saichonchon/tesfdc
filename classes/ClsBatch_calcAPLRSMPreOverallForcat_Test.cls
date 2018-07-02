/**
*  This test class used to test class ClsBatch_calcAPLRSMPreOverallForecast.
*
@author Lili Zhao
@created 2014-08-13
*
@changelog
* coverage  89%
*  
2014-08-13 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest
private class ClsBatch_calcAPLRSMPreOverallForcat_Test {

   static testMethod void testMethod1() {
        Test.startTest();
        ClsBatch_calcAPLRSMPreOverallForecast cls1 = new ClsBatch_calcAPLRSMPreOverallForecast();
	    database.executeBatch(cls1);	    
	    Test.stopTest();
    }

    static testMethod void testMethod2() {
        Test.startTest();
        ClsBatch_calcAPLRSMPreOverallForecast cls1 = new ClsBatch_calcAPLRSMPreOverallForecast();
        cls1.currentYear = '2014';
        cls1.currentQuarter = 1;
	    database.executeBatch(cls1);	    
	    Test.stopTest();
    }
    
    static testMethod void testMethod3() {
        Test.startTest();
        ClsBatch_calcAPLRSMPreOverallForecast cls1 = new ClsBatch_calcAPLRSMPreOverallForecast();
        cls1.currentYear = '2014';
        cls1.currentQuarter = 2;
	    database.executeBatch(cls1);	    
	    Test.stopTest();
    }
    
    static testMethod void testMethod4() {
        Test.startTest();
        ClsBatch_calcAPLRSMPreOverallForecast cls1 = new ClsBatch_calcAPLRSMPreOverallForecast();
        cls1.currentYear = '2014';
        cls1.currentQuarter = 3;
	    database.executeBatch(cls1);	    
	    Test.stopTest();
    }
    
    static testMethod void testMethod5() {
        Test.startTest();
        ClsBatch_calcAPLRSMPreOverallForecast cls1 = new ClsBatch_calcAPLRSMPreOverallForecast();
        cls1.currentYear = '2014';
        cls1.currentQuarter = 4;
	    database.executeBatch(cls1);	    
	    Test.stopTest();
    }
}