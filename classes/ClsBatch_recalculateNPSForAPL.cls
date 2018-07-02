/**
 * The batch class is used for calculating NPS1.
 * Execute after LtngOpportunityForecastCtrl.saveForecastList
 *
 * @author      Qiang Liu (qiang.liu@oinio.com)
 * @created     2017-11-22
 * @since		38.0
 * @version     1.0
 *
 * @changelog
 *
 */
global class ClsBatch_recalculateNPSForAPL implements Database.Batchable<SObject> {
	public String query = 'SELECT Id FROM Opportunity_Forecast__c WHERE Id = null';
	public Set<Id> set_fcIds;
	public List<sObject> list_sos;
	
	public ClsBatch_recalculateNPSForAPL(List<Opportunity_Forecast__c> list_fcs) {
		set_fcIds = (new Map<Id, Opportunity_Forecast__c>(list_fcs)).keySet();
		if (set_fcIds.size() > 0) query = 'SELECT Id, Part__c, NPS1__c, Opportunity__c FROM Opportunity_Forecast__c WHERE Id IN :set_fcIds';
		System.debug('xxxx query=' + query);
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext BC, List<Opportunity_Forecast__c> list_fcs) {
		Set<Id> oppIdSet = new Set<Id>();
		for(Opportunity_Forecast__c oppFC : list_fcs) {
			if (oppFC.Part__c != null && oppFC.NPS1__c == null) oppIdSet.add(oppFC.Opportunity__c);
		}
		
		if (oppIdSet.size() > 0) APL_Utils_Class.updateNPSMSGonPartNew(oppIdSet);
	}
	
	global void finish(Database.BatchableContext BC) {}   
}