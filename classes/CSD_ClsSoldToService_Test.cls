/**
*  This test class used to test class CSD_CtrlSalesPersonViewForecast.
*
@author Lei Tang
@created 2015-06-23
*
@changelog
* coverage  78%
*  
2015-06-23 Lei Tang <lei.tang@itbconsult.com>
* - Created
*/
@isTest
public  class CSD_ClsSoldToService_Test {
	
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
    	system.debug('!@# rtoem :'+rtoem);    
    	Consumer_Device_Opportunity_Record_Types__c cdort1 = ClsTestHelp.createTestCSD1();
    	Consumer_Device_Opportunity_Record_Types__c cdort2 = ClsTestHelp.createTestCSD2();
    	Consumer_Device_Opportunity_Record_Types__c cdort3 = ClsTestHelp.createTestCSD3();
    	Consumer_Device_Opportunity_Record_Types__c cdort4 = ClsTestHelp.createTestCSD4();
    	Consumer_Device_Opportunity_Record_Types__c cdort5 = ClsTestHelp.createTestCSD5();
    	Consumer_Device_Opportunity_Record_Types__c cdort6 = ClsTestHelp.createTestCSD6();
    	Consumer_Device_Opportunity_Record_Types__c cdort7 = ClsTestHelp.createTestCSD7();
        
        User user = ClsTestHelp.createTestUsers(); 
        user.Te_Network_Id__c = 'ABCDEFG';
        insert user;

        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
    	sh.Level_2_Territory_Code__c = '103004';
    	sh.Level_7_Territory_Code__c = '123456';
    	sh.Level_7_Assigned_User_Network_Ids__c = 'ABCDEFG';
        insert sh;
				
		Account samsung = ClsTestHelp.createTestAccounts();
    	samsung.Name = 'samsung';
    	samsung.RecordTypeId = rtoem.Id;
    	samsung.Account_Manager__c = user.Id;
    	samsung.Design_In_Region__c = 'KOREA';
    	samsung.STATDESC__c = 'Active';
    	samsung.Active__c = true;
    	insert samsung;
		
        list<CSD_Configuration__c> list_setting = new list<CSD_Configuration__c>();
		CSD_Configuration__c setting = new CSD_Configuration__c();
		setting.Name = 'Samsung OEM Account';
		setting.Value__c = samsung.Id;
		//insert setting;
		list_setting.add(setting);
		CSD_Configuration__c setting2 = new CSD_Configuration__c();
		setting2.Name = 'Non OEM Account';
		setting2.Value__c = samsung.Id;
		//insert setting2;
		list_setting.add(setting2);
        insert list_setting;
        
		list<Account> list_acct = new list<Account>();
    	Account acct1 = ClsTestHelp.createTestAccounts();
    	acct1.Name = 'axx';
    	acct1.RecordTypeId = rtsoldto.Id;
    	acct1.AccountNumber = '1234:12345678';
    	acct1.Account_Manager__c = user.Id;
    	acct1.SALES_TERRITORY_CDE__c = '123456';
    	acct1.Active__c = true;
    	acct1.STATDESC__c = 'Active';
    	acct1.WWCORPACCT__c = '123412345678';
    	//insert acct1;
    	list_acct.add(acct1);
    	
    	Account acct11 = ClsTestHelp.createTestAccounts();
    	acct11.Name = 'axx1';
    	acct11.RecordTypeId = rtsoldto.Id;
    	acct11.AccountNumber = '1234:12345679';
    	acct11.Account_Manager__c = user.Id;
    	acct11.SALES_TERRITORY_CDE__c = '123456';
    	acct11.Active__c = true;
    	acct11.STATDESC__c = 'Active';
    	acct11.WWCORPACCT__c = '123412345678';
    	//insert acct11;
    	list_acct.add(acct11);
    	
    	Account acct2 = ClsTestHelp.createTestAccounts();
    	acct2.Name = 'relayAcctaxx';
    	acct2.RecordTypeId = rtoem.Id;
    	acct2.Account_Manager__c = user.Id;
    	acct2.Design_In_Region__c = 'AMERICAS';
    	acct2.STATDESC__c = 'Active';
    	acct2.Active__c = true;
    	//insert acct2;
    	list_acct.add(acct2);
    	
