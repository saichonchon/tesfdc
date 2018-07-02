/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   A test class for OpportunityResetClauses.cls.
Inputs:        
Test Class:    
History
2017-11-30 Yiming Shen <yiming.shen@capgemini.com> Created
------------------------------------------------------------*/
@isTest
private class OpportunityResetClauses_Test {
	@testSetup static void createConfig(){
    	ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        ClsTestCustomSettingHelper.getQuoteValiditySetting();
        ClsTestCustomSettingHelper.getQuoteExpirationSetting();
        ClsTestHelp.createTestOrgWideSettings1();
        ClsTestCustomSettingHelper.getADMTerritoryCode();
        ClsTestHelp.createTestOPTG4(); 
    }
    
    static testMethod void myUnitTest() {
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'testOppy2';
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        oppy.Quote_Type__c = 'Standard';
        insert oppy;
        
        ANZ_Clause_Master__c anzClsMaster = ClsTestHelp.createTestANZClauseMaster();
        anzClsMaster.Name = 'testMaster';
        anzClsMaster.Opportynity_Type__c = 'Quote';
        insert anzClsMaster;
        
        ANZ_Clause__c anzCls = ClsTestHelp.createTestANZClause();
        anzCls.Opportunity__c = oppy.Id;
        anzCls.Name = anzClsMaster.Name;
   		anzCls.ANZ_Clause_Master__c = anzClsMaster.Id;
   		anzCls.Insurance__c = anzClsMaster.Insurance__c;
   		anzCls.Opportynity_Type__c = anzClsMaster.Opportynity_Type__c;
   		anzCls.Sequence_No__c = anzClsMaster.Sequence_No__c;
        insert anzCls;
        
        Test.startTest();
        OpportunityResetClauses.resetClauses(oppy.Id,oppy.Quote_Type__c);
        Test.stopTest();
        List<ANZ_Clause__c> list_ANZClauses = [SELECT Id FROM ANZ_Clause__c WHERE Opportunity__c =: oppy.Id];
        System.assert(list_ANZClauses.size() > 0);
    }
}