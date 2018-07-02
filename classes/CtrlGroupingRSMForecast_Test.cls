/**
*  This test class used to test class ClsGroupingAMForecastUtil.
*
@author Lili Zhao
@created 2014-08-20
*
@changelog
* coverage  84%
*  
2014-08-15 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest
private class CtrlGroupingRSMForecast_Test {

    static testMethod void myUnitTest() {
    	
    	Test.startTest();
        
        APL_Forecast_Settings__c perm = new APL_Forecast_Settings__c();
        perm.Name = 'test';
        perm.Value__c = UserInfo.getUserId();
        perm.Is_Active__c = true; 
        perm.isLoginAsRSMView__c = true;
        insert perm;
        
        APL_RSM__c aplRsm1 = new APL_RSM__c();
        aplRsm1.Manager__c = userInfo.getUserId();
        aplRsm1.Type__c = 'Relay';
        aplRsm1.Display_Name__c = 'test2';
        insert aplRsm1;
        
        APL_RSM__c aplRsm = new APL_RSM__c();
        aplRsm.Manager__c = userInfo.getUserId();
        aplRsm.Type__c = 'AM';
        aplRsm.Display_Name__c = 'test1';
        aplRsm.APL_RSM__c = aplRsm1.Id;
        insert aplRsm;
        
        RecordType rt25 = ClsTestHelp.createTestRecordType25(); 
        APL_Forecast_Management__c apll = new APL_Forecast_Management__c();
        apll.Name = 'testName';
        apll.A6_Code__c = '123456';
        apll.Manager__c = userInfo.getUserId();  
        apll.RSM__c = aplRsm.Id;
        apll.RecordTypeId = rt25.Id;
        insert apll;
        
    	ApexPages.currentPage().getParameters().put('uid',EncodingUtil.base64Encode(Blob.valueof('Relay')));
        
        CtrlGroupingRSMForecast CtrlGroupingRSMForecast = new CtrlGroupingRSMForecast();
        
        ClsAPLEntityTypes.PageConfig pageConf = new ClsAPLEntityTypes.PageConfig();
		pageConf.set_rsmRelayDisplayNames = new set<String>();
		pageConf.set_rsmRelayDisplayNames.add('test');
		pageConf.set_rsmRelayTerritoryCodes = new set<String>();
		pageConf.set_rsmRelayTerritoryCodes.add('test');
		pageConf.map_year_quartersFuture.put('2014', new set<String>());
    	pageConf.map_year_quartersFuture.get('2014').add('04'); 
    	CtrlGroupingRSMForecast.pageConf = pageConf;
        CtrlGroupingRSMForecast.service = ClsAPLForecastUtil.newCtrlInstance(ClsAPLForecastUtil.map_RSMTYPE_INSTANCENAME.get('AM'));
        CtrlGroupingRSMForecast.initRSM();
        CtrlGroupingRSMForecast.initPage();
        CtrlGroupingRSMForecast.setTerritory();
        CtrlGroupingRSMForecast.loadTotalFC();
        CtrlGroupingRSMForecast.set_allDateItems();
        CtrlGroupingRSMForecast.setAcctViewColumns();
        CtrlGroupingRSMForecast.setCBCViewColumns();
        CtrlGroupingRSMForecast.setCBCData('AM');
        CtrlGroupingRSMForecast.setCBCData('Relay');
        CtrlGroupingRSMForecast.setGPLViewColumns();
        CtrlGroupingRSMForecast.setPartViewColumns();
        CtrlGroupingRSMForecast.getThis();
        CtrlGroupingRSMForecast.getTotalReferRow();
        CtrlGroupingRSMForecast.getRelayTotalReferRow();
        CtrlGroupingRSMForecast.getRSMTotalReferRow();
        CtrlGroupingRSMForecast.getUsersOfManagement();
        
        
        Test.stopTest();
    }
}