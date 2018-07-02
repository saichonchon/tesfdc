/**
 *  This test class is for CSD_ClsBatch_clearCFTForecast.
 *
 * @author Lei Tang
 * @created 2015-01-28
 * @version 1.0
 * @since 30.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2015-01-28 Lei Tang <lei.tang@itbconsult.com>
 * - Created
 * - Test coverage 93%
*/
@isTest
private class CSD_ClsBatch_clearCFTForecast_Test {
    static testMethod void testMost() {

    	Date currentFiscalDate = CSD_ClsUtils.getCurrentFiscalDate().addMonths(-3);
    	
    	CSD_CFT_Forecast__c cftFC1 = new CSD_CFT_Forecast__c();
    	
    	cftFC1.Fiscal_Year__c = String.valueOf(currentFiscalDate.year());
    	cftFC1.Fiscal_Month__c = String.valueOf(currentFiscalDate.month());
    	
    	cftFC1.Quantity__c = 10;
    	
    	insert cftFC1;
    	Test.startTest();
    	list<CSD_CFT_Forecast__c> scrope = new list<CSD_CFT_Forecast__c>();
    	scrope.add(cftFC1);
    	CSD_ClsBatch_clearCFTForecast cls = new CSD_ClsBatch_clearCFTForecast();
        ID batchprocessid = Database.executeBatch(cls);
        
        /*Database.BatchableContext bc;
		cls.start(bc);
        cls.execute(bc, scrope);
        cls.finish(bc); */
    	Test.stopTest();
    }
}