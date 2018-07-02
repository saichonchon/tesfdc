/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   Test class for OpportunityTriggerFromWorkflows.trigger
Inputs:        
Returns:       
History
2017-12-11  Yiming Shen <yiming.shen@capgemini.com> created
------------------------------------------------------------*/
@isTest
private class TrgOpportunityTriggerFromWorkflowsTest {
	@testSetup static void testConfig(){
		ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
        ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
        ClsTestCustomSettingHelper.getPMV_Stage_Config();
        ClsTestCustomSettingHelper.getADMTerritoryCode();
        Channelinsightdata_test.Channelinsightdata_test();
        ClsTestHelp.createTestOPTG4();
        ClsTestHelp.createTestSSPS1(); 
	}
	
    static testMethod void testEnergyOppy(){
    	Opportunity testOppy = ClsTestHelp.createTestOpportunity();
        testOppy.Name = 'test';
        testOppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        Test.startTest();
        insert testOppy;
        Test.stopTest();
    }
    
    static testMethod void testUpdateStageByMedOppStatus() {
    	ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);
    	Account acct = ClsTestHelp.createTestAccounts();
    	acct.AccountNumber = '511234';
    	insert acct;
    	Opportunity oppy = ClsTestHelp.createTestOpportunity();
    	oppy.Name = 'testOppy';
    	//oppy.Probability__c = '10';
    	oppy.StageName = 'Approved/Active';
    	oppy.AccountId = acct.Id;
    	oppy.Master_Opportunity__c = null;
    	oppy.RecordTypeId = ClsTestHelp.createTestRecordType11().Id;
    	insert oppy;
    	Test.startTest();
    	oppy.MED_Opp_Status__c = 'CM - Complete';
		update oppy;
    	Test.stopTest();
    	Opportunity oppyAssert = [SELECT StageName FROM Opportunity WHERE Id =: oppy.Id limit 1];
    	System.assert(oppyAssert.StageName == 'Won - Closed');
    }
    
    static testMethod void testUpdateRelayAEStartDatePositive() {
    	ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);
    	Opportunity oppy = ClsTestHelp.createTestOpportunity();
    	oppy.Name = 'testOppy';
    	oppy.Relay_Application_Support_requested__c = false;
    	//oppy.Probability__c = '10';
    	oppy.StageName = 'Approved/Active';
    	oppy.Master_Opportunity__c = null;
    	oppy.RecordTypeId = ClsTestHelp.createTestRecordType11().Id;
    	insert oppy;
    	Opportunity oppyAssert = [SELECT Relay_AE_Start_Date__c FROM Opportunity WHERE Id =: oppy.Id limit 1];
    	System.assert(oppyAssert.Relay_AE_Start_Date__c == null);
    	Test.startTest();
    	oppy.Relay_Application_Support_requested__c = true;
    	update oppy;
    	Test.stopTest();
    	oppyAssert = [SELECT Relay_AE_Start_Date__c FROM Opportunity WHERE Id =: oppy.Id limit 1];
    	System.assert(oppyAssert.Relay_AE_Start_Date__c != null);
    }
    
    static testMethod void testUpdateRelayAEStartDateNegative() {
    	ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);
    	Opportunity oppy = ClsTestHelp.createTestOpportunity();
    	oppy.Name = 'testOppy';
    	oppy.Relay_Application_Support_requested__c = true;
    	//oppy.Probability__c = '10';
    	oppy.StageName = 'Approved/Active';
    	oppy.Master_Opportunity__c = null;
    	oppy.RecordTypeId = ClsTestHelp.createTestRecordType11().Id;
    	insert oppy;
    	Opportunity oppyAssert = [SELECT Relay_AE_Start_Date__c FROM Opportunity WHERE Id =: oppy.Id limit 1];
    	System.assert(oppyAssert.Relay_AE_Start_Date__c != null);
    	Test.startTest();
    	oppy.Relay_Application_Support_requested__c = false;
    	update oppy;
    	Test.stopTest();
    	oppyAssert = [SELECT Relay_AE_Start_Date__c FROM Opportunity WHERE Id =: oppy.Id limit 1];
    	System.assert(oppyAssert.Relay_AE_Start_Date__c == null);
    }
    
    static testMethod void testSetStageEntryDate() {
    	ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);
    	Opportunity oppy = ClsTestHelp.createTestOpportunity();
    	oppy.Name = 'testOppy';
    	oppy.Relay_Application_Support_requested__c = true;
    	//oppy.Probability__c = '10';
    	oppy.StageName = 'Approved/Active';
    	oppy.Master_Opportunity__c = null;
    	oppy.RecordTypeId = ClsTestHelp.createTestRecordType11().Id;
    	insert oppy;
    	Opportunity oppyAssert = [SELECT Date_when_stage_entered__c FROM Opportunity WHERE Id =: oppy.Id limit 1];
    	System.assert(oppyAssert.Date_when_stage_entered__c != null);
    	Test.startTest();
    	oppy.StageName = 'Quotation';
    	update oppy;
    	Test.stopTest();
    	oppyAssert = [SELECT Date_when_stage_entered__c FROM Opportunity WHERE Id =: oppy.Id limit 1];
    	System.assert(oppyAssert.Date_when_stage_entered__c != null);
    }
    
    static testMethod void testSetMEDWinLossDateNegative() {
    	ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);
    	Opportunity oppy = ClsTestHelp.createTestOpportunity();
    	oppy.Name = 'testOppy';
    	oppy.MED_Opp_Status__c = 'CN - Lost (Canceled)';
    	//oppy.Probability__c = '10';
    	oppy.StageName = 'Approved/Active';
    	oppy.Master_Opportunity__c = null;
    	oppy.RecordTypeId = ClsTestHelp.createTestRecordType11().Id;
    	insert oppy;
    	Opportunity oppyAssert = [SELECT MED_Quote_Approval_Date__c FROM Opportunity WHERE Id =: oppy.Id limit 1];
    	System.assert(oppyAssert.MED_Quote_Approval_Date__c != null);
    	Test.startTest();
    	oppy.MED_Opp_Status__c = 'QR - Quote Released';
    	update oppy;
    	Test.stopTest();
    	oppyAssert = [SELECT MED_Quote_Approval_Date__c FROM Opportunity WHERE Id =: oppy.Id limit 1];
    	System.assert(oppyAssert.MED_Quote_Approval_Date__c == null);
    }
    
    static testMethod void testSetMEDWinLossDatePositive() {
    	ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);
    	Opportunity oppy = ClsTestHelp.createTestOpportunity();
    	oppy.Name = 'testOppy';
    	oppy.MED_Opp_Status__c = 'P0 - Pre-Opportunity';
    	//oppy.Probability__c = '10';
    	oppy.StageName = 'Approved/Active';
    	oppy.Master_Opportunity__c = null;
    	oppy.MED_Quote_Approval_Date__c = Date.today();
    	oppy.RecordTypeId = ClsTestHelp.createTestRecordType11().Id;
    	insert oppy;
    	Opportunity oppyAssert = [SELECT MED_Quote_Approval_Date__c FROM Opportunity WHERE Id =: oppy.Id limit 1];
    	System.assert(oppyAssert.MED_Quote_Approval_Date__c == null);
    	Test.startTest();
    	oppy.MED_Opp_Status__c = 'CN - Lost (Canceled)';
    	update oppy;
    	Test.stopTest();
    	oppyAssert = [SELECT MED_Quote_Approval_Date__c FROM Opportunity WHERE Id =: oppy.Id limit 1];
    	System.assert(oppyAssert.MED_Quote_Approval_Date__c != null);
    }
    
    static testMethod void testSetMEDWinLossDatePositive2() {
    	ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);
    	Opportunity oppy = ClsTestHelp.createTestOpportunity();
    	oppy.Name = 'testOppy';
    	oppy.MED_Opp_Status__c = 'P0 - Pre-Opportunity';
    	//oppy.Probability__c = '10';
    	oppy.StageName = 'Approved/Active';
    	oppy.Master_Opportunity__c = null;
    	oppy.RecordTypeId = ClsTestHelp.createTestRecordType11().Id;
    	insert oppy;
    	Opportunity oppyAssert = [SELECT MED_Quote_Approval_Date__c FROM Opportunity WHERE Id =: oppy.Id limit 1];
    	System.assert(oppyAssert.MED_Quote_Approval_Date__c == null);
    	Test.startTest();
    	oppy.MED_Opp_Status__c = 'CN - Lost (Canceled)';
    	update oppy;
    	Test.stopTest();
    	oppyAssert = [SELECT MED_Quote_Approval_Date__c FROM Opportunity WHERE Id =: oppy.Id limit 1];
    	System.assert(oppyAssert.MED_Quote_Approval_Date__c != null);
    }
}