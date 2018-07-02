trigger INDLearningResponseTrigger on Learning_Response_Result__c (after Update,after insert) {
/*********************************************************************************************************************** 
 Name: INDLearningResponseTrigger
 Salesforce Instance : Sandbox
========================================================================================================================
 Purpose: This Trigger is fired on Learning and response object and used to call the class for sending outlook invite for the participants.                                        
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
 VERSION AUTHOR                DATE         DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
     1.0 Deepak                15 Dec 2015   Initial Development                                         
***********************************************************************************************************************/ 


if(trigger.isupdate)
  { 
   
   INDSendOutlookInviteTriggerClass.initMethod(Trigger.newMap.keySet(),trigger.old);
  
  }


}