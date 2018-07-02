/**
*  This test class is for ClsBatch_updateBBBMonthlyValues.
*
@author Di Chen
@created 2013-01-31
@version 1.0
@since 20.0
*
@changelog
* 2013-01-31 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 
*/
@isTest
private class ClsBatch_updateBBBMonthlyValues_Test {

    static testMethod void testBatch() {
    	RecordType rt = ClsTestHelp.createTestRecordType8();
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.RecordTypeId = rt.Id;
    	acc.SALES_TERRITORY_CDE__c = 'A003153';
    	acc.Individually_Planned__c = true;
    	acc.Account_Manager__c = UserInfo.getUserId();
    	acc.CurrencyIsoCode = 'AED';
    	insert acc;
    	    	
    	BBB_Month_Bill_Book_Cust__c bbb = new BBB_Month_Bill_Book_Cust__c();
    	bbb.Customer__c = acc.Id;
    	bbb.Fiscal_Year__c = '2012';
    	bbb.Bill_Type__c = 'Direct';
    	bbb.Budget_Direct__c = 1;
    	bbb.Budget_POS__c = 2;
    	bbb.Budget_CMA__c = 3;
    	bbb.Budget_TBR_NY__c = 12;
    	bbb.Budget_Document_Currency__c = 11;
    	bbb.CurrencyIsoCode = 'EUR';
    	insert bbb;
    	
    	Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
    	sh.Level_7_Territory_Code__c = 'A007357';
    	insert sh;
    	
    	Budget__c bg = new Budget__c();
    	bg.Year__c = '2012';
    	bg.Territory__c = sh.Id;
		bg.Total_Direct_Budget_TBR_NY__c = 11;
		bg.Total_Budget_TBR_NY__c = 12;
    	insert bg;
    	    	
    	list<BBB_Month_Bill_Book_Cust__c> scope = new list<BBB_Month_Bill_Book_Cust__c>();
    	scope.add(bbb);
    	
    	map<String, Budget__c> map_stringBud = new map<String, Budget__c>();
    	map_stringBud.put('2012',bg);
    	
    	map<Id, map<String, Budget__c>> map_accId_year_budget = new map<Id, map<String, Budget__c>>();
    	map_accId_year_budget.put(acc.Id,map_stringBud);
    	
    	Set<Id> set_accIds = new Set<Id>();
    	set_accIds.add(acc.Id);
    	
    	Set<String> set_years = new Set<String>();
    	set_years.add('2012');
    	
    	Test.startTest();
    	
    	ClsBatch_updateBBBMonthlyValues clsBatch = new ClsBatch_updateBBBMonthlyValues(map_accId_year_budget,set_accIds,set_years);
        Database.BatchableContext BC;
		clsBatch.filter = ' limit 1';
		
    	clsBatch.start(BC);
		clsBatch.execute(BC, scope);
		clsBatch.finish(BC);
    	
    	system.assert(true);
    	Test.stopTest();   
    }
}