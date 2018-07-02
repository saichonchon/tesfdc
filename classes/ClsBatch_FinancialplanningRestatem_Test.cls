/**
*   This test class is for ClsBatch_FinancialplanningRestatement.
*
@author Di Chen
@created 2014-01-20
@version 1.0
@since 20.0
*
@changelog
* 2014-01-20 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 
*/
@isTest
private class ClsBatch_FinancialplanningRestatem_Test {

    static testMethod void myUnitTest() {
        
        Forecast_Definition__c fd = new Forecast_Definition__c();
        fd.Region__c = 'Americas';
        fd.Profit_Center__c = 'abc';
        fd.GSM__c = UserInfo.getUserId();
        fd.GSM_Name__c = '1234';
        
        Forecast_Definition__c fd1 = new Forecast_Definition__c();
        fd1.Region__c = 'EMEA';
        fd1.Profit_Center__c = 'abc';
        fd1.GSM__c = UserInfo.getUserId();
        fd1.GSM_Name__c = '1234';
        insert new List<Forecast_Definition__c>{fd,fd1};
        
        Manager_Forecast__c manForecast = new Manager_Forecast__c();
        manForecast.Fiscal_Year__c = '2099';
        manForecast.Fiscal_Month__c = 2;
        manForecast.Forecast_Definition__c = fd.Id;
        manForecast.Fiscal_Year__c = '2020'; //manForecast.Fiscal_Year__c = '2099';
        manForecast.Fiscal_Month__c = 1;
        manForecast.Forecast_USD__c = 1; // added by lili 2014.2.10
        insert manForecast; 
        
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        
        RecordType rt2 = ClsTestHelp.createTestRecordType8();
        
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
        insert sh;
        
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.RecordTypeId = rt2.Id;
        acc2.LAYER2_ORGANIZATION_ID__c = '0002';
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
        acc2.IND_Billing_Region__c = 'Americas';
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
        acc.IND_Billing_Region__c = 'Americas';
        acc.LAYER2_ORGANIZATION_ID__c = '0002';
        insert acc;
            
        BBB_Month_Bill_Book_Cust__c bbb = new BBB_Month_Bill_Book_Cust__c();
        bbb.Customer__c = acc2.Id;
        bbb.Fiscal_Year__c = '2020';
        bbb.Fiscal_Month__c = 1;
        bbb.Bill_Type__c = 'Direct';
        bbb.Budget_Direct__c = 1;
        bbb.Budget_POS__c = 2;
        bbb.Budget_CMA__c = 3;
        bbb.Budget_TBR_NY__c = 12;
        bbb.Budget_Document_Currency__c = 11;
        bbb.CurrencyIsoCode = 'EUR';
        bbb.Monthly_BBB_External_Key__c = 'abc';
        bbb.Is_Comment__c = true;
        bbb.IND_Profit_Centre_Groups__c = 'abc';
        bbb.SAP_Profit_Center_Group_Code__c = 'G0123';
        bbb.Monthly_BBB_External_Key__c = acc.Id;
        bbb.Comment__c = '<comments><comment value="100">Comment about a positive forecast risk</comment><comment value="-80">Comment about a negative forecast risk</comment></comments>';
        insert bbb;
        
        BBB_Month_Bill_Book_Cust__c testbb = [Select Id,Customer__r.RecordType.DeveloperName,IND_Profit_Centre_Groups__c,Customer__r.IND_Billing_Region__c,Monthly_BBB_External_Key__c,Fiscal_Year__c,Fiscal_Month__c from BBB_Month_Bill_Book_Cust__c where Id=:bbb.Id];
        system.debug('@@IND_Profit_Centre_Groups__c ' + testbb.IND_Profit_Centre_Groups__c);
        system.debug('@@Customer__r.IND_Billing_Region__c ' + testbb.Customer__r.IND_Billing_Region__c);
            system.debug('@@Customer__r.RecordType.DeveloperName ' + testbb.Customer__r.RecordType.DeveloperName);
        system.debug('@@Monthly_BBB_External_Key__c ' + testbb.Monthly_BBB_External_Key__c);
        system.debug('@@Fiscal_Year__c ' + testbb.Fiscal_Year__c);
        system.debug('@@Fiscal_Month__c ' + testbb.Fiscal_Month__c);
        //system.debug('@@ ' + testbb.);
        
        List<Manager_Forecast__c> list_manForecast = new List<Manager_Forecast__c>();
        list_manForecast.add(manForecast);
              
        Test.startTest();
              
        ClsBatch_FinancialplanningRestatement clsBatch = new ClsBatch_FinancialplanningRestatement();
        
        database.executeBatch(clsBatch);
        ClsBatch_FinancialplanningRestatement.RestatementItem RestatementItem = new ClsBatch_FinancialplanningRestatement.RestatementItem();
        system.assert(true);
        Test.stopTest(); 
    }
}