/**
 * Test class for:ClsBatch_FindDuplicateMonthlyBBB
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
public class ClsBatch_FindDuplicateMonthlyBBB_Test
{
    public static testmethod void ClsBatch_FindDuplicateMonthlyBBB_UT()
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
        
        ClsBatch_FindDuplicateMonthlyBBB o = new ClsBatch_FindDuplicateMonthlyBBB();
        
        o.strQuery = 'select '
                + 'Backlog_0__c, Backlog_1__c, Backlog_2__c, Backlog_3__c, Backlog_4__c, Backlog_5__c, Backlog_6__c, Bill_Amount_Document__c, Bill_Amount_USD__c, Bill_Cost_Amount__c, Bill_Type__c, Bill_Type_Filter__c, Book_Amount_Document__c, Book_Amount_USD__c, Book_Cost_Amount__c, Budget__c, Budget_Billing_CYRR__c, Budget_Billing_CYRR_Disp__c, Budget_Billings_CYTD__c, Budget_Billings_CYTD_Disp__c, Budget_Billings_LY__c, Budget_Billings_LY_Disp__c, Budget_CMA__c, Budget_CMA_Disp__c, Budget_Direct__c, Budget_Direct_Disp__c, Budget_Document_Currency__c, Budget_POS__c, Budget_POS_Disp__c, Budget_TBR_NY__c, Comment__c, ConflictField__c, Currency_1_USD__c, Currency_2_USD__c, Currency_3_USD__c, Currency_4_USD__c, Customer__c, Demand_Open__c, Demand_Shipped__c, Duplicate_BBB__c, Effective_Working_Days__c, Fiscal_Month__c, Fiscal_Year__c, Forecast__c, Forecast_2_Months_Document__c, Forecast_3_Months_Document__c, Forecast_4_Months_Document__c, Forecast_5_Months_Document__c, Forecast_6_Months_Document__c, Forecast_Begin_of_Quarter_Document__c, Forecast_Disp__c, Forecast_Document__c, Forecast_End_of_Prev_Quarter_Document__c, Forecast_Previous_TBR_USD__c, IND_Profit_Centre_Groups__c, IND_Profit_Workflow_Timestamp__c, Is_Comment__c, Last_Frozen_Month_Date__c, Last_Update_Date__c, Load_Status__c, Monthly_BBB_External_Key_Temp__c, Monthly_BBB_External_Key__c, Obsolete__c, Original_Budget__c, Previous_Exchange_Rate__c, Previous_Month_Forecast_Document__c, Profit_Center__c, Region__c, Reseller_Customer__c, Sales_Period__c, SAP_Profit_Center_Code__c, SAP_Profit_Center_Code_Filter__c, SAP_Profit_Center_Group_Code__c, SAP_Profit_Center_Group_Code_Filter__c, SAP_Profit_Center__c, SAP_Profit_Center_Grp_Short_Desc_Filter__c, SAP_Profit_Center_Short_Desc_Filter__c, SAP_Profit_Center_Short_Description__c, Scheduling_Agreement_Amount_0_USD__c, Scheduling_Agreement_Amount_1_USD__c, Scheduling_Agreement_Amount_2_USD__c, Scheduling_Agreement_Amount_3_USD__c, id '
                + ' from BBB_Month_Bill_Book_Cust__c where id = \'' + bbb.id + '\'';
        database.executebatch(o);
    }
}