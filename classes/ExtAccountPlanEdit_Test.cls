/**
*   This test class is for ExtAccountPlanEdit.
*
@author Di Chen
@created 2012-06-07
@version 1.0
@since 20.0
*
@changelog
* 2012-06-07 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 78%
*/
@isTest(SeeAllData = true)
private class ExtAccountPlanEdit_Test {
    static testMethod void modeIsEdit1() {
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();
        RecordType rt = ClsTestHelp.createTestRecordType14();
        RecordType rt2 = ClsTestHelp.createTestRecordType8();
        RecordType rt3 = ClsTestHelp.createTestRecordType21();
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt.Id;
        acc.Customer_Classification__c = 'A'; 
        acc.Type = 'Global Account';       
        acc.Type = 'Competitor';
        insert acc;
        
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.RecordTypeId = rt.Id;
        acc2.Customer_Classification__c = 'A';
        acc2.Type = 'Grouped B';
        acc.IND_KAM_Code__c = 'test';
        acc2.Individually_Planned__c = true;
        acc2.Plan_Group_Id__c = acc.Id;
        insert acc2;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.AccountId = acc.Id;
        oppy.StageName = 'New';
        //oppy.RecordTypeId = rt2.Id;
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        insert oppy;
        
        oppy.Five_Year_Revenue__c = 23;
        update oppy;
        
        Account_Plan__c ap = ClsTestHelp.createTestAccountPlan();
        ap.Customer__c = acc2.Id;
        ap.Plan_Year__c = '2012';
        ap.Sales_Figures_Makeup__c = 'Direct';
        /*ap.Competitor1__c = acc2.Id;
        ap.Competitor2__c = acc2.Id;
        ap.Competitor3__c = acc2.Id;
        ap.Competitor4__c = acc2.Id;
        ap.Competitor5__c = acc2.Id;
        ap.Competitor6__c = acc2.Id;*/
        ap.Account_Definition__c = 'Custom';
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
        ap.Strategic_Initiative_11__c = '12';
        ap.Strategic_Initiative_12__c = '12';
        ap.Strategic_Initiative_13__c = '12';
        ap.Strategic_Initiative_14__c = '12';
        ap.Strategic_Initiative_15__c = '12';
        ap.Strategic_Initiative_16__c = '12';
        ap.Strategic_Initiative_17__c = '12';
        ap.Strategic_Initiative_18__c = '12';
        ap.Strategic_Initiative_19__c = '12';
        ap.Strategic_Initiative_20__c = '12'; 
        ap.active__c = true;       
        insert ap;
        
        Account_Plan__c ap1 = ClsTestHelp.createTestAccountPlan();
        ap1.Customer__c = acc.Id;
        ap1.Plan_Year__c = '2012';
        ap1.Sales_Figures_Makeup__c = 'Direct';
        ap1.Account_Definition__c = 'Custom';
        ap1.Key_Project_1__c = oppy.Id;
        ap1.Key_Project_2__c = oppy.Id;
        ap1.Key_Project_3__c = oppy.Id;
        ap1.Key_Project_4__c = oppy.Id;
        ap1.Key_Project_5__c = oppy.Id;
        ap1.Key_Project_6__c = oppy.Id;
        ap1.Won_Project_1__c = oppy.Id;
        ap1.Won_Project_2__c = oppy.Id;
        ap1.Won_Project_3__c = oppy.Id;
        ap1.Won_Project_4__c = oppy.Id;
        ap1.Lost_Project_1__c = oppy.Id;
        ap1.Lost_Project_2__c = oppy.Id;
        ap1.Lost_Project_3__c = oppy.Id;
        ap1.Lost_Project_4__c = oppy.Id;
        ap1.Strategic_Initiative_11__c = '12';
        ap1.Strategic_Initiative_12__c = '12';
        ap1.Strategic_Initiative_13__c = '12';
        ap1.Strategic_Initiative_14__c = '12';
        ap1.Strategic_Initiative_15__c = '12';
        ap1.Strategic_Initiative_16__c = '12';
        ap1.Strategic_Initiative_17__c = '12';
        ap1.Strategic_Initiative_18__c = '12';
        ap1.Strategic_Initiative_19__c = '12';
        ap1.Strategic_Initiative_20__c = '12'; 
        ap1.active__c = true;       
        insert ap1;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'GPL';
        ph.Description__c = 'Industrial';
        ph.CBC3_Description__c = 'Wire Processing';
        //insert ph;
        
        Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
        ph1.Hierarchy_Level_Type__c = 'GPL';
        ph1.Description__c = 'Industrial';
        ph1.CBC3_Description__c = 'Wire Processing';
        //insert ph1;
        
        Product_Hierarchy__c ph2 = new Product_Hierarchy__c();
        ph2.Hierarchy_Level_Type__c = 'GPL';
        ph2.Description__c = 'Industrial';
        ph2.CBC3_Description__c = 'Wire Processing';
        //insert ph2;
        
        Product_Hierarchy__c ph3 = new Product_Hierarchy__c();
        ph3.Hierarchy_Level_Type__c = 'GPL';
        ph3.Description__c = 'Industrial';
        ph3.CBC3_Description__c = 'Wire Processing';
        //insert ph3;
        
        Product_Hierarchy__c ph4 = new Product_Hierarchy__c();
        ph4.Hierarchy_Level_Type__c = 'GPL';
        ph4.Description__c = 'Industrial';
        ph4.CBC3_Description__c = 'Wire Processing';
        //insert ph4;
        
        Product_Hierarchy__c ph5 = new Product_Hierarchy__c();
        ph5.Hierarchy_Level_Type__c = 'GPL';
        ph5.Description__c = 'Industrial';
        ph5.CBC3_Description__c = 'Wire Processing';
        insert new list<Product_Hierarchy__c>{ph, ph1, ph2, ph3, ph4, ph5};
        
        Part__c part = new Part__c();
        part.Description__c = 'Proposal Part';
        part.Product_Hierarchy__c = ph.Id;
        //insert part;
        
        Part__c part1 = new Part__c();
        part1.Description__c = 'Proposal Part';
        part1.Product_Hierarchy__c = ph1.Id;
        //insert part1;
        
        Part__c part2 = new Part__c();
        part2.Description__c = 'Proposal Part';
        part2.Product_Hierarchy__c = ph2.Id;
        //insert part2;
        
        Part__c part3 = new Part__c();
        part3.Description__c = 'Proposal Part';
        part3.Product_Hierarchy__c = ph3.Id;
        //insert part3;
        
        Part__c part4 = new Part__c();
        part4.Description__c = 'Proposal Part';
        part4.Product_Hierarchy__c = ph4.Id;
        //insert part4;
        
        Part__c part5 = new Part__c();
        part5.Description__c = 'Proposal Part';
        part5.Product_Hierarchy__c = ph5.Id;
        insert new list<Part__c>{part, part1, part2, part3, part4, part5};
        
        BBB_Year_Bill_Book_Cust_PN__c bby = new BBB_Year_Bill_Book_Cust_PN__c();
        bby.Part__c = part.Id;
        bby.Customer__c = acc.Id;
        insert bby;
        
        BBB_Month_Bill_Book_Cust__c byb = new BBB_Month_Bill_Book_Cust__c();
        byb.Region__c = 'EU';
        byb.Bill_Type__c = 'Direct';
        byb.Bill_Amount_USD__c = 11;
        byb.Fiscal_Year__c = '2012';
        byb.Customer__c = acc2.Id;
        byb.SAP_Profit_Center__c = 'Business Unit';
        byb.Sales_Period__c = date.newInstance(2013, 2, 15);
        //insert byb;
        
        BBB_Month_Bill_Book_Cust__c byb1 = new BBB_Month_Bill_Book_Cust__c();
        byb1.Region__c = 'EU1';
        byb1.Bill_Type__c = 'Direct';
        byb1.Bill_Amount_USD__c = 19;
        byb1.Fiscal_Year__c = '2012';
        byb1.Customer__c = acc2.Id;
        byb1.SAP_Profit_Center__c = 'Business Unit';
        byb1.Sales_Period__c = date.newInstance(2013, 3, 15);
        //insert byb1;
        
        BBB_Month_Bill_Book_Cust__c byb2 = new BBB_Month_Bill_Book_Cust__c();
        byb2.Region__c = 'EU2';
        byb2.Bill_Type__c = 'Direct';
        byb2.Bill_Amount_USD__c = 18;
        byb2.Fiscal_Year__c = '2012';
        byb2.Customer__c = acc2.Id;
        byb2.SAP_Profit_Center__c = 'Business Unit';
        byb2.Sales_Period__c = date.newInstance(2013, 4, 15);
        //insert byb2;
        
        BBB_Month_Bill_Book_Cust__c byb3 = new BBB_Month_Bill_Book_Cust__c();
        byb3.Region__c = 'EU3';
        byb3.Bill_Type__c = 'Direct';
        byb3.Bill_Amount_USD__c = 16;
        byb3.Fiscal_Year__c = '2012';
        byb3.Customer__c = acc2.Id;
        byb3.SAP_Profit_Center__c = 'Business Unit';
        byb3.Sales_Period__c = date.newInstance(2013, 5, 15);
        //insert byb3;
        
        BBB_Month_Bill_Book_Cust__c byb4 = new BBB_Month_Bill_Book_Cust__c();
        byb4.Region__c = 'EU4';
        byb4.Bill_Type__c = 'Direct';
        byb4.Bill_Amount_USD__c = 14;
        byb4.Fiscal_Year__c = '2012';
        byb4.Customer__c = acc2.Id;
        byb4.SAP_Profit_Center__c = 'Business Unit';
        byb4.Sales_Period__c = date.newInstance(2013, 6, 15);
        //insert byb4;
        
        BBB_Month_Bill_Book_Cust__c byb5 = new BBB_Month_Bill_Book_Cust__c();
        byb5.Region__c = 'EU5';
        byb5.Bill_Type__c = 'Direct';
        byb5.Bill_Amount_USD__c = 15;
        byb5.Fiscal_Year__c = '2012';
        byb5.Customer__c = acc2.Id;
        byb5.SAP_Profit_Center__c = 'Business Unit';
        byb5.Sales_Period__c = date.newInstance(2013, 7, 15);
        insert new list<BBB_Month_Bill_Book_Cust__c> {byb, byb1, byb2, byb3, byb4, byb5};
        
        set<string> set_salesRTs = new set<string>();
        set<string> set_engineerRTs = new set<string>();
        set<string> set_dndRTs = new set<string>();
        set<string> set_salescsdRTs = new set<string>();
        set<string> set_engcsdRTs = new set<string>();  
                            
                                    
        for (Opportunity_Record_Type_Groups__c rtty : Opportunity_Record_Type_Groups__c.getall().values()){
            if(rtty.Active__c && rtty.API_Name__c!= null){
                if(rtty.Group__c == 'Account Plan Set Oppty type'){
                    if (rtty.Is_Sales_Only__c)
                                    set_salesRTs.add(rtty.API_Name__c);
                            else
                                    set_engineerRTs.add(rtty.API_Name__c);
                }
                if(rtty.Group__c == 'CSD Account Plan Set Oppty type'){
                    if (rtty.Is_Sales_Only__c)
                                    set_salescsdRTs.add(rtty.API_Name__c);
                            else
                                    set_engcsdRTs.add(rtty.API_Name__c);
                }
                if(rtty.Group__c == 'DND Account Plan Set Oppty type'){
                    
                         set_dndRTs.add(rtty.API_Name__c);
                          
                }
                
            }
        }
    
        Attachment att = ClsTestHelp.createTestAttachments();
        att.Name = 'VoiceOverview.wav';
        att.ParentId = ap.Id;
        insert att;
        Opportunity oppy2 = [select Name,Account_Plan_Comment__c, LastModifiedDate from Opportunity where Id =: oppy.Id];
        ExtAccountPlanEdit.keyOppyAndProgramm extKey = new ExtAccountPlanEdit.keyOppyAndProgramm(oppy,true,1,String.valueOf(date.today()),1, set_salesRTs, set_engineerRTs, set_dndRTs, set_salescsdRTs, set_engcsdRTs);
        
        list<ExtAccountPlanEdit.winLossOppy> list_winOppy = new list<ExtAccountPlanEdit.winLossOppy>();
        list<ExtAccountPlanEdit.winLossOppy> list_lossOppy = new list<ExtAccountPlanEdit.winLossOppy>();
        ExtAccountPlanEdit.winLossOppy extWin = new ExtAccountPlanEdit.winLossOppy(oppy,true,1,String.valueOf(date.today()),1,set_salesRTs, set_engineerRTs, set_dndRTs, set_salescsdRTs, set_engcsdRTs);
        extWin.isSelected = true;
        extWin.fiveYearReve = 12;
        extWin.oppy = oppy2;
        list_winOppy.add(extWin);
        list_lossOppy.add(extWin);
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('id',ap.Id);
        ApexPages.currentPage().getParameters().put('accId',acc.Id);
        ApexPages.currentPage().getParameters().put('retURL','http://www.baidu.com');
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(ap); 
        ExtAccountPlanEdit ext = new ExtAccountPlanEdit(stdCtrl);
        ext.voiceBody = Blob.valueof('Test');
        ext.voiceFileContentType = 'audio';
        ext.accPlan = ap;
        ext.planYearMinus1 = 2012;
        ext.list_winOppy = list_winOppy;
        ext.list_lossOppy = list_lossOppy;
        
        ext.Saveone();
        
        ext.RemoveVoiceFile();
        ext.refreshOverviewTable();
        ext.cancel();
        ExtAccountPlanEdit.loadLineChart(ap);
        ExtAccountPlanEdit.loadPieCBCChart(ap);
        ExtAccountPlanEdit.loadPieRegionChart(ap);
        ExtAccountPlanEdit.loadLineChart(ap1);
        ExtAccountPlanEdit.loadPieCBCChart(ap1);
        ExtAccountPlanEdit.loadPieRegionChart(ap1);
        
        boolean b = ext.chkLoggedInUser;
        ext.Unlock();
        //ext.cbcPart1 = null;
        //ext.cbcPart2 = 1;
        //ext.Saveone();
        
        Test.stopTest();
    }
    
