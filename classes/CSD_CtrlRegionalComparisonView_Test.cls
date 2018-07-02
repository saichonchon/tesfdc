/**
*	This test class is for CSD_CtrlRegionalComparisonView.
*
@author Minghao Li
@created 2014-09-24
@version 1.0
@since 30.0
*
@changelog
* 2014-09-24 Minghao Li <minghao.li@itbconsult.com>
* - Created
* - Test coverage 91%
*/
@isTest
private class CSD_CtrlRegionalComparisonView_Test {

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
        
        CSD_CtrlRegionalComparisonView regional = new CSD_CtrlRegionalComparisonView();
        regional.getThis();
        regional.refreshData();
        
        test.stopTest();
    }
    
    static testMethod void myUnitTest2() {
    	CSD_ClsUtils.Convert15CharTo18CharId('test12351874859685');
		CSD_ClsUtils.Convert15CharTo18CharId('onvert15chartto');
		
		CSD_ClsUtils.encryptionFormID('testEncryptionFromID');
		CSD_ClsUtils.decryptionFormInput('testPassword');
		
		CSD_ClsEntityType.LocaleConfig config = new CSD_ClsEntityType.LocaleConfig();
		String userLocal = 'German';
		CSD_ClsUtils.setUserLocale(config, userLocal);
		
		CSD_ClsUtils.getStartDate('2015_9');
		CSD_ClsUtils.getEndDate('2015_9');
		
		List<String> list_str = new List<String>{'2015_1'};
		CSD_ClsUtils.getFiscalMonthMap(list_str);
		
		CSD_ClsUtils.getRelayPartQuery();
		
		set<string> set_str = new set<string>{'test'};
		map<string,set<string>> map_year_quarter = new map<string,set<string>>();
		map_year_quarter.put('2014',set_str);
		CSD_ClsUtils.getMonthFilter(map_year_quarter);
		
		String [] params;
		CSD_ClsUtils.getQueryString(params);
		
		CSD_ClsUtils.getHexUID();
		
		CSD_ClsUtils.getManageUserId(null);
		CSD_ClsUtils.getManageUserId(UserInfo.getUserId());
		
		list<string> list_formatStr = new list<string>{'test','test1'};
		CSD_ClsUtils.getFormatString(list_formatStr);
		
		CSD_ClsUtils.getFiscalDate();
    }
    
    
}