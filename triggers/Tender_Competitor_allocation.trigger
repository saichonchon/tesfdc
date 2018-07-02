/***********************************************************************************************************************
      Name : Tender_Competitor_allocation
       Org : C2S
 Copyright : © 2013 TE Connectivity 
========================================================================================================================
   Summary : This trigger updates the Tender Competitor fields based on the Allocation and tender detail fields
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE        DETAIL               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Ravi    08/14/2013   Initial Development         Tender Competitor
***********************************************************************************************************************/

trigger Tender_Competitor_allocation on Tender_Competitor__c (Before insert, Before update)
{
    cls_Tender_competitor_allocation.Tender_competitor_allocation(trigger.new);                                                                                               

}