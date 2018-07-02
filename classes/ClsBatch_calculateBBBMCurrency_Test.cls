/**
*  This test class used to test class ExtRecalculateBudget.
*
@author Bin Yuan
@created 2014-01-20
@version 1.0   
@since 28.0
*
@changelog
* coverage % 
* 
* 
2014-01-20 Bin Yuan <bin.yuan@itbconsult.com>
* - Created
*/
@isTest (seeAllData = true)
private class ClsBatch_calculateBBBMCurrency_Test {
    static testMethod void myUnitTest1() {
        //insert account manager
        User acctMger = new User();
        acctMger = ClsTestHelp.createTestUsers();
        acctMger.FirstName ='First';
        acctMger.LastName = 'acctMger';
        acctMger.Alias = 'acctMger';
        acctMger.Email = 'mtesteracctMger@ItbTestcompany.com';
        acctMger.Username = acctMger.Email;
        acctMger.Te_Network_Id__c = 'acctMger';
        acctMger.CommunityNickname = acctMger.Alias;
        insert acctMger;        
        
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
        acc.IND_Billing_Region__c = 'test';
        insert acc;
        
        //insert bbb monthly records for rsm
        BBB_Month_Bill_Book_Cust__c bbb = new BBB_Month_Bill_Book_Cust__c();
        bbb.Customer__c = acc.Id;
        bbb.Fiscal_Year__c = '2045';
        bbb.Fiscal_Month__c = 1;
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
        bbb.Comment__c = '<comments><comment value="100">Comment about a positive forecast risk</comment><comment value="-80">Comment about a negative forecast risk</comment></comments>';
        insert bbb;
        BBB_Month_Bill_Book_Cust__c bbb2 = new BBB_Month_Bill_Book_Cust__c();
        bbb2.Customer__c = acc.Id;
        bbb2.Fiscal_Year__c = '2045';
        bbb2.Fiscal_Month__c = 2;
        bbb2.Bill_Type__c = 'Direct';
        bbb2.Budget_Direct__c = 1;
        bbb2.Budget_POS__c = 2;
        bbb2.Budget_CMA__c = 3;
        bbb2.Budget_TBR_NY__c = 12;
        bbb2.Budget_Document_Currency__c = 11; 
        bbb2.CurrencyIsoCode = 'EUR';
        bbb2.Monthly_BBB_External_Key__c = null;
        bbb2.Is_Comment__c = true;
        bbb2.IND_Profit_Centre_Groups__c = 'abc';
        bbb2.SAP_Profit_Center_Group_Code__c = 'G0123';
        bbb2.Is_Comment__c = true;
        bbb2.IND_Profit_Centre_Groups__c = 'test';
        bbb2.Comment__c = '<comments><comment value="100">Comment about a positive forecast risk</comment><comment value="-80">Comment about a negative forecast risk</comment></comments>';
        insert bbb2;
        Test.startTest();
        list<BBB_Month_Bill_Book_Cust__c> list_manForecast = new list<BBB_Month_Bill_Book_Cust__c>();
        list_manForecast.add(bbb);
        list_manForecast.add(bbb2);
        ClsBatch_calculateBBBMCurrency cls = new ClsBatch_calculateBBBMCurrency();
        Database.BatchableContext BC;
        cls.currentYear = 2045;
        cls.currentMonth = 2;
        //cls.str_limit = ' limit 2 ';
        cls.start(BC);
        cls.execute(BC, list_manForecast);
        cls.finish(BC);
        Test.stopTest();
    }
}