/**
 *  This test class is used to test APL_ClsAMService
 *  
 * @author Lei Tang
 * @created 2015-06-17
 * @version 1.0
 * @since 33.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2015-06-17 Lei Tang <lei.tang@itbconsult.com>
 * - Created
 *
 */
@isTest
private class CSD_ClsGAMViewService_Test {

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
        
        RecordType rtsoldto = ClsTestHelp.createTestRecordType8();
        RecordType rtoem = ClsTestHelp.createCSDTestRecordType7(); 
        
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

        Account acct1 = ClsTestHelp.createTestAccounts();
        acct1.Name = 'axx';
        acct1.RecordTypeId = rtsoldto.Id;
        acct1.AccountNumber = '1234:12345678';
        acct1.Account_Manager__c = userInfo.getUserId();
        acct1.STATDESC__c = 'Active';
        acct1.SALES_TERRITORY_CDE__c = '123456';
        acct1.Relay_Specialist_Territory_Code__c = '123456';  
        acct1.Sales_Hierarchy__c = sh.Id;    
        acct1.Active__c = true;
        insert acct1;
        
        Account acct2 = ClsTestHelp.createTestAccounts();
        acct2.Name = 'relayAcctaxx';
        acct2.RecordTypeId = rtoem.Id;
        acct2.Account_Manager__c = userInfo.getUserId();
        acct2.Active__c = true;
        insert acct2;

        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Name = '123';
        ph.CBC2__c = '30012';
        ph.CBC3__c = '30033';
        ph.CBC1_Description__c = 'Appliances';
        insert ph;
        
        Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
        ph1.Name = '1234';
        ph1.CBC2__c = '13213';
        ph1.CBC3__c = '30033';
        ph1.CBC1_Description__c = 'Appliances';
        insert ph1;
        
        Product_Hierarchy__c ph2 = new Product_Hierarchy__c();
        ph2.Name = '1234';
        ph2.CBC1__c = '45678';
        ph2.CBC2__c = '13213';
        ph2.CBC3__c = '30033';
        ph2.CBC1_Description__c = 'Appliances';
        insert ph2;
        
        Part__c part = new Part__c();
        part.Name = 'testPart';
        part.GPL__c = ph.Id;
        part.Product_Hierarchy__c = ph.Id; 
        part.Description__c = 'test';
        part.PRODUCT_CDE__c = 'TEST1';
        part.PROD_NAME__c = 'test name1';
        insert part;
        
        Part__c part1 = new Part__c();
        part1.Name = 'testPart';
        part1.GPL__c = ph1.Id;
        part1.Product_Hierarchy__c = ph1.Id; 
        part1.Description__c = 'test';
        part1.PRODUCT_CDE__c = 'TEST2';
        part1.PROD_NAME__c = 'test name2';
        insert part1;
        
        Part__c part2 = new Part__c();
        part2.Name = 'testPart';
        part2.GPL__c = ph2.Id;
        part2.Product_Hierarchy__c = ph2.Id; 
        part2.Description__c = 'test';
        part2.PRODUCT_CDE__c = 'TEST3';
        part2.PROD_NAME__c = 'test name3';
        insert part2;
        
        CSD_Sales_Forecast__c csdFC1 = new CSD_Sales_Forecast__c();
        csdFC1.Type__c = 'Sold-To';
        csdFC1.Fiscal_Year__c = '2015';
        csdFC1.Fiscal_Month__c = '9';
        csdFC1.Sold_To_Number__c = '1234:12345678';
        csdFC1.Sold_To_Name__c = 'Test';
        csdFC1.Forecast__c = 1000;
        csdFC1.Billing_Region__c = 'AMERICAS';
        insert csdFC1;
        
        CSD_Sales_Forecast__c csdFC2 = new CSD_Sales_Forecast__c();
        csdFC2.type__c = 'OEM';
        csdFC2.Fiscal_Year__c = '2015';
        csdFC2.Fiscal_Month__c = '9';
        csdFC2.Sold_To_Number__c = '1234:12345678';
        csdFC2.Sold_To_Name__c = 'Test';
        csdFC2.OEM__c = acct2.Id;
        csdFC2.Forecast__c = 1000;
        csdFC2.Billing_Region__c = 'AMERICAS';
        insert csdFC2;
        
        
        CSD_Sales_Forecast__c csdFC3 = new CSD_Sales_Forecast__c();
        csdFC3.type__c = 'Part';
        csdFC3.Fiscal_Year__c = '2015';
        csdFC3.Fiscal_Month__c = '9';
        csdFC3.Sold_To_Number__c = '1234:12345678';
        csdFC3.Sold_To_Name__c = 'Test';
        csdFC3.Part__c = part1.Id;
        csdFC3.Forecast__c = 100;
        csdFC3.OEM__c = acct2.Id;
        csdFC3.Price__c = 10;
        csdFC3.Quantity__c = 10;
        csdFC3.Billing_Region__c = 'AMERICAS';
        insert csdFC3;
        

        
        RecordType rt25 = ClsTestHelp.createTestRecordType25(); 
        CSD_Forecast_Management__c csd = new CSD_Forecast_Management__c();
        csd.Name = 'testName';
        csd.Role__c = 'Sales Leader';
        csd.User__c = userInfo.getUserId();
        insert csd;
        
        OEM_Details__c oemd = new OEM_Details__c();
        oemd.OEM__c = acct2.Id;
        insert oemd;
        
        OEM_Mapping_Rule__c oemmap = new OEM_Mapping_Rule__c();
        oemmap.OEM__c = oemd.Id;
        oemmap.Allocation__c = 100;
        oemmap.Sold_To_Account_Code__c = '12345678';
        oemmap.Type__c = 'Customer';
        insert oemmap;
        
