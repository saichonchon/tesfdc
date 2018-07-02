/**
*   This trigger is used to Opportunity Spanning Relationship fields by stting required fields in before insert and update events
*   Case 00900679.
*
Test Class: OpportunityTrigger_test
Code Coverage: 100%
@  author Rajendra Shahane
@  created 2016-01-26
*
*/
trigger OpportunityTrigger on Opportunity (before insert,before update,before delete,after insert,after update,after delete,after undelete)
{if(checkRecursive.runOnce() || test.isRunningTest()){
    if(trigger.isbefore)
    {
        if(trigger.isinsert)
        {
            OpportunityTriggerHandler objOpportunityTrgHandler = new OpportunityTriggerHandler();             
            objOpportunityTrgHandler.onBeforeInsert(trigger.new, trigger.newmap);
        }
        
        if(trigger.isupdate)
        {
            OpportunityTriggerHandler objOpportunityTrgHandler = new OpportunityTriggerHandler();             
            objOpportunityTrgHandler.onBeforeUpdate(trigger.old, trigger.new, trigger.oldmap, trigger.newmap);
        }
        
        if(trigger.isdelete)
        {
            
        }
    }
    if(trigger.isafter)
    {
        if(trigger.isinsert)
        {
            
        }
        
        if(trigger.isupdate)
        {
            
        }
        
        if(trigger.isdelete)
        {
            
        }
        
        if(trigger.isundelete)
        {
            
        }
    }
    }
}