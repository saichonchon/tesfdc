/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class CSD_CtrlGAMViewForecast_Test {

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
    	
    	Consumer_Device_Opportunity_Record_Types__c cdort1 = ClsTestHelp.createTestCSD1();
    	Consumer_Device_Opportunity_Record_Types__c cdort2 = ClsTestHelp.createTestCSD2();
    	Consumer_Device_Opportunity_Record_Types__c cdort3 = ClsTestHelp.createTestCSD3();
    	Consumer_Device_Opportunity_Record_Types__c cdort4 = ClsTestHelp.createTestCSD4();
    	Consumer_Device_Opportunity_Record_Types__c cdort5 = ClsTestHelp.createTestCSD5();
    	Consumer_Device_Opportunity_Record_Types__c cdort6 = ClsTestHelp.createTestCSD6();
    	Consumer_Device_Opportunity_Record_Types__c cdort7 = ClsTestHelp.createTestCSD7();
        
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
    	sh.Level_2_Territory_Code__c = '103004';
        insert sh;

    	Account acct1 = ClsTestHelp.createTestAccounts();
    	acct1.Name = 'axx';
    	acct1.RecordTypeId = rtsoldto.Id;
    	acct1.AccountNumber = '1234:12345678';
    	acct1.Account_Manager__c = userInfo.getUserId();
    	acct1.STATDESC__c = 'Active';
    	acct1.SALES_TERRITORY_CDE__c = '123456';
    	acct1.Relay_Specialist_Territory_Code__c = '123456';  
    	acct1.Sales_Hierarchy__c = sh.Id;	 
    	acct1.Active__c = true;
    	insert acct1;
    	
    	Account acct2 = ClsTestHelp.createTestAccounts();
    	acct2.Name = 'relayAcctaxx';
    	acct2.RecordTypeId = rtoem.Id;
    	acct2.Account_Manager__c = userInfo.getUserId();
    	acct2.Active__c = true;
    	insert acct2;

    	
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
		csdFC1.Fiscal_Year__c = '2015';
		csdFC1.Fiscal_Month__c = '9';
		csdFC1.Sold_To_Number__c = '1234:12345678';
		csdFC1.Sold_To_Name__c = 'Test';
		csdFC1.Forecast__c = 1000;
		csdFC1.Billing_Region__c = 'AMERICAS';
		insert csdFC1;
		
		CSD_Sales_Forecast__c csdFC2 = new CSD_Sales_Forecast__c();
		csdFC2.type__c = 'OEM';
		csdFC2.Fiscal_Year__c = '2015';
		csdFC2.Fiscal_Month__c = '9';
		csdFC2.Sold_To_Number__c = '1234:12345678';
		csdFC2.Sold_To_Name__c = 'Test';
		csdFC2.OEM__c = acct2.Id;
		csdFC2.Forecast__c = 1000;
		csdFC2.Billing_Region__c = 'AMERICAS';
		insert csdFC2;
		
		
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
		insert csdFC3;
		

    	
    	RecordType rt25 = ClsTestHelp.createTestRecordType25(); 
    	CSD_Forecast_Management__c csd = new CSD_Forecast_Management__c();
    	csd.Name = 'testName';
		csd.Role__c = 'Sales Leader';
		csd.User__c = userInfo.getUserId();
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
        so.set_fiscalMonth.add('2015_5');
		so.set_fiscalMonth.add('2015_9');
        so.set_fiscalMonth.add('2015_8');
		
        so.map_year_monthsFuture = new map<String, set<Integer>>{
        	'2015'=> new set<Integer>{3,4,5,6,7,8,9,10,11}
        };
        
		so.startDate = '2015-03-15';
		so.endDate = '2015-11-15';

        String sData = JSON.serialize(so);
		String result = '';
		
		test.startTest();
		
		CSD_CtrlGAMViewForecast ctrl = new CSD_CtrlGAMViewForecast();
		ctrl.getThis();
		
		test.stopTest();
    }
}