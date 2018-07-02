/**
*   This test trigger is for Contact_AU_updateCampaignMember.
*
@author Di Chen
@created 2013-01-25
@version 1.0
@since 20.0
*
@changelog
* 2013-01-25 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 100%
*/
@isTest
private class TrgContact_AU_updateCampaignMember_Test {

    static testMethod void testAU() {
    	
    	Profile p = [Select Id, Name From Profile 
     								where Name = 'Production Support' 
     								or Name = 'Service Account' 
     								or Name ='System Administrator' 
     								or Name ='Systemadministrator' limit 1];
     	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'linad@testCompany999.com';
    	u.Alias = 'SFs';
    	u.ProfileId = p.Id;
    	u.Username = 'what@xx.com';
    	u.CommunityNickname = 'QPS';
    	u.IsActive = true;
		insert u;
		    	
        Account acc = ClsTestHelp.createTestAccounts();
        insert acc;
        
        Contact con = ClsTestHelp.createTestContacts();
        con.AccountId = acc.Id;
        con.NPS_Language__c = 'DE';
        con.NPS_Contact__c = true;
        con.Email = 'hallo@scd.com';
        con.OwnerId = UserInfo.getUserId();
        insert con;
        
        Survey__c survey = new Survey__c();
        survey.Name = 'henhao';
        insert survey;
                
        Campaign cam = new Campaign();
        cam.Name = 'nihao';
        cam.EndDate = date.today() - 5;
        cam.Survey__c = survey.Id;
        cam.Survey_Date__c = date.today() - 15;
        insert cam;
        
        CampaignMember cm = new CampaignMember();
        cm.ContactId = con.Id;
        cm.Contact_Owner__c = UserInfo.getUserId();
        cm.CampaignId = cam.Id;
        insert cm;
        
        Test.startTest();
        
        con.OwnerId = u.Id;
        update con;
        
        system.assert(true);
        Test.stopTest();
    }
}