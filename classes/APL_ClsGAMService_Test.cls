/**
 *  This test class is used to test APL_ClsAMService
 *  
 * @author Weihang Li
 * @created 2015-06-12
 * @version 1.0
 * @since 29.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2015-06-12 Weihang Li <weihang.li@itbconsult.com>
 * - Created
 *
 */
@isTest
private class APL_ClsGAMService_Test {

    static testMethod void myUnitTest() {
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
        
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
        sh.Level_2_Territory_Code__c = '103004';
        insert sh;
        
        Account acct = ClsTestHelp.createTestAccounts();
        acct.Name = 'axx';
        acct.RecordTypeId = rt2.Id;
        acct.AccountNumber = '123456';
        acct.APL_Relay_forecast_Plan_Account__c = acct.Id;
        acct.APL_Relay_Currency__c = 'USD';
        acct.APL_Relay_Display_Name__c = 'testName';
        acct.APL_AM_forecast_Plan_Account__c = acct.Id;
        acct.APL_AM_Currency__c = 'USD';
        acct.APL_AM_Display_Name__c = 'amTestName';
        acct.Account_Manager__c = userInfo.getUserId();
        acct.STATDESC__c = 'Active';
        acct.SALES_TERRITORY_CDE__c = '123456';
        acct.Relay_Specialist_Territory_Code__c = '123456';  
        acct.Sales_Hierarchy__c = sh.Id;     
        //acct.Territory_L2_code__c = '103004';
        insert acct;
        
        Account relayAcct = ClsTestHelp.createTestAccounts();
        relayAcct.Name = 'relayAcctaxx';
        relayAcct.RecordTypeId = rt2.Id;
        relayAcct.Account_Manager__c = userInfo.getUserId();
        relayAcct.APL_Relay_forecast_Plan_Account__c = acct.Id;
        relayAcct.APL_AM_forecast_Plan_Account__c = acct.Id;
        relayAcct.APL_Relay_Currency__c = 'USD';
        relayAcct.APL_Relay_Display_Name__c = 'testName';
        relayAcct.APL_Relay_ParentAccount__c = acct.Id;
        relayAcct.SALES_TERRITORY_CDE__c = '123456';
        relayAcct.Relay_Specialist_Territory_Code__c = '123456';  
        relayAcct.GAMCD__c = '1234'; 
        relayAcct.Sales_Hierarchy__c = sh.Id;   
        relayAcct.STATDESC__c = 'Active';
        //relayAcct.Territory_L2_code__c = '103004';
        //insert relayAcct;
        
        Account relayAcct1 = ClsTestHelp.createTestAccounts();
        relayAcct1.Name = 'relayAcctaxx';
        relayAcct1.RecordTypeId = rt2.Id;
        relayAcct1.Account_Manager__c = userInfo.getUserId();
        relayAcct1.APL_Relay_forecast_Plan_Account__c = acct.Id;
        relayAcct1.APL_Relay_Currency__c = 'USD';
        relayAcct1.APL_Relay_Display_Name__c = 'testName';
        relayAcct1.APL_Relay_ParentAccount__c = acct.Id;
        relayAcct1.SALES_TERRITORY_CDE__c = '123456';   
        relayAcct1.GAMCD__c = '1234';   
        relayAcct1.Relay_Specialist_Territory_Code__c = '123456';
        relayAcct1.STATDESC__c = 'Active';
        relayAcct1.Sales_Hierarchy__c = sh.Id;  
        //relayAcct1.Territory_L2_code__c = '103004';
        
        
        Account amAcct = ClsTestHelp.createTestAccounts();
        amAcct.Name = 'axx';
        amAcct.RecordTypeId = rt2.Id;
        amAcct.APL_AM_forecast_Plan_Account__c = acct.Id;
        amAcct.APL_AM_Currency__c = 'USD';
        amAcct.APL_AM_Display_Name__c = 'amTestName';
        amAcct.APL_AM_ParentAccount__c = acct.Id;       
        amAcct.Account_Manager__c = userInfo.getUserId();
        amAcct.SALES_TERRITORY_CDE__c = '123456';
        amAcct.Relay_Specialist_Territory_Code__c = '123456';
        amAcct.GAMCD__c = '1234';
        amAcct.Sales_Hierarchy__c = sh.Id;  
        amAcct.STATDESC__c = 'Active';
        //amAcct.Territory_L2_code__c = '103004';
        //insert amAcct;
        
        
        Account amAcct1 = ClsTestHelp.createTestAccounts();
        amAcct1.Name = 'axx';
        amAcct1.RecordTypeId = rt2.Id;
        amAcct1.APL_AM_forecast_Plan_Account__c = null;
        amAcct1.APL_AM_Currency__c = 'USD';
        amAcct1.APL_AM_Display_Name__c = 'amTestName';
        amAcct1.APL_AM_ParentAccount__c = acct.Id;      
        amAcct1.Account_Manager__c = userInfo.getUserId();
        amAcct1.SALES_TERRITORY_CDE__c = '123456';
        amAcct1.Relay_Specialist_Territory_Code__c = '123456';
        amAcct1.GAMCD__c = '1234';
        amAcct1.Sales_Hierarchy__c = sh.Id; 
        //amAcct1.Territory_L2_code__c = '103004';
        //insert amAcct1;
        insert new list<account>{relayAcct, relayAcct1, amAcct, amAcct1};
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Name = '123';
        ph.CBC2__c = '30012';
        ph.CBC3__c = '30033';
        ph.CBC1_Description__c = 'Appliances';
        //insert ph;
        
        Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
        ph1.Name = '1234';
        ph1.CBC2__c = '13213';
        ph1.CBC3__c = '30033';
        ph1.CBC1_Description__c = 'Appliances';
        //insert ph1;
        
        Product_Hierarchy__c ph2 = new Product_Hierarchy__c();
        ph2.Name = '1234';
        ph2.CBC1__c = '45678';
        ph2.CBC2__c = '13213';
        ph2.CBC3__c = '30033';
        ph2.CBC1_Description__c = 'Appliances';
        insert new list<Product_Hierarchy__c >{ph, ph1, ph2};
        
        Part__c part = new Part__c();
        part.Name = 'testPart';
        part.GPL__c = ph.Id;
        part.Product_Hierarchy__c = ph.Id; 
        part.Description__c = 'test';
        part.PRODUCT_CDE__c = 'TEST1';
        part.PROD_NAME__c = 'test name1';
        //insert part;
        
        Part__c part1 = new Part__c();
        part1.Name = 'testPart';
        part1.GPL__c = ph1.Id;
        part1.Product_Hierarchy__c = ph1.Id; 
        part1.Description__c = 'test';
        part1.PRODUCT_CDE__c = 'TEST2';
        part1.PROD_NAME__c = 'test name2';
        //insert part1;
        
        Part__c part2 = new Part__c();
        part2.Name = 'testPart';
        part2.GPL__c = ph2.Id;
        part2.Product_Hierarchy__c = ph2.Id; 
        part2.Description__c = 'test';
        part2.PRODUCT_CDE__c = 'TEST3';
        part2.PROD_NAME__c = 'test name3';
        insert new list<part__c>{part, part1, part2};
        
        APL_Sales_Forecast__c aplFC1 = new APL_Sales_Forecast__c();
        aplFC1.type__c = 'GPL';
        aplFC1.Fiscal_Year__c = '2015';
        aplFC1.Fiscal_Quarter__c = '04';
        aplFC1.customer__c = amAcct.Id;
        aplFC1.RSM_Forecast__c = 10;
        aplFC1.GPL__c = ph.Id;
        aplFC1.Part__c = part.Id;
        //insert aplFC1;
        
        APL_Sales_Forecast__c aplFC3 = new APL_Sales_Forecast__c();
        aplFC3.type__c = 'Relay Product Code';
        aplFC3.Fiscal_Year__c = '2015';
        aplFC3.Fiscal_Quarter__c = '04';
        aplFC3.customer__c = relayAcct.Id;
        aplFC3.PRODUCT_CDE__c = part1.PRODUCT_CDE__c;
        aplFC3.PROD_NAME__c = part1.PROD_NAME__c;
        aplFC3.Relay_CBC2_Code__c = ph1.CBC2__c;
        aplFC3.RSM_Forecast__c = 10;
        //insert aplFC3;
        
        
        APL_Sales_Forecast__c aplFC2 = new APL_Sales_Forecast__c();
        aplFC2.type__c = 'Relay';
        aplFC2.Fiscal_Year__c = '2015';
        aplFC2.Fiscal_Quarter__c = '04';
        aplFC2.customer__c = relayAcct.Id;
        aplFC2.Part__c = part1.Id;
        aplFC2.GPL__c = ph1.Id;
        aplFC2.RSM_Forecast__c = 10;
        insert new list<APL_Sales_Forecast__c >{aplFC1, aplFC3, aplFC2};
        
        APL_RSM__c aplRsm = new APL_RSM__c();
        aplRsm.Manager__c = userInfo.getUserId();
        aplRsm.Display_Name__c = 'test';
        //insert aplRsm;
        
        APL_RSM__c aplRsm1 = new APL_RSM__c();
        aplRsm1.Manager__c = userInfo.getUserId();
        aplRsm1.Type__c = 'Relay';
        aplRsm1.Display_Name__c = 'test2';
        //insert aplRsm1;
        
        APL_RSM__c aplRsm2 = new APL_RSM__c();
        aplRsm2.Manager__c = userInfo.getUserId();
        aplRsm2.Type__c = 'AM';
        aplRsm2.Display_Name__c = 'test1';
        aplRsm2.APL_RSM__c = aplRsm1.Id;
        insert new list<APL_RSM__c >{aplRsm, aplRsm1, aplRsm2};
        
        RecordType rt25 = ClsTestHelp.createTestRecordType25(); 
        APL_Forecast_Management__c apl = new APL_Forecast_Management__c();
        apl.Name = 'testName';
        apl.A6_Code__c = '123456';
        apl.Manager__c = userInfo.getUserId();  
        apl.RSM__c = aplRsm2.Id;
        apl.GAM_Code__c = '103004';
        apl.RecordTypeId = rt25.Id;
        //insert apl;
        
        APL_Forecast_Management__c apl1 = new APL_Forecast_Management__c();
        apl1.Name = 'testName1';
        apl1.A6_Code__c = '123456';
        apl1.GAM_Code__c = '103004';
        apl1.Manager__c = userInfo.getUserId();
        apl1.RecordTypeId = rt25.Id;
        apl1.RSM__c = aplRsm1.Id;
        insert new list<APL_Forecast_Management__c >{apl, apl1};
        
        BBB_Month_Bill_Book_Cust_PN__c bbbMon = new BBB_Month_Bill_Book_Cust_PN__c();
        bbbMon.Customer__c = amAcct.Id;
        bbbMon.Bill_Amount_USD__c = 10;
        bbbMon.Book_Amount_USD__c = 10; 
        bbbMon.Fiscal_Year__c = '2015';
        bbbMon.Fiscal_Month__c = 8;
        bbbMon.Profit_Center__c = 'APL';
        bbbMon.Part__c = part.Id;
        insert bbbMon;
        
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
        bbbDay.Part__c = part.Id;
        insert bbbDay;
        
        APL_RSM_Overall_Forecast__c aplOver = new APL_RSM_Overall_Forecast__c();
        aplOver.Fiscal_Quarter__c = '04';
        aplOver.Fiscal_Year__c = '2015';
        aplOver.APL_RSM__c = aplRsm.Id;
        aplOver.RSM_Overall_Forecast__c = 10;       
        insert aplOver;
        
        APL_ClsEntityType.SearchObj so = ClsTestHelp.createSearchObj();
        so.set_fiscalMonth = new set<String>();
        so.set_fiscalMonth.add('2015_5');
        so.currencyIso = 'USD';
        so.territoryCode = acct.SALES_TERRITORY_CDE__c;
        so.managerId = userInfo.getUserId();
        so.rsmgrouping = APL_ClsUtils.OTHER;
        //so.accnumber = ph1.CBC3__c;
        so.set_gamCodes = new set<String>();
        so.set_gamCodes.add('103004');
        so.grouping = acct.Id;
        so.isOtherMethod = true;
        so.map_year_quartersFuture = new map<String, set<String>>{
            '2015'=> new set<String>{'03', '04'},
            '2016'=> new set<String>{'01', '02', '03', '04'},
            '2017'=> new set<String>{'01'}
        };
        so.set_fiscalMonth.add('2016_9');
        so.set_fiscalMonth.add('2015_8');
        
        so.region = '103004';
        so.soldtoId = amAcct.Id;
        String sData = JSON.serialize(so);
        
        test.startTest();
        APL_ClsGAMService.SearchLevel1 level1 = new APL_ClsGAMService.SearchLevel1();
        
        String s = level1.getRefData(sData);
        String sd = level1.getBacklogRefData(sData);
        
        
        APL_ClsGAMService.SearchLevel2 level2 = new APL_ClsGAMService.SearchLevel2();

        s = level2.getRefData(sData);
        sd = level2.getBacklogRefData(sData);

        /*
        APL_ClsGAMService.SearchLevel3 level3 = new APL_ClsGAMService.SearchLevel3();
        so.cbc2Code = 'Relay';
        sData = JSON.serialize(so);
        
        s = level3.getRefData(sData);
        sd = level3.getBacklogRefData(sData);

        
        APL_ClsGAMService.SearchLevel4 level4 = new APL_ClsGAMService.SearchLevel4();
        so.cbc2Code = '30012';
        so.gplId = ph.Id;
        sData = JSON.serialize(so);
        s = level4.getRefData(sData);
        sd = level4.getBacklogRefData(sData);
        
        so.cbc2Code = 'Relay';
        so.accnumber = ph1.CBC2__c;
        sData = JSON.serialize(so);
        s = level4.getExistResult(sData);
        s = level4.getRefData(sData);
        sd = level4.getBacklogRefData(sData);
        */
        test.stopTest();
        

    }
    
    
    static testMethod void testMethodAMService1() {
        
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
        
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
        sh.Level_2_Territory_Code__c = '103004';
        insert sh;
        
        Account acct = ClsTestHelp.createTestAccounts();
        acct.Name = 'axx';
        acct.RecordTypeId = rt2.Id;
        acct.AccountNumber = '123456';
        acct.APL_Relay_forecast_Plan_Account__c = acct.Id;
        acct.APL_Relay_Currency__c = 'USD';
        acct.APL_Relay_Display_Name__c = 'testName';
        acct.APL_AM_forecast_Plan_Account__c = acct.Id;
        acct.APL_AM_Currency__c = 'USD';
        acct.APL_AM_Display_Name__c = 'amTestName';
        acct.Account_Manager__c = userInfo.getUserId();
        acct.STATDESC__c = 'Active';
        acct.SALES_TERRITORY_CDE__c = '123456';
        acct.Relay_Specialist_Territory_Code__c = '123456';   
        //acct.Territory_L2_code__c = '103004';
        insert acct;
        
        Account relayAcct = ClsTestHelp.createTestAccounts();
        relayAcct.Name = 'relayAcctaxx';
        relayAcct.RecordTypeId = rt2.Id;
        relayAcct.Account_Manager__c = userInfo.getUserId();
        relayAcct.APL_Relay_forecast_Plan_Account__c = acct.Id;
        relayAcct.APL_AM_forecast_Plan_Account__c = acct.Id;
        relayAcct.APL_Relay_Currency__c = 'USD';
        relayAcct.APL_Relay_Display_Name__c = 'testName';
        relayAcct.APL_Relay_ParentAccount__c = acct.Id;
        relayAcct.SALES_TERRITORY_CDE__c = '123456';
        relayAcct.Relay_Specialist_Territory_Code__c = '123456';  
        relayAcct.GAMCD__c = '1234'; 
        relayAcct.Sales_Hierarchy__c = sh.Id;   
        relayAcct.STATDESC__c = 'Active';
        //relayAcct.Territory_L2_code__c = '103004';
        //insert relayAcct;
        
        Account relayAcct1 = ClsTestHelp.createTestAccounts();
        relayAcct1.Name = 'relayAcctaxx';
        relayAcct1.RecordTypeId = rt2.Id;
        relayAcct1.Account_Manager__c = userInfo.getUserId();
        relayAcct1.APL_Relay_forecast_Plan_Account__c = acct.Id;
        relayAcct1.APL_Relay_Currency__c = 'USD';
        relayAcct1.APL_Relay_Display_Name__c = 'testName';
        relayAcct1.APL_Relay_ParentAccount__c = acct.Id;
        relayAcct1.SALES_TERRITORY_CDE__c = '123456';   
        relayAcct1.GAMCD__c = '1234';   
        relayAcct1.Relay_Specialist_Territory_Code__c = '123456';
        relayAcct1.STATDESC__c = 'Active';
        //relayAcct1.Territory_L2_code__c = '103004';
        //insert relayAcct1;
        
        Account amAcct = ClsTestHelp.createTestAccounts();
        amAcct.Name = 'axx';
        amAcct.RecordTypeId = rt2.Id;
        amAcct.APL_AM_forecast_Plan_Account__c = acct.Id;
        amAcct.APL_AM_Currency__c = 'USD';
        amAcct.APL_AM_Display_Name__c = 'amTestName';
        amAcct.APL_AM_ParentAccount__c = acct.Id;       
        amAcct.Account_Manager__c = userInfo.getUserId();
        amAcct.SALES_TERRITORY_CDE__c = '123456';
        amAcct.Relay_Specialist_Territory_Code__c = '123456';
        amAcct.GAMCD__c = '1234';
        amAcct.Sales_Hierarchy__c = sh.Id;  
        amAcct.STATDESC__c = 'Active';
        //amAcct.Territory_L2_code__c = '103004';
        //insert amAcct;
        
        Account amAcct1 = ClsTestHelp.createTestAccounts();
        amAcct1.Name = 'axx';
        amAcct1.RecordTypeId = rt2.Id;
        amAcct1.APL_AM_forecast_Plan_Account__c = null;
        amAcct1.APL_AM_Currency__c = 'USD';
        amAcct1.APL_AM_Display_Name__c = 'amTestName';
        amAcct1.APL_AM_ParentAccount__c = acct.Id;      
        amAcct1.Account_Manager__c = userInfo.getUserId();
        amAcct1.SALES_TERRITORY_CDE__c = '123456';
        amAcct1.Relay_Specialist_Territory_Code__c = '123456';
        amAcct1.GAMCD__c = '1234';
        amAcct1.Sales_Hierarchy__c = sh.Id; 
        //amAcct1.Territory_L2_code__c = '103004';
        insert new list<account>{relayAcct, relayAcct1, amAcct, amAcct1};
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Name = '123';
        ph.CBC2__c = '30012';
        ph.CBC3__c = '30033';
        ph.CBC1_Description__c = 'Appliances';
        //insert ph;
        
        Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
        ph1.Name = '1234';
        ph1.CBC2__c = '13213';
        ph1.CBC3__c = '30033';
        ph1.CBC1_Description__c = 'Appliances';
        //insert ph1;
        
        Product_Hierarchy__c ph2 = new Product_Hierarchy__c();
        ph2.Name = '1234';
        ph2.CBC1__c = '45678';
        ph2.CBC2__c = '13213';
        ph2.CBC3__c = '30033';
        ph2.CBC1_Description__c = 'Appliances';
        insert new list<Product_Hierarchy__c> {ph, ph1, ph2};
        
        Part__c part = new Part__c();
        part.Name = 'testPart';
        part.GPL__c = ph.Id;
        part.Product_Hierarchy__c = ph.Id; 
        part.Description__c = 'test';
        part.PRODUCT_CDE__c = 'TEST1';
        part.PROD_NAME__c = 'test name1';
        //insert part;
        
        Part__c part1 = new Part__c();
        part1.Name = 'testPart';
        part1.GPL__c = ph1.Id;
        part1.Product_Hierarchy__c = ph1.Id; 
        part1.Description__c = 'test';
        part1.PRODUCT_CDE__c = 'TEST2';
        part1.PROD_NAME__c = 'test name2';
        //insert part1;
        
        Part__c part2 = new Part__c();
        part2.Name = 'testPart';
        part2.GPL__c = ph2.Id;
        part2.Product_Hierarchy__c = ph2.Id; 
        part2.Description__c = 'test';
        part2.PRODUCT_CDE__c = 'TEST3';
        part2.PROD_NAME__c = 'test name3';
        insert new list<Part__c> {part, part1, part2};
        
        APL_Sales_Forecast__c aplFC1 = new APL_Sales_Forecast__c();
        aplFC1.type__c = 'GPL';
        aplFC1.Fiscal_Year__c = '2015';
        aplFC1.Fiscal_Quarter__c = '04';
        aplFC1.customer__c = amAcct.Id;
        aplFC1.RSM_Forecast__c = 10;
        aplFC1.GPL__c = ph.Id;
        aplFC1.Part__c = part.Id;
        //insert aplFC1;
        
        APL_Sales_Forecast__c aplFC3 = new APL_Sales_Forecast__c();
        aplFC3.type__c = 'Relay Product Code';
        aplFC3.Fiscal_Year__c = '2015';
        aplFC3.Fiscal_Quarter__c = '04';
        aplFC3.customer__c = relayAcct.Id;
        aplFC3.PRODUCT_CDE__c = part1.PRODUCT_CDE__c;
        aplFC3.PROD_NAME__c = part1.PROD_NAME__c;
        aplFC3.Relay_CBC2_Code__c = ph1.CBC2__c;
        aplFC3.RSM_Forecast__c = 10;
        //insert aplFC3;
        
        
        APL_Sales_Forecast__c aplFC2 = new APL_Sales_Forecast__c();
        aplFC2.type__c = 'Relay';
        aplFC2.Fiscal_Year__c = '2015';
        aplFC2.Fiscal_Quarter__c = '04';
        aplFC2.customer__c = relayAcct.Id;
        aplFC2.Part__c = part1.Id;
        aplFC2.GPL__c = ph1.Id;
        aplFC2.RSM_Forecast__c = 10;
        insert new list<APL_Sales_Forecast__c>{aplFC1, aplFC3, aplFC2};
        
        APL_RSM__c aplRsm = new APL_RSM__c();
        aplRsm.Manager__c = userInfo.getUserId();
        aplRsm.Display_Name__c = 'test';
        //insert aplRsm;
        
        APL_RSM__c aplRsm1 = new APL_RSM__c();
        aplRsm1.Manager__c = userInfo.getUserId();
        aplRsm1.Type__c = 'Relay';
        aplRsm1.Display_Name__c = 'test2';
        //insert aplRsm1;
        
        APL_RSM__c aplRsm2 = new APL_RSM__c();
        aplRsm2.Manager__c = userInfo.getUserId();
        aplRsm2.Type__c = 'AM';
        aplRsm2.Display_Name__c = 'test1';
        aplRsm2.APL_RSM__c = aplRsm1.Id;
        insert new list<APL_RSM__c> {aplRsm, aplRsm1, aplRsm2};
        
        RecordType rt25 = ClsTestHelp.createTestRecordType25(); 
        APL_Forecast_Management__c apl = new APL_Forecast_Management__c();
        apl.Name = 'testName';
        apl.A6_Code__c = '123456';
        apl.Manager__c = userInfo.getUserId();  
        apl.RSM__c = aplRsm2.Id;
        apl.GAM_Code__c = '103004';
        apl.RecordTypeId = rt25.Id;
        //insert apl;
        
        APL_Forecast_Management__c apl1 = new APL_Forecast_Management__c();
        apl1.Name = 'testName1';
        apl1.A6_Code__c = '123456';
        apl1.GAM_Code__c = '103004';
        apl1.Manager__c = userInfo.getUserId();
        apl1.RecordTypeId = rt25.Id;
        apl1.RSM__c = aplRsm1.Id;
        insert new list<APL_Forecast_Management__c> {apl, apl1};
        
        BBB_Month_Bill_Book_Cust_PN__c bbbMon = new BBB_Month_Bill_Book_Cust_PN__c();
        bbbMon.Customer__c = amAcct.Id;
        bbbMon.Bill_Amount_USD__c = 10;
        bbbMon.Book_Amount_USD__c = 10; 
        bbbMon.Fiscal_Year__c = '2015';
        bbbMon.Fiscal_Month__c = 8;
        bbbMon.Profit_Center__c = 'APL';
        bbbMon.Part__c = part.Id;
        insert bbbMon;
        
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
        bbbDay.Part__c = part.Id;
        insert bbbDay;
        
        APL_RSM_Overall_Forecast__c aplOver = new APL_RSM_Overall_Forecast__c();
        aplOver.Fiscal_Quarter__c = '04';
        aplOver.Fiscal_Year__c = '2015';
        aplOver.APL_RSM__c = aplRsm.Id;
        aplOver.RSM_Overall_Forecast__c = 10;       
        insert aplOver;
        
        APL_ClsEntityType.SearchObj so = ClsTestHelp.createSearchObj();
        so.set_fiscalMonth = new set<String>();
        so.set_fiscalMonth.add('2015_5');
        so.currencyIso = 'USD';
        so.territoryCode = acct.SALES_TERRITORY_CDE__c;
        so.managerId = userInfo.getUserId();
        so.rsmgrouping = APL_ClsUtils.OTHER;
        so.accnumber = ph1.CBC3__c;
        so.grouping = acct.Id;
        so.isOtherMethod = true;
        so.set_gamCodes = new set<String>();
        so.set_gamCodes.add('103004');
        so.map_year_quartersFuture = new map<String, set<String>>{
            '2015'=> new set<String>{'03', '04'},
            '2016'=> new set<String>{'01', '02', '03', '04'},
            '2017'=> new set<String>{'01'}
        };
        so.set_fiscalMonth.add('2016_9');
        so.set_fiscalMonth.add('2015_8');
        
        so.region = '103004';
        so.soldtoId = amAcct.Id;
        so.cbc2Code = '30005';
        so.partId = part1.Id;
        String sData = JSON.serialize(so);
        
        String s = '';
        String sd = '';
        
        APL_ClsGAMService.SearchLevel5 level5 = new APL_ClsGAMService.SearchLevel5();
        
        s = level5.getExistResult(sData);
        s = level5.getRefData(sData);
        sd = level5.getBacklogRefData(sData);
        
        APL_ClsGAMService.SearchLevel6 level6 = new APL_ClsGAMService.SearchLevel6();
        
        s = level6.getExistResult(sData);
        s = level6.getRefData(sData);
        sd = level6.getBacklogRefData(sData);
        
        
        APL_ClsGAMService.SearchLevelOther levelother = new APL_ClsGAMService.SearchLevelOther();
        
        
        s = levelother.getExistResult(sData);
        
        so.accnumber = ph2.CBC1__c;
        sData = JSON.serialize(so);
        s = levelother.getRefData(sData);
        sd = levelother.getBacklogRefData(sData);
        
    }
    
