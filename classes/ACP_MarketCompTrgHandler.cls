/******************************************************************************************************************
Name: ACP_MarketCompTrgHandler
=======================================================================================================
Requirement: 
Trigger handler for Market and Competition
=======================================================================================================
Purpose:
Trigger Handler to Delete Opportunity TAM Revenue Record when Market Competition record deleted.
Test Class:
ACP_MarketCompTrgHandler_Test
=======================================================================================================
History
-------
VERSION AUTHOR DATE     DETAIL
1.0 -   Esther 09/13/17 INITIAL DEVELOPMENT
2.0 -   Esther 10/31/17 Added Custom Setting Usage to Active/Deactive the Trigger
********************************************************************************************************************/
public class ACP_MarketCompTrgHandler extends ClsTriggerVirtual {
  public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
    if (trgCtx.isAfter) return;
    Boolean isRun;
    Trigger_Configuration__c tc = Trigger_Configuration__c.getInstance('MarketCompetitionDelete'); //Enable/Disable trigger based on Custom Setting

    if (tc != null) isRun = tc.isRun__c;
    if (isRun) {
      if (trgCtx.isDelete) {
        ACP_DeleteOppTAM.delOppty(trgCtx.oldMap.keySet());
      }
    }
  }
}