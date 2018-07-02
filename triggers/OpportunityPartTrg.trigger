/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   A trigger for Opportunity_Part__c.
               The user story number is W-00018, W-00459.
Inputs:        
Test Class:    OpportunityPartTrgHandler_Test.cls
History
2017-08-09 Yiming Shen <yiming.shen@capgemini.com> Created
------------------------------------------------------------*/
trigger OpportunityPartTrg on Opportunity_Part__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    System.debug('----OpportunityPartTrg----Limits.getCpuTime--------'+Limits.getCpuTime());
    
    
    //Added by Tangyong Li 2017-12-06
    if(trigger.isInsert || trigger.isUpdate || trigger.isUndelete) {
        
        set<Id> set_oppyIds = new set<Id>();
        for(Opportunity_Part__c part : trigger.new){
            set_oppyIds.add(part.Opportunity__c);
        }
        if(!ClsTriggerRecursionDefense.avoidMultipleRunningForTrigger(set_oppyIds)) {
            return;
        }
    } else if(trigger.isDelete) {
        set<Id> set_oppyIds = new set<Id>();
        for(Opportunity_Part__c part : trigger.old){
            set_oppyIds.add(part.Opportunity__c);
        }
        if(!ClsTriggerRecursionDefense.avoidMultipleRunningForTrigger(set_oppyIds)) {
            return;
        }
    }
    //End
    
    
    ClsTriggerFactory.createHandler(Opportunity_Part__c.sObjectType);
}