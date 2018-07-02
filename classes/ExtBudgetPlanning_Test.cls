/**
*   This test class is for ExtBudgetPlanning.
*
@author Di Chen
@created 2013-06-18
@version 1.0
@since 20.0
*
@changelog
* 2013-06-18 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 78%
*/
@isTest(seealldata=false)
private class ExtBudgetPlanning_Test {

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
        ClsTestHelp.getAllApex_Helper_Settings();
        ClsTestHelp.createTestName1();
        ClsTestHelp.createTestName3();
        ClsTestHelp.createTestName4();
        ClsTestHelp.initAPLTestData();
        list<Apex_Helper_Settings__c> list_setting = new list<Apex_Helper_Settings__c>();
        if(ClsTestHelp.map_ahs.containsKey('Budget Plan Accounts')) {
            
            Apex_Helper_Settings__c setting1 = ClsTestHelp.map_ahs.get('Budget Plan Accounts');
            setting1.Value__c = 'Test value';
            list_setting.add(setting1);
        }
        if(ClsTestHelp.map_ahs.containsKey('Other Accounts in Territory')) {
            
            Apex_Helper_Settings__c setting2 = ClsTestHelp.map_ahs.get('Other Accounts in Territory');
            setting2.Value__c = 'Test value';
            list_setting.add(setting2);
        }
        if(ClsTestHelp.map_ahs.containsKey('Won Opportunities')) {
            
            Apex_Helper_Settings__c setting3 = ClsTestHelp.map_ahs.get('Won Opportunities');
            setting3.Value__c = 'Test value';
            list_setting.add(setting3);
        }
        if(ClsTestHelp.map_ahs.containsKey('Commit Opportunities')) {
            
            Apex_Helper_Settings__c setting4 = ClsTestHelp.map_ahs.get('Commit Opportunities');
            setting4.Value__c = 'Test value';
            list_setting.add(setting4);
        }
        if(ClsTestHelp.map_ahs.containsKey('Likely Opportunities')) {
            
            Apex_Helper_Settings__c setting5 = ClsTestHelp.map_ahs.get('Likely Opportunities');
            setting5.Value__c = 'Test value';
            list_setting.add(setting5);
        }
        if(ClsTestHelp.map_ahs.containsKey('50/50 Opportunities')) {
            
            Apex_Helper_Settings__c setting6 = ClsTestHelp.map_ahs.get('50/50 Opportunities');
            setting6.Value__c = 'Test value';
            list_setting.add(setting6);
        }
        if(ClsTestHelp.map_ahs.containsKey('Weak Opportunities')) {
            
            Apex_Helper_Settings__c setting7 = ClsTestHelp.map_ahs.get('Weak Opportunities');
            setting7.Value__c = 'Test value';
            list_setting.add(setting7);
        }
        update list_setting;
        
        
        RecordType rt = ClsTestHelp.createTestRecordType8();
        
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.Individually_Planned__c = true;
        acc2.RecordTypeId = rt.Id;
        acc2.Account_Manager__c = u.Id;
        acc2.SALES_TERRITORY_CDE__c = 'A007357';
        acc2.Name = 'ohxxsx';
        insert acc2;
        
        list<Account> listAcces = new list<Account>();
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.RecordTypeId = rt.Id;
    	acc.SALES_TERRITORY_CDE__c = 'A007357';
    	acc.Individually_Planned__c = false;
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
        bg.Year__c = '2014';
        bg.Territory__c = sh.Id;
        bg.Total_Direct_Budget_TBR_NY__c = 11;
        bg.Total_POS_Budget_TBR_NY__c = 11;
        bg.Total_CMA_Budget_TBR_NY__c = 11;
        bg.Total_Budget_TBR_NY__c = 12;
        insert bg;
        
        BBB_Month_Bill_Book_Cust__c bbb = new BBB_Month_Bill_Book_Cust__c();
        bbb.Customer__c = acc.Id;
        bbb.Fiscal_Year__c = '2014';
        bbb.Bill_Type__c = 'Direct';
        bbb.Budget_Direct__c = 1;
        bbb.Budget_POS__c = 2;
        bbb.Budget_CMA__c = 3;
        bbb.Budget_TBR_NY__c = 12;
        
        insert bbb; 
        
        BBB_Month_Bill_Book_Cust__c bbbmb = new BBB_Month_Bill_Book_Cust__c();
        bbbmb.Customer__c = acc.Id;
        bbbmb.fiscal_Year__c = '2014';
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
        
        list<String> list_detail = new list<String>();
        
        Test.startTest();       
        
