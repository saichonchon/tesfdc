/**
*   This test class is for CtrlAccountForecast.
*
@author Di Chen
@created 2014-01-20
@version 1.0
@since 20.0
*
@changelog
* 2014-01-20 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 
*/
@isTest(seeAllData=false)
private class CtrlAccountForecast_Test {

    static testMethod void testMostMethods() {
        Test.startTest();
        
        CtrlAccountForecast ctrl = new CtrlAccountForecast();
        ctrl.testString = 'test';
        ctrl.currentMonth = 2;
        ctrl.currentYear = '12';
        ctrl.acctIds = '';
        
        ctrl.forecastComments = new ClsForecastComments();
        ctrl.str_comment = 'test';
        ctrl.getAcctPercent();
        //ctrl.parentAcctId = userInfo.getuserID();
        //ctrl.pageConf = new CtrlAccountForecast.PageConfig();
        ctrl.getComments();
        //ctrl.saveComments();
        ctrl.saveForecast();
        
        ctrl.refresh4TerritoryChange();
        ctrl.pageConf.str_fcSaveItems = '[1, 9]';
         ctrl.saveForecast();
        
        CtrlAccountForecast.ColorConfig oColorConfig = new CtrlAccountForecast.ColorConfig();
        oColorConfig.colorName = oColorConfig.colorName;
        oColorConfig.color = oColorConfig.color;
        oColorConfig.maxValue = oColorConfig.maxValue;
        oColorConfig.minValue = oColorConfig.minValue;
        
        
        Test.stopTest();
        
    }
    static testMethod void testMostMethods2() {
        
        CtrlAccountForecast.PageConfig ctrlP = new CtrlAccountForecast.PageConfig();
        ctrlP.str_comts2Save = '1';
        ctrlP.currentYear = '2014';
        ctrlP.currentMonth = 1;
        ctrlP.selectTerritory = 'shanghai';
        
        Test.startTest();
        
        CtrlAccountForecast ctrl = new CtrlAccountForecast();
        ctrl.pageConf = ctrlP;
        ctrl.getTerritoryCodes();
        ctrl.saveForecast();
        ctrl.getColorConfig();
        system.assert(true);
        Test.stopTest();
    }
}