    static testMethod void testMethodAMService2() {
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
        
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
        sh.Level_2_Territory_Code__c = '103004';
        insert sh;
        
        Account acct = ClsTestHelp.createTestAccounts();
        acct.Name = 'axx';
        acct.RecordTypeId = rt2.Id;
        acct.AccountNumber = '123456';
        acct.APL_Relay_forecast_Plan_Account__c = acct.Id;
        acct.APL_Relay_Currency__c = 'USD';
        acct.APL_Relay_Display_Name__c = 'testName';
        acct.APL_AM_forecast_Plan_Account__c = acct.Id;
        acct.APL_AM_Currency__c = 'USD';
        acct.APL_AM_Display_Name__c = 'amTestName';
        acct.Account_Manager__c = userInfo.getUserId();
        acct.STATDESC__c = 'Active';
        acct.SALES_TERRITORY_CDE__c = '123456';
        acct.Relay_Specialist_Territory_Code__c = '123456';  
        acct.Sales_Hierarchy__c = sh.Id;     
        //acct.Territory_L2_code__c = '103004';
        insert acct;
        
        Account relayAcct = ClsTestHelp.createTestAccounts();
        relayAcct.Name = 'relayAcctaxx';
        relayAcct.RecordTypeId = rt2.Id;
        relayAcct.Account_Manager__c = userInfo.getUserId();
        relayAcct.APL_Relay_forecast_Plan_Account__c = acct.Id;
        relayAcct.APL_AM_forecast_Plan_Account__c = acct.Id;
        relayAcct.APL_Relay_Currency__c = 'USD';
        relayAcct.APL_Relay_Display_Name__c = 'testName';
        relayAcct.APL_Relay_ParentAccount__c = acct.Id;
        relayAcct.SALES_TERRITORY_CDE__c = '123456';
        relayAcct.Relay_Specialist_Territory_Code__c = '123456';  
        relayAcct.GAMCD__c = '1234'; 
        relayAcct.Sales_Hierarchy__c = sh.Id;   
        relayAcct.STATDESC__c = 'Active';
        //relayAcct.Territory_L2_code__c = '103004';
        //insert relayAcct;
        
        Account relayAcct1 = ClsTestHelp.createTestAccounts();
        relayAcct1.Name = 'relayAcctaxx';
        relayAcct1.RecordTypeId = rt2.Id;
        relayAcct1.Account_Manager__c = userInfo.getUserId();
        relayAcct1.APL_Relay_forecast_Plan_Account__c = acct.Id;
        relayAcct1.APL_Relay_Currency__c = 'USD';
        relayAcct1.APL_Relay_Display_Name__c = 'testName';
        relayAcct1.APL_Relay_ParentAccount__c = acct.Id;
        relayAcct1.SALES_TERRITORY_CDE__c = '123456';   
        relayAcct1.GAMCD__c = '1234';   
        relayAcct1.Relay_Specialist_Territory_Code__c = '123456';
        relayAcct1.STATDESC__c = 'Active';
        relayAcct1.Sales_Hierarchy__c = sh.Id;  
        //relayAcct1.Territory_L2_code__c = '103004';
        //insert relayAcct1;
        
        Account amAcct = ClsTestHelp.createTestAccounts();
        amAcct.Name = 'axx';
        amAcct.RecordTypeId = rt2.Id;
        amAcct.APL_AM_forecast_Plan_Account__c = acct.Id;
        amAcct.APL_AM_Currency__c = 'USD';
        amAcct.APL_AM_Display_Name__c = 'amTestName';
        amAcct.APL_AM_ParentAccount__c = acct.Id;       
        amAcct.Account_Manager__c = userInfo.getUserId();
        amAcct.SALES_TERRITORY_CDE__c = '123456';
        amAcct.Relay_Specialist_Territory_Code__c = '123456';
        amAcct.GAMCD__c = '1234';
        amAcct.Sales_Hierarchy__c = sh.Id;  
        amAcct.STATDESC__c = 'Active';
        //amAcct.Territory_L2_code__c = '103004';
        //insert amAcct;
        
        Account amAcct1 = ClsTestHelp.createTestAccounts();
        amAcct1.Name = 'axx';
        amAcct1.RecordTypeId = rt2.Id;
        amAcct1.APL_AM_forecast_Plan_Account__c = null;
        amAcct1.APL_AM_Currency__c = 'USD';
        amAcct1.APL_AM_Display_Name__c = 'amTestName';
        amAcct1.APL_AM_ParentAccount__c = acct.Id;      
        amAcct1.Account_Manager__c = userInfo.getUserId();
        amAcct1.SALES_TERRITORY_CDE__c = '123456';
        amAcct1.Relay_Specialist_Territory_Code__c = '123456';
        amAcct1.GAMCD__c = '1234';
        amAcct1.Sales_Hierarchy__c = sh.Id; 
        //amAcct1.Territory_L2_code__c = '103004';
        //insert amAcct1;
        insert new list<account>{relayAcct, relayAcct1, amAcct, amAcct1};
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Name = '123';
        ph.CBC2__c = '30012';
        ph.CBC3__c = '30033';
        ph.CBC1_Description__c = 'Appliances';
        //insert ph;
        
        Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
        ph1.Name = '1234';
        ph1.CBC2__c = '13213';
        ph1.CBC3__c = '30033';
        ph1.CBC1_Description__c = 'Appliances';
        //insert ph1;
        
        Product_Hierarchy__c ph2 = new Product_Hierarchy__c();
        ph2.Name = '1234';
        ph2.CBC1__c = '45678';
        ph2.CBC2__c = '13213';
        ph2.CBC3__c = '30033';
        ph2.CBC1_Description__c = 'Appliances';
        //insert ph2;
        insert new list<Product_Hierarchy__c> {ph, ph1, ph2};
        
        Part__c part = new Part__c();
        part.Name = 'testPart';
        part.GPL__c = ph.Id;
        part.Product_Hierarchy__c = ph.Id; 
        part.Description__c = 'test';
        part.PRODUCT_CDE__c = 'TEST1';
        part.PROD_NAME__c = 'test name1';
        //insert part;
        
        Part__c part1 = new Part__c();
        part1.Name = 'testPart';
        part1.GPL__c = ph1.Id;
        part1.Product_Hierarchy__c = ph1.Id; 
        part1.Description__c = 'test';
        part1.PRODUCT_CDE__c = 'TEST2';
        part1.PROD_NAME__c = 'test name2';
        //insert part1;
        
        Part__c part2 = new Part__c();
        part2.Name = 'testPart';
        part2.GPL__c = ph2.Id;
        part2.Product_Hierarchy__c = ph2.Id; 
        part2.Description__c = 'test';
        part2.PRODUCT_CDE__c = 'TEST3';
        part2.PROD_NAME__c = 'test name3';
        //insert part2;
        insert new list<Part__c> {part, part1, part2};
        APL_Sales_Forecast__c aplFC1 = new APL_Sales_Forecast__c();
        aplFC1.type__c = 'GPL';
        aplFC1.Fiscal_Year__c = '2015';
        aplFC1.Fiscal_Quarter__c = '04';
        aplFC1.customer__c = amAcct.Id;
        aplFC1.RSM_Forecast__c = 10;
        aplFC1.GPL__c = ph.Id;
        aplFC1.Part__c = part.Id;
        //insert aplFC1;
        
        APL_Sales_Forecast__c aplFC3 = new APL_Sales_Forecast__c();
        aplFC3.type__c = 'Relay Product Code';
        aplFC3.Fiscal_Year__c = '2015';
        aplFC3.Fiscal_Quarter__c = '04';
        aplFC3.customer__c = relayAcct.Id;
        aplFC3.PRODUCT_CDE__c = part1.PRODUCT_CDE__c;
        aplFC3.PROD_NAME__c = part1.PROD_NAME__c;
        aplFC3.Relay_CBC2_Code__c = ph1.CBC2__c;
        aplFC3.RSM_Forecast__c = 10;
        //insert aplFC3;
        
        
        APL_Sales_Forecast__c aplFC2 = new APL_Sales_Forecast__c();
        aplFC2.type__c = 'Relay';
        aplFC2.Fiscal_Year__c = '2015';
        aplFC2.Fiscal_Quarter__c = '04';
        aplFC2.customer__c = relayAcct.Id;
        aplFC2.Part__c = part1.Id;
        aplFC2.GPL__c = ph1.Id;
        aplFC2.RSM_Forecast__c = 10;
        //insert aplFC2;
        insert new list<APL_Sales_Forecast__c>{aplFC1, aplFC3, aplFC2};
        APL_RSM__c aplRsm = new APL_RSM__c();
        aplRsm.Manager__c = userInfo.getUserId();
        aplRsm.Display_Name__c = 'test';
        //insert aplRsm;
        
        APL_RSM__c aplRsm1 = new APL_RSM__c();
        aplRsm1.Manager__c = userInfo.getUserId();
        aplRsm1.Type__c = 'Relay';
        aplRsm1.Display_Name__c = 'test2';
        //insert aplRsm1;
        
        APL_RSM__c aplRsm2 = new APL_RSM__c();
        aplRsm2.Manager__c = userInfo.getUserId();
        aplRsm2.Type__c = 'AM';
        aplRsm2.Display_Name__c = 'test1';
        aplRsm2.APL_RSM__c = aplRsm1.Id;
        //insert aplRsm2;
        insert new list<APL_RSM__c> {aplRsm, aplRsm1, aplRsm2};
        RecordType rt25 = ClsTestHelp.createTestRecordType25(); 
        APL_Forecast_Management__c apl = new APL_Forecast_Management__c();
        apl.Name = 'testName';
        apl.A6_Code__c = '123456';
        apl.Manager__c = userInfo.getUserId();  
        apl.RSM__c = aplRsm2.Id;
        apl.GAM_Code__c = '103004';
        apl.RecordTypeId = rt25.Id;
        //insert apl;
        
        APL_Forecast_Management__c apl1 = new APL_Forecast_Management__c();
        apl1.Name = 'testName1';
        apl1.A6_Code__c = '123456';
        apl1.GAM_Code__c = '103004';
        apl1.Manager__c = userInfo.getUserId();
        apl1.RecordTypeId = rt25.Id;
        apl1.RSM__c = aplRsm1.Id;
        insert new list<APL_Forecast_Management__c> {apl, apl1};
        
        BBB_Month_Bill_Book_Cust_PN__c bbbMon = new BBB_Month_Bill_Book_Cust_PN__c();
        bbbMon.Customer__c = amAcct.Id;
        bbbMon.Bill_Amount_USD__c = 10;
        bbbMon.Book_Amount_USD__c = 10; 
        bbbMon.Fiscal_Year__c = '2015';
        bbbMon.Fiscal_Month__c = 8;
        bbbMon.Profit_Center__c = 'APL';
        bbbMon.Part__c = part.Id;
        insert bbbMon;
        
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
        bbbDay.Part__c = part.Id;
        insert bbbDay;
        
        APL_RSM_Overall_Forecast__c aplOver = new APL_RSM_Overall_Forecast__c();
        aplOver.Fiscal_Quarter__c = '04';
        aplOver.Fiscal_Year__c = '2015';
        aplOver.APL_RSM__c = aplRsm.Id;
        aplOver.RSM_Overall_Forecast__c = 10;       
        insert aplOver;
        
        APL_ClsEntityType.SearchObj so = ClsTestHelp.createSearchObj();
        so.set_fiscalMonth = new set<String>();
        so.set_fiscalMonth.add('2015_5');
        so.currencyIso = 'USD';
        so.territoryCode = acct.SALES_TERRITORY_CDE__c;
        so.managerId = userInfo.getUserId();
        so.rsmgrouping = APL_ClsUtils.OTHER;
        //so.accnumber = ph1.CBC3__c;
        so.set_gamCodes = new set<String>();
        so.set_gamCodes.add('103004');
        so.grouping = acct.Id;
        so.isOtherMethod = true;
        so.map_year_quartersFuture = new map<String, set<String>>{
            '2015'=> new set<String>{'03', '04'},
            '2016'=> new set<String>{'01', '02', '03', '04'},
            '2017'=> new set<String>{'01'}
        };
        so.set_fiscalMonth.add('2016_9');
        so.set_fiscalMonth.add('2015_8');
        
        so.region = '103004';
        so.soldtoId = amAcct.Id;
        String sData = JSON.serialize(so);

        APL_ClsGAMService.SearchLevel3 level3 = new APL_ClsGAMService.SearchLevel3();
        so.cbc2Code = 'Relay';
        sData = JSON.serialize(so);
        
        String s = level3.getRefData(sData);
        String sd = level3.getBacklogRefData(sData);

        
        APL_ClsGAMService.SearchLevel4 level4 = new APL_ClsGAMService.SearchLevel4();
        so.cbc2Code = '30012';
        so.gplId = ph.Id;
        sData = JSON.serialize(so);
        s = level4.getRefData(sData);
        sd = level4.getBacklogRefData(sData);
        
        so.cbc2Code = 'Relay';
        so.accnumber = ph1.CBC2__c;
        sData = JSON.serialize(so);
        s = level4.getExistResult(sData);
        s = level4.getRefData(sData);
        sd = level4.getBacklogRefData(sData);
        
        

    }
}