        BBB_Month_Bill_Book_Cust_PN__c bbbMon = new BBB_Month_Bill_Book_Cust_PN__c();
        bbbMon.Customer__c = acct1.Id;
        bbbMon.Bill_Amount_USD__c = 10;
        bbbMon.Book_Amount_USD__c = 10; 
        bbbMon.Fiscal_Year__c = '2015';
        bbbMon.Fiscal_Month__c = 8;
        bbbMon.Profit_Center__c = 'CSD';
        bbbMon.Part__c = part.Id;
        insert bbbMon;

        CSD_OEM_Mapping_Monthly_BBB__c monmap = new CSD_OEM_Mapping_Monthly_BBB__c();
        monmap.Monthly_Billings_Bookings_by_Part__r = bbbMon;
        monmap.OEM_Mapping__c = oemmap.Id;
        
        
        BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c bbbDay = new BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c();
        bbbDay.Backlog_Amount_USD__c = 10;
        bbbDay.Bill_Amount_USD__c = 10; 
        bbbDay.Book_Amount_USD__c = 10;
        bbbDay.Customer__c = acct1.Id;
        bbbDay.Fiscal_Year__c = '2015';
        bbbDay.Fiscal_Month__c = 9;
        bbbDay.Customer_Request_Date_Fiscal_Year__c = '2015';
        bbbday.Customer_Request_Date_Fiscal_Month__c = 9;
        bbbDay.Profit_Center__c = 'CSD';
        bbbDay.Part__c = part.Id;
        insert bbbDay;

        CSD_OEM_Mapping_Daily_BBB__c daymap = new CSD_OEM_Mapping_Daily_BBB__c();
        daymap.Daily_Booking_Billing_Backlog_By_Part__c = bbbDay.Id;
        daymap.CSD_OEM_Mapping__c  = oemmap.Id;
        insert daymap;
        
        CSD_ClsEntityType.SearchObj so = new CSD_ClsEntityType.SearchObj();
        so.set_fiscalMonth = new set<String>();
        so.set_fiscalMonth.add('2015_5');//'2015_5' shawn
        so.set_fiscalMonth.add('2015_9');//'2015_9' shawn
        so.set_fiscalMonth.add('2015_8');//'2015_8' shawn
        
        so.map_year_monthsFuture = new map<String, set<Integer>>{
            '2015'=> new set<Integer>{3,4,5,6,7,8,9,10,11}
        };
        
        so.startDate = '2015-03-15';
        so.endDate = '2015-11-15';

        String sData = JSON.serialize(so);
        String result = '';
        
        
        CSD_CtrlGAMViewForecast ctrl = new CSD_CtrlGAMViewForecast();
        
        CSD_ClsGAMViewService.SearchLevel1 level1 = new CSD_ClsGAMViewService.SearchLevel1();
        
        so.oemId = acct2.Id;
        sData = JSON.serialize(so);
        
        result = level1.getRefData(sData);
        result = level1.getBacklogRefData(sData);
        
        
        CSD_ClsGAMViewService.SearchLevel2 level2 = new CSD_ClsGAMViewService.SearchLevel2();
        
        result = level2.getExistResult(sData);
        so.type = 'channel';
        so.region = 'AMERICAS';
        sData = JSON.serialize(so);
        result = level2.getExistResult(sData);
        
        result = level2.getRefData(sData);
        result = level2.getBacklogRefData(sData);
        
        
        CSD_ClsGAMViewService.SearchLevel3 level3 = new CSD_ClsGAMViewService.SearchLevel3();

