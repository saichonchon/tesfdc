/**
 *  Controll class for page CtrlRSMForecast
 *
 @author    Yuda Zheng
 @created   2013-09-30
 @version   1.0
 @since     27.0 (Force.com ApiVersion)
 *
 @changelog
 * 2013-09-30 Yuda Zheng <yuda.zheng@itbconsult.com>
 * - Created
 */

public without sharing class CtrlRSMForecast {
   
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //public list<Forecast_Definition__c> list_fDefinition {get; set;}
    //public List<String> list_category {get; set;}
    public String category_a {get; set;}
    public String category_b {get; set;}
    public String category_channel {get; set;}
    public String str_selectedCmt {get; set;}
    //public Map<String, Map<String, List<CtrlRSMForecast.DefinitionItem>>> map_categoryItems {get; set;}
    //public List<RSMItem> list_RSMItems {get; set;}
    transient public LocaleConfig lc {get; set;}
    transient public String jsonSaveData {get;set;}
    transient public list<Comment> list_comments {get;set;}
    transient public list<Comment> list_asmComments {get;set;}
    transient public list<Comment> list_asmHoverTopComments {get;set;}
    transient public list<Comment> list_asmHoverBottomComments {get;set;}
    transient public String str_asmComtOverSearch {get;set;}
    public List<DateItem> list_dateItems {get; set;}
    public Map<String, List<DateItem>> map_dateItems {get; set;}
    public List<DateItem> list_allDateItems {get; set;}
    
    public Map<String, List<RSMDefinitionItem>> map_totalItems {get; set;}
    public Map<String, List<RSMDefinitionItem>> map_rSMDefinitionItems {get; set;}
    public Map<String, Map<String, List<RSMDefinitionItem>>> map_otherItems {get; set;}
    public Map<String, List<String>> map_otherLabel {get; set;}
    
    public List<String> list_regions {get; set;}
    //public List<String> list_pcenters {get; set;}
    public List<String> list_pcenter_region {get; set;}
    public Map<String, List<String>> map_regionPcenters {get; set;}
    
    public String regionCenters {get; set;}
    public String queryStrForBBBM {get; set;}   
    public String queryStrForScheduled {get; set;}
    public Boolean editable {get; set;}
    public map<String, map<String, list<Comment>>> map_fcDefId_fiscalDate_listComts {get; set;}
    public String str_comment2Save {get; set;}
    public String str_comment2Delete {get; set;}
    public String str_asmComtSearch {get; set;}
    public set<String> set_dateKey {get; set;}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private Id userId;
    private List<Forecast_Definition__c> list_fDefinition;
    private Map<String, Map<String, List<Forecast_Definition__c>>> map_regionPcenterDefinitions;
    private String region;
    private String pcenter;
    //private List<String> list_pcenter;
    private Map<String, Set<Integer>> map_financialMonth;
    //Added for IND_Customer_Classification__c
    
    //End
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
   
    public CtrlRSMForecast() {
        try{
            category_a = 'A';
            category_b = 'B';
            category_channel = 'Channel';
            this.lc = new LocaleConfig();
            userId = userInfo.getUserId();
            this.str_selectedCmt = '';
            this.map_fcDefId_fiscalDate_listComts = new map<String, map<String, list<Comment>>>();
            str_comment2Save = '';
            str_comment2Delete = '';
            str_asmComtSearch = '';
            //used for generate bbb monthly query by every month
            set_dateKey = new set<String>();
            //userId = '005E0000000XvjFIAS';      //Gregor Scholz, only for RSM testing 
            //list_fDefinition = ClsRSMForecastUtil.getForecastDefinition(userId);
            map_regionPcenterDefinitions = new Map<String, Map<String, List<Forecast_Definition__c>>>();
            list_pcenter_region = new List<String>();
            map_regionPcenters = new Map<String, List<String>>();
            //list_pcenters = new List<String>();
            ClsRSMForecastUtil.createDefinition(userId, map_regionPcenterDefinitions, map_regionPcenters, list_pcenter_region);
                  
            list_dateItems = new List<DateItem>();
            map_dateItems = new Map<String, List<DateItem>>();
            list_allDateItems = new List<DateItem>();
            ClsRSMForecastUtil.createDateItem(list_dateItems, map_dateItems, list_allDateItems, '');
            
            map_financialMonth = ClsRSMForecastUtil.map_financialMonth;
            editable = ClsRSMForecastUtil.checkFrozenDate();
            ClsRSMForecastUtil.setDateKey(map_financialMonth, set_dateKey);
        //    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'set_classifications:' + set_classifications));
            
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, e+''));         
        }
        //ClsRSMForecastUtil.setCurrent(this);
        //map_financialMonth = new map<String, Set<Integer>>();
        //ClsRSMForecastUtil.setfinancialMonths(map_financialMonth);
        
        
        //createRSMItems();

        /**try {
            init();     
        }
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, ex.getStackTraceString()));
        }
        **/
    }
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
    /**
    * This method get controller
    *
    @author Minghao Li
    @created 2013-11-29
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    @return             CtrlRSMForecast
    *
    @changelog
    * 2013-11-29 Minghao Li <minghao.li@itbconsult.com>
    * - Created
    */
    public CtrlRSMForecast getThis(){
        return this;
    }
    
    public void init(){
        try{
            if(regionCenters != null && regionCenters != '' && regionCenters.indexOf('_') > 0) {
                pcenter = regionCenters.substring(0, regionCenters.indexOf('_'));
                region = regionCenters.substring(regionCenters.indexOf('_') +1);                
                //list_pcenter = regionCenters.substring(regionCenters.indexOf('_') +1).split('_');
            }
            
            map<String, String> map_fiscalDate_bbbMQuery = new map<String, String>();
            map<String, String> map_fiscalDate_scheduledQuery = new map<String, String>();
            
            set<String> set_classifications = new set<String>();
            if(map_regionPcenterDefinitions != null && !map_regionPcenterDefinitions.isEmpty()) {
                map_regionPcenterDefinitions.clear();
                ClsRSMForecastUtil.createDefinition(userId, map_regionPcenterDefinitions, map_regionPcenters, list_pcenter_region);
            }
            list_fDefinition = ClsRSMForecastUtil.getChoosenDefinition(map_regionPcenterDefinitions, region, pcenter, set_classifications);      
            
            list_dateItems.clear();
            map_dateItems.clear();
            list_allDateItems.clear();
            ClsRSMForecastUtil.createDateItem(list_dateItems, map_dateItems, list_allDateItems, region);
            
            map<String, String> map_classifications = new map<String, String>();
            list<String> list_classifications = new list<String>();
            list_classifications.addAll(set_classifications);
            for(Integer i=0, max=list_classifications.size(); i<max; i+=1){
                map_classifications.put(list_classifications[i], ('cls_'+i+'_ind'));
            }
            set_classifications.clear();
            
            
            map_rSMDefinitionItems = new Map<String, List<RSMDefinitionItem>>();
            map_rSMDefinitionItems.put(category_a, new List<RSMDefinitionItem>());
            map_rSMDefinitionItems.put(category_b, new List<RSMDefinitionItem>());
            map_rSMDefinitionItems.put(category_channel, new List<RSMDefinitionItem>());
            map_otherItems =  new Map<String, Map<String, List<RSMDefinitionItem>>>(); 
            map_otherItems.put(category_a, new Map<String, List<RSMDefinitionItem>>());
            map_otherItems.put(category_b, new Map<String, List<RSMDefinitionItem>>());
            map_otherItems.put(category_channel, new Map<String, List<RSMDefinitionItem>>());
            map_totalItems = new Map<String, List<RSMDefinitionItem>> ();
            map_totalItems.put(category_a, new List<RSMDefinitionItem>());
            map_totalItems.put(category_b, new List<RSMDefinitionItem>());
            map_totalItems.put(category_channel, new List<RSMDefinitionItem>());
            
            
            ClsRSMForecastUtil.getRSMDefinitionItemMap(list_fDefinition, map_rSMDefinitionItems, map_totalItems, map_otherItems, map_classifications);
            //ClsRSMForecastUtil.getRSMDefinitionItemMap(list_fDefinition, map_rSMDefinitionItems);
            map_otherLabel = new map<String, list<String>>();
            for (String category : map_otherItems.keySet()) {
                map_otherLabel.put(category, new List<String>());
                if(map_otherItems.get(category) != null) {
                    map_otherLabel.get(category).addAll(map_otherItems.get(category).keySet());
                }
            }
            
            list<ConnectionSql> list_bbbSql = new list<ConnectionSql>();
            list<ConnectionSql> list_scheduleSql = new list<ConnectionSql>();
                
            if(!map_classifications.isEmpty()){
                //for(String key : map_classifications.keySet()){
                    for(String dateKey : set_dateKey) {
                        String map_key = 'bbb@' + dateKey;
                        map_fiscalDate_bbbMQuery.put(map_key, ClsRSMForecastUtil.getQueryStrForBBBM(dateKey, region, pcenter));
                    }
                    //list_bbbSql.add(new ConnectionSql(map_classifications.get(key), ClsRSMForecastUtil.getQueryStrForBBBM(region, pcenter, map_financialMonth, key)));
                //}
                //for(String key : map_classifications.keySet()){
                    for(String dateKey : set_dateKey) {
                        String map_key = 'sch@' + dateKey;
                        map_fiscalDate_scheduledQuery.put(map_key, ClsRSMForecastUtil.getQueryStrForScheduledAgreements(dateKey, region));
                    }
                    //list_scheduleSql.add(new ConnectionSql(map_classifications.get(key), ClsRSMForecastUtil.getQueryStrForScheduledAgreements(region, map_financialMonth, key)));
                //}
            }
            this.queryStrForBBBM = Json.serialize(map_fiscalDate_bbbMQuery);
            this.queryStrForScheduled = Json.serialize(map_fiscalDate_scheduledQuery);
            if(!editable) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, system.label.FinancialPlan_Msg4Closed));
            }
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'queryStrForBBBM:' + queryStrForBBBM));
            
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'queryStrForBBBM:' + queryStrForBBBM));
            
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, e+''));         
        }
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'queryStrForBBBM:' + queryStrForBBBM));
    }
    
    /**
    * This method save rsm forecast
    *
    @author Minghao Li
    @created 2013-11-29
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2013-11-29 Minghao Li <minghao.li@itbconsult.com>
    * - Created
    */
    public void saveForecast(){
        try{
            List<RSMForecastItem> list_rsm = new List<RSMForecastItem>();
            
            parseJSON(list_rsm, this.jsonSaveData);
            
            if(list_rsm != null && list_rsm.size() > 0) {
                 ClsRSMForecastUtil.saveRSMForecast(list_rsm);
            }
  
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Save Successful!'));
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, e+''));
        }
    }
    
    /**
    * This method get RSM fields
    *
    @author Minghao Li
    @created 2013-11-29
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    @return             list<RSMForecastFields>
    *
    @changelog
    * 2013-11-29 Minghao Li <minghao.li@itbconsult.com>
    * - Created
    */
    public list<RSMForecastFields> getAFields(){
        return getRSM_Fields(true);
    }
    /**
    * This method get RSM outher fields
    *
    @author Minghao Li
    @created 2013-11-29
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    @return             list<RSMForecastFields>
    *
    @changelog
    * 2013-11-29 Minghao Li <minghao.li@itbconsult.com>
    * - Created
    */
    public list<RSMForecastFields> getOthFields(){
        return getRSM_Fields(false);
    }
    public void  actionComments() {
        this.list_asmComments = new list<Comment>();
        this.list_comments = new list<Comment>();
        //getComments();
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'list_comments :: ' + list_comments));
    }
    public list<Comment> getComments() {
        map<String, String> map_fcDefId_date = new map<String, String>();
        String fcDefId = '';
        String fiscalDate = '';
        try {
            if(str_selectedCmt != '') {
                map_fcDefId_date = (map<String, String>)JSON.deserializeStrict(str_selectedCmt, map<String, String>.class);
                for(String fcDef : map_fcDefId_date.keySet()) {
                    fcDefId = fcDef;
                    fiscalDate = map_fcDefId_date.get(fcDefId);
                }
                ClsRSMForecastUtil.getMFComments(fcDefId, fiscalDate, list_comments);
            }
        }
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex+''));
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getStackTraceString()));
        }
        return list_comments;
    }
    
    public void saveComments() {
        try {
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'str_comment2Save ::' + str_comment2Delete));
            map<String, String> map_fcDefId_fiscalDate2Delete = new map<String, String>();
            map_fcDefId_fiscalDate_listComts = new map<String, map<String, list<Comment>>>();
                if(str_comment2Save != '') {
                map_fcDefId_fiscalDate_listComts = (map<String, map<String, list<Comment>>>) Json.deserializeStrict(str_comment2Save, map<String, map<String, list<Comment>>>.class);
                }
            if(str_comment2Delete != '') {
                map_fcDefId_fiscalDate2Delete = (map<String, String>) Json.deserializeStrict(str_comment2Delete, map<String, String>.class);
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'str_comment2Delete ::' + str_comment2Delete));
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'map_fcDefId_fiscalDate2Delete ::' + map_fcDefId_fiscalDate2Delete));
            }

            ClsRSMForecastUtil.saveComments(map_fcDefId_fiscalDate_listComts, map_fcDefId_fiscalDate2Delete);
            str_comment2Save = '';
            map_fcDefId_fiscalDate_listComts.clear();
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Save Successful!'));
        }
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex+''));
        }
    }
    public list<Comment> getASMComments() {
        
        try {
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'str_asmComtSearch ::' + str_asmComtSearch));
            if(str_asmComtSearch == null || str_asmComtSearch == '') {
                return null;
            }
            ASMCommentSearch searchObj = (ASMCommentSearch) Json.deserializeStrict(str_asmComtSearch, ASMCommentSearch.class);
            if(searchObj.cls1 == '' || searchObj.cls2 == '') {
                return null;
            }
            ClsRSMForecastUtil.getASMComments(map_rSMDefinitionItems.get(searchObj.cls1), searchObj, this.list_asmComments, region, pcenter);
        }
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex+''));
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getStackTraceString()));
        }
        return this.list_asmComments;
    }
    public void actionASMHoverComt() {
        try {
            this.list_asmComments = new list<Comment>();
            this.list_asmHoverBottomComments = new list<Comment>();
            this.list_asmHoverTopComments = new list<Comment>();
            list<Comment> list_tempComts = new list<Comment>();
            str_asmComtSearch = str_asmComtOverSearch;
            list_tempComts = getASMComments();
            if(list_tempComts.isEmpty()) {
                return;
            }
            for(Integer counter = 1 ;counter <= list_tempComts.size() ; counter ++) {
                if(counter <= 5) {
                    this.list_asmHoverTopComments.add(list_tempComts[counter - 1]);
                }
                else if(counter > 5 && (list_tempComts.size() - counter) < 5) {
                    this.list_asmHoverBottomComments.add(list_tempComts[counter - 1]);
                }
    
            }
        }
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex+''));
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getStackTraceString()));
        }
    }
    public list<Comment> getTopASMComts() {
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'list_asmHoverBottomComments :: ' + list_asmHoverBottomComments));
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'list_asmHoverTopComments :: ' + list_asmHoverTopComments));
        return this.list_asmHoverTopComments;
    }
    public list<Comment> getBottemASMComts() {
        return this.list_asmHoverBottomComments;
    }
    public void actionASMComments() {
        //this.list_asmComments = new list<Comment>();
    }
    public String getColorConfig() {
        list<ColorConfig> list_colorConf = new list<ColorConfig>();
        ClsRSMForecastUtil.getRSMColorConfigFromSetting(list_colorConf);
        return Json.serialize(list_colorConf);
    }
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- ********************************* 
    /**
    * This method get RSM fields
    *
    @author Minghao Li
    @created 2013-11-29
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    @param isTeam       isTeam boolean
    *
    @return             list<RSMForecastFields>
    *
    @changelog
    * 2013-11-29 Minghao Li <minghao.li@itbconsult.com>
    * - Created
    */
    private list<RSMForecastFields> getRSM_Fields(Boolean isTeam){
        list<RSMForecastFields> list_t = new list<RSMForecastFields>();
        list_t.add(new RSMForecastFields(Label.rsm_Previous_Month_Forecast, false, 'pmfc', 'pd_l_1', 'innobg', ''));
        list_t.add(new RSMForecastFields(Label.rsm_AM_Forecast_Total, true, 'amfc', 'eve pd_l_1', '', ''));
        if(isTeam){
            list_t.add(new RSMForecastFields(Label.rsm_Industrial_Sales_Team, false, 'amfcin', 'pd_l_2', 'amfc sbcell', ''));
            list_t.add(new RSMForecastFields(Label.rsm_Other_BU_Sales_Team, false, 'amfcoth', 'eve pd_l_2', 'amfc sbcell', ''));
        }
        list_t.add(new RSMForecastFields(Label.rsm_Demand_Shipped, true, 'bling', 'pd_l_1', '', ''));
        if(isTeam){
            list_t.add(new RSMForecastFields(Label.rsm_Industrial_Sales_Team, false, 'blingin', 'eve pd_l_2', 'bling sbcell', ''));
            list_t.add(new RSMForecastFields(Label.rsm_Other_BU_Sales_Team, false, 'blingoth', 'pd_l_2', 'bling sbcell', ''));
        }       
        list_t.add(new RSMForecastFields(Label.rsm_Book_to_Bill, false, 'btb', 'eve pd_l_1', '', ''));
        
        list_t.add(new RSMForecastFields(Label.rsm_Demand_Open, false, 'blog', 'pd_l_1', 'innobg', ''));
        list_t.add(new RSMForecastFields(Label.rsm_orders, true, 'blogorder', 'eve pd_l_2', 'innobg', ''));
        if(isTeam){
            list_t.add(new RSMForecastFields(Label.rsm_Industrial_Sales_Team, false, 'blogorderin', 'pd_l_3', 'innobg blogorder sbcell', ''));
            list_t.add(new RSMForecastFields(Label.rsm_Other_BU_Sales_Team, false, 'blogorderoth', 'eve pd_l_3', 'innobg blogorder sbcell', ''));
        }       
        list_t.add(new RSMForecastFields(Label.rsm_Scheduling_Agreements, true, 'blogsched', 'pd_l_2', 'innobg', ''));
        if(isTeam){
            list_t.add(new RSMForecastFields(Label.rsm_Industrial_Sales_Team, false, 'blogschedin', 'eve pd_l_3', 'innobg blogsched sbcell', ''));
            list_t.add(new RSMForecastFields(Label.rsm_Other_BU_Sales_Team, false, 'blogschedoth', 'pd_l_3 ', 'innobg blogsched sbcell', ''));
        }       
        list_t.add(new RSMForecastFields(Label.rsm_Currency, true, 'currencytotal', 'eve pd_l_1', 'innobg', ''));
        if(isTeam){
            list_t.add(new RSMForecastFields(Label.rsm_Industrial_Sales_Team, false, 'currencytotalin', 'pd_l_2', 'innobg currencytotal sbcell', ''));
            list_t.add(new RSMForecastFields(Label.rsm_Other_BU_Sales_Team, false, 'currencytotaloth', 'eve pd_l_2', 'innobg currencytotal sbcell', ''));
        }
        list_t.add(new RSMForecastFields(Label.rsm_2M_Accuracy, false, 'ac2m', 'pd_l_1 ', ' percenttotal', ''));
        list_t.add(new RSMForecastFields(Label.rsm_6M_Accuracy, false, 'ac6m', 'eve pd_l_1', ' percenttotal ', ''));
        list_t.add(new RSMForecastFields(Label.rsm_Quarterly_Accuracy, false, 'acquart', 'pd_l_1', ' percenttotal ', 'border_b'));
        return list_t;
    }
    /**
    private void createRSMItems() {
        list_RSMItems = new list<RSMItem>();
        for (Forecast_Definition__c fDefinition : list_fDefinition) {
            RSMItem rSMItem = new RSMItem();
            rSMItem.name = fDefinition.Name != null ? fDefinition.Name : '';
            rSMItem.category = fDefinition.Category__c != null ? fDefinition.Category__c : '';
            rSMItem.sequence = fDefinition.RSM_Se_quence__c != null ? fDefinition.RSM_Se_quence__c : 0;
            rSMItem.subtotal = fDefinition.Subtotal__c != null ? fDefinition.Subtotal__c : false;
            rSMItem.profitCenter = fDefinition.Profit_Center__c != null ? fDefinition.Profit_Center__c : '';            
            rSMItem.industrialSalesTeamInclude = fDefinition.Industrial_Sales_Team_Include__c != null ? fDefinition.Industrial_Sales_Team_Include__c : '';
            //rSMItem.acctFilterCriteria = ClsRSMForecastUtil.getAccountFilterCriteria(fDefinition);
            list_RSMItems.add(rSMItem);
        }
    }**/
    
    
    
    /**
    * method used the parse json object
    *
    @author minghao.li@itbconsult.com
    @created 2013-06-11
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @changelog
    * 2013-06-11 Minghao Li <minghao.li@itbconsult.com>
    * - Created
    */
    private void parseJSON(list<RSMForecastItem> list_tp, String sJson){
        JSONParser parser = JSON.createParser(sJson);
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) { // Start at the array of invoices. 
                while (parser.nextToken() != null) {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        RSMForecastItem cc= (RSMForecastItem)parser.readValueAs(CtrlRSMForecast.RSMForecastItem.class);
                        list_tp.add(cc);
                        parser.skipChildren();
                    }
                }
            }
        }
    }
    
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>InnerClass*/
    
    public class RSMForecastFields{
        transient public String labelName {get;set;}
        transient public String cls {get;set;}
        transient public String cls1 {get;set;}
        transient public String cls2 {get;set;}
        transient public String cls3 {get;set;}
        transient public Boolean isShow {get;set;}
        
        public RSMForecastFields(String labelName, Boolean isShow, String cls, String cls1, String cls2, String cls3){
            this.labelName = labelName;
            this.isShow = isShow;
            this.cls = cls;
            this.cls1 = cls1;
            this.cls2 = cls2;
            this.cls3 = cls3;
        }
    }
    public class ASMCommentSearch {
        public String cls1, cls2, cls3, cls4, cls5;
    }
    public class ConnectionSql {
        public String pSql {get;set;}
        public String sqlCls {get;set;}
        public ConnectionSql(String sqlCls, String pSql){
            this.sqlCls = sqlCls;
            this.pSql = pSql;
        }
    }
    
    public class RSMForecastItem {
        public Decimal billings {get; set;}
        public Decimal bookings {get; set;}
        public Decimal rsmForecast {get; set;}
        public Decimal asmForecast {get; set;}
        public String definition {get; set;}
        public String fiscalDate {get; set;}
    }

    public class RSMDefinitionItem {
        public String id {get; set;}
        public String name {get; set;}
        public String category {get; set;}
        public Decimal sequence {get; set;}
        public String label {get; set;}
        public Boolean subtotal {get; set;}
        public String profitCenter {get; set;}
        public String categoryInclude {get; set;}
        public String categoryExclude {get; set;}
        public String industrialSalesTeamInclude {get; set;}
        public String classifications {get;set;}
        public String oldClassifications {get;set;}
        public String managerfc {get;set;}
        public String prevManagerFc {get;set;}
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
    
    public class Comment implements Comparable {
        public String fcDefId {get; set;}
        public String fiscalDate {get; set;}
        public String value {get; set;}
        public String comment {get; set;}
        public String acctName {get; set;}
        public String profitCtr {get; set;}
        
        public Comment() { 
            this.fcDefId = '';
            this.fiscalDate = '';
            this.value = '';
            this.comment = '';
            this.acctName = '';
            this.profitCtr = '';
        }
        public Integer compareTo(Object compareTo) {
        // Your code here
            Comment toComment = (Comment) compareTo;
            double compToVal = ((toComment.value != null && toComment.value != '') ? double.valueOf(toComment.value) : 0);
            double compVal = ((this.value != null && this.value != '') ? double.valueOf(this.value) : 0);
            if (compVal >= compToVal) {
                return 0;
            }
            else 
                return 1;
        }
    }
    
    public class DateItem {
        public String itemName {get; set;}
        public String type {get; set;}
        public String cls {get; set;}
        public String total {get; set;}
        public String visiable {get; set;}
        public Boolean isInput {get; set;}
        public String type1 {get; set;}
        public String type2 {get; set;}
        public String type3 {get; set;}
        public String fYear {get; set;}
        public Integer fMonth {get; set;}
        public Decimal workingDays {get; set;}
        
        public DateItem(String name) {
            itemName = name;
            cls = '';
            total = '';
            type = '';
            type1 = '';
            type2 = '';
            type3 = '';
            visiable = 'true';
            isInput = false;
            fYear = '';
            fMonth = 0;
            workingDays = 0;    
        }
    }
    public class ColorConfig {
        public String colorName {get; set;}
        public String color {get; set;}
        public decimal maxValue {get; set;}
        public decimal minValue {get; set;}
        
        public ColorConfig() {
          this.colorName = '';
          this.color = '';
          this.maxValue = 0;
          this.minValue = 0;
        }
    }
    ///*<<<InnerClass*/
    //********************************* -=END inner classes=- *************************************
}