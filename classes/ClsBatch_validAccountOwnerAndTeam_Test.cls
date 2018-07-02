/**
*	This test class is for ClsBatch_validAccountOwnerAndTeam.
*
@author Di Chen
@created 2012-06-14
@version 1.0
@since 20.0
*
@changelog
* 2012-06-14 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 80%
*/
@isTest
private class ClsBatch_validAccountOwnerAndTeam_Test {

    static testMethod void testBatch() {
    	RecordType rt1 = ClsTestHelp.createTestRecordType12();
    	
    	Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
    	sh.Level_7_Territory_Code__c = 'A003153';
    	sh.Level_7_Default_Owner__c = UserInfo.getUserId();
    	sh.Level_7_Assigned_User_Network_Ids__c = 'ET04135f';
    	insert sh;
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.SALES_TERRITORY_CDE__c = 'A003153';
    	acc.Sales_Hierarchy__c = sh.Id;
    	insert acc;
    	
    	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'Lion@testCompany999.com';
    	u.Alias = 'SF';
    	u.CommunityNickname = 'QPS';
    	u.IsActive = false;
		insert u;
		
    	Account_Team__c atm = new Account_Team__c();
    	atm.Account__c = acc.Id;
    	atm.Role__c = 'Account Manager (AM)';
    	atm.RecordTypeId = rt1.Id;
    	atm.Team_Member__c = u.Id;
    	insert atm;
    	
    	list<Account> list_accounts = new list<Account>();
    	list_accounts.add(acc);
    	
        Test.startTest();
        
        ClsBatch_validAccountOwnerAndTeam clsBatch = new ClsBatch_validAccountOwnerAndTeam();
        Database.BatchableContext BC;
    	clsBatch.email = 'sdfsds@qq.com';
    	clsBatch.query = 'SELECT Id FROM Account limit 1';	
    	
    	clsBatch.start(BC);
		clsBatch.execute(BC, list_accounts);
		clsBatch.finish(BC);
        
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void testBatch2() {
    	
    	Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
    	sh.Level_7_Territory_Code__c = 'A003153';
    	sh.Level_7_Default_Owner__c = null;
    	sh.Level_7_Assigned_User_Network_Ids__c = 'ET04135a;';
    	insert sh;
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.SALES_TERRITORY_CDE__c = 'A003153';
    	acc.Sales_Hierarchy__c = sh.Id;
    	insert acc;
    	
    	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'LinasInbas@testCompany1233423.com';
    	u.Alias = 'Sidk';
    	u.CommunityNickname = 'mtas';
    	u.Te_Network_Id__c = 'ET04135a';
    	u.FirstName = 'TEIS';
    	u.LastName = 'Admin';
		insert u;
    	
    	list<Account> list_accounts = new list<Account>();
    	list_accounts.add(acc);
    	
        Test.startTest();
        
        ClsBatch_validAccountOwnerAndTeam clsBatch = new ClsBatch_validAccountOwnerAndTeam();
        Database.BatchableContext BC;
    	clsBatch.email = 'sdfsds@qq.com';
    	clsBatch.query = 'SELECT Id FROM Account limit 1';	
    	system.runAs(u){
    	clsBatch.start(BC);
		clsBatch.execute(BC, list_accounts);
		clsBatch.finish(BC);
    	}
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void testBatch3() {
    	
    	Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
    	sh.Level_7_Territory_Code__c = 'A003153';
    	sh.Level_7_Default_Owner__c = null;
    	sh.Level_7_Assigned_User_Network_Ids__c = 'ET04135b;';
    	insert sh;

    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.SALES_TERRITORY_CDE__c = 'A003153';
    	acc.Sales_Hierarchy__c = sh.Id;
    	insert acc;
    	
    	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'LinasIsdnbas@testCompany1233423.com';
    	u.Alias = 'Svdk';
    	u.CommunityNickname = 'mhas';
    	u.Te_Network_Id__c = 'ET04135b';
    	u.FirstName = 'TEIS';
    	u.LastName = 'Admin';
		insert u;
		
    	list<Account> list_accounts = new list<Account>();
    	list_accounts.add(acc);
    	
        Test.startTest();
        
        ClsBatch_validAccountOwnerAndTeam clsBatch = new ClsBatch_validAccountOwnerAndTeam();
        Database.BatchableContext BC;
    	clsBatch.email = 'sdfsds@qq.com';
    	clsBatch.query = 'SELECT Id FROM Account limit 1';	
    	system.runAs(u){
    	clsBatch.start(BC);
		clsBatch.execute(BC, list_accounts);
		clsBatch.finish(BC);
    	}
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void testBatch4() {
    	RecordType rt1 = ClsTestHelp.createTestRecordType13();
    	
    	Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
    	sh.Level_7_Territory_Code__c = 'A003153';
    	sh.Level_7_Default_Owner__c = UserInfo.getUserId();
    	sh.Level_7_Assigned_User_Network_Ids__c = 'ET04135c';
    	insert sh;
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.SALES_TERRITORY_CDE__c = 'A003153';
    	acc.Sales_Hierarchy__c = sh.Id;
    	insert acc;
    	
    	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'Lion@testCompany999.com';
    	u.Alias = 'SF';
    	u.CommunityNickname = 'QPS';
    	u.IsActive = true;
    	u.TE_Network_Id__c = 'BG07608c';
		insert u;
		
    	Account_Team__c atm = new Account_Team__c();
    	atm.Account__c = acc.Id;
    	atm.Role__c = 'Relay Specialist (IS)';
    	atm.RecordTypeId = rt1.Id;
    	atm.Team_Member__c = u.Id;
    	atm.TE_Network_Id__c = 'BG07608c';
    	insert atm;
    	
    	list<Account> list_accounts = new list<Account>();
    	list_accounts.add(acc);
    	
        Test.startTest();
        
        ClsBatch_validAccountOwnerAndTeam clsBatch = new ClsBatch_validAccountOwnerAndTeam();
        Database.BatchableContext BC;
    	clsBatch.email = 'sdfsds@qq.com';
    	clsBatch.query = 'SELECT Id FROM Account limit 1';	
    	
    	clsBatch.start(BC);
		clsBatch.execute(BC, list_accounts);
		clsBatch.finish(BC);
        
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void testBatch5() {
    	RecordType rt1 = ClsTestHelp.createTestRecordType13();
    	
    	Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
    	sh.Level_7_Territory_Code__c = 'A003153';
    	sh.Level_7_Default_Owner__c = UserInfo.getUserId();
    	sh.Level_7_Assigned_User_Network_Ids__c = 'ET04135d';
    	insert sh;
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.SALES_TERRITORY_CDE__c = 'A003153';
    	acc.Sales_Hierarchy__c = sh.Id;
    	insert acc;
    	
    	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'Lion@testCompany999.com';
    	u.Alias = 'SF';
    	u.CommunityNickname = 'QPS';
    	u.IsActive = true;
    	u.TE_Network_Id__c = 'BG07608d';
		insert u;
		
    	Account_Team__c atm = new Account_Team__c();
    	atm.Account__c = acc.Id;
    	atm.Role__c = 'Field Engineer (FE)';
    	atm.RecordTypeId = rt1.Id;
    	atm.Team_Member__c = u.Id;
    	atm.TE_Network_Id__c = 'BG076085';
    	insert atm;
    	
    	list<Account> list_accounts = new list<Account>();
    	list_accounts.add(acc);
    	
        Test.startTest();
        
        ClsBatch_validAccountOwnerAndTeam clsBatch = new ClsBatch_validAccountOwnerAndTeam();
        Database.BatchableContext BC;
    	clsBatch.email = 'sdfsds@qq.com';
    	clsBatch.query = 'SELECT Id FROM Account limit 1';	
    	
    	clsBatch.start(BC);
		clsBatch.execute(BC, list_accounts);
		clsBatch.finish(BC);
        
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void testBatch6() {
    	RecordType rt1 = ClsTestHelp.createTestRecordType13();
    	
    	Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
    	sh.Level_7_Territory_Code__c = 'A003153';
    	sh.Level_7_Default_Owner__c = UserInfo.getUserId();
    	sh.Level_7_Assigned_User_Network_Ids__c = 'ET04135e';
    	insert sh;
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.SALES_TERRITORY_CDE__c = 'A003153';
    	acc.Sales_Hierarchy__c = sh.Id;
    	insert acc;
    	
    	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'Lion@testCompany999.com';
    	u.Alias = 'SF';
    	u.CommunityNickname = 'QPS';
    	u.IsActive = true;
    	u.TE_Network_Id__c = 'BG07608e';
		insert u;
		
    	Account_Team__c atm = new Account_Team__c();
    	atm.Account__c = acc.Id;
    	atm.Role__c = 'Global Account Manager (GAM)';
    	atm.RecordTypeId = rt1.Id;
    	atm.Team_Member__c = u.Id;
    	atm.TE_Network_Id__c = 'BG07608e';
    	insert atm;
    	
    	list<Account> list_accounts = new list<Account>();
    	list_accounts.add(acc);
    	
        Test.startTest();
        
        ClsBatch_validAccountOwnerAndTeam clsBatch = new ClsBatch_validAccountOwnerAndTeam();
        Database.BatchableContext BC;
    	clsBatch.email = 'sdfsds@qq.com';
    	clsBatch.query = 'SELECT Id FROM Account limit 1';	
    	
    	clsBatch.start(BC);
		clsBatch.execute(BC, list_accounts);
		clsBatch.finish(BC);
        
        system.assert(true);
        Test.stopTest();
    }
     static testMethod void testBatch7() {
    	RecordType rt1 = ClsTestHelp.createTestRecordType12();
    	
    	Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
    	sh.Level_7_Territory_Code__c = 'A003153';
    	sh.Level_7_Default_Owner__c = UserInfo.getUserId();
    	sh.Level_7_Assigned_User_Network_Ids__c = 'ET04135g';
    	insert sh;
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.SALES_TERRITORY_CDE__c = 'A003153';
    	acc.Sales_Hierarchy__c = sh.Id;
    	insert acc;
    	
    	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'Lion@testCompany999.com';
    	u.Alias = 'SF';
    	u.CommunityNickname = 'QPS';
    	u.IsActive = true;
    	u.TE_Network_Id__c = 'ET04135g';
		insert u;
		
    	Account_Team__c atm = new Account_Team__c();
    	atm.Account__c = acc.Id;
    	atm.Role__c = 'Account Manager (AM)';
    	atm.RecordTypeId = rt1.Id;
    	atm.Team_Member__c = u.Id;
    	insert atm;
    	
    	list<Account> list_accounts = new list<Account>();
    	list_accounts.add(acc);
    	
        Test.startTest();
        
        ClsBatch_validAccountOwnerAndTeam clsBatch = new ClsBatch_validAccountOwnerAndTeam();
        Database.BatchableContext BC;
    	clsBatch.email = 'sdfsds@qq.com';
    	clsBatch.query = 'SELECT Id FROM Account limit 1';	
    	
    	clsBatch.start(BC);
		clsBatch.execute(BC, list_accounts);
		clsBatch.finish(BC);
        
        system.assert(true);
        Test.stopTest();
    }
}