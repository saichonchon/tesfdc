/**********************************************************************************************************************************************
*******
Name: BIU_CCP_AssignEntitlementTest
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This test class covers test coverage for BIU_CCP_AssignEntitlementTest trigger class.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE       DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepatil  10/16/2013    Test Class                       
***********************************************************************************************************************************************
*****/

/* changed the accounts name manually to control duplication
    2014-09-18 Harinath Chittala <harinath.chittala@te.com> */  


@isTest(seeAllData=false)
public class BIU_CCP_AssignEntitlementTest{
    static testmethod void BIU_CCP_AssignEntitlementTestMethod(){
        test.startTest();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        Apex_Helper_Settings__c vCaseRT = Apex_Helper_Settings__c.getInstance('Customer Care Cloud');
        Account vAccount;
        List<Case> vCsLst = new List<Case>();
        vAccount                       = ClsTestHelp.createTestAccounts();
        vAccount.Name                  = 'TE Aluminium Foundries Inc';
        vAccount.Legally_Restricted__c = true; 
        vAccount.AnnualRevenue         = 1000000.11; 
        vAccount.BillingCity       = 'Beijing';  
        vAccount.BillingCountry     = 'China';
        vAccount.BillingState          = '000001';
        vAccount.BillingStreet       = 'Tiananmen';
        vAccount.BillingPostalCode   = '200000';

        Account vAccount1                       = ClsTestHelp.createTestAccounts();
        vAccount1.Name                  = 'TE test';
        vAccount1.Legally_Restricted__c = true; 
        vAccount1.AnnualRevenue         = 1000000.11; 
        vAccount1.BillingCity       = 'Beijing';  
        vAccount1.BillingCountry     = 'China';
        vAccount1.BillingState          = '000001';
        vAccount1.BillingStreet       = 'Tiananmen';
        vAccount1.BillingPostalCode   = '200000';
        insert new list<Account>{vAccount, vAccount1};
        contact con = ClsTestHelp.createTestContacts();
        con.email='test@org.com';
        con.accountid=vAccount.id;
        //insert con;
        contact con2 = ClsTestHelp.createTestContacts();
        con2.email='test1@org.com';
        con2.accountid=vAccount1.id;
        insert new list<contact>{con, con2};
        Entitlement vEn = new Entitlement();
        vEn.name = 'Test Entitlement';
        vEn.accountid = vAccount.id;
        vEn.Startdate = System.today();
        //insert vEn;
        
        Entitlement vEn1 = new Entitlement();
        vEn1.name = 'Test Entitlement';
        vEn1.accountid = vAccount1.id;
        vEn1.Startdate = System.today();
        insert new list<Entitlement>{vEN, vEn1};
        Case vCs = new Case();
        vCs.Origin = 'Email-cip1';
        vCs.Inquiry_Type__c = 'Cancellation';
        vCs.Status= 'In Progress';
        vCs.Description = 'Test Description';
        vCs.AccountId = vAccount.id;
        vCs.contactId=con.id;
        vCs.RecordTypeid = VCaseRT.Value__c;
        vCs.subject ='testing';
         TE_Employee__c intcon=new TE_Employee__c();
        intcon.Email__c='test@t.com';
        insert intcon;
        CaseUtil_CCP.AssignEntlmnboolean = false;
        Case Cs = new Case();
        Cs.Origin = 'Email-cip1';
        Cs.Inquiry_Type__c = 'Cancellation';
        Cs.Status= 'In Progress';
        Cs.Description = 'Test Description';
        //cs.Internal_Contact__c=intcon.Id;
        Cs.RecordTypeid = VCaseRT.Value__c;
        Cs.subject ='testing0';
        //insert Cs;
        Case Cs1 = new Case();
        Cs1.Origin = 'Email-cip1';
        Cs1.Inquiry_Type__c = 'Cancellation';
        Cs1.Status= 'In Progress';
        Cs1.Description = 'Test Description';
        Cs1.RecordTypeid = VCaseRT.Value__c;
        Cs1.subject ='testing1';
        //insert Cs1;
        insert new list<case>{Cs, Cs1, vCs};
        
        CaseUtil_CCP.AssignEntlmnboolean_update =false;
        vCs.AccountId = vAccount1.id;
        //update vCs;
        System.assert(vCs.Entitlementid == null,'Case not updated');
        //intrnal contact case
       
        
        cs1.contactId=con.id;
        update new list<case>{vCs, cs1};
        test.stopTest(); 
        
  }
}