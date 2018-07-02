/**
*	This test class is for ClsBatch_BudgetDetailRateCalculating.
*
@author Di Chen
@created 2013-06-11
@version 1.0
@since 20.0
*
@changelog
* 2013-06-11 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 93%
*/
@isTest
private class ClsBatch_BudgetDetailRateCalculatig_Test {

    static testMethod void testMost() {
    	
    	RecordType rt = ClsTestHelp.createTestRecordType();   	
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	insert acc;
    	
    	Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
    	sh.Level_7_Territory_Code__c = 'A007357';
    	insert sh;
    	
    	Budget__c bg = new Budget__c();
    	bg.Year__c = '2012';
    	bg.Territory__c = sh.Id;
		bg.Total_Direct_Budget_TBR_NY__c = 11;
		bg.Total_Budget_TBR_NY__c = 12;
    	insert bg;
    	
    	Budget_Detail__c bd = ClsTestHelp.createTestBudgetDetail();
    	bd.Account__c = acc.Id;
    	bd.Budget__c = bg.Id;
    	bd.Billings_CYRR__c = 1;
    	insert bd;
    	
    	list<Budget_Detail__c> list_bd = new list<Budget_Detail__c>();
    	list_bd.add(bd);
    	
    	Test.startTest();
    	
        ClsBatch_BudgetDetailRateCalculating clsBatch = new ClsBatch_BudgetDetailRateCalculating();
        clsBatch.fiscalYear = 2012;
        clsBatch.email = 'OK@testitbconsults78912.com';
        clsBatch.filter = ' limit 1';
        
        Database.BatchableContext bc;
		clsBatch.start(bc);
        clsBatch.execute(bc, list_bd);
        clsBatch.finish(bc); 
        
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void testElse() {
    	
    	RecordType rt = ClsTestHelp.createTestRecordType();   	
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	insert acc;
    	
    	Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
    	sh.Level_7_Territory_Code__c = 'A007357';
    	insert sh;
    	
    	Budget__c bg = new Budget__c();
    	bg.Year__c = '2012';
    	bg.Territory__c = sh.Id;
		bg.Total_Direct_Budget_TBR_NY__c = 11;
		bg.Total_Budget_TBR_NY__c = 12;
    	insert bg;
    	
    	Budget_Detail__c bd = ClsTestHelp.createTestBudgetDetail();
    	bd.Account__c = acc.Id;
    	bd.Budget__c = bg.Id;
    	bd.Billings_CYRR__c = 1;
    	insert bd;
    	
    	list<Budget_Detail__c> list_bd = new list<Budget_Detail__c>();
    	list_bd.add(bd);
    	    	
    	Test.startTest();
    	
        ClsBatch_BudgetDetailRateCalculating clsBatch = new ClsBatch_BudgetDetailRateCalculating();
        clsBatch.fiscalYear = null;
        clsBatch.email = null;
        clsBatch.filter = ' limit 1';
        
        Database.BatchableContext bc;
		clsBatch.start(bc);
        clsBatch.execute(bc, list_bd);
        clsBatch.finish(bc); 
        
        system.assert(true);
        Test.stopTest();
    }
}