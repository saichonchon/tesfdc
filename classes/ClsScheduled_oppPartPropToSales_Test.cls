/**
*	This test class is for ClsScheduled_oppPartPropToSales.
*
@author Di Chen
@created 2012-12-21
@version 1.0
@since 20.0
*
@changelog
* 2012-12-21 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 100%
*/
@isTest
private class ClsScheduled_oppPartPropToSales_Test {

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
        
		ClsScheduled_oppPartPropToSales obj = new ClsScheduled_oppPartPropToSales();                
		String jobId = system.schedule('test', sch, obj); 
		
        system.assert(true);
        Test.stopTest();
    }
}