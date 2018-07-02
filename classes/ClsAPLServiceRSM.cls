public without sharing class ClsAPLServiceRSM extends ClsAPLInterface.AAPLCtrlService {
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public static final String OTHER = system.label.APL_Other_Accounts;
    public static final String ACCTFCTYPE = 'Account';
    public static final String GPLFCTYPE = 'GPL';
    public static final String PARTFCTYPE = 'Part';
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
   /**
    * This method is used to create a new interface instance
    *
    @author Bin Yuan
    @created 2014-06-02
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-02 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public ClsAPLEntityTypes.AcctInfo getAcctInfo(ClsAPLEntityTypes.PageConfig pageConf) {
        return new ClsAPLEntityTypes.AcctInfo();
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
    public static void getAcctTotalFC(ClsAPLEntityTypes.PageConfig pageConf, 
                                            list<ClsAPLEntityTypes.TotalFCViewFields> list_totalFC) {
        list<String> list_amSQL = new list<String>();
        list<String> list_relaySQL = new list<String>();
        set<String> set_territoryCodes = new set<String>();
        if(pageConf.set_rsmAMTerritoryCodes.isEmpty()) {
            return ;
        }
        set_territoryCodes.addAll(pageConf.set_rsmAMTerritoryCodes);
        
        list_amSQL.add(' Fiscal_Year__c year, sum(RSM_Forecast__c) fc, Fiscal_Quarter__c quarter ');
        list_amSQL.add(' APL_Sales_Forecast__c ');
        list_amSQL.add(' WHERE Customer__r.SALES_TERRITORY_CDE__c IN : set_territoryCodes '
                     + ' And (Type__c = \'' + ClsAPLForecastUtil.OTHERFCTYPE + '\' OR Type__c =\'' + ClsAPLForecastUtil.GPLFCTYPE + '\')'
                     + ClsAPLForecastUtil.getMonthFilter(pageConf.map_year_quartersFuture)
                     + ' Group by Fiscal_Year__c, Fiscal_Quarter__c ');
        list_relaySQL.add(' Fiscal_Year__c year, sum(RSM_Forecast__c) fc, Fiscal_Quarter__c quarter ');
        list_relaySQL.add(' APL_Sales_Forecast__c ');
        list_relaySQL.add(' WHERE Customer__r.SALES_TERRITORY_CDE__c IN : set_territoryCodes '
                     + ' And Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' '
                     + ' And Customer__r.STATDESC__c = \'Active\' '
                     + ClsAPLForecastUtil.getMonthFilter(pageConf.map_year_quartersFuture)
                     + ' Group by Fiscal_Year__c, Fiscal_Quarter__c ');
                           
        ClsAPLEntityTypes.TotalFCViewFields showTotal = new ClsAPLEntityTypes.TotalFCViewFields(' trt_0 trt_trt col ');
        showTotal.fieldName= system.label.APL_Show_Total;
        ClsAPLEntityTypes.TotalFCViewFields fcTotal = new ClsAPLEntityTypes.TotalFCViewFields(' trt_0 dn fctotal ');
        fcTotal.fieldName= system.label.APL_Total_Forecast;
        ClsAPLEntityTypes.TotalFCViewFields tcFC = new ClsAPLEntityTypes.TotalFCViewFields(' trt_0 dn tcfctotal ');
        tcFC.fieldName = system.label.APL_TC_Products;
        tcFC.list_referenceRows.addAll(getRSMTotalReferRow());
        ClsAPLEntityTypes.TotalFCViewFields relayFC = new ClsAPLEntityTypes.TotalFCViewFields(' trt_0 dn relayfctotal ');
        relayFC.fieldName = system.label.APL_Relay_Products;
        relayFC.list_referenceRows.addAll(getRSMTotalReferRow());
        ClsAPLEntityTypes.TotalFCViewFields overruleRelayFC = new ClsAPLEntityTypes.TotalFCViewFields(' trt_0 dn overrulerelayfctotal ');
        overruleRelayFC.fieldName = system.label.APL_Overrule_Relay_Products;
        //get t&c forecast
        for(AggregateResult  result : Database.query(ClsAPLForecastUtil.getQueryString(list_amSQL))) {
            String parentId = 'T&C';
            String year = (String) result.get('year');
            String quarter = (String) result.get('quarter');
            String dateKey = year + '_' + quarter;
            //build account forecast date map
            tcFC = (ClsAPLEntityTypes.TotalFCViewFields) tcFC.assignFCValues(tcFC, result, dateKey);
        }
        
        //get relay forecast
        for(AggregateResult  result : Database.query(ClsAPLForecastUtil.getQueryString(list_relaySQL))) {
            String parentId = 'Relay';
            String year = (String) result.get('year');
            String quarter = (String) result.get('quarter');
            String dateKey = year + '_' + quarter;
            //build account forecast date map
            relayFC = (ClsAPLEntityTypes.TotalFCViewFields) relayFC.assignFCValues(relayFC, result, dateKey);
        }
        //set value = 0 if no result from system
        for(String year : pageConf.map_year_quartersFuture.keySet()) {
            for(String quarter : pageConf.map_year_quartersFuture.get(year)) {
                String dateKey = year + '_' + quarter;
                //check tcFC
                if(!relayFC.map_currentFC.containsKey(dateKey)) {
                    relayFC.map_currentFC.put(dateKey, 0);
                }
                if(!tcFC.map_currentFC.containsKey(dateKey)) {
                    tcFC.map_currentFC.put(dateKey, 0);
                }
                
            }
        }
        tcFC.currentFC = Json.serialize(tcFC.map_currentFC);
        relayFC.currentFC = Json.serialize(relayFC.map_currentFC);
        list_totalFC.add(showTotal);
        list_totalFC.add(fcTotal);
        list_totalFC.add(tcFC);
        list_totalFC.add(relayFC);
        list_totalFC.add(overruleRelayFC);
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
    public static ClsAPLEntityTypes.AcctFCResults getRSMAMOverRallFC(ClsAPLEntityTypes.RSMAMOverRallInfo rsmOverRall) {
        ClsAPLEntityTypes.AcctFCResults overRallResult = new ClsAPLEntityTypes.AcctFCResults();
        list<String> list_sql = new list<String>();
        ClsAPLEntityTypes.OverRallFCObj overRallFC = new ClsAPLEntityTypes.OverRallFCObj();
        list_sql.add(' sum(RSM_Overall_Forecast__c) fc, Fiscal_Year__c year, Fiscal_Quarter__c quarter ');
        list_sql.add(' APL_RSM_Overall_Forecast__c ');
        system.debug('!@#rsmOverRall: '+rsmOverRall);
        list_sql.add(' WHERE APL_RSM__r.Manager__c = \'' + rsmOverRall.managerId + '\' '
                    + ' And APL_RSM__r.Display_Name__c = \'' + rsmOverRall.displayName + '\' '
                    + ' And RSM_Overall_Forecast__c > 0 '
                    + ClsAPLForecastUtil.getMonthFilter(rsmOverRall.map_year_quartersFuture) 
                    + ' Group by Fiscal_Year__c, Fiscal_Quarter__c ');
        system.debug('getRSMAMOverRallFC :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String year = (String) result.get('year'),
                   quarter = (String) result.get('quarter'),
                   dateKey = year + '_' + quarter;
            
            overRallFC = overRallFC.assignFCValues(overRallFC, result, dateKey);
        }
        
        for(String year : rsmOverRall.map_year_quartersFuture.keySet()) {
            for(String quarter : rsmOverRall.map_year_quartersFuture.get(year)) {
                
                String dateKey = (year + '_' + quarter);
                AggregateResult result;
                overRallFC = overRallFC.assignFCValues(overRallFC, result, dateKey);
                
            }
        }
        
        overRallResult.json_result = Json.serialize(overRallFC);    
        system.debug('overRallResult :: ' + overRallResult);                    
        return overRallResult;
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
    public static ClsAPLEntityTypes.AcctFCResults getRSMTotalRefData(ClsAPLEntityTypes.RSMTotalFCInfo rsmTotal) {
        ClsAPLEntityTypes.AcctFCResults result = new ClsAPLEntityTypes.AcctFCResults();
        String startDate = ClsAPLForecastUtil.getStartDate(rsmTotal.list_dateKey[0]),
               endDate = ClsAPLForecastUtil.getEndDate(rsmTotal.list_dateKey[2]);
        
        Integer startYear = Integer.valueOf(startDate.subStringBefore('-')), 
               startMonth = Integer.valueOf(startDate.subStringBetween('-', '-')), 
               endYear = Integer.valueOf(endDate.subStringBefore('-')), 
               endMonth = Integer.valueOf(endDate.subStringBetween('-', '-')), 
               currentYear = Integer.valueOf(rsmTotal.currentYear),
               currentMonth = Integer.valueOf(rsmTotal.currentMonth); 
        Date date_endDate = Date.newInstance(endYear, endMonth, 1);
        Date date_currentDate = Date.newInstance(currentYear, currentMonth, 1);
        Date date_startDate = Date.newInstance(startYear, startMonth, 1);
        map<String, set<Integer>> map_fiscalMonth = ClsAPLForecastUtil.getFiscalMonthMap(rsmTotal.list_dateKey);
        ClsAPLEntityTypes.AcctFCValueObj fcViewObj = new ClsAPLEntityTypes.AcctFCValueObj();
        if(date_endDate < date_currentDate) {
            getTotalHistoryRefData(rsmTotal.set_terrtoryCodes, rsmTotal.isTCProd, startDate, endDate, 
                                    rsmTotal.list_dateKey, fcViewObj);
            getTotalHisBacklogRefData(rsmTotal.set_terrtoryCodes, rsmTotal.isTCProd, startDate, endDate,
                                    map_fiscalMonth, rsmTotal.list_dateKey, fcViewObj);
        }
        else if(date_currentDate < date_startDate) {
            getTotalFutureRefData(rsmTotal.set_terrtoryCodes, rsmTotal.isTCProd, startDate, endDate,
                                map_fiscalMonth, rsmTotal.list_dateKey, fcViewObj);
        }
        else {
            String currentEndDate =  ClsAPLForecastUtil.getEndDate(rsmTotal.currentYear + '_' + rsmTotal.currentMonth);
            map<String, set<Integer>> map_history = new map<String, set<Integer>>();
            map<String, set<Integer>> map_future = new map<String, set<Integer>>();
            ClsAPLForecastUtil.getDividedFiscalMap(date_currentDate, rsmTotal.list_dateKey, map_history, map_future);
            
            getTotalHistoryRefData(rsmTotal.set_terrtoryCodes, rsmTotal.isTCProd, startDate, currentEndDate, 
                                    rsmTotal.list_dateKey, fcViewObj);
            if(!map_history.isEmpty()) {
                getTotalHisBacklogRefData(rsmTotal.set_terrtoryCodes, rsmTotal.isTCProd, startDate, currentEndDate,
                                        map_history, rsmTotal.list_dateKey, fcViewObj);
            }
            if(!map_future.isEmpty()) {
                getTotalCurrentRefData(rsmTotal.set_terrtoryCodes, rsmTotal.isTCProd, rsmTotal.currentYear, Integer.valueOf(rsmTotal.currentMonth),
                                        fcViewObj);
                getTotalFutureRefData(rsmTotal.set_terrtoryCodes, rsmTotal.isTCProd, currentEndDate, endDate,
                                        map_future, rsmTotal.list_dateKey, fcViewObj);
            }                       
        }
        
        fcViewObj.cls = String.join(rsmTotal.list_dateKey, ',');
        result.json_result = Json.serialize(fcViewObj);                     
        return result;
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
    public static void getTotalHistoryRefData(set<String> set_territoryCodes, boolean isTCProd,
                                            String startDate, String endDate,
                                            list<String> list_dateKey,
                                            ClsAPLEntityTypes.AcctFCValueObj fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
        ClsAPLForecastUtil.setRSMAccountIds(true, set_territoryCodes, set_acctIds);
                                                
        list<String> list_sql = new list<String>();
        map<String, map<String, ClsAPLEntityTypes.CBCFCValueObj>> map_cbc2Name_map_dateKey_result = new map<String, map<String, ClsAPLEntityTypes.CBCFCValueObj>>();
        set<String> set_tempTerritorys = new set<String>();
        set_tempTerritorys.addAll(set_territoryCodes);
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking, Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds '
                    + (isTCProd ? ClsAPLForecastUtil.getNoneRelayPartQuery() : ClsAPLForecastUtil.getRelayPartQuery())
                    + ' And Fiscal_Date__c >= ' + startDate
                    + ' And Fiscal_Date__c < ' + endDate
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' Group by Fiscal_Date__c ' );
                    
        system.debug('getTotalHistoryRefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;

            fcViewObj = (ClsAPLEntityTypes.AcctFCValueObj) fcViewObj.assignRefData(fcViewObj, result, dateKey, true);
        }
        //generate forecast view objects for each quarter
        for(String dateKey : list_dateKey) {
            AggregateResult result;
            fcViewObj = fcViewObj.assignRefData(fcViewObj, result, dateKey, true);
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
    public static void getTotalHisBacklogRefData(set<String> set_territoryCodes, boolean isTCProd,
                                            String startDate, String endDate,
                                            map<String, set<Integer>> map_fiscalMonth, list<String> list_dateKey,
                                            ClsAPLEntityTypes.AcctFCValueObj fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
        ClsAPLForecastUtil.setRSMAccountIds(true, set_territoryCodes, set_acctIds);

        list<String> list_sql = new list<String>();
        set<String> set_tempTerritorys = new set<String>();
        set_tempTerritorys.addAll(set_territoryCodes);
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds '
                    + (isTCProd ? ClsAPLForecastUtil.getNoneRelayPartQuery() : ClsAPLForecastUtil.getRelayPartQuery())
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

            fcViewObj = (ClsAPLEntityTypes.AcctFCValueObj) fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey);
        }
        //generate forecast view objects for each quarter
        for(String dateKey : list_dateKey) {
            AggregateResult result;
            fcViewObj = fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey);
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
    public static void getTotalCurrentRefData(set<String> set_territoryCodes, boolean isTCProd,
                                            String year, Integer month,
                                            ClsAPLEntityTypes.AcctFCValueObj fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
        ClsAPLForecastUtil.setRSMAccountIds(true, set_territoryCodes, set_acctIds);
        
        list<String> list_sql = new list<String>();
        set<String> set_tempTerritorys = new set<String>();
        set_tempTerritorys.addAll(set_territoryCodes);
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds '
                    + (isTCProd ? ClsAPLForecastUtil.getNoneRelayPartQuery() : ClsAPLForecastUtil.getRelayPartQuery())
                    + ' And Fiscal_Year__c = \'' + year +'\''
                    + ' And Fiscal_Month__c = ' + month +
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0 ) ' );
        system.debug('getCBC2RefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        String dateKey = year + '_' + month;
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {

            fcViewObj = (ClsAPLEntityTypes.AcctFCValueObj) fcViewObj.assignRefData(fcViewObj, result, dateKey, true);
        }
        //generate forecast view objects for each quarter
        AggregateResult result;
        fcViewObj = fcViewObj.assignRefData(fcViewObj, result, dateKey, true);
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
    public static void getTotalFutureRefData(set<String> set_territoryCodes, boolean isTCProd,
                                            String startDate, String endDate,
                                            map<String, set<Integer>> map_fiscalMonth, list<String> list_dateKey,
                                            ClsAPLEntityTypes.AcctFCValueObj fcViewObj) {
        //get children account ids first
        set<String> set_acctIds = new set<String>();
        ClsAPLForecastUtil.setRSMAccountIds(true, set_territoryCodes, set_acctIds);

        list<String> list_sql = new list<String>();
        set<String> set_tempTerritorys = new set<String>();
        set_tempTerritorys.addAll(set_territoryCodes);
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds '
                    + (isTCProd ? ClsAPLForecastUtil.getNoneRelayPartQuery() : ClsAPLForecastUtil.getRelayPartQuery())
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

            fcViewObj = (ClsAPLEntityTypes.AcctFCValueObj) fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey);
        }
        //generate forecast view objects for each quarter
        for(String dateKey : list_dateKey) {
            AggregateResult result;
            fcViewObj = fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey);
        }
    }
    
   /**
    * This method is used to create a new interface instance
    *
    @author Bin Yuan
    @created 2014-06-02
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-02 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static ClsAPLEntityTypes.AcctFCResults getRSMTerritoryFC(ClsAPLEntityTypes.RSMTerritoryFCInfo rsmTerritory) {
        ClsAPLEntityTypes.AcctFCResults acctFCResult = new ClsAPLEntityTypes.AcctFCResults();
        list<String> list_sql = new list<String>();
        map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result =
            new map<String, map<String, AggregateResult>>();
        ClsAPLEntityTypes.AcctFCValueObj acctFC = new ClsAPLEntityTypes.AcctFCValueObj();
        //Get account grouping
        String tempAcctId = 'temp';
        //get account forecast
        list_sql.add(' Fiscal_Year__c year, sum(RSM_Forecast__c) fc, '      //, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
                        +' sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter, sum(Forecast__c) amFC ');
        list_sql.add(' APL_Sales_Forecast__c ');
        list_sql.add(' WHERE Customer__r.SALES_TERRITORY_CDE__c = \'' + rsmTerritory.territoryCode + '\' '
                    + ' AND  (Type__c = \'GPL\' ' 
                    + ' OR Type__c = \'' + ClsAPLForecastUtil.OTHERFCTYPE + '\' OR Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' )'
                        + ClsAPLForecastUtil.getMonthFilter(rsmTerritory.map_year_quartersFuture) 
                        + ' And Customer__r.STATDESC__c = \'Active\' '
                        + ' Group by Fiscal_Year__c, Fiscal_Quarter__c ');
        /*
        list<String> list_relaysql = new list<String>();
        list_relaysql.add(' Fiscal_Year__c year, sum(RSM_Forecast__c) fc, '     //, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
                        +' sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter, sum(Forecast__c) amFC ');
        list_relaysql.add(' APL_Sales_Forecast__c ');
        list_relaysql.add(' WHERE Customer__r.SALES_TERRITORY_CDE__c = \'' + rsmTerritory.territoryCode + '\' '
                    + ' AND Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' ' 
                    + ClsAPLForecastUtil.getMonthFilter(rsmTerritory.map_year_quartersFuture) 
                    + ' And Customer__r.STATDESC__c = \'Active\' '
                    + ' Group by Fiscal_Year__c, Fiscal_Quarter__c ');
        */              
        
        system.debug('getRSMAcctFC :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        for(AggregateResult result : Database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String year = (String) result.get('year'),
                   quarter = (String) result.get('quarter'), 
                   dateKey = (year + '_' + quarter);
            
            ClsAPLForecastUtil.setResultMap(result, tempAcctId, dateKey, map_acctId_map_dateKey_result);
        }
        /*
        for(AggregateResult result : Database.query(ClsAPLForecastUtil.getQueryString(list_relaysql))) {
            String year = (String) result.get('year'),
                   quarter = (String) result.get('quarter'), 
                   dateKey = (year + '_' + quarter);
            
            ClsAPLForecastUtil.setResultMap(result, tempAcctId, dateKey, map_acctId_map_dateKey_result);
        }
        */
        for(String year : rsmTerritory.map_year_quartersFuture.keySet()) {
            for(String quarter : rsmTerritory.map_year_quartersFuture.get(year)) {
                
                String dateKey = (year + '_' + quarter);
                AggregateResult result;
                
                if(map_acctId_map_dateKey_result.containsKey(tempAcctId) 
                    && map_acctId_map_dateKey_result.get(tempAcctId).containsKey(dateKey)) {
                    
                    result = map_acctId_map_dateKey_result.get(tempAcctId).get(dateKey);
                }
                
                acctFC = (ClsAPLEntityTypes.AcctFCValueObj) acctFC.assignFCValues(acctFC, result, dateKey);
                
            }
        }
        //prepare result
        acctFCResult.json_result = Json.serialize(acctFC);
        return acctFCResult;
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
    public static ClsAPLEntityTypes.AcctFCResults getRSMTerritoryRefData(ClsAPLEntityTypes.RSMTerritoryFCInfo rsmTerritory) {
        ClsAPLEntityTypes.AcctFCResults result = new ClsAPLEntityTypes.AcctFCResults();
        String startDate = ClsAPLForecastUtil.getStartDate(rsmTerritory.list_dateKey[0]),
               endDate = ClsAPLForecastUtil.getEndDate(rsmTerritory.list_dateKey[2]);
        
        Integer startYear = Integer.valueOf(startDate.subStringBefore('-')), 
               startMonth = Integer.valueOf(startDate.subStringBetween('-', '-')), 
               endYear = Integer.valueOf(endDate.subStringBefore('-')), 
               endMonth = Integer.valueOf(endDate.subStringBetween('-', '-')), 
               currentYear = Integer.valueOf(rsmTerritory.currentYear),
               currentMonth = Integer.valueOf(rsmTerritory.currentMonth); 
        Date date_endDate = Date.newInstance(endYear, endMonth, 1);
        Date date_currentDate = Date.newInstance(currentYear, currentMonth, 1);
        Date date_startDate = Date.newInstance(startYear, startMonth, 1);
        map<String, set<Integer>> map_fiscalMonth = ClsAPLForecastUtil.getFiscalMonthMap(rsmTerritory.list_dateKey);
        ClsAPLEntityTypes.AcctFCValueObj fcViewObj = new ClsAPLEntityTypes.AcctFCValueObj();
        if(date_endDate < date_currentDate) {
            getTerritoryHistoryRefData(rsmTerritory.territoryCode, startDate, endDate, 
                                    rsmTerritory.list_dateKey, fcViewObj);
            getTerritoryHisBacklogRefData(rsmTerritory.territoryCode, startDate, endDate,
                                    map_fiscalMonth, rsmTerritory.list_dateKey, fcViewObj);
        }
        else if(date_currentDate < date_startDate) {
            getTerritoryFutureRefData(rsmTerritory.territoryCode, startDate, endDate,
                                map_fiscalMonth, rsmTerritory.list_dateKey, fcViewObj);
        }
        else {
            String currentEndDate =  ClsAPLForecastUtil.getEndDate(rsmTerritory.currentYear + '_' + rsmTerritory.currentMonth);
            map<String, set<Integer>> map_history = new map<String, set<Integer>>();
            map<String, set<Integer>> map_future = new map<String, set<Integer>>();
            ClsAPLForecastUtil.getDividedFiscalMap(date_currentDate, rsmTerritory.list_dateKey, map_history, map_future);
            
            getTerritoryHistoryRefData(rsmTerritory.territoryCode, startDate, currentEndDate, 
                                    rsmTerritory.list_dateKey, fcViewObj);
            if(!map_history.isEmpty()) {
                getTerritoryHisBacklogRefData(rsmTerritory.territoryCode, startDate, currentEndDate,
                                        map_history, rsmTerritory.list_dateKey, fcViewObj);
            }
            if(!map_future.isEmpty()) {
                getTerritoryCurrentRefData(rsmTerritory.territoryCode, rsmTerritory.currentYear, Integer.valueOf(rsmTerritory.currentMonth),
                                            fcViewObj);
                getTerritoryFutureRefData(rsmTerritory.territoryCode, currentEndDate, endDate,
                                        map_future, rsmTerritory.list_dateKey, fcViewObj);
            }                       
        }
        
        fcViewObj.cls = String.join(rsmTerritory.list_dateKey, ',');
        result.json_result = Json.serialize(fcViewObj);                     
        return result;
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
    public static void getTerritoryHistoryRefData(String territoryCode,
                                            String startDate, String endDate,
                                            list<String> list_dateKey,
                                            ClsAPLEntityTypes.AcctFCValueObj fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
        ClsAPLForecastUtil.setRSMAccountIds(true, new set<String>{territoryCode}, set_acctIds);
                                                
        list<String> list_sql = new list<String>();
        map<String, map<String, ClsAPLEntityTypes.CBCFCValueObj>> map_cbc2Name_map_dateKey_result = new map<String, map<String, ClsAPLEntityTypes.CBCFCValueObj>>();
        
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking, Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds '
                    + ' And Fiscal_Date__c >= ' + startDate
                    + ' And Fiscal_Date__c < ' + endDate
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

            fcViewObj = (ClsAPLEntityTypes.AcctFCValueObj) fcViewObj.assignRefData(fcViewObj, result, dateKey, true);
        }
        //generate forecast view objects for each quarter
        for(String dateKey : list_dateKey) {
            AggregateResult result;
            fcViewObj = fcViewObj.assignRefData(fcViewObj, result, dateKey, true);
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
    public static void getTerritoryHisBacklogRefData(String territoryCode,
                                            String startDate, String endDate,
                                            map<String, set<Integer>> map_fiscalMonth, list<String> list_dateKey,
                                            ClsAPLEntityTypes.AcctFCValueObj fcViewObj) {
        //get children account ids first
        set<String> set_acctIds = new set<String>();
        ClsAPLForecastUtil.setRSMAccountIds(true, new set<String>{territoryCode}, set_acctIds);

        list<String> list_sql = new list<String>();
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date ');
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

            fcViewObj = (ClsAPLEntityTypes.AcctFCValueObj) fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey);
        }
        //generate forecast view objects for each quarter
        for(String dateKey : list_dateKey) {
            AggregateResult result;
            fcViewObj = fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey);
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
    public static void getTerritoryCurrentRefData(String territoryCode,
                                            String year, Integer month,
                                            ClsAPLEntityTypes.AcctFCValueObj fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
        ClsAPLForecastUtil.setRSMAccountIds(true, new set<String>{territoryCode}, set_acctIds);

        list<String> list_sql = new list<String>();
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds '
                    + ' And Fiscal_Year__c = \'' + year +'\''
                    + ' And Fiscal_Month__c = ' + month +
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0 ) ' );
        system.debug('getCBC2RefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        String dateKey = year + '_' + month;
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            fcViewObj = (ClsAPLEntityTypes.AcctFCValueObj) fcViewObj.assignRefData(fcViewObj, result, dateKey, true);
        }
        //generate forecast view objects for each quarter
        AggregateResult result;
        fcViewObj = fcViewObj.assignRefData(fcViewObj, result, dateKey, true);
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
    public static void getTerritoryFutureRefData(String territoryCode,
                                            String startDate, String endDate,
                                            map<String, set<Integer>> map_fiscalMonth, list<String> list_dateKey,
                                            ClsAPLEntityTypes.AcctFCValueObj fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
        ClsAPLForecastUtil.setRSMAccountIds(true, new set<String>{territoryCode}, set_acctIds);

        list<String> list_sql = new list<String>();
        
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date ');
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

            fcViewObj = (ClsAPLEntityTypes.AcctFCValueObj) fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey);
        }
        //generate forecast view objects for each quarter
        for(String dateKey : list_dateKey) {
            AggregateResult result;
            fcViewObj = fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey);
        }
    }
   /**
    * This method is used to create a new interface instance
    *
    @author Bin Yuan
    @created 2014-06-02
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-02 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static ClsAPLEntityTypes.AcctFCResults getRSMAcctFC(ClsAPLEntityTypes.RSMAcctFCInfo rsmAcct) {
        ClsAPLEntityTypes.AcctFCResults acctFCResult = new ClsAPLEntityTypes.AcctFCResults();
        list<String> list_sql = new list<String>();
        map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result =
            new map<String, map<String, AggregateResult>>();
        //Get account grouping
        map<String, ClsAPLEntityTypes.AcctFCValueObj> map_groupId_acctFC = ClsAPLRSMForecastUtil.getAMAcctGroup(rsmAcct);
        //get account forecast
        list_sql.add(' Fiscal_Year__c year, sum(RSM_Forecast__c) fc, '      //, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
                        +' sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter, sum(Forecast__c) amFC, '
                        +' Customer__r.APL_AM_forecast_Plan_Account__c parentId');
        list_sql.add(' APL_Sales_Forecast__c ');
        list_sql.add(' WHERE Customer__r.SALES_TERRITORY_CDE__c = \'' + rsmAcct.territoryCode + '\' '
                    + ' AND  (Type__c = \'GPL\' ' 
                    + ' OR Type__c = \'' + ClsAPLForecastUtil.OTHERFCTYPE + '\''
                    + ' OR Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' )'
                    + ' And Customer__r.STATDESC__c = \'Active\' '
                    + ClsAPLForecastUtil.getMonthFilter(rsmAcct.map_year_quartersFuture) 
                    + ' Group by Customer__r.APL_AM_forecast_Plan_Account__c, Fiscal_Year__c, Fiscal_Quarter__c ');
        system.debug('getRSMAcctFC :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        for(AggregateResult result : Database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String acctId = (String) (result.get('parentId') == null ? ClsAPLForecastUtil.OTHERACCTID : result.get('parentId')), 
                   year = (String) result.get('year'),
                   quarter = (String) result.get('quarter'), 
                   dateKey = (year + '_' + quarter);
            
            ClsAPLForecastUtil.setResultMap(result, acctId, dateKey, map_acctId_map_dateKey_result);
        }
        
        for(String acctId : map_groupId_acctFC.keySet()) {
            for(String year : rsmAcct.map_year_quartersFuture.keySet()) {
                for(String quarter : rsmAcct.map_year_quartersFuture.get(year)) {
                    
                    String dateKey = (year + '_' + quarter);
                    AggregateResult result;
                    
                    if(map_acctId_map_dateKey_result.containsKey(acctId) 
                        && map_acctId_map_dateKey_result.get(acctId).containsKey(dateKey)) {
                        
                        result = map_acctId_map_dateKey_result.get(acctId).get(dateKey);
                    }
                    
                    ClsAPLEntityTypes.AcctFCValueObj acctFC = map_groupId_acctFC.get(acctId);
                    acctFC = (ClsAPLEntityTypes.AcctFCValueObj) acctFC.assignFCValues(acctFC, result, dateKey);
                    
                }
            }
        }
        list<ClsAPLEntityTypes.AcctFCValueObj> list_tempAcctFC = new list<ClsAPLEntityTypes.AcctFCValueObj>();
        list<ClsAPLEntityTypes.AcctFCValueObj> list_AcctFC = new list<ClsAPLEntityTypes.AcctFCValueObj>();
        ClsAPLEntityTypes.AcctFCValueObj otherAcctFC;
        if(map_groupId_acctFC.containsKey(ClsAPLForecastUtil.OTHERACCTID)) {
            otherAcctFC = map_groupId_acctFC.get(ClsAPLForecastUtil.OTHERACCTID);
            map_groupId_acctFC.remove(ClsAPLForecastUtil.OTHERACCTID);
            list_AcctFC.add(otherAcctFC);
        }
        
        list_tempAcctFC.addAll(map_groupId_acctFC.values());
        list_tempAcctFC.sort();
        list_AcctFC.addAll(list_tempAcctFC);
        //prepare result
        acctFCResult.json_result = Json.serialize(list_AcctFC);
        return acctFCResult;
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
    public static ClsAPLEntityTypes.AcctFCResults getRSMAcctRefData(ClsAPLEntityTypes.RSMAcctFCInfo rsmAcct) {
        ClsAPLEntityTypes.AcctFCResults result = new ClsAPLEntityTypes.AcctFCResults();
        String startDate = ClsAPLForecastUtil.getStartDate(rsmAcct.list_dateKey[0]),
               endDate = ClsAPLForecastUtil.getEndDate(rsmAcct.list_dateKey[2]);
        
        Integer startYear = Integer.valueOf(startDate.subStringBefore('-')), 
               startMonth = Integer.valueOf(startDate.subStringBetween('-', '-')), 
               endYear = Integer.valueOf(endDate.subStringBefore('-')), 
               endMonth = Integer.valueOf(endDate.subStringBetween('-', '-')), 
               currentYear = Integer.valueOf(rsmAcct.currentYear),
               currentMonth = Integer.valueOf(rsmAcct.currentMonth); 
        Date date_endDate = Date.newInstance(endYear, endMonth, 1);
        Date date_currentDate = Date.newInstance(currentYear, currentMonth, 1);
        Date date_startDate = Date.newInstance(startYear, startMonth, 1);
        map<String, set<Integer>> map_fiscalMonth = ClsAPLForecastUtil.getFiscalMonthMap(rsmAcct.list_dateKey);
        ClsAPLEntityTypes.AcctFCValueObj fcViewObj = new ClsAPLEntityTypes.AcctFCValueObj();
        if(date_endDate < date_currentDate) {
            getAcctHistoryRefData(rsmAcct.acctId, rsmAcct.territoryCode, startDate, endDate, 
                                    rsmAcct.list_dateKey, fcViewObj);
            getAcctHisBacklogRefData(rsmAcct.acctId, rsmAcct.territoryCode, startDate, endDate,
                                    map_fiscalMonth, rsmAcct.list_dateKey, fcViewObj);
        }
        else if(date_currentDate < date_startDate) {
            getAcctFutureRefData(rsmAcct.acctId, rsmAcct.territoryCode, startDate, endDate,
                                map_fiscalMonth, rsmAcct.list_dateKey, fcViewObj);
        }
        else {
            String currentEndDate =  ClsAPLForecastUtil.getEndDate(rsmAcct.currentYear + '_' + rsmAcct.currentMonth);
            map<String, set<Integer>> map_history = new map<String, set<Integer>>();
            map<String, set<Integer>> map_future = new map<String, set<Integer>>();
            ClsAPLForecastUtil.getDividedFiscalMap(date_currentDate, rsmAcct.list_dateKey, map_history, map_future);
            
            getAcctHistoryRefData(rsmAcct.acctId, rsmAcct.territoryCode, startDate, currentEndDate, 
                                    rsmAcct.list_dateKey, fcViewObj);
            if(!map_history.isEmpty()) {
                getAcctHisBacklogRefData(rsmAcct.acctId, rsmAcct.territoryCode, startDate, currentEndDate,
                                        map_history, rsmAcct.list_dateKey, fcViewObj);
            }
            if(!map_future.isEmpty()) {
                getAcctCurrentRefData(rsmAcct.acctId, rsmAcct.territoryCode, rsmAcct.currentYear, Integer.valueOf(rsmAcct.currentMonth),
                                      fcViewObj);
                getAcctFutureRefData(rsmAcct.acctId, rsmAcct.territoryCode, currentEndDate, endDate,
                                        map_future, rsmAcct.list_dateKey, fcViewObj);
            }                       
        }
        
        fcViewObj.cls = String.join(rsmAcct.list_dateKey, ',');
        result.json_result = Json.serialize(fcViewObj);                     
        return result;
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
    public static void getAcctHistoryRefData(String parentId, String territoryCode,
                                            String startDate, String endDate,
                                            list<String> list_dateKey,
                                            ClsAPLEntityTypes.AcctFCValueObj fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
        ClsAPLForecastUtil.setAccountIds(true, parentId, territoryCode, set_acctIds);
                                                
        list<String> list_sql = new list<String>();
        map<String, map<String, ClsAPLEntityTypes.CBCFCValueObj>> map_cbc2Name_map_dateKey_result = new map<String, map<String, ClsAPLEntityTypes.CBCFCValueObj>>();
        
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking, Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds ' 
                    + ' And Fiscal_Date__c >= ' + startDate
                    + ' And Fiscal_Date__c < ' + endDate
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

            fcViewObj = (ClsAPLEntityTypes.AcctFCValueObj) fcViewObj.assignRefData(fcViewObj, result, dateKey, true);
        }
        //generate forecast view objects for each quarter
        for(String dateKey : list_dateKey) {
            AggregateResult result;
            fcViewObj = fcViewObj.assignRefData(fcViewObj, result, dateKey, true);
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
    public static void getAcctHisBacklogRefData(String parentId, String territoryCode,
                                            String startDate, String endDate,
                                            map<String, set<Integer>> map_fiscalMonth, list<String> list_dateKey,
                                            ClsAPLEntityTypes.AcctFCValueObj fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
        ClsAPLForecastUtil.setAccountIds(true, parentId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date ');
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

            fcViewObj = (ClsAPLEntityTypes.AcctFCValueObj) fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey);
        }
        //generate forecast view objects for each quarter
        for(String dateKey : list_dateKey) {
            AggregateResult result;
            fcViewObj = fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey);
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
    public static void getAcctCurrentRefData(String parentId, String territoryCode,
                                            String year, Integer month,
                                            ClsAPLEntityTypes.AcctFCValueObj fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
        ClsAPLForecastUtil.setAccountIds(true, parentId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds ' 
                    + ' And Fiscal_Year__c = \'' + year +'\''
                    + ' And Fiscal_Month__c = ' + month +
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0 ) ' );
        system.debug('getCBC2RefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        String dateKey = year + '_' + month;
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {

            fcViewObj = (ClsAPLEntityTypes.AcctFCValueObj) fcViewObj.assignRefData(fcViewObj, result, dateKey, true);
        }
        //generate forecast view objects for each quarter
        AggregateResult result;
        fcViewObj = fcViewObj.assignRefData(fcViewObj, result, dateKey, true);
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
    public static void getAcctFutureRefData(String parentId, String territoryCode,
                                            String startDate, String endDate,
                                            map<String, set<Integer>> map_fiscalMonth, list<String> list_dateKey,
                                            ClsAPLEntityTypes.AcctFCValueObj fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
        ClsAPLForecastUtil.setAccountIds(true, parentId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date ');
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

            fcViewObj = (ClsAPLEntityTypes.AcctFCValueObj) fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey);
        }
        //generate forecast view objects for each quarter
        for(String dateKey : list_dateKey) {
            AggregateResult result;
            fcViewObj = fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey);
        }
    }
    
   /**
    * This method is used to create a new interface instance
    *
    @author Bin Yuan
    @created 2014-06-02
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-02 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static ClsAPLEntityTypes.AcctFCResults getRSMCBCFC(ClsAPLEntityTypes.RSMCBCFCInfo rsmCBC) {
        system.debug('rsmCBC :: ' + rsmCBC);
        ClsAPLEntityTypes.AcctFCResults acctFCResult = new ClsAPLEntityTypes.AcctFCResults();
        list<String> list_sql = new list<String>();
        map<String, ClsAPLEntityTypes.CBCFCValueObj> map_cbcKey_cbcFC = new map<String, ClsAPLEntityTypes.CBCFCValueObj>();
        map<String, map<String, AggregateResult>> map_cbcName_map_dateKey_result =
            new map<String, map<String, AggregateResult>>();
        list_sql.add(' Fiscal_Year__c year, sum(RSM_Forecast__c) fc,  '         //, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
                    + ' sum(Forecast__c) amFC, sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter, '
                    + '  GPL__r.CBC2__c cbc2Name, GPL__r.CBC3__c cbc3Name  ');
                    
        list_sql.add(' APL_Sales_Forecast__c ');
        list_sql.add(' WHERE Customer__r.APL_AM_forecast_Plan_Account__c = ' 
                    + (rsmCBC.acctId == ClsAPLForecastUtil.OTHERACCTID ? ' null ' : '\'' +  rsmCBC.acctId + '\' ') 
                    + ' And Customer__r.SALES_TERRITORY_CDE__c = \'' + rsmCBC.territoryCode + '\' '
                    + ' AND  (Type__c = \'GPL\' ' 
                    + ' OR Type__c = \'' + ClsAPLForecastUtil.OTHERFCTYPE + '\')'
                    + ' And Customer__r.STATDESC__c = \'Active\' '
                    + ClsAPLForecastUtil.getMonthFilter(rsmCBC.map_year_quartersFuture) +
                    ' Group by Fiscal_Year__c, Fiscal_Quarter__c, GPL__r.CBC2__c, GPL__r.CBC3__c ');
        
        list<String> list_relaysql = new list<String>();    
        list_relaysql.add(' Fiscal_Year__c year, sum(RSM_Forecast__c) fc,  '        //, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
                    + ' sum(Forecast__c) amFC, sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter, '
                    + ' Relay_CBC2_Code__c cbc2Name  ');    
        list_relaysql.add(' APL_Sales_Forecast__c ');
        list_relaysql.add(' WHERE Customer__r.APL_AM_forecast_Plan_Account__c = ' 
                    + (rsmCBC.acctId == ClsAPLForecastUtil.OTHERACCTID ? ' null ' : '\'' +  rsmCBC.acctId + '\' ') 
                    + ' And Customer__r.SALES_TERRITORY_CDE__c = \'' + rsmCBC.territoryCode + '\' '
                    + ' AND Type__c = \'' +APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' ' 
                    + APL_ClsUtils.getRelayCBC2CodeQuery() 
                    + ' And Customer__r.STATDESC__c = \'Active\' '
                    + ClsAPLForecastUtil.getMonthFilter(rsmCBC.map_year_quartersFuture) +
                    ' Group by Fiscal_Year__c, Fiscal_Quarter__c, Relay_CBC2_Code__c ');            
        
        //Generate forecast view result
        system.debug('getRSMCBCFC query :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        for(AggregateResult  result : Database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String year = (String) result.get('year'),
                   quarter = (String) result.get('quarter'), 
                   dateKey = (year + '_' + quarter),
                   cbc2 = (String) (result.get('cbc2Name') == null ? '' : result.get('cbc2Name')),
                   cbc3 = (String) (result.get('cbc3Name') == null ? '' : result.get('cbc3Name')),
                   cbcName = ClsAPLForecastUtil.getCBCKeyName(cbc2, cbc3);
            
            if(!map_cbcKey_cbcFC.containsKey(cbcName)) {
                ClsAPLEntityTypes.CBCFCValueObj cbcFC = new ClsAPLEntityTypes.CBCFCValueObj();
                
                cbcFC.fieldName = rsmCBC.map_cbcRowKey_cbcName.get(cbcName);
                cbcFC.rsmTypeName = (cbcName == ClsAPLForecastUtil.CBCOTHER ? 'ClsAPLEntityTypes.RSMPartFCInfo' : cbcFC.rsmTypeName);
                map_cbcKey_cbcFC.put(cbcName, cbcFC);
            }
            ClsAPLEntityTypes.CBCFCValueObj cbcFC = map_cbcKey_cbcFC.get(cbcName);
            cbcFC = (ClsAPLEntityTypes.CBCFCValueObj) cbcFC.assignFCValues(cbcFC, result, dateKey);
            
        }
        
        for(AggregateResult  result : Database.query(ClsAPLForecastUtil.getQueryString(list_relaysql))) {
            String year = (String) result.get('year'),
                   quarter = (String) result.get('quarter'), 
                   dateKey = (year + '_' + quarter),
                   cbc2 = (String) (result.get('cbc2Name') == null ? '' : result.get('cbc2Name')),
                   //cbc3 = (String) (result.get('cbc2Name') == null ? '' : result.get('cbc2Name')),
                   cbcName = ClsAPLForecastUtil.getCBCKeyName(cbc2, cbc2);
            
            if(!map_cbcKey_cbcFC.containsKey(cbcName)) {
                ClsAPLEntityTypes.CBCFCValueObj cbcFC = new ClsAPLEntityTypes.CBCFCValueObj();
                
                cbcFC.fieldName = rsmCBC.map_cbcRowKey_cbcName.get(cbcName);
                cbcFC.rsmTypeName = (cbcName == ClsAPLForecastUtil.CBCOTHER ? 'ClsAPLEntityTypes.RSMPartFCInfo' : cbcFC.rsmTypeName);
                map_cbcKey_cbcFC.put(cbcName, cbcFC);
            }
            ClsAPLEntityTypes.CBCFCValueObj cbcFC = map_cbcKey_cbcFC.get(cbcName);
            cbcFC = (ClsAPLEntityTypes.CBCFCValueObj) cbcFC.assignFCValues(cbcFC, result, dateKey);
            
        }
        
        
        //build map for all the cbcs & quarters
        for(String cbcKey : rsmCBC.map_cbcRowKey_cbcName.keySet()) {
            for(String year : rsmCBC.map_year_quartersFuture.keySet()) {
                for(String quarter : rsmCBC.map_year_quartersFuture.get(year)) {
                    
                    String dateKey = (year + '_' + quarter);
                    AggregateResult result;
                    
                    if(!map_cbcKey_cbcFC.containsKey(cbcKey)) {
                        ClsAPLEntityTypes.CBCFCValueObj cbcFC = new ClsAPLEntityTypes.CBCFCValueObj();
                        
                        cbcFC.fieldName = rsmCBC.map_cbcRowKey_cbcName.get(cbcKey);
                        cbcFC.rsmTypeName = (cbcKey == ClsAPLForecastUtil.CBCOTHER ? 'ClsAPLEntityTypes.RSMPartFCInfo' : cbcFC.rsmTypeName);
                        map_cbcKey_cbcFC.put(cbcKey, cbcFC);
                    }
                    ClsAPLEntityTypes.CBCFCValueObj cbcFC = map_cbcKey_cbcFC.get(cbcKey);
                    cbcFC = (ClsAPLEntityTypes.CBCFCValueObj) cbcFC.assignFCValues(cbcFC, result, dateKey);
                }
            }
        }
        //prepare result
        system.debug('map_cbcKey_cbcFC :: ' + map_cbcKey_cbcFC);
        acctFCResult.json_result = Json.serialize(map_cbcKey_cbcFC.values());
        return acctFCResult;
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
    public static ClsAPLEntityTypes.AcctFCResults getRSMCBCRefData(ClsAPLEntityTypes.RSMCBCFCInfo rsmCBC) {
        ClsAPLEntityTypes.AcctFCResults result = new ClsAPLEntityTypes.AcctFCResults();
        String startDate = ClsAPLForecastUtil.getStartDate(rsmCBC.list_dateKey[0]),
               endDate = ClsAPLForecastUtil.getEndDate(rsmCBC.list_dateKey[2]);
        
        Integer startYear = Integer.valueOf(startDate.subStringBefore('-')), 
               startMonth = Integer.valueOf(startDate.subStringBetween('-', '-')), 
               endYear = Integer.valueOf(endDate.subStringBefore('-')), 
               endMonth = Integer.valueOf(endDate.subStringBetween('-', '-')), 
               currentYear = Integer.valueOf(rsmCBC.currentYear),
               currentMonth = Integer.valueOf(rsmCBC.currentMonth); 
        Date date_endDate = Date.newInstance(endYear, endMonth, 1);
        Date date_currentDate = Date.newInstance(currentYear, currentMonth, 1);
        Date date_startDate = Date.newInstance(startYear, startMonth, 1);
        map<String, set<Integer>> map_fiscalMonth = ClsAPLForecastUtil.getFiscalMonthMap(rsmCBC.list_dateKey);
        
        ClsAPLEntityTypes.CBCFCValueObj fcViewObj = new ClsAPLEntityTypes.CBCFCValueObj();
        if(date_endDate < date_currentDate) {
            getCBCHistoryRefData(rsmCBC.acctId, rsmCBC.territoryCode, startDate, endDate, rsmCBC.cbcCode, 
                                    rsmCBC.list_dateKey, fcViewObj);
            getCBCHisBacklogRefData(rsmCBC.acctId, rsmCBC.territoryCode, rsmCBC.cbcCode, startDate, endDate,
                                    map_fiscalMonth, rsmCBC.list_dateKey, fcViewObj);
        }
        else if(date_currentDate < date_startDate) {
            getCBCFutureRefData(rsmCBC.acctId, rsmCBC.territoryCode, rsmCBC.cbcCode, startDate, endDate,
                                map_fiscalMonth, rsmCBC.list_dateKey, fcViewObj);
        }
        else {
            String currentEndDate =  ClsAPLForecastUtil.getEndDate(rsmCBC.currentYear + '_' + rsmCBC.currentMonth);
            map<String, set<Integer>> map_history = new map<String, set<Integer>>();
            map<String, set<Integer>> map_future = new map<String, set<Integer>>();
            ClsAPLForecastUtil.getDividedFiscalMap(date_currentDate, rsmCBC.list_dateKey, map_history, map_future);
            
            getCBCHistoryRefData(rsmCBC.acctId, rsmCBC.territoryCode, startDate, currentEndDate, rsmCBC.cbcCode, 
                                    rsmCBC.list_dateKey, fcViewObj);
            if(!map_history.isEmpty()) {
                getCBCHisBacklogRefData(rsmCBC.acctId, rsmCBC.territoryCode, rsmCBC.cbcCode, startDate, currentEndDate,
                                        map_history, rsmCBC.list_dateKey, fcViewObj);
            }
            if(!map_future.isEmpty()) {
                getCBCCurrentRefData(rsmCBC.acctId, rsmCBC.territoryCode, rsmCBC.cbcCode, rsmCBC.currentYear, Integer.valueOf(rsmCBC.currentMonth),
                                     fcViewObj);
                getCBCFutureRefData(rsmCBC.acctId, rsmCBC.territoryCode, rsmCBC.cbcCode, currentEndDate, endDate,
                                        map_future, rsmCBC.list_dateKey, fcViewObj);
            }                       
        }
        
        fcViewObj.cls = String.join(rsmCBC.list_dateKey, ',');
        fcViewObj.fieldName = rsmCBC.cbcCode;
        result.json_result = Json.serialize(fcViewObj);                     
        return result;
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
    public static void getCBCHistoryRefData(String parentId, String territoryCode,
                                            String startDate, String endDate, String cbcCode,
                                            list<String> list_dateKey,
                                            ClsAPLEntityTypes.CBCFCValueObj fcViewObj) {
                                                
        //get children account ids first
        set<String> set_acctIds = new set<String>();
        ClsAPLForecastUtil.setAccountIds(true, parentId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        map<String, map<String, ClsAPLEntityTypes.CBCFCValueObj>> map_cbc2Name_map_dateKey_result = new map<String, map<String, ClsAPLEntityTypes.CBCFCValueObj>>();
        
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking, Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds ' 
                    + (cbcCode == ClsAPLForecastUtil.CBCOTHER ? ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\'', '') : '')
                    + (cbcCode == ClsAPLForecastUtil.CBCRELAY ? ClsAPLForecastUtil.getRelayPartQuery() : '')
                    + ((cbcCode != ClsAPLForecastUtil.CBCOTHER && cbcCode != ClsAPLForecastUtil.CBCRELAY) 
                                    ? 'And Part__r.Product_Hierarchy__r.CBC2__c = \'' + cbcCode +'\'' : '')
                                    
                    + ' And Fiscal_Date__c >= ' + startDate
                    + ' And Fiscal_Date__c < ' + endDate
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

            fcViewObj = (ClsAPLEntityTypes.CBCFCValueObj) fcViewObj.assignRefData(fcViewObj, result, dateKey, true);
        }
        //generate forecast view objects for each quarter
        for(String dateKey : list_dateKey) {
            AggregateResult result;
            fcViewObj = fcViewObj.assignRefData(fcViewObj, result, dateKey, true);
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
    public static void getCBCHisBacklogRefData(String parentId, String territoryCode,
                                            String cbcCode, String startDate, String endDate,
                                            map<String, set<Integer>> map_fiscalMonth, list<String> list_dateKey,
                                            ClsAPLEntityTypes.CBCFCValueObj fcViewObj) {

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

            fcViewObj = (ClsAPLEntityTypes.CBCFCValueObj) fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey);
        }
        //generate forecast view objects for each quarter
        for(String dateKey : list_dateKey) {
            AggregateResult result;
            fcViewObj = fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey);
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
    public static void getCBCCurrentRefData(String parentId, String territoryCode,
                                            String cbcCode, String year, Integer month,
                                            ClsAPLEntityTypes.CBCFCValueObj fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
        ClsAPLForecastUtil.setAccountIds(true, parentId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds ' 
                    
                    + (cbcCode == ClsAPLForecastUtil.CBCOTHER ? ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\'', '') : '')
                    + (cbcCode == ClsAPLForecastUtil.CBCRELAY ? ClsAPLForecastUtil.getRelayPartQuery() : '')
                    + ((cbcCode != ClsAPLForecastUtil.CBCOTHER && cbcCode != ClsAPLForecastUtil.CBCRELAY) 
                                    ? 'And Part__r.Product_Hierarchy__r.CBC2__c = \'' + cbcCode +'\'' : '')
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0 ) '             
                    + ' And Fiscal_Year__c = \'' + year +'\''
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' And Fiscal_Month__c = ' + month );
                    
        system.debug('getCBC2RefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        String dateKey = year + '_' + month;
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            fcViewObj = (ClsAPLEntityTypes.CBCFCValueObj) fcViewObj.assignRefData(fcViewObj, result, dateKey, true);
        }
        //generate forecast view objects for each quarter
        AggregateResult result;
        fcViewObj = fcViewObj.assignRefData(fcViewObj, result, dateKey, true);
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
    public static void getCBCFutureRefData(String parentId, String territoryCode,
                                            String cbcCode, String startDate, String endDate,
                                            map<String, set<Integer>> map_fiscalMonth, list<String> list_dateKey,
                                            ClsAPLEntityTypes.CBCFCValueObj fcViewObj) {

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
                    + ' And Backlog_Amount_USD__c != 0 '            
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '    
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_fiscalMonth)
                    + ' Group by Customer_Request_Date_Fiscal_Date__c' );
        system.debug('getCBC2RefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;

            fcViewObj = (ClsAPLEntityTypes.CBCFCValueObj) fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey);
        }
        //generate forecast view objects for each quarter
        for(String dateKey : list_dateKey) {
            AggregateResult result;
            fcViewObj = fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey);
        }
    }
    
   /**
    * This method is used to create a new interface instance
    *
    @author Bin Yuan
    @created 2014-06-02
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-02 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static ClsAPLEntityTypes.AcctFCResults getRSMGPLFC(ClsAPLEntityTypes.RSMGPLFCInfo rsmGPL) {
        ClsAPLEntityTypes.AcctFCResults acctFCResult = new ClsAPLEntityTypes.AcctFCResults();
        
        list<String> list_sql = new list<String>();
        map<String, map<String, AggregateResult>> map_gplId_map_dateKey_result =
            new map<String, map<String, AggregateResult>>();
        map<String, String> map_prodHichyId_gplCode = new map<String, String>();
        map<String, String> map_gplId_gplName = new map<String, String>();
        map<String, ClsAPLEntityTypes.GPLFCValueObj> map_gplId_gplFC 
            = new map<String, ClsAPLEntityTypes.GPLFCValueObj>();
        //set gpl code & gpl name map
        ClsAPLForecastUtil.setGPLCode(map_prodHichyId_gplCode, rsmGPL.cbc2Code, map_gplId_gplName);
        system.debug('@#rsmGPL.cbc2Code:'+rsmGPL.cbc2Code);
        system.debug('@#map_prodHichyId_gplCode:'+map_prodHichyId_gplCode);
        system.debug('@#map_gplId_gplName:'+map_gplId_gplName);
        
        //get query string for gpl forecast
        list_sql.add(' Fiscal_Year__c year, sum(RSM_Forecast__c) fc, GPL__c gplId,   '      //, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
                    + ' sum(Forecast__c) amFC, sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter ');
                    
        list_sql.add(' APL_Sales_Forecast__c ');
        list_sql.add(' WHERE Customer__r.APL_AM_forecast_Plan_Account__c = ' 
                    + (rsmGPL.acctId == ClsAPLForecastUtil.OTHERACCTID ? ' null ' : '\'' +  rsmGPL.acctId + '\' ') 
                    + ' And Customer__r.SALES_TERRITORY_CDE__c = \'' + rsmGPL.territoryCode + '\' '
                    + ' And Type__c = \'' + ClsAPLForecastUtil.GPLFCTYPE + '\' '
                    + ClsAPLForecastUtil.getMonthFilter(rsmGPL.map_year_quartersFuture)
                    + (rsmGPL.cbc2Code == ClsAPLForecastUtil.CBCRELAY ? ClsAPLForecastUtil.getRelayGPLQuery(false) : ' And GPL__r.CBC2__c =\'' + rsmGPL.cbc2Code + '\' ')
                    + ' And Customer__r.STATDESC__c = \'Active\' '
                    + ' Group by Fiscal_Year__c, Fiscal_Quarter__c, GPL__c ');
        //Generate forecast view result
        system.debug('getRSMGPLFC query :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        for(AggregateResult  result : Database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String year = (String) result.get('year'),
                   quarter = (String) result.get('quarter'), 
                   dateKey = (year + '_' + quarter),
                   gplId = (String) result.get('gplId');
            
            ClsAPLForecastUtil.setResultMap(result, gplId, dateKey, map_gplId_map_dateKey_result);
        }
        //build map for all the cbcs & quarters
        for(String gplId : map_gplId_gplName.keySet()) {
            for(String year : rsmGPL.map_year_quartersFuture.keySet()) {
                for(String quarter : rsmGPL.map_year_quartersFuture.get(year)) {
                    
                    String dateKey = (year + '_' + quarter);
                    AggregateResult result;
                    
                    if(map_gplId_map_dateKey_result.containsKey(gplId)
                        && map_gplId_map_dateKey_result.get(gplId).containsKey(dateKey)) {
                        
                        result = map_gplId_map_dateKey_result.get(gplId).get(dateKey);
                    }
                    if(!map_gplId_gplFC.containsKey(gplId)) {
                        ClsAPLEntityTypes.GPLFCValueObj gplFC = new ClsAPLEntityTypes.GPLFCValueObj();
                        gplFC.prodHichyId = gplId;
                        gplFC.fieldName = map_gplId_gplName.get(gplId);
                        gplFC.gplCode = map_prodHichyId_gplCode.get(gplId);
                        map_gplId_gplFC.put(gplId, gplFC);
                    }
                    ClsAPLEntityTypes.GPLFCValueObj gplFC = map_gplId_gplFC.get(gplId);
                    gplFC = (ClsAPLEntityTypes.GPLFCValueObj) gplFC.assignFCValues(gplFC, result, dateKey);
                }
            }
        }
        
        APL_ClsUtils.setRSMAMGPLHighlight(rsmGPL, map_gplId_gplFC);
        
        //prepare result
        acctFCResult.json_result = Json.serialize(map_gplId_gplFC.values());
        return acctFCResult;
    }
   /**
    * This method is used to create a new interface instance
    *
    @author Bin Yuan
    @created 2014-06-02
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-02 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static ClsAPLEntityTypes.AcctFCResults getRSMRelayCBCFC(ClsAPLEntityTypes.RSMGPLFCInfo rsmGPL) {
        ClsAPLEntityTypes.AcctFCResults acctFCResult = new ClsAPLEntityTypes.AcctFCResults();
        list<String> list_sortedRelayCBC = ClsAPLForecastUtil.getSortedRelayCBCKey();
        list<String> list_sql = new list<String>();
        list<ClsAPLEntityTypes.GPLFCValueObj> list_tempFC = new list<ClsAPLEntityTypes.GPLFCValueObj>();
        map<String, ClsAPLEntityTypes.GPLFCValueObj> map_cbcKey_fcViewObj = new map<String, ClsAPLEntityTypes.GPLFCValueObj>();
        //get query string for gpl forecast
        list_sql.add(' Fiscal_Year__c year, sum(RSM_Forecast__c) fc, '      //, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
                    + ' sum(Forecast__c) amFC, sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter, '
                    + ' Relay_CBC2_Code__c cbc2Name ');
                    
        list_sql.add(' APL_Sales_Forecast__c ');
        list_sql.add(' WHERE Customer__r.APL_AM_forecast_Plan_Account__c = ' 
                    + (rsmGPL.acctId == ClsAPLForecastUtil.OTHERACCTID ? ' null ' : '\'' +  rsmGPL.acctId + '\' ') 
                    + ' And Customer__r.SALES_TERRITORY_CDE__c = \'' + rsmGPL.territoryCode + '\' '
                    + ' And Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' '
                    + ClsAPLForecastUtil.getMonthFilter(rsmGPL.map_year_quartersFuture)
                    + APL_ClsUtils.getRelayCBC2CodeQuery()
                    + ' And Customer__r.STATDESC__c = \'Active\' '
                    + ' Group by Fiscal_Year__c, Fiscal_Quarter__c, Customer__c,Relay_CBC2_Code__c ');
        system.debug('query :: ' + ClsAPLForecastUtil.getQueryString(list_sql));            
        for(AggregateResult  result : Database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String year = (String) result.get('year');
            String cbcKeyName = (String) result.get('cbc2Name');
            //String cbc3Name = (String) result.get('cbc3Name');
            //String cbcKeyName = ClsAPLForecastUtil.getRelayCBCKey(cbc2Name, cbc3Name);
            String quarter = (String) result.get('quarter');
            String dateKey = year + '_' + quarter;
            if(!map_cbcKey_fcViewObj.containsKey(cbcKeyName)) {
                map_cbcKey_fcViewObj.put(cbcKeyName, new ClsAPLEntityTypes.GPLFCValueObj());
            }
            ClsAPLEntityTypes.GPLFCValueObj gplFC = map_cbcKey_fcViewObj.get(cbcKeyName);
            gplFC = (ClsAPLEntityTypes.GPLFCValueObj) gplFC.assignFCValues(gplFC, result, dateKey);
        }
        //build map for all the cbcs & quarters
        for(String cbcKey : list_sortedRelayCBC) {
            for(String year : rsmGPL.map_year_quartersFuture.keySet()) {
                for(String quarter : rsmGPL.map_year_quartersFuture.get(year)) {
                    
                    String dateKey = (year + '_' + quarter);
                    AggregateResult result;
                    
                    if(!map_cbcKey_fcViewObj.containsKey(cbcKey)) {
                        map_cbcKey_fcViewObj.put(cbcKey, new ClsAPLEntityTypes.GPLFCValueObj());
                    }
                    ClsAPLEntityTypes.GPLFCValueObj gplFC = map_cbcKey_fcViewObj.get(cbcKey);
                    gplFC = (ClsAPLEntityTypes.GPLFCValueObj) gplFC.assignFCValues(gplFC, result, dateKey);
                }
            }
        }
        //prepare result
        for(String cbcKey : list_sortedRelayCBC) {
            ClsAPLEntityTypes.GPLFCValueObj gplFC = map_cbcKey_fcViewObj.get(cbcKey);
            gplFC.fieldName = ClsAPLForecastUtil.map_RELAY_CBCCode_CBCDESC.get(cbcKey);
            gplFC.gplCode = cbcKey;
            gplFC.prodHichyId = cbcKey;
            list_tempFC.add(gplFC);
        }
        acctFCResult.json_result = Json.serialize(list_tempFC);
        return acctFCResult;
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
    public static ClsAPLEntityTypes.AcctFCResults getRSMGPLRefData(ClsAPLEntityTypes.RSMGPLFCInfo rsmGPL) {
        ClsAPLEntityTypes.AcctFCResults result = new ClsAPLEntityTypes.AcctFCResults();
        String startDate = ClsAPLForecastUtil.getStartDate(rsmGPL.list_dateKey[0]),
               endDate = ClsAPLForecastUtil.getEndDate(rsmGPL.list_dateKey[2]);
        Integer startYear = Integer.valueOf(startDate.subStringBefore('-')), 
               startMonth = Integer.valueOf(startDate.subStringBetween('-', '-')), 
               endYear = Integer.valueOf(endDate.subStringBefore('-')), 
               endMonth = Integer.valueOf(endDate.subStringBetween('-', '-')), 
               currentYear = Integer.valueOf(rsmGPL.currentYear),
               currentMonth = Integer.valueOf(rsmGPL.currentMonth); 
        Date date_endDate = Date.newInstance(endYear, endMonth, 1);
        Date date_currentDate = Date.newInstance(currentYear, currentMonth, 1);
        Date date_startDate = Date.newInstance(startYear, startMonth, 1);
        map<String, set<Integer>> map_fiscalMonth = ClsAPLForecastUtil.getFiscalMonthMap(rsmGPL.list_dateKey);
        ClsAPLEntityTypes.GPLFCValueObj fcViewObj = new ClsAPLEntityTypes.GPLFCValueObj();
        if(date_endDate < date_currentDate) {
            getGPLHistoryRefData(rsmGPL.acctId, rsmGPL.territoryCode, rsmGPL.gplId, rsmGPL.cbcCode, startDate, endDate, 
                                    rsmGPL.list_dateKey, fcViewObj);
            getGPLHisBacklogRefData(rsmGPL.acctId, rsmGPL.territoryCode, rsmGPL.gplId, rsmGPL.cbcCode, startDate, endDate,
                                    map_fiscalMonth, rsmGPL.list_dateKey, fcViewObj);
        }
        else if(date_currentDate < date_startDate) {
            getGPLFutureRefData(rsmGPL.acctId, rsmGPL.territoryCode, rsmGPL.gplId, rsmGPL.cbcCode, startDate, endDate,
                                map_fiscalMonth, rsmGPL.list_dateKey, fcViewObj);
        }
        else {
            String currentEndDate =  ClsAPLForecastUtil.getEndDate(rsmGPL.currentYear + '_' + rsmGPL.currentMonth);
            map<String, set<Integer>> map_history = new map<String, set<Integer>>();
            map<String, set<Integer>> map_future = new map<String, set<Integer>>();
            ClsAPLForecastUtil.getDividedFiscalMap(date_currentDate, rsmGPL.list_dateKey, map_history, map_future);
                                
            getGPLHistoryRefData(rsmGPL.acctId, rsmGPL.territoryCode, rsmGPL.gplId, rsmGPL.cbcCode, startDate, currentEndDate, 
                                    rsmGPL.list_dateKey, fcViewObj);
            if(!map_history.isEmpty()) {
                getGPLHisBacklogRefData(rsmGPL.acctId, rsmGPL.territoryCode, rsmGPL.gplId, rsmGPL.cbcCode, startDate, currentEndDate,
                                        map_history, rsmGPL.list_dateKey, fcViewObj);
            }
            if(!map_future.isEmpty()) {
                getGPLCurrentRefData(rsmGPL.acctId, rsmGPL.territoryCode, rsmGPL.gplId, rsmGPL.cbcCode, rsmGPL.currentYear, Integer.valueOf(rsmGPL.currentMonth),
                                     fcViewObj);
                getGPLFutureRefData(rsmGPL.acctId, rsmGPL.territoryCode, rsmGPL.gplId, rsmGPL.cbcCode, currentEndDate, endDate,
                                        map_future, rsmGPL.list_dateKey, fcViewObj);
                
            }
        }
        result.json_result = Json.serialize(fcViewObj); 
        fcViewObj.cls = String.join(rsmGPL.list_dateKey, ',');                  
        return result;
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
    public static void getGPLHistoryRefData(String acctId, String territoryCode, String gplId, 
                                            String cbcCode, String startDate, String endDate,
                                            list<String> list_dateKey,
                                            ClsAPLEntityTypes.GPLFCValueObj fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
        ClsAPLForecastUtil.setAccountIds(true, acctId, territoryCode, set_acctIds);                                             

        list<String> list_sql = new list<String>();
        map<String, map<String, AggregateResult>> map_gplId_map_dateKey_result = new map<String, map<String, AggregateResult>>();
        
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking, Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds ' 
                    + (cbcCode == 'Relay' ? ClsAPLForecastUtil.getRelayCBCFilter(gplId) : ' And Part__r.Product_Hierarchy__c = \'' + gplId + '\'')
                    + ' And Fiscal_Date__c >= ' + startDate
                    + ' And Fiscal_Date__c < ' + endDate
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' Group by Fiscal_Date__c');

        system.debug('getCBC2RefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;
            
            fcViewObj = fcViewObj.assignRefData(fcViewObj, result, dateKey, true);
        }
        //generate forecast view objects for each quarter
        for(String dateKey : list_dateKey) {
            AggregateResult result;
            fcViewObj = fcViewObj.assignRefData(fcViewObj, result, dateKey, true);
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
    public static void getGPLHisBacklogRefData(String acctId, String territoryCode, String gplId,
                                            String cbcCode, String startDate, String endDate,
                                            map<String, set<Integer>> map_fiscalMonth, list<String> list_dateKey,
                                            ClsAPLEntityTypes.GPLFCValueObj fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
        ClsAPLForecastUtil.setAccountIds(true, acctId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        map<String, map<String, AggregateResult>> map_gplId_map_dateKey_result = new map<String, map<String, AggregateResult>>();
        
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds ' 
                    + (cbcCode == 'Relay' ? ClsAPLForecastUtil.getRelayCBCFilter(gplId) : ' And Part__r.Product_Hierarchy__c = \'' + gplId + '\'')
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_fiscalMonth) 
                    + ' And Backlog_Amount_USD__c != 0 '
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' Group by Customer_Request_Date_Fiscal_Date__c '
                    );
                    
        system.debug('getCBCFutureRefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;
            
            fcViewObj = fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey);
        }
        //generate forecast view objects for each quarter
        for(String dateKey : list_dateKey) {
            AggregateResult result;
            fcViewObj = fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey);
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
    public static void getGPLCurrentRefData(String acctId, String territoryCode, String gplId,
                                            String cbcCode, String year, Integer month,
                                            ClsAPLEntityTypes.GPLFCValueObj fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
        ClsAPLForecastUtil.setAccountIds(true, acctId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        map<String, map<String, AggregateResult>> map_gplId_map_dateKey_result = new map<String, map<String, AggregateResult>>();
        
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
            fcViewObj = fcViewObj.assignRefData(fcViewObj, result, dateKey, true);
        }
        //generate forecast view objects for each quarter
        AggregateResult result;
        fcViewObj = fcViewObj.assignRefData(fcViewObj, result, dateKey, true);
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
    public static void getGPLFutureRefData(String acctId, String territoryCode, String gplId,
                                            String cbcCode, String startDate, String endDate,
                                            map<String, set<Integer>> map_fiscalMonth, list<String> list_dateKey,
                                            ClsAPLEntityTypes.GPLFCValueObj fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
        ClsAPLForecastUtil.setAccountIds(true, acctId, territoryCode, set_acctIds);

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
            
            fcViewObj = fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey);
        }
        //generate forecast view objects for each quarter
        for(String dateKey : list_dateKey) {
            AggregateResult result;
            fcViewObj = fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey);
        }
    }
    
    /**
    * This method is used get account cbc forecast
    * 
    *
    @author Lei Tang
    @created 2014-06-03
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *@param FCInfo request - parentId is AccountId
    *@return FCResults - include APL_Sales_Forecast__c list
    *
    @changelog
    * 2014-06-0-3 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public static ClsAPLEntityTypes.AcctFCResults getRSMPartFC(ClsAPLEntityTypes.RSMPartFCInfo rsmPart) {
        
        ClsAPLEntityTypes.AcctFCResults acctFCResult = new ClsAPLEntityTypes.AcctFCResults();
        
        list<String> list_sql = new list<String>();
        map<String, map<String, AggregateResult>> map_partId_map_dateKey_result =
            new map<String, map<String, AggregateResult>>();
        map<String, String> map_partId_partName = new map<String, String>();
        map<String, ClsAPLEntityTypes.PartFCValueObj> map_partId_partFC 
            = new map<String, ClsAPLEntityTypes.PartFCValueObj>();

        
        //get query string for gpl forecast
        list_sql.add(' Fiscal_Year__c year, sum(RSM_Forecast__c) fc, Part__c partId, Part__r.Description__c partDesc, '         //, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
                    + 'Part__r.Name partName, sum(Forecast__c) amFC, sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter ');
                    
        list_sql.add(' APL_Sales_Forecast__c ');
        list_sql.add(' WHERE Customer__r.APL_AM_forecast_Plan_Account__c = ' 
                    + (rsmPart.acctId == ClsAPLForecastUtil.OTHERACCTID ? ' null ' : '\'' +  rsmPart.acctId + '\' ') 
                    + ' And Customer__r.SALES_TERRITORY_CDE__c = \'' + rsmPart.territoryCode + '\' '
                    + ' And Part__c != null '
                    + ClsAPLForecastUtil.getMonthFilter(rsmPart.map_year_quartersFuture)
                    + (rsmPart.cbc2Code == ClsAPLForecastUtil.CBCOTHER ? ' And ' + ClsAPLForecastUtil.getOtherPartQuery() 
                        : (rsmPart.cbc2Code == ClsAPLForecastUtil.RELAYFCTYPE ? ClsAPLForecastUtil.getRelayCBCFilter(rsmPart.gplId) : ' And GPL__c =\'' + rsmPart.gplId + '\' '))
                    + ' And Customer__r.STATDESC__c = \'Active\' '
                    + ' Group by Part__c, Part__r.Name, Part__r.Description__c, Fiscal_Year__c, Fiscal_Quarter__c ');
        system.debug('getGAMPartFC query :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //Generate forecast view result
        for(AggregateResult  result : Database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String year = (String) result.get('year'),
                   quarter = (String) result.get('quarter'), 
                   dateKey = (year + '_' + quarter),
                   partId = (String) result.get('partId'),
                   partName = (String) result.get('partName');
                   
            map_partId_partName.put(partId, partName);
            ClsAPLForecastUtil.setResultMap(result, partId, dateKey, map_partId_map_dateKey_result);
        }
        //build map for all the cbcs & quarters
        for(String partId : map_partId_partName.keySet()) {
            for(String year : rsmPart.map_year_quartersFuture.keySet()) {
                for(String quarter : rsmPart.map_year_quartersFuture.get(year)) {
                    
                    String dateKey = (year + '_' + quarter);
                    AggregateResult result;
                    
                    if(map_partId_map_dateKey_result.containsKey(partId)
                        && map_partId_map_dateKey_result.get(partId).containsKey(dateKey)) {
                        
                        result = map_partId_map_dateKey_result.get(partId).get(dateKey);
                    }
                    if(!map_partId_partFC.containsKey(partId)) {
                        ClsAPLEntityTypes.PartFCValueObj partFC = new ClsAPLEntityTypes.PartFCValueObj();
                        partFC.partId = partId;
                        partFC.fieldName = map_partId_partName.get(partId);
                        map_partId_partFC.put(partId, partFC);
                    }
                    ClsAPLEntityTypes.PartFCValueObj partFC = map_partId_partFC.get(partId);
                    partFC = (ClsAPLEntityTypes.PartFCValueObj) partFC.assignFCValues(partFC, result, dateKey);
                }
            }
        }
        //Get part reference data 
        if(rsmPart.map_year_monthsHistory != null && !rsmPart.map_year_monthsHistory.isEmpty()) {
            getPartHistoryRefData(rsmPart.acctId, rsmPart.territoryCode, rsmPart.gplId, rsmPart.cbc2Code, rsmPart.map_year_monthsHistory, map_partId_partFC);   
        }
        if(rsmPart.refStartDate != null && rsmPart.periodStartDate != null) {
            getPartHisBacklogRefData(rsmPart.acctId, rsmPart.territoryCode, rsmPart.gplId, rsmPart.cbc2Code, rsmPart.periodStartDate, rsmPart.refStartDate, rsmPart.map_year_monthsHistory,
                                map_partId_partFC);
        }
        if(rsmPart.refStartDate != null && rsmPart.refEndDate != null) {
            getPartCurrentRefData(rsmPart.acctId, rsmPart.territoryCode, rsmPart.gplId,
                                    rsmPart.cbc2Code, rsmPart.currentYear, Integer.valueOf(rsmPart.currentMonth),
                                    map_partId_partFC);
            getPartFutureRefData(rsmPart.acctId, rsmPart.territoryCode, rsmPart.gplId, rsmPart.cbc2Code, rsmPart.refStartDate, rsmPart.refEndDate, rsmPart.map_year_monthsFuture,
                                map_partId_partFC);
        }
        //prepare result
        acctFCResult.json_result = Json.serialize(map_partId_partFC.values());
        
        return acctFCResult;
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
    public static void getPartHistoryRefData(String acctId, String territoryCode, String gplId,
                                            String cbc2Code,
                                            map<String, set<Integer>> map_year_monthsHistory,
                                            map<String, ClsAPLEntityTypes.PartFCValueObj> map_partId_fcViewObj) {
                                                
        //get children account ids first
        set<String> set_acctIds = new set<String>();
        ClsAPLForecastUtil.setAccountIds(true, acctId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        set<String> set_partIds = new set<String>();
        map<String, map<String, AggregateResult>> map_partId_map_dateKey_result =
            new map<String, map<String, AggregateResult>>();
        set_partIds.addAll(map_partId_fcViewObj.keySet());
        
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking, Fiscal_Date__c fiscal_date, '
                    + ' Part__c partId ');
        list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds ' 
                    + (cbc2Code == ClsAPLForecastUtil.CBCOTHER ? 
                            ' And ' + ClsAPLForecastUtil.getOtherPartQuery() 
                            : (cbc2Code == ClsAPLForecastUtil.RELAYFCTYPE ? ClsAPLForecastUtil.getRelayCBCFilter(gplId) : ' And Part__r.Product_Hierarchy__c =\'' + gplId + '\' '))
                    + ' And Part__c IN : set_partIds '
                    + (ClsAPLForecastUtil.getFiscalMonthFilter(map_year_monthsHistory) == '' ? '' 
                            : ClsAPLForecastUtil.getFiscalMonthFilter(map_year_monthsHistory))
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '  
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '    
                    + 'Group by Fiscal_Date__c, Part__c'
                    );

        system.debug('getPartHistoryRefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String partId = (String) result.get('partId');
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;
            
            ClsAPLForecastUtil.setResultMap(result, partId, dateKey, map_partId_map_dateKey_result);
        }
        //generate forecast view objects for each quarter
        for(String partId : map_partId_fcViewObj.keySet()) {
            for(String year : map_year_monthsHistory.keySet()) {
                for(Integer month : map_year_monthsHistory.get(year)) {
                    String dateKey = year + '_' + month;
                    AggregateResult result;
                    
                    if(map_partId_map_dateKey_result.containsKey(partId)
                        && map_partId_map_dateKey_result.get(partId).containsKey(dateKey)) {
                        
                        result = map_partId_map_dateKey_result.get(partId).get(dateKey);
                    }
                    
                    ClsAPLEntityTypes.PartFCValueObj fcObj = map_partId_fcViewObj.get(partId);
                    fcObj = fcObj.assignRefData(fcObj, result, dateKey, true);
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
    public static void getPartHisBacklogRefData(String parentId, String territoryCode, String gplId,
                                            String cbc2Code,
                                            String backlogStartDate, String backlogEndDate,
                                            map<String, set<Integer>> map_year_monthsFuture,
                                            map<String, ClsAPLEntityTypes.PartFCValueObj> map_partId_fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
        ClsAPLForecastUtil.setAccountIds(true, parentId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        map<String, map<String, AggregateResult>> map_partId_map_dateKey_result =
            new map<String, map<String, AggregateResult>>();
        set<String> set_partIds = new set<String>();
        set_partIds.addAll(map_partId_fcViewObj.keySet());
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date__c fiscal_date, Part__c partId ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds ' 
                    + (cbc2Code == ClsAPLForecastUtil.CBCOTHER 
                            ? ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And Type__c = \'Part\'', '') 
                            : (cbc2Code == ClsAPLForecastUtil.RELAYFCTYPE ? ClsAPLForecastUtil.getRelayCBCFilter(gplId) :' And Part__r.Product_Hierarchy__c =\'' + gplId + '\' '))
                    + ' And Part__c IN : set_partIds '
                    + ' And Customer_Request_Date__c >= ' + backlogStartDate 
                    + ' And Customer_Request_Date__c < ' + backlogEndDate
                    + ' And Backlog_Amount_USD__c != 0 '
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + 'Group by Customer_Request_Date__c, Part__c '
                    );
                    
        system.debug('getPartFutureRefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String partId = (String) result.get('partId');
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;
            
            ClsAPLForecastUtil.setResultMap(result, partId, dateKey, map_partId_map_dateKey_result);
        }
        //generate forecast view objects for each quarter
        for(String partId : map_partId_fcViewObj.keySet()) {
            for(String year : map_year_monthsFuture.keySet()) {
                for(Integer month : map_year_monthsFuture.get(year)) {
                    String dateKey = year + '_' + month;
                    AggregateResult result;
                    
                    if(map_partId_map_dateKey_result.containsKey(partId)
                        && map_partId_map_dateKey_result.get(partId).containsKey(dateKey)) {
                        
                        result = map_partId_map_dateKey_result.get(partId).get(dateKey);
                    }
                    ClsAPLEntityTypes.PartFCValueObj fcObj = map_partId_fcViewObj.get(partId);
                    fcObj = fcObj.assignHisBacklogRefData(fcObj, result, dateKey);
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
    public static void getPartCurrentRefData(String parentId, String territoryCode, String gplId,
                                            String cbc2Code,
                                            String year, Integer month,
                                            map<String, ClsAPLEntityTypes.PartFCValueObj> map_partId_fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
        ClsAPLForecastUtil.setAccountIds(true, parentId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        map<String, map<String, AggregateResult>> map_partId_map_dateKey_result =
            new map<String, map<String, AggregateResult>>();
        set<String> set_partIds = new set<String>();
        set_partIds.addAll(map_partId_fcViewObj.keySet());
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking, Part__c partId ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds ' 
                    + (cbc2Code == ClsAPLForecastUtil.CBCOTHER ? 
                                ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\'', '') 
                                : (cbc2Code == ClsAPLForecastUtil.RELAYFCTYPE ? ClsAPLForecastUtil.getRelayCBCFilter(gplId) :' And Part__r.Product_Hierarchy__c =\'' + gplId + '\' '))
                    + ' And Part__c IN : set_partIds '
                    + ' And Fiscal_Year__c = \'' + year +'\''
                    + ' And Fiscal_Month__c = ' + month +
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
                    + 'Group by Part__c '
                    );
                    
        system.debug('getPartFutureRefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        String dateKey = year + '_' + month;
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String partId = (String) result.get('partId');
            ClsAPLForecastUtil.setResultMap(result, partId, dateKey, map_partId_map_dateKey_result);
        }
        //generate forecast view objects for each quarter
        for(String partId : map_partId_fcViewObj.keySet()) {
            AggregateResult result;
            
            if(map_partId_map_dateKey_result.containsKey(partId)
                && map_partId_map_dateKey_result.get(partId).containsKey(dateKey)) {
                
                result = map_partId_map_dateKey_result.get(partId).get(dateKey);
            }
            ClsAPLEntityTypes.PartFCValueObj fcObj = map_partId_fcViewObj.get(partId);
            fcObj = fcObj.assignRefData(fcObj, result, dateKey, true);
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
    public static void getPartFutureRefData(String parentId, String territoryCode, String gplId,
                                            String cbc2Code,
                                            String refStartDate, String refEndDate,
                                            map<String, set<Integer>> map_year_monthsFuture,
                                            map<String, ClsAPLEntityTypes.PartFCValueObj> map_partId_fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
        ClsAPLForecastUtil.setAccountIds(true, parentId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        map<String, map<String, AggregateResult>> map_partId_map_dateKey_result =
            new map<String, map<String, AggregateResult>>();
        set<String> set_partIds = new set<String>();
        set_partIds.addAll(map_partId_fcViewObj.keySet());
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date__c fiscal_date, Part__c partId ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds ' 
                    + (cbc2Code == ClsAPLForecastUtil.CBCOTHER ? 
                                ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\'', '') 
                                : (cbc2Code == ClsAPLForecastUtil.RELAYFCTYPE ? ClsAPLForecastUtil.getRelayCBCFilter(gplId) :' And Part__r.Product_Hierarchy__c =\'' + gplId + '\' '))
                    + ' And Part__c IN : set_partIds '
                    + ' And Customer_Request_Date__c >= ' + refStartDate 
                    + ' And Customer_Request_Date__c < ' + refEndDate
                    + ' And Backlog_Amount_USD__c != 0 '
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + 'Group by Customer_Request_Date__c, Part__c '
                    );
                    
        system.debug('getPartFutureRefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String partId = (String) result.get('partId');
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;
            
            ClsAPLForecastUtil.setResultMap(result, partId, dateKey, map_partId_map_dateKey_result);
        }
        //generate forecast view objects for each quarter
        for(String partId : map_partId_fcViewObj.keySet()) {
            for(String year : map_year_monthsFuture.keySet()) {
                for(Integer month : map_year_monthsFuture.get(year)) {
                    String dateKey = year + '_' + month;
                    AggregateResult result;
                    
                    if(map_partId_map_dateKey_result.containsKey(partId)
                        && map_partId_map_dateKey_result.get(partId).containsKey(dateKey)) {
                        
                        result = map_partId_map_dateKey_result.get(partId).get(dateKey);
                    }
                    ClsAPLEntityTypes.PartFCValueObj fcObj = map_partId_fcViewObj.get(partId);
                    fcObj = fcObj.assignHisBacklogRefData(fcObj, result, dateKey);
                }
            }
        }
    }

    /**
    * This method is used to save GAM GPL forecast
    * 
    *
    @author Yuda Zheng
    @created 2014-06-12
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *@param     GAMGPLFCInfo GAM GPL forecast information
    *
    @changelog
    * 2014-06-12 Yuda Zheng <yuda.zheng@itbconsult.com>
    * - Created
    */
    public static void saveRSMGPLFC(ClsAPLEntityTypes.RSMGPLFCInfo gplFC) {
        map<String, map<String, APL_Sales_Forecast__c>> map_acctId_map_dateKey_fc = new map<String, map<String, APL_Sales_Forecast__c>>();
        map<String, map<String, map<String, APL_Sales_Forecast__c>>> map_partId_map_acctId_map_dateKey_fc = new map<String, map<String, map<String, APL_Sales_Forecast__c>>>();
        list<APL_Sales_Forecast__c> list_acctFC2Insert = new list<APL_Sales_Forecast__c>();
        list<APL_Sales_Forecast__c> list_acctFC2Update = new list<APL_Sales_Forecast__c>();
        list<APL_Sales_Forecast__c> list_acctFC2Delete = new list<APL_Sales_Forecast__c>();
        map<String, decimal> map_acctId_billingPercent = new map<String, decimal>();
        map<String, decimal> map_acctId_avgPercent = new map<String, decimal>();
        map<String, map<String, decimal>> map_partId_map_acctId_percent =
            new map<String, map<String, decimal>>();
        String fcType = (gplFC.cbc2Code == ClsAPLForecastUtil.CBCOTHER ? ClsAPLForecastUtil.OTHERFCTYPE : ClsAPLForecastUtil.PARTFCTYPE);
        
        getGPLPercentForSave(gplFC.acctId, gplFC.gplId, gplFC.territoryCode, gplFC.quarterNumb, gplFC.cbc2Code, 
                             map_acctId_billingPercent, map_acctId_avgPercent, map_partId_map_acctId_percent);
        
        if(gplFC.cbc2Code != ClsAPLForecastUtil.CBCOTHER) {
            //get existing acct
            getExistingGPLFC(gplFC.acctId, gplFC.gplId, gplFC.territoryCode, gplFC.map_year_quartersFuture, map_acctId_map_dateKey_fc);
            //create or update account forecast records
            ClsAPLForecastUtil.generateFC(map_acctId_billingPercent, gplFC.map_dateKey_fc, map_acctId_map_dateKey_fc, 
                        ClsAPLForecastUtil.GPLFCTYPE, gplFC.gplId, '', gplFC.currencyIso, false, false, true, list_acctFC2Insert, list_acctFC2Update, list_acctFC2Delete);
        }
        ClsAPLForecastUtil.aplFCRecordsDML(list_acctFC2Insert, list_acctFC2Update, list_acctFC2Delete);
        if(gplFC.list_parts == null || gplFC.list_parts.isEmpty()) {
            return;
        }
        //get existing acct
        getExistingPartFC(gplFC.acctId, gplFC.gplId, gplFC.territoryCode, gplFC.cbc2Code, gplFC.map_year_quartersFuture, map_partId_map_acctId_map_dateKey_fc);
        saveGAMPartFC(gplFC.list_parts, map_partId_map_acctId_map_dateKey_fc, gplFC.gplId, fcType, map_partId_map_acctId_percent, map_acctId_avgPercent,
                        list_acctFC2Insert, list_acctFC2Update, list_acctFC2Delete);
                      
        //INSERT, UPDATE, DELETE APL Forecasts
        ClsAPLForecastUtil.aplFCRecordsDML(list_acctFC2Insert, list_acctFC2Update, list_acctFC2Delete);
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
    public static void getGPLPercentForSave(String parentId, String gplId, String territoryCode, 
                                            String quartNumb, String cbcCode, 
                                            map<String, decimal> map_acctId_gplPercent, 
                                            map<String, decimal> map_acctId_avgPercent,
                                            map<String, map<String, decimal>> map_partId_map_acctId_partPercent) {
        
        decimal gplTotalAmount = 0;
        map<String, decimal> map_partId_totalAmount = new map<String, decimal>();
        set<String> set_childAcctIds = new set<String>();
        list<String> list_sql = new list<String>();
        //get all children account ids for current parent
        ClsAPLForecastUtil.getChildrenAccts(parentId, territoryCode, set_childAcctIds, false);
        // get account billing query
        list_sql.add(' SUM(Bill_Amount_current_prior__c) amount, Part__c PartId, Customer__c AcctId ');
        list_sql.add(' BBB_Year_Bill_Book_Cust_PN__c ');
        list_sql.add(' Where Customer__r.APL_AM_forecast_Plan_Account__c = ' 
                    + (parentId == ClsAPLForecastUtil.OTHERACCTID ? ' null ' : '\'' +  parentId + '\' ') 
                    + ' And Customer__r.SALES_TERRITORY_CDE__c = \'' + territoryCode + '\' '
                    + (cbcCode == ClsAPLForecastUtil.CBCOTHER ? 
                        ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\'', '') 
                        : ' And Part__r.Product_Hierarchy__c =\'' + gplId + '\' ')
                    + ' And Bill_Amount_current_prior__c != null And Bill_Amount_current_prior__c != 0  '
                    + ' And BU_Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' And Customer__r.STATDESC__c = \'Active\' '
                    + ' group by Part__c, Customer__c ');
        //get reference data by part ==> map_acctId_map_partId_billingAmount
        system.debug('getGPLPercentForSave query :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String partId = (String) (cbcCode == ClsAPLForecastUtil.CBCOTHER ? ClsAPLForecastUtil.OTHERPARTID : result.get('PartId'));
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
        ClsAPLForecastUtil.calcPercentage(map_acctId_gplPercent, gplTotalAmount, true);
        //calc avg percent
        ClsAPLForecastUtil.calcPercentage(map_acctId_avgPercent, 0, true);
        //build other parts percent
        if(cbcCode == ClsAPLForecastUtil.CBCOTHER && !map_partId_map_acctId_partPercent.containsKey(ClsAPLForecastUtil.OTHERPARTID)) {
            map_partId_map_acctId_partPercent.put(ClsAPLForecastUtil.OTHERPARTID, new map<String, decimal>());
            map_partId_totalAmount.put(ClsAPLForecastUtil.OTHERPARTID, 0);
        }
        
        //build part percent for all children account
        for(String partId : map_partId_map_acctId_partPercent.keySet()) {
            for(String acctId : set_childAcctIds) {
                if(!map_partId_map_acctId_partPercent.get(partId).containsKey(acctId)) {
                    map_partId_map_acctId_partPercent.get(partId).put(acctId, 0);
                }
            }
            //Calc part percent
            ClsAPLForecastUtil.calcPercentage(map_partId_map_acctId_partPercent.get(partId), map_partId_totalAmount.get(partId), true);
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
                                        map<String, set<String>> map_year_quartersFuture, 
                                        map<String, map<String, APL_Sales_Forecast__c>> map_acctId_map_dateKey_fc) {
        
        list<String> list_sql = new list<String>();

        list_sql.add(' Id, Customer__c, GPL__c, Fiscal_Quarter__c, Fiscal_Year__c, Forecast__c, RSM_Forecast__c, Type__c ');     
        list_sql.add(' APL_Sales_Forecast__c ');                               
        list_sql.add(' Where Customer__r.APL_AM_forecast_Plan_Account__c = ' 
                   + (parentId == ClsAPLForecastUtil.OTHERACCTID ? ' null ' : '\'' +  parentId + '\' ') 
                   + ' And Customer__r.SALES_TERRITORY_CDE__c = \'' + territoryCode + '\' '
                   + ' And Type__c = \'GPL\' '
                   + ' And Customer__r.STATDESC__c = \'Active\' '
                   + ClsAPLForecastUtil.getMonthFilter(map_year_quartersFuture)
                   + ' And GPL__c =\'' + gplId + '\'');      
                                            
        for(APL_Sales_Forecast__c fc : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
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
    public static void getExistingPartFC(String acctId, String gplId, String territoryCode, String cbc2Code,
                                        map<String, set<String>> map_year_quartersFuture, 
                                        map<String, map<String, map<String, APL_Sales_Forecast__c>>> map_partId_map_acctId_map_dateKey_fc) {
        
        list<String> list_sql = new list<String>();

        list_sql.add(' Id, Customer__c, Part__c, Fiscal_Quarter__c, Fiscal_Year__c, Forecast__c, RSM_Forecast__c, Type__c ');     
        list_sql.add(' APL_Sales_Forecast__c ');                               
            list_sql.add(' Where Customer__r.APL_AM_forecast_Plan_Account__c = ' 
                   + (acctId == ClsAPLForecastUtil.OTHERACCTID ? ' null ' : '\'' +  acctId + '\' ') 
                   + ' And Customer__r.SALES_TERRITORY_CDE__c = \'' + territoryCode + '\' '
                   + ' And Customer__r.STATDESC__c = \'Active\' '
                   + ClsAPLForecastUtil.getMonthFilter(map_year_quartersFuture)
                   + ' And Type__c = \'' + (cbc2Code == ClsAPLForecastUtil.CBCOTHER ? ClsAPLForecastUtil.OTHERFCTYPE
                                            : ClsAPLForecastUtil.PARTFCTYPE) + '\' ' 
                   + (cbc2Code == ClsAPLForecastUtil.CBCOTHER ? '' 
                        : '  And  Part__r.Product_Hierarchy__c =\'' + gplId + '\''));      
        system.debug('getExistingPartFC :: ' + ClsAPLForecastUtil.getQueryString(list_sql));                                    
        for(APL_Sales_Forecast__c fc : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String dateKey = fc.Fiscal_Year__c + '_' + fc.Fiscal_Quarter__c;
            String partId = (fc.Type__c == ClsAPLForecastUtil.OTHERFCTYPE ? ClsAPLForecastUtil.OTHERFCTYPE : fc.Part__c);
            if(!map_partId_map_acctId_map_dateKey_fc.containsKey(partId)) {
                map_partId_map_acctId_map_dateKey_fc.put(partId, new map<String, map<String, APL_Sales_Forecast__c>>());
            }
            if(!map_partId_map_acctId_map_dateKey_fc.get(partId).containsKey(fc.Customer__c)) {
                map_partId_map_acctId_map_dateKey_fc.get(partId).put(fc.Customer__c, new map<String, APL_Sales_Forecast__c>());
            }
            system.debug('map_partId_map_acctId_map_dateKey_fc :: ' + map_partId_map_acctId_map_dateKey_fc);
            system.debug('partId :: ' + partId);
            system.debug('dateKey :: ' + dateKey);
            system.debug('fc.Customer__c :: ' + fc.Customer__c);
            if(!map_partId_map_acctId_map_dateKey_fc.get(partId).get(fc.Customer__c).containsKey(dateKey)) {
                map_partId_map_acctId_map_dateKey_fc.get(partId).get(fc.Customer__c).put(dateKey, fc);
            }
        }
    }
    
    /**
    * This method is used to save GAM GPL forecast
    * 
    *
    @author Yuda Zheng
    @created 2014-06-12
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *@param     GAMGPLFCInfo GAM GPL forecast information
    *
    @changelog
    * 2014-06-12 Yuda Zheng <yuda.zheng@itbconsult.com>
    * - Created
    */
    public static void saveGAMPartFC(list<ClsAPLEntityTypes.RSMPartFCInfo> list_partFCs, 
                                      map<String, map<String, map<String, APL_Sales_Forecast__c>>> map_partId_map_acctId_map_dateKey_fc,
                                      String gplId,  String fcType,
                                      map<String, map<String, decimal>> map_partId_map_acctId_percent,
                                      map<String, decimal> map_acctId_avgPercent,
                                      list<APL_Sales_Forecast__c> list_acctFC2Insert,
                                      list<APL_Sales_Forecast__c> list_acctFC2Update,
                                      list<APL_Sales_Forecast__c> list_acctFC2Delete) {
        map<String, map<String, APL_Sales_Forecast__c>> map_acctId_map_dateKey_fc = new map<String, map<String, APL_Sales_Forecast__c>>();
        map<String, decimal> map_acctId_billingPercent = new map<String, decimal>();
        
        for(ClsAPLEntityTypes.RSMPartFCInfo partFC : list_partFCs) {
            map_acctId_map_dateKey_fc = map_partId_map_acctId_map_dateKey_fc.get((fcType == ClsAPLForecastUtil.OTHERFCTYPE ? ClsAPLForecastUtil.OTHERFCTYPE : partFC.partId));
            if(map_partId_map_acctId_percent.containsKey(partFC.partId)) {
                map_acctId_billingPercent = map_partId_map_acctId_percent.get(partFC.partId);
            }
            
            if(map_acctId_billingPercent == null || map_acctId_billingPercent.isEmpty()) {
                map_acctId_billingPercent = map_acctId_avgPercent;
            }
            system.debug('map_acctId_billingPercent :: ' + map_acctId_billingPercent);
            //create or update account forecast records
            system.debug('partFC.gplId :: ' + partFC.gplId);
            ClsAPLForecastUtil.generateFC(map_acctId_billingPercent, partFC.map_dateKey_fc, map_acctId_map_dateKey_fc, 
                        fcType, partFC.gplId, partFC.partId, 'USD', false, false, true, list_acctFC2Insert, list_acctFC2Update, list_acctFC2Delete);
        }
    }
    
    /**
    * This method is used to create a new interface instance
    *
    @author Bin Yuan
    @created 2014-06-02
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-02 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static list<ClsAPLEntityTypes.AcctColumns> getRSMTotalReferRow() {
        list<ClsAPLEntityTypes.AcctColumns> list_t = new list<ClsAPLEntityTypes.AcctColumns> {
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_total_billing, 'totalBilling', 'feve', '', false),
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_total_booking, 'totalBooking', ' ', '', false),
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_total_backlog, 'totalBacklog', 'feve', '', false)
        };
        return list_t;
    }
    
    /**
    * This method is used to create a new interface instance
    *
    @author Bin Yuan
    @created 2014-06-02
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-02 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void saveOverRallFC(ClsAPLEntityTypes.RSMAMOverRallInfo overRallInfo) {
        list<String> list_sql = new list<String>();
        map<String, APL_RSM_Overall_Forecast__c> map_dateKey_overRallFC = new map<String, APL_RSM_Overall_Forecast__c>();
        list<APL_RSM_Overall_Forecast__c> list_overRallFC2Update = new list<APL_RSM_Overall_Forecast__c>();
        list<APL_RSM_Overall_Forecast__c> list_overRallFC2Insert = new list<APL_RSM_Overall_Forecast__c>();
        String aplRSMId = '';
        //added by nelson zheng 2015-9-16 begin
        String displayName = '',manualInput='';
        
        if(overRallInfo.displayName.indexOf(';') > 0){
            String[] tmp = overRallInfo.displayName.split(';');
            displayName = tmp[0];
            manualInput = tmp[1];
        }else{
            displayName = overRallInfo.displayName;
        }
        //added by nelson zheng 2015-9-16 end
        
        list_sql.add(' Id ');
        list_sql.add(' APL_RSM__c ');
        list_sql.add(' Where Manager__c = \'' + overRallInfo.managerId + '\' '
                   + ' And Display_Name__c = \'' + displayName + '\'');//added by nelson zheng 2015-9-16 change overRallInfo.displayName to displayName
        
        for(APL_RSM__c rsm : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            aplRSMId = rsm.Id;
        }
        system.debug('aplRSMId :: ' + aplRSMId);
        if(aplRSMId == '') {
            return;
        }
        list_sql.clear();
        list_sql.add(' Id, RSM_Overall_Forecast__c, Fiscal_Year__c, Fiscal_Quarter__c ');
        list_sql.add(' APL_RSM_Overall_Forecast__c ');
        
        list_sql.add(' WHERE APL_RSM__r.Manager__c = \'' + overRallInfo.managerId + '\' '
                    + ' And APL_RSM__r.Display_Name__c = \'' + displayName + '\' '
                    + ClsAPLForecastUtil.getMonthFilter(overRallInfo.map_year_quartersFuture) );
                    
        for(APL_RSM_Overall_Forecast__c overRallFC : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String year = overRallFC.Fiscal_Year__c,
                   quarter = overRallFC.Fiscal_Quarter__c,
                   dateKey = year + '_' + quarter;
            map_dateKey_overRallFC.put(dateKey, overRallFC);
        }
        
        for(String year : overRallInfo.map_year_quartersFuture.keySet()) {
            for(String quarter : overRallInfo.map_year_quartersFuture.get(year)) {
                String dateKey = year + '_' + quarter;
                
                if(!map_dateKey_overRallFC.containsKey(dateKey)) {
                    APL_RSM_Overall_Forecast__c overRallFC = new APL_RSM_Overall_Forecast__c();
                    overRallFC.CurrencyIsoCode = 'USD';
                    overRallFC.APL_RSM__c = aplRSMId;
                    overRallFC.Fiscal_year__c = year;
                    overRallFC.Fiscal_quarter__c = quarter;
                    overRallFC.RSM_Overall_Forecast__c = overRallInfo.map_dateKey_fc.get(dateKey);
                    overRallFC.Relay_RSM_Overall_Forecast__c = overRallFC.RSM_Overall_Forecast__c;
                    list_overRallFC2Insert.add(overRallFC);
                    system.debug('overRallFC :: ' + overRallFC);
                }
                else {
                    APL_RSM_Overall_Forecast__c overRallFC = map_dateKey_overRallFC.get(dateKey);
                    overRallFC.RSM_Overall_Forecast__c = overRallInfo.map_dateKey_fc.get(dateKey);
                    overRallFC.Relay_RSM_Overall_Forecast__c = overRallFC.RSM_Overall_Forecast__c;
                    list_overRallFC2Update.add(overRallFC);
                }
            }
        }
        
        if(!list_overRallFC2Insert.isEmpty()) {
            system.debug('list_overRallFC2Insert :: ' + list_overRallFC2Insert);
            insert list_overRallFC2Insert;
        }
        if(!list_overRallFC2Update.isEmpty()) {
            system.debug('list_overRallFC2Insert :: ' + list_overRallFC2Update);
            update list_overRallFC2Update;
        }
        
        if(manualInput != ''){
            APL_RSM__c aplRSM = new APL_RSM__c();
            aplRSM.Id = aplRSMId;
            if(manualInput == 'false'){
                aplRSM.Manual_Enter_Forecast__c = false;
            }else{
                aplRSM.Manual_Enter_Forecast__c = true;
            }
            
            update aplRSM;
        }
    }
    
    public static void unfreezeAM(ClsAPLEntityTypes.RSMTerritoryFCInfo rsmTerritory) {
        list<String> list_sql = new list<String>();
        list<APL_Forecast_Management__c> list_aplFCManagment = new list<APL_Forecast_Management__c>();
        list_sql.add(' Id, RSM_Freeze__c, AM_Freeze__c ');
        list_sql.add(' APL_Forecast_Management__c ');
        // Change start by Mrunal for case 901020
        //list_sql.add('  Where RSM__r.Manager__c = \'' + rsmTerritory.managerId + '\' And  A6_Code__c = \'' + rsmTerritory.territoryCode + '\' and RecordTypeId != null ');
        list_sql.add(' Where A6_Code__c = \'' + rsmTerritory.territoryCode + '\' and RecordTypeId != null ');
        // Change end by Mrunal for case 901020
        for(APL_Forecast_Management__c afm : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            system.debug('>>>>>##@@'+afm);
            afm.RSM_Freeze__c = true;
            afm.AM_Freeze__c = false;
            list_aplFCManagment.add(afm);
        }
        if(!list_aplFCManagment.isEmpty()) {
            update list_aplFCManagment;
        }
    }
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>InnerClass*/
    ///*<<<InnerClass*/
    //********************************* -=END inner classes=- *************************************
}