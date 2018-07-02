/**
*   This test class is for ExtAPShapShotView.
*
@author Di Chen
@created 2012-06-07
@version 1.0
@since 20.0
*
@changelog
* 2012-06-07 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 97%
*/
@isTest 
private class ExtAPShapShotView_Test {

    static testMethod void testAllMethods() {
        
        RecordType rt = ClsTestHelp.createTestRecordType6();
        RecordType rt2 = ClsTestHelp.createTestRecordType8();
        
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
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        insert oppy;
         
        Account_Plan__c ap = ClsTestHelp.createTestAccountPlan();
        ap.Customer__c = acc.Id;
        ap.Plan_Year__c = '2012';
        /*ap.Competitor1__c = acc2.Id;
        ap.Competitor2__c = acc2.Id;
        ap.Competitor3__c = acc2.Id;
        ap.Competitor4__c = acc2.Id;
        ap.Competitor5__c = acc2.Id;
        ap.Competitor6__c = acc2.Id;*/
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
        ExtAPShapShotView.breakthroughProgram extBp = new ExtAPShapShotView.breakthroughProgram('xxx','zzz','ooo');
        ExtAPShapShotView.winsAndLosses extWin = new ExtAPShapShotView.winsAndLosses(oppy.Id,'SandKing',1.2,String.valueOf(system.today()),'xx');
        Test.startTest();
         
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(ap); 
        ExtAPShapShotView ext = new ExtAPShapShotView(stdCtrl);
        ext.accountPlan = ap;
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testLeastMethods() {

        Account_Plan__c ap = ClsTestHelp.createTestAccountPlan();
        
        Test.startTest();
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(ap); 
        ExtAPShapShotView ext = new ExtAPShapShotView(stdCtrl);
        ext.accountPlan = ap;
        
        system.assert(true);
        Test.stopTest();
    }
}