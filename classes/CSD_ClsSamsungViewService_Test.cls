/**
*  This test class used to test class CSD_ClsSamsungViewService.
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
private class CSD_ClsSamsungViewService_Test {

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
        user.FirstName ='TeFirst';
        user.LastName = 'Tester';
        user.Username = 'tetest@tetest.com';
        user.Te_Network_Id__c = 'ABCDEFG';
        user.Email = 'tetest@tetest.com';
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

		CSD_Configuration__c setting = new CSD_Configuration__c();
		setting.Name = 'Samsung OEM Account';
		setting.Value__c = samsung.Id;
		insert setting;
		
		CSD_Configuration__c setting2 = new CSD_Configuration__c();
		setting2.Name = 'Non OEM Account';
		setting2.Value__c = samsung.Id;
		insert setting2;
		
		
    	Account acct1 = ClsTestHelp.createTestAccounts();
    	acct1.Name = 'axx';
    	acct1.RecordTypeId = rtsoldto.Id;
    	acct1.AccountNumber = '1234:12345678';
    	acct1.Account_Manager__c = user.Id;
    	acct1.SALES_TERRITORY_CDE__c = '123456';
    	acct1.Active__c = true;
    	acct1.STATDESC__c = 'Active';
    	acct1.WWCORPACCT__c = '123412345678';
    	insert acct1;
    	
    	Account acct11 = ClsTestHelp.createTestAccounts();
    	acct11.Name = 'axx1';
    	acct11.RecordTypeId = rtsoldto.Id;
    	acct11.AccountNumber = '1234:12345679';
    	acct11.Account_Manager__c = user.Id;
    	acct11.SALES_TERRITORY_CDE__c = '123456';
    	acct11.Active__c = true;
    	acct11.STATDESC__c = 'Active';
    	acct11.WWCORPACCT__c = '123412345679';
    	insert acct11;
    	
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
		csdFC1.GPL_Family__c = 'gplfamily';
		csdFC1.GPL_Code__c = 'gplcode';
		csdFC1.Fiscal_Year__c = '2015';
		csdFC1.Fiscal_Month__c = '9';
		csdFC1.Sold_To_Number__c = '1234:12345678';
		csdFC1.Sold_To_Name__c = 'Test';
		csdFC1.Forecast__c = 1000;
		csdFC1.Billing_Region__c = 'KOREA';
		csdFC1.Samsung_Type__c = 'Non Part';
		csdFC1.OEM__c = samsung.Id;
		csdFC1.Part__c = Part1.Id;
		//insert csdFC1;

		CSD_Sales_Forecast__c csdFC1A = new CSD_Sales_Forecast__c();
		csdFC1A.Type__c = 'Sold-To';
		csdFC1A.GPL_Family__c = 'gplfamily';
		csdFC1A.GPL_Code__c = 'gplcode';
		csdFC1A.Fiscal_Year__c = '2016';
		csdFC1A.Fiscal_Month__c = '9';
		csdFC1A.Samsung_Type__c = 'Non Part';
		csdFC1A.OEM__c = samsung.Id;
		csdFC1A.Sold_To_Number__c = '1234:12345678';
		csdFC1A.Sold_To_Name__c = 'Test';
		csdFC1A.Forecast__c = 1000;
		csdFC1A.Billing_Region__c = 'KOREA';
		csdFC1A.Part__c = Part1.Id;

		CSD_Sales_Forecast__c csdFC1B = new CSD_Sales_Forecast__c();
		csdFC1B.Type__c = 'Sold-To';
		csdFC1B.GPL_Family__c = 'gplfamily';
		csdFC1B.GPL_Code__c = 'gplcode';
		csdFC1B.Fiscal_Year__c = '2017';
		csdFC1B.Fiscal_Month__c = '9';
		csdFC1B.Samsung_Type__c = 'Non Part';
		csdFC1B.OEM__c = samsung.Id;
		csdFC1B.Sold_To_Number__c = '1234:12345678';
		csdFC1B.Sold_To_Name__c = 'Test';
		csdFC1B.Forecast__c = 1000;
		csdFC1B.Billing_Region__c = 'KOREA';
		csdFC1B.Part__c = Part1.Id;
		
		CSD_Sales_Forecast__c csdFC11 = new CSD_Sales_Forecast__c();
		csdFC11.Type__c = 'Sold-To';
		csdFC11.GPL_Family__c = 'gplfamily';
		csdFC11.GPL_Code__c = 'gplcode';
		csdFC11.Fiscal_Year__c = '2015';
		csdFC11.Fiscal_Month__c = '9';
		csdFC11.Sold_To_Number__c = '1234:12345670';
		csdFC11.Sold_To_Name__c = 'Test';
		csdFC11.Forecast__c = 1000;
		csdFC11.Billing_Region__c = 'KOREA';
		csdFC11.Samsung_Type__c = 'Non Part';
		csdFC11.OEM__c = samsung.Id;
		csdFC11.Part__c = Part1.Id;
		//insert csdFC11
		
		
		CSD_Sales_Forecast__c csdFC2 = new CSD_Sales_Forecast__c();
		csdFC2.type__c = 'OEM';
		csdFC2.GPL_Family__c = 'gplfamily';
		csdFC2.Fiscal_Year__c = '2015';
		csdFC2.Fiscal_Month__c = '9';
		csdFC2.Sold_To_Number__c = '1234:12345678';
		csdFC2.Sold_To_Name__c = 'Test';
		csdFC2.OEM__c = samsung.Id;
		csdFC2.Forecast__c = 1000;
		csdFC2.Billing_Region__c = 'KOREA';
		//insert csdFC2;
		
		
		CSD_Sales_Forecast__c csdFC3 = new CSD_Sales_Forecast__c();
		csdFC3.type__c = 'Part';
		csdFC3.Fiscal_Year__c = '2015';
		csdFC3.Fiscal_Month__c = '9';
		csdFC3.Sold_To_Number__c = '1234:12345678';
		csdFC3.Sold_To_Name__c = 'Test';
		csdFC3.Part__c = part1.Id;
		csdFC3.Forecast__c = 100;
		csdFC3.OEM__c = samsung.Id;
		csdFC3.Price__c = 10;
		csdFC3.Quantity__c = 10;
		csdFC3.Billing_Region__c = 'KOREA';
		//insert csdFC3;
		insert new list<CSD_Sales_Forecast__c>{csdFC1,csdFC1A,csdFC1B,csdFC11,csdFC2,csdFC3};
    	
    	RecordType rt25 = ClsTestHelp.createTestRecordType25(); 
    	CSD_Forecast_Management__c csd = new CSD_Forecast_Management__c();
    	csd.Name = 'testName';
		csd.Role__c = 'Samsung GAM';
		csd.Region__c = 'AMERICAS';
		csd.WWAC_Code__c = '123412345678';
		csd.User__c = user.Id;
    	insert csd;

    	CSD_Samsung_Mapping__c summap = new CSD_Samsung_Mapping__c();
    	summap.Sales_Email__c = 'tetest@tetest.com';
    	summap.GPL_Family__c = 'gplfamily';
    	summap.GPL_Code__c = 'gplcode';
    	summap.Category__c = '1234:12345678';
    	summap.Part__c = part1.Id;
    	insert summap;
    	
    	CSD_Samsung_Mapping__c summap1 = new CSD_Samsung_Mapping__c();
    	summap1.Sales_Email__c = 'tetest@tetest.com';
    	summap1.GPL_Family__c = 'gplfamily';
    	summap1.GPL_Code__c = 'gplcode';
    	summap1.Category__c = '1234:12345679';
    	summap1.Part__c = part1.Id;
    	insert summap1;
    	
    	OEM_Details__c oemd = new OEM_Details__c();
    	oemd.OEM__c = samsung.Id;
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
		so.viewMode = 'view';
		so.isOtherMethod = false;
		so.gplfamily = 'gplfamily';
		so.oemId = samsung.Id;
        String sData = JSON.serialize(so);
        CSD_ClsEntityType.SearchObj so2 = new CSD_ClsEntityType.SearchObj();
        so2.set_fiscalMonth = new set<String>();
        so2.set_fiscalMonth.add('2019_5');
		so2.set_fiscalMonth.add('2019_9');
        so2.set_fiscalMonth.add('2019_8');
		
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
		so2.endDate = '2015-11-15';
		so2.managerId = user.Id;
		so2.searchKey = '';
		//View Mode
		so2.viewMode = 'forecast';
		so2.isOtherMethod = false;
		so2.gplfamily = 'gplfamily';
		so2.oemId = samsung.Id;
        String sData2 = JSON.serialize(so2);

		String result = '';
		
		system.runAs(user){
			Test.startTest();
			
			CSD_CtrlSamsungForecastView ctrl = new CSD_CtrlSamsungForecastView();
			
			
			CSD_ClsSamsungViewService.SearchTotal total = new CSD_ClsSamsungViewService.SearchTotal();
			result = total.getTotalBillingData(sData);
			
			
			CSD_ClsSamsungViewService.SearchLevel1 level1 = new CSD_ClsSamsungViewService.SearchLevel1();
			
			result = level1.getRefData(sData);
			//result = level1.getBacklogRefData(sData);
			result = level1.getBacklogRefData(sData2);
			
			
			
			CSD_ClsSamsungViewService.SearchLevel2 level2 = new CSD_ClsSamsungViewService.SearchLevel2();
			result = level2.getExistResult(sData);
			
			so.gplcode = 'gplcode';
			sData = JSON.serialize(so);
			so2.gplcode = 'gplcode';
			sData2 = JSON.serialize(so2);
			
			result = level2.getRefData(sData);
			//result = level2.getBacklogRefData(sData);
			result = level2.getBacklogRefData(sData2);
			
			so.isOtherMethod = true;
			sData = JSON.serialize(so);
			so2.isOtherMethod = true;
			sData2 = JSON.serialize(so2);
			result = level2.getRefData(sData);
			result = level2.getExistResult(sData);
			//result = level2.getBacklogRefData(sData);
			result = level2.getBacklogRefData(sData2);
			
			
			
			CSD_ClsSamsungViewService.SearchLevel3 level3 = new CSD_ClsSamsungViewService.SearchLevel3();
			
			so.partId = part1.Id;
			sData = JSON.serialize(so);
			so2.partId = part1.Id;
			sData2 = JSON.serialize(so2);
			result = level3.getExistResult(sData);
			result = level3.getRefData(sData);
			//result = level3.getBacklogRefData(sData);
			result = level3.getBacklogRefData(sData2);
			
			so.isOtherMethod = false;
			sData = JSON.serialize(so);
			so2.isOtherMethod = false;
			sData2 = JSON.serialize(so2);
			result = level3.getExistResult(sData);
			result = level3.getRefData(sData);
			//result = level3.getBacklogRefData(sData);
			//result = level3.getBacklogRefData(sData2);

			so.isOtherMethod = true;
			sData = JSON.serialize(so);
			result = level3.getExistResult(sData);

			CSD_ClsSamsungViewService.SearchLevel4 level4 = new CSD_ClsSamsungViewService.SearchLevel4();
			
			so.accnumber = '1234:12345678';
			sData = JSON.serialize(so);
			so2.accnumber = '1234:12345678';
			sData2 = JSON.serialize(so2);
			result = level4.getRefData(sData);
			//result = level4.getBacklogRefData(sData);
			//result = level4.getBacklogRefData(sData2);
			
			so.isExpansionSoldto = true;
			sData = JSON.serialize(so);
			result = level4.getExistResult(sData);
			
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
        user.FirstName ='TeFirst';
        user.LastName = 'Tester';
        user.Username = 'tetest@tetest.com';
        user.Te_Network_Id__c = 'ABCDEFG';
        user.Email = 'tetest@tetest.com';
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

		CSD_Configuration__c setting = new CSD_Configuration__c();
		setting.Name = 'Samsung OEM Account';
		setting.Value__c = samsung.Id;
		insert setting;
		
		CSD_Configuration__c setting2 = new CSD_Configuration__c();
		setting2.Name = 'Non OEM Account';
		setting2.Value__c = samsung.Id;
		insert setting2;
		
		
    	Account acct1 = ClsTestHelp.createTestAccounts();
    	acct1.Name = 'axx';
    	acct1.RecordTypeId = rtsoldto.Id;
    	acct1.AccountNumber = '1234:12345678';
    	acct1.Account_Manager__c = user.Id;
    	acct1.SALES_TERRITORY_CDE__c = '123456';
    	acct1.Active__c = true;
    	acct1.STATDESC__c = 'Active';
    	acct1.WWCORPACCT__c = '123412345678';
    	insert acct1;
    	
    	Account acct11 = ClsTestHelp.createTestAccounts();
    	acct11.Name = 'axx1';
    	acct11.RecordTypeId = rtsoldto.Id;
    	acct11.AccountNumber = '1234:12345679';
    	acct11.Account_Manager__c = user.Id;
    	acct11.SALES_TERRITORY_CDE__c = '123456';
    	acct11.Active__c = true;
    	acct11.STATDESC__c = 'Active';
    	acct11.WWCORPACCT__c = '123412345679';
    	insert acct11;
    	
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
		csdFC1.GPL_Family__c = 'gplfamily';
		csdFC1.GPL_Code__c = 'gplcode';
		csdFC1.Fiscal_Year__c = '2015';
		csdFC1.Fiscal_Month__c = '9';
		csdFC1.Sold_To_Number__c = '1234:12345678';
		csdFC1.Sold_To_Name__c = 'Test';
		csdFC1.Forecast__c = 1000;
		csdFC1.Billing_Region__c = 'KOREA';
		insert csdFC1;
		
		CSD_Sales_Forecast__c csdFC11 = new CSD_Sales_Forecast__c();
		csdFC11.Type__c = 'Sold-To';
		csdFC11.GPL_Family__c = 'gplfamily';
		csdFC11.GPL_Code__c = 'gplcode';
		csdFC11.Fiscal_Year__c = '2015';
		csdFC11.Fiscal_Month__c = '9';
		csdFC11.Sold_To_Number__c = '1234:12345670';
		csdFC11.Sold_To_Name__c = 'Test';
		csdFC11.Forecast__c = 1000;
		csdFC11.Billing_Region__c = 'KOREA';
		csdFC11.Samsung_Type__c = 'Non Part';
		insert csdFC11;
		
		
		CSD_Sales_Forecast__c csdFC2 = new CSD_Sales_Forecast__c();
		csdFC2.type__c = 'OEM';
		csdFC2.GPL_Family__c = 'gplfamily';
		csdFC2.Fiscal_Year__c = '2015';
		csdFC2.Fiscal_Month__c = '9';
		csdFC2.Sold_To_Number__c = '1234:12345678';
		csdFC2.Sold_To_Name__c = 'Test';
		csdFC2.OEM__c = samsung.Id;
		csdFC2.Forecast__c = 1000;
		csdFC2.Billing_Region__c = 'KOREA';
		insert csdFC2;
		
		
		CSD_Sales_Forecast__c csdFC3 = new CSD_Sales_Forecast__c();
		csdFC3.type__c = 'Part';
		csdFC3.Fiscal_Year__c = '2015';
		csdFC3.Fiscal_Month__c = '9';
		csdFC3.Sold_To_Number__c = '1234:12345678';
		csdFC3.Sold_To_Name__c = 'Test';
		csdFC3.Part__c = part1.Id;
		csdFC3.Forecast__c = 100;
		csdFC3.OEM__c = samsung.Id;
		csdFC3.Price__c = 10;
		csdFC3.Quantity__c = 10;
		csdFC3.Billing_Region__c = 'KOREA';
		insert csdFC3;
		
		
		CSD_Sales_Forecast__c csdFCS1 = new CSD_Sales_Forecast__c();
		csdFCS1.Type__c = 'Sold-To';
		csdFCS1.GPL_Family__c = 'gplfamily';
		csdFCS1.GPL_Code__c = 'gplcode';
		csdFCS1.Fiscal_Year__c = '2016';
		csdFCS1.Fiscal_Month__c = '2';
		csdFCS1.Sold_To_Number__c = '1234:12345678';
		csdFCS1.Sold_To_Name__c = 'Test';
		csdFCS1.Forecast__c = 1000;
		csdFCS1.Part__c = part1.Id;
		csdFCS1.Billing_Region__c = 'KOREA';
		insert csdFCS1;
		
		CSD_Sales_Forecast__c csdFCS2 = new CSD_Sales_Forecast__c();
		csdFCS2.Type__c = 'Sold-To';
		csdFCS2.GPL_Family__c = 'gplfamily';
		csdFCS2.GPL_Code__c = 'gplcode';
		csdFCS2.Fiscal_Year__c = '2016';
		csdFCS2.Fiscal_Month__c = '3';
		csdFCS2.Sold_To_Number__c = '1234:12345679';
		csdFCS2.Sold_To_Name__c = 'Test';
		csdFCS2.Forecast__c = 1000;
		csdFCS2.Part__c = part1.Id;
		csdFCS2.Billing_Region__c = 'KOREA';
		csdFCS2.Samsung_Type__c = 'Non Part';
		insert csdFCS2;
		
		
		CSD_Sales_Forecast__c csdFCS3 = new CSD_Sales_Forecast__c();
		csdFCS3.type__c = 'Sold-To';
		csdFCS3.GPL_Family__c = 'gplfamily';
		csdFCS3.Fiscal_Year__c = '2016';
		csdFCS3.Fiscal_Month__c = '4';
		csdFCS3.Sold_To_Number__c = '1234:12345678';
		csdFCS3.Sold_To_Name__c = 'Test';
		csdFCS3.OEM__c = samsung.Id;
		csdFCS3.Part__c = part1.Id;
		csdFCS3.Forecast__c = 1000;
		csdFCS3.Billing_Region__c = 'KOREA';
		insert csdFCS3;
		
		
		CSD_Sales_Forecast__c csdFCS4 = new CSD_Sales_Forecast__c();
		csdFCS4.type__c = 'Sold-To';
		csdFCS4.Fiscal_Year__c = '2016';
		csdFCS4.Fiscal_Month__c = '5';
		csdFCS4.Sold_To_Number__c = '1234:12345678';
		csdFCS4.Sold_To_Name__c = 'Test';
		csdFCS4.Part__c = part1.Id;
		csdFCS4.Forecast__c = 100;
		csdFCS4.OEM__c = samsung.Id;
		csdFCS4.Price__c = 10;
		csdFCS4.Quantity__c = 10;
		csdFCS4.Billing_Region__c = 'KOREA';
		insert csdFCS4;
		
		
    	
    	RecordType rt25 = ClsTestHelp.createTestRecordType25(); 
    	CSD_Forecast_Management__c csd = new CSD_Forecast_Management__c();
    	csd.Name = 'testName';
		csd.Role__c = 'Samsung GAM';
		csd.Region__c = 'AMERICAS';
		csd.WWAC_Code__c = '123412345678';
		csd.User__c = user.Id;
    	insert csd;

    	CSD_Samsung_Mapping__c summap = new CSD_Samsung_Mapping__c();
    	summap.Sales_Email__c = 'tetest@tetest.com';
    	summap.GPL_Family__c = 'gplfamily';
    	summap.GPL_Code__c = 'gplcode';
    	summap.Category__c = '1234:12345678';
    	summap.Part__c = part1.Id;
    	insert summap;
    	
    	CSD_Samsung_Mapping__c summap1 = new CSD_Samsung_Mapping__c();
    	summap1.Sales_Email__c = 'tetest@tetest.com';
    	summap1.GPL_Family__c = 'gplfamily';
    	summap1.GPL_Code__c = 'gplcode';
    	summap1.Category__c = '1234:12345679';
    	summap1.Part__c = part1.Id;
    	insert summap1;
    	
    	OEM_Details__c oemd = new OEM_Details__c();
    	oemd.OEM__c = samsung.Id;
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
        so.set_fiscalMonth.add('2015_9');
		so.set_fiscalMonth.add('2015_10');
        so.set_fiscalMonth.add('2015_11');
        so.set_fiscalMonth.add('2015_12');
        so.set_fiscalMonth.add('2016_1');
        so.set_fiscalMonth.add('2016_2');
        so.set_fiscalMonth.add('2016_3');
        so.set_fiscalMonth.add('2016_4');
		
        so.map_year_monthsFuture = new map<String, set<Integer>>{
        	'2015'=> new set<Integer>{7,8,9,10,11},
        	'2016'=> new set<Integer>{1,2,3,4}
        };
        
        so.map_quarter_months =  new map<String, String>{
        	'01'=>'1,2,3',
        	'02'=>'4,5,6',
        	'03'=>'7,8,9',
        	'04'=>'10,11,12'
        };
        so.set_selectedId = new set<String>();
		so.startDate = '2015-07-15';
		so.endDate = '2016-04-15';
		so.managerId = user.Id;
		so.searchKey = '';
		//View Mode
		so.viewMode = 'forecast';
		so.isOtherMethod = false;
		so.gplfamily = 'gplfamily';
		so.oemId = samsung.Id;
        String sData = JSON.serialize(so);

        CSD_ClsEntityType.SearchObj so2 = new CSD_ClsEntityType.SearchObj();
        so2.set_fiscalMonth = new set<String>();
        so2.set_fiscalMonth.add('2019_5');
		so2.set_fiscalMonth.add('2019_9');
        so2.set_fiscalMonth.add('2019_8');
		
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
		so2.endDate = '2015-11-15';
		so2.managerId = user.Id;
		so2.searchKey = '';
		//View Mode
		so2.viewMode = 'forecast';
		so2.isOtherMethod = false;
		so2.gplfamily = 'gplfamily';
		so2.oemId = samsung.Id;
        String sData2 = JSON.serialize(so2);
		String result = '';
		
		system.runAs(user){
			Test.startTest();
			
			CSD_CtrlSamsungForecastView ctrl = new CSD_CtrlSamsungForecastView();
			
			
			CSD_ClsSamsungViewService.SearchTotal total = new CSD_ClsSamsungViewService.SearchTotal();
			result = total.getTotalBillingData(sData);
			
			
			CSD_ClsSamsungViewService.SearchLevel1 level1 = new CSD_ClsSamsungViewService.SearchLevel1();
			
			result = level1.getRefData(sData);
			result = level1.getBacklogRefData(sData);
			
			
			
			CSD_ClsSamsungViewService.SearchLevel2 level2 = new CSD_ClsSamsungViewService.SearchLevel2();
			result = level2.getExistResult(sData);
			
			so.gplcode = 'gplcode';
			sData = JSON.serialize(so);
			
			result = level2.getRefData(sData);
			result = level2.getBacklogRefData(sData);
			
			so.isOtherMethod = true;
			sData = JSON.serialize(so);
			result = level2.getRefData(sData);
			result = level2.getBacklogRefData(sData);
			
			
			CSD_ClsSamsungViewService.SearchLevel3 level3 = new CSD_ClsSamsungViewService.SearchLevel3();
			
			so.partId = part1.Id;
			sData = JSON.serialize(so);
			result = level3.getExistResult(sData);
			result = level3.getRefData(sData);
			result = level3.getBacklogRefData(sData);
			
			so.isOtherMethod = false;
			sData = JSON.serialize(so);
			so2.isOtherMethod = false;
			sData2 = JSON.serialize(so2);
			result = level3.getExistResult(sData);
			result = level3.getRefData(sData);
			//result = level3.getBacklogRefData(sData);
			result = level3.getBacklogRefData(sData2);

			CSD_ClsSamsungViewService.SearchLevel4 level4 = new CSD_ClsSamsungViewService.SearchLevel4();
			
			so.accnumber = '1234:12345678';
			sData = JSON.serialize(so);
			so2.accnumber = '1234:12345678';
			sData2 = JSON.serialize(so2);
			result = level4.getRefData(sData);
			//result = level4.getBacklogRefData(sData);
			result = level4.getBacklogRefData(sData2);
			
			so.isExpansionSoldto = true;
			sData = JSON.serialize(so);
			result = level4.getExistResult(sData);
			
			Test.stoptest();
		}
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
    	system.debug('!@# rtoem :'+rtoem);    
    	Consumer_Device_Opportunity_Record_Types__c cdort1 = ClsTestHelp.createTestCSD1();
    	Consumer_Device_Opportunity_Record_Types__c cdort2 = ClsTestHelp.createTestCSD2();
    	Consumer_Device_Opportunity_Record_Types__c cdort3 = ClsTestHelp.createTestCSD3();
    	Consumer_Device_Opportunity_Record_Types__c cdort4 = ClsTestHelp.createTestCSD4();
    	Consumer_Device_Opportunity_Record_Types__c cdort5 = ClsTestHelp.createTestCSD5();
    	Consumer_Device_Opportunity_Record_Types__c cdort6 = ClsTestHelp.createTestCSD6();
    	Consumer_Device_Opportunity_Record_Types__c cdort7 = ClsTestHelp.createTestCSD7();
        
        User user = ClsTestHelp.createTestUsers(); 
        user.FirstName ='TeFirst';
        user.LastName = 'Tester';
        user.Username = 'tetest@tetest.com';
        user.Te_Network_Id__c = 'ABCDEFG';
        user.Email = 'tetest@tetest.com';
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

		CSD_Configuration__c setting = new CSD_Configuration__c();
		setting.Name = 'Samsung OEM Account';
		setting.Value__c = samsung.Id;
		insert setting;
		
		CSD_Configuration__c setting2 = new CSD_Configuration__c();
		setting2.Name = 'Non OEM Account';
		setting2.Value__c = samsung.Id;
		insert setting2;
		
		
    	Account acct1 = ClsTestHelp.createTestAccounts();
    	acct1.Name = 'axx';
    	acct1.RecordTypeId = rtsoldto.Id;
    	acct1.AccountNumber = '1234:12345678';
    	acct1.Account_Manager__c = user.Id;
    	acct1.SALES_TERRITORY_CDE__c = '123456';
    	acct1.Active__c = true;
    	acct1.STATDESC__c = 'Active';
    	acct1.WWCORPACCT__c = '123412345678';
    	insert acct1;
    	
    	Account acct11 = ClsTestHelp.createTestAccounts();
    	acct11.Name = 'axx1';
    	acct11.RecordTypeId = rtsoldto.Id;
    	acct11.AccountNumber = '1234:12345679';
    	acct11.Account_Manager__c = user.Id;
    	acct11.SALES_TERRITORY_CDE__c = '123456';
    	acct11.Active__c = true;
    	acct11.STATDESC__c = 'Active';
    	acct11.WWCORPACCT__c = '123412345679';
    	insert acct11;
    	
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
		csdFC1.GPL_Family__c = 'gplfamily';
		csdFC1.GPL_Code__c = 'gplcode';
		csdFC1.Fiscal_Year__c = '2015';
		csdFC1.Fiscal_Month__c = '9';
		csdFC1.Sold_To_Number__c = '1234:12345678';
		csdFC1.Sold_To_Name__c = 'Test';
		csdFC1.Forecast__c = 1000;
		csdFC1.Billing_Region__c = 'KOREA';
		insert csdFC1;
		
		CSD_Sales_Forecast__c csdFC11 = new CSD_Sales_Forecast__c();
		csdFC11.Type__c = 'Sold-To';
		csdFC11.GPL_Family__c = 'gplfamily';
		csdFC11.GPL_Code__c = 'gplcode';
		csdFC11.Fiscal_Year__c = '2015';
		csdFC11.Fiscal_Month__c = '9';
		csdFC11.Sold_To_Number__c = '1234:12345670';
		csdFC11.Sold_To_Name__c = 'Test';
		csdFC11.Forecast__c = 1000;
		csdFC11.Billing_Region__c = 'KOREA';
		csdFC11.Samsung_Type__c = 'Non Part';
		insert csdFC11;
		
		
		CSD_Sales_Forecast__c csdFC2 = new CSD_Sales_Forecast__c();
		csdFC2.type__c = 'OEM';
		csdFC2.GPL_Family__c = 'gplfamily';
		csdFC2.Fiscal_Year__c = '2015';
		csdFC2.Fiscal_Month__c = '9';
		csdFC2.Sold_To_Number__c = '1234:12345678';
		csdFC2.Sold_To_Name__c = 'Test';
		csdFC2.OEM__c = samsung.Id;
		csdFC2.Forecast__c = 1000;
		csdFC2.Billing_Region__c = 'KOREA';
		insert csdFC2;
		
		
		CSD_Sales_Forecast__c csdFC3 = new CSD_Sales_Forecast__c();
		csdFC3.type__c = 'Part';
		csdFC3.Fiscal_Year__c = '2015';
		csdFC3.Fiscal_Month__c = '9';
		csdFC3.Sold_To_Number__c = '1234:12345678';
		csdFC3.Sold_To_Name__c = 'Test';
		csdFC3.Part__c = part1.Id;
		csdFC3.Forecast__c = 100;
		csdFC3.OEM__c = samsung.Id;
		csdFC3.Price__c = 10;
		csdFC3.Quantity__c = 10;
		csdFC3.Billing_Region__c = 'KOREA';
		insert csdFC3;
		
		
		CSD_Sales_Forecast__c csdFCS1 = new CSD_Sales_Forecast__c();
		csdFCS1.Type__c = 'Sold-To';
		csdFCS1.GPL_Family__c = 'gplfamily';
		csdFCS1.GPL_Code__c = 'gplcode';
		csdFCS1.Fiscal_Year__c = '2016';
		csdFCS1.Fiscal_Month__c = '2';
		//csdFCS1.Sold_To_Number__c = '1234:12345678';
		csdFCS1.Sold_To_Name__c = 'Test';
		csdFCS1.Forecast__c = 1000;
		csdFCS1.Part__c = part1.Id;
		csdFCS1.Billing_Region__c = 'KOREA';
		csdFCS1.Samsung_Type__c = 'Non SoldTo';
		insert csdFCS1;
		
		CSD_Sales_Forecast__c csdFCS2 = new CSD_Sales_Forecast__c();
		csdFCS2.Type__c = 'Sold-To';
		csdFCS2.GPL_Family__c = 'gplfamily';
		csdFCS2.GPL_Code__c = 'gplcode';
		csdFCS2.Fiscal_Year__c = '2016';
		csdFCS2.Fiscal_Month__c = '3';
		csdFCS2.Sold_To_Number__c = null;
		csdFCS2.Sold_To_Name__c = 'Test';
		csdFCS2.Forecast__c = 1000;
		csdFCS2.Part__c = part1.Id;
		csdFCS2.Billing_Region__c = 'KOREA';
		csdFCS2.Samsung_Type__c = 'Non SoldTo';
		insert csdFCS2;
		
		
		CSD_Sales_Forecast__c csdFCS3 = new CSD_Sales_Forecast__c();
		csdFCS3.type__c = 'Sold-To';
		csdFCS3.GPL_Family__c = 'gplfamily';
		csdFCS3.Fiscal_Year__c = '2016';
		csdFCS3.Fiscal_Month__c = '4';
		csdFCS3.Sold_To_Number__c = null;
		csdFCS3.Sold_To_Name__c = 'Test';
		csdFCS3.OEM__c = samsung.Id;
		csdFCS3.Part__c = part1.Id;
		csdFCS3.Forecast__c = 1000;
		csdFCS3.Billing_Region__c = 'KOREA';
		csdFCS3.Samsung_Type__c = 'Non SoldTo';
		insert csdFCS3;
		
		
		CSD_Sales_Forecast__c csdFCS4 = new CSD_Sales_Forecast__c();
		csdFCS4.type__c = 'Sold-To';
		csdFCS4.Fiscal_Year__c = '2016';
		csdFCS4.Fiscal_Month__c = '5';
		csdFCS4.Sold_To_Number__c = null;
		csdFCS4.Sold_To_Name__c = 'Test';
		csdFCS4.Part__c = part1.Id;
		csdFCS4.Forecast__c = 100;
		csdFCS4.OEM__c = samsung.Id;
		csdFCS4.Price__c = 10;
		csdFCS4.Quantity__c = 10;
		csdFCS4.Billing_Region__c = 'KOREA';
		csdFCS4.Samsung_Type__c = 'Non SoldTo';
		insert csdFCS4;
		
		
    	
    	RecordType rt25 = ClsTestHelp.createTestRecordType25(); 
    	CSD_Forecast_Management__c csd = new CSD_Forecast_Management__c();
    	csd.Name = 'testName';
		csd.Role__c = 'Samsung GAM';
		csd.Region__c = 'AMERICAS';
		csd.WWAC_Code__c = '123412345678';
		csd.User__c = user.Id;
    	insert csd;

    	CSD_Samsung_Mapping__c summap = new CSD_Samsung_Mapping__c();
    	summap.Sales_Email__c = 'tetest@tetest.com';
    	summap.GPL_Family__c = 'gplfamily';
    	summap.GPL_Code__c = 'gplcode';
    	summap.Category__c = '1234:12345678';
    	summap.Part__c = part1.Id;
    	insert summap;
    	
    	CSD_Samsung_Mapping__c summap1 = new CSD_Samsung_Mapping__c();
    	summap1.Sales_Email__c = 'tetest@tetest.com';
    	summap1.GPL_Family__c = 'gplfamily';
    	summap1.GPL_Code__c = 'gplcode';
    	summap1.Category__c = '1234:12345679';
    	summap1.Part__c = part1.Id;
    	insert summap1;
    	
    	OEM_Details__c oemd = new OEM_Details__c();
    	oemd.OEM__c = samsung.Id;
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
        so.set_fiscalMonth.add('2015_9');
		so.set_fiscalMonth.add('2015_10');
        so.set_fiscalMonth.add('2015_11');
        so.set_fiscalMonth.add('2015_12');
        so.set_fiscalMonth.add('2016_1');
        so.set_fiscalMonth.add('2016_2');
        so.set_fiscalMonth.add('2016_3');
        so.set_fiscalMonth.add('2016_4');
        so.set_fiscalMonth.add('2016_5');
        so.set_fiscalMonth.add('2016_6');
        so.set_fiscalMonth.add('2016_7');
		
        so.map_year_monthsFuture = new map<String, set<Integer>>{
        	'2015'=> new set<Integer>{7,8,9,10,11,12},
        	'2016'=> new set<Integer>{1,2,3,4,5,6,7}
        };
        
        so.map_quarter_months =  new map<String, String>{
        	'01'=>'1,2,3',
        	'02'=>'4,5,6',
        	'03'=>'7,8,9',
        	'04'=>'10,11,12'
        };
        so.set_selectedId = new set<String>();
		so.startDate = '2015-07-15';
		so.endDate = '2016-08-15';
		so.managerId = user.Id;
		so.searchKey = '';
		//View Mode
		so.viewMode = 'forecast';
		so.isOtherMethod = false;
		so.gplfamily = 'gplfamily';
		so.oemId = samsung.Id;
        String sData = JSON.serialize(so);
		String result = '';
		
		system.runAs(user){
			Test.startTest();
			
			CSD_CtrlSamsungForecastView ctrl = new CSD_CtrlSamsungForecastView();
			
			
			CSD_ClsSamsungViewService.SearchTotal total = new CSD_ClsSamsungViewService.SearchTotal();
			result = total.getTotalBillingData(sData);
			
			
			CSD_ClsSamsungViewService.SearchLevel1 level1 = new CSD_ClsSamsungViewService.SearchLevel1();
			
			result = level1.getRefData(sData);
			result = level1.getBacklogRefData(sData);
			
			
			
			CSD_ClsSamsungViewService.SearchLevel2 level2 = new CSD_ClsSamsungViewService.SearchLevel2();
			result = level2.getExistResult(sData);
			
			so.gplcode = 'gplcode';
			sData = JSON.serialize(so);
			
			result = level2.getRefData(sData);
			result = level2.getBacklogRefData(sData);
			
			so.isOtherMethod = true;
			sData = JSON.serialize(so);
			result = level2.getRefData(sData);
			result = level2.getBacklogRefData(sData);
			
			
			CSD_ClsSamsungViewService.SearchLevel3 level3 = new CSD_ClsSamsungViewService.SearchLevel3();
			
			so.partId = part1.Id;
			sData = JSON.serialize(so);
			result = level3.getExistResult(sData);
			result = level3.getRefData(sData);
			result = level3.getBacklogRefData(sData);
			
			so.isOtherMethod = false;
			sData = JSON.serialize(so);
			result = level3.getExistResult(sData);
			result = level3.getRefData(sData);
			result = level3.getBacklogRefData(sData);
			
			CSD_ClsSamsungViewService.SearchLevel4 level4 = new CSD_ClsSamsungViewService.SearchLevel4();
			
			so.accnumber = '1234:12345678';
			sData = JSON.serialize(so);
			result = level4.getRefData(sData);
			result = level4.getBacklogRefData(sData);
			
			so.isExpansionSoldto = true;
			sData = JSON.serialize(so);
			result = level4.getExistResult(sData);
			
			Test.stoptest();
		}
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
    	system.debug('!@# rtoem :'+rtoem);    
    	Consumer_Device_Opportunity_Record_Types__c cdort1 = ClsTestHelp.createTestCSD1();
    	Consumer_Device_Opportunity_Record_Types__c cdort2 = ClsTestHelp.createTestCSD2();
    	Consumer_Device_Opportunity_Record_Types__c cdort3 = ClsTestHelp.createTestCSD3();
    	Consumer_Device_Opportunity_Record_Types__c cdort4 = ClsTestHelp.createTestCSD4();
    	Consumer_Device_Opportunity_Record_Types__c cdort5 = ClsTestHelp.createTestCSD5();
    	Consumer_Device_Opportunity_Record_Types__c cdort6 = ClsTestHelp.createTestCSD6();
    	Consumer_Device_Opportunity_Record_Types__c cdort7 = ClsTestHelp.createTestCSD7();
        
        User user = ClsTestHelp.createTestUsers(); 
        user.FirstName ='TeFirst';
        user.LastName = 'Tester';
        user.Username = 'tetest@tetest.com';
        user.Te_Network_Id__c = 'ABCDEFG';
        user.Email = 'tetest@tetest.com';
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

		CSD_Configuration__c setting = new CSD_Configuration__c();
		setting.Name = 'Samsung OEM Account';
		setting.Value__c = samsung.Id;
		insert setting;
		
		CSD_Configuration__c setting2 = new CSD_Configuration__c();
		setting2.Name = 'Non OEM Account';
		setting2.Value__c = samsung.Id;
		insert setting2;
		
		
    	Account acct1 = ClsTestHelp.createTestAccounts();
    	acct1.Name = 'axx';
    	acct1.RecordTypeId = rtsoldto.Id;
    	acct1.AccountNumber = '1234:12345678';
    	acct1.Account_Manager__c = user.Id;
    	acct1.SALES_TERRITORY_CDE__c = '123456';
    	acct1.Active__c = true;
    	acct1.STATDESC__c = 'Active';
    	acct1.WWCORPACCT__c = '123412345678';
    	insert acct1;
    	
    	Account acct11 = ClsTestHelp.createTestAccounts();
    	acct11.Name = 'axx1';
    	acct11.RecordTypeId = rtsoldto.Id;
    	acct11.AccountNumber = '1234:12345679';
    	acct11.Account_Manager__c = user.Id;
    	acct11.SALES_TERRITORY_CDE__c = '123456';
    	acct11.Active__c = true;
    	acct11.STATDESC__c = 'Active';
    	acct11.WWCORPACCT__c = '123412345679';
    	insert acct11;
    	
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
		csdFC1.GPL_Family__c = 'gplfamily';
		csdFC1.GPL_Code__c = 'gplcode';
		csdFC1.Fiscal_Year__c = '2015';
		csdFC1.Fiscal_Month__c = '9';
		csdFC1.Sold_To_Number__c = '1234:12345678';
		csdFC1.Sold_To_Name__c = 'Test';
		csdFC1.Forecast__c = 1000;
		csdFC1.Billing_Region__c = 'KOREA';
		insert csdFC1;
		
		CSD_Sales_Forecast__c csdFC11 = new CSD_Sales_Forecast__c();
		csdFC11.Type__c = 'Sold-To';
		csdFC11.GPL_Family__c = 'gplfamily';
		csdFC11.GPL_Code__c = 'gplcode';
		csdFC11.Fiscal_Year__c = '2015';
		csdFC11.Fiscal_Month__c = '9';
		csdFC11.Sold_To_Number__c = '1234:12345670';
		csdFC11.Sold_To_Name__c = 'Test';
		csdFC11.Forecast__c = 1000;
		csdFC11.Billing_Region__c = 'KOREA';
		csdFC11.Samsung_Type__c = 'Non Part';
		insert csdFC11;
		
		
		CSD_Sales_Forecast__c csdFC2 = new CSD_Sales_Forecast__c();
		csdFC2.type__c = 'OEM';
		csdFC2.GPL_Family__c = 'gplfamily';
		csdFC2.Fiscal_Year__c = '2015';
		csdFC2.Fiscal_Month__c = '9';
		csdFC2.Sold_To_Number__c = '1234:12345678';
		csdFC2.Sold_To_Name__c = 'Test';
		csdFC2.OEM__c = samsung.Id;
		csdFC2.Forecast__c = 1000;
		csdFC2.Billing_Region__c = 'KOREA';
		insert csdFC2;
		
		
		CSD_Sales_Forecast__c csdFC3 = new CSD_Sales_Forecast__c();
		csdFC3.type__c = 'Part';
		csdFC3.Fiscal_Year__c = '2015';
		csdFC3.Fiscal_Month__c = '9';
		csdFC3.Sold_To_Number__c = '1234:12345678';
		csdFC3.Sold_To_Name__c = 'Test';
		csdFC3.Part__c = part1.Id;
		csdFC3.Forecast__c = 100;
		csdFC3.OEM__c = samsung.Id;
		csdFC3.Price__c = 10;
		csdFC3.Quantity__c = 10;
		csdFC3.Billing_Region__c = 'KOREA';
		insert csdFC3;
		
		
		CSD_Sales_Forecast__c csdFCS1 = new CSD_Sales_Forecast__c();
		csdFCS1.Type__c = 'Sold-To';
		csdFCS1.GPL_Family__c = 'gplfamily';
		csdFCS1.GPL_Code__c = 'gplcode';
		csdFCS1.Fiscal_Year__c = '2016';
		csdFCS1.Fiscal_Month__c = '2';
		//csdFCS1.Sold_To_Number__c = '1234:12345678';
		csdFCS1.Sold_To_Name__c = 'Test';
		csdFCS1.Forecast__c = 1000;
		csdFCS1.Part__c = part1.Id;
		csdFCS1.Billing_Region__c = 'KOREA';
		csdFCS1.Samsung_Type__c = 'Non SoldTo';
		insert csdFCS1;
		
		CSD_Sales_Forecast__c csdFCS2 = new CSD_Sales_Forecast__c();
		csdFCS2.Type__c = 'Sold-To';
		csdFCS2.GPL_Family__c = 'gplfamily';
		csdFCS2.GPL_Code__c = 'gplcode';
		csdFCS2.Fiscal_Year__c = '2016';
		csdFCS2.Fiscal_Month__c = '3';
		csdFCS2.Sold_To_Number__c = null;
		csdFCS2.Sold_To_Name__c = 'Test';
		csdFCS2.Forecast__c = 1000;
		csdFCS2.Part__c = part1.Id;
		csdFCS2.Billing_Region__c = 'KOREA';
		csdFCS2.Samsung_Type__c = 'Non SoldTo';
		insert csdFCS2;
		
		
		CSD_Sales_Forecast__c csdFCS3 = new CSD_Sales_Forecast__c();
		csdFCS3.type__c = 'Sold-To';
		csdFCS3.GPL_Family__c = 'gplfamily';
		csdFCS3.Fiscal_Year__c = '2016';
		csdFCS3.Fiscal_Month__c = '4';
		csdFCS3.Sold_To_Number__c = '1234:12345679';
		csdFCS3.Sold_To_Name__c = 'Test';
		csdFCS3.OEM__c = samsung.Id;
		csdFCS3.Part__c = part1.Id;
		csdFCS3.Forecast__c = 1000;
		csdFCS3.Billing_Region__c = 'KOREA';
		csdFCS3.Samsung_Type__c = 'Non SoldTo';
		insert csdFCS3;
		
		
		CSD_Sales_Forecast__c csdFCS4 = new CSD_Sales_Forecast__c();
		csdFCS4.type__c = 'Sold-To';
		csdFCS4.Fiscal_Year__c = '2016';
		csdFCS4.Fiscal_Month__c = '5';
		csdFCS4.Sold_To_Number__c = '1234:12345678';
		csdFCS4.Sold_To_Name__c = 'Test';
		csdFCS4.Part__c = part1.Id;
		csdFCS4.Forecast__c = 100;
		csdFCS4.OEM__c = samsung.Id;
		csdFCS4.Price__c = 10;
		csdFCS4.Quantity__c = 10;
		csdFCS4.Billing_Region__c = 'KOREA';
		csdFCS4.Samsung_Type__c = 'Non SoldTo';
		insert csdFCS4;
		
		
    	
    	RecordType rt25 = ClsTestHelp.createTestRecordType25(); 
    	CSD_Forecast_Management__c csd = new CSD_Forecast_Management__c();
    	csd.Name = 'testName';
		csd.Role__c = 'Samsung GAM';
		csd.Region__c = 'AMERICAS';
		csd.WWAC_Code__c = '123412345678';
		csd.User__c = user.Id;
    	insert csd;

    	CSD_Samsung_Mapping__c summap = new CSD_Samsung_Mapping__c();
    	summap.Sales_Email__c = 'tetest@tetest.com';
    	summap.GPL_Family__c = 'gplfamily';
    	summap.GPL_Code__c = 'gplcode';
    	summap.Category__c = '1234:12345678';
    	summap.Part__c = part1.Id;
    	insert summap;
    	
    	CSD_Samsung_Mapping__c summap1 = new CSD_Samsung_Mapping__c();
    	summap1.Sales_Email__c = 'tetest@tetest.com';
    	summap1.GPL_Family__c = 'gplfamily';
    	summap1.GPL_Code__c = 'gplcode';
    	summap1.Category__c = '1234:12345679';
    	summap1.Part__c = part1.Id;
    	insert summap1;
    	
    	OEM_Details__c oemd = new OEM_Details__c();
    	oemd.OEM__c = samsung.Id;
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
        so.set_fiscalMonth.add('2015_9');
		so.set_fiscalMonth.add('2015_10');
        so.set_fiscalMonth.add('2015_11');
        so.set_fiscalMonth.add('2015_12');
        so.set_fiscalMonth.add('2016_1');
        so.set_fiscalMonth.add('2016_2');
        so.set_fiscalMonth.add('2016_3');
        so.set_fiscalMonth.add('2016_4');
        so.set_fiscalMonth.add('2016_5');
        so.set_fiscalMonth.add('2016_6');
        so.set_fiscalMonth.add('2016_7');
		
        so.map_year_monthsFuture = new map<String, set<Integer>>{
        	'2015'=> new set<Integer>{7,8,9,10,11,12},
        	'2016'=> new set<Integer>{1,2,3,4,5,6,7}
        };
        
        so.map_quarter_months =  new map<String, String>{
        	'01'=>'1,2,3',
        	'02'=>'4,5,6',
        	'03'=>'7,8,9',
        	'04'=>'10,11,12'
        };
        so.set_selectedId = new set<String>();
		so.startDate = '2015-07-15';
		so.endDate = '2016-08-15';
		so.managerId = user.Id;
		so.searchKey = '';
		//View Mode
		so.viewMode = 'view';
		so.isOtherMethod = false;
		so.gplfamily = 'gplfamily';
		so.oemId = samsung.Id;
        String sData = JSON.serialize(so);
		String result = '';
		
		system.runAs(user){
			Test.startTest();
			CSD_CtrlSamsungForecastView ctrl = new CSD_CtrlSamsungForecastView();
			CSD_ClsSamsungViewService.SearchLevel2 level2 = new CSD_ClsSamsungViewService.SearchLevel2();
			level2.getExistResult(sData);
			Test.stoptest();
		}
    }
}