/**
 *  This test class is used to test APL_ClsRelayForecastbyProductService
 *  
 * @author Lei Tang
 * @created 2015-07-28
 * @version 1.0
 * @since 33.0 (Force.com ApiVersion)  
 * 
 *
 * @changeloga
 * 2015-07-28 Lei Tang <lei.tang@oinio.com>
 * - Created
 *
 * coverage 82%
 */
@isTest
private class APL_ClsRelayForecastbyProService_Test {

    static testMethod void myUnitTest() {
        
		ClsTestHelp.initAPLTestData();
        
        RecordType rt2 = ClsTestHelp.createTestRecordType8();
        
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
        sh.Level_2_Territory_Code__c = '103004';
        insert sh;
        
        list<Account> list_accounts = new list<Account>();
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
    	//insert relayAcct;
    	list_accounts.add(relayAcct);
    	
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
    	//insert relayAcct1;
    	list_accounts.add(relayAcct1);
    	
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
    	//insert amAcct;
    	list_accounts.add(amAcct);
    	
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
    	//insert amAcct1;
    	list_accounts.add(amAcct1);
    	insert list_accounts;
    	
    	list<Product_Hierarchy__c> list_phs = new list<Product_Hierarchy__c>();
    	
    	Product_Hierarchy__c ph = new Product_Hierarchy__c();
    	ph.Name = '123';
    	ph.CBC2__c = '30012';
    	ph.CBC3__c = '30033';
    	ph.CBC1_Description__c = 'Appliances';
        //insert ph;
        list_phs.add(ph);
        
        Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
    	ph1.Name = '1234';
    	ph1.CBC2__c = '13213';
    	ph1.CBC3__c = '30033';
    	ph1.CBC1_Description__c = 'Appliances';
        //insert ph1;
        list_phs.add(ph1);
        
        Product_Hierarchy__c ph2 = new Product_Hierarchy__c();
    	ph2.Name = '1234';
    	ph2.CBC1__c = '45678';
    	ph2.CBC2__c = '13213';
    	ph2.CBC3__c = '30033';
    	ph2.CBC1_Description__c = 'Appliances';
        //insert ph2;
        list_phs.add(ph2);
        
        insert list_phs;
        
        list<Part__c> list_parts = new list<Part__c>();
        
        Part__c part = new Part__c();
        part.Name = 'testPart';
        part.GPL__c = ph.Id;
        part.Product_Hierarchy__c = ph.Id; 
        part.Description__c = 'test';
        part.PRODUCT_CDE__c = 'TEST1';
        part.PROD_NAME__c = 'test name1';
        //insert part;
        list_parts.add(part);
        
        Part__c part1 = new Part__c();
        part1.Name = 'testPart';
        part1.GPL__c = ph1.Id;
        part1.Product_Hierarchy__c = ph1.Id; 
        part1.Description__c = 'test';
        part1.PRODUCT_CDE__c = 'TEST2';
        part1.PROD_NAME__c = 'test name2';
        //insert part1;
        list_parts.add(part1);
        
        Part__c part2 = new Part__c();
        part2.Name = 'testPart';
        part2.GPL__c = ph2.Id;
        part2.Product_Hierarchy__c = ph2.Id; 
        part2.Description__c = 'test';
        part2.PRODUCT_CDE__c = 'TEST3';
        part2.PROD_NAME__c = 'test name3';
        //insert part2;
    	list_parts.add(part2);
    	insert list_parts;
    	
    	list<APL_Sales_Forecast__c> list_sfs = new list<APL_Sales_Forecast__c>();
    	
    	APL_Sales_Forecast__c aplFC1 = new APL_Sales_Forecast__c();
		aplFC1.type__c = 'GPL';
		aplFC1.Fiscal_Year__c = '2015';
		aplFC1.Fiscal_Quarter__c = '04';
		aplFC1.customer__c = amAcct.Id;
		aplFC1.RSM_Forecast__c = 10;
		aplFC1.GPL__c = ph.Id;
		aplFC1.Part__c = part.Id;
		//insert aplFC1;
		list_sfs.add(aplFC1);
		
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
		list_sfs.add(aplFC3);
		
		APL_Sales_Forecast__c aplFC2 = new APL_Sales_Forecast__c();
		aplFC2.type__c = 'Relay';
		aplFC2.Fiscal_Year__c = '2015';
		aplFC2.Fiscal_Quarter__c = '04';
		aplFC2.customer__c = relayAcct.Id;
		aplFC2.Part__c = part1.Id;
		aplFC2.GPL__c = ph1.Id;
		aplFC2.RSM_Forecast__c = 10;
		//insert aplFC2;
		list_sfs.add(aplFC2);
		insert list_sfs;
		
		list<APL_RSM__c> list_rsms = new list<APL_RSM__c>();
		
		APL_RSM__c aplRsm = new APL_RSM__c();
		aplRsm.Manager__c = userInfo.getUserId();
		aplRsm.Display_Name__c = 'test';
		//insert aplRsm;
		list_rsms.add(aplRsm);
		
		APL_RSM__c aplRsm1 = new APL_RSM__c();
		aplRsm1.Manager__c = userInfo.getUserId();
		aplRsm1.Type__c = 'Relay';
		aplRsm1.Display_Name__c = 'test2';
		insert aplRsm1;
		//list_rsms.add(aplRsm1);
		insert list_rsms;
		
		APL_RSM__c aplRsm2 = new APL_RSM__c();
		aplRsm2.Manager__c = userInfo.getUserId();
		aplRsm2.Type__c = 'AM';
		aplRsm2.Display_Name__c = 'test1';
		aplRsm2.APL_RSM__c = aplRsm1.Id;
		insert aplRsm2;
    	
    	RecordType rt25 = ClsTestHelp.createTestRecordType26(); 
    	list<APL_Forecast_Management__c> list_apls = new list<APL_Forecast_Management__c>();
    	APL_Forecast_Management__c apl = new APL_Forecast_Management__c();
    	apl.Name = 'testName';
    	apl.A6_Code__c = '123456';
    	apl.Manager__c = userInfo.getUserId();  
    	apl.RSM__c = aplRsm2.Id;
    	apl.GAM_Code__c = '1234';
    	apl.RecordTypeId = rt25.Id;
    	//insert apl;
    	list_apls.add(apl);
    	
    	APL_Forecast_Management__c apl1 = new APL_Forecast_Management__c();
    	apl1.Name = 'testName1';
    	apl1.A6_Code__c = '123456';
    	apl1.GAM_Code__c = '1234';
    	apl1.Manager__c = userInfo.getUserId();
    	apl1.RecordTypeId = rt25.Id;
    	apl1.RSM__c = aplRsm1.Id;
    	//insert apl1;
    	list_apls.add(apl1);
    	insert list_apls;
    	
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
		ctrl.selectedType = APL_ClsUtils.MAP_RSMMANAGERLABEL.get('Relay');
		ctrl.setRSMType();
		ctrl.searchGroupsAccounts();
        ctrl.initRSM();
        
        
        APL_ClsEntityType.SearchObj so = ClsTestHelp.createSearchObj();
        so.set_fiscalMonth = new set<String>();
        so.set_fiscalMonth.add('2015_5');
        so.currencyIso = 'USD';
        so.territoryCode = APL_ClsUtils.OTHER;
        so.managerId = userInfo.getUserId();
        so.rsmgrouping = APL_ClsUtils.OTHER;
        so.accnumber = part1.PRODUCT_CDE__c;
        so.grouping = acct.Id;
        so.cbc2Code = ph1.CBC2__c;
        so.partId = part1.Id;
        so.map_year_quartersFuture = new map<String, set<String>>{
        	'2015'=> new set<String>{'03', '04'},
        	'2016'=> new set<String>{'01', '02', '03', '04'},
        	'2017'=> new set<String>{'01'}
        };
        so.set_fiscalMonth.add('2016_9');
        so.set_fiscalMonth.add('2015_8');
        String sData = JSON.serialize(so);
        
        APL_ClsRelayForecastbyProductService rsmservice = new APL_ClsRelayForecastbyProductService();
		list<APL_ClsEntityType.APLColumn> list_acctColumns = new list<APL_ClsEntityType.APLColumn>();
		rsmservice.setTotalRow(list_acctColumns, ctrl.pageConf);
		list<Object> list_data = new list<Object>();
        rsmservice.setLevel1Data(list_data, ctrl.pageConf);
        
        APL_ClsRelayForecastbyProductService.SearchLevelTotal total = new APL_ClsRelayForecastbyProductService.SearchLevelTotal();
        
        String se = total.getExistResult(sData);
        String s = total.getRefData(sData);
        String sd = total.getBacklogRefData(sData);
        
        
        APL_ClsRelayForecastbyProductService.SearchLevel1 level1 = new APL_ClsRelayForecastbyProductService.SearchLevel1();
        
        s = level1.getRefData(sData);
        sd = level1.getBacklogRefData(sData);
        
        APL_ClsRelayForecastbyProductService.SearchLevel2 level2 = new APL_ClsRelayForecastbyProductService.SearchLevel2();
		se = level2.getExistResult(sData);
        s = level2.getRefData(sData);
        sd = level2.getBacklogRefData(sData);
        
        
        APL_ClsRelayForecastbyProductService.SearchLevel3 level3 = new APL_ClsRelayForecastbyProductService.SearchLevel3();
		se = level3.getExistResult(sData);
        s = level3.getRefData(sData);
        sd = level3.getBacklogRefData(sData);
        
        APL_ClsRelayForecastbyProductService.SearchLevel4 level4 = new APL_ClsRelayForecastbyProductService.SearchLevel4();
		se = level4.getExistResult(sData);
        s = level4.getRefData(sData);
        sd = level4.getBacklogRefData(sData);
        
        
        Test.stopTest();
    }
}