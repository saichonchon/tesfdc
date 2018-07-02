trigger INDupdateLLRrecord on spExams__User_Exam__c (after Update ) {
  
/*********************************************************************************************************************** 
 Name: INDupdateLLRrecord 
 Salesforce Instance : Sandbox
========================================================================================================================
 Purpose: This trigger is calling by Class INDUpdateLRResFromUserExamTriggerClass to Update the data from SPExam App to the Learning and Responce Object .                                                   
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
 VERSION AUTHOR                DATE         DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
     1.0 Deepak                16 March 2016   Initial Development                                         
***********************************************************************************************************************/
  


//**********************************resuchedule the Exam**********************************************************************************************    
     
  
 if(trigger.isafter)
   {
    INDUpdateLRResFromUserExamTriggerClass.initMethod(trigger.new);
   }    
//**********************************resuchedule the Exam**********************************************************************************************    
  
}