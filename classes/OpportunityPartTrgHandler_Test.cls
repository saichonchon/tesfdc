/*------------------------------------------------------------
Author:        Wenxuan Qin <wenxuan.qin@capgemini.com>
Description:   A test class for OpportunityPartTrgHandler.cls.
			   The user story number is W-00018, W-00459.
Inputs:        
Test Class:    
History
2017-08-29 Wenxuan Qin <wenxuan.qin@capgemini.com> Created
------------------------------------------------------------*/
@isTest
private class OpportunityPartTrgHandler_Test {
	
	@testSetup static void testCreateConfig(){
		ClsTestCustomSettingHelper.getADMTerritoryCode();
		ClsTestHelp.createTestOPTG4();
    	ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        Channelinsightdata_test.Channelinsightdata_test();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String session=UserInfo.getSessionId();
        ClsTestCustomSettingHelper.getBestPriceWebspeedSetting();
        BestPriceWebspeed__c bestPriceMfg = BestPriceWebspeed__c.getInstance('QAD-MFGProUrl');
        req.requestURI = bestPriceMfg.URL__c;  
        req.addParameter('sessionid', session);
        req.addParameter('part','1234567');
        req.addParameter('qty', '5');
        req.addParameter('customer', '1wer2547');
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res; 
	}
	
