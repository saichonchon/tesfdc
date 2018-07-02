/**
*  This test class used to test class ClsAPLEntityTypes.
*
@author Lili Zhao
@created 2014-08-15
*
@changelog
* coverage  99%
*  
2014-08-15 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest
private class ClsAPLEntityTypes_Test {
	static testMethod void entityType_test() {
		
		ClsAPLEntityTypes.RSMTotalFCInfo rsmTotal = new ClsAPLEntityTypes.RSMTotalFCInfo();
    	rsmTotal.list_dateKey = new list<String>();
    	rsmTotal.list_dateKey.add('2014_4');
    	rsmTotal.list_dateKey.add('2014_4');
    	rsmTotal.list_dateKey.add('2014_4');
    	rsmTotal.currentYear = '2014';
    	rsmTotal.currentMonth = 4;
    	rsmTotal.set_terrtoryCodes = new set<String>();
    	rsmTotal.set_terrtoryCodes.add('test');
    	rsmTotal.isTCProd = true;
    	String str_json = Json.serialize(rsmTotal);
    	
    	ClsAPLEntityTypes.RSMRelayTotalFCInfo rsmTotal1 = new ClsAPLEntityTypes.RSMRelayTotalFCInfo();
    	rsmTotal1.list_dateKey = new list<String>();
    	rsmTotal1.list_dateKey.add('2014_4');
    	rsmTotal1.list_dateKey.add('2014_4');
    	rsmTotal1.list_dateKey.add('2014_4');
    	rsmTotal1.currentYear = '2014';
    	rsmTotal1.currentMonth = 4;
    	rsmTotal1.set_terrtoryCodes = new set<String>();
    	rsmTotal1.set_terrtoryCodes.add('test');
    	String str_json1 = Json.serialize(rsmTotal1);
    	
    	ClsAPLEntityTypes.RSMTerritoryFCInfo rsmTerritory = new ClsAPLEntityTypes.RSMTerritoryFCInfo();
        rsmTerritory.territoryCode = 'test';
		rsmTerritory.map_year_quartersFuture = new map<String, set<String>>();	
    	rsmTerritory.map_year_quartersFuture.put('2014', new set<String>());
    	rsmTerritory.map_year_quartersFuture.get('2014').add('04');
    	rsmTerritory.list_dateKey = new list<String>();
    	rsmTerritory.list_dateKey.add('2014_4');
    	rsmTerritory.list_dateKey.add('2014_4');
    	rsmTerritory.list_dateKey.add('2014_4');
    	rsmTerritory.currentYear = '2014';
    	rsmTerritory.currentMonth = 4;    	
    	String str_json2 = Json.serialize(rsmTerritory);
    	
    	ClsAPLEntityTypes.RSMRelayTerritoryFCInfo rsmTerritory1 = new ClsAPLEntityTypes.RSMRelayTerritoryFCInfo();
		rsmTerritory1.territoryCode = 'test';
		rsmTerritory1.map_year_quartersFuture = new map<String, set<String>>();	
    	rsmTerritory1.map_year_quartersFuture.put('2014', new set<String>());
    	rsmTerritory1.map_year_quartersFuture.get('2014').add('04');
    	rsmTerritory1.list_dateKey = new list<String>();
    	rsmTerritory1.list_dateKey.add('2014_4');
    	rsmTerritory1.list_dateKey.add('2014_4');
    	rsmTerritory1.list_dateKey.add('2014_4');
    	rsmTerritory1.currentYear = '2014';
    	rsmTerritory1.currentMonth = 4;
    	String str_json3 = Json.serialize(rsmTerritory1);
    	
    	ClsAPLEntityTypes.RSMAcctFCInfo rsmAcct = new ClsAPLEntityTypes.RSMAcctFCInfo();
    	rsmAcct.territoryCode = 'test';
    	rsmAcct.acctId = 'other';
    	rsmAcct.map_year_quartersFuture = new map<String, set<String>>();	
    	rsmAcct.map_year_quartersFuture.put('2014', new set<String>());
    	rsmAcct.map_year_quartersFuture.get('2014').add('04');
    	rsmAcct.list_dateKey = new list<String>();
    	rsmAcct.list_dateKey.add('2014_4');
    	rsmAcct.list_dateKey.add('2014_4');
    	rsmAcct.list_dateKey.add('2014_4');
    	rsmAcct.currentYear = '2014';
    	rsmAcct.currentMonth = 4;
    	String str_json4 = Json.serialize(rsmAcct);
    	
    	ClsAPLEntityTypes.RSMAMOverRallInfo overRallInfo = new ClsAPLEntityTypes.RSMAMOverRallInfo();
    	overRallInfo.managerId = userInfo.getUserId();
    	overRallInfo.displayName = 'test';
    	overRallInfo.map_year_quartersFuture = new map<String, set<String>>();	
    	overRallInfo.map_year_quartersFuture.put('2014', new set<String>());
    	overRallInfo.map_year_quartersFuture.get('2014').add('04');
    	overRallInfo.map_dateKey_fc = new map<String, decimal>();
    	overRallInfo.map_dateKey_fc.put('2013_01', 20);
    	overRallInfo.map_dateKey_fc.put('2014_04', 20);
    	overRallInfo.map_dateKey_fc.put('2015_01', 20);
    	String str_json5 = Json.serialize(overRallInfo);
    	
    	ClsAPLEntityTypes.RSMRelayOverRallInfo overRallInfo1 = new ClsAPLEntityTypes.RSMRelayOverRallInfo();
    	overRallInfo1.set_displayNames = new set<String>();
		overRallInfo1.set_displayNames.add('test');
		overRallInfo1.set_rsmIds = new set<String>();
		overRallInfo1.map_year_quartersFuture = new map<String, set<String>>();	
    	overRallInfo1.map_year_quartersFuture.put('2014', new set<String>());
    	overRallInfo1.map_year_quartersFuture.get('2014').add('04');
    	overRallInfo1.map_name_map_dateKey_fc = new map<String, map<String,decimal>>();
    	overRallInfo1.map_name_map_dateKey_fc.put('test', new map<String,decimal>());
    	overRallInfo1.map_name_map_dateKey_fc.get('test').put('2013_01', 20);
    	overRallInfo1.map_name_map_dateKey_fc.get('test').put('2014_04', 20);
    	overRallInfo1.map_name_map_dateKey_fc.get('test').put('2015_01', 20);
    	String str_json6 = Json.serialize(overRallInfo1);
    	
    	ClsAPLEntityTypes.RSMRelayAcctFCInfo rsmAcct1 = new ClsAPLEntityTypes.RSMRelayAcctFCInfo();
    	rsmAcct1.territoryCode = 'test';
    	rsmAcct1.acctId = 'Other';
    	rsmAcct1.map_year_quartersFuture = new map<String, set<String>>();	
    	rsmAcct1.map_year_quartersFuture.put('2014', new set<String>());
    	rsmAcct1.map_year_quartersFuture.get('2014').add('04');
    	rsmAcct1.list_dateKey = new list<String>();
    	rsmAcct1.list_dateKey.add('2014_4');
    	rsmAcct1.list_dateKey.add('2014_4');
    	rsmAcct1.list_dateKey.add('2014_4');
    	rsmAcct1.currentYear = '2014';
    	rsmAcct1.currentMonth = 4;
		String str_json7 = Json.serialize(rsmAcct1);
		
		String str_json8 = Json.serialize(new ClsAPLEntityTypes.RelayAcctFCInfo());
		
		ClsAPLEntityTypes.GAMAcctFCInfo gamAcct = new ClsAPLEntityTypes.GAMAcctFCInfo();
    	gamAcct.acctId = '';
    	gamAcct.set_acctIds = new set<String>();
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
    	String str_json9 = Json.serialize(gamAcct);
    	
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
		String str_json10 = Json.serialize(gamRegion);
		
		ClsAPLEntityTypes.RSMCBCFCInfo rsmCBC = new ClsAPLEntityTypes.RSMCBCFCInfo();
    	rsmCBC.acctId = 'other';
    	rsmCBC.territoryCode = 'test';
    	rsmCBC.cbcCode = '30012';
    	rsmCBC.map_year_quartersFuture = new map<String, set<String>>();	
    	rsmCBC.map_year_quartersFuture.put('2014', new set<String>());
    	rsmCBC.map_year_quartersFuture.get('2014').add('04');
    	rsmCBC.list_dateKey = new list<String>();
    	rsmCBC.list_dateKey.add('2014_4');
    	rsmCBC.list_dateKey.add('2014_4');
    	rsmCBC.list_dateKey.add('2014_4');
    	rsmCBC.currentYear = '2014';
    	rsmCBC.currentMonth = 4;
    	rsmCBC.map_cbcRowKey_cbcName = new map<String, String>();
    	rsmCBC.map_cbcRowKey_cbcName.put('30012', 'Power/Signal');
    	String str_json11 = Json.serialize(rsmCBC);
    	
    	ClsAPLEntityTypes.RSMRelayCBCFCInfo rsmCBC1 = new ClsAPLEntityTypes.RSMRelayCBCFCInfo();
		rsmCBC1.acctId = 'other';
    	rsmCBC1.territoryCode = 'test';
    	rsmCBC1.cbc2Code = '13213';
    	rsmCBC1.map_year_quartersFuture = new map<String, set<String>>();	
    	rsmCBC1.map_year_quartersFuture.put('2014', new set<String>());
    	rsmCBC1.map_year_quartersFuture.get('2014').add('04');
    	rsmCBC1.list_dateKey = new list<String>();
    	rsmCBC1.list_dateKey.add('2014_4');
    	rsmCBC1.list_dateKey.add('2014_4');
    	rsmCBC1.list_dateKey.add('2014_4');
    	rsmCBC1.currentYear = '2014';
    	rsmCBC1.currentMonth = 4;
    	rsmCBC1.map_cbcRowKey_cbcName = new map<String, String>();
    	rsmCBC1.map_cbcRowKey_cbcName.put('13213', 'Power/Signal');
    	rsmCBC1.list_partFC = new list<ClsAPLEntityTypes.RelayPartFCInfo>();
    	String str_json12 = Json.serialize(rsmCBC1);
    	
    	ClsAPLEntityTypes.GAMCBCFCInfo gamCBC = new ClsAPLEntityTypes.GAMCBCFCInfo();
        gamCBC.acctId = '';
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
    	String str_json13 = Json.serialize(gamCBC);
    	
    	ClsAPLEntityTypes.RelayCBCFCInfo cbcFC = new ClsAPLEntityTypes.RelayCBCFCInfo();
    	cbcFC.parentId = 'other';
    	cbcFC.cbc2Code = '13213';
    	cbcFC.territoryCode = 'test';
    	cbcFC.quarterNumb = '02';
    	cbcFC.list_partFC = new list<ClsAPLEntityTypes.RelayPartFCInfo>();
    	String str_json14 = Json.serialize(cbcFC);
    	
    	ClsAPLEntityTypes.RSMGPLFCInfo rsmGPL = new ClsAPLEntityTypes.RSMGPLFCInfo();
    	rsmGPL.acctId = 'other';
    	rsmGPL.territoryCode = 'test';
    	rsmGPL.cbc2Code = '30012';
    	rsmGPL.gplId = '';
    	rsmGPL.map_year_quartersFuture = new map<String, set<String>>();	
    	rsmGPL.map_year_quartersFuture.put('2014', new set<String>());
    	rsmGPL.map_year_quartersFuture.get('2014').add('04');
    	rsmGPL.list_dateKey = new list<String>();
    	rsmGPL.list_dateKey.add('2014_4');
    	rsmGPL.list_dateKey.add('2014_4');
    	rsmGPL.list_dateKey.add('2014_4');
    	rsmGPL.currentYear = '2014';
    	rsmGPL.currentMonth = 4;
    	String str_json15 = Json.serialize(rsmGPL);
    	
    	ClsAPLEntityTypes.RSMRelayGPLFCInfo rsmPart = new ClsAPLEntityTypes.RSMRelayGPLFCInfo();
    	rsmPart.acctId = 'other';
    	rsmPart.territoryCode = 'test';
    	rsmPart.cbc2Code = '13213';
    	rsmPart.gplId = '';
    	rsmPart.map_year_quartersFuture = new map<String, set<String>>();	
    	rsmPart.map_year_quartersFuture.put('2014', new set<String>());
    	rsmPart.map_year_quartersFuture.get('2014').add('04');     	
    	rsmPart.map_year_monthsHistory = new map<String, set<Integer>>();	
    	rsmPart.map_year_monthsHistory.put('2014', new set<Integer>());
    	rsmPart.map_year_monthsHistory.get('2014').add(4);
    	rsmPart.map_year_monthsFuture = new map<String, set<Integer>>();
    	rsmPart.map_year_monthsFuture.put('2014', new set<Integer>());
    	rsmPart.map_year_monthsFuture.get('2014').add(4);
    	rsmPart.refStartDate = '2014-04-01';
    	rsmPart.periodStartDate = '2014-04-21';
    	rsmPart.refEndDate = '2014-04-01';
    	rsmPart.currentYear = '2014';
    	rsmPart.currentMonth = 4;  
    	rsmPart.map_dateKey_fc = new map<String, decimal>();
    	rsmPart.map_dateKey_fc.put('2014_04', 20);
    	rsmPart.map_dateKey_fc.put('2015_01', 20);
    	rsmPart.map_dateKey_fc.put('2013_01', 20);    	
    	String str_json16 = Json.serialize(rsmPart);
    	

    	
    	
    	
		
		Test.startTest();
		ClsAPLEntityTypes.MockObj mockObj = new ClsAPLEntityTypes.MockObj();
		ClsAPLEntityTypes.LocaleConfig local = new ClsAPLEntityTypes.LocaleConfig();
		ClsAPLEntityTypes.LocaleConfig local1 = new ClsAPLEntityTypes.LocaleConfig('test', 'test');
		ClsAPLEntityTypes.AcctColumns acctCol = new ClsAPLEntityTypes.AcctColumns('Test', 'Test', 'Test', 'Test', false);
		ClsAPLEntityTypes.AcctColumns acctCol1 = new ClsAPLEntityTypes.AcctColumns();
		ClsAPLEntityTypes.AcctGroupingTerritroy acctGroup = new ClsAPLEntityTypes.AcctGroupingTerritroy();
		ClsAPLEntityTypes.AcctGroupingTerritroy acctGroup2 = new ClsAPLEntityTypes.AcctGroupingTerritroy('Test', false);
		ClsAPLEntityTypes.DateItem dateItem = new ClsAPLEntityTypes.DateItem('Test');
		ClsAPLEntityTypes.PageConfig pageConf = new ClsAPLEntityTypes.PageConfig();
		ClsAPLEntityTypes.GAMAcctInfo gamAcct1 = new ClsAPLEntityTypes.GAMAcctInfo();
		ClsAPLEntityTypes.GAMRegionInfo gamRegion4 = new ClsAPLEntityTypes.GAMRegionInfo();
		ClsAPLEntityTypes.GAMRegionInfo gamRegion5 = new ClsAPLEntityTypes.GAMRegionInfo('Test', 'Test');
		ClsAPLEntityTypes.GAMRegionInfo gamRegion6 = new ClsAPLEntityTypes.GAMRegionInfo('Test', 'Test', 'Test');
		ClsAPLEntityTypes.RegionAccountInfo acctRegion = new ClsAPLEntityTypes.RegionAccountInfo();
		ClsAPLEntityTypes.RegionAccountInfo acctRegion2 = new ClsAPLEntityTypes.RegionAccountInfo('Test', 'Test');
		ClsAPLEntityTypes.RSMTerritoryInfo rsmTerritory11 = new ClsAPLEntityTypes.RSMTerritoryInfo();
		ClsAPLEntityTypes.RSMTerritoryInfo rsmTerritory22 = new ClsAPLEntityTypes.RSMTerritoryInfo('Test', 'Test');
		ClsAPLEntityTypes.RSMTerritoryInfo rsmTerritory33 = new ClsAPLEntityTypes.RSMTerritoryInfo('Test1', 'Test2', false);
		ClsAPLEntityTypes.RSMTerritoryInfo rsmTerritory44 = new ClsAPLEntityTypes.RSMTerritoryInfo('Test1', 'Test2', 'Test3', false);
		list<ClsAPLEntityTypes.RSMTerritoryInfo> list_Temp = new list<ClsAPLEntityTypes.RSMTerritoryInfo>();
		list_Temp.add(rsmTerritory11);
		list_Temp.add(rsmTerritory22);
		list_Temp.add(rsmTerritory33);
		list_Temp.add(rsmTerritory44);
		list_Temp.sort();
		
		ClsAPLEntityTypes.RSMAcctInfo rsmAcctInfo = new ClsAPLEntityTypes.RSMAcctInfo();
		ClsAPLEntityTypes.RSMTotalFCInfo rsmTotalInfo = new ClsAPLEntityTypes.RSMTotalFCInfo();
		rsmTotalInfo.getRefData(str_json);
		
		ClsAPLEntityTypes.RSMRelayTotalFCInfo rSMRelayTotalFCInfo = new ClsAPLEntityTypes.RSMRelayTotalFCInfo();
		rSMRelayTotalFCInfo.set_terrtoryCodes = new set<String>();
		rSMRelayTotalFCInfo.getRefData(str_json1);
		
		ClsAPLEntityTypes.RSMTerritoryFCInfo rSMTerritoryFCInfo = new ClsAPLEntityTypes.RSMTerritoryFCInfo();
		rSMTerritoryFCInfo.saveFC(str_json2);
		rSMTerritoryFCInfo.getFC(str_json2);
		rSMTerritoryFCInfo.getRefData(str_json2);
		
		ClsAPLEntityTypes.RSMRelayTerritoryFCInfo rSMRelayTerritoryFCInfo = new ClsAPLEntityTypes.RSMRelayTerritoryFCInfo();
		rSMRelayTerritoryFCInfo.saveFC(str_json3);
		rSMRelayTerritoryFCInfo.getFC(str_json3);
		rSMRelayTerritoryFCInfo.getRefData(str_json3);
		
		ClsAPLEntityTypes.RSMAcctFCInfo RSMAcctFCInfo = new ClsAPLEntityTypes.RSMAcctFCInfo();
		RSMAcctFCInfo.saveFC(str_json4);
		RSMAcctFCInfo.getFC(str_json4);
		RSMAcctFCInfo.getRefData(str_json4);
		
		ClsAPLEntityTypes.RSMAMOverRallInfo RSMAMOverRallInfo = new ClsAPLEntityTypes.RSMAMOverRallInfo();
		RSMAMOverRallInfo.saveFC(str_json5);
		RSMAMOverRallInfo.getFC(str_json5);
		
		ClsAPLEntityTypes.RSMRelayOverRallInfo RSMRelayOverRallInfo = new ClsAPLEntityTypes.RSMRelayOverRallInfo();
		RSMRelayOverRallInfo.saveFC(str_json6);
		RSMRelayOverRallInfo.getFC(str_json6);
		
		ClsAPLEntityTypes.RSMRelayAcctFCInfo RSMRelayAcctFCInfo = new ClsAPLEntityTypes.RSMRelayAcctFCInfo();
		RSMRelayAcctFCInfo.saveFC(str_json7);
		RSMRelayAcctFCInfo.getFC(str_json7);
		RSMRelayAcctFCInfo.getRefData(str_json7);
		
		ClsAPLEntityTypes.RelayAcctFCInfo RelayAcctFCInfo = new ClsAPLEntityTypes.RelayAcctFCInfo();
		RelayAcctFCInfo.saveFC(str_json8);
		RelayAcctFCInfo.getFC(str_json8);
		
		ClsAPLEntityTypes.RelayFC RelayFC = new ClsAPLEntityTypes.RelayFC();
		/*
		ClsAPLEntityTypes.GAMAcctFCInfo GAMAcctFCInfo = new ClsAPLEntityTypes.GAMAcctFCInfo();
		GAMAcctFCInfo.saveFC(str_json9);
		GAMAcctFCInfo.getFC(str_json9);
		GAMAcctFCInfo.getRefData(str_json9);
		
		ClsAPLEntityTypes.GAMRegionFCInfo GAMRegionFCInfo = new ClsAPLEntityTypes.GAMRegionFCInfo();
		GAMRegionFCInfo.getFC(str_json10);
		GAMRegionFCInfo.getRefData(str_json10);
		GAMRegionFCInfo.saveFC(str_json10);
		
		ClsAPLEntityTypes.RSMCBCFCInfo RSMCBCFCInfo = new ClsAPLEntityTypes.RSMCBCFCInfo();
		RSMCBCFCInfo.getFC(str_json11);
		RSMCBCFCInfo.getRefData(str_json11);
		RSMCBCFCInfo.saveFC(str_json11);
		
		ClsAPLEntityTypes.RSMRelayCBCFCInfo RSMRelayCBCFCInfo = new ClsAPLEntityTypes.RSMRelayCBCFCInfo();
		RSMRelayCBCFCInfo.getFC(str_json12);
		RSMRelayCBCFCInfo.getRefData(str_json12);
		RSMRelayCBCFCInfo.saveFC(str_json12);
		
		ClsAPLEntityTypes.GAMCBCFCInfo GAMCBCFCInfo = new ClsAPLEntityTypes.GAMCBCFCInfo();
		GAMCBCFCInfo.saveFC(str_json13);
		GAMCBCFCInfo.getFC(str_json13);
		GAMCBCFCInfo.getRefData(str_json13);
		
		ClsAPLEntityTypes.RelayCBCFCInfo RelayCBCFCInfo = new ClsAPLEntityTypes.RelayCBCFCInfo();
		RelayCBCFCInfo.getFC(str_json14);
		RelayCBCFCInfo.saveFC(str_json14);
		
		ClsAPLEntityTypes.RSMGPLFCInfo RSMGPLFCInfo = new ClsAPLEntityTypes.RSMGPLFCInfo();
		RSMGPLFCInfo.getFC(str_json15);
		RSMGPLFCInfo.getRefData(str_json15);
		RSMGPLFCInfo.saveFC(str_json15);
		
		ClsAPLEntityTypes.RSMRelayGPLFCInfo RSMRelayGPLFCInfo = new ClsAPLEntityTypes.RSMRelayGPLFCInfo();
		RSMRelayGPLFCInfo.getFC(str_json16);
		RSMRelayGPLFCInfo.saveFC(str_json15);*/

		Test.stopTest();
	}
	
	static testMethod void entityType_test2() {
		
		ClsAPLEntityTypes.RSMTotalFCInfo rsmTotal = new ClsAPLEntityTypes.RSMTotalFCInfo();
    	rsmTotal.list_dateKey = new list<String>();
    	rsmTotal.list_dateKey.add('2014_4');
    	rsmTotal.list_dateKey.add('2014_4');
    	rsmTotal.list_dateKey.add('2014_4');
    	rsmTotal.currentYear = '2014';
    	rsmTotal.currentMonth = 4;
    	rsmTotal.set_terrtoryCodes = new set<String>();
    	rsmTotal.set_terrtoryCodes.add('test');
    	rsmTotal.isTCProd = true;
    	String str_json = Json.serialize(rsmTotal);
    	
    	ClsAPLEntityTypes.RSMRelayTotalFCInfo rsmTotal1 = new ClsAPLEntityTypes.RSMRelayTotalFCInfo();
    	rsmTotal1.list_dateKey = new list<String>();
    	rsmTotal1.list_dateKey.add('2014_4');
    	rsmTotal1.list_dateKey.add('2014_4');
    	rsmTotal1.list_dateKey.add('2014_4');
    	rsmTotal1.currentYear = '2014';
    	rsmTotal1.currentMonth = 4;
    	rsmTotal1.set_terrtoryCodes = new set<String>();
    	rsmTotal1.set_terrtoryCodes.add('test');
    	String str_json1 = Json.serialize(rsmTotal1);
    	
    	ClsAPLEntityTypes.RSMTerritoryFCInfo rsmTerritory = new ClsAPLEntityTypes.RSMTerritoryFCInfo();
        rsmTerritory.territoryCode = 'test';
		rsmTerritory.map_year_quartersFuture = new map<String, set<String>>();	
    	rsmTerritory.map_year_quartersFuture.put('2014', new set<String>());
    	rsmTerritory.map_year_quartersFuture.get('2014').add('04');
    	rsmTerritory.list_dateKey = new list<String>();
    	rsmTerritory.list_dateKey.add('2014_4');
    	rsmTerritory.list_dateKey.add('2014_4');
    	rsmTerritory.list_dateKey.add('2014_4');
    	rsmTerritory.currentYear = '2014';
    	rsmTerritory.currentMonth = 4;    	
    	String str_json2 = Json.serialize(rsmTerritory);
    	
    	ClsAPLEntityTypes.RSMRelayTerritoryFCInfo rsmTerritory1 = new ClsAPLEntityTypes.RSMRelayTerritoryFCInfo();
		rsmTerritory1.territoryCode = 'test';
		rsmTerritory1.map_year_quartersFuture = new map<String, set<String>>();	
    	rsmTerritory1.map_year_quartersFuture.put('2014', new set<String>());
    	rsmTerritory1.map_year_quartersFuture.get('2014').add('04');
    	rsmTerritory1.list_dateKey = new list<String>();
    	rsmTerritory1.list_dateKey.add('2014_4');
    	rsmTerritory1.list_dateKey.add('2014_4');
    	rsmTerritory1.list_dateKey.add('2014_4');
    	rsmTerritory1.currentYear = '2014';
    	rsmTerritory1.currentMonth = 4;
    	String str_json3 = Json.serialize(rsmTerritory1);
    	
    	ClsAPLEntityTypes.RSMAcctFCInfo rsmAcct = new ClsAPLEntityTypes.RSMAcctFCInfo();
    	rsmAcct.territoryCode = 'test';
    	rsmAcct.acctId = 'other';
    	rsmAcct.map_year_quartersFuture = new map<String, set<String>>();	
    	rsmAcct.map_year_quartersFuture.put('2014', new set<String>());
    	rsmAcct.map_year_quartersFuture.get('2014').add('04');
    	rsmAcct.list_dateKey = new list<String>();
    	rsmAcct.list_dateKey.add('2014_4');
    	rsmAcct.list_dateKey.add('2014_4');
    	rsmAcct.list_dateKey.add('2014_4');
    	rsmAcct.currentYear = '2014';
    	rsmAcct.currentMonth = 4;
    	String str_json4 = Json.serialize(rsmAcct);
    	
    	ClsAPLEntityTypes.RSMAMOverRallInfo overRallInfo = new ClsAPLEntityTypes.RSMAMOverRallInfo();
    	overRallInfo.managerId = userInfo.getUserId();
    	overRallInfo.displayName = 'test';
    	overRallInfo.map_year_quartersFuture = new map<String, set<String>>();	
    	overRallInfo.map_year_quartersFuture.put('2014', new set<String>());
    	overRallInfo.map_year_quartersFuture.get('2014').add('04');
    	overRallInfo.map_dateKey_fc = new map<String, decimal>();
    	overRallInfo.map_dateKey_fc.put('2013_01', 20);
    	overRallInfo.map_dateKey_fc.put('2014_04', 20);
    	overRallInfo.map_dateKey_fc.put('2015_01', 20);
    	String str_json5 = Json.serialize(overRallInfo);
    	
    	ClsAPLEntityTypes.RSMRelayOverRallInfo overRallInfo1 = new ClsAPLEntityTypes.RSMRelayOverRallInfo();
    	overRallInfo1.set_displayNames = new set<String>();
		overRallInfo1.set_displayNames.add('test');
		overRallInfo1.set_rsmIds = new set<String>();
		overRallInfo1.map_year_quartersFuture = new map<String, set<String>>();	
    	overRallInfo1.map_year_quartersFuture.put('2014', new set<String>());
    	overRallInfo1.map_year_quartersFuture.get('2014').add('04');
    	overRallInfo1.map_name_map_dateKey_fc = new map<String, map<String,decimal>>();
    	overRallInfo1.map_name_map_dateKey_fc.put('test', new map<String,decimal>());
    	overRallInfo1.map_name_map_dateKey_fc.get('test').put('2013_01', 20);
    	overRallInfo1.map_name_map_dateKey_fc.get('test').put('2014_04', 20);
    	overRallInfo1.map_name_map_dateKey_fc.get('test').put('2015_01', 20);
    	String str_json6 = Json.serialize(overRallInfo1);
    	
    	ClsAPLEntityTypes.RSMRelayAcctFCInfo rsmAcct1 = new ClsAPLEntityTypes.RSMRelayAcctFCInfo();
    	rsmAcct1.territoryCode = 'test';
    	rsmAcct1.acctId = 'Other';
    	rsmAcct1.map_year_quartersFuture = new map<String, set<String>>();	
    	rsmAcct1.map_year_quartersFuture.put('2014', new set<String>());
    	rsmAcct1.map_year_quartersFuture.get('2014').add('04');
    	rsmAcct1.list_dateKey = new list<String>();
    	rsmAcct1.list_dateKey.add('2014_4');
    	rsmAcct1.list_dateKey.add('2014_4');
    	rsmAcct1.list_dateKey.add('2014_4');
    	rsmAcct1.currentYear = '2014';
    	rsmAcct1.currentMonth = 4;
		String str_json7 = Json.serialize(rsmAcct1);
		
		String str_json8 = Json.serialize(new ClsAPLEntityTypes.RelayAcctFCInfo());
		
		ClsAPLEntityTypes.GAMAcctFCInfo gamAcct = new ClsAPLEntityTypes.GAMAcctFCInfo();
    	gamAcct.acctId = '';
    	gamAcct.set_acctIds = new set<String>();
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
    	String str_json9 = Json.serialize(gamAcct);
    	
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
		String str_json10 = Json.serialize(gamRegion);
		
		ClsAPLEntityTypes.RSMCBCFCInfo rsmCBC = new ClsAPLEntityTypes.RSMCBCFCInfo();
    	rsmCBC.acctId = 'other';
    	rsmCBC.territoryCode = 'test';
    	rsmCBC.cbcCode = '30012';
    	rsmCBC.map_year_quartersFuture = new map<String, set<String>>();	
    	rsmCBC.map_year_quartersFuture.put('2014', new set<String>());
    	rsmCBC.map_year_quartersFuture.get('2014').add('04');
    	rsmCBC.list_dateKey = new list<String>();
    	rsmCBC.list_dateKey.add('2014_4');
    	rsmCBC.list_dateKey.add('2014_4');
    	rsmCBC.list_dateKey.add('2014_4');
    	rsmCBC.currentYear = '2014';
    	rsmCBC.currentMonth = 4;
    	rsmCBC.map_cbcRowKey_cbcName = new map<String, String>();
    	rsmCBC.map_cbcRowKey_cbcName.put('30012', 'Power/Signal');
    	String str_json11 = Json.serialize(rsmCBC);
    	
    	ClsAPLEntityTypes.RSMRelayCBCFCInfo rsmCBC1 = new ClsAPLEntityTypes.RSMRelayCBCFCInfo();
		rsmCBC1.acctId = 'other';
    	rsmCBC1.territoryCode = 'test';
    	rsmCBC1.cbc2Code = '13213';
    	rsmCBC1.map_year_quartersFuture = new map<String, set<String>>();	
    	rsmCBC1.map_year_quartersFuture.put('2014', new set<String>());
    	rsmCBC1.map_year_quartersFuture.get('2014').add('04');
    	rsmCBC1.list_dateKey = new list<String>();
    	rsmCBC1.list_dateKey.add('2014_4');
    	rsmCBC1.list_dateKey.add('2014_4');
    	rsmCBC1.list_dateKey.add('2014_4');
    	rsmCBC1.currentYear = '2014';
    	rsmCBC1.currentMonth = 4;
    	rsmCBC1.map_cbcRowKey_cbcName = new map<String, String>();
    	rsmCBC1.map_cbcRowKey_cbcName.put('13213', 'Power/Signal');
    	rsmCBC1.list_partFC = new list<ClsAPLEntityTypes.RelayPartFCInfo>();
    	String str_json12 = Json.serialize(rsmCBC1);
    	
    	ClsAPLEntityTypes.GAMCBCFCInfo gamCBC = new ClsAPLEntityTypes.GAMCBCFCInfo();
        gamCBC.acctId = '';
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
    	String str_json13 = Json.serialize(gamCBC);
    	
    	ClsAPLEntityTypes.RelayCBCFCInfo cbcFC = new ClsAPLEntityTypes.RelayCBCFCInfo();
    	cbcFC.parentId = 'other';
    	cbcFC.cbc2Code = '13213';
    	cbcFC.territoryCode = 'test';
    	cbcFC.quarterNumb = '02';
    	cbcFC.list_partFC = new list<ClsAPLEntityTypes.RelayPartFCInfo>();
    	String str_json14 = Json.serialize(cbcFC);
    	
    	ClsAPLEntityTypes.RSMGPLFCInfo rsmGPL = new ClsAPLEntityTypes.RSMGPLFCInfo();
    	rsmGPL.acctId = 'other';
    	rsmGPL.territoryCode = 'test';
    	rsmGPL.cbc2Code = '30012';
    	rsmGPL.gplId = '';
    	rsmGPL.map_year_quartersFuture = new map<String, set<String>>();	
    	rsmGPL.map_year_quartersFuture.put('2014', new set<String>());
    	rsmGPL.map_year_quartersFuture.get('2014').add('04');
    	rsmGPL.list_dateKey = new list<String>();
    	rsmGPL.list_dateKey.add('2014_4');
    	rsmGPL.list_dateKey.add('2014_4');
    	rsmGPL.list_dateKey.add('2014_4');
    	rsmGPL.currentYear = '2014';
    	rsmGPL.currentMonth = 4;
    	String str_json15 = Json.serialize(rsmGPL);
    	
    	ClsAPLEntityTypes.RSMRelayGPLFCInfo rsmPart = new ClsAPLEntityTypes.RSMRelayGPLFCInfo();
    	rsmPart.acctId = 'other';
    	rsmPart.territoryCode = 'test';
    	rsmPart.cbc2Code = '13213';
    	rsmPart.gplId = '';
    	rsmPart.map_year_quartersFuture = new map<String, set<String>>();	
    	rsmPart.map_year_quartersFuture.put('2014', new set<String>());
    	rsmPart.map_year_quartersFuture.get('2014').add('04');     	
    	rsmPart.map_year_monthsHistory = new map<String, set<Integer>>();	
    	rsmPart.map_year_monthsHistory.put('2014', new set<Integer>());
    	rsmPart.map_year_monthsHistory.get('2014').add(4);
    	rsmPart.map_year_monthsFuture = new map<String, set<Integer>>();
    	rsmPart.map_year_monthsFuture.put('2014', new set<Integer>());
    	rsmPart.map_year_monthsFuture.get('2014').add(4);
    	rsmPart.refStartDate = '2014-04-01';
    	rsmPart.periodStartDate = '2014-04-21';
    	rsmPart.refEndDate = '2014-04-01';
    	rsmPart.currentYear = '2014';
    	rsmPart.currentMonth = 4;  
    	rsmPart.map_dateKey_fc = new map<String, decimal>();
    	rsmPart.map_dateKey_fc.put('2014_04', 20);
    	rsmPart.map_dateKey_fc.put('2015_01', 20);
    	rsmPart.map_dateKey_fc.put('2013_01', 20);    	
    	String str_json16 = Json.serialize(rsmPart);
    	

    	
    	
    	
		
		Test.startTest();
		ClsAPLEntityTypes.MockObj mockObj = new ClsAPLEntityTypes.MockObj();
		ClsAPLEntityTypes.LocaleConfig local = new ClsAPLEntityTypes.LocaleConfig();
		ClsAPLEntityTypes.LocaleConfig local1 = new ClsAPLEntityTypes.LocaleConfig('test', 'test');
		ClsAPLEntityTypes.AcctColumns acctCol = new ClsAPLEntityTypes.AcctColumns('Test', 'Test', 'Test', 'Test', false);
		ClsAPLEntityTypes.AcctColumns acctCol1 = new ClsAPLEntityTypes.AcctColumns();
		ClsAPLEntityTypes.AcctGroupingTerritroy acctGroup = new ClsAPLEntityTypes.AcctGroupingTerritroy();
		ClsAPLEntityTypes.AcctGroupingTerritroy acctGroup2 = new ClsAPLEntityTypes.AcctGroupingTerritroy('Test', false);
		ClsAPLEntityTypes.DateItem dateItem = new ClsAPLEntityTypes.DateItem('Test');
		ClsAPLEntityTypes.PageConfig pageConf = new ClsAPLEntityTypes.PageConfig();
		ClsAPLEntityTypes.GAMAcctInfo gamAcct1 = new ClsAPLEntityTypes.GAMAcctInfo();
		ClsAPLEntityTypes.GAMRegionInfo gamRegion4 = new ClsAPLEntityTypes.GAMRegionInfo();
		ClsAPLEntityTypes.GAMRegionInfo gamRegion5 = new ClsAPLEntityTypes.GAMRegionInfo('Test', 'Test');
		ClsAPLEntityTypes.GAMRegionInfo gamRegion6 = new ClsAPLEntityTypes.GAMRegionInfo('Test', 'Test', 'Test');
		ClsAPLEntityTypes.RegionAccountInfo acctRegion = new ClsAPLEntityTypes.RegionAccountInfo();
		ClsAPLEntityTypes.RegionAccountInfo acctRegion2 = new ClsAPLEntityTypes.RegionAccountInfo('Test', 'Test');
		ClsAPLEntityTypes.RSMTerritoryInfo rsmTerritory11 = new ClsAPLEntityTypes.RSMTerritoryInfo();
		ClsAPLEntityTypes.RSMTerritoryInfo rsmTerritory22 = new ClsAPLEntityTypes.RSMTerritoryInfo('Test', 'Test');
		ClsAPLEntityTypes.RSMTerritoryInfo rsmTerritory33 = new ClsAPLEntityTypes.RSMTerritoryInfo('Test1', 'Test2', false);
		ClsAPLEntityTypes.RSMTerritoryInfo rsmTerritory44 = new ClsAPLEntityTypes.RSMTerritoryInfo('Test1', 'Test2', 'Test3', false);
		list<ClsAPLEntityTypes.RSMTerritoryInfo> list_Temp = new list<ClsAPLEntityTypes.RSMTerritoryInfo>();
		list_Temp.add(rsmTerritory11);
		list_Temp.add(rsmTerritory22);
		list_Temp.add(rsmTerritory33);
		list_Temp.add(rsmTerritory44);
		list_Temp.sort();
		/*
		ClsAPLEntityTypes.RSMAcctInfo rsmAcctInfo = new ClsAPLEntityTypes.RSMAcctInfo();
		ClsAPLEntityTypes.RSMTotalFCInfo rsmTotalInfo = new ClsAPLEntityTypes.RSMTotalFCInfo();
		rsmTotalInfo.getRefData(str_json);
		
		ClsAPLEntityTypes.RSMRelayTotalFCInfo rSMRelayTotalFCInfo = new ClsAPLEntityTypes.RSMRelayTotalFCInfo();
		rSMRelayTotalFCInfo.set_terrtoryCodes = new set<String>();
		rSMRelayTotalFCInfo.getRefData(str_json1);
		
		ClsAPLEntityTypes.RSMTerritoryFCInfo rSMTerritoryFCInfo = new ClsAPLEntityTypes.RSMTerritoryFCInfo();
		rSMTerritoryFCInfo.saveFC(str_json2);
		rSMTerritoryFCInfo.getFC(str_json2);
		rSMTerritoryFCInfo.getRefData(str_json2);
		
		ClsAPLEntityTypes.RSMRelayTerritoryFCInfo rSMRelayTerritoryFCInfo = new ClsAPLEntityTypes.RSMRelayTerritoryFCInfo();
		rSMRelayTerritoryFCInfo.saveFC(str_json3);
		rSMRelayTerritoryFCInfo.getFC(str_json3);
		rSMRelayTerritoryFCInfo.getRefData(str_json3);
		
		ClsAPLEntityTypes.RSMAcctFCInfo RSMAcctFCInfo = new ClsAPLEntityTypes.RSMAcctFCInfo();
		RSMAcctFCInfo.saveFC(str_json4);
		RSMAcctFCInfo.getFC(str_json4);
		RSMAcctFCInfo.getRefData(str_json4);
		
		ClsAPLEntityTypes.RSMAMOverRallInfo RSMAMOverRallInfo = new ClsAPLEntityTypes.RSMAMOverRallInfo();
		RSMAMOverRallInfo.saveFC(str_json5);
		RSMAMOverRallInfo.getFC(str_json5);
		
		ClsAPLEntityTypes.RSMRelayOverRallInfo RSMRelayOverRallInfo = new ClsAPLEntityTypes.RSMRelayOverRallInfo();
		RSMRelayOverRallInfo.saveFC(str_json6);
		RSMRelayOverRallInfo.getFC(str_json6);
		
		ClsAPLEntityTypes.RSMRelayAcctFCInfo RSMRelayAcctFCInfo = new ClsAPLEntityTypes.RSMRelayAcctFCInfo();
		RSMRelayAcctFCInfo.saveFC(str_json7);
		RSMRelayAcctFCInfo.getFC(str_json7);
		RSMRelayAcctFCInfo.getRefData(str_json7);
		
		ClsAPLEntityTypes.RelayAcctFCInfo RelayAcctFCInfo = new ClsAPLEntityTypes.RelayAcctFCInfo();
		RelayAcctFCInfo.saveFC(str_json8);
		RelayAcctFCInfo.getFC(str_json8);
		*/
		ClsAPLEntityTypes.RelayFC RelayFC = new ClsAPLEntityTypes.RelayFC();
		
		ClsAPLEntityTypes.GAMAcctFCInfo GAMAcctFCInfo = new ClsAPLEntityTypes.GAMAcctFCInfo();
		GAMAcctFCInfo.saveFC(str_json9);
		GAMAcctFCInfo.getFC(str_json9);
		GAMAcctFCInfo.getRefData(str_json9);
		
		ClsAPLEntityTypes.GAMRegionFCInfo GAMRegionFCInfo = new ClsAPLEntityTypes.GAMRegionFCInfo();
		GAMRegionFCInfo.getFC(str_json10);
		GAMRegionFCInfo.getRefData(str_json10);
		GAMRegionFCInfo.saveFC(str_json10);
		
		ClsAPLEntityTypes.RSMCBCFCInfo RSMCBCFCInfo = new ClsAPLEntityTypes.RSMCBCFCInfo();
		RSMCBCFCInfo.getFC(str_json11);
		RSMCBCFCInfo.getRefData(str_json11);
		RSMCBCFCInfo.saveFC(str_json11);
		
		ClsAPLEntityTypes.RSMRelayCBCFCInfo RSMRelayCBCFCInfo = new ClsAPLEntityTypes.RSMRelayCBCFCInfo();
		RSMRelayCBCFCInfo.getFC(str_json12);
		RSMRelayCBCFCInfo.getRefData(str_json12);
		RSMRelayCBCFCInfo.saveFC(str_json12);
		
		ClsAPLEntityTypes.GAMCBCFCInfo GAMCBCFCInfo = new ClsAPLEntityTypes.GAMCBCFCInfo();
		GAMCBCFCInfo.saveFC(str_json13);
		GAMCBCFCInfo.getFC(str_json13);
		GAMCBCFCInfo.getRefData(str_json13);
		
		ClsAPLEntityTypes.RelayCBCFCInfo RelayCBCFCInfo = new ClsAPLEntityTypes.RelayCBCFCInfo();
		RelayCBCFCInfo.getFC(str_json14);
		RelayCBCFCInfo.saveFC(str_json14);
		
		ClsAPLEntityTypes.RSMGPLFCInfo RSMGPLFCInfo = new ClsAPLEntityTypes.RSMGPLFCInfo();
		RSMGPLFCInfo.getFC(str_json15);
		RSMGPLFCInfo.getRefData(str_json15);
		RSMGPLFCInfo.saveFC(str_json15);
		
		ClsAPLEntityTypes.RSMRelayGPLFCInfo RSMRelayGPLFCInfo = new ClsAPLEntityTypes.RSMRelayGPLFCInfo();
		RSMRelayGPLFCInfo.getFC(str_json16);
		RSMRelayGPLFCInfo.saveFC(str_json15);

		Test.stopTest();
	}
	
	
	static testMethod void testMethod2() {
		ClsAPLEntityTypes.GAMGPLFCInfo gamGPL = new ClsAPLEntityTypes.GAMGPLFCInfo();
    	gamGPL.cbc2Code = '30012';
    	gamGPL.acctId = '';
    	gamGPL.gplId =  '';
    	gamGPL.map_year_quartersFuture = new map<String, set<String>>();	
    	gamGPL.map_year_quartersFuture.put('2014', new set<String>());
    	gamGPL.map_year_quartersFuture.get('2014').add('04'); 
    	gamGPL.list_dateKey = new list<String>();
    	gamGPL.list_dateKey.add('2014_4');
    	gamGPL.list_dateKey.add('2014_4');
    	gamGPL.list_dateKey.add('2014_4');
    	gamGPL.currentYear = '2014';
    	gamGPL.currentMonth = 4;
    	gamGPL.map_dateKey_fc = new map<String, decimal>();
    	gamGPL.list_parts = new list<ClsAPLEntityTypes.GAMPartFCInfo>();
    	String str_json17 = Json.serialize(gamGPL);
    	
    	ClsAPLEntityTypes.RSMPartFCInfo rsmPart1 = new ClsAPLEntityTypes.RSMPartFCInfo();
    	rsmPart1.acctId = 'other';
    	rsmPart1.territoryCode = 'test';
    	rsmPart1.cbc2Code = '30012';
    	rsmPart1.gplId = '';
    	rsmPart1.partId = '';
    	rsmPart1.map_year_quartersFuture = new map<String, set<String>>();	
    	rsmPart1.map_year_quartersFuture.put('2014', new set<String>());
    	rsmPart1.map_year_quartersFuture.get('2014').add('04');     	
    	rsmPart1.map_year_monthsHistory = new map<String, set<Integer>>();	
    	rsmPart1.map_year_monthsHistory.put('2014', new set<Integer>());
    	rsmPart1.map_year_monthsHistory.get('2014').add(4);
    	rsmPart1.map_year_monthsFuture = new map<String, set<Integer>>();
    	rsmPart1.map_year_monthsFuture.put('2014', new set<Integer>());
    	rsmPart1.map_year_monthsFuture.get('2014').add(4);
    	rsmPart1.refStartDate = '2014-04-01';
    	rsmPart1.periodStartDate = '2014-04-21';
    	rsmPart1.refEndDate = '2014-04-01';
    	rsmPart1.currentYear = '2014';
    	rsmPart1.currentMonth = 4;  
    	rsmPart1.map_dateKey_fc = new map<String, decimal>();
    	rsmPart1.map_dateKey_fc.put('2014_04', 20);
    	rsmPart1.map_dateKey_fc.put('2015_01', 20);
    	rsmPart1.map_dateKey_fc.put('2013_01', 20);
    	String str_json18 = Json.serialize(rsmPart1);
    	
    	ClsAPLEntityTypes.GAMPartFCInfo gamPart = new ClsAPLEntityTypes.GAMPartFCInfo();
    	gamPart.acctId = '';
    	gamPart.map_year_quartersFuture = new map<String, set<String>>();	
    	gamPart.map_year_quartersFuture.put('2014', new set<String>());
    	gamPart.map_year_quartersFuture.get('2014').add('04'); 
    	gamPart.cbc2Code = '30012';
    	gamPart.gplId = '';
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
    	String str_json19 = Json.serialize(gamPart);
		ClsAPLEntityTypes.GAMGPLFCInfo GAMGPLFCInfo = new ClsAPLEntityTypes.GAMGPLFCInfo();
		GAMGPLFCInfo.getFC(str_json17);
		GAMGPLFCInfo.getRefData(str_json17);
		GAMGPLFCInfo.saveFC(str_json17);
		
    	ClsAPLEntityTypes.RSMRelayCBCFCInfo rsmCBC1 = new ClsAPLEntityTypes.RSMRelayCBCFCInfo();
		rsmCBC1.acctId = 'other';
    	rsmCBC1.territoryCode = 'test';
    	rsmCBC1.cbc2Code = '13213';
    	rsmCBC1.map_year_quartersFuture = new map<String, set<String>>();	
    	rsmCBC1.map_year_quartersFuture.put('2014', new set<String>());
    	rsmCBC1.map_year_quartersFuture.get('2014').add('04');
    	rsmCBC1.list_dateKey = new list<String>();
    	rsmCBC1.list_dateKey.add('2014_4');
    	rsmCBC1.list_dateKey.add('2014_4');
    	rsmCBC1.list_dateKey.add('2014_4');
    	rsmCBC1.currentYear = '2014';
    	rsmCBC1.currentMonth = 4;
    	rsmCBC1.map_cbcRowKey_cbcName = new map<String, String>();
    	rsmCBC1.map_cbcRowKey_cbcName.put('13213', 'Power/Signal');
    	rsmCBC1.list_partFC = new list<ClsAPLEntityTypes.RelayPartFCInfo>();
    	String str_json12 = Json.serialize(rsmCBC1);
		ClsAPLEntityTypes.RSMPartFCInfo RSMPartFCInfo = new ClsAPLEntityTypes.RSMPartFCInfo();
		RSMPartFCInfo.getFC(str_json18);
		RSMPartFCInfo.saveFC(str_json18);
		Test.startTest();
		ClsAPLEntityTypes.RSMRelayPartFCInfo RSMRelayPartFCInfo = new ClsAPLEntityTypes.RSMRelayPartFCInfo();
		RSMRelayPartFCInfo.getFC(str_json12);
		RSMRelayPartFCInfo.saveFC(str_json12);
		
		ClsAPLEntityTypes.GAMPartFCInfo GAMPartFCInfo = new ClsAPLEntityTypes.GAMPartFCInfo();
		GAMPartFCInfo.getFC(str_json19);
		GAMPartFCInfo.saveFC(str_json19);
		
		ClsAPLEntityTypes.RelayPartFCInfo RelayPartFCInfo = new ClsAPLEntityTypes.RelayPartFCInfo();
		
		ClsAPLEntityTypes.RelayPartObj RelayPartObj = new ClsAPLEntityTypes.RelayPartObj();
		
		ClsAPLEntityTypes.FCResults FCResults = new ClsAPLEntityTypes.FCResults();
		
		ClsAPLEntityTypes.AcctFCResults AcctFCResults = new ClsAPLEntityTypes.AcctFCResults();
		
		AggregateResult result;
		
		ClsAPLEntityTypes.AcctFCValueObj AcctFCValueObj = new ClsAPLEntityTypes.AcctFCValueObj();
		AcctFCValueObj.assignFCValues(new ClsAPLEntityTypes.AcctFCValueObj(), result, '2014_04');
		AcctFCValueObj.assignRefData(new ClsAPLEntityTypes.AcctFCValueObj(), result, '2014_04', true);
		AcctFCValueObj.assignHisBacklogRefData(new ClsAPLEntityTypes.AcctFCValueObj(), result, '2014_04');
		
		ClsAPLEntityTypes.CBCFCValueObj CBCFCValueObj = new ClsAPLEntityTypes.CBCFCValueObj();
		CBCFCValueObj.assignFCValues(new ClsAPLEntityTypes.CBCFCValueObj(),  result, '2014_04');
		CBCFCValueObj.assignRefData(new ClsAPLEntityTypes.CBCFCValueObj(),  result, '2014_04', true);
		CBCFCValueObj.assignHisBacklogRefData(new ClsAPLEntityTypes.CBCFCValueObj(),  result, '2014_04');
		
		ClsAPLEntityTypes.GPLFCValueObj GPLFCValueObj = new ClsAPLEntityTypes.GPLFCValueObj();
		GPLFCValueObj.assignFCValues(new ClsAPLEntityTypes.GPLFCValueObj(), result, '2014_04');
		GPLFCValueObj.assignRefData(new ClsAPLEntityTypes.GPLFCValueObj(), result, '2014_04', true);
		GPLFCValueObj.assignHisBacklogRefData(new ClsAPLEntityTypes.GPLFCValueObj(), result, '2014_04');
		
		ClsAPLEntityTypes.PartFCValueObj PartFCValueObj = new ClsAPLEntityTypes.PartFCValueObj();
		PartFCValueObj.assignFCValues(new ClsAPLEntityTypes.PartFCValueObj(), result, '2014_04');
		PartFCValueObj.assignRefData(new ClsAPLEntityTypes.PartFCValueObj(), result, '2014_04', true);
		PartFCValueObj.assignHisBacklogRefData(new ClsAPLEntityTypes.PartFCValueObj(), result, '2014_04');
		
		//ClsAPLEntityTypes.FCValueObj FCValueObj = new ClsAPLEntityTypes.FCValueObj();
		//FCValueObj.assignFCValues(new ClsAPLEntityTypes.FCValueObj(), result, '2014_04' );
		
		ClsAPLEntityTypes.Cbc2Object Cbc2Object = new ClsAPLEntityTypes.Cbc2Object('test', 'test', 'test', 'test');
		
		ClsAPLEntityTypes.RelayPartObject RelayPartObject = new ClsAPLEntityTypes.RelayPartObject();
		
		ClsAPLEntityTypes.RelayPartFCValueObj RelayPartFCValueObj = new ClsAPLEntityTypes.RelayPartFCValueObj();
		RelayPartFCValueObj.assignFCPartRelayValues(new ClsAPLEntityTypes.RelayPartFCValueObj(), result, '2014_04', '2');
		RelayPartFCValueObj.assignRefData(new ClsAPLEntityTypes.RelayPartFCValueObj(), result, '2014_04', true);
		RelayPartFCValueObj.assignHisBacklogRefData(new ClsAPLEntityTypes.RelayPartFCValueObj(), result, '2014_04');
		
		ClsAPLEntityTypes.RelayFCObj RelayFCObj = new ClsAPLEntityTypes.RelayFCObj();
		
		ClsAPLEntityTypes.TotalFCViewFields TotalFCViewFields = new ClsAPLEntityTypes.TotalFCViewFields();
		ClsAPLEntityTypes.TotalFCViewFields TotalFCViewFields1 = new ClsAPLEntityTypes.TotalFCViewFields('test');
		TotalFCViewFields.assignFCValues(new ClsAPLEntityTypes.TotalFCViewFields(), result, '2014_04');
		
		ClsAPLEntityTypes.OverRallFCObj OverRallFCObj = new ClsAPLEntityTypes.OverRallFCObj();
		OverRallFCObj.assignFCValues(new ClsAPLEntityTypes.OverRallFCObj(), result, '2014_04');
		Test.stopTest();
	}
}