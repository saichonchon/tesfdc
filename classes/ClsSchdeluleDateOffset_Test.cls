/**
 * Test class for :ClsBatchDateOffset, ClsSchdeluleDateOffset
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
public class ClsSchdeluleDateOffset_Test
{
    public static testmethod void ClsSchdeluleDateOffset_UT()
    {
        //ClsBatchDateOffset 
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
        
        insert bbb;
        test.starttest();
            ClsSchdeluleDateOffset o = new ClsSchdeluleDateOffset();
            o.strquery = 'select id, sales_Period__c from BBB_Month_Bill_Book_Cust__c ';
            o.mapFieldOfsetdays = new map<string, integer>{'sales_Period__c' => 7};
            o.batchSize = 200;
            system.schedule('Test check ClsSchdeluleDateOffset', '0 0 23 * * ?', o);
        test.stoptest();
    }
}