/***********************************************************************************************************************
      Name :Cls_tender_details_update_test
       Org : C2S
 Copyright : © 2013 TE Connectivity 
========================================================================================================================
   Summary : Test class for cls_Tender_competitor_allocation
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE        DETAIL               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Ravi    08/14/2013   Initial Development         Tender Competitor
***********************************************************************************************************************/

@istest(seealldata=true)
public class cls_Tender_competitor_allocation_test
{
    public static testmethod void Tender_competitor_allocation_test()
    {
        
        tender__c t1 = new tender__c();
        t1.name = 'test';
        t1.Country_of_Service__c ='us';
        t1.Number_of_Trains__c=2;
        t1.Number_of_Train_Carriages__c=3;
        insert t1;
        system.assert(t1.id!=null);
        
       Tender_competitor__c TC = new Tender_competitor__c();
       TC.tender__c =t1.id;
       TC.allocation__c=10;
       TC.product_line__c='others';
       insert TC;
       system.assert(TC.id!=null);
      
    }
}