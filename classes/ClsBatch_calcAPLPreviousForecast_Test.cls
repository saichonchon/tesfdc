/**
*  This test class used to test class ClsBatch_calcAPLPreviousForecast.
*
@author Lili Zhao
@created 2014-08-13
*
@changelog
* coverage  90%
*  
2014-08-13 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest 
private class ClsBatch_calcAPLPreviousForecast_Test {

    
    static testMethod void testMethod1() {
        Test.startTest();
        ClsBatch_calcAPLPreviousForecast cls1 = new ClsBatch_calcAPLPreviousForecast();
	    database.executeBatch(cls1);	    
	    Test.stopTest();
    }
    
    static testMethod void testMethod2() {
        Test.startTest();
        ClsBatch_calcAPLPreviousForecast cls1 = new ClsBatch_calcAPLPreviousForecast();
        cls1.currentYear = '2014';
        cls1.currentQuarter = 1;
	    database.executeBatch(cls1);	    
	    Test.stopTest();
    }
    
    static testMethod void testMethod3() {
        Test.startTest();
        ClsBatch_calcAPLPreviousForecast cls1 = new ClsBatch_calcAPLPreviousForecast();
        cls1.currentYear = '2014';
        cls1.currentQuarter = 2;
	    database.executeBatch(cls1);	    
	    Test.stopTest();
    }
    
    static testMethod void testMethod4() {
        Test.startTest();
        ClsBatch_calcAPLPreviousForecast cls1 = new ClsBatch_calcAPLPreviousForecast();
        cls1.currentYear = '2014';
        cls1.currentQuarter = 3;
	    database.executeBatch(cls1);	    
	    Test.stopTest();
    }
    
    static testMethod void testMethod5() {
        Test.startTest();
        ClsBatch_calcAPLPreviousForecast cls1 = new ClsBatch_calcAPLPreviousForecast();
        cls1.currentYear = '2014';
        cls1.currentQuarter = 4;
	    database.executeBatch(cls1);	    
	    Test.stopTest();
    }
    
}