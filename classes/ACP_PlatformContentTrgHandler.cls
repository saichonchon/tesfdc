/******************************************************************************************************************
Name: ACP_PlatformContentTrgHandler
=======================================================================================================
Requirement: 
Trigger handler for Platform Content
=======================================================================================================
Purpose:
Trigger Handler to update the comments in Application Breakdown when Platform Content comments updated.
Test Class:
ACP_PlatformContentTrgHandler_Test
=======================================================================================================
History
-------
VERSION AUTHOR DATE     DETAIL
1.0 -   Esther 09/15/17 INITIAL DEVELOPMENT
2.0 -   Esther 10/31/17 Added Custom Setting Usage to Active/Deactive the Trigger
3.0 -   Esther 11/23/17 Removed looping for newMap and oldMap and added directly as trgCtx.oldMap and trgCtx.newMap
********************************************************************************************************************/
public class ACP_PlatformContentTrgHandler extends ClsTriggerVirtual {

  public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
    if (trgCtx.isBefore) return;
    Boolean isRun;
    Trigger_Configuration__c tc = Trigger_Configuration__c.getInstance('PlatformContentUpdate'); //Enable/Disable trigger based on Custom Setting

    if (tc != null) isRun = tc.isRun__c;
    if (isRun) {
      if (trgCtx.isUpdate) {
   
        ACP_TrgClassPlatformContent.updateComments(trgCtx.oldMap, trgCtx.newMap);

      }
    }
  }
}