/**
 *  Ctrl class for APL_CtrlForecastbyProduct
 *
 @author    Lei Tang
 @created   2015-05-07
 @version   1.0
 @since     33.0 (Force.com ApiVersion)
 *
 @changelog
 * 2015-05-07 Lei Tang <lei.tang@itbconsult.com>
 * - Created
 */
public without sharing  class APL_CtrlForecastbyProduct  extends APL_CtrlForecastRemoteBase  {
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	public transient APL_ClsEntityType.LocaleConfig lc {get;set;}

	public APL_ClsEntityType.PageConfig pageConf {get; set;}
	
	public transient list<APL_ClsEntityType.DateItem> list_allDateItems {get; set;}
	
	public transient list<APL_ClsEntityType.APLColumn> list_TotalColumns {get;set;}
	public transient list<APL_ClsEntityType.APLColumn> list_Level1Columns {get;set;}
	public transient list<APL_ClsEntityType.APLColumn> list_Level2Columns {get;set;}
	public transient list<APL_ClsEntityType.APLColumn> list_Level3Columns {get;set;}
	public transient list<APL_ClsEntityType.APLColumn> list_Level4Columns {get;set;}
	public transient list<APL_ClsEntityType.APLColumn> list_Level5Columns {get;set;}

	public String jsongrouping {get; set;}
	public transient String otherID {get; set;}
	public String json_rsmTypeList {get; set;}
	public String selectedType {get; set;}
	public String json_savegroup {get; set;}
	public String json_managerUserList {get; set;}
	public String userName {get; set;}
	public String pricePlaces {get; set;}
	public map<String, APL_ClsEntityType.RSMType> map_rsmType {get; set;}
	
	public transient set<String> set_territoryCodes {get; set;}
	
	public transient list<Object> list_RSMGroupingData {get;set;}
	
	public transient list<Object> list_GroupingData {get;set;}

	public APL_Interface.AAPLCtrlService aplService {get;set;}

	{
		
		this.lc = new APL_ClsEntityType.LocaleConfig();
		APL_ClsUtils.setUserLocale(this.lc, userInfo.getLocale());	//set user locale
	}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private ClsAPLEntityTypes.RSMAcctInfo rsmTypeInfo;
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
	public APL_CtrlForecastbyProduct(){
		
		this.otherID = ClsAPLForecastUtil.OTHERACCTID;
		initGrouping();
		
	}
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
	public void refreshData() {
		initRSM();
	}

	

	public APL_CtrlForecastbyProduct getThis(){
		return this;
	}
    
   /**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
	public void initGrouping(){
		try {
			
			this.pageConf = new APL_ClsEntityType.PageConfig();
			this.pageConf.managerId = UserInfo.getUserId();
			this.pageConf.isRender = true;
			this.selectedType = 'Sales Manager';
			this.json_managerUserList = 'true';
			this.json_rsmTypeList = '';
			this.jsongrouping = '';
			this.userName = '';
			this.pricePlaces = APL_ClsUtils.getPricePlaces();
			if(ApexPages.currentPage().getParameters().get('uid') != null) {
				String paramvalue = ApexPages.currentPage().getParameters().get('uid');
				Blob afterblob = EncodingUtil.base64Decode(paramvalue);
				String loginInfo = afterblob.toString();
				
				APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(loginInfo, APL_ClsEntityType.SearchObj.class);
				this.pageConf.managerId = searchOb.userId;
				this.selectedType = APL_ClsUtils.MAP_RSMMANAGERLABEL.get(searchOb.viewMode);
				setRSMType();
				setTerritory();
				initRSM();
			}
			
			/*
			if(ApexPages.currentPage().getParameters().get('uid') != null) {
				String paramvalue = ApexPages.currentPage().getParameters().get('uid');
				Blob afterblob = EncodingUtil.base64Decode(paramvalue);
				String loginInfo = afterblob.toString();
				
				APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(loginInfo, APL_ClsEntityType.SearchObj.class);
				
				this.pageConf.managerId = searchOb.userId;
				this.selectedType = APL_ClsUtils.MAP_RSMMANAGERLABEL.get(searchOb.viewMode);
				system.debug('!@#searchOb : '+ searchOb);
				
				if(!searchOb.isOtherMethod) {
					
					
					searchGroupsAccounts();
					this.userName = '';
				}else if(searchOb.isOtherMethod) {
					this.pageConf.isStop = false;
					this.json_managerUserList = 'false';
					
					viewASUserRSM();
				}
			}*/
			system.debug('!@#this.pageConf.managerId : '+ this.pageConf.managerId);
			system.debug('!@#json_rsmTypeList : '+ this.json_rsmTypeList);
			/*else {
				getUsersOfManagement();
				
				this.list_GroupingData = new list<Object>();
				this.json_rsmTypeList = '';
				this.jsongrouping = '';
				//setRSMType();
			}*/
		} 
		catch(Exception ex) {
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
		}

	}
	
	public void setRSMType() {
		this.map_rsmType = new map<String, APL_ClsEntityType.RSMType>();
		//this.pageConf.isRelay = false;s
		String username = '';
		for(APL_Forecast_Management__c forecastManager : [Select Id, A6_Code__c, Manager__c, AM_Freeze__c, RecordType.DeveloperName, RSM__r.Manager__r.Name
														  From APL_Forecast_Management__c
														  Where RSM__r.Manager__c = :this.pageConf.managerId
														  And A6_Code__c != null
														  And RecordTypeId != null ]) {
														  //And RecordType.DeveloperName = :APL_ClsUtils.MAP_RSMLABEL_MANAGER.get(this.selectedType)
			//this.pageConf.isRelay = (forecastManager.RecordType.DeveloperName == 'Relay' ? true : false);
			this.pageConf.territoryCode = forecastManager.A6_Code__c;	
			this.pageConf.isFrozen = forecastManager.AM_Freeze__c;
			//username = forecastManager.RSM__r.Manager__r.Name;
			APL_ClsEntityType.RSMType remtype = new APL_ClsEntityType.RSMType();
			String clsname = (forecastManager.RecordType.DeveloperName == 'AM' ? 'APL_ClsAMForecastbyProductService' : 'APL_ClsRelayForecastbyProductService');
			String levelname = 'Level';
			for(Integer i = 1; i <= 5;i++) {
				remtype.map_level_name.put(levelname + String.valueOf(i), clsname + '.Search' + levelname + String.valueOf(i));
			}
			if(forecastManager.RecordType.DeveloperName == 'AM') {
				remtype.map_level_name.put(levelname + 'Other', 'APL_ClsAMForecastbyProductService.SearchLevelOther');
			}
			remtype.map_level_name.put('Relay', (forecastManager.RecordType.DeveloperName == 'AM' ? 'false' : 'true'));
			remtype.map_level_name.put(levelname+'total', clsname + '.SearchLevelTotal');
			this.map_rsmType.put(APL_ClsUtils.MAP_RSMMANAGERLABEL.get(forecastManager.RecordType.DeveloperName), remtype);
			
		}
		this.userName = username;
		this.json_rsmTypeList = Json.serialize(this.map_rsmType.get(this.selectedType));
		//this.json_rsmTypeList = Json.serialize(this.map_rsmType);
	}
	
	

	/**
    * This method is used to create a new interface instance
    *
    @author Bin Yuan
    @created 2014-06-02
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-02 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public APL_Interface.AAPLCtrlService newCtrlInstance(String className){
        try{
            Type t = Type.forName(className);
            return (APL_Interface.AAPLCtrlService) t.newInstance();
        }catch(Exception e){
            throw e;
        }
    }
	
   	/**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
	public void setList_allDateItems(){
		this.list_allDateItems = new list<APL_ClsEntityType.DateItem>();
		this.aplService.setAllDateItems(this.pageConf, this.list_allDateItems);
	}
	
	
	/**
    * This method is used to get level 1 OEM data.
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
	public void setList_RSMGroupingData(){
		this.list_RSMGroupingData = new list<Object>();
		aplService.setLevel1Data(this.list_RSMGroupingData, this.pageConf);
	}
	
	
	/**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
	public void setTotalColumns(){
		this.list_TotalColumns = new list<APL_ClsEntityType.APLColumn>();
		this.aplService.setTotalRow(this.list_TotalColumns, this.pageConf);
		system.debug('@#list_TotalColumns: '+this.list_TotalColumns);
	}
	
	
	
	
	/**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
	public void setLevel1Columns(){
		this.list_Level1Columns = new list<APL_ClsEntityType.APLColumn>();
		this.aplService.setLevel1Row(this.list_Level1Columns);
	}
	
	
	/**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
	public void setLevel2Columns(){
		this.list_Level2Columns = new list<APL_ClsEntityType.APLColumn>();
		this.aplService.setLevel2Row(this.list_Level2Columns);
	}
	
	
   	/**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
	public void setLevel3Columns(){
		this.list_Level3Columns = new list<APL_ClsEntityType.APLColumn>();
		this.aplService.setLevel3Row(this.list_Level3Columns);
	}
	
   /**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
	public void setLevel4Columns(){
		this.list_Level4Columns = new list<APL_ClsEntityType.APLColumn>();
		this.aplService.setLevel4Row(this.list_Level4Columns);
	}

	/**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
	public void setLevel5Columns(){
		this.list_Level5Columns = new list<APL_ClsEntityType.APLColumn>();
		this.aplService.setLevel5Row(this.list_Level5Columns);
	}
	
	/**
    * This method is used to init page parms
    *
    @author Bin Yuan
    @created 2014-03-27
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-27 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public void searchGroupsAccounts() {
		setTerritory();
		system.debug('!@#pageconf:'+this.pageConf);
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.info, 'pageConf.territoryCode :: ' + pageConf.territoryCode));
        this.list_GroupingData = new list<Object>();
        this.aplService.setGroupForecast(this.list_GroupingData, this.pageConf);
		this.jsongrouping = Json.serialize(this.list_GroupingData);
		//system.debug('!@#jsongrouping'+jsongrouping);
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.info, this.jsongrouping));
    }
	
	/**
    * This method is used to create a new interface instance
    *
    @author Bin Yuan
    @created 2014-06-02
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-02 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
	public void setTerritory() {
		try {
			
			String clsName = (this.selectedType == 'Sales Manager' ? 'APL_ClsAMForecastbyProductService' : 'APL_ClsRelayForecastbyProductService');
			this.aplService = newCtrlInstance(clsName);
			this.aplService.setPageConf(this.pageConf);
			
			//APL_ClsUtils.getTerritoryInfo(this.pageConf);
			 
			/*map<String, ClsAPLEntityTypes.RSMTerritoryInfo> map_territoryCodes = new map<String, ClsAPLEntityTypes.RSMTerritoryInfo>();
			for(ClsAPLEntityTypes.RSMTerritoryInfo territoryCodes : this.rsmTypeInfo.map_type_territoryCodes.get(this.selectedType)) {
				map_territoryCodes.put(territoryCodes.name, territoryCodes);
			}

			this.list_territoryCodes.addAll(map_territoryCodes.values());
			this.list_territoryCodes.sort();*/
			
		}
		catch(Exception ex) {
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex + ''));
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getStackTraceString()));
		}
	}
	
	
	public void initRSM() {
		this.setList_allDateItems();

		this.setLevel1Columns();
		this.setLevel2Columns();
		this.setLevel3Columns();
		this.setLevel4Columns();
		this.setLevel5Columns();
		this.setTotalColumns();

		this.setList_RSMGroupingData();
	}
	
	public void renderRSMForecast() {
		this.pageConf.isRender = false;
		initRSM();
	}
	
	public void saveRSMGrouping() {
		
		this.pageConf.isStop = false;
		this.pageConf.isRender = true;
		try{
			
			list<APL_ClsEntityType.RSMParentAcctObj> list_GroupingDatatemp = (list<APL_ClsEntityType.RSMParentAcctObj>)JSON.deserialize(this.json_savegroup, list<APL_ClsEntityType.RSMParentAcctObj>.class);
			list<Account> list_acc = new list<Account> ();
			for(APL_ClsEntityType.RSMParentAcctObj rsmgroup : list_GroupingDatatemp) {
				
				if(rsmgroup.olddisName != rsmgroup.displayName) {
					Account acct = (this.selectedType != 'Sales Manager' ? 
											new Account(Id = rsmgroup.acctId, APL_RSM_Relay_Display_Name__c = rsmgroup.displayName) 
										  : new Account(Id = rsmgroup.acctId, APL_RSM_Display_Name__c = rsmgroup.displayName));
					list_acc.add(acct);
				}
			}

			if(list_acc.size() > 0) {
				update list_acc;
			}
			
		}catch(Exception ex) {
			this.pageConf.isStop = true;
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));

		}
	}


	public void next() {
		initRSM();
		this.userName = '';
	}
	
	public void viewASUserRSM() {
		setTerritory();
		renderRSMForecast();
	}
	
	/*
	public void getUsersOfManagement() {

		list<APL_ClsEntityType.UserObj> list_RSMusers = new list<APL_ClsEntityType.UserObj>();
		//list<User> list_user = new list<User>();
		map<String, APL_ClsEntityType.UserObj> map_user_obj = new map<String, APL_ClsEntityType.UserObj>();
		Boolean hasPerm = false;
		for(APL_Forecast_Settings__c perm : [select Id,Value__c  from APL_Forecast_Settings__c where Is_Active__c = true and isLoginAsRSMView__c = true ]) {
			if(perm.Value__c != null && perm.Value__c.length() >= 15 && perm.Value__c.substring(0,15) == UserInfo.getUserId().substring(0,15)) {
				hasPerm = true;
			}
		}
		system.debug('!@#hasPerm: '+hasPerm);
		if(!hasPerm) {
			this.json_managerUserList = Json.serialize(map_user_obj);
			return;
		}
		
		String query = '';
        query = ' select RSM__r.Manager__c managerId, RSM__r.Manager__r.Name managerName, RecordType.DeveloperName rtName ';
        query += ' FROM APL_Forecast_Management__c ';
        query += ' WHERE RSM__c != null and RecordType.DeveloperName IN (\'AM\',\'Relay\') ';//and RSM__r.Manager__c !=\''+ UserInfo.getUserId() +'\'';
        query += ' group by RSM__r.Manager__c, RSM__r.Manager__r.Name, RecordType.DeveloperName';
  		system.debug('!@#query: '+query);
  		String levelname = 'Level';
        for(AggregateResult ar : database.query(query)){	
        	APL_ClsEntityType.UserObj userobj = new APL_ClsEntityType.UserObj();
        	if(!map_user_obj.containsKey((String)ar.get('managerId'))) {
        		userobj.key = userobj.id = (String)ar.get('managerId');
        		userobj.title = userobj.name = (String)ar.get('managerName');
        		userobj.lazy = true;
        		userobj.map_rsmType = new map<String, APL_ClsEntityType.RSMType>();
        	}else {
        		userobj = map_user_obj.get((String)ar.get('managerId'));
        	}

        	map<String, APL_ClsEntityType.RSMType> map_rsmType = userobj.map_rsmType;
        	
        	APL_ClsEntityType.RSMType remtype = new APL_ClsEntityType.RSMType();
			String clsname = ((String)ar.get('rtName') == 'AM' ? 'APL_ClsAMForecastbyProductService' : 'APL_ClsRelayForecastbyProductService');
			
			for(Integer i = 1; i <= 6;i++) {
				remtype.map_level_name.put(levelname + String.valueOf(i), clsname + '.Search' + levelname + String.valueOf(i));
			}
			if((String)ar.get('rtName') == 'AM') {
				remtype.map_level_name.put(levelname + 'Other', 'APL_ClsAMForecastbyProductService.SearchLevelOther');
			}
			
			remtype.map_level_name.put('Relay', ((String)ar.get('rtName') == 'AM' ? 'false' : 'true'));
			remtype.map_level_name.put(levelname+'total', clsname + '.SearchLevelTotal');
			
			map_rsmType.put(APL_ClsUtils.MAP_RSMMANAGERLABEL.get((String)ar.get('rtName')), remtype);
        	
        	userobj.map_rsmType = map_rsmType;
        	
        	map_user_obj.put(userobj.id, userobj);
        }
		this.json_managerUserList = Json.serialize(map_user_obj);
	}
	*/
	
	
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
	//********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
	
}