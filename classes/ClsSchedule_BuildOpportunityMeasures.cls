global class ClsSchedule_BuildOpportunityMeasures implements Schedulable{

	list <Period> PeriodObj = [select id , StartDate, Type from Period Where Type = 'Month'];
    list<Date> StartDate = new list<Date>();
    public Date todayDate = Date.Today();
    global void execute(SchedulableContext sc) {
        for (Period p: PeriodObj){
        Startdate.add(p.StartDate);
    }
    	for (Date dt: Startdate){
        	if (todayDate == dt){
        	ClsBatch_buildOpportunityMeasures bom = new ClsBatch_buildOpportunityMeasures();
        	ID batchprocessid = Database.executeBatch(bom);
        	}
    	}
	}
}