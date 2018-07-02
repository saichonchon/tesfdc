/**********************************************************************************************************************************************
*******
Name: CCP_AddContoEntitlementTest
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This test class covers test coverage for CCP_AddContoEntitlement trigger .
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE       DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepatil  11/15/2013    Test Class     
 1.1   Rajendra Shahane		11/28/2016   Modified to improve code coverage
 1.2   Mahesh Babu		    12/07/2016   Modified to improve code coverage
***********************************************************************************************************************************************
*****/

/* changed the accounts name manually to control duplication
    2014-09-18 Harinath Chittala <harinath.chittala@te.com> */  

@isTest(seeAllData=false)
public class CCP_AddContoEntitlementTest{
    static testmethod void CCP_AddContoEntitlementTestMethod(){
        ClsTestCustomSettingHelper.getAllSettings();
        test.startTest();
        Account vAccount;
        Account vAccount1;
        // Start : Updated by Mahesh Babu for Case 900944 - Modified to improve code coverage
        Account vAccount2;
        Account vAccount3;
        Account vAccount4;
        // End : Updated by Mahesh Babu for Case 900944 - Modified to improve code coverage
        List<Case> vCsLst = new List<Case>();
        vAccount                       = ClsTestHelp.createTestAccounts();
        //vAccount.Name                  = 'TE Aluminium Foundries Inc';
        vAccount.Legally_Restricted__c = true; 
        vAccount.AnnualRevenue         = 1000000.11; 
        vAccount.BillingCity       = 'Beijing';  
        vAccount.BillingCountry     = 'China';
        vAccount.BillingState          = '000001';
        vAccount.BillingStreet       = 'Tiananmen';
        vAccount.BillingPostalCode   = '200000';
        vAccount.Account_Has_Entitlement__c = true;
        //insert vAccount;
        vAccount1                       = ClsTestHelp.createTestAccounts();
        //vAccount1.Name                  = 'TE Aluminium Foundries';
        vAccount1.Legally_Restricted__c = true; 
        vAccount1.AnnualRevenue         = 1000000.11; 
        vAccount1.BillingCity       = 'Beijing';  
        vAccount1.BillingCountry     = 'China';
        vAccount1.BillingState          = '000001';
        vAccount1.BillingStreet       = 'Tiananmen';
        vAccount1.BillingPostalCode   = '200000';
        vAccount1.Account_Has_Entitlement__c = true;
		// Start : Updated by Mahesh Babu for Case 900944 - Modified to improve code coverage
        vAccount2                       = ClsTestHelp.createTestAccounts();
        //vAccount2.Name                  = 'TE Aluminium Foundries';
        vAccount2.Legally_Restricted__c = true; 
        vAccount2.AnnualRevenue         = 1000000.11; 
        vAccount2.BillingCity       = 'Beijing';  
        vAccount2.BillingCountry     = 'China';
        vAccount2.BillingState          = '000001';
        vAccount2.BillingStreet       = 'Tiananmen';
        vAccount2.BillingPostalCode   = '200000';
        vAccount2.Account_Has_Entitlement__c = true;
        vAccount3                       = ClsTestHelp.createTestAccounts();
        //vAccount3.Name                  = 'TE Aluminium Foundries';
        vAccount3.Legally_Restricted__c = true; 
        vAccount3.AnnualRevenue         = 1000000.11; 
        vAccount3.BillingCity       = 'Beijing';  
        vAccount3.BillingCountry     = 'China';
        vAccount3.BillingState          = '000001';
        vAccount3.BillingStreet       = 'Tiananmen';
        vAccount3.BillingPostalCode   = '200000';
        vAccount3.Account_Has_Entitlement__c = true;
        vAccount4                       = ClsTestHelp.createTestAccounts();
        //vAccount4.Name                  = 'TE Aluminium Foundries';
        vAccount4.Legally_Restricted__c = true; 
        vAccount4.AnnualRevenue         = 1000000.11; 
        vAccount4.BillingCity       = 'Beijing';  
        vAccount4.BillingCountry     = 'China';
        vAccount4.BillingState          = '000001';
        vAccount4.BillingStreet       = 'Tiananmen';
        vAccount4.BillingPostalCode   = '200000';
        vAccount4.Account_Has_Entitlement__c = true;

        insert new list<account>{ vAccount, vAccount1, vAccount2, vAccount3, vAccount4};
		// End : Updated by Mahesh Babu for Case 900944 - Modified to improve code coverage 
        Entitlement vEn = new Entitlement();
        vEn.name = 'Test Entitlement';
        vEn.accountid = vAccount.id;
        vEn.Startdate = System.today();
        //insert vEn;
        Entitlement vEn1 = new Entitlement();
        vEn1.name = 'Test Entitlement';
        vEn1.accountid = vAccount.id;
        vEn1.Startdate = System.today();
        insert new list<Entitlement>{vEn, vEn1};
        contact con = ClsTestHelp.createTestContacts();
        con.email='test@org.com';
        con.accountid=vAccount.id;
        //insert con;
        contact con2 = ClsTestHelp.createTestContacts();
        con2.email='test1@org.com';
        con2.accountid=vAccount1.id;
        // Start : Updated by Mahesh Babu for Case 900944 - Modified to improve code coverage
		contact con3 = ClsTestHelp.createTestContacts();
        con3.email='test2@org.com';
        con3.accountid=vAccount2.id;
		contact con4 = ClsTestHelp.createTestContacts();
        con4.email='test3@org.com';
        con4.accountid=vAccount3.id;
		contact con5 = ClsTestHelp.createTestContacts();
        con5.email='test4@org.com';
        con5.accountid=vAccount4.id;

        insert new list<contact>{con, con2, con3, con4, con5};
        // End : Updated by Mahesh Babu for Case 900944 - Modified to improve code coverage
        
        
        Case vCs = new Case();
        vCs.Origin = 'Email-cip1';
        vCs.Inquiry_Type__c = 'Cancellation';
        vCs.Status= 'In Progress';
        vCs.Description = 'Test Description';
        vCs.AccountId = vAccount.id;
        vCs.contactId=con.id;
        insert vCs;
        CaseUtil_CCP.AddEntlContact = false;
        con.accountid = vaccount1.id;
        update con;
        con.Inactive__c = true;
        con2.ReportsToId = con.Id;
		// Start : Updated by Mahesh Babu for Case 900944 - Modified to improve code coverage
        con4.ReportsToId = con3.Id;
		con5.ReportsToId = con4.Id;
		update new List<Contact> {con, con2, con4, con5};
		con4.Inactive__c = true;
        update con4;
		// End : Updated by Mahesh Babu for Case 900944 - Modified to improve code coverage
            
        test.stoptest();
        }
        }