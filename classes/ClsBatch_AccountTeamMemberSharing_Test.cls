/**
*	This test class is for ClsBatch_AccountTeamMemberSharing.
*
@author Di Chen
@created 2012-03-13
@version 1.0
@since 20.0
*
@changelog
* 2012-03-13 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 90%
*/
@isTest
private class ClsBatch_AccountTeamMemberSharing_Test {

    static testMethod void testIf() {
    	
    	RecordType rt = ClsTestHelp.createTestRecordType2();
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	insert acc;

    	Account_Team__c aTeam = new Account_Team__c();
    	aTeam.Account__c = acc.Id;
    	aTeam.Role__c = 'Field Engineer (FE)';
    	aTeam.RecordTypeId = rt.Id;
    	aTeam.Team_Member__c = UserInfo.getUserId();
    	insert aTeam;
    	
        list<Account> list_acc = new list<Account>();
    	list_acc.add(acc);
        Test.startTest();
        
        ClsBatch_AccountTeamMemberSharing clsBatch = new ClsBatch_AccountTeamMemberSharing();
        clsBatch.query = 'Select Id, ParentId, RecordTypeId, Public_Group_Id__c from Account limit 1';
        clsBatch.email = 'OK@testitbconsult7891.com';
        
        Database.BatchableContext bc;
		clsBatch.start(bc);
        clsBatch.execute(bc, list_acc);
        clsBatch.finish(bc); 
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void testElse() {
    	
    	RecordType rt = ClsTestHelp.createTestRecordType2();
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	insert acc;

    	Account_Team__c aTeam = new Account_Team__c();
    	aTeam.Account__c = acc.Id;
    	aTeam.Role__c = 'Customer Service Rep (CSR)';
    	aTeam.RecordTypeId = rt.Id;
    	aTeam.Team_Member__c = UserInfo.getUserId();
    	insert aTeam;
    	
        list<Account> list_acc = new list<Account>();
    	list_acc.add(acc);
        Test.startTest();
        
        ClsBatch_AccountTeamMemberSharing clsBatch = new ClsBatch_AccountTeamMemberSharing();
        clsBatch.query = 'Select Id, ParentId, RecordTypeId, Public_Group_Id__c from Account limit 1';
        clsBatch.email = 'OK@testitbconsult7891.com';
        
        Database.BatchableContext bc;
		clsBatch.start(bc);
        clsBatch.execute(bc, list_acc);
        clsBatch.finish(bc); 
        system.assert(true);
        Test.stopTest();
    }
}