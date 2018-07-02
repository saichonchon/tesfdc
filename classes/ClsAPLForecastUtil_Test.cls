/**
*This is the test class to test ClsAPLForecastUtil.
*
*
@author Juillet Yuan
@created 2014-07-18
@version 1.0
@since 30.0
*
@changelog
* coverage  92%
*
2014-07-18 Juillet Yuan<juillet.yuan@itbconsult.com>
* - Created
*
2014-08-14 Lili Zhao<lili.zhao@itbconsult.com>
* - modify and add some method
*/
@isTest
private class ClsAPLForecastUtil_Test {
	
	static testMethod void newClassInstance_test() {
		Test.startTest();
		ClsAPLForecastUtil.newClassInstance('ClsAPLEntityTypes.RSMAcctFCInfo');
		Test.stopTest();
	}
	
	static testMethod void newRefDataInstance_test() {
		Test.startTest();
		ClsAPLForecastUtil.newRefDataInstance('ClsAPLEntityTypes.RSMAcctFCInfo');
		Test.stopTest();
	}
	
	static testMethod void newCtrlInstance_test() {
		Test.startTest();
		ClsAPLForecastUtil.newCtrlInstance('ClsAPLServiceRSMRelay');
		Test.stopTest();
	}
	
	static testMethod void setUserLocale_test(){
		Test.startTest();
		ClsAPLForecastUtil.setUserLocale((new ClsAPLEntityTypes.LocaleConfig('cn_CN',' ')), 'cn_CN');
		Test.stopTest();
	}
	
	static testMethod void getQueryString_test() {
		String[] arr = new String[3];
		arr[0] = 'id';
		arr[1] = 'opportunity';
		arr[2] = 'a';
		Test.startTest();
		ClsAPLForecastUtil.getQueryString(arr);
		Test.stopTest();
	}
	
	static testMethod void transformIsoCode_test(){
		Test.startTest();
		ClsAPLForecastUtil.transformIsoCode(0.1, 'CN', 'GE');
		ClsAPLForecastUtil.transformIsoCode(null, 'CN', 'GE');
		Test.stopTest();
	}
	
	static testMethod void setAllPeriodStartEndDate_test(){
		map<String, Date> map_financialDate =  new map<String, Date>();
		map_financialDate.put('s',system.today()-30);
		map_financialDate.put('e',system.today());
		Test.startTest();
		ClsAPLForecastUtil.setAllPeriodStartEndDate(map_financialDate);
		Test.stopTest();
	}
	
	static testMethod void setFiscalMonth_test(){
		Test.startTest();
		APL_Forecast_Settings__c setting1 = ClsTestHelp.createAPLSetting1();
        APL_Forecast_Settings__c setting2 = ClsTestHelp.createAPLSetting2();
        
		ClsAPLForecastUtil.setFiscalMonth(new ClsAPLEntityTypes.PageConfig());
		ClsAPLEntityTypes.PageConfig pageConf = new ClsAPLEntityTypes.PageConfig();
		pageConf.currentYear = '2014';
		pageConf.isSetupDone = true;
		ClsAPLForecastUtil.setFiscalMonth(pageConf);
		Test.stopTest();
	}
	
	static testMethod void setCurrentMonthIndex_test(){
		Test.startTest();
		ClsAPLEntityTypes.PageConfig pageConf = new ClsAPLEntityTypes.PageConfig();
		pageConf.currentYear = '2014';
		ClsAPLForecastUtil.setCurrentMonthIndex(pageConf);
		Test.stopTest();
	}
	
