/**
*  This test class used to test class ClsAPLRSMForecastUtil.
*
@author Lili Zhao
@created 2014-08-15
*
@changelog
* coverage  91%
*  
2014-08-15 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest
private class ClsAPLRSMForecastUtil_Test {

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
        
    	RecordType rt = ClsTestHelp.createTestRecordType6();
    	RecordType rt2 = ClsTestHelp.createTestRecordType8();
    	
    	Consumer_Device_Opportunity_Record_Types__c cdort1 = ClsTestHelp.createTestCSD1();
    	Consumer_Device_Opportunity_Record_Types__c cdort2 = ClsTestHelp.createTestCSD2();
    	Consumer_Device_Opportunity_Record_Types__c cdort3 = ClsTestHelp.createTestCSD3();
    	Consumer_Device_Opportunity_Record_Types__c cdort4 = ClsTestHelp.createTestCSD4();
    	Consumer_Device_Opportunity_Record_Types__c cdort5 = ClsTestHelp.createTestCSD5();
    	Consumer_Device_Opportunity_Record_Types__c cdort6 = ClsTestHelp.createTestCSD6();
    	Consumer_Device_Opportunity_Record_Types__c cdort7 = ClsTestHelp.createTestCSD7();
    	
    	Account acct = ClsTestHelp.createTestAccounts();
    	acct.Name = 'axx';
    	acct.RecordTypeId = rt2.Id;
    	acct.AccountNumber = '123456';
    	acct.STATDESC__c = 'active';
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
    	relayAcct.STATDESC__c = 'active';
    	relayAcct.Account_Manager__c = userInfo.getUserId();
    	relayAcct.APL_Relay_forecast_Plan_Account__c = acct.Id;
    	relayAcct.APL_Relay_Currency__c = 'USD';
    	relayAcct.APL_Relay_Display_Name__c = 'testName';
    	relayAcct.APL_Relay_ParentAccount__c = acct.Id;
    	relayAcct.Relay_Specialist_Territory_Code__c = 'test';    	
    	insert relayAcct;
    	
    	Account relayAcct1 = ClsTestHelp.createTestAccounts();
    	relayAcct1.Name = 'relayAcctaxx';
    	relayAcct1.RecordTypeId = rt2.Id;
    	relayAcct1.STATDESC__c = 'active';
    	relayAcct1.Account_Manager__c = userInfo.getUserId();
    	relayAcct1.APL_Relay_forecast_Plan_Account__c = null;
    	relayAcct1.APL_Relay_Currency__c = 'USD';
    	relayAcct1.APL_Relay_Display_Name__c = 'testName';
    	relayAcct1.APL_Relay_ParentAccount__c = acct.Id;
    	relayAcct1.Relay_Specialist_Territory_Code__c = 'test';    	
    	insert relayAcct1;
    	
    	Account amAcct = ClsTestHelp.createTestAccounts();
    	amAcct.Name = 'axx';
    	amAcct.STATDESC__c = 'active';
    	amAcct.RecordTypeId = rt2.Id;
    	amAcct.APL_AM_forecast_Plan_Account__c = acct.Id;
    	amAcct.APL_AM_Currency__c = 'USD';
    	amAcct.APL_AM_Display_Name__c = 'amName';
    	amAcct.APL_AM_ParentAccount__c = acct.Id;    	
    	amAcct.Account_Manager__c = userInfo.getUserId();
    	amAcct.SALES_TERRITORY_CDE__c = 'test';
    	insert amAcct;
    	
    	Account amAcct1 = ClsTestHelp.createTestAccounts();
    	amAcct1.Name = 'axx';
    	amAcct1.STATDESC__c = 'active';
    	amAcct1.RecordTypeId = rt2.Id;
    	amAcct1.APL_AM_forecast_Plan_Account__c = null;
    	amAcct1.APL_AM_Currency__c = 'USD';
    	amAcct1.APL_AM_Display_Name__c = 'amName';
    	amAcct1.APL_AM_ParentAccount__c = acct.Id;    	
    	amAcct1.Account_Manager__c = userInfo.getUserId();
    	amAcct1.SALES_TERRITORY_CDE__c = 'test';
    	insert amAcct1;
    	    	
		APL_RSM__c aplRsm1 = new APL_RSM__c();
		aplRsm1.Manager__c = userInfo.getUserId();
		aplRsm1.Type__c = 'Relay';
		aplRsm1.Display_Name__c = 'test2';
		insert aplRsm1;
		
		APL_RSM__c aplRsm = new APL_RSM__c();
		aplRsm.Manager__c = userInfo.getUserId();
		aplRsm.Type__c = 'AM';
		aplRsm.Display_Name__c = 'test1';
		aplRsm.APL_RSM__c = aplRsm1.Id;
		insert aplRsm;		
    	
    	RecordType rt25 = ClsTestHelp.createTestRecordType25(); 
    	APL_Forecast_Management__c apl = new APL_Forecast_Management__c();
    	apl.Name = 'testName';
    	apl.A6_Code__c = '123456';
    	apl.Manager__c = userInfo.getUserId();  
    	apl.RSM__c = aplRsm.Id;
    	apl.RecordTypeId = rt25.Id;
    	insert apl;
    	
    	APL_Forecast_Management__c apl1 = new APL_Forecast_Management__c();
    	apl1.Name = 'testName1';
    	apl1.A6_Code__c = '1234567';
    	apl1.Manager__c = userInfo.getUserId();
    	apl1.RecordTypeId = rt25.Id;
    	apl.RSM__c = aplRsm1.Id;
    	insert apl1;
    	
    	Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
    	sh.Level_7_Territory_Code__c = '1234567';
        insert sh;
    	
    	ClsAPLEntityTypes.RSMAcctFCInfo rsmAcct = new ClsAPLEntityTypes.RSMAcctFCInfo();
    	rsmAcct.territoryCode = 'test';
    	
    	ClsAPLEntityTypes.RSMRelayAcctFCInfo rsmAcct1 = new ClsAPLEntityTypes.RSMRelayAcctFCInfo();
    	rsmAcct1.territoryCode = 'test';
    	
    	ClsAPLEntityTypes.PageConfig pageConf = new ClsAPLEntityTypes.PageConfig();
    	pageConf.managerId = userInfo.getUserId();
    	
    	Test.startTest();
    	ClsAPLRSMForecastUtil.getAMAcctGroup(rsmAcct);
    	ClsAPLRSMForecastUtil.getRSMRelayAcctGroup(rsmAcct1);
    	ClsAPLRSMForecastUtil.getTerritoryInfo(pageConf);
    	Test.stopTest();
    }
}