/**
*  This test class used to test class ClsAPLServiceRSM.
*
@author Lili Zhao
@created 2014-08-15
*
@changelog
* coverage  89%
*  
2014-08-15 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest
private class ClsAPLServiceRSM_Test {

    static testMethod void myUnitTest02() {
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();
        
        //RecordType rt = ClsTestHelp.createTestRecordType8();
        RecordType rt2 = ClsTestHelp.createTestRecordType8();
        
        
        Consumer_Device_Opportunity_Record_Types__c cdort1 = ClsTestHelp.createTestCSD1();
        Consumer_Device_Opportunity_Record_Types__c cdort2 = ClsTestHelp.createTestCSD2();
        Consumer_Device_Opportunity_Record_Types__c cdort3 = ClsTestHelp.createTestCSD3();
        Consumer_Device_Opportunity_Record_Types__c cdort4 = ClsTestHelp.createTestCSD4();
        Consumer_Device_Opportunity_Record_Types__c cdort5 = ClsTestHelp.createTestCSD5();
        Consumer_Device_Opportunity_Record_Types__c cdort6 = ClsTestHelp.createTestCSD6();
        Consumer_Device_Opportunity_Record_Types__c cdort7 = ClsTestHelp.createTestCSD7();
        
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy1();
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
        acct.APL_AM_Display_Name__c = 'amName';
        acct.Account_Manager__c = userInfo.getUserId();
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
        relayAcct.Relay_Specialist_Territory_Code__c = 'test';   
        relayAcct.GAMCD__c = '1234'; 
        relayAcct.Sales_Hierarchy__c = sh.Id;   
        relayAcct.SALES_TERRITORY_CDE__c = 'test';
        relayAcct.STATDESC__c = 'Active';
        insert relayAcct;
        
        /*Account relayAcct1 = ClsTestHelp.createTestAccounts();
        relayAcct1.Name = 'relayAcctaxx';
        relayAcct1.RecordTypeId = rt2.Id;
        relayAcct1.Account_Manager__c = userInfo.getUserId();
        relayAcct1.APL_Relay_forecast_Plan_Account__c = null;
        relayAcct1.APL_Relay_Currency__c = 'USD';
        relayAcct1.APL_Relay_Display_Name__c = 'testName';
        relayAcct1.APL_Relay_ParentAccount__c = acct.Id;
        relayAcct1.Relay_Specialist_Territory_Code__c = 'test';   
        relayAcct1.GAMCD__c = '1234';   
        relayAcct1.SALES_TERRITORY_CDE__c = 'test';
        insert relayAcct1;*/
        
        Account amAcct = ClsTestHelp.createTestAccounts();
        amAcct.Name = 'axx';
        amAcct.RecordTypeId = rt2.Id;
        amAcct.APL_Relay_forecast_Plan_Account__c = null;
        amAcct.APL_AM_forecast_Plan_Account__c = acct.Id;
        amAcct.APL_AM_Currency__c = 'USD';
        amAcct.APL_AM_Display_Name__c = 'amName';
        amAcct.APL_AM_ParentAccount__c = acct.Id;       
        amAcct.Account_Manager__c = userInfo.getUserId();
        amAcct.SALES_TERRITORY_CDE__c = 'test';
        amAcct.GAMCD__c = '1234';
        amAcct.Sales_Hierarchy__c = sh.Id; 
        amAcct.STATDESC__c = 'Active'; 
        insert amAcct;
        
        Account amAcct1 = ClsTestHelp.createTestAccounts();
        amAcct1.Name = 'axx';
        amAcct1.RecordTypeId = rt2.Id;
        amAcct1.APL_AM_forecast_Plan_Account__c = null;
        amAcct1.APL_AM_Currency__c = 'USD';
        amAcct1.APL_AM_Display_Name__c = 'amName';
        amAcct1.APL_AM_ParentAccount__c = acct.Id;      
        amAcct1.Account_Manager__c = userInfo.getUserId();
        amAcct1.SALES_TERRITORY_CDE__c = 'test';
        amAcct.GAMCD__c = '1234';
        amAcct.Sales_Hierarchy__c = sh.Id;  
        insert amAcct1;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Name = '123';
        ph.CBC2__c = '30012';
        ph.CBC3__c = '30033';
        ph.CBC1_Description__c = 'Appliances';
        ph.GPL_Description__c = 'Test desc';
        insert ph;
        
        Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
        ph1.Name = '1234';
        ph1.CBC2__c = '13213';
        ph1.CBC3__c = '30033';
        ph1.CBC1_Description__c = 'Appliances';
        insert ph1;
        
        Part__c part = new Part__c();
        part.Name = 'testPart';
        part.GPL__c = ph.Id;
        part.Product_Hierarchy__c = ph.Id; 
        part.Description__c = 'test';
        insert part;
        
        string curYear = string.valueof(Date.Today().Year());//Added by Mrunal
        string curQuart = string.valueof(date.today().month()/3);//Added by Mrunal
        Integer curMonth = Integer.valueof(date.today().month());//Added by Mrunal
        string key= curYear+'_'+curQuart;//Added by Mrunal
        
        APL_Sales_Forecast__c aplFC1 = new APL_Sales_Forecast__c();
        aplFC1.type__c = 'GPL';
        aplFC1.Fiscal_Year__c = curYear ;
        aplFC1.Fiscal_Quarter__c = curQuart ;
        aplFC1.customer__c = amAcct.Id;
        aplFC1.RSM_Forecast__c = 10;
        aplFC1.GPL__c = ph.Id;
        aplFC1.Part__c = part.Id;
        insert aplFC1;
        
        APL_Sales_Forecast__c aplFC2 = new APL_Sales_Forecast__c();
        aplFC2.type__c = 'Relay';
        aplFC2.Fiscal_Year__c = curYear ;
        aplFC2.Fiscal_Quarter__c = curQuart ;
        aplFC2.customer__c = relayAcct.Id;
        aplFC2.Part__c = part.Id;
        aplFC2.GPL__c = ph1.Id;
        aplFC2.RSM_Forecast__c = 10;
        insert aplFC2;
        
        APL_Sales_Forecast__c aplFC3 = new APL_Sales_Forecast__c();
        aplFC3.type__c = 'Relay';
        aplFC3.Fiscal_Year__c = curYear ;
        aplFC3.Fiscal_Quarter__c = curQuart ;
        aplFC3.customer__c = relayAcct.Id;
        aplFC3.Part__c = part.Id;
        aplFC3.GPL__c = ph1.Id;
        aplFC3.RSM_Forecast__c = 10;
        insert aplFC3;
        
        
        
        APL_RSM__c aplRsm = new APL_RSM__c();
        aplRsm.Manager__c = userInfo.getUserId();
        aplRsm.Display_Name__c = 'test';
        insert aplRsm;
        
        APL_RSM__c aplRsm1 = new APL_RSM__c();
        aplRsm1.Manager__c = userInfo.getUserId();
        aplRsm1.Type__c = 'Relay';
        aplRsm1.Display_Name__c = 'test2';
        insert aplRsm1;
        
        APL_RSM__c aplRsm2 = new APL_RSM__c();
        aplRsm2.Manager__c = userInfo.getUserId();
        aplRsm2.Type__c = 'AM';
        aplRsm2.Display_Name__c = 'test1';
        aplRsm2.APL_RSM__c = aplRsm1.Id;
        insert aplRsm2;
        
        RecordType rt25 = ClsTestHelp.createTestRecordType25(); 
        APL_Forecast_Management__c apl = new APL_Forecast_Management__c();
        apl.Name = 'testName';
        apl.A6_Code__c = '123456';
        apl.Manager__c = userInfo.getUserId();  
        apl.RSM__c = aplRsm2.Id;
        apl.GAM_Code__c = '1234';
        apl.RecordTypeId = rt25.Id;
        insert apl;
        
        APL_Forecast_Management__c apl1 = new APL_Forecast_Management__c();
        apl1.Name = 'testName1';
        apl1.A6_Code__c = '1234567';
        apl1.GAM_Code__c = '1234';
        apl1.Manager__c = userInfo.getUserId();
        apl1.RecordTypeId = rt25.Id;
        apl1.RSM__c = aplRsm1.Id;
        insert apl1;
        
        BBB_Year_Bill_Book_Cust_PN__c bbbyr = new BBB_Year_Bill_Book_Cust_PN__c();
        bbbyr.Bill_Year_to_Date_Amount_Document__c = 100;
        bbbyr.Bill_Prior_Year_Amount_USD__c= 100;
        bbbyr.BU_Profit_Center__c = 'APL';
        bbbyr.Year__c = curYear ;
        bbbyr.Part__c = part.Id;
        bbbyr.Customer__c = amAcct.Id;
        bbbyr.Billings_Month_1__c = 10;
        insert bbbyr;
        
        BBB_Month_Bill_Book_Cust_PN__c bbbMon = new BBB_Month_Bill_Book_Cust_PN__c();
        bbbMon.Customer__c = amAcct.Id;
        bbbMon.Bill_Amount_USD__c = 10;
        bbbMon.Book_Amount_USD__c = 10; 
        bbbMon.Fiscal_Year__c = '2014';
        bbbMon.Fiscal_Month__c = 4;
        bbbMon.Profit_Center__c = 'APL';
        bbbMon.Part__c = part.Id;
        insert bbbMon;
        
        BBB_Month_Bill_Book_Cust_PN__c bbbMon1 = new BBB_Month_Bill_Book_Cust_PN__c();
        bbbMon1.Customer__c = amAcct.Id;
        bbbMon1.Bill_Amount_USD__c = 10;
        bbbMon1.Book_Amount_USD__c = 10; 
        bbbMon1.Fiscal_Year__c = curYear;
        bbbMon1.Fiscal_Month__c = curMonth;
        bbbMon1.Profit_Center__c = 'APL';
        bbbMon1.Part__c = part.Id;
        insert bbbMon1;
        
        BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c bbbDay = new BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c();
        bbbDay.Backlog_Amount_USD__c = 10;
        bbbDay.Bill_Amount_USD__c = 10; 
        bbbDay.Book_Amount_USD__c = 10;
        bbbDay.Customer__c = amAcct.Id;
        bbbDay.Fiscal_Year__c = '2014';
        bbbDay.Fiscal_Month__c = 4;
        bbbDay.Customer_Request_Date__c = date.today();
        bbbDay.Customer_Request_Date_Fiscal_Year__c = '2014';
        bbbday.Customer_Request_Date_Fiscal_Month__c = 4;
        bbbDay.Profit_Center__c = 'APL';
        bbbDay.Part__c = part.Id;
        insert bbbDay;
        
        BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c bbbDay1 = new BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c();
        bbbDay1.Backlog_Amount_USD__c = 10;
        bbbDay1.Bill_Amount_USD__c = 10; 
        bbbDay1.Book_Amount_USD__c = 10;
        bbbDay1.Customer__c = amAcct.Id;
        bbbDay1.Fiscal_Year__c = curYear;
        bbbDay1.Fiscal_Month__c = curMonth;
        bbbDay1.Customer_Request_Date__c = date.today();
        bbbDay1.Customer_Request_Date_Fiscal_Year__c = curYear;
        bbbDay1.Customer_Request_Date_Fiscal_Month__c = curMonth;
        bbbDay1.Profit_Center__c = 'APL';
        bbbDay1.Part__c = part.Id;
        insert bbbDay1;
        
        APL_RSM_Overall_Forecast__c aplOver = new APL_RSM_Overall_Forecast__c();
        aplOver.Fiscal_Quarter__c = '04';
        aplOver.Fiscal_Year__c = '2014';
        aplOver.APL_RSM__c = aplRsm.Id;
        aplOver.RSM_Overall_Forecast__c = 10;       
        insert aplOver;
        
        ClsAPLEntityTypes.PageConfig pageConf = new ClsAPLEntityTypes.PageConfig();
        pageConf.set_rsmAMTerritoryCodes.add('test');
        pageConf.map_year_quartersFuture.put('2014', new set<String>());
        pageConf.map_year_quartersFuture.get('2014').add('04');
        
        ClsAPLEntityTypes.RSMAMOverRallInfo rsmOverRall = new ClsAPLEntityTypes.RSMAMOverRallInfo();
        rsmOverRall.managerId = userInfo.getUserId();
        rsmOverRall.displayName = 'test';
        rsmOverRall.map_year_quartersFuture = new map<String, set<String>>();    
        rsmOverRall.map_year_quartersFuture.put('2014', new set<String>());
        rsmOverRall.map_year_quartersFuture.get('2014').add('04');
        
        ClsAPLEntityTypes.RSMTotalFCInfo rsmTotal = new ClsAPLEntityTypes.RSMTotalFCInfo();
        rsmTotal.list_dateKey = new list<String>();
        rsmTotal.list_dateKey.add('2014_4');
        rsmTotal.list_dateKey.add('2014_4');
        rsmTotal.list_dateKey.add('2014_4');
        rsmTotal.currentYear = '2014';
        rsmTotal.currentMonth = 4;
        rsmTotal.set_terrtoryCodes = new set<String>();
        rsmTotal.set_terrtoryCodes.add('test');
        rsmTotal.isTCProd = true;
        
        ClsAPLEntityTypes.RSMTotalFCInfo rsmTotal1 = new ClsAPLEntityTypes.RSMTotalFCInfo();
        rsmTotal1.list_dateKey = new list<String>();
        rsmTotal1.list_dateKey.add('2013_4');
        rsmTotal1.list_dateKey.add('2014_4');
        rsmTotal1.list_dateKey.add('2015_4');
        rsmTotal1.currentYear = '2014';
        rsmTotal1.currentMonth = 4;
        rsmTotal1.set_terrtoryCodes = new set<String>();
        rsmTotal1.set_terrtoryCodes.add('test');
        rsmTotal1.isTCProd = true;
        
        ClsAPLEntityTypes.RSMTotalFCInfo rsmTotal2 = new ClsAPLEntityTypes.RSMTotalFCInfo();
        rsmTotal2.list_dateKey = new list<String>();
        rsmTotal2.list_dateKey.add('2014_4');
        rsmTotal2.list_dateKey.add('2014_4');
        rsmTotal2.list_dateKey.add('2014_4');
        rsmTotal2.currentYear = '2016';
        rsmTotal2.currentMonth = 4;
        rsmTotal2.set_terrtoryCodes = new set<String>();
        rsmTotal2.set_terrtoryCodes.add('test');
        rsmTotal2.isTCProd = true;
        
        map<String, set<Integer>> map_fiscalMonth = new map<String, set<Integer>>();
        map_fiscalMonth.put('2014', new set<Integer>());
        map_fiscalMonth.get('2014').add(4);
        
        ClsAPLEntityTypes.RSMTerritoryFCInfo rsmTerritory = new ClsAPLEntityTypes.RSMTerritoryFCInfo();
        rsmTerritory.territoryCode = 'test';
        rsmTerritory.map_year_quartersFuture = new map<String, set<String>>();  
        rsmTerritory.map_year_quartersFuture.put('2014', new set<String>());
        rsmTerritory.map_year_quartersFuture.get('2014').add('04');
        rsmTerritory.list_dateKey = new list<String>();
        rsmTerritory.list_dateKey.add('2014_4');
        rsmTerritory.list_dateKey.add('2014_4');
        rsmTerritory.list_dateKey.add('2014_4');
        rsmTerritory.currentYear = '2014';
        rsmTerritory.currentMonth = 4;
        
        ClsAPLEntityTypes.RSMTerritoryFCInfo rsmTerritory1 = new ClsAPLEntityTypes.RSMTerritoryFCInfo();
        rsmTerritory1.territoryCode = 'test';
        rsmTerritory1.map_year_quartersFuture = new map<String, set<String>>(); 
        rsmTerritory1.map_year_quartersFuture.put('2014', new set<String>());
        rsmTerritory1.map_year_quartersFuture.get('2014').add('04');
        rsmTerritory1.list_dateKey = new list<String>();
        rsmTerritory1.list_dateKey.add('2014_3');
        rsmTerritory1.list_dateKey.add('2014_4');
        rsmTerritory1.list_dateKey.add('2014_5');
        rsmTerritory1.currentYear = '2014';
        rsmTerritory1.currentMonth = 4;
        
        ClsAPLEntityTypes.RSMTerritoryFCInfo rsmTerritory2 = new ClsAPLEntityTypes.RSMTerritoryFCInfo();
        rsmTerritory2.territoryCode = 'test';
        rsmTerritory2.map_year_quartersFuture = new map<String, set<String>>(); 
        rsmTerritory2.map_year_quartersFuture.put('2014', new set<String>());
        rsmTerritory2.map_year_quartersFuture.get('2014').add('04');
        rsmTerritory2.list_dateKey = new list<String>();
        rsmTerritory2.list_dateKey.add('2014_4');
        rsmTerritory2.list_dateKey.add('2014_4');
        rsmTerritory2.list_dateKey.add('2014_4');
        rsmTerritory2.currentYear = '2016';
        rsmTerritory2.currentMonth = 4;
        
        ClsAPLEntityTypes.RSMAcctFCInfo rsmAcct = new ClsAPLEntityTypes.RSMAcctFCInfo();
        rsmAcct.territoryCode = 'test';
        rsmAcct.acctId = acct.Id;
        rsmAcct.map_year_quartersFuture = new map<String, set<String>>();   
        rsmAcct.map_year_quartersFuture.put('2014', new set<String>());
        rsmAcct.map_year_quartersFuture.get('2014').add('04');
        rsmAcct.list_dateKey = new list<String>();
        rsmAcct.list_dateKey.add('2014_4');
        rsmAcct.list_dateKey.add('2014_4');
        rsmAcct.list_dateKey.add('2014_4');
        rsmAcct.currentYear = '2014';
        rsmAcct.currentMonth = 4;
        
        ClsAPLEntityTypes.RSMAcctFCInfo rsmAcct1 = new ClsAPLEntityTypes.RSMAcctFCInfo();
        rsmAcct1.territoryCode = 'test';
        rsmAcct1.acctId = acct.Id;
        rsmAcct1.map_year_quartersFuture = new map<String, set<String>>();  
        rsmAcct1.map_year_quartersFuture.put('2014', new set<String>());
        rsmAcct1.map_year_quartersFuture.get('2014').add('04');
        rsmAcct1.list_dateKey = new list<String>();
        rsmAcct1.list_dateKey.add('2014_3');
        rsmAcct1.list_dateKey.add('2014_4');
        rsmAcct1.list_dateKey.add('2014_5');
        rsmAcct1.currentYear = '2014';
        rsmAcct1.currentMonth = 4;
        
        ClsAPLEntityTypes.RSMAcctFCInfo rsmAcct2 = new ClsAPLEntityTypes.RSMAcctFCInfo();
        rsmAcct2.territoryCode = 'test';
        rsmAcct2.acctId = amAcct.Id;
        rsmAcct2.map_year_quartersFuture = new map<String, set<String>>();  
        rsmAcct2.map_year_quartersFuture.put('2014', new set<String>());
        rsmAcct2.map_year_quartersFuture.get('2014').add('04');
        rsmAcct2.list_dateKey = new list<String>();
        rsmAcct2.list_dateKey.add('2014_4');
        rsmAcct2.list_dateKey.add('2014_4');
        rsmAcct2.list_dateKey.add('2014_4');
        rsmAcct2.currentYear = '2016';
        rsmAcct2.currentMonth = 4;
        
        ClsAPLEntityTypes.RSMCBCFCInfo rsmCBC = new ClsAPLEntityTypes.RSMCBCFCInfo();
        rsmCBC.acctId = acct.Id;
        rsmCBC.territoryCode = 'test';
        rsmCBC.cbcCode = '30012';
        rsmCBC.map_year_quartersFuture = new map<String, set<String>>();    
        rsmCBC.map_year_quartersFuture.put('2014', new set<String>());
        rsmCBC.map_year_quartersFuture.get('2014').add('04');
        rsmCBC.list_dateKey = new list<String>();
        rsmCBC.list_dateKey.add('2014_4');
        rsmCBC.list_dateKey.add('2014_4');
        rsmCBC.list_dateKey.add('2014_4');
        rsmCBC.currentYear = '2014';
        rsmCBC.currentMonth = 4;
        rsmCBC.map_cbcRowKey_cbcName = new map<String, String>();
        rsmCBC.map_cbcRowKey_cbcName.put('30012', 'Power/Signal');
        
        ClsAPLEntityTypes.RSMCBCFCInfo rsmCBC1 = new ClsAPLEntityTypes.RSMCBCFCInfo();
        rsmCBC1.acctId = acct.Id;
        rsmCBC1.territoryCode = 'test';
        rsmCBC1.cbcCode = '30012';
        rsmCBC1.map_year_quartersFuture = new map<String, set<String>>();   
        rsmCBC1.map_year_quartersFuture.put('2014', new set<String>());
        rsmCBC1.map_year_quartersFuture.get('2014').add('04');
        rsmCBC1.list_dateKey = new list<String>();
        rsmCBC1.list_dateKey.add('2013_4');
        rsmCBC1.list_dateKey.add('2014_4');
        rsmCBC1.list_dateKey.add('2015_4');
        rsmCBC1.currentYear = '2014';
        rsmCBC1.currentMonth = 4;
        rsmCBC1.map_cbcRowKey_cbcName = new map<String, String>();
        rsmCBC1.map_cbcRowKey_cbcName.put('30012', 'Power/Signal');
        
        ClsAPLEntityTypes.RSMCBCFCInfo rsmCBC2 = new ClsAPLEntityTypes.RSMCBCFCInfo();
        rsmCBC2.acctId = acct.Id;
        rsmCBC2.territoryCode = 'test';
        rsmCBC2.cbcCode = '30012';
        rsmCBC2.map_year_quartersFuture = new map<String, set<String>>();   
        rsmCBC2.map_year_quartersFuture.put('2014', new set<String>());
        rsmCBC2.map_year_quartersFuture.get('2014').add('04');
        rsmCBC2.list_dateKey = new list<String>();
        rsmCBC2.list_dateKey.add('2014_4');
        rsmCBC2.list_dateKey.add('2014_4');
        rsmCBC2.list_dateKey.add('2014_4');
        rsmCBC2.currentYear = '2016';
        rsmCBC2.currentMonth = 4;
        rsmCBC2.map_cbcRowKey_cbcName = new map<String, String>();
        rsmCBC2.map_cbcRowKey_cbcName.put('30012', 'Power/Signal');
        
        ClsAPLEntityTypes.RSMGPLFCInfo rsmGPL = new ClsAPLEntityTypes.RSMGPLFCInfo();
        rsmGPL.acctId = acct.Id;
        rsmGPL.territoryCode = 'test';
        rsmGPL.cbc2Code = '30012';
        rsmGPL.gplId = ph.Id;
        rsmGPL.map_year_quartersFuture = new map<String, set<String>>();    
        rsmGPL.map_year_quartersFuture.put(curYear, new set<String>());
        rsmGPL.map_year_quartersFuture.get(curYear).add(curQuart);
        rsmGPL.list_dateKey = new list<String>();
        rsmGPL.list_dateKey.add('2014_4');
        rsmGPL.list_dateKey.add('2014_4');
        rsmGPL.list_dateKey.add('2014_4');
        rsmGPL.list_dateKey.add(key);
        rsmGPL.currentYear = curYear;
        rsmGPL.currentMonth = curMonth;
        
        ClsAPLEntityTypes.RSMGPLFCInfo rsmGPL1 = new ClsAPLEntityTypes.RSMGPLFCInfo();
        rsmGPL1.acctId = acct.Id;
        rsmGPL1.territoryCode = 'test';
        rsmGPL1.cbc2Code = '30012';
        rsmGPL1.gplId = ph.Id;
        rsmGPL1.map_year_quartersFuture = new map<String, set<String>>();   
        rsmGPL1.map_year_quartersFuture.put('2014', new set<String>());
        rsmGPL1.map_year_quartersFuture.get('2014').add('04');
        rsmGPL1.list_dateKey = new list<String>();
        rsmGPL1.list_dateKey.add('2014_3');
        rsmGPL1.list_dateKey.add('2014_4');
        rsmGPL1.list_dateKey.add('2014_5');
        rsmGPL1.currentYear = '2014';
        rsmGPL1.currentMonth = 4;
        
        ClsAPLEntityTypes.RSMGPLFCInfo rsmGPL2 = new ClsAPLEntityTypes.RSMGPLFCInfo();
        rsmGPL2.acctId = acct.Id;
        rsmGPL2.territoryCode = 'test';
        rsmGPL2.cbc2Code = '30012';
        rsmGPL2.gplId = ph.Id;
        rsmGPL2.map_year_quartersFuture = new map<String, set<String>>();   
        rsmGPL2.map_year_quartersFuture.put('2014', new set<String>());
        rsmGPL2.map_year_quartersFuture.get('2014').add('04');
        rsmGPL2.list_dateKey = new list<String>();
        rsmGPL2.list_dateKey.add('2014_4');
        rsmGPL2.list_dateKey.add('2014_4');
        rsmGPL2.list_dateKey.add('2014_4');
        rsmGPL2.currentYear = '2016';
        rsmGPL2.currentMonth = 4;
        
        ClsAPLEntityTypes.RSMGPLFCInfo rsmGPL3 = new ClsAPLEntityTypes.RSMGPLFCInfo();
        rsmGPL3.acctId = acct.Id;
        rsmGPL3.territoryCode = 'test';
        rsmGPL3.cbc2Code = '30012';
        rsmGPL3.gplId = ph.Id;
        rsmGPL3.map_year_quartersFuture = new map<String, set<String>>();   
        rsmGPL3.map_year_quartersFuture.put(curYear, new set<String>());
        rsmGPL3.map_year_quartersFuture.get(curYear).add(curQuart);
        rsmGPL3.list_dateKey = new list<String>();
        rsmGPL3.list_dateKey.add('2017_4');
        rsmGPL3.list_dateKey.add('2017_4');
        rsmGPL3.list_dateKey.add('2017_5');
        rsmGPL3.currentYear = curYear;
        rsmGPL3.currentMonth = curMonth;
        
        ClsAPLEntityTypes.RSMGPLFCInfo rsmGPLRelay = new ClsAPLEntityTypes.RSMGPLFCInfo();
        rsmGPLRelay.acctId = acct.Id;
        rsmGPLRelay.territoryCode = 'test';
        rsmGPLRelay.map_year_quartersFuture = new map<String, set<String>>();   
        rsmGPLRelay.map_year_quartersFuture.put(curYear , new set<String>());
        rsmGPLRelay.map_year_quartersFuture.get(curYear ).add(curQuart ); 
        
        
        ClsAPLEntityTypes.RSMPartFCInfo rsmPart = new ClsAPLEntityTypes.RSMPartFCInfo();
        rsmPart.acctId = acct.Id;
        rsmPart.territoryCode = 'test';
        rsmPart.cbc2Code = '30012';
        rsmPart.gplId = ph.Id;
        rsmPart.partId = part.Id;
        rsmPart.map_year_quartersFuture = new map<String, set<String>>();   
        rsmPart.map_year_quartersFuture.put(curYear , new set<String>());
        rsmPart.map_year_quartersFuture.get(curYear).add(curQuart );      
        rsmPart.map_year_monthsHistory = new map<String, set<Integer>>();   
        rsmPart.map_year_monthsHistory.put(curYear, new set<Integer>());
        rsmPart.map_year_monthsHistory.get(curYear).add(curMonth);
        rsmPart.map_year_monthsFuture = new map<String, set<Integer>>();
        rsmPart.map_year_monthsFuture.put(curYear, new set<Integer>());
        rsmPart.map_year_monthsFuture.get(curYear).add(curMonth);
        rsmPart.refStartDate = string.valueof(Date.Today()-1);
        rsmPart.periodStartDate = string.valueof(Date.Today());
        rsmPart.refEndDate = string.valueof(Date.Today());
        rsmPart.currentYear = curYear ;
        rsmPart.currentMonth = curMonth ;  
        rsmPart.map_dateKey_fc = new map<String, decimal>();
        rsmPart.map_dateKey_fc.put('2014_04', 20);
        rsmPart.map_dateKey_fc.put('2015_01', 20);
        rsmPart.map_dateKey_fc.put('2013_01', 20);
        rsmPart.map_dateKey_fc.put(key, 20);//Added by Mrunal
        
        
        ClsAPLEntityTypes.RSMGPLFCInfo gplFC = new ClsAPLEntityTypes.RSMGPLFCInfo();
        gplFC.cbc2Code = '30012';
        gplFC.acctId = acct.Id;
        gplFC.gplId = ph.Id;
        gplFC.quarterNumb = curQuart;
        gplFC.map_year_quartersFuture = new map<String, set<String>>(); 
        gplFC.map_year_quartersFuture.put(curYear , new set<String>());
        gplFC.map_year_quartersFuture.get(curYear ).add(curQuart ); 
        gplFC.list_parts = new list<ClsAPLEntityTypes.RSMPartFCInfo>();
        gplFC.list_parts.add(rsmPart);
        
        ClsAPLEntityTypes.RSMAMOverRallInfo overRallInfo = new ClsAPLEntityTypes.RSMAMOverRallInfo();
        overRallInfo.managerId = userInfo.getUserId();
        overRallInfo.displayName = 'test;true';//Added by Mrunal
        overRallInfo.map_year_quartersFuture = new map<String, set<String>>();  
        overRallInfo.map_year_quartersFuture.put(curYear, new set<String>());//Added by Mrunal
        overRallInfo.map_year_quartersFuture.get(curYear).add(curQuart);//Added by Mrunal
        overRallInfo.map_dateKey_fc = new map<String, decimal>();
        overRallInfo.map_dateKey_fc.put('2013_01', 20);
        overRallInfo.map_dateKey_fc.put('2014_04', 20);
        overRallInfo.map_dateKey_fc.put('2015_01', 20);
        overRallInfo.map_dateKey_fc.put(key, 20);//Added by Mrunal
        overRallInfo.map_dateKey_fc.put('2017_01', 20);
        
        ClsAPLEntityTypes.RSMTerritoryFCInfo rsmTerritory3 = new ClsAPLEntityTypes.RSMTerritoryFCInfo();
        rsmTerritory3.managerId = userInfo.getUserId();
        rsmTerritory3.territoryCode = 'test';
        
        Test.startTest();
        ClsAPLServiceRSM.getRSMCBCFC(rsmCBC);
        ClsAPLServiceRSM.getRSMCBCRefData(rsmCBC);
        ClsAPLServiceRSM.getRSMCBCRefData(rsmCBC1);
        ClsAPLServiceRSM.getRSMCBCRefData(rsmCBC2);
        ClsAPLServiceRSM.getCBCHistoryRefData(acct.Id, 'test','2014-04-01', '2014-04-21','30012', rsmCBC.list_dateKey, new ClsAPLEntityTypes.CBCFCValueObj());
        ClsAPLServiceRSM.getCBCHisBacklogRefData(acct.Id, 'test', '30012', '2014-04-01', '2014-04-21', map_fiscalMonth, rsmCBC.list_dateKey, new ClsAPLEntityTypes.CBCFCValueObj());
        ClsAPLServiceRSM.getCBCCurrentRefData(acct.Id, 'test', '30012', '2014', 4, new ClsAPLEntityTypes.CBCFCValueObj());
        ClsAPLServiceRSM.getRSMGPLFC(rsmGPL);
        ClsAPLServiceRSM.getRSMRelayCBCFC(rsmGPLRelay);  
        ClsAPLServiceRSM.getRSMGPLRefData(rsmGPL);
        ClsAPLServiceRSM.getRSMGPLRefData(rsmGPL1);
        ClsAPLServiceRSM.getRSMGPLRefData(rsmGPL2);
        ClsAPLServiceRSM.getRSMGPLRefData(rsmGPL3);
        ClsAPLServiceRSM.getGPLCurrentRefData(acct.Id, 'test', ph.Id, '30012', '2014', 4, new ClsAPLEntityTypes.GPLFCValueObj());
        ClsAPLServiceRSM.getRSMPartFC(rsmPart);
        ClsAPLServiceRSM.saveRSMGPLFC(gplFC);
        ClsAPLServiceRSM.getRSMTotalReferRow();
        ClsAPLServiceRSM.saveOverRallFC(overRallInfo);
        overRallInfo.displayName = 'test;false';//Mrunal
        ClsAPLServiceRSM.saveOverRallFC(overRallInfo);
        ClsAPLServiceRSM.unfreezeAM(rsmTerritory3);
        Test.stopTest();
    }
    static testMethod void myUnitTest() {
        
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();
        
        //RecordType rt = ClsTestHelp.createTestRecordType8();
        RecordType rt2 = ClsTestHelp.createTestRecordType8();
        
        Consumer_Device_Opportunity_Record_Types__c cdort1 = ClsTestHelp.createTestCSD1();
        Consumer_Device_Opportunity_Record_Types__c cdort2 = ClsTestHelp.createTestCSD2();
        Consumer_Device_Opportunity_Record_Types__c cdort3 = ClsTestHelp.createTestCSD3();
        Consumer_Device_Opportunity_Record_Types__c cdort4 = ClsTestHelp.createTestCSD4();
        Consumer_Device_Opportunity_Record_Types__c cdort5 = ClsTestHelp.createTestCSD5();
        Consumer_Device_Opportunity_Record_Types__c cdort6 = ClsTestHelp.createTestCSD6();
        Consumer_Device_Opportunity_Record_Types__c cdort7 = ClsTestHelp.createTestCSD7();
        
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy1();
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
        acct.APL_AM_Display_Name__c = 'amName';
        acct.Account_Manager__c = userInfo.getUserId();
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
        relayAcct.Relay_Specialist_Territory_Code__c = 'test';   
        relayAcct.GAMCD__c = '1234'; 
        relayAcct.Sales_Hierarchy__c = sh.Id;   
        relayAcct.SALES_TERRITORY_CDE__c = 'test';
        insert relayAcct;
        
        /*Account relayAcct1 = ClsTestHelp.createTestAccounts();
        relayAcct1.Name = 'relayAcctaxx';
        relayAcct1.RecordTypeId = rt2.Id;
        relayAcct1.Account_Manager__c = userInfo.getUserId();
        relayAcct1.APL_Relay_forecast_Plan_Account__c = null;
        relayAcct1.APL_Relay_Currency__c = 'USD';
        relayAcct1.APL_Relay_Display_Name__c = 'testName';
        relayAcct1.APL_Relay_ParentAccount__c = acct.Id;
        relayAcct1.Relay_Specialist_Territory_Code__c = 'test';   
        relayAcct1.GAMCD__c = '1234';   
        relayAcct1.SALES_TERRITORY_CDE__c = 'test';
        insert relayAcct1;*/
        
        Account amAcct = ClsTestHelp.createTestAccounts();
        amAcct.Name = 'axx';
        amAcct.RecordTypeId = rt2.Id;
        amAcct.APL_AM_forecast_Plan_Account__c = acct.Id;
        amAcct.APL_AM_Currency__c = 'USD';
        amAcct.APL_AM_Display_Name__c = 'amName';
        amAcct.APL_AM_ParentAccount__c = acct.Id;       
        amAcct.Account_Manager__c = userInfo.getUserId();
        amAcct.SALES_TERRITORY_CDE__c = 'test';
        amAcct.GAMCD__c = '1234';
        amAcct.Sales_Hierarchy__c = sh.Id;  
        insert amAcct;
        
        Account amAcct1 = ClsTestHelp.createTestAccounts();
        amAcct1.Name = 'axx';
        amAcct1.RecordTypeId = rt2.Id;
        amAcct1.APL_AM_forecast_Plan_Account__c = null;
        amAcct1.APL_AM_Currency__c = 'USD';
        amAcct1.APL_AM_Display_Name__c = 'amName';
        amAcct1.APL_AM_ParentAccount__c = acct.Id;      
        amAcct1.Account_Manager__c = userInfo.getUserId();
        amAcct1.SALES_TERRITORY_CDE__c = 'test';
        amAcct.GAMCD__c = '1234';
        amAcct.Sales_Hierarchy__c = sh.Id;  
        insert amAcct1;
        
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
        
        Part__c part = new Part__c();
        part.Name = 'testPart';
        part.GPL__c = ph.Id;
        part.Product_Hierarchy__c = ph.Id; 
        part.Description__c = 'test';
        insert part;
        
        APL_Sales_Forecast__c aplFC1 = new APL_Sales_Forecast__c();
        aplFC1.type__c = 'GPL';
        aplFC1.Fiscal_Year__c = '2014';
        aplFC1.Fiscal_Quarter__c = '04';
        aplFC1.customer__c = amAcct.Id;
        aplFC1.RSM_Forecast__c = 10;
        aplFC1.GPL__c = ph.Id;
        aplFC1.Part__c = part.Id;
        insert aplFC1;
        
        APL_Sales_Forecast__c aplFC2 = new APL_Sales_Forecast__c();
        aplFC2.type__c = 'Relay';
        aplFC2.Fiscal_Year__c = '2014';
        aplFC2.Fiscal_Quarter__c = '04';
        aplFC2.customer__c = relayAcct.Id;
        aplFC2.Part__c = part.Id;
        aplFC2.GPL__c = ph1.Id;
        aplFC2.RSM_Forecast__c = 10;
        insert aplFC2;
        
        APL_RSM__c aplRsm = new APL_RSM__c();
        aplRsm.Manager__c = userInfo.getUserId();
        aplRsm.Display_Name__c = 'test';
        insert aplRsm;
        
        APL_RSM__c aplRsm1 = new APL_RSM__c();
        aplRsm1.Manager__c = userInfo.getUserId();
        aplRsm1.Type__c = 'Relay';
        aplRsm1.Display_Name__c = 'test2';
        insert aplRsm1;
        
        APL_RSM__c aplRsm2 = new APL_RSM__c();
        aplRsm2.Manager__c = userInfo.getUserId();
        aplRsm2.Type__c = 'AM';
        aplRsm2.Display_Name__c = 'test1';
        aplRsm2.APL_RSM__c = aplRsm1.Id;
        insert aplRsm2;
        
        RecordType rt5 = ClsTestHelp.createTestRecordType26();// mrunal
        RecordType rt25 = ClsTestHelp.createTestRecordType25(); 
        APL_Forecast_Management__c apl = new APL_Forecast_Management__c();
        apl.Name = 'testName';
        apl.A6_Code__c = '123456';
        apl.Manager__c = userInfo.getUserId();  
        apl.RSM__c = aplRsm2.Id;
        apl.GAM_Code__c = '1234';
        apl.RecordTypeId = rt25.Id;
        apl.RSM_Freeze__c = false;
        apl.AM_Freeze__c = true;
        insert apl;
        
        APL_Forecast_Management__c apl1 = new APL_Forecast_Management__c();
        apl1.Name = 'testName1';
        apl1.A6_Code__c = '1234567';
        apl1.GAM_Code__c = '1234';
        apl1.Manager__c = userInfo.getUserId();
        apl1.RecordTypeId = rt25.Id;
        apl1.RSM__c = aplRsm1.Id;
        insert apl1;
        
        BBB_Month_Bill_Book_Cust_PN__c bbbMon = new BBB_Month_Bill_Book_Cust_PN__c();
        bbbMon.Customer__c = amAcct.Id;
        bbbMon.Bill_Amount_USD__c = 10;
        bbbMon.Book_Amount_USD__c = 10; 
        bbbMon.Fiscal_Year__c = '2014';
        bbbMon.Fiscal_Month__c = 4;
        bbbMon.Profit_Center__c = 'APL';
        bbbMon.Part__c = part.Id;
        insert bbbMon;
        
        BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c bbbDay = new BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c();
        bbbDay.Backlog_Amount_USD__c = 10;
        bbbDay.Bill_Amount_USD__c = 10; 
        bbbDay.Book_Amount_USD__c = 10;
        bbbDay.Customer__c = amAcct.Id;
        bbbDay.Fiscal_Year__c = '2016';//mrunal
        bbbDay.Fiscal_Month__c = 9;
        bbbDay.Customer_Request_Date_Fiscal_Year__c = '2016';
        bbbday.Customer_Request_Date_Fiscal_Month__c = 9;
        bbbDay.Profit_Center__c = 'APL';
        bbbDay.Part__c = part.Id;
        insert bbbDay;
        
        APL_RSM_Overall_Forecast__c aplOver = new APL_RSM_Overall_Forecast__c();
        aplOver.Fiscal_Quarter__c = '04';
        aplOver.Fiscal_Year__c = '2014';
        aplOver.APL_RSM__c = aplRsm.Id;
        aplOver.RSM_Overall_Forecast__c = 10;       
        insert aplOver;
        
        ClsAPLEntityTypes.PageConfig pageConf = new ClsAPLEntityTypes.PageConfig();
        pageConf.set_rsmAMTerritoryCodes.add('test');
        pageConf.map_year_quartersFuture.put('2014', new set<String>());
        pageConf.map_year_quartersFuture.get('2014').add('04');
        
        ClsAPLEntityTypes.RSMAMOverRallInfo rsmOverRall = new ClsAPLEntityTypes.RSMAMOverRallInfo();
        rsmOverRall.managerId = userInfo.getUserId();
        rsmOverRall.displayName = 'test';
        rsmOverRall.map_year_quartersFuture = new map<String, set<String>>();    
        rsmOverRall.map_year_quartersFuture.put('2014', new set<String>());
        rsmOverRall.map_year_quartersFuture.get('2014').add('04');
        
        ClsAPLEntityTypes.RSMTotalFCInfo rsmTotal = new ClsAPLEntityTypes.RSMTotalFCInfo();
        rsmTotal.list_dateKey = new list<String>();
        rsmTotal.list_dateKey.add('2014_4');
        rsmTotal.list_dateKey.add('2014_4');
        rsmTotal.list_dateKey.add('2014_4');
        rsmTotal.currentYear = '2014';
        rsmTotal.currentMonth = 4;
        rsmTotal.set_terrtoryCodes = new set<String>();
        rsmTotal.set_terrtoryCodes.add('test');
        rsmTotal.isTCProd = true;
        
        ClsAPLEntityTypes.RSMTotalFCInfo rsmTotal1 = new ClsAPLEntityTypes.RSMTotalFCInfo();
        rsmTotal1.list_dateKey = new list<String>();
        rsmTotal1.list_dateKey.add('2013_4');
        rsmTotal1.list_dateKey.add('2014_4');
        rsmTotal1.list_dateKey.add('2015_4');
        rsmTotal1.currentYear = '2014';
        rsmTotal1.currentMonth = 4;
        rsmTotal1.set_terrtoryCodes = new set<String>();
        rsmTotal1.set_terrtoryCodes.add('test');
        rsmTotal1.isTCProd = true;
        
        ClsAPLEntityTypes.RSMTotalFCInfo rsmTotal2 = new ClsAPLEntityTypes.RSMTotalFCInfo();
        rsmTotal2.list_dateKey = new list<String>();
        rsmTotal2.list_dateKey.add('2014_4');
        rsmTotal2.list_dateKey.add('2014_4');
        rsmTotal2.list_dateKey.add('2014_4');
        rsmTotal2.currentYear = '2016';
        rsmTotal2.currentMonth = 4;
        rsmTotal2.set_terrtoryCodes = new set<String>();
        rsmTotal2.set_terrtoryCodes.add('test');
        rsmTotal2.isTCProd = true;
        
        map<String, set<Integer>> map_fiscalMonth = new map<String, set<Integer>>();
        map_fiscalMonth.put('2014', new set<Integer>());
        map_fiscalMonth.get('2014').add(4);
        
        string curYear = string.valueof(Date.Today().Year());//Added by Mrunal
        string curQuart = string.valueof(date.today().month()/3);//Added by Mrunal
        Integer curMonth = Integer.valueof(date.today().month());//Added by Mrunal
        string key= curYear+'_'+curQuart;//Added by Mrunal
        
        ClsAPLEntityTypes.RSMTerritoryFCInfo rsmTerritory = new ClsAPLEntityTypes.RSMTerritoryFCInfo();
        rsmTerritory.territoryCode = 'test';
        rsmTerritory.map_year_quartersFuture = new map<String, set<String>>();  
        rsmTerritory.map_year_quartersFuture.put(curYear, new set<String>());
        rsmTerritory.map_year_quartersFuture.get(curYear).add(curQuart );
        rsmTerritory.list_dateKey = new list<String>();
        rsmTerritory.list_dateKey.add('2014_4');
        rsmTerritory.list_dateKey.add('2014_4');
        rsmTerritory.list_dateKey.add('2014_4');
        rsmTerritory.list_dateKey.add(key);
        
        
        rsmTerritory.currentYear = curYear ;
        rsmTerritory.currentMonth = curMonth ;
        
        ClsAPLEntityTypes.RSMTerritoryFCInfo rsmTerritory1 = new ClsAPLEntityTypes.RSMTerritoryFCInfo();
        rsmTerritory1.territoryCode = 'test';
        rsmTerritory1.map_year_quartersFuture = new map<String, set<String>>(); 
        rsmTerritory1.map_year_quartersFuture.put('2014', new set<String>());
        rsmTerritory1.map_year_quartersFuture.get('2014').add('04');
        rsmTerritory1.list_dateKey = new list<String>();
        rsmTerritory1.list_dateKey.add('2014_3');
        rsmTerritory1.list_dateKey.add('2014_4');
        rsmTerritory1.list_dateKey.add('2014_5');
        rsmTerritory1.currentYear = '2014';
        rsmTerritory1.currentMonth = 4;
        
        ClsAPLEntityTypes.RSMTerritoryFCInfo rsmTerritory2 = new ClsAPLEntityTypes.RSMTerritoryFCInfo();
        rsmTerritory2.territoryCode = 'test';
        rsmTerritory2.map_year_quartersFuture = new map<String, set<String>>(); 
        rsmTerritory2.map_year_quartersFuture.put('2014', new set<String>());
        rsmTerritory2.map_year_quartersFuture.get('2014').add('04');
        rsmTerritory2.list_dateKey = new list<String>();
        rsmTerritory2.list_dateKey.add('2014_4');
        rsmTerritory2.list_dateKey.add('2014_4');
        rsmTerritory2.list_dateKey.add('2014_4');
        rsmTerritory2.currentYear = '2016';
        rsmTerritory2.currentMonth = 4;
        
        ClsAPLEntityTypes.RSMAcctFCInfo rsmAcct = new ClsAPLEntityTypes.RSMAcctFCInfo();
        rsmAcct.territoryCode = 'test';
        rsmAcct.acctId = acct.Id;
        rsmAcct.map_year_quartersFuture = new map<String, set<String>>();   
        rsmAcct.map_year_quartersFuture.put('2014', new set<String>());
        rsmAcct.map_year_quartersFuture.get('2014').add('04');
        rsmAcct.list_dateKey = new list<String>();
        rsmAcct.list_dateKey.add('2014_4');
        rsmAcct.list_dateKey.add('2014_4');
        rsmAcct.list_dateKey.add('2014_4');
        rsmAcct.currentYear = '2014';
        rsmAcct.currentMonth = 4;
        
        ClsAPLEntityTypes.RSMAcctFCInfo rsmAcct1 = new ClsAPLEntityTypes.RSMAcctFCInfo();
        rsmAcct1.territoryCode = 'test';
        rsmAcct1.acctId = acct.Id;
        rsmAcct1.map_year_quartersFuture = new map<String, set<String>>();  
        rsmAcct1.map_year_quartersFuture.put('2014', new set<String>());
        rsmAcct1.map_year_quartersFuture.get('2014').add('04');
        rsmAcct1.list_dateKey = new list<String>();
        rsmAcct1.list_dateKey.add('2014_3');
        rsmAcct1.list_dateKey.add('2014_4');
        rsmAcct1.list_dateKey.add('2014_5');
        rsmAcct1.currentYear = '2014';
        rsmAcct1.currentMonth = 4;
        
        ClsAPLEntityTypes.RSMAcctFCInfo rsmAcct2 = new ClsAPLEntityTypes.RSMAcctFCInfo();
        rsmAcct2.territoryCode = 'test';
        rsmAcct2.acctId = amAcct.Id;
        rsmAcct2.map_year_quartersFuture = new map<String, set<String>>();  
        rsmAcct2.map_year_quartersFuture.put('2014', new set<String>());
        rsmAcct2.map_year_quartersFuture.get('2014').add('04');
        rsmAcct2.list_dateKey = new list<String>();
        rsmAcct2.list_dateKey.add('2014_4');
        rsmAcct2.list_dateKey.add('2014_4');
        rsmAcct2.list_dateKey.add('2014_4');
        rsmAcct2.currentYear = '2016';
        rsmAcct2.currentMonth = 4;
        
        ClsAPLEntityTypes.RSMCBCFCInfo rsmCBC = new ClsAPLEntityTypes.RSMCBCFCInfo();
        rsmCBC.acctId = acct.Id;
        rsmCBC.territoryCode = 'test';
        rsmCBC.cbcCode = '30012';
        rsmCBC.map_year_quartersFuture = new map<String, set<String>>();    
        rsmCBC.map_year_quartersFuture.put('2014', new set<String>());
        rsmCBC.map_year_quartersFuture.get('2014').add('04');
        rsmCBC.list_dateKey = new list<String>();
        rsmCBC.list_dateKey.add('2014_4');
        rsmCBC.list_dateKey.add('2014_4');
        rsmCBC.list_dateKey.add('2014_4');
        rsmCBC.currentYear = '2014';
        rsmCBC.currentMonth = 4;
        rsmCBC.map_cbcRowKey_cbcName = new map<String, String>();
        rsmCBC.map_cbcRowKey_cbcName.put('30012', 'Power/Signal');
        
        ClsAPLEntityTypes.RSMCBCFCInfo rsmCBC1 = new ClsAPLEntityTypes.RSMCBCFCInfo();
        rsmCBC1.acctId = acct.Id;
        rsmCBC1.territoryCode = 'test';
        rsmCBC1.cbcCode = '30012';
        rsmCBC1.map_year_quartersFuture = new map<String, set<String>>();   
        rsmCBC1.map_year_quartersFuture.put('2014', new set<String>());
        rsmCBC1.map_year_quartersFuture.get('2014').add('04');
        rsmCBC1.list_dateKey = new list<String>();
        rsmCBC1.list_dateKey.add('2013_4');
        rsmCBC1.list_dateKey.add('2014_4');
        rsmCBC1.list_dateKey.add('2015_4');
        rsmCBC1.currentYear = '2014';
        rsmCBC1.currentMonth = 4;
        rsmCBC1.map_cbcRowKey_cbcName = new map<String, String>();
        rsmCBC1.map_cbcRowKey_cbcName.put('30012', 'Power/Signal');
        
        ClsAPLEntityTypes.RSMCBCFCInfo rsmCBC2 = new ClsAPLEntityTypes.RSMCBCFCInfo();
        rsmCBC2.acctId = acct.Id;
        rsmCBC2.territoryCode = 'test';
        rsmCBC2.cbcCode = '30012';
        rsmCBC2.map_year_quartersFuture = new map<String, set<String>>();   
        rsmCBC2.map_year_quartersFuture.put('2014', new set<String>());
        rsmCBC2.map_year_quartersFuture.get('2014').add('04');
        rsmCBC2.list_dateKey = new list<String>();
        rsmCBC2.list_dateKey.add('2014_4');
        rsmCBC2.list_dateKey.add('2014_4');
        rsmCBC2.list_dateKey.add('2014_4');
        rsmCBC2.currentYear = '2016';
        rsmCBC2.currentMonth = 4;
        rsmCBC2.map_cbcRowKey_cbcName = new map<String, String>();
        rsmCBC2.map_cbcRowKey_cbcName.put('30012', 'Power/Signal');
        
        ClsAPLEntityTypes.RSMGPLFCInfo rsmGPL = new ClsAPLEntityTypes.RSMGPLFCInfo();
        rsmGPL.acctId = acct.Id;
        rsmGPL.territoryCode = 'test';
        rsmGPL.cbc2Code = '30012';
        rsmGPL.gplId = ph.Id;
        rsmGPL.map_year_quartersFuture = new map<String, set<String>>();    
        rsmGPL.map_year_quartersFuture.put('2014', new set<String>());
        rsmGPL.map_year_quartersFuture.get('2014').add('04');
        rsmGPL.list_dateKey = new list<String>();
        rsmGPL.list_dateKey.add('2014_4');
        rsmGPL.list_dateKey.add('2014_4');
        rsmGPL.list_dateKey.add('2014_4');
        rsmGPL.currentYear = '2014';
        rsmGPL.currentMonth = 4;
        
        ClsAPLEntityTypes.RSMGPLFCInfo rsmGPL1 = new ClsAPLEntityTypes.RSMGPLFCInfo();
        rsmGPL1.acctId = acct.Id;
        rsmGPL1.territoryCode = 'test';
        rsmGPL1.cbc2Code = '30012';
        rsmGPL1.gplId = ph.Id;
        rsmGPL1.map_year_quartersFuture = new map<String, set<String>>();   
        rsmGPL1.map_year_quartersFuture.put('2014', new set<String>());
        rsmGPL1.map_year_quartersFuture.get('2014').add('04');
        rsmGPL1.list_dateKey = new list<String>();
        rsmGPL1.list_dateKey.add('2014_3');
        rsmGPL1.list_dateKey.add('2014_4');
        rsmGPL1.list_dateKey.add('2014_5');
        rsmGPL1.currentYear = '2014';
        rsmGPL1.currentMonth = 4;
        
        ClsAPLEntityTypes.RSMGPLFCInfo rsmGPL2 = new ClsAPLEntityTypes.RSMGPLFCInfo();
        rsmGPL2.acctId = acct.Id;
        rsmGPL2.territoryCode = 'test';
        rsmGPL2.cbc2Code = '30012';
        rsmGPL2.gplId = ph.Id;
        rsmGPL2.map_year_quartersFuture = new map<String, set<String>>();   
        rsmGPL2.map_year_quartersFuture.put('2014', new set<String>());
        rsmGPL2.map_year_quartersFuture.get('2014').add('04');
        rsmGPL2.list_dateKey = new list<String>();
        rsmGPL2.list_dateKey.add('2014_4');
        rsmGPL2.list_dateKey.add('2014_4');
        rsmGPL2.list_dateKey.add('2014_4');
        rsmGPL2.currentYear = '2016';
        rsmGPL2.currentMonth = 4;
        
        ClsAPLEntityTypes.RSMGPLFCInfo rsmGPLRelay = new ClsAPLEntityTypes.RSMGPLFCInfo();
        rsmGPLRelay.acctId = acct.Id;
        rsmGPL.territoryCode = 'test';
        rsmGPLRelay.map_year_quartersFuture = new map<String, set<String>>();   
        rsmGPLRelay.map_year_quartersFuture.put('2014', new set<String>());
        rsmGPLRelay.map_year_quartersFuture.get('2014').add('04'); 
        
        ClsAPLEntityTypes.RSMPartFCInfo rsmPart = new ClsAPLEntityTypes.RSMPartFCInfo();
        rsmPart.acctId = acct.Id;
        rsmPart.territoryCode = 'test';
        rsmPart.cbc2Code = '30012';
        rsmPart.gplId = ph.Id;
        rsmPart.partId = part.Id;
        rsmPart.map_year_quartersFuture = new map<String, set<String>>();   
        rsmPart.map_year_quartersFuture.put('2014', new set<String>());
        rsmPart.map_year_quartersFuture.get('2014').add('04');      
        rsmPart.map_year_monthsHistory = new map<String, set<Integer>>();   
        rsmPart.map_year_monthsHistory.put('2014', new set<Integer>());
        rsmPart.map_year_monthsHistory.get('2014').add(4);
        rsmPart.map_year_monthsFuture = new map<String, set<Integer>>();
        rsmPart.map_year_monthsFuture.put('2014', new set<Integer>());
        rsmPart.map_year_monthsFuture.get('2014').add(4);
        rsmPart.refStartDate = '2014-04-01';
        rsmPart.periodStartDate = '2014-04-21';
        rsmPart.refEndDate = '2014-04-01';
        rsmPart.currentYear = '2014';
        rsmPart.currentMonth = 4;  
        rsmPart.map_dateKey_fc = new map<String, decimal>();
        rsmPart.map_dateKey_fc.put('2014_04', 20);
        rsmPart.map_dateKey_fc.put('2015_01', 20);
        rsmPart.map_dateKey_fc.put('2013_01', 20);
        
        ClsAPLEntityTypes.RSMGPLFCInfo gplFC = new ClsAPLEntityTypes.RSMGPLFCInfo();
        gplFC.cbc2Code = '30012';
        gplFC.acctId = acct.Id;
        gplFC.gplId = ph.Id;
        gplFC.quarterNumb = '02';
        gplFC.map_year_quartersFuture = new map<String, set<String>>(); 
        gplFC.map_year_quartersFuture.put('2014', new set<String>());
        gplFC.map_year_quartersFuture.get('2014').add('04'); 
        gplFC.list_parts = new list<ClsAPLEntityTypes.RSMPartFCInfo>();
        gplFC.list_parts.add(rsmPart);
        
        ClsAPLEntityTypes.RSMAMOverRallInfo overRallInfo = new ClsAPLEntityTypes.RSMAMOverRallInfo();
        overRallInfo.managerId = userInfo.getUserId();
        overRallInfo.displayName = 'test';
        overRallInfo.map_year_quartersFuture = new map<String, set<String>>();  
        overRallInfo.map_year_quartersFuture.put('2014', new set<String>());
        overRallInfo.map_year_quartersFuture.get('2014').add('04');
        overRallInfo.map_dateKey_fc = new map<String, decimal>();
        overRallInfo.map_dateKey_fc.put('2013_01', 20);
        overRallInfo.map_dateKey_fc.put('2014_04', 20);
        overRallInfo.map_dateKey_fc.put('2015_01', 20);
        
        ClsAPLEntityTypes.RSMTerritoryFCInfo rsmTerritory3 = new ClsAPLEntityTypes.RSMTerritoryFCInfo();
        rsmTerritory3.managerId = userInfo.getUserId();
        rsmTerritory3.territoryCode = '123456';
        
        
        Test.startTest();
        //ClsAPLServiceRSM.getAcctInfo(new ClsAPLEntityTypes.PageConfig());
        ClsAPLServiceRSM.getAcctTotalFC(pageConf, new list<ClsAPLEntityTypes.TotalFCViewFields>());
        ClsAPLServiceRSM.getRSMAMOverRallFC(rsmOverRall);
        ClsAPLServiceRSM.getRSMTotalRefData(rsmTotal);
        ClsAPLServiceRSM.getRSMTotalRefData(rsmTotal1);
        ClsAPLServiceRSM.getRSMTotalRefData(rsmTotal2);
        ClsAPLServiceRSM.getTotalHistoryRefData(rsmTotal.set_terrtoryCodes, true, '2016-09-09', '2014-04-07', rsmTotal.list_dateKey, new ClsAPLEntityTypes.AcctFCValueObj());
        ClsAPLServiceRSM.getTotalHisBacklogRefData(rsmTotal.set_terrtoryCodes, true, '2014-04-01', '2014-04-01', map_fiscalMonth, rsmTotal.list_dateKey, new ClsAPLEntityTypes.AcctFCValueObj());
        ClsAPLServiceRSM.getTotalCurrentRefData(rsmTotal.set_terrtoryCodes, true, '2014', 4, new ClsAPLEntityTypes.AcctFCValueObj());
        ClsAPLServiceRSM.getRSMTerritoryFC(rsmTerritory);
        ClsAPLServiceRSM.getRSMTerritoryRefData(rsmTerritory);
        ClsAPLServiceRSM.getRSMTerritoryRefData(rsmTerritory1);
        ClsAPLServiceRSM.getRSMTerritoryRefData(rsmTerritory2);
        ClsAPLServiceRSM.getTerritoryHistoryRefData('test','2016-09-01', '2016-09-01', rsmTerritory.list_dateKey, new ClsAPLEntityTypes.AcctFCValueObj() );//mrunal
        ClsAPLServiceRSM.getTerritoryHisBacklogRefData('test','2014-04-01', '2014-04-01', map_fiscalMonth, rsmTerritory.list_dateKey, new ClsAPLEntityTypes.AcctFCValueObj());
        ClsAPLServiceRSM.getTerritoryCurrentRefData('test', '2014', 4, new ClsAPLEntityTypes.AcctFCValueObj());
        ClsAPLServiceRSM.getRSMAcctFC(rsmAcct);
        ClsAPLServiceRSM.getRSMAcctRefData(rsmAcct);
        ClsAPLServiceRSM.getRSMAcctRefData(rsmAcct1);
        ClsAPLServiceRSM.getRSMAcctRefData(rsmAcct2);
        ClsAPLServiceRSM.getAcctHistoryRefData(acct.Id, 'test','2014-04-01', '2014-04-01', rsmAcct.list_dateKey, new ClsAPLEntityTypes.AcctFCValueObj());
        ClsAPLServiceRSM.getAcctHisBacklogRefData(acct.Id, 'test','2014-04-01', '2014-04-01', map_fiscalMonth, rsmAcct.list_dateKey, new ClsAPLEntityTypes.AcctFCValueObj());
        ClsAPLServiceRSM.getAcctCurrentRefData(acct.Id, 'test', '2014', 4, new ClsAPLEntityTypes.AcctFCValueObj());
        Test.stopTest();
    }
}