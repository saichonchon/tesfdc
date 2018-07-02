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
public without sharing class CtrlGroupingRelayForecast extends CtrlGroupingRemoteBase{
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public SettingPage sp {get;set;}
    public ClsAPLEntityTypes.PageConfig pageConf {get; set;}
    
    public transient list<ClsAPLEntityTypes.DateItem> list_allDateItems {get; set;}
    public transient list<ClsGroupingAMForecastUtil.AcctForecastItem> list_acctFC {get; set;}
    public transient list<ClsGroupingAMForecastUtil.AcctForecastItem> list_otherFC {get; set;}
    public transient list<ClsAPLEntityTypes.TotalFCViewFields> list_totalFC {get; set;}
    public transient LocaleConfig lc {get; set;}   
    public transient map<String, ClsGroupingRelayForecastUtil.RelayForecastViewFields> map_acctGroupId_fcViewObj {get; set;}
    
    public transient String str_futureQuarterMap {get; set;}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private String acctManagerId;
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    public CtrlGroupingRelayForecast(){
        try {
            this.lc = new LocaleConfig();
            this.sp = new SettingPage(false, '/apex/CtrlAccountGrouping');
            this.pageConf = new ClsAPLEntityTypes.PageConfig();
            initForecast();
            //this.acctManagerId = '005E0000005MMQU';
            this.acctManagerId = UserInfo.getUserId();
        }
        catch(Exception ex) {
        	ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getStackTraceString()));
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
        }
    }
    public CtrlGroupingRelayForecast(String url) {
    	this.sp = new SettingPage(true, url);
    }
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
    public void initForecast() {
        //this.acctManagerId = '005E0000005MMQU';
        this.acctManagerId = UserInfo.getUserId();
        this.pageConf.managerId = this.acctManagerId;
        this.list_acctFC = new list<ClsGroupingAMForecastUtil.AcctForecastItem>();
        this.list_otherFC = new list<ClsGroupingAMForecastUtil.AcctForecastItem>();
        //this.pageConf = new ClsAPLEntityTypes.PageConfig();
        this.pageConf.isRelay = true;
        this.list_allDateItems = new list<ClsAPLEntityTypes.DateItem>();
        try {
            ClsAPLForecastUtil.setFiscalMonth(pageConf);
            ClsAPLForecastUtil.createDateItem(pageConf, list_allDateItems);
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'pageConf.currentTerritoryCode::'+ pageConf.currentTerritoryCode));
            this.str_futureQuarterMap = Json.serialize(pageConf.map_year_quartersFuture);
            ClsGroupingRelayForecastUtil.getAcctInfo(this.acctManagerId, pageConf, this.list_acctFC, this.list_otherFC);
            //get account forecast data for each quarter
            getAcctForecasts();
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
    
    
    public CtrlGroupingRelayForecast getThis(){
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
    public void getAcctForecasts() {
        try {
            this.map_acctGroupId_fcViewObj = new map<String, ClsGroupingRelayForecastUtil.RelayForecastViewFields>();
            this.list_totalFC = new list<ClsAPLEntityTypes.TotalFCViewFields>();
           	//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'map_acctGroupId_fcViewObj :: ' + map_acctGroupId_fcViewObj)); 
            ClsGroupingRelayForecastUtil.getAcctForecast(this.acctManagerId, pageConf, this.map_acctGroupId_fcViewObj);
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'map_acctGroupId_fcViewObj :106 ::: ' + map_acctGroupId_fcViewObj)); 
            ClsGroupingRelayForecastUtil.getAcctTotalFCQuery(this.acctManagerId, pageConf, this.list_totalFC);
        }  
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getStackTraceString()));
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
    public list<ClsAPLEntityTypes.AcctColumns> getAcctViewRows() {
        list<ClsAPLEntityTypes.AcctColumns> list_tempColumns = new list<ClsAPLEntityTypes.AcctColumns> {
            
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_current_sales_forecast, 'currentFC', '', '', false),
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_previous_sales_forecast, 'previousFC', 'feve ', '', false),
            new ClsAPLEntityTypes.AcctColumns('Previous RSM Forecast', 'rsmFC', ' ', '', false),
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_pos_forecast, 'posFC', '', '', true),
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_cma_forecast, 'cmaFC', 'feve ', '', true),

            new ClsAPLEntityTypes.AcctColumns(system.label.APL_total_relay_billing, 'totalBilling', 'feve', '', false),
            //new ClsAPLEntityTypes.AcctColumns('Total Billing Quantity', 'totalBillingQty', 'feve ', '', false),
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_total_relay_booking, 'totalBooking', ' ', '', false),
            //new ClsAPLEntityTypes.AcctColumns('Total Booking Quantity', 'totalBookingQty', 'feve', '', false),
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_total_relay_backlog, 'totalBacklog', 'feve', '', false)
			//new ClsAPLEntityTypes.AcctColumns('Total Backlog Quantity', 'totalBacklogQty', '', '', false)
            /*
            ,
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_total_sa, 'totalSA', 'feve', '', false),
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_2m_fc_accuracy, 'fc2MAccuracy', '', '', false),
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_3m_fc_accuracy, 'fc3MAccuracy', 'feve', '', false),
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_6m_fc_accuracy, 'fc6MAccuracy', '', '', false)
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
    public list<ClsAPLEntityTypes.Cbc2Object> getCBC2Data(){
        list<ClsAPLEntityTypes.Cbc2Object> list_tempData = new list<ClsAPLEntityTypes.Cbc2Object> {            
            new ClsAPLEntityTypes.Cbc2Object('[ 13213 ] CBC2 / Automotive Relays', '13213', 'CBC2__c', ''),
            new ClsAPLEntityTypes.Cbc2Object('[ 30005 ] CBC2 / APPLIANCES GENERAL PURPOSE RELAYS', '30005',  'CBC2__c', ''),
            new ClsAPLEntityTypes.Cbc2Object('[ 41553 ] CBC3 / Relays IND', '41553', 'CBC3__c', '' )
            //comment by Lei Tang <lei.tang@capgemini.com> 2017-12-05
            //new ClsAPLEntityTypes.Cbc2Object('[ 40308 ] CBC3 / Relays A&C', '40308', 'CBC3__c', ''),
            //new ClsAPLEntityTypes.Cbc2Object('[ 40309 ] CBC3 / Relays IB', '40309', 'CBC3__c', '' )
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
    public list<ClsAPLEntityTypes.AcctColumns> getCBC2ViewRows() {
        list<ClsAPLEntityTypes.AcctColumns> list_tempColumns = new list<ClsAPLEntityTypes.AcctColumns> {
            
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_current_sales_forecast, 'currentFC', '', '', true),
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_previous_sales_forecast, 'previousFC', 'feve', '', false),
            new ClsAPLEntityTypes.AcctColumns('Previous RSM Forecast', 'rsmFC', '', '', false),
        //  new ClsAPLEntityTypes.AcctColumns('Schedule Agreement', 'scheduleAgreement', '', '', false),
        	
        	new ClsAPLEntityTypes.AcctColumns(system.label.APL_billing, 'billing', 'feve', '', false),
            //new ClsAPLEntityTypes.AcctColumns('Billing Quantity', 'billingQty', 'feve ', '', false),
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_booking, 'booking', '', '', false),
            //new ClsAPLEntityTypes.AcctColumns('Booking Quantity', 'bookingQty', 'feve', '', false),
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_backlog, 'backlog', 'feve', '', false)
			//new ClsAPLEntityTypes.AcctColumns('Backlog Quantity', 'backlogQty', '', '', false)
        	
            
            
            
            
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
    public list<ClsAPLEntityTypes.AcctColumns> getPartViewRows() {
        list<ClsAPLEntityTypes.AcctColumns> list_tempColumns = new list<ClsAPLEntityTypes.AcctColumns> {
            
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_current_sales_forecast, 'currentFC', '', '', true),
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_previous_sales_forecast, 'previousFC', 'feve', '', false),
            new ClsAPLEntityTypes.AcctColumns('Previous RSM Forecast', 'rsmFC', '', '', false),
            
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_billing, 'billing', 'feve', '', false),
            //new ClsAPLEntityTypes.AcctColumns('Billing Quantity', 'billingQty', 'feve ', '', false),
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_booking, 'booking', '', '', false),
            //new ClsAPLEntityTypes.AcctColumns('Booking Quantity', 'bookingQty', 'feve', '', false),
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_backlog, 'backlog', 'feve', '', false)
			//new ClsAPLEntityTypes.AcctColumns('Backlog Quantity', 'backlogQty', '', '', false)
        };
        return list_tempColumns;
    }
    
    
    /**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Lei Tang
    @created 2015-05-22
    @version 1.0
    @since 33.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public list<ClsAPLEntityTypes.AcctColumns> getProductCodeViewRows() {
        list<ClsAPLEntityTypes.AcctColumns> list_tempColumns = new list<ClsAPLEntityTypes.AcctColumns> {
            
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_current_sales_forecast, 'currentFC', '', '', true),
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_previous_sales_forecast, 'previousFC', 'feve', '', false),
            new ClsAPLEntityTypes.AcctColumns('Previous RSM Forecast', 'rsmFC', '', '', false),
            
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_billing, 'billing', 'feve', '', false),
            //new ClsAPLEntityTypes.AcctColumns('Billing Quantity', 'billingQty', 'feve ', '', false),
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_booking, 'booking', '', '', false),
            //new ClsAPLEntityTypes.AcctColumns('Booking Quantity', 'bookingQty', 'feve', '', false),
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_backlog, 'backlog', 'feve', '', false)
			//new ClsAPLEntityTypes.AcctColumns('Backlog Quantity', 'backlogQty', '', '', false)
            
        };
        return list_tempColumns;
    }
    
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>InnerClass*/
    public class ForecastDate{
        public String name {get;set;}
        public String year {get;set;}
        public String month {get;set;}
        public Boolean isInput {get;set;}
        
        public ForecastDate(){
            this.name = '';
            this.year = '';
            this.month = '';
            this.isInput = false;
        }
    }
    
    public class PageConfig {
        public map<String, set<Integer>> map_financialMonth {get; set;}
        public map<String, Decimal> map_workingDays {get; set;}

        public list<String> list_yearMonth {get; set;}
        public set<String> set_dateKey {get; set;}
        public String currentYear {get; set;}
        public Integer currentMonth {get; set;}
        public Integer currentMonthIndex {get; set;}
        public transient String str_tableHead {get; set;}
        public boolean isRelay {get; set;}
        public String currentTerritoryCode {get; set;}
        public map<String, set<String>> map_year_quartersFuture {get; set;}
        public set<String> set_parentIds = new set<String>();
        
        public PageConfig() {
            this.currentMonthIndex = 0;
            this.map_financialMonth = new map<String, set<Integer>>();
            this.currentYear = '';
            this.currentMonth = 0;
            this.set_dateKey = new set<String>();
            this.map_workingDays = new map<String, decimal>();
            this.list_yearMonth = new List<String>();
            this.map_workingDays = new Map<String, Decimal>();
            this.str_tableHead = '';
            this.isRelay = false;
            this.currentTerritoryCode = '';
            this.map_year_quartersFuture = new map<String, set<String>>();
            this.set_parentIds = new set<String>();
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
    
    
    public class LocaleConfig{
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
    
    ///*<<<InnerClass*/
    //********************************* -=END inner classes=- *************************************
    
}