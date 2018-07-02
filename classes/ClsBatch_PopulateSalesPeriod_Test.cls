@isTest
private class ClsBatch_PopulateSalesPeriod_Test {
    static testMethod void ClsBatch_PopulateSalesPeriod()
    {
        RecordType rt2 = ClsTestHelp.createTestRecordType8();
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
        insert sh;
        
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        
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
        insert new list<account>{acc, acc2};
        
        BBB_Month_Bill_Book_Cust__c bbb = new BBB_Month_Bill_Book_Cust__c();
        bbb.Customer__c = acc.Id;
        bbb.Fiscal_Year__c = '2014';
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
        bbb.SAP_Profit_Center_Code__c = 'G0123';
        bbb.Comment__c = '<comments><comment value="100">Comment about a positive forecast risk</comment><comment value="-80">Comment about a negative forecast risk</comment></comments>';
        insert bbb;
        
        Test.startTest();
        
        ClsBatch_PopulateSalesPeriod objClsBatchPopulateSalesPeriod = new ClsBatch_PopulateSalesPeriod();
        Database.executeBatch(objClsBatchPopulateSalesPeriod);
        
        Test.stopTest();
    }

}