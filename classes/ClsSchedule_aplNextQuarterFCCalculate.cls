/**
 *  Schedule class to Calculate apl Next Quarter forecast 
 *
 @author    Lili Zhao
 @created   2014-08-26
 @version   1.0
 @since     30.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-08-26 Lili Zhao <lili.zhao@itbconsult.com>
 * - Created
 */
global class ClsSchedule_aplNextQuarterFCCalculate implements Schedulable {
    public Date startDate;
    global void execute(SchedulableContext sc) {
               
        String currentYear;
        String currentQuarter;
        
        if(currentYear == null || currentQuarter == null) {
            for (Period period : [select StartDate, FiscalYearSettings.Name, Number 
                                  from Period 
                                  where EndDate >=Today 
                                  and Type = 'Quarter' 
                                  order by EndDate limit 7]) {
                
                if(startDate == null) {
                    startDate = period.StartDate.adddays(3);//period.StartDate;
                }
                if(period.FiscalYearSettings.Name != null){
                    currentYear = period.FiscalYearSettings.Name;
                }
                if(period.Number != null){
                    currentQuarter = '0' + period.Number;
                }
            }
            if(currentQuarter == '01') {
                currentYear = String.valueOf(Integer.valueOf(currentYear) - 1);
                currentQuarter = '04';
            }
            else {
                currentQuarter = '0' + (Integer.valueOf(currentQuarter) - 1);
            }
        }
        
        if(startDate == system.today()) {     
            ClsBatch_calcAPLNextQuarterForecast cls = new ClsBatch_calcAPLNextQuarterForecast();
            cls.currentQuarter = currentQuarter;
            cls.currentYear = currentYear;
            Id batchId = database.executeBatch(cls);
            
        }
    }
}