    	Account acct22 = ClsTestHelp.createTestAccounts();
    	acct22.Name = 'relayAcctaxx2';
    	acct22.RecordTypeId = rtoem.Id;
    	acct22.Account_Manager__c = user.Id;
    	acct22.Design_In_Region__c = 'AMERICAS';
    	acct22.STATDESC__c = 'Active';
    	acct22.Active__c = true;
    	//insert acct22;
    	list_acct.add(acct22);
        insert list_acct;
		
        list<Product_Hierarchy__c> list_ph = new list<Product_Hierarchy__c>();
    	Product_Hierarchy__c ph = new Product_Hierarchy__c();
    	ph.Name = '123';
    	ph.CBC2__c = '30012';
    	ph.CBC3__c = '30033';
    	ph.CBC1_Description__c = 'Appliances';
        //insert ph;
        list_ph.add(ph);
        
        Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
    	ph1.Name = '1234';
    	ph1.CBC2__c = '13213';
    	ph1.CBC3__c = '30033';
    	ph1.CBC1_Description__c = 'Appliances';
        //insert ph1;
        list_ph.add(ph1);
        
        Product_Hierarchy__c ph2 = new Product_Hierarchy__c();
    	ph2.Name = '1234';
    	ph2.CBC1__c = '45678';
    	ph2.CBC2__c = '13213';
    	ph2.CBC3__c = '30033';
    	ph2.CBC1_Description__c = 'Appliances';
        //insert ph2;
        list_ph.add(ph2);
        insert list_ph;
  
        list<Part__c> list_part = new list<Part__c>();
        Part__c part = new Part__c();
        part.Name = 'testPart';
        part.GPL__c = ph.Id;
        part.Product_Hierarchy__c = ph.Id; 
        part.Description__c = 'test';
        part.PRODUCT_CDE__c = 'TEST1';
        part.PROD_NAME__c = 'test name1';
        //insert part;
        list_part.add(part);
        
        Part__c part1 = new Part__c();
        part1.Name = 'testPart';
        part1.GPL__c = ph1.Id;
        part1.Product_Hierarchy__c = ph1.Id; 
        part1.Description__c = 'test';
        part1.PRODUCT_CDE__c = 'TEST2';
        part1.PROD_NAME__c = 'test name2';
        //insert part1;
        list_part.add(part1);
        Part__c part2 = new Part__c();
        part2.Name = 'testPart';
        part2.GPL__c = ph2.Id;
        part2.Product_Hierarchy__c = ph2.Id; 
        part2.Description__c = 'test';
        part2.PRODUCT_CDE__c = 'TEST3';
        part2.PROD_NAME__c = 'test name3';
        //insert part2;
    	list_part.add(part2);
        insert list_part;
        
        list<CSD_Sales_Forecast__c> list_csdfc = new  list<CSD_Sales_Forecast__c>();
    	CSD_Sales_Forecast__c csdFC1 = new CSD_Sales_Forecast__c();
		csdFC1.Type__c = 'Sold-To';
		csdFC1.Fiscal_Year__c = '2015';
		csdFC1.Fiscal_Month__c = '9';
		csdFC1.Sold_To_Number__c = '1234:12345678';
		csdFC1.Sold_To_Name__c = 'Test';
		csdFC1.Forecast__c = 1000;
		csdFC1.Billing_Region__c = 'AMERICAS';
		//insert csdFC1;
		list_csdfc.add(csdFC1);
        CSD_Sales_Forecast__c csdFCA = new CSD_Sales_Forecast__c();
		csdFCA.Type__c = 'Sold-To';
		csdFCA.Fiscal_Year__c = '2014';
		csdFCA.Fiscal_Month__c = '9';
		csdFCA.Sold_To_Number__c = '1234:12345678';
		csdFCA.Sold_To_Name__c = 'Test';
		csdFCA.Forecast__c = 1000;
		csdFCA.Billing_Region__c = 'AMERICAS';
		//insert csdFC1;
		list_csdfc.add(csdFCA);
        CSD_Sales_Forecast__c csdFCB = new CSD_Sales_Forecast__c();
		csdFCB.Type__c = 'Sold-To';
		csdFCB.Fiscal_Year__c = '2016';
		csdFCB.Fiscal_Month__c = '9';
		csdFCB.Sold_To_Number__c = '1234:12345678';
		csdFCB.Sold_To_Name__c = 'Test';
		csdFCB.Forecast__c = 1000;
		csdFCB.Billing_Region__c = 'AMERICAS';
		//insert csdFC1;
		list_csdfc.add(csdFCB);
        CSD_Sales_Forecast__c csdFCC = new CSD_Sales_Forecast__c();
		csdFCC.Type__c = 'Sold-To';
		csdFCC.Fiscal_Year__c = '2017';
		csdFCC.Fiscal_Month__c = '9';
		csdFCC.Sold_To_Number__c = '1234:12345678';
		csdFCC.Sold_To_Name__c = 'Test';
		csdFCC.Forecast__c = 1000;
		csdFCC.Billing_Region__c = 'AMERICAS';
		//insert csdFC1;
		list_csdfc.add(csdFCC);
		CSD_Sales_Forecast__c csdFC2 = new CSD_Sales_Forecast__c();
		csdFC2.type__c = 'OEM';
		csdFC2.Fiscal_Year__c = '2015';
		csdFC2.Fiscal_Month__c = '9';
		csdFC2.Sold_To_Number__c = '1234:12345678';
		csdFC2.Sold_To_Name__c = 'Test';
		csdFC2.OEM__c = acct2.Id;
		csdFC2.Forecast__c = 1000;
		csdFC2.Billing_Region__c = 'AMERICAS';
		//insert csdFC2;
		list_csdfc.add(csdFC2);
		
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
		//insert csdFC3;
		list_csdfc.add(csdFC3);
		insert list_csdfc;
        
