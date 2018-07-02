/**
*   This class contains all utility methods for trigger CustomerSupportSurveyTrigger
*   Case 900745,900748.
*  Case 900745,900748
*  Test Class: CustomerSupportSurveyTrigger_test
*  Code Coverage: 94%
@  author Rajendra Shahane
@  created 2016-04-08
*
*/
public class CustomerSupportSurveyTriggerUtils
{
    public static void SetCustomerSupportSurveyFields(list<Customer_Support_Survey__c> lstCustSupportSurveyNew, Map<Id,Customer_Support_Survey__c> mapCustSupportSurveyNew)
    {
        map<Id,List<Customer_Support_Survey__c>> mapCaseIdCustSurvey = new map<Id,List<Customer_Support_Survey__c>>();
        for(Customer_Support_Survey__c custSurvey: lstCustSupportSurveyNew)
        {
            if(!mapCaseIdCustSurvey.containskey(custSurvey.Case__c))
                mapCaseIdCustSurvey.put(custSurvey.Case__c,new List<Customer_Support_Survey__c> {custSurvey});
            else
                mapCaseIdCustSurvey.get(custSurvey.Case__c).add(custSurvey);
        }
        if(mapCaseIdCustSurvey.size() > 0)
        {
            for(Case CustSurveyCase:[select Id, Case_Closed_By__c, ContactId from Case where Id in :mapCaseIdCustSurvey.keySet()])
            {
                for(Customer_Support_Survey__c Survey: mapCaseIdCustSurvey.get(CustSurveyCase.Id))
                {
                    string struserid = CustSurveyCase.Case_Closed_By__c;
                    if(CustSurveyCase.Case_Closed_By__c != null && struserid.startswith('005'))
                        Survey.Survey_Owner__c = (Id)CustSurveyCase.Case_Closed_By__c;
                    if(CustSurveyCase.ContactId != null)
                        Survey.Contact__c = CustSurveyCase.ContactId;
                }
            }
        }
    }
}