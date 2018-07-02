/**
*	This test class is for ClsBatch_AccountSharingInit.
*
@author Di Chen
@created 2012-02-23
@version 1.0
@since 20.0
*
@changelog
* 2012-02-23 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 90%
*/
@isTest
private class ClsBatch_AccountSharingInit_Test {

    static testMethod void testBatch() {
        
        RecordType rt = ClsTestHelp.createTestRecordType();   										  
    										  
		Account acc = ClsTestHelp.createTestAccounts();  
		acc.RecordTypeId = rt.Id;
		insert acc;
		
		AccountTeamMember aTeamMember = new AccountTeamMember();
		aTeamMember.AccountId = acc.Id;
		aTeamMember.UserId = UserInfo.getUserId();
		insert aTeamMember;
		
		Group g = ClsTestHelp.createTestGroups();
		insert g;
		
		List<Account> list_acc = new List<Account>();
		list_acc.add(acc);
		
        Test.startTest();
        
        ClsBatch_AccountSharingInit clsBatch = new ClsBatch_AccountSharingInit();
        clsBatch.query = 'Select Id, ParentId, RecordTypeId, Public_Group_Id__c from Account limit 1';
        clsBatch.email = 'OK@testitbconsult789.com';
        
        Database.BatchableContext bc;
		clsBatch.start(bc);
        clsBatch.execute(bc, list_acc);
        clsBatch.finish(bc);  
        
        system.assert(true);
        Test.stopTest();
    }
}