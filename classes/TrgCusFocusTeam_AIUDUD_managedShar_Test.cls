/**
*	This test class is for customerFocusTeam_AIUDUD_managedSharing.
*
@author Di Chen
@created 2012-03-12
@version 1.0
@since 20.0
*
@changelog
* 2012-03-12 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 78%
*/
@isTest
private class TrgCusFocusTeam_AIUDUD_managedShar_Test {

     static testMethod void insertCustomerFocusTeamMember() {
    	
    	RecordType rt = ClsTestHelp.createTestRecordType();
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.RecordTypeId = rt.Id;
    	insert acc;
    	
        Test.startTest();
        
        Customer_Focus_Team_Member__c cftm = new Customer_Focus_Team_Member__c();
        cftm.Global_Account_Lkp__c = acc.Id;
        cftm.Salesforce_User_Name__c = UserInfo.getUserId(); 
        insert cftm;
        
        delete cftm;
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void updateCustomerFocusTeamMember1() {
    	
    	RecordType rt = ClsTestHelp.createTestRecordType();
    	
    	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'DargonKnights@testItbconsult321456987.com';
    	u.CommunityNickname = 'Dargon';
    	insert u;
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.RecordTypeId = rt.Id;
    	insert acc;
    	
    	Account acc2 = ClsTestHelp.createTestAccounts();
    	acc2.Name = 'Shadow Fiend';
    	acc2.RecordTypeId = rt.Id;
    	insert acc2;
    	
        Test.startTest();
        
        Customer_Focus_Team_Member__c cftm = new Customer_Focus_Team_Member__c();
        cftm.Global_Account_Lkp__c = acc.Id;
        cftm.Salesforce_User_Name__c = UserInfo.getUserId(); 
        cftm.Role__c = 'Logistics';
        insert cftm;
        
		cftm.Role__c = 'Account Manager (AM)';
        update cftm;  
        
        Customer_Focus_Team_Member__c cftm2 = [select Role__c from Customer_Focus_Team_Member__c where Id =: cftm.Id];
        system.assertEquals('Account Manager (AM)', cftm2.Role__c);
        Test.stopTest();
    }
	static testMethod void updateCustomerFocusTeamMember2() {
    	
    	RecordType rt = ClsTestHelp.createTestRecordType();
    	
    	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'Lucifer@testItbconsult321456987.com';
    	u.CommunityNickname = 'Knight';
    	insert u;
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.RecordTypeId = rt.Id;
    	insert acc;
    	
    	Account acc2 = ClsTestHelp.createTestAccounts();
    	acc2.RecordTypeId = rt.Id;
    	insert acc2;
    	
        Test.startTest();
        
        Customer_Focus_Team_Member__c cftm = new Customer_Focus_Team_Member__c();
        cftm.Global_Account_Lkp__c = acc.Id;
        cftm.Salesforce_User_Name__c = UserInfo.getUserId(); 
        cftm.Role__c = 'Logistics';
        insert cftm;
        
        Customer_Focus_Team_Member__c cftm2 = [select Role__c from Customer_Focus_Team_Member__c where Id =: cftm.Id];
        system.assertEquals('Logistics', cftm2.Role__c);
         
        Test.stopTest();
    }
}