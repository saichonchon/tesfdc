/**
*  This test class used to test class ClsBatch_aplSalesForecastFrozen.
*
@author Lili Zhao
@created 2014-08-15
*
@changelog
* coverage  94%
*  
2014-08-15 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest
private class ClsSchedule_aplNextQuarterFCCalcula_Test{

    static testMethod void testSchedule() {
        list <Period> PeriodObj = [select EndDate, FiscalYearSettings.Name, Number from Period where StartDate<=Today and EndDate >=Today and Type = 'Quarter'];
        
        list<Date> endDate = new list<Date>();
         for (Period p: PeriodObj){
            endDate.add(p.EndDate);
         }
        endDate.add(Date.today());
        DateTime currTime = DateTime.now();
        Date dt = Date.today();
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        String sch;
        Integer i = 0;
        String jobName;
        
    if(min <= 58)
            sch = '0 '+ (min + 1) + ' ' + hour + ' * * ? '+ currTime.year();
        else          
            sch = '0 0 '+ (hour + 1) + ' * * ? '+ currTime.year();
            
        Test.startTest();
            for (Date dt1: endDate){
                  if (Date.today() == dt1){
                    jobName = 'aplNextQuarterFC' + String.valueOf(i);
                    i++;
                    ClsSchedule_aplNextQuarterFCCalculate sh1 = new ClsSchedule_aplNextQuarterFCCalculate();
                    sh1.startDate= Date.today();
                    //String jobId = system.schedule('test', sch, sh1); 
                    String jobId = system.schedule(jobName, sch, sh1); 
                    system.assert(true);
                  }
            }
            Test.stopTest();
        
    }
}