/*------------------------------------------------------------
Author:        Tangyong Li <tangyong.li@capgemini.com>
Description:   test class for class EditAllforopportunity.
			   The user story number is W-00018, W-00459.
Inputs:        
Test Class:    
History
2017-08-24 	   Tangyong Li <tangyong.li@capgemini.com> Created
------------------------------------------------------------*/
@isTest
public class EditAllforopportunityTest {
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
        ClsTestHelp.createTestOPTG4();
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
        	System.assert(op.Id != null);
        	system.debug('query :::2  ' + limits.getQueries());
        	EditAllforopportunity ea = new EditAllforopportunity(new ApexPages.StandardController(oppy));
        	system.debug('query :::3  ' + limits.getQueries());
        	ea.GPLCode = 'GPLCode'; 
        	ea.GPLDescription = 'GPLDescription'; 
        	ea.Priceflag1 = true; 
        	ea.SelectedStatus = 'SelectedStatus'; 
        	ea.prodSearch = 'prodSearch'; 
        	ea.myStatus = 'myStatus'; 
        	ea.SearchCriteria = 'SearchCriteria'; 
        	new EditAllforopportunity.prodlinewrapper('test',1,1,1); 
        	ea.getprodlinedescpicklistvaluesstatus();
        	ea.getstatus();
        	ea.getsearchitem();
        	ea.setsearchitem('test');
        	ea.setsearchitem1('test');
        	ea.getsearchitemstatus();
        	ea.setsearchitemstatus('test');
        	ea.setprodlinedescpicklistvalues('test');
        	ea.setprodlinedescpicklistvaluesstatus('test');
        	//EditAllforopportunity.turnOppPart2OpportunityLineItem(op);
        	ea.Save2();
        	system.debug('query :::4  ' + limits.getQueries());
        	Test.stopTest();
        	ea.Massupdate();
        	ea.saverefresh();
        	system.debug('query :::5  ' + limits.getQueries());
        	ea.ZeroPercentage();
        	system.debug('query :::6  ' + limits.getQueries());
        	ea.searchByGPLCode();
        	ea.searchGPLDescription();
            List<EditAllforopportunity.OpportunityPartWrapper> list_sort = new list<EditAllforopportunity.OpportunityPartWrapper>();
            EditAllforopportunity.OpportunityPartWrapper opw1 = new EditAllforopportunity.OpportunityPartWrapper(op);
            EditAllforopportunity.OpportunityPartWrapper opw2 = new EditAllforopportunity.OpportunityPartWrapper(op);
            list_sort.add(opw1);
            list_sort.add(opw2);
			list_sort.sort();    
        }
    }
    
    
    static testMethod void testSaveWithException() {
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
        	System.assert(op.Id != null);
        	system.debug('query :::2  ' + limits.getQueries());
        	EditAllforopportunity ea = new EditAllforopportunity(new ApexPages.StandardController(oppy));
        	system.debug('query :::3  ' + limits.getQueries());
        	ea.GPLCode = 'GPLCode'; 
        	ea.GPLDescription = 'GPLDescription'; 
        	ea.Priceflag1 = true; 
        	ea.SelectedStatus = 'SelectedStatus'; 
        	ea.prodSearch = 'prodSearch'; 
        	ea.myStatus = 'myStatus'; 
        	ea.SearchCriteria = 'SearchCriteria'; 
        	new EditAllforopportunity.prodlinewrapper('test',1,1,1); 
        	ea.getprodlinedescpicklistvaluesstatus();
        	ea.getstatus();
        	ea.getsearchitem();
        	ea.setsearchitem('test');
        	ea.setsearchitem1('test');
        	ea.getsearchitemstatus();
        	ea.setsearchitemstatus('test');
        	ea.setprodlinedescpicklistvalues('test');
        	ea.setprodlinedescpicklistvaluesstatus('test');
        	//EditAllforopportunity.turnOppPart2OpportunityLineItem(op);
        	ea.list_oppyPart = new list<Opportunity_Part__c>();
            ea.list_oppyPart.add(null);
        	ea.Save2();
        	system.debug('query :::4  ' + limits.getQueries());
        	Test.stopTest();
        	//ea.Massupdate();
        	ea.saverefresh();
            //ea.saveAndRefresh(); 
        	system.debug('query :::5  ' + limits.getQueries());
        	ea.ZeroPercentage();
        }
    }
    
    static testMethod void myUnitTest2() {
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
        	ExtOppyPartDiscounting.isEnergyPartManagementSave = true;
        	system.debug('query :::11  ' + limits.getQueries());
        	Test.startTest();
        	ClsTriggerFactory.setSkipHandler('AccountTrgHandler',true); 
        	ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);
        	insert op;
        	EditAllforopportunity ea = new EditAllforopportunity(new ApexPages.StandardController(oppy));
        	ea.GPLCode = 'GPLCode'; 
        	ea.GPLDescription = 'GPLDescription'; 
        	ea.Priceflag1 = true; 
        	ea.SelectedStatus = 'SelectedStatus'; 
        	ea.prodSearch = 'prodSearch'; 
        	ea.myStatus = 'myStatus'; 
        	ea.SearchCriteria = 'SearchCriteria'; 
        	system.debug('query :::22  ' + limits.getQueries());
        	Test.stopTest();
        	ea.Search1();
        	ea.showAll();
        	ea.SalesHistory();
        	ea.getPls();
        	system.debug('query :::33  ' + limits.getQueries());
        	ea.getrenderpageblock();
        	ea.cancel1();
        	ea.productInfo();
        	ea.BacktoOLI();
        	ea.getGPLCodeDescMap();
        	system.debug('query :::44  ' + limits.getQueries());
        }
    }
    
    static testMethod void myUnitTest3() {
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
        	ExtOppyPartDiscounting.isEnergyPartManagementSave = true;
        	system.debug('query :::11  ' + limits.getQueries());
        	EditAllforopportunity ea = new EditAllforopportunity(new ApexPages.StandardController(oppy));
        	Test.startTest(); 
        	insert op;
        	ea.GPLCode = 'GPLCode'; 
        	ea.GPLDescription = 'GPLDescription'; 
        	ea.Priceflag1 = true; 
        	ea.SelectedStatus = 'SelectedStatus'; 
        	ea.prodSearch = 'prodSearch'; 
        	ea.myStatus = 'myStatus'; 
        	ea.SearchCriteria = 'SearchCriteria'; 
        	system.debug('query :::22  ' + limits.getQueries());
        	//ea.saveAndRefresh();
        	Test.stopTest();
        }
    }
    
}