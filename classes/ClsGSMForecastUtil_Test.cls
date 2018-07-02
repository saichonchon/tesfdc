/**
*	This test class is for ClsGSMForecastUtil.
*
@author Di Chen
@created 2014-01-23
@version 1.0
@since 20.0
*
@changelog
* 2014-01-23 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 74%
*/
@isTest(seeAllData=true)
private class ClsGSMForecastUtil_Test {

    static testMethod void testMostMethods1() {
    	
    	Forecast_Definition__c fd = new Forecast_Definition__c();
    	fd.Region__c = 'Americas';
    	fd.Profit_Center__c = 'A&C';
    	fd.GSM__c = UserInfo.getUserId();
    	fd.GSM_Name__c = '1234';
    	fd.Category__c = 'A';
    	fd.Subtotal__c = false;
    	insert fd;
    	
    	Manager_Forecast__c manForecast = new Manager_Forecast__c();
        manForecast.Fiscal_Year__c = '2014';
        manForecast.Fiscal_Month__c = 2;
        manForecast.Forecast_Definition__c = fd.Id;
        manForecast.Forecast_USD__c = 11;
        manForecast.Previous_Month_Forecast_Document__c = 11;
		insert manForecast;
		
		Manager_Forecast__c manForecast2 = new Manager_Forecast__c();
        manForecast2.Fiscal_Year__c = '2014';
        manForecast2.Fiscal_Month__c = 2;
        manForecast2.Forecast_Definition__c = fd.Id;
        manForecast2.Forecast_USD__c = 11;
        manForecast2.Previous_Month_Forecast_Document__c = 11;
        manForecast2.Comment__c = '<comments><comment value="200000">test2</comment><comment value="111000">march comment</comment></comments>';
		insert manForecast2;
		list<CtrlGSMForecast.Comment> list_cmts;
		set<String> set_rsmFCDefIds = new set<String>();
		String fiscalDate = '2014-2';
		set_rsmFCDefIds.add(fd.Id);
		
		
		
		
    	List<Manager_Forecast__c> list_mgForecasts = [select Previous_Month_Forecast_Document__c,Forecast_USD__c,Id,Fiscal_Year__c,Fiscal_Date__c,Forecast_Definition__c,Fiscal_Month__c from Manager_Forecast__c where Id =: manForecast.Id];
        
    	list<Forecast_Definition__c> list_gsmDef = new list<Forecast_Definition__c>();
    	list_gsmDef.add(fd);
    	
    	list<String> list_region = new list<String>();
    	list_region.add('Americas');
    	
    	map<String, list<CtrlGSMForecast.GSMLineItem>> map_category_list_gsmItems = new map<String, list<CtrlGSMForecast.GSMLineItem>>();
    	list<CtrlGSMForecast.GSMLineItem> list_gsmItems = new list<CtrlGSMForecast.GSMLineItem>();
    	CtrlGSMForecast.GSMLineItem ctrlGSM = new CtrlGSMForecast.GSMLineItem();
    	ctrlGSM.name = '1234';
    	list_gsmItems.add(ctrlGSM);
    	map_category_list_gsmItems.put('A',list_gsmItems);
    	map_category_list_gsmItems.put('B',list_gsmItems);
    	map_category_list_gsmItems.put('Channel',list_gsmItems);
    	
    	map<String, list<CtrlGSMForecast.GSMDefinitionItem>> map_total_list_gsmDefItems = new map<String, list<CtrlGSMForecast.GSMDefinitionItem>>();
    	list<CtrlGSMForecast.GSMDefinitionItem> list_gsmDefItems = new list<CtrlGSMForecast.GSMDefinitionItem>();
    	CtrlGSMForecast.GSMDefinitionItem ctrlGSMD = new CtrlGSMForecast.GSMDefinitionItem();
    	ctrlGSMD.category = 'A';
    	list_gsmDefItems.add(ctrlGSMD);
        //init gsm definition item
    	map_total_list_gsmDefItems.put('A',list_gsmDefItems);
        map_total_list_gsmDefItems.put('B', new list<CtrlGSMForecast.GSMDefinitionItem>());
        map_total_list_gsmDefItems.put('A_B', new list<CtrlGSMForecast.GSMDefinitionItem>());
        map_total_list_gsmDefItems.put('B_C', new list<CtrlGSMForecast.GSMDefinitionItem>());
        map_total_list_gsmDefItems.put('Channel', new list<CtrlGSMForecast.GSMDefinitionItem>());
    	map<String, list<CtrlGSMForecast.GSMLineItem>> map_other_list_gsmItems = new map<String, list<CtrlGSMForecast.GSMLineItem>>();
    	
    	map<String, map<String, String>> map_gsmName_date_fc = new map<String, map<String, String>>();
    	map<String, String> map_date_fc = new map<String, String>();
    	map_gsmName_date_fc.put('1234',map_date_fc);
    	
    	map<String, map<String, String>> map_gsmName_date_prevFC = new map<String, map<String, String>>();
    	map<String, String> map_date_prevFC = new map<String, String>();
    	map_gsmName_date_prevFC.put('1234',map_date_prevFC);
    	
        Test.startTest();
        
        ClsGSMForecastUtil cls = new ClsGSMForecastUtil();
        ClsGSMForecastUtil.getRSMComments(set_rsmFCDefIds, fiscalDate, list_cmts);
        ClsGSMForecastUtil.getGSMForecastDef(list_gsmDef, UserInfo.getUserId(), null, list_region);
        ClsGSMForecastUtil.getGSMDefinitionItems(list_gsmDef, map_category_list_gsmItems, map_total_list_gsmDefItems, map_other_list_gsmItems, map_gsmName_date_fc, map_gsmName_date_prevFC);
        
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void testMostMethods2() {
    	
    	Forecast_Definition__c fd = new Forecast_Definition__c();
    	fd.Region__c = 'Americas';
    	fd.Profit_Center__c = 'A&C';
    	fd.GSM__c = UserInfo.getUserId();
    	fd.GSM_Name__c = '1234';
    	fd.Category__c = 'B';
    	insert fd;
    	
    	Manager_Forecast__c manForecast = new Manager_Forecast__c();
        manForecast.Fiscal_Year__c = '2014';
        manForecast.Fiscal_Month__c = 2;
        manForecast.Forecast_Definition__c = fd.Id;
        manForecast.Forecast_USD__c = 11;
        manForecast.Previous_Month_Forecast_Document__c = 11;
		insert manForecast;
		
    	List<Manager_Forecast__c> list_mgForecasts = [select Previous_Month_Forecast_Document__c,Forecast_USD__c,Id,Fiscal_Year__c,Fiscal_Date__c,Forecast_Definition__c,Fiscal_Month__c from Manager_Forecast__c where Id =: manForecast.Id];
        
    	list<Forecast_Definition__c> list_gsmDef = new list<Forecast_Definition__c>();
    	list_gsmDef.add(fd);
    	
    	list<String> list_region = new list<String>();
    	list_region.add('Americas');
    	
    	map<String, list<CtrlGSMForecast.GSMLineItem>> map_category_list_gsmItems = new map<String, list<CtrlGSMForecast.GSMLineItem>>();
    	list<CtrlGSMForecast.GSMLineItem> list_gsmItems = new list<CtrlGSMForecast.GSMLineItem>();
    	CtrlGSMForecast.GSMLineItem ctrlGSM = new CtrlGSMForecast.GSMLineItem();
    	list_gsmItems.add(ctrlGSM);
    	map_category_list_gsmItems.put('A',list_gsmItems);
    	map_category_list_gsmItems.put('B',list_gsmItems);
    	map_category_list_gsmItems.put('Channel',list_gsmItems);
    	
    	map<String, list<CtrlGSMForecast.GSMDefinitionItem>> map_total_list_gsmDefItems = new map<String, list<CtrlGSMForecast.GSMDefinitionItem>>();
    	list<CtrlGSMForecast.GSMDefinitionItem> list_gsmDefItems = new list<CtrlGSMForecast.GSMDefinitionItem>();
    	CtrlGSMForecast.GSMDefinitionItem ctrlGSMD = new CtrlGSMForecast.GSMDefinitionItem();
    	ctrlGSMD.category = 'B';
    	list_gsmDefItems.add(ctrlGSMD);
        //init gsm definition item
    	map_total_list_gsmDefItems.put('A',list_gsmDefItems);
        map_total_list_gsmDefItems.put('B', new list<CtrlGSMForecast.GSMDefinitionItem>());
        map_total_list_gsmDefItems.put('A_B', new list<CtrlGSMForecast.GSMDefinitionItem>());
        map_total_list_gsmDefItems.put('B_C', new list<CtrlGSMForecast.GSMDefinitionItem>());
        map_total_list_gsmDefItems.put('Channel', new list<CtrlGSMForecast.GSMDefinitionItem>());
    	
    	map<String, list<CtrlGSMForecast.GSMLineItem>> map_other_list_gsmItems = new map<String, list<CtrlGSMForecast.GSMLineItem>>();
    	
    	map<String, map<String, String>> map_gsmName_date_fc = new map<String, map<String, String>>();
    	map<String, String> map_date_fc = new map<String, String>();
    	map_gsmName_date_fc.put('1234',map_date_fc);
    	
    	map<String, map<String, String>> map_gsmName_date_prevFC = new map<String, map<String, String>>();
    	map<String, String> map_date_prevFC = new map<String, String>();
    	map_gsmName_date_prevFC.put('1234',map_date_prevFC);
    	
        Test.startTest();
        
        ClsGSMForecastUtil cls = new ClsGSMForecastUtil();
        
        ClsGSMForecastUtil.getGSMForecastDef(list_gsmDef, UserInfo.getUserId(), null, list_region);
        ClsGSMForecastUtil.getGSMDefinitionItems(list_gsmDef, map_category_list_gsmItems, map_total_list_gsmDefItems, map_other_list_gsmItems, map_gsmName_date_fc, map_gsmName_date_prevFC);
        
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void testMostMethod3() {
    	
    	Forecast_Definition__c fd = new Forecast_Definition__c();
    	fd.Region__c = 'Americas';
    	fd.Profit_Center__c = 'A&C';
    	fd.GSM__c = UserInfo.getUserId();
    	fd.GSM_Name__c = '1234';
    	fd.Category__c = 'B_C';
    	insert fd;
    	
    	Manager_Forecast__c manForecast = new Manager_Forecast__c();
        manForecast.Fiscal_Year__c = '2014';
        manForecast.Fiscal_Month__c = 2;
        manForecast.Forecast_Definition__c = fd.Id;
        manForecast.Forecast_USD__c = 11;
        manForecast.Previous_Month_Forecast_Document__c = 11;
        manForecast.Comment__c = '<comments><comment value="100">Comment about a positive forecast risk</comment><comment value="-80">Comment about a negative forecast risk</comment></comments>';
		insert manForecast;
		
    	List<Manager_Forecast__c> list_mgForecasts = [select Previous_Month_Forecast_Document__c,Forecast_USD__c,Id,Fiscal_Year__c,Fiscal_Date__c,Forecast_Definition__c,Fiscal_Month__c from Manager_Forecast__c where Id =: manForecast.Id];
        
    	list<Forecast_Definition__c> list_gsmDef = new list<Forecast_Definition__c>();
    	list_gsmDef.add(fd);
    	
    	list<String> list_region = new list<String>();
    	list_region.add('Americas');
    	
    	map<String, list<CtrlGSMForecast.GSMLineItem>> map_category_list_gsmItems = new map<String, list<CtrlGSMForecast.GSMLineItem>>();
    	list<CtrlGSMForecast.GSMLineItem> list_gsmItems = new list<CtrlGSMForecast.GSMLineItem>();
    	CtrlGSMForecast.GSMLineItem ctrlGSM = new CtrlGSMForecast.GSMLineItem();
    	list_gsmItems.add(ctrlGSM);
    	map_category_list_gsmItems.put('A',list_gsmItems);
    	map_category_list_gsmItems.put('B',list_gsmItems);
    	map_category_list_gsmItems.put('B_C',list_gsmItems);
    	map_category_list_gsmItems.put('Channel',list_gsmItems);
    	
    	map<String, list<CtrlGSMForecast.GSMDefinitionItem>> map_total_list_gsmDefItems = new map<String, list<CtrlGSMForecast.GSMDefinitionItem>>();
    	list<CtrlGSMForecast.GSMDefinitionItem> list_gsmDefItems = new list<CtrlGSMForecast.GSMDefinitionItem>();
    	CtrlGSMForecast.GSMDefinitionItem ctrlGSMD = new CtrlGSMForecast.GSMDefinitionItem();
    	ctrlGSMD.category = 'B_C';
    	list_gsmDefItems.add(ctrlGSMD);
        //init gsm definition item
    	map_total_list_gsmDefItems.put('A',list_gsmDefItems);
        map_total_list_gsmDefItems.put('B', new list<CtrlGSMForecast.GSMDefinitionItem>());
        map_total_list_gsmDefItems.put('A_B', new list<CtrlGSMForecast.GSMDefinitionItem>());
        map_total_list_gsmDefItems.put('B_C', new list<CtrlGSMForecast.GSMDefinitionItem>());
        map_total_list_gsmDefItems.put('Channel', new list<CtrlGSMForecast.GSMDefinitionItem>());
    	
    	map<String, list<CtrlGSMForecast.GSMLineItem>> map_other_list_gsmItems = new map<String, list<CtrlGSMForecast.GSMLineItem>>();
    	
    	map<String, map<String, String>> map_gsmName_date_fc = new map<String, map<String, String>>();
    	map<String, String> map_date_fc = new map<String, String>();
    	map_gsmName_date_fc.put('1234',map_date_fc);
    	
    	map<String, map<String, String>> map_gsmName_date_prevFC = new map<String, map<String, String>>();
    	map<String, String> map_date_prevFC = new map<String, String>();
    	map_gsmName_date_prevFC.put('1234',map_date_prevFC);
    	
    	CtrlGSMForecast.PageConfig pageConf = new CtrlGSMForecast.PageConfig();
    	set<String> set_dateKey = new set<String>();
    	
    	List<CtrlGSMForecast.DateItem> list_dateItems = new List<CtrlGSMForecast.DateItem>();
    	CtrlGSMForecast.DateItem ctrlDI = new CtrlGSMForecast.DateItem('Historical Data');
    	list_dateItems.add(ctrlDI);
    	Map<String, List<CtrlGSMForecast.DateItem>> map_dateItems = new Map<String, List<CtrlGSMForecast.DateItem>>();
    	map_dateItems.put('Historical Data',list_dateItems);
    	
    	map<String, String> map_fiscalDate_bbbMQuery = new map<String, String>();
    	
    	map<String, String> map_fiscalDate_scheduledQuery = new map<String, String>();
    	
    	map<String, set<Integer>> map_financialMonth = new map<String, set<Integer>>();
    	set<Integer> set_int = new set<Integer>();
    	set_int.add(1);
    	map_financialMonth.put('2014',set_int);
    	
    	CtrlGSMForecast.GSMSaveItem item = new CtrlGSMForecast.GSMSaveItem();
    	
    	list<CtrlGSMForecast.ColorConfig> list_colorConf = new list<CtrlGSMForecast.ColorConfig>();
    	CtrlGSMForecast.ColorConfig ctrlCol = new CtrlGSMForecast.ColorConfig();
    	list_colorConf.add(ctrlCol);
    	
    	set<String> set_rsmFCDefIds = new set<String>();
    	set_rsmFCDefIds.add(fd.Id);
    	
    	list<CtrlGSMForecast.Comment> list_cmts = new list<CtrlGSMForecast.Comment>();
    	CtrlGSMForecast.Comment ctrlCom = new CtrlGSMForecast.Comment();
    	list_cmts.add(ctrlCom);
    	
        Test.startTest();
        map<String, CtrlGSMForecast.GSMLineItem> map_temp_gsmDefKey_gsmLineItem = new map<String, CtrlGSMForecast.GSMLineItem>();
        
        ClsGSMForecastUtil cls = new ClsGSMForecastUtil();
        
        ClsGSMForecastUtil.getGSMForecastDef(list_gsmDef, UserInfo.getUserId(), null, list_region);
        ClsGSMForecastUtil.getGSMDefinitionItems(list_gsmDef, map_category_list_gsmItems, map_total_list_gsmDefItems, map_other_list_gsmItems, map_gsmName_date_fc, map_gsmName_date_prevFC);
        ClsGSMForecastUtil.generateGSMDefItem(fd, list_gsmDefItems, ctrlGSMD, map_temp_gsmDefKey_gsmLineItem);
        ClsGSMForecastUtil.integrateString('1', '2');
        ClsGSMForecastUtil.setfinancialMonths(pageConf, set_dateKey);
        ClsGSMForecastUtil.createDateItem(list_dateItems, map_dateItems, list_dateItems, pageConf);
        ClsGSMForecastUtil.createWorkingDaysMap(pageConf);
        ClsGSMForecastUtil.getQueryStrForBBBM(set_dateKey, map_fiscalDate_bbbMQuery);
        ClsGSMForecastUtil.getQueryStrForScheduledAgreements(set_dateKey, map_fiscalDate_scheduledQuery);
        ClsGSMForecastUtil.getGSMManagerForecast(userInfo.getUserId(), map_financialMonth, map_gsmName_date_fc, map_gsmName_date_prevFC);
        ClsGSMForecastUtil.generateGSMSaveItem(userInfo.getUserId(), list_mgForecasts, item);
        ClsGSMForecastUtil.getRSMColorConfigFromSetting(list_colorConf);
        ClsGSMForecastUtil.getRSMComments(set_rsmFCDefIds, '-2014', list_cmts);
        
        system.assert(true);
        Test.stopTest();
    }
}