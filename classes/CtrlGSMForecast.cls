/**
 *  Contains a set of static methods used GSM Forecast VF pages
 *
 @author Bin Yuan
 @created 2013-11-25
 @version 1.0
 @since 28.0 (Force.com ApiVersion)
 *
 @changelog
 * 2013-11-25 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created
 */
public class CtrlGSMForecast {
   
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    transient public LocaleConfig lc {get; set;}
    transient public list<String> list_region {get; set;}
    transient public String selectedRegion {get; set;}
    transient public String saveJSON {get; set;}
    
    transient public String queryStrForBBBM {get; set;}   
    transient public String queryStrForScheduled {get; set;}
    transient public list<Comment> list_comments {get;set;}
    
    public Comment cmtSearchObj {get; set;}
    public String category_a {get; set;}
    public String category_b {get; set;}
    public String category_ab {get; set;}
    public String category_bc {get; set;}
    public String category_channel {get; set;}
    
    public List<DateItem> list_dateItems {get; set;}
    public Map<String, List<DateItem>> map_dateItems {get; set;}
    public List<DateItem> list_allDateItems {get; set;}
    public map<String, list<GSMLineItem>> map_category_list_gsmItems {get; set;}
    
    public map<String, list<GSMDefinitionItem>> map_total_list_gsmDefItems {get; set;}
    
    public map<String, list<GSMLineItem>> map_other_list_gsmItems {get; set;}    
    
