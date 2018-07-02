/**
 *  Ctrl class for CSD_CtrlSamsungForecastView
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
public with sharing class CSD_CtrlSamsungForecastView extends CSD_CtrlForecastRemoteBase {
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	public transient CSD_ClsEntityType.LocaleConfig lc {get;set;}

	public transient CSD_ClsEntityType.PageConfig pageConf {get; set;}
	
	public transient list<CSD_ClsEntityType.DateItem> list_allDateItems {get; set;}
	public transient list<CSD_ClsEntityType.CSDColumn> list_SoldToColumns {get;set;}
	//public transient list<CSD_ClsEntityType.CSDColumn> list_OEMColumns {get;set;}
	public transient list<CSD_ClsEntityType.CSDColumn> list_PartColumns {get;set;}
	public transient list<CSD_ClsEntityType.CSDColumn> list_TotalColumns {get;set;}
	public transient list<CSD_ClsEntityType.CSDColumn> list_GPLFamilyColumns {get;set;}
	public transient list<CSD_ClsEntityType.CSDColumn> list_GPLCodeColumns {get;set;}
	
	public transient list<Object> list_popupColumnsLevle1 {get;set;}
	public transient list<Object> list_popupColumnsLevle2 {get;set;}
	public transient list<Object> list_popupColumnsLevle3 {get;set;}
	//public transient list<Object> list_soldToData {get;set;}
	public transient list<Object> list_GPLFamilyData {get;set;}
	
	public transient String RESTSOLDTOID {get;set;}
	public transient String RESTPARTID {get;set;}
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
	public CSD_CtrlSamsungForecastView(){
		this.csdService = new CSD_ClsSamsungViewService();
		initCSD();
		
	}
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************

	public CSD_CtrlSamsungForecastView getThis(){
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
			this.RESTPARTID = CSD_ClsUtils.RESTPARTID;
			
			this.pageConf = new CSD_ClsEntityType.PageConfig();
			Boolean isPrems = false;
			for(CSD_Forecast_Management__c mapping : [select Id
                                        			from CSD_Forecast_Management__c where Role__c='Samsung GAM' and User__c=:UserInfo.getUserId()]) {
				isPrems = true;
				break;
			}
			
			this.pageConf.managerId = UserInfo.getUserId();
			if(CSD_Configuration__c.getInstance('Samsung OEM Account') != null || CSD_Configuration__c.getInstance('Samsung OEM Account').Value__c != null) {
				this.pageConf.samsungId = CSD_Configuration__c.getInstance('Samsung OEM Account').Value__c;
			}
			this.csdService.setPageConf(this.pageConf);

			this.setPopupColumnsLevle1();
			this.setPopupColumnsLevle2();
			this.setPopupColumnsLevle3();
			
			//this.setTotalColumns();
			//this.setOEMColumns();
			this.list_TotalColumns = new list<CSD_ClsEntityType.CSDColumn>();
			this.setGPLFamilyColumns();
			this.setGPLCodeColumns();
			this.setPartColumns();
			this.setSoldToColumns();
			this.setList_allDateItems();
			
			map<Integer, decimal> map_month_Percent = new map<Integer, decimal>();
            CSD_ClsUtils.setStatisticalPercentMap(map_month_Percent);
            this.jsonmonthspercent = Json.serialize(map_month_Percent);
            // REQ_00842 cutoff date added by padmaja
			this.jsonAttention = CSD_ClsUtils.getAttentionString();
			if(isPrems) {
				this.setList_GPLData();
				if(list_GPLFamilyData.size() < 1) {
					this.list_allDateItems.clear();
					this.pageConf.str_tableHead = 'null';
				}
			}else {
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
	
	
	
	public void setList_GPLData(){
		this.list_GPLFamilyData = new list<Object>();
		csdService.setLevel1Data(this.list_GPLFamilyData, this.pageConf);
	}
	
	
	/**
    * This method is used to generate GPL Family columns
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
	public void setGPLFamilyColumns(){
		this.list_GPLFamilyColumns = new list<CSD_ClsEntityType.CSDColumn>();
		this.csdService.setLevel1Row(this.list_GPLFamilyColumns);
	}
	
	
	/**
    * This method is used to generate GPL Code columns
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
	public void setGPLCodeColumns(){
		this.list_GPLCodeColumns = new list<CSD_ClsEntityType.CSDColumn>();
		this.csdService.setLevel2Row(this.list_GPLCodeColumns);
	}
	
	
	/**
    * This method is used to generate Total Columns
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
	}
	
	
	/**
    * This method is used to generate SoldTo Columns
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
		this.csdService.setLevel4Row(this.list_SoldToColumns);
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
	
	
	public void setPopupColumnsLevle1(){
		this.list_popupColumnsLevle1 = new list<Object>();
		this.csdService.setPopUPBoxColumnLevel1(this.list_popupColumnsLevle1);
	}
	
	public void setPopupColumnsLevle2(){
		this.list_popupColumnsLevle2 = new list<Object>();
		this.csdService.setPopUPBoxColumnLevel2(this.list_popupColumnsLevle2);
	}
	
	public void setPopupColumnsLevle3(){
		this.list_popupColumnsLevle3 = new list<Object>();
		this.csdService.setPopUPBoxColumnLevel3(this.list_popupColumnsLevle3);
	}
	

    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
	//********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************

}