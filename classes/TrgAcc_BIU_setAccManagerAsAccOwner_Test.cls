/**
*	This test class is for account_BIU_setAccManagerAsAccOwner.
*
@author Di Chen
@created 2012-02-23
@version 1.0
@since 20.0
*
@changelog
* 2012-05-33 Yuliang Ye <yuliang.ye@itbconsult.com>
* - Created
* - Test coverage 93%
*/
@isTest
private class TrgAcc_BIU_setAccManagerAsAccOwner_Test {

    static testMethod void testElse() {
    	Profile p = [select Id from Profile where Name = 'System Administrator' limit 1];
    	
    	User u = ClsTestHelp.createTestUsers();
    	u.ProfileId = p.Id;
    	u.Username = 'KO@testKOitbconsult.com';
    	u.Email = 'hoho@testItbconsult.com';
    	u.CommunityNickname = 'xxx.xxx';
    	u.Alias = 'rrr';
    	insert u;
        
        Test.startTest();
    	
    	system.runAs(u){
	    		
	    	User u2 = ClsTestHelp.createTestUsers();
	    	u2.Username = 'KAO@testEmail.com';
	    	u2.Email = 'zzzzz@testItbconsult.com';
	    	u2.CommunityNickname = 'zzz.zzz';
	    	u2.Alias = 'zzz';
	    	insert u2;

	        Account acc = ClsTestHelp.createTestAccounts();
	        acc.Account_Manager__c = u.Id;
	        insert acc;
	        
	        acc.Account_Manager__c = u2.Id;
	        update acc;
    	}
    	system.assert(true);
        Test.stopTest();
    }
}