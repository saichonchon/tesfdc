/**
*  This test class used to test class ClsGroupingAMForecastUtil.
*
@author Lili Zhao
@created 2014-08-20
*
@changelog
* coverage  89%
*  
2014-08-15 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest
private class ClsGroupingAMForecastUtil_Test {

    static testMethod void myUnitTest() {
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        
        //RecordType rt = ClsTestHelp.createTestRecordType8();
        RecordType rt2 = ClsTestHelp.createTestRecordType8();
        
        Opportunity_Record_Type_Groups__c  org1 = ClsTestHelp.createTestOPTG3();
        
        //Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy1();
        sh.Level_2_Territory_Code__c = '103004';
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
        acct.STATDESC__c = 'Active';
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
        //insert relayAcct;
        
        Account relayAcct1 = ClsTestHelp.createTestAccounts();
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
        relayAcct1.STATDESC__c = 'Active';
        
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
        amAcct.STATDESC__c = 'Active';
        
        Account amAcct1 = ClsTestHelp.createTestAccounts();
        amAcct1.Name = 'axx';
        amAcct1.RecordTypeId = rt2.Id;
        amAcct1.APL_AM_forecast_Plan_Account__c = null;
        amAcct1.APL_AM_Currency__c = 'USD';
        amAcct1.APL_AM_Display_Name__c = 'amName';
        amAcct1.APL_AM_ParentAccount__c = acct.Id;      
        amAcct1.Account_Manager__c = userInfo.getUserId();
        amAcct1.SALES_TERRITORY_CDE__c = 'test';
        amAcct1.GAMCD__c = '1234';
        amAcct1.Sales_Hierarchy__c = sh.Id;
        amAcct1.STATDESC__c = 'Active';
        system.debug('sh::' + sh);
        insert new List<Account>{relayAcct, relayAcct1, amAcct, amAcct1};
        
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
        insert new List<Product_Hierarchy__c>{ph, ph1};
        
        Part__c part = new Part__c();
        part.Name = 'testPart';
        part.GPL__c = ph.Id;
        part.Product_Hierarchy__c = ph.Id; 
        part.Description__c = 'test';
        //insert part;
        
        Part__c part1 = new Part__c();
        part1.Name = 'testPart1';
        part1.GPL__c = ph.Id;
        part1.Product_Hierarchy__c = ph.Id; 
        part1.Description__c = 'test';
        insert new List<Part__c>{part, part1};
        
        APL_Sales_Forecast__c aplFC1 = new APL_Sales_Forecast__c();
        aplFC1.type__c = 'GPL';
        aplFC1.Fiscal_Year__c = '2014';
        aplFC1.Fiscal_Quarter__c = '04';
        aplFC1.customer__c = amAcct.Id;
        aplFC1.RSM_Forecast__c = 10;
        aplFC1.Forecast__c = 10;
        aplFC1.GPL__c = ph.Id;
        aplFC1.Part__c = part.Id;
        insert aplFC1;
        
        APL_Sales_Forecast__c aplFC3 = new APL_Sales_Forecast__c();
        aplFC3.type__c = 'Part';
        aplFC3.Fiscal_Year__c = '2014';
        aplFC3.Fiscal_Quarter__c = '04';
        aplFC3.customer__c = amAcct.Id;
        aplFC3.RSM_Forecast__c = 10;
        aplFC3.Forecast__c = 10;
        aplFC3.GPL__c = ph.Id;
        aplFC3.Part__c = part.Id;
        //insert aplFC3;
        
        APL_Sales_Forecast__c aplFC4 = new APL_Sales_Forecast__c();
        aplFC4.type__c = 'other';
        aplFC4.Fiscal_Year__c = '2014';
        aplFC4.Fiscal_Quarter__c = '04';
        aplFC4.customer__c = amAcct1.Id;
        aplFC4.RSM_Forecast__c = 10;
        aplFC4.Forecast__c = 10;
        aplFC4.GPL__c = ph.Id;
        aplFC4.Part__c = part.Id;
        //insert aplFC4;
        
        APL_Sales_Forecast__c aplFC2 = new APL_Sales_Forecast__c();
        aplFC2.type__c = 'Relay';
        aplFC2.Fiscal_Year__c = '2014';
        aplFC2.Fiscal_Quarter__c = '04';
        aplFC2.customer__c = relayAcct.Id;
        aplFC2.Part__c = part.Id;
        aplFC2.Forecast__c = 10;
        aplFC2.GPL__c = ph1.Id;
        aplFC2.RSM_Forecast__c = 10;
        insert new List<APL_Sales_Forecast__c>{aplFC2 , aplFC3 , aplFC4};
        
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
        insert new List<APL_RSM__c>{aplRsm, aplRsm1, aplRsm2};
        
        RecordType rt25 = ClsTestHelp.createTestRecordType25(); 
        APL_Forecast_Management__c apl = new APL_Forecast_Management__c();
        apl.Name = 'testName';
        apl.A6_Code__c = '123456';
        apl.Manager__c = userInfo.getUserId();  
        apl.RSM__c = aplRsm2.Id;
        apl.GAM_Code__c = '1234';
        apl.RecordTypeId = rt25.Id;
        //insert apl;
        
        APL_Forecast_Management__c apl1 = new APL_Forecast_Management__c();
        apl1.Name = 'testName1';
        apl1.A6_Code__c = '1234567';
        apl1.GAM_Code__c = '1234';
        apl1.Manager__c = userInfo.getUserId();
        apl1.RecordTypeId = rt25.Id;
        apl1.RSM__c = aplRsm1.Id;
        insert new List<APL_Forecast_Management__c>{apl, apl1};
        
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
        bbbDay.Fiscal_Year__c = '2014';
        bbbDay.Fiscal_Month__c = 4;
        bbbDay.Customer_Request_Date_Fiscal_Year__c = '2014';
        bbbday.Customer_Request_Date_Fiscal_Month__c = 4;
        bbbDay.Profit_Center__c = 'APL';
        bbbDay.Part__c = part.Id;
        insert bbbDay;
        
        map<String, String> map_acctId_currencyIso = new map<String, String>();
        map_acctId_currencyIso.put(amAcct.Id, 'USD'); 
        map_acctId_currencyIso.put(acct.Id, 'USD');     
        
        ClsAPLEntityTypes.PageConfig pageConf = new ClsAPLEntityTypes.PageConfig();
        pageConf.currentTerritoryCode = 'test';
        pageConf.map_year_quartersFuture.put('2014', new set<String>());
        pageConf.map_year_quartersFuture.get('2014').add('04');
        pageConf.json_acctCurrency = Json.serialize(map_acctId_currencyIso);
        pageConf.set_parentIds.add(amAcct.Id);
        pageConf.set_parentIds.add(relayAcct.Id);
        pageConf.set_parentIds.add(acct.Id);
        
        CtrlGroupingRemoteBase.AcctForecast acctFCInfo = new CtrlGroupingRemoteBase.AcctForecast();
        acctFCInfo.list_dateKey = new list<String>();
        acctFCInfo.list_dateKey.add('2014_4');
        acctFCInfo.list_dateKey.add('2014_4');
        acctFCInfo.list_dateKey.add('2014_4');
        acctFCInfo.currentYear = '2014';
        acctFCInfo.currentMonth = 4;
        acctFCInfo.map_acctId_currencyIso = new map<String, String>();
        acctFCInfo.map_acctId_currencyIso.put(amAcct.Id, 'USD');
        acctFCInfo.map_acctId_currencyIso.put(acct.Id, 'USD');
        acctFCInfo.aid = acct.Id;
        
        CtrlGroupingRemoteBase.AcctForecast acctFCInfo1 = new CtrlGroupingRemoteBase.AcctForecast();
        acctFCInfo1.list_dateKey = new list<String>();
        acctFCInfo1.list_dateKey.add('2013_4');
        acctFCInfo1.list_dateKey.add('2014_4');
        acctFCInfo1.list_dateKey.add('2015_4');
        acctFCInfo1.currentYear = '2014';
        acctFCInfo1.currentMonth = 4;
        acctFCInfo1.map_acctId_currencyIso = new map<String, String>();
        acctFCInfo1.map_acctId_currencyIso.put(amAcct.Id, 'USD');
        acctFCInfo1.map_acctId_currencyIso.put(acct.Id, 'USD');
        acctFCInfo1.aid = acct.Id;
        
        CtrlGroupingRemoteBase.AcctForecast acctFCInfo2 = new CtrlGroupingRemoteBase.AcctForecast();
        acctFCInfo2.list_dateKey = new list<String>();
        acctFCInfo2.list_dateKey.add('2014_4');
        acctFCInfo2.list_dateKey.add('2014_4');
        acctFCInfo2.list_dateKey.add('2014_4');
        acctFCInfo2.currentYear = '2016';
        acctFCInfo2.currentMonth = 4;
        acctFCInfo2.map_acctId_currencyIso = new map<String, String>();
        acctFCInfo2.map_acctId_currencyIso.put(amAcct.Id, 'USD');
        acctFCInfo2.map_acctId_currencyIso.put(acct.Id, 'USD');
        acctFCInfo2.aid = acct.Id;
        
        CtrlGroupingRemoteBase.CBC2Forecast cbc_fc = new CtrlGroupingRemoteBase.CBC2Forecast();
        cbc_fc.aid = acct.Id;
        cbc_fc.territoryCode = 'test';
        cbc_fc.map_year = new map<String, set<String>>();   
        cbc_fc.map_year.put('2014', new set<String>());
        cbc_fc.map_year.get('2014').add('04');
        cbc_fc.map_acctId_currencyIso = new map<String, String>();
        cbc_fc.map_acctId_currencyIso.put(amAcct.Id, 'USD');
        cbc_fc.map_acctId_currencyIso.put(acct.Id, 'USD');
        cbc_fc.map_cbcName = new map<String, String>();
        cbc_fc.map_cbcName.put('30012', 'test');
        cbc_fc.map_cbcName.put('30022', 'test');
        cbc_fc.list_dateKey = new list<String>();
        cbc_fc.list_dateKey.add('2014_4');
        cbc_fc.list_dateKey.add('2014_4');
        cbc_fc.list_dateKey.add('2014_4');
        cbc_fc.currentYear = '2014';
        cbc_fc.currentMonth = 4;
        cbc_fc.cbcCode = '30012';
        
        CtrlGroupingRemoteBase.CBC2Forecast cbc_fc1 = new CtrlGroupingRemoteBase.CBC2Forecast();
        cbc_fc1.aid = acct.Id;
        cbc_fc1.territoryCode = 'test';
        cbc_fc1.map_year = new map<String, set<String>>();  
        cbc_fc1.map_year.put('2014', new set<String>());
        cbc_fc1.map_year.get('2014').add('04');
        cbc_fc1.map_acctId_currencyIso = new map<String, String>();
        cbc_fc1.map_acctId_currencyIso.put(amAcct.Id, 'USD');
        cbc_fc1.map_acctId_currencyIso.put(acct.Id, 'USD');
        cbc_fc1.map_cbcName = new map<String, String>();
        cbc_fc1.map_cbcName.put('30012', 'test');
        cbc_fc1.map_cbcName.put('30022', 'test');
        cbc_fc1.list_dateKey = new list<String>();
        cbc_fc1.list_dateKey.add('2013_4');
        cbc_fc1.list_dateKey.add('2014_4');
        cbc_fc1.list_dateKey.add('2016_4');
        cbc_fc1.currentYear = '2014';
        cbc_fc1.currentMonth = 4;
        cbc_fc1.cbcCode = '30012';
        
        CtrlGroupingRemoteBase.CBC2Forecast cbc_fc2 = new CtrlGroupingRemoteBase.CBC2Forecast();
        cbc_fc2.aid = acct.Id;
        cbc_fc2.territoryCode = 'test';
        cbc_fc2.map_year = new map<String, set<String>>();  
        cbc_fc2.map_year.put('2014', new set<String>());
        cbc_fc2.map_year.get('2014').add('04');
        cbc_fc2.map_acctId_currencyIso = new map<String, String>();
        cbc_fc2.map_acctId_currencyIso.put(amAcct.Id, 'USD');
        cbc_fc2.map_acctId_currencyIso.put(acct.Id, 'USD');
        cbc_fc2.map_cbcName = new map<String, String>();
        cbc_fc2.map_cbcName.put('30012', 'test');
        cbc_fc2.map_cbcName.put('30022', 'test');
        cbc_fc2.list_dateKey = new list<String>();
        cbc_fc2.list_dateKey.add('2014_4');
        cbc_fc2.list_dateKey.add('2014_4');
        cbc_fc2.list_dateKey.add('2014_4');
        cbc_fc2.currentYear = '2016';
        cbc_fc2.currentMonth = 4;
        cbc_fc2.cbcCode = '30012';
        
        CtrlGroupingRemoteBase.GPLInfo gpl = new CtrlGroupingRemoteBase.GPLInfo();
        gpl.map_year = new map<String, set<String>>();  
        gpl.map_year.put('2014', new set<String>());
        gpl.map_year.get('2014').add('04');
        gpl.aid = acct.Id;
        gpl.territoryCode = 'test';
        gpl.map_acctId_currencyIso = new map<String, String>();
        gpl.map_acctId_currencyIso.put(amAcct.Id, 'USD');
        gpl.map_acctId_currencyIso.put(acct.Id, 'USD');
        
        CtrlGroupingRemoteBase.GPLInfo gplfc = new CtrlGroupingRemoteBase.GPLInfo();
        gplfc.aid = acct.Id;
        gplfc.territoryCode = 'test';
        gplfc.gplId = ph.Id;
        gplfc.cbcCode = '30012';
        gplfc.map_year = new map<String, set<String>>();    
        gplfc.map_year.put('2014', new set<String>());
        gplfc.map_year.get('2014').add('04');
        gplfc.map_acctId_currencyIso = new map<String, String>();
        gplfc.map_acctId_currencyIso.put(amAcct.Id, 'USD');
        gplfc.map_acctId_currencyIso.put(acct.Id, 'USD');
        gplfc.isNeedBillPercentage = true;
        gplfc.quarterNumb = 'Q2';
        gplfc.list_dateKey = new list<String>();
        gplfc.list_dateKey.add('2014_4');
        gplfc.list_dateKey.add('2014_4');
        gplfc.list_dateKey.add('2014_4');
        gplfc.currentYear = '2014';
        gplfc.currentMonth = 4;
        
        CtrlGroupingRemoteBase.GPLInfo gplfc1 = new CtrlGroupingRemoteBase.GPLInfo();
        gplfc1.aid = acct.Id;
        gplfc1.territoryCode = 'test';
        gplfc1.gplId = ph.Id;
        gplfc1.cbcCode = '30012';
        gplfc1.map_year = new map<String, set<String>>();   
        gplfc1.map_year.put('2014', new set<String>());
        gplfc1.map_year.get('2014').add('04');
        gplfc1.map_acctId_currencyIso = new map<String, String>();
        gplfc1.map_acctId_currencyIso.put(amAcct.Id, 'USD');
        gplfc1.map_acctId_currencyIso.put(acct.Id, 'USD');
        gplfc1.isNeedBillPercentage = true;
        gplfc1.quarterNumb = 'Q2';
        gplfc1.list_dateKey = new list<String>();
        gplfc1.list_dateKey.add('2013_4');
        gplfc1.list_dateKey.add('2014_4');
        gplfc1.list_dateKey.add('2015_4');
        gplfc1.currentYear = '2014';
        gplfc1.currentMonth = 4;
        
        CtrlGroupingRemoteBase.GPLInfo gplfc2 = new CtrlGroupingRemoteBase.GPLInfo();
        gplfc2.aid = acct.Id;
        gplfc2.territoryCode = 'test';
        gplfc2.gplId = ph.Id;
        gplfc2.cbcCode = '30012';
        gplfc2.map_year = new map<String, set<String>>();   
        gplfc2.map_year.put('2014', new set<String>());
        gplfc2.map_year.get('2014').add('04');
        gplfc2.map_acctId_currencyIso = new map<String, String>();
        gplfc2.map_acctId_currencyIso.put(amAcct.Id, 'USD');
        gplfc2.map_acctId_currencyIso.put(acct.Id, 'USD');
        gplfc2.isNeedBillPercentage = true;
        gplfc2.quarterNumb = 'Q2';
        gplfc2.list_dateKey = new list<String>();
        gplfc2.list_dateKey.add('2014_4');
        gplfc2.list_dateKey.add('2014_4');
        gplfc2.list_dateKey.add('2014_4');
        gplfc2.currentYear = '2016';
        gplfc2.currentMonth = 4;
        
        CtrlGroupingRemoteBase.PartInfo partInfo = new CtrlGroupingRemoteBase.PartInfo();
        partInfo.aid =  acct.Id; 
        partInfo.gplId = ph.Id;
        partInfo.territoryCode = 'test';
        partInfo.map_year = new map<String, set<String>>(); 
        partInfo.map_year.put('2014', new set<String>());
        partInfo.map_year.get('2014').add('04');
        partInfo.map_acctId_currencyIso = new map<String, String>();
        partInfo.map_acctId_currencyIso.put(amAcct.Id, 'USD');
        partInfo.map_acctId_currencyIso.put(acct.Id, 'USD');        
        partInfo.map_year_monthsHistory = new map<String, set<Integer>>();  
        partInfo.map_year_monthsHistory.put('2014', new set<Integer>());
        partInfo.map_year_monthsHistory.get('2014').add(4);
        partInfo.map_year_monthsFuture = new map<String, set<Integer>>();
        partInfo.map_year_monthsFuture.put('2014', new set<Integer>());
        partInfo.map_year_monthsFuture.get('2014').add(4);
        partInfo.refStartDate = '2014-04-01';
        partInfo.periodStartDate = '2014-04-21';
        partInfo.refEndDate = '2014-04-01';
        partInfo.currentYear = '2014';
        partInfo.currentMonth = 4; 
        partInfo.isOther = false; 
        partInfo.set_partIds = new set<String>();
        partInfo.set_partIds.add(part1.Id);
        
        map<String, String> map_partId_partName = new map<String, String>();
        map_partId_partName.put(part.Id, '');
        
        ClsAPLForecastObjects.PartObject partObj = new ClsAPLForecastObjects.PartObject();
        partObj.partId = part.Id;
        partObj.currencyIso = 'USD';
        partObj.map_dateKey_fc = new map<String, decimal>();
        partObj.map_dateKey_fc.put('2014_04', 20);
        partObj.map_dateKey_fc.put('2015_01', 20);
        partObj.map_dateKey_fc.put('2013_01', 20);
        
        ClsAPLForecastObjects.PartObject partObj1 = new ClsAPLForecastObjects.PartObject();
        partObj1.partId = part.Id;
        partObj1.currencyIso = 'USD';
        partObj1.map_dateKey_fc = new map<String, decimal>();
        partObj1.map_dateKey_fc.put('2014_04', 20);
        partObj1.map_dateKey_fc.put('2015_01', 20);
        partObj1.map_dateKey_fc.put('2013_01', 20);
        
        ClsAPLForecastObjects.GplObject gplObj = new ClsAPLForecastObjects.GplObject();
        gplObj.parentId =  acct.Id; 
        gplObj.gplId = ph.Id;
        gplObj.territoryCode = 'test';
        gplObj.quarterNumb = '02';
        gplObj.map_year_quartersFuture = new map<String, set<String>>();    
        gplObj.map_year_quartersFuture.put('2014', new set<String>());
        gplObj.map_year_quartersFuture.get('2014').add('04');       
        gplObj.map_dateKey_fc = new map<String, decimal>();
        gplObj.map_dateKey_fc.put('2014_04', 20);
        gplObj.map_dateKey_fc.put('2015_01', 20);
        gplObj.map_dateKey_fc.put('2013_01', 20);
        gplObj.currencyIso = 'USD';
        gplObj.list_partFC = new list<ClsAPLForecastObjects.PartObject>();
        gplObj.list_partFC.add(partObj);
        
        ClsAPLForecastObjects.OtherCBCObject otherCBCFC = new ClsAPLForecastObjects.OtherCBCObject();
        otherCBCFC.parentId =  'other'; 
        otherCBCFC.territoryCode = 'test';
        otherCBCFC.quarterNumb = '02';
        otherCBCFC.map_year_quartersFuture = new map<String, set<String>>();    
        otherCBCFC.map_year_quartersFuture.put('2014', new set<String>());
        otherCBCFC.map_year_quartersFuture.get('2014').add('04'); 
        otherCBCFC.list_partFC = new list<ClsAPLForecastObjects.PartObject>();
        otherCBCFC.list_partFC.add(partObj1);
        
        ClsAPLEntityTypes.RSMTerritoryFCInfo rsmRegion = new ClsAPLEntityTypes.RSMTerritoryFCInfo();
        rsmRegion.managerId = userInfo.getUserId();
        rsmRegion.territoryCode = 'test';
        
          
        
        Test.startTest();
        ClsGroupingAMForecastUtil.getAcctTotalFCQuery(userInfo.getUserId(), pageConf, new list<ClsGroupingAMForecastUtil.TotalFCViewFields>());
        ClsGroupingAMForecastUtil.getAccountFCQuery(userInfo.getUserId(), pageConf);
        ClsGroupingAMForecastUtil.getAcctForecast(userInfo.getUserId(), pageConf, new map<String, ClsGroupingAMForecastUtil.ForecastViewFields>());
        ClsGroupingAMForecastUtil.getAMAcctRefData(acctFCInfo);
        ClsGroupingAMForecastUtil.getAMAcctRefData(acctFCInfo1);
        ClsGroupingAMForecastUtil.getAMAcctRefData(acctFCInfo2);
        ClsGroupingAMForecastUtil.getAcctInfo(userInfo.getUserId(), pageConf, new list<ClsGroupingAMForecastUtil.AcctForecastItem>(), new list<ClsGroupingAMForecastUtil.AcctForecastItem>());
        ClsGroupingAMForecastUtil.getCBC2FC(cbc_fc);
        ClsGroupingAMForecastUtil.getAMCBCRefData(cbc_fc);
        ClsGroupingAMForecastUtil.getAMCBCRefData(cbc_fc1);
        ClsGroupingAMForecastUtil.getAMCBCRefData(cbc_fc2);
        ClsGroupingAMForecastUtil.getRelayCBC2FC(gpl);
        ClsGroupingAMForecastUtil.getGPLFC('30012', gplfc);
        ClsGroupingAMForecastUtil.getAMGPLRefData(gplfc);
        ClsGroupingAMForecastUtil.getAMGPLRefData(gplfc1);
        ClsGroupingAMForecastUtil.getAMGPLRefData(gplfc2);
        ClsGroupingAMForecastUtil.getRelayGPLQuery(false);
        ClsGroupingAMForecastUtil.getReferenceRelayGPLQuery();
        ClsGroupingAMForecastUtil.getPartFC(partInfo, false, false);
        ClsGroupingAMForecastUtil.getPartRefDataForAdd(partInfo);
        ClsGroupingAMForecastUtil.setMapPartIdName(map_partId_partName);
        ClsGroupingAMForecastUtil.addPart(acct.Id, '30012', 'test', ph.Id, 'testPart1',
                               '02', true, false, new list<ClsGroupingAMForecastUtil.PartObj>(), 
                               otherCBCFC.map_year_quartersFuture, new set<String>());
        ClsGroupingAMForecastUtil.addPart(acct.Id, '30012', 'test', ph.Id, 'testPart1',
                               '02', false, false, new list<ClsGroupingAMForecastUtil.PartObj>(), 
                               otherCBCFC.map_year_quartersFuture, new set<String>());
        ClsGroupingAMForecastUtil.deletePart(acct.Id, 'test', false, '30012', ph.Id, part.Id);
        ClsGroupingAMForecastUtil.saveAcctFC(new ClsAPLForecastObjects.AccountObject());
        /*ClsGroupingAMForecastUtil.saveGPLAndPartFC(gplObj);
        ClsGroupingAMForecastUtil.saveOtherCBCPartFC(otherCBCFC);
        AggregateResult result;
        ClsGroupingAMForecastUtil.AcctViewColumns acctViewColumns = new ClsGroupingAMForecastUtil.AcctViewColumns('test', 'fieldName', 'cls', 'matchName', false);
        ClsGroupingAMForecastUtil.Cbc2Object cbc2Object = new ClsGroupingAMForecastUtil.Cbc2Object('test', 'fieldName', 'cls', 'matchName');
        ClsGroupingAMForecastUtil.TotalFCViewFields totalFCViewFields = new ClsGroupingAMForecastUtil.TotalFCViewFields();
        totalFCViewFields.assignFCValues(new ClsGroupingAMForecastUtil.TotalFCViewFields(), result, '2014-04');
        ClsGroupingAMForecastUtil.TotalFCViewFields totalFCViewFields1 = new ClsGroupingAMForecastUtil.TotalFCViewFields('test');
        ClsGroupingAMForecastUtil.PageConfig pageConfig = new ClsGroupingAMForecastUtil.PageConfig();
        ClsGroupingAMForecastUtil.GPLPartAccountPercent gPLPartAccountPercent = new ClsGroupingAMForecastUtil.GPLPartAccountPercent('GPLCode', new list<ClsGroupingAMForecastUtil.PartIdAccountPercent>());
        ClsGroupingAMForecastUtil.PartIdAccountPercent partIdAccountPercent = new ClsGroupingAMForecastUtil.PartIdAccountPercent('partId', 'accountId', 10);
        */
        Test.stopTest();
    }
    
    static testMethod void myUnitTest2() {
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        
        Opportunity_Record_Type_Groups__c  org1 = ClsTestHelp.createTestOPTG3();
        
        RecordType rt2 = ClsTestHelp.createTestRecordType8();
        
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
        acct.STATDESC__c = 'Active';
        insert acct;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Name = '123';
        ph.CBC2__c = '30012';
        ph.CBC3__c = '30033';
        ph.CBC1_Description__c = 'Appliances';
        insert ph;
        
        Part__c part = new Part__c();
        part.Name = 'testPart';
        part.GPL__c = ph.Id;
        part.Product_Hierarchy__c = ph.Id; 
        part.Description__c = 'test';
        insert part;
        
        ClsAPLForecastObjects.PartObject partObj = new ClsAPLForecastObjects.PartObject();
        partObj.partId = part.Id;
        partObj.currencyIso = 'USD';
        partObj.map_dateKey_fc = new map<String, decimal>();
        partObj.map_dateKey_fc.put('2014_04', 20);
        partObj.map_dateKey_fc.put('2015_01', 20);
        partObj.map_dateKey_fc.put('2013_01', 20);
        
        ClsAPLForecastObjects.PartObject partObj1 = new ClsAPLForecastObjects.PartObject();
        partObj1.partId = part.Id;
        partObj1.currencyIso = 'USD';
        partObj1.map_dateKey_fc = new map<String, decimal>();
        partObj1.map_dateKey_fc.put('2014_04', 20);
        partObj1.map_dateKey_fc.put('2015_01', 20);
        partObj1.map_dateKey_fc.put('2013_01', 20);
        
        ClsAPLForecastObjects.OtherCBCObject otherCBCFC = new ClsAPLForecastObjects.OtherCBCObject();
        otherCBCFC.parentId =  'other'; 
        otherCBCFC.territoryCode = 'test';
        otherCBCFC.quarterNumb = '02';
        otherCBCFC.map_year_quartersFuture = new map<String, set<String>>();    
        otherCBCFC.map_year_quartersFuture.put('2014', new set<String>());
        otherCBCFC.map_year_quartersFuture.get('2014').add('04'); 
        otherCBCFC.list_partFC = new list<ClsAPLForecastObjects.PartObject>();
        otherCBCFC.list_partFC.add(partObj1);
        
        
        
        ClsAPLForecastObjects.GplObject gplObj = new ClsAPLForecastObjects.GplObject();
        gplObj.parentId =  acct.Id; 
        gplObj.gplId = ph.Id;
        gplObj.territoryCode = 'test';
        gplObj.quarterNumb = '02';
        gplObj.map_year_quartersFuture = new map<String, set<String>>();    
        gplObj.map_year_quartersFuture.put('2014', new set<String>());
        gplObj.map_year_quartersFuture.get('2014').add('04');       
        gplObj.map_dateKey_fc = new map<String, decimal>();
        gplObj.map_dateKey_fc.put('2014_04', 20);
        gplObj.map_dateKey_fc.put('2015_01', 20);
        gplObj.map_dateKey_fc.put('2013_01', 20);
        gplObj.currencyIso = 'USD';
        gplObj.list_partFC = new list<ClsAPLForecastObjects.PartObject>();
        gplObj.list_partFC.add(partObj);
        
        test.startTest();
        ClsGroupingAMForecastUtil.saveGPLAndPartFC(gplObj);
        ClsGroupingAMForecastUtil.saveOtherCBCPartFC(otherCBCFC);
        AggregateResult result;
        ClsGroupingAMForecastUtil.AcctViewColumns acctViewColumns = new ClsGroupingAMForecastUtil.AcctViewColumns('test', 'fieldName', 'cls', 'matchName', false);
        ClsGroupingAMForecastUtil.Cbc2Object cbc2Object = new ClsGroupingAMForecastUtil.Cbc2Object('test', 'fieldName', 'cls', 'matchName');
        ClsGroupingAMForecastUtil.TotalFCViewFields totalFCViewFields = new ClsGroupingAMForecastUtil.TotalFCViewFields();
        totalFCViewFields.assignFCValues(new ClsGroupingAMForecastUtil.TotalFCViewFields(), result, '2014-04');
        ClsGroupingAMForecastUtil.TotalFCViewFields totalFCViewFields1 = new ClsGroupingAMForecastUtil.TotalFCViewFields('test');
        ClsGroupingAMForecastUtil.PageConfig pageConfig = new ClsGroupingAMForecastUtil.PageConfig();
        ClsGroupingAMForecastUtil.GPLPartAccountPercent gPLPartAccountPercent = new ClsGroupingAMForecastUtil.GPLPartAccountPercent('GPLCode', new list<ClsGroupingAMForecastUtil.PartIdAccountPercent>());
        ClsGroupingAMForecastUtil.PartIdAccountPercent partIdAccountPercent = new ClsGroupingAMForecastUtil.PartIdAccountPercent('partId', 'accountId', 10);
        test.stopTest();
    }
}