/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   A test class for ClsCloneOppyPartQueue.cls.
Inputs:        
Test Class:    
History
2018-01-29 Yiming Shen <yiming.shen@capgemini.com> Created
------------------------------------------------------------*/
@isTest
private class ClsCloneOppyPartQueue_Test {
	@testSetup static void createConfig(){
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        ClsTestCustomSettingHelper.getADMTerritoryCode();
        Channelinsightdata_test.Channelinsightdata_test();
        ClsTestHelp.createTestOrgWideSettings1();
        ClsTestHelp.createTestOPTG4();
    }
    
    static testMethod void myUnitTest() {
        Account acct = ClsTestHelp.createTestAccounts();
    	acct.Source_System__c = 50;
    	acct.AccountNumber = '123456';
    	insert acct;
    	Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'TestOppy21';
        oppy.AccountId = acct.Id;
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        
        Opportunity oppy11 = ClsTestHelp.createTestOpportunity();
        oppy11.Name = 'TestOppy21';
        oppy11.AccountId = acct.Id;
        oppy11.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        insert new List<Opportunity>{oppy,oppy11};
        
        Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial'; 
        insert ph;
        Part__c part = ClsTestHelp.createTestPart();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        Test.startTest();
        Opportunity_Part__c oppypart = ClsTestHelp.createTestEnergyOpportunityPart();
        oppypart.Opportunity__c = oppy11.Id;
        oppypart.Part__c = part.Id;
        oppypart.Offered_Price__c = 0;
        insert oppypart;
         
        System.enqueueJob(new ClsCloneOppyPartQueue(oppy.Id,oppy11.Id));
        Test.stopTest();
    }
}