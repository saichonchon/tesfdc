/***********************************************************************************************************************
 Name: PICactivitytest
 Org : C2S
 Copyright : © 2015 TE Connectivity 
========================================================================================================================
 Summary : test class
 -----------------------------------------------------------------------------------------------------------------------
 VERSION  AUTHOR              DATE           DETAIL                              
 -----------------------------------------------------------------------------------------------------------------------
   1.0   Sanghita Das    09/15/2015     PICactivitytest   
   1.1   Rajendra Shahane 03/29/2016  Modified for case - 900703
***********************************************************************************************************************/ 

@isTest(seealldata=false)
public class PICactivitytest{
public testMethod static void PICactivitytest() {
        //Start: Rajendra Shahane Modified for case - 900703
        ClsTestCustomSettingHelper.getCCPTriggerSettings();
        //End: Rajendra Shahane Modified for case - 900703
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' limit 1];
        User u = new User(Alias = 'standt', Email='CasereassignmentTEST@te.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='CasereassignmentTESTtyco@te.com.c2s');
        
        
         //* Added by Archana...code changes start
        List<Trigger_Configuration__c> lstTriggerConfig = new  List<Trigger_Configuration__c>();
       
        Trigger_Configuration__c tc = new Trigger_Configuration__c(); 
        tc.Name='Avoid Duplicate PLM Id';
        tc.isRun__c=true;
        lstTriggerConfig .add(tc);
               
        Trigger_Configuration__c tc2 = new Trigger_Configuration__c(); 
        tc2.Name='DND Lead Conversion Initialization';
        tc2.isRun__c=true;
        lstTriggerConfig .add(tc2);
        
        Trigger_Configuration__c tc3 = new Trigger_Configuration__c(); 
        tc3.Name='Identify Fiscal Year';
        tc3.isRun__c=true;
        lstTriggerConfig .add(tc3);
        
        Trigger_Configuration__c tc4 = new Trigger_Configuration__c(); 
        tc4.Name='Populate Opportunity Partner';
        tc4.isRun__c=true;
        lstTriggerConfig .add(tc4);
        
        Trigger_Configuration__c tc5 = new Trigger_Configuration__c(); 
        tc5.Name='updateAccountBusinessUnit';
        tc5.isRun__c=true;
        lstTriggerConfig .add(tc5);
        
        insert lstTriggerConfig ;
        
        ADMTerritoryCode__c admTerritoryCode= new ADMTerritoryCode__c();
        admTerritoryCode.Name='ADMTerritoryCode';
        admTerritoryCode.Territory_Code__c='101485';
        insert admTerritoryCode;
        
                //* Added by Archana...code changes end
           
        Test.starttest();
        System.runAs(u) {
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getCaseFinalVariables();        
        ClsTestCustomSettingHelper.getWebToCaseStrings();
            
            
               
        //get PIC record Type
        Id vCasePICRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('TE PIC Standard Case Record Type').getRecordTypeId();//[SELECT Id FROM RecordType WHERE DeveloperName = 'TE_PIC_Standard_Case_Record_Type'].Id;
       
        //get PIC user record
        Id vPICUserId = [SELECT Id FROM User WHERE isActive=true and Profile.Name like '%PIC%' limit 1].Id;
        
        //get PIC record Type
        Id vAccountRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();//[SELECT Id FROM RecordType WHERE DeveloperName = 'CIS_Prospect'].Id;
        
        Account vAccount;
        vAccount = new Account();
        vAccount.Name = 'Test Pic acc2';
        vAccount.Legally_Restricted__c = true; 
        vAccount.BillingCity = 'Beijing';  
        vAccount.BillingCountry = 'Ch';
        vAccount.BillingState = '000001';
        vAccount.BillingStreet = 'Tiananmen';
        vAccount.BillingPostalCode = '200000';
       // vAccount.Account_Manager__c = vPICUserId;
        vAccount.RecordTypeId=vAccountRT;
        insert vAccount;
        
        contact con = new Contact();
        con.email='testpiic@org.com';
        con.lastName='TestCon';
        con.FirstName='Test1Con';
        con.accountid=vAccount.id;
        con.MailingCountry='United States';
        insert con;
        
        Trigger_Configuration__c TrgConf = new Trigger_Configuration__c();
        TrgConf.Name = 'updateAccountBusinessUnit';
        insert TrgConf;
        
        DD1_Definition__c DDdef = new DD1_Definition__c();
        DDdef.Name = 'Test';
        insert DDdef;
                   
        //PIC Case
        Case Cs = new Case();
        Cs.subject ='testing';
        Cs.Origin = 'PIC US Email';    
        Cs.Status= 'New';
        Cs.Description = 'Test Description';
        Cs.ownerId = vPICUserId;
        Cs.AccountId = vAccount.id;
        Cs.contactId=con.id;
        Cs.RecordTypeid = vCasePICRT;  
        Cs.city__c='Test City';
        Cs.Country__c='United States';
        Cs.State__c='TestState';
        Cs.Customer_Industry__c='TestIndustry';
        Cs.Hot_Lead__c= True ;
        Cs.Preferred_Distributor__c='Arrow';
        insert Cs;
              
        LiveChatVisitor lv = new LiveChatVisitor();
        insert lv;
        
        LiveChatTranscript l = new LiveChatTranscript();
        l.CaseId=Cs.id;
        l.LiveChatVisitorId = lv.id;
        l.body = 'test';        
        insert l;
        
        Cs.Status = 'In Progress';
        update Cs;
                
}
Test.stoptest();
}
}