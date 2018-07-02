global class ClsSchedule_UpdateAmountsInOVM implements Schedulable {
	list <Period> PeriodObj = [select id , StartDate, Type from Period Where Type = 'Month'];
    list<Date> StartDate = new list<Date>();
    public Date todayDate = Date.Today();
    list <Overall_Forecast__c> lst_ovf = [select id, Gam_Code__c from Overall_Forecast__c];
    set <string> set_GamCode = new set <String>();
	global void execute(SchedulableContext sc) {
		for (Period p: PeriodObj){
        Startdate.add(p.StartDate);
    }
    for (Overall_Forecast__c ovf: lst_ovf){
        set_GamCode.add(ovf.Gam_Code__c);
    }
    for (Date dt: Startdate){
        if (todayDate == dt){
        	UpdateAmountsInOverallMeasures.CaluclateTotalRunrate(set_GamCode);
        	UpdateAmountsInOverallMeasures.CaluclateRemainingRunrate(set_GamCode);
        	}
        }	
	}

}