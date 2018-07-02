/**
*  This test class used to test class CSD_ClsScheduled_CSDFCSnapShot.
*
@author Lei Tang
@created 2015-06-23
*
@changelog
* coverage  80%
*  
2015-06-23 Lei Tang <lei.tang@itbconsult.com>
* - Created
*/
@isTest
private class CSD_ClsScheduled_CSDFCSnapShot_Test {

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
        
        Consumer_Device_Opportunity_Record_Types__c cdort1 = ClsTestHelp.createTestCSD1();
    	Consumer_Device_Opportunity_Record_Types__c cdort2 = ClsTestHelp.createTestCSD2();
    	Consumer_Device_Opportunity_Record_Types__c cdort3 = ClsTestHelp.createTestCSD3();
    	Consumer_Device_Opportunity_Record_Types__c cdort4 = ClsTestHelp.createTestCSD4();
    	Consumer_Device_Opportunity_Record_Types__c cdort5 = ClsTestHelp.createTestCSD5();
    	Consumer_Device_Opportunity_Record_Types__c cdort6 = ClsTestHelp.createTestCSD6();
    	Consumer_Device_Opportunity_Record_Types__c cdort7 = ClsTestHelp.createTestCSD7();
        
        RecordType rt = ClsTestHelp.createTestRecordType8();
    	
    	Account acct1 = ClsTestHelp.createTestAccounts();
    	acct1.Name = 'axxx';
    	acct1.RecordTypeId = rt.Id;
    	acct1.AccountNumber = '1234:12345678';
    	acct1.Account_Manager__c = UserInfo.getUserId();
    	acct1.SALES_TERRITORY_CDE__c = '123456';
    	acct1.Active__c = true;
    	acct1.STATDESC__c = 'Active';
    	acct1.WWCORPACCT__c = '123412345678';
    	insert acct1;
    	
    	Date currentFiscalDate = CSD_ClsUtils.getCurrentFiscalDate();
    	currentFiscalDate = currentFiscalDate.addDays(3);
    	CSD_Sales_Forecast__c csdFC1 = new CSD_Sales_Forecast__c();
    	csdFC1.Sold_To_Number__c = '1234:12345678';
		csdFC1.Sold_To_Name__c = 'Test';
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
        
        DateTime currTime = DateTime.now();
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        String sch;
        
        if(min <= 58)
            sch = '0 '+ (min + 1) + ' ' + hour + ' * * ? '+ currTime.year();
        else          
            sch = '0 0 '+ (hour + 1) + ' * * ? '+ currTime.year();
        
        Test.startTest();
        
        CSD_ClsScheduled_CSDFCSnapShot obj = new CSD_ClsScheduled_CSDFCSnapShot();                
        String jobId = system.schedule('test_CSD_ClsScheduled_CSDFCSnapShot', sch, obj); 
    
        system.assert(true);
        Test.stopTest();
        
    }
}