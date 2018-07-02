/***********************************************************************************************************************
      Name : Cls_SchedularAPLJDAPartForecast 
       Org : C2S
 Copyright : © 2016 TE Connectivity 
========================================================================================================================
   Summary : This is a schedular for the Batch Cls_SchedularAPLJDAPartForecast .
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE       DETAIL               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Pankaj Raijade   08/09/2016 Initial Development                   
***********************************************************************************************************************/
global class Cls_SchedularAPLJDAPartForecast implements Schedulable
{
    global void execute(SchedulableContext SC)
    {
        Id batchInstanceId = Database.executeBatch(new Cls_BatchAPLJDAPartForecast(), 1000);     
    }   
}