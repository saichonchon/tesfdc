/**************************************************************************************************************************************************
Name:  OpptyUtilTest
Copyright � 2011 TE Connectivity
===================================================================================================================================================
Purpose: This class contain Test Methods for Opportunity Insert, Opportunity Update and Opportunity Utility class 
---------------------------------------------------------------------------------------------------------------------------------------------------       
Related APEX Class : OpportunityUtil                                                              
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer          Date       Detail                                  Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Umasankar Subbaian 11/01/2011 Initial Development                      1453487                                   
**************************************************************************************************************************************************/
@isTest(seealldata = true)
public class OpptyUtilTest
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
  vAccount.BillingCity           = 'Shanghai';  
  vAccount.BillingCountry        = 'China';
  vAccount.BillingState          = '000000';
  vAccount.BillingStreet         = 'Changning';
  vAccount.BillingPostalCode     = '200051';
  vLstAccount.add(vAccount);
  
  vAccount                       = ClsTestHelp.createTestAccounts();
  vAccount.Name                  = 'TE Foundries Inc';
  vAccount.Legally_Restricted__c = true; 
  vAccount.AnnualRevenue         = 1000000.11; 
  vAccount.BillingCity           = 'Shanghai';  
  vAccount.BillingCountry        = 'China';
  vAccount.BillingState          = '000000';
  vAccount.BillingStreet         = 'Changning';
  vAccount.BillingPostalCode     = '200051';
  vLstAccount.add(vAccount);  
  Insert vLstAccount; 
  System.assert(vLstAccount.size() > 0,'There should be 2 accounts created in the volatile memory');    
  // Don't know to cover Exception Handling part of AccountAI trigger
  
 } // public static void ptInsertAccount
 
 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - Inserting Opportunity at the Child Org(BU Org)                                                                                |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
  public static void ptInsertOppty()
 {
  /*-- 1.0 Collection variable declaration -----------------------------------------*/  
  List<Account> vLstAcctLegallyUnrestricted;
  List<Account> vLstAcctLegallyRestricted;
  List<Opportunity> vLstOpportunity;
  List<sObject> vLstSo;
  /*-- 1.1 Object variable declaration ---------------------------------------------*/  
  Account vAccount;
  Opportunity vOpportunity;
  
  // 1. Create 2 account in Child Org(BU Org)
  vLstSo = new List<sObject>() ;
  ExecuteOnce.SF2SF_OPPORTUNITY = false;
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
   //start added by di.chen
  Profile p = [Select Id, Name From Profile 
                                where Name = 'Channel Standard User' 
                                or Name = 'Service Account' 
                                or Name ='System Administrator' 
                                or Name ='Systemadministrator' limit 1];
  User u = ClsTestHelp.createTestUsers();
  u.Email = 'qscfd@helool.com';
  u.Alias = 'rfg';
  u.CommunityNickname = 'jkl';
  u.FirstName = 'lmk';
  u.ProfileId = p.Id;
  insert u;
        
  system.runAs(u){
    
  /*vOpportunity                       = new Opportunity();
  vOpportunity.AccountId             = vLstAcctLegallyUnrestricted[0].Id;
  vOpportunity.Name                  = 'TestUmasankar';
  vOpportunity.Legally_Restricted__c = false;
  vOpportunity.StageName             = 'Lead';
  vOpportunity.CloseDate             = Date.Today();   
  vLstOpportunity                    = new List<Opportunity>();
  vLstOpportunity.add(vOpportunity);

  vOpportunity                       = new Opportunity();
  vOpportunity.AccountId             = vLstAcctLegallyUnrestricted[0].Id;
  vOpportunity.Name                  = 'TestRahul';
  vOpportunity.Legally_Restricted__c = true;
  vOpportunity.StageName             = 'Lead';
  vOpportunity.CloseDate             = Date.Today();   
  vLstOpportunity.add(vOpportunity);*/
    
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
  
 /* vOpportunity                       = new Opportunity();
  vOpportunity.AccountId             = vLstAcctLegallyRestricted[0].Id;
  vOpportunity.Name                  = 'TestRajeev';
  vOpportunity.Legally_Restricted__c = false;
  vOpportunity.StageName             = 'Lead';
  vOpportunity.CloseDate             = Date.Today();
  vLstOpportunity.add(vOpportunity);

  vOpportunity                       = new Opportunity();
  vOpportunity.AccountId             = vLstAcctLegallyRestricted[0].Id;
  vOpportunity.Name                  = 'TestJosh';
  vOpportunity.Legally_Restricted__c = true;
  vOpportunity.StageName             = 'Lead';
  vOpportunity.CloseDate             = Date.Today();  */
  

  
  RecordType rt = ClsTestHelp.createTestRecordType10();
  
  Account acc = ClsTestHelp.createTestAccounts();
  acc.Type = 'CM';
  insert acc;

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
  oppy.RecordTypeId = rt.Id;
  //insert vOpportunity;
  vLstOpportunity                    = new List<Opportunity>();
  vLstOpportunity.add(oppy);  
  
  Insert vLstOpportunity;
  
  Opportunity oppy2 = ClsTestHelp.createTestOpportunity(); 
  oppy2.Type = 'CM';
  oppy2.Request_Type__c = 'Extension';
  oppy2.Method__c = 'BOM';
  oppy2.Level__c = 'Yearly';
  oppy2.Amount = 1;
  oppy2.CurrencyIsoCode = 'EUR';
  oppy2.Five_Year_Revenue__c = 1;
  oppy2.AccountId = acc.Id;
  oppy2.StageName = 'New';
  oppy2.RecordTypeId = rt.Id;
  insert oppy2;
  
  Set<Id> pLstOppty = new Set<Id>();
  pLstOppty.add(oppy2.Id);
  
  List<Opportunity> pLstOpptys = new List<Opportunity>();
  pLstOpptys.add(oppy2);
  
  OpptyUtil.inPNRC(pLstOppty, vLstOpportunity, true);
  OpptyUtil.IsParentRestricted(pLstOpptys);
  OpptyUtil.inPNRC(pLstOppty, pLstOpptys);
  //System.assert(vLstOpportunity.size() > 0,'There should be 2 Opportunitys for 2 accounts created in the volatile memory');  
  }
 } // public static void ptInsertOppty

 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - Updating Opportunity records at the Child Org(BU Org)                                                                         |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static void ptUpdateOppty()
 {
  /*-- 1.0 Collection variable declaration -----------------------------------------*/  
  List<Opportunity> vLstOpportunity;
  List<PartnerNetworkRecordConnection> vLstPnrc;
  /*-- 1.1 Primitive variable declaration ------------------------------------------*/
  PartnerNetworkRecordConnection vPnrc;
  /*-- 1.2 Primitive variable declaration ------------------------------------------*/
  string vStrOpptyID;
  
  ExecuteOnce.SF2SF_OPPORTUNITY = false;
  
  vLstPnrc = 
   [
    SELECT p.LocalRecordId, 
           p.Status
      FROM PartnerNetworkRecordConnection p  
     WHERE p.Status = 'Sent'  limit 1    
   ]; 
   
  //System.assert(vLstPnrc.size() > 0, 'Please create at least 1 record in PNRC{UI - create opportunity}'); 
  
  for (PartnerNetworkRecordConnection vPnrc1 : vLstPnrc)
  {
   if (String.ValueOf(vPnrc1.LocalRecordId).substring(0,3) == '006')
   {
    vStrOpptyID = vPnrc1.LocalRecordId;
    break;
   } // if (String.ValueOf().substring(0,3) == '006')
  } // for (PartnerNetworkRecordConnection vPnrc1 : vLstPnrc)  
  
  // System.assert(vStrOpptyID != null, 'Please create at least 1 opportunity record manually'); 
  
  vLstOpportunity = 
   [
    SELECT o.AccountId            ,                         
           o.BU_Owner_Email__c    ,
           o.BU_Owner_Name__c     , 
           o.BU_Owner_Phone__c    ,  
           o.Id                   ,
           o.Legally_Restricted__c,
           o.Name                 ,
           o.OwnerId
      FROM Opportunity o
     WHERE o.Id = :vStrOpptyID    
   ];
   for (Opportunity vOpportunity : vLstOpportunity)
   {
    vOpportunity.Name += '1';   
   } // for (Opportunity vOpportunity : vLstOpportunity)
   Update vLstOpportunity;
   for (Opportunity vOpportunity : vLstOpportunity)
   {
    System.Debug(vOpportunity.Name);
    vStrOpptyID = vOpportunity.Id;
    //System.Debug('18 character Opportunity Id : ' + vStrOpptyID);
   } // for (Opportunity vOpportunity : vLstOpportunity)
   
    
    //System.Debug('Total records in PNRC : ' + vLstPnrc.size());
    // System.Debug('PartnerNetworkRecordConnection.Status : ' + vPnrc.Status);
 } // public static void ptUpdateOppty()
 public static void ptInsertOppty1()
 {
      List<Account> vLstAcctLegallyUnrestricted;
      List<Account> vLstAcctLegallyRestricted;
      List<Opportunity> vLstOpportunity;
      List<sObject> vLstSo; 
      Account vAccount;
      Opportunity vOpportunity;
    
      vLstSo = new List<sObject>() ;
      ExecuteOnce.SF2SF_OPPORTUNITY = false;
      vLstAcctLegallyUnrestricted = [SELECT a.AnnualRevenue, a.BU_Owner_Email__c, a.BU_Owner_Name__c, a.BU_Owner_Phone__c, a.Id,a.Legally_Restricted__c,a.Name, a.OwnerID FROM Account a
             WHERE a.Name = 'AMP Foundries Inc'
           ];
      Profile p = [Select Id, Name From Profile 
                       where Name = 'Channel Standard User' 
                       or Name = 'Service Account' 
                       or Name ='System Administrator' 
                       or Name ='Systemadministrator' limit 1];
      User u = ClsTestHelp.createTestUsers();
      u.Email = 'qscfd@helool.com';
      u.Alias = 'rfg';
      u.CommunityNickname = 'jkl123';
      u.FirstName = 'lmk';
      u.ProfileId = p.Id;
      insert u;
      
      system.runAs(u){

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
          
          RecordType rt = ClsTestHelp.createTestRecordType30();
          
          Account acc = ClsTestHelp.createTestAccounts();
          acc.Type = 'CM';
          insert acc;

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
          oppy.RecordTypeId = rt.Id;
          vLstOpportunity                    = new List<Opportunity>();
          vLstOpportunity.add(oppy);  
          
          Insert vLstOpportunity;
          
          Opportunity oppy2 = ClsTestHelp.createTestOpportunity(); 
          oppy2.Type = 'CM';
          oppy2.Request_Type__c = 'Extension';
          oppy2.Method__c = 'BOM';
          oppy2.Level__c = 'Yearly';
          oppy2.Amount = 1;
          oppy2.CurrencyIsoCode = 'EUR';
          oppy2.Five_Year_Revenue__c = 1;
          oppy2.AccountId = acc.Id;
          oppy2.StageName = 'New';
          oppy2.RecordTypeId = rt.Id;
          insert oppy2;
          
          Set<Id> pLstOppty = new Set<Id>();
          pLstOppty.add(oppy2.Id);
          
          List<Opportunity> pLstOpptys = new List<Opportunity>();
          pLstOpptys.add(oppy2);
          
          OpptyUtil.inPNRC(pLstOppty, vLstOpportunity, true);
          OpptyUtil.IsParentRestricted(pLstOpptys);
          OpptyUtil.inPNRC(pLstOppty, pLstOpptys);
      
      }
  }
 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - inserting Opportunity records and updating Opportunity records                                                                |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/  
 public static testMethod void OpptyUpsert()
 {
  test.StartTest();
  ptInsertAccount();
  ptInsertOppty();
  
  test.StopTest();
 } // public static testMethod void OpptyUpsert()
 
 public static testMethod void OpptyUpsert1()
 {
  test.StartTest();
  ptInsertOppty1();
  ptUpdateOppty();
  test.StopTest();
 } 
/*-----------------------------------------------------------------------------------------------------------------------------------------------*/  

} // public class OpptyUtilTest