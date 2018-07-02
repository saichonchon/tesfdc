/**********************************************************************************************************************************************
*******
Name: AI_UpdateCaseMilestone_CCPTest
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This test class covers test coverage for BI_UpdateCaseMilestone_CCP trigger.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE       DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepatil  10/22/2013    Test Class                       
***********************************************************************************************************************************************
*****/
@isTest(seeAllData=true)
public class AI_UpdateCaseMilestone_CCPTest{
    static testmethod void BI_UpdateCaseMilestone_CCPTestMethod(){
        test.startTest();
        Apex_Helper_Settings__c vCaseRT = Apex_Helper_Settings__c.getInstance('Customer Care Cloud');
        List<SLAProcess> vSLALst = new List<SLAProcess>();
        vSLALst = [Select id,name,isActive from SLAProcess where isActive =: true];
        Profile p = [Select Id, Name From Profile 
                     where Name = 'Channel Standard User' 
                        or Name = 'Service Account' 
                        or Name ='System Administrator' 
                        or Name ='Systemadministrator' limit 1];
/*------------------ User created for Test ------------------------------*/                        
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'test@test.com';
        u.username = 'dmmrouting@test.com';
        u.Alias = 'abc';
        u.CommunityNickname = 'TsMD';
        u.ProfileId = p.Id;
        insert u;
        
        Account vAccount;
         vAccount                       = ClsTestHelp.createTestAccounts();
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
        contact1.email = 'test@zensar.in';
        contact1.Contact_Has_Entitlement__c = true;
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
        vCs.recordtypeid = vCaseRT.Value__c;
        vCs.ownerId = u.id;
        insert vCs;
        
        EmailMessage vEMS          = new EmailMessage();
        vEMS.parentid              = vCs.id;
        vEMS.FromAddress           = u.email;
        vEMS.FromName              = 'Test Zensar';
        vEMS.incoming              = true;
        vEMS.messagedate           = System.today()+1; 
        vEMS.subject               = 'Test';
        vEMS.textbody              = 'Test';
        vEMS.toaddress             = 'test@zensar.in';
        insert vEMS;
        CaseUtil_CCP.EmailMsgboolean = false;
        CaseUtil_CCP.Countoncaseboolean = false;
        EmailMessage vEMS1          = new EmailMessage();
        vEMS1.parentid              = vCs.id;
        vEMS1.FromAddress           = u.email;
        vEMS1.FromName              = 'Test Zensar';
        vEMS1.incoming              = false;
        vEMS1.messagedate           = System.today()+1; 
        vEMS1.subject               = 'Test';
        vEMS1.textbody              = 'Test';
        vEMS1.toaddress             = 'testcon@test.com';
        insert vEMS1;
        vCs.Count_Incoming_Emails__c = 1;
        update vCs;
        CaseUtil_CCP.EmailMsgboolean = false;
                CaseUtil_CCP.Countoncaseboolean = false;
        EmailMessage vEMS2          = new EmailMessage();
        vEMS2.parentid              = vCs.id;
        vEMS2.FromAddress           = 'test@zensar.in';
        vEMS2.FromName              = 'Test Zensar';
        vEMS2.incoming              = true;
        vEMS2.messagedate           = System.today()+1; 
        vEMS2.subject               = 'Test';
        vEMS2.textbody              = 'Test';
        vEMS2.toaddress             = 'test@zensar.in';
        insert vEMS2;
        CaseUtil_CCP.EmailMsgboolean = false;
           CaseUtil_CCP.Countoncaseboolean = false;     
        EmailMessage vEMS3          = new EmailMessage();
        vEMS3.parentid              = vCs.id;
        vEMS3.FromAddress           = u.email;
        vEMS3.FromName              = 'Test Zensar';
        vEMS3.incoming              = false;
        vEMS3.messagedate           = System.today()+1; 
        vEMS3.subject               = 'Test';
        vEMS3.textbody              = 'Test';
        vEMS3.toaddress             = 'testcon@test.com';
        insert vEMS3;
        test.StopTest();
        }
}