		CSD_Channel_Forecast__c channel = new CSD_Channel_Forecast__c();
		channel.Billing_Region__c = 'AMERICAS';
		channel.Fiscal_Year__c = '2015';
		channel.Fiscal_Month__c = '9';
		channel.Forecast__c = 200;
		channel.OEM__c = acct2.Id;
		channel.Name = 'ChannelForecast';
		insert channel;
    	
    	RecordType rt25 = ClsTestHelp.createTestRecordType25(); 
    	CSD_Forecast_Management__c csd = new CSD_Forecast_Management__c();
    	csd.Name = 'testName';
		csd.Role__c = 'Sales Leader';
		csd.Region__c = 'AMERICAS';
		csd.WWAC_Code__c = '123412345678';
		csd.User__c = user.Id;
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
        so.set_fiscalMonth.add('2017_5');
		so.set_fiscalMonth.add('2017_9');
        so.set_fiscalMonth.add('2017_8');
		
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
		so.endDate = '2018-11-15';
		so.managerId = user.Id;
		so.searchKey = '';
		//View Mode
		so.viewMode = 'billingRegion';
		so.isOtherMethod = false;
		so.accnumber = '1234:12345678';
        String sData = JSON.serialize(so);
		String result = '';

		
		
		
		system.runAs(user){
			Test.startTest();
			
			CSD_CtrlSoldToForecast ctrl = new CSD_CtrlSoldToForecast();
			
			CSD_ClsSoldToService.SearchTotal total = new CSD_ClsSoldToService.SearchTotal();
			result = total.getTotalBillingData(sData);
			
			
			CSD_ClsSoldToService.SearchSoldTo level1 = new CSD_ClsSoldToService.SearchSoldTo();
			
			
			
			CSD_ClsEntityType.AccountObj valueobj = new CSD_ClsEntityType.AccountObj();
			valueobj.accnumber = '1234:12345678';
			valueobj.csFC = new map<String, decimal>(); 
			valueobj.csFC.put('2015_9',1200);
			valueobj.csFC.put('2015_10',1300);
			valueobj.csFC.put('2015_11',1400);
			valueobj.name = 'Test';
			String save = JSON.serialize(valueobj);
			result = level1.saveSObjectData(save);
			
			result = level1.getSearchResult(sData);

			//result = level1.getRefData(sData2);
			result = level1.getBacklogRefData(sData);
			
			
			CSD_ClsSoldToService.SearchRestSoldTo rest = new CSD_ClsSoldToService.SearchRestSoldTo();
			
			//result = rest.getRefData(sData2);
			result = rest.getBacklogRefData(sData);
			
			
			
			CSD_ClsSoldToService.SearchOEM level2 = new CSD_ClsSoldToService.SearchOEM();
			
			result = level2.getExistResult(sData);
			
			so.oemId = acct2.Id;
			sData = JSON.serialize(so);
			
			
			CSD_ClsEntityType.AccountObj valueobj1 = new CSD_ClsEntityType.AccountObj();
			valueobj1.accnumber = '1234:12345678';
			valueobj1.oemId = acct2.Id;
			valueobj1.csFC = new map<String, decimal>(); 
			valueobj1.csFC.put('2015_9',1200);
			valueobj1.csFC.put('2015_10',1300);
			valueobj1.csFC.put('2015_11',1400);
			valueobj1.restPNFC = new map<String, decimal>(); 
			valueobj1.restPNFC.put('2015_9',100);
			valueobj1.restPNFC.put('2015_10',100);
			valueobj1.restPNFC.put('2015_11',100);
			valueobj1.name = 'Test';
			valueobj1.region = 'AMERICAS';
			save = JSON.serialize(valueobj1);
			result = level2.saveSObjectData(save);
			
			result = level2.getSearchResult(sData);
			so.isOtherMethod = true;
			sData = JSON.serialize(so);
			result = level2.getSearchResult(sData);
			//result = level2.getRefData(sData2);
			result = level2.getBacklogRefData(sData);
			

			CSD_ClsSoldToService.SearchPart level3 = new CSD_ClsSoldToService.SearchPart();
			
			result = level3.getExistResult(sData);
			
			so.partId = part1.Id;
			sData = JSON.serialize(so);
			
			
			CSD_ClsEntityType.CSDForecastValueObj valueobj2 = new CSD_ClsEntityType.CSDForecastValueObj();
			valueobj2.accnumber = '1234:12345678';
			valueobj2.oemId = acct2.Id;
			valueobj2.name = 'Test';
			valueobj2.region = 'AMERICAS';
			valueobj2.partId = part1.Id;
			valueobj2.csFC = new map<String, CSD_ClsEntityType.AccountValueobj>();
			CSD_ClsEntityType.AccountValueobj detail1 = new CSD_ClsEntityType.AccountValueobj();
			detail1.price = 12;
			detail1.quantity = 10;
			detail1.forecast = 120;
			valueobj2.csFC.put('2015_9',detail1);
			save = JSON.serialize(valueobj2);
			result = level3.saveSObjectData(save);
			
			result = level3.getSearchResult(sData);
			so.isOtherMethod = false;
			sData = JSON.serialize(so);
			result = level3.getSearchResult(sData);
			
			//result = level3.getRefData(sData2);
			result = level3.getBacklogRefData(sData);
			
			
			result = level2.deleteCSDObject(sData);
			result = level2.deleteCSDObject(sData);
			result = level1.deleteCSDObject(sData);

			Test.stoptest();
		}
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
    	system.debug('!@# rtoem :'+rtoem);    
    	Consumer_Device_Opportunity_Record_Types__c cdort1 = ClsTestHelp.createTestCSD1();
    	Consumer_Device_Opportunity_Record_Types__c cdort2 = ClsTestHelp.createTestCSD2();
    	Consumer_Device_Opportunity_Record_Types__c cdort3 = ClsTestHelp.createTestCSD3();
    	Consumer_Device_Opportunity_Record_Types__c cdort4 = ClsTestHelp.createTestCSD4();
    	Consumer_Device_Opportunity_Record_Types__c cdort5 = ClsTestHelp.createTestCSD5();
    	Consumer_Device_Opportunity_Record_Types__c cdort6 = ClsTestHelp.createTestCSD6();
    	Consumer_Device_Opportunity_Record_Types__c cdort7 = ClsTestHelp.createTestCSD7();
        
