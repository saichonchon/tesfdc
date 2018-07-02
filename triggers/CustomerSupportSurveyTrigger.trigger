/**
*   This trigger is used to populate Survey_Owner__c and Contact field on Customer_Support_Survey__c
*   Case 900745,900748
*
Test Class: CustomerSupportSurveyTrigger_test
Code Coverage: 100%
@  author Rajendra Shahane
@  created 2016-04-04
*
*/
trigger CustomerSupportSurveyTrigger on Customer_Support_Survey__c (before insert,after insert,before update,after update,before delete,after delete,after undelete)
{
	if(trigger.isbefore)
    {
        if(trigger.isinsert)
        {
           CustomerSupportSurveyTriggerHandler objCustSupportSurveyTrgHandler = new CustomerSupportSurveyTriggerHandler();
            objCustSupportSurveyTrgHandler.onBeforeInsert(trigger.new, trigger.newmap);
        }
        
        if(trigger.isupdate)
        {
            
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