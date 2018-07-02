/***********************************************************************************************************************
      Name : CreateTenderDetails
       Org : C2S
 Copyright : © 2013 TE Connectivity 
========================================================================================================================
   Summary : This Trigger creates and updates the tender detail records based on tender object records
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE        DETAIL               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Ravi    07/15/2013  Initial Development         1206                     
***********************************************************************************************************************/

trigger CreateTenderDetails on Tender__c (after insert, after update) {
    
        TenderdetailRec.insertTenderDetail(trigger.new);
            
    
}