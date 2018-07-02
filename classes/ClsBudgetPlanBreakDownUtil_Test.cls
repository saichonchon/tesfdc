/**
*	This test class is for ClsBudgetPlanBreakDownUtil.
*
@author Di Chen
@created 2013-06-18
@version 1.0
@since 20.0
*
@changelog
* 2013-06-18 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 88%
*/
@isTest
private class ClsBudgetPlanBreakDownUtil_Test {

    static testMethod void testMostMethodsParentAcc1() {
    	Profile p = [Select Id, Name From Profile 
     								where Name = 'Production Support' 
     								or Name = 'Service Account' 
     								or Name ='System Administrator' 
     								or Name ='Systemadministrator' limit 1];
     	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'az@testCompany1233423.com';
    	u.Alias = 'dpse'; 
    	u.CommunityNickname = 'TMD';
    	u.ProfileId = p.Id;
		insert u;
    	
    	RecordType rt = ClsTestHelp.createTestRecordType8();
    	
    	Account acc2 = ClsTestHelp.createTestAccounts();
    	acc2.Individually_Planned__c = true;
    	acc2.Name = 'ohxxsx';
    	acc2.CurrencyIsoCode = 'EUR';
    	insert acc2;
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.RecordTypeId = rt.Id;
    	acc.SALES_TERRITORY_CDE__c = 'A003153';
    	acc.Individually_Planned__c = true;
    	acc.Account_Manager__c = u.Id;
    	acc.Plan_Group_Account__c = acc2.Id;
    	acc.Plan_Group_Id__c = acc2.Id;
    	acc.CurrencyIsoCode = 'EUR';
    	insert acc;
    	
    	Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
    	sh.Level_7_Territory_Code__c = 'A007357';
    	insert sh;
    	
    	Budget__c bg = new Budget__c();
    	bg.Year__c = '2013';
    	bg.Territory__c = sh.Id;
		bg.Total_Direct_Budget_TBR_NY__c = 11;
		bg.Total_POS_Budget_TBR_NY__c = 11;
		bg.Total_CMA_Budget_TBR_NY__c = 11;
		bg.Total_Budget_TBR_NY__c = 12;
    	insert bg;
    	
    	BBB_Month_Bill_Book_Cust__c bbb = new BBB_Month_Bill_Book_Cust__c();
    	bbb.Customer__c = acc.Id;
    	bbb.Fiscal_Year__c = '2013';
    	bbb.Bill_Type__c = 'CMA';
    	bbb.Budget_Direct__c = 1;
    	bbb.Budget_POS__c = 2;
    	bbb.Budget_CMA__c = 3;
    	bbb.Budget_TBR_NY__c = 12;
    	bbb.Monthly_BBB_External_Key__c = acc.Id;
    	bbb.Budget_Direct_Disp__c = 11;
    	bbb.Budget_Document_Currency__c = 1;
    	bbb.Budget_TBR_NY__c = 1;
    	bbb.Budget_Direct_Disp__c = 1;
    	bbb.Budget_POS_Disp__c = 1;
    	bbb.Budget_CMA_Disp__c = 1;
    	insert bbb; 
    	
    	BBB_Month_Bill_Book_Cust__c bbbmb = new BBB_Month_Bill_Book_Cust__c();
    	bbbmb.Customer__c = acc.Id;
    	bbbmb.fiscal_Year__c = '2013';
    	bbbmb.Bill_Amount_USD__c = 11;
    	bbbmb.Bill_Type__c = 'CMA';
    	insert bbbmb;
    	
    	Budget_Detail__c bd = ClsTestHelp.createTestBudgetDetail();
    	bd.Account__c = acc.Id;
    	bd.Budget__c = bg.Id;
    	bd.Type__c = 'Direct';
    	bd.Parent_Account__c = acc.Id;
    	bd.RecordTypeId = [select Id from RecordType where DeveloperName = 'Account' and SobjectType = 'Budget_Detail__c' limit 1][0].Id;
    	bd.Billings_LY__c = 11;
    	bd.Billings_CYTD__c = 1;
    	bd.Billings_CYRR__c = 2;
    	bd.Forecast_CY__c = 4;
    	bd.Budget_TBR_NY__c = 1;
    	bd.Budget_Document_Currency__c = 1;
    	bd.Market_Growth__c = 1;
    	bd.Price_Change__c = 2;
    	bd.Price_Increase__c = 3;
    	insert bd;
    	
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c part = new Part__c();
    	part.Description__c = 'Sniper';
    	part.Product_Hierarchy__c = ph.Id;
    	insert part;
    	 
    	BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c bbbp = new BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c();
    	bbbp.Customer__c = acc.Id;
    	bbbp.Part__c = part.Id;
    	bbbp.Customer_Request_Date__c = date.today();
    	bbbp.Current_Schedule_Date__c = date.today();
    	bbbp.Fiscal_Year__c = '2013';
    	bbbp.Bill_Type__c = 'CMA';
    	bbbp.Fiscal_Month__c = 12;
    	bbbp.Bill_Amount_USD__c = 12;
    	bbbp.Backlog_Amount_USD__c = 11;
    	insert bbbp;
    	
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Type = 'CM';
        oppy.AccountId = acc.Id;
        oppy.RecordTypeId = [select Id from RecordType where DeveloperName = 'Opportunity_Engineering_Project' and SobjectType = 'Opportunity'][0].Id;
        oppy.Sum_Part_Allocation__c = 100;
        insert oppy;
    	
    	Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
    	oppypart.Opportunity__c = oppy.Id;
    	oppypart.Part__c = part.Id;
        oppypart.Status__c = '50/50';
    	oppypart.Lost_Reason__c = 'Other';
    	oppypart.Lost_Reason_Text__c = null;
    	oppypart.Won_Fiscal_Year__c = '2014';
    	insert oppypart;
    	
        Opportunity_Partner__c oppyPartner = ClsTestHelp.createTestOpportunityPartner();
		oppyPartner.Opportunity__c = oppy.Id;
        oppyPartner.Account__c = acc.Id;
        oppyPartner.Allocation__c = 100;
        //insert oppyPartner;
        
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
    	oppyForecast.Opportunity__c = oppy.Id;
    	oppyForecast.Quantity__c = 0;
    	oppyForecast.Part__c = oppypart.Id;
    	oppyForecast.Date__c = date.today();
    	oppyForecast.Amount__c = 1;
    	oppyForecast.Fiscal_Year__c = '2014';
    	insert oppyForecast;
    	
    	List<ClsBudgetPlanBreakDownStructure> list_budgetPlanStructure = new List<ClsBudgetPlanBreakDownStructure>();
    	
    	ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem clsAcc = new ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem(acc.Id,'','EUR');   	
    	ClsBudgetPlanBreakDownStructure cls = new ClsBudgetPlanBreakDownStructure(rt.Id,acc.Id);
        cls.isRecalculate = true;
        cls.accountId = acc.Id;
        cls.setParentAccountItem(clsAcc);
        cls.getAccountId4Report();
        cls.getParentAccountItem();
        cls.getChildrenAccountItems();
        cls.calAccountDetailValue(1, 2, 3);
        cls.calAccountFCValue(1, 2, 3, 4, 'other');
        cls.calAccountFCValue(1, 2, 3, 4, '');
    	
    	list_budgetPlanStructure.add(cls);
    	
    	map<String, ClsBudgetPlanBreakDownStructure> map_accId_budgetPlanStructures = new map<String, ClsBudgetPlanBreakDownStructure>();
    	map_accId_budgetPlanStructures.put(acc.Id,cls);
    	
    	map<String, Id> map_budgetDetail_recordTypeId = new map<String, Id>();
    	
    	list<Budget_Detail__c> list_budgetDetail = new list<Budget_Detail__c>();
    	list_budgetDetail.add(bd);
    	
    	set<Id> set_accId = new set<Id>();
    	set_accId.add(acc.Id);
    	
    	map<Id,map<string,Budget_Detail__c>> map_accId_type_bd = new map<Id,map<string,Budget_Detail__c>>();
    	map<string,Budget_Detail__c> map_type_bd = new map<string,Budget_Detail__c>();
    	map_type_bd.put('Direct',bd);
    	map_accId_type_bd.put(acc.Id,map_type_bd);
    	
    	List<Budget_Detail__c> list_budgetDetails = new List<Budget_Detail__c>();
    	list_budgetDetails.add(bd);
    	
    	map<Integer, map<string,BBB_Month_Bill_Book_Cust__c>> map_BBBMonthly = new map<Integer, map<string,BBB_Month_Bill_Book_Cust__c>>();
    	map<string,BBB_Month_Bill_Book_Cust__c> map_str = new map<string,BBB_Month_Bill_Book_Cust__c>();
    	map_str.put('Direct',bbb);
    	map_BBBMonthly.put(1,map_str);
    	
    	map<String, map<Integer, Decimal>> map_billType_monthRate = new map<String, map<Integer, Decimal>>();
    	map<Integer, Decimal> map_ID = new map<Integer, Decimal>();
    	map_ID.put(1,1);
    	map_billType_monthRate.put('Direct',map_ID);
    	map_billType_monthRate.put('POS',map_ID);
    	map_billType_monthRate.put('CMA',map_ID);
    	
    	map<String,Decimal> map_type_Rate = new map<String,Decimal>();
    	map_type_Rate.put('Standard',1);
    	map_type_Rate.put('Rate',1);
    	
    	Test.startTest();
    	
    	ClsBudgetPlanBreakDownUtil.getBudgetPlanById(bg.Id);
    	ClsBudgetPlanBreakDownUtil.BuildBreakDownStructures(bg.Id, 'A007357', list_budgetPlanStructure, cls, map_accId_budgetPlanStructures, map_budgetDetail_recordTypeId, list_budgetDetail, set_accId, map_accId_type_bd);
    	ClsBudgetPlanBreakDownUtil.calAllValues(list_budgetPlanStructure);
    	ClsBudgetPlanBreakDownUtil.calTotalBudgetDetail(list_budgetDetails, cls);
    	ClsBudgetPlanBreakDownUtil.initDetailValues(bd);
    	ClsBudgetPlanBreakDownUtil.calcAccountItemValues(clsAcc, list_budgetDetails);
    	ClsBudgetPlanBreakDownUtil.refreshBBBMonthlyRecord(map_BBBMonthly, acc.Id, bg, map_billType_monthRate, 1, 1, map_type_Rate, clsAcc, map_type_bd);
    	ClsBudgetPlanBreakDownUtil.calcBudgetDetailToSave(clsAcc);
    	ClsBudgetPlanBreakDownUtil.calRunRateBusiValue(bd);
    	ClsBudgetPlanBreakDownUtil.calAdjustedBusiValue(bd, 1);
    	ClsBudgetPlanBreakDownUtil.calAdjustmentValue(bd, 1);
    	ClsBudgetPlanBreakDownUtil.getBBBMonthlyByAccountId(set_accId, '2013');
    	ClsBudgetPlanBreakDownUtil.calBBBMonthRateByQurater(bg);
    	ClsBudgetPlanBreakDownUtil.calFCBBBMonthRateByQurater(bg);
    	ClsBudgetPlanBreakDownUtil.calBudgetRate();
    	ClsBudgetPlanBreakDownUtil.calMonthRate(1, 2, 3);
    	
    	system.assert(true);
    	Test.stopTest();
    }
	static testMethod void testMostMethodsParentAcc2() {
    	Profile p = [Select Id, Name From Profile 
     								where Name = 'Production Support' 
     								or Name = 'Service Account' 
     								or Name ='System Administrator' 
     								or Name ='Systemadministrator' limit 1];
     	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'az@testCompany1233423.com';
    	u.Alias = 'dpse'; 
    	u.CommunityNickname = 'TMD';
    	u.ProfileId = p.Id;
		insert u;
    	
    	RecordType rt = ClsTestHelp.createTestRecordType8();
    	
    	Account acc2 = ClsTestHelp.createTestAccounts();
    	acc2.Individually_Planned__c = true;
    	acc2.Name = 'ohxxsx';
    	insert acc2;
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.RecordTypeId = rt.Id;
    	acc.SALES_TERRITORY_CDE__c = 'A003153';
    	acc.Individually_Planned__c = true;
    	acc.Account_Manager__c = u.Id;
    	acc.Plan_Group_Account__c = acc2.Id;
    	acc.Plan_Group_Id__c = acc2.Id;
    	insert acc;
    	
    	Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
    	sh.Level_7_Territory_Code__c = 'A007357';
    	insert sh;
    	
    	Budget__c bg = new Budget__c();
    	bg.Year__c = '2013';
    	bg.Territory__c = sh.Id;
		bg.Total_Direct_Budget_TBR_NY__c = 11;
		bg.Total_POS_Budget_TBR_NY__c = 11;
		bg.Total_CMA_Budget_TBR_NY__c = 11;
		bg.Total_Budget_TBR_NY__c = 12;
    	insert bg;
    	
    	BBB_Month_Bill_Book_Cust__c bbb = new BBB_Month_Bill_Book_Cust__c();
    	bbb.Customer__c = acc.Id;
    	bbb.Fiscal_Year__c = '2013';
    	bbb.Bill_Type__c = 'CMA';
    	bbb.Budget_Direct__c = 1;
    	bbb.Budget_POS__c = 2;
    	bbb.Budget_CMA__c = 3;
    	bbb.Budget_TBR_NY__c = 12;
    	bbb.Monthly_BBB_External_Key__c = acc.Id;
    	insert bbb; 
    	
    	BBB_Month_Bill_Book_Cust__c bbbmb = new BBB_Month_Bill_Book_Cust__c();
    	bbbmb.Customer__c = acc.Id;
    	bbbmb.fiscal_Year__c = '2013';
    	bbbmb.Bill_Amount_USD__c = 11;
    	bbbmb.Bill_Type__c = 'CMA';
    	insert bbbmb;
    	
    	Budget_Detail__c bd = ClsTestHelp.createTestBudgetDetail();
    	bd.Account__c = acc.Id;
    	bd.Budget__c = bg.Id;
    	bd.Type__c = 'Direct';
    	bd.RecordTypeId = [select Id from RecordType where DeveloperName = 'Account' and SobjectType = 'Budget_Detail__c' limit 1][0].Id;
    	insert bd;
    	
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c part = new Part__c();
    	part.Description__c = 'Sniper';
    	part.Product_Hierarchy__c = ph.Id;
    	insert part;
    	 
    	BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c bbbp = new BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c();
    	bbbp.Customer__c = acc.Id;
    	bbbp.Part__c = part.Id;
    	bbbp.Customer_Request_Date__c = date.today();
    	bbbp.Current_Schedule_Date__c = date.today();
    	bbbp.Fiscal_Year__c = '2013';
    	bbbp.Bill_Type__c = 'CMA';
    	bbbp.Fiscal_Month__c = 12;
    	bbbp.Bill_Amount_USD__c = 12;
    	bbbp.Backlog_Amount_USD__c = 11;
    	insert bbbp;
    	
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Type = 'CM';
        oppy.AccountId = acc.Id;
        oppy.RecordTypeId = [select Id from RecordType where DeveloperName = 'Opportunity_Engineering_Project' and SobjectType = 'Opportunity'][0].Id;
        oppy.Sum_Part_Allocation__c = 100;
        insert oppy;
    	
    	Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
    	oppypart.Opportunity__c = oppy.Id;
    	oppypart.Part__c = part.Id;
        oppypart.Status__c = '50/50';
    	oppypart.Lost_Reason__c = 'Other';
    	oppypart.Lost_Reason_Text__c = null;
    	oppypart.Won_Fiscal_Year__c = '2014';
    	insert oppypart;
    	
        Opportunity_Partner__c oppyPartner = ClsTestHelp.createTestOpportunityPartner();
		oppyPartner.Opportunity__c = oppy.Id;
        oppyPartner.Account__c = acc.Id;
        oppyPartner.Allocation__c = 100;
        //insert oppyPartner;
        
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
    	oppyForecast.Opportunity__c = oppy.Id;
    	oppyForecast.Quantity__c = 0;
    	oppyForecast.Part__c = oppypart.Id;
    	oppyForecast.Date__c = date.today();
    	oppyForecast.Amount__c = 1;
    	oppyForecast.Fiscal_Year__c = '2014';
    	insert oppyForecast;
    	
    	List<ClsBudgetPlanBreakDownStructure> list_budgetPlanStructure = new List<ClsBudgetPlanBreakDownStructure>();
    	
    	ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem clsAcc = new ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem(acc.Id,'','EUR');   	
    	ClsBudgetPlanBreakDownStructure cls = new ClsBudgetPlanBreakDownStructure(rt.Id,acc.Id);
        cls.isRecalculate = true;
        cls.accountId = acc.Id;
        cls.setParentAccountItem(clsAcc);
        cls.getAccountId4Report();
        cls.getParentAccountItem();
        cls.getChildrenAccountItems();
        cls.calAccountDetailValue(1, 2, 3);
        cls.calAccountFCValue(1, 2, 3, 4, 'other');
        cls.calAccountFCValue(1, 2, 3, 4, '');
    	
    	list_budgetPlanStructure.add(cls);
    	
    	map<String, ClsBudgetPlanBreakDownStructure> map_accId_budgetPlanStructures = new map<String, ClsBudgetPlanBreakDownStructure>();
    	map_accId_budgetPlanStructures.put(acc.Id,cls);
    	
    	map<String, Id> map_budgetDetail_recordTypeId = new map<String, Id>();
    	
    	list<Budget_Detail__c> list_budgetDetail = new list<Budget_Detail__c>();
    	list_budgetDetail.add(bd);
    	
    	set<Id> set_accId = new set<Id>();
    	set_accId.add(acc.Id);
    	
    	map<Id,map<string,Budget_Detail__c>> map_accId_type_bd = new map<Id,map<string,Budget_Detail__c>>();
    	map<string,Budget_Detail__c> map_type_bd = new map<string,Budget_Detail__c>();
    	map_type_bd.put('',bd);
    	map_accId_type_bd.put(acc.Id,map_type_bd);
    	
    	Test.startTest();
    	
    	ClsBudgetPlanBreakDownUtil.getBudgetPlanById(bg.Id);
    	ClsBudgetPlanBreakDownUtil.BuildBreakDownStructures(bg.Id, 'A007357', list_budgetPlanStructure, cls, map_accId_budgetPlanStructures, map_budgetDetail_recordTypeId, list_budgetDetail, set_accId, map_accId_type_bd);
    	
    	system.assert(true);
    	Test.stopTest();
    }  
	static testMethod void testMostMethodsRTOther1() {
    	Profile p = [Select Id, Name From Profile 
     								where Name = 'Production Support' 
     								or Name = 'Service Account' 
     								or Name ='System Administrator' 
     								or Name ='Systemadministrator' limit 1];
     	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'az@testCompany1233423.com';
    	u.Alias = 'dpse'; 
    	u.CommunityNickname = 'TMD';
    	u.ProfileId = p.Id;
		insert u;
    	
    	RecordType rt = ClsTestHelp.createTestRecordType8();
    	
    	Account acc2 = ClsTestHelp.createTestAccounts();
    	acc2.Individually_Planned__c = true;
    	acc2.Name = 'ohxxsx';
    	insert acc2;
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.RecordTypeId = rt.Id;
    	acc.SALES_TERRITORY_CDE__c = 'A003153';
    	acc.Individually_Planned__c = true;
    	acc.Account_Manager__c = u.Id;
    	acc.Plan_Group_Account__c = acc2.Id;
    	acc.Plan_Group_Id__c = acc2.Id;
    	insert acc;
    	
    	Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
    	sh.Level_7_Territory_Code__c = 'A007357';
    	insert sh;
    	
    	Budget__c bg = new Budget__c();
    	bg.Year__c = '2013';
    	bg.Territory__c = sh.Id;
		bg.Total_Direct_Budget_TBR_NY__c = 11;
		bg.Total_POS_Budget_TBR_NY__c = 11;
		bg.Total_CMA_Budget_TBR_NY__c = 11;
		bg.Total_Budget_TBR_NY__c = 12;
    	insert bg;
    	
    	BBB_Month_Bill_Book_Cust__c bbb = new BBB_Month_Bill_Book_Cust__c();
    	bbb.Customer__c = acc.Id;
    	bbb.Fiscal_Year__c = '2013';
    	bbb.Bill_Type__c = 'CMA';
    	bbb.Budget_Direct__c = 1;
    	bbb.Budget_POS__c = 2;
    	bbb.Budget_CMA__c = 3;
    	bbb.Budget_TBR_NY__c = 12;
    	bbb.Monthly_BBB_External_Key__c = acc.Id;
    	insert bbb; 
    	
    	BBB_Month_Bill_Book_Cust__c bbbmb = new BBB_Month_Bill_Book_Cust__c();
    	bbbmb.Customer__c = acc.Id;
    	bbbmb.fiscal_Year__c = '2013';
    	bbbmb.Bill_Amount_USD__c = 11;
    	bbbmb.Bill_Type__c = 'CMA';
    	insert bbbmb;
    	
    	Budget_Detail__c bd = ClsTestHelp.createTestBudgetDetail();
    	bd.Account__c = acc.Id;
    	bd.Parent_Account__c = null;
    	bd.Budget__c = bg.Id;
    	bd.Type__c = 'Direct';
    	bd.RecordTypeId = [select Id from RecordType where DeveloperName = 'Other' and SobjectType = 'Budget_Detail__c' limit 1][0].Id;
    	insert bd;
    	
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c part = new Part__c();
    	part.Description__c = 'Sniper';
    	part.Product_Hierarchy__c = ph.Id;
    	insert part;
    	 
    	BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c bbbp = new BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c();
    	bbbp.Customer__c = acc.Id;
    	bbbp.Part__c = part.Id;
    	bbbp.Customer_Request_Date__c = date.today();
    	bbbp.Current_Schedule_Date__c = date.today();
    	bbbp.Fiscal_Year__c = '2013';
    	bbbp.Bill_Type__c = 'CMA';
    	bbbp.Fiscal_Month__c = 12;
    	bbbp.Bill_Amount_USD__c = 12;
    	bbbp.Backlog_Amount_USD__c = 11;
    	insert bbbp;
    	
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Type = 'CM';
        oppy.AccountId = acc.Id;
        oppy.RecordTypeId = [select Id from RecordType where DeveloperName = 'Opportunity_Engineering_Project' and SobjectType = 'Opportunity'][0].Id;
        oppy.Sum_Part_Allocation__c = 100;
        insert oppy;
    	
    	Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
    	oppypart.Opportunity__c = oppy.Id;
    	oppypart.Part__c = part.Id;
        oppypart.Status__c = '50/50';
    	oppypart.Lost_Reason__c = 'Other';
    	oppypart.Lost_Reason_Text__c = null;
    	oppypart.Won_Fiscal_Year__c = '2014';
    	insert oppypart;
    	
        Opportunity_Partner__c oppyPartner = ClsTestHelp.createTestOpportunityPartner();
		oppyPartner.Opportunity__c = oppy.Id;
        oppyPartner.Account__c = acc.Id;
        oppyPartner.Allocation__c = 100;
        //insert oppyPartner;
        
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
    	oppyForecast.Opportunity__c = oppy.Id;
    	oppyForecast.Quantity__c = 0;
    	oppyForecast.Part__c = oppypart.Id;
    	oppyForecast.Date__c = date.today();
    	oppyForecast.Amount__c = 1;
    	oppyForecast.Fiscal_Year__c = '2014';
    	insert oppyForecast;
    	
    	List<ClsBudgetPlanBreakDownStructure> list_budgetPlanStructure = new List<ClsBudgetPlanBreakDownStructure>();
    	
    	ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem clsAcc = new ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem(acc.Id,'','EUR');   	
    	ClsBudgetPlanBreakDownStructure cls = new ClsBudgetPlanBreakDownStructure(rt.Id,acc.Id);
        cls.isRecalculate = true;
        cls.accountId = acc.Id;
        cls.setParentAccountItem(clsAcc);
        cls.getAccountId4Report();
        cls.getParentAccountItem();
        cls.getChildrenAccountItems();
        cls.calAccountDetailValue(1, 2, 3);
        cls.calAccountFCValue(1, 2, 3, 4, 'other');
        cls.calAccountFCValue(1, 2, 3, 4, '');
    	
    	list_budgetPlanStructure.add(cls);
    	
    	map<String, ClsBudgetPlanBreakDownStructure> map_accId_budgetPlanStructures = new map<String, ClsBudgetPlanBreakDownStructure>();
    	map_accId_budgetPlanStructures.put(acc.Id,cls);
    	
    	map<String, Id> map_budgetDetail_recordTypeId = new map<String, Id>();
    	
    	list<Budget_Detail__c> list_budgetDetail = new list<Budget_Detail__c>();
    	list_budgetDetail.add(bd);
    	
    	set<Id> set_accId = new set<Id>();
    	set_accId.add(acc.Id);
    	
    	map<Id,map<string,Budget_Detail__c>> map_accId_type_bd = new map<Id,map<string,Budget_Detail__c>>();
    	map<string,Budget_Detail__c> map_type_bd = new map<string,Budget_Detail__c>();
    	map_type_bd.put('',bd);
    	map_accId_type_bd.put(acc.Id,map_type_bd);
    	
    	Test.startTest();
    	
    	ClsBudgetPlanBreakDownUtil.getBudgetPlanById(bg.Id);
    	ClsBudgetPlanBreakDownUtil.BuildBreakDownStructures(bg.Id, 'A007357', list_budgetPlanStructure, cls, map_accId_budgetPlanStructures, map_budgetDetail_recordTypeId, list_budgetDetail, set_accId, map_accId_type_bd);
    	
    	system.assert(true);
    	Test.stopTest();
    }            
	static testMethod void testMostMethodsRTOther2() {
    	Profile p = [Select Id, Name From Profile 
     								where Name = 'Production Support' 
     								or Name = 'Service Account' 
     								or Name ='System Administrator' 
     								or Name ='Systemadministrator' limit 1];
     	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'az@testCompany1233423.com';
    	u.Alias = 'dpse'; 
    	u.CommunityNickname = 'TMD';
    	u.ProfileId = p.Id;
		insert u;
    	
    	RecordType rt = ClsTestHelp.createTestRecordType8();
    	
    	Account acc2 = ClsTestHelp.createTestAccounts();
    	acc2.Individually_Planned__c = true;
    	acc2.Name = 'ohxxsx';
    	insert acc2;
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.RecordTypeId = rt.Id;
    	acc.SALES_TERRITORY_CDE__c = 'A003153';
    	acc.Individually_Planned__c = true;
    	acc.Account_Manager__c = u.Id;
    	acc.Plan_Group_Account__c = acc2.Id;
    	acc.Plan_Group_Id__c = acc2.Id;
    	insert acc;
    	
    	Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
    	sh.Level_7_Territory_Code__c = 'A007357';
    	insert sh;
    	
    	Budget__c bg = new Budget__c();
    	bg.Year__c = '2013';
    	bg.Territory__c = sh.Id;
		bg.Total_Direct_Budget_TBR_NY__c = 11;
		bg.Total_POS_Budget_TBR_NY__c = 11;
		bg.Total_CMA_Budget_TBR_NY__c = 11;
		bg.Total_Budget_TBR_NY__c = 12;
    	insert bg;
    	
    	BBB_Month_Bill_Book_Cust__c bbb = new BBB_Month_Bill_Book_Cust__c();
    	bbb.Customer__c = acc.Id;
    	bbb.Fiscal_Year__c = '2013';
    	bbb.Bill_Type__c = 'CMA';
    	bbb.Budget_Direct__c = 1;
    	bbb.Budget_POS__c = 2;
    	bbb.Budget_CMA__c = 3;
    	bbb.Budget_TBR_NY__c = 12;
    	bbb.Monthly_BBB_External_Key__c = acc.Id;
    	insert bbb; 
    	
    	BBB_Month_Bill_Book_Cust__c bbbmb = new BBB_Month_Bill_Book_Cust__c();
    	bbbmb.Customer__c = acc.Id;
    	bbbmb.fiscal_Year__c = '2013';
    	bbbmb.Bill_Amount_USD__c = 11;
    	bbbmb.Bill_Type__c = 'CMA';
    	insert bbbmb;
    	
    	Budget_Detail__c bd = ClsTestHelp.createTestBudgetDetail();
    	bd.Account__c = acc.Id;
    	bd.Parent_Account__c = null;
    	bd.Budget__c = bg.Id;
    	bd.Type__c = 'Direct';
    	bd.RecordTypeId = [select Id from RecordType where DeveloperName = 'Other' and SobjectType = 'Budget_Detail__c' limit 1][0].Id;
    	insert bd;
    	
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c part = new Part__c();
    	part.Description__c = 'Sniper';
    	part.Product_Hierarchy__c = ph.Id;
    	insert part;
    	 
    	BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c bbbp = new BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c();
    	bbbp.Customer__c = acc.Id;
    	bbbp.Part__c = part.Id;
    	bbbp.Customer_Request_Date__c = date.today();
    	bbbp.Current_Schedule_Date__c = date.today();
    	bbbp.Fiscal_Year__c = '2013';
    	bbbp.Bill_Type__c = 'CMA';
    	bbbp.Fiscal_Month__c = 12;
    	bbbp.Bill_Amount_USD__c = 12;
    	bbbp.Backlog_Amount_USD__c = 11;
    	insert bbbp;
    	
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Type = 'CM';
        oppy.AccountId = acc.Id;
        oppy.RecordTypeId = [select Id from RecordType where DeveloperName = 'Opportunity_Engineering_Project' and SobjectType = 'Opportunity'][0].Id;
        oppy.Sum_Part_Allocation__c = 100;
        insert oppy;
    	
    	Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
    	oppypart.Opportunity__c = oppy.Id;
    	oppypart.Part__c = part.Id;
        oppypart.Status__c = '50/50';
    	oppypart.Lost_Reason__c = 'Other';
    	oppypart.Lost_Reason_Text__c = null;
    	oppypart.Won_Fiscal_Year__c = '2014';
    	insert oppypart;
    	
        Opportunity_Partner__c oppyPartner = ClsTestHelp.createTestOpportunityPartner();
		oppyPartner.Opportunity__c = oppy.Id;
        oppyPartner.Account__c = acc.Id;
        oppyPartner.Allocation__c = 100;
        //insert oppyPartner;
        
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
    	oppyForecast.Opportunity__c = oppy.Id;
    	oppyForecast.Quantity__c = 0;
    	oppyForecast.Part__c = oppypart.Id;
    	oppyForecast.Date__c = date.today();
    	oppyForecast.Amount__c = 1;
    	oppyForecast.Fiscal_Year__c = '2014';
    	insert oppyForecast;
    	
    	List<ClsBudgetPlanBreakDownStructure> list_budgetPlanStructure = new List<ClsBudgetPlanBreakDownStructure>();
    	
    	ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem clsAcc = new ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem(acc.Id,'','EUR');   	
    	ClsBudgetPlanBreakDownStructure cls = new ClsBudgetPlanBreakDownStructure(rt.Id,acc.Id);
        cls.isRecalculate = true;
        cls.accountId = acc.Id;
        cls.setParentAccountItem(clsAcc);
        cls.getAccountId4Report();
        cls.getParentAccountItem();
        cls.getChildrenAccountItems();
        cls.calAccountDetailValue(1, 2, 3);
        cls.calAccountFCValue(1, 2, 3, 4, 'other');
        cls.calAccountFCValue(1, 2, 3, 4, '');
    	
    	list_budgetPlanStructure.add(cls);
    	
    	map<String, ClsBudgetPlanBreakDownStructure> map_accId_budgetPlanStructures = new map<String, ClsBudgetPlanBreakDownStructure>();
    	map_accId_budgetPlanStructures.put(acc2.Id,cls);
    	
    	map<String, Id> map_budgetDetail_recordTypeId = new map<String, Id>();
    	
    	list<Budget_Detail__c> list_budgetDetail = new list<Budget_Detail__c>();
    	list_budgetDetail.add(bd);
    	
    	set<Id> set_accId = new set<Id>();
    	set_accId.add(acc.Id);
    	
    	map<Id,map<string,Budget_Detail__c>> map_accId_type_bd = new map<Id,map<string,Budget_Detail__c>>();
    	map<string,Budget_Detail__c> map_type_bd = new map<string,Budget_Detail__c>();
    	map_type_bd.put('',bd);
    	map_accId_type_bd.put(acc.Id,map_type_bd);
    	
    	Test.startTest();
    	
    	ClsBudgetPlanBreakDownUtil.getBudgetPlanById(bg.Id);
    	ClsBudgetPlanBreakDownUtil.BuildBreakDownStructures(bg.Id, 'A007357', list_budgetPlanStructure, cls, map_accId_budgetPlanStructures, map_budgetDetail_recordTypeId, list_budgetDetail, set_accId, map_accId_type_bd);
    	
    	system.assert(true);
    	Test.stopTest();
    }                
}