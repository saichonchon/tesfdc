/***********************************************************************************************************************
      Name : Cls_SchedularPartFlagActivation
       Org : C2S
 Copyright : © 2013 TE Connectivity 
========================================================================================================================
   Summary : This is a schedular for the Batch Class Cls_BatchPartFlagActivation.
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE       DETAIL               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Shantinath   06/19/2013 Initial Development  1177                      
***********************************************************************************************************************/
global class Cls_SchedularPartFlagActivation implements Schedulable{
    global void execute(SchedulableContext SC) {
        Cls_BatchPartFlagActivation vBatch = new Cls_BatchPartFlagActivation();
        Id batchInstanceId = Database.executeBatch(vBatch, 2000);  
    }   
}