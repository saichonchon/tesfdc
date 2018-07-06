/**
 *  Ctrl class for CSD_CtrlGAMViewForecast
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
public without sharing class CSD_CtrlGAMViewForecast extends CSD_CtrlForecastRemoteBase {
        
         //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        public transient CSD_ClsEntityType.LocaleConfig lc {get;set;}

        public transient CSD_ClsEntityType.PageConfig pageConf {get; set;}
        
        public transient list<CSD_ClsEntityType.DateItem> list_allDateItems {get; set;}
        
        public transient list<CSD_ClsEntityType.CSDColumn> list_TotalColumns {get;set;}
        public transient list<CSD_ClsEntityType.CSDColumn> list_OEMColumns {get;set;}
        public transient list<CSD_ClsEntityType.CSDColumn> list_RegionColumns {get;set;}
        public transient list<CSD_ClsEntityType.CSDColumn> list_SoldToColumns {get;set;}
        public transient list<CSD_ClsEntityType.CSDColumn> list_PartColumns {get;set;}
        
        public transient list<Object> list_OEMData {get;set;}
        public transient String jsonchannel {get;set;}
        public transient String jsonmonthspercent {get;set;}
        public transient String jsonAttention {get;set;} // REQ_00842 cutoff date 
        public CSD_Interface.ACSDCtrlService csdService {get;set;}

        {
                
                this.lc = new CSD_ClsEntityType.LocaleConfig();
                CSD_ClsUtils.setUserLocale(this.lc, userInfo.getLocale());      //set user locale
        }
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
        public CSD_CtrlGAMViewForecast(){
                
                this.csdService = new CSD_ClsGAMViewService();  //init gam service interface
                initCSD();
                
        }
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************

        public CSD_CtrlGAMViewForecast getThis(){
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
                        
                        this.pageConf = new CSD_ClsEntityType.PageConfig();
                        this.pageConf.managerId = UserInfo.getUserId();
                        this.csdService.setPageConf(this.pageConf);
                        
                        //this.setTotalColumns();
                        this.list_TotalColumns = new list<CSD_ClsEntityType.CSDColumn>();
                        this.setOEMColumns();
                        this.setRegionColumns();
                        this.setSoldToColumns();
                        this.setPartColumns();
                        system.debug('@#pageconf:'+pageconf);
                        
                        this.setList_allDateItems();
                        this.setList_OEMData();
                        this.jsonchannel = this.csdService.setChannelForecast(this.pageConf);
                        map<Integer, decimal> map_month_Percent = new map<Integer, decimal>();
            CSD_ClsUtils.setStatisticalPercentMap(map_month_Percent);
            this.jsonmonthspercent = Json.serialize(map_month_Percent);
            // REQ_00842 cutoff date added by padmaja
                        this.jsonAttention = CSD_ClsUtils.getAttentionString();
                        if(list_OEMData.size() < 1) {
                                
                                this.list_allDateItems.clear();
                                this.pageConf.str_tableHead = 'null';
                        }
                        system.debug('@#list_allDateItems:'+list_allDateItems);
                        system.debug('@#list_OEMData:'+list_OEMData);
                }
                catch(Exception ex) {
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
        public void setList_allDateItems(){
                this.list_allDateItems = new list<CSD_ClsEntityType.DateItem>();
                this.csdService.setAllDateItems(this.pageConf, this.list_allDateItems);
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
        public void setList_OEMData(){
                this.list_OEMData = new list<Object>();
                csdService.setLevel1Data(this.list_OEMData, this.pageConf);
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
                this.csdService.setLevel1Row(this.list_OEMColumns);
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
        public void setRegionColumns(){
                this.list_RegionColumns = new list<CSD_ClsEntityType.CSDColumn>();
                this.csdService.setLevel2Row(this.list_RegionColumns);
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
                this.csdService.setLevel3Row(this.list_SoldToColumns);
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
                this.csdService.setLevel4Row(this.list_PartColumns);
        }

        
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
        //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
        

        
    
    
    
    
}