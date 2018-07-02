/***********************************************************************************************************************
      Name : Cls_tender_details_update
       Org : C2S
 Copyright : © 2013 TE Connectivity 
========================================================================================================================
   Summary : This Class updates the Tender Competitor fields based on the  tender detail fields And Called by 
              TenderDetail_BIU Trigger 
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE        DETAIL               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Ravi    08/14/2013   Initial Development         Tender Competitor
***********************************************************************************************************************/


public class Cls_tender_details_update
{
    public static void update_tender_Competitor(List<Tender_Details__c > lst_td)
    { 
        set<Id> tenderIds = new set<Id>();
        set<string> picklist = new set<string>();
    
    for(Tender_Details__c td:lst_td)
    {
        tenderIds.add(td.tender__C);
        picklist.add(td.Product_Line__c);
    
    }
        list<Tender_Competitor__c> updatetc = [select Id,Product_Line__c,TAM_Per_Car__c,TAM_Tender_Total__c,tender__C,Allocation__c 
        from Tender_Competitor__c where tender__C in:tenderIds and Product_Line__c in:picklist];
    
    if(!updatetc.isempty())
        
        update updatetc;
    
    }
}