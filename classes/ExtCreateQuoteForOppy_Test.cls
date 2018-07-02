@isTest
private class ExtCreateQuoteForOppy_Test {
	@testSetup static void testConfig(){
		ClsTestCustomSettingHelper.getApex_Helper_Settings();
    	ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
    	ClsTestCustomSettingHelper.getOpportunity_Approvers();
    	ClsTestCustomSettingHelper.getTrigger_Configuration();
    	ClsTestCustomSettingHelper.getProfitBUCenterMapping();
    	ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
    	ClsTestCustomSettingHelper.getQuoteValiditySetting();
    	ClsTestCustomSettingHelper.getQuoteExpirationSetting();
    	ClsTestCustomSettingHelper.getADMTerritoryCode();
    	ClsTestCustomSettingHelper.getEnergyControlSetting();
    	ClsTestHelp.createTestOrgWideSettings1();
    	ClsTestHelp.createTestOPTG4();
	}
	
	static testMethod void myUnitTest() {
        // TO DO: implement unit test
        User u = ClsTestHelp.createTestUsers();
        u.Quote_Language__c = 'English';
        insert u;
        System.runAs(u) {
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
        
        	Contact cContact = ClsTestHelp.createTestContacts();
        	cContact.AccountId = vAccount.Id;
        	insert cContact;
        
        	Opportunity oppy = ClsTestHelp.createTestOpportunity();
        	oppy.Name = 'testOppy1';
        	oppy.AccountId = vAccount.Id;
        	oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        	oppy.Customer_Contact_Name__c = cContact.Id;
        	oppy.End_Customer__c = vAccount.Id;
        	oppy.Quote_Type__c = 'Meet Competitor Price';
        	oppy.Approval_Status__c = 'Awaiting Approval';
        	//oppy.Language_of_Quote__c='English';
        	oppy.Days_prices_valid__c = '120 Days';
        	oppy.NDR_Quote_Document_Number__c = '1234';
        	oppy.ERP_For_Pricing__c = 'SAP (except ANZPAC)';
        	oppy.Valid_From__c = date.newInstance(2017,10,25);
        	insert oppy;
        	Test.startTest();
        	ExtCreateQuoteForOppy create4Oppy = new ExtCreateQuoteForOppy(new ApexPages.StandardController(oppy));
        	Test.stopTest();
    	}
	}
	
    static testMethod void myUnitTest2() {
        // TO DO: implement unit test
        User u = ClsTestHelp.createTestUsers();
        u.Quote_Language__c = 'English';
        insert u;
        System.runAs(u) {
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
        
        	Contact cContact = ClsTestHelp.createTestContacts();
        	cContact.AccountId = vAccount.Id;
        	insert cContact;
        
        	Opportunity oppy = ClsTestHelp.createTestOpportunity();
        	oppy.Name = 'testOppy1';
        	oppy.AccountId = vAccount.Id;
        	oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        	oppy.Customer_Contact_Name__c = cContact.Id;
        	oppy.End_Customer__c = vAccount.Id;
        	oppy.ERP_For_Pricing__c = 'SAP (except ANZPAC)'; 
        	oppy.SAP_Quote_Type__c = 'Small Quote';
        	oppy.Quote_Type__c = 'Meet Competitor Price';
        	oppy.Approval_Status__c = 'Awaiting Approval';
        	//oppy.Language_of_Quote__c='English';
        	oppy.Days_prices_valid__c = '120 Days';
        	oppy.Valid_From__c = date.newInstance(2017,10,25);
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
        
       	 	Energy_Quote__c newQuote = ClsTestHelp.createTestEnergyQuote();
        	Id salesQuoteId = ClsTestHelp.getSalesQuoteRecType().Id;
        	if(salesQuoteId != null){
        		newQuote.RecordTypeId = salesQuoteId;
        	}
        	newQuote.Contact__c = oppy.Customer_Contact_Name__c;
        	newQuote.Name = oppy.Name + String.valueOf(Date.today()).substring(0, 10);
        	newQuote.Account_Name__c = oppy.AccountId;
        	newQuote.Opportunity_Name__c = oppy.Id;
       	 	insert newQuote;
        
        	Energy_Quote_Line_Item__c item = ClsTestHelp.createTestEnergyQuoteLineItem();
        	item.Energy_Quote_Name__c = newQuote.Id;
        	//item.CurrencyIsoCode = newQuote.CurrencyIsoCode;
        	item.Quantity__c = 25;
        	//item.Part_Number__c = op.Name;
        	//item.Part__c = op.Part__c;
        	//item.Opportunity_Part__c = oppPart.Id;
        	item.UnitPrice__c = 2;
        	item.Product_Hierarchy__c = ph.Id;
        	//item.Price_List__c = op.Sales_Price__c;
        	//item.Product_Hierarchy__c = op.GPL__c;
        	insert item;
   
        	Test.startTest();
        	ExtOppyPartDiscounting.isEnergyPartManagementSave = true;
        	Opportunity_Part__c oppPart = ClsTestHelp.createTestEnergyOpportunityPart();
        	oppPart.opportunity__c = oppy.Id;
        	oppPart.Energy_Quote_Line_Item__c = item.Id;
        	oppPart.part__c = part.Id;
        	oppPart.NDR_Competitor_Name__c = 'Test Name';
        	oppPart.Competitor_Price__c = 12;
        	insert oppPart;
        	
        	ExtCreateQuoteForOppy create4Oppy = new ExtCreateQuoteForOppy(new ApexPages.StandardController(oppy));
        	create4Oppy.validator();
        	create4Oppy.createQuote();
        	Test.stopTest();
        	System.assert(create4Oppy.isHasError == false);
    	}
	}
	
