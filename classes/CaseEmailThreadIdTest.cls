/***********************************************************************************************************************
 Name: CaseEmailThreadIdTest
 Org : C2S
 Copyright : © 2015 TE Connectivity 
========================================================================================================================
 Summary : test class
 -----------------------------------------------------------------------------------------------------------------------
 VERSION  AUTHOR              DATE           DETAIL                              
 -----------------------------------------------------------------------------------------------------------------------
   1.0   Sanghita Das    09/15/2015     CaseEmailThreadIdTest                  
***********************************************************************************************************************/ 

@isTest(seeAllData=false)
public class CaseEmailThreadIdTest{


  public testMethod static void CaseEmailThreadIdTest() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' limit 1];
        User u = new User(Alias = 'standt', Email='CaseEmailThreadIdTest@te.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='CasereassignmentTESTtyco@te.com.c2s');
        
         Test.starttest();
         System.runAs(u) {
         ClsTestCustomSettingHelper.getApex_Helper_Settings(); 
         ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
         //ClsTestCustomSettingHelper.getCaseFinalVariables();        
         //ClsTestCustomSettingHelper.getWebToCaseStrings();
         
          //get PIC record Type
        Id vCasePICRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'TE_PIC_Standard_Case_Record_Type'].Id;
         //get PIC user record
        Id vPICUserId = [SELECT Id FROM User WHERE isActive=true and Profile.Name like '%PIC%' limit 1].Id;
        
        //get PIC record Type
        Id vAccountRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'CIS_Prospect'].Id;
        
         Account vAccount;
        vAccount = new Account();
        vAccount.Name = 'Test Pic acc2';
        vAccount.Legally_Restricted__c = true; 
        vAccount.BillingCity = 'Beijing';  
        vAccount.BillingCountry = 'Ch';
        vAccount.BillingState = '000001';
        vAccount.BillingStreet = 'Tiananmen';
        vAccount.BillingPostalCode = '200000';
        //vAccount.ownerId = teisAdminUserId;
        vAccount.Account_Manager__c = vPICUserId;
        vAccount.RecordTypeId=vAccountRT;
        insert vAccount;
        
        contact con = new Contact();
        con.Salutation='Mr.';
        con.email='testpiic@org.com';
        con.lastName='TestCon';
        con.accountid=vAccount.id;
        insert con;
        
        //PIC Case
        Case vCs = new Case();
        vCs.subject ='ref:_1234:ref';
        vCs.Origin = 'Email';    
        vCs.Status= 'New';
        vCs.Description = 'Test Description';
        vCs.ownerId = vPICUserId;
        //vCs.AccountId = vAccount.id;
        vCs.contactId=con.id;
        vCs.RecordTypeid = vCasePICRT;  
        vCs.PIC_Central_Thread_ID__c='ref:_1234:ref' ;   
        insert vCs;
        
         EmailMessage em1 = new emailMessage();
         em1.ToAddress='pic.info@te.com';
         em1.Subject='[ref:_1234:ref][ref:_1234:]';
         em1.incoming=true ;
         em1.parentid=Vcs.id;
         em1.MessageDate =date.valueof('2015-10-30T08:49:52.000+0000');        
         //insert em1;
         
         EmailMessage em = new emailMessage();
         em.ToAddress='pic.info.qa@te.com';
         em.Subject='ref:_1234:ref';
         em.incoming=true ;
         em.parentid=Vcs.id;
         em.MessageDate =date.valueof('2015-10-30T08:49:52.000+0000');
         system.debug('+++em+++'+em);         
         //insert em;
         
         EmailMessage em2 = new emailMessage();
         em2.ToAddress='pic.info.qa@te.com';
         em2.Subject='[ref:_1234:ref][ref:_1234:ref][ref:_1234]';
         em2.incoming=true ;
         em2.parentid=Vcs.id;
         em2.MessageDate =date.valueof('2015-10-30T08:49:52.000+0000');
         system.debug('+++em+++'+em2);         
         insert new List<EmailMessage>{ em2,em,em1};
         }

Test.stoptest();
}
}