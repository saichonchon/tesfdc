/**.
 *  This test class is used to test APL_ClsAMForecastbyProductService
 *  
 * @author Lei Tang
 * @created 2015-07-22
 * @version 1.0
 * @since 33.0 (Force.com ApiVersion)  
 * 
 *
 * @changeloga
 * 2015-06-12 Lei Tang <lei.tang@itbconsult.com>
 * - Created
 *
 * coverage 73%
 */
@isTest
private class APL_ClsAMForecastbyProductService_Test {

	static testMethod void myUnitTest() {
		
		ClsTestHelp.initAPLTestData();
        
        RecordType rt2 = ClsTestHelp.createTestRecordType8();
        
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
    	acct.APL_AM_Display_Name__c = 'amTestName';
    	acct.Account_Manager__c = userInfo.getUserId();
    	acct.STATDESC__c = 'Active';
    	acct.SALES_TERRITORY_CDE__c = '123456';
    	acct.Relay_Specialist_Territory_Code__c = '123456';   
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
    	insert relayAcct;
    	
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
    	insert relayAcct1;
    	
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
    	insert amAcct;
    	
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
    	
    	APL_Sales_Forecast__c aplFC1 = new APL_Sales_Forecast__c();
		aplFC1.type__c = 'GPL';
		aplFC1.Fiscal_Year__c = '2015';
		aplFC1.Fiscal_Quarter__c = '04';
		aplFC1.customer__c = amAcct.Id;
		aplFC1.RSM_Forecast__c = 10;
		aplFC1.GPL__c = ph.Id;
		aplFC1.Part__c = part.Id;
		insert aplFC1;
		
		APL_Sales_Forecast__c aplFC4 = new APL_Sales_Forecast__c();
		aplFC4.type__c = 'Part';
		aplFC4.Fiscal_Year__c = '2015';
		aplFC4.Fiscal_Quarter__c = '04';
		aplFC4.customer__c = amAcct.Id;
		aplFC4.RSM_Forecast__c = 10;
		aplFC4.GPL__c = ph.Id;
		aplFC4.Part__c = part.Id;
		insert aplFC4;
		
		APL_Sales_Forecast__c aplFC3 = new APL_Sales_Forecast__c();
		aplFC3.type__c = 'Relay Product Code';
		aplFC3.Fiscal_Year__c = '2015';
		aplFC3.Fiscal_Quarter__c = '04';
		aplFC3.customer__c = relayAcct.Id;
		aplFC3.PRODUCT_CDE__c = part1.PRODUCT_CDE__c;
		aplFC3.PROD_NAME__c = part1.PROD_NAME__c;
		aplFC3.Relay_CBC2_Code__c = ph1.CBC2__c;
		aplFC3.RSM_Forecast__c = 10;
		insert aplFC3;
		
		
		APL_Sales_Forecast__c aplFC2 = new APL_Sales_Forecast__c();
		aplFC2.type__c = 'Relay';
		aplFC2.Fiscal_Year__c = '2015';
		aplFC2.Fiscal_Quarter__c = '04';
		aplFC2.customer__c = relayAcct.Id;
		aplFC2.Part__c = part1.Id;
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
    	apl1.A6_Code__c = '123456';
    	apl1.GAM_Code__c = '1234';
    	apl1.Manager__c = userInfo.getUserId();
    	apl1.RecordTypeId = rt25.Id;
    	apl1.RSM__c = aplRsm1.Id;
    	insert apl1;
    	
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
		
		Test.startTest();
		
		APL_CtrlForecastbyProduct ctrl = new APL_CtrlForecastbyProduct();
		ctrl.selectedType = APL_ClsUtils.MAP_RSMMANAGERLABEL.get('AM');
		ctrl.setRSMType();
		ctrl.searchGroupsAccounts();
        ctrl.initRSM();
		
		APL_ClsAMForecastbyProductService rsmservice = new APL_ClsAMForecastbyProductService();
		list<APL_ClsEntityType.APLColumn> list_acctColumns = new list<APL_ClsEntityType.APLColumn>();
		rsmservice.setTotalRow(list_acctColumns, ctrl.pageConf);
		list<Object> list_data = new list<Object>();
		rsmservice.setOverRelayProductsForecast(list_data, ctrl.pageConf);
		
		list_data.clear();
		rsmservice.setLevel1Data(list_data, ctrl.pageConf);
		
		APL_ClsAMForecastbyProductService.SearchLevelTotal total = new APL_ClsAMForecastbyProductService.SearchLevelTotal();
        String jsonT1 = '{"managerId":"'+userInfo.getUserId()+'","map_year_quartersFuture":{"2015":["03","04"],"2016":["01","02","03","04"],"2017":["01"]}}';
        total.getExistResult(jsonT1);
		
		String jsonT2 = '{"managerId":"'+userInfo.getUserId()+'","type":"RelayProducts","set_fiscalMonth":["2015_8","2015_9","2015_7"]}';
		String jsonT3 = '{"managerId":"'+userInfo.getUserId()+'","type":"TCProducts","set_fiscalMonth":["2015_8","2015_9","2015_7"]}';
		total.getRefData(jsonT2);
		total.getRefData(jsonT3);
		total.getBacklogRefData(jsonT2);
		total.getBacklogRefData(jsonT3);
		
		APL_ClsAMForecastbyProductService.SearchLevel1 level1 = new APL_ClsAMForecastbyProductService.SearchLevel1();
		String json1 = '{"managerId":"'+userInfo.getUserId()+'","territoryCode":"'+APL_ClsUtils.OTHER+'","set_fiscalMonth":["2015_8","2015_9","2015_7"]}';
		level1.getRefData(json1);
		level1.getBacklogRefData(json1);
		
		APL_ClsAMForecastbyProductService.SearchLevel2 level2 = new APL_ClsAMForecastbyProductService.SearchLevel2();
		String json31 = '{"managerId":"'+userInfo.getUserId()+'","territoryCode":"'+APL_ClsUtils.OTHER+'","grouping":"'+acct.Id+'","map_year_quartersFuture":{"2015":["03","04"],"2016":["01","02","03","04"],"2017":["01"]}}';
        level2.getExistResult(json31);
		String json32 = '{"managerId":"'+userInfo.getUserId()+'","cbc2Code":"30012","territoryCode":"'+APL_ClsUtils.OTHER+'","grouping":"'+acct.Id+'","set_fiscalMonth":["2015_8","2015_9","2015_7"]}';
		level2.getRefData(json32);
		level2.getBacklogRefData(json32);
		
		
		APL_ClsAMForecastbyProductService.SearchLevel3 level3 = new APL_ClsAMForecastbyProductService.SearchLevel3();
		String json41 = '{"managerId":"'+userInfo.getUserId()+'","cbc2Code":"30012","territoryCode":"'+APL_ClsUtils.OTHER+'","grouping":"'+acct.Id+'","map_year_quartersFuture":{"2015":["03","04"],"2016":["01","02","03","04"],"2017":["01"]}}';
        level3.getExistResult(json41);
        String json44 = '{"managerId":"'+userInfo.getUserId()+'","cbc2Code":"Relay","territoryCode":"'+APL_ClsUtils.OTHER+'","grouping":"'+acct.Id+'","map_year_quartersFuture":{"2015":["03","04"],"2016":["01","02","03","04"],"2017":["01"]}}';
        level3.getExistResult(json44);
		String json42 = '{"managerId":"'+userInfo.getUserId()+'","cbc2Code":"30012","territoryCode":"'+APL_ClsUtils.OTHER+'","gplId":"'+ph.Id+'","grouping":"'+acct.Id+'","set_fiscalMonth":["2015_8","2015_9","2015_7"]}';
		level3.getRefData(json42);
		level3.getBacklogRefData(json42);
		String json43 = '{"managerId":"'+userInfo.getUserId()+'","cbc2Code":"Relay","territoryCode":"'+APL_ClsUtils.OTHER+'","accnumber":"30005","grouping":"'+acct.Id+'","set_fiscalMonth":["2015_8","2015_9","2015_7"]}';
		level3.getRefData(json43);
		level3.getBacklogRefData(json43);
		
		
		APL_ClsAMForecastbyProductService.SearchLevel4 level4 = new APL_ClsAMForecastbyProductService.SearchLevel4();
		String json51 = '{"managerId":"'+userInfo.getUserId()+'","cbc2Code":"30012","territoryCode":"'+APL_ClsUtils.OTHER+'","gplId":"'+ph.Id+'","grouping":"'+acct.Id+'","map_year_quartersFuture":{"2015":["03","04"],"2016":["01","02","03","04"],"2017":["01"]}}';
        level4.getExistResult(json51);
        String json53 = '{"managerId":"'+userInfo.getUserId()+'","cbc2Code":"Relay","territoryCode":"'+APL_ClsUtils.OTHER+'","relayCode":"30005","grouping":"'+acct.Id+'","map_year_quartersFuture":{"2015":["03","04"],"2016":["01","02","03","04"],"2017":["01"]}}';
        level4.getExistResult(json53);
		String json52 = '{"managerId":"'+userInfo.getUserId()+'","cbc2Code":"30012","territoryCode":"'+APL_ClsUtils.OTHER+'","partId":"'+part.Id+'","set_fiscalMonth":["2015_8","2015_9","2015_7"]}';
		level4.getRefData(json52);
		level4.getBacklogRefData(json52);
		String json54 = '{"managerId":"'+userInfo.getUserId()+'","cbc2Code":"Relay","accnumber":"'+part1.PRODUCT_CDE__c+'","territoryCode":"'+APL_ClsUtils.OTHER+'","relayCode":"30005","grouping":"'+acct.Id+'","set_fiscalMonth":["2015_8","2015_9","2015_7"]}';
		level4.getRefData(json54);
		level4.getBacklogRefData(json54);
		
		
		APL_ClsAMForecastbyProductService.SearchLevel5 level5 = new APL_ClsAMForecastbyProductService.SearchLevel5();
		String json61 = '{"managerId":"'+userInfo.getUserId()+'","territoryCode":"'+APL_ClsUtils.OTHER+'","cbc2Code":"Relay","accnumber":"30005","relayCode":"TEST12","grouping":"'+acct.Id+'","map_year_quartersFuture":{"2015":["03","04"],"2016":["01","02","03","04"],"2017":["01"]}}';
        level5.getExistResult(json61);
		String json62 = '{"managerId":"'+userInfo.getUserId()+'","territoryCode":"'+APL_ClsUtils.OTHER+'","cbc2Code":"Relay","relayCode":"30005","partId":"'+part1.Id+'","grouping":"'+acct.Id+'","set_fiscalMonth":["2015_8","2015_9","2015_7"]}';
		level5.getRefData(json62);
		level5.getBacklogRefData(json62);
		
		APL_ClsAMForecastbyProductService.SearchLevelOther levelother = new APL_ClsAMForecastbyProductService.SearchLevelOther();
		String json01 = '{"managerId":"'+userInfo.getUserId()+'","territoryCode":"'+APL_ClsUtils.OTHER+'","grouping":"'+acct.Id+'","map_year_quartersFuture":{"2015":["03","04"],"2016":["01","02","03","04"],"2017":["01"]}}';
        levelother.getExistResult(json01);
		String json02 = '{"managerId":"'+userInfo.getUserId()+'","accnumber":"45678","territoryCode":"'+APL_ClsUtils.OTHER+'","grouping":"'+acct.Id+'","set_fiscalMonth":["2015_8","2015_9","2015_7"]}';
		levelother.getRefData(json02);
		levelother.getBacklogRefData(json02);
		
		
		Test.stopTest();

        
	}

}