    public class MockHTTPResponseGenerator implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {     
           HTTPResponse res = new HTTPResponse();
           res.setHeader('Content-Type', 'application/json');
           res.setStatusCode(200);          
           res.setBody('<result><customer>505528</customer><part>406490-000</part><qty>6</qty><bestlistprice>0</bestlistprice></result>');
           return res;
        }
    }
    
    static testMethod void testMethod0() {
    	ClsTestCustomSettingHelper.getTriggerDisableUserIdSetting();
        Account testAcct1 = ClsTestHelp.createTestAccounts();
        testAcct1.AccountNumber = 'test';
        testAcct1.Company_Number__c = 'test';
        insert testAcct1;
        //create Opportunity
        RecordType oppyRecordType = ClsTestHelp.createTestRecordType32();
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'TestOppy1';
        oppy.AccountId = testAcct1.Id;
        oppy.RecordTypeId = oppyRecordType.Id;
        oppy.ERP_for_Pricing__c = 'ANZPAC';
        oppy.Type__c = 'Opportunity';
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
        ClsTriggerFactory.setSkipHandler('OpportunityForecastTrgHandler',true);
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestENGOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy.id;
        oppyForecast.Fiscal_Month__c = '09';
        oppyForecast.Amount__c = 100.09;
        oppyForecast.Fiscal_Year__c = '2017';
        insert oppyForecast;
        Customer_Part_Number__c cpn = ClsTestHelp.createTestCustomerPartNumber();
        cpn.Part_Number__c = 'test';
        cpn.Account__c = testAcct1.Id; 
        Test.startTest();
        insert cpn;
        Test.setMock(HttpCalloutMock.class,new MockHTTPResponseGenerator());
        Opportunity_Part__c oppypart = ClsTestHelp.createTestEnergyOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppyPart.Part__c = part.Id;
		//test SetOppyPartTotalCostAndPrice method
        oppypart.Quantity__c = 1;
        oppypart.Standard_Cost__c = 1;
        //test syncCustomPartNum method
        oppypart.Part_Number__c = 'test';
        //test assignLineItemMargin price & updateOppyMargin methods 
        oppypart.Offered_Price__c = 2;
        //test getMaxNumber method
        List<Integer> list_Integers = new List<Integer>{1,2,3,4,5};
        Integer maxNumber = OpportunityPartTrgHandler.getMaxNumber(list_Integers);
        System.assert(maxNumber == 5, 'The result is not expected from method getMaxNumber');
        insert oppypart;
        Test.stopTest();        
    }
    
    static testMethod void testMethod1() {
        Account testAcct1 = ClsTestHelp.createTestAccounts();
        testAcct1.AccountNumber = 'test';
        testAcct1.Company_Number__c = 'test';
        insert testAcct1;
        //create Opportunity
        RecordType oppyRecordType = ClsTestHelp.createTestRecordType32();
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'TestOppy1';
        oppy.AccountId = testAcct1.Id;
        oppy.RecordTypeId = oppyRecordType.Id;
        oppy.ERP_for_Pricing__c = 'ANZPAC';
        oppy.Type__c = 'Opportunity';
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
        ClsTriggerFactory.setSkipHandler('OpportunityForecastTrgHandler',true);
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestENGOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy.id;
        oppyForecast.Fiscal_Month__c = '09';
        oppyForecast.Amount__c = 100.09;
        oppyForecast.Fiscal_Year__c = '2017';
        insert oppyForecast;
        Customer_Part_Number__c cpn = ClsTestHelp.createTestCustomerPartNumber();
        cpn.Part_Number__c = 'test';
        cpn.Account__c = testAcct1.Id;
        Test.startTest();
        insert cpn;
        Test.setMock(HttpCalloutMock.class,new MockHTTPResponseGenerator());
        Opportunity_Part__c oppypart = ClsTestHelp.createTestEnergyOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppyPart.Part__c = part.Id;
		//test SetOppyPartTotalCostAndPrice method
        oppypart.Quantity__c = 1;
        oppypart.Standard_Cost__c = 0;
        //test syncCustomPartNum method
        oppypart.Part_Number__c = 'test';
        //test assignLineItemMargin price & updateOppyMargin methods 
        oppypart.Offered_Price__c = 2;
        //test getMaxNumber method
        insert oppypart;
        Test.stopTest();        
    }
    
    static testMethod void testMethod2() {
    	Account testAcct1 = ClsTestHelp.createTestAccounts();
        testAcct1.AccountNumber = 'test';
        testAcct1.Company_Number__c = 'test';
        testAcct1.Source_System__c = 36;
        insert testAcct1;
        //create Opportunity
        RecordType oppyRecordType = ClsTestHelp.createTestRecordType32();
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'TestOppy1';
        oppy.AccountId = testAcct1.Id;
        oppy.RecordTypeId = oppyRecordType.Id;
        //oppy.StageName = 'Won';
        oppy.CloseDate = Date.today();
        insert oppy;
        
        Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial'; 
        insert ph;
        
        Part__c part = ClsTestHelp.createTestPart();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        part.Name = 'test';
        insert part;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,new MockHTTPResponseGenerator());
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestENGOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy.id;
        oppyForecast.Fiscal_Month__c = '09';
        oppyForecast.Amount__c = 100.09; 
        oppyForecast.Fiscal_Year__c = '2017';
        ClsTriggerFactory.setSkipHandler('OpportunityForecastTrgHandler',true);
        insert oppyForecast;
        Customer_Part_Number__c cpn = ClsTestHelp.createTestCustomerPartNumber();
        cpn.Part_Number__c = 'test';
        cpn.Account__c = testAcct1.Id;
        insert cpn;
        Opportunity_Part__c oppypart = ClsTestHelp.createTestEnergyOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        //test updateOppyPartForecast method
        oppyPart.Part__c = part.Id;
        oppyPart.Status__c = 'No Bid';
        oppyPart.Quantity__c = 235;
        insert oppyPart;
        Opportunity_Part_Forecast__c oppyPartForecast = ClsTestHelp.createTestOpportunityPartForecast();
        oppyPartForecast.Month__c = 1; 
        oppyPartForecast.Opportunity_Forecast__c = oppyForecast.Id;
        oppyPartForecast.Opportunity_Part__c = oppypart.Id;
        oppyPartForecast.Year__c = '2017';
        insert oppyPartForecast;
        OpportunityPartTrgHandler.isInUpdateOppyPartFraction = false;
        oppyPart.Status__c = 'Pending';
        //oppyPart.Fraction_of_sale__c = 0.80;
        oppyPart.Change_Part_Number__c = '53124';
        oppyPart.Quantity__c = 35;
        update oppypart;
        Test.stopTest();
    }
   	
   	static testMethod void testMethod6() {
    	Account testAcct1 = ClsTestHelp.createTestAccounts();
        testAcct1.AccountNumber = 'test';
        testAcct1.Company_Number__c = 'test';
        testAcct1.Source_System__c = 36;
        insert testAcct1;
        //create Opportunity
        RecordType oppyRecordType = ClsTestHelp.createTestRecordType32();
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'TestOppy1';
        oppy.AccountId = testAcct1.Id;
        oppy.RecordTypeId = oppyRecordType.Id;
        //oppy.StageName = 'Won';
        oppy.CloseDate = Date.today();
        insert oppy;
        
        Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial'; 
        insert ph;
        
        Part__c part = ClsTestHelp.createTestPart();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        part.Name = 'test';
        insert part;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,new MockHTTPResponseGenerator());
        Opportunity_Part__c oppypart = ClsTestHelp.createTestEnergyOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppyPart.Part__c = part.Id;
        oppyPart.Status__c = 'No Bid';
        oppyPart.Quantity__c = 235;
        insert oppyPart;
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
        item.Quantity__c = 25;
        item.Part__c = oppyPart.Part__c;
        item.UnitPrice__c = 2;
        item.Product_Hierarchy__c = ph.Id;
        item.Price_List__c = oppyPart.Sales_Price__c;
        item.Product_Hierarchy__c = oppyPart.GPL__c;
        insert item; 
        oppyPart.Energy_Quote_Line_Item__c = item.Id;
        oppyPart.Quantity__c = 5;
        update oppypart;  
        Test.stopTest();
    }
    
   	static testMethod void testMethod4() {
    	Account testAcct1 = ClsTestHelp.createTestAccounts();
        testAcct1.AccountNumber = 'test';
        testAcct1.Company_Number__c = 'test';
        testAcct1.Source_System__c = 36;
        insert testAcct1;
        //create Opportunity
        RecordType oppyRecordType = ClsTestHelp.createTestRecordType32();
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'TestOppy1';
        oppy.AccountId = testAcct1.Id;
        oppy.RecordTypeId = oppyRecordType.Id;
        //oppy.StageName = 'Won';
        oppy.CloseDate = Date.today();
        insert oppy;
        
        Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial'; 
        insert ph;
        
        Part__c part = ClsTestHelp.createTestPart();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        part.Name = 'test';
        insert part;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,new MockHTTPResponseGenerator());
        Customer_Part_Number__c cpn = ClsTestHelp.createTestCustomerPartNumber();
        cpn.Part_Number__c = 'test';
        cpn.Account__c = testAcct1.Id;
        insert cpn;
        Opportunity_Part__c oppypart = ClsTestHelp.createTestEnergyOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppyPart.Part__c = part.Id;
        oppyPart.Status__c = 'Pending';
        oppyPart.Quantity__c = 1;
        oppyPart.Offered_Price__c = 1;
        Opportunity_Part__c oppypart2 = ClsTestHelp.createTestEnergyOpportunityPart();
        oppypart2.Opportunity__c = oppy.Id;
        oppyPart2.Part__c = part.Id;
        oppyPart2.Status__c = 'Pending';
        oppyPart2.Quantity__c = 2;
        oppyPart2.Offered_Price__c = 2;
        insert new List<Opportunity_Part__c>{oppyPart,oppyPart2};
        Test.stopTest();
    }
    
	static testMethod void testMethod3() {
        Account testAcct1 = ClsTestHelp.createTestAccounts();
        testAcct1.AccountNumber = 'test';
        testAcct1.Source_System__c = 36;
        testAcct1.Company_Number__c = 'test';
        insert testAcct1;
        //create Opportunity
        RecordType oppyRecordType = ClsTestHelp.createTestRecordType32();
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'TestOppy1';
        oppy.AccountId = testAcct1.Id;
        oppy.RecordTypeId = oppyRecordType.Id;
        oppy.currencyISOCode = 'EUR';
        //oppy.StageName = 'Won';
        oppy.CloseDate = Date.today();
        insert oppy;
        
        Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial'; 
        insert ph;
        
        Part__c part = ClsTestHelp.createTestPart();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        part.Name = 'test';
        insert part;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,new MockHTTPResponseGenerator());
        Opportunity_Part__c oppypart = ClsTestHelp.createTestEnergyOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        //test updateOppyPartForecast method
        oppyPart.Part__c = part.Id;
        oppyPart.Sales_Price__c = 230;
        oppyPart.currencyISOCode = 'USD';
        insert oppyPart;
        OpportunityPartTrgHandler.isInUpdateOppyPartFraction = false;
        oppypart.Change_Part_Number__c = '12345';
        oppypart.NDR_Item_Price_Per__c = '2';
        update oppypart;
        Test.stopTest();      
    }   
    
    static testMethod void testMethod5() {
        Account testAcct1 = ClsTestHelp.createTestAccounts();
        testAcct1.AccountNumber = 'test';
        testAcct1.Company_Number__c = 'test';
        testAcct1.Source_System__c = 36;
        insert testAcct1;
        //create Opportunity
        RecordType oppyRecordType = ClsTestHelp.createTestRecordType32();
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'TestOppy1';
        oppy.AccountId = testAcct1.Id;
        oppy.RecordTypeId = oppyRecordType.Id;
        oppy.CloseDate = Date.today();
        insert oppy;
        Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial'; 
        insert ph;
        
        Part__c part = ClsTestHelp.createTestPart();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        part.Name = 'test';
        insert part;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,new MockHTTPResponseGenerator());
        Opportunity_Part__c oppypart = ClsTestHelp.createTestEnergyOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = part.Id;
        //test updateOppyPartForecast method
        insert oppyPart;
        OpportunityPartTrgHandler.isInUpdateOppyPartFraction = false;
        oppypart.Change_Part_Number__c = '54321';
        update oppypart;
        Test.stopTest();      
    }  
    
    static testMethod void testMethodForDelete() {
    	Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial'; 
        insert ph;
        
        Part__c part = ClsTestHelp.createTestPart();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        part.Name = 'test';
        insert part;
        Account testAcct1 = ClsTestHelp.createTestAccounts();
        testAcct1.AccountNumber = 'test';
        testAcct1.Company_Number__c = 'test';
        testAcct1.Source_System__c = 36;
        insert testAcct1;
        //create Opportunity
        RecordType oppyRecordType = ClsTestHelp.createTestRecordType32();
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'TestOppy1';
        oppy.AccountId = testAcct1.Id;
        oppy.RecordTypeId = oppyRecordType.Id;
        oppy.CloseDate = Date.today();
        insert oppy;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,new MockHTTPResponseGenerator());
        list<Opportunity_Part__c> list_opp = new list<Opportunity_Part__c>();
        Opportunity_Part__c oppypart = ClsTestHelp.createTestEnergyOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = part.Id;
        //test updateOppyPartForecast method
        list_opp.add(oppyPart);
        Opportunity_Part__c oppypart2 = ClsTestHelp.createTestEnergyOpportunityPart();
        oppypart2.Opportunity__c = oppy.Id;
        oppypart2.Part__c = part.Id;
        list_opp.add(oppypart2);
        insert list_opp;
        OpportunityPartTrgHandler.isInUpdateOppyPartFraction = false;
        delete oppypart;
        Test.stopTest();      
    }  
    
    static testMethod void testChangePartNumberHasValueAction() {
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'TestOppy2';
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        oppy.Approval_Status__c = 'Approved';
        oppy.NDR_Quote_Document_Number__c = 'testNum';
        oppy.SAP_Quote_Type__c = 'Small Quote';
        oppy.ERP_For_Pricing__c = 'SAP (except ANZPAC)';
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
        
        Opportunity_Part__c op =  ClsTestHelp.createTestEnergyOpportunityPart();
        op.Opportunity__c = oppy.Id;
        op.Part__c = part.Id;
        op.Quantity__c = 20;
        Opportunity_Part__c op2 =  ClsTestHelp.createTestEnergyOpportunityPart();
        op2.Opportunity__c = oppy.Id;
        op2.Part__c = part.Id;
        op2.Quantity__c = 30;
        op2.Change_Part_Number__c = '134354';
        ExtOppyPartDiscounting.isEnergyPartManagementSave = true;
        insert new List<Opportunity_Part__c>{op,op2};
        Opportunity_Part__c op22 = [select Id,Part_Number_txt__c,
        							Opportunity__c,Part__c,Change_Part_Number__c 
        							 from Opportunity_Part__C where Id =: op2.Id limit 1];
        Test.startTest();
        ClsWrappers.TriggerContext trgCtx = new ClsWrappers.TriggerContext();
        trgCtx.isBefore = true;
        trgCtx.isUpdate = true;
        trgCtx.newList = new list<Opportunity_Part__c>();
        trgCtx.newList.add(op22);
        trgCtx.newMap = new map<Id,Opportunity_Part__c>();
        trgCtx.newMap.put(op22.Id,op22);
        trgCtx.oldMap = new map<Id,Opportunity_Part__c>();
        trgCtx.oldMap.put(op22.Id,op);
        OpportunityPartTrgHandler.changePartNumberHasValueAction(trgCtx);
        Test.stopTest();
    }
    
    static testMethod void testResetBookprice() {
    	map<Id, Opportunity> map_oppyId_oppys = new map<Id, Opportunity>();
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'TestOppy2';
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        oppy.Approval_Status__c = 'Approved';
        oppy.NDR_Quote_Document_Number__c = 'testNum';
        oppy.SAP_Quote_Type__c = 'Small Quote';
        oppy.ERP_For_Pricing__c = 'SAP (except ANZPAC)';
        insert oppy;  
        map_oppyId_oppys.put(oppy.Id, oppy);
        
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
        
        Opportunity_Part__c op =  ClsTestHelp.createTestEnergyOpportunityPart();
        op.Opportunity__c = oppy.Id;
        op.Part__c = part.Id;
        op.Quantity__c = 20;
        Opportunity_Part__c op2 =  ClsTestHelp.createTestEnergyOpportunityPart();
        op2.Opportunity__c = oppy.Id;
        op2.Part__c = part.Id;
        op2.Quantity__c = 30;
        op2.Change_Part_Number__c = '134354';
        ExtOppyPartDiscounting.isEnergyPartManagementSave = true;
        insert new List<Opportunity_Part__c>{op,op2};
        Opportunity_Part__c op22 = [select Id,Part_Number_txt__c,Quantity__c,
        							Opportunity__c,Part__c,Change_Part_Number__c,isCloned__c,Status__c 
        							 from Opportunity_Part__C where Id =: op2.Id limit 1];
        Test.startTest();
        ClsWrappers.TriggerContext trgCtx = new ClsWrappers.TriggerContext();
        trgCtx.isAfter = true;
        trgCtx.isUpdate = true;
        trgCtx.newList = new list<Opportunity_Part__c>();
        trgCtx.newList.add(op22);
        trgCtx.newMap = new map<Id,Opportunity_Part__c>();
        trgCtx.newMap.put(op22.Id,op22);
        trgCtx.oldMap = new map<Id,Opportunity_Part__c>();
        trgCtx.oldMap.put(op22.Id,op);
        OpportunityPartTrgHandler.resetBookprice(trgCtx, map_oppyId_oppys,new map<Id, Opportunity_Part__c>());
        Test.stopTest();
    }
    
    static testMethod void testSetChangedSinceQuoteIntegration() {
        //create Opportunity
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'TestOppy2';
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        oppy.Approval_Status__c = 'Approved';
        oppy.NDR_Quote_Document_Number__c = 'testNum';
        oppy.SAP_Quote_Type__c = 'Small Quote';
        oppy.ERP_For_Pricing__c = 'SAP (except ANZPAC)';
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
        
        Opportunity_Part__c op =  ClsTestHelp.createTestEnergyOpportunityPart();
        op.Opportunity__c = oppy.Id;
        op.Part__c = part.Id;
        op.Quantity__c = 20;
        Opportunity_Part__c op2 =  ClsTestHelp.createTestEnergyOpportunityPart();
        op2.Opportunity__c = oppy.Id;
        op2.Part__c = part.Id;
        op2.Quantity__c = 30;
        ExtOppyPartDiscounting.isEnergyPartManagementSave = true;
        insert new List<Opportunity_Part__c>{op,op2};
        
        Test.startTest();
        ClsWrappers.TriggerContext trgCtx = new ClsWrappers.TriggerContext();
        trgCtx.isBefore = true;
        trgCtx.isUpdate = true;
        trgCtx.newList = new list<Opportunity_Part__c>();
        trgCtx.newList.add(op2);
        trgCtx.newMap = new map<Id,Opportunity_Part__c>();
        trgCtx.newMap.put(op2.Id,op2);
        trgCtx.oldMap = new map<Id,Opportunity_Part__c>();
        trgCtx.oldMap.put(op2.Id,op);
        OpportunityPartTrgHandler.setChangedSinceQuoteIntegration(trgCtx);
        Test.stopTest();
    }
    
    static testMethod void testAvoidPartMultipleRunning() {
        Test.startTest();
        ClsWrappers.TriggerContext trgCtx = new ClsWrappers.TriggerContext();
        trgCtx.isAfter = true;
        trgCtx.isBefore = false;
        trgCtx.isUpdate = false;
        trgCtx.isInsert = false;
        trgCtx.isDelete = true;
        ClsWrappers.TriggerContext trgCtx2 = new ClsWrappers.TriggerContext();
        trgCtx2.isBefore = true;
        trgCtx2.isAfter = false;
        trgCtx2.isUpdate = false;
        trgCtx2.isInsert = false;
        trgCtx2.isDelete = true;
        ClsWrappers.TriggerContext trgCtx3 = new ClsWrappers.TriggerContext();
        trgCtx3.isAfter = true;
        trgCtx3.isBefore = false;
        trgCtx3.isUpdate = false;
        trgCtx3.isInsert = true;
        trgCtx3.isDelete = false;
        ClsWrappers.TriggerContext trgCtx4 = new ClsWrappers.TriggerContext();
        trgCtx4.isBefore = true;
        trgCtx4.isAfter = false;
        trgCtx4.isUpdate = false;
        trgCtx4.isInsert = true;
        trgCtx4.isDelete = false;
        Boolean isAvoidRunning = OpportunityPartTrgHandler.avoidOppyPartMultipleRunning(trgCtx);
        System.assert(!isAvoidRunning);
        Boolean isAvoidRunning2 = OpportunityPartTrgHandler.avoidOppyPartMultipleRunning(trgCtx2);
        System.assert(!isAvoidRunning2);
        isAvoidRunning = OpportunityPartTrgHandler.avoidOppyPartMultipleRunning(trgCtx);
        System.assert(isAvoidRunning);
        isAvoidRunning2 = OpportunityPartTrgHandler.avoidOppyPartMultipleRunning(trgCtx2);
        System.assert(isAvoidRunning2);
        isAvoidRunning = OpportunityPartTrgHandler.avoidOppyPartMultipleRunning(trgCtx3);
        System.assert(!isAvoidRunning);
        isAvoidRunning2 = OpportunityPartTrgHandler.avoidOppyPartMultipleRunning(trgCtx4);
        System.assert(!isAvoidRunning2);
        isAvoidRunning = OpportunityPartTrgHandler.avoidOppyPartMultipleRunning(trgCtx3);
        System.assert(isAvoidRunning);
        isAvoidRunning2 = OpportunityPartTrgHandler.avoidOppyPartMultipleRunning(trgCtx4);
        System.assert(isAvoidRunning2);
        Test.stopTest();
    }
}