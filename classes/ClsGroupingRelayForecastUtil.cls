/**
 *  Util class for page 
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
public without sharing class ClsGroupingRelayForecastUtil {
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public static final String OTHER = system.Label.APL_Other_Accounts;    
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    public static final map<String, set<String>> map_RELAY_CBCFIELD_CBCDESC = new map<String, set<String>> {
        'CBC2__c' => new set<String> {'30005', '13213'},
        'CBC3__c' => new set<String> {'41553'}
        //comment by Lei Tang <lei.tang@capgemini.com> 2017-12-05
        //'CBC3__c' => new set<String> {'40308', '40309'}
    };
    public static final String ACCTFCTYPE = 'Account';
    public static final String GPLFCTYPE = 'GPL';
    public static final String PARTFCTYPE = 'Part';
    public static final String RELAYFCTYPE = 'Relay';
    public static final String RELAYPRODUCTCODEFCTYPE = 'Relay Product Code';
    //********************************* -=BEGIN public methods=- **********************************
    /**
    * This method is used get account hierarchy for current account manager.
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
    public static void getAcctTotalFCQuery(String managerId, ClsAPLEntityTypes.PageConfig pageConf, list<ClsAPLEntityTypes.TotalFCViewFields> list_totalFC) {
        if(pageConf.currentTerritoryCode == '') {
            return ;
        }
        String query = ' Select Fiscal_Year__c year, sum(Forecast_10000__c) fc, Fiscal_Quarter__c quarter ';
        query += ' FROM APL_Sales_Forecast__c ';
        query += ' WHERE Customer__r.Relay_Specialist_Territory_Code__c = \'' + pageConf.currentTerritoryCode + '\'';
        query += ' And Customer__r.Active__c = true';
        String monthFilter = ClsAPLForecastUtil.getMonthFilter(pageConf.map_year_quartersFuture);
        query += (monthFilter == '' ? '' :  monthFilter);
        
        String relay_query = query + ' And Type__c = \'' + RELAYPRODUCTCODEFCTYPE + '\' ' 
                           //+ ClsAPLForecastUtil.getRelayPartQuery()
                           + ' Group by Fiscal_Year__c, Fiscal_Quarter__c ';
                           
        ClsAPLEntityTypes.TotalFCViewFields showTotal = new ClsAPLEntityTypes.TotalFCViewFields(' trt_0 trt_trt col ');
        showTotal.fieldName= system.label.APL_Show_Total;                  
        ClsAPLEntityTypes.TotalFCViewFields relayFC = new ClsAPLEntityTypes.TotalFCViewFields(' trt_0 dn relayfctotal ');
        relayFC.fieldName = system.label.APL_Relay_Products;
        system.debug('relay_query::: '+relay_query);
        for(AggregateResult  result : database.query(relay_query)) {
            String parentId = 'Relay';
            String year = (String) result.get('year');
            String quarter = (String) result.get('quarter');
            String dateKey = year + '_' + quarter;
            //build account forecast date map
            relayFC = (ClsAPLEntityTypes.TotalFCViewFields) relayFC.assignFCValues(relayFC, result, dateKey);
        }
        system.debug('relayFC::: '+relayFC);
        //set value = 0 if no result from system
        for(String year : pageConf.map_year_quartersFuture.keySet()) {
            for(String quarter : pageConf.map_year_quartersFuture.get(year)) {
                String dateKey = year + '_' + quarter;
                //check tcFC
                if(!relayFC.map_currentFC.containsKey(dateKey)) {
                    relayFC.map_currentFC.put(dateKey, 0);
                }
                
            }
        }
        relayFC.currentFC = Json.serialize(relayFC.map_currentFC);
        list_totalFC.add(showTotal);
        list_totalFC.add(relayFC);
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
    public static void getAcctInfo(String managerId, ClsAPLEntityTypes.PageConfig pageConf, 
                                    list<ClsGroupingAMForecastUtil.AcctForecastItem> list_acctFC,
                                    list<ClsGroupingAMForecastUtil.AcctForecastItem> list_otherFC) {
        
        map<String, String> map_acctId_currencyIso = new map<String, String>();
        String query = getAccountQuery(managerId, pageConf);
        if(query == '') {
            return;        
        }
        system.debug('query:::: '+query);  
        ClsGroupingAMForecastUtil.AcctForecastItem otherAcctGroup;
        for(AggregateResult result : database.query(query)) {
            String parentId = (String) ((result.get('ParentAcctId') == null || result.get('ParentAcctId') == '') ? OTHER : result.get('ParentAcctId'));
            String displayName = (String) ((result.get('DisplayName') == null || result.get('DisplayName') == '') ? '' : result.get('DisplayName'));
            String currencyIsoCode = (String) result.get('CurrencyCode');            
            decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, currencyIsoCode, 'USD');
            system.debug('pageConf.currencyPlaces::: '+pageConf.currencyPlaces);
            //currencyRate = currencyRate.setScale((pageConf.currencyPlaces == '' ? 4 : Integer.valueOf(pageConf.currencyPlaces)));
            system.debug(': '+currencyRate);
            ClsGroupingAMForecastUtil.AcctForecastItem groupAcct = new ClsGroupingAMForecastUtil.AcctForecastItem();
            groupAcct.acctName = displayName;
            groupAcct.acctISOCode = currencyIsoCode;
            groupAcct.currencyRate = currencyRate;
            groupAcct.parentId = parentId; 
            system.debug('parentId::: '+parentId);  
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'parentId :: ' + parentId));
            if(parentId == OTHER) {
                otherAcctGroup = new ClsGroupingAMForecastUtil.AcctForecastItem();
                otherAcctGroup = groupAcct;
                otherAcctGroup.acctName = OTHER;
                otherAcctGroup.acctISOCode = 'USD';
                otherAcctGroup.currencyRate = 1;
                
            }
            else {             
                list_acctFC.add(groupAcct);
            }
            pageConf.set_parentIds.add(parentId);
            if(!map_acctId_currencyIso.containsKey(parentId)) {
                map_acctId_currencyIso.put(parentId, currencyIsoCode);
            }
        }
        pageConf.json_acctCurrency = json.serialize(map_acctId_currencyIso);
        //Add other account group as last
        /*
        if(otherAcctGroup != null) {
            list_otherFC.add(otherAcctGroup);
        }
        */
        system.debug('list_otherFC::: '+list_otherFC);
        system.debug('list_acctFC::: '+list_acctFC);
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
    public static String getAccountQuery(String managerId, ClsAPLEntityTypes.PageConfig pageConf){
        system.debug('pageConf::: '+pageConf);
        if(pageConf.currentTerritoryCode == null || pageConf.currentTerritoryCode == '') {
            for(APL_Forecast_Management__c forecastManager : [Select Id, A6_Code__c, Manager__c, RecordType.DeveloperName
                                                              From APL_Forecast_Management__c
                                                              Where Manager__c = : managerId 
                                                              And A6_Code__c != null 
                                                              And RecordType.DeveloperName = 'Relay' 
                                                              limit 1 ]) {
                pageConf.isRelay = true;
                pageConf.currentTerritoryCode = forecastManager.A6_Code__c;              
            }
        }
        String query = ' Select APL_Relay_forecast_Plan_Account__c ParentAcctId, APL_Relay_Display_Name__c DisplayName, APL_Relay_Currency__c CurrencyCode ';
        query += ' FROM Account ';
        query += ' WHERE Relay_Specialist_Territory_Code__c= \'' + pageConf.currentTerritoryCode + '\' And APL_Relay_forecast_Plan_Account__c != null ';
        query += ' And STATDESC__c = \'Active\' ';
        query += ' Group by APL_Relay_forecast_Plan_Account__c, APL_Relay_Display_Name__c, APL_Relay_Currency__c ';
        
        return query;
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
    public static void getAcctForecast(String managerId, ClsAPLEntityTypes.PageConfig pageConf, map<String, ClsGroupingRelayForecastUtil.RelayForecastViewFields> map_acctGroupId_fcViewObj) {
        
        map<String, map<String, AggregateResult>> map_acctId_map_dateKey_fcObj = new map<String, map<String, AggregateResult>>();
        map<String, String> map_acctId_currencyIso = new map<String, String>();
        map_acctId_currencyIso = (map<String, String>) Json.deserialize(pageConf.json_acctCurrency, map<String, String>.class);

        //get account forecast query
        String query = getAccountFCQuery(managerId, pageConf);
        if(query == '') {
            return;
        }
        system.debug('query::: '+query);
        for(AggregateResult  result : database.query(query)) {
            String parentId = (String) (result.get('parentId') == null ? OTHER : result.get('parentId'));
            String year = (String) result.get('year');
            String quarter = (String) result.get('quarter');
            String dateKey = year + '_' + quarter;
            //build account forecast date map
            if(!map_acctId_map_dateKey_fcObj.containsKey(parentId)) {
                map_acctId_map_dateKey_fcObj.put(parentId, new map<String, AggregateResult>());
            }
            if(!map_acctId_map_dateKey_fcObj.get(parentId).containsKey(dateKey)) {
                map_acctId_map_dateKey_fcObj.get(parentId).put(dateKey, result);
            }
        }
        system.debug('pageConf.set_parentIds::: '+pageConf.set_parentIds);
        //loop for each future quarter and build forecast view object
        for(String year : pageConf.map_year_quartersFuture.keySet()) {
            for(String quarter : pageConf.map_year_quartersFuture.get(year)) {
                String dateKey = year + '_' + quarter;
                for(String parentId : pageConf.set_parentIds) {
                    decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, map_acctId_currencyIso.get(parentId), 'USD');
                    //currencyRate = currencyRate.setScale(4, System.Roundingmode.HALF_UP);
                    system.debug('currencyRate:: '+currencyRate);
                    //system.debug('currencyRate::: '+currencyRate);
                    //create fc view object for each group
                    if(!map_acctGroupId_fcViewObj.containsKey(parentId)) {
                        map_acctGroupId_fcViewObj.put(parentId, new RelayForecastViewFields());
                    }
                    //assign values for forecast view objects
                    //get related fc view object
                    RelayForecastViewFields obj = map_acctGroupId_fcViewObj.get(parentId);
                    //get related query data
                    AggregateResult result;
                    if(map_acctId_map_dateKey_fcObj.containsKey(parentId) && map_acctId_map_dateKey_fcObj.get(parentId).containsKey(dateKey)) {
                        result = map_acctId_map_dateKey_fcObj.get(parentId).get(dateKey);
                    }
                    obj = (RelayForecastViewFields) obj.assignFCValues(obj, result, dateKey, currencyRate);
                    //assignValuesForFCViewOjb(obj, result, dateKey);
                }
            }
        }
        for(String acctGroupId : map_acctGroupId_fcViewObj.keySet()) {
            RelayForecastViewFields fcObj = map_acctGroupId_fcViewObj.get(acctGroupId);
            for(String dateKey : fcObj.currentFCObj.keySet()) { 
                /*              
                fcObj.currentFC.put(dateKey, JSON.serialize(fcObj.currentFCObj.get(dateKey)));
                fcObj.previousFC.put(dateKey, JSON.serialize(fcObj.previousFCObj.get(dateKey)));
                */
                fcObj.rsmFC.put(dateKey, fcObj.rsmFC.get(dateKey));
                fcObj.currentFC.put(dateKey, fcObj.currentFC.get(dateKey));
                fcObj.previousFC.put(dateKey, fcObj.previousFC.get(dateKey));
            }
        }
        system.debug('map_acctGroupId_fcViewObj:::'+map_acctGroupId_fcViewObj);
    }
    
   /**
    * This method is used get account hierarchy for current account manager.
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
    public static String getAccountFCQuery(String managerId, ClsAPLEntityTypes.PageConfig pageConf) {
        if(pageConf.currentTerritoryCode == '') {
            return '';
        }
        String query = ' Select Fiscal_Year__c year, sum(Forecast_10000__c) fc, sum(Current_month_1_forecast__c) preFc, sum(Quantity__c) quantity, sum(Current_month_1_quantity__c) preQuantity, '//sum(CMA_Forecast__c) cmaFC, '
                     + ' Fiscal_Quarter__c quarter, sum(Current_month_1_RSM_forecast__c) rsmFc,'
                     + ' Customer__r.APL_Relay_forecast_Plan_Account__c parentId, Customer__r.APL_Relay_Currency__c currency ';
        query += ' FROM APL_Sales_Forecast__c ';
        query += ' WHERE Customer__r.Relay_Specialist_Territory_Code__c= \'' + pageConf.currentTerritoryCode + '\'';
        query += ' And Type__c = \'' + RELAYPRODUCTCODEFCTYPE + '\' ';
        query += ' And Customer__r.STATDESC__c = \'Active\' ';        
        query += ClsAPLForecastUtil.getMonthFilter(pageConf.map_year_quartersFuture);
        query += ' Group by Customer__r.APL_Relay_forecast_Plan_Account__c, Customer__r.APL_Relay_Currency__c, Fiscal_Year__c, Fiscal_Quarter__c ';
        
        return query;
    }
    
   /**
    * This method is used to get GPLs for CBC2
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
    /*
    public static String getRelayGPLQuery(boolean isProdHierchary) {
        String str_relayQuery = 'And ( TEMP ) ';
        String tempQuery = '';
        for(String cbcField : map_RELAY_CBCFIELD_CBCDESC.keySet()) {
            for(String cbcName : map_RELAY_CBCFIELD_CBCDESC.get(cbcField)) {
                tempQuery += ((isProdHierchary ? '' : 'GPL__r.') + cbcField + ' = \'' + cbcName + '\' OR '); 
            }
        }
        tempQuery = tempQuery.removeEnd('OR ');
        str_relayQuery = str_relayQuery.replace('TEMP', tempQuery);
        return str_relayQuery;
    }
    */
    /**
    * This method is used to get CBC2 for RelayForcast
    *
    @author Lili Zhao
    @created 2014-05-29
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-05-29 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    //public static void getCBC2FCForRelay(String parentId, String territoryCode, map<String, String> map_cbcRowKey_cbcFC, boolean temp, map<String, set<String>> map_year_quartersFuture, map<String, set<Integer>> map_year_monthsHistory, String refStartDate, String refEndDate, map<String, set<Integer>> map_year_monthsFuture){
    public static void getCBC2FCForRelay(CtrlGroupingRemoteBase.CBC2Forecast cbc_fc){        
        system.debug('cbc_fc::: '+cbc_fc);
        map<String, String> map_cbc2Name_cbcRowKey = new map<String, String>();
        map<String, map<String, list<AggregateResult>>> map_cbcName_map_dateKey_list_result = new map<String, map<String, list<AggregateResult>>>();
        map<String, RelayFCCBCViewFields > map_cbc2RowKey_fcCBCViewObj = new map<String, RelayFCCBCViewFields >();
        //map<String, set<Integer>> map_fiscalMonth = ClsAPLForecastUtil.getFiscalMonthMap(cbcFCInfo.list_dateKey);
        String query = getCBC2FCQueryForRelay(cbc_fc.aid, cbc_fc.territoryCode, cbc_fc.map_year);
        decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, cbc_fc.map_acctId_currencyIso.get(cbc_fc.aid), 'USD');
        //currencyRate = currencyRate.setScale(4, System.Roundingmode.HALF_UP);
        system.debug('currencyRate:: '+currencyRate);
        if(cbc_fc.map_cbcName.isEmpty() || cbc_fc.map_cbcName == null) {
            return;
        }
        system.debug('query::: '+query);
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(query)) {
            String cbcKeyName = (String) result.get('cbc2Name');
            //String cbc3Name = (String) result.get('cbc3Name');
            //String cbcKeyName = getCBCKeyName(cbc2Name, cbc3Name);            
            String year = (String) result.get('year');
            String quarter = (String) result.get('quarter');
            String dateKey = year + '_' + quarter;
            system.debug('cbcKeyName::: '+cbcKeyName);
            if(!map_cbcName_map_dateKey_list_result.containsKey(cbcKeyName)) {
                map_cbcName_map_dateKey_list_result.put(cbcKeyName, new map<String, list<AggregateResult>>());
            }
            if(!map_cbcName_map_dateKey_list_result.get(cbcKeyName).containsKey(dateKey)) {
                map_cbcName_map_dateKey_list_result.get(cbcKeyName).put(dateKey, new list<AggregateResult>());
            }
            map_cbcName_map_dateKey_list_result.get(cbcKeyName).get(dateKey).add(result);
        }
        system.debug('map_cbcName_map_dateKey_list_result::: '+map_cbcName_map_dateKey_list_result);
        //generate forecast view objects for each quarter
        for(String cbcRowKey : cbc_fc.map_cbcName.keySet()) {
            String cbcName = cbc_fc.map_cbcName.get(cbcRowKey);
            for(String year : cbc_fc.map_year.keySet()) {
                for(String quarter : cbc_fc.map_year.get(year)) {
                    String dateKey = year + '_' + quarter;
                    list<AggregateResult> list_result = new list<AggregateResult>();
                    if(map_cbcName_map_dateKey_list_result.containsKey(cbcName) && map_cbcName_map_dateKey_list_result.get(cbcName).containsKey(dateKey)) {
                        list_result = map_cbcName_map_dateKey_list_result.get(cbcName).get(dateKey);
                    }
                    if(!map_cbc2RowKey_fcCBCViewObj.containsKey(cbcName)) {
                        map_cbc2RowKey_fcCBCViewObj.put(cbcName, new RelayFCCBCViewFields());
                    }
                    RelayFCCBCViewFields fcObj = map_cbc2RowKey_fcCBCViewObj.get(cbcName);
                    if(list_result.size() > 0) {
                        for(AggregateResult resultView : list_result) {                     
                            fcObj = (RelayFCCBCViewFields)fcObj.assignFCCurrentValues(fcObj, resultView, dateKey, currencyRate);
                        }
                    }else {
                        AggregateResult resultObj;
                        fcObj = (RelayFCCBCViewFields)fcObj.assignFCCurrentValues(fcObj, resultObj, dateKey, currencyRate);                     
                    }
                                        
                }
            }
        }
           
        //Get cbc reference data                 
        
        if(cbc_fc.map_year_monthsHistory != null && !cbc_fc.map_year_monthsHistory.isEmpty()) {
            getCBCHistoryRefData(cbc_fc.aid, cbc_fc.territoryCode, currencyRate, cbc_fc.map_cbcName, cbc_fc.map_year_monthsHistory, map_cbc2RowKey_fcCBCViewObj);                           
            getCBCHistoryRefBacklogData(cbc_fc.aid, cbc_fc.territoryCode, currencyRate, cbc_fc.map_cbcName, cbc_fc.periodStartDate, cbc_fc.refStartDate, cbc_fc.map_year_monthsHistory,
                            map_cbc2RowKey_fcCBCViewObj);
        }
        
        if(cbc_fc.currentYear != null && cbc_fc.currentMonth != null) {
            getCBCCurrentRefData(cbc_fc.aid, cbc_fc.territoryCode, currencyRate, cbc_fc.map_cbcName, cbc_fc.currentYear, cbc_fc.currentMonth, cbc_fc.map_year_monthsFuture,
                            map_cbc2RowKey_fcCBCViewObj);
        } 
            
        if(cbc_fc.map_year_monthsFuture != null && !cbc_fc.map_year_monthsFuture.isEmpty()) {   
            getCBCFutureRefBacklogData(cbc_fc.aid, cbc_fc.territoryCode, currencyRate, cbc_fc.map_cbcName, cbc_fc.refStartDate, cbc_fc.refEndDate, cbc_fc.map_year_monthsFuture,
                            map_cbc2RowKey_fcCBCViewObj);
        }   
         
        //parser view object into json string bach to front end 
        for(String cbcRowKey : cbc_fc.map_cbcName.keySet()) {
            String cbc2Name = cbc_fc.map_cbcName.get(cbcRowKey);
            if(map_cbc2RowKey_fcCBCViewObj.containsKey(cbc2Name)) {
                String str_json = json.serialize(map_cbc2RowKey_fcCBCViewObj.get(cbc2Name));
                cbc_fc.map_cbcName.put(cbcRowKey, str_json);
            }
        } 
        /*             
        for(String cbc2RowKey : map_cbc2RowKey_fcCBCViewObj.keySet()) {
            String str_json = json.serialize(map_cbc2RowKey_fcCBCViewObj.get(cbc2RowKey));
            cbc_fc.map_cbcName.put(cbc2RowKey, str_json);
        }
        */
        system.debug('cbc_fc.map_cbcName::: '+cbc_fc.map_cbcName);
    }   
    
    /**
    * This method is used to get the CBC2FCQuery for RelayForcast.
    *
    @author Lili Zhao
    @created 2014-05-29
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-05-29 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static String getCBC2FCQueryForRelay(String parentId, String territoryCode, map<String, set<String>> map_year_quartersFuture) {
        
        String query = ' Select Fiscal_Year__c year, sum(Forecast_10000__c) fc, ' // sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC, '
                     + ' sum(Current_month_1_forecast__c) preFc, Fiscal_Quarter__c quarter, sum(Quantity__c) quantity, sum(Current_month_1_quantity__c) preQuantity, Relay_CBC2_Code__c cbc2Name ';             
        query += ' FROM APL_Sales_Forecast__c ';
        query += ' WHERE Id != null ';
        //query +=  getRelayCBCQuery();
        query += ClsAPLForecastUtil.getMonthFilter(map_year_quartersFuture);
        query += ' And Customer__r.STATDESC__c = \'Active\' ';   
        String str_filter = getForecastParentFilter(parentId, territoryCode, false);
        str_filter += ' And Type__c = \'' + RELAYPRODUCTCODEFCTYPE + '\' ';
        String groupby = ' Group by Fiscal_Year__c, Fiscal_Quarter__c, Relay_CBC2_Code__c ' ;
        query += (str_filter + groupby);
        return query;
    }
   /**
    * This method is used to build currency iso map 
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
    public static String getForecastParentFilter(String parentId, String territoryCode, boolean isAcct) {

        String filter = ' And ' + (isAcct ? '' : 'Customer__r.') + 'Relay_Specialist_Territory_Code__c= \'' + territoryCode +'\' And ' + (isAcct ? '' : 'Customer__r.') + (parentId == OTHER ? 
                         'APL_Relay_forecast_Plan_Account__c = null'
                        : 'APL_Relay_forecast_Plan_Account__c = \'' + parentId + '\'');
        
        return filter;
    }
    
    /**
    * This method is used to get the CBC2FCQuery for RelayForcast.
    *
    @author Lili Zhao
    @created 2014-05-29
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-05-29 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static String getCBCKeyName(String cbc2Name, String cbc3Name) {
        if(map_RELAY_CBCFIELD_CBCDESC.get('CBC2__c').contains(cbc2Name)) {
            return cbc2Name;
        }else {
            return cbc3Name;
        }
    }
    
    /**
    * This method is used to get the CBC2FCQuery for RelayForcast.
    *
    @author Lili Zhao
    @created 2014-05-29
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-05-29 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    /*
    public static String getRelayField(String cbcCode) {
        for(String field : map_RELAY_CBCFIELD_CBCDESC.keySet()) {
            if(map_RELAY_CBCFIELD_CBCDESC.get(field).contains(cbcCode)) {
                return field;
            }
        }
        return '';
    }
    */
    /**
    * This method is used to get the CBC2 for RelayForcast.
    *
    @author Lili Zhao
    @created 2014-05-29
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-05-29 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static String getRelayCBCQuery() {
        String str_partQuery = 'And ( TEMP ) ';
        String tempQuery = '';
        for(String cbcField : map_RELAY_CBCFIELD_CBCDESC.keySet()) {
            for(String cbcName : map_RELAY_CBCFIELD_CBCDESC.get(cbcField)) {
                tempQuery += 'Part__r.Product_Hierarchy__r.' + cbcField + ' = \'' + cbcName + '\' OR '; 
            }
        }
        tempQuery = tempQuery.removeEnd('OR ');
        str_partQuery = str_partQuery.replace('TEMP', tempQuery);
        return str_partQuery;
    }
    
    /**
    * This method is used to get Relay Product Code for CBC2
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
    public static String getRelayProductCodeFC(CtrlGroupingRemoteBase.PartInfo part) {      
        system.debug('part::: '+part);
        map<String, PartViewFields> map_partId_fcViewObj = new map<String, PartViewFields>();
        String query = getPartFCQuery(part.aid, part.cbc2Name, part.territoryCode, part.map_year);
        map<String, map<String, AggregateResult>> map_partId_map_dateKey_result = new map<String, map<String, AggregateResult>>();
        map<String, String> map_partId_partName = new map<String, String>();
        map<String, PartFCObect> map_partId_partObj = new map<String, PartFCObect>();        
        map<String, decimal> map_partId_price = new map<String, decimal>();
        set<String> set_highLightParts = new set<String>();
        decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, part.map_acctId_currencyIso.get(part.aid), 'USD');
        //currencyRate = currencyRate.setScale(4, System.Roundingmode.HALF_UP);
        system.debug('query::: '+query);
        //get all high light parts
        getPartHighlight(part.aid, part.cbc2Name, part.territoryCode, part.map_year, set_highLightParts);        
        setPartFCQueryResult(query, map_partId_map_dateKey_result, map_partId_partObj);
        // set the part name as part id 
        //setMapPartIdName(map_partId_partName); //added lili zhao 2014-07-25
        // set the price of APL_Sales_Forecast__c as the part id
        setMapPartIdPrice(map_partId_partObj, map_partId_price, part);
        for(String partId : map_partId_partObj.keySet()) {
            for(String year : part.map_year.keySet()) {
                for(String quarter : part.map_year.get(year)) {
                    String dateKey = year + '_' + quarter;
                    AggregateResult result;
                    if(map_partId_map_dateKey_result.containsKey(partId) && map_partId_map_dateKey_result.get(partId).containsKey(dateKey)) {
                        result = map_partId_map_dateKey_result.get(partId).get(dateKey);
                    }
                    if(!map_partId_fcViewObj.containsKey(partId)) {
                        PartViewFields partFC = new PartViewFields();
                        partFC.partId = partId;
                        
                        if(map_partId_price.containsKey(partId)) {
                            partFC.price = map_partId_price.get(partId);
                        }
                        partFC.fieldName = map_partId_partObj.get(partId).name;
                        partFC.gplId = map_partId_partObj.get(partId).gplId;
                        map_partId_fcViewObj.put(partId, partFC);
                    }
                    PartViewFields obj = map_partId_fcViewObj.get(partId);
                    obj = (PartViewFields) obj.assignFCValues(obj, result, dateKey, currencyRate);
                    
                    if(set_highLightParts.contains(obj.partId)) {
                        obj.isHighLighted = true;
                    }
                }
            }
        }
         //Get cbc reference data 
        if(part.map_year_monthsHistory != null && !part.map_year_monthsHistory.isEmpty()) {
            getPartHistoryRefData(part.cbc2Name, part.aid, currencyRate,part.territoryCode, part.map_year_monthsHistory, map_partId_fcViewObj); 
            
            getPartHistoryRefBacklogData(part.cbc2Name, part.aid, currencyRate, part.territoryCode, part.periodStartDate, part.refStartDate, part.map_year_monthsHistory,
                            map_partId_fcViewObj);
              
        }
        
        if(part.currentYear != null && part.currentMonth != null) {
            getPartCurrentRefData(part.cbc2Name, part.aid, currencyRate, part.territoryCode, part.currentYear, part.currentMonth, part.map_year_monthsFuture,
                            map_partId_fcViewObj);
        }
        
        if(part.map_year_monthsFuture != null && !part.map_year_monthsFuture.isEmpty()) {
            
            getPartFutureRefData(part.cbc2Name, part.aid, currencyRate, part.territoryCode, part.refStartDate, part.refEndDate, part.map_year_monthsFuture,
                            map_partId_fcViewObj);
        }
        
        //parser view object into json string bach to front end
        system.debug('map_partId_fcViewObj.values()::: '+map_partId_fcViewObj.values());
        return json.serialize(map_partId_fcViewObj.values());
    }
    
    
    
    /**
    * This method is used get account hierarchy for current account manager.
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
    public static String getRelayProductCodeFCQuery(String parentId, String gplId, String territoryCode, map<String, set<String>> map_year_quartersFuture) {
        
        String query = ' Select Fiscal_Year__c year, Fiscal_Quarter__c quarter, Part__c partId, Part__r.Product_Hierarchy__c gplId, Part__r.Description__c partDesc, Part__r.Name partName, ';
        query += ' sum(Quantity__c) quantity, sum(Current_month_1_quantity__c) preQuantity ';
        //query += ' ,AVG(Price__c) price, AVG(Current_month_1_price__c) prePrice ';
        query += ' FROM APL_Sales_Forecast__c ';
        query += ' WHERE Id != null ';
        query += ' And Customer__r.STATDESC__c = \'Active\' ';   
        query += getRelayPartSearchQueryFilter(gplId, true);
        query += ClsAPLForecastUtil.getMonthFilter(map_year_quartersFuture);
        
        String str_filter = getForecastParentFilter(parentId, territoryCode, false);
        str_filter += ' And Type__c = \'' + RELAYFCTYPE + '\'';
        String str_groupby = ' Group by Part__c, Fiscal_Year__c, Fiscal_Quarter__c, Part__r.Product_Hierarchy__c, Part__r.Description__c, Part__r.Name' ;
        
        query += (str_filter + str_groupby);
        
        return query;
    }
    
    
    /**
    * This method is used to get Parts for CBC2
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
    public static String getPartFC(CtrlGroupingRemoteBase.PartInfo part) {      
        system.debug('part::: '+part);
        map<String, PartViewFields> map_partId_fcViewObj = new map<String, PartViewFields>();
        String query = getPartFCQuery(part.aid, part.cbc2Name, part.territoryCode, part.map_year);
        map<String, map<String, AggregateResult>> map_partId_map_dateKey_result = new map<String, map<String, AggregateResult>>();
        map<String, String> map_partId_partName = new map<String, String>();
        map<String, PartFCObect> map_partId_partObj = new map<String, PartFCObect>();        
        map<String, decimal> map_partId_price = new map<String, decimal>();
        set<String> set_highLightParts = new set<String>();
        decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, part.map_acctId_currencyIso.get(part.aid), 'USD');
        //currencyRate = currencyRate.setScale(4, System.Roundingmode.HALF_UP);
        system.debug('query::: '+query);
        //get all high light parts
        getPartHighlight(part.aid, part.cbc2Name, part.territoryCode, part.map_year, set_highLightParts);        
        setPartFCQueryResult(query, map_partId_map_dateKey_result, map_partId_partObj);
        // set the part name as part id 
        //setMapPartIdName(map_partId_partName); //added lili zhao 2014-07-25
        // set the price of APL_Sales_Forecast__c as the part id
        setMapPartIdPrice(map_partId_partObj, map_partId_price, part);
        for(String partId : map_partId_partObj.keySet()) {
            for(String year : part.map_year.keySet()) {
                for(String quarter : part.map_year.get(year)) {
                    String dateKey = year + '_' + quarter;
                    AggregateResult result;
                    if(map_partId_map_dateKey_result.containsKey(partId) && map_partId_map_dateKey_result.get(partId).containsKey(dateKey)) {
                        result = map_partId_map_dateKey_result.get(partId).get(dateKey);
                    }
                    if(!map_partId_fcViewObj.containsKey(partId)) {
                        PartViewFields partFC = new PartViewFields();
                        partFC.partId = partId;
                        
                        if(map_partId_price.containsKey(partId)) {
                            partFC.price = map_partId_price.get(partId);
                        }
                        partFC.fieldName = map_partId_partObj.get(partId).name;
                        partFC.gplId = map_partId_partObj.get(partId).gplId;
                        map_partId_fcViewObj.put(partId, partFC);
                    }
                    PartViewFields obj = map_partId_fcViewObj.get(partId);
                    obj = (PartViewFields) obj.assignFCValues(obj, result, dateKey, currencyRate);
                    
                    if(set_highLightParts.contains(obj.partId)) {
                        obj.isHighLighted = true;
                    }
                }
            }
        }
         //Get cbc reference data 
        if(part.map_year_monthsHistory != null && !part.map_year_monthsHistory.isEmpty()) {
            getPartHistoryRefData(part.cbc2Name, part.aid, currencyRate,part.territoryCode, part.map_year_monthsHistory, map_partId_fcViewObj); 
            
            getPartHistoryRefBacklogData(part.cbc2Name, part.aid, currencyRate, part.territoryCode, part.periodStartDate, part.refStartDate, part.map_year_monthsHistory,
                            map_partId_fcViewObj);
              
        }
        
        if(part.currentYear != null && part.currentMonth != null) {
            getPartCurrentRefData(part.cbc2Name, part.aid, currencyRate, part.territoryCode, part.currentYear, part.currentMonth, part.map_year_monthsFuture,
                            map_partId_fcViewObj);
        }
        
        if(part.map_year_monthsFuture != null && !part.map_year_monthsFuture.isEmpty()) {
            
            getPartFutureRefData(part.cbc2Name, part.aid, currencyRate, part.territoryCode, part.refStartDate, part.refEndDate, part.map_year_monthsFuture,
                            map_partId_fcViewObj);
        }
        
        //parser view object into json string bach to front end
        system.debug('map_partId_fcViewObj.values()::: '+map_partId_fcViewObj.values());
        return json.serialize(map_partId_fcViewObj.values());
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
    public static String getPartRefDataForAdd(CtrlGroupingRemoteBase.PartInfo part) {
        system.debug('part:::: '+part);
        map<String, PartViewFields> map_partId_fcViewObj = new map<String, PartViewFields>();
        decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, part.map_acctId_currencyIso.get(part.aid), 'USD');
        //if part ids is null return null
        if(part.set_partIds == null || part.set_partIds.isEmpty()) {
            return '';
        }
        for(String partId : part.set_partIds) {
            map_partId_fcViewObj.put(partId, new PartViewFields());
        }
        //Get part reference data 
        
        if(part.map_year_monthsHistory != null && !part.map_year_monthsHistory.isEmpty()) {
            getPartHistoryRefData(part.cbc2Name, part.aid, currencyRate,part.territoryCode, part.map_year_monthsHistory, map_partId_fcViewObj);   
            system.debug('map_partId_fcViewObj:::: '+map_partId_fcViewObj);
            
            getPartHistoryRefBacklogData(part.cbc2Name, part.aid, currencyRate, part.territoryCode, part.periodStartDate, part.refStartDate, part.map_year_monthsHistory,
                            map_partId_fcViewObj);
            system.debug('map_partId_fcViewObj:::: '+map_partId_fcViewObj);
        }
        
        if(part.currentYear != null && part.currentMonth != null) {
            getPartCurrentRefData(part.cbc2Name, part.aid, currencyRate, part.territoryCode, part.currentYear, part.currentMonth, part.map_year_monthsFuture,
                            map_partId_fcViewObj);
        }
        
        if(part.refStartDate != null && part.refEndDate != null) {
            getPartFutureRefData(part.cbc2Name, part.aid, currencyRate, part.territoryCode, part.refStartDate, part.refEndDate, part.map_year_monthsFuture,
                            map_partId_fcViewObj);
            system.debug('map_partId_fcViewObj:::: '+map_partId_fcViewObj);        
        }
        
        return json.serialize(map_partId_fcViewObj.values());
    }

    /**
    * This method is used get account hierarchy for current account manager.
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
    
    public static void setPartFCQueryResult(String query, map<String, map<String, AggregateResult>> map_partId_map_dateKey_result, map<String, PartFCObect> map_partId_partObj) {
        for(AggregateResult result : database.query(query)) {
            String partId = (String) result.get('partId');
            String partName = (String) result.get('partName');
            String gplId = (String) result.get('gplId');
            String year = (String) result.get('year');
            String quarter = (String) result.get('quarter');
            String dateKey = year + '_' + quarter;
            if(!map_partId_map_dateKey_result.containsKey(partId)) {
                map_partId_map_dateKey_result.put(partId, new map<String, AggregateResult>());
            }
            if(!map_partId_map_dateKey_result.get(partId).containsKey(dateKey)) {
                map_partId_map_dateKey_result.get(partId).put(dateKey, result);
            }
            PartFCObect partFc = new PartFCObect();
            partFc.name = partName;
            partFc.gplId = gplId;
            map_partId_partObj.put(partId, partFc);
        }
    }

    /**
    * This method is used get account hierarchy for current account manager.
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
    public static void setMapPartIdName(map<String, String> map_partId_partName) {
        if(!map_partId_partName.isEmpty()) {
            for(Part__c part : [select Id, Name From Part__c where Id in : map_partId_partName.keySet()]) {
                if(part.Name != null) {
                    map_partId_partName.put(part.Id, part.Name);
                }
            }
        }
    }
    /**
    * This method is used to get the QueryFilter as the other
    *
    @author Lili Zhao
    @created 2014-05-15
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-05-15 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static void setMapPartIdPrice(map<String, PartFCObect> map_partId_partObj, map<String, decimal> map_partId_price, CtrlGroupingRemoteBase.PartInfo part) {
        set<String> set_partIds = new set<String>();  
        if(!map_partId_partObj.isEmpty()) {      
            set_partIds.addAll(map_partId_partObj.keyset());
            String query = ' Select Part__c, Price__c, Current_month_1_price__c ';
            query += ' FROM APL_Sales_Forecast__c ';
            query += ' WHERE Id != null ';          
            query += ' And Part__c IN : set_partIds '; 
            query += ' And Customer__r.STATDESC__c = \'Active\' ';          
            query += getRelayPartSearchQueryFilter(part.cbc2Name, true);
            query += ClsAPLForecastUtil.getMonthFilter(part.map_year);          
            query += getForecastParentFilter(part.aid, part.territoryCode, false);
            query += ' And Type__c = \'' + RELAYFCTYPE + '\'';
            system.debug('query::: '+query);
            for(APL_Sales_Forecast__c fc  : database.query(query)) {                
                map_partId_price.put(fc.Part__c, fc.Price__c);
            }
            
        }
        
        
    }

    /**
    * This method is used get account hierarchy for current account manager.
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
    public static String getPartFCQuery(String parentId, String gplId, String territoryCode, map<String, set<String>> map_year_quartersFuture) {
        
        String query = ' Select Fiscal_Year__c year, Fiscal_Quarter__c quarter, Part__c partId, Part__r.Product_Hierarchy__c gplId, Part__r.Description__c partDesc, Part__r.Name partName, ';
        query += ' sum(Quantity__c) quantity, sum(Current_month_1_quantity__c) preQuantity ';
        //query += ' ,AVG(Price__c) price, AVG(Current_month_1_price__c) prePrice ';
        query += ' FROM APL_Sales_Forecast__c ';
        query += ' WHERE Id != null ';
        query += ' And Customer__r.STATDESC__c = \'Active\' ';   
        query += getRelayPartSearchQueryFilter(gplId, true);
        query += ClsAPLForecastUtil.getMonthFilter(map_year_quartersFuture);
        
        String str_filter = getForecastParentFilter(parentId, territoryCode, false);
        str_filter += ' And Type__c = \'' + RELAYFCTYPE + '\'';
        String str_groupby = ' Group by Part__c, Fiscal_Year__c, Fiscal_Quarter__c, Part__r.Product_Hierarchy__c, Part__r.Description__c, Part__r.Name' ;
        
        query += (str_filter + str_groupby);
        
        return query;
    }
    /**
    * This method is used to get the part query for relay
    *
    @author Lili Zhao
    @created 2014-06-03
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-03 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static String getRelayPartSearchQueryFilter(String gplId, boolean isForecast) {
        String filter = '';
        filter += ' And '+(isForecast ? 'Part__r.' : '' ) + 'Product_Hierarchy__r.' + getRelayField(gplId) + ' = \'' + gplId + '\' ';
        
        return filter;
    }
    /**
    * This method is used to get the part filed for relay
    *
    @author Lili Zhao
    @created 2014-06-03
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-03 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static String getRelayField(String gplId) {
        String relayField = '';
        for(String cbcField : map_RELAY_CBCFIELD_CBCDESC.keySet()) {
            if(map_RELAY_CBCFIELD_CBCDESC.get(cbcField).contains(gplId)) {
                relayField = cbcField;
                return relayField;
            }           
        }  
        return relayField;
    }
    
    /**
    * This method is used to search the part filed for relay
    *
    @author Lili Zhao
    @created 2014-06-03
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-03 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */  
    public static void addPart(String parentId, String cbcCode, String territoryCode,String partName, String quarterNumb,
                                boolean isTop, 
                                list<RelayPartObj> list_parts, 
                                map<String, set<String>> map_year_quartersFuture, boolean temp, set<String> set_newAddedpartIds) {
        if(isTop == null) {
            isTop = false;
        }
        //only get current fc to check if this part has forecast
        map_year_quartersFuture = new map<String, set<String>>();
        String currentYearQuart = ClsAPLForecastUtil.getCurrentYearQuart();
        String year = currentYearQuart.substringBefore('_');
        String quarter = currentYearQuart.substringAfter('_');
        system.debug('currentYearQuart :: ' + currentYearQuart);
        map_year_quartersFuture.put(year, new set<String>{quarter});
        
        system.debug('set_newAddedpartIds:::'+set_newAddedpartIds);
        if(isTop) {
            map<String, decimal> map_partId_billPercent = new map<String, decimal>();
            //set<String> set_newAddedpartIds = ((json_partIds == null || json_partIds == '') ? new set<String>() : (set<String>) json.deserialize(json_partIds, set<String>.class));
            system.debug('set_newAddedpartIds::: '+set_newAddedpartIds);
            list_parts.addAll(setPartBillPercent(cbcCode, territoryCode, quarterNumb, parentId, map_partId_billPercent, set_newAddedpartIds));
            system.debug('list_parts :: ' + list_parts);
        }
        else {            
            set<String> set_existPartIds = new set<String>();
            //filter part ids for already added parts
            if(!set_newAddedpartIds.isEmpty()) {
                set_existPartIds.addAll(set_newAddedpartIds);
            }
            String existPartIdQuery = getPartHighlightQuery(parentId, cbcCode, territoryCode, map_year_quartersFuture, false);
    		
            setExistPartIds(set_existPartIds, existPartIdQuery);
            system.debug('existPartIdQuery :: ' + existPartIdQuery);
            //set_existPartIds = new set<String>();
            String query = getPartQuery(cbcCode, partName, set_existPartIds);
            setListPartObjs(list_parts, query, set_existPartIds);
        }
        system.debug('list_parts :: ' + list_parts);
    }
    
    
    
    /**
    * This method is used to get the QueryFilter as the other
    *
    @author Lili Zhao
    @created 2014-05-15
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-05-15 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */    
    public static list<RelayPartObj> setPartBillPercent(String cbcCode, String territoryCode, String quarterNumb, String parentId, map<String, decimal> map_partId_billPercent, set<String> set_existingParts) {
        decimal allValue = 0;
        System.debug('-----------------------ClsGroupingRelayForecastUtil1-----------------');
        map<String, decimal> map_partId_amount = new map<String, decimal>();
        //map<String, String> map_partId_gplId = new map<String, String>();
        set<String> existPartIds = new set<String>();
        existPartIds.addAll(set_existingParts);
        // get the query for Part level begin 
        String query = ' select SUM(Bill_Amount_current_prior__c) amount, Part__c key, Part__r.Product_Hierarchy__c gplId '
                     + ' From BBB_Year_Bill_Book_Cust_PN__c '
                     + ' Where Id != null '
                     + ' And Bill_Amount_current_prior__c != null And Bill_Amount_current_prior__c != 0 ' 
                     //update by nelson zheng 2015-10-21 for case 00900375
                     //+' And BU_Profit_Center__c = \'RPA\'  '
                     //+ ' And (BU_Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  '
	                 +' And BU_Profit_Center__c = \'APL\'  '     
	                   
                     + (!existPartIds.isEmpty() ? ' And Part__c not in : existPartIds ' : '');
        query += ' And Customer__r.STATDESC__c = \'Active\' ';   
        query += getForecastParentFilter(parentId, territoryCode, false);
        query += ' And Part__r.Product_Hierarchy__r.' + getRelayField(cbcCode) + ' = \'' + cbcCode + '\' ';
        query += ' group by Part__c, Part__r.Product_Hierarchy__c ';
        // end
        system.debug('--------------ClsGroupingRelayForecastUtil.cls (10 matches) 1-------------------');
        system.debug('query::: '+query);
        system.debug('quarterNumb::: '+quarterNumb);
        // get the part to the amount begin
        for(AggregateResult  result : database.query(query)) {
            //decimal priorAmount = (decimal) (result.get('priorAmount') == null ? 0 : result.get('priorAmount'));
            //decimal tempAmount = (decimal) (result.get('amount') == null ? 0 : result.get('amount'));
            //decimal amount = tempAmount + ((quarterNumb == 'Q1' || quarterNumb == 'Q2') ? priorAmount : 0); 
            decimal amount = (decimal) (result.get('amount') == null ? 0 : result.get('amount'));
            allValue += amount;                                     
            map_partId_amount.put((String)result.get('key'), amount); 
            //map_partId_gplId.put((String)result.get('key'), (String)result.get('gplId')); 
        }
        system.debug('map_partId_amount::: '+map_partId_amount);
        system.debug('allValue::: '+allValue);
        // get the Percent for Part level begin
        setBillPercent(allValue, map_partId_amount, map_partId_billPercent);
        list<RelayPartObj> list_partObj = getPartObj(map_partId_billPercent);
        return list_partObj;
    }
    
    
    
    /**
    * This method is used to get the QueryFilter as the other
    *
    @author Lili Zhao
    @created 2014-05-15
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-05-15 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static void setBillPercent(decimal allValue, map<String, decimal> map_key_amount, map<String, decimal> map_key_billPercent) {        
        
        for(String key : map_key_amount.keySet()) {
            Decimal rate = (allValue == 0 ? 0 : (map_key_amount.get(key) / allValue));
            rate = rate.setScale(4, System.Roundingmode.HALF_UP);
            map_key_billPercent.put(key, rate);
        }
    }
    
    /**
    * This method is used to get the BillPercent as the part
    *
    @author Lili Zhao
    @created 2014-05-13
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-05-13 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static list<RelayPartObj> getPartObj(map<String, decimal> map_partId_billPercent) {
        list<RelayPartObj> list_partObj = new list<RelayPartObj>();
        list<RelayPartObj> list_partObjReturn = new list<RelayPartObj>();
        map<String, String> map_partId_name = new map<String, String>();
        for(Part__c part : [Select Id, Name, Description__c, Product_Hierarchy__c  
                            from Part__c 
                            where Id IN: map_partId_billPercent.keySet()]) {
            RelayPartObj partObj = new RelayPartObj();        
            partObj.partId = part.Id;
            partObj.partName = part.Name;
            partObj.gplId = part.Product_Hierarchy__c;
            partObj.precent = map_partId_billPercent.get(part.Id);
            partObj.description = (part.Description__c == null ? '' : part.Description__c);
            list_partObj.add(partObj);
        }
        system.debug('list_partObj::: '+list_partObj);
        list_partObj.sort();
        system.debug('list_partObj::: '+list_partObj);
        for(Integer m=0; m < list_partObj.size(); m++) {
            list_partObjReturn.add(list_partObj[m]);
            if(m == 4) return list_partObjReturn;
        }
        
        return list_partObjReturn;
    }
    

    /**
    * This method is used get account hierarchy for current account manager.
    *
    @author Lili Zhao
    @created 2014-06-03
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-03 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static String getPartQuery(String gplId, String partName, set<String> set_existPartIds) {
        set<String> set_partIds = new set<String>();
        set_partIds.addAll(set_existPartIds);
        String query = ' Select Id, Name, Description__c, Product_Hierarchy__c ';
        query += ' FROM Part__c ';
        query += ' WHERE Id != null ';        
        query += getRelayPartSearchQueryFilter(gplId, false);
        query += (partName != null ? ' And name like \'%' + partName + '%\' ' : '');
        query += (set_existPartIds.isEmpty() ? '' : ' And Id not in: set_partIds ');
        query += ' limit 200 ';
        return query;
    }
    
    /**
    * This method is used get account hierarchy for current account manager.
    *
    @author Lili Zhao
    @created 2014-06-03
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-03 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static void setListPartObjs(list<RelayPartObj> list_parts, String query, set<String> set_existPartIds) {
        set<String> set_partIds = new set<String>();
        set_partIds.addAll(set_existPartIds);
        for(Part__c part : database.query(query)) {
            RelayPartObj partObj = new RelayPartObj();
            partObj.partId = part.Id;
            partObj.partName = part.Name;
            partObj.gplId = part.Product_Hierarchy__c; 
            partObj.Description = (part.Description__c == null ? '' : part.Description__c);
            list_parts.add(partObj);
        }
    }

    
    /**
    * This method is used get account hierarchy for current account manager.
    *
    @author Lili Zhao
    @created 2014-06-03
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-03 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static void setExistPartIds(set<String> set_existPartIds, String existPartIdQuery) {
        for(AggregateResult result : database.query(existPartIdQuery)) {
            String partId = (String) result.get('partId');
            set_existPartIds.add(partId);
        }
    }
    
   /**
    * This method is used get account hierarchy for current account manager.
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
    public static void getPartHighlight(String parentId, String gplId, String territoryCode, 
                                        map<String, set<String>> map_year_quartersFuture, set<String> set_highLightParts) {
        
        String query = getPartHighlightQuery(parentId, gplId, territoryCode, map_year_quartersFuture, true);
        map<String, set<String>> map_partId_set_acctIds = new map<String, set<String>>();
        Integer minPartCounter = 0;
        for(AggregateResult result : database.query(query)) {
            
            String acctId = (String) result.get('acctId');
            String partId = (String) result.get('partId');
            if(!map_partId_set_acctIds.containsKey(partId)) {
                map_partId_set_acctIds.put(partId, new set<String>());
            }
            map_partId_set_acctIds.get(partId).add(acctId);
        }
        for(String partId : map_partId_set_acctIds.keySet()) {
            if(minPartCounter == 0 && map_partId_set_acctIds.get(partId).size() != 0) {
                minPartCounter = map_partId_set_acctIds.get(partId).size();
            }
            if(minPartCounter != 0 && map_partId_set_acctIds.get(partId).size() < minPartCounter) {
                minPartCounter = map_partId_set_acctIds.get(partId).size();
            }
        }
        if(minPartCounter != 0) {
            for(String partId : map_partId_set_acctIds.keySet()) {
                if(map_partId_set_acctIds.get(partId).size() > minPartCounter) {
                    set_highLightParts.add(partId);
                }
            }
        }
        
    }
    
   /**
    * This method is used get account hierarchy for current account manager.
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
    public static String getPartHighlightQuery(String parentId, String gplId, String territoryCode,
                                               map<String, set<String>> map_year_quartersFuture, boolean isForHighlight) {
        
        String query = ' Select ' + (isForHighlight ? ' Customer__c acctId, Part__c partId ' : ' Part__c partId ');
        query += ' FROM APL_Sales_Forecast__c ';
        query += ' WHERE Id != null ';
        query += ' And Customer__r.STATDESC__c = \'Active\' ';   
        query += getRelayPartSearchQueryFilter(gplId, true);
        query += ClsAPLForecastUtil.getMonthFilter(map_year_quartersFuture);
        
        String str_filter = getForecastParentFilter(parentId, territoryCode, false);
        //str_filter += ' And Type__c = \'' + PARTFCTYPE + '\'';
        str_filter += ' And Type__c = \'' + RELAYFCTYPE + '\'';
        String str_groupby = ' Group by' + (isForHighlight ? ' Customer__c, Part__c ' : ' Part__c ');
        
        query += (str_filter + str_groupby);
        
        return query;
    }
   /**
    * This method is used get account hierarchy for current account manager.
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
    public static String getPartSearchQueryFilter(String gplId, boolean isForecast) {
        String filter = '';
        filter += ' And ' + (isForecast ? 'Part__r.' : '' ) + 'Product_Hierarchy__c = \'' + gplId + '\' ';
        
        return filter;
    }
    /**
    * This method is used to get GPLs for CBC2
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
    public static boolean deletePart(CtrlGroupingRemoteBase.PartInfo part) {
        list<APL_Sales_Forecast__c> list_aplFC = new list<APL_Sales_Forecast__c>();
        String query = ' Select Id From APL_Sales_Forecast__c WHERE Id != null ';
        query += getForecastParentFilter(part.aid, part.territoryCode, false);
        query += ' And Part__c = \'' + part.partId + '\'';
        query += ' And Type__c = \'' + RELAYFCTYPE + '\' ';
        query += ' And Customer__r.STATDESC__c = \'Active\' ';   
        query += ClsAPLForecastUtil.getMonthFilter(part.map_year);
        try {
            for(APL_Sales_Forecast__c fc : database.query(query)) {
                list_aplFC.add(fc);
            }
            if(!list_aplFC.isEmpty()) {
                delete list_aplFC;
            }
            return true;
        }
        catch(Exception ex) {
            return false;
        }
    }
    
    /**
    * This method is used to get GPLs for CBC2
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
    /*
    public static void saveAcctFC(ClsAPLEntityTypes.RelayAcctFCInfo acctFC) {
        map<String, decimal> map_acctId_billingPercent = new map<String, decimal>();
        map<String, map<String, APL_Sales_Forecast__c>> map_acctId_map_dateKey_fc = new map<String, map<String, APL_Sales_Forecast__c>>();
        list<APL_Sales_Forecast__c> list_acctFC2Insert = new list<APL_Sales_Forecast__c>();
        list<APL_Sales_Forecast__c> list_acctFC2Update = new list<APL_Sales_Forecast__c>();
        list<APL_Sales_Forecast__c> list_acctFC2Delete = new list<APL_Sales_Forecast__c>();
        
        //get all children accounts and percent of each account
        getChildAcctPercent(acctFC.parentId, acctFC.territoryCode, acctFC.quarterNumb, map_acctId_billingPercent);
        //get existing account forecast for each children accounts
        getExistingAcctFC(acctFC.parentId, acctFC.territoryCode, acctFC.quarterNumb, acctFC.map_year_quartersFuture, map_acctId_map_dateKey_fc);
        //create or update account forecast records
        generateFC(map_acctId_billingPercent, acctFC.map_dateKey_relayFC, map_acctId_map_dateKey_fc, acctFC.currencyIso,
                    ACCTFCTYPE, '', true, list_acctFC2Insert, list_acctFC2Update, list_acctFC2Delete);
                   
        //INSERT, UPDATE, DELETE APL Forecasts
        ClsAPLForecastUtil.aplFCRecordsDML(list_acctFC2Insert, list_acctFC2Update, list_acctFC2Delete);
    }
    */
    /**
    * This method is used to get the 
    *
    @author Lili Zhao
    @created 2014-05-23
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-05-23 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    /*
    public static void getExistingAcctFC(String parentId, String territoryCode, 
                                        String quartNumb, map<String, set<String>> map_year_quartersFuture, 
                                        map<String, map<String, APL_Sales_Forecast__c>> map_acctId_map_dateKey_fc) {
                                            
        String query = ' Select Id, Customer__c, Fiscal_Quarter__c, Fiscal_Year__c, Forecast_10000__c '
                     + ' From APL_Sales_Forecast__c '
                     + ' Where Type__c = \'' + ACCTFCTYPE + '\' ';
        query += getForecastParentFilter(parentId, territoryCode, false);
        query += ClsAPLForecastUtil.getMonthFilter(map_year_quartersFuture);
        for(APL_Sales_Forecast__c fc : database.query(query)) {
            String dateKey = fc.Fiscal_Year__c + '_' + fc.Fiscal_Quarter__c;
            if(!map_acctId_map_dateKey_fc.containsKey(fc.Customer__c)) {
                map_acctId_map_dateKey_fc.put(fc.Customer__c, new map<String, APL_Sales_Forecast__c>());
            }
            if(!map_acctId_map_dateKey_fc.get(fc.Customer__c).containsKey(dateKey)) {
                map_acctId_map_dateKey_fc.get(fc.Customer__c).put(dateKey, fc);
            }
        }
    }
    */
    /**
    * This method is used to get GPLs for CBC2
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
    public static void savePartFC(ClsAPLEntityTypes.RelayCBCFCInfo cbcFC) {
        map<String, map<String, decimal>> map_partId_map_acctId_partPercent = new map<String, map<String, decimal>>();
        map<String, decimal> map_acctId_avgPercent = new map<String, decimal>();
            
        map<String, map<String, map<String, APL_Sales_Forecast__c>>> map_partId_map_acctId_map_dateKey_fc 
            = new map<String, map<String, map<String, APL_Sales_Forecast__c>>>();
            
        list<APL_Sales_Forecast__c> list_acctFC2Insert = new list<APL_Sales_Forecast__c>();
        list<APL_Sales_Forecast__c> list_acctFC2Update = new list<APL_Sales_Forecast__c>();
        list<APL_Sales_Forecast__c> list_acctFC2Delete = new list<APL_Sales_Forecast__c>();
        //get parts percent
        getPartPercentForSave(cbcFC.parentId, cbcFC.cbc2Code, cbcFC.territoryCode, cbcFC.quarterNumb,
                              map_acctId_avgPercent, map_partId_map_acctId_partPercent);
        //get existing part forecasts
        getExistingPartFC(cbcFC.parentId, cbcFC.cbc2Code, cbcFC.territoryCode, cbcFC.quarterNumb,
                            cbcFC.map_year_quartersFuture, map_partId_map_acctId_map_dateKey_fc);
        //generate or update part forecast records
        system.debug('map_partId_map_acctId_partPercent::: '+map_partId_map_acctId_partPercent);      
        system.debug('map_acctId_avgPercent::: '+map_acctId_avgPercent); 
        /*
        set<String> set_partId = new set<String>();
        map<String, String> map_partId_GPLId = new map<String, String>();
        for(ClsAPLEntityTypes.RelayPartFCInfo partFC : cbcFC.list_partFC) {
            set_partId.add(partFC.partId.trim());
        }  
        
        for(Part__c part : [select Id, Product_Hierarchy__c 
                            from Part__c where Id In : set_partId]) {
            map_partId_GPLId.put(part.Id, part.Product_Hierarchy__c);
        }   
        */ 
        for(ClsAPLEntityTypes.RelayPartFCInfo partFC : cbcFC.list_partFC) {
            String partId = partFC.partId.trim(); 
            String gplId = partFC.gplId.trim();
            
            map<String, map<String, APL_Sales_Forecast__c>> temp_map_acctId_map_dateKey_fc = new map<String, map<String, APL_Sales_Forecast__c>>();
            map<String, decimal> map_acctId_billingPercent = new map<String, decimal>();
            if(map_partId_map_acctId_partPercent.containsKey(partId)) {
                map_acctId_billingPercent = map_partId_map_acctId_partPercent.get(partId);
            }else {
                map_acctId_billingPercent = map_acctId_avgPercent;
            }
            
            if(map_partId_map_acctId_map_dateKey_fc.containsKey(partId)) {
                temp_map_acctId_map_dateKey_fc = map_partId_map_acctId_map_dateKey_fc.get(partId);
            }
            
            if(temp_map_acctId_map_dateKey_fc == null) {
                temp_map_acctId_map_dateKey_fc = new map<String, map<String, APL_Sales_Forecast__c>>();
            }
            
            generateFC(map_acctId_billingPercent, partFC.map_dateKey_relayFC, temp_map_acctId_map_dateKey_fc, 
                        cbcFC.currencyIso, RELAYFCTYPE, partId, gplId, false, list_acctFC2Insert, list_acctFC2Update, list_acctFC2Delete);
        } 
        system.debug('list_acctFC2Insert::: '+list_acctFC2Insert);   
        system.debug('list_acctFC2Update::: '+list_acctFC2Update);  
        system.debug('list_acctFC2Delete::: '+list_acctFC2Delete);      
        //INSERT, UPDATE, DELETE APL Forecasts
        ClsAPLForecastUtil.aplFCRecordsDML(list_acctFC2Insert, list_acctFC2Update, list_acctFC2Delete);
    }

   /**
    * This method is used to build currency iso map 
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
    private static void calcPercentage(map<String, decimal> map_key_percent, decimal totalAmount) {
        decimal remaining = 1;
        if(map_key_percent.isEmpty()) {
            return;
        } 
        Integer indicator = 1;
        for(String key : map_key_percent.keySet()) {
            decimal percent = (totalAmount == 0 ? 1.0 / map_key_percent.size() : map_key_percent.get(key) / totalAmount);
            percent = percent.setScale(2);
            if(indicator == map_key_percent.size()) {
                map_key_percent.put(key, remaining);
            }
            else {
                map_key_percent.put(key, percent);
            }
            remaining = remaining - percent;
            indicator ++;
        }
        
    }
    
    /**
    * This method is used to get the children account billing percent
    *
    @author Lili Zhao
    @created 2014-05-23
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-05-23 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static void getChildrenAccts(String parentId, String territoryCode, set<String> set_acctIds) {
        String query = ' Select Id From Account Where Id != null ';
        query += ' And STATDESC__c = \'Active\' ';   
        query += getForecastParentFilter(parentId, territoryCode, true);
        for(Account acct : database.query(query)) {
            set_acctIds.add(acct.Id);
        }
    }
    
   /**
    * This method is used to build currency iso map 
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
    private static void generateFC(map<String, decimal> map_acctId_billingPercent, map<String, ClsAPLEntityTypes.RelayFC> map_dateKey_fc,
                                    map<String, map<String, APL_Sales_Forecast__c>> map_acctId_map_dateKey_fc, String currencyIso,
                                    String fcType, String partId, String GPLId, boolean isAcc,   
                                    list<APL_Sales_Forecast__c> list_acctFC2Insert,
                                    list<APL_Sales_Forecast__c> list_acctFC2Update, 
                                    list<APL_Sales_Forecast__c> list_acctFC2Delete) {
        
        set<String> set_updatedAcctFCIds = new set<String>();
        
        if(map_acctId_map_dateKey_fc == null) {
            map_acctId_map_dateKey_fc = new map<String, map<String, APL_Sales_Forecast__c>>();
        }
        //create or update account forecast records
        if(map_acctId_billingPercent.isEmpty()) {
            return;
        }
        integer i = 0;
                
        system.debug('map_acctId_billingPercent::: '+map_acctId_billingPercent);
        map<String, decimal> dateKey_sumQuantity = new map<String, decimal>();
        for(String acctId : map_acctId_billingPercent.keySet()) {    
                           
            for(String dateKey : map_dateKey_fc.keySet()) {
                //if has such account percent will not generate apl forecast record for this account
                if(!map_acctId_billingPercent.containsKey(acctId)) {
                    continue;
                }
                String year = dateKey.substringBefore('_');
                String quarter = dateKey.substringAfter('_');
                ClsAPLEntityTypes.RelayFC fc = map_dateKey_fc.get(dateKey);
                system.debug('fc:::: '+fc);
                decimal percent = map_acctId_billingPercent.get(acctId); 
                system.debug('percent::: '+percent);             
                if(!dateKey_sumQuantity.containsKey(dateKey)) {
                    dateKey_sumQuantity.put(dateKey, 0);
                }
                system.debug('dateKey_sumQuantity::: '+dateKey_sumQuantity);
                decimal sumQuantity = dateKey_sumQuantity.get(dateKey);
                decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, currencyIso, 'USD');  
                system.debug('currencyRate::: '+currencyRate);
                if(map_acctId_map_dateKey_fc.containsKey(acctId) 
                    && map_acctId_map_dateKey_fc.get(acctId).containsKey(dateKey)) {
                        
                    //decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, currencyIso, 'USD');   
                    APL_Sales_Forecast__c acctFC = map_acctId_map_dateKey_fc.get(acctId).get(dateKey);                    
                    //acctFC.Price__c = ClsAPLForecastUtil.transformIsoCode(fc.price, 'USD', currencyIso);
                    if(!isAcc) {                        
                        acctFC.Price__c = fc.price; 
                        acctFC.RSM_Price__c = fc.price;
                        acctFC.GPL__c = GPLId;
                        if(i == (map_acctId_billingPercent.size() - 1)) {
                            acctFC.Quantity__c = fc.amount - sumQuantity;                            
                        }else {   
                            decimal quantity = fc.amount * percent;                
                            //acctFC.Quantity__c = fc.amount * percent;
                            if(quantity != 0) {
                                quantity = quantity.setScale(0, System.Roundingmode.HALF_UP);
                            }
                            acctFC.Quantity__c = quantity;
                        }
                        system.debug('acctFC.Quantity__c::: '+acctFC.Quantity__c);
                        acctFC.RSM_Quantity__c = acctFC.Quantity__c;
                        acctFC.Forecast__c = acctFC.Price__c * acctFC.Quantity__c;
                        //acctFC.GAM_Forecast__c = acctFC.Forecast__c;
                        sumQuantity += acctFC.Quantity__c;
                        system.debug('sumQuantity::: '+sumQuantity);
                        if(dateKey_sumQuantity.containsKey(dateKey)) {
                            dateKey_sumQuantity.put(dateKey, sumQuantity);
                        }
                    }else {
                        acctFC.Forecast__c = fc.total * percent;
                        
                    }  
                    system.debug('currencyRate::: '+currencyRate);
                    acctFC.GAM_Forecast__c = acctFC.Forecast__c * currencyRate; 
                    acctFC.RSM_Forecast__c = acctFC.RSM_Price__c * acctFC.Quantity__c * currencyRate;              
                    acctFC.currencyIsoCode = currencyIso;
                    list_acctFC2Update.add(acctFC);
                    set_updatedAcctFCIds.add(acctFC.Id);
                    
                }
                else {
                    system.debug('acctId::: '+acctId);
                    APL_Sales_Forecast__c acctFC = new APL_Sales_Forecast__c();
                    acctFC.Customer__c = acctId;
                    acctFC.Type__c = fcType;
                    acctFC.Fiscal_Year__c = year;
                    acctFC.Fiscal_Quarter__c = quarter;
                    acctFC.GPL__c = GPLId;
                    if(!isAcc) {
                         acctFC.Price__c = fc.price; 
                         acctFC.RSM_Price__c = fc.price;
                         system.debug('i'+i);
                         system.debug('map_acctId_billingPercent.size():::: '+map_acctId_billingPercent.size());
                        if(i == map_acctId_billingPercent.size()-1) {
                            acctFC.Quantity__c = fc.amount - sumQuantity;
                        }else {    
                            decimal quantity = fc.amount * percent;               
                            //acctFC.Quantity__c = fc.amount * percent;
                            if(quantity != 0) {
                                quantity = quantity.setScale(0, System.Roundingmode.HALF_UP);
                            }
                            acctFC.Quantity__c = quantity;
                        }
                        acctFC.RSM_Quantity__c = acctFC.Quantity__c;
                        system.debug('acctFC.Quantity__c::: '+acctFC.Quantity__c);
                        acctFC.Forecast__c = acctFC.Price__c * acctFC.Quantity__c;
                          
                        acctFC.GAM_Forecast__c = acctFC.Forecast__c * currencyRate;
                        acctFC.RSM_Forecast__c = acctFC.RSM_Price__c * acctFC.Quantity__c * currencyRate;    
                        sumQuantity += acctFC.Quantity__c;
                        system.debug('sumQuantity::: '+sumQuantity);
                        if(dateKey_sumQuantity.containsKey(dateKey)) {
                            dateKey_sumQuantity.put(dateKey, sumQuantity);
                        }
                        system.debug('dateKey_sumQuantity::: '+dateKey_sumQuantity);
                    }else {
                        acctFC.Forecast__c = fc.total * percent;
                    }                    
                    acctFC.Part__c = (fcType == RELAYFCTYPE ? partId : null);
                    acctFC.currencyIsoCode = currencyIso;
                    
                    list_acctFC2Insert.add(acctFC);
                }
                
            }
            i++;
        }
        //check forecast records to remove
        for(String acctId : map_acctId_map_dateKey_fc.keySet()) {
            for(APL_Sales_Forecast__c aplFC : map_acctId_map_dateKey_fc.get(acctId).values()) {
                if(!set_updatedAcctFCIds.contains(aplFC.Id)) {
                    list_acctFC2Delete.add(aplFC);
                }
            }
        }
        
    }
    
    
    /**
    * This method is used to get the children account billing percent
    *
    @author Lili Zhao
    @created 2014-05-23
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-05-23 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static void getPartPercentForSave(String parentId, String cbcCode, String territoryCode, String quartNumb,
                                                map<String, decimal> map_acctId_avgPercent, map<String, map<String, decimal>> map_partId_map_acctId_partPercent) {
        System.debug('-----------------------ClsGroupingRelayForecastUtil2-----------------');
        map<String, decimal> map_partId_totalAmount = new map<String, decimal>();
        set<String> set_childAcctIds = new set<String>();
        system.debug('set_childAcctIds ::: '+set_childAcctIds);
        //get all children account ids for current parent
        getChildrenAccts(parentId, territoryCode, set_childAcctIds);
        // get account billing query
        String query = 'select SUM(Bill_Amount_current_prior__c) amount, Part__c PartId, Customer__c AcctId '
                     + ' From BBB_Year_Bill_Book_Cust_PN__c '
                     + ' Where Id != null And Bill_Amount_current_prior__c != null And Bill_Amount_current_prior__c != 0 ';
        query += ' And Customer__r.STATDESC__c = \'Active\' ';   
        query += ' And Part__r.Product_Hierarchy__r.' + getRelayField(cbcCode) + ' = \'' + cbcCode + '\' ';
        
        query += getForecastParentFilter(parentId, territoryCode, false);
        //update by nelson zheng 2015-10-21 for case 00900375
        //query += ' And BU_Profit_Center__c = \'RPA\'  ';
        //query += ' And (BU_Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  ';
	    query += ' And BU_Profit_Center__c = \'APL\'  ';
	                  
        query += ' group by Part__c, Customer__c';
        //get reference data by part ==> map_acctId_map_partId_billingAmount
        system.debug('--------------ClsGroupingRelayForecastUtil.cls (10 matches) 2-------------------');
        
        system.debug('query ::: ' + query);
        for(AggregateResult result : database.query(query)) {
            String partId = (String) (result.get('PartId') == null ? OTHER : result.get('PartId'));
            String acctId = (String) result.get('AcctId');
            //decimal priorAmount = (decimal) (result.get('priorAmount') == null ? 0 : result.get('priorAmount'));
            //decimal tempAmount = (decimal) (result.get('amount') == null ? 0 : result.get('amount'));
            //decimal amount = tempAmount + ((quartNumb == 'Q1' || quartNumb == 'Q2') ? priorAmount : 0); 
            decimal amount = (decimal) (result.get('amount') == null ? 0 : result.get('amount'));

            //build part percent map
            if(!map_partId_map_acctId_partPercent.containsKey(partId)) {
                map_partId_map_acctId_partPercent.put(partId, new map<String, decimal>());
            }
            if(!map_partId_map_acctId_partPercent.get(partId).containsKey(acctId)) {
                map_partId_map_acctId_partPercent.get(partId).put(acctId, 0);
            }
            map_partId_map_acctId_partPercent.get(partId).put(acctId, map_partId_map_acctId_partPercent.get(partId).get(acctId) + amount);
            //calc total amount for each part
            if(!map_partId_totalAmount.containsKey(partId)) {
                map_partId_totalAmount.put(partId, 0);
            }
            map_partId_totalAmount.put(partId, map_partId_totalAmount.get(partId) + amount);
            
        }
        for(String acctId : set_childAcctIds) {
            if(!map_acctId_avgPercent.containsKey(acctId)) {
                map_acctId_avgPercent.put(acctId, 0);
            }
        }
        calcPercentage(map_acctId_avgPercent, 0);
        system.debug('map_acctId_avgPercent::: '+map_acctId_avgPercent);
        //build part percent for all children account
        for(String partId : map_partId_map_acctId_partPercent.keySet()) {
            for(String acctId : set_childAcctIds) {
                if(!map_partId_map_acctId_partPercent.get(partId).containsKey(acctId)) {
                    map_partId_map_acctId_partPercent.get(partId).put(acctId, 0);
                }
            }
            //Calc part percent // modify by lili zhao 2014-06-16
            calcPercentage(map_partId_map_acctId_partPercent.get(partId), map_partId_totalAmount.get(partId));
        }
        
    }
    
    /**
    * This method is used to get the 
    *
    @author Lili Zhao
    @created 2014-05-23
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-05-23 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static void getExistingPartFC(String parentId, String cbcCode, String territoryCode, String quartNumb, 
                                        map<String, set<String>> map_year_quartersFuture,
                                        map<String, map<String, map<String, APL_Sales_Forecast__c>>> map_partId_map_acctId_map_dateKey_fc) {
                                            
        String query = ' Select Id, Customer__c, Fiscal_Quarter__c, Fiscal_Year__c, Part__c '
                     + ' From APL_Sales_Forecast__c '
                     + ' Where Type__c = \'' + RELAYFCTYPE + '\' ';
        query += getForecastParentFilter(parentId, territoryCode, false);
        query += ClsAPLForecastUtil.getMonthFilter(map_year_quartersFuture);
        query += ' And Customer__r.STATDESC__c = \'Active\' ';   
        query += ' And Part__r.Product_Hierarchy__r.' + getRelayField(cbcCode) + ' = \'' + cbcCode + '\' ';
        for(APL_Sales_Forecast__c fc : database.query(query)) {
            String dateKey = fc.Fiscal_Year__c + '_' + fc.Fiscal_Quarter__c;
            String acctId = fc.Customer__c;
            String partId = fc.Part__c;
            
            if(!map_partId_map_acctId_map_dateKey_fc.containsKey(partId)) {
                map_partId_map_acctId_map_dateKey_fc.put(partId, new map<String, map<String, APL_Sales_Forecast__c>>());
            }
            if(!map_partId_map_acctId_map_dateKey_fc.get(partId).containsKey(acctId)) {
                map_partId_map_acctId_map_dateKey_fc.get(partId).put(acctId, new map<String, APL_Sales_Forecast__c>());
            }
            if(!map_partId_map_acctId_map_dateKey_fc.get(partId).get(acctId).containsKey(dateKey)) {
                map_partId_map_acctId_map_dateKey_fc.get(partId).get(acctId).put(dateKey, fc);
            }
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
    public static void getCBCHistoryRefData(String parentId, String territoryCode, decimal currencyRate, 
                                            map<String, String> map_cbcRowKey_cbcFC, 
                                            map<String, set<Integer>> map_year_monthsHistory,
                                            map<String, RelayFCCBCViewFields> map_cbc2RowKey_fcViewObj) {
        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(false, parentId, territoryCode, set_acctIds);
        System.debug('-----------------------ClsGroupingRelayForecastUtil3-----------------');                                         
        list<String> list_sql = new list<String>();
        map<String, map<String, RelayFCCBCViewFields>> map_cbc2Name_map_dateKey_result = new map<String, map<String, RelayFCCBCViewFields>>();
        
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking, Fiscal_Date__c fiscal_date, '
                    + ' Part__r.Product_Hierarchy__r.CBC2__c cbc2, Part__r.Product_Hierarchy__r.CBC3__c cbc3 ');
        list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
        
        list_sql.add(' Where Customer__c IN : set_acctIds ' 
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
                    + getRelayCBCQuery() 
                    + (ClsAPLForecastUtil.getFiscalMonthFilter(map_year_monthsHistory) == '' ? '' 
                            : ClsAPLForecastUtil.getFiscalMonthFilter(map_year_monthsHistory))
                    //update by nelson zheng 2015-10-21 for case 00900375
                    //+' And Profit_Center__c = \'RPA\'  ' 
                    //+ ' And (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  '
	                +' And Profit_Center__c = \'APL\'  ' 
	                  
                    + ' Group by Fiscal_Date__c, Part__r.Product_Hierarchy__r.CBC2__c, Part__r.Product_Hierarchy__r.CBC3__c '
                    );
         system.debug('--------------ClsGroupingRelayForecastUtil.cls (10 matches) 3-------------------');
        
        if(map_cbcRowKey_cbcFC.isEmpty()) {
            return;
        }
        system.debug('ClsAPLForecastUtil.getQueryString(list_sql)::: '+ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String cbc2Name = (String) result.get('cbc2');
            String cbc3Name = (String) result.get('cbc3');
            String cbcKeyName = getCBCKeyName(cbc2Name, cbc3Name);
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;
            if(!map_cbc2RowKey_fcViewObj.containsKey(cbcKeyName)) {
                map_cbc2RowKey_fcViewObj.put(cbcKeyName, new RelayFCCBCViewFields());
            }
            RelayFCCBCViewFields cbcFC = map_cbc2RowKey_fcViewObj.get(cbcKeyName);
            cbcFC = (RelayFCCBCViewFields) cbcFC.assignRefData(cbcFC, result, dateKey, currencyRate, true);
            system.debug('cbcFC:::  '+cbcFC);
        }
        //generate forecast view objects for each quarter
        for(String cbcRowKey : map_cbcRowKey_cbcFC.keySet()) {
            String cbc2Name = map_cbcRowKey_cbcFC.get(cbcRowKey);
            for(String year : map_year_monthsHistory.keySet()) {
                for(Integer month : map_year_monthsHistory.get(year)) {
                    String dateKey = year + '_' + month;
                    AggregateResult result;
                    
                    RelayFCCBCViewFields fcObj = map_cbc2RowKey_fcViewObj.get(cbc2Name);
                    fcObj = fcObj.assignRefData(fcObj, result, dateKey, currencyRate, true);                    
                }
            }
        }
        system.debug('map_cbc2RowKey_fcViewObj:::: '+map_cbc2RowKey_fcViewObj);
    }
    
    /**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Lili Zhao
    @created 2014-06-30
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-30 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static void getCBCHistoryRefBacklogData(String parentId, String territoryCode, decimal currencyRate, 
                                            map<String, String> map_cbcRowKey_cbcFC, 
                                            String periodStartDate, String refStartDate,
                                            map<String, set<Integer>> map_year_monthsHistory,
                                            map<String, RelayFCCBCViewFields> map_cbc2RowKey_fcViewObj) {
        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(false, parentId, territoryCode, set_acctIds);
		System.debug('-----------------------ClsGroupingRelayForecastUtil4-----------------');
        list<String> list_sql = new list<String>();
        map<String, map<String, RelayFCCBCViewFields>> map_cbc2Name_map_dateKey_result = new map<String, map<String, RelayFCCBCViewFields>>();
        system.debug('map_year_monthsHistory::::1690::: '+map_year_monthsHistory);
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date, '
                    + ' Part__r.Product_Hierarchy__r.CBC2__c cbc2, Part__r.Product_Hierarchy__r.CBC3__c cbc3 ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' Where Customer__c IN : set_acctIds '
                    + ' And Backlog_Amount_USD__c != 0 '
                    + getRelayCBCQuery() 
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_year_monthsHistory)
                    
                    //update by nelson zheng 2015-10-21 for case 00900375
                    //+' And Profit_Center__c = \'RPA\'  '
                    //+ ' And (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  '
	       			+' And Profit_Center__c = \'APL\'  '
	       			
                    + ' Group by Customer_Request_Date_Fiscal_Date__c, Part__r.Product_Hierarchy__r.CBC2__c, Part__r.Product_Hierarchy__r.CBC3__c '
                    );
        system.debug('--------------ClsGroupingRelayForecastUtil.cls (10 matches) 4-------------------');
        
        if(map_cbcRowKey_cbcFC.isEmpty()) {
            return;
        }
        system.debug('ClsAPLForecastUtil.getQueryString(list_sql) 1471::: '+ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String cbc2Name = (String) result.get('cbc2');
            String cbc3Name = (String) result.get('cbc3');
            String cbcKeyName = getCBCKeyName(cbc2Name, cbc3Name);
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;
            if(!map_cbc2RowKey_fcViewObj.containsKey(cbcKeyName)) {
                map_cbc2RowKey_fcViewObj.put(cbcKeyName, new RelayFCCBCViewFields());
            }

            RelayFCCBCViewFields cbcFC = map_cbc2RowKey_fcViewObj.get(cbcKeyName);
            cbcFC = (RelayFCCBCViewFields) cbcFC.assignRefBacklogData(cbcFC, result, dateKey, currencyRate);
        }
        //generate forecast view objects for each quarter
        for(String cbcRowKey : map_cbcRowKey_cbcFC.keySet()) {
            String cbc2Name = map_cbcRowKey_cbcFC.get(cbcRowKey);
            for(String year : map_year_monthsHistory.keySet()) {
                for(Integer month : map_year_monthsHistory.get(year)) {
                    String dateKey = year + '_' + month;
                    AggregateResult result;
                    RelayFCCBCViewFields fcObj = map_cbc2RowKey_fcViewObj.get(cbc2Name);
                    fcObj = fcObj.assignRefBacklogData(fcObj, result, dateKey, currencyRate);                    
                }
            }
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
    public static void getCBCFutureRefBacklogData(String parentId, String territoryCode, decimal currencyRate, 
                                            map<String, String> map_cbcRowKey_cbcFC, 
                                            String refStartDate, String refEndDate,
                                            map<String, set<Integer>> map_year_monthsFuture,
                                            map<String, RelayFCCBCViewFields> map_cbc2RowKey_fcViewObj) {
        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(false, parentId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        map<String, map<String, RelayFCCBCViewFields>> map_cbc2Name_map_dateKey_result = new map<String, map<String, RelayFCCBCViewFields>>();
        system.debug('map_year_monthsFuture::1758:: '+map_year_monthsFuture);
        
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date, '
                    + ' Part__r.Product_Hierarchy__r.CBC2__c cbc2, Part__r.Product_Hierarchy__r.CBC3__c cbc3 ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' Where Customer__c IN : set_acctIds '
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0 OR Backlog_Amount_USD__c != 0) '
                    + getRelayCBCQuery() 
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_year_monthsFuture)
                    
                    //update by nelson zheng 2015-10-21 for case 00900375
                    //+' And Profit_Center__c = \'RPA\'  '
                    //+ ' And (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  '
	       			+' And Profit_Center__c = \'APL\'  '
	       			
                    + ' Group by Customer_Request_Date_Fiscal_Date__c, Part__r.Product_Hierarchy__r.CBC2__c, Part__r.Product_Hierarchy__r.CBC3__c '
                    );
        system.debug('--------------ClsGroupingRelayForecastUtil.cls (10 matches) 5-------------------');
        if(map_cbcRowKey_cbcFC.isEmpty()) {
            return;
        }
        system.debug('ClsAPLForecastUtil.getQueryString(list_sql)1540 ::: '+ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String cbc2Name = (String) result.get('cbc2');
            String cbc3Name = (String) result.get('cbc3');
            String cbcKeyName = getCBCKeyName(cbc2Name, cbc3Name);
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;
            if(!map_cbc2RowKey_fcViewObj.containsKey(cbcKeyName)) {
                map_cbc2RowKey_fcViewObj.put(cbcKeyName, new RelayFCCBCViewFields());
            }
            RelayFCCBCViewFields cbcFC = map_cbc2RowKey_fcViewObj.get(cbcKeyName);
            cbcFC = (RelayFCCBCViewFields) cbcFC.assignRefBacklogData(cbcFC, result, dateKey, currencyRate);
        }
        //generate forecast view objects for each quarter
        for(String cbcRowKey : map_cbcRowKey_cbcFC.keySet()) {
            String cbc2Name = map_cbcRowKey_cbcFC.get(cbcRowKey);
            for(String year : map_year_monthsFuture.keySet()) {
                for(Integer month : map_year_monthsFuture.get(year)) {
                    String dateKey = year + '_' + month;
                    AggregateResult result;
                    RelayFCCBCViewFields fcObj = map_cbc2RowKey_fcViewObj.get(cbc2Name);
                    fcObj = fcObj.assignRefBacklogData(fcObj, result, dateKey, currencyRate);
                }
            }
        }

        system.debug('map_cbc2RowKey_fcViewObj:1570 ::: '+map_cbc2RowKey_fcViewObj);
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
    public static void getCBCCurrentRefData(String parentId, String territoryCode, decimal currencyRate, 
                                            map<String, String> map_cbcRowKey_cbcFC, 
                                            String fiscalYear, Integer fiscalMonth,
                                            map<String, set<Integer>> map_year_monthsFuture,
                                            map<String, RelayFCCBCViewFields> map_cbc2RowKey_fcViewObj) {
        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(false, parentId, territoryCode, set_acctIds);
		System.debug('-----------------------ClsGroupingRelayForecastUtil5-----------------');
        list<String> list_sql = new list<String>();
        map<String, map<String, RelayFCCBCViewFields>> map_cbc2Name_map_dateKey_result = new map<String, map<String, RelayFCCBCViewFields>>();
        system.debug('map_year_monthsFuture::1758:: '+map_year_monthsFuture);
        
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking, '
                    + ' Part__r.Product_Hierarchy__r.CBC2__c cbc2, Part__r.Product_Hierarchy__r.CBC3__c cbc3 ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' Where Customer__c IN : set_acctIds '
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0 OR Backlog_Amount_USD__c != 0) '
                    + getRelayCBCQuery() 
                    + ' And Fiscal_Year__c = \'' + fiscalYear + '\' And Fiscal_Month__c = ' + fiscalMonth 
                    
                    //update by nelson zheng 2015-10-21 for case 00900375
                    //+' And Profit_Center__c = \'RPA\'  '
                    //+ ' And (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  '
	       			+' And Profit_Center__c = \'APL\'  '
	       			
                    + ' Group by  Part__r.Product_Hierarchy__r.CBC2__c, Part__r.Product_Hierarchy__r.CBC3__c '
                    );
        system.debug('--------------ClsGroupingRelayForecastUtil.cls (10 matches) 6-------------------');
        if(map_cbcRowKey_cbcFC.isEmpty()) {
            return;
        }
        system.debug('ClsAPLForecastUtil.getQueryString(list_sql)1540 ::: '+ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        String dateKey = fiscalYear + '_' + fiscalMonth;
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String cbc2Name = (String) result.get('cbc2');
            String cbc3Name = (String) result.get('cbc3');
            String cbcKeyName = getCBCKeyName(cbc2Name, cbc3Name);
            //Date fiscal_date = (Date) result.get('fiscal_date');
            //String year = String.valueOf(fiscal_date.year());
            //String month = String.valueOf(fiscal_date.month());
            
            if(!map_cbc2RowKey_fcViewObj.containsKey(cbcKeyName)) {
                map_cbc2RowKey_fcViewObj.put(cbcKeyName, new RelayFCCBCViewFields());
            }
            RelayFCCBCViewFields cbcFC = map_cbc2RowKey_fcViewObj.get(cbcKeyName);
            cbcFC = (RelayFCCBCViewFields) cbcFC.assignRefData(cbcFC, result, dateKey, currencyRate, true);

        }
        //generate forecast view objects for each quarter
        for(String cbcRowKey : map_cbcRowKey_cbcFC.keySet()) {
            String cbc2Name = map_cbcRowKey_cbcFC.get(cbcRowKey);
            AggregateResult result;
            RelayFCCBCViewFields fcObj = map_cbc2RowKey_fcViewObj.get(cbc2Name);
            fcObj = fcObj.assignRefData(fcObj, result, dateKey, currencyRate, true);

        }
        system.debug('map_cbc2RowKey_fcViewObj:1570 ::: '+map_cbc2RowKey_fcViewObj);
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
    public static void getPartHistoryRefData(String gplId, String parentId, decimal currencyRate, String territoryCode, 
                                            map<String, set<Integer>> map_year_monthsHistory,
                                            map<String, PartViewFields> map_partId_fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(false, parentId, territoryCode, set_acctIds);
       System.debug('-----------------------ClsGroupingRelayForecastUtil6-----------------');                                         
        list<String> list_sql = new list<String>();
        set<String> set_partIds = new set<String>();
        set_partIds.addAll(map_partId_fcViewObj.keySet());
        system.debug('set_partIds::: '+set_partIds);
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking, Fiscal_Date__c fiscal_date, '
                    + ' Part__c partId ');
        list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
        
        list_sql.add(' Where Customer__C IN : set_acctIds ' 
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
                    + getRelayPartSearchQueryFilter(gplId, true) 
                    + ' And Part__c IN : set_partIds '
                    + (ClsAPLForecastUtil.getFiscalMonthFilter(map_year_monthsHistory) == '' ? '' 
                            : ClsAPLForecastUtil.getFiscalMonthFilter(map_year_monthsHistory))
                    
                    //update by nelson zheng 2015-10-21 for case 00900375
                    //+' And Profit_Center__c = \'RPA\'  '
                    //+ ' And (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  '
	       			+' And Profit_Center__c = \'APL\'  '
	       			
                    + ' Group by Fiscal_Date__c, Part__c '
                    );
        system.debug('--------------ClsGroupingRelayForecastUtil.cls (10 matches) 7-------------------');
        if(map_partId_fcViewObj.isEmpty()) {
            return;
        }
        system.debug('ClsAPLForecastUtil.getQueryString(list_sql)::: '+ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String partId = (String) result.get('partId');
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;
            if(!map_partId_fcViewObj.containsKey(partId)) {
                map_partId_fcViewObj.put(partId, new PartViewFields());
            }            
            PartViewFields partFC = map_partId_fcViewObj.get(partId);
            partFC = (PartViewFields) partFC.assignRefData(partFC, result, dateKey, currencyRate, true);
            system.debug('partFC::: '+partFC);
        }
        //generate forecast view objects for each quarter
        for(String partId : map_partId_fcViewObj.keySet()) {
            for(String year : map_year_monthsHistory.keySet()) {
                for(Integer month : map_year_monthsHistory.get(year)) {
                    String dateKey = year + '_' + month;
                    AggregateResult result;
                    PartViewFields fcObj = map_partId_fcViewObj.get(partId);
                    fcObj = fcObj.assignRefData(fcObj, result, dateKey, currencyRate, true);  
                    system.debug('fcObj::: '+fcObj);                  
                }
            }
        }
        system.debug('map_partId_fcViewObj:::: '+map_partId_fcViewObj);
    }
    //getPartFutureRefBacklogData
    /**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Lili Zhao
    @created 2014-06-24
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-24 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static void getPartHistoryRefBacklogData(String gplId, String parentId, decimal currencyRate, String territoryCode,
                                            String periodStartDate, String refStartDate,
                                            map<String, set<Integer>> map_year_monthsFuture,
                                            map<String, PartViewFields> map_partId_fcViewObj) {
        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(false, parentId, territoryCode, set_acctIds);
		System.debug('-----------------------ClsGroupingRelayForecastUtil7-----------------');
        list<String> list_sql = new list<String>();
        //map<String, map<String, PartViewFields>> map_partId_map_dateKey_result = new map<String, map<String, PartViewFields>>();
        set<String> set_partIds = new set<String>();
        set_partIds.addAll(map_partId_fcViewObj.keySet());
        system.debug('set_partIds::: '+set_partIds);
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date, '
                    + ' Part__c partId');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' Where Customer__C IN : set_acctIds '
                    + getRelayPartSearchQueryFilter(gplId, true) 
                    + ' And Part__c IN : set_partIds '
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_year_monthsFuture)
                    + ' And Backlog_Amount_USD__c != 0 '
                    
                    //update by nelson zheng 2015-10-21 for case 00900375
                    //+' And Profit_Center__c = \'RPA\'  '
                    //+ ' And (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  '
	       			+' And Profit_Center__c = \'APL\'  '
	       			
                    + ' Group by Customer_Request_Date_Fiscal_Date__c, Part__c '
                    );
        system.debug('--------------ClsGroupingRelayForecastUtil.cls (10 matches) 8-------------------');
        if(map_partId_fcViewObj.isEmpty()) {
            return;
        }
        system.debug('ClsAPLForecastUtil.getQueryString(list_sql)::: '+ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String partId = (String) result.get('partId');
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;
            if(!map_partId_fcViewObj.containsKey(partId)) {
                map_partId_fcViewObj.put(partId, new PartViewFields());
            }
            
            PartViewFields partFC = map_partId_fcViewObj.get(partId);
            partFC = (PartViewFields) partFC.assignRefBacklogData(partFC, result, dateKey, currencyRate);
            system.debug('partFC::: '+partFC);
        }
        //generate forecast view objects for each quarter
        for(String partId : map_partId_fcViewObj.keySet()) {
            for(String year : map_year_monthsFuture.keySet()) {
                for(Integer month : map_year_monthsFuture.get(year)) {
                    String dateKey = year + '_' + month;
                    AggregateResult result;                    
                    PartViewFields fcObj = map_partId_fcViewObj.get(partId);
                    fcObj = fcObj.assignRefBacklogData(fcObj, result, dateKey, currencyRate);     
                    system.debug('fcObj::: '+fcObj);               
                }
            }
        }
        system.debug('map_partId_fcViewObj:::: '+map_partId_fcViewObj);
    }
    
    /**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Lili Zhao
    @created 2014-06-24
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-24 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static void getPartFutureRefData(String gplId, String parentId, decimal currencyRate, String territoryCode,
                                            String refStartDate, String refEndDate,
                                            map<String, set<Integer>> map_year_monthsFuture,
                                            map<String, PartViewFields> map_partId_fcViewObj) {
        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(false, parentId, territoryCode, set_acctIds);
		System.debug('-----------------------ClsGroupingRelayForecastUtil8-----------------');
        list<String> list_sql = new list<String>();
        //map<String, map<String, PartViewFields>> map_partId_map_dateKey_result = new map<String, map<String, PartViewFields>>();
        set<String> set_partIds = new set<String>();
        set_partIds.addAll(map_partId_fcViewObj.keySet());
        system.debug('set_partIds::: '+set_partIds);
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date, '
                    + ' Part__c partId');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' Where Customer__C IN : set_acctIds '
                    + getRelayPartSearchQueryFilter(gplId, true) 
                    + ' And Part__c IN : set_partIds '
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_year_monthsFuture)
                    + ' And (Backlog_Amount_USD__c != 0  or Bill_Amount_USD__c != 0 or Book_Amount_USD__c != 0) '
                    
                    //update by nelson zheng 2015-10-21 for case 00900375
                    //+' And Profit_Center__c = \'RPA\'  '
                    //+ ' And (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  '
	       			+' And Profit_Center__c = \'APL\'  '
	       			
                    + ' Group by Customer_Request_Date_Fiscal_Date__c, Part__c '
                    );
        system.debug('--------------ClsGroupingRelayForecastUtil.cls (10 matches) 9-------------------');
        if(map_partId_fcViewObj.isEmpty()) {
            return;
        }
        system.debug('ClsAPLForecastUtil.getQueryString(list_sql)::: '+ClsAPLForecastUtil.getQueryString(list_sql));
        system.debug('currencyRate::: '+currencyRate);
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String partId = (String) result.get('partId');
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;
            if(!map_partId_fcViewObj.containsKey(partId)) {
                map_partId_fcViewObj.put(partId, new PartViewFields());
            }
            PartViewFields partFC = map_partId_fcViewObj.get(partId);
            partFC = (PartViewFields) partFC.assignRefBacklogData(partFC, result, dateKey, currencyRate);
            system.debug('partFC::: '+partFC);
        }
        //generate forecast view objects for each quarter
        for(String partId : map_partId_fcViewObj.keySet()) {
            for(String year : map_year_monthsFuture.keySet()) {
                for(Integer month : map_year_monthsFuture.get(year)) {
                    String dateKey = year + '_' + month;
                    AggregateResult result;
                    PartViewFields fcObj = map_partId_fcViewObj.get(partId);
                    fcObj = fcObj.assignRefBacklogData(fcObj, result, dateKey, currencyRate);    
                    system.debug('fcObj::: '+fcObj);                
                }
            }
        }
        system.debug('map_partId_fcViewObj:::: '+map_partId_fcViewObj);
    }
    
    
    /**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Lili Zhao
    @created 2014-06-24
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-24 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static void getPartCurrentRefData(String gplId, String parentId, decimal currencyRate, String territoryCode,
                                            String year, Integer month,
                                            map<String, set<Integer>> map_year_monthsFuture,
                                            map<String, PartViewFields> map_partId_fcViewObj) {
        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(false, parentId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        //map<String, map<String, PartViewFields>> map_partId_map_dateKey_result = new map<String, map<String, PartViewFields>>();
        set<String> set_partIds = new set<String>();
        set_partIds.addAll(map_partId_fcViewObj.keySet());
        system.debug('set_partIds::: '+set_partIds);
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking, '
                    + ' Part__c partId');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' Where Customer__C IN : set_acctIds '
                    + getRelayPartSearchQueryFilter(gplId, true) 
                    + ' And Part__c IN : set_partIds '
                    + ' And Fiscal_Year__c = \'' + year +'\''
                    + ' And Fiscal_Month__c = ' + month +
                    + ' And (Backlog_Amount_USD__c != 0  or Bill_Amount_USD__c != 0 or Book_Amount_USD__c != 0) '
                    
                    //update by nelson zheng 2015-10-21 for case 00900375
                    //+' And Profit_Center__c = \'RPA\'  '
                    //+ ' And (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  '
	       			+' And Profit_Center__c = \'APL\'  '
	       			
                    + ' Group by  Part__c '
                    );
         system.debug('--------------ClsGroupingRelayForecastUtil.cls (10 matches) 10-------------------');
        if(map_partId_fcViewObj.isEmpty()) {
            return;
        }

        //get cbc2 forecast for all cbc2
        String dateKey = year + '_' + month;
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String partId = (String) result.get('partId');
            if(!map_partId_fcViewObj.containsKey(partId)) {
                map_partId_fcViewObj.put(partId, new PartViewFields());
            }
            PartViewFields partFC = map_partId_fcViewObj.get(partId);
            partFC = (PartViewFields) partFC.assignRefData(partFC, result, dateKey, currencyRate, true);
            system.debug('partFC::: '+partFC);
        }
        //generate forecast view objects for each quarter
        for(String partId : map_partId_fcViewObj.keySet()) {
            AggregateResult result;         
            PartViewFields fcObj = map_partId_fcViewObj.get(partId);
            fcObj = fcObj.assignRefData(fcObj, result, dateKey, currencyRate, true);    
        }
        system.debug('map_partId_fcViewObj:::: '+map_partId_fcViewObj);
    }
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>InnerClass*/
    
    /**
     *  Inner class for 
     *
     @author    Lei Tang
     @created   2014-06-03
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-06-03 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     */
    public class RelayPartObj implements Comparable {
        public String partId {get; set;}
        public String gplId {get; set;}
        public String partName {get; set;}
        public String Description {get; set;}
        public decimal precent {get; set;}
        
        public RelayPartObj() {
            this.partId = '';
            this.partName = '';
            this.gplId = '';
            //this.Description = '';
            this.precent = 0;
        }
        
        public Integer compareTo(Object compareTo) {
            RelayPartObj compareToPart = (RelayPartObj) compareTo;
            if (this.precent == compareToPart.precent) return 0;
            if (this.precent > compareToPart.precent) return -1;
            return 1;        
        }
    }
    
    public class RelayFCObj {
        public decimal price {get; set;}
        public decimal quantity {get; set;}
        public RelayFCObj() {
            this.price = 0;
            this.quantity = 0;
        }
    }
    
    public class RelayFCCBCViewFields {
        public map<String, decimal> currentFC {get; set;}
        public map<String, decimal> previousFC {get; set;}
        public map<String, decimal> billing {get; set;}
        public map<String, decimal> booking {get; set;}
        public map<String, decimal> backlog {get; set;}
        public RelayFCCBCViewFields() {
            this.currentFC = new map<String, decimal>();
            this.previousFC = new map<String, decimal>();
            this.billing = new map<String, decimal>();
            this.booking = new map<String, decimal>();
            this.backlog = new map<String, decimal>();
        }
        
        public Object assignFCCurrentValues(Object superObj, AggregateResult result, String dateKey, decimal currencyRate) {
            RelayFCCBCViewFields currentObj = (RelayFCCBCViewFields) superObj;
            system.debug('result:::: '+result);
            decimal fc = (decimal) ((result == null || result.get('fc') == null ) ? 0 : result.get('fc')); 
            decimal prevFC = (decimal) ((result == null || result.get('preFc') == null ) ? 0 : result.get('preFc'));    
            
            fc = fc / currencyRate / 10000; 
            prevFC = prevFC / currencyRate;
            
            fc += (currentObj.currentFC.containsKey(dateKey) ? currentObj.currentFC.get(dateKey) : 0);
            prevFC += (currentObj.previousFC.containsKey(dateKey) ? currentObj.previousFC.get(dateKey) : 0);
            
            currentObj.currentFC.put(dateKey, fc);
            currentObj.previousFC.put(dateKey, prevFC); 
            
            return currentObj;
        }
        
        public RelayFCCBCViewFields assignRefData(RelayFCCBCViewFields cbcObj, AggregateResult result, String dateKey, decimal currencyRate, boolean isMonthly) {
            
            decimal billing = (decimal) ((result == null || result.get('billing') == null) ? 0 : result.get('billing'));
            decimal booking = (decimal) ((result == null || result.get('booking') == null) ? 0 : result.get('booking'));
            decimal backlog = (decimal) ((isMonthly || result == null || result.get('backlog') == null) ? 0 : result.get('backlog'));
            
            billing = billing / currencyRate; 
            booking = booking / currencyRate;
            backlog = backlog / currencyRate;
            
            billing += (cbcObj.billing.containsKey(dateKey) ? cbcObj.billing.get(dateKey) : 0);
            booking += (cbcObj.booking.containsKey(dateKey) ? cbcObj.booking.get(dateKey) : 0);
            backlog += (cbcObj.backlog.containsKey(dateKey) ? cbcObj.backlog.get(dateKey) : 0);
            
            cbcObj.billing.put(dateKey, billing);
            cbcObj.booking.put(dateKey, booking);
            cbcObj.backlog.put(dateKey, backlog);
            return cbcObj;
        }
        
        public RelayFCCBCViewFields assignRefBacklogData(RelayFCCBCViewFields cbcObj, AggregateResult result, String dateKey, decimal currencyRate) {
            decimal backlog = (decimal) ((result == null || result.get('backlog') == null) ? 0 : result.get('backlog'));
            backlog = backlog / currencyRate; 
            backlog += (cbcObj.backlog.containsKey(dateKey) ? cbcObj.backlog.get(dateKey) : 0);

            cbcObj.backlog.put(dateKey, backlog);
            return cbcObj;
        }   

    }
    
    public class RelayForecastViewFields{
        public String fieldName {get; set;}
        public map<String, decimal> currentFC {get; set;}
        public map<String, decimal> previousFC {get; set;}
        public map<String, RelayFCObj> currentFCObj {get; set;}
        public map<String, RelayFCObj> previousFCObj {get; set;}
        public map<String, decimal> posFC {get; set;}
        public map<String, decimal> cmaFC {get; set;}
        public map<String, decimal> totalBilling {get; set;}
        public map<String, decimal> totalBooking {get; set;}
        public map<String, decimal> totalBacklog {get; set;}
        public map<String, decimal> totalSA {get; set;}
        public map<String, decimal> fc2MAccuracy {get; set;}
        public map<String, decimal> fc3MAccuracy {get; set;}
        public map<String, decimal> fc6MAccuracy {get; set;}
        public map<String, decimal> rsmFC {get; set;}
        
        public map<String, decimal> totalBillingQty {get; set;}
        public map<String, decimal> totalBookingQty {get; set;}
        public map<String, decimal> totalBacklogQty {get; set;}
        
        public RelayForecastViewFields() {
            this.fieldName = '';
            this.currentFC = new map<String, decimal>();
            this.previousFC = new map<String, decimal>();
            this.currentFCObj = new map<String, RelayFCObj>();
            this.previousFCObj = new map<String, RelayFCObj>();
            this.posFC = new map<String, decimal>();
            this.cmaFC = new map<String, decimal>();
            this.totalBilling = new map<String, decimal>();
            this.totalBooking = new map<String, decimal>();
            this.totalBacklog = new map<String, decimal>();
            this.totalSA = new map<String, decimal>();
            this.fc2MAccuracy = new map<String, decimal>();
            this.fc3MAccuracy = new map<String, decimal>();
            this.fc6MAccuracy = new map<String, decimal>();
            this.rsmFC = new map<String, decimal>();
            
            this.totalBillingQty = new map<String, decimal>();
            this.totalBookingQty = new map<String, decimal>();
            this.totalBacklogQty = new map<String, decimal>();
        }
        
        public Object assignFCValues(Object superObj, AggregateResult result, String dateKey, decimal currencyRate) {
            RelayForecastViewFields obj = (RelayForecastViewFields) superObj;
            decimal fc = (decimal) ((result == null || result.get('fc') == null ) ? 0 : result.get('fc')); 
            decimal prevFC = (decimal) ((result == null || result.get('preFc') == null ) ? 0 : result.get('preFc'));
            decimal rsmFC = (decimal) ((result == null || result.get('rsmFc') == null ) ? 0 : result.get('rsmFc'));
            
            fc = fc / currencyRate / 10000;
            prevFC = prevFC / currencyRate;
            rsmFC = rsmFC / currencyRate;
            obj.currentFC.put(dateKey, fc);
            obj.previousFC.put(dateKey, prevFC);           
            obj.posFC.put(dateKey, 0);
            obj.cmaFC.put(dateKey, 0);
            obj.totalBilling.put(dateKey, 0);
            obj.totalBooking.put(dateKey, 0);
            obj.totalBacklog.put(dateKey, 0);
            obj.totalSA.put(dateKey, 0);
            obj.fc2MAccuracy.put(dateKey, 0);
            obj.fc3MAccuracy.put(dateKey, 0);
            obj.fc6MAccuracy.put(dateKey, 0);
            obj.rsmFC.put(dateKey, rsmFC);
            
            obj.totalBillingQty.put(dateKey, 0);
            obj.totalBookingQty.put(dateKey, 0);
            obj.totalBacklogQty.put(dateKey, 0);
            
            return obj;
        }
    }
    
    public class PartFCObect {
        public String name {get; set;}
        public String gplId {get; set;}
        
        public PartFCObect() {
            this.name = '';
            this.gplId = '';
        }
    }
    
    public class PartViewFields{
        public String partId {get; set;}
        public String gplId {get; set;}
        public String fieldName {get; set;}
        public boolean isHighLighted {get; set;}
        public decimal price{get; set;}
        public String partDesc {get; set;}
        public map<String, String> currentFC {get; set;}
        public map<String, String> previousFC {get; set;}
        public map<String, decimal> billing {get; set;}
        public map<String, decimal> booking {get; set;}
        public map<String, decimal> backlog {get; set;}
        public PartViewFields() {
            this.partId = ''; 
            this.gplId = '';
            this.fieldName = '';
            this.price = 0;
            this.partDesc = '';
            this.currentFC = new map<String, String>();
            this.previousFC = new map<String, String>();
            this.billing = new map<String, decimal>();
            this.booking = new map<String, decimal>();
            this.backlog = new map<String, decimal>();
            this.isHighLighted = false;
        }
        
        public Object assignFCValues(PartViewFields superObj, AggregateResult result, String dateKey, decimal currencyRate) {
            
            PartViewFields obj = (PartViewFields) superObj;
            
            RelayFCObj relayFCObj = new RelayFCObj();
            //relayFCObj.price = (decimal) ((result == null || result.get('price') == null) ? 0 : result.get('price'));
            relayFCObj.price = superObj.price;
            relayFCObj.quantity = (decimal) ((result == null || result.get('quantity') == null) ? 0 : result.get('quantity')); 

            //relayFCObj.price = relayFCObj.price / currencyRate;
            
            RelayFCObj preRelayFCObj = new RelayFCObj();
            //preRelayFCObj.price = (decimal) ((result == null || result.get('prePrice') == null) ? 0 : result.get('prePrice'));
            preRelayFCObj.price = superObj.price;
            preRelayFCObj.quantity = (decimal) ((result == null || result.get('preQuantity') == null) ? 0 : result.get('preQuantity'));   
 
            //preRelayFCObj.price = preRelayFCObj.price / currencyRate;
            String partDesc = (String) ((result == null || result.get('partDesc') == null ) ? '' : result.get('partDesc'));
            obj.partDesc = (obj.partDesc == '' ? partDesc : obj.partDesc);
            
            obj.currentFC.put(dateKey, JSON.serialize(relayFCObj));
            obj.previousFC.put(dateKey, JSON.serialize(preRelayFCObj));
            
            return obj;
        }
        
        public PartViewFields assignRefData(PartViewFields partObj, AggregateResult result, String dateKey, decimal currencyRate, boolean isMonthly) {
            
            decimal billing = (decimal) ((result == null || result.get('billing') == null) ? 0 : result.get('billing'));
            decimal booking = (decimal) ((result == null || result.get('booking') == null) ? 0 : result.get('booking'));
            decimal backlog = (decimal) ((isMonthly || result == null || result.get('backlog') == null) ? 0 : result.get('backlog'));
            
            billing = billing / currencyRate; 
            booking = booking / currencyRate; 
            backlog = backlog / currencyRate; 

            billing += (partObj.billing.containsKey(dateKey) ? partObj.billing.get(dateKey) : 0);
            booking += (partObj.booking.containsKey(dateKey) ? partObj.booking.get(dateKey) : 0);
            backlog += (partObj.backlog.containsKey(dateKey) ? partObj.backlog.get(dateKey) : 0);
            
            
            partObj.billing.put(dateKey, billing);
            partObj.booking.put(dateKey, booking);
            partObj.backlog.put(dateKey, backlog);
            
            return partObj;
        }
        
        public PartViewFields assignRefBacklogData(PartViewFields partObj, AggregateResult result, String dateKey, decimal currencyRate) {

            decimal backlog = (decimal) ((result == null || result.get('backlog') == null) ? 0 : result.get('backlog'));
            backlog = backlog / currencyRate; 
            backlog += (partObj.backlog.containsKey(dateKey) ? partObj.backlog.get(dateKey) : 0);
            
            partObj.backlog.put(dateKey, backlog);
            
            return partObj;
        }                
    }
    ///*<<<InnerClass*/
    //********************************* -=END inner classes=- *************************************

}