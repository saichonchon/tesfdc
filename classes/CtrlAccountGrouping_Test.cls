/**
*  This test class used to test class ClsGroupingAMForecastUtil.
*
@author Lili Zhao
@created 2014-08-20
*
@changelog
* coverage  76%
*  
2014-08-15 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest
private class CtrlAccountGrouping_Test {

    static testMethod void myUnitTest() {
        Test.startTest();
    	
    	CtrlAccountGrouping ctrlAccountGrouping = new CtrlAccountGrouping();
    	
    	ctrlAccountGrouping.getlist_currencyIsoCodes();
    	
    	ctrlAccountGrouping.nextForecast();
    	ctrlAccountGrouping.backForecast();
    	ctrlAccountGrouping.updateAPLSalesFCForSave();
    	ctrlAccountGrouping.updateAPLSalesFCForNext();
        ctrlAccountGrouping.pageConf.isrelay = true;
        ctrlAccountGrouping.updateAPLSalesFCForNext();
    	ctrlAccountGrouping.removeRelayOtherFCForSave();
    	ctrlAccountGrouping.removeRelayOtherFCForNext();
    	ctrlAccountGrouping.getThis();
    	ctrlAccountGrouping.frozenNext();
    	
    	
    	ctrlAccountGrouping.ForecastCtrl ForecastCtrl = new ctrlAccountGrouping.ForecastCtrl();
    	ctrlAccountGrouping.PageConfig PageConfig = new ctrlAccountGrouping.PageConfig();
    	PageConfig.isFrozen = false;
    	ctrlAccountGrouping.isShowPopup = false;
    	PageConfig.territoryCode = 'test';
    	PageConfig.str_lastAcctForecastId = '';
    	
    	PageConfig.set_modifiedAcctIds.add('test');
    	ctrlAccountGrouping.init();
    	ctrlAccountGrouping.searchGroupsAccounts();
    	ctrlAccountGrouping.saveAcctGroup();
    	PageConfig.isRelay = false;
    	ctrlAccountGrouping.frozenNext();
    	PageConfig.isRelay = true;
    	ctrlAccountGrouping.frozenNext();
    	ctrlAccountGrouping.LocaleConfig LocaleConfig = new ctrlAccountGrouping.LocaleConfig();
        Test.stopTest();
    }
}