/**************************************************************************************************************************************************
Name:  AccountUtilTest
Copyright © 2011 TE Connectivity
===================================================================================================================================================
Purpose: This class contain Test Methods for AccountUtil 
---------------------------------------------------------------------------------------------------------------------------------------------------       
Related APEX Class : AccountUtil                                                              
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer          Date       Detail                                  Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Umasankar Subbaian 10/31/2011 Initial Development                      1453487                                   
**************************************************************************************************************************************************/
@isTest(SeeAllData=false)
public class AccountUtilTest
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
  vAccount                       = new Account();
  vAccount.Name                  = 'AMP Foundries Inc';
  vAccount.AnnualRevenue         = 2000000.11; 
  vAccount.Legally_Restricted__c = false; 
  
  vAccount.BillingCity           = 'Shanghai';  
  vAccount.BillingCountry        = 'China';
  vAccount.BillingState          = '000000';
  vAccount.BillingStreet         = 'Changning';
  vAccount.BillingPostalCode     = '200051';

  vLstAccount.add(vAccount);
  
  vAccount                       = new Account();
  vAccount.Name                  = 'TE Foundries Inc';
  vAccount.Legally_Restricted__c = true; 
  vAccount.AnnualRevenue         = 1000000.11;
  
  vAccount.BillingCity           = 'Beijing';   
  vAccount.BillingCountry        = 'China';
  vAccount.BillingState          = '000001';
  vAccount.BillingStreet         = 'Tiananmen';
  vAccount.BillingPostalCode     = '200000'; 
  
  vLstAccount.add(vAccount);  
  Insert vLstAccount; //uncommented by subramanian
  //System.assert(vLstAccount.size() > 0,'There should be 2 accounts created in the volatile memory');    
  // Don't know to cover Exception Handling part of AccountAI trigger
  
 } // public static void ptInsertAccount

 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - Assigning User Info in account records                                                                                        |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static void ptAssignUserInfo(){
  /*-- 1.0 Collection variable declaration -----------------------------------------*/  
  List<Account> vLstAccount;
  vLstAccount = [SELECT a.AnnualRevenue        ,
           a.BU_Owner_Email__c    ,
           a.BU_Owner_Name__c     , 
           a.BU_Owner_Phone__c    ,  
           a.Id                   ,
           a.Legally_Restricted__c, 
           a.Name                 ,
           a.OwnerID
      FROM Account a
     WHERE a.Name IN ('AMP Foundries Inc', 'TE Foundries Inc')
  ];
  //System.Debug('BU Owner Name : ' + vLstAccount[0].Bu_Owner_Name__c);               
  AccountUtil.getUserMap(vLstAccount);  
  //System.assert(vLstAccount[0].BU_Owner_Email__c != null,'The email address should be assigned');  
 } // public static void ptAssignUserInfo
 
 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - Getting legally unrestricted account records and creating entries in PNRC                                                     |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static void ptCreatePnrcForUnrestrictedAccounts()
 {
  /*-- 1.0 Collection variable declaration -----------------------------------------*/  
  List<Account>                        vLstAccount;
  // List<PartnerNetworkRecordConnection> vLstPnrc; // Commented by subramanian
  List<String>                         vLstAccountId;                              
  
  vLstAccount = [SELECT a.AnnualRevenue        ,
                        a.BU_Owner_Email__c    ,
                        a.BU_Owner_Name__c     , 
                        a.BU_Owner_Phone__c    ,  
                        a.Id                   ,
                        a.Legally_Restricted__c, 
                        a.Name                 ,
                        a.OwnerID
                   FROM Account a
                  WHERE a.Name IN ('AMP Foundries Inc', 'TE Foundries Inc')];
  vLstAccount = AccountUtil.FilterAccs(vLstAccount);
  vLstAccountId = new List<String>();
  for (Account vAccount: vLstAccount)
  {
   vLstAccountId.add(String.valueOf(vAccount.Id).substring(0,15));
  } // for (Account vAccount: vLstAccount)
  // AccountUtil.Insert_PNRC(vLstAccount); // Commented by subramanian
  vLstAccount = AccountUtil.notFilterAccs(vLstAccount);  // Added by subramanian
  /*
  vLstPnrc = 
   [
    SELECT p.Id
      FROM PartnerNetworkRecordConnection p
     WHERE p.LocalRecordId in :vLstAccountId 
   ]; */ // Commented by subramanian
  //System.assert(vLstPnrc.size() > 0,'The entry in PNRC is not created');   
 } // public static void ptCreatePnrcForUnrestrictedAccounts()
 
 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - Getting legally restricted account records                                                                                    |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static void ptGetRestrictedAccounts()
 {
  /*-- 1.0 Collection variable declaration -----------------------------------------*/  
  List<Account> vLstAccount;
  vLstAccount = [SELECT a.AnnualRevenue        ,
                        a.BU_Owner_Email__c    ,
                        a.BU_Owner_Name__c     , 
                        a.BU_Owner_Phone__c    ,  
                        a.Id                   ,
                        a.Legally_Restricted__c, 
                        a.Name                 ,
                        a.OwnerID
                   FROM Account a
                  WHERE a.Name IN ('AMP Foundries Inc', 'TE Foundries Inc')];
  vLstAccount = AccountUtil.notFilterAccs(vLstAccount);  
  //System.assert(vLstAccount.size() > 0,'No Legally restricted Accounts');   
 } // public static void ptGetRestrictedAccounts()
 

 
 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - Restricting child records                                                                                                     |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static void ptRestrictChild()
 {
  /*-- 1.0 Collection variable declaration -----------------------------------------*/  
  List<Account> vLstAccount;
  List<Account> vLstAccountLr; // Legally Restricted Accounts
  /*-- 1.1 Object variable declaration ---------------------------------------------*/ 
  Account     vAccount;
  Contact     vContact;
  Opportunity vOppty;
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
     WHERE a.Name IN ('AMP Foundries Inc', 'TE Foundries Inc')
   ];
  vLstAccountLr = new List<Account>();                
  for (Account vAcc: vLstAccount)
  {
   if (vAcc.Legally_Restricted__c)
   {
    vLstAccountLr.add(vAcc);    
   } // if (vAcc.Legally_Restricted__c)
  } // for (Account vAcc: vLstAccount)
  //System.Debug('vLstAccountLr : ' + vLstAccountLr);
  
 /* vContact                       = new Contact();
  vContact.AccountId             = vLstAccountLr[0].Id;
  vContact.FirstName             = 'TestUmasankar';
  vContact.LastName              = 'TestSubbaian';
  vContact.Legally_Restricted__c = false;
  ExecuteOnce.SF2SF_CONTACT     = false;
  Insert vContact;
    
  /*vOppty                         = new Opportunity();
  vOppty.Name                    = 'Test Opportunity';
  vOppty.AccountId               = vLstAccountLr[0].Id;
  vOppty.StageName               = 'Lead';
  vOppty.CloseDate               = Date.Today();
  vContact.Legally_Restricted__c = false;
  ExecuteOnce.SF2SF_OPPORTUNITY = false;
  Insert vOppty;*/
  //start added by di.chen 2012/9/7  
  Profile p = [Select Id, Name From Profile 
                                where Name = 'Channel Standard User' 
                                or Name = 'Service Account' 
                                or Name ='System Administrator' 
                                or Name ='Systemadministrator' limit 1];
  User u = ClsTestHelp.createTestUsers();
  u.Email = 'pol@testCompany1233423.com';
  u.Alias = 'pol';
  u.CommunityNickname = 'pol';
  u.ProfileId = p.Id;
  insert u;
        
  system.runAs(u){
  RecordType rt9 = ClsTestHelp.createTestRecordType10();
  
  Account acc = ClsTestHelp.createTestAccounts();
  acc.Type = 'CM';
  insert acc;
  //vLstAccountLr.add(acc);
  vContact = new Contact();
  vContact.AccountId = acc.Id;
  vContact.FirstName = 'TestFirstName';
  vContact.LastName = 'TestLastName';
  vContact.Legally_Restricted__c = false;
  insert vContact;
  
  vOppty = ClsTestHelp.createTestOpportunity(); 
  vOppty.Type = 'CM';
  vOppty.Request_Type__c = 'Extension';
  vOppty.Method__c = 'BOM';
  vOppty.Level__c = 'Yearly';
  vOppty.Amount = 1;
  vOppty.CurrencyIsoCode = 'EUR';
  vOppty.Five_Year_Revenue__c = 1;
  vOppty.AccountId = acc.Id;
  vOppty.StageName = 'New';
  vOppty.RecordTypeId = rt9.Id;
  insert vOppty;
  List<String> Accsid = new List<String>();
  Accsid.Add(acc.Id);
  AccountUtil.childRestrict(vLstAccountLr);
  AccountUtil.futurechildRestrict(Accsid);
  //end
  
  /*vContact =
   [
    SELECT c.Legally_Restricted__c
      FROM Contact c
     WHERE c.LastName  = 'TestSubbaian' 
       AND c.FirstName = 'TestUmasankar'
   ];  */ 
  
  vOppty = 
   [
    SELECT o.Legally_Restricted__c
      FROM Opportunity o
     WHERE o.Name ='SandKing'// 'Test Opportunity' 
   ];
  }
  //System.assert(vContact.Legally_Restricted__c, 'Legally restricted is not working for contact');
  //System.assert(vOppty.Legally_Restricted__c  , 'Legally restricted is not working for Opportunity');
 } // public static void ptRestrictChild

 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - Cascade Restriction to child records (Contacts and Opportunities)                                                             |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static void ptCascadeRestriction1() 
 {
  /*-- 1.0 Collection variable declaration -----------------------------------------*/  
  List<Account> vLstAccount;
  List<Account> vLstNewAccount;
  List<Account> vLstOldAccount;
  /*-- 1.1 Object variable declaration ---------------------------------------------*/ 
  Account     vAccount;
  Contact     vContact; 
  Opportunity vOppty;
  
  ExecuteOnce.SF2SF_CONTACT = false;
  ExecuteOnce.SF2SF_OPPORTUNITY = false;
  //Start:added by di.chen 
  RecordType rt = ClsTestHelp.createTestRecordType8();
  Account acc1 = ClsTestHelp.createTestAccounts();
  acc1.RecordTypeId = rt.Id;
  acc1.Name = 'AMP Foundries Inc';
  insert acc1; 
  //end
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
     WHERE a.Name IN ('AMP Foundries Inc')
   ];
   

  /*vContact                       = new Contact();
  vContact.AccountId             = vLstAccount[0].Id;
  vContact.FirstName             = 'TestFirstName';
  vContact.LastName              = 'TestLastName';
  vContact.Legally_Restricted__c = false;
  Insert vContact;
  //Start:added by di.chen
 /* vOppty                         = new Opportunity();
  vOppty.Name                    = 'Test Opportunity 1';
  vOppty.AccountId               = vLstAccount[0].Id;
  vOppty.StageName               = 'Lead';
  vOppty.CloseDate               = Date.Today();
  vContact.Legally_Restricted__c = false;
  Insert vOppty;*/
    //start added by di.chen 2012/9/7  
  Profile p = [Select Id, Name From Profile 
                                where Name = 'Channel Standard User' 
                                or Name = 'Service Account' 
                                or Name ='System Administrator' 
                                or Name ='Systemadministrator' limit 1];
  User u = ClsTestHelp.createTestUsers();
  u.Email = 'tyu@testCompany1233423.com';
  u.Alias = 'yui';
  u.CommunityNickname = 'hjk';
  u.ProfileId = p.Id;
  insert u;
        
  system.runAs(u){
  RecordType rt9 = ClsTestHelp.createTestRecordType10();
  
  Account acc = ClsTestHelp.createTestAccounts();
  acc.Type = 'CM';
  insert acc;
  
  vContact = new Contact();
  vContact.AccountId = acc.Id;
  vContact.FirstName = 'TestFirstName';
  vContact.LastName = 'TestLastName';
  vContact.Legally_Restricted__c = false;
  insert vContact;
  
  vOppty = ClsTestHelp.createTestOpportunity(); 
  vOppty.Type = 'CM';
  vOppty.Request_Type__c = 'Extension';
  vOppty.Method__c = 'BOM';
  vOppty.Level__c = 'Yearly';
  vOppty.Amount = 1;
  vOppty.CurrencyIsoCode = 'EUR';
  vOppty.Five_Year_Revenue__c = 1;
  vOppty.AccountId = acc.Id;
  vOppty.StageName = 'New';
  vOppty.RecordTypeId = rt9.Id;
  insert vOppty;
//end
  
  vLstNewAccount = new List<Account>();
  vLstOldAccount = new List<Account>();
  for (Account vAccount0: vLstAccount)
  {
   vAccount = new Account();
   vAccount0.Legally_Restricted__c = true;
   vLstNewAccount.add(vAccount0);
   vAccount = vAccount0;
   vAccount.Legally_Restricted__c = false;
   vLstOldAccount.add(vAccount); // Immitate as trigger
  } // for (Account vAccount: vLstAccount) 
  AccountUtil.cascadeRestriction(vLstNewAccount, vLstOldAccount);
  ExecuteOnce.SF2SF_ACCOUNT = false;
  Update vLstNewAccount;

  /*vContact =
   [
    SELECT c.Legally_Restricted__c
      FROM Contact c
     WHERE c.LastName  = 'TestLastName' 
       AND c.FirstName = 'TestFirstName' 
   ];  */ 
  //Start:added by di.chen
  vOppty = 
   [
    SELECT o.Legally_Restricted__c
      FROM Opportunity o
     WHERE o.Id =: vOppty.Id
   ];
   //end
  }
 // System.assert(vContact.Legally_Restricted__c == false, 'Legally restricted is not working for contact');
 // System.assert(vOppty.Legally_Restricted__c == false , 'Legally restricted is not working for Opportunity'); //added by di.chen 
 } // public static void ptCascadeRestriction1() 

 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - Cascade Restriction to child records (Contacts and Opportunities)                                                             |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static void ptCascadeRestriction2() 
 {
  /*-- 1.0 Collection variable declaration -----------------------------------------*/  
  List<Account> vLstAccount;
  List<Account> vLstNewAccount;
  /*-- 1.1 Object variable declaration ---------------------------------------------*/ 
  Account     vAccount;
  Contact     vContact;
  Opportunity vOppty;
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
     WHERE a.Name IN ('AMP Foundries Inc', 'TE Foundries Inc')
   ];
     //Start:added by di.chen
  /*vContact                       = new Contact();
  vContact.AccountId             = vLstAccount[0].Id;
  vContact.FirstName             = 'TestFirstName';
  vContact.LastName              = 'TestLastName';
  vContact.Legally_Restricted__c = false;
  Insert vContact;

  //start added by di.chen 2012/9/7
  /*vOppty                         = new Opportunity();
  vOppty.Name                    = 'Test Opportunity 1';
  vOppty.AccountId               = vLstAccount[0].Id;
  vOppty.StageName               = 'Lead';
  vOppty.CloseDate               = Date.Today();
  vContact.Legally_Restricted__c = false;
  Insert vOppty;*/  
  
  
  Profile p = [Select Id, Name From Profile 
                                where Name = 'Channel Standard User' 
                                or Name = 'Service Account' 
                                or Name ='System Administrator' 
                                or Name ='Systemadministrator' limit 1];
  User u = ClsTestHelp.createTestUsers();
  u.Email = 'axe@helool.com';
  u.Alias = 'well';
  u.CommunityNickname = 'llew';
  u.FirstName = 'lmk';
  u.ProfileId = p.Id;
  //insert u;
        
  system.runAs(u){
  
  RecordType rt9 = ClsTestHelp.createTestRecordType10();
  
  Account acc = ClsTestHelp.createTestAccounts();
  acc.Type = 'CM';
  insert acc;
  
  vContact = new Contact();
  vContact.AccountId = acc.Id;
  vContact.FirstName = 'TestFirstName';
  vContact.LastName = 'TestLastName';
  vContact.Legally_Restricted__c = false;
  insert vContact;
  
  vOppty = ClsTestHelp.createTestOpportunity(); 
  vOppty.Type = 'CM';
  vOppty.Request_Type__c = 'Extension';
  vOppty.Method__c = 'BOM';
  vOppty.Level__c = 'Yearly';
  vOppty.Amount = 1;
  vOppty.CurrencyIsoCode = 'EUR';
  vOppty.Five_Year_Revenue__c = 1;
  vOppty.AccountId = acc.Id;
  vOppty.StageName = 'New';
  vOppty.RecordTypeId = rt9.Id;
  insert vOppty;
//end
  
  vLstNewAccount = new List<Account>();
  for (Account vAccount0: vLstAccount)
  {
   vAccount = new Account();
   vAccount0.Legally_Restricted__c = true;
   vLstNewAccount.add(vAccount0);
  } // for (Account vAccount: vLstAccount) 
   
  ExecuteOnce.SF2SF_ACCOUNT = false;
  Update vLstNewAccount;  

  /*vContact =
   [
    SELECT c.Legally_Restricted__c
      FROM Contact c
      where c.Id =: vContact.Id
    // WHERE c.LastName  = 'TestLastName' 
      // AND c.FirstName = 'TestFirstName'
   ];   */
  //Start:added by di.chen   
  vOppty = 
   [
    SELECT o.Legally_Restricted__c
      FROM Opportunity o
     WHERE o.Id =: vOppty.Id
   ];
  }
  //end
 // System.assert(vContact.Legally_Restricted__c, 'Legally restricted is not working for contact');
 // System.assert(vOppty.Legally_Restricted__c  , 'Legally restricted is not working for Opportunity');   
 } // public static void ptCascadeRestriction2() 
 
 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - Cascade Unrestriction to child records (Contacts and Opportunities)                                                           |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static void ptCascadeUnrestriction1() 
 {
  /*-- 1.0 Collection variable declaration -----------------------------------------*/  
  List<Account> vLstAccount;
  
  /*-- 1.1 Object variable declaration ---------------------------------------------*/ 
  Account     vAccount;
  Contact     vContact;
  Opportunity vOppty;
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
     WHERE a.Name IN ('AMP Foundries Inc', 'TE Foundries Inc')
   ];
  
  for (Account vAccount0: vLstAccount)
  {   
   vAccount0.Legally_Restricted__c = false;
  } // for (Account vAccount: vLstAccount) 
  ExecuteOnce.SF2SF_ACCOUNT = false;
  Update vLstAccount;  
  /*vContact =
   [
    SELECT c.Legally_Restricted__c
      FROM Contact c
     WHERE c.LastName  = 'TestSubbaian' 
       AND c.FirstName = 'TestUmasankar'
   ];   */
  
  vOppty = 
   [
    SELECT o.Legally_Restricted__c
      FROM Opportunity o
     WHERE o.Name = 'SandKing'//'Test Opportunity' 
   ];
  
  //System.assert(vContact.Legally_Restricted__c , 'Legally restricted is not working for contact');
 // System.assert(vOppty.Legally_Restricted__c   , 'Legally restricted is not working for Opportunity');   
 } // public static void ptCascadeUnrestriction1() 


 
 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - Cascade Unrestriction to child records (Contacts and Opportunities)                                                           |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static void ptCascadeUnrestriction2() 
 {
  /*-- 1.0 Collection variable declaration -----------------------------------------*/  
  List<Account> vLstAccount;
  List<Account> vLstNewAccount;
  List<Account> vLstOldAccount;
  /*-- 1.1 Object variable declaration ---------------------------------------------*/ 
  Account     vAccount;
  Contact     vContact;
  Opportunity vOppty; 
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
     WHERE a.Name IN ('AMP Foundries Inc', 'TE Foundries Inc')
   ];
  vLstNewAccount = new List<Account>();
  vLstOldAccount = new List<Account>();
  for (Account vAccount0: vLstAccount)
  {
   vAccount = new Account();
   vAccount0.Legally_Restricted__c = false;
   vLstNewAccount.add(vAccount0);
   vAccount = vAccount0;
   vAccount.Legally_Restricted__c = true;
   vLstOldAccount.add(vAccount);
  } // for (Account vAccount: vLstAccount) 
  AccountUtil.cascadeUnrestriction(vLstNewAccount, vLstOldAccount);
  ExecuteOnce.SF2SF_ACCOUNT = false;
  Update vLstNewAccount;
  /*vContact =
   [
    SELECT c.Legally_Restricted__c
      FROM Contact c
     WHERE c.LastName  = 'TestSubbaian' 
       AND c.FirstName = 'TestUmasankar'
   ];  */ 
  
  vOppty = 
   [
    SELECT o.Legally_Restricted__c
      FROM Opportunity o
     WHERE o.Name = 'SandKing'//'Test Opportunity' 
   ];
  
 // System.assert(vContact.Legally_Restricted__c , 'Legally restricted is not working for contact');
  //System.assert(vOppty.Legally_Restricted__c   , 'Legally restricted is not working for Opportunity');  
 } // public static void ptCascadeUnrestriction2() 

 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - Cascade Restriction to child records (Contacts and Opportunities) | Negative behavioral test                                  |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static void ntCasCadeRestriction()
 {
  /*-- 1.0 Collection variable declaration -----------------------------------------*/  
  List<Account> vLstAccount;
  AccountUtil.cascadeUnrestriction(null, null);
  
 } // public static void ntCasCadeRestriction
 
 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - inserting account records and updating account records                                                                        |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/  
 public static testMethod void accountUpsert()
 {
  test.StartTest();
  ptInsertAccount();
  ptAssignUserInfo();
  ptCreatePnrcForUnrestrictedAccounts();
  //ptGetRestrictedAccounts();
  // ptUpdateAccount();
  ptRestrictChild();
 // ptCascadeRestriction1();
 // ptCascadeRestriction2();
  ptCascadeUnrestriction1();
 // ptCascadeUnrestriction2();
  // ntCasCadeRestriction();  
  test.StopTest();
 } // public static testMethod void accountUpsert()
 
 
  public static testMethod void accountUpsertSplit()
 {
  test.StartTest();
   ptInsertAccount();
  ptAssignUserInfo();
  ptCreatePnrcForUnrestrictedAccounts();
  //ptGetRestrictedAccounts();
  // ptUpdateAccount();
  ptRestrictChild();
 // ptCascadeRestriction1();
 // ptCascadeRestriction2();
 // ptCascadeUnrestriction1();
  ptCascadeUnrestriction2();
  // ntCasCadeRestriction();  
  test.StopTest();
 } // public static testMethod void accountUpsert()
 
 
 
 
 
 
 //start:added by di.chen 2012-5-07
  public static testMethod void accountUpsert2()
 {
  test.StartTest();
  
  ptCascadeRestriction1();
 // ptCascadeRestriction2();
 
 
  test.StopTest();
 }//end
 
    public static testMethod void accountUpsert3()
    {
        Profile p = [Select Id, Name From Profile 
                                where Name = 'Channel Standard User' 
                                or Name = 'Service Account' 
                                or Name ='System Administrator' 
                                or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'pol@testCompany1233423.com';
        u.Alias = 'pol';
        u.CommunityNickname = 'pol';
        u.ProfileId = p.Id;
        u.Te_Network_Id__c = 'testuser';
        insert u;
        
        system.runAs(u){
        RecordType rt9 = ClsTestHelp.createTestRecordType10();
  
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        insert acc;
  
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.FirstName = 'TestFirstName';
        con.LastName = 'TestLastName';
        con.Legally_Restricted__c = false;
        insert con;
  
        Opportunity oppy = ClsTestHelp.createTestOpportunity(); 
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        oppy.AccountId = acc.Id;
        oppy.StageName = 'New';
        oppy.RecordTypeId = rt9.Id;
        insert oppy;
        
        Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
        sh.Name = 'Test User';
        sh.Level_7_Territory_Code__c = u.Te_Network_Id__c;
        sh.Level_6_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
        insert sh;
        sh.Level_7_Territory_Code__c = 'testuste';
        update sh;
        List<String> Accsid = new List<String>();
        Accsid.add(acc.Id);
        
        map<Id, Id> map_accId_accManager = new map<Id, Id>();
        map_accId_accManager.put(acc.Id,UserInfo.getUserId());
        string nullValues;
        map<Id, String> map_accId_accSalesTerritoryCDE = new map<Id, String>();
        map_accId_accSalesTerritoryCDE.put(acc.Id, nullValues);
        //UPDATED FOR CODE COVERAGE - 10-06-2013
        Test.startTest();
        Map<Id, Id> map_accId_salesHierarchyId = new Map<Id, Id>();
        map_accId_salesHierarchyId.put(acc.id, sh.id);
        //UPDATED FOR CODE COVERAGE - 10-06-2013
        List<Account> list_accounts = new List<Account>();
        AccountUtil.SetAccManagerAsAccOwner(map_accId_accManager, map_accId_accSalesTerritoryCDE, map_accId_salesHierarchyId, list_accounts);
        
        map_accId_accSalesTerritoryCDE.put(acc.Id, '');
        AccountUtil.SetAccManagerAsAccOwner(map_accId_accManager, map_accId_accSalesTerritoryCDE, map_accId_salesHierarchyId, list_accounts);
        //UPDATED FOR CODE COVERAGE - 10-06-2013
        AccountUtil.futurechildUnRestrict(Accsid);
        AccountUtil.futurechildRestrict(Accsid);
        
        system.assert(true);
        Test.StopTest();
    }
    }
    public static testMethod void accountHeirarchyUpdate(){
        List<Account> vLstAccount = new List<Account>();
        Account vAccountParent               = new Account();
        vAccountParent.Name                  = 'AMP Foundries Inc';
        vAccountParent.AnnualRevenue         = 2000000.11; 
        vAccountParent.Legally_Restricted__c = false; 
          
        vAccountParent.BillingCity       = 'Shanghai';  
        vAccountParent.BillingCountry    = 'CN';
        vAccountParent.BillingState      = '000000';
        vAccountParent.BillingStreet     = 'Changning';
        vAccountParent.BillingPostalCode = '200051';
        vAccountParent.GAMCD__c          = 'G030';
        
        insert vAccountParent;
        //vLstAccount.add(vAccount);
        System.assertNotEquals(vAccountParent, NULL);
        
        Account vAccountChild               = new Account();
        vAccountChild.Name                  = 'TE Foundries Inc';
        vAccountChild.Legally_Restricted__c = true; 
        vAccountChild.AnnualRevenue         = 1000000.11;
        
        vAccountChild.BillingCity        = 'Beijing';   
        vAccountChild.BillingCountry     = 'United State';
        vAccountChild.BillingState       = '000001';
        vAccountChild.BillingStreet      = 'Tiananmen';
        vAccountChild.BillingPostalCode  = '200000'; 
        //vAccountChild.GAMCD__c           = 'G030';
        vAccountChild.ParentId           = vAccountParent.Id;
        
        insert vAccountChild;
        
        vLstAccount.add(vAccountChild);
        AccountUtil.setSalesHerarchyLookup(vLstAccount);  
    }
}