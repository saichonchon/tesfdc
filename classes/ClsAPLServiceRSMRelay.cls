public without sharing class ClsAPLServiceRSMRelay extends ClsAPLInterface.AAPLCtrlService {
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    public static final String RELAYFCTYPE = 'Relay';  
    public static final String ACCTFCTYPE = 'Account';
    public static final String OTHER = system.Label.APL_Other_Accounts;    
    
    public static final map<String, set<String>> map_RELAY_CBCFIELD_CBCDESC = new map<String, set<String>> {
        'CBC2__c' => new set<String> {'30005', '13213'},
        //change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
        'CBC3__c' => new set<String> {'41553'}
    };
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
    public ClsAPLEntityTypes.RSMAcctInfo getAcctInfo(ClsAPLEntityTypes.PageConfig pageConf) {
        
        ClsAPLEntityTypes.RSMAcctInfo rsmInfo = new ClsAPLEntityTypes.RSMAcctInfo();
        return new ClsAPLEntityTypes.RSMAcctInfo();
    }
    
    
    
    /**
        * Method to set account forecast view column.
        *
        @author Bin Yuan
        @created 2014-05-30
        @version 1.0
        @since 29.0 (Force.com ApiVersion)
        *
        *
        @changelog
        * 2014-05-30 Bin Yuan <bin.yuan@itbconsult.com>
        * - Created
        */  
        
        public override void setAcctRow(list<ClsAPLEntityTypes.AcctColumns> list_acctColumns){
            
            list<ClsAPLEntityTypes.AcctColumns> list_t = new list<ClsAPLEntityTypes.AcctColumns> {
                new ClsAPLEntityTypes.AcctColumns(system.label.APL_current_sales_forecast, 'currentFC', '', '', false),
                new ClsAPLEntityTypes.AcctColumns(system.label.APL_previous_sales_forecast, 'previousFC', 'feve ', '', false),
                new ClsAPLEntityTypes.AcctColumns(system.label.APL_AM_Sales_Forecast, 'amFC', '', '', false),
                new ClsAPLEntityTypes.AcctColumns(system.label.APL_pos_forecast, 'posFC', 'feve', 'nhide', true),
                new ClsAPLEntityTypes.AcctColumns(system.label.APL_cma_forecast, 'cmaFC', '', 'nhide', true),
                new ClsAPLEntityTypes.AcctColumns(system.label.APL_total_relay_billing, 'totalBilling', 'feve', '', false),
                new ClsAPLEntityTypes.AcctColumns(system.label.APL_total_relay_booking, 'totalBooking', ' ', '', false),
                new ClsAPLEntityTypes.AcctColumns(system.label.APL_total_relay_backlog, 'totalBacklog', 'feve', '', false),
                new ClsAPLEntityTypes.AcctColumns(system.label.APL_total_sa, 'totalSA', '', 'nhide', false),
                new ClsAPLEntityTypes.AcctColumns(system.label.APL_2m_fc_accuracy, 'fc2MAccuracy', 'feve', 'nhide', false),
                new ClsAPLEntityTypes.AcctColumns(system.label.APL_3m_fc_accuracy, 'fc3MAccuracy', '', 'nhide', false),
                new ClsAPLEntityTypes.AcctColumns(system.label.APL_6m_fc_accuracy, 'fc6MAccuracy', 'feve', 'nhide', false)
            };
            
            list_acctColumns.addAll(list_t);
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
        system.debug('pageConf.set_rsmRelayDisplayNames ::: '+pageConf.set_rsmRelayDisplayNames);
        list<String> list_relaySQL = new list<String>();
        list<String> list_rsmRelayDisplayNames = new list<String>();
        list_rsmRelayDisplayNames.addAll(pageConf.set_rsmRelayDisplayNames);
        //list<ClsAPLEntityTypes.TotalFCViewFields> list_totalOverallFC = new list<ClsAPLEntityTypes.TotalFCViewFields>();
        set<String> set_territoryCodes = new set<String>();
        if(pageConf.set_rsmRelayTerritoryCodes.isEmpty()) {
            return ;
        }
        set_territoryCodes.addAll(pageConf.set_rsmRelayTerritoryCodes);
 
        list_relaySQL.add(' Fiscal_Year__c year, sum(RSM_Forecast__c) fc, Fiscal_Quarter__c quarter ');
        list_relaySQL.add(' APL_Sales_Forecast__c ');
        list_relaySQL.add(' WHERE Customer__r.Relay_Specialist_Territory_Code__c IN : set_territoryCodes '
                     + ' And Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' '
                     + ' And Customer__r.STATDESC__c = \'Active\' '
                     //+ ClsAPLForecastUtil.getRelayPartQuery()
                     + ClsAPLForecastUtil.getMonthFilter(pageConf.map_year_quartersFuture)
                     + ' Group by Fiscal_Year__c, Fiscal_Quarter__c ');                  
                           
        ClsAPLEntityTypes.TotalFCViewFields showTotal = new ClsAPLEntityTypes.TotalFCViewFields(' trt_0 trt_trt col ');
        showTotal.fieldName= system.label.APL_Show_Total;
        /*
        ClsAPLEntityTypes.TotalFCViewFields fcTotal = new ClsAPLEntityTypes.TotalFCViewFields(' trt_0 dn fctotal ');
        fcTotal.fieldName= system.label.APL_Total_Forecast;
        ClsAPLEntityTypes.TotalFCViewFields tcFC = new ClsAPLEntityTypes.TotalFCViewFields(' trt_0 dn tcfctotal ');
        tcFC.fieldName = system.label.APL_TC_Products;
        tcFC.list_referenceRows.addAll(getRSMTotalReferRow());   
        */
        ClsAPLEntityTypes.TotalFCViewFields relayFC = new ClsAPLEntityTypes.TotalFCViewFields(' trt_0 dn relayfctotal ');
        relayFC.fieldName = system.label.APL_Relay_Products;
        relayFC.list_referenceRows.addAll(getRSMTotalReferRow());
        
        ClsAPLEntityTypes.TotalFCViewFields overallRelayFC = new ClsAPLEntityTypes.TotalFCViewFields(' trt_0 dn overrulerelayfctotalall ');
        overallRelayFC.fieldName = system.label.APL_Total_Overrule_Relay_Products;
        
        system.debug('79 :::: '+list_rsmRelayDisplayNames);
        //get relay forecast
        system.debug('!@#list_relaySQL: '+list_relaySQL);
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
            }
        }
        relayFC.currentFC = Json.serialize(relayFC.map_currentFC);
        list_totalFC.add(showTotal);
        list_totalFC.add(relayFC);
        list_totalFC.add(overallRelayFC);
        for(String  name : list_rsmRelayDisplayNames) {
            ClsAPLEntityTypes.TotalFCViewFields overruleRelayFC = new ClsAPLEntityTypes.TotalFCViewFields(' trt_0 dn overrulerelayfctotal ');
            overruleRelayFC.fieldName = name;
            overruleRelayFC.disName = name;
            if(name != null && name != ''){
                overruleRelayFC.name = name.replaceAll(' ','');
            }
            //list_totalOverallFC.add(overruleRelayFC);
            list_totalFC.add(overruleRelayFC);
        }  
        /*
        if(list_totalOverallFC.size() > 0 ) {
            list_totalFC.add(overallRelayFC);
            for(ClsAPLEntityTypes.TotalFCViewFields overruleRelayFC : list_totalOverallFC) {
                list_totalFC.add(overruleRelayFC);
            }
        }
        */
        system.debug('list_totalFC::: '+list_totalFC);
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
    public static ClsAPLEntityTypes.AcctFCResults getRSMRelayOverRallFC(ClsAPLEntityTypes.RSMRelayOverRallInfo rsmOverRall) {
        system.debug('rsmOverRall::: '+rsmOverRall);
        ClsAPLEntityTypes.AcctFCResults overRallResult = new ClsAPLEntityTypes.AcctFCResults();
        
        map<String, map<String, decimal>> map_name_map_dateKey_fc = new map<String, map<String, decimal>>();        
        map<String, ClsAPLEntityTypes.OverRallFCObj> map_disName_overRallFC = new map<String, ClsAPLEntityTypes.OverRallFCObj>();
        list<String> list_sql = new list<String>();

        set<String> set_displayNames = new set<String>();
        set<String> set_rsmIds = new set<String>();
        list<String> list_displayNames = new list<String>(rsmOverRall.set_displayNames);
        set_displayNames.addAll(rsmOverRall.set_displayNames);
        set_rsmIds.addAll(rsmOverRall.set_rsmIds);
        //list_sql.add(' sum(Relay_RSM_Overall_Forecast__c) fc, Fiscal_Year__c year, Fiscal_Quarter__c quarter, APL_RSM__r.APL_RSM__r.Display_Name__c disName ');
        list_sql.add(' sum(Relay_RSM_Overall_Forecast__c) fc, Fiscal_Year__c year, Fiscal_Quarter__c quarter, APL_RSM__r.Display_Name__c disName ');
        
        list_sql.add(' APL_RSM_Overall_Forecast__c ');
        
        list_sql.add(' WHERE APL_RSM__r.Display_Name__c IN : set_displayNames '   
                    + ' And Relay_RSM_Overall_Forecast__c > 0 '
                    + ' And APL_RSM__c IN : set_rsmIds '
                    //+ ' And APL_RSM__r.Type__c != \'AM\' '
                    + ClsAPLForecastUtil.getMonthFilter(rsmOverRall.map_year_quartersFuture) 
                    + ' Group by Fiscal_Year__c, Fiscal_Quarter__c, APL_RSM__r.Display_Name__c ');
        system.debug('getRSMAMOverRallFC :: ' + ClsAPLForecastUtil.getQueryString(list_sql));

        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String year = (String) result.get('year'),
                   quarter = (String) result.get('quarter'),
                   dateKey = year + '_' + quarter,
                   name = (String) result.get('disName');
                   
            if(!map_disName_overRallFC.containsKey(name)) {
                ClsAPLEntityTypes.OverRallFCObj overRallFC = new ClsAPLEntityTypes.OverRallFCObj();
                overRallFC.disName = name;
                if(name != null && name != '') {
                    overRallFC.name = name.replaceAll(' ','');
                }
                overRallFC.fieldName = system.label.APL_Overrule_Relay_Products;
                overRallFC.clsName = ' trt_0 dn overrulerelayfctotal ';
                map_disName_overRallFC.put(name, overRallFC);
            }
            ClsAPLEntityTypes.OverRallFCObj overRallFCObj = map_disName_overRallFC.get(name);
            overRallFCObj = overRallFCObj.assignFCValues(overRallFCObj, result, dateKey);
        }
        for(String name : list_displayNames) {
            for(String year : rsmOverRall.map_year_quartersFuture.keySet()) {
                for(String quarter : rsmOverRall.map_year_quartersFuture.get(year)) {   
                                       
                    String dateKey = (year + '_' + quarter);
                    AggregateResult result;
                    
                    if(!map_disName_overRallFC.containsKey(name)) {
                        ClsAPLEntityTypes.OverRallFCObj overRallFC = new ClsAPLEntityTypes.OverRallFCObj();
                        overRallFC.disName = name;
                        if(name != null && name != ''){
                            overRallFC.name = name.replaceAll(' ','');
                        }
                        overRallFC.fieldName = system.label.APL_Overrule_Relay_Products;
                        overRallFC.clsName = ' trt_0 dn overrulerelayfctotal ';
                        map_disName_overRallFC.put(name, overRallFC);
                    }
                    
                    ClsAPLEntityTypes.OverRallFCObj overRallFCObj;
                    if(map_disName_overRallFC.containskey(name)) {
                        overRallFCObj = map_disName_overRallFC.get(name);
                    }
                    overRallFCObj = overRallFCObj.assignFCValues(overRallFCObj, result, dateKey);
                    
                }
            }
        }
        //overRallResult.json_result = Json.serialize(overRallFC);  
        overRallResult.json_result = Json.serialize(map_disName_overRallFC.values());
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
    public static ClsAPLEntityTypes.AcctFCResults getRSMTotalRefData(ClsAPLEntityTypes.RSMRelayTotalFCInfo rsmTotal) {
        system.debug('rsmTotal:::: '+rsmTotal);
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
            getTotalHistoryRefData(rsmTotal.set_terrtoryCodes, startDate, endDate, 
                                    rsmTotal.list_dateKey, fcViewObj);
            getTotalHisBacklogRefData(rsmTotal.set_terrtoryCodes, startDate, endDate,
                                    map_fiscalMonth, rsmTotal.list_dateKey, fcViewObj);
        }
        else if(date_currentDate < date_startDate) {
            getTotalFutureRefData(rsmTotal.set_terrtoryCodes, startDate, endDate,
                                map_fiscalMonth, rsmTotal.list_dateKey, fcViewObj);
        }
        else {
            String currentEndDate =  ClsAPLForecastUtil.getEndDate(rsmTotal.currentYear + '_' + rsmTotal.currentMonth);
            map<String, set<Integer>> map_history = new map<String, set<Integer>>();
            map<String, set<Integer>> map_future = new map<String, set<Integer>>();
            ClsAPLForecastUtil.getDividedFiscalMap(date_currentDate, rsmTotal.list_dateKey, map_history, map_future);
            
            getTotalHistoryRefData(rsmTotal.set_terrtoryCodes, startDate, currentEndDate, 
                                    rsmTotal.list_dateKey, fcViewObj);
            if(!map_history.isEmpty()) {
                getTotalHisBacklogRefData(rsmTotal.set_terrtoryCodes, startDate, currentEndDate,
                                        map_history, rsmTotal.list_dateKey, fcViewObj);
            }
            if(!map_future.isEmpty()) {
                getTotalCurrentRefData(rsmTotal.set_terrtoryCodes, rsmTotal.currentYear, Integer.valueOf(rsmTotal.currentMonth),
                                        fcViewObj);
                getTotalFutureRefData(rsmTotal.set_terrtoryCodes, currentEndDate, endDate,
                                        map_future, rsmTotal.list_dateKey, fcViewObj);
            }                       
        }
        
        fcViewObj.cls = String.join(rsmTotal.list_dateKey, ',');
        result.json_result = Json.serialize(fcViewObj);     
        system.debug('result.json_result:::'+result.json_result);               
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
    public static void getTotalHistoryRefData(set<String> set_territoryCodes, 
                                            String startDate, String endDate,
                                            list<String> list_dateKey,
                                            ClsAPLEntityTypes.AcctFCValueObj fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setRSMAccountIds(false, set_territoryCodes, set_acctIds);
                                                
        list<String> list_sql = new list<String>();
        map<String, map<String, ClsAPLEntityTypes.CBCFCValueObj>> map_cbc2Name_map_dateKey_result = new map<String, map<String, ClsAPLEntityTypes.CBCFCValueObj>>();
        set<String> set_tempTerritorys = new set<String>();
        set_tempTerritorys.addAll(set_territoryCodes);
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking, Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds '
                    + ClsAPLForecastUtil.getRelayPartQuery() 
                    + ' And Fiscal_Date__c >= ' + startDate
                    + ' And Fiscal_Date__c < ' + endDate
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
                    
                    //update by nelson zheng 2015-10-21 for case 00900375
                    //+ ' And Profit_Center__c = \'RPA\'  '
                     //+ ' And (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  '
                    + ' And Profit_Center__c = \'APL\'  '
                    
                    + ' Group by Fiscal_Date__c ' );
                     system.debug('------------ClsAPLServiceRSMRelay.cls (21 matches) 1-------------------');
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
    public static void getTotalHisBacklogRefData(set<String> set_territoryCodes, 
                                            String startDate, String endDate,
                                            map<String, set<Integer>> map_fiscalMonth, list<String> list_dateKey,
                                            ClsAPLEntityTypes.AcctFCValueObj fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setRSMAccountIds(false, set_territoryCodes, set_acctIds);

        list<String> list_sql = new list<String>();
        set<String> set_tempTerritorys = new set<String>();
        set_tempTerritorys.addAll(set_territoryCodes);
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds '
                    + ClsAPLForecastUtil.getRelayPartQuery()  
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_fiscalMonth)
                    + ' And Backlog_Amount_USD__c != 0 '
                    
                    //update by nelson zheng 2015-10-21 for case 00900375
                    //+ ' And Profit_Center__c = \'RPA\'  '
                    //+ ' And (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  '
                    + ' And Profit_Center__c = \'APL\'  '
                    + ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
                    system.debug('------------ClsAPLServiceRSMRelay.cls (21 matches) 2-------------------');
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
    public static void getTotalCurrentRefData(set<String> set_territoryCodes, 
                                            String year, Integer month,
                                            ClsAPLEntityTypes.AcctFCValueObj fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setRSMAccountIds(false, set_territoryCodes, set_acctIds);

        list<String> list_sql = new list<String>();
        set<String> set_tempTerritorys = new set<String>();
        set_tempTerritorys.addAll(set_territoryCodes);
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds '
                    + ClsAPLForecastUtil.getRelayPartQuery()  
                    + ' And Fiscal_Year__c = \'' + year +'\''
                    + ' And Fiscal_Month__c = ' + month +
                    
                    //update by nelson zheng 2015-10-21 for case 00900375
                    //+ ' And Profit_Center__c = \'RPA\'  '
                    //+ ' And (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  '
                    + ' And Profit_Center__c = \'APL\'  '
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0 ) ' );
          system.debug('------------ClsAPLServiceRSMRelay.cls (21 matches) 3-------------------');
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
    public static void getTotalFutureRefData(set<String> set_territoryCodes, 
                                            String startDate, String endDate,
                                            map<String, set<Integer>> map_fiscalMonth, list<String> list_dateKey,
                                            ClsAPLEntityTypes.AcctFCValueObj fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setRSMAccountIds(false, set_territoryCodes, set_acctIds);

        list<String> list_sql = new list<String>();
        set<String> set_tempTerritorys = new set<String>();
        set_tempTerritorys.addAll(set_territoryCodes);
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds '
                    + ClsAPLForecastUtil.getRelayPartQuery()  
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_fiscalMonth)
                    + ' And Backlog_Amount_USD__c != 0 '
                    
                    //update by nelson zheng 2015-10-21 for case 00900375
                    //+ ' And Profit_Center__c = \'RPA\'  '
                    //+ ' And (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  '
                    + ' And Profit_Center__c = \'APL\'  '
                    + ' Group by Customer_Request_Date_Fiscal_Date__c' );
                    system.debug('------------ClsAPLServiceRSMRelay.cls (21 matches) 4-------------------');
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
    public static ClsAPLEntityTypes.AcctFCResults getRSMTerritoryFC(ClsAPLEntityTypes.RSMRelayTerritoryFCInfo rsmTerritory) {
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
        list_sql.add(' WHERE Customer__r.Relay_Specialist_Territory_Code__c = \'' + rsmTerritory.territoryCode + '\' '
                    + ' And Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' '
                    + APL_ClsUtils.getRelayCBC2CodeQuery()
                    //+ ClsAPLForecastUtil.getRelayPartQuery()
                    + ' And Customer__r.STATDESC__c = \'Active\' '
                    + ClsAPLForecastUtil.getMonthFilter(rsmTerritory.map_year_quartersFuture) 
                    + ' Group by Fiscal_Year__c, Fiscal_Quarter__c ');
        system.debug('getRSMAcctFC :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        for(AggregateResult result : Database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String year = (String) result.get('year'),
                   quarter = (String) result.get('quarter'), 
                   dateKey = (year + '_' + quarter);
            
            ClsAPLForecastUtil.setResultMap(result, tempAcctId, dateKey, map_acctId_map_dateKey_result);
        }
        
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
    public static ClsAPLEntityTypes.AcctFCResults getRSMTerritoryRefData(ClsAPLEntityTypes.RSMRelayTerritoryFCInfo rsmTerritory) {
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
		ClsAPLForecastUtil.setRSMAccountIds(false, new set<String>{territoryCode}, set_acctIds);
                                                
        list<String> list_sql = new list<String>();
        map<String, map<String, ClsAPLEntityTypes.CBCFCValueObj>> map_cbc2Name_map_dateKey_result = new map<String, map<String, ClsAPLEntityTypes.CBCFCValueObj>>();
        
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking, Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds '
                    + ClsAPLForecastUtil.getRelayPartQuery()  
                    + ' And Fiscal_Date__c >= ' + startDate
                    + ' And Fiscal_Date__c < ' + endDate
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
                    
                    //update by nelson zheng 2015-10-21 for case 00900375
                    //+ ' And Profit_Center__c = \'RPA\'  '
                    ///+ ' And (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  '
                    + ' And Profit_Center__c = \'APL\'  '
                    + ' Group by Fiscal_Date__c ' );
              system.debug('------------ClsAPLServiceRSMRelay.cls (21 matches) 5------------------');      
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
		ClsAPLForecastUtil.setRSMAccountIds(false, new set<String>{territoryCode}, set_acctIds);

        list<String> list_sql = new list<String>();
        
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds '
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_fiscalMonth)
                    + ClsAPLForecastUtil.getRelayPartQuery()  
                    + ' And Backlog_Amount_USD__c != 0 '
                    
                    //update by nelson zheng 2015-10-21 for case 00900375
                    //+ ' And Profit_Center__c = \'RPA\'  '
                    //+ ' And (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  '
                    + ' And Profit_Center__c = \'APL\'  '
                    + ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
          system.debug('------------ClsAPLServiceRSMRelay.cls (21 matches) 6------------------');  
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
		ClsAPLForecastUtil.setRSMAccountIds(false, new set<String>{territoryCode}, set_acctIds);

        list<String> list_sql = new list<String>();
        
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds '
                    + ' And Fiscal_Year__c = \'' + year +'\''
                    + ' And Fiscal_Month__c = ' + month +
                    + ClsAPLForecastUtil.getRelayPartQuery()  
                    
                    //update by nelson zheng 2015-10-21 for case 00900375
                    //+ ' And Profit_Center__c = \'RPA\'  '
                    //+ ' And (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  '
                    + ' And Profit_Center__c = \'APL\'  '
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0 ) ' );
        system.debug('------------ClsAPLServiceRSMRelay.cls (21 matches) 7------------------');             
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
		ClsAPLForecastUtil.setRSMAccountIds(false, new set<String>{territoryCode}, set_acctIds);

        list<String> list_sql = new list<String>();
        
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' WHERE Customer__c IN : set_acctIds '
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_fiscalMonth)
                    + ClsAPLForecastUtil.getRelayPartQuery()  
                    + ' And Backlog_Amount_USD__c != 0 '
                    //update by nelson zheng 2015-10-21 for case 00900375
                    //+ ' And Profit_Center__c = \'RPA\'  '
                    //+ ' And (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  '
                    + ' And Profit_Center__c = \'APL\'  '
                    
                    + ' Group by Customer_Request_Date_Fiscal_Date__c' );
        system.debug('------------ClsAPLServiceRSMRelay.cls (21 matches) 8------------------');             
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
    
    // add lili

    /**
    * This method is used to get relay account forecast.
    *
    @author Yuda Zheng
    @created 2014-06-16
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *@param FCInfo request - parentId is AccountId
    *
    @changelog
    * 2014-06-16 Yuda Zheng <yuda.zheng@itbconsult.com>
    * - Created
    */
    public static ClsAPLEntityTypes.AcctFCResults getRelayAcctFC(ClsAPLEntityTypes.RSMRelayAcctFCInfo relayAccFCInfo){
        ClsAPLEntityTypes.AcctFCResults acctFCResult = new ClsAPLEntityTypes.AcctFCResults();
        list<String> list_sql = new list<String>();
        map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result =
            new map<String, map<String, AggregateResult>>();
        //Get account grouping
        map<String, ClsAPLEntityTypes.AcctFCValueObj> map_groupId_acctFC = ClsAPLRSMForecastUtil.getRSMRelayAcctGroup(relayAccFCInfo);
        //get account forecast
        system.debug('map_groupId_acctFC:::: '+map_groupId_acctFC);
        String query = 'Select Customer__r.APL_Relay_forecast_Plan_Account__c parentId, Fiscal_Year__c year, Fiscal_Quarter__c quarter,'
                      + ' sum(Forecast__c) amFC, sum(RSM_Forecast__c) fc, sum(Current_month_1_forecast__c) prevFC ';
        query += ' From APL_Sales_Forecast__c Where Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' And Customer__r.Relay_Specialist_Territory_Code__c= \'' + relayAccFCInfo.territoryCode + '\'';
        query += ClsAPLForecastUtil.getMonthFilter(relayAccFCInfo.map_year_quartersFuture);
        query += ' And Customer__r.STATDESC__c = \'Active\' '; 
        query += ' Group by Customer__r.APL_Relay_forecast_Plan_Account__c, Fiscal_Year__c, Fiscal_Quarter__c ';
        system.debug('getuery :: ' + query);
        for(AggregateResult result : Database.query(query)) {
            String acctId = (String) (result.get('parentId') == null ? ClsAPLForecastUtil.OTHERACCTID : result.get('parentId')), 
                   year = (String) result.get('year'),
                   quarter = (String) result.get('quarter'), 
                   dateKey = (year + '_' + quarter);
            
            ClsAPLForecastUtil.setResultMap(result, acctId, dateKey, map_acctId_map_dateKey_result);
        }
        system.debug('map_acctId_map_dateKey_result::: '+map_acctId_map_dateKey_result);
        for(String acctId : map_groupId_acctFC.keySet()) {
            for(String year : relayAccFCInfo.map_year_quartersFuture.keySet()) {
                for(String quarter : relayAccFCInfo.map_year_quartersFuture.get(year)) {
                    // to do lili 
                    //decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, 'USD', map_acctId_currencyIso.get(parentId));
                    decimal currencyRate = 1;
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
        for(String acctId : map_groupId_acctFC.keySet()) {
            ClsAPLEntityTypes.AcctFCValueObj acctFCObj = map_groupId_acctFC.get(acctId);
            for(String dateKey : acctFCObj.currentFC.keySet()) { 
                acctFCObj.currentFC.put(dateKey, acctFCObj.currentFC.get(dateKey));
                acctFCObj.previousFC.put(dateKey, acctFCObj.previousFC.get(dateKey));
            }
        }
        //prepare result
        acctFCResult.json_result = Json.serialize(map_groupId_acctFC.values());
        system.debug('acctFCResult::: '+acctFCResult);
        return acctFCResult;
    }
    
    /**
    * This method is used to refresh the data of booking,billing,blocklog as the account.
    *
    @author Lili Zhao
    @created 2014-07-23
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *@param FCInfo request - parentId is AccountId
    *
    @changelog
    * 2014-07-23 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static ClsAPLEntityTypes.AcctFCResults getRSMRelayAcctRefData(ClsAPLEntityTypes.RSMRelayAcctFCInfo rsmAcct) {
        system.debug('rsmAcct::: ' + rsmAcct);
    
        ClsAPLEntityTypes.AcctFCValueObj fcViewObj = new ClsAPLEntityTypes.AcctFCValueObj();
        String startDate = ClsAPLForecastUtil.getStartDate(rsmAcct.list_dateKey[0]),
               endDate = ClsAPLForecastUtil.getEndDate(rsmAcct.list_dateKey[2]);
        system.debug('startDate::: '+startDate);     
        Integer startYear = Integer.valueOf(startDate.subStringBefore('-')), 
               startMonth = Integer.valueOf(startDate.subStringBetween('-', '-')), 
               endYear = Integer.valueOf(endDate.subStringBefore('-')), 
               endMonth = Integer.valueOf(endDate.subStringBetween('-', '-')), 
               currentYear = Integer.valueOf(rsmAcct.currentYear),
               currentMonth = Integer.valueOf(rsmAcct.currentMonth); 
        system.debug('startYear:::: '+startYear);     
        map<String, set<Integer>> map_fiscalMonth = ClsAPLForecastUtil.getFiscalMonthMap(rsmAcct.list_dateKey);
        ClsAPLEntityTypes.AcctFCResults result = new ClsAPLEntityTypes.AcctFCResults();
        Date date_endDate = Date.newInstance(endYear, endMonth, 1);
        Date date_currentDate = Date.newInstance(currentYear, currentMonth, 1);
        Date date_startDate = Date.newInstance(startYear, startMonth, 1);
        
        decimal currencyRate = 1;
        
        if(date_endDate < date_currentDate) {
            getAcctHistoryRefData(rsmAcct.acctId, rsmAcct.territoryCode, currencyRate, startDate, endDate, 
                                    rsmAcct.list_dateKey, fcViewObj);
            getAcctHisBacklogRefData(rsmAcct.acctId, rsmAcct.territoryCode, currencyRate, map_fiscalMonth, 
                                    rsmAcct.list_dateKey, fcViewObj);
        }
        else if(date_currentDate < date_startDate) {
            getAcctFutureRefData(rsmAcct.acctId, rsmAcct.territoryCode, currencyRate, map_fiscalMonth,
                                    rsmAcct.list_dateKey, fcViewObj);
        }
        else {
            map<String, set<Integer>> map_history = new map<String, set<Integer>>();
            map<String, set<Integer>> map_future = new map<String, set<Integer>>();
            ClsAPLForecastUtil.getDividedFiscalMap(date_currentDate, rsmAcct.list_dateKey, map_history, map_future);
            
            String currentEndDate =  ClsAPLForecastUtil.getEndDate(rsmAcct.currentYear + '_' + rsmAcct.currentMonth);
            getAcctHistoryRefData(rsmAcct.acctId, rsmAcct.territoryCode, currencyRate, startDate, currentEndDate, 
                                    rsmAcct.list_dateKey, fcViewObj);
            if(!map_history.isEmpty()) {
                getAcctHisBacklogRefData(rsmAcct.acctId, rsmAcct.territoryCode, currencyRate, map_history,
                                        rsmAcct.list_dateKey, fcViewObj);
            }
            if(!map_future.isEmpty()) {
                getAcctCurrentRefData(rsmAcct.acctId, rsmAcct.territoryCode, currencyRate, rsmAcct.currentYear, 
                                        rsmAcct.currentMonth, rsmAcct.list_dateKey, fcViewObj);
                getAcctFutureRefData(rsmAcct.acctId, rsmAcct.territoryCode, currencyRate, map_future,
                                        rsmAcct.list_dateKey, fcViewObj);
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
    public static void getAcctHistoryRefData(String parentId, String territoryCode, decimal currencyRate,
                                            String startDate, String endDate,
                                            list<String> list_dateKey,
                                            ClsAPLEntityTypes.AcctFCValueObj acctFCObj) {
                                                
        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(false, parentId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        map<String, map<String, ClsAPLEntityTypes.CBCFCValueObj>> map_cbc2Name_map_dateKey_result = new map<String, map<String, ClsAPLEntityTypes.CBCFCValueObj>>();
        
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking, Fiscal_Date__c fiscal_date '
                    //+ ' Part__r.Product_Hierarchy__r.CBC2__c cbc2, Part__r.Product_Hierarchy__r.CBC3__c cbc3 ');
                    );
        list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
        
        list_sql.add(' Where Customer__c IN : set_acctIds ' 
                    + ' And ( Bill_Amount_USD__c != 0 or Book_Amount_USD__c != 0 ) ' 
                    + ClsAPLForecastUtil.getRelayPartQuery()  
                    //+ getRelayPartSearchQueryFilter(cbcCode, true) 
                    + ' And Fiscal_Date__c >= ' + startDate
                    + ' And Fiscal_Date__c < ' + endDate
                    //update by nelson zheng 2015-10-21 for case 00900375
                    //+ ' And Profit_Center__c = \'RPA\'  '
                    //+ ' And (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  '
                    + ' And Profit_Center__c = \'APL\'  '
                    
                    + ' Group by Fiscal_Date__c '
                    );
        system.debug('------------ClsAPLServiceRSMRelay.cls (21 matches) 9------------------');             
        system.debug('getCBC2RefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;

            acctFCObj = (ClsAPLEntityTypes.AcctFCValueObj) acctFCObj.assignRefData(acctFCObj, result, dateKey, true);
        }
        //generate forecast view objects for each quarte
        for(String dateKey : list_dateKey) {
            AggregateResult result;                    
            acctFCObj = acctFCObj.assignRefData(acctFCObj, result, dateKey, true);                    
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
                                                    map<String, set<Integer>> map_fiscalMonth, 
                                                    list<String> list_dateKey, 
                                                    ClsAPLEntityTypes.AcctFCValueObj acctFCObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(false, parentId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        map<String, map<String, ClsAPLEntityTypes.CBCFCValueObj>> map_cbc2Name_map_dateKey_result = new map<String, map<String, ClsAPLEntityTypes.CBCFCValueObj>>();
        
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' Where Customer__c IN : set_acctIds ' 
                    + ClsAPLForecastUtil.getRelayPartQuery()  
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_fiscalMonth)
                    + ' And Backlog_Amount_USD__c != 0 '
                    //update by nelson zheng 2015-10-21 for case 00900375
                    //+ ' And Profit_Center__c = \'RPA\'  '
                    //+ ' And (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  '
                    + ' And Profit_Center__c = \'APL\'  '
                    + ' Group by Customer_Request_Date_Fiscal_Date__c '
                    );

        system.debug('------------ClsAPLServiceRSMRelay.cls (21 matches) 10------------------');             
        system.debug('getCBCHistoryRefBacklogData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;
            acctFCObj = (ClsAPLEntityTypes.AcctFCValueObj) acctFCObj.assignHisBacklogRefData(acctFCObj, result, dateKey);
        }

        //generate forecast view objects for each quarter
        for(String dateKey : list_dateKey) {
            AggregateResult result;
            acctFCObj = (ClsAPLEntityTypes.AcctFCValueObj) acctFCObj.assignHisBacklogRefData(acctFCObj, result, dateKey);                    
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
                                            list<String> list_dateKey, 
                                            ClsAPLEntityTypes.AcctFCValueObj acctFCObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(false, parentId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking '
                    );
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' Where Customer__c IN : set_acctIds ' 
                    + ClsAPLForecastUtil.getRelayPartQuery()  
                    + ' And Fiscal_Year__c = \'' + year +'\''
                    + ' And Fiscal_Month__c = ' + month +
                    //update by nelson zheng 2015-10-21 for case 00900375
                    //+ ' And Profit_Center__c = \'RPA\'  '
                    //+ ' And (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  '
                    + ' And Profit_Center__c = \'APL\'  '
                    + ' And (Bill_Amount_USD__c != 0 or Book_Amount_USD__c != 0 or Backlog_Amount_USD__c != 0 ) '
                    );

        system.debug('------------ClsAPLServiceRSMRelay.cls (21 matches) 11------------------');             
        system.debug('getCBC2RefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        
        String dateKey = year + '_' + month;
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            acctFCObj = (ClsAPLEntityTypes.AcctFCValueObj) acctFCObj.assignRefData(acctFCObj, result, dateKey, true);
        }
        
        //for(String dateKey : list_dateKey) {
        AggregateResult result;
        acctFCObj = (ClsAPLEntityTypes.AcctFCValueObj) acctFCObj.assignRefData(acctFCObj, result, dateKey, true);            
        //}
        
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
                                            map<String, set<Integer>> map_fiscalMonth, 
                                            list<String> list_dateKey, 
                                            ClsAPLEntityTypes.AcctFCValueObj acctFCObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(false, parentId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date '
                    );
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' Where Customer__c IN : set_acctIds ' 
                    + ClsAPLForecastUtil.getRelayPartQuery()  
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_fiscalMonth)
                    + ' And (Bill_Amount_USD__c != 0 or Book_Amount_USD__c != 0 or Backlog_Amount_USD__c != 0 ) '
                    //update by nelson zheng 2015-10-21 for case 00900375
                    //+ ' And Profit_Center__c = \'RPA\'  '
                    //+ ' And (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  '
                    + ' And Profit_Center__c = \'APL\'  '
                    + ' Group by Customer_Request_Date_Fiscal_Date__c '
                    );

        system.debug('------------ClsAPLServiceRSMRelay.cls (21 matches) 12------------------');             
        system.debug('getCBC2RefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;

            acctFCObj = (ClsAPLEntityTypes.AcctFCValueObj) acctFCObj.assignHisBacklogRefData(acctFCObj, result, dateKey);
        }
        
        for(String dateKey : list_dateKey) {
            AggregateResult result;
            acctFCObj = (ClsAPLEntityTypes.AcctFCValueObj) acctFCObj.assignHisBacklogRefData(acctFCObj, result, dateKey);            
        }
        
    }
    
    /**
    * This method is used to get relay cbc2 forecast.
    *
    @author Weihang Li
    @created 2014-06-18
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *@param FCInfo request - parentId is AccountId
    *
    @changelog
    * 2014-06-18 Weihang Li <weihang.li@itbconsult.com>
    * - Created
    */
    public static ClsAPLEntityTypes.AcctFCResults getRelayCBCFC(ClsAPLEntityTypes.RSMRelayCBCFCInfo relayCBCFCInfo){
        ClsAPLEntityTypes.AcctFCResults acctFCResult = new ClsAPLEntityTypes.AcctFCResults();
        map<String, ClsAPLEntityTypes.CBCFCValueObj> map_cbcKey_cbcFC = new map<String, ClsAPLEntityTypes.CBCFCValueObj>();
        map<String, map<String, list<AggregateResult>>> map_cbcName_map_dateKey_list_result =
            new map<String, map<String, list<AggregateResult>>>();

        String query = ' Select Fiscal_Year__c year, sum(RSM_Forecast__c) fc, sum(Forecast__c) amFC, ' // sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC, '
                     + ' sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter, ' 
                     + ' Relay_CBC2_Code__c cbc2Name '; 
        query += ' From APL_Sales_Forecast__c ';
        query += ' Where Id != null And Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' And Customer__r.Relay_Specialist_Territory_Code__c= \'' + relayCBCFCInfo.territoryCode + '\' ';
        query += ' And Customer__r.STATDESC__c = \'Active\' '; 
        if(relayCBCFCInfo.acctId != null){
            //query += ' And Customer__r.APL_Relay_forecast_Plan_Account__c = \'' + relayCBCFCInfo.parentId + '\'';
            query += getForecastParentFilter(relayCBCFCInfo.acctId, relayCBCFCInfo.territoryCode, false);
        }
        //query += ClsAPLForecastUtil.getRelayPartQuery();
        query += ClsAPLForecastUtil.getMonthFilter(relayCBCFCInfo.map_year_quartersFuture);
        query += ' Group by Fiscal_Year__c, Fiscal_Quarter__c, Relay_CBC2_Code__c ';
        
        system.debug('query:: '+query); 
        // to do lili  
        //decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, 'USD', cbc_fc.map_acctId_currencyIso.get(cbc_fc.aid));
        decimal currencyRate = 1;              
        for(AggregateResult  result : Database.query(query)) {
            String year = (String) result.get('year'),
                   quarter = (String) result.get('quarter'), 
                   dateKey = (year + '_' + quarter),
                   cbcName = (String) (result.get('cbc2Name') == null ? '' : result.get('cbc2Name'));
                   //cbc3 = (String) (result.get('cbc3Name') == null ? '' : result.get('cbc3Name')),
                   //cbcName = getCBCKeyName(cbc2, cbc3);
            if(!map_cbcName_map_dateKey_list_result.containsKey(cbcName)) {
                map_cbcName_map_dateKey_list_result.put(cbcName, new map<String, list<AggregateResult>>());
            }
            if(!map_cbcName_map_dateKey_list_result.get(cbcName).containsKey(dateKey)) {
                map_cbcName_map_dateKey_list_result.get(cbcName).put(dateKey, new list<AggregateResult>());
            }
            map_cbcName_map_dateKey_list_result.get(cbcName).get(dateKey).add(result);
            
            //ClsAPLForecastUtil.setResultMap(result, cbcName, dateKey, map_cbcName_map_dateKey_result);
        }
        //system.debug('map_cbcName_map_dateKey_list_result::: '+map_cbcName_map_dateKey_list_result);
        //build map for all the cbcs & quarters
        for(String cbcKey : relayCBCFCInfo.map_cbcRowKey_cbcName.keySet()) {
            //String cbcName = relayCBCFCInfo.map_cbcRowKey_cbcName.get(cbcKey);
            String cbcName = cbcKey;
            for(String year : relayCBCFCInfo.map_year_quartersFuture.keySet()) {
                for(String quarter : relayCBCFCInfo.map_year_quartersFuture.get(year)) {                    
                    String dateKey = (year + '_' + quarter);
                    list<AggregateResult> list_result = new list<AggregateResult>();
                    
                    if(map_cbcName_map_dateKey_list_result.containsKey(cbcKey)
                        && map_cbcName_map_dateKey_list_result.get(cbcKey).containsKey(dateKey)) {                        
                        list_result = map_cbcName_map_dateKey_list_result.get(cbcKey).get(dateKey);
                    }
                    if(!map_cbcKey_cbcFC.containsKey(cbcKey)) {
                        ClsAPLEntityTypes.CBCFCValueObj cbcFC = new ClsAPLEntityTypes.CBCFCValueObj();
                        cbcFC.gplCode = cbcKey;
                        cbcFC.fieldName = relayCBCFCInfo.map_cbcRowKey_cbcName.get(cbcKey);
                        cbcFC.rsmTypeName = (cbcKey == ClsAPLForecastUtil.CBCOTHER ? 'ClsAPLEntityTypes.RSMPartFCInfo' : cbcFC.rsmTypeName);
                        map_cbcKey_cbcFC.put(cbcKey, cbcFC);
                    }
                    ClsAPLEntityTypes.CBCFCValueObj cbcFC = map_cbcKey_cbcFC.get(cbcKey);
                    if(list_result.size() > 0) {
                        for(AggregateResult resultView : list_result) {
                            cbcFC = (ClsAPLEntityTypes.CBCFCValueObj) cbcFC.assignFCValues(cbcFC, resultView, dateKey);
                        } 
                    }else {
                        AggregateResult resultObj;
                        cbcFC = (ClsAPLEntityTypes.CBCFCValueObj) cbcFC.assignFCValues(cbcFC, resultObj, dateKey);
                    }
                                       
                }
            }
        }
        system.debug('relayCBCFCInfo::::'+relayCBCFCInfo);  
        /*
        if(relayCBCFCInfo.map_year_monthsHistory != null && !relayCBCFCInfo.map_year_monthsHistory.isEmpty()) {
            getCBCHistoryRefData(relayCBCFCInfo.acctId, relayCBCFCInfo.territoryCode, currencyRate, relayCBCFCInfo.map_cbcRowKey_cbcName,
                                 relayCBCFCInfo.map_year_monthsHistory, map_cbcKey_cbcFC); 
        }  
        if(relayCBCFCInfo.map_year_monthsFuture != null && !relayCBCFCInfo.map_year_monthsFuture.isEmpty()) {
            getCBCHistoryRefBacklogData(relayCBCFCInfo.acctId, relayCBCFCInfo.territoryCode, currencyRate, relayCBCFCInfo.map_cbcRowKey_cbcName, 
                                        relayCBCFCInfo.periodStartDate, relayCBCFCInfo.refStartDate, relayCBCFCInfo.map_year_monthsFuture, map_cbcKey_cbcFC);

            getCBCFutureRefData(relayCBCFCInfo.acctId, relayCBCFCInfo.territoryCode, currencyRate, relayCBCFCInfo.map_cbcRowKey_cbcName, 
                                relayCBCFCInfo.refStartDate, relayCBCFCInfo.refEndDate, relayCBCFCInfo.map_year_monthsFuture, map_cbcKey_cbcFC);
        } 
       */
        
        //prepare result
        system.debug('map_cbcKey_cbcFC :: ' + map_cbcKey_cbcFC);
        acctFCResult.json_result = Json.serialize(map_cbcKey_cbcFC.values());
        return acctFCResult;
    }
    
    /**
    * This method is used to refresh the data of booking,billing,blocklog as the cbc code
    @author Lili Zhao
    @created 2014-07-23
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *@param FCInfo request - parentId is AccountId
    *
    @changelog
    * 2014-06-18 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    
    public static ClsAPLEntityTypes.AcctFCResults getRSMRelayCBCRefData(ClsAPLEntityTypes.RSMRelayCBCFCInfo cbcFCInfo) {
        system.debug('cbcFCInfo::: ' + cbcFCInfo);
        
        ClsAPLEntityTypes.AcctFCResults result = new ClsAPLEntityTypes.AcctFCResults();
        ClsAPLEntityTypes.CBCFCValueObj fcViewObj = new ClsAPLEntityTypes.CBCFCValueObj();
        
        String startDate = ClsAPLForecastUtil.getStartDate(cbcFCInfo.list_dateKey[0]),
               endDate = ClsAPLForecastUtil.getEndDate(cbcFCInfo.list_dateKey[2]);
        Integer startYear = Integer.valueOf(startDate.subStringBefore('-')), 
               startMonth = Integer.valueOf(startDate.subStringBetween('-', '-')), 
               endYear = Integer.valueOf(endDate.subStringBefore('-')), 
               endMonth = Integer.valueOf(endDate.subStringBetween('-', '-')), 
               currentYear = Integer.valueOf(cbcFCInfo.currentYear),
               currentMonth = Integer.valueOf(cbcFCInfo.currentMonth); 
        map<String, set<Integer>> map_fiscalMonth = ClsAPLForecastUtil.getFiscalMonthMap(cbcFCInfo.list_dateKey);
        
        Date date_endDate = Date.newInstance(endYear, endMonth, 1);
        Date date_currentDate = Date.newInstance(currentYear, currentMonth, 1);
        Date date_startDate = Date.newInstance(startYear, startMonth, 1);
        decimal currencyRate = 1;    
        
        if(date_endDate < date_currentDate) {
            getCBCHistoryRefData(cbcFCInfo.acctId, cbcFCInfo.territoryCode, currencyRate, startDate, endDate, cbcFCInfo.cbc2Code, 
                                    cbcFCInfo.list_dateKey, fcViewObj);
            getCBCHistoryRefBacklogData(cbcFCInfo.acctId, cbcFCInfo.territoryCode, currencyRate, map_fiscalMonth, cbcFCInfo.cbc2Code,
                                    cbcFCInfo.list_dateKey, fcViewObj);
        }
        else if(date_currentDate < date_startDate) {
            getCBCFutureRefData(cbcFCInfo.acctId, cbcFCInfo.territoryCode, currencyRate, map_fiscalMonth, cbcFCInfo.cbc2Code,
                                    cbcFCInfo.list_dateKey, fcViewObj);
        }
        else {
            String currentEndDate =  ClsAPLForecastUtil.getEndDate(cbcFCInfo.currentYear + '_' + cbcFCInfo.currentMonth);
            map<String, set<Integer>> map_history = new map<String, set<Integer>>();
            map<String, set<Integer>> map_future = new map<String, set<Integer>>();
            ClsAPLForecastUtil.getDividedFiscalMap(date_currentDate, cbcFCInfo.list_dateKey, map_history, map_future);
            
            getCBCHistoryRefData(cbcFCInfo.acctId, cbcFCInfo.territoryCode, currencyRate, startDate, currentEndDate, cbcFCInfo.cbc2Code, 
                                    cbcFCInfo.list_dateKey, fcViewObj);
            if(!map_history.isEmpty()) {
                getCBCHistoryRefBacklogData(cbcFCInfo.acctId, cbcFCInfo.territoryCode, currencyRate, map_history, cbcFCInfo.cbc2Code,
                                    cbcFCInfo.list_dateKey, fcViewObj);
            }
            if(!map_future.isEmpty()) {
                getCBCCurrentRefData(cbcFCInfo.acctId, cbcFCInfo.territoryCode, currencyRate, cbcFCInfo.currentYear, 
                                    cbcFCInfo.currentMonth, cbcFCInfo.cbc2Code, cbcFCInfo.list_dateKey, fcViewObj);
                                    
                getCBCFutureRefData(cbcFCInfo.acctId, cbcFCInfo.territoryCode, currencyRate, map_future, cbcFCInfo.cbc2Code,
                                    cbcFCInfo.list_dateKey, fcViewObj);
            }
            
        }
        fcViewObj.cls = String.join(cbcFCInfo.list_dateKey, ',');
        fcViewObj.fieldName = cbcFCInfo.cbc2Code;
        result.json_result = Json.serialize(fcViewObj);                     
        return result;
    }

    
    
    /**
    * This method is used to get part forecast.
    *
    @author Weihang Li
    @created 2014-06-18
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *@param FCInfo request - parentId is AccountId
    *
    @changelog
    * 2014-06-18 Weihang Li <weihang.li@itbconsult.com>
    * - Created
    */
    public static ClsAPLEntityTypes.AcctFCResults getPartFC(ClsAPLEntityTypes.RSMRelayGPLFCInfo relayInfo) {
        system.debug('relayInfo::: '+relayInfo);
        decimal currencyRate = 1;
        String pricePlaces = '';
        if(APL_Forecast_Settings__c.getInstance('Price Decimal Places') != null 
            && APL_Forecast_Settings__c.getInstance('Price Decimal Places').Value__c != null) {
            pricePlaces = (String) APL_Forecast_Settings__c.getInstance('Price Decimal Places').Value__c;
        }
        ClsAPLEntityTypes.AcctFCResults acctFCResult = new ClsAPLEntityTypes.AcctFCResults();
        map<String, ClsAPLEntityTypes.RelayPartFCValueObj> map_partId_fcViewObj = new map<String, ClsAPLEntityTypes.RelayPartFCValueObj>();
        String query = ' Select Fiscal_Year__c year, Fiscal_Quarter__c quarter, Part__c partId, Part__r.Description__c partDesc, Part__r.Product_Hierarchy__c gplId , Part__r.Name partName, ';
        query += ' sum(RSM_Forecast__c) fc, sum(Current_month_1_forecast__c) prevFC, sum(Forecast__c) amFC, ';
        query +=' sum(RSM_Quantity__c) quantity, sum(Current_month_1_RSM_quantity__c) preQuantity, avg(RSM_Price__c) price, avg(Current_month_1_RSM_price__c) prePrice ';
        query += ' FROM APL_Sales_Forecast__c ';
        query += ' WHERE Id != null And Customer__r.Relay_Specialist_Territory_Code__c= \'' + relayInfo.territoryCode + '\'';
        query += ' And Customer__r.STATDESC__c = \'Active\' '; 
        query += getRelayPartSearchQueryFilter(relayInfo.cbc2Code, true);
        query += ClsAPLForecastUtil.getMonthFilter(relayInfo.map_year_quartersFuture);
        
        query += getForecastParentFilter(relayInfo.acctId, relayInfo.territoryCode, false);
        query += ' And Type__c = \'' + RELAYFCTYPE + '\' ';
        query += ' Group by Part__c, Fiscal_Year__c, Fiscal_Quarter__c, Part__r.Description__c, Part__r.Name, Part__r.Product_Hierarchy__c ' ;
        system.debug('query ::590:: '+query);
        map<String, map<String, AggregateResult>> map_partId_map_dateKey_result = new map<String, map<String, AggregateResult>>();
        map<String, String> map_partId_partName = new map<String, String>();
        map<String, ClsAPLEntityTypes.RelayPartObject> map_partId_relayPartObj = new map<String, ClsAPLEntityTypes.RelayPartObject>();
        //map<String, RelayForecastViewCurrentFields> map_cbc2RowKey_fcViewCurrentObj = new map<String, RelayForecastViewCurrentFields>();
        set<String> set_highLightParts = new set<String>();
        //get all high light parts
        getPartHighlight(relayInfo.acctId, relayInfo.cbc2Code, relayInfo.territoryCode, relayInfo.map_year_quartersFuture, set_highLightParts);                
        //build gpl result map        
        setPartFCQueryResult(query, map_partId_map_dateKey_result, map_partId_relayPartObj);
        //setMapPartIdName(map_partId_partName); // add lili zhao 2014-07-25
        //build gpl forecast list for each month
        system.debug('map_partId_relayPartObj::: '+map_partId_relayPartObj);
        system.debug('map_partId_map_dateKey_result::: '+map_partId_map_dateKey_result);
        for(String partId : map_partId_relayPartObj.keySet()) {
            for(String year : relayInfo.map_year_quartersFuture.keySet()) {
                for(String quarter : relayInfo.map_year_quartersFuture.get(year)) {
                    String dateKey = year + '_' + quarter;
                    AggregateResult result;
                    if(map_partId_map_dateKey_result.containsKey(partId) && map_partId_map_dateKey_result.get(partId).containsKey(dateKey)) {
                        result = map_partId_map_dateKey_result.get(partId).get(dateKey);
                    }
                    if(!map_partId_fcViewObj.containsKey(partId)) {
                        ClsAPLEntityTypes.RelayPartFCValueObj partFC = new ClsAPLEntityTypes.RelayPartFCValueObj();
                        partFC.partId = partId;
                        partFC.gplId = map_partId_relayPartObj.get(partId).gplId;
                        partFC.fieldName = map_partId_relayPartObj.get(partId).name;
                        map_partId_fcViewObj.put(partId, partFC);
                    }
                    ClsAPLEntityTypes.RelayPartFCValueObj obj = map_partId_fcViewObj.get(partId);
                    obj = (ClsAPLEntityTypes.RelayPartFCValueObj) obj.assignFCPartRelayValues(obj, result, dateKey, pricePlaces); 
                    if(set_highLightParts.contains(obj.partId)) {
                        obj.isHighLighted = true;
                    }                                      
                }
            }
        }       
        system.debug('map_partId_fcViewObj::: '+map_partId_fcViewObj);
        if(relayInfo.map_year_monthsHistory != null && !relayInfo.map_year_monthsHistory.isEmpty()) {
            getPartHistoryRefData(relayInfo.cbc2Code, relayInfo.acctId, currencyRate,relayInfo.territoryCode, relayInfo.map_year_monthsHistory, map_partId_fcViewObj);   
            
            getPartHistoryRefBacklogData(relayInfo.cbc2Code, relayInfo.acctId, currencyRate, relayInfo.territoryCode, relayInfo.periodStartDate, relayInfo.refStartDate, 
                                relayInfo.map_year_monthsHistory, map_partId_fcViewObj);
        }
        if(relayInfo.currentYear != null && relayInfo.currentMonth != null) {
            getPartCurrentRefData(relayInfo.cbc2Code, relayInfo.acctId, currencyRate, relayInfo.territoryCode, relayInfo.currentYear, relayInfo.currentMonth, map_partId_fcViewObj);
        }
        if(relayInfo.refStartDate != null && relayInfo.refEndDate != null) {
            getPartFutureRefData(relayInfo.cbc2Code, relayInfo.acctId, currencyRate, relayInfo.territoryCode, relayInfo.refStartDate, relayInfo.refEndDate, 
                                relayInfo.map_year_monthsFuture, map_partId_fcViewObj);
        }
        system.debug('map_partId_fcViewObj::: '+map_partId_fcViewObj);
        acctFCResult.json_result = Json.serialize(map_partId_fcViewObj.values());
        return acctFCResult;
    }
    
    
    /**
    * This method is used get exist part Id.
    *
    @author Lili Zhao
    @created 2014-06-27
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-27 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static void getPartHighlight(String parentId, String cbcCode, String territoryCode, 
                                        map<String, set<String>> map_year_quartersFuture, set<String> set_highLightParts) {
        
        String query = getPartHighlightQuery(parentId, cbcCode, territoryCode, map_year_quartersFuture, true);
        map<String, set<String>> map_partId_set_acctIds = new map<String, set<String>>();
        Integer minPartCounter = 0;
        system.debug('query ::: '+query);
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
    * This method is used get the query of exist part Id.
    *
    @author Lili Zhao
    @created 2014-06-27
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-27 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static String getPartHighlightQuery(String parentId, String cbcCode, String territoryCode,
                                               map<String, set<String>> map_year_quartersFuture, boolean isForHighlight) {
        
        String query = ' Select ' + (isForHighlight ? ' Customer__c acctId, Part__c partId ' : ' Part__c partId ');
        query += ' FROM APL_Sales_Forecast__c ';
        query += ' WHERE Id != null And Customer__r.Relay_Specialist_Territory_Code__c= \'' + territoryCode + '\'';
        query += ' And Customer__r.STATDESC__c = \'Active\' '; 
        query += getRelayPartSearchQueryFilter(cbcCode, true);
        query += ClsAPLForecastUtil.getMonthFilter(map_year_quartersFuture);
        
        String str_filter = getForecastParentFilter(parentId, territoryCode, false);
        str_filter += ' And Type__c = \'' + RELAYFCTYPE + '\'';
        String str_groupby = ' Group by' + (isForHighlight ? ' Customer__c, Part__c ' : ' Part__c ');
        
        query += (str_filter + str_groupby);
        
        return query;
    }
    
    /**
    * This method is used get account hierarchy for current account manager.
    *
    @author Weihang Li
    @created 2014-06-18
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-18 Weihang Li <weihang.li@itbconsult.com>
    * - Created
    */
    
    public static void setPartFCQueryResult(String query, map<String, map<String, AggregateResult>> map_partId_map_dateKey_result, map<String, ClsAPLEntityTypes.RelayPartObject> map_partId_relayPartObj) {
        for(AggregateResult result : database.query(query)) {
            String partId = (String) result.get('partId');
            String partName = (String) result.get('partName');
            String year = (String) result.get('year');
            String quarter = (String) result.get('quarter');
            String gplId = (String) result.get('gplId');
            String dateKey = year + '_' + quarter;
            if(!map_partId_map_dateKey_result.containsKey(partId)) {
                map_partId_map_dateKey_result.put(partId, new map<String, AggregateResult>());
            }
            if(!map_partId_map_dateKey_result.get(partId).containsKey(dateKey)) {
                map_partId_map_dateKey_result.get(partId).put(dateKey, result);
            }
            ClsAPLEntityTypes.RelayPartObject relayObj = new ClsAPLEntityTypes.RelayPartObject();
            relayObj.gplId = gplId;
            relayObj.name = partName; 
            map_partId_relayPartObj.put(partId, relayObj);
        }
    }
    /**
    * This method is used get account hierarchy for current account manager.
    *
    @author Weihang Li
    @created 2014-06-18
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-18 Weihang Li <weihang.li@itbconsult.com>
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
    * This method is used to get the part query for relay
    *
    @author Weihang Li
    @created 2014-06-18
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-18 Weihang Li <weihang.li@itbconsult.com>
    * - Created
    */
    public static String getRelayPartSearchQueryFilter(String cbcCode, boolean isForecast) {
        String filter = '';
        filter += ' And '+(isForecast ? 'Part__r.' : '' ) + 'Product_Hierarchy__r.' + getRelayField(cbcCode) + ' = \'' + cbcCode + '\' ';
        
        return filter;
    }
    /**
    * This method is used to build currency iso map 
    *
    @author Weihang Li
    @created 2014-06-18
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-18 Weihang Li <weihang.li@itbconsult.com>
    * - Created
    */
    public static String getForecastParentFilter(String parentId, String territoryCode, boolean isAcct) {
        system.debug('parentId:::'+parentId);
        String filter = ' And ' + (isAcct ? '' : 'Customer__r.') + (parentId == ClsAPLForecastUtil.OTHERACCTID ? 'APL_Relay_forecast_Plan_Account__c = null ' : 'APL_Relay_forecast_Plan_Account__c = \'' + parentId + '\'') ;
        return filter;
    }
    
    /**
    * This method is used to get the part filed for relay
    *
    @author Weihang Li
    @created 2014-06-18
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-18 Weihang Li <weihang.li@itbconsult.com>
    * - Created
    */
    public static String getRelayField(String gplId) {
        String relayField = '';
        system.debug('gplId:::: '+gplId);
        for(String cbcField : map_RELAY_CBCFIELD_CBCDESC.keySet()) {
            if(map_RELAY_CBCFIELD_CBCDESC.get(cbcField).contains(gplId)) {
                relayField = cbcField;
                return relayField;
            }           
        }  
        system.debug('relayField:::' + relayField);
        return relayField;
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
    * This method is used to get the children account billing percent
    *
    @author Weihang Li
    @created 2014-06-20
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-20 Weihang Li <weihang.li@itbconsult.com>
    * - Created
    */
    /*
    public static void getChildAcctPercent(String parentId, String territoryCode, String quarterNumb, map<String, decimal> map_acctId_billingPercent) {
    
        decimal totalBilling = 0;       
        set<String> set_childAcctIds = new set<String>();
        //get all children accounts
        getChildrenAccts(parentId, territoryCode, set_childAcctIds);
        // get account billing query
        String query = 'select SUM(Bill_Prior_Year_Amount_USD__c) priorAmount, SUM(Bill_Year_to_Date_Amount_USD__c) amount, Customer__c AcctId '
                     + ' From BBB_Year_Bill_Book_Cust_PN__c '
                     + ' Where Id != null And Customer__r.Relay_Specialist_Territory_Code__c= \'' + territoryCode + '\'';
        
        query += getForecastParentFilter(parentId, territoryCode, false);
        query += ' group by Customer__c';

        // get account billing data
        for(AggregateResult  result : database.query(query)) {
            String acctId = (String) result.get('AcctId');
            decimal priorAmount = (decimal) (result.get('priorAmount') == null ? 0 : result.get('priorAmount'));
            decimal tempAmount = (decimal) (result.get('amount') == null ? 0 : result.get('amount'));
            decimal amount = tempAmount + ((quarterNumb == 'Q1' || quarterNumb == 'Q2') ? priorAmount : 0); 
            map_acctId_billingPercent.put(acctId, amount);
            totalBilling += amount;
        }
        //build map for all children accounts
        for(String acctId : set_childAcctIds) {
            if(!map_acctId_billingPercent.containsKey(acctId)) {
                map_acctId_billingPercent.put(acctId, 0);
            }
        }
        // calc each account
        calcPercentage(map_acctId_billingPercent, totalBilling);
        
    }
    */
    /**
    * This method is used to get the exist account forecast.
    *
    @author Weihang Li
    @created 2014-06-20
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-20 Weihang Li <weihang.li@itbconsult.com>
    * - Created
    */
    /*
    public static void getExistingAcctFC(String parentId, String territoryCode, 
                                        String quartNumb, map<String, set<String>> map_year_quartersFuture, 
                                        map<String, map<String, APL_Sales_Forecast__c>> map_acctId_map_dateKey_fc) {
                                            
        String query = ' Select Id, Customer__c, Fiscal_Quarter__c, Fiscal_Year__c, Forecast__c '
                     + ' From APL_Sales_Forecast__c '
                     + ' Where Type__c = \'' + ACCTFCTYPE + '\' And Customer__r.Relay_Specialist_Territory_Code__c= \'' + territoryCode + '\'';
        query += getForecastParentFilter(parentId, territoryCode, false);
        query += ClsAPLForecastUtil.getMonthFilter(map_year_quartersFuture);
        system.debug('getExistingAcctFC :: ' + query);
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
    * This method is used to build currency iso map 
    *
    @author Weihang Li
    @created 2014-06-20
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-20 Weihang Li <weihang.li@itbconsult.com>
    * - Created
    */
    private static void generateFC(map<String, decimal> map_acctId_billingPercent, map<String, ClsAPLEntityTypes.RelayFC> map_dateKey_fc,
                                    map<String, map<String, APL_Sales_Forecast__c>> map_acctId_map_dateKey_fc, String currencyIso,
                                    String fcType, String partId, String gplId, boolean isAcc, 
                                    list<APL_Sales_Forecast__c> list_acctFC2Insert,
                                    list<APL_Sales_Forecast__c> list_acctFC2Update, 
                                    list<APL_Sales_Forecast__c> list_acctFC2Delete) {
        
        set<String> set_updatedAcctFCIds = new set<String>();
        
        if(map_acctId_map_dateKey_fc == null) {
            map_acctId_map_dateKey_fc = new map<String, map<String, APL_Sales_Forecast__c>>();
        }
        integer i = 0;
        map<String, decimal> dateKey_sumQuantity = new map<String, decimal>();
        //create or update account forecast records
        for(String acctId : map_acctId_billingPercent.keySet()) {
            for(String dateKey : map_dateKey_fc.keySet()) {
                //if has such account percent will not generate apl forecast record for this account
                if(!map_acctId_billingPercent.containsKey(acctId)) {
                    continue;
                }
                String year = dateKey.substringBefore('_');
                String quarter = dateKey.substringAfter('_');
                ClsAPLEntityTypes.RelayFC fc = map_dateKey_fc.get(dateKey);
                system.debug('fc::: '+fc);
                decimal percent = map_acctId_billingPercent.get(acctId);
                if(!dateKey_sumQuantity.containsKey(dateKey)) {
                    dateKey_sumQuantity.put(dateKey, 0);
                }
                decimal sumQuantity = dateKey_sumQuantity.get(dateKey); 
                
                if(map_acctId_map_dateKey_fc.containsKey(acctId) 
                    && map_acctId_map_dateKey_fc.get(acctId).containsKey(dateKey)) {
                
                    APL_Sales_Forecast__c acctFC = map_acctId_map_dateKey_fc.get(acctId).get(dateKey);
                    system.debug('acctFC：：： '+acctFC);
                    if(!isAcc) {                        
                        acctFC.RSM_Price__c = ClsAPLForecastUtil.transformIsoCode(fc.price, 'USD', acctFC.CurrencyIsoCode); 
                        //acctFC.RSM_Price__c = fc.price;
                        system.debug('map_acctId_billingPercent.size()::: ' + map_acctId_billingPercent.size());
                        system.debug('1::: ' + i);
                        if(i == (map_acctId_billingPercent.size() - 1)) {
                            acctFC.RSM_Quantity__c = fc.amount - sumQuantity;
                        }else { 
                            system.debug('fc.amount::: ' + fc.amount);    
                            system.debug('percent::: ' + percent); 
                            decimal quantity = fc.amount * percent;               
                            //acctFC.RSM_Quantity__c = fc.amount * percent;
                            system.debug('acctFC.RSM_Quantity__c'+acctFC.RSM_Quantity__c);
                            if(quantity != 0) {
                                quantity = quantity.setScale(0, System.Roundingmode.HALF_UP);
                            }
                            acctFC.RSM_Quantity__c = quantity;
                        }
                        acctFC.RSM_Forecast__c = fc.price * acctFC.RSM_Quantity__c;
                        
                        sumQuantity += acctFC.RSM_Quantity__c;
                        if(dateKey_sumQuantity.containsKey(dateKey)) {
                            dateKey_sumQuantity.put(dateKey, sumQuantity);
                        }

                    }else {
                        acctFC.Forecast__c = fc.total * percent;
                    } 
                    system.debug('currencyIso::: '+acctFC.CurrencyIsoCode);
                    decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, acctFC.CurrencyIsoCode, 'USD');  
                    system.debug('currencyRate::: '+currencyRate);
                    system.debug(':::: '+ClsAPLForecastUtil.transformIsoCode(1,'USD', acctFC.CurrencyIsoCode));
                    acctFC.GAM_Forecast__c = acctFC.RSM_Forecast__c;  
                    acctFC.GPl__c = gplId;
                    //acctFC.RSM_Price__c = acctFC.Forecast__c / currencyRate;                
                    //acctFC.currencyIsoCode = currencyIso;
                    list_acctFC2Update.add(acctFC);
                    set_updatedAcctFCIds.add(acctFC.Id);
                    system.debug('list_acctFC2Update:::: '+list_acctFC2Update);
                }
                else {
                    APL_Sales_Forecast__c acctFC = new APL_Sales_Forecast__c();
                    acctFC.Customer__c = acctId;
                    acctFC.GPl__c = gplId;
                    acctFC.Type__c = fcType;
                    acctFC.Fiscal_Year__c = year;
                    acctFC.Fiscal_Quarter__c = quarter;

                    if(!isAcc) {
                        acctFC.RSM_Price__c = ClsAPLForecastUtil.transformIsoCode(fc.price, currencyIso, 'USD'); 
                        //acctFC.RSM_Price__c = fc.price;
                        if(i == map_acctId_billingPercent.size()-1) {
                            acctFC.RSM_Quantity__c = fc.amount - sumQuantity;
                        }else {   
                            decimal quantity = fc.amount * percent;                     
                            //acctFC.RSM_Quantity__c = fc.amount * percent;
                            if(quantity != 0) {
                                quantity = quantity.setScale(0, System.Roundingmode.HALF_UP);
                            }
                            acctFC.RSM_Quantity__c = quantity;
                        }
                        acctFC.RSM_Forecast__c = fc.price * acctFC.RSM_Quantity__c;
                        
                        sumQuantity += acctFC.RSM_Quantity__c;
                        if(dateKey_sumQuantity.containsKey(dateKey)) {
                            dateKey_sumQuantity.put(dateKey, sumQuantity);
                        }
                    }else {
                        acctFC.Forecast__c = fc.total * percent;
                    }
                    decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, currencyIso, 'USD');   
                    //acctFC.GAM_Forecast__c = acctFC.RSM_Forecast__c * currencyRate; 
                    acctFC.GAM_Forecast__c = acctFC.RSM_Forecast__c;
                    //acctFC.RSM_Price__c = acctFC.RSM_Price__c / currencyRate; 
                    system.debug('currencyIso:::'+currencyIso);
                    acctFC.currencyIsoCode = currencyIso;
                    acctFC.Part__c = (fcType == RELAYFCTYPE ? partId : null);
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
    @author Weihang Li
    @created 2014-06-20
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-20 Weihang Li <weihang.li@itbconsult.com>
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
    @author Weihang Li
    @created 2014-06-20
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-20 Weihang Li <weihang.li@itbconsult.com>
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
    * This method is used to get GPLs for CBC2
    *
    @author Weihang Li
    @created 2014-06-20
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-20 Weihang Li <weihang.li@itbconsult.com>
    * - Created
    */
    public static void savePartFC(ClsAPLEntityTypes.RSMRelayCBCFCInfo releyCbcFC) {
        
        map<String, map<String, decimal>> map_partId_map_acctId_partPercent = new map<String, map<String, decimal>>();
        map<String, decimal> map_acctId_avgPercent = new map<String, decimal>();   
        map<String, map<String, map<String, APL_Sales_Forecast__c>>> map_partId_map_acctId_map_dateKey_fc 
            = new map<String, map<String, map<String, APL_Sales_Forecast__c>>>();
            
        list<APL_Sales_Forecast__c> list_acctFC2Insert = new list<APL_Sales_Forecast__c>();
        list<APL_Sales_Forecast__c> list_acctFC2Update = new list<APL_Sales_Forecast__c>();
        list<APL_Sales_Forecast__c> list_acctFC2Delete = new list<APL_Sales_Forecast__c>();
        //get gpl percent and parts percent
        getPartPercentForSave(releyCbcFC.parentId, releyCbcFC.cbc2Code, releyCbcFC.territoryCode, releyCbcFC.quarterNumb,
                              map_acctId_avgPercent, map_partId_map_acctId_partPercent);

        //get existing part forecasts
        getExistingPartFC(releyCbcFC.parentId, releyCbcFC.cbc2Code, releyCbcFC.territoryCode, releyCbcFC.quarterNumb,
                            releyCbcFC.map_year_quartersFuture, map_partId_map_acctId_map_dateKey_fc);
        //generate or update part forecast records  
        system.debug('releyCbcFC::: '+releyCbcFC);            
        generatePartFC(releyCbcFC.list_partFC, releyCbcFC.currencyIso, map_partId_map_acctId_partPercent, map_partId_map_acctId_map_dateKey_fc, map_acctId_avgPercent,
                       list_acctFC2Insert, list_acctFC2Update, list_acctFC2Delete);             
        system.debug('Part list_acctFC2Insert :: ' + list_acctFC2Insert);
        system.debug('list_acctFC2Update:::: '+list_acctFC2Update);
        //INSERT, UPDATE, DELETE APL Forecasts
        ClsAPLForecastUtil.aplFCRecordsDML(list_acctFC2Insert, list_acctFC2Update, list_acctFC2Delete);
    }
    /**
    * This method is used to get the children account billing percent
    *
    @author Weihang Li
    @created 2014-06-20
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-20 Weihang Li <weihang.li@itbconsult.com>
    * - Created
    */
    public static void getPartPercentForSave(String parentId, String cbcCode, String territoryCode, String quartNumb,
                                             map<String, decimal> map_acctId_avgPercent, map<String, map<String, decimal>> map_partId_map_acctId_partPercent) {
        
        map<String, decimal> map_partId_totalAmount = new map<String, decimal>();
        set<String> set_childAcctIds = new set<String>();
        //get all children account ids for current parent
        getChildrenAccts(parentId, territoryCode, set_childAcctIds);
        system.debug('set_childAcctIds::: '+set_childAcctIds);
        // get account billing query
        String query = 'select SUM(Bill_Amount_current_prior__c) amount, Part__c PartId, Customer__c AcctId '
                     + ' From BBB_Year_Bill_Book_Cust_PN__c '
                     + ' Where Id != null And Bill_Amount_current_prior__c != null And Bill_Amount_current_prior__c != 0 ';
        
        query += ' And Part__r.Product_Hierarchy__r.' + getRelayField(cbcCode) + ' = \'' + cbcCode + '\' ';
        query += ' And Customer__r.STATDESC__c = \'Active\' '; 
        query += getForecastParentFilter(parentId, territoryCode, false);
        
        //update by nelson zheng 2015-10-21 for case 00900375
        //query += ' And BU_Profit_Center__c = \'RPA\'  ';
        //query += ' And (BU_Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  ';
        query += ' And BU_Profit_Center__c = \'APL\'  ';
        system.debug('------------ClsAPLServiceRSMRelay.cls (21 matches) 13------------------');             
        
        query += ' group by Part__c, Customer__c';
        //get reference data by part ==> map_acctId_map_partId_billingAmount
        system.debug('query::: '+query);
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
        system.debug('!@# map_partId_totalAmount : '+map_partId_totalAmount);
        for(String acctId : set_childAcctIds) {
            if(!map_acctId_avgPercent.containsKey(acctId)) {
                map_acctId_avgPercent.put(acctId, 0);
            }
        }
        
        calcPercentage(map_acctId_avgPercent, 0);
        
        //build part percent for all children account
        for(String partId : map_partId_map_acctId_partPercent.keySet()) {
            for(String acctId : set_childAcctIds) {
                if(!map_partId_map_acctId_partPercent.get(partId).containsKey(acctId)) {
                    map_partId_map_acctId_partPercent.get(partId).put(acctId, 0);
                }
            }
            //Calc part percent // modify by lili zhao 2014-06-16
            calcPercentage(map_partId_map_acctId_partPercent.get(partId), map_partId_totalAmount.get(partId));
            system.debug('!@# map_partId_map_acctId_partPercent.get(partId) : '+map_partId_map_acctId_partPercent.get(partId));
        }
        
    }
    
    /**
    * This method is used to get the children account billing percent
    *
    @author Weihang Li
    @created 2014-06-20
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-20 Weihang Li <weihang.li@itbconsult.com>
    * - Created
    */
    public static void getProductCodePercentForSave(String parentId, String cbcCode, String territoryCode, String quartNumb,
                                             map<String, decimal> map_acctId_avgPercent, map<String, map<String, decimal>> map_partId_map_acctId_partPercent) {
        
        map<String, decimal> map_partId_totalAmount = new map<String, decimal>();
        set<String> set_childAcctIds = new set<String>();
        //get all children account ids for current parent
        getChildrenAccts(parentId, territoryCode, set_childAcctIds);
        system.debug('set_childAcctIds::: '+set_childAcctIds);
        // get account billing query
        String query = 'select SUM(Bill_Amount_current_prior__c) amount, Part__r.PRODUCT_CDE__c PartId, Customer__c AcctId '
                     + ' From BBB_Year_Bill_Book_Cust_PN__c '
                     + ' Where Id != null And Bill_Amount_current_prior__c != null And Bill_Amount_current_prior__c != 0 ';
        
        query += ' And Part__r.Product_Hierarchy__r.' + getRelayField(cbcCode) + ' = \'' + cbcCode + '\' ';
        query += ' And Customer__r.STATDESC__c = \'Active\' '; 
        query += getForecastParentFilter(parentId, territoryCode, false);
        
        //update by nelson zheng 2015-10-21 for case 00900375
        //query += ' And BU_Profit_Center__c = \'RPA\'  ';
        //query += ' And (BU_Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  ';
        query += ' And BU_Profit_Center__c = \'APL\'  ';
        system.debug('------------ClsAPLServiceRSMRelay.cls (21 matches) 13------------------');             
        
        query += ' group by Part__r.PRODUCT_CDE__c, Customer__c';
        //get reference data by part ==> map_acctId_map_partId_billingAmount
        system.debug('query::: '+query);
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
        system.debug('!@# map_partId_totalAmount : '+map_partId_totalAmount);
        for(String acctId : set_childAcctIds) {
            if(!map_acctId_avgPercent.containsKey(acctId)) {
                map_acctId_avgPercent.put(acctId, 0);
            }
        }
        
        calcPercentage(map_acctId_avgPercent, 0);
        
        //build part percent for all children account
        for(String partId : map_partId_map_acctId_partPercent.keySet()) {
            for(String acctId : set_childAcctIds) {
                if(!map_partId_map_acctId_partPercent.get(partId).containsKey(acctId)) {
                    map_partId_map_acctId_partPercent.get(partId).put(acctId, 0);
                }
            }
            //Calc part percent // modify by lili zhao 2014-06-16
            calcPercentage(map_partId_map_acctId_partPercent.get(partId), map_partId_totalAmount.get(partId));
            system.debug('!@# map_partId_map_acctId_partPercent.get(partId) : '+map_partId_map_acctId_partPercent.get(partId));
        }
        
    }
    
    
    /**
    * This method is used to get the children account billing percent
    *
    @author Weihang Li
    @created 2014-06-20
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-20 Weihnag Li <weihang.li@itbconsult.com>
    * - Created
    */
    public static void generatePartFC(list<ClsAPLEntityTypes.RelayPartFCInfo> list_partFC, String currencyIso,
                                      map<String, map<String, decimal>> map_partId_map_acctId_partPercent, 
                                      map<String, map<String, map<String, APL_Sales_Forecast__c>>> map_partId_map_acctId_map_dateKey_fc,
                                      map<String, decimal> map_acctId_avgPercent, 
                                      list<APL_Sales_Forecast__c> list_acctFC2Insert,
                                      list<APL_Sales_Forecast__c> list_acctFC2Update,
                                      list<APL_Sales_Forecast__c> list_acctFC2Delete) {
        system.debug('map_acctId_avgPercent::: '+map_acctId_avgPercent);
        system.debug('map_partId_map_acctId_partPercent::: '+map_partId_map_acctId_partPercent);
        //generate or update part forecast records                  
        for(ClsAPLEntityTypes.RelayPartFCInfo partFC : list_partFC) {
            String partId = partFC.partId.trim();
            string gplId = partFC.gplId.trim();
            //map<String, map<String, APL_Sales_Forecast__c>> temp_map_acctId_map_dateKey_fc = map_partId_map_acctId_map_dateKey_fc.get(partId);
            map<String, map<String, APL_Sales_Forecast__c>> temp_map_acctId_map_dateKey_fc = new map<String, map<String, APL_Sales_Forecast__c>>();
            map<String, decimal> map_acctId_billingPercent = new map<String, decimal>();
            
            system.debug('map_partId_map_acctId_partPercent::: '+map_partId_map_acctId_partPercent);
            system.debug('partId::: '+ partId);  
            if(map_partId_map_acctId_partPercent.containsKey(partId)) {
                map_acctId_billingPercent = map_partId_map_acctId_partPercent.get(partId);
                system.debug('map_acctId_billingPercent:::: '+map_acctId_billingPercent);
            }else {
                map_acctId_billingPercent = map_acctId_avgPercent;
            }           
            
            if(map_partId_map_acctId_map_dateKey_fc.containsKey(partId)) {
                temp_map_acctId_map_dateKey_fc = map_partId_map_acctId_map_dateKey_fc.get(partId);
            }
            //map<String, decimal> map_acctId_billingPercent = map_partId_map_acctId_partPercent.get(partId);
            if(temp_map_acctId_map_dateKey_fc == null) {
                temp_map_acctId_map_dateKey_fc = new map<String, map<String, APL_Sales_Forecast__c>>();
            }
            
            generateFC(map_acctId_billingPercent, partFC.map_dateKey_relayFC, temp_map_acctId_map_dateKey_fc, 
                        currencyIso, RELAYFCTYPE, partId, gplId, false, list_acctFC2Insert, list_acctFC2Update, list_acctFC2Delete);
        }
    }
    /**
    * This method is used to get the 
    *
    @author Weihang Li
    @created 2014-06-20
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-20 Weihang Li <weihnag.li@itbconsult.com>
    * - Created
    */
    public static void getExistingPartFC(String parentId, String cbcCode, String territoryCode, String quartNumb, 
                                        map<String, set<String>> map_year_quartersFuture,
                                        map<String, map<String, map<String, APL_Sales_Forecast__c>>> map_partId_map_acctId_map_dateKey_fc) {
                                            
        String query = ' Select Id, Customer__c, Fiscal_Quarter__c, Fiscal_Year__c, Part__c '
                     + ' From APL_Sales_Forecast__c '
                     + ' Where Type__c = \'' + RELAYFCTYPE + '\' ';
        query += ' And Customer__r.STATDESC__c = \'Active\' '; 
        query += getForecastParentFilter(parentId, territoryCode, false);
        query += ClsAPLForecastUtil.getMonthFilter(map_year_quartersFuture);
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
    * This method is used to get the CBC2FCQuery for RelayForcast.
    *
    @author Weihang li
    @created 2014-06-20
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-20 Weihang Li <weihang.li@itbconsult.com>
    * - Created
    */
    /*
    public static String getCBCField(String cbcCode) {
        for(String field : map_RELAY_CBCFIELD_CBCDESC.keySet()) {
            if(map_RELAY_CBCFIELD_CBCDESC.get(field).contains(cbcCode)) {
                return field;
            }
        }
        return '';
    }
    */
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
    /*
    public static void addPart(String parentId, String cbcCode, String territoryCode,String partName, String quarterNumb,
                                list<RelayPartObj> list_parts, 
                                map<String, set<String>> map_year_quartersFuture, boolean temp, String json_partIds) {
    
    public static ClsAPLEntityTypes.AcctFCResults addPart(ClsAPLEntityTypes.RSMRelayPartFCInfo releyCbcFC) {
        ClsAPLEntityTypes.AcctFCResults acctFCResult = new ClsAPLEntityTypes.AcctFCResults();
        
        //set<String> set_newAddedpartIds = ((releyCbcFC.set_partId == null || releyCbcFC.set_partId == '') ? new set<String>() : (set<String>) json.deserialize(releyCbcFC.set_partId, set<String>.class));
        set<String> set_newAddedpartIds = new set<String>();
        
        list<ClsAPLEntityTypes.RelayPartObj> list_parts = new list<ClsAPLEntityTypes.RelayPartObj>();
          
        set<String> set_existPartIds = new set<String>();
        //filter part ids for already added parts   
        if(!set_newAddedpartIds.isEmpty()) {
            set_existPartIds.addAll(set_newAddedpartIds);
        }
        String existPartIdQuery = getPartHighlightQuery(releyCbcFC.parentId, releyCbcFC.cbc2Code, releyCbcFC.territoryCode, releyCbcFC.map_year_quartersFuture, false);
        system.debug('existPartIdQuery::::'+existPartIdQuery);

        setExistPartIds(set_existPartIds, existPartIdQuery);
        //system.debug('set_existPartIds::::'+set_existPartIds);
        set_existPartIds = new set<String>();
        String query = getPartQuery(releyCbcFC.cbc2Code, releyCbcFC.partName, set_existPartIds);
        //system.debug('query:::'+query);
        setListPartObjs(list_parts, query);
        acctFCResult.json_result = Json.serialize(list_parts);
        
        return acctFCResult;
    }
    */
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
    /*
    public static void setExistPartIds(set<String> set_existPartIds, String existPartIdQuery) {
        for(AggregateResult result : database.query(existPartIdQuery)) {
            String partId = (String) result.get('partId');
            set_existPartIds.add(partId);
        }
    }
    */
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
    /*
    public static String getPartQuery(String gplId, String partName, set<String> set_existPartIds) {
        set<String> set_partIds = new set<String>();
        set_partIds.addAll(set_existPartIds);
        String query = ' Select Id, Name, Description__c ';
        query += ' FROM Part__c ';
        query += ' WHERE Id != null ';        
        query += getRelayPartSearchQueryFilter(gplId, false);
        query += (partName != null ? ' And name like \'%' + partName + '%\' ' : '');
        query += (set_existPartIds.isEmpty() ? '' : ' And Id not in: set_partIds ');
        query += ' limit 200 ';
        return query;
    }
    */
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
    /*
    public static void setListPartObjs(list<ClsAPLEntityTypes.RelayPartObj> list_parts, String query) {
        for(Part__c part : database.query(query)) {
            ClsAPLEntityTypes.RelayPartObj partObj = new ClsAPLEntityTypes.RelayPartObj();
            partObj.partId = part.Id;
            partObj.partName = part.Name;
            partObj.Description = part.Description__c;
            list_parts.add(partObj);
        }
    }
    */
    /**
    * This method is used to delete part
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
    /*
    public static ClsAPLEntityTypes.AcctFCResults deletePart(ClsAPLEntityTypes.RSMRelayPartFCInfo releyCbcFC) {
        ClsAPLEntityTypes.AcctFCResults acctFCResult = new ClsAPLEntityTypes.AcctFCResults();
        list<APL_Sales_Forecast__c> list_aplFC = new list<APL_Sales_Forecast__c>();
        String query = ' Select Id From APL_Sales_Forecast__c WHERE Id != null ';
        query += getForecastParentFilter(releyCbcFC.parentId, releyCbcFC.territoryCode, false);
        query += ' And Part__c = \'' + releyCbcFC.partId + '\'';
        query += ' And Type__c = \'Relay\' ';
        query += ClsAPLForecastUtil.getMonthFilter(releyCbcFC.map_year_quartersFuture);
        try {
            system.debug('deletePart query :: ' + query);
            for(APL_Sales_Forecast__c fc : database.query(query)) {
                list_aplFC.add(fc);
            }
            if(!list_aplFC.isEmpty()) {
                delete list_aplFC;
            }
            acctFCResult.json_result = Json.serialize(true);
            return acctFCResult;
            //return true;
        }
        catch(Exception ex) {
            acctFCResult.json_result = Json.serialize(false);
            return acctFCResult;
            //return false;
        }
    }
    */
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
    public static void getCBCHistoryRefData(String parentId, String territoryCode, decimal currencyRate, 
                                            String startDate, String endDate, String cbcCode, 
                                            list<String> list_dateKey, 
                                            ClsAPLEntityTypes.CBCFCValueObj  fcViewObj)  {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(false, parentId, territoryCode, set_acctIds);

        system.debug('getRelayPartSearchQueryFilter::: '+getRelayPartSearchQueryFilter(cbcCode, true));                                     
        list<String> list_sql = new list<String>();
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking, Fiscal_Date__c fiscal_date '
                    );
        list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
        
        list_sql.add(' Where Customer__c IN : set_acctIds '  
                    + ' And ( Bill_Amount_USD__c != 0 or Book_Amount_USD__c != 0 ) '
                    + getRelayPartSearchQueryFilter(cbcCode, true) 
                    + ' And Fiscal_Date__c >= ' + startDate
                    + ' And Fiscal_Date__c < ' + endDate
                    
                    //update by nelson zheng 2015-10-21 for case 00900375
                    //+ ' And Profit_Center__c = \'RPA\'  '
                    //+ ' And (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  '
	              	+ ' And Profit_Center__c = \'APL\'  '
                    + ' Group by Fiscal_Date__c '
                    );

        system.debug('------------ClsAPLServiceRSMRelay.cls (21 matches) 14------------------');             
        system.debug('getCBCHistoryRefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {

            String cbcKeyName = cbcCode;
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;

            fcViewObj = (ClsAPLEntityTypes.CBCFCValueObj) fcViewObj.assignRefData(fcViewObj, result, dateKey, true);
        }

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
    public static void getCBCHistoryRefBacklogData(String parentId, String territoryCode, decimal currencyRate, 
                                                    map<String, set<Integer>> map_fiscalMonth, String cbcCode, 
                                                    list<String> list_dateKey, 
                                                    ClsAPLEntityTypes.CBCFCValueObj fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(false, parentId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        map<String, map<String, ClsAPLEntityTypes.CBCFCValueObj>> map_cbc2Name_map_dateKey_result = new map<String, map<String, ClsAPLEntityTypes.CBCFCValueObj>>();
        
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date '
                    //+ ' Part__r.Product_Hierarchy__r.CBC2__c cbc2, Part__r.Product_Hierarchy__r.CBC3__c cbc3 ');
                    );
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' Where Customer__c IN : set_acctIds ' 
                    //+ ClsAPLForecastUtil.getRelayPartQuery()  
                    + getRelayPartSearchQueryFilter(cbcCode, true) 
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_fiscalMonth)
                    + ' And Backlog_Amount_USD__c != 0 '
                    //update by nelson zheng 2015-10-21 for case 00900375
                    //+ ' And Profit_Center__c = \'RPA\'  '
                    //+ ' And (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  '
	              	+ ' And Profit_Center__c = \'APL\'  '
	              	
                    + ' Group by Customer_Request_Date_Fiscal_Date__c '
                    );

        system.debug('------------ClsAPLServiceRSMRelay.cls (21 matches) 15------------------');             
        system.debug('getCBCHistoryRefBacklogData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {

            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;

            fcViewObj = (ClsAPLEntityTypes.CBCFCValueObj) fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey);
        }

        for(String dateKey : list_dateKey) {
            AggregateResult result;
            fcViewObj = (ClsAPLEntityTypes.CBCFCValueObj) fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey);                    
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
                                            String year, Integer month, String cbcCode, list<String> list_dateKey, 
                                            ClsAPLEntityTypes.CBCFCValueObj fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(false, parentId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking '
                    //+ ' Part__r.Product_Hierarchy__r.CBC2__c cbc2, Part__r.Product_Hierarchy__r.CBC3__c cbc3 ');
                    );
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' Where Customer__c IN : set_acctIds ' 
                    //+ ClsAPLForecastUtil.getRelayPartQuery()  
                    + getRelayPartSearchQueryFilter(cbcCode, true) 
                    + ' And Fiscal_Year__c = \'' + year +'\''
                    + ' And Fiscal_Month__c = ' + month +
                    //update by nelson zheng 2015-10-21 for case 00900375
                    //+ ' And Profit_Center__c = \'RPA\'  '
                    //+ ' And (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  '
	              	+ ' And Profit_Center__c = \'APL\'  '
                    + ' And (Bill_Amount_USD__c != 0 or Book_Amount_USD__c != 0 or Backlog_Amount_USD__c != 0 ) '
                    );

        system.debug('------------ClsAPLServiceRSMRelay.cls (21 matches) 16------------------');             
        system.debug('getCBC2RefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        String dateKey = year + '_' + month;
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            //Date fiscal_date = (Date) result.get('fiscal_date');
            //String year = String.valueOf(fiscal_date.year());
            //String month = String.valueOf(fiscal_date.month());
            fcViewObj = (ClsAPLEntityTypes.CBCFCValueObj) fcViewObj.assignRefData(fcViewObj, result, dateKey, true);
        }

        //for(String dateKey : list_dateKey) {
        AggregateResult result;
        fcViewObj = (ClsAPLEntityTypes.CBCFCValueObj) fcViewObj.assignRefData(fcViewObj, result, dateKey, true);            
        //}

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
                                            map<String, set<Integer>> map_fiscalMonth, String cbcCode,
                                            list<String> list_dateKey, 
                                            ClsAPLEntityTypes.CBCFCValueObj fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(false, parentId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date '
                    //+ ' Part__r.Product_Hierarchy__r.CBC2__c cbc2, Part__r.Product_Hierarchy__r.CBC3__c cbc3 ');
                    );
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' Where Customer__c IN : set_acctIds ' 
                    //+ ClsAPLForecastUtil.getRelayPartQuery()  
                    + getRelayPartSearchQueryFilter(cbcCode, true) 
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_fiscalMonth)
                    + ' And (Bill_Amount_USD__c != 0 or Book_Amount_USD__c != 0 or Backlog_Amount_USD__c != 0 ) '
                    //update by nelson zheng 2015-10-21 for case 00900375
                    //+ ' And Profit_Center__c = \'RPA\'  '
                    //+ ' And (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  '
	              	+ ' And Profit_Center__c = \'APL\'  '
                    + ' Group by Customer_Request_Date_Fiscal_Date__c '
                    );

        system.debug('------------ClsAPLServiceRSMRelay.cls (21 matches) 17------------------');             
        system.debug('getCBC2RefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;

            fcViewObj = (ClsAPLEntityTypes.CBCFCValueObj) fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey);
        }

        for(String dateKey : list_dateKey) {
            AggregateResult result;
            fcViewObj = (ClsAPLEntityTypes.CBCFCValueObj) fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey);            
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
    public static void getPartHistoryRefData(String gplId, String parentId, decimal currencyRate, String territoryCode, 
                                            map<String, set<Integer>> map_year_monthsHistory,
                                            map<String, ClsAPLEntityTypes.RelayPartFCValueObj> map_partId_fcViewObj) {
                                                
        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(false, parentId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        //map<String, map<String, RelayFCCBCViewFields>> map_cbc2Name_map_dateKey_result = new map<String, map<String, RelayFCCBCViewFields>>();
        map<String, map<String, ClsAPLEntityTypes.RelayPartFCValueObj>> map_partId_map_dateKey_result = new map<String, map<String, ClsAPLEntityTypes.RelayPartFCValueObj>>();
        set<String> set_partIds = new set<String>();
        set_partIds.addAll(map_partId_fcViewObj.keySet());
        system.debug('set_partIds::: '+set_partIds);
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking, Fiscal_Date__c fiscal_date, '
                    + ' Part__c partId ');
        list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
        
        list_sql.add(' Where Customer__c IN : set_acctIds ' 
                    + ' And ( Bill_Amount_USD__c != 0 or Book_Amount_USD__c != 0 ) '
                    + getRelayPartSearchQueryFilter(gplId, true) 
                    + ' And Part__c IN : set_partIds '
                    //update by nelson zheng 2015-10-21 for case 00900375
                    //+ ' And Profit_Center__c = \'RPA\'  '
                    //+ ' And (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  '
	              	+ ' And Profit_Center__c = \'APL\'  '
                    + (ClsAPLForecastUtil.getFiscalMonthFilter(map_year_monthsHistory) == '' ? '' 
                            : ClsAPLForecastUtil.getFiscalMonthFilter(map_year_monthsHistory))
                    + ' Group by Fiscal_Date__c, Part__c '
                    );
        system.debug('------------ClsAPLServiceRSMRelay.cls (21 matches) 18------------------');             
                    
        if(map_partId_fcViewObj.isEmpty()) {
            return;
        }
        system.debug('getPartRefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String partId = (String) result.get('partId');
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;
            if(!map_partId_fcViewObj.containsKey(partId)) {
                map_partId_fcViewObj.put(partId, new ClsAPLEntityTypes.RelayPartFCValueObj());
            }            
            ClsAPLEntityTypes.RelayPartFCValueObj partFC = map_partId_fcViewObj.get(partId);
            partFC = (ClsAPLEntityTypes.RelayPartFCValueObj) partFC.assignRefData(partFC, result, dateKey, true);
        }
        system.debug('map_partId_fcViewObj::: '+map_partId_fcViewObj);
        //generate forecast view objects for each quarter
        for(String partId : map_partId_fcViewObj.keySet()) {
            for(String year : map_year_monthsHistory.keySet()) {
                for(Integer month : map_year_monthsHistory.get(year)) {
                    String dateKey = year + '_' + month;
                    AggregateResult result;    
                    ClsAPLEntityTypes.RelayPartFCValueObj fcObj = map_partId_fcViewObj.get(partId);
                    fcObj = fcObj.assignRefData(fcObj, result, dateKey, true);                    
                }
            }
        }
        system.debug('map_partId_fcViewObj::: '+map_partId_fcViewObj);
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
    public static void getPartHistoryRefBacklogData(String gplId, String parentId, decimal currencyRate, String territoryCode,
                                            String periodStartDate, String refStartDate,
                                            map<String, set<Integer>> map_year_monthsFuture,
                                            map<String, ClsAPLEntityTypes.RelayPartFCValueObj> map_partId_fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(false, parentId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        map<String, map<String, ClsAPLEntityTypes.RelayPartFCValueObj>> map_partId_map_dateKey_result = new map<String, map<String, ClsAPLEntityTypes.RelayPartFCValueObj>>();
        set<String> set_partIds = new set<String>();
        set_partIds.addAll(map_partId_fcViewObj.keySet());
        
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date, '
                    + ' Part__c partId');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' Where Customer__c IN : set_acctIds ' 
                    + getRelayPartSearchQueryFilter(gplId, true) 
                    + ' And Part__c IN : set_partIds '
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_year_monthsFuture)
                    + ' And Backlog_Amount_USD__c != 0 '
                    //update by nelson zheng 2015-10-21 for case 00900375
                    //+ ' And Profit_Center__c = \'RPA\'  '
                    //+ ' And (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  '
	              	+ ' And Profit_Center__c = \'APL\'  '
                    + ' Group by Customer_Request_Date_Fiscal_Date__c, Part__c '
                    );
        system.debug('------------ClsAPLServiceRSMRelay.cls (21 matches) 19------------------');             
        
        if(map_partId_fcViewObj.isEmpty()) {
            return;
        }
        system.debug('getCBC2RefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String partId = (String) result.get('partId');
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;
            if(!map_partId_fcViewObj.containsKey(partId)) {
                map_partId_fcViewObj.put(partId, new ClsAPLEntityTypes.RelayPartFCValueObj());
            }
            
            ClsAPLEntityTypes.RelayPartFCValueObj partFC = map_partId_fcViewObj.get(partId);
            partFC = (ClsAPLEntityTypes.RelayPartFCValueObj) partFC.assignHisBacklogRefData(partFC, result, dateKey);
        }
        system.debug('map_partId_fcViewObj::: '+map_partId_fcViewObj);
        //generate forecast view objects for each quarter
        for(String partId : map_partId_fcViewObj.keySet()) {
            for(String year : map_year_monthsFuture.keySet()) {
                for(Integer month : map_year_monthsFuture.get(year)) {
                    String dateKey = year + '_' + month;
                    AggregateResult result;    
                    ClsAPLEntityTypes.RelayPartFCValueObj fcObj = map_partId_fcViewObj.get(partId);
                    fcObj = fcObj.assignHisBacklogRefData(fcObj, result, dateKey);                    
                }
            }
        }
        system.debug('map_partId_fcViewObj::: '+map_partId_fcViewObj);
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
                                            map<String, ClsAPLEntityTypes.RelayPartFCValueObj> map_partId_fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(false, parentId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        map<String, map<String, ClsAPLEntityTypes.RelayPartFCValueObj>> map_partId_map_dateKey_result = new map<String, map<String, ClsAPLEntityTypes.RelayPartFCValueObj>>();
        set<String> set_partIds = new set<String>();
        set_partIds.addAll(map_partId_fcViewObj.keySet());
        
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking, '
                    + ' Part__c partId');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' Where Customer__c IN : set_acctIds ' 
                    + getRelayPartSearchQueryFilter(gplId, true) 
                    + ' And Part__c IN : set_partIds '
                    //+ ClsAPLForecastUtil.getCustomRequestMonthFilter(map_year_monthsFuture)
                    + ' And Fiscal_Year__c = \'' + year +'\''
                    + ' And Fiscal_Month__c = ' + month +
                    + ' And (Backlog_Amount_USD__c != 0  or Bill_Amount_USD__c != 0 or Book_Amount_USD__c != 0) '
                    //update by nelson zheng 2015-10-21 for case 00900375
                    //+ ' And Profit_Center__c = \'RPA\'  '
                    //+ ' And (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  '
	              	+ ' And Profit_Center__c = \'APL\'  '
                    + ' Group by Part__c '
                    );
        system.debug('------------ClsAPLServiceRSMRelay.cls (21 matches) 20------------------');             
        
        if(map_partId_fcViewObj.isEmpty()) {
            return;
        }
        system.debug('getCBC2RefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        String dateKey = year + '_' + month;
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String partId = (String) result.get('partId');
            //Date fiscal_date = (Date) result.get('fiscal_date');
            //String year = String.valueOf(fiscal_date.year());
            //String month = String.valueOf(fiscal_date.month());            
            if(!map_partId_fcViewObj.containsKey(partId)) {
                map_partId_fcViewObj.put(partId, new ClsAPLEntityTypes.RelayPartFCValueObj());
            }            
            ClsAPLEntityTypes.RelayPartFCValueObj partFC = map_partId_fcViewObj.get(partId);
            partFC = (ClsAPLEntityTypes.RelayPartFCValueObj) partFC.assignRefData(partFC, result, dateKey, true);
        }
        system.debug('map_partId_fcViewObj::: '+map_partId_fcViewObj);
        //generate forecast view objects for each quarter
        for(String partId : map_partId_fcViewObj.keySet()) {
            //for(String year : map_year_monthsFuture.keySet()) {
                //for(Integer month : map_year_monthsFuture.get(year)) {                    
                    AggregateResult result;    
                    ClsAPLEntityTypes.RelayPartFCValueObj fcObj = map_partId_fcViewObj.get(partId);
                    fcObj = fcObj.assignRefData(fcObj, result, dateKey, true);                    
                //}
            //}
        }
        system.debug('map_partId_fcViewObj::: '+map_partId_fcViewObj);
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
                                            map<String, ClsAPLEntityTypes.RelayPartFCValueObj> map_partId_fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setAccountIds(false, parentId, territoryCode, set_acctIds);

        list<String> list_sql = new list<String>();
        map<String, map<String, ClsAPLEntityTypes.RelayPartFCValueObj>> map_partId_map_dateKey_result = new map<String, map<String, ClsAPLEntityTypes.RelayPartFCValueObj>>();
        set<String> set_partIds = new set<String>();
        set_partIds.addAll(map_partId_fcViewObj.keySet());
        
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date, '
                    + ' Part__c partId');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' Where Customer__c IN : set_acctIds ' 
                    + getRelayPartSearchQueryFilter(gplId, true) 
                    + ' And Part__c IN : set_partIds '
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_year_monthsFuture)
                    + ' And (Backlog_Amount_USD__c != 0  or Bill_Amount_USD__c != 0 or Book_Amount_USD__c != 0) '
                    //update by nelson zheng 2015-10-21 for case 00900375
                    //+ ' And Profit_Center__c = \'RPA\'  '
                    //+ ' And (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))  '
	              	+ ' And Profit_Center__c = \'APL\'  '
                    + ' Group by Customer_Request_Date_Fiscal_Date__c, Part__c '
                    );
        system.debug('------------ClsAPLServiceRSMRelay.cls (21 matches) 21------------------');             
        
        if(map_partId_fcViewObj.isEmpty()) {
            return;
        }
        system.debug('getCBC2RefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String partId = (String) result.get('partId');
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;
            if(!map_partId_fcViewObj.containsKey(partId)) {
                map_partId_fcViewObj.put(partId, new ClsAPLEntityTypes.RelayPartFCValueObj());
            }
            
            ClsAPLEntityTypes.RelayPartFCValueObj partFC = map_partId_fcViewObj.get(partId);
            partFC = (ClsAPLEntityTypes.RelayPartFCValueObj) partFC.assignHisBacklogRefData(partFC, result, dateKey);
        }
        system.debug('map_partId_fcViewObj::: '+map_partId_fcViewObj);
        //generate forecast view objects for each quarter
        for(String partId : map_partId_fcViewObj.keySet()) {
            for(String year : map_year_monthsFuture.keySet()) {
                for(Integer month : map_year_monthsFuture.get(year)) {
                    String dateKey = year + '_' + month;
                    AggregateResult result;    
                    ClsAPLEntityTypes.RelayPartFCValueObj fcObj = map_partId_fcViewObj.get(partId);
                    fcObj = fcObj.assignHisBacklogRefData(fcObj, result, dateKey);                    
                }
            }
        }
        system.debug('map_partId_fcViewObj::: '+map_partId_fcViewObj);
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
    public static void saveOverRallFC(ClsAPLEntityTypes.RSMRelayOverRallInfo overRallInfo) {
        system.debug('overRallInfo::: '+overRallInfo);
        list<String> list_sql = new list<String>();
        set<String> set_displayNames = new set<String>();
        set<String> set_rsmIds = new set<String>();
        list<String> list_displayNames = new list<String>(overRallInfo.set_displayNames);
        set_displayNames.addAll(overRallInfo.set_displayNames);
        set_rsmIds.addAll(overRallInfo.set_rsmIds);
        map<String, APL_RSM_Overall_Forecast__c> map_dateKey_overRallFC = new map<String, APL_RSM_Overall_Forecast__c>();
        map<String,map<String, APL_RSM_Overall_Forecast__c>> map_name_dateKey_overRallFC = new map<String, map<String, APL_RSM_Overall_Forecast__c>>();
        list<APL_RSM_Overall_Forecast__c> list_overRallFC2Update = new list<APL_RSM_Overall_Forecast__c>();
        list<APL_RSM_Overall_Forecast__c> list_overRallFC2Insert = new list<APL_RSM_Overall_Forecast__c>();
        set<String> set_aplRSMId = new set<String>();
        map<String, String> map_rsmId_disName = new map<String, String>();
        list_sql.add(' Id, Display_Name__c ');
        list_sql.add(' APL_RSM__c ');
        /*
        list_sql.add(' Where Manager__c = \'' + overRallInfo.managerId + '\' '
                   + ' And APL_RSM__r.Display_Name__c IN : set_displayNames'
                   //+ ' And Type__c != \'AM\' '
                   );
        */
        list_sql.add(' Where Display_Name__c IN : set_displayNames '
                    + ' And Id IN : set_rsmIds '
                   );
        system.debug('ClsAPLForecastUtil.getQueryString(list_sql):::: '+ClsAPLForecastUtil.getQueryString(list_sql));
        for(APL_RSM__c rsm : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            set_aplRSMId.add(rsm.Id);
            map_rsmId_disName.put(rsm.Id, rsm.Display_Name__c);
        }
        
        if(set_aplRSMId.isEmpty()) {
            return;
        }
        list_sql.clear();
        list_sql.add(' Id, Relay_RSM_Overall_Forecast__c, RSM_Overall_Forecast__c, Fiscal_Year__c, Fiscal_Quarter__c, APL_RSM__r.Display_Name__c ');
        list_sql.add(' APL_RSM_Overall_Forecast__c ');
        /*
        list_sql.add(' WHERE APL_RSM__r.Manager__c = \'' + overRallInfo.managerId + '\' '
                    + ' And APL_RSM__r.Display_Name__c In : set_displayNames '
                    //+ ' And APL_RSM__r.Type__c != \'AM\' '
                    + ClsAPLForecastUtil.getMonthFilter(overRallInfo.map_year_quartersFuture) );
        */  
        list_sql.add(' WHERE APL_RSM__r.Display_Name__c In : set_displayNames '
                    + ' And APL_RSM__c IN : set_rsmIds '
                    //+ ' And APL_RSM__r.Type__c != \'AM\' '
                    + ClsAPLForecastUtil.getMonthFilter(overRallInfo.map_year_quartersFuture) );        
        system.debug('ClsAPLForecastUtil.getQueryString(list_sql):::: '+ClsAPLForecastUtil.getQueryString(list_sql));           
        for(APL_RSM_Overall_Forecast__c overRallFC : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String year = overRallFC.Fiscal_Year__c,
                   quarter = overRallFC.Fiscal_Quarter__c,
                   dateKey = year + '_' + quarter,
                   name = overRallFC.APL_RSM__r.Display_Name__c;
            if(!map_name_dateKey_overRallFC.containsKey(name)) {
                map_name_dateKey_overRallFC.put(name, new map<String, APL_RSM_Overall_Forecast__c>());
            }           
            map_name_dateKey_overRallFC.get(name).put(dateKey, overRallFC);
        }
        system.debug('map_name_dateKey_overRallFC::: '+map_name_dateKey_overRallFC);
        for(String rsmId : map_rsmId_disName.keySet()) {
            for(String year : overRallInfo.map_year_quartersFuture.keySet()) {
                for(String quarter : overRallInfo.map_year_quartersFuture.get(year)) {
                    String dateKey = year + '_' + quarter;
                    APL_RSM_Overall_Forecast__c overRallFC;
                    if(map_rsmId_disName.containsKey(rsmId) && !map_name_dateKey_overRallFC.containsKey(map_rsmId_disName.get(rsmId))) {
                        map_name_dateKey_overRallFC.put(map_rsmId_disName.get(rsmId), new map<String, APL_RSM_Overall_Forecast__c>());
                    }
                    
                    if(!map_name_dateKey_overRallFC.get(map_rsmId_disName.get(rsmId)).containsKey(dateKey)) {
                        overRallFC = new APL_RSM_Overall_Forecast__c();
                        overRallFC.CurrencyIsoCode = 'USD';
                        overRallFC.APL_RSM__c = rsmId;
                        //overRallFC.type__c = 'Relay';
                        overRallFC.Fiscal_Year__c = year;
                        overRallFC.Fiscal_Quarter__c = quarter;
                        if(map_rsmId_disName.containsKey(rsmId) &&  overRallInfo.map_name_map_dateKey_fc.containsKey(map_rsmId_disName.get(rsmId)) && 
                            overRallInfo.map_name_map_dateKey_fc.get(map_rsmId_disName.get(rsmId)).containsKey(dateKey) ) {
                            
                            overRallFC.Relay_RSM_Overall_Forecast__c = overRallInfo.map_name_map_dateKey_fc.get(map_rsmId_disName.get(rsmId)).get(dateKey);
                            overRallFC.RSM_Overall_Forecast__c = overRallFC.Relay_RSM_Overall_Forecast__c;
                        }
                        system.debug('overRallFC::: '+overRallFC);
                        
                        list_overRallFC2Insert.add(overRallFC);
                    }
                    else {
                        overRallFC = map_name_dateKey_overRallFC.get(map_rsmId_disName.get(rsmId)).get(dateKey);
                        if(map_rsmId_disName.containsKey(rsmId) &&  overRallInfo.map_name_map_dateKey_fc.containsKey(map_rsmId_disName.get(rsmId)) && 
                            overRallInfo.map_name_map_dateKey_fc.get(map_rsmId_disName.get(rsmId)).containsKey(dateKey) ) {
                            
                            overRallFC.Relay_RSM_Overall_Forecast__c = overRallInfo.map_name_map_dateKey_fc.get(map_rsmId_disName.get(rsmId)).get(dateKey);
                            overRallFC.RSM_Overall_Forecast__c = overRallFC.Relay_RSM_Overall_Forecast__c;
                        }
                        system.debug('overRallFC::: '+overRallFC);
                        list_overRallFC2Update.add(overRallFC);
                    }
                }
            }
        }
        system.debug('list_overRallFC2Update::: '+list_overRallFC2Update);
        system.debug('list_overRallFC2Insert::: '+list_overRallFC2Insert);
        system.debug('2962 size::: '+list_overRallFC2Update.size());
        system.debug('2965 size::: '+list_overRallFC2Insert.size());
        if(!list_overRallFC2Update.isEmpty()) {
            update list_overRallFC2Update;
        }
        if(!list_overRallFC2Insert.isEmpty()) {
            insert  list_overRallFC2Insert;
        }
    }

    //********************************* -=END public methods=- ************************************
     
    
    //********************************* -=BEGIN private methods=- *********************************
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************

    
}