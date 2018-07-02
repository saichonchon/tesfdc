/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   A handler class for Opportunity_Part_Forecast__c triggers.
               The user story number is Opportunity Part Forecast.
Inputs:        
Test Class:    OpportunityPartForecastTrgHandler_Test.cls
History
2017-08-25  Yiming Shen <yiming.shen@capgemini.com> Created
2017-11-30  Yiming Shen <yiming.shen@capgemini.com> Modified
	Add a new method setUSDCurrencyCode
------------------------------------------------------------*/
public with sharing class OpportunityPartForecastTrgHandler extends ClsTriggerVirtual{
	
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
        if(trgCtx.isAfter) return;
        
        if(!trgCtx.isDelete){
            for(Sobject sobj : trgCtx.newList){
                Opportunity_Part_Forecast__c oppPartForecast = (Opportunity_Part_Forecast__c)sobj;
                    Integer year = Integer.valueOf(oppPartForecast.Year__c);

                    Integer month = Integer.valueOf(oppPartForecast.Month__c);

                    oppPartForecast.year_and_month__c = 100 * year + month;
            }
        }
        
		setUSDCurrencyCode(trgCtx);
    }
    
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
        if(trgCtx.isBefore) return;
    }

	/*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to Ensure that the currencyCode on ALL OppForecast and OPF records is USD.  
				   We shouldn't have any other currencies shown.
	Inputs:        trgCtx - ClsWrappers.TriggerContext
	Returns:       
	History
	2017-11-30 	   Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
    private static void setUSDCurrencyCode(ClsWrappers.TriggerContext trgCtx){
    	if(trgCtx.isInsert || trgCtx.isUndelete){
    		Map<String,List<Opportunity_Part_Forecast__c>> map_OppyId_OPFs = new Map<String,List<Opportunity_Part_Forecast__c>>();
    		for(Sobject sobj : trgCtx.newList) {
	    		Opportunity_Part_Forecast__c oppyPartForecast = (Opportunity_Part_Forecast__c)sobj;
	    		if(!map_OppyId_OPFs.containsKey(oppyPartForecast.CustomOpportunityId__c)){
	    			map_OppyId_OPFs.put(oppyPartForecast.CustomOpportunityId__c, new List<Opportunity_Part_Forecast__c>());
	    		}
	    		map_OppyId_OPFs.get(oppyPartForecast.CustomOpportunityId__c).add(oppyPartForecast);
	    	}
	    	
	    	if(map_OppyId_OPFs.keySet().size() > 0){
	    		for(Opportunity oppy : [SELECT Id FROM Opportunity 
    								WHERE Id IN: map_OppyId_OPFs.keySet()
    								AND RecordType.DeveloperName = 'Energy_Sales']){
		    		for(Opportunity_Part_Forecast__c oppyPartForecast : map_OppyId_OPFs.get(((String)oppy.Id).subString(0,15))){
		    			oppyPartForecast.CurrencyISOCode = 'USD';
		    		}
    			}
	    	}
    	}
    }
}