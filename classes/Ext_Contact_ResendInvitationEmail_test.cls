/**
*  This test class used to test class ExtRecalculateBudget.
*
@author Lili Zhao
@created 2013-09-13
@version 1.0   
@since 28.0
*
@changelog
* coverage 77% 
* 
* 
2013-09-13 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest(seeAllData = true) 
private class Ext_Contact_ResendInvitationEmail_test {

    static testMethod void myUnitTest() {
        test.startTest();           
        Contact contact=ClsTestHelp.createTestContacts();
        
        insert contact;
        
        //Added by Bhavya to cover Contact_AU_changeSubReportsTo trigger
        Contact contact1=ClsTestHelp.createTestContacts();       
        insert contact1;
        
        Contact contact2=ClsTestHelp.createTestContacts();
        contact2.Inactive__c=false;
        insert contact2;
        contact2.ReportsToId=contact1.id;
        update contact2;
        
        Contact contact3=ClsTestHelp.createTestContacts();
        insert contact3;
        contact3.ReportsToId=contact2.id;
        update contact3;
        
        contact1.Inactive__c=true;
        update contact1;
       
        Contact contact4=ClsTestHelp.createTestContacts();
        insert contact4;
        contact4.ReportsToId=contact1.id;
        update contact4;
        //     
        Survey__c survey = new Survey__c();
        survey.name = 'testSurvey';
        insert survey;
        
        Campaign campaign = new Campaign();
        campaign.Name = 'testCamNam';
        campaign.Survey__c = survey.Id;
        campaign.Survey_Date__c = Date.valueOf('2013-2-15');
        campaign.StartDate = Date.today();
        campaign.IsActive = true;
        campaign.EndDate = Date.valueOf('2999-12-15');
        insert campaign;
        
        CampaignMember campaignMember = new CampaignMember();
        campaignMember.CampaignId = campaign.Id;
        campaignMember.ContactId = contact.Id;
        insert campaignMember;
        
        contact.Campaign_Member_ID__c = campaignMember.Id;

        ApexPages.StandardController stdCtl = new ApexPages.StandardController(contact);   
        Ext_Contact_ResendInvitationEmail ext = new Ext_Contact_ResendInvitationEmail(stdCtl);
        ext.sendEmail(); 
        ext.returnContactView();
                
        test.stopTest();
    }
}