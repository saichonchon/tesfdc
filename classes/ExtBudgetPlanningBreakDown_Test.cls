/**
*   This test class is for ExtBudgetPlanningBreakDown.
*
@author Di Chen
@created 2013-06-18
@version 1.0
@since 20.0
*
@changelog
* 2013-06-18 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 
*/
@isTest
private class ExtBudgetPlanningBreakDown_Test {

    static testMethod void testMostMethods() {
		Profile p = [Select Id, Name From Profile 
     								where Name = 'Production Support' 
     								or Name = 'Service Account' 
     								or Name ='System Administrator' 
     								or Name ='Systemadministrator' limit 1];
     	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'az@testCompany1233423.com';
    	u.Alias = 'dpse'; 
    	u.CommunityNickname = 'TMD';
    	u.ProfileId = p.Id;
		insert u;
    	
    	RecordType rt = ClsTestHelp.createTestRecordType8();
    	
    	Account acc2 = ClsTestHelp.createTestAccounts();
    	acc2.Individually_Planned__c = true;
    	acc2.Account_Manager__c = u.Id;
    	acc2.SALES_TERRITORY_CDE__c = 'A007357';
    	acc2.Name = 'ohxxsx';
    	insert acc2;
    	
    	list<Account> listAcces = new list<Account>();
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.RecordTypeId = rt.Id;
    	acc.SALES_TERRITORY_CDE__c = 'A007357';
    	acc.Individually_Planned__c = true;
    	acc.Account_Manager__c = u.Id;
    	acc.Plan_Group_Account__c = acc2.Id;
    	listAcces.add(acc);
    	
    	Account acc3 = ClsTestHelp.createTestAccounts();
    	acc3.Individually_Planned__c = true;
    	acc3.RecordTypeId = rt.Id;
    	acc3.Account_Manager__c = u.Id;
    	acc3.SALES_TERRITORY_CDE__c = 'A007357';
    	acc3.Name = 'oinioTest';
    	listAcces.add(acc3);
    	insert listAcces;

    	Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
    	sh.Level_7_Territory_Code__c = 'A007357';
    	insert sh;
    	
    	Budget__c bg = new Budget__c();
    	bg.Year__c = '2012';
    	bg.Territory__c = sh.Id;
		bg.Total_Direct_Budget_TBR_NY__c = 11;
		bg.Total_POS_Budget_TBR_NY__c = 11;
		bg.Total_CMA_Budget_TBR_NY__c = 11;
		bg.Total_Budget_TBR_NY__c = 12;
    	insert bg;
    	
    	BBB_Month_Bill_Book_Cust__c bbb = new BBB_Month_Bill_Book_Cust__c();
    	bbb.Customer__c = acc.Id;
    	bbb.Fiscal_Year__c = '2012';
    	bbb.Bill_Type__c = 'Direct';
    	bbb.Budget_Direct__c = 1;
    	bbb.Budget_POS__c = 2;
    	bbb.Budget_CMA__c = 3;
    	bbb.Budget_TBR_NY__c = 12;
    	insert bbb; 
    	
    	BBB_Month_Bill_Book_Cust__c bbbmb = new BBB_Month_Bill_Book_Cust__c();
    	bbbmb.Customer__c = acc.Id;
    	bbbmb.fiscal_Year__c = '2012';
    	insert bbbmb;
    	
    	RecordType rtbdAcc, trbdOther;
    	for(RecordType rttemp : [select Id, DeveloperName from RecordType where SobjectType='Budget_Detail__c' and DeveloperName IN ('Account','Other')]) {
    		if(rttemp.DeveloperName == 'Account') {
    			rtbdAcc = rttemp;
    		}else if(rttemp.DeveloperName == 'Other') {
    			trbdOther = rttemp;
    		}
    	}
    	
    	 
    	list<Budget_Detail__c> listBDs = new list<Budget_Detail__c>();
    	Budget_Detail__c bd1 = ClsTestHelp.createTestBudgetDetail();
    	bd1.Account__c = acc.Id;
    	bd1.Budget__c = bg.Id;
    	bd1.Type__c = 'Direct';
    	bd1.RecordTypeId = rtbdAcc.Id;
    	Budget_Detail__c bd2 = ClsTestHelp.createTestBudgetDetail();
    	bd2.Account__c = acc.Id;
    	bd2.Budget__c = bg.Id;
    	bd2.Type__c = 'POS';
    	bd1.RecordTypeId = rtbdAcc.Id;
    	Budget_Detail__c bd3 = ClsTestHelp.createTestBudgetDetail();
    	bd3.Account__c = acc.Id;
    	bd3.Budget__c = bg.Id;
    	bd3.Type__c = 'CMA';
    	bd1.RecordTypeId = rtbdAcc.Id;
    	Budget_Detail__c bd4 = ClsTestHelp.createTestBudgetDetail();
    	bd4.Account__c = acc2.Id;
    	bd4.Budget__c = bg.Id;
    	bd4.Type__c = 'Direct';
    	bd1.RecordTypeId = rtbdAcc.Id;
    	Budget_Detail__c bd5 = ClsTestHelp.createTestBudgetDetail();
    	bd5.Account__c = acc2.Id;
    	bd5.Budget__c = bg.Id;
    	bd5.Type__c = 'POS';
    	bd1.RecordTypeId = rtbdAcc.Id;
    	Budget_Detail__c bd6 = ClsTestHelp.createTestBudgetDetail();
    	bd6.Account__c = acc2.Id;
    	bd6.Budget__c = bg.Id;
    	bd6.Type__c = 'CMA';
    	bd1.RecordTypeId = rtbdAcc.Id;
    	listBDs.add(bd1);
    	listBDs.add(bd2);
    	listBDs.add(bd3);
    	listBDs.add(bd4);
    	listBDs.add(bd5);
    	listBDs.add(bd6);
    	
    	Budget_Detail__c bdother1 = ClsTestHelp.createTestBudgetDetail();
    	bdother1.Account__c = acc3.Id;
    	bdother1.Budget__c = bg.Id;
    	bdother1.Type__c = 'Direct';
    	bdother1.RecordTypeId = trbdOther.Id;
    	Budget_Detail__c bdother2 = ClsTestHelp.createTestBudgetDetail();
    	bdother2.Account__c = acc3.Id;
    	bdother2.Budget__c = bg.Id;
    	bdother2.Type__c = 'POS';
    	bdother2.RecordTypeId = trbdOther.Id;
    	Budget_Detail__c bdother3 = ClsTestHelp.createTestBudgetDetail();
    	bdother3.Account__c = acc3.Id;
    	bdother3.Budget__c = bg.Id;
    	bdother3.Type__c = 'CMA';
    	bdother3.RecordTypeId = trbdOther.Id;
    	listBDs.add(bdother1);
    	listBDs.add(bdother2);
    	listBDs.add(bdother3);
    	insert listBDs;

    	Test.startTest();        
       		
       	ClsBudgetPlanBreakDownStructure cls2 = new ClsBudgetPlanBreakDownStructure(rt.Id,acc.Id);
       	List<ClsBudgetPlanBreakDownStructure> list_budgetPlanStructure = new List<ClsBudgetPlanBreakDownStructure>();
       	list_budgetPlanStructure.add(cls2);
       	 
    	ApexPages.currentPage().getParameters().put('id',bg.Id);
    	 	
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(bg); 
        ExtBudgetPlanningBreakDown ext = new ExtBudgetPlanningBreakDown(stdCtrl);  
        system.debug('!@# ext.sJsonTest:'+ext.sJsonTest); 
        
        ext.getBudgetPlanBreakDownStructureList(); 
        //ext.budget = bg; 	
    	ext.otherBudgetPlanStructure = cls2;
    	//ext.list_budgetPlanStructure = list_budgetPlanStructure;

    	ext.recalculate();

    	list<ExtBudgetPlanningBreakDown.BudgetDetail> list_data = new list<ExtBudgetPlanningBreakDown.BudgetDetail>();
    	ExtBudgetPlanningBreakDown.BudgetDetail db1 = new ExtBudgetPlanningBreakDown.BudgetDetail();
    	db1.accid = acc.Id;
    	db1.TotalBudget4Direct = 5;
    	db1.TotalBudget4POS = 5;
    	db1.TotalBudget4CMA = 5;
    	ExtBudgetPlanningBreakDown.BudgetDetail db2 = new ExtBudgetPlanningBreakDown.BudgetDetail();
    	db2.accid = acc2.Id;
    	db2.TotalBudget4Direct = 5;
    	db2.TotalBudget4POS = 5;
    	db2.TotalBudget4CMA = 5;
    	ExtBudgetPlanningBreakDown.BudgetDetail db3 = new ExtBudgetPlanningBreakDown.BudgetDetail();
    	db3.accid = acc3.Id;
    	db3.TotalBudget4Direct = 5;
    	db3.TotalBudget4POS = 5;
    	db3.TotalBudget4CMA = 5;

    	list_data.add(db1);
    	list_data.add(db2);
    	list_data.add(db3);
    	ext.saveJson = Json.serialize(list_data);
 
    	ApexPages.currentPage().getParameters().put('isSubmit','true');
    	ext.budget.Manager__c = u.Id;
    	ext.save();
    	ext.saveAndSubmit();
    	ext.back();
    	ext.saveBreakDown();
    	//ext.map_accId_budgetPlanStructuresJson = Jsonmap_accId_budgetPlanStructures;
    	ext.saveBreakDownBudgetDetail(); 

    	system.assert(true);
    	Test.stopTest();
    }
    /*static testMethod void testMostMethods2() {
		Profile p = [Select Id, Name From Profile 
     								where Name = 'Production Support' 
     								or Name = 'Service Account' 
     								or Name ='System Administrator' 
     								or Name ='Systemadministrator' limit 1];
     	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'az@testCompany1233423.com';
    	u.Alias = 'dpse'; 
    	u.CommunityNickname = 'TMD';
    	u.ProfileId = p.Id;
		insert u;
    	
    	RecordType rt = ClsTestHelp.createTestRecordType8();
    	
    	Account acc2 = ClsTestHelp.createTestAccounts();
    	acc2.Individually_Planned__c = true;
    	acc2.Account_Manager__c = u.Id;
    	acc2.SALES_TERRITORY_CDE__c = '021';
    	acc2.Name = 'ohxxsx';
    	insert acc2;
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.RecordTypeId = rt.Id;
    	acc.SALES_TERRITORY_CDE__c = 'A007357';
    	acc.Individually_Planned__c = true;
    	acc.Account_Manager__c = u.Id;
    	acc.Plan_Group_Account__c = acc2.Id;
    	insert acc;
    	
    	Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
    	sh.Level_7_Territory_Code__c = 'A007357';
    	insert sh;
    	
    	Budget__c bg = new Budget__c();
    	bg.Year__c = '2012';
    	bg.Territory__c = sh.Id;
		bg.Total_Direct_Budget_TBR_NY__c = 11;
		bg.Total_POS_Budget_TBR_NY__c = 11;
		bg.Total_CMA_Budget_TBR_NY__c = 11;
		bg.Total_Budget_TBR_NY__c = 12;
    	insert bg;
    	
    	BBB_Month_Bill_Book_Cust__c bbb = new BBB_Month_Bill_Book_Cust__c();
    	bbb.Customer__c = acc.Id;
    	bbb.Fiscal_Year__c = '2012';
    	bbb.Bill_Type__c = 'Direct';
    	bbb.Budget_Direct__c = 1;
    	bbb.Budget_POS__c = 2;
    	bbb.Budget_CMA__c = 3;
    	bbb.Budget_TBR_NY__c = 12;
    	insert bbb; 
    	
    	BBB_Month_Bill_Book_Cust__c bbbmb = new BBB_Month_Bill_Book_Cust__c();
    	bbbmb.Customer__c = acc.Id;
    	bbbmb.fiscal_Year__c = '2012';
    	insert bbbmb;
    	
    	list<Budget_Detail__c> listBDs = new list<Budget_Detail__c>();
    	Budget_Detail__c bd1 = ClsTestHelp.createTestBudgetDetail();
    	bd1.Account__c = acc.Id;
    	bd1.Budget__c = bg.Id;
    	bd1.Type__c = 'Direct';
    	Budget_Detail__c bd2 = ClsTestHelp.createTestBudgetDetail();
    	bd2.Account__c = acc.Id;
    	bd2.Budget__c = bg.Id;
    	bd2.Type__c = 'POS';
    	Budget_Detail__c bd3 = ClsTestHelp.createTestBudgetDetail();
    	bd3.Account__c = acc.Id;
    	bd3.Budget__c = bg.Id;
    	bd3.Type__c = 'CMA';
    	Budget_Detail__c bd4 = ClsTestHelp.createTestBudgetDetail();
    	bd4.Account__c = acc2.Id;
    	bd4.Budget__c = bg.Id;
    	bd4.Type__c = 'Direct';
    	Budget_Detail__c bd5 = ClsTestHelp.createTestBudgetDetail();
    	bd5.Account__c = acc2.Id;
    	bd5.Budget__c = bg.Id;
    	bd5.Type__c = 'POS';
    	Budget_Detail__c bd6 = ClsTestHelp.createTestBudgetDetail();
    	bd6.Account__c = acc2.Id;
    	bd6.Budget__c = bg.Id;
    	bd6.Type__c = 'CMA';
    	listBDs.add(bd1);
    	listBDs.add(bd2);
    	listBDs.add(bd3);
    	listBDs.add(bd4);
    	listBDs.add(bd5);
    	listBDs.add(bd6);
    	insert listBDs;
    	
    	Test.startTest();        
       		
    	ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem clsAcc = new ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem(acc.Id,'','EUR');
    	
        ClsBudgetPlanBreakDownStructure cls = new ClsBudgetPlanBreakDownStructure(rt.Id,acc.Id);
        cls.isRecalculate = true;
        cls.accountId = acc.Id;
        
        cls.setParentAccountItem(clsAcc);
        cls.getAccountId4Report();
        cls.getParentAccountItem();
        cls.getChildrenAccountItems();
        cls.calAccountDetailValue(1, 2, 3);
        cls.calAccountFCValue(1, 2, 3, 4, 'other');
        cls.calAccountFCValue(1, 2, 3, 4, '');
        
       	List<ClsBudgetPlanBreakDownStructure> list_budgetPlanStructure = new List<ClsBudgetPlanBreakDownStructure>();
       	list_budgetPlanStructure.add(cls);
       	 
    	ApexPages.currentPage().getParameters().put('id',bg.Id);
    	 	
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(bg); 
        ExtBudgetPlanningBreakDown ext = new ExtBudgetPlanningBreakDown(stdCtrl);   
        
        ext.budget = bg; 	
    	ext.otherBudgetPlanStructure = cls;
    	//ext.list_budgetPlanStructure = list_budgetPlanStructure;
    	
    	list<ExtBudgetPlanningBreakDown.BudgetDetail> list_data = new list<ExtBudgetPlanningBreakDown.BudgetDetail>();
    	ExtBudgetPlanningBreakDown.BudgetDetail db1 = new ExtBudgetPlanningBreakDown.BudgetDetail();
    	db1.accid = acc.Id;
    	db1.TotalBudget4Direct = 5;
    	db1.TotalBudget4POS = 5;
    	db1.TotalBudget4CMA = 5;
    	list_data.add(db1);
    	ext.saveJson = Json.serialize(list_data);
    	ext.budget.Manager__c = u.Id;
    	ext.saveBreakDown(); 
    	//ext.map_accId_budgetPlanStructuresJson = Jsonmap_accId_budgetPlanStructures;
    	ApexPages.currentPage().getParameters().put('isSubmit','true');
    	ext.saveBreakDownBudgetDetail(); 
    	system.assert(true);
    	Test.stopTest();
    }    */
}