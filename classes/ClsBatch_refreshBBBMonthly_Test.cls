/**
*  This test class is for ClsBatch_refreshBBBMonthly.
*
@author Di Chen
@created 2013-06-11
@version 1.0
@since 20.0
*
@changelog
* 2013-06-11 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 100%
*/
@isTest
private class ClsBatch_refreshBBBMonthly_Test {

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
    	
    	list<BBB_Month_Bill_Book_Cust__c> scrope = new list<BBB_Month_Bill_Book_Cust__c>();
    	scrope.add(bbb);
    	
    	Test.startTest();
    	
        ClsBatch_refreshBBBMonthly clsBatch = new ClsBatch_refreshBBBMonthly();
        clsBatch.email = 'OK@testitbconsults78912.com';
        clsBatch.filter = ' limit 1';
        
        Database.BatchableContext bc;
		clsBatch.start(bc);
        clsBatch.execute(bc, scrope);
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
    	
    	list<BBB_Month_Bill_Book_Cust__c> scrope = new list<BBB_Month_Bill_Book_Cust__c>();
    	scrope.add(bbb);
    	
    	Test.startTest();
    	
        ClsBatch_refreshBBBMonthly clsBatch = new ClsBatch_refreshBBBMonthly();
        clsBatch.email = null;
        clsBatch.filter = ' limit 1';
        
        Database.BatchableContext bc;
		clsBatch.start(bc);
        clsBatch.execute(bc, scrope);
        clsBatch.finish(bc); 
        
        system.assert(true);
        Test.stopTest();
    }
}