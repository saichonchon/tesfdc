/**
 *	This test class is for ClsScheduled_calculateOppyWithin2Years.
 *
 @author Jinbo Shan
 @created 2014-06-25
 @version 1.0
 @since 29.0
 *
 @changelog
 * 2014-06-25 Jinbo Shan<jinbo.shan@itbconsult.com>
 * - Created
 * - Test coverage 100%
 */
@isTest 
private class  ClsScheduled_calculateOppyWithin2Y_Test {
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
        
		ClsScheduled_calculateOppyWithin2Years obj = new ClsScheduled_calculateOppyWithin2Years();                
		String jobId = system.schedule('test_AMPrevForecast', sch, obj); 
		
        system.assert(true);
        Test.stopTest();
    }
}