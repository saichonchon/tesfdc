/**
 * Controller class for page APL_CtrlManagerAPLFilter
 *
 @author    Shawn liu
 @created   2015-01-29
 @version   1.0
 @since     30.0 (Force.com ApiVersion)
 *
 @changelog
 * 2015-01-29 Shawn liu <Shawn.liu.china@itbconsult.com>
 * - Created
 */
public without sharing  class APL_CtrlManagerAPLFilter {
	
	/*
	* jsonfilters is the one used for page
	*/
	public transient APL_ClsMangerAPLUtil.LocaleConfig lc {get;set;}
	public String jsonfilters{get;set;}
	public String oppytypes{get;set;}
	public String jsonlistfield {get;set;}
	/************************/
	public String jsontemplates{get;set;}
	public String tid{get;set;}
	public String tname{get;set;}
	/************************/
	
	/************************///cache 
	public set<string> set_labels{set;get;}
	public list<APL_ClsMangerAPLUtil.FieldFilter> list_fieldfilters = new list<APL_ClsMangerAPLUtil.FieldFilter>();
	/************************/
	
	/************************///for fieldset setup
	//public transient list<APL_ClsMangerAPLUtil.FieldSetInfo> list_fieldSetInfos{get;set;}
	/************************/
	
	/************************///for doSearch()
	public string oppyType{get;set;}
	public string oppyDetails{get;set;}
	/************************/
	
	/************************///dependency data
	public string pid{get;set;}
	public string pvalues{get;set;}
	public string ctrlIds{get;set;}
	public string ctrlValues{get;set;}
	/************************/
	
	/***********************/
	public string oppylastId{get;set;}//oppyLastId
	public string oppyRst{get;set;}//Oppy resultdata
	public string pRst{get;set;}//Oppy part or partner resultdata
	public transient string pFcstRst {get;set;}//Oppy part or partner forecast resultdata
	public transient string oppyFcstResult{get;set;}//OppyFcst resultdata;
	public string mainSOQL {get;set;}//iterative query
	
	public string oppyId{get;set;}//Oppy part or Partner
	/***********************/
	
	/***********************/
	public string oppyIds {get;set;}
	public string oppyFcstType {get;set;}
	public string oppyFcstYearRange {get;set;}
	public integer queryYears {set;get;}
	/***********************/
	
	/***********************///for loading and export the oppy forecast;
	public string lastFcstOppyId{get;set;}
	public string lastFcstOppyPartId{get;set;}
	public string lastExportOppyId{get;set;}
	public string lastExportPartId{get;set;}
	public string lastExportPartnerId{get;set;}
	public string lastExportPartFcstId{get;set;}
	public string lastExportFcstOppyId{get;set;}
	/***********************/
	
	/***********************///for export
	public transient string oppyExpt{get;set;}
	public transient string oppyFcstExpt{get;set;}
	public transient string oppyPartFcstExpt{get;set;}
	public transient string oppyPartExpt{get;set;}
	public transient string oppyPartnerExpt{get;set;}
	/***********************/
	
	/***********************///for Remote action
	public string labels{get;set;}
	public string fieldFilters{get;set;}
	/***********************/
	
	/***********************///for viewstate reduce
	public transient string mappingIds {get;set;}
	public string tmpmapping{get;set;}
	public transient string jsonidprops {get;set;}
	public string tmpidprops{get;set;}
	public transient string jsonpnids{get;set;}
	/***********************/
	
	public transient String jsonlistcolunm {get;set;}
	public transient String jsonlistchildcolunm {get;set;}
	public transient String jsonexportlistcolunm {get;set;}
	
	//public String jsonsearchobj {get;set;}
	
	public APL_CtrlManagerAPLFilter getThis(){
		return this;
	}
	
	
	public void getCtrlValues(){
		map<String,APL_ClsMangerAPLUtil.APLFilterServerWrapper> map_idToCacheWrappers  = (map<String,APL_ClsMangerAPLUtil.APLFilterServerWrapper>)JSon.deserialize(tmpidprops,map<String,APL_ClsMangerAPLUtil.APLFilterServerWrapper>.class);
		list<string> list_pValues = (list<String>)JSon.deserialize(pvalues,list<string>.class);
		list<string> list_ctrlIds = (list<String>)JSon.deserialize(ctrlIds,list<string>.class);
		system.debug('getCtrlValues pvalues = ' + list_pValues +' ? getCtrlValues ctrlIds = ' + list_ctrlIds + ' ? getCtrlValues PId = ' + pid);
		ctrlValues = Json.serialize(APL_ClsMangerAPLUtil.getCtrlValues(pid, list_pValues, list_ctrlIds, map_idToCacheWrappers));
		tmpidprops = null;
	}
	
	
	
	/**
	@author shawn liu
	@created 2015-01-29
	@version 1.0
	@since 30.0 (Force.com ApiVersion)
	*
	@return 	void
	*
	@changelog
	* 2015-01-29 shawn liu <shawn.liu.china@itbconsult.com>
	* - Created
	*/  	
	
	public APL_CtrlManagerAPLFilter(){
		this.lc = new APL_ClsMangerAPLUtil.LocaleConfig();
		APL_ClsMangerAPLUtil.setUserLocale(this.lc, userInfo.getLocale());
		if(System.currentPageReference().getParameters().get( 'tid' ) != null) 
		tid = System.currentPageReference().getParameters().get( 'tid' ) ;
		System.debug('---------------tid----------------'+tid);
		set_labels = new set<string>();
		initialize();
	}
	
	public void initialize(){
		clear();
		lastExportOppyId = '';
		lastExportPartId = '';
		lastExportPartnerId = '';
		lastExportFcstOppyId = '';
		lastExportPartFcstId = '';
		lastFcstOppyId = '';
		lastFcstOppyPartId = '';
		jsontemplates = '';
		fieldFilters = '';
		//tid = 'a5Nc00000004LuoEAE';
		this.jsonlistcolunm = '{}';
		this.jsonlistchildcolunm = '{}';
		this.jsonexportlistcolunm = '{}';
		APL_ClsMangerAPLUtil.initLoading(tid);
		postInitialize();
	}
	private void clear(){
		list_fieldfilters.clear();
		this.jsonlistfield = '';
		set_labels.clear();
	}
	
	public void postInitialize(){
		if(APL_ClsMangerAPLUtil.list_fieldfilters != null) {
			list_fieldfilters.addAll(APL_ClsMangerAPLUtil.list_fieldfilters);
			this.jsonlistfield = Json.serialize(list_fieldfilters);
		}
		if(APL_ClsMangerAPLUtil.map_idToFSWrappers != null)
			jsonidprops = Json.serialize(APL_ClsMangerAPLUtil.map_idToFSWrappers);
		
		jsonfilters = APL_ClsMangerAPLUtil.jsonfilters;
		oppytypes = APL_ClsMangerAPLUtil.oppytypesjson;
		if(APL_ClsMangerAPLUtil.list_templates != null)
			jsontemplates = Json.serialize(APL_ClsMangerAPLUtil.list_templates);
		if(APL_ClsMangerAPLUtil.list_fieldSetInfosIn != null)
			fieldFilters = Json.serialize(APL_ClsMangerAPLUtil.list_fieldSetInfosIn);
		
		///////////////////////////////////////////////////////////////////////////
		list<APL_ClsMangerAPLUtil.TableColunm> list_colunm  = null;
		list<APL_ClsMangerAPLUtil.TableColunm> list_childcolunm = null;
		list_colunm = new list<APL_ClsMangerAPLUtil.TableColunm>();
		list_childcolunm = new list<APL_ClsMangerAPLUtil.TableColunm>();
		APL_ClsMangerAPLUtil.TableColunm numcolunm = new APL_ClsMangerAPLUtil.TableColunm();
		numcolunm.label = '';
		numcolunm.apiName = 'number';
		list_colunm.add(numcolunm);
		
		String rptLvl = 'Opportunity';
		String rptCopt = '';
		
		for(APL_ClsMangerAPLUtil.OPPYTemaplate fieldobj : APL_ClsMangerAPLUtil.list_templates) {
			if(tid == fieldobj.value) {
				rptLvl = fieldobj.rptLvl;
				rptCopt = fieldobj.rptCopt;
			}
		}
		system.debug('!@#oppytypes = '+oppytypes);
		list<APL_ClsMangerAPLUtil.FieldSetInfo> list_fieldSetInfosIn = (oppytypes == null || oppytypes == '' ? new list<APL_ClsMangerAPLUtil.FieldSetInfo>() :
			(list<APL_ClsMangerAPLUtil.FieldSetInfo>)JSon.deserialize(oppytypes, list<APL_ClsMangerAPLUtil.FieldSetInfo>.class));
		
		for(APL_ClsMangerAPLUtil.FieldSetInfo fieldobj : list_fieldSetInfosIn) {
			if(fieldobj.title == 'Report Level') {
				list<String> list_fields = fieldobj.incs.get(fieldobj.mdty);
				for(integer i = 0; i < fieldobj.incs.get(fieldobj.mdty).size(); i++) {
					APL_ClsMangerAPLUtil.TableColunm oppycolunm = new APL_ClsMangerAPLUtil.TableColunm();
					oppycolunm.label = fieldobj.incs.get(fieldobj.mdty).get(i);
					oppycolunm.apiName = fieldobj.incsAPIs.get(fieldobj.mdty).get(i);
					list_colunm.add(oppycolunm);
				}
			}
		}
		
		if(rptCopt != null && rptCopt != '' && rptCopt != '[]') {
			set<String> rptCopts = new set<String>();
			rptCopts.addALL(rptCopt.split(','));
			
			for(APL_ClsMangerAPLUtil.FieldSetInfo fieldobj : list_fieldSetInfosIn) {
				if(fieldobj.title == 'Report Component') {
					for(String key : rptCopts) {
						list<String> list_filedlabels = fieldobj.incs.get(key);
						list<String> list_filedAPIs = fieldobj.incsAPIs.get(key);
						for(integer i = 0; i < list_filedlabels.size(); i++) {
							APL_ClsMangerAPLUtil.TableColunm oppycolunm = new APL_ClsMangerAPLUtil.TableColunm();
							oppycolunm.label = list_filedlabels.get(i);
							oppycolunm.apiName = list_filedAPIs.get(i);
							oppycolunm.iscomponent = true;
							list_colunm.add(oppycolunm);
						}
					}
				}
			}
		}
		
		if(rptLvl != 'Opportunity') {
			for(APL_ClsMangerAPLUtil.FieldSetInfo fieldobj : list_fieldSetInfosIn) {
				if(fieldobj.title == 'Report Level') {
					list<String> list_filedlabels = fieldobj.incs.get(rptLvl);
					list<String> list_filedAPIs = fieldobj.incsAPIs.get(rptLvl);
					for(integer i = 0; i < list_filedlabels.size(); i++) {
						APL_ClsMangerAPLUtil.TableColunm oppycolunm = new APL_ClsMangerAPLUtil.TableColunm();
						oppycolunm.label = list_filedlabels.get(i);
						oppycolunm.apiName = list_filedAPIs.get(i);
						list_childcolunm.add(oppycolunm);
					}
				}
			}
		}
		
		List<map<String,List<APL_ClsMangerAPLUtil.APLFilterWrapper>>> list_mapofcategoryoflistofAplFilter = (jsonfilters == null || jsonfilters == '' ? new List<map<String,List<APL_ClsMangerAPLUtil.APLFilterWrapper>>>() :
			(List<map<String,List<APL_ClsMangerAPLUtil.APLFilterWrapper>>>)JSon.deserialize(jsonfilters, List<map<String,List<APL_ClsMangerAPLUtil.APLFilterWrapper>>>.class));
		list<Integer> list_years = new list<Integer>();
		map<Integer, String> map_labels = new map<Integer, String>();
		list<String> list_quarter = new list<String>();
		list_quarter.add('');
		for(map<String,List<APL_ClsMangerAPLUtil.APLFilterWrapper>> maps : list_mapofcategoryoflistofAplFilter) {
			if(maps.containsKey('Forecast Category')) {
				for(APL_ClsMangerAPLUtil.APLFilterWrapper filter : maps.get('Forecast Category')) {
					if(filter.displayName == 'Standard Opportunity Forecast' && filter.values.size() > 0 && filter.values.get(0).value == 'true') {
						map_labels.put(0, '');
					}else if (filter.displayName == 'Weighted Forecast' && filter.values.size() > 0 && filter.values.get(0).value == 'true') {
						map_labels.put(1, ' '+APL_ClsMangerAPLUtil.OPPY_FCST_WF);
					}else if (filter.displayName == 'New Business forecast' && filter.values.size() > 0 && filter.values.get(0).value == 'true') {
						map_labels.put(2, ' '+APL_ClsMangerAPLUtil.OPPY_FCST_NBF);
					}else if (filter.displayName == 'Weighted New Business' && filter.values.size() > 0 && filter.values.get(0).value == 'true') {
						map_labels.put(3, ' '+APL_ClsMangerAPLUtil.OPPY_FCST_WNB);
					}else if (filter.displayName == 'NPS1 Forecast' && filter.values.size() > 0 && filter.values.get(0).value == 'true') {
						map_labels.put(4, ' '+APL_ClsMangerAPLUtil.OPPY_FCST_NPS1);
					}else if (filter.displayName == 'NPS2 Forecast' && filter.values.size() > 0 && filter.values.get(0).value == 'true') {
						map_labels.put(5, ' '+APL_ClsMangerAPLUtil.OPPY_FCST_NPS2);
					}else if (filter.displayName == 'NPS3 Forecast' && filter.values.size() > 0 && filter.values.get(0).value == 'true') {
						map_labels.put(6, ' '+APL_ClsMangerAPLUtil.OPPY_FCST_NPS3);
					}else if (filter.displayName == 'Forecast Years selection' && filter.values.size() > 0) {
						String[] years = filter.values.get(0).value.split(':');
						Integer yearcount = Integer.valueOf(years.get(1)) - Integer.valueOf(years.get(0));
						for(integer i=0;i <= yearcount; i++) {
							list_years.add( Integer.valueOf(years.get(0)) + i);
						}
					}else if (filter.displayName == 'Forecast display' && filter.values.size() > 0 && filter.values.get(0).value != 'By Year') {
						list_quarter.clear();
						list_quarter.add(' Q1');
						list_quarter.add(' Q2');
						list_quarter.add(' Q3');
						list_quarter.add(' Q4');
					}
				}
			}
		}
		
		for(Integer year : list_years) {
			for(String quarter : list_quarter) {
				for(integer i =0; i < 7; i++) {
					if(map_labels.containsKey(i)) {
						APL_ClsMangerAPLUtil.TableColunm yearcolunm = new APL_ClsMangerAPLUtil.TableColunm();
						yearcolunm.apiName = yearcolunm.label = string.valueOf(year) + quarter + map_labels.get(i);
						yearcolunm.isFC = true;
						list_colunm.add(yearcolunm);
						if(rptLvl != 'Opportunity') {
							list_childcolunm.add(yearcolunm);
						}
					}
				}
			}
		}
		
		system.debug('!@#list_colunm : '+list_colunm);
		system.debug('!@#list_childcolunm : '+list_childcolunm);
		this.jsonlistcolunm  = Json.serialize(list_colunm);
		this.jsonlistchildcolunm = Json.serialize(list_childcolunm);
	}
	
   /**
	* This method is used to save the filter user created
	*
	@author shawn liu
	@created 2015-01-29
	@version 1.0
	@since 30.0 (Force.com ApiVersion)
	*
	@return 	void
	*
	@changelog
	* 2015-01-29 shawn liu <shawn.liu.china@itbconsult.com>
	* - Created
	*/
    /*commented out by chenchen on 2017-03-06 to create new apex method
     public void doSave(){
		tid = APL_ClsMangerAPLUtil.doSaveAs(tname,oppyType,oppyDetails,jsonfilters);
	}
	
	public void doUpdate(){
		APL_ClsMangerAPLUtil.doUpdate(tid,oppyType,oppyDetails,jsonfilters);
	} 
    */
    //add by chenchen on 2017-03-06
    @RemoteAction
	public static String doSave(String tname,String oppyType,String oppyDetails,String jsonfilters){
        String tid = '';
		tid = APL_ClsMangerAPLUtil.doSaveAs(tname,oppyType,oppyDetails,jsonfilters);
        return tid;
	}
    
	@RemoteAction
	public static void doUpdate(String tid,String oppyType,String oppyDetails,String jsonfilters){
		APL_ClsMangerAPLUtil.doUpdate(tid,oppyType,oppyDetails,jsonfilters);
	}
    
    public static void doRender(){
	}
    //end
	
	public void lazySearch(){
		list<string> details = (list<String>)JSon.deserialize(oppyDetails,list<string>.class);
		map<string,set<string>> map_oppyIdCached =  (map<string,set<string>>)JSon.deserialize(tmpmapping,map<string,set<string>>.class);
		this.oppyRst = APL_ClsMangerAPLUtil.queryOppyResult(mainSOQL,oppylastId,map_oppyIdCached.keySet(),list_fieldfilters,details);
		this.oppylastId = APL_ClsMangerAPLUtil.oppyLastId;
		this.tmpmapping = null;
	}
	
	private void clearBeforeLoading(){
		mainSOQL = '';
		oppyFcstType = '';
		oppyFcstYearRange = '';
		queryYears = 0;
		oppyRst = '';
		oppylastId = '';
		oppyFcstResult = '';
		lastFcstOppyId = '';
		pRst = '';
		pFcstRst ='';
		lastFcstOppyPartId = '';
		set_labels.clear();
	}
	public void doSearch(){
		clearBeforeLoading();
		list<string> details = (list<String>)JSon.deserialize(oppyDetails, list<string>.class);//oppyType oppyDetails
		System.debug('-----------details-------------'+details);
		map<String,APL_ClsMangerAPLUtil.APLFilterServerWrapper> map_idToCacheWrappers = (map<String,APL_ClsMangerAPLUtil.APLFilterServerWrapper>)JSon.deserialize(tmpidprops,map<String,APL_ClsMangerAPLUtil.APLFilterServerWrapper>.class);
		this.oppyRst = APL_ClsMangerAPLUtil.doSearch(jsonfilters, list_fieldfilters, map_idToCacheWrappers, oppyType, details);
		this.mainSOQL = APL_ClsMangerAPLUtil.mainSOQL;
		this.oppyFcstType = APL_ClsMangerAPLUtil.oppyFcstType;
		this.oppyFcstYearRange = APL_ClsMangerAPLUtil.oppyFcstFiscalRange;
		this.oppylastId = APL_ClsMangerAPLUtil.oppyLastId;
		this.queryYears = APL_ClsMangerAPLUtil.years;
		
		if(APL_ClsMangerAPLUtil.set_checkedFcstLabels != null)
			set_labels.addAll(APL_ClsMangerAPLUtil.set_checkedFcstLabels);
		if(APL_ClsMangerAPLUtil.set_pnIds != null)
			jsonpnids = Json.serialize(APL_ClsMangerAPLUtil.set_pnIds);
		
		
		mappingIds = Json.serialize(APL_ClsMangerAPLUtil.map_oppyIdToSetOfPartIds);
		labels = Json.serialize(set_labels);
		tmpidprops = null;
		
		
		system.debug('!@#list_fieldfilters :'+list_fieldfilters);
		system.debug('!@#details :'+details);
		system.debug('!@#oppyType :'+oppyType);
		system.debug('!@#oppyFcstType :'+oppyFcstType);
		system.debug('!@#set_labels :'+set_labels);
		///////////////////////////////////////////////////////////////////////////////////////////////
		list<APL_ClsMangerAPLUtil.TableColunm> list_colunm  = null;
		list<APL_ClsMangerAPLUtil.TableColunm> list_childcolunm = null;
		list<APL_ClsMangerAPLUtil.TableColunm> list_exportcolunm = null;
		list_colunm = new list<APL_ClsMangerAPLUtil.TableColunm>();
		list_childcolunm = new list<APL_ClsMangerAPLUtil.TableColunm>();
		list_exportcolunm = new list<APL_ClsMangerAPLUtil.TableColunm>();
		APL_ClsMangerAPLUtil.TableColunm numcolunm = new APL_ClsMangerAPLUtil.TableColunm();
		numcolunm.label = '';
		numcolunm.apiName = 'number';
		list_colunm.add(numcolunm);
		
		String rptLvl = oppyType;
		//String rptCopt = '';
		//if(details.size() > 0) {
		//	rptCopt = String.join(details, ',');
		//}
		
		/*for(APL_ClsMangerAPLUtil.OPPYTemaplate fieldobj : APL_ClsMangerAPLUtil.list_templates) {
			if(tid == fieldobj.value) {
				rptLvl = fieldobj.rptLvl;
				rptCopt = fieldobj.rptCopt;
			}
		}*/

		list<APL_ClsMangerAPLUtil.FieldSetInfo> list_fieldSetInfosIn = 
			(list<APL_ClsMangerAPLUtil.FieldSetInfo>)JSon.deserialize(oppytypes, list<APL_ClsMangerAPLUtil.FieldSetInfo>.class);
		System.debug('-------------list_fieldSetInfosIn-----------------'+list_fieldSetInfosIn);
		for(APL_ClsMangerAPLUtil.FieldSetInfo fieldobj : list_fieldSetInfosIn) {
			if(fieldobj.title == 'Report Level') {
				list<String> list_fields = fieldobj.incs.get(fieldobj.mdty);
				for(integer i = 0; i < fieldobj.incs.get(fieldobj.mdty).size(); i++) {
					APL_ClsMangerAPLUtil.TableColunm oppycolunm = new APL_ClsMangerAPLUtil.TableColunm();
					oppycolunm.label = fieldobj.incs.get(fieldobj.mdty).get(i);
					oppycolunm.apiName = fieldobj.incsAPIs.get(fieldobj.mdty).get(i);
					list_colunm.add(oppycolunm);
					list_exportcolunm.add(oppycolunm);
				}
			}
		}
		if(details.size() > 0) {
			//set<String> rptCopts = new set<String>();
			//rptCopts.addALL(rptCopt.split(','));
			for(APL_ClsMangerAPLUtil.FieldSetInfo fieldobj : list_fieldSetInfosIn) {
				if(fieldobj.title == 'Report Component') {
					system.debug('!@#fieldobj : '+fieldobj);
					for(String key : details) {
						list<String> list_filedlabels = fieldobj.incs.get(key);
						list<String> list_filedAPIs = fieldobj.incsAPIs.get(key);
						for(integer i = 0; i < list_filedlabels.size(); i++) {
							APL_ClsMangerAPLUtil.TableColunm oppycolunm = new APL_ClsMangerAPLUtil.TableColunm();
							oppycolunm.label = list_filedlabels.get(i);
							oppycolunm.apiName = list_filedAPIs.get(i);
							oppycolunm.iscomponent = true;
							list_colunm.add(oppycolunm);
							list_exportcolunm.add(oppycolunm);
						}
					}
				}
			}
		}
		
		if(rptLvl != 'Opportunity') {
			for(APL_ClsMangerAPLUtil.FieldSetInfo fieldobj : list_fieldSetInfosIn) {
				if(fieldobj.title == 'Report Level') {
					list<String> list_filedlabels = fieldobj.incs.get(rptLvl);
					list<String> list_filedAPIs = fieldobj.incsAPIs.get(rptLvl);
					for(integer i = 0; i < list_filedlabels.size(); i++) {
						APL_ClsMangerAPLUtil.TableColunm oppycolunm = new APL_ClsMangerAPLUtil.TableColunm();
						oppycolunm.label = list_filedlabels.get(i);
						oppycolunm.apiName = list_filedAPIs.get(i);
						list_childcolunm.add(oppycolunm);
						list_exportcolunm.add(oppycolunm);
					}
				}
			}
		}
		
		List<map<String,List<APL_ClsMangerAPLUtil.APLFilterWrapper>>> list_mapofcategoryoflistofAplFilter = 
			(List<map<String,List<APL_ClsMangerAPLUtil.APLFilterWrapper>>>)JSon.deserialize(jsonfilters, List<map<String,List<APL_ClsMangerAPLUtil.APLFilterWrapper>>>.class);
		list<Integer> list_years = new list<Integer>();
		map<Integer, String> map_labels = new map<Integer, String>();
		list<String> list_quarter = new list<String>();
		list_quarter.add('');
		String types = 'By Quarter';
		for(map<String,List<APL_ClsMangerAPLUtil.APLFilterWrapper>> maps : list_mapofcategoryoflistofAplFilter) {
			if(maps.containsKey('Forecast Category')) {
				for(APL_ClsMangerAPLUtil.APLFilterWrapper filter : maps.get('Forecast Category')) {
					if(filter.displayName == 'Standard Opportunity Forecast' && filter.values.size() > 0 && filter.values.get(0).value == 'true') {
						map_labels.put(0, '');
					}else if (filter.displayName == 'Weighted Forecast' && filter.values.size() > 0 && filter.values.get(0).value == 'true') {
						map_labels.put(1, ' '+APL_ClsMangerAPLUtil.OPPY_FCST_WF);
					}else if (filter.displayName == 'New Business forecast' && filter.values.size() > 0 && filter.values.get(0).value == 'true') {
						map_labels.put(2, ' '+APL_ClsMangerAPLUtil.OPPY_FCST_NBF);
					}else if (filter.displayName == 'Weighted New Business' && filter.values.size() > 0 && filter.values.get(0).value == 'true') {
						map_labels.put(3, ' '+APL_ClsMangerAPLUtil.OPPY_FCST_WNB);
					}else if (filter.displayName == 'NPS1 Forecast' && filter.values.size() > 0 && filter.values.get(0).value == 'true') {
						map_labels.put(4, ' '+APL_ClsMangerAPLUtil.OPPY_FCST_NPS1);
					}else if (filter.displayName == 'NPS2 Forecast' && filter.values.size() > 0 && filter.values.get(0).value == 'true') {
						map_labels.put(5, ' '+APL_ClsMangerAPLUtil.OPPY_FCST_NPS2);
					}else if (filter.displayName == 'NPS3 Forecast' && filter.values.size() > 0 && filter.values.get(0).value == 'true') {
						map_labels.put(6, ' '+APL_ClsMangerAPLUtil.OPPY_FCST_NPS3);
					}
					//added by nelson zheng 2015-11-04 for case 00897724
					
					else if (filter.displayName == 'Asia MSG' && filter.values.size() > 0 && filter.values.get(0).value == 'true') {
						map_labels.put(7, ' '+APL_ClsMangerAPLUtil.OPPY_FCST_MSG1);
					}
					
					else if (filter.displayName == 'Forecast Years selection' && filter.values.size() > 0) {
						String[] years = filter.values.get(0).value.split(':');
						Integer yearcount = Integer.valueOf(years.get(1)) - Integer.valueOf(years.get(0));
						for(integer i=0;i <= yearcount; i++) {
							list_years.add( Integer.valueOf(years.get(0)) + i);
						}
					}else if (filter.displayName == 'Forecast display' && filter.values.size() > 0 && oppyFcstType != 'By Year') {
						list_quarter.clear();
						list_quarter.add(' Q1');
						list_quarter.add(' Q2');
						list_quarter.add(' Q3');
						list_quarter.add(' Q4');
					}
				}
			}
		}
		
		for(Integer year : list_years) {
			for(String quarter : list_quarter) {
				for(integer i =0; i < 8; i++) {////changed by nelson zheng 2015-11-04 for case 00897724 7 to 8
					if(map_labels.containsKey(i)) {
						APL_ClsMangerAPLUtil.TableColunm yearcolunm = new APL_ClsMangerAPLUtil.TableColunm();
						yearcolunm.apiName = yearcolunm.label = string.valueOf(year) + quarter + map_labels.get(i);
						yearcolunm.isFC = true;
						APL_ClsMangerAPLUtil.TableColunm exportyearcolunm = new APL_ClsMangerAPLUtil.TableColunm();
						exportyearcolunm.label = string.valueOf(year) + quarter + (map_labels.get(i) == '' ? ' FC' : map_labels.get(i));
						exportyearcolunm.apiName = string.valueOf(year) + quarter + map_labels.get(i);
						exportyearcolunm.isFC = true;
						list_colunm.add(yearcolunm);
						list_exportcolunm.add(exportyearcolunm);
						if(rptLvl != 'Opportunity') {
							list_childcolunm.add(yearcolunm);
						}
					}
				}
			}
		}
		
		this.jsonlistcolunm  = Json.serialize(list_colunm);
		this.jsonlistchildcolunm = Json.serialize(list_childcolunm);
		this.jsonexportlistcolunm = Json.serialize(list_exportcolunm);
		
	}
	public void queryOppyFcst(){
		//system.debug('queryOppyFcst() oppyIds = ' + oppyIds);
		map<string,set<string>> map_oppyIdCached =  (map<string,set<string>>)JSon.deserialize(tmpmapping,map<string,set<string>>.class);
		set<string> set_oppyIds = (set<string>)JSon.deserialize(oppyIds,set<string>.class);
		oppyFcstResult = APL_ClsMangerAPLUtil.queryOppyFcstResult(oppyFcstType,lastFcstOppyId,oppyFcstYearRange,queryYears,set_oppyIds,map_oppyIdCached,set_labels);
		this.lastFcstOppyId = APL_ClsMangerAPLUtil.lastFcstOppyId;
		this.tmpmapping = null;
	}
	public void queryOppyChildrens(){
		/*map<string,set<string>> map_oppyIdCached =  (map<string,set<string>>)JSon.deserialize(tmpmapping,map<string,set<string>>.class);
		if(APL_ClsMangerAPLUtil.OPPY_PLUS_PART_TYPE.equals(oppyType)){
			lastFcstOppyPartId = '';
			pRst = APL_ClsMangerAPLUtil.queryOppyPartResult(oppyId,list_fieldfilters, map_oppyIdCached);
		}else{
			list<APL_ClsMangerAPLUtil.PropsWrapper> wrappers = APL_ClsMangerAPLUtil.queryOppyPartnerResult(oppyId,list_fieldfilters,map_oppyIdCached);
			APL_ClsMangerAPLUtil.ForcastWrapper fcstwrapper = APL_ClsMangerAPLUtil.queryRightOppyFcstResult(oppyFcstType,oppyId, oppyFcstYearRange, set_labels,map_oppyIdCached);
			if(fcstwrapper != null && (wrappers != null && !wrappers.isEmpty())){
				for(APL_ClsMangerAPLUtil.PropsWrapper tmp : wrappers){
					tmp.list_oppyFcst.addAll(fcstwrapper.list_innerDatas);
				}
			}
			pRst = Json.serialize(wrappers);
		}
		this.tmpmapping = null;*/
	}
	public void queryOppyChildrensFcst(){
		/*map<string,set<string>> map_oppyIdCached =  (map<string,set<string>>)JSon.deserialize(tmpmapping,map<string,set<string>>.class);
		if(APL_ClsMangerAPLUtil.OPPY_PLUS_PART_TYPE.equals(oppyType)){
			pFcstRst = APL_ClsMangerAPLUtil.queryOppyPartFcstResult(oppyId,oppyFcstType,lastFcstOppyPartId,queryYears,oppyFcstYearRange, map_oppyIdCached,set_labels);
			this.lastFcstOppyPartId = APL_ClsMangerAPLUtil.lastFcstOppyPartId;
		}
		this.tmpmapping = null;*/
	}
    //commented out by chenchen on 2017-03-06 to create new apex method
	/*public void doTemplateRemove(){
		boolean success = APL_ClsMangerAPLUtil.doRemove(tid);
		tid = null;
		initialize();
	}*/
    //end
    //add by chenchen on 2017-03-06 to Remove template
    @RemoteAction
    public static void doTemplateRemove(String tid){
		boolean success = APL_ClsMangerAPLUtil.doRemove(tid);
		//tid = null;
	}    
    public void doTemplateRemove2Render(){
		tid = null;
		initialize();
	}
    //end
	public void doTemplateSwitch(){
		initialize();
	}
	public void oppyExport(){//
		/*map<string,set<string>> map_oppyIdCached =  (map<string,set<string>>)JSon.deserialize(tmpmapping,map<string,set<string>>.class);
		list<string> details = (list<String>)JSon.deserialize(oppyDetails,list<string>.class);//oppyType oppyDetails
		oppyExpt =  Json.serialize(APL_ClsMangerAPLUtil.queryOppyExport(oppyFcstType, oppyFcstYearRange,mainSOQL, lastExportOppyId, map_oppyIdCached, list_fieldfilters, details));
		this.lastExportOppyId = APL_ClsMangerAPLUtil.lastExportOppyId;
		this.tmpmapping = null;
		system.debug('oppyExport = ' + oppyExpt + '; lastExportOppyId =' + lastExportOppyId);*/
	}
	@RemoteAction
	public static APL_ClsMangerAPLUtil.Result asynOppyExport(integer taskId,string types, string soqlYearRange,string querySOQL, string oppyIds,string filters, list<string> details){
		//set<string> set_oppyIds = (set<string>)JSon.deserialize(oppyIds,set<string>.class);
		//list<APL_ClsMangerAPLUtil.FieldFilter> list_fields = (list<APL_ClsMangerAPLUtil.FieldFilter>)JSon.deserialize(filters,list<APL_ClsMangerAPLUtil.FieldFilter>.class);
		//system.debug('RemoteAction types = ' + types + ';yearRangeSOQL =' + soqlYearRange + ';oppyIds =' + oppyIds + ';list_fields = ' + list_fields);
		APL_ClsMangerAPLUtil.Result ret = new APL_ClsMangerAPLUtil.Result();
		ret.taskId = taskId;
		try{
			//ret.wrappers = APL_ClsMangerAPLUtil.asynQueryOppyExport(types, soqlYearRange,querySOQL, '', set_oppyIds,list_fields, details);
		}catch(Exception ex){
			system.debug('The following exception has occurred: ' + ex.getMessage());
			ret.bGood = false;
			ret.msg = ex.getMessage();
		}
		return ret;
	}
	@RemoteAction
	public static APL_ClsMangerAPLUtil.Result asynOppyPartExport(integer taskId,string types, string soqlYearRange,string querySOQL, list<string> pids,string labels,string filters, list<string> details){
		//set<string> set_labels = (set<string>)JSon.deserialize(labels,set<string>.class);
		//set<string> set_pids = new set<string>(pids);
		//list<APL_ClsMangerAPLUtil.FieldFilter> list_fields = (list<APL_ClsMangerAPLUtil.FieldFilter>)JSon.deserialize(filters,list<APL_ClsMangerAPLUtil.FieldFilter>.class);
		APL_ClsMangerAPLUtil.Result ret = new APL_ClsMangerAPLUtil.Result();
		ret.taskId = taskId;
		try{
			//ret.wrappers = APL_ClsMangerAPLUtil.asynQueryOppyPartExport(types, soqlYearRange,querySOQL,set_pids,set_labels,list_fields, details);
		}catch(Exception ex){
			system.debug('The following exception has occurred: ' + ex.getMessage());
			ret.bGood = false;
			ret.msg = ex.getMessage();
		}
		return ret;
	}
	@RemoteAction
	public static APL_ClsMangerAPLUtil.Result asynOppyPartnerExport(integer taskId,string types, string soqlYearRange,string querySOQL, list<string> pnids,string labels,string filters, list<string> details){
		//set<string> set_labels = (set<string>)JSon.deserialize(labels,set<string>.class);
		//set<string> set_pnids = new set<string>(pnids);
		//list<APL_ClsMangerAPLUtil.FieldFilter> list_fields = (list<APL_ClsMangerAPLUtil.FieldFilter>)JSon.deserialize(filters,list<APL_ClsMangerAPLUtil.FieldFilter>.class);
		APL_ClsMangerAPLUtil.Result ret = new APL_ClsMangerAPLUtil.Result();
		ret.taskId = taskId;
		try{
			//ret.wrappers = APL_ClsMangerAPLUtil.asynQueryOppyPartnerExport(types, soqlYearRange,querySOQL,set_pnids,set_labels,list_fields, details);
		}catch(Exception ex){
			system.debug('The following exception has occurred: ' + ex.getMessage());
			ret.bGood = false;
			ret.msg = ex.getMessage();
		}
		return ret;
	}
	@RemoteAction
	public static APL_ClsMangerAPLUtil.Result oppyFcstExport(integer taskId,string types, integer queryYears,string yearRangeSOQL, list<string> list_oppyIds, string mappingIds, string labels){
		//map<string,set<string>> oppyIdToPIds =  (map<string,set<string>>)JSon.deserialize(mappingIds,map<string,set<string>>.class);
		//set<string> set_labels = (set<string>)JSon.deserialize(labels,set<string>.class);
		//set<string> oppyIds = new set<string>(list_oppyIds);
		//system.debug('RemoteAction oppyFcstExport types = ' + types + '; taskId = '+ taskId + ';queryYears =' + queryYears + ';yearRangeSOQL =' + yearRangeSOQL + ';oppyIds =' + list_oppyIds + ';oppyIdToPIds =' + mappingIds + ';labels =' + labels + ';set_labels = ' + set_labels);
		APL_ClsMangerAPLUtil.Result ret = new APL_ClsMangerAPLUtil.Result();
		ret.taskId = taskId;
		try{
			//ret.wrappers = APL_ClsMangerAPLUtil.queryOppyFcstExport(types,'',queryYears,yearRangeSOQL, oppyIds, oppyIdToPIds, set_labels);
		}catch(Exception ex){
			system.debug('The following exception has occurred: ' + ex.getMessage());
			ret.bGood = false;
			ret.msg = ex.getMessage();
		}
		//system.debug('RemoteAction end oppyFcstExport taskId  = ' + taskId );
		return ret;
	}
	@RemoteAction
	public static APL_ClsMangerAPLUtil.Result oppyPartFcstExport(integer taskId,string types,integer queryYears,string yearRangeSOQL, list<string> list_pids,string labels){
		//system.debug('RemoteAction oppyPartFcstExport types = ' + types + ';taskId ='+ taskId + ';queryYears =' + queryYears + ';yearRangeSOQL =' + yearRangeSOQL + ';pids =' + list_pids + ';labels =' + labels);
		//set<string> set_labels = (set<string>)JSon.deserialize(labels,set<string>.class);
		//set<string> pids = new set<string>(list_pids);
		APL_ClsMangerAPLUtil.Result ret = new APL_ClsMangerAPLUtil.Result();
		ret.taskId = taskId;
		try{
			//ret.wrappers = APL_ClsMangerAPLUtil.queryOppyPartFcstExport(types,'',queryYears,yearRangeSOQL, pids,set_labels);
		}catch(Exception ex){
			system.debug('The following exception has occurred: ' + ex.getMessage());
			ret.bGood = false;
			ret.msg = ex.getMessage();
		}
		return ret;
	}
	public void oppyFcstExport(){//
		/*set<string> set_oppyIds = (set<string>)JSon.deserialize(oppyIds,set<string>.class);
		map<string,set<string>> map_oppyIdCached =  (map<string,set<string>>)JSon.deserialize(tmpmapping,map<string,set<string>>.class);
		oppyFcstExpt = Json.serialize(APL_ClsMangerAPLUtil.queryOppyFcstExport(oppyFcstType,lastExportFcstOppyId,queryYears,oppyFcstYearRange, set_oppyIds, map_oppyIdCached, set_labels));
		this.lastExportFcstOppyId = APL_ClsMangerAPLUtil.lastExportFcstOppyId;
		this.tmpmapping = null;
		system.debug('oppyFcstExport = ' + oppyFcstExpt + '; lastExportFcstOppyId =' + lastExportFcstOppyId);*/
	}
	public void oppyPartFcstExport(){
		/*map<string,set<string>> map_oppyIdCached =  (map<string,set<string>>)JSon.deserialize(tmpmapping,map<string,set<string>>.class);
		set<string> oppyIds = map_oppyIdCached.keySet();
    	set<string> pids = new set<string>();
    	for(string id: oppyIds){
    		pids.addAll(map_oppyIdCached.get(id));
    	}
		oppyPartFcstExpt = Json.serialize(APL_ClsMangerAPLUtil.queryOppyPartFcstExport(oppyFcstType,lastExportPartFcstId,queryYears,oppyFcstYearRange,pids,set_labels));
		this.lastExportPartFcstId = APL_ClsMangerAPLUtil.lastExportPartFcstId;
		this.tmpmapping = null;
		system.debug('oppyPartFcstExport = ' + oppyPartFcstExpt + '; lastExportPartFcstId =' + lastExportPartFcstId);*/
	}
	public void oppyPartExport(){//
		/*system.debug('oppyPartExport details = ' + oppyDetails);
		map<string,set<string>> map_oppyIdCached =  (map<string,set<string>>)JSon.deserialize(tmpmapping,map<string,set<string>>.class);
		list<string> details = (list<String>)JSon.deserialize(oppyDetails,list<string>.class);//oppyType oppyDetails
		oppyPartExpt = Json.serialize(APL_ClsMangerAPLUtil.queryOppyPartExport(oppyFcstType, oppyFcstYearRange,mainSOQL,lastExportPartId,map_oppyIdCached, set_labels,list_fieldfilters,details));
		this.lastExportPartId = APL_ClsMangerAPLUtil.lastExportPartId;
		this.tmpmapping = null;
		system.debug('oppyPartExpt   oppyPartExpt = ' + oppyPartExpt + '; lastExportPartId =' + lastExportPartId);*/
	}
	public void oppyPartnerExport(){
		/*system.debug('oppyPartnerExport details = ' + oppyDetails);
		map<string,set<string>> map_oppyIdCached =  (map<string,set<string>>)JSon.deserialize(tmpmapping,map<string,set<string>>.class);
		list<string> details = (list<String>)JSon.deserialize(oppyDetails,list<string>.class);//oppyType oppyDetails
		oppyPartnerExpt = Json.serialize(APL_ClsMangerAPLUtil.queryOppyPartnerExport(mainSOQL,lastExportPartnerId,map_oppyIdCached,list_fieldfilters, details));
		this.lastExportPartnerId = APL_ClsMangerAPLUtil.lastExportPartnerId;
		this.tmpmapping = null;
		system.debug('oppyPartnerExport   oppyPartnerExpt = ' + oppyPartnerExpt + '; lastExportPartnerId =' + lastExportPartnerId);*/
	}
	public void oppyPartnerFcstExport(){//TODO How to export oppy forecast accordingly.
		/*oppyFcstExport();*/
	}
	
	/**
    * This method is used to query Oppy for export
    *
    @author Lei Tang
    @created 2015-06-30
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @return list<ForcastWrapper>
    *
    @changelog
    * 2015-06-30 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
	@RemoteAction
	@ReadOnly
	public static APL_ClsMangerAPLUtil.Result asynOppyExportNew(String sData){
		
		APL_ClsMangerAPLUtil.SearchObj searchObj = (APL_ClsMangerAPLUtil.SearchObj)JSon.deserialize(sData, APL_ClsMangerAPLUtil.SearchObj.class);

		APL_ClsMangerAPLUtil.Result ret = new APL_ClsMangerAPLUtil.Result();
		ret.taskId = 0;//searchObj.taskId;
		ret.wrappers = APL_ClsMangerAPLUtil.queryOppyExport(searchObj.types, searchObj.soqlYearRange, searchObj.querySOQL, '', searchObj.mappingIds, searchObj.list_fields, searchObj.details);
		return ret;	
	}
	@RemoteAction
	@ReadOnly
	public static APL_ClsMangerAPLUtil.Result oppyFcstExportNew(String sData){

		APL_ClsMangerAPLUtil.SearchObj searchObj = (APL_ClsMangerAPLUtil.SearchObj)JSon.deserialize(sData, APL_ClsMangerAPLUtil.SearchObj.class);

		set<string> oppyIds = searchObj.mappingIds.keySet();
		APL_ClsMangerAPLUtil.Result ret = new APL_ClsMangerAPLUtil.Result();
		ret.taskId = 0;
		ret.wrappers = APL_ClsMangerAPLUtil.queryOppyFcstExport(searchObj.types,'',searchObj.queryYears, searchObj.yearRangeSOQL, oppyIds, searchObj.mappingIds, searchObj.set_labels);

		return ret;
	}
	
	
	/**
    * This method is used to query Oppy Part for export
    *
    @author Lei Tang
    @created 2015-06-30
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @return list<ForcastWrapper>
    *
    @changelog
    * 2015-06-30 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
	@RemoteAction
	@ReadOnly
	public static APL_ClsMangerAPLUtil.Result asynOppyPartExportNew(String sData){
		
		APL_ClsMangerAPLUtil.SearchObj searchObj = (APL_ClsMangerAPLUtil.SearchObj)JSon.deserialize(sData, APL_ClsMangerAPLUtil.SearchObj.class);
		system.debug('!@#searchObj : '+searchObj);
		APL_ClsMangerAPLUtil.Result ret = new APL_ClsMangerAPLUtil.Result();
		ret.taskId = 0;//searchObj.taskId;
		ret.wrappers = APL_ClsMangerAPLUtil.queryOppyPartExport(searchObj.types, searchObj.soqlYearRange, searchObj.querySOQL, '', searchObj.set_pids, searchObj.set_labels, searchObj.list_fields, searchObj.details);
		return ret;	
	}
	@RemoteAction
	@ReadOnly
	public static APL_ClsMangerAPLUtil.Result oppyPartFcstExportNew(String sData){

		APL_ClsMangerAPLUtil.SearchObj searchObj = (APL_ClsMangerAPLUtil.SearchObj)JSon.deserialize(sData, APL_ClsMangerAPLUtil.SearchObj.class);
		system.debug('!@#searchObj : '+searchObj);
		//set<string> oppyIds = searchObj.mappingIds.keySet();
		//set<string> pids = new set<string>();
		//for(String oppyid : searchObj.mappingIds.keySet()) {
		//	pids.addAll(searchObj.mappingIds.get(oppyid));
		//}
		APL_ClsMangerAPLUtil.Result ret = new APL_ClsMangerAPLUtil.Result();
		ret.taskId = 0;
		ret.wrappers = APL_ClsMangerAPLUtil.queryOppyPartFcstExport(searchObj.types, '', searchObj.queryYears, searchObj.yearRangeSOQL, searchObj.set_pids, searchObj.set_labels);

		return ret;
	}
	
	
	/**
    * This method is used to query Oppy Partner for export
    *
    @author Lei Tang
    @created 2015-06-30
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @return list<ForcastWrapper>
    *
    @changelog
    * 2015-06-30 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
	@RemoteAction
	@ReadOnly
	public static String asynOppyPartnerExportNew(String sData){
		APL_ClsMangerAPLUtil.SearchObj searchObj = (APL_ClsMangerAPLUtil.SearchObj)JSon.deserialize(sData, APL_ClsMangerAPLUtil.SearchObj.class);
		
		return APL_ClsMangerAPLUtil.queryOppyPartnerExportNew(searchObj.types, searchObj.querySOQL, searchObj.mappingIds, searchObj.list_fields, searchObj.details, searchObj.set_labels, searchObj.yearRangeSOQL);
		
	}
	
	
	/**
    * This method is used to query Oppy Part Forecast
    *
    @author Lei Tang
    @created 2015-07-02
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @return list<ForcastWrapper>
    *
    @changelog
    * 2015-07-02 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
	@RemoteAction
	@ReadOnly
	public static String existOppyPartChildForecast(String sData) {
		APL_ClsMangerAPLUtil.SearchObj searchObj = (APL_ClsMangerAPLUtil.SearchObj)JSon.deserialize(sData, APL_ClsMangerAPLUtil.SearchObj.class);
		
		return APL_ClsMangerAPLUtil.existOppyPartChildForecast(searchObj.types, searchObj.querySOQL, searchObj.mappingIds, searchObj.list_fields, searchObj.details, searchObj.set_labels, searchObj.yearRangeSOQL);
		
	}
	
	
	/**
    * This method is used to query Oppy Partner Forecast
    *
    @author Lei Tang
    @created 2015-07-02
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @return list<ForcastWrapper>
    *
    @changelog
    * 2015-07-02 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
	@RemoteAction
	@ReadOnly
	public static String existOppyPartnerChildForecast(String sData) {
		APL_ClsMangerAPLUtil.SearchObj searchObj = (APL_ClsMangerAPLUtil.SearchObj)JSon.deserialize(sData, APL_ClsMangerAPLUtil.SearchObj.class);
		
		return APL_ClsMangerAPLUtil.existOppyPartnerChildForecast(searchObj.types, searchObj.querySOQL, searchObj.mappingIds, searchObj.list_fields, searchObj.details, searchObj.set_labels, searchObj.yearRangeSOQL);
		
	}
}