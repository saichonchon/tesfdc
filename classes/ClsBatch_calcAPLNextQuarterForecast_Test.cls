/**
*  This test class used to test class ClsBatch_calcAPLNextQuarterForecast.
*
@author Lili Zhao
@created 2014-08-13
*
@changelog
* coverage  95%
*  
2014-08-13 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest 
private class ClsBatch_calcAPLNextQuarterForecast_Test {

    static testMethod void testMethod1() {
    	
    	Test.startTest();
        ClsBatch_calcAPLNextQuarterForecast cls1 = new ClsBatch_calcAPLNextQuarterForecast();
	    database.executeBatch(cls1);	    
	    Test.stopTest();
    }
    static testMethod void testMethod2() {
    	
    	Test.startTest();
        ClsBatch_calcAPLNextQuarterForecast cls1 = new ClsBatch_calcAPLNextQuarterForecast();
        cls1.currentQuarter = '01';
        cls1.currentYear= '2014';
	    database.executeBatch(cls1);	    
	    Test.stopTest();
    }
    static testMethod void testMethod3() {
    	
    	Test.startTest();
        ClsBatch_calcAPLNextQuarterForecast cls1 = new ClsBatch_calcAPLNextQuarterForecast();
        cls1.currentQuarter = '02';
        cls1.currentYear = '2014';
	    database.executeBatch(cls1);	    
	    Test.stopTest();
    }
    static testMethod void testMethod4() {
    	
    	Test.startTest();
        ClsBatch_calcAPLNextQuarterForecast cls1 = new ClsBatch_calcAPLNextQuarterForecast();
        cls1.currentQuarter = '03';
        cls1.currentYear = '2014';
	    database.executeBatch(cls1);	    
	    Test.stopTest();
    }
    static testMethod void testMethod5() {
    	
    	Test.startTest();
        ClsBatch_calcAPLNextQuarterForecast cls1 = new ClsBatch_calcAPLNextQuarterForecast();
        cls1.currentQuarter = '04';
        cls1.currentYear = '2014';
	    database.executeBatch(cls1);	    
	    Test.stopTest();
    }
}