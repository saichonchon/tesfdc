/**
*  This test class is for CSD_ClsBatch_calcForecastSnapshot.
*
@author Bin Yuan
@created 2014-12-09
@version 1.0
@since 30.0
*
@changelog
* 2014-12-09 Bin Yuan <bin.yuan@itbconsult.com>
* - Created
* - Test coverage 100%
*/
@isTest
private class CSD_ClsBatch_calcForecastSnapshot_Test {
    static testMethod void testMost() {
    	
    	Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();
        
    	RecordType rt = ClsTestHelp.createTestRecordType8();
    	
    	Consumer_Device_Opportunity_Record_Types__c cdort1 = ClsTestHelp.createTestCSD1();
    	Consumer_Device_Opportunity_Record_Types__c cdort2 = ClsTestHelp.createTestCSD2();
    	Consumer_Device_Opportunity_Record_Types__c cdort3 = ClsTestHelp.createTestCSD3();
    	Consumer_Device_Opportunity_Record_Types__c cdort4 = ClsTestHelp.createTestCSD4();
    	Consumer_Device_Opportunity_Record_Types__c cdort5 = ClsTestHelp.createTestCSD5();
    	Consumer_Device_Opportunity_Record_Types__c cdort6 = ClsTestHelp.createTestCSD6();
    	Consumer_Device_Opportunity_Record_Types__c cdort7 = ClsTestHelp.createTestCSD7();
    	
    	
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.RecordTypeId = rt.Id;
    	acc.SALES_TERRITORY_CDE__c = 'A003153';
    	acc.Individually_Planned__c = true;
    	acc.Account_Manager__c = UserInfo.getUserId();
    	acc.CurrencyIsoCode = 'AED';
    	insert acc;
    	
    	Date currentFiscalDate = CSD_ClsUtils.getCurrentFiscalDate();
    	currentFiscalDate = currentFiscalDate.addDays(3);
    	CSD_Sales_Forecast__c csdFC1 = new CSD_Sales_Forecast__c();
    	csdFC1.Sold_To__c = acc.Id;
    	csdFC1.Fiscal_Year__c = String.valueOf(currentFiscalDate.year());
    	csdFC1.Fiscal_Month__c = String.valueOf(currentFiscalDate.month());
    	csdFC1.Forecast__c = 10;
    	csdFC1.Previous_Month_Forecast__c = 10;
    	csdFC1.Previous_1_Month_Forecast__c = 10;
    	csdFC1.Previous_2_Month_Forecast__c = 10;
    	csdFC1.Previous_3_Month_Forecast__c = 10;
    	csdFC1.Previous_4_Month_Forecast__c = 10;
    	csdFC1.Previous_5_Month_Forecast__c = 10;
    	csdFC1.Previous_6_Month_Forecast__c = 10;
    	csdFC1.Previous_7_Month_Forecast__c = 10;
    	csdFC1.Previous_8_Month_Forecast__c = 10;
    	csdFC1.Previous_9_Month_Forecast__c = 10;
    	csdFC1.Previous_10_Month_Forecast__c = 10;
    	csdFC1.Previous_11_Month_Forecast__c = 10;
    	csdFC1.Quantity__c = 10;
    	csdFC1.Previous_Month_Quantity__c = 10;
    	csdFC1.Previous_1_Month_Quantity__c = 10;
    	csdFC1.Previous_2_Month_Quantity__c = 10;
    	csdFC1.Previous_3_Month_Quantity__c = 10;
    	csdFC1.Previous_4_Month_Quantity__c = 10;
    	csdFC1.Previous_5_Month_Quantity__c = 10;
    	csdFC1.Previous_6_Month_Quantity__c = 10;
    	csdFC1.Previous_7_Month_Quantity__c = 10;
    	csdFC1.Previous_8_Month_Quantity__c = 10;
    	csdFC1.Previous_9_Month_Quantity__c = 10;
    	csdFC1.Previous_10_Month_Quantity__c = 10;
    	csdFC1.Previous_11_Month_Quantity__c = 10;
    	insert csdFC1;
    	Test.startTest();
    	list<CSD_Sales_Forecast__c> scrope = new list<CSD_Sales_Forecast__c>();
    	scrope.add(csdFC1);
    	
    	CSD_ClsBatch_calcForecastSnapshot cls = new CSD_ClsBatch_calcForecastSnapshot();
    	//ID batchprocessid = Database.executeBatch(cls);
        Database.BatchableContext bc;
		cls.start(bc);
        cls.execute(bc, scrope);
        cls.isFail = false;
        cls.finish(bc); 
    	Test.stopTest();
    }
    static testMethod void testFailureCase() {
    	
    	Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();
        
    	RecordType rt = ClsTestHelp.createTestRecordType8();
    	
    	Consumer_Device_Opportunity_Record_Types__c cdort1 = ClsTestHelp.createTestCSD1();
    	Consumer_Device_Opportunity_Record_Types__c cdort2 = ClsTestHelp.createTestCSD2();
    	Consumer_Device_Opportunity_Record_Types__c cdort3 = ClsTestHelp.createTestCSD3();
    	Consumer_Device_Opportunity_Record_Types__c cdort4 = ClsTestHelp.createTestCSD4();
    	Consumer_Device_Opportunity_Record_Types__c cdort5 = ClsTestHelp.createTestCSD5();
    	Consumer_Device_Opportunity_Record_Types__c cdort6 = ClsTestHelp.createTestCSD6();
    	Consumer_Device_Opportunity_Record_Types__c cdort7 = ClsTestHelp.createTestCSD7();
    	
    	
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.RecordTypeId = rt.Id;
    	acc.SALES_TERRITORY_CDE__c = 'A003153';
    	acc.Individually_Planned__c = true;
    	acc.Account_Manager__c = UserInfo.getUserId();
    	acc.CurrencyIsoCode = 'AED';
    	insert acc;
    	
    	Date currentFiscalDate = CSD_ClsUtils.getCurrentFiscalDate();
    	currentFiscalDate = currentFiscalDate.addDays(3);
    	CSD_Sales_Forecast__c csdFC1 = new CSD_Sales_Forecast__c();
    	csdFC1.Sold_To__c = acc.Id;
    	csdFC1.Fiscal_Year__c = String.valueOf(currentFiscalDate.year());
    	csdFC1.Fiscal_Month__c = String.valueOf(currentFiscalDate.month());
    	csdFC1.Forecast__c = 10;
    	csdFC1.Previous_Month_Forecast__c = 10;
    	csdFC1.Previous_1_Month_Forecast__c = 10;
    	csdFC1.Previous_2_Month_Forecast__c = 10;
    	csdFC1.Previous_3_Month_Forecast__c = 10;
    	csdFC1.Previous_4_Month_Forecast__c = 10;
    	csdFC1.Previous_5_Month_Forecast__c = 10;
    	csdFC1.Previous_6_Month_Forecast__c = 10;
    	csdFC1.Previous_7_Month_Forecast__c = 10;
    	csdFC1.Previous_8_Month_Forecast__c = 10;
    	csdFC1.Previous_9_Month_Forecast__c = 10;
    	csdFC1.Previous_10_Month_Forecast__c = 10;
    	csdFC1.Previous_11_Month_Forecast__c = 10;
    	csdFC1.Quantity__c = 10;
    	csdFC1.Previous_Month_Quantity__c = 10;
    	csdFC1.Previous_1_Month_Quantity__c = 10;
    	csdFC1.Previous_2_Month_Quantity__c = 10;
    	csdFC1.Previous_3_Month_Quantity__c = 10;
    	csdFC1.Previous_4_Month_Quantity__c = 10;
    	csdFC1.Previous_5_Month_Quantity__c = 10;
    	csdFC1.Previous_6_Month_Quantity__c = 10;
    	csdFC1.Previous_7_Month_Quantity__c = 10;
    	csdFC1.Previous_8_Month_Quantity__c = 10;
    	csdFC1.Previous_9_Month_Quantity__c = 10;
    	csdFC1.Previous_10_Month_Quantity__c = 10;
    	csdFC1.Previous_11_Month_Quantity__c = 10;
    	insert csdFC1;
    	Test.startTest();
    	list<CSD_Sales_Forecast__c> scrope = new list<CSD_Sales_Forecast__c>();
    	scrope.add(csdFC1);
    	
    	CSD_ClsBatch_calcForecastSnapshot cls = new CSD_ClsBatch_calcForecastSnapshot();
    	//ID batchprocessid = Database.executeBatch(cls);
        Database.BatchableContext bc;
		cls.start(bc);
        cls.execute(bc, scrope);
        cls.isFail = true;
        cls.finish(bc); 
    	Test.stopTest();
    }
}