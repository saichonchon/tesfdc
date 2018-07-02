/**
*  This test class used to test class ClsGroupingAMForecastUtil.
*
@author Lili Zhao
@created 2014-08-20
*
@changelog
* coverage  96%
*  
2014-08-15 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest
private class CtrlGroupingGAMForecast_Test {

    static testMethod void myUnitTest() {
    	
    	Test.startTest();
        CtrlGroupingGAMForecast CtrlGroupingGAMForecast = new CtrlGroupingGAMForecast();
        CtrlGroupingGAMForecast.initGAM();
        CtrlGroupingGAMForecast.getList_allDateItems();
        CtrlGroupingGAMForecast.getRegionViewColumns();
        CtrlGroupingGAMForecast.getAcctViewColumns();
        CtrlGroupingGAMForecast.getCBCViewColumns();
        CtrlGroupingGAMForecast.getCBCData();
        CtrlGroupingGAMForecast.getGPLViewColumns();
        CtrlGroupingGAMForecast.getPartViewColumns();
        CtrlGroupingGAMForecast.getThis();
        
        Test.stopTest();
    }
}