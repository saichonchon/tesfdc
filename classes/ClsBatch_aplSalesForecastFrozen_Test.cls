/**
*  This test class used to test class ClsBatch_aplSalesForecastFrozen.
*
@author Lili Zhao
@created 2014-08-15
*
@changelog
* coverage  94%
*  
2014-08-15 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest
private class ClsBatch_aplSalesForecastFrozen_Test {

    static testMethod void myUnitTest() {
    	
    	APL_RSM__c aplRsm1 = new APL_RSM__c();
		aplRsm1.Manager__c = userInfo.getUserId();
		aplRsm1.Type__c = 'Relay';
		aplRsm1.Display_Name__c = 'test2';
		insert aplRsm1;
		
		APL_RSM__c aplRsm2 = new APL_RSM__c();
		aplRsm2.Manager__c = userInfo.getUserId();
		aplRsm2.Type__c = 'AM';
		aplRsm2.Display_Name__c = 'test1';
		aplRsm2.APL_RSM__c = aplRsm1.Id;
		insert aplRsm2;
    	
    	RecordType rt25 = ClsTestHelp.createTestRecordType25(); 
    	APL_Forecast_Management__c apl = new APL_Forecast_Management__c();
    	apl.Name = 'testName';
    	apl.A6_Code__c = '123456';
    	apl.Manager__c = userInfo.getUserId();  
    	apl.RSM__c = aplRsm2.Id;
    	apl.GAM_Code__c = '1234';
    	apl.RecordTypeId = rt25.Id;
    	insert apl;
    	
    	APL_Forecast_Management__c apl1 = new APL_Forecast_Management__c();
    	apl1.Name = 'testName1';
    	apl1.A6_Code__c = '1234567';
    	apl1.GAM_Code__c = '1234';
    	apl1.Manager__c = userInfo.getUserId();
    	apl1.RecordTypeId = rt25.Id;
    	apl1.RSM__c = aplRsm1.Id;
    	insert apl1;
    	
    	List<APL_Forecast_Management__c> list_aplFCManagements = new List<APL_Forecast_Management__c>();
    	list_aplFCManagements.add(apl);
    	list_aplFCManagements.add(apl1);
    	
		Test.startTest();
    	
        ClsBatch_aplSalesForecastFrozen clsBatch = new ClsBatch_aplSalesForecastFrozen();        
        clsBatch.isFreezeAM = true; 
		clsBatch.isFreezeGAM = true;
		clsBatch.isFreezeRSM = true;
		clsBatch.isFreezeRSMRelay = false;
		Database.BatchableContext bc;
		clsBatch.start(bc);
        clsBatch.execute(bc, list_aplFCManagements);
        clsBatch.finish(bc); 
        
        system.assert(true);
        Test.stopTest();
    }
}