/**
 *  Controll class for page CtrlAcctGrouping
 *
 @author    Bin Yuan
 @created   2014-03-27
 @version   1.0
 @since     29.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-03-27 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created
 */
public without sharing class CtrlGroupingAMForecast extends CtrlGroupingRemoteBase{
	
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	public ClsAPLEntityTypes.PageConfig pageConf {get; set;}
	public SettingPage sp {get;set;}
	public transient LocaleConfig lc {get; set;}

	public transient list<ClsAPLEntityTypes.DateItem> list_dateItemTypes {get; set;}
	public transient map<String, list<ClsAPLEntityTypes.DateItem>> map_type_dateItems {get; set;}
	public transient list<ClsAPLEntityTypes.DateItem> list_allDateItems {get; set;}
	public transient list<ClsGroupingAMForecastUtil.AcctForecastItem> list_acctFC {get; set;}
	public transient list<ClsGroupingAMForecastUtil.AcctForecastItem> list_otherFC {get; set;}
	public transient list<ClsGroupingAMForecastUtil.TotalFCViewFields> list_totalFC {get; set;}
	public transient map<String, ClsGroupingAMForecastUtil.ForecastViewFields> map_acctGroupId_fcViewObj {get; set;}
	public transient String str_futureQuarterMap {get; set;}
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	//private set<String> set_dateKey = new set<String>();
	private String acctManagerId;
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
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
	public CtrlGroupingAMForecast(){
		this.lc = new LocaleConfig();
		this.sp = new SettingPage(false, '/apex/CtrlAccountGrouping');
		//this.acctManagerId = '005E00000018QLsIAM';
		this.acctManagerId = UserInfo.getUserId();
		this.pageConf = new ClsAPLEntityTypes.PageConfig();
		initForecast();
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
	public CtrlGroupingAMForecast(String url){
		this.sp = new SettingPage(true, url);
	}
	
	/////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
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
	public void initForecast() {
		//this.set_dateKey.clear();
		//this.acctManagerId = '005E00000018QLsIAM';
		this.acctManagerId = UserInfo.getUserId();
		this.pageConf.managerId = this.acctManagerId;
		this.list_acctFC = new list<ClsGroupingAMForecastUtil.AcctForecastItem>();
		this.list_otherFC = new list<ClsGroupingAMForecastUtil.AcctForecastItem>();
		//this.pageConf = new ClsAPLEntityTypes.PageConfig();
		this.list_dateItemTypes = new list<ClsAPLEntityTypes.DateItem>();
		this.map_type_dateItems = new map<String, list<ClsAPLEntityTypes.DateItem>>();
		this.list_allDateItems = new list<ClsAPLEntityTypes.DateItem>();

		try {
			ClsAPLForecastUtil.setFiscalMonth(pageConf);
			ClsAPLForecastUtil.createDateItem(pageConf, list_allDateItems);
			this.str_futureQuarterMap = Json.serialize(pageConf.map_year_quartersFuture);
			ClsGroupingAMForecastUtil.getAcctInfo(this.acctManagerId, pageConf, this.list_acctFC, this.list_otherFC);
			//get account forecast data for each quarter
			getAcctForecasts();
			
			//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'this.list_acctFC :: '+ this.list_acctFC));
			//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'this.pageConf.set_parentIds :: '+ this.pageConf.set_parentIds));
			if(this.pageConf.isFrozen) {
				ClsAPLForecastUtil.addFrozenMsg();
			}
		}
		catch(Exception ex) {
			this.pageConf.str_tableHead = '';
			this.list_allDateItems.clear();
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getStackTraceString()));
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
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
	public CtrlGroupingAMForecast getThis(){
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
	public list<ClsGroupingAMForecastUtil.AcctViewColumns> getAcctViewRows() {
		list<ClsGroupingAMForecastUtil.AcctViewColumns> list_tempColumns = new list<ClsGroupingAMForecastUtil.AcctViewColumns> {
			
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_current_sales_forecast, 'currentFC', '', '', false),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_previous_sales_forecast, 'previousFC', 'feve ', '', false),
			new ClsGroupingAMForecastUtil.AcctViewColumns('Previous RSM Forecast', 'rsmFC', '  ', '', false),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_pos_forecast, 'posFC', '', '', true),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_cma_forecast, 'cmaFC', 'feve ', '', true),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_total_billing, 'totalBilling', 'feve ', '', false),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_total_booking, 'totalBooking', ' ', '', false),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_total_backlog, 'totalBacklog', 'feve', '', false)
			/*
			,
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_total_sa, 'totalSA', 'feve', '', false),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_2m_fc_accuracy, 'fc2MAccuracy', 'feve', '', false),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_3m_fc_accuracy, 'fc3MAccuracy', '', '', false),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_6m_fc_accuracy, 'fc6MAccuracy', 'feve', '', false)
			*/
		};
		return list_tempColumns;
	}
	
	
	
	/**
    * This method is used to generate CBC2 data.
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
	public list<ClsGroupingAMForecastUtil.Cbc2Object> getCBC2Data(){
		list<ClsGroupingAMForecastUtil.Cbc2Object> list_tempData = new list<ClsGroupingAMForecastUtil.Cbc2Object> {
			
			new ClsGroupingAMForecastUtil.Cbc2Object('[ 30012 ] - Power', '30012', 'Power', ''),
            new ClsGroupingAMForecastUtil.Cbc2Object('[ 30014 ] - Signal', '30014', 'Signal', ''),
			new ClsGroupingAMForecastUtil.Cbc2Object('[ 30015 ] - RAST', '30015', 'RAST', ''),
			new ClsGroupingAMForecastUtil.Cbc2Object('[ 30016 ] - Terminals & Splices', '30016', 'Terminals & Splices', ''),
			new ClsGroupingAMForecastUtil.Cbc2Object('[ 30017 ] - Tubing', '30017', 'Tubing', '' ),
			new ClsGroupingAMForecastUtil.Cbc2Object('[ 30042 ] - Magnet', '30042', 'Magnet', '' ),
			new ClsGroupingAMForecastUtil.Cbc2Object('Relay', 'Relay', 'Relay', 'cls_relay' ),
			new ClsGroupingAMForecastUtil.Cbc2Object('Other BU Products', 'Others', 'OTHER', 'cls_other' )
			
		};

		return list_tempData;
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
	public list<ClsGroupingAMForecastUtil.AcctViewColumns> getCBC2ViewRows() {
		list<ClsGroupingAMForecastUtil.AcctViewColumns> list_tempColumns = new list<ClsGroupingAMForecastUtil.AcctViewColumns> {
			
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_current_sales_forecast, 'currentFC', '', '', true),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_previous_sales_forecast, 'previousFC', 'feve', '', false),
			new ClsGroupingAMForecastUtil.AcctViewColumns('Previous RSM Forecast', 'rsmFC', '  ', '', false),
		//	new ClsGroupingAMForecastUtil.AcctViewColumns('Schedule Agreement', 'scheduleAgreement', '', '', false),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_billing, 'billing', 'feve', '', false),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_booking, 'booking', '', '', false),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_backlog, 'backlog', 'feve', '', false)

		};
		return list_tempColumns;
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
	public list<ClsGroupingAMForecastUtil.AcctViewColumns> getGPLViewRows() {
		list<ClsGroupingAMForecastUtil.AcctViewColumns> list_tempColumns = new list<ClsGroupingAMForecastUtil.AcctViewColumns> {
			
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_current_sales_forecast, 'currentFC', '', '', true),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_previous_sales_forecast, 'previousFC', 'feve', '', false),
			new ClsGroupingAMForecastUtil.AcctViewColumns('Previous RSM Forecast', 'rsmFC', ' ', '', false),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_schedule_agreement, 'scheduleAgreement', '', 'nhide', false),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_forecast_of_rest_parts, 'partFC', 'feve', 'nhide', false),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_billing, 'billing', 'feve', '', false),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_booking, 'booking', '', '', false),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_backlog, 'backlog', 'feve', '', false)
			
		};
		return list_tempColumns;
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
	public list<ClsGroupingAMForecastUtil.AcctViewColumns> getPartViewRows() {
		list<ClsGroupingAMForecastUtil.AcctViewColumns> list_tempColumns = new list<ClsGroupingAMForecastUtil.AcctViewColumns> {
			
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_current_sales_forecast, 'currentFC', '', '', true),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_previous_sales_forecast, 'previousFC', 'feve', '', false),
			new ClsGroupingAMForecastUtil.AcctViewColumns('Previous RSM Forecast', 'rsmFC', ' ', '', false),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_schedule_agreement, 'scheduleAgreement', '', 'nhide', false),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_billing, 'billing', 'feve', '', false),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_booking, 'booking', '', '', false),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_backlog, 'backlog', 'feve', '', false)
			
		};
		return list_tempColumns;
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
	public list<ClsGroupingAMForecastUtil.AcctViewColumns> getProductCodeViewRows() {
		list<ClsGroupingAMForecastUtil.AcctViewColumns> list_tempColumns = new list<ClsGroupingAMForecastUtil.AcctViewColumns> {
			
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_current_sales_forecast, 'currentFC', '', '', true),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_previous_sales_forecast, 'previousFC', 'feve', '', false),
			new ClsGroupingAMForecastUtil.AcctViewColumns('Previous RSM Forecast', 'rsmFC', ' ', '', false),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_schedule_agreement, 'scheduleAgreement', '', 'nhide', false),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_billing, 'billing', 'feve', '', false),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_booking, 'booking', '', '', false),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_backlog, 'backlog', 'feve', '', false)
		};
		return list_tempColumns;
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
	public list<ClsGroupingAMForecastUtil.AcctViewColumns> getOtherViewRows() {
		list<ClsGroupingAMForecastUtil.AcctViewColumns> list_tempColumns = new list<ClsGroupingAMForecastUtil.AcctViewColumns> {
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_current_sales_forecast, 'currentFC', '', '', true),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_billing, 'billing', 'feve', '', false),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_booking, 'booking', '', '', false),
			new ClsGroupingAMForecastUtil.AcctViewColumns(system.label.APL_backlog, 'backlog', 'feve', '', false)
		};
		return list_tempColumns;
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
	public void getAcctForecasts() {
		try {
			this.map_acctGroupId_fcViewObj = new map<String, ClsGroupingAMForecastUtil.ForecastViewFields>();
			this.list_totalFC = new list<ClsGroupingAMForecastUtil.TotalFCViewFields>();
			ClsGroupingAMForecastUtil.getAcctForecast(this.acctManagerId, pageConf, this.map_acctGroupId_fcViewObj);
			
			ClsGroupingAMForecastUtil.getAcctTotalFCQuery(this.acctManagerId, pageConf, this.list_totalFC);
			//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'this.list_totalFC :: '+ this.list_totalFC));
		}
		catch(Exception ex) {
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getStackTraceString()));
		}
	}

	//********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>InnerClass*/
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
        
        public LocaleConfig(){
            try{
                this.locale= userInfo.getLocale();
                list<String> list_s = this.locale.split('_');
                this.locale = list_s[0]+'-'+list_s[1];
            }catch(Exception e){
                this.locale = 'de-DE';
            }   
            this.jsPath = '/glob-cultures/cultures/globalize.culture.'+this.locale+'.js';
        }
    }
    
    public class SettingPage{
    	
    	public Boolean isShow {get;set;}
    	public String url {get;set;}
    	
    	public SettingPage(Boolean isShow, String url){
    		this.isShow = isShow;
    		this.url = url;
    	}
    }
    
    ///*<<<InnerClass*/
    //********************************* -=END inner classes=- *************************************
}