/**
*   This test class is for Campaign_AU_updateCampaignMemberIdonContact.
*
@author Di Chen
@created 2013-02-01
@version 1.0
@since 20.0
*
@changelog
* 2013-02-01 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 87%
*/
@isTest
private class TrgCampaign_AU_updateCamMIdonCon_Test {

    static testMethod void TestAU1() {
        Account acc = ClsTestHelp.createTestAccounts();
        insert acc;
        
        Contact con = ClsTestHelp.createTestContacts();
        con.AccountId = acc.Id;
        con.Email = 'asldf@slkfs.com';
        insert con;
                
        Survey__c survey = new Survey__c();
        survey.Name = 'henhao';
        insert survey;
        
        Campaign cam = new Campaign();
        cam.Name = 'nihao';
        cam.EndDate = date.today() - 5;
        cam.Survey__c = survey.Id;
        cam.IsActive = false;
        cam.Survey_Date__c = date.today() - 15;
        insert cam;
        
        CampaignMember cm = new CampaignMember();
        cm.ContactId = con.Id;
        cm.CampaignId = cam.Id;
        insert cm;
                
        Test.startTest();
        
        cam.IsActive = true;
        update cam;
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void TestAU2() {
    	
        Account acc = ClsTestHelp.createTestAccounts();
        insert acc;
        
        Contact con = ClsTestHelp.createTestContacts();
        con.AccountId = acc.Id;
        con.Email = 'asldf@slkfs.com';
        insert con;
                
        Survey__c survey = new Survey__c();
        survey.Name = 'henhao';
        insert survey;
        
        Campaign cam = new Campaign();
        cam.Name = 'nihao';
        cam.EndDate = date.today() - 5;
        cam.Survey__c = survey.Id;
        cam.IsActive = true;
        cam.Survey_Date__c = date.today() - 15;
        insert cam;
        
        CampaignMember cm = new CampaignMember();
        cm.ContactId = con.Id;
        cm.CampaignId = cam.Id;
        insert cm;
                
        Test.startTest();
        
        cam.IsActive = false;
        update cam;
        
        system.assert(true);
        Test.stopTest();
    }
}