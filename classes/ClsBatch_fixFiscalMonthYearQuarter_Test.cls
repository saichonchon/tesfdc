/**
 * Test class for :ClsBatch_fixFiscalMonthYearQuarter.
 *
 @author    Pankaj Raijade
 @created   2016-06-25
 @version   1.0
 @since     37.0 (Force.com ApiVersion)
 *
 @changelog
 * 2016-06-25 Pankaj Raijade <Pankaj.raijade@zensar.in>
 * - Created
 */
@istest(seeAlldata=false)
public class ClsBatch_fixFiscalMonthYearQuarter_Test
{
    public static testmethod void ClsBatch_fixFiscalMonthYearQuarter_UT()
    {
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        
        Account account = ClsTestHelp.createTestAccounts();
        account.GAMCD__c = 'test';
        insert account;
        
        BBB_Month_Bill_Book_Cust__c bbb = new BBB_Month_Bill_Book_Cust__c();
        bbb.Customer__c = account.Id;
        bbb.Fiscal_Year__c = '2012';
        bbb.sales_Period__c = date.today();
        bbb.Bill_Type__c = 'Direct';
        bbb.CurrencyIsoCode = 'EUR';
        bbb.Monthly_BBB_External_Key__c = 'test';
        
        BBB_Month_Bill_Book_Cust__c bbb2 = new BBB_Month_Bill_Book_Cust__c();
        bbb2.Customer__c = account.Id;
        bbb2.Fiscal_Year__c = '2012';
        bbb2.sales_Period__c = date.today();
        bbb2.Bill_Type__c = 'Direct';
        bbb2.CurrencyIsoCode = 'EUR';
        bbb2.Monthly_BBB_External_Key__c = 'test';
        insert new list<BBB_Month_Bill_Book_Cust__c>{bbb, bbb2};
        
        ClsBatch_fixFiscalMonthYearQuarter o = new ClsBatch_fixFiscalMonthYearQuarter();
        o.strquery = 'select id, Fiscal_Month__c, Sales_Period__c, Fiscal_Year__c from BBB_Month_Bill_Book_Cust__c  Where id = \'' + bbb.id + '\' ';
        o.mapFieldOfsetdays = new map<string, integer>{'Sales_Period__c' => 7};
        o.strControllingfield = 'Sales_Period__c';
        o.strFiscalMonthfield = 'Fiscal_Month__c';
        o.strFiscalYearfield = 'Fiscal_Year__c';
        o.periodStartdate = system.date.newInstance(2015, 08, 23);
        o.periodEnddate = system.date.newInstance(2017, 09, 02);
        database.executeBatch(o, 200);
        
        
    }
}