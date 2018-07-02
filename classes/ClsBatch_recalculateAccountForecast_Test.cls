/**
 *  This test class is for ClsBatch_recalculateAccountForecast.
 * 
 @author Bin Yuan
 @created 2013-11-18
 @version 1.0
 @since 20.0
 * 
 @changelog
 * 2013-11-18 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created
 * - Test coverage %
 @changelog
 * 2013-11-20 Lili Zhao <lili.zhao@itbconsult.com>
 * 2014-01-21 Di Chen <di.chen@itbconsult.com>
 * - modify
 * - Test coverage 100%
 */
@isTest
private class ClsBatch_recalculateAccountForecast_Test {
    static testMethod void testBatch() {
        list<BBB_Month_Bill_Book_Cust__c> list_bbbM = new list<BBB_Month_Bill_Book_Cust__c>();
        String fYear_Current = '2014';
        String fYear_CurrentP = '2013';
        String fYear_CurrentN = '2015';
        
        Integer fMonth_Current = 1;
        Integer fMonth_Current2 = 2;
        Integer fMonth_Current3 = 3;
        Integer fMonth_Current4 = 4;
        Integer fMonth_Current5 = 5;
        Integer fMonth_Current6 = 6;
        Integer fMonth_Current7 = 7;
        Integer fMonth_Current8 = 8;
        Integer fMonth_Current9 = 9;
        Integer fMonth_Current10 = 10;
        Integer fMonth_Current11 = 11;
        Integer fMonth_Current12 = 12;
        
        
        date frozenDate = date.newinstance(2013, 12, 15);
        date frozenDateP = date.newinstance(2012, 12, 15);
        date frozenDateN = date.newinstance(2014, 12, 15);
        
    	Apex_Helper_Settings__c ahs1 = ClsTestHelp.createTestName1();
    	Apex_Helper_Settings__c ahs2 = ClsTestHelp.createTestName2();
    	Apex_Helper_Settings__c ahs3 = ClsTestHelp.createTestName3();
    	Apex_Helper_Settings__c ahs4 = ClsTestHelp.createTestName4();
    	Apex_Helper_Settings__c ahs5 = ClsTestHelp.createTestName5();
    	Apex_Helper_Settings__c ahs6 = ClsTestHelp.createTestName6();
    	Apex_Helper_Settings__c ahs7 = ClsTestHelp.createTestName7();
    	Apex_Helper_Settings__c ahs8 = ClsTestHelp.createTestName8();
    	Apex_Helper_Settings__c ahs9 = ClsTestHelp.createTestName9();
    	Apex_Helper_Settings__c ahs10 = ClsTestHelp.createTestName10();
    	Apex_Helper_Settings__c ahs11 = ClsTestHelp.createTestName11();
    	
    	Consumer_Device_Opportunity_Record_Types__c cdort1 = ClsTestHelp.createTestCSD1();
    	Consumer_Device_Opportunity_Record_Types__c cdort2 = ClsTestHelp.createTestCSD2();
    	Consumer_Device_Opportunity_Record_Types__c cdort3 = ClsTestHelp.createTestCSD3();
    	Consumer_Device_Opportunity_Record_Types__c cdort4 = ClsTestHelp.createTestCSD4();
    	Consumer_Device_Opportunity_Record_Types__c cdort5 = ClsTestHelp.createTestCSD5();
    	Consumer_Device_Opportunity_Record_Types__c cdort6 = ClsTestHelp.createTestCSD6();
    	Consumer_Device_Opportunity_Record_Types__c cdort7 = ClsTestHelp.createTestCSD7();
    	
    	RecordType rt2 = ClsTestHelp.createTestRecordType8();
    	
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
        insert sh;
        
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.RecordTypeId = rt2.Id;
        acc2.Name = 'Xxx1';
        acc2.Account_Manager__c = UserInfo.getUserId();
        acc2.SALES_TERRITORY_CDE__c = 'A103754';
        acc2.Sales_Hierarchy__c = sh.Id;
        acc2.Legally_Restricted__c = true;
        acc2.Individually_Planned__c = true;
        acc2.Individually_Forecasted__c = true;
        acc2.Customer_Classification__c = 'A';
    	acc2.Type = 'Global Account';
    	acc2.GAMCD__c = '1000';
    	acc2.SALES_TERRITORY_CDE__c = 'A004841';
        insert acc2;
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Account_Manager__c = UserInfo.getUserId();
        acc.RecordTypeId = rt2.Id;
        acc.SALES_TERRITORY_CDE__c = 'A103754';
        acc.Sales_Hierarchy__c = sh.Id;
        acc.Legally_Restricted__c = true;
        acc.Individually_Planned__c = false;
        acc.Individually_Forecasted__c = true;
        acc.Plan_Group_Account__c = acc2.Id;
        acc.Plan_Group_Id__c = acc2.Id;
        acc.Customer_Classification__c = 'A';
    	acc.Type = 'Global Account';
    	acc.GAMCD__c = '1000';
    	acc.SALES_TERRITORY_CDE__c = 'A004841';
        insert acc;
        
    	BBB_Month_Bill_Book_Cust__c bbb = new BBB_Month_Bill_Book_Cust__c();
    	bbb.Customer__c = acc.Id;
    	bbb.Fiscal_Year__c = '2014';
    	bbb.Fiscal_Month__c = 07;
    	bbb.Bill_Type__c = 'Direct';
    	bbb.Budget_Direct__c = 1;
    	bbb.Budget_POS__c = 2;
    	bbb.Budget_CMA__c = 3;
    	bbb.Budget_TBR_NY__c = 12;
    	bbb.Budget_Document_Currency__c = 11;
    	bbb.CurrencyIsoCode = 'EUR';
    	bbb.Monthly_BBB_External_Key__c = null;
    	bbb.Is_Comment__c = true;
    	bbb.IND_Profit_Centre_Groups__c = 'abc';
    	bbb.SAP_Profit_Center_Group_Code__c = 'G0123';
    	bbb.forecast__c = 1;
    	bbb.Comment__c = '<comments><comment value="100">Comment about a positive forecast risk</comment><comment value="-80">Comment about a negative forecast risk</comment></comments>';
    	insert bbb;
        
        List<BBB_Month_Bill_Book_Cust__c> list_BBMonths = [select Id,forecast__c,Fiscal_Date__c,Comment__c,SAP_Profit_Center_Group_Code__c,IND_Profit_Centre_Groups__c,Monthly_BBB_External_Key__c,Is_Comment__c,CurrencyIsoCode,Budget_Document_Currency__c,Budget_TBR_NY__c,Budget_CMA__c,Budget_POS__c,Customer__c,Fiscal_Year__c,Fiscal_Month__c,Bill_Type__c,Budget_Direct__c from BBB_Month_Bill_Book_Cust__c where Id =: bbb.Id];
        
        test.startTest();
        ClsBatch_recalculateAccountForecast clsBatch = new ClsBatch_recalculateAccountForecast();
        
        Database.BatchableContext BC;
        clsBatch.filter = ' limit 1 ';

        clsBatch.start(BC);
        clsBatch.execute(BC, list_BBMonths);
        clsBatch.finish(BC);
        test.stopTest();
    }

}