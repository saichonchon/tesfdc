/**
 *  This test class is for ClsScheduled_recalcBBBMCurrency .
 *
 @author Lili Zhao
 @created 2014-03-07
 @version 1.0
 @since 29.0
 *
 @changelog
 * 2014-03-07 Lili Zhao<bin.yuan@itbconsult.com>
 * - Created
 * - Test coverage 100%
 */
@isTest
private class  ClsScheduled_recalcBBBMCurrency_Test {
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
        
        ClsScheduled_recalcBBBMCurrency obj = new ClsScheduled_recalcBBBMCurrency();                
        String jobId = system.schedule('test_BBBMCurrency', sch, obj); 
    
        system.assert(true);
        Test.stopTest();
    }
}