	static testMethod void myUnitTest3() {
        // TO DO: implement unit test
        User u = ClsTestHelp.createTestUsers();
        u.Quote_Language__c = 'English';
        insert u;
        System.runAs(u) {
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
        
        	Contact cContact = ClsTestHelp.createTestContacts();
        	cContact.AccountId = vAccount.Id;
        	insert cContact;
        
        	Opportunity oppy = ClsTestHelp.createTestOpportunity();
        	oppy.Name = 'testOppy1';
        	oppy.AccountId = vAccount.Id;
        	oppy.StageName = 'Initiation';
        	oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        	oppy.Customer_Contact_Name__c = cContact.Id;
        	oppy.End_Customer__c = vAccount.Id;
        	oppy.Quote_Type__c = 'Meet Competitor Price';
        	oppy.Approval_Status__c = 'Awaiting Approval';
        	//oppy.Language_of_Quote__c='English';
        	oppy.Days_prices_valid__c = '120 Days';
        	oppy.Valid_From__c = date.newInstance(2017,10,25);
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
        
       	 	Energy_Quote__c newQuote = ClsTestHelp.createTestEnergyQuote();
        	Id salesQuoteId = ClsTestHelp.getSalesQuoteRecType().Id; 
        	if(salesQuoteId != null){
        		newQuote.RecordTypeId = salesQuoteId;
        	}
        	newQuote.Contact__c = oppy.Customer_Contact_Name__c;
        	newQuote.Name = oppy.Name + String.valueOf(Date.today()).substring(0, 10);
        	newQuote.Account_Name__c = oppy.AccountId;
        	newQuote.Opportunity_Name__c = oppy.Id;
       	 	insert newQuote;
        
        	Energy_Quote_Line_Item__c item = ClsTestHelp.createTestEnergyQuoteLineItem();
        	item.Energy_Quote_Name__c = newQuote.Id;
        	//item.CurrencyIsoCode = newQuote.CurrencyIsoCode;
        	item.Quantity__c = 25;
        	//item.Part_Number__c = op.Name;
        	//item.Part__c = op.Part__c;
        	//item.Opportunity_Part__c = oppPart.Id;
        	item.UnitPrice__c = 2;
        	item.Product_Hierarchy__c = ph.Id;
        	//item.Price_List__c = op.Sales_Price__c;
        	//item.Product_Hierarchy__c = op.GPL__c;
        	insert item;
   
        	Test.startTest();
        	ExtOppyPartDiscounting.isEnergyPartManagementSave = true;
        	Opportunity_Part__c oppPart = ClsTestHelp.createTestEnergyOpportunityPart();
        	oppPart.opportunity__c = oppy.Id;
        	oppPart.Energy_Quote_Line_Item__c = item.Id;
        	oppPart.part__c = part.Id;
        	oppPart.NDR_Competitor_Name__c = null;
        	oppPart.NDR_Competitor_Part_Number__c = '1234';
        	oppPart.Competitor_Price__c = 12;
        	insert oppPart;
        	
        	ExtCreateQuoteForOppy create4Oppy = new ExtCreateQuoteForOppy(new ApexPages.StandardController(oppy));
        	create4Oppy.validator();
        	create4Oppy.createQuote();
        	Test.stopTest();
        	System.assert(create4Oppy.isHasError == true);
    	}
	}
	
