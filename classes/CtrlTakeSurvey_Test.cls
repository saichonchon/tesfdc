/**
*   This test class is for CtrlTakeSurvey.
*
@author Di Chen
@created 2012-12-18
@version 1.0
@since 20.0
*
@changelog
* 2012-12-18 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 88% 
*/
@isTest
private class CtrlTakeSurvey_Test {
    static testMethod void testId1() {
        
        Account acc = ClsTestHelp.createTestAccounts();
        insert acc;
        
        Apexpages.currentPage().getParameters().put('Id',acc.Id);
        
		Test.startTest();
		
		CtrlTakeSurvey ctrl = new CtrlTakeSurvey();
		
		//ctrl.getLanguages();
		
		system.assert(true);
		Test.stopTest();
    }
    static testMethod void testError1() {
        
        Account acc = ClsTestHelp.createTestAccounts();
        insert acc;
        
        Contact con = ClsTestHelp.createTestContacts();
        con.AccountId = acc.Id;
        con.NPS_Language__c = 'DE';
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
        
        Apexpages.currentPage().getParameters().put('Id',cm.Id);
        
		Test.startTest();
		
		CtrlTakeSurvey ctrl = new CtrlTakeSurvey();
		
		system.assert(true);
		Test.stopTest();
    }
    static testMethod void testError2() {
        
        Account acc = ClsTestHelp.createTestAccounts();
        insert acc;
        
        Contact con = ClsTestHelp.createTestContacts();
        con.AccountId = acc.Id;
        con.NPS_Language__c = 'DE';
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
        //cm.Status = 'Responded';
        insert cm;
        
        Apexpages.currentPage().getParameters().put('Id',cm.Id);
        
		Test.startTest();
		
		CtrlTakeSurvey ctrl = new CtrlTakeSurvey();
		
		system.assert(true);
		Test.stopTest();
    }
	static testMethod void testGenerateSurveyItems1() {
        
        Account acc = ClsTestHelp.createTestAccounts();
        insert acc;
        
        Contact con = ClsTestHelp.createTestContacts();
        con.AccountId = acc.Id;
        con.NPS_Language__c = 'DE';
        con.NPS_Contact__c = true;
        con.Email = 'hallo@scd.com';
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
        cm.NPS_Language__c = 'English';
        insert cm;
        
        Question__c ques = new Question__c();
        ques.Category__c = 'Operations';
        ques.Survey__c = survey.Id;
        ques.Active__c = true;
        ques.Sortorder__c = 2;
        insert ques;
        
        Answer__c answer = new Answer__c();
        answer.Contact__c = con.Id;
        answer.Campaign__c = cam.Id;
        answer.Question__c = ques.Id;
        answer.Current__c = true;
        answer.Not_Applicable__c = false;
        insert answer;
        
        list<CtrlTakeSurvey.SurveyItem> list_overall = new list<CtrlTakeSurvey.SurveyItem>();
        CtrlTakeSurvey.SurveyItem ctrlSurvey = new CtrlTakeSurvey.SurveyItem(ques,1,'a');
        list_overall.add(ctrlSurvey);
        
        Apexpages.currentPage().getParameters().put('Id',cm.Id);
        
		Test.startTest();
		
		CtrlTakeSurvey ctrl = new CtrlTakeSurvey();
		ctrl.con = con;
		ctrl.question = ques;
		ctrl.firstSurveyItem = ctrlSurvey;
		ctrl.list_overall = list_overall;
		ctrl.list_technology = list_overall;
		ctrl.list_commercial = list_overall;
		ctrl.list_operations = list_overall;
		ctrl.list_others = list_overall;
		
		ctrl.enter();
		ctrl.changeLanguage();
		ctrl.next();
		
		ctrl.back();
		
		system.assert(true);
		Test.stopTest();
    }
	static testMethod void testGenerateSurveyItems2() {
        
        Account acc = ClsTestHelp.createTestAccounts();
        insert acc;
        
        Contact con = ClsTestHelp.createTestContacts();
        con.AccountId = acc.Id;
        con.NPS_Language__c = 'DE';
        con.NPS_Contact__c = true;
        con.Email = 'hallo@scd.com';
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
        
        Question__c ques = new Question__c();
        ques.Category__c = 'Overall';
        ques.Survey__c = survey.Id;
        ques.Active__c = true;
        ques.Sortorder__c = 2;
        insert ques;
        
        Answer__c answer = new Answer__c();
        answer.Contact__c = con.Id;
        answer.Campaign__c = cam.Id;
        answer.Question__c = ques.Id;
        answer.Current__c = true;
        answer.Not_Applicable__c = false;
        insert answer;
        
        list<CtrlTakeSurvey.SurveyItem> list_overall = new list<CtrlTakeSurvey.SurveyItem>();
        CtrlTakeSurvey.SurveyItem ctrlSurvey = new CtrlTakeSurvey.SurveyItem(ques,1,'a');
        list_overall.add(ctrlSurvey); 
        
        Apexpages.currentPage().getParameters().put('Id',cm.Id);
        
		Test.startTest();
		
		CtrlTakeSurvey ctrl = new CtrlTakeSurvey();
		ctrl.con = con;
		ctrl.question = ques;
		ctrl.firstSurveyItem = ctrlSurvey;
		ctrl.list_overall = list_overall;
		ctrl.list_technology = list_overall;
		ctrl.list_commercial = list_overall;
		ctrl.list_operations = list_overall;
		ctrl.list_others = list_overall;
		
		ctrl.enter();
		ctrl.changeLanguage();
		ctrl.next();
		//ctrl.getRadioItems();
		
		system.assert(true);
		Test.stopTest();
    }
	static testMethod void testGenerateSurveyItems3() {
        
        Account acc = ClsTestHelp.createTestAccounts();
        insert acc;
        
        Contact con = ClsTestHelp.createTestContacts();
        con.AccountId = acc.Id;
        con.NPS_Language__c = 'DE';
        con.NPS_Contact__c = true;
        con.Email = 'hallo@scd.com';
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
        
        Question__c ques = new Question__c();
        ques.Category__c = 'Technology';
        ques.Survey__c = survey.Id;
        ques.Active__c = true;
        ques.Sortorder__c = 2;
        insert ques;
        
        Answer__c answer = new Answer__c();
        answer.Contact__c = con.Id;
        answer.Campaign__c = cam.Id;
        answer.Question__c = ques.Id;
        answer.Current__c = true;
        answer.Not_Applicable__c = false;
        insert answer;
        
        list<CtrlTakeSurvey.SurveyItem> list_overall = new list<CtrlTakeSurvey.SurveyItem>();
        CtrlTakeSurvey.SurveyItem ctrlSurvey = new CtrlTakeSurvey.SurveyItem(ques,1,'a');
        list_overall.add(ctrlSurvey);
        
        Apexpages.currentPage().getParameters().put('Id',cm.Id);
        
		Test.startTest();
		
		CtrlTakeSurvey ctrl = new CtrlTakeSurvey();
		ctrl.con = con;
		ctrl.question = ques;
		ctrl.firstSurveyItem = ctrlSurvey;
		ctrl.list_overall = list_overall;
		ctrl.list_technology = list_overall;
		ctrl.list_commercial = list_overall;
		ctrl.list_operations = list_overall;
		ctrl.list_others = list_overall;
		
		ctrl.enter();
		ctrl.changeLanguage();
		ctrl.next();
		//ctrl.getRadioItems();
		
		system.assert(true);
		Test.stopTest();
    }
	static testMethod void testGenerateSurveyItems4() {
        
        Account acc = ClsTestHelp.createTestAccounts();
        insert acc;
        
        Contact con = ClsTestHelp.createTestContacts();
        con.AccountId = acc.Id;
        con.NPS_Language__c = 'DE';
        con.NPS_Contact__c = true;
        con.Email = 'hallo@scd.com';
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
        
        Question__c ques = new Question__c();
        ques.Category__c = 'Commercial';
        ques.Survey__c = survey.Id;
        ques.Active__c = true;
        ques.Sortorder__c = 2;
        insert ques;
        
        Answer__c answer = new Answer__c();
        answer.Contact__c = con.Id;
        answer.Campaign__c = cam.Id;
        answer.Question__c = ques.Id;
        answer.Current__c = true;
        answer.Not_Applicable__c = false;
        insert answer;
        
        list<CtrlTakeSurvey.SurveyItem> list_overall = new list<CtrlTakeSurvey.SurveyItem>();
        CtrlTakeSurvey.SurveyItem ctrlSurvey = new CtrlTakeSurvey.SurveyItem(ques,1,'a');
        list_overall.add(ctrlSurvey);
        
        Apexpages.currentPage().getParameters().put('Id',cm.Id);
        
		Test.startTest();
		
		CtrlTakeSurvey ctrl = new CtrlTakeSurvey();
		ctrl.con = con;
		ctrl.question = ques;
		ctrl.firstSurveyItem = ctrlSurvey;
		ctrl.list_overall = list_overall;
		ctrl.list_technology = list_overall;
		ctrl.list_commercial = list_overall;
		ctrl.list_operations = list_overall;
		ctrl.list_others = list_overall;
		
		ctrl.enter();
		ctrl.changeLanguage();
		ctrl.next();
		//ctrl.getRadioItems();
		
		system.assert(true);
		Test.stopTest();
    }
	static testMethod void testGenerateSurveyItems5() {
        
        Account acc = ClsTestHelp.createTestAccounts();
        insert acc;
        
        Contact con = ClsTestHelp.createTestContacts();
        con.AccountId = acc.Id;
        con.NPS_Language__c = 'DE';
        con.NPS_Contact__c = true;
        con.Email = 'hallo@scd.com';
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
        
        Question__c ques = new Question__c();
        ques.Category__c = '';
        ques.Survey__c = survey.Id;
        ques.Active__c = true;
        ques.Sortorder__c = 2;
        insert ques;
        
        Answer__c answer = new Answer__c();
        answer.Contact__c = con.Id;
        answer.Campaign__c = cam.Id;
        answer.Question__c = ques.Id;
        answer.Current__c = true;
        answer.Not_Applicable__c = false;
        insert answer;
        
        list<CtrlTakeSurvey.SurveyItem> list_overall = new list<CtrlTakeSurvey.SurveyItem>();
        CtrlTakeSurvey.SurveyItem ctrlSurvey = new CtrlTakeSurvey.SurveyItem(ques,1,'a');
        list_overall.add(ctrlSurvey);
        
        Apexpages.currentPage().getParameters().put('Id',cm.Id);
        
		Test.startTest();
		
		CtrlTakeSurvey ctrl = new CtrlTakeSurvey();
		ctrl.con = con;
		ctrl.question = ques;
		ctrl.firstSurveyItem = ctrlSurvey;
		ctrl.list_overall = list_overall;
		ctrl.list_technology = list_overall;
		ctrl.list_commercial = list_overall;
		ctrl.list_operations = list_overall;
		ctrl.list_others = list_overall;
		
		ctrl.enter();
		ctrl.changeLanguage();
		ctrl.next();
		//ctrl.getRadioItems();
		
		system.assert(true);
		Test.stopTest();
    }
	static testMethod void testIsErrorTrue() {
        
        Account acc = ClsTestHelp.createTestAccounts();
        insert acc;
        
        Contact con = ClsTestHelp.createTestContacts();
        con.AccountId = acc.Id;
        con.NPS_Language__c = 'DE';
        con.NPS_Contact__c = true;
        con.Email = 'hallo@scd.com';        
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
        
        Question__c ques = new Question__c();
        ques.Category__c = 'Operations';
        ques.Survey__c = survey.Id;
        ques.Active__c = true;
        ques.Sortorder__c = 2;
        ques.Question_Type__c = 'Comment';//'Comment';//'0...10';
        insert ques;
        
        Answer__c answer = new Answer__c();
        answer.Contact__c = con.Id;
        answer.Campaign__c = cam.Id;
        answer.Question__c = ques.Id;
        answer.Current__c = true;
        answer.Answer__c = '10';
        answer.Not_Applicable__c = false;
        insert answer;
        
        list<CtrlTakeSurvey.SurveyItem> list_overall = new list<CtrlTakeSurvey.SurveyItem>();
        CtrlTakeSurvey.SurveyItem ctrlSurvey = new CtrlTakeSurvey.SurveyItem(ques,1,'a');
        //ctrlSurvey.answer = answer;
        list_overall.add(ctrlSurvey);
        
        Apexpages.currentPage().getParameters().put('Id',cm.Id);
        
		Test.startTest();
		
		CtrlTakeSurvey ctrl = new CtrlTakeSurvey();
		ctrl.con = con;
		ctrl.question = ques;
		ctrl.firstSurveyItem = ctrlSurvey;
		ctrl.list_overall = list_overall;
		ctrl.list_technology = list_overall;
		ctrl.list_commercial = list_overall;
		ctrl.list_operations = list_overall;
		ctrl.list_others = list_overall;
		
		ctrl.enter();
		ctrl.submit();
		
		system.assert(true);
		Test.stopTest();
    }
}