/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   A test class for OpportunityTrgHandler.
			   Related user story numbers: W-00456,W-00145
Inputs:        
Test Class:    
History
2016-08-18 	Jun Yu <jun.yu@oinio.com>	Created
2017-07-10 	Yiming Shen <yiming.shen@capgemini.com>	Modified
------------------------------------------------------------*/
@isTest(SeeAllData=false)
public class OpportunityTrgHandler_Test {
	@testSetup static void createConfig(){
		ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
        ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
        ClsTestCustomSettingHelper.getPMV_Stage_Config();
        ClsTestCustomSettingHelper.getADMTerritoryCode();
        Channelinsightdata_test.Channelinsightdata_test();
        ClsTestCustomSettingHelper.getBestPriceWebspeedSetting();
        ClsTestHelp.createTestOPTG4();
	}
	
    static testMethod void testBeforeTrigger() {
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'TestOppy2';
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        insert oppy;                
    }
    
    static testMethod void testAfterTrigger() {
        list<account> testAccounts = new list<account>();
        Account testAcct1 = ClsTestHelp.createTestAccounts();
        testAcct1.AccountNumber = 'test';
        testAccounts.add(testAcct1);
        Account testAcct2 = ClsTestHelp.createTestAccounts();
        testAcct2.AccountNumber = 'test2';
        testAcct2.Source_System__c = 1;
        testAccounts.add(testAcct2);
        insert testAccounts;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.AccountId = testAcct1.Id;
        oppy.Name = 'TestOppy1';
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        insert oppy;
        oppy.AccountId = testAcct2.Id;
        oppy.Distributor__c = 'FUTURE';
        OpportunityTrgHandler.isSkipSetOppyTerritoryAndERPPricing = false;
        update oppy;
    }
    
    static testMethod void testDelete() {
    	Account acct = ClsTestHelp.createTestAccounts();
    	acct.Source_System__c = 50;
    	acct.AccountNumber = '123456';
    	insert acct;
    	Opportunity oppy = ClsTestHelp.createTestOpportunity();
    	oppy.Name = 'testOppy';
    	oppy.AccountId = acct.Id;
    	oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
    	insert oppy;
    	Test.startTest();
    	delete oppy;
    	Test.stopTest();
    }
    
    static testMethod void testANZClauseAI(){
    	User u = ClsTestHelp.createTestUsers();
        insert u;
        System.runAs(u) {
        	ClsTriggerFactory.setSkipHandler('AccountTrgHandler',true);
	        Account testAcct1 = ClsTestHelp.createTestAccounts();
	        testAcct1.AccountNumber = 'test';
	        testAcct1.Source_System__c = 42;
	        insert testAcct1;
	        
	    	ANZ_Clause_Master__c anzClsMaster = ClsTestHelp.createTestANZClauseMaster();
	        anzClsMaster.Name = 'testMaster';
	        anzClsMaster.Opportynity_Type__c = 'Quote';
	        insert anzClsMaster;
	        
	        Opportunity oppy = ClsTestHelp.createTestOpportunity();
	        oppy.AccountId = testAcct1.Id;
	        oppy.Name = 'testOppy2';
	        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
	        oppy.Type__c = 'Quote';
	        oppy.ERP_for_Pricing__c = 'ANZPAC';
	        oppy.Quote_Type__c = 'Standard';
	        Test.startTest();
	        insert oppy;
	        Test.stopTest();
	        ANZ_Clause__c clause2Assert = new ANZ_Clause__c();
            for(ANZ_Clause__c ac :[select Opportynity_Type__c from ANZ_Clause__c 
                 where Opportunity__c =: oppy.Id limit 1]){
                     clause2Assert = ac;
            }
            System.assert(clause2Assert.Id != null);
        }
    }
    
