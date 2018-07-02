/*------------------------------------------------------------
	Author:        Jinliang Chen <jinliang.chen@capgemini.com> 
	Description:   Unit test class for class ExtOppyPartDiscounting
	Inputs:        
	Test Class:    
	History
	2017-08-04     Jinliang Chen <jinliang.chen@capgemini.com> Created
	------------------------------------------------------------*/
@isTest
public class ExtOppyPartDiscountingTest {
	
	public class MockHTTPResponseGenerator implements HttpCalloutMock {
      	public HTTPResponse respond(HTTPRequest req) {     
           HTTPResponse res = new HTTPResponse();
           res.setHeader('Content-Type', 'application/json');
           res.setStatusCode(200);          
           res.setBody('<result><customer>505528</customer><part>406490-000</part><qty>6</qty><bestlistprice>0</bestlistprice></result>');
           return res;
        }
	}
	
	@testSetup static void createConfig(){
		ClsTestCustomSettingHelper.getApex_Helper_Settings();
     	ClsTestCustomSettingHelper.getProfitBUCenterMapping();
     	ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
     	ClsTestCustomSettingHelper.getOpportunity_Approvers();
     	ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
     	ClsTestCustomSettingHelper.getADMTerritoryCode();
     	ClsTestHelp.createTestOrgWideSettings1();
     	ClsTestHelp.createTestOPTG4();
	}
	
    static testMethod void testExtOppyPartDiscounting(){    
         /** create test user */ 
    	 User u = ClsTestHelp.createTestUsers();
    	 insert u;
         system.runAs(u){
         	/** create test product hierarchy */
         	Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
    		ph.Name = '123';
    		ph.CBC1__c = '13005';
    		ph.CBC2__c = '30012';
    		ph.CBC3__c = '30033';
    		ph.CBC1_Description__c = 'Appliances';
            ph.CBC4_Description__c = 'Appliances';
        	insert ph;
        	/** create test part */
        	Part__c part = ClsTestHelp.createTestPart();
    		part.Name = 'testPart';
    		part.GPL__c = ph.Id;
    		part.Product_Hierarchy__c = ph.Id; 
    		part.Description__c = 'test';
    		part.PRODUCT_CDE__c = 'TEST1';
    		part.IsActive__c = true;
    		part.PROD_NAME__c = 'test name1';
             
            Part__c part2 = ClsTestHelp.createTestPart();
    		part2.Name = 'Other Costs';
    		part2.GPL__c = ph.Id;
    		part2.Product_Hierarchy__c = ph.Id; 
    		part2.Description__c = 'test2';
    		part2.PRODUCT_CDE__c = 'TEST2';
    		part2.PROD_NAME__c = 'test name2';
    		part2.IsActive__c = true;
    		List<Part__c> list_Parts = new List<Part__c>{part,part2};
    		insert list_Parts;
             
            Inventory__c inv = ClsTestHelp.createTestInventory();
            inv.PartNbr__c = part.Id;
            inv.Qty_on_Hand_Grade_Net__c = 0;
            insert inv;
    		/** create test opp */
         	Opportunity opp =  ClsTestHelp.createTestOpportunity();
         	opp.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
         	insert opp;
         	
        	ClsTriggerRecursionDefense.OpportunityAnzClauseTrigger = false;
         	/** create test Opportunity Part */
        	Opportunity_Part__c op =  ClsTestHelp.createTestEnergyOpportunityPart();
        	op.Opportunity__c = opp.Id;
        	op.Part__c = part.Id;
        	insert op;
            Test.startTest();
            Opportunity_Part__c op2 =  ClsTestHelp.createTestEnergyOpportunityPart();
        	op2.recordTypeId = ClsTestHelp.createTestRecordType24().Id;
        	op2.Opportunity__c = opp.Id;
        	op2.Part__c = part.Id;
        	op2.Quantity__c = 20;
        	op2.Offered_Price__c = 2;
        	CBC4_to_PM__c cbc4 = ClsTestHelp.createTestCBC4toPM();
            cbc4.Product_Manager__c = u.Id;
            cbc4.Name = 'Appliances';
            insert cbc4;
        	ClsTestCustomSettingHelper.getBestPriceWebspeedSetting();
        	BestPriceWebspeed__c bp = BestPriceWebspeed__c.getValues('QAD-MFGProUrl'); 
            
        	/** call out ExtOppyPartDiscounting cls */
        	ExtOppyPartDiscounting extOppPartDis = new ExtOppyPartDiscounting(new ApexPages.StandardController(opp));
            extOppPartDis.init();
        	extOppPartDis.list_parts = new list<Part__c>();
        	extOppPartDis.searchText = '';
        	ExtOppyPartDiscounting.innerClassForAdd ina = new ExtOppyPartDiscounting.innerClassForAdd();
        	
        	ExtOppyPartDiscounting.OppIdPartNumber opn = new ExtOppyPartDiscounting.OppIdPartNumber();
        	opn.oppyId = '';
        	opn.partNum = '';
        	
        	/** call out addParts() */
	        RestRequest req = new RestRequest(); 
	        RestResponse res = new RestResponse();
	        
	        String session = UserInfo.getSessionId();
	        req.requestURI = bp.URL__c;  
	        req.addParameter('sessionid', session);
	        req.addParameter('part','1234567');
	        req.addParameter('qty', '5');
	        req.addParameter('customer', '1wer2547');
	        
	        req.httpMethod = 'POST';
	        RestContext.request = req;
	        RestContext.response = res;	
        	Test.setMock(HttpCalloutMock.class,new MockHTTPResponseGenerator());
        	extOppPartDis.str_partIds2AddJson = '["'+String.valueOf(part.Id)+'"]';
        	extOppPartDis.str_partIds2AddJsonWithNum = '[{"partId":"'+part.Id+'","quantity":15}]';
        	extOppPartDis.addParts();
            extOppPartDis.addPartsNewAction();
        	System.assert(extOppPartDis.str_partListJson != ''); 
        	/** create innser class test data */
        	ExtOppyPartDiscounting.OppyPartDiscountItem item = new ExtOppyPartDiscounting.OppyPartDiscountItem();
        	item.str_oppyPartId = String.valueOf(op.Id);
        	item.str_partNumber = '';
        	item.str_partName = '';
        	item.oppyPart = op;
        	item.int_quality = 0;
        	item.partListPrice = 0;
        	item.partSalesPrice = 0;
        	item.partOfferedPrice = 0;
        	item.isRequestedPriceLower = false; 
            item.str_itemNumber = '';
            item.isThisCBC4 = true;
            item.str_CBC4Product = ph.Id;
        	List<ExtOppyPartDiscounting.OppyPartDiscountItem> oppPartDisItems = new List<ExtOppyPartDiscounting.OppyPartDiscountItem>{item};   	
        	/** call out getParts() */
        	extOppPartDis.str_partNumb = 'testPart';
        	extOppPartDis.str_partDescription = 'test';
        	extOppPartDis.getParts();
        	extOppPartDis.getPartsUsingLike();
        	System.assert(extOppPartDis.str_partListJson != null);
            extOppPartDis.str_partNumb = 'testPart,Other Costs';
        	extOppPartDis.str_partDescription = 'test';
        	extOppPartDis.getParts();
        	extOppPartDis.getPartsUsingLike();
            extOppPartDis.str_partNumb = 'testPart,tt';
        	extOppPartDis.str_partDescription = 'test';
        	extOppPartDis.getParts();
        	extOppPartDis.getPartsUsingLike();
        	/** call out saveOppyParts() */
        	extOppPartDis.str_oppyPartJson2Save = 'aaaa';
			extOppPartDis.saveOppyParts();
			
        	extOppPartDis.str_oppyPartJson2Save = JSON.serialize(oppPartDisItems);
        	System.debug('extOppPartDis:::'+extOppPartDis.str_oppyPartJson2Save);
        	extOppPartDis.saveOppyParts();
        	System.assert(extOppPartDis.displayUploadPopup == false); 
        	
        	/** call out upsertOppyPart() */
        	extOppPartDis.str_oppIdPartNumberJson = 'aaaa';
        	extOppPartDis.upsertOppyPart();
        	extOppPartDis.str_oppIdPartNumberJson = JSON.serialize(oppPartDisItems);
        	extOppPartDis.upsertOppyPart();
        	/** call out deleteOppyPart() */
        	extOppPartDis.oppylist_index = 1;        	
        	extOppPartDis.deleteOppyPart();
        	extOppPartDis.oppylist_index = 0;        	
        	extOppPartDis.deleteOppyPart();
        	/** call out other method */
        	extOppPartDis.closeUploadPopup();
        	extOppPartDis.showUploadPopup();
        	extOppPartDis.closePopup();
        	extOppPartDis.showPopup();
            extOppPartDis.str_currencyFromValue = '12';
            extOppPartDis.str_currencyFromCode = 'USD';
            extOppPartDis.str_currencyToCode = 'EUR';
            extOppPartDis.transformIsoCode();
            extOppPartDis.saveERPforPricing();
            list<String> list_delId = new list<String>();
			list_delId.add(op2.Id);
			extOppPartDis.str_deleteOppyPartIds = Json.serialize(list_delId);
            extOppPartDis.deleteOppyParts();
        	Test.stopTest();
        } 
    }
    
