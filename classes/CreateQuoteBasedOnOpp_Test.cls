/**
 * test class for class CreateQuoteBasedOnOpp
 *
 * @author     Yuan Yao
 * @created    2017-09-06
 * @version    1.0
 * @since      40.0 (Force.com ApiVersion)
 *
 * @changelog
 * 2017-09-06  Yuan Yao <yuan.yao@capgemini.com>
 * - Created
 */
@isTest
public class CreateQuoteBasedOnOpp_Test {
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
        ClsTestHelp.createTestOPTG4();
        ClsTestHelp.createTestOrgWideSettings1();
	}
	
	static testMethod void myUnitTest() {
        User u = ClsTestHelp.createTestUsers();
        insert u;
        System.runAs(u) {
			Account vAccount = ClsTestHelp.createTestAccounts();
			vAccount.Name = 'AMP Iron Foundries Inc';
			vAccount.AnnualRevenue = 2000000.11; 
			vAccount.Legally_Restricted__c = false;  
			vAccount.BillingCity = 'Shanghai';	
			vAccount.BillingCountry	= 'China';
			vAccount.BillingState = '000000';
			vAccount.BillingStreet = 'Changning';
			vAccount.BillingPostalCode = '200051';
        	vAccount.BU_Owner_Email__c = 'testMail@oinio.com';
        	insert vAccount;
            
            RecordType rt = ClsTestHelp.createTestRecordType32();
            
        	Opportunity oppy = ClsTestHelp.createTestOpportunity();
        	oppy.Name = 'testOppy2';
        	oppy.AccountId = vAccount.Id;
            oppy.RecordTypeId = rt.id;
            oppy.ERP_For_Pricing__c = 'SAP (except ANZPAC)';
        	insert oppy;
            
            /** create test product hierarchy */
         	Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
    		ph.Name = '123';
    		ph.CBC2__c = '30012';
    		ph.CBC3__c = '30033';
    		ph.CBC1_Description__c = 'Appliances';
        	insert ph;
        	/** create test part */
        	Part__c part = ClsTestHelp.createTestPart();
    		part.Name = 'testPart';
    		part.GPL__c = ph.Id;
    		part.Product_Hierarchy__c = ph.Id; 
    		part.Description__c = 'test';
    		part.PRODUCT_CDE__c = 'TEST1';
    		part.PROD_NAME__c = 'test name1';
    		insert part;
            
        	Opportunity_Part__c op =  ClsTestHelp.createTestEnergyOpportunityPart();
        	op.Opportunity__c = oppy.Id;
        	op.Part__c = part.Id;
        	op.Quantity__c = 20;
        	op.Offered_Price__c = 1;
        	Test.startTest();
        	insert op;
            
            String quoteId = CreateQuoteBasedOnOpp.createQuote(oppy.Id);
            System.assert(quoteId.length() == 18);
            CreateQuoteBasedOnOpp.savePdf(quoteId);
            CreateQuoteBasedOnOpp.savePdf(null);
            Test.stopTest();
        }
    }
    
    static testMethod void myUnitTest2() {
        User u = ClsTestHelp.createTestUsers();
        insert u;
        System.runAs(u) {
			Account vAccount = ClsTestHelp.createTestAccounts();
			vAccount.Name = 'AMP Iron Foundries Inc';
			vAccount.AnnualRevenue = 2000000.11; 
			vAccount.Legally_Restricted__c = false;  
			vAccount.BillingCity = 'Shanghai';	
			vAccount.BillingCountry	= 'China';
			vAccount.BillingState = '000000';
			vAccount.BillingStreet = 'Changning';
			vAccount.BillingPostalCode = '200051';
        	vAccount.BU_Owner_Email__c = 'testMail@oinio.com';
        	insert vAccount;
            Opportunity oppy1 = ClsTestHelp.createTestOpportunity();
        	oppy1.Name = 'testOppy2';
        	oppy1.AccountId = vAccount.Id;
        	insert oppy1;
            /** create test product hierarchy */
         	Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
    		ph.Name = '123';
    		ph.CBC2__c = '30012';
    		ph.CBC3__c = '30033';
    		ph.CBC1_Description__c = 'Appliances';
        	insert ph;
        	/** create test part */
        	Part__c part = ClsTestHelp.createTestPart();
    		part.Name = 'testPart';
    		part.GPL__c = ph.Id;
    		part.Product_Hierarchy__c = ph.Id; 
    		part.Description__c = 'test';
    		part.PRODUCT_CDE__c = 'TEST1';
    		part.PROD_NAME__c = 'test name1';
    		insert part;
            
        	Opportunity_Part__c op =  ClsTestHelp.createTestOpportunityPart();
        	op.Opportunity__c = oppy1.Id;
        	op.Part__c = part.Id;
        	op.Quantity__c = 20;
        	op.Offered_Price__c = 1;
        	Test.startTest();
        	insert op;
            String quoteId2 = CreateQuoteBasedOnOpp.createQuote(oppy1.Id);
            CreateQuoteBasedOnOpp.savePdf(quoteId2);
            Test.stopTest();
        }
    }
}