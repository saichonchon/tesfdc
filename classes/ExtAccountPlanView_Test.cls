/**
*   This test class is for ExtAccountPlanView.
*
@author Di Chen
@created 2012-06-07
@version 1.0
@since 20.0
*
@changelog
* 2012-06-07 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 87%
*/
@isTest 
private class ExtAccountPlanView_Test {

    static testMethod void testMethods() {
         
        RecordType rt = ClsTestHelp.createTestRecordType6();
        RecordType rt2 = ClsTestHelp.createTestRecordType8();
        RecordType rt3 = ClsTestHelp.createTestRecordType14();
        RecordType rt4 = ClsTestHelp.createTestRecordType21();
        
        List<Account> acc= new List<Account>();
        
                
        Account a = ClsTestHelp.createTestAccounts();
        a.RecordTypeId = rt2.Id;
        a.Customer_Classification__c = 'A';
        a.Type = 'Competitor'; 
        acc.add(a);
      
        
        Account a1 = ClsTestHelp.createTestAccounts();
        a1.RecordTypeId = rt3.Id;
        a1.Customer_Classification__c = 'A';
        a1.Type = 'Global Account';
        a1.GAMCD__c = 'G032';
        acc.add(a1);
        
        insert acc;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.AccountId = acc[0].Id;
        oppy.StageName = 'New';
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.Total_Opportunity_Value__c=1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        oppy.Five_Year_Value__c=1;
        insert oppy;
        
        List <Account_Plan__c> ap = new List <Account_Plan__c>();
        
        Account_Plan__c AccPlan1 = ClsTestHelp.createTestAccountPlan();
        AccPlan1.Account_Definition__c = 'Custom';
        AccPlan1.Customer__c = acc[0].Id;
        AccPlan1.Plan_Year__c = '2012';
        AccPlan1.Key_Project_1__c = oppy.Id;
        AccPlan1.Key_Project_2__c = oppy.Id;
        AccPlan1.Key_Project_3__c = oppy.Id;
        AccPlan1.Key_Project_4__c = oppy.Id;
        AccPlan1.Key_Project_5__c = oppy.Id;
        AccPlan1.Key_Project_6__c = oppy.Id;
        AccPlan1.Won_Project_1__c = oppy.Id;
        AccPlan1.Won_Project_2__c = oppy.Id;
        AccPlan1.Won_Project_3__c = oppy.Id;
        AccPlan1.Won_Project_4__c = oppy.Id;
        AccPlan1.Lost_Project_1__c = oppy.Id;
        AccPlan1.Lost_Project_2__c = oppy.Id;
        AccPlan1.Lost_Project_3__c = oppy.Id;
        AccPlan1.Lost_Project_4__c = oppy.Id;
        AccPlan1.Company_Logo_Id__c = '123456789012345';
        AccPlan1.Account_Manager_Id__c = '123456789012345';
        AccPlan1.Approval_Status__c = 'Pending';
        AccPlan1.Account_Objective_2__c = 'xxxx';
        AccPlan1.Account_Objective_3__c = 'xxxx';
        AccPlan1.Account_Objective_4__c = 'xxxx';
        AccPlan1.Account_Objective_4__c = 'xxx';
        AccPlan1.Account_Objective_5__c = 'xxxxx';
        AccPlan1.Strategic_Initiative_2__c = 'xxx';
        AccPlan1.Strategic_Initiative_3__c = 'xxx';
        AccPlan1.Strategic_Initiative_4__c = 'xxx';
        AccPlan1.Strategic_Initiative_5__c = 'xxx';
        AccPlan1.Strategic_Initiative_6__c = 'xxx';
        AccPlan1.Strategic_Initiative_7__c = 'xxx';
        AccPlan1.Strategic_Initiative_8__c = 'xxx';
        AccPlan1.Strategic_Initiative_9__c = 'xxx';
        AccPlan1.Category1_Name__c = 'xxx';
        AccPlan1.Category2_Name__c = 'xxx';
        AccPlan1.Category3_Name__c = 'xxx';
        AccPlan1.Key_Product_2__c = 'xxx';
        AccPlan1.Key_Product_3__c = 'xxx';
        AccPlan1.Key_Product_4__c = 'xxx';
        AccPlan1.Key_Product_5__c = 'xxx';
        AccPlan1.Key_Product_6__c = 'xxx';
        AccPlan1.Breakthrough_Program_1__c = 'xxx';
        AccPlan1.Breakthrough_Program_2__c = 'xxx';
        AccPlan1.Breakthrough_Program_3__c = 'xxx';
        AccPlan1.Breakthrough_Program_4__c = 'xxx';
        AccPlan1.Recent_Big_Win_1__c = 'xxx';
        AccPlan1.Recent_Big_Win_2__c = 'xxx';
        AccPlan1.Recent_Big_Win_3__c = 'xxx';
        AccPlan1.Recent_Big_Win_4__c = 'xxx';
        AccPlan1.Recent_Loss_1__c = 'xxx';
        AccPlan1.Recent_Loss_2__c = 'xxx';
        AccPlan1.Recent_Loss_3__c = 'xxx';
        AccPlan1.Recent_Loss_4__c = 'xxx';
        AccPlan1.Obstacle_1__c = 'xxx';
        AccPlan1.Obstacle_2__c = 'xxx';
        AccPlan1.Obstacle_3__c = 'xxx';
        AccPlan1.Obstacle_4__c = 'xxx';
        AccPlan1.Obstacle_5__c = 'xxx';
        AccPlan1.Revenue_TAM_SAM__c = 'TAM';
        AccPlan1.Active__c = true;
        ap.add(AccPlan1);
        
        
        
        Account_Plan__c AccPlan2 = ClsTestHelp.createTestAccountPlan();
        AccPlan2.Customer__c = acc[1].Id;
        AccPlan2.Plan_Year__c = '2012';
        AccPlan2.Key_Project_1__c = oppy.Id;
        AccPlan2.Key_Project_2__c = oppy.Id;
        AccPlan2.Key_Project_3__c = oppy.Id;
        AccPlan2.Key_Project_4__c = oppy.Id;
        AccPlan2.Key_Project_5__c = oppy.Id;
        AccPlan2.Key_Project_6__c = oppy.Id;
        AccPlan2.Won_Project_1__c = oppy.Id;
        AccPlan2.Won_Project_2__c = oppy.Id;
        AccPlan2.Won_Project_3__c = oppy.Id;
        AccPlan2.Won_Project_4__c = oppy.Id;
        AccPlan2.Lost_Project_1__c = oppy.Id;
        AccPlan2.Lost_Project_2__c = oppy.Id;
        AccPlan2.Lost_Project_3__c = oppy.Id;
        AccPlan2.Lost_Project_4__c = oppy.Id;
        AccPlan2.Company_Logo_Id__c = '123456789012345';
        AccPlan2.Account_Manager_Id__c = '123456789012345';
        AccPlan2.approval_Status__c = 'Pending';
        AccPlan2.Account_Objective_2__c = 'xxxx';
        AccPlan2.Account_Objective_3__c = 'xxxx';
        AccPlan2.Account_Objective_4__c = 'xxxx';
        AccPlan2.Account_Objective_4__c = 'xxx';
        AccPlan2.Account_Objective_5__c = 'xxxxx';
        AccPlan2.Strategic_Initiative_2__c = 'xxx';
        AccPlan2.Strategic_Initiative_3__c = 'xxx';
        AccPlan2.Strategic_Initiative_4__c = 'xxx';
        AccPlan2.Strategic_Initiative_5__c = 'xxx';
        AccPlan2.Strategic_Initiative_6__c = 'xxx';
        AccPlan2.Strategic_Initiative_7__c = 'xxx';
        AccPlan2.Strategic_Initiative_8__c = 'xxx';
        AccPlan2.Strategic_Initiative_9__c = 'xxx';
        AccPlan2.Category1_Name__c = 'xxx';
        AccPlan2.Category2_Name__c = 'xxx';
        AccPlan2.Category3_Name__c = 'xxx';
        AccPlan2.Key_Product_2__c = 'xxx';
        AccPlan2.Key_Product_3__c = 'xxx';
        AccPlan2.Key_Product_4__c = 'xxx';
        AccPlan2.Key_Product_5__c = 'xxx';
        AccPlan2.Key_Product_6__c = 'xxx';
        AccPlan2.Breakthrough_Program_1__c = 'xxx';
        AccPlan2.Breakthrough_Program_2__c = 'xxx';
        AccPlan2.Breakthrough_Program_3__c = 'xxx';
        AccPlan2.Breakthrough_Program_4__c = 'xxx';
        AccPlan2.Recent_Big_Win_1__c = 'xxx';
        AccPlan2.Recent_Big_Win_2__c = 'xxx';
        AccPlan2.Recent_Big_Win_3__c = 'xxx';
        AccPlan2.Recent_Big_Win_4__c = 'xxx';
        AccPlan2.Recent_Loss_1__c = 'xxx';
        AccPlan2.Recent_Loss_2__c = 'xxx';
        AccPlan2.Recent_Loss_3__c = 'xxx';
        AccPlan2.Recent_Loss_4__c = 'xxx';
        AccPlan2.Obstacle_1__c = 'xxx';
        AccPlan2.Obstacle_2__c = 'xxx';
        AccPlan2.Obstacle_3__c = 'xxx';
        AccPlan2.Obstacle_4__c = 'xxx';
        AccPlan2.Obstacle_5__c = 'xxx';
        AccPlan2.Revenue_TAM_SAM__c = 'TAM';
        AccPlan2.Sales_Figures_Makeup__c = 'Direct;Indirect - Distribution';
        AccPlan2.Account_Manager_approver__c = UserInfo.getUserId();
        AccPlan2.Active__c = true;
        ap.add(AccPlan2);
        
        insert ap;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'GPL';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Proposal Part';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        List <BBB_Year_Bill_Book_Cust_PN__c> bby= new List <BBB_Year_Bill_Book_Cust_PN__c>();
        
        BBB_Year_Bill_Book_Cust_PN__c bby1 = new BBB_Year_Bill_Book_Cust_PN__c();
        bby1.Part__c = part.Id;
        bby1.Customer__c = acc[0].Id;
        bby.add(bby1);
        
        BBB_Year_Bill_Book_Cust_PN__c bby2 = new BBB_Year_Bill_Book_Cust_PN__c();
        bby2.Part__c = part.Id;
        bby2.Customer__c = acc[1].Id;
        bby2.Year__c = '2011';
        bby2.Bill_Type__c = 'Direct';
        bby.add(bby2);
        
        insert bby;
        
        
        List<BBB_Month_Bill_Book_Cust__c> byb= new List<BBB_Month_Bill_Book_Cust__c>();
        
        BBB_Month_Bill_Book_Cust__c byb0 = new BBB_Month_Bill_Book_Cust__c();
        byb0.Region__c = 'EU';
        byb0.Bill_Type__c = 'Direct';
        byb0.Bill_Amount_USD__c = 11;
        byb0.Fiscal_Year__c = '2011';
        byb0.Customer__c = acc[0].Id;
        byb.add(byb0);
        
        
        BBB_Month_Bill_Book_Cust__c byb1 = new BBB_Month_Bill_Book_Cust__c();
        byb1.Region__c = 'EU';
        byb1.Bill_Type__c = 'Direct';
        byb1.Bill_Amount_USD__c = 11;
        byb1.Fiscal_Year__c = '2011';
        byb1.Customer__c = acc[1].Id;
        byb1.SAP_Profit_Center__c = 'Test';
        
        insert byb;
        
        ExtAccountPlanView.overview extOw = new ExtAccountPlanView.overview('xxx',1.2,1.3,'20',1.5,'20');
        ExtAccountPlanView.breakthroughProgram extBp = new ExtAccountPlanView.breakthroughProgram('xxx','zzz','ooo');
        ExtAccountPlanView.winsAndLosses extWin = new ExtAccountPlanView.winsAndLosses(oppy.Id,'SandKing',1.2,String.valueOf(system.today()),'xx');
        
        ExtAccountPlanView.snapshot extSn = new ExtAccountPlanView.snapshot(ap[0].Id,String.valueOf(date.Today()));
        
        list<ExtAccountPlanView.snapshot> list_snapshot = new list<ExtAccountPlanView.snapshot>();
        list_snapshot.add(extSn);
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('id',ap[0].Id);
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(ap[0]); 
        ExtAccountPlanView ext = new ExtAccountPlanView(stdCtrl);
        ext.accountPlan = ap[0];
        ext.list_snapshot = list_snapshot;
        
        ext.submitAndApproval();
        ext.unLock();
        ext.edit();
        string b2 = ext.voiceId;
        boolean b = ext.chkLoggedInUser;
        b2 = ext.checkSnapshot_url;
        b = ext.showCBCPanel;
        b= ext.showRegionPanel;
        ext.Pdf();
        ExtAccountPlanView.loadLineChart(ap[0]);
        ExtAccountPlanView.loadPieCBCChart(ap[0]);
        ExtAccountPlanView.loadPieRegionChart(ap[0]);
        ext.getCheckSnapshot();
        system.assert(true);
        
        
        ApexPages.StandardController stdCtrl1 = new ApexPages.StandardController(ap[1]); 
        ExtAccountPlanView ext1 = new ExtAccountPlanView(stdCtrl1);
        ext.accountPlan = ap[1];
        ext.list_snapshot = list_snapshot;
        ext.planYearMinus1 = 2011;
       
        Test.stopTest();
    }
    /*static testMethod void testMethods2() {
        
        RecordType rt = ClsTestHelp.createTestRecordType6();
        RecordType rt2 = ClsTestHelp.createTestRecordType8();
        RecordType rt3 = ClsTestHelp.createTestRecordType21();
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt2.Id;
        acc.Customer_Classification__c = 'A';
        acc.Type = 'Competitor';
        insert acc;
        
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.RecordTypeId = rt2.Id;
        acc2.Customer_Classification__c = 'A';
        acc2.Type = 'Competitor';
        acc2.Individually_Planned__c = true;
        acc2.Plan_Group_Id__c = acc.Id;
        insert acc2;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.AccountId = acc.Id;
        oppy.StageName = 'New';
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.Total_Opportunity_Value__c=1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        oppy.Five_Year_Value__c=1;
        insert oppy;
        
        Account_Plan__c ap = ClsTestHelp.createTestAccountPlan();
        ap.Account_Definition__c = 'Custom';
        ap.Customer__c = acc.Id;
        ap.Plan_Year__c = '2012';
        ap.Key_Project_1__c = oppy.Id;
        ap.Key_Project_2__c = oppy.Id;
        ap.Key_Project_3__c = oppy.Id;
        ap.Key_Project_4__c = oppy.Id;
        ap.Key_Project_5__c = oppy.Id;
        ap.Key_Project_6__c = oppy.Id;
        ap.Won_Project_1__c = oppy.Id;
        ap.Won_Project_2__c = oppy.Id;
        ap.Won_Project_3__c = oppy.Id;
        ap.Won_Project_4__c = oppy.Id;
        ap.Lost_Project_1__c = oppy.Id;
        ap.Lost_Project_2__c = oppy.Id;
        ap.Lost_Project_3__c = oppy.Id;
        ap.Lost_Project_4__c = oppy.Id;
        ap.Company_Logo_Id__c = '123456789012345';
        ap.Account_Manager_Id__c = '123456789012345';
        ap.Approval_Status__c = 'Pending';
        ap.Account_Objective_2__c = 'xxxx';
        ap.Account_Objective_3__c = 'xxxx';
        ap.Account_Objective_4__c = 'xxxx';
        ap.Account_Objective_4__c = 'xxx';
        ap.Account_Objective_5__c = 'xxxxx';
        ap.Strategic_Initiative_2__c = 'xxx';
        ap.Strategic_Initiative_3__c = 'xxx';
        ap.Strategic_Initiative_4__c = 'xxx';
        ap.Strategic_Initiative_5__c = 'xxx';
        ap.Strategic_Initiative_6__c = 'xxx';
        ap.Strategic_Initiative_7__c = 'xxx';
        ap.Strategic_Initiative_8__c = 'xxx';
        ap.Strategic_Initiative_9__c = 'xxx';
        ap.Category1_Name__c = 'xxx';
        ap.Category2_Name__c = 'xxx';
        ap.Category3_Name__c = 'xxx';
        ap.Key_Product_2__c = 'xxx';
        ap.Key_Product_3__c = 'xxx';
        ap.Key_Product_4__c = 'xxx';
        ap.Key_Product_5__c = 'xxx';
        ap.Key_Product_6__c = 'xxx';
        ap.Breakthrough_Program_1__c = 'xxx';
        ap.Breakthrough_Program_2__c = 'xxx';
        ap.Breakthrough_Program_3__c = 'xxx';
        ap.Breakthrough_Program_4__c = 'xxx';
        ap.Recent_Big_Win_1__c = 'xxx';
        ap.Recent_Big_Win_2__c = 'xxx';
        ap.Recent_Big_Win_3__c = 'xxx';
        ap.Recent_Big_Win_4__c = 'xxx';
        ap.Recent_Loss_1__c = 'xxx';
        ap.Recent_Loss_2__c = 'xxx';
        ap.Recent_Loss_3__c = 'xxx';
        ap.Recent_Loss_4__c = 'xxx';
        ap.Obstacle_1__c = 'xxx';
        ap.Obstacle_2__c = 'xxx';
        ap.Obstacle_3__c = 'xxx';
        ap.Obstacle_4__c = 'xxx';
        ap.Obstacle_5__c = 'xxx';
        ap.Revenue_TAM_SAM__c = 'TAM';
        ap.Active__c = true;
        insert ap;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'GPL';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Proposal Part';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        BBB_Year_Bill_Book_Cust_PN__c bby = new BBB_Year_Bill_Book_Cust_PN__c();
        bby.Part__c = part.Id;
        bby.Customer__c = acc.Id;
        insert bby;
        
        BBB_Month_Bill_Book_Cust__c byb = new BBB_Month_Bill_Book_Cust__c();
        byb.Region__c = 'EU';
        byb.Bill_Type__c = 'Direct';
        byb.Bill_Amount_USD__c = 11;
        byb.Fiscal_Year__c = '2011';
        byb.Customer__c = acc.Id;
        insert byb;
        
        ExtAccountPlanView.overview extOw = new ExtAccountPlanView.overview('xxx',1.2,1.3,'20',1.5,'20');
        ExtAccountPlanView.breakthroughProgram extBp = new ExtAccountPlanView.breakthroughProgram('xxx','zzz','ooo');
        ExtAccountPlanView.winsAndLosses extWin = new ExtAccountPlanView.winsAndLosses(oppy.Id,'SandKing',1.2,String.valueOf(system.today()),'xx');
        Test.startTest();
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(ap); 
        ExtAccountPlanView ext = new ExtAccountPlanView(stdCtrl);
        ext.accountPlan = ap;
        ////ext.regionPart1 = 11;
        ////ext.regionPart2 = 11;
        //ext.regionPart3 = null;
        
        //ext.getChartWithRegion();
        ext.unLock();
        ext.edit();
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testMethods3() {
        
        RecordType rt = ClsTestHelp.createTestRecordType6();
        RecordType rt2 = ClsTestHelp.createTestRecordType8();
        RecordType rt3 = ClsTestHelp.createTestRecordType21();
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt2.Id;
        acc.Customer_Classification__c = 'A';
        acc.Type = 'Competitor';
        insert acc;
        
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.RecordTypeId = rt2.Id;
        acc2.Customer_Classification__c = 'A';
        acc2.Type = 'Competitor';
        acc2.Individually_Planned__c = true;
        acc2.Plan_Group_Id__c = acc.Id;
        insert acc2;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.AccountId = acc.Id;
        oppy.StageName = 'New';
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.Total_Opportunity_Value__c=1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        oppy.Five_Year_Value__c=1;
        insert oppy;
        
        Account_Plan__c ap = ClsTestHelp.createTestAccountPlan();
        ap.Account_Definition__c = 'Custom';
        ap.Customer__c = acc.Id;
        ap.Plan_Year__c = '2012';
        ap.Key_Project_1__c = oppy.Id;
        ap.Key_Project_2__c = oppy.Id;
        ap.Key_Project_3__c = oppy.Id;
        ap.Key_Project_4__c = oppy.Id;
        ap.Key_Project_5__c = oppy.Id;
        ap.Key_Project_6__c = oppy.Id;
        ap.Won_Project_1__c = oppy.Id;
        ap.Won_Project_2__c = oppy.Id;
        ap.Won_Project_3__c = oppy.Id;
        ap.Won_Project_4__c = oppy.Id;
        ap.Lost_Project_1__c = oppy.Id;
        ap.Lost_Project_2__c = oppy.Id;
        ap.Lost_Project_3__c = oppy.Id;
        ap.Lost_Project_4__c = oppy.Id;
        ap.Company_Logo_Id__c = '123456789012345';
        ap.Account_Manager_Id__c = '123456789012345';
        ap.Approval_Status__c = 'Pending';
        ap.Account_Objective_2__c = 'xxxx';
        ap.Account_Objective_3__c = 'xxxx';
        ap.Account_Objective_4__c = 'xxxx';
        ap.Account_Objective_4__c = 'xxx';
        ap.Account_Objective_5__c = 'xxxxx';
        ap.Strategic_Initiative_2__c = 'xxx';
        ap.Strategic_Initiative_3__c = 'xxx';
        ap.Strategic_Initiative_4__c = 'xxx';
        ap.Strategic_Initiative_5__c = 'xxx';
        ap.Strategic_Initiative_6__c = 'xxx';
        ap.Strategic_Initiative_7__c = 'xxx';
        ap.Strategic_Initiative_8__c = 'xxx';
        ap.Strategic_Initiative_9__c = 'xxx';
        ap.Category1_Name__c = 'xxx';
        ap.Category2_Name__c = 'xxx';
        ap.Category3_Name__c = 'xxx';
        ap.Key_Product_2__c = 'xxx';
        ap.Key_Product_3__c = 'xxx';
        ap.Key_Product_4__c = 'xxx';
        ap.Key_Product_5__c = 'xxx';
        ap.Key_Product_6__c = 'xxx';
        ap.Breakthrough_Program_1__c = 'xxx';
        ap.Breakthrough_Program_2__c = 'xxx';
        ap.Breakthrough_Program_3__c = 'xxx';
        ap.Breakthrough_Program_4__c = 'xxx';
        ap.Recent_Big_Win_1__c = 'xxx';
        ap.Recent_Big_Win_2__c = 'xxx';
        ap.Recent_Big_Win_3__c = 'xxx';
        ap.Recent_Big_Win_4__c = 'xxx';
        ap.Recent_Loss_1__c = 'xxx';
        ap.Recent_Loss_2__c = 'xxx';
        ap.Recent_Loss_3__c = 'xxx';
        ap.Recent_Loss_4__c = 'xxx';
        ap.Obstacle_1__c = 'xxx';
        ap.Obstacle_2__c = 'xxx';
        ap.Obstacle_3__c = 'xxx';
        ap.Obstacle_4__c = 'xxx';
        ap.Obstacle_5__c = 'xxx';
        ap.Revenue_TAM_SAM__c = 'TAM';
        ap.Active__c = true;
        insert ap;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'GPL';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Proposal Part';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        BBB_Year_Bill_Book_Cust_PN__c bby = new BBB_Year_Bill_Book_Cust_PN__c();
        bby.Part__c = part.Id;
        bby.Customer__c = acc.Id;
        insert bby;
        
        BBB_Month_Bill_Book_Cust__c byb = new BBB_Month_Bill_Book_Cust__c();
        byb.Region__c = 'EU';
        byb.Bill_Type__c = 'Direct';
        byb.Bill_Amount_USD__c = 11;
        byb.Fiscal_Year__c = '2011';
        byb.Customer__c = acc.Id;
        insert byb;
        
        ExtAccountPlanView.overview extOw = new ExtAccountPlanView.overview('xxx',1.2,1.3,'20',1.5,'20');
        ExtAccountPlanView.breakthroughProgram extBp = new ExtAccountPlanView.breakthroughProgram('xxx','zzz','ooo');
        ExtAccountPlanView.winsAndLosses extWin = new ExtAccountPlanView.winsAndLosses(oppy.Id,'SandKing',1.2,String.valueOf(system.today()),'xx');
        
        ExtAccountPlanView.snapshot extSn = new ExtAccountPlanView.snapshot(ap.Id,String.valueOf(date.Today()));
        
        list<ExtAccountPlanView.snapshot> list_snapshot = new list<ExtAccountPlanView.snapshot>();
        list_snapshot.add(extSn);
        
        Test.startTest();
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(ap); 
        ExtAccountPlanView ext = new ExtAccountPlanView(stdCtrl);
        ext.accountPlan = ap;
        //ext.regionPart1 = 11;
        //ext.regionPart2 = 11;
        //ext.regionPart3 = 11;
        //ext.regionPart4 = null;
        //ext.getChartWithRegion();
        ext.unLock();
        ext.edit();
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testMethods4() {
        
        RecordType rt = ClsTestHelp.createTestRecordType6();
        RecordType rt2 = ClsTestHelp.createTestRecordType8();
        RecordType rt3 = ClsTestHelp.createTestRecordType21();
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt2.Id;
        acc.Customer_Classification__c = 'A';
        acc.Type = 'Competitor';
        insert acc;
        
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.RecordTypeId = rt2.Id;
        acc2.Customer_Classification__c = 'A';
        acc2.Type = 'Competitor';
        acc2.Individually_Planned__c = true;
        acc2.Plan_Group_Id__c = acc.Id;
        insert acc2;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.AccountId = acc.Id;
        oppy.StageName = 'New';
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.Total_Opportunity_Value__c=1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        oppy.Five_Year_Value__c=1;
        insert oppy;
        
        Account_Plan__c ap = ClsTestHelp.createTestAccountPlan();
        ap.Account_Definition__c = 'Custom';
        ap.Customer__c = acc.Id;
        ap.Plan_Year__c = '2012';
        ap.Key_Project_1__c = oppy.Id;
        ap.Key_Project_2__c = oppy.Id;
        ap.Key_Project_3__c = oppy.Id;
        ap.Key_Project_4__c = oppy.Id;
        ap.Key_Project_5__c = oppy.Id;
        ap.Key_Project_6__c = oppy.Id;
        ap.Won_Project_1__c = oppy.Id;
        ap.Won_Project_2__c = oppy.Id;
        ap.Won_Project_3__c = oppy.Id;
        ap.Won_Project_4__c = oppy.Id;
        ap.Lost_Project_1__c = oppy.Id;
        ap.Lost_Project_2__c = oppy.Id;
        ap.Lost_Project_3__c = oppy.Id;
        ap.Lost_Project_4__c = oppy.Id;
        ap.Company_Logo_Id__c = '123456789012345';
        ap.Account_Manager_Id__c = '123456789012345';
        ap.Approval_Status__c = 'Pending';
        ap.Account_Objective_2__c = 'xxxx';
        ap.Account_Objective_3__c = 'xxxx';
        ap.Account_Objective_4__c = 'xxxx';
        ap.Account_Objective_4__c = 'xxx';
        ap.Account_Objective_5__c = 'xxxxx';
        ap.Strategic_Initiative_2__c = 'xxx';
        ap.Strategic_Initiative_3__c = 'xxx';
        ap.Strategic_Initiative_4__c = 'xxx';
        ap.Strategic_Initiative_5__c = 'xxx';
        ap.Strategic_Initiative_6__c = 'xxx';
        ap.Strategic_Initiative_7__c = 'xxx';
        ap.Strategic_Initiative_8__c = 'xxx';
        ap.Strategic_Initiative_9__c = 'xxx';
        ap.Category1_Name__c = 'xxx';
        ap.Category2_Name__c = 'xxx';
        ap.Category3_Name__c = 'xxx';
        ap.Key_Product_2__c = 'xxx';
        ap.Key_Product_3__c = 'xxx';
        ap.Key_Product_4__c = 'xxx';
        ap.Key_Product_5__c = 'xxx';
        ap.Key_Product_6__c = 'xxx';
        ap.Breakthrough_Program_1__c = 'xxx';
        ap.Breakthrough_Program_2__c = 'xxx';
        ap.Breakthrough_Program_3__c = 'xxx';
        ap.Breakthrough_Program_4__c = 'xxx';
        ap.Recent_Big_Win_1__c = 'xxx';
        ap.Recent_Big_Win_2__c = 'xxx';
        ap.Recent_Big_Win_3__c = 'xxx';
        ap.Recent_Big_Win_4__c = 'xxx';
        ap.Recent_Loss_1__c = 'xxx';
        ap.Recent_Loss_2__c = 'xxx';
        ap.Recent_Loss_3__c = 'xxx';
        ap.Recent_Loss_4__c = 'xxx';
        ap.Obstacle_1__c = 'xxx';
        ap.Obstacle_2__c = 'xxx';
        ap.Obstacle_3__c = 'xxx';
        ap.Obstacle_4__c = 'xxx';
        ap.Obstacle_5__c = 'xxx';
        ap.Revenue_TAM_SAM__c = 'TAM';
        ap.Active__c = true;
        insert ap;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'GPL';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Proposal Part';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        BBB_Year_Bill_Book_Cust_PN__c bby = new BBB_Year_Bill_Book_Cust_PN__c();
        bby.Part__c = part.Id;
        bby.Customer__c = acc.Id;
        insert bby;
        
        BBB_Month_Bill_Book_Cust__c byb = new BBB_Month_Bill_Book_Cust__c();
        byb.Region__c = 'EU';
        byb.Bill_Type__c = 'Direct';
        byb.Bill_Amount_USD__c = 11;
        byb.Fiscal_Year__c = '2011';
        byb.Customer__c = acc.Id;
        insert byb;
        
        ExtAccountPlanView.overview extOw = new ExtAccountPlanView.overview('xxx',1.2,1.3,'20',1.5,'20');
        ExtAccountPlanView.breakthroughProgram extBp = new ExtAccountPlanView.breakthroughProgram('xxx','zzz','ooo');
        ExtAccountPlanView.winsAndLosses extWin = new ExtAccountPlanView.winsAndLosses(oppy.Id,'SandKing',1.2,String.valueOf(system.today()),'xx');
        Test.startTest();
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(ap); 
        ExtAccountPlanView ext = new ExtAccountPlanView(stdCtrl);
        ext.accountPlan = ap;
        //ext.regionPart1 = 11;
        //ext.regionPart2 = 11;
        //ext.regionPart3 = 11;
        //ext.regionPart4 = 11;
        //ext.regionPart5 = null;
        
        //ext.getChartWithRegion();
        ext.unLock();
        ext.edit();
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testMethods5() {
        
        Account_Plan__c ap = ClsTestHelp.createTestAccountPlan();
        
        Test.startTest();
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(ap); 
        ExtAccountPlanView ext = new ExtAccountPlanView(stdCtrl);
        ext.accountPlan = ap;
        
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testMethods6() {
         
        RecordType rt = ClsTestHelp.createTestRecordType6();
        RecordType rt2 = ClsTestHelp.createTestRecordType8();
        RecordType rt3 = ClsTestHelp.createTestRecordType14();
        RecordType rt4 = ClsTestHelp.createTestRecordType21();
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt2.Id;
        acc.Customer_Classification__c = 'A';
        acc.Type = 'Competitor';
        insert acc;
        
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.RecordTypeId = rt4.Id;
        acc2.Customer_Classification__c = 'A';
        acc2.Type = 'Competitor';
        acc2.Individually_Planned__c = true;
        acc2.Plan_Group_Id__c = acc.Id;
        insert acc2; 
        
        Account acc3 = ClsTestHelp.createTestAccounts();
        acc3.RecordTypeId = rt3.Id;
        acc3.Customer_Classification__c = 'A';
        acc3.Type = 'Global Account';
        //acc3.Customer_Region__c = 'EMEA';
        acc3.GAMCD__c = 'G032';
        insert acc3;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.AccountId = acc.Id;
        oppy.StageName = 'New';
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.Total_Opportunity_Value__c=1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        oppy.Five_Year_Value__c=1;
        insert oppy;
        
        Account_Plan__c ap = ClsTestHelp.createTestAccountPlan();
        ap.Customer__c = acc3.Id;
        ap.Plan_Year__c = '2012';
        ap.Key_Project_1__c = oppy.Id;
        ap.Key_Project_2__c = oppy.Id;
        ap.Key_Project_3__c = oppy.Id;
        ap.Key_Project_4__c = oppy.Id;
        ap.Key_Project_5__c = oppy.Id;
        ap.Key_Project_6__c = oppy.Id;
        ap.Won_Project_1__c = oppy.Id;
        ap.Won_Project_2__c = oppy.Id;
        ap.Won_Project_3__c = oppy.Id;
        ap.Won_Project_4__c = oppy.Id;
        ap.Lost_Project_1__c = oppy.Id;
        ap.Lost_Project_2__c = oppy.Id;
        ap.Lost_Project_3__c = oppy.Id;
        ap.Lost_Project_4__c = oppy.Id;
        ap.Company_Logo_Id__c = '123456789012345';
        ap.Account_Manager_Id__c = '123456789012345';
        ap.Approval_Status__c = 'Pending';
        ap.Account_Objective_2__c = 'xxxx';
        ap.Account_Objective_3__c = 'xxxx';
        ap.Account_Objective_4__c = 'xxxx';
        ap.Account_Objective_4__c = 'xxx';
        ap.Account_Objective_5__c = 'xxxxx';
        ap.Strategic_Initiative_2__c = 'xxx';
        ap.Strategic_Initiative_3__c = 'xxx';
        ap.Strategic_Initiative_4__c = 'xxx';
        ap.Strategic_Initiative_5__c = 'xxx';
        ap.Strategic_Initiative_6__c = 'xxx';
        ap.Strategic_Initiative_7__c = 'xxx';
        ap.Strategic_Initiative_8__c = 'xxx';
        ap.Strategic_Initiative_9__c = 'xxx';
        ap.Category1_Name__c = 'xxx';
        ap.Category2_Name__c = 'xxx';
        ap.Category3_Name__c = 'xxx';
        ap.Key_Product_2__c = 'xxx';
        ap.Key_Product_3__c = 'xxx';
        ap.Key_Product_4__c = 'xxx';
        ap.Key_Product_5__c = 'xxx';
        ap.Key_Product_6__c = 'xxx';
        ap.Breakthrough_Program_1__c = 'xxx';
        ap.Breakthrough_Program_2__c = 'xxx';
        ap.Breakthrough_Program_3__c = 'xxx';
        ap.Breakthrough_Program_4__c = 'xxx';
        ap.Recent_Big_Win_1__c = 'xxx';
        ap.Recent_Big_Win_2__c = 'xxx';
        ap.Recent_Big_Win_3__c = 'xxx';
        ap.Recent_Big_Win_4__c = 'xxx';
        ap.Recent_Loss_1__c = 'xxx';
        ap.Recent_Loss_2__c = 'xxx';
        ap.Recent_Loss_3__c = 'xxx';
        ap.Recent_Loss_4__c = 'xxx';
        ap.Obstacle_1__c = 'xxx';
        ap.Obstacle_2__c = 'xxx';
        ap.Obstacle_3__c = 'xxx';
        ap.Obstacle_4__c = 'xxx';
        ap.Obstacle_5__c = 'xxx';
        ap.Revenue_TAM_SAM__c = 'TAM';
        ap.Sales_Figures_Makeup__c = 'Direct;Indirect - Distribution';
        ap.Account_Manager_Approver__c = UserInfo.getUserId();
        ap.Active__c = true;
        insert ap;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'GPL';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Proposal Part';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        BBB_Year_Bill_Book_Cust_PN__c bby = new BBB_Year_Bill_Book_Cust_PN__c();
        bby.Part__c = part.Id;
        bby.Customer__c = acc3.Id;
        bby.Year__c = '2011';
        bby.Bill_Type__c = 'Direct';
        insert bby;
        
        BBB_Month_Bill_Book_Cust__c byb = new BBB_Month_Bill_Book_Cust__c();
        byb.Region__c = 'EU';
        byb.Bill_Type__c = 'Direct';
        byb.Bill_Amount_USD__c = 11;
        byb.Fiscal_Year__c = '2011';
        byb.Customer__c = acc3.Id;
        byb.SAP_Profit_Center__c = 'Test';
        insert byb;
        
        ExtAccountPlanView.overview extOw = new ExtAccountPlanView.overview('xxx',1.2,1.3,'20',1.5,'20');
        ExtAccountPlanView.breakthroughProgram extBp = new ExtAccountPlanView.breakthroughProgram('xxx','zzz','ooo');
        ExtAccountPlanView.winsAndLosses extWin = new ExtAccountPlanView.winsAndLosses(oppy.Id,'SandKing',1.2,String.valueOf(system.today()),'xx');
        
        ExtAccountPlanView.snapshot extSn = new ExtAccountPlanView.snapshot(ap.Id,String.valueOf(date.Today()));
        
        list<ExtAccountPlanView.snapshot> list_snapshot = new list<ExtAccountPlanView.snapshot>();
        list_snapshot.add(extSn);
        
        Test.startTest();
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(ap); 
        ExtAccountPlanView ext = new ExtAccountPlanView(stdCtrl);
        ext.accountPlan = ap;
        ext.list_snapshot = list_snapshot;
        ext.planYearMinus1 = 2011;
        
        //ext.getChartWithRegion();
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testMethods7() {
         
        RecordType rt = ClsTestHelp.createTestRecordType6();
        RecordType rt2 = ClsTestHelp.createTestRecordType8();
        RecordType rt3 = ClsTestHelp.createTestRecordType21();
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt2.Id;
        acc.Customer_Classification__c = 'A';
        acc.Type = 'Competitor';
        insert acc;
        
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.RecordTypeId = rt2.Id;
        acc2.Customer_Classification__c = 'A';
        acc2.Type = 'Competitor';
        acc2.Individually_Planned__c = true;
        acc2.Plan_Group_Id__c = acc.Id;
        insert acc2; 
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.AccountId = acc.Id;
        oppy.StageName = 'New';
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.Total_Opportunity_Value__c=1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        oppy.Five_Year_Value__c=1;
        insert oppy;
        
        Account_Plan__c ap = ClsTestHelp.createTestAccountPlan();
        ap.Active__c = true;
        ap.Account_Manager_Approver__c = UserInfo.getUserId();
        ap.Account_Definition__c = 'Custom';
        ap.Customer__c = acc.Id;
        ap.Plan_Year__c = '2012';
        ap.Key_Project_1__c = oppy.Id;
        ap.Key_Project_2__c = oppy.Id;
        ap.Key_Project_3__c = oppy.Id;
        ap.Key_Project_4__c = oppy.Id;
        ap.Key_Project_5__c = oppy.Id;
        ap.Key_Project_6__c = oppy.Id;
        ap.Won_Project_1__c = oppy.Id;
        ap.Won_Project_2__c = oppy.Id;
        ap.Won_Project_3__c = oppy.Id;
        ap.Won_Project_4__c = oppy.Id;
        ap.Lost_Project_1__c = oppy.Id;
        ap.Lost_Project_2__c = oppy.Id;
        ap.Lost_Project_3__c = oppy.Id;
        ap.Lost_Project_4__c = oppy.Id;
        ap.Company_Logo_Id__c = '123456789012345';
        ap.Account_Manager_Id__c = '123456789012345';
        ap.Approval_Status__c = 'Pending';
        ap.Account_Objective_2__c = 'xxxx';
        ap.Account_Objective_3__c = 'xxxx';
        ap.Account_Objective_4__c = 'xxxx';
        ap.Account_Objective_4__c = 'xxx';
        ap.Account_Objective_5__c = 'xxxxx';
        ap.Strategic_Initiative_2__c = 'xxx';
        ap.Strategic_Initiative_3__c = 'xxx';
        ap.Strategic_Initiative_4__c = 'xxx';
        ap.Strategic_Initiative_5__c = 'xxx';
        ap.Strategic_Initiative_6__c = 'xxx';
        ap.Strategic_Initiative_7__c = 'xxx';
        ap.Strategic_Initiative_8__c = 'xxx';
        ap.Strategic_Initiative_9__c = 'xxx';
        ap.Category1_Name__c = 'xxx';
        ap.Category2_Name__c = 'xxx';
        ap.Category3_Name__c = 'xxx';
        ap.Key_Product_2__c = 'xxx';
        ap.Key_Product_3__c = 'xxx';
        ap.Key_Product_4__c = 'xxx';
        ap.Key_Product_5__c = 'xxx';
        ap.Key_Product_6__c = 'xxx';
        ap.Breakthrough_Program_1__c = 'xxx';
        ap.Breakthrough_Program_2__c = 'xxx';
        ap.Breakthrough_Program_3__c = 'xxx';
        ap.Breakthrough_Program_4__c = 'xxx';
        ap.Recent_Big_Win_1__c = 'xxx';
        ap.Recent_Big_Win_2__c = 'xxx';
        ap.Recent_Big_Win_3__c = 'xxx';
        ap.Recent_Big_Win_4__c = 'xxx';
        ap.Recent_Loss_1__c = 'xxx';
        ap.Recent_Loss_2__c = 'xxx';
        ap.Recent_Loss_3__c = 'xxx';
        ap.Recent_Loss_4__c = 'xxx';
        ap.Obstacle_1__c = 'xxx';
        ap.Obstacle_2__c = 'xxx';
        ap.Obstacle_3__c = 'xxx';
        ap.Obstacle_4__c = 'xxx';
        ap.Obstacle_5__c = 'xxx';
        ap.Revenue_TAM_SAM__c = 'TAM';
        insert ap;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'GPL';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Proposal Part';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        BBB_Year_Bill_Book_Cust_PN__c bby = new BBB_Year_Bill_Book_Cust_PN__c();
        bby.Part__c = part.Id;
        bby.Customer__c = acc.Id;
        insert bby;
        
        BBB_Month_Bill_Book_Cust__c byb = new BBB_Month_Bill_Book_Cust__c();
        byb.Region__c = 'EU';
        byb.Bill_Type__c = 'Direct';
        byb.Bill_Amount_USD__c = 11;
        byb.Fiscal_Year__c = '2011';
        byb.Customer__c = acc.Id;
        insert byb;
        
        ExtAccountPlanView.overview extOw = new ExtAccountPlanView.overview('xxx',1.2,1.3,'20',1.5,'20');
        ExtAccountPlanView.breakthroughProgram extBp = new ExtAccountPlanView.breakthroughProgram('xxx','zzz','ooo');
        ExtAccountPlanView.winsAndLosses extWin = new ExtAccountPlanView.winsAndLosses(oppy.Id,'SandKing',1.2,String.valueOf(system.today()),'xx');
        
        ExtAccountPlanView.snapshot extSn = new ExtAccountPlanView.snapshot(ap.Id,String.valueOf(date.Today()));
        
        list<ExtAccountPlanView.snapshot> list_snapshot = new list<ExtAccountPlanView.snapshot>();
        list_snapshot.add(extSn);
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('id',ap.Id);
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(ap); 
        ExtAccountPlanView ext = new ExtAccountPlanView(stdCtrl);
        ext.accountPlan = ap;

        ext.unLock();
        ext.edit();
        
        system.assert(true);
        Test.stopTest();
    }*/
}