        User user = ClsTestHelp.createTestUsers(); 
        user.Te_Network_Id__c = 'ABCDEFG';
        insert user;

        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
    	sh.Level_2_Territory_Code__c = '103004';
    	sh.Level_7_Territory_Code__c = '123456';
    	sh.Level_7_Assigned_User_Network_Ids__c = 'ABCDEFG';
        insert sh;
				
		Account samsung = ClsTestHelp.createTestAccounts();
    	samsung.Name = 'samsung';
    	samsung.RecordTypeId = rtoem.Id;
    	samsung.Account_Manager__c = user.Id;
    	samsung.Design_In_Region__c = 'KOREA';
    	samsung.STATDESC__c = 'Active';
    	samsung.Active__c = true;
    	insert samsung;
		
        list<CSD_Configuration__c> list_setting = new list<CSD_Configuration__c>();
		CSD_Configuration__c setting = new CSD_Configuration__c();
		setting.Name = 'Samsung OEM Account';
		setting.Value__c = samsung.Id;
		//insert setting;
		list_setting.add(setting);
		CSD_Configuration__c setting2 = new CSD_Configuration__c();
		setting2.Name = 'Non OEM Account';
		setting2.Value__c = samsung.Id;
		//insert setting2;
		list_setting.add(setting2);
        insert list_setting;
        
