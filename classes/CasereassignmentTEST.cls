/***********************************************************************************************************************
 Name: CasereassignmentTEST
 Org : C2S
 Copyright : © 2015 TE Connectivity 
========================================================================================================================
 Summary : Test class for Case Triiger Casereassignment for code coverage
 -----------------------------------------------------------------------------------------------------------------------
 VERSION  AUTHOR              DATE              DETAIL                              
 -----------------------------------------------------------------------------------------------------------------------
   1.0   Sandeep Y            10/20/2015        Initial Development CasereassignmentTEST
---------------------------------------------------------------------------------------------------------------------------------------------------
   1.1 Rajendra Shahane 03/21/2016  Modified for case - 900703                                   
***********************************************************************************************************************/ 

@isTest(seeAllData=false)
public class CasereassignmentTEST{

    public testMethod static void CasereassignmentTEST() 
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' limit 1];
        User u = new User(Alias = 'standt', Email='CasereassignmentTEST@te.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='CasereassignmentTESTtyco@te.com.c2s');
        
        Test.startTest();
        System.runAs(u) {
        //Start: Rajendra Shahane 03/21/2016  Modified for case - 900703
        ClsTestCustomSettingHelper.getCCPTriggerSettings();
        //End: Rajendra Shahane 03/21/2016  Modified for case - 900703
        ClsTestCustomSettingHelper.getApex_Helper_Settings(); 
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getCaseFinalVariables();        
        ClsTestCustomSettingHelper.getWebToCaseStrings();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        //ClsTestCustomSettingHelper.getAllSettings();
        
        //get PIC record Type
        Id vCasePICRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('TE PIC Standard Case Record Type').getRecordTypeId();//[SELECT Id FROM RecordType WHERE DeveloperName = 'TE_PIC_Standard_Case_Record_Type'].Id;
        //get CC record Type
        Id vCaseCCRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Care Cloud').getRecordTypeId();//[SELECT Id FROM RecordType WHERE DeveloperName = 'Customer_Care_Cloud'].Id;
        //get PIC user record
        Id vPICUserId = [SELECT Id FROM User WHERE isActive=true and Profile.Name like '%PIC%' limit 1].Id;
        //get CC User Id
        Id vCCUserId= [SELECT Id FROM User WHERE isActive=true and Profile.Name like '%CC CCP%' limit 1].Id;
        /*for(User usr: ([SELECT Id,Profile.Name FROM User WHERE isActive=true and (Profile.Name like '%CC CCP%' or Profile.Name like '%PIC%')]))
        {
            if(usr.Profile.Name.contains('CC CCP'))
                vCCUserId = usr.Id;
            else if(usr.Profile.Name.contains('PIC'))
                vPICUserId = usr.Id;
        }*/
        
        //get PIC Queue Id
        Id vPICQueueId = [SELECT Id FROM Group WHERE name like 'PIC%' limit 1].Id;
        
        //get CC Queue Id
        Id vCCQueueId= [SELECT Id FROM Group WHERE name like 'AMER Arrow Team%' limit 1].Id;
            
        for(Group grp: ([SELECT Id,Name FROM Group WHERE name like 'PIC%' or name like 'AMER Arrow Team%']))
        {
            if(grp.Name.contains('PIC'))
                vPICQueueId = grp.Id;
            else if(grp.Name.contains('PIC'))
                vCCQueueId = grp.Id;
        }
        
        //get PIC record Type
        Id vAccountRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();//[SELECT Id FROM RecordType WHERE DeveloperName = 'CIS_Prospect'].Id;
        
        //Id teisAdminUserId = Apex_Helper_Settings__c.getInstance('TEIS Admin User Id').Value__c;
        
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
        con.email='testpiic@org.com';
        con.lastName='TestCon';
        con.accountid=vAccount.id;
        insert con;
        
        //PIC Case
        Case vCs = new Case();
        vCs.subject ='testing';
        vCs.Origin = 'PIC US Email';    
        vCs.Status= 'New';
        vCs.Description = 'Test Description';
        vCs.ownerId = vPICUserId;
        //vCs.AccountId = vAccount.id;
        vCs.contactId=con.id;
        vCs.RecordTypeid = vCasePICRT;         
                  
        //insert vCs;
        //PIC Case
        Case vCs2 = new Case();
        vCs2.subject ='testing';
        vCs2.Origin = 'PIC US Email';    
        vCs2.Status= 'New';
        vCs2.Description = 'Test Description';
        vCs2.ownerId = vPICUserId;
        //vCs2.AccountId = vAccount.id;
        vCs2.contactId=con.id;
        vCs2.RecordTypeid = vCasePICRT;         
                  
        insert new List<Case> {vCs2, vCs};
        
        //transfer to CC user
        vCs.ownerId = vCCUserId;
        //Update vCs;
        
        //transfer to CC Queue
        vCs2.ownerId = vCCQueueId;
        Update new List<Case> {vCs2,VCs};
        }
        Test.stopTest();
    }
    
}