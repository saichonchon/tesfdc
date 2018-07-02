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
public without sharing class CtrlAccountGrouping extends CtrlGroupingRemoteBase{
   
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public String acctManagerId {get; set;}
    
    public transient LocaleConfig lc {get; set;}
//    public transient list<ClsAcctGroupingUtil.ParentAcctObj> list_accts {get; set;}
    public transient String str_jsonAccts {get; set;}
    public transient String str_mapTypeCodes {get; set;}
    public boolean isShowPopup {get; set;}
    public PageConfig pageConf {get; set;}
    public String chartURL {get;set;}
    
    public ForecastCtrl ctrl {get;set;}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
   /**
    * Constructer
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public CtrlAccountGrouping() {
        try {
            this.lc = new LocaleConfig();
            this.ctrl = new ForecastCtrl();
			this.chartURL = '';
            //this.acctManagerId = '005E00000018QLs';
            this.acctManagerId = userInfo.getUserId();
            this.pageConf = new PageConfig();
            
            init();
        }
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getStackTraceString()));
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
        }
    }
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
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
    public void init() {
        this.isShowPopup = false;
        this.str_jsonAccts = '';
        this.str_mapTypeCodes = '';
        list<ClsAcctGroupingUtil.ParentAcctObj> list_accts = new list<ClsAcctGroupingUtil.ParentAcctObj>();
        map<String, list<ClsAPLEntityTypes.AcctGroupingTerritroy>> map_managerType_list_Codes = new map<String, list<ClsAPLEntityTypes.AcctGroupingTerritroy>>();
//      this.list_accts = new list<ClsAcctGroupingUtil.ParentAcctObj>();
        this.isShowPopup = ClsAcctGroupingUtil.checkIfRelayOrAM(acctManagerId, map_managerType_list_Codes, pageConf);
        
        if(!this.isShowPopup && pageConf.territoryCode != null && pageConf.territoryCode != '') {
            if(!pageConf.isFrozen) {
            	map_managerType_list_Codes.clear();
            }
            ClsAcctGroupingUtil.getAcctHieraychy(acctManagerId, list_accts, pageConf);
            this.str_jsonAccts = json.serialize(list_accts);
        }
        this.str_mapTypeCodes = json.serialize(map_managerType_list_Codes);
        
        
        
 //     ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'str_jsonAccts :: ' + this.str_jsonAccts));
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
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.info, 'pageConf.territoryCode :: ' + pageConf.territoryCode));
        this.str_jsonAccts = '';
        list<ClsAcctGroupingUtil.ParentAcctObj> list_accts = new list<ClsAcctGroupingUtil.ParentAcctObj>();
        if(pageConf.territoryCode != null && pageConf.territoryCode != '') {
            ClsAcctGroupingUtil.getAcctHieraychy(acctManagerId, list_accts, pageConf);
        }
        this.str_jsonAccts = json.serialize(list_accts);
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.info, 'list_accts :: ' + list_accts));
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
    public list<String> getlist_currencyIsoCodes() {
        list<String> list_currencyIsoCodes = new list<String>();
        for(CurrencyType cuencyType : [Select ConversionRate, IsoCode 
                                       From CurrencyType
                                       Where IsActive = true
                                       order by IsoCode]) {
            
            list_currencyIsoCodes.add(cuencyType.IsoCode);                  
        }
        return list_currencyIsoCodes;
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
    public void saveAcctGroup() { 
    	pageConf.isStop = false;
        try{
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.error, 'isUpdateAccount() :: ' + isUpdateAccount()));
            //Check if the accounts are changed
            if(!isUpdateAccount()){
                searchGroupsAccounts();     // reload tree
                return;
            }
            /*
            //save account grouping
            ClsAcctGroupingUtil.updateAcctForGrouping(pageConf);
            */
            //update apl sales forecast if related account currency changed
            ClsAcctGroupingUtil.updateAcctForecast(pageConf);
            if(pageConf.str_lastAcctForecastId == '') { 
                searchGroupsAccounts();
            }
        }catch(Exception e){
        	pageConf.isStop = true;
        	searchGroupsAccounts();
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.error, e+''));
        }
    }
    
    /**
    * This method is used to forecast component
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
    public void nextForecast(){
    	pageConf.isStop = false;
        try {
        	
            //Check if the accounts are changed
            if(!isUpdateAccount()){
                renderednComponent();
                return;
            }
            /*
            //update account grouping info
            ClsAcctGroupingUtil.updateAcctForGrouping(pageConf);
            */  
            //update apl sales forecast if related account currency changed
            ClsAcctGroupingUtil.updateAcctForecast(pageConf);
            //jump into sales forecast page after update
            if(pageConf.str_lastAcctForecastId == '') { 
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'pageConf.str_lastAcctForecastId :: ' + pageConf.str_lastAcctForecastId));
                renderednComponent();
            }
            
            
        }
        catch(Exception ex) {
            pageConf.isStop = true;
            searchGroupsAccounts();
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
        }
        
    }
    
    /**
    * This method is used to account grouping component
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
    public void backForecast(){ //show account tree component

        //init();
        searchGroupsAccounts();
        ctrl.isRendered_tree = true;
        ctrl.isRendered_am = false;
        ctrl.isRendered_relay = false;
    }
    
    /**
    * This method is used to account grouping component
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
    public void updateAPLSalesFCForSave(){  
    	pageConf.isStop = false;
        try {
        //update apl sales forecast for related account
	        ClsAcctGroupingUtil.updateAcctForecast(pageConf);
	    //  ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'pageConf.str_lastAcctForecastId :: ' + pageConf.str_lastAcctForecastId));
	        if(pageConf.str_lastAcctForecastId == '') {     //refresh grouping page with latest data
	            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'pageConf.str_lastAcctForecastId :: ' + pageConf.str_lastAcctForecastId));
	            if(!pageConf.isRelay) {
	            	init();
	            }
	        }
        }
        catch(Exception ex) {
        	pageConf.isStop = true;
        	searchGroupsAccounts();
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
        }
    }
    
    /**
    * This method is used to account grouping component
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
    public void updateAPLSalesFCForNext(){  
    	pageConf.isStop = false;
    	try {
	        ClsAcctGroupingUtil.updateAcctForecast(pageConf);
	        
	        if(pageConf.str_lastAcctForecastId == '') { //jump into sales forecast page after update
	            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'pageConf.str_lastAcctForecastId :: ' + pageConf.str_lastAcctForecastId));
	            if(!pageConf.isRelay) {
	            	renderednComponent();
	            }
	        }
    	}
    	catch(Exception ex) {
    		pageConf.isStop = true;
    		searchGroupsAccounts();
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
    	}
    }
    
    /**
    * This method is used to account grouping component
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
    public void removeRelayOtherFCForSave(){  
    	pageConf.isStop = false;
        try {
        //update apl sales forecast for related account
	        ClsAcctGroupingUtil.removeRelayOtherFC(pageConf);
	    //  ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'pageConf.str_lastAcctForecastId :: ' + pageConf.str_lastAcctForecastId));
	        if(pageConf.str_lastRemoveId == '') {     //refresh grouping page with latest data
	            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'pageConf.str_lastAcctForecastId :: ' + pageConf.str_lastAcctForecastId));
	            init();
	        }
        }
        catch(Exception ex) {
        	pageConf.isStop = true;
        	searchGroupsAccounts();
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
        }
    }
    
    /**
    * This method is used to account grouping component
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
    public void removeRelayOtherFCForNext(){  
    	pageConf.isStop = false;
    	try {
	        ClsAcctGroupingUtil.removeRelayOtherFC(pageConf);
	        
	        if(pageConf.str_lastRemoveId == '') { //jump into sales forecast page after update
	            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'pageConf.str_lastAcctForecastId :: ' + pageConf.str_lastAcctForecastId));
	            renderednComponent();
	        }
    	}
    	catch(Exception ex) {
    		pageConf.isStop = true;
    		searchGroupsAccounts();
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
    	}
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
    public CtrlAccountGrouping getThis() { 
        return this;    
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
    public void frozenNext() {
    	renderednComponent();
    	
    }    
    
    
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
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
    private void renderednComponent(){
        this.str_jsonAccts = '';
        if(pageConf.isRelay){
            ctrl.relay_fc.pageConf = new ClsAPLEntityTypes.PageConfig();
            ctrl.relay_fc.pageConf.isFrozen = this.pageConf.isFrozen; 
            ctrl.relay_fc.pageConf.currentTerritoryCode = this.pageConf.territoryCode;
            ctrl.isRendered_relay = true;   //show relay component
            ctrl.isRendered_am = false;
            ctrl.isRendered_tree = false;
            ctrl.relay_fc.initForecast();
            try{
            	this.chartURL = APL_CtrlChart.enCodeUrl('Relay',  this.pageConf.territoryCode, UserInfo.getUserId());
            }catch(Exception ex) {
            	
            }
            return;
        }
        ctrl.am_fc.pageConf = new ClsAPLEntityTypes.PageConfig();
        ctrl.am_fc.pageConf.isFrozen = this.pageConf.isFrozen; 
        ctrl.am_fc.pageConf.currentTerritoryCode = this.pageConf.territoryCode;
        ctrl.isRendered_am = true;      //show am component
        ctrl.isRendered_relay = false;
        ctrl.isRendered_tree = false;
        ctrl.am_fc.initForecast();
        try{
            	this.chartURL = APL_CtrlChart.enCodeUrl('AM',  this.pageConf.territoryCode, UserInfo.getUserId());
            }catch(Exception ex) {
            	
            }
        system.debug('!@#ctrl.am_fc.initForecast()');
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
    private Boolean isUpdateAccount(){
        Boolean isUpdata = true;
        try{
            list<ClsAcctGroupingUtil.ParentAcctObj> list_accts2Save = (list<ClsAcctGroupingUtil.ParentAcctObj>)Json.deserialize(this.str_jsonAccts, list<ClsAcctGroupingUtil.ParentAcctObj>.class);
            system.debug('list_accts2Save :: ' + list_accts2Save);
            ClsAcctGroupingUtil.checkAcctIsChanged(list_accts2Save, pageConf);
            
            //update accounts if changed
            if(pageConf.set_modifiedAcctIds.isEmpty()) {
                isUpdata = false;
            }
        }catch(Exception ex){
            isUpdata = false;
            throw ex;
        }
        return isUpdata;
    }

    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>InnerClass*/
    
    public class ForecastCtrl{
        
        public CtrlGroupingAMForecast am_fc {get;set;}
        public CtrlGroupingRelayForecast relay_fc {get;set;}
        public Boolean isRendered_am {get;set;}
        public Boolean isRendered_relay {get;set;}
        
        public Boolean isRendered_tree {get;set;}
        public ForecastCtrl(){
            this.isRendered_tree = true;
            
            this.isRendered_am = false;
            this.isRendered_relay = false;
            this.am_fc = new CtrlGroupingAMForecast('');
            this.relay_fc = new CtrlGroupingRelayForecast('');
        }
        
    }
    
    
    public class PageConfig {
        public String str_jsonAcctGroupSave {get; set;}
        public boolean isRelay {get; set;}
        public String territoryCode {get; set;}
        public set<String> set_modifiedAcctIds {get; set;}
        public map<String, String> map_acctId_currencyCode {get; set;}
        public String str_lastAcctForecastId {get; set;}
        public map<String, Account> map_acctId_acct {get; set;}
        public boolean isFrozen {get; set;}
        public boolean isStop {get; set;}
        public String str_lastRemoveId {get; set;}
        public String currentYear{get; set;}
        public String currentQuarter{get; set;}
        
        public PageConfig() {
            this.str_jsonAcctGroupSave = '';
            this.isRelay = false;
            this.territoryCode = '';
            this.set_modifiedAcctIds = new set<String>();
            this.str_lastAcctForecastId = '';
            this.map_acctId_currencyCode = new map<String, String>();
            this.map_acctId_acct = new map<String, Account>();
            this.isFrozen = false;
            this.isStop = false;
            this.str_lastRemoveId = '';
            this.currentYear = '';
            this.currentQuarter = '';
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