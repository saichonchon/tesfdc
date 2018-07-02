/**
 * This class contains unit tests for ClsSchedule_recalculateOppyRevenue
 *
 @author Bin Yuan
 @created 2014-01-08
 @version 1.0
 @since 29.0
 *
 @changelog
 * coverage 88% 
 * 
 * 2014-01-08 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created
 */
@isTest
private class ClsSchedule_recalculateOppyRevenue_Test {
    static testMethod void testSchedule() {
            
        
        DateTime currTime = DateTime.now();
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        String sch;
        if(min <= 58) {
            sch = '0 '+ (min + 1) + ' ' + hour + ' * * ? '+ currTime.year();
        }
        else {         
            sch = '0 0 '+ (hour + 1) + ' * * ? '+ currTime.year();
        }
        
        test.startTest(); 
        ClsSchedule_recalculateOppyRevenue cls = new ClsSchedule_recalculateOppyRevenue();
        String jobId = system.schedule('test', sch, cls); 
            
        Test.stopTest(); 
    }
}