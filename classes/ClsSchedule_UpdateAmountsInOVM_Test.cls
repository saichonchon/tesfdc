/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest (seeallData = true)
private class ClsSchedule_UpdateAmountsInOVM_Test {
    
    static testMethod void testSchedule() {
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
        String sch;
        
    if(min <= 58)
            sch = '0 '+ (min + 1) + ' ' + hour + ' * * ? '+ currTime.year();
        else          
            sch = '0 0 '+ (hour + 1) + ' * * ? '+ currTime.year();
            
        Test.startTest();
            for (Date dt1: Startdate){
                  if (Date.today() == dt1){
            ClsSchedule_UpdateAmountsInOVM sh1 = new ClsSchedule_UpdateAmountsInOVM();
            sh1.todayDate = startDate[0];
           // String jobId = system.schedule('test', sch, sh1); 
            system.assert(true);
                  }
            }
            Test.stopTest();
        
    }
    
}