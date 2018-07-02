/**
 *  This class is APL Forecast and Actual Billing Chart.
 *  
 * @author Lei Tang
 * @created 2015-05-05
 * @version 1.0
 * @since 33.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2015-05-05 Lei Tang <lei.tang@itbconsult.com>
 * - Created
 
   @changelog
 * 2016-04-07 Mingxing Qiu  <mingxing.qiu@oinio.com>
 * Update the chart data query filter and group query filter because  page date ,chart data and export data difference . 
 * - Created 
 *
 */
public without sharing class APL_CompForecastBillingChart {
    
    public transient ClsAPLEntityTypes.LocaleConfig lc {get;set;}

    public String selectgroupingnames {get;set;}
    public String selectCBC2names {get;set;}
    public String selectterrtroynames {get;set;}
    public String selectproductcodenames {get;set;}
    public String viewmode {get;set;}
    //added by Bin
    //public Integer currentFiscalYear {get; set;}
    public Integer currentFiscalQuarter {get; set;}
    
    public list<String> list_territoryName {get; set;}
    public list<String> list_territoryCode {get; set;}
    public list<String> list_AMGrouping {get; set;}
    public list<String> list_RSMGrouping {get; set;}
    public list<String> list_RSMRelayGrouping {get; set;}
    public list<String> list_RelayGrouping {get; set;}
    public list<String> list_Region {get; set;}
    public String managerType {get; set;}
    public String territoryCodeJSON {get; set;}
    public String rSMGroupingJSON {get; set;}
    public String relayGroupingJSON {get; set;}
    public String AMGroupingJSON {get;set;}
    public String rSMRelayGroupingJSON {get; set;}
    public String regionJSON {get; set;}
    public String currentTerritoryCode {get; set;}
    public String source {get; set;}
    public String userId {get; set;}
    public list<String> list_exportHead {get; set;}
    
    private map<String, set<String>> map_territoryCode_AMGrouping = new map<String, set<String>>();
    private map<String, set<String>> map_territoryCode_RelayGrouping = new map<String, set<String>>();
    private map<String, set<String>> map_rsmGrouping_AMGrouping = new map<String, set<String>>();
    private map<String, set<String>> map_rsmRelayGrouping_RelayGrouping = new map<String, set<String>>();
    
    private set<Id> set_AccountIds = new set<Id>();
    
    public static final String OTHERAMGROUPEDACCOUNTS = 'Other AM Grouped Accounts';
    public static final String OTHERACCOUNTS = 'Other Accounts';
    
    public APL_Interface.AAPLCtrlService aplService {get;set;}
    {
        this.lc = new ClsAPLEntityTypes.LocaleConfig();
        ClsAPLForecastUtil.setUserLocale(this.lc, userInfo.getLocale());    //set user locale
    }
    
    public map<String, String> map_month_quarter = new map<String, String> {
        '1' => '1', '2' => '1', '3' => '1',
        '4' => '2', '5' => '2', '6' => '2',
        '7' => '3', '8' => '3', '9' => '3',
        '10' => '4', '11' => '4', '12' => '4'
    };
    
    public static map<String, String> map_cbc2id_cbc2label = new map<String, String>{
        '[ 30012 ] - Power' => '30012',
        '[ 30014 ] - Signal' => '30014',
        '[ 30015 ] - RAST' => '30015', 
        '[ 30016 ] - Terminals & Splices' => '30016', 
        '[ 30017 ] - Tubing' => '30017', 
        '[ 30042 ] - Magnet' => '30042', 
        'Relay' => 'Relay', 
        'Other BU Products' => 'Other CBC2'
    };
    
    public static map<String, String> map_cbc2label_cbc2id = new map<String, String> {
        '30012' => '[ 30012 ] - Power',
        '30014' => '[ 30014 ] - Signal',
        '30015' => '[ 30015 ] - RAST', 
        '30016' => '[ 30016 ] - Terminals & Splices', 
        '30017' => '[ 30017 ] - Tubing', 
        '30042' => '[ 30042 ] - Magnet', 
        'Relay' => 'Relay', 
        'Other CBC2' => 'Other BU Products'
    };
    
    public static map<String, String> map_cbc2label_soql = new map<String, String> {
        '[ 30012 ] - Power' => ' (Part__r.Product_Hierarchy__r.CBC2__c = \'30012\' ) ',
        '[ 30014 ] - Signal' => ' (Part__r.Product_Hierarchy__r.CBC2__c = \'30014\' ) ',
        '[ 30015 ] - RAST' => ' (Part__r.Product_Hierarchy__r.CBC2__c = \'30015\' ) ', 
        '[ 30016 ] - Terminals & Splices' => ' (Part__r.Product_Hierarchy__r.CBC2__c = \'30016\' ) ', 
        '[ 30017 ] - Tubing' => ' (Part__r.Product_Hierarchy__r.CBC2__c = \'30017\' ) ', 
        '[ 30042 ] - Magnet' => ' (Part__r.Product_Hierarchy__r.CBC2__c = \'30042\' ) ', 
        //change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
        'Relay' => ' ( Part__r.Product_Hierarchy__r.CBC2__c in (\'13213\',\'30005\') or Part__r.Product_Hierarchy__r.CBC3__c in (\'41553\') ) ', 
        'Other BU Products' => ' ( Part__r.Product_Hierarchy__r.CBC2__c not in (\'30012\',\'30014\',\'30015\',\'30016\',\'30017\',\'30042\',\'13213\',\'30005\') and Part__r.Product_Hierarchy__r.CBC3__c not in (\'41553\') ) ',
        'CBC2 / Automotive Relays' => ' (Part__r.Product_Hierarchy__r.CBC2__c = \'13213\' ) ',
        'CBC2 / APPLIANCES GENERAL PURPOSE RELAYS' => ' (Part__r.Product_Hierarchy__r.CBC2__c = \'30005\' ) ',
        'CBC3 / Relays IND' => ' (Part__r.Product_Hierarchy__r.CBC3__c = \'41553\' ) '
        //change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
        //'CBC3 / Relays A&C' => ' (Part__r.Product_Hierarchy__r.CBC3__c = \'40308\' ) ',
        //'CBC3 / Relays IB' => ' (Part__r.Product_Hierarchy__r.CBC3__c = \'40309\' ) '
    };
    
    
    public static map<String, String> map_relay_cbc2id_cbc2label = new map<String, String> {
        '13213' => 'CBC2 / Automotive Relays',
        '30005' => 'CBC2 / APPLIANCES GENERAL PURPOSE RELAYS',
        '41553' => 'CBC3 / Relays IND'
        //change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
        //'40308' => 'CBC3 / Relays A&C',
        //'40309' => 'CBC3 / Relays IB'
    };
    
    public static map<String, String> map_relay_cbc2label_cbc2id = new map<String, String> {
        'CBC2 / Automotive Relays' => '13213',
        'CBC2 / APPLIANCES GENERAL PURPOSE RELAYS' => '30005',
        'CBC3 / Relays IND' => '41553'
        //change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
        //'CBC3 / Relays A&C' => '40308',
        //'CBC3 / Relays IB' => '40309'
    };
    
    public static map<String, String> map_Region_LV2TerritoryCode = new map<String, String>{
        'Appl EMEA' => '103004',
        'Appl Americas' => '102264',
        'Appl Asia Pacific' => '102706'
    };
        
    public static Set<String> set_excludedCode = new Set<String>{
        //update by nelson zheng 2015-10-21 for case 00900375
        //'30012','30015','30016','30017','30042','13213,30005','40308','40309'
        '30012','30014','30015','30016','30017','30042','13213','30005','41553'
        //change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
        //'30012','30014','30015','30016','30017','30042','13213','30005','40308','40309'
    };
    
    public static String getProductFamilySOQL(set<String> set_productFamily) {
        
        String soqlString = '';
        for(String cbc2label : set_productFamily) {
            if(APL_CompForecastBillingChart.map_cbc2label_soql.containsKey(cbc2label)) {
                soqlString += 'or' + APL_CompForecastBillingChart.map_cbc2label_soql.get(cbc2label);
            }
        }
        if(soqlString != '') {
            soqlString = '(' + soqlString.subString(2) + ')';
        }

        return soqlString;
    }
    
    
    public Integer getCurrentFiscalYear(){
        Integer year;
        for (Period period : [select Id, FiscalYearSettings.Name, Number 
                                from Period where StartDate<=Today and EndDate >=Today and Type = 'Quarter']) {
              
            if(period.FiscalYearSettings.Name != null){ //set current year
                year = Integer.valueOf(period.FiscalYearSettings.Name);
            }
            if(period.Number != null ){ //set current quarter
                CurrentFiscalQuarter = Integer.valueOf(period.Number);
            }
        } 
        
        list_exportHead = new list<String>();
        list_exportHead.add('Territory Name');
        if(source == 'AM'){
            list_exportHead.add('AM Grouping');
        }
        if(source == 'Relay'){
            list_exportHead.add('Relay Grouping');
        }
        if(source == 'RSM'){
            list_exportHead.add('RSM Grouping');
            list_exportHead.add('AM Grouping');
        }
        if(source == 'RSMRelay'){
            list_exportHead.add('RSM Relay Grouping');
            list_exportHead.add('Relay Grouping');
        }
        list_exportHead.add('Product Family');
        list_exportHead.add('Product/GPL Code');
        for(Integer j = year-1 ; j <= year + 1; j++){
            for(Integer i = 1; i < 5; i++){
                list_exportHead.add(j + '-Q' + i);
            }
        }
        system.debug('list_exportHead:'+list_exportHead);
          
        return year;
    }
    
    public APL_CompForecastBillingChart getThis(){
        return this;
    } 

    public string getTcodeAMGroupingMAP(){
        return JSON.serialize(map_territoryCode_AMGrouping);    
    }
    public string getRSMGroupingAMGroupingMAP(){
        return JSON.serialize(map_rsmGrouping_AMGrouping);  
    }
    public string getTcodeRelayGroupingMAP(){
        return JSON.serialize(map_territoryCode_RelayGrouping); 
    }
    public string getRSMRelayGroupingRelayGroupingMAP(){
        return JSON.serialize(map_rsmRelayGrouping_RelayGrouping);  
    }
        
    public list<String> getTNameByTcode(list<String> list_tcode){
        list<String> list_tName = new list<String>();
        set<String> set_territoryCode = new set<String>();
        String queryTName;
        set_territoryCode.addAll(list_tcode);
        if(source == 'RSM'){
            queryTName = 'Select Account_Manager__r.name tname From Account Where SALES_TERRITORY_CDE__c In: set_territoryCode Group By Account_Manager__r.name';
        }
        if(source == 'RSMRelay'){
            queryTName = 'Select Relay_Hierarchy__r.Level_7_Default_Owner__r.name tname From Account Where Relay_Specialist_Territory_Code__c In: set_territoryCode Group By Relay_Hierarchy__r.Level_7_Default_Owner__r.name';
        }
        for(AggregateResult result : database.Query(queryTName)){
            if(result.get('tname') != null && String.valueof(result.get('tname')) != ''){
                list_tName.add(String.valueof(result.get('tname')));
            }
        }
        return list_tName;
    }
    
    public map<String, String> getTNameMapByTcode(set<String> list_tcode){
        map<String, String> map_tName = new map<String, String>();
        //set<String> set_territoryCode = new set<String>();
        String queryTName;
        //set_territoryCode.addAll(list_tcode);
        if(source == 'RSM'){
            queryTName = 'Select Account_Manager__r.name tname, SALES_TERRITORY_CDE__c terr From Account Where SALES_TERRITORY_CDE__c In: list_tcode Group By Account_Manager__r.name, SALES_TERRITORY_CDE__c';
        }
        if(source == 'RSMRelay'){
            queryTName = 'Select Relay_Hierarchy__r.Level_7_Default_Owner__r.name tname, Relay_Specialist_Territory_Code__c terr From Account Where Relay_Specialist_Territory_Code__c In: list_tcode Group By Relay_Hierarchy__r.Level_7_Default_Owner__r.name, Relay_Specialist_Territory_Code__c';
        }
        for(AggregateResult result : database.Query(queryTName)){
            if(result.get('tname') != null && String.valueof(result.get('tname')) != ''){
                map_tName.put((String)result.get('terr'), (String)result.get('tname'));
                //list_tName.add(String.valueof(result.get('tname')));
            }
        }
        return map_tName;
    }
    
    
    public string getRSMTerritoryCode(){
        list<String> list_temp = new list<String>();
        String tCode = JSON.serialize(list_temp);
        AMGroupingJSON = JSON.serialize(list_temp);
        rSMRelayGroupingJSON = JSON.serialize(list_temp);
        if(source == 'RSM'){
            list_territoryCode = calTerritoryCode('AM');
            list_territoryName = getTNameByTcode(list_territoryCode);
            tCode = JSON.serialize(list_territoryName); 
            
            getGroupingMap();
            
            rSMGroupingJSON = JSON.serialize(list_RSMGrouping);
            //getAMGroupingByTerritoryCode('');
            getRSMAMGroupingByTerritoryCode('');
            AMGroupingJSON = JSON.serialize(list_AMGrouping);
        }
        return tCode;
    }
    
    public string getRSMRelayTerritoryCode(){
        list<String> list_temp = new list<String>();
        String tCode = JSON.serialize(list_temp);
        relayGroupingJSON = JSON.serialize(list_temp);
        rSMRelayGroupingJSON = JSON.serialize(list_temp);
        if(source == 'RSMRelay'){
            list_territoryCode = calTerritoryCode('Relay');
            list_territoryName = getTNameByTcode(list_territoryCode);
            tCode = JSON.serialize(list_territoryName);
            
            getGroupingMap();
            
            rSMRelayGroupingJSON = JSON.serialize(list_RSMRelayGrouping);
            //getRelayGroupingByTerritoryCode('');
            getRSMRelayGroupingByTerritoryCode('');
            relayGroupingJSON = JSON.serialize(list_RelayGrouping);
        }
        return tCode;
    }
    
    public string getAMGrouping(){
        if(source == 'AM'){
            return JSON.serialize(calAMGrouping(currentTerritoryCode));
        }
        return '';
    }
    
    public string getRelayGrouping(){
        if(source == 'Relay'){
            return JSON.serialize(calRelayGrouping(currentTerritoryCode));
        }
        return '';
    }
    
    public string getRegion(){
        if(source == 'GAM'){
            return JSON.serialize(calRegion());
        }
        return '';
    }
    
    public list<String> calAMGrouping(String territoryCode){
        list<String> list_am = new list<String>();
        String queryGrouping = 'select APL_AM_Display_Name__c amGrouping from Account where SALES_TERRITORY_CDE__c = :territoryCode and APL_AM_Display_Name__c != null and APL_AM_forecast_Plan_Account__c != null group by APL_AM_Display_Name__c';
        for(AggregateResult result : database.Query(queryGrouping)){
            list_am.add(String.valueof(result.get('amGrouping')));
        }
        return list_am;     
    }
    
    public list<String> calRelayGrouping(String territoryCode){
        list<String> list_relay = new list<String>();
        String queryGrouping = 'select APL_Relay_Display_Name__c relayGrouping from Account where Relay_Specialist_Territory_Code__c = :territoryCode and APL_Relay_Display_Name__c != null and APL_Relay_forecast_Plan_Account__c != null group by APL_Relay_Display_Name__c';
        for(AggregateResult result : database.Query(queryGrouping)){
            list_relay.add(String.valueof(result.get('relayGrouping')));
        }
        return list_relay;      
    }
    
    public list<String> calRegion(){
        set<String> set_lv2TerritoryCodes = new set<String>();
        set<String> set_GAMCodes = new set<String>();
        set<String> set_region = new set<String>();
        list<String> list_region = new list<String>();
        
        set_lv2TerritoryCodes.addAll(ClsAPLForecastUtil.map_LV2TerritoryCode_Region.keySet());
        String queryManagement = 'Select GAM_Code__c From APL_Forecast_Management__c Where GAM_Code__c != null AND Manager__c = \'' + UserInfo.getUserId() + '\' And RecordTypeId != null';
        for(APL_Forecast_Management__c afm : Database.query(queryManagement)){
            set_GAMCodes.add(afm.GAM_Code__c);
        }

        String queryRegion = 'Select Territory_L2_code__c From Account Where STATDESC__c != \'Not Active\' And GAMCD__c in : set_GAMCodes';
        queryRegion += ' And Territory_L2_code__c in : set_lv2TerritoryCodes';

        for(Account account : database.Query(queryRegion)){
            if(account.Territory_L2_code__c != null && ClsAPLForecastUtil.map_LV2TerritoryCode_Region.get(account.Territory_L2_code__c) != null){
                set_region.add(ClsAPLForecastUtil.map_LV2TerritoryCode_Region.get(account.Territory_L2_code__c));
            }
        }
        list_region.addAll(set_region);
        system.debug('list_region:'+list_region);

        return list_region;      
    }
    
    public String getProductFamily(){
        String result;
        if(source == 'Relay' || source == 'RSMRelay'){
            result = Json.serialize(map_relay_cbc2label_cbc2id.keySet());
        }else{
            result = Json.serialize(map_cbc2id_cbc2label.keySet()); 
        }
        return result;
    }
    
    
    @RemoteAction
    public static map<String, String> getChartData(String sData) {
        map<String, String> map_result = new map<String, String>();
        SearchData searchOb = (SearchData)JSON.deserialize(sData,SearchData.class);
        
        system.debug('searchOb:'+searchOb);        
        //try{   
            if(searchOb.source == 'AM'){
                map_result = getAMChartData(searchOb, false);
            }
            if(searchOb.source == 'Relay'){
                map_result = getRelayChartData(searchOb, false);
            }
            if(searchOb.source == 'GAM'){
                map_result = getGAMChartData(searchOb, false);
            }
            if(searchOb.source == 'RSM'){
                map_result = getRSMChartData(searchOb, false);
            }
            if(searchOb.source == 'RSMRelay'){
                map_result = getRSMRelayChartData(searchOb, false);
            }  
            //map_result.addAll(amount);
            map_result.put('message', 'success');
        //}
        //catch(Exception ex){
            //map_result.put('message', ex.getMessage());
            //map_result.put('amount', null);
       // }
        map_result.put('fiscalYear', searchOb.fiscalYear);
        map_result.put('fiscalQuarter', searchOb.fiscalQuarter);
        return map_result;
    }

    public static list<String> getTcodeByTName(list<String> list_tname, String source){
        list<String> list_tCode = new list<String>();
        set<String> set_territoryName = new set<String>();
        String queryTCode;
        set_territoryName.addAll(list_tname);
        if(source == 'RSM' || source == ''){
            queryTCode = 'Select SALES_TERRITORY_CDE__c tcode From Account Where Account_Manager__r.name In: set_territoryName Group By SALES_TERRITORY_CDE__c';
        }
        if(source == 'RSMRelay'){
            queryTCode = 'Select Relay_Specialist_Territory_Code__c tcode From Account Where Relay_Hierarchy__r.Level_7_Default_Owner__r.name In: set_territoryName Group By Relay_Specialist_Territory_Code__c';
        }
        for(AggregateResult result : database.Query(queryTCode)){
            if(result.get('tcode') != null && String.valueof(result.get('tcode')) != ''){
                list_tCode.add(String.valueof(result.get('tcode')));
            }
        }
        return list_tCode;
    }


    public static map<String, String> getAMChartData(SearchData searchOb, Boolean isExport) {
        map<String, String> map_result = new map<String, String>();
        if(!isExport){ // for chart
            map_result.put('amount', '0');
        }
    
        String queryPartIds;
        String territorName = '';
        Boolean hasRelay = false;
        set<String> set_productFamily = new set<String>();
        set<String> set_territorCode = new set<String>();
        
        if(searchOb.productFamily != null && searchOb.productFamily != ''){
            set_productFamily.addAll(searchOb.productFamily.split(';'));
        }else{
            set_productFamily.addAll(map_cbc2id_cbc2label.keySet());
            hasRelay = true;
        }
        system.debug('!@#set_productFamily.size = '+set_productFamily.size());
        for(String tcode : searchOb.territoryCode.split(';')){
            set_territorCode.add(tcode);
        }
        
        for(AggregateResult result : [Select Account_Manager__r.name tname From Account Where SALES_TERRITORY_CDE__c In: set_territorCode Group By Account_Manager__r.name]){
            if(result.get('tname') != null && String.valueof(result.get('tname')) != ''){
                territorName = String.valueof(result.get('tname'));
            }
        }
              
       if((Integer.valueOf(searchOb.FiscalYear) == Integer.valueOf(searchOb.currentFiscalYear) 
            && Integer.valueOf(searchOb.FiscalQuarter) < Integer.valueOf(searchOb.currentFiscalQuarter)) || Integer.valueOf(searchOb.FiscalYear) == (Integer.valueOf(searchOb.currentFiscalYear) - 1)){
            set<String> set_AccIds = new set<String>();
            set<String> set_pcode = new set<String>();
            set<String> set_excludeCode = new set<String>();

            ClsAPLForecastUtil.setRSMAccountIds(true, set_territorCode, set_AccIds);
            
            if(!set_productFamily.isEmpty()){
                if(set_productFamily.size() != 8) {
                    queryPartIds = APL_CompForecastBillingChart.getProductFamilySOQL(set_productFamily);
                }else {
                    hasRelay = true;
                }
                /*for(String fcode : set_productFamily){
                    if(fcode != 'Relay'){
                        set_pcode.add(map_cbc2id_cbc2label.get(fcode));
                    }
                    else{
                        set_pcode.addAll(map_relay_cbc2label_cbc2id.values());
                        hasRelay = true;
                    }
                }
                system.debug('set_productFamily:'+set_productFamily); 
                system.debug('set_pcode:' + set_pcode);
                system.debug('set_excludeCode:' + set_excludeCode); 
                set_excludeCode.addAll(map_cbc2id_cbc2label.values());
                set_excludeCode.addAll(map_relay_cbc2label_cbc2id.values());
                set_excludeCode.remove('Relay');
                set_excludeCode.remove('Other CBC2');
                set_excludeCode.removeAll(set_pcode);                    

                queryPartIds = ' (Part__r.Product_Hierarchy__r.CBC2__c in :set_pcode or Part__r.Product_Hierarchy__r.CBC3__c in :set_pcode) ';
                if(set_pcode.contains('Other CBC2')){
                    queryPartIds = ' (Part__r.Product_Hierarchy__r.CBC1__c != \'30007\' and Part__r.Product_Hierarchy__r.CBC2__c not in :set_excludeCode and Part__r.Product_Hierarchy__r.CBC3__c not in :set_excludeCode) ';
                }
                */
            }else{
                hasRelay = true;
            }
            
            if(!set_AccIds.isEmpty()){
                String queryBillingStr;
                if(!isExport){ // for Chart
                    queryBillingStr = 'SELECT sum(Bill_Amount_USD__c) billing FROM BBB_Month_Bill_Book_Cust_PN__c ';
                }
                else{ // for Export
                    queryBillingStr = 'SELECT sum(Bill_Amount_USD__c) billing, customer__r.APL_AM_Display_Name__c, Part__r.Product_Hierarchy__r.CBC2__c, Part__r.Product_Hierarchy__r.CBC3__c, Part__r.Product_Hierarchy__r.Name, Part__r.Product_Hierarchy__r.GPL_Description__c, Part__r.PRODUCT_CDE__c, Part__r.PROD_NAME__c FROM BBB_Month_Bill_Book_Cust_PN__c ';
                }
                /* update by nelson zheng 2015-10-21 for case 00900375 begin
                queryBillingStr += 'WHERE Customer__r.STATDESC__c = \'Active\' AND Profit_Center__c IN (\'APL\'';
                if(hasRelay || set_productFamily.contains('Relay')){
                    queryBillingStr +=', \'RPA\'';
                }*/
                queryBillingStr += 'WHERE Customer__r.STATDESC__c = \'Active\' ';
                
                //queryBillingStr += ') AND Bill_Amount_USD__c != 0';
                queryBillingStr += ' AND Bill_Amount_USD__c != 0';
                
                
                queryBillingStr +=  ' AND Fiscal_Year__c = \'' + searchOb.FiscalYear +'\' AND Fiscal_Quarter__c = \'' + searchOb.FiscalQuarter + '\'';
                queryBillingStr += ' AND Customer__c IN: set_AccIds';
                queryBillingStr += ' AND Customer__r.SALES_TERRITORY_CDE__c IN: set_territorCode';
                /*
                if(queryPartIds != null){
                    queryBillingStr += ' AND ' + queryPartIds;
                }
                */
                if(queryPartIds != null){
                    queryBillingStr += ' AND Profit_Center__c = \'APL\' AND ' + queryPartIds;
                }else{
                    if(hasRelay || set_productFamily.contains('Relay')){
                        queryBillingStr += ' AND Profit_Center__c = \'APL\'';
                    }else{
                    	//change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
                        queryBillingStr += ' AND (Profit_Center__c = \'APL\' and Part__r.Product_Hierarchy__r.CBC3__c not in (\'41553\') and Part__r.Product_Hierarchy__r.CBC2__c not in (\'30005\',\'13213\'))';
                    }
                }
                System.debug('---------APL_CompForecastBillingChart.cls (10 matches) 1--------------');
                //update by nelson zheng 2015-10-21 for case 00900375 end
                
                if(searchOb.aMGrouping !=null && searchOb.aMGrouping != ''){
                    queryBillingStr += ' AND customer__r.APL_AM_Display_Name__c in (\''+ (String)searchOb.aMGrouping.replaceAll(';', '\', \'') + '\')';
                }else {
                    // update 2016-04-06 by Mingxing Qiu  because page date and chart date unlike 
                    //queryBillingStr += ' AND customer__r.APL_AM_forecast_Plan_Account__c != null ';
                }

                if(isExport){ // for Export
                    queryBillingStr +=  ' Group By customer__r.APL_AM_Display_Name__c, Part__r.Product_Hierarchy__r.CBC2__c, Part__r.Product_Hierarchy__r.CBC3__c, Part__r.Product_Hierarchy__r.Name, Part__r.Product_Hierarchy__r.GPL_Description__c, Part__r.PRODUCT_CDE__c, Part__r.PROD_NAME__c';
                }

                system.debug('queryBillingStr:'+queryBillingStr);
                system.debug('set_AccIds:'+set_AccIds);
                system.debug('queryPartIds:'+queryPartIds);

                if(!isExport){ // for Chart
                    for(AggregateResult  result : Database.query(queryBillingStr)) {
                        if(result.get('billing') != null ){
                            map_result.put('amount', String.valueOf(result.get('billing')));
                        }
                    }   
                }
                else{
                    for(AggregateResult  result : Database.query(queryBillingStr)) {
                        if(result.get('billing') != null ){
                            String productFamily ='';
                            String productCode = '';
                            String groupKey = territorName;
                            
                            if(result.get('APL_AM_Display_Name__c') != null){
                                groupKey += '|' + (String)result.get('APL_AM_Display_Name__c');
                                
                                if(map_cbc2label_cbc2id.get((String)result.get('CBC2__c')) != null && result.get('Name') != null && result.get('GPL_Description__c') != null){
                                    productFamily = map_cbc2label_cbc2id.get((String)result.get('CBC2__c'));
                                    productCode = '[ ' + (String)result.get('Name') + ' ] - ' + (String)result.get('GPL_Description__c');
                                }else if(map_relay_cbc2id_cbc2label.get((String)result.get('CBC2__c')) != null && result.get('PRODUCT_CDE__c') != null && result.get('PROD_NAME__c') != null){
                                    productFamily = map_relay_cbc2id_cbc2label.get((String)result.get('CBC2__c'));
                                    productCode = '[ ' + (String)result.get('PRODUCT_CDE__c') + ' ] - ' + (String)result.get('PROD_NAME__c');
                                }else if(map_relay_cbc2id_cbc2label.get((String)result.get('CBC3__c')) != null && result.get('PRODUCT_CDE__c') != null && result.get('PROD_NAME__c') != null ){
                                    productFamily = map_relay_cbc2id_cbc2label.get((String)result.get('CBC3__c'));
                                    productCode = '[ ' + (String)result.get('PRODUCT_CDE__c') + ' ] - ' + (String)result.get('PROD_NAME__c');
                                }else{
                                    productFamily = map_cbc2label_cbc2id.get('Other CBC2');
                                }
                                
                                if(productFamily != ''){
                                    groupKey += '|' + productFamily;
                                    
                                    if(productCode != ''){
                                        groupKey += '|' + productCode;
                                    }
    
                                }
                            }
                            if(!map_result.containsKey(groupKey)){
                                map_result.put(groupKey, String.valueOf(result.get('billing')));
                            }
                            else{
                                Decimal m = Decimal.valueOf(map_result.get(groupKey));
                                m +=  (decimal)result.get('billing');
                                map_result.put(groupKey, String.valueOf(m));
                            }
                        }
                    }
                }
            }
        }else{
            set<String> set_relaycode = new set<String>();
            
            String queryForecastStr;
            if(!isExport){ // for Chart
                queryForecastStr = 'SELECT sum(Forecast__c) fc FROM APL_Sales_Forecast__c WHERE Forecast__c != null';
            }
            else{ // for export
                queryForecastStr = 'SELECT sum(Forecast__c) fc, customer__r.APL_AM_Display_Name__c, Type__c, GPL__r.CBC2__c, GPL__r.CBC3__c, GPL__r.Name, GPL__r.GPL_Description__c, Relay_CBC2_Code__c, PRODUCT_CDE__c, PROD_NAME__c FROM APL_Sales_Forecast__c WHERE Forecast__c != null';
            }

            queryForecastStr +=  ' AND Customer__r.STATDESC__c != \'Not Active\' AND Fiscal_Year__c = \'' + searchOb.FiscalYear +'\' AND Fiscal_Quarter__c = \'0' + searchOb.FiscalQuarter + '\'';
    
            if(searchOb.aMGrouping !=null && searchOb.aMGrouping != ''){
                queryForecastStr += ' AND customer__r.APL_AM_Display_Name__c in (\''+ (String)searchOb.aMGrouping.replaceAll(';', '\', \'') + '\')';
            }
            queryForecastStr += ' AND Customer__r.SALES_TERRITORY_CDE__c IN: set_territorCode';
            if(!set_productFamily.isEmpty()){
                String productFamilyFilter = '';
                
                if(set_productFamily.contains('Relay')){
                    set_relaycode.addAll(map_relay_cbc2label_cbc2id.values());
                    productFamilyFilter += ' OR (Type__c = \'Relay Product Code\' AND Relay_CBC2_Code__c IN: set_relaycode)';
                    set_productFamily.remove('Relay');
                }

                if(set_productFamily.contains('Other BU Products')){
                    productFamilyFilter += ' OR Type__c = \'Other CBC2\'';
                    set_productFamily.remove('Other BU Products');
                }
                if(set_productFamily.size() > 0){
                    productFamilyFilter += ' OR (Type__c = \'GPL\' AND (';
                    String cbcCodes = '(';
                    for(String pfkey : set_productFamily){
                        cbcCodes += '\'' + map_cbc2id_cbc2label.get(pfkey) + '\', ';
                    }
                    cbcCodes = cbcCodes.substring(0, cbcCodes.lastIndexOf(',')) + ')';
                    productFamilyFilter += 'GPL__r.CBC2__c IN ' + cbcCodes + ' OR GPL__r.CBC3__c IN ' + cbcCodes + '))';
                }
                if(productFamilyFilter.indexOf('OR') == 1){
                    productFamilyFilter = productFamilyFilter.substring(4, productFamilyFilter.length());
                }
                    
                queryForecastStr += ' AND (' + productFamilyFilter + ')';
            }
            
            if(isExport){ //for Export
                queryForecastStr += ' Group By customer__r.APL_AM_Display_Name__c, Type__c, GPL__r.CBC2__c, GPL__r.CBC3__c, GPL__r.Name, GPL__r.GPL_Description__c, Relay_CBC2_Code__c, PRODUCT_CDE__c, PROD_NAME__c ';
            }


            system.debug('queryForecastStr:'+queryForecastStr);

            if(!isExport){ //for chart
                for(AggregateResult  result : Database.query(queryForecastStr)) {
                    if(result.get('fc') != null ){
                        map_result.put('amount',String.valueOf(result.get('fc')));
                    }
                }
            }
            else{ // for export
                for(AggregateResult  result : Database.query(queryForecastStr)) {
                    if(result.get('fc') != null){
                        String productFamily ='';
                        String productCode = '';
                        String groupKey = territorName;
                        
                        if(result.get('APL_AM_Display_Name__c') != null){
                            groupKey += '|' + (String)result.get('APL_AM_Display_Name__c');
                            
                            if(result.get('Type__c') == 'GPL' && map_cbc2label_cbc2id.get((String)result.get('CBC2__c')) != null && result.get('Name') != null && result.get('GPL_Description__c') != null){
                                productFamily = map_cbc2label_cbc2id.get((String)result.get('CBC2__c'));
                                productCode = '[ ' + (String)result.get('Name') + ' ] - ' + (String)result.get('GPL_Description__c');
                            }else if(result.get('Type__c') == 'Relay Product Code' && map_relay_cbc2id_cbc2label.get((String)result.get('Relay_CBC2_Code__c')) != null && result.get('PRODUCT_CDE__c') != null && result.get('PROD_NAME__c') != null){
                                productFamily = map_relay_cbc2id_cbc2label.get((String)result.get('Relay_CBC2_Code__c'));
                                productCode = '[ ' + (String)result.get('PRODUCT_CDE__c') + ' ] - ' + (String)result.get('PROD_NAME__c');
                            }else if(result.get('Type__c') == 'Other CBC2'){
                                productFamily = map_cbc2label_cbc2id.get('Other CBC2');
                            }
                            
                            if(productFamily != ''){
                                groupKey += '|' + productFamily;
                                
                                if(productCode != ''){
                                    groupKey += '|' + productCode;
                                }

                            }
                        }
                        if(!map_result.containsKey(groupKey)){
                            map_result.put(groupKey, String.valueOf(result.get('fc')));
                        }
                        else{
                            Decimal m = Decimal.valueOf(map_result.get(groupKey));
                            m +=  (decimal)result.get('fc');
                            map_result.put(groupKey, String.valueOf(m));
                        }
                    }
                }
            }
        }
        system.debug('map_result:' + map_result);
        return map_result;
    }


    public static map<String, String> getRelayChartData(SearchData searchOb, Boolean isExport) {
        map<String, String> map_result = new map<String, String>();
        if(!isExport){ // for chart
            map_result.put('amount', '0');
        }   

        String queryPartIds;
        String territorName = '';
        set<String> set_productFamily = new set<String>();
        set<String> set_territorCode = new set<String>();
        
        if(searchOb.productFamily != null && searchOb.productFamily != ''){
            set_productFamily.addAll(searchOb.productFamily.split(';'));
        }else{
            set_productFamily.addAll(map_relay_cbc2label_cbc2id.keySet());
        }

        for(String tcode : searchOb.territoryCode.split(';')){
            set_territorCode.add(tcode);
        }
        
        for(AggregateResult result : [Select Relay_Hierarchy__r.Level_7_Default_Owner__r.name tname From Account Where Relay_Specialist_Territory_Code__c In: set_territorCode Group By Relay_Hierarchy__r.Level_7_Default_Owner__r.name]){
            if(result.get('tname') != null && String.valueof(result.get('tname')) != ''){
                territorName = String.valueof(result.get('tname'));
            }
        }
        
        system.debug('set_productFamily:'+set_productFamily); 
        system.debug('searchOb:'+searchOb); 
        
        if((Integer.valueOf(searchOb.FiscalYear) == Integer.valueOf(searchOb.currentFiscalYear) 
            && Integer.valueOf(searchOb.FiscalQuarter) < Integer.valueOf(searchOb.currentFiscalQuarter)) || Integer.valueOf(searchOb.FiscalYear) == (Integer.valueOf(searchOb.currentFiscalYear) - 1)){
            set<String> set_AccIds = new set<String>();
            
            system.debug('set_territorCode:'+set_territorCode);
            ClsAPLForecastUtil.setRSMAccountIds(false, set_territorCode, set_AccIds);
            
            if(!set_productFamily.isEmpty()){
                
                queryPartIds = APL_CompForecastBillingChart.getProductFamilySOQL(set_productFamily);
                
                /*set<String> set_pcode = new set<String>();
                for(String fcode : set_productFamily){
                    set_pcode.add(map_relay_cbc2label_cbc2id.get(fcode));
                }
                system.debug('set_pcode:' + set_pcode);
                queryPartIds = ' (Part__r.Product_Hierarchy__r.CBC2__c in :set_pcode or Part__r.Product_Hierarchy__r.CBC3__c in :set_pcode) ';
                */
            }
            
            if(!set_AccIds.isEmpty()){
                String queryBillingStr;
                if(!isExport){ // for Chart
                    queryBillingStr = 'SELECT sum(Bill_Amount_USD__c) billing FROM BBB_Month_Bill_Book_Cust_PN__c ';
                }
                else{ // for Export
                    queryBillingStr = 'SELECT sum(Bill_Amount_USD__c) billing, customer__r.APL_Relay_Display_Name__c, Part__r.Product_Hierarchy__r.CBC2__c, Part__r.Product_Hierarchy__r.CBC3__c, Part__r.Product_Hierarchy__r.Name, Part__r.Product_Hierarchy__r.GPL_Description__c, Part__r.PRODUCT_CDE__c, Part__r.PROD_NAME__c FROM BBB_Month_Bill_Book_Cust_PN__c ';
                }
                
                //update by nelson zheng 2015-10-21 for case 00900375
                //queryBillingStr += 'WHERE Customer__r.STATDESC__c = \'Active\' AND Profit_Center__c IN (\'RPA\') AND Bill_Amount_USD__c != 0';
                queryBillingStr += 'WHERE Customer__r.STATDESC__c = \'Active\' AND Bill_Amount_USD__c != 0';
                System.debug('---------APL_CompForecastBillingChart.cls (10 matches) 2--------------');
                queryBillingStr +=  ' AND Fiscal_Year__c = \'' + searchOb.FiscalYear +'\' AND Fiscal_Quarter__c = \'' + searchOb.FiscalQuarter + '\'';
                queryBillingStr += ' AND Customer__c IN: set_AccIds';
                queryBillingStr += ' AND Customer__r.Relay_Specialist_Territory_Code__c IN: set_territorCode';
                /*update by nelson zheng 2015-10-21 for case 00900375
                if(queryPartIds != null){
                    queryBillingStr += ' AND ' + queryPartIds;
                }*/
                if(queryPartIds != null){
                    queryBillingStr += ' AND Profit_Center__c = \'APL\' AND ' + queryPartIds;
                }else{
                	//change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
                    queryBillingStr += ' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'41553\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) ';
                }//update by nelson zheng 2015-10-21 for case 00900375
                
                if(searchOb.relayGrouping !=null && searchOb.relayGrouping != ''){
                    queryBillingStr += ' AND customer__r.APL_Relay_Display_Name__c in (\''+ (String)searchOb.relayGrouping.replaceAll(';', '\', \'') + '\')';
                }else {
                    // update 2016-04-06 by Mingxing Qiu  because page date and chart date unlike 
                   // queryBillingStr += ' AND customer__r.APL_Relay_forecast_Plan_Account__c != null ';
                }
                
                if(isExport){ // for Export
                    queryBillingStr +=  ' Group By customer__r.APL_Relay_Display_Name__c, Part__r.Product_Hierarchy__r.CBC2__c, Part__r.Product_Hierarchy__r.CBC3__c, Part__r.Product_Hierarchy__r.Name, Part__r.Product_Hierarchy__r.GPL_Description__c, Part__r.PRODUCT_CDE__c, Part__r.PROD_NAME__c';
                }
                
                system.debug('queryBillingStr:'+queryBillingStr);
                system.debug('set_AccIds:'+set_AccIds);
                system.debug('queryPartIds:'+queryPartIds);

                if(!isExport){ // for Chart
                    for(AggregateResult  result : Database.query(queryBillingStr)) {
                        if(result.get('billing') != null ){
                            map_result.put('amount', String.valueOf(result.get('billing')));
                        }
                    }   
                }
                else{
                    for(AggregateResult  result : Database.query(queryBillingStr)) {
                        if(result.get('billing') != null ){
                            String productFamily ='';
                            String productCode = '';
                            String groupKey = territorName;
                            
                            if(result.get('APL_Relay_Display_Name__c') != null){
                                groupKey += '|' + (String)result.get('APL_Relay_Display_Name__c');
                                
                                if(map_relay_cbc2id_cbc2label.get((String)result.get('CBC2__c')) != null && result.get('PRODUCT_CDE__c') != null && result.get('PROD_NAME__c') != null){
                                    productFamily = map_relay_cbc2id_cbc2label.get((String)result.get('CBC2__c'));
                                    productCode = '[ ' + (String)result.get('PRODUCT_CDE__c') + ' ] - ' + (String)result.get('PROD_NAME__c');
                                }else if(map_relay_cbc2id_cbc2label.get((String)result.get('CBC3__c')) != null && result.get('PRODUCT_CDE__c') != null && result.get('PROD_NAME__c') != null ){
                                    productFamily = map_relay_cbc2id_cbc2label.get((String)result.get('CBC3__c'));
                                    productCode = '[ ' + (String)result.get('PRODUCT_CDE__c') + ' ] - ' + (String)result.get('PROD_NAME__c');
                                }
                                
                                if(productFamily != ''){
                                    groupKey += '|' + productFamily;
                                    
                                    if(productCode != ''){
                                        groupKey += '|' + productCode;
                                    }
                                }
                            }
                            if(!map_result.containsKey(groupKey)){
                                map_result.put(groupKey, String.valueOf(result.get('billing')));
                            }
                            else{
                                Decimal m = Decimal.valueOf(map_result.get(groupKey));
                                m +=  (decimal)result.get('billing');
                                map_result.put(groupKey, String.valueOf(m));
                            }
                        }
                    }
                }
            }
        }else{
            String queryForecastStr;
            if(!isExport){ // for Chart
                queryForecastStr = 'SELECT sum(Forecast__c) fc FROM APL_Sales_Forecast__c WHERE Forecast__c != null';
            }
            else{ // for export
                queryForecastStr = 'SELECT sum(Forecast__c) fc, customer__r.APL_Relay_Display_Name__c, Type__c, GPL__r.CBC2__c, GPL__r.CBC3__c, GPL__r.Name, GPL__r.GPL_Description__c, Relay_CBC2_Code__c, PRODUCT_CDE__c, PROD_NAME__c FROM APL_Sales_Forecast__c WHERE Forecast__c != null';
            }
            
            queryForecastStr +=  ' AND Customer__r.STATDESC__c != \'Not Active\' AND Customer__r.APL_Relay_forecast_Plan_Account__c != null AND Fiscal_Year__c = \'' + searchOb.FiscalYear +'\' AND Fiscal_Quarter__c = \'0' + searchOb.FiscalQuarter + '\'';
    
            queryForecastStr += ' AND Customer__r.Relay_Specialist_Territory_Code__c IN: set_territorCode';
            if(searchOb.relayGrouping !=null && searchOb.relayGrouping != ''){
                queryForecastStr += ' AND customer__r.APL_Relay_Display_Name__c in (\''+ (String)searchOb.relayGrouping.replaceAll(';', '\', \'') + '\')';
            }
            if(!set_productFamily.isEmpty()){
                queryForecastStr += ' AND Type__c = \'Relay Product Code\' AND ';
                String cbcCodes = '(';
                for(String pfkey : set_productFamily){
                    cbcCodes += '\'' + map_relay_cbc2label_cbc2id.get(pfkey) + '\', ';
                }
                cbcCodes = cbcCodes.substring(0, cbcCodes.lastIndexOf(',')) + ')';
               queryForecastStr += 'Relay_CBC2_Code__c IN ' + cbcCodes;
            }
            
            if(isExport){ //for Export
                queryForecastStr += ' Group By customer__r.APL_Relay_Display_Name__c, Type__c, GPL__r.CBC2__c, GPL__r.CBC3__c, GPL__r.Name, GPL__r.GPL_Description__c, Relay_CBC2_Code__c, PRODUCT_CDE__c, PROD_NAME__c';
            }
    
            system.debug('queryForecastStr:'+queryForecastStr);
            
            if(!isExport){ //for chart
                for(AggregateResult  result : Database.query(queryForecastStr)) {
                    if(result.get('fc') != null ){
                        map_result.put('amount',String.valueOf(result.get('fc')));
                    }
                }
            }
            else{ // for export
                for(AggregateResult  result : Database.query(queryForecastStr)) {
                    if(result.get('fc') != null){
                        String productFamily ='';
                        String productCode = '';
                        String groupKey = territorName;
                        
                        if(result.get('APL_Relay_Display_Name__c') != null){
                            groupKey += '|' + (String)result.get('APL_Relay_Display_Name__c');
                            
                            if(result.get('Type__c') == 'Relay Product Code' && map_relay_cbc2id_cbc2label.get((String)result.get('Relay_CBC2_Code__c')) != null && result.get('PRODUCT_CDE__c') != null && result.get('PROD_NAME__c') != null){
                                productFamily = map_relay_cbc2id_cbc2label.get((String)result.get('Relay_CBC2_Code__c'));
                                productCode = '[ ' + (String)result.get('PRODUCT_CDE__c') + ' ] - ' + (String)result.get('PROD_NAME__c');
                            }
                            
                            if(productFamily != ''){
                                groupKey += '|' + productFamily;
                                
                                if(productCode != ''){
                                    groupKey += '|' + productCode;
                                }
                            }
                        }
                        if(!map_result.containsKey(groupKey)){
                            map_result.put(groupKey, String.valueOf(result.get('fc')));
                        }
                        else{
                            Decimal m = Decimal.valueOf(map_result.get(groupKey));
                            m +=  (decimal)result.get('fc');
                            map_result.put(groupKey, String.valueOf(m));
                        }
                    }
                }
            }
        }
        system.debug('map_result:' + map_result);
        
        return map_result;
    }
    
    
    public static map<String, String> getRegionNameByL2TCode(map<String, String> map_Code){
        map<String, String> map_tmp = new map<String, String>();
        for(String rName: map_Code.keySet()){
            map_tmp.put(map_Code.get(rName), rName);
        }
        return map_tmp;
    }

    public static map<String, String> getGAMChartData(SearchData searchOb, Boolean isExport) {
        map<String, String> map_result = new map<String, String>();
        map<String, String> map_tCodeRegion  = getRegionNameByL2TCode(map_Region_LV2TerritoryCode);
        if(!isExport){ // for chart
            map_result.put('amount', '0');
        }  
                
        decimal amount = 0;
        String queryPartIds;
        set<string> set_region = new set<string>();
        set<String> set_productFamily = new set<String>();
        set<String> set_GAMCodes = new set<String>();
        Boolean hasRelay = false;
        
        String queryManagement = 'Select GAM_Code__c From APL_Forecast_Management__c Where GAM_Code__c != null AND Manager__c = \'' + UserInfo.getUserId() + '\' And RecordType.Name != null';
        for(APL_Forecast_Management__c afm : Database.query(queryManagement)){
            set_GAMCodes.add(afm.GAM_Code__c);
        }
        //
        if(searchOb.region !=null && searchOb.region != ''){
            for(String region : searchOb.region.split(';')){
                if(map_Region_LV2TerritoryCode.get(region) != null){
                    set_region.add(map_Region_LV2TerritoryCode.get(region));
                }
            }
        }else{
            set<String> set_lv2TerritoryCodes = new set<String>();
            set_lv2TerritoryCodes.addAll(ClsAPLForecastUtil.map_LV2TerritoryCode_Region.keySet());
            String queryRegion = 'Select Territory_L2_code__c From Account Where STATDESC__c != \'Not Active\' And GAMCD__c in : set_GAMCodes';
            queryRegion += ' And Territory_L2_code__c in : set_lv2TerritoryCodes';
    
            for(Account account : database.Query(queryRegion)){
                if(account.Territory_L2_code__c != null && ClsAPLForecastUtil.map_LV2TerritoryCode_Region.get(account.Territory_L2_code__c) != null){
                    set_region.add(account.Territory_L2_code__c);
                }
            }
        }
        system.debug('set_region:' + set_region);
        
        if(searchOb.productFamily != null && searchOb.productFamily != ''){
            set_productFamily.addAll(searchOb.productFamily.split(';'));
        }else{
            set_productFamily.addAll(map_cbc2id_cbc2label.keySet());
            hasRelay = true;
        }
        system.debug('set_productFamily:'+set_productFamily); 
        
         if((Integer.valueOf(searchOb.FiscalYear) == Integer.valueOf(searchOb.currentFiscalYear) 
            && Integer.valueOf(searchOb.FiscalQuarter) < Integer.valueOf(searchOb.currentFiscalQuarter)) || Integer.valueOf(searchOb.FiscalYear) == (Integer.valueOf(searchOb.currentFiscalYear) - 1)){
            
            if(!set_productFamily.isEmpty()){
                
                if(set_productFamily.size() != 8) {
                    queryPartIds = APL_CompForecastBillingChart.getProductFamilySOQL(set_productFamily);
                }else {
                    hasRelay = true;
                }
                
                /*set<String> set_pcode = new set<String>();
                for(String fcode : set_productFamily){
                    if(fcode != 'Relay'){
                        set_pcode.add(map_cbc2id_cbc2label.get(fcode));
                    }
                    else{
                        set_pcode.addAll(map_relay_cbc2label_cbc2id.values());
                        hasRelay = true;
                    }
                }
                system.debug('set_pcode:' + set_pcode);
                set<String> set_excludeCode = new set<String>();
                set_excludeCode.addAll(map_cbc2id_cbc2label.values());
                set_excludeCode.addAll(map_relay_cbc2label_cbc2id.values());
                set_excludeCode.remove('Relay');
                set_excludeCode.remove('Other CBC2');
                set_excludeCode.removeAll(set_pcode);
                
                system.debug('set_excludCode:' + set_excludeCode);
                queryPartIds = ' (Part__r.Product_Hierarchy__r.CBC2__c in :set_pcode or Part__r.Product_Hierarchy__r.CBC3__c in :set_pcode) ';
                if(set_pcode.contains('Other CBC2')){
                    queryPartIds = ' (Part__r.Product_Hierarchy__r.CBC1__c != \'30007\' and Part__r.Product_Hierarchy__r.CBC2__c not in :set_excludeCode and Part__r.Product_Hierarchy__r.CBC3__c not in :set_excludeCode) ';
                }*/           
            }else{
                hasRelay = true;
            }

            String queryBillingStr; 
            if(!isExport){//for Chart
                queryBillingStr = 'SELECT sum(Bill_Amount_USD__c) billing FROM BBB_Month_Bill_Book_Cust_PN__c ';
            }
            else{ // for Export
                queryBillingStr = 'SELECT sum(Bill_Amount_USD__c) billing, customer__r.Sales_Hierarchy__r.Level_2_Territory_Code__c region,  Part__r.Product_Hierarchy__r.CBC2__c, Part__r.Product_Hierarchy__r.CBC3__c, Part__r.Product_Hierarchy__r.Name, Part__r.Product_Hierarchy__r.GPL_Description__c, Part__r.PRODUCT_CDE__c, Part__r.PROD_NAME__c FROM BBB_Month_Bill_Book_Cust_PN__c ';
            } 
            
            /* update by nelson zheng 2015-10-21 for case 00900375 begin
            queryBillingStr += 'WHERE Customer__r.STATDESC__c = \'Active\' AND Profit_Center__c IN (\'APL\'';
            if(hasRelay || set_productFamily.contains('Relay')){
                queryBillingStr +=', \'RPA\'';
            }*/
            queryBillingStr += 'WHERE Customer__r.STATDESC__c = \'Active\'';
            
            //queryBillingStr += ') AND Bill_Amount_USD__c != 0';
            queryBillingStr += ' AND Bill_Amount_USD__c != 0';
            
            queryBillingStr +=  ' AND Fiscal_Year__c = \'' + searchOb.FiscalYear +'\' AND Fiscal_Quarter__c = \'' + searchOb.FiscalQuarter + '\'';
            /*
            if(queryPartIds != null){
                queryBillingStr += ' AND ' + queryPartIds;
            }
            */
            if(queryPartIds != null){
                queryBillingStr += ' AND Profit_Center__c = \'APL\' AND ' + queryPartIds;
            }else{
                if(hasRelay || set_productFamily.contains('Relay')){
                    queryBillingStr += ' AND Profit_Center__c = \'APL\'';
                }else{
                	//change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
                    queryBillingStr += ' AND (Profit_Center__c = \'APL\' and Part__r.Product_Hierarchy__r.CBC3__c not in (\'41553\') and Part__r.Product_Hierarchy__r.CBC2__c not in (\'30005\',\'13213\'))';
                }
            }
            System.debug('---------APL_CompForecastBillingChart.cls (10 matches) 3--------------');
            //update by nelson zheng 2015-10-21 for case 00900375 end
            
            if(!set_region.isEmpty()){
                queryBillingStr += ' AND customer__r.Territory_L2_code__c In: set_region';
            }
            queryBillingStr += ' AND customer__r.GAMCD__c in :set_GAMCodes';

            if(isExport){ // for Export
                queryBillingStr += ' group by customer__r.Sales_Hierarchy__r.Level_2_Territory_Code__c , Part__r.Product_Hierarchy__r.CBC2__c, Part__r.Product_Hierarchy__r.CBC3__c, Part__r.Product_Hierarchy__r.Name, Part__r.Product_Hierarchy__r.GPL_Description__c, Part__r.PRODUCT_CDE__c, Part__r.PROD_NAME__c  ';
            } 

            system.debug('queryBillingStr:'+queryBillingStr);

            if(!isExport){ //for Chart
                for(AggregateResult  result : Database.query(queryBillingStr)) {
                    if(result.get('billing') != null){
                        map_result.put('amount', String.valueOf(result.get('billing')));
                    }
                }   
            }else{ // for Export
                for(AggregateResult  result : Database.query(queryBillingStr)) {
                    if(result.get('billing') != null){
                        String productFamily ='';
                        String productCode = '';
                        String groupKey;

                        if(result.get('region') != null && map_tCodeRegion.containsKey(String.valueOf(result.get('region')))){ // get region name based on Territory_L2_code__c
                            groupKey = map_tCodeRegion.get(String.valueOf(result.get('region')));
                        
                            if(map_cbc2label_cbc2id.get((String)result.get('CBC2__c')) != null && result.get('Name') != null && result.get('GPL_Description__c') != null){
                                productFamily = map_cbc2label_cbc2id.get((String)result.get('CBC2__c'));
                                productCode = '[ ' + (String)result.get('Name') + ' ] - ' + (String)result.get('GPL_Description__c');
                            }else if(map_relay_cbc2id_cbc2label.get((String)result.get('CBC2__c')) != null && result.get('PRODUCT_CDE__c') != null && result.get('PROD_NAME__c') != null){
                                productFamily = map_relay_cbc2id_cbc2label.get((String)result.get('CBC2__c'));
                                productCode = '[ ' + (String)result.get('PRODUCT_CDE__c') + ' ] - ' + (String)result.get('PROD_NAME__c');
                            }else if(map_relay_cbc2id_cbc2label.get((String)result.get('CBC3__c')) != null && result.get('PRODUCT_CDE__c') != null && result.get('PROD_NAME__c') != null ){
                                productFamily = map_relay_cbc2id_cbc2label.get((String)result.get('CBC3__c'));
                                productCode = '[ ' + (String)result.get('PRODUCT_CDE__c') + ' ] - ' + (String)result.get('PROD_NAME__c');
                            }else{
                                productFamily = map_cbc2label_cbc2id.get('Other CBC2'); //key for other BU Products
                            }
                            
                            if(productFamily != ''){
                                groupKey += '|' + productFamily;
                                if(productCode != ''){
                                    groupKey += '|' + productCode;
                                }
                            }
                            if(!map_result.containsKey(groupKey)){
                                map_result.put(groupKey, String.valueOf(result.get('billing')));
                            }
                            else{
                                Decimal m = Decimal.valueOf(map_result.get(groupKey));
                                m +=  (decimal)result.get('billing');
                                map_result.put(groupKey, String.valueOf(m));
                            }
                        }
                    }
                }
            }
        }
        else{
            set<String> set_relaycode = new set<String>();
            String queryForecastStr;
            if(!isExport){// for Chart
                queryForecastStr = 'SELECT sum(GAM_Forecast__c) fc FROM APL_Sales_Forecast__c WHERE GAM_Forecast__c != null';
            } 
            else{
                queryForecastStr = 'SELECT sum(GAM_Forecast__c) fc, customer__r.Sales_Hierarchy__r.Level_2_Territory_Code__c region, Type__c, GPL__r.CBC2__c, GPL__r.CBC3__c, GPL__r.Name, GPL__r.GPL_Description__c, Relay_CBC2_Code__c, PRODUCT_CDE__c, PROD_NAME__c FROM APL_Sales_Forecast__c WHERE GAM_Forecast__c != null';
            }
             
            queryForecastStr +=  ' AND Customer__r.STATDESC__c != \'Not Active\' AND Fiscal_Year__c = \'' + searchOb.FiscalYear +'\' AND Fiscal_Quarter__c = \'0' + searchOb.FiscalQuarter + '\'';
            
            if(!set_region.isEmpty()){
                queryForecastStr += ' AND customer__r.Territory_L2_code__c In: set_region';
            }

            queryForecastStr += ' AND customer__r.GAMCD__c in :set_GAMCodes';
            
            if(!set_productFamily.isEmpty()){
                String productFamilyFilter = '';
                
                if(set_productFamily.contains('Relay')){
                    set_relaycode.addAll(map_relay_cbc2label_cbc2id.values());
                    productFamilyFilter += ' OR (Type__c = \'Relay Product Code\' AND Relay_CBC2_Code__c IN: set_relaycode)';
                    set_productFamily.remove('Relay');
                }
                if(set_productFamily.contains('Other BU Products')){
                    productFamilyFilter += ' OR Type__c = \'Other CBC2\'';
                    set_productFamily.remove('Other BU Products');
                }
                if(set_productFamily.size() > 0){
                    productFamilyFilter += ' OR (Type__c = \'GPL\' AND (';
                    String cbcCodes = '(';
                    for(String pfkey : set_productFamily){
                        cbcCodes += '\'' + map_cbc2id_cbc2label.get(pfkey) + '\', ';
                    }
                    cbcCodes = cbcCodes.substring(0, cbcCodes.lastIndexOf(',')) + ')';
                    productFamilyFilter += 'GPL__r.CBC2__c IN ' + cbcCodes + ' OR GPL__r.CBC3__c IN ' + cbcCodes + '))';
                }
                if(productFamilyFilter.indexOf('OR') == 1){
                    productFamilyFilter = productFamilyFilter.substring(4, productFamilyFilter.length());
                }
                    
                queryForecastStr += ' AND (' + productFamilyFilter + ')';
            }

            if(isExport){
                queryForecastStr += ' Group By customer__r.Sales_Hierarchy__r.Level_2_Territory_Code__c, Type__c, GPL__r.CBC2__c, GPL__r.CBC3__c, GPL__r.Name, GPL__r.GPL_Description__c, Relay_CBC2_Code__c, PRODUCT_CDE__c, PROD_NAME__c';
            }
            system.debug('set_relaycode:'+set_relaycode);
            system.debug('set_GAMCodes:'+set_GAMCodes);
            system.debug('queryForecastStr:'+queryForecastStr);
            if(!isExport){ // for Chart
                for(AggregateResult  result : Database.query(queryForecastStr)) {
                    if(result.get('fc') != null && (decimal)result.get('fc') > 0){
                        system.debug('forecast:' + String.valueOf(result.get('fc')));
                        map_result.put('amount', String.valueOf(result.get('fc')));
                    }
                }
            }
            else{ // for Export
                map<String, decimal> map_region_amount = new map<String, decimal>();                
                for(AggregateResult  result : Database.query(queryForecastStr)) {
                    if(result.get('fc') != null){
                        String productFamily ='';
                        String productCode = '';
                        String groupKey;

                        if(result.get('region') != null && map_tCodeRegion.containsKey(String.valueOf(result.get('region')))){ // get region name based on Territory_L2_code__c
                            groupKey = map_tCodeRegion.get(String.valueOf(result.get('region')));    

                            if(result.get('Type__c') == 'GPL' && map_cbc2label_cbc2id.get((String)result.get('CBC2__c')) != null && result.get('Name') != null && result.get('GPL_Description__c') != null){
                                productFamily = map_cbc2label_cbc2id.get((String)result.get('CBC2__c'));
                                productCode = '[ ' + (String)result.get('Name') + ' ] - ' + (String)result.get('GPL_Description__c');
                            }else if(result.get('Type__c') == 'Relay Product Code' && map_relay_cbc2id_cbc2label.get((String)result.get('Relay_CBC2_Code__c')) != null && result.get('PRODUCT_CDE__c') != null && result.get('PROD_NAME__c') != null){
                                productFamily = map_relay_cbc2id_cbc2label.get((String)result.get('Relay_CBC2_Code__c'));
                                productCode = '[ ' + (String)result.get('PRODUCT_CDE__c') + ' ] - ' + (String)result.get('PROD_NAME__c');
                            }else if(result.get('Type__c') == 'Other CBC2'){
                                productFamily = map_cbc2label_cbc2id.get('Other CBC2');
                            }

                            if(productFamily != ''){
                                groupKey += '|' + productFamily;
                                if(productCode != ''){
                                    groupKey += '|' + productCode;
                                }
                            }
                            if(!map_result.containsKey(groupKey)){
                                map_result.put(groupKey, String.valueOf(result.get('fc')));
                            }
                            else{
                                Decimal m = Decimal.valueOf(map_result.get(groupKey));
                                m +=  (decimal)result.get('fc');
                                map_result.put(groupKey, String.valueOf(m));
                            }
                        }
                    }
                }             
            }
        }
        system.debug('map_result:' + map_result);
        return map_result;
    }
    
    public static map<String, String> getRSMChartData(SearchData searchOb, Boolean isExport) {
        map<String, String> map_result = new map<String, String>();
        if(!isExport){ // for chart
            map_result.put('amount', '0');
        }
        decimal amount = 0;
        String queryPartIds;
        String userId;
        set<String> set_territorCode = new set<String>();
        set<String> set_rsmGrouping = new set<String>();
        set<String> set_productFamily = new set<String>();
        Boolean hasRelay = false;
        
        if(searchOb.userId != null && searchOb.userId != ''){
            userId = searchOb.userId;
        }else{
            userId = UserInfo.getUserId();
        }
        
        if(searchOb.territoryCode != null && searchOb.territoryCode != ''){
            set_territorCode.addAll(getTcodeByTName(searchOb.territoryCode.split(';'), searchOb.source));
        }else{
            for(AggregateResult result : [select A6_Code__c territoryCode from APL_Forecast_Management__c where RSM__r.Manager__c =: userId and A6_Code__c != null and RecordType.Name = 'AM' group by A6_Code__c]){
                if(result.get('territoryCode') != null){
                    set_territorCode.add((String)result.get('territoryCode'));
                }
            }
        }
        
        if(searchOb.rSMGrouping != null && searchOb.rSMGrouping != ''){
            set_rsmGrouping.addAll(searchOb.rSMGrouping.split(';'));
        }
        
        if(searchOb.productFamily != null && searchOb.productFamily != ''){
            set_productFamily.addAll(searchOb.productFamily.split(';'));
        }else{
            set_productFamily.addAll(map_cbc2id_cbc2label.keySet());
            hasRelay = true;
        }
        system.debug('set_productFamily:'+set_productFamily); 
       if((Integer.valueOf(searchOb.FiscalYear) == Integer.valueOf(searchOb.currentFiscalYear) 
            && Integer.valueOf(searchOb.FiscalQuarter) < Integer.valueOf(searchOb.currentFiscalQuarter)) || Integer.valueOf(searchOb.FiscalYear) == (Integer.valueOf(searchOb.currentFiscalYear) - 1)){
            
            if(!set_productFamily.isEmpty()){
                
                if(set_productFamily.size() != 8) {
                    queryPartIds = APL_CompForecastBillingChart.getProductFamilySOQL(set_productFamily);
                }else {
                    hasRelay = true;
                }
                
                /*set<String> set_pcode = new set<String>();
                for(String fcode : set_productFamily){
                    if(fcode != 'Relay'){
                        set_pcode.add(map_cbc2id_cbc2label.get(fcode));
                    }
                    else{
                        set_pcode.addAll(map_relay_cbc2label_cbc2id.values());
                        hasRelay = true;
                    }
                }
                system.debug('set_pcode:' + set_pcode);
                set<String> set_excludeCode = new set<String>();
                set_excludeCode.addAll(map_cbc2id_cbc2label.values());
                set_excludeCode.addAll(map_relay_cbc2label_cbc2id.values());
                set_excludeCode.remove('Relay');
                set_excludeCode.remove('Other CBC2');
                set_excludeCode.removeAll(set_pcode);
                
                system.debug('set_excludCode:' + set_excludeCode);
                queryPartIds = ' (Part__r.Product_Hierarchy__r.CBC2__c in :set_pcode or Part__r.Product_Hierarchy__r.CBC3__c in :set_pcode) ';
                if(set_pcode.contains('Other CBC2')){
                    queryPartIds = ' (Part__r.Product_Hierarchy__r.CBC1__c != \'30007\' and Part__r.Product_Hierarchy__r.CBC2__c not in :set_excludeCode and Part__r.Product_Hierarchy__r.CBC3__c not in :set_excludeCode) ';
                }*/
            }else{
                hasRelay = true;
            }
            
            String queryBillingStr;
            if(!isExport){ // for Chart
                queryBillingStr = 'SELECT sum(Bill_Amount_USD__c) billing FROM BBB_Month_Bill_Book_Cust_PN__c ';
            }
            else{ // for Export
                queryBillingStr = 'SELECT sum(Bill_Amount_USD__c) billing, customer__r.Account_Manager__r.name tname, Customer__r.APL_RSM_Display_Name__c, customer__r.APL_AM_Display_Name__c, Part__r.Product_Hierarchy__r.CBC2__c, Part__r.Product_Hierarchy__r.CBC3__c, Part__r.Product_Hierarchy__r.Name, Part__r.Product_Hierarchy__r.GPL_Description__c, Part__r.PRODUCT_CDE__c, Part__r.PROD_NAME__c FROM BBB_Month_Bill_Book_Cust_PN__c ';
            }
            /* update by nelson zheng 2015-10-21 for case 00900375 begin
            queryBillingStr += 'WHERE Customer__r.STATDESC__c = \'Active\' AND Profit_Center__c IN (\'APL\'';
            if(hasRelay || set_productFamily.contains('Relay')){
                queryBillingStr +=', \'RPA\'';
            }
            queryBillingStr += ') AND Bill_Amount_USD__c != 0';
            */
            queryBillingStr += 'WHERE Customer__r.STATDESC__c = \'Active\'';
            
            //queryBillingStr += ') AND Bill_Amount_USD__c != 0';
            queryBillingStr += ' AND Bill_Amount_USD__c != 0';
            
            queryBillingStr +=  ' AND Fiscal_Year__c = \'' + searchOb.FiscalYear +'\' AND Fiscal_Quarter__c = \'' + searchOb.FiscalQuarter + '\'';
            if(!set_territorCode.isEmpty()){
                queryBillingStr += ' AND Customer__r.SALES_TERRITORY_CDE__c IN: set_territorCode';
            }
            if(!set_rsmGrouping.isEmpty()){
                if(set_rsmGrouping.contains(APL_CompForecastBillingChart.OTHERAMGROUPEDACCOUNTS)){
                    set_rsmGrouping.remove(APL_CompForecastBillingChart.OTHERAMGROUPEDACCOUNTS);
                    if(set_rsmGrouping.size() > 0){
                        queryBillingStr += ' AND (Customer__r.APL_RSM_Display_Name__c IN: set_rsmGrouping OR Customer__r.APL_RSM_Display_Name__c = null)';
                    }else{
                        queryBillingStr += ' AND Customer__r.APL_RSM_Display_Name__c = null';
                    }
                }else{
                    queryBillingStr += ' AND Customer__r.APL_RSM_Display_Name__c IN: set_rsmGrouping';
                }
            }
            /*
            if(queryPartIds != null){
                queryBillingStr += ' AND ' + queryPartIds;
            }
            */
            if(queryPartIds != null){
                queryBillingStr += ' AND Profit_Center__c = \'APL\' AND ' + queryPartIds;
            }else{
                if(hasRelay || set_productFamily.contains('Relay')){
                    queryBillingStr += ' AND Profit_Center__c = \'APL\'';
                }else{
                	//change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
                    queryBillingStr += ' AND (Profit_Center__c = \'APL\' and Part__r.Product_Hierarchy__r.CBC3__c not in (\'41553\') and Part__r.Product_Hierarchy__r.CBC2__c not in (\'30005\',\'13213\'))';
                }
            }
            System.debug('---------APL_CompForecastBillingChart.cls (10 matches) 4--------------');
            //update by nelson zheng 2015-10-21 for case 00900375 end
            
            if(searchOb.aMGrouping !=null && searchOb.aMGrouping != ''){
                queryBillingStr += ' AND customer__r.APL_AM_Display_Name__c in (\''+ (String)searchOb.aMGrouping.replaceAll(';', '\', \'') + '\')';
            }else {
                // update 2016-04-06 by Mingxing Qiu  because page date and chart date unlike 
                // queryBillingStr += ' AND customer__r.APL_AM_forecast_Plan_Account__c != null ';
            }
            
            if(isExport){ // for Export
                queryBillingStr +=  ' Group By customer__r.Account_Manager__r.name, Customer__r.APL_RSM_Display_Name__c, customer__r.APL_AM_Display_Name__c, Part__r.Product_Hierarchy__r.CBC2__c, Part__r.Product_Hierarchy__r.CBC3__c, Part__r.Product_Hierarchy__r.Name, Part__r.Product_Hierarchy__r.GPL_Description__c, Part__r.PRODUCT_CDE__c, Part__r.PROD_NAME__c';
            }
            system.debug('queryBillingStr:'+queryBillingStr);
            system.debug('set_territorCode:'+set_territorCode);
            system.debug('queryPartIds:'+queryPartIds);
            if(!isExport){ // for Chart
                for(AggregateResult  result : Database.query(queryBillingStr)) {
                    if(result.get('billing') != null ){
                        map_result.put('amount', String.valueOf(result.get('billing')));
                    }
                }   
            }else{
                integer flag = 0;
                Decimal sum = 0;
                for(AggregateResult  result : Database.query(queryBillingStr)) {
                    if(result.get('billing') != null){
                        String productFamily ='';
                        String productCode = '';
                        String groupKey = '';
                                               
                        if(result.get('tname') != null){
                            system.debug('tname:'+result.get('tname'));
                            groupKey = (String)result.get('tname');
                            
                            if(result.get('APL_RSM_Display_Name__c') == null)  groupKey += '|' + '';
                            else groupKey += '|' + (String)result.get('APL_RSM_Display_Name__c');
                                
                            if(result.get('APL_AM_Display_Name__c') == null) groupKey += '|' + '';
                            else groupKey += '|' + (String)result.get('APL_AM_Display_Name__c');
                                    
                            if(map_cbc2label_cbc2id.get((String)result.get('CBC2__c')) != null && result.get('Name') != null && result.get('GPL_Description__c') != null){
                                productFamily = map_cbc2label_cbc2id.get((String)result.get('CBC2__c'));
                                productCode = '[ ' + (String)result.get('Name') + ' ] - ' + (String)result.get('GPL_Description__c');
                            }else if(map_relay_cbc2id_cbc2label.get((String)result.get('CBC2__c')) != null && result.get('PRODUCT_CDE__c') != null && result.get('PROD_NAME__c') != null){
                                productFamily = map_relay_cbc2id_cbc2label.get((String)result.get('CBC2__c'));
                                productCode = '[ ' + (String)result.get('PRODUCT_CDE__c') + ' ] - ' + (String)result.get('PROD_NAME__c');
                            }else if(map_relay_cbc2id_cbc2label.get((String)result.get('CBC3__c')) != null && result.get('PRODUCT_CDE__c') != null && result.get('PROD_NAME__c') != null ){
                                productFamily = map_relay_cbc2id_cbc2label.get((String)result.get('CBC3__c'));
                                productCode = '[ ' + (String)result.get('PRODUCT_CDE__c') + ' ] - ' + (String)result.get('PROD_NAME__c');
                            }else{
                                productFamily = map_cbc2label_cbc2id.get('Other CBC2'); //key for other BU Products
                            }
                            
                            if(productFamily != ''){
                                groupKey += '|' + productFamily;
                                
                                if(productCode != ''){
                                    groupKey += '|' + productCode;
                                }
                            }
                             
                            if(!map_result.containsKey(groupKey)){
                                map_result.put(groupKey, String.valueOf(result.get('billing')));
                            }
                            else{
                                Decimal m = Decimal.valueOf(map_result.get(groupKey));
                                m +=  (decimal)result.get('billing');
                                map_result.put(groupKey, String.valueOf(m));
                            }
                           //system.debug('result.get(billing):'+ result.get('billing'));
                            //system.debug('result.get(billing) --String:'+ String.valueOf(result.get('billing')));
                            //system.debug('map_result.get(groupKey)'+ map_result.get(groupKey));
                           
                            
                        }
                    }
                }
            }
        }else{
            set<String> set_relaycode = new set<String>();
    
            String queryForecastStr;
            if(!isExport){ // for Chart
                queryForecastStr = 'SELECT sum(RSM_Forecast__c) fc FROM APL_Sales_Forecast__c WHERE RSM_Forecast__c != null';
            }
            else{ // for export
                queryForecastStr = 'SELECT sum(RSM_Forecast__c) fc, customer__r.Account_Manager__r.name tname, Customer__r.APL_RSM_Display_Name__c, customer__r.APL_AM_Display_Name__c, Type__c, GPL__r.CBC2__c, GPL__r.CBC3__c, GPL__r.Name, GPL__r.GPL_Description__c, Relay_CBC2_Code__c, PRODUCT_CDE__c, PROD_NAME__c FROM APL_Sales_Forecast__c WHERE RSM_Forecast__c != null';
            }

            queryForecastStr +=  ' AND Customer__r.STATDESC__c != \'Not Active\' AND Fiscal_Year__c = \'' + searchOb.FiscalYear +'\' AND Fiscal_Quarter__c = \'0' + searchOb.FiscalQuarter + '\'';
            
            if(!set_territorCode.isEmpty()){
                queryForecastStr += ' AND Customer__r.SALES_TERRITORY_CDE__c IN: set_territorCode';
            }
            if(!set_rsmGrouping.isEmpty()){
                if(set_rsmGrouping.contains(APL_CompForecastBillingChart.OTHERAMGROUPEDACCOUNTS)){
                    set_rsmGrouping.remove(APL_CompForecastBillingChart.OTHERAMGROUPEDACCOUNTS);
                    if(set_rsmGrouping.size() > 0){
                        queryForecastStr += ' AND (Customer__r.APL_RSM_Display_Name__c IN: set_rsmGrouping OR Customer__r.APL_RSM_Display_Name__c = null)';
                    }else{
                        queryForecastStr += ' AND Customer__r.APL_RSM_Display_Name__c = null';
                    }
                }else{
                    queryForecastStr += ' AND Customer__r.APL_RSM_Display_Name__c IN: set_rsmGrouping';
                }
            }
            if(searchOb.aMGrouping !=null && searchOb.aMGrouping != ''){
                queryForecastStr += ' AND customer__r.APL_AM_Display_Name__c in (\''+ (String)searchOb.aMGrouping.replaceAll(';', '\', \'') + '\')';
            }
            if(!set_productFamily.isEmpty()){
                String productFamilyFilter = '';
                
                if(set_productFamily.contains('Relay')){
                    set_relaycode.addAll(map_relay_cbc2label_cbc2id.values());
                    productFamilyFilter += ' OR (Type__c = \'Relay Product Code\' AND Relay_CBC2_Code__c IN: set_relaycode)';
                    set_productFamily.remove('Relay');
                }
                if(set_productFamily.contains('Other BU Products')){
                    productFamilyFilter += ' OR Type__c = \'Other CBC2\'';
                    set_productFamily.remove('Other BU Products');
                }
                if(set_productFamily.size() > 0){
                    productFamilyFilter += ' OR (Type__c = \'GPL\' AND (';
                    String cbcCodes = '(';
                    for(String pfkey : set_productFamily){
                        cbcCodes += '\'' + map_cbc2id_cbc2label.get(pfkey) + '\', ';
                    }
                    cbcCodes = cbcCodes.substring(0, cbcCodes.lastIndexOf(',')) + ')';
                    productFamilyFilter += 'GPL__r.CBC2__c IN ' + cbcCodes + ' OR GPL__r.CBC3__c IN ' + cbcCodes + '))';
                }
                if(productFamilyFilter.indexOf('OR') == 1){
                    productFamilyFilter = productFamilyFilter.substring(4, productFamilyFilter.length());
                }
                    
                queryForecastStr += ' AND (' + productFamilyFilter + ')';
            }
    		
            if(isExport){ //for Export
                queryForecastStr += ' Group By customer__r.Account_Manager__r.name, Customer__r.APL_RSM_Display_Name__c, customer__r.APL_AM_Display_Name__c, Type__c, GPL__r.CBC2__c, GPL__r.CBC3__c, GPL__r.Name, GPL__r.GPL_Description__c, Relay_CBC2_Code__c, PRODUCT_CDE__c, PROD_NAME__c';
            }
            system.debug('set_territorCode:'+set_territorCode);
            system.debug('queryForecastStr:'+queryForecastStr);
            
                if(!isExport){ //for chart
                    for(AggregateResult  result : Database.query(queryForecastStr)) {
                        if(result.get('fc') != null ){
                            map_result.put('amount',String.valueOf(result.get('fc')));
                        }
                    }
                }else{ // for export
                    // Change start by Mrunal for Case 901022
                    queryForecastStr += ' LIMIT 2000';
                    For(Integer i=0; i<2 ; i++){
                        if(i==1)queryForecastStr += ' offset 2000';
                        // change end by Mrunal for Case 901022
                        for(AggregateResult  result : Database.query(queryForecastStr)) {
                            if(result.get('fc') != null){
                                String productFamily ='';
                                String productCode = '';
                                String groupKey = '';
                                
                                if(result.get('tname') != null){
                                    groupKey = (String)result.get('tname');
                                    
                                    if(result.get('APL_RSM_Display_Name__c') == null)  groupKey += '|' + '';
                                    else groupKey += '|' + (String)result.get('APL_RSM_Display_Name__c');
                                        
                                    if(result.get('APL_AM_Display_Name__c') == null) groupKey += '|' + '';
                                    else groupKey += '|' + (String)result.get('APL_AM_Display_Name__c');
                                            
                                    if(result.get('Type__c') == 'GPL' && map_cbc2label_cbc2id.get((String)result.get('CBC2__c')) != null && result.get('Name') != null && result.get('GPL_Description__c') != null){
                                        productFamily = map_cbc2label_cbc2id.get((String)result.get('CBC2__c'));
                                        productCode = '[ ' + (String)result.get('Name') + ' ] - ' + (String)result.get('GPL_Description__c');
                                    }else if(result.get('Type__c') == 'Relay Product Code' && map_relay_cbc2id_cbc2label.get((String)result.get('Relay_CBC2_Code__c')) != null && result.get('PRODUCT_CDE__c') != null && result.get('PROD_NAME__c') != null){
                                        productFamily = map_relay_cbc2id_cbc2label.get((String)result.get('Relay_CBC2_Code__c'));
                                        productCode = '[ ' + (String)result.get('PRODUCT_CDE__c') + ' ] - ' + (String)result.get('PROD_NAME__c');
                                    }else if(result.get('Type__c') == 'Other CBC2'){
                                        productFamily = map_cbc2label_cbc2id.get('Other CBC2');
                                    }
                                    
                                    if(productFamily != ''){
                                        groupKey += '|' + productFamily;
                                        
                                        if(productCode != ''){
                                            groupKey += '|' + productCode;
                                        }
                                    }
        
                                    if(!map_result.containsKey(groupKey)){
                                        map_result.put(groupKey, String.valueOf(result.get('fc')));
                                    }
                                    else{
                                        Decimal m = Decimal.valueOf(map_result.get(groupKey));
                                        m +=  (decimal)result.get('fc');
                                        map_result.put(groupKey, String.valueOf(m));
                                    }
                                }
                            }
                        }
                }  
            }
        }
        system.debug('map_result:' + map_result);
        /*decimal sum = 0;
        for(String str_sum : map_result.keySet()){
            system.debug('str_sum:' + str_sum);
            system.debug('Value :' + map_result.get(str_sum));
           sum += Decimal.valueOf(map_result.get(str_sum));
        }
        system.debug('sum:' + sum);
        */
        return map_result;
    }

    public static map<String, String> getRSMRelayChartData(SearchData searchOb, Boolean isExport) {
        map<String, String> map_result = new map<String, String>();
        if(!isExport){ // for chart
            map_result.put('amount', '0');
        }
        String queryPartIds;
        String userId;
        set<String> set_territorCode = new set<String>();
        set<String> set_rsmRelayGrouping = new set<String>();
        set<String> set_productFamily = new set<String>();
        
        if(searchOb.userId != null && searchOb.userId != ''){
            userId = searchOb.userId;
        }else{
            userId = UserInfo.getUserId();
        }
        
        if(searchOb.territoryCode != null && searchOb.territoryCode != ''){
            set_territorCode.addAll(getTcodeByTName(searchOb.territoryCode.split(';'), searchOb.source));
        }else {
            for(AggregateResult result : [select A6_Code__c territoryCode from APL_Forecast_Management__c where RSM__r.Manager__c =: userId and A6_Code__c != null and RecordType.Name = 'Relay' group by A6_Code__c]){
                if(result.get('territoryCode') != null){
                    set_territorCode.add((String)result.get('territoryCode'));
                }
            }
        }
        
        if(searchOb.rSMRelayGrouping != null && searchOb.rSMRelayGrouping != ''){
            set_rsmRelayGrouping.addAll(searchOb.rSMRelayGrouping.split(';'));
        }
        
        if(searchOb.productFamily != null && searchOb.productFamily != ''){
            set_productFamily.addAll(searchOb.productFamily.split(';'));
        }else{
            set_productFamily.addAll(map_relay_cbc2label_cbc2id.keySet());
        }
        system.debug('set_productFamily:'+set_productFamily); 
         if((Integer.valueOf(searchOb.FiscalYear) == Integer.valueOf(searchOb.currentFiscalYear) 
            && Integer.valueOf(searchOb.FiscalQuarter) < Integer.valueOf(searchOb.currentFiscalQuarter)) || Integer.valueOf(searchOb.FiscalYear) == (Integer.valueOf(searchOb.currentFiscalYear) - 1)){  
            if(!set_productFamily.isEmpty()){
                
                queryPartIds = APL_CompForecastBillingChart.getProductFamilySOQL(set_productFamily);
                
                /*set<String> set_pcode = new set<String>();
                for(String fcode : set_productFamily){
                    set_pcode.add(map_relay_cbc2label_cbc2id.get(fcode));
                }
                system.debug('set_pcode:' + set_pcode);
                queryPartIds = ' (Part__r.Product_Hierarchy__r.CBC2__c in :set_pcode or Part__r.Product_Hierarchy__r.CBC3__c in :set_pcode) ';
                */
            }
            
            String queryBillingStr;
            if(!isExport){ // for Chart
                queryBillingStr = 'SELECT sum(Bill_Amount_USD__c) billing FROM BBB_Month_Bill_Book_Cust_PN__c ';
            }
            else{ // for Export
                queryBillingStr = 'SELECT sum(Bill_Amount_USD__c) billing, Customer__r.Relay_Hierarchy__r.Level_7_Default_Owner__r.name tname, Customer__r.APL_RSM_Relay_Display_Name__c, customer__r.APL_Relay_Display_Name__c, Part__r.Product_Hierarchy__r.CBC2__c, Part__r.Product_Hierarchy__r.CBC3__c, Part__r.Product_Hierarchy__r.Name, Part__r.Product_Hierarchy__r.GPL_Description__c, Part__r.PRODUCT_CDE__c, Part__r.PROD_NAME__c FROM BBB_Month_Bill_Book_Cust_PN__c ';
            }
             
            //update by nelson zheng 2015-10-21 for case 00900375    
            //queryBillingStr += 'WHERE Customer__r.STATDESC__c = \'Active\' AND Profit_Center__c IN (\'RPA\')';
            queryBillingStr += 'WHERE Customer__r.STATDESC__c = \'Active\' ';
            System.debug('---------APL_CompForecastBillingChart.cls (10 matches) 5--------------');
            queryBillingStr +=  ' AND Fiscal_Year__c = \'' + searchOb.FiscalYear +'\' AND Fiscal_Quarter__c = \'' + searchOb.FiscalQuarter + '\'';
            if(!set_territorCode.isEmpty()){
                queryBillingStr += ' AND Customer__r.Relay_Specialist_Territory_Code__c IN: set_territorCode';
            }
            if(!set_rsmRelayGrouping.isEmpty()){
                if(set_rsmRelayGrouping.contains(APL_CompForecastBillingChart.OTHERACCOUNTS)){
                    set_rsmRelayGrouping.remove(APL_CompForecastBillingChart.OTHERACCOUNTS);
                    if(set_rsmRelayGrouping.size() > 0){
                        queryBillingStr += ' AND (Customer__r.APL_RSM_Relay_Display_Name__c IN: set_rsmRelayGrouping OR Customer__r.APL_RSM_Relay_Display_Name__c = null)';
                    }else{
                        queryBillingStr += ' AND Customer__r.APL_RSM_Relay_Display_Name__c = null';
                    }
                }else{
                    queryBillingStr += ' AND Customer__r.APL_RSM_Relay_Display_Name__c IN: set_rsmRelayGrouping';
                }
            }
            /*update by nelson zheng 2015-10-21 for case 00900375 
            if(queryPartIds != null){
                queryBillingStr += ' AND ' + queryPartIds;
            }*/
            if(queryPartIds != null){
                queryBillingStr += ' AND Profit_Center__c = \'APL\' AND ' + queryPartIds;
            }else{
            	//change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
                queryBillingStr += ' AND (Profit_Center__c = \'APL\' AND (Part__r.Product_Hierarchy__r.CBC3__c in (\'41553\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) ';
            }//update by nelson zheng 2015-10-21 for case 00900375 
            
            if(searchOb.relayGrouping !=null && searchOb.relayGrouping != ''){
                queryBillingStr += ' AND customer__r.APL_Relay_Display_Name__c in (\''+ (String)searchOb.relayGrouping.replaceAll(';', '\', \'') + '\')';
            }
            else {
                // update 2016-04-06 by Mingxing Qiu  because page date and chart date unlike 
                //queryBillingStr += ' AND customer__r.APL_Relay_forecast_Plan_Account__c != null ';
            }
            
            if(isExport){ // for Export
                queryBillingStr +=  ' Group By Customer__r.Relay_Hierarchy__r.Level_7_Default_Owner__r.name, Customer__r.APL_RSM_Relay_Display_Name__c, customer__r.APL_Relay_Display_Name__c, Part__r.Product_Hierarchy__r.CBC2__c, Part__r.Product_Hierarchy__r.CBC3__c, Part__r.Product_Hierarchy__r.Name, Part__r.Product_Hierarchy__r.GPL_Description__c, Part__r.PRODUCT_CDE__c, Part__r.PROD_NAME__c';
            }
            
            system.debug('queryBillingStr:'+queryBillingStr);
            system.debug('queryPartIds:'+queryPartIds); 
            if(!isExport){ // for Chart
                for(AggregateResult  result : Database.query(queryBillingStr)) {
                    if(result.get('billing') != null ){
                        map_result.put('amount', String.valueOf(result.get('billing')));
                    }
                }   
            }else{   
                for(AggregateResult  result : Database.query(queryBillingStr)) {
                    if(result.get('billing') != null){
                        String productFamily ='';
                        String productCode = '';
                        String groupKey = '';
                        
                        if(result.get('tname') != null){
                            groupKey = (String)result.get('tname');
                            
                            if(result.get('APL_RSM_Relay_Display_Name__c') == null)  groupKey += '|' + '';
                            else groupKey += '|' + (String)result.get('APL_RSM_Relay_Display_Name__c');
                                
                            if(result.get('APL_Relay_Display_Name__c') == null) groupKey += '|' + '';
                            else groupKey += '|' + (String)result.get('APL_Relay_Display_Name__c');                            
                            
                                
                            if(map_cbc2label_cbc2id.get((String)result.get('CBC2__c')) != null && result.get('Name') != null && result.get('GPL_Description__c') != null){
                                productFamily = map_cbc2label_cbc2id.get((String)result.get('CBC2__c'));
                                productCode = '[ ' + (String)result.get('Name') + ' ] - ' + (String)result.get('GPL_Description__c');
                            }else if(map_relay_cbc2id_cbc2label.get((String)result.get('CBC2__c')) != null && result.get('PRODUCT_CDE__c') != null && result.get('PROD_NAME__c') != null){
                                productFamily = map_relay_cbc2id_cbc2label.get((String)result.get('CBC2__c'));
                                productCode = '[ ' + (String)result.get('PRODUCT_CDE__c') + ' ] - ' + (String)result.get('PROD_NAME__c');
                            }else if(map_relay_cbc2id_cbc2label.get((String)result.get('CBC3__c')) != null && result.get('PRODUCT_CDE__c') != null && result.get('PROD_NAME__c') != null ){
                                productFamily = map_relay_cbc2id_cbc2label.get((String)result.get('CBC3__c'));
                                productCode = '[ ' + (String)result.get('PRODUCT_CDE__c') + ' ] - ' + (String)result.get('PROD_NAME__c');
                            }else{
                                productFamily = map_cbc2label_cbc2id.get('Other CBC2'); //key for other BU Products
                            }
                            
                            if(productFamily != ''){
                                groupKey += '|' + productFamily;
                                
                                if(productCode != ''){
                                    groupKey += '|' + productCode;
                                }
                            }

                            if(!map_result.containsKey(groupKey)){
                                map_result.put(groupKey, String.valueOf(result.get('billing')));
                            }
                            else{
                                Decimal m = Decimal.valueOf(map_result.get(groupKey));
                                m +=  (decimal)result.get('billing');
                                map_result.put(groupKey, String.valueOf(m));
                            }
                        }
                    }
                }
            }
        }else{
            String queryForecastStr;
            if(!isExport){ // for Chart
                queryForecastStr = 'SELECT sum(RSM_Forecast__c) fc FROM APL_Sales_Forecast__c WHERE RSM_Forecast__c != null';
            }
            else{ // for export
                queryForecastStr = 'SELECT sum(RSM_Forecast__c) fc, Customer__r.Relay_Hierarchy__r.Level_7_Default_Owner__r.name tname, Customer__r.APL_RSM_Relay_Display_Name__c, customer__r.APL_Relay_Display_Name__c, Type__c, GPL__r.CBC2__c, GPL__r.CBC3__c, GPL__r.Name, GPL__r.GPL_Description__c, Relay_CBC2_Code__c, PRODUCT_CDE__c, PROD_NAME__c FROM APL_Sales_Forecast__c WHERE RSM_Forecast__c != null';
            }
            queryForecastStr +=  ' AND Customer__r.STATDESC__c != \'Not Active\' AND Fiscal_Year__c = \'' + searchOb.FiscalYear +'\' AND Fiscal_Quarter__c = \'0' + searchOb.FiscalQuarter + '\'';
            
            if(!set_territorCode.isEmpty()){
                queryForecastStr += ' AND Customer__r.Relay_Specialist_Territory_Code__c IN: set_territorCode';
            }
            if(!set_rsmRelayGrouping.isEmpty()){
                if(set_rsmRelayGrouping.contains(APL_CompForecastBillingChart.OTHERACCOUNTS)){
                    set_rsmRelayGrouping.remove(APL_CompForecastBillingChart.OTHERACCOUNTS);
                    if(set_rsmRelayGrouping.size() > 0){
                        queryForecastStr += ' AND (Customer__r.APL_RSM_Relay_Display_Name__c IN: set_rsmRelayGrouping OR Customer__r.APL_RSM_Relay_Display_Name__c = null)';
                    }else{
                        queryForecastStr += ' AND Customer__r.APL_RSM_Relay_Display_Name__c = null';
                    }
                }else{
                    queryForecastStr += ' AND Customer__r.APL_RSM_Relay_Display_Name__c IN: set_rsmRelayGrouping';
                }
            }
            if(searchOb.relayGrouping !=null && searchOb.relayGrouping != ''){
                queryForecastStr += ' AND customer__r.APL_Relay_Display_Name__c in (\''+ (String)searchOb.relayGrouping.replaceAll(';', '\', \'') + '\')';
            }
            if(!set_productFamily.isEmpty()){
                queryForecastStr += ' AND Type__c = \'Relay Product Code\' AND ';
                String cbcCodes = '(';
                for(String pfkey : set_productFamily){
                    cbcCodes += '\'' + map_relay_cbc2label_cbc2id.get(pfkey) + '\', ';
                }
                cbcCodes = cbcCodes.substring(0, cbcCodes.lastIndexOf(',')) + ')';
                queryForecastStr += 'Relay_CBC2_Code__c IN ' + cbcCodes;
            }
            
            if(isExport){ //for Export
                queryForecastStr += ' Group By Customer__r.Relay_Hierarchy__r.Level_7_Default_Owner__r.name, Customer__r.APL_RSM_Relay_Display_Name__c, customer__r.APL_Relay_Display_Name__c, Type__c, GPL__r.CBC2__c, GPL__r.CBC3__c, GPL__r.Name, GPL__r.GPL_Description__c, Relay_CBC2_Code__c, PRODUCT_CDE__c, PROD_NAME__c';
            }
            
            system.debug('queryForecastStr:'+queryForecastStr);
            
            if(!isExport){ //for chart
                for(AggregateResult  result : Database.query(queryForecastStr)) {
                    if(result.get('fc') != null ){
                        map_result.put('amount',String.valueOf(result.get('fc')));
                    }
                }
            }else{ // for export
                for(AggregateResult  result : Database.query(queryForecastStr)) {
                    if(result.get('fc') != null){
                        String productFamily ='';
                        String productCode = '';
                        String groupKey = '';
                        
                        if(result.get('tname') != null){
                            groupKey = (String)result.get('tname');
                            
                            if(result.get('APL_RSM_Relay_Display_Name__c') == null)  groupKey += '|' + '';
                            else groupKey += '|' + (String)result.get('APL_RSM_Relay_Display_Name__c');
                                
                            if(result.get('APL_Relay_Display_Name__c') == null) groupKey += '|' + '';
                            else groupKey += '|' + (String)result.get('APL_Relay_Display_Name__c');                            
                            
                                    
                            if(result.get('Type__c') == 'GPL' && map_cbc2label_cbc2id.get((String)result.get('CBC2__c')) != null && result.get('Name') != null && result.get('GPL_Description__c') != null){
                                productFamily = map_cbc2label_cbc2id.get((String)result.get('CBC2__c'));
                                productCode = '[ ' + (String)result.get('Name') + ' ] - ' + (String)result.get('GPL_Description__c');
                            }else if(result.get('Type__c') == 'Relay Product Code' && map_relay_cbc2id_cbc2label.get((String)result.get('Relay_CBC2_Code__c')) != null && result.get('PRODUCT_CDE__c') != null && result.get('PROD_NAME__c') != null){
                                productFamily = map_relay_cbc2id_cbc2label.get((String)result.get('Relay_CBC2_Code__c'));
                                productCode = '[ ' + (String)result.get('PRODUCT_CDE__c') + ' ] - ' + (String)result.get('PROD_NAME__c');
                            }else if(result.get('Type__c') == 'Other CBC2'){
                                productFamily = map_cbc2label_cbc2id.get('Other CBC2');
                            }
                            
                            if(productFamily != ''){
                                groupKey += '|' + productFamily;
                                if(productCode != ''){
                                    groupKey += '|' + productCode;
                                }
                            }

                            if(!map_result.containsKey(groupKey)){
                                map_result.put(groupKey, String.valueOf(result.get('fc')));
                            }
                            else{
                                Decimal m = Decimal.valueOf(map_result.get(groupKey));
                                m +=  (decimal)result.get('fc');
                                map_result.put(groupKey, String.valueOf(m));
                            }
                        }
                    }
                }
            }
        }
        system.debug('map_result:' + map_result);
        
        return map_result;
    }

    public list<string> calTerritoryCode(String recordType){
        list<string> list_tCode = new list<String>();
        if(userId == null){
            userId = UserInfo.getUserId();
        }
        for(AggregateResult result : [select A6_Code__c territoryCode from APL_Forecast_Management__c where RSM__r.Manager__c =: userId and A6_Code__c != null and RecordType.Name =: recordType group by A6_Code__c]){
            if(result.get('territoryCode') != null){
                list_tCode.add((String)result.get('territoryCode'));
            }
        }
        return list_tCode;
    }
    
    private void getGroupingMap(){
        list_RSMGrouping = new list<String>();
        list_RSMRelayGrouping = new list<String>();
        
        if(!list_territoryCode.isEmpty()){
            set<String> set_territoryCode = new set<String>();
            
            set_territoryCode.addAll(list_territoryCode);
            
            map<String, String> map_territortname = getTNameMapByTcode(set_territoryCode);
            
            String territoryField = '';
            if(source == 'Relay'){
                territoryField += 'Relay_Specialist_Territory_Code__c';
            }else{
                territoryField += 'SALES_TERRITORY_CDE__c';
            }
            
            if(source == 'RSMRelay'){
                String queryGrouping = 'select Relay_Specialist_Territory_Code__c, APL_Relay_Display_Name__c, APL_RSM_Relay_Display_Name__c from Account';
                queryGrouping += ' where Relay_Specialist_Territory_Code__c in: set_territoryCode ';
                
                for(Account acc : database.query(queryGrouping)){
                    if(acc.APL_Relay_Display_Name__c != null){
                        if(acc.APL_RSM_Relay_Display_Name__c != null){
                            if(!map_rsmRelayGrouping_RelayGrouping.containsKey(acc.APL_RSM_Relay_Display_Name__c)){
                                map_rsmRelayGrouping_RelayGrouping.put(acc.APL_RSM_Relay_Display_Name__c, new set<String>());
                            }
                            map_rsmRelayGrouping_RelayGrouping.get(acc.APL_RSM_Relay_Display_Name__c).add(acc.APL_Relay_Display_Name__c);
                        }
                        if(acc.Relay_Specialist_Territory_Code__c != null){
                            if(!map_territoryCode_RelayGrouping.containsKey(acc.Relay_Specialist_Territory_Code__c)){
                                map_territoryCode_RelayGrouping.put(acc.Relay_Specialist_Territory_Code__c, new set<String>());
                            }
                            map_territoryCode_RelayGrouping.get(acc.Relay_Specialist_Territory_Code__c).add(acc.APL_Relay_Display_Name__c);
                        }
                    }
                }
                
                system.debug('map_territoryCode_RelayGrouping:'+map_territoryCode_RelayGrouping);
                list_RSMRelayGrouping.addAll(map_rsmRelayGrouping_RelayGrouping.keySet());
                list_RSMRelayGrouping.sort();

                RSMRelayGroupingJSON = JSON.serialize(list_RSMRelayGrouping);
            }else{
                String queryGrouping = 'select ' + territoryField + ' territoryCode, APL_RSM_Display_Name__c rsmGrouping, APL_AM_Display_Name__c amGrouping, APL_Relay_Display_Name__c relayGrouping, ';
                queryGrouping += 'APL_RSM_Relay_Display_Name__c rsmRelayGrouping from Account where ' + territoryField + ' in: set_territoryCode ';
                queryGrouping += 'group by ' + territoryField +', APL_RSM_Display_Name__c, APL_AM_Display_Name__c, APL_Relay_Display_Name__c, APL_RSM_Relay_Display_Name__c';
                
                
                for(AggregateResult result : database.query(queryGrouping)){
                    String territoryCode = (String)result.get('territoryCode');
                    String territoryName = map_territortname.get(territoryCode) != null ? map_territortname.get(territoryCode) : '';
                    if(result.get('rsmGrouping') != null){
                        String rsmGrouping = (String)result.get('rsmGrouping');
                        
                        if(result.get('amGrouping') != null){
                            if(!map_rsmGrouping_AMGrouping.containsKey(rsmGrouping)){
                                map_rsmGrouping_AMGrouping.put(rsmGrouping, new set<String>());
                            }
                            map_rsmGrouping_AMGrouping.get(rsmGrouping).add((String)result.get('amGrouping'));
                        }
                    }else if(result.get('amGrouping') != null){
                        if(!map_rsmGrouping_AMGrouping.containsKey(APL_CompForecastBillingChart.OTHERAMGROUPEDACCOUNTS)){
                            map_rsmGrouping_AMGrouping.put(APL_CompForecastBillingChart.OTHERAMGROUPEDACCOUNTS, new set<String>());
                        }
                        map_rsmGrouping_AMGrouping.get(APL_CompForecastBillingChart.OTHERAMGROUPEDACCOUNTS).add((String)result.get('amGrouping'));
                    }
                    
                    if(result.get('rsmRelayGrouping') != null){
                        String rsmRelayGrouping = (String)result.get('rsmRelayGrouping');
                        
                        if(result.get('relayGrouping') != null){ 
                            if(!map_rsmRelayGrouping_RelayGrouping.containsKey(rsmRelayGrouping)){
                                map_rsmRelayGrouping_RelayGrouping.put(rsmRelayGrouping, new set<String>());
                            }
                            map_rsmRelayGrouping_RelayGrouping.get(rsmRelayGrouping).add((String)result.get('relayGrouping'));
                        }
                    }else if(result.get('relayGrouping') != null){ 
                        if(!map_rsmRelayGrouping_RelayGrouping.containsKey(APL_CompForecastBillingChart.OTHERACCOUNTS)){
                            map_rsmRelayGrouping_RelayGrouping.put(APL_CompForecastBillingChart.OTHERACCOUNTS, new set<String>());
                        }
                        map_rsmRelayGrouping_RelayGrouping.get(APL_CompForecastBillingChart.OTHERACCOUNTS).add((String)result.get('relayGrouping'));
                    }
                    
                    if(result.get('amGrouping') != null){
                        if(!map_territoryCode_AMGrouping.containsKey(territoryName)){
                            map_territoryCode_AMGrouping.put(territoryName, new set<String>());
                        }
                        map_territoryCode_AMGrouping.get(territoryName).add((String)result.get('amGrouping'));
    
                    }
                    if(result.get('relayGrouping') != null){
                        if(!map_territoryCode_RelayGrouping.containsKey(territoryName)){
                            map_territoryCode_RelayGrouping.put(territoryName, new set<String>());
                        }
                        map_territoryCode_RelayGrouping.get(territoryName).add((String)result.get('relayGrouping'));
                    }
                }
    
                system.debug('map_territoryCode_AMGrouping:'+map_territoryCode_AMGrouping);
                system.debug('map_territoryCode_RelayGrouping:'+map_territoryCode_RelayGrouping);
                list_RSMGrouping.addAll(map_rsmGrouping_AMGrouping.keySet());
                list_RSMGrouping.sort();
                list_RSMRelayGrouping.addAll(map_rsmRelayGrouping_RelayGrouping.keySet());
                list_RSMRelayGrouping.sort();
    
                RSMGroupingJSON = JSON.serialize(list_RSMGrouping);
                RSMRelayGroupingJSON = JSON.serialize(list_RSMRelayGrouping);
            }

           
        }
    }

    public void getAMGroupingByTerritoryCode(String territoryCode){
        list_AMGrouping = getGrouping(territoryCode, list_territoryCode, map_territoryCode_AMGrouping);
    }
    
    public void getRSMAMGroupingByTerritoryCode(String territoryCode){
        list_AMGrouping = getGrouping(territoryCode, list_territoryName, map_territoryCode_AMGrouping);
    }
    
    public void getRelayGroupingByTerritoryCode(String territoryCode){
        list_RelayGrouping = getGrouping(territoryCode, list_territoryCode, map_territoryCode_RelayGrouping);
    }
    
    public void getRSMRelayGroupingByTerritoryCode(String territoryCode){
        list_RelayGrouping = getGrouping(territoryCode, list_territoryName, map_territoryCode_RelayGrouping);
    }
    
    public void getAMGroupingByRSMGrouping(String rsmGrouping){
        list_AMGrouping = getGrouping(rsmGrouping, list_RSMGrouping, map_rsmGrouping_AMGrouping);
    }
    
    public void getRelayGroupingByRSMRelayGrouping(String rsmRelayGrouping){
        list_RelayGrouping = getGrouping(rsmRelayGrouping, list_RSMRelayGrouping, map_rsmRelayGrouping_RelayGrouping);
    }
        
    public list<String> getGrouping(String keys, list<String> list_key, map<String, set<String>> map_key_grouping){
        list<String> list_grouping = new list<String>();
        set<String> set_key = new set<String>();
        set<String> set_grouping = new set<String>();
        if(keys != ''){
            for(String key : keys.split(';')){
                set_key.add(key);
            }
        }else{
            set_key.addAll(list_key);
        }
        for(String mapKey : map_key_grouping.keySet()){
            if(set_key.contains(mapKey) && !map_key_grouping.get(mapKey).isEmpty()){
                set_grouping.addAll(map_key_grouping.get(mapKey));
            }
        }
        list_grouping.addAll(set_grouping);
        return list_grouping;
    }
    
    @RemoteAction
    public static map<String, String> getExportGroup(String sData) {
        //map<String, map<String, list<String>>> map_tCode_pFamily_pCode = new map<String, map<String, list<String>>>();
        map<String, String> map_ExportGroup = new map<String, String>();
        
        SearchData searchOb = (SearchData)JSON.deserialize(sData,SearchData.class);
        system.debug('searchOb:'+searchOb); 
        
        if(searchOb.source == 'AM'){
            map_ExportGroup = getAMExportGroup(searchOb);
        }
        if(searchOb.source == 'Relay'){
            map_ExportGroup = getRelayExportGroup(searchOb);
        }
        if(searchOb.source == 'GAM'){
            map_ExportGroup = getGAMExportGroup(searchOb);
        }
        if(searchOb.source == 'RSM'){
            map_ExportGroup = getRSMExportGroup(searchOb);
        }
        if(searchOb.source == 'RSMRelay'){
            map_ExportGroup = getRSMRelayExportGroup(searchOb);
        }
        
        return map_ExportGroup;
    }
    
    
    @RemoteAction
    public static map<String, String> getExportData(String sData) {
        decimal amount = 0;
        map<String, String> map_result = new map<String, String>();
        SearchData searchOb = (SearchData)JSON.deserialize(sData,SearchData.class);
        system.debug('searchOb:'+searchOb);        
        //try{   
            if(searchOb.source == 'AM'){
                map_result = getAMChartData(searchOb,true);
            }
            if(searchOb.source == 'Relay'){
                map_result = getRelayChartData(searchOb, true);
            }
            if(searchOb.source == 'GAM'){
                map_result = getGAMChartData(searchOb, true);
            }
            if(searchOb.source == 'RSM'){
                map_result = getRSMChartData(searchOb, true);
            }
            if(searchOb.source == 'RSMRelay'){
                map_result = getRSMRelayChartData(searchOb, true);
            }  
            //result.amount = amount;
        //}
        //catch(Exception ex){
            //result.message = ex.getMessage();
            //result.amount = null;
        //}

        system.debug('map_result:'+map_result);
        return map_result;
    }

    public static map<String, String> getAMExportGroup(SearchData searchOb){
        Integer currentYear;
        Integer currenQuarter;
        Boolean hasRelay = false;
        String territorName = '';
        set<String> set_productFamily = new set<String>();
        set<String> set_territorCode = new set<String>();
        set<String> set_billingQuarter = new set<String>();
        set<String> set_forecastQuarter = new set<String>();
        map<String, String> map_result = new map<String, String>();
        
        /** get product family set **/
        if(searchOb.productFamily != null && searchOb.productFamily != ''){
            set_productFamily.addAll(searchOb.productFamily.split(';'));
        }else{
            set_productFamily.addAll(map_cbc2id_cbc2label.keySet());
            hasRelay = true;
        }
        
        /** get product territory code **/
        for(String tcode : searchOb.territoryCode.split(';')){
            set_territorCode.add(tcode);
        }
        
        for(AggregateResult result : [Select Account_Manager__r.name tname From Account Where SALES_TERRITORY_CDE__c In: set_territorCode Group By Account_Manager__r.name]){
            if(result.get('tname') != null && String.valueof(result.get('tname')) != ''){
                territorName = String.valueof(result.get('tname'));
            }
        }
        
        currenQuarter = Integer.valueOf(searchOb.currentFiscalQuarter);
        currentYear = Integer.valueOf(searchOb.currentFiscalYear);
        
        for(Integer i = 1; i < currenQuarter; i++){
            set_billingQuarter.add(String.valueOf(i));
        }
        for(Integer j = currenQuarter; j <= 4; j++){
            set_forecastQuarter.add('0' + String.valueOf(j));
        }

        /** get billing group map **/
        if(!set_billingQuarter.isEmpty()){
            set<String> set_AccIds = new set<String>();
            set<String> set_pcode = new set<String>();
            set<String> set_excludeCode = new set<String>();
            String queryPartIds;
            
            ClsAPLForecastUtil.setRSMAccountIds(true, set_territorCode, set_AccIds);
            
            if(!set_productFamily.isEmpty()){
                for(String fcode : set_productFamily){
                    if(fcode != 'Relay'){
                        set_pcode.add(map_cbc2id_cbc2label.get(fcode));
                    }
                    else{
                        set_pcode.addAll(map_relay_cbc2label_cbc2id.values());
                        hasRelay = true;
                    }
                }
                system.debug('set_productFamily:'+set_productFamily); 
                system.debug('set_pcode:' + set_pcode);
                system.debug('set_excludeCode:' + set_excludeCode); 
                set_excludeCode.addAll(map_cbc2id_cbc2label.values());
                set_excludeCode.addAll(map_relay_cbc2label_cbc2id.values());
                set_excludeCode.remove('Relay');
                set_excludeCode.remove('Other CBC2');
                set_excludeCode.removeAll(set_pcode);                    

                queryPartIds = ' (Part__r.Product_Hierarchy__r.CBC2__c in :set_pcode or Part__r.Product_Hierarchy__r.CBC3__c in :set_pcode) ';
                if(set_pcode.contains('Other CBC2')){
                    // delete limte 'Part__r.Product_Hierarchy__r.CBC1__c != \'30007\' and ' by Mingxing Qiu Because  export date and chart data unlike
                    queryPartIds = ' ( Part__r.Product_Hierarchy__r.CBC2__c not in :set_excludeCode and Part__r.Product_Hierarchy__r.CBC3__c not in :set_excludeCode) ';
                }
            }else{
                hasRelay = true;
            }
            
            if(!set_AccIds.isEmpty()){
                String queryBillingStr = 'SELECT sum(Bill_Amount_USD__c) billing, customer__r.APL_AM_Display_Name__c, Part__r.Product_Hierarchy__r.CBC2__c, Part__r.Product_Hierarchy__r.CBC3__c, Part__r.Product_Hierarchy__r.Name, ';
                queryBillingStr += 'Part__r.Product_Hierarchy__r.GPL_Description__c, Part__r.PRODUCT_CDE__c, Part__r.PROD_NAME__c FROM BBB_Month_Bill_Book_Cust_PN__c ';
                /* update by nelson zheng 2015-10-21 for case 00900375 begin
                queryBillingStr += 'WHERE Customer__r.STATDESC__c = \'Active\' AND Profit_Center__c IN (\'APL\'';
                if(hasRelay){
                    queryBillingStr +=', \'RPA\'';
                }
                queryBillingStr += ') AND Bill_Amount_USD__c != 0';*/
                queryBillingStr += 'WHERE Customer__r.STATDESC__c = \'Active\' ';
                
                queryBillingStr += ' AND Bill_Amount_USD__c != 0';
                
                queryBillingStr +=  '  AND (Fiscal_Year__c = \'' + (currentYear-1) + '\' OR (Fiscal_Year__c = \'' + currentYear + '\' AND Fiscal_Quarter__c in: set_billingQuarter))';
                queryBillingStr += ' AND Customer__c IN: set_AccIds';
                queryBillingStr += ' AND Customer__r.SALES_TERRITORY_CDE__c IN: set_territorCode';
                /*
                if(queryPartIds != null){
                    queryBillingStr += ' AND ' + queryPartIds;
                }
                */
                if(queryPartIds != null){
                    queryBillingStr += ' AND Profit_Center__c = \'APL\' AND ' + queryPartIds;
                }else{
                    if(hasRelay || set_productFamily.contains('Relay')){
                        queryBillingStr += ' AND Profit_Center__c = \'APL\'';
                    }else{
                    	//change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
                        queryBillingStr += ' AND (Profit_Center__c = \'APL\' and Part__r.Product_Hierarchy__r.CBC3__c not in (\'41553\') and Part__r.Product_Hierarchy__r.CBC2__c not in (\'30005\',\'13213\'))';
                    }
                }
                System.debug('---------APL_CompForecastBillingChart.cls (10 matches) 6--------------');
                //update by nelson zheng 2015-10-21 for case 00900375 end
                
                if(searchOb.aMGrouping !=null && searchOb.aMGrouping != ''){
                    queryBillingStr += ' AND customer__r.APL_AM_Display_Name__c in (\''+ (String)searchOb.aMGrouping.replaceAll(';', '\', \'') + '\')';
                }
                
                queryBillingStr += ' Group By customer__r.APL_AM_Display_Name__c, Part__r.Product_Hierarchy__r.CBC2__c, Part__r.Product_Hierarchy__r.CBC3__c, Part__r.Product_Hierarchy__r.Name, Part__r.Product_Hierarchy__r.GPL_Description__c, Part__r.PRODUCT_CDE__c, Part__r.PROD_NAME__c';
                
                system.debug('queryBillingStr:'+queryBillingStr);
                system.debug('set_AccIds:'+set_AccIds);
                system.debug('queryPartIds:'+queryPartIds);

                for(AggregateResult  result : Database.query(queryBillingStr)) {
                    if(result.get('billing') != null){
                        String productFamily ='';
                        String productCode = '';
                        String groupKey = territorName;
                        
                        if(result.get('APL_AM_Display_Name__c') == null) groupKey += '|' + '';
                        else groupKey += '|' + (String)result.get('APL_AM_Display_Name__c');
                            
                        if(map_cbc2label_cbc2id.get((String)result.get('CBC2__c')) != null && result.get('Name') != null && result.get('GPL_Description__c') != null){
                            productFamily = map_cbc2label_cbc2id.get((String)result.get('CBC2__c'));
                            productCode = '[ ' + (String)result.get('Name') + ' ] - ' + (String)result.get('GPL_Description__c');
                        }else if(map_relay_cbc2id_cbc2label.get((String)result.get('CBC2__c')) != null && result.get('PRODUCT_CDE__c') != null && result.get('PROD_NAME__c') != null){
                            productFamily = map_relay_cbc2id_cbc2label.get((String)result.get('CBC2__c'));
                            productCode = '[ ' + (String)result.get('PRODUCT_CDE__c') + ' ] - ' + (String)result.get('PROD_NAME__c');
                        }else if(map_relay_cbc2id_cbc2label.get((String)result.get('CBC3__c')) != null && result.get('PRODUCT_CDE__c') != null && result.get('PROD_NAME__c') != null ){
                            productFamily = map_relay_cbc2id_cbc2label.get((String)result.get('CBC3__c'));
                            productCode = '[ ' + (String)result.get('PRODUCT_CDE__c') + ' ] - ' + (String)result.get('PROD_NAME__c');
                        }else{
                            productFamily = map_cbc2label_cbc2id.get('Other CBC2');
                        }
                        
                        if(productFamily != ''){
                            groupKey += '|' + productFamily;
                            
                            if(productCode != ''){
                                groupKey += '|' + productCode;
                            }
                        }
                        map_result.put(groupKey, groupKey);    
                    }
                }   
            }
        }
        
        /** get forecast group map **/
        set<String> set_relaycode = new set<String>();
        
        String queryForecastStr = 'SELECT sum(Forecast__c) fc, customer__r.APL_AM_Display_Name__c, Type__c, GPL__r.CBC2__c, GPL__r.CBC3__c, GPL__r.Name, GPL__r.GPL_Description__c,';
        queryForecastStr += ' Relay_CBC2_Code__c, PRODUCT_CDE__c, PROD_NAME__c  FROM APL_Sales_Forecast__c WHERE Forecast__c != null';
        queryForecastStr += ' AND Customer__r.STATDESC__c != \'Not Active\' AND (Fiscal_Year__c = \'' + (currentYear+1) + '\' OR (Fiscal_Year__c = \'' + currentYear + '\' AND Fiscal_Quarter__c in: set_forecastQuarter))';
        if(searchOb.aMGrouping !=null && searchOb.aMGrouping != ''){
            queryForecastStr += ' AND customer__r.APL_AM_Display_Name__c in (\''+ (String)searchOb.aMGrouping.replaceAll(';', '\', \'') + '\')';
        }
        queryForecastStr += ' AND Customer__r.SALES_TERRITORY_CDE__c IN: set_territorCode';
        if(!set_productFamily.isEmpty()){
            String productFamilyFilter = '';
            
            if(set_productFamily.contains('Relay')){
                set_relaycode.addAll(map_relay_cbc2label_cbc2id.values());
                productFamilyFilter += ' OR (Type__c = \'Relay Product Code\' AND Relay_CBC2_Code__c IN: set_relaycode)';
                set_productFamily.remove('Relay');
            }
            
            if(set_productFamily.contains('Other BU Products')){
                productFamilyFilter += ' OR Type__c = \'Other CBC2\'';
                set_productFamily.remove('Other BU Products');
            }
            if(set_productFamily.size() > 0){
                productFamilyFilter += ' OR (Type__c = \'GPL\' AND (';
                String cbcCodes = '(';
                for(String pfkey : set_productFamily){
                    cbcCodes += '\'' + map_cbc2id_cbc2label.get(pfkey) + '\', ';
                }
                cbcCodes = cbcCodes.substring(0, cbcCodes.lastIndexOf(',')) + ')';
                productFamilyFilter += 'GPL__r.CBC2__c IN ' + cbcCodes + ' OR GPL__r.CBC3__c IN ' + cbcCodes + '))';
            }
            if(productFamilyFilter.indexOf('OR') == 1){
                productFamilyFilter = productFamilyFilter.substring(4, productFamilyFilter.length());
            }
            
            queryForecastStr += ' AND (' + productFamilyFilter + ')';
        }
        
        queryForecastStr += ' Group By customer__r.APL_AM_Display_Name__c, Type__c, GPL__r.CBC2__c, GPL__r.CBC3__c, GPL__r.Name, GPL__r.GPL_Description__c, Relay_CBC2_Code__c, PRODUCT_CDE__c, PROD_NAME__c';
        
        system.debug('queryForecastStr:'+queryForecastStr);
        for(AggregateResult  result : Database.query(queryForecastStr)) {
            if(result.get('fc') != null){
                String productFamily ='';
                String productCode = '';
                String groupKey = territorName;
       
                if(result.get('APL_AM_Display_Name__c') == null) groupKey += '|' + '';
                else groupKey += '|' + (String)result.get('APL_AM_Display_Name__c');
                
                if(result.get('Type__c') == 'GPL' && map_cbc2label_cbc2id.get((String)result.get('CBC2__c')) != null && result.get('Name') != null && result.get('GPL_Description__c') != null){
                    productFamily = map_cbc2label_cbc2id.get((String)result.get('CBC2__c'));
                    productCode = '[ ' + (String)result.get('Name') + ' ] - ' + (String)result.get('GPL_Description__c');
                }else if(result.get('Type__c') == 'Relay Product Code' && map_relay_cbc2id_cbc2label.get((String)result.get('Relay_CBC2_Code__c')) != null && result.get('PRODUCT_CDE__c') != null && result.get('PROD_NAME__c') != null){
                    productFamily = map_relay_cbc2id_cbc2label.get((String)result.get('Relay_CBC2_Code__c'));
                    productCode = '[ ' + (String)result.get('PRODUCT_CDE__c') + ' ] - ' + (String)result.get('PROD_NAME__c');
                }else if(result.get('Type__c') == 'Other CBC2'){
                    productFamily = map_cbc2label_cbc2id.get('Other CBC2');
                }
                            
                if(productFamily != ''){
                    groupKey += '|' + productFamily;
                    
                    if(productCode != ''){
                        groupKey += '|' + productCode;
                    }
                }
                map_result.put(groupKey, groupKey);
            }
        }
        system.debug('map_result:' + map_result);
        return map_result;
    }
    
    public static map<String, String> getRelayExportGroup(SearchData searchOb){
        Integer currentYear;
        Integer currenQuarter;
        String territorName = '';
        set<String> set_productFamily = new set<String>();
        set<String> set_territorCode = new set<String>();
        set<String> set_billingQuarter = new set<String>();
        set<String> set_forecastQuarter = new set<String>();
        map<String, String> map_result = new map<String, String>();
        
        
        /** get product family set **/
        if(searchOb.productFamily != null && searchOb.productFamily != ''){
            set_productFamily.addAll(searchOb.productFamily.split(';'));
        }else{
            set_productFamily.addAll(map_relay_cbc2label_cbc2id.keySet());
        }
        
        /** get product territory code **/
        for(String tcode : searchOb.territoryCode.split(';')){
            set_territorCode.add(tcode);
        }
        
        for(AggregateResult result : [Select Relay_Hierarchy__r.Level_7_Default_Owner__r.name tname From Account Where Relay_Specialist_Territory_Code__c In: set_territorCode Group By Relay_Hierarchy__r.Level_7_Default_Owner__r.name]){
            if(result.get('tname') != null && String.valueof(result.get('tname')) != ''){
                territorName = String.valueof(result.get('tname'));
            }
        }
        
        currenQuarter = Integer.valueOf(searchOb.currentFiscalQuarter);
        currentYear = Integer.valueOf(searchOb.currentFiscalYear);
        
        for(Integer i = 1; i < currenQuarter; i++){
            set_billingQuarter.add(String.valueOf(i));
        }
        for(Integer j = currenQuarter; j <= 4; j++){
            set_forecastQuarter.add('0' + String.valueOf(j));
        }

        /** get billing group map **/
        if(!set_billingQuarter.isEmpty()){
            set<String> set_AccIds = new set<String>();
            set<String> set_pcode = new set<String>();
            String queryPartIds;
            
            system.debug('set_territorCode:'+set_territorCode);
            ClsAPLForecastUtil.setRSMAccountIds(false, set_territorCode, set_AccIds);
            
            
            if(!set_productFamily.isEmpty()){
                for(String fcode : set_productFamily){
                    set_pcode.add(map_relay_cbc2label_cbc2id.get(fcode));
                }
                system.debug('set_pcode:' + set_pcode);
                queryPartIds = ' (Part__r.Product_Hierarchy__r.CBC2__c in :set_pcode or Part__r.Product_Hierarchy__r.CBC3__c in :set_pcode) ';
            }

            if(!set_AccIds.isEmpty()){
                String queryBillingStr = 'SELECT sum(Bill_Amount_USD__c) billing, customer__r.APL_Relay_Display_Name__c, Part__r.Product_Hierarchy__r.CBC2__c, Part__r.Product_Hierarchy__r.CBC3__c,';
                queryBillingStr += ' Part__r.PRODUCT_CDE__c, Part__r.PROD_NAME__c FROM BBB_Month_Bill_Book_Cust_PN__c';
                
                //update by nelson zheng 2015-10-21 for case 00900375
                //queryBillingStr += ' WHERE Customer__r.STATDESC__c = \'Active\' AND Profit_Center__c IN (\'RPA\')';
                queryBillingStr += ' WHERE Customer__r.STATDESC__c = \'Active\' ';
                System.debug('---------APL_CompForecastBillingChart.cls (10 matches) 7--------------');
                
                queryBillingStr +=  '  AND (Fiscal_Year__c = \'' + (currentYear-1) + '\' OR (Fiscal_Year__c = \'' + currentYear + '\' AND Fiscal_Quarter__c in: set_billingQuarter))';
                queryBillingStr += ' AND Customer__c IN: set_AccIds';
                queryBillingStr += ' AND Customer__r.Relay_Specialist_Territory_Code__c IN: set_territorCode';
                /*update by nelson zheng 2015-10-21 for case 00900375
                if(queryPartIds != null){
                    queryBillingStr += ' AND ' + queryPartIds;
                }*/
                if(queryPartIds != null){
                    queryBillingStr += ' AND Profit_Center__c = \'APL\' AND ' + queryPartIds;
                }else{
                	//change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
                    queryBillingStr += ' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'41553\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))';
                }//update by nelson zheng 2015-10-21 for case 00900375
                
                
                if(searchOb.relayGrouping !=null && searchOb.relayGrouping != ''){
                    queryBillingStr += ' AND customer__r.APL_Relay_Display_Name__c in (\''+ (String)searchOb.relayGrouping.replaceAll(';', '\', \'') + '\')';
                }

                queryBillingStr += ' Group By customer__r.APL_Relay_Display_Name__c, Part__r.Product_Hierarchy__r.CBC2__c, Part__r.Product_Hierarchy__r.CBC3__c, Part__r.PRODUCT_CDE__c, Part__r.PROD_NAME__c';
                
                system.debug('queryBillingStr:'+queryBillingStr);
                system.debug('set_AccIds:'+set_AccIds);
                system.debug('queryPartIds:'+queryPartIds);
                
                for(AggregateResult  result : Database.query(queryBillingStr)) {
                    if(result.get('billing') != null){
                        String productFamily ='';
                        String productCode = '';
                        String groupKey = territorName;

                        if(result.get('APL_Relay_Display_Name__c') == null) groupKey += '|' + '';
                        else groupKey += '|' + (String)result.get('APL_Relay_Display_Name__c');
                                                
                        
                        if(map_relay_cbc2id_cbc2label.get((String)result.get('CBC2__c')) != null && result.get('PRODUCT_CDE__c') != null && result.get('PROD_NAME__c') != null){
                            productFamily = map_relay_cbc2id_cbc2label.get((String)result.get('CBC2__c'));
                            productCode = '[ ' + (String)result.get('PRODUCT_CDE__c') + ' ] - ' + (String)result.get('PROD_NAME__c');
                        }else if(map_relay_cbc2id_cbc2label.get((String)result.get('CBC3__c')) != null && result.get('PRODUCT_CDE__c') != null && result.get('PROD_NAME__c') != null ){
                            productFamily = map_relay_cbc2id_cbc2label.get((String)result.get('CBC3__c'));
                            productCode = '[ ' + (String)result.get('PRODUCT_CDE__c') + ' ] - ' + (String)result.get('PROD_NAME__c');
                        }
                        
                        if(productFamily != ''){
                            groupKey += '|' + productFamily;
                            
                            if(productCode != ''){
                                groupKey += '|' + productCode;
                            }
                        }
                        map_result.put(groupKey, groupKey);    
                    }
                } 
            }
        }
        
        /** get forecast group map **/
        String queryForecastStr = 'SELECT sum(Forecast__c) fc, customer__r.APL_Relay_Display_Name__c, Type__c, GPL__r.CBC2__c, GPL__r.CBC3__c,';
        queryForecastStr += ' Relay_CBC2_Code__c, PRODUCT_CDE__c, PROD_NAME__c  FROM APL_Sales_Forecast__c WHERE Forecast__c != null';
        queryForecastStr += ' AND Customer__r.STATDESC__c != \'Not Active\' AND Customer__r.APL_Relay_forecast_Plan_Account__c != null AND (Fiscal_Year__c = \'' + (currentYear+1) + '\' OR (Fiscal_Year__c = \'' + currentYear + '\' AND Fiscal_Quarter__c in: set_forecastQuarter))';
        
        if(searchOb.relayGrouping !=null && searchOb.relayGrouping != ''){
            queryForecastStr += ' AND customer__r.APL_Relay_Display_Name__c in (\''+ (String)searchOb.relayGrouping.replaceAll(';', '\', \'') + '\')';
        }
        queryForecastStr += ' AND Customer__r.Relay_Specialist_Territory_Code__c IN: set_territorCode';
        if(!set_productFamily.isEmpty()){
            queryForecastStr += ' AND Type__c = \'Relay Product Code\' AND ';
            String cbcCodes = '(';
            for(String pfkey : set_productFamily){
                cbcCodes += '\'' + map_relay_cbc2label_cbc2id.get(pfkey) + '\', ';
            }
            cbcCodes = cbcCodes.substring(0, cbcCodes.lastIndexOf(',')) + ')';
            queryForecastStr += 'Relay_CBC2_Code__c IN ' + cbcCodes;
        }
        
        queryForecastStr += ' Group By customer__r.APL_Relay_Display_Name__c, Type__c, GPL__r.CBC2__c, GPL__r.CBC3__c, Relay_CBC2_Code__c, PRODUCT_CDE__c, PROD_NAME__c';
        
        system.debug('queryForecastStr:'+queryForecastStr);
        for(AggregateResult  result : Database.query(queryForecastStr)) {
            if(result.get('fc') != null){
                String productFamily ='';
                String productCode = '';
                String groupKey = territorName;
                
                if(result.get('APL_Relay_Display_Name__c') == null) groupKey += '|' + '';
                else groupKey += '|' + (String)result.get('APL_Relay_Display_Name__c');
                    
                if(result.get('Type__c') == 'Relay Product Code' && map_relay_cbc2id_cbc2label.get((String)result.get('Relay_CBC2_Code__c')) != null && result.get('PRODUCT_CDE__c') != null && result.get('PROD_NAME__c') != null){
                    productFamily = map_relay_cbc2id_cbc2label.get((String)result.get('Relay_CBC2_Code__c'));
                    productCode = '[ ' + (String)result.get('PRODUCT_CDE__c') + ' ] - ' + (String)result.get('PROD_NAME__c');
                }
                        
                if(productFamily != ''){
                    groupKey += '|' + productFamily;
                    
                    if(productCode != ''){
                        groupKey += '|' + productCode;
                    }
                }
                map_result.put(groupKey, groupKey);
            }
        }
        system.debug('map_result:' + map_result);
        return map_result;
    }
    
    public static map<String, String> getGAMExportGroup(SearchData searchOb){
        Integer currentYear;
        Integer currenQuarter;
        Boolean hasRelay = false;
        set<string> set_region = new set<string>();
        set<String> set_productFamily = new set<String>();
        set<String> set_GAMCodes = new set<String>();
        set<String> set_billingQuarter = new set<String>();
        set<String> set_forecastQuarter = new set<String>();
        map<String, String> map_result = new map<String, String>();
        map<String, String> map_tCodeRegion  = getRegionNameByL2TCode(map_Region_LV2TerritoryCode);
        
        /** get product family set **/
        if(searchOb.productFamily != null && searchOb.productFamily != ''){
            set_productFamily.addAll(searchOb.productFamily.split(';'));
        }else{
            set_productFamily.addAll(map_cbc2id_cbc2label.keySet());
            hasRelay = true;
        }
        
        /** get level2 territory code **/
        String queryManagement = 'Select GAM_Code__c From APL_Forecast_Management__c Where GAM_Code__c != null AND Manager__c = \'' + UserInfo.getUserId() + '\' And RecordType.Name != null';
        for(APL_Forecast_Management__c afm : Database.query(queryManagement)){
            set_GAMCodes.add(afm.GAM_Code__c);
        }

        if(searchOb.region !=null && searchOb.region != ''){
            for(String region : searchOb.region.split(';')){
                if(map_Region_LV2TerritoryCode.get(region) != null){
                    set_region.add(map_Region_LV2TerritoryCode.get(region));
                }
            }
        }else{
            set<String> set_lv2TerritoryCodes = new set<String>();
            set_lv2TerritoryCodes.addAll(ClsAPLForecastUtil.map_LV2TerritoryCode_Region.keySet());
            String queryRegion = 'Select Territory_L2_code__c From Account Where STATDESC__c != \'Not Active\' And GAMCD__c in : set_GAMCodes';
            queryRegion += ' And Territory_L2_code__c in : set_lv2TerritoryCodes';
    
            for(Account account : database.Query(queryRegion)){
                if(account.Territory_L2_code__c != null && ClsAPLForecastUtil.map_LV2TerritoryCode_Region.get(account.Territory_L2_code__c) != null){
                    set_region.add(account.Territory_L2_code__c);
                }
            }
        }
        system.debug('set_region:' + set_region);
        
        currenQuarter = Integer.valueOf(searchOb.currentFiscalQuarter);
        currentYear = Integer.valueOf(searchOb.currentFiscalYear);
        
        for(Integer i = 1; i < currenQuarter; i++){
            set_billingQuarter.add(String.valueOf(i));
        }
        for(Integer j = currenQuarter; j <= 4; j++){
            set_forecastQuarter.add('0' + String.valueOf(j));
        }

        /** get billing group map **/
        if(!set_billingQuarter.isEmpty()){
            set<String> set_pcode = new set<String>();
            set<String> set_excludeCode = new set<String>();
            String queryPartIds;
            
            if(!set_productFamily.isEmpty()){
                for(String fcode : set_productFamily){
                    if(fcode != 'Relay'){
                        set_pcode.add(map_cbc2id_cbc2label.get(fcode));
                    }
                    else{
                        set_pcode.addAll(map_relay_cbc2label_cbc2id.values());
                        hasRelay = true;
                    }
                }
                system.debug('set_pcode:' + set_pcode);
                set_excludeCode.addAll(map_cbc2id_cbc2label.values());
                set_excludeCode.addAll(map_relay_cbc2label_cbc2id.values());
                set_excludeCode.remove('Relay');
                set_excludeCode.remove('Other CBC2');
                set_excludeCode.removeAll(set_pcode);               

                system.debug('set_excludCode:' + set_excludeCode);
                queryPartIds = ' (Part__r.Product_Hierarchy__r.CBC2__c in :set_pcode or Part__r.Product_Hierarchy__r.CBC3__c in :set_pcode) ';
                if(set_pcode.contains('Other CBC2')){
                    // delete limte 'Part__r.Product_Hierarchy__r.CBC1__c != \'30007\' and ' by Mingxing Qiu Because  export date and chart data unlike
                    queryPartIds = ' ( Part__r.Product_Hierarchy__r.CBC2__c not in :set_excludeCode and Part__r.Product_Hierarchy__r.CBC3__c not in :set_excludeCode) ';
                }   
            }else{
                hasRelay = true;
            }

            String queryBillingStr = 'SELECT sum(Bill_Amount_USD__c) billing, customer__r.Sales_Hierarchy__r.Level_2_Territory_Code__c region, Part__r.Product_Hierarchy__r.CBC2__c, Part__r.Product_Hierarchy__r.CBC3__c, Part__r.Product_Hierarchy__r.Name, ';
            queryBillingStr += 'Part__r.Product_Hierarchy__r.GPL_Description__c, Part__r.PRODUCT_CDE__c, Part__r.PROD_NAME__c FROM BBB_Month_Bill_Book_Cust_PN__c ';
            
            /* update by nelson zheng 2015-10-21 for case 00900375 begin
            queryBillingStr += 'WHERE Customer__r.STATDESC__c = \'Active\' AND Profit_Center__c IN (\'APL\'';
            if(hasRelay){
                queryBillingStr +=', \'RPA\'';
            }
            queryBillingStr +=  ') AND Fiscal_Year__c = \'' + currentYear +'\' AND Fiscal_Quarter__c in: set_billingQuarter';
            */
            queryBillingStr += 'WHERE Customer__r.STATDESC__c = \'Active\' ';
            
            queryBillingStr +=  ' AND (Fiscal_Year__c = \'' + (currentYear-1) + '\' OR (Fiscal_Year__c = \'' + currentYear + '\' AND Fiscal_Quarter__c in: set_billingQuarter))';
            
            
            if(!set_region.isEmpty()){
                queryBillingStr += ' AND customer__r.Territory_L2_code__c In: set_region';
            }
            /*update by nelson zheng 2015-10-21 for case 00900375
            if(queryPartIds != null){
                queryBillingStr += ' AND ' + queryPartIds;
            }*/
            if(queryPartIds != null){
                queryBillingStr += ' AND Profit_Center__c = \'APL\' AND ' + queryPartIds;
            }else{
                if(hasRelay){
                    queryBillingStr +=' AND Profit_Center__c = \'APL\'';
                }else{
                	//change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
                    queryBillingStr +=' AND (Profit_Center__c = \'APL\' and Part__r.Product_Hierarchy__r.CBC3__c not in (\'41553\') and Part__r.Product_Hierarchy__r.CBC2__c not in (\'30005\',\'13213\'))';
                }
            }
            System.debug('---------APL_CompForecastBillingChart.cls (10 matches) 8--------------');
            //update by nelson zheng 2015-10-21 for case 00900375 end
            
            queryBillingStr += ' AND customer__r.GAMCD__c in :set_GAMCodes';
  
            queryBillingStr += ' Group By customer__r.Sales_Hierarchy__r.Level_2_Territory_Code__c, Part__r.Product_Hierarchy__r.CBC2__c, Part__r.Product_Hierarchy__r.CBC3__c, Part__r.Product_Hierarchy__r.Name, Part__r.Product_Hierarchy__r.GPL_Description__c, Part__r.PRODUCT_CDE__c, Part__r.PROD_NAME__c';
            
            for(AggregateResult  result : Database.query(queryBillingStr)) {
                if(result.get('billing') != null){
                    String productFamily ='';
                    String productCode = '';
                    String groupKey = '';
                    
                    if(result.get('region') != null && map_tCodeRegion.containsKey(String.valueOf(result.get('region'))) != null && map_tCodeRegion.get(String.valueOf(result.get('region'))) != ''){
                        groupKey = map_tCodeRegion.get(String.valueOf(result.get('region')));
                        
                        if(map_cbc2label_cbc2id.get((String)result.get('CBC2__c')) != null && result.get('Name') != null && result.get('GPL_Description__c') != null){
                            productFamily = map_cbc2label_cbc2id.get((String)result.get('CBC2__c'));
                            productCode = '[ ' + (String)result.get('Name') + ' ] - ' + (String)result.get('GPL_Description__c');
                        }else if(map_relay_cbc2id_cbc2label.get((String)result.get('CBC2__c')) != null && result.get('PRODUCT_CDE__c') != null && result.get('PROD_NAME__c') != null){
                            productFamily = map_relay_cbc2id_cbc2label.get((String)result.get('CBC2__c'));
                            productCode = '[ ' + (String)result.get('PRODUCT_CDE__c') + ' ] - ' + (String)result.get('PROD_NAME__c');
                        }else if(map_relay_cbc2id_cbc2label.get((String)result.get('CBC3__c')) != null && result.get('PRODUCT_CDE__c') != null && result.get('PROD_NAME__c') != null ){
                            productFamily = map_relay_cbc2id_cbc2label.get((String)result.get('CBC3__c'));
                            productCode = '[ ' + (String)result.get('PRODUCT_CDE__c') + ' ] - ' + (String)result.get('PROD_NAME__c');
                        }else{
                            productFamily = map_cbc2label_cbc2id.get('Other CBC2');
                        }
                        
                        if(productFamily != ''){
                            groupKey += '|' + productFamily;
                                
                            if(productCode != ''){
                                groupKey += '|' + productCode;
                            }
                        }
                    }
                    map_result.put(groupKey, groupKey);
                }
            } 
        }
        
        /** get forecast group map **/
        set<String> set_relaycode = new set<String>();

        String queryForecastStr = 'SELECT sum(GAM_Forecast__c) fc, Customer__r.Sales_Hierarchy__r.Level_2_Territory_Code__c region, Type__c, GPL__r.CBC2__c, GPL__r.CBC3__c, GPL__r.Name, GPL__r.GPL_Description__c,';
        queryForecastStr += ' Relay_CBC2_Code__c, PRODUCT_CDE__c, PROD_NAME__c  FROM APL_Sales_Forecast__c WHERE GAM_Forecast__c != null';
        queryForecastStr += ' AND Customer__r.STATDESC__c != \'Not Active\' AND (Fiscal_Year__c = \'' + (currentYear+1) + '\' OR (Fiscal_Year__c = \'' + currentYear + '\' AND Fiscal_Quarter__c in: set_forecastQuarter))';
        if(!set_region.isEmpty()){
            queryForecastStr += ' AND customer__r.Territory_L2_code__c In: set_region';
        }
        queryForecastStr += ' AND customer__r.GAMCD__c in :set_GAMCodes';
        
        if(!set_productFamily.isEmpty()){
            String productFamilyFilter = '';
            
            if(set_productFamily.contains('Relay')){
                set_relaycode.addAll(map_relay_cbc2label_cbc2id.values());
                productFamilyFilter += ' OR (Type__c = \'Relay Product Code\' AND Relay_CBC2_Code__c IN: set_relaycode)';
                set_productFamily.remove('Relay');
            }
            
            if(set_productFamily.contains('Other BU Products')){
                productFamilyFilter += ' OR Type__c = \'Other CBC2\'';
                set_productFamily.remove('Other BU Products');
            }
            if(set_productFamily.size() > 0){
                productFamilyFilter += ' OR (Type__c = \'GPL\' AND (';
                String cbcCodes = '(';
                for(String pfkey : set_productFamily){
                    cbcCodes += '\'' + map_cbc2id_cbc2label.get(pfkey) + '\', ';
                }
                cbcCodes = cbcCodes.substring(0, cbcCodes.lastIndexOf(',')) + ')';
                productFamilyFilter += 'GPL__r.CBC2__c IN ' + cbcCodes + ' OR GPL__r.CBC3__c IN ' + cbcCodes + '))';
            }
            if(productFamilyFilter.indexOf('OR') == 1){
                productFamilyFilter = productFamilyFilter.substring(4, productFamilyFilter.length());
            }
            
            queryForecastStr += ' AND (' + productFamilyFilter + ')';
        }
        
        queryForecastStr += ' Group By Customer__r.Sales_Hierarchy__r.Level_2_Territory_Code__c, Type__c, GPL__r.CBC2__c, GPL__r.CBC3__c, GPL__r.Name, GPL__r.GPL_Description__c, Relay_CBC2_Code__c, PRODUCT_CDE__c, PROD_NAME__c';
        
        system.debug('queryForecastStr:'+queryForecastStr);
        for(AggregateResult  result : Database.query(queryForecastStr)) {
            if(result.get('fc') != null){
                String productFamily ='';
                String productCode = '';
                String groupKey = '';
                
                if(result.get('region') != null && map_tCodeRegion.containsKey(String.valueOf(result.get('region'))) != null && map_tCodeRegion.get(String.valueOf(result.get('region'))) != ''){
                    groupKey = map_tCodeRegion.get(String.valueOf(result.get('region')));
                    
                    if(result.get('Type__c') == 'GPL' && map_cbc2label_cbc2id.get((String)result.get('CBC2__c')) != null && result.get('Name') != null && result.get('GPL_Description__c') != null){
                        productFamily = map_cbc2label_cbc2id.get((String)result.get('CBC2__c'));
                        productCode = '[ ' + (String)result.get('Name') + ' ] - ' + (String)result.get('GPL_Description__c');
                    }else if(result.get('Type__c') == 'Relay Product Code' && map_relay_cbc2id_cbc2label.get((String)result.get('Relay_CBC2_Code__c')) != null && result.get('PRODUCT_CDE__c') != null && result.get('PROD_NAME__c') != null){
                        productFamily = map_relay_cbc2id_cbc2label.get((String)result.get('Relay_CBC2_Code__c'));
                        productCode = '[ ' + (String)result.get('PRODUCT_CDE__c') + ' ] - ' + (String)result.get('PROD_NAME__c');
                    }else if(result.get('Type__c') == 'Other CBC2'){
                        productFamily = map_cbc2label_cbc2id.get('Other CBC2');
                    }
                    
                    if(productFamily != ''){
                        groupKey += '|' + productFamily;
                            
                        if(productCode != ''){
                            groupKey += '|' + productCode;
                        }
                    }
                }
                map_result.put(groupKey, groupKey);
            }
        }
        system.debug('map_result :' + map_result);

        return map_result;
    }
    
    public static map<String, String> getRSMExportGroup(SearchData searchOb){
        Integer currentYear;
        Integer currenQuarter;
        String userId;
        String queryPartIds;
        Boolean hasRelay = false;
        set<String> set_productFamily = new set<String>();
        set<String> set_rsmGrouping = new set<String>();
        set<String> set_territorCode = new set<String>();
        set<String> set_billingQuarter = new set<String>();
        set<String> set_forecastQuarter = new set<String>();
        map<String, String> map_result = new map<String, String>();
        
        if(searchOb.userId != null && searchOb.userId != ''){
            userId = searchOb.userId;
        }else{
            userId = UserInfo.getUserId();
        }
        
        /** get product family set **/
        if(searchOb.productFamily != null && searchOb.productFamily != ''){
            set_productFamily.addAll(searchOb.productFamily.split(';'));
        }else{
            set_productFamily.addAll(map_cbc2id_cbc2label.keySet());
            hasRelay = true;
        }
        
        /** get product territory code **/
        if(searchOb.territoryCode != null && searchOb.territoryCode != ''){
            set_territorCode.addAll(getTcodeByTName(searchOb.territoryCode.split(';'), searchOb.source));
        }else{
            for(AggregateResult result : [select A6_Code__c territoryCode from APL_Forecast_Management__c where RSM__r.Manager__c =: userId and A6_Code__c != null and RecordType.Name = 'AM' group by A6_Code__c]){
                if(result.get('territoryCode') != null){
                    set_territorCode.add((String)result.get('territoryCode'));
                }
            }
        }
        system.debug('set_territorCode:' + set_territorCode);
        /** get rsm grouping **/
        if(searchOb.rSMGrouping != null && searchOb.rSMGrouping != ''){
            set_rsmGrouping.addAll(searchOb.rSMGrouping.split(';'));
        }
        
        currenQuarter = Integer.valueOf(searchOb.currentFiscalQuarter);
        currentYear = Integer.valueOf(searchOb.currentFiscalYear);
        
        for(Integer i = 1; i < currenQuarter; i++){
            set_billingQuarter.add(String.valueOf(i));
        }
        for(Integer j = currenQuarter; j <= 4; j++){
            set_forecastQuarter.add('0' + String.valueOf(j));
        }

        /** get billing group map **/
        if(!set_billingQuarter.isEmpty()){
            set<String> set_pcode = new set<String>();
            set<String> set_excludeCode = new set<String>();

            if(!set_productFamily.isEmpty()){
                for(String fcode : set_productFamily){
                    if(fcode != 'Relay'){
                        set_pcode.add(map_cbc2id_cbc2label.get(fcode));
                    }
                    else{
                        set_pcode.addAll(map_relay_cbc2label_cbc2id.values());
                        hasRelay = true;
                    }
                }
                system.debug('set_productFamily:'+set_productFamily); 
                system.debug('set_pcode:' + set_pcode);
                system.debug('set_excludeCode:' + set_excludeCode); 
                set_excludeCode.addAll(map_cbc2id_cbc2label.values());
                set_excludeCode.addAll(map_relay_cbc2label_cbc2id.values());
                set_excludeCode.remove('Relay');
                set_excludeCode.remove('Other CBC2');
                set_excludeCode.removeAll(set_pcode);                    

                queryPartIds = ' (Part__r.Product_Hierarchy__r.CBC2__c in :set_pcode or Part__r.Product_Hierarchy__r.CBC3__c in :set_pcode) ';
                if(set_pcode.contains('Other CBC2')){
                    // delete limte 'Part__r.Product_Hierarchy__r.CBC1__c != \'30007\' and ' by Mingxing Qiu Because  export date and chart data unlike
                    queryPartIds = ' (Part__r.Product_Hierarchy__r.CBC2__c not in :set_excludeCode and Part__r.Product_Hierarchy__r.CBC3__c not in :set_excludeCode) ';
                }
            }else{
                hasRelay = true;
            }

            String queryBillingStr = 'SELECT sum(Bill_Amount_USD__c) billing, customer__r.Account_Manager__r.name tname, Customer__r.APL_RSM_Display_Name__c, customer__r.APL_AM_Display_Name__c, Part__r.Product_Hierarchy__r.CBC2__c, Part__r.Product_Hierarchy__r.CBC3__c, Part__r.Product_Hierarchy__r.Name, ';
            queryBillingStr += 'Part__r.Product_Hierarchy__r.GPL_Description__c, Part__r.PRODUCT_CDE__c, Part__r.PROD_NAME__c FROM BBB_Month_Bill_Book_Cust_PN__c ';
            
            /* update by nelson zheng 2015-10-21 for case 00900375 begin
            queryBillingStr += 'WHERE Customer__r.STATDESC__c = \'Active\' AND Profit_Center__c IN (\'APL\'';
            if(hasRelay){
                queryBillingStr +=', \'RPA\'';
            }
            queryBillingStr += ') AND Fiscal_Year__c = \'' + currentYear +'\' AND Fiscal_Quarter__c in: set_billingQuarter';
            */
            queryBillingStr += 'WHERE Customer__r.STATDESC__c = \'Active\' ';
            
            queryBillingStr += '  AND (Fiscal_Year__c = \'' + (currentYear-1) + '\' OR (Fiscal_Year__c = \'' + currentYear + '\' AND Fiscal_Quarter__c in: set_billingQuarter))';
            
            
            if(!set_territorCode.isEmpty()){
                queryBillingStr += ' AND Customer__r.SALES_TERRITORY_CDE__c IN: set_territorCode';
            }
            if(!set_rsmGrouping.isEmpty()){
                if(set_rsmGrouping.contains(APL_CompForecastBillingChart.OTHERAMGROUPEDACCOUNTS)){
                    set_rsmGrouping.remove(APL_CompForecastBillingChart.OTHERAMGROUPEDACCOUNTS);
                    if(set_rsmGrouping.size() > 0){
                        queryBillingStr += ' AND (Customer__r.APL_RSM_Display_Name__c IN: set_rsmGrouping OR Customer__r.APL_RSM_Display_Name__c = null)';
                    }else{
                        queryBillingStr += ' AND Customer__r.APL_RSM_Display_Name__c = null';
                    }
                }else{
                    queryBillingStr += ' AND Customer__r.APL_RSM_Display_Name__c IN: set_rsmGrouping';
                }
            }
            /*
            if(queryPartIds != null){
                queryBillingStr += ' AND ' + queryPartIds;
            }*/
            if(queryPartIds != null){
                queryBillingStr += '  AND Profit_Center__c = \'APL\' AND ' + queryPartIds;
            }else{
                if(hasRelay){
                    queryBillingStr += ' AND Profit_Center__c = \'APL\'';
                }else{
                	//change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
                    queryBillingStr += ' AND (Profit_Center__c = \'APL\' and Part__r.Product_Hierarchy__r.CBC3__c not in (\'41553\') and Part__r.Product_Hierarchy__r.CBC2__c not in (\'30005\',\'13213\'))';
                }
            }
            System.debug('---------APL_CompForecastBillingChart.cls (10 matches) 9--------------');
            //update by nelson zheng 2015-10-21 for case 00900375 end
            
            if(searchOb.aMGrouping !=null && searchOb.aMGrouping != ''){
                queryBillingStr += ' AND customer__r.APL_AM_Display_Name__c in (\''+ (String)searchOb.aMGrouping.replaceAll(';', '\', \'') + '\')';
            }
            
            queryBillingStr += ' Group By customer__r.Account_Manager__r.name, Customer__r.APL_RSM_Display_Name__c, customer__r.APL_AM_Display_Name__c, Part__r.Product_Hierarchy__r.CBC2__c, Part__r.Product_Hierarchy__r.CBC3__c, Part__r.Product_Hierarchy__r.Name, Part__r.Product_Hierarchy__r.GPL_Description__c, Part__r.PRODUCT_CDE__c, Part__r.PROD_NAME__c';
            System.debug('queryBillingStr::' + queryBillingStr);
            for(AggregateResult  result : Database.query(queryBillingStr)) {
                if(result.get('billing') != null){
                    String productFamily ='';
                    String productCode = '';
                    String groupKey = '';
                    
                    if(result.get('tname') != null){
                        groupKey = (String)result.get('tname');
                        
                        if(result.get('APL_RSM_Display_Name__c') == null)  groupKey += '|' + '';
                        else groupKey += '|' + (String)result.get('APL_RSM_Display_Name__c');
                            
                        if(result.get('APL_AM_Display_Name__c') == null) groupKey += '|' + '';
                        else groupKey += '|' + (String)result.get('APL_AM_Display_Name__c');   
                                
                        if(map_cbc2label_cbc2id.get((String)result.get('CBC2__c')) != null && result.get('Name') != null && result.get('GPL_Description__c') != null){
                            productFamily = map_cbc2label_cbc2id.get((String)result.get('CBC2__c'));
                            productCode = '[ ' + (String)result.get('Name') + ' ] - ' + (String)result.get('GPL_Description__c');
                        }else if(map_relay_cbc2id_cbc2label.get((String)result.get('CBC2__c')) != null && result.get('PRODUCT_CDE__c') != null && result.get('PROD_NAME__c') != null){
                            productFamily = map_relay_cbc2id_cbc2label.get((String)result.get('CBC2__c'));
                            productCode = '[ ' + (String)result.get('PRODUCT_CDE__c') + ' ] - ' + (String)result.get('PROD_NAME__c');
                        }else if(map_relay_cbc2id_cbc2label.get((String)result.get('CBC3__c')) != null && result.get('PRODUCT_CDE__c') != null && result.get('PROD_NAME__c') != null ){
                            productFamily = map_relay_cbc2id_cbc2label.get((String)result.get('CBC3__c'));
                            productCode = '[ ' + (String)result.get('PRODUCT_CDE__c') + ' ] - ' + (String)result.get('PROD_NAME__c');
                        }else{
                            productFamily = map_cbc2label_cbc2id.get('Other CBC2');
                        }
                        
                        if(productFamily != ''){
                            groupKey += '|' + productFamily;
                            
                            if(productCode != ''){
                                groupKey += '|' + productCode;
                            }   
                        }

                        map_result.put(groupKey, groupKey);      
                    }
                }
            }  
        }
        
        /** get forecast group map **/
        set<String> set_relaycode = new set<String>();
        
        String queryForecastStr = 'SELECT sum(RSM_Forecast__c) fc, customer__r.Account_Manager__r.name tname,  Customer__r.APL_RSM_Display_Name__c, customer__r.APL_AM_Display_Name__c, Type__c, GPL__r.CBC2__c, GPL__r.CBC3__c, GPL__r.Name, GPL__r.GPL_Description__c,';
        queryForecastStr += ' Relay_CBC2_Code__c, PRODUCT_CDE__c, PROD_NAME__c  FROM APL_Sales_Forecast__c WHERE RSM_Forecast__c != null';
        queryForecastStr += ' AND Customer__r.STATDESC__c != \'Not Active\' AND (Fiscal_Year__c = \'' + (currentYear+1) + '\' OR (Fiscal_Year__c = \'' + currentYear + '\' AND Fiscal_Quarter__c in: set_forecastQuarter))';
        if(searchOb.aMGrouping !=null && searchOb.aMGrouping != ''){
            queryForecastStr += ' AND customer__r.APL_AM_Display_Name__c in (\''+ (String)searchOb.aMGrouping.replaceAll(';', '\', \'') + '\')';
        }
        if(!set_territorCode.isEmpty()){
            queryForecastStr += ' AND Customer__r.SALES_TERRITORY_CDE__c IN: set_territorCode';
        }
        if(!set_rsmGrouping.isEmpty()){
            if(set_rsmGrouping.contains(APL_CompForecastBillingChart.OTHERAMGROUPEDACCOUNTS)){
                set_rsmGrouping.remove(APL_CompForecastBillingChart.OTHERAMGROUPEDACCOUNTS);
                if(set_rsmGrouping.size() > 0){
                    queryForecastStr += ' AND (Customer__r.APL_RSM_Display_Name__c IN: set_rsmGrouping OR Customer__r.APL_RSM_Display_Name__c = null)';
                }else{
                    queryForecastStr += ' AND Customer__r.APL_RSM_Display_Name__c = null';
                }
            }else{
                queryForecastStr += ' AND Customer__r.APL_RSM_Display_Name__c IN: set_rsmGrouping';
            }
        }
        if(!set_productFamily.isEmpty()){
            String productFamilyFilter = '';
            
            if(set_productFamily.contains('Relay')){
                set_relaycode.addAll(map_relay_cbc2label_cbc2id.values());
                productFamilyFilter += ' OR (Type__c = \'Relay Product Code\' AND Relay_CBC2_Code__c IN: set_relaycode)';
                set_productFamily.remove('Relay');
            }
            
            if(set_productFamily.contains('Other BU Products')){
                productFamilyFilter += ' OR Type__c = \'Other CBC2\'';
                set_productFamily.remove('Other BU Products');
            }
            if(set_productFamily.size() > 0){
                productFamilyFilter += ' OR (Type__c = \'GPL\' AND (';
                String cbcCodes = '(';
                for(String pfkey : set_productFamily){
                    cbcCodes += '\'' + map_cbc2id_cbc2label.get(pfkey) + '\', ';
                }
                cbcCodes = cbcCodes.substring(0, cbcCodes.lastIndexOf(',')) + ')';
                productFamilyFilter += 'GPL__r.CBC2__c IN ' + cbcCodes + ' OR GPL__r.CBC3__c IN ' + cbcCodes + '))';
            }
            if(productFamilyFilter.indexOf('OR') == 1){
                productFamilyFilter = productFamilyFilter.substring(4, productFamilyFilter.length());
            }
            
            queryForecastStr += ' AND (' + productFamilyFilter + ')';
        }
        
      queryForecastStr += ' Group By customer__r.Account_Manager__r.name, Customer__r.APL_RSM_Display_Name__c,customer__r.APL_AM_Display_Name__c, Type__c, GPL__r.CBC2__c, GPL__r.CBC3__c, GPL__r.Name, GPL__r.GPL_Description__c, Relay_CBC2_Code__c, PRODUCT_CDE__c, PROD_NAME__c';
       
        system.debug('set_territorCode:'+set_territorCode);
        system.debug('queryForecastStr:'+queryForecastStr);
        //Change added by Mrunal for Case 9010122
        queryForecastStr += ' LIMIT 2000';
        For(Integer i=0; i<2 ; i++){
            if(i==1)queryForecastStr += ' offset 2000';
        //Change end by Mrunal for Case 9010122
            for(AggregateResult  result : Database.query(queryForecastStr)) {
                if(result.get('fc') != null){
                    String productFamily ='';
                    String productCode = '';
                    String groupKey = '';
                    
                    if(result.get('tname') != null){
                        groupKey = (String)result.get('tname');
                        
                        if(result.get('APL_RSM_Display_Name__c') == null)  groupKey += '|' + '';
                        else groupKey += '|' + (String)result.get('APL_RSM_Display_Name__c');
                            
                        if(result.get('APL_AM_Display_Name__c') == null) groupKey += '|' + '';
                        else groupKey += '|' + (String)result.get('APL_AM_Display_Name__c');   
                                                
                                
                        if(result.get('Type__c') == 'GPL' && map_cbc2label_cbc2id.get((String)result.get('CBC2__c')) != null && result.get('Name') != null && result.get('GPL_Description__c') != null){
                            productFamily = map_cbc2label_cbc2id.get((String)result.get('CBC2__c'));
                            productCode = '[ ' + (String)result.get('Name') + ' ] - ' + (String)result.get('GPL_Description__c');
                        }else if(result.get('Type__c') == 'Relay Product Code' && map_relay_cbc2id_cbc2label.get((String)result.get('Relay_CBC2_Code__c')) != null && result.get('PRODUCT_CDE__c') != null && result.get('PROD_NAME__c') != null){
                            productFamily = map_relay_cbc2id_cbc2label.get((String)result.get('Relay_CBC2_Code__c'));
                            productCode = '[ ' + (String)result.get('PRODUCT_CDE__c') + ' ] - ' + (String)result.get('PROD_NAME__c');
                        }else if(result.get('Type__c') == 'Other CBC2'){
                            productFamily = map_cbc2label_cbc2id.get('Other CBC2');
                        }
                        
                        if(productFamily != ''){
                            groupKey += '|' + productFamily;
                            
                            if(productCode != ''){
                                groupKey += '|' + productCode;
                            }   
                        }
    
                        map_result.put(groupKey, groupKey);      
                    }
                }
        	}
        }
        system.debug('map_result:' + map_result);
        return map_result;
    }
    
    public static map<String, String> getRSMRelayExportGroup(SearchData searchOb){
        Integer currentYear;
        Integer currenQuarter;
        String userId;
        String queryPartIds;
        set<String> set_productFamily = new set<String>();
        set<String> set_rsmRelayGrouping = new set<String>();
        set<String> set_territorCode = new set<String>();
        set<String> set_billingQuarter = new set<String>();
        set<String> set_forecastQuarter = new set<String>();
        map<String, String> map_result = new map<String, String>();
        
        if(searchOb.userId != null && searchOb.userId != ''){
            userId = searchOb.userId;
        }else{
            userId = UserInfo.getUserId();
        }
        
        /** get product family set **/
        if(searchOb.productFamily != null && searchOb.productFamily != ''){
            set_productFamily.addAll(searchOb.productFamily.split(';'));
        }else{
            set_productFamily.addAll(map_relay_cbc2label_cbc2id.keySet());
        }
        
        /** get product territory code **/
        if(searchOb.territoryCode != null && searchOb.territoryCode != ''){
            set_territorCode.addAll(getTcodeByTName(searchOb.territoryCode.split(';'), searchOb.source));
        }else{
            for(AggregateResult result : [select A6_Code__c territoryCode from APL_Forecast_Management__c where RSM__r.Manager__c =: userId and A6_Code__c != null and RecordType.Name = 'Relay' group by A6_Code__c]){
                if(result.get('territoryCode') != null){
                    set_territorCode.add((String)result.get('territoryCode'));
                }
            }
        }
        
        system.debug('set_territorCode:' + set_territorCode);
        /** get rsm relay grouping **/
        if(searchOb.rSMRelayGrouping != null && searchOb.rSMRelayGrouping != ''){
            set_rsmRelayGrouping.addAll(searchOb.rSMRelayGrouping.split(';'));
        }

        
        currenQuarter = Integer.valueOf(searchOb.currentFiscalQuarter);
        currentYear = Integer.valueOf(searchOb.currentFiscalYear);
        
        for(Integer i = 1; i < currenQuarter; i++){
            set_billingQuarter.add(String.valueOf(i));
        }
        for(Integer j = currenQuarter; j <= 4; j++){
            set_forecastQuarter.add('0' + String.valueOf(j));
        }

        /** get billing group map **/
        if(!set_billingQuarter.isEmpty()){
            set<String> set_pcode = new set<String>();
            set<String> set_excludeCode = new set<String>();

            if(!set_productFamily.isEmpty()){
                for(String fcode : set_productFamily){
                    set_pcode.add(map_relay_cbc2label_cbc2id.get(fcode));
                }
                system.debug('set_pcode:' + set_pcode);
                queryPartIds = ' (Part__r.Product_Hierarchy__r.CBC2__c in :set_pcode or Part__r.Product_Hierarchy__r.CBC3__c in :set_pcode) ';
            }

            String queryBillingStr = 'SELECT sum(Bill_Amount_USD__c) billing, Customer__r.Relay_Hierarchy__r.Level_7_Default_Owner__r.name tname, Customer__r.APL_RSM_Relay_Display_Name__c, customer__r.APL_Relay_Display_Name__c, Part__r.Product_Hierarchy__r.CBC2__c, Part__r.Product_Hierarchy__r.CBC3__c, Part__r.Product_Hierarchy__r.Name, ';
            queryBillingStr += 'Part__r.Product_Hierarchy__r.GPL_Description__c, Part__r.PRODUCT_CDE__c, Part__r.PROD_NAME__c FROM BBB_Month_Bill_Book_Cust_PN__c ';
            //update by nelson zheng 2015-10-21 for case 00900375
            //queryBillingStr += 'WHERE Customer__r.STATDESC__c = \'Active\' AND Profit_Center__c IN (\'RPA\')';
            queryBillingStr += 'WHERE Customer__r.STATDESC__c = \'Active\' ';
            
            queryBillingStr += '  AND (Fiscal_Year__c = \'' + (currentYear-1) + '\' OR (Fiscal_Year__c = \'' + currentYear + '\' AND Fiscal_Quarter__c in: set_billingQuarter))';
            if(!set_territorCode.isEmpty()){
                queryBillingStr += ' AND Customer__r.Relay_Specialist_Territory_Code__c IN: set_territorCode';
            }
            if(!set_rsmRelayGrouping.isEmpty()){
                if(set_rsmRelayGrouping.contains(APL_CompForecastBillingChart.OTHERACCOUNTS)){
                    set_rsmRelayGrouping.remove(APL_CompForecastBillingChart.OTHERACCOUNTS);
                    if(set_rsmRelayGrouping.size() > 0){
                        queryBillingStr += ' AND (Customer__r.APL_RSM_Relay_Display_Name__c IN: set_rsmRelayGrouping OR Customer__r.APL_RSM_Relay_Display_Name__c = null)';
                    }else{
                        queryBillingStr += ' AND Customer__r.APL_RSM_Relay_Display_Name__c = null';
                    }
                }else{
                    queryBillingStr += ' AND Customer__r.APL_RSM_Relay_Display_Name__c IN: set_rsmRelayGrouping';
                }
            }
            /*update by nelson zheng 2015-10-21 for case 00900375
            if(queryPartIds != null){
                queryBillingStr += ' AND ' + queryPartIds;
            }*/
            if(queryPartIds != null){
                queryBillingStr += ' AND Profit_Center__c = \'APL\' AND ' + queryPartIds;
            }else{
            	//change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
                queryBillingStr += ' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'41553\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))';
            }
            System.debug('---------APL_CompForecastBillingChart.cls (10 matches) 10--------------');
            
            if(searchOb.relayGrouping !=null && searchOb.relayGrouping != ''){
                queryBillingStr += ' AND customer__r.APL_Relay_Display_Name__c in (\''+ (String)searchOb.relayGrouping.replaceAll(';', '\', \'') + '\')';
            }
            queryBillingStr += ' Group By Customer__r.Relay_Hierarchy__r.Level_7_Default_Owner__r.name, Customer__r.APL_RSM_Relay_Display_Name__c, customer__r.APL_Relay_Display_Name__c, Part__r.Product_Hierarchy__r.CBC2__c, Part__r.Product_Hierarchy__r.CBC3__c, Part__r.Product_Hierarchy__r.Name, Part__r.Product_Hierarchy__r.GPL_Description__c, Part__r.PRODUCT_CDE__c, Part__r.PROD_NAME__c';

            system.debug('queryBillingStr:' + queryBillingStr);
            for(AggregateResult  result : Database.query(queryBillingStr)) {
                if(result.get('billing') != null){
                    String productFamily ='';
                    String productCode = '';
                    String groupKey = '';
                    
                    if(result.get('tname') != null){
                        groupKey = (String)result.get('tname');
                        
                        if(result.get('APL_RSM_Relay_Display_Name__c') == null)  groupKey += '|' + '';
                        else groupKey += '|' + (String)result.get('APL_RSM_Relay_Display_Name__c');
                            
                        if(result.get('APL_Relay_Display_Name__c') == null) groupKey += '|' + '';
                        else groupKey += '|' + (String)result.get('APL_Relay_Display_Name__c');       
                            
                        if(map_cbc2label_cbc2id.get((String)result.get('CBC2__c')) != null && result.get('Name') != null && result.get('GPL_Description__c') != null){
                            productFamily = map_cbc2label_cbc2id.get((String)result.get('CBC2__c'));
                            productCode = '[ ' + (String)result.get('Name') + ' ] - ' + (String)result.get('GPL_Description__c');
                        }else if(map_relay_cbc2id_cbc2label.get((String)result.get('CBC2__c')) != null && result.get('PRODUCT_CDE__c') != null && result.get('PROD_NAME__c') != null){
                            productFamily = map_relay_cbc2id_cbc2label.get((String)result.get('CBC2__c'));
                            productCode = '[ ' + (String)result.get('PRODUCT_CDE__c') + ' ] - ' + (String)result.get('PROD_NAME__c');
                        }else if(map_relay_cbc2id_cbc2label.get((String)result.get('CBC3__c')) != null && result.get('PRODUCT_CDE__c') != null && result.get('PROD_NAME__c') != null ){
                            productFamily = map_relay_cbc2id_cbc2label.get((String)result.get('CBC3__c'));
                            productCode = '[ ' + (String)result.get('PRODUCT_CDE__c') + ' ] - ' + (String)result.get('PROD_NAME__c');
                        }else{
                            productFamily = map_cbc2label_cbc2id.get('Other CBC2'); //key for other BU Products
                        }
                        
                        if(productFamily != ''){
                            groupKey += '|' + productFamily;
                            
                            if(productCode != ''){
                                groupKey += '|' + productCode;
                            }
                        }

                    }
                    map_result.put(groupKey, groupKey); 
                }
            }  
        }
        
        /** get forecast group map **/
        set<String> set_relaycode = new set<String>();
        
        String queryForecastStr = 'SELECT sum(RSM_Forecast__c) fc, Customer__r.Relay_Hierarchy__r.Level_7_Default_Owner__r.name tname, Customer__r.APL_RSM_Relay_Display_Name__c, customer__r.APL_Relay_Display_Name__c, Type__c, GPL__r.CBC2__c, GPL__r.CBC3__c, GPL__r.Name, GPL__r.GPL_Description__c,';
        queryForecastStr += ' Relay_CBC2_Code__c, PRODUCT_CDE__c, PROD_NAME__c  FROM APL_Sales_Forecast__c WHERE RSM_Forecast__c != null';
        queryForecastStr += ' AND Customer__r.STATDESC__c != \'Not Active\' AND (Fiscal_Year__c = \'' + (currentYear+1) + '\' OR (Fiscal_Year__c = \'' + currentYear + '\' AND Fiscal_Quarter__c in: set_forecastQuarter))';
        if(searchOb.relayGrouping !=null && searchOb.relayGrouping != ''){
            queryForecastStr += ' AND customer__r.APL_Relay_Display_Name__c in (\''+ (String)searchOb.relayGrouping.replaceAll(';', '\', \'') + '\')';
        }
        if(!set_territorCode.isEmpty()){
            queryForecastStr += ' AND Customer__r.Relay_Specialist_Territory_Code__c IN: set_territorCode';
        }
        if(!set_rsmRelayGrouping.isEmpty()){
            if(set_rsmRelayGrouping.contains(APL_CompForecastBillingChart.OTHERACCOUNTS)){
                set_rsmRelayGrouping.remove(APL_CompForecastBillingChart.OTHERACCOUNTS);
                if(set_rsmRelayGrouping.size() > 0){
                    queryForecastStr += ' AND (Customer__r.APL_RSM_Relay_Display_Name__c IN: set_rsmRelayGrouping OR Customer__r.APL_RSM_Relay_Display_Name__c = null)';
                }else{
                    queryForecastStr += ' AND Customer__r.APL_RSM_Relay_Display_Name__c = null';
                }
            }else{
                queryForecastStr += ' AND Customer__r.APL_RSM_Relay_Display_Name__c IN: set_rsmRelayGrouping';
            }
        }
        if(!set_productFamily.isEmpty()){
            queryForecastStr += ' AND Type__c = \'Relay Product Code\' AND ';
            String cbcCodes = '(';
            for(String pfkey : set_productFamily){
                cbcCodes += '\'' + map_relay_cbc2label_cbc2id.get(pfkey) + '\', ';
            }
            cbcCodes = cbcCodes.substring(0, cbcCodes.lastIndexOf(',')) + ')';
            queryForecastStr += 'Relay_CBC2_Code__c IN ' + cbcCodes;
        }
        
        queryForecastStr += ' Group By Customer__r.Relay_Hierarchy__r.Level_7_Default_Owner__r.name, Customer__r.APL_RSM_Relay_Display_Name__c, customer__r.APL_Relay_Display_Name__c, Type__c, GPL__r.CBC2__c, GPL__r.CBC3__c, GPL__r.Name, GPL__r.GPL_Description__c, Relay_CBC2_Code__c, PRODUCT_CDE__c, PROD_NAME__c';
        
        system.debug('set_territorCode:'+set_territorCode);
        system.debug('queryForecastStr:'+queryForecastStr);
        for(AggregateResult  result : Database.query(queryForecastStr)) {
            if(result.get('fc') != null){
                String productFamily ='';
                String productCode = '';
                String groupKey = '';
                
                if(result.get('tname') != null){
                    groupKey = (String)result.get('tname');

                    if(result.get('APL_RSM_Relay_Display_Name__c') == null)  groupKey += '|' + '';
                    else groupKey += '|' + (String)result.get('APL_RSM_Relay_Display_Name__c');
                        
                    if(result.get('APL_Relay_Display_Name__c') == null) groupKey += '|' + '';
                    else groupKey += '|' + (String)result.get('APL_Relay_Display_Name__c');       
                            
                    if(result.get('Type__c') == 'GPL' && map_cbc2label_cbc2id.get((String)result.get('CBC2__c')) != null && result.get('Name') != null && result.get('GPL_Description__c') != null){
                        productFamily = map_cbc2label_cbc2id.get((String)result.get('CBC2__c'));
                        productCode = '[ ' + (String)result.get('Name') + ' ] - ' + (String)result.get('GPL_Description__c');
                    }else if(result.get('Type__c') == 'Relay Product Code' && map_relay_cbc2id_cbc2label.get((String)result.get('Relay_CBC2_Code__c')) != null && result.get('PRODUCT_CDE__c') != null && result.get('PROD_NAME__c') != null){
                        productFamily = map_relay_cbc2id_cbc2label.get((String)result.get('Relay_CBC2_Code__c'));
                        productCode = '[ ' + (String)result.get('PRODUCT_CDE__c') + ' ] - ' + (String)result.get('PROD_NAME__c');
                    }else if(result.get('Type__c') == 'Other CBC2'){
                        productFamily = map_cbc2label_cbc2id.get('Other CBC2');
                    }
                    
                    if(productFamily != ''){
                        groupKey += '|' + productFamily;
                        
                        if(productCode != ''){
                            groupKey += '|' + productCode;
                        }
                    }

                }
                system.debug('groupKey:' + groupKey);
                map_result.put(groupKey, groupKey);
            }
        }
        
        system.debug('map_result:' + map_result);
        return map_result;
    }
    
    public class SearchData {
        public String territoryCode {get; set;}
        public String aMGrouping {get; set;}
        public String rSMGrouping {get; set;}
        public String relayGrouping {get; set;}
        public String rSMRelayGrouping {get; set;}
        public String region {get; set;}
        public String productFamily {get; set;}
        public String fiscalYear {get; set;}
        public String fiscalQuarter {get; set;}
        public String source {get; set;}
        public String currentFiscalYear {get; set;}
        public String currentFiscalQuarter {get; set;}
        public String userId {get; set;}
    }
    
    public class ChartResultData {
        public String fiscalYear {get; set;}
        public String fiscalQuarter {get; set;}
        public Decimal amount {get; set;}
        public String message {get; set;}
    }
            
  
}