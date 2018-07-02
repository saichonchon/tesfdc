/**.
 *  This test class is used to test APL_ClsUtils
 *  
 * @author Weihang Li
 * @created 2015-06-12
 * @version 1.0
 * @since 29.0 (Force.com ApiVersion)  
 * 
 *
 * @changeloga
 * 2015-06-12 Weihang Li <weihang.li@itbconsult.com>
 * - Created
 *
 * coverage 73%
 */
@isTest
private class APL_ClsUtils_Test {
	static testMethod void myUnitTest() {
		ClsAPLEntityTypes.GAMGPLFCInfo gamGPL = new ClsAPLEntityTypes.GAMGPLFCInfo();
    	gamGPL.cbc2Code = '30012';
    	gamGPL.acctId = '';
    	gamGPL.gplId =  '';
    	gamGPL.map_year_quartersFuture = new map<String, set<String>>();	
    	gamGPL.map_year_quartersFuture.put('2014', new set<String>());
    	gamGPL.map_year_quartersFuture.get('2014').add('04'); 
    	gamGPL.list_dateKey = new list<String>();
    	gamGPL.list_dateKey.add('2014_4');
    	gamGPL.list_dateKey.add('2014_4');
    	gamGPL.list_dateKey.add('2014_4');
    	gamGPL.currentYear = '2014';
    	gamGPL.currentMonth = 4;
    	gamGPL.map_dateKey_fc = new map<String, decimal>();
    	gamGPL.list_parts = new list<ClsAPLEntityTypes.GAMPartFCInfo>();
		
		APL_ClsEntityType.PageConfig pc = new APL_ClsEntityType.PageConfig();
        pc.currencyPlaces = 'test';
        pc.currentMonth = 2;
        pc.currentMonthIndex = 2;
        pc.currentTerritoryCode = '23432';
        pc.currentYear = '2015';
        pc.isFrozen = false;
        pc.isOverallFrozen = true;
        pc.isRelay = true;
        pc.isRender = true;
        pc.isSetupDone = false;
        pc.isStop = true;
        pc.json_acctCurrency = 'test';
        pc.json_map_quarter_months = 'test';
        pc.json_rsmAMTerritoryCodes = 'test';
        pc.json_rsmRelayDisplayNames = 'test';
        pc.json_rsmRelayIds = 'test';
        pc.json_rsmRelayTerritoryCodes = 'test';
        pc.json_setGAMCodes = 'test';
        pc.list_yearMonth = new List<String>{'2018_1','2018_11','2018_10','2018_9','2018_1','2018_2','2018_3','2018_4','2018_5','2018_6','2018_7','2018_8','2018_9','2018_10','2018_11','2018_12'};
        pc.managerId = 'test';
        pc.map_acctId_currencyIso = new map<String,string>();
        pc.map_financialMonth = new map<String,set<Integer>>();
        pc.map_financialMonth.put('2017',new set<Integer>{1,2});
        pc.map_quarter_months = new map<String,string>();
        pc.map_workingDays = new map<string,decimal>();
        pc.map_year_monthsFuture = new map<string,set<integer>>();
        pc.map_year_monthsHistory = new map<string,set<Integer>>();
        pc.map_year_quartersFuture = new map<string,set<String>>();
        pc.periodStartDate = 'test';
        pc.pricePlaces = 'test';
        pc.quarterNumb = 'test';
        pc.refEndDate = '2015-06-06';
        pc.refStartDate = '2015-01-01';
        pc.rsmAMDisplayName = 'test name';
        pc.rsmAMId = 'tes';
        pc.samsungId = 'test';
        pc.set_dateKey = new set<string>();
        pc.set_gamCodes = new set<string>();
        pc.set_parentIds = new set<string>();
        pc.set_regions = new set<String>();
        pc.set_rsmAMTerritoryCodes = new set<string>();
        pc.set_rsmRelayDisplayNames = new set<String>();
        pc.set_rsmRelayIds = new set<String>();
        pc.set_rsmRelayTerritoryCodes = new set<String>();
        pc.set_territoryCodes = new set<String>();
        pc.str_financialMonthMap = 'test';
        pc.str_futureMonthMap = 'test';
        pc.str_futureQuarterMap = 'test';
        pc.str_historyMonthMap = 'test';
        pc.str_tableHead = 'test tab head';
        pc.territoryCode = 'test code';
        pc.viewMode = 'test mode';
		
		
		Consumer_Device_Opportunity_Record_Types__c cdort1 = ClsTestHelp.createTestCSD1();
        Consumer_Device_Opportunity_Record_Types__c cdort2 = ClsTestHelp.createTestCSD2();
        Consumer_Device_Opportunity_Record_Types__c cdort3 = ClsTestHelp.createTestCSD3();
        Consumer_Device_Opportunity_Record_Types__c cdort4 = ClsTestHelp.createTestCSD4();
        Consumer_Device_Opportunity_Record_Types__c cdort5 = ClsTestHelp.createTestCSD5();
        Consumer_Device_Opportunity_Record_Types__c cdort6 = ClsTestHelp.createTestCSD6();
        Consumer_Device_Opportunity_Record_Types__c cdort7 = ClsTestHelp.createTestCSD7();
        
		List<Apex_Helper_Settings__c> lstApex_Helper_Settings = new List<Apex_Helper_Settings__c>();
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'System Admin Profile Id', Value__c = ''));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Service Account Profile Id', Value__c = ''));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'TEIS Admin User Id', Value__c = ''));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Account Record Type Id', Value__c = ''));        
        insert lstApex_Helper_Settings;
        
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
        
		RecordType rt2 = ClsTestHelp.createTestRecordType8();
        
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy1();
    	sh.Level_2_Territory_Code__c = '103004';
        insert sh;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
    	ph.Name = '123';
    	ph.CBC2__c = '30012';
    	ph.CBC3__c = '30033';
    	ph.CBC1_Description__c = 'Appliances';
        insert ph;
		
        Account acc=new Account();  
        acc.Name='Test1000';
        acc.BillingCountry='US';
        acc.Account_Manager__c = UserInfo.getUserId();
        acc.Relays_Application_Engineer__c = UserInfo.getUserId();
        acc.Account_Team_Partner_Function__c = UserInfo.getUserId();
        insert acc;    
        
        CtrlGroupingRemoteBase.GPLInfo gpl = new CtrlGroupingRemoteBase.GPLInfo();
        gpl.map_year = new map<String, set<String>>();  
        gpl.map_year.put('2014', new set<String>());
        gpl.map_year.get('2014').add('04');
        gpl.aid = acc.Id;
        gpl.territoryCode = 'test';
        gpl.map_acctId_currencyIso = new map<String, String>();
        gpl.map_acctId_currencyIso.put(acc.Id, 'USD');
        gpl.map_acctId_currencyIso.put(acc.Id, 'USD');
		
    	Part__c part = new Part__c();
        part.Name = 'testPart';
        part.GPL__c = ph.Id;
        part.Product_Hierarchy__c = ph.Id; 
        part.Description__c = 'test';
        part.PRODUCT_CDE__c = 'TEST1';
        part.PROD_NAME__c = 'test name1';
        insert part;
		
		BBB_Month_Bill_Book_Cust_PN__c bbbMon = new BBB_Month_Bill_Book_Cust_PN__c();
    	bbbMon.Customer__c = acc.Id;
    	bbbMon.Bill_Amount_USD__c = 10;
    	bbbMon.Book_Amount_USD__c = 10; 
    	bbbMon.Fiscal_Year__c = '2015';
    	bbbMon.Fiscal_Month__c = 8;
    	bbbMon.Profit_Center__c = 'APL';
    	bbbMon.Part__c = part.Id;
    	insert bbbMon;
		
		
		APL_ClsUtils.Convert15CharTo18CharId('test12351874859685');
		APL_ClsUtils.Convert15CharTo18CharId('onvert15chartto');
		
		APL_ClsUtils.encryptionFormID('testEncryptionFromID');
		APL_ClsUtils.decryptionFormInput('testPassword');
		
		APL_ClsEntityType.LocaleConfig config = new APL_ClsEntityType.LocaleConfig();
		String userLocal = 'German';
		APL_ClsUtils.setUserLocale(config, userLocal);
		
		APL_ClsUtils.getStartDate('2015_9');
		APL_Forecast_Settings__c aps = new APL_Forecast_Settings__c();
		aps.Name = 'Price Decimal Places';
		aps.Value__c = '4';
		insert aps;
		
		APL_Forecast_Settings__c aps1 = new APL_Forecast_Settings__c();
		aps1.Name = 'Currency Rate Decimal Places';
		aps1.Value__c = '4';
		insert aps1;
		
		APL_ClsUtils.getPricePlaces();
		
		List<String> list_str = new List<String>{'2015_1'};
		APL_ClsUtils.getFiscalMonthMap(list_str);
		
		APL_ClsUtils.getRelayPartQuery();
		
		set<string> set_str = new set<string>{'test'};
		map<string,set<string>> map_year_quarter = new map<string,set<string>>();
		map_year_quarter.put('2014',set_str);
		APL_ClsUtils.getMonthFilter(map_year_quarter);
		
		String [] params;
		APL_ClsUtils.getQueryString(params);
		
		APL_ClsUtils.getHexUID();
		
		APL_ClsUtils.getManageUserId(null);
		APL_ClsUtils.getManageUserId(UserInfo.getUserId());
		
		list<string> list_formatStr = new list<string>{'test','test1'};
		APL_ClsUtils.getFormatString(list_formatStr);
		
		APL_ClsUtils.getEndDate('2017_11');
		map<String,set<Integer>> map_str = new map<String,set<Integer>>();
		map_str.put('2015',new set<Integer>{1});
		APL_ClsUtils.getDividedFiscalMap(Date.today(),new List<String>{'2015_1'},map_str,new map<String,set<Integer>>());
		
		map<String,set<Integer>> map_future = new map<String,set<Integer>>();
		map_future.put('4000',new set<Integer>{1});
		List<String> list_str1 = new List<String>{'2015_1'};
		APL_ClsUtils.getDividedFiscalMap(Date.today(),list_str1,map_future,new map<String,set<Integer>>());
		
		map<String, set<Integer>> map_financialMonth = new map<String, set<Integer>>();
		map_financialMonth.put('2017',new set<Integer>{1,2});
		APL_ClsUtils.getCustomRequestMonthFilter(map_financialMonth);
		APL_ClsUtils.getFiscalDate();
		
		APL_ClsUtils.setSoldToMapRefData(new set<String>{'2017','2018'},new set<Integer>{1,2,3,4},new list<Date>{Date.today()},new list<String>{'  Customer__r.AccountNumber refId, sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate ',' BBB_Month_Bill_Book_Cust_PN__c ',' Group by Customer__r.AccountNumber,  Fiscal_Date__c'},new map<String, map<String, AggregateResult>>());
		APL_ClsUtils.setTotelBillingData(new set<String>{'2017','2018'},new set<Integer>{1,2,3,4},new Account(),new list<String>{' Customer__r.AccountNumber refId, sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate ',' BBB_Month_Bill_Book_Cust_PN__c ',' Group by Customer__r.AccountNumber,  Fiscal_Date__c'},new map<String, map<String, AggregateResult>>());
		APL_ClsUtils.setOEMPartMapRefData(new set<String>{'1','2','3','4'},new list<String>{'  Customer__r.AccountNumber refId, sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate ',' BBB_Month_Bill_Book_Cust_PN__c ',' Group by Customer__r.AccountNumber,  Fiscal_Date__c'},new  map<String, map<String, AggregateResult>>());
		APL_ClsUtils.setGAMOEMMapRefData('',new set<String>{'1','2','3','4'},new list<String>{'  Customer__r.AccountNumber refId, sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate ',' BBB_Month_Bill_Book_Cust_PN__c ',' Group by Customer__r.AccountNumber,  Fiscal_Date__c'},new  map<String, map<String, AggregateResult>>());
		APL_ClsUtils.setRefDatelist(new list<Date>{Date.today().addDays(-10)},new list<Date>{Date.today().addDays(100)},new set<String>{'2017_1','2017_2','2017_3','2017_4','2017_5','2017_6','2017_7','2017_8','2017_9','2017_10','2017_11','2017_12'});
		
		APL_ClsEntityType.APLRefObj aplRefObj = new APL_ClsEntityType.APLRefObj();
        aplRefObj.map_backlogrefdata = new map<String,decimal>{'a'=>10};
        aplRefObj.map_billingrefdata = new map<String,decimal>{'b'=>10};
        aplRefObj.map_bookingrefdata = new map<String,decimal>{'c'=>10};
        aplRefObj.map_statisticalrefdata = new map<String,decimal>{'d'=>10};
		APL_ClsUtils.setRefDateObject(new list<Date>{Date.today().addDays(-10)},new list<Date>{Date.today().addDays(100)},new list<Date>(),Date.today(),aplRefObj,new map<String, map<String, AggregateResult>>(),new map<String, map<String, AggregateResult>>());
	
		map<String, set<String>> map_year_quartersFuture = new map<String, set<String>>();
		map_year_quartersFuture.put('2018',new set<String>{'1','2','3','4'});
		APL_ClsUtils.createSearchRSMRelayPartObj(new APL_ClsEntityType.RSMPartObj(),map_year_quartersFuture);
		map<String, set<Integer>> map_year_monthsFuture1 = new map<String, set<Integer>>();
		map_year_monthsFuture1.put('2018',new set<Integer>{1,2,3,4});
		APL_ClsUtils.createAccountObj(new APL_ClsEntityType.AccountObj(),map_year_monthsFuture1);
		
		map<String, set<Integer>> map_year_monthsFuture2 = new map<String, set<Integer>>();
		map_year_monthsFuture2.put('2018',new set<Integer>{1,2,3,4});
		APL_ClsUtils.createOEMAccountObj(new APL_ClsEntityType.OEMAccountObj(),map_year_monthsFuture2);
		
		map<String, String> map_year_month = new map<String, String>();
		map_year_month.put('2018','2');
		APL_ClsUtils.createAccountObjForComprison(new APL_ClsEntityType.AccountObjForComparison(),map_year_month);
	
		map<String, set<Integer>> map_year_monthsFuture3 = new map<String, set<Integer>>();
		map_year_monthsFuture3.put('2019',new set<Integer>{1,2,3,4});
		APL_ClsUtils.createPartObj(new APL_ClsEntityType.PartObj(),map_year_monthsFuture3);
		APL_ClsUtils.copyCFTForecast('');
		APL_ClsUtils.getASP('');
		APL_ClsUtils.setStatisticalForecastDate(new set<String>{'2018'},new set<Integer>{1,2,3,4},new list<Date>{Date.today().addDays(-10),Date.today().addDays(-20)});
		APL_ClsUtils.createDateItemForComparison(pc,new list<APL_ClsEntityType.DateItem>());
		
		//APL_ClsUtils.setGAMViewAccountObjMap(new map<String, APL_ClsEntityType.AccountObj>(),pc,new list<String>{''},new set<String>(),Date.today(),Date.today().addDays(100));
		APL_ClsUtils.getHasForecastProdectCodeQuery('','','',new map<String, set<String>>(),false);
		
		map<String,decimal> map_acctId_billingPercent = new map<String, decimal>();
		map_acctId_billingPercent.put(acc.id,10);
		
		map<String,decimal> map_date_value = new map<String,decimal>();
		map_date_value.put('2018_1',3);
		APL_ClsUtils.generateAMFC(map_acctId_billingPercent,map_date_value,new map<String, map<String, APL_Sales_Forecast__c>>(),'','','','','',new list<APL_Sales_Forecast__c>(),new list<APL_Sales_Forecast__c>(),new list<APL_Sales_Forecast__c>());
	
		APL_ClsUtils.deletePart('','',false,'','','');
		
		map<String, ClsGroupingAMForecastUtil.GPLViewFields> map_gplId_fcViewObj = new map<String, ClsGroupingAMForecastUtil.GPLViewFields>();
		map_gplId_fcViewObj.put('2017',new ClsGroupingAMForecastUtil.GPLViewFields());
		APL_ClsUtils.setAMGPLHighlight('',gpl,map_gplId_fcViewObj);
		
		
		map<String,ClsAPLEntityTypes.GPLFCValueObj> map_gplId_gplFC = new map<String,ClsAPLEntityTypes.GPLFCValueObj>();
		map_gplId_gplFC.put('2017',new ClsAPLEntityTypes.GPLFCValueObj());
		APL_ClsUtils.setGAMAMGPLHighlight(gamGPL,map_gplId_gplFC);
		APL_ClsUtils.getCurrentFiscalDate();
		
		APL_ClsUtils.createDateItem(pc,new list<APL_ClsEntityType.DateItem>());
		APL_ClsUtils.setFiscalMonth(pc);
		APL_ClsUtils.setCurrentMonthIndex(pc);
		APL_ClsUtils.setAllPeriodStartEndDate(new map<String, Date>());
		APL_ClsUtils.setRegionMapRefData('',new set<String>{'2018'},new set<Integer>{1,2,3,4},new set<String>(),new list<String>{' Customer__r.AccountNumber refId, sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate ',' BBB_Month_Bill_Book_Cust_PN__c ',' Group by Customer__r.AccountNumber,  Fiscal_Date__c'},new map<String, map<String, AggregateResult>>());
		APL_ClsUtils.setRefDateObject(new list<Date>{Date.today().addDays(-10)},new list<Date>{Date.today().addDays(100)},aplRefObj,new map<String, map<String, AggregateResult>>(),new map<String, map<String, AggregateResult>>());
		APL_ClsUtils.setRelayRefDateObject(new list<Date>{Date.today().addDays(-10)},new list<Date>{Date.today().addDays(100)},APL_ClsUtils.createRelayRefDataObj(),new map<String, map<String, AggregateResult>>(),new map<String, map<String, AggregateResult>>());
		
		APL_ClsEntityType.RSMAccountObj rsmObj = new APL_ClsEntityType.RSMAccountObj();
        rsmObj.snumber = '1111';
        rsmObj.price = 10;
        rsmObj.json_FCData = 'test';
        rsmObj.isHighLighted = false;
        rsmObj.map_type_FC = new map<String,map<String,decimal>>();
        
        map<String, set<String>> map_yearmonth = new map<String, set<String>>();
        map_yearmonth.put('2018',new set<String>{'1','2','3','4'});
		APL_ClsUtils.createRSMAMroupingObj(rsmObj,map_yearmonth);
		
		APL_ClsUtils.createRSMRelayGroupingObj(rsmObj,map_yearmonth);
		APL_ClsUtils.createRSMAccountObj(rsmObj,map_yearmonth);
		APL_ClsUtils.createRSMRelayAccountObj(rsmObj,map_yearmonth);
		APL_ClsUtils.createRSMRelayPartObj(rsmObj,map_yearmonth);
		APL_ClsUtils.createRefDataObj();
		APL_ClsUtils.createRelayRefDataObj();
		APL_ClsUtils.setRefForecastDate(new set<String>{'2015','2016'},new set<Integer>{10,11,4},new list<Date>{Date.today()});
		APL_ClsUtils.setGAMViewAccountObjMap(new map<String, APL_ClsEntityType.AccountObj>(),pc,new list<String>{'Fiscal_Month__c year, Fiscal_Year__c month, OEM__c oem, name accname, sum(DC_Forecast_Price__c) sumFC, sum(DC_Forecast_Quantity__c) sumPMFC , sum(DC_Forecast_Amount__c) sumDCFC, sum(Previous_10_Month_Forecast__c) restPNFC   ', ' CSD_Sales_Forecast__c', ' group by Fiscal_Month__c, Fiscal_Year__c, OEM__c, name '}, new set<String>(), Date.today(), Date.today());
		APL_ClsUtils.setTerritoryInfo(new set<String>(),'','');
		APL_ClsUtils.setTerritoryUserName(new map<String, String>(),'','');
		APL_ClsUtils.setAllTerritoryCode('',new set<String>(),new set<String>(),new set<String>(),'');
		APL_ClsUtils.getExistingProductCodeFC('','','','',new map<String, set<String>>(),new map<String, map<String, map<String, APL_Sales_Forecast__c>>>());
		
		ClsAPLEntityTypes.RSMGPLFCInfo rsmGPL = new ClsAPLEntityTypes.RSMGPLFCInfo();
    	rsmGPL.acctId = acc.Id;
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
    	
		//APL_ClsUtils.getExistingPartFC(rsmGPL.acctId,rsmGPL.gplId,rsmGPL.territoryCode,rsmGPL.cbc2Code,new map<String, set<String>>(),new map<String, map<String, map<String, APL_Sales_Forecast__c>>>());
		APL_ClsEntityType.APLForecastValueObj aplForeValObj = new APL_ClsEntityType.APLForecastValueObj();
        aplForeValObj.accnumber = '123';
        aplForeValObj.cbc2Code = '333';
        aplForeValObj.currencyIso = 'RMB';
        aplForeValObj.gplId = 'test';
        aplForeValObj.grouping = 'test';
        aplForeValObj.managerId = 'test';
        aplForeValObj.map_datekey_csFC = new map<String,decimal>{'a'=>10};
        aplForeValObj.map_year_quartersFuture = new map<String,set<String>>();
        aplForeValObj.partId = part.Id;
        aplForeValObj.price = 10;
        aplForeValObj.productcode = '23423423';
        aplForeValObj.productname = 'test product';
        aplForeValObj.territoryCode = 'test';
        map<String, map<String, decimal>> map_test = new map<String, map<String, decimal>>();
        map<String, decimal> map_test1 = new map<String,decimal>();
        map_test1.put(acc.Id,1);
        map_test.put('test',map_test1);
		APL_ClsUtils.generateProductFC(aplForeValObj,map_test,new map<String, map<String, map<String, APL_Sales_Forecast__c>>>(),new map<String, decimal>(),'','',new list<APL_Sales_Forecast__c>(),new list<APL_Sales_Forecast__c>(),new list<APL_Sales_Forecast__c>());
		APL_ClsUtils.getRelayCBC2CodeQuery();
		APL_ClsUtils.getRelayCBCFilter('test');
		
		APL_ClsEntityType.SearchObj so = new APL_ClsEntityType.SearchObj();
        so.searchKey = 'Test';
        so.soldtoId = null;
        so.accnumber = 'Test';
        so.oemId = null;
        so.partId = part.Id;
        so.region = 'Test';
        so.gplfamily = 'Test';
        so.gplId = ph.Id;
        so.rsmgrouping = 'Test';
        so.grouping = 'Test';
        so.cbc2Code = 'Test';
        so.relayCode = 'Test';
        so.territoryCode = 'Test';
        so.set_selectedId = null;
        so.map_year_monthsFuture = null;
        so.map_year_quartersFuture = new map<String,set<String>>();
        so.map_year_quartersFuture.put('2017',new set<String>());
        so.startDate = '2015-05-01';
        so.endDate = '2015-05-01';
        so.isOtherMethod = true;
        so.set_fiscalMonth = null;
        so.isExpansionSoldto = true;
        so.hasGPLCode = true;
        so.viewMode = 'Test';
        so.userId = UserInfo.getUserId();
        so.managerId = UserInfo.getUserId();
        so.type = 'CBC2';
        so.currencyIso = 'USD';
        so.set_deletedId  = null;
        so.map_quarter_months = null;
        so.map_acctId_currencyIso = null;
        so.set_gamCodes = null;
        
        map<String, APL_ClsEntityType.RSMAccountObj> map_year_entry = new map<String, APL_ClsEntityType.RSMAccountObj>();
        map_year_entry.put('2017',rsmObj);
		APL_ClsUtils.setHighlight(so,'Relay','AM',map_year_entry);
		
		so.isOtherMethod = false;
		APL_ClsUtils.setHighlight(so,'Relay','AM',map_year_entry);
		
		so.isOtherMethod = false;
		APL_ClsUtils.setHighlight(so,'Part','RSM',map_year_entry);
		
		so.isOtherMethod = false;
		APL_ClsUtils.setHighlight(so,'Relay','RSM',map_year_entry);
		
		so.isOtherMethod = false;
		//APL_ClsUtils.setHighlight(so,'Relay','GAM',map_year_entry);
		
		
		APL_ClsUtils.setRSMAMGPLHighlight(rsmGPL,map_gplId_gplFC);
	
	}
}