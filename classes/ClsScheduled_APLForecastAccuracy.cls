global class ClsScheduled_APLForecastAccuracy  implements Schedulable{
	global void execute(SchedulableContext sc){
		
		String quarterToRun = 'Jan:01;Apr:02;Jul:03;Oct:04';
		       
        Integer year = Date.today().Year();
        Period p =  [select FiscalYearSettingsId, FiscalYearSettings.Name, Number, PeriodLabel, StartDate, EndDate from Period where type = 'Month' and startdate <=: System.today() and enddate >=: System.today() limit 1];
        
        if(quarterToRun.indexOf(p.PeriodLabel) > -1 || Test.isRunningTest()){
        	String fiscalYear,fiscalQuarter;
        	String[] quarterList = quarterToRun.split(';');
        	if(quarterList[3].indexOf(p.PeriodLabel) > -1){
        		//Jan, should get last year q4
        		fiscalYear = (Integer.valueOf(p.FiscalYearSettings.Name)-1)+'';
        	}else{
        		fiscalYear = p.FiscalYearSettings.Name;
        	}
        	
        	for(String q : quarterList){
        		if(q.indexOf(p.PeriodLabel) > -1){
        			fiscalQuarter = q.split(':')[1];
        			break;
        		}
        	}
        	
        	String soql = 'select RecordType.DeveloperName, Relay_Specialist__c, A6_Code__c from APL_Forecast_Management__c where RecordType.DeveloperName in (\'AM\',\'Relay\')';
        
        	ClsBatch_APLForecastAccuracy batch = new ClsBatch_APLForecastAccuracy(soql,fiscalYear,fiscalQuarter);
        	Database.executeBatch(batch,1);
        }
        
        if(Date.today() == p.StartDate.addDays(1))
        {      
            ClsBatch_recalculatePartNPSMSGRevenue ClsBatch = new ClsBatch_recalculatePartNPSMSGRevenue();
            ID processId = Database.executeBatch(ClsBatch,1);
        }               
    }
}