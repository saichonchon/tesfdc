/*
created by nelson zheng 01-21-2015
*/
global class ClsScheduled_RecalculatePartNPSMSG implements Schedulable{
	
	global void execute(SchedulableContext sc) {
		
		set<Id> applOpptyRTId = ClsOppyForecastUtil.applianceOpptyRecordTypeId();
		String query = 'SELECT Id,Part__c From Opportunity_Part__c where need_recalculate_PartNPSMSGRevenue__c = true and Opportunity__r.RecordTypeId in: applOpptyRTId and opportunity__r.Industry_Code__c = \'Appliances\' and opportunity__r.Owner.GIBU__c = \'Appliances\' and APL_Forecast_Calculation_Start_Date__c>=2008-09-27 and Status__c != \'Dead\' and Status__c != \'Lost\'';                        
	    ClsBatch_recalculatePartNPSMSGRevenue batch = new ClsBatch_recalculatePartNPSMSGRevenue();
	    batch.query = query;
	    Database.executeBatch(batch,1);
	}
}