	static testMethod void createDateItem_test(){
		ClsAPLEntityTypes.PageConfig a = new ClsAPLEntityTypes.PageConfig();
		a.currentYear = '12';
		for(integer i=0;i<=15;i++){
			a.list_yearMonth.add('2014_06');	
		}
		
		ClsAPLEntityTypes.PageConfig PageConfig = new ClsAPLEntityTypes.PageConfig();
		PageConfig.currentYear = '12';
		PageConfig.currentMonthIndex = 10;
		for(integer i=0;i<=15;i++){
			PageConfig.list_yearMonth.add('2014_06');	
		}
		
		Test.startTest();
		ClsAPLForecastUtil.createDateItem(a,new list<ClsAPLEntityTypes.DateItem>());
		ClsAPLForecastUtil.createDateItem(PageConfig, new list<ClsAPLEntityTypes.DateItem>());
		Test.stopTest();
	}
	
	static testMethod void getMonthFilter_test(){
		Test.startTest();
		map<String, Set<String>> map_year_quarter = new map<String, Set<String>>();
		ClsAPLForecastUtil.getMonthFilter(map_year_quarter);
		set<string> set_quanter = new set<string>{'1','2','3','4'};
		map_year_quarter.put('2011',set_quanter);
		
		ClsAPLForecastUtil.getMonthFilter(map_year_quarter);
		Test.stopTest();
	}
	
	static testMethod void getCustomRequestMonthFilter_test(){
		map<String, Set<Integer>> map_year_month = new map<String, Set<Integer>>();
		set<Integer> set_month = new set<Integer>{1,2,3,4};
		map_year_month.put('2011',set_month);
		Test.startTest();
		ClsAPLForecastUtil.getCustomRequestMonthFilter(map_year_month);
		Test.stopTest();
	}
	
	static testMethod void getFiscalMonthMap_test(){
		list<String> list_dateKey = new list<String>();
		list_dateKey.add('2011_05');
		Test.startTest();
		ClsAPLForecastUtil.getFiscalMonthMap(list_dateKey);
		Test.stopTest();
	}
	
	static testMethod void getFiscalMonthFilter_test(){
		Test.startTest();
		map<String, Set<Integer>> map_year_month = new map<String, Set<Integer>>();
		ClsAPLForecastUtil.getFiscalMonthFilter(map_year_month);
		set<Integer> set_month = new set<Integer>{1,2,3,4};
		map_year_month.put('2011',set_month);
		
		ClsAPLForecastUtil.getFiscalMonthFilter(map_year_month);
		Test.stopTest();
	}
	
