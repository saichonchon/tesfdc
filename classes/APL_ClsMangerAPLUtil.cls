/**
 * Implement class for APL Report function, all the functions is included in this class.
 *
 @author    Shawn liu
 @created   2015-05-05
 @version   1.0
 @since     30.0 (Force.com ApiVersion)
 *
 @changelog
 * 2015-05-05 Shawn liu <Shawn.liu.china@itbconsult.com>
 * - Created
 */
public class APL_ClsMangerAPLUtil {
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END Public static members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public static String jsonfilters = null;//jsonfilters is the one used for page
    public static String oppytypesjson = null;//oppy report information
    public static String mainSOQL = null;//soql for doSearch
    
    public static String oppyLastId = null;//for oppy iterative search
    public static Integer years = 0;//Integer years range
    public static string lastFcstOppyId = null;//for oppy forecast iterative search
    public static string lastFcstOppyPartId = null;//for oppy part forecast iterative search
    public static String oppyFcstType = null;//forecast type: by year | by quarter
    public static String oppyFcstFiscalRange = null;//soql string for year range
    public static string lastExportFcstOppyId = null;//for oppy forecast iterative export
    public static string lastExportOppyId = null;//for oppy iterative export
    public static string lastExportPartId = null;//for oppy part iterative export
    public static string lastExportPartnerId = null;//for oppy partner iterative export
    public static string lastExportPartFcstId = null;//for oppy partner iterative export
    
    public static list<APLFilterWrapper> list_APLFilterWrappers = null;//temp cached APLFilterWrapper
    public static set<string> set_checkedFcstLabels = null;//temp cached forecast labels
    public static set<string> set_pnIds= null;//temp cached partner Ids
    public static list<OPPYTemaplate> list_templates = null; //temp cached list of templates
    public static list<FieldSetInfo> list_fieldSetInfosIn = null;//temp cached list of fieldSet info
    public static list<FieldFilter> list_fieldfilters = null;//temp cached list of field filters
    public static map<string,set<string>> map_oppyIdToSetOfPartIds = null;////temp cached map of part and parts
    public static map<String,APLFilterServerWrapper> map_idToFSWrappers = null;//temp cached map of FilterServerWrapper
    public static set<string> set_pgs = null; //temp cached set of public groups
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END constanct members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    /**
    * this method is just for clear before initializing
     @author shawn liu
     @created 2015-05-04
     @version 1.0
     @since 30.0 (Force.com ApiVersion)
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static void clear(){
        if(list_APLFilterWrappers != null)
            list_APLFilterWrappers.clear();
        if(list_templates != null)
            list_templates.clear();
        if(list_fieldfilters != null)
            list_fieldfilters.clear();
        if(map_idToFSWrappers != null)
            map_idToFSWrappers.clear();
        if(map_oppyIdToSetOfPartIds != null)
            map_oppyIdToSetOfPartIds.clear();
        if(jsonfilters != null)
            jsonfilters = null;
        if(list_fieldSetInfosIn != null)
            list_fieldSetInfosIn.clear();
    }
    /**
    * this method is just for clear before initializing
     @author shawn liu
     @created 2015-05-04
     @version 1.0
     @since 30.0 (Force.com ApiVersion)
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static void setup(){
        if(list_APLFilterWrappers == null)
            list_APLFilterWrappers = new List<APLFilterWrapper>();
        if(jsonfilters == null)
            jsonfilters = '';
        if(list_templates == null)
            list_templates = new List<OPPYTemaplate>();
        if(list_fieldfilters == null)
            list_fieldfilters = new list<FieldFilter>();
        if(map_idToFSWrappers == null)
            map_idToFSWrappers = new map<String,APLFilterServerWrapper>();
        if(list_fieldSetInfosIn == null)
            list_fieldSetInfosIn = new list<FieldSetInfo>();
        if(map_oppyIdToSetOfPartIds == null)
            map_oppyIdToSetOfPartIds =  new map<string,set<string>>();
    }
     /**
     *this method is just used for the whole logic for initializing
     @author shawn liu
     @created 2015-05-04
     @version 1.0
     @since 30.0 (Force.com ApiVersion)
     *
     @param tid string templateId
    
     @changelog
     * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
     * - Created
     */
    public static void initLoading(string tid){
        system.debug('----------------initLoading tid---------------------- = ' + tid);
        clear();
        setup();
        list<APL_Filter__c> list_APLFilters = loading(tid);
        if(list_APLFilters == null || list_APLFilters.isEmpty())
            return ; 
        processAPLFilters(list_APLFilters);
        validateUserFilterValues();
        jsonSerialization();
        //system.debug('jsonfilters in loading == ' +  jsonfilters);      
    }
     /**
     *this method is just used for serialization after the initialization
     @author shawn liu
     @created 2015-05-04
     @version 1.0
     @since 30.0 (Force.com ApiVersion)
     *
     @changelog
     * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
     * - Created
     */
    public static void jsonSerialization(){
        list_APLFilterWrappers.sort();
        List<String> list_Categorys = new List<String>();
        for(APLFilterWrapper aplwrapper : list_APLFilterWrappers){
            if(!APL_ClsMangerAPLUtil.isContainInList(aplwrapper.filterCategory,list_Categorys))
                list_Categorys.add(aplwrapper.filterCategory);
        }
        system.debug('list_Categorys = ' + list_Categorys);
        List<map<String,List<APLFilterWrapper>>> list_mapofcategoryoflistofAplFilter = new List<map<String,List<APLFilterWrapper>>>();
        for(String categorysec : list_Categorys){
            list_mapofcategoryoflistofAplFilter.add(dividedOnCategory(categorysec));
        }
        jsonfilters =  Json.serialize(list_mapofcategoryoflistofAplFilter);
        system.debug('jsonfilters = ' + jsonfilters);
        oppytypesjson =  Json.serialize(list_fieldSetInfosIn);
        system.debug('oppytypesjson = ' + oppytypesjson);
    }
    /**
    * this method is used to group APLFilterWrapper based on specific category
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *@param     String  category
    *
    *@return    map<String,List<APLFilterWrapper>>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */ 
    public static map<String,List<APLFilterWrapper>> dividedOnCategory(String categorysec ){
        List<APLFilterWrapper> list_filterWrapper = new List<APLFilterWrapper>();
        for(APLFilterWrapper aplwrapper : list_APLFilterWrappers){
            if(categorysec.equals(aplwrapper.filterCategory))
                list_filterWrapper.add(aplwrapper);
        }
        //system.debug('list_filterWrapper = ' + list_filterWrapper);
        map<String,List<APLFilterWrapper>> map_categoryTolistOfAPLFilterWrapper = new map<String,List<APLFilterWrapper>>();
        map_categoryTolistOfAPLFilterWrapper.put(categorysec,list_filterWrapper);
        return map_categoryTolistOfAPLFilterWrapper;
    }
    /**
    * this method is used for dbloading APL_Filter__c and related fieldsets
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *@param     tid String templateId
    *
    *@return    list<APLFilterWrapper>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */ 
    public static list<APL_Filter__c> loading(String tid){
        list<APL_Filter__c> list_APLFilters = dbLoading(tid);
        fieldSetLoading();
        return list_APLFilters; 
    }
    /**
    * this method is used for fieldsets loading
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */ 
    public static void fieldSetLoading(){//customer setting
        list<APLFilter_FieldSet__c> list_fieldsets = APLFilter_FieldSet__c.getAll().values();
        if(list_fieldsets == null || list_fieldsets.isEmpty())
            return ;
        for(APLFilter_FieldSet__c fieldset : list_fieldsets){
            list<FieldInfo> list_fieldInfos = getFields(fieldset.Reference_FieldSet_Name__c,fieldset.Reference_Object__c);
            if(list_fieldInfos == null || list_fieldInfos.isEmpty())
                continue;
            FieldFilter filter = new FieldFilter();
            filter.name = fieldset.Name;
            filter.id = fieldset.id;
            filter.bCheck = fieldset.Selected__c;
            filter.list_fieldInfos.addAll(list_fieldInfos);
            list_fieldfilters.add(filter);
        }
        list_fieldSetInfosIn = initializeFieldSetInfos();
        //system.debug('list_fieldfilters = ' + list_fieldfilters);
    }
    /**
    * this method is used for contruct fieldsets structure
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @return list<FieldSetInfo>
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */ 
    public static list<FieldSetInfo> initializeFieldSetInfos(){
        list<FieldSetInfo> list_fieldSetInfos = new list<FieldSetInfo>();
        //list_fieldInfos FieldInfo fieldlabel
        map<string,list<string>> map_labels = new map<string,list<string>>();
        map<string,list<string>> map_APIs = new map<string,list<string>>();
        for(FieldFilter filter : list_fieldfilters){
            list<string> list_labels = new list<string>();
            list<string> list_APIs = new list<string>();
            for(FieldInfo finfo : filter.list_fieldInfos){
                list_labels.add(finfo.fieldlabel);
                list_APIs.add(finfo.fieldAPI);
            }
            map_labels.put(filter.name,list_labels);
            map_APIs.put(filter.name,list_APIs);
        }
        
        set<string> set_OppyIndependants = new set<string>();
        
        FieldSetInfo fieldsetInfo = new FieldSetInfo();
        fieldsetInfo.dtype = PICKLIST_TYPE;
        fieldsetInfo.title = OPPY_TYPE_DEF;
        fieldsetInfo.mdty = OPPY_TYPE;
        list_fieldSetInfos.add(fieldsetInfo);
        
        list<OppyTypeWrappers> oppytypewrappers = initilizeOppysMapping();
        for(OppyTypeWrappers oppytypewrapper : oppytypewrappers){
            list<string> list_labels = new list<string>();
            list<string> list_APIs = new list<string>();
            for(string  coverName: oppytypewrapper.oppyWrappers){
                list_labels.addAll(map_labels.get(coverName));
                list_APIs.addAll(map_APIs.get(coverName));
                set_OppyIndependants.add(coverName);
            }
            fieldsetInfo.incs.put(oppytypewrapper.title,list_labels);
            fieldsetInfo.incsAPIs.put(oppytypewrapper.title,list_APIs);
        }
        fieldsetInfo = new FieldSetInfo();
        fieldsetInfo.dtype = MULT_PICKLIST_TYPE;
        fieldsetInfo.title = OPPY_DETLS_DEF;
        list_fieldSetInfos.add(fieldsetInfo);
        for(FieldFilter filter : list_fieldfilters){
            if(!set_OppyIndependants.contains(filter.name)){
                fieldsetInfo.incs.put(filter.name,map_labels.get(filter.name));
                fieldsetInfo.incsAPIs.put(filter.name,map_APIs.get(filter.name));
            }
        }
        return list_fieldSetInfos;
    }
    /**
    * this method is used for contruct oppy components structure
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @return list<OppyTypeWrappers>
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */ 
    public static list<OppyTypeWrappers> initilizeOppysMapping(){
        list<OppyTypeWrappers> oppytypewrappers = new list<OppyTypeWrappers>();
        
        list<string> list_oppyNameSets = new list<string>();
        list_oppyNameSets.add(OPPY_MDTY_CLMN);
        
        OppyTypeWrappers oppytype = new OppyTypeWrappers();
        oppytype.title = OPPY_TYPE;
        oppytype.oppyWrappers.addAll(list_oppyNameSets);
        oppytypewrappers.add(oppytype);
        
        oppytype = new OppyTypeWrappers();
        oppytype.title = OPPY_PLUS_PART_TYPE;
        //oppytype.oppyWrappers.addAll(list_oppyNameSets);
        oppytype.oppyWrappers.add(OPPY_PART_DETL);
        oppytypewrappers.add(oppytype);
        
        oppytype = new OppyTypeWrappers();
        oppytype.title = OPPY_PLUS_PARTER_TYPE;
        //oppytype.oppyWrappers.addAll(list_oppyNameSets);
        oppytype.oppyWrappers.add(OPPY_PARTNER_DETL);
        oppytypewrappers.add(oppytype);
        
        return oppytypewrappers;
    }
    /**
    * this method is used for getting the fieldInfo
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param fieldsetname string 
    @param reference string
    *
    @return list<FieldInfo>
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */ 
    public static list<FieldInfo> getFields(string fieldsetname, string reference){
        list<FieldInfo> list_fieldInfos = new list<FieldInfo>();
        try{
            list<Schema.DescribeSObjectResult> list_dsos = Schema.describeSObjects(new string[]{reference});
            if(list_dsos == null || list_dsos.isEmpty())
                return null;
            Schema.DescribeSObjectResult result = list_dsos[0];
            list<FieldSetMember>  members = result.fieldSets.getMap().get(fieldsetname).getFields();
            for(FieldSetMember member : members){
                FieldInfo info = new FieldInfo();
                info.fieldlabel = member.getLabel();
                info.fieldAPI = member.getFieldPath();
                info.dtype  = member.getType().name();
                list_fieldInfos.add(info);
            }
        }catch(Exception ex){
            system.debug('The following exception has occurred: ' + ex.getMessage());
        }
        return list_fieldInfos;
    }
    /**
    * this method is used for getting user public groups
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param userId string 
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */ 
    public static void getUserPublicGroups(string userId){
        set_pgs = new set<string>();
        list<Group> list_pgs = [select Name from Group where id in (select GroupId from GroupMember where userorgroupid = :userId)];
        if(list_pgs != null && !list_pgs.isEmpty()){
            for(Group pg : list_pgs){
                set_pgs.add(pg.Name);
            }
        }
    }
    /**
    * this method is used for fetch prop data when do initilization
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param tid string 
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */ 
    public static list<APL_Filter__c> dbLoading(String tid){
        list<APL_Filter__c> list_APLFilters = null;
        if(tid == null || tid == ''){
            list_APLFilters =  [SELECT APL_Filter__c,Is_Reqired__c, Name, Category__c,Display_Name__c,Display_by_Parent_value__c, Domain_Values_Soql__c,Params_Mapping__c,
                                        Result_Filter__c,Object__c,Domain_Values__c, Order__c, Id, Type__c,Default_Clause_SOQL__c,Oppy_Forecast_Label_Name__c, 
                                        (select Display_Name__c,Value__c,Order__c,Condition_Clause_SOQL__c,Disable_Children_Query__c,Public_Group_Access__c from APL_Filter_Domain_Values__r) 
                                from APL_Filter__c where Active__c = true order by Order__c asc];
        }else{
            list_APLFilters =  [SELECT APL_Filter__c,Is_Reqired__c, Name, Category__c,Display_Name__c,Display_by_Parent_value__c, Domain_Values_Soql__c,Params_Mapping__c,
                                        Result_Filter__c, Object__c,Domain_Values__c, Order__c, Id, Type__c,Default_Clause_SOQL__c,Oppy_Forecast_Label_Name__c, 
                                        (select Id, Value__c from APL_User_Filter__r where USER__C = :UserInfo.getUserId() and Template__c = :tid),
                                        (select Display_Name__c,Value__c,Order__c,Condition_Clause_SOQL__c,Disable_Children_Query__c,Public_Group_Access__c from APL_Filter_Domain_Values__r) 
                                from APL_Filter__c where Active__c = true order by Order__c asc];
        }
        try{
            //changed by BYU
            for(APL_Oppy_Portal_Template__c t : [Select Id, Name, Report_Level__c, Report_Component__c from APL_Oppy_Portal_Template__c where CreatedById = :UserInfo.getUserId()]){
                OPPYTemaplate template = new OPPYTemaplate();
                template.label = t.Name;
                template.value = t.Id;
                template.rptLvl = t.Report_Level__c;
                template.rptCopt = t.Report_Component__c;
                list_templates.add(template);
            }
            /*
            list<AggregateResult> list_ufilers= [select Template__r.Id, Template__r.Name, Template__r.Report_Level__c, Template__r.Report_Component__c from APL_User_Filter__c where USER__C = :UserInfo.getUserId() group by Template__r.Id, Template__r.Name, Template__r.Report_Level__c, Template__r.Report_Component__c];
            if(list_ufilers != null && !list_ufilers.isEmpty()){
                for(AggregateResult rest : list_ufilers){
                    OPPYTemaplate template = new OPPYTemaplate();
                    template.label = (String)rest.get('Name');
                    template.value = (String)rest.get('Id');
                    template.rptLvl = (String)rest.get('Report_Level__c');
                    template.rptCopt = (String)rest.get('Report_Component__c');
                    list_templates.add(template);
                }
            }
            */
            //system.debug('list_APLFilters = ' + list_APLFilters);
            //system.debug('list_ufilers = ' + list_ufilers);
            //system.debug('list_templates = ' + list_templates);
           }catch(Exception ex){
              system.debug('The following exception has occurred: ' + ex.getMessage());
           } 
        return list_APLFilters;
    }
    /**
    * this method is used for processing the dbdata when initialization
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param list_APLFilters list<APL_Filter__c> 
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */ 
    public static void processAPLFilters(list<APL_Filter__c> list_APLFilters ){
        for(APL_Filter__c  filter : list_APLFilters){
            if(filter.APL_Filter__c == null || (filter.APL_Filter__c !=null && filter.Display_by_Parent_value__c != null)){
                processSimpleFilter(filter);
            }
        }
        for(APL_Filter__c  filter : list_APLFilters){
            if(filter.APL_Filter__c != null && filter.Display_by_Parent_value__c == null){
                processDependencyFilter(filter,list_APLFilters);
            }
        }
        
    }
    /**
    * this method is used for processing simple filters with no dependency
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param filter APL_Filter__c
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */ 
    public static void processSimpleFilter(APL_Filter__c filter){
        APLFilterWrapper wrapper = convertToWrapper(filter);
        list_APLFilterWrappers.add(wrapper);
        system.debug('!@#filter : '+filter);
        processValuesInitialize(wrapper,filter);
        system.debug('before validate processSimpleFilter filter displayName  = ' + wrapper.displayName + '; values = ' + wrapper.values + '; dvalues = ' + wrapper.listDomainValues);
        validateUserFilterValue(wrapper);
        system.debug('after validate processSimpleFilter filter displayName  = ' + wrapper.displayName + '; values = ' + wrapper.values + '; dvalues = ' + wrapper.listDomainValues);
        //system.debug('processSimpleFilter Validate wrapper = ' + wrapper);
    }
     /**
    * this method is used for converting APL_Filter__c filter to APLFilterWrapper
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param filter APL_Filter__c
    *
    @return APLFilterWrapper
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static APLFilterWrapper convertToWrapper(APL_Filter__c filter){
        APLFilterWrapper wrapper = new APLFilterWrapper();
        wrapper.initialize(filter);
        APLFilterServerWrapper serverWrapper = new APLFilterServerWrapper();
        serverWrapper.initialize(filter);
        map_idToFSWrappers.put(serverWrapper.id,serverWrapper);
        return wrapper;
    }
    /**
    * this method is used for processing dependent filters
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param filter           APL_Filter__c
    @param list_APLFilters  list<APL_Filter__c>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */ 
    public static void processDependencyFilter(APL_Filter__c filter,list<APL_Filter__c> list_APLFilters ){
        lkpParentAPLFilter(filter,list_APLFilters);
    }
    
