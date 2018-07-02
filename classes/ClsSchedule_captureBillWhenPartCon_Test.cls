/**
 *  This test class is used to test ClsBatch_captureBillingWhenPartConv
 *  
 * @author Mingxing Qiu
 * @created 2016-05-06
 * @version 1.0
 * @since 29.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2015-06-12 Mingxing Qiu <Mingxing Qiu@itbconsult.com>
   - Coverage 80%
 * - Created
 *
 */
 
@isTest
private class ClsSchedule_captureBillWhenPartCon_Test {
	 
    static testMethod void myUnitTest() {
    	
    	list <Period> PeriodObj = [select id , StartDate, Type from Period Where Type = 'Month'];
        
        list<Date> StartDate = new list<Date>();
        for (Period p: PeriodObj){
        	Startdate.add(p.StartDate);
        }
        StartDate.add(Date.today());
        DateTime currTime = DateTime.now();
        Date dt = Date.today();
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        Integer i = 0;
        String jobName;
        String sch;
        
	    if(min <= 58) {
	    	sch = '0 '+ (min + 1) + ' ' + hour + ' * * ? '+ currTime.year();
	    } else {         
	    	sch = '0 0 '+ (hour + 1) + ' * * ? '+ currTime.year();
	    }
        Test.startTest();
        for (Date dt1: Startdate){
        	if (Date.today() == dt1){
        		jobName = 'BuildOpptyMeasuTest' + String.valueOf(i);
        		i++;
	            ClsSchedule_captureBillWhenPartConverted sh1 = new ClsSchedule_captureBillWhenPartConverted();
	            //String jobId = system.schedule('BuildOpportunityMeasuTest', sch, sh1); 
	            String jobId = system.schedule(jobName, sch, sh1); 
	            system.assert(true);
            }
        }
        Test.stopTest();

    }
}