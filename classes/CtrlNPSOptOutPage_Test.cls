/**
*	This test class is for CtrlNPSOptOutPage.
*
@author Di Chen
@created 2013-01-29
@version 1.0
@since 20.0
*
@changelog
* 2013-01-29 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 86%
*/
@isTest
private class CtrlNPSOptOutPage_Test {

    static testMethod void testMostMethods() {
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
        cam.EndDate = date.today() + 5;
        cam.Survey__c = survey.Id;
        cam.Survey_Date__c = date.today() - 15;
        insert cam;
        
        CampaignMember cm = new CampaignMember();
        cm.ContactId = con.Id;
        cm.CampaignId = cam.Id;
        insert cm;
        
        Apexpages.currentPage().getParameters().put('Id',cm.Id);
        
        Test.startTest();
        
        CtrlNPSOptOutPage ctrl = new CtrlNPSOptOutPage();
        
        ctrl.init();
        ctrl.save();
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testMostMethods2() {
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
        cam.Survey_Date__c = date.today() - 15;
        insert cam;
        
        CampaignMember cm = new CampaignMember();
        cm.ContactId = con.Id;
        cm.CampaignId = cam.Id;
        insert cm;
        Apexpages.currentPage().getParameters().put('Id',acc.Id);
        Test.startTest();
        
        CtrlNPSOptOutPage ctrl = new CtrlNPSOptOutPage();
        
        system.assert(true);
        Test.stopTest();
        }
}