    static testMethod void testANZClauseAU(){
    	User u = ClsTestHelp.createTestUsers();
        insert u;
        System.runAs(u) {
	    	ClsTriggerFactory.setSkipHandler('AccountTrgHandler',true);
	    	ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);
	        Account testAcct1 = ClsTestHelp.createTestAccounts();
	        testAcct1.AccountNumber = 'test';
	        testAcct1.Source_System__c = 42;
	        insert testAcct1;
	        
	    	ANZ_Clause_Master__c anzClsMaster = ClsTestHelp.createTestANZClauseMaster();
	        anzClsMaster.Name = 'testMaster';
	        anzClsMaster.Opportynity_Type__c = 'Quote';
	        ANZ_Clause_Master__c anzClsMaster2 = ClsTestHelp.createTestANZClauseMaster();
	        anzClsMaster2.Name = 'testMaster';
	        anzClsMaster2.Opportynity_Type__c = 'Tender';
	        insert new List<ANZ_Clause_Master__c>{anzClsMaster,anzClsMaster2};
	        
	        Opportunity oppy = ClsTestHelp.createTestOpportunity();
	        oppy.AccountId = testAcct1.Id;
	        oppy.Name = 'testOppy2';
	        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
	        oppy.Quote_Type__c = 'Quote';
	        oppy.ERP_for_Pricing__c = 'ANZPAC';
	        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
	        oppy2.AccountId = testAcct1.Id;
	        oppy2.Name = 'testOppy2';
	        oppy2.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
	        oppy2.Quote_Type__c = 'Standard';
	        oppy2.ERP_for_Pricing__c = 'ANZPAC';
	        insert new List<Opportunity>{oppy,oppy2};
	        ClsWrappers.TriggerContext trgCtx = new ClsWrappers.TriggerContext();
	        trgCtx.isAfter = true;
	        trgCtx.isUpdate = true;
	        trgCtx.newList = new List<Opportunity>{oppy2};
	        trgCtx.newMap = new map<Id,Opportunity>{
	        	oppy2.Id => oppy2
			};
	        trgCtx.oldMap = new map<Id,Opportunity>{
	        	oppy2.Id => oppy
			};
	        Test.startTest();
	        OpportunityTrgHandler ot = new OpportunityTrgHandler();
	        ot.createANZClausesAU(trgCtx, trgCtx.newList); 
	        Test.stopTest();
	        ANZ_Clause__c clause2Assert = new ANZ_Clause__c();
            for(ANZ_Clause__c ac : [select Opportynity_Type__c from ANZ_Clause__c 
                 					where Opportunity__c =: oppy2.Id limit 1]){
                     clause2Assert = ac;
            }
            System.assert(clause2Assert.Id != null);
        }
    }
    
    static testMethod void testUpdateConfidenceLevelForLostOppy() {
        User u = ClsTestHelp.createTestUsers();
        insert u;
        System.runAs(u) {
	        ClsTriggerFactory.isSkipTrigger = true;
	    	ClsWrappers.TriggerContext trgCtx = new ClsWrappers.TriggerContext();
	    	trgCtx.isBefore = true;
	    	trgCtx.isUpdate = true;
	    	ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);
	    	Account acct = ClsTestHelp.createTestAccounts();
	    	acct.Source_System__c = 50;
	    	acct.AccountNumber = '123456';
        	insert acct;
        	Opportunity oppy = ClsTestHelp.createTestOpportunity();
        	oppy.Name = 'testOppy';
        	oppy.Probability__c = '10';
        	oppy.Master_Opportunity__c = null;
        	oppy.Margin__c = null;
        	oppy.AccountId = acct.Id;
        	oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        	insert oppy;
        	oppy.StageName = 'Lost';
        	oppy.Probability = 0;
        	update oppy;
        	Test.startTest();
        	list<Opportunity> list_oppys = new list<Opportunity>();
            list_oppys.add(oppy);
            OpportunityTrgHandler ot = new OpportunityTrgHandler();
			ot.updateConfidenceLevelForOppy(list_oppys);            
        	Test.stopTest();
        }
    }
    
    static testMethod void testUpdateConfidenceLevelForWonOppy() {
        User u = ClsTestHelp.createTestUsers();
        insert u;
        System.runAs(u) {
	        ClsTriggerFactory.isSkipTrigger = true;
	    	ClsWrappers.TriggerContext trgCtx = new ClsWrappers.TriggerContext();
	    	trgCtx.isBefore = true;
	    	trgCtx.isUpdate = true;
	    	ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);
	    	Account acct = ClsTestHelp.createTestAccounts();
	    	acct.Source_System__c = 50;
	    	acct.AccountNumber = '123456';
        	insert acct;
        	Opportunity oppy = ClsTestHelp.createTestOpportunity();
        	oppy.Name = 'testOppy';
        	oppy.Probability__c = '10';
        	oppy.Master_Opportunity__c = null;
        	oppy.Margin__c = null;
        	oppy.AccountId = acct.Id;
        	oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        	insert oppy;
        	oppy.StageName = 'Won - Closed';
        	oppy.Probability = 100;
        	update oppy;
        	Test.startTest();
        	list<Opportunity> list_oppys = new list<Opportunity>();
            list_oppys.add(oppy);
            OpportunityTrgHandler ot = new OpportunityTrgHandler();
			ot.updateConfidenceLevelForOppy(list_oppys);            
        	Test.stopTest();
        }
    }
    
    static testMethod void testAssignPrimaryOppy() {
    	ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'TestOppy21';
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        insert oppy;
        Opportunity oppy11 = ClsTestHelp.createTestOpportunity();
        oppy11.Name = 'TestOppy21';
        oppy11.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        oppy11.Master_Opportunity__c = oppy.Id;
        insert oppy11;
        Opportunity oppy12 = ClsTestHelp.createTestOpportunity();
        oppy12.Name = 'TestOppy21';
        oppy12.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        oppy12.Master_Opportunity__c = oppy11.Id;
        insert oppy12; 
        ClsWrappers.TriggerContext trgCtx = new ClsWrappers.TriggerContext();
        trgCtx.isBefore = true;
        trgCtx.isInsert = true;
        trgCtx.newList = new List<Opportunity>{oppy12};
        trgCtx.newMap = new map<Id,Opportunity>{
        	oppy12.Id => oppy12
		};
        Test.startTest();
        OpportunityTrgHandler ot = new OpportunityTrgHandler();
        Map<Id,Opportunity> map_Id_AllOppys = new Map<Id,Opportunity>();
        map_Id_AllOppys.putAll(ot.getOpportunitiesBaseupId(trgCtx));
        ot.assignPrimaryOppy(trgCtx.newList, map_Id_AllOppys); 
        Test.stopTest();
    }
    
    static testMethod void testSetOppyApprovalStatusBU() {
        ClsTriggerFactory.isSkipTrigger = true;
    	ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);
    	Account acct = ClsTestHelp.createTestAccounts();
    	acct.Source_System__c = 50;
    	acct.AccountNumber = '123456';
    	insert acct;
    	Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'TestOppy21';
        oppy.AccountId = acct.Id;
        oppy.Amount = 100;
        oppy.Approved_Total__c = 100;
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        
        Opportunity oppy11 = ClsTestHelp.createTestOpportunity();
        oppy11.Name = 'TestOppy21';
        oppy11.AccountId = acct.Id;
        oppy11.Amount = 222;
        oppy11.Approved_Total__c = 220;
        oppy11.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        oppy11.Approval_Status__c = 'Approved';
        insert new List<Opportunity>{oppy,oppy11};
        Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial'; 
        insert ph;
        Part__c part = ClsTestHelp.createTestPart();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy11.Id;
        oppypart.Part__c = part.Id;
        oppypart.Offered_Price__c = 1000;
        oppypart.Sales_Price__c = 1000;
        insert oppypart; 
    	Test.startTest();
    	ClsWrappers.TriggerContext trgCtx = new ClsWrappers.TriggerContext();
    	trgCtx.isBefore = true;
    	trgCtx.isUpdate = true;
    	trgCtx.oldList = new list<Opportunity>{oppy};
    	trgCtx.oldMap = new Map<Id,Opportunity>{
    		oppy11.Id => oppy
    	};
    	trgCtx.newList = new list<Opportunity>{oppy11};
    	trgCtx.newMap = new Map<Id,Opportunity>{
    		oppy11.Id => oppy11
    	};
        OpportunityTrgHandler ot = new OpportunityTrgHandler();
        map<Id, Opportunity> map_oppyId_allOppys = new map<Id, Opportunity>();
    	map<Id, Opportunity_Part__c> map_oppyPartId_allOppyParts = new map<Id, Opportunity_Part__c>();
    	map_oppyId_allOppys.putAll(ot.getOpportunitiesBaseupId(trgCtx));
    	map_oppyPartId_allOppyParts.putAll(ot.getOpportunityPartsBaseupId(map_oppyId_allOppys));
    	ot.setOppyApprovalStatusBU(trgCtx, trgCtx.newList, map_oppyPartId_allOppyParts);
    	Test.stopTest();
    }
    
    static testMethod void testSetOppyApprovalStatusBI() {
        ClsTriggerFactory.isSkipTrigger = true;
    	ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);
    	Account acct = ClsTestHelp.createTestAccounts();
    	acct.Source_System__c = 50;
    	acct.AccountNumber = '123456';
    	insert acct;
    	Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'TestOppy21';
        oppy.AccountId = acct.Id;
        oppy.Amount = 100;
        oppy.Approved_Total__c = 100;
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        
        Opportunity oppy11 = ClsTestHelp.createTestOpportunity();
        oppy11.Name = 'TestOppy21';
        oppy11.AccountId = acct.Id;
        oppy11.Amount = 222;
        oppy11.Approved_Total__c = 220;
        oppy11.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        oppy11.Approval_Status__c = 'Approved';
        insert new List<Opportunity>{oppy,oppy11};
        Test.startTest();
        OpportunityTrgHandler ot = new OpportunityTrgHandler();
    	ot.setOppyApprovalStatusBI(new List<Opportunity>{oppy,oppy11});
    	Test.stopTest();
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
    
    static testMethod void testSetAllPartsChangedSinceQuoteIntegration() {
		ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);
	    Opportunity oppy = ClsTestHelp.createTestOpportunity();
	    oppy.Name = 'TestOppy21';
	    oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
	    oppy.Quote_Created_time__c = Datetime.now();
	    
	    Opportunity oppy11 = ClsTestHelp.createTestOpportunity();
	    oppy11.Name = 'TestOppy21';
	    oppy11.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
	    oppy11.Quote_Created_time__c = Datetime.now().addDays(1);
	    insert new List<Opportunity>{oppy,oppy11}; 
	    Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
	    ph.Hierarchy_Level_Type__c = 'CBC1';
	    ph.Description__c = 'Industrial'; 
	    insert ph;
	    
	    Part__c part = ClsTestHelp.createTestPart();
	    part.Description__c = 'Sniper';
	    part.Product_Hierarchy__c = ph.Id;
	    insert part;
		Opportunity_Part__c oppypart = ClsTestHelp.createTestEnergyOpportunityPart();
	    oppypart.Opportunity__c = oppy11.Id;
	    oppypart.Part__c = part.Id;
	    oppypart.Offered_Price__c = 0;
	    insert oppypart;
	    ClsWrappers.TriggerContext trgCtx = new ClsWrappers.TriggerContext();
	    trgCtx.isAfter = true;
	    trgCtx.isUpdate = true;
	    trgCtx.oldList = new List<Opportunity>{oppy};
	    trgCtx.oldMap = new map<Id,Opportunity>{
	    	oppy11.Id => oppy
		};
	    trgCtx.newList = new List<Opportunity>{oppy11};
	    trgCtx.newMap = new map<Id,Opportunity>{
	    	oppy11.Id => oppy11
		};
	    Test.startTest();
		OpportunityTrgHandler ot = new OpportunityTrgHandler();
	    map<Id, Opportunity> map_oppyId_allOppys = new map<Id, Opportunity>();
    	map<Id, Opportunity_Part__c> map_oppyPartId_allOppyParts = new map<Id, Opportunity_Part__c>();
    	map_oppyId_allOppys.putAll(ot.getOpportunitiesBaseupId(trgCtx));
    	map_oppyPartId_allOppyParts.putAll(ot.getOpportunityPartsBaseupId(map_oppyId_allOppys));
    	map<Id, Opportunity_Part__c> map_oppyPartId_oppyParts = new map<Id, Opportunity_Part__c>();
	    ot.setAllPartsChangedSinceQuoteIntegration(trgCtx,trgCtx.newList, map_oppyPartId_oppyParts, map_oppyPartId_allOppyParts);
	    Test.stopTest();
    }
    
    static testMethod void testUpdateApprovedTotalIfOppApprove(){
    	ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);
        	Account acct = ClsTestHelp.createTestAccounts();
        	acct.AccountNumber = '123456';
        	insert acct;
	        Opportunity oppy = ClsTestHelp.createTestOpportunity();
	        oppy.Name = 'TestOppy21';
	        oppy.AccountId = acct.Id;
	        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
	        
	        Opportunity oppy11 = ClsTestHelp.createTestOpportunity();
	        oppy11.Name = 'TestOppy21';
	        oppy11.AccountId = acct.Id;
	        oppy11.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
	        oppy11.Approval_Status__c = 'Approved';
	        insert new List<Opportunity>{oppy,oppy11}; 
	        Test.startTest();
	       
	        ClsWrappers.TriggerContext trgCtx = new ClsWrappers.TriggerContext();
	        trgCtx.isBefore = true;
	        trgCtx.isUpdate = true;
	        trgCtx.oldList = new List<Opportunity>{oppy};
	        trgCtx.oldMap = new map<Id,Opportunity>{
	        	oppy11.Id => oppy
			};
	        trgCtx.newList = new List<Opportunity>{oppy11};
	        trgCtx.newMap = new map<Id,Opportunity>{
	        	oppy11.Id => oppy11
			};
            OpportunityTrgHandler ot = new OpportunityTrgHandler();
			ot.updateApprovedTotalIfOppApprove(trgCtx,trgCtx.newList); 
	        Test.stopTest();
    }
    /*
    static testMethod void testUpdateOppyForecastAndQuoteForOppy() {
        	ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);
        	Account acct = ClsTestHelp.createTestAccounts();
        	acct.AccountNumber = '123456';
        	insert acct;
	        Opportunity oppy = ClsTestHelp.createTestOpportunity();
	        oppy.Name = 'TestOppy21';
	        oppy.AccountId = acct.Id;
	        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
	        
	        Opportunity oppy11 = ClsTestHelp.createTestOpportunity();
	        oppy11.Name = 'TestOppy21';
	        oppy11.AccountId = acct.Id;
	        oppy11.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
	        oppy11.StageName = 'Lost';
	        insert new List<Opportunity>{oppy,oppy11}; 
	        
	        Opportunity_Forecast__c oppyForecast1 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast1.Opportunity__c = oppy11.Id;
            oppyForecast1.Amount__c = 100;
            oppyForecast1.Actual_Value__c = 100;
            oppyForecast1.CurrencyIsoCode = 'USD';
            oppyForecast1.Confidence_Level__c = '30';
            oppyForecast1.Fiscal_Month__c = '11';
            oppyForecast1.Fiscal_Quarter__c = 'Q4';
            oppyForecast1.Fiscal_Year__c = '2018';
            insert oppyForecast1;
            Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
	        ph.Hierarchy_Level_Type__c = 'CBC1';
	        ph.Description__c = 'Industrial'; 
	        insert ph;
	        Part__c part = ClsTestHelp.createTestPart();
	        part.Description__c = 'Sniper';
	        part.Product_Hierarchy__c = ph.Id;
	        insert part;
	        Test.startTest();
	        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
	        oppypart.Opportunity__c = oppy.Id;
	        oppypart.Part__c = part.Id;
	        Opportunity_Part__c oppypart2 = ClsTestHelp.createTestOpportunityPart();
	        oppypart2.Opportunity__c = oppy11.Id;
	        oppypart2.Part__c = part.Id;
	        insert new List<Opportunity_Part__c>{oppypart,oppypart2};
	        Opportunity_Part_Forecast__c oppyPartForecast = ClsTestHelp.createTestOpportunityPartForecast();
	        oppyPartForecast.Name = 'testOppPartForecast' + system.now();
	        oppyPartForecast.Opportunity_Part__c = oppypart.Id;
	        oppyPartForecast.Opportunity_Forecast__c = oppyForecast1.Id;
	        oppyPartForecast.Month__c = decimal.valueOf(oppyForecast1.Fiscal_Month__c);
	        oppyPartForecast.Year__c = oppyForecast1.Fiscal_Year__c;
	        insert oppyPartForecast; 
	        Energy_Quote__c newQuote = ClsTestHelp.createTestEnergyQuote();
	        newQuote.Contact__c = oppy11.Customer_Contact_Name__c;
	        newQuote.Name = oppy.Name + String.valueOf(Date.today()).substring(0, 10);
	        newQuote.Account_Name__c = oppy11.AccountId;
	        newQuote.Opportunity_Name__c = oppy11.Id;
	        newQuote.Status__c = 'Accepted';
        	insert newQuote;
        	
	        ClsWrappers.TriggerContext trgCtx = new ClsWrappers.TriggerContext();
	        trgCtx.isAfter = true;
	        trgCtx.isInsert = true;
	        trgCtx.oldList = new List<Opportunity>{oppy};
	        trgCtx.oldMap = new map<Id,Opportunity>{
	        	oppy11.Id => oppy
			};
	        trgCtx.newList = new List<Opportunity>{oppy11};
	        trgCtx.newMap = new map<Id,Opportunity>{
	        	oppy11.Id => oppy11
			};
			ClsWrappers.TriggerContext trgCtx2 = new ClsWrappers.TriggerContext();
	        trgCtx2.isAfter = true;
	        trgCtx2.isUpdate = true;
	        trgCtx2.oldList = new List<Opportunity>{oppy};
	        trgCtx2.oldMap = new map<Id,Opportunity>{
	        	oppy11.Id => oppy
			};
	        trgCtx2.newList = new List<Opportunity>{oppy11};
	        trgCtx2.newMap = new map<Id,Opportunity>{
	        	oppy11.Id => oppy11
			};
			OpportunityTrgHandler ot = new OpportunityTrgHandler();
			map<Id, Opportunity> map_oppyId_allOppys = new map<Id, Opportunity>();
	    	map<Id, Opportunity_Part__c> map_oppyPartId_allOppyParts = new map<Id, Opportunity_Part__c>();
	    	map_oppyId_allOppys.putAll(ot.getOpportunitiesBaseupId(trgCtx));
	    	map_oppyPartId_allOppyParts.putAll(ot.getOpportunityPartsBaseupId(map_oppyId_allOppys));
			map<Id, Opportunity_Part__c> map_oppyPartId_oppyParts = new map<Id, Opportunity_Part__c>();
			ot.syncDetailRecordsForWonOrLostOppyAI(trgCtx.newList,map_oppyPartId_oppyParts,map_oppyPartId_allOppyParts); 
	        ot.syncDetailRecordsForWonOrLostOppyAU(trgCtx,trgCtx.newList,map_oppyPartId_oppyParts,map_oppyPartId_allOppyParts); 
	        oppy11.StageName = 'Won - Closed';
        	oppy11.Probability = 100;
	        update oppy11;
			ClsWrappers.TriggerContext trgCtx3 = new ClsWrappers.TriggerContext();
	        trgCtx3.isAfter = true;
	        trgCtx3.isUpdate = true;
	        trgCtx3.oldList = new List<Opportunity>{oppy};
	        trgCtx3.oldMap = new map<Id,Opportunity>{
	        	oppy11.Id => oppy
			};
	        trgCtx3.newList = new List<Opportunity>{oppy11};
	        trgCtx3.newMap = new map<Id,Opportunity>{
	        	oppy11.Id => oppy11
			};
	        ot.syncDetailRecordsForWonOrLostOppyAU(trgCtx,trgCtx.newList,map_oppyPartId_oppyParts,map_oppyPartId_allOppyParts);
	        Test.stopTest();
    }
*/
    
    static testMethod void testCheckQuoteStatusForOppyStage() {
    	ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);
    	Account acct = ClsTestHelp.createTestAccounts();
    	acct.RecordTypeId = ClsTestHelp.createProspectAccount().Id;
    	acct.AccountNumber = '123456';
    	insert acct;
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'TestOppy21';
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        oppy.StageName = 'New';
        oppy.AccountId = acct.Id;
        insert oppy;
        ClsWrappers.TriggerContext trgCtx = new ClsWrappers.TriggerContext();
        trgCtx.isBefore = true;
        trgCtx.isUpdate = true;
        trgCtx.oldList = new List<Opportunity>{oppy};
        oppy.stageName = 'Won';
        update oppy; 
        Opportunity oppy2 = [SELECT Id,StageName,Account.RecordType.Name FROM Opportunity WHERE Id =: oppy.Id limit 1];
        trgCtx.oldMap = new map<Id,Opportunity>{
        	oppy.Id => oppy
		};
        trgCtx.newList = new List<Opportunity>{oppy2};
        trgCtx.newMap = new map<Id,Opportunity>{
        	oppy2.Id => oppy2
		};
        
        Energy_Quote__c newQuote = ClsTestHelp.createTestEnergyQuote();
        newQuote.Contact__c = oppy.Customer_Contact_Name__c;
        newQuote.Name = oppy.Name + String.valueOf(Date.today()).substring(0, 10);
        newQuote.Account_Name__c = oppy.AccountId;
        newQuote.Opportunity_Name__c = oppy.Id;
        newQuote.Approval_Status__c = 'Pending';
        //newQuote.Status__c = 'Accepted';
        insert newQuote;
        Test.startTest();
        OpportunityTrgHandler ot = new OpportunityTrgHandler();
        ot.checkQuoteStatusForOppyStage(trgCtx,trgCtx.newList); 
        Test.stopTest();
    }
    
    static testMethod void testUpdateAccountFields() {
    	User u = ClsTestHelp.createTestUsers();
        u.Te_Network_Id__c = '0529';
        insert u;
        System.runAs(u) {
        	ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);
	    	Sales_Hierarchy__c sh7 = ClsTestHelp.createTestSalesHierarchy();
	        sh7.Level_7_Territory_Code__c = 'A007357';
	        sh7.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
	        sh7.Level_7_Default_Owner__c = u.Id;
	        sh7.Level_7_Assigned_Users__c = u.Id;
	        sh7.Level_7_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
	        Sales_Hierarchy__c sh72 = ClsTestHelp.createTestSalesHierarchy();
	        sh72.Level_7_Territory_Code__c = 'A0073572';
	        sh72.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
	        sh72.Level_7_Default_Owner__c = u.Id;
	        sh72.Level_7_Assigned_Users__c = u.Id;
	        sh72.Level_7_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
	        insert new List<Sales_Hierarchy__c>{sh7,sh72};
	        Account acct = ClsTestHelp.createTestAccounts();
        	acct.Sales_Hierarchy__c = sh72.Id;
        	acct.SALES_TERRITORY_CDE__c = 'A0073572';
        	Account acct2 = ClsTestHelp.createTestAccounts();
        	acct2.Sales_Hierarchy__c = sh72.Id;
        	acct2.SALES_TERRITORY_CDE__c = 'A0073572';
        	Account acct3 = ClsTestHelp.createTestAccounts();
        	acct3.Sales_Hierarchy__c = sh72.Id;
        	acct3.SALES_TERRITORY_CDE__c = 'A0073572';
        	Account acct4 = ClsTestHelp.createTestAccounts();
        	acct4.Sales_Hierarchy__c = sh72.Id;
        	acct4.SALES_TERRITORY_CDE__c = 'A0073572';
        	insert new List<Account>{acct,acct2,acct3,acct4};
        	
	        Opportunity oppy = ClsTestHelp.createTestOpportunity();
	        oppy.Name = 'TestOppy21';
	        oppy.AccountId = acct.Id;
	        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
	        oppy.ERP_for_Pricing__c = 'No ERP';
	        oppy.Territory__c = sh72.Id;
	        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
	        oppy2.Name = 'TestOppy22';
	        oppy2.AccountId = acct2.Id;
	        oppy2.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
	        oppy2.ERP_for_Pricing__c = 'SAP (except ANZPAC)';
	        oppy2.Territory__c = sh72.Id;
	        Opportunity oppy3 = ClsTestHelp.createTestOpportunity();
	        oppy3.Name = 'TestOppy23';
	        oppy3.AccountId = acct3.Id;
	        oppy3.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
	        oppy3.ERP_for_Pricing__c = 'MFGPRO';
	        oppy3.Territory__c = sh72.Id;
	        Opportunity oppy4 = ClsTestHelp.createTestOpportunity();
	        oppy4.Name = 'TestOppy24';
	        oppy4.AccountId = acct4.Id;
	        oppy4.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
	        oppy4.ERP_for_Pricing__c = 'ANZPAC';
	        oppy4.Territory__c = sh72.Id;
	        Opportunity oppy11 = ClsTestHelp.createTestOpportunity();
	        oppy11.Name = 'TestOppy21';
	        oppy11.AccountId = acct.Id;
	        oppy11.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
	        oppy11.ERP_for_Pricing__c = 'SAP (except ANZPAC)';
	        oppy11.Territory__c = sh7.Id;
	        Opportunity oppy22 = ClsTestHelp.createTestOpportunity();
	        oppy22.Name = 'TestOppy22';
	        oppy22.AccountId = acct2.Id;
	        oppy22.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
	        oppy22.ERP_for_Pricing__c = 'MFGPRO';
	        oppy22.Territory__c = sh7.Id;
	        Opportunity oppy33 = ClsTestHelp.createTestOpportunity();
	        oppy33.Name = 'TestOppy23';
	        oppy33.AccountId = acct3.Id;
	        oppy33.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
	        oppy33.ERP_for_Pricing__c = 'ANZPAC';
	        oppy33.Territory__c = sh7.Id;
	        Opportunity oppy44 = ClsTestHelp.createTestOpportunity();
	        oppy44.Name = 'TestOppy24';
	        oppy44.AccountId = acct4.Id;
	        oppy44.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
	        oppy44.ERP_for_Pricing__c = 'No ERP';
	        oppy44.Territory__c = sh7.Id;
	        insert new List<Opportunity>{oppy,oppy2,oppy3,oppy4,oppy11,oppy22,oppy33,oppy44}; 
	        ClsWrappers.TriggerContext trgCtx = new ClsWrappers.TriggerContext();
	        trgCtx.isAfter = true;
	        trgCtx.isUpdate = true;
	        trgCtx.oldList = new List<Opportunity>{oppy,oppy2,oppy3,oppy4};
	        trgCtx.oldMap = new map<Id,Opportunity>{
	        	oppy11.Id => oppy,
	        	oppy22.Id => oppy2,
	        	oppy33.Id => oppy3,
	        	oppy44.Id => oppy4
			};
	        
	        trgCtx.newList = new List<Opportunity>{oppy11,oppy22,oppy33,oppy44};
	        trgCtx.newMap = new map<Id,Opportunity>{
	        	oppy11.Id => oppy11,
	        	oppy22.Id => oppy22,
	        	oppy33.Id => oppy33,
	        	oppy44.Id => oppy44
			};
	        Test.startTest();
            OpportunityTrgHandler ot = new OpportunityTrgHandler();
	        ot.updateAccountFields(trgCtx,trgCtx.newList);
	        Test.stopTest();
        } 
    }
    
    static testMethod void testSyncRelatedListCurrency() {
    	ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'TestOppy21';
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        oppy.CurrencyISOCode = 'USD';
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Name = 'TestOppy22';
        oppy2.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        oppy2.CurrencyISOCode = 'CNY';
        insert new List<Opportunity>{oppy,oppy2}; 
        Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial'; 
        insert ph;
        Part__c part = ClsTestHelp.createTestPart();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        Test.startTest();
        Opportunity_Part__c oppypart = ClsTestHelp.createTestEnergyOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = part.Id;
        oppypart.Offered_Price__c = 0;
        insert oppypart;
        Opportunity_Forecast__c oppyForecast1 = ClsTestHelp.createTestENGOpportunityForecasts();
        oppyForecast1.Opportunity__c = oppy.Id;
        oppyForecast1.Part__c = oppypart.Id;
        oppyForecast1.Amount__c = 100;
        oppyForecast1.CurrencyIsoCode = 'USD';
        oppyForecast1.Confidence_Level__c = '30';
        oppyForecast1.Fiscal_Month__c = '12';
        oppyForecast1.Fiscal_Quarter__c = 'Q4';
        oppyForecast1.Fiscal_Year__c = '2017';
        insert oppyForecast1;
        
        Opportunity_Part_Forecast__c oppyPartForecast = ClsTestHelp.createTestOpportunityPartForecast();
        oppyPartForecast.Name = 'testOppPartForecast' + system.now();
        oppyPartForecast.Opportunity_Part__c = oppypart.Id;
        oppyPartForecast.Opportunity_Forecast__c = oppyForecast1.Id;
        oppyPartForecast.Month__c = decimal.valueOf(oppyForecast1.Fiscal_Month__c);
        oppyPartForecast.Year__c = oppyForecast1.Fiscal_Year__c;
        insert oppyPartForecast; 
        
        ClsWrappers.TriggerContext trgCtx = new ClsWrappers.TriggerContext();
        trgCtx.isAfter = true;
        trgCtx.isUpdate = true;
        trgCtx.newList = new list<Opportunity>();
        trgCtx.newList.add(oppy);
        trgCtx.oldList = new list<Opportunity>();
        trgCtx.oldList.add(oppy2);
        trgCtx.newMap = new map<Id,Opportunity>();
        trgCtx.newMap.put(oppy.Id, oppy);
        trgCtx.oldMap = new map<Id,Opportunity>();
        trgCtx.oldMap.put(oppy.Id, oppy2);
        map<Id, Opportunity_Part__c> map_oppyPartId_oppyParts = new map<Id, Opportunity_Part__c>();
        OpportunityTrgHandler ot = new OpportunityTrgHandler();
        ot.syncRelatedListCurrency(trgCtx,trgCtx.newList,map_oppyPartId_oppyParts,map_oppyPartId_oppyParts);
        Test.stopTest();
    }
    
    static testMethod void testUpdateOppyPartToApproved() {
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'TestOppy2';
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        oppy.Approval_Status__c = 'Approved';
        insert oppy;  
        
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Name = 'TestOppy2';
        oppy2.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        oppy2.Approval_Status__c = 'Approved Required';
        insert oppy2;  
        
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
        op.Status__c = 'Pending';
        op.Qty_PIP__c = 1;
        op.ANZ_Quantity__c = 0;
        op.ANZ_Percentage__c = '1';
        op.Sales_Price__c = 100;
        op.Pieces_in_Pack__c = 0;
        op.Product_Line__c = 'All'; 
        ExtOppyPartDiscounting.isEnergyPartManagementSave = true;
        insert op;
        
        Test.startTest();
        OpportunityTrgHandler.list_oppyPartsForApprovedOppy = new list<Opportunity_Part__c>();
        OpportunityTrgHandler.list_oppyPartsForApprovedOppy.add(op);
        
        ClsWrappers.TriggerContext trgCtx = new ClsWrappers.TriggerContext();
        trgCtx.isAfter = true;
        trgCtx.isInsert = true;
        trgCtx.newMap = new map<Id,Opportunity>();
        trgCtx.newMap.put(op.Opportunity__c,oppy);
        trgCtx.oldMap = new map<Id,Opportunity>();
        trgCtx.oldMap.put(op.Opportunity__c,oppy2);
        map<Id, Opportunity_Part__c> map_oppyPartId_oppyParts = new map<Id, Opportunity_Part__c>();
        OpportunityTrgHandler ot = new OpportunityTrgHandler();
        ot.updateOppyPartToApproved(trgCtx,map_oppyPartId_oppyParts);
        
        Test.stopTest();
    }
    
    static testMethod void testSetSAPQuoteType() {
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'TestOppy2';
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        oppy.ERP_For_Pricing__c = 'SAP (except ANZPAC)';
        //oppy.Quote_Type__c = 'One Time Tender';
        oppy.Quote_Type__c = 'Blanket/Tender';
        
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Name = 'TestOppy2';
        oppy2.ERP_For_Pricing__c = 'SAP (except ANZPAC)';
        oppy2.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        oppy2.Total_Opportunity_Value__c = 10001;
        
        Test.startTest();
        insert new List<Opportunity>{oppy,oppy2};
        Test.stopTest();
    }
    
    static testMethod void testCreateQuoteForSmallQuoteType() {
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'TestOppy2';
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        oppy.Approval_Status__c = 'Approved';
        oppy.NDR_Quote_Document_Number__c = 'testNum';
        oppy.SAP_Quote_Type__c = 'Small Quote';
        oppy.ERP_For_Pricing__c = 'SAP (except ANZPAC)';
        
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Name = 'TestOppy2';
        oppy2.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        oppy2.Approval_Status__c = 'Approved Required';
        oppy2.NDR_Quote_Document_Number__c = 'testNum2';
        oppy2.SAP_Quote_Type__c = 'Small Quote';
        insert new List<Opportunity>{oppy,oppy2};  
        
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
        op.Status__c = 'Pending';
        op.Qty_PIP__c = 1;
        op.ANZ_Quantity__c = 0;
        op.ANZ_Percentage__c = '1';
        op.Sales_Price__c = 100;
        op.Pieces_in_Pack__c = 0;
        op.Product_Line__c = 'All'; 
        ExtOppyPartDiscounting.isEnergyPartManagementSave = true;
        insert op;
        
        Test.startTest();
        ClsWrappers.TriggerContext trgCtx = new ClsWrappers.TriggerContext();
        trgCtx.isAfter = true;
        trgCtx.isUpdate = true;
        trgCtx.newList = new list<Opportunity>();
        trgCtx.newList.add(oppy);
        trgCtx.newMap = new map<Id,Opportunity>();
        trgCtx.newMap.put(op.Opportunity__c,oppy);
        trgCtx.oldMap = new map<Id,Opportunity>();
        trgCtx.oldMap.put(op.Opportunity__c,oppy2);
        OpportunityTrgHandler ot = new OpportunityTrgHandler();
        map<Id, Opportunity> map_oppyId_allOppys = new map<Id, Opportunity>();
    	map<Id, Opportunity_Part__c> map_oppyPartId_allOppyParts = new map<Id, Opportunity_Part__c>();
    	map_oppyId_allOppys.putAll(ot.getOpportunitiesBaseupId(trgCtx));
    	map_oppyPartId_allOppyParts.putAll(ot.getOpportunityPartsBaseupId(map_oppyId_allOppys));
        ot.createQuoteForSmallQuoteType(trgCtx,trgCtx.newList, map_oppyId_allOppys, map_oppyPartId_allOppyParts);
        Test.stopTest();
    }
    
    static testMethod void testAvoidOppyMultipleRunning() {
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
        OpportunityTrgHandler ot = new OpportunityTrgHandler();
        Boolean isAvoidRunning = ot.avoidOppyMultipleRunning(trgCtx);
        System.assert(!isAvoidRunning);
        Boolean isAvoidRunning2 = ot.avoidOppyMultipleRunning(trgCtx2);
        System.assert(!isAvoidRunning2);
        isAvoidRunning = ot.avoidOppyMultipleRunning(trgCtx);
        System.assert(isAvoidRunning);
        isAvoidRunning2 = ot.avoidOppyMultipleRunning(trgCtx2);
        System.assert(isAvoidRunning2);
        Test.stopTest();
    }
    
    
    static testMethod void testsyncRelatedListCurrency2() {
        //create Opportunity
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'TestOppy2';
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        oppy.Approval_Status__c = 'Approved';
        oppy.NDR_Quote_Document_Number__c = 'testNum';
        oppy.SAP_Quote_Type__c = 'Small Quote';
        oppy.ERP_For_Pricing__c = 'SAP (except ANZPAC)';
        oppy.CurrencyISOCode = 'USD';
        insert oppy;  
        
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Name = 'TestOppy2';
        oppy2.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        oppy2.Approval_Status__c = 'Approved Required';
        oppy2.NDR_Quote_Document_Number__c = 'testNum2';
        oppy2.SAP_Quote_Type__c = 'Small Quote';
        
        insert oppy2;  
        
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
        op.Status__c = 'Pending';
        op.Qty_PIP__c = 1;
        op.ANZ_Quantity__c = 0;
        op.ANZ_Percentage__c = '1';
        op.Sales_Price__c = 100;
        op.Pieces_in_Pack__c = 0;
        op.Product_Line__c = 'All'; 
        ExtOppyPartDiscounting.isEnergyPartManagementSave = true;
        insert op;
        
        Test.startTest();
        ClsWrappers.TriggerContext trgCtx = new ClsWrappers.TriggerContext();
        trgCtx.isAfter = true;
        trgCtx.isUpdate = true;
        trgCtx.newList = new list<Opportunity>();
        trgCtx.newList.add(oppy);
        trgCtx.newMap = new map<Id,Opportunity>();
        trgCtx.newMap.put(op.Opportunity__c,oppy);
        trgCtx.oldMap = new map<Id,Opportunity>();
        trgCtx.oldMap.put(op.Opportunity__c,oppy2);
        
        Opportunity opOld = new Opportunity();
        opOld.Id = oppy.Id;
        opOld.CurrencyISOCode = 'EUR';
        trgCtx.oldMap.put(op.Opportunity__c,opOld);
        
        map<Id, Opportunity_Part__c> map_oppyPartId_oppyParts = new map<Id, Opportunity_Part__c>();
        Opportunity_Part__c opTemp = new Opportunity_Part__c();
        opTemp.Opportunity__c = oppy.Id;
        opTemp.CurrencyISOCode = 'CNY';
		map_oppyPartId_oppyParts.put(op.Id,opTemp);
        
        OpportunityTrgHandler ot = new OpportunityTrgHandler();
        ot.syncRelatedListCurrency(trgCtx,trgCtx.newList,map_oppyPartId_oppyParts,map_oppyPartId_oppyParts);
        Test.stopTest();
    }
    
    static testMethod void setOppyTerritoryAndERPPricingBI2() {
        User u = ClsTestHelp.createTestUsers();
        u.Te_Network_Id__c = '0529';
        insert u;
        System.runAs(u) {
        	ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);
	    	Sales_Hierarchy__c sh7 = ClsTestHelp.createTestSalesHierarchy();
	        sh7.Level_7_Territory_Code__c = 'A007357';
	        sh7.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
	        sh7.Level_7_Default_Owner__c = u.Id;
	        sh7.Level_7_Assigned_Users__c = u.Id;
	        sh7.Level_7_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
            
	        Sales_Hierarchy__c sh72 = ClsTestHelp.createTestSalesHierarchy();
	        sh72.Level_7_Territory_Code__c = 'A0073572';
	        sh72.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
	        sh72.Level_7_Default_Owner__c = u.Id;
	        sh72.Level_7_Assigned_Users__c = u.Id;
	        sh72.Level_7_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
	        insert new List<Sales_Hierarchy__c>{sh7,sh72};
                
	        Account acct = ClsTestHelp.createTestAccounts();
        	acct.Sales_Hierarchy__c = sh72.Id;
        	acct.SALES_TERRITORY_CDE__c = 'A0073572';
            acct.Source_System__c = 1;
            
        	Account acct2 = ClsTestHelp.createTestAccounts();
        	acct2.Sales_Hierarchy__c = sh72.Id;
        	acct2.SALES_TERRITORY_CDE__c = 'A0073572';
            acct2.Source_System__c = 2;
            
        	Account acct3 = ClsTestHelp.createTestAccounts();
        	acct3.Sales_Hierarchy__c = sh72.Id;
        	acct3.SALES_TERRITORY_CDE__c = 'A0073572';
            acct3.Source_System__c = 42;
            
        	Account acct4 = ClsTestHelp.createTestAccounts();
        	acct4.Sales_Hierarchy__c = sh72.Id;
        	acct4.SALES_TERRITORY_CDE__c = 'A0073572';
            acct4.Source_System__c = 51;
        	insert new List<Account>{acct,acct2,acct3,acct4};
        	
	        Opportunity oppy = ClsTestHelp.createTestOpportunity();
	        oppy.Name = 'TestOppy21';
	        oppy.AccountId = acct.Id;
	        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
            
	        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
	        oppy2.Name = 'TestOppy22';
	        oppy2.AccountId = acct2.Id;
	        oppy2.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;

	        Opportunity oppy3 = ClsTestHelp.createTestOpportunity();
	        oppy3.Name = 'TestOppy23';
	        oppy3.AccountId = acct3.Id;
	        oppy3.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;

	        Opportunity oppy4 = ClsTestHelp.createTestOpportunity();
	        oppy4.Name = 'TestOppy24'; 
	        oppy4.AccountId = acct4.Id; 
	        oppy4.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
	        
	        Test.startTest();
            list<Opportunity> list_oppys = new List<Opportunity>{oppy,oppy2,oppy3,oppy4}; 
            OpportunityTrgHandler ot = new OpportunityTrgHandler();
            ot.setOppyTerritoryAndERPPricingBI(list_oppys);
	        Test.stopTest();
        } 
    }
    
    
    static testMethod void setOppyTerritoryAndERPPricingBU2() {
        User u = ClsTestHelp.createTestUsers();
        u.Te_Network_Id__c = '0529';
        insert u;
        System.runAs(u) {
        	ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);
	    	Sales_Hierarchy__c sh7 = ClsTestHelp.createTestSalesHierarchy();
	        sh7.Level_7_Territory_Code__c = 'A007357';
	        sh7.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
	        sh7.Level_7_Default_Owner__c = u.Id;
	        sh7.Level_7_Assigned_Users__c = u.Id;
	        sh7.Level_7_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
            
	        Sales_Hierarchy__c sh72 = ClsTestHelp.createTestSalesHierarchy();
	        sh72.Level_7_Territory_Code__c = 'A0073572';
	        sh72.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
	        sh72.Level_7_Default_Owner__c = u.Id;
	        sh72.Level_7_Assigned_Users__c = u.Id;
	        sh72.Level_7_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
	        insert new List<Sales_Hierarchy__c>{sh7,sh72};
                
	        Account acct = ClsTestHelp.createTestAccounts();
        	acct.Sales_Hierarchy__c = sh72.Id;
        	acct.SALES_TERRITORY_CDE__c = 'A0073572';
            acct.Source_System__c = 1;
            
        	Account acct2 = ClsTestHelp.createTestAccounts();
        	acct2.Sales_Hierarchy__c = sh72.Id;
        	acct2.SALES_TERRITORY_CDE__c = 'A0073572';
            acct2.Source_System__c = 2;
            
        	Account acct3 = ClsTestHelp.createTestAccounts();
        	acct3.Sales_Hierarchy__c = sh72.Id;
        	acct3.SALES_TERRITORY_CDE__c = 'A0073572';
            acct3.Source_System__c = 42;
            
        	Account acct4 = ClsTestHelp.createTestAccounts();
        	acct4.Sales_Hierarchy__c = sh72.Id;
        	acct4.SALES_TERRITORY_CDE__c = 'A0073572';
            acct4.Source_System__c = 51;
        	insert new List<Account>{acct,acct2,acct3,acct4};
        	
	        Opportunity oppy = ClsTestHelp.createTestOpportunity();
	        oppy.Name = 'TestOppy21';
	        oppy.AccountId = acct.Id;
	        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
            
	        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
	        oppy2.Name = 'TestOppy22';
	        oppy2.AccountId = acct2.Id;
	        oppy2.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;

	        Opportunity oppy3 = ClsTestHelp.createTestOpportunity();
	        oppy3.Name = 'TestOppy23';
	        oppy3.AccountId = acct3.Id;
	        oppy3.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;

	        Opportunity oppy4 = ClsTestHelp.createTestOpportunity();
	        oppy4.Name = 'TestOppy24';
	        oppy4.AccountId = acct4.Id;
	        oppy4.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
	        insert new List<Opportunity>{oppy,oppy2,oppy3,oppy4}; 
            
	        Test.startTest();
            ClsWrappers.TriggerContext trgCtx = new ClsWrappers.TriggerContext();
            trgCtx.isAfter = true;
            trgCtx.isUpdate = true;
            trgCtx.newList = new list<Opportunity>();
            trgCtx.newList.add(oppy);
            trgCtx.newMap = new map<Id,Opportunity>();
            trgCtx.newMap.put(oppy.Id,oppy);
            trgCtx.oldMap = new map<Id,Opportunity>();
            set<String> set_Ids = new set<String>{oppy.Id,oppy2.Id,oppy3.Id,oppy4.Id}; 
			for(Opportunity opp :[select id,AccountId,Territory__c,ERP_for_Pricing__c from opportunity where id IN:set_Ids]){
				trgCtx.oldMap.put(opp.Id,opp);
            }
            
			oppy.AccountId = acct4.Id;
            oppy2.AccountId = acct3.Id;
            oppy3.AccountId = acct2.Id;
            oppy4.AccountId = acct.Id;            
            list<Opportunity> list_oppys = new List<Opportunity>{oppy,oppy2,oppy3,oppy4}; 
            
            OpportunityTrgHandler ot = new OpportunityTrgHandler();
            ot.setOppyTerritoryAndERPPricingBU(trgCtx,list_oppys);
	        Test.stopTest();
        } 
    }
}