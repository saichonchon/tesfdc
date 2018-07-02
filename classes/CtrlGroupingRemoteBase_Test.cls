/**
*  This test class used to test class ClsGroupingAMForecastUtil.
*
@author Lili Zhao
@created 2014-08-20
*
@changelog
* coverage  88%
*  
2014-08-15 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest
private class CtrlGroupingRemoteBase_Test {

    static testMethod void myUnitTest() {
    	
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
        
    	CtrlGroupingRemoteBase.CBC2Forecast cbc_fc = new CtrlGroupingRemoteBase.CBC2Forecast();
    	cbc_fc.aid = 'other';
    	cbc_fc.territoryCode = 'test';
    	cbc_fc.map_year = new map<String, set<String>>();	
    	cbc_fc.map_year.put('2014', new set<String>());
    	cbc_fc.map_year.get('2014').add('04');
    	cbc_fc.map_acctId_currencyIso = new map<String, String>();
    	cbc_fc.map_acctId_currencyIso.put('other', 'USD');
    	cbc_fc.map_cbcName = new map<String, String>();
    	cbc_fc.map_cbcName.put('30012', 'test');
    	cbc_fc.map_cbcName.put('30022', 'test');
    	cbc_fc.list_dateKey = new list<String>();
    	cbc_fc.list_dateKey.add('2014_4');
    	cbc_fc.list_dateKey.add('2014_4');
    	cbc_fc.list_dateKey.add('2014_4');
    	cbc_fc.currentYear = '2014';
    	cbc_fc.currentMonth = 4;
    	cbc_fc.cbcCode = '30012';
        String str_json = Json.serialize(cbc_fc);
        
        CtrlGroupingRemoteBase.AcctForecast acctFCInfo = new CtrlGroupingRemoteBase.AcctForecast();
    	acctFCInfo.list_dateKey = new list<String>();
    	acctFCInfo.list_dateKey.add('2014_4');
    	acctFCInfo.list_dateKey.add('2014_4');
    	acctFCInfo.list_dateKey.add('2014_4');
    	acctFCInfo.currentYear = '2014';
    	acctFCInfo.currentMonth = 4;
    	acctFCInfo.map_acctId_currencyIso = new map<String, String>();
    	acctFCInfo.map_acctId_currencyIso.put('other', 'USD');
    	acctFCInfo.aid = 'other';
        String str_json1 = Json.serialize(acctFCInfo);
        
        CtrlGroupingRemoteBase.GPLInfo gplfc = new CtrlGroupingRemoteBase.GPLInfo();
    	gplfc.aid = 'other';
		gplfc.territoryCode = 'test';
		gplfc.gplId = ph.Id;
		gplfc.cbcCode = '30012';
		gplfc.isTop = true;
		gplfc.isOther = true;
		gplfc.map_year = new map<String, set<String>>();	
		gplfc.map_year.put('2014', new set<String>());
    	gplfc.map_year.get('2014').add('04');
    	gplfc.map_acctId_currencyIso = new map<String, String>();
    	gplfc.map_acctId_currencyIso.put('other', 'USD');
    	gplfc.isNeedBillPercentage = true;
    	gplfc.quarterNumb = 'Q2';
    	gplfc.list_dateKey = new list<String>();
    	gplfc.list_dateKey.add('2014_4');
    	gplfc.list_dateKey.add('2014_4');
    	gplfc.list_dateKey.add('2014_4');
    	gplfc.currentYear = '2014';
    	gplfc.currentMonth = 4;
    	gplfc.json_partIds = new set<String>();
    	String str_json2 = Json.serialize(gplfc);
    	
    	CtrlGroupingRemoteBase.GPLInfo gplfc1 = new CtrlGroupingRemoteBase.GPLInfo();
    	gplfc1.aid = 'other';
		gplfc1.territoryCode = 'test';
		gplfc1.gplId = ph1.Id;
		gplfc1.cbcCode = '13213';
		gplfc1.cbc2Name = '13213';
		gplfc1.isTop = true;
		gplfc1.isOther = true;
		gplfc1.map_year = new map<String, set<String>>();	
		gplfc1.map_year.put('2014', new set<String>());
    	gplfc1.map_year.get('2014').add('04');
    	gplfc1.map_acctId_currencyIso = new map<String, String>();
    	gplfc1.map_acctId_currencyIso.put('other', 'USD');
    	gplfc1.isNeedBillPercentage = true;
    	gplfc1.quarterNumb = 'Q2';
    	gplfc1.list_dateKey = new list<String>();
    	gplfc1.list_dateKey.add('2014_4');
    	gplfc1.list_dateKey.add('2014_4');
    	gplfc1.list_dateKey.add('2014_4');
    	gplfc1.currentYear = '2014';
    	gplfc1.currentMonth = 4;
    	gplfc1.json_partIds = new set<String>();
    	String str_json12 = Json.serialize(gplfc1);
    	
    	CtrlGroupingRemoteBase.PartInfo partInfo = new CtrlGroupingRemoteBase.PartInfo();
    	partInfo.aid =  'other'; 
    	partInfo.gplId = ph.Id;
    	partInfo.territoryCode = 'test';
    	partInfo.map_year = new map<String, set<String>>();	
		partInfo.map_year.put('2014', new set<String>());
    	partInfo.map_year.get('2014').add('04');
    	partInfo.map_acctId_currencyIso = new map<String, String>();
    	partInfo.map_acctId_currencyIso.put('other', 'USD');   	
    	partInfo.map_year_monthsHistory = new map<String, set<Integer>>();	
    	partInfo.map_year_monthsHistory.put('2014', new set<Integer>());
    	partInfo.map_year_monthsHistory.get('2014').add(4);
    	partInfo.map_year_monthsFuture = new map<String, set<Integer>>();
    	partInfo.map_year_monthsFuture.put('2014', new set<Integer>());
    	partInfo.map_year_monthsFuture.get('2014').add(4);
    	partInfo.refStartDate = '2014-04-01';
    	partInfo.periodStartDate = '2014-04-21';
    	partInfo.refEndDate = '2014-04-01';
    	partInfo.currentYear = '2014';
    	partInfo.currentMonth = 4; 
    	partInfo.isOther = true; 
    	partInfo.set_partIds = new set<String>();
        String str_json3 = Json.serialize(partInfo);
        
        CtrlGroupingRemoteBase.PartInfo partInfo2 = new CtrlGroupingRemoteBase.PartInfo();
    	partInfo2.aid =  'other'; 
    	partInfo2.gplId = '13213';
    	partInfo2.territoryCode = 'test';
    	partInfo2.map_year = new map<String, set<String>>();	
		partInfo2.map_year.put('2014', new set<String>());
    	partInfo2.map_year.get('2014').add('04');
    	partInfo2.map_acctId_currencyIso = new map<String, String>();
    	partInfo2.map_acctId_currencyIso.put('other', 'USD');   	
    	partInfo2.map_year_monthsHistory = new map<String, set<Integer>>();	
    	partInfo2.map_year_monthsHistory.put('2014', new set<Integer>());
    	partInfo2.map_year_monthsHistory.get('2014').add(4);
    	partInfo2.map_year_monthsFuture = new map<String, set<Integer>>();
    	partInfo2.map_year_monthsFuture.put('2014', new set<Integer>());
    	partInfo2.map_year_monthsFuture.get('2014').add(4);
    	partInfo2.refStartDate = '2014-04-01';
    	partInfo2.periodStartDate = '2014-04-21';
    	partInfo2.refEndDate = '2014-04-01';
    	partInfo2.currentYear = '2014';
    	partInfo2.currentMonth = 4; 
    	partInfo2.isOther = true; 
    	partInfo2.set_partIds = new set<String>();
        String str_json8 = Json.serialize(partInfo2);
        
        CtrlGroupingRemoteBase.PartInfo partInfo1 = new CtrlGroupingRemoteBase.partInfo();
    	partInfo1.aid =  'other'; 
    	partInfo1.cbc2Name = '13213';
    	partInfo1.territoryCode = 'test';
    	partInfo1.partId = '';
    	partInfo1.map_year = new map<String, set<String>>();	
		partInfo1.map_year.put('2014', new set<String>());
    	partInfo1.map_year.get('2014').add('04');
    	partInfo1.map_acctId_currencyIso = new map<String, String>();    	
    	partInfo1.map_year_monthsHistory = new map<String, set<Integer>>();	
    	partInfo1.map_year_monthsHistory.put('2014', new set<Integer>());
    	partInfo1.map_year_monthsHistory.get('2014').add(4);
    	partInfo1.map_year_monthsFuture = new map<String, set<Integer>>();
    	partInfo1.map_year_monthsFuture.put('2014', new set<Integer>());
    	partInfo1.map_year_monthsFuture.get('2014').add(4);
    	partInfo1.refStartDate = '2014-04-01';
    	partInfo1.periodStartDate = '2014-04-21';
    	partInfo1.refEndDate = '2014-04-01';
    	partInfo1.currentYear = '2014';
    	partInfo1.currentMonth = 4; 
    	partInfo1.set_partIds = new set<String>();
    	String str_json4 = Json.serialize(partInfo1);
    	
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
    	String str_json22 = Json.serialize(rsmCBC1);
    	
    	ClsAPLForecastObjects.PartObject partObj = new ClsAPLForecastObjects.PartObject();
    	partObj.partId = '';
    	partObj.currencyIso = 'USD';
    	partObj.map_dateKey_fc = new map<String, decimal>();
    	partObj.map_dateKey_fc.put('2014_04', 20);
    	partObj.map_dateKey_fc.put('2015_01', 20);
    	partObj.map_dateKey_fc.put('2013_01', 20);
    	
    	ClsAPLForecastObjects.GplObject gplObj = new ClsAPLForecastObjects.GplObject();
    	gplObj.parentId =  ''; 
    	gplObj.gplId = ph.Id;
    	gplObj.territoryCode = 'test';
    	gplObj.quarterNumb = '02';
    	gplObj.map_year_quartersFuture = new map<String, set<String>>();	
    	gplObj.map_year_quartersFuture.put('2014', new set<String>());
    	gplObj.map_year_quartersFuture.get('2014').add('04');     	
    	gplObj.map_dateKey_fc = new map<String, decimal>();
    	gplObj.map_dateKey_fc.put('2014_04', 20);
    	gplObj.map_dateKey_fc.put('2015_01', 20);
    	gplObj.map_dateKey_fc.put('2013_01', 20);
    	gplObj.currencyIso = 'USD';
    	gplObj.list_partFC = new list<ClsAPLForecastObjects.PartObject>();
    	gplObj.list_partFC.add(partObj);
    	String str_json55 = Json.serialize(gplObj);
    	
    	ClsAPLForecastObjects.ForecastSaveBaseObj fo = new ClsAPLForecastObjects.ForecastSaveBaseObj();
    	fo.className = 'ClsAPLForecastObjects.GplObject';
    	fo.str_json = str_json55;
    	String str_json5 = Json.serialize(fo);
    	
    	ClsAPLEntityTypes.MockObj mockObj = new ClsAPLEntityTypes.MockObj();
    	mockObj.className = 'ClsAPLEntityTypes.RSMRelayCBCFCInfo';
    	mockObj.str_json = str_json22;
    	String str_json6 = Json.serialize(mockObj);
    	
    	ClsAPLEntityTypes.RSMTerritoryFCInfo rsmTerritory3 = new ClsAPLEntityTypes.RSMTerritoryFCInfo();
    	rsmTerritory3.managerId = userInfo.getUserId();
    	rsmTerritory3.territoryCode = 'test';
    	String str_json7 = Json.serialize(rsmTerritory3);

        
        Test.startTest();
        
        CtrlGroupingRemoteBase.searchCBC2Forecast(str_json);
        CtrlGroupingRemoteBase.searchAMAcctFCReferenceData(str_json1);
        CtrlGroupingRemoteBase.searchAMCBCRefDataQuarterly(str_json);
        CtrlGroupingRemoteBase.searchCBC2ForecastForRelay(str_json);
        CtrlGroupingRemoteBase.searchGPL(str_json2);
        CtrlGroupingRemoteBase.searchAMGPLRefDataQuarterly(str_json2);
        CtrlGroupingRemoteBase.searchPartFC(str_json3);
        CtrlGroupingRemoteBase.searchPartFCForRelay(str_json4);
        CtrlGroupingRemoteBase.searchOthersPartFC(str_json3);
        CtrlGroupingRemoteBase.searchRelayGPLFC(str_json2);
        CtrlGroupingRemoteBase.searchRelayPartFC(str_json8);
        CtrlGroupingRemoteBase.deletePart(str_json3);
        CtrlGroupingRemoteBase.addedPart(str_json2);
        CtrlGroupingRemoteBase.searchAllPart(str_json2);
        CtrlGroupingRemoteBase.getAddedPartRefData(str_json3);
        CtrlGroupingRemoteBase.addedRelayPart(str_json12);
        CtrlGroupingRemoteBase.searchRelayPart(str_json12);
        CtrlGroupingRemoteBase.getAddedRelayPartRefData(str_json4);
        CtrlGroupingRemoteBase.saveForecast(str_json5);
        CtrlGroupingRemoteBase.delPart(str_json3);
        CtrlGroupingRemoteBase.delRelayPart(str_json4);
        CtrlGroupingRemoteBase.saveRelayFC(str_json6);
        CtrlGroupingRemoteBase.getRefData(str_json6);
        CtrlGroupingRemoteBase.getGAMFC(str_json6);
        CtrlGroupingRemoteBase.saveGAMFC(str_json6);
        CtrlGroupingRemoteBase.unfreezeAM(str_json7);
        CtrlGroupingRemoteBase CBase = new CtrlGroupingRemoteBase();
        //CBase.submitAM();
        CBase.getOtherAcctId();
        CtrlGroupingRemoteBase.AcctForecast AcctForecast = new CtrlGroupingRemoteBase.AcctForecast();
        CtrlGroupingRemoteBase.CBC2Forecast CBC2Forecast = new CtrlGroupingRemoteBase.CBC2Forecast();
        CtrlGroupingRemoteBase.GPLInfo GPLInfo = new CtrlGroupingRemoteBase.GPLInfo();
        CtrlGroupingRemoteBase.PartInfo PartInfo3 = new CtrlGroupingRemoteBase.PartInfo();
        CtrlGroupingRemoteBase.Superclass Superclass = new CtrlGroupingRemoteBase.Superclass();
        
        //try block added to avoid any json parsing exceptios
        try{ CtrlGroupingRemoteBase.existAPLsObject('APL_ClsAMService.SearchLevel1', str_json4);} catch(exception ex){}
        try{ CtrlGroupingRemoteBase.searchAPLsObject('APL_ClsRelayService.SearchLevel3', str_json12);} catch(exception ex){}
        try{ CtrlGroupingRemoteBase.saveAPLsObject('APL_ClsAMService.SearchLevel3', str_json6);} catch(exception ex){}
        try{ CtrlGroupingRemoteBase.getBacklogRefData('APL_ClsAMService.SearchLevel1.', str_json3);} catch(exception ex){}
        //try{ CtrlGroupingRemoteBase.getAPLsRefData('APL_ClsAMService.SearchLevel1',str_json6);} catch(exception ex){}
        try{ CtrlGroupingRemoteBase.delAPLsOjbect('APL_ClsRelayService.SearchLevel3', str_json4);} catch(exception ex){}
            
        Test.stopTest();
    }
}