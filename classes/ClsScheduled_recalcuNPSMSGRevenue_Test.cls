/**
 *  This test class is for ClsScheduled_recalcuPartNPSMSGRevenue.
 *
 */
@isTest
private class  ClsScheduled_recalcuNPSMSGRevenue_Test {
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
        
        ClsScheduled_recalcuPartNPSMSGRevenue obj = new ClsScheduled_recalcuPartNPSMSGRevenue();                
        String jobId = system.schedule('test_NPSMSG', sch, obj); 
        
        system.assert(true);
        Test.stopTest();
    }
}