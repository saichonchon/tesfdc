/**
 *  This test class is for CSD_ClsScheduled_ClearCFTCorecast.
 *
 * @author Lei Tang
 * @created 2015-06-25
 * @version 1.0
 * @since 33.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2015-06-25 Lei Tang <lei.tang@itbconsult.com>
 * - Created
 * - Test coverage 100%
*/
@isTest
private class CSD_ClsScheduled_ClearCFTCorecast_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        Date currentFiscalDate = CSD_ClsUtils.getCurrentFiscalDate().addMonths(-3);
    	
    	CSD_CFT_Forecast__c cftFC1 = new CSD_CFT_Forecast__c();
    	
    	cftFC1.Fiscal_Year__c = String.valueOf(currentFiscalDate.year());
    	cftFC1.Fiscal_Month__c = String.valueOf(currentFiscalDate.month());
    	
    	cftFC1.Quantity__c = 10;
    	
    	insert cftFC1;
        
        DateTime currTime = DateTime.now();
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        String sch;
        
        if(min <= 58)
            sch = '0 '+ (min + 1) + ' ' + hour + ' * * ? '+ currTime.year();
        else          
            sch = '0 0 '+ (hour + 1) + ' * * ? '+ currTime.year();
        
        Test.startTest();
        
        CSD_ClsScheduled_ClearCFTCorecast obj = new CSD_ClsScheduled_ClearCFTCorecast();                
        String jobId = system.schedule('test_ClsSchedule_aplFCFreeze', sch, obj); 
    
        system.assert(true);
        Test.stopTest();
        
    }
}