	static testMethod void aplFCRecordsDML_test(){
		list<APL_Sales_Forecast__c> list_acctFC2Insert = new list<APL_Sales_Forecast__c>();
		list<APL_Sales_Forecast__c> list_acctFC2Update = new list<APL_Sales_Forecast__c>();
		list<APL_Sales_Forecast__c> list_acctFC2Delete = new list<APL_Sales_Forecast__c>();
		
		
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
    	
    	Consumer_Device_Opportunity_Record_Types__c cdort1 = ClsTestHelp.createTestCSD1();
    	Consumer_Device_Opportunity_Record_Types__c cdort2 = ClsTestHelp.createTestCSD2();
    	Consumer_Device_Opportunity_Record_Types__c cdort3 = ClsTestHelp.createTestCSD3();
    	Consumer_Device_Opportunity_Record_Types__c cdort4 = ClsTestHelp.createTestCSD4();
    	Consumer_Device_Opportunity_Record_Types__c cdort5 = ClsTestHelp.createTestCSD5();
    	Consumer_Device_Opportunity_Record_Types__c cdort6 = ClsTestHelp.createTestCSD6();
    	Consumer_Device_Opportunity_Record_Types__c cdort7 = ClsTestHelp.createTestCSD7();
    	
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
    	acct.STATDESC__c = 'active';
    	acct.Account_Manager__c = userInfo.getUserId();
    	insert acct;

		
		APL_Sales_Forecast__c aplFC1 = new APL_Sales_Forecast__c();
		aplFC1.type__c = 'GPL';
		aplFC1.customer__c = acct.Id;
		list_acctFC2Insert.add(aplFC1);

		APL_Sales_Forecast__c aplFC2 = new APL_Sales_Forecast__c();
		aplFC2.type__c = 'GPL';
		aplFC2.customer__c = acct.Id;
		insert aplFC2;
		aplFC2.Type__c = 'Part';
		list_acctFC2Update.add(aplFC2);	
		
		APL_Sales_Forecast__c aplFC3 = new APL_Sales_Forecast__c();
		aplFC3.type__c = 'GPL';
		aplFC3.customer__c = acct.Id;
		insert aplFC3;
		list_acctFC2Delete.add(aplFC3);
		
		APL_Sales_Forecast__c apl = new APL_Sales_Forecast__c();
		apl.Fiscal_Quarter__c = '01';
		apl.Fiscal_Year__c = '2015';
		apl.Forecast__c = 100;
		apl.customer__c = acct.Id;
		insert apl;
		
		APL_Sales_Forecast__c apl1 = new APL_Sales_Forecast__c();
		apl1.Fiscal_Quarter__c = '02';
		apl1.Fiscal_Year__c = '2015';
		apl1.Forecast__c = 100;
		apl1.customer__c = acct.Id;
		insert apl1;
		
		APL_Sales_Forecast__c apl2 = new APL_Sales_Forecast__c();
		apl2.Fiscal_Quarter__c = '03';
		apl2.Fiscal_Year__c = '2015';
		apl2.Forecast__c = 100;
		apl2.customer__c = acct.Id;
		insert apl2;
		
		
		APL_Sales_Forecast__c apl3 = new APL_Sales_Forecast__c();
		apl3.Fiscal_Quarter__c = '01';
		apl3.Fiscal_Year__c = '2016';
		apl3.Forecast__c = 100;
		apl3.customer__c = acct.Id;
		insert apl3;
		
		APL_Sales_Forecast__c apl4 = new APL_Sales_Forecast__c();
		apl4.Fiscal_Quarter__c = '02';
		apl4.Fiscal_Year__c = '2016';
		apl4.Forecast__c = 100;
		apl4.customer__c = acct.Id;
		insert apl4;
		
		APL_Sales_Forecast__c apl5 = new APL_Sales_Forecast__c();
		apl5.Fiscal_Quarter__c = '01';
		apl5.Fiscal_Year__c = '2015';
		apl5.Forecast__c = 100;
		apl5.Type__c = 'Relay';
		apl5.customer__c = acct.Id;
		insert apl5;
		
		APL_Sales_Forecast__c apl6 = new APL_Sales_Forecast__c();
		apl6.Fiscal_Quarter__c = '02';
		apl6.Fiscal_Year__c = '2015';
		apl6.Forecast__c = 100;
		apl6.Type__c = 'Relay';
		apl6.customer__c = acct.Id;
		insert apl6;
		
		APL_Sales_Forecast__c apl7 = new APL_Sales_Forecast__c();
		apl7.Fiscal_Quarter__c = '03';
		apl7.Fiscal_Year__c = '2015';
		apl7.Forecast__c = 100;
		apl7.customer__c = acct.Id;
		apl7.Type__c = 'Relay';
		insert apl7;
		
		
		APL_Sales_Forecast__c apl8 = new APL_Sales_Forecast__c();
		apl8.Fiscal_Quarter__c = '01';
		apl8.Fiscal_Year__c = '2016';
		apl8.Forecast__c = 100;
		apl8.Type__c = 'Relay';
		apl8.customer__c = acct.Id;
		insert apl8;
		
		APL_Sales_Forecast__c apl9 = new APL_Sales_Forecast__c();
		apl9.Fiscal_Quarter__c = '02';
		apl9.Fiscal_Year__c = '2016';
		apl9.Forecast__c = 100;
		apl9.Type__c = 'Relay';
		apl9.customer__c = acct.Id;
		insert apl9;
		
		
		
		list<APL_Sales_Forecast__c> list_apls = new list<APL_Sales_Forecast__c>();
		list_apls.add(apl);
		list_apls.add(apl1);
		list_apls.add(apl2);
		list_apls.add(apl3);
		list_apls.add(apl4);
		
		APL_Sales_Forecast__c apl10 = new APL_Sales_Forecast__c();
		map<String, map<String, APL_Sales_Forecast__c>> map_acctId_map_dateKey_fc = new map<String, map<String, APL_Sales_Forecast__c>>();
		map_acctId_map_dateKey_fc.put(acct.Id, new map<String, APL_Sales_Forecast__c>());
		map_acctId_map_dateKey_fc.get(acct.Id).put('2014_01', apl10);
		map<String, decimal> map_acctId_billingPercent = new map<String, decimal>();
		map_acctId_billingPercent.put(acct.Id, 0.1);
		//map_acctId_billingPercent.put('test2', 0.1);
		map<String, decimal> map_dateKey_fc = new map<String, decimal>();
		map_dateKey_fc.put('2014_01', 100);
		map_dateKey_fc.put('2014_02', 100);
		
		set<String> set_dateKeys = new set<String>();
		set_dateKeys.add('2015_02');
		set_dateKeys.add('2015_03');
		set_dateKeys.add('2016_02');
		set_dateKeys.add('2016_03');
		
		Test.startTest();
		ClsAPLForecastUtil.generateFC(map_acctId_billingPercent, map_dateKey_fc,
										map_acctId_map_dateKey_fc, 
										'fctype', '','partId', 'currencyIso', 
										true,true,true,
										new list<APL_Sales_Forecast__c>(),
										new list<APL_Sales_Forecast__c>(), 
										new list<APL_Sales_Forecast__c>());
		
		ClsAPLForecastUtil.generateFC(new map<String, decimal>(), new map<String, decimal>(),
										new map<String, map<String, APL_Sales_Forecast__c>>(), 
										'fctype', '','partId', 'currencyIso', 
										true,true,true,
										new list<APL_Sales_Forecast__c>(),
										new list<APL_Sales_Forecast__c>(), 
										new list<APL_Sales_Forecast__c>());
		ClsAPLForecastUtil.calcAPLNextQuarterForecast(list_apls, '2016_03', '2016_04',
    											  '2016_02', '2015_03',set_dateKeys, '2015_02', '2015_04' );

		ClsAPLForecastUtil.aplFCRecordsDML(list_acctFC2Insert,list_acctFC2Update,list_acctFC2Delete);
		Test.stopTest();
	}
	
