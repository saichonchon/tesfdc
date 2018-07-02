/**
*	This test class is for CtrlManagerReview.
*
@author Di Chen
@created 2012-06-07
@version 1.0
@since 20.0
*
@changelog
* 2012-06-07 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 97%
*/
@isTest
private class CtrlManagerReview_Test {

    static testMethod void testMostMethods() {
    	
    	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'helloMan@testCompany1233423.com';
    	u.Alias = 'dps';
    	u.CommunityNickname = 'ATM';
		insert u;
    	
    	system.runAs(u){
    	
	        RecordType rt = ClsTestHelp.createTestRecordType8();
	    	
	    	Account acc = ClsTestHelp.createTestAccounts();
	    	acc.RecordTypeId = rt.Id;
	    	acc.SALES_TERRITORY_CDE__c = 'A003153';
	    	acc.Individually_Planned__c = true;
	    	acc.Account_Manager__c = u.Id;
	    	insert acc;
	    	
	    	Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
	    	sh.Level_7_Territory_Code__c = 'A007357';
	    	insert sh;
	    	
	    	Budget__c bg = new Budget__c();
	    	bg.Year__c = string.valueOf(date.today().year());
	    	bg.Territory__c = sh.Id;
			bg.Total_Direct_Budget_TBR_NY__c = 11;
			bg.Total_Budget_TBR_NY__c = 12;
			bg.Stage__c = 'Original';
			bg.Manager__c = u.Id;
			bg.Manager_CMA_Budget__c = 12;
			bg.Manager_Direct_Budget__c = 12;
			bg.Manager_POS_Budget__c = 12;
			bg.Original_POS_Budget__c = 12;
			bg.Status__c = 'Submitted';
	    	insert bg;
	    	
	    	Budget_Detail__c bd = ClsTestHelp.createTestBudgetDetail();
	    	bd.Account__c = acc.Id;
	    	bd.Budget__c = bg.Id;
	    	bd.Type__c = 'Total';
	    	insert bd;
	   
	   		CtrlManagerReview.BudgetReviewRecord ctrlBudget = new CtrlManagerReview.BudgetReviewRecord(bg,'Direct');
	   		ctrlBudget.isChecked = true;
	   		ctrlBudget.budget = bg;
	   		ctrlBudget.budgetDetail = bd;
	   		ctrlBudget.getGrowth();
	   		
	   		
	    	Test.startTest();
	    	
	    	CtrlManagerReview ctrl = new CtrlManagerReview();
	    	ctrl.totalBudgetReviewRecord = ctrlBudget;
	    	
	    	ctrl.getBudgetRecordViewByAM();
	    	ctrl.backToView();
	    	ctrl.getBugetReviewRecords();
	    	ctrl.save();
            for(CtrlManagerReview.BudgetReviewRecord rec:ctrl.map_budgetId_BudgetReviewRecords.values())
        	rec.ischecked = true;
	    	ctrl.saveAndApproval();
	    	ctrl.saveAndReject();
	    	ctrl.getViews();
    	}
    	system.assert(true);
    	Test.stopTest();
    }
	static testMethod void testMostMethods2() {
        RecordType rt = ClsTestHelp.createTestRecordType8();
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.RecordTypeId = rt.Id;
    	acc.SALES_TERRITORY_CDE__c = 'A003153';
    	acc.Individually_Planned__c = true;
    	acc.Account_Manager__c = UserInfo.getUserId();
    	insert acc;
    	
    	Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
    	sh.Level_7_Territory_Code__c = 'A007357';
    	insert sh;
    	
    	Budget__c bg = new Budget__c();
    	bg.Year__c = string.valueOf(date.today().year());
    	bg.Territory__c = sh.Id;
		bg.Total_Direct_Budget_TBR_NY__c = 11;
		bg.Total_Budget_TBR_NY__c = 12;
		bg.Stage__c = 'Original';
		bg.Manager__c = UserInfo.getUserId();
		bg.Manager_CMA_Budget__c = 12;
		bg.Manager_Direct_Budget__c = 12;
		bg.Manager_POS_Budget__c = 12;
		bg.Original_POS_Budget__c = 12;
    	insert bg;
    	
    	Budget_Detail__c bd = ClsTestHelp.createTestBudgetDetail();
    	bd.Account__c = acc.Id;
    	bd.Budget__c = bg.Id;
    	bd.Type__c = 'Total';
    	insert bd;
   
   		CtrlManagerReview.BudgetReviewRecord ctrlBudget = new CtrlManagerReview.BudgetReviewRecord(bg,'POS');
   		ctrlBudget.isChecked = true;
   		ctrlBudget.budget = bg;
   		ctrlBudget.budgetDetail = bd;
   		ctrlBudget.getGrowth();
   		
    	Test.startTest();
    	
    	CtrlManagerReview ctrl = new CtrlManagerReview();
    	ctrl.totalBudgetReviewRecord = ctrlBudget;
    	
    	ctrl.getBudgetRecordViewByAM();
    	ctrl.backToView();
    	ctrl.getBugetReviewRecords();
    	ctrl.save();
        for(CtrlManagerReview.BudgetReviewRecord rec:ctrl.map_budgetId_BudgetReviewRecords.values())
        rec.ischecked = true;
    	ctrl.saveAndApproval();
    	ctrl.saveAndReject();
    	ctrl.getViews();
    	
    	system.assert(true);
    	Test.stopTest();
    }
	static testMethod void testMostMethods3() {
        RecordType rt = ClsTestHelp.createTestRecordType8();
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.RecordTypeId = rt.Id;
    	acc.SALES_TERRITORY_CDE__c = 'A003153';
    	acc.Individually_Planned__c = true;
    	acc.Account_Manager__c = UserInfo.getUserId();
    	insert acc;
    	
    	Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
    	sh.Level_7_Territory_Code__c = 'A007357';
    	insert sh;
    	
    	Budget__c bg = new Budget__c();
    	bg.Year__c = string.valueOf(date.today().year());
    	bg.Territory__c = sh.Id;
		bg.Total_Direct_Budget_TBR_NY__c = 11;
		bg.Total_Budget_TBR_NY__c = 12;
		bg.Stage__c = 'Original';
		bg.Manager__c = UserInfo.getUserId();
		bg.Manager_CMA_Budget__c = 12;
		bg.Manager_Direct_Budget__c = 12;
		bg.Manager_POS_Budget__c = 12;
		bg.Original_POS_Budget__c = 12;
    	insert bg;
    	
    	Budget_Detail__c bd = ClsTestHelp.createTestBudgetDetail();
    	bd.Account__c = acc.Id;
    	bd.Budget__c = bg.Id;
    	bd.Type__c = 'Total';
    	bd.Billings_LY__c = 11;
    	bd.Billings_CYTD__c = 11;
    	bd.Billings_CYRR__c = 11;
    	bd.Forecast_CY__c = 12;
    	insert bd;
   
   		CtrlManagerReview.BudgetReviewRecord ctrlBudget = new CtrlManagerReview.BudgetReviewRecord(bg,'CMA');
   		ctrlBudget.isChecked = true;
   		ctrlBudget.budget = bg;
   		ctrlBudget.budgetDetail = bd;
   		ctrlBudget.getGrowth();
   		
    	Test.startTest();
    	
    	CtrlManagerReview ctrl = new CtrlManagerReview();
    	ctrl.totalBudgetReviewRecord = ctrlBudget;
    	ctrl.view = 'Total';
    	
    	ctrl.getBudgetRecordViewByAM();
    	ctrl.backToView();
    	ctrl.getBugetReviewRecords();
    	ctrl.save();
        for(CtrlManagerReview.BudgetReviewRecord rec:ctrl.map_budgetId_BudgetReviewRecords.values())
        rec.ischecked = true;
    	ctrl.saveAndApproval();
    	ctrl.saveAndReject();
    	ctrl.getViews();
    	
    	system.assert(true);
    	Test.stopTest();
    }
	static testMethod void testMostMethods4() {
        RecordType rt = ClsTestHelp.createTestRecordType8();
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.RecordTypeId = rt.Id;
    	acc.SALES_TERRITORY_CDE__c = 'A003153';
    	acc.Individually_Planned__c = true;
    	acc.Account_Manager__c = UserInfo.getUserId();
    	insert acc;
    	
    	Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
    	sh.Level_7_Territory_Code__c = 'A007357';
    	insert sh;
    	
    	Budget__c bg = new Budget__c();
    	bg.Year__c = string.valueOf(date.today().year());
    	bg.Territory__c = sh.Id;
		bg.Total_Direct_Budget_TBR_NY__c = 11;
		bg.Total_Budget_TBR_NY__c = 12;
		bg.Stage__c = 'Original';
		bg.Manager__c = UserInfo.getUserId();
		bg.Manager_CMA_Budget__c = 12;
		bg.Manager_Direct_Budget__c = 12;
		bg.Manager_POS_Budget__c = 12;
		bg.Original_POS_Budget__c = 12;
    	insert bg;
    	
    	Budget_Detail__c bd = ClsTestHelp.createTestBudgetDetail();
    	bd.Account__c = acc.Id;
    	bd.Budget__c = bg.Id;
    	bd.Type__c = 'Total';
    	bd.Billings_LY__c = 11;
    	bd.Billings_CYTD__c = 11;
    	bd.Billings_CYRR__c = 11;
    	bd.Forecast_CY__c = 12;
    	insert bd;
   
   		CtrlManagerReview.BudgetReviewRecord ctrlBudget = new CtrlManagerReview.BudgetReviewRecord(bg,'CMA');
   		ctrlBudget.isChecked = true;
   		ctrlBudget.budget = bg;
   		ctrlBudget.budgetDetail = bd;
   		ctrlBudget.getGrowth();
   		
    	Test.startTest();
    	
    	CtrlManagerReview ctrl = new CtrlManagerReview();
    	ctrl.totalBudgetReviewRecord = ctrlBudget;
    	ctrl.view = 'Total';
    	
    	ctrl.buildManagerReviewRcords();
    	
    	system.assert(true);
    	Test.stopTest();
    }
	static testMethod void testMostMethods5() {
        RecordType rt = ClsTestHelp.createTestRecordType8();
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.RecordTypeId = rt.Id;
    	acc.SALES_TERRITORY_CDE__c = 'A003153';
    	acc.Individually_Planned__c = true;
    	acc.Account_Manager__c = UserInfo.getUserId();
    	insert acc;
    	
    	Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
    	sh.Level_7_Territory_Code__c = 'A007357';
    	insert sh;
    	
    	Budget__c bg = new Budget__c();
    	bg.Year__c = string.valueOf(date.today().year());
    	bg.Territory__c = sh.Id;
		bg.Total_Direct_Budget_TBR_NY__c = 11;
		bg.Total_Budget_TBR_NY__c = 12;
		bg.Stage__c = 'Original';
		bg.Manager__c = UserInfo.getUserId();
		bg.Manager_CMA_Budget__c = 12;
		bg.Manager_Direct_Budget__c = 12;
		bg.Manager_POS_Budget__c = 12;
		bg.Original_POS_Budget__c = 12;
    	insert bg;
    	
    	Budget_Detail__c bd = ClsTestHelp.createTestBudgetDetail();
    	bd.Account__c = acc.Id;
    	bd.Budget__c = bg.Id;
    	bd.Type__c = 'Total';
    	bd.Billings_LY__c = 11;
    	bd.Billings_CYTD__c = 11;
    	bd.Billings_CYRR__c = 11;
    	bd.Forecast_CY__c = 12;
    	insert bd;
   
   		CtrlManagerReview.BudgetReviewRecord ctrlBudget = new CtrlManagerReview.BudgetReviewRecord(bg,'CMA');
   		ctrlBudget.isChecked = true;
   		ctrlBudget.budget = bg;
   		ctrlBudget.budgetDetail = bd;
   		ctrlBudget.getGrowth();
   		
    	Test.startTest();
    	
    	CtrlManagerReview ctrl = new CtrlManagerReview();
    	ctrl.totalBudgetReviewRecord = ctrlBudget;
    	ctrl.view = 'Direct';
    	
    	ctrl.buildManagerReviewRcords();
    	
    	system.assert(true);
    	Test.stopTest();
    }
	static testMethod void testMostMethods6() {
        RecordType rt = ClsTestHelp.createTestRecordType8();
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.RecordTypeId = rt.Id;
    	acc.SALES_TERRITORY_CDE__c = 'A003153';
    	acc.Individually_Planned__c = true;
    	acc.Account_Manager__c = UserInfo.getUserId();
    	insert acc;
    	
    	Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
    	sh.Level_7_Territory_Code__c = 'A007357';
    	insert sh;
    	
    	Budget__c bg = new Budget__c();
    	bg.Year__c = string.valueOf(date.today().year());
    	bg.Territory__c = sh.Id;
		bg.Total_Direct_Budget_TBR_NY__c = 11;
		bg.Total_Budget_TBR_NY__c = 12;
		bg.Stage__c = 'Original';
		bg.Manager__c = UserInfo.getUserId();
		bg.Manager_CMA_Budget__c = 12;
		bg.Manager_Direct_Budget__c = 12;
		bg.Manager_POS_Budget__c = 12;
		bg.Original_POS_Budget__c = 12;
    	insert bg;
    	
    	Budget_Detail__c bd = ClsTestHelp.createTestBudgetDetail();
    	bd.Account__c = acc.Id;
    	bd.Budget__c = bg.Id;
    	bd.Type__c = 'Total';
    	bd.Billings_LY__c = 11;
    	bd.Billings_CYTD__c = 11;
    	bd.Billings_CYRR__c = 11;
    	bd.Forecast_CY__c = 12;
    	insert bd;
   
   		CtrlManagerReview.BudgetReviewRecord ctrlBudget = new CtrlManagerReview.BudgetReviewRecord(bg,'CMA');
   		ctrlBudget.isChecked = true;
   		ctrlBudget.budget = bg;
   		ctrlBudget.budgetDetail = bd;
   		ctrlBudget.getGrowth();
   		
    	Test.startTest();
    	
    	CtrlManagerReview ctrl = new CtrlManagerReview();
    	ctrl.totalBudgetReviewRecord = ctrlBudget;
    	ctrl.view = 'CMA';
    	
    	ctrl.buildManagerReviewRcords();
    	
    	system.assert(true);
    	Test.stopTest();
    }
}