    static testMethod void testExtOppyPartDiscounting2(){    
         /** create test user */ 
    	 User u = ClsTestHelp.createTestUsers();
    	 insert u;
         system.runAs(u){
         	/** create test product hierarchy */
         	Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
    		ph.Name = '123';
    		ph.CBC1__c = '13005';
    		ph.CBC2__c = '30012';
    		ph.CBC3__c = '30033';
    		ph.CBC1_Description__c = 'Appliances';
            ph.CBC4_Description__c = 'Appliances';
        	insert ph;
        	/** create test part */
        	Part__c part = ClsTestHelp.createTestPart();
    		part.Name = 'testPart';
    		part.GPL__c = ph.Id;
    		part.Product_Hierarchy__c = ph.Id; 
    		part.Description__c = 'test';
    		part.PRODUCT_CDE__c = 'TEST1';
    		part.IsActive__c = true;
    		part.PROD_NAME__c = 'test name1';
             
            Part__c part2 = ClsTestHelp.createTestPart();
    		part2.Name = 'testPart2';
    		part2.GPL__c = ph.Id;
    		part2.Product_Hierarchy__c = ph.Id; 
    		part2.Description__c = 'test2';
    		part2.PRODUCT_CDE__c = 'TEST2';
    		part2.PROD_NAME__c = 'test name2';
    		part2.IsActive__c = true;
    		List<Part__c> list_Parts = new List<Part__c>{part,part2};
    		insert list_Parts;
             
            Inventory__c inv = ClsTestHelp.createTestInventory();
            inv.PartNbr__c = part.Id;
            inv.Qty_on_Hand_Grade_Net__c = 0;
            insert inv;
         	ClsTriggerFactory.setSkipHandler('AccountTrgHandler',true); 
            Account acct = ClsTestHelp.createTestAccounts();
            insert acct;
    		/** create test opp */
         	Opportunity opp =  ClsTestHelp.createTestOpportunity();
         	opp.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
         	opp.CloseDate = Date.today();
         	insert opp;
        	ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);
        	ClsTriggerRecursionDefense.OpportunityAnzClauseTrigger = false;
         	/** create test Opportunity Part */
        	Opportunity_Part__c op =  ClsTestHelp.createTestEnergyOpportunityPart();
        	op.Opportunity__c = opp.Id;
        	op.Part__c = part.Id;
        	insert op;
        	Energy_Quote__c newQuote = ClsTestHelp.createTestEnergyQuote();
	        Id salesQuoteId = ClsTestHelp.getSalesQuoteRecType().Id;
	        if(salesQuoteId != null){
	            newQuote.RecordTypeId = salesQuoteId;
	        }
	        newQuote.Contact__c = opp.Customer_Contact_Name__c;
	        newQuote.Name = opp.Name + String.valueOf(Date.today()).substring(0, 10);
	        newQuote.Account_Name__c = opp.AccountId;
	        newQuote.Opportunity_Name__c = opp.Id;
	        newQuote.Approval_Status__c = 'Won';
	        newQuote.Reason_of_Win__c = 'Other';
	        newQuote.Contract_start_date__c = Date.today().addDays(-1);
	        newQuote.Contract_Finish_Date__c = Date.today().addDays(1);
	        insert newQuote;
	        
	        Energy_Quote_Line_Item__c eqli = ClsTestHelp.createTestEnergyQuoteLineItem();
	        eqli.Energy_Quote_Name__c = newQuote.Id;
	        eqli.Quantity__c = 25;
	        eqli.Part__c = op.Part__c;
	        eqli.UnitPrice__c = 2;
	        eqli.Product_Hierarchy__c = ph.Id;
	        eqli.Price_List__c = op.Sales_Price__c;
	        eqli.Product_Hierarchy__c = op.GPL__c;
	        insert eqli;
            Test.startTest();
        	CBC4_to_PM__c cbc4 = ClsTestHelp.createTestCBC4toPM();
            cbc4.Product_Manager__c = u.Id;
            cbc4.Name = 'Appliances';
            insert cbc4;
        	ClsTestCustomSettingHelper.getBestPriceWebspeedSetting();
        	BestPriceWebspeed__c bp = BestPriceWebspeed__c.getValues('QAD-MFGProUrl'); 
            
        	/** call out ExtOppyPartDiscounting cls */
        	ExtOppyPartDiscounting extOppPartDis = new ExtOppyPartDiscounting(new ApexPages.StandardController(opp));
            extOppPartDis.init();
        	extOppPartDis.list_parts = new list<Part__c>();
        	extOppPartDis.searchText = '';
        	ExtOppyPartDiscounting.innerClassForAdd ina = new ExtOppyPartDiscounting.innerClassForAdd();
        	
        	ExtOppyPartDiscounting.OppIdPartNumber opn = new ExtOppyPartDiscounting.OppIdPartNumber();
        	opn.oppyId = '';
        	opn.partNum = '';
        	
        	
        	/** call out addParts() */
	        RestRequest req = new RestRequest(); 
	        RestResponse res = new RestResponse();
	        
	        String session = UserInfo.getSessionId();
	        
	        req.requestURI = bp.URL__c;  
	        req.addParameter('sessionid', session);
	        req.addParameter('part','1234567');
	        req.addParameter('qty', '5');
	        req.addParameter('customer', '1wer2547');
	        
	
	        req.httpMethod = 'POST';
	        RestContext.request = req;
	        RestContext.response = res;	
        	Test.setMock(HttpCalloutMock.class,new MockHTTPResponseGenerator());
        	extOppPartDis.str_partIds2AddJson = '["'+String.valueOf(part.Id)+'"]';
        	extOppPartDis.str_partIds2AddJsonWithNum = '[{"partId":"'+part.Id+'","quantity":15}]';
        	extOppPartDis.addParts();
        	System.assert(extOppPartDis.str_partListJson != ''); 
        	/** create innser class test data */
        	ExtOppyPartDiscounting.OppyPartDiscountItem item = new ExtOppyPartDiscounting.OppyPartDiscountItem();
        	item.str_oppyPartId = String.valueOf(op.Id);
        	item.str_partNumber = '';
        	item.str_partName = '';
        	item.oppyPart = op;
        	item.int_quality = 0;
        	item.partListPrice = 0;
        	item.partSalesPrice = 0;
        	item.partOfferedPrice = 0;
        	item.isRequestedPriceLower = false; 
            item.str_itemNumber = '';
            item.isThisCBC4 = true;
            //item.str_CBC4Product = 'test cbc4';
            item.str_CBC4Product = ph.Id;
        	List<ExtOppyPartDiscounting.OppyPartDiscountItem> oppPartDisItems = new List<ExtOppyPartDiscounting.OppyPartDiscountItem>{item};   	
        	/** call out getParts() */
        	extOppPartDis.str_partNumb = 'testPart';
        	extOppPartDis.str_partDescription = 'test';
        	extOppPartDis.getParts();
        	extOppPartDis.getPartsUsingLike();
        	System.assert(extOppPartDis.str_partListJson != null);
            extOppPartDis.str_partNumb = 'testPart,testPart2';
        	extOppPartDis.str_partDescription = 'test';
        	extOppPartDis.getParts();
        	extOppPartDis.getPartsUsingLike();
            extOppPartDis.str_partNumb = 'testPart,tt';
        	extOppPartDis.str_partDescription = 'test';
        	extOppPartDis.getParts();
        	extOppPartDis.getPartsUsingLike();
    
            List<Integer> list_index = new List<Integer>{1,2,3};
            ExtOppyPartDiscounting.reverseIndex(list_index);
            ExtOppyPartDiscounting.reverseIndex(null);
        	Test.stopTest();
        }
    }
    
     static testMethod void testExtOppyPartDiscounting3(){    
         /** create test user */ 
    	 User u = ClsTestHelp.createTestUsers();
    	 insert u;
         system.runAs(u){
         	/** create test product hierarchy */
         	Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
    		ph.Name = '123';
    		ph.CBC1__c = '13005';
    		ph.CBC2__c = '30012';
    		ph.CBC3__c = '30033';
    		ph.CBC1_Description__c = 'Appliances';
            ph.CBC4_Description__c = 'Appliances';
        	insert ph;
        	/** create test part */
        	Part__c part = ClsTestHelp.createTestPart();
    		part.Name = 'testPart';
    		part.GPL__c = ph.Id;
    		part.Product_Hierarchy__c = ph.Id; 
    		part.Description__c = 'test';
    		part.PRODUCT_CDE__c = 'TEST1';
    		part.IsActive__c = true;
    		part.PROD_NAME__c = 'test name1';
             
            Part__c part2 = ClsTestHelp.createTestPart();
    		part2.Name = 'testPart2';
    		part2.GPL__c = ph.Id;
    		part2.Product_Hierarchy__c = ph.Id; 
    		part2.Description__c = 'test2';
    		part2.PRODUCT_CDE__c = 'TEST2';
    		part2.PROD_NAME__c = 'test name2';
    		part2.IsActive__c = true;
    		List<Part__c> list_Parts = new List<Part__c>{part,part2};
    		insert list_Parts;
             
            Inventory__c inv = ClsTestHelp.createTestInventory();
            inv.PartNbr__c = part.Id;
            inv.Qty_on_Hand_Grade_Net__c = 0;
            insert inv;
         	ClsTriggerFactory.setSkipHandler('AccountTrgHandler',true); 
            Account acct = ClsTestHelp.createTestAccounts();
            acct.Source_System__c = 42;
            acct.AccountNumber = '123456';
        	insert acct;
    		/** create test opp */
         	Opportunity opp =  ClsTestHelp.createTestOpportunity();
         	opp.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
         	opp.AccountId = acct.Id;
         	opp.StageName = 'Won';
         	opp.Approval_Status__c = 'Awaiting Approval';
            opp.Type__c = 'Opportunity';
            opp.Probability = 80;
         	insert opp;
            Test.startTest();
        	/** call out ExtOppyPartDiscounting cls */
        	ExtOppyPartDiscounting extOppPartDis = new ExtOppyPartDiscounting(new ApexPages.StandardController(opp));
            extOppPartDis.init();
        	Test.stopTest();
        }
    }
    
     static testMethod void testExtOppyPartDiscounting4(){    
         /** create test user */ 
    	 User u = ClsTestHelp.createTestUsers();
    	 insert u;
         system.runAs(u){
         	/** create test product hierarchy */
         	Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
    		ph.Name = '123';
    		ph.CBC1__c = '13005';
    		ph.CBC2__c = '30012';
    		ph.CBC3__c = '30033';
    		ph.CBC1_Description__c = 'Appliances';
            ph.CBC4_Description__c = 'Appliances';
        	insert ph;
        	/** create test part */
        	Part__c part = ClsTestHelp.createTestPart();
    		part.Name = 'testPart';
    		part.GPL__c = ph.Id;
    		part.Product_Hierarchy__c = ph.Id; 
    		part.Description__c = 'test';
    		part.PRODUCT_CDE__c = 'TEST1';
    		part.IsActive__c = true;
    		part.PROD_NAME__c = 'test name1';
             
            Part__c part2 = ClsTestHelp.createTestPart();
    		part2.Name = 'testPart2';
    		part2.GPL__c = ph.Id;
    		part2.Product_Hierarchy__c = ph.Id; 
    		part2.Description__c = 'test2';
    		part2.PRODUCT_CDE__c = 'TEST2';
    		part2.PROD_NAME__c = 'test name2';
    		part2.IsActive__c = true;
    		List<Part__c> list_Parts = new List<Part__c>{part,part2};
    		insert list_Parts;
             
            Inventory__c inv = ClsTestHelp.createTestInventory();
            inv.PartNbr__c = part.Id;
            inv.Qty_on_Hand_Grade_Net__c = 0;
            insert inv;
         	ClsTriggerFactory.setSkipHandler('AccountTrgHandler',true); 
            Account acct = ClsTestHelp.createTestAccounts();
            acct.AccountNumber = '123456';
            acct.Source_System__c = 1;
        	insert acct;
    		/** create test opp */
         	Opportunity opp =  ClsTestHelp.createTestOpportunity();
         	opp.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
         	opp.AccountId = acct.Id;
         	opp.StageName = 'Won';
            opp.Probability = 80;
         	opp.Approval_Status__c = 'Awaiting Approval';
         	insert opp;
            Test.startTest();
        	/** call out ExtOppyPartDiscounting cls */
        	ExtOppyPartDiscounting extOppPartDis = new ExtOppyPartDiscounting(new ApexPages.StandardController(opp));
        	Test.stopTest();
        }
    }
    
    
    static testMethod void testExtOppyPartDiscounting5(){    
         //create test user 
    	 User u = ClsTestHelp.createTestUsers();
    	 insert u;
         system.runAs(u){
         	//create test product hierarchy
         	Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
    		ph.Name = '123';
    		ph.CBC1__c = '13005';
    		ph.CBC2__c = '30012';
    		ph.CBC3__c = '30033';
    		ph.CBC1_Description__c = 'Appliances';
            ph.CBC4_Description__c = 'Appliances';
        	insert ph;
        	//create test part
        	Part__c part = ClsTestHelp.createTestPart();
    		part.Name = 'testPart';
    		part.GPL__c = ph.Id;
    		part.Product_Hierarchy__c = ph.Id; 
    		part.Description__c = 'test';
    		part.PRODUCT_CDE__c = 'TEST1';
    		part.IsActive__c = true;
    		part.PROD_NAME__c = 'test name1';
             
            Part__c part2 = ClsTestHelp.createTestPart();
    		part2.Name = 'testPart2';
    		part2.GPL__c = ph.Id;
    		part2.Product_Hierarchy__c = ph.Id; 
    		part2.Description__c = 'test2';
    		part2.PRODUCT_CDE__c = 'TEST2';
    		part2.PROD_NAME__c = 'test name2';
    		part2.IsActive__c = true;
    		List<Part__c> list_Parts = new List<Part__c>{part,part2};
    		insert list_Parts;
             
            Inventory__c inv = ClsTestHelp.createTestInventory();
            inv.PartNbr__c = part.Id;
            inv.Qty_on_Hand_Grade_Net__c = 0;
            insert inv;
         	ClsTriggerFactory.setSkipHandler('AccountTrgHandler',true); 
            Sales_Hierarchy__c ssh = ClsTestHelp.createTestSalesHierarchy();
            ssh.name = 'test ssh';
            ssh.Level_7_Territory_Code__c = 'testL7';
            insert ssh;
             
            Account acct = ClsTestHelp.createTestAccounts();
            acct.Source_System__c = 42;
            acct.AccountNumber = '123456';
             acct.Sales_Hierarchy__c = ssh.Id;
        	insert acct;
    		//create test opp
         	Opportunity opp =  ClsTestHelp.createTestOpportunity();
         	opp.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
         	opp.AccountId = acct.Id;
         	opp.StageName = 'Won';
            opp.Probability = 80;
         	opp.Approval_Status__c = 'Awaiting Approval';
            opp.Type__c = 'Opportunity';
         	insert opp;
             
            Part__c Tpart = ClsTestHelp.createTestPart();
            Tpart.Name = 'testpart';
            Tpart.BASE_UM_CDE__c = 'PC';
            Tpart.UNIT_PACKAGING_TYPE_CDE__c = 'PC';
            Tpart.GPL__c = ph.Id;
    		Tpart.Product_Hierarchy__c = ph.Id; 
    		Tpart.Description__c = 'Tpart';
    		Tpart.PRODUCT_CDE__c = 'Tpart';
    		Tpart.PROD_NAME__c = 'Tpart';
    		Tpart.IsActive__c = true;
            insert Tpart;
            Test.startTest();
        	//call out ExtOppyPartDiscounting cls
        	ExtOppyPartDiscounting extOppPartDis = new ExtOppyPartDiscounting(new ApexPages.StandardController(opp));
            extOppPartDis.init();
            
            list<ExtOppyPartDiscounting.OppyPartDiscountItem> list_oppyPartItem = new list<ExtOppyPartDiscounting.OppyPartDiscountItem>();
            ExtOppyPartDiscounting.OppyPartDiscountItem partItem = new ExtOppyPartDiscounting.OppyPartDiscountItem();
            Opportunity_Part__c oppyPart = ClsTestHelp.createTestOpportunityPart();
            oppyPart.Opportunity__c = opp.Id;
            oppyPart.Quantity__c = 1;
            oppyPart.Offered_Price__c = 1;
            partItem.str_partName = 'testpart';
            partItem.oppyPart = oppyPart;
            list_oppyPartItem.add(partItem);
            String str_json = JSON.serialize(list_oppyPartItem);
            ExtOppyPartDiscounting.uploadOppyPartsRemoteAction(opp.Id,str_json,true);
            
            //test try/catch exception
            str_json = 'testerrorJsonString';
			ExtOppyPartDiscounting.uploadOppyPartsRemoteAction(opp.Id,str_json,true);
             
        	Test.stopTest();
        }
    }
       
    static testMethod void testExtOppyPartDiscounting6(){    
         //create test user 
    	 User u = ClsTestHelp.createTestUsers();
    	 insert u;
         system.runAs(u){
         	//create test product hierarchy
         	Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
    		ph.Name = '123';
    		ph.CBC1__c = '13005';
    		ph.CBC2__c = '30012';
    		ph.CBC3__c = '30033';
    		ph.CBC1_Description__c = 'Appliances';
            ph.CBC4_Description__c = 'Appliances';
        	insert ph;
        	//create test part
        	Part__c part = ClsTestHelp.createTestPart();
    		part.Name = 'testPart';
    		part.GPL__c = ph.Id;
    		part.Product_Hierarchy__c = ph.Id; 
    		part.Description__c = 'test';
    		part.PRODUCT_CDE__c = 'TEST1';
    		part.IsActive__c = true;
    		part.PROD_NAME__c = 'test name1';
             
            Part__c part2 = ClsTestHelp.createTestPart();
    		part2.Name = 'testPart2';
    		part2.GPL__c = ph.Id;
    		part2.Product_Hierarchy__c = ph.Id; 
    		part2.Description__c = 'test2';
    		part2.PRODUCT_CDE__c = 'TEST2';
    		part2.PROD_NAME__c = 'test name2';
    		part2.IsActive__c = true;
    		List<Part__c> list_Parts = new List<Part__c>{part,part2};
    		insert list_Parts;
             
            Inventory__c inv = ClsTestHelp.createTestInventory();
            inv.PartNbr__c = part.Id;
            inv.Qty_on_Hand_Grade_Net__c = 0;
            insert inv;
         	ClsTriggerFactory.setSkipHandler('AccountTrgHandler',true); 
            Sales_Hierarchy__c ssh = ClsTestHelp.createTestSalesHierarchy();
            ssh.name = 'test ssh';
            ssh.Level_7_Territory_Code__c = 'testL7';
            insert ssh;
             
            Account acct = ClsTestHelp.createTestAccounts();
            acct.Source_System__c = 42;
            acct.AccountNumber = '123456';
             acct.Sales_Hierarchy__c = ssh.Id;
        	insert acct;
    		//create test opp
         	Opportunity opp =  ClsTestHelp.createTestOpportunity();
         	opp.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
         	opp.AccountId = acct.Id;
         	opp.StageName = 'Won';
            opp.Probability = 80;
         	opp.Approval_Status__c = 'Awaiting Approval';
            opp.Type__c = 'Opportunity';
         	insert opp;
             
            Part__c Tpart = ClsTestHelp.createTestPart();
            Tpart.Name = 'testpart';
            Tpart.BASE_UM_CDE__c = 'PC';
            Tpart.UNIT_PACKAGING_TYPE_CDE__c = 'PC';
            Tpart.GPL__c = ph.Id;
    		Tpart.Product_Hierarchy__c = ph.Id; 
    		Tpart.Description__c = 'Tpart';
    		Tpart.PRODUCT_CDE__c = 'Tpart';
    		Tpart.PROD_NAME__c = 'Tpart';
    		Tpart.IsActive__c = true;
            insert Tpart;
            
            Test.startTest();
        	//call out ExtOppyPartDiscounting cls
        	ExtOppyPartDiscounting extOppPartDis = new ExtOppyPartDiscounting(new ApexPages.StandardController(opp));
            extOppPartDis.init();
            
            list<ExtOppyPartDiscounting.OppyPartDiscountItem> list_oppyPartItem = new list<ExtOppyPartDiscounting.OppyPartDiscountItem>();
            ExtOppyPartDiscounting.OppyPartDiscountItem partItem = new ExtOppyPartDiscounting.OppyPartDiscountItem();
            Opportunity_Part__c oppyPart = ClsTestHelp.createTestOpportunityPart();
            oppyPart.Opportunity__c = opp.Id;
            oppyPart.Quantity__c = 1;
            oppyPart.Offered_Price__c = 1;
            partItem.str_partName = 'testpart';
            partItem.oppyPart = oppyPart;
            list_oppyPartItem.add(partItem);
            String str_json = JSON.serialize(list_oppyPartItem);
            
           	ExtOppyPartDiscounting.deleteAllParts(opp.Id);
            
			extOppPartDis.showErrorMessage();
            ExtOppyPartDiscounting.saveOppyPartsRemoteAction(opp.Id,str_json);
             
        	Test.stopTest();
        }
    }
    
    static testMethod void testExtOppyPartDiscounting7() {
        User u = ClsTestHelp.createTestUsers();
        insert u;
         system.runAs(u){
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
             
            Part__c part2 = ClsTestHelp.createTestPart();
    		part2.Name = 'testPart2';
    		part2.GPL__c = ph.Id;
    		part2.Product_Hierarchy__c = ph.Id; 
    		part2.Description__c = 'test2';
    		part2.PRODUCT_CDE__c = 'TEST2';
    		part2.PROD_NAME__c = 'test name2';
    		insert part2;
             
            Inventory__c inv = ClsTestHelp.createTestInventory();
            inv.PartNbr__c = part.Id;
            inv.Qty_on_Hand_Grade_Net__c = 0;
            insert inv;
            Account acct = ClsTestHelp.createTestAccounts();
        	insert acct;
         	Opportunity opp =  ClsTestHelp.createTestOpportunity();
            opp.accountId = acct.Id;
            opp.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
         	insert opp;

            Test.startTest();
            
        	ExtOppyPartDiscounting extOppPartDis = new ExtOppyPartDiscounting(new ApexPages.StandardController(opp));
            extOppPartDis.saveERPforPricing();
            extOppPartDis.str_ERPforPricingValue = 'SAP';
			extOppPartDis.saveERPforPricing();
			
			extOppPartDis.searchSalesHierarchyByName();  
            extOppPartDis.str_selectTerritoryId = 'aaa';
            extOppPartDis.saveTerritoryToOppy();
            extOppPartDis.str_selectTerritoryId = '0060q000002f5kM';
             extOppPartDis.saveTerritoryToOppy();
            Test.stopTest();
         }
    }
    
    static testMethod void testExtOppyPartDiscounting8(){    
         /** create test user */ 
    	 User u = ClsTestHelp.createTestUsers();
    	 insert u;
         system.runAs(u){
         	/** create test product hierarchy */
         	Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
    		ph.Name = '123';
    		ph.CBC1__c = '13005';
    		ph.CBC2__c = '30012';
    		ph.CBC3__c = '30033';
    		ph.CBC1_Description__c = 'Appliances';
            ph.CBC4_Description__c = 'Appliances';
        	insert ph;
        	/** create test part */
        	Part__c part = ClsTestHelp.createTestPart();
    		part.Name = 'testPart';
    		part.GPL__c = ph.Id;
    		part.Product_Hierarchy__c = ph.Id; 
    		part.Description__c = 'test';
    		part.PRODUCT_CDE__c = 'TEST1';
    		part.IsActive__c = true;
    		part.PROD_NAME__c = 'test name1';
             
            Part__c part2 = ClsTestHelp.createTestPart();
    		part2.Name = 'Other Costs';
    		part2.GPL__c = ph.Id;
    		part2.Product_Hierarchy__c = ph.Id; 
    		part2.Description__c = 'test2';
    		part2.PRODUCT_CDE__c = 'TEST2';
    		part2.PROD_NAME__c = 'test name2';
    		part2.IsActive__c = true;
    		List<Part__c> list_Parts = new List<Part__c>{part,part2};
    		insert list_Parts;
             
            Inventory__c inv = ClsTestHelp.createTestInventory();
            inv.PartNbr__c = part.Id;
            inv.Qty_on_Hand_Grade_Net__c = 0;
            insert inv;
    		/** create test opp */
         	Opportunity opp =  ClsTestHelp.createTestOpportunity();
         	opp.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
         	insert opp;
         	
        	ClsTriggerRecursionDefense.OpportunityAnzClauseTrigger = false;
         	/** create test Opportunity Part */
        	Opportunity_Part__c op =  ClsTestHelp.createTestEnergyOpportunityPart();
        	op.Opportunity__c = opp.Id;
        	op.Part__c = part.Id;
        	insert op;
            Test.startTest();
            Opportunity_Part__c op2 =  ClsTestHelp.createTestEnergyOpportunityPart();
        	op2.recordTypeId = ClsTestHelp.createTestRecordType24().Id;
        	op2.Opportunity__c = opp.Id;
        	op2.Part__c = part.Id;
        	op2.Quantity__c = 20;
        	op2.Offered_Price__c = 2;
        	CBC4_to_PM__c cbc4 = ClsTestHelp.createTestCBC4toPM();
            cbc4.Product_Manager__c = u.Id;
            cbc4.Name = 'Appliances';
            insert cbc4;
        	ClsTestCustomSettingHelper.getBestPriceWebspeedSetting();
        	BestPriceWebspeed__c bp = BestPriceWebspeed__c.getValues('QAD-MFGProUrl');
            
        	/** call out ExtOppyPartDiscounting cls */
        	ExtOppyPartDiscounting extOppPartDis = new ExtOppyPartDiscounting(new ApexPages.StandardController(opp));
            extOppPartDis.init();
        	extOppPartDis.list_parts = new list<Part__c>();
        	extOppPartDis.searchText = '';
        	ExtOppyPartDiscounting.innerClassForAdd ina = new ExtOppyPartDiscounting.innerClassForAdd();
        	
        	ExtOppyPartDiscounting.OppIdPartNumber opn = new ExtOppyPartDiscounting.OppIdPartNumber();
        	opn.oppyId = '';
        	opn.partNum = '';
        	
        	/** call out addParts() */
	        RestRequest req = new RestRequest(); 
	        RestResponse res = new RestResponse();
	        
	        String session = UserInfo.getSessionId();
	        
	        req.requestURI = bp.URL__c;  
	        req.addParameter('sessionid', session);
	        req.addParameter('part','1234567');
	        req.addParameter('qty', '5');
	        req.addParameter('customer', '1wer2547');
	
	        req.httpMethod = 'POST';
	        RestContext.request = req;
	        RestContext.response = res;	
        	Test.setMock(HttpCalloutMock.class,new MockHTTPResponseGenerator());
        	extOppPartDis.str_partIds2AddJson = '["'+String.valueOf(part.Id)+'"]';
        	extOppPartDis.str_partIds2AddJsonWithNum = '[{"partId":"'+part.Id+'","quantity":15}]';
        	extOppPartDis.addParts();
        	System.assert(extOppPartDis.str_partListJson != ''); 
        	/** create innser class test data */
        	ExtOppyPartDiscounting.OppyPartDiscountItem item = new ExtOppyPartDiscounting.OppyPartDiscountItem();
        	item.str_oppyPartId = String.valueOf(op.Id);
        	item.str_partNumber = '';
        	item.str_partName = '';
        	item.oppyPart = op;
        	item.int_quality = 0;
        	item.partListPrice = 0;
        	item.partSalesPrice = 0;
        	item.partOfferedPrice = 0;
        	item.isRequestedPriceLower = false; 
            item.str_itemNumber = '';
            item.isThisCBC4 = true;
            item.str_CBC4Product = ph.Id;
        	List<ExtOppyPartDiscounting.OppyPartDiscountItem> oppPartDisItems = new List<ExtOppyPartDiscounting.OppyPartDiscountItem>{item};   	
        	/** call out getParts() */
        	extOppPartDis.str_partNumb = 'testPart';
        	extOppPartDis.str_partDescription = 'test';
        	extOppPartDis.getParts();
        	extOppPartDis.getPartsUsingLike();
        	System.assert(extOppPartDis.str_partListJson != null);
            extOppPartDis.str_partNumb = 'testPart,Other Costs';
        	extOppPartDis.str_partDescription = 'test';
        	extOppPartDis.getParts();
        	extOppPartDis.getPartsUsingLike();
            extOppPartDis.str_partNumb = 'testPart,tt';
        	extOppPartDis.str_partDescription = 'test';
        	extOppPartDis.getParts();
        	extOppPartDis.getPartsUsingLike();
        	/** call out saveOppyParts() */
        	extOppPartDis.str_oppyPartJson2Save = 'aaaa';
			extOppPartDis.saveOppyParts();
			
            op.Quantity__c = 20;
        	op.Offered_Price__c = 1;
        	extOppPartDis.str_oppyPartJson2Save = JSON.serialize(oppPartDisItems);
        	System.debug('extOppPartDis:::'+extOppPartDis.str_oppyPartJson2Save);
        	extOppPartDis.saveOppyParts();
            extOppPartDis.str_deleteOppyPartIds = 'aaaa';
        	extOppPartDis.deleteOppyParts();
            
            Opportunity_Part__c oppPa = ClsTestHelp.createTestOpportunityPart();
            map<String,list<Energy_Quote_Line_Item__c>> map_partId_quoteLineItems = new map<String,list<Energy_Quote_Line_Item__c>>();
            map<String,list<Inventory__c>> map_partId_Inventories = new map<String,list<Inventory__c>>();
            map<String,decimal> map_partId_pricebookCosts = new map<String,decimal>();
            extOppPartDis.displayAmpicsButton = true;
            extOppPartDis.generateOppyPartItem(oppPa,map_partId_quoteLineItems,map_partId_Inventories,map_partId_pricebookCosts);

        	Test.stopTest();
        } 
    }
    
    static testMethod void testExtOppyPartDiscounting10(){    
        //create test user 
        User u = ClsTestHelp.createTestUsers();
        insert u;
        system.runAs(u){
            //create test product hierarchy
            Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
            ph.Name = '123';
            ph.CBC1__c = '13005';
            ph.CBC2__c = '30012';
            ph.CBC3__c = '30033';
            ph.CBC1_Description__c = 'Appliances';
            ph.CBC4_Description__c = 'Appliances';
            insert ph;
            //create test part
            Part__c part = ClsTestHelp.createTestPart();
            part.Name = 'testPart';
            part.GPL__c = ph.Id;
            part.Product_Hierarchy__c = ph.Id; 
            part.Description__c = 'test';
            part.PRODUCT_CDE__c = 'TEST1';
            part.IsActive__c = true;
            part.PROD_NAME__c = 'test name1';
            
            Part__c part2 = ClsTestHelp.createTestPart();
            part2.Name = 'testPart2';
            part2.GPL__c = ph.Id;
            part2.Product_Hierarchy__c = ph.Id; 
            part2.Description__c = 'test2';
            part2.PRODUCT_CDE__c = 'TEST2';
            part2.PROD_NAME__c = 'test name2';
            part2.IsActive__c = true;
            List<Part__c> list_Parts = new List<Part__c>{part,part2};
                insert list_Parts;
            
            Inventory__c inv = ClsTestHelp.createTestInventory();
            inv.PartNbr__c = part.Id;
            inv.Qty_on_Hand_Grade_Net__c = 0;
            insert inv;
            ClsTriggerFactory.setSkipHandler('AccountTrgHandler',true); 
            Sales_Hierarchy__c ssh = ClsTestHelp.createTestSalesHierarchy();
            ssh.name = 'test ssh';
            ssh.Level_7_Territory_Code__c = 'testL7';
            insert ssh;
            
            Account acct = ClsTestHelp.createTestAccounts();
            acct.Source_System__c = 42;
            acct.AccountNumber = '123456';
            acct.Sales_Hierarchy__c = ssh.Id;
            insert acct;
            //create test opp
            Opportunity opp =  ClsTestHelp.createTestOpportunity();
            opp.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
            opp.AccountId = acct.Id;
            opp.StageName = 'Won';
            opp.Probability = 80;
            opp.Approval_Status__c = 'Awaiting Approval';
            opp.Type__c = 'Opportunity';
            insert opp;
            
            Part__c Tpart = ClsTestHelp.createTestPart();
            Tpart.Name = 'testpart';
            Tpart.BASE_UM_CDE__c = 'PC';
            Tpart.UNIT_PACKAGING_TYPE_CDE__c = 'PC';
            Tpart.GPL__c = ph.Id;
            Tpart.Product_Hierarchy__c = ph.Id; 
            Tpart.Description__c = 'Tpart';
            Tpart.PRODUCT_CDE__c = 'Tpart';
            Tpart.PROD_NAME__c = 'Tpart';
            Tpart.IsActive__c = true;
            insert Tpart;
            
            Test.startTest();
            //call out ExtOppyPartDiscounting cls
            ExtOppyPartDiscounting extOppPartDis = new ExtOppyPartDiscounting(new ApexPages.StandardController(opp));
            extOppPartDis.init();
            
            list<ExtOppyPartDiscounting.OppyPartDiscountItem> list_oppyPartItem = new list<ExtOppyPartDiscounting.OppyPartDiscountItem>();
            ExtOppyPartDiscounting.OppyPartDiscountItem partItem = new ExtOppyPartDiscounting.OppyPartDiscountItem();
            Opportunity_Part__c oppyPart = ClsTestHelp.createTestOpportunityPart();
            oppyPart.Opportunity__c = opp.Id;
            oppyPart.Quantity__c = 1;
            oppyPart.Offered_Price__c = 1;
            partItem.str_partName = 'testpart';
            partItem.oppyPart = oppyPart;
            list_oppyPartItem.add(partItem);
            extOppPartDis.str_oppIdPartNumberJson = JSON.serialize(list_oppyPartItem);
            extOppPartDis.upsertOppyPart();
            
            Test.stopTest();
        }
    }
}