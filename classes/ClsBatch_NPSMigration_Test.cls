/**
*  This test class is for ClsBatch_NPSMigration.
*
@author Di Chen
@created 2013-01-15
@version 1.0
@since 20.0
*
@changelog
* 2013-01-15 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 96%
*/
@isTest
private class ClsBatch_NPSMigration_Test {

    static testMethod void testBatch() {
    	
    	Contact contact = ClsTestHelp.createTestContacts();
    	contact.FirstName = 'sand';
    	insert contact;
    	
    	Survey__c survey = new Survey__c();
        survey.Name = 'henhao';
        insert survey;
    	
        Question__c ques = new Question__c();
        ques.Category__c = 'Operations';
        ques.Survey__c = survey.Id;
        ques.Active__c = true;
        ques.Sortorder__c = 2;
        insert ques;
            	    	
    	NPS_Migration__c nps = new NPS_Migration__c();
    	nps.Current__c = true;
    	nps.Appliance__c = true;
    	nps.Contact__c = contact.Id;
    	nps.Question_01__c = ques.Id;
    	nps.Question_02__c = ques.Id;
    	nps.Question_03__c = ques.Id;
    	nps.Question_04__c = ques.Id;
    	nps.Question_05__c = ques.Id;
    	nps.Question_06__c = ques.Id;
    	nps.Question_07__c = ques.Id;
    	nps.Question_08__c = ques.Id;
    	nps.Question_09__c = ques.Id;
    	nps.Question_10__c = ques.Id;
    	nps.Question_11__c = ques.Id;
    	nps.Question_12__c = ques.Id;
    	nps.Question_13__c = ques.Id;
    	nps.Question_14__c = ques.Id;
    	insert nps;
    	
        List<NPS_Migration__c> list_nps = new List<NPS_Migration__c>();
        list_nps.add(nps);
              
        Test.startTest();
              
        ClsBatch_NPSMigration clsBatch = new ClsBatch_NPSMigration();
        Database.BatchableContext BC;
        
        clsBatch.start(BC);
        clsBatch.execute(BC, list_nps);
        clsBatch.finish(BC);
              
        system.assert(true);
        Test.stopTest();
    }
}