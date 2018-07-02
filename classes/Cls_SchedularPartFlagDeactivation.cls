/***********************************************************************************************************************
      Name : Cls_SchedularPartFlagDeactivation
       Org : C2S
 Copyright : © 2013 TE Connectivity 
========================================================================================================================
   Summary : This is a schedular for the Batch Class Cls_BatchPartFlagDeactivation.
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE       DETAIL               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Shantinath   06/19/2013 Initial Development  1177                      
***********************************************************************************************************************/
global class Cls_SchedularPartFlagDeactivation implements Schedulable {
	global void execute(SchedulableContext SC) {
    	Cls_BatchPartFlagDeactivation vBatchDeact = new Cls_BatchPartFlagDeactivation();
        Id batchInstanceId = Database.executeBatch(vBatchDeact, 2000); 
    }
}