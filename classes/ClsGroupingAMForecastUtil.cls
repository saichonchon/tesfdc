/**
 *  Util class for page CtrlAcctGrouping
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
public without sharing class ClsGroupingAMForecastUtil {
   
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public static final Integer QNUMBER = 5;
    public static final Integer FUTUREQNUMBER = 6;  
    public static final String OTHER = system.label.APL_Other_Accounts;
    public static map<String, Decimal> map_isoCode_exchangeRate; 
    public static map<String, Decimal> map_convertionRate = new Map<String, Decimal>();
    public static final map<String, Integer> MAP_MONTHLABELNUMBER = new map<String, Integer>{
        'Jan' => 4, 'Feb' => 5, 'Mar' => 6, 'Apr' => 7, 'May' => 8, 'Jun' => 9,
        'Jul' => 10, 'Aug' => 11, 'Sep' => 12, 'Oct' => 1, 'Nov' => 2, 'Dec' => 3
    };
    public static final map<Decimal, String> MAP_NUMBERMONTHLABEL = new map<Decimal, String>{   
        4 => 'Jan', 5 => 'Feb', 6 => 'Mar', 7 => 'Apr', 8 => 'May', 9 => 'Jun',
        10 => 'Jul', 11 => 'Aug', 12 => 'Sep', 1 => 'Oct', 2 => 'Nov', 3 => 'Dec'
    };
    public static final map<Integer, String> MAP_MONTH_INT_STRING = new map<Integer, String>{
        1 => '01', 2 => '02', 3 => '03', 4 => '04', 5 => '05', 6 => '06',
        7 => '07', 8 => '08', 9 => '09', 10 => '10', 11 => '11', 12 => '12'
    };
    public static final map<String, set<String>> map_RELAY_CBCFIELD_CBCDESC = new map<String, set<String>> {
        'CBC2__c' => new set<String> {'30005', '13213'},
        'CBC3__c' => new set<String> {'41553'}
        //comment by Lei Tang <lei.tang@capgemini.com> 2017-12-05
        //'CBC3__c' => new set<String> {'40308', '40309'}
    };
    public static final map<String, String> map_CBC2ID_CBC2NAME = new map<String, String>{
        '30012' => 'Power/Signal', '30015' => 'RAST', '30016' => 'Terminals & Splices', '30017' => 'Tubing', '30042' => 'Magnet'
    };
    public static final String ACCTFCTYPE = 'Account';
    public static final String GPLFCTYPE = 'GPL';
    public static final String PARTFCTYPE = 'Part';
    public static final String RELAYFCTYPE = 'Relay';
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
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
    public static void getAcctTotalFCQuery(String managerId, ClsAPLEntityTypes.PageConfig pageConf, list<TotalFCViewFields> list_totalFC) {
        if(pageConf.currentTerritoryCode == '') {
            return ;
        }
        String query = ' Select Fiscal_Year__c year, sum(Forecast_10000__c) fc, Fiscal_Quarter__c quarter ';
        query += ' FROM APL_Sales_Forecast__c ';
        query += ' WHERE Customer__r.SALES_TERRITORY_CDE__c = \'' + pageConf.currentTerritoryCode + '\'';
        String monthFilter = buildMonthFilter(pageConf.map_year_quartersFuture);
        query += (monthFilter == '' ? '' : ' And ' + monthFilter);
        
        String relay_query = query + ' And Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' ' 
                           //+ ClsAPLForecastUtil.getRelayPartQuery()
                           + ' And Customer__r.STATDESC__c = \'Active\' '
                           + ' Group by Fiscal_Year__c, Fiscal_Quarter__c ';
                           
        TotalFCViewFields showTotal = new TotalFCViewFields(' trt_0 trt_trt col ');
        showTotal.fieldName= system.label.APL_Show_Total;
        TotalFCViewFields fcTotal = new TotalFCViewFields(' trt_0 dn fctotal ');
        fcTotal.fieldName= system.label.APL_Total_Forecast;
        TotalFCViewFields tcFC = new TotalFCViewFields(' trt_0 dn tcfctotal ');
        tcFC.fieldName = system.label.APL_TC_Products;
        TotalFCViewFields relayFC = new TotalFCViewFields(' trt_0 dn relayfctotal ');
        relayFC.fieldName = system.label.APL_Relay_Products;
        /*
        TotalFCViewFields overruleRelayFC = new TotalFCViewFields(' trt_0 dn overrulerelayfctotal ');
        overruleRelayFC.fieldName = system.label.APL_Overrule_Relay_Products;
        */
        for(AggregateResult  result : database.query(relay_query)) {
            String parentId = 'Relay';
            String year = (String) result.get('year');
            String quarter = (String) result.get('quarter');
            String dateKey = year + '_' + quarter;
            //build account forecast date map
            relayFC = (TotalFCViewFields) relayFC.assignFCValues(relayFC, result, dateKey);
        }
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
        list_totalFC.add(fcTotal);
        list_totalFC.add(tcFC);
        list_totalFC.add(relayFC);
    //    list_totalFC.add(overruleRelayFC);
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
        String query = ' Select Fiscal_Year__c year, sum(Forecast_10000__c) fc, sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter, ';  //, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
        query += '  Customer__r.APL_AM_forecast_Plan_Account__c parentId, Customer__r.APL_AM_Currency__c currency, sum(Current_month_1_RSM_forecast__c) rsmFC';
        query += ' FROM APL_Sales_Forecast__c ';
        query += ' WHERE Customer__r.SALES_TERRITORY_CDE__c = \'' + pageConf.currentTerritoryCode + '\''
        	   + ' And Customer__r.STATDESC__c = \'Active\' '
               + ' And (Type__c = \'' + GPLFCTYPE + '\' '   
               + '      OR Type__c = \'' + ClsAPLForecastUtil.OTHERFCTYPE + '\' '
               + '      OR (Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' ' 
               //+ ClsAPLForecastUtil.getRelayPartQuery()
               + APL_ClsUtils.getRelayCBC2CodeQuery() 
               + '))';
        String monthFilter = buildMonthFilter(pageConf.map_year_quartersFuture);
        query += (monthFilter == '' ? '' : ' And ' + monthFilter);
        query += ' Group by Customer__r.APL_AM_forecast_Plan_Account__c, Customer__r.APL_AM_Currency__c, Fiscal_Year__c, Fiscal_Quarter__c' ;
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
    public static string buildMonthFilter(map<String, Set<String>> map_year_quarter) {
        string monthFilter = '';
        if(map_year_quarter != null && map_year_quarter.size() > 0) {
            monthFilter += '(';
            for (string year : map_year_quarter.keySet()) {
                if(year != 'null') {
                    monthFilter += '(Fiscal_Year__c = \'' + year +'\'';
                    if(map_year_quarter.get(year) != null && map_year_quarter.get(year).size() > 0) {
                        monthFilter += ' AND Fiscal_Quarter__c IN (';
                        for(String quarter : map_year_quarter.get(year)) {
                            monthFilter += '\'' + quarter + '\', ';
                        }
                        monthFilter = monthFilter.substring(0, monthFilter.lastIndexOf(',')) + ')';
                    }
                    monthFilter += ') OR ';
                }
            }
            monthFilter = monthFilter.substring(0, monthFilter.lastIndexOf(' OR')) + ')';
        }
        return monthFilter;
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
    public static void getAcctForecast(String managerId, ClsAPLEntityTypes.PageConfig pageConf, map<String, ForecastViewFields> map_acctGroupId_fcViewObj) {
        
        map<String, map<String, AggregateResult>> map_acctId_map_dateKey_fcObj = new map<String, map<String, AggregateResult>>();
        map<String, String> map_acctId_currencyIso = new map<String, String>();
        if(pageConf.json_acctCurrency == null || pageConf.json_acctCurrency == '') {
        	return;
        }
        map_acctId_currencyIso = (map<String, String>) Json.deserialize(pageConf.json_acctCurrency, map<String, String>.class);
        
        //get account forecast query
        String query = getAccountFCQuery(managerId, pageConf);
        if(query == '') {
            return;
        }
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'query :: '+ query));
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
        //loop for each future quarter and build forecast view object
        for(String year : pageConf.map_year_quartersFuture.keySet()) {
            for(String quarter : pageConf.map_year_quartersFuture.get(year)) {
                String dateKey = year + '_' + quarter;
                for(String parentId : pageConf.set_parentIds) {
                    decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, 'USD', map_acctId_currencyIso.get(parentId));
                    //create fc view object for each group
                    if(!map_acctGroupId_fcViewObj.containsKey(parentId)) {
                        map_acctGroupId_fcViewObj.put(parentId, new ForecastViewFields());
                    }
                    //assign values for forecast view objects
                    //get related fc view object
                    ForecastViewFields obj = map_acctGroupId_fcViewObj.get(parentId);
                    //get related query data
                    AggregateResult result ;
                    if(map_acctId_map_dateKey_fcObj.containsKey(parentId) && map_acctId_map_dateKey_fcObj.get(parentId).containsKey(dateKey)) {
                        result = map_acctId_map_dateKey_fcObj.get(parentId).get(dateKey);
                    }
                    obj = (ForecastViewFields) obj.assignFCValues(obj, result, dateKey, currencyRate);
                }
            }
        }
        
        system.debug('!@#map_acctGroupId_fcViewObj: '+map_acctGroupId_fcViewObj);
        
        //
    }
    /**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Weihang Li
    @created 2014-06-23
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-23 Weihang Li <weihang.li@itbconsult.com>
    * - Created
    */
    public static String getAMAcctRefData(CtrlGroupingRemoteBase.AcctForecast acctFCInfo) {
        String startDate = ClsAPLForecastUtil.getStartDate(acctFCInfo.list_dateKey[0]),
               endDate = ClsAPLForecastUtil.getEndDate(acctFCInfo.list_dateKey[2]);
        Integer startYear = Integer.valueOf(startDate.subStringBefore('-')), 
               startMonth = Integer.valueOf(startDate.subStringBetween('-', '-')), 
               endYear = Integer.valueOf(endDate.subStringBefore('-')), 
               endMonth = Integer.valueOf(endDate.subStringBetween('-', '-')), 
               currentYear = Integer.valueOf(acctFCInfo.currentYear),
               currentMonth = Integer.valueOf(acctFCInfo.currentMonth); 
        map<String, set<Integer>> map_fiscalMonth = ClsAPLForecastUtil.getFiscalMonthMap(acctFCInfo.list_dateKey);
        ForecastViewFields fcViewObj = new ForecastViewFields();
        Date date_endDate = Date.newInstance(endYear, endMonth, 1);
        Date date_currentDate = Date.newInstance(currentYear, currentMonth, 1);
        Date date_startDate = Date.newInstance(startYear, startMonth, 1);
        decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, 'USD', acctFCInfo.map_acctId_currencyIso.get(acctFCInfo.aid));
        if(date_endDate < date_currentDate) {
            getAcctHistoryRefData(acctFCInfo.aid, acctFCInfo.territoryCode, currencyRate, startDate, endDate, 
                                    acctFCInfo.list_dateKey, fcViewObj);
            getAcctHisBacklogRefData(acctFCInfo.aid, acctFCInfo.territoryCode, currencyRate, startDate, endDate, map_fiscalMonth, 
                                    acctFCInfo.list_dateKey, fcViewObj);
        }
        else if(date_currentDate < date_startDate) {
            getAcctFutureRefData(acctFCInfo.aid, acctFCInfo.territoryCode, currencyRate, startDate, endDate, map_fiscalMonth,
                                    acctFCInfo.list_dateKey, fcViewObj);
        }
        else {
            map<String, set<Integer>> map_history = new map<String, set<Integer>>();
            map<String, set<Integer>> map_future = new map<String, set<Integer>>();
            ClsAPLForecastUtil.getDividedFiscalMap(date_currentDate, acctFCInfo.list_dateKey, map_history, map_future);
            
            String currentEndDate =  ClsAPLForecastUtil.getEndDate(acctFCInfo.currentYear + '_' + acctFCInfo.currentMonth);
            getAcctHistoryRefData(acctFCInfo.aid, acctFCInfo.territoryCode, currencyRate, startDate, currentEndDate,
                                    acctFCInfo.list_dateKey, fcViewObj);
            if(!map_history.isEmpty()) {
                getAcctHisBacklogRefData(acctFCInfo.aid, acctFCInfo.territoryCode, currencyRate, startDate, currentEndDate, map_history,
                                        acctFCInfo.list_dateKey, fcViewObj);
            }
            if(!map_future.isEmpty()) {
            	getAcctCurrentRefData(acctFCInfo.aid, acctFCInfo.territoryCode, currencyRate, acctFCInfo.currentYear, 
            							Integer.valueOf(acctFCInfo.currentMonth), fcViewObj);
                getAcctFutureRefData(acctFCInfo.aid, acctFCInfo.territoryCode, currencyRate, currentEndDate, endDate, map_future,
                                        acctFCInfo.list_dateKey, fcViewObj);
            }
        }
        fcViewObj.cls = String.join(acctFCInfo.list_dateKey, ',');
        return Json.serialize(fcViewObj);   
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
    public static void getAcctHistoryRefData(String parentId, String territoryCode, decimal currencyRate,
                                            String startDate, String endDate, 
                                            list<String> list_dateKey,
                                            ForecastViewFields fcViewObj) {
        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(true, parentId, territoryCode, set_acctIds); 
		      
        list<String> list_sql = new list<String>();
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking, sum(Bill_Quantity__c) billingQty, sum(Book_Quantity__c) bookingQty, Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds ' 
                    + ' And Fiscal_Date__c >= ' + startDate
                    + ' And Fiscal_Date__c < ' + endDate
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' Group by Fiscal_Date__c ' );
        system.debug('getCBC2RefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
       for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;
            
            fcViewObj = fcViewObj.assignRefData(fcViewObj, result, dateKey, currencyRate, true);
        }
        //generate forecast view objects for each quarter
        for(String dateKey : list_dateKey) {
            AggregateResult result;
            fcViewObj = fcViewObj.assignRefData(fcViewObj, result, dateKey, currencyRate, true);
                    
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
    public static void getAcctHisBacklogRefData(String parentId, String territoryCode, decimal currencyRate,
                                                String startDate, String endDate, map<String, set<Integer>> map_fiscalMonth,
                                                list<String> list_dateKey,
                                                ForecastViewFields fcViewObj) {
        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(true, parentId, territoryCode, set_acctIds);
		                                       	
        list<String> list_sql = new list<String>();
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, sum(Backlog_Qty__c) backlogQty, Customer_Request_Date_Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds ' 
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_fiscalMonth)
                    + ' And Backlog_Amount_USD__c != 0 '
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
        system.debug('getCBC2RefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
       for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;
            
            fcViewObj = fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey, currencyRate);
        }
        //generate forecast view objects for each quarter
        for(String dateKey : list_dateKey) {
            AggregateResult result;
            fcViewObj = fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey, currencyRate);
                    
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
    public static void getAcctCurrentRefData(String parentId, String territoryCode, decimal currencyRate,
                                                String year, Integer month,
                                                ForecastViewFields fcViewObj) {
        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(true, parentId, territoryCode, set_acctIds);
		                                       	
        list<String> list_sql = new list<String>();
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking, sum(Bill_Qty__c) billingQty, sum(Book_Qty__c) bookingQty ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        list_sql.add(' WHERE Customer__c IN : set_acctIds ' 
                    + ' And Fiscal_Year__c = \'' + year +'\''
                    + ' And Fiscal_Month__c = ' + month +
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) ');
        system.debug('getCBC2RefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        String dateKey = year + '_' + month;
       	for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
        	fcViewObj = fcViewObj.assignRefData(fcViewObj, result, dateKey, currencyRate, true);
		}
        //generate forecast view objects for each quarter
        AggregateResult result;
        fcViewObj = fcViewObj.assignRefData(fcViewObj, result, dateKey, currencyRate, true);
                    
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
    public static void getAcctFutureRefData(String parentId, String territoryCode, decimal currencyRate,
                                                String startDate, String endDate, map<String, set<Integer>> map_fiscalMonth,
                                                list<String> list_dateKey,
                                                ForecastViewFields fcViewObj) {
        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(true, parentId, territoryCode, set_acctIds);
		
        list<String> list_sql = new list<String>();
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, sum(Backlog_Amount_USD__c) backlogQty, Customer_Request_Date_Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        list_sql.add(' WHERE Customer__c IN : set_acctIds ' 
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_fiscalMonth)
                    + ' And Backlog_Amount_USD__c != 0 '
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' Group by Customer_Request_Date_Fiscal_Date__c' );
        system.debug('getCBC2RefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
       for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;
            
            fcViewObj = fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey, currencyRate);
        }
        //generate forecast view objects for each quarter
        for(String dateKey : list_dateKey) {
            AggregateResult result;
            fcViewObj = fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey, currencyRate);
                    
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
    public static void getAcctInfo(String managerId, ClsAPLEntityTypes.PageConfig pageConf, 
                                    list<AcctForecastItem> list_acctFC,
                                    list<AcctForecastItem> list_otherFC) {
        
        map<String, String> map_acctId_currencyIso = new map<String, String>();
        String query = getAccountQuery(managerId, pageConf);
        if(query == '' || pageConf.currentTerritoryCode == null || pageConf.currentTerritoryCode == '') {
            return;
        }
        AcctForecastItem otherAcctGroup;
        system.debug('getAcctInfo :: ' + query);
        for(AggregateResult result : database.query(query)) {
            String parentId = (String) ((result.get('ParentAcctId') == null || result.get('ParentAcctId') == '') ? OTHER : result.get('ParentAcctId'));
            String displayName = (String) ((result.get('DisplayName') == null || result.get('DisplayName') == '') ? '' : result.get('DisplayName'));
            String currencyIsoCode = (String) result.get('CurrencyCode');
            decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, currencyIsoCode, 'USD');
            
            currencyRate = currencyRate.setScale((pageConf.currencyPlaces == '' ? 4 : Integer.valueOf(pageConf.currencyPlaces)));
            AcctForecastItem groupAcct = new AcctForecastItem();
            groupAcct.acctName = displayName;
            groupAcct.acctISOCode = currencyIsoCode;
            groupAcct.currencyRate = currencyRate;
            groupAcct.parentId = parentId;
            
            if(parentId == OTHER) {
                otherAcctGroup = new AcctForecastItem();
                otherAcctGroup = groupAcct;
                otherAcctGroup.acctName = OTHER;
                otherAcctGroup.acctISOCode = 'USD';
                otherAcctGroup.currencyRate = 1;
            }
            else {
                list_acctFC.add(groupAcct);
            }
            pageConf.set_parentIds.add(parentId);
            //set pageconfig acct currency mapping
            if(!map_acctId_currencyIso.containsKey(parentId)) {
                map_acctId_currencyIso.put(parentId, currencyIsoCode);
            }
        } 
        pageConf.json_acctCurrency = json.serialize(map_acctId_currencyIso);
        //Add other account group as last
        if(otherAcctGroup != null) {
            list_otherFC.add(otherAcctGroup);
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
    public static String getAccountQuery(String managerId, ClsAPLEntityTypes.PageConfig pageConf){
        //String query = '';
        if(pageConf.currentTerritoryCode == null || pageConf.currentTerritoryCode == '') {
            for(APL_Forecast_Management__c forecastManager : [Select Id, A6_Code__c, Manager__c, AM_Freeze__c, RecordType.DeveloperName
                                                              From APL_Forecast_Management__c
                                                              Where Manager__c = : managerId 
                                                              And RecordType.DeveloperName = 'AM'
                                                              And A6_Code__c != null
                                                              limit 1]) {
                pageConf.isRelay = false;
                pageConf.currentTerritoryCode = forecastManager.A6_Code__c;     
                pageConf.isFrozen = forecastManager.AM_Freeze__c;    
            }
        }
        String query  = ' Select APL_AM_forecast_Plan_Account__c ParentAcctId, APL_AM_Display_Name__c DisplayName, APL_AM_Currency__c CurrencyCode ';
        query += ' FROM Account ';
        query += ' WHERE SALES_TERRITORY_CDE__c = \'' + pageConf.currentTerritoryCode + '\' And STATDESC__c = \'Active\' ';
        query += ' Group by APL_AM_forecast_Plan_Account__c, APL_AM_Display_Name__c, APL_AM_Currency__c ';
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
    public static void getCBC2FC(CtrlGroupingRemoteBase.CBC2Forecast cbc_fc){
                                    
        map<String, String> map_cbc2Name_cbcRowKey = new map<String, String>();
        map<String, map<String, AggregateResult>> map_cbc2Name_map_dateKey_result = new map<String, map<String, AggregateResult>>();
        map<String, map<String, GPLViewFields>> map_cbc2Name_map_dateKey_fcViewObj = new map<String, map<String, GPLViewFields>>();
        map<String, GPLViewFields> map_cbc2RowKey_fcViewObj = new map<String, GPLViewFields>();
        String query = getCBC2FCQuery(cbc_fc.aid, cbc_fc.territoryCode, cbc_fc.map_year);
        String relayquery = getRelayCBC2FCQuery(cbc_fc.aid, cbc_fc.territoryCode, cbc_fc.map_year);
        decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, 'USD', cbc_fc.map_acctId_currencyIso.get(cbc_fc.aid));
        
        if(cbc_fc.map_cbcName.isEmpty()) {
            return;
        }
        system.debug('cbc_fc.map_cbcName :: ' + cbc_fc.map_cbcName);
        system.debug('cbc_fc query :: ' + query);
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(query)) {
            String cbc2Name = (String) result.get('cbc2Name');
            String cbc3Name = (String) result.get('cbc3Name');
            String cbcKeyName = ClsAPLForecastUtil.getCBCKeyName(cbc2Name, cbc3Name);
            
            String year = (String) result.get('year');
            String quarter = (String) result.get('quarter');
            String dateKey = year + '_' + quarter;
            if(!map_cbc2RowKey_fcViewObj.containsKey(cbcKeyName)) {
                map_cbc2RowKey_fcViewObj.put(cbcKeyName, new GPLViewFields());
            }
            GPLViewFields gplFC = map_cbc2RowKey_fcViewObj.get(cbcKeyName);
            gplFC = (GPLViewFields) gplFC.assignFCValues(gplFC, result, dateKey, currencyRate);
        }
        
        for(AggregateResult result : database.query(relayquery)) {
            String cbc2Name = (String) result.get('cbc2Name');
            String cbc3Name = (String) result.get('cbc2Name');
            String cbcKeyName = ClsAPLForecastUtil.getCBCKeyName(cbc2Name, cbc3Name);
            
            String year = (String) result.get('year');
            String quarter = (String) result.get('quarter');
            String dateKey = year + '_' + quarter;
            if(!map_cbc2RowKey_fcViewObj.containsKey(cbcKeyName)) {
                map_cbc2RowKey_fcViewObj.put(cbcKeyName, new GPLViewFields());
            }
            GPLViewFields gplFC = map_cbc2RowKey_fcViewObj.get(cbcKeyName);
            gplFC = (GPLViewFields) gplFC.assignFCValues(gplFC, result, dateKey, currencyRate);
        }
        
        //generate forecast view objects for each quarter
        for(String cbc2Name : cbc_fc.map_cbcName.keySet()) {
            for(String year : cbc_fc.map_year.keySet()) {
                for(String quarter : cbc_fc.map_year.get(year)) {
                    String dateKey = year + '_' + quarter;
                    AggregateResult result;
                    if(!map_cbc2RowKey_fcViewObj.containsKey(cbc2Name)) {
                        map_cbc2RowKey_fcViewObj.put(cbc2Name, new GPLViewFields());
                    }
                    
                    GPLViewFields fcObj = map_cbc2RowKey_fcViewObj.get(cbc2Name);
                    fcObj = (GPLViewFields) fcObj.assignFCValues(fcObj, result, dateKey, currencyRate);
                    
                }
            }
        }
        //parser view object into json string bach to front end
        for(String cbc2RowKey : map_cbc2RowKey_fcViewObj.keySet()) {
            String str_json = json.serialize(map_cbc2RowKey_fcViewObj.get(cbc2RowKey));
            cbc_fc.map_cbcName.put(cbc2RowKey, str_json);
        }
        
    }
    
    /**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Weihang Li
    @created 2014-06-23
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-23 Weihang Li <weihang.li@itbconsult.com>
    * - Created
    */
    public static String getAMCBCRefData(CtrlGroupingRemoteBase.CBC2Forecast cbcFCInfo) {
        String startDate = ClsAPLForecastUtil.getStartDate(cbcFCInfo.list_dateKey[0]),
               endDate = ClsAPLForecastUtil.getEndDate(cbcFCInfo.list_dateKey[2]);
        Integer startYear = Integer.valueOf(startDate.subStringBefore('-')), 
               startMonth = Integer.valueOf(startDate.subStringBetween('-', '-')), 
               endYear = Integer.valueOf(endDate.subStringBefore('-')), 
               endMonth = Integer.valueOf(endDate.subStringBetween('-', '-')), 
               currentYear = Integer.valueOf(cbcFCInfo.currentYear),
               currentMonth = Integer.valueOf(cbcFCInfo.currentMonth); 
        map<String, set<Integer>> map_fiscalMonth = ClsAPLForecastUtil.getFiscalMonthMap(cbcFCInfo.list_dateKey);
        GPLViewFields fcViewObj = new GPLViewFields();
        Date date_endDate = Date.newInstance(endYear, endMonth, 1);
        Date date_currentDate = Date.newInstance(currentYear, currentMonth, 1);
        Date date_startDate = Date.newInstance(startYear, startMonth, 1);
        decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, 'USD', cbcFCInfo.map_acctId_currencyIso.get(cbcFCInfo.aid));
        if(date_endDate < date_currentDate) {
            getCBCHistoryRefData(cbcFCInfo.aid, cbcFCInfo.territoryCode, currencyRate, startDate, endDate, cbcFCInfo.cbcCode, 
                                    cbcFCInfo.list_dateKey, fcViewObj);
            getCBCHisBacklogRefData(cbcFCInfo.aid, cbcFCInfo.territoryCode, currencyRate, startDate, endDate, map_fiscalMonth, cbcFCInfo.cbcCode,
                                    cbcFCInfo.list_dateKey, fcViewObj);
        }
        else if(date_currentDate < date_startDate) {
            getCBCFutureRefData(cbcFCInfo.aid, cbcFCInfo.territoryCode, currencyRate, startDate, endDate, map_fiscalMonth, cbcFCInfo.cbcCode,
                                    cbcFCInfo.list_dateKey, fcViewObj);
        }
        else {
            String currentEndDate =  ClsAPLForecastUtil.getEndDate(cbcFCInfo.currentYear + '_' + cbcFCInfo.currentMonth);
            map<String, set<Integer>> map_history = new map<String, set<Integer>>();
            map<String, set<Integer>> map_future = new map<String, set<Integer>>();
            ClsAPLForecastUtil.getDividedFiscalMap(date_currentDate, cbcFCInfo.list_dateKey, map_history, map_future);
            
            getCBCHistoryRefData(cbcFCInfo.aid, cbcFCInfo.territoryCode, currencyRate, startDate, currentEndDate, cbcFCInfo.cbcCode, 
                                    cbcFCInfo.list_dateKey, fcViewObj);
            if(!map_history.isEmpty()) {
                getCBCHisBacklogRefData(cbcFCInfo.aid, cbcFCInfo.territoryCode, currencyRate, startDate, currentEndDate, map_history, cbcFCInfo.cbcCode,
                                    cbcFCInfo.list_dateKey, fcViewObj);
            }
            if(!map_future.isEmpty()) {
            	getCBCCurrentRefData(cbcFCInfo.aid, cbcFCInfo.territoryCode, currencyRate, cbcFCInfo.currentYear, 
            							Integer.valueOf(cbcFCInfo.currentMonth), cbcFCInfo.cbcCode, fcViewObj);
                getCBCFutureRefData(cbcFCInfo.aid, cbcFCInfo.territoryCode, currencyRate, currentEndDate, endDate, map_future, cbcFCInfo.cbcCode,
                                    cbcFCInfo.list_dateKey, fcViewObj);
            }
            
        }
        fcViewObj.cls = String.join(cbcFCInfo.list_dateKey, ',');
        fcViewObj.fieldName = cbcFCInfo.cbcCode;
        return Json.serialize(fcViewObj);   
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
                                            String startDate, String endDate, String cbcCode, 
                                            list<String> list_dateKey,
                                            GPLViewFields fcViewObj) {
        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(true, parentId, territoryCode, set_acctIds);
                                               
        list<String> list_sql = new list<String>();
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking, Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds ' 
                    + (cbcCode == ClsAPLForecastUtil.CBCOTHER ? ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\'', '') : '')
                    + (cbcCode == ClsAPLForecastUtil.CBCRELAY ? ClsAPLForecastUtil.getRelayPartQuery() : '')
                    + ((cbcCode != ClsAPLForecastUtil.CBCOTHER && cbcCode != ClsAPLForecastUtil.CBCRELAY) 
                                    ? 'And Part__r.Product_Hierarchy__r.CBC2__c = \'' + cbcCode +'\'' : '')
                                    
                    + ' And Fiscal_Date__c >= ' + startDate
                    + ' And Fiscal_Date__c < ' + endDate
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
                    + ' Group by Fiscal_Date__c ' );
        system.debug('getCBC2RefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
       for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;
            
            fcViewObj = (GPLViewFields) fcViewObj.assignRefData(fcViewObj, result, dateKey, currencyRate, true);
        }
        //generate forecast view objects for each quarter
        for(String dateKey : list_dateKey) {
            AggregateResult result;
            fcViewObj = fcViewObj.assignRefData(fcViewObj, result, dateKey, currencyRate, true);
                    
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
    public static void getCBCHisBacklogRefData(String parentId, String territoryCode, decimal currencyRate,
                                                String startDate, String endDate, map<String, set<Integer>> map_fiscalMonth,
                                                String cbcCode, list<String> list_dateKey,
                                                GPLViewFields fcViewObj) {
        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(true, parentId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds ' 
                    + (cbcCode == ClsAPLForecastUtil.CBCOTHER ? ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\'', '') : '')
                    + (cbcCode == ClsAPLForecastUtil.CBCRELAY ? ClsAPLForecastUtil.getRelayPartQuery() : '')
                    + ((cbcCode != ClsAPLForecastUtil.CBCOTHER && cbcCode != ClsAPLForecastUtil.CBCRELAY) 
                                    ? 'And Part__r.Product_Hierarchy__r.CBC2__c = \'' + cbcCode +'\'' : '')
                                    
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_fiscalMonth)
                    + ' And Backlog_Amount_USD__c != 0 '
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
        system.debug('getCBC2RefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
       for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;
            
            fcViewObj = (GPLViewFields) fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey, currencyRate);
        }
        //generate forecast view objects for each quarter
        for(String dateKey : list_dateKey) {
            AggregateResult result;
            fcViewObj = fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey, currencyRate);
                    
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
    public static void getCBCCurrentRefData(String parentId, String territoryCode, decimal currencyRate,
                                                String year, Integer month, String cbcCode, 
                                                GPLViewFields fcViewObj) {
        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(true, parentId, territoryCode, set_acctIds);
        
        list<String> list_sql = new list<String>();
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        list_sql.add(' WHERE Customer__c IN : set_acctIds ' 
                    + (cbcCode == ClsAPLForecastUtil.CBCOTHER ? ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace(' And  Type__c = \'Part\'', '') : '')
                    + (cbcCode == ClsAPLForecastUtil.CBCRELAY ? ClsAPLForecastUtil.getRelayPartQuery() : '')
                    + ((cbcCode != ClsAPLForecastUtil.CBCOTHER && cbcCode != ClsAPLForecastUtil.CBCRELAY) 
                                    ? ' And Part__r.Product_Hierarchy__r.CBC2__c = \'' + cbcCode +'\'' : '')
                    + ' And Fiscal_Year__c = \'' + year +'\''
                    + ' And Fiscal_Month__c = ' + month +
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) ');
        system.debug('getCBC2RefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        String dateKey = year + '_' + month;
		for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            
            fcViewObj = (GPLViewFields) fcViewObj.assignRefData(fcViewObj, result, dateKey, currencyRate, true);
        }
        //generate forecast view objects for each quarter
        AggregateResult result;
        fcViewObj = fcViewObj.assignRefData(fcViewObj, result, dateKey, currencyRate, true);
                    
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
    public static void getCBCFutureRefData(String parentId, String territoryCode, decimal currencyRate,
                                                String startDate, String endDate, map<String, set<Integer>> map_fiscalMonth,
                                                String cbcCode, list<String> list_dateKey,
                                                GPLViewFields fcViewObj) {
        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(true, parentId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        list_sql.add('sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        list_sql.add(' WHERE Customer__c IN : set_acctIds ' 
                    + (cbcCode == ClsAPLForecastUtil.CBCOTHER ? ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace(' And  Type__c = \'Part\'', '') : '')
                    + (cbcCode == ClsAPLForecastUtil.CBCRELAY ? ClsAPLForecastUtil.getRelayPartQuery() : '')
                    + ((cbcCode != ClsAPLForecastUtil.CBCOTHER && cbcCode != ClsAPLForecastUtil.CBCRELAY) 
                                    ? ' And Part__r.Product_Hierarchy__r.CBC2__c = \'' + cbcCode +'\'' : '')
                                    
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_fiscalMonth)
                    + ' And Backlog_Amount_USD__c != 0 '
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' Group by Customer_Request_Date_Fiscal_Date__c' );
        system.debug('getCBC2RefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
       for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;
            
            fcViewObj = (GPLViewFields) fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey, currencyRate);
        }
        //generate forecast view objects for each quarter
        for(String dateKey : list_dateKey) {
            AggregateResult result;
            fcViewObj = fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey, currencyRate);
                    
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
    public static String getCBC2FCQuery(String parentId, String territoryCode, map<String, set<String>> map_year_quartersFuture) {
        
        String query = ' Select Fiscal_Year__c year, sum(Forecast_10000__c) fc, sum(Current_month_1_RSM_forecast__c) rsmFC, '  //, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
                     + ' sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter, GPL__r.CBC2__c cbc2Name, GPL__r.CBC3__c cbc3Name ';
        query += ' FROM APL_Sales_Forecast__c ';
        query += ' WHERE Id != null';
        
        String monthFilter = buildMonthFilter(map_year_quartersFuture);
        query += (monthFilter == '' ? '' : ' And ' + monthFilter);
        String str_filter = getForecastParentFilter(parentId, territoryCode, false);
        str_filter += (' AND  (Type__c = \'' + GPLFCTYPE + '\' ' 
                    + ' OR (Type__c = \'' + ClsAPLForecastUtil.OTHERFCTYPE + '\' and Part__c = null )' 
                    //+ ' OR (Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' ' 
                    //+ ClsAPLForecastUtil.getRelayPartQuery()
                    + ') And Customer__r.STATDESC__c = \'Active\' ');
        String groupby = ' Group by GPL__r.CBC2__c, GPL__r.CBC3__c, Fiscal_Year__c, Fiscal_Quarter__c' ;
        query += (str_filter + groupby);
        
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
    public static String getRelayCBC2FCQuery(String parentId, String territoryCode, map<String, set<String>> map_year_quartersFuture) {
        
        String query = ' Select Fiscal_Year__c year, sum(Forecast_10000__c) fc, sum(Current_month_1_RSM_forecast__c) rsmFC, '  //, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
                     + ' sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter, Relay_CBC2_Code__c cbc2Name ';
        query += ' FROM APL_Sales_Forecast__c ';
        query += ' WHERE Id != null';
        
        String monthFilter = buildMonthFilter(map_year_quartersFuture);
        query += (monthFilter == '' ? '' : ' And ' + monthFilter);
        String str_filter = getForecastParentFilter(parentId, territoryCode, false);
        str_filter += (' AND Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' ' 
                        + APL_ClsUtils.getRelayCBC2CodeQuery()
                    + ' And Customer__r.STATDESC__c = \'Active\' ');
        String groupby = ' Group by Relay_CBC2_Code__c, Fiscal_Year__c, Fiscal_Quarter__c' ;
        query += (str_filter + groupby);
        
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
    public static String getRelayCBC2FC(CtrlGroupingRemoteBase.GPLInfo gpl) {
        
        map<String, GPLViewFields> map_cbcKey_fcViewObj = new map<String, GPLViewFields>();
        list<GPLViewFields> list_tempFC = new list<GPLViewFields>();
        list<String> list_sortedRelayCBC = ClsAPLForecastUtil.getSortedRelayCBCKey();
        
        String query = ' Select Fiscal_Year__c year, sum(Forecast_10000__c) fc, sum(Current_month_1_RSM_forecast__c) rsmFC, '  //, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
                     + ' sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter, PRODUCT_CDE__c procode, PROD_NAME__c proname ';//Part__r.Product_Hierarchy__r.CBC2__c cbc2Name, Part__r.Product_Hierarchy__r.CBC3__c cbc3Name ';
        query += ' FROM APL_Sales_Forecast__c ';
        query += ' WHERE Id != null And Customer__r.STATDESC__c = \'Active\' ';
        String monthFilter = buildMonthFilter(gpl.map_year);
        query += (monthFilter == '' ? '' : ' And ' + monthFilter);
        String str_filter = getForecastParentFilter(gpl.aid, gpl.territoryCode, false);
        str_filter +=  ' And Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' '+ APL_ClsUtils.getRelayCBC2CodeQuery();
        String groupby = ' Group by PROD_NAME__c, PRODUCT_CDE__c, Fiscal_Year__c, Fiscal_Quarter__c' ;
        query += (str_filter + groupby);
        decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, 'USD', gpl.map_acctId_currencyIso.get(gpl.aid));
        
        system.debug('map_cbcKey_fcViewObj query :: ' + query);
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(query)) {
            String cbcKeyName = (String) result.get('procode');
            //String cbc3Name = (String) result.get('cbc3Name');
            //String cbcKeyName = ClsAPLForecastUtil.getRelayCBCKey(cbc2Name, cbc3Name);
            
            String year = (String) result.get('year');
            String quarter = (String) result.get('quarter');
            String dateKey = year + '_' + quarter;
            if(!map_cbcKey_fcViewObj.containsKey(cbcKeyName)) {
                map_cbcKey_fcViewObj.put(cbcKeyName, new GPLViewFields());
            }
            GPLViewFields gplFC = map_cbcKey_fcViewObj.get(cbcKeyName);
            gplFC = (GPLViewFields) gplFC.assignFCValues(gplFC, result, dateKey, currencyRate);
        }
        //generate forecast view objects for each quarter
        for(String cbc2Name : list_sortedRelayCBC) {
            for(String year : gpl.map_year.keySet()) {
                for(String quarter : gpl.map_year.get(year)) {
                    String dateKey = year + '_' + quarter;
                    AggregateResult result;
                    if(!map_cbcKey_fcViewObj.containsKey(cbc2Name)) {
                        map_cbcKey_fcViewObj.put(cbc2Name, new GPLViewFields());
                    }
                    
                    GPLViewFields fcObj = map_cbcKey_fcViewObj.get(cbc2Name);
                    fcObj = (GPLViewFields) fcObj.assignFCValues(fcObj, result, dateKey, currencyRate);
                    
                }
            }
        }
        //parser view object into json string bach to front end
        for(String cbc2RowKey : list_sortedRelayCBC) {
        	GPLViewFields gplFC = map_cbcKey_fcViewObj.get(cbc2RowKey);
            gplFC.fieldName = ClsAPLForecastUtil.map_RELAY_CBCCode_CBCDESC.get(cbc2RowKey);
            gplFC.gplCode = cbc2RowKey;
            gplFC.prodHichyId = cbc2RowKey;
        	list_tempFC.add(gplFC);
        }
        String str_json = json.serialize(list_tempFC);
        return str_json;
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
    public static String getGPLFC(String cbc2Name, CtrlGroupingRemoteBase.GPLInfo gpl) {
        
        map<String, GPLViewFields> map_gplId_fcViewObj = new map<String, GPLViewFields>();
        String query = getGPLFCQuery(gpl.aid, cbc2Name, gpl.territoryCode, gpl.map_year);
        map<String, map<String, AggregateResult>> map_gplId_map_dateKey_result = new map<String, map<String, AggregateResult>>();
        set<String> set_gplNames = new set<String>();
        map<String, String> map_gplId_gplName = new map<String, String>();
        map<String, String> map_prodHichyId_gplCode = new map<String, String>();
        map<String, decimal> map_gpl_billPercent = new map<String, decimal>();
        decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, 'USD', gpl.map_acctId_currencyIso.get(gpl.aid));
        //get gpl names from product hierchary
        String str_prodHichyQuery = ' select Id, GPL_Description__c, Name From Product_Hierarchy__c where CBC1_Description__c = \'Appliances\' ';
        str_prodHichyQuery += (cbc2Name == 'Relay' ? getRelayGPLQuery(true) : ' And CBC2__c =\'' + cbc2Name + '\' '); 
        system.debug('str_prodHichyQuery :: ' + str_prodHichyQuery);
        for(Product_Hierarchy__c prodHchy : database.query(str_prodHichyQuery)) {
            if(prodHchy.GPL_Description__c != null) {
                map_prodHichyId_gplCode.put(prodHchy.Id, prodHchy.Name);
                map_gplId_gplName.put(prodHchy.Id, prodHchy.GPL_Description__c);
            }
        }
        //build gpl result map
        system.debug('query :: ' + query);
        for(AggregateResult result : database.query(query)) {
            String gplId = (String) result.get('gplId');
            String year = (String) result.get('year');
            String quarter = (String) result.get('quarter');
            String dateKey = year + '_' + quarter;
            if(!map_gplId_map_dateKey_result.containsKey(gplId)) {
                map_gplId_map_dateKey_result.put(gplId, new map<String, AggregateResult>());
            }
            if(!map_gplId_map_dateKey_result.get(gplId).containsKey(dateKey)) {
                map_gplId_map_dateKey_result.get(gplId).put(dateKey, result);
            }
        }
        //build gpl forecast list for each month
        for(String gplId : map_prodHichyId_gplCode.keySet()) {
            for(String year : gpl.map_year.keySet()) {
                for(String quarter : gpl.map_year.get(year)) {
                    String dateKey = year + '_' + quarter;
                    AggregateResult result;
                    if(map_gplId_map_dateKey_result.containsKey(gplId) && map_gplId_map_dateKey_result.get(gplId).containsKey(dateKey)) {
                        result = map_gplId_map_dateKey_result.get(gplId).get(dateKey);
                    }
                    if(!map_gplId_fcViewObj.containsKey(gplId)) {
                        GPLViewFields gplFC = new GPLViewFields();
                        gplFC.prodHichyId = gplId;
                        gplFC.fieldName = map_gplId_gplName.get(gplId);
                        gplFC.gplCode = map_prodHichyId_gplCode.get(gplId);
                        map_gplId_fcViewObj.put(gplId, gplFC);
                    }
                    GPLViewFields obj = map_gplId_fcViewObj.get(gplId);
                    obj = (GPLViewFields) obj.assignFCValues(obj, result, dateKey, currencyRate);
                    //assignValuesForFCViewOjb(obj, result, dateKey);
                }
            }
        }
        //get gpl billing percentages from history data
        if(gpl.isNeedBillPercentage) {
	        setGPLBillPercent(cbc2Name, gpl.quarterNumb, gpl.territoryCode, gpl.aid, map_gpl_billPercent, map_gplId_fcViewObj.keySet());
	        if(!map_gpl_billPercent.isEmpty()) {
	            for(String gplId : map_gplId_fcViewObj.keySet()) {
	                GPLViewFields gplFC = map_gplId_fcViewObj.get(gplId);
	                gplFC.precent = (map_gpl_billPercent.containsKey(gplId) ? map_gpl_billPercent.get(gplId) : 0);
	            }
	        }
        }

		APL_ClsUtils.setAMGPLHighlight(cbc2Name, gpl, map_gplId_fcViewObj);
		
        list<GPLViewFields> list_tempGPL = map_gplId_fcViewObj.values();
        list_tempGPL.sort();
        system.debug('list_tempGPL :: ' + list_tempGPL);
        return json.serialize(list_tempGPL);
    }
    /**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Weihang Li
    @created 2014-06-23
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-23 Weihang Li <weihang.li@itbconsult.com>
    * - Created
    */
    public static String getAMGPLRefData(CtrlGroupingRemoteBase.GPLInfo amGPL) {
        String startDate = ClsAPLForecastUtil.getStartDate(amGPL.list_dateKey[0]),
               endDate = ClsAPLForecastUtil.getEndDate(amGPL.list_dateKey[2]);
        Integer startYear = Integer.valueOf(startDate.subStringBefore('-')), 
               startMonth = Integer.valueOf(startDate.subStringBetween('-', '-')), 
               endYear = Integer.valueOf(endDate.subStringBefore('-')), 
               endMonth = Integer.valueOf(endDate.subStringBetween('-', '-')), 
               currentYear = Integer.valueOf(amGPL.currentYear),
               currentMonth = Integer.valueOf(amGPL.currentMonth); 
        map<String, set<Integer>> map_fiscalMonth = ClsAPLForecastUtil.getFiscalMonthMap(amGPL.list_dateKey);
        GPLViewFields fcViewObj = new GPLViewFields();
        Date date_endDate = Date.newInstance(endYear, endMonth, 1);
        Date date_currentDate = Date.newInstance(currentYear, currentMonth, 1);
        Date date_startDate = Date.newInstance(startYear, startMonth, 1);
        decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, 'USD', amGPL.map_acctId_currencyIso.get(amGPL.aid));
        //
        if(date_endDate < date_currentDate) {
            getGPLHistoryRefData(amGPL.aid, amGPL.territoryCode, currencyRate, amGPL.gplId, amGPL.cbcCode, startDate, endDate,
                                amGPL.list_dateKey, fcViewObj);
            getGPLHisBacklogRefData(amGPL.aid, amGPL.territoryCode, currencyRate, amGPL.gplId, amGPL.cbcCode, startDate, endDate, map_fiscalMonth,
                                amGPL.list_dateKey, fcViewObj);
        }
        else if(date_currentDate < date_startDate) {
            getGPLFutureRefData(amGPL.aid, amGPL.territoryCode, currencyRate, amGPL.gplId, amGPL.cbcCode, startDate, endDate, map_fiscalMonth,
                                amGPL.list_dateKey, fcViewObj);
        }
        else {
            String currentEndDate =  ClsAPLForecastUtil.getEndDate(amGPL.currentYear + '_' + amGPL.currentMonth);
            map<String, set<Integer>> map_history = new map<String, set<Integer>>();
            map<String, set<Integer>> map_future = new map<String, set<Integer>>();
            ClsAPLForecastUtil.getDividedFiscalMap(date_currentDate, amGPL.list_dateKey, map_history, map_future);
            getGPLHistoryRefData(amGPL.aid, amGPL.territoryCode, currencyRate, amGPL.gplId, amGPL.cbcCode, startDate, currentEndDate, 
                                amGPL.list_dateKey, fcViewObj);
            if(!map_history.isEmpty()) {
                getGPLHisBacklogRefData(amGPL.aid, amGPL.territoryCode, currencyRate, amGPL.gplId, amGPL.cbcCode, startDate, currentEndDate, map_history,
                                    amGPL.list_dateKey, fcViewObj);
            }
            if(!map_future.isEmpty()) {
            	getGPLCurrentRefData(amGPL.aid, amGPL.territoryCode, currencyRate, amGPL.gplId, amGPL.cbcCode,
                                      amGPL.currentYear, Integer.valueOf(amGPL.currentMonth), fcViewObj);
                getGPLFutureRefData(amGPL.aid, amGPL.territoryCode, currencyRate, amGPL.gplId, amGPL.cbcCode, currentEndDate, endDate, map_future,
                                    amGPL.list_dateKey, fcViewObj);
            }
            

        }
                                
        fcViewObj.cls = String.join(amGPL.list_dateKey, ',');
        return json.serialize(fcViewObj);                   
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
    public static String getGPLFCQuery(String parentId, String str_cbc2Name, String territoryCode, map<String, set<String>> map_year_quartersFuture) {
        
        String query = ' Select Fiscal_Year__c year, sum(Forecast_10000__c) fc, sum(Current_month_1_RSM_forecast__c) rsmFC, '			//, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
                     + ' sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter, GPL__c gplId';
        query += ' FROM APL_Sales_Forecast__c ';
        query += ' WHERE Id != null ';
        query += (str_cbc2Name == 'Relay' ? getRelayGPLQuery(false) : ' And GPL__r.CBC2__c =\'' + str_cbc2Name + '\' '); 
        
        String monthFilter = buildMonthFilter(map_year_quartersFuture);
        query += (monthFilter == '' ? '' : ' And ' + monthFilter);
        
        String str_filter = getForecastParentFilter(parentId, territoryCode, false);
        str_filter += ' And Type__c = \'' + (str_cbc2Name == 'Relay' ? RELAYFCTYPE : GPLFCTYPE) + '\' And Customer__r.STATDESC__c = \'Active\' ';
        String str_groupby = ' Group by GPL__c, Fiscal_Year__c, Fiscal_Quarter__c' ;
        
        query += (str_filter + str_groupby);
        
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
    public static void getGPLHistoryRefData(String parentId, String territoryCode, decimal currencyRate, String gplId, String cbcCode, 
                                            String startDate, String endDate,
                                            list<String> list_dateKey, GPLViewFields fcViewObj) {
        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(true, parentId, territoryCode, set_acctIds);
                                                
        list<String> list_sql = new list<String>();
        map<String, map<String, AggregateResult>> map_gplId_map_dateKey_result = new map<String, map<String, AggregateResult>>();
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking, Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds ' 
                    + (cbcCode == 'Relay' ? ClsAPLForecastUtil.getRelayCBCFilter(gplId) : ' And Part__r.Product_Hierarchy__c = \'' + gplId + '\'')
                    + ' And Fiscal_Date__c >= ' + startDate
                    + ' And Fiscal_Date__c < ' + endDate
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0 ) '
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' Group by Fiscal_Date__c');
        system.debug('getCBC2RefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;
            
            fcViewObj = fcViewObj.assignRefData(fcViewObj, result, dateKey, currencyRate, true);
        }
        //generate forecast view objects for each quarter
        for(String dateKey : list_dateKey) {
            AggregateResult result;
            fcViewObj = fcViewObj.assignRefData(fcViewObj, result, dateKey, currencyRate, true);
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
    public static void getGPLHisBacklogRefData(String parentId, String territoryCode, decimal currencyRate, String gplId, String cbcCode,
                                                String startDate, String endDate, map<String, set<Integer>> map_fiscalMonth,
                                                list<String> list_dateKey, GPLViewFields fcViewObj) {
        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(true, parentId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        map<String, map<String, AggregateResult>> map_gplId_map_dateKey_result = new map<String, map<String, AggregateResult>>();
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        list_sql.add(' WHERE Customer__c IN : set_acctIds ' 
                    + (cbcCode == 'Relay' ? ClsAPLForecastUtil.getRelayCBCFilter(gplId) : ' And Part__r.Product_Hierarchy__c = \'' + gplId + '\'')
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_fiscalMonth)
                    + ' And Backlog_Amount_USD__c != 0 '
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' Group by Customer_Request_Date_Fiscal_Date__c ' );
                        
        system.debug('getCBCFutureRefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;
            fcViewObj = fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey, currencyRate);
        }
        //generate forecast view objects for each quarter
        for(String dateKey : list_dateKey) {
            AggregateResult result;
            fcViewObj = fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey, currencyRate);
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
    public static void getGPLCurrentRefData(String parentId, String territoryCode, decimal currencyRate, String gplId, String cbcCode,
                                            String year, Integer month, GPLViewFields fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(true, parentId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds ' 
                    + (cbcCode == 'Relay' ? ClsAPLForecastUtil.getRelayCBCFilter(gplId) : ' And Part__r.Product_Hierarchy__c = \'' + gplId + '\'')
                    + ' And Fiscal_Year__c = \'' + year +'\''
                    + ' And Fiscal_Month__c = ' + month +
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0 ) ' );          
        system.debug('getCBCFutureRefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        String dateKey = year + '_' + month;
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            fcViewObj = fcViewObj.assignRefData(fcViewObj, result, dateKey, currencyRate, true);
        }
        //generate forecast view objects for each quarter
        AggregateResult result;
        fcViewObj = fcViewObj.assignRefData(fcViewObj, result, dateKey, currencyRate, true);
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
    public static void getGPLFutureRefData(String parentId, String territoryCode, decimal currencyRate, String gplId, String cbcCode,
                                            String startDate, String endDate, map<String, set<Integer>> map_fiscalMonth,
                                            list<String> list_dateKey, GPLViewFields fcViewObj) {
        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(true, parentId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds ' 
                    + (cbcCode == 'Relay' ? ClsAPLForecastUtil.getRelayCBCFilter(gplId) : ' And Part__r.Product_Hierarchy__c = \'' + gplId + '\'')
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_fiscalMonth)
                    + ' And Backlog_Amount_USD__c != 0 '
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' Group by Customer_Request_Date_Fiscal_Date__c ' );          
        system.debug('getCBCFutureRefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;
            
            fcViewObj = fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey, currencyRate);
        }
        //generate forecast view objects for each quarter
        for(String dateKey : list_dateKey) {
            AggregateResult result;
            fcViewObj = fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey, currencyRate);
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
    public static String getReferenceRelayGPLQuery() {
        String str_relayQuery = 'And ( TEMP ) ';
        String tempQuery = '';
        for(String cbcField : map_RELAY_CBCFIELD_CBCDESC.keySet()) {
            for(String cbcName : map_RELAY_CBCFIELD_CBCDESC.get(cbcField)) {
                tempQuery += 'Part__r.Product_Hierarchy__r.' + cbcField + ' = \'' + cbcName + '\' OR '; 
            }
        }
        tempQuery = tempQuery.removeEnd('OR ');
        str_relayQuery = str_relayQuery.replace('TEMP', tempQuery);
        return str_relayQuery;
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
    public static String getPartFC(CtrlGroupingRemoteBase.PartInfo part, boolean isRelayPart, boolean isOther) {
        
        map<String, PartViewFields> map_partId_fcViewObj = new map<String, PartViewFields>();
        String query = getPartFCQuery(part.aid, part.gplId, part.territoryCode, isRelayPart, isOther, part.map_year);
        map<String, map<String, AggregateResult>> map_partId_map_dateKey_result = new map<String, map<String, AggregateResult>>();
        map<String, String> map_partId_partName = new map<String, String>();
        set<String> set_highLightParts = new set<String>();
        decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, 'USD', part.map_acctId_currencyIso.get(part.aid));
        //get all high light parts
        getPartHighlight(part.aid, part.gplId, part.territoryCode, isRelayPart, isOther, part.map_year, set_highLightParts);
        
        //build gpl result map
        system.debug('getPartFC query :: ' + query);
        setPartFCQueryResult(query, map_partId_map_dateKey_result, map_partId_partName);
        
        
        //get gpl names from product hierchary
        setMapPartIdName(map_partId_partName);   
        //build gpl forecast list for each month
        for(String partId : map_partId_partName.keySet()) {
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
                        partFC.fieldName = map_partId_partName.get(partId);
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
        //Get part reference data 
        if(part.map_year_monthsHistory != null && !part.map_year_monthsHistory.isEmpty()) {
            getPartHistoryRefData(part.aid, part.territoryCode, currencyRate, part.gplId, isRelayPart, isOther, part.map_year_monthsHistory, map_partId_fcViewObj);   
        }
        if(part.refStartDate != null && part.periodStartDate != null) {
            getPartHisBacklogRefData(part.aid, part.territoryCode, currencyRate, part.gplId, isRelayPart, isOther, part.periodStartDate, part.refStartDate, part.map_year_monthsHistory,
                                map_partId_fcViewObj);
        }
        if(part.refStartDate != null && part.refEndDate != null) {
        	getPartCurrentRefData(part.aid, part.territoryCode, currencyRate, part.gplId, isRelayPart, part.isOther,
                                            part.currentYear, Integer.valueOf(part.currentMonth), map_partId_fcViewObj);
            getPartFutureRefData(part.aid, part.territoryCode, currencyRate, part.gplId, isRelayPart, isOther, part.refStartDate, part.refEndDate, part.map_year_monthsFuture,
                                map_partId_fcViewObj);
        }
        
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
        map<String, PartViewFields> map_partId_fcViewObj = new map<String, PartViewFields>();
        decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, 'USD', part.map_acctId_currencyIso.get(part.aid));
        //if part ids is null return null
        if(part.set_partIds == null || part.set_partIds.isEmpty()) {
            return json.serialize(map_partId_fcViewObj);
        }
        for(String partId : part.set_partIds) {
            PartViewFields partFC = new PartViewFields();
            partFC.partId = partId;
            map_partId_fcViewObj.put(partId, partFC);
        }
        //Get part reference data 
        if(part.map_year_monthsHistory != null && !part.map_year_monthsHistory.isEmpty()) {
            getPartHistoryRefData(part.aid, part.territoryCode, currencyRate, part.gplId, false, part.isOther, part.map_year_monthsHistory, map_partId_fcViewObj);   
        }
        if(part.refStartDate != null && part.periodStartDate != null) {
            getPartHisBacklogRefData(part.aid, part.territoryCode, currencyRate, part.gplId, false, part.isOther, part.periodStartDate, part.refStartDate, part.map_year_monthsHistory,
                                map_partId_fcViewObj);
        }
        if(part.refStartDate != null && part.refEndDate != null) {
        	getPartCurrentRefData(part.aid, part.territoryCode, currencyRate, part.gplId, false, part.isOther,
                                            part.currentYear, Integer.valueOf(part.currentMonth), map_partId_fcViewObj);
            getPartFutureRefData(part.aid, part.territoryCode, currencyRate, part.gplId, false, part.isOther, part.refStartDate, part.refEndDate, part.map_year_monthsFuture,
                                map_partId_fcViewObj);
        }
        return json.serialize(map_partId_fcViewObj);
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
    public static void getPartHistoryRefData(String parentId, String territoryCode, decimal currencyRate, String gplId,
                                            boolean isRelayPart, boolean isOther,
                                            map<String, set<Integer>> map_year_monthsHistory,
                                            map<String, PartViewFields> map_partId_fcViewObj) {
                                                
        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(true, parentId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        map<String, map<String, PartViewFields>> map_partId_map_dateKey_result = new map<String, map<String, PartViewFields>>();
        set<String> set_partIds = new set<String>();
        set_partIds.addAll(map_partId_fcViewObj.keySet());
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking, Fiscal_Date__c fiscal_date, '
                    + ' Part__c partId ');
        list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds ' 
                    + (isRelayPart ? ClsAPLForecastUtil.getRelayCBCFilter(gplId) : getPartSearchQueryFilter(gplId, isOther, true))
                    + ' And Part__c IN : set_partIds '
                    + (ClsAPLForecastUtil.getFiscalMonthFilter(map_year_monthsHistory) == '' ? '' 
                            : ClsAPLForecastUtil.getFiscalMonthFilter(map_year_monthsHistory))
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0 ) '     
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '  
                    + ' Group by Fiscal_Date__c, Part__c'
                    );

        system.debug('getPartHistoryRefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
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
        }
        //generate forecast view objects for each quarter
        for(String partId : map_partId_fcViewObj.keySet()) {
            for(String year : map_year_monthsHistory.keySet()) {
                for(Integer month : map_year_monthsHistory.get(year)) {
                    String dateKey = year + '_' + month;
                    AggregateResult result;
                    
                    PartViewFields fcObj = map_partId_fcViewObj.get(partId);
                    fcObj = fcObj.assignRefData(fcObj, result, dateKey, currencyRate, true);
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
    public static void getPartHisBacklogRefData(String parentId, String territoryCode, decimal currencyRate, String gplId,
                                            boolean isRelayPart, boolean isOther,
                                            String backlogStartDate, String backlogEndDate,
                                            map<String, set<Integer>> map_year_monthsFuture,
                                            map<String, PartViewFields> map_partId_fcViewObj) {
        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(true, parentId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        map<String, map<String, PartViewFields>> map_partId_map_dateKey_result = new map<String, map<String, PartViewFields>>();
        set<String> set_partIds = new set<String>();
        set_partIds.addAll(map_partId_fcViewObj.keySet());
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date,  Part__c partId ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        list_sql.add(' WHERE Customer__c IN : set_acctIds ' 
                    + (isRelayPart ? ClsAPLForecastUtil.getRelayCBCFilter(gplId) : getPartSearchQueryFilter(gplId, isOther, true))
                    + ' And Part__c IN : set_partIds '
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_year_monthsFuture)
                    + ' And Backlog_Amount_USD__c != 0 '
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + 'Group by Customer_Request_Date_Fiscal_Date__c, Part__c '
                    );
                    
        system.debug('getPartFutureRefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
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
            partFC = (PartViewFields) partFC.assignHisBacklogRefData(partFC, result, dateKey, currencyRate);
        }
        //generate forecast view objects for each quarter
        for(String partId : map_partId_fcViewObj.keySet()) {
            for(String year : map_year_monthsFuture.keySet()) {
                for(Integer month : map_year_monthsFuture.get(year)) {
                    String dateKey = year + '_' + month;
                    AggregateResult result;
                    
                    PartViewFields fcObj = map_partId_fcViewObj.get(partId);
                    fcObj = fcObj.assignHisBacklogRefData(fcObj, result, dateKey, currencyRate);
                    
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
    public static void getPartCurrentRefData(String parentId, String territoryCode, decimal currencyRate, String gplId,
                                            boolean isRelayPart, boolean isOther,
                                            String year, Integer month,
                                            map<String, PartViewFields> map_partId_fcViewObj) {
        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(true, parentId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        map<String, map<String, PartViewFields>> map_partId_map_dateKey_result = new map<String, map<String, PartViewFields>>();
        set<String> set_partIds = new set<String>();
        set_partIds.addAll(map_partId_fcViewObj.keySet());
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking, Part__c partId ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds ' 
                    + (isRelayPart ? ClsAPLForecastUtil.getRelayCBCFilter(gplId) : getPartSearchQueryFilter(gplId, isOther, true))
                    + ' And Part__c IN : set_partIds '
                    + ' And Fiscal_Year__c = \'' + year +'\''
                    + ' And Fiscal_Month__c = ' + month +
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0 ) '
                    + 'Group by Part__c '
                    );
                    
        system.debug('getPartFutureRefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        String dateKey = year + '_' + month;
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String partId = (String) result.get('partId');
            if(!map_partId_fcViewObj.containsKey(partId)) {
                map_partId_fcViewObj.put(partId, new PartViewFields());
            }
            PartViewFields partFC = map_partId_fcViewObj.get(partId);
            partFC = (PartViewFields) partFC.assignRefData(partFC, result, dateKey, currencyRate, true);
        }
        //generate forecast view objects for each quarter
        for(String partId : map_partId_fcViewObj.keySet()) {
            AggregateResult result;
            
            PartViewFields fcObj = map_partId_fcViewObj.get(partId);
            fcObj = fcObj.assignRefData(fcObj, result, dateKey, currencyRate, false);
                    
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
    public static void getPartFutureRefData(String parentId, String territoryCode, decimal currencyRate, String gplId,
                                            boolean isRelayPart, boolean isOther,
                                            String refStartDate, String refEndDate,
                                            map<String, set<Integer>> map_year_monthsFuture,
                                            map<String, PartViewFields> map_partId_fcViewObj) {
        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(true, parentId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        map<String, map<String, PartViewFields>> map_partId_map_dateKey_result = new map<String, map<String, PartViewFields>>();
        set<String> set_partIds = new set<String>();
        set_partIds.addAll(map_partId_fcViewObj.keySet());
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date, '
                    + ' Part__c partId ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds ' 
                    + (isRelayPart ? ClsAPLForecastUtil.getRelayCBCFilter(gplId) : getPartSearchQueryFilter(gplId, isOther, true))
                    + ' And Part__c IN : set_partIds '
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_year_monthsFuture)
                    + ' And Backlog_Amount_USD__c != 0 '
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + 'Group by Customer_Request_Date_Fiscal_Date__c, Part__c '
                    );
                    
        system.debug('getPartFutureRefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
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
            partFC = (PartViewFields) partFC.assignHisBacklogRefData(partFC, result, dateKey, currencyRate);
        }
        //generate forecast view objects for each quarter
        for(String partId : map_partId_fcViewObj.keySet()) {
            for(String year : map_year_monthsFuture.keySet()) {
                for(Integer month : map_year_monthsFuture.get(year)) {
                    String dateKey = year + '_' + month;
                    AggregateResult result;
                    
                    PartViewFields fcObj = map_partId_fcViewObj.get(partId);
                    fcObj = fcObj.assignHisBacklogRefData(fcObj, result, dateKey, currencyRate);
                    
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
    
    public static void setPartFCQueryResult(String query, map<String, map<String, AggregateResult>> map_partId_map_dateKey_result, map<String, String> map_partId_partName) {
        for(AggregateResult result : database.query(query)) {
            String partId = (String) result.get('partId');
            String year = (String) result.get('year');
            String quarter = (String) result.get('quarter');
            String dateKey = year + '_' + quarter;
            if(!map_partId_map_dateKey_result.containsKey(partId)) {
                map_partId_map_dateKey_result.put(partId, new map<String, AggregateResult>());
            }
            if(!map_partId_map_dateKey_result.get(partId).containsKey(dateKey)) {
                map_partId_map_dateKey_result.get(partId).put(dateKey, result);
            }
            map_partId_partName.put(partId, '');
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
    public static String getPartFCQuery(String parentId, String gplId, String territoryCode, boolean isRelayPart,
                                         boolean isOther, map<String, set<String>> map_year_quartersFuture) {
        
        String query = ' Select Fiscal_Year__c year, sum(Forecast_10000__c) fc, sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter, Part__c partId, Part__r.Description__c partDesc, sum(Current_month_1_RSM_forecast__c) rsmFC ';
        //query += ' sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC ';
        query += ' FROM APL_Sales_Forecast__c ';
        query += ' WHERE Id != null And Customer__r.STATDESC__c = \'Active\' ';
        //query += getPartSearchQueryFilter(gplId, isOther, true);
        query += (isRelayPart ? ClsAPLForecastUtil.getRelayCBCFilter(gplId) : getPartSearchQueryFilter(gplId, isOther, true));
        String monthFilter = buildMonthFilter(map_year_quartersFuture);
        query += (monthFilter == '' ? '' : ' And ' + monthFilter);
        
        String str_filter = getForecastParentFilter(parentId, territoryCode, false);
        //str_filter += ' And Type__c = \'' + PARTFCTYPE + '\'';
        str_filter += ' And Type__c = \'' + (isRelayPart ? RELAYFCTYPE : PARTFCTYPE) + '\'';
        String str_groupby = ' Group by Fiscal_Year__c, Fiscal_Quarter__c, Part__c, Part__r.Description__c' ;
        
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
    public static void getPartHighlight(String parentId, String gplId, String territoryCode, 
                                        boolean isRelayPart, boolean isOther, 
                                        map<String, set<String>> map_year_quartersFuture, set<String> set_highLightParts) {
        
        String query = getPartHighlightQuery(parentId, gplId, territoryCode, isRelayPart, isOther, map_year_quartersFuture, true);
        map<String, set<String>> map_partId_set_acctIds = new map<String, set<String>>();
        Integer minPartCounter = 0;
        system.debug('query:::975::'+query);
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
                                               boolean isRelayPart, boolean isOther, 
                                               map<String, set<String>> map_year_quartersFuture, boolean isForHighlight) {
        
        String query = ' Select ' + (isForHighlight ? ' Customer__c acctId, Part__c partId ' : ' Part__c partId ');
        query += ' FROM APL_Sales_Forecast__c ';
        query += ' WHERE Id != null And Customer__r.STATDESC__c = \'Active\' ';
        //query += getPartSearchQueryFilter(gplId, isOther, true);
        query += (isRelayPart ? ClsAPLForecastUtil.getRelayCBCFilter(gplId) : getPartSearchQueryFilter(gplId, isOther, true));
        String monthFilter = buildMonthFilter(map_year_quartersFuture);
        system.debug('map_year_quartersFuture :: ' + map_year_quartersFuture);
        system.debug('monthFilter :: ' + monthFilter);
        query += (monthFilter == '' ? '' : ' And ' + monthFilter);
        
        String str_filter = getForecastParentFilter(parentId, territoryCode, false);
        //str_filter += ' And Type__c = \'' + PARTFCTYPE + '\'';
        str_filter += ' And Type__c = \'' + (isRelayPart ? RELAYFCTYPE : PARTFCTYPE) + '\'';
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
    public static void addPart(String parentId, String cbcCode, String territoryCode, String gplId, String partName,
                               String quarterNumb, boolean isTop, boolean isOther, list<PartObj> list_parts, 
                               map<String, set<String>> map_year_quartersFuture, set<String> set_newAddedpartIds) {
        //only get current fc to check if this part has forecast
        map_year_quartersFuture = new map<String, set<String>>();
        String currentYearQuart = ClsAPLForecastUtil.getCurrentYearQuart();
        String year = currentYearQuart.substringBefore('_');
        String quarter = currentYearQuart.substringAfter('_');
        map_year_quartersFuture.put(year, new set<String>{quarter});
        
        if(isTop) {
            map<String, decimal> map_partId_billPercent = new map<String, decimal>();
            list_parts.addAll(setPartBillPercent(cbcCode, gplId, territoryCode, quarterNumb, parentId, isOther, map_partId_billPercent, set_newAddedpartIds));
            system.debug('list_parts :: ' + list_parts);
        }
        else {
            set<String> set_existPartIds = new set<String>();
            //filter part ids for already added parts
            if(!set_newAddedpartIds.isEmpty()) {
                set_existPartIds.addAll(set_newAddedpartIds);
            }
            String existPartIdQuery = getPartHighlightQuery(parentId, gplId, territoryCode, false, isOther, map_year_quartersFuture, false);
            system.debug('existPartIdQuery :: ' + existPartIdQuery);
            setExistPartIds(set_existPartIds, existPartIdQuery);
            String query = getPartQuery(gplId, partName, isOther, set_existPartIds);
            system.debug('Search part :: ' + query);
            
            setListPartObjs(list_parts, query, set_existPartIds);
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
    public static String getPartQuery(String gplId, String partName, boolean isOther, set<String> set_existPartIds) {
        set<String> set_partIds = new set<String>();
        set_partIds.addAll(set_existPartIds);
        String query = ' Select Id, Name, Description__c ';
        query += ' FROM Part__c ';
        query += ' WHERE Id != null ';        
        //query += getPartSearchQueryFilter(gplId, isOther, false);
        query += getPartSearchQueryFilter(gplId, isOther, false);
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
    public static void setExistPartIds(set<String> set_existPartIds, String existPartIdQuery) {
        for(AggregateResult result : database.query(existPartIdQuery)) {
            String partId = (String) result.get('partId');
            set_existPartIds.add(partId);
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
    public static void setListPartObjs(list<PartObj> list_parts, String query, set<String> set_existPartIds) {
        set<String> set_partIds = new set<String>();
        set_partIds.addAll(set_existPartIds);
        for(Part__c part : database.query(query)) {
            PartObj partObj = new PartObj();
            partObj.partId = part.Id;
            partObj.partName = part.Name;
            partObj.description = (part.Description__c == null ? '' : part.Description__c);
            list_parts.add(partObj);
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
    public static String getPartSearchQueryFilter(String gplId, boolean isOther, boolean isForecast) {
        String filter = '';
        if(isOther) {
            filter += getOtherSearchQueryFilter(isForecast);
        }
        else {
            filter += ' And ' + (isForecast ? 'Part__r.' : '' ) + 'Product_Hierarchy__c = \'' + gplId + '\' ';
        }
        
        return filter;
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
    public static String getRelayPartSearchQueryFilter(String gplId, boolean isOther, boolean isForecast) {
        String filter = '';
        if(isOther) {
            filter += getOtherSearchQueryFilter(true);
        }
        else {
            filter += ' And '+(isForecast ? 'Part__r.' : '' ) + 'Product_Hierarchy__r.' + getRelayField(gplId) + ' = \'' + gplId + '\' ';
        }
        
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
        //system.debug('relayField:::' + relayField);
        return relayField;
    }

    
   /**
    * This method is used to get the BillPercent as the GPL
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
    public static void setGPLBillPercent(String CBC2Code, String quarterNumb, String territoryCode, String groupId, 
                                         map<String, decimal> map_GPL_billPercent, set<String> set_allGPLs) {
    
        decimal totalAmount = 0;
        set<String> set_gplIds = new set<String>();
        getGPLIds(CBC2Code, set_gplIds);
        if(set_gplIds.isEmpty()) {
        	return;
        }
        // get the query for GPL level begin 
        String query = 'select SUM(Bill_Amount_current_prior__c) amount, '
                     + ' Part__r.Product_Hierarchy__c key '
                     + ' From BBB_Year_Bill_Book_Cust_PN__c '
                     //+ ' Where Bill_Amount_current_prior__c != null And Bill_Amount_current_prior__c != 0 '
                     //+ ' And Part__r.Product_Hierarchy__c IN : set_gplIds '
                     + ' Where  Part__r.Product_Hierarchy__c IN : set_gplIds '
                     + ' And BU_Profit_Center__c IN (\'APL\', \'RPA\') '
                     + ' And Customer__r.STATDESC__c = \'Active\' ';
        query += getForecastParentFilter(groupId, territoryCode, false);
        query += ' group by Part__r.Product_Hierarchy__c ';
        //end 
		system.debug('query :: ' + query);
        // get the GPL to the amount begin
        for(AggregateResult  result : database.query(query)) {
            decimal amount = (decimal) (result.get('amount') == null ? 0 : result.get('amount'));
            totalAmount += amount;                                      
            map_GPL_billPercent.put((String)result.get('key'), amount); 
        }
        //build billing percent map for all gpls
        for(String gpl : set_allGPLs) {
            if(!map_GPL_billPercent.containsKey(gpl)) {
                map_GPL_billPercent.put(gpl, 0);
            }
        }
        // get the Percent for GPL level begin
        calcPercentage(map_GPL_billPercent, totalAmount);

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
    public static void getGPLIds(String cbcCode, set<String> set_gplIds) {        
        
        String query = ' select Id, GPL_Description__c, Name '
                     + ' From Product_Hierarchy__c '
                     + ' where CBC1_Description__c = \'Appliances\' '
                     + (cbcCode == 'Relay' ? getRelayGPLQuery(true) : ' And CBC2__c =\'' + cbcCode + '\' '); 
        system.debug('str_prodHichyQuery :: ' + query);
        for(Product_Hierarchy__c prodHchy : database.query(query)) {
            set_gplIds.add(prodHchy.Id);
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
    public static list<PartObj> setPartBillPercent(String CBC2Code, String GPL, String territoryCode, String quarterNumb, 
                                                    String groupId, Boolean isOther, 
                                                    map<String, decimal> map_partId_billPercent,
                                                    set<String> set_existingParts) {
    
        decimal allValue = 0;
        map<String, decimal> map_partId_amount = new map<String, decimal>();
        set<String> existPartIds = new set<String>();
        existPartIds.addAll(set_existingParts);
        // get the query for Part level begin 
        String query = ' select SUM(Bill_Amount_current_prior__c) amount, Part__c key '
                     + ' From BBB_Year_Bill_Book_Cust_PN__c '
                     + ' Where Id != null '
                     + ' And Bill_Amount_current_prior__c != null And Bill_Amount_current_prior__c != 0 '
                     + ' And BU_Profit_Center__c IN (\'APL\', \'RPA\') '
                     + ' And Customer__r.STATDESC__c = \'Active\' '
                     + (!existPartIds.isEmpty() ? ' And Part__c not in : existPartIds ' : '');
        query += getForecastParentFilter(groupId, territoryCode, false);
        query += ' AND CBC2_Code__c = \'' + CBC2Code + '\' ';
        query += (isOther ? getOtherSearchQueryFilter(true) : ' AND Part__r.Product_Hierarchy__c = \'' + GPL + '\' ');  
        query += ' group by Part__c ';
        // end
		
        // get the part to the amount begin
        for(AggregateResult  result : database.query(query)) {
            decimal amount = (decimal) (result.get('amount') == null ? 0 : result.get('amount'));
            allValue += amount;                                     
            map_partId_amount.put((String)result.get('key'), amount); 
        }
        
        // get the Percent for Part level begin
        setBillPercent(allValue, map_partId_amount, map_partId_billPercent);
        list<PartObj> list_partObj = getPartObj(map_partId_billPercent);
        return list_partObj;
        // end
    }
    
    /**
    * This method is used to get the QueryFilter as the other
    *
    @author Lili Zhao
    @created 2014-05-14
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-05-14 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static String getOtherSearchQueryFilter(boolean isForecast) {
        
        String filter = '';
        for(String cbc2Name : map_CBC2ID_CBC2NAME.keySet()) {
            filter += ' And ' + (isForecast ? 'Part__r.' : '' ) + 'Product_Hierarchy__r.CBC2__c != \'' + cbc2Name + '\' '; 
        }
        for(String cbcField : map_RELAY_CBCFIELD_CBCDESC.keySet()) {
            for(String cbcName : map_RELAY_CBCFIELD_CBCDESC.get(cbcField)) {
                filter += ' And ' + (isForecast ? 'Part__r.' : '' ) + 'Product_Hierarchy__r.' + cbcField + ' != \'' + cbcName + '\' '; 
            }
        }
        return filter;
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
    public static list<PartObj> getPartObj(map<String, decimal> map_partId_billPercent) {
        list<PartObj> list_partObj = new list<PartObj>();
        list<PartObj> list_partObjReturn = new list<PartObj>();
        map<String, String> map_partId_name = new map<String, String>();
        for(Part__c part : [Select Id, Name, Description__c 
                            from Part__c 
                            where Id IN: map_partId_billPercent.keySet()]) {
            PartObj partObj = new PartObj();        
            partObj.partId = part.Id;
            partObj.partName = part.Name;
            partObj.precent = map_partId_billPercent.get(part.Id);
            partObj.description = (part.Description__c == null ? '' : part.Description__c);
            list_partObj.add(partObj);
        }
        
        list_partObj.sort();
        for(Integer m=0; m < list_partObj.size(); m++) {
            list_partObjReturn.add(list_partObj[m]);
            if(m == 4) return list_partObjReturn;
        }
        
        return list_partObjReturn;
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
    public static boolean deletePart(String parentId, String territoryCode, boolean isOther, String cbc2Code, String gplId, String partId) {
        list<APL_Sales_Forecast__c> list_aplFC = new list<APL_Sales_Forecast__c>();
        String query = ' Select Id From APL_Sales_Forecast__c WHERE Id != null ';
        query += getForecastParentFilter(parentId, territoryCode, false);
        query += getPartSearchQueryFilter(gplId, isOther, true);
        query += ' And Part__c = \'' + partId + '\'';
        query += ' And Type__c = \'Part\' ';
        try {
            system.debug('deletePart query :: ' + query);
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
        //modified by chenchen
        /*String filter = (parentId == OTHER ? 
                        ' And ' + (isAcct ? '' : 'Customer__r.') + 'SALES_TERRITORY_CDE__c = \'' + territoryCode +'\' And ' + (isAcct ? '' : 'Customer__r.') + 'APL_AM_forecast_Plan_Account__c = null'
                        : ' And ' + (isAcct ? '' : 'Customer__r.') + 'APL_AM_forecast_Plan_Account__c = \'' + parentId + '\'' + ' And ' + (isAcct ? '' : 'Customer__r.') + 'SALES_TERRITORY_CDE__c = \'' + territoryCode +'\' ');*/
        String filter = ((parentId == OTHER || parentId == 'customother') ? 
                        ' And ' + (isAcct ? '' : 'Customer__r.') + 'SALES_TERRITORY_CDE__c = \'' + territoryCode +'\' And ' + (isAcct ? '' : 'Customer__r.') + 'APL_AM_forecast_Plan_Account__c = null'
                        : ' And ' + (isAcct ? '' : 'Customer__r.') + 'APL_AM_forecast_Plan_Account__c = \'' + parentId + '\'' + ' And ' + (isAcct ? '' : 'Customer__r.') + 'SALES_TERRITORY_CDE__c = \'' + territoryCode +'\' ');
        return filter;
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
    public static void saveAcctFC(ClsAPLForecastObjects.AccountObject acctFC) {
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
    public static void saveGPLAndPartFC(ClsAPLForecastObjects.GplObject gplFC) {
                                            
        map<String, decimal> map_acctId_gplPercent = new map<String, decimal>();
        map<String, decimal> map_acctId_avgPercent = new map<String, decimal>();
        map<String, map<String, decimal>> map_partId_map_acctId_partPercent = new map<String, map<String, decimal>>();
        map<String, map<String, APL_Sales_Forecast__c>> map_acctId_map_dateKey_fc 
            = new map<String, map<String, APL_Sales_Forecast__c>>();
            
        map<String, map<String, map<String, APL_Sales_Forecast__c>>> map_partId_map_acctId_map_dateKey_fc 
            = new map<String, map<String, map<String, APL_Sales_Forecast__c>>>();
            
        list<APL_Sales_Forecast__c> list_acctFC2Insert = new list<APL_Sales_Forecast__c>();
        list<APL_Sales_Forecast__c> list_acctFC2Update = new list<APL_Sales_Forecast__c>();
        list<APL_Sales_Forecast__c> list_acctFC2Delete = new list<APL_Sales_Forecast__c>();
        system.debug('saveGPLAndPartFC :: ' + gplFC);
        //get gpl percent and parts percent
        getGPLPercentForSave(gplFC.parentId, gplFC.gplId, gplFC.territoryCode, gplFC.quarterNumb, false, map_acctId_gplPercent, 
                                map_acctId_avgPercent, map_partId_map_acctId_partPercent);
        system.debug('map_acctId_gplPercent :: ' + map_acctId_gplPercent);
        system.debug('map_partId_map_acctId_partPercent :: ' + map_partId_map_acctId_partPercent);
        //get existing gpl forecast
        getExistingGPLFC(gplFC.parentId, gplFC.gplId, gplFC.territoryCode, gplFC.quarterNumb, gplFC.map_year_quartersFuture,
                         map_acctId_map_dateKey_fc);
        //generate or update gpl forecast records
        generateFC(map_acctId_gplPercent, gplFC.map_dateKey_fc, map_acctId_map_dateKey_fc, 
                    GPLFCTYPE, gplFC.gplId, '', gplFC.currencyIso, list_acctFC2Insert, list_acctFC2Update, list_acctFC2Delete);
        system.debug('GPL list_acctFC2Insert :: ' + list_acctFC2Insert);
        system.debug('GPL list_acctFC2Update :: ' + list_acctFC2Update);
        system.debug('gplFC.list_partFC :: ' + gplFC.list_partFC);
        //get existing part forecasts
        getExistingPartFC(gplFC.parentId, gplFC.gplId, gplFC.territoryCode, gplFC.quarterNumb, false,
                            gplFC.map_year_quartersFuture, map_partId_map_acctId_map_dateKey_fc);
        //generate or update part forecast records              
        generatePartFC(gplFC.list_partFC, map_partId_map_acctId_partPercent, map_partId_map_acctId_map_dateKey_fc, gplFC.gplId,
                       map_acctId_avgPercent, list_acctFC2Insert, list_acctFC2Update, list_acctFC2Delete);             
        system.debug('Part list_acctFC2Insert :: ' + list_acctFC2Insert);
        
        //INSERT, UPDATE, DELETE APL Forecasts
        aplFCRecordsDML(list_acctFC2Insert, list_acctFC2Update, list_acctFC2Delete);
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
    public static void saveOtherCBCPartFC(ClsAPLForecastObjects.OtherCBCObject otherCBCFC) {
        //system.debug('!@#otherCBCFC : '+otherCBCFC);
        ClsAPLForecastObjects.PartObject po = new ClsAPLForecastObjects.PartObject();
        po.map_dateKey_fc = otherCBCFC.map_dateKey_fc;
        po.partId = 'null';
        po.currencyIso = otherCBCFC.currencyIso;
        otherCBCFC.list_partFC = new list<ClsAPLForecastObjects.PartObject>();
        otherCBCFC.list_partFC.add(po);
        system.debug('!@#otherCBCFC : '+otherCBCFC);
        map<String, decimal> map_acctId_gplPercent = new map<String, decimal>();  
        map<String, decimal> map_acctId_avgPercent = new map<String, decimal>();                                  
        map<String, map<String, decimal>> map_partId_map_acctId_partPercent = new map<String, map<String, decimal>>();
            
        map<String, map<String, map<String, APL_Sales_Forecast__c>>> map_partId_map_acctId_map_dateKey_fc 
            = new map<String, map<String, map<String, APL_Sales_Forecast__c>>>();
            
        list<APL_Sales_Forecast__c> list_acctFC2Insert = new list<APL_Sales_Forecast__c>();
        list<APL_Sales_Forecast__c> list_acctFC2Update = new list<APL_Sales_Forecast__c>();
        list<APL_Sales_Forecast__c> list_acctFC2Delete = new list<APL_Sales_Forecast__c>();
        //calc gpl percent
        getOtherPercentForSave(otherCBCFC.parentId, otherCBCFC.territoryCode, otherCBCFC.quarterNumb, 
                                map_acctId_avgPercent);
        map_partId_map_acctId_partPercent.put(ClsAPLForecastUtil.OTHERFCTYPE, map_acctId_avgPercent);
        //get existing part forecasts
        getExistingPartFC(otherCBCFC.parentId, '', otherCBCFC.territoryCode, otherCBCFC.quarterNumb, true,
                            otherCBCFC.map_year_quartersFuture, map_partId_map_acctId_map_dateKey_fc);
                            
        //generate or update part forecast records     
        system.debug('!@#map_partId_map_acctId_map_dateKey_fc : '+map_partId_map_acctId_map_dateKey_fc);
        generatePartFC(otherCBCFC.list_partFC, map_partId_map_acctId_partPercent, map_partId_map_acctId_map_dateKey_fc, '',
                       map_acctId_avgPercent, list_acctFC2Insert, list_acctFC2Update, list_acctFC2Delete);
        //INSERT, UPDATE, DELETE APL Forecasts
        system.debug('!@#list_acctFC2Update : '+list_acctFC2Update);
        aplFCRecordsDML(list_acctFC2Insert, list_acctFC2Update, list_acctFC2Delete);
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
    public static void generatePartFC(list<ClsAPLForecastObjects.PartObject> list_partFC, 
                                      map<String, map<String, decimal>> map_partId_map_acctId_partPercent, 
                                      map<String, map<String, map<String, APL_Sales_Forecast__c>>> map_partId_map_acctId_map_dateKey_fc,
                                      String gplId, map<String, decimal> map_acctId_avgPercent,
                                      list<APL_Sales_Forecast__c> list_acctFC2Insert,
                                      list<APL_Sales_Forecast__c> list_acctFC2Update,
                                      list<APL_Sales_Forecast__c> list_acctFC2Delete) {
        
        //generate or update part forecast records                  
        for(ClsAPLForecastObjects.PartObject partFC : list_partFC) {
            String partId = (partFC.partId == 'null' ? ClsAPLForecastUtil.OTHERFCTYPE : partFC.partId);
            String fcType = (partId == ClsAPLForecastUtil.OTHERFCTYPE ? ClsAPLForecastUtil.OTHERFCTYPE : ClsAPLForecastUtil.PARTFCTYPE);
            map<String, map<String, APL_Sales_Forecast__c>> temp_map_acctId_map_dateKey_fc = map_partId_map_acctId_map_dateKey_fc.get(partId);
            map<String, decimal> map_acctId_billingPercent = new map<String, decimal>();
            if(map_partId_map_acctId_partPercent.containsKey(partId)) {
                map_acctId_billingPercent = map_partId_map_acctId_partPercent.get(partId);
            }
            else {
                map_acctId_billingPercent = map_acctId_avgPercent;
            }
            if(temp_map_acctId_map_dateKey_fc == null) {
                temp_map_acctId_map_dateKey_fc = new map<String, map<String, APL_Sales_Forecast__c>>();
            }
            
            generateFC(map_acctId_billingPercent, partFC.map_dateKey_fc, temp_map_acctId_map_dateKey_fc, 
                        fcType, gplId, partId, partFC.currencyIso, list_acctFC2Insert, list_acctFC2Update, list_acctFC2Delete);
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
    public static void aplFCRecordsDML(list<APL_Sales_Forecast__c> list_acctFC2Insert, 
                                       list<APL_Sales_Forecast__c> list_acctFC2Update,
                                       list<APL_Sales_Forecast__c> list_acctFC2Delete) {
        if(!list_acctFC2Insert.isEmpty()) {
            insert list_acctFC2Insert;
        }
        if(!list_acctFC2Update.isEmpty()) {
            update list_acctFC2Update;
        }
        //????? remove dirty records for current parents 
        if(!list_acctFC2Delete.isEmpty()) {
            //delete list_acctFC2Delete;
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
    public static void getExistingGPLFC(String parentId, String gplId, String territoryCode, 
                                        String quartNumb, map<String, set<String>> map_year_quartersFuture,
                                        map<String, map<String, APL_Sales_Forecast__c>> map_acctId_map_dateKey_fc) {
                                            
        String query = ' Select Id, Customer__c, Fiscal_Quarter__c, Fiscal_Year__c, Forecast__c, GAM_Forecast__c '
                     + ' From APL_Sales_Forecast__c '
                     + ' Where Type__c = \'' + GPLFCTYPE + '\' And Customer__r.STATDESC__c = \'Active\' ';
        query += getForecastParentFilter(parentId, territoryCode, false);
        String monthFilter = buildMonthFilter(map_year_quartersFuture);
        query += (monthFilter == '' ? '' : ' And ' + monthFilter);
        query += ' And GPL__c = \'' + gplId + '\'';
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
    public static void getExistingPartFC(String parentId, String gplId, String territoryCode, 
                                        String quartNumb, boolean isOther, 
                                        map<String, set<String>> map_year_quartersFuture,
                                        map<String, map<String, map<String, APL_Sales_Forecast__c>>> map_partId_map_acctId_map_dateKey_fc) {
                                            
        String query = ' Select Id, Customer__c, Fiscal_Quarter__c, Fiscal_Year__c, Part__c, Forecast__c, GAM_Forecast__c '
                     + ' From APL_Sales_Forecast__c '
                     + ' Where Type__c = \'' + (isOther ? ClsAPLForecastUtil.OTHERFCTYPE : ClsAPLForecastUtil.PARTFCTYPE) + '\' ';
        query += getForecastParentFilter(parentId, territoryCode, false);
        String monthFilter = buildMonthFilter(map_year_quartersFuture);
        query += (monthFilter == '' ? '' : ' And ' + monthFilter);
        query += ' And Customer__r.STATDESC__c = \'Active\' ';
        //query += getPartSearchQueryFilter(gplId, isOther, true);
        query += getPartSearchQueryFilter(gplId, isOther, true);
        for(APL_Sales_Forecast__c fc : database.query(query)) {
            String dateKey = fc.Fiscal_Year__c + '_' + fc.Fiscal_Quarter__c;
            String acctId = fc.Customer__c;
            String partId = (fc.Part__c == null ? ClsAPLForecastUtil.OTHERFCTYPE : fc.Part__c);
            
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
    public static void getOtherPercentForSave(String parentId, String territoryCode, String quartNumb, 
                                            map<String, decimal> map_acctId_percent) {
        decimal gplTotalAmount = 0;
        set<String> set_childAcctIds = new set<String>();
        //get all children account ids for current parent
        getChildrenAccts(parentId, territoryCode, set_childAcctIds);
        // get account billing query
        String query = 'select SUM(Bill_Amount_current_prior__c) amount, Customer__c AcctId '
                     + ' From BBB_Year_Bill_Book_Cust_PN__c '
                     + ' Where Bill_Amount_current_prior__c != null '
                     //added by Lei Tang 2017-03-01
                     + ' And Bill_Type__c = \'Direct\' '
                     + ' And BU_Profit_Center__c IN (\'APL\', \'RPA\') '
                     + ' And Customer__r.STATDESC__c = \'Active\' '
                     + ' And Bill_Amount_current_prior__c != 0';
        
        query += getPartSearchQueryFilter('', true, true);
        query += getForecastParentFilter(parentId, territoryCode, false);
        query += ' group by Customer__c';
        //get reference data by account ==> map_acctId_map_partId_billingAmount
        for(AggregateResult result : database.query(query)) {
            String acctId = (String) result.get('AcctId');
            decimal amount = (decimal) (result.get('amount') == null ? 0 : result.get('amount'));
            //build gpl percent map
            if(!map_acctId_percent.containsKey(acctId)) {
                map_acctId_percent.put(acctId, 0);
            }
            map_acctId_percent.put(acctId, (amount + map_acctId_percent.get(acctId)));
            //calc gpl total amount
            gplTotalAmount += amount;
            
        }
        //build gpl account map for all children accounts
        for(String acctId : set_childAcctIds) {
            if(!map_acctId_percent.containsKey(acctId)) {
                map_acctId_percent.put(acctId, 0);
            }
        }
        //calc gpl percent
        calcPercentage(map_acctId_percent, gplTotalAmount);
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
    public static void getGPLPercentForSave(String parentId, String gplId, String territoryCode, String quartNumb, 
                                            boolean isOther, map<String, decimal> map_acctId_gplPercent, 
                                            map<String, decimal> map_acctId_avgPercent,
                                            map<String, map<String, decimal>> map_partId_map_acctId_partPercent) {
        decimal gplTotalAmount = 0;
        map<String, decimal> map_partId_totalAmount = new map<String, decimal>();
        set<String> set_childAcctIds = new set<String>();
        //get all children account ids for current parent
        getChildrenAccts(parentId, territoryCode, set_childAcctIds);
        // get account billing query
        String query = 'select SUM(Bill_Amount_current_prior__c) amount, Part__c PartId, Customer__c AcctId '
                     + ' From BBB_Year_Bill_Book_Cust_PN__c '
                     + ' Where Bill_Amount_current_prior__c != null '
                     //added by Lei Tang 2017-03-01
                     + ' And Bill_Type__c = \'Direct\' '
                     + ' And BU_Profit_Center__c IN (\'APL\', \'RPA\') '
                     + ' And Customer__r.STATDESC__c = \'Active\' '
                     + ' And Bill_Amount_current_prior__c != 0';
        
        query += getPartSearchQueryFilter(gplId, isOther, true);
        query += getForecastParentFilter(parentId, territoryCode, false);
        query += ' group by Part__c, Customer__c';
        //get reference data by part ==> map_acctId_map_partId_billingAmount
        for(AggregateResult result : database.query(query)) {
            String partId = (String) (result.get('PartId') == null ? OTHER : result.get('PartId'));
            String acctId = (String) result.get('AcctId');
            decimal amount = (decimal) (result.get('amount') == null ? 0 : result.get('amount'));
            //build gpl percent map
            if(!map_acctId_gplPercent.containsKey(acctId)) {
                map_acctId_gplPercent.put(acctId, 0);
            }
            map_acctId_gplPercent.put(acctId, (amount + map_acctId_gplPercent.get(acctId)));
            //calc gpl total amount
            gplTotalAmount += amount;
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
        //build gpl account map for all children accounts
        for(String acctId : set_childAcctIds) {
            if(!map_acctId_gplPercent.containsKey(acctId)) {
                map_acctId_gplPercent.put(acctId, 0);
            }
            if(!map_acctId_avgPercent.containsKey(acctId)) {
                map_acctId_avgPercent.put(acctId, 0);
            }
        }
        //calc gpl percent
        calcPercentage(map_acctId_gplPercent, gplTotalAmount);
        //calc account avg percent
        calcPercentage(map_acctId_avgPercent, 0);
        
        //build part percent for all children account
        for(String partId : map_partId_map_acctId_partPercent.keySet()) {
            for(String acctId : set_childAcctIds) {
                if(!map_partId_map_acctId_partPercent.get(partId).containsKey(acctId)) {
                    map_partId_map_acctId_partPercent.get(partId).put(acctId, 0);
                }
            }
            //Calc part percent
            calcPercentage(map_partId_map_acctId_partPercent.get(partId), map_partId_totalAmount.get(partId));
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
    public static void submitAMFC(ClsAPLEntityTypes.RSMTerritoryFCInfo rsmRegion) {
    	list<String> list_sql = new list<String>();
    	list<APL_Forecast_Management__c> list_aplFCManagment = new list<APL_Forecast_Management__c>();
    	list_sql.add(' Id, RSM_Freeze__c, AM_Freeze__c ');
    	list_sql.add(' APL_Forecast_Management__c ');
    	list_sql.add('  Where Manager__c = \'' + rsmRegion.managerId + '\' And  A6_Code__c = \'' + rsmRegion.territoryCode + '\' and RecordTypeId != null ');
    	
    	for(APL_Forecast_Management__c afm : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
    		afm.RSM_Freeze__c = false;
    		afm.AM_Freeze__c = true;
    		list_aplFCManagment.add(afm);
    		system.debug(' afm :: ' + afm);
    	}
    	if(!list_aplFCManagment.isEmpty()) {
    		update list_aplFCManagment;
    	}
    }
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
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
            decimal percent = (totalAmount == 0 ? (1.0 / map_key_percent.size()) : (map_key_percent.get(key) / totalAmount));
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
    private static void generateFC(map<String, decimal> map_acctId_billingPercent, map<String, decimal> map_dateKey_fc,
                                    map<String, map<String, APL_Sales_Forecast__c>> map_acctId_map_dateKey_fc, 
                                    String fcType, String gplId, String partId, String currencyIso, 
                                    list<APL_Sales_Forecast__c> list_acctFC2Insert,
                                    list<APL_Sales_Forecast__c> list_acctFC2Update, 
                                    list<APL_Sales_Forecast__c> list_acctFC2Delete) {
        
        set<String> set_updatedAcctFCIds = new set<String>();
        decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, currencyIso, 'USD');
        if(map_acctId_map_dateKey_fc == null) {
            map_acctId_map_dateKey_fc = new map<String, map<String, APL_Sales_Forecast__c>>();
        }
        //create or update account forecast records
        for(String acctId : map_acctId_billingPercent.keySet()) {
            for(String dateKey : map_dateKey_fc.keySet()) {
                //if has such account percent will not generate apl forecast record for this account
                if(!map_acctId_billingPercent.containsKey(acctId)) {
                    continue;
                }
                String year = dateKey.substringBefore('_');
                String quarter = dateKey.substringAfter('_');
                decimal fc = map_dateKey_fc.get(dateKey);
                decimal gamFC = fc * currencyRate;
                decimal percent = map_acctId_billingPercent.get(acctId);
                
                APL_Sales_Forecast__c acctFC;
                if(map_acctId_map_dateKey_fc.containsKey(acctId) 
                    && map_acctId_map_dateKey_fc.get(acctId).containsKey(dateKey)) {
                
                    acctFC = map_acctId_map_dateKey_fc.get(acctId).get(dateKey);
                    acctFC.Forecast__c = fc * percent;
                    acctFC.GAM_Forecast__c = gamFC * percent;
                    acctFC.RSM_Forecast__c = gamFC * percent;
                    acctFC.currencyIsoCode = currencyIso;
                    acctFC.GPL__c = ((gplId != null && gplId != 'null' && gplId != '')? gplId : null);
                    list_acctFC2Update.add(acctFC);
                    set_updatedAcctFCIds.add(acctFC.Id);
                    system.debug('acctFC u ::' + acctFC);
                }
                else {
                    acctFC = new APL_Sales_Forecast__c();
                    acctFC.currencyIsoCode = currencyIso;
                    acctFC.Customer__c = acctId;
                    acctFC.Type__c = fcType;
                    acctFC.Fiscal_Year__c = year;
                    acctFC.Fiscal_Quarter__c = quarter;
                    acctFC.Forecast__c = fc * percent;
                    acctFC.GAM_Forecast__c = gamFC * percent;
                    acctFC.RSM_Forecast__c = gamFC * percent;
                    acctFC.GPL__c = ((gplId != null && gplId != 'null' && gplId != '')? gplId : null);
                    acctFC.Part__c = (fcType == PARTFCTYPE ? partId : null);
                    list_acctFC2Insert.add(acctFC);
                    system.debug('acctFC i ::' + acctFC);
                }
                
            }
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
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>InnerClass*/
    
    public class AcctForecastItem {
        public String parentId {get; set;}
        public String acctName {get; set;}
        public String acctISOCode {get; set;}
        public decimal currencyRate {get; set;}
        public decimal currentFC {get; set;}
        public decimal previousFC {get; set;}
        public decimal posFC {get; set;}
        public decimal cmaFC {get; set;}
        public decimal totalBilling {get; set;}
        public decimal totalBooking {get; set;}
        public decimal totalBacklog {get; set;}
        public decimal totalSA {get; set;}
        public decimal fc2MAccuracy {get; set;}
        public decimal fc3MAccuracy {get; set;}
        public decimal fc6MAccuracy {get; set;}
        public decimal scheduleAgreement {get; set;}
        public decimal billing {get; set;}
        public decimal booking {get; set;}
        public decimal backlog {get; set;}
        public decimal partFC {get; set;}
        
        public AcctForecastItem() {
            this.parentId = '';
            this.acctName = '';
            this.acctISOCode = '';
            this.currencyRate = 0;
            this.currentFC = 0;
            this.previousFC = 0;
            this.posFC = 0;
            this.cmaFC = 0;
            this.totalBilling = 0;
            this.totalBooking = 0;
            this.totalBacklog = 0;
            this.totalSA = 0;
            this.fc2MAccuracy = 0;
            this.fc3MAccuracy = 0;
            this.fc6MAccuracy = 0;
            this.scheduleAgreement = 0;
            this.billing = 0;
            this.booking = 0;
            this.backlog = 0;
            this.partFC = 0;
        
        }
    }
    
    public class AcctViewColumns {
        public String name {get;set;}
        public String fieldName {get;set;}
        public String cls {get;set;}
        public String matchName {get; set;}
        public Boolean isInput {get; set;}
        public AcctViewColumns(String name, String fieldName, String cls, String matchName, boolean isInput) {
            this.name = name;
            this.fieldName = fieldName;
            this.cls = cls;
            this.matchName = matchName;
            this.isInput = isInput;
        }
    }
    
    public class Cbc2Object{
        public String name{get;set;}
        public String code {get;set;}
        public String fieldName {get;set;}
        public String clsName {get;set;}
        public Cbc2Object(String name, String code, String fieldName, String clsName){
            this.name = name;
            this.code = code;
            this.fieldName = fieldName;
            this.clsName = clsName;
        }
        
    }
    public class TotalFCViewFields {
        public map<String, decimal> map_currentFC {get; set;}
        public String fieldName {get; set;}
        public String clsName {get;set;}
        public String currentFC {get; set;}
        
        public TotalFCViewFields() {
            this.map_currentFC = new map<String, decimal>();
            this.fieldName = '';
            this.clsName = '';
            this.currentFC = '';
        }
        
        public TotalFCViewFields(String clsName) {
            this.map_currentFC = new map<String, decimal>();
            this.fieldName = '';
            this.clsName = clsName;
            this.currentFC = '';
        }
        
        public TotalFCViewFields assignFCValues(TotalFCViewFields superObj, AggregateResult result, String dateKey) {
            TotalFCViewFields obj = (TotalFCViewFields) superObj;
            decimal fc = (decimal) ((result == null || result.get('fc') == null ) ? 0 : result.get('fc'));
            obj.map_currentFC.put(dateKey, fc / 10000);
            return obj;
        }
    }
    public class ForecastViewFields extends FCViewOjb{
        
        public map<String, decimal> posFC {get; set;}
        public map<String, decimal> cmaFC {get; set;}
        public map<String, decimal> totalBilling {get; set;}
        public map<String, decimal> totalBooking {get; set;}
        public map<String, decimal> totalBacklog {get; set;}
        
        public map<String, decimal> totalSA {get; set;}
        public map<String, decimal> fc2MAccuracy {get; set;}
        public map<String, decimal> fc3MAccuracy {get; set;}
        public map<String, decimal> fc6MAccuracy {get; set;}
        
        public ForecastViewFields() {
            this.fieldName = '';
            this.currentFC = new map<String, decimal>();
            this.previousFC = new map<String, decimal>();
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

        }
        
        public override Object assignFCValues(FCViewOjb superObj, AggregateResult result, String dateKey, decimal currencyRate) {
            ForecastViewFields obj = (ForecastViewFields) superObj;
            decimal fc = (decimal) ((result == null || result.get('fc') == null ) ? 0 : result.get('fc'));
            decimal posFC = 0; //(decimal) ((result == null || result.get('posFC') == null ) ? 0 : result.get('posFC'));
            decimal cmaFC = 0; //(decimal) ((result == null || result.get('cmaFC') == null ) ? 0 : result.get('cmaFC'));
            decimal prevFC = (decimal) ((result == null || result.get('prevFC') == null ) ? 0 : result.get('prevFC'));
            decimal rsmFC = (decimal) ((result == null || result.get('rsmFC') == null ) ? 0 : result.get('rsmFC'));
            
            
            fc = currencyRate * fc / 10000; 
            prevFC = currencyRate * prevFC; 
            posFC = currencyRate * posFC; 
            cmaFC = currencyRate * cmaFC; 
            rsmFC = currencyRate * rsmFC; 
            
            fc += (obj.currentFC.containsKey(dateKey) ? obj.currentFC.get(dateKey) : 0);
            prevFC += (obj.previousFC.containsKey(dateKey) ? obj.previousFC.get(dateKey) : 0);
            rsmFC += (obj.rsmFC.containsKey(dateKey) ? obj.rsmFC.get(dateKey) : 0);
            
            obj.currentFC.put(dateKey, fc);
            obj.previousFC.put(dateKey, prevFC);
            obj.posFC.put(dateKey, posFC);
            obj.cmaFC.put(dateKey, cmaFC);
            obj.rsmFC.put(dateKey, rsmFC);
            
            //empty values for follow maps
            obj.totalBilling.put(dateKey, 0);
            obj.totalBooking.put(dateKey, 0);
            obj.totalBacklog.put(dateKey, 0);

            
            obj.totalSA.put(dateKey, 0);
            obj.fc2MAccuracy.put(dateKey, 0);
            obj.fc3MAccuracy.put(dateKey, 0);
            obj.fc6MAccuracy.put(dateKey, 0);
            return obj;
        }
        
        public ForecastViewFields assignRefData(ForecastViewFields acctObj, AggregateResult result, String dateKey, decimal currencyRate, boolean isMonthly) {
            
            decimal totalBilling = (decimal) ((result == null || result.get('billing') == null) ? 0 : result.get('billing'));
            decimal totalBooking = (decimal) ((result == null || result.get('booking') == null) ? 0 : result.get('booking'));
            decimal totalBacklog = (decimal) ((isMonthly || result == null || result.get('backlog') == null) ? 0 : result.get('backlog'));
            
            
            totalBilling = currencyRate * totalBilling; 
            totalBooking = currencyRate * totalBooking; 
            totalBacklog = currencyRate * totalBacklog; 
            
            totalBilling += (acctObj.totalBilling.containsKey(dateKey) ? acctObj.totalBilling.get(dateKey) : 0);
            totalBooking += (acctObj.totalBooking.containsKey(dateKey) ? acctObj.totalBooking.get(dateKey) : 0);
            totalBacklog += (acctObj.totalBacklog.containsKey(dateKey) ? acctObj.totalBacklog.get(dateKey) : 0);
            
            acctObj.totalBilling.put(dateKey, totalBilling);
            acctObj.totalBooking.put(dateKey, totalBooking);
            acctObj.totalBacklog.put(dateKey, totalBacklog);
            
            return acctObj;
        }
        public ForecastViewFields assignHisBacklogRefData(ForecastViewFields acctObj, AggregateResult result, String dateKey, decimal currencyRate) {
            
            decimal totalBacklog = (decimal) ((result == null || result.get('backlog') == null) ? 0 : result.get('backlog'));
            
            totalBacklog = currencyRate * totalBacklog; 
            
            totalBacklog += (decimal) (acctObj.totalBacklog.containsKey(dateKey) ? acctObj.totalBacklog.get(dateKey) : 0);
            
            acctObj.totalBacklog.put(dateKey, totalBacklog);
            
            return acctObj;
        }
    }
    
    public class GPLViewFields extends FCViewOjb implements Comparable {
        public String prodHichyId {get; set;}
        public String gplCode {get; set;}
        public decimal precent {get; set;}
        public boolean isHighLighted {get; set;}
        public map<String, decimal> billing {get; set;}
        public map<String, decimal> booking {get; set;}
        public map<String, decimal> backlog {get; set;}
        public GPLViewFields() {
            this.prodHichyId = ''; 
            this.gplCode = '';
            this.precent = 0;
            this.isHighLighted = false;
            this.currentFC = new map<String, decimal>();
            this.previousFC = new map<String, decimal>();
            this.rsmFC = new map<String, decimal>();
            this.billing = new map<String, decimal>();
            this.booking = new map<String, decimal>();
            this.backlog = new map<String, decimal>();
        }
        
        public override Object assignFCValues(FCViewOjb superObj, AggregateResult result, String dateKey, decimal currencyRate) {
            
            GPLViewFields obj = (GPLViewFields) superObj;
            
            decimal fc = (decimal) ((result == null || result.get('fc') == null ) ? 0 : result.get('fc'));
            decimal prevFC = (decimal) ((result == null || result.get('prevFC') == null ) ? 0 : result.get('prevFC'));
            decimal rsmFC = (decimal) ((result == null || result.get('rsmFC') == null ) ? 0 : result.get('rsmFC'));
            
            fc = currencyRate * fc / 10000; 
            prevFC = currencyRate * prevFC; 
            rsmFC = currencyRate * rsmFC; 
            
            fc += (obj.currentFC.containsKey(dateKey) ? obj.currentFC.get(dateKey) : 0);
            prevFC += (obj.previousFC.containsKey(dateKey) ? obj.previousFC.get(dateKey) : 0);
            rsmFC += (obj.rsmFC.containsKey(dateKey) ? obj.rsmFC.get(dateKey) : 0);
            obj.currentFC.put(dateKey, fc);
            obj.previousFC.put(dateKey, prevFC);
            obj.rsmFC.put(dateKey, rsmFC);
            
            return obj;
        }  
        
        public GPLViewFields assignRefData(GPLViewFields gplObj, AggregateResult result, String dateKey, decimal currencyRate, boolean isMonthly) {
            
            decimal billing = (decimal) ((result == null || result.get('billing') == null) ? 0 : result.get('billing'));
            decimal booking = (decimal) ((result == null || result.get('booking') == null) ? 0 : result.get('booking'));
            decimal backlog = (decimal) ((isMonthly || result == null || result.get('backlog') == null) ? 0 : result.get('backlog'));
            
            
            billing = currencyRate * billing; 
            booking = currencyRate * booking; 
            backlog = currencyRate * backlog; 
            
            billing += (gplObj.billing.containsKey(dateKey) ? gplObj.billing.get(dateKey) : 0);
            booking += (gplObj.booking.containsKey(dateKey) ? gplObj.booking.get(dateKey) : 0);
            backlog += (gplObj.backlog.containsKey(dateKey) ? gplObj.backlog.get(dateKey) : 0);
            
            gplObj.billing.put(dateKey, billing);
            gplObj.booking.put(dateKey, booking);
            gplObj.backlog.put(dateKey, backlog);
            
            return gplObj;
        }
        public GPLViewFields assignHisBacklogRefData(GPLViewFields gplObj, AggregateResult result, String dateKey, decimal currencyRate) {
            
            decimal backlog = (decimal) ((result == null || result.get('backlog') == null) ? 0 : result.get('backlog'));
            
            backlog = currencyRate * backlog; 
            
            backlog += (decimal) (gplObj.backlog.containsKey(dateKey) ? gplObj.backlog.get(dateKey) : 0);
            gplObj.backlog.put(dateKey, backlog);
            
            return gplObj;
        }
        
        public Integer compareTo(Object compareTo) {
            GPLViewFields compareToGPL = (GPLViewFields) compareTo;
            if (gplCode == compareToGPL.gplCode) return 0;
            if (gplCode > compareToGPL.gplCode) return 1;
            return -1;        
        }
    }
    
    public class PartViewFields extends FCViewOjb{
        public String partId {get; set;}
        public boolean isHighLighted {get; set;}
        public String partDesc {get; set;}
        public map<String, decimal> billing {get; set;}
        public map<String, decimal> booking {get; set;}
        public map<String, decimal> backlog {get; set;}
        
        public PartViewFields() {
            this.partId = ''; 
            this.partDesc = ''; 
            this.currentFC = new map<String, decimal>();
            this.previousFC = new map<String, decimal>();
            this.rsmFC = new map<String, decimal>();
            this.isHighLighted = false;
            this.billing = new map<String, decimal>();
            this.booking = new map<String, decimal>();
            this.backlog = new map<String, decimal>();
        }
        
        public override Object assignFCValues(FCViewOjb superObj, AggregateResult result, String dateKey, decimal currencyRate) {
            
            PartViewFields obj = (PartViewFields) superObj;
            
            decimal fc = (decimal) ((result == null || result.get('fc') == null ) ? 0 : result.get('fc'));
            decimal prevFC = (decimal) ((result == null || result.get('prevFC') == null ) ? 0 : result.get('prevFC'));
            decimal rsmFC = (decimal) ((result == null || result.get('rsmFC') == null ) ? 0 : result.get('rsmFC'));
            
            String partDesc = (String) ((result == null || result.get('partDesc') == null ) ? '' : result.get('partDesc'));
            obj.partDesc = (obj.partDesc == '' ? partDesc : obj.partDesc);
            fc = fc * currencyRate / 10000;
            prevFC = prevFC * currencyRate;
            rsmFC = rsmFC * currencyRate;
            
            obj.currentFC.put(dateKey, fc);
            obj.previousFC.put(dateKey, prevFC);
            obj.rsmFC.put(dateKey, rsmFC);
            
            return obj;
        }
        
        public PartViewFields assignRefData(PartViewFields partObj, AggregateResult result, String dateKey, decimal currencyRate, boolean isMonthly) {
            
            decimal billing = (decimal) ((result == null || result.get('billing') == null) ? 0 : result.get('billing'));
            decimal booking = (decimal) ((result == null || result.get('booking') == null) ? 0 : result.get('booking'));
            decimal backlog = (decimal) ((isMonthly || result == null || result.get('backlog') == null) ? 0 : result.get('backlog'));
            
            
            billing = currencyRate * billing; 
            booking = currencyRate * booking; 
            backlog = currencyRate * backlog; 
            
            billing += (partObj.billing.containsKey(dateKey) ? partObj.billing.get(dateKey) : 0);
            booking += (partObj.booking.containsKey(dateKey) ? partObj.booking.get(dateKey) : 0);
            backlog += (partObj.backlog.containsKey(dateKey) ? partObj.backlog.get(dateKey) : 0);
            partObj.billing.put(dateKey, billing);
            partObj.booking.put(dateKey, booking);
            partObj.backlog.put(dateKey, backlog);
            
            return partObj;
        }
        
        public PartViewFields assignHisBacklogRefData(PartViewFields partObj, AggregateResult result, String dateKey, decimal currencyRate) {
            
            decimal backlog = (decimal) ((result == null || result.get('backlog') == null) ? 0 : result.get('backlog'));
            
            backlog = currencyRate * backlog; 
            
            backlog += (decimal) (partObj.backlog.containsKey(dateKey) ? partObj.backlog.get(dateKey) : 0);
            partObj.backlog.put(dateKey, backlog);
            
            return partObj;
        }

    }
        
    public abstract class FCViewOjb{
        public String fieldName {get; set;}
        public String cls {get; set;}
        public map<String, decimal> currentFC {get; set;}
        public map<String, decimal> previousFC {get; set;}
		public map<String, decimal> rsmFC {get; set;}
        
        public abstract Object assignFCValues(FCViewOjb obj, AggregateResult result, String dateKey, decimal currencyRate);
    }
    
    public class PageConfig {
        public map<String, set<Integer>> map_financialMonth {get; set;}
        public map<String, Decimal> map_workingDays {get; set;}

        public list<String> list_yearMonth {get; set;}
        public set<String> set_dateKey {get; set;}
        public String currentYear {get; set;}
        public Integer currentMonth {get; set;}
        public Integer currentMonthIndex {get; set;}
        public String quarterNumb {get; set;}
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
            this.quarterNumb = '';
        }
    }
    public class PartObj implements Comparable {
        public String partId {get; set;}
        public String partName {get; set;}
        public decimal precent {get; set;}
        public String description {get; set;}
        
        public PartObj() {
            this.partId = '';
            this.partName = '';
            this.precent = 0;
            this.description = '';
        }
        
        public Integer compareTo(Object compareTo) {
            PartObj compareToPart = (PartObj) compareTo;
            if (this.precent == compareToPart.precent) return 0;
            if (this.precent > compareToPart.precent) return -1;
            return 1;        
        }
    }
    
    public class GPLPartAccountPercent {
        public String GPLCode {get; set;}
        public list<PartIdAccountPercent> list_partAccPercent {get; set;}
        public GPLPartAccountPercent(String GPLCode, list<PartIdAccountPercent> list_partAccPercent) {
            this.GPLCode = GPLCode;
            this.list_partAccPercent = list_partAccPercent;
        }
        
    }
    public class PartIdAccountPercent {
        public String partId {get; set;}
        public String accountId {get; set;}
        public decimal percent {get; set;}
        public PartIdAccountPercent(String partId, String accountId, decimal percent) {
            this.partId = partId;
            this.accountId = accountId;
            this.percent = percent;
        }
    }
    ///*<<<InnerClass*/
    //********************************* -=END inner classes=- *************************************
}