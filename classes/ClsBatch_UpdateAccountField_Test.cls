/**
*  This test class used to test batch ClsBatchSetINDCustomerClassification.
*
@author Lili Zhao
@created 2013-11-27
@version 1.0   
@since 28.0
*
@changelog
* coverage 100% 
* 
* 
2013-11-27 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest(seeAllData = true) 
private class ClsBatch_UpdateAccountField_Test {

    static testMethod void myUnitTest() {
    	Account account = ClsTestHelp.createTestAccounts();
		account.GAMCD__c = 'test';
		insert account;	 	
    	
		List<Account> list_account = new List<Account>();
        list_account.add(account);
              
        Test.startTest();
              
        ClsBatch_UpdateAccountField clsBatch = new ClsBatch_UpdateAccountField();
        Database.BatchableContext BC;
        clsBatch.filter = ' limit 1';
        clsBatch.start(BC);
        clsBatch.execute(BC, list_account);
        clsBatch.finish(BC);
                  
        system.assert(true);
        Test.stopTest();
    }
}