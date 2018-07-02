/**
*	This test class is for ClsScheduled_forecaseSnapshot.
*
@author Di Chen
@created 2013-01-14
@version 1.0
@since 20.0
*
@changelog
* 2013-01-14 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 
*/
@isTest
private class ClsScheduled_forecaseSnapshot_Test {

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
        
		ClsScheduled_forecaseSnapshot obj = new ClsScheduled_forecaseSnapshot();                
		String jobId = system.schedule('test', sch, obj); 
		
        system.assert(true);
        Test.stopTest();
    }
}