		list<Account> list_acct = new list<Account>();
    	Account acct1 = ClsTestHelp.createTestAccounts();
    	acct1.Name = 'axx';
    	acct1.RecordTypeId = rtsoldto.Id;
    	acct1.AccountNumber = '1234:12345678';
    	acct1.Account_Manager__c = user.Id;
    	acct1.SALES_TERRITORY_CDE__c = '123456';
    	acct1.Active__c = true;
    	acct1.STATDESC__c = 'Active';
    	acct1.WWCORPACCT__c = '123412345678';
    	//insert acct1;
    	list_acct.add(acct1);
    	
    	Account acct11 = ClsTestHelp.createTestAccounts();
    	acct11.Name = 'axx1';
    	acct11.RecordTypeId = rtsoldto.Id;
    	acct11.AccountNumber = '1234:12345679';
    	acct11.Account_Manager__c = user.Id;
    	acct11.SALES_TERRITORY_CDE__c = '123456';
    	acct11.Active__c = true;
    	acct11.STATDESC__c = 'Active';
    	acct11.WWCORPACCT__c = '123412345678';
    	//insert acct11;
    	list_acct.add(acct11);
    	
    	Account acct2 = ClsTestHelp.createTestAccounts();
    	acct2.Name = 'relayAcctaxx';
    	acct2.RecordTypeId = rtoem.Id;
    	acct2.Account_Manager__c = user.Id;
    	acct2.Design_In_Region__c = 'AMERICAS';
    	acct2.STATDESC__c = 'Active';
    	acct2.Active__c = true;
    	//insert acct2;
    	list_acct.add(acct2);
    	
    	Account acct22 = ClsTestHelp.createTestAccounts();
    	acct22.Name = 'relayAcctaxx2';
    	acct22.RecordTypeId = rtoem.Id;
    	acct22.Account_Manager__c = user.Id;
    	acct22.Design_In_Region__c = 'AMERICAS';
    	acct22.STATDESC__c = 'Active';
    	acct22.Active__c = true;
    	//insert acct22;
    	list_acct.add(acct22);
        insert list_acct;
		
        list<Product_Hierarchy__c> list_ph = new list<Product_Hierarchy__c>();
    	Product_Hierarchy__c ph = new Product_Hierarchy__c();
    	ph.Name = '123';
    	ph.CBC2__c = '30012';
    	ph.CBC3__c = '30033';
    	ph.CBC1_Description__c = 'Appliances';
        //insert ph;
        list_ph.add(ph);
        
        Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
    	ph1.Name = '1234';
    	ph1.CBC2__c = '13213';
    	ph1.CBC3__c = '30033';
    	ph1.CBC1_Description__c = 'Appliances';
        //insert ph1;
        list_ph.add(ph1);
        
        Product_Hierarchy__c ph2 = new Product_Hierarchy__c();
    	ph2.Name = '1234';
    	ph2.CBC1__c = '45678';
    	ph2.CBC2__c = '13213';
    	ph2.CBC3__c = '30033';
    	ph2.CBC1_Description__c = 'Appliances';
        //insert ph2;
        list_ph.add(ph2);
        insert list_ph;
  
        list<Part__c> list_part = new list<Part__c>();
        Part__c part = new Part__c();
        part.Name = 'testPart';
        part.GPL__c = ph.Id;
        part.Product_Hierarchy__c = ph.Id; 
        part.Description__c = 'test';
        part.PRODUCT_CDE__c = 'TEST1';
        part.PROD_NAME__c = 'test name1';
        //insert part;
        list_part.add(part);
        
        Part__c part1 = new Part__c();
        part1.Name = 'testPart';
        part1.GPL__c = ph1.Id;
        part1.Product_Hierarchy__c = ph1.Id; 
        part1.Description__c = 'test';
        part1.PRODUCT_CDE__c = 'TEST2';
        part1.PROD_NAME__c = 'test name2';
        //insert part1;
        list_part.add(part1);
        Part__c part2 = new Part__c();
        part2.Name = 'testPart';
        part2.GPL__c = ph2.Id;
        part2.Product_Hierarchy__c = ph2.Id; 
        part2.Description__c = 'test';
        part2.PRODUCT_CDE__c = 'TEST3';
        part2.PROD_NAME__c = 'test name3';
        //insert part2;
    	list_part.add(part2);
        insert list_part;
        
