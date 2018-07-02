/**.
 *  This test class is used to test APL_ClsEntityType
 *  
 * @author Lei Tang
 * @created 2015-06-12
 * @version 1.0
 * @since 33.0 (Force.com ApiVersion)  
 * 
 *
 * @changeloga
 * 2015-06-12 Lei Tang <lei.tang@itbconsult.com>
 * - Created
 *
 * coverage 96%
 */
@isTest
private class CSD_ClsEntityType_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        CSD_ClsEntityType.MockObj mo = new CSD_ClsEntityType.MockObj();
        mo.className = 'test';
        mo.str_json = 'test';
        
        
        CSD_ClsEntityType.SearchObj so = new CSD_ClsEntityType.SearchObj();
        so.searchKey = 'Test';
        so.soldtoId = 'Test';
        so.accnumber = 'Test';
        so.oemId = 'Test';
        so.partId = 'Test';
        so.region = 'Test';
        so.gplfamily = 'Test';
        so.set_selectedId = null;
        so.map_year_monthsFuture = null;
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
        so.set_deletedId  = null;
        so.map_quarter_months = null;
        
        
        CSD_ClsEntityType.BaseObj bo = new CSD_ClsEntityType.BaseObj();
        bo.id = '';
        bo.name = 'test';
        bo.managerId = '';
        bo.region = 'test';
        bo.accnumber = 'test';
        bo.type = 'test';
        
        CSD_ClsEntityType.AccountValueobj av = new CSD_ClsEntityType.AccountValueobj();
        av.forecast = 2;
        av.price = 10;
        av.quantity = 10;
        av.restPNFC = 10;
        
        CSD_ClsEntityType.OEMAccountObj oemAccObj = new CSD_ClsEntityType.OEMAccountObj();
        oemAccObj.accmanager = 'test';
        oemAccObj.snumber = '1';
        oemAccObj.oemId = 'test';
        oemAccObj.gplcode = '3461';
        oemAccObj.gplfamily = 'test';
        oemAccObj.eolcomment = 'test';
        oemAccObj.rank = '12';
        oemAccObj.accmanager ='test';
        oemAccObj.csFC = new map<String,decimal>{'a'=>10};
        oemAccObj.restPNFC = new map<String,decimal>{'b'=>10};
        oemAccObj.dcFC = new map<String,decimal>{'c'=>10};
        oemAccObj.pmFC = new map<String,decimal>{'d'=>10};
        oemAccObj.json_csFC = 'test';
        oemAccObj.json_dcFC = 'test';
        oemAccObj.json_pmFC = 'test';
        
        CSD_ClsEntityType.OEMAccountObj oemAccObj2 = new CSD_ClsEntityType.OEMAccountObj();
        oemAccObj2.accmanager = 'test';
        oemAccObj2.snumber = '1';
        oemAccObj2.oemId = 'test';
        oemAccObj2.gplcode = '3461';
        oemAccObj2.gplfamily = 'test';
        oemAccObj2.eolcomment = 'test';
        oemAccObj2.rank = '10';
        oemAccObj2.accmanager ='test';
        oemAccObj2.csFC = new map<String,decimal>{'a'=>10};
        oemAccObj2.restPNFC = new map<String,decimal>{'b'=>10};
        oemAccObj2.dcFC = new map<String,decimal>{'c'=>10};
        oemAccObj2.pmFC = new map<String,decimal>{'d'=>10};
        oemAccObj2.json_csFC = 'test';
        oemAccObj2.json_dcFC = 'test';
        oemAccObj2.json_pmFC = 'test';
        
        list<CSD_ClsEntityType.OEMAccountObj> oemAccObjlist = new list<CSD_ClsEntityType.OEMAccountObj>();
        oemAccObjlist.add(oemAccObj);
        oemAccObjlist.add(oemAccObj2);
        oemAccObjlist.sort();
        
        CSD_ClsEntityType.AccountObj ao = new CSD_ClsEntityType.AccountObj();
        ao.accmanager = 'test';
        ao.snumber = '1';
        ao.name = 'test';
        ao.oemId = 'test';
        ao.gplcode = '3461';
        ao.gplfamily = 'test';
        ao.eolcomment = 'test';
        ao.accmanager ='test';
        ao.rank = '12';
        ao.csFC = new map<String,decimal>{'a'=>10};
        ao.restPNFC = new map<String,decimal>{'b'=>10};
        ao.dcFC = new map<String,decimal>{'c'=>10};
        ao.pmFC = new map<String,decimal>{'d'=>10};
        ao.json_csFC = 'test';
        ao.json_dcFC = 'test';
        ao.json_pmFC = 'test';
        
		CSD_ClsEntityType.AccountObj ao2 = new CSD_ClsEntityType.AccountObj();
		ao2.name = 'test1';
		
		list<CSD_ClsEntityType.AccountObj> aolist = new list<CSD_ClsEntityType.AccountObj>();
		aolist.add(ao);
		aolist.add(ao2);
        aolist.sort();
        
        CSD_ClsEntityType.AccountObjForComparison accObjForComparision = new CSD_ClsEntityType.AccountObjForComparison();
        accObjForComparision.csFCamount = 10;
        accObjForComparision.json_csFC = 'test';
        accObjForComparision.json_dcFC = 'test';
        accObjForComparision.json_pmFC = 'test';
        accObjForComparision.csFC = new map<String,decimal>{'a'=>10};
        accObjForComparision.dcFC = new map<String,decimal>{'b'=>10};
        accObjForComparision.pmFC = new map<String,decimal>{'c'=>10};
        
        CSD_ClsEntityType.AccountObjForComparison accObjForComparision2 = new CSD_ClsEntityType.AccountObjForComparison();
        accObjForComparision2.csFCamount = 11;
        
        list<CSD_ClsEntityType.AccountObjForComparison> accObjForComparisionlist = new list<CSD_ClsEntityType.AccountObjForComparison>();
		accObjForComparisionlist.add(accObjForComparision);
		accObjForComparisionlist.add(accObjForComparision2);
        accObjForComparisionlist.sort();
        
        CSD_ClsEntityType.PartObj partObj = new CSD_ClsEntityType.PartObj();
        partObj.snumber = '33';
        partObj.gplcode = '23432';
        partObj.gplfamily = 'test';
        partObj.name = 'test';
        partObj.hasCFTFC = true;
        partObj.dcFC = new map<String,decimal>{'c'=>10};
        partObj.pmFC = new map<String,decimal>{'d'=>10};
        
        CSD_ClsEntityType.PartObj partObj2 = new CSD_ClsEntityType.PartObj();
        partObj2.name = 'test1';
        
        list<CSD_ClsEntityType.PartObj> partObjlist = new list<CSD_ClsEntityType.PartObj>();
		partObjlist.add(partObj);
		partObjlist.add(partObj2);
        partObjlist.sort();
        
        CSD_ClsEntityType.ComparisonObj comobj = new CSD_ClsEntityType.ComparisonObj();
        comobj.csFCamount = 10;
        comobj.csFCmonth = new map<String,decimal>{'a'=>10};
        comobj.dcFCmonth = new map<String,decimal>{'b'=>10};
        
        CSD_ClsEntityType.ComparisonObj comobj2 = new CSD_ClsEntityType.ComparisonObj();
        comobj2.csFCamount = 11;

        list<CSD_ClsEntityType.ComparisonObj> comobjlist = new list<CSD_ClsEntityType.ComparisonObj>();
		comobjlist.add(comobj);
		comobjlist.add(comobj2);
        comobjlist.sort();
        
        CSD_ClsEntityType.CSDForecastValueObj csdForeValObj = new CSD_ClsEntityType.CSDForecastValueObj();
        csdForeValObj.accnumber = '123';
        csdForeValObj.gplcode = 'test';
        csdForeValObj.gplfamily = 'test';
        csdForeValObj.managerId = 'test';
        csdForeValObj.csFC = new map<String,CSD_ClsEntityType.AccountValueobj>();
        csdForeValObj.partId = 'test';
        csdForeValObj.name = 'test';
        csdForeValObj.region = 'test';
        csdForeValObj.oemId = 'test';
        csdForeValObj.soldToId = 'test';
		
        
        CSD_ClsEntityType.CSDReferenceData aplReferData = new CSD_ClsEntityType.CSDReferenceData();
        aplReferData.backlog = 10;
        aplReferData.billing = 10;
        aplReferData.booking = 10;
        
        
        CSD_ClsEntityType.CSDRefObj aplRefObj = new CSD_ClsEntityType.CSDRefObj();
        aplRefObj.map_backlogrefdata = new map<String,decimal>{'a'=>10};
        aplRefObj.map_billingrefdata = new map<String,decimal>{'b'=>10};
        aplRefObj.map_bookingrefdata = new map<String,decimal>{'c'=>10};
        aplRefObj.map_statisticalrefdata = new map<String,decimal>{'d'=>10};
        
        
        CSD_ClsEntityType.UserObj userObj = new CSD_ClsEntityType.UserObj();
        userObj.id = 'test';
        userObj.isSamsung = true;
        userObj.key = 'test key';
        userObj.lazy = false;
        userObj.name = 'test name';
        userObj.password = '123123';
        userObj.photoUrl = 'www.test.com';
        userObj.title = 'test title';
        userObj.url = 'test';
        
        
        CSD_ClsEntityType.UserObj userObj2 = new CSD_ClsEntityType.UserObj('test',new list<CSD_ClsEntityType.UserObj>());
        
        
        CSD_ClsEntityType.CFTDataObj cftdataobj = new CSD_ClsEntityType.CFTDataObj();
        cftdataobj.dateKey = 'test datakey';
        cftdataobj.hasvalue = true;
        cftdataobj.quantity = 10;
        
        CSD_ClsEntityType.CSDColumn csdCol = new CSD_ClsEntityType.CSDColumn();
        csdCol.cls = 'test';
        csdCol.fieldName = 'Name';
        csdCol.isInput = true;
        csdCol.matchName = 'test name';
        csdCol.name = 'test ';
        CSD_ClsEntityType.CSDColumn csdCol2 = new CSD_ClsEntityType.CSDColumn('test','test','test','test',true);
        
        
        CSD_ClsEntityType.Cbc2Object cbc2Obj = new CSD_ClsEntityType.Cbc2Object('test','test','test','test');
        cbc2Obj.name = 'test name';
        cbc2Obj.clsName = 'test clsname';
        cbc2Obj.code = 'test code';
        cbc2Obj.fieldName = 'test field name';
        
        CSD_ClsEntityType.DateItem dataItem = new CSD_ClsEntityType.DateItem('test');
        
        
        CSD_ClsEntityType.PageConfig pc = new CSD_ClsEntityType.PageConfig();
        
                
        CSD_ClsEntityType.LocaleConfig local = new CSD_ClsEntityType.LocaleConfig();
        CSD_ClsEntityType.LocaleConfig local1 = new CSD_ClsEntityType.LocaleConfig('test jspath','test locale');
        
        
        CSD_ClsEntityType.SearchObjExpand sobjExpand = new CSD_ClsEntityType.SearchObjExpand();
        sobjExpand.set_deletedgplcodes = new set<string>{'test'};
        sobjExpand.set_deletedPartIds = new set<string>{'test'};
        sobjExpand.set_deletedsoldtonumbers = new set<string>{'test'};
        sobjExpand.set_selectdsoldtonumbers = new set<String>{'test'};
        sobjExpand.set_selectedPartIds = new set<string>{'test'};
		
		CSD_ClsEntityType.AttentionString attention = new CSD_ClsEntityType.AttentionString();
		
    }
}