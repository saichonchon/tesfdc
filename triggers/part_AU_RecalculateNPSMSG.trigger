/**
*   This trigger is used to recalculate NPS2,NPS3 value when update marketing date on part 
*   -- only for Appliance Oppty which oppty record type is: Opportunity - Engineering Project or Opportunity - Product Platform  
*   or Opportunity - Sales Project. Case 00689465.
*
@  author Michael Cui
@  created 2014-07-16
@
@ Modified By Mrunal on 2016-08-09
@ Added changes to call UpdateGPL method to Update GPL on Oppty Part when it is updated on related part as per case 901034.
*
*/
trigger part_AU_RecalculateNPSMSG on Part__c (after update) 
{
    CSD_Utils_Class.recalcuNPSMSGonPart(Trigger.Old, Trigger.New);
    ClsOppyPartUtil.updateGPL(Trigger.Old, Trigger.New);// Added for case 901034
}