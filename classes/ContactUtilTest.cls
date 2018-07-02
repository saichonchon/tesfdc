/**************************************************************************************************************************************************
Name:  ContactUtilTest
Copyright © 2011 TE Connectivity
===================================================================================================================================================
Purpose: This class contain Test Methods for Contact Insert, Contact Update and Contact Utility class 
---------------------------------------------------------------------------------------------------------------------------------------------------       
Related APEX Class : ContactUtil                                                              
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer          Date       Detail                                  Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Umasankar Subbaian 11/01/2011 Initial Development                      1453487                                   
**************************************************************************************************************************************************/
//@IsTest(SeeAllData=true)
@IsTest
public class ContactUtilTest
{
 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - Inserting Account records in the Child Org(BU Org)                                                                            |
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
  vAccount.Name                  = 'AMP Foundries Inc';
  vAccount.AnnualRevenue         = 2000000.11; 
  vAccount.Legally_Restricted__c = false; 
  vAccount.BillingCity			 = 'Beijing';	
  vAccount.BillingCountry		 = 'China';
  vAccount.BillingState   	     = '000001';
  vAccount.BillingStreet  		 = 'Tiananmen';
  vAccount.BillingPostalCode	 = '200000';
  
   
  vLstAccount.add(vAccount);
  
  vAccount                       = ClsTestHelp.createTestAccounts();
  vAccount.Name                  = 'TE Foundries Inc';
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
 | Purpose : Test - Inserting Contact at the Child Org(BU Org)                                                                                    |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
  public static void ptInsertContact()
 {
  /*-- 1.0 Collection variable declaration -----------------------------------------*/  
  List<Account> vLstAcctLegallyUnrestricted;
  List<Account> vLstAcctLegallyRestricted;
  List<Contact> vLstContact;
  List<sObject> vLstSo;
  /*-- 1.1 Object variable declaration ---------------------------------------------*/  
  Account vAccount;
  Contact vContact;
  // 1. Create 2 account in Child Org(BU Org)
  vLstSo = new List<sObject>() ;
  ExecuteOnce.SF2SF_CONTACT = false;
  vLstAcctLegallyUnrestricted    = 
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
     WHERE a.Name = 'AMP Foundries Inc'
   ];
  
  vContact                       = new Contact();
  vContact.AccountId             = vLstAcctLegallyUnrestricted[0].Id;
  vContact.FirstName             = 'TestUmasankar';
  vContact.LastName              = 'TestSubbaian';
  vContact.Legally_Restricted__c = false;
  vLstContact                    = new List<Contact>();
  vLstContact.add(vContact);

  vContact                       = new Contact();
  vContact.AccountId             = vLstAcctLegallyUnrestricted[0].Id;
  vContact.FirstName             = 'TestRahul';
  vContact.LastName              = 'TestGharat';
  vContact.Legally_Restricted__c = true;
  vLstContact.add(vContact);
    
  vLstAcctLegallyRestricted = 
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
     WHERE a.Name = 'TE Foundries Inc'
   ];  
  
  vContact                       = new Contact();
  vContact.AccountId             = vLstAcctLegallyRestricted[0].Id;
  vContact.FirstName             = 'TestRajeev';
  vContact.LastName              = 'TestVenkitaraman';
  vContact.Legally_Restricted__c = false;
  vLstContact.add(vContact);

  vContact                       = new Contact();
  vContact.AccountId             = vLstAcctLegallyRestricted[0].Id;
  vContact.FirstName             = 'TestJosh';
  vContact.LastName              = 'TestKaplan';
  vContact.Legally_Restricted__c = true;
  vLstContact.add(vContact);  
  
  Insert vLstContact;
  
  //System.assert(vLstContact.size() > 0,'There should be 2 contacts for 2 accounts created in the volatile memory');   
  
 } // public static void ptInsertContact

 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - Updating Contact records at the Child Org(BU Org)                                                                             |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static void ptUpdateContact()
 {
  /*-- 1.0 Collection variable declaration -----------------------------------------*/  
  List<Contact>                        vLstContact;
  List<PartnerNetworkRecordConnection> vLstPnrc;
  /*-- 1.2 Primitive variable declaration ------------------------------------------*/
  string vStrContactId;  
  
  vLstPnrc = 
   [
    SELECT p.LocalRecordId, 
           p.Status
      FROM PartnerNetworkRecordConnection p  
     WHERE p.Status = 'Sent'  limit 1    
   ]; 
   
  //System.assert(vLstPnrc.size() > 0, 'Please create at least 1 record in PNRC{create contact via UI}');  

  for (PartnerNetworkRecordConnection vPnrc1 : vLstPnrc)
  {
   if (String.ValueOf(vPnrc1.LocalRecordId).substring(0,3) == '003')
   {
    vStrContactId = vPnrc1.LocalRecordId;
    break;
   } // if (String.ValueOf().substring(0,3) == '003')
  } // for (PartnerNetworkRecordConnection vPnrc1 : vLstPnrc)
  
  // System.assert(vStrContactId != null, 'Please create at least 1 contact record manually'); 
  
  vLstContact = 
   [
    SELECT c.AccountId            ,                         
           c.BU_Owner_Email__c    ,
           c.BU_Owner_Name__c     , 
           c.BU_Owner_Phone__c    ,  
           c.Id                   ,
           c.FirstName            ,
           c.LastName             , 
           c.Legally_Restricted__c,
           c.Name                 ,
           c.OwnerId
      FROM Contact c
     WHERE c.Id = :vStrContactId
   ];
   for (contact vContact : vLstContact)
   {
    vContact.FirstName += '1';
    vContact.LastName  += '1';
   } // for (contact vContact : vLstContact)
   Update vLstContact;
   for (contact vContact : vLstContact)
   {
    //System.Debug(vContact.FirstName);
    //System.Debug(vContact.LastName);
   } // for (contact vContact : vLstContact)
 } // public static void ptUpdateContact()
 
 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - inserting contact records and updating contact records                                                                        |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/  
 public static testMethod void contactUpsert()
 {
  test.StartTest();
  ptInsertAccount();
  //ptInsertContact();
  ptUpdateContact();
  test.StopTest();
 } // public static testMethod void contactUpsert()
 
/*-----------------------------------------------------------------------------------------------------------------------------------------------*/  
} // public class ContactUtilTest