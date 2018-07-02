/**************************************************************************************************************************************************
Name: changeInOwnerfromCaseQueuetoUser_Test
Copyright © 2011 TE Connectivity
===================================================================================================================================================
Purpose: This class contain Test Methods to cover UpdateCaseRecord,customerSurvey class and keepescalationastrue trigger on case
---------------------------------------------------------------------------------------------------------------------------------------------------       
                                                          
                                                     
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer          Date       Detail                                  Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
  1.0 Narasimha Narra    03/12/2013    Initial Development                      1453487                                   
**************************************************************************************************************************************************/
@isTest(seeAllData=true)
public class changeInOwnerfromCaseQueuetoUser_Test
{
    static testmethod void chkUpdateCaseRecord()
    {
        test.startTest();
        Apex_Helper_Settings__c QueueType = Apex_Helper_Settings__c.getInstance('APAC Channel Team');
        Apex_Helper_Settings__c vCaseRT_CCP = Apex_Helper_Settings__c.getInstance('Customer Care Cloud');
        Profile p1 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User usr = new User(Alias = 'stand', Email='ram1@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p1.Id, TimeZoneSidKey='America/Los_Angeles', UserName='std456@testorg.com', Region__c ='Asia Pacific', GIBU__c = 'Appliances', APAC_Office__c ='Singapore');
        insert usr;
        //insert account
        Account acc =  ClsTestHelp.createTestAccounts();
        insert acc;
        Contact con;
        con = ClsTestHelp.createTestContacts();
        con.email='test@org.com';
        insert con;
        //insert Case
        Case Cs = new Case();
        cs.OwnerId=QueueType.value__c;
        Cs.Origin = 'Email-cip1';
        Cs.Inquiry_Type__c = 'Cancellation';
        Cs.Status= 'In Progress';
        Cs.Description = 'Test Description';
        Cs.AccountId = acc.id;
        cs.contactId=con.Id;
        insert cs;
        CaseUtil_CCP.KeepEscationtrueboolean = false;
        cs.OwnerId=userInfo.getUserId();
        Cs.Status= 'Closed';
        update cs;
        CaseUtil_CCP.KeepEscationBeforeInsert =false;

        Case Cs1 = new Case();
        Cs1.OwnerId=usr.id;
        Cs1.Origin = 'Email-cip1';
        Cs1.Inquiry_Type__c = 'Cancellation';
        Cs1.Status= 'In Progress';        
        Cs1.Description = 'Test Description';
        Cs1.AccountId = acc.id;
        Cs1.contactId=con.Id;
        Cs1.RecordTypeId = vCaseRT_CCP.value__c;
        insert Cs1;
        test.stopTest();
    }
    
    static testmethod void chkUpdateforPIC()
    {
        test.startTest();
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
        insert Cs1;
        
        Cs1.Status= 'Closed';
        update Cs1;
        test.stopTest();
    }
}