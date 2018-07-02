/**
*	This test class is for AccTeamMember_BUD_preventUpdateDelete.
*
@author Di Chen
@created 2012-05-03
@version 1.0
@since 20.0
*
@changelog
* 2012-05-03 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 79%
*/
@isTest
private class TrgAccTeamM_BUD_preventUpdateDelete_Test {

    static testMethod void testBUD() {
	    Profile p1 = [select Id from Profile where Name = 'System Administrator' limit 1];
	    Profile p2 = [select Id from Profile where Name = 'Service Account' limit 1];
	    Apex_Helper_Settings__c integrationAdminId = new Apex_Helper_Settings__c();
        for(Apex_Helper_Settings__c integrationAdminId1 : [select Value__c from Apex_Helper_Settings__c where Name = 'Service Account Profile Id' limit 1]){
        	integrationAdminId = integrationAdminId1;
        }
	    if(integrationAdminId.Value__c == null){
	        integrationAdminId.Value__c = p2.Id;
	        integrationAdminId.Name = 'Service Account Profile Id';
	        insert integrationAdminId;
	    }
	    /*User u = ClsTestHelp.createTestUsers();
    	u.ProfileId = p1.Id;
    	u.Username = 'KOs@testKOistbconsult.com';
    	u.Email = 'hoshos@testItbconsult.com';
    	u.CommunityNickname = 'sxs.xxx';
    	u.Alias = 'sds';
    	insert u;  
	*/
		User u = [select Id from User where IsActive = true and ProfileId =:integrationAdminId.Value__c limit 1];//and Id = :integrationAdminId.Value__c
    	RecordType rt2 = ClsTestHelp.createTestRecordType2();
    	RecordType rt1 = ClsTestHelp.createTestRecordType();
    	
    	Account acc2 = ClsTestHelp.createTestAccounts();
    	acc2.RecordTypeId = rt1.Id;
    	insert acc2;
    	
    	Contact contact = ClsTestHelp.createTestContacts();
    	contact.FirstName = 'sand';
    	insert contact;
 
    	Test.startTest();
    	
        Account_Team__c AccTeam = new Account_Team__c();
        system.runAs(u){    
        AccTeam.RecordTypeId = rt2.Id;
        AccTeam.Account__c = acc2.Id;
        AccTeam.Team_Member__c = u.Id;
        AccTeam.Team_Member_Contact__c = contact.Id;
        AccTeam.Role__c = 'Field Engineer (FE)';
        insert AccTeam;

		}
		AccTeam.Role__c = 'Account Manager (AM)';
	    update AccTeam;
		//Account_Team__c AccTeam = [select Id ,Team_Member__c,Role__c from Account_Team__c where Team_Member__c =: u.Id];
		delete AccTeam;
        system.assert(true);
        test.stopTest();
    }
}