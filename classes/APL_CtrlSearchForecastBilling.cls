/**
 * Controller class for page APL_CtrlSearchForecastBilling
 *
 @author    Chen Chen
 @created   2015-01-29
 @version   1.0
 @since     30.0 (Force.com ApiVersion)
 *
 @changelog
 * 2016-03-30 Chen Chen <Shawn.liu.china@itbconsult.com>
 * - Created
 */
 

public without sharing class APL_CtrlSearchForecastBilling {
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    /**
     * transient string to show custom message on page.
    */
    //public transient APL_ClsMangerAPLUtil.LocaleConfig lc {get;set;}
    public transient String message{get;private set;}
    public String filterJson {get; set;}                         //to sent data of filter to page In initFilter()
    public String Json_map_oppyFileds {get; set;}                //to sent the title of oppy In table
    public String Json_map_fcFileds {get; set;}                  //to sent the title of forecast In table
    public String Json_map_billFileds {get; set;}                //to sent the title of billing In table
    public String Json_map_oppyPart {get; set;}                  //to sent the title of oppyPart In table
    public String Json_map_oppyPartner {get; set;}               //to sent the title of oppyPartner In table
    public Integer fiscalYearnum {get; set;} 
    public list<String> list_columnNames;                        //get filedName form custom setting
    public list<String> list_columnAPINames;                     //get filedApiName form custom setting
    public static Integer fiscalYear = APL_ClsSearchBillAPLUtil.getFiscalYear();    // sure the year is IN which fiscal year
    public static Set<String> set_oppyId = new Set<String>();    //to save oppyIds
    //three boolean to sure whther quantity have value
    public static boolean befYear {get; set;}
    public static boolean fisYear {get; set;} 
    public static boolean nextYear {get; set;}
    public static integer dirBillMonth {get; set;}               //Direct Billing Month
    public static integer PosBillMonth {get; set;}               //POS/CMA Billing Month
    public static String  str_dirPosMonth {get; set;} 
    public static String  thousandSep {get; set;}                //thousand separate symbol
    public static list<APL_ClsSearchBillAPLUtil.response> list_response = new list<APL_ClsSearchBillAPLUtil.response>();//to return data to js
    public static list<String> list_partOrPartner = new list<String>();             //to choose to return oppPart or Partner or all
    public map<String,APL_Billing__c> customSettingValue =  new map<String,APL_Billing__c>();
    public APL_Billing__c getOppy;
    public APL_Billing__c getOppyPart;
    public APL_Billing__c getOppyPartner;
    
    //to make title of table about forecast
    public static Map<String, String> map_fcFileds = new Map<String, String>{
            'FY' + (fiscalYear + 1) => 'FY' + (fiscalYear + 1) + ' TTL',
            'FY' + fiscalYear => 'FY' + fiscalYear + ' TTL',
            'FY' + fiscalYear +'_Q4' => 'FY' + fiscalYear + ' Q4',
            'FY' + fiscalYear +'_Q3' => 'FY' + fiscalYear + ' Q3',
            'FY' + fiscalYear +'_Q2' => 'FY' + fiscalYear + ' Q2',
            'FY' + fiscalYear +'_Q1' => 'FY' + fiscalYear + ' Q1',
            'FY' + (fiscalYear - 1) => 'FY' + (fiscalYear - 1) + ' TTL',
            'Initial_12_months__c' => 'Initial 12 month Fcst'
    };
    //to make title of table about billing
    public static Map<String, String> map_billFileds = new Map<String, String>{
            'Booking_Diff_Vs_Pre_FY' => 'Booking Diff. Vs Pre. FY',
            'Book_Year_to_Date_Amount_USD__c' => 'Current YTD Booking',
            'Book_Prior_Year_To_Date_Amount_USD__c' => 'Previous YTD Booking',
            'Book_Prior_Year_Amount_USD__c' => 'Previous Year TTL Booking',
            'Bill_Forecast_Achieve_Ratio'=>'Forecast achieve Ratio',
            'Billing_Diff_Vs_Pre_FY' => 'Billing Diff. Vs Pre. FY',
            'Bill_Year_to_Date_Amount_USD__c' => 'Current YTD Billing',
            'Bill_Prior_Year_to_Date_Amount_USD__c' => 'Previous YTD Billing',
            'Bill_Prior_Year_Amount_USD__c' => 'Previous Year TTL Billing',
            'Bill_Prior_Year_1_to_Date_Amount_Do__c' => 'Previous  -1 YTD Billing',
            'Bill_Prior_Year_1_Amount_Document__c' => 'Previous Year -1 TTL Billing'
            
    };
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private Map<String, String> map_oppyFileds = new Map<String, String>();//to put OppyId, OppyLabel In map
    private Map<String, String> map_oppyPart = new Map<String, String>();//to put OppyPartId, OppyPartLabel In map
    private Map<String, String> map_oppyPartner = new Map<String, String>();//to put OppyPartnerId, OppyPartnerLabel In map
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    //
    public APL_CtrlSearchForecastBilling() {
        customSettingValue = APL_Billing__c.getAll();
        getOppy = customSettingValue.get('Oppy');
        getOppyPart = customSettingValue.get('OppyPart');
        getOppyPartner = customSettingValue.get('OppyPartner');
        this.fiscalYearnum = APL_ClsSearchBillAPLUtil.getFiscalYear();
        initFilter();                 //get Data from database to sent to filter
        getFileds();                  //get fileds of Opportunity and Opportunity Part and Opportunity Partner From custome setting
        transmitJson();               //serialize map to sent to page
        //dirBillMonth = APL_ClsSearchBillAPLUtil.getDirBillMonth();
        //PosBillMonth = APL_ClsSearchBillAPLUtil.getPosBillMonth();
        str_dirPosMonth = APL_ClsSearchBillAPLUtil.getDirBillPosBill();
        dirBillMonth = Integer.valueOf(str_dirPosMonth.split(',')[0]);
        PosBillMonth = Integer.valueOf(str_dirPosMonth.split(',')[1]);
        thousandSep = APL_ClsSearchBillAPLUtil.getThouSymbol();
    }
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
    
    //get Data from database to sent to filter
    public void initFilter(){
        APL_ClsSearchBillAPLUtil searchUntil = new APL_ClsSearchBillAPLUtil();
        filterJson = searchUntil.getMultipleType();
        system.debug('filterJson::chen' + filterJson);
    }
    //get fileds of Opportunity and Opportunity Part and Opportunity Partner From custome setting
    public void getFileds(){
        //split the String to list with ','
        list_columnNames = getOppy.Column_Names__c.split(',');
        list_columnAPINames = getOppy.Column_API_Names__c.split(',');
        //put the OppYId OppyLabel In custom setting
        //change By Lei Tang 2016-05-20 reset order 
        for(Integer i = list_columnNames.size()-1;i >= 0;i--){
            map_oppyFileds.put(list_columnAPINames[i], list_columnNames[i]);
        }
        //Opportunity_Part__c : same as Opportunity
        list_columnNames = getOppyPart.Column_Names__c.split(',');
        list_columnAPINames = getOppyPart.Column_API_Names__c.split(',');
        //change By Lei Tang 2016-05-20 reset order 
        for(Integer i = list_columnNames.size()-1;i >= 0;i--){
            map_oppyPart.put(list_columnAPINames[i], list_columnNames[i]);
        }
        //Opportunity_Partner__c : same as Opportunity
        list_columnNames = getOppyPartner.Column_Names__c.split(',');
        list_columnAPINames = getOppyPartner.Column_API_Names__c.split(',');
        //change By Lei Tang 2016-05-20 reset order 
        for(Integer i = list_columnNames.size()-1;i >= 0;i--){
            map_oppyPartner.put(list_columnAPINames[i], list_columnNames[i]);
        }
    }
    //serialize map to sent to page
    public void transmitJson(){
        //serialize map
        Json_map_oppyFileds = JSON.serialize(map_oppyFileds);
        Json_map_fcFileds = JSON.serialize(map_fcFileds);
        Json_map_billFileds = JSON.serialize(map_billFileds);
        Json_map_oppyPart = JSON.serialize(map_oppyPart);
        Json_map_oppyPartner = JSON.serialize(map_oppyPartner);
    }
    
    //Search data accroding of the filter and to sent to page
    @RemoteAction
    public static list<APL_ClsSearchBillAPLUtil.response> doSearch(list<paramlFilter> list_searchQuery, String Json_set_oppyIds) {
        system.debug('chenchen::list_searchQuery::' + list_searchQuery);
        set<String> set_oppyIds = new set<String>();
        set_oppyIds = (set<String>)JSon.deserialize(Json_set_oppyIds, set<String>.class);
        system.debug('chenchen::Json_set_oppyIds::' + Json_set_oppyIds);
        if(set_oppyIds.isEmpty()) {    //first Search
            //to find OppyId whichi is eligible and return set_oppyIds
            set_oppyIds = APL_ClsSearchBillAPLUtil.findSet_oppyId(list_searchQuery);
            system.debug('chen::set_oppyIds' + set_oppyIds);
            if(set_oppyIds.size() <= 100 && set_oppyIds.size() > 0) {
                //find the oppyId we need accroding to filter and set_oppyIds will change after a query
                system.debug('Start to get Id' + set_oppyIds);
                set_oppyIds = APL_ClsSearchBillAPLUtil.findOppyIdInOppPart(set_oppyIds, list_searchQuery);
                if(!set_oppyIds.isEmpty()) {
                    set_oppyIds = APL_ClsSearchBillAPLUtil.findOppyIdInOppPartner(set_oppyIds);
                }
                if(!set_oppyIds.isEmpty()) {
                    //start to get data
                    list_response.addAll(APL_ClsSearchBillAPLUtil.getOppy(set_oppyIds));        //get information of Oppy with set_oppyId i get 
                    befYear = false;
                    fisYear = false;
                    nextYear = false;
                    //screening set_oppyId and get information of Forecast with set_oppyId i screening 
                    list_response.addAll(APL_ClsSearchBillAPLUtil.getFore(list_searchQuery,set_oppyIds,fiscalYear,befYear,fisYear,nextYear));
                    //debug 
                    for(APL_ClsSearchBillAPLUtil.response resp : list_response) {
                        system.debug('!@# resp: '+ resp);
                    }
                    
                    //screening set_oppyId and get information of Billing with set_oppyId i screening
                    list_response.addAll(APL_ClsSearchBillAPLUtil.getBill(set_oppyIds, map_billFileds));
                    list_response = APL_ClsSearchBillAPLUtil.mergeMap(set_oppyIds, list_response);//mergeMap make the data map_record belong to a oppyId
                    //calculate oppy forecast achieve reatio
                    list_response=APL_ClsSearchBillAPLUtil.calForecastAchieveRatio(fiscalYear,Integer.valueOf(APL_ClsSearchBillAPLUtil.getDirBillPosBill().split(',')[0]),list_response);
                    system.debug('chenchen::list_response::' + list_response);
                }else {
                    APL_ClsSearchBillAPLUtil.response res = new APL_ClsSearchBillAPLUtil.response();
                    res.message = label.Apl_Bill_No_Record;
                    list_response.add(res);
                }
            }else if(set_oppyIds.size() == 0){
                APL_ClsSearchBillAPLUtil.response res = new APL_ClsSearchBillAPLUtil.response();
                res.message = label.Apl_Bill_No_Record;
                list_response.add(res);
            }else if(set_oppyIds.size() >= 100){
                APL_ClsSearchBillAPLUtil.response res = new APL_ClsSearchBillAPLUtil.response();
                res.set_oppyId2Js = set_oppyIds;
                list_response.add(res);
            }
        } else if(! set_oppyIds.isEmpty()) {
            set_oppyIds = APL_ClsSearchBillAPLUtil.findOppyIdInOppPart(set_oppyIds, list_searchQuery);
            system.debug('set_oppyIds:' + set_oppyIds);
            if(!set_oppyIds.isEmpty()) {
                set_oppyIds = APL_ClsSearchBillAPLUtil.findOppyIdInOppPartner(set_oppyIds);
            }
            if(!set_oppyIds.isEmpty()) {
                system.debug('chenchen::set_oppyIdsOK::' + set_oppyIds);
                //start to get data
                list_response.addAll(APL_ClsSearchBillAPLUtil.getOppy(set_oppyIds));//get information of Oppy with set_oppyId i get 
                befYear = false;
                fisYear = false;
                nextYear = false;
                list_response.addAll(APL_ClsSearchBillAPLUtil.getFore(list_searchQuery, set_oppyIds,fiscalYear,befYear,fisYear,nextYear));//screening set_oppyId and get information of Forecast with set_oppyId i screening 
                list_response.addAll(APL_ClsSearchBillAPLUtil.getBill(set_oppyIds, map_billFileds));//screening set_oppyId and get information of Billing with set_oppyId i screening 
                //duplicated code 
                list_response = APL_ClsSearchBillAPLUtil.mergeMap(set_oppyIds, list_response);//mergeMap make the data map_record belong to a oppyId
                //calculate oppy forecast achieve reatio
                list_response=APL_ClsSearchBillAPLUtil.calForecastAchieveRatio(fiscalYear,Integer.valueOf(APL_ClsSearchBillAPLUtil.getDirBillPosBill().split(',')[0]),list_response);
                
            }else {
                APL_ClsSearchBillAPLUtil.response res = new APL_ClsSearchBillAPLUtil.response();
                res.message = label.Apl_Bill_No_Record;
                list_response.add(res);
            }
            
        }
        //check list_response if it contain records
        if(list_response.size() == 0){
                APL_ClsSearchBillAPLUtil.response res = new APL_ClsSearchBillAPLUtil.response();
                res.message = label.Apl_Bill_No_Record;
                list_response.add(res);
        }

        return list_response;
    }
    
    //to get OppyPart and oppyPartner according to OppyId
    @RemoteAction
    public static list<APL_ClsSearchBillAPLUtil.response> searchPartAndPartner(List<paramlFilter> list_paramFilter, String set_oppyIds, String choosePartOrPartner){
        
        list_partOrPartner = choosePartOrPartner.split(',');
        set<String> set_oppIds = new set<String>();
        set_oppIds = (set<String>)JSon.deserialize(set_oppyIds, set<String>.class);
        system.debug('chenchen::list_partOrPartner::' + list_partOrPartner);
        list<APL_ClsSearchBillAPLUtil.response> list_res_part_partner = new list<APL_ClsSearchBillAPLUtil.response>();
        if(list_partOrPartner.size() == 2) {           
            //to get oppyForecast data according to oppyPartId (Updated by kevin shen)
            list_res_part_partner.addAll(APL_ClsSearchBillAPLUtil.getOppyPartFcBilling(list_paramFilter, set_oppIds, APL_ClsSearchBillAPLUtil.getFiscalYear(),Integer.valueOf(APL_ClsSearchBillAPLUtil.getDirBillPosBill().split(',')[0])));            
            //get partner and forcast record(Updated by kevin shen)
            list_res_part_partner.addAll(APL_ClsSearchBillAPLUtil.getoppyPartnerFcBilling(list_paramFilter, set_oppIds, APL_ClsSearchBillAPLUtil.getFiscalYear(),Integer.valueOf(APL_ClsSearchBillAPLUtil.getDirBillPosBill().split(',')[0])));
        }else if(list_partOrPartner.size() == 1) {
            if(list_partOrPartner[0] == 'Opportunity_Part__c') {
                list_res_part_partner.addAll(APL_ClsSearchBillAPLUtil.getOppyPartFcBilling(list_paramFilter, set_oppIds, APL_ClsSearchBillAPLUtil.getFiscalYear(),Integer.valueOf(APL_ClsSearchBillAPLUtil.getDirBillPosBill().split(',')[0])));
            }else if(list_partOrPartner[0] == 'Opportunity_Partner__c') {
                list_res_part_partner.addAll(APL_ClsSearchBillAPLUtil.getoppyPartnerFcBilling(list_paramFilter, set_oppIds, APL_ClsSearchBillAPLUtil.getFiscalYear(),Integer.valueOf(APL_ClsSearchBillAPLUtil.getDirBillPosBill().split(',')[0])));
            }
        }
        system.debug('chenchen::list_res_part_partner::' + list_res_part_partner);
        return list_res_part_partner;
    }
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    //********************************* -=BEGIN inner classes=- ***********************************
    public class paramlFilter {
        public String objectName {get; set;}
        public String queryString {get; set;}
        // Won_Date__c: 'Custom Date|13800000012345|13800000022345'
        public map<String, String> valueMap {get; set;}
        
        public paramlFilter() {
            this.objectName = '';
            this.queryString = '';
            this.valueMap = new map<String, String>();
        }
    }
    //********************************* -=END inner classes=- *************************************
}