/******************************************************************************************************************
Name: ACP_DeleteOppTAM
=======================================================================================================
Requirement: 
Logic for Market and Competition Trigger
=======================================================================================================
Purpose:
Class to Delete Opportunity TAM Revenue Record when Market Competition record deleted.
Test Class:
ACP_MarketCompTrgHandler_Test
=======================================================================================================
History
-------
VERSION AUTHOR DATE     DETAIL
1.0 -   Esther 09/12/17 INITIAL DEVELOPMENT
********************************************************************************************************************/
public without sharing class ACP_DeleteOppTAM
{
   public static void delOppty(Set<Id> set_Id_marks_old)
    {
       list<ACP_Opportunity_TAM_Revenue__c> OppTamList=[select id from ACP_Opportunity_TAM_Revenue__c where ACP_Market_Competition__r.Id in :set_Id_marks_old];
      try 
      {delete OppTamList;}       catch (DMLException e)        {ErrorLogging.Log(e, 'ACP_DeleteOppTAM', 'delOppty', '');    ApexPages.addMessages(e);   }
    
    }
}