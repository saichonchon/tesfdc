/**
*  This class contains all helper methods for trigger CustomerSupportSurveyTrigger
*  Case 900745,900748
*  Test Class: CustomerSupportSurveyTrigger_test
*  Code Coverage: 100%
@  author Rajendra Shahane
@  created 2016-04-08
*
*/
public class CustomerSupportSurveyTriggerHandler
{
    public CustomerSupportSurveyTriggerHandler()
    {
    }
        
    public void onBeforeInsert(list<Customer_Support_Survey__c> lstCustSupportSurveyNew, Map<Id,Customer_Support_Survey__c> mapCustSupportSurveyNew)
    {
        CustomerSupportSurveyTriggerUtils.SetCustomerSupportSurveyFields(lstCustSupportSurveyNew,mapCustSupportSurveyNew);
    }
}