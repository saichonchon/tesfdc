/**
*	This test class is for CSD_CtrlSamsungForecastView.
*
@author Minghao Li
@created 2014-09-24
@version 1.0
@since 30.0
*
@changelog
* 2014-09-24 Minghao Li <minghao.li@itbconsult.com>
* - Created
* - Test coverage 90%
*/
@isTest
private class CSD_CtrlSamsungForecastView_Test {

    static testMethod void myUnitTest() {
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();
        
    	//RecordType rt = ClsTestHelp.createTestRecordType8();
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
    	
    	
    	Account samsung = ClsTestHelp.createTestAccounts();
    	samsung.Name = 'samsung';
    	samsung.RecordTypeId = rtoem.Id;
    	samsung.Account_Manager__c = UserInfo.getUserId();
    	samsung.Design_In_Region__c = 'KOREA';
    	samsung.STATDESC__c = 'Active';
    	samsung.Active__c = true;
    	insert samsung;
    	
    	CSD_Forecast_Management__c csd = new CSD_Forecast_Management__c();
    	csd.Name = 'testName';
		csd.Role__c = 'Samsung GAM';
		csd.Region__c = 'AMERICAS';
		csd.WWAC_Code__c = '123412345678';
		csd.User__c = UserInfo.getUserId();
    	insert csd;
    	
    	CSD_Configuration__c setting = new CSD_Configuration__c();
		setting.Name = 'Samsung OEM Account';
		setting.Value__c = samsung.Id;
		insert setting;
		
		CSD_Configuration__c setting2 = new CSD_Configuration__c();
		setting2.Name = 'Non OEM Account';
		setting2.Value__c = samsung.Id;
		insert setting2;
    	
        // TO DO: implement unit test
        test.startTest();
        
        CSD_CtrlSamsungForecastView sfv = new CSD_CtrlSamsungForecastView();
        sfv.getThis();
		/*
		sfv.setPartColumns();
		sfv.setPopupColumnsLevle1();
		sfv.setPopupColumnsLevle2();
		sfv.setPopupColumnsLevle3();
		sfv.setGPLCodeColumns();
		sfv.setGPLFamilyColumns();
		sfv.setList_GPLData();
		sfv.setList_allDateItems();
		*/
        test.stopTest();
    }
}