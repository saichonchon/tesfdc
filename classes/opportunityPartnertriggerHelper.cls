/**
*  This helper class for trigger opportunityPartner_AIUBD_updateOppyLastModifiedDate.
*
@author Pankaj Raijade
@created 2016-03-07
@version 1.0
@since 35.0
*
Test Class: opportunityPartner_AIUDUD_alloTest
COde Coverage - 81%
*/

public class opportunityPartnertriggerHelper
{

    Public static void opportunityPartnerTriggerExceptionhandler(DMLException e, list<Opportunity_Partner__c> triggerOld, list<Opportunity_Partner__c> triggerNew, boolean isDelete)
    {
          // 2014-12-16 Phil Hiemstra - Added DML Exception handling, mostly to catch Funnel OCR related validation errors.
        Map<Id, String> errorMessages = new Map<Id, String>();
        for (Integer i = 0; i < e.getNumDml(); i++) 
            errorMessages.put(Id.valueOf(e.getDmlId(i)), e.getDmlMessage(i));
        
        if(isDelete)
        {
            for(Opportunity_Partner__c n : triggerOld)
                if (errorMessages.containsKey(n.Opportunity__c))
                    n.addError(errorMessages.get(n.Opportunity__c));
        }
        else
        {
            for(Opportunity_Partner__c n : triggerNew)
                if (errorMessages.containsKey(n.Opportunity__c))
                    n.addError(errorMessages.get(n.Opportunity__c));
        }
    }

}