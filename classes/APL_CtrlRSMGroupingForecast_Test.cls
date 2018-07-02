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
private class APL_CtrlRSMGroupingForecast_Test {

    static testMethod void myUnitTest() {
        
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
        APL_Forecast_Management__c apl = new APL_Forecast_Management__c();
        apl.Name = 'testName';
        apl.A6_Code__c = '123456';
        apl.Manager__c = userInfo.getUserId();  
        apl.RSM__c = aplRsm.Id;
        apl.RecordTypeId = rt25.Id;
        insert apl;
        
        APL_Forecast_Settings__c perm = new APL_Forecast_Settings__c();
        perm.Name = 'test';
        perm.Value__c = UserInfo.getUserId();
        perm.Is_Active__c = true; 
        perm.isLoginAsRSMView__c = true;
        insert perm;
        Test.startTest();
        
        APL_CtrlRSMGroupingForecast ctrlAccountGrouping = new APL_CtrlRSMGroupingForecast();
        
        ctrlAccountGrouping.aplService = ctrlAccountGrouping.newCtrlInstance('APL_ClsRSMGroupingForecastService');
        ctrlAccountGrouping.set_territoryCodes = new set<String>();
        ctrlAccountGrouping.selectedType = 'Sales Manager';
        ctrlAccountGrouping.initGrouping();
        ctrlAccountGrouping.setRSMType();
        ctrlAccountGrouping.searchGroupsAccounts();
        ctrlAccountGrouping.setTerritory();
        ctrlAccountGrouping.getThis();
        
        
        ctrlAccountGrouping.setList_allDateItems();
        ctrlAccountGrouping.setList_RSMGroupingData();
        ctrlAccountGrouping.setTotalColumns();
        ctrlAccountGrouping.setLevel1Columns();
        ctrlAccountGrouping.setLevel2Columns();

        ctrlAccountGrouping.setLevel3Columns();
        ctrlAccountGrouping.setLevel4Columns();
        ctrlAccountGrouping.setLevel5Columns();
        ctrlAccountGrouping.renderRSMForecast();
        ctrlAccountGrouping.next();
        ctrlAccountGrouping.initRSM();
        ctrlAccountGrouping.viewASUserRSM();
        ctrlAccountGrouping.getUsersOfManagement();
        ctrlAccountGrouping.refreshData();
        ctrlAccountGrouping.saveRSMGrouping();
        Test.stopTest();
    }
}