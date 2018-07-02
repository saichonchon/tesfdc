/**
 * test class for class ExtMFGPROQuotePdf
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
public class ExtMFGPROQuotePdf_Test {
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
            
            RecordType rt = ClsTestHelp.createTestRecordType32();
           
        	Opportunity oppy = ClsTestHelp.createTestOpportunity();
        	oppy.Name = 'testOppy2';
        	oppy.AccountId = vAccount.Id;
            oppy.RecordTypeId = rt.id;
        	insert oppy;
            
            /** create test product hierarchy */
         	Product_Hierarchy__c ph = new Product_Hierarchy__c();
    		ph.Name = '123';
    		ph.CBC2__c = '30012';
    		ph.CBC3__c = '30033';
    		ph.CBC1_Description__c = 'Appliances';
        	insert ph;
        	/** create test part */
        	Part__c part = new Part__c();
    		part.Name = 'testPart';
    		part.GPL__c = ph.Id;
    		part.Product_Hierarchy__c = ph.Id; 
    		part.Description__c = 'test';
    		part.PRODUCT_CDE__c = 'TEST1';
    		part.PROD_NAME__c = 'test name1';
    		insert part;
            
            RecordType recType = [select Id from RecordType where DeveloperName = 'NDR_Opportunity_Parts'];
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
            PageReference pageRef = Page.MFGPROQuotePdf;
            Test.setCurrentPage(pageRef);
			ApexPages.currentPage().getParameters().put('id', quoteId);
			ExtMFGPROQuotePdf controller = new ExtMFGPROQuotePdf(new ApexPages.StandardController(newQuote));
            Test.stopTest();
        }
    }
}