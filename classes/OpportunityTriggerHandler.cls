/**
*   This test class contains all helper methods for trigger OpportunitySpanningRelationship
*   Case 00900679.
*
@  author Rajendra Shahane
@  created 2016-01-28
*
*/
public class OpportunityTriggerHandler
{
    public OpportunityTriggerHandler()
    {
    }
    public void onBeforeUpdate(list<Opportunity> lstOppOld, list<Opportunity> lstOppNew, Map<Id,Opportunity> mapOppOld, Map<Id,Opportunity> mapOppNew)
    {
        OpportunitytriggerUtils.SetOppSpaningRealationFields(lstOppNew,lstOppOld,mapOppOld,mapOppNew,true);
    }
    
    public void onBeforeInsert(list<Opportunity> lstOppNew, Map<Id,Opportunity> mapOppNew)
    {
        OpportunitytriggerUtils.SetOppSpaningRealationFields(lstOppNew,null,null,mapOppNew,false);
    } 
}