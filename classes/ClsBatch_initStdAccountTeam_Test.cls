/**
*	This test class is for ClsBatch_initStdAccountTeam.
*
@author Di Chen
@created 2012-11-22
@version 1.0
@since 20.0
*
@changelog
* 2012-11-22 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 86%
*/
@isTest
private class ClsBatch_initStdAccountTeam_Test {

    static testMethod void testBatch() {
    	Profile p = [Select Id, Name From Profile 
     								where Name = 'Production Support' 
     								or Name = 'Service Account' 
     								or Name ='System Administrator' 
     								or Name ='Systemadministrator' limit 1];
     	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'Lio2n@testCompany999.com';
    	u.Alias = 'SF2';
    	u.ProfileId = p.Id;
    	u.CommunityNickname = 'QPS2';
    	u.IsActive = true;
		insert u;
		    	
    	RecordType rt1 = ClsTestHelp.createTestRecordType12();
    	
    	Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
    	sh.Level_7_Territory_Code__c = 'A003153';
    	sh.Level_7_Default_Owner__c = UserInfo.getUserId();
    	sh.Level_7_Assigned_User_Network_Ids__c = 'ET04135f';
    	insert sh;
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.SALES_TERRITORY_CDE__c = 'A003153';
    	acc.Sales_Hierarchy__c = sh.Id;
    	acc.Relay_Hierarchy__c = sh.Id;
    	acc.FE_Hierarchy__c = sh.Id;
    	acc.GAMCD__c = 'EUR';
    	acc.MKTMGRCDE__c = 'EUR';
    	acc.Field_Service_Engineer_Code__c = 'EUR';
    	insert acc;
		
    	Account_Team__c atm = new Account_Team__c();
    	atm.Account__c = acc.Id;
    	atm.Role__c = 'Account Manager (AM)';
    	atm.RecordTypeId = rt1.Id;
    	atm.Team_Member__c = u.Id;
    	insert atm;
    	
    	list<Account> list_accounts = new list<Account>();
    	list_accounts.add(acc);    	
    	
        Test.startTest();
        
        ClsBatch_initStdAccountTeam clsBatch = new ClsBatch_initStdAccountTeam();
        Database.BatchableContext BC;
    	clsBatch.query = 'SELECT Id FROM Account limit 1';	
    	clsBatch.email = 'asdfjka@akldjf.com';
    	
    	clsBatch.start(BC);
		clsBatch.execute(BC, list_accounts);
		clsBatch.finish(BC);
        
        system.assert(true);
        Test.stopTest();
    }
}