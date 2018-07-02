/**
*   This test class is for ClsBudgetPlanningUtil.
*
@author Di Chen
@created 2012-06-07
@version 1.0
@since 20.0
*
@changelog
* 2012-06-07 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 89%
*/
@isTest(seeAllData = false)    
private class ClsBudgetPlanningUtil_Test { 

     static testMethod void testTypeDirect() {
         ClsTestCustomSettingHelper.getApex_Helper_Settings();
         ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
     	Test.startTest();
     	ClsSharingUtil.TriggerRecursionDefense = true;
        //ClsOppyPartUtil.needCheckAlloc = false; 
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
        u.Te_Network_Id__c = 'te-00014';
        u.Username = 'az@testCompany1233423.com1';
        insert u;
        
        system.runAs(u){
        RecordType rt = ClsTestHelp.createTestRecordType8();  //detail.RecordType.DeveloperName = 'CIS_Account'
        
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.Individually_Planned__c = true;
        acc2.Name = 'ohxxsx';
        acc2.SALES_TERRITORY_CDE__c = 'A007357';
        insert acc2;
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt.Id;
        acc.SALES_TERRITORY_CDE__c = 'A007357';
        acc.Individually_Planned__c = true;
        acc.Account_Manager__c = u.Id;
        acc.Plan_Group_Account__c = acc2.Id;
        insert acc; 
            
        Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
        sh.Level_7_Territory_Code__c = 'A007357';
        insert sh;
        
        Budget__c bg = new Budget__c();
        bg.Year__c = '2012';
        bg.Territory__c = sh.Id;
        bg.Total_Direct_Budget_TBR_NY__c = 11;
        bg.Total_POS_Budget_TBR_NY__c = 11;
        bg.Total_CMA_Budget_TBR_NY__c = 11;
        bg.Total_Budget_TBR_NY__c = 12;
        //insert bg;
        Budget__c bg1 = new Budget__c();
        bg1.Year__c = '2012';
        bg1.Status__c = 'Draft';
        bg1.Territory__c = sh.Id;
        bg1.Total_Direct_Budget_TBR_NY__c = 11;
        bg1.Total_POS_Budget_TBR_NY__c = 11;
        bg1.Total_CMA_Budget_TBR_NY__c = 11;
        bg1.Total_Budget_TBR_NY__c = 12;
            insert new List<Budget__c> {bg,bg1};
        
        Budget_Detail__c bd = ClsTestHelp.createTestBudgetDetail();       
        bd.Account__c = acc.Id;
        bd.Parent_Account__c = acc2.Id;
        bd.Budget__c = bg.Id;
        bd.Type__c = 'Direct';
        insert bd;
            
            
       Budget_Detail__c bd1 = ClsTestHelp.createTestBudgetDetail();
        //bd1.Account_Territory_Code__c = 'A007357';        
        bd1.Account__c = acc.Id;
        bd1.Parent_Account__c = acc2.Id;
        bd1.Budget__c = bg1.Id;
        bd1.Type__c = 'CMA';
        insert bd1;
            
            
            
            
        
        bg = [Select Territory__c,ownerId, Territory_Code__c,Year__c, Total_Direct_Budget_TBR_NY__c, Total_POS_Budget_TBR_NY__c, Total_CMA_Budget_TBR_NY__c, Total_Budget_TBR_NY__c, Territory__r.Level_7_Territory_Code__c from Budget__c where Id =: bg.Id];
        bd = [select Id, RecordType.DeveloperName, Budget__c,
													Account__r.Account_Combined_Data__c, Account__c, Account__r.Name,
													Parent_Account__c, Parent_Account__r.Account_Combined_Data__c, Parent_Account__r.Name, 
													Adjusted_Business__c, Adjustment__c, Backlog__c, Billings_CYRR__c, 
													Billings_CYTD__c, Billings_LY__c, Calculated_Budget__c, Comments__c, 
													Forecast_CY__c, Manager_Final_Budget__c, Manager_Total_Budget__c, 
													Market_Growth__c, Obsoletion_EOL__c, Opportunities50_50__c, 
													Opportunities_Commit__c, Opportunities_Likely__c, Opportunities_Pipeline__c, 
													Opportunities_Weak__c, Opportunities_Won__c, Price_Change__c, Price_Increase__c, 
													Run_Rate_Business__c, TAM_DTAM__c, Total_Budget__c, Transfer_In__c, Transfer_Out__c, 
													Type__c, Account_Territory_Code__c, Budget_Year__c, Business_Transfers__c, Growth__c, Budget_TBR_NY__c from Budget_Detail__c where id =: bd.Id];		
        bg1 = [Select Territory__c, Status__c, Year__c, ownerId,Territory_Code__c,Total_Direct_Budget_TBR_NY__c, Total_POS_Budget_TBR_NY__c, Total_CMA_Budget_TBR_NY__c, Total_Budget_TBR_NY__c, Territory__r.Level_7_Territory_Code__c from Budget__c where Id =: bg.Id];
        BBB_Month_Bill_Book_Cust__c bbb = new BBB_Month_Bill_Book_Cust__c();
        bbb.Customer__c = acc.Id;
        bbb.Fiscal_Year__c = '2012';
        bbb.Bill_Type__c = 'Direct';
        bbb.Budget_Direct__c = 1;
        bbb.Budget_POS__c = 2;
        bbb.Budget_CMA__c = 3;
        bbb.Budget_TBR_NY__c = 12;
        //insert bbb; 

        //set Load_Status__c for Budget Planning by kevin shen
        
        Load_Status__c  load_status = new Load_Status__c();       
        load_status.Current_Fiscal_Year__c = '2013';
        load_status.Name = 'BBB_Month_Bill_Book_Cust__c Direct';
        load_status.Current_Fiscal_Month__c = 8;
        insert load_status;
            
            
        BBB_Month_Bill_Book_Cust__c bbbmb = new BBB_Month_Bill_Book_Cust__c();
        bbbmb.Customer__c = acc.Id;
        bbbmb.fiscal_Year__c = '2012';
        insert new List<BBB_Month_Bill_Book_Cust__c> {bbb,bbbmb};
        
        insert new Budget_Rate__c(CurrencyIsoCode = 'USD',Rate__c=60);
         
        Id uId = UserInfo.getUserId();
        String territory = sh.Id;
        String year = '2012';
        
        Set<String> set_years = new Set<String>();
        set_years.add('2012');
        
        Set<String> set_territory = new Set<String>();
        set_territory.add(territory);
        
        List<String> list_accIds = new List<String>();
        list_accIds.add(acc.Id);
 
        Map<String, ClsAnnualBudgetPlanStructure> map_accId_budgetPlanStructures = new Map<String, ClsAnnualBudgetPlanStructure>();
        ClsAnnualBudgetPlanStructure budgetPlanStructure = new ClsAnnualBudgetPlanStructure(acc.Id);
        map_accId_budgetPlanStructures.put(acc.Id, budgetPlanStructure);
        map_accId_budgetPlanStructures.put(String.valueOf(acc2.Id).substring(0,15), budgetPlanStructure);
        
		ClsBudgetPlanningUtil.buildBudgetStructure(map_accId_budgetPlanStructures, bg, budgetPlanStructure, budgetPlanStructure);
        ClsBudgetPlanningUtil.getCurrentFiscalYear();
        
        ClsBudgetPlanningUtil.FilterYears(uId, territory, set_years);
        ClsBudgetPlanningUtil.filterTerritory(uId, year, set_territory);
        ClsBudgetPlanningUtil.getBudgetPlanById(bg.Id);
        ClsBudgetPlanningUtil.getAllFiscalMonthDateRange();
        ClsBudgetPlanningUtil.salesPeriodDate('2012',11);
    
        ClsBudgetPlanningUtil.calBudgetPlanningSalesPeriodDate('2013');            
        load_status.Current_Fiscal_Year__c = '2012';
        update load_status;      
        ClsBudgetPlanningUtil.getLoadStatusByYear('2012');        
            
        ClsBudgetPlanningUtil.calBudgetRate();

        ClsBudgetPlanningUtil.getFiscalMonthByDate(date.newInstance(2012, 7, 7),'2012');
        
        map<String, map<Integer, BBB_Month_Bill_Book_Cust__c>> map_BBBMonthly = new map<String, map<Integer, BBB_Month_Bill_Book_Cust__c>>();
        map<Integer, BBB_Month_Bill_Book_Cust__c> map_bbb = new map<Integer, BBB_Month_Bill_Book_Cust__c>();
        map_bbb.put(2012,bbb);
        map_BBBMonthly.put('Direct',map_bbb);

        map<String,Decimal> map_year_Rate = new map<String,Decimal>();
        map_year_Rate.put('2012',12);
        
        map<String, map<Integer, Decimal>> map_billType_monthRate = new map<String, map<Integer, Decimal>>();
        map_billType_monthRate.put('Direct', new map<Integer, Decimal>());
        map_billType_monthRate.put('POS', new map<Integer, Decimal>());
        map_billType_monthRate.put('CMA', new map<Integer, Decimal>());
        map_billType_monthRate.get('Direct').put(1, 1);
        map_billType_monthRate.get('POS').put(1, 1);
        map_billType_monthRate.get('CMA').put(1, 1);
        
        ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem item = new ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem(acc.Id, 'test', 'EUR');
        item.TotalBudget4Direct = 1000;
        item.TotalBudget4POS = 1000;
        item.TotalBudget4CMA = 1000;
        item.ForecastCY = 1000;
        
        ClsBudgetPlanningUtil.calMonthRate(1, 1, 1);
        
        list<Id> list_individualAccIds = new list<Id>();
        list_individualAccIds.add(acc2.Id);
        ClsBudgetPlanningUtil.getDefaultYearList(2012);
        ClsAnnualBudgetPlanStructure.BudgetPlanningItem clsBu = new ClsAnnualBudgetPlanStructure.BudgetPlanningItem();
        clsBu.TotalBudget = 1;
        clsBu.BillingsLY = 1;
        clsBu.BillingsYTDCY = 1;
        clsBu.BillingsRRCY = 1;
        clsBu.Backlog = 1;
        clsBu.EstimatedFinalCY = 1;
        clsBu.ObsoletionEOL = 1;
        clsBu.TransferOut = 1;
        clsBu.TransferIn = 1;
        clsBu.TAMDTAM = 1;
        clsBu.RepeatBusiness = 1;
        clsBu.CustomerGrowth = 1;
        clsBu.MarketPriceChange = 1;
        clsBu.PriceIncrease = 1;
        clsBu.AdjRepeatBusiness = 1;
        clsBu.OpportunitiesWon = 1;
        clsBu.Forecast = 1;
        clsBu.OpportunitiesCommit = 1;
        clsBu.OpportunitiesLikely = 1;
        clsBu.Opportunities5050 = 1;
        clsBu.OpportunitiesWeak = 1;
        clsBu.Adjustment = 1;
        clsBu.Growth = 1;
        clsBu.TotalAccountBudget = 1;
        clsBu.TotalOtherBudget = 1;
        
        ClsAnnualBudgetPlanStructure.BudgetPlanningAccountItem accItem = new ClsAnnualBudgetPlanStructure.BudgetPlanningAccountItem();
            
        ClsBudgetPlanningUtil.calRunRateBusiValue(clsBu);
        ClsBudgetPlanningUtil.calAdjustedBusiValue(clsBu);
        List<Budget_Detail__c> list_budgetDetails = new List<Budget_Detail__c>();
        list_budgetDetails.add(bd);
        
        ClsBudgetPlanningUtil cls = new ClsBudgetPlanningUtil();
        
        ClsBudgetPlanningUtil.determineApprover(bg);
        
        ClsBudgetPlanningUtil.createBudgetDetailFromStructureDetail(bg.Id, 'Other', acc.Id, clsBu, accItem, rt.Id, 1); 
        
        ClsBudgetPlanningUtil.getFiscalMonth(date.today());
        
        List<Account> list_accounts = new List<Account>();
        list_accounts.add(acc2);
        list_accounts.add(acc);
         
        Map<Id, Boolean> map_parentId_planned = new Map<Id, Boolean>();
        map_parentId_planned.put(acc.Id,true);
        
        List<BBB_Month_Bill_Book_Cust__c> list_bbbM2Recal = new List<BBB_Month_Bill_Book_Cust__c>();
        list_bbbM2Recal.add(bbb);
        
        ClsBudgetPlanningUtil.updatePlanGroupId(list_accounts, map_parentId_planned, 'trigger', 'delete');
        ClsBudgetPlanningUtil.updatePlanGroupId(list_accounts, map_parentId_planned, 'trigger', 'update');
        ClsBudgetPlanningUtil.updatePlanGroupId(list_accounts, map_parentId_planned, 'batch', 'update');  
        ClsBudgetPlanningUtil.allocatedOpportunityValues('Won', clsBu, accItem, 1);    
        ClsBudgetPlanningUtil.allocatedOpportunityValues('Weak', clsBu, accItem, 1); 
        ClsBudgetPlanningUtil.allocatedOpportunityValues('Commit', clsBu, accItem, 1); 
        ClsBudgetPlanningUtil.allocatedOpportunityValues('Likely', clsBu, accItem, 1); 
        ClsBudgetPlanningUtil.allocatedOpportunityValues('50/50', clsBu, accItem, 1);   
        map<String, map<String,Budget_Detail__c>> map_existingDetails = new map<String, map<String,Budget_Detail__c>>();
  
        ClsBudgetPlanningUtil.fillOldBudgetDetailsIntoStructure('2012', list_accIds, bg, 'A007357', map_existingDetails);
                      
        ClsBudgetPlanningUtil.fillOldBudgetDetailsIntoStructure('2012', list_accIds, bg1, 'A007357', map_existingDetails);
        
            
        //Map<String, ClsAnnualBudgetPlanStructure> map_accId_budgetPlanStructures = new Map<String, ClsAnnualBudgetPlanStructure>();
        Map<String, ClsAnnualBudgetPlanStructure> map_accParId_budgetPlanStructures = new Map<String, ClsAnnualBudgetPlanStructure>();
        //ClsAnnualBudgetPlanStructure budgetPlanStructure = new ClsAnnualBudgetPlanStructure(acc.Id);
        map_accId_budgetPlanStructures.put(String.valueOf(acc.Id).substring(0,15),budgetPlanStructure);
        map_accId_budgetPlanStructures.put(acc.Id, budgetPlanStructure);
        map_accId_budgetPlanStructures.put(acc2.Id, budgetPlanStructure);
        map_accParId_budgetPlanStructures.put(String.valueOf(acc2.Id).substring(0,15),budgetPlanStructure);
        map_accParId_budgetPlanStructures.put(acc2.Id, budgetPlanStructure);
        map_accParId_budgetPlanStructures.put(acc.Id, budgetPlanStructure);
        ClsBudgetPlanningUtil.buildBudgetByAccountId('2012', '2012', map_accId_budgetPlanStructures, list_accIds, bg, budgetPlanStructure, 'A007357', map_existingDetails);    
        ClsBudgetPlanningUtil.buildBudgetByAccountId('2014', '2013', map_accId_budgetPlanStructures, list_accIds, bg, budgetPlanStructure, 'A007357', map_existingDetails);  
        ClsBudgetPlanningUtil.buildBudgetByAccountId('2014', '2013', map_accParId_budgetPlanStructures, list_accIds, bg, budgetPlanStructure, 'A007357', map_existingDetails); 
        ClsBudgetPlanningUtil.transformIsoCode(12, 'USD', 'EUR');
        //ClsBudgetPlanningUtil.setBBBMonthlyValuesByBudgets(new List<Budget__c> {bg,bg1});
        /*map<Id, map<String, Budget__c>> map_accId_year_budget = new map<Id, map<String, Budget__c>>();
        map_accId_year_budget.put(acc.id, new map<String, Budget__c>());
        map_accId_year_budget.get(acc.id).put('2012',bg1);
        ClsBudgetPlanningUtil.processUpdateBBBMonthlyVlaues(map_accId_year_budget,new Set<Id> {acc.Id}, new Set<String> {'2012'});  */  
        system.assert(true);
        Test.stopTest();
        }
    }
     static testMethod void testTypeDirect2() {
         ClsTestCustomSettingHelper.getApex_Helper_Settings();
         ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
     	Test.startTest();
     	ClsSharingUtil.TriggerRecursionDefense = true;
        //ClsOppyPartUtil.needCheckAlloc = false; 
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
        u.Te_Network_Id__c = 'te-00014';
        u.Username = 'az@testCompany1233423.com1';
        insert u;
        
        system.runAs(u){
        RecordType rt = ClsTestHelp.createTestRecordType8();  //detail.RecordType.DeveloperName = 'CIS_Account'
        
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.Individually_Planned__c = true;
        acc2.Name = 'ohxxsx';
        acc2.SALES_TERRITORY_CDE__c = 'A007357';
        insert acc2;
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt.Id;
        acc.SALES_TERRITORY_CDE__c = 'A007357';
        acc.Individually_Planned__c = true;
        acc.Account_Manager__c = u.Id;
        acc.Plan_Group_Account__c = acc2.Id;
        insert acc; 
            
        Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
        sh.Level_7_Territory_Code__c = 'A007357';
        insert sh;
        
        Budget__c bg = new Budget__c();
        bg.Year__c = '2012';
        bg.Territory__c = sh.Id;
        bg.Total_Direct_Budget_TBR_NY__c = 11;
        bg.Total_POS_Budget_TBR_NY__c = 11;
        bg.Total_CMA_Budget_TBR_NY__c = 11;
        bg.Total_Budget_TBR_NY__c = 12;
        //insert bg;
        Budget__c bg1 = new Budget__c();
        bg1.Year__c = '2012';
        bg1.Status__c = 'Draft';
        bg1.Territory__c = sh.Id;
        bg1.Total_Direct_Budget_TBR_NY__c = 11;
        bg1.Total_POS_Budget_TBR_NY__c = 11;
        bg1.Total_CMA_Budget_TBR_NY__c = 11;
        bg1.Total_Budget_TBR_NY__c = 12;
            insert new List<Budget__c> {bg,bg1};
        
        Budget_Detail__c bd = ClsTestHelp.createTestBudgetDetail();       
        bd.Account__c = acc.Id;
        bd.Parent_Account__c = acc2.Id;
        bd.Budget__c = bg.Id;
        bd.Type__c = 'Direct';
        insert bd;
            
            
       Budget_Detail__c bd1 = ClsTestHelp.createTestBudgetDetail();
        //bd1.Account_Territory_Code__c = 'A007357';        
        bd1.Account__c = acc.Id;
        bd1.Parent_Account__c = acc2.Id;
        bd1.Budget__c = bg1.Id;
        bd1.Type__c = 'CMA';
        insert bd1;
            
            
            
            
        
        bg = [Select Territory__c,ownerId, Territory_Code__c,Year__c, Total_Direct_Budget_TBR_NY__c, Total_POS_Budget_TBR_NY__c, Total_CMA_Budget_TBR_NY__c, Total_Budget_TBR_NY__c, Territory__r.Level_7_Territory_Code__c from Budget__c where Id =: bg.Id];
        bd = [select Id, RecordType.DeveloperName, Budget__c,
													Account__r.Account_Combined_Data__c, Account__c, Account__r.Name,
													Parent_Account__c, Parent_Account__r.Account_Combined_Data__c, Parent_Account__r.Name, 
													Adjusted_Business__c, Adjustment__c, Backlog__c, Billings_CYRR__c, 
													Billings_CYTD__c, Billings_LY__c, Calculated_Budget__c, Comments__c, 
													Forecast_CY__c, Manager_Final_Budget__c, Manager_Total_Budget__c, 
													Market_Growth__c, Obsoletion_EOL__c, Opportunities50_50__c, 
													Opportunities_Commit__c, Opportunities_Likely__c, Opportunities_Pipeline__c, 
													Opportunities_Weak__c, Opportunities_Won__c, Price_Change__c, Price_Increase__c, 
													Run_Rate_Business__c, TAM_DTAM__c, Total_Budget__c, Transfer_In__c, Transfer_Out__c, 
													Type__c, Account_Territory_Code__c, Budget_Year__c, Business_Transfers__c, Growth__c, Budget_TBR_NY__c from Budget_Detail__c where id =: bd.Id];		
        bg1 = [Select Territory__c, Status__c, Year__c, ownerId,Territory_Code__c,Total_Direct_Budget_TBR_NY__c, Total_POS_Budget_TBR_NY__c, Total_CMA_Budget_TBR_NY__c, Total_Budget_TBR_NY__c, Territory__r.Level_7_Territory_Code__c from Budget__c where Id =: bg.Id];
        BBB_Month_Bill_Book_Cust__c bbb = new BBB_Month_Bill_Book_Cust__c();
        bbb.Customer__c = acc.Id;
        bbb.Fiscal_Year__c = '2012';
        bbb.Bill_Type__c = 'Direct';
        bbb.Budget_Direct__c = 1;
        bbb.Budget_POS__c = 2;
        bbb.Budget_CMA__c = 3;
        bbb.Budget_TBR_NY__c = 12;
        //insert bbb; 

        //set Load_Status__c for Budget Planning by kevin shen
        
        Load_Status__c  load_status = new Load_Status__c();       
        load_status.Current_Fiscal_Year__c = '2013';
        load_status.Name = 'BBB_Month_Bill_Book_Cust__c Direct';
        load_status.Current_Fiscal_Month__c = 8;
        insert load_status;
            
            
        BBB_Month_Bill_Book_Cust__c bbbmb = new BBB_Month_Bill_Book_Cust__c();
        bbbmb.Customer__c = acc.Id;
        bbbmb.fiscal_Year__c = '2012';
        insert new List<BBB_Month_Bill_Book_Cust__c> {bbb,bbbmb};
        
        insert new Budget_Rate__c(CurrencyIsoCode = 'USD',Rate__c=60);
         
        
        ClsBudgetPlanningUtil cls = new ClsBudgetPlanningUtil();
        
        
            
        //Map<String, ClsAnnualBudgetPlanStructure> map_accId_budgetPlanStructures = new Map<String, ClsAnnualBudgetPlanStructure>();
        //ClsAnnualBudgetPlanStructure budgetPlanStructure = new ClsAnnualBudgetPlanStructure(acc.Id);
        ClsBudgetPlanningUtil.setBBBMonthlyValuesByBudgets(new List<Budget__c> {bg,bg1});
        system.assert(true);
        Test.stopTest();
        }
    }
    
