/***********************************************************************************************************************
      Name : ClsBatch_DeleteMonthlyBBB_data_Test
       Org : C2S
 Copyright : Â© 2013 TE Connectivity 
========================================================================================================================
   Summary :This class is usinig  for code coverage of "ClsBatch_DeleteMonthlyBBB_data".
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE        DETAIL               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Ravi   09/06/2013     Initial Development         R-1244                     
***********************************************************************************************************************/


@istest
(seealldata= true)
public class ClsBatch_DeleteMonthlyBBB_data_Test{
    
     public Boolean Call_Query= false;
     
    static testmethod void testm1()
    {
        Account acc = new Account();
        acc.Name = 'TE Acc';
        acc.AnnualRevenue = 100; 
        acc.Legally_Restricted__c = false;  
        acc.BillingCity = 'Hyderabad';
        acc.BillingStreet = 'Hitech city';
        acc.BillingCountry = 'India';
        acc.Type = 'Distributor';
        acc.BillingPostalCode = '500045';
        acc.AccountNumber = '';  
        acc.Industry_Code_Description__c = 'Test';
        insert acc;
        
        
        BBB_Month_Bill_Book_Cust__c MBBB1 = new BBB_Month_Bill_Book_Cust__c();
        MBBB1.Customer__c = acc.id;
        MBBB1.Fiscal_Year__c='2015';
        insert MBBB1;
        
        
        //system.assert(!MDR.isempty());
        
        test.starttest();
        //Cls_Schedule_DeleteMonthlyBBB_data ClsSD = new Cls_Schedule_DeleteMonthlyBBB_data();
        string qry='SELECT Id, Fiscal_Year__c FROM BBB_Month_Bill_Book_Cust__c limit 1';
        ClsBatch_DeleteMonthlyBBB_data BatchMD = new ClsBatch_DeleteMonthlyBBB_data(qry);
        Database.executeBatch(BatchMD,20 );
        test.stoptest();
    }  
}