    public static APL_Filter__c lkpParentAPLFilter(APL_Filter__c filter,list<APL_Filter__c> list_APLFilters ){
        if(filter.APL_Filter__c == null)
            return filter;
        for(APLFilterWrapper wrapper : list_APLFilterWrappers){
            if(wrapper.id.equals(filter.id))//already initialized then return;
               return filter;
        }
        APLFilterWrapper wrapper = convertToWrapper(filter);
        list_APLFilterWrappers.add(wrapper);
        for(APL_Filter__c apl : list_APLFilters){
            if(apl.id.equals(filter.APL_Filter__c)){
                APL_Filter__c masterFilter = lkpParentAPLFilter(apl,list_APLFilters);
                initilizeDependencyAPLFilter(filter,wrapper,masterFilter);
                break;
            }
        }
        return filter;
    }
    @TestVisible
    private static void initilizeDependencyAPLFilter(APL_Filter__c filter,APLFilterWrapper filterWrapper,APL_Filter__c masterFilter){
        APLFilterWrapper masterWrapper = null;
        for(APLFilterWrapper wrapper : list_APLFilterWrappers){
            if(wrapper.id.equals(masterFilter.id)){
                masterWrapper = wrapper;
                break;
            }
        }
        if(masterWrapper == null)
            return ;
        boolean bAppend = false;
        system.debug('initilizeDependencyAPLFilter values = ' + masterWrapper.values);
        set<String> set_masters = new set<String>();
        for(APLFilterValue filterValue: masterWrapper.values){//TODO value
            if(getDiableStatusFromLabel(filterValue.label,masterWrapper))
                return ;
            
            String value = getValueFromLabel(filterValue.label,masterWrapper);
            if(value != null){
                set_masters.add(value);
                if(value.contains(COMMA))
                    bAppend = true;
            }   
        }
        initilizeDependencyData(filter,filterWrapper,set_masters,bAppend);
    }
    @TestVisible
    private static string getValueFromLabel(String label, APLFilterWrapper masterWrapper){
        //system.debug('getValueFromLabel label = ' + label + '; values = ' + masterWrapper.values);
        APLFilterServerWrapper serverWrapper = map_idToFSWrappers.get(masterWrapper.id);
        if(serverWrapper == null){
            return null;
        }   
        LabelRefObject refObj = serverWrapper.map_labelToReference.get(label);
        if(refObj == null){
            return null;
        }   
        //system.debug('label = ' + label + '; refObj = ' + refObj);
        return refObj.value;
    }
    @TestVisible
    public static boolean getDiableStatusFromLabel(String label, APLFilterWrapper masterWrapper){
        /*
        system.debug('label = ' + label);
        system.debug('masterWrapper = ' + masterWrapper);
        system.debug('map_idToFSWrappers = ' + map_idToFSWrappers);*/
        APLFilterServerWrapper serverWrapper = map_idToFSWrappers.get(masterWrapper.id);
        if(serverWrapper == null)
            return false;
        LabelRefObject refObj = serverWrapper.map_labelToReference.get(label);
        if(refObj == null)
            return false;
        return refObj.disableChildrenQuery;
    }
    @TestVisible
    private static void initilizeDependencyData(APL_Filter__c filter,APLFilterWrapper filterWrapper,set<string> set_masters, boolean bAppend){
        
        if(!filterWrapper.bReq && PICKLIST_TYPE.equals(filterWrapper.filterType)){////filterType PICKLIST_TYPE
            filterWrapper.listDomainValues.add(NONE_APLFILTER);
        }
        //system.debug('InitilizeDependencyData displayName = ' + filterWrapper.displayName + '; set_masters = ' + set_masters + '; bAppend = ' + bAppend);
        if(set_masters.isEmpty()){
            filterWrapper.values.clear();
            return ;
        }
        if(filter.Domain_Values_Soql__c == null)
            return ;
        string rightSoql = null;//list_pIds
        if(!bAppend){
            rightSoql = filter.Domain_Values_Soql__c.replace('($Parent$)', ':set_masters');
        }else{
            string realValues = '';
            for(string pvalue : set_masters){
                pvalue = isInQuotation(pvalue) ? pvalue : addQuotation(pvalue);
                realValues += pvalue + COMMA;
            }
            if(realValues.endsWith(COMMA)){
                realValues = trimEndWithsToken(realValues,COMMA);
                realValues = isInParenthesis(realValues) ? realValues : addParenthesis(realValues);
            }
            rightSoql = filter.Domain_Values_Soql__c.replace('($Parent$)', realValues);
        }
        
        try{
            list<String> params = parseParamsMapping(filter.Params_Mapping__c);
            if(params == null || params.size() != 2)
                return ;
            list<sObject> objs = database.query(rightSoql);
            if(objs == null || objs.isEmpty())
                return ;
            APLFilterServerWrapper serverWrapper = map_idToFSWrappers.get(filterWrapper.id);
            for(sObject obj : objs){
                string label = (string)obj.get(params[0]);
                if(!string.isEmpty(label)){
                    processDependencyData(filterWrapper,serverWrapper,label,(String)obj.get(params[1]));
                }
                    /*
                    APLFilterValue filterValue = new  APLFilterValue();
                    filterValue.value = filterValue.label = (string)obj.get(params[0]);
                    //filterValue.value = (String)obj.get(params[1]);
                    LabelRefObject refObject = new LabelRefObject();
                    refObject.value = (String)obj.get(params[1]);
                    serverWrapper.map_labelToReference.put(filterValue.label,refObject);*/
                
            }
        }catch(Exception ex){
            System.debug('The following exception has occurred: ' + ex.getMessage());
        }
    }
    public static void processDependencyData(APLFilterWrapper filterWrapper,APLFilterServerWrapper serverWrapper,string label, string value){
        APLFilterValue filterValue = new  APLFilterValue();
        filterValue.value = filterValue.label = label;
        LabelRefObject refObject = new LabelRefObject();
        refObject.value = value;
        serverWrapper.map_labelToReference.put(filterValue.label,refObject);
        filterWrapper.listDomainValues.add(filterValue);
    }
    
    
    public static void validateUserFilterValues(){//filter.APL_Filter__c == null || (filter.APL_Filter__c !=null && filter.Display_by_Parent_value__c != null)
        for(APLFilterWrapper wrapper : list_APLFilterWrappers){
            if(wrapper.pid != null && wrapper.pvalues == null){//TODO
                validateUserFilterValue(wrapper);
            }
        }
    }
    
