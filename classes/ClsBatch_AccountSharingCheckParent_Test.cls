/**
*	This test class is for ClsBatch_AccountSharingCheckParent.
*
@author Di Chen
@created 2012-06-26
@version 1.0
@since 20.0
*
@changelog
* 2012-06-26 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 83%
*/
@isTest
private class ClsBatch_AccountSharingCheckParent_Test {

    static testMethod void testBatch() {
    	
        RecordType rt = ClsTestHelp.createTestRecordType();   										  
    										  
		Account acc = ClsTestHelp.createTestAccounts();  
		acc.RecordTypeId = rt.Id;
		insert acc;
		
		Account acc2 = ClsTestHelp.createTestAccounts();  
		acc2.RecordTypeId = rt.Id;
		acc2.Name = 'AccCon';
		acc2.ParentId = acc.Id;
		acc2.Public_Group_Id__c = acc.Id;
		insert acc2;
		
		List<Account> list_acc = new List<Account>();
		list_acc.add(acc2);
		
        Test.startTest();
        
        ClsBatch_AccountSharingCheckParent clsBatch = new ClsBatch_AccountSharingCheckParent();
        clsBatch.query = 'Select Id, ParentId, RecordTypeId, Public_Group_Id__c from Account limit 1';
        clsBatch.email = 'OKs@testitbconsult789.com';
        
        Database.BatchableContext bc;
		clsBatch.start(bc);
        clsBatch.execute(bc, list_acc);
        clsBatch.finish(bc);  
        
        system.assert(true);
        Test.stopTest();
    }
}