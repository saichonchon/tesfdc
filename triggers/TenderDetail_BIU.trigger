/***********************************************************************************************************************
      Name : TenderDetail_BIU
       Org : C2S
 Copyright : Â© 2013 TE Connectivity 
========================================================================================================================
   Summary : This Trigger checks the duplicate recoreds on tenderdetail object 
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE        DETAIL               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Ravi    07/15/2013  Initial Development         1206                     
***********************************************************************************************************************/

trigger TenderDetail_BIU on Tender_Details__c (before insert, before update,after update) {
    
    List<Tender_Details__c> TenderDetailsList;    
    List<Tender_Details__c> TenderDetailsList_Old;
        
    if(trigger.isbefore && trigger.isinsert){
        TenderDetailsList = Trigger.new;    
        TenderDetail_DupCheck.FindDuplicateDetailsIns(TenderDetailsList);
    }
    else if(trigger.isbefore && trigger.isupdate){ 
        TenderDetailsList = Trigger.new;    
        TenderDetailsList_Old = Trigger.Old;    
        TenderDetail_DupCheck.FindDuplicateDetails(TenderDetailsList, TenderDetailsList_Old);
    } 
    If(trigger.isafter && trigger.isupdate)
    {
        Cls_tender_details_update.update_tender_Competitor(trigger.new) ; 
    }       
}