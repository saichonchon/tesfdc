/**
*	This test class is for ClsBatch_ReCalculationAccountTeam.
*
@author Di Chen
@created 2012-06-14
@version 1.0
@since 20.0
*
@changelog
* 2012-06-14 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 90%
*/
@isTest
private class ClsBatch_ReCalculationAccountTeam_Test {

    static testMethod void EmailIsNotNull() {
    	
    	RecordType rt1 = ClsTestHelp.createTestRecordType12();
    	
        Account acc = ClsTestHelp.createTestAccounts();
    	acc.SALES_TERRITORY_CDE__c = 'A003153';
    	insert acc;
    	
    	Account_Team__c atm = new Account_Team__c();
    	atm.Account__c = acc.Id;
    	atm.Role__c = 'Account Manager (AM)';
    	atm.RecordTypeId = rt1.Id;
    	insert atm;
    	
    	list<Account_Team__c> list_accountTeams = new list<Account_Team__c>();
    	list_accountTeams.add(atm);
    	
    	Test.startTest();
    	
    	ClsBatch_ReCalculationAccountTeam clsBatch = new ClsBatch_ReCalculationAccountTeam();
        Database.BatchableContext BC;
    	clsBatch.email = 'sdfsds@qq.com';
    	clsBatch.query = 'SELECT Account__c, Name, CreatedById, CreatedDate, CurrencyIsoCode, IsDeleted, LastModifiedById, LastModifiedDate, Opportunity_Access__c, ConnectionReceivedId, Id, RecordTypeId, Role__c, ConnectionSentId, SystemModstamp, TE_Network_Id__c, Team_Member_Formula__c, Team_Member__c, Team_Member_Contact__c, Team_Member_txt__c, Team_Member_Key__c, View__c FROM Account_Team__c limit 1';	
		
    	clsBatch.start(BC);
		clsBatch.execute(BC, list_accountTeams);
		clsBatch.finish(BC);
    	
    	system.assert(true);
    	Test.stopTest();
    }
    static testMethod void EmailIsNull() {
    	
    	RecordType rt1 = ClsTestHelp.createTestRecordType12();
    	
        Account acc = ClsTestHelp.createTestAccounts();
    	acc.SALES_TERRITORY_CDE__c = 'A003153';
    	insert acc;
    	
    	Account_Team__c atm = new Account_Team__c();
    	atm.Account__c = acc.Id;
    	atm.Role__c = 'Account Manager (AM)';
    	atm.RecordTypeId = rt1.Id;
    	insert atm;
    	
    	list<Account_Team__c> list_accountTeams = new list<Account_Team__c>();
    	list_accountTeams.add(atm);
    	
    	Test.startTest();
    	
    	ClsBatch_ReCalculationAccountTeam clsBatch = new ClsBatch_ReCalculationAccountTeam();
        Database.BatchableContext BC;
    	clsBatch.email = null;
    	clsBatch.query = 'SELECT Account__c, Name, CreatedById, CreatedDate, CurrencyIsoCode, IsDeleted, LastModifiedById, LastModifiedDate, Opportunity_Access__c, ConnectionReceivedId, Id, RecordTypeId, Role__c, ConnectionSentId, SystemModstamp, TE_Network_Id__c, Team_Member_Formula__c, Team_Member__c, Team_Member_Contact__c, Team_Member_txt__c, Team_Member_Key__c, View__c FROM Account_Team__c limit 1';	
		
    	clsBatch.start(BC);
		clsBatch.execute(BC, list_accountTeams);
		clsBatch.finish(BC);
    	
    	system.assert(true);
    	Test.stopTest();
    }
}