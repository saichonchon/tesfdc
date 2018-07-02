/**
*   This trigger is used to recalculate NPS2,NPS3 value when update manufacture start date on oppty -- only for Appliance Oppty
*   which oppty record type is: Opportunity - Engineering Project or Opportunity - Product Platform or Opportunity - Sales Project. 
*   Case 00689465.
*
@  author Michael Cui
@  created 2014-07-15
*
*/
trigger opportunity_AU_RecalculateNPSMSG on Opportunity (after update) 
{
    if(APL_One_Time_Execution.canTrigger('opportunity_AU_RecalculateNPSMSG'))
        APL_Utils_Class.updateNPSMSG(Trigger.Old, Trigger.New);
}