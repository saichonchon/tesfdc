/**
*   This trigger is used to calculate NPS2,NPS3 value when insert or update oppty forecast-- only for Appliance Oppty
*   which oppty record type is: Opportunity - Engineering Project or Opportunity - Product Platform or Opportunity - Sales Project. Case 00689465.
*
@  author Michael Cui
@  created 2014-06-26
*
*/
trigger CalcNPSAmount on Opportunity_Forecast__c (after insert) 
{     
    //CSD_Utils_Class.updateNPSMSG(Trigger.New);  
          
}