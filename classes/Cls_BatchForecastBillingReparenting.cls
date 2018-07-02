/**
 *  A batch one time job for Forecast Billing reparenting.
 *  
 * @author Rajendra Shahane
 * @created 2016-11-11
 * @version 1.0
 * @since 36.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 *
 * 2016-11-11 Rajendra Shahane <Rajendra.shahane@zensar.com>
 * - Created   
 *
 */
global class Cls_BatchForecastBillingReparenting implements Database.Batchable<SObject>
{
    public Date startDate;
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        string query = 'Select id,Date__c,opportunity_part__c,opportunity_forecast__c FROM Forecast_Billing__c where opportunity_forecast__c = null and opportunity_part__c <> null';
        if(startDate != null)
        	query = 'Select id,Date__c,opportunity_part__c,opportunity_forecast__c FROM Forecast_Billing__c where opportunity_forecast__c = null and opportunity_part__c <> null and opportunity_part__r.opportunity__r.last_modified_date__c >=:startDate ';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<Forecast_Billing__c> lstForecastBilling)
    {
        system.debug('@@lstForecastBilling : ' + lstForecastBilling);
        if(lstForecastBilling !=null && lstForecastBilling.size()>0)
        {
            system.debug('@@lstForecastBilling size : ' + lstForecastBilling.size());
            map<string,opportunity_forecast__c> mapOFPartOFdatewithOppyForecast = new map<string,opportunity_forecast__c>();
            set<Id> setOppyPart = new set<Id>();
            for(Forecast_Billing__c fb: lstForecastBilling)
            {
                setOppyPart.add(fb.opportunity_part__c);
            }
            system.debug('@@setOppyPart size : ' + setOppyPart.size());
            for(opportunity_forecast__c OppyForecast:[select Id,Part__c,Date__c from opportunity_forecast__c where Part__c in :setOppyPart])
            {
                if(!mapOFPartOFdatewithOppyForecast.containskey(OppyForecast.Part__c+string.valueof(OppyForecast.Date__c)))
                    mapOFPartOFdatewithOppyForecast.put(OppyForecast.Part__c+string.valueof(OppyForecast.Date__c),OppyForecast);
            }
            system.debug('@@mapOFPartOFdatewithOppyForecast size : ' + mapOFPartOFdatewithOppyForecast.size());
            List<Forecast_Billing__c> lstForecastBillingToUpdate = new List<Forecast_Billing__c>();
            for(Forecast_Billing__c frcastbill: lstForecastBilling)
            {
                if(mapOFPartOFdatewithOppyForecast.containskey(frcastbill.opportunity_part__c+string.valueof(frcastbill.Date__c)))
                {
                    frcastbill.opportunity_forecast__c  = mapOFPartOFdatewithOppyForecast.get(frcastbill.opportunity_part__c+string.valueof(frcastbill.Date__c)).Id;
                    lstForecastBillingToUpdate.add(frcastbill);
                }
            }
			system.debug('@@lstForecastBillingToUpdate size : ' + lstForecastBillingToUpdate.size());  
            if(lstForecastBillingToUpdate.size() > 0)
                update lstForecastBillingToUpdate; 
        }
    }
    
    global void finish(Database.BatchableContext BC) {}
}