	static testMethod void myUnitTest4() {
		 User u = ClsTestHelp.createTestUsers();
         u.Quote_Language__c = 'English';
        insert u;
        System.runAs(u) {
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
        
        	Contact cContact = ClsTestHelp.createTestContacts();
        	cContact.AccountId = vAccount.Id;
        	insert cContact;
        
        	Opportunity oppy = ClsTestHelp.createTestOpportunity();
        	oppy.Name = 'testOppy1';
        	oppy.AccountId = vAccount.Id;
        	oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        	oppy.Customer_Contact_Name__c = cContact.Id;
        	oppy.End_Customer__c = vAccount.Id;
        	oppy.Quote_Type__c = 'Meet Competitor Price';
        	oppy.Approval_Status__c = 'Awaiting Approval';
        	//oppy.Language_of_Quote__c='English';
        	oppy.Days_prices_valid__c = '120 Days';
        	oppy.Valid_From__c = date.newInstance(2017,10,25);
        	insert oppy;
        
        	/** create test product hierarchy */
        	/*Product_Hierarchy__c ph = new Product_Hierarchy__c();
        	ph.Name = '123';
        	ph.CBC2__c = '30012';
        	ph.CBC3__c = '30033';
        	ph.CBC1_Description__c = 'Appliances';
        	insert ph;*/
        
        	/** create test part */
        	/*Part__c part = new Part__c();
        	part.Name = 'testPart';
        	part.GPL__c = ph.Id;
        	part.Product_Hierarchy__c = ph.Id; 
        	part.Description__c = 'test';
        	part.PRODUCT_CDE__c = 'TEST1';
        	part.PROD_NAME__c = 'test name1';
        	insert part;
        
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
        	//item.CurrencyIsoCode = newQuote.CurrencyIsoCode;
        	item.Quantity__c = 25;
        	//item.Part_Number__c = op.Name;
        	//item.Part__c = op.Part__c;
        	//item.Opportunity_Part__c = oppPart.Id;
        	item.UnitPrice__c = 2;
        	item.Product_Hierarchy__c = ph.Id;
        	//item.Price_List__c = op.Sales_Price__c;
        	//item.Product_Hierarchy__c = op.GPL__c;
        	insert item;*/
   
        	Test.startTest();
        	
        	ExtCreateQuoteForOppy create4Oppy = new ExtCreateQuoteForOppy(new ApexPages.StandardController(oppy));
        	create4Oppy.validator();
        	create4Oppy.createQuote();
        	create4Oppy.saveQuotePdf();
        	Test.stopTest();
        	System.assert(create4Oppy.isHasError == false);
    	}
	}
    
     static testMethod void testCallSAPtoCreateQuote(){
	    	User u = ClsTestHelp.createTestUsers();
	        insert u;
	        System.runAs(u) {
	        	ClsTestCustomSettingHelper.getSAPInstanceSetting();
	        	ClsTestCustomSettingHelper.getSAPBestPriceWebspeedSetting();
	        	
	        	Account acct = ClsTestHelp.createTestAccounts();
	        	acct.Name = 'AMP Iron Foundries Inc';
	        	acct.AnnualRevenue = 2000000.11; 
	        	acct.Legally_Restricted__c = false;  
	        	acct.BillingCity = 'Shanghai';  
	        	acct.BillingCountry = 'China';
	        	acct.BillingState = '000000';
	        	acct.BillingStreet = 'Changning asdfasdfasdfasdfasdfsadfasdfasdfasdfasdfasdfasdfasdfsa';
	        	acct.BillingPostalCode = '200051';
	       	 	acct.BU_Owner_Email__c = 'testMail@oinio.com';
	       	 	acct.AccountNumber = '123123';
	        	insert acct;
	        	Opportunity oppy = ClsTestHelp.createTestOpportunity();
	        	oppy.Name = 'testOppy2';
	        	oppy.AccountId = acct.Id;
	        	oppy.Check_Unit_Price__c = true;
	        	oppy.End_Customer__c = acct.Id;
	        	oppy.Quote_Type__c = 'Meet Competitor Price';
	        	oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
	        	insert oppy; 
	        	Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
	    		ph.Name = '123';
	    		ph.CBC2__c = '30012';
	    		ph.CBC3__c = '30033';
	    		ph.CBC1_Description__c = 'Appliances';
	        	insert ph;
	        	Part__c part = ClsTestHelp.createTestPart();
	    		part.Name = 'testPart';
	    		part.GPL__c = ph.Id;
	    		part.Product_Hierarchy__c = ph.Id; 
	    		part.Description__c = 'test';
	    		part.PRODUCT_CDE__c = 'TEST1';
	    		part.PROD_NAME__c = 'test name1';
	    		insert part;
	        	Opportunity_Part__c op =  ClsTestHelp.createTestOpportunityPart();
	        	op.Opportunity__c = oppy.Id;
	        	op.Part__c = part.Id;
	        	op.Quantity__c = 20;
	        	op.Offered_Price__c = 1;
	        	op.Discount_A__c = 1;
	        	op.No_Bid__c = true;
	        	op.Check_Unit_Price__c = true;
	        	op.Status__c = null;
	        	op.Qty_PIP__c = 1;
	        	op.ANZ_Quantity__c = 0;
	        	op.ANZ_Percentage__c = '1';
	        	op.Sales_Price__c = 100;
	        	op.Pieces_in_Pack__c = 0;
	        	op.Product_Line__c = 'All'; 
	        	system.debug('query :::1  ' + limits.getQueries());
	        	Test.startTest();
	        	ClsTriggerFactory.setSkipHandler('AccountTrgHandler',true); 
	        	ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);
	        	ExtOppyPartDiscounting.isEnergyPartManagementSave = true;
	        	insert op;
	        	system.debug('query :::2  ' + limits.getQueries());
	        	ExtCreateQuoteForOppy create4Oppy = new ExtCreateQuoteForOppy(new ApexPages.StandardController(oppy));
	        	ExtCreateQuoteForOppy.handleNull('test');
	        	ExtCreateQuoteForOppy.getDateAs8CharString(system.today());
	        	ExtCreateQuoteForOppy.callSAPtoCreateQuote(oppy.Id);
				Test.stopTest();
				System.assert(create4Oppy.isHasError == false);
	    }
    }
}