/**
*  This test class used to test class ClsGroupingAMForecastUtil.
*
@author Lili Zhao
@created 2014-08-20
*
@changelog
* coverage  90%
*  
2014-08-15 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest
private class CtrlGroupingAMForecast_Test {

    static testMethod void myUnitTest() {
    	Test.startTest();
    	
    	CtrlGroupingAMForecast ctrlGroupingAMForecast = new CtrlGroupingAMForecast();
    	CtrlGroupingAMForecast ctrlGroupingAMForecast1 = new CtrlGroupingAMForecast('www.test.com');
    	ctrlGroupingAMForecast.initForecast();
    	ctrlGroupingAMForecast.getThis();
    	ctrlGroupingAMForecast.getAcctViewRows();
    	ctrlGroupingAMForecast.getCBC2Data();
    	ctrlGroupingAMForecast.getCBC2ViewRows();
    	ctrlGroupingAMForecast.getGPLViewRows();
    	ctrlGroupingAMForecast.getPartViewRows();
    	ctrlGroupingAMForecast.getAcctForecasts();
    	CtrlGroupingAMForecast.LocaleConfig LocaleConfig = new CtrlGroupingAMForecast.LocaleConfig();
    	CtrlGroupingAMForecast.SettingPage SettingPage = new CtrlGroupingAMForecast.SettingPage(true, 'test');
        Test.stopTest();
    }
}