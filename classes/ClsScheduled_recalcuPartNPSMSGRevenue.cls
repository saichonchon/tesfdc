global class ClsScheduled_recalcuPartNPSMSGRevenue implements Schedulable
{
    global void execute(SchedulableContext sc) 
    {       
        Integer year = Date.today().Year();
        Period p =  [select FiscalYearSettingsId, FiscalYearSettings.Name, Number, PeriodLabel, StartDate, EndDate from Period where type = 'Quarter' and Number = 1 and FiscalYearSettings.Name =: String.valueOf(year+1) limit 1];
        
        if(Date.today() == p.StartDate.addDays(1))
        {      
            ClsBatch_recalculatePartNPSMSGRevenue ClsBatch = new ClsBatch_recalculatePartNPSMSGRevenue();
            ID processId = Database.executeBatch(ClsBatch,1);
        }               
    }
}