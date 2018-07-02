/**
 *  Ctrl class for CSD_CtrlSalesPersonViewForecast
 *
 @author    Lei Tang
 @created   2014-10-16
 @version   1.0
 @since     30.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-10-16 Lei Tang <lei.tang@itbconsult.com>
 * - Created
 */
public without sharing class CSD_CtrlSalesPersonViewForecast extends CSD_CtrlForecastRemoteBase {
	
	 //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	public transient CSD_ClsEntityType.LocaleConfig lc {get;set;}

	public transient CSD_ClsEntityType.PageConfig pageConf {get; set;}
	
	public transient list<CSD_ClsEntityType.DateItem> list_allDateItems {get; set;}
	public transient list<CSD_ClsEntityType.CSDColumn> list_SoldToColumns {get;set;}
	public transient list<CSD_ClsEntityType.CSDColumn> list_OEMColumns {get;set;}
	public transient list<CSD_ClsEntityType.CSDColumn> list_PartColumns {get;set;}
	public transient list<CSD_ClsEntityType.CSDColumn> list_TotalColumns {get;set;}
	
	public transient list<Object> list_soldToData {get;set;}
	public transient String RESTSOLDTOID {get;set;}
	public transient String NONOEMSID {get;set;}
	
	public transient String rootUserJson {get;set;}
	public transient String userId {get;set;}
	public transient String totalbacklogname {get;set;}
	public transient String jsonmonthspercent {get;set;}
	public transient String jsonAttention {get;set;}// REQ_00842 cutoff date added by padmaja
	
	
	public CSD_Interface.ACSDCtrlService csdService {get;set;}
	

	{
		
		this.lc = new CSD_ClsEntityType.LocaleConfig();
		CSD_ClsUtils.setUserLocale(this.lc, userInfo.getLocale());	//set user locale
	}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
	public CSD_CtrlSalesPersonViewForecast(){
		CSD_ClsEntityType.UserObj user = new CSD_ClsEntityType.UserObj();
		for(User u : [Select Id, Name, SmallPhotoUrl From User Where Id =: userInfo.getUserId()]){
			user.key = user.id = u.Id;
			user.title = user.name = u.name;
			user.photoUrl = u.SmallPhotoUrl;
			user.lazy = true;
		}
		this.userId = user.id;
		this.rootUserJson = Json.serialize(user);
		
		this.csdService = new CSD_ClsSalesPersonViewService();	//init gam service interface
		initCSD();
		
	}
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
	public void refreshData(){
		initCSD();
	}
	
	
	public CSD_CtrlSalesPersonViewForecast getThis(){
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
	public void initCSD(){
		try {
			this.RESTSOLDTOID = CSD_ClsUtils.RESTSOLDTOID;
			if(CSD_Configuration__c.getInstance('Non OEM Account') != null && CSD_Configuration__c.getInstance('Non OEM Account').Value__c != null) {
	        	this.NONOEMSID = CSD_Configuration__c.getInstance('Non OEM Account').Value__c;
			}
			
			this.totalbacklogname = CSD_ClsUtils.MAP_ROWLABEL_ROWNAME.get('Total Backlog');
			
			this.pageConf = new CSD_ClsEntityType.PageConfig();
			this.pageConf.managerId = this.userId;
			this.csdService.setPageConf(this.pageConf);
			this.list_TotalColumns = new list<CSD_ClsEntityType.CSDColumn>();
			//this.setTotalColumns();
			this.setSoldToColumns();
			this.setOEMColumns();
			this.setPartColumns();
			this.setList_allDateItems();
			
			this.setList_soldToData();
			
			map<Integer, decimal> map_month_Percent = new map<Integer, decimal>();
            CSD_ClsUtils.setStatisticalPercentMap(map_month_Percent);
            this.jsonmonthspercent = Json.serialize(map_month_Percent);
            // REQ_00842 cutoff date added by padmaja
			this.jsonAttention = CSD_ClsUtils.getAttentionString();
			if(list_soldToData.size() < 1) {
				this.list_allDateItems.clear();
				this.pageConf.str_tableHead = 'null';
			}
		}
		catch(Exception ex) {
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
		}
		
		//this.csdService.getAcctInfo(this.pageConf);
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
		this.list_allDateItems = new list<CSD_ClsEntityType.DateItem>();
		this.csdService.setAllDateItems(this.pageConf, this.list_allDateItems);
	}
	
	
	
	public void setList_soldToData(){
		this.list_soldToData = new list<Object>();
		csdService.setLevel1Data(this.list_soldToData, this.pageConf);
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
		this.list_TotalColumns = new list<CSD_ClsEntityType.CSDColumn>();
		
		this.csdService.setTotalRow(this.list_TotalColumns);
		//return list_soldToColumn;
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
	public void setSoldToColumns(){
		this.list_SoldToColumns = new list<CSD_ClsEntityType.CSDColumn>();
		this.csdService.setLevel1Row(this.list_SoldToColumns);
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
	public void setOEMColumns(){
		this.list_OEMColumns = new list<CSD_ClsEntityType.CSDColumn>();
		this.csdService.setLevel2Row(this.list_OEMColumns);
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
	public void setPartColumns(){
		this.list_PartColumns = new list<CSD_ClsEntityType.CSDColumn>();
		this.csdService.setLevel3Row(this.list_PartColumns);
	}


	@RemoteAction
	public static String getSubordinateUser(String sData) {
		
		CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
		list<CSD_ClsEntityType.UserObj> list_users = new list<CSD_ClsEntityType.UserObj>();
		
		CSD_ClsUtils.setSubordinateUser(searchOb.userId, list_users);

		return Json.serialize(list_users);
	}
	
	
	@RemoteAction
	public static String getUsersOfManagement(String sData) {

		list<CSD_ClsEntityType.UserObj> list_soldtousers = new list<CSD_ClsEntityType.UserObj>();
		list<CSD_ClsEntityType.UserObj> list_samsungusers = new list<CSD_ClsEntityType.UserObj>();
		
		list<User> list_user = new list<User>();
		set<String> set_useremail = new set<String>();
		for(User user : [select Id, Name, SmallPhotoUrl, Email
                         from User where CSD_Forecast_Delegation__c = :UserInfo.getUserId() ]) {
    		list_user.add(user);
    		if(!set_useremail.contains(user.Email)) {
    			set_useremail.add(user.Email);
    		}
       	}
    	set<String> set_samsunguseremail = new set<String>();
    	for(CSD_Samsung_Mapping__c sm : [select Sales_Email__c
                                    	 from CSD_Samsung_Mapping__c 
                                    	 where Sales_Email__c IN :set_useremail ]) {
    		set_samsunguseremail.add(sm.Sales_Email__c);
    	}

        for(User user : list_user) {
            CSD_ClsEntityType.UserObj userobj = new CSD_ClsEntityType.UserObj();
            userobj.key = userobj.id = user.Id;
            userobj.title = userobj.name = user.name;
            userobj.photoUrl = user.SmallPhotoUrl;
            userobj.lazy = true;
            userobj.isSamsung = (set_samsunguseremail.contains(user.Email) ? true : false);
            userobj.password = CSD_ClsUtils.encryptionFormID(user.Id);
            userobj.url = '/apex/CSD_CtrlSoldToForecast?mid=' + userobj.password;
            list_soldtousers.add(userobj);
			
			if(set_samsunguseremail.contains(user.Email)) {
				CSD_ClsEntityType.UserObj samsunguserobj = new CSD_ClsEntityType.UserObj();
	            samsunguserobj = userobj.clone();
	            samsunguserobj.isSamsung = true;
	            samsunguserobj.url = '/apex/CSD_CtrlSamsungForecast?mid=' + userobj.password;
	            list_samsungusers.add(samsunguserobj);
			}
        }

		list<Object> list_s = new list<Object>{
			new CSD_ClsEntityType.UserObj('Sold To', list_soldtousers),
			new CSD_ClsEntityType.UserObj('Samsung', list_samsungusers)
		};

		return Json.serialize(list_s);
	}
	
	
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
	//********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
	

	
    
    
    
    
}