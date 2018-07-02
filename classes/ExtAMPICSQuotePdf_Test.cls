/**
 * test class for class ExtAMPICSQuotePdf
 *
 * @author     Yuan Yao
 * @created    2017-10-17
 * @version    1.0
 * @since      41.0 (Force.com ApiVersion)
 *
 * @changelog
 * 2017-10-17  Yuan Yao <yuan.yao@capgemini.com>
 * - Created
 */
@isTest
public class ExtAMPICSQuotePdf_Test {
	static testMethod void myUnitTest() {
        User u = ClsTestHelp.createTestUsers();
        insert u;
        System.runAs(u) {
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
            
            ANZ_Clause_Master__c acm = ClsTestHelp.createTestANZClauseMaster();
            acm.Name = 'Terms and Conditions';
            acm.Opportynity_Type__c = 'Quote';
            acm.Insurance__c = 'TE Terms and Conditions of Sale Apply, refer www.te.com/aboutus/tandc.asp';
            insert acm;
            
            RecordType rt = ClsTestHelp.createTestRecordType32();
        	Opportunity oppy = ClsTestHelp.createTestOpportunity();
        	oppy.Name = 'testOppy2';
        	oppy.AccountId = vAccount.Id;
            oppy.RecordTypeId = rt.id;
            oppy.Quote_Type__c = 'Standard';
            oppy.Customer_Reference_Number__c = 'test';
            oppy.Days_prices_valid__c = '30 days';
            oppy.Sales_Engineer__c = 'Bruno Tiziani';
            oppy.Air_Freight_Cost__c = 1;
            oppy.Internal_Sales_Officer__c = 'Donita Leonard';
        	insert oppy;
        	
            ANZ_Clause__c clause = ClsTestHelp.createTestANZClause();
            clause.Opportunity__c = oppy.Id;
            clause.Insurance__c = 'test';
            insert clause;
            
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
            
            RecordType recType = ClsTestHelp.createTestRecordType24();
        	Opportunity_Part__c op =  ClsTestHelp.createTestEnergyOpportunityPart();
        	//op.recordTypeId = recType.Id;
        	op.Opportunity__c = oppy.Id;
        	op.Part__c = part.Id;
        	op.Quantity__c = 20;
        	op.Offered_Price__c = 1;
        	Test.startTest();
        	//ClsTriggerFactory.setSkipHandler('AccountTrgHandler',true); 
        	ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);
        	insert op;

            String quoteId = CreateQuoteBasedOnOpp.createQuote(oppy.Id);
            Energy_Quote__c newQuote = [Select Id From Energy_Quote__c Where Id =: quoteId];
            PageReference pageRef = Page.AMPICSQuotePdf;
            Test.setCurrentPage(pageRef);
			ApexPages.currentPage().getParameters().put('id', quoteId);
			ExtAMPICSQuotePdf controller = new ExtAMPICSQuotePdf(new ApexPages.StandardController(newQuote));
            String dateFormat = controller.getDateformat();
            controller.getANZClause();
            System.assert(dateFormat!= null);
            Test.stopTest();
        }
    }
}