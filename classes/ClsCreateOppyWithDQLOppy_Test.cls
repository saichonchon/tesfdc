/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   A test class for ClsCreateOppyWithDQLOppy.cls.
Inputs:        
Test Class:    
History
2017-09-21 	Yiming Shen <yiming.shen@capgemini.com> created
------------------------------------------------------------*/
@isTest
private class ClsCreateOppyWithDQLOppy_Test {

    static testMethod void myUnitTest() {
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        //ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getADMTerritoryCode();
        ClsTestCustomSettingHelper.getOrgWideSettings();
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();
        
        RecordType rt2 = ClsTestHelp.createTestRecordType8();
        
        Consumer_Device_Opportunity_Record_Types__c cdort1 = ClsTestHelp.createTestCSD1();
        Consumer_Device_Opportunity_Record_Types__c cdort2 = ClsTestHelp.createTestCSD2();
        Consumer_Device_Opportunity_Record_Types__c cdort3 = ClsTestHelp.createTestCSD3();
        Consumer_Device_Opportunity_Record_Types__c cdort4 = ClsTestHelp.createTestCSD4();
        Consumer_Device_Opportunity_Record_Types__c cdort5 = ClsTestHelp.createTestCSD5();
        Consumer_Device_Opportunity_Record_Types__c cdort6 = ClsTestHelp.createTestCSD6();
        Consumer_Device_Opportunity_Record_Types__c cdort7 = ClsTestHelp.createTestCSD7();
        Account testAcct = ClsTestHelp.createTestAccounts();
        insert testAcct;
        Data_Qualified_Lead__c dql = new Data_Qualified_Lead__c();
        dql.Name = 'TestDQL';
        dql.TE_Potential_Value__c = 123;
        dql.Next_Step__c = 'Follow up on project';
        dql.Prospect_Company__c = testAcct.Id;
        insert dql;
        
        Test.startTest();
        
        ClsCreateOppyWithDQLOppy.createOpportunity(dql.Id);
        ClsCreateOppyWithDQLOppy.createOpportunity(null);
        
        Test.stopTest();
    }
}