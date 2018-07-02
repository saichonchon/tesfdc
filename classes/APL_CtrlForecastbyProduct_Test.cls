/**
*  This test class used to test class APL_CtrlForecastbyProduct.
*
@author Lei Tang 
@created 2015-07-28
*
@changelog
* coverage  76%
*  
2015-07-28 Lei Tang  <lei.tang@oinio.com>
* - Created
*/
@isTest
private class APL_CtrlForecastbyProduct_Test {

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
        
        APL_CtrlForecastbyProduct ctrlAccountGrouping = new APL_CtrlForecastbyProduct();
        
        ctrlAccountGrouping.aplService = ctrlAccountGrouping.newCtrlInstance('APL_ClsAMForecastbyProductService');
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
        ctrlAccountGrouping.refreshData();
        Test.stopTest();
    }
}