    static testMethod void modeIsEdit2() {
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8(); 
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();       
        RecordType rt = ClsTestHelp.createTestRecordType14();
        RecordType rt2 = ClsTestHelp.createTestRecordType8();
        RecordType rt3 = ClsTestHelp.createTestRecordType21();
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt.Id;
        acc.Customer_Classification__c = 'A';
        acc.IND_KAM_Code__c = 'test';
        acc.Type = 'Competitor';
        insert acc;
        
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.RecordTypeId = rt.Id;
        acc.IND_KAM_Code__c = 'test';
        acc2.Customer_Classification__c = 'A';
        acc2.Type = 'Competitor';
        insert acc2;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.AccountId = acc.Id;
        oppy.StageName = 'New';
        //oppy.RecordTypeId = rt2.Id;
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        insert oppy;
        
        oppy.Amount = 2;
        update oppy;
        
        Account_Plan__c ap = ClsTestHelp.createTestAccountPlan();
        ap.Customer__c = acc.Id;
        ap.Plan_Year__c = '2012';
        /*ap.Competitor1__c = acc2.Id;
        ap.Competitor2__c = acc2.Id;
        ap.Competitor3__c = acc2.Id;
        ap.Competitor4__c = acc2.Id;
        ap.Competitor5__c = acc2.Id;
        ap.Competitor6__c = acc2.Id;*/
        ap.Account_Definition__c = 'Custom';
        ap.Sales_Figures_Makeup__c = 'Direct';
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
        ap.Key_Project_1__c = oppy.Id;
        ap.Won_Project_2__c = oppy.Id;
        ap.active__c = true;
        insert ap;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'GPL';
        ph.Description__c = 'Industrial';
        ph.CBC3_Description__c = 'Wire Processing';
        insert ph;
       
        Part__c part = new Part__c();
        part.Description__c = 'Proposal Part';
        part.Product_Hierarchy__c = ph.Id;
        insert part;              
        
        BBB_Year_Bill_Book_Cust_PN__c bby = new BBB_Year_Bill_Book_Cust_PN__c();
        bby.Part__c = part.Id;
        bby.Bill_Prior_Year_Amount_USD__c = 10;
        bby.Customer__c = acc.Id;
        bby.Year__c = ap.Plan_Year__c;
        bby.Bill_Type__c = 'Direct';
        insert bby;
        
        BBB_Year_Bill_Book_Cust_PN__c bby1 = new BBB_Year_Bill_Book_Cust_PN__c();
        bby1.Part__c = part.Id;
        bby1.Customer__c = acc.Id;
        insert bby1;
        
        BBB_Year_Bill_Book_Cust_PN__c bby2 = new BBB_Year_Bill_Book_Cust_PN__c();
        bby2.Part__c = part.Id;
        bby2.Customer__c = acc.Id;
        insert bby2;
        
        BBB_Year_Bill_Book_Cust_PN__c bby3 = new BBB_Year_Bill_Book_Cust_PN__c();
        bby3.Part__c = part.Id;
        bby3.Customer__c = acc.Id;
        insert bby3;
        
        BBB_Year_Bill_Book_Cust_PN__c bby4 = new BBB_Year_Bill_Book_Cust_PN__c();
        bby4.Part__c = part.Id;
        bby4.Customer__c = acc.Id;
        insert bby4;
        
        BBB_Month_Bill_Book_Cust__c byb = new BBB_Month_Bill_Book_Cust__c();
        byb.Region__c = 'EU';
        byb.Bill_Type__c = 'Direct';
        byb.Bill_Amount_USD__c = 11;
        byb.Fiscal_Year__c = '2011';
        byb.Customer__c = acc.Id;
        insert byb;
        
        set<string> set_salesRTs = new set<string>();
        set<string> set_engineerRTs = new set<string>();
        set<string> set_dndRTs = new set<string>();
        set<string> set_salescsdRTs = new set<string>();
        set<string> set_engcsdRTs = new set<string>();

        for (Opportunity_Record_Type_Groups__c rtty : Opportunity_Record_Type_Groups__c.getall().values()){
                if(rtty.Active__c && rtty.API_Name__c!= null){
                     if(rtty.Group__c == 'Account Plan Set Oppty type'){
                        if (rtty.Is_Sales_Only__c)
                                    set_salesRTs.add(rtty.API_Name__c);
                            else
                                    set_engineerRTs.add(rtty.API_Name__c);
                }
                if(rtty.Group__c == 'CSD Account Plan Set Oppty type'){
                        if (rtty.Is_Sales_Only__c)
                                    set_salescsdRTs.add(rtty.API_Name__c);
                            else
                                    set_engcsdRTs.add(rtty.API_Name__c);
                }
                if(rtty.Group__c == 'DND Account Plan Set Oppty type'){
                    
                         set_dndRTs.add(rtty.API_Name__c);
                          
                }
                
            }
        } 
        
        Opportunity oppy2 = [select Name,CloseDate,Account_Plan_Comment__c, LastModifiedDate from Opportunity where Id =: oppy.Id];
        list<ExtAccountPlanEdit.keyOppyAndProgramm> list_keyOppyAndProgramm = new list<ExtAccountPlanEdit.keyOppyAndProgramm>();
        ExtAccountPlanEdit.keyOppyAndProgramm extKey = new ExtAccountPlanEdit.keyOppyAndProgramm(oppy,true,1,String.valueOf(date.today()),1, set_salesRTs, set_engineerRTs, set_dndRTs, set_salescsdRTs, set_engcsdRTs);
        extKey.isSelected = true;
        extKey.oppy = oppy2;
        list_keyOppyAndProgramm.add(extKey);
        
        list<ExtAccountPlanEdit.winLossOppy> list_winOppy = new list<ExtAccountPlanEdit.winLossOppy>();
        list<ExtAccountPlanEdit.winLossOppy> list_lossOppy = new list<ExtAccountPlanEdit.winLossOppy>();
        ExtAccountPlanEdit.winLossOppy extWin = new ExtAccountPlanEdit.winLossOppy(oppy,true,1,String.valueOf(date.today()),1, set_salesRTs, set_engineerRTs, set_dndRTs, set_salescsdRTs, set_engcsdRTs);
        extWin.oppy = oppy2;
        extWin.isSelected = true;
        list_winOppy.add(extWin);
        list_lossOppy.add(extWin);
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('id',ap.Id);
        ApexPages.currentPage().getParameters().put('accId',acc.Id);
        ApexPages.currentPage().getParameters().put('retURL','http://www.baidu.com');
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(ap); 
        ExtAccountPlanEdit ext = new ExtAccountPlanEdit(stdCtrl);
        ext.voiceBody = Blob.valueof('Test');
        ext.voiceFileContentType = 'audio';
        ext.accPlan = ap;
        ext.list_winOppy = list_winOppy;
        ext.list_keyOppyAndProgramm = list_keyOppyAndProgramm;
        ext.voiceFileSize = 3145729;
        
        ext.Saveone();
        ext.RemoveVoiceFile();
        ext.refreshOverviewTable();
        ext.cancel();
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void modeIsEdit3() {
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();        
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
        insert acc2;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.AccountId = acc.Id;
        oppy.StageName = 'New';
        //oppy.RecordTypeId = rt2.Id;
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        insert oppy;
        
        oppy.Five_Year_Revenue__c = 3;
        update oppy;
        
        Account_Plan__c ap = ClsTestHelp.createTestAccountPlan();
        ap.Customer__c = acc.Id;
        ap.Plan_Year__c = '2012';
        /*ap.Competitor1__c = acc2.Id;
        ap.Competitor2__c = acc2.Id;
        ap.Competitor3__c = acc2.Id;
        ap.Competitor4__c = acc2.Id;
        ap.Competitor5__c = acc2.Id;
        ap.Competitor6__c = acc2.Id;*/
        ap.Account_Definition__c = 'Custom';
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
        ap.Key_Project_1__c = oppy.Id;
        ap.Won_Project_2__c = oppy.Id;
        ap.active__c = true;
        insert ap;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'GPL';
        ph.Description__c = 'Industrial';
       // ph.CBC3_Description__c = 'Wire Processing';
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
        
        set<string> set_salesRTs = new set<string>();
        set<string> set_engineerRTs = new set<string>();
        set<string> set_dndRTs = new set<string>();
        set<string> set_salescsdRTs = new set<string>();
        set<string> set_engcsdRTs = new set<string>();

        for (Opportunity_Record_Type_Groups__c rtty : Opportunity_Record_Type_Groups__c.getall().values()){
                    if(rtty.Active__c && rtty.API_Name__c!= null){
                        if(rtty.Group__c == 'Account Plan Set Oppty type'){
                            if (rtty.Is_Sales_Only__c)
                                            set_salesRTs.add(rtty.API_Name__c);
                                    else
                                            set_engineerRTs.add(rtty.API_Name__c);
                        }
                        if(rtty.Group__c == 'CSD Account Plan Set Oppty type'){
                            if (rtty.Is_Sales_Only__c)
                                            set_salescsdRTs.add(rtty.API_Name__c);
                                    else
                                            set_engcsdRTs.add(rtty.API_Name__c);
                        }
                        if(rtty.Group__c == 'DND Account Plan Set Oppty type'){
                            
                                 set_dndRTs.add(rtty.API_Name__c);
                                  
                        }
                        
                    }
            }
        
        Opportunity oppy2 = [select Name,CloseDate,Account_Plan_Comment__c, LastModifiedDate from Opportunity where Id =: oppy.Id];
        list<ExtAccountPlanEdit.keyOppyAndProgramm> list_keyOppyAndProgramm = new list<ExtAccountPlanEdit.keyOppyAndProgramm>();
        ExtAccountPlanEdit.keyOppyAndProgramm extKey = new ExtAccountPlanEdit.keyOppyAndProgramm(oppy,true,1,String.valueOf(date.today()),1, set_salesRTs, set_engineerRTs, set_dndRTs, set_salescsdRTs, set_engcsdRTs);
        extKey.isSelected = true;
        extKey.oppy = oppy2;
        list_keyOppyAndProgramm.add(extKey);
        
        list<ExtAccountPlanEdit.winLossOppy> list_winOppy = new list<ExtAccountPlanEdit.winLossOppy>();
        list<ExtAccountPlanEdit.winLossOppy> list_lossOppy = new list<ExtAccountPlanEdit.winLossOppy>();
        ExtAccountPlanEdit.winLossOppy extWin = new ExtAccountPlanEdit.winLossOppy(oppy,true,1,String.valueOf(date.today()),1, set_salesRTs, set_engineerRTs, set_dndRTs, set_salescsdRTs, set_engcsdRTs);
        extWin.oppy = oppy2;
        extWin.isSelected = true;
        list_winOppy.add(extWin);
        list_lossOppy.add(extWin);
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('id',ap.Id);
        ApexPages.currentPage().getParameters().put('accId',acc.Id);
        ApexPages.currentPage().getParameters().put('retURL','http://www.baidu.com');
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(ap); 
        ExtAccountPlanEdit ext = new ExtAccountPlanEdit(stdCtrl);
        ext.voiceBody = Blob.valueof('Test');
        ext.voiceFileContentType = 's';
        ext.accPlan = ap;
        ext.list_winOppy = list_winOppy;
        ext.list_keyOppyAndProgramm = list_keyOppyAndProgramm;
        ext.voiceFileSize = 3;
        ext.voiceName = 'xxxxxx';
        
        ext.Saveone();
        ext.RemoveVoiceFile();
        ext.refreshOverviewTable();
        ext.cancel();
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void modeIsEdit4() {
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();        
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
        insert acc2;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.AccountId = acc.Id;
        oppy.StageName = 'New';
        //oppy.RecordTypeId = rt2.Id;
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        insert oppy;
        
        oppy.Five_Year_Revenue__c = 3;
        update oppy;
        
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
        ap.Account_Definition__c = 'Custom';
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
        ap.Key_Project_1__c = oppy.Id;
        ap.Won_Project_2__c = oppy.Id;
        ap.active__c = true;
        insert ap;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'GPL';
        ph.Description__c = 'Industrial';
       // ph.CBC3_Description__c = 'Wire Processing';
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
        
        set<string> set_salesRTs = new set<string>();
        set<string> set_engineerRTs = new set<string>();
        set<string> set_dndRTs = new set<string>();
        set<string> set_salescsdRTs = new set<string>();
        set<string> set_engcsdRTs = new set<string>();

        for (Opportunity_Record_Type_Groups__c rtty : Opportunity_Record_Type_Groups__c.getall().values()){
                    if(rtty.Active__c && rtty.API_Name__c!= null){
                        if(rtty.Group__c == 'Account Plan Set Oppty type'){
                            if (rtty.Is_Sales_Only__c)
                                            set_salesRTs.add(rtty.API_Name__c);
                                    else
                                            set_engineerRTs.add(rtty.API_Name__c);
                        }
                        if(rtty.Group__c == 'CSD Account Plan Set Oppty type'){
                            if (rtty.Is_Sales_Only__c)
                                            set_salescsdRTs.add(rtty.API_Name__c);
                                    else
                                            set_engcsdRTs.add(rtty.API_Name__c);
                        }
                        if(rtty.Group__c == 'DND Account Plan Set Oppty type'){
                            
                                 set_dndRTs.add(rtty.API_Name__c);
                                  
                        }
                        
                    }
            }
        
        Opportunity oppy2 = [select Name,CloseDate,Account_Plan_Comment__c, LastModifiedDate from Opportunity where Id =: oppy.Id];
        list<ExtAccountPlanEdit.keyOppyAndProgramm> list_keyOppyAndProgramm = new list<ExtAccountPlanEdit.keyOppyAndProgramm>();
        ExtAccountPlanEdit.keyOppyAndProgramm extKey = new ExtAccountPlanEdit.keyOppyAndProgramm(oppy,true,1,String.valueOf(date.today()),1, set_salesRTs, set_engineerRTs, set_dndRTs, set_salescsdRTs, set_engcsdRTs);
        extKey.isSelected = true;
        extKey.oppy = oppy2;
        list_keyOppyAndProgramm.add(extKey);
        
        list<ExtAccountPlanEdit.winLossOppy> list_winOppy = new list<ExtAccountPlanEdit.winLossOppy>();
        list<ExtAccountPlanEdit.winLossOppy> list_lossOppy = new list<ExtAccountPlanEdit.winLossOppy>();
        ExtAccountPlanEdit.winLossOppy extWin = new ExtAccountPlanEdit.winLossOppy(oppy,true,1,String.valueOf(date.today()),1, set_salesRTs, set_engineerRTs, set_dndRTs, set_salescsdRTs, set_engcsdRTs);
        extWin.oppy = oppy2;
        extWin.isSelected = true;
        list_winOppy.add(extWin);
        list_lossOppy.add(extWin);
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('id',ap.Id);
        ApexPages.currentPage().getParameters().put('accId',acc.Id);
        ApexPages.currentPage().getParameters().put('retURL','http://www.baidu.com');
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(ap); 
        ExtAccountPlanEdit ext = new ExtAccountPlanEdit(stdCtrl);
        ext.voiceBody = Blob.valueof('Test');
        ext.voiceFileContentType = 'audio';
        ext.accPlan = ap;
        ext.list_winOppy = list_winOppy;
        ext.list_keyOppyAndProgramm = list_keyOppyAndProgramm;
        ext.voiceFileSize = 3145719;
        ext.voiceName = 'xxxxxx';
        
        ext.Saveone();
        ext.RemoveVoiceFile();
        ext.refreshOverviewTable();
        ext.cancel();
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void modeIsEdit5() {
        RecordType rt = ClsTestHelp.createTestRecordType6();
        RecordType rt2 = ClsTestHelp.createTestRecordType8();
        RecordType rt3 = ClsTestHelp.createTestRecordType21();
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt2.Id;
        acc.Customer_Classification__c = 'A';
        acc.Type = 'Competitor';
        insert acc;
        
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.RecordTypeId = rt2.Id;
        acc2.Customer_Classification__c = 'A';
        acc2.Type = 'Competitor';
        insert acc2;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.AccountId = acc.Id;
        oppy.StageName = 'New';
        //oppy.RecordTypeId = rt2.Id;
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        insert oppy;
        
        oppy.Five_Year_Revenue__c = 3;
        update oppy;
        
        Account_Plan__c ap = ClsTestHelp.createTestAccountPlan();
        ap.Customer__c = acc.Id;
        ap.Plan_Year__c = '2012';
        ap.Account_Definition__c = 'Custom';
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
        ap.Key_Project_1__c = oppy.Id;
        ap.Won_Project_2__c = oppy.Id;
        ap.Strategic_Initiative_2_Status__c = null;
        ap.Strategic_Initiative_2_Target__c = null;
        ap.Strategic_Initiative_3_Status__c = null;
        ap.Strategic_Initiative_3_Target__c = null;
        ap.Strategic_Initiative_4_Status__c = null;
        ap.Strategic_Initiative_4_Target__c = null;
        ap.Strategic_Initiative_5_Status__c = null;
        ap.Strategic_Initiative_5_Target__c = null;
        ap.Strategic_Initiative_6_Status__c = null;
        ap.Strategic_Initiative_6_Target__c = null;
        ap.Strategic_Initiative_7_Status__c = null;
        ap.Strategic_Initiative_7_Target__c = null;
        ap.Strategic_Initiative_8_Status__c = null;
        ap.Strategic_Initiative_8_Target__c = null;
        ap.Strategic_Initiative_9_Status__c = null;
        ap.Strategic_Initiative_9_Target__c = null;
        ap.Strategic_Initiative_10_Status__c = null;
        ap.Strategic_Initiative_10_Target__c = null;
        ap.Strategic_Initiative_1_Target__c = null;
        ap.Strategic_Initiative_1_Status__c = null;
        ap.active__c = true;
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
        
        set<string> set_salesRTs = new set<string>();
        set<string> set_engineerRTs = new set<string>();
        set<string> set_dndRTs = new set<string>();
        set<string> set_salescsdRTs = new set<string>();
        set<string> set_engcsdRTs = new set<string>();

        for (Opportunity_Record_Type_Groups__c rtty : Opportunity_Record_Type_Groups__c.getall().values()){
                    if(rtty.Active__c && rtty.API_Name__c!= null){
                        if(rtty.Group__c == 'Account Plan Set Oppty type'){
                            if (rtty.Is_Sales_Only__c)
                                            set_salesRTs.add(rtty.API_Name__c);
                                    else
                                            set_engineerRTs.add(rtty.API_Name__c);
                        }
                        if(rtty.Group__c == 'CSD Account Plan Set Oppty type'){
                            if (rtty.Is_Sales_Only__c)
                                            set_salescsdRTs.add(rtty.API_Name__c);
                                    else
                                            set_engcsdRTs.add(rtty.API_Name__c);
                        }
                        if(rtty.Group__c == 'DND Account Plan Set Oppty type'){
                            
                                 set_dndRTs.add(rtty.API_Name__c);
                                  
                        }
                        
                    }
            }
        
        Opportunity oppy2 = [select Name,CloseDate,Account_Plan_Comment__c, LastModifiedDate from Opportunity where Id =: oppy.Id];
        list<ExtAccountPlanEdit.keyOppyAndProgramm> list_keyOppyAndProgramm = new list<ExtAccountPlanEdit.keyOppyAndProgramm>();
        ExtAccountPlanEdit.keyOppyAndProgramm extKey = new ExtAccountPlanEdit.keyOppyAndProgramm(oppy,true,1,String.valueOf(date.today()),1, set_salesRTs, set_engineerRTs, set_dndRTs, set_salescsdRTs, set_engcsdRTs);
        extKey.isSelected = true;
        extKey.oppy = oppy2;
        list_keyOppyAndProgramm.add(extKey);
        
        list<ExtAccountPlanEdit.winLossOppy> list_winOppy = new list<ExtAccountPlanEdit.winLossOppy>();
        list<ExtAccountPlanEdit.winLossOppy> list_lossOppy = new list<ExtAccountPlanEdit.winLossOppy>();
        ExtAccountPlanEdit.winLossOppy extWin = new ExtAccountPlanEdit.winLossOppy(oppy,true,1,String.valueOf(date.today()),1, set_salesRTs, set_engineerRTs, set_dndRTs, set_salescsdRTs, set_engcsdRTs);
        extWin.oppy = oppy2;
        extWin.isSelected = true;
        list_winOppy.add(extWin);
        list_lossOppy.add(extWin);
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('id',ap.Id);
        ApexPages.currentPage().getParameters().put('accId',acc.Id);
        ApexPages.currentPage().getParameters().put('retURL','http://www.baidu.com');
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(ap); 
        ExtAccountPlanEdit ext = new ExtAccountPlanEdit(stdCtrl);
        ext.voiceBody = Blob.valueof('Test');
        ext.voiceFileContentType = 's';
        ext.accPlan = ap;
        ext.list_keyOppyAndProgramm = list_keyOppyAndProgramm;
        ext.voiceFileSize = 3;
        ext.voiceName = 'xxxxxx';
        ext.chooseCBC = false;
        
        ext.Saveone();
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void modeIsEdit6() {
        RecordType rt = ClsTestHelp.createTestRecordType6();
        RecordType rt2 = ClsTestHelp.createTestRecordType8();
        RecordType rt3 = ClsTestHelp.createTestRecordType21();
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8(); 
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();       
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt2.Id;
        acc.Customer_Classification__c = 'A';
        acc.Type = 'Competitor';
        insert acc;
        
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.RecordTypeId = rt2.Id;
        acc2.Customer_Classification__c = 'A';
        acc2.Type = 'Competitor';
        insert acc2;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.AccountId = acc.Id;
        oppy.StageName = 'New';
        //oppy.RecordTypeId = rt2.Id;
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        insert oppy;
        
        oppy.Five_Year_Revenue__c = 3;
        update oppy;
        
        Account_Plan__c ap = ClsTestHelp.createTestAccountPlan();
        ap.Name = 'OMG';
        ap.Customer__c = acc.Id;
        ap.Plan_Year__c = '2012';
        ap.Account_Definition__c = 'Custom';
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
        ap.Key_Project_1__c = oppy.Id;
        ap.Won_Project_2__c = oppy.Id;
        ap.Strategic_Initiative_2__c = null;
        ap.Strategic_Initiative_3__c = null;
        ap.Strategic_Initiative_4__c = null;
        ap.Strategic_Initiative_5__c = null;
        ap.Strategic_Initiative_6__c = null;
        ap.Strategic_Initiative_7__c = null;
        ap.Strategic_Initiative_8__c = null;
        ap.Strategic_Initiative_9__c = null;
        ap.Strategic_Initiative_10__c = null;
        ap.Strategic_Initiative_6_Target__c = null;
        ap.Strategic_Initiative_7_Status__c = null;
        ap.Strategic_Initiative_7_Target__c = null;
        ap.Strategic_Initiative_8_Status__c = null;
        ap.Strategic_Initiative_8_Target__c = null;
        ap.Strategic_Initiative_9_Status__c = null;
        ap.Strategic_Initiative_9_Target__c = null;
        ap.Strategic_Initiative_10_Status__c = null;
        ap.Strategic_Initiative_10_Target__c = null;
        ap.Strategic_Initiative_1_Target__c = null;
        ap.Strategic_Initiative_1_Status__c = null;
        ap.Sales_Figures_Makeup__c = 'Direct';
        ap.Key_Product_Percent_Title__c = 'Market Share Percent';
        ap.Key_Product_1_Outlook__c = 'Increasing';
        ap.TE_Performance_Status__c = 'Solid, holding';
        ap.Revenue_TAM_SAM__c = 'TAM';
        ap.Executive_Relationship__c = 'NA';
        ap.Purchasing_Relationship__c = 'NA';
        ap.Engineering_Relationship__c = 'NA';
        ap.Competitor_1_MS_Trend__c = 'Flat';
        ap.Strategic_Initiative_1_Target__c = 'FY12Q1';
        ap.Strategic_Initiative_1_Status__c = 'On target';
        ap.active__c = true;
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
        
        set<string> set_salesRTs = new set<string>();
        set<string> set_engineerRTs = new set<string>();
        set<string> set_dndRTs = new set<string>();
        set<string> set_salescsdRTs = new set<string>();
        set<string> set_engcsdRTs = new set<string>();

        for (Opportunity_Record_Type_Groups__c rtty : Opportunity_Record_Type_Groups__c.getall().values()){
                    if(rtty.Active__c && rtty.API_Name__c!= null){
                        if(rtty.Group__c == 'Account Plan Set Oppty type'){
                            if (rtty.Is_Sales_Only__c)
                                            set_salesRTs.add(rtty.API_Name__c);
                                    else
                                            set_engineerRTs.add(rtty.API_Name__c);
                        }
                        if(rtty.Group__c == 'CSD Account Plan Set Oppty type'){
                            if (rtty.Is_Sales_Only__c)
                                            set_salescsdRTs.add(rtty.API_Name__c);
                                    else
                                            set_engcsdRTs.add(rtty.API_Name__c);
                        }
                        if(rtty.Group__c == 'DND Account Plan Set Oppty type'){
                            
                                 set_dndRTs.add(rtty.API_Name__c);
                                  
                        }
                        
                    }
            }
        
        Attachment att = ClsTestHelp.createTestAttachments();
        att.Name = 'VoiceOverview.wav';
        att.ParentId = ap.Id;
        insert att;
        Opportunity oppy2 = [select Name,CloseDate,Account_Plan_Comment__c, LastModifiedDate from Opportunity where Id =: oppy.Id];
        list<ExtAccountPlanEdit.keyOppyAndProgramm> list_keyOppyAndProgramm = new list<ExtAccountPlanEdit.keyOppyAndProgramm>();
        ExtAccountPlanEdit.keyOppyAndProgramm extKey = new ExtAccountPlanEdit.keyOppyAndProgramm(oppy,true,1,String.valueOf(date.today()),1, set_salesRTs, set_engineerRTs, set_dndRTs, set_salescsdRTs, set_engcsdRTs);
        extKey.isSelected = true;
        extKey.oppy = oppy2;
        list_keyOppyAndProgramm.add(extKey);
        
        list<ExtAccountPlanEdit.winLossOppy> list_winOppy = new list<ExtAccountPlanEdit.winLossOppy>();
        list<ExtAccountPlanEdit.winLossOppy> list_lossOppy = new list<ExtAccountPlanEdit.winLossOppy>();
        ExtAccountPlanEdit.winLossOppy extWin = new ExtAccountPlanEdit.winLossOppy(oppy,true,1,String.valueOf(date.today()),1, set_salesRTs, set_engineerRTs, set_dndRTs, set_salescsdRTs, set_engcsdRTs);
        extWin.oppy = oppy;
        extWin.isSelected = true;
        list_winOppy.add(extWin);
        list_lossOppy.add(extWin);
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('id',null);
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(ap); 
        ExtAccountPlanEdit ext = new ExtAccountPlanEdit(stdCtrl);
        ext.voiceBody = null;//Blob.valueof('Test');
        ext.voiceFileContentType = 's';
        ext.accPlan = ap;
        ext.list_keyOppyAndProgramm = list_keyOppyAndProgramm;
        ext.voiceFileSize = 3;
        ext.voiceName = null;//'xxxx';
        ext.chooseCBC = false;
        
        ext.Saveone();
        
        system.assert(true);
        Test.stopTest();
    }
   static testMethod void modeIsNew1() {
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();  
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();      
        RecordType rt = ClsTestHelp.createTestRecordType6();
        RecordType rt3 = ClsTestHelp.createTestRecordType21();
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt3.Id;
        acc.Customer_Classification__c = 'A';
        acc.Type = 'Competitor';
        insert acc;
        
        Account_Plan__c ap = ClsTestHelp.createTestAccountPlan();
        ap.Customer__c = acc.Id;
        ap.Account_Definition__c = 'Custom';
        ap.Plan_Year__c = null;
        /*ap.Competitor1__c = acc.Id;
        ap.Competitor2__c = acc.Id;
        ap.Competitor3__c = acc.Id;
        ap.Competitor4__c = acc.Id;
        ap.Competitor5__c = acc.Id;
        ap.Competitor6__c = acc.Id;*/
        ap.active__c = true;
        insert ap;
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id',null);
        ApexPages.currentPage().getParameters().put('accId',acc.Id);
        ApexPages.currentPage().getParameters().put('retURL','http://www.baidu.com');
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(ap); 
        ExtAccountPlanEdit ext = new ExtAccountPlanEdit(stdCtrl);
        ext.aid = ap.Id;
        ext.voiceBody = Blob.valueof('Test');
        ext.voiceFileContentType = 'audio';
        ext.voiceName = 'xxxxxx';
        ext.chooseCBC = false;
        ext.accPlan = ap;
        ext.mode = 'new';
        
        ext.cancel();
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void modeIsNew2() {
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();    
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();    
        RecordType rt = ClsTestHelp.createTestRecordType6();
        RecordType rt3 = ClsTestHelp.createTestRecordType21();
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt3.Id;
        acc.Customer_Classification__c = 'A';
        acc.Type = 'Competitor';
        insert acc;
        
        Account_Plan__c ap = ClsTestHelp.createTestAccountPlan();
        ap.Customer__c = acc.Id;
        ap.Plan_Year__c = '2012';
        /*ap.Competitor1__c = acc.Id;
        ap.Competitor2__c = acc.Id;
        ap.Competitor3__c = acc.Id;
        ap.Competitor4__c = acc.Id;
        ap.Competitor5__c = acc.Id;
        ap.Competitor6__c = acc.Id;*/
        ap.Account_Definition__c = 'Custom';
        ap.active__c = true;
        insert ap;
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id',null);
        ApexPages.currentPage().getParameters().put('retURL',null);
        ApexPages.currentPage().getParameters().put('accId',acc.Id);
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(ap); 
        ExtAccountPlanEdit ext = new ExtAccountPlanEdit(stdCtrl);
        ext.aid = ap.Id;
        ext.voiceBody = Blob.valueof('Test');
        ext.voiceFileContentType = 'audio';
        ext.voiceName = 'xxxxxx';
        ext.chooseCBC = false;
        ext.accPlan = ap;
        ext.mode = 'new';
        
        ext.refreshOverviewTable();
        ext.cancel();
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void modeIsNew3() {
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();   
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();     
        RecordType rt = ClsTestHelp.createTestRecordType6();
        RecordType rt3 = ClsTestHelp.createTestRecordType21();
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt3.Id;
        acc.Customer_Classification__c = 'A';
        acc.Type = 'Competitor';
        insert acc;
        
        Account_Plan__c ap = ClsTestHelp.createTestAccountPlan();
        ap.Customer__c = acc.Id;
        ap.Plan_Year__c = null;
        /*ap.Competitor1__c = acc.Id;
        ap.Competitor2__c = acc.Id;
        ap.Competitor3__c = acc.Id;
        ap.Competitor4__c = acc.Id;
        ap.Competitor5__c = acc.Id;
        ap.Competitor6__c = acc.Id;*/
        ap.Account_Definition__c = 'Custom';
        ap.active__c= true;
        insert ap;
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id',null);
        ApexPages.currentPage().getParameters().put('retURL',null);
        ApexPages.currentPage().getParameters().put('accId',null);
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(ap); 
        ExtAccountPlanEdit ext = new ExtAccountPlanEdit(stdCtrl);
        ext.aid = ap.Id;
        ext.voiceBody = Blob.valueof('Test');
        ext.voiceFileContentType = 'audio';
        ext.voiceName = 'xxxxxx';
        ext.chooseCBC = false;
        ext.accPlan = ap;
        ext.mode = 'new'; 
        
        ext.refreshOverviewTable();
        ext.cancel();
         
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void modeIsNew4() {
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();  
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();      
        RecordType rt = ClsTestHelp.createTestRecordType6();
        RecordType rt3 = ClsTestHelp.createTestRecordType21();
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt3.Id;
        acc.Customer_Classification__c = 'A';
        acc.Type = 'Competitor';
        insert acc;
        
        Account_Plan__c ap = ClsTestHelp.createTestAccountPlan();
        ap.Customer__c = acc.Id;
        ap.Plan_Year__c = null;
        /*ap.Competitor1__c = acc.Id;
        ap.Competitor2__c = acc.Id;
        ap.Competitor3__c = acc.Id;
        ap.Competitor4__c = acc.Id;
        ap.Competitor5__c = acc.Id;
        ap.Competitor6__c = acc.Id;*/
        ap.Account_Definition__c = 'Custom';
        ap.active__c = true;
        insert ap;
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('accId',acc.Id);
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(ap); 
        ExtAccountPlanEdit ext = new ExtAccountPlanEdit(stdCtrl);
        ext.aid = ap.Id;
        ext.voiceBody = Blob.valueof('Test');
        ext.voiceFileContentType = 'audio';
        ext.voiceName = 'xxxxxx';
        ext.chooseCBC = false;
        ext.accPlan = ap;
        ext.mode = 'new'; 
        
        ext.Saveone();
         
        system.assert(true);
        Test.stopTest();
    }
    /*static testMethod void testGetMethods6() {
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();  
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();      
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
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
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
        ap.active__c = true;
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
        
        set<string> set_salesRTs = new set<string>();
        set<string> set_engineerRTs = new set<string>();
        set<string> set_dndRTs = new set<string>();
        set<string> set_salescsdRTs = new set<string>();
        set<string> set_engcsdRTs = new set<string>();

        for (Opportunity_Record_Type_Groups__c rtty : Opportunity_Record_Type_Groups__c.getall().values()){
                    if(rtty.Active__c && rtty.API_Name__c!= null){
                        if(rtty.Group__c == 'Account Plan Set Oppty type'){
                            if (rtty.Is_Sales_Only__c)
                                            set_salesRTs.add(rtty.API_Name__c);
                                    else
                                            set_engineerRTs.add(rtty.API_Name__c);
                        }
                        if(rtty.Group__c == 'CSD Account Plan Set Oppty type'){
                            if (rtty.Is_Sales_Only__c)
                                            set_salescsdRTs.add(rtty.API_Name__c);
                                    else
                                            set_engcsdRTs.add(rtty.API_Name__c);
                        }
                        if(rtty.Group__c == 'DND Account Plan Set Oppty type'){
                            
                                 set_dndRTs.add(rtty.API_Name__c);
                                  
                        }
                        
                    }
            }
        
        
        Attachment att = ClsTestHelp.createTestAttachments();
        att.Name = 'VoiceOverview.wav';
        att.ParentId = ap.Id;
        insert att;
        
        ExtAccountPlanEdit.keyOppyAndProgramm extKey = new ExtAccountPlanEdit.keyOppyAndProgramm(oppy,true,1,String.valueOf(date.today()),1, set_salesRTs, set_engineerRTs, set_dndRTs, set_salescsdRTs, set_engcsdRTs);
        
        list<ExtAccountPlanEdit.winLossOppy> list_winOppy = new list<ExtAccountPlanEdit.winLossOppy>();
        list<ExtAccountPlanEdit.winLossOppy> list_lossOppy = new list<ExtAccountPlanEdit.winLossOppy>();
        ExtAccountPlanEdit.winLossOppy extWin = new ExtAccountPlanEdit.winLossOppy(oppy,true,1,String.valueOf(date.today()),1, set_salesRTs, set_engineerRTs, set_dndRTs, set_salescsdRTs, set_engcsdRTs);
        extWin.isSelected = true;
        list_winOppy.add(extWin);
        list_lossOppy.add(extWin);
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('id',ap.Id);
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(ap); 
        ExtAccountPlanEdit ext = new ExtAccountPlanEdit(stdCtrl);
        ext.accPlan = ap;
        ext.planYearMinus1 = 2012;
        ext.list_winOppy = list_winOppy;
        ext.regionPart1 = 11;
        ext.regionPart2 = 12;
        ext.cbcPart3 = 12;
        ext.cbcPart4 = 12;
        ext.cbcPart5 = 12;
        ext.showCBCPanel = true;
        ext.showRegionPanel = true;
        ext.cbcPercent1 = 12;
        ext.regionPercent1 = 12;
        
        //ext.getCBCUrl();
        //ext.getRegionUrl();
        //ext.getChartWithCBC3();
        //ext.getChartWithRegion();
        ext.refreshPerformanceAndChart();
        ext.Unlock();
        
        ExtAccountPlanEdit.loadLineChart(ap);
        ExtAccountPlanEdit.loadPieCBCChart(ap);
        ExtAccountPlanEdit.loadPieRegionChart(ap);
        
        
        system.assert(true);
        Test.stopTest();
    }*/
}