	static testMethod void calcPercentage_test(){
		Test.startTest();
		map<String, decimal> map_key_percent = new map<String, decimal>();
		ClsAPLForecastUtil.calcPercentage(map_key_percent, 10, true);
		map_key_percent.put('23',0.5);		
		ClsAPLForecastUtil.calcPercentage(map_key_percent, 10, true);
		ClsAPLForecastUtil.calcPercentage(map_key_percent, 10, false);
		Test.stopTest();
	}
	
	static testMethod void getCBCKeyName_test(){
		Test.startTest();
		ClsAPLForecastUtil.getCBCKeyName('53d5f','RAST');
		ClsAPLForecastUtil.getCBCKeyName('30012','30000');
		Test.stopTest();
	}
	
	static testMethod void setResultMap_test(){
		AggregateResult a;
		Test.startTest();
		ClsAPLForecastUtil.setResultMap(a, '12', '2014-01-01', new map<String, map<String, AggregateResult>>());
		Test.stopTest();
	}
	
	static testMethod void getRelayGPLQuery_test(){
		Test.startTest();
		ClsAPLForecastUtil.getRelayGPLQuery(true);
		Test.stopTest();
	}
	
	static testMethod void getRelayPartQuery_test(){
		Test.startTest();
		ClsAPLForecastUtil.getRelayPartQuery();
		Test.stopTest();
	}
	
