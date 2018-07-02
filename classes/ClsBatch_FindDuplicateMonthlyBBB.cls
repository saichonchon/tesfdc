/**
 * Class to find duplicate Monthly BBB by customer records based on Monthly_BBB_External_Key__c.
 *
 @author    Pankaj Raijade
 @created   2016-06-25
 @version   1.0
 @since     37.0 (Force.com ApiVersion)
 *
 //Test class : ClsBatch_FindDuplicateMonthlyBBB_Test
//Code coverage 94%
 @changelog
 * 2016-06-25 Pankaj Raijade <Pankaj.raijade@zensar.in>
 * - Created
 */
global class ClsBatch_FindDuplicateMonthlyBBB implements Database.Batchable<sObject>, Database.Stateful
{
    public string strQuery = '';
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        if(strQuery != null && strQuery != '')
            return Database.getQueryLocator(strQuery );
        else 
        {
            strQuery = 'select '
                + 'Backlog_0__c, Backlog_1__c, Backlog_2__c, Backlog_3__c, Backlog_4__c, Backlog_5__c, Backlog_6__c, Bill_Amount_Document__c, Bill_Amount_USD__c, Bill_Cost_Amount__c, Bill_Type__c, Bill_Type_Filter__c, Book_Amount_Document__c, Book_Amount_USD__c, Book_Cost_Amount__c, Budget__c, Budget_Billing_CYRR__c, Budget_Billing_CYRR_Disp__c, Budget_Billings_CYTD__c, Budget_Billings_CYTD_Disp__c, Budget_Billings_LY__c, Budget_Billings_LY_Disp__c, Budget_CMA__c, Budget_CMA_Disp__c, Budget_Direct__c, Budget_Direct_Disp__c, Budget_Document_Currency__c, Budget_POS__c, Budget_POS_Disp__c, Budget_TBR_NY__c, Comment__c, ConflictField__c, Currency_1_USD__c, Currency_2_USD__c, Currency_3_USD__c, Currency_4_USD__c, Customer__c, Demand_Open__c, Demand_Shipped__c, Duplicate_BBB__c, Effective_Working_Days__c, Fiscal_Month__c, Fiscal_Year__c, Forecast__c, Forecast_2_Months_Document__c, Forecast_3_Months_Document__c, Forecast_4_Months_Document__c, Forecast_5_Months_Document__c, Forecast_6_Months_Document__c, Forecast_Begin_of_Quarter_Document__c, Forecast_Disp__c, Forecast_Document__c, Forecast_End_of_Prev_Quarter_Document__c, Forecast_Previous_TBR_USD__c, IND_Profit_Centre_Groups__c, IND_Profit_Workflow_Timestamp__c, Is_Comment__c, Last_Frozen_Month_Date__c, Last_Update_Date__c, Load_Status__c, Monthly_BBB_External_Key_Temp__c, Monthly_BBB_External_Key__c, Obsolete__c, Original_Budget__c, Previous_Exchange_Rate__c, Previous_Month_Forecast_Document__c, Profit_Center__c, Region__c, Reseller_Customer__c, Sales_Period__c, SAP_Profit_Center_Code__c, SAP_Profit_Center_Code_Filter__c, SAP_Profit_Center_Group_Code__c, SAP_Profit_Center_Group_Code_Filter__c, SAP_Profit_Center__c, SAP_Profit_Center_Grp_Short_Desc_Filter__c, SAP_Profit_Center_Short_Desc_Filter__c, SAP_Profit_Center_Short_Description__c, Scheduling_Agreement_Amount_0_USD__c, Scheduling_Agreement_Amount_1_USD__c, Scheduling_Agreement_Amount_2_USD__c, Scheduling_Agreement_Amount_3_USD__c, id '
                + ' from BBB_Month_Bill_Book_Cust__c where Sales_Period__c >= 2016-09-24  and Sales_Period__c < 2017-09-02 ';
        
            return Database.getQueryLocator(strQuery );
            
        }
    }
    global void execute(Database.BatchableContext BC, List<BBB_Month_Bill_Book_Cust__c> lstSObject)
    {
        map<string, BBB_Month_Bill_Book_Cust__c> mapBBBKey = new map<string, BBB_Month_Bill_Book_Cust__c>();
        map<id, BBB_Month_Bill_Book_Cust__c> mapBBBid = new map<id, BBB_Month_Bill_Book_Cust__c>();
        map<id, BBB_Month_Bill_Book_Cust__c> mapBBBupdate = new map<id, BBB_Month_Bill_Book_Cust__c>();
        for(BBB_Month_Bill_Book_Cust__c oSObj :lstSObject)
        {
            if(oSObj.Monthly_BBB_External_Key__c != null)
            {
                mapBBBKey.put(oSObj.Monthly_BBB_External_Key__c, oSObj);
                mapBBBid.put(oSObj.id, oSObj);
            }
        }
        set<string> setBBBKey = mapBBBKey.keyset();
        set<id> setBBBid = mapBBBid.keyset();
        list<BBB_Month_Bill_Book_Cust__c> lstbbb = database.query('select Backlog_0__c, Backlog_1__c, Backlog_2__c, Backlog_3__c, Backlog_4__c, Backlog_5__c, Backlog_6__c, Bill_Amount_Document__c, Bill_Amount_USD__c, Bill_Cost_Amount__c, Bill_Type__c, Bill_Type_Filter__c, Book_Amount_Document__c, Book_Amount_USD__c, Book_Cost_Amount__c, Budget__c, Budget_Billing_CYRR__c, Budget_Billing_CYRR_Disp__c, Budget_Billings_CYTD__c, Budget_Billings_CYTD_Disp__c, Budget_Billings_LY__c, Budget_Billings_LY_Disp__c, Budget_CMA__c, Budget_CMA_Disp__c, Budget_Direct__c, Budget_Direct_Disp__c, Budget_Document_Currency__c, Budget_POS__c, Budget_POS_Disp__c, Budget_TBR_NY__c, Comment__c, ConflictField__c, Currency_1_USD__c, Currency_2_USD__c, Currency_3_USD__c, Currency_4_USD__c, Customer__c, Demand_Open__c, Demand_Shipped__c, Duplicate_BBB__c, Effective_Working_Days__c, Fiscal_Month__c, Fiscal_Year__c, Forecast__c, Forecast_2_Months_Document__c, Forecast_3_Months_Document__c, Forecast_4_Months_Document__c, Forecast_5_Months_Document__c, Forecast_6_Months_Document__c, Forecast_Begin_of_Quarter_Document__c, Forecast_Disp__c, Forecast_Document__c, Forecast_End_of_Prev_Quarter_Document__c, Forecast_Previous_TBR_USD__c, IND_Profit_Centre_Groups__c, IND_Profit_Workflow_Timestamp__c, Is_Comment__c, Last_Frozen_Month_Date__c, Last_Update_Date__c, Load_Status__c, Monthly_BBB_External_Key_Temp__c, Monthly_BBB_External_Key__c, Obsolete__c, Original_Budget__c, Previous_Exchange_Rate__c, Previous_Month_Forecast_Document__c, Profit_Center__c, Region__c, Reseller_Customer__c, Sales_Period__c, SAP_Profit_Center_Code__c, SAP_Profit_Center_Code_Filter__c, SAP_Profit_Center_Group_Code__c, SAP_Profit_Center_Group_Code_Filter__c, SAP_Profit_Center__c, SAP_Profit_Center_Grp_Short_Desc_Filter__c, SAP_Profit_Center_Short_Desc_Filter__c, SAP_Profit_Center_Short_Description__c, Scheduling_Agreement_Amount_0_USD__c, Scheduling_Agreement_Amount_1_USD__c, Scheduling_Agreement_Amount_2_USD__c, Scheduling_Agreement_Amount_3_USD__c, id from BBB_Month_Bill_Book_Cust__c where Monthly_BBB_External_Key__c in :setBBBKey and id not in :setBBBid');
        for(BBB_Month_Bill_Book_Cust__c oBBB :lstbbb)
        {
            if(mapBBBKey.containsKey(oBBB.Monthly_BBB_External_Key__c))
            {
                BBB_Month_Bill_Book_Cust__c oBBBdup = mapBBBKey.get(oBBB.Monthly_BBB_External_Key__c);
                if(oBBB.get('Monthly_BBB_External_Key_temp__c') != null)
                {
                    system.debug('asdf11'+ oBBB.get('Monthly_BBB_External_Key_temp__c'));
                    oBBB.put('Duplicate_BBB__c', oBBBdup.id);
                    updatebbbfields(oBBBdup, oBBB);
                    mapBBBupdate.put(oBBB.id, oBBB);
                    mapBBBupdate.put(oBBBdup.id, oBBBdup);
                }
                else 
                {
                    system.debug('asdf12'+ oBBBdup.get('Monthly_BBB_External_Key__c'));
                    oBBBdup.put('Duplicate_BBB__c', oBBB.id);
                    updatebbbfields(oBBB, oBBBdup);
                    mapBBBupdate.put(oBBBdup.id, oBBBdup);
                    mapBBBupdate.put(oBBB.id, oBBB);
                }
            }
        }
        system.debug('asdf12' +mapBBBupdate);
        if(mapBBBupdate.size() > 0)
            update mapBBBupdate.values();
    } 
    global void finish(Database.BatchableContext BC)
    { 
    }
    public static list<string> lstField = new list<string>
    {
        'Backlog_0__c',
        'Backlog_1__c',
        'Backlog_2__c',
        'Backlog_3__c',
        'Backlog_4__c',
        'Backlog_5__c',
        'Backlog_6__c',
        'Bill_Amount_Document__c',
        'Bill_Amount_USD__c',
        'Bill_Cost_Amount__c',
        'Bill_Type__c',
        'Bill_Type_Filter__c',
        'Book_Amount_Document__c',
        'Book_Amount_USD__c',
        'Book_Cost_Amount__c',
        'Budget__c',
        'Budget_Billing_CYRR__c',
        'Budget_Billing_CYRR_Disp__c',
        'Budget_Billings_CYTD__c',
        'Budget_Billings_CYTD_Disp__c',
        'Budget_Billings_LY__c',
        'Budget_Billings_LY_Disp__c',
        'Budget_CMA__c',
        'Budget_CMA_Disp__c',
        'Budget_Direct__c',
        'Budget_Direct_Disp__c',
        'Budget_Document_Currency__c',
        'Budget_POS__c',
        'Budget_POS_Disp__c',
        'Budget_TBR_NY__c',
        'Comment__c',
        'Currency_1_USD__c',
        'Currency_2_USD__c',
        'Currency_3_USD__c',
        'Currency_4_USD__c',
        'Customer__c',
        'Demand_Open__c',
        'Demand_Shipped__c',
        'Effective_Working_Days__c',
        'Fiscal_Month__c',
        'Fiscal_Year__c',
        'Forecast__c',
        'Forecast_2_Months_Document__c',
        'Forecast_3_Months_Document__c',
        'Forecast_4_Months_Document__c',
        'Forecast_5_Months_Document__c',
        'Forecast_6_Months_Document__c',
        'Forecast_Begin_of_Quarter_Document__c',
        'Forecast_Disp__c',
        'Forecast_Document__c',
        'Forecast_End_of_Prev_Quarter_Document__c',
        'Forecast_Previous_TBR_USD__c',
        'IND_Profit_Centre_Groups__c',
        'IND_Profit_Workflow_Timestamp__c',
        'Is_Comment__c',
        'Last_Frozen_Month_Date__c',
        'Last_Update_Date__c',
        'Load_Status__c',
        'Obsolete__c',
        'Original_Budget__c',
        'Previous_Exchange_Rate__c',
        'Previous_Month_Forecast_Document__c',
        'Profit_Center__c',
        'Region__c',
        'Reseller_Customer__c',
        'Sales_Period__c',
        'SAP_Profit_Center_Code__c',
        'SAP_Profit_Center_Code_Filter__c',
        'SAP_Profit_Center_Group_Code__c',
        'SAP_Profit_Center_Group_Code_Filter__c',
        'SAP_Profit_Center__c',
        'SAP_Profit_Center_Grp_Short_Desc_Filter__c',
        'SAP_Profit_Center_Short_Desc_Filter__c',
        'SAP_Profit_Center_Short_Description__c',
        'Scheduling_Agreement_Amount_0_USD__c',
        'Scheduling_Agreement_Amount_1_USD__c',
        'Scheduling_Agreement_Amount_2_USD__c',
        'Scheduling_Agreement_Amount_3_USD__c'
    };
    public static void updatebbbfields(BBB_Month_Bill_Book_Cust__c OrignalBBB, BBB_Month_Bill_Book_Cust__c DuplicateBBB)
    {
        for(string strfield :lstField)
        {
            system.debug('asdf33'+strfield);
            if(DuplicateBBB.get(strfield) != null)
            {
                //if(OrignalBBB.get(strfield) != null)
                //{
                    //OrignalBBB.put(strfield,DuplicateBBB.get(strfield));
                    //if(DuplicateBBB.get(strfield) != OrignalBBB.get(strfield))
                        //OrignalBBB.put('ConflictField__c', OrignalBBB.get('ConflictField__c') +strfield);
                //}
                //else
                    OrignalBBB.put(strfield,DuplicateBBB.get(strfield));
                    system.debug('asdf34'+DuplicateBBB.get(strfield));
            }
        }
    }
}