/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   A trigger for Opportunity_Part_Forecast__c.
               The user story number is Opportunity Part Forecast.
Inputs:        
Test Class:    OpportunityPartForecastTrgHandler_Test.cls
History
2017-08-09 Yiming Shen <yiming.shen@capgemini.com> Created
------------------------------------------------------------*/
trigger OpportunityPartForecastTrg on Opportunity_Part_Forecast__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    
    
    ClsTriggerFactory.createHandler(Opportunity_Part_Forecast__c.sObjectType);
}