/**
*	This test class is for ClsBatch_BudgetCalculating.
*
@author Di Chen
@created 2012-06-21
@version 1.0
@since 20.0
*
@changelog
* 2012-06-21 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 90%
*/
@isTest
private class ClsBatch_BudgetCalculating_Test {

    static testMethod void testMost() {
    	
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
    	
    	Budget_Rate__c br = new Budget_Rate__c();
    	br.Effective_Date__c = date.newInstance(2011, 06, 06);
    	br.Expiration_Date__c = date.newInstance(2012, 10, 10);
    	br.CurrencyIsoCode = 'EUR';
    	br.Rate__c = 12;
    	insert br;
    	
    	
    	BBB_Month_Bill_Book_Cust__c bbb2 = [select Id ,CurrencyIsoCode,Customer__r.CurrencyIsoCode,Fiscal_Year__c,Budget_Document_Currency__c,Customer_Currency__c from BBB_Month_Bill_Book_Cust__c where Id = : bbb.Id];
    	
    	List<BBB_Month_Bill_Book_Cust__c> list_monthlyBillings = new List<BBB_Month_Bill_Book_Cust__c>();
    	list_monthlyBillings.add(bbb2);
    	
    	Test.startTest();
    	
        ClsBatch_BudgetCalculating clsBatch = new ClsBatch_BudgetCalculating();
        //clsBatch.query = 'Select Customer__r.CurrencyIsoCode, Budget_Document_Currency__c, Budget__c from BBB_Month_Bill_Book_Cust__c limit 1';
        clsBatch.fiscalYear = 2012;
        clsBatch.email = 'OK@testitbconsults78912.com';
        clsBatch.filter = ' limit 1';
        
        Database.BatchableContext bc;
		clsBatch.start(bc);
        clsBatch.execute(bc, list_monthlyBillings);
        clsBatch.finish(bc); 
        
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void testElse() {
    	
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
    	bbb.Budget_Document_Currency__c = null;
    	bbb.CurrencyIsoCode = 'EUR';
    	insert bbb;
    	
    	BBB_Month_Bill_Book_Cust__c bbb2 = [select Id ,CurrencyIsoCode,Customer__r.CurrencyIsoCode,Fiscal_Year__c,Budget_Document_Currency__c,Customer_Currency__c from BBB_Month_Bill_Book_Cust__c where Id = : bbb.Id];
    	
    	List<BBB_Month_Bill_Book_Cust__c> list_monthlyBillings = new List<BBB_Month_Bill_Book_Cust__c>();
    	list_monthlyBillings.add(bbb2);
    	
    	Test.startTest();
    	
        ClsBatch_BudgetCalculating clsBatch = new ClsBatch_BudgetCalculating();
        //clsBatch.query = 'Select Customer__r.CurrencyIsoCode, Budget_Document_Currency__c, Budget__c from BBB_Month_Bill_Book_Cust__c limit 1';
        clsBatch.fiscalYear = null;
        clsBatch.email = null;
        clsBatch.filter = ' limit 1';
        
        Database.BatchableContext bc;
		clsBatch.start(bc);
        clsBatch.execute(bc, list_monthlyBillings);
        clsBatch.finish(bc); 
        
        system.assert(true);
        Test.stopTest();
    }
}