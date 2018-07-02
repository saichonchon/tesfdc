/**************************************************************************************************************************************************
Name:  OpportunityDAOTest
Copyright © 2011 TE Connectivity | Instance : BU Org(Energy)
===================================================================================================================================================
Purpose: This class contain Test Methods for Opportunity DAO class
---------------------------------------------------------------------------------------------------------------------------------------------------
Apex classes whose code is covered  : OpportunityDAOTest                                                    
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer          Date       Detail                                  Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Umasankar Subbaian 11/07/2011 Initial Development                     1453487                                   
**************************************************************************************************************************************************/
@isTest
public class OpportunityDAOTest
{
 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - Create Account & Opportunity records in BU org                                                                                |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/
 public static void ptInsertOppty()
 {
  /*-- 1.0 Collection variable declaration -----------------------------------------*/  
  List<Account>     vLstAccount;
  List<Opportunity> vLstOppty;
 
  /*-- 1.1 Object variable declaration ---------------------------------------------*/  
  Account vAccount;
  Opportunity vOppty;
    
  // 1. Create 2 account in Child Org(BU Org)
  vLstAccount = new List<Account>();
  vAccount                       = ClsTestHelp.createTestAccounts();
  vAccount.Name                  = 'AMP Foundries Inc';
  vAccount.AnnualRevenue         = 2000000.11; 
  vAccount.Legally_Restricted__c = false;  
  
  vAccount.BillingCity			 = 'Shanghai';	
  vAccount.BillingCountry		 = 'China';
  vAccount.BillingState   	     = '000000';
  vAccount.BillingStreet  		 = 'Changning';
  vAccount.BillingPostalCode	 = '200051';
  vLstAccount.add(vAccount);
  
  vAccount                       = ClsTestHelp.createTestAccounts();
  vAccount.Name                  = 'TE Foundries Inc';
  vAccount.Legally_Restricted__c = false; 
  vAccount.AnnualRevenue         = 1000000.11;
  vAccount.BillingCity			 = 'Shanghai';	
  vAccount.BillingCountry		 = 'China';
  vAccount.BillingState   	     = '000000';
  vAccount.BillingStreet  		 = 'Changning';
  vAccount.BillingPostalCode	 = '200051'; 
  vLstAccount.add(vAccount);  
  Insert vLstAccount; 
 // System.assert(vLstAccount.size() > 0,'There should be 2 accounts created in the volatile memory');    
  
  /*vOppty                       = new Opportunity();
  vOppty.AccountId             = vLstAccount[0].Id;
  vOppty.Name                  = 'Generator';
  vOppty.Legally_Restricted__c = false;
  vOppty.StageName             = 'Lead';
  vOppty.CloseDate             = Date.Today(); 
  vLstOppty                    = new List<Opportunity>();
  vLstOppty.add(vOppty);

  vOppty                       = new Opportunity();
  vOppty.AccountId             = vLstAccount[0].Id;
  vOppty.Name                  = 'Crank Case';
  vOppty.Legally_Restricted__c = false;
  vOppty.StageName             = 'Lead';
  vOppty.CloseDate             = Date.Today(); */
  //start : added by di.chen 2012/9/7
  Profile p = [Select Id, Name From Profile 
     							where Name = 'Channel Standard User' 
     							or Name = 'Service Account' 
     							or Name ='System Administrator' 
     							or Name ='Systemadministrator' limit 1];
  User u = ClsTestHelp.createTestUsers();
  u.Email = 'abc@testCompany1233423.com';
  u.Alias = 'abc';
  u.CommunityNickname = 'TsMD';
  u.ProfileId = p.Id;
  insert u;
    	
  system.runAs(u){
  Account acc = ClsTestHelp.createTestAccounts();
  acc.LEVEL_1_INDUSTRY_CDE__c = '0001';
  insert acc;
  vOppty = ClsTestHelp.createTestOpportunity();
  vLstOppty = new List<Opportunity>();
  //end
  vLstOppty.add(vOppty);
  Insert vLstOppty;
  
  
  
  //System.assert(vLstOppty.size() > 0,'There should be 2 Opportunities created in the volatile memory');   
  // Don't know to cover Exception Handling part of AccountAI trigger
  }
 } // public static void ptInsertOppty() 

 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - Read Opportunity records in BU Org | Test behavior : Positive                                                                 |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/
 public static void ptSelectOppty()
 {
  /*-- 1.0 Collection variable declaration -----------------------------------------*/  
  List<Account>     vLstAccount;
  List<Opportunity> vLstOppty;
  List<String>      vLstAccountId;
  vLstAccount = 
   [
    SELECT a.Id
      FROM Account a
     WHERE a.Name in ('AMP Foundries Inc', 'TE Foundries Inc') 
   ];
  vLstAccountId = new List<String>();  
  for (Account vAccount: vLstAccount)
  {
   vLstAccountId.add(vAccount.Id);
  } // for (Account vAccount: vLstAccount) 
  
  vLstOppty = OpportunityDAO.getOpportunitiesByAccountId(vLstAccountId);  
 } // public static void ptSelectOppty()

 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - Reading Opportunity records                                                                                                   |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
  public static testMethod void readOppty()
 {
  test.StartTest();
  ptInsertOppty();
  ptSelectOppty();
  test.StopTest();
 } // public static testMethod void readOppty() 
 /*----------------------------------------------------------------------------------------------------------------------------------------------*/ 
 
} // public class OpportunityDAOTest