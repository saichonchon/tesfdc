/**
*	This test class is for ClsBatch_setAccountSalesHierarchy.
*
@author Di Chen
@created 2013-04-03
@version 1.0
@since 20.0
*
@changelog
* 2013-04-03 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 100%
*/
@isTest
private class ClsBatch_setAccountSalesHierarchy_Test {

    static testMethod void AccountRecordType1() {
    	RecordType rt2 = ClsTestHelp.createTestRecordType8();
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.Name = 'axx';
    	acc.RecordTypeId = rt2.Id;
    	acc.Customer_Classification__c = 'A';
    	acc.Type = 'Global Account';
    	acc.GAMCD__c = '1000';
    	insert acc;    	
    	
		List<Account> scope = new List<Account>();
        scope.add(acc);
              
        Test.startTest();
              
        ClsBatch_setAccountSalesHierarchy clsBatch = new ClsBatch_setAccountSalesHierarchy();
        Database.BatchableContext BC;
        clsBatch.filter = ' limit 1';
        clsBatch.start(BC);
        clsBatch.execute(BC, scope);
        clsBatch.finish(BC);
              
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void AccountRecordType2() {
    	RecordType rt2 = ClsTestHelp.createTestRecordType8();
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.Name = 'axx';
    	acc.RecordTypeId = rt2.Id;
    	acc.Customer_Classification__c = 'A';
    	acc.Type = 'Grouped B';
    	acc.GAMCD__c = '1000';
    	//****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
    	acc.MKTMGRCDE__c = 'D1412';
    	acc.IND_KAM_Code__c = 'D1412';
    	//****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
    	insert acc;    	
    	
		List<Account> scope = new List<Account>();
        scope.add(acc);
              
        Test.startTest();
              
        ClsBatch_setAccountSalesHierarchy clsBatch = new ClsBatch_setAccountSalesHierarchy();
        Database.BatchableContext BC;
        clsBatch.filter = ' limit 1';
        clsBatch.start(BC);
        clsBatch.execute(BC, scope);
        clsBatch.finish(BC);
              
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void AccountRecordType3() {
    	RecordType rt2 = ClsTestHelp.createTestRecordType();
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.Name = 'axx';
    	acc.RecordTypeId = rt2.Id;
    	acc.Customer_Classification__c = 'A';
    	acc.Type = 'Global Account';
    	acc.GAMCD__c = '1000';
    	insert acc;    	
    	
		List<Account> scope = new List<Account>();
        scope.add(acc);
              
        Test.startTest();
              
        ClsBatch_setAccountSalesHierarchy clsBatch = new ClsBatch_setAccountSalesHierarchy();
        Database.BatchableContext BC;
        clsBatch.filter = ' limit 1';
        clsBatch.start(BC);
        clsBatch.execute(BC, scope);
        clsBatch.finish(BC);
              
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void AccountRecordType4() {
    	RecordType rt2 = ClsTestHelp.createTestRecordType();
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.Name = 'axx';
    	acc.RecordTypeId = rt2.Id;
    	acc.Customer_Classification__c = 'A';
    	acc.Type = 'Grouped B';
    	acc.GAMCD__c = '1000';
    	//****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
    	acc.MKTMGRCDE__c = 'D1412';
    	acc.IND_KAM_Code__c = 'D1412';
    	//****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
    	insert acc;    	
    	
		List<Account> scope = new List<Account>();
        scope.add(acc);
              
        Test.startTest();
              
        ClsBatch_setAccountSalesHierarchy clsBatch = new ClsBatch_setAccountSalesHierarchy();
        Database.BatchableContext BC;
        clsBatch.filter = ' limit 1';
        clsBatch.start(BC);
        clsBatch.execute(BC, scope);
        clsBatch.finish(BC);
              
        system.assert(true);
        Test.stopTest();
    }
}