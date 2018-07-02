/**
*   This test class is for APL_CompForecastBillingChart.
*
@author Yuda Zheng
@created 2015-06-12
@version 1.0
@since 29.0
*
@changelog
* 2015-06-12 Yuda Zheng <yuda.zheng@itbconsult.com>
* - Created
* - Test coverage 78%
@changelog
* 2016-10-5 Mrunal Parate
* - Modified
* - Test coverage 86%
*/
@isTest
private class APL_CompForecastBillingChart_Test {
    @testSetup static void setData(){
        // TO DO: implement unit test
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();
        
        RecordType rt2 = ClsTestHelp.createTestRecordType8();
        
        Consumer_Device_Opportunity_Record_Types__c cdort1 = ClsTestHelp.createTestCSD1();
        Consumer_Device_Opportunity_Record_Types__c cdort2 = ClsTestHelp.createTestCSD2();
        Consumer_Device_Opportunity_Record_Types__c cdort3 = ClsTestHelp.createTestCSD3();
        Consumer_Device_Opportunity_Record_Types__c cdort4 = ClsTestHelp.createTestCSD4();
        Consumer_Device_Opportunity_Record_Types__c cdort5 = ClsTestHelp.createTestCSD5();
        Consumer_Device_Opportunity_Record_Types__c cdort6 = ClsTestHelp.createTestCSD6();
        Consumer_Device_Opportunity_Record_Types__c cdort7 = ClsTestHelp.createTestCSD7();
        
        
        
        Profile p = [Select Id, Name From Profile 
                                    where Name = 'Appliance Standard User'
                                    limit 1];
        List<User> uList = new List<User>();                            
        User uRSM = ClsTestHelp.createTestUsers();
        uRSM.Email = 'helloSand0728@testCompany1407281004.com';
        uRSM.FirstName ='Test0728';
        uRSM.LastName = 'User0728';
        uRSM.Alias = 'dpse0728';
        uRSM.CommunityNickname = 'TMD0728';
        uRSM.ProfileId = p.Id;
        uRSM.GIBU__c = 'Appliances';
        uRSM.Username = 'helloSand0728mr@testCompany1407281004.com';
        uList.add(uRSM);
        User uAM = ClsTestHelp.createTestUsers();
        uAM.Email = 'helloSand0728@testCompany1407281004.com';
        uAM.FirstName ='Test0728';
        uAM.LastName = 'User0728';
        uAM.Alias = 'dpse0723';
        uAM.CommunityNickname = 'TMD07281';
        uAM.ProfileId = p.Id;
        uAM.GIBU__c = 'Appliances';
        uAM.Te_Network_Id__c = 'TE128763';
        uAM.Username = 'helloSand072811mr@testCompany1407281004.com';
        uList.add(uAM);
        insert uList;
        
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
        sh.Level_2_Territory_Code__c = '103004';
        //sh.Level_7_Default_Owner__c = uAM.Id;
        sh.Level_7_Assigned_User_Network_Ids__c = 'TE128763';
        sh.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
        insert sh;
        
        List<Trigger_Configuration__c> lstTriggerConfig = new  List<Trigger_Configuration__c>();
       
        Trigger_Configuration__c tc = new Trigger_Configuration__c(); 
        tc.Name='Avoid Duplicate PLM Id';
        tc.isRun__c=true;
        lstTriggerConfig .add(tc);
               
        Trigger_Configuration__c tc2 = new Trigger_Configuration__c(); 
        tc2.Name='DND Lead Conversion Initialization';
        tc2.isRun__c=true;
        lstTriggerConfig .add(tc2);
        
        Trigger_Configuration__c tc3 = new Trigger_Configuration__c(); 
        tc3.Name='Identify Fiscal Year';
        tc3.isRun__c=true;
        lstTriggerConfig .add(tc3);
        
        Trigger_Configuration__c tc4 = new Trigger_Configuration__c(); 
        tc4.Name='Populate Opportunity Partner';
        tc4.isRun__c=true;
        lstTriggerConfig .add(tc4);
        
        Trigger_Configuration__c tc5 = new Trigger_Configuration__c(); 
        tc5.Name='updateAccountBusinessUnit';
        tc5.isRun__c=true;
        lstTriggerConfig .add(tc5);
        
        insert lstTriggerConfig ;
        
        List<Account> accList = new List<Account>();
        
        Account acct = ClsTestHelp.createTestAccounts();
        acct.Name = 'axx';
        acct.RecordTypeId = rt2.Id;
        acct.AccountNumber = '123456';
        acct.APL_Relay_forecast_Plan_Account__c = acct.Id;
        acct.APL_Relay_Currency__c = 'USD';
        acct.APL_Relay_Display_Name__c = 'testName';
        acct.APL_AM_forecast_Plan_Account__c = acct.Id;
        acct.APL_AM_Currency__c = 'USD';
        acct.APL_AM_Display_Name__c = 'acct';
        //acct.Account_Manager__c = uAM.Id;
        acct.Account_Manager__c = uAM.Id;
        acct.STATDESC__c = 'Active';
        acct.GAMCD__c = '1234'; 
        acct.SALES_TERRITORY_CDE__c = '123456';
        acct.Relay_Specialist_Territory_Code__c = '123456';  
        acct.Relay_Hierarchy__c = sh.Id; 
        insert acct;
        
        Account relayAcct = ClsTestHelp.createTestAccounts();
        relayAcct.Name = 'relayAcctaxx';
        relayAcct.RecordTypeId = rt2.Id;
        //relayAcct.Account_Manager__c = uAM.Id;
        relayAcct.Account_Manager__c = uAM.Id;
        relayAcct.APL_Relay_forecast_Plan_Account__c = acct.Id;
        relayAcct.APL_AM_forecast_Plan_Account__c = acct.Id;
        relayAcct.APL_Relay_Currency__c = 'USD';
        relayAcct.APL_Relay_Display_Name__c = 'testName';
        relayAcct.APL_AM_Display_Name__c = 'relayAcct';
        relayAcct.APL_Relay_ParentAccount__c = acct.Id;
        relayAcct.SALES_TERRITORY_CDE__c = '123456';
        relayAcct.Relay_Specialist_Territory_Code__c = '123456';  
        relayAcct.GAMCD__c = '1234'; 
        relayAcct.Sales_Hierarchy__c = sh.Id;   
        relayAcct.Relay_Hierarchy__c = sh.Id; 
        relayAcct.STATDESC__c = 'Active';
        accList.add(relayAcct);
        
        Account relayAcct1 = ClsTestHelp.createTestAccounts();
        relayAcct1.Name = 'relayAcctaxx';
        relayAcct1.RecordTypeId = rt2.Id;
        //relayAcct1.Account_Manager__c = uAM.Id;
        relayAcct1.Account_Manager__c = uAM.Id;
        relayAcct1.APL_Relay_forecast_Plan_Account__c = acct.Id;
        relayAcct1.APL_Relay_Currency__c = 'USD';
        relayAcct1.APL_Relay_Display_Name__c = 'testName';
        relayAcct1.APL_AM_Display_Name__c = 'relayAcct1';
        relayAcct1.APL_Relay_ParentAccount__c = acct.Id;
        relayAcct1.SALES_TERRITORY_CDE__c = '123456';   
        relayAcct1.GAMCD__c = '1234';   
        relayAcct1.Relay_Hierarchy__c = sh.Id; 
        relayAcct1.Relay_Specialist_Territory_Code__c = '123456';
        relayAcct1.APL_Relay_forecast_Plan_Account__c = acct.Id;
        relayAcct1.STATDESC__c = 'Active';
        accList.add(relayAcct1);
        
        Account amAcct = ClsTestHelp.createTestAccounts();
        amAcct.Name = 'axx';
        amAcct.RecordTypeId = rt2.Id;
        amAcct.APL_AM_forecast_Plan_Account__c = acct.Id;
        amAcct.APL_AM_Currency__c = 'USD';
        amAcct.APL_AM_Display_Name__c = 'amAcct';
        amAcct.APL_AM_ParentAccount__c = acct.Id;       
        //amAcct.Account_Manager__c = uAM.Id;
        amAcct.Account_Manager__c = uAM.Id;
        amAcct.SALES_TERRITORY_CDE__c = '123456';
        amAcct.Relay_Specialist_Territory_Code__c = '123456';
        amAcct.APL_Relay_forecast_Plan_Account__c = acct.Id;
        amAcct.APL_Relay_Display_Name__c = 'testName';
        amAcct.GAMCD__c = '1234';
        amAcct.Relay_Hierarchy__c = sh.Id; 
        amAcct.Sales_Hierarchy__c = sh.Id;  
        amAcct.STATDESC__c = 'Active';
        accList.add(amAcct);
        
        Account amAcct1 = ClsTestHelp.createTestAccounts();
        amAcct1.Name = 'axx';
        amAcct1.RecordTypeId = rt2.Id;
        amAcct1.APL_AM_forecast_Plan_Account__c = null;
        amAcct1.APL_AM_Currency__c = 'USD';
        amAcct1.APL_AM_Display_Name__c = 'amAcct1';
        amAcct1.APL_AM_ParentAccount__c = acct.Id;      
        //amAcct1.Account_Manager__c = uAM.Id;
        amAcct1.Account_Manager__c = uAM.Id;
        amAcct1.SALES_TERRITORY_CDE__c = '123456';
        amAcct1.Relay_Hierarchy__c = sh.Id; 
        amAcct1.Relay_Specialist_Territory_Code__c = '123456';
        amAcct1.APL_Relay_forecast_Plan_Account__c = acct.Id;
        amAcct1.APL_Relay_Display_Name__c = 'testName';
        amAcct1.GAMCD__c = '1234';
        amAcct1.Sales_Hierarchy__c = sh.Id; 
        amAcct1.STATDESC__c = 'Active';
        accList.add(amAcct1);
        insert accList;
        
        List<Product_Hierarchy__c> prdHierList = new List<Product_Hierarchy__c>();
        Product_Hierarchy__c phNonRelay = new Product_Hierarchy__c();
        phNonRelay.Name = '123';
        phNonRelay.CBC2__c = '30012';
        phNonRelay.CBC3__c = '30033';
        phNonRelay.CBC1_Description__c = 'Appliances';
        phNonRelay.GPL_Description__c = 'test';
        prdHierList.add(phNonRelay);
        
        Product_Hierarchy__c phNonRelay1 = new Product_Hierarchy__c();
        phNonRelay1.Name = '123';
        phNonRelay1.CBC2__c = '30000';
        phNonRelay1.CBC3__c = '30000';
        phNonRelay1.CBC1_Description__c = 'Appliances';
        phNonRelay1.GPL_Description__c = 'test';
        prdHierList.add(phNonRelay1);
        
        Product_Hierarchy__c phRelay = new Product_Hierarchy__c();
        phRelay.Name = '1234';
        phRelay.CBC2__c = '13213';
        phRelay.CBC3__c = '30042';
        phRelay.CBC1_Description__c = 'Appliances';
        phRelay.GPL_Description__c = 'test';
        prdHierList.add(phRelay);
        
        Product_Hierarchy__c phRelay1 = new Product_Hierarchy__c();
        phRelay1.Name = '1234';
        phRelay1.CBC1__c = '45678';
        phRelay1.CBC2__c = '45678';
        phRelay1.CBC3__c = '40308';
        phRelay1.CBC1_Description__c = 'Appliances';
        prdHierList.add(phRelay1);
        insert prdHierList;
        
        List<Part__c> partList = new List<Part__c>();
        Part__c partNonRelay = new Part__c();
        partNonRelay.Name = 'testPart';
        partNonRelay.GPL__c = phNonRelay.Id;
        partNonRelay.Product_Hierarchy__c = phNonRelay.Id; 
        partNonRelay.Description__c = 'test';
        partNonRelay.PRODUCT_CDE__c = 'TEST1';
        partNonRelay.PROD_NAME__c = 'test name1';
        partList.add(partNonRelay);
        
        Part__c partNonRelay1 = new Part__c();
        partNonRelay1.Name = 'testPart';
        partNonRelay1.GPL__c = phNonRelay1.Id;
        partNonRelay1.Product_Hierarchy__c = phNonRelay1.Id; 
        partNonRelay1.Description__c = 'test';
        partNonRelay1.PRODUCT_CDE__c = 'TEST1';
        partNonRelay1.PROD_NAME__c = 'test name1';
        partList.add(partNonRelay1);
        
        Part__c partRelay = new Part__c();
        partRelay.Name = 'testPart';
        partRelay.GPL__c = phRelay.Id;
        partRelay.Product_Hierarchy__c = phRelay.Id; 
        partRelay.Description__c = 'test';
        partRelay.PRODUCT_CDE__c = 'TEST2';
        partRelay.PROD_NAME__c = 'test name2';
        partList.add(partRelay);
        
        Part__c partRelay1 = new Part__c();
        partRelay1.Name = 'testPart';
        partRelay1.GPL__c = phRelay1.Id;
        partRelay1.Product_Hierarchy__c = phRelay1.Id; 
        partRelay1.Description__c = 'test';
        partRelay1.PRODUCT_CDE__c = 'TEST3';
        partRelay1.PROD_NAME__c = 'test name3';
        partList.add(partRelay1);
        insert partList;
        
        List<APL_Sales_Forecast__c> sForecastList = new List<APL_Sales_Forecast__c>();
        APL_Sales_Forecast__c aplFCNonRelay = new APL_Sales_Forecast__c();
        aplFCNonRelay.type__c = 'GPL';
        aplFCNonRelay.Forecast__c = 10;
        aplFCNonRelay.Fiscal_Year__c = '2015';
        aplFCNonRelay.Fiscal_Quarter__c = '03';
        aplFCNonRelay.customer__c = amAcct.Id;
        aplFCNonRelay.RSM_Forecast__c = 10;
        aplFCNonRelay.GPL__c = phNonRelay.Id;
        aplFCNonRelay.Part__c = partNonRelay.Id;
        aplFCNonRelay.GAM_Forecast__c = 10;
        sForecastList.add(aplFCNonRelay);
        
        APL_Sales_Forecast__c aplFCRelay = new APL_Sales_Forecast__c();
        aplFCRelay.type__c = 'Relay Product Code';
        aplFCRelay.Fiscal_Year__c = '2015';
        aplFCRelay.Fiscal_Quarter__c = '03';
        aplFCRelay.Forecast__c = 10;
        aplFCRelay.customer__c = relayAcct.Id;
        aplFCRelay.PRODUCT_CDE__c = partRelay.PRODUCT_CDE__c;
        aplFCRelay.PROD_NAME__c = partRelay.PROD_NAME__c;
        aplFCRelay.Relay_CBC2_Code__c = phRelay.CBC2__c;
        aplFCRelay.GPL__c = phRelay.Id;
        aplFCRelay.RSM_Forecast__c = 10;
        aplFCRelay.GAM_Forecast__c = 10;
        sForecastList.add(aplFCRelay);
        
        
        APL_Sales_Forecast__c aplFCRelay1 = new APL_Sales_Forecast__c();
        aplFCRelay1.type__c = 'Other CBC2';
        aplFCRelay1.Fiscal_Year__c = '2015';
        aplFCRelay1.Fiscal_Quarter__c = '03';
        aplFCRelay1.customer__c = relayAcct.Id;
        aplFCRelay1.Forecast__c = 10;
        aplFCRelay1.PRODUCT_CDE__c = partRelay.PRODUCT_CDE__c;
        aplFCRelay1.PROD_NAME__c = partRelay.PROD_NAME__c;
        aplFCRelay1.Relay_CBC2_Code__c = phRelay.CBC2__c;
        aplFCRelay1.GPL__c = phRelay.Id;
        aplFCRelay1.RSM_Forecast__c = 10;
        aplFCRelay1.GAM_Forecast__c = 10;
        sForecastList.add(aplFCRelay1);
        insert sForecastList;
        
        List<APL_RSM__c> aplRsmList = new List<APL_RSM__c>();
        APL_RSM__c aplRsm = new APL_RSM__c();
        aplRsm.Manager__c = uRSM.Id;
        aplRsm.Display_Name__c = 'test';
        aplRsmList.add(aplRsm);
        
        APL_RSM__c aplRsm1 = new APL_RSM__c();
        aplRsm1.Manager__c = UserInfo.getUserId();//uRSM.Id;
        aplRsm1.Type__c = 'Relay';
        aplRsm1.Display_Name__c = 'test2';
        aplRsmList.add(aplRsm1);
        
        APL_RSM__c aplRsm2 = new APL_RSM__c();
        aplRsm2.Manager__c = UserInfo.getUserId();//uRSM.Id;
        aplRsm2.Type__c = 'AM';
        aplRsm2.Display_Name__c = 'test1';
        aplRsm2.APL_RSM__c = aplRsm1.Id;
        aplRsmList.add(aplRsm2);
        insert aplRsmList;
        
        RecordType rt25 = ClsTestHelp.createTestRecordType25(); 
        List<APL_Forecast_Management__c> fmgmtList = new List<APL_Forecast_Management__c>();
        APL_Forecast_Management__c apl = new APL_Forecast_Management__c();
        apl.Name = 'testName';
        apl.A6_Code__c = '123456';
        apl.Manager__c = UserInfo.getUserId();  
        apl.RSM__c = aplRsm2.Id;
        apl.GAM_Code__c = '1234';
        apl.RecordTypeId = rt25.Id;
        fmgmtList.add(apl);
        
        APL_Forecast_Management__c apl1 = new APL_Forecast_Management__c();
        apl1.Name = 'testName1';
        apl1.A6_Code__c = '123456';
        apl1.GAM_Code__c = '1234';
        apl1.Manager__c = UserInfo.getUserId();
        apl1.RecordTypeId = rt25.Id;
        apl1.RSM__c = aplRsm1.Id;
        fmgmtList.add(apl1);
        insert fmgmtList;
        
        List<BBB_Month_Bill_Book_Cust_PN__c> mBBBList = new List<BBB_Month_Bill_Book_Cust_PN__c>();
        BBB_Month_Bill_Book_Cust_PN__c bbbMon = new BBB_Month_Bill_Book_Cust_PN__c();
        bbbMon.Customer__c = amAcct.Id;
        bbbMon.Bill_Amount_USD__c = 10;
        bbbMon.Book_Amount_USD__c = 10; 
        bbbMon.Fiscal_Year__c = '2015';
        bbbMon.Fiscal_Month__c = 5;
        bbbMon.Profit_Center__c = 'APL';
        bbbMon.Part__c = partNonRelay.Id;
        mBBBList.add(bbbMon);
        
        BBB_Month_Bill_Book_Cust_PN__c bbbMon1 = new BBB_Month_Bill_Book_Cust_PN__c();
        bbbMon1.Customer__c = amAcct.Id;
        bbbMon1.Bill_Amount_USD__c = 10;
        bbbMon1.Book_Amount_USD__c = 10; 
        bbbMon1.Fiscal_Year__c = '2015';
        bbbMon1.Fiscal_Month__c = 5;
        bbbMon1.Profit_Center__c = 'APL';
        bbbMon1.Part__c = partNonRelay1.Id;
        mBBBList.add(bbbMon1);
        
        BBB_Month_Bill_Book_Cust_PN__c bbbMonRelay = new BBB_Month_Bill_Book_Cust_PN__c();
        bbbMonRelay.Customer__c = amAcct.Id;
        bbbMonRelay.Bill_Amount_USD__c = 10;
        bbbMonRelay.Book_Amount_USD__c = 10; 
        bbbMonRelay.Fiscal_Year__c = '2015';
        bbbMonRelay.Fiscal_Month__c = 5;
        bbbMonRelay.Profit_Center__c = 'APL';
        bbbMonRelay.Part__c = partRelay.Id;
        mBBBList.add(bbbMonRelay);
        
        BBB_Month_Bill_Book_Cust_PN__c bbbMonRelay1 = new BBB_Month_Bill_Book_Cust_PN__c();
        bbbMonRelay1.Customer__c = amAcct.Id;
        bbbMonRelay1.Bill_Amount_USD__c = 10;
        bbbMonRelay1.Book_Amount_USD__c = 10; 
        bbbMonRelay1.Fiscal_Year__c = '2015';
        bbbMonRelay1.Fiscal_Month__c = 5;
        bbbMonRelay1.Profit_Center__c = 'APL';
        bbbMonRelay1.Part__c = partRelay1.Id;
        mBBBList.add(bbbMonRelay1);
        insert mBBBList;
        
        List<BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c> dBBBList = new List<BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c>();
        BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c bbbDay = new BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c();
        bbbDay.Backlog_Amount_USD__c = 10;
        bbbDay.Bill_Amount_USD__c = 10; 
        bbbDay.Book_Amount_USD__c = 10;
        bbbDay.Customer__c = amAcct.Id;
        bbbDay.Fiscal_Year__c = '2015';
        bbbDay.Fiscal_Month__c = 9;
        bbbDay.Customer_Request_Date_Fiscal_Year__c = '2015';
        bbbday.Customer_Request_Date_Fiscal_Month__c = 9;
        bbbDay.Profit_Center__c = 'APL';
        bbbDay.Part__c = partNonRelay.Id;
        dBBBList.add(bbbDay);
        
        BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c bbbDayRelay = new BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c();
        bbbDayRelay.Backlog_Amount_USD__c = 10;
        bbbDayRelay.Bill_Amount_USD__c = 10; 
        bbbDayRelay.Book_Amount_USD__c = 10;
        bbbDayRelay.Customer__c = amAcct.Id;
        bbbDayRelay.Fiscal_Year__c = '2015';
        bbbDayRelay.Fiscal_Month__c = 9;
        bbbDayRelay.Customer_Request_Date_Fiscal_Year__c = '2015';
        bbbDayRelay.Customer_Request_Date_Fiscal_Month__c = 9;
        bbbDayRelay.Profit_Center__c = 'APL';
        bbbDayRelay.Part__c = partRelay.Id;
        dBBBList.add(bbbDayRelay);
        insert dBBBList;
        
        APL_RSM_Overall_Forecast__c aplOver = new APL_RSM_Overall_Forecast__c();
        aplOver.Fiscal_Quarter__c = '04';
        aplOver.Fiscal_Year__c = '2015';
        aplOver.APL_RSM__c = aplRsm.Id;
        aplOver.RSM_Overall_Forecast__c = 10;       
        insert aplOver;
    }
    static testMethod void myUnitTest1() {
        Test.starttest();
        Set<String> territoryCodeSet = new Set<String>();
        territoryCodeSet.add('123456');
        
        List<String> territoryCodeList = new List<String>();
        territoryCodeList.add('123456');
        
        APL_CompForecastBillingChart aPLCFB = new APL_CompForecastBillingChart();
        Integer year  = aPLCFB.getCurrentFiscalYear();
        system.assert(year > 0);

        aPLCFB.source = 'RSM';
        String rsmTCode  = aPLCFB.getRSMTerritoryCode();
        aPLCFB.getTNameByTcode(territoryCodeList);
        aPLCFB.getTNameMapByTcode(territoryCodeSet);
        system.assert(rsmTCode != null);
        
        
        aPLCFB.source = 'RSMRelay';
        String rsmRelayTCode = aPLCFB.getRSMRelayTerritoryCode();
        aPLCFB.getTNameByTcode(territoryCodeList);
        aPLCFB.getTNameMapByTcode(territoryCodeSet);
        system.assert(rsmTCode != null);
        
        
        String productFamily4RSM = aPLCFB.getProductFamily();
        system.assert(productFamily4RSM != null);
        
        String tCodeAMGrouping = aPLCFB.getTcodeAMGroupingMAP();
        system.assert(tCodeAMGrouping != null);
        String rsmGrouping = aPLCFB.getRSMGroupingAMGroupingMAP();
        system.assert(rsmGrouping != null);
        String tcodeRelayGrouping = aPLCFB.getTcodeRelayGroupingMAP();
        system.assert(tcodeRelayGrouping != null);
        String rsmRelayGrouping = aPLCFB.getRSMRelayGroupingRelayGroupingMAP();
        system.assert(rsmRelayGrouping != null);
        
        aPLCFB.source = 'AM';
        String amGrouping = aPLCFB.getAMGrouping();
        system.assert(amGrouping != null);
        
        String productFamily4AM = aPLCFB.getProductFamily();
        system.assert(productFamily4AM != null);
        
        aPLCFB.source = 'Relay';
        String relayGrouping = aPLCFB.getRelayGrouping();
        String relayProductFamily = aPLCFB.getProductFamily();
        system.assert(relayGrouping != null);
        system.assert(relayProductFamily != null);
        
        aPLCFB.source = 'GAM';
        String region = aPLCFB.getRegion();
        system.assert(region != null);
        
        //test AM
        APL_CompForecastBillingChart.SearchData searchData = new APL_CompForecastBillingChart.SearchData();
        searchData.currentFiscalQuarter = '3';
        searchData.fiscalQuarter = '2';
        searchData.currentFiscalYear = '2015';
        searchData.fiscalYear = '2015';
        searchData.source = 'AM' ;
        searchData.territoryCode = '123456;';
        String searchOb = Json.serialize(searchData);
        
        map<String, String> map_billingResultAM = new map<String, String>();
        map_billingResultAM = APL_CompForecastBillingChart.getExportGroup(searchOb); 
        map_billingResultAM = APL_CompForecastBillingChart.getExportData(searchOb);
        map_billingResultAM = APL_CompForecastBillingChart.getChartData(searchOb);
        system.assert(map_billingResultAM.get('fiscalYear') == '2015');
        searchData.fiscalQuarter = '3';
        searchOb = Json.serialize(searchData);
        map<String, String> map_foreCastResultAM = new map<String, String>();
        map_foreCastResultAM = APL_CompForecastBillingChart.getExportGroup(searchOb);
        map_foreCastResultAM = APL_CompForecastBillingChart.getExportData(searchOb);
        map_foreCastResultAM = APL_CompForecastBillingChart.getChartData(searchOb);
        system.assert(map_foreCastResultAM.get('fiscalYear') == '2015');
        
        //test Relay
        searchData.source = 'Relay' ;
        searchData.fiscalQuarter = '2';
        searchData.territoryCode = '123456';
        searchOb = Json.serialize(searchData);
        
        map<String, String> map_billingResultRelay = new map<String, String>();
        APL_CompForecastBillingChart.getRelayChartData(searchData,false);
        APL_CompForecastBillingChart.getRelayChartData(searchData,true);
        map_billingResultRelay = APL_CompForecastBillingChart.getExportGroup(searchOb);
        map_billingResultRelay = APL_CompForecastBillingChart.getExportData(searchOb);
        map_billingResultRelay = APL_CompForecastBillingChart.getChartData(searchOb);
        
        //system.assert(map_billingResultRelay.get('fiscalYear') == '2015');
        searchData.fiscalQuarter = '3';
        searchOb = Json.serialize(searchData);
        APL_CompForecastBillingChart.getRelayChartData(searchData,false);
        APL_CompForecastBillingChart.getRelayChartData(searchData,true);
        map<String, String> map_foreCastResultRelay = new map<String, String>();
        map_foreCastResultRelay = APL_CompForecastBillingChart.getExportGroup(searchOb);
        map_foreCastResultRelay = APL_CompForecastBillingChart.getExportData(searchOb);
        map_foreCastResultRelay = APL_CompForecastBillingChart.getChartData(searchOb);
        system.assert(map_foreCastResultRelay.get('fiscalYear') == '2015');
        
        
        
        //searchData.rSMRelayGrouping = relayGrouping ;// mrunal
        //searchData.territoryCode = rsmRelayTCode ;// mrunal
        Test.stopTest();
    }
    static testMethod void myUnitTest2() {

        Test.startTest();
        APL_CompForecastBillingChart.SearchData searchData = new APL_CompForecastBillingChart.SearchData();
        searchData.currentFiscalQuarter = '3';
        searchData.fiscalQuarter = '2';
        searchData.currentFiscalYear = '2015';
        searchData.fiscalYear = '2015';
        searchData.territoryCode = '123456;';
        //test GAM
        searchData.source = 'GAM' ;
        string searchOb = Json.serialize(searchData);
        map<String, String> map_billingResultGAM = new map<String, String>();
        map_billingResultGAM = APL_CompForecastBillingChart.getExportGroup(searchOb);
        map_billingResultGAM = APL_CompForecastBillingChart.getExportData(searchOb);
        map_billingResultGAM = APL_CompForecastBillingChart.getChartData(searchOb);
        system.assert(map_billingResultGAM.get('fiscalYear') == '2015');
        //searchData.fiscalYear = '2013';
        searchData.fiscalQuarter = '3';
        searchOb = Json.serialize(searchData);
        map<String, String> map_foreCastResultGAM = new map<String, String>();
        map_foreCastResultGAM = APL_CompForecastBillingChart.getExportGroup(searchOb);
        map_foreCastResultGAM = APL_CompForecastBillingChart.getExportData(searchOb);
        map_foreCastResultGAM = APL_CompForecastBillingChart.getChartData(searchOb);
        //system.assert(map_foreCastResultGAM.get('fiscalYear') == '2013');
        
        //test RSM
        searchData.source = 'RSM' ;
        searchData.fiscalYear = '2015';
        searchData.fiscalQuarter = '2';
        searchOb = Json.serialize(searchData);
        map<String, String> map_billingResultRSM = new map<String, String>();
        map_billingResultRSM = APL_CompForecastBillingChart.getExportGroup(searchOb);
        map_billingResultRSM = APL_CompForecastBillingChart.getExportData(searchOb);
        map_billingResultRSM = APL_CompForecastBillingChart.getChartData(searchOb);
        system.assert(map_billingResultRSM.get('fiscalYear') == '2015');
        searchData.fiscalQuarter = '3';
        searchOb = Json.serialize(searchData);
        map<String, String> map_foreCastResultRSM = new map<String, String>();
        map_foreCastResultRSM = APL_CompForecastBillingChart.getExportGroup(searchOb);
        map_foreCastResultRSM = APL_CompForecastBillingChart.getExportData(searchOb);
        map_foreCastResultRSM = APL_CompForecastBillingChart.getChartData(searchOb);
        system.assert(map_foreCastResultRSM.get('fiscalYear') == '2015');

        //test RSM Relay
        searchData.source = 'RSMRelay' ;
        searchData.fiscalQuarter = '2';
        searchOb = Json.serialize(searchData);
        map<String, String> map_billingResultRSMRelay = new map<String, String>();
        map_billingResultRSMRelay = APL_CompForecastBillingChart.getExportGroup(searchOb);
        map_billingResultRSMRelay = APL_CompForecastBillingChart.getExportData(searchOb);
        map_billingResultRSMRelay = APL_CompForecastBillingChart.getChartData(searchOb);
        system.assert(map_billingResultRSMRelay.get('fiscalYear') == '2015');
        searchData.fiscalQuarter = '3';
        searchOb = Json.serialize(searchData);
        map<String, String> map_foreCastResultRSMRelay = new map<String, String>();
        map_foreCastResultRSMRelay = APL_CompForecastBillingChart.getExportGroup(searchOb);
        map_foreCastResultRSMRelay = APL_CompForecastBillingChart.getExportData(searchOb);
        map_foreCastResultRSMRelay = APL_CompForecastBillingChart.getChartData(searchOb);
        system.assert(map_foreCastResultRSMRelay.get('fiscalYear') == '2015');   
        APL_CompForecastBillingChart aplChart = new APL_CompForecastBillingChart();
        aplChart.selectgroupingnames = 'test';
        aplChart.selectCBC2names = 'test';
        aplChart.selectterrtroynames = 'test';
        aplChart.selectproductcodenames = 'test';
        aplChart.viewmode = 'test';
        aplChart.list_Region = new List<String>();
        aplChart.managerType = 'test';
        aplChart.territoryCodeJSON = 'test';
        aplChart.regionJSON = 'test';
        aplChart.source = 'AM';
        aplChart.getCurrentFiscalYear();
        aplChart.source = 'Relay';
        aplChart.getCurrentFiscalYear();
        aplChart.source = 'RSM';
        aplChart.getCurrentFiscalYear();
        aplChart.source = 'RSMRelay';
        aplChart.getCurrentFiscalYear();
        aplChart.calAMGrouping('123456');
        aplChart.getThis();
        aplChart.source = '';
        aplChart.getAMGrouping();
        aplChart.getRelayGrouping();
        aplChart.getRegion();
        Test.stopTest();
    }
  
}