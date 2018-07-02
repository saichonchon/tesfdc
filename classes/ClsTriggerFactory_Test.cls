/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   A test class for ClsTriggerFactory.cls.
Inputs:        
Test Class:    
History
2016-08-18  Jun Yu <jun.yu@oinio.com> created
2017-07-10 	Yiming Shen <yiming.shen@capgemini.com> Modified
------------------------------------------------------------*/
@isTest(SeeAllData=false)
public class ClsTriggerFactory_Test {
	@testSetup static void createConfig(){
		ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        ClsTestCustomSettingHelper.getADMTerritoryCode();
        Channelinsightdata_test.Channelinsightdata_test();
        ClsTestHelp.createTestOPTG4();
	}
	
    static testMethod void testBasicCreateHandler() {
    	Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        oppy.Name = 'TestOppy2';
        insert oppy;
        
        test.starttest();
        ClsTriggerFactory.setSkipHandlers(true);
        update oppy;
        ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);       
        update oppy;    
        Opportunity oppyAssert = [SELECT Id,Name FROM Opportunity WHERE Id =: oppy.Id]; 
        System.assert(oppyAssert.Name == 'TestOppy2');   
        test.stoptest();
        ClsTriggerException e = new ClsTriggerException();
        ClsTriggerVirtual trgVir = new ClsTriggerVirtual();
        ClsWrappers.TriggerContext trgCx = new ClsWrappers.TriggerContext();
        trgCx.isInsert = true;
        List<SObject> list_soj = new List<SObject>();
        list_soj.add(oppy);
        trgCx.newList = list_soj;
        trgVir.beforeTrigger(trgCx);
        trgVir.afterTrigger(trgCx);
        trgCx.isInsert = false;
        trgCx.isDelete = true;
        trgCx.oldList = list_soj;
        trgVir.beforeTrigger(trgCx);
        trgVir.afterTrigger(trgCx);
        trgCx.isInsert = false;
        trgCx.isDelete = false;
        trgCx.isUpdate = true;
        trgCx.oldList = list_soj;
        trgCx.newMap = new map<Id, SObject>();
        trgCx.newMap.put(oppy.Id, oppy);
        trgVir.beforeTrigger(trgCx);
        trgVir.afterTrigger(trgCx);
        ClsTriggerFactory.setSkipHandlers(false);
        ClsTriggerFactory.setSkipHandler('ClsTriggerFactory_Test',false);
    }
    
    static testMethod void testAcctCreateHandler() {
        Account acct = ClsTestHelp.createTestAccounts();
        test.starttest();
        acct.Name = 'Test';
        insert acct;
        test.stoptest(); 
        Account acctAssert = [SELECT Id,Name FROM Account WHERE Id =: acct.Id]; 
        System.assert(acctAssert.Name == 'Test');       
    }
    
    static testMethod void testInventoryCreateHandler() {
        Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
    	insert ph;
    	 
    	Part__c part = ClsTestHelp.createTestPart();
    	part.Name = 'test';
    	part.Product_Hierarchy__c = ph.Id;
    	insert part;
    	
    	Inventory__c inven = ClsTestHelp.createTestInventory();
    	inven.Part_Number__c = part.Name;
    	test.starttest();
    	insert inven;
    	test.stoptest();
    	Inventory__c invenAssert = [SELECT Id,Part_Number__c FROM Inventory__c WHERE Id =: inven.Id]; 
        System.assert(invenAssert.Part_Number__c == part.Name); 
    }
    
    static testMethod void testEnergyPricebookEntryCreateHandler() {
        Product_Hierarchy__c p = ClsTestHelp.createTestProductHierarchy();
    	insert p;
    	
    	Part__c part = ClsTestHelp.createTestPart();
    	part.Name = 'test';
    	part.Product_Hierarchy__c = p.Id;
    	insert part;
    	
    	Test.startTest();
    	Energy_Price_Book_Entry__c epbe = ClsTestHelp.createTestEnergyPriceBookEntry();
    	epbe.Name = 'test';
    	insert epbe;
    	Test.stopTest();
    	Energy_Price_Book_Entry__c epbeAssert = [SELECT Id,Name FROM Energy_Price_Book_Entry__c WHERE Id =: epbe.Id]; 
        System.assert(epbeAssert.Name == 'test'); 
    }
    
    static testMethod void testOppyPartnerCreateHandler() {
    	Account acct = ClsTestHelp.createTestAccounts();
        insert acct;
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'TestOppy1';
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        insert oppy;
    	Opportunity_Partner__c oppyPartner = ClsTestHelp.createTestOpportunityPartner();
        oppyPartner.Opportunity__c = oppy.Id;
        oppyPartner.Account__c = acct.Id;
        oppyPartner.Allocation__c = 100;
        Test.startTest();
        insert oppyPartner;
        Test.stopTest();
        Opportunity_Partner__c opAssert = [SELECT Id,Allocation__c FROM Opportunity_Partner__c WHERE Id =: oppyPartner.Id]; 
        System.assert(opAssert.Allocation__c == 100); 
    }
    
    static testMethod void testOppyTeamMemberCreateHandler() {
    	Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'TestOppy1';
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        insert oppy;
        OpportunityTeamMember teamMember = ClsTestHelp.createTestOpportunityTeamMember();
        teamMember.OpportunityId = oppy.Id;
        teamMember.UserId = UserInfo.getUserId();
        Test.startTest();
        insert teamMember;
        Test.stopTest();
        OpportunityTeamMember otmAssert = [SELECT Id,OpportunityId FROM OpportunityTeamMember WHERE Id =: teamMember.Id]; 
        System.assert(otmAssert.OpportunityId == oppy.Id); 
    }
    
    static testMethod void testOppyPartCreateHandler() {
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'TestOppy1';
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        insert oppy;
    	Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial'; 
        insert ph;
        Part__c part = ClsTestHelp.createTestPart();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        Opportunity_Part__c oppyPart = ClsTestHelp.createTestEnergyOpportunityPart();
		oppyPart.Opportunity__c = oppy.Id;
		oppyPart.Part__c = part.Id;
		//oppyPart.Fraction_of_sale__c = 0.60;
        Test.startTest();
        insert oppyPart;
        Test.stopTest();
        Opportunity_Part__c opAssert = [SELECT Id,Opportunity__c FROM Opportunity_Part__c WHERE Id =: oppyPart.Id]; 
        System.assert(opAssert.Opportunity__c == oppy.Id);
    }
    
    static testMethod void testOppyForecastCreateHandler() {
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'TestOppy1';
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        insert oppy;
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestENGOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy.Id;
        oppyForecast.Confidence_Level__c = '30';
        Test.startTest();
        insert oppyForecast;
        Test.stopTest();
        Opportunity_Forecast__c ofAssert = [SELECT Id,Opportunity__c FROM Opportunity_Forecast__c WHERE Id =: oppyForecast.Id]; 
        System.assert(ofAssert.Opportunity__c == oppy.Id);
    }
    
    static testMethod void testCreateHandler() {
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'TestOppy2';
        //oppy.Probability__c = '30';
        insert oppy;
        
         Account acct = ClsTestHelp.createtestAccounts();
         acct.WWCORPACCT__c = 'W0007';
         acct.GAMCD__c = 'G0007';
         acct.IND_KAM_Code__c = 'K0007';
         insert acct;
        
         ACP_Account_Plan__c newAccPlan = new ACP_Account_Plan__c(
           Name = 'TestAccountPlan3564',
           ACP_Account_Name__c = acct.Id,
           Account_Plan_Type__c = 'Gam Account',
           ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3564');
         insert newAccPlan;
        
         Trigger_Configuration__c tcm = new Trigger_Configuration__c();
         tcm.Name = 'MarketCompetitionDelete';
         tcm.isRun__c = true;
         insert tcm;
        
         Trigger_Configuration__c tcp = new Trigger_Configuration__c();
         tcp.Name = 'PlatformContentUpdate';
         tcp.isRun__c = true;
         insert tcp;
        
         //insert Market and Competition
         List < ACP_Market_and_Competition__c > Mark = ACP_TestDataFactory.createMarketCompetition(1, 'General Market and Competition');
         for (ACP_Market_and_Competition__c obj: mark) {
           obj.ACP_Account_Plan__c = newAccPlan.id;
         }    
         insert mark;
        
         Opportunity opp = [select id from opportunity limit 1];
            
         List < Platform_Content__c > pfc = ACP_TestDataFactory.createPlatCont();
         for (Platform_Content__c obj: pfc) {
           obj.Program_Opportunity__c = opp.id;
         }
         insert pfc;  

    }
}