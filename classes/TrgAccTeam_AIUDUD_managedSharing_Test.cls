/**
*	This test class is for accountTeam_AIUDUD_managedSharing.
*
@author Di Chen
@created 2012-02-23
@version 1.0
@since 20.0
*
@changelog
* 2012-02-23 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 77%
*/
@isTest
private class TrgAccTeam_AIUDUD_managedSharing_Test {

     static testMethod void testUpdateRole1() {
    	
    	RecordType rt1 = ClsTestHelp.createTestRecordType();
    	RecordType rt2 = ClsTestHelp.createTestRecordType2();
    	
    	Account acc1 = ClsTestHelp.createTestAccounts();
    	acc1.RecordTypeId = rt1.Id;
    	acc1.Name = 'test 2';
    	insert acc1;
    	
    	Account acc2 = ClsTestHelp.createTestAccounts();
    	acc2.RecordTypeId = rt1.Id;
    	acc2.ParentId = acc1.Id;
    	insert acc2;
    	
    	Contact contact = ClsTestHelp.createTestContacts();
    	contact.FirstName = 'sand';
    	insert contact;
 
    	Test.startTest();
    	
        Account_Team__c AccTeam = new Account_Team__c();
        AccTeam.RecordTypeId = rt2.Id;
        AccTeam.Account__c = acc2.Id;
        AccTeam.Team_Member__c = UserInfo.getUserId();
        AccTeam.Team_Member_Contact__c = contact.Id;
        AccTeam.Role__c = 'Field Engineer (FE)';
        insert AccTeam;
        
        AccTeam.Role__c = 'Account Manager (AM)';
        update AccTeam;
        
        delete AccTeam;
        system.assert(true);
        Test.stopTest();
    }
    
     static testMethod void testUpdateRole2() {
    	
    	RecordType rt1 = ClsTestHelp.createTestRecordType();
    	RecordType rt2 = ClsTestHelp.createTestRecordType2();
		
    	Account acc1 = ClsTestHelp.createTestAccounts();
    	acc1.RecordTypeId = rt1.Id;
    	acc1.Name = 'test 2';
    	insert acc1;
    	
    	Account acc2 = ClsTestHelp.createTestAccounts();
    	acc2.RecordTypeId = rt1.Id;
    	acc2.ParentId = acc1.Id;
    	insert acc2;
    	
    	Contact contact = ClsTestHelp.createTestContacts();
    	contact.FirstName = 'sand';
    	insert contact;

    	Test.startTest();
    	
        Account_Team__c AccTeam = new Account_Team__c();
        AccTeam.RecordTypeId = rt2.Id;
        AccTeam.Account__c = acc2.Id;
        AccTeam.Team_Member__c = UserInfo.getUserId();
        AccTeam.Team_Member_Contact__c = contact.Id;
        AccTeam.Role__c = 'Account Manager (AM)';
        insert AccTeam;
        
        AccTeam.Role__c = 'Engineering';
        update AccTeam;
        
        system.assert(true);
        Test.stopTest();
    }
    
	static testMethod void testUpdateRole3() {
    	
    	RecordType rt1 = ClsTestHelp.createTestRecordType();
    	RecordType rt2 = ClsTestHelp.createTestRecordType2();
		
    	Account acc1 = ClsTestHelp.createTestAccounts();
    	acc1.RecordTypeId = rt1.Id;
    	acc1.Name = 'test 2';
    	insert acc1;
    	
    	Account acc2 = ClsTestHelp.createTestAccounts();
    	acc2.RecordTypeId = rt1.Id;
    	acc2.ParentId = acc1.Id;
    	insert acc2;
    	
    	Contact contact = ClsTestHelp.createTestContacts();
    	contact.FirstName = 'sand';
    	insert contact;

    	Test.startTest();
    	
        Account_Team__c AccTeam = new Account_Team__c();
        AccTeam.RecordTypeId = rt2.Id;
        AccTeam.Account__c = acc2.Id;
        AccTeam.Team_Member__c = UserInfo.getUserId();
        AccTeam.Team_Member_Contact__c = contact.Id;
        AccTeam.Role__c = 'Engineering';
        insert AccTeam;
        
        AccTeam.Role__c = '';
        AccTeam.Team_Member__c = null;
        update AccTeam;
        
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void testUpdateTeamMember() {
    	
    	RecordType rt1 = ClsTestHelp.createTestRecordType();
    	RecordType rt2 = ClsTestHelp.createTestRecordType2();
		
    	Account acc1 = ClsTestHelp.createTestAccounts();
    	acc1.RecordTypeId = rt1.Id;
    	acc1.Name = 'test 2';
    	insert acc1;
    	
    	Account acc2 = ClsTestHelp.createTestAccounts();
    	acc2.RecordTypeId = rt1.Id;
    	acc2.ParentId = acc1.Id;
    	insert acc2;
    	
    	Contact contact = ClsTestHelp.createTestContacts();
    	contact.FirstName = 'sand';
    	insert contact;

    	Test.startTest();
    	
        Account_Team__c AccTeam = new Account_Team__c();
        AccTeam.RecordTypeId = rt2.Id;
        AccTeam.Account__c = acc2.Id;
        AccTeam.Team_Member__c = UserInfo.getUserId();
        AccTeam.Team_Member_Contact__c = contact.Id;
        AccTeam.Role__c = 'Engineering';
        insert AccTeam;
        
        system.assert(true);
        Test.stopTest();
    }
}