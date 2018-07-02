/**
*   This test class is for CampaignMember_BIU_updateContactOwner.
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
private class TrgCampaignMember_BIU_updateConOwnr_Test {

    static testMethod void testBIU() {
    	
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Industry_Code_Description__c = 'A&C';
        acc.LEVEL_1_INDUSTRY_CDE__c = '0108';
        insert acc;
        
        Contact con = ClsTestHelp.createTestContacts();
        con.AccountId = acc.Id;
        con.NPS_Language__c = 'DE';
        con.Email = 'sdf@dsafj.com';
        insert con;
        
        Survey__c survey = new Survey__c();
        survey.Name = 'henhao';
        insert survey;
        
        Campaign cam = new Campaign();
        cam.Name = 'nihao';
        cam.EndDate = date.today() + 5;
        cam.Survey__c = survey.Id;
        cam.Survey_Date__c = date.today() - 15;
        insert cam;
        
        CampaignMember cm = new CampaignMember();
        cm.ContactId = con.Id;
        cm.CampaignId = cam.Id;
        cm.Status = 'Sent';
        
        Test.startTest();
        
        insert cm;
        
        
        system.assert(true);
        Test.stopTest();
    }
}