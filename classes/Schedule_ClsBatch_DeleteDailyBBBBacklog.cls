/***********************************************************************************************************************
Name: Schedule_ClsBatch_DeleteDailyBBBBacklog
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S
========================================================================================================================
Purpose: Schedule the (ClsBatch_DeleteDailyBBBBacklogRecords) batch class                                                  
========================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
1.0    Toshi            07/19/2013     Initial Development                                         
***********************************************************************************************************************/

global class Schedule_ClsBatch_DeleteDailyBBBBacklog implements Schedulable
{
  /*_____________________________________________________________________________________________________________________
    | Purpose : Execute                                                                                                   |
    |_____________________________________________________________________________________________________________________|
    | Input Parameter  : Batch class (ClsBatch_DeleteDailyBBBBacklogRecords)Object.                                                                                              |
    |_____________________________________________________________________________________________________________________|
    |  I1. Name        : Schedulable Context                                                                                | 
    |      Data Type   : Database.SchedulableContext                                                                        | 
    |      Description :                                                                                                  |
    |_____________________________________________________________________________________________________________________| 
    | Output Parameter : List of DailyBBB records returned by Qyery                                                                                              
     ______________________________________________________________________________________________________________________*/    
    global void execute(SchedulableContext sc)
    {
        ClsBatch_DeleteDailyBBBBacklogRecords objBatchClass = new ClsBatch_DeleteDailyBBBBacklogRecords();
        database.executebatch(objBatchClass);
    }
}