/**
 *  This class is used to schedule batch job CSD_ClsBatch_calcForecastSnapshot
 *  
 * @author Bin Yuan
 * @created 2014-03-03
 * @version 1.0
 * @since 28.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2014-03-03 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created   
 *
 */

global class CSD_ClsScheduled_CSDFCSnapShot implements Schedulable{
	global void execute(SchedulableContext sc) {
    	/*Integer dayCount = system.today().toStartOfMonth().daysBetween(system.today()) + 1;
    	
    	Integer csdFCSnapshotDay = 3, 
    			quarterRevenueDay = 4;
    	boolean isCSDFCSnapshotDay = false, 
    			isQuarterRevenueDay = false;
    	
    	if(CSD_Configuration__c.getInstance('CSD Opportunity FC Snapshot') != null
    		&& CSD_Configuration__c.getInstance('CSD Opportunity FC Snapshot').Value__c != null) {
    		
			csdFCSnapshotDay = Integer.valueOf(CSD_Configuration__c.getInstance('CSD Opportunity FC Snapshot').Value__c);
    	} 
    	if(CSD_Configuration__c.getInstance('CSD Opportunity FC 8 Quarter Revenue') != null
    		&& CSD_Configuration__c.getInstance('CSD Opportunity FC 8 Quarter Revenue').Value__c != null) {
    		
			quarterRevenueDay = Integer.valueOf(CSD_Configuration__c.getInstance('CSD Opportunity FC 8 Quarter Revenue').Value__c);
    	} 
    	
		isCSDFCSnapshotDay = (dayCount == csdFCSnapshotDay ? false : true);
		isQuarterRevenueDay = (dayCount == quarterRevenueDay ? false : true);
		if(isCSDFCSnapshotDay) {
			CSD_ClsBatch_calcForecastSnapshot cls= new CSD_ClsBatch_calcForecastSnapshot();
			ID batchprocessid = Database.executeBatch(cls);
		}
		if(isQuarterRevenueDay) {
			//CSD_Clsbatch_updateOppy8quarterRevenue cls= new CSD_Clsbatch_updateOppy8quarterRevenue();
			//ID batchprocessid = Database.executeBatch(cls);
		}*/
        Date startDate;
        Integer year, month;
        Date currentFiscalDate;
    	for (Period period : [select Id, FiscalYearSettings.Name, PeriodLabel, StartDate
                            from Period where StartDate<=Today and EndDate >=Today and Type = 'Month']) {
            if(startDate == null) {
                startDate = period.StartDate;
            }
            if(period.FiscalYearSettings.Name != null){ //set current year
                year = Integer.valueOf(period.FiscalYearSettings.Name);
            }
            if(period.PeriodLabel != null && CSD_ClsUtils.MAP_MONTHLABELNUMBER.containsKey(period.PeriodLabel)){ //set current month
                month = Integer.valueOf(CSD_ClsUtils.MAP_MONTHLABELNUMBER.get(period.PeriodLabel));
            }
            currentFiscalDate = Date.newInstance(year, month, 15).addMonths(-1);
        }

        if(startDate == system.today()) {     
        	
            CSD_ClsBatch_calcForecastSnapshot cls = new CSD_ClsBatch_calcForecastSnapshot();
            cls.currentFiscalDate = currentFiscalDate;
			ID batchprocessid = Database.executeBatch(cls);
        }
		
		
	}
}