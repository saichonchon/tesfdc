/**
*  This test class used to test class ClsAcctGroupingUtil.
*
@author Lili Zhao
@created 2014-08-14
*
@changelog
* coverage  88%
*  
2014-08-14 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest
private class ClsAcctGroupingUtil_Test {

    static testMethod void getAcctHieraychy_Test() {
    	
    	
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
    	acct.APL_Relay_forecast_Plan_Account__c = acct.Id;
    	acct.APL_Relay_Currency__c = 'USD';
    	acct.APL_Relay_Display_Name__c = 'testName';
    	acct.APL_AM_forecast_Plan_Account__c = acct.Id;
    	acct.APL_AM_Currency__c = 'USD';
    	acct.APL_AM_Display_Name__c = 'amName';
    	acct.Account_Manager__c = userInfo.getUserId();
    	acct.STATDESC__c = 'active';
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
    	amAcct.RecordTypeId = rt2.Id;
    	amAcct.STATDESC__c = 'active';
    	amAcct.APL_AM_forecast_Plan_Account__c = acct.Id;
    	amAcct.APL_AM_Currency__c = 'USD';
    	amAcct.APL_AM_Display_Name__c = 'amName';
    	amAcct.APL_AM_ParentAccount__c = acct.Id;    	
    	amAcct.Account_Manager__c = userInfo.getUserId();
    	amAcct.SALES_TERRITORY_CDE__c = 'test';
    	insert amAcct;
    	
    	Account amAcct1 = ClsTestHelp.createTestAccounts();
    	amAcct1.Name = 'axx';
    	amAcct1.RecordTypeId = rt2.Id;
    	amAcct1.STATDESC__c = 'active';
    	amAcct1.APL_AM_forecast_Plan_Account__c = null;
    	amAcct1.APL_AM_Currency__c = 'USD';
    	amAcct1.APL_AM_Display_Name__c = 'amName';
    	amAcct1.APL_AM_ParentAccount__c = acct.Id;    	
    	amAcct1.Account_Manager__c = userInfo.getUserId();
    	amAcct1.SALES_TERRITORY_CDE__c = 'test';
    	insert amAcct1;
    	
    	list<ClsAcctGroupingUtil.ParentAcctObj> list_parentAccts = new list<ClsAcctGroupingUtil.ParentAcctObj>();    	
    	ClsAcctGroupingUtil.ParentAcctObj parentAcctObj = new ClsAcctGroupingUtil.ParentAcctObj();
    	parentAcctObj.parentAcctId = acct.Id;
    	
    	parentAcctObj.list_childAccts = new list<ClsAcctGroupingUtil.ChildAcctObj>();
    	ClsAcctGroupingUtil.ChildAcctObj childAcctObj = new ClsAcctGroupingUtil.ChildAcctObj();
    	childAcctObj.acctId = amAcct.Id;
    	
    	parentAcctObj.list_childAccts.add(childAcctObj);
    	list_parentAccts.add(parentAcctObj);
    	
    	CtrlAccountGrouping.PageConfig pageConfAM = new CtrlAccountGrouping.PageConfig();
    	pageConfAM.territoryCode = 'test';
    	pageConfAM.isRelay = false;
    	pageConfAM.map_acctId_acct.put(amAcct.Id, amAcct);
    	pageConfAM.set_modifiedAcctIds.add(amAcct.Id);
    	pageConfAM.set_modifiedAcctIds.add(amAcct1.Id);
    	pageConfAM.set_modifiedAcctIds.add(relayAcct1.Id);
    	
    	CtrlAccountGrouping.PageConfig pageConfRelay = new CtrlAccountGrouping.PageConfig();
    	pageConfRelay.isRelay = true;
    	pageConfRelay.territoryCode = 'test';
    	pageConfRelay.currentYear = '2013';
    	pageConfRelay.set_modifiedAcctIds.add(amAcct.Id);
    	pageConfRelay.set_modifiedAcctIds.add(relayAcct.Id);
    	pageConfRelay.set_modifiedAcctIds.add(relayAcct1.Id);
    	
    	CtrlAccountGrouping.PageConfig pageConf = new CtrlAccountGrouping.PageConfig();
    	pageConf.map_acctId_acct.put(amAcct.Id, amAcct);
    	
    	APL_Sales_Forecast__c aplFC1 = new APL_Sales_Forecast__c();
		aplFC1.type__c = 'GPL';
		aplFC1.customer__c = amAcct.Id;
		insert aplFC1;
		
		APL_Sales_Forecast__c aplFC2 = new APL_Sales_Forecast__c();
		aplFC2.type__c = 'Relay';
		aplFC2.Fiscal_Year__c = '2014';
		aplFC2.customer__c = relayAcct.Id;
		insert aplFC2;
    	
    	
        Test.startTest();
        ClsAcctGroupingUtil.updateAcctForGrouping(pageConf);
        
		ClsAcctGroupingUtil.getAcctHieraychy('', list_parentAccts, pageConfAM);
		ClsAcctGroupingUtil.getAcctHieraychy('', list_parentAccts, pageConfRelay);
		ClsAcctGroupingUtil.saveAcctGroup(list_parentAccts, pageConfAM);
		ClsAcctGroupingUtil.checkAcctIsChanged(list_parentAccts, pageConfAM);
		
		ClsAcctGroupingUtil.generateAcctInfo(ClsAcctGroupingUtil.OTHERAcctId, 'USD',  'testName', relayAcct1, true);
		ClsAcctGroupingUtil.generateAcctInfo(relayAcct.Id, 'USD',  'testName', relayAcct, true);
		ClsAcctGroupingUtil.generateAcctInfo(ClsAcctGroupingUtil.OTHERAcctId, 'USD',  'testName', amAcct1, false);
		ClsAcctGroupingUtil.generateAcctInfo(amAcct.Id, 'USD',  'testName',amAcct, false);
		ClsAcctGroupingUtil.checkAcctInfo('oldParentId', 'oldCurrency', 'newCurrency', 'newParentId', acct, new CtrlAccountGrouping.PageConfig());
		ClsAcctGroupingUtil.updateAcctForecast(pageConfAM);
		ClsAcctGroupingUtil.updateAcctForecast(pageConfRelay);
		ClsAcctGroupingUtil.removeRelayOtherFC(pageConfRelay);
		Test.stopTest();
    }
    
    static testMethod void checkIfRelayOrAM_Test() {
    	RecordType rt25 = ClsTestHelp.createTestRecordType25(); 
    	APL_Forecast_Management__c apl = new APL_Forecast_Management__c();
    	apl.Name = 'testName';
    	apl.A6_Code__c = '123456';
    	apl.Manager__c = userInfo.getUserId();  
    	apl.RecordTypeId = rt25.Id;
    	insert apl;
    	
    	APL_Forecast_Management__c apl1 = new APL_Forecast_Management__c();
    	apl1.Name = 'testName1';
    	apl1.A6_Code__c = '1234567';
    	apl1.Manager__c = userInfo.getUserId();
    	apl1.RecordTypeId = rt25.Id;
    	insert apl1;
    	
    	CtrlAccountGrouping.PageConfig pageConf = new CtrlAccountGrouping.PageConfig();
    	
    	Test.startTest();
		ClsAcctGroupingUtil.checkIfRelayOrAM(userInfo.getUserId(), new map<String, list<ClsAPLEntityTypes.AcctGroupingTerritroy>>(), pageConf);
		ClsAcctGroupingUtil.checkAccountChanged(new list<ClsAcctGroupingUtil.ParentAcctObj>(), new list<ClsAcctGroupingUtil.ParentAcctObj>(), new CtrlAccountGrouping.PageConfig());
		Test.stopTest();
    }
}