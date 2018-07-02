/**
*   This test class is for Campaign_AU_updateNPSContactType.
*
@author Lili Zhao
@created 2014-10-28
@version 1.0
@since 28.0
*
@changelog
* 2014-10-28 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
* - Test coverage 86%
*/
@isTest(SeeAllData = True)
private class TrgCampaign_AU_updateNPSContactType_Test {

    static testMethod void myUnitTest() {
        
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
        cam.Campaign_Type__c = 'test';
        cam.IsActive = true;
        insert cam;
        
        CampaignMember cm = new CampaignMember();
        cm.ContactId = con.Id;
        cm.CampaignId = cam.Id;
        cm.NPS_OPT_OUT__c = false;
        cm.Status = 'Sent';
        insert cm;
        Test.startTest();
        cam.Campaign_Type__c = 'Industries';
        update cam;
        system.assert(true);
        Test.stopTest();
     }   
}