/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   A trigger for Opportunity_Forecast__c.
               The user story number is W-00145.
Inputs:        
Test Class:    OpportunityForecastTrgHandler_Test.cls
History
2017-08-14 Yiming Shen <yiming.shen@capgemini.com> Created
------------------------------------------------------------*/
trigger OpportunityForecastTrg on Opportunity_Forecast__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    
    
    
    ClsTriggerFactory.createHandler(Opportunity_Forecast__c.sObjectType);
}