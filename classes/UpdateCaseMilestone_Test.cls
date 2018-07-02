/**********************************************************************************************************************************************
*******
Name: UpdateCaseMilestone_Test
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This test class covers test coverage for UpdateCaseMilestone class.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE       DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0    Narasimha Narra     13/11/2013    Test Class                       
***********************************************************************************************************************************************
*****/
@isTest(seeAllData=true)
public class UpdateCaseMilestone_Test{
    static testmethod void UpdateCaseMilestone_TestMethod(){
        test.startTest();
        Apex_Helper_Settings__c vCaseRT = Apex_Helper_Settings__c.getInstance('Customer Care Cloud');
        Apex_Helper_Settings__c mlstnType_4hrresponse = Apex_Helper_Settings__c.getInstance('4 Hour Response Time');
        List<SLAProcess> vSLALst = new List<SLAProcess>();
        vSLALst = [Select id,name,isActive from SLAProcess where isActive =: true and name=:'Gold Customers V 6.0'];
        
        Account vAccount;
         vAccount                      = ClsTestHelp.createTestAccounts();
        vAccount.Name                  = 'TE Aluminium Foundries Inc';
        vAccount.Legally_Restricted__c = true; 
        vAccount.AnnualRevenue         = 1000000.11; 
        vAccount.BillingCity       = 'Beijing';  
        vAccount.BillingCountry     = 'China';
        vAccount.BillingState          = '000001';
        vAccount.BillingStreet       = 'Tiananmen';
        vAccount.BillingPostalCode   = '200000';
        insert vAccount;
        
        Contact contact1  = ClsTestHelp.createTestContacts();
        contact1.AccountId = vAccount.Id;  
        contact1.email = 'testcon@test.com';
        insert contact1;
              
        Entitlement vEn = new Entitlement();
        vEn.name = 'Test Entitlement';
        vEn.accountid = vAccount.id;
        vEn.Startdate = System.today();
        vEn.SlaProcessId = vSLALst[0].id;
        insert vEn;
        
        Case vCs = new Case();
        vCs.Origin = 'Email';
        vCs.Inquiry_Type__c = 'Cancellation';
        vCs.Status= 'In Progress';
        vCs.Description = 'Test Description';
        vCs.recordtypeid = vCaseRT.Value__c;
        vCs.AccountId = vAccount.id;
        vCs.ContactId = contact1.id;
        vCs.EntitlementId = vEn.id;       
        vCs.Priority='Medium';
        insert vCs;        
        vCs.status='Closed';
        update vCs; 
        Test.stopTest();
     }
        
     static testmethod void UpdateCaseMilestone_TestMethod1(){
        test.startTest();
        Apex_Helper_Settings__c vCaseRT = Apex_Helper_Settings__c.getInstance('Customer Care Cloud');
        Apex_Helper_Settings__c mlstnType_4hrresponse = Apex_Helper_Settings__c.getInstance('4 Hour Response Time');
        List<SLAProcess> vSLALst = new List<SLAProcess>();
        vSLALst = [Select id,name,isActive from SLAProcess where isActive =: true and name=:'Gold Customers V 6.0'];              
        Account vAccount1;
         vAccount1                       = ClsTestHelp.createTestAccounts();
        vAccount1.Name                  = 'TE Aluminium Foundries Inc Ltd';
        vAccount1.Legally_Restricted__c = true; 
        vAccount1.AnnualRevenue         = 1000000.11; 
        vAccount1.BillingCity       = 'Beijing';  
        vAccount1.BillingCountry     = 'China';
        vAccount1.BillingState          = '000001';
        vAccount1.BillingStreet       = 'Tiananmen';
        vAccount1.BillingPostalCode   = '200000';
        insert vAccount1;
        
        Contact contact2  = ClsTestHelp.createTestContacts();
        contact2.AccountId = vAccount1.Id;  
        contact2.email = 'testcont@test.com';
        insert contact2;
        
        Entitlement vEn1 = new Entitlement();
        vEn1.name = 'Test1 Entitlement';
        vEn1.accountid = vAccount1.id;
        vEn1.Startdate = System.today();
        vEn1.SlaProcessId = vSLALst[0].id;
        insert vEn1;
        
        Case vCs1 = new Case();
        vCs1.Origin = 'Email';
        vCs1.Inquiry_Type__c = 'Cancellation';
        vCs1.Status= 'In Progress';
        vCs1.Description = 'Test1 Description';
        vCs1.recordtypeid = vCaseRT.Value__c;
        vCs1.AccountId = vAccount1.id;
        vCs1.ContactId = contact2.id;
        vCs1.EntitlementId = vEn1.id;       
        vCs1.Priority='High';
        insert vCs1;        
        vCs1.status='Closed';
        update vCs1;          
        Test.stopTest();
    }
}