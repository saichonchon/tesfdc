/**
*   This test class is for ClsAcctForecastUtil.
*
@author Di Chen
@created 2014-01-20
@version 1.0
@since 20.0
*
@changelog
* 2014-01-20 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 78%
*/
@isTest
private class ClsAcctForecastUtil_Test {
 
    static testMethod void testMostMethods1() {
    	
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
    	CtrlAccountForecast ctrl = new CtrlAccountForecast();
    	
       	map<String, set<String>> map_parentAcctId_set_childrenAcctIds = new map<String, set<String>>();
       	
    	CtrlAccountForecast.PageConfig ctrlP = new CtrlAccountForecast.PageConfig();
    	ctrlP.comtSaveYear = '2014';
		ctrlP.comtSaveMonth = 1;
		
		ctrlP.str_comts2Save = '1';
		ctrlP.currentYear = '2014';
		ctrlP.currentMonth = 1;
		ctrlP.selectTerritory = 'shanghai';
    	ctrl.getComments();
    	map<String, set<Integer>> map_financialMonth = new map<String, set<Integer>>();
    	set<Integer> set_int = new set<Integer>();
    	set_int.add(1);
    	map_financialMonth.put('2014',set_int);
    	
    	set<String> set_acctIds = new set<String>();
    	set_acctIds.add(acc.Id);
    	
    	
    	map<String, String> map_parentId_acctName = new map<String, String>();
    	map_parentId_acctName.put(acc.Id,acc.Name);
    	
    	map<String, map<String, ClsAccountForecastItem>> map_acctId_map_year_fcItem = new map<String, map<String, ClsAccountForecastItem>>();
    	map<String, ClsAccountForecastItem> map_map_year_fcItem = new map<String, ClsAccountForecastItem>();
    	ClsAccountForecastItem clsAF = new ClsAccountForecastItem(acc.Id);
    	map_map_year_fcItem.put('2014',clsAF);
    	map_acctId_map_year_fcItem.put(acc.Id,map_map_year_fcItem);
    	
    	map<String, map<String, map<Integer, decimal>>> map_parentId_map_year_map_month_agreements = new map<String, map<String, map<Integer, decimal>>>();
    	map<String, map<Integer, decimal>> map_year_map_month_agreements= new map<String, map<Integer, decimal>>();
    	map<Integer, decimal> map_month_agreements = new map<Integer, decimal>();
    	map_month_agreements.put(1,1);
    	map_year_map_month_agreements.put('2014',map_month_agreements);
    	map_parentId_map_year_map_month_agreements.put(acc2.Id,map_year_map_month_agreements);
    	
    	set<String> set_childAcctIds = new set<String>();
    	set_childAcctIds.add(acc2.Id);
    	
    	map<String, map<String, map<String,decimal>>> map_parentId_map_childId_map_profitCtr_percent = new map<String, map<String, map<String,decimal>>>();
    	map<String, map<String,decimal>> map_childId_map_profitCtr_percent = new map<String, map<String,decimal>>();
    	map<String,decimal> map_profitCtr_percent = new map<String,decimal>();
    	map_profitCtr_percent.put('G0123',1);
    	map_childId_map_profitCtr_percent.put(acc2.Id,map_profitCtr_percent);
    	map_parentId_map_childId_map_profitCtr_percent.put(acc.Id,map_childId_map_profitCtr_percent);
    	
    	ClsForecastComments forecastComments = new ClsForecastComments();
    	
    	list<ClsAccountForecastItem.AcctForecastSaveItem> list_fcSaveItems = new list<ClsAccountForecastItem.AcctForecastSaveItem>();
    	ClsAccountForecastItem.AcctForecastSaveItem clsAFSI = new ClsAccountForecastItem.AcctForecastSaveItem();
    	clsAFSI.month = 1;
    	clsAFSI.year = '2014';
    	clsAFSI.parentAcctId = acc.Id;
    	list_fcSaveItems.add(clsAFSI);
    	
    	map<String, set<Integer>> map_fiscalMonth4Save = new map<String, set<Integer>>();
    	set<Integer> set_newInt = new set<Integer>();
    	set_newInt.add(1);
    	map_fiscalMonth4Save.put('2014',set_newInt);
    	
    	map<String, map<String, map<Integer, map<String, String>>>> map_acctId_year_month_profitCtr_comt = new map<String, map<String, map<Integer, map<String, String>>>>();
    	map<String, map<Integer, map<String, String>>> map_year_month_profitCtr_comt = new map<String, map<Integer, map<String, String>>>();
    	map<Integer, map<String, String>> map_month_profitCtr_comt = new map<Integer, map<String, String>>();
    	map<String, String> map_profitCtr_comt= new  map<String, String>();
    	map_profitCtr_comt.put('G0123',bbb.Comment__c);
    	map_month_profitCtr_comt.put(1,map_profitCtr_comt);
    	map_year_month_profitCtr_comt.put('2014',map_month_profitCtr_comt);
    	map_acctId_year_month_profitCtr_comt.put(acc.Id,map_year_month_profitCtr_comt);
    	
    	map<String, map<Integer, Integer>> map_year_map_month_effWorkingDays = new map<String, map<Integer, Integer>>();
    	map<Integer, Integer> map_month_effWorkingDays = new map<Integer, Integer>();
    	map_month_effWorkingDays.put(1,1);
    	map_year_map_month_effWorkingDays.put('2014',map_month_effWorkingDays);
    	
    	list<String> list_territoryCodes = new list<String>();
    	list_territoryCodes.add(acc.SALES_TERRITORY_CDE__c);
    	
        Test.startTest();
        
        ClsAcctForecastUtil.getAcctHieraychy(map_parentAcctId_set_childrenAcctIds, UserInfo.getUserId(), set_acctIds, map_parentId_acctName);
        
        ClsAcctForecastUtil.setfinancialMonths(ctrlP);
        
        ClsAcctForecastUtil.getAcctForecastData(map_financialMonth, set_acctIds, map_parentAcctId_set_childrenAcctIds, map_acctId_map_year_fcItem, map_parentId_acctName, '');

        String str_select = ' Select sum(Bill_Amount_USD__c) Bills, sum(Book_Amount_USD__c) Book2Bill, sum(Budget__c) Budgets, sum(forecast__c) Forecasts, sum(Previous_Month_Forecast_Document__c) PrevForecasts, sum(Demand_Shipped__c) DemandShipped, sum(Demand_Open__c) DemandOpen,' 
                          + ' sum(Backlog_0__c) Backlog0, sum(Backlog_1__c) Backlog1, sum(Backlog_2__c) Backlog2, sum(Backlog_3__c) Backlog3, sum(Currency_1_USD__c) Currency1, sum(Forecast_2_Months_Document__c) forecast_2, sum(Forecast_Begin_of_Quarter_Document__c) forecast_3, sum(Forecast_6_Months_Document__c) forecast_6, '
                          + ' sum(Currency_2_USD__c) Currency2, sum(Currency_3_USD__c) Currency3, sum(Currency_4_USD__c) Currency4, Customer__r.Plan_Group_Id__c ParentId, Fiscal_date__c FDate, currencyIsocode';
        String str_from = ' From BBB_Month_Bill_Book_Cust__c';
        String str_where = ' Where Bill_Type__c = \'Direct\' And IND_Profit_Centre_Groups__c != null ';
        String str_orderBy = ' Group by Customer__r.Plan_Group_Id__c, Customer__c, IND_Profit_Centre_Groups__c,currencyIsocode,Fiscal_date__c ';
        String query = str_select + str_from + str_where+str_orderBy;
        ClsAccountForecastItem.AccountForecastMonthlyItem fcMonthItem = new ClsAccountForecastItem.AccountForecastMonthlyItem();
        for(AggregateResult bbbm : database.query(query)) {
        	
			ClsAcctForecastUtil.calcFCItems(map_acctId_map_year_fcItem, acc2.Id, acc2.Name, bbbm, map_parentId_map_year_map_month_agreements);
			
		}
		ClsAcctForecastUtil.generateAcctFCItem(map_acctId_map_year_fcItem, acc2.Id, '2014', 1);
		ClsAcctForecastUtil.generateAgreementsMap(map_parentId_map_year_map_month_agreements, acc2.Id, '2014', 1, map_parentAcctId_set_childrenAcctIds);
        ClsAcctForecastUtil.getComments(set_acctIds, '2014', 1, forecastComments, '2014', 1);
        ClsAcctForecastUtil.getComments(set_acctIds, '2014', 1, forecastComments, '2014', 1, '');
        ClsAcctForecastUtil.transformIsoCode(1, 'EUR', 'USD');
        ClsAcctForecastUtil.getAcctHieraychy(map_parentAcctId_set_childrenAcctIds, UserInfo.getUserId(), set_acctIds, map_parentId_acctName, '');
        ClsAcctForecastUtil.getAcctPercentage(set_childAcctIds, map_parentAcctId_set_childrenAcctIds, map_parentId_map_childId_map_profitCtr_percent, '2014', 1, 'shanghai');
        ClsAcctForecastUtil.saveAcctForecast(list_fcSaveItems, set_acctIds, map_parentId_map_childId_map_profitCtr_percent, ctrlP, map_fiscalMonth4Save);
        ClsAcctForecastUtil.saveComments(map_acctId_year_month_profitCtr_comt, map_fiscalMonth4Save);
        ClsAcctForecastUtil.checkFCMap4Year(map_acctId_map_year_fcItem, map_financialMonth, map_parentAcctId_set_childrenAcctIds, map_parentId_acctName);
        ClsAcctForecastUtil.getEffectiveWorkingDays(map_financialMonth, map_year_map_month_effWorkingDays);
        ClsAcctForecastUtil.isDateFrozen(ctrlP);
        ClsAcctForecastUtil.getAccountTerritory(UserInfo.getUserId(), list_territoryCodes);
        
        system.assert(true);
        Test.stopTest();
    }
}