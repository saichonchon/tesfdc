/**************************************************************************************************************************************************
Name:  AccountBuTest
Copyright © 2011 TE Connectivity
===================================================================================================================================================
Purpose: This class contain Test Methods for AccountBU 
---------------------------------------------------------------------------------------------------------------------------------------------------       
Related APEX Trigger : AccountBU                                                             
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer          Date       Detail                                  Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Umasankar Subbaian 12/09/2011 Initial Development                      1453487                                   
**************************************************************************************************************************************************/
//@IsTest(SeeAllData=true)
@IsTest
public class AccountBuTest
{

 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - Inserting Account record at the Child Org(BU Org)                                                                             |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static void ptInsertAccount()
 {
  /*-- 1.0 Collection variable declaration -----------------------------------------*/  
  List<Account> vLstAccount;
  /*-- 1.1 Object variable declaration ---------------------------------------------*/  
  Account vAccount;
  
  // 1. Create 2 account in Child Org(BU Org)
  vLstAccount = new List<Account>();
  vAccount                       = ClsTestHelp.createTestAccounts();
  vAccount.Name                  = 'AMP Iron Foundries Inc';
  vAccount.AnnualRevenue         = 2000000.11; 
  vAccount.Legally_Restricted__c = false;  
  
  vAccount.BillingCity			 = 'Shanghai';	
  vAccount.BillingCountry		 = 'China';
  vAccount.BillingState   	     = '000000';
  vAccount.BillingStreet  		 = 'Changning';
  vAccount.BillingPostalCode	 = '200051';
  
  vLstAccount.add(vAccount);
  
  vAccount                       = ClsTestHelp.createTestAccounts();
  vAccount.Name                  = 'TE Aluminium Foundries Inc';
  vAccount.Legally_Restricted__c = true; 
  vAccount.AnnualRevenue         = 1000000.11; 
  
  vAccount.BillingCity			 = 'Beijing';	
  vAccount.BillingCountry		 = 'China';
  vAccount.BillingState   	     = '000001';
  vAccount.BillingStreet  		 = 'Tiananmen';
  vAccount.BillingPostalCode	 = '200000';
  
  vLstAccount.add(vAccount);  
  Insert vLstAccount; 
  //System.assert(vLstAccount.size() > 0,'There should be 2 accounts created in the volatile memory');    
  // Don't know to cover Exception Handling part of AccountAI trigger
  
 } // public static void ptInsertAccount
 
 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - Account before update trigger                                                                                                 |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static void ptAccountBu()
 {
  /*-- 1.0 Collection variable declaration -----------------------------------------*/  
  List<Account> vLstAccount;
  
  vLstAccount = 
   [
    SELECT a.AnnualRevenue        ,
           a.BU_Owner_Email__c    ,
           a.BU_Owner_Name__c     , 
           a.BU_Owner_Phone__c    ,  
           a.Id                   ,
           a.Legally_Restricted__c, 
           a.Name                 ,
           a.OwnerID
      FROM Account a
     WHERE a.Name IN ('AMP Iron Foundries Inc', 'TE Aluminium Foundries Inc')
  ];
  Update vLstAccount; 
 } // public static void ptAccountBu()

 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - updating account records                                                                                                      |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static void ptUpdateAccount()
 {
  /*-- 1.0 Collection variable declaration -----------------------------------------*/  
  List<Account>                        vLstAccount;
  List<PartnerNetworkRecordConnection> vLstPnrc;
  /*-- 1.2 Primitive variable declaration ------------------------------------------*/
  string vStrAccountId;
    
  vLstPnrc = 
   [
    SELECT p.LocalRecordId, 
           p.Status
      FROM PartnerNetworkRecordConnection p  
     WHERE p.Status = 'Sent' limit 1     
   ]; 
   
  //System.assert(vLstPnrc.size() > 0, 'Please create at least 1 record in PNRC{create an account via UI}');  
  
  for (PartnerNetworkRecordConnection vPnrc1 : vLstPnrc)
  {
   if (String.ValueOf(vPnrc1.LocalRecordId).substring(0,3) == '001')
   {
    vStrAccountId = vPnrc1.LocalRecordId;
    break;
   } // if (String.ValueOf().substring(0,3) == '001')
  } // for (PartnerNetworkRecordConnection vPnrc1 : vLstPnrc)
  
  //System.assert(vStrAccountId != null, 'Please create at least 1 account record manually'); 
  
  vLstAccount = 
   [
    SELECT a.AnnualRevenue        ,
           a.BU_Owner_Email__c    ,
           a.BU_Owner_Name__c     , 
           a.BU_Owner_Phone__c    ,  
           a.Id                   ,
           a.Legally_Restricted__c, 
           a.Name                 ,
           a.OwnerID              ,  
           a.BillingCity	      ,
  		   a.BillingCountry		  ,
  		   a.BillingState   	  ,
  		   a.BillingStreet  	  ,
           a.BillingPostalCode	 
           
           
           
      FROM Account a
     WHERE a.Id = :vStrAccountId
    ];
  
    
 // vLstAccount[0].Name += '1';
  ExecuteOnce.SF2SF_ACCOUNT = false;
  Update vLstAccount;
  //System.assert(vLstAccount.size() > 0 , 'Account is not updated');   
 } // public static void ptUpdateAccount()
 
 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - Account before update trigger                                                                                                 |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static testMethod void TestTrigger()
 {
  test.StartTest();
  ptInsertAccount();
  ptAccountBu();
  ptUpdateAccount();
  test.StopTest();
 } // public static testMethod void TestTrigger()
 
 /*-----------------------------------------------------------------------------------------------------------------------------------------------*/ 
 
} // public class AccountBuTest