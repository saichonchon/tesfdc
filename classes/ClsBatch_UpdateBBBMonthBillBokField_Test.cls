/**
*  This test class used to test batch ClsBatchSetINDCustomerClassification.
*
@author Lili Zhao
@created 2013-11-27
@version 1.0   
@since 28.0
*
@changelog
* coverage 100% 
* 
* 
2013-11-27 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest(seeAllData = true) 
private class ClsBatch_UpdateBBBMonthBillBokField_Test {

    static testMethod void myUnitTest() {
    	Account account = ClsTestHelp.createTestAccounts();
		account.GAMCD__c = 'test';
		insert account;
    	BBB_Month_Bill_Book_Cust__c bbb = new BBB_Month_Bill_Book_Cust__c();
    	bbb.Customer__c = account.Id;
    	bbb.Fiscal_Year__c = '2012';
    	bbb.Bill_Type__c = 'Direct';
    	bbb.Budget_Direct__c = 1;
    	bbb.Budget_POS__c = 2;
    	bbb.Budget_CMA__c = 3;
    	bbb.Budget_TBR_NY__c = 12;
    	bbb.Budget_Document_Currency__c = 11;
    	bbb.CurrencyIsoCode = 'EUR';
    	insert bbb;	 	
    	
		List<BBB_Month_Bill_Book_Cust__c> list_bbb = new List<BBB_Month_Bill_Book_Cust__c>();
        list_bbb.add(bbb);
              
        Test.startTest();
              
        ClsBatch_UpdateBBBMonthBillBookCustField  clsBatch = new ClsBatch_UpdateBBBMonthBillBookCustField ();
        Database.BatchableContext BC;
        clsBatch.filter = ' limit 1';
        clsBatch.start(BC);
        clsBatch.execute(BC, list_bbb);
        clsBatch.finish(BC);
                  
        system.assert(true);
        Test.stopTest();
    }
}