    transient public String a_tableJson {get; set;}
    transient public String a_total_tableJson {get; set;}
    transient public String str_list_rows {get; set;}
    //transient public String total_tableJson {get; set;}
    
    
    
    
    /*
    public map<String, map<String,list<GSMDefinitionItem>>> map_category_region_gsmDefs {get; set;}
    public map<String, map<String,list<GSMDefinitionItem>>> map_category_region_otherGSMDefs {get; set;}
    public map<String, map<String,list<GSMDefinitionItem>>> map_category_region_totalGSMDefs {get; set;}
    */
    public PageConfig pageConf {get; set;}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    /**
     * map to store global describtion due to limit on describe methodes.
     */
    private map<String, String> map_urlParams;
    private Id userId;
    private Map<String, Set<Integer>> map_financialMonth;
    private list<Forecast_Definition__c> list_gsmDef = new list<Forecast_Definition__c>();
    private map<String, map<String, set<String>>> map_class_map_region_set_profitCtrs = new map<String, map<String, set<String>>>();
    //private map<String, map<String, map<Integer, GSMSaveItem>>> map_gsmName_year_month_gsmItem = new map<String, map<String, map<Integer, GSMSaveItem>>>();
    map<String, map<String, String>> map_gsmName_date_fc = new map<String, map<String, String>>();
    map<String, map<String, String>> map_gsmName_date_prevFC = new map<String, map<String, String>>();
    private set<String> set_dateKey = new set<String>();
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
   /**
    * The contsructor
    *
    @author Bin Yuan
    @created 2013-11-25
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    @changelog
    * 2013-11-25 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public CtrlGSMForecast() {
        category_a = 'A';
        category_b = 'B';
        category_ab = 'A_B';
        category_bc = 'B_C';
        category_channel = 'Channel';
        this.lc = new LocaleConfig();
        userId = userInfo.getUserId();
        //userId = '005E0000002FFFs';
        pageConf = new PageConfig();
        list_dateItems = new List<DateItem>();
        map_dateItems = new Map<String, List<DateItem>>();
        list_allDateItems = new List<DateItem>();
        cmtSearchObj = new Comment();
        a_tableJson = '';
        a_total_tableJson = '';
        
        map_category_list_gsmItems = new map<String, list<GSMLineItem>>();
        map_total_list_gsmDefItems = new map<String, list<GSMDefinitionItem>>();
        
        map_other_list_gsmItems = new map<String, list<GSMLineItem>>();

        this.list_region = new list<String>{'All'};
        this.selectedRegion = 'All';    //default region value
        try{
            //Create date item
            ClsGSMForecastUtil.setfinancialMonths(pageConf, set_dateKey);
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'map_fiscalDate_bbbMQuery :: ' + map_fiscalDate_bbbMQuery));
            ClsGSMForecastUtil.createWorkingDaysMap(pageConf);
            ClsGSMForecastUtil.createDateItem(list_dateItems, map_dateItems, list_allDateItems, pageConf);
            
            init();
            
        }
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex+''));
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getStackTraceString()));
        }
    }
    

    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
   /**
    * This method is used to 
    *
    @author Bin Yuan
    @created 2013-11-25
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    @param year         year string
    @param ownerId      owner id string
    *
    @return             the visit capacity
    *
    @changelog
    * 2013-11-25 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public void init() {
        try {
            //reset 
            if(map_gsmName_date_fc != null && !map_gsmName_date_fc.isEmpty()) {
                map_gsmName_date_fc.clear();
            }
            if(map_category_list_gsmItems != null && !map_category_list_gsmItems.isEmpty()) {
                map_category_list_gsmItems.clear();
            }
            if(map_total_list_gsmDefItems != null && !map_total_list_gsmDefItems.isEmpty()) {
                map_total_list_gsmDefItems.clear();
            }
            if(map_gsmName_date_prevFC != null && !map_gsmName_date_prevFC.isEmpty()) {
                map_gsmName_date_prevFC.clear();
            }
            list_gsmDef = new list<Forecast_Definition__c>();
            //init gsm definition item
            map_category_list_gsmItems.put(category_a, new list<GSMLineItem>());
            map_category_list_gsmItems.put(category_b, new list<GSMLineItem>());
            map_category_list_gsmItems.put(category_channel, new list<GSMLineItem>());
            //init gsm definition item
            map_total_list_gsmDefItems.put(category_a, new list<GSMDefinitionItem>());
            map_total_list_gsmDefItems.put(category_b, new list<GSMDefinitionItem>());
            map_total_list_gsmDefItems.put(category_ab, new list<GSMDefinitionItem>());
            map_total_list_gsmDefItems.put(category_bc, new list<GSMDefinitionItem>());
            map_total_list_gsmDefItems.put(category_channel, new list<GSMDefinitionItem>());
            
            map<String, String> map_fiscalDate_bbbMQuery = new map<String, String>();
            map<String, String> map_fiscalDate_scheduledQuery = new map<String, String>();
            //get gsm definition
            ClsGSMForecastUtil.getGSMForecastDef(list_gsmDef, userId, selectedRegion, list_region);
            if(list_gsmDef.isEmpty()) {
                return;
            }
            ClsGSMForecastUtil.getGSMManagerForecast(userId, pageConf.map_financialMonth, map_gsmName_date_fc, map_gsmName_date_prevFC);
            //map_class_map_region_set_profitCtrs = new map<String, map<String, set<String>>>();
            //get gsm definition map items
            ClsGSMForecastUtil.getGSMDefinitionItems(list_gsmDef, map_category_list_gsmItems, map_total_list_gsmDefItems, map_other_list_gsmItems, map_gsmName_date_fc, map_gsmName_date_prevFC);
            //build query string
            ClsGSMForecastUtil.getQueryStrForBBBM(set_dateKey, map_fiscalDate_bbbMQuery);
            ClsGSMForecastUtil.getQueryStrForScheduledAgreements(set_dateKey, map_fiscalDate_scheduledQuery);
            this.queryStrForBBBM = Json.serialize(map_fiscalDate_bbbMQuery);
         //   this.queryStrForBBBM = Json.serialize(new map<String, String>{'bbb@2013_12'=> map_fiscalDate_bbbMQuery.get('bbb@2013_12')});
        //    map_fiscalDate_scheduledQuery.clear();
            this.queryStrForScheduled = Json.serialize(map_fiscalDate_scheduledQuery);
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'map_class_map_region_set_profitCtrs :: ' + map_class_map_region_set_profitCtrs));
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'map_fiscalDate_bbbMQuery :: ' + map_fiscalDate_bbbMQuery));
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'map_fiscalDate_scheduledQuery :: ' + map_fiscalDate_scheduledQuery));
        }
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex+''));
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getStackTraceString()));
        }
    }
    
    /**
    * This method is save manager forecast
    *
    @author Bin Yuan
    @created 2013-11-25
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2013-11-25 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public void saveGSMForecast() {
        try{
            list<GSMSaveItem> list_gsm = new list<GSMSaveItem>();
            
            parseJSON(list_gsm, this.saveJSON);
            if(list_gsm.size() > 0) {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.error, 'list_gsm :: ' + list_gsm));
                ClsGSMForecastUtil.saveGSMManagerForecast(userId, pageConf.map_financialMonth, list_gsm);
            }
        } 
        catch(Exception e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e+''));
        }
    }
    
    
   /**
    * This method is used to 
    *
    @author Bin Yuan
    @created 2013-11-25
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    @param year         year string
    @param ownerId      owner id string
    *
    @return             the visit capacity
    *
    @changelog
    * 2013-11-25 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public CtrlGSMForecast getThis() {
        return this;
    }
    
    /**
    * This method get definition fields
    *
    @author Bin Yuan
    @created 2013-11-25
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    @param year         year string
    @param ownerId      owner id string
    *
    @return             the visit capacity
    *
    @changelog
    * 2013-11-25 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public list<DefinitionItemField> getDefinitionTotalField(){
        list<DefinitionItemField> list_dif = new list<DefinitionItemField>{
            new DefinitionItemField(Label.GSM_MyPrevFc, 'c1', 'pmtot', ''),
            new DefinitionItemField(Label.GSM_RsmTotalFc, 'c2', 'rsmtot', ''),
        //    new DefinitionItemField('Total Billings', 'c3', 'billingtot', ''),
            new DefinitionItemField(Label.GSM_Total_DemandShipped, 'c3', 'billingtot', ''),
            new DefinitionItemField(Label.GSM_Demand_Open, 'c4', 'backlogtot', ''),
            new DefinitionItemField(Label.GSM_TotalCurrency, 'c5', 'currencytot', '')
        };
        return list_dif;
    }
    
    /**
    * This method is get region fields
    *
    @author Bin Yuan
    @created 2013-11-25
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    @param year         year string
    @param ownerId      owner id string
    *
    @return             the visit capacity
    *
    @changelog
    * 2013-11-25 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public list<DefinitionItemField> getDefinitionRegionField(){
        list<DefinitionItemField> list_dif = new list<DefinitionItemField>{
            new DefinitionItemField(Label.rsm_Previous_Month_Forecast, 'b1 pd_l_2', 'g1', 'pmfc'),
            new DefinitionItemField(Label.rsm_AM_Forecast_Total, 'b2 pd_l_2', 'g2', 'amfc'),
        //    new DefinitionItemField('Billings', 'b3 pd_l_2', 'g3', 'billing'),
            new DefinitionItemField(Label.rsm_Demand_Shipped, 'b3 pd_l_2', 'g3', 'billing'),
            new DefinitionItemField(Label.rsm_Book_to_Bill, 'b4 pd_l_2', 'g4', 'btbill'),
            new DefinitionItemField(Label.rsm_Demand_Open, 'b5 pd_l_2', 'g5', 'backlog'),
       //     new DefinitionItemField('Order Backlog', 'b6 pd_l_3', 'g6', 'obacklog'),
            new DefinitionItemField(Label.rsm_orders, 'b6 pd_l_3', 'g6', 'obacklog'),
            new DefinitionItemField(Label.rsm_Scheduling_Agreements, 'b7 pd_l_3', 'g7', 'scheduled'),
            new DefinitionItemField(Label.rsm_Currency, 'b8 pd_l_2', 'g8', 'crcy'),
            new DefinitionItemField(Label.rsm_2M_Accuracy, 'b9 pd_l_2', 'g9', 'a2m'),
            new DefinitionItemField(Label.rsm_6M_Accuracy, 'b10 pd_l_2', 'g10', 'a6m'),
            new DefinitionItemField(Label.rsm_Quarterly_Accuracy, 'b11 pd_l_2', 'g11', 'aqty')
        };
        return list_dif;
    }
    public void calcGSMTable() {
        /*
        try {
            str_list_rows = '';
            list<GSMTableCell> list_rows = new list<GSMTableCell>();
            map<String, GSMTableItem> map_totalTable2Return = new map<String, GSMTableItem>();
            map<String, GSMTableItem> map_categroy_totalTab = (map<String, GSMTableItem>) Json.deserialize(a_total_tableJson, map<String, GSMTableItem>.class);
            list<GSMTableItem> list_gsmTab = (list<GSMTableItem>) Json.deserialize(a_tableJson, list<GSMTableItem>.class);
            if(!list_gsmTab.isEmpty()) {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'list_gsmTabs :: ' + list_gsmTabs));
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'aTotal :: ' + aTotal));
                ClsGSMForecastUtil.calcGSMTable(list_gsmTab, map_categroy_totalTab, list_rows);
            }
            if(map_categroy_totalTab.containsKey(category_a) && map_categroy_totalTab.keySet().size() == 1) {
                map_totalTable2Return.put(category_a, map_categroy_totalTab.get(category_a));
            }
            else if(!map_categroy_totalTab.containsKey(category_channel)) {
                map_totalTable2Return.put(category_ab, map_categroy_totalTab.get(category_ab));
            }
            a_total_tableJson = Json.serialize(map_totalTable2Return);
            a_tableJson = Json.serialize(list_rows);
            
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'a_tableJson  :: ' + a_tableJson));
            
            //aTotal = (GSMTableItem) Json.deserialize(a_total_tableJson, GSMTableItem.class);
            //GSMTableItem aTotal = new GSMTableItem();
            //aTotal = (GSMTableItem) Json.deserialize(a_total_tableJson, GSMTableItem.class);
        }
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex+''));
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getStackTraceString()));
        }
        */
    }
    public String getColorConfig() {
        list<ColorConfig> list_colorConf = new list<ColorConfig>();
        ClsGSMForecastUtil.getRSMColorConfigFromSetting(list_colorConf);
        return Json.serialize(list_colorConf);
    }
    public void actionRSMComments() {
        list_comments = new list<Comment>();
    }
    public list<Comment> getRSMComments() {
        try {
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'cmtSearchObj :: ' + cmtSearchObj));
            if(cmtSearchObj == null || cmtSearchObj.fcDefId == null || cmtSearchObj.fiscalDate == null || cmtSearchObj.fcDefId == '' || cmtSearchObj.fiscalDate == '') {
                return null;
            }
            set<String> set_rsmDefIds = new set<String>();
            list<String> list_rsmDefIds = (list<String>) Json.deserialize(cmtSearchObj.fcDefId, list<String>.class);
            if(list_rsmDefIds.isEmpty()) {
                return null;
            }
            set_rsmDefIds.addAll(list_rsmDefIds);
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'set_rsmDefIds :: ' + set_rsmDefIds));
            ClsGSMForecastUtil.getRSMComments(set_rsmDefIds, cmtSearchObj.fiscalDate, list_comments);
        }
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex+''));
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getStackTraceString()));
        }
        return list_comments;
    }
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
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
    private void parseJSON(list<GSMSaveItem> list_tp, String sJson){
        JSONParser parser = JSON.createParser(sJson);
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) { // Start at the array of invoices. 
                while (parser.nextToken() != null) {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        GSMSaveItem cc= (GSMSaveItem)parser.readValueAs(CtrlGSMForecast.GSMSaveItem.class);
                        list_tp.add(cc);
                        parser.skipChildren();
                    }
                }
            }
        }
    }
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
    public class PageConfig {
        public map<String, set<Integer>> map_financialMonth {get; set;}
        public String currentYear {get; set;}
        public Integer currentMonth {get; set;}
        public map<String, Decimal> map_workingDays {get; set;}
        public Integer currentMonthIndex {get; set;}
        public list<String> list_yearMonth {get; set;}
        //public Map<String, Decimal> map_workingDays {get; set;}
        public PageConfig() {
            this.currentMonthIndex = 0;
            this.map_financialMonth = new map<String, set<Integer>>();
            this.currentYear = '';
            this.currentMonth = 0;
            this.map_workingDays = new map<String, decimal>();
            this.list_yearMonth = new List<String>();
            this.map_workingDays = new Map<String, Decimal>();
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
    
    public class GSMDefinitionItem {
        public String id {get; set;}
        public String name {get; set;}
        public String rsmName {get; set;}
        public String category {get; set;}
        public Decimal gsmSequence {get; set;}
        public Decimal rsmSequence {get; set;}
        public String label {get; set;}
        public Boolean subtotal {get; set;}
        public String profitCenter {get; set;}
        public String region {get; set;}
        public String categoryInclude {get; set;}
        public String categoryExclude {get; set;}
        public String industrialSalesTeamInclude {get; set;}
        public String classification {get; set;}
        public String managerFc {get;set;}
        public String prevManagerFc {get;set;}
        public String defItemKey {get; set;}
        transient public map<String, String> map_defKey_listDefs {get; set;}
    }
    public class GSMLineItem {
        public String name {get; set;}
        public String managerfc {get;set;}
        public String pmfc {get;set;}
        public String id{get; set;}
        public list<GSMDefinitionItem> list_gsmDefinitions {get; set;}
        
        public GSMLineItem() {
            this.name = '';
            this.pmfc = '';
            this.managerfc = '';
            this.id = '';
            this.list_gsmDefinitions = new list<GSMDefinitionItem>();
        }
    }
    public class GSMSaveItem {
        public String mfId {get; set;}
        public String gsmName {get; set;}
        public String fiscalYear {get; set;}
        public Integer fiscalMonth {get; set;}
        public decimal fc {get; set;}
        public decimal prevFC {get; set;}
        public String gsmDate {get;set;}
        public GSMSaveItem() {
            this.mfId = '';
            this.gsmName = '';
            this.gsmDate = '';
            this.fiscalYear = '';
            this.fiscalMonth = 0;
            this.fc = 0;
            this.prevFC = 0;
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
    
    public class DefinitionItemField{
        public String fieldName {get;set;}
        public String clsName {get;set;}
        public String clsField {get;set;}
        public String clsParent {get;set;}
        public DefinitionItemField(String fieldName, String clsName, String clsParent, String clsField){
            this.fieldName = fieldName;
            this.clsName = clsName;
            this.clsParent = clsParent;
            this.clsField = clsField;
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
    public class Comment {
        public String fcDefId {get; set;}
        public String fiscalDate {get; set;}
        public String value {get; set;}
        public String comment {get; set;}
        public String region {get; set;}
        
        public Comment() {
            this.fcDefId = '';
            this.fiscalDate = '';
            this.value = '';
            this.comment = '';
            this.region = '';
        }
    }
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
}