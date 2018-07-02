/***********************************************************************************************************************
 Name: CustomerSupportSurveyTrigger_Test
 Org : C2S
 Copyright : © 2015 TE Connectivity 
========================================================================================================================
 Summary : Test class for Trigger CustomerSupportSurveyTrigger and CustomerSupportSurveyTriggerHandler,CustomerSupportSurveyTriggerUtils classes
 -----------------------------------------------------------------------------------------------------------------------
 VERSION  AUTHOR              DATE              DETAIL                              
 -----------------------------------------------------------------------------------------------------------------------
   1.0   Rajendra Shahane            04/08/2016        Initial Development CustomerSupportSurveyTrigger_Test
***********************************************************************************************************************/ 
@isTest(SeeAllData=false)
public class CustomerSupportSurveyTrigger_Test
{

    public testMethod static void TestCustomerSupportSurveyTrigger() 
    {
        ClsTestCustomSettingHelper.getCCPTriggerSettings();
        ClsTestCustomSettingHelper.getApex_Helper_Settings(); 
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getCaseFinalVariables();        
        ClsTestCustomSettingHelper.getWebToCaseStrings();
        
        //get PIC record Type
        Id vCasePICRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('TE PIC Standard Case Record Type').getRecordTypeId();
        Id vAccountRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        test.startTest();
        Account vAccount;
        vAccount = new Account();
        vAccount.Name = 'Test Pic acc2';
        vAccount.Legally_Restricted__c = true; 
        vAccount.BillingCity = 'Beijing';  
        vAccount.BillingCountry = 'Ch';
        vAccount.BillingState = '000001';
        vAccount.BillingStreet = 'Tiananmen';
        vAccount.BillingPostalCode = '200000';
        vAccount.Account_Manager__c = userinfo.getUserId();
        vAccount.RecordTypeId=vAccountRT;
        insert vAccount;
        
        contact con = new Contact();
        con.email='testpiic@org.com';
        con.lastName='TestCon';
        con.accountid=vAccount.id;
        insert con;
        
        //PIC Case
        Case vCs = new Case();
        vCs.subject ='testing';
        vCs.Origin = 'PIC US Email';    
        vCs.Status= 'New';
        vCs.Description = 'Test Description';
        vCs.ownerId = userinfo.getUserId();
        vCs.contactId=con.id;
        vCs.Case_Closed_By__c=userinfo.getUserId();
        vCs.RecordTypeid = vCasePICRT;         
        insert vCs;
        
        insert new Customer_Support_Survey__c(Case__c = vcs.Id);
        test.stopTest();
    }
}