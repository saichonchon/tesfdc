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
private class ClsContactUtil_Test {

    static testMethod void myUnitTest() {
        test.startTest();    
        // insert the custom setting before insert account begin
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        
        Consumer_Device_Opportunity_Record_Types__c cusetting1 = ClsTestHelp.createTestCSD7();
        Consumer_Device_Opportunity_Record_Types__c cusetting2 = ClsTestHelp.createTestCSD3();
        Consumer_Device_Opportunity_Record_Types__c cusetting3 = ClsTestHelp.createTestCSD1();
        // insert the custom setting before insert account end
                   
        Account account = ClsTestHelp.createTestAccounts();
        account.GAMCD__c = 'test';
        insert account;
        
        Account accountGAM = ClsTestHelp.createTestAccounts();
        accountGAM.GAMCD__c = 'test';
        accountGAM.NPS_Score__c = 2;
        accountGAM.Type = 'Global Account';
        insert accountGAM;
        
         // insert the custom setting before insert contact begin
        Profile p2 = [Select Id, Name From Profile where Name ='Customer Care Service Cloud' limit 1];
        Apex_Helper_Settings__c ahs = new Apex_Helper_Settings__c();
        for(Apex_Helper_Settings__c ahs2 : [select Id,Value__c from Apex_Helper_Settings__c where Name = 'Customer Care Service Cloud' limit 1]){
            ahs = ahs2;
        }
        if(ahs.Value__c == null){
            ahs.Name = 'Customer Care Service Cloud';
            ahs.Value__c = p2.Id;
            insert ahs;
        }
        // insert the custom setting before insert contact end
        
        Contact contact1  = ClsTestHelp.createTestContacts();
        contact1.AccountId = account.Id;    
        contact1.Survey_Attended_Date__c = Date.valueOf('2013-11-21');
        insert contact1;
        
        Contact contact2  = ClsTestHelp.createTestContacts();
        contact2.AccountId = account.Id;    
        contact2.Survey_Attended_Date__c = Date.valueOf('2013-10-21');
        insert contact2;
        
        Survey__c survey = new Survey__c();
        survey.Name = 'henhao';
        insert survey;
        
        Question__c ques = new Question__c();
        ques.Category__c = 'Overall';
        ques.Name = '01test';
        ques.Active__c = true;
        ques.Survey__c = survey.Id;
        ques.Sortorder__c = 2;
        insert ques;
        
        Answer__c answer = new Answer__c();
        answer.Answer__c = '2';
        answer.Contact__c = contact1.Id;
        answer.Current__c = true;
        answer.Question__c = ques.Id;
        answer.answer_date__c = System.Today();
        insert answer;
        
        Answer__c answer1 = new Answer__c();
        answer1.Answer__c = '4';
        answer1.Contact__c = contact2.Id;
        answer1.Current__c = true;
        answer1.Question__c = ques.Id;
        answer1.answer_date__c = System.Today();
        insert answer1;
        
        String targetObjectId = contact1.Id;  
        String name = 'testName';
        String language;
        ClsContactUtil.contactSendEmail(targetObjectId, name, language);
        ClsContactUtil.contactSendEmail(targetObjectId, name, 'CN');
        ClsContactUtil.contactSendEmail(targetObjectId, name, 'CN_SIMPL');
        ClsContactUtil.contactSendEmail(targetObjectId, name, 'DE');
        ClsContactUtil.contactSendEmail(targetObjectId, name, 'EN');
        ClsContactUtil.contactSendEmail(targetObjectId, name, 'ES');
        ClsContactUtil.contactSendEmail(targetObjectId, name, 'FR');
        ClsContactUtil.contactSendEmail(targetObjectId, name, 'IT');
        ClsContactUtil.contactSendEmail(targetObjectId, name, 'JP');
        ClsContactUtil.contactSendEmail(targetObjectId, name, 'KR');
        ClsContactUtil.contactSendEmail(targetObjectId, name, 'PT');
        ClsContactUtil.contactSendEmail(targetObjectId, name, 'RU');
        
        set<String> set_accountIds = new set<String>();
        set<String> set_gamcd = new set<String>();
        set_accountIds.add(account.Id);
        set_accountIds.add(accountGAM.Id);
        set_gamcd.add('test');
        ClsContactUtil.AVGForAccountNPSScoreOnContact(set_accountIds);
        ClsContactUtil.calculateAllAccountNPSScoreOnContact(set_accountIds);
        ClsContactUtil.calculateAllAccountGAMNPSScoreOnContact(set_gamcd);
        test.stopTest();      
    }
}