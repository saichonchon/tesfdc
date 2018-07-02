/**
*	This test class is for CSD_CtrlSoldToForecast.
*
@author Minghao Li
@created 2014-09-24
@version 1.0
@since 30.0
*
@changelog
* 2014-09-24 Minghao Li <minghao.li@itbconsult.com>
* - Created
* - Test coverage 76%
*/
@isTest
private class CSD_CtrlSoldToForecast_Test {

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
    	RecordType rt2 = ClsTestHelp.createTestRecordType8();
    	
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
    	
    	Account acct = ClsTestHelp.createTestAccounts();
    	acct.Name = 'axx';
    	acct.RecordTypeId = rt2.Id;
    	acct.AccountNumber = '123456';
    	acct.APL_Relay_forecast_Plan_Account__c = acct.Id;
    	acct.APL_Relay_Currency__c = 'USD';
    	acct.APL_Relay_Display_Name__c = 'testName';
    	acct.APL_AM_forecast_Plan_Account__c = acct.Id;
    	acct.APL_AM_Currency__c = 'USD';
    	acct.APL_AM_Display_Name__c = 'amName';
    	acct.Account_Manager__c = userInfo.getUserId();
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
    	relayAcct.Relay_Specialist_Territory_Code__c = 'test';   
    	relayAcct.GAMCD__c = '1234'; 
    	relayAcct.Sales_Hierarchy__c = sh.Id;	
    	relayAcct.SALES_TERRITORY_CDE__c = 'test';
    	insert relayAcct;
    	
    	Account relayAcct1 = ClsTestHelp.createTestAccounts();
    	relayAcct1.Name = 'relayAcctaxx';
    	relayAcct1.RecordTypeId = rt2.Id;
    	relayAcct1.Account_Manager__c = userInfo.getUserId();
    	relayAcct1.APL_Relay_forecast_Plan_Account__c = null;
    	relayAcct1.APL_Relay_Currency__c = 'USD';
    	relayAcct1.APL_Relay_Display_Name__c = 'testName';
    	relayAcct1.APL_Relay_ParentAccount__c = acct.Id;
    	relayAcct1.Relay_Specialist_Territory_Code__c = 'test';   
    	relayAcct1.GAMCD__c = '1234'; 	
    	relayAcct1.SALES_TERRITORY_CDE__c = 'test';
    	insert relayAcct1;
    	
    	Account amAcct = ClsTestHelp.createTestAccounts();
    	amAcct.Name = 'axx';
    	amAcct.RecordTypeId = rt2.Id;
    	amAcct.APL_AM_forecast_Plan_Account__c = acct.Id;
    	amAcct.APL_AM_Currency__c = 'USD';
    	amAcct.APL_AM_Display_Name__c = 'amName';
    	amAcct.APL_AM_ParentAccount__c = acct.Id;    	
    	amAcct.Account_Manager__c = userInfo.getUserId();
    	amAcct.SALES_TERRITORY_CDE__c = 'test';
    	amAcct.GAMCD__c = '1234';
    	amAcct.Sales_Hierarchy__c = sh.Id;	
    	insert amAcct;
    	
    	Account amAcct1 = ClsTestHelp.createTestAccounts();
    	amAcct1.Name = 'axx';
    	amAcct1.RecordTypeId = rt2.Id;
    	amAcct1.APL_AM_forecast_Plan_Account__c = null;
    	amAcct1.APL_AM_Currency__c = 'USD';
    	amAcct1.APL_AM_Display_Name__c = 'amName';
    	amAcct1.APL_AM_ParentAccount__c = acct.Id;    	
    	amAcct1.Account_Manager__c = userInfo.getUserId();
    	amAcct1.SALES_TERRITORY_CDE__c = 'test';
    	amAcct.GAMCD__c = '1234';
    	amAcct.Sales_Hierarchy__c = sh.Id;	
    	insert amAcct1;
    	
        // TO DO: implement unit test
        test.startTest();
        
        CSD_CtrlSoldToForecast soldto = new CSD_CtrlSoldToForecast();
        soldto.getThis();
        soldto.setList_allDateItems();
        soldto.setList_soldToData();
        soldto.setTotalColumns();
        soldto.setSoldToColumns();
        soldto.setOEMColumns();
        soldto.setPartColumns();
        soldto.setPopupColumnsLevle1();
        soldto.setPopupColumnsLevle2();
        soldto.setPopupColumnsLevle3();
        
        CSD_ClsEntityType.SearchObj so= new CSD_ClsEntityType.SearchObj();
        so.searchKey = 'testKey';
        so.set_selectedId = null;
        so.set_deletedId = null;
        so.accnumber = '104565';
        so.oemId = amAcct.Id;
		so.startDate = '2015-01-15';
		so.endDate = '2016-06-15';
		so.managerId = UserInfo.getUserId();
		so.map_year_monthsFuture = new map<String, set<Integer>>();
    	so.map_year_monthsFuture.put('2014', new set<Integer>());
    	so.map_year_monthsFuture.get('2014').add(4);
		
		
    	CSD_CtrlSoldToForecast.saveSoldToEOL( JSON.serialize(so) );
        CSD_CtrlSoldToForecast.searchKeyPart( JSON.serialize(so) );
        CSD_CtrlSoldToForecast.autoCreateOEMForecast( JSON.serialize(so) );
        CSD_CtrlSoldToForecast.hasKeyPart( JSON.serialize(so) );
        
        
        test.stopTest();
    }
}