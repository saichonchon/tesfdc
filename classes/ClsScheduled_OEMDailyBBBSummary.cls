global class ClsScheduled_OEMDailyBBBSummary implements Schedulable{

    global void execute(SchedulableContext sc) {
    	
    	//fiscal month/fiscal year must be configured Picklist values, or the order by will not function correctly.  custom picklist values (inserted because they appear on 
		//data) always get sorted to the top.  Even in the picklist, fiscal month should always be prefixed by 0 or string sort will not order them correctly, i.e. 9 will 
		//come out as > 10
    	aggregateResult[] maxFyFm = [SELECT Max(fiscal_month__c) fiscal_month__c, fiscal_year__c from OEM_Mapping_Rule__c where active__c = false group by fiscal_year__c order by fiscal_year__c desc limit 1];
    	if(maxFyFM.size() > 0)
    	{
	    	String FiscalYear = (String)maxFyFm[0].get('fiscal_year__c');
	    	String FiscalMonth = (String)maxFyFm[0].get('fiscal_month__c');
	   
	   		ClsOEMUtil.checkForActive = false; 	
	    	ClsOEMUtil.listOEMMapBatchInput = ClsOEMUtil.setOEMMapBatchInput(FiscalMonth, FiscalYear);    	
	    	//System.debug('***** JNV - ' + ClsOEMUtil.listOEMMapBatchInput);
			
			//updated by nelson
	        //ClsBatch_OEM_DailyBBBSummary oem = new ClsBatch_OEM_DailyBBBSummary(ClsOEMUtil.listOEMMapBatchInput, fiscalMonth, fiscalYear);
	        ClsBatch_OEM_DailyBBBSummary oem = new ClsBatch_OEM_DailyBBBSummary();
	        ID batchprocessid = Database.executeBatch(oem);
    	}			
    	
    }

}