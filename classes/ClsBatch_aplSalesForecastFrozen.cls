/**
 *  Batch class to Freeze/Unfreeze APL Sales Forecast
 *
 @author    Bin Yuan
 @created   2014-08-07
 @version   1.0
 @since     30.0 (Force.com ApiVersion) 
 *
 @changelog
 * 2014-08-07 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created
 */
global class ClsBatch_aplSalesForecastFrozen implements Database.Batchable<SObject>, Database.stateful{
	global boolean isFreezeAM {get; set;}
	global boolean isFreezeGAM {get; set;}
	global boolean isFreezeRSM {get; set;}
	global boolean isFreezeRSMRelay {get; set;}
	
	global Database.QueryLocator start(Database.BatchableContext BC){
		if(isFreezeAM == null || isFreezeGAM == null || isFreezeRSM == null) {
			return null;
		}
		String query = 'Select Id, AM_Freeze__c, GAM_Freeze__c, RSM_Freeze__c, RecordType.DeveloperName From APL_Forecast_Management__c ';
		return database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext BC, list<APL_Forecast_Management__c> list_aplFCManagements){
		for(APL_Forecast_Management__c aplFCManagement : list_aplFCManagements) {
			aplFCManagement.AM_Freeze__c = isFreezeAM;
			aplFCManagement.GAM_Freeze__c = isFreezeGAM;
			aplFCManagement.RSM_Freeze__c = (aplFCManagement.RecordType.DeveloperName == 'AM' ? isFreezeRSM : isFreezeRSMRelay);
		}
		
		if(!list_aplFCManagements.isEmpty()) {
			update list_aplFCManagements;
		}
	}
	global void finish(Database.BatchableContext BC){ 
        
    }
}