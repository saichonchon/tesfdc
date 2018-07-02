/***********************************************************************************************************************
Name: ClsSchedule_deleteForecastSnapshot
========================================================================================================================
Purpose: Scheduler for ClsBatch_deleteForecastSnapshot                                                  
========================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                            
------------------------------------------------------------------------------------------------------------------------
1.0    Mrunal            09/15/2015     Initial Development                             
***********************************************************************************************************************/

global class ClsSchedule_deleteForecastSnapshot implements Schedulable
{
    global void execute(SchedulableContext sc){
          ClsBatch_deleteForecastSnapshot objBatchClass = new ClsBatch_deleteForecastSnapshot();
            database.executebatch(objBatchClass);  
    }    
}