        list<CSD_Sales_Forecast__c> list_csdfc = new  list<CSD_Sales_Forecast__c>();
    	CSD_Sales_Forecast__c csdFC1 = new CSD_Sales_Forecast__c();
		csdFC1.Type__c = 'Sold-To';
		csdFC1.Fiscal_Year__c = '2017';
		csdFC1.Fiscal_Month__c = '1';
		csdFC1.Sold_To_Number__c = '1234:12345678';
		csdFC1.Sold_To_Name__c = 'Test';
		csdFC1.Forecast__c = 1000;
		//csdFC1.Fiscal_Date__c = system.today();
		csdFC1.Billing_Region__c = 'AMERICAS';
		//insert csdFC1;
		list_csdfc.add(csdFC1);
        CSD_Sales_Forecast__c csdFCA = new CSD_Sales_Forecast__c();
		csdFCA.Type__c = 'Sold-To';
		csdFCA.Fiscal_Year__c = '2014';
		csdFCA.Fiscal_Month__c = '9';
		csdFCA.Sold_To_Number__c = '1234:12345678';
		csdFCA.Sold_To_Name__c = 'Test';
		csdFCA.Forecast__c = 1000;
		csdFCA.Billing_Region__c = 'AMERICAS';
		//insert csdFC1;
		list_csdfc.add(csdFCA);
        CSD_Sales_Forecast__c csdFCB = new CSD_Sales_Forecast__c();
		csdFCB.Type__c = 'Sold-To';
		csdFCB.Fiscal_Year__c = '2016';
		csdFCB.Fiscal_Month__c = '9';
		csdFCB.Sold_To_Number__c = '1234:12345678';
		csdFCB.Sold_To_Name__c = 'Test';
		csdFCB.Forecast__c = 1000;
		csdFCB.Billing_Region__c = 'AMERICAS';
		//insert csdFC1;
		list_csdfc.add(csdFCB);
        CSD_Sales_Forecast__c csdFCC = new CSD_Sales_Forecast__c();
		csdFCC.Type__c = 'Sold-To';
		csdFCC.Fiscal_Year__c = '2017';
		csdFCC.Fiscal_Month__c = '9';
		csdFCC.Sold_To_Number__c = '1234:12345678';
		csdFCC.Sold_To_Name__c = 'Test';
		csdFCC.Forecast__c = 1000;
		csdFCC.Billing_Region__c = 'AMERICAS';
		//insert csdFC1;
		list_csdfc.add(csdFCC);

		CSD_Sales_Forecast__c csdFC11 = new CSD_Sales_Forecast__c();
		csdFC11.Type__c = 'Rest-SoldTo';
		csdFC11.Fiscal_Year__c = '2017';
		csdFC11.Fiscal_Month__c = '1';
		csdFC11.Sold_To_Number__c = '1234:12345678';
		csdFC11.Sold_To_Name__c = 'Test';
		csdFC11.Forecast__c = 1000;
		//csdFC11.Fiscal_Date__c = system.today();
		csdFC11.Billing_Region__c = 'AMERICAS';
		//insert csdFC1;
		list_csdfc.add(csdFC11);

		CSD_Sales_Forecast__c csdFC2 = new CSD_Sales_Forecast__c();
		csdFC2.type__c = 'OEM';
		csdFC2.Fiscal_Year__c = '2017';
		csdFC2.Fiscal_Month__c = '1';
		csdFC2.Sold_To_Number__c = '1234:12345678';
		//csdFC2.Fiscal_Date__c = system.today();
		csdFC2.Sold_To_Name__c = 'Test';
		csdFC2.OEM__c = acct2.Id;
		csdFC2.Forecast__c = 1000;
		csdFC2.Billing_Region__c = 'AMERICAS';
		//insert csdFC2;
		list_csdfc.add(csdFC2);
		
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
		//insert csdFC3;
		list_csdfc.add(csdFC3);
		insert list_csdfc;
        
		CSD_Channel_Forecast__c channel = new CSD_Channel_Forecast__c();
		channel.Billing_Region__c = 'AMERICAS';
		channel.Fiscal_Year__c = '2015';
		channel.Fiscal_Month__c = '9';
		channel.Forecast__c = 200;
		channel.OEM__c = acct2.Id;
		channel.Name = 'ChannelForecast';
		insert channel;
    	
