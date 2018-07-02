/**
*  This test class used to test class ClsAPLRSMForecastUtil.
*
@author Lili Zhao
@created 2014-08-15
*
@changelog
* coverage  92%
*  
2014-08-15 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest
private class ClsAPLServiceGAM_Test {

    static testMethod void myUnitTest() {
    	
    	
    	RecordType rt2 = ClsTestHelp.createTestRecordType8();
    	
    	ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
    	
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
        acct.STATDESC__c = 'Active';
    	insert acct;
    	
    	Account relayAcct = ClsTestHelp.createTestAccounts();
    	relayAcct.Name = 'relayAcctaxx';
        relayAcct.STATDESC__c = 'Active';
    	relayAcct.RecordTypeId = rt2.Id;
    	relayAcct.Account_Manager__c = userInfo.getUserId();
    	relayAcct.APL_Relay_forecast_Plan_Account__c = acct.Id;
    	relayAcct.APL_Relay_Currency__c = 'USD';
    	relayAcct.APL_Relay_Display_Name__c = 'testName';
    	relayAcct.APL_Relay_ParentAccount__c = acct.Id;
    	relayAcct.Relay_Specialist_Territory_Code__c = 'test';   
    	relayAcct.GAMCD__c = '1234'; 
    	relayAcct.Sales_Hierarchy__c = sh.Id;	
    	//insert relayAcct;
    	
    	Account relayAcct1 = ClsTestHelp.createTestAccounts();
    	relayAcct1.Name = 'relayAcctaxx';
        relayAcct1.STATDESC__c = 'Active';
    	relayAcct1.RecordTypeId = rt2.Id;
    	relayAcct1.Account_Manager__c = userInfo.getUserId();
    	relayAcct1.APL_Relay_forecast_Plan_Account__c = null;
    	relayAcct1.APL_Relay_Currency__c = 'USD';
    	relayAcct1.APL_Relay_Display_Name__c = 'testName';
    	relayAcct1.APL_Relay_ParentAccount__c = acct.Id;
    	relayAcct1.Relay_Specialist_Territory_Code__c = 'test';   
    	relayAcct1.GAMCD__c = '1234'; 	
    	//insert relayAcct1;
    	
    	Account amAcct = ClsTestHelp.createTestAccounts();
    	amAcct.Name = 'axx';
        amAcct.STATDESC__c = 'Active';
    	amAcct.RecordTypeId = rt2.Id;
    	amAcct.APL_AM_forecast_Plan_Account__c = acct.Id;
    	amAcct.APL_AM_Currency__c = 'USD';
    	amAcct.APL_AM_Display_Name__c = 'amName';
    	amAcct.APL_AM_ParentAccount__c = acct.Id;    	
    	amAcct.Account_Manager__c = userInfo.getUserId();
    	amAcct.SALES_TERRITORY_CDE__c = 'test';
    	amAcct.GAMCD__c = '1234';
    	amAcct.Sales_Hierarchy__c = sh.Id;	
    	//insert amAcct;
    	
    	Account amAcct1 = ClsTestHelp.createTestAccounts();
    	amAcct1.Name = 'axx';
        amAcct1.STATDESC__c = 'Active';
    	amAcct1.RecordTypeId = rt2.Id;
    	amAcct1.APL_AM_forecast_Plan_Account__c = null;
    	amAcct1.APL_AM_Currency__c = 'USD';
    	amAcct1.APL_AM_Display_Name__c = 'amName';
    	amAcct1.APL_AM_ParentAccount__c = acct.Id;    	
    	amAcct1.Account_Manager__c = userInfo.getUserId();
    	amAcct1.SALES_TERRITORY_CDE__c = 'test';
    	amAcct1.GAMCD__c = '1234';
        //amAcct1.Territory_L2_code__c = '103004';
        insert new List<Account>{relayAcct, relayAcct1, amAcct, amAcct1};
    	
    	Product_Hierarchy__c ph = new Product_Hierarchy__c();
    	ph.Name = '123';
    	ph.CBC2__c = '30012';
    	ph.CBC1_Description__c = 'Appliances';
        //insert ph;
        
        Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
    	ph1.Name = '1234';
    	ph1.CBC2__c = '13213';
    	ph1.CBC1_Description__c = 'Appliances';
        insert new List<Product_Hierarchy__c>{ph, ph1};
        
        Part__c part = new Part__c();
        part.Name = 'testPart';
        part.GPL__c = ph.Id;
        part.Product_Hierarchy__c = ph.Id; 
        part.Description__c = 'test';
        insert part;
    	
    	APL_Sales_Forecast__c aplFC1 = new APL_Sales_Forecast__c();
		aplFC1.type__c = 'GPL';
		aplFC1.Fiscal_Year__c = '2014';
		aplFC1.Fiscal_Quarter__c = '04';
		aplFC1.customer__c = amAcct.Id;
		aplFC1.GPL__c = ph.Id;
		aplFC1.Part__c = part.Id;
        //aplFC1.Territory_L2_code__c = '12';
		//insert aplFC1;
		
		APL_Sales_Forecast__c aplFC2 = new APL_Sales_Forecast__c();
		aplFC2.type__c = 'Relay';
		aplFC2.Fiscal_Year__c = '2014';
		aplFC2.Fiscal_Quarter__c = '04';
		aplFC2.customer__c = relayAcct.Id;
		aplFC2.Part__c = part.Id;
		aplFC2.GPL__c = ph1.Id;
        
        insert new List<APL_Sales_Forecast__c>{aplFC1, aplFC2};
		
		ClsAPLEntityTypes.PageConfig pageConf = new ClsAPLEntityTypes.PageConfig();
		pageConf.set_gamCodes.add('1234'); 
		pageConf.map_year_quartersFuture.put('2014', new set<String>());
    	pageConf.map_year_quartersFuture.get('2014').add('04');
    	PageConf.managerId = userInfo.getUserId();
    	
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
    	apl.GAM_Code__c = '1234';
    	apl.RecordTypeId = rt25.Id;
    	//insert apl;
    	
    	APL_Forecast_Management__c apl1 = new APL_Forecast_Management__c();
    	apl1.Name = 'testName1';
    	apl1.A6_Code__c = '1234567';
    	apl1.GAM_Code__c = '1234';
    	apl1.Manager__c = userInfo.getUserId();
    	apl1.RecordTypeId = rt25.Id;
    	apl.RSM__c = aplRsm1.Id;
        insert new List<APL_Forecast_Management__c>{apl, apl1};
    	
    	BBB_Month_Bill_Book_Cust_PN__c bbbMon = new BBB_Month_Bill_Book_Cust_PN__c();
    	bbbMon.Customer__c = amAcct.Id;
    	bbbMon.Bill_Amount_USD__c = 10;
    	bbbMon.Book_Amount_USD__c = 10; 
    	bbbMon.Fiscal_Year__c = '2014';
    	bbbMon.Fiscal_Month__c = 4;
    	bbbMon.Profit_Center__c = 'APL';
    	bbbMon.Part__c = part.Id;
    	insert bbbMon;
    	
    	BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c bbbDay = new BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c();
    	bbbDay.Backlog_Amount_USD__c = 10;
    	bbbDay.Bill_Amount_USD__c = 10; 
    	bbbDay.Book_Amount_USD__c = 10;
    	bbbDay.Customer__c = amAcct.Id;
    	bbbDay.Fiscal_Year__c = '2014';
    	bbbDay.Fiscal_Month__c = 4;
    	bbbDay.Customer_Request_Date_Fiscal_Year__c = '2014';
    	bbbday.Customer_Request_Date_Fiscal_Month__c = 4;
    	bbbDay.Profit_Center__c = 'APL';
    	bbbDay.Part__c = part.Id;
    	insert bbbDay;
    	
    	ClsAPLEntityTypes.GAMRegionFCInfo gamRegion = new ClsAPLEntityTypes.GAMRegionFCInfo();
    	gamRegion.set_gamCodes = new set<String>();
    	gamRegion.set_gamCodes.add('1234');
    	gamRegion.level2TerritoryCode = '103004';   
    	gamRegion.map_year_quartersFuture = new map<String, set<String>>();	
    	gamRegion.map_year_quartersFuture.put('2014', new set<String>());
    	gamRegion.map_year_quartersFuture.get('2014').add('04');    
    	gamRegion.map_year_monthsHistory = new map<String, set<Integer>>();	
    	gamRegion.map_year_monthsHistory.put('2014', new set<Integer>());
    	gamRegion.map_year_monthsHistory.get('2014').add(4);
    	gamRegion.map_year_monthsFuture = new map<String, set<Integer>>();
    	gamRegion.map_year_monthsFuture.put('2014', new set<Integer>());
    	gamRegion.map_year_monthsFuture.get('2014').add(4);
    	gamRegion.refStartDate = '2014-04';
    	gamRegion.periodStartDate = '2014-04';
    	gamRegion.refEndDate = '2014-04';
    	gamRegion.currentYear = '2014';
    	gamRegion.currentMonth = 4;
        //gamRegion.level2TerritoryCode = '12';
    	
    	ClsAPLEntityTypes.GAMAcctFCInfo gamAcct = new ClsAPLEntityTypes.GAMAcctFCInfo();
    	gamAcct.acctId = amAcct.Id;
    	gamAcct.set_acctIds = new set<String>();
    	gamAcct.set_acctIds.add(amAcct.Id);
    	gamAcct.set_acctIds.add(relayAcct.Id);
    	gamAcct.map_year_quartersFuture = new map<String, set<String>>();	
    	gamAcct.map_year_quartersFuture.put('2014', new set<String>());
    	gamAcct.map_year_quartersFuture.get('2014').add('04'); 
    	gamAcct.list_dateKey = new list<String>();
    	gamAcct.list_dateKey.add('2014_4');
    	gamAcct.list_dateKey.add('2014_4');
    	gamAcct.list_dateKey.add('2014_4');
    	//list_dateKey.add('2014_4');
    	gamAcct.currentYear = '2014';
    	gamAcct.currentMonth = 4;
    	
    	ClsAPLEntityTypes.GAMAcctFCInfo gamAcct1 = new ClsAPLEntityTypes.GAMAcctFCInfo();
    	gamAcct1.set_acctIds = new set<String>();
    	gamAcct1.set_acctIds.add(amAcct.Id);
    	gamAcct1.set_acctIds.add(relayAcct.Id);
    	gamAcct1.acctId = amAcct.Id;
    	gamAcct1.map_year_quartersFuture = new map<String, set<String>>();	
    	gamAcct1.map_year_quartersFuture.put('2014', new set<String>());
    	gamAcct1.map_year_quartersFuture.get('2014').add('04'); 
    	gamAcct1.list_dateKey = new list<String>();
    	gamAcct1.list_dateKey.add('2013_4');
    	gamAcct1.list_dateKey.add('2014_4');
    	gamAcct1.list_dateKey.add('2015_4');
    	gamAcct1.currentYear = '2014';
    	gamAcct1.currentMonth = 4;
    	
    	ClsAPLEntityTypes.GAMAcctFCInfo gamAcct2 = new ClsAPLEntityTypes.GAMAcctFCInfo();
    	gamAcct2.set_acctIds = new set<String>();
    	gamAcct2.set_acctIds.add(amAcct.Id);
    	gamAcct2.set_acctIds.add(relayAcct.Id);
    	gamAcct2.acctId = amAcct.Id;
    	gamAcct2.map_year_quartersFuture = new map<String, set<String>>();	
    	gamAcct2.map_year_quartersFuture.put('2014', new set<String>());
    	gamAcct2.map_year_quartersFuture.get('2014').add('04'); 
    	gamAcct2.list_dateKey = new list<String>();
    	gamAcct2.list_dateKey.add('2013_4');
    	gamAcct2.list_dateKey.add('2014_4');
    	gamAcct2.list_dateKey.add('2015_4');
    	gamAcct2.currentYear = '2016';
    	gamAcct2.currentMonth = 4;
    	
    	map<String, set<Integer>> map_fiscalMonth = new map<String, set<Integer>>();
        map_fiscalMonth.put('2014', new set<Integer>());
        map_fiscalMonth.get('2014').add(4);
        
        ClsAPLEntityTypes.GAMCBCFCInfo gamCBC = new ClsAPLEntityTypes.GAMCBCFCInfo();
        gamCBC.acctId = amAcct.Id;
        gamCBC.cbcCode = '30012';
        gamCBC.map_year_quartersFuture = new map<String, set<String>>();	
    	gamCBC.map_year_quartersFuture.put('2014', new set<String>());
    	gamCBC.map_year_quartersFuture.get('2014').add('04'); 
    	gamCBC.map_cbcRowKey_cbcName = new map<String, String>();
    	gamCBC.map_cbcRowKey_cbcName.put('30012', 'Power/Signal');
    	gamCBC.list_dateKey = new list<String>();
    	gamCBC.list_dateKey.add('2014_4');
    	gamCBC.list_dateKey.add('2014_4');
    	gamCBC.list_dateKey.add('2014_4');
    	gamCBC.currentYear = '2014';
    	gamCBC.currentMonth = 4;
    	
    	ClsAPLEntityTypes.GAMCBCFCInfo gamCBC1 = new ClsAPLEntityTypes.GAMCBCFCInfo();
        gamCBC1.acctId = amAcct.Id;
        gamCBC1.cbcCode = '30012';
        gamCBC1.map_year_quartersFuture = new map<String, set<String>>();	
    	gamCBC1.map_year_quartersFuture.put('2014', new set<String>());
    	gamCBC1.map_year_quartersFuture.get('2014').add('04'); 
    	gamCBC1.map_cbcRowKey_cbcName = new map<String, String>();
    	gamCBC1.map_cbcRowKey_cbcName.put('30012', 'Power/Signal');
    	gamCBC1.list_dateKey = new list<String>();
    	gamCBC1.list_dateKey.add('2013_4');
    	gamCBC1.list_dateKey.add('2014_4');
    	gamCBC1.list_dateKey.add('2015_4');
    	gamCBC1.currentYear = '2016';
    	gamCBC1.currentMonth = 4;
    	
    	ClsAPLEntityTypes.GAMCBCFCInfo gamCBC2 = new ClsAPLEntityTypes.GAMCBCFCInfo();
        gamCBC2.acctId = amAcct.Id;
        gamCBC2.cbcCode = '30012';
        gamCBC2.map_year_quartersFuture = new map<String, set<String>>();	
    	gamCBC2.map_year_quartersFuture.put('2014', new set<String>());
    	gamCBC2.map_year_quartersFuture.get('2014').add('04'); 
    	gamCBC2.map_cbcRowKey_cbcName = new map<String, String>();
    	gamCBC2.map_cbcRowKey_cbcName.put('30012', 'Power/Signal');
    	gamCBC2.list_dateKey = new list<String>();
    	gamCBC2.list_dateKey.add('2013_4');
    	gamCBC2.list_dateKey.add('2014_4');
    	gamCBC2.list_dateKey.add('2015_4');
    	gamCBC2.currentYear = '2014';
    	gamCBC2.currentMonth = 4;
    	
    	ClsAPLEntityTypes.GAMGPLFCInfo gamGPL = new ClsAPLEntityTypes.GAMGPLFCInfo();
    	gamGPL.cbc2Code = '30012';
    	gamGPL.acctId = amAcct.Id;
    	gamGPL.gplId =  ph.Id;
    	gamGPL.map_year_quartersFuture = new map<String, set<String>>();	
    	gamGPL.map_year_quartersFuture.put('2014', new set<String>());
    	gamGPL.map_year_quartersFuture.get('2014').add('04'); 
    	gamGPL.list_dateKey = new list<String>();
    	gamGPL.list_dateKey.add('2014_4');
    	gamGPL.list_dateKey.add('2014_4');
    	gamGPL.list_dateKey.add('2014_4');
    	gamGPL.currentYear = '2014';
    	gamGPL.currentMonth = 4;
    	
    	ClsAPLEntityTypes.GAMGPLFCInfo gamGPL1 = new ClsAPLEntityTypes.GAMGPLFCInfo();
    	gamGPL1.cbc2Code = '30012';
    	gamGPL1.acctId = amAcct.Id;
    	gamGPL1.gplId =  ph.Id;
    	gamGPL1.map_year_quartersFuture = new map<String, set<String>>();	
    	gamGPL1.map_year_quartersFuture.put('2014', new set<String>());
    	gamGPL1.map_year_quartersFuture.get('2014').add('04'); 
    	gamGPL1.list_dateKey = new list<String>();
    	gamGPL1.list_dateKey.add('2013_4');
    	gamGPL1.list_dateKey.add('2014_4');
    	gamGPL1.list_dateKey.add('2014_4');
    	gamGPL1.currentYear = '2015';
    	gamGPL1.currentMonth = 4;
    	
    	ClsAPLEntityTypes.GAMGPLFCInfo gamGPL2 = new ClsAPLEntityTypes.GAMGPLFCInfo();
    	gamGPL2.cbc2Code = '30012';
    	gamGPL2.acctId = amAcct.Id;
    	gamGPL2.gplId =  ph.Id;
    	gamGPL2.map_year_quartersFuture = new map<String, set<String>>();	
    	gamGPL2.map_year_quartersFuture.put('2014', new set<String>());
    	gamGPL2.map_year_quartersFuture.get('2014').add('04'); 
    	gamGPL2.list_dateKey = new list<String>();
    	gamGPL2.list_dateKey.add('2013_4');
    	gamGPL2.list_dateKey.add('2014_4');
    	gamGPL2.list_dateKey.add('2015_4');
    	gamGPL2.currentYear = '2014';
    	gamGPL2.currentMonth = 4;
    	
    	ClsAPLEntityTypes.GAMGPLFCInfo gamGPLRelay = new ClsAPLEntityTypes.GAMGPLFCInfo();
    	gamGPLRelay.cbc2Code = '30012';
    	gamGPLRelay.acctId = relayAcct.Id;
    	gamGPLRelay.map_year_quartersFuture = new map<String, set<String>>();	
    	gamGPLRelay.map_year_quartersFuture.put('2014', new set<String>());
    	gamGPLRelay.map_year_quartersFuture.get('2014').add('04'); 
    	
    	ClsAPLEntityTypes.GAMPartFCInfo gamPart = new ClsAPLEntityTypes.GAMPartFCInfo();
    	gamPart.acctId = amAcct.Id;
    	gamPart.map_year_quartersFuture = new map<String, set<String>>();	
    	gamPart.map_year_quartersFuture.put('2014', new set<String>());
    	gamPart.map_year_quartersFuture.get('2014').add('04'); 
    	gamPart.cbc2Code = '30012';
    	gamPart.gplId = ph.Id;
    	gamPart.map_year_monthsHistory = new map<String, set<Integer>>();	
    	gamPart.map_year_monthsHistory.put('2014', new set<Integer>());
    	gamPart.map_year_monthsHistory.get('2014').add(4);
    	gamPart.map_year_monthsFuture = new map<String, set<Integer>>();
    	gamPart.map_year_monthsFuture.put('2014', new set<Integer>());
    	gamPart.map_year_monthsFuture.get('2014').add(4);
    	gamPart.refStartDate = '2014-04';
    	gamPart.periodStartDate = '2014-04';
    	gamPart.refEndDate = '2014-04';
    	gamPart.currentYear = '2014';
    	gamPart.currentMonth = 4;  
    	gamPart.map_dateKey_fc = new map<String, decimal>();
    	gamPart.map_dateKey_fc.put('2014_04', 20);
    	gamPart.map_dateKey_fc.put('2015_01', 20);
    	gamPart.map_dateKey_fc.put('2013_01', 20);  	
    	
    	ClsAPLEntityTypes.GAMGPLFCInfo gamGPLSave = new ClsAPLEntityTypes.GAMGPLFCInfo();
    	gamGPLSave.cbc2Code = '30012';
    	gamGPLSave.acctId = amAcct.Id;
    	gamGPLSave.gplId = ph.Id;
    	gamGPLSave.map_year_quartersFuture = new map<String, set<String>>();	
    	gamGPLSave.map_year_quartersFuture.put('2014', new set<String>());
    	gamGPLSave.map_year_quartersFuture.get('2014').add('04'); 
    	gamGPLSave.list_parts = new list<ClsAPLEntityTypes.GAMPartFCInfo>();
    	gamGPLSave.list_parts.add(gamPart);
    	gamGPLSave.map_dateKey_fc = new map<String, decimal>();
    	gamGPLSave.map_dateKey_fc.put('2014_04', 20);
    	gamGPLSave.map_dateKey_fc.put('2015_01', 20);
    	gamGPLSave.map_dateKey_fc.put('2013_01', 20);
    	
    	Test.startTest();
        ClsAPLServiceGAM.setRegionRow(new list<ClsAPLEntityTypes.AcctColumns>());
        ClsAPLServiceGAM.getAcctTotalFCQuery(pageConf, new list<ClsAPLEntityTypes.TotalFCViewFields>());
        ClsAPLServiceGAM.getAcctInfo(pageConf);
        ClsAPLServiceGAM.getGAMRegionFC(gamRegion);
        ClsAPLServiceGAM.getGAMRegionRefData(gamRegion);
        ClsAPLServiceGAM.getGAMAcctFC(gamAcct);
        ClsAPLServiceGAM.getGAMAcctRefData(gamAcct);        
        ClsAPLServiceGAM.getGAMAcctRefData(gamAcct1);
        ClsAPLServiceGAM.getGAMAcctRefData(gamAcct2);
        ClsAPLServiceGAM.getAcctHistoryRefData(amAcct.Id, '2014-04-01', '2014-04-01', gamAcct2.list_dateKey, new ClsAPLEntityTypes.AcctFCValueObj());
        ClsAPLServiceGAM.getAcctHisBacklogRefData(amAcct.Id, '2014-04-01', '2014-04-01',map_fiscalMonth, gamAcct2.list_dateKey, new ClsAPLEntityTypes.AcctFCValueObj());
        ClsAPLServiceGAM.getAcctCurrentRefData(amAcct.Id, '2014', 4, new ClsAPLEntityTypes.AcctFCValueObj());
        ClsAPLServiceGAM.getGAMCBCFC(gamCBC);
        ClsAPLServiceGAM.getGAMCBCRefData(gamCBC);
        ClsAPLServiceGAM.getGAMCBCRefData(gamCBC1);
        ClsAPLServiceGAM.getGAMCBCRefData(gamCBC2);        
        ClsAPLServiceGAM.getCBCHistoryRefData(amAcct.Id, '30012', '2014-04-01', '2014-04-01', gamCBC2.list_dateKey, new ClsAPLEntityTypes.CBCFCValueObj());
        ClsAPLServiceGAM.getCBCHisBacklogRefData(amAcct.Id, '30012', '2014-04-01', '2014-04-01', map_fiscalMonth, gamCBC2.list_dateKey, new ClsAPLEntityTypes.CBCFCValueObj());
        ClsAPLServiceGAM.getCBCCurrentRefData(amAcct.Id,'30012', '2014', 4, new ClsAPLEntityTypes.CBCFCValueObj());
        ClsAPLServiceGAM.getGAMGPLFC(gamGPL);
        ClsAPLServiceGAM.getGAMRelayCBCFC(gamGPLRelay);
        ClsAPLServiceGAM.getGAMGPLRefData(gamGPL);
        ClsAPLServiceGAM.getGAMGPLRefData(gamGPL1);
        ClsAPLServiceGAM.getGAMGPLRefData(gamGPL2);
        ClsAPLServiceGAM.getGPLHistoryRefData(amAcct.Id, ph.Id, '30012', '2014-04-01', '2014-04-01', gamGPL.list_dateKey, new ClsAPLEntityTypes.GPLFCValueObj());
        ClsAPLServiceGAM.getGPLHisBacklogRefData(amAcct.Id, ph.Id, '30012', '2014-04-01', '2014-04-01', map_fiscalMonth, gamGPL.list_dateKey, new ClsAPLEntityTypes.GPLFCValueObj());
        ClsAPLServiceGAM.getGPLCurrentRefData(amAcct.Id, ph.Id, '30012', '2014', 4, new ClsAPLEntityTypes.GPLFCValueObj());
        ClsAPLServiceGAM.getGAMPartFC(gamPart);
        ClsAPLServiceGAM.saveGAMAcctFC(new ClsAPLEntityTypes.GAMAcctFCInfo());
        ClsAPLServiceGAM.saveGAMGPLFC(gamGPLSave);
        
        
        Test.stopTest();
    }
}