        result = level3.getExistResult(sData);
        so.accnumber = '1234:12345678';
        sData = JSON.serialize(so);
        result = level3.getRefData(sData);
        result = level3.getBacklogRefData(sData);
    }
    
    static testMethod void myUnitTest2() {
        
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
        
        RecordType rtsoldto = ClsTestHelp.createTestRecordType8();
        RecordType rtoem = ClsTestHelp.createCSDTestRecordType7(); 
        
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

        Account acct1 = ClsTestHelp.createTestAccounts();
        acct1.Name = 'axx';
        acct1.RecordTypeId = rtsoldto.Id;
        acct1.AccountNumber = '1234:12345678';
        acct1.Account_Manager__c = userInfo.getUserId();
        acct1.STATDESC__c = 'Active';
        acct1.SALES_TERRITORY_CDE__c = '123456';
        acct1.Relay_Specialist_Territory_Code__c = '123456';  
        acct1.Sales_Hierarchy__c = sh.Id;    
        //acct.Territory_L2_code__c = '103004';
        insert acct1;
        
        Account acct2 = ClsTestHelp.createTestAccounts();
        acct2.Name = 'relayAcctaxx';
        acct2.RecordTypeId = rtoem.Id;
        acct2.AccountNumber = '1234:12345678';
        acct2.Account_Manager__c = userInfo.getUserId();
        acct2.SALES_TERRITORY_CDE__c = '123456';
        acct2.Relay_Specialist_Territory_Code__c = '123456';  
        acct2.GAMCD__c = '1234'; 
        acct2.Sales_Hierarchy__c = sh.Id;
        acct2.STATDESC__c = 'Active';
        insert acct2;

        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Name = '123';
        ph.CBC2__c = '30012';
        ph.CBC3__c = '30033';
        ph.CBC1_Description__c = 'Appliances';
        insert ph;
        
        Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
        ph1.Name = '1234';
        ph1.CBC2__c = '13213';
        ph1.CBC3__c = '30033';
        ph1.CBC1_Description__c = 'Appliances';
        insert ph1;
        
        Product_Hierarchy__c ph2 = new Product_Hierarchy__c();
        ph2.Name = '1234';
        ph2.CBC1__c = '45678';
        ph2.CBC2__c = '13213';
        ph2.CBC3__c = '30033';
        ph2.CBC1_Description__c = 'Appliances';
        insert ph2;
        
        Part__c part = new Part__c();
        part.Name = 'testPart';
        part.GPL__c = ph.Id;
        part.Product_Hierarchy__c = ph.Id; 
        part.Description__c = 'test';
        part.PRODUCT_CDE__c = 'TEST1';
        part.PROD_NAME__c = 'test name1';
        insert part;
        
        Part__c part1 = new Part__c();
        part1.Name = 'testPart';
        part1.GPL__c = ph1.Id;
        part1.Product_Hierarchy__c = ph1.Id; 
        part1.Description__c = 'test';
        part1.PRODUCT_CDE__c = 'TEST2';
        part1.PROD_NAME__c = 'test name2';
        insert part1;
        
        Part__c part2 = new Part__c();
        part2.Name = 'testPart';
        part2.GPL__c = ph2.Id;
        part2.Product_Hierarchy__c = ph2.Id; 
        part2.Description__c = 'test';
        part2.PRODUCT_CDE__c = 'TEST3';
        part2.PROD_NAME__c = 'test name3';
        insert part2;
        
        CSD_Sales_Forecast__c csdFC1 = new CSD_Sales_Forecast__c();
        csdFC1.Type__c = 'Sold-To';
        csdFC1.Fiscal_Year__c = '2015';
        csdFC1.Fiscal_Month__c = '9';
        csdFC1.Sold_To_Number__c = '1234:12345678';
        csdFC1.Sold_To_Name__c = 'Test';
        csdFC1.Forecast__c = 1000;
        csdFC1.Billing_Region__c = 'AMERICAS';
        insert csdFC1;
        
        CSD_Sales_Forecast__c csdFC2 = new CSD_Sales_Forecast__c();
        csdFC2.type__c = 'OEM';
        csdFC2.Fiscal_Year__c = '2015';
        csdFC2.Fiscal_Month__c = '9';
        csdFC2.Sold_To_Number__c = '1234:12345678';
        csdFC2.Sold_To_Name__c = 'Test';
        csdFC2.OEM__c = acct2.Id;
        csdFC2.Forecast__c = 1000;
        csdFC2.Billing_Region__c = 'AMERICAS';
        insert csdFC2;
        
        
        CSD_Sales_Forecast__c csdFC3 = new CSD_Sales_Forecast__c();
        csdFC3.type__c = 'Part';
        csdFC3.Fiscal_Year__c = '2015';
        csdFC3.Fiscal_Month__c = '9';
        csdFC3.Sold_To_Number__c = '1234:12345678';
        csdFC3.Sold_To_Name__c = 'Test';
        csdFC3.Part__c = part1.Id;
        csdFC3.Forecast__c = 100;
        csdFC3.OEM__c = acct2.Id;
        csdFC3.Price__c = 10;
        csdFC3.Quantity__c = 10;
        csdFC3.Billing_Region__c = 'AMERICAS';
        insert csdFC3;
        

        
        RecordType rt25 = ClsTestHelp.createTestRecordType25(); 
        CSD_Forecast_Management__c csd = new CSD_Forecast_Management__c();
        csd.Name = 'testName';
        csd.Role__c = 'Sales Leader';
        csd.User__c = userInfo.getUserId();
        insert csd;
        
        
        OEM_Details__c oemd = new OEM_Details__c();
        oemd.OEM__c = acct2.Id;
        insert oemd;
        
        OEM_Mapping_Rule__c oemmap = new OEM_Mapping_Rule__c();
        oemmap.OEM__c = oemd.Id;
        oemmap.Allocation__c = 100;
        oemmap.Sold_To_Account_Code__c = '12345678';
        oemmap.Type__c = 'Customer';
        insert oemmap;
        
        BBB_Month_Bill_Book_Cust_PN__c bbbMon = new BBB_Month_Bill_Book_Cust_PN__c();
        bbbMon.Customer__c = acct1.Id;
        bbbMon.Bill_Amount_USD__c = 10;
        bbbMon.Book_Amount_USD__c = 10; 
        bbbMon.Fiscal_Year__c = '2015';
        bbbMon.Fiscal_Month__c = 8;
        bbbMon.Profit_Center__c = 'CSD';
        bbbMon.Part__c = part.Id;
        insert bbbMon;

        CSD_OEM_Mapping_Monthly_BBB__c monmap = new CSD_OEM_Mapping_Monthly_BBB__c();
        monmap.Monthly_Billings_Bookings_by_Part__r = bbbMon;
        monmap.OEM_Mapping__c = oemmap.Id;
        
        
        BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c bbbDay = new BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c();
        bbbDay.Backlog_Amount_USD__c = 10;
        bbbDay.Bill_Amount_USD__c = 10; 
        bbbDay.Book_Amount_USD__c = 10;
        bbbDay.Customer__c = acct1.Id;
        bbbDay.Fiscal_Year__c = '2015';
        bbbDay.Fiscal_Month__c = 9;
        bbbDay.Customer_Request_Date_Fiscal_Year__c = '2015';
        bbbday.Customer_Request_Date_Fiscal_Month__c = 9;
        bbbDay.Profit_Center__c = 'CSD';
        bbbDay.Part__c = part.Id;
        insert bbbDay;

        CSD_OEM_Mapping_Daily_BBB__c daymap = new CSD_OEM_Mapping_Daily_BBB__c();
        daymap.Daily_Booking_Billing_Backlog_By_Part__c = bbbDay.Id;
        daymap.CSD_OEM_Mapping__c  = oemmap.Id;
        insert daymap;
        
        
        CSD_ClsEntityType.SearchObj so = new CSD_ClsEntityType.SearchObj();
        so.set_fiscalMonth = new set<String>();
        so.set_fiscalMonth.add('2015_5');
        so.set_fiscalMonth.add('2015_9');
        so.set_fiscalMonth.add('2015_8');
        
        so.map_year_monthsFuture = new map<String, set<Integer>>{
            '2015'=> new set<Integer>{3,4,5,6,7,8,9,10,11}
        };
        
        so.startDate = '2015-03-15';
        so.endDate = '2015-11-15';
        so.oemId = acct2.Id;
        so.region = 'AMERICAS';
        so.accnumber = '1234:12345678';
        so.partId = part1.Id;
        String sData = JSON.serialize(so);
        String result = '';
        
        
        CSD_ClsGAMViewService.SearchLevel4 level4 = new CSD_ClsGAMViewService.SearchLevel4();

        result = level4.getExistResult(sData);
        result = level4.getRefData(sData);
        result = level4.getBacklogRefData(sData);
        
        
        CSD_ClsGAMViewService.SearchTotal total = new CSD_ClsGAMViewService.SearchTotal();

        result = total.getTotalBillingData(sData);

    }
    
    static testMethod void myUnitTest3() {
        
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
        
        RecordType rtsoldto = ClsTestHelp.createTestRecordType8();
        RecordType rtoem = ClsTestHelp.createCSDTestRecordType7(); 
        
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

        Account acct1 = ClsTestHelp.createTestAccounts();
        acct1.Name = 'axx';
        acct1.RecordTypeId = rtsoldto.Id;
        acct1.AccountNumber = '1234:12345678';
        acct1.Account_Manager__c = userInfo.getUserId();
        acct1.STATDESC__c = 'Active';
        acct1.SALES_TERRITORY_CDE__c = '123456';
        acct1.Relay_Specialist_Territory_Code__c = '123456';  
        acct1.Sales_Hierarchy__c = sh.Id;    
        acct1.Active__c = true;
        insert acct1;
        
        Account acct2 = ClsTestHelp.createTestAccounts();
        acct2.Name = 'relayAcctaxx';
        acct2.RecordTypeId = rtoem.Id;
        acct2.Account_Manager__c = userInfo.getUserId();
        acct2.Active__c = true;
        insert acct2;

        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Name = '123';
        ph.CBC2__c = '30012';
        ph.CBC3__c = '30033';
        ph.CBC1_Description__c = 'Appliances';
        insert ph;
        
        Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
        ph1.Name = '1234';
        ph1.CBC2__c = '13213';
        ph1.CBC3__c = '30033';
        ph1.CBC1_Description__c = 'Appliances';
        insert ph1;
        
        Product_Hierarchy__c ph2 = new Product_Hierarchy__c();
        ph2.Name = '1234';
        ph2.CBC1__c = '45678';
        ph2.CBC2__c = '13213';
        ph2.CBC3__c = '30033';
        ph2.CBC1_Description__c = 'Appliances';
        insert ph2;
        
        Part__c part = new Part__c();
        part.Name = 'testPart';
        part.GPL__c = ph.Id;
        part.Product_Hierarchy__c = ph.Id; 
        part.Description__c = 'test';
        part.PRODUCT_CDE__c = 'TEST1';
        part.PROD_NAME__c = 'test name1';
        insert part;
        
        Part__c part1 = new Part__c();
        part1.Name = 'testPart';
        part1.GPL__c = ph1.Id;
        part1.Product_Hierarchy__c = ph1.Id; 
        part1.Description__c = 'test';
        part1.PRODUCT_CDE__c = 'TEST2';
        part1.PROD_NAME__c = 'test name2';
        insert part1;
        
        Part__c part2 = new Part__c();
        part2.Name = 'testPart';
        part2.GPL__c = ph2.Id;
        part2.Product_Hierarchy__c = ph2.Id; 
        part2.Description__c = 'test';
        part2.PRODUCT_CDE__c = 'TEST3';
        part2.PROD_NAME__c = 'test name3';
        insert part2;
        
        CSD_Sales_Forecast__c csdFC1 = new CSD_Sales_Forecast__c();
        csdFC1.Type__c = 'Sold-To';
        csdFC1.Fiscal_Year__c = '2016';
        csdFC1.Fiscal_Month__c = '1';
        csdFC1.Sold_To_Number__c = '1234:12345678';
        csdFC1.Sold_To_Name__c = 'Test';
        csdFC1.Forecast__c = 1000;
        csdFC1.Billing_Region__c = 'AMERICAS';
        insert csdFC1;
        
        CSD_Sales_Forecast__c csdFC2 = new CSD_Sales_Forecast__c();
        csdFC2.type__c = 'OEM';
        csdFC2.Fiscal_Year__c = '2016';
        csdFC2.Fiscal_Month__c = '2';
        csdFC2.Sold_To_Number__c = '1234:12345678';
        csdFC2.Sold_To_Name__c = 'Test';
        csdFC2.OEM__c = acct2.Id;
        csdFC2.Forecast__c = 1000;
        csdFC2.Billing_Region__c = 'AMERICAS';
        insert csdFC2;
        
        
        CSD_Sales_Forecast__c csdFC3 = new CSD_Sales_Forecast__c();
        csdFC3.type__c = 'Part';
        csdFC3.Fiscal_Year__c = '2016';
        csdFC3.Fiscal_Month__c = '3';
        csdFC3.Sold_To_Number__c = '1234:12345678';
        csdFC3.Sold_To_Name__c = 'Test';
        csdFC3.Part__c = part1.Id;
        csdFC3.Forecast__c = 100;
        csdFC3.OEM__c = acct2.Id;
        csdFC3.Price__c = 10;
        csdFC3.Quantity__c = 10;
        csdFC3.Billing_Region__c = 'AMERICAS';
        insert csdFC3;
        
        CSD_Sales_Forecast__c csdFC4 = new CSD_Sales_Forecast__c();
        csdFC4.type__c = 'Part';
        csdFC4.Fiscal_Year__c = '2016';
        csdFC4.Fiscal_Month__c = '4';
        csdFC4.Sold_To_Number__c = '1234:12345678';
        csdFC4.Sold_To_Name__c = 'Test';
        csdFC4.Part__c = part1.Id;
        csdFC4.Forecast__c = 100;
        csdFC4.OEM__c = acct2.Id;
        csdFC4.Price__c = 10;
        csdFC4.Quantity__c = 10;
        csdFC4.Billing_Region__c = 'TAIWAN';
        insert csdFC4;
        
        CSD_Sales_Forecast__c csdFC5 = new CSD_Sales_Forecast__c();
        csdFC5.type__c = 'Part';
        csdFC5.Fiscal_Year__c = '2016';
        csdFC5.Fiscal_Month__c = '5';
        csdFC5.Sold_To_Number__c = '1234:12345678';
        csdFC5.Sold_To_Name__c = 'Test';
        csdFC5.Part__c = part1.Id;
        csdFC5.Forecast__c = 100;
        csdFC5.OEM__c = acct2.Id;
        csdFC5.Price__c = 10;
        csdFC5.Quantity__c = 10;
        csdFC5.Billing_Region__c = 'TAIWAN';
        insert csdFC5;
        
        
        RecordType rt25 = ClsTestHelp.createTestRecordType25(); 
        CSD_Forecast_Management__c csd = new CSD_Forecast_Management__c();
        csd.Name = 'testName';
        csd.Role__c = 'Sales Leader';
        csd.User__c = userInfo.getUserId();
        insert csd;
        
        OEM_Details__c oemd = new OEM_Details__c();
        oemd.OEM__c = acct2.Id;
        insert oemd;
        
        OEM_Mapping_Rule__c oemmap = new OEM_Mapping_Rule__c();
        oemmap.OEM__c = oemd.Id;
        oemmap.Allocation__c = 100;
        oemmap.Sold_To_Account_Code__c = '12345678';
        oemmap.Type__c = 'Customer';
        insert oemmap;
        
        BBB_Month_Bill_Book_Cust_PN__c bbbMon = new BBB_Month_Bill_Book_Cust_PN__c();
        bbbMon.Customer__c = acct1.Id;
        bbbMon.Bill_Amount_USD__c = 10;
        bbbMon.Book_Amount_USD__c = 10; 
        bbbMon.Fiscal_Year__c = '2015';
        bbbMon.Fiscal_Month__c = 10;
        bbbMon.Profit_Center__c = 'CSD';
        bbbMon.Part__c = part.Id;
        insert bbbMon;
        
        OEM_Mapping_Rule__c oemmap2 = new OEM_Mapping_Rule__c();
        oemmap2.OEM__c = oemd.Id;
        oemmap2.Allocation__c = 100;
        oemmap2.Sold_To_Account_Code__c = '12345678';
        oemmap2.Type__c = 'Customer';
        insert oemmap2;
        
        BBB_Month_Bill_Book_Cust_PN__c bbbMon2 = new BBB_Month_Bill_Book_Cust_PN__c();
        bbbMon2.Customer__c = acct1.Id;
        bbbMon2.Bill_Amount_USD__c = 10;
        bbbMon2.Book_Amount_USD__c = 10; 
        bbbMon2.Fiscal_Year__c = '2015';
        bbbMon2.Fiscal_Month__c = 11;
        bbbMon2.Profit_Center__c = 'CSD';
        bbbMon2.Part__c = part.Id;
        insert bbbMon2;

        CSD_OEM_Mapping_Monthly_BBB__c monmap = new CSD_OEM_Mapping_Monthly_BBB__c();
        monmap.Monthly_Billings_Bookings_by_Part__r = bbbMon;
        monmap.OEM_Mapping__c = oemmap.Id;
        
        CSD_OEM_Mapping_Monthly_BBB__c monmap2 = new CSD_OEM_Mapping_Monthly_BBB__c();
        monmap2.Monthly_Billings_Bookings_by_Part__r = bbbMon2;
        monmap2.OEM_Mapping__c = oemmap2.Id;
        
        
        BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c bbbDay = new BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c();
        bbbDay.Backlog_Amount_USD__c = 10;
        bbbDay.Bill_Amount_USD__c = 10; 
        bbbDay.Book_Amount_USD__c = 10;
        bbbDay.Customer__c = acct1.Id;
        bbbDay.Fiscal_Year__c = '2015';
        bbbDay.Fiscal_Month__c = 10;
        bbbDay.Customer_Request_Date_Fiscal_Year__c = '2015';
        bbbday.Customer_Request_Date_Fiscal_Month__c = 10;
        bbbDay.Profit_Center__c = 'CSD';
        bbbDay.Part__c = part.Id;
        insert bbbDay;
        
        BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c bbbDay2 = new BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c();
        bbbDay2.Backlog_Amount_USD__c = 10;
        bbbDay2.Bill_Amount_USD__c = 10; 
        bbbDay2.Book_Amount_USD__c = 10;
        bbbDay2.Customer__c = acct1.Id;
        bbbDay2.Fiscal_Year__c = '2015';
        bbbDay2.Fiscal_Month__c = 11;
        bbbDay2.Customer_Request_Date_Fiscal_Year__c = '2015';
        bbbDay2.Customer_Request_Date_Fiscal_Month__c = 11;
        bbbDay2.Profit_Center__c = 'CSD';
        bbbDay2.Part__c = part.Id;
        insert bbbDay2;

        CSD_OEM_Mapping_Daily_BBB__c daymap = new CSD_OEM_Mapping_Daily_BBB__c();
        daymap.Daily_Booking_Billing_Backlog_By_Part__c = bbbDay.Id;
        daymap.CSD_OEM_Mapping__c  = oemmap.Id;
        insert daymap;
        
        CSD_OEM_Mapping_Daily_BBB__c daymap2 = new CSD_OEM_Mapping_Daily_BBB__c();
        daymap2.Daily_Booking_Billing_Backlog_By_Part__c = bbbDay2.Id;
        daymap2.CSD_OEM_Mapping__c  = oemmap2.Id;
        insert daymap2;
        
        CSD_ClsEntityType.SearchObj so = new CSD_ClsEntityType.SearchObj();
        so.set_fiscalMonth = new set<String>();
        so.set_fiscalMonth.add('2015_8');//'2015_5' shawn
        so.set_fiscalMonth.add('2015_9');//'2015_9' shawn
        so.set_fiscalMonth.add('2015_10');//'2015_8' shawn
        so.set_fiscalMonth.add('2015_11');//'2015_8' shawn
        
        so.map_year_monthsFuture = new map<String, set<Integer>>{
            '2015'=> new set<Integer>{9,10,11},
            '2016'=> new set<Integer>{2,3,4,5}
        };
        
        so.startDate = '2015-08-15';
        so.endDate = '2016-06-15';

        String sData = JSON.serialize(so);
        String result = '';
        
        
        CSD_CtrlGAMViewForecast ctrl = new CSD_CtrlGAMViewForecast();
        
        CSD_ClsGAMViewService.SearchLevel1 level1 = new CSD_ClsGAMViewService.SearchLevel1();
        
        so.oemId = acct2.Id;
        sData = JSON.serialize(so);
        
        result = level1.getRefData(sData);
        result = level1.getBacklogRefData(sData);
        
        
        CSD_ClsGAMViewService.SearchLevel2 level2 = new CSD_ClsGAMViewService.SearchLevel2();
        
        result = level2.getExistResult(sData);
        so.type = 'channel';
        so.region = 'AMERICAS';
        sData = JSON.serialize(so);
        result = level2.getExistResult(sData);
        
        result = level2.getRefData(sData);
        result = level2.getBacklogRefData(sData);
        
        
        CSD_ClsGAMViewService.SearchLevel3 level3 = new CSD_ClsGAMViewService.SearchLevel3();

        result = level3.getExistResult(sData);
        so.accnumber = '1234:12345678';
        sData = JSON.serialize(so);
        result = level3.getRefData(sData);
        result = level3.getBacklogRefData(sData);
    }
    
    static testMethod void myUnitTest4() {
        
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
        
        RecordType rtsoldto = ClsTestHelp.createTestRecordType8();
        RecordType rtoem = ClsTestHelp.createCSDTestRecordType7(); 
        
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

        Account acct1 = ClsTestHelp.createTestAccounts();
        acct1.Name = 'axx';
        acct1.RecordTypeId = rtsoldto.Id;
        acct1.AccountNumber = '1234:12345678';
        acct1.Account_Manager__c = userInfo.getUserId();
        acct1.STATDESC__c = 'Active';
        acct1.SALES_TERRITORY_CDE__c = '123456';
        acct1.Relay_Specialist_Territory_Code__c = '123456';  
        acct1.Sales_Hierarchy__c = sh.Id;    
        //acct.Territory_L2_code__c = '103004';
        insert acct1;
        
        Account acct2 = ClsTestHelp.createTestAccounts();
        acct2.Name = 'relayAcctaxx';
        acct2.RecordTypeId = rtoem.Id;
        acct2.AccountNumber = '1234:12345678';
        acct2.Account_Manager__c = userInfo.getUserId();
        acct2.SALES_TERRITORY_CDE__c = '123456';
        acct2.Relay_Specialist_Territory_Code__c = '123456';  
        acct2.GAMCD__c = '1234'; 
        acct2.Sales_Hierarchy__c = sh.Id;
        acct2.STATDESC__c = 'Active';
        acct2.Active__c = true;
        insert acct2;

        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Name = '123';
        ph.CBC2__c = '30012';
        ph.CBC3__c = '30033';
        ph.CBC1_Description__c = 'Appliances';
        insert ph;
        
        Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
        ph1.Name = '1234';
        ph1.CBC2__c = '13213';
        ph1.CBC3__c = '30033';
        ph1.CBC1_Description__c = 'Appliances';
        insert ph1;
        
        Product_Hierarchy__c ph2 = new Product_Hierarchy__c();
        ph2.Name = '1234';
        ph2.CBC1__c = '45678';
        ph2.CBC2__c = '13213';
        ph2.CBC3__c = '30033';
        ph2.CBC1_Description__c = 'Appliances';
        insert ph2;
        
        Part__c part = new Part__c();
        part.Name = 'testPart';
        part.GPL__c = ph.Id;
        part.Product_Hierarchy__c = ph.Id; 
        part.Description__c = 'test';
        part.PRODUCT_CDE__c = 'TEST1';
        part.PROD_NAME__c = 'test name1';
        insert part;
        
        Part__c part1 = new Part__c();
        part1.Name = 'testPart';
        part1.GPL__c = ph1.Id;
        part1.Product_Hierarchy__c = ph1.Id; 
        part1.Description__c = 'test';
        part1.PRODUCT_CDE__c = 'TEST2';
        part1.PROD_NAME__c = 'test name2';
        insert part1;
        
        Part__c part2 = new Part__c();
        part2.Name = 'testPart';
        part2.GPL__c = ph2.Id;
        part2.Product_Hierarchy__c = ph2.Id; 
        part2.Description__c = 'test';
        part2.PRODUCT_CDE__c = 'TEST3';
        part2.PROD_NAME__c = 'test name3';
        insert part2;
        
        CSD_Sales_Forecast__c csdFC1 = new CSD_Sales_Forecast__c();
        csdFC1.Type__c = 'Sold-To';
        csdFC1.Fiscal_Year__c = '2016';
        csdFC1.Fiscal_Month__c = '3';
        csdFC1.Sold_To_Number__c = '1234:12345678';
        csdFC1.Sold_To_Name__c = 'Test';
        csdFC1.Forecast__c = 1000;
        csdFC1.Billing_Region__c = 'AMERICAS';
        insert csdFC1;
        
        CSD_Sales_Forecast__c csdFC2 = new CSD_Sales_Forecast__c();
        csdFC2.type__c = 'OEM';
        csdFC2.Fiscal_Year__c = '2016';
        csdFC2.Fiscal_Month__c = '4';
        csdFC2.Sold_To_Number__c = '1234:12345678';
        csdFC2.Sold_To_Name__c = 'Test';
        csdFC2.OEM__c = acct2.Id;
        csdFC2.Forecast__c = 1000;
        csdFC2.Billing_Region__c = 'AMERICAS';
        insert csdFC2;
        
        
        CSD_Sales_Forecast__c csdFC3 = new CSD_Sales_Forecast__c();
        csdFC3.type__c = 'Part';
        csdFC3.Fiscal_Year__c = '2016';
        csdFC3.Fiscal_Month__c = '5';
        csdFC3.Sold_To_Number__c = '1234:12345678';
        csdFC3.Sold_To_Name__c = 'Test';
        csdFC3.Part__c = part1.Id;
        csdFC3.Forecast__c = 100;
        csdFC3.OEM__c = acct2.Id;
        csdFC3.Price__c = 10;
        csdFC3.Quantity__c = 10;
        csdFC3.Billing_Region__c = 'AMERICAS';
        insert csdFC3;
        
        CSD_Sales_Forecast__c csdFC4 = new CSD_Sales_Forecast__c();
        csdFC4.type__c = 'Part';
        csdFC4.Fiscal_Year__c = '2016';
        csdFC4.Fiscal_Month__c = '6';
        csdFC4.Sold_To_Number__c = '1234:12345678';
        csdFC4.Sold_To_Name__c = 'Test';
        csdFC4.Part__c = part1.Id;
        csdFC4.Forecast__c = 100;
        csdFC4.OEM__c = acct2.Id;
        csdFC4.Price__c = 10;
        csdFC4.Quantity__c = 10;
        csdFC4.Billing_Region__c = 'TAIWAN';
        insert csdFC4;
        
        CSD_Sales_Forecast__c csdFC5 = new CSD_Sales_Forecast__c();
        csdFC5.type__c = 'Part';
        csdFC5.Fiscal_Year__c = '2015';
        csdFC5.Fiscal_Month__c = '12';
        csdFC5.Sold_To_Number__c = '1234:12345678';
        csdFC5.Sold_To_Name__c = 'Test';
        csdFC5.Part__c = part1.Id;
        csdFC5.Forecast__c = 100;
        csdFC5.OEM__c = acct2.Id;
        csdFC5.Price__c = 10;
        csdFC5.Quantity__c = 10;
        csdFC5.Billing_Region__c = 'TAIWAN';
        insert csdFC5;

        
        RecordType rt25 = ClsTestHelp.createTestRecordType25(); 
        CSD_Forecast_Management__c csd = new CSD_Forecast_Management__c();
        csd.Name = 'testName';
        csd.Role__c = 'Sales Leader';
        csd.User__c = userInfo.getUserId();
        insert csd;
        
        
        OEM_Details__c oemd = new OEM_Details__c();
        oemd.OEM__c = acct2.Id;
        insert oemd;
        
        OEM_Mapping_Rule__c oemmap = new OEM_Mapping_Rule__c();
        oemmap.OEM__c = oemd.Id;
        oemmap.Allocation__c = 100;
        oemmap.Sold_To_Account_Code__c = '12345678';
        oemmap.Type__c = 'Customer';
        insert oemmap;
        
        BBB_Month_Bill_Book_Cust_PN__c bbbMon = new BBB_Month_Bill_Book_Cust_PN__c();
        bbbMon.Customer__c = acct1.Id;
        bbbMon.Bill_Amount_USD__c = 10;
        bbbMon.Book_Amount_USD__c = 10; 
        bbbMon.Fiscal_Year__c = '2015';
        bbbMon.Fiscal_Month__c = 10;
        bbbMon.Profit_Center__c = 'CSD';
        bbbMon.Part__c = part.Id;
        insert bbbMon;

        CSD_OEM_Mapping_Monthly_BBB__c monmap = new CSD_OEM_Mapping_Monthly_BBB__c();
        monmap.Monthly_Billings_Bookings_by_Part__r = bbbMon;
        monmap.OEM_Mapping__c = oemmap.Id;
        
        
        BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c bbbDay = new BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c();
        bbbDay.Backlog_Amount_USD__c = 10;
        bbbDay.Bill_Amount_USD__c = 10; 
        bbbDay.Book_Amount_USD__c = 10;
        bbbDay.Customer__c = acct1.Id;
        bbbDay.Fiscal_Year__c = '2015';
        bbbDay.Fiscal_Month__c = 11;
        bbbDay.Customer_Request_Date_Fiscal_Year__c = '2015';
        bbbday.Customer_Request_Date_Fiscal_Month__c = 11;
        bbbDay.Profit_Center__c = 'CSD';
        bbbDay.Part__c = part.Id;
        insert bbbDay;

        CSD_OEM_Mapping_Daily_BBB__c daymap = new CSD_OEM_Mapping_Daily_BBB__c();
        daymap.Daily_Booking_Billing_Backlog_By_Part__c = bbbDay.Id;
        daymap.CSD_OEM_Mapping__c  = oemmap.Id;
        insert daymap;
        
        
        CSD_ClsEntityType.SearchObj so = new CSD_ClsEntityType.SearchObj();
        so.set_fiscalMonth = new set<String>();
        so.set_fiscalMonth.add('2015_10');
        so.set_fiscalMonth.add('2015_11');
        so.set_fiscalMonth.add('2015_12');
        so.set_fiscalMonth.add('2016_1');
        so.set_fiscalMonth.add('2016_2');
        so.set_fiscalMonth.add('2016_3');
        so.set_fiscalMonth.add('2016_4');
        so.set_fiscalMonth.add('2016_5');
        so.set_fiscalMonth.add('2016_6');
        so.map_year_monthsFuture = new map<String, set<Integer>>{
            '2015'=> new set<Integer>{10,11,12},
            '2016'=> new set<Integer>{1,2,3,4,5,6}
        };
        
        so.startDate = '2015-08-15';
        so.endDate = '2016-07-15';
        so.oemId = acct2.Id;
        so.region = 'AMERICAS';
        so.accnumber = '1234:12345678';
        so.partId = part1.Id;
        String sData = JSON.serialize(so);
        String result = '';
        
        
        CSD_ClsGAMViewService.SearchLevel4 level4 = new CSD_ClsGAMViewService.SearchLevel4();

        result = level4.getExistResult(sData);
        result = level4.getRefData(sData);
        result = level4.getBacklogRefData(sData);
        
        
        CSD_ClsGAMViewService.SearchTotal total = new CSD_ClsGAMViewService.SearchTotal();

        result = total.getTotalBillingData(sData);

    }
    
     static testMethod void myUnitTestZhou() {
      Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();
        
      RecordType rtsoldto = ClsTestHelp.createTestRecordType8();
      RecordType rtoem = ClsTestHelp.createCSDTestRecordType7();
      
      Consumer_Device_Opportunity_Record_Types__c cdort1 = ClsTestHelp.createTestCSD1();
      Consumer_Device_Opportunity_Record_Types__c cdort2 = ClsTestHelp.createTestCSD2();
      Consumer_Device_Opportunity_Record_Types__c cdort3 = ClsTestHelp.createTestCSD3();
      Consumer_Device_Opportunity_Record_Types__c cdort4 = ClsTestHelp.createTestCSD4();
      Consumer_Device_Opportunity_Record_Types__c cdort5 = ClsTestHelp.createTestCSD5();
      Consumer_Device_Opportunity_Record_Types__c cdort6 = ClsTestHelp.createTestCSD6();
      Consumer_Device_Opportunity_Record_Types__c cdort7 = ClsTestHelp.createTestCSD7();
      
      //CSD_Configuration__c cfg = new CSD_Configuration__c();
      //cfg.name = 'Samsung OEM Account';
      //insert cfg;
      
      User user = ClsTestHelp.createTestUsers(); 
        user.FirstName ='TeFirst';
        user.LastName = 'Tester';
        user.Username = 'tetest2@tetest.com';
        user.Te_Network_Id__c = 'ABCDEFG';
        user.Email = 'tetest2@tetest.com';
        insert user;
        
        Account samsung = ClsTestHelp.createTestAccounts();
      samsung.Name = 'samsung';
       samsung.RecordTypeId = rtoem.Id;
       samsung.Account_Manager__c = user.Id;
       samsung.Design_In_Region__c = 'KOREA';
       samsung.STATDESC__c = 'Active';
       samsung.Active__c = true;
      insert samsung;
      
        String clsName4Search = 'CSD_ClsSoldToService.SearchSoldTo';
        String clsName4Exist = 'CSD_ClsSoldToService.SearchOEM';
        String clsName4Save = 'CSD_ClsSoldToService.SearchSoldTo';
        String clsName4Del = 'CSD_ClsSoldToService.SearchSoldTo';
        String clsName4GetASP = 'CSD_ClsSoldToService.SearchPart';
        String clsName4GetRef = 'CSD_ClsSoldToService.SearchSoldTo';
        String clsName4GetCFT = 'CSD_ClsSoldToService.SearchPart';
        String clsName4GetBack = 'CSD_ClsSoldToService.SearchSoldTo';
        String clsName4GetTotal = 'CSD_ClsSoldToService.SearchTotal';
        
        CSD_ClsEntityType.AccountObj ao = new CSD_ClsEntityType.AccountObj();
        ao.id = CSD_ClsUtils.getHexUID();
    ao.name = 'Channel';
    ao.type = 'totalchannel';
        String accountStr = JSON.serialize(ao);
        
        CSD_ClsEntityType.SearchObj so = new CSD_ClsEntityType.SearchObj();
        so.set_fiscalMonth = new set<String>();
        so.set_fiscalMonth.add('2015_5');
    so.set_fiscalMonth.add('2015_9');
        so.set_fiscalMonth.add('2015_8');
        
        so.map_year_monthsFuture = new map<String, set<Integer>>{
          '2015'=> new set<Integer>{3,4,5,6,7,8,9,10,11}
        };
        
        so.map_quarter_months =  new map<String, String>{
          '01'=>'1,2,3',
          '02'=>'4,5,6',
          '03'=>'7,8,9',
          '04'=>'10,11,12'
        };
        so.set_selectedId = new set<String>();
    so.startDate = '2015-03-15';
    so.endDate = '2015-11-15';
    
    so.managerId = user.Id;
    so.searchKey = '';
    //View Mode
    so.viewMode = 'forecast';
    so.isOtherMethod = false;
    so.gplfamily = 'gplfamily';
    //so.oemId = samsung.Id;
        String searchStr = JSON.serialize(so);
        System.debug('View JOSN ' + searchStr);
      
        Test.startTest();
    try {CSD_CtrlForecastRemoteBase.searchCSDsObject(clsName4Search,searchStr);
    }catch (Exception e){System.debug(e.getMessage());}
    
    try {CSD_CtrlForecastRemoteBase.existCSDsObject(clsName4Exist,searchStr);
    }catch (Exception e){System.debug(e.getMessage());}
    
    try {CSD_CtrlForecastRemoteBase.saveCSDsObject(clsName4Save,accountStr);
    }catch (Exception e){System.debug(e.getMessage());}
    
    try {CSD_CtrlForecastRemoteBase.delCSDsOjbect(clsName4Del,searchStr);
    }catch (Exception e){System.debug(e.getMessage());}
    
    try {CSD_CtrlForecastRemoteBase.getASPData(clsName4GetASP,searchStr);
    }catch (Exception e){System.debug(e.getMessage());}
    
    try {CSD_CtrlForecastRemoteBase.getRefData(clsName4GetRef,searchStr);
    }catch (Exception e){System.debug(e.getMessage());}
    
    try {CSD_CtrlForecastRemoteBase.getCFTData(clsName4GetCFT,searchStr);
    }catch (Exception e){System.debug(e.getMessage());}
    
    try {CSD_CtrlForecastRemoteBase.getBacklogRefData(clsName4GetBack,searchStr);
    }catch (Exception e){System.debug(e.getMessage());}
    
    try {CSD_CtrlForecastRemoteBase.getTotalBillingData(clsName4GetTotal,searchStr);
    }catch (Exception e){System.debug(e.getMessage());}
    
    try {CSD_CtrlForecastRemoteBase.getTotalBillingData('invalid_className',searchStr);
    }catch (Exception e){System.debug(e.getMessage());}
        Test.stopTest();
    }
}