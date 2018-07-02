/**
 *  Ctrl class for CtrlGroupingGAMForecast
 *
 @author    Lili Zhao
 @created   2014-05-19
 @version   1.0
 @since     27.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-05-19 Lili Zhao <lili.zhao@itbconsult.com>
 * - Created
 */
public without sharing class APL_CtrlGroupingRSMForecast extends CtrlGroupingRemoteBase {
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	public transient ClsAPLEntityTypes.LocaleConfig lc {get;set;}
	public ClsAPLEntityTypes.PageConfig pageConf {get; set;}
	public String json_rsmTypeMap {get; set;}
	public transient list<ClsAPLEntityTypes.DateItem> list_allDateItems {get;set;}
	public transient list<ClsAPLEntityTypes.AcctColumns> list_acctColumn {get;set;}
	public transient list<ClsAPLEntityTypes.AcctColumns> list_cbcColumn {get;set;}
	public transient list<ClsAPLEntityTypes.AcctColumns> list_gplColumn {get;set;}
	public transient list<ClsAPLEntityTypes.Cbc2Object> list_cbcData {get;set;}
	public transient list<ClsAPLEntityTypes.AcctColumns> list_productcodeColumn {get;set;}
	public transient list<ClsAPLEntityTypes.AcctColumns> list_partColumn {get;set;}
	public transient list<ClsAPLEntityTypes.AcctColumns> list_otherColumn {get;set;}
	
	public transient list<ClsAPLEntityTypes.RSMTerritoryInfo> list_territoryCodes {get; set;}
	public transient list<ClsAPLEntityTypes.TotalFCViewFields> list_totalFC {get; set;}
	public String selectedType {get; set;}
	public Boolean isLoginAs {get; set;}
	public String json_managerUserList {get; set;}
	public String chartURL {get;set;}
	
	
	public ClsAPLInterface.IAPLControllerService service {get;set;}
	{
		try{
			this.lc = new ClsAPLEntityTypes.LocaleConfig();
			ClsAPLForecastUtil.setUserLocale(this.lc, userInfo.getLocale());	//set user locale
		}catch(Exception e){
			
		} 
	}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private ClsAPLEntityTypes.RSMAcctInfo rsmTypeInfo;
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
	public APL_CtrlGroupingRSMForecast(){
		try {
			//get rsm territory codes, if both am and relay rsm for current user, let user choose which to display
			this.json_rsmTypeMap = '';
			this.chartURL = '';
			this.pageConf = new ClsAPLEntityTypes.PageConfig();
			this.json_managerUserList = '{}';
			//this.pageConf.managerId = UserInfo.getUserId();
			this.json_rsmTypeMap = '{}';
			getUsersOfManagement();
			
			/*if(ApexPages.currentPage().getParameters().get('uid') != null) {
				String paramvalue = ApexPages.currentPage().getParameters().get('uid');
				Blob afterblob = EncodingUtil.base64Decode(paramvalue);
				String loginInfo = afterblob.toString();
				if(loginInfo != 'AM' && loginInfo != 'Relay' ) {
					this.selectedType = '';
					return;
				}
				this.selectedType = loginInfo;
				rsmTypeInfo = ClsAPLRSMForecastUtil.getTerritoryInfo(this.pageConf);
				setTerritory();
				this.json_rsmTypeMap = '{}';
				
				getUsersOfManagement();
				
			}else {
				
				this.selectedType = '';
				initPage();
			}
			*/
		}
		catch(Exception ex) {
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex + ''));
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getStackTraceString()));
		}
	}
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
    
    public void initPage() {
    	
    	this.selectedType = APL_ClsUtils.MAP_RSMLABEL_MANAGER.get(this.selectedType);
    	
    	
    	//this.pageConf.managerId = UserInfo.getUserId();
		//this.selectedType = '';
		//this.service = new ClsAPLInterface.IAPLControllerService();
		rsmTypeInfo = ClsAPLRSMForecastUtil.getTerritoryInfo(this.pageConf);
		//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'rsmTypeInfo.54 :: '+ rsmTypeInfo));
		
		//if(rsmTypeInfo.map_type_instanceName.keySet().size() == 1) {
		//	for(String rsmType : rsmTypeInfo.map_type_instanceName.keySet()) {
		//		this.selectedType = rsmType;
		//	}
			setTerritory();
		//}
		this.json_rsmTypeMap = Json.serialize(rsmTypeInfo.map_type_instanceName);
		//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'this.json_rsmTypeMap ::: '+ this.json_rsmTypeMap));
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
	public void initRSM(){
		this.service.setPageConf(this.pageConf);
		//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'this.pageConf :: ' + this.pageConf));
		set_allDateItems();
		setAcctViewColumns();
		setCBCViewColumns();
		setGPLViewColumns();
		setPartViewColumns();
		setProductCodeViewColumns();
		setOtherViewColumns();
		setCBCData(this.selectedType);
		loadTotalFC();
		
		
	}
	
	
	public void viewASUserRSM() {
		initPage();
		//renderRSMForecast();
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
			this.list_territoryCodes = new list<ClsAPLEntityTypes.RSMTerritoryInfo>();
			this.service = ClsAPLForecastUtil.newCtrlInstance(rsmTypeInfo.map_type_instanceName.get(this.selectedType));
			map<String, ClsAPLEntityTypes.RSMTerritoryInfo> map_territoryCodes = new map<String, ClsAPLEntityTypes.RSMTerritoryInfo>();
			for(ClsAPLEntityTypes.RSMTerritoryInfo territoryCodes : rsmTypeInfo.map_type_territoryCodes.get(this.selectedType)) {
				map_territoryCodes.put(territoryCodes.name, territoryCodes);
			}

			list_territoryCodes.addAll(map_territoryCodes.values());
			list_territoryCodes.sort();
			initRSM();
		}
		catch(Exception ex) {
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex + ''));
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getStackTraceString()));
		}
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
	public void loadTotalFC() {
		try {
			this.list_totalFC = new list<ClsAPLEntityTypes.TotalFCViewFields>();
			//LOAD AM total fc
			if(this.selectedType == 'AM') {
				ClsAPLServiceRSM.getAcctTotalFC(this.pageConf, this.list_totalFC);
				pageConf.isOverallFrozen = ClsAPLRSMForecastUtil.getIsRSMAMOverallFrozen();
			}
			//load Relay total fc
			else {
				ClsAPLServiceRSMRelay.getAcctTotalFC(this.pageConf, this.list_totalFC);	
				pageConf.isOverallFrozen = ClsAPLRSMForecastUtil.getIsRSMRelayOverallFrozen();
			}
			//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'pageConf.isOverallFrozen :: ' + pageConf.isOverallFrozen));
		}
		catch(Exception ex) {
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex + ''));
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getStackTraceString()));
		}
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
	public void set_allDateItems(){
		this.list_allDateItems = new list<ClsAPLEntityTypes.DateItem>();
		//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'this.pageConf :: ' + this.pageConf));
		this.service.setAllDateItems(this.pageConf, list_allDateItems);
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
	public void setAcctViewColumns(){
		this.list_acctColumn = new list<ClsAPLEntityTypes.AcctColumns>();
		this.service.setAcctRow(list_acctColumn);
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
	public void setCBCViewColumns(){
		this.list_cbcColumn = new list<ClsAPLEntityTypes.AcctColumns>();
		this.service.setCBC2Row(list_cbcColumn);
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
	public void setCBCData(String selectedType) {
		this.list_cbcData = new list<ClsAPLEntityTypes.Cbc2Object>();
		if(selectedType == 'AM') {
			this.service.setCBC2Data(list_cbcData);
			try{
            	this.chartURL = APL_CtrlChart.enCodeUrl('RSM',  null, UserInfo.getUserId());
            }catch(Exception ex) {
            	
            }
		}else if(selectedType == 'Relay') {
			this.service.setRelayCBC2Data(list_cbcData);
			try{
            	this.chartURL = APL_CtrlChart.enCodeUrl('RSMRelay',  null, UserInfo.getUserId());
            }catch(Exception ex) {
            	
            }
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
	public void setGPLViewColumns(){
		this.list_gplColumn = new list<ClsAPLEntityTypes.AcctColumns>();
		this.service.setGPLRow(list_gplColumn);
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
	public void setPartViewColumns(){
		this.list_partColumn = new list<ClsAPLEntityTypes.AcctColumns>();
		this.service.setPartRow(list_partColumn);
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
	public void setOtherViewColumns(){
		this.list_otherColumn = new list<ClsAPLEntityTypes.AcctColumns>();
		this.list_otherColumn = getRSMOtherRow();
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
	public void setProductCodeViewColumns(){
		this.list_productcodeColumn = new list<ClsAPLEntityTypes.AcctColumns>();
		this.service.setProductCodeRow(list_productcodeColumn);
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
	public APL_CtrlGroupingRSMForecast getThis(){
		return this;
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
	public list<ClsAPLEntityTypes.AcctColumns> getTotalReferRow() {
		list<ClsAPLEntityTypes.AcctColumns> list_t = new list<ClsAPLEntityTypes.AcctColumns> {
			new ClsAPLEntityTypes.AcctColumns(system.label.APL_current_sales_forecast, 'currentFC', '', '', true),
			new ClsAPLEntityTypes.AcctColumns(system.label.APL_previous_sales_forecast, 'previousFC', 'feve', '', false),
		//	new ClsAPLEntityTypes.AcctColumns(system.label.APL_AM_Sales_Forecast, 'amFC', ' ', '', false),
			new ClsAPLEntityTypes.AcctColumns(system.label.APL_total_billing, 'totalBilling', 'feve', '', false),
			new ClsAPLEntityTypes.AcctColumns(system.label.APL_total_booking, 'totalBooking', ' ', '', false),
			new ClsAPLEntityTypes.AcctColumns(system.label.APL_total_backlog, 'totalBacklog', 'feve', '', false)
		};
		return list_t;
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
	public list<ClsAPLEntityTypes.AcctColumns> getRelayTotalReferRow() {
		list<ClsAPLEntityTypes.AcctColumns> list_t = new list<ClsAPLEntityTypes.AcctColumns> {
			new ClsAPLEntityTypes.AcctColumns(system.label.APL_current_sales_forecast, 'currentFC', '', '', true),
			new ClsAPLEntityTypes.AcctColumns(system.label.APL_previous_sales_forecast, 'previousFC', 'feve', '', false),
			new ClsAPLEntityTypes.AcctColumns(system.label.APL_total_billing, 'totalBilling', 'feve', '', false),
			new ClsAPLEntityTypes.AcctColumns(system.label.APL_total_booking, 'totalBooking', ' ', '', false),
			new ClsAPLEntityTypes.AcctColumns(system.label.APL_total_backlog, 'totalBacklog', 'feve', '', false)
		};
		return list_t;
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
	public list<ClsAPLEntityTypes.AcctColumns> getRSMTotalReferRow() {
		list<ClsAPLEntityTypes.AcctColumns> list_t = new list<ClsAPLEntityTypes.AcctColumns> {
			new ClsAPLEntityTypes.AcctColumns(system.label.APL_total_billing, 'totalBilling', 'feve', '', false),
			new ClsAPLEntityTypes.AcctColumns(system.label.APL_total_booking, 'totalBooking', ' ', '', false),
			new ClsAPLEntityTypes.AcctColumns(system.label.APL_total_backlog, 'totalBacklog', 'feve', '', false)
		};
		return list_t;
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
	public list<ClsAPLEntityTypes.AcctColumns> getRSMOtherRow() {
		list<ClsAPLEntityTypes.AcctColumns> list_t = new list<ClsAPLEntityTypes.AcctColumns> {
			new ClsAPLEntityTypes.AcctColumns(system.label.APL_current_sales_forecast, 'currentFC', '', '', true),
			new ClsAPLEntityTypes.AcctColumns(system.label.APL_total_billing, 'totalBilling', 'feve', '', false),
			new ClsAPLEntityTypes.AcctColumns(system.label.APL_total_booking, 'totalBooking', ' ', '', false),
			new ClsAPLEntityTypes.AcctColumns(system.label.APL_total_backlog, 'totalBacklog', 'feve', '', false)
		};
		return list_t;
	}
	
	
	public void getUsersOfManagement() {

		list<APL_ClsEntityType.UserObj> list_RSMusers = new list<APL_ClsEntityType.UserObj>();
		//list<User> list_user = new list<User>();
		map<String, APL_ClsEntityType.UserObj> map_user_obj = new map<String, APL_ClsEntityType.UserObj>();
		Boolean hasPerm = false;
		String currentUser = UserInfo.getUserId().substring(0,15)+'%';
		for(APL_Forecast_Settings__c perm : [select Id,Value__c  from APL_Forecast_Settings__c where Is_Active__c = true and isLoginAsRSMView__c = true and Value__c like :currentUser ]) {
			hasPerm = true;
			break;
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
        	
        	userobj.map_rsmType.put(APL_ClsUtils.MAP_RSMMANAGERLABEL.get((String)ar.get('rtName')), null);
        	
        	map_user_obj.put(userobj.id, userobj);
        }
        
		this.json_managerUserList = Json.serialize(map_user_obj);
	}
	
	
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
	//********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************

}