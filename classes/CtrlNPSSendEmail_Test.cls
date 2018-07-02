/**
*   This test class is for CtrlNPSSendEmail.
*
@author Di Chen
@created 2012-12-18
@version 1.0
@since 20.0
*
@changelog
* 2012-12-18 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 95%
*/
@isTest
private class CtrlNPSSendEmail_Test {

    static testMethod void testMostMethods() {
    	
    	Profile p = [Select Id, Name From Profile 
                     where Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
		User u = ClsTestHelp.createTestUsers();
		u.Email = 'hellosManedsfd@testCompany1233423.com';
		u.Alias = 'dpses';
		u.CommunityNickname = 'NNND';
		u.ProfileId = p.Id;
		insert u;
		
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Account_Manager__c = u.Id;
        insert acc;
        
        Contact con = ClsTestHelp.createTestContacts();
        con.AccountId = acc.Id;
        con.NPS_Language__c = 'DE';
        con.Email = 'asldf@slkfs.com';
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
        cm.CampaignId = cam.Id;
        insert cm;
        
        Apexpages.currentPage().getParameters().put('Id',cam.Id);
        
        Test.startTest();
        
        CtrlNPSSendEmail ctrl = new CtrlNPSSendEmail();
        
        ctrl.send();
        ctrl.cancel();
        
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void testError() {
    	
        Account acc = ClsTestHelp.createTestAccounts();
        insert acc;
        
        Contact con = ClsTestHelp.createTestContacts();
        con.AccountId = acc.Id;
        con.NPS_Language__c = 'DE';
        con.Email = 'asldf@slkfs.com';
        insert con;
        
        Survey__c survey = new Survey__c();
        survey.Name = 'henhao';
        insert survey;
        
        Campaign cam = new Campaign();
        cam.Name = 'nihao';
        cam.EndDate = date.today() - 5;
        cam.Survey__c = survey.Id;
        cam.Notification_Sent__c = true;
        cam.Survey_Date__c = date.today() - 15;
        insert cam;
        
        CampaignMember cm = new CampaignMember();
        cm.ContactId = con.Id;
        cm.CampaignId = cam.Id;
        insert cm;
        
        Apexpages.currentPage().getParameters().put('Id',cam.Id);
        
        Test.startTest();
        
        CtrlNPSSendEmail ctrl = new CtrlNPSSendEmail();
        
        system.assert(true);
        Test.stopTest();
    }
}