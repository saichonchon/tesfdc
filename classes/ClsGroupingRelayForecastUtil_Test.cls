/**
*  This test class used to test class ClsGroupingRelayForecastUtil.
*
@author Lili Zhao
@created 2014-08-20
*
@changelog
* coverage  86%
*  
2014-08-15 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest
private class ClsGroupingRelayForecastUtil_Test {

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
    	insert relayAcct;
    	
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
    	insert relayAcct1;
    	
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
    	amAcct1.GAMCD__c = '1234';
    	amAcct1.Sales_Hierarchy__c = sh.Id;	
    	amAcct1.STATDESC__c = 'Active';
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
        
        Part__c part1 = new Part__c();
        part1.Name = 'testPart';
        part1.GPL__c = ph1.Id;
        part1.Product_Hierarchy__c = ph1.Id; 
        part1.Description__c = 'test';
        insert part1;
        
        Part__c part2 = new Part__c();
        part2.Name = 'testPart1';
        part2.GPL__c = ph1.Id;
        part2.Product_Hierarchy__c = ph1.Id; 
        part2.Description__c = 'test';
        insert part2;
    	
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
		aplFC2.Part__c = part1.Id;
		aplFC2.GPL__c = ph1.Id;
		aplFC2.RSM_Forecast__c = 10;
		aplFC2.Price__c = 2;
		aplFC2.Forecast__c = 10;
		aplFC2.Quantity__c = 5;
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
    	
    	BBB_Month_Bill_Book_Cust_PN__c bbbMon = new BBB_Month_Bill_Book_Cust_PN__c();
    	bbbMon.Customer__c = relayAcct.Id;
    	bbbMon.Bill_Amount_USD__c = 10;
    	bbbMon.Book_Amount_USD__c = 10; 
    	bbbMon.Fiscal_Year__c = '2014';
    	bbbMon.Fiscal_Month__c = 4;
    	//update by nelson zheng 2015-10-21 for case 00900375
    	//bbbMon.Profit_Center__c = 'RPA';
    	bbbMon.Profit_Center__c = 'APL';
    	bbbMon.Part__c = part1.Id;
    	insert bbbMon;
    	
    	BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c bbbDay = new BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c();
    	bbbDay.Backlog_Amount_USD__c = 10;
    	bbbDay.Bill_Amount_USD__c = 10; 
    	bbbDay.Book_Amount_USD__c = 10;
    	bbbDay.Customer__c = relayAcct.Id;
    	bbbDay.Fiscal_Year__c = '2014';
    	bbbDay.Fiscal_Month__c = 4;
    	bbbDay.Customer_Request_Date_Fiscal_Year__c = '2014';
    	bbbday.Customer_Request_Date_Fiscal_Month__c = 4;
    	//update by nelson zheng 2015-10-21 for case 00900375
    	//bbbDay.Profit_Center__c = 'RPA';
    	bbbDay.Profit_Center__c = 'APL';
    	bbbDay.Part__c = part1.Id;
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
    	cbc_fc.map_year_monthsHistory = new map<String, set<Integer>>();	
    	cbc_fc.map_year_monthsHistory.put('2014', new set<Integer>());
    	cbc_fc.map_year_monthsHistory.get('2014').add(4);
    	cbc_fc.map_year_monthsFuture = new map<String, set<Integer>>();
    	cbc_fc.map_year_monthsFuture.put('2014', new set<Integer>());
    	cbc_fc.map_year_monthsFuture.get('2014').add(4);
    	cbc_fc.refStartDate = '2014-04-01';
    	cbc_fc.periodStartDate = '2014-04-21';
    	cbc_fc.refEndDate = '2014-04-01';
    	cbc_fc.currentYear = '2014';
    	cbc_fc.currentMonth = 4;  
    	
    	CtrlGroupingRemoteBase.PartInfo partInfo = new CtrlGroupingRemoteBase.PartInfo();
    	partInfo.aid =  acct.Id; 
    	partInfo.cbc2Name = '13213';
    	partInfo.territoryCode = 'test';
    	partInfo.partId = part1.id;
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
    	partInfo.set_partIds = new set<String>();
    	partInfo.set_partIds.add(part2.Id);
    	//CtrlGroupingRemoteBase.PartInfo part = new CtrlGroupingRemoteBase.PartInfo();
    	
    	map<String, String> map_partId_partName = new map<String, String>();
    	map_partId_partName.put(part1.Id, '');
    	
    	map<String, ClsGroupingRelayForecastUtil.PartFCObect> map_partId_partObj = new map<String, ClsGroupingRelayForecastUtil.PartFCObect>();
    	map_partId_partObj.put(part1.Id, new ClsGroupingRelayForecastUtil.PartFCObect());
    	
    	map<String, set<String>> map_year_quartersFuture = new map<String, set<String>>();	
    	map_year_quartersFuture.put('2014', new set<String>());
    	map_year_quartersFuture.get('2014').add('04'); 
    	
    	ClsAPLEntityTypes.RelayFC relayfc = new ClsAPLEntityTypes.RelayFC();
    	relayfc.amount = 10;
    	relayfc.price = 2;
    	relayfc.total = 20;
    	
    	ClsAPLEntityTypes.RelayPartFCInfo partFC = new ClsAPLEntityTypes.RelayPartFCInfo();
    	partFC.gplId = ph1.Id;
    	partFC.partId = part1.Id;
    	partFC.map_dateKey_relayFC = new map<String, ClsAPLEntityTypes.RelayFC>();
    	partFC.map_dateKey_relayFC.put('2013_04', relayfc);
    	partFC.map_dateKey_relayFC.put('2014_04', relayfc);
    	partFC.map_dateKey_relayFC.put('2015_04', relayfc);
    	
    	ClsAPLEntityTypes.RelayCBCFCInfo cbcFC = new ClsAPLEntityTypes.RelayCBCFCInfo();
    	cbcFC.parentId = acct.Id;
    	cbcFC.cbc2Code = '13213';
    	cbcFC.territoryCode = 'test';
    	cbcFC.quarterNumb = '02';
    	cbcFC.list_partFC = new list<ClsAPLEntityTypes.RelayPartFCInfo>();
    	cbcFC.list_partFC.add(partFC);
    	
    	
    	Test.startTest();
    	
    	ClsGroupingRelayForecastUtil.getAcctTotalFCQuery(userInfo.getUserId(), pageConf, new list<ClsAPLEntityTypes.TotalFCViewFields>());
    	
    	ClsGroupingRelayForecastUtil.getAcctInfo(userInfo.getUserId(), pageConf, new list<ClsGroupingAMForecastUtil.AcctForecastItem>(), new list<ClsGroupingAMForecastUtil.AcctForecastItem>());
    	
    	ClsGroupingRelayForecastUtil.getAcctForecast(userInfo.getUserId(), pageConf, new map<String, ClsGroupingRelayForecastUtil.RelayForecastViewFields>());
    	
    	ClsGroupingRelayForecastUtil.getCBC2FCForRelay(cbc_fc);
    	
    	ClsGroupingRelayForecastUtil.getPartFC(partInfo);
    	
    	ClsGroupingRelayForecastUtil.getPartRefDataForAdd(partInfo);
    	
    	ClsGroupingRelayForecastUtil.setMapPartIdName(map_partId_partName);
    	
    	ClsGroupingRelayForecastUtil.setMapPartIdPrice(map_partId_partObj, new map<String, decimal>(), partInfo);
    	
    	ClsGroupingRelayForecastUtil.addPart(acct.Id, '13213', 'test', 'testPart1',
                               '02', true, new list<ClsGroupingRelayForecastUtil.RelayPartObj>(), 
                               map_year_quartersFuture, false, new set<String>());
                               
    	ClsGroupingRelayForecastUtil.addPart(acct.Id, '13213', 'test', 'testPart1',
                               '02', false, new list<ClsGroupingRelayForecastUtil.RelayPartObj>(), 
                               map_year_quartersFuture, false, new set<String>());
    	
    	ClsGroupingRelayForecastUtil.deletePart(partInfo);
    	
    	ClsGroupingRelayForecastUtil.savePartFC(cbcFC);
    	
    	
    	
    	
		Test.stopTest();
    }
}