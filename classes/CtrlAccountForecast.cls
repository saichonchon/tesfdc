/**
 *  Controll class for page CtrlAccountForecast
 *
 @author    Yuanyuan Zhang
 @created   2013-09-18
 @version   1.0
 @since     27.0 (Force.com ApiVersion)
 *
 @changelog
 * 2013-09-18 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
 * - Created
 */

public without sharing class CtrlAccountForecast {
   
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public static String str_acctIds {get; set;}
    public PageConfig pageConf {get; set;}
    public string testString {get; set;}
    public Integer currentMonth {get; set;}
    public String currentYear {get; set;}
    //public map<String, Set<Integer>> map_financialMonth {get; set;}
    public list<String> list_acctIds {get; set;}
    public String acctIds {get; set;}
    public map<String, map<String, ClsAccountForecastItem>> map_acctId_map_year_fcItem {get; set;}
    public ClsForecastComments forecastComments {get; set;}
    public map<String, map<Integer, Integer>> map_year_map_month_effWorkingDays{get; set;}
    //public String commentYear {get; set;}
    //public Integer commentMonth {get; set;}
    public String parentAcctId {get; set;}
    public String str_comment {get; set;}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private list<String> list_territoryCodes = new list<String>();
    private Map<String, String> map_urlParams;
    private map<String, set<String>> map_parentAcctId_set_childrenAcctIds = new map<String, set<String>>();
    private map<String, String> map_parentId_acctName = new map<String, String>(); 
    private static final String OTHER = 'OTHER';
    private map<String, ClsAccountForecastItem> mapDemo = new map<String, ClsAccountForecastItem>();
    private String userId = UserInfo.getUserId();
    private set<String> set_totalAcctIds = new set<String>();
    //private map<String, map<String, decimal>> map_parentId_map_childId_percent = new map<String, map<String, decimal>>();
    private map<String, map<String, map<String,decimal>>> map_parentId_map_childId_map_profitCtr_percent = new map<String, map<String, map<String,decimal>>>();
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
    public CtrlAccountForecast() {
        str_acctIds = '';
        pageConf = new PageConfig();
        map_acctId_map_year_fcItem = new map<String, map<String, ClsAccountForecastItem>>();
        try {
            ClsAcctForecastUtil.setfinancialMonths(pageConf);
            getTerritoryCodes();
            if(list_territoryCodes.size() == 1) {
                pageConf.selectTerritory = list_territoryCodes[0];
            }
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'pageConf.map_financialMonth :: ' + pageConf.map_financialMonth));
            init();   
            list<ColorConfig> list_colorConf = new list<ColorConfig>();
        	ClsAcctForecastUtil.getAMColorConfigFromSetting(list_colorConf, pageConf);  
        }
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, ex.getStackTraceString()));
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, ex.getMessage()));
        }
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Page config :: ' + pageConf));
    }
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
   /**
    * This method is used to get account billing percent
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
    public void getAcctPercent() {
        map_parentId_map_childId_map_profitCtr_percent.clear();
        ClsAcctForecastUtil.getAcctPercentage(set_totalAcctIds, map_parentAcctId_set_childrenAcctIds, map_parentId_map_childId_map_profitCtr_percent, pageConf.currentYear, pageConf.currentMonth, pageConf.selectTerritory);
        pageConf.acctPercent = Json.serialize(map_parentId_map_childId_map_profitCtr_percent);
    }
    
   /**
    * This method is used to get account forecast comments for gaven month
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
    public void getComments() {
        
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'pageConf :: ' + pageConf ));
        if(parentAcctId == '' || parentAcctId == null) {
            return;
        }
        forecastComments = new ClsForecastComments();
        set<String> set_childAcctIds = map_parentAcctId_set_childrenAcctIds.get(parentAcctId);
        ClsAcctForecastUtil.getComments(set_childAcctIds, pageConf.comtSaveYear, pageConf.comtSaveMonth, forecastComments, pageConf.currentYear, pageConf.currentMonth, pageConf.selectTerritory);
        str_comment = JSON.serialize(forecastComments);
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'str_comment :: ' + str_comment ));
    }

   /**
    * This method is used to save account forecast
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
    public void saveForecast() {
        try {
            if(pageConf.str_fcSaveItems == '') {
                return;
            }
            //pageConf.str_fcSaveItems = pageConf.str_fcSaveItems.replaceAll('\"', '\'');
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'pageConf.str_fcSaveItems :: ' + pageConf.str_fcSaveItems));
            list<ClsAccountForecastItem.AcctForecastSaveItem> list_fcSaveItems = new list<ClsAccountForecastItem.AcctForecastSaveItem>();
            map<String, map<String, map<Integer, map<String, String>>>> map_acctId_year_month_profitCtr_comt = new map<String, map<String, map<Integer, map<String, String>>>>();
            list_fcSaveItems = (list<ClsAccountForecastItem.AcctForecastSaveItem>) JSON.deserialize(pageConf.str_fcSaveItems, list<ClsAccountForecastItem.AcctForecastSaveItem>.class);
            map<String, set<Integer>> map_fiscalMonth4Save = new map<String, set<Integer>>();
            //set<String> set_childAcctIds = map_parentAcctId_set_childrenAcctIds.get(pageConf.saveItem.parentAcctId);
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'set_childAcctIds :: ' + set_childAcctIds));
            if(!list_fcSaveItems.isEmpty()) {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'pageConf.saveItem.parentAcctId :: ' + pageConf.saveItem.parentAcctId));
                for(ClsAccountForecastItem.AcctForecastSaveItem item : list_fcSaveItems) {
                    if(item.year != null && item.year != '') {
                        if(!map_fiscalMonth4Save.containsKey(item.year)) {
                            map_fiscalMonth4Save.put(item.year, new set<Integer>());
                        }
                        if(!map_fiscalMonth4Save.get(item.year).contains(item.month)) {
                            map_fiscalMonth4Save.get(item.year).add(item.month);
                        }
                    }
                    if(item.commentList != null && !item.commentList.isEmpty()) {
                        //set_childAcctIds4Comment.addAll(map_parentAcctId_set_childrenAcctIds.get(item.parentAcctId));
                        for(ClsAccountForecastItem.FCCommentSaveItem cmtItem : item.commentList) {
                            String STR_NULL = 'NULL';
                            String profitCtr = ((cmtItem.profitCenter == '' || cmtItem.profitCenter == null) ? STR_NULL : cmtItem.profitCenter);
                            if(!map_acctId_year_month_profitCtr_comt.containsKey(cmtItem.acctId)) {
                                map_acctId_year_month_profitCtr_comt.put(cmtItem.acctId, new map<String, map<Integer, map<String, String>>>());
                            }
                            if(!map_acctId_year_month_profitCtr_comt.get(cmtItem.acctId).containsKey(item.year)) {
                                map_acctId_year_month_profitCtr_comt.get(cmtItem.acctId).put(item.year, new map<Integer, map<String, String>>());
                            }
                            if(!map_acctId_year_month_profitCtr_comt.get(cmtItem.acctId).get(item.year).containsKey(item.month)) {
                                map_acctId_year_month_profitCtr_comt.get(cmtItem.acctId).get(item.year).put(item.month, new map<String, String>());
                            }
                            if(!map_acctId_year_month_profitCtr_comt.get(cmtItem.acctId).get(item.year).get(item.month).containsKey(profitCtr)) {
                                map_acctId_year_month_profitCtr_comt.get(cmtItem.acctId).get(item.year).get(item.month).put(profitCtr, cmtItem.comment);
                            }
                        }
                    }
                }
                //map_parentId_map_childId_map_profitCtr_percent = new map<String, map<String, map<String,decimal>>>();
                if(map_parentId_map_childId_map_profitCtr_percent.isEmpty()) {
                    ClsAcctForecastUtil.getAcctPercentage(set_totalAcctIds, map_parentAcctId_set_childrenAcctIds, map_parentId_map_childId_map_profitCtr_percent, pageConf.currentYear, pageConf.currentMonth, pageConf.selectTerritory);
                }
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'map_parentId_map_childId_map_profitCtr_percent :: ' + map_parentId_map_childId_map_profitCtr_percent));
                ClsAcctForecastUtil.saveAcctForecast(list_fcSaveItems, set_totalAcctIds, map_parentId_map_childId_map_profitCtr_percent, pageConf, map_fiscalMonth4Save);
                if(!map_acctId_year_month_profitCtr_comt.isEmpty()) {
                    //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'map_acctId_year_month_profitCtr_comt :: ' + map_acctId_year_month_profitCtr_comt));
                    ClsAcctForecastUtil.saveComments(map_acctId_year_month_profitCtr_comt, map_fiscalMonth4Save);
                }
            }
        }
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getStackTraceString()));
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
        }
    }

   /**
    * This method is used to get account territory code
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
    public String getTerritoryCodes() {
        list_territoryCodes = new list<String>();
        ClsAcctForecastUtil.getAccountTerritory(userId, list_territoryCodes);
        return Json.serialize(list_territoryCodes);
    }
    
   /**
    * This method is action function while changed territory code
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
    public void refresh4TerritoryChange() {
        init();
    }
    
   /**
    * This method is used to get am page color config from custom setting
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
    public String getColorConfig() {
        list<ColorConfig> list_colorConf = new list<ColorConfig>();
        ClsAcctForecastUtil.getAMColorConfigFromSetting(list_colorConf, pageConf);
        return Json.serialize(list_colorConf);
    }
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
   /**
    * This method is used to init page parms
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
    private void init(){
        map_year_map_month_effWorkingDays = new map<String, map<Integer, Integer>>();
        
        string monthFilter = ClsAcctForecastUtil.buildMonthFilter(pageConf.map_financialMonth);
        this.pageConf.fiscalDate = Json.serialize(pageConf.map_financialMonth);
        this.list_acctIds = new list<String>();
        //reset data
        map_parentAcctId_set_childrenAcctIds.clear();
        set_totalAcctIds.clear();
        map_parentId_acctName.clear();
        map_acctId_map_year_fcItem.clear();
        //reset data        
        ClsAcctForecastUtil.getEffectiveWorkingDays(pageConf.map_financialMonth, map_year_map_month_effWorkingDays);
        this.pageConf.effectiveDays = JSON.serialize(map_year_map_month_effWorkingDays);
        ClsAcctForecastUtil.getAcctHieraychy(map_parentAcctId_set_childrenAcctIds, userId, set_totalAcctIds, map_parentId_acctName, pageConf.selectTerritory);
        ClsAcctForecastUtil.getAcctForecastData(pageConf.map_financialMonth, set_totalAcctIds, map_parentAcctId_set_childrenAcctIds, map_acctId_map_year_fcItem, map_parentId_acctName, pageConf.selectTerritory);
        ClsAcctForecastUtil.checkFCMap4Year(map_acctId_map_year_fcItem, pageConf.map_financialMonth, map_parentAcctId_set_childrenAcctIds, map_parentId_acctName);
        pageConf.str_fcData = JSON.serialize(map_acctId_map_year_fcItem);
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'map_acctId_map_year_fcItem :: ' + map_acctId_map_year_fcItem));
        pageConf.isSaveable = (ClsAcctForecastUtil.isDateFrozen(pageConf) == true ? false : true);
        getAcctPercent();
        if(!pageConf.isSaveable) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, system.label.FinancialPlan_Msg4Closed));
        }
    }
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>InnerClass*/
    public class PageConfig {
        public String acctIds {get; set;}
        public String forecasts {get; set;}
        public decimal deciFormat {get; set;}
        public Integer currentMonth{get; set;}
        public String currentYear {get; set;}
        public Integer currentMonthIndex{get; set;}
        public list<String> list_acctIds {get; set;}
        public BBB_Month_Bill_Book_Cust__c tempBBBM {get; set;}
        public ClsAccountForecastItem.AcctForecastSaveItem saveItem {get; set;}
        public String str_fcSaveItems {get; set;}
        public String fiscalDate {get; set;}
        public String str_comts2Save {get; set;}
        public String comtSaveYear {get; set;}
        public Integer comtSaveMonth {get; set;}
        public String currentParentId {get; set;}
        public String effectiveDays {get; set;}
        public String str_fcData {get; set;}
        public Boolean isSaveable {get; set;}
        public String selectTerritory {get; set;}
        //public list<String> list_territoryCodes {get; set;}
        public Integer todayYear {get; set;}
        public Integer todayMonth {get; set;}
        //public String fcIds2Delete {get; set;}
        public map<String, set<Integer>> map_financialMonth {get; set;}
        public list<String> list_yearMonth {get; set;}
        public String acctPercent {get; set;}
        public map<String, map<Integer, String>> map_year_month_lastDay {get; set;}
        //following are used for color in am page
        public String amRed {get; set;}
        public String amGreen {get; set;}
        public String colorJson {get; set;}
        
        public PageConfig() {
            this.acctIds = '';
            this.list_acctIds = new list<String>();
            this.forecasts = '';
            this.deciFormat = 1234.56;    
            this.currentMonthIndex = 0;
            this.tempBBBM = new BBB_Month_Bill_Book_Cust__c();
            tempBBBM.Bill_Amount_USD__c = 1234.56;
            this.saveItem = new ClsAccountForecastItem.AcctForecastSaveItem();
            this.str_fcSaveItems = '';
            this.fiscalDate = '';
            this.str_comts2Save = '';
            this.comtSaveYear = '';
            this.comtSaveMonth = 0;
            this.currentParentId = '';
            this.effectiveDays = '';
            this.str_fcData = '';
            this.isSaveable = true;
            this.selectTerritory = '';
            this.todayYear = date.today().year();
            this.todayMonth = date.today().month();
            this.map_financialMonth = new map<String, set<Integer>>();
            this.list_yearMonth = new list<String>();
            this.acctPercent = '';
            this.map_year_month_lastDay = new map<String, map<Integer, String>>();
            this.amRed = '';
            this.amGreen = '';
            this.colorJson = '';
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