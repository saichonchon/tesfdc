/**********************************************************************************************************************************************
*******
Name: CaseAssignmentUsers_Test
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This test class covers test coverage for 
Trigger:outOfofficeUseron on User and keepescalationastrue on Case
class:CaseAssignmentUsers
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE       DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Narasimha Narra     31/12/2013    Test Class                       
***********************************************************************************************************************************************
*****/
@isTest(seeAllData=true)
public Class CaseAssignmentUsers_Test
{
    static testmethod void assignmentTest()
    {
        Profile p = [select id, name from Profile where  name = 'System Administrator' limit 1];    
        User activeUser = new User(alias = 'tesuser',email='test@testorg.com',
                                 lastname='Testing',profileid = p.Id,IsActive=true,
                                 emailencodingkey='UTF-8',localesidkey='en_US',timezonesidkey='America/Los_Angeles',
                                 LanguageLocaleKey='en_US',username='testu1@testorg.com');
        insert activeUser ;
        User outOfUser = new User(alias = 'testus',email='test@testorg.com',
                                 lastname='Testing',profileid = p.Id,IsActive=true,
                                 emailencodingkey='UTF-8',localesidkey='en_US',timezonesidkey='America/Los_Angeles',
                                 LanguageLocaleKey='en_US',username='testu2@testorg.com',Alternate_User1__c= activeUser.Id
                                  
                                  );
        insert outOfUser;
        test.startTest();
        //insert account
        Account acc =  ClsTestHelp.createTestAccounts();
        insert acc;
        //insert contact
        Contact con;
        con = ClsTestHelp.createTestContacts();
        con.email='test@org.com';
        insert con;
        Case Cs = new Case();
        cs.OwnerId=outOfUser .Id;
        Cs.Origin = 'Email-cip1';
        Cs.Inquiry_Type__c = 'Cancellation';
        Cs.Status= 'In Progress';
        Cs.Description = 'Test Description';
        Cs.AccountId = acc.id;
        cs.contactId=con.Id;
        insert cs;
        outOfUser.Out_Of_Office__c=true;
        update outOfUser;
        Case Cs2 = new Case();
        cs2.OwnerId=activeUser.Id;
        Cs2.Origin = 'Email-cip1';
        Cs2.Inquiry_Type__c = 'Cancellation';
        Cs2.Status= 'In Progress';
        Cs2.Description = 'Test Description';
        Cs2.AccountId = acc.id;
        cs2.contactId=con.Id;
        insert cs2;
        cs2.OwnerId=outOfUser .Id;
        update Cs2;
        Test.stopTest();
    }
}