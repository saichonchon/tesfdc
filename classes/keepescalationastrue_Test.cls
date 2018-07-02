/**************************************************************************************************************************************************
Name:  keepescalationastrue _Test
Copyright © 2011 TE Connectivity
===================================================================================================================================================
Purpose: This class contain Test Methods to cover keepescalationastrue trigger on case
---------------------------------------------------------------------------------------------------------------------------------------------------       
                                                            
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer          Date       Detail                                  Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
  1.0 Narasimha Narra    11/11/2013    Initial Development                      1453487                                   
**************************************************************************************************************************************************/
@isTest(seeAllData=false)
public class keepescalationastrue_Test
{
    static testmethod void chkkeepescalation()
    {
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        test.startTest();
        Id PICrecId = Apex_Helper_Settings__c.getInstance('PIC Service Cloud').Value__c;
        //insert account
        Account acc =  ClsTestHelp.createTestAccounts();
        insert acc;
        Contact con;
        con = ClsTestHelp.createTestContacts();
        con.email='test@org.com';
        con.AccountId = acc.Id;//added by nelson zheng 2015-8-12
        insert con;
        Contact con1;
        con1 = ClsTestHelp.createTestContacts();
        con1.email='test1@org.com';
        con1.Lead_converted__c=12345;
        con1.AccountId = acc.Id;//added by nelson zheng 2015-8-12
        insert con1;
        //insert Case
        Case Cs = new Case();
        Cs.Origin = 'Email-cip1';
        Cs.Inquiry_Type__c = 'Cancellation';
        Cs.Status= 'In Progress';
        Cs.Description = 'Test Description';
        Cs.AccountId = acc.id;
        cs.contactId=con.Id;
        cs.IsEscalated=true;
        insert cs;
        cs.Status='Closed';
        update cs;
        
        Case Cs1 = new Case();
        Cs1.Origin = 'Email';
        Cs1.Inquiry_Type__c = 'Cancellation';
        Cs1.Status= 'In Progress';
        Cs1.Description = 'Test1 Description';
        Cs1.AccountId = acc.id;
        Cs1.contactId=con1.Id;
        Cs1.IsEscalated=true;
        Cs1.RecordTypeid = PICrecId;
        insert Cs1;
        Cs1.Status='Closed';
        update Cs1;
        test.stopTest();
    }
    