    public static void trimNullFilterValue(list<APLFilterValue> list_filters){
        list<APLFilterValue> list_clone = list_filters.clone();
        list_filters.clear();
        Iterator<APLFilterValue> iter = list_clone.iterator();
        while(iter.hasNext()){
            APLFilterValue filter = iter.next();
            if(filter.label != null)
                list_filters.add(filter);
        }
        list_clone.clear();
    }
    public static void validateUserFilterValue(APLFilterWrapper wrapper){
        //system.debug('validateUserFilterValue wrapper = ' + wrapper);
        if(wrapper.values == null || wrapper.values.isEmpty())
            return ;
        if(DATE_TYPE.equals(wrapper.filterType) 
                    || CHECKBOX_TYPE.equals(wrapper.filterType) 
                    || DATE_YEAR_DEF.equals(wrapper.filterType))//datatype.equals(DATE_TYPE)
            return ;
        if(wrapper.listDomainValues == null || wrapper.listDomainValues.isEmpty()){
            wrapper.values.clear();
            return ;
        }
        trimNullFilterValue(wrapper.listDomainValues);
        if(wrapper.listDomainValues.isEmpty()){
            wrapper.values.clear();
            return ;
        }
        boolean bSame = true;
        for(APLFilterValue filterValue : wrapper.listDomainValues){
            if(filterValue.label == null){
                //system.debug('wrapper displayName = ' + wrapper.displayName + '; filterValue.value =' + filterValue.value);
                continue;
            }   
            if(!filterValue.label.equals(filterValue.value)){
                //system.debug('wrapper displayName = ' + wrapper.displayName +'; filterValue.label =' + filterValue.label + '; filterValue.value =' + filterValue.value);
                bSame = false;
                break;
            }
        }
        system.debug('!@#wrapper: ' + wrapper);
        set<APLFilterValue> set_APLFilterValues = new set<APLFilterValue>(wrapper.listDomainValues);
        wrapper.listDomainValues.clear();
        
        set<APLFilterValue> set_SelectedValues = new set<APLFilterValue>(wrapper.values);
        wrapper.values.clear();
        system.debug('set_SelectedValues: ' + set_SelectedValues);
        system.debug('set_APLFilterValues: ' + set_APLFilterValues);
        if(!bSame){
            for(APLFilterValue filterValue : set_SelectedValues){
                for(APLFilterValue domainFilterValue : set_APLFilterValues){
                    if(filterValue.label.equals(domainFilterValue.label)){
                        filterValue.label = domainFilterValue.label;
                        filterValue.value = domainFilterValue.value;
                        break;
                    }
                }
            }
        }
        if(!set_APLFilterValues.containsAll(set_SelectedValues)){
            set<APLFilterValue> set_clone = set_SelectedValues.clone();
            set_SelectedValues.removeAll(set_APLFilterValues);
            set_clone.removeAll(set_SelectedValues);
            set_APLFilterValues.removeAll(set_clone);
            wrapper.values.addAll(set_clone);
        }else{
            set_APLFilterValues.removeAll(set_SelectedValues);
            wrapper.values.addAll(set_SelectedValues);
        }
        system.debug('listDomainValues: ' + wrapper.listDomainValues);
        wrapper.listDomainValues.addAll(set_APLFilterValues);   
    }
    /**
    *this method is used to proces value initialization for simple filters
    @author shawn liu
    @created 2015-01-29
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param     APLFilterWrapper     wrapper
    @param     APL_Filter__c        filter
    *
    *
    @changelog
    * 2015-01-29 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static void processValuesInitialize(APLFilterWrapper wrapper,APL_Filter__c filter){
        domainValuesInitilize(wrapper,filter);
    }
    /**
    *this method is used to initialize values for simple filters
    @author shawn liu
    @created 2015-01-29
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param     APLFilterWrapper     wrapper
    @param     APL_Filter__c        filter
    *
    *
    @changelog
    * 2015-01-29 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static void domainValuesInitilize(APLFilterWrapper wrapper,APL_Filter__c filter){
        
        if(!wrapper.bReq && PICKLIST_TYPE.equals(wrapper.filterType)){
            wrapper.listDomainValues.add(NONE_APLFILTER);
        }////list_pgs getUserPublicGroups(string userId) Public_Group_Access__c UserInfo.getUserId()
        if(filter.APL_Filter_Domain_Values__r != null && filter.APL_Filter_Domain_Values__r.size() > 0){
            for(APL_Filter_Domain_Values__c apl_filter_domain_value : filter.APL_Filter_Domain_Values__r){
                if(!string.isEmpty(apl_filter_domain_value.Public_Group_Access__c)){
                    list<string> pgs = parseStringValue(apl_filter_domain_value.Public_Group_Access__c,SEMICOLON);
                    if(set_pgs == null)
                        getUserPublicGroups(UserInfo.getUserId()); 
                    
                    boolean bContained = false;
                    for(string pgname: pgs){
                        if(set_pgs.contains(pgname)){
                            bContained = true;
                            break;
                        }
                    }
                    if(!bContained)
                        continue;
                }
                if(!string.isEmpty(apl_filter_domain_value.Display_Name__c)){
                    APLFilterValue filterValue = new  APLFilterValue();
                    filterValue.value = filterValue.label = apl_filter_domain_value.Display_Name__c;
                    filterValue.orderNum = (integer)apl_filter_domain_value.Order__c;
                    wrapper.listDomainValues.add(filterValue);
                    APLFilterServerWrapper serverWrapper = map_idToFSWrappers.get(wrapper.id);
                    LabelRefObject refObject = new LabelRefObject();
                    refObject.value = apl_filter_domain_value.Value__c;
                    refObject.disableChildrenQuery = apl_filter_domain_value.Disable_Children_Query__c;
                    if(apl_filter_domain_value.Condition_Clause_SOQL__c != null){
                        refObject.conditionSOQL = apl_filter_domain_value.Condition_Clause_SOQL__c;
                    }
                    serverWrapper.map_labelToReference.put(filterValue.label,refObject);
                }
            }
            system.debug('domainValuesInitilize wrapper.listDomainValues = ' + wrapper.listDomainValues);
            wrapper.listDomainValues.sort();
            return ;
        }
        if(filter.Domain_Values_Soql__c == null)
            return ;
        try{
            list<String> params = parseParamsMapping(filter.Params_Mapping__c);
            if(params == null || params.size() != 2)
                return ;
            
            list<sObject> objs = database.query(filter.Domain_Values_Soql__c);
            if(objs == null || objs.isEmpty())
                return ;
            APLFilterServerWrapper serverWrapper = map_idToFSWrappers.get(wrapper.id);
            for(sObject obj : objs){
                if(PLM_ID_DEF.equals(params[0])){//special case;  || PLM_ID_DEF.equals(params[1])
                    string plmId = (string)obj.get(params[0]);
                    if(plmId != null)
                        plmId = plmId.trim();
                    if(!string.isEmpty(plmId) && plmId.length() == 16){
                        processDependencyData(wrapper,serverWrapper,plmId,plmId);
                    }
                    string plmdst = (string)obj.get(params[1]);
                    if(plmdst != null)
                        plmdst = plmdst.trim();
                    if(!string.isEmpty(plmdst) && plmdst.length() >= 16){
                        plmdst = plmdst.substring(0,16);
                        processDependencyData(wrapper,serverWrapper,plmdst,plmdst);
                    }
                }else{
                    APLFilterValue filterValue = new  APLFilterValue();
                    filterValue.value = filterValue.label = (String)obj.get(params[0]);
                    //filterValue.value = (String)obj.get(params[1]);
                    wrapper.listDomainValues.add(filterValue);
                    //APLFilterServerWrapper serverWrapper = map_idToFSWrappers.get(wrapper.id);
                    
                    LabelRefObject refObject = new LabelRefObject();
                    refObject.value = (String)obj.get(params[1]);
                    serverWrapper.map_labelToReference.put(filterValue.label,refObject);
                }
            }
            if(PLM_ID_DEF.equals(params[0]) && wrapper.listDomainValues != null && !wrapper.listDomainValues.isEmpty()){
                    set<APLFilterValue> set_dvalues = new set<APLFilterValue>(wrapper.listDomainValues);
                    wrapper.listDomainValues.clear();
                    wrapper.listDomainValues.addAll(set_dvalues);
            }
        }catch(Exception ex){
            system.debug('The following exception has occurred: ' + ex.getMessage());
        }
    }
    /**
    *this method is used to retrieves the params for getting the value
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param     params       string
    *
    @return list<String>
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static list<String> parseParamsMapping(String params){
        return APL_ClsMangerAPLUtil.parseStringValue(params,SEMICOLON);
    }
    
   /**
    * This method is used to save a template
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param tname    string
    @param oppyType string
    @param oppyDetails  string
    @param userJson     string
    *
    @return string
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */      
    public static string doSaveAs(string tname,string oppyType, string oppyDetails,string userJson){//TODO category for date don't need to save
        system.debug('tname = ' + tname + ';oppyType = ' + oppyType + ';oppyDetails = ' + oppyDetails);
        system.debug('userJson = ' + userJson);
        APL_Oppy_Portal_Template__c template = null;
        try{
            template = new APL_Oppy_Portal_Template__c();
            template.Name = tname;
            template.Report_Level__c = oppyType;
            template.Report_Component__c = oppyDetails;
            insert template;
            doUpsertUserFilters(template.id,userJson);
            return template.id;
        }catch(Exception ex){
            system.debug('The following exception has occurred: ' + ex.getMessage());
        }
        return '';
    }
    
    
    //***********************Convert to Wrapper***********************
    /**
    * This method is used to convert to partpropswrapper
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param tname            string
    @param oppyPart         Opportunity_Part__c
    @param list_fieldSets   list<FieldFilter>
    *
    @return PropsWrapper
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */ 
    @TestVisible
    private static PropsWrapper convertToPartPropsWrapper(string oppyId, Opportunity_Part__c oppyPart,list<FieldFilter> list_fieldSets){
        PropsWrapper wrapper = new PropsWrapper();
        //wrapper.oppyType = OPPY_PLUS_PART_TYPE;
        wrapper.oppyId = oppyId;
        wrapper.oppyPartId = oppyPart.Id;
        for(FieldFilter filterset : list_fieldSets){
            if(filterset.name.equals(OPPY_PART_DETL)){
                for(FieldInfo info : filterset.list_fieldInfos){
                    if('DATE'.equalsIgnoreCase(info.dtype) || 'DATETIME'.equalsIgnoreCase(info.dtype)){
                        DateTime dt = (DateTime)oppyPart.get(info.fieldAPI);
                        string value = '';
                        if(dt != null)
                            value = dt.format('yyyy-MM-dd');
                        wrapper.list_entries.add(info.fieldAPI + OPRAND_EQUALS + value);
                    }else{
                        wrapper.list_entries.add(info.fieldAPI + OPRAND_EQUALS + (oppyPart.get(info.fieldAPI) == null ? '' : oppyPart.get(info.fieldAPI)));
                    }
                }
            }
        }
        return wrapper;
    }
    /**
    * This method is used to convert to OppyProps Wrapper
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param oppy             Opportunity
    @param list_fieldSets   list<FieldFilter>
    @param details          list<string>
    *
    @return PropsWrapper
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */ 
    public static PropsWrapper convertToOppyPropsWrapper(Opportunity oppy,list<FieldFilter> list_fieldSets, list<string> details){
        PropsWrapper wrapper = new PropsWrapper();
        //wrapper.oppyType = OPPY_TYPE;
        wrapper.oppyId = oppy.Id;
        for(FieldFilter filterset : list_fieldSets){
            if(filterset.name.startsWith(OPPY_MDTY)){
                for(FieldInfo info : filterset.list_fieldInfos){
                    if('DATE'.equalsIgnoreCase(info.dtype) || 'DATETIME'.equalsIgnoreCase(info.dtype)){
                        DateTime dt = (DateTime)oppy.get(info.fieldAPI);
                        string value = '';
                        if(dt != null)
                            value = dt.format('yyyy-MM-dd');
                        wrapper.list_entries.add(info.fieldAPI + OPRAND_EQUALS + value);
                    }else{
                        wrapper.list_entries.add(info.fieldAPI + OPRAND_EQUALS + (oppy.get(info.fieldAPI) == null ? '' : oppy.get(info.fieldAPI)));
                    }
                }
            }
        }
        for(string fieldsetName : details){
            for(FieldFilter filterset : list_fieldSets){
                if(filterset.name.equals(fieldsetName)){
                    for(FieldInfo info : filterset.list_fieldInfos){
                        if('DATE'.equalsIgnoreCase(info.dtype) || 'DATETIME'.equalsIgnoreCase(info.dtype)){
                            DateTime dt = (DateTime)oppy.get(info.fieldAPI);
                            string value = '';
                            if(dt != null)
                                value = dt.format('yyyy-MM-dd');
                            wrapper.list_entries.add(info.fieldAPI + OPRAND_EQUALS + value);
                        }else{
                            wrapper.list_entries.add(info.fieldAPI + OPRAND_EQUALS + (oppy.get(info.fieldAPI) == null ? '' : oppy.get(info.fieldAPI)));
                        }
                    }
                }
            }
        }
        return wrapper;
    }
    /**
    * This method is used to convert to OppyPartnerProps Wrapper
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param oppyId           string
    @param partner          Opportunity_Partner__c
    @param list_fieldSets   list<FieldFilter>
    *
    @return PropsWrapper
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */ 
    @TestVisible
    private static PropsWrapper convertToPartnerPropsWrapper(String oppyId, Opportunity_Partner__c partner, list<FieldFilter> list_fieldSets){
        PropsWrapper wrapper = new PropsWrapper();
        //wrapper.oppyType = OPPY_PLUS_PARTER_TYPE;
        wrapper.oppyId = oppyId;
        wrapper.oppyPartnerId = partner.Id;
        wrapper.allocation = partner.Allocation__c;
        for(FieldFilter filterset : list_fieldSets){
            if(filterset.name.equals(OPPY_PARTNER_DETL)){
                for(FieldInfo info : filterset.list_fieldInfos){
                    if('DATE'.equalsIgnoreCase(info.dtype) || 'DATETIME'.equalsIgnoreCase(info.dtype)){
                        DateTime dt = (DateTime)partner.get(info.fieldAPI);
                        string value = '';
                        if(dt != null)
                            value = dt.format('yyyy-MM-dd');
                        wrapper.list_entries.add(info.fieldAPI + OPRAND_EQUALS + value);
                    }else{
                        wrapper.list_entries.add(info.fieldAPI + OPRAND_EQUALS + (partner.get(info.fieldAPI) == null ? '' : partner.get(info.fieldAPI)));
                    }
                }
            }
        }
        return wrapper;
    }
    /**
    * This method is used to calculate the limit size for query
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param fcstInterval         string
    @param queryYears           integer
    *
    @return integer
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */ 
    public static integer getLimitSize(string fcstInterval, integer queryYears){
        system.debug('fcstInterval = ' + fcstInterval + '; queryYears = ' + queryYears);
        integer base = 1;
        if(!fcstInterval.containsIgnoreCase(DATE_YEAR_DEF))
            base = 4;
        integer gradunarity = base * queryYears * 10;
        return 2000/gradunarity * gradunarity;
    }
    //***********************Query***********************
    //Oppy partner
    /**
    * This method is used to query OppyPartner 
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param oppyId           string
    @param cachedFos        list<FieldFilter>
    @param map_oppyIdCached map<string,set<string>>
    *
    @return list<PropsWrapper>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */ 
    /*public static list<PropsWrapper> queryOppyPartnerResult(string oppyId,list<FieldFilter> cachedFos, map<string,set<string>> map_oppyIdCached){
        list<PropsWrapper> list_propswrappers = new list<PropsWrapper>();
        set<string> set_oppyIds = new set<string>();
        set_oppyIds.add(oppyId);
        try{
            list<sObject> objs = queryOppyPartners(false,set_oppyIds,'');
            if(objs != null && !objs.isEmpty()){
                for(sObject objt : objs){
                    PropsWrapper wrapper = convertToPartnerPropsWrapper(oppyId,(Opportunity_Partner__c)objt,cachedFos);
                    list_propswrappers.add(wrapper);
                }
            }
        }catch(Exception ex){
            system.debug('The following exception has occurred: ' + ex.getMessage());
        }
        return list_propswrappers;
    }*/
    /**
    * This method is used to query OppyPartner 
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param bExport          boolean
    @param set_oppyIds      set<string>
    @param lastId           string
    *
    @return list<sObject>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static list<sObject> queryOppyPartners(boolean bExport,set<string> set_oppyIds,string lastId){//string oppyId, map<string,set<string>> map_oppyIdCached
        integer limitsize = SQL_OPPYPARTNER_LIMITSIZE;
        if(bExport)
            limitsize = SQL_EXPT_LIMITSIZE;
        string whereCondition = ' where Opportunity__c in : set_oppyIds';
        if(!String.isEmpty(lastId))
            whereCondition += ' and id > :lastId ';
        string orderBy = ' order by Id asc ';
        APLFilter_FieldSet__c fieldset = APLFilter_FieldSet__c.getValues(OPPY_PARTNER_DETL);
        list<FieldInfo> list_fieldInfos = getFields(fieldset.Reference_FieldSet_Name__c,fieldset.Reference_Object__c);
        string soql = 'select ';
        for(FieldInfo info : list_fieldInfos ){
            soql += info.fieldAPI + COMMA;
        }
        if(!soql.containsIgnoreCase('id')){//containsIgnoreCase(substring)
            soql += 'id' + COMMA;
        }
        if(!soql.containsIgnoreCase('Opportunity__c')){//containsIgnoreCase(Opportunity__c)
            soql += 'Opportunity__c' + COMMA;
        }
        if(!soql.containsIgnoreCase('Allocation__c')){//containsIgnoreCase(substring)
            soql += 'Allocation__c' + COMMA;
        }
        soql = trimEndWithsToken(soql,COMMA);
        soql += ' from Opportunity_Partner__c ' + whereCondition + orderBy;
        if(limitsize > 0)
            soql +=  ' limit : limitsize';
        /*
        list<sObject> objs = null;
        try{
            objs = database.query(soql);
        }catch(Exception ex){
            system.debug('The following exception has occurred: ' + ex.getMessage());
        }*/
        return database.query(soql);
    }
    //Oppy Part;
    /**
    * This method is used to query OppyPart
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param oppyId           string
    @param cachedFos        list<FieldFilter>
    @param map_oppyIdCached map<string,set<string>>
    *
    @return string
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    /*public static string queryOppyPartResult(string oppyId,list<FieldFilter> cachedFos , map<string,set<string>> map_oppyIdCached){
        list<PropsWrapper> list_propswrappers = new list<PropsWrapper>();
        set<string> set_partIds = map_oppyIdCached.get(oppyId);
        //system.debug('set_partIds =' +  set_partIds);
        if(set_partIds == null || set_partIds.isEmpty())
            return Json.serialize(list_propswrappers);
        try{
            list<sObject> objs = queryOppyParts(false,set_partIds,'');
            if(objs != null && !objs.isEmpty()){
                for(sObject obj : objs){
                    PropsWrapper wrapper = convertToPartPropsWrapper(oppyId,(Opportunity_Part__c)obj,cachedFos);
                    list_propswrappers.add(wrapper);
                }
            }   
        }catch(Exception ex){
            system.debug('The following exception has occurred: ' + ex.getMessage());
        }
        return Json.serialize(list_propswrappers);
    }*/
    /**
    * This method is used to query OppyPart
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param bExport          boolean
    @param set_partIds      set<string>
    @param lastId           string
    *
    @return list<sObject>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static list<sObject> queryOppyParts(boolean bExport,set<string> set_partIds,string lastId){
        integer limitsize = SQL_OPPYPART_LIMITSIZE;
        if(bExport)
            limitsize = SQL_EXPT_LIMITSIZE;
        string whereCondition = 'where id in :set_partIds';
        
        if(!String.isEmpty(lastId))
            whereCondition += ' and id > :lastId ';
        
        string orderBy = ' order by id asc ';
        APLFilter_FieldSet__c fieldset = APLFilter_FieldSet__c.getValues(OPPY_PART_DETL);
        list<FieldInfo> list_fieldInfos = getFields(fieldset.Reference_FieldSet_Name__c,fieldset.Reference_Object__c);
        string soql = 'select ';
        for(FieldInfo info : list_fieldInfos ){
            soql += info.fieldAPI + COMMA;
        }
        soql = trimEndWithsToken(soql,COMMA);
        if(!soql.containsIgnoreCase('Opportunity__c')){
            soql += ', Opportunity__c ';
        }
        if(!soql.containsIgnoreCase('Id')){
            soql += ', Id ';
        }
        soql += ' from Opportunity_Part__c ' + whereCondition + orderBy;
        if(limitsize > 0)
            soql +=  ' limit : limitsize';
        
        //system.debug('queryOppyParts = ' + soql);//
        /*
        list<sObject> objs = null;
        try{
            objs = database.query(soql);    
        }catch(Exception ex){
            system.debug('The following exception has occurred: ' + ex.getMessage());
        }*/
        return database.query(soql);
    }
    /**
    * This method is used to query OppyPart Forecast
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param oppyId           string
    @param fcstInterval     string
    @param preOppyPartId    string
    @param queryYears       integer
    @param soqlYearRange    string
    @param map_oppyIdCached map<string,set<string>>
    @param set_cachedLabels set<string>
    *
    @return string
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    /*public static string queryOppyPartFcstResult(string oppyId,string fcstInterval,string preOppyPartId,integer queryYears,string soqlYearRange, 
                                                            map<string,set<string>> map_oppyIdCached,set<string> set_cachedLabels){
        //system.debug('queryOppyPartFcstResult oppyId = ' + oppyId);
        set<string> partIds = map_oppyIdCached.get(oppyId);
        //system.debug('queryOppyPartFcstResult partIds = ' + partIds);
        list<ForcastWrapper> wrappers = queryOppyPartFcstObjects(fcstInterval,preOppyPartId,queryYears,soqlYearRange, partIds,set_cachedLabels);
        return Json.serialize(wrappers);
    }*/
    /**
    * This method is used to query OppyPart Forecast
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param fcstInterval     string
    @param preOppyPartId    string
    @param queryYears       integer
    @param soqlYearRange    string
    @param oppyPartIds      set<string>
    @param set_checkedFcstCacheLabels   set<string>
    *
    @return list<ForcastWrapper> 
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static list<ForcastWrapper> queryOppyPartFcstObjects(string fcstInterval,string preOppyPartId, integer queryYears,string soalYearRange, set<string> oppyPartIds, set<string> set_checkedFcstCacheLabels){
        integer fcstlimit = getLimitSize(fcstInterval,queryYears);
        list<ForcastWrapper> wrappers = new list<ForcastWrapper>();
        try{
            list<sObject> objs = queryOppyPartFcsts(fcstInterval,preOppyPartId,fcstlimit,soalYearRange, oppyPartIds);
            if(objs != null && !objs.isEmpty()){
                lastFcstOppyPartId = (string)objs.get(objs.size() - 1).get('Part__c');
                wrappers = convertToFcstWrappers(false,fcstInterval,objs,set_checkedFcstCacheLabels);
            }
        }catch(Exception ex){
            system.debug('The following exception has occurred: ' + ex.getMessage());           
        }
        return wrappers;
    }
    /**
    * This method is used to query OppyPart Forecast
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param fcstInterval         string
    @param preOppyPartId        string
    @param queryfcstlimitsize   integer
    @param soqlYearRange        string
    @param oppyPartIds          set<string>
    *
    @return list<sObject>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static list<sObject>  queryOppyPartFcsts(string fcstInterval,string preOppyPartId, integer fcstlimitsize,string soalYearRange, set<string> oppyPartIds){
        
        //edited by nelson zheng 2015-11-04 add sum(MSG1__c) MSG1, for case 00897724
        string querySOQL = 'select sum(Amount__c) SF, sum(APL_Weighted_FC__c) WF, sum(APL_Weighted_New_Business__c) WNB, sum(New_Bussiness_Forecast__c) NBF, sum(NPS1__c) NPS1, sum(NPS2__c) NPS2, sum(NPS3__c) NPS3, sum(MSG1__c) MSG1, Opportunity__c, Part__c, Fiscal_Year__c ';
        string queryTableSOQL = ' from Opportunity_Forecast__c ';
        string groupby = ' group by Opportunity__c,Part__c, Fiscal_Year__c ';
        string orderby =  ' order by Part__c asc, Fiscal_Year__c asc,Opportunity__c asc ';
        if(!fcstInterval.containsIgnoreCase(DATE_YEAR_DEF)){
            querySOQL += ', Fiscal_Quarter__c' ;
            groupby   += ', Fiscal_Quarter__c ';
            orderby   += ', Fiscal_Quarter__c asc';
        }
        querySOQL += queryTableSOQL;
        string whereCondition = null;
        if(String.isEmpty(preOppyPartId)){
            whereCondition = ' where Part__c in ($set_batchOppyIds$) and ' + soalYearRange + groupby + orderby;
            if(fcstlimitsize > 0)
                whereCondition += ' LIMIT :fcstlimitsize';
        }else{
            whereCondition = ' where Part__c > :preOppyPartId and Part__c in ($set_batchOppyIds$) and ' + soalYearRange + groupby + orderby;
            if(fcstlimitsize > 0)
                whereCondition += ' LIMIT :fcstlimitsize';
        }
        querySOQL += whereCondition;
        querySOQL = querySOQL.replace('($set_batchOppyIds$)', ' :oppyPartIds ');
        
        //system.debug('queryOppyPartFcsts querySOQL = ' + querySOQL + $set_batchOppyIds$ = ' + oppyPartIds);
        //list<sObject> objs = database.query(querySOQL);
        /*
        try{
            objs = database.query(querySOQL);
        }catch(Exception ex){
            system.debug('The following exception has occurred: ' + ex.getMessage());
        }*/
        return database.query(querySOQL);
    } 
    //Oppy
    /**
    * This method is used to query Oppy
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param querySOQL                string
    @param lastId                   string
    @param list_cacheFieldFilters   list<FieldFilter>
    @param details                  list<string>
    *
    @return list<sObject>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static string queryOppyResult(string querySOQL, string lastId, set<string> oppyIds, list<FieldFilter> list_cacheFieldFilters,list<string> details){
        list<PropsWrapper> list_propswrappers = new list<PropsWrapper>();
        try{
            list<sObject> objs = queryOppys(false,querySOQL,lastId,oppyIds);
            if(objs != null && !objs.isEmpty()){
                oppyLastId = (string)objs.get(objs.size() - 1).get('id');
                for(sObject obj : objs){
                    PropsWrapper wrapper = convertToOppyPropsWrapper((Opportunity)obj,list_cacheFieldFilters,details);
                    list_propswrappers.add(wrapper);
                }
            }
        }catch(Exception ex){
            system.debug('The following exception has occurred: ' + ex.getMessage());
        }   
        return Json.serialize(list_propswrappers);
    }
     /**
    * This method is used to query Oppy
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param bExport      boolean
    @param querySOQL    string
    @param lastId       string
    @param oppyIds      set<string>
    *
    @return list<sObject>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static list<sObject> queryOppys(boolean bExport, string querySOQL, string lastId, set<string> oppyIds){
        integer limitsize = SQL_OPPY_LIMITSIZE;
        if(bExport)
            limitsize = SQL_EXPT_LIMITSIZE;
            
        if(String.isEmpty(lastId)){
            querySOQL += ' where id in ($oppyIds$) order by Id ';
            if(limitsize > 0 )
                querySOQL +=  'LIMIT :limitsize';
        }else{
            querySOQL += ' where id > :lastId and id in ($oppyIds$) order by Id ';
            if(limitsize > 0 )
                querySOQL +=  'LIMIT :limitsize';
        }
        system.debug('lastId = ' + lastId + '; limitsize = ' + limitsize + ';length = ' + oppyIds.size());
        list<sObject> objs = null;
        querySOQL = querySOQL.replace('($oppyIds$)', ':oppyIds');
        System.debug('--------------querySOQL11----------------'+querySOQL);
        /*
        try{
            objs = database.query(querySOQL);
        }catch(Exception ex){
            system.debug('The following exception has occurred: ' + ex.getMessage());
        }*/
        system.debug('!@#querySOQL : ' + querySOQL);
        return database.query(querySOQL);
    }
    /**
    * This method is used to query Oppy Forecast
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param fcstInterval         string
    @param preOppyId            string
    @param oppyFcstYearRange    string
    @param queryYears           integer
    @param oppyIds              set<string>
    @param map_oppyIdCached     map<string,set<string>>
    @param set_checkedFcstCacheLabels       set<string>
    *
    @return string
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static string queryOppyFcstResult(string types,string lastId, string yearSOQL,integer queryYears, set<string> oppyIds, map<string,set<string>> mappingIds, set<string> set_labels){
        integer fcstlimit = getLimitSize(types,queryYears);
        list<ForcastWrapper> list_oppyWrappers = queryOppyFcstObjects(types,lastId,fcstlimit,yearSOQL, oppyIds,mappingIds,set_labels);
        //system.debug('list_oppyWrappers = ' + list_oppyWrappers);
        return Json.serialize(list_oppyWrappers);
    }
    /**
    * This method is used to query Oppy Forecast
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param fcstInterval         string
    @param preOppyId            string
    @param fcstlimit            integer
    @param oppyFcstYearRange    string
    @param oppyIds              set<string>
    @param map_oppyIdCached     map<string,set<string>>
    @param set_checkedFcstCacheLabels       set<string>
    *
    @return list<ForcastWrapper>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static list<ForcastWrapper> queryOppyFcstObjects(string fcstInterval,string preOppyId,integer fcstlimit, string oppyFcstYearRange, set<string> oppyIds, map<string,set<string>> map_oppyIdCached, set<string> set_checkedFcstCacheLabels){
        list<ForcastWrapper> wrappers = new list<ForcastWrapper>();
        try{
            list<sObject> objs = queryOppyFcsts(fcstInterval,preOppyId,fcstlimit,oppyFcstYearRange,oppyIds,map_oppyIdCached,set_checkedFcstCacheLabels);
            if(objs != null && !objs.isEmpty()){
                lastFcstOppyId = (string)objs.get(objs.size() - 1).get('Opportunity__c');
                wrappers = convertToFcstWrappers(true,fcstInterval,objs,set_checkedFcstCacheLabels);
            }
        }catch(Exception ex){
            system.debug('The following exception has occurred: ' + ex.getMessage());
        }   
        return wrappers;
    }
    //TODO list_oppyFcst,list_innerDatas
    /**
    * This method is used to query Oppy Forecast
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param fcstInterval         string
    @param oppyId               string
    @param oppyFcstYearRange    string
    @param oppyIds              set<string>
    @param map_oppyIdCached     map<string,set<string>>
    @param set_checkedFcstCacheLabels       set<string>
    *
    @return ForcastWrapper
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    /*public static ForcastWrapper queryRightOppyFcstResult(string fcstInterval,string oppyId, string oppyFcstYearRange, set<string> set_checkedFcstCacheLabels,map<string,set<string>> map_oppyIdCached){
        list<ForcastWrapper> list_oppyWrappers = queryRightOppyFcstObjects(fcstInterval,oppyId,oppyFcstYearRange,set_checkedFcstCacheLabels,map_oppyIdCached);
        if(list_oppyWrappers == null || list_oppyWrappers.isEmpty())
            return null;
        else
            return list_oppyWrappers.get(0);
    }*/
    /**
    * This method is used to query Oppy Forecast
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param fcstInterval         string
    @param oppyId               string
    @param oppyFcstYearRange    string
    @param oppyIds              set<string>
    @param set_checkedFcstCacheLabels       set<string>
    @param map_oppyIdCached     map<string,set<string>>
    *
    @return list<ForcastWrapper>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static list<ForcastWrapper> queryRightOppyFcstObjects(string fcstInterval,string oppyId,string oppyFcstYearRange,set<string> set_checkedFcstCacheLabels,map<string,set<string>> map_oppyIdCached){
        list<sObject> objs = queryRightOppyFcsts(fcstInterval,oppyId,oppyFcstYearRange,map_oppyIdCached);
        list<ForcastWrapper> wrappers = new list<ForcastWrapper>();
        if(objs != null && !objs.isEmpty())
            wrappers = convertToFcstWrappers(true,fcstInterval,objs,set_checkedFcstCacheLabels);
        return wrappers;
    }
    /**
    * This method is used to query Oppy Forecast
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param fcstInterval         string
    @param oppyId               string
    @param oppyFcstYearRange    string
    @param map_oppyIdCached     map<string,set<string>>
    *
    @return list<sObject>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static list<sObject> queryRightOppyFcsts(string fcstInterval, string oppyId,string oppyFcstYearRange,map<string,set<string>> map_oppyIdCached){
        
        //edited by nelson zheng 2015-11-04 add sum(MSG1__c) MSG1, for case 00897724
        string querySOQL = 'select sum(Amount__c) SF, sum(APL_Weighted_FC__c) WF, sum(APL_Weighted_New_Business__c) WNB, sum(New_Bussiness_Forecast__c) NBF, sum(NPS1__c) NPS1, sum(NPS2__c) NPS2, sum(NPS3__c) NPS3, sum(MSG1__c) MSG1, Opportunity__c, Fiscal_Year__c';// from Opportunity_Forecast__c ';
        string tableQuerySOQL = ' from Opportunity_Forecast__c';
        string groupby = ' group by Opportunity__c , Fiscal_Year__c ';
        string orderby =  ' order by Opportunity__c asc,  Fiscal_Year__c asc ';
        if(!fcstInterval.containsIgnoreCase(DATE_YEAR_DEF)){
            querySOQL += ', Fiscal_Quarter__c ';
            groupby +=', Fiscal_Quarter__c ';
            orderby  +=  ', Fiscal_Quarter__c asc';
        }
        set<string> set_oppyPartId = map_oppyIdCached.get(oppyId);
        querySOQL += tableQuerySOQL;
        querySOQL += ' where Opportunity__c =\''+ oppyId +'\'  and Part__c in ($set_batchOppyIds$) and ' + oppyFcstYearRange + groupby + orderby;
        querySOQL = querySOQL.replace('($set_batchOppyIds$)', ' :set_oppyPartId');
        
        system.debug('queryRightOppyFcsts querySOQL = ' + querySOQL + '; set_oppyPartId = '+ set_oppyPartId);
        list<sObject> objs = null;
        try{
            objs = database.query(querySOQL);
        }catch(Exception ex){
            system.debug('The following exception has occurred: ' + ex.getMessage());
        }
        return objs;
    }
    /**
    * This method is used to query Oppy Forecast    
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param fcstInterval         string
    @param lastOppyId           string
    @param fcstlimitsize        integer
    @param oppyFcstYearRange    string
    @param oppyIds              set<string>
    @param map_oppyIdCached     map<string,set<string>>
    @param set_checkedFcstCacheLabels set<string>
    *
    @return list<sObject>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static list<sObject> queryOppyFcsts(string fcstInterval, string lastOppyId,integer fcstlimitsize,string oppyFcstYearRange, set<string> oppyIds, map<string,set<string>> map_oppyIdCached, set<string> set_checkedFcstCacheLabels){
        
        //edited by nelson zheng 2015-11-04 add sum(MSG1__c) MSG1, for case 00897724
        string querySOQL = 'select sum(Amount__c) SF, sum(APL_Weighted_FC__c) WF, sum(APL_Weighted_New_Business__c) WNB, sum(New_Bussiness_Forecast__c) NBF, sum(NPS1__c) NPS1, sum(NPS2__c) NPS2, sum(NPS3__c) NPS3, sum(MSG1__c) MSG1, Opportunity__c, Fiscal_Year__c';// from Opportunity_Forecast__c ';
        string tableQuerySOQL = ' from Opportunity_Forecast__c';
        string groupby = ' group by Opportunity__c , Fiscal_Year__c ';
        string orderby =  ' order by Opportunity__c asc,  Fiscal_Year__c asc ';
        if(!fcstInterval.containsIgnoreCase(DATE_YEAR_DEF)){
            querySOQL += ', Fiscal_Quarter__c ';
            groupby +=', Fiscal_Quarter__c ';
            orderby  +=  ', Fiscal_Quarter__c asc';
        }
        querySOQL += tableQuerySOQL;
        set<string> set_batchOppyIds = new set<string>();
        for(string oppyId : oppyIds){
            set<string> set_oppyPartId = map_oppyIdCached.get(oppyId);
            if(set_oppyPartId != null && !set_oppyPartId.isEmpty())
                set_batchOppyIds.addAll(set_oppyPartId);
        }
        //system.debug('$set_batchOppyIds$ = ' + set_batchOppyIds + ';$oppyIds$ = ' + oppyIds + ';lastOppyId = ' + lastOppyId);
        string whereCondition = null;
        if(String.isEmpty(lastOppyId)){
            whereCondition = ' where Amount__c != 0 and Opportunity__c in ($oppyIds$) and Part__c in ($set_batchOppyIds$) and ' + oppyFcstYearRange + groupby + orderby;
            if(fcstlimitsize > 0)
                whereCondition += ' LIMIT :fcstlimitsize';
        }else{
            whereCondition = ' where Opportunity__c > :lastOppyId and Opportunity__c in ($oppyIds$) and Part__c in ($set_batchOppyIds$) and ' + oppyFcstYearRange + groupby + orderby;
            if(fcstlimitsize > 0)
                whereCondition += ' LIMIT :fcstlimitsize';
        }
        querySOQL += whereCondition;
        querySOQL = querySOQL.replace('($oppyIds$)',' :oppyIds ').replace('($set_batchOppyIds$)', ' :set_batchOppyIds ');
        
        system.debug('fcstlimitsize = ' + fcstlimitsize + ';lastOppyId = ' + lastOppyId + ';$oppyIds$ = ' + oppyIds + '; $set_batchOppyIds$ = ' + set_batchOppyIds);
        
        /*
        list<sObject> objs = null;
        try{
            objs = database.query(querySOQL);
        }catch(Exception ex){//TODO RuntimeException
            system.debug('The following exception has occurred: ' + ex.getMessage());
        }*/
        return database.query(querySOQL);
    }
    //***********************Export***********************
    //Export code
    /**
    * This method is used to query Oppy Forecast for export
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param fcstInterval         string
    @param preExportOppyId      string
    @param queryYears           integer
    @param oppyFcstYearRange    string
    @param oppyIds              set<string>
    @param map_oppyIdCached     map<string,set<string>>
    @param set_checkedFcstCacheLabels set<string>
    *
    @return list<ForcastWrapper>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static list<ForcastWrapper> queryOppyFcstExport(string fcstInterval,string preExportOppyId,integer queryYears,string soqlYearRange, set<string> oppyIds, map<string,set<string>> map_oppyIdCached, set<string> set_checkedFcstCacheLabels){
        //integer fcstlimit = getLimitSize(fcstInterval, queryYears);
        list<ForcastWrapper> wrappers = new list<ForcastWrapper>();
        list<sObject> objs = queryOppyFcsts(fcstInterval,preExportOppyId,0,soqlYearRange,oppyIds,map_oppyIdCached,set_checkedFcstCacheLabels);
        /*
        if(objs != null && !objs.isEmpty()){
            lastExportFcstOppyId = (string)objs.get(objs.size() - 1).get('Opportunity__c');
            wrappers = convertToFcstWrappers(true,fcstInterval,objs,set_checkedFcstCacheLabels);
        }*/
        if(objs != null && !objs.isEmpty())
            wrappers = convertToFcstWrappers(true,fcstInterval,objs,set_checkedFcstCacheLabels);
        
        return wrappers;
    }
    /**
    * This method is used to query Oppy for export
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param fcstInterval         string
    @param oppyFcstYearRange    string
    @param querySOQL            string
    @param lastId               string
    @param map_oppyIdCached     map<string,set<string>>
    @param list_fieldSets       list<FieldFilter>
    @param details              list<string>
    *
    @return list<ForcastWrapper>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static list<PropsWrapper> queryOppyExport(string fcstInterval, string soqlYearRange,string querySOQL, string lastId, map<string,set<string>> map_oppyIdCached,list<FieldFilter> list_fieldSets, list<string> details){
        list<PropsWrapper> list_propswrappers = new list<PropsWrapper>();
        set<string> set_oppyIds = map_oppyIdCached.keySet();
        try{
            list<sObject> objs = queryOppys(true,querySOQL, lastId, set_oppyIds);
            if(objs == null || objs.isEmpty())
                return list_propswrappers;
            sObject lastObj = objs.get(objs.size() - 1);//for lastId;
            lastExportOppyId = (string)lastObj.get('id');
            for(sObject obj : objs){
                PropsWrapper wrapper = convertToOppyPropsWrapper((Opportunity)obj,list_fieldSets,details);
                system.debug('!@#wrapper : '+wrapper);
                list_propswrappers.add(wrapper);
            }
        }catch(Exception ex){
            system.debug('The following exception has occurred: ' + ex.getMessage());
        }
        return list_propswrappers;
    }
    /**
    * This method is used to query Oppy for export when invoked from client asynchronizely.
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param fcstInterval         string
    @param oppyFcstYearRange    string
    @param querySOQL            string
    @param lastId               string
    @param oppyIds              set<string>
    @param list_fieldSets       list<FieldFilter>
    @param details              list<string>
    *
    @return list<PropsWrapper>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    /*public static list<PropsWrapper> asynQueryOppyExport(string fcstInterval, string soqlYearRange,string querySOQL, string lastId, set<string> oppyIds,list<FieldFilter> list_fieldSets, list<string> details){
        list<PropsWrapper> list_propswrappers = new list<PropsWrapper>();
        list<sObject> objs = queryOppys(true,querySOQL,lastId,oppyIds);
        if(objs == null || objs.isEmpty())
            return list_propswrappers;
        for(sObject obj : objs){
            PropsWrapper wrapper = convertToOppyPropsWrapper((Opportunity)obj,list_fieldSets,details);
            list_propswrappers.add(wrapper);
        }
        return list_propswrappers;
    }*/
    
    //Part Export
    /**
    * This method is used to query OppyPart forecast for export
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param fcstInterval         string
    @param preExportPartFcstId  string
    @param queryYears           string
    @param soqlYearRange        string
    @param set_checkedFcstCacheLabels set<string>
    @param map_oppyIdCached     map<string,set<string>>
    *
    @return list<ForcastWrapper>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static list<ForcastWrapper> queryOppyPartFcstExport(string fcstInterval, string lastId,integer queryYears,string soqlYearRange, set<string> pids,set<string> labels){
        /*
        set<string> oppyIds = map_oppyIdCached.keySet();
        set<string> oppyPartIds = new set<string>();
        for(string oppy: oppyIds){
            oppyPartIds.addAll(map_oppyIdCached.get(oppy));
        }
        //integer fcstlimit = getLimitSize(fcstInterval,queryYears);
        list<ForcastWrapper> wrappers = new list<ForcastWrapper>();
        list<sObject> objs = queryOppyPartFcsts(fcstInterval,preExportPartFcstId,0,soqlYearRange, oppyPartIds);
        if(objs != null && !objs.isEmpty()){
            lastExportPartFcstId = (string)objs.get(objs.size() - 1).get('Part__c');
            wrappers = convertToFcstWrappers(false,fcstInterval,objs,set_checkedFcstCacheLabels);
        }*/
        list<ForcastWrapper> wrappers = new list<ForcastWrapper>();
        list<sObject> objs = queryOppyPartFcsts(fcstInterval,lastId,0,soqlYearRange, pids);
        if(objs != null && !objs.isEmpty())
            wrappers = convertToFcstWrappers(false,fcstInterval,objs,labels);
        
        return wrappers;
    }
    /**
    * This method is used to query OppyPart for export
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param interval             string
    @param soqlYearRange        string
    @param oppySOQL             string
    @param prePartId            string
    @param map_oppyIdCached     map<string,set<string>>
    @param set_checkedFcstCacheLabels set<string>
    @param list_fieldSets       list<FieldFilter>
    @param details              list<string> 
    *
    *
    @return list<ForcastWrapper>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static list<PropsWrapper> queryOppyPartExport(string interval, string soqlYearRange,string oppySOQL,string prePartId,map<string,set<string>> map_oppyIdCached, set<string> set_checkedFcstCacheLabels,list<FieldFilter> list_fieldSets, list<string> details){
        list<PropsWrapper> partwrappers = new list<PropsWrapper>();
        set<string> set_allPartIds = new set<string>();
        set<string> oppyIds = map_oppyIdCached.keySet();
        for(string oppyId : oppyIds)
            set_allPartIds.addAll(map_oppyIdCached.get(oppyId));
        list<sObject> objs = null;
        try{
            objs = queryOppyParts(true,set_allPartIds,prePartId);
        }catch(Exception ex){
            system.debug('The following exception has occurred: ' + ex.getMessage());
        }
        if(objs == null || objs.isEmpty())
                return partwrappers;
        set<string> set_oppyIds = new set<string>();
        for(sObject obj : objs){
            string oppyId = (string)obj.get('Opportunity__c');
            set_oppyIds.add(oppyId);
            PropsWrapper wrapper = convertToPartPropsWrapper(oppyId, (Opportunity_Part__c)obj,list_fieldSets);
            partwrappers.add(wrapper);
        }
        lastExportPartId = (string)objs.get(objs.size() - 1).get('Id');
        list<PropsWrapper> oppywrappers = new list<PropsWrapper>();
        try{
            list<sObject> oppys = queryOppys(true,oppySOQL,'',set_oppyIds);
            for(sObject obj : oppys){
                PropsWrapper wrapper = convertToOppyPropsWrapper((Opportunity)obj,list_fieldSets, details);
                oppywrappers.add(wrapper);
            }
        }catch(Exception ex){
            system.debug('The following exception has occurred: ' + ex.getMessage());
        }
        mergePropsWrappers(partwrappers,oppywrappers);
        return partwrappers;
    }
    
    /**
    * This method is used to query OppyPart for export
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param interval             string
    @param soqlYearRange        string
    @param oppySOQL             string
    @param prePartId            string
    @param map_oppyIdCached     map<string,set<string>>
    @param set_checkedFcstCacheLabels set<string>
    @param list_fieldSets       list<FieldFilter>
    @param details              list<string> 
    *
    *
    @return list<ForcastWrapper>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static list<PropsWrapper> queryOppyPartExport(string interval, string soqlYearRange,string oppySOQL,string prePartId, set<string> set_allPartIds, set<string> set_checkedFcstCacheLabels,list<FieldFilter> list_fieldSets, list<string> details){
        list<PropsWrapper> partwrappers = new list<PropsWrapper>();
        //set<string> set_allPartIds = new set<string>();
        //set<string> oppyIds = map_oppyIdCached.keySet();
        //for(string oppyId : oppyIds)
        //    set_allPartIds.addAll(map_oppyIdCached.get(oppyId));
        list<sObject> objs = null;
        try{
            objs = queryOppyParts(true, set_allPartIds, prePartId);
        }catch(Exception ex){
            system.debug('The following exception has occurred: ' + ex.getMessage());
        }
        if(objs == null || objs.isEmpty())
                return partwrappers;
        set<string> set_oppyIds = new set<string>();
        for(sObject obj : objs){
            string oppyId = (string)obj.get('Opportunity__c');
            set_oppyIds.add(oppyId);
            PropsWrapper wrapper = convertToPartPropsWrapper(oppyId, (Opportunity_Part__c)obj, list_fieldSets);
            partwrappers.add(wrapper);
        }
        lastExportPartId = (string)objs.get(objs.size() - 1).get('Id');
        list<PropsWrapper> oppywrappers = new list<PropsWrapper>();
        try{
            list<sObject> oppys = queryOppys(true, oppySOQL, '', set_oppyIds);
            for(sObject obj : oppys){
                PropsWrapper wrapper = convertToOppyPropsWrapper((Opportunity)obj, list_fieldSets, details);
                oppywrappers.add(wrapper);
            }
        }catch(Exception ex){
            system.debug('The following exception has occurred: ' + ex.getMessage());
        }
        mergePropsWrappers(partwrappers, oppywrappers);
        return partwrappers;
    }
    
     /**
    * This method is used to query OppyPart for export
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param interval             string
    @param soqlYearRange        string
    @param oppySOQL             string
    @param pids                 set<string>
    @param set_checkedFcstCacheLabels set<string>
    @param list_fieldSets       list<FieldFilter>
    @param details              list<string> 
    *
    *
    @return list<ForcastWrapper>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    /*public static list<PropsWrapper> asynQueryOppyPartExport(string interval, string soqlYearRange,string oppySOQL,set<string> pids,set<string> set_checkedFcstCacheLabels,list<FieldFilter> list_fieldSets, list<string> details){
        list<PropsWrapper> partwrappers = new list<PropsWrapper>();
        list<sObject> objs = queryOppyParts(true,pids,'');
        if(objs == null || objs.isEmpty())
            return partwrappers;
            
        set<string> set_oppyIds = new set<string>();
        for(sObject obj : objs){
            string oppyId = (string)obj.get('Opportunity__c');
            set_oppyIds.add(oppyId);
            PropsWrapper wrapper = convertToPartPropsWrapper(oppyId, (Opportunity_Part__c)obj,list_fieldSets);
            partwrappers.add(wrapper);
        }
        list<PropsWrapper> oppywrappers = new list<PropsWrapper>();
        try{
            list<sObject> oppys = queryOppys(true,oppySOQL,'',set_oppyIds);
            for(sObject obj : oppys){
                PropsWrapper wrapper = convertToOppyPropsWrapper((Opportunity)obj,list_fieldSets, details);
                oppywrappers.add(wrapper);
            }
        }catch(Exception ex){
            system.debug('The following exception has occurred: ' + ex.getMessage());
        }
        mergePropsWrappers(partwrappers,oppywrappers);
        return partwrappers;
    }*/
    //Export Partner
    /**
    * This method is used to query OppyPartner for export
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param oppySOQL             string
    @param prePartId            string
    @param map_oppyIdCached     map<string,set<string>>
    @param list_fieldSets       list<FieldFilter>
    @param details              list<string> 
    *
    @return list<PropsWrapper>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    /*public static list<PropsWrapper> queryOppyPartnerExport(string oppySOQL, string prePartId, map<string,set<string>> map_oppyIdCached, list<FieldFilter> list_fieldSets, list<string> details){
        list<PropsWrapper> partnerwrappers = new list<PropsWrapper>();
        set<string> oppyIds = map_oppyIdCached.keySet();
        list<sObject> objs = null;
        try{
            objs = queryOppyPartners(true, oppyIds, prePartId);
        }catch(Exception ex){
            system.debug('The following exception has occurred: ' + ex.getMessage());
        }
        if(objs == null || objs.isEmpty())
            return partnerwrappers;
        set<string> set_oppyIds = new set<string>();
        for(sObject obj : objs){
            string oppyId = (string)obj.get('Opportunity__c');
            set_oppyIds.add(oppyId);
            PropsWrapper wrapper = convertToPartnerPropsWrapper(oppyId, (Opportunity_Partner__c)obj, list_fieldSets);
            partnerwrappers.add(wrapper);
        }
        lastExportPartnerId = (string)objs.get(objs.size() - 1).get('Id');
        list<PropsWrapper> oppywrappers = new list<PropsWrapper>();
        try{
            list<sObject> oppys = queryOppys(true,oppySOQL,'',set_oppyIds);
            for(sObject obj : oppys){
                PropsWrapper wrapper = convertToOppyPropsWrapper((Opportunity)obj, list_fieldSets, details);
                oppywrappers.add(wrapper);
            }
        }catch(Exception ex){
            system.debug('The following exception has occurred: ' + ex.getMessage());
        }
        mergePropsWrappers(partnerwrappers,oppywrappers);
        return partnerwrappers;
    }*/
    
    
    /**
    * This method is used to query OppyPartner for export
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param oppySOQL             string
    @param prePartId            string
    @param map_oppyIdCached     map<string,set<string>>
    @param list_fieldSets       list<FieldFilter>
    @param details              list<string> 
    *
    @return list<PropsWrapper>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static String queryOppyPartnerExportNew(String fcstInterval, string oppySOQL, map<string,set<string>> map_oppyIdCached, list<FieldFilter> list_fieldSets, list<string> details, set<string> set_checkedFcstCacheLabels, string soqlYearRange){
        //list<PropsWrapper> partnerwrappers = new list<PropsWrapper>();
        set<string> oppyIds = map_oppyIdCached.keySet();
        list<sObject> objs = null;
        objs = queryOppyPartners(true, oppyIds, '');
        map<String, PartnerResult> map_key_result = new map<String, PartnerResult>();
        if(objs == null || objs.isEmpty() || objs.size() == 0)
            return Json.serialize(map_key_result.values());
        set<string> set_oppyIds = new set<string>();
        
        for(sObject obj : objs){
            string oppyId = (string)obj.get('Opportunity__c');
            if(!set_oppyIds.contains(oppyId)) { set_oppyIds.add(oppyId);}
            
            Opportunity_Partner__c partner = (Opportunity_Partner__c)obj;
            PartnerResult result = new PartnerResult();
            result.oppyId = oppyId;
            result.oppyPartnerId = partner.Id;
            result.allocation = partner.Allocation__c;
            result.map_field_value = new map<String, String>();
            for(FieldFilter filterset : list_fieldSets){
                if(filterset.name.equals(OPPY_PARTNER_DETL)){
                    for(FieldInfo info : filterset.list_fieldInfos){
                        if('DATE'.equalsIgnoreCase(info.dtype) || 'DATETIME'.equalsIgnoreCase(info.dtype)){
                            DateTime dt = (DateTime)partner.get(info.fieldAPI);
                            string value = '';
                            if(dt != null)
                                value = dt.format('yyyy-MM-dd');
                            result.map_field_value.put(info.fieldAPI, value);
                            //wrapper.list_entries.add(info.fieldAPI + OPRAND_EQUALS + value);
                        }else{
                            result.map_field_value.put(info.fieldAPI, (partner.get(info.fieldAPI) == null ? '' : string.valueof(partner.get(info.fieldAPI))));
                            //wrapper.list_entries.add(info.fieldAPI + OPRAND_EQUALS + (partner.get(info.fieldAPI) == null ? '' : partner.get(info.fieldAPI)));
                        }
                    }
                }
            }
            map_key_result.put(result.oppyPartnerId, result);
            
        }

        list<sObject> oppys = queryOppys(true, oppySOQL, '', set_oppyIds);
        
        map<String, sObject> map_oppyid_oppy = new map<String, sObject>();
        
        for(sObject obj : oppys){
            map_oppyid_oppy.put((string)obj.get('Id'), obj);    
        }
        
        for(String partnerId : map_key_result.keySet()) {
            
            PartnerResult result = map_key_result.get(partnerId);
            sObject oppy = map_oppyid_oppy.get(result.oppyId);
            //result.map_field_value = new map<String, String>();
            //result.oppyId = oppy.Id;
            for(FieldFilter filterset : list_fieldSets){
                if(filterset.name.startsWith(OPPY_MDTY)){
                    for(FieldInfo info : filterset.list_fieldInfos){
                        if('DATE'.equalsIgnoreCase(info.dtype) || 'DATETIME'.equalsIgnoreCase(info.dtype)){
                            DateTime dt = (DateTime)oppy.get(info.fieldAPI);
                            string value = '';
                            if(dt != null)
                                value = dt.format('yyyy-MM-dd');
                            result.map_field_value.put(info.fieldAPI, value);
                            //wrapper.list_entries.add(info.fieldAPI + OPRAND_EQUALS + value);
                        }else{
                            result.map_field_value.put(info.fieldAPI, (oppy.get(info.fieldAPI) == null ? '' : string.valueof(oppy.get(info.fieldAPI))));
                            //wrapper.list_entries.add(info.fieldAPI + OPRAND_EQUALS + (oppy.get(info.fieldAPI) == null ? '' : oppy.get(info.fieldAPI)));
                        }
                    }
                }
            }
            for(string fieldsetName : details){
                for(FieldFilter filterset : list_fieldSets){
                    if(filterset.name.equals(fieldsetName)){
                        for(FieldInfo info : filterset.list_fieldInfos){
                            if('DATE'.equalsIgnoreCase(info.dtype) || 'DATETIME'.equalsIgnoreCase(info.dtype)){
                                DateTime dt = (DateTime)oppy.get(info.fieldAPI);
                                string value = '';
                                if(dt != null)
                                    value = dt.format('yyyy-MM-dd');
                                result.map_field_value.put(info.fieldAPI, value);
                                //wrapper.list_entries.add(info.fieldAPI + OPRAND_EQUALS + value);
                            }else{
                                result.map_field_value.put(info.fieldAPI, (oppy.get(info.fieldAPI) == null ? '' : string.valueof(oppy.get(info.fieldAPI))));
                                //wrapper.list_entries.add(info.fieldAPI + OPRAND_EQUALS + (oppy.get(info.fieldAPI) == null ? '' : oppy.get(info.fieldAPI)));
                            }
                        }
                    }
                }
            }
            map_key_result.put(result.oppyPartnerId, result);
            //PropsWrapper wrapper = convertToOppyPropsWrapper((Opportunity)obj, list_fieldSets, details);
            //oppywrappers.add(wrapper);
        }
       
        
        list<sObject> fcobjs = queryOppyFcsts(fcstInterval, '', 0, soqlYearRange, set_oppyIds, map_oppyIdCached, set_checkedFcstCacheLabels);
        
        boolean sf = set_checkedFcstCacheLabels.contains('SF');
        boolean wf = set_checkedFcstCacheLabels.contains(OPPY_FCST_WF);
        boolean wnb = set_checkedFcstCacheLabels.contains(OPPY_FCST_WNB);
        boolean nbf = set_checkedFcstCacheLabels.contains(OPPY_FCST_NBF);
        boolean nps1 = set_checkedFcstCacheLabels.contains(OPPY_FCST_NPS1);
        boolean nps2 = set_checkedFcstCacheLabels.contains(OPPY_FCST_NPS2);
        boolean nps3 = set_checkedFcstCacheLabels.contains(OPPY_FCST_NPS3);
        boolean msg1 = set_checkedFcstCacheLabels.contains(OPPY_FCST_MSG1);//added by nelson zheng 2015-11-04 for case 00897724
        //system.debug('convertToFcstWrappers.set_checkedFcstCacheLabels = ' + set_checkedFcstCacheLabels);
        //string preId;
        //ForcastWrapper wrapper = null;
        
        map<String, map<String, sObject>> map_oppyid_forecast = new map<String, map<String, sObject>>();
        
        for(sObject obj : fcobjs){
            string oppyId = (string) obj.get('Opportunity__c');
            string key = (string) obj.get(OPPY_FSCL_YEAR);
            if(!fcstInterval.containsIgnoreCase(DATE_YEAR_DEF)){
                string quarter = (string) obj.get(OPPY_FSCL_QUTER);
                key += ' ' + convertQuarter(quarter);
            }
            
            map<String, sObject> map_key_forecast = new map<String, sObject>();
            if(map_oppyid_forecast.containsKey(oppyId)) {
                map_key_forecast = map_oppyid_forecast.get(oppyId);
            }
            map_key_forecast.put(key, obj);
            
            map_oppyid_forecast.put(oppyId, map_key_forecast);
        }
           
        for(String partnerId : map_key_result.keySet()) {

            PartnerResult result = map_key_result.get(partnerId);
            map<String, sObject> map_key_forecast = map_oppyid_forecast.get(result.oppyId);
            if(map_key_forecast != null && map_key_forecast.size() > 0){

                for(String key : map_key_forecast.keySet()) {
                    sObject obj = map_key_forecast.get(key);
                    /*string key = (string) obj.get(OPPY_FSCL_YEAR);
                    if(!fcstInterval.containsIgnoreCase(DATE_YEAR_DEF)){
                        string quarter = (string) obj.get(OPPY_FSCL_QUTER);
                        key += ' ' + convertQuarter(quarter);
                    }*/
                    if(sf && obj.get('SF') != null && result.allocation != null) {
                        result.map_field_value.put(key, string.valueof((decimal)obj.get('SF') * result.allocation/100));
                        //wrapper.list_innerDatas.add(key + OPRAND_EQUALS +  string.valueof(obj.get('SF')));
                    }
                    if(wf && obj.get('WF') != null && result.allocation != null) {
                        result.map_field_value.put(key + ' ' + OPPY_FCST_WF, string.valueof((decimal)obj.get('WF') * result.allocation/100));
                        //wrapper.list_innerDatas.add(key + ' ' + OPPY_FCST_WF + OPRAND_EQUALS +  string.valueof(obj.get('WF')));
                    }
                    if(wnb && obj.get('WNB') != null && result.allocation != null) {
                        result.map_field_value.put(key + ' ' + OPPY_FCST_WNB, string.valueof((decimal)obj.get('WNB') * result.allocation/100));
                        //wrapper.list_innerDatas.add(key + ' ' + OPPY_FCST_WNB + OPRAND_EQUALS +  string.valueof(obj.get('WNB')));
                    }
                    if(nbf && obj.get('NBF') != null && result.allocation != null) {
                        result.map_field_value.put(key + ' ' + OPPY_FCST_NBF, string.valueof((decimal)obj.get('NBF') * result.allocation/100));
                        //wrapper.list_innerDatas.add(key + ' ' + OPPY_FCST_NBF + OPRAND_EQUALS +  string.valueof(obj.get('NBF')));
                    }
                    if(nps1 && obj.get(OPPY_FCST_NPS1) != null && result.allocation != null) {
                        result.map_field_value.put(key + ' ' + OPPY_FCST_NPS1, string.valueof((decimal)obj.get(OPPY_FCST_NPS1) * result.allocation/100));
                        //wrapper.list_innerDatas.add(key + ' ' + OPPY_FCST_NPS1 + OPRAND_EQUALS +  string.valueof(obj.get(OPPY_FCST_NPS1)));
                    }
                    if(nps2 && obj.get(OPPY_FCST_NPS2) != null && result.allocation != null) {
                        result.map_field_value.put(key + ' ' + OPPY_FCST_NPS2, string.valueof((decimal)obj.get(OPPY_FCST_NPS2) * result.allocation/100));
                        //wrapper.list_innerDatas.add(key + ' ' + OPPY_FCST_NPS2 + OPRAND_EQUALS +  string.valueof(obj.get(OPPY_FCST_NPS2)));
                    }
                    if(nps3 && obj.get(OPPY_FCST_NPS3) != null && result.allocation != null) {
                        result.map_field_value.put(key + ' ' + OPPY_FCST_NPS3, string.valueof((decimal)obj.get(OPPY_FCST_NPS3) * result.allocation/100));
                        //wrapper.list_innerDatas.add(key + ' ' + OPPY_FCST_NPS3 + OPRAND_EQUALS +  string.valueof(obj.get(OPPY_FCST_NPS3)));
                    }
                    
                    //added by nelson zheng 2015-11-04 for case 00897724
                    if(msg1 && obj.get(OPPY_FCST_MSG1) != null && result.allocation != null) {
                        result.map_field_value.put(key + ' ' + OPPY_FCST_MSG1, string.valueof((decimal)obj.get(OPPY_FCST_MSG1) * result.allocation/100));
                        
                    }
                     
                }
            }
            //wrapper.list_innerDatas.add(innerData);
        }
        system.debug('!@#map_key_result :'+ map_key_result);
        system.debug('!@#map_key_result.size() :'+ map_key_result.size());
        //mergePropsWrappers(partnerwrappers,oppywrappers);
        //return partnerwrappers;
        return Json.serialize(map_key_result.values());
    }
    
    
    /**
    * This method is used to query OppyPartner child
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param oppySOQL             string
    @param prePartId            string
    @param map_oppyIdCached     map<string,set<string>>
    @param list_fieldSets       list<FieldFilter>
    @param details              list<string> 
    *
    @return list<PropsWrapper>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static String existOppyPartnerChildForecast(String fcstInterval, string oppySOQL, map<string,set<string>> map_oppyIdCached, list<FieldFilter> list_fieldSets, list<string> details, set<string> set_checkedFcstCacheLabels, string soqlYearRange){
        //list<PropsWrapper> partnerwrappers = new list<PropsWrapper>();
        set<string> oppyIds = map_oppyIdCached.keySet();
        list<sObject> objs = null;
        objs = queryOppyPartners(true, oppyIds, '');
        map<String, PartnerResult> map_key_result = new map<String, PartnerResult>();
        if(objs == null || objs.isEmpty() || objs.size() == 0)
            return Json.serialize(map_key_result.values());
        set<string> set_oppyIds = new set<string>();
        
        for(sObject obj : objs){
            string oppyId = (string)obj.get('Opportunity__c');
            if(!set_oppyIds.contains(oppyId)) { set_oppyIds.add(oppyId);}
            
            Opportunity_Partner__c partner = (Opportunity_Partner__c)obj;
            PartnerResult result = new PartnerResult();
            result.oppyId = oppyId;
            result.oppyPartnerId = partner.Id;
            result.allocation = partner.Allocation__c;
            result.map_field_value = new map<String, String>();
            for(FieldFilter filterset : list_fieldSets){
                if(filterset.name.equals(OPPY_PARTNER_DETL)){
                    for(FieldInfo info : filterset.list_fieldInfos){
                        if('DATE'.equalsIgnoreCase(info.dtype) || 'DATETIME'.equalsIgnoreCase(info.dtype)){
                            DateTime dt = (DateTime)partner.get(info.fieldAPI);
                            string value = '';
                            if(dt != null)
                                value = dt.format('yyyy-MM-dd');
                            result.map_field_value.put(info.fieldAPI, value);
                            //wrapper.list_entries.add(info.fieldAPI + OPRAND_EQUALS + value);
                        }else{
                            result.map_field_value.put(info.fieldAPI, (partner.get(info.fieldAPI) == null ? '' : string.valueof(partner.get(info.fieldAPI))));
                            //wrapper.list_entries.add(info.fieldAPI + OPRAND_EQUALS + (partner.get(info.fieldAPI) == null ? '' : partner.get(info.fieldAPI)));
                        }
                    }
                }
            }
            map_key_result.put(result.oppyPartnerId, result);
            
        }

        //list<sObject> oppys = queryOppys(true, oppySOQL, '', set_oppyIds);
        
        //map<String, sObject> map_oppyid_oppy = new map<String, sObject>();
        
        //for(sObject obj : oppys){
        //  map_oppyid_oppy.put((string)obj.get('Id'), obj);    
        //}
        /*
        for(String partnerId : map_key_result.keySet()) {
            
            PartnerResult result = map_key_result.get(partnerId);
            sObject oppy = map_oppyid_oppy.get(result.oppyId);
            //result.map_field_value = new map<String, String>();
            //result.oppyId = oppy.Id;
            for(FieldFilter filterset : list_fieldSets){
                if(filterset.name.startsWith(OPPY_MDTY)){
                    for(FieldInfo info : filterset.list_fieldInfos){
                        if('DATE'.equalsIgnoreCase(info.dtype) || 'DATETIME'.equalsIgnoreCase(info.dtype)){
                            DateTime dt = (DateTime)oppy.get(info.fieldAPI);
                            string value = '';
                            if(dt != null)
                                value = dt.format('yyyy-MM-dd');
                            result.map_field_value.put(info.fieldAPI, value);
                            //wrapper.list_entries.add(info.fieldAPI + OPRAND_EQUALS + value);
                        }else{
                            result.map_field_value.put(info.fieldAPI, (oppy.get(info.fieldAPI) == null ? '' : string.valueof(oppy.get(info.fieldAPI))));
                            //wrapper.list_entries.add(info.fieldAPI + OPRAND_EQUALS + (oppy.get(info.fieldAPI) == null ? '' : oppy.get(info.fieldAPI)));
                        }
                    }
                }
            }
            for(string fieldsetName : details){
                for(FieldFilter filterset : list_fieldSets){
                    if(filterset.name.equals(fieldsetName)){
                        for(FieldInfo info : filterset.list_fieldInfos){
                            if('DATE'.equalsIgnoreCase(info.dtype) || 'DATETIME'.equalsIgnoreCase(info.dtype)){
                                DateTime dt = (DateTime)oppy.get(info.fieldAPI);
                                string value = '';
                                if(dt != null)
                                    value = dt.format('yyyy-MM-dd');
                                result.map_field_value.put(info.fieldAPI, value);
                                //wrapper.list_entries.add(info.fieldAPI + OPRAND_EQUALS + value);
                            }else{
                                result.map_field_value.put(info.fieldAPI, (oppy.get(info.fieldAPI) == null ? '' : string.valueof(oppy.get(info.fieldAPI))));
                                //wrapper.list_entries.add(info.fieldAPI + OPRAND_EQUALS + (oppy.get(info.fieldAPI) == null ? '' : oppy.get(info.fieldAPI)));
                            }
                        }
                    }
                }
            }
            map_key_result.put(result.oppyPartnerId, result);
            //PropsWrapper wrapper = convertToOppyPropsWrapper((Opportunity)obj, list_fieldSets, details);
            //oppywrappers.add(wrapper);
        }
        */
        
        list<sObject> fcobjs = queryOppyFcsts(fcstInterval, '', 0, soqlYearRange, set_oppyIds, map_oppyIdCached, set_checkedFcstCacheLabels);
        
        boolean sf = set_checkedFcstCacheLabels.contains('SF');
        boolean wf = set_checkedFcstCacheLabels.contains(OPPY_FCST_WF);
        boolean wnb = set_checkedFcstCacheLabels.contains(OPPY_FCST_WNB);
        boolean nbf = set_checkedFcstCacheLabels.contains(OPPY_FCST_NBF);
        boolean nps1 = set_checkedFcstCacheLabels.contains(OPPY_FCST_NPS1);
        boolean nps2 = set_checkedFcstCacheLabels.contains(OPPY_FCST_NPS2);
        boolean nps3 = set_checkedFcstCacheLabels.contains(OPPY_FCST_NPS3);
        boolean msg1 = set_checkedFcstCacheLabels.contains(OPPY_FCST_MSG1);//added by nelson zheng 2015-11-04 for case 00897724
        //system.debug('convertToFcstWrappers.set_checkedFcstCacheLabels = ' + set_checkedFcstCacheLabels);
        //string preId;
        //ForcastWrapper wrapper = null;
        
        map<String, map<String, sObject>> map_oppyid_forecast = new map<String, map<String, sObject>>();
        
        for(sObject obj : fcobjs){
            string oppyId = (string) obj.get('Opportunity__c');
            string key = (string) obj.get(OPPY_FSCL_YEAR);
            if(!fcstInterval.containsIgnoreCase(DATE_YEAR_DEF)){
                string quarter = (string) obj.get(OPPY_FSCL_QUTER);
                key += ' ' + convertQuarter(quarter);
            }
            
            map<String, sObject> map_key_forecast = new map<String, sObject>();
            if(map_oppyid_forecast.containsKey(oppyId)) {
                map_key_forecast = map_oppyid_forecast.get(oppyId);
            }
            map_key_forecast.put(key, obj);
            
            map_oppyid_forecast.put(oppyId, map_key_forecast);
        }
           
        for(String partnerId : map_key_result.keySet()) {

            PartnerResult result = map_key_result.get(partnerId);
            map<String, sObject> map_key_forecast = map_oppyid_forecast.get(result.oppyId);
            if(map_key_forecast != null && map_key_forecast.size() > 0){

                for(String key : map_key_forecast.keySet()) {
                    sObject obj = map_key_forecast.get(key);
                    /*string key = (string) obj.get(OPPY_FSCL_YEAR);
                    if(!fcstInterval.containsIgnoreCase(DATE_YEAR_DEF)){
                        string quarter = (string) obj.get(OPPY_FSCL_QUTER);
                        key += ' ' + convertQuarter(quarter);
                    }*/
                    if(sf && obj.get('SF') != null && result.allocation != null) {
                        result.map_field_value.put(key, string.valueof((decimal)obj.get('SF') * result.allocation/100));
                        //wrapper.list_innerDatas.add(key + OPRAND_EQUALS +  string.valueof(obj.get('SF')));
                    }
                    if(wf && obj.get('WF') != null && result.allocation != null) {
                        result.map_field_value.put(key + ' ' + OPPY_FCST_WF, string.valueof((decimal)obj.get('WF') * result.allocation/100));
                        //wrapper.list_innerDatas.add(key + ' ' + OPPY_FCST_WF + OPRAND_EQUALS +  string.valueof(obj.get('WF')));
                    }
                    if(wnb && obj.get('WNB') != null && result.allocation != null) {
                        result.map_field_value.put(key + ' ' + OPPY_FCST_WNB, string.valueof((decimal)obj.get('WNB') * result.allocation/100));
                        //wrapper.list_innerDatas.add(key + ' ' + OPPY_FCST_WNB + OPRAND_EQUALS +  string.valueof(obj.get('WNB')));
                    }
                    if(nbf && obj.get('NBF') != null && result.allocation != null) {
                        result.map_field_value.put(key + ' ' + OPPY_FCST_NBF, string.valueof((decimal)obj.get('NBF') * result.allocation/100));
                        //wrapper.list_innerDatas.add(key + ' ' + OPPY_FCST_NBF + OPRAND_EQUALS +  string.valueof(obj.get('NBF')));
                    }
                    if(nps1 && obj.get(OPPY_FCST_NPS1) != null && result.allocation != null) {
                        result.map_field_value.put(key + ' ' + OPPY_FCST_NPS1, string.valueof((decimal)obj.get(OPPY_FCST_NPS1) * result.allocation/100));
                        //wrapper.list_innerDatas.add(key + ' ' + OPPY_FCST_NPS1 + OPRAND_EQUALS +  string.valueof(obj.get(OPPY_FCST_NPS1)));
                    }
                    if(nps2 && obj.get(OPPY_FCST_NPS2) != null && result.allocation != null) {
                        result.map_field_value.put(key + ' ' + OPPY_FCST_NPS2, string.valueof((decimal)obj.get(OPPY_FCST_NPS2) * result.allocation/100));
                        //wrapper.list_innerDatas.add(key + ' ' + OPPY_FCST_NPS2 + OPRAND_EQUALS +  string.valueof(obj.get(OPPY_FCST_NPS2)));
                    }
                    if(nps3 && obj.get(OPPY_FCST_NPS3) != null && result.allocation != null) {
                        result.map_field_value.put(key + ' ' + OPPY_FCST_NPS3, string.valueof((decimal)obj.get(OPPY_FCST_NPS3) * result.allocation/100));
                        //wrapper.list_innerDatas.add(key + ' ' + OPPY_FCST_NPS3 + OPRAND_EQUALS +  string.valueof(obj.get(OPPY_FCST_NPS3)));
                    }
                    
                    //added by nelson zheng 2015-11-04 for case 00897724
                    if(msg1 && obj.get(OPPY_FCST_MSG1) != null && result.allocation != null) {
                        result.map_field_value.put(key + ' ' + OPPY_FCST_MSG1, string.valueof((decimal)obj.get(OPPY_FCST_MSG1) * result.allocation/100));
                        
                    }
                }
            }
            //wrapper.list_innerDatas.add(innerData);
        }
        system.debug('!@#map_key_result :'+ map_key_result);
        system.debug('!@#map_key_result.size() :'+ map_key_result.size());
        //mergePropsWrappers(partnerwrappers,oppywrappers);
        //return partnerwrappers;
        return Json.serialize(map_key_result.values());
    }
    
    
    /**
    * This method is used to query OppyPart child
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param oppySOQL             string
    @param prePartId            string
    @param map_oppyIdCached     map<string,set<string>>
    @param list_fieldSets       list<FieldFilter>
    @param details              list<string> 
    *
    @return list<PropsWrapper>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static String existOppyPartChildForecast(String fcstInterval, string oppySOQL, map<string,set<string>> map_oppyIdCached, list<FieldFilter> list_fieldSets, list<string> details, set<string> set_checkedFcstCacheLabels, string soqlYearRange){
        //list<PropsWrapper> partnerwrappers = new list<PropsWrapper>();
        list<sObject> objs = null;
        set<string> set_allPartIds = new set<string>();
        set<string> oppyIds = map_oppyIdCached.keySet();
        for(string oppyId : oppyIds) {
            set_allPartIds.addAll(map_oppyIdCached.get(oppyId));
        }
        objs = queryOppyParts(true, set_allPartIds, '');
        //objs = queryOppyPartners(true, oppyIds, '');
        map<String, PartnerResult> map_key_result = new map<String, PartnerResult>();
        if(objs == null || objs.isEmpty() || objs.size() == 0)
            return Json.serialize(map_key_result.values());
        set<string> set_oppyIds = new set<string>();
        system.debug('!@#objs :'+objs);
        for(sObject obj : objs){
            string oppyId = (string)obj.get('Opportunity__c');
            if(!set_oppyIds.contains(oppyId)) { set_oppyIds.add(oppyId);}
            
            Opportunity_Part__c part = (Opportunity_Part__c)obj;
            PartnerResult result = new PartnerResult();
            result.oppyId = oppyId;
            result.oppyPartnerId = part.Id;
            //result.allocation = partner.Allocation__c;
            result.map_field_value = new map<String, String>();
            for(FieldFilter filterset : list_fieldSets){
                if(filterset.name.equals(OPPY_PART_DETL)){
                    for(FieldInfo info : filterset.list_fieldInfos){
                        if('DATE'.equalsIgnoreCase(info.dtype) || 'DATETIME'.equalsIgnoreCase(info.dtype)){
                            DateTime dt = (DateTime)part.get(info.fieldAPI);
                            string value = '';
                            if(dt != null)
                                value = dt.format('yyyy-MM-dd');
                            result.map_field_value.put(info.fieldAPI, value);
                            //wrapper.list_entries.add(info.fieldAPI + OPRAND_EQUALS + value);
                        }else{
                            result.map_field_value.put(info.fieldAPI, (part.get(info.fieldAPI) == null ? '' : string.valueof(part.get(info.fieldAPI))));
                            //wrapper.list_entries.add(info.fieldAPI + OPRAND_EQUALS + (partner.get(info.fieldAPI) == null ? '' : partner.get(info.fieldAPI)));
                        }
                    }
                }
            }
            map_key_result.put(result.oppyPartnerId, result);
            
        }
        
        list<sObject> fcobjs = queryOppyPartFcsts(fcstInterval , '', 0, soqlYearRange, set_allPartIds);
        
        boolean sf = set_checkedFcstCacheLabels.contains('SF');
        boolean wf = set_checkedFcstCacheLabels.contains(OPPY_FCST_WF);
        boolean wnb = set_checkedFcstCacheLabels.contains(OPPY_FCST_WNB);
        boolean nbf = set_checkedFcstCacheLabels.contains(OPPY_FCST_NBF);
        boolean nps1 = set_checkedFcstCacheLabels.contains(OPPY_FCST_NPS1);
        boolean nps2 = set_checkedFcstCacheLabels.contains(OPPY_FCST_NPS2);
        boolean nps3 = set_checkedFcstCacheLabels.contains(OPPY_FCST_NPS3);
        boolean msg1 = set_checkedFcstCacheLabels.contains(OPPY_FCST_MSG1);//added by nelson zheng 2015-11-04 for case 00897724
        //system.debug('convertToFcstWrappers.set_checkedFcstCacheLabels = ' + set_checkedFcstCacheLabels);
        //string preId;
        //ForcastWrapper wrapper = null;
        
        map<String, map<String, sObject>> map_oppyid_forecast = new map<String, map<String, sObject>>();
        system.debug('!@#set_checkedFcstCacheLabels :'+set_checkedFcstCacheLabels);
        for(sObject obj : fcobjs){
            string oppyId = (string) obj.get('Part__c');
            string key = (string) obj.get(OPPY_FSCL_YEAR);
            if(!fcstInterval.containsIgnoreCase(DATE_YEAR_DEF)){
                string quarter = (string) obj.get(OPPY_FSCL_QUTER);
                key += ' ' + convertQuarter(quarter);
            }
            map<String, sObject> map_key_forecast = new map<String, sObject>();
            if(map_oppyid_forecast.containsKey(oppyId)) {
                map_key_forecast = map_oppyid_forecast.get(oppyId);
            }
            map_key_forecast.put(key, obj);
            
            map_oppyid_forecast.put(oppyId, map_key_forecast);
        }
           
        for(String partId : map_key_result.keySet()) {

            PartnerResult result = map_key_result.get(partId);
            map<String, sObject> map_key_forecast = map_oppyid_forecast.get(result.oppyPartnerId);
            if(map_key_forecast != null && map_key_forecast.size() > 0){

                for(String key : map_key_forecast.keySet()) {
                    sObject obj = map_key_forecast.get(key);
                    /*string key = (string) obj.get(OPPY_FSCL_YEAR);
                    if(!fcstInterval.containsIgnoreCase(DATE_YEAR_DEF)){
                        string quarter = (string) obj.get(OPPY_FSCL_QUTER);
                        key += ' ' + convertQuarter(quarter);
                    }*/
                    if(sf && obj.get('SF') != null ) {
                        result.map_field_value.put(key, string.valueof((decimal)obj.get('SF')));
                        //wrapper.list_innerDatas.add(key + OPRAND_EQUALS +  string.valueof(obj.get('SF')));
                    }
                    if(wf && obj.get('WF') != null ) {
                        result.map_field_value.put(key + ' ' + OPPY_FCST_WF, string.valueof((decimal)obj.get('WF')));
                        //wrapper.list_innerDatas.add(key + ' ' + OPPY_FCST_WF + OPRAND_EQUALS +  string.valueof(obj.get('WF')));
                    }
                    if(wnb && obj.get('WNB') != null ) {
                        result.map_field_value.put(key + ' ' + OPPY_FCST_WNB, string.valueof((decimal)obj.get('WNB')));
                        //wrapper.list_innerDatas.add(key + ' ' + OPPY_FCST_WNB + OPRAND_EQUALS +  string.valueof(obj.get('WNB')));
                    }
                    if(nbf && obj.get('NBF') != null ) {
                        result.map_field_value.put(key + ' ' + OPPY_FCST_NBF, string.valueof((decimal)obj.get('NBF')));
                        //wrapper.list_innerDatas.add(key + ' ' + OPPY_FCST_NBF + OPRAND_EQUALS +  string.valueof(obj.get('NBF')));
                    }
                    if(nps1 && obj.get(OPPY_FCST_NPS1) != null ) {
                        result.map_field_value.put(key + ' ' + OPPY_FCST_NPS1, string.valueof((decimal)obj.get(OPPY_FCST_NPS1)));
                        //wrapper.list_innerDatas.add(key + ' ' + OPPY_FCST_NPS1 + OPRAND_EQUALS +  string.valueof(obj.get(OPPY_FCST_NPS1)));
                    }
                    if(nps2 && obj.get(OPPY_FCST_NPS2) != null ) {
                        result.map_field_value.put(key + ' ' + OPPY_FCST_NPS2, string.valueof((decimal)obj.get(OPPY_FCST_NPS2)));
                        //wrapper.list_innerDatas.add(key + ' ' + OPPY_FCST_NPS2 + OPRAND_EQUALS +  string.valueof(obj.get(OPPY_FCST_NPS2)));
                    }
                    if(nps3 && obj.get(OPPY_FCST_NPS3) != null ) {
                        result.map_field_value.put(key + ' ' + OPPY_FCST_NPS3, string.valueof((decimal)obj.get(OPPY_FCST_NPS3)));
                        //wrapper.list_innerDatas.add(key + ' ' + OPPY_FCST_NPS3 + OPRAND_EQUALS +  string.valueof(obj.get(OPPY_FCST_NPS3)));
                    }
                    
                    //added by nelson zheng 2015-11-04 for case 00897724
                    if(msg1 && obj.get(OPPY_FCST_MSG1) != null ) {
                        result.map_field_value.put(key + ' ' + OPPY_FCST_MSG1, string.valueof((decimal)obj.get(OPPY_FCST_MSG1)));
                        
                    }
                }
            }
            //wrapper.list_innerDatas.add(innerData);
        }
        system.debug('!@#map_key_result :'+ map_key_result);
        system.debug('!@#map_key_result.size() :'+ map_key_result.size());
        //mergePropsWrappers(partnerwrappers,oppywrappers);
        //return partnerwrappers;
        return Json.serialize(map_key_result.values());
    }
    
    
    /**
    * This method is used to query OppyPart for export
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param interval             string
    @param soqlYearRange        string
    @param oppySOQL             string
    @param pids                 set<string>
    @param set_checkedFcstCacheLabels set<string>
    @param list_fieldSets       list<FieldFilter>
    @param details              list<string> 
    *
    *
    @return list<ForcastWrapper>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    /*public static list<PropsWrapper> asynQueryOppyPartnerExport(string interval, string soqlYearRange,string oppySOQL,set<string> pnids,set<string> set_checkedFcstCacheLabels,list<FieldFilter> list_fieldSets, list<string> details){
        list<PropsWrapper> partnerwrappers = new list<PropsWrapper>();
        
        list<sObject> objs = queryOppyPartners(true,pnids,'');
        if(objs == null || objs.isEmpty())
            return partnerwrappers;
        set<string> set_oppyIds = new set<string>();
        for(sObject obj : objs){
            string oppyId = (string)obj.get('Opportunity__c');
            set_oppyIds.add(oppyId);
            PropsWrapper wrapper = convertToPartnerPropsWrapper(oppyId, (Opportunity_Partner__c)obj,list_fieldSets);
            partnerwrappers.add(wrapper);
        }
        list<PropsWrapper> oppywrappers = new list<PropsWrapper>();
        try{
            list<sObject> oppys = queryOppys(true,oppySOQL,'',set_oppyIds);
            for(sObject obj : oppys){
                PropsWrapper wrapper = convertToOppyPropsWrapper((Opportunity)obj,list_fieldSets, details);
                oppywrappers.add(wrapper);
            }
        }catch(Exception ex){
            system.debug('The following exception has occurred: ' + ex.getMessage());
        }
        mergePropsWrappers(partnerwrappers,oppywrappers);
        return partnerwrappers;
    }*/
    /**
    * This method is used to merge props wrapper
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param wrappers             list<PropsWrapper>
    @param oppywrappers         list<PropsWrapper>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static void mergePropsWrappers(list<PropsWrapper> wrappers,list<PropsWrapper> oppywrappers){
        for(PropsWrapper wrapper : wrappers){
            for(PropsWrapper oppywrapper : oppywrappers){
                if(wrapper.oppyId.equals(oppywrapper.oppyId)){
                    list<string> tmplist = new list<string>();
                    tmplist.addAll(wrapper.list_entries);
                    wrapper.list_entries.clear();
                    wrapper.list_entries.addAll(oppywrapper.list_entries);
                    wrapper.list_entries.addAll(tmplist);
                    tmplist.clear();
                    tmplist = null;
                    break;
                }
            }
        }
    }
    /**
    * This method is used to convert to literal quarter
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param literal              string
    *
    @return string
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static string convertQuarter(string literal){
        if(literal.equals('01'))
            return 'Q1';
        if(literal.equals('02'))
            return 'Q2';
        if(literal.equals('03'))
            return 'Q3';
        if(literal.equals('04'))
            return 'Q4';
        return literal;
    }
    /**
    * This method is used to convert to ForcastWrapper object from the sObject
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param bOppyFcst                    boolean
    @param fcstInterval                 string
    @param objs                         list<sObject>
    @param set_checkedFcstCacheLabels   set<string>
    *
    @return list<ForcastWrapper>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static list<ForcastWrapper> convertToFcstWrappers(boolean bOppyFcst,  string fcstInterval, list<sObject> objs,set<string> set_checkedFcstCacheLabels){
        //system.debug('convertToFcstWrappers objs = ' + objs);
        list<ForcastWrapper> wrappers = new list<ForcastWrapper>();
        boolean sf = set_checkedFcstCacheLabels.contains('SF');
        boolean wf = set_checkedFcstCacheLabels.contains(OPPY_FCST_WF);
        boolean wnb = set_checkedFcstCacheLabels.contains(OPPY_FCST_WNB);
        boolean nbf = set_checkedFcstCacheLabels.contains(OPPY_FCST_NBF);
        boolean nps1 = set_checkedFcstCacheLabels.contains(OPPY_FCST_NPS1);
        boolean nps2 = set_checkedFcstCacheLabels.contains(OPPY_FCST_NPS2);
        boolean nps3 = set_checkedFcstCacheLabels.contains(OPPY_FCST_NPS3);
        boolean msg1 = set_checkedFcstCacheLabels.contains(OPPY_FCST_MSG1);//added by nelson zheng 2015-11-04 for case 00897724
        //system.debug('convertToFcstWrappers.set_checkedFcstCacheLabels = ' + set_checkedFcstCacheLabels);
        string preId;
        ForcastWrapper wrapper = null;
        for(sObject obj : objs){
            string id = null;
            string oppyId = id =  (string) obj.get('Opportunity__c');
            if(!bOppyFcst)
                id = (string) obj.get('Part__c');
            if(!id.equals(preId)){
                preId = id;
                wrapper = new ForcastWrapper();
                wrapper.oppyId = oppyId;
                if(!bOppyFcst)
                    wrapper.oppyPartId = id;
                wrappers.add(wrapper);
            }
            /*
            FcstInnnerData innerData = new FcstInnnerData();
            innerData.key = (string) obj.get(OPPY_FSCL_YEAR);
            if(!fcstInterval.containsIgnoreCase(DATE_YEAR_DEF)){
                string quarter = (string) obj.get(OPPY_FSCL_QUTER);
                innerData.key += ' ' + convertQuarter(quarter);
            }*/
            string key = (string) obj.get(OPPY_FSCL_YEAR);
            if(!fcstInterval.containsIgnoreCase(DATE_YEAR_DEF)){
                string quarter = (string) obj.get(OPPY_FSCL_QUTER);
                key += ' ' + convertQuarter(quarter);
            }
            if(sf)
                wrapper.list_innerDatas.add(key + OPRAND_EQUALS +  string.valueof((obj.get('SF') == null ? '' : obj.get('SF'))));
            if(wf)
                wrapper.list_innerDatas.add(key + ' ' + OPPY_FCST_WF + OPRAND_EQUALS +  string.valueof((obj.get('WF') == null ? '' : obj.get('WF'))));
            if(wnb)
                wrapper.list_innerDatas.add(key + ' ' + OPPY_FCST_WNB + OPRAND_EQUALS +  string.valueof((obj.get('WNB') == null ? '' : obj.get('WNB'))));
            if(nbf)
                wrapper.list_innerDatas.add(key + ' ' + OPPY_FCST_NBF + OPRAND_EQUALS +  string.valueof((obj.get('NBF') == null ? '' : obj.get('NBF'))));
            if(nps1)
                wrapper.list_innerDatas.add(key + ' ' + OPPY_FCST_NPS1 + OPRAND_EQUALS +  string.valueof((obj.get(OPPY_FCST_NPS1) == null ? '' : obj.get(OPPY_FCST_NPS1))));
            if(nps2)
                wrapper.list_innerDatas.add(key + ' ' + OPPY_FCST_NPS2 + OPRAND_EQUALS +  string.valueof((obj.get(OPPY_FCST_NPS2) == null ? '' : obj.get(OPPY_FCST_NPS2))));
            if(nps3)
                wrapper.list_innerDatas.add(key + ' ' + OPPY_FCST_NPS3 + OPRAND_EQUALS +  string.valueof((obj.get(OPPY_FCST_NPS3) == null ? '' : obj.get(OPPY_FCST_NPS3))));
            
            //added by nelson zheng 2015-11-04 for case 00897724
            if(msg1)
                wrapper.list_innerDatas.add(key + ' ' + OPPY_FCST_MSG1 + OPRAND_EQUALS +  string.valueof((obj.get(OPPY_FCST_MSG1) == null ? '' : obj.get(OPPY_FCST_MSG1))));
            
            //wrapper.list_innerDatas.add(innerData);
        }
        //system.debug('convertToFcstWrappers wrappers = ' + wrappers);
        return wrappers;
    }
    //****************************Dependency data************************************ 
    /**
    * This method is used to get the dependent filters' domain values
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param pid                  boolean
    @param list_pValues         list<string>
    @param list_ctrlIds         list<string>
    @param map_idToServerWrappers map<String,APLFilterServerWrapper>
    *
    @return map<string,list<APLFilterValue>> 
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static map<string,list<APLFilterValue>> getCtrlValues(string pid, list<string> list_pValues,list<string> list_ctrlIds,map<String,APLFilterServerWrapper> map_idToServerWrappers){
        if(list_ctrlIds == null || list_ctrlIds.isEmpty())
            return null;
        APLFilterServerWrapper pOne = map_idToServerWrappers.get(pid);
        //system.debug('list_pValues ==' + list_pValues);
        //system.debug('pOne.map_labelToReference ==' + pOne.map_labelToReference);
        
        string realValues = '';
        if(!pOne.map_labelToReference.isEmpty()){
            for(string label : list_pValues){
                string rvalue = '';
                LabelRefObject refObj = pOne.map_labelToReference.get(label);
                if(refObj != null){
                    if(string.isEmpty(refObj.value))
                        continue ;
                    rvalue = isInQuotation(refObj.value) ? refObj.value : addQuotation(refObj.value);
                    realValues += rvalue + COMMA;
                }
            }
            if(realValues.endsWith(COMMA)){
                realValues = trimEndWithsToken(realValues,COMMA);
                realValues = isInParenthesis(realValues) ? realValues : addParenthesis(realValues);
            }   
        }
        /*
        if(!string.isEmpty(realValues) && realValues.endsWith(COMMA))
            rvalue = trimEndWithsToken(rvalue,COMMA);
        if(!string.isEmpty(rvalue))
            realValues.add(rvalue);*/
        
        if(string.isEmpty(realValues)){
            for(string pvalue : list_pValues){
                pvalue = isInQuotation(pvalue) ? pvalue : addQuotation(pvalue);
                realValues += pvalue + COMMA;
            }
            if(realValues.endsWith(COMMA)){
                realValues = trimEndWithsToken(realValues,COMMA);
                realValues = isInParenthesis(realValues) ? realValues : addParenthesis(realValues);
            }
        }
        //system.debug('getCtrlValues realValues ' + realValues);
        
        map<string,list<APLFilterValue>> map_fidToListOfCtrlValues = new map<String,list<APLFilterValue>>();
        for(string id : list_ctrlIds){
            APLFilterServerWrapper rightOne = map_idToServerWrappers.get(id);
            if(rightOne == null)
                continue;
            list<APLFilterValue> list_filterValues = dbQueryCtrlValues(realValues,rightOne);
            /*
            if(list_filterValues == null)
                continue;*/
            list<APLFilterValue> real_filterValues = new list<APLFilterValue>();
            if(!rightOne.bReq && PICKLIST_TYPE.equals(rightOne.filterType)){////filterType PICKLIST_TYPE
                real_filterValues.add(NONE_APLFILTER);
            }
            if(list_filterValues != null && !list_filterValues.isEmpty()){
                real_filterValues.addAll(list_filterValues);
            }
            map_fidToListOfCtrlValues.put(id,real_filterValues);
        }
        return map_fidToListOfCtrlValues;
    }
    /**
    * This method is used to get the dependent filters' domain values
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param realValues   boolean
    @param rightOne     list<string>
    *
    @return list<APLFilterValue> 
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static list<APLFilterValue> dbQueryCtrlValues(string realValues, APLFilterServerWrapper rightOne){
        //system.debug('rightOne.soql ==' + rightOne.soql);
        if(rightOne.soql == null)
            return null;
        list<APLFilterValue> list_filterValues = new list<APLFilterValue>();
        string rightSoql = rightOne.soql.replace('($Parent$)', realValues);//'($Parent$)', ':set_masters'
        system.debug('rightSoql =' + rightSoql + '; realValues = ' + realValues);
        try{
            list<String> params = parseParamsMapping(rightOne.paramsmapping);
            if(params == null || params.size() != 2)
            return list_filterValues;
            //system.debug('params = ' + params);
            list<sObject> objs = database.query(rightSoql);
            //system.debug('objs = '+ objs);
            if(objs == null || objs.isEmpty())
                return null;
            for(sObject obj : objs){
                  if(PLM_ID_DEF.equals(params[0]) || PLM_ID_DEF.equals(params[1])){
                    string plmId = (string)obj.get(params[0]);
                    if(plmId != null)
                        plmId = plmId.trim();
                    if(!string.isEmpty(plmId) && plmId.length() == 16){
                        APLFilterValue filterValue = new APLFilterValue();
                        filterValue.label = plmId;
                        filterValue.value = plmId;
                        list_filterValues.add(filterValue);
                    }
                    string plmdst = (string)obj.get(params[1]);
                    if(plmdst != null)
                        plmdst = plmdst.trim();
                    if(!string.isEmpty(plmdst) && plmdst.length() >= 16){
                        plmdst = plmdst.substring(0,16);
                        APLFilterValue filterValue = new  APLFilterValue();
                        filterValue.label = filterValue.value = plmdst;
                        list_filterValues.add(filterValue);
                    }
                }else{
                    APLFilterValue filterValue = new  APLFilterValue();
                    filterValue.label = (String)obj.get(params[0]);
                    filterValue.value = (String)obj.get(params[1]);
                    if(!string.isEmpty(filterValue.label)){
                        list_filterValues.add(filterValue);
                    }
                }
            }
        }catch(Exception ex){
            system.debug('The following exception has occurred: ' + ex.getMessage());
        }
        return list_filterValues;
    }
   //****************************doSearch()************************************ 
   /**
    * This method is the entry for searching
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param userJson                 string
    @param list_cacheFieldFilters   list<FieldFilter>
    @param map_idToFSWrappersClone  map<string,APLFilterServerWrapper>
    @param oppyType                 string
    @param details                  list<string>
    *
    @return string
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static string doSearch(string userJson, list<FieldFilter> list_cacheFieldFilters,map<string,APLFilterServerWrapper> map_idToFSWrappersClone,string oppyType, list<string> details){
        //system.debug('doSearch userJson = ' + userJson);
        //system.debug('doSearch oppyType = ' + oppyType + '; details = ' + details);
        list<APLFilterWrapper> list_UpdatedAPLFilters = getUpdateFilters(userJson);
        map<string,list<APLFilterWrapper>> map_refObjNameTolistOfFilterWrapper = devideFilterOnRefObject(list_UpdatedAPLFilters,map_idToFSWrappersClone);
        
        map<String,String> map_refObjToSQLCondition = processSOQLCondition(list_UpdatedAPLFilters,map_idToFSWrappersClone);
        if(map_refObjToSQLCondition == null || map_refObjToSQLCondition.isEmpty())
            return null;
        system.debug('devideConditions = ' + map_refObjToSQLCondition);
        map_oppyIdToSetOfPartIds = doQueryKeys2(map_refObjToSQLCondition);
        mainSOQL = constructMainSOQL(list_cacheFieldFilters,details);
        processOppyFcstSOQLElements(list_UpdatedAPLFilters,map_idToFSWrappersClone);
        system.debug('mainSOQL = ' + mainSOQL);
        set<string> set_OppyIds = map_oppyIdToSetOfPartIds.keySet();
        if(set_OppyIds == null || set_OppyIds.isEmpty()){
            set_pnIds = new set<string>();
            return '';
        }   
        if(OPPY_PLUS_PARTER_TYPE.equals(oppyType)){
            set_pnIds = getPartnerIds(set_OppyIds);
        }   
        return queryOppyResult(mainSOQL,'',set_OppyIds, list_cacheFieldFilters,details);
    }
   /**
    * This method is used to get all the partner ids belonging to specific oppyIds
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param set<string>  oppyIds
    *
    @return set<String>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static set<String> getPartnerIds(set<string> oppyIds){
        set<string> pids = new set<string>();
        for(Opportunity_Partner__c a : [select id from Opportunity_Partner__c where Opportunity__c in :oppyIds]){
            pids.add(a.id); 
        }
        return pids;
    }
    /**
    * This method is used to reduce the oppy id and oppy part Id range
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param map_refObjToSQLCondition map<String,String>
    *
    @return map<string,set<string>>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    /*
    public static map<string,set<string>> doQueryKeys(map<String,String> map_refObjToSQLCondition){
        
        //step 1
        map<string,set<string>> map_objNameToSetOfIds = new map<string,set<string>>();
        set<string> set_keys = map_refObjToSQLCondition.keySet();
        
        //step 2 process oppy part
        set<string> set_pids = null;
        set<string> set_poids = null;
        string whereCondition = map_refObjToSQLCondition.get('Opportunity_Part__c');
        list<set<string>> list_idsets= queryOppyPartKeys(whereCondition);
        if(list_idsets != null && list_idsets.size() == 2){
            set_pids = list_idsets.get(0);
            set_poids = list_idsets.get(1);
        }else{
            set_pids = new set<string>();
            set_poids = new set<string>();
        }
        map_objNameToSetOfIds.put('Opportunity_Part__c',set_pids);
        //step 2 process oppy
        whereCondition = map_refObjToSQLCondition.get('Opportunity');
        set<string> set_oids = queryOppyKeys(whereCondition,set_poids);
        map_objNameToSetOfIds.put('Opportunity',set_oids);
        
        if(set_oids == null || set_oids.isEmpty())
            return map_objNameToSetOfIds;
        if(set_pids == null || set_pids.isEmpty())
            return map_objNameToSetOfIds;
        
        string soql = 'select id,Opportunity__c from Opportunity_Part__c where id in ($Parts$)  and Opportunity__c in ($set_oids$) ';
        soql = soql.replace('($Parts$)', ' :set_pids').replace('($set_oids$)',' :set_oids');
        map<string,set<string>> map_oppyIdToSetOfOppypartIds = new map<string,set<string>>();
        try{
            sObject[] list_idgroups = database.query(soql);
            if(list_idgroups == null || list_idgroups.isEmpty())
                return map_oppyIdToSetOfOppypartIds;
            for(sObject obj : list_idgroups){
                string oppyId = (string)obj.get('Opportunity__c');
                string oppyPartId = (string)obj.get('id');
                if(map_oppyIdToSetOfOppypartIds.containsKey(oppyId)){
                    map_oppyIdToSetOfOppypartIds.get(oppyId).add(oppyPartId);
                }else{
                    set<string> set_oppypartIds = new set<string>();
                    set_oppypartIds.add(oppyPartId);
                    map_oppyIdToSetOfOppypartIds.put(oppyId,set_oppypartIds);
                }
            }
        }catch(Exception ex){
            system.debug('The following exception has occurred: ' + ex.getMessage());
        }
        system.debug('doQueryKeys soql = ' + soql + '; set_pids = ' + set_pids + '; set_oids = ' + set_oids + '; final oppySize = ' + map_oppyIdToSetOfOppypartIds.size());
        return map_oppyIdToSetOfOppypartIds;
        
    }*/
    
    
    public static map<string,set<string>> doQueryKeys2(map<String,String> map_conditions){
        string pCondition = map_conditions.get('Opportunity_Part__c');
        string oCondition = map_conditions.get('Opportunity');
        string pSOQL = 'select id, Opportunity__c from Opportunity_Part__c ';
        string oppySOQL = 'select id from Opportunity ';
        if(!string.isEmpty(oCondition))
            oppySOQL += ' where ' + oCondition;
        if(!string.isEmpty(pCondition))
            pSOQL += ' where ' + pCondition;
        map<string,set<string>> map_ids = new map<string,set<string>>();
        //added by nelson zheng
        List<sObject> oppList = database.query(oppySOQL);
        Set<Id> oppyIdSet = new Set<Id>();
        if(oppList == null || oppList.isEmpty()){
            return map_ids;
        }else{
            for(sObject obj : oppList){
                Id oppId = (Id)obj.get('Id');
                oppyIdSet.add(oppId);
            }
        }
        
        
        if(pSOQL.containsIgnoreCase(' where ')){
            //pSOQL += ' and Opportunity__c in (' + oppySOQL +')';   
            pSOQL += ' and Opportunity__c in: oppyIdSet';   
        }else{
            //pSOQL += ' where Opportunity__c in (' + oppySOQL +')';
            pSOQL += ' where Opportunity__c in: oppyIdSet';
        }
        System.debug('----------oppySOQL--------------'+oppySOQL);
        System.debug('----------pSOQL--------------'+pSOQL);
        
        try{
            sObject[] groups = database.query(pSOQL);
            if(groups == null || groups.isEmpty())
                return map_ids;
            for(sObject obj : groups){
                string oppyId = (string)obj.get('Opportunity__c');
                string pid = (string)obj.get('id');
                if(map_ids.containsKey(oppyId)){
                    map_ids.get(oppyId).add(pid);
                }else{
                    set<string> set_pids = new set<string>();
                    set_pids.add(pid);
                    map_ids.put(oppyId,set_pids);
                }
            }
        }catch(Exception ex){
            system.debug('The following exception has occurred: ' + ex.getMessage());
        }
        return map_ids;
    }
   /**
    * This method is used to get the oppy Ids or Oppy part Ids
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param table            string
    @param whereCondition   string
    *
    @return set<string>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static list<set<string>> queryOppyPartKeys(string whereCondition){
        list<set<string>> list_idsets = new list<set<string>>();
        string soql = 'select id, Opportunity__c from Opportunity_Part__c where ' + whereCondition;
        list<sObject> objs= null;
        try{
            objs = database.query(soql);
        }catch(Exception ex){
            system.debug('The following exception has occurred: ' + ex.getMessage());
        }
        if(objs == null || objs.isEmpty())
            return list_idsets;
        
        set<string> set_ids = new set<string>();
        set<string> set_oids = new set<string>();
        list_idsets.add(set_ids);
        list_idsets.add(set_oids);
        for(sObject obj : objs){
            string id = (String)obj.get('id');
            set_ids.add(id);
            string oid = (String)obj.get('Opportunity__c');
            set_oids.add(oid);
        }
        system.debug('queryKeys soql = ' + soql + '; set_ids = ' + set_ids);
        return list_idsets;
    }
    
    
    public static set<string> queryOppyKeys(string whereCondition,set<string> poids){
        if(string.isEmpty(whereCondition) || poids.isEmpty())
            return poids;
        
        set<string> set_ids = new set<string>();
        string soql = 'select id from Opportunity  where ' + whereCondition + ' and id in :poids';
        list<sObject> objs= null;
        try{
            objs = database.query(soql);
        }catch(Exception ex){
            system.debug('The following exception has occurred: ' + ex.getMessage());
        }
        if(objs == null || objs.isEmpty())
            return set_ids;
        for(sObject obj : objs){
            string id = (String)obj.get('id');
            set_ids.add(id);
        }
        system.debug('queryKeys soql = ' + soql + '; set_ids = ' + set_ids);
        return set_ids;
    }
   /**
    * This method is used to get the information for forecast query
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param list_UpdatedAPLFilters           list<APLFilterWrapper>
    @param map_idToFSWrappersClone          map<string,APLFilterServerWrapper>
    *
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static void processOppyFcstSOQLElements(list<APLFilterWrapper> list_UpdatedAPLFilters,map<string,APLFilterServerWrapper> map_idToFSWrappersClone){
        if(set_checkedFcstLabels != null)
            set_checkedFcstLabels.clear();
        else
            set_checkedFcstLabels = new set<string>();
        //based on (Result Filter)
        
        set<APLFilterWrapper> updatedFilters = new set<APLFilterWrapper>();
        for(APLFilterWrapper wrapper : list_UpdatedAPLFilters){
            APLFilterServerWrapper serverWrapper = map_idToFSWrappersClone.get(wrapper.id);
            if(serverWrapper != null && serverWrapper.bResult){
                updatedFilters.add(wrapper);
            }   
        }
        for(APLFilterWrapper wrapper : updatedFilters){//List<APLFilterValue> values
            if(wrapper.values == null || wrapper.values.isEmpty())
                continue ;
            if(CHECKBOX_TYPE.equals(wrapper.filterType)
                        && TRUE_DEF.equals(wrapper.values[0].value)
                        && wrapper.filterCategory.equals(FCST_CTGY_DEF)){
                set_checkedFcstLabels.add(wrapper.oppyFcstLabel);
            }
            if(OPPYFCST_SHOW_TYPE_DEF.equals(wrapper.displayName)){
                oppyFcstType = wrapper.values[0].value;
                //record the By or Quater 
            }
            if(OPPYFCST_FISCAL_TYPE_DEF.equals(wrapper.displayName)){
                APLFilterServerWrapper serverWrapper = map_idToFSWrappersClone.get(wrapper.id);
                oppyFcstFiscalRange = '';
                list<string> dates = parseStringValue(wrapper.values[0].value,COLON);//getCustomerDate();
                system.debug('------------wrapper.dates = ' + dates);
                if(dates!= null && dates.size() >=2){
                    oppyFcstFiscalRange = serverWrapper.defClause;
                    string startyear = dates[0];
                    string endyear = dates[1];
                    years = Integer.valueOf(endyear) - Integer.valueOf(startyear) + 1;
                    system.debug('--------startyear = ' + startyear + '; endyear = ' + endyear);
                    oppyFcstFiscalRange = oppyFcstFiscalRange.replace('($startyear$)','\''+startyear+'\'').replace('($endyear$)','\''+endyear+'\'');
                    oppyFcstFiscalRange =  isInParenthesis(oppyFcstFiscalRange) ? oppyFcstFiscalRange : addParenthesis(oppyFcstFiscalRange);
                }
            }
        }
        //system.debug('processOppyFcstSOQLElements set_checkedFcstLabels = ' + set_checkedFcstLabels);
        //system.debug('year = ' + years);
        system.debug('doSearch oppyFcstType = ' + oppyFcstType + '; oppyFcstFiscalRange = ' + oppyFcstFiscalRange);
    }
    /**
    * This method is used to construct the SOQL for searching or exporting based on the filter information
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param list_fieldSets   list<FieldFilter>
    @param details          list<string>
    *
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static string constructMainSOQL(list<FieldFilter> list_fieldSets, list<string> details){
        String query = 'SELECT ';
        set<string> set_apis = new set<string>();
        string querySuffix = ' from Opportunity ';// Id 
        for(FieldFilter filterset : list_fieldSets){
            if(filterset.name.startsWith(OPPY_MDTY)){
                for(FieldInfo info : filterset.list_fieldInfos){
                    query += info.fieldAPI + COMMA;
                    set_apis.add(info.fieldAPI);
                }
            }
        }
        //scene 1: 
        if(details == null || details.isEmpty()){
            if(!set_apis.contains('ID') && !set_apis.contains('Id')
                && !set_apis.contains('iD') && !set_apis.contains('id')){
                    query += ' Id ';
            }
            
            query = trimEndWithsToken(query,COMMA);
            query += querySuffix;
            return query;
        }
        //scene 2: 
        for(string fieldsetName : details){
            for(FieldFilter filterset : list_fieldSets){
                if(filterset.name.equals(fieldsetName)){
                    for(FieldInfo info : filterset.list_fieldInfos){
                        query += info.fieldAPI + COMMA;
                        set_apis.add(info.fieldAPI);
                    }
                }
            }
        }
        if(!set_apis.contains('ID') && !set_apis.contains('Id')
                && !set_apis.contains('iD') && !set_apis.contains('id')){
                    query += ' Id ';
        }
        query = trimEndWithsToken(query,COMMA);
        query += querySuffix;
        return query;   
    }
    /**
    * This method is used to process for main SOQL based on the filters
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param list_UpdatedAPLFilters   list<APLFilterWrapper>
    @param map_idToFSWrappersClone  map<String,APLFilterServerWrapper>
    *
    @return map<String,String> 
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static map<String,String> processSOQLCondition(list<APLFilterWrapper> list_UpdatedAPLFilters, map<String,APLFilterServerWrapper> map_idToFSWrappersClone){
        map<string,list<APLFilterWrapper>> map_refObjNameTolistOfFilterWrapper = devideFilterOnRefObject(list_UpdatedAPLFilters,map_idToFSWrappersClone);
        
        map<String,String> map_refObjToSQLCondition = new map<String,String>();
        set<string> set_string = map_refObjNameTolistOfFilterWrapper.keySet();
        String sql = '';
        for(String refObj : set_string){
            
            String refObjSOQL = generateSQLConditions(map_refObjNameTolistOfFilterWrapper.get(refObj),map_idToFSWrappersClone);
           
            if(!string.isEmpty(refObjSOQL))
                map_refObjToSQLCondition.put(refObj,refObjSOQL);
        }
        return map_refObjToSQLCondition;
    }
    /**
    * This method is used to process for main SOQL based on the filters
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param updatedWrappers          list<APLFilterWrapper>
    @param map_idToFSWrappersClone  map<String,APLFilterServerWrapper>
    *
    @return string
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static string generateSQLConditions(list<APLFilterWrapper> updatedWrappers,map<String,APLFilterServerWrapper> map_idToFSWrappersClone){
        String sql = '';
        if(updatedWrappers == null || updatedWrappers.isEmpty())
            return sql;
        for(APLFilterWrapper wrapper : updatedWrappers){
            string wrapperSOQL = generateSQLCondition(wrapper,map_idToFSWrappersClone);
            //system.debug('generateSQLConditions.wrapperSOQL = ' + wrapperSOQL + ';wrapper.values =' + wrapper.values + '; wrapper.displayName = ' + wrapper.displayName);
            if(string.isEmpty(wrapperSOQL))
                continue;
            
            sql += wrapperSOQL + SQL_AND_TOKEN;
        }
        return trimEndWithsToken(sql,SQL_AND_TOKEN);
    }
    /**
    * This method is used to process for main SOQL based on the filters
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param updatedWrappers          list<APLFilterWrapper>
    @param map_idToFSWrappersClone  map<String,APLFilterServerWrapper>
    *
    @return string
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static string generateSQLCondition(APLFilterWrapper updatedWrapper, map<String,APLFilterServerWrapper> map_idToFSWrappersClone){
        if(updatedWrapper.values == null || updatedWrapper.values.isEmpty())
            return '';
        if(updatedWrapper.values[0].equals(NONE_APLFILTER))
            return '';
        string sql = '';
        boolean bRefs = false;
        set<string> set_values = new set<string>();
        APLFilterServerWrapper serverWrapper = map_idToFSWrappersClone.get(updatedWrapper.id);
        for(APLFilterValue filter : updatedWrapper.values){
            LabelRefObject refObj = serverWrapper.map_labelToReference.get(filter.label);
            if(refObj == null){
                break;
            }
            bRefs = true;
            set_values.add(refObj.value);
            string temp = generateSQLConditionOnLable(updatedWrapper,filter.label,refObj);
            
            system.debug('sqlCondition = ' + temp + '; displayName = ' + updatedWrapper.displayName);
            if(!string.isEmpty(temp))
                sql += temp + SQL_OR_TOKEN;
        }
        if(!string.isEmpty(sql) && sql.endsWith(SQL_OR_TOKEN)){
            sql = trimEndWithsToken(sql,SQL_OR_TOKEN);
            return addParenthesis(sql);//isInParenthesis(sql) ? sql : addParenthesis(sql);
        }
        if(!bRefs){
            for(APLFilterValue filter : updatedWrapper.values){
                set_values.add(filter.value);
            }
        }
        if(!bRefs || string.isEmpty(sql)){
            if(string.isEmpty(serverWrapper.defClause))
                return '';
            if(set_values.isEmpty())
                return '';
            string values = '';
            for(string value : set_values){
                if(string.isEmpty(value))
                    continue;
                value = isInQuotation(value) ? value : addQuotation(value);
                values +=  value + COMMA;
            }
            if(!values.endsWith(COMMA))
                return '';
            values = trimEndWithsToken(values,COMMA);
            values = isInParenthesis(values) ? values : addParenthesis(values);
            //string defSOQL = serverWrapper.defClause.replace('($Values$)', ' :set_values');
            string defSOQL = serverWrapper.defClause.replace('($Values$)', values);
            
            //added be nelson zheng 2015-11-04 for case 00897724
            /*
            if(defSOQL.indexOf('Account.GAMCD__c') > -1){
                
                String gamList = defSOQL.subString(defSOQL.indexOf('(')+1,defSOQL.indexOf(')'));
                String gamSOQL = 'APL_Partner_GAM_Codes__c like ';
                String tmpSOQL = '';
                for(String gamCode : gamList.split(',')){
                    gamCode = gamCode.replace('\'','');
                    tmpSOQL += gamSOQL + '\'%' + gamCode + '%\' OR ';
                }
                System.debug('---------tmpSOQL-------------'+tmpSOQL);
                tmpSOQL = tmpSOQL.subString(0,tmpSOQL.lastIndexOf('OR'));
                defSOQL += ' OR (' + tmpSOQL +')';
                
            }*/
            System.debug('-----------defSOQL------------'+defSOQL);
            sql =  isInParenthesis(defSOQL) ? defSOQL : addParenthesis(defSOQL);
        }
        System.debug('-----------sql------------'+sql);
        return sql; 
    }
    /**
    * This method is used to process for main SOQL based on the filters
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param updatedWrapper           APLFilterWrapper
    @param label                    string
    @param refObj                   LabelRefObject
    *
    @return string
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */ 
    public static string generateSQLConditionOnLable(APLFilterWrapper updatedWrapper,string label,LabelRefObject refObj){
        string ret = '';
        if(updatedWrapper.filterType.equals(DATE_TYPE) 
            && label.equals(CUSTOMER_DATE_TYPE)){
            //system.debug('generateSQLConditionOnLable refObj.conditionSOQL = ' + refObj.conditionSOQL);
            if(onlyReferenceFieldAPI(refObj.conditionSOQL)){
                string dateValue = '';
                for(APLFilterValue filter : updatedWrapper.values){
                    if(filter.label.equals(label)){
                        dateValue = filter.value;
                        break;
                    }
                }
                ret = getCustomerDateSOQL(refObj.conditionSOQL,dateValue,'');
            }
        }else{
            if(onlyReferenceFieldAPI(refObj.conditionSOQL) || string.isEmpty(refObj.conditionSOQL)){
                    ret = '';
            }else{
                ret = refObj.conditionSOQL;
            }
        }
        return string.isEmpty(ret) ? '' : addParenthesis(ret);
    }
    /**
    * This method is used to process for main SOQL based on the filters
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param fieldName            string
    @param customerDate         string
    @param granularity          string
    *
    @return string
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */ 
    @TestVisible
    private static string getCustomerDateSOQL(string fieldName,string customerDate, string granularity){
        string ret = '';
        list<string> dates = getCustomerDate(customerDate);
        if(dates == null || dates.size() != 2)
            return ret;
        string startdate = dates.get(0);
        string enddate = dates.get(1);
        //system.debug('getCustomerDateSOQL startdate='+ startdate+';enddate = ' +enddate);
        if(!startdate.equals('0')){
            DateTime sdt = DateTime.newInstance(Long.valueOf(startdate)).date();
            //ret += fieldName + '> ' + '($startdate$)'  + ' and ';
            //ret = ret.replace('($startdate$)',' :sd');
            if(DATE_YEAR_DEF.equals(granularity)){
                ret += fieldName + '> \'' + sdt.year()  + '\' and ';
            }else{
                ret += fieldName + '> ' + sdt.format('yyyy-MM-dd')  + ' and ';
            }
        }
        if(!enddate.equals('0')){
            DateTime edt = DateTime.newInstance(Long.valueOf(enddate)).date();
            //ret += fieldName + '< ' + '($enddate$)';
            //ret = ret.replace('($enddate$)',' :ed');
            if(DATE_YEAR_DEF.equals(granularity)){
                ret += fieldName + '< \'' + edt.year()  + '\' ';
            }else{
                ret += fieldName + '< ' + edt.format('yyyy-MM-dd');
            }
        }
        if(string.isEmpty(ret))
            return ret;
            
        if(ret.endsWith(SQL_AND_TOKEN))
            ret = trimEndWithsToken(ret,SQL_AND_TOKEN);
        return isInParenthesis(ret) ? ret : addParenthesis(ret);
    }
    /**
    * This method is used to process for main SOQL based on the filters
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param customerDate         string
    *
    @return list<string>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */ 
    public static list<string> getCustomerDate(string customerDate){
        return parseStringValue(customerDate,SEMICOLON);
    }
   /**
    * This method is used to check the soqlCondition
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param conditionSOQL            string
    *
    @return boolean
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */ 
    public static boolean onlyReferenceFieldAPI(String conditionSOQL){//TODO need to check like createDate
        if(conditionSOQL != null){
            if(conditionSOQL.endsWith('__c'))
                return true;
            conditionSOQL = conditionSOQL.trim();
            list<string> strs = parseStringValue(conditionSOQL,' ');
            if(strs!= null && strs.size() == 1)
                return true;
        }
        return false;
    }
    /**
    * Utility method for add the Parenthesis for soql condition
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param soqlCondition            string
    *
    @return string
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */ 
    public static string addParenthesis(string soqlCondition){
        return LEFT_PARENTHESIS + soqlCondition + RIGHT_PARENTHESIS;
    }
   /**
    * Utility method for check whether soqlCondition in the Parenthesis
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param soqlCondition            string
    *
    @return boolean
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static boolean isInParenthesis(string soqlCondition){
        return soqlCondition.startsWith(LEFT_PARENTHESIS) && soqlCondition.endsWith(RIGHT_PARENTHESIS);
    }
    /**
    * Utility method for check whether soqlCondition in the Quotation
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param soqlCondition            string
    *
    @return boolean
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static boolean isInQuotation(string soqlCondition){
        return soqlCondition.startsWith(QUOTATION) && soqlCondition.endsWith(QUOTATION);
    }
    /**
    * Utility method for adding Quotation for soqlCondition
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param soqlCondition            string
    *
    @return string
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static string addQuotation(string soqlCondition){
        return QUOTATION + soqlCondition + QUOTATION;
    }
    /**
    * Utility method for trimming the end specific symbol
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param stringvalue          string
    @param token                string
    *
    @return string
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static string trimEndWithsToken(string stringvalue, string token){
        if(stringvalue.endsWith(token))
            return stringvalue.substring(0,stringvalue.lastIndexOf(token));
        return stringvalue;
    }
    /**
    * Utility method for deviding the APL Filters
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param list_UpdatedAPLFilters           list<APLFilterWrapper>
    @param map_idToFSWrappersClone          map<String,APLFilterServerWrapper>
    *
    @return map<string,list<APLFilterWrapper>>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static map<string,list<APLFilterWrapper>> devideFilterOnRefObject(list<APLFilterWrapper> list_UpdatedAPLFilters,map<String,APLFilterServerWrapper> map_idToFSWrappersClone){
        map<string,list<APLFilterWrapper>> map_refObjNameTolistOfFilterWrapper = new map<string,list<APLFilterWrapper>> ();
        for(APLFilterWrapper wrapper : list_UpdatedAPLFilters){
            if(map_idToFSWrappersClone.get(wrapper.id).bResult || map_idToFSWrappersClone.get(wrapper.id).relatedObject == null)
                continue;
            if(map_refObjNameTolistOfFilterWrapper.containsKey(map_idToFSWrappersClone.get(wrapper.id).relatedObject)){
                map_refObjNameTolistOfFilterWrapper.get(map_idToFSWrappersClone.get(wrapper.id).relatedObject).add(wrapper);
            }else{
                list<APLFilterWrapper> list_filterWrappers = new list<APLFilterWrapper>();
                list_filterWrappers.add(wrapper);
                map_refObjNameTolistOfFilterWrapper.put(map_idToFSWrappersClone.get(wrapper.id).relatedObject,list_filterWrappers);
            }
        }
        return map_refObjNameTolistOfFilterWrapper;
    }
   /**
    * Utility method for getting the updated APL Filters
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param userJson         string
    *
    @return list<APLFilterWrapper>
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static list<APLFilterWrapper> getUpdateFilters(string userJson){
        list<APLFilterWrapper> list_UpdatedAPLFilters = new list<APLFilterWrapper>();
        list<map<String,list<APLFilterWrapper>>> objects = (list<map<String,list<APLFilterWrapper>>>)Json.deserialize(userJson, list<map<String,list<APLFilterWrapper>>>.class);
        for(map<String,list<APLFilterWrapper>> cmap: objects){
            set<String> set_Keys = cmap.keySet();
            for(String key : set_Keys){
                list_UpdatedAPLFilters.addAll(cmap.get(key));
            }
        }
        return list_UpdatedAPLFilters;
    }
   /**
    * Utility method for updating the user's filters' value
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param tid              string
    @param userJson         string
    *
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static void doUpsertUserFilters(string tid, string userJson){
        //userJson = '[{"Opportunity Category":[{"values":[{"value":"IB","label":"IB"}],"userFilterId":null,"relatedObject":"Opportunity_Part__c","relatedField":"BU_profit_center__c","parentField":null,"listDomainValues":[{"value":"A&C","label":"A&C"},{"value":"AER","label":"AER"},{"value":"IB","label":"IB"}],"id":"a3Vc0000000Ob3hEAC","filterType":"Single","filterOrder":1,"filterCategory":"Opportunity Category","displayName":"Opportunity Part profit center"},{"values":[{"value":"Commit;Won","label":"converted"}],"userFilterId":null,"relatedObject":"Opportunity_Part__c","relatedField":"Status__c","parentField":null,"listDomainValues":[{"value":"On Hold; Weak;50/50;Likely;Commit;Won","label":"pending and converted"},{"value":"On Hold; Weak;50/50;Likely","label":"all pending status"},{"value":"Commit;Won","label":"converted"}],"id":"a3Vc0000000Ob3mEAC","filterType":"Single","filterOrder":2,"filterCategory":"Opportunity Category","displayName":"Opportunity Part status"},{"values":[],"userFilterId":null,"relatedObject":"Opportunity_Part__c","relatedField":"Awarded__c","parentField":null,"listDomainValues":[],"id":"a3Vc0000000ObRQEA0","filterType":"Multiple","filterOrder":7,"filterCategory":"Opportunity Category","displayName":"Awarded AF7C"},{"values":[],"userFilterId":null,"relatedObject":"Opportunity_Part__c","relatedField":"BU_profit_center__c","parentField":null,"listDomainValues":[],"id":"a3Vc0000000ObRaEAK","filterType":"Multiple","filterOrder":8,"filterCategory":"Opportunity Category","displayName":"BU profit center"},{"values":[],"userFilterId":null,"relatedObject":"Opportunity_Part__c","relatedField":"NDR_Award_Type_Value__c","parentField":null,"listDomainValues":[],"id":"a3Vc0000000ObRVEA0","filterType":"Multiple","filterOrder":8,"filterCategory":"Opportunity Category","displayName":"Award Type Value AF8C"}]},{"Sales Dimensions":[{"values":[{"value":"005E0000000XwtxIAC","label":"Gregor Scholz"}],"userFilterId":null,"relatedObject":"Opportunity__c","relatedField":"OwnerId","parentField":null,"listDomainValues":[{"value":"005E0000000XjyUIAS","label":"Klaus Klein"},{"value":"005E0000000XwtxIAC","label":"Gregor Scholz"},{"value":"005E0000000XzsVIAS","label":"Jason Lucas"},{"value":"005E0000000Y0H3IAK","label":"Bin Yu"},{"value":"005E00000018QLLIA2","label":"Jan Adelhardt"},{"value":"005E0000001Mmx0IAC","label":"Boyd Xu"},{"value":"005E0000003b5QpIAI","label":"IL HYOUNG CHO"}],"id":"a3Vc0000000Ob3rEAC","filterType":"Multiple","filterOrder":3,"filterCategory":"Sales Dimensions","displayName":"Opportunity Owner"}]},{"Product Dimensions":[{"values":[{"value":"30004","label":"30004"}],"userFilterId":null,"relatedObject":"Opportunity_Part__c","relatedField":"CBC_1_Code__c","parentField":null,"listDomainValues":[{"value":"30004","label":"30004"},{"value":"30007","label":"30007"},{"value":"13453","label":"13453"}],"id":"a3Vc0000000Ob3wEAC","filterType":"Multiple","filterOrder":4,"filterCategory":"Product Dimensions","displayName":"Product Family"},{"values":[{"value":"402","label":"402"},{"value":"890","label":"890"}],"userFilterId":null,"relatedObject":"Opportunity_Part__c","relatedField":"GPL_Name__c","parentField":"a3Vc0000000Ob3wEAC","listDomainValues":[{"value":"F12","label":"F12"},{"value":"AC2","label":"AC2"},{"value":"Y26","label":"Y26"},{"value":"A39","label":"A39"},{"value":"Y56","label":"Y56"},{"value":"890","label":"890"},{"value":"457","label":"457"},{"value":"228","label":"228"},{"value":"402","label":"402"},{"value":"001","label":"001"},{"value":"A52","label":"A52"},{"value":"902","label":"902"}],"id":"a3Vc0000000Ob41EAC","filterType":"Multiple","filterOrder":5,"filterCategory":"Product Dimensions","displayName":"GPL"}]}]';
        //system.debug('userJson = ' + userJson);
        list<APLFilterWrapper> list_UpdatedAPLFilters = getUpdateFilters(userJson);
        list<APL_User_Filter__c> list_OrgFilters = [select Id, Name, Value__c from APL_User_Filter__c where Template__c = :tid];
        if(list_OrgFilters == null || list_OrgFilters.isEmpty()){
            list<APL_User_Filter__c> list_userAPLFilters = new list<APL_User_Filter__c>();
            for(APLFilterWrapper filterWrapper : list_UpdatedAPLFilters){
                APL_User_Filter__c userFilter = new APL_User_Filter__c();
                //userFilter.id = filterWrapper.uid;
                userFilter.APL_Filter__c = filterWrapper.id;
                userFilter.Value__c = format(filterWrapper.filterType,filterWrapper.values);
                userFilter.User__c = UserInfo.getUserId();
                userFilter.Template__c = tid;
                list_userAPLFilters.add(userFilter);
            }
            //system.debug('doUpsertUserFilters userFilter = ' + list_userAPLFilters);
            upsert list_userAPLFilters;
        }else{
            for(APL_User_Filter__c userfilter : list_OrgFilters){
                for(APLFilterWrapper filterWrapper : list_UpdatedAPLFilters){
                    if(userfilter.id.equals(filterWrapper.uid)){
                        userfilter.Value__c = format(filterWrapper.filterType,filterWrapper.values);
                        break;
                    }
                }
            }
            //system.debug('doUpsertUserFilters org userFilter = ' + list_OrgFilters);
            upsert list_OrgFilters;
        }
    }
   /**
    * Utility method for updating template
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param tid              string
    @param oppyType         string
    @param oppyDetails      string
    *
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static void updateTemplate(string tid,string oppyType, string oppyDetails){
        try{
            APL_Oppy_Portal_Template__c template = [select Id, Name, Report_Level__c, Report_Component__c from APL_Oppy_Portal_Template__c where id = :tid limit 1];
            template.Report_Level__c = oppyType;
            template.Report_Component__c = oppyDetails;
            upsert template;
        }catch(Exception ex){
            system.debug('The following exception has occurred: ' + ex.getMessage());
        }
    }
    /**
    * Utility method for updating template
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param tid              string
    @param oppyType         string
    @param oppyDetails      string
    @param userJson         string
    *
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static void doUpdate(string tid,string oppyType, string oppyDetails, string userJson){//
        updateTemplate(tid,oppyType,oppyDetails);
        doUpsertUserFilters(tid,userJson);
    }
    /**
    * Utility method for updating template
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param tid              string
    *
    @return boolean
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static boolean doRemove(string tid){
        boolean bSuccess = false;
        try{
            list<APL_User_Filter__c> userFilters = [select id from APL_User_Filter__c where Template__c = :tid];
            delete userFilters;
            APL_Oppy_Portal_Template__c template = new APL_Oppy_Portal_Template__c(Id = tid);
            delete template;
            bSuccess = true;
        }catch(Exception ex){
            system.debug('The following exception has occurred: ' + ex.getMessage());
        }
        return bSuccess;
    }
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN constanct members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public static final String QUERY_AND = 'and';
    public static final String SEMICOLON =';';
    public static final String QUOTATION ='\'';
    public static final String COLON =':';
    public static final String OPRAND_EQUALS ='=';
    public static final String HYPHEN ='-';
    public static final String LEFT_BRACKET= '[';
    public static final String RIGHT_BRACKET= ']';
    public static final String COMMA= ',';
    public static final String DOT= '.';
    public static final String LEFT_PARENTHESIS = '(';
    public static final String RIGHT_PARENTHESIS = ')';
    public static final String LEFT_CURLY_BRACE = '{';
    public static final String RIGHT_CURLY_BRACE = '}';
    public final static String JSON_GENERIC_NAME = 'name';
    public final static String JSON_GENERIC_VALUE = 'value';
    public final static String SQL_AND_TOKEN = ' and ';
    public final static String SQL_OR_TOKEN = ' or ';
    public final static integer SQL_OPPY_LIMITSIZE = 100;
    public final static integer SQL_EXPT_LIMITSIZE = 1000;
    public final static integer SQL_OPPYPART_LIMITSIZE = 1000;
    public final static integer SQL_OPPYPARTNER_LIMITSIZE = 1000;
    
    
    public final static string DATE_TYPE = 'Date';
    public final static string CHECKBOX_TYPE = 'Checkbox';
    public final static string CUSTOMER_DATE_TYPE = 'Custom Date';
    public final static string PICKLIST_TYPE = 'Picklist';//filterType PICKLIST_TYPE
    public final static string MULT_PICKLIST_TYPE = 'MultiPicklist';
    public final static string TEXT_TYPE = 'Text';
    
    public final static string OPPY_TYPE_DEF = 'Report Level';
    public final static string OPPY_DETLS_DEF = 'Report Component';
    
    public final static string OPPY_TYPE = 'Opportunity';
    public final static string OPPY_PLUS_PART_TYPE = 'Opportunity & Opportunity Part';
    public final static string OPPY_PLUS_PARTER_TYPE = 'Opportunity & Partner details';
    public final static string OPPYFCST_SHOW_TYPE_DEF = 'Forecast display';
    public final static string OPPYFCST_FISCAL_TYPE_DEF = 'Forecast Years selection';
    public final static string DATE_YEAR_DEF = 'Year';
    public final static string DATE_QUARTER_DEF = 'Quarter';
    public final static string FCST_CTGY_DEF = 'Forecast Category';//Forecast Category
    public final static string TRUE_DEF = 'true';
    
    public final static string OPPY_PART_DETL = 'Opportunity Part details';
    public final static string OPPY_PARTNER_DETL = 'Opportunity Partner details';
    public final static string OPPY_MDTY_CLMN= 'Mandatory columns';
    public final static string OPPY_MDTY = 'Mandatory';
    public final static string OPPY_FCST_SF = '';
    public final static string OPPY_FCST_WF = 'Wt';
    public final static string OPPY_FCST_WNB = 'Wt NB';
    public final static string OPPY_FCST_NBF = 'NB';
    public final static string OPPY_FCST_NPS1 = 'NPS1';
    public final static string OPPY_FCST_NPS2 = 'NPS2';
    public final static string OPPY_FCST_NPS3 = 'NPS3';
    public final static string OPPY_FCST_MSG1 = 'MSG1';//added by nelson zheng 2015-11-04 for case 00897724
    public final static string OPPY_FSCL_YEAR = 'Fiscal_Year__c';
    public final static string OPPY_FSCL_QUTER = 'Fiscal_Quarter__c';
    public final static APLFilterValue NONE_APLFILTER = new APLFilterValue('None','None',0);
    public final static string PLM_ID_DEF = 'PLM_Id__c';
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END constanct members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        //
    /**
    *this method is used to parse the domain values and  format 'aa;bb;cc' seperated by ';';
    @author shawn liu
    @created 2015-01-29
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *@param     String  filter
    *
    *@return    List<String>    
    *
    @changelog
    * 2015-01-29 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static list<String> parseStringValue(String values,String smclon){
        list<String> list_values = new list<String>();
        if(values == null)
            return list_values;
        String[] rets = values.split(smclon,-1);
        if(rets == null || rets.isEmpty())
            return list_values;
        for(String ret : rets){
            String realValue = ret.trim();
            if(realValue != null && !realValue.equals(''))
                list_values.add(realValue);
        }
        return list_values;
    }
    /**
    *this method is used to check whether the String is in the list
    @author shawn liu
    @created 2015-01-29
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *@param     String  filter
    *
    *@param     List<String>
    *
    *@return    boolean     
    *
    @changelog
    * 2015-01-29 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    **/
    public static boolean isContainInList(String obj,List<String> list_objects){
        for(String sobj: list_objects){
            if(obj.equals(sobj)){
                return true;
            }    
        }
        return false;
    }
    /**
    * Utility method for formatting user's filters' values
    *
    @author shawn liu
    @created 2015-05-04
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param datatype             string
    @param values               list<APLFilterValue>
    *
    @return string
    *
    @changelog
    * 2015-05-04 shawn liu <shawn.liu.china@itbconsult.com>
    * - Created
    */
    public static String format(string datatype,list<APLFilterValue> values){
        String formatValue = '';
        if(values == null || values.size() == 0)
            return formatValue;
         
        if(datatype.equals(DATE_TYPE) && values != null && !values.isEmpty() && CUSTOMER_DATE_TYPE.equals(values[0].label)){
            formatValue += CUSTOMER_DATE_TYPE + COLON + values[0].value;
            return formatValue;
        }
        for(APLFilterValue value : values){
            formatValue += value.label + APL_ClsMangerAPLUtil.SEMICOLON;
        }
        if(formatValue.endsWith(APL_ClsMangerAPLUtil.SEMICOLON)){
            formatValue = formatValue.substring(0, formatValue.length() - 1);
        }
        return formatValue;
    }
    /**
    * This class is used wrap the info for  APL_Filter__c
    *
    @author    Shawn liu
    @created   2015-05-04
    @version   1.0
    @since     30.0 (Force.com ApiVersion)
    *
    @changelog
    * 2015-05-04 Shawn liu <Shawn.liu.china@itbconsult.com>
    * - Created
    */
    public class APLFilterWrapper implements Comparable{//
        public String id;//filter id,
        public String uid; //user filter id, whether needed?
        public String filterCategory;
        public String displayName;
        public String filterType;
        public integer filterOrder;
        public String pid;
        public String oppyFcstLabel;
        public boolean bReq;
        public String pvalues;//enable by the parent default values
        public List<APLFilterValue> values = new List<APLFilterValue>();
        public List<APLFilterValue> listDomainValues =  new List<APLFilterValue>();

        public void initialize(APL_Filter__c filter){
            this.id = filter.id;
            this.filterCategory = filter.category__c;
            this.displayName = filter.Display_Name__c;
            this.filterType = filter.Type__c;
            this.filterOrder = (integer)filter.Order__c;
            this.pid = filter.APL_Filter__c;
            this.pvalues = filter.Display_by_Parent_value__c;
            this.bReq = filter.Is_Reqired__c;
            this.oppyFcstLabel = filter.Oppy_Forecast_Label_Name__c;
            
            //intilize the user data
            if(filter.APL_User_Filter__r == null || filter.APL_User_Filter__r.isEmpty())
                return ;
            APL_User_Filter__c userFilterValue = filter.APL_User_Filter__r[0];
            system.debug('userFilterValue: ' + userFilterValue);
            this.uid = userFilterValue.id;
            if(filterType.equals(PICKLIST_TYPE) 
                    || filterType.equals(CHECKBOX_TYPE)
                    || filterType.equals(TEXT_TYPE)){
                APLFilterValue filterValue = new APLFilterValue();
                filterValue.value = userFilterValue.Value__c;
                filterValue.label = userFilterValue.Value__c;
                values.add(filterValue);
            }else if(filterType.equals(DATE_TYPE) && !string.isEmpty(userFilterValue.Value__c) && userFilterValue.Value__c.startsWith(CUSTOMER_DATE_TYPE)){
                APLFilterValue filterValue = new APLFilterValue();
                filterValue.label = CUSTOMER_DATE_TYPE;
                list<String> list_values = APL_ClsMangerAPLUtil.parseStringValue(userFilterValue.Value__c,COLON);
                if(list_values != null && list_values.size() == 2){
                    filterValue.value = list_values[1];
                }
                values.add(filterValue);
            }else{
                list<String> list_values = APL_ClsMangerAPLUtil.parseStringValue(userFilterValue.Value__c,SEMICOLON);
                
                for(String value: list_values){
                    APLFilterValue filterValue = new APLFilterValue();
                    filterValue.label = value;
                    filterValue.value = value;
                    values.add(filterValue);
                }
            }
        }
        public Integer compareTo(Object compareTo) {
            APLFilterWrapper obj = (APLFilterWrapper)compareTo;
            if(filterOrder > obj.filterOrder)
                return 1;
            else if(filterOrder < obj.filterOrder)
                return -1;
            else
                return 0;
        }
    }
    /**
    * This class is used wrap the info for  APL_Filter__c and cached on server side
    *
    @author    Shawn liu
    @created   2015-05-04
    @version   1.0
    @since     30.0 (Force.com ApiVersion)
    *
    @changelog
    * 2015-05-04 Shawn liu <Shawn.liu.china@itbconsult.com>
    * - Created
    */
    public class APLFilterServerWrapper{
        public String id;
        public String relatedObject;
        public String relatedField;
        public String soql;
        public boolean bResult;
        public boolean bReq;
        public String filterType;
        public String paramsmapping;
        public String defClause;
        public map<string,LabelRefObject> map_labelToReference = new map<string,LabelRefObject>();
        public void initialize(APL_Filter__c filter){
            this.id = filter.id;
            this.relatedObject = filter.Object__c;
            //this.relatedField = filter.Field_Api_Name__c;
            this.soql = filter.Domain_Values_Soql__c;
            this.bResult = filter.Result_Filter__c;
            this.bReq = filter.Is_Reqired__c;
            this.filterType = filter.Type__c;
            this.paramsmapping = filter.Params_Mapping__c; 
            this.defClause = filter.Default_Clause_SOQL__c;
        }
    }
   /**
    * This class is used to wrap the template
    *
    @author    Shawn liu
    @created   2015-05-04
    @version   1.0
    @since     30.0 (Force.com ApiVersion)
    *
    @changelog
    * 2015-05-04 Shawn liu <Shawn.liu.china@itbconsult.com>
    * - Created
    */
    public class OPPYTemaplate{
        public String label{get;set;}
        public String value{get;set;}
        public String rptLvl{get;set;}
        public String rptCopt{get;set;}
        public Integer hashCode() {
            return label.hashCode() << 32 + value.hashCode();
        }
        public Boolean equals(Object obj) {
            APLFilterValue filterValue = (APLFilterValue)obj;
            if(filterValue.label.equals(label) && filterValue.value.equals(value)){
                return true;
            }
            return false;
        }
    }
    /**
    * This class is used to wrap the field value
    *
    @author    Shawn liu
    @created   2015-05-04
    @version   1.0
    @since     30.0 (Force.com ApiVersion)
    *
    @changelog
    * 2015-05-04 Shawn liu <Shawn.liu.china@itbconsult.com>
    * - Created
    */
    public class APLFilterValue implements Comparable{
        public String label{get;set;}
        public String value{get;set;}
        public integer orderNum{get;set;}
        public APLFilterValue(){
            label = '';
            value = '';
        }
        public APLFilterValue(string tlabel,string tvalue){
            this.label = tlabel;
            this.value = tvalue;
        }
        public APLFilterValue(string tlabel,string tvalue,integer num){
            this.label = tlabel;
            this.value = tvalue;
            this.orderNum = num;
        }
        public Integer hashCode() {
            return label.hashCode() << 32 + value.hashCode();
        }
        public Boolean equals(Object obj) {
            APLFilterValue filterValue = (APLFilterValue)obj;
            if(filterValue.label.equals(label) && filterValue.value.equals(value)){
                return true;
            }

            return false;
        }
        public Integer compareTo(Object compareTo) {
            APLFilterValue obj = (APLFilterValue)compareTo;
            if(this.orderNum == null)
                return -1;
            if(obj.orderNum == null)
                return 1;
            return orderNum - (integer)obj.orderNum;
            /*
            if(filterOrder > obj.filterOrder)
                return 1;
            else if(filterOrder < obj.filterOrder)
                return -1;
            else
                return 0;*/
        }
    }
    
    /**
    * Method to set user locale.
    *
    @author Bin Yuan
    @created 2014-05-30
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-05-30 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void setUserLocale(LocaleConfig localeConfig, String userLocale){
        try{
            localeConfig.locale= userLocale;
            list<String> list_s = localeConfig.locale.split('_');
            localeConfig.locale = list_s[0]+'-'+list_s[1];
        }catch(Exception e){
            localeConfig.locale = 'de-DE';
        }   
        localeConfig.jsPath = '/glob-cultures/cultures/globalize.culture.'+localeConfig.locale+'.js';
    }
    
    
    /**
    * This class is used to wrap the related field information on server side
    *
    @author    Shawn liu
    @created   2015-05-04
    @version   1.0
    @since     30.0 (Force.com ApiVersion)
    *
    @changelog
    * 2015-05-04 Shawn liu <Shawn.liu.china@itbconsult.com>
    * - Created
    */
    public class LabelRefObject{
        public String value;
        public String conditionSOQL;
        public boolean disableChildrenQuery = false;
    }
    
    public class OppyTypeWrappers{
        public string title;
        public list<string> oppyWrappers = new list<string>();
    }
    public class FieldFilter{
        public string  name;
        public string  id;
        public boolean bCheck;
        public list<FieldInfo> list_fieldInfos = new list<FieldInfo>();
    }
    public class FieldInfo{
        public string fieldlabel;
        public string fieldAPI;
        public string dtype;
    }
    public class ForcastWrapper{
        public string oppyId;
        public string oppyPartId;
        /*public list<FcstInnnerData> list_innerDatas = new list<FcstInnnerData>();*/
        public list<string> list_innerDatas = new list<string>();
        
    }
    public class FcstInnnerData{
        //public string key; //2015-Q1
        public list<string> values = new list<string>(); //NPS1 = 2000;NPS2 = 4000 
    }
    public class PropsWrapper{
        public string oppyId;
        public string oppyPartId;
        public string oppyPartnerId;
        public decimal allocation;
        public list<string> list_oppyFcst = new list<string>();//Only work for partner 
        //public string oppyType;//OPPY_TYPE,OPPY_PLUS_PART_TYPE,OPPY_PLUS_PARTER_TYPE
        //public boolean bQuarter;
        public list<string> list_entries = new list<string>();
    }
    
    public class FieldSetInfo{
        public string dtype;
        public string title;//'Oppy type' || 'Oppy details'
        public string mdty;
        public map<string,list<string>> incs = new map<string,list<string>>();
        public map<string,list<string>> incsAPIs = new map<string,list<string>>();
    }
    
    public class Result{
        public string msg = '';
        public boolean bGood = true;
        public list<Object> wrappers;
        public integer taskId = 0;
    }
    
    public class SearchObj {
        public integer taskId {get;set;}
        public string types {get;set;} 
        public string soqlYearRange {get;set;}
        public string querySOQL {get;set;} 
        public string oppyIds {get;set;}
        public list<APL_ClsMangerAPLUtil.FieldFilter> list_fields {get;set;} 
        public list<string> details {get;set;}
        public integer queryYears {get;set;}
        public string yearRangeSOQL {get;set;}
        public map<string,set<string>> mappingIds {get;set;}
        public set<string> set_labels {get;set;}
        public set<String> set_pids {get;set;}
        public list<string> list_oppyIds {get;set;}
        public String startyear {get;set;}
        public String endyear {get;set;}
    }
    
    
    public class PartnerResult {
        public string oppyId {get;set;}
        public string oppyPartnerId {get;set;}
        public decimal allocation {get;set;}
        public map<String, String> map_field_value {get;set;}
    }
    
    /**
     *  Inner class for LocaleConfig
     *
     @author    Bin Yuan
     @created   2014-05-30
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-05-30 Bin Yuan <bin.yuan@itbconsult.com>
     * - Created
     */
    public class LocaleConfig {
        public String locale {get;set;}
        public String jsPath {get;set;}
        
        public LocaleConfig() {}
        
        public LocaleConfig(String locale, String jsPath) {
            this.locale = locale;
            this.jsPath = jsPath;
        }
    }
    
    public class TableColunm {
        public String label {get;set;}
        public String apiName {get;set;}
        public Boolean isFC {get;set;}
        public Boolean iscomponent {get;set;}
        
        public TableColunm() {
            this.label = '';
            this.apiName = '';
            this.isFC = false;
            this.iscomponent = false;
        }
    }
}