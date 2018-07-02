/**
*  This test class is for ClsBatch_setLastRSMFrozenDate.
*
@author Di Chen
@created 2014-01-21
@version 1.0
@since 20.0
*
@changelog
* 2014-01-21 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage  100%
*/
@isTest
private class ClsBatch_setLastRSMFrozenDate_Test {

    static testMethod void testBatch() {
    	
        ClsTestCustomSettingHelper.getFinancialPlanningConfiguration();
    	Forecast_Definition__c fd = new Forecast_Definition__c(Region__c = 'Americas',Profit_Center__c = 'A&C',GSM__c = UserInfo.getUserId(),GSM_Name__c = '1234');
    	insert fd;
    	
        List<Manager_Forecast__c> list_BBMonths = new List<Manager_Forecast__c>();
        list_BBMonths.add(new Manager_Forecast__c(Fiscal_Year__c = '2014',Fiscal_Month__c = 2,Forecast_Definition__c = fd.Id,Forecast_USD__c = 1));
        insert list_BBMonths;    	
		Test.startTest();
		
		ClsBatch_setLastRSMFrozenDate clsBatch = new ClsBatch_setLastRSMFrozenDate();
        Database.BatchableContext BC;
        clsBatch.isUnFrozen = true;
        clsBatch.filter = ' limit 1';
        clsBatch.start(BC);
        clsBatch.execute(BC, list_BBMonths);
        clsBatch.finish(BC);
		
		system.assert(true);
		Test.stopTest();
    }
}