	static testMethod void getNoneRelayPartQuery_test(){
		Test.startTest();
		ClsAPLForecastUtil.getNoneRelayPartQuery();
		Test.stopTest();
	}
	
	static testMethod void getOtherPartQuery_test(){
		Test.startTest();
		ClsAPLForecastUtil.getOtherPartQuery();
		Test.stopTest();
	}
	
	static testMethod void setGPLCode_test(){
		Product_Hierarchy__c prodH = new Product_Hierarchy__c();
        prodH.Name = 'A00';
        prodH.CBC2__c = '99999';
        prodH.CBC1_Description__c = 'Appliances';
        prodH.GPL_Description__c = 'test';
        insert prodH;
	        
		Test.startTest();
		ClsAPLForecastUtil.setGPLCode(new map<String, String>(), 'wont matter', new map<String, String>());
		ClsAPLForecastUtil.setGPLCode(new map<String, String>(), '99999', new map<String, String>());
		Test.stopTest();
	}	
	
	static testMethod void getChildrenAccts_test(){
		Test.startTest();
		ClsAPLForecastUtil.getChildrenAccts('001c000000ZTFX5AAP', 'CN' , new set<String>(), true);
		Test.stopTest();
	}
	
	static testMethod void getStartDate_test(){
		Test.startTest();
		ClsAPLForecastUtil.getStartDate('2014_06');
		Test.stopTest();
	}
	
	static testMethod void getEndDate_test(){
		Test.startTest();
		ClsAPLForecastUtil.getEndDate('2014_06');
		Test.stopTest();
	}
	
	static testMethod void getDividedFiscalMap_test(){
		Date currentDate = system.today();
		Integer year = currentDate.year();
		Integer month = currentDate.month();
		String divideDate = String.valueOf(year + 1) + '_' + String.valueOf(month);
		list<String> list_dateKey = new list<String>();
		list_dateKey.add('2014_06');
		list_dateKey.add(divideDate);
		Test.startTest();
		ClsAPLForecastUtil.getDividedFiscalMap(currentDate, list_dateKey, 
    											new map<String, set<Integer>>(), new map<String, set<Integer>>());
		Test.stopTest();
	}
	
	static testMethod void setAPLPrevFC_test(){
		
		APL_Sales_Forecast__c apl = new APL_Sales_Forecast__c();
		apl.Fiscal_Quarter__c = '04';
		apl.Fiscal_Year__c = '2014';
		//insert apl;
		list<APL_Sales_Forecast__c> list_apls = new list<APL_Sales_Forecast__c>();
		list_apls.add(apl);
		
		Test.startTest();
		ClsAPLForecastUtil.setAPLPrevFC(list_apls, '2014', 2);
		ClsAPLForecastUtil.setAPLPrevFC(list_apls, '2013', 2);
		ClsAPLForecastUtil.setAPLPrevFC(list_apls, '2012', 2);
		Test.stopTest();
	}
	
	static testMethod void setAPLRSMOverallPrevFC(){
		
		APL_RSM__c aplRsm = new APL_RSM__c();
		aplRsm.Manager__c = userInfo.getUserId();
		insert aplRsm;
		APL_RSM_Overall_Forecast__c apl = new APL_RSM_Overall_Forecast__c();
		apl.Fiscal_Quarter__c = '04';
		apl.Fiscal_Year__c = '2014';
		apl.APL_RSM__c = aplRsm.Id;
		insert apl;
		list<APL_RSM_Overall_Forecast__c> list_apls = new list<APL_RSM_Overall_Forecast__c>();
		list_apls.add(apl);
		
		Test.startTest();
		ClsAPLForecastUtil.setAPLRSMOverallPrevFC(list_apls, '2014', 2);
		ClsAPLForecastUtil.setAPLRSMOverallPrevFC(list_apls, '2013', 2);
		ClsAPLForecastUtil.setAPLRSMOverallPrevFC(list_apls, '2012', 2);
		Test.stopTest();
	}
	
}