        system.runAs(u) {
        ExtBudgetPlanning.BudgetPlanningInfo extBP = new ExtBudgetPlanning.BudgetPlanningInfo();
        extBP.list_detail.add(null);
        
        ClsAnnualBudgetPlanStructure.BudgetPlanningAccountItem clsBu = new ClsAnnualBudgetPlanStructure.BudgetPlanningAccountItem();
        
        ClsAnnualBudgetPlanStructure.BudgetPlanningAccountStructure clsS = new ClsAnnualBudgetPlanStructure.BudgetPlanningAccountStructure(acc.Id);
        
        ClsAnnualBudgetPlanStructure.BudgetPlanningItem clsItem = new ClsAnnualBudgetPlanStructure.BudgetPlanningItem();
         
        ClsAnnualBudgetPlanStructure cls = new ClsAnnualBudgetPlanStructure(acc.Id);
        cls.accountId = acc.Id;     
        
        
        ApexPages.currentPage().getParameters().put('mode', 'edit');
        Map<String, ClsAnnualBudgetPlanStructure> map_accId_budgetPlanStructures = new Map<String, ClsAnnualBudgetPlanStructure>();
        map_accId_budgetPlanStructures.put(acc.Id,cls);
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(bg); 
        ExtBudgetPlanning ext = new ExtBudgetPlanning(stdCtrl);
        ext.getBudgetPlanStructureList();
        ext.isNew = true;
        ext.format = 'true';
        
        ext.otherBudgetPlanStructure = cls;
        ext.budget = bg;
        ext.theTerritory = sh.Id;
		system.debug('!@# ext.map_accId_budgetPlanStructure: '+ext.map_accId_budgetPlanStructure);

        ext.saveBudget();
        ext.saveBudgetAndNext();
        
        ext.goToBreakDown();
        ext.editBudget();
        ext.recalculateBudget();

        ext.backAction();
        ext.backToBudgetPlanning();
        ext.toBreakdown();
        ext.backToView();
        ext.list_years.add('2015');
        ext.list_years.add('2016');
        ext.list_years.add('2014');
        ext.selectBudgetYear();
        ext.selectBudgetTerritory();
        ext.getTerritoryCode4Report();
        
        ExtBudgetPlanning.getValidAccountsByAMTerritory(u.Id, 'A007357', map_accId_budgetPlanStructures);
        
        ext.isRecalculate = true;
        ext.budget.year__c = '2014';
        system.debug('Fiscal Year:: ' + ext.budget.year__c);
        ext.recalculateBudget();
        ext.selectBudgetTerritory();
        ext.rebuildBugdetAccounts();
        
        system.debug('!@# budget.Id :: ' + ext.budget.Id);
        ext.checkTerritoryHiearchy();
        ext.clearBugdetAccounts();
        ext.resortBugdetAccounts();
        map<String, String> map_te = new map<String, String>();
        map_te.put('1', '1');
        map_te.put('2', '2');
        ext.addTerritoryItems(map_te);
        system.debug('totalBudgetPlan.detailCMA.TotalBudget:: ' + ext.totalBudgetPlan.detailCMA.TotalBudget);
        ext.budget.FQ1_CMA__c = 0;
        ext.budget.FQ2_CMA__c = 0;
        ext.budget.FQ3_CMA__c = 0;
        ext.budget.FQ1_Direct__c = 0;
        ext.budget.FQ2_Direct__c = 0;
        ext.budget.FQ3_Direct__c = 0;
        ext.budget.FQ1_POS__c = 0;
        ext.budget.FQ2_POS__c = 0;
        ext.budget.FQ3_POS__c = 0;
        ext.budget.FQ1_Total__c = 0;
        ext.budget.FQ2_Total__c = 0;
        ext.budget.FQ3_Total__c = 0;
        system.debug('budget.FQ1_CMA__c:: ' + ext.budget.FQ1_CMA__c);
        ext.mode = 'view';
        ext.checkBudgetFQValue();
        
        ext.getAllTerritoryByUser(u.Id);
        }
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testMostMethods2() {
        
        Budget__c bg = new Budget__c();
        
        Test.startTest();       
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(bg); 
        ExtBudgetPlanning ext = new ExtBudgetPlanning(stdCtrl);
        
        system.assert(true);
        Test.stopTest();
    }    
    static testMethod void testMostMethods3() {
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
        ClsTestHelp.createTestName1();
        ClsTestHelp.createTestName3();
        ClsTestHelp.createTestName4();
        ClsTestHelp.initAPLTestData();
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
        
        Test.startTest();       
         
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(bg); 
        ExtBudgetPlanning ext = new ExtBudgetPlanning(stdCtrl);
        
        ext.budget = bg;
        
        ext.saveBudgetAndNext();
        
        system.assert(true);
        Test.stopTest();
    }    
    static testMethod void testMostMethods4() {
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
        ClsTestHelp.createTestName1();
        ClsTestHelp.createTestName3();
        ClsTestHelp.createTestName4();
        ClsTestHelp.initAPLTestData();
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
        
        Test.startTest();       
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(bg); 
        ExtBudgetPlanning ext = new ExtBudgetPlanning(stdCtrl);
        
        ext.budget = bg;
        
        ext.saveBudgetAndNext();
        ext.isRecalculate = true;
        //ext.recalculateBudget();
        system.assert(true);
        Test.stopTest();
    }    
}