    static testMethod void testTypeCMA() {
         ClsTestCustomSettingHelper.getApex_Helper_Settings();
         ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
     	Test.startTest();
     	ClsSharingUtil.TriggerRecursionDefense = true;
        //ClsOppyPartUtil.needCheckAlloc = false; 
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
        u.Te_Network_Id__c = 'te-00014';
        u.Username = 'az@testCompany1233423.com1';
        insert u;
        
        system.runAs(u){
        RecordType rt = ClsTestHelp.createTestRecordType8();  //detail.RecordType.DeveloperName = 'CIS_Account'
        
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.Individually_Planned__c = true;
        acc2.Name = 'ohxxsx';
        acc2.SALES_TERRITORY_CDE__c = 'A007357';
        insert acc2;
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt.Id;
        acc.SALES_TERRITORY_CDE__c = 'A007357';
        acc.Individually_Planned__c = true;
        acc.Account_Manager__c = u.Id;
        acc.Plan_Group_Account__c = acc2.Id;
        insert acc; 
            
        Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
        sh.Level_7_Territory_Code__c = 'A007357';
        insert sh;
        
        Budget__c bg = new Budget__c();
        bg.Year__c = '2012';
        bg.Territory__c = sh.Id;
        bg.Total_Direct_Budget_TBR_NY__c = 11;
        bg.Total_POS_Budget_TBR_NY__c = 11;
        bg.Total_CMA_Budget_TBR_NY__c = 11;
        bg.Total_Budget_TBR_NY__c = 12;
        //insert bg;
        Budget__c bg1 = new Budget__c();
        bg1.Year__c = '2012';
        bg1.Status__c = 'Draft';
        bg1.Territory__c = sh.Id;
        bg1.Total_Direct_Budget_TBR_NY__c = 11;
        bg1.Total_POS_Budget_TBR_NY__c = 11;
        bg1.Total_CMA_Budget_TBR_NY__c = 11;
        bg1.Total_Budget_TBR_NY__c = 12;
            insert new List<Budget__c> {bg,bg1};
        
        Budget_Detail__c bd = ClsTestHelp.createTestBudgetDetail();       
        bd.Account__c = acc.Id;
        bd.Parent_Account__c = acc2.Id;
        bd.Budget__c = bg.Id;
        bd.Type__c = 'CMA';
        insert bd;
            
            
       Budget_Detail__c bd1 = ClsTestHelp.createTestBudgetDetail();
        //bd1.Account_Territory_Code__c = 'A007357';        
        bd1.Account__c = acc.Id;
        bd1.Parent_Account__c = acc2.Id;
        bd1.Budget__c = bg1.Id;
        bd1.Type__c = 'CMA';
        insert bd1;
            
            
            
            
        
        bg = [Select Territory__c,ownerId, Territory_Code__c,Year__c, Total_Direct_Budget_TBR_NY__c, Total_POS_Budget_TBR_NY__c, Total_CMA_Budget_TBR_NY__c, Total_Budget_TBR_NY__c, Territory__r.Level_7_Territory_Code__c from Budget__c where Id =: bg.Id];
        bd = [select Id, RecordType.DeveloperName, Budget__c,
													Account__r.Account_Combined_Data__c, Account__c, Account__r.Name,
													Parent_Account__c, Parent_Account__r.Account_Combined_Data__c, Parent_Account__r.Name, 
													Adjusted_Business__c, Adjustment__c, Backlog__c, Billings_CYRR__c, 
													Billings_CYTD__c, Billings_LY__c, Calculated_Budget__c, Comments__c, 
													Forecast_CY__c, Manager_Final_Budget__c, Manager_Total_Budget__c, 
													Market_Growth__c, Obsoletion_EOL__c, Opportunities50_50__c, 
													Opportunities_Commit__c, Opportunities_Likely__c, Opportunities_Pipeline__c, 
													Opportunities_Weak__c, Opportunities_Won__c, Price_Change__c, Price_Increase__c, 
													Run_Rate_Business__c, TAM_DTAM__c, Total_Budget__c, Transfer_In__c, Transfer_Out__c, 
													Type__c, Account_Territory_Code__c, Budget_Year__c, Business_Transfers__c, Growth__c, Budget_TBR_NY__c from Budget_Detail__c where id =: bd.Id];		
        bg1 = [Select Territory__c, Status__c, Year__c, ownerId,Territory_Code__c,Total_Direct_Budget_TBR_NY__c, Total_POS_Budget_TBR_NY__c, Total_CMA_Budget_TBR_NY__c, Total_Budget_TBR_NY__c, Territory__r.Level_7_Territory_Code__c from Budget__c where Id =: bg.Id];
        BBB_Month_Bill_Book_Cust__c bbb = new BBB_Month_Bill_Book_Cust__c();
        bbb.Customer__c = acc.Id;
        bbb.Fiscal_Year__c = '2012';
        bbb.Bill_Type__c = 'CMA';
        bbb.Budget_Direct__c = 1;
        bbb.Budget_POS__c = 2;
        bbb.Budget_CMA__c = 3;
        bbb.Budget_TBR_NY__c = 12;
        //insert bbb; 

        //set Load_Status__c for Budget Planning by kevin shen
        
        Load_Status__c  load_status = new Load_Status__c();       
        load_status.Current_Fiscal_Year__c = '2013';
        load_status.Name = 'BBB_Month_Bill_Book_Cust__c Indirect';
        load_status.Current_Fiscal_Month__c = 8;
        insert load_status;
            
            
        BBB_Month_Bill_Book_Cust__c bbbmb = new BBB_Month_Bill_Book_Cust__c();
        bbbmb.Customer__c = acc.Id;
        bbbmb.fiscal_Year__c = '2012';
        insert new List<BBB_Month_Bill_Book_Cust__c> {bbb,bbbmb};
        
        insert new Budget_Rate__c(CurrencyIsoCode = 'USD',Rate__c=60);
         
        Id uId = UserInfo.getUserId();
        String territory = sh.Id;
        String year = '2012';
        
        Set<String> set_years = new Set<String>();
        set_years.add('2012');
        
        Set<String> set_territory = new Set<String>();
        set_territory.add(territory);
        
        List<String> list_accIds = new List<String>();
        list_accIds.add(acc.Id);
 
        Map<String, ClsAnnualBudgetPlanStructure> map_accId_budgetPlanStructures = new Map<String, ClsAnnualBudgetPlanStructure>();
        ClsAnnualBudgetPlanStructure budgetPlanStructure = new ClsAnnualBudgetPlanStructure(acc.Id);
        map_accId_budgetPlanStructures.put(acc.Id, budgetPlanStructure);
        map_accId_budgetPlanStructures.put(String.valueOf(acc2.Id).substring(0,15), budgetPlanStructure);
        
		ClsBudgetPlanningUtil.buildBudgetStructure(map_accId_budgetPlanStructures, bg, budgetPlanStructure, budgetPlanStructure);
        ClsBudgetPlanningUtil.getCurrentFiscalYear();
        
        ClsBudgetPlanningUtil.FilterYears(uId, territory, set_years);
        ClsBudgetPlanningUtil.filterTerritory(uId, year, set_territory);
        ClsBudgetPlanningUtil.getBudgetPlanById(bg.Id);
        ClsBudgetPlanningUtil.getAllFiscalMonthDateRange();
        ClsBudgetPlanningUtil.salesPeriodDate('2012',11);
    
        ClsBudgetPlanningUtil.calBudgetPlanningSalesPeriodDate('2013');            
        load_status.Current_Fiscal_Year__c = '2012';
        update load_status;      
        ClsBudgetPlanningUtil.getLoadStatusByYear('2012');        
            
        ClsBudgetPlanningUtil.calBudgetRate();

        ClsBudgetPlanningUtil.getFiscalMonthByDate(date.newInstance(2012, 7, 7),'2012');
        
        map<String, map<Integer, BBB_Month_Bill_Book_Cust__c>> map_BBBMonthly = new map<String, map<Integer, BBB_Month_Bill_Book_Cust__c>>();
        map<Integer, BBB_Month_Bill_Book_Cust__c> map_bbb = new map<Integer, BBB_Month_Bill_Book_Cust__c>();
        map_bbb.put(2012,bbb);
        map_BBBMonthly.put('Direct',map_bbb);

        map<String,Decimal> map_year_Rate = new map<String,Decimal>();
        map_year_Rate.put('2012',12);
        
        map<String, map<Integer, Decimal>> map_billType_monthRate = new map<String, map<Integer, Decimal>>();
        map_billType_monthRate.put('Direct', new map<Integer, Decimal>());
        map_billType_monthRate.put('POS', new map<Integer, Decimal>());
        map_billType_monthRate.put('CMA', new map<Integer, Decimal>());
        map_billType_monthRate.get('Direct').put(1, 1);
        map_billType_monthRate.get('POS').put(1, 1);
        map_billType_monthRate.get('CMA').put(1, 1);
        
        ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem item = new ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem(acc.Id, 'test', 'EUR');
        item.TotalBudget4Direct = 1000;
        item.TotalBudget4POS = 1000;
        item.TotalBudget4CMA = 1000;
        item.ForecastCY = 1000;
        
        ClsBudgetPlanningUtil.calMonthRate(1, 1, 1);
        
        list<Id> list_individualAccIds = new list<Id>();
        list_individualAccIds.add(acc2.Id);
        ClsBudgetPlanningUtil.getDefaultYearList(2012);
        ClsAnnualBudgetPlanStructure.BudgetPlanningItem clsBu = new ClsAnnualBudgetPlanStructure.BudgetPlanningItem();
        clsBu.TotalBudget = 1;
        clsBu.BillingsLY = 1;
        clsBu.BillingsYTDCY = 1;
        clsBu.BillingsRRCY = 1;
        clsBu.Backlog = 1;
        clsBu.EstimatedFinalCY = 1;
        clsBu.ObsoletionEOL = 1;
        clsBu.TransferOut = 1;
        clsBu.TransferIn = 1;
        clsBu.TAMDTAM = 1;
        clsBu.RepeatBusiness = 1;
        clsBu.CustomerGrowth = 1;
        clsBu.MarketPriceChange = 1;
        clsBu.PriceIncrease = 1;
        clsBu.AdjRepeatBusiness = 1;
        clsBu.OpportunitiesWon = 1;
        clsBu.Forecast = 1;
        clsBu.OpportunitiesCommit = 1;
        clsBu.OpportunitiesLikely = 1;
        clsBu.Opportunities5050 = 1;
        clsBu.OpportunitiesWeak = 1;
        clsBu.Adjustment = 1;
        clsBu.Growth = 1;
        clsBu.TotalAccountBudget = 1;
        clsBu.TotalOtherBudget = 1;
        
        ClsAnnualBudgetPlanStructure.BudgetPlanningAccountItem accItem = new ClsAnnualBudgetPlanStructure.BudgetPlanningAccountItem();
            
        ClsBudgetPlanningUtil.calRunRateBusiValue(clsBu);
        ClsBudgetPlanningUtil.calAdjustedBusiValue(clsBu);
        List<Budget_Detail__c> list_budgetDetails = new List<Budget_Detail__c>();
        list_budgetDetails.add(bd);
        
        ClsBudgetPlanningUtil cls = new ClsBudgetPlanningUtil();
        
        ClsBudgetPlanningUtil.determineApprover(bg);
        
        ClsBudgetPlanningUtil.createBudgetDetailFromStructureDetail(bg.Id, 'Other', acc.Id, clsBu, accItem, rt.Id, 1); 
        
        ClsBudgetPlanningUtil.getFiscalMonth(date.today());
        
        List<Account> list_accounts = new List<Account>();
        list_accounts.add(acc2);
        list_accounts.add(acc);
         
        Map<Id, Boolean> map_parentId_planned = new Map<Id, Boolean>();
        map_parentId_planned.put(acc.Id,true);
        
        List<BBB_Month_Bill_Book_Cust__c> list_bbbM2Recal = new List<BBB_Month_Bill_Book_Cust__c>();
        list_bbbM2Recal.add(bbb);
        
        ClsBudgetPlanningUtil.updatePlanGroupId(list_accounts, map_parentId_planned, 'trigger', 'delete');
        ClsBudgetPlanningUtil.updatePlanGroupId(list_accounts, map_parentId_planned, 'trigger', 'update');
        ClsBudgetPlanningUtil.updatePlanGroupId(list_accounts, map_parentId_planned, 'batch', 'update');  
        ClsBudgetPlanningUtil.allocatedOpportunityValues('Won', clsBu, accItem, 1);    
        ClsBudgetPlanningUtil.allocatedOpportunityValues('Weak', clsBu, accItem, 1); 
        ClsBudgetPlanningUtil.allocatedOpportunityValues('Commit', clsBu, accItem, 1); 
        ClsBudgetPlanningUtil.allocatedOpportunityValues('Likely', clsBu, accItem, 1); 
        ClsBudgetPlanningUtil.allocatedOpportunityValues('50/50', clsBu, accItem, 1);   
        map<String, map<String,Budget_Detail__c>> map_existingDetails = new map<String, map<String,Budget_Detail__c>>();
  
        ClsBudgetPlanningUtil.fillOldBudgetDetailsIntoStructure('2012', list_accIds, bg, 'A007357', map_existingDetails);
                      
        ClsBudgetPlanningUtil.fillOldBudgetDetailsIntoStructure('2012', list_accIds, bg1, 'A007357', map_existingDetails);
        
            
        //Map<String, ClsAnnualBudgetPlanStructure> map_accId_budgetPlanStructures = new Map<String, ClsAnnualBudgetPlanStructure>();
        Map<String, ClsAnnualBudgetPlanStructure> map_accParId_budgetPlanStructures = new Map<String, ClsAnnualBudgetPlanStructure>();
        //ClsAnnualBudgetPlanStructure budgetPlanStructure = new ClsAnnualBudgetPlanStructure(acc.Id);
        map_accId_budgetPlanStructures.put(String.valueOf(acc.Id).substring(0,15),budgetPlanStructure);
        map_accId_budgetPlanStructures.put(acc.Id, budgetPlanStructure);
        map_accId_budgetPlanStructures.put(acc2.Id, budgetPlanStructure);
        map_accParId_budgetPlanStructures.put(String.valueOf(acc2.Id).substring(0,15),budgetPlanStructure);
        map_accParId_budgetPlanStructures.put(acc2.Id, budgetPlanStructure);
        map_accParId_budgetPlanStructures.put(acc.Id, budgetPlanStructure);
        ClsBudgetPlanningUtil.buildBudgetByAccountId('2012', '2012', map_accId_budgetPlanStructures, list_accIds, bg, budgetPlanStructure, 'A007357', map_existingDetails);    
        ClsBudgetPlanningUtil.buildBudgetByAccountId('2014', '2013', map_accId_budgetPlanStructures, list_accIds, bg, budgetPlanStructure, 'A007357', map_existingDetails);  
        ClsBudgetPlanningUtil.buildBudgetByAccountId('2014', '2013', map_accParId_budgetPlanStructures, list_accIds, bg, budgetPlanStructure, 'A007357', map_existingDetails); 
        ClsBudgetPlanningUtil.transformIsoCode(12, 'USD', 'EUR');
        ClsBudgetPlanningUtil.setBBBMonthlyValuesByBudgets(new List<Budget__c> {bg,bg1});
        /*map<Id, map<String, Budget__c>> map_accId_year_budget = new map<Id, map<String, Budget__c>>();
        map_accId_year_budget.put(acc.id, new map<String, Budget__c>());
        map_accId_year_budget.get(acc.id).put('2012',bg1);
        ClsBudgetPlanningUtil.processUpdateBBBMonthlyVlaues(map_accId_year_budget,new Set<Id> {acc.Id}, new Set<String> {'2012'});  */  
        system.assert(true);
        Test.stopTest();
        }
    }
    }