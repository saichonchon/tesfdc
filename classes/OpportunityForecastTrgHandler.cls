/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   A handler class for OpportunityForecastTrgHandler.cls.
			   The user story number is W-00145.
Inputs:        
Test Class:    OpportunityForecastTrgHandler_Test.cls
History
2017-08-14 Yiming Shen <yiming.shen@capgemini.com> created
------------------------------------------------------------*/
public with sharing class OpportunityForecastTrgHandler extends ClsTriggerVirtual{
    public static Boolean isSkipTrigger = false;
    public static Boolean isInUpdateOppyPartForecast = false;
    public static Boolean isInUpdateForecastCurrencyCode = false;
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
        if(trgCtx.isAfter) return;
    }
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
        if(trgCtx.isBefore) return;
        setCurrencyCodeUSD(trgCtx);
        executeHandler(trgCtx);
    }
    
    /*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to set Opportunity forecast CurrencyISOCode always USD.
	Inputs:        trgCtx - ClsWrappers.TriggerContext
	Returns:       
	History
	2018-03-08 	   Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
    private static void setCurrencyCodeUSD(ClsWrappers.TriggerContext trgCtx){
    	if(isInUpdateForecastCurrencyCode) return;
    	isInUpdateForecastCurrencyCode = true;
    	Boolean isCurrentUserAllowToSet = false; 
    	List<Allow_To_Set_Forecast_USD_Currency__c> list_AllowSettings = Allow_To_Set_Forecast_USD_Currency__c.getall().values();
    	
    	for(Allow_To_Set_Forecast_USD_Currency__c allowSetting :list_AllowSettings){
    		if(String.isNotBlank(allowSetting.UserId__c) && Id.valueOf(allowSetting.UserId__c) == Id.valueOf(UserInfo.getUserId())){
    			isCurrentUserAllowToSet = true;
    		}
    	}
    	if(!isCurrentUserAllowToSet) return;
    	Set<Id> set_OppyForecastIds = new Set<Id>();
    	List<Opportunity_Forecast__c> list_OppyForecasts2Update = new List<Opportunity_Forecast__c>();
    	
    	if(trgCtx.isInsert || trgCtx.isUndelete || trgCtx.isUpdate){
    		for(Sobject sobj : trgCtx.newList) {
	    		Opportunity_Forecast__c oppyForecast = (Opportunity_Forecast__c)sobj;
	    		if(oppyForecast.CurrencyISOCode == null || oppyForecast.CurrencyISOCode != 'USD'){
	    			set_OppyForecastIds.add(oppyForecast.Id);
	    		}
	    	}
    	}
    	
    	for(Opportunity_Forecast__c oppyForecast : [SELECT CurrencyISOCode 
    												FROM Opportunity_Forecast__c
    												WHERE Opportunity__r.RecordType.DeveloperName = 'Energy_Sales'
    												AND Id IN: set_OppyForecastIds]){
    		oppyForecast.CurrencyISOCode = 'USD';
    		list_OppyForecasts2Update.add(oppyForecast);
    	}
    	if(list_OppyForecasts2Update.size() > 0){
    		update list_OppyForecasts2Update;
    	}
    }
    
    /*private static void syncOppyCurrencyCode(ClsWrappers.TriggerContext trgCtx){
    	Map<Id,List<Opportunity_Forecast__c>> map_OppyId_OppyForecastList = new Map<Id,List<Opportunity_Forecast__c>>();
    	if(trgCtx.isInsert || trgCtx.isUndelete){
    		for(Sobject sobj : trgCtx.newList) {
	    		Opportunity_Forecast__c oppyForecast = (Opportunity_Forecast__c)sobj;
	    		if(oppyForecast.Opportunity__c != null){
	    			if(!map_OppyId_OppyForecastList.containsKey(oppyForecast.Opportunity__c)){
	    				map_OppyId_OppyForecastList.put(oppyForecast.Opportunity__c,new List<Opportunity_Forecast__c>());
	    			}
	    			map_OppyId_OppyForecastList.get(oppyForecast.Opportunity__c).add(oppyForecast);
	    		}
	    	}
    	}
    	
    	for(Opportunity oppy : [SELECT Id FROM Opportunity 
    								WHERE Id IN: map_OppyId_OppyForecastList.keySet()
    								AND RecordType.DeveloperName = 'Energy_Sales']){
    		for(Opportunity_Forecast__c oppyForecast : map_OppyId_OppyForecastList.get(oppy.Id)){
    			oppyForecast.CurrencyISOCode = 'USD';
    		}
    	}
    }*/
    /*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to update Opportunity_Part_Forecast__c records.
				   Function to update opportunity amount when the opportunity forecast updated.
	Inputs:        trgCtx - ClsWrappers.TriggerContext
	Returns:       
	History
	2017-12-20 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
	private static void executeHandler(ClsWrappers.TriggerContext trgCtx){
    	if(trgCtx.isBefore) return;
    	//UpdateOppyPartForecast variables start
    	Map<Id,List<Opportunity_Part__c>> map_OppyId_ListOppyParts = new Map<Id,List<Opportunity_Part__c>>();
    	Map<Id,List<Opportunity_Forecast__c>> map_OppyId_ListOppyForecasts = new Map<Id,List<Opportunity_Forecast__c>>();
    	List<Opportunity_Part_Forecast__c> list_OppyPartForecasts2Delete = new List<Opportunity_Part_Forecast__c>();
    	List<Opportunity_Part_Forecast__c> list_OppyPartForecasts2Insert = new List<Opportunity_Part_Forecast__c>();
    	Set<Id> set_OppyIds2UpdateOppyPartForecasts = new Set<Id>();
    	Map<Id,List<Opportunity_Forecast__c>> map_OppyId_ListOppyForecasts2Insert = new Map<Id,List<Opportunity_Forecast__c>>();
 		Map<Id,Set<Id>> map_OppyId_ListOppyForecastIds2Delete = new Map<Id,Set<Id>>(); 
 		//UpdateOppyPartForecast variables end
 		
 		//updateOppyAmount variables start
 		Set<Id> set_oppId = new Set<Id>();
        Set<Id> set_oppIdAfterFilter = new Set<Id>();
        map<Id, Decimal> map_oppId_Amount = new map<Id, Decimal>();
        list<Opportunity> list_oppForUpdate = new list<Opportunity>();
        //updateOppyAmount variables end
       
    	if(trgCtx.isInsert || trgCtx.isUndelete){
    		for(Sobject sobj : trgCtx.newList) {
	    		Opportunity_Forecast__c oppyForecast = (Opportunity_Forecast__c)sobj;
	    		//updateOppyAmount start
	    		set_oppId.add(oppyForecast.Opportunity__c);
	    		//updateOppyAmount end
	    		//UpdateOppyPartForecast start
	    		if(oppyForecast.Amount__c != null && oppyForecast.Amount__c > 0){
					if(!map_OppyId_ListOppyForecasts2Insert.containsKey(oppyForecast.Opportunity__c)){
						map_OppyId_ListOppyForecasts2Insert.put(oppyForecast.Opportunity__c, new List<Opportunity_Forecast__c>());
					}
					map_OppyId_ListOppyForecasts2Insert.get(oppyForecast.Opportunity__c).add(oppyForecast);
	    		}
	    		//UpdateOppyPartForecast end
	    	}
    	}else if(trgCtx.isUpdate){   		
    		for(Sobject sobj : trgCtx.newList) {
	    		Opportunity_Forecast__c oppyForecast = (Opportunity_Forecast__c)sobj;
	    		Opportunity_Forecast__c oldOppyForecast = (Opportunity_Forecast__c)trgCtx.oldMap.get(oppyForecast.Id);
	    		//updateOppyAmount start
	    		if(oppyForecast.Amount__c != oldOppyForecast.Amount__c) {
                    set_oppId.add(oppyForecast.Opportunity__c);
                }
                //updateOppyAmount end
	    		//UpdateOppyPartForecast start
	    		if(oppyForecast.Amount__c != oldOppyForecast.Amount__c){
	    			if((oldOppyForecast.Amount__c == 0 || oldOppyForecast.Amount__c == null)
	    			&& (oppyForecast.Amount__c != 0 && oppyForecast.Amount__c != null)){
	    				if(!map_OppyId_ListOppyForecasts2Insert.containsKey(oppyForecast.Opportunity__c)){
							map_OppyId_ListOppyForecasts2Insert.put(oppyForecast.Opportunity__c, new List<Opportunity_Forecast__c>());
						}
						map_OppyId_ListOppyForecasts2Insert.get(oppyForecast.Opportunity__c).add(oppyForecast);
	    			}else if((oldOppyForecast.Amount__c != 0 && oldOppyForecast.Amount__c != null)
	    			&& (oppyForecast.Amount__c == 0 || oppyForecast.Amount__c == null)){
	    				if(!map_OppyId_ListOppyForecastIds2Delete.containsKey(oldOppyForecast.Opportunity__c)){
							map_OppyId_ListOppyForecastIds2Delete.put(oldOppyForecast.Opportunity__c, new Set<Id>());
						}
						map_OppyId_ListOppyForecastIds2Delete.get(oldOppyForecast.Opportunity__c).add(oldOppyForecast.Id);
	    			}else if(oldOppyForecast.Amount__c != 0 && oldOppyForecast.Amount__c != null
	    			&& oppyForecast.Amount__c != 0 && oppyForecast.Amount__c != null){
	    				if(!map_OppyId_ListOppyForecastIds2Delete.containsKey(oldOppyForecast.Opportunity__c)){
							map_OppyId_ListOppyForecastIds2Delete.put(oldOppyForecast.Opportunity__c, new Set<Id>());
						}
						if(!map_OppyId_ListOppyForecasts2Insert.containsKey(oppyForecast.Opportunity__c)){
							map_OppyId_ListOppyForecasts2Insert.put(oppyForecast.Opportunity__c, new List<Opportunity_Forecast__c>());
						}
						map_OppyId_ListOppyForecastIds2Delete.get(oldOppyForecast.Opportunity__c).add(oldOppyForecast.Id);
						map_OppyId_ListOppyForecasts2Insert.get(oppyForecast.Opportunity__c).add(oppyForecast);
	    			}
	    		}
	    		//UpdateOppyPartForecast end
	    	}
    	}else if(trgCtx.isDelete){   		
    		for(Sobject sobj : trgCtx.oldList) {
	    		Opportunity_Forecast__c oldOppyForecast = (Opportunity_Forecast__c)sobj;
	    		//UpdateOppyAmount start
	    		set_oppId.add(oldOppyForecast.Opportunity__c);
	    		//UpdateOppyAmount end
	    		//UpdateOppyPartForecast start
				if(!map_OppyId_ListOppyForecastIds2Delete.containsKey(oldOppyForecast.Opportunity__c)){
					map_OppyId_ListOppyForecastIds2Delete.put(oldOppyForecast.Opportunity__c, new Set<Id>());
				}
				map_OppyId_ListOppyForecastIds2Delete.get(oldOppyForecast.Opportunity__c).add(oldOppyForecast.Id);
				//UpdateOppyPartForecast end
	    	}
    	}
    	
    	//1.Our OppForecast trigger should only run on Energy Opportunities.Record Type is Energy - Sales.
    	for(Opportunity oppy : [SELECT Id, RecordType.DeveloperName FROM Opportunity 
    							WHERE RecordType.DeveloperName = 'Energy_Sales'
    							AND (Id IN: map_OppyId_ListOppyForecastIds2Delete.keySet()
    							OR Id IN: map_OppyId_ListOppyForecasts2Insert.keySet()
    							OR Id IN: set_oppId)]){
    		if(map_OppyId_ListOppyForecastIds2Delete.keySet().contains(oppy.Id)
    		|| map_OppyId_ListOppyForecasts2Insert.keySet().contains(oppy.Id)){
	    		set_OppyIds2UpdateOppyPartForecasts.add(oppy.Id);
    		}
    		if(set_oppId.contains(oppy.Id)){
    			set_oppIdAfterFilter.add(oppy.Id);
    		}
    	}
    	//2.delete OpportunityPartForecasts
    	if(set_OppyIds2UpdateOppyPartForecasts.size() > 0
    	&& !isInUpdateOppyPartForecast
    	&& !isSkipTrigger){
    		isInUpdateOppyPartForecast = true;
    		Set<Id> set_OppyForecastIds = new Set<Id>();
    		for(Id oppyId : set_OppyIds2UpdateOppyPartForecasts){
    			if(map_OppyId_ListOppyForecastIds2Delete.containsKey(oppyId)){
    				for(Id oppyForecastId : map_OppyId_ListOppyForecastIds2Delete.get(oppyId)){
    					set_OppyForecastIds.add(oppyForecastId);
    				}
    			}
    		}
    		for(Opportunity_Part_Forecast__c oppyPartForecast : [SELECT Id FROM Opportunity_Part_Forecast__c
																	WHERE Opportunity_Forecast__c IN: set_OppyForecastIds]){
				list_OppyPartForecasts2Delete.add(oppyPartForecast);
			}
			System.debug('---list_OppyPartForecasts2Delete:::' + list_OppyPartForecasts2Delete.size());
	    	//3.create OpportunityPartForecasts
	    	//for(Opportunity_Part__c oppyPart : [SELECT Id, Opportunity__c, Fraction_of_sale__c
	    	for(Opportunity_Part__c oppyPart : [SELECT Id, Opportunity__c
	    										FROM Opportunity_Part__c 
	    										WHERE Opportunity__c IN: set_OppyIds2UpdateOppyPartForecasts
	    										AND Status__c != 'Lost' 
	    										AND Status__c != 'No Bid']){
				if(!map_OppyId_ListOppyParts.containsKey(oppyPart.Opportunity__c)){
					map_OppyId_ListOppyParts.put(oppyPart.Opportunity__c, new List<Opportunity_Part__c>());
				}
	    		map_OppyId_ListOppyParts.get(oppyPart.Opportunity__c).add(oppyPart);
	    	}
    		System.debug('---map_OppyId_ListOppyParts:::' + map_OppyId_ListOppyParts);
    		for(Id oppyId : set_OppyIds2UpdateOppyPartForecasts){
    			if(map_OppyId_ListOppyForecasts2Insert.containsKey(oppyId)){
    				for(Opportunity_Forecast__c oppyForecast : map_OppyId_ListOppyForecasts2Insert.get(oppyId)){
    					if(map_OppyId_ListOppyParts.containsKey(oppyId)){
		    				for(Opportunity_Part__c oppyPart : map_OppyId_ListOppyParts.get(oppyId)){
		    					Opportunity_Part_Forecast__c oppyPartForecast2Insert = new Opportunity_Part_Forecast__c();
		    					oppyPartForecast2Insert.Opportunity_Forecast__c = oppyForecast.Id;
								oppyPartForecast2Insert.Opportunity_Part__c = oppyPart.Id;
								oppyPartForecast2Insert.Year__c = oppyForecast.Fiscal_Year__c;
								oppyPartForecast2Insert.CurrencyISOCode = 'USD';
								oppyPartForecast2Insert.Quarter__c = oppyForecast.Fiscal_Quarter__c;
								oppyPartForecast2Insert.Month__c = Decimal.valueOf(oppyForecast.Fiscal_Month__c);
		    					list_OppyPartForecasts2Insert.add(oppyPartForecast2Insert);
		    				}
    					}
    				}
    			}
    		}
    	} 	
    	System.debug('---list_OppyPartForecasts2Insert:::' + list_OppyPartForecasts2Insert.size());
    	if(set_oppIdAfterFilter.size() > 0) {
            for(aggregateResult result : [Select sum(Amount__c) amount, Opportunity__c
                                          From Opportunity_Forecast__c
                                          Where Opportunity__c in: set_oppIdAfterFilter 
                                          group by Opportunity__c]){
                map_oppId_Amount.put((Id)result.get('Opportunity__c'), (Decimal)result.get('amount'));                              
            }
        }
        if(map_oppId_Amount.size() > 0) {
            for(Opportunity opp : [Select Id, CurrencyIsoCode,Amount From Opportunity
                                   Where Id in :map_oppId_Amount.keySet()]){
                opp.Amount = (opp.CurrencyIsoCode == 'USD' ? map_oppId_Amount.get(opp.Id) : ClsPMVTeamViewUtil.transformIsoCode(map_oppId_Amount.get(opp.Id), 'USD', opp.CurrencyIsoCode)) ;                
                list_oppForUpdate.add(opp);                        
            }
        }
    	if(Test.isRunningTest()){
    		if(list_OppyPartForecasts2Delete.size() > 0) delete list_OppyPartForecasts2Delete;
    		if(list_OppyPartForecasts2Insert.size() > 0) insert list_OppyPartForecasts2Insert;
    		if(list_oppForUpdate.size() > 0) update list_oppForUpdate;
    	}else{
    		try{
    			if(list_oppForUpdate.size() > 0) {
            		update list_oppForUpdate;
        		}
				if((list_OppyPartForecasts2Delete.size() > 0 || list_OppyPartForecasts2Insert.size() > 0)
				&& !isSkipTrigger)  System.enqueueJob(new ClsOppyPartForecastDeleteQueue(list_OppyPartForecasts2Delete,list_OppyPartForecasts2Insert)); 
    		}catch(Exception e){
    			String vStrError = 'Error Type = ' + e.getTypeName() + ' Error Line = ' + e.getLineNumber() + '' + ' Error Stack = ' + e.getStackTraceString() + ' Error Message = ' + e.getMessage();
            	SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '', e.getStackTraceString());
    			if(ExtOpportunityForecasting.isOppyForecastManagementSave){throw e;}
    		}
    	}
    }
}