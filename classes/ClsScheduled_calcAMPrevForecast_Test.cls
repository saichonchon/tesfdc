/**
 *	This test class is for ClsScheduled_calcAMPrevForecast.
 *
 @author Bin Yuan
 @created 2014-03-03
 @version 1.0
 @since 29.0
 *
 @changelog
 * 2014-03-03 Bin Yuan<bin.yuan@itbconsult.com>
 * - Created
 * - Test coverage 
 */
@isTest
private class  ClsScheduled_calcAMPrevForecast_Test {
	static testMethod void testAll() {
	
        DateTime currTime = DateTime.now();
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        String sch;
        
		if(min <= 58)
            sch = '0 '+ (min + 1) + ' ' + hour + ' * * ? '+ currTime.year();
        else          
            sch = '0 0 '+ (hour + 1) + ' * * ? '+ currTime.year();
        
        Test.startTest();
        
		ClsScheduled_calcAMPrevForecast obj = new ClsScheduled_calcAMPrevForecast();                
		String jobId = system.schedule('test_AMPrevForecast', sch, obj); 
		
        system.assert(true);
        Test.stopTest();
    }
}