    	RecordType rt25 = ClsTestHelp.createTestRecordType25(); 
    	CSD_Forecast_Management__c csd = new CSD_Forecast_Management__c();
    	csd.Name = 'testName';
		csd.Role__c = 'Sales Leader';
		csd.Region__c = 'AMERICAS';
		csd.WWAC_Code__c = '123412345678';
		csd.User__c = user.Id;
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
		
		
		CSD_ClsEntityType.SearchObj so2 = new CSD_ClsEntityType.SearchObj();
        so2.set_fiscalMonth = new set<String>();
        so2.set_fiscalMonth.add('2015_5');
		so2.set_fiscalMonth.add('2015_9');
        so2.set_fiscalMonth.add('2015_8');
		
        so2.map_year_monthsFuture = new map<String, set<Integer>>{
        	'2015'=> new set<Integer>{3,4,5,6,7,8,9,10,11}
        };
        
        so2.map_quarter_months =  new map<String, String>{
        	'01'=>'1,2,3',
        	'02'=>'4,5,6',
        	'03'=>'7,8,9',
        	'04'=>'10,11,12'
        };
        so2.set_selectedId = new set<String>();
		so2.startDate = '2015-03-15';
		so2.endDate = '2018-11-15';
		so2.managerId = user.Id;
		so2.searchKey = '';
		//View Mode
		so2.viewMode = 'billingRegion';
		so2.isOtherMethod = false;
		so2.accnumber = '1234:12345678';
        String sData2 = JSON.serialize(so2);
		String result = '';
		
		system.runAs(user){
			Test.startTest();
			
			CSD_ClsSoldToService.SearchSoldTo level1 = new CSD_ClsSoldToService.SearchSoldTo();
			result = level1.getRefData(sData2);

			CSD_ClsSoldToService.SearchTotal total = new CSD_ClsSoldToService.SearchTotal();
			result = total.getTotalBillingData(sData2);

			//CSD_ClsSoldToService.SearchPart SearchPart1 = new CSD_ClsSoldToService.SearchPart();
			//result = SearchPart1.useASP(sData2);
			//result = SearchPart1.copyCFTForecast(sData2);

			CSD_ClsEntityType.AccountObj valueobj = new CSD_ClsEntityType.AccountObj();
			valueobj.accnumber = '1234:12345678';
			valueobj.csFC = new map<String, decimal>(); 
			valueobj.csFC.put('2015_9',1200);
			valueobj.csFC.put('2015_10',1300);
			valueobj.csFC.put('2015_11',1400);
			valueobj.name = 'Test';
			String save = JSON.serialize(valueobj);
			CSD_ClsSoldToService.SearchRestSoldTo rest = new CSD_ClsSoldToService.SearchRestSoldTo();
			result = rest.getRefData(sData2);
			result = rest.saveSObjectData(save);


			CSD_ClsSoldToService.SearchOEM level2 = new CSD_ClsSoldToService.SearchOEM();
			so2.oemId = acct2.Id;
			so2.isOtherMethod = true;
			sData2 = JSON.serialize(so2);
			result = level2.getRefData(sData2);

			CSD_ClsSoldToService.SearchPart level3 = new CSD_ClsSoldToService.SearchPart();
			so2.partId = part1.Id;
			so2.isOtherMethod = false;
			sData2 = JSON.serialize(so2);
			result = level3.getRefData(sData2);
			
			CSD_ClsSoldToService.SearchNonOEMs nonoem = new CSD_ClsSoldToService.SearchNonOEMs();
			CSD_ClsEntityType.AccountObj valueobjnon = new CSD_ClsEntityType.AccountObj();
			valueobjnon.accnumber = '1234:12345679';
			valueobjnon.csFC = new map<String, decimal>(); 
			valueobjnon.csFC.put('2015_9',1200);
			valueobjnon.csFC.put('2015_10',1300);
			valueobjnon.csFC.put('2015_11',1400);
			valueobjnon.restPNFC = new map<String, decimal>(); 
			valueobjnon.restPNFC.put('2015_9',100);
			valueobjnon.restPNFC.put('2015_10',100);
			valueobjnon.restPNFC.put('2015_11',100);
			valueobjnon.name = 'Test';
			valueobjnon.region = 'AMERICAS';
			save = JSON.serialize(valueobjnon);
			result = nonoem.saveSObjectData(save);
			
			Test.stoptest();
		}
    }
	
}