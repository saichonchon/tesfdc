/**
*  This test class used to test class ExtRecalculateBudget.
*
@author Lili Zhao
@created 2013-09-27
@version 1.0   
@since 28.0
*
@changelog
* coverage 100% 
* 
* 
2013-09-27 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest(seeAllData = true) 
private class ClsBatch_updateAccountGAMNPSScore_Test {

    static testMethod void AccountRecordType1() {
    	Account account = ClsTestHelp.createTestAccounts();
		account.GAMCD__c = 'test';
		insert account;
		
		Account accountGAM = ClsTestHelp.createTestAccounts();
		accountGAM.GAMCD__c = 'test';
		accountGAM.NPS_Score__c = 2;
		accountGAM.Type = 'Global Account';
		insert accountGAM;
	
		Contact contact1  = ClsTestHelp.createTestContacts();
		contact1.AccountId = account.Id;	
		contact1.Survey_Attended_Date__c = Date.valueOf('2013-11-21');
		insert contact1;
		
		Contact contact2  = ClsTestHelp.createTestContacts();
		contact2.AccountId = account.Id;	
		contact2.Survey_Attended_Date__c = Date.valueOf('2013-10-21');
		insert contact2;
		
		Answer__c answer = new Answer__c();
		answer.Answer__c = '2';
		answer.Contact__c = contact1.Id;
		answer.Current__c = true;
		answer.Question__c = 'a1OE000000038ao';
		insert answer;
		
		Answer__c answer1 = new Answer__c();
		answer1.Answer__c = '4';
		answer1.Contact__c = contact2.Id;
		answer1.Current__c = true;
		answer1.Question__c = 'a1OE000000038ao';
		insert answer1;		 	
    	
		List<Account> list_account = new List<Account>();
        list_account.add(account);
        list_account.add(accountGAM);
              
        Test.startTest();
              
        ClsBatch_updateAccountGAMNPSScore clsBatch = new ClsBatch_updateAccountGAMNPSScore();
        Database.BatchableContext BC;
        clsBatch.filter = ' limit 1';
        clsBatch.start(BC);
        clsBatch.execute(BC, list_account);
        clsBatch.finish(BC);
                  
        system.assert(true);
        Test.stopTest();
    }
}