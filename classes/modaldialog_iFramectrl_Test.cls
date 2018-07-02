/**
* This test class is for modaldialog_iFramectrl.
*
@author Prabhanjan N <prabhanjan.nandyala@zensar.in>
@created 12/8/2014
@version 1.0 
*
@changelog
* 12/4/2016 Prabhanjan N <prabhanjan.nandyala@zensar.in>
* - Added new line for the method onload() 
* - removed seealldata=true and used ClsTestCustomSettingHelper methods to create custom settings.
*/


@isTest

public class modaldialog_iFramectrl_Test {
    
    
    
    
    public static testMethod void modaldialog_iFramectrl_Test1() {
        ClsTestCustomSettingHelper.getApex_Helper_Settings(); 
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ChannelinsightData_test.ChannelinsightData_test();

        Date TODAY = System.today();
        //Account accone1 = new Account();
        Account accone1 =ClsTestHelp.createTestAccounts();
        
        insert accone1 ;
        
        Pop_Up_Alert__c popone = new Pop_Up_Alert__c();
        popone.Account__c = accone1.id;
        popone.Start_Date__c = TODAY -2;
        popone.End_Date__c = TODAY + 2;
        popone.Message__c = 'Test Always';
        insert popone;
        
        Pop_Up_Alert_Confirmation__c popConOne = new Pop_Up_Alert_Confirmation__c();
        popConOne.Pop_Up_Alerts__c = popone.id;
        popConOne.user__C = userinfo.getUserId();
        insert popConOne;
        
        test.startTest();
        PageReference pageRef = Page.modaldialog_iframe;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',accone1.id);
        
        modaldialog_iFramectrl controller = new modaldialog_iFramectrl();
        controller.userPref();
        
        test.stopTest(); 
    }
    public static testMethod void modaldialog_iFramectrl_Test2() {
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ChannelinsightData_test.ChannelinsightData_test();

        Date TODAY = System.today();
        //Account accone1 = new Account();
        Account accone1 =ClsTestHelp.createTestAccounts();
        
        insert accone1 ;
        
        contact cont1 =ClsTestHelp.createTestContacts();
        cont1.accountid=accone1.id;
        insert cont1;
        
        Pop_Up_Alert__c popone = new Pop_Up_Alert__c();
        popone.Account__c = accone1.id;
        popone.Start_Date__c = TODAY -2;
        popone.End_Date__c = TODAY + 2;
        popone.Message__c = 'Test Always';
        insert popone;
        
        Pop_Up_Alert_Confirmation__c popConOne = new Pop_Up_Alert_Confirmation__c();
        popConOne.Pop_Up_Alerts__c = popone.id;
        popConOne.user__C = userinfo.getUserId();
        insert popConOne;
        
        test.startTest();
        PageReference pageRef = Page.modaldialog_iframe;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',cont1.id);
        
        modaldialog_iFramectrl controller = new modaldialog_iFramectrl();
        controller.onload();
        controller.userPref();
        
        test.stopTest(); 
    }
    public static testMethod void modaldialog_iFramectrl_Test3() {
        ClsTestCustomSettingHelper.getApex_Helper_Settings(); 
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ChannelinsightData_test.ChannelinsightData_test();
        
        Date TODAY = System.today();
        //Account accone1 = new Account();
        Account accone1 =ClsTestHelp.createTestAccounts();
        
        insert accone1 ;
        
        contact cont1 =ClsTestHelp.createTestContacts();
        cont1.accountid=accone1.id;
        insert cont1;
        
        case case1 = new case();
        case1.accountid=accone1.id;
        case1.contactid=cont1.id;
        case1.Subject='test';
        case1.Status='New';
        case1.Origin='phone';
        insert case1;
        Pop_Up_Alert__c popone = new Pop_Up_Alert__c();
        popone.Account__c = accone1.id;
        popone.Start_Date__c = TODAY -2;
        popone.End_Date__c = TODAY + 2;
        popone.Message__c = 'Test Always';
        insert popone;
        
        Pop_Up_Alert_Confirmation__c popConOne = new Pop_Up_Alert_Confirmation__c();
        popConOne.Pop_Up_Alerts__c = popone.id;
        popConOne.user__C = userinfo.getUserId();
        insert popConOne;
        
        test.startTest();
        PageReference pageRef = Page.modaldialog_iframe;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',case1.id);
        
        modaldialog_iFramectrl controller = new modaldialog_iFramectrl();
        controller.onload();
        controller.userPref();
        
        test.stopTest(); 
    }
}