/************************************************************************************************************************************************************************************************************************
Class Name: CaseAssignMeButtonClass_Test
Test Class Coverage: 
Copyright © 2018 TE Connectivity | Salesforce Instance : C2S Org
===========================================================================================================================================================================================================
Purpose: This test class for CaseAssignMeButtonClass which is intended for the functionality of updating the caseOwnerId will be refered from Lightining component 
===========================================================================================================================================================================================================
VERSION       AUTHOR                      DATE                                   
 1.0          Vinod Kumar               22/01/2018  
*/

@isTest
public class CaseAssignMeButtonClass_Test {
 	@isTest
    public static void caseAssignmeMethod(){
        /*Account acc = new Account();
        acc.name = 'test Account';
       // insert acc;
        contact con = new contact();
        con.AccountId=acc.id;
        insert con;*/
        Case cs = new Case();
        cs.CurrencyIsoCode='Euro';
        cs.Status='In Progress';
        cs.Origin='Email';
        //cs.AccountId=acc.id;
        //cs.ContactId=con.id;
        //insert cs;
        //CaseAssignMeButtonClass.checkOwner(cs.id,true);
        //CaseAssignMeButtonClass.changeOwnerMethod(cs.id);
        
    }
     
 
 public static testmethod void TestMethod1(){           
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
         //Start: Rajendra Shahane Modified for case - 900703
        ClsTestCustomSettingHelper.getCCPTriggerSettings();
        //End: Rajendra Shahane Modified for case - 900703
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getCaseFinalVariables();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        //ClsTestCustomSettingHelper.getADMTerritoryCode();
         
        /*List<CaseFinalVariablesforCC__c> lstCaseCCFV = new List<CaseFinalVariablesforCC__c>();
        lstCaseCCFV.add(new CaseFinalVariablesforCC__c (name='Default', Customer_Care_Cloud_Record_Type_String__c ='Customer_Care_Cloud') ) ;
        insert lstCaseCCFV; */
        //Id vCaseCCRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Care Cloud').getRecordTypeId();
         
        ClsTestCustomSettingHelper.getWebToCaseStrings();
        Id vCaseRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('TE PIC Standard Case Record Type').getRecordTypeId();//[SELECT Id FROM RecordType WHERE DeveloperName = 'TE_PIC_Standard_Case_Record_Type'].Id;
        List<Case> vCsLst = new List<Case>();
        List<Case> vCsLstUpdate = new List<Case>();
        Map<Id,Case> vCsMap = new Map<Id,Case>();        
        User u = new User();
        u.FirstName ='Fpic';
        u.LastName = 'Tester';
        u.Alias = 'mfptst';
        u.Email = 'mfptester@zencoTestcompany.com';
        u.Username ='Fpic' + u.Email;
        u.CommunityNickname = u.Alias;
        u.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.Primary_Business_Hours__c = 'PIC - US';
        insert u;
       
        Account vAccount;
        vAccount = new Account();
        //================================ code Added for Add Business Unit value with Account
        vAccount.Industry_Code_Description__c = 'Industrial';
         vAccount.Business_Unit_Level_2__c = 'Rail';
        //================================
        vAccount.Name = 'Test Pic acc2';
        vAccount.Legally_Restricted__c = true; 
        vAccount.BillingCity = 'Beijing';  
        vAccount.BillingCountry = 'Ch';
        vAccount.BillingState = '000001';
        vAccount.BillingStreet = 'Tiananmen';
        vAccount.BillingPostalCode = '200000';
        vAccount.ownerId = u.Id;
        insert vAccount;
        
        contact con = new Contact();
        con.email='testpiic@org.com';
        con.lastName='TestCon';
        con.accountid=vAccount.id;
        insert con;
        
        Case vCs = new Case();
        vCs.subject ='testing';
        vCs.Origin = 'PIC US Email';    
        vCs.Status= 'New';
        vCs.Description = 'Test Description';
        vCs.AccountId = vAccount.id;
        vCs.contactId=con.id;
        vCs.ownerId = u.id;   
        vCs.CurrencyIsoCode='EUR';
        vCs.RecordTypeid = VCaseRT;         
        vCsLst.add(vCs);               
        insert vCsLst;
		 CaseAssignMeButtonClass.checkOwner(vCs.id,true);
        CaseAssignMeButtonClass.changeOwnerMethod(vCs.id);
     
     
     
      Profile testProfile = [SELECT Id 
                           FROM profile
                           WHERE Name = 'Standard User' 
                           LIMIT 1];

    User testUser = new User(LastName = 'test user 1', 
                             Username = 'test.user.1@example.com', 
                             Email = 'test.1@example.com', 
                             Alias = 'testu1', 
                             TimeZoneSidKey = 'GMT', 
                             LocaleSidKey = 'en_GB', 
                             EmailEncodingKey = 'ISO-8859-1', 
                             ProfileId = testProfile.Id, 
                             LanguageLocaleKey = 'en_US');
     
     System.runAs(u) {
              CaseAssignMeButtonClass.changeOwnerMethod(vCs.id);
        }
		}
}