/**
 * test class for class EnergyQuoteTrgHandler
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
public class EnergyQuoteTrgHandler_Test {
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
        ClsTestCustomSettingHelper.getBestPriceWebspeedSetting();
	}
	
	static testMethod void testSaveQuotePdfAsAttachment1() {
		Account vAccount = ClsTestHelp.createTestAccounts();
        vAccount.Name = 'AMP Iron Foundries Inc';
        vAccount.AnnualRevenue = 2000000.11; 
        vAccount.Legally_Restricted__c = false;  
        vAccount.BillingCity = 'Shanghai';  
        vAccount.BillingCountry = 'China';
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
        oppy.StageName = 'Lost';
        insert oppy;
        System.debug('query num1+++'+ Limits.getQueries());
        /** create test product hierarchy */
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Name = '123';
        ph.CBC2__c = '30012';
        ph.CBC3__c = '30033';
        ph.CBC1_Description__c = 'Appliances';
        insert ph;
        System.debug('query num2+++'+ Limits.getQueries());
        /** create test part */
        Part__c part = new Part__c();
        part.Name = 'testPart';
        part.GPL__c = ph.Id;
        part.Product_Hierarchy__c = ph.Id; 
        part.Description__c = 'test';
        part.PRODUCT_CDE__c = 'TEST1';
        part.PROD_NAME__c = 'test name1';
        insert part;
        System.debug('query num3+++'+ Limits.getQueries());
        Test.startTest();
        System.debug('query num4+++'+ Limits.getQueries());
        Opportunity_Part__c op =  ClsTestHelp.createTestEnergyOpportunityPart();
        op.Opportunity__c = oppy.Id;
        op.Part__c = part.Id;
        insert op;
        System.debug('query num5+++'+ Limits.getQueries());
        Energy_Quote__c newQuote = new Energy_Quote__c();
        Id salesQuoteId = ClsTestHelp.getSalesQuoteRecType().Id; 
        if(salesQuoteId != null){
            newQuote.RecordTypeId = salesQuoteId;
        }
        newQuote.Contact__c = oppy.Customer_Contact_Name__c;
        newQuote.Name = oppy.Name + String.valueOf(Date.today()).substring(0, 10);
        newQuote.Account_Name__c = oppy.AccountId;
        newQuote.Opportunity_Name__c = oppy.Id;
        newQuote.Valid_From__c = system.today();
        //newQuote.CurrencyIsoCode = oppy.CurrencyIsoCode;
        insert newQuote;
        Test.stopTest();
	}
	
	static testMethod void testSaveQuotePdfAsAttachment2() {
		Account vAccount = ClsTestHelp.createTestAccounts();
        vAccount.Name = 'AMP Iron Foundries Inc';
        vAccount.AnnualRevenue = 2000000.11; 
        vAccount.Legally_Restricted__c = false;  
        vAccount.BillingCity = 'Shanghai';  
        vAccount.BillingCountry = 'China';
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
        oppy.StageName = 'Lost';
        insert oppy;
        System.debug('query num1+++'+ Limits.getQueries());
        /** create test product hierarchy */
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Name = '123';
        ph.CBC2__c = '30012';
        ph.CBC3__c = '30033';
        ph.CBC1_Description__c = 'Appliances';
        insert ph;
        System.debug('query num2+++'+ Limits.getQueries());
        /** create test part */
        Part__c part = new Part__c();
        part.Name = 'testPart';
        part.GPL__c = ph.Id;
        part.Product_Hierarchy__c = ph.Id; 
        part.Description__c = 'test';
        part.PRODUCT_CDE__c = 'TEST1';
        part.PROD_NAME__c = 'test name1';
        insert part;
        System.debug('query num3+++'+ Limits.getQueries());
        Test.startTest();
        System.debug('query num4+++'+ Limits.getQueries());
        Opportunity_Part__c op =  ClsTestHelp.createTestEnergyOpportunityPart();
        op.Opportunity__c = oppy.Id;
        op.Part__c = part.Id;
        insert op;
        System.debug('query num5+++'+ Limits.getQueries());
        Energy_Quote__c newQuote = new Energy_Quote__c();
        Id salesQuoteId = ClsTestHelp.getSalesQuoteRecType().Id; 
        if(salesQuoteId != null){
            newQuote.RecordTypeId = salesQuoteId;
        }
        newQuote.Contact__c = oppy.Customer_Contact_Name__c;
        newQuote.Name = oppy.Name + String.valueOf(Date.today()).substring(0, 10);
        newQuote.Account_Name__c = oppy.AccountId;
        newQuote.Opportunity_Name__c = oppy.Id;
        //newQuote.CurrencyIsoCode = oppy.CurrencyIsoCode;
        insert newQuote;
        Test.stopTest();
	}
	
	static testMethod void testSyncOppyStage1() {
		Account vAccount = ClsTestHelp.createTestAccounts();
        vAccount.Name = 'AMP Iron Foundries Inc';
        vAccount.AnnualRevenue = 2000000.11; 
        vAccount.Legally_Restricted__c = false;  
        vAccount.BillingCity = 'Shanghai';  
        vAccount.BillingCountry = 'China';
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
        oppy.StageName = 'Lost';
        insert oppy;
        System.debug('query num1+++'+ Limits.getQueries());
        /** create test product hierarchy */
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Name = '123';
        ph.CBC2__c = '30012';
        ph.CBC3__c = '30033';
        ph.CBC1_Description__c = 'Appliances';
        insert ph;
        System.debug('query num2+++'+ Limits.getQueries());
        /** create test part */
        Part__c part = new Part__c();
        part.Name = 'testPart';
        part.GPL__c = ph.Id;
        part.Product_Hierarchy__c = ph.Id; 
        part.Description__c = 'test';
        part.PRODUCT_CDE__c = 'TEST1';
        part.PROD_NAME__c = 'test name1';
        insert part;
        System.debug('query num3+++'+ Limits.getQueries());
        Test.startTest();
        System.debug('query num4+++'+ Limits.getQueries());
        Opportunity_Part__c op =  ClsTestHelp.createTestEnergyOpportunityPart();
        op.Opportunity__c = oppy.Id;
        op.Part__c = part.Id;
        insert op;
        System.debug('query num5+++'+ Limits.getQueries());
        Energy_Quote__c newQuote = new Energy_Quote__c();
        Id salesQuoteId = ClsTestHelp.getSalesQuoteRecType().Id; 
        if(salesQuoteId != null){
            newQuote.RecordTypeId = salesQuoteId;
        }
        newQuote.Contact__c = oppy.Customer_Contact_Name__c;
        newQuote.Name = oppy.Name + String.valueOf(Date.today()).substring(0, 10);
        newQuote.Account_Name__c = oppy.AccountId;
        newQuote.Opportunity_Name__c = oppy.Id;
        //newQuote.Status__c = 'Accepted';
        //newQuote.CurrencyIsoCode = oppy.CurrencyIsoCode;
        insert newQuote;
        Test.stopTest();
	}
	
	static testMethod void testSyncOppyStage2() {
		Account vAccount = ClsTestHelp.createTestAccounts();
        vAccount.Name = 'AMP Iron Foundries Inc';
        vAccount.AnnualRevenue = 2000000.11; 
        vAccount.Legally_Restricted__c = false;  
        vAccount.BillingCity = 'Shanghai';  
        vAccount.BillingCountry = 'China';
        vAccount.AccountNumber = '123456789';
        vAccount.BillingState = '000000';
        vAccount.BillingStreet = 'Changning';
        vAccount.BillingPostalCode = '200051';
        vAccount.RecordTypeId = ClsTestHelp.createTestRecordType6().Id;
        vAccount.BU_Owner_Email__c = 'testMail@oinio.com';
        insert vAccount;
        RecordType rt = ClsTestHelp.createTestRecordType32();            
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'testOppy2';
        oppy.AccountId = vAccount.Id;
        oppy.RecordTypeId = rt.id;
        oppy.StageName = 'New';
        insert oppy;
        System.debug('query num1+++'+ Limits.getQueries());
        /** create test product hierarchy */
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Name = '123';
        ph.CBC2__c = '30012';
        ph.CBC3__c = '30033';
        ph.CBC1_Description__c = 'Appliances';
        insert ph;
        System.debug('query num2+++'+ Limits.getQueries());
        /** create test part */
        Part__c part = new Part__c();
        part.Name = 'testPart';
        part.GPL__c = ph.Id;
        part.Product_Hierarchy__c = ph.Id; 
        part.Description__c = 'test';
        part.PRODUCT_CDE__c = 'TEST1';
        part.PROD_NAME__c = 'test name1';
        insert part;
        System.debug('query num3+++'+ Limits.getQueries());
        Test.startTest();
        System.debug('query num4+++'+ Limits.getQueries());
        Opportunity_Part__c op =  ClsTestHelp.createTestEnergyOpportunityPart();
        op.Opportunity__c = oppy.Id;
        op.Part__c = part.Id;
        insert op;
        System.debug('query num5+++'+ Limits.getQueries());
        Energy_Quote__c newQuote = new Energy_Quote__c();
        Id salesQuoteId = ClsTestHelp.getSalesQuoteRecType().Id; 
        if(salesQuoteId != null){
            newQuote.RecordTypeId = salesQuoteId;
        }
        newQuote.Contact__c = oppy.Customer_Contact_Name__c;
        newQuote.Name = oppy.Name + String.valueOf(Date.today()).substring(0, 10);
        newQuote.Account_Name__c = oppy.AccountId;
        newQuote.Opportunity_Name__c = oppy.Id;
        //newQuote.Status__c = 'Accepted';
        //newQuote.CurrencyIsoCode = oppy.CurrencyIsoCode;
        insert newQuote;
        Test.stopTest();
	}
	
	static testMethod void testSyncEnergyQuoteSAPQuoteNum() {
		Account vAccount = ClsTestHelp.createTestAccounts();
        vAccount.Name = 'AMP Iron Foundries Inc';
        vAccount.AnnualRevenue = 2000000.11; 
        vAccount.Legally_Restricted__c = false;  
        vAccount.BillingCity = 'Shanghai';  
        vAccount.BillingCountry = 'China';
        vAccount.AccountNumber = '123456789';
        vAccount.BillingState = '000000';
        vAccount.BillingStreet = 'Changning';
        vAccount.BillingPostalCode = '200051';
        vAccount.RecordTypeId = ClsTestHelp.createTestRecordType6().Id;
        vAccount.BU_Owner_Email__c = 'testMail@oinio.com';
        insert vAccount;
        RecordType rt = ClsTestHelp.createTestRecordType32();            
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'testOppy2';
        oppy.AccountId = vAccount.Id;
        oppy.RecordTypeId = rt.id;
        oppy.StageName = 'New';
        insert oppy;
        System.debug('query num1+++'+ Limits.getQueries());
        /** create test product hierarchy */
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Name = '123';
        ph.CBC2__c = '30012';
        ph.CBC3__c = '30033';
        ph.CBC1_Description__c = 'Appliances';
        insert ph;
        System.debug('query num2+++'+ Limits.getQueries());
        /** create test part */
        Part__c part = new Part__c();
        part.Name = 'testPart';
        part.GPL__c = ph.Id;
        part.Product_Hierarchy__c = ph.Id; 
        part.Description__c = 'test';
        part.PRODUCT_CDE__c = 'TEST1';
        part.PROD_NAME__c = 'test name1';
        insert part;
        System.debug('query num3+++'+ Limits.getQueries());
        Test.startTest();
        System.debug('query num4+++'+ Limits.getQueries());
        Opportunity_Part__c op =  ClsTestHelp.createTestEnergyOpportunityPart();
        op.Opportunity__c = oppy.Id;
        op.Part__c = part.Id;
        insert op;
        System.debug('query num5+++'+ Limits.getQueries());
        
        Energy_Quote__c newQuote = new Energy_Quote__c();
        Id salesQuoteId = ClsTestHelp.getSalesQuoteRecType().Id; 
        if(salesQuoteId != null){
            newQuote.RecordTypeId = salesQuoteId;
        }
        newQuote.Contact__c = oppy.Customer_Contact_Name__c;
        newQuote.Name = oppy.Name + String.valueOf(Date.today()).substring(0, 10);
        newQuote.Account_Name__c = oppy.AccountId;
        newQuote.Opportunity_Name__c = oppy.Id;
        newQuote.SAP_Quote_Number__c = 'test1';
        
        Energy_Quote__c newQuote2 = new Energy_Quote__c();
        if(salesQuoteId != null){
            newQuote2.RecordTypeId = salesQuoteId;
        }
        newQuote2.Contact__c = oppy.Customer_Contact_Name__c;
        newQuote2.Name = oppy.Name + String.valueOf(Date.today()).substring(0, 10);
        newQuote2.Account_Name__c = oppy.AccountId;
        newQuote2.Opportunity_Name__c = oppy.Id;
        List<Energy_Quote__c> list_EnergyQuotes = new List<Energy_Quote__c>{newQuote, newQuote2};
        insert list_EnergyQuotes;
        newQuote2.SAP_Quote_Number__c = 'test2';
        newQuote2.Approval_Status__c = 'Won';
        newQuote2.Reason_of_Win__c = 'Other';
        update newQuote2;
        Test.stopTest();
	}
	
	static testMethod void testSyncEnergyQuoteSAPQuoteNum2() {
		Account vAccount = ClsTestHelp.createTestAccounts();
        vAccount.Name = 'AMP Iron Foundries Inc';
        vAccount.AnnualRevenue = 2000000.11; 
        vAccount.Legally_Restricted__c = false;  
        vAccount.BillingCity = 'Shanghai';  
        vAccount.BillingCountry = 'China';
        vAccount.AccountNumber = '123456789';
        vAccount.BillingState = '000000';
        vAccount.BillingStreet = 'Changning';
        vAccount.BillingPostalCode = '200051';
        vAccount.RecordTypeId = ClsTestHelp.createTestRecordType6().Id;
        vAccount.BU_Owner_Email__c = 'testMail@oinio.com';
        insert vAccount;
        RecordType rt = ClsTestHelp.createTestRecordType32();            
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'testOppy2';
        oppy.AccountId = vAccount.Id;
        oppy.RecordTypeId = rt.id;
        oppy.StageName = 'New';
        insert oppy;
        System.debug('query num1+++'+ Limits.getQueries());
        /** create test product hierarchy */
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Name = '123';
        ph.CBC2__c = '30012';
        ph.CBC3__c = '30033';
        ph.CBC1_Description__c = 'Appliances';
        insert ph;
        System.debug('query num2+++'+ Limits.getQueries());
        /** create test part */
        Part__c part = new Part__c();
        part.Name = 'testPart';
        part.GPL__c = ph.Id;
        part.Product_Hierarchy__c = ph.Id; 
        part.Description__c = 'test';
        part.PRODUCT_CDE__c = 'TEST1';
        part.PROD_NAME__c = 'test name1';
        insert part;
        System.debug('query num3+++'+ Limits.getQueries());
        Test.startTest();
        System.debug('query num4+++'+ Limits.getQueries());
        Opportunity_Part__c op =  ClsTestHelp.createTestEnergyOpportunityPart();
        op.Opportunity__c = oppy.Id;
        op.Part__c = part.Id;
        insert op;
        System.debug('query num5+++'+ Limits.getQueries());
        Energy_Quote__c newQuote = new Energy_Quote__c();
        Id salesQuoteId = ClsTestHelp.getSalesQuoteRecType().Id; 
        if(salesQuoteId != null){
            newQuote.RecordTypeId = salesQuoteId;
        }
        newQuote.Contact__c = oppy.Customer_Contact_Name__c;
        newQuote.Name = oppy.Name + String.valueOf(Date.today()).substring(0, 10);
        newQuote.Account_Name__c = oppy.AccountId;
        newQuote.Opportunity_Name__c = oppy.Id;
        newQuote.SAP_Quote_Number__c = 'test1'; 
        insert newQuote;
        Energy_Quote__c newQuote2 = new Energy_Quote__c();
        newQuote2.RecordTypeId = salesQuoteId;
        newQuote2.Contact__c = oppy.Customer_Contact_Name__c;
        newQuote2.Name = oppy.Name + String.valueOf(Date.today()).substring(0, 10);
        newQuote2.Account_Name__c = oppy.AccountId;
        newQuote2.Opportunity_Name__c = oppy.Id;
        newQuote2.SAP_Quote_Number__c = 'test2';
        insert newQuote2;
        Test.stopTest();
	}
	
    static testMethod void testCopyApprovedLineItemsToOppyParts() {
    	Account vAccount = ClsTestHelp.createTestAccounts();
        vAccount.Name = 'AMP Iron Foundries Inc';
        vAccount.AnnualRevenue = 2000000.11; 
        vAccount.Legally_Restricted__c = false;  
        vAccount.BillingCity = 'Shanghai';  
        vAccount.BillingCountry = 'China';
        vAccount.AccountNumber = '123456789';
        vAccount.BillingState = '000000';
        vAccount.BillingStreet = 'Changning';
        vAccount.BillingPostalCode = '200051';
        vAccount.RecordTypeId = ClsTestHelp.createTestRecordType6().Id;
        vAccount.BU_Owner_Email__c = 'testMail@oinio.com';
        insert vAccount;
        
        RecordType rt = ClsTestHelp.createTestRecordType32();            
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'testOppy2';
        oppy.RecordTypeId = rt.id;
        oppy.StageName = 'Lost';
        oppy.CurrencyISOCode = 'EUR';
        oppy.AccountId = vAccount.Id;
        insert oppy;
        System.debug('query num1+++'+ Limits.getQueries());
        /** create test product hierarchy */
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Name = '123';
        ph.CBC2__c = '30012';
        ph.CBC3__c = '30033';
        ph.CBC1_Description__c = 'Appliances';
        insert ph;
        System.debug('query num2+++'+ Limits.getQueries());
        /** create test part */
        Part__c part = new Part__c();
        part.Name = 'testPart';
        part.GPL__c = ph.Id;
        part.Product_Hierarchy__c = ph.Id; 
        part.Description__c = 'test';
        part.PRODUCT_CDE__c = 'TEST1';
        part.PROD_NAME__c = 'test name1';
        insert part;
        Test.startTest();
        Opportunity_Part__c op =  ClsTestHelp.createTestEnergyOpportunityPart();
        op.Opportunity__c = oppy.Id;
        op.Part__c = part.Id;
        insert op;
        System.debug('query num5+++'+ Limits.getQueries());
        Energy_Quote__c newQuote = new Energy_Quote__c();
        Id salesQuoteId = ClsTestHelp.getSalesQuoteRecType().Id; 
        if(salesQuoteId != null){
            newQuote.RecordTypeId = salesQuoteId;
        }
        newQuote.Contact__c = oppy.Customer_Contact_Name__c;
        newQuote.Name = oppy.Name + String.valueOf(Date.today()).substring(0, 10);
        newQuote.Account_Name__c = oppy.AccountId;
        newQuote.Opportunity_Name__c = oppy.Id;
        insert newQuote;
        
        Energy_Quote_Line_Item__c item = new Energy_Quote_Line_Item__c();
        item.Energy_Quote_Name__c = newQuote.Id;
        item.Quantity__c = 25;
        item.Part__c = op.Part__c;
        item.UnitPrice__c = 2;
        item.Product_Hierarchy__c = ph.Id;
        item.Price_List__c = op.Sales_Price__c;
        item.Product_Hierarchy__c = op.GPL__c;
        insert item;
        newQuote.Approval_Status__c = 'Won';
        newQuote.Reason_of_Win__c = 'Other';
        update newQuote;
        Test.stopTest();
    }
}