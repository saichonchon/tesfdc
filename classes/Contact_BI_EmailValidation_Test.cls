/**********************************************************************************************************************************************
Name: Contact_BI_EmailValidation_Test
Copyright © 2014 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This test class covers test coverage for Contact_BI_EmailValidation trigger .
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE       DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Ramakrishna Singara  04/14/2014    Test Class                       
***********************************************************************************************************************************************
*****/
/* changed the accounts and contacts name manually to control duplication
    2014-09-18 Harinath Chittala <harinath.chittala@te.com> */
    
@isTest(SeeAllData=true)
private class Contact_BI_EmailValidation_Test{
     public static testMethod void MytestTrigger() {
         Test.startTest();
             Profile p = [SELECT Id FROM Profile WHERE Name='Customer Care Service Cloud'];             
             Profile p1 = [SELECT Id FROM Profile WHERE Name='System Administrator'];             
             User u =new User( Alias = 'Rama1' ,
                            Email ='Rama1@testorg.com',
                            EmailEncodingKey = 'UTF-8',
                            LastName = 'Rama1',
                            LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', // changed for to avoid: INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST, Locale: bad value for restricted picklist field: America/Los_Angeles
                            UserName='Rama1@testorg.com',
                            ProfileId=p.id,
                            TimeZoneSidKey    = 'America/Los_Angeles');
             insert u;             
             System.runAs(u) { 
                Account vAccount = new Account();           
                vAccount                       = ClsTestHelp.createTestAccounts();
                //vAccount.Name                  = 'TE Aluminium Foundries Inc';
                vAccount.Legally_Restricted__c = true; 
                vAccount.AnnualRevenue         = 1000000.11; 
                vAccount.BillingCity       = 'Beijing';  
                vAccount.BillingCountry     = 'China';
                vAccount.BillingState          = '000001';
                vAccount.BillingStreet       = 'Tiananmen';
                vAccount.BillingPostalCode   = '200000';            
                insert vAccount;
                contact con = ClsTestHelp.createTestContacts();  
                con.Phone = '+49 6912345566';              
                //con.email='test@org.com';
                con.accountid=vAccount.id;
                insert con;
                contact con1 = ClsTestHelp.createTestContacts();  
                con1.Phone = '+49 6912345566';              
                //con1.email='test@org.com';
                con1.accountid=vAccount.id;
                insert con1;                
            }
         Test.stopTest();
     }
 }