    static testmethod void chkUpdateforPIC()
    {
        test.startTest();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        Apex_Helper_Settings__c vCaseRT_PIC = Apex_Helper_Settings__c.getInstance('PIC Service Cloud');
        Profile p1 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User usr = new User(Alias = 'stand', Email='ram1@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p1.Id, TimeZoneSidKey='America/Los_Angeles', UserName='std456@testorg.com', Region__c ='Asia Pacific', GIBU__c = 'Appliances', APAC_Office__c ='Singapore');
        insert usr;
        //insert account
        Account acc =  ClsTestHelp.createTestAccounts();
        insert acc;
        Contact con;
        con = ClsTestHelp.createTestContacts();
        con.email='test@org.com';
        con.Customer_Survey_Opt_Out__c = false;
        con.Survey_Sent__c = true;
        insert con;
        
        //insert Case
        
        Case Cs1 = new Case();
        Cs1.OwnerId=usr.id;
        Cs1.Origin = 'Email-cip1';
        Cs1.Inquiry_Type__c = 'Cancellation';
        Cs1.Status= 'In Progress';
        
        Cs1.Description = 'Test Description';
        Cs1.AccountId = acc.id;
        Cs1.contactId=con.Id;
        //Cs1.RecordTypeId = vCaseRT_CCP.value__c; Commented for Case# 00901186 by Subramanian
        Cs1.RecordTypeId = vCaseRT_PIC.value__c;
        Cs1.Survey_Sent__c = false;
        insert Cs1;
        Cs1.Status= 'Closed';
        update Cs1;
        Cs1.Status= 'ReOpen';
        Cs1.First_Survey__c = false;
        Cs1.Case_Re_Open_Reason__c = 'New Query';
        Cs1.Case_Reopened__c = true;
        Cs1.Survey_Sent__c = true;
        update Cs1;
        
        test.stopTest();
    }
    
    static testmethod void chkUpdateforcc()
    {
        test.startTest();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        Apex_Helper_Settings__c vCaseRT_PIC = Apex_Helper_Settings__c.getInstance('Customer Care Cloud');
        Profile p1 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User usr = new User(Alias = 'stand', Email='ram1@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p1.Id, TimeZoneSidKey='America/Los_Angeles', UserName='std456@testorg.com', Region__c ='Asia Pacific', GIBU__c = 'Appliances', APAC_Office__c ='Singapore');
        insert usr;
        //insert account
        Account acc =  ClsTestHelp.createTestAccounts();
        insert acc;
        Contact con;
        con = ClsTestHelp.createTestContacts();
        con.email='test@org.com';
        con.Customer_Survey_Opt_Out__c = false;
        con.Survey_Sent__c = true;
        insert con;
        
        //insert Case
        
        Case Cs1 = new Case();
        Cs1.OwnerId=usr.id;
        Cs1.Origin = 'Email-cip1';
        Cs1.Inquiry_Type__c = 'Cancellation';
        Cs1.Status= 'In Progress';        
        Cs1.Description = 'Test Description';
        Cs1.AccountId = acc.id;
        Cs1.contactId=con.Id;
        //Cs1.RecordTypeId = vCaseRT_CCP.value__c; Commented for Case# 00901186 by Subramanian
        Cs1.RecordTypeId = vCaseRT_PIC.value__c;
        Cs1.Survey_Sent__c = false;
        insert Cs1;       
        Cs1.Status= 'Closed';  
        update Cs1;     
        Cs1.Status= 'ReOpen';
        Cs1.First_Survey__c = false;
        Cs1.Case_Re_Open_Reason__c = 'New Query';
        Cs1.Case_Reopened__c = true;
        Cs1.Survey_Sent__c = true;
        update Cs1;
        
        test.stopTest();
    }
    
    static testmethod void chkUpdateforcc1()
    {
        test.startTest();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        Apex_Helper_Settings__c vCaseRT_PIC = Apex_Helper_Settings__c.getInstance('Customer Care Cloud');
        Profile p1 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User usr = new User(Alias = 'stand', Email='ram1@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p1.Id, TimeZoneSidKey='America/Los_Angeles', UserName='std456@testorg.com', Region__c ='Asia Pacific', GIBU__c = 'Appliances', APAC_Office__c ='Singapore');
        insert usr;
        //insert account
        Account acc =  ClsTestHelp.createTestAccounts();
        insert acc;
        Contact con;
                        
        Case Cs1 = new Case();
        Cs1.OwnerId=usr.id;
        Cs1.Origin = 'Email';
        Cs1.Inquiry_Type__c = 'Order Status';
        Cs1.Status= 'In Progress';        
        Cs1.Description = 'Test Description';
        Cs1.AccountId = acc.id;
        Cs1.RecordTypeId = vCaseRT_PIC.value__c;
        Cs1.Survey_Sent__c = false;
        insert Cs1; 
        con = ClsTestHelp.createTestContacts();
        con.email='test@org.com';
        con.Customer_Survey_Opt_Out__c = false;
        con.Survey_Sent__c = false;
        insert con;                   
        Cs1.Survey_Sent__c = true;         
        Cs1.Status= 'Closed'; 
        Cs1.contactId=con.Id;
        update Cs1; 
        Cs1.Status= 'ReOpen';
        Cs1.First_Survey__c = false;
        Cs1.Case_Re_Open_Reason__c = 'New Query';
        Cs1.Case_Reopened__c = true;
        Cs1.Survey_Sent__c = true;
        update Cs1;
                
        test.stopTest();
    }
    
    static testmethod void chkUpdateforpic1()
    {
        test.startTest();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        Apex_Helper_Settings__c vCaseRT_PIC = Apex_Helper_Settings__c.getInstance('PIC Service Cloud');
        Profile p1 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User usr = new User(Alias = 'stand', Email='ram1@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p1.Id, TimeZoneSidKey='America/Los_Angeles', UserName='std456@testorg.com', Region__c ='Asia Pacific', GIBU__c = 'Appliances', APAC_Office__c ='Singapore');
        insert usr;
        //insert account
        Account acc =  ClsTestHelp.createTestAccounts();
        insert acc;
        Contact con;
                        
        Case Cs1 = new Case();
        Cs1.OwnerId=usr.id;
        Cs1.Origin = 'Email';
        Cs1.Inquiry_Type__c = 'Order Status';
        Cs1.Status= 'In Progress';        
        Cs1.Description = 'Test Description';
        Cs1.AccountId = acc.id;
        Cs1.RecordTypeId = vCaseRT_PIC.value__c;
        Cs1.Survey_Sent__c = false;
        insert Cs1; 
        con = ClsTestHelp.createTestContacts();
        con.email='test@org.com';
        con.Customer_Survey_Opt_Out__c = false;
        con.Survey_Sent__c = false;
        insert con;                   
        Cs1.Survey_Sent__c = true;         
        Cs1.Status= 'Closed'; 
        Cs1.contactId=con.Id;
        update Cs1; 
        Cs1.Status= 'ReOpen';
        Cs1.First_Survey__c = false;
        Cs1.Case_Re_Open_Reason__c = 'New Query';
        Cs1.Case_Reopened__c = true;
        Cs1.Survey_Sent__c = true;
        update Cs1;
                
        test.stopTest();
    }
}