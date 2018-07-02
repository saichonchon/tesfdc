/**
*  This test class used to test class APL_ClsMangerAPLUtil.
*
*@author Qiang Liu
*@created 2015-07-02
*@version 1.0
*@since 30.0
*
@ changelog
* 
* 2015-07-02 Qiang Liu <qiang.liu@itbconsult.com>
* - Created
* - Coverage 
*/
@isTest
private class APL_ClsMangerAPLUtil_Test {
  private static string pid = null;
  private static string pvalue = null;
  private static string cid = null;
  /*static testMethod void myUnitTest() {
        User user = setupUser();
        system.runAs(user){
            //ClsTriggerFactory.setSkipHandlers(true);
            test.startTest();
            list<APL_Oppy_Portal_Template__c> tmplts = setUpdata(user);
            APL_CtrlManagerAPLFilter ctrl = new APL_CtrlManagerAPLFilter();
            ctrl.oppyDetails = '["Opportunity details","Sales team"]';
            ctrl.oppyType = 'Opportunity';
            ctrl.tmpidprops = ctrl.jsonidprops;
            ctrl.doSearch();
            
            
            ctrl.set_labels.clear();
            ctrl.set_labels.add('SF');
            ctrl.set_labels.add('Wt');
            ctrl.oppyDetails = '["Opportunity details","Sales team"]';
            ctrl.oppyFcstType = 'By Year';
            ctrl.oppyFcstYearRange = '(Fiscal_Year__c >=\'2015\' and Fiscal_Year__c  <=\'2016\')';
            ctrl.oppylastId = '';
            ctrl.queryYears = 2;
            ctrl.mainSOQL = 'SELECT Opportunity_Number__c,Name,Record_Type_Name__c,Opportunity_Owner__c,Opportunity_Owner_Profile__c,Opportunity_Account_Name__c,StageName,New_Business_Percentage__c,Days_since_last_user_update__c,Account_Manager__c,Territory_Code__c,Field_Engineer_Code__c,Relay_Hierarchy_Manager__c,Relay_Specialist_Territory_Code__c, Id from Opportunity ';
            map<String,set<string>> map_mappingIds= setUpTestData(user);
            //set<string> tmp = new set<string>();
            //ctrl.tmpmapping = Json.serialize(map_mappingIds);
            //map_mappingIds.put('006E0000007ia8VIAQ',tmp);
            set<ID> keys = new set<Id>();
            for(String str_Id : map_mappingIds.keySet()) {
                keys.add((Id) str_Id);
            }
            list<Id> list_keys = new list<Id>(keys);
            ctrl.oppyIds = Json.serialize(list_keys);
            ctrl.tmpmapping = Json.serialize(map_mappingIds);
            ctrl.lastFcstOppyId = '';
            ctrl.queryOppyFcst();
            
            ctrl.tmpmapping = Json.serialize(map_mappingIds);
            ctrl.lazySearch();
            String oppyId, oppyPartId;
            list<APL_ClsMangerAPLUtil.FieldFilter> list_filter = new list<APL_ClsMangerAPLUtil.FieldFilter>();
            APL_ClsMangerAPLUtil.FieldFilter filter1 = new APL_ClsMangerAPLUtil.FieldFilter();
            filter1.list_fieldInfos = new list<APL_ClsMangerAPLUtil.FieldInfo>();
            APL_ClsMangerAPLUtil.FieldFilter filter2 = new APL_ClsMangerAPLUtil.FieldFilter();
            filter2.list_fieldInfos = new list<APL_ClsMangerAPLUtil.FieldInfo>();
            filter2.name = 'Opportunity Partner details';
            
            filter1.name = 'Opportunity Part details';
            APL_ClsMangerAPLUtil.FieldInfo fieldInfo1 = new APL_ClsMangerAPLUtil.FieldInfo();
            fieldInfo1.fieldlabel = 'Id';
            fieldInfo1.fieldAPI = 'Id';
            fieldInfo1.dtype = 'String';
            

            
            filter1.list_fieldInfos.add(fieldInfo1);

            list_filter.add(filter1);

            
            for(String opId : map_mappingIds.keySet()) {
                oppyId = opId;
                for(String partId : map_mappingIds.get(opId)) {
                    oppyPartId = partId;
                }
            }
            Opportunity_Part__c part = new Opportunity_Part__c();
            //part.Id = oppyPartId;
            part.Opportunity__c = oppyId;
            
            APL_ClsMangerAPLUtil.convertToPartPropsWrapper(oppyId, part, list_filter);
            Opportunity_Partner__c partner = new Opportunity_Partner__c();
            partner.Opportunity__c = oppyId;
            insert partner;
            APL_ClsMangerAPLUtil.convertToPartnerPropsWrapper(oppyId, partner, list_filter);
            
            APL_ClsMangerAPLUtil.queryOppyParts(true, new set<String> {oppyPartId}, oppyPartId);
            APL_ClsMangerAPLUtil.queryOppyPartFcstObjects('DATE_YEAR_DEF', oppyPartId, 3, ' id != null ', new set<String> {oppyPartId}, new set<String> {'SF'});
            APL_ClsMangerAPLUtil.queryRightOppyFcstObjects('DATE_YEAR_DEF', oppyId, '3', new set<String> {oppyPartId} ,map_mappingIds);
            APL_ClsMangerAPLUtil.queryOppyPartExport('3', ' ID != NULL ', 'Select Id, Name From opportunity ' , oppyPartId , map_mappingIds, new set<String>{''}, list_filter, new list<string>());
            APL_ClsMangerAPLUtil.queryOppyPartExport('3', ' id != NULL ', 'Select Id, Name From opportunity  ', oppyPartId, new set<String> {oppyPartId}, new set<String>{''} , list_filter, new list<string>());
            APL_ClsMangerAPLUtil.queryOppyPartnerExportNew('3', 'Select Id, Name From opportunity  ', map_mappingIds, list_filter, new list<string>(), new set<string>(), ' Id != null ');
            
            APL_ClsMangerAPLUtil.FieldInfo fieldInfo2 = new APL_ClsMangerAPLUtil.FieldInfo();
            fieldInfo2.fieldlabel = 'Id';
            fieldInfo2.fieldAPI = 'Id';
            fieldInfo2.dtype = 'String';
            filter2.list_fieldInfos.add(fieldInfo1);
            filter2.list_fieldInfos.add(fieldInfo2);
            list_filter.add(filter2);
            APL_ClsMangerAPLUtil.existOppyPartnerChildForecast('3', 'Select Id, Name From opportunity  ', map_mappingIds, list_filter, new list<string>(), new set<string>(), ' Id != null ');
            APL_ClsMangerAPLUtil.existOppyPartChildForecast('3', 'Select Id, Name From opportunity  ', map_mappingIds, list_filter, new list<string>(), new set<string>(), ' Id != null ');
            APL_ClsMangerAPLUtil.existOppyPartChildForecast('3', 'Select Id, Name From opportunity  ', map_mappingIds, list_filter, new list<string>(), new set<string>(), ' Id != null ');
            
            list<APL_ClsMangerAPLUtil.PropsWrapper> wrappers = new list<APL_ClsMangerAPLUtil.PropsWrapper>();
            APL_ClsMangerAPLUtil.PropsWrapper wrapper = new APL_ClsMangerAPLUtil.PropsWrapper();
            wrapper.oppyId = oppyId;
            wrapper.list_entries = new list<String>();
            wrappers.add(wrapper);
            APL_ClsMangerAPLUtil.mergePropsWrappers(wrappers, wrappers);
            
            Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast.Opportunity__c = oppyId;
            oppyForecast.Quantity__c = 12;
            oppyForecast.Part__c = oppyPartId;
            oppyForecast.Date__c = date.newInstance(2012, 09, 28);
            oppyForecast.Amount__c = 1;
            oppyForecast.Fiscal_Quarter__c = '03';
            oppyForecast.Fiscal_Month__c = '08'; 
            list<sObject> objs = new list<sObject>();
            objs.add((sObject) oppyForecast);
            
            APL_ClsMangerAPLUtil.convertToFcstWrappers(false,  '3', objs, new set<String>());
            APL_ClsMangerAPLUtil.getPartnerIds(new set<String>{oppyId});
            map<String, String> map_conditions = new map<String, String>();
            map_conditions.put('Opportunity_Part__c', ' Id != null limit 100 ');
            map_conditions.put('Opportunity', ' Id != null limit 100 ');
            APL_ClsMangerAPLUtil.doQueryKeys2(map_conditions);
            APL_ClsMangerAPLUtil.queryOppyPartKeys(' Id != null limit 100 ');
            APL_ClsMangerAPLUtil.queryOppyKeys(' Id != null limit 100 ', new set<String> {oppyId});
            
            APL_ClsMangerAPLUtil.APLFilterWrapper filter4 = new APL_ClsMangerAPLUtil.APLFilterWrapper();
            filter4.id = 'id1';
            filter4.filterType = 'Checkbox';
            filter4.values = new list<APL_ClsMangerAPLUtil.APLFilterValue>();
            APL_ClsMangerAPLUtil.APLFilterValue fv = new APL_ClsMangerAPLUtil.APLFilterValue();
            fv.label = 'Name';
            fv.value = 'Test';
            fv.orderNum = 1;
            filter4.values.add(fv);
            
            APL_ClsMangerAPLUtil.APLFilterServerWrapper sevFilter = new APL_ClsMangerAPLUtil.APLFilterServerWrapper();
            sevFilter.id = 'id1';
            sevFilter.bResult = true;
            map<String, APL_ClsMangerAPLUtil.APLFilterServerWrapper> map_seFilter = new map<String, APL_ClsMangerAPLUtil.APLFilterServerWrapper>();
            map_seFilter.put('id1', sevFilter);
            list<APL_ClsMangerAPLUtil.APLFilterWrapper> list_filters = new list<APL_ClsMangerAPLUtil.APLFilterWrapper>();
            list_filters.add(filter4);
            APL_ClsMangerAPLUtil.processOppyFcstSOQLElements(list_filters, map_seFilter);
            
            
            list<APL_ClsMangerAPLUtil.FieldFilter> list_fieldfilter153 = new list<APL_ClsMangerAPLUtil.FieldFilter>();
            list_fieldfilter153.add(filter1);
            APL_ClsMangerAPLUtil.constructMainSOQL(list_fieldfilter153, new list<String>());
            APL_ClsMangerAPLUtil.generateSQLCondition(filter4, map_seFilter);
            
            APL_ClsMangerAPLUtil.APLFilterWrapper filter5 = new APL_ClsMangerAPLUtil.APLFilterWrapper();
            filter5.id = 'id1';
            filter5.filterType = 'Date';
            filter5.values = new list<APL_ClsMangerAPLUtil.APLFilterValue>();
            APL_ClsMangerAPLUtil.LabelRefObject labelRefObj = new APL_ClsMangerAPLUtil.LabelRefObject();
            labelRefObj.conditionSOQL = ' ssss ';
            APL_ClsMangerAPLUtil.generateSQLConditionOnLable(filter5, 'Custom Date', labelRefObj);
            APL_Oppy_Portal_Template__c temp = new APL_Oppy_Portal_Template__c();
            temp.Name = 'Name';
            insert temp;
            APL_User_Filter__c uf = new APL_User_Filter__c();
            uf.Template__c = temp.Id;
            insert uf;
            
            APL_ClsMangerAPLUtil.updateTemplate(temp.Id, 'oppytype', 'details');    
            APL_ClsMangerAPLUtil.doRemove(temp.Id);
            APL_ClsMangerAPLUtil.APLFilterWrapper master = new APL_ClsMangerAPLUtil.APLFilterWrapper();
            master.id = 'id1';
            APL_ClsMangerAPLUtil.getValueFromLabel('label', master);
            APL_ClsMangerAPLUtil.getDiableStatusFromLabel('label', master);
            
            APL_ClsMangerAPLUtil.processDependencyData(filter4, sevFilter, 'label', 'value');
            APL_ClsMangerAPLUtil.convertQuarter('01');
            APL_ClsMangerAPLUtil.convertQuarter('02');
            APL_ClsMangerAPLUtil.convertQuarter('03');
            APL_ClsMangerAPLUtil.convertQuarter('04');
            APL_ClsMangerAPLUtil.LocaleConfig config = new APL_ClsMangerAPLUtil.LocaleConfig('sss', 'sss');
            APL_ClsMangerAPLUtil.SearchObj searchObj = new APL_ClsMangerAPLUtil.SearchObj();
            
            APL_ClsMangerAPLUtil.APLFilterServerWrapper aplFsw = new APL_ClsMangerAPLUtil.APLFilterServerWrapper();
            aplFsw.id = 'aplFsw';
            aplFsw.relatedObject = '';
            aplFsw.bReq = true;
            aplFsw.filterType = 'Picklist';
            APL_ClsMangerAPLUtil.LabelRefObject labelRef = new APL_ClsMangerAPLUtil.LabelRefObject();
            labelRef.value = 'aplFsw';
            labelRef.conditionSOQL = ' ID != NULL limit 100 ';
            
            aplFsw.map_labelToReference.put('aplFsw', labelRef);
            list<string> list_pValues = new list<String>();
            list_pValues.add('aplFsw');
            map<String,APL_ClsMangerAPLUtil.APLFilterServerWrapper> map_idToServerWrappers = new map<String,APL_ClsMangerAPLUtil.APLFilterServerWrapper>();
            map_idToServerWrappers.put('aplFsw', aplFsw);
            APL_ClsMangerAPLUtil.getCtrlValues('aplFsw', list_pValues, list_pValues, map_idToServerWrappers);
            test.stopTest();
        }
    }*/
    
    static testMethod void doSaveTest() {
        User user = setupUser();
        system.runAs(user){
            //ClsTriggerFactory.setSkipHandlers(true);
            test.startTest();
            list<APL_Oppy_Portal_Template__c> tmplts = setUpdata(user);
            APL_CtrlManagerAPLFilter ctrl = new APL_CtrlManagerAPLFilter();
            ctrl.tname = 'shawn_1';
            ctrl.oppyType = 'Opportunity';
            ctrl.oppyDetails = 'Opportunity details,Sales team';
            //ctrl.doSave();
            APL_CtrlManagerAPLFilter.doSave(ctrl.tname,ctrl.oppyType,ctrl.oppyDetails,ctrl.jsonfilters);
            APL_ClsMangerAPLUtil.getCustomerDateSOQL(' Name != null ', '1341828183000;1371828183000', '2015-01-06');
            APL_ClsMangerAPLUtil.PartnerResult parent = new APL_ClsMangerAPLUtil.PartnerResult();
            APL_ClsMangerAPLUtil.SearchObj searchOjb = new APL_ClsMangerAPLUtil.SearchObj();
            APL_ClsMangerAPLUtil.onlyReferenceFieldAPI('testString__c');
            
            test.stopTest();
        }
    }
    
    
    
