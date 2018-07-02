public without sharing class ClsAPLServiceGAM extends ClsAPLInterface.AAPLCtrlService {
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
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
    public static void setRegionRow(list<ClsAPLEntityTypes.AcctColumns> list_acctColumns){
        
        list<ClsAPLEntityTypes.AcctColumns> list_t = new list<ClsAPLEntityTypes.AcctColumns> {
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_current_sales_forecast, 'currentFC', 'feve', '', false),
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_previous_sales_forecast, 'previousFC', '', '', false),
        //    new ClsAPLEntityTypes.AcctColumns(system.label.APL_AM_Sales_Forecast, 'amFC', '', 'feve', false),
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_total_billing, 'totalBilling', '', '', false),
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_total_booking, 'totalBooking', 'feve', '', false),
            new ClsAPLEntityTypes.AcctColumns(system.label.APL_total_backlog, 'totalBacklog', '', '', false)
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
    public static void getAcctTotalFCQuery(ClsAPLEntityTypes.PageConfig pageConf, 
                                            list<ClsAPLEntityTypes.TotalFCViewFields> list_totalFC) {
        list<String> list_amSQL = new list<String>();
        list<String> list_relaySQL = new list<String>();
        set<String> set_gamCodes = new set<String>();
        if(pageConf.set_gamCodes.isEmpty()) {
            return ;
        }
        set_gamCodes.addAll(pageConf.set_gamCodes);
        
        list_amSQL.add(' Fiscal_Year__c year, sum(GAM_Forecast__c) fc, Fiscal_Quarter__c quarter ');
        list_amSQL.add(' APL_Sales_Forecast__c ');
        list_amSQL.add(' WHERE Customer__r.GAMCD__c IN : set_gamCodes '
        			 + ' And Customer__r.STATDESC__c = \'Active\' '
                     + ' And (Type__c = \'' + ClsAPLForecastUtil.OTHERFCTYPE + '\' OR Type__c =\'' + ClsAPLForecastUtil.GPLFCTYPE + '\')'
                     + ClsAPLForecastUtil.getMonthFilter(pageConf.map_year_quartersFuture)
                     + ' Group by Fiscal_Year__c, Fiscal_Quarter__c ');
        
        
        list_relaySQL.add(' Fiscal_Year__c year, sum(Forecast__c) fc, Fiscal_Quarter__c quarter ');
        list_relaySQL.add(' APL_Sales_Forecast__c ');
        list_relaySQL.add(' WHERE Customer__r.GAMCD__c IN : set_gamCodes '
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
        ClsAPLEntityTypes.TotalFCViewFields relayFC = new ClsAPLEntityTypes.TotalFCViewFields(' trt_0 dn relayfctotal ');
        relayFC.fieldName = system.label.APL_Relay_Products;
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
    public static ClsAPLEntityTypes.GAMAcctInfo getAcctInfo(ClsAPLEntityTypes.PageConfig PageConf) {
        ClsAPLEntityTypes.GAMAcctInfo accInfo = new ClsAPLEntityTypes.GAMAcctInfo();
        set<String> set_GAMCodes = new set<String>(), 
                    set_acctIds = new set<String>(),
                    set_lv2TerritoryCodes = new set<String>();
        map<String, String> map_region_tmp = new map<String, String>();
        
        list<String> list_sql = new list<String>{
                                    ' GAM_Code__c, GAM_Freeze__c ', ' APL_Forecast_Management__c ', ' WHERE GAM_Code__c != null AND Manager__c = \''+PageConf.managerId+'\' and RecordTypeId != null '
                                };

        for(APL_Forecast_Management__c afm : Database.query(ClsAPLForecastUtil.getQueryString(list_sql))){
            set_GAMCodes.add(afm.GAM_Code__c);
            PageConf.isFrozen = afm.GAM_Freeze__c;
        }
        if(set_GAMCodes.isEmpty()) {
            return accInfo;
        }
        PageConf.set_gamCodes.addAll(set_GAMCodes);
        PageConf.json_setGAMCodes = Json.serialize(PageConf.set_gamCodes);
        set_lv2TerritoryCodes.addAll(ClsAPLForecastUtil.map_LV2TerritoryCode_Region.keySet());
        
        //add 2015-5-21 by Lei Tang<lei.tang@itbconsult.com> BEGIN
        list_sql.clear();
    	list_sql.add(' Customer__c accId, sum(GAM_Forecast__c) fc');
        list_sql.add(' APL_Sales_Forecast__c ');
        list_sql.add(' WHERE Customer__r.Territory_L2_code__c in : set_lv2TerritoryCodes ' 
        			+ ' And Customer__r.GAMCD__c in : set_GAMCodes '  
        			+ ' And Customer__r.RecordType.DeveloperName != \'Grouped Accounts\' '
                    + ' And (Type__c = \'' + ClsAPLForecastUtil.GPLFCTYPE + '\' '   
                    + ' OR Type__c = \'' + ClsAPLForecastUtil.OTHERFCTYPE + '\''
                    + ' OR Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' )' 
                    + ' And Fiscal_Year__c = \''+PageConf.currentYear+'\' '
                    + ' And Fiscal_Quarter__c =  \''+pageConf.quarterNumb.replace('Q','0')+'\' '
                    + ' And Customer__r.STATDESC__c = \'Active\' '
                    + ' Group by Customer__c ');
        system.debug('@#list_sql : '+ ClsAPLForecastUtil.getQueryString(list_sql));
    	map<String, decimal> map_accid_amount = new map<String, decimal>();
    	for(AggregateResult result : Database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String accId = (String)result.get('accId');
			map_accid_amount.put(accId, (result.get('fc') != null ? (decimal)result.get('fc') : 0));
        }
        //add 2015-5-21 by Lei Tang<lei.tang@itbconsult.com> END

        list_sql.clear();       //clear sql
        list_sql.add(' Territory_L2_code__c, Id, Account_Combined_Data__c, Customer_Region__c ');
        list_sql.add(' Account ');
        list_sql.add(' WHERE RecordType.DeveloperName != \'Grouped Accounts\' '
                   + ' AND GAMCD__c in :set_GAMCodes '
                   + ' And STATDESC__c = \'Active\' '
                   + ' And Territory_L2_code__c IN : set_lv2TerritoryCodes ');
        
        for(Account acct : Database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            set_acctIds.add(acct.Id);
            if(!map_region_tmp.containsKey(ClsAPLForecastUtil.map_LV2TerritoryCode_Region.get(acct.Territory_L2_code__c))) {        //add unique region
                accInfo.list_region.add(new ClsAPLEntityTypes.GAMRegionInfo(ClsAPLForecastUtil.map_LV2TerritoryCode_Region.get(acct.Territory_L2_code__c), acct.Id + '_cls', acct.Territory_L2_code__c));
                map_region_tmp.put(ClsAPLForecastUtil.map_LV2TerritoryCode_Region.get(acct.Territory_L2_code__c), acct.Id);
            }
            if(!accInfo.map_region_acct.containsKey(ClsAPLForecastUtil.map_LV2TerritoryCode_Region.get(acct.Territory_L2_code__c))) {
                accInfo.map_region_acct.put(ClsAPLForecastUtil.map_LV2TerritoryCode_Region.get(acct.Territory_L2_code__c), new list<ClsAPLEntityTypes.RegionAccountInfo>());
            }
            list<ClsAPLEntityTypes.RegionAccountInfo> list_temp_regionacc = accInfo.map_region_acct.get(ClsAPLForecastUtil.map_LV2TerritoryCode_Region.get(acct.Territory_L2_code__c));
            ClsAPLEntityTypes.RegionAccountInfo regionacc = new ClsAPLEntityTypes.RegionAccountInfo(acct.Id, acct.Account_Combined_Data__c);
            if(map_accid_amount.containsKey(acct.Id)) {
            	regionacc.csFCamount = map_accid_amount.get(acct.Id);
            }
            list_temp_regionacc.add(regionacc);
            list_temp_regionacc.sort();
            accInfo.map_region_acct.put(ClsAPLForecastUtil.map_LV2TerritoryCode_Region.get(acct.Territory_L2_code__c), list_temp_regionacc);
            
        }
    	
    	
    	
    	
    	
        return accInfo;
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
    public static ClsAPLEntityTypes.AcctFCResults getGAMRegionFC(ClsAPLEntityTypes.GAMRegionFCInfo gamRegion) {
        
        ClsAPLEntityTypes.AcctFCResults acctFCResult = new ClsAPLEntityTypes.AcctFCResults();
        list<String> list_sql = new list<String>();
        ClsAPLEntityTypes.AcctFCValueObj regionFC = new ClsAPLEntityTypes.AcctFCValueObj();
        map<String, map<String, AggregateResult>> map_territoryCode_map_dateKey_result =
            new map<String, map<String, AggregateResult>>();
        set<String> set_gamCodes = new set<String>();
        set_gamCodes.addAll(gamRegion.set_gamCodes);
        
        list_sql.add(' Fiscal_Year__c year, sum(GAM_Forecast__c) fc, sum(Forecast__c) amFC, ' 		//, sum(POS_Forecast__c) posFC  sum(CMA_Forecast__c) cmaFC,
                    + '  sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter ');
                    
        list_sql.add(' APL_Sales_Forecast__c ');
        list_sql.add(' WHERE Customer__r.Territory_L2_code__c = \'' + gamRegion.level2TerritoryCode + '\' ' 
                    + ' And (Type__c = \'' + ClsAPLForecastUtil.GPLFCTYPE + '\' '   
                    + ' OR Type__c = \'' + ClsAPLForecastUtil.OTHERFCTYPE + '\''
                    + ' OR Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\')'
                    + ' And Customer__r.GAMCD__c in : set_gamCodes '
                    + ' And Customer__r.STATDESC__c = \'Active\' '
                    + ClsAPLForecastUtil.getMonthFilter(gamRegion.map_year_quartersFuture) +
                    ' Group by Fiscal_Year__c, Fiscal_Quarter__c ');
        //Generate forecast view object
        system.debug('getGAMAcctFC query :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        for(AggregateResult result : Database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String territoryCode = gamRegion.level2TerritoryCode, 
                   year = (String) result.get('year'),
                   quarter = (String) result.get('quarter'), 
                   dateKey = (year + '_' + quarter);
                   
            ClsAPLForecastUtil.setResultMap(result, territoryCode, dateKey, map_territoryCode_map_dateKey_result);
        }
        for(String year : gamRegion.map_year_quartersFuture.keySet()) {
            for(String quarter : gamRegion.map_year_quartersFuture.get(year)) {
                
                String dateKey = (year + '_' + quarter);
                AggregateResult result;
                
                if(map_territoryCode_map_dateKey_result.containsKey(gamRegion.level2TerritoryCode) 
                    && map_territoryCode_map_dateKey_result.get(gamRegion.level2TerritoryCode).containsKey(dateKey)) {
                    
                    result = map_territoryCode_map_dateKey_result.get(gamRegion.level2TerritoryCode).get(dateKey);
                }
                
                regionFC = (ClsAPLEntityTypes.AcctFCValueObj) regionFC.assignFCValues(regionFC, result, dateKey);
            }
        }

        //prepare result
        acctFCResult.json_result = Json.serialize(regionFC);
        return acctFCResult;
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
    public static ClsAPLEntityTypes.AcctFCResults getGAMRegionRefData(ClsAPLEntityTypes.GAMRegionFCInfo gamRegion) {
        ClsAPLEntityTypes.AcctFCResults acctFCResult = new ClsAPLEntityTypes.AcctFCResults();
        //Get Region reference data 
        ClsAPLEntityTypes.AcctFCValueObj regionFC = new ClsAPLEntityTypes.AcctFCValueObj();
        if(gamRegion.map_year_monthsHistory != null && !gamRegion.map_year_monthsHistory.isEmpty()) {
            getRegionHistoryRefData(gamRegion.level2TerritoryCode, gamRegion.set_gamCodes, gamRegion.map_year_monthsHistory, regionFC);   
        }
        if(gamRegion.refStartDate != null && gamRegion.periodStartDate != null) {
            getRegionHisBacklogRefData(gamRegion.level2TerritoryCode, gamRegion.set_gamCodes, gamRegion.periodStartDate, gamRegion.refStartDate, 
                                    gamRegion.map_year_monthsHistory, regionFC);
        }
        if(gamRegion.refStartDate != null && gamRegion.refEndDate != null) {
        	getRegionCurrentRefData(gamRegion.level2TerritoryCode, gamRegion.set_gamCodes,
                                   gamRegion.currentYear, Integer.valueOf(gamRegion.currentMonth), regionFC);
            getRegionFutureRefData(gamRegion.level2TerritoryCode, gamRegion.set_gamCodes, gamRegion.refStartDate, gamRegion.refEndDate, 
                                    gamRegion.map_year_monthsFuture, regionFC);
        }
        //prepare result
        acctFCResult.json_result = Json.serialize(regionFC);
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
    public static void getRegionHistoryRefData(String territoryCode, set<String> set_gamCodes,
                                            map<String, set<Integer>> map_year_monthsHistory,
                                            ClsAPLEntityTypes.AcctFCValueObj fcViewObj) {
        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setGAMAccountIds(territoryCode, set_gamCodes, set_acctIds);
		                                        
        list<String> list_sql = new list<String>();
        map<String, map<String, AggregateResult>> map_territoryCode_map_dateKey_result = new map<String, map<String, AggregateResult>>();
        set<String> set_tempGamCodes = new set<String>();
        set_tempGamCodes.addAll(set_gamCodes);
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking, Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
        
        list_sql.add(' Where Customer__c IN : set_acctIds '
                    + (ClsAPLForecastUtil.getFiscalMonthFilter(map_year_monthsHistory) == '' ? '' 
                            : ClsAPLForecastUtil.getFiscalMonthFilter(map_year_monthsHistory))
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0 ) '
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + 'Group by Fiscal_Date__c ' );

        system.debug('getRegionHistoryRefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;
            
            ClsAPLForecastUtil.setResultMap(result, territoryCode, dateKey, map_territoryCode_map_dateKey_result);
        }
        //generate forecast view objects for each quarter
        for(String year : map_year_monthsHistory.keySet()) {
            for(Integer month : map_year_monthsHistory.get(year)) {
                String dateKey = year + '_' + month;
                AggregateResult result;
                if(map_territoryCode_map_dateKey_result.containsKey(territoryCode) && map_territoryCode_map_dateKey_result.get(territoryCode).containsKey(dateKey)) {
                    result = map_territoryCode_map_dateKey_result.get(territoryCode).get(dateKey);
                }
                fcViewObj = fcViewObj.assignRefData(fcViewObj, result, dateKey, true);
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
    public static void getRegionHisBacklogRefData(String territoryCode, set<String> set_gamCodes,
                                            String backlogStartDate, String backlogEndDate,
                                            map<String, set<Integer>> map_year_monthsFuture,
                                            ClsAPLEntityTypes.AcctFCValueObj fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setGAMAccountIds(territoryCode, set_gamCodes, set_acctIds);

        list<String> list_sql = new list<String>();
        map<String, map<String, AggregateResult>> map_territoryCode_map_dateKey_result 
                            = new map<String, map<String, AggregateResult>>();
        set<String> set_tempGamCodes = new set<String>();
        set_tempGamCodes.addAll(set_gamCodes);
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' Where Customer__C IN : set_acctIds '
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_year_monthsFuture)
                    + ' And Backlog_Amount_USD__c != 0 '
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + 'Group by Customer_Request_Date_Fiscal_Date__c ' );
                    
        system.debug('getRegionHisBacklogRefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;
            ClsAPLForecastUtil.setResultMap(result, territoryCode, dateKey, map_territoryCode_map_dateKey_result);
        }
        //generate forecast view objects for each quarter
        for(String year : map_year_monthsFuture.keySet()) {
            for(Integer month : map_year_monthsFuture.get(year)) {
                String dateKey = year + '_' + month;
                AggregateResult result;
                if(map_territoryCode_map_dateKey_result.containsKey(territoryCode) && map_territoryCode_map_dateKey_result.get(territoryCode).containsKey(dateKey)) {
                    result = map_territoryCode_map_dateKey_result.get(territoryCode).get(dateKey);
                }
                
                fcViewObj = fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey);
                
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
    public static void getRegionCurrentRefData(String territoryCode, set<String> set_gamCodes,
                                            String year, Integer month,
                                            ClsAPLEntityTypes.AcctFCValueObj fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setGAMAccountIds(territoryCode, set_gamCodes, set_acctIds);

        list<String> list_sql = new list<String>();
        map<String, map<String, AggregateResult>> map_territoryCode_map_dateKey_result 
                            = new map<String, map<String, AggregateResult>>();
        set<String> set_tempGamCodes = new set<String>();
        set_tempGamCodes.addAll(set_gamCodes);
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' Where  Customer__C IN : set_acctIds '
                    + ' And Fiscal_Year__c = \'' + year +'\''
                    + ' And Fiscal_Month__c = ' + month +
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0 ) '); 
                    
        system.debug('getRegionCurrentRefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        String dateKey = year + '_' + month;
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            ClsAPLForecastUtil.setResultMap(result, territoryCode, dateKey, map_territoryCode_map_dateKey_result);
        }
        //generate forecast view objects for each quarter
        AggregateResult result;
        if(map_territoryCode_map_dateKey_result.containsKey(territoryCode) && map_territoryCode_map_dateKey_result.get(territoryCode).containsKey(dateKey)) {
            result = map_territoryCode_map_dateKey_result.get(territoryCode).get(dateKey);
        }
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
    public static void getRegionFutureRefData(String territoryCode, set<String> set_gamCodes,
                                            String refStartDate, String refEndDate,
                                            map<String, set<Integer>> map_year_monthsFuture,
                                            ClsAPLEntityTypes.AcctFCValueObj fcViewObj) {

        //get children account ids first
        set<String> set_acctIds = new set<String>();
		ClsAPLForecastUtil.setGAMAccountIds(territoryCode, set_gamCodes, set_acctIds);

        list<String> list_sql = new list<String>();
        map<String, map<String, AggregateResult>> map_territoryCode_map_dateKey_result 
                            = new map<String, map<String, AggregateResult>>();
        set<String> set_tempGamCodes = new set<String>();
        set_tempGamCodes.addAll(set_gamCodes);
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' Where  Customer__C IN : set_acctIds '
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_year_monthsFuture)
                    + ' And Backlog_Amount_USD__c != 0 '
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + 'Group by Customer_Request_Date_Fiscal_Date__c ' );
                    
        system.debug('getRegionFutureRefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        //get cbc2 forecast for all cbc2
        for(AggregateResult result : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            Date fiscal_date = (Date) result.get('fiscal_date');
            String year = String.valueOf(fiscal_date.year());
            String month = String.valueOf(fiscal_date.month());
            String dateKey = year + '_' + month;
            ClsAPLForecastUtil.setResultMap(result, territoryCode, dateKey, map_territoryCode_map_dateKey_result);
        }
        //generate forecast view objects for each quarter
        for(String year : map_year_monthsFuture.keySet()) {
            for(Integer month : map_year_monthsFuture.get(year)) {
                String dateKey = year + '_' + month;
                AggregateResult result;
                if(map_territoryCode_map_dateKey_result.containsKey(territoryCode) && map_territoryCode_map_dateKey_result.get(territoryCode).containsKey(dateKey)) {
                    result = map_territoryCode_map_dateKey_result.get(territoryCode).get(dateKey);
                }
                fcViewObj = fcViewObj.assignHisBacklogRefData(fcViewObj, result, dateKey);
            }
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
    public static ClsAPLEntityTypes.AcctFCResults getGAMAcctFC(ClsAPLEntityTypes.GAMAcctFCInfo gamAcct) {
        
        ClsAPLEntityTypes.AcctFCResults acctFCResult = new ClsAPLEntityTypes.AcctFCResults();
        list<String> list_sql = new list<String>();
        set<String> set_acctIds = new set<String>();
        set_acctIds.addAll(gamAcct.set_acctIds);
        map<String, ClsAPLEntityTypes.AcctFCValueObj> map_acctId_acctFC = new map<String, ClsAPLEntityTypes.AcctFCValueObj>();
        map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result =
            new map<String, map<String, AggregateResult>>();
        list_sql.add(' Customer__c accId, Fiscal_Year__c year, sum(GAM_Forecast__c) fc, ' 		//, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
                    + ' sum(Forecast__c) amFC, sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter ');
                    
        list_sql.add(' APL_Sales_Forecast__c ');
        list_sql.add(' WHERE Customer__c in : set_acctIds ' 
                    + ' And (Type__c = \'' + ClsAPLForecastUtil.GPLFCTYPE + '\' '   
                    + ' OR Type__c = \'' + ClsAPLForecastUtil.OTHERFCTYPE + '\''
                    + ' OR Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\')'
                    + ClsAPLForecastUtil.getMonthFilter(gamAcct.map_year_quartersFuture) 
                    + ' And Customer__r.STATDESC__c = \'Active\' '
                    + ' Group by Fiscal_Year__c, Fiscal_Quarter__c, Customer__c ');
        //Generate forecast view object
        system.debug('getGAMAcctFC query :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        for(AggregateResult result : Database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String accId = (String)result.get('accId'), 
                   year = (String) result.get('year'),
                   quarter = (String) result.get('quarter'), 
                   dateKey = (year + '_' + quarter);
                   
            ClsAPLForecastUtil.setResultMap(result, accId, dateKey, map_acctId_map_dateKey_result);
        }
        
        for(String acctId : set_acctIds) {
            for(String year : gamAcct.map_year_quartersFuture.keySet()) {
                for(String quarter : gamAcct.map_year_quartersFuture.get(year)) {
                    
                    String dateKey = (year + '_' + quarter);
                    AggregateResult result;
                    
                    if(map_acctId_map_dateKey_result.containsKey(acctId) 
                        && map_acctId_map_dateKey_result.get(acctId).containsKey(dateKey)) {
                        
                        result = map_acctId_map_dateKey_result.get(acctId).get(dateKey);
                    }
                    
                    if(!map_acctId_acctFC.containsKey(acctId)) {
                        ClsAPLEntityTypes.AcctFCValueObj acctFC = new ClsAPLEntityTypes.AcctFCValueObj();
                        acctFC.acctId = acctId;
                        map_acctId_acctFC.put(acctId, acctFC);
                    }
                    ClsAPLEntityTypes.AcctFCValueObj acctFC = map_acctId_acctFC.get(acctId);
                    acctFC = (ClsAPLEntityTypes.AcctFCValueObj) acctFC.assignFCValues(acctFC, result, dateKey);
                    
                }
            }
        }
        //prepare result
        list<ClsAPLEntityTypes.AcctFCValueObj> list_fcObj = new list<ClsAPLEntityTypes.AcctFCValueObj>();
        list_fcObj.addAll(map_acctId_acctFC.values());
        acctFCResult.json_result = Json.serialize(list_fcObj);
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
    public static ClsAPLEntityTypes.AcctFCResults getGAMAcctRefData(ClsAPLEntityTypes.GAMAcctFCInfo gamAcct) {
        ClsAPLEntityTypes.AcctFCResults result = new ClsAPLEntityTypes.AcctFCResults();
        String startDate = ClsAPLForecastUtil.getStartDate(gamAcct.list_dateKey[0]),
               endDate = ClsAPLForecastUtil.getEndDate(gamAcct.list_dateKey[2]);
               
        Integer startYear = Integer.valueOf(startDate.subStringBefore('-')), 
               startMonth = Integer.valueOf(startDate.subStringBetween('-', '-')), 
               endYear = Integer.valueOf(endDate.subStringBefore('-')), 
               endMonth = Integer.valueOf(endDate.subStringBetween('-', '-')), 
               currentYear = Integer.valueOf(gamAcct.currentYear),
               currentMonth = Integer.valueOf(gamAcct.currentMonth); 
        map<String, set<Integer>> map_fiscalMonth = ClsAPLForecastUtil.getFiscalMonthMap(gamAcct.list_dateKey);
        system.debug('start date :: ' + startDate);
        system.debug('end date :: ' + endDate);
        ClsAPLEntityTypes.AcctFCValueObj fcViewObj = new ClsAPLEntityTypes.AcctFCValueObj();
        Date date_endDate = Date.newInstance(endYear, endMonth, 1);
        Date date_currentDate = Date.newInstance(currentYear, currentMonth, 1);
        Date date_startDate = Date.newInstance(startYear, startMonth, 1);
        
        if(date_endDate < date_currentDate) {
            getAcctHistoryRefData(gamAcct.acctId, startDate, endDate, 
                                    gamAcct.list_dateKey, fcViewObj);
            getAcctHisBacklogRefData(gamAcct.acctId, startDate, endDate, map_fiscalMonth, 
                                    gamAcct.list_dateKey, fcViewObj);
        }
        else if(date_currentDate < date_startDate) {
            getAcctFutureRefData(gamAcct.acctId, startDate, endDate, map_fiscalMonth,
                                    gamAcct.list_dateKey, fcViewObj);
        }
        else {
            String currentEndDate =  ClsAPLForecastUtil.getEndDate(gamAcct.currentYear + '_' + gamAcct.currentMonth);
            map<String, set<Integer>> map_history = new map<String, set<Integer>>();
            map<String, set<Integer>> map_future = new map<String, set<Integer>>();
            ClsAPLForecastUtil.getDividedFiscalMap(date_currentDate, gamAcct.list_dateKey, map_history, map_future);
            
            getAcctHistoryRefData(gamAcct.acctId, startDate, currentEndDate, 
                                    gamAcct.list_dateKey, fcViewObj);
            if(!map_history.isEmpty()) {
                getAcctHisBacklogRefData(gamAcct.acctId, startDate, currentEndDate, map_history,
                                        gamAcct.list_dateKey, fcViewObj);
            }
            if(!map_future.isEmpty()) {
            	getAcctCurrentRefData(gamAcct.acctId, gamAcct.currentYear, Integer.valueOf(gamAcct.currentMonth),
                                       fcViewObj);
                getAcctFutureRefData(gamAcct.acctId, currentEndDate, endDate, map_future,
                                        gamAcct.list_dateKey, fcViewObj);
            }
        }
        
        fcViewObj.cls = String.join(gamAcct.list_dateKey, ',');
        result.json_result = Json.serialize(fcViewObj);                     
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
    public static void getAcctHistoryRefData(String parentId,String startDate, String endDate,
                                            list<String> list_dateKey,
                                            ClsAPLEntityTypes.AcctFCValueObj fcViewObj) {

                                                
        list<String> list_sql = new list<String>();
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking, Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
        list_sql.add(' Where Customer__c = \'' + parentId + '\' '
                    + ' And Fiscal_Date__c >= ' + startDate
                    + ' And Fiscal_Date__c < ' + endDate
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' And Customer__r.STATDESC__c = \'Active\' '
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
    public static void getAcctHisBacklogRefData(String parentId, String startDate, String endDate, 
                                                map<String, set<Integer>> map_fiscalMonth, list<String> list_dateKey,
                                                ClsAPLEntityTypes.AcctFCValueObj fcViewObj) {
        list<String> list_sql = new list<String>();
        
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' Where Customer__c = \'' + parentId + '\' '
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_fiscalMonth)
                    + ' And Backlog_Amount_USD__c != 0 '
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' And Customer__r.STATDESC__c = \'Active\' '
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
    public static void getAcctCurrentRefData(String parentId, String year, Integer month,
                                            ClsAPLEntityTypes.AcctFCValueObj fcViewObj) {
        list<String> list_sql = new list<String>();
        
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' Where Customer__c = \'' + parentId + '\' '
                    + ' And Fiscal_Year__c = \'' + year +'\''
                    + ' And Fiscal_Month__c = ' + month +
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' And Customer__r.STATDESC__c = \'Active\' '
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0)' );
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
    public static void getAcctFutureRefData(String parentId, String startDate, String endDate,
                                            map<String, set<Integer>> map_fiscalMonth, list<String> list_dateKey,
                                            ClsAPLEntityTypes.AcctFCValueObj fcViewObj) {
        list<String> list_sql = new list<String>();
        
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' Where Customer__c = \'' + parentId + '\' '
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_fiscalMonth)
                    + ' And Backlog_Amount_USD__c != 0 '
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' And Customer__r.STATDESC__c = \'Active\' '
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
    public static ClsAPLEntityTypes.AcctFCResults getGAMCBCFC(ClsAPLEntityTypes.GAMCBCFCInfo gamCBC) {
        
        ClsAPLEntityTypes.AcctFCResults acctFCResult = new ClsAPLEntityTypes.AcctFCResults();
        
        list<String> list_sql = new list<String>();
        map<String, ClsAPLEntityTypes.CBCFCValueObj> map_cbcKey_cbcFC = new map<String, ClsAPLEntityTypes.CBCFCValueObj>();
        map<String, map<String, AggregateResult>> map_cbcName_map_dateKey_result =
            new map<String, map<String, AggregateResult>>();
        list_sql.add(' Fiscal_Year__c year, sum(GAM_Forecast__c) fc,  ' 		//, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
                    + ' sum(Forecast__c) amFC, sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter, '
                    + '  GPL__r.CBC2__c cbc2Name, GPL__r.CBC3__c cbc3Name  ');
                    
        list_sql.add(' APL_Sales_Forecast__c ');
        list_sql.add(' WHERE Customer__c = \'' + gamCBC.acctId + '\' '
                    + ' AND  (Type__c = \'GPL\' ' 
                    + ' OR Type__c = \'' + ClsAPLForecastUtil.OTHERFCTYPE + '\')'
                    + ' And Customer__r.STATDESC__c = \'Active\' '
                    + ClsAPLForecastUtil.getMonthFilter(gamCBC.map_year_quartersFuture) +
                    ' Group by Fiscal_Year__c, Fiscal_Quarter__c, GPL__r.CBC2__c, GPL__r.CBC3__c ');
        
        list<String> list_relaysql = new list<String>(); 
        list_relaysql.add(' Fiscal_Year__c year, sum(GAM_Forecast__c) fc,  ' 		//, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
                    + ' sum(Forecast__c) amFC, sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter ');
        list_relaysql.add(' APL_Sales_Forecast__c ');
        list_relaysql.add(' WHERE Customer__c = \'' + gamCBC.acctId + '\' '
                    + ' AND Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' ' 
                    +   APL_ClsUtils.getRelayCBC2CodeQuery()
                    + ' And Customer__r.STATDESC__c = \'Active\' '
                    + ClsAPLForecastUtil.getMonthFilter(gamCBC.map_year_quartersFuture) +
                    ' Group by Fiscal_Year__c, Fiscal_Quarter__c ');            
        
        //Generate forecast view result
        system.debug('gamCBC :: ' + gamCBC);
        system.debug('getGAMCBCFC query :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        for(AggregateResult  result : Database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String year = (String) result.get('year'),
                   quarter = (String) result.get('quarter'), 
                   dateKey = (year + '_' + quarter),
                   cbc2 = (String) (result.get('cbc2Name') == null ? '' : result.get('cbc2Name')),
                   cbc3 = (String) (result.get('cbc3Name') == null ? '' : result.get('cbc3Name')),
                   cbcName = ClsAPLForecastUtil.getCBCKeyName(cbc2, cbc3);
            
            
            if(!map_cbcKey_cbcFC.containsKey(cbcName)) {
                ClsAPLEntityTypes.CBCFCValueObj cbcFC = new ClsAPLEntityTypes.CBCFCValueObj();
                
                cbcFC.fieldName = gamCBC.map_cbcRowKey_cbcName.get(cbcName);
                cbcFC.gamTypeName = (cbcName == ClsAPLForecastUtil.CBCOTHER ? 'ClsAPLEntityTypes.GAMPartFCInfo' : cbcFC.gamTypeName);
                map_cbcKey_cbcFC.put(cbcName, cbcFC);
            }
            ClsAPLEntityTypes.CBCFCValueObj cbcFC = map_cbcKey_cbcFC.get(cbcName);
            cbcFC = (ClsAPLEntityTypes.CBCFCValueObj) cbcFC.assignFCValues(cbcFC, result, dateKey);
        }
        
        for(AggregateResult  result : Database.query(ClsAPLForecastUtil.getQueryString(list_relaysql))) {
            String year = (String) result.get('year'),
                   quarter = (String) result.get('quarter'), 
                   dateKey = (year + '_' + quarter),
                   //cbc2 = (String) (result.get('cbc2Name') == null ? '' : result.get('cbc2Name')),
                   //cbc3 = (String) (result.get('cbc2Name') == null ? '' : result.get('cbc2Name')),
                   cbcName = 'Relay';//ClsAPLForecastUtil.getCBCKeyName(cbc2, cbc3);
            
            
            if(!map_cbcKey_cbcFC.containsKey(cbcName)) {
                ClsAPLEntityTypes.CBCFCValueObj cbcFC = new ClsAPLEntityTypes.CBCFCValueObj();
                
                cbcFC.fieldName = gamCBC.map_cbcRowKey_cbcName.get(cbcName);
                cbcFC.gamTypeName = (cbcName == ClsAPLForecastUtil.CBCOTHER ? 'ClsAPLEntityTypes.GAMPartFCInfo' : cbcFC.gamTypeName);
                map_cbcKey_cbcFC.put(cbcName, cbcFC);
            }
            ClsAPLEntityTypes.CBCFCValueObj cbcFC = map_cbcKey_cbcFC.get(cbcName);
            cbcFC = (ClsAPLEntityTypes.CBCFCValueObj) cbcFC.assignFCValues(cbcFC, result, dateKey);
        }
        
        //build map for all the cbcs & quarters
        for(String cbcKey : gamCBC.map_cbcRowKey_cbcName.keySet()) {
            for(String year : gamCBC.map_year_quartersFuture.keySet()) {
                for(String quarter : gamCBC.map_year_quartersFuture.get(year)) {
                    
                    String dateKey = (year + '_' + quarter);
                    AggregateResult result;
                    
                    if(!map_cbcKey_cbcFC.containsKey(cbcKey)) {
                        ClsAPLEntityTypes.CBCFCValueObj cbcFC = new ClsAPLEntityTypes.CBCFCValueObj();
                        
                        cbcFC.fieldName = gamCBC.map_cbcRowKey_cbcName.get(cbcKey);
                        cbcFC.gamTypeName = (cbcKey == ClsAPLForecastUtil.CBCOTHER ? 'ClsAPLEntityTypes.GAMPartFCInfo' : cbcFC.gamTypeName);
                        map_cbcKey_cbcFC.put(cbcKey, cbcFC);
                    }
                    ClsAPLEntityTypes.CBCFCValueObj cbcFC = map_cbcKey_cbcFC.get(cbcKey);
                    cbcFC = (ClsAPLEntityTypes.CBCFCValueObj) cbcFC.assignFCValues(cbcFC, result, dateKey);
                }
            }
        }
        //Get cbc reference data 
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
    public static ClsAPLEntityTypes.AcctFCResults getGAMCBCRefData(ClsAPLEntityTypes.GAMCBCFCInfo gamCBC) {
        ClsAPLEntityTypes.AcctFCResults result = new ClsAPLEntityTypes.AcctFCResults();
        String startDate = ClsAPLForecastUtil.getStartDate(gamCBC.list_dateKey[0]),
               endDate = ClsAPLForecastUtil.getEndDate(gamCBC.list_dateKey[2]);
               
        Integer startYear = Integer.valueOf(startDate.subStringBefore('-')), 
               startMonth = Integer.valueOf(startDate.subStringBetween('-', '-')), 
               endYear = Integer.valueOf(endDate.subStringBefore('-')), 
               endMonth = Integer.valueOf(endDate.subStringBetween('-', '-')), 
               currentYear = Integer.valueOf(gamCBC.currentYear),
               currentMonth = Integer.valueOf(gamCBC.currentMonth); 
        map<String, set<Integer>> map_fiscalMonth = ClsAPLForecastUtil.getFiscalMonthMap(gamCBC.list_dateKey);
        system.debug('start date :: ' + startDate);
        system.debug('end date :: ' + endDate);
        ClsAPLEntityTypes.CBCFCValueObj fcViewObj = new ClsAPLEntityTypes.CBCFCValueObj();
        Date date_endDate = Date.newInstance(endYear, endMonth, 1);
        Date date_currentDate = Date.newInstance(currentYear, currentMonth, 1);
        Date date_startDate = Date.newInstance(startYear, startMonth, 1);
        
        if(date_endDate < date_currentDate) {
            getCBCHistoryRefData(gamCBC.acctId, gamCBC.cbcCode, startDate, endDate, 
                                    gamCBC.list_dateKey, fcViewObj);
            getCBCHisBacklogRefData(gamCBC.acctId, gamCBC.cbcCode, startDate, endDate, map_fiscalMonth, 
                                    gamCBC.list_dateKey, fcViewObj);
        }
        else if(date_currentDate < date_startDate) {
            getCBCFutureRefData(gamCBC.acctId, gamCBC.cbcCode, startDate, endDate, map_fiscalMonth,
                                    gamCBC.list_dateKey, fcViewObj);
        }
        else {
            String currentEndDate =  ClsAPLForecastUtil.getEndDate(gamCBC.currentYear + '_' + gamCBC.currentMonth);
            map<String, set<Integer>> map_history = new map<String, set<Integer>>();
            map<String, set<Integer>> map_future = new map<String, set<Integer>>();
            ClsAPLForecastUtil.getDividedFiscalMap(date_currentDate, gamCBC.list_dateKey, map_history, map_future);
            
            getCBCHistoryRefData(gamCBC.acctId, gamCBC.cbcCode, startDate, currentEndDate, 
                                    gamCBC.list_dateKey, fcViewObj);
            if(!map_history.isEmpty()) {
                getCBCHisBacklogRefData(gamCBC.acctId, gamCBC.cbcCode, startDate, currentEndDate, map_history,
                                        gamCBC.list_dateKey, fcViewObj);
            }
            if(!map_future.isEmpty()) {
            	getCBCCurrentRefData(gamCBC.acctId, gamCBC.cbcCode, gamCBC.currentYear, Integer.valueOf(gamCBC.currentMonth),
                                     fcViewObj);
                getCBCFutureRefData(gamCBC.acctId, gamCBC.cbcCode, currentEndDate, endDate, map_future,
                                        gamCBC.list_dateKey, fcViewObj);
            }
        }
        
        fcViewObj.cls = String.join(gamCBC.list_dateKey, ',');
        fcViewObj.fieldName = gamCBC.cbcCode;
        result.json_result = Json.serialize(fcViewObj);                     
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
    public static void getCBCHistoryRefData(String parentId, String cbcCode,
                                            String startDate, String endDate,
                                            list<String> list_dateKey,
                                            ClsAPLEntityTypes.CBCFCValueObj fcViewObj) {
                                                
        list<String> list_sql = new list<String>();
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking, Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
        list_sql.add(' Where Customer__c = \'' + parentId + '\' '
                    + (cbcCode == ClsAPLForecastUtil.CBCOTHER ? ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\'', '') : '')
                    + (cbcCode == ClsAPLForecastUtil.CBCRELAY ? ClsAPLForecastUtil.getRelayPartQuery() : '')
                    + ((cbcCode != ClsAPLForecastUtil.CBCOTHER && cbcCode != ClsAPLForecastUtil.CBCRELAY) 
                                    ? 'And Part__r.Product_Hierarchy__r.CBC2__c = \'' + cbcCode +'\'' : '')
                                    
                    + ' And Fiscal_Date__c >= ' + startDate
                    + ' And Fiscal_Date__c < ' + endDate
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0 ) '
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' And Customer__r.STATDESC__c = \'Active\' '
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
    public static void getCBCHisBacklogRefData(String parentId,
                                                String cbcCode, String startDate, String endDate,
                                                map<String, set<Integer>> map_fiscalMonth, list<String> list_dateKey,
                                                ClsAPLEntityTypes.CBCFCValueObj fcViewObj) {
        list<String> list_sql = new list<String>();
        
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' Where Customer__c = \'' + parentId + '\' '
                    + (cbcCode == ClsAPLForecastUtil.CBCOTHER ? ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\'', '') : '')
                    + (cbcCode == ClsAPLForecastUtil.CBCRELAY ? ClsAPLForecastUtil.getRelayPartQuery() : '')
                    + ((cbcCode != ClsAPLForecastUtil.CBCOTHER && cbcCode != ClsAPLForecastUtil.CBCRELAY) 
                                    ? 'And Part__r.Product_Hierarchy__r.CBC2__c = \'' + cbcCode +'\'' : '')
                                    
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_fiscalMonth)
                    + ' And Backlog_Amount_USD__c != 0 '
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' And Customer__r.STATDESC__c = \'Active\' '
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
    public static void getCBCCurrentRefData(String parentId,
                                            String cbcCode, String year, Integer month,
                                            ClsAPLEntityTypes.CBCFCValueObj fcViewObj) {
        list<String> list_sql = new list<String>();
        
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' Where Customer__c = \'' + parentId + '\' '
                    + (cbcCode == ClsAPLForecastUtil.CBCOTHER ? ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\'', '') : '')
                    + (cbcCode == ClsAPLForecastUtil.CBCRELAY ? ClsAPLForecastUtil.getRelayPartQuery() : '')
                    + ((cbcCode != ClsAPLForecastUtil.CBCOTHER && cbcCode != ClsAPLForecastUtil.CBCRELAY) 
                                    ? 'And Part__r.Product_Hierarchy__r.CBC2__c = \'' + cbcCode +'\'' : '')
                    + ' And Fiscal_Year__c = \'' + year +'\''
                    + ' And Fiscal_Month__c = ' + month +
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' And Customer__r.STATDESC__c = \'Active\' '
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0)' );
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
    public static void getCBCFutureRefData(String parentId,
                                            String cbcCode, String startDate, String endDate,
                                            map<String, set<Integer>> map_fiscalMonth, list<String> list_dateKey,
                                            ClsAPLEntityTypes.CBCFCValueObj fcViewObj) {
        list<String> list_sql = new list<String>();
        
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' Where Customer__c = \'' + parentId + '\' '
                    + (cbcCode == ClsAPLForecastUtil.CBCOTHER ? ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\'', '') : '')
                    + (cbcCode == ClsAPLForecastUtil.CBCRELAY ? ClsAPLForecastUtil.getRelayPartQuery() : '')
                    + ((cbcCode != ClsAPLForecastUtil.CBCOTHER && cbcCode != ClsAPLForecastUtil.CBCRELAY) 
                                    ? 'And Part__r.Product_Hierarchy__r.CBC2__c = \'' + cbcCode +'\'' : '')
                                    
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_fiscalMonth)
                    + ' And Backlog_Amount_USD__c != 0 '
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' And Customer__r.STATDESC__c = \'Active\' '
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
    public static ClsAPLEntityTypes.AcctFCResults getGAMGPLFC(ClsAPLEntityTypes.GAMGPLFCInfo gamGPL) {
        
        ClsAPLEntityTypes.AcctFCResults acctFCResult = new ClsAPLEntityTypes.AcctFCResults();
        
        list<String> list_sql = new list<String>();
        map<String, map<String, AggregateResult>> map_gplId_map_dateKey_result =
            new map<String, map<String, AggregateResult>>();
        map<String, String> map_prodHichyId_gplCode = new map<String, String>();
        map<String, String> map_gplId_gplName = new map<String, String>();
        map<String, ClsAPLEntityTypes.GPLFCValueObj> map_gplId_gplFC 
            = new map<String, ClsAPLEntityTypes.GPLFCValueObj>();
        //set gpl code & gpl name map
        ClsAPLForecastUtil.setGPLCode(map_prodHichyId_gplCode, gamGPL.cbc2Code, map_gplId_gplName);
        
        //get query string for gpl forecast
        list_sql.add(' Fiscal_Year__c year, sum(GAM_Forecast__c) fc, GPL__c gplId,   ' 		//, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
                    + ' sum(Forecast__c) amFC, sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter ');
                    
        list_sql.add(' APL_Sales_Forecast__c ');
        list_sql.add(' WHERE Customer__c = \'' + gamGPL.acctId + '\' AND Type__c = \'GPL\' ' 
                    + ClsAPLForecastUtil.getMonthFilter(gamGPL.map_year_quartersFuture)
                    + (gamGPL.cbc2Code == ClsAPLForecastUtil.CBCRELAY ? ClsAPLForecastUtil.getRelayGPLQuery(false) : ' And GPL__r.CBC2__c =\'' + gamGPL.cbc2Code + '\' ')
                    + ' And Customer__r.STATDESC__c = \'Active\' '
                    + ' Group by Fiscal_Year__c, Fiscal_Quarter__c, GPL__c ');
        //Generate forecast view result
        system.debug('getGAMGPLFC query :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
        for(AggregateResult  result : Database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String year = (String) result.get('year'),
                   quarter = (String) result.get('quarter'), 
                   dateKey = (year + '_' + quarter),
                   gplId = (String) result.get('gplId');
            
            ClsAPLForecastUtil.setResultMap(result, gplId, dateKey, map_gplId_map_dateKey_result);
        }
        //build map for all the cbcs & quarters
        for(String gplId : map_gplId_gplName.keySet()) {
            for(String year : gamGPL.map_year_quartersFuture.keySet()) {
                for(String quarter : gamGPL.map_year_quartersFuture.get(year)) {
                    
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
        
        
        APL_ClsUtils.setGAMAMGPLHighlight(gamGPL, map_gplId_gplFC);
        
        //prepare result
        acctFCResult.json_result = Json.serialize(map_gplId_gplFC.values());
        return acctFCResult;
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
    public static ClsAPLEntityTypes.AcctFCResults getGAMRelayCBCFC(ClsAPLEntityTypes.GAMGPLFCInfo gamGPL) {
        
        ClsAPLEntityTypes.AcctFCResults acctFCResult = new ClsAPLEntityTypes.AcctFCResults();
        list<String> list_sortedRelayCBC = ClsAPLForecastUtil.getSortedRelayCBCKey();
        list<String> list_sql = new list<String>();
        list<ClsAPLEntityTypes.GPLFCValueObj> list_tempFC = new list<ClsAPLEntityTypes.GPLFCValueObj>();
        map<String, ClsAPLEntityTypes.GPLFCValueObj> map_cbcKey_fcViewObj = new map<String, ClsAPLEntityTypes.GPLFCValueObj>();
        
        //get query string for gpl forecast
        list_sql.add(' Fiscal_Year__c year, sum(GAM_Forecast__c) fc, ' 		//, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
                    + ' sum(Forecast__c) amFC, sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter, '
                    + ' Relay_CBC2_Code__c cbc2Name ');
                    
        list_sql.add(' APL_Sales_Forecast__c ');
        list_sql.add(' WHERE Customer__c = \'' + gamGPL.acctId + '\' AND Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' ' 
                    + ClsAPLForecastUtil.getMonthFilter(gamGPL.map_year_quartersFuture)
                    + APL_ClsUtils.getRelayCBC2CodeQuery()
                    + ' And Customer__r.STATDESC__c = \'Active\' '
                    + ' Group by Fiscal_Year__c, Fiscal_Quarter__c, Customer__c, Relay_CBC2_Code__c ');
        //Generate forecast view result
        system.debug('getGAMGPLFC query :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
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
            for(String year : gamGPL.map_year_quartersFuture.keySet()) {
                for(String quarter : gamGPL.map_year_quartersFuture.get(year)) {
                    
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
    public static ClsAPLEntityTypes.AcctFCResults getGAMGPLRefData(ClsAPLEntityTypes.GAMGPLFCInfo gamGPL) {
        ClsAPLEntityTypes.AcctFCResults result = new ClsAPLEntityTypes.AcctFCResults();
        String startDate = ClsAPLForecastUtil.getStartDate(gamGPL.list_dateKey[0]),
               endDate = ClsAPLForecastUtil.getEndDate(gamGPL.list_dateKey[2]);
        Integer startYear = Integer.valueOf(startDate.subStringBefore('-')), 
               startMonth = Integer.valueOf(startDate.subStringBetween('-', '-')), 
               endYear = Integer.valueOf(endDate.subStringBefore('-')), 
               endMonth = Integer.valueOf(endDate.subStringBetween('-', '-')), 
               currentYear = Integer.valueOf(gamGPL.currentYear),
               currentMonth = Integer.valueOf(gamGPL.currentMonth); 
        map<String, set<Integer>> map_fiscalMonth = ClsAPLForecastUtil.getFiscalMonthMap(gamGPL.list_dateKey);
        Date date_endDate = Date.newInstance(endYear, endMonth, 1);
        Date date_currentDate = Date.newInstance(currentYear, currentMonth, 1);
        Date date_startDate = Date.newInstance(startYear, startMonth, 1);
        
        ClsAPLEntityTypes.GPLFCValueObj fcViewObj = new ClsAPLEntityTypes.GPLFCValueObj();
        //
        if(date_endDate < date_currentDate) {
            getGPLHistoryRefData(gamGPL.acctId, gamGPL.gplId, gamGPL.cbcCode, startDate, endDate, 
                                gamGPL.list_dateKey, fcViewObj);
            getGPLHisBacklogRefData(gamGPL.acctId, gamGPL.gplId, gamGPL.cbcCode, startDate, endDate, map_fiscalMonth,
                                gamGPL.list_dateKey, fcViewObj);
        }
        else if(date_currentDate < date_startDate) {
            getGPLFutureRefData(gamGPL.acctId, gamGPL.gplId, gamGPL.cbcCode, startDate, endDate, map_fiscalMonth, 
                                gamGPL.list_dateKey, fcViewObj);
        }
        else {
            String currentEndDate =  ClsAPLForecastUtil.getEndDate(gamGPL.currentYear + '_' + gamGPL.currentMonth);
            map<String, set<Integer>> map_history = new map<String, set<Integer>>();
            map<String, set<Integer>> map_future = new map<String, set<Integer>>();
            ClsAPLForecastUtil.getDividedFiscalMap(date_currentDate, gamGPL.list_dateKey, map_history, map_future);
            
            getGPLHistoryRefData(gamGPL.acctId, gamGPL.gplId, gamGPL.cbcCode, startDate, currentEndDate, 
                                gamGPL.list_dateKey, fcViewObj);
            if(!map_history.isEmpty()) {
                getGPLHisBacklogRefData(gamGPL.acctId, gamGPL.gplId, gamGPL.cbcCode, startDate, currentEndDate, map_history,
                                    gamGPL.list_dateKey, fcViewObj);
            }
            if(!map_future.isEmpty()) {
            	getGPLCurrentRefData(gamGPL.acctId, gamGPL.gplId, gamGPL.cbcCode,
                                     gamGPL.currentYear, Integer.valueOf(gamGPL.currentMonth),
                                     fcViewObj);
                getGPLFutureRefData(gamGPL.acctId, gamGPL.gplId, gamGPL.cbcCode, currentEndDate, endDate, map_future,
                                    gamGPL.list_dateKey, fcViewObj);
            }               
        }
                                
        result.json_result = Json.serialize(fcViewObj); 
        fcViewObj.cls = String.join(gamGPL.list_dateKey, ',');                  
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
    public static void getGPLHistoryRefData(String acctId, String gplId, String cbcCode,
                                            String startDate, String endDate,
                                            list<String> list_dateKey,
                                            ClsAPLEntityTypes.GPLFCValueObj fcViewObj) {
                                                
        list<String> list_sql = new list<String>();
        map<String, map<String, AggregateResult>> map_gplId_map_dateKey_result 
                = new map<String, map<String, AggregateResult>>();
        
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking, Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
        
        list_sql.add(' Where Customer__c = \'' + acctId + '\' '
                    + (cbcCode == 'Relay' ? ClsAPLForecastUtil.getRelayCBCFilter(gplId) : ' And Part__r.Product_Hierarchy__c = \'' + gplId + '\'')
                    + ' And Fiscal_Date__c >= ' + startDate
                    + ' And Fiscal_Date__c < ' + endDate
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0 ) '
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' And Customer__r.STATDESC__c = \'Active\' '
                    + ' Group by Fiscal_Date__c');
                    
        system.debug('getGPL2RefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
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
    public static void getGPLHisBacklogRefData(String acctId, String gplId, String cbcCode,
                                                String startDate, String endDate,
                                                map<String, set<Integer>> map_fiscalMonth, list<String> list_dateKey,
                                                ClsAPLEntityTypes.GPLFCValueObj fcViewObj) {
        list<String> list_sql = new list<String>();
        
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' Where Customer__c = \'' + acctId + '\' '
                    + (cbcCode == 'Relay' ? ClsAPLForecastUtil.getRelayCBCFilter(gplId) : ' And Part__r.Product_Hierarchy__c = \'' + gplId + '\'')
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_fiscalMonth)
                    + ' And Backlog_Amount_USD__c != 0 '
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' And Customer__r.STATDESC__c = \'Active\' '
                    + ' Group by Customer_Request_Date_Fiscal_Date__c ');
        system.debug('getGPL2RefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
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
    public static void getGPLCurrentRefData(String acctId, String gplId, String cbcCode,
                                            String year, Integer month,
                                            ClsAPLEntityTypes.GPLFCValueObj fcViewObj) {
        list<String> list_sql = new list<String>();
        map<String, map<String, AggregateResult>> map_gplId_map_dateKey_result = new map<String, map<String, AggregateResult>>();
        
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' Where Customer__c = \'' + acctId + '\' '
                    + (cbcCode == 'Relay' ? ClsAPLForecastUtil.getRelayCBCFilter(gplId) : ' And Part__r.Product_Hierarchy__c = \'' + gplId + '\'')
                    + ' And Fiscal_Year__c = \'' + year +'\''
                    + ' And Fiscal_Month__c = ' + month +
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' And Customer__r.STATDESC__c = \'Active\' '
                    + ' And ( Bill_Amount_USD__c != 0  OR Book_Amount_USD__c != 0)' );
        system.debug('getGPL2RefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
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
    public static void getGPLFutureRefData(String acctId, String gplId, String cbcCode,
                                            String startDate, String endDate,
                                            map<String, set<Integer>> map_fiscalMonth, list<String> list_dateKey,
                                            ClsAPLEntityTypes.GPLFCValueObj fcViewObj) {
        list<String> list_sql = new list<String>();
        map<String, map<String, AggregateResult>> map_gplId_map_dateKey_result = new map<String, map<String, AggregateResult>>();
        
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' Where Customer__c = \'' + acctId + '\' '
                    + (cbcCode == 'Relay' ? ClsAPLForecastUtil.getRelayCBCFilter(gplId) : ' And Part__r.Product_Hierarchy__c = \'' + gplId + '\'')
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_fiscalMonth)
                    + ' And Backlog_Amount_USD__c != 0 '
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' And Customer__r.STATDESC__c = \'Active\' '
                    + ' Group by Customer_Request_Date_Fiscal_Date__c '
                    );
        system.debug('getGPL2RefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
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
    public static ClsAPLEntityTypes.AcctFCResults getGAMPartFC(ClsAPLEntityTypes.GAMPartFCInfo gamPart) {
        
        ClsAPLEntityTypes.AcctFCResults acctFCResult = new ClsAPLEntityTypes.AcctFCResults();
        
        list<String> list_sql = new list<String>();
        map<String, map<String, AggregateResult>> map_partId_map_dateKey_result =
            new map<String, map<String, AggregateResult>>();
        map<String, String> map_partId_partName = new map<String, String>();
        map<String, ClsAPLEntityTypes.PartFCValueObj> map_partId_partFC 
            = new map<String, ClsAPLEntityTypes.PartFCValueObj>();

        
        //get query string for gpl forecast
        list_sql.add(' Fiscal_Year__c year, sum(GAM_Forecast__c) fc, sum(Forecast__c) amFC, Part__c partId, Part__r.Description__c partDesc, ' //, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
                    + 'Part__r.Name partName, sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter ');
                    
        list_sql.add(' APL_Sales_Forecast__c ');
        list_sql.add(' WHERE Customer__c = \'' + gamPart.acctId + '\' ' 
                    + ClsAPLForecastUtil.getMonthFilter(gamPart.map_year_quartersFuture)
                    + ' And Part__c != null '
                    + (gamPart.cbc2Code == ClsAPLForecastUtil.CBCOTHER ? ' And ' + ClsAPLForecastUtil.getOtherPartQuery() 
                    	: (gamPart.cbc2Code == ClsAPLForecastUtil.RELAYFCTYPE ? ClsAPLForecastUtil.getRelayCBCFilter(gamPart.gplId) : ' And GPL__c =\'' + gamPart.gplId + '\' '))
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
            for(String year : gamPart.map_year_quartersFuture.keySet()) {
                for(String quarter : gamPart.map_year_quartersFuture.get(year)) {
                    
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
        system.debug('map_partId_partFC :: ' + map_partId_partFC);
        //Get part reference data 
        
        if(gamPart.map_year_monthsHistory != null && !gamPart.map_year_monthsHistory.isEmpty()) {
            getPartHistoryRefData(gamPart.acctId, gamPart.gplId, gamPart.cbc2Code, gamPart.map_year_monthsHistory, map_partId_partFC);   
        }
        if(gamPart.refStartDate != null && gamPart.periodStartDate != null) {
            getPartFutureRefData(gamPart.acctId, gamPart.gplId, gamPart.cbc2Code, gamPart.periodStartDate, gamPart.refStartDate, 
                                    gamPart.map_year_monthsHistory, map_partId_partFC);
        }
        if(gamPart.refStartDate != null && gamPart.refEndDate != null) {
        	getPartCurrentRefData(gamPart.acctId, gamPart.gplId, gamPart.cbc2Code,
                                  gamPart.currentYear, Integer.valueOf(gamPart.currentMonth),
                                  map_partId_partFC);
            getPartFutureRefData(gamPart.acctId, gamPart.gplId, gamPart.cbc2Code, gamPart.refStartDate, gamPart.refEndDate, 
                                    gamPart.map_year_monthsFuture, map_partId_partFC);
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
    public static void getPartHistoryRefData(String acctId, String gplId, String cbc2Code,
                                            map<String, set<Integer>> map_year_monthsHistory,
                                            map<String, ClsAPLEntityTypes.PartFCValueObj> map_partId_fcViewObj) {
                                                
        list<String> list_sql = new list<String>();
        map<String, map<String, AggregateResult>> map_partId_map_dateKey_result = new map<String, map<String, AggregateResult>>();
        set<String> set_partIds = new set<String>();
        set_partIds.addAll(map_partId_fcViewObj.keySet());
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking, Fiscal_Date__c fiscal_date, '
                    + ' Part__c partId ');
        list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
        
        list_sql.add(' Where Id != null '
                    + ' And Customer__c = \'' + acctId + '\''
                    + (cbc2Code == ClsAPLForecastUtil.CBCOTHER ? ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\' ', '')
                        : (cbc2Code == ClsAPLForecastUtil.RELAYFCTYPE ? ClsAPLForecastUtil.getRelayCBCFilter(gplId) :' And Part__r.Product_Hierarchy__c =\'' + gplId + '\' '))
                    + ' And Part__c IN : set_partIds '
                    + (ClsAPLForecastUtil.getFiscalMonthFilter(map_year_monthsHistory) == '' ? '' 
                            : ClsAPLForecastUtil.getFiscalMonthFilter(map_year_monthsHistory))
                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0 ) ' 
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '  
                    + ' And Customer__r.STATDESC__c = \'Active\' '  
                    + 'Group by Fiscal_Date__c, Part__c'
                    );

        system.debug('getGAMPartHistoryRefData :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
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
                    if(map_partId_map_dateKey_result.containsKey(partId) && map_partId_map_dateKey_result.get(partId).containsKey(dateKey)) {
                        result = map_partId_map_dateKey_result.get(partId).get(dateKey);
                    }
                    if(!map_partId_fcViewObj.containsKey(partId)) {
                        map_partId_fcViewObj.put(partId, new ClsAPLEntityTypes.PartFCValueObj());
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
    public static void getPartHisBacklogRefData(String acctId, String gplId, String cbc2Code,
                                            String backlogStartDate, String backlogEndDate,
                                            map<String, set<Integer>> map_year_monthsFuture,
                                            map<String, ClsAPLEntityTypes.PartFCValueObj> map_partId_fcViewObj) {
        list<String> list_sql = new list<String>();
        map<String, map<String, AggregateResult>> map_partId_map_dateKey_result 
                            = new map<String, map<String, AggregateResult>>();
        set<String> set_partIds = new set<String>();
        set_partIds.addAll(map_partId_fcViewObj.keySet());
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date, Part__c partId ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' Where Id != null '
                    + ' And Customer__c = \'' + acctId + '\''
                    + (cbc2Code == ClsAPLForecastUtil.CBCOTHER ? ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\' ', '') 
                        : (cbc2Code == ClsAPLForecastUtil.RELAYFCTYPE ? ClsAPLForecastUtil.getRelayCBCFilter(gplId) : ' And Part__r.Product_Hierarchy__c =\'' + gplId + '\' '))
                    + ' And Part__c IN : set_partIds '
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_year_monthsFuture)
                    + ' And Backlog_Amount_USD__c != 0 '
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' And Customer__r.STATDESC__c = \'Active\' '
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
            ClsAPLForecastUtil.setResultMap(result, partId, dateKey, map_partId_map_dateKey_result);
        }
        //generate forecast view objects for each quarter
        for(String partId : map_partId_fcViewObj.keySet()) {
            for(String year : map_year_monthsFuture.keySet()) {
                for(Integer month : map_year_monthsFuture.get(year)) {
                    String dateKey = year + '_' + month;
                    AggregateResult result;
                    if(map_partId_map_dateKey_result.containsKey(partId) && map_partId_map_dateKey_result.get(partId).containsKey(dateKey)) {
                        result = map_partId_map_dateKey_result.get(partId).get(dateKey);
                    }
                    if(!map_partId_fcViewObj.containsKey(partId)) {
                        map_partId_fcViewObj.put(partId, new ClsAPLEntityTypes.PartFCValueObj());
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
    public static void getPartCurrentRefData(String acctId, String gplId, String cbc2Code,
                                            String year, Integer month,
                                            map<String, ClsAPLEntityTypes.PartFCValueObj> map_partId_fcViewObj) {
        list<String> list_sql = new list<String>();
        map<String, map<String, AggregateResult>> map_partId_map_dateKey_result 
                            = new map<String, map<String, AggregateResult>>();
        set<String> set_partIds = new set<String>();
        set_partIds.addAll(map_partId_fcViewObj.keySet());
        list_sql.add(' sum(Bill_Amount_USD__c) billing, sum(Book_Amount_USD__c) booking, Part__c partId ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' Where Id != null '
                    + ' And Customer__c = \'' + acctId + '\''
                    + (cbc2Code == ClsAPLForecastUtil.CBCOTHER ? ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\' ', '') 
                        : (cbc2Code == ClsAPLForecastUtil.RELAYFCTYPE ? ClsAPLForecastUtil.getRelayCBCFilter(gplId) : ' And Part__r.Product_Hierarchy__c =\'' + gplId + '\' '))
                    + ' And Part__c IN : set_partIds '
                    + ' And Fiscal_Year__c = \'' + year +'\''
                    + ' And Fiscal_Month__c = ' + month +
                    + ' And ( Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0 ) '
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' And Customer__r.STATDESC__c = \'Active\' '
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
            if(map_partId_map_dateKey_result.containsKey(partId) && map_partId_map_dateKey_result.get(partId).containsKey(dateKey)) {
                result = map_partId_map_dateKey_result.get(partId).get(dateKey);
            }
            if(!map_partId_fcViewObj.containsKey(partId)) {
                map_partId_fcViewObj.put(partId, new ClsAPLEntityTypes.PartFCValueObj());
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
    public static void getPartFutureRefData(String acctId, String gplId, String cbc2Code,
                                            String refStartDate, String refEndDate,
                                            map<String, set<Integer>> map_year_monthsFuture,
                                            map<String, ClsAPLEntityTypes.PartFCValueObj> map_partId_fcViewObj) {
        list<String> list_sql = new list<String>();
        map<String, map<String, AggregateResult>> map_partId_map_dateKey_result 
                            = new map<String, map<String, AggregateResult>>();
        set<String> set_partIds = new set<String>();
        set_partIds.addAll(map_partId_fcViewObj.keySet());
        list_sql.add(' sum(Backlog_Amount_USD__c) backlog, Customer_Request_Date_Fiscal_Date__c fiscal_date, Part__c partId ');
        list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
        
        list_sql.add(' Where Id != null '
                    + ' And Customer__c = \'' + acctId + '\''
                    + (cbc2Code == ClsAPLForecastUtil.CBCOTHER ? ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\' ', '') 
                        : (cbc2Code == ClsAPLForecastUtil.RELAYFCTYPE ? ClsAPLForecastUtil.getRelayCBCFilter(gplId) : ' And Part__r.Product_Hierarchy__c =\'' + gplId + '\' '))
                    + ' And Part__c IN : set_partIds '
                    + ClsAPLForecastUtil.getCustomRequestMonthFilter(map_year_monthsFuture)
                    + ' And Backlog_Amount_USD__c != 0 '
                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
                    + ' And Customer__r.STATDESC__c = \'Active\' '
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
            ClsAPLForecastUtil.setResultMap(result, partId, dateKey, map_partId_map_dateKey_result);
        }
        //generate forecast view objects for each quarter
        for(String partId : map_partId_fcViewObj.keySet()) {
            for(String year : map_year_monthsFuture.keySet()) {
                for(Integer month : map_year_monthsFuture.get(year)) {
                    String dateKey = year + '_' + month;
                    AggregateResult result;
                    if(map_partId_map_dateKey_result.containsKey(partId) && map_partId_map_dateKey_result.get(partId).containsKey(dateKey)) {
                        result = map_partId_map_dateKey_result.get(partId).get(dateKey);
                    }
                    if(!map_partId_fcViewObj.containsKey(partId)) {
                        map_partId_fcViewObj.put(partId, new ClsAPLEntityTypes.PartFCValueObj());
                    }
                    
                    ClsAPLEntityTypes.PartFCValueObj fcObj = map_partId_fcViewObj.get(partId);
                    fcObj = fcObj.assignHisBacklogRefData(fcObj, result, dateKey);
                    
                }
            }
        }
    }


    /**
    * This method is used to save GAM account forecast
    * 
    *
    @author Yuda Zheng
    @created 2014-06-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *@param     GAMAcctFCInfo GAM account forecast information
    *
    @changelog
    * 2014-06-11 Yuda Zheng <yuda.zheng@itbconsult.com>
    * - Created
    */
    public static void saveGAMAcctFC(ClsAPLEntityTypes.GAMAcctFCInfo acctFC) {
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
    public static void saveGAMGPLFC(ClsAPLEntityTypes.GAMGPLFCInfo gplFC) {
        
        map<String, map<String, APL_Sales_Forecast__c>> map_acctId_map_dateKey_fc = new map<String, map<String, APL_Sales_Forecast__c>>();
        map<String, map<String, map<String, APL_Sales_Forecast__c>>> map_partId_map_acctId_map_dateKey_fc = new map<String, map<String, map<String, APL_Sales_Forecast__c>>>();
        list<APL_Sales_Forecast__c> list_acctFC2Insert = new list<APL_Sales_Forecast__c>();
        list<APL_Sales_Forecast__c> list_acctFC2Update = new list<APL_Sales_Forecast__c>();
        list<APL_Sales_Forecast__c> list_acctFC2Delete = new list<APL_Sales_Forecast__c>();
        map<String, decimal> map_acctId_billingPercent = new map<String, decimal>{
            gplFC.acctId => 1
        };
        String fcType = (gplFC.cbc2Code == ClsAPLForecastUtil.CBCOTHER ? ClsAPLForecastUtil.OTHERFCTYPE : ClsAPLForecastUtil.PARTFCTYPE);
        if(gplFC.cbc2Code != ClsAPLForecastUtil.CBCOTHER) {
            //get existing acct
            getExistingGPLFC(gplFC.acctId, gplFC.gplId, gplFC.map_year_quartersFuture, map_acctId_map_dateKey_fc);
            //create or update account forecast records
            ClsAPLForecastUtil.generateFC(map_acctId_billingPercent, gplFC.map_dateKey_fc, map_acctId_map_dateKey_fc, 
                        ClsAPLForecastUtil.GPLFCTYPE, gplFC.gplId, '', gplFC.currencyIso, false, true, false, list_acctFC2Insert, list_acctFC2Update, list_acctFC2Delete);
        }
        //get existing acct
        getExistingPartFC(gplFC.acctId, gplFC.gplId, gplFC.cbc2Code, gplFC.map_year_quartersFuture, map_partId_map_acctId_map_dateKey_fc);
        
        saveGAMPartFC(gplFC.list_parts, fcType, map_partId_map_acctId_map_dateKey_fc, gplFC.gplId, map_acctId_billingPercent, list_acctFC2Insert,
                      list_acctFC2Update, list_acctFC2Delete);
        
        //INSERT, UPDATE, DELETE APL Forecasts
        ClsAPLForecastUtil.aplFCRecordsDML(list_acctFC2Insert, list_acctFC2Update, list_acctFC2Delete);
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
    public static void saveGAMPartFC(list<ClsAPLEntityTypes.GAMPartFCInfo> list_partFCs, String fcType,
                                      map<String, map<String, map<String, APL_Sales_Forecast__c>>> map_partId_map_acctId_map_dateKey_fc,
                                      String gplId, map<String, decimal> map_acctId_billingPercent,
                                      list<APL_Sales_Forecast__c> list_acctFC2Insert,
                                      list<APL_Sales_Forecast__c> list_acctFC2Update,
                                      list<APL_Sales_Forecast__c> list_acctFC2Delete) {
        map<String, map<String, APL_Sales_Forecast__c>> map_acctId_map_dateKey_fc = new map<String, map<String, APL_Sales_Forecast__c>>();
        for(ClsAPLEntityTypes.GAMPartFCInfo partFC : list_partFCs) {
            
            map_acctId_map_dateKey_fc = map_partId_map_acctId_map_dateKey_fc.get((fcType == ClsAPLForecastUtil.OTHERFCTYPE ? ClsAPLForecastUtil.OTHERFCTYPE : partFC.partId));
            //create or update account forecast records
            system.debug('partFC.gplId :: ' + partFC.gplId);
            ClsAPLForecastUtil.generateFC(map_acctId_billingPercent, partFC.map_dateKey_fc, map_acctId_map_dateKey_fc, 
                        fcType, partFC.gplId, partFC.partId, partFC.currencyIso, false, true, false, list_acctFC2Insert, list_acctFC2Update, list_acctFC2Delete);
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
    public static void getExistingGPLFC(String acctId, String gplId,
                                        map<String, set<String>> map_year_quartersFuture, 
                                        map<String, map<String, APL_Sales_Forecast__c>> map_acctId_map_dateKey_fc) {
        
        list<String> list_sql = new list<String>();

        list_sql.add(' Id, Customer__c, GPL__c, Fiscal_Quarter__c, Fiscal_Year__c, Forecast__c, GAM_Forecast__c, Type__c, RSM_Forecast__c ');     
        list_sql.add(' APL_Sales_Forecast__c ');                               
        list_sql.add(' Where Type__c = \'' + ClsAPLForecastUtil.GPLFCTYPE + '\' '
                   + ClsAPLForecastUtil.getMonthFilter(map_year_quartersFuture)
                   + ' And Customer__c = \'' + acctId + '\' ' 
                   + ' And Customer__r.STATDESC__c = \'Active\' '
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
    public static void getExistingPartFC(String acctId, String gplId, String cbc2Code,
                                        map<String, set<String>> map_year_quartersFuture, 
                                        map<String, map<String, map<String, APL_Sales_Forecast__c>>> map_partId_map_acctId_map_dateKey_fc) {
        
        list<String> list_sql = new list<String>();
        String fcType = (cbc2Code == ClsAPLForecastUtil.CBCOTHER ? ClsAPLForecastUtil.OTHERFCTYPE : ClsAPLForecastUtil.PARTFCTYPE);
        
        list_sql.add(' Id, Customer__c, Part__c, Fiscal_Quarter__c, Fiscal_Year__c, Forecast__c, GAM_Forecast__c, Type__c, RSM_Forecast__c ');     
        list_sql.add(' APL_Sales_Forecast__c ');                               
        list_sql.add(' Where Type__c = \'' + fcType + '\' '
                   + ClsAPLForecastUtil.getMonthFilter(map_year_quartersFuture)
                   + ' And Customer__c = \'' + acctId + '\' ' 
                   + ' And Customer__r.STATDESC__c = \'Active\' '
                   + (cbc2Code == ClsAPLForecastUtil.CBCOTHER ? '' 
                        : '  And Part__r.Product_Hierarchy__c =\'' + gplId + '\''));      
        system.debug('getExistingPartFC :: ' + ClsAPLForecastUtil.getQueryString(list_sql));                                    
        for(APL_Sales_Forecast__c fc : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String dateKey = fc.Fiscal_Year__c + '_' + fc.Fiscal_Quarter__c;
            String partId = (fc.Type__c == ClsAPLForecastUtil.OTHERFCTYPE ? ClsAPLForecastUtil.OTHERFCTYPE : fc.Part__c);
            
            //if(!map_partId_map_acctId_map_dateKey_fc.containsKey(fc.Part__c)) {
            if(!map_partId_map_acctId_map_dateKey_fc.containsKey(partId)) {
                map_partId_map_acctId_map_dateKey_fc.put(partId, new map<String, map<String, APL_Sales_Forecast__c>>{
                    fc.Customer__c => new map<String, APL_Sales_Forecast__c>()
                });
            }
            if(!map_partId_map_acctId_map_dateKey_fc.get(partId).get(fc.Customer__c).containsKey(dateKey)) {
                map_partId_map_acctId_map_dateKey_fc.get(partId).get(fc.Customer__c).put(dateKey, fc);
            }
        }
    }

   
}