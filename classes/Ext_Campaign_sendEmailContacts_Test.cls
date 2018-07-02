/**
*  This test class used to test class ExtRecalculateBudget.
*
@author Lili Zhao
@created 2013-09-13
@version 1.0   
@since 28.0
*
@changelog
* coverage 85% 
* 
* 
2013-09-13 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest(seeAllData = true) 
private class Ext_Campaign_sendEmailContacts_Test {

    static testMethod void myUnitTest() {
        test.startTest();  
         	
		Contact contact=ClsTestHelp.createTestContacts();
		contact.NPS_Language__c = 'CN';
		insert contact;
		
		Survey__c survey = new Survey__c();
		survey.name = 'testSurvey';
		insert survey;
		
		Campaign campaign = new Campaign();
		campaign.Name = 'testCamNam';
		campaign.Survey__c = survey.Id;
		campaign.Survey_Date__c = Date.valueOf('2013-2-15');
		campaign.StartDate = Date.today();
		campaign.IsActive = true;
		campaign.EndDate = Date.today();
		insert campaign;
		
		CampaignMember campaignMember = new CampaignMember();
		campaignMember.CampaignId = campaign.Id;
		campaignMember.ContactId = contact.Id;
		campaignMember.Status = 'send';
		insert campaignMember;		
		
		ApexPages.StandardController stdCtl = new ApexPages.StandardController(campaign);   
		Ext_Campaign_sendEmailContacts ext = new Ext_Campaign_sendEmailContacts(stdCtl);
		ext.sendEmail(); 
		ext.returnCampaignView();
		test.stopTest();
    }
}