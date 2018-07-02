/***********************************************************************************************************************
      Name : Cls_Schedule_DeleteMonthlyBBB_data_test
       Org : C2S
 Copyright : © 2013 TE Connectivity 
========================================================================================================================
   Summary :This class for code coverage "Cls_Schedule_DeleteMonthlyBBB_data".
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE        DETAIL               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Ravi    07/15/2013  Initial Development         1206                     
***********************************************************************************************************************/


@istest
(seealldata=false)
Public class Cls_Schedule_DeleteMonthlyBBB_data_test
{
    public static  testmethod void sch_test()
    {
        ClsTestCustomSettingHelper.getAllSettings();
        Account oAccount = ClsTestHelp.createTestAccounts();
        insert oAccount;
        Product_Hierarchy__c oProductHierarchy = new Product_Hierarchy__c();
        insert oProductHierarchy;
        
        Part__c oPart = new Part__c(Product_Hierarchy__c = oProductHierarchy.id);
        insert oPart;
        
        BBB_Month_Bill_Book_Cust_PN__c obbbMonthly = new BBB_Month_Bill_Book_Cust_PN__c(Customer__c = oAccount.Id, Part__c = oPart.ID);
        insert obbbMonthly;
        test.starttest();
        Cls_Schedule_DeleteMonthlyBBB_data schDBBB = new Cls_Schedule_DeleteMonthlyBBB_data();
        string STime ='0 0 23 * * ?';
        system.schedule('schDBBB',STime,schDBBB );
        
        test.stoptest();
      }
     
  }