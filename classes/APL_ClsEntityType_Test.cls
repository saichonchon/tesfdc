/**.
 *  This test class is used to test APL_ClsEntityType
 *  
 * @author Weihang Li
 * @created 2015-06-12
 * @version 1.0
 * @since 29.0 (Force.com ApiVersion)  
 * 
 *
 * @changeloga
 * 2015-06-12 Weihang Li <weihang.li@itbconsult.com>
 * - Created
 *
 * coverage 73%
 */
@isTest
private class APL_ClsEntityType_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        APL_ClsEntityType.MockObj mo = new APL_ClsEntityType.MockObj();
        mo.className = 'test';
        mo.str_json = 'test';
        
        APL_ClsEntityType.SearchObj so = new APL_ClsEntityType.SearchObj();
        so.searchKey = 'Test';
        so.soldtoId = 'Test';
        so.accnumber = 'Test';
        so.oemId = 'Test';
        so.partId = 'Test';
        so.region = 'Test';
        so.gplfamily = 'Test';
        so.gplId = 'Test';
        so.rsmgrouping = 'Test';
        so.grouping = 'Test';
        so.cbc2Code = 'Test';
        so.relayCode = 'Test';
        so.territoryCode = 'Test';
        so.set_selectedId = null;
        so.map_year_monthsFuture = null;
        so.map_year_quartersFuture = null;
        so.startDate = '2015-05-01';
        so.endDate = '2015-05-01';
        so.isOtherMethod = true;
        so.set_fiscalMonth = null;
        so.isExpansionSoldto = true;
        so.hasGPLCode = true;
        so.viewMode = 'Test';
        so.userId = UserInfo.getUserId();
        so.managerId = UserInfo.getUserId();
        so.type = 'CBC2';
        so.currencyIso = 'USD';
        so.set_deletedId  = null;
        so.map_quarter_months = null;
        so.map_acctId_currencyIso = null;
        so.set_gamCodes = null;        
        
        APL_ClsEntityType.BaseObj bo = new APL_ClsEntityType.BaseObj();
        bo.id = '';
        bo.name = 'test';
        bo.managerId = '';
        bo.region = 'test';
        bo.accnumber = 'test';
        bo.type = 'test';
        
        APL_ClsEntityType.AccountValueobj av = new APL_ClsEntityType.AccountValueobj();
        av.forecast = 2;
        av.price = 10;
        av.quantity = 10;
        av.restPNFC = 10;
        
        APL_ClsEntityType.OEMAccountObj oemAccObj = new APL_ClsEntityType.OEMAccountObj();
        oemAccObj.accmanager = 'test';
        oemAccObj.snumber = '1';
        oemAccObj.oemId = 'test';
        oemAccObj.gplcode = '3461';
        oemAccObj.gplfamily = 'test';
        oemAccObj.eolcomment = 'test';
        oemAccObj.rank = 'test';
        oemAccObj.accmanager ='test';
        oemAccObj.csFC = new map<String,decimal>{'a'=>10};
        oemAccObj.restPNFC = new map<String,decimal>{'b'=>10};
        oemAccObj.dcFC = new map<String,decimal>{'c'=>10};
        oemAccObj.pmFC = new map<String,decimal>{'d'=>10};
        oemAccObj.json_csFC = 'test';
        oemAccObj.json_dcFC = 'test';
        oemAccObj.json_pmFC = 'test';
        
        APL_ClsEntityType.AccountObj ao = new APL_ClsEntityType.AccountObj();
        ao.accmanager = 'test';
        ao.snumber = '1';
        ao.oemId = 'test';
        ao.gplcode = '3461';
        ao.gplfamily = 'test';
        ao.eolcomment = 'test';
        ao.accmanager ='test';
        ao.csFC = new map<String,decimal>{'a'=>10};
        ao.restPNFC = new map<String,decimal>{'b'=>10};
        ao.dcFC = new map<String,decimal>{'c'=>10};
        ao.pmFC = new map<String,decimal>{'d'=>10};
        ao.json_csFC = 'test';
        ao.json_dcFC = 'test';
        ao.json_pmFC = 'test';
        
        APL_ClsEntityType.RSMAccountObj rsmObj = new APL_ClsEntityType.RSMAccountObj();
        rsmObj.snumber = '1111';
        rsmObj.price = 10;
        rsmObj.json_FCData = 'test';
        rsmObj.isHighLighted = false;
        rsmObj.map_type_FC = new map<String,map<String,decimal>>();
        
        
        APL_ClsEntityType.RSMPartObj rsmPart = new APL_ClsEntityType.RSMPartObj();
        rsmPart.snumber = '222';
        rsmPart.price = 10;
        rsmPart.precent = 0.5;
        rsmPart.isHighLighted = true;
        rsmPart.json_FCData = 'test';
        rsmPart.map_type_FC = new map<String,map<String,decimal>>();
        
        APL_ClsEntityType.AccountObjForComparison accObjForComparision = new APL_ClsEntityType.AccountObjForComparison();
        accObjForComparision.csFCamount = 10;
        accObjForComparision.json_csFC = 'test';
        accObjForComparision.json_dcFC = 'test';
        accObjForComparision.json_pmFC = 'test';
        accObjForComparision.csFC = new map<String,decimal>{'a'=>10};
        accObjForComparision.dcFC = new map<String,decimal>{'b'=>10};
        accObjForComparision.pmFC = new map<String,decimal>{'c'=>10};
        
        APL_ClsEntityType.PartObj partObj = new APL_ClsEntityType.PartObj();
        partObj.snumber = '33';
        partObj.gplcode = '23432';
        partObj.gplfamily = 'test';
        partObj.hasCFTFC = true;
        partObj.dcFC = new map<String,decimal>{'c'=>10};
        partObj.pmFC = new map<String,decimal>{'d'=>10};
        
        APL_ClsEntityType.ComparisonObj comobj = new APL_ClsEntityType.ComparisonObj();
        comobj.csFCamount = 10;
        comobj.csFCmonth = new map<String,decimal>{'a'=>10};
        comobj.dcFCmonth = new map<String,decimal>{'b'=>10};
        
        APL_ClsEntityType.APLForecastValueObj aplForeValObj = new APL_ClsEntityType.APLForecastValueObj();
        aplForeValObj.accnumber = '123';
        aplForeValObj.cbc2Code = '333';
        aplForeValObj.currencyIso = 'RMB';
        aplForeValObj.gplId = 'test';
        aplForeValObj.grouping = 'test';
        aplForeValObj.managerId = 'test';
        aplForeValObj.map_datekey_csFC = new map<String,decimal>{'a'=>10};
        aplForeValObj.map_year_quartersFuture = new map<String,set<String>>();
        aplForeValObj.partId = 'test';
        aplForeValObj.price = 10;
        aplForeValObj.productcode = '23423423';
        aplForeValObj.productname = 'test product';
        aplForeValObj.territoryCode = 'test';
        
        APL_ClsEntityType.APLReferenceData aplReferData = new APL_ClsEntityType.APLReferenceData();
        aplReferData.backlog = 10;
        aplReferData.billing = 10;
        aplReferData.booking = 10;
        
        APL_ClsEntityType.APLRefObj aplRefObj = new APL_ClsEntityType.APLRefObj();
        aplRefObj.map_backlogrefdata = new map<String,decimal>{'a'=>10};
        aplRefObj.map_billingrefdata = new map<String,decimal>{'b'=>10};
        aplRefObj.map_bookingrefdata = new map<String,decimal>{'c'=>10};
        aplRefObj.map_statisticalrefdata = new map<String,decimal>{'d'=>10};
        
        APL_ClsEntityType.UserObj userObj = new APL_ClsEntityType.UserObj();
        userObj.id = 'test';
        userObj.isSamsung = true;
        userObj.key = 'test key';
        userObj.lazy = false;
        userObj.name = 'test name';
        userObj.password = '123123';
        userObj.photoUrl = 'www.test.com';
        userObj.rsmType = 'test';
        userObj.title = 'test title';
        userObj.url = 'test';
        
        APL_ClsEntityType.CFTDataObj cftdataobj = new APL_ClsEntityType.CFTDataObj();
        cftdataobj.dateKey = 'test datakey';
        cftdataobj.hasvalue = true;
        cftdataobj.quantity = 10;
        
        APL_ClsEntityType.APLColumn aplCol = new APL_ClsEntityType.APLColumn();
        aplCol.cls = 'test';
        aplCol.fieldName = 'Name';
        aplCol.id = 'test id';
        aplCol.isInput = true;
        aplCol.json_ForecastData = 'test jsonStr';
        aplCol.matchName = 'test name';
        aplCol.name = 'test ';
        
        APL_ClsEntityType.Cbc2Object cbc2Obj = new APL_ClsEntityType.Cbc2Object('test','test','test','test');
        cbc2Obj.name = 'test name';
        cbc2Obj.clsName = 'test clsname';
        cbc2Obj.code = 'test code';
        cbc2Obj.fieldName = 'test field name';
        
        APL_ClsEntityType.DateItem dataItem = new APL_ClsEntityType.DateItem('test');
        dataItem.cls = 'test cls';
        dataItem.fMonth = 1;
        dataItem.fYear = '2015';
        dataItem.isFutrue = false;
        dataItem.isInput = true;
        dataItem.itemName = 'itemName';
        dataItem.mLabel = 'mLabel';
        dataItem.monthCls = 'monthCls';
        dataItem.qLabel = 'test qLabel';
        dataItem.qMonths = 'test qMonth';
        dataItem.qtotalCls = 'test';
        dataItem.total = '100';
        dataItem.type = 'test type';
        dataItem.type1 = 'test type 1';
        dataItem.type2 = 'test type2';
        dataItem.type3 = 'test type3';
        dataItem.workingDays = 4;
        
        APL_ClsEntityType.PageConfig pc = new APL_ClsEntityType.PageConfig();
        pc.currencyPlaces = 'test';
        pc.currentMonth = 2;
        pc.currentMonthIndex = 2;
        pc.currentTerritoryCode = '23432';
        pc.currentYear = '2015';
        pc.isFrozen = false;
        pc.isOverallFrozen = true;
        pc.isRelay = true;
        pc.isRender = true;
        pc.isSetupDone = true;
        pc.isStop = true;
        pc.json_acctCurrency = 'test';
        pc.json_map_quarter_months = 'test';
        pc.json_rsmAMTerritoryCodes = 'test';
        pc.json_rsmRelayDisplayNames = 'test';
        pc.json_rsmRelayIds = 'test';
        pc.json_rsmRelayTerritoryCodes = 'test';
        pc.json_setGAMCodes = 'test';
        pc.list_yearMonth = new List<String>{'1','3'};
        pc.managerId = 'test';
        pc.map_acctId_currencyIso = new map<String,string>();
        pc.map_financialMonth = new map<String,set<Integer>>();
        pc.map_quarter_months = new map<String,string>();
        pc.map_workingDays = new map<string,decimal>();
        pc.map_year_monthsFuture = new map<string,set<integer>>();
        pc.map_year_monthsHistory = new map<string,set<Integer>>();
        pc.map_year_quartersFuture = new map<string,set<String>>();
        pc.periodStartDate = 'test';
        pc.pricePlaces = 'test';
        pc.quarterNumb = 'test';
        pc.refEndDate = '2015-06-06';
        pc.refStartDate = '2015-01-01';
        pc.rsmAMDisplayName = 'test name';
        pc.rsmAMId = 'tes';
        pc.samsungId = 'test';
        pc.set_dateKey = new set<string>();
        pc.set_gamCodes = new set<string>();
        pc.set_parentIds = new set<string>();
        pc.set_regions = new set<String>();
        pc.set_rsmAMTerritoryCodes = new set<string>();
        pc.set_rsmRelayDisplayNames = new set<String>();
        pc.set_rsmRelayIds = new set<String>();
        pc.set_rsmRelayTerritoryCodes = new set<String>();
        pc.set_territoryCodes = new set<String>();
        pc.str_financialMonthMap = 'test';
        pc.str_futureMonthMap = 'test';
        pc.str_futureQuarterMap = 'test';
        pc.str_historyMonthMap = 'test';
        pc.str_tableHead = 'test tab head';
        pc.territoryCode = 'test code';
        pc.viewMode = 'test mode';
                
        APL_ClsEntityType.LocaleConfig local = new APL_ClsEntityType.LocaleConfig();
        local.jsPath = 'test jspath';
        local.locale = 'test locale';
        
        APL_ClsEntityType.LocaleConfig local1 = new APL_ClsEntityType.LocaleConfig('test local', 'test jspath');
        
        
        APL_ClsEntityType.SearchObjExpand sobjExpand = new APL_ClsEntityType.SearchObjExpand();
        sobjExpand.set_deletedgplcodes = new set<string>{'test'};
        sobjExpand.set_deletedPartIds = new set<string>{'test'};
        sobjExpand.set_deletedsoldtonumbers = new set<string>{'test'};
        sobjExpand.set_selectdsoldtonumbers = new set<String>{'test'};
        sobjExpand.set_selectedPartIds = new set<string>{'test'};
        
        
        APL_ClsEntityType.RSMParentAcctObj rsmParentAccObj = new APL_ClsEntityType.RSMParentAcctObj();
        rsmParentAccObj.accnumber = 'test accNumber';
        rsmParentAccObj.acctId = 'test accIds';
        rsmParentAccObj.displayName = 'test displayname';
        rsmParentAccObj.expanded = true;
        rsmParentAccObj.folder = true;
        rsmParentAccObj.level = 'test level';
        rsmParentAccObj.name = 'test name';
        rsmParentAccObj.olddisName = 'test oldDisname';
        rsmParentAccObj.parentId = 'test parentId';
        rsmParentAccObj.territoryName = 'test territoryName';
         
        APL_ClsEntityType.RSMParentAcctObj rsmParentAccObj1 = new APL_ClsEntityType.RSMParentAcctObj('test accNumber', 'test accIds', 'test accNumber','test displayname', 'test parentId', 'test level', 'test oldDisname');
        APL_ClsEntityType.RSMParentAcctObj rsmParentAccObj2 = new APL_ClsEntityType.RSMParentAcctObj('test accIds', 'test name', 'test accNumber', 'test displayname', 'test parentId', 'test level', 'test diaplayname', 'test code');
       

        
        APL_ClsEntityType.RSMType rsmTyp = new APL_ClsEntityType.RSMType();
        rsmTyp.map_level_name = new map<String,String>();
        
        APL_ClsEntityType.RSMRelayOverRallInfo rsmRelay = new APL_ClsEntityType.RSMRelayOverRallInfo();
        rsmRelay.managerId = 'test managerId';
        rsmRelay.set_rsmIds = new set<string>();
        rsmRelay.set_displayNames = new set<string>{'test'};
        rsmRelay.map_year_quartersFuture = new map<string,set<string>>();
        rsmRelay.map_name_map_dateKey_fc = new map<string,map<string,decimal>>();
    }
}