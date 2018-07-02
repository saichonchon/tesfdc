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
private class CtrlGroupingRelayForecast_Test {

    static testMethod void myUnitTest() {
        Test.startTest();
        
        CtrlGroupingRelayForecast CtrlGroupingRelayForecast = new CtrlGroupingRelayForecast();
        CtrlGroupingRelayForecast CtrlGroupingRelayForecast1 = new CtrlGroupingRelayForecast('test');
        CtrlGroupingRelayForecast.initForecast();
        CtrlGroupingRelayForecast.getThis();
        CtrlGroupingRelayForecast.getAcctForecasts();
        CtrlGroupingRelayForecast.getAcctViewRows();
        CtrlGroupingRelayForecast.getCBC2Data();
        CtrlGroupingRelayForecast.getCBC2ViewRows();
        CtrlGroupingRelayForecast.getPartViewRows();
        CtrlGroupingRelayForecast.ForecastDate ForecastDate = new CtrlGroupingRelayForecast.ForecastDate();
        CtrlGroupingRelayForecast.PageConfig PageConfig = new CtrlGroupingRelayForecast.PageConfig();
        CtrlGroupingRelayForecast.SettingPage SettingPage = new CtrlGroupingRelayForecast.SettingPage(true, 'test');
        CtrlGroupingRelayForecast.LocaleConfig LocaleConfig = new CtrlGroupingRelayForecast.LocaleConfig();
        
        Test.stopTest();
    }
}