    static testMethod void doSaveUpdate() {
        User user = setupUser();
        system.runAs(user){
            test.startTest();
            list<APL_Oppy_Portal_Template__c> tmplts = setUpdata(user);
            APL_CtrlManagerAPLFilter ctrl = new APL_CtrlManagerAPLFilter();
            ctrl.tid = tmplts.get(0).id;
            ctrl.oppyType = 'Opportunity';
            ctrl.oppyDetails = 'Opportunity details,Sales team';
            //ctrl.doUpdate();
            APL_CtrlManagerAPLFilter.doUpdate(ctrl.tid,ctrl.oppyType,ctrl.oppyDetails,ctrl.jsonfilters);
            test.stopTest();
        }
    }
    /*
    static testMethod void doQueryPart() {
        User user = setupUser();
        system.runAs(user){
            list<APL_Oppy_Portal_Template__c> tmplts = setUpdata(user); 
            map<Id,set<string>> map_mappingIds = setUpTestData2Map(user);
            test.startTest();
            
            APL_CtrlManagerAPLFilter ctrl = new APL_CtrlManagerAPLFilter();
            //map<Id,set<string>> map_mappingIds= setUpTestData(user);
            set<Id> keys = map_mappingIds.keySet();
            list<Id> list_keys = new list<Id>(keys);
            ctrl.oppyId = list_keys.get(0);
            ctrl.tmpmapping = Json.serialize(map_mappingIds);
            ctrl.oppyType = APL_ClsMangerAPLUtil.OPPY_PLUS_PART_TYPE;
            ctrl.queryOppyChildrens();
            test.stopTest();
        }
    }
    */
    static testMethod void doQueryPartFcst() {
        User user = setupUser();
        system.runAs(user){
            test.startTest();
            APL_CtrlManagerAPLFilter ctrl = new APL_CtrlManagerAPLFilter();
            map<Id,set<string>> map_mappingIds= setUpTestData2Map(user);
            set<Id> keys = map_mappingIds.keySet();
            list<Id> list_keys = new list<Id>(keys);
            
            ctrl.oppyId = list_keys.get(0);
            ctrl.oppyFcstType = 'By Year';
            ctrl.lastFcstOppyPartId = '';
            ctrl.queryYears = 2;
            ctrl.oppyFcstYearRange = '(Fiscal_Year__c >=\'2015\' and Fiscal_Year__c  <=\'2016\')';
            ctrl.set_labels.clear();
            ctrl.set_labels.add('SF');
      ctrl.set_labels.add('Wt');
      ctrl.oppyType = APL_ClsMangerAPLUtil.OPPY_PLUS_PART_TYPE;
            ctrl.tmpmapping = Json.serialize(map_mappingIds);
            ctrl.queryOppyChildrensFcst();
            test.stopTest();
        }
    }
    static testMethod void doQueryPartner() {
        User user = setupUser();
        list<APL_Oppy_Portal_Template__c> tmplts = setUpdata(user);
        system.runAs(user){
            test.startTest();
            APL_CtrlManagerAPLFilter ctrl = new APL_CtrlManagerAPLFilter();
            map<Id,set<string>> map_mappingIds= setUpTestData2Map(user);
            set<Id> keys = map_mappingIds.keySet();
            list<Id> list_keys = new list<Id>(keys);
            ctrl.oppyId = list_keys.get(0);
            ctrl.tmpmapping = Json.serialize(map_mappingIds);
            ctrl.oppyType = 'Opportunity & Partner details';
            ctrl.oppyFcstType = 'By Year';
            ctrl.oppyFcstYearRange = '(Fiscal_Year__c >=\'2015\' and Fiscal_Year__c  <=\'2016\')';
            ctrl.set_labels.clear();
            ctrl.set_labels.add('SF');
      ctrl.set_labels.add('Wt');
            ctrl.queryOppyChildrens();
            test.stopTest();
        }
    }
    static testMethod void doQueryCtrl() {
        User user = setupUser();
        list<APL_Oppy_Portal_Template__c> tmplts = setUpdata(user);
        system.runAs(user){
            test.startTest();
            APL_CtrlManagerAPLFilter ctrl = new APL_CtrlManagerAPLFilter();
            ctrl.tmpidprops = ctrl.jsonidprops;
            ctrl.pid = pid;
            
            list<string> list_values = new list<string>();
            list_values.add(pvalue);
            list<string> list_cids = new list<string>();
            list_values.add(cid);
            
            ctrl.pvalues = Json.serialize(list_values);
            ctrl.ctrlIds = Json.serialize(list_cids);
            
            ctrl.getCtrlValues();
            test.stopTest();
        }
    }
    
    static testMethod void myUnitTest2() {
        User user = setupUser();
        system.runAs(user){
            //map<Id,set<string>> map_mappingIds= setUpTestData(user);
            list<APL_Oppy_Portal_Template__c> tmplts = setUpdata(user);
            test.startTest();
            //APL_CtrlManagerAPLFilter ctrl = new APL_CtrlManagerAPLFilter(tmplts.get(0).id);
            APL_ClsMangerAPLUtil.initLoading(tmplts.get(0).id);
            //ctrl.doTemplateSwitch();
            //system.debug('after switch');
            test.stopTest();
        }
    }
    
    static testMethod void myUnitTest3() {
        User user = setupUser();
        system.runAs(user){
            //map<Id,set<string>> map_mappingIds= setUpTestData(user);
            list<APL_Oppy_Portal_Template__c> tmplts = setUpdata(user);
            test.startTest();
            //mock doTemplateRemove
            APL_ClsMangerAPLUtil.doRemove(tmplts.get(0).id);
            //APL_CtrlManagerAPLFilter ctrl = new APL_CtrlManagerAPLFilter();
            test.stopTest();
        }
    }
    static testMethod void myUnitTest4() {
        User user = setupUser();
        system.runAs(user){
            //ClsTriggerFactory.setSkipHandlers(true);
            list<APL_Oppy_Portal_Template__c> tmplts = APL_CtrlManagerAPLFilter_Test.setUpdata(user);
            APL_Oppy_Portal_Template__c tmp = tmplts.get(tmplts.size() - 2);
            PageReference ref = Page.APL_CtrlManagerAPLFilter;
            ref.getParameters().put('tid', tmp.id);
            test.startTest();
            Test.setCurrentPage(ref);
            APL_CtrlManagerAPLFilter ctrl = new APL_CtrlManagerAPLFilter();
            ctrl.getThis();
            ctrl.oppyPartnerFcstExport();
            ctrl.oppyPartnerExport();
            test.stopTest();
        }
    }
    
    static testMethod void myUnitTest7() {
        User user = setupUser();
        system.runAs(user){
            //ClsTriggerFactory.setSkipHandlers(true);
            list<APL_Oppy_Portal_Template__c> tmplts = APL_CtrlManagerAPLFilter_Test.setUpdata(user);
            APL_Oppy_Portal_Template__c tmp = tmplts.get(1);
            PageReference ref = Page.APL_CtrlManagerAPLFilter;
            ref.getParameters().put('tid', tmp.id);
            test.startTest();
            Test.setCurrentPage(ref);
            APL_CtrlManagerAPLFilter ctrl = new APL_CtrlManagerAPLFilter();
            test.stopTest();
        }
    }
    static testMethod void myUnitTest8() {
        User user = setupUser();
        system.runAs(user){
            //ClsTriggerFactory.setSkipHandlers(true);
            list<APL_Oppy_Portal_Template__c> tmplts = setUpdata(user);
            APL_Oppy_Portal_Template__c tmp = tmplts.get(tmplts.size() - 1);
            PageReference ref = Page.APL_CtrlManagerAPLFilter;
            ref.getParameters().put('tid', tmp.id);
            test.startTest();
            Test.setCurrentPage(ref);
            APL_CtrlManagerAPLFilter ctrl = new APL_CtrlManagerAPLFilter();
            test.stopTest();
        }
    }
    static testMethod void myUnitTest9() {
        User user = setupUser();
        system.runAs(user){
            //ClsTriggerFactory.setSkipHandlers(true);
            test.startTest();
            list<APL_Oppy_Portal_Template__c> tmplts = setUpdata(user);
            APL_CtrlManagerAPLFilter ctrl = new APL_CtrlManagerAPLFilter();
            ctrl.oppyDetails = '["Opportunity details","Sales team"]';
            ctrl.oppyType = 'Opportunity & Opportunity Part';
            ctrl.tmpidprops = ctrl.jsonidprops;
            ctrl.doSearch();
            test.stopTest();
        }
    }
    
    static testMethod void myUnitTest5() {
        User user = setupUser();
        system.runAs(user){
            //ClsTriggerFactory.setSkipHandlers(true);
            test.startTest();
            APL_CtrlManagerAPLFilter.asynOppyExport(1,'', '','', '','', new list<string>());
            APL_CtrlManagerAPLFilter.asynOppyPartExport(1,'', '','', new list<string>(),'','', new list<string>());
            APL_CtrlManagerAPLFilter.asynOppyPartnerExport(1,'', '','', new list<string>(),'','', new list<string>());
            APL_CtrlManagerAPLFilter.oppyFcstExport(1,'', 2,'', new list<string>(), '', '');
            APL_CtrlManagerAPLFilter.oppyPartFcstExport(1,'', 2,'', new list<string>(),'');
            test.stopTest();
        }
    } 
    
    /*@isTest
    static void test_asynOppyExportNew() {
        
        ExecuteOnce.SF2SF_ACCOUNT = true;
        ExecuteOnce.SF2SF_OPPORTUNITY = true;
        ClsBatch_calculateOppyWithin2Years.isRunningBatch = true;
        
        User user = setupUser();
        system.runAs(user){
            test.startTest();
            setUpdata(user);
            APL_CtrlManagerAPLFilter ctrl = New APL_CtrlManagerAPLFilter();
            ctrl.initialize();
            
            APL_ClsMangerAPLUtil.SearchObj searchObj = New APL_ClsMangerAPLUtil.SearchObj();
            APL_ClsMangerAPLUtil.FcstInnnerData fcstIn = New APL_ClsMangerAPLUtil.FcstInnnerData();
            APL_ClsMangerAPLUtil.APLFilterValue aplfv = New APL_ClsMangerAPLUtil.APLFilterValue('a', 'b');
            APL_ClsMangerAPLUtil.OPPYTemaplate temp = New APL_ClsMangerAPLUtil.OPPYTemaplate();
            temp.label = 'a';
            temp.value = 'b';
            temp.equals((Object) aplfv);
            searchObj.types = 'By Quarter';
            searchObj.soqlYearRange = 'oppyFcstYearRange';
            searchObj.querySOQL = 'SELECT Opportunity_Number__c,Name,Record_Type_Name__c,Opportunity_Owner__c,Opportunity_Owner_Profile__c,' 
                + 'Opportunity_Account_Name__c,Account_Number__c,GAM_Code__c,Customer_Region__c,Account_Billing_Country__c,Industry_Code__c,' 
                + 'StageName,New_Business_Percentage__c,Days_since_last_user_update__c,Account_Manager__c,Territory_Code__c,Field_Engineer_Code__c,' 
                + 'Relay_Hierarchy_Manager__c,Relay_Specialist_Territory_Code__c,CreatedDate,Manufacturing_Start_Date__c,Last_Modified_Date__c,'
                + 'Lost_Start_Date__c, Id from Opportunity';
            searchObj.list_fields = ctrl.list_fieldfilters;
            searchObj.details = New List<String>{'Account details', 'Opportunity details', 'Sales team', 'Time dimensions'};
            searchObj.queryYears = 2;
            searchObj.yearRangeSOQL = '(Fiscal_Year__c >=\'2015\' and Fiscal_Year__c  <=\'2016\')';
            searchObj.mappingIds = setUpTestData(user);
            searchObj.set_labels = New Set<String>{'SF'};
            searchObj.set_pids = New Set<String>();
            searchObj.list_oppyIds = New List<String>();
            
            String json_searchObj = Json.serialize(searchObj);
            APL_CtrlManagerAPLFilter.asynOppyExportNew(json_searchObj);
            APL_CtrlManagerAPLFilter.oppyFcstExportNew(json_searchObj);
            APL_CtrlManagerAPLFilter.asynOppyPartExportNew(json_searchObj);
            APL_CtrlManagerAPLFilter.oppyPartFcstExportNew(json_searchObj);
            
            
            test.stopTest();
        }
    }*/
    
    /*@isTest
    static void test_asynOppyPartnerExportNew() {
        //System.debug('qqqq test_asynOppyPartnerExportNew getFields=' + getFields('Opportunity_Partner_details', 'Opportunity_Partner__c'));
        ExecuteOnce.SF2SF_ACCOUNT = true;
        ExecuteOnce.SF2SF_OPPORTUNITY = true;
        ClsBatch_calculateOppyWithin2Years.isRunningBatch = true;
        
        User user = setupUser();
        system.runAs(user){
            test.startTest();
            setUpdata(user);
            APL_CtrlManagerAPLFilter ctrl = New APL_CtrlManagerAPLFilter();
            APL_ClsMangerAPLUtil.SearchObj searchObj = New APL_ClsMangerAPLUtil.SearchObj();
            searchObj.types = 'By Quarter';
            searchObj.soqlYearRange = 'oppyFcstYearRange';
            searchObj.querySOQL = 'SELECT Opportunity_Number__c,Name,Record_Type_Name__c,Opportunity_Owner__c,Opportunity_Owner_Profile__c,' 
                + 'Opportunity_Account_Name__c,Account_Number__c,GAM_Code__c,Customer_Region__c,Account_Billing_Country__c,Industry_Code__c,' 
                + 'StageName,New_Business_Percentage__c,Days_since_last_user_update__c,Account_Manager__c,Territory_Code__c,Field_Engineer_Code__c,' 
                + 'Relay_Hierarchy_Manager__c,Relay_Specialist_Territory_Code__c,CreatedDate,Manufacturing_Start_Date__c,Last_Modified_Date__c,'
                + 'Lost_Start_Date__c, Id from Opportunity';
            searchObj.list_fields = ctrl.list_fieldfilters;
            searchObj.details = New List<String>{'Account details', 'Opportunity details', 'Sales team', 'Time dimensions'};
            searchObj.queryYears = 2;
            searchObj.yearRangeSOQL = '(Fiscal_Year__c >=\'2015\' and Fiscal_Year__c  <=\'2016\')';
            searchObj.mappingIds = setUpTestData(user);
            searchObj.set_labels = New Set<String>{'SF'};
            searchObj.set_pids = New Set<String>();
            searchObj.list_oppyIds = New List<String>();
            
            String json_searchObjPartner = Json.serialize(searchObj);
            APL_CtrlManagerAPLFilter.asynOppyPartnerExportNew(json_searchObjPartner);
            
            test.stopTest();
        }
    }*/
    
    
    public static list<APL_Oppy_Portal_Template__c> setUpdata(User u){
        list<APL_Filter__c> filters = setUpAPLFilters();
        //upsert filters;
        list<APLFilter_FieldSet__c> settings = setUpCustomerSetting();
        upsert settings;
        return setUpTemplates(filters,u);
    }
    
    public static User setupUser(){
        Profile p = [Select Id, Name From Profile 
                     where Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'hellosERYT@testCompany1233423.com';
        u.Alias = 'dp2s';
        u.CommunityNickname = 'NND9';
        u.ProfileId = p.Id;
        system.debug('u.ProfileId == ' + u.ProfileId);
        insert u;
        
        /*
        Apex_Helper_Settings__c ahs1 = new Apex_Helper_Settings__c();
        ahs1.name = 'oppy_BAU_snapshotForecastData_invalid';
        ahs1.Active__c = true;
        insert ahs1;
        
        Apex_Helper_Settings__c ahs2 = new Apex_Helper_Settings__c();
        ahs2.name = 'Service Account Profile Id';
        ahs2.Value__c = p.Id;
        insert ahs2;
        
        Apex_Helper_Settings__c ahs3 = new Apex_Helper_Settings__c();
        ahs3.name = 'TEIS Admin User Id';
        ahs3.Value__c = p.Id;
        insert ahs3;
        
        Apex_Helper_Settings__c ahs4 = new Apex_Helper_Settings__c();
        ahs4.name = 'Account Record Type Id';
        ahs4.Value__c = p.Id;
        insert ahs4;
        
        Apex_Helper_Settings__c ahs5 = new Apex_Helper_Settings__c();
        ahs5.name = 'Currency Confirm Except Users';
        ahs5.Value__c = p.Id;
        insert ahs5;*/
        
        /*
        Apex_Helper_Settings__c ahs1 = new Apex_Helper_Settings__c();
        ahs1.name = 'NDR Opportunity';
        ahs1.Value__c = p.Id;
        insert ahs1;
        
        Apex_Helper_Settings__c ahs2 = new Apex_Helper_Settings__c();
        ahs2.name = 'Currency Confirm Except Users';
        ahs2.Value__c = p.Id;
        insert ahs2;*/
        
        /*
        RecordType rt = [select Name from RecordType where SobjectType = 'Opportunity' and DeveloperName = 'DND_Opportunity'];
        Apex_Helper_Settings__c ahs3 = new Apex_Helper_Settings__c();
        ahs3.name = 'DND Opportunity';
        ahs3.Value__c = rt.Id;
        system.debug('ahs3 values = ' + ahs3.Value__c);
        insert ahs3;*/
        
        
        
        ClsTestHelp.createTestName1();
        ClsTestHelp.createTestName2();
        ClsTestHelp.createTestName3();
        ClsTestHelp.createTestName4();
        ClsTestHelp.createTestName5();
        ClsTestHelp.createTestName6();
        ClsTestHelp.createTestName7();
        ClsTestHelp.createTestName8();
        ClsTestHelp.createTestName9();
        ClsTestHelp.createTestName10();
        ClsTestHelp.createTestName11();
        ClsTestHelp.createTestName12();
        ClsTestHelp.createTestName13();
        
        
        //
        ClsTestHelp.createTestCSD1();
        ClsTestHelp.createTestCSD2();
        ClsTestHelp.createTestCSD3();
        ClsTestHelp.createTestCSD4();
        ClsTestHelp.createTestCSD5();
        ClsTestHelp.createTestCSD6();
        ClsTestHelp.createTestCSD7();
        
        ClsTestHelp.createTestOpportunityApprovers();
        ClsTestHelp.createTestOpportunityApprovers2();
        ClsTestHelp.createTestOpportunityApprovers3();
        ClsTestHelp.createTestOpportunityApprovers4();
        
        ClsTestHelp.createTestProfitBUCenterMapping1();
        ClsTestHelp.createTestProfitBUCenterMapping2();
        ClsTestHelp.createTestProfitBUCenterMapping3();
        //ClsTestHelp.createTestOPTG1();
        //ClsTestHelp.createTestOPTG2();
        //ClsTestHelp.createTestSLC1();
        //ClsTestHelp.createTestSLC2();
        //ClsTestHelp.createTestSLC3();
        //ClsTestHelp.createTestSSPS1();
        //ClsTestHelp.createTestSSPS2();
        
        //ClsTestHelp.createTestSSSS1();
        //ClsTestHelp.createTestSSSS2();
        //ClsTestHelp.createTestSSSS3();
        //ClsTestHelp.createTestSSSS4();
        //ClsTestHelp.createTestSSSS5();
        //ClsTestHelp.createTestSSSS6();
        //ClsTestHelp.createTestSSSS7();
        //ClsTestHelp.createTestSSSS8();
        //ClsTestHelp.createTestSSSS9();
        //ClsTestHelp.createTestSSSS10();
        
        ClsTestHelp.createTestSSC1();
        ClsTestHelp.createTestSSC2();
        ClsTestHelp.createTestSSC3();
        ClsTestHelp.createTestSSC4();
        ClsTestHelp.createTestSSC5();
        ClsTestHelp.createTestSSC6();
        ClsTestHelp.createTestSSC7();
        
        //ClsTestHelp.createAPLSetting1();
        //ClsTestHelp.createAPLSetting2();
        /*
        Apex_Helper_Settings__c a = new Apex_Helper_Settings__c();
        a.name = 'NDR Opportunity';
        a.Value__c = '012E0000000egdD';
        insert a;
        */
        Apex_Helper_Settings__c a1 = new Apex_Helper_Settings__c();
        a1.Name = 'Currency Confirm Except Users';
        a1.Value__c = '005E0000006CX4x';
        insert a1;
        
        return u;
    }
    public static map<String, set<string>> setUpTestData(User user){
        /*
        if (Type.forName('Channelinsight__CI_Configuration__c') != null) {
            Channelinsight__CI_Configuration__c c = new Channelinsight__CI_Configuration__c();
            c.Name = 'Default';
            c.Channelinsight__CONF_Stop_Matching_POS_to_Opportunity__c = 'Opportunity Is Closed';
            c.Channelinsight__CONF_Salesforce_Environment__c = 'Sandbox';
            c.Channelinsight__CONF_Reprocess_Reviewed__c = true;
            c.Channelinsight__CONF_Disable_Address_Type_Matching__c = true;  
            c.Channelinsight__CONF_Auto_mark_POS_Reviewed__c = false; 
            c.Channelinsight__CONF_Acct_Sales_Trending_Default_Address__c = 'Bill-to';
            insert c;
   }
*/
    
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        //ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        
        set<string> pids = new set<string>();
        map<String, set<string>> map_oIdtoPids = new map<String, set<string>>();
        Apex_Helper_Settings__c ahs1 = new Apex_Helper_Settings__c();
        ahs1.Name = 'oppy_BAU_snapshotForecastData_invalid';
        ahs1.Active__c = true;
        //insert ahs1;
        system.runAs(user){
            RecordType rt = ClsTestHelp.createTestRecordType();
            RecordType rt2 = ClsTestHelp.createTestRecordType23();
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            insert acc;
              
            
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.Request_Type__c = 'Extension';
            oppy2.RecordTypeId = rt2.Id;
            insert oppy2;  
              
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Program__c = oppy2.Id;   
            oppy.Type = 'CM';
            oppy.Request_Type__c = 'Extension';
            oppy.Method__c = 'BOM';
            oppy.Level__c = 'Yearly';
            oppy.Amount = 1;
            oppy.CurrencyIsoCode = 'EUR';
            oppy.Five_Year_Revenue__c = 1;
            oppy.RecordTypeId = rt2.Id;
            insert oppy;
            
            Product_Hierarchy__c ph = new Product_Hierarchy__c();
            ph.Hierarchy_Level_Type__c = 'CBC1';
            ph.Description__c = 'Industrial'; 
            insert ph;
            
            Part__c part = new Part__c();
            part.Description__c = 'Sniper';
            part.Product_Hierarchy__c = ph.Id;
            insert part;
            
            
            Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
            oppypart.Opportunity__c = oppy.Id;
            oppypart.Part__c = part.Id;
            insert oppypart;
            
            
            Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast.Opportunity__c = oppy.Id;
            oppyForecast.Quantity__c = 12;
            oppyForecast.Part__c = oppypart.Id;
            oppyForecast.Date__c = date.newInstance(2012, 09, 28);
            oppyForecast.Amount__c = 1;
            oppyForecast.Fiscal_Quarter__c = '03';
            oppyForecast.Fiscal_Month__c = '08';
            insert oppyForecast;
            /*
            Opportunity_Forecast__c oppyForecast2 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast2.Opportunity__c = oppy.Id;
            oppyForecast2.Quantity__c = 12;
            oppyForecast2.Part__c = oppypart.Id;
            oppyForecast2.Date__c = date.newInstance(2012, 09, 28);
            oppyForecast2.Amount__c = 1;
            insert oppyForecast2;
            
            map<Id, Decimal> map_partId_price = new map<Id, Decimal>();
            map_partId_price .put(part.Id,0);
            List<Opportunity_Forecast__c> oppyForecasts = new List<Opportunity_Forecast__c>();
            oppyForecasts.add(oppyForecast);
            oppyForecasts.add(oppyForecast2);
            
            Map<Id, List<Opportunity_Forecast__c>> partFCs = new Map<Id, List<Opportunity_Forecast__c>>();
            partFCs.put(oppypart.Id,oppyForecasts);*/
            
            pids.add(oppypart.Id);
            map_oIdtoPids.put(oppy.Id,pids);
        }
        return map_oIdtoPids;
    }
    
    
    public static list<APL_Oppy_Portal_Template__c> setUpTemplates(list<APL_Filter__c> filters,User u){
        list<APL_Oppy_Portal_Template__c> tmplts = new list<APL_Oppy_Portal_Template__c>();
        /*
        APL_Oppy_Portal_Template__c tmplt1 = new APL_Oppy_Portal_Template__c();
        tmplts.add(tmplt1);
        tmplt1.name = 'shawn_1';
        tmplt1.Report_Level__c = 'Opportunity';
        tmplt1.Report_Component__c = '';
        APL_Oppy_Portal_Template__c tmplt2 = new APL_Oppy_Portal_Template__c();
        tmplts.add(tmplt2);
        tmplt2.name = 'shawn_2';
        tmplt2.Report_Level__c = 'Opportunity';
        tmplt2.Report_Component__c = 'Account details,Opportunity details,Sales team,Time dimensions';
        
        APL_Oppy_Portal_Template__c tmplt3 = new APL_Oppy_Portal_Template__c();
        tmplts.add(tmplt3);
        tmplt3.name = 'shawn_3';
        tmplt3.Report_Level__c = 'Opportunity & Opportunity Part';
        tmplt3.Report_Component__c = 'Opportunity details';
        */
        
        APL_Oppy_Portal_Template__c tmplt4 = new APL_Oppy_Portal_Template__c();
        tmplts.add(tmplt4);
        tmplt4.name = 'shawn_4';
        tmplt4.Report_Level__c = 'Opportunity & Partner details';
        tmplt4.Report_Component__c = 'Opportunity details,Sales team';
        
        upsert tmplts;
        
        //setUpUserValues(filters,tmplt1,u);
        //setUpUserValues(filters,tmplt2,u);
        //setUpUserValues(filters,tmplt3,u);
        setUpUserValues(filters,tmplt4,u);
        return tmplts;
    }
    
    
    public static list<APL_User_Filter__c> setUpUserValues(list<APL_Filter__c> filters,APL_Oppy_Portal_Template__c tmplt,User u){
        list<APL_User_Filter__c> list_ufilters = new list<APL_User_Filter__c>();
        //Oppy
        APL_User_Filter__c ufilter1 = new APL_User_Filter__c();
        ufilter1.Template__c = tmplt.id;
        ufilter1.APL_Filter__c = filters.get(0).id;
        ufilter1.User__c = u.id;
        ufilter1.Value__c = 'Pipeline Exclude Overdue';
        
        APL_User_Filter__c ufilter2 = new APL_User_Filter__c();
        ufilter2.Template__c = tmplt.id;
        ufilter2.APL_Filter__c = filters.get(1).id;
        ufilter2.User__c = u.id;
        ufilter2.Value__c = 'None';
        
        APL_User_Filter__c ufilter3 = new APL_User_Filter__c();
        ufilter3.Template__c = tmplt.id;
        ufilter3.APL_Filter__c = filters.get(2).id;
        ufilter3.User__c = u.id;
        ufilter3.Value__c = 'None';
        //Time
        APL_User_Filter__c ufilter4 = new APL_User_Filter__c();
        ufilter4.Template__c = tmplt.id;
        ufilter4.APL_Filter__c = filters.get(3).id;
        ufilter4.User__c = u.id;
        ufilter4.Value__c = 'All the time';
        
        APL_User_Filter__c ufilter5 = new APL_User_Filter__c();
        ufilter5.Template__c = tmplt.id;
        ufilter5.APL_Filter__c = filters.get(4).id;
        ufilter5.User__c = u.id;
        ufilter5.Value__c = 'None';
        
        APL_User_Filter__c ufilter6 = new APL_User_Filter__c();
        ufilter6.Template__c = tmplt.id;
        ufilter6.APL_Filter__c = filters.get(5).id;
        ufilter6.User__c = u.id;
        ufilter6.Value__c = 'None';
        
        //Forcast
        APL_User_Filter__c ufilter7 = new APL_User_Filter__c();
        ufilter7.Template__c = tmplt.id;
        ufilter7.APL_Filter__c = filters.get(6).id;
        ufilter7.User__c = u.id;
        ufilter7.Value__c = 'true';
        
        APL_User_Filter__c ufilter8 = new APL_User_Filter__c();
        ufilter8.Template__c = tmplt.id;
        ufilter8.APL_Filter__c = filters.get(7).id;
        ufilter8.User__c = u.id;
        ufilter8.Value__c = 'true';
        
        APL_User_Filter__c ufilter9 = new APL_User_Filter__c();
        ufilter9.Template__c = tmplt.id;
        ufilter9.APL_Filter__c = filters.get(8).id;
        ufilter9.User__c = u.id;
        ufilter9.Value__c = 'true';
        
        APL_User_Filter__c ufilter10 = new APL_User_Filter__c();
        ufilter10.Template__c = tmplt.id;
        ufilter10.APL_Filter__c = filters.get(9).id;
        ufilter10.User__c = u.id;
        ufilter10.Value__c = 'true';
        
        APL_User_Filter__c ufilter11 = new APL_User_Filter__c();
        ufilter11.Template__c = tmplt.id;
        ufilter11.APL_Filter__c = filters.get(10).id;
        ufilter11.User__c = u.id;
        ufilter11.Value__c = 'true';
        
        APL_User_Filter__c ufilter12 = new APL_User_Filter__c();
        ufilter12.Template__c = tmplt.id;
        ufilter12.APL_Filter__c = filters.get(11).id;
        ufilter12.User__c = u.id;
        ufilter12.Value__c = 'true';
        
        APL_User_Filter__c ufilter13 = new APL_User_Filter__c();
        ufilter13.Template__c = tmplt.id;
        ufilter13.APL_Filter__c = filters.get(12).id;
        ufilter13.User__c = u.id;
        ufilter13.Value__c = 'true';
        
        APL_User_Filter__c ufilter14 = new APL_User_Filter__c();
        ufilter14.Template__c = tmplt.id;
        ufilter14.APL_Filter__c = filters.get(13).id;
        ufilter14.User__c = u.id;
        ufilter14.Value__c = '2015:2016';
        
        APL_User_Filter__c ufilter15 = new APL_User_Filter__c();
        ufilter15.Template__c = tmplt.id;
        ufilter15.APL_Filter__c = filters.get(14).id;
        ufilter15.User__c = u.id;
        ufilter15.Value__c = 'By Year';
        
        //Product
        APL_User_Filter__c ufilter16 = new APL_User_Filter__c();
        ufilter16.Template__c = tmplt.id;
        ufilter16.APL_Filter__c = filters.get(15).id;
        ufilter16.User__c = u.id;
        ufilter16.Value__c = 'APL Users';
        
        APL_User_Filter__c ufilter17 = new APL_User_Filter__c();
        ufilter17.Template__c = tmplt.id;
        ufilter17.APL_Filter__c = filters.get(16).id;
        ufilter17.User__c = u.id;
        ufilter17.Value__c = '';
        
        APL_User_Filter__c ufilter18 = new APL_User_Filter__c();
        ufilter18.Template__c = tmplt.id;
        ufilter18.APL_Filter__c = filters.get(17).id;
        ufilter18.User__c = u.id;
        ufilter18.Value__c = '';
        
        APL_User_Filter__c ufilter19 = new APL_User_Filter__c();
        ufilter19.Template__c = tmplt.id;
        ufilter19.APL_Filter__c = filters.get(18).id;
        ufilter19.User__c = u.id;
        ufilter19.Value__c = '';
        
        APL_User_Filter__c ufilter20 = new APL_User_Filter__c();
        ufilter20.Template__c = tmplt.id;
        ufilter20.APL_Filter__c = filters.get(19).id;
        ufilter20.User__c = u.id;
        ufilter20.Value__c = '';
        
        APL_User_Filter__c ufilter21 = new APL_User_Filter__c();
        ufilter21.Template__c = tmplt.id;
        ufilter21.APL_Filter__c = filters.get(20).id;
        ufilter21.User__c = u.id;
        ufilter21.Value__c = '';
        
        APL_User_Filter__c ufilter22 = new APL_User_Filter__c();
        ufilter22.Template__c = tmplt.id;
        ufilter22.APL_Filter__c = filters.get(21).id;
        ufilter22.User__c = u.id;
        ufilter22.Value__c = '';
        
        APL_User_Filter__c ufilter23 = new APL_User_Filter__c();
        ufilter23.Template__c = tmplt.id;
        ufilter23.APL_Filter__c = filters.get(22).id;
        ufilter23.User__c = u.id;
        ufilter23.Value__c = '';
        
        //prdt
        APL_User_Filter__c ufilter24 = new APL_User_Filter__c();
        ufilter24.Template__c = tmplt.id;
        ufilter24.APL_Filter__c = filters.get(23).id;
        ufilter24.User__c = u.id;
        ufilter24.Value__c = 'None';
        
        APL_User_Filter__c ufilter25 = new APL_User_Filter__c();
        ufilter25.Template__c = tmplt.id;
        ufilter25.APL_Filter__c = filters.get(24).id;
        ufilter25.User__c = u.id;
        ufilter25.Value__c = 'None';
        
        APL_User_Filter__c ufilter26 = new APL_User_Filter__c();
        ufilter26.Template__c = tmplt.id;
        ufilter26.APL_Filter__c = filters.get(25).id;
        ufilter26.User__c = u.id;
        ufilter26.Value__c = 'None';
        
        APL_User_Filter__c ufilter27 = new APL_User_Filter__c();
        ufilter27.Template__c = tmplt.id;
        ufilter27.APL_Filter__c = filters.get(26).id;
        ufilter27.User__c = u.id;
        ufilter27.Value__c = 'None';
        
        APL_User_Filter__c ufilter28 = new APL_User_Filter__c();
        ufilter28.Template__c = tmplt.id;
        ufilter28.APL_Filter__c = filters.get(27).id;
        ufilter28.User__c = u.id;
        ufilter28.Value__c = '';
        //other
        APL_User_Filter__c ufilter29 = new APL_User_Filter__c();
        ufilter29.Template__c = tmplt.id;
        ufilter29.APL_Filter__c = filters.get(28).id;
        ufilter29.User__c = u.id;
        ufilter29.Value__c = 'None';
        
        APL_User_Filter__c ufilter30 = new APL_User_Filter__c();
        ufilter30.Template__c = tmplt.id;
        ufilter30.APL_Filter__c = filters.get(29).id;
        ufilter30.User__c = u.id;
        ufilter30.Value__c = '';
        upsert list_ufilters;
        
        return list_ufilters;
    } 
    
    
    public static list<APLFilter_FieldSet__c> setUpCustomerSetting(){
        list<APLFilter_FieldSet__c> settings =  new list<APLFilter_FieldSet__c>();
        APLFilter_FieldSet__c cs1 = new APLFilter_FieldSet__c();
        settings.add(cs1);
        cs1.Name = 'Account details';
        cs1.Reference_FieldSet_Name__c = 'Account_details';
        cs1.Reference_Object__c = 'Opportunity';
        cs1.Selected__c = true;
        
        APLFilter_FieldSet__c cs2 = new APLFilter_FieldSet__c();
        settings.add(cs2);
        cs2.Name = 'Mandatory columns';
        cs2.Reference_FieldSet_Name__c = 'Mandatory_columns';
        cs2.Reference_Object__c = 'Opportunity';
        cs2.Selected__c = true;
        
        APLFilter_FieldSet__c cs3 = new APLFilter_FieldSet__c();
        settings.add(cs3);
        cs3.Name = 'Opportunity details';
        cs3.Reference_FieldSet_Name__c = 'Opportunity_details';
        cs3.Reference_Object__c = 'Opportunity';
        cs3.Selected__c = true;
        
        APLFilter_FieldSet__c cs4 = new APLFilter_FieldSet__c();
        settings.add(cs4);
        cs4.Name = 'Opportunity Part details';
        cs4.Reference_FieldSet_Name__c = 'Opportunity_Part_details';
        cs4.Reference_Object__c = 'Opportunity_Part__c';
        cs4.Selected__c = true;
        
        APLFilter_FieldSet__c cs5 = new APLFilter_FieldSet__c();
        settings.add(cs5);
        cs5.Name = 'Opportunity Partner details';
        cs5.Reference_FieldSet_Name__c = 'Opportunity_Partner_details';
        cs5.Reference_Object__c = 'Opportunity_Partner__c';
        cs5.Selected__c = true;
        
        APLFilter_FieldSet__c cs6 = new APLFilter_FieldSet__c();
        settings.add(cs6);
        cs6.Name = 'Sales team';
        cs6.Reference_FieldSet_Name__c = 'Sales_team';
        cs6.Reference_Object__c = 'Opportunity';
        cs6.Selected__c = true;
        
        APLFilter_FieldSet__c cs7 = new APLFilter_FieldSet__c();
        settings.add(cs7);
        cs7.Name = 'Time dimensions';
        cs7.Reference_FieldSet_Name__c = 'Time_dimensions';
        cs7.Reference_Object__c = 'Opportunity';
        cs7.Selected__c = true;
        
        return settings;
    }
    
    public static list<APL_Filter__c> setUpAPLFilters(){
        list<APL_Filter__c> filters = new list<APL_Filter__c>();
        
        list<APL_Filter__c> oppys = oppyCategoryFilters();
        filters.addAll(oppys);
        list<APL_Filter__c> times = timeCategoryFilters(oppys);
        list<APL_Filter__c> fcsts = forecastCategoryFilters();
        list<APL_Filter__c> sales = salesCategoryFilters();
        list<APL_Filter__c> prdts = prdtCategoryFilters();
        list<APL_Filter__c> others = otherCategoryFilters();
        
        filters.addAll(oppys);
        filters.addAll(times);
        filters.addAll(fcsts);
        filters.addAll(sales);
        filters.addAll(prdts);
        filters.addAll(others);
        
        for(APL_Filter__c filter : [ Select Active__c, APL_Filter__c, Category__c, ConnectionReceivedId, 
                                            ConnectionSentId, CreatedById, CreatedDate, CurrencyIsoCode, 
                                            Default_Clause_SOQL__c, Display_by_Parent_value__c, Display_Name__c, 
                                            Domain_Values__c, Domain_Values_Soql__c, Id, Is_Reqired__c, 
                                            IsDeleted, LastModifiedById, LastModifiedDate, LastReferencedDate, 
                                            LastViewedDate, Name, Object__c, Oppy_Forecast_Label_Name__c, Order__c, 
                                            OwnerId, Params_Mapping__c, Result_Filter__c, SystemModstamp, Type__c
                                     From APL_Filter__c]) {
            filters.add(filter);             
        }
        return filters;
    }
    
    public static list<APL_Filter__c> oppyCategoryFilters(){
        list<APL_Filter__c> list_filters = new list<APL_Filter__c>();
        APL_Filter__c filter1 = new APL_Filter__c();
        list_filters.add(filter1);
        filter1.APL_Filter__c = null;
        filter1.Is_Reqired__c = true;
        filter1.Category__c = 'Opportunity Category';
        filter1.Display_Name__c = 'APL Opportunity Type';
        filter1.Display_by_Parent_value__c = null;
        filter1.Domain_Values_Soql__c = null;
        filter1.Params_Mapping__c = null;
        filter1.Result_Filter__c = false;
        filter1.Object__c = 'Opportunity_Part__c';
        filter1.Type__c = 'Picklist';
        filter1.Order__c = 1;
        filter1.Default_Clause_SOQL__c = null;
        filter1.Oppy_Forecast_Label_Name__c = null;
        filter1.Active__c = true;
        insert filter1;
        setUpDomainValues(filter1);
        
        APL_Filter__c filter2 = new APL_Filter__c();
        list_filters.add(filter2);
        filter2.APL_Filter__c = filter1.Id;
        filter2.Is_Reqired__c = false;
        filter2.Category__c = 'Opportunity Category';
        filter2.Display_Name__c = 'Opportunity Update Status';
        filter2.Display_by_Parent_value__c = 'TAM Opportunity;Other BU pipeline with APL products';
        filter2.Domain_Values_Soql__c = null;
        filter2.Params_Mapping__c = null;
        filter2.Result_Filter__c = false;
        filter2.Object__c = 'Opportunity_Part__c';
        filter2.Type__c = 'Picklist';
        filter2.Order__c = 2;
        filter2.Default_Clause_SOQL__c = null;
        filter2.Oppy_Forecast_Label_Name__c = null;
        filter2.Active__c = true;
        insert filter2;
        setUpDomainValues(filter2);
        
        APL_Filter__c filter3 = new APL_Filter__c();
        list_filters.add(filter3);
        filter3.APL_Filter__c = filter1.Id;
        filter3.Is_Reqired__c = false;
        filter3.Category__c = 'Opportunity Category';
        filter3.Display_Name__c = 'Opportunity Part confidence & status';
        filter3.Display_by_Parent_value__c = 'Pipeline Exclude Overdue;Pipeline Include Overdue;SIP Pipeline;Other BU pipeline with APL products';
        filter3.Domain_Values_Soql__c = null;
        filter3.Params_Mapping__c = null;
        filter3.Result_Filter__c = false;
        filter3.Object__c = 'Opportunity_Part__c';
        filter3.Type__c = 'MultiPicklist';
        filter3.Order__c = 3;
        filter3.Default_Clause_SOQL__c = null;
        filter3.Oppy_Forecast_Label_Name__c = null;
        filter3.Active__c = true;
        insert filter3;
        setUpDomainValues(filter3);//'Opportunity Part confidence & status'
        return list_filters;
        //Miss one == 'Opportunity Part confidence & status'
    }
    
    
    public static list<APL_Filter__c> forecastCategoryFilters(){
        list<APL_Filter__c> list_filters = new list<APL_Filter__c>();
        
        APL_Filter__c filter1 = new APL_Filter__c();
        list_filters.add(filter1);
        filter1.APL_Filter__c = null;
        filter1.Is_Reqired__c = false;
        filter1.Category__c = 'Forecast Category';
        filter1.Display_Name__c = 'Standard Opportunity Forecast';
        filter1.Display_by_Parent_value__c = null;
        filter1.Domain_Values_Soql__c = null;
        filter1.Params_Mapping__c = null;
        filter1.Result_Filter__c = true;
        filter1.Object__c = '';
        filter1.Type__c = 'Checkbox';
        filter1.Order__c = 7;
        filter1.Default_Clause_SOQL__c = null;
        filter1.Oppy_Forecast_Label_Name__c = 'SF';
        filter1.Active__c = true;
        
        APL_Filter__c filter2 = new APL_Filter__c();
        list_filters.add(filter2);
        filter2.APL_Filter__c = null;
        filter2.Is_Reqired__c = false;
        filter2.Category__c = 'Forecast Category';
        filter2.Display_Name__c = 'Weighted Forecast';
        filter2.Display_by_Parent_value__c = null;
        filter2.Domain_Values_Soql__c = null;
        filter2.Params_Mapping__c = null;
        filter2.Result_Filter__c = true;
        filter2.Object__c = '';
        filter2.Type__c = 'Checkbox';
        filter2.Order__c = 8;
        filter2.Default_Clause_SOQL__c = null;
        filter2.Oppy_Forecast_Label_Name__c = 'Wt';
        filter2.Active__c = true;
        
        APL_Filter__c filter3 = new APL_Filter__c();
        list_filters.add(filter3);
        filter3.APL_Filter__c = null;
        filter3.Is_Reqired__c = false;
        filter3.Category__c = 'Forecast Category';
        filter3.Display_Name__c = 'New Business forecast';
        filter3.Display_by_Parent_value__c = null;
        filter3.Domain_Values_Soql__c = null;
        filter3.Params_Mapping__c = null;
        filter3.Result_Filter__c = true;
        filter3.Object__c = '';
        filter3.Type__c = 'Checkbox';
        filter3.Order__c = 9;
        filter3.Default_Clause_SOQL__c = null;
        filter3.Oppy_Forecast_Label_Name__c = 'NB';
        filter3.Active__c = true;
        
        APL_Filter__c filter4 = new APL_Filter__c();
        list_filters.add(filter4);
        filter4.APL_Filter__c = null;
        filter4.Is_Reqired__c = false;
        filter4.Category__c = 'Forecast Category';
        filter4.Display_Name__c = 'Weighted New Business';
        filter4.Display_by_Parent_value__c = null;
        filter4.Domain_Values_Soql__c = null;
        filter4.Params_Mapping__c = null;
        filter4.Result_Filter__c = true;
        filter4.Object__c = '';
        filter4.Type__c = 'Checkbox';
        filter4.Order__c = 10;
        filter4.Default_Clause_SOQL__c = null;
        filter4.Oppy_Forecast_Label_Name__c = 'Wt NB';
        filter4.Active__c = true;
        
        APL_Filter__c filter5 = new APL_Filter__c();
        list_filters.add(filter5);
        filter5.APL_Filter__c = null;
        filter5.Is_Reqired__c = false;
        filter5.Category__c = 'Forecast Category';
        filter5.Display_Name__c = 'NPS1 Forecast';
        filter5.Display_by_Parent_value__c = null;
        filter5.Domain_Values_Soql__c = null;
        filter5.Params_Mapping__c = null;
        filter5.Result_Filter__c = true;
        filter5.Object__c = '';
        filter5.Type__c = 'Checkbox';
        filter5.Order__c = 11;
        filter5.Default_Clause_SOQL__c = null;
        filter5.Oppy_Forecast_Label_Name__c = 'NPS1';
        filter5.Active__c = true;
        
        APL_Filter__c filter6 = new APL_Filter__c();
        list_filters.add(filter6);
        filter6.APL_Filter__c = null;
        filter6.Is_Reqired__c = false;
        filter6.Category__c = 'Forecast Category';
        filter6.Display_Name__c = 'NPS2 Forecast';
        filter6.Display_by_Parent_value__c = null;
        filter6.Domain_Values_Soql__c = null;
        filter6.Params_Mapping__c = null;
        filter6.Result_Filter__c = true;
        filter6.Object__c = '';
        filter6.Type__c = 'Checkbox';
        filter6.Order__c = 12;
        filter6.Default_Clause_SOQL__c = null;
        filter6.Oppy_Forecast_Label_Name__c = 'NPS2';
        filter6.Active__c = true;
        
        APL_Filter__c filter7 = new APL_Filter__c();
        list_filters.add(filter7);
        filter7.APL_Filter__c = null;
        filter7.Is_Reqired__c = false;
        filter7.Category__c = 'Forecast Category';
        filter7.Display_Name__c = 'NPS2 Forecast';
        filter7.Display_by_Parent_value__c = null;
        filter7.Domain_Values_Soql__c = null;
        filter7.Params_Mapping__c = null;
        filter7.Result_Filter__c = true;
        filter7.Object__c = '';
        filter7.Type__c = 'Checkbox';
        filter7.Order__c = 12;
        filter7.Default_Clause_SOQL__c = null;
        filter7.Oppy_Forecast_Label_Name__c = 'NPS2';
        filter7.Active__c = true;
        
        APL_Filter__c filter8 = new APL_Filter__c();
        list_filters.add(filter8);
        filter8.APL_Filter__c = null;
        filter8.Is_Reqired__c = false;
        filter8.Category__c = 'Forecast Category';
        filter8.Display_Name__c = 'Forecast Years selection';
        filter8.Display_by_Parent_value__c = null;
        filter8.Domain_Values_Soql__c = null;
        filter8.Params_Mapping__c = null;
        filter8.Result_Filter__c = true;
        filter8.Object__c = '';
        filter8.Type__c = 'Year';
        filter8.Order__c = 14;
        filter8.Default_Clause_SOQL__c = 'Fiscal_Year__c >=($startyear$) and Fiscal_Year__c <=($endyear$)';
        filter8.Oppy_Forecast_Label_Name__c = '';
        filter8.Active__c = true;
        
        APL_Filter__c filter9 = new APL_Filter__c();
        list_filters.add(filter9);
        filter9.APL_Filter__c = null;
        filter9.Is_Reqired__c = true;
        filter9.Category__c = 'Forecast Category';
        filter9.Display_Name__c = 'Forecast display';
        filter9.Display_by_Parent_value__c = null;
        filter9.Domain_Values_Soql__c = null;
        filter9.Params_Mapping__c = null;
        filter9.Result_Filter__c = true;
        filter9.Object__c = '';
        filter9.Type__c = 'Picklist';
        filter9.Order__c = 15;
        filter9.Default_Clause_SOQL__c = null;
        filter9.Oppy_Forecast_Label_Name__c = '';
        filter9.Active__c = true;
        insert filter9;
        setUpDomainValues(filter9);
        
        upsert list_filters;
        return list_filters;
    }
    
    
     public static list<APL_Filter__c> timeCategoryFilters(list<APL_Filter__c> oppys){
        list<APL_Filter__c> list_filters = new list<APL_Filter__c>();
        APL_Filter__c filter1 = new APL_Filter__c();
        list_filters.add(filter1);
        filter1.APL_Filter__c = null;
        filter1.Is_Reqired__c = false;
        filter1.Category__c = 'Time Dimensions';
        filter1.Display_Name__c = 'Opp Create date';
        filter1.Display_by_Parent_value__c = null;
        filter1.Domain_Values_Soql__c = null;
        filter1.Params_Mapping__c = null;
        filter1.Result_Filter__c = false;
        filter1.Object__c = 'Opportunity';
        filter1.Type__c = 'Date';
        filter1.Order__c = 4;
        filter1.Default_Clause_SOQL__c = null;
        filter1.Active__c = true;
        insert filter1;
        setUpDomainValues(filter1);
        
        APL_Filter__c filter2 = new APL_Filter__c();
        list_filters.add(filter2);
        filter2.APL_Filter__c = oppys.get(0).id;
        filter2.Is_Reqired__c = false;
        filter2.Category__c = 'Time Dimensions';
        filter2.Display_Name__c = 'Lost start date';
        filter2.Display_by_Parent_value__c = 'APL Lost Business';
        filter2.Domain_Values_Soql__c = null;
        filter2.Params_Mapping__c = null;
        filter2.Result_Filter__c = false;
        filter2.Object__c = 'Opportunity';
        filter2.Type__c = 'Date';
        filter2.Order__c = 5;
        filter2.Default_Clause_SOQL__c = null;
        filter2.Active__c = true;
        insert filter2;
        setUpDomainValues(filter2);
        
        APL_Filter__c filter3 = new APL_Filter__c();
        list_filters.add(filter3);
        filter3.APL_Filter__c = oppys.get(0).id;
        filter3.Is_Reqired__c = false;
        filter3.Category__c = 'Time Dimensions';
        filter3.Display_Name__c = 'Opp Won date';
        filter3.Display_by_Parent_value__c = 'Pipeline Exclude Overdue;Pipeline Include Overdue;SIP Pipeline;Overdue Opportunity;TAM Opportunity;Other BU pipeline with APL products';
        filter3.Domain_Values_Soql__c = null;
        filter3.Params_Mapping__c = null;
        filter3.Result_Filter__c = false;
        filter3.Object__c = 'Opportunity_Part__c';
        filter3.Type__c = 'Date';
        filter3.Order__c = 6;
        filter3.Default_Clause_SOQL__c = null;
        filter3.Active__c = true;
        insert filter3;
        setUpDomainValues(filter3);
        
        return list_filters;
     }
     public static list<APL_Filter__c> prdtCategoryFilters(){
        list<APL_Filter__c> list_filters = new list<APL_Filter__c>();
        
        APL_Filter__c filter1 = new APL_Filter__c();
        list_filters.add(filter1);
        filter1.APL_Filter__c = null;
        filter1.Is_Reqired__c = true;
        filter1.Category__c = 'Product Dimensions';
        filter1.Display_Name__c = 'Product Family';
        filter1.Display_by_Parent_value__c = null;
        filter1.Domain_Values_Soql__c = null;
        filter1.Params_Mapping__c = null;
        filter1.Result_Filter__c = false;
        filter1.Object__c = 'Opportunity_Part__c';
        filter1.Type__c = 'Picklist';
        filter1.Order__c = 24;
        filter1.Default_Clause_SOQL__c = null;
        filter1.Active__c = true;
        insert filter1;
        setUpDomainValues(filter1);
        
        
        APL_Filter__c filter2 = new APL_Filter__c();
        list_filters.add(filter2);
        filter2.APL_Filter__c = filter1.id;
        filter2.Is_Reqired__c = false;
        filter2.Category__c = 'Product Dimensions';
        filter2.Display_Name__c = 'GPL';
        filter2.Display_by_Parent_value__c = '';
        filter2.Domain_Values_Soql__c = 'select Name, Id from Product_Hierarchy__c where (CBC2__c in ($Parent$)) or (CBC3__c in ($Parent$)) group by Name, Id';
        filter2.Params_Mapping__c = 'Name; Id';
        filter2.Result_Filter__c = false;
        filter2.Object__c = 'Opportunity_Part__c';
        filter2.Type__c = 'MultiPicklist';
        filter2.Order__c = 25;
        filter2.Default_Clause_SOQL__c = 'GPL__r.Id in ($Values$)';
        filter2.Active__c = false;
        insert filter2;
        
        APL_Filter__c filter3 = new APL_Filter__c();
        list_filters.add(filter3);
        filter3.APL_Filter__c = filter2.id;
        filter3.Is_Reqired__c = false;
        filter3.Category__c = 'Product Dimensions';
        filter3.Display_Name__c = 'Product code';
        filter3.Display_by_Parent_value__c = '';
        filter3.Domain_Values_Soql__c = 'select PRODUCT_CDE__c from Part__c where Product_Hierarchy__c in ($Parent$) group by PRODUCT_CDE__c';
        filter3.Params_Mapping__c = 'PRODUCT_CDE__c; PRODUCT_CDE__c';
        filter3.Result_Filter__c = false;
        filter3.Object__c = 'Opportunity_Part__c';
        filter3.Type__c = 'MultiPicklist';
        filter3.Order__c = 26;
        filter3.Default_Clause_SOQL__c = 'Part__r.PRODUCT_CDE__c in ($Values$)';
        filter3.Active__c = false;
        insert filter3;
        
        APL_Filter__c filter5 = new APL_Filter__c();
        list_filters.add(filter5);
        filter5.APL_Filter__c = null;
        filter5.Is_Reqired__c = false;
        filter5.Category__c = 'Product Dimensions';
        filter5.Display_Name__c = 'NPS Category';
        filter5.Display_by_Parent_value__c = '';
        filter5.Domain_Values_Soql__c = '';
        filter5.Params_Mapping__c = '';
        filter5.Result_Filter__c = false;
        filter5.Object__c = 'Opportunity_Part__c';
        filter5.Type__c = 'Picklist';
        filter5.Order__c = 27;
        filter5.Default_Clause_SOQL__c = 'Part__r.NPS_category__c in ($Values$)';
        filter5.Active__c = true;
        insert filter5;
        setUpDomainValues(filter5);
        
        APL_Filter__c filter6 = new APL_Filter__c();
        list_filters.add(filter6);
        filter6.APL_Filter__c = null;
        filter6.Is_Reqired__c = false;
        filter6.Category__c = 'Product Dimensions';
        filter6.Display_Name__c = 'PLM Project No';
        filter6.Display_by_Parent_value__c = '';
        filter6.Domain_Values_Soql__c = 'Select Opportunity__r.PLM_Id__c, Opportunity__r.APL_PLM_Bucket_Project__c from Opportunity_Part__c where BU_profit_center__c = \'Appliances\' group by Opportunity__r.PLM_Id__c, Opportunity__r.APL_PLM_Bucket_Project__c';
        filter6.Params_Mapping__c = 'PLM_Id__c; APL_PLM_Bucket_Project__c';
        filter6.Result_Filter__c = false;
        filter6.Object__c = 'Opportunity';
        filter6.Type__c = 'MultiPicklist';
        filter6.Order__c = 26;
        filter6.Default_Clause_SOQL__c = '(APL_PLM_Bucket_Project_16__c in ($Values$) or PLM_Id__c in ($Values$))';
        filter6.Active__c = false;
        insert filter6;
        return list_filters;
     }
     
     public static list<APL_Filter__c> salesCategoryFilters(){
        list<APL_Filter__c> list_filters = new list<APL_Filter__c>();
        
        APL_Filter__c filter1 = new APL_Filter__c();
        list_filters.add(filter1);
        filter1.APL_Filter__c = null;
        filter1.Is_Reqired__c = true;
        filter1.Category__c = 'Sales Dimensions';
        filter1.Display_Name__c = 'Opportunity Owner BU';
        filter1.Display_by_Parent_value__c = null;
        filter1.Domain_Values_Soql__c = null;
        filter1.Params_Mapping__c = null;
        filter1.Result_Filter__c = false;
        filter1.Object__c = 'Opportunity';
        filter1.Type__c = 'Picklist';
        filter1.Order__c = 16;
        filter1.Default_Clause_SOQL__c = 'Opportunity_Owner_Profile__c in ($Values$)';
        filter1.Active__c = true;
        insert filter1;
        setUpDomainValues(filter1);
        
        APL_Filter__c filter2 = new APL_Filter__c();
        list_filters.add(filter2);
        filter2.APL_Filter__c = null;
        filter2.Is_Reqired__c = false;
        filter2.Category__c = 'Sales Dimensions';
        filter2.Display_Name__c = 'Customer country';
        filter2.Display_by_Parent_value__c = '';
        filter2.Domain_Values_Soql__c = '';
        filter2.Params_Mapping__c = '';
        filter2.Result_Filter__c = false;
        filter2.Object__c = 'Opportunity';
        filter2.Type__c = 'MultiPicklist';
        filter2.Order__c = 18;
        filter2.Default_Clause_SOQL__c = 'Account.BillingCountry in ($Values$)';
        filter2.Active__c = true;
        insert filter2;
        
        APL_Filter__c filter3 = new APL_Filter__c();
        list_filters.add(filter3);
        filter3.APL_Filter__c = null;
        filter3.Is_Reqired__c = false;
        filter3.Category__c = 'Sales Dimensions';
        filter3.Display_Name__c = 'Customer Region';
        filter3.Display_by_Parent_value__c = '';
        filter3.Domain_Values_Soql__c = '';
        filter3.Params_Mapping__c = '';
        filter3.Result_Filter__c = false;
        filter3.Object__c = 'Opportunity';
        filter3.Type__c = 'MultiPicklist';
        filter3.Order__c = 17;
        filter3.Default_Clause_SOQL__c = 'Account.Customer_Region__c in ($Values$)';
        filter3.Active__c = true;
        insert filter3;
        
        APL_Filter__c filter4 = new APL_Filter__c();
        list_filters.add(filter4);
        filter4.APL_Filter__c = null;
        filter4.Is_Reqired__c = false;
        filter4.Category__c = 'Sales Dimensions';
        filter4.Display_Name__c = 'GAM Name';
        filter4.Display_by_Parent_value__c = '';
        filter4.Domain_Values_Soql__c = 'select Level_7_Territory_Name__c,Level_7_Territory_code__c from Sales_Hierarchy__c where Level_6_Territory_Name__c = \'Appliance\' and Hierarchy_Type__c = \'Global Account Manager Hierarchy (GAM)\' group by Level_7_Territory_Name__c,Level_7_Territory_code__c';
        filter4.Params_Mapping__c = 'Level_7_Territory_Name__c;Level_7_Territory_code__c';
        filter4.Result_Filter__c = false;
        filter4.Object__c = 'Opportunity';
        filter4.Type__c = 'Picklist';
        filter4.Order__c = 19;
        filter4.Default_Clause_SOQL__c = 'Account.GAMCD__c in ($Values$)';
        filter4.Active__c = false;
        insert filter4;
        
        APL_Filter__c filter5 = new APL_Filter__c();
        list_filters.add(filter5);
        filter5.APL_Filter__c = filter1.id;
        filter5.Is_Reqired__c = false;
        filter5.Category__c = 'Sales Dimensions';
        filter5.Display_Name__c = 'Opportunity Owner';
        filter5.Display_by_Parent_value__c = null;
        filter5.Domain_Values_Soql__c = 'Select Name from User where Profile.Name in ($Parent$) group by Name';
        filter5.Params_Mapping__c = 'Name;Name';
        filter5.Result_Filter__c = false;
        filter5.Object__c = 'Opportunity';
        filter5.Type__c = 'MultiPicklist';
        filter5.Order__c = 20;
        filter5.Default_Clause_SOQL__c = 'Owner.name in ($Values$)';
        filter5.Active__c = true;
        insert filter5;
        
        APL_Filter__c filter6 = new APL_Filter__c();
        list_filters.add(filter6);
        filter6.APL_Filter__c = filter1.id;
        filter6.Is_Reqired__c = false;
        filter6.Category__c = 'Sales Dimensions';
        filter6.Display_Name__c = 'Account Owner';
        filter6.Display_by_Parent_value__c = '';
        filter6.Domain_Values_Soql__c = 'Select Account.Owner.Name from Opportunity where Owner.Profile.Name in ($Parent$) group by Account.Owner.Name';
        filter6.Params_Mapping__c = 'Name;Name';
        filter6.Result_Filter__c = false;
        filter6.Object__c = 'Opportunity';
        filter6.Type__c = 'MultiPicklist';
        filter6.Order__c = 21;
        filter6.Default_Clause_SOQL__c = 'Account_Owner__r.name in ($Values$)';
        filter6.Active__c = false;
        insert filter6;
        
        APL_Filter__c filter7 = new APL_Filter__c();
        list_filters.add(filter7);
        filter7.APL_Filter__c = filter1.id;
        filter7.Is_Reqired__c = false;
        filter7.Category__c = 'Sales Dimensions';
        filter7.Display_Name__c = 'Field Engineer';
        filter7.Display_by_Parent_value__c = '';
        filter7.Domain_Values_Soql__c = 'Select Account.ACCTMGRNM__c from Opportunity where Account.FE_Hierarchy__r.Level_7_Default_Owner__r.Profile.name in ($Parent$) and Account.FE_Hierarchy__r.Hierarchy_Type__c = \'Account Manager Hierarchy (FE)\' group by Account.ACCTMGRNM__c';
        filter7.Params_Mapping__c = 'ACCTMGRNM__c;ACCTMGRNM__c';
        filter7.Result_Filter__c = false;
        filter7.Object__c = 'Opportunity_Part__c';
        filter7.Type__c = 'MultiPicklist';
        filter7.Order__c = 22;
        filter7.Default_Clause_SOQL__c = 'Account.ACCTMGRNM__c in ($Values$)';
        filter7.Active__c = false;
        insert filter7;
        
        APL_Filter__c filter8 = new APL_Filter__c();
        list_filters.add(filter8);
        filter8.APL_Filter__c = null;
        filter8.Is_Reqired__c = false;
        filter8.Category__c = 'Sales Dimensions';
        filter8.Display_Name__c = 'Relay AE';
        filter8.Display_by_Parent_value__c = '';
        filter8.Domain_Values_Soql__c = '';
        filter8.Params_Mapping__c = '';
        filter8.Result_Filter__c = false;
        filter8.Object__c = 'Opportunity';
        filter8.Type__c = 'MultiPicklist';
        filter8.Order__c = 23;
        filter8.Default_Clause_SOQL__c = 'REL_AE_Name__c in ($Values$)';
        filter8.Active__c = true;
        insert filter8;
        setUpDomainValues(filter8);
        
        return list_filters;
     }
     //salesCategoryFilters() otherCategoryFilters
     
     public static list<APL_Filter__c> otherCategoryFilters(){
        list<APL_Filter__c> list_filters = new list<APL_Filter__c>();
        
        APL_Filter__c filter1 = new APL_Filter__c();
        list_filters.add(filter1);
        filter1.APL_Filter__c = null;
        filter1.Is_Reqired__c = false;
        filter1.Category__c = 'Other Dimensions';
        filter1.Display_Name__c = 'Relay Technical Status';
        filter1.Display_by_Parent_value__c = '';
        filter1.Domain_Values_Soql__c = '';
        filter1.Params_Mapping__c = '';
        filter1.Result_Filter__c = false;
        filter1.Object__c = 'Opportunity_Part__c';
        filter1.Type__c = 'MultiPicklist';
        filter1.Order__c = 20;
        filter1.Default_Clause_SOQL__c = 'Technical_Status__c in ($Values$)';
        filter1.Active__c = true;
        insert filter1;
        setUpDomainValues(filter1);
        
        APL_Filter__c filter2 = new APL_Filter__c();
        list_filters.add(filter2);
        filter2.APL_Filter__c = null;
        filter2.Is_Reqired__c = false;
        filter2.Category__c = 'Other Dimensions';
        filter2.Display_Name__c = 'Relay AE Close out Date';
        filter2.Display_by_Parent_value__c = null;
        filter2.Domain_Values_Soql__c = null;
        filter2.Params_Mapping__c = null;
        filter2.Result_Filter__c = false;
        filter2.Object__c = 'Opportunity_Part__c';
        filter2.Type__c = 'Date';
        filter2.Order__c = 30;
        filter2.Default_Clause_SOQL__c = '';
        filter2.Active__c = true;
        insert filter2;
        setUpDomainValues(filter2);
        
        return list_filters;
     }
    
    public static void setUpDomainValues(APL_Filter__c filter){
        list<APL_Filter_Domain_Values__c> domainValues = new list<APL_Filter_Domain_Values__c>();
        if(filter.Display_Name__c.equals('APL Opportunity Type')){
            APL_Filter_Domain_Values__c dvalue1 = new APL_Filter_Domain_Values__c();
            dvalue1.Display_Name__c = 'Pipeline Exclude Overdue';
            dvalue1.Value__c = 'Pipeline Exclude Overdue';
            dvalue1.Condition_Clause_SOQL__c = 'APL_Active_Pipeline__c = \'YES\'';
            dvalue1.Disable_Children_Query__c = false;
            dvalue1.Order__c =1;
            dvalue1.Public_Group_Access__c = '';
            dvalue1.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue2 = new APL_Filter_Domain_Values__c();
            dvalue2.Display_Name__c = 'Pipeline Include Overdue';
            dvalue2.Value__c = 'Pipeline Include Overdue';
            dvalue2.Condition_Clause_SOQL__c = '(APL_Active_Pipeline__c = \'YES\' or Overdue_need_update__c = \'YES\')';
            dvalue2.Disable_Children_Query__c = false;
            dvalue2.Order__c = 2;
            dvalue2.Public_Group_Access__c = '';
            dvalue2.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue3 = new APL_Filter_Domain_Values__c();
            dvalue3.Display_Name__c = 'SIP Pipeline';
            dvalue3.Value__c = 'SIP Pipeline';
            dvalue3.Condition_Clause_SOQL__c = 'APL_Active_Pipeline__c = \'YES\' and (((Status__c in (\'Weak\',\'50/50\',\'Likely\',\'Commit\') or (Status__c = \'Won\' and Process_Status__c = \'Pre-prod\')) and Opportunity__r.CreatedDate = THIS_FISCAL_YEAR) or (Status__c = \'Won\' and Process_Status__c =\'Production\'))';
            dvalue3.Disable_Children_Query__c = false;
            dvalue3.Order__c = 3;
            dvalue3.Public_Group_Access__c = '';
            dvalue3.APL_Filter__c = filter.Id;  
            
            APL_Filter_Domain_Values__c dvalue4 = new APL_Filter_Domain_Values__c();
            dvalue4.Display_Name__c = 'Overdue Opportunity';
            dvalue4.Value__c = 'Overdue Opportunity';
            dvalue4.Condition_Clause_SOQL__c = 'Overdue_need_update__c = \'YES\'';
            dvalue4.Disable_Children_Query__c = false;
            dvalue4.Order__c = 5;
            dvalue4.Public_Group_Access__c = '';
            dvalue4.APL_Filter__c = filter.Id;  
            
            APL_Filter_Domain_Values__c dvalue5 = new APL_Filter_Domain_Values__c();
            dvalue5.Display_Name__c = 'APL Lost Business';
            dvalue5.Value__c = 'APL Lost Business';
            dvalue5.Condition_Clause_SOQL__c = 'Opportunity__r.RecordType.Name = \'Lost Business - Appliances\'';
            dvalue5.Disable_Children_Query__c = false;
            dvalue5.Order__c = 6;
            dvalue5.Public_Group_Access__c = '';
            dvalue5.APL_Filter__c = filter.Id;  
            
            APL_Filter_Domain_Values__c dvalue6 = new APL_Filter_Domain_Values__c();
            dvalue6.Display_Name__c = 'TAM Opportunity';
            dvalue6.Value__c = 'TAM Opportunity';
            dvalue6.Condition_Clause_SOQL__c = 'Opportunity__r.RecordType.Name = \'TAM\' and BU_profit_center__c = \'Appliances\' and Status__c not in(\'Lost\',\'Dead\')';
            dvalue6.Disable_Children_Query__c = false;
            dvalue6.Order__c = 4;
            dvalue6.Public_Group_Access__c = '';
            dvalue6.APL_Filter__c = filter.Id;  
            
            APL_Filter_Domain_Values__c dvalue7 = new APL_Filter_Domain_Values__c();
            dvalue7.Display_Name__c = 'Other BU pipeline with APL products';
            dvalue7.Value__c = 'Other BU pipeline with APL products';
            dvalue7.Condition_Clause_SOQL__c = '(not BU_profit_center__c LIKE \'%Appliance%\') and CBC_1_Code__c = \'30007\' and status__c not in (\'Lost\',\'Dead\')';
            dvalue7.Disable_Children_Query__c = false;
            dvalue7.Order__c = 4;
            dvalue7.Public_Group_Access__c = 'APL China FE Group; APL EMEA Team; ITBconsult';
            dvalue7.APL_Filter__c = filter.Id;  
            domainValues.add(dvalue1);
            domainValues.add(dvalue2);
            domainValues.add(dvalue3);
            domainValues.add(dvalue4);
            domainValues.add(dvalue5);
            domainValues.add(dvalue6);
            domainValues.add(dvalue7);
            insert domainValues;
            return ;
        }
        if(filter.Display_Name__c.equals('APL Opportunity Type')){
            APL_Filter_Domain_Values__c dvalue1 = new APL_Filter_Domain_Values__c();
            dvalue1.Display_Name__c = 'Updated within 90 days';
            dvalue1.Value__c = 'Updated within 90 days';
            dvalue1.Condition_Clause_SOQL__c = 'Opportunity__r.Days_since_last_user_update__c < 90';
            dvalue1.Disable_Children_Query__c = false;
            dvalue1.Order__c = 1;
            dvalue1.Public_Group_Access__c = '';
            dvalue1.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue2 = new APL_Filter_Domain_Values__c();
            dvalue2.Display_Name__c = 'Includes overdue';
            dvalue2.Value__c = 'Includes overdue';
            dvalue2.Condition_Clause_SOQL__c = '';
            dvalue2.Disable_Children_Query__c = false;
            dvalue2.Order__c = 2;
            dvalue2.Public_Group_Access__c = '';
            dvalue2.APL_Filter__c = filter.Id;
            
            domainValues.add(dvalue1);
            domainValues.add(dvalue2);
            insert domainValues;
            return ;        
        }
        if(filter.Display_Name__c.equals('Forecast display')){
            APL_Filter_Domain_Values__c dvalue1 = new APL_Filter_Domain_Values__c();
            dvalue1.Display_Name__c = 'By Year';
            dvalue1.Value__c = 'By Year';
            dvalue1.Condition_Clause_SOQL__c = '';
            dvalue1.Disable_Children_Query__c = false;
            dvalue1.Order__c = 1;
            dvalue1.Public_Group_Access__c = '';
            dvalue1.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue2 = new APL_Filter_Domain_Values__c();
            dvalue2.Display_Name__c = 'By Quarter';
            dvalue2.Value__c = 'By Quarter';
            dvalue2.Condition_Clause_SOQL__c = '';
            dvalue2.Disable_Children_Query__c = false;
            dvalue2.Order__c = 2;
            dvalue2.Public_Group_Access__c = '';
            dvalue2.APL_Filter__c = filter.Id;
            
            domainValues.add(dvalue1);
            domainValues.add(dvalue2);
            insert domainValues;
            return ;        
        }
        if(filter.Display_Name__c.equals('Opp Create date')){
            APL_Filter_Domain_Values__c dvalue1 = new APL_Filter_Domain_Values__c();
            dvalue1.Display_Name__c = 'All the time';
            dvalue1.Value__c = 'All the time';
            dvalue1.Condition_Clause_SOQL__c = '';
            dvalue1.Disable_Children_Query__c = false;
            dvalue1.Order__c = 1;
            dvalue1.Public_Group_Access__c = '';
            dvalue1.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue2 = new APL_Filter_Domain_Values__c();
            dvalue2.Display_Name__c = 'Within this FY';
            dvalue2.Value__c = 'Within this FY';
            dvalue2.Condition_Clause_SOQL__c = 'CreatedDate = THIS_FISCAL_YEAR';
            dvalue2.Disable_Children_Query__c = false;
            dvalue2.Order__c = 2;
            dvalue2.Public_Group_Access__c = '';
            dvalue2.APL_Filter__c = filter.Id;
            
            
            APL_Filter_Domain_Values__c dvalue3 = new APL_Filter_Domain_Values__c();
            dvalue3.Display_Name__c = 'In the past 30 days';
            dvalue3.Value__c = 'In the past 30 days';
            dvalue3.Condition_Clause_SOQL__c = 'CreatedDate = LAST_N_DAYS:30';
            dvalue3.Disable_Children_Query__c = false;
            dvalue3.Order__c = 3;
            dvalue3.Public_Group_Access__c = '';
            dvalue3.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue4 = new APL_Filter_Domain_Values__c();
            dvalue4.Display_Name__c = 'In the past 90 days';
            dvalue4.Value__c = 'In the past 90 days';
            dvalue4.Condition_Clause_SOQL__c = 'CreatedDate = LAST_90_DAYS';
            dvalue4.Disable_Children_Query__c = false;
            dvalue4.Order__c = 4;
            dvalue4.Public_Group_Access__c = '';
            dvalue4.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue5 = new APL_Filter_Domain_Values__c();
            dvalue5.Display_Name__c = 'Custom Date';
            dvalue5.Value__c = 'Custom Date';
            dvalue5.Condition_Clause_SOQL__c = 'Opportunity_Create_Date__c';
            dvalue5.Disable_Children_Query__c = false;
            dvalue5.Order__c = 5;
            dvalue5.Public_Group_Access__c = '';
            dvalue5.APL_Filter__c = filter.Id;
            
            domainValues.add(dvalue1);
            domainValues.add(dvalue2);
            domainValues.add(dvalue3);
            domainValues.add(dvalue4);
            domainValues.add(dvalue5);
            insert domainValues;
            return ;        
        }
        if(filter.Display_Name__c.equals('Opp Won date')){
            APL_Filter_Domain_Values__c dvalue1 = new APL_Filter_Domain_Values__c();
            dvalue1.Display_Name__c = 'None';
            dvalue1.Value__c = 'None';
            dvalue1.Condition_Clause_SOQL__c = '';
            dvalue1.Disable_Children_Query__c = false;
            dvalue1.Order__c = 1;
            dvalue1.Public_Group_Access__c = '';
            dvalue1.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue2 = new APL_Filter_Domain_Values__c();
            dvalue2.Display_Name__c = 'Within this FY';
            dvalue2.Value__c = 'Within this FY';
            dvalue2.Condition_Clause_SOQL__c = 'Won_Date__c = THIS_FISCAL_YEAR';
            dvalue2.Disable_Children_Query__c = false;
            dvalue2.Order__c = 2;
            dvalue2.Public_Group_Access__c = '';
            dvalue2.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue3 = new APL_Filter_Domain_Values__c();
            dvalue3.Display_Name__c = 'In the past 30 days';
            dvalue3.Value__c = 'In the past 30 days';
            dvalue3.Condition_Clause_SOQL__c = 'Won_Date__c = LAST_N_DAYS:30';
            dvalue3.Disable_Children_Query__c = false;
            dvalue3.Order__c = 3;
            dvalue3.Public_Group_Access__c = '';
            dvalue3.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue4 = new APL_Filter_Domain_Values__c();
            dvalue4.Display_Name__c = 'In the past 90 days';
            dvalue4.Value__c = 'In the past 90 days';
            dvalue4.Condition_Clause_SOQL__c = 'Won_Date__c = LAST_N_DAYS:90';
            dvalue4.Disable_Children_Query__c = false;
            dvalue4.Order__c = 4;
            dvalue4.Public_Group_Access__c = '';
            dvalue4.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue5 = new APL_Filter_Domain_Values__c();
            dvalue5.Display_Name__c = 'Custom Date';
            dvalue5.Value__c = 'Custom Date';
            dvalue5.Condition_Clause_SOQL__c = 'Won_Date__c';
            dvalue5.Disable_Children_Query__c = false;
            dvalue5.Order__c = 5;
            dvalue5.Public_Group_Access__c = '';
            dvalue5.APL_Filter__c = filter.Id;
            
            domainValues.add(dvalue1);
            domainValues.add(dvalue2);
            domainValues.add(dvalue3);
            domainValues.add(dvalue4);
            domainValues.add(dvalue5);
            insert domainValues;
            return ;        
        }
        if(filter.Display_Name__c.equals('Lost start date')){
            APL_Filter_Domain_Values__c dvalue1 = new APL_Filter_Domain_Values__c();
            dvalue1.Display_Name__c = 'None';
            dvalue1.Value__c = 'None';
            dvalue1.Condition_Clause_SOQL__c = '';
            dvalue1.Disable_Children_Query__c = false;
            dvalue1.Order__c = 1;
            dvalue1.Public_Group_Access__c = '';
            dvalue1.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue2 = new APL_Filter_Domain_Values__c();
            dvalue2.Display_Name__c = 'In previous FY';
            dvalue2.Value__c = 'In previous FY';
            dvalue2.Condition_Clause_SOQL__c = 'Lost_Start_Date__c = LAST_FISCAL_YEAR';
            dvalue2.Disable_Children_Query__c = false;
            dvalue2.Order__c = 2;
            dvalue2.Public_Group_Access__c = '';
            dvalue2.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue3 = new APL_Filter_Domain_Values__c();
            dvalue3.Display_Name__c = 'Within this FY';
            dvalue3.Value__c = 'Within this FY';
            dvalue3.Condition_Clause_SOQL__c = 'Lost_Start_Date__c = THIS_FISCAL_YEAR';
            dvalue3.Disable_Children_Query__c = false;
            dvalue3.Order__c = 3;
            dvalue3.Public_Group_Access__c = '';
            dvalue3.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue4 = new APL_Filter_Domain_Values__c();
            dvalue4.Display_Name__c = 'In next FY';
            dvalue4.Value__c = 'In next FY';
            dvalue4.Condition_Clause_SOQL__c = 'Lost_Start_Date__c = NEXT_FISCAL_YEAR';
            dvalue4.Disable_Children_Query__c = false;
            dvalue4.Order__c = 4;
            dvalue4.Public_Group_Access__c = '';
            dvalue4.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue5 = new APL_Filter_Domain_Values__c();
            dvalue5.Display_Name__c = 'Custom Date';
            dvalue5.Value__c = 'Custom Date';
            dvalue5.Condition_Clause_SOQL__c = 'Lost_Start_Date__c';
            dvalue5.Disable_Children_Query__c = false;
            dvalue5.Order__c = 5;
            dvalue5.Public_Group_Access__c = '';
            dvalue5.APL_Filter__c = filter.Id;
            
            domainValues.add(dvalue1);
            domainValues.add(dvalue2);
            domainValues.add(dvalue3);
            domainValues.add(dvalue4);
            domainValues.add(dvalue5);
            insert domainValues;
            return ;        
        }
        if(filter.Display_Name__c.equals('Product Family')){
            APL_Filter_Domain_Values__c dvalue1 = new APL_Filter_Domain_Values__c();
            dvalue1.Display_Name__c = 'Power & Signal';
            dvalue1.Value__c = '30012';
            dvalue1.Condition_Clause_SOQL__c = 'GPL__r.CBC2__c = \'30012\'';
            dvalue1.Disable_Children_Query__c = false;
            dvalue1.Order__c = 3;
            dvalue1.Public_Group_Access__c = '';
            dvalue1.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue2 = new APL_Filter_Domain_Values__c();
            dvalue2.Display_Name__c = 'RAST';
            dvalue2.Value__c = '30015';
            dvalue2.Condition_Clause_SOQL__c = 'GPL__r.CBC2__c = \'30015\'';
            dvalue2.Disable_Children_Query__c = false;
            dvalue2.Order__c = 5;
            dvalue2.Public_Group_Access__c = '';
            dvalue2.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue3 = new APL_Filter_Domain_Values__c();
            dvalue3.Display_Name__c = 'Tubing';
            dvalue3.Value__c = '30017';
            dvalue3.Condition_Clause_SOQL__c = 'GPL__r.CBC2__c = \'30017\'';
            dvalue3.Disable_Children_Query__c = false;
            dvalue3.Order__c = 6;
            dvalue3.Public_Group_Access__c = '';
            dvalue3.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue4 = new APL_Filter_Domain_Values__c();
            dvalue4.Display_Name__c = 'Magnet Wire';
            dvalue4.Value__c = '30042';
            dvalue4.Condition_Clause_SOQL__c = 'GPL__r.CBC2__c = \'30042\'';
            dvalue4.Disable_Children_Query__c = false;
            dvalue4.Order__c = 4;
            dvalue4.Public_Group_Access__c = '';
            dvalue4.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue5 = new APL_Filter_Domain_Values__c();
            dvalue5.Display_Name__c = 'Teminals & Splices';
            dvalue5.Value__c = '30016';
            dvalue5.Condition_Clause_SOQL__c = 'GPL__r.CBC2__c = \'30016\'';
            dvalue5.Disable_Children_Query__c = false;
            dvalue5.Order__c = 2;
            dvalue5.Public_Group_Access__c = '';
            dvalue5.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue6 = new APL_Filter_Domain_Values__c();
            dvalue6.Display_Name__c = 'Advanced Development';
            dvalue6.Value__c = '30013';
            dvalue6.Condition_Clause_SOQL__c = 'GPL__r.CBC2__c = \'30013\'';
            dvalue6.Disable_Children_Query__c = false;
            dvalue6.Order__c = 8;
            dvalue6.Public_Group_Access__c = '';
            dvalue6.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue7 = new APL_Filter_Domain_Values__c();
            dvalue7.Display_Name__c = 'Intergrated Products';
            dvalue7.Value__c = '41204';
            dvalue7.Condition_Clause_SOQL__c = 'GPL__r.CBC2__c = \'41204\'';
            dvalue7.Disable_Children_Query__c = false;
            dvalue7.Order__c = 9;
            dvalue7.Public_Group_Access__c = '';
            dvalue7.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue8 = new APL_Filter_Domain_Values__c();
            dvalue8.Display_Name__c = 'Relay Products';
            dvalue8.Value__c = '13213, 30005,41553';
            dvalue8.Condition_Clause_SOQL__c = '(GPL__r.CBC2__c in (\'13213\', \'30005\') or GPL__r.CBC3__c in (\'41553\'))';
            dvalue8.Disable_Children_Query__c = false;
            dvalue8.Order__c = 7;
            dvalue8.Public_Group_Access__c = '';
            dvalue8.APL_Filter__c = filter.Id;
            
            
            APL_Filter_Domain_Values__c dvalue9 = new APL_Filter_Domain_Values__c();
            dvalue9.Display_Name__c = 'Other BU Products';
            dvalue9.Value__c = '!=30007';
            dvalue9.Condition_Clause_SOQL__c = 'GPL__r.CBC1__c != \'30007\'';
            dvalue9.Disable_Children_Query__c = false;
            dvalue9.Order__c = 10;
            dvalue9.Public_Group_Access__c = '';
            dvalue9.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue10 = new APL_Filter_Domain_Values__c();
            dvalue10.Display_Name__c = 'None';
            dvalue10.Value__c = 'None';
            dvalue10.Condition_Clause_SOQL__c = '(GPL__r.CBC2__c in (\'13213\', \'30005\') or GPL__r.CBC3__c in (\'41553\'))';
            dvalue10.Disable_Children_Query__c = false;
            dvalue10.Order__c = 1;
            dvalue10.Public_Group_Access__c = '';
            dvalue10.APL_Filter__c = filter.Id;
            
            domainValues.add(dvalue1);
            domainValues.add(dvalue2);
            domainValues.add(dvalue3);
            domainValues.add(dvalue4);
            domainValues.add(dvalue5);
            domainValues.add(dvalue6);
            domainValues.add(dvalue7);
            domainValues.add(dvalue8);
            domainValues.add(dvalue9);
            domainValues.add(dvalue10);
            insert domainValues;
            return ;        
        }
        
        if(filter.Display_Name__c.equals('NPS Category')){
            APL_Filter_Domain_Values__c dvalue1 = new APL_Filter_Domain_Values__c();
            dvalue1.Display_Name__c = 'NPS 1';
            dvalue1.Value__c = 'NPS 1';
            dvalue1.Condition_Clause_SOQL__c = '';
            dvalue1.Disable_Children_Query__c = false;
            dvalue1.Order__c = 1;
            dvalue1.Public_Group_Access__c = '';
            dvalue1.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue2 = new APL_Filter_Domain_Values__c();
            dvalue2.Display_Name__c = 'NPS 2';
            dvalue2.Value__c = 'NPS 2';
            dvalue2.Condition_Clause_SOQL__c = '';
            dvalue2.Disable_Children_Query__c = false;
            dvalue2.Order__c = 2;
            dvalue2.Public_Group_Access__c = '';
            dvalue2.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue3 = new APL_Filter_Domain_Values__c();
            dvalue3.Display_Name__c = 'NPS 3';
            dvalue3.Value__c = 'NPS 3';
            dvalue3.Condition_Clause_SOQL__c = '';
            dvalue3.Disable_Children_Query__c = false;
            dvalue3.Order__c = 3;
            dvalue3.Public_Group_Access__c = '';
            dvalue3.APL_Filter__c = filter.Id;
            
            domainValues.add(dvalue1);
            domainValues.add(dvalue2);
            domainValues.add(dvalue3);
            insert domainValues;
            return ;        
        }
        
        if(filter.Display_Name__c.equals('Opportunity Owner BU')){
            APL_Filter_Domain_Values__c dvalue1 = new APL_Filter_Domain_Values__c();
            dvalue1.Display_Name__c = 'APL Users';
            dvalue1.Value__c = '\'Appliance Engineering User w/Cost\',\'Appliance Standard User\',\'Appliance User w/ Cost\'';
            dvalue1.Condition_Clause_SOQL__c = '';
            dvalue1.Disable_Children_Query__c = false;
            dvalue1.Order__c = 1;
            dvalue1.Public_Group_Access__c = '';
            dvalue1.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue2 = new APL_Filter_Domain_Values__c();
            dvalue2.Display_Name__c = 'CBU Users';
            dvalue2.Value__c = '\'Channel Standard User\',\'Channel User w/Cost\'';
            dvalue2.Condition_Clause_SOQL__c = '';
            dvalue2.Disable_Children_Query__c = false;
            dvalue2.Order__c = 2;
            dvalue2.Public_Group_Access__c = '';
            dvalue2.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue3 = new APL_Filter_Domain_Values__c();
            dvalue3.Display_Name__c = 'Others Users';
            dvalue3.Value__c = '\'BU Admin\',\'BU Analyst\'';
            dvalue3.Condition_Clause_SOQL__c = '';
            dvalue3.Disable_Children_Query__c = false;
            dvalue3.Order__c = 4;
            dvalue3.Public_Group_Access__c = 'APL China FE Group; APL EMEA Team; ITBconsult';
            dvalue3.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue4 = new APL_Filter_Domain_Values__c();
            dvalue4.Display_Name__c = 'APL & CBU Users';
            dvalue4.Value__c = '\'Appliance Engineering User w/Cost\',\'Appliance Standard User\',\'Appliance User w/ Cost\',\'Channel Stardard User\',\'Channel User w/Cost\'';
            dvalue4.Condition_Clause_SOQL__c = '';
            dvalue4.Disable_Children_Query__c = false;
            dvalue4.Order__c = 3;
            dvalue4.Public_Group_Access__c = '';
            dvalue4.APL_Filter__c = filter.Id;
            
            domainValues.add(dvalue1);
            domainValues.add(dvalue2);
            domainValues.add(dvalue3);
            domainValues.add(dvalue4);
            insert domainValues;
            return ;        
        }
        if(filter.Display_Name__c.equals('Relay AE')){
            APL_Filter_Domain_Values__c dvalue1 = new APL_Filter_Domain_Values__c();
            dvalue1.Display_Name__c = 'Sang Kwon Lee';
            dvalue1.Value__c = 'Sang Kwon Lee';
            dvalue1.Condition_Clause_SOQL__c = '';
            dvalue1.Disable_Children_Query__c = false;
            dvalue1.Order__c = 3;
            dvalue1.Public_Group_Access__c = '';
            dvalue1.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue2 = new APL_Filter_Domain_Values__c();
            dvalue2.Display_Name__c = 'Bobby L Johnson';
            dvalue2.Value__c = 'Bobby L Johnson';
            dvalue2.Condition_Clause_SOQL__c = '';
            dvalue2.Disable_Children_Query__c = false;
            dvalue2.Order__c = 1;
            dvalue2.Public_Group_Access__c = '';
            dvalue2.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue3 = new APL_Filter_Domain_Values__c();
            dvalue3.Display_Name__c = 'Thomas Kerneker';
            dvalue3.Value__c = 'Thomas Kerneker';
            dvalue3.Condition_Clause_SOQL__c = '';
            dvalue3.Disable_Children_Query__c = false;
            dvalue3.Order__c = 4;
            dvalue3.Public_Group_Access__c = 'APL China FE Group; APL EMEA Team; ITBconsult';
            dvalue3.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue4 = new APL_Filter_Domain_Values__c();
            dvalue4.Display_Name__c = 'Colin Huang';
            dvalue4.Value__c = 'Colin Huang';
            dvalue4.Condition_Clause_SOQL__c = '';
            dvalue4.Disable_Children_Query__c = false;
            dvalue4.Order__c = 2;
            dvalue4.Public_Group_Access__c = '';
            dvalue4.APL_Filter__c = filter.Id;
            
            domainValues.add(dvalue1);
            domainValues.add(dvalue2);
            domainValues.add(dvalue3);
            domainValues.add(dvalue4);
            insert domainValues;
            return ;        
        }
        if(filter.Display_Name__c.equals('Customer Region')){
            APL_Filter_Domain_Values__c dvalue1 = new APL_Filter_Domain_Values__c();
            dvalue1.Display_Name__c = 'Asia(excl. China and Japan)';
            dvalue1.Value__c = 'Asia(excl. China and Japan)';
            dvalue1.Condition_Clause_SOQL__c = '';
            dvalue1.Disable_Children_Query__c = false;
            dvalue1.Order__c = 1;
            dvalue1.Public_Group_Access__c = '';
            dvalue1.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue2 = new APL_Filter_Domain_Values__c();
            dvalue2.Display_Name__c = 'Australia / New Zealand';
            dvalue2.Value__c = 'Australia / New Zealand';
            dvalue2.Condition_Clause_SOQL__c = '';
            dvalue2.Disable_Children_Query__c = false;
            dvalue2.Order__c = 2;
            dvalue2.Public_Group_Access__c = '';
            dvalue2.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue3 = new APL_Filter_Domain_Values__c();
            dvalue3.Display_Name__c = 'China / HK / Taiwan';
            dvalue3.Value__c = 'China / HK / Taiwan';
            dvalue3.Condition_Clause_SOQL__c = '';
            dvalue3.Disable_Children_Query__c = false;
            dvalue3.Order__c = 3;
            dvalue3.Public_Group_Access__c = 'APL China FE Group; APL EMEA Team; ITBconsult';
            dvalue3.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue4 = new APL_Filter_Domain_Values__c();
            dvalue4.Display_Name__c = 'EMEA (excl. India)';
            dvalue4.Value__c = 'EMEA (excl. India)';
            dvalue4.Condition_Clause_SOQL__c = '';
            dvalue4.Disable_Children_Query__c = false;
            dvalue4.Order__c = 4;
            dvalue4.Public_Group_Access__c = '';
            dvalue4.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue5 = new APL_Filter_Domain_Values__c();
            dvalue5.Display_Name__c = 'India';
            dvalue5.Value__c = 'India';
            dvalue5.Condition_Clause_SOQL__c = '';
            dvalue5.Disable_Children_Query__c = false;
            dvalue5.Order__c = 5;
            dvalue5.Public_Group_Access__c = '';
            dvalue5.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue6 = new APL_Filter_Domain_Values__c();
            dvalue6.Display_Name__c = 'Japan';
            dvalue6.Value__c = 'Japan';
            dvalue6.Condition_Clause_SOQL__c = '';
            dvalue6.Disable_Children_Query__c = false;
            dvalue6.Order__c = 6;
            dvalue6.Public_Group_Access__c = '';
            dvalue6.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue7 = new APL_Filter_Domain_Values__c();
            dvalue7.Display_Name__c = 'North America';
            dvalue7.Value__c = 'North America';
            dvalue7.Condition_Clause_SOQL__c = '';
            dvalue7.Disable_Children_Query__c = false;
            dvalue7.Order__c = 7;
            dvalue7.Public_Group_Access__c = 'APL China FE Group; APL EMEA Team; ITBconsult';
            dvalue7.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue8 = new APL_Filter_Domain_Values__c();
            dvalue8.Display_Name__c = 'South America';
            dvalue8.Value__c = 'South America';
            dvalue8.Condition_Clause_SOQL__c = '';
            dvalue8.Disable_Children_Query__c = false;
            dvalue8.Order__c = 8;
            dvalue8.Public_Group_Access__c = '';
            dvalue8.APL_Filter__c = filter.Id;
            
            domainValues.add(dvalue1);
            domainValues.add(dvalue2);
            domainValues.add(dvalue3);
            domainValues.add(dvalue4);
            domainValues.add(dvalue5);
            domainValues.add(dvalue6);
            domainValues.add(dvalue7);
            domainValues.add(dvalue8);
            insert domainValues;
            return ;        
        }
        if(filter.Display_Name__c.equals('Customer country')){
            APL_Filter_Domain_Values__c dvalue1 = new APL_Filter_Domain_Values__c();
            dvalue1.Display_Name__c = 'AE';
            dvalue1.Value__c = 'AE';
            dvalue1.Condition_Clause_SOQL__c = '';
            dvalue1.Disable_Children_Query__c = false;
            dvalue1.Order__c = 1;
            dvalue1.Public_Group_Access__c = '';
            dvalue1.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue2 = new APL_Filter_Domain_Values__c();
            dvalue2.Display_Name__c = 'AR';
            dvalue2.Value__c = 'AR';
            dvalue2.Condition_Clause_SOQL__c = '';
            dvalue2.Disable_Children_Query__c = false;
            dvalue2.Order__c = 2;
            dvalue2.Public_Group_Access__c = '';
            dvalue2.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue3 = new APL_Filter_Domain_Values__c();
            dvalue3.Display_Name__c = 'CH';
            dvalue3.Value__c = 'CH';
            dvalue3.Condition_Clause_SOQL__c = '';
            dvalue3.Disable_Children_Query__c = false;
            dvalue3.Order__c = 3;
            dvalue3.Public_Group_Access__c = 'APL China FE Group; APL EMEA Team; ITBconsult';
            dvalue3.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue4 = new APL_Filter_Domain_Values__c();
            dvalue4.Display_Name__c = 'DE';
            dvalue4.Value__c = 'DE';
            dvalue4.Condition_Clause_SOQL__c = '';
            dvalue4.Disable_Children_Query__c = false;
            dvalue4.Order__c = 4;
            dvalue4.Public_Group_Access__c = '';
            dvalue4.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue5 = new APL_Filter_Domain_Values__c();
            dvalue5.Display_Name__c = 'CN';
            dvalue5.Value__c = 'CN';
            dvalue5.Condition_Clause_SOQL__c = '';
            dvalue5.Disable_Children_Query__c = false;
            dvalue5.Order__c = 5;
            dvalue5.Public_Group_Access__c = '';
            dvalue5.APL_Filter__c = filter.Id;
            
            domainValues.add(dvalue1);
            domainValues.add(dvalue2);
            domainValues.add(dvalue3);
            domainValues.add(dvalue4);
            domainValues.add(dvalue5);
            insert domainValues;
            return ;        
        }
        
        if(filter.Display_Name__c.equals('Relay AE Close out Date')){
            APL_Filter_Domain_Values__c dvalue1 = new APL_Filter_Domain_Values__c();
            dvalue1.Display_Name__c = 'Custom Date';
            dvalue1.Value__c = 'Custom Date';
            dvalue1.Condition_Clause_SOQL__c = 'Close_out_date__c';
            dvalue1.Disable_Children_Query__c = false;
            dvalue1.Order__c = 2;
            dvalue1.Public_Group_Access__c = '';
            dvalue1.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue2 = new APL_Filter_Domain_Values__c();
            dvalue2.Display_Name__c = 'None';
            dvalue2.Value__c = 'None';
            dvalue2.Condition_Clause_SOQL__c = '';
            dvalue2.Disable_Children_Query__c = false;
            dvalue2.Order__c = 1;
            dvalue2.Public_Group_Access__c = '';
            dvalue2.APL_Filter__c = filter.Id;
            
            domainValues.add(dvalue1);
            domainValues.add(dvalue2);
            insert domainValues;
            return ;        
        }
        if(filter.Display_Name__c.equals('Relay Technical Status')){
            APL_Filter_Domain_Values__c dvalue1 = new APL_Filter_Domain_Values__c();
            dvalue1.Display_Name__c = 'canceled by customer';
            dvalue1.Value__c = 'canceled by customer';
            dvalue1.Condition_Clause_SOQL__c = 'Close_out_date__c';
            dvalue1.Disable_Children_Query__c = false;
            dvalue1.Order__c = 1;
            dvalue1.Public_Group_Access__c = '';
            dvalue1.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue2 = new APL_Filter_Domain_Values__c();
            dvalue2.Display_Name__c = 'in process with low probability';
            dvalue2.Value__c = 'in process with low probability';
            dvalue2.Condition_Clause_SOQL__c = '';
            dvalue2.Disable_Children_Query__c = false;
            dvalue2.Order__c = 2;
            dvalue2.Public_Group_Access__c = '';
            dvalue2.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue3 = new APL_Filter_Domain_Values__c();
            dvalue3.Display_Name__c = 'in process with normal probability';
            dvalue3.Value__c = 'in process with normal probability';
            dvalue3.Condition_Clause_SOQL__c = '';
            dvalue3.Disable_Children_Query__c = false;
            dvalue3.Order__c = 3;
            dvalue3.Public_Group_Access__c = '';
            dvalue3.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue4 = new APL_Filter_Domain_Values__c();
            dvalue4.Display_Name__c = 'no solution';
            dvalue4.Value__c = 'no solution';
            dvalue4.Condition_Clause_SOQL__c = '';
            dvalue4.Disable_Children_Query__c = false;
            dvalue4.Order__c = 4;
            dvalue4.Public_Group_Access__c = '';
            dvalue4.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue5 = new APL_Filter_Domain_Values__c();
            dvalue5.Display_Name__c = 'on hold';
            dvalue5.Value__c = 'on hold';
            dvalue5.Condition_Clause_SOQL__c = '';
            dvalue5.Disable_Children_Query__c = false;
            dvalue5.Order__c = 5;
            dvalue5.Public_Group_Access__c = '';
            dvalue5.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue6 = new APL_Filter_Domain_Values__c();
            dvalue6.Display_Name__c = 'replaced';
            dvalue6.Value__c = 'replaced';
            dvalue6.Condition_Clause_SOQL__c = '';
            dvalue6.Disable_Children_Query__c = false;
            dvalue6.Order__c = 6;
            dvalue6.Public_Group_Access__c = '';
            dvalue6.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue7 = new APL_Filter_Domain_Values__c();
            dvalue7.Display_Name__c = 'solved';
            dvalue7.Value__c = 'solved';
            dvalue7.Condition_Clause_SOQL__c = '';
            dvalue7.Disable_Children_Query__c = false;
            dvalue7.Order__c = 7;
            dvalue7.Public_Group_Access__c = '';
            dvalue7.APL_Filter__c = filter.Id;
            
            domainValues.add(dvalue1);
            domainValues.add(dvalue2);
            domainValues.add(dvalue3);
            domainValues.add(dvalue4);
            domainValues.add(dvalue5);
            domainValues.add(dvalue6);
            domainValues.add(dvalue7);
            insert domainValues;
            return ;        
        }//setUpDomainValues(filter3);
        if(filter.Display_Name__c.equals('Opportunity Part confidence & status')){
            APL_Filter_Domain_Values__c dvalue1 = new APL_Filter_Domain_Values__c();
            dvalue1.Display_Name__c = 'Weak';
            dvalue1.Value__c = 'Weak';
            dvalue1.Condition_Clause_SOQL__c = 'Status__c = \'Weak\'';
            dvalue1.Disable_Children_Query__c = false;
            dvalue1.Order__c = 4;
            dvalue1.Public_Group_Access__c = '';
            dvalue1.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue2 = new APL_Filter_Domain_Values__c();
            dvalue2.Display_Name__c = '50/50';
            dvalue2.Value__c = '50/50';
            dvalue2.Condition_Clause_SOQL__c = 'Status__c = \'50/50\'';
            dvalue2.Disable_Children_Query__c = false;
            dvalue2.Order__c = 3;
            dvalue2.Public_Group_Access__c = '';
            dvalue2.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue3 = new APL_Filter_Domain_Values__c();
            dvalue3.Display_Name__c = 'Likely';
            dvalue3.Value__c = 'Likely';
            dvalue3.Condition_Clause_SOQL__c = 'Status__c = \'Likely\'';
            dvalue3.Disable_Children_Query__c = false;
            dvalue3.Order__c = 2;
            dvalue3.Public_Group_Access__c = '';
            dvalue3.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue4 = new APL_Filter_Domain_Values__c();
            dvalue4.Display_Name__c = 'Commit';
            dvalue4.Value__c = 'Commit';
            dvalue4.Condition_Clause_SOQL__c = 'Status__c = \'Commit\'';
            dvalue4.Disable_Children_Query__c = false;
            dvalue4.Order__c = 1;
            dvalue4.Public_Group_Access__c = '';
            dvalue4.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue5 = new APL_Filter_Domain_Values__c();
            dvalue5.Display_Name__c = 'Won/Pre-Prod';
            dvalue5.Value__c = 'Won/Pre-Prod';
            dvalue5.Condition_Clause_SOQL__c = 'Status__c = \'Won\' and Process_Status__c = \'Pre-prod\'';
            dvalue5.Disable_Children_Query__c = false;
            dvalue5.Order__c = 5;
            dvalue5.Public_Group_Access__c = '';
            dvalue5.APL_Filter__c = filter.Id;
            
            APL_Filter_Domain_Values__c dvalue6 = new APL_Filter_Domain_Values__c();
            dvalue6.Display_Name__c = 'Won/Prod';
            dvalue6.Value__c = 'Won/Prod';
            dvalue6.Condition_Clause_SOQL__c = 'Status__c = \'Won\' and Process_Status__c = \'Production\'';
            dvalue6.Disable_Children_Query__c = false;
            dvalue6.Order__c = 6;
            dvalue6.Public_Group_Access__c = '';
            dvalue6.APL_Filter__c = filter.Id;
            
            domainValues.add(dvalue1);
            domainValues.add(dvalue2);
            domainValues.add(dvalue3);
            domainValues.add(dvalue4);
            domainValues.add(dvalue5);
            domainValues.add(dvalue6);
            insert domainValues;
            return ;        
        }
    }
    
    public static map<Id, set<string>> setUpTestData2Map(User user){
        /*
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        if (Type.forName('Channelinsight__CI_Configuration__c') != null) {
            Channelinsight__CI_Configuration__c c = new Channelinsight__CI_Configuration__c();
            c.Name = 'Default';
            c.Channelinsight__CONF_Stop_Matching_POS_to_Opportunity__c = 'Opportunity Is Closed';
            c.Channelinsight__CONF_Salesforce_Environment__c = 'Sandbox';
            c.Channelinsight__CONF_Reprocess_Reviewed__c = true;
            c.Channelinsight__CONF_Disable_Address_Type_Matching__c = true;  
            c.Channelinsight__CONF_Auto_mark_POS_Reviewed__c = false; 
            c.Channelinsight__CONF_Acct_Sales_Trending_Default_Address__c = 'Bill-to';
            insert c;
   }
*/
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        //ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        
        set<string> pids = new set<string>();
        map<Id, set<string>> map_oIdtoPids = new map<Id, set<string>>();
        
        RecordType rt = ClsTestHelp.createTestRecordType();
        RecordType rt2 = ClsTestHelp.createTestRecordType23();
        RecordType rt3 = ClsTestHelp.createTestRecordType16();
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        insert acc;
          
        /*
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        oppy2.Request_Type__c = 'Extension';
        oppy2.RecordTypeId = rt2.Id;
        insert oppy2;*/
        
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        oppy2.Request_Type__c = 'Extension';
        oppy2.RecordTypeId = rt3.Id;
        insert oppy2;  
          
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Program__c = oppy2.Id;   
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        oppy.RecordTypeId = rt2.Id;
        insert oppy;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial'; 
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = part.Id;
        insert oppypart;
        
        
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy.Id;
        oppyForecast.Quantity__c = 12;
        oppyForecast.Part__c = oppypart.Id;
        oppyForecast.Date__c = date.newInstance(2012, 09, 28);
        oppyForecast.Amount__c = 1;
        insert oppyForecast;

        pids.add(oppypart.Id);
        map_oIdtoPids.put(oppy.Id,pids);
        
        return map_oIdtoPids;
    }
}