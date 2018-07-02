/**
*  This class test class for clsBatch_CalculateSurveyScore.
*
@author Pankaj Raijade
@created 4/2/2015
@version 1.0   
@since 33.0
*
@changelog
* coverage  93%
* 
* 
4/2/2015 Pankaj Raijade pankaj.raijade@zensar.in
* - Created
Rajendra Shahane 03/29/2016  Modified for case - 900703
*/
@isTest(seeAllData=false)
public class clsBatch_CalculateSurveyScore_Test
{
    static testmethod void clsBatch_CalculateSurveyScore_TM()
    {
        Survey_Question_field_mappings__c os1 = new Survey_Question_field_mappings__c(name = 'test1', Object__c = 'Account', Survey_Name__c = 'NPS Survey', Survey_Question__c = '1. Over all score', Survey_Score_Field__c = 'NPS_Overall_Score__c');
        //insert os1;
        Survey_Question_field_mappings__c os2 = new Survey_Question_field_mappings__c(name = 'test2', Object__c = 'Account', Survey_Name__c = 'NPS Survey', Survey_Question__c = 'NPS_Engineering_Responsiveness__c', Survey_Score_Field__c = 'NPS_Engineering_Responsiveness__c');
        //insert os2;
        Survey_Question_field_mappings__c os3 = new Survey_Question_field_mappings__c(name = 'test3', Object__c = 'Account', Survey_Name__c = 'NPS Survey', Survey_Question__c = 'NPS_Field_Tech_Support__c', Survey_Score_Field__c = 'NPS_Field_Tech_Support__c');
        //insert os3;
        insert new list<Survey_Question_field_mappings__c>{os1,os2,os3};
        Batch_Email_message_Users__c oBatch_Email_message_Users = new Batch_Email_message_Users__c(name = 'Error_clsBatch_CalculateSurveyScore', email_ID__c = 'test@test.test');
        insert oBatch_Email_message_Users;
        
        Time_frame_Setting__c oTFS = new Time_frame_Setting__c(Name = 'ACCOUNT_SURVEY', Period__c = 60, Period_Type__c = 'MONTH');
        insert oTFS;

        //Start: Rajendra Shahane Modified for case - 900703
        ClsTestCustomSettingHelper.getCCPTriggerSettings();
        //End: Rajendra Shahane Modified for case - 900703       
         
        List<Apex_Helper_Settings__c> lstApex_Helper_Settings = new List<Apex_Helper_Settings__c>();
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'System Admin Profile Id', Value__c = ''));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Service Account Profile Id', Value__c = ''));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'TEIS Admin User Id', Value__c = ''));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Account Record Type Id', Value__c = ''));        
        insert lstApex_Helper_Settings;
        
        list<Consumer_Device_Opportunity_Record_Types__c> lstConsumer_Device_Opportunity_Record_Types = new list<Consumer_Device_Opportunity_Record_Types__c>();
        lstConsumer_Device_Opportunity_Record_Types.add(new Consumer_Device_Opportunity_Record_Types__c(name = 'OEM', Record_Type_Id__c = Schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('NDR Opportunity').getRecordTypeId()));
        lstConsumer_Device_Opportunity_Record_Types.add(new Consumer_Device_Opportunity_Record_Types__c(name = 'Sales Opportunity-CSD', Record_Type_Id__c = Schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('NDR Opportunity').getRecordTypeId()));
        lstConsumer_Device_Opportunity_Record_Types.add(new Consumer_Device_Opportunity_Record_Types__c(name = 'Engineering Opportunity-CSD', Record_Type_Id__c = Schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('NDR Opportunity').getRecordTypeId()));
        
        insert lstConsumer_Device_Opportunity_Record_Types;
        
        
        Survey__c oSurvey = new Survey__c(Name = 'NPS Survey');
        insert oSurvey;
        
        Question__c oQuestion = new Question__c(Survey__c = oSurvey.id, Active__c = true, Name = '1. Over all score', Question_Type__c = '0...10');
        //insert oQuestion;
        
        Question__c oQuestion2 = new Question__c(Survey__c = oSurvey.id, Active__c = true, Name = 'NPS_Engineering_Responsiveness__c', Question_Type__c = '0...10');
        //insert oQuestion2;
        insert new list<Question__c >{oQuestion, oQuestion2};
        
        list<Account> lstAccount = new list<account>();
        Account oAccount = new Account(name = 'testaccount', BillingCountry = 'US');
        lstAccount.add(oAccount);
        Account oAccount2 = new Account(name = 'testaccount', BillingCountry = 'US');
        lstAccount.add(oAccount2);
        insert lstAccount;
        
        Campaign oCampaign = new campaign(name = 'test', Survey_Date__c = date.today().addDays(-100));
        insert oCampaign;
        
        Contact oContact = new contact(accountid = oAccount.Id, lastname = 'testcontact');
        insert oContact;
        
        Answer__c oAnswer = new Answer__c(Current__c = true, contact__c = oContact.Id, Answer__c = '2', Question__c = oQuestion.Id, Campaign__c = oCampaign.Id);
        //insert oAnswer;
        Answer__c oAnswer2 = new Answer__c(Current__c = true, contact__c = oContact.Id, Answer__c = '2', Question__c = oQuestion2.Id, Campaign__c = oCampaign.Id);
        //insert oAnswer2;
        insert new list<Answer__c>{oAnswer, oAnswer2};
        
        //system.debug('asdf'+[SELECT Question__r.Question_Type__c, survey_date__c, Contact__r.accountid,  Survey_Name_Survey_Question__c FROM Answer__c]);
        test.starttest();
            clsBatch_CalculateSurveyScore o = new clsBatch_CalculateSurveyScore();
            o.mapError.put(oAccount.Id, 'test');
            database.executeBatch(o);
            oTFS = new Time_frame_Setting__c(Id = oTFS.ID, Name = 'ACCOUNT_SURVEY', Period__c = 60, Period_Type__c = 'DAY');
            update oTFS;
            o = new clsBatch_CalculateSurveyScore();
            oTFS = new Time_frame_Setting__c(Id = oTFS.ID, Name = 'ACCOUNT_SURVEY', Period__c = 60, Period_Type__c = 'YEAR');
            update oTFS;
            o = new clsBatch_CalculateSurveyScore();
            
            o.Query = 'select id, NPS_Business_Understanding__c, NPS_Competitive_Price__c, NPS_Customer_Care_Support__c, NPS_Delivery_Performance__c, NPS_Engineering_Responsiveness__c, NPS_Field_Tech_Support__c, NPS_Overall_Score__c, NPS_Product_Innovation__c, NPS_Product_Quality__c, NPS_Technology_needs_met__c from account';
            database.executeBatch(o);
             o = new clsBatch_CalculateSurveyScore(date.today());
            database.executeBatch(o);
        test.stoptest();
    }
}