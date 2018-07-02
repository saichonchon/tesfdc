/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   A test class for ExtOpportunityDeepClone.cls.
Inputs:        
Test Class:    
History
2017-10-18 Yiming Shen <yiming.shen@capgemini.com> Created
------------------------------------------------------------*/
@isTest
private class ExtOpportunityDeepClone_Test {
	@testSetup static void createConfig(){
		ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOrgWideSettings();
        ClsTestCustomSettingHelper.getADMTerritoryCode();
        ClsTestHelp.createTestOPTG4();
	}
	
    static testMethod void myUnitTest1() {
        Account testAcct1 = ClsTestHelp.createTestAccounts();
        testAcct1.AccountNumber = 'test';
        testAcct1.Company_Number__c = 'test';
        testAcct1.Source_System__c = 36;
        insert testAcct1;
        RecordType oppyRecordType = ClsTestHelp.createTestRecordType32();
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'TestOppy1';
        oppy.AccountId = testAcct1.Id;
        oppy.RecordTypeId = oppyRecordType.Id;
        insert oppy;
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Name = 'TestOppy1';
        oppy2.AccountId = testAcct1.Id;
        oppy2.RecordTypeId = oppyRecordType.Id;
        oppy2.Master_Opportunity__c = oppy.Id;
        insert oppy2;
        OpportunityTeamMember teamMember = ClsTestHelp.createTestOpportunityTeamMember();
        teamMember.OpportunityId = oppy2.Id;
        teamMember.UserId = UserInfo.getUserId();
        insert teamMember;
        ANZ_Clause__c clause = ClsTestHelp.createTestANZClause();
        clause.Opportunity__c = oppy2.Id;
        insert clause;
        Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial'; 
        insert ph;
        
        Part__c part = ClsTestHelp.createTestPart();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        Opportunity_Part__c oppypart = ClsTestHelp.createTestEnergyOpportunityPart();
        oppypart.Opportunity__c = oppy2.Id;
        oppypart.Part__c = part.Id;
        oppypart.Offered_Price__c = 0;
        Test.startTest();
        insert oppypart;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(oppy2);
        ApexPages.currentPage().getParameters().put('isCompetingOppy','true');
        ExtOpportunityDeepClone ctrl = new ExtOpportunityDeepClone(sc);
        ctrl.cloneOpportunity();
        Test.stopTest();
    }
    
    static testMethod void myUnitTest2() {
    	 Account testAcct1 = ClsTestHelp.createTestAccounts();
        testAcct1.AccountNumber = 'test';
        testAcct1.Company_Number__c = 'test';
        testAcct1.Source_System__c = 36;
        insert testAcct1;
        RecordType oppyRecordType = ClsTestHelp.createTestRecordType32();
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'TestOppy1';
        oppy.AccountId = testAcct1.Id;
        oppy.RecordTypeId = oppyRecordType.Id;
        insert oppy;
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Name = 'TestOppy1';
        oppy2.AccountId = testAcct1.Id;
        oppy2.RecordTypeId = oppyRecordType.Id;
        oppy2.Master_Opportunity__c = oppy.Id;
        insert oppy2;
        OpportunityTeamMember teamMember = ClsTestHelp.createTestOpportunityTeamMember();
        teamMember.OpportunityId = oppy2.Id;
        teamMember.UserId = UserInfo.getUserId();
        insert teamMember;
        ANZ_Clause__c clause = ClsTestHelp.createTestANZClause();
        clause.Opportunity__c = oppy2.Id;
        insert clause;
        Opportunity_Partner__c oppPartner = ClsTestHelp.createTestOpportunityPartner();
        oppPartner.Opportunity__c = oppy2.Id;
        oppPartner.Account__c = testAcct1.Id;
        oppPartner.Allocation__c = 100.00;
        oppPartner.Primary__c = true;
        insert oppPartner;
        Test.startTest();
        ExtOpportunityDeepClone.cloneOppyParts(oppy.Id,oppy2.Id);
        ExtOpportunityDeepClone.cloneOpportunityPartners(oppy.Id,oppy2.Id);
        ExtOpportunityDeepClone.cloneOpportunityTeamMembers(oppy.Id,oppy2.Id);
        ExtOpportunityDeepClone.cloneANZClauses(oppy.Id,oppy2.Id);
        Test.stopTest();
    	
    }
}