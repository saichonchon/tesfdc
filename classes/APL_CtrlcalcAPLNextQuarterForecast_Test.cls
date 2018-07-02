/**
*   This test class is for APL_CompForecastBillingChart.
*
@author Lei Tang
@created 2016-07-11
@version 1.0
@since 35.0
*
@changelog
* 2016-07-11 Lei Tang <lei.tang@oinio.com>
* - Created
* - Test coverage 78%
*/
@isTest
private class APL_CtrlcalcAPLNextQuarterForecast_Test {

    static testMethod void myUnitTest() {
        Test.startTest();
        
        APL_CtrlcalcAPLNextQuarterForecast ctrl = new APL_CtrlcalcAPLNextQuarterForecast();
        ctrl.executeCalcAPLNextQuarterForecastBatch();
        
            
	    Test.stopTest();
    }
}