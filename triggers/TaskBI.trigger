/**********************************************************************************************************************
Name: TaskBI 
Copyright © 2011 TE Connectivity | Salesforce Instance : BU Org
=======================================================================================================================
Purpose: This trigger populate user information (BU Owner Name, BU Owner Email, BU Owner Phone) and Source BU in the 
         task custom fields.                                                  
=======================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                      
-----------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR        DATE       DETAIL                            Mercury Request #
-----------------------------------------------------------------------------------------------------------------------
    1.0 Umasankar   02/14/2012   Initial Development               SMO (1453487)      
**********************************************************************************************************************/
trigger TaskBI on Task (before insert) 
{
 /*-- D1. Collection variable declaration --------------------------------------*/
 List<Task> vLstTask;
 
 if (!ExecuteOnce.SF2SF_TASK)
 {
  vLstTask = Trigger.New;
  TaskUtil.assignBUInfo(vLstTask);
 } // if (!ExecuteOnce.SF2SF_TASK)
 
 /*__________________________________________________________________________________________________________________*/ 
  
} // trigger TaskBI on Task (before insert)