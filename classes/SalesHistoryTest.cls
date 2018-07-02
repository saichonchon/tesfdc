/*------------------------------------------------------------
Author:        Tangyong Li <tangyong.li@capgemini.com>
Description:   test class for class SalesHistory.
			   The user story number is W-00130.
Inputs:        
Test Class:    
History
2017-08-24 	   Tangyong Li <tangyong.li@capgemini.com> Created
------------------------------------------------------------*/
@isTest
public class SalesHistoryTest {
    @testSetup static void createConfig(){
    	ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        ClsTestCustomSettingHelper.getQuoteValiditySetting();
        ClsTestCustomSettingHelper.getQuoteExpirationSetting();
        ClsTestCustomSettingHelper.getADMTerritoryCode();
        ClsTestHelp.createTestOrgWideSettings1();
    }
    
    static testMethod void myUnitTest() {
        User u = ClsTestHelp.createTestUsers();
        insert u;
        System.runAs(u) {
        	Account acct = ClsTestHelp.createTestAccounts();
        	insert acct;
        	Opportunity oppy = ClsTestHelp.createTestOpportunity();
        	oppy.Name = 'testOppy2';
        	oppy.AccountId = acct.Id;
        	oppy.Check_Unit_Price__c = true;
        	oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        	insert oppy; 
        	Product_Hierarchy__c ph = new Product_Hierarchy__c();
    		ph.Name = '123';
    		ph.CBC2__c = '30012';
    		ph.CBC3__c = '30033';
    		ph.CBC1_Description__c = 'Appliances';
        	insert ph;
        	Part__c part = new Part__c();
    		part.Name = 'testPart';
    		part.GPL__c = ph.Id;
    		part.Product_Hierarchy__c = ph.Id; 
    		part.Description__c = 'test';
    		part.PRODUCT_CDE__c = 'TEST1';
    		part.PROD_NAME__c = 'test name1';
    		insert part;
        	Test.startTest();
        	ApexPages.currentPage().getParameters().put('Id', part.Id);
        	ApexPages.currentPage().getParameters().put('oppyId', oppy.Id);
        	SalesHistory sh = new SalesHistory();
        	//sh.getSalesHistorydata();
        	//sh.getSalesHistorydata1();
        	Test.stopTest();
        }
    }
    
}