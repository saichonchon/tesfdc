@isTest
private class ClsScheduled_APLForecastAccuracyTest {

    static testMethod void myUnitTest() {
        DateTime currTime = DateTime.now();
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        String sch;
        
        if(min <= 58)
            sch = '0 '+ (min + 1) + ' ' + hour + ' * * ? '+ currTime.year();
        else          
            sch = '0 0 '+ (hour + 1) + ' * * ? '+ currTime.year();
        
        Test.startTest();
        
        ClsScheduled_APLForecastAccuracy obj = new ClsScheduled_APLForecastAccuracy();                
        String jobId = system.schedule('test', sch, obj); 
        
        system.assert(true);
        Test.stopTest();
    }
}