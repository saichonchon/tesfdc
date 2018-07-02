/*------------------------------------------------------------
Author:        Tangyong Li <tangyong.li@capgemini.com>
Description:   A test class for ClsCopyLineItemsToOppyPartsQueue.cls.
Inputs:        
History
2018-05-04     Tangyong Li <tangyong.li@capgemini.com> Created
------------------------------------------------------------*/
@isTest
public class ClsCopyLineItemsToOppyPartsQueue_Test {
    
    @testSetup 
    static void testCreateConfig(){
		ClsTestCustomSettingHelper.getADMTerritoryCode();
		ClsTestHelp.createTestOPTG4();
    	ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        Channelinsightdata_test.Channelinsightdata_test();
	}
    
    static testMethod void myUnitTest() {
    	Account testAcct1 = ClsTestHelp.createTestAccounts();
        testAcct1.AccountNumber = 'test';
        testAcct1.Company_Number__c = 'test';
        insert testAcct1;
        RecordType oppyRecordType = ClsTestHelp.createTestRecordType32();
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'TestOppy1';
        oppy.AccountId = testAcct1.Id;
        oppy.RecordTypeId = oppyRecordType.Id;
        oppy.ERP_for_Pricing__c = 'MFGPRO';
        insert oppy; 
        Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial'; 
        insert ph;
        Part__c part = ClsTestHelp.createTestPart();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        part.Min_Order_Qty__c = 10;
        insert part;
        Energy_Quote__c quote = ClsTestHelp.createTestEnergyQuote();
        quote.Opportunity_Name__c = oppy.Id;
        quote.Reason_of_Win__c = 'On spec';
        insert quote;
        Energy_Quote_Line_Item__c qli = ClsTestHelp.createTestEnergyQuoteLineItem();
        qli.Energy_Quote_Name__c = quote.Id;
        qli.Quantity__c = 100;
        qli.UnitPrice__c = 100;
        insert qli;
        Test.startTest();
        list<Opportunity_Part__c> list_oppyParts = new list<Opportunity_Part__c>();
        for(Integer i=0; i<51; i++) {
	        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
	        oppypart.Opportunity__c = oppy.Id;
	        oppyPart.Part__c = part.Id;
	        oppypart.Quantity__c = 1;
	        oppypart.Standard_Cost__c = 0;
	        oppypart.Part_Number__c = 'test';
	        oppypart.Offered_Price__c = 2;
	        list_oppyParts.add(oppypart);
        }
        system.enqueueJob(new ClsCopyLineItemsToOppyPartsQueue(new set<Id>{quote.Id}, new map<Id, String>{oppy.Id => 'USD'}));
        Test.stopTest();
    }
    
}