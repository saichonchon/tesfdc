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
public without sharing class CtrlRSMChangeScreen{
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public List<ASMItem> list_asmItem {get; set;}
    //public String str_listAsmItem {get; set;}
    public String queryStrForBBBM {get; set;}
    public String queryStrForScheduled {get; set;}
    public String queryStrForOthersBBBM {get; set;}
    public String queryStrForOthersScheduled {get; set;}
    public String viewType {get; set;}
    public String str_effectDays {get; set;}
    
    public String acctId4Comment {get; set;}
    public String year4Comment {get; set;}
    public Integer month4Comment {get; set;}
    public String comments {get; set;}
    
    transient public list<ClsForecastComments.ForecastCommentItem> list_comments {get; set;}
    
    public map<String, String> map_viewType {set;
        get{
            if(map_viewType == null){
                map_viewType = new map<String, String> {
                    'sv'=>'SalesView',
                    'pcv'=>'ProfitCenterView'
                };
            }
            return map_viewType;
        }
    }

    public List<CtrlRSMForecast.DateItem> list_dateItems {get; set;}
    public Map<String, List<CtrlRSMForecast.DateItem>> map_dateItems {get; set;}
    public List<CtrlRSMForecast.DateItem> list_allDateItems {get; set;}
    transient public LocaleConfig lc {get; set;}
    public set<String> set_dateKey {get; set;}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private String userId;
    private set<String> set_region = new set<String>();
    private set<String> set_profitCtr = new set<String>();
    private Map<String, Set<Integer>> map_financialMonth = new Map<String, Set<Integer>>();
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
   
    public CtrlRSMChangeScreen() {
        try{
            userId = userInfo.getUserId();
            //userId = '005E0000000XwtxIAC';      //Gregor Scholz, only for RSM testing 
            viewType = 'SalesView';
            this.lc = new LocaleConfig();
            changeScreen();
            list_dateItems = new List<CtrlRSMForecast.DateItem>();
            map_dateItems = new Map<String, List<CtrlRSMForecast.DateItem>>();
            list_allDateItems = new List<CtrlRSMForecast.DateItem>();
            ClsRSMForecastUtil.createDateItem(list_dateItems, map_dateItems, list_allDateItems, '');
            map_financialMonth = ClsRSMForecastUtil.map_financialMonth;
            //used for generate bbb monthly query by every month
            set_dateKey = new set<String>();
            ClsRSMForecastUtil.setDateKey(map_financialMonth, set_dateKey);
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'set_dateKey :: ' + set_dateKey));            
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, e+''));         
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, e.getStackTraceString()));         
        }
    }
    public String getColorConfig() {
        list<ColorConfig> list_colorConf = new list<ColorConfig>();
        ClsRSMForecastUtil.getColorConfigFromSetting(list_colorConf);
        return Json.serialize(list_colorConf);
    }
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
    
    public void changeScreen(){
        queryStrForBBBM = '';
        queryStrForScheduled = '';
        queryStrForOthersBBBM = '';
        queryStrForOthersScheduled = '';
        map<String, String> map_fiscalDate_bbbMQuery = new map<String, String>();
        map<String, String> map_fiscalDate_scheduledQuery = new map<String, String>();
        map<String, String> map_fiscalDate_bbbMQueryOther = new map<String, String>();
        map<String, String> map_fiscalDate_scheduledQueryOther = new map<String, String>();
        if(set_dateKey == null || set_dateKey.isEmpty()) {
            map_financialMonth = ClsRSMForecastUtil.map_financialMonth;
            //used for generate bbb monthly query by every month
            set_dateKey = new set<String>();
            ClsRSMForecastUtil.setDateKey(map_financialMonth, set_dateKey);
        }
        try{
            setASMItem(ClsRSMForecastUtil.getAccountManagers(userId, viewType, set_region, set_profitCtr));
        //      ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'list_asmItem:' + list_asmItem));
            //str_listAsmItem = JSON.serialize(list_asmItem);
            if(list_asmItem.size() > 1) {
                ClsRSMForecastUtil.getChangeScreenBBBMQuery(viewType, set_dateKey, map_fiscalDate_bbbMQuery);
                ClsRSMForecastUtil.getQueryStrForScheduledAgreements(viewType, set_dateKey, map_fiscalDate_scheduledQuery);
                
                //queryStrForBBBM = ClsRSMForecastUtil.getChangeScreenBBBMQuery(viewType);
                //queryStrForScheduled = ClsRSMForecastUtil.getQueryStrForScheduledAgreements(viewType);
                queryStrForBBBM = Json.serialize(map_fiscalDate_bbbMQuery);
                queryStrForScheduled = Json.serialize(map_fiscalDate_scheduledQuery);
            }
            else {
                queryStrForBBBM = '';
                queryStrForScheduled = '';
            }
                
            if(viewType == 'ProfitCenterView') {
                ClsRSMForecastUtil.getChangeScreenBBBMQuery(viewType, set_dateKey, map_fiscalDate_bbbMQueryOther);
                ClsRSMForecastUtil.getQueryStrForScheduledAgreements(viewType, set_dateKey, map_fiscalDate_scheduledQueryOther);
                
                queryStrForOthersBBBM = Json.serialize(map_fiscalDate_bbbMQueryOther);
                queryStrForOthersScheduled = Json.serialize(map_fiscalDate_scheduledQueryOther);
                
                //queryStrForOthersBBBM = ClsRSMForecastUtil.getChangeScreenBBBMQuery('other');
                //queryStrForOthersScheduled = ClsRSMForecastUtil.getQueryStrForScheduledAgreements('other');
            }

            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'queryStrForBBBM:' + queryStrForBBBM));
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, e+''));         
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, e.getStackTraceString()));         
        }
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'queryStrForBBBM:' + queryStrForBBBM));
    }
    public CtrlRSMChangeScreen getThis() {
        return this;
    }
    public void getComments() {
        try{
            ClsForecastComments forecastComments = new ClsForecastComments();
            //comments = '';
            ClsRSMForecastUtil.getComments(acctId4Comment, year4Comment, month4Comment, forecastComments, set_region, set_profitCtr);
            //comments = JSON.serialize(forecastComments.list_commentItem);
            list_comments = new list<ClsForecastComments.ForecastCommentItem>();
            list_comments.addAll(forecastComments.list_commentItem);
            
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, e+''));         
        }
    }
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- ********************************* 
    private void setASMItem(List<AggregateResult> list_accounts) {
        list_asmItem = new List<ASMItem>();
        
        if (list_accounts != null && list_accounts.size() > 0) {
            for (AggregateResult account : list_accounts) {
                ASMItem asmItem = new ASMItem();
                asmItem.id = (Id)account.get('aId');
                asmItem.name = (String)account.get('aName');
                list_asmItem.add(asmItem);
            }
        }
        if(viewType == 'ProfitCenterView') {
            ASMItem otherAsmItem = new ASMItem();
            otherAsmItem.id = 'OTHER';
            otherAsmItem.name = 'Other Account Managers';
            list_asmItem.add(otherAsmItem);
        }
    }
    
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>InnerClass*/
    public class ASMItem {
        public String id {get; set;}
        public String name {get; set;}
        
        public ASMItem() {
            id = '';
            name = '';
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
        
    }  
    
    public class ColorConfig {
        public String colorName {get; set;}
        public decimal maxValue {get; set;}
        public decimal minValue {get; set;}
        
        public ColorConfig() {
            this.colorName = '';
            this.maxValue = 0;
            this.minValue = 0;
        }
    }
    
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
    ///*<<<InnerClass*/
    //********************************* -=END inner classes=- *************************************
}