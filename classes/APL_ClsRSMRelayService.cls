public without sharing class APL_ClsRSMRelayService  extends APL_Interface.AAPLCtrlService  {
    
    public class SearchLevelTotal extends APL_Interface.AAPLRemoteService {
        
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
        public override String saveSObjectData(String sData) { 
            APL_ClsEntityType.RSMRelayOverRallInfo overRallInfo = (APL_ClsEntityType.RSMRelayOverRallInfo) json.deserialize(sData, APL_ClsEntityType.RSMRelayOverRallInfo.class);
            
            system.debug('!@#overRallInfo: '+overRallInfo);
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
            list_sql.add(' Where Display_Name__c IN : set_displayNames and Active__c = true ' 
                        + ' And Id IN : set_rsmIds ');
            //system.debug('ClsAPLForecastUtil.getQueryString(list_sql):::: '+ClsAPLForecastUtil.getQueryString(list_sql));
            for(APL_RSM__c rsm : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
                set_aplRSMId.add(rsm.Id);
                map_rsmId_disName.put(rsm.Id, rsm.Display_Name__c);
            }
            
            if(set_aplRSMId.isEmpty()) {
                return 'true';
            } 
            list_sql.clear();
            list_sql.add(' Id, Relay_RSM_Overall_Forecast__c, RSM_Overall_Forecast__c, Fiscal_Year__c, Fiscal_Quarter__c, APL_RSM__r.Display_Name__c ');
            list_sql.add(' APL_RSM_Overall_Forecast__c '); 
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
            try {
                if(!list_overRallFC2Update.isEmpty()) {
                    update list_overRallFC2Update;
                }
                if(!list_overRallFC2Insert.isEmpty()) {
                    insert list_overRallFC2Insert;
                }
                return 'true';
            }catch(Exception ex) {
                throw ex;
            }
            
        }
        
        
        /**
         *  This function is used get all reference data list.
         *  
         * @author Juillet Yuan
         * @created 2014-10-29
         * @version 1.0
         * @since 31.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Juillet Yuan <Juillet.yuan@itbconsult.com>
         * - Created
         *
         */
        public override String getRefData(String sData) { 
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData,APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                
                set<String> set_rsmAMTerritoryCodes = new set<String>();
                set<String> set_rsmRelayTerritoryCodes = new set<String>();
                set<String> set_rsmDisplayName = new set<String>();
                
                APL_ClsUtils.setAllTerritoryCode(searchOb.managerId, set_rsmAMTerritoryCodes, set_rsmRelayTerritoryCodes, set_rsmDisplayName, 'AM');
                
                set<String> set_acctIds = new set<String>();
                ClsAPLForecastUtil.setRSMAccountIds(false, set_rsmRelayTerritoryCodes, set_acctIds);
                
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_currentdate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                Date currentdate = APL_ClsUtils.getCurrentFiscalDate();
                
                for(String datekey : searchOb.set_fiscalMonth) {
                    String year = datekey.substring(0, datekey.indexOf('_'));
                    String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
                    Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);
                    if(refdate < currentdate) {
                        list_beforedate.add(refdate);
                    }else if(refdate >= currentdate) {
                        list_currentdate.add(refdate);
                    }
                }

                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();

                if(list_beforedate.size() > 0) {
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_beforedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Quantity__c) billQty, sum(Book_Quantity__c) bookQty, Fiscal_Date__c refdate ');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    
                    list_sql.add(' WHERE Customer__c IN : set_soldtoIds '
                            + ClsAPLForecastUtil.getRelayPartQuery()
                            + ' And Fiscal_Year__c IN : years '
                            + ' And Fiscal_Month__c IN : months '
                            + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
                            //update by nelson zheng 2015-10-21 for case 00900375
                            //+ ' And Profit_Center__c = \'RPA\' '
                            //+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))'
                            + ' And Profit_Center__c = \'APL\' '
                            + ' Group by Fiscal_Date__c ' );

                    System.debug('------APL_ClsRSMRelayService.cls (18 matches) 1-----');
                    APL_ClsUtils.setRegionMapRefData('relaytotal', years, months, set_acctIds, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
                    //current
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                        
                    APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
    
                    list<String> list_sql = new list<String>();
                        
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Qty__c) billQty, sum(Book_Qty__c) bookQty, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__c IN : set_soldtoIds '
                        + ClsAPLForecastUtil.getRelayPartQuery()  
                        + ' And Fiscal_Year__c IN : years '
                        + ' And Fiscal_Month__c IN : months '
                        + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
                        //update by nelson zheng 2015-10-21 for case 00900375
                        //+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))'
                        //+ ' And Profit_Center__c = \'RPA\' '
                        + ' And Profit_Center__c = \'APL\' '
                        + ' Group by Fiscal_Date__c  ' );
    
                    System.debug('------APL_ClsRSMRelayService.cls (18 matches) 2-----');
                    APL_ClsUtils.setRegionMapRefData('relaytotal', years, months, set_acctIds, list_sql, map_acctId_map_dateKey_result_before);
                }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = 'relaytotal';
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
        }
        
        /**
         *  This function is used get backlog reference data list.
         *  
         * @author Lei Tang
         * @created 2015-03-10
         * @version 1.0
         * @since 30.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Lei Tang <lei.tang@itbconsult.com>
         * - Created
         *
         */
        public override String getBacklogRefData(String sData) {
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                
                set<String> set_rsmAMTerritoryCodes = new set<String>();
                set<String> set_rsmRelayTerritoryCodes = new set<String>();
                set<String> set_rsmDisplayName = new set<String>();
                
                APL_ClsUtils.setAllTerritoryCode(searchOb.managerId, set_rsmAMTerritoryCodes, set_rsmRelayTerritoryCodes, set_rsmDisplayName, 'AM');
                
                set<String> set_acctIds = new set<String>();
                ClsAPLForecastUtil.setRSMAccountIds(false, set_rsmRelayTerritoryCodes, set_acctIds);
                
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                for(String datekey : searchOb.set_fiscalMonth) {
                    String year = datekey.substring(0, datekey.indexOf('_'));
                    String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
                    Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);
    
                    list_futruedate.add(refdate);
                }

                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();

                if(list_futruedate.size() > 0) {
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_futruedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount, sum(Backlog_Qty__c) qty, Customer_Request_Date_Fiscal_Date__c refdate ');
                    list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__c IN : set_soldtoIds '
                        + ClsAPLForecastUtil.getRelayPartQuery()  
                        + ' And Customer_Request_Date_Fiscal_Year__c IN : years '
                        + ' And Customer_Request_Date_Fiscal_Month__c IN : months '
                        + ' And Backlog_Amount_USD__c != 0 '
                        //update by nelson zheng 2015-10-21 for case 00900375
                        //+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))'
                        //+ ' And Profit_Center__c = \'RPA\' '
                        + ' And Profit_Center__c = \'APL\' '
                        + ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
                    System.debug('------APL_ClsRSMRelayService.cls (18 matches) 3-----');
                    APL_ClsUtils.setRegionMapRefData('relaytotal', years, months, set_acctIds, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = 'relaytotal';
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
            
        }
    }
    
    
    public class SearchLevel1 extends APL_Interface.AAPLRemoteService {

        /**
         *  This function is used get all reference data list.
         *  
         * @author Juillet Yuan
         * @created 2014-10-29
         * @version 1.0
         * @since 31.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Juillet Yuan <Juillet.yuan@itbconsult.com>
         * - Created
         *
         */
        public override String getRefData(String sData) { 
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData,APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_currentdate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                Date currentdate = APL_ClsUtils.getCurrentFiscalDate();
                for(String datekey : searchOb.set_fiscalMonth) {
                    String year = datekey.substring(0, datekey.indexOf('_'));
                    String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
                    Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);

                    if(refdate < currentdate) {
                        list_beforedate.add(refdate);
                    }else if(refdate >= currentdate) {
                        list_currentdate.add(refdate);
                    }
                }
                
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();
                
                if(list_beforedate.size() > 0) {
                    
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_beforedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Quantity__c) billQty, sum(Book_Quantity__c) bookQty, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.Relay_Specialist_Territory_Code__c = \'' + searchOb.territoryCode + '\' '
                            + ' And Customer__r.STATDESC__c = \'Active\' '
                            //+ ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
                            //+ ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
                            + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
                            //update by nelson zheng 2015-10-21 for case 00900375
                            //change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
                            +' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'41553\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))'
                           // + ' And Profit_Center__c = \'RPA\'  '
                            + ' And Fiscal_Year__c IN : years '
                            + ' And Fiscal_Month__c IN : months '
                            + ' Group by Fiscal_Date__c ');
                    System.debug('------APL_ClsRSMRelayService.cls (18 matches) 4-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.territoryCode, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
                    //current
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                        
                    APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
    
                    list<String> list_sql = new list<String>();
                        
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Qty__c) billQty, sum(Book_Qty__c) bookQty, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.Relay_Specialist_Territory_Code__c = \'' + searchOb.territoryCode + '\' '
                            + ' And Customer__r.STATDESC__c = \'Active\' '
                            //+ ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
                            //+ ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
                            + ' And Fiscal_Year__c IN : years '
                            + ' And Fiscal_Month__c IN : months '
                            + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
                            //update by nelson zheng 2015-10-21 for case 00900375
                            //change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
                            +' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'41553\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\')))'
                            //+ ' And Profit_Center__c = \'RPA\'  '
                            + ' Group by Fiscal_Date__c  ' );
    
                    System.debug('------APL_ClsRSMRelayService.cls (18 matches) 5-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.territoryCode, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = searchOb.territoryCode;
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                //decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, searchOb.currencyIso, 'USD');
                
                //for(String datekey : refdata.map_billingrefdata.keySet()) {
                //  refdata.map_billingrefdata.put(datekey, (refdata.map_billingrefdata.get(datekey) / currencyRate) );
                //  refdata.map_bookingrefdata.put(datekey, (refdata.map_bookingrefdata.get(datekey) / currencyRate) );
                //}
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
        }
        
        
        /**
         *  This function is used get backlog reference data list.
         *  
         * @author Lei Tang
         * @created 2015-03-10
         * @version 1.0
         * @since 30.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Lei Tang <lei.tang@itbconsult.com>
         * - Created
         *
         */
        public override String getBacklogRefData(String sData) {
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                for(String datekey : searchOb.set_fiscalMonth) {
                    String year = datekey.substring(0, datekey.indexOf('_'));
                    String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
                    Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);
    
                    list_futruedate.add(refdate);
                }

                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();

                if(list_futruedate.size() > 0) {
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_futruedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount, sum(Backlog_Qty__c) qty, Customer_Request_Date_Fiscal_Date__c refdate ');
                    list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.Relay_Specialist_Territory_Code__c = \'' + searchOb.territoryCode + '\' '
                            + ' And Customer__r.STATDESC__c = \'Active\' '
                            //+ ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
                            //+ ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
                            + ' And Customer_Request_Date_Fiscal_Year__c IN : years '
                            + ' And Customer_Request_Date_Fiscal_Month__c  IN : months '
                            + ' And Backlog_Amount_USD__c != 0 '
                            //update by nelson zheng 2015-10-21 for case 00900375
                            //change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
                            +' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'41553\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                            //+ ' And Profit_Center__c = \'RPA\'  '
                            
                            + ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
                    System.debug('------APL_ClsRSMRelayService.cls (18 matches) 6-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.territoryCode, years, months, null, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = searchOb.territoryCode;
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                //decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, searchOb.currencyIso, 'USD');
                
                //for(String datekey : refdata.map_billingrefdata.keySet()) {
                //  refdata.map_backlogrefdata.put(datekey, (refdata.map_backlogrefdata.get(datekey) / currencyRate) );
                //}

                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
            
        }
    }
    
    
    public class SearchLevel2 extends APL_Interface.AAPLRemoteService {
        

        public override String getExistResult(String sData){
            APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb:'+searchOb);
            
            list<String> list_sql = new list<String>();
            list_sql.add(' Fiscal_Year__c year, sum(RSM_Forecast__c) fc, Customer__r.APL_Relay_Display_Name__c groupname, Customer__r.APL_Relay_forecast_Plan_Account__c accId, '      //, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
                        +' sum(Current_month_1_RSM_forecast__c) prevFC, Fiscal_Quarter__c quarter, sum(Forecast__c) amFC ');
            list_sql.add(' APL_Sales_Forecast__c ');
            list_sql.add(' WHERE Customer__r.Relay_Specialist_Territory_Code__c = \'' + searchOb.territoryCode + '\' '
                        + ' And Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' '
                        + APL_ClsUtils.getRelayCBC2CodeQuery()
                        + ' And Customer__r.STATDESC__c = \'Active\' '
                        + ClsAPLForecastUtil.getMonthFilter(searchOb.map_year_quartersFuture) 
                        + ' Group by Fiscal_Year__c, Fiscal_Quarter__c, Customer__r.APL_Relay_Display_Name__c, Customer__r.APL_Relay_forecast_Plan_Account__c ');

            map<String, APL_ClsEntityType.RSMAccountObj> map_acctId_acctFC = new map<String, APL_ClsEntityType.RSMAccountObj>();
            
            for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
                String accId = (String) result.get('accId'),
                       year = (String) result.get('year'),
                       quarter = (String) result.get('quarter'), 
                       dateKey = (year + '_' + quarter);
                //ClsAPLForecastUtil.setResultMap(result, tempAcctId, dateKey, map_acctId_map_dateKey_result);
                APL_ClsEntityType.RSMAccountObj acctFC = new APL_ClsEntityType.RSMAccountObj();
                //decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, (String) result.get('currency'), 'USD');
                if(!map_acctId_acctFC.containsKey(accId)) {
                    APL_ClsUtils.createRSMRelayGroupingObj(acctFC, searchOb.map_year_quartersFuture);
                    
                    acctFC.id = accId;
                    acctFC.name = (String) result.get('groupname');
    
                    map_acctId_acctFC.put(accId, acctFC);
                }else {
                    acctFC = map_acctId_acctFC.get(accId);  
                }
    			
                acctFC.map_type_FC.get('csFC').put(dateKey, (result.get('fc') != null ? (decimal)result.get('fc') : 0));
                acctFC.map_type_FC.get('pmFC').put(dateKey, (result.get('prevFC') != null ? (decimal)result.get('prevFC') : 0));
                acctFC.map_type_FC.get('amFC').put(dateKey, (result.get('amFC') != null ? (decimal)result.get('amFC') : 0));
                map_acctId_acctFC.put(accId, acctFC);
    
            }
            
            list<APL_ClsEntityType.RSMAccountObj> list_accFC = new list<APL_ClsEntityType.RSMAccountObj>();
            list_accFC.addAll(map_acctId_acctFC.values());
            list_accFC.sort();
            return Json.serialize(list_accFC);

        }
        
        /**
         *  This function is used get all reference data list.
         *  
         * @author Juillet Yuan
         * @created 2014-10-29
         * @version 1.0
         * @since 31.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Juillet Yuan <Juillet.yuan@itbconsult.com>
         * - Created
         *
         */
        public override String getRefData(String sData) { 
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData,APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_currentdate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                Date currentdate = APL_ClsUtils.getCurrentFiscalDate();
                for(String datekey : searchOb.set_fiscalMonth) {
                    String year = datekey.substring(0, datekey.indexOf('_'));
                    String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
                    Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);

                    if(refdate < currentdate) {
                        list_beforedate.add(refdate);
                    }else if(refdate >= currentdate) {
                        list_currentdate.add(refdate);
                    }
                }

                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();

                if(list_beforedate.size() > 0) {
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_beforedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Quantity__c) billQty, sum(Book_Quantity__c) bookQty, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.Relay_Specialist_Territory_Code__c = \'' + searchOb.territoryCode + '\' '
                            + ' And Customer__r.APL_Relay_forecast_Plan_Account__c = \'' +  searchOb.grouping + '\' '
                            + ' And Customer__r.STATDESC__c = \'Active\' '
                            + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
                            //update by nelson zheng 2015-10-21 for case 00900375
                            //change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
                            +' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'41553\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                            //+ ' And Profit_Center__c = \'RPA\'  '
                            
                            + ' And Fiscal_Year__c IN : years '
                            + ' And Fiscal_Month__c IN : months '
                            + ' Group by Fiscal_Date__c ');
                    System.debug('------APL_ClsRSMRelayService.cls (18 matches) 7-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.grouping, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
                    //current
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                        
                    APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
    
                    list<String> list_sql = new list<String>();
                        
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Qty__c) billQty, sum(Book_Qty__c) bookQty, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.Relay_Specialist_Territory_Code__c = \'' + searchOb.territoryCode + '\' '
                            + ' And Customer__r.APL_Relay_forecast_Plan_Account__c = ' + (searchOb.grouping == ClsAPLForecastUtil.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ')   
                        + ' And Customer__r.STATDESC__c = \'Active\' '
                        + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
                        + ' And Fiscal_Year__c IN : years '
                        + ' And Fiscal_Month__c IN : months '
                        //update by nelson zheng 2015-10-21 for case 00900375
                        //change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
                        +' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'41553\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        //+ ' And Profit_Center__c = \'RPA\'  '
                        
                        + ' Group by Fiscal_Date__c  ' );
    
                    System.debug('------APL_ClsRSMRelayService.cls (18 matches) 8-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.grouping, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = searchOb.grouping;
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
        }
        
        /**
         *  This function is used get backlog reference data list.
         *  
         * @author Lei Tang
         * @created 2015-03-10
         * @version 1.0
         * @since 30.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Lei Tang <lei.tang@itbconsult.com>
         * - Created
         *
         */
        public override String getBacklogRefData(String sData) {
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                for(String datekey : searchOb.set_fiscalMonth) {
                    String year = datekey.substring(0, datekey.indexOf('_'));
                    String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
                    Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);
    
                    list_futruedate.add(refdate);
                }

                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();

                if(list_futruedate.size() > 0) {
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_futruedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount, sum(Backlog_Qty__c) qty, Customer_Request_Date_Fiscal_Date__c refdate ');
                    list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.Relay_Specialist_Territory_Code__c = \'' + searchOb.territoryCode + '\' '
                        + ' And Customer__r.APL_Relay_forecast_Plan_Account__c = ' + (searchOb.grouping == ClsAPLForecastUtil.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ')   
                        + ' And Customer__r.STATDESC__c = \'Active\' '
                        + ' And Customer_Request_Date_Fiscal_Year__c IN : years '
                        + ' And Customer_Request_Date_Fiscal_Month__c  IN : months '
                        + ' And Backlog_Amount_USD__c != 0 '
                        //update by nelson zheng 2015-10-21 for case 00900375
                        //change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
                        +' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'41553\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        //+ ' And Profit_Center__c = \'RPA\'  '
                        
                        + ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
                    System.debug('------APL_ClsRSMRelayService.cls (18 matches) 9-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.grouping, years, months, null, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = searchOb.grouping;
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
            
        }
        
    }
    
    
    public class SearchLevel3 extends APL_Interface.AAPLRemoteService {
        
        public override void setCBC2Column(list<APL_ClsEntityType.Cbc2Object> list_cbc2column)  {
        	list_cbc2column.add(new APL_ClsEntityType.Cbc2Object('[ 41553 ] CBC3 / Relays IND', '41553', 'CBC3 / Relays IND', '' ));
        	//change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
            //list_cbc2column.add(new APL_ClsEntityType.Cbc2Object('[ 40309 ] CBC3 / Relays IB', '40309', 'CBC3 / Relays IB', '' ));
            //list_cbc2column.add(new APL_ClsEntityType.Cbc2Object('[ 40308 ] CBC3 / Relays A&C', '40308', 'CBC3 / Relays A&C', ''));
            list_cbc2column.add(new APL_ClsEntityType.Cbc2Object('[ 30005 ] CBC2 / APPLIANCES GENERAL PURPOSE RELAYS', '30005', 'CBC2 / APPLIANCES GENERAL PURPOSE RELAYS', ''));
            list_cbc2column.add(new APL_ClsEntityType.Cbc2Object('[ 13213 ] CBC2 / Automotive Relays', '13213',  'CBC2 / Automotive Relays', ''));
        }
        
        public override String getExistResult(String sData){
            APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb:'+searchOb);
            list<APL_ClsEntityType.RSMAccountObj> list_accFC = new list<APL_ClsEntityType.RSMAccountObj>();

            list<String> list_sql = new list<String>();
             
            list_sql.add(' Fiscal_Year__c year, Fiscal_Quarter__c quarter, Relay_CBC2_Code__c cbc2Name, ' 
                    + ' sum(RSM_Forecast__c) amFC, sum(Current_month_1_RSM_forecast__c) prevFC ');
            list_sql.add(' APL_Sales_Forecast__c ');
            list_sql.add(' WHERE Customer__r.STATDESC__c = \'Active\' '
                + ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
                + ClsAPLForecastUtil.getMonthFilter(searchOb.map_year_quartersFuture)
                + ' And Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' '  
                + ' Group by Fiscal_Year__c, Fiscal_Quarter__c, Relay_CBC2_Code__c'); 
            
            map<String, APL_ClsEntityType.RSMAccountObj> map_acctId_acctFC = new map<String, APL_ClsEntityType.RSMAccountObj>();
            
            list<APL_ClsEntityType.Cbc2Object> list_cbc2column = new list<APL_ClsEntityType.Cbc2Object>();
            setCBC2Column(list_cbc2column);
            map<String, APL_ClsEntityType.Cbc2Object> map_cbcRowKey_cbcName = new map<String, APL_ClsEntityType.Cbc2Object>();
            for(APL_ClsEntityType.Cbc2Object cbc2 : list_cbc2column) {
                map_cbcRowKey_cbcName.put(cbc2.code, cbc2);
                APL_ClsEntityType.RSMAccountObj rsmcbc = new APL_ClsEntityType.RSMAccountObj();
                APL_ClsUtils.createRSMRelayAccountObj(rsmcbc, searchOb.map_year_quartersFuture);
                rsmcbc.id = APL_ClsUtils.getHexUID();
                rsmcbc.name = cbc2.name;
                rsmcbc.accnumber = cbc2.code;
                map_acctId_acctFC.put(cbc2.code, rsmcbc);
            }
            
            list<String> set_tempqy = new list<String>();

            //decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, searchOb.currencyIso, 'USD');
            for(AggregateResult  result : Database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
                String year = (String) result.get('year');
                String cbcName = (String) result.get('cbc2Name');
                String quarter = (String) result.get('quarter');
                String dateKey = year + '_' + quarter;
                
                APL_ClsEntityType.RSMAccountObj rsmcbc = new APL_ClsEntityType.RSMAccountObj();
                //decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, (String) result.get('currency'), 'USD');
                if(!map_acctId_acctFC.containsKey(cbcName)) {
                    APL_ClsUtils.createRSMAccountObj(rsmcbc, searchOb.map_year_quartersFuture);
                    rsmcbc.id = APL_ClsUtils.getHexUID();
                    rsmcbc.name = map_cbcRowKey_cbcName.get(cbcName).name;
                    rsmcbc.accnumber = map_cbcRowKey_cbcName.get(cbcName).code;
                    map_acctId_acctFC.put(cbcName, rsmcbc);
                }else {
                    rsmcbc = map_acctId_acctFC.get(cbcName);
                }
                
                rsmcbc.map_type_FC.get('csFC').put(dateKey, (result.get('amFC') != null ? (decimal)result.get('amFC') : 0));
                //rsmcbc.map_type_FC.get('rsmFC').put(dateKey, (result.get('rsmFC') != null ? ((decimal)result.get('rsmFC') / currencyRate) : 0));
                rsmcbc.map_type_FC.get('pmFC').put(dateKey, (result.get('prevFC') != null ? (decimal)result.get('prevFC') : 0));
                map_acctId_acctFC.put(cbcName, rsmcbc);
            }
            
            list_accFC.addAll(map_acctId_acctFC.values());
            system.debug('@#list_accFC : '+list_accFC);
            return Json.serialize(list_accFC);
        }
        
        /**
         *  This function is used get all reference data list.
         *  
         * @author Juillet Yuan
         * @created 2014-10-29
         * @version 1.0
         * @since 31.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Juillet Yuan <Juillet.yuan@itbconsult.com>
         * - Created
         *
         */
        public override String getRefData(String sData) { 
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData,APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_currentdate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                Date currentdate = APL_ClsUtils.getCurrentFiscalDate();
                for(String datekey : searchOb.set_fiscalMonth) {
                    String year = datekey.substring(0, datekey.indexOf('_'));
                    String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
                    Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);

                    if(refdate < currentdate) {
                        list_beforedate.add(refdate);
                    }else if(refdate >= currentdate) {
                        list_currentdate.add(refdate);
                    }
                }
                
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();
                
                if(list_beforedate.size() > 0) {
                    
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_beforedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Quantity__c) billQty, sum(Book_Quantity__c) bookQty, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.APL_Relay_forecast_Plan_Account__c = \'' +  searchOb.grouping + '\' '
                            + ' And Customer__r.STATDESC__c = \'Active\' '
                            + ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
                            + ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
                            + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
                            //update by nelson zheng 2015-10-21 for case 00900375
                        	//+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c = \'RPA\'  '
                        	+ ' And Profit_Center__c = \'APL\'  '
                            + ' And Fiscal_Year__c IN : years '
                            + ' And Fiscal_Month__c IN : months '
                            + ' Group by Fiscal_Date__c ');
                    System.debug('------APL_ClsRSMRelayService.cls (18 matches) 10-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.cbc2Code, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
                    //current
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                        
                    APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
    
                    list<String> list_sql = new list<String>();
                        
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Qty__c) billQty, sum(Book_Qty__c) bookQty, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.APL_Relay_forecast_Plan_Account__c = \'' +  searchOb.grouping + '\' '
                            + ' And Customer__r.STATDESC__c = \'Active\' '
                            + ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
                            + ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
                            + ' And Fiscal_Year__c IN : years '
                            + ' And Fiscal_Month__c IN : months '
                            + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
                            //update by nelson zheng 2015-10-21 for case 00900375
                       	 	//+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c = \'RPA\'  '
                        	+ ' And Profit_Center__c = \'APL\'  '
                            + ' Group by Fiscal_Date__c  ' );
    
                    System.debug('------APL_ClsRSMRelayService.cls (18 matches) 11-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.cbc2Code, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = searchOb.cbc2Code;
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);

                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
        }
        
        /**
         *  This function is used get backlog reference data list.
         *  
         * @author Lei Tang
         * @created 2015-03-10
         * @version 1.0
         * @since 30.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Lei Tang <lei.tang@itbconsult.com>
         * - Created
         *
         */
        public override String getBacklogRefData(String sData) {
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                for(String datekey : searchOb.set_fiscalMonth) {
                    String year = datekey.substring(0, datekey.indexOf('_'));
                    String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
                    Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);
    
                    list_futruedate.add(refdate);
                }

                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();

                if(list_futruedate.size() > 0) {
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_futruedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount, sum(Backlog_Qty__c) qty, Customer_Request_Date_Fiscal_Date__c refdate ');
                    list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
                    list_sql.add(' WHERE  Customer__r.APL_Relay_forecast_Plan_Account__c = \'' +  searchOb.grouping + '\' '
                            + ' And Customer__r.STATDESC__c = \'Active\' '
                            + ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
                            + ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
                            + ' And Customer_Request_Date_Fiscal_Year__c IN : years '
                            + ' And Customer_Request_Date_Fiscal_Month__c  IN : months '
                            + ' And Backlog_Amount_USD__c != 0 '
                            //update by nelson zheng 2015-10-21 for case 00900375
                        	//+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c = \'RPA\'  '
                        	 + ' And Profit_Center__c = \'APL\' '
                            + ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
                    System.debug('------APL_ClsRSMRelayService.cls (18 matches) 12-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.cbc2Code, years, months, null, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = searchOb.cbc2Code;
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                

                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
            
        }
        
        
    }
    
    public class SearchLevel4 extends APL_Interface.AAPLRemoteService {
        
        public override String saveSObjectData(String sData) { 
            try {
                APL_ClsEntityType.APLForecastValueObj valueobj = (APL_ClsEntityType.APLForecastValueObj)JSON.deserialize(sData,APL_ClsEntityType.APLForecastValueObj.class);
                system.debug('@#valueobj : '+valueobj);
                map<String, map<String, decimal>> map_partId_map_acctId_partPercent = new map<String, map<String, decimal>>();
                map<String, decimal> map_acctId_avgPercent = new map<String, decimal>();   
                map<String, map<String, map<String, APL_Sales_Forecast__c>>> map_partId_map_acctId_map_dateKey_fc 
                            = new map<String, map<String, map<String, APL_Sales_Forecast__c>>>();
                
                list<APL_Sales_Forecast__c> list_acctFC2Insert = new list<APL_Sales_Forecast__c>();
                list<APL_Sales_Forecast__c> list_acctFC2Update = new list<APL_Sales_Forecast__c>();
                list<APL_Sales_Forecast__c> list_acctFC2Delete = new list<APL_Sales_Forecast__c>();
                
                
                ClsAPLServiceRSMRelay.getPartPercentForSave(valueobj.grouping, valueobj.cbc2Code, valueobj.territoryCode, '',
                              map_acctId_avgPercent, map_partId_map_acctId_partPercent);
                APL_ClsUtils.getExistingProductCodeFC(valueobj.grouping, valueobj.cbc2Code, valueobj.territoryCode, '',
                            valueobj.map_year_quartersFuture, map_partId_map_acctId_map_dateKey_fc);
                valueobj.currencyIso = 'USD';
                APL_ClsUtils.generateProductFC(valueobj, map_partId_map_acctId_partPercent, map_partId_map_acctId_map_dateKey_fc, map_acctId_avgPercent,APL_ClsUtils.RELAYPRODUCTCODEFCTYPE, APL_ClsUtils.RSMFCTYPE,
                       list_acctFC2Insert, list_acctFC2Update, list_acctFC2Delete);             
                system.debug('Part list_acctFC2Insert :: ' + list_acctFC2Insert);
                system.debug('list_acctFC2Update:::: '+list_acctFC2Update);
                //INSERT, UPDATE, DELETE APL Forecasts
                ClsAPLForecastUtil.aplFCRecordsDML(list_acctFC2Insert, list_acctFC2Update, list_acctFC2Delete);
                return 'true';
            }catch(Exception ex) {
                throw ex;
            }
        }

        
        public override String getExistResult(String sData){
            APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb:'+searchOb);
            list<APL_ClsEntityType.RSMAccountObj> list_accFC = new list<APL_ClsEntityType.RSMAccountObj>();
            
            list<String> list_sql = new list<String>();
             
            list_sql.add(' Fiscal_Year__c year, Fiscal_Quarter__c quarter, PRODUCT_CDE__c procode, PROD_NAME__c proname, ' 
                    + ' sum(RSM_Quantity__c) quantity, sum(Current_month_1_RSM_quantity__c) preQuantity');
            list_sql.add(' APL_Sales_Forecast__c ');
            list_sql.add(' WHERE Customer__r.STATDESC__c = \'Active\' '
                //+ ClsAPLServiceRSMRelay.getRelayPartSearchQueryFilter(searchOb.cbc2Code, true)
                + ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
                + ' And Relay_CBC2_Code__c = \''+searchOb.cbc2Code+'\''
                + ClsAPLForecastUtil.getMonthFilter(searchOb.map_year_quartersFuture)
                + ' And Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' '  
                + ' Group by Fiscal_Year__c, Fiscal_Quarter__c, PRODUCT_CDE__c, PROD_NAME__c'); 
            
            map<String, APL_ClsEntityType.RSMAccountObj> map_acctId_acctFC = new map<String, APL_ClsEntityType.RSMAccountObj>();
            
            list<String> set_tempqy = new list<String>();
            
            String pricePlaces = APL_ClsUtils.getPricePlaces();
            //decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, searchOb.map_acctId_currencyIso.get(searchOb.grouping), 'USD');
            //decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, searchOb.currencyIso, 'USD');
            for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
                String accId = (String) result.get('procode'),
                       year = (String) result.get('year'),
                       quarter = (String) result.get('quarter'), 
                       dateKey = (year + '_' + quarter);
                if(set_tempqy.size() == 0) {
                    set_tempqy.add(year);
                    set_tempqy.add(quarter);
                }
                 
                APL_ClsEntityType.RSMAccountObj acctFC = new APL_ClsEntityType.RSMAccountObj();
                
                if(!map_acctId_acctFC.containsKey(accId)) {
                    APL_ClsUtils.createRSMRelayAccountObj(acctFC, searchOb.map_year_quartersFuture);
                    acctFC.id = APL_ClsUtils.getHexUID();
                    acctFC.name = (String) result.get('proname');
                    acctFC.accnumber = accId;
                    acctFC.price = 0;
                    acctFC.isHighLighted = false;
                    map_acctId_acctFC.put(accId, acctFC);
                }else {
                    acctFC = map_acctId_acctFC.get(accId);
                }
                
                //acctFC.map_type_FC.get('csFC').put(dateKey, (result.get('fc') != null ? ((decimal)result.get('fc') / currencyRate) : 0));
                acctFC.map_type_FC.get('quantity').put(dateKey, (result.get('quantity') != null ? (decimal)result.get('quantity') : 0));
                acctFC.map_type_FC.get('pmFC').put(dateKey, (result.get('preQuantity') != null ? (decimal)result.get('preQuantity') : 0));
                //acctFC.map_type_FC.get('rsmFC').put(dateKey, (result.get('rsmQuantity') != null ? (decimal)result.get('rsmQuantity') : 0));
                map_acctId_acctFC.put(accId, acctFC);
            }
            system.debug('@#set_tempqy : '+set_tempqy);
            if(set_tempqy.size() > 1){
				
                list_sql.clear();
                list_sql.add(' PRODUCT_CDE__c , RSM_Price__c ');
                list_sql.add(' APL_Sales_Forecast__c ');
                list_sql.add(' WHERE Customer__r.STATDESC__c = \'Active\' '
                    + ' And Relay_CBC2_Code__c = \''+searchOb.cbc2Code+'\''
                    + ' And Fiscal_Year__c = \''+set_tempqy.get(0)+'\' '
                    + ' And Fiscal_Quarter__c = \''+set_tempqy.get(1)+'\' '
                    + ' And PRODUCT_CDE__c != null '
                    + ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
                    + ' And Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' ');
                
                //system.debug('@#list_sql : '+APL_ClsUtils.getQueryString(list_sql));
                for(APL_Sales_Forecast__c result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
                    String accId = result.PRODUCT_CDE__c;
                    if(map_acctId_acctFC.containsKey(accId)) {
                        decimal price = (result.RSM_Price__c == null ? 0 : result.RSM_Price__c);
                        map_acctId_acctFC.get(accId).price = price.setScale((pricePlaces == '' ? 3 : Integer.valueOf(pricePlaces)));
                    }
                }

            }
            
            APL_ClsUtils.setHighlight(searchOb, APL_ClsUtils.RELAYFCTYPE, APL_ClsUtils.RSMFCTYPE, map_acctId_acctFC);
            
            list_accFC.addAll(map_acctId_acctFC.values());
            system.debug('@#list_accFC : '+list_accFC);
            return Json.serialize(list_accFC);
        }
        
        /**
         *  This function is used get all reference data list.
         *  
         * @author Juillet Yuan
         * @created 2014-10-29
         * @version 1.0
         * @since 31.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Juillet Yuan <Juillet.yuan@itbconsult.com>
         * - Created
         *
         */
        public override String getRefData(String sData) { 
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData,APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_currentdate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                Date currentdate = APL_ClsUtils.getCurrentFiscalDate();
                for(String datekey : searchOb.set_fiscalMonth) {
                    String year = datekey.substring(0, datekey.indexOf('_'));
                    String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
                    Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);

                    if(refdate < currentdate) {
                        list_beforedate.add(refdate);
                    }else if(refdate >= currentdate) {
                        list_currentdate.add(refdate);
                    }
                }
                
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();
                
                if(list_beforedate.size() > 0) {
                    
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_beforedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Quantity__c) billQty, sum(Book_Quantity__c) bookQty, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.STATDESC__c = \'Active\' '
                            + ' And Part__r.PRODUCT_CDE__c = \'' + searchOb.accnumber + '\' '
                            + ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
                            + ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
                            + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
                            //update by nelson zheng 2015-10-21 for case 00900375
                        	//+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c = \'RPA\'  '
                        	+ ' And Profit_Center__c = \'APL\'  '
                            + ' And Fiscal_Year__c IN : years '
                            + ' And Fiscal_Month__c IN : months '
                            + ' Group by Fiscal_Date__c ');
                    System.debug('------APL_ClsRSMRelayService.cls (18 matches) 13-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.accnumber, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
                    //current
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                        
                    APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
    
                    list<String> list_sql = new list<String>();
                        
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Qty__c) billQty, sum(Book_Qty__c) bookQty, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.STATDESC__c = \'Active\' '
                            + ' And Part__r.PRODUCT_CDE__c = \'' + searchOb.accnumber + '\' '
                            + ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
                            + ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
                            + ' And Fiscal_Year__c IN : years '
                            + ' And Fiscal_Month__c IN : months '
                            + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
                            //update by nelson zheng 2015-10-21 for case 00900375
                        	//+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c = \'RPA\'  '
                        	+ ' And Profit_Center__c = \'APL\'  '
                            + ' Group by Fiscal_Date__c  ' );
    
                    System.debug('------APL_ClsRSMRelayService.cls (18 matches) 14-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.accnumber, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = searchOb.accnumber;
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
        }
        
        /**
         *  This function is used get backlog reference data list.
         *  
         * @author Lei Tang
         * @created 2015-03-10
         * @version 1.0
         * @since 30.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Lei Tang <lei.tang@itbconsult.com>
         * - Created
         *
         */
        public override String getBacklogRefData(String sData) {
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                for(String datekey : searchOb.set_fiscalMonth) {
                    String year = datekey.substring(0, datekey.indexOf('_'));
                    String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
                    Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);
    
                    list_futruedate.add(refdate);
                }

                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();

                if(list_futruedate.size() > 0) {
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_futruedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount, sum(Backlog_Qty__c) qty, Customer_Request_Date_Fiscal_Date__c refdate ');
                    list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.STATDESC__c = \'Active\' '
                            + ' And Part__r.PRODUCT_CDE__c = \'' + searchOb.accnumber + '\' '
                            + ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
                            + ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
                            + ' And Customer_Request_Date_Fiscal_Year__c IN : years '
                            + ' And Customer_Request_Date_Fiscal_Month__c  IN : months '
                            + ' And Backlog_Amount_USD__c != 0 '
                            //update by nelson zheng 2015-10-21 for case 00900375
                        	//+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c = \'RPA\'  '
                        	 + ' And Profit_Center__c = \'APL\' '
                            + ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
                    System.debug('------APL_ClsRSMRelayService.cls (18 matches) 15-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.accnumber, years, months, null, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = searchOb.accnumber;
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
            
        }
        
        
    }
    
    public class SearchLevel5 extends APL_Interface.AAPLRemoteService {
        
        public override String saveSObjectData(String sData) { 
            try {
                APL_ClsEntityType.APLForecastValueObj valueobj = (APL_ClsEntityType.APLForecastValueObj)JSON.deserialize(sData,APL_ClsEntityType.APLForecastValueObj.class);
                system.debug('@#valueobj : '+valueobj);
                map<String, map<String, decimal>> map_partId_map_acctId_partPercent = new map<String, map<String, decimal>>();
                map<String, decimal> map_acctId_avgPercent = new map<String, decimal>();   
                map<String, map<String, map<String, APL_Sales_Forecast__c>>> map_partId_map_acctId_map_dateKey_fc 
                            = new map<String, map<String, map<String, APL_Sales_Forecast__c>>>();
                
                list<APL_Sales_Forecast__c> list_acctFC2Insert = new list<APL_Sales_Forecast__c>();
                list<APL_Sales_Forecast__c> list_acctFC2Update = new list<APL_Sales_Forecast__c>();
                list<APL_Sales_Forecast__c> list_acctFC2Delete = new list<APL_Sales_Forecast__c>();
                
                
                ClsAPLServiceRSMRelay.getPartPercentForSave(valueobj.grouping, valueobj.cbc2Code, valueobj.territoryCode, '',
                              map_acctId_avgPercent, map_partId_map_acctId_partPercent);
                              
                APL_ClsUtils.getExistingPartFC(valueobj.grouping, valueobj.cbc2Code, valueobj.territoryCode, '',
                            valueobj.map_year_quartersFuture, map_partId_map_acctId_map_dateKey_fc);
                valueobj.currencyIso = 'USD';
                APL_ClsUtils.generateProductFC(valueobj, map_partId_map_acctId_partPercent, map_partId_map_acctId_map_dateKey_fc, map_acctId_avgPercent,APL_ClsUtils.RELAYFCTYPE, APL_ClsUtils.RSMFCTYPE,
                       list_acctFC2Insert, list_acctFC2Update, list_acctFC2Delete);             
                system.debug('@#Part list_acctFC2Insert :: ' + list_acctFC2Insert);
                system.debug('@#list_acctFC2Update:::: '+list_acctFC2Update);
                //INSERT, UPDATE, DELETE APL Forecasts
                ClsAPLForecastUtil.aplFCRecordsDML(list_acctFC2Insert, list_acctFC2Update, list_acctFC2Delete);
                return 'true';
            }catch(Exception ex) {
                throw ex;
            }
        }

        public override String getExistResult(String sData){
            APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb:'+searchOb);
            list<APL_ClsEntityType.RSMAccountObj> list_accFC = new list<APL_ClsEntityType.RSMAccountObj>();
            
            list<String> list_sql = new list<String>();

            list_sql.add(' Fiscal_Year__c year, Fiscal_Quarter__c quarter, Part__c partId, Part__r.Product_Hierarchy__c gplId, Part__r.Description__c partDesc, Part__r.Name partName, ' 
                    + ' sum(RSM_Quantity__c) quantity, sum(Forecast__c) fc, sum(Current_month_1_RSM_quantity__c) preQuantity ');
            list_sql.add(' APL_Sales_Forecast__c ');
            list_sql.add(' WHERE Customer__r.STATDESC__c = \'Active\' '
                + ClsAPLServiceRSMRelay.getRelayPartSearchQueryFilter(searchOb.cbc2Code, true)
                + ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
                + ClsAPLForecastUtil.getMonthFilter(searchOb.map_year_quartersFuture)
                + ' And Type__c = \'' + APL_ClsUtils.RELAYFCTYPE + '\' ' 
                + ' And Part__r.PRODUCT_CDE__c = \'' + searchOb.accnumber + '\' '
                + ' Group by Part__c, Fiscal_Year__c, Fiscal_Quarter__c, Part__r.Product_Hierarchy__c, Part__r.Description__c, Part__r.Name'); 
            system.debug('@#list_sql : '+APL_ClsUtils.getQueryString(list_sql));
            map<String, APL_ClsEntityType.RSMAccountObj> map_acctId_acctFC = new map<String, APL_ClsEntityType.RSMAccountObj>();
            
            list<String> set_tempqy = new list<String>();
            
            String pricePlaces = APL_ClsUtils.getPricePlaces();
            //decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, searchOb.map_acctId_currencyIso.get(searchOb.grouping), 'USD');
            //decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, searchOb.currencyIso, 'USD');
            for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
                String accId = (String) result.get('partId'),
                       year = (String) result.get('year'),
                       quarter = (String) result.get('quarter'), 
                       dateKey = (year + '_' + quarter);
                if(set_tempqy.size() == 0) {
                    set_tempqy.add(year);
                    set_tempqy.add(quarter);
                }
                 
                APL_ClsEntityType.RSMAccountObj acctFC = new APL_ClsEntityType.RSMAccountObj();
                
                if(!map_acctId_acctFC.containsKey(accId)) {
                    APL_ClsUtils.createRSMRelayAccountObj(acctFC, searchOb.map_year_quartersFuture);
                    acctFC.id = accId;
                    acctFC.name = (String) result.get('partName');
                    acctFC.accnumber = (String) result.get('gplId');
                    acctFC.snumber = (String) result.get('partDesc');
                    acctFC.price = 0;
                    map_acctId_acctFC.put(accId, acctFC);
                }else {
                    acctFC = map_acctId_acctFC.get(accId);
                }
                
                //acctFC.map_type_FC.get('csFC').put(dateKey, (result.get('fc') != null ? ((decimal)result.get('fc') / currencyRate) : 0));
                acctFC.map_type_FC.get('quantity').put(dateKey, (result.get('quantity') != null ? (decimal)result.get('quantity') : 0));
                acctFC.map_type_FC.get('pmFC').put(dateKey, (result.get('preQuantity') != null ? (decimal)result.get('preQuantity') : 0));
                //acctFC.map_type_FC.get('rsmFC').put(dateKey, (result.get('rsmQuantity') != null ? (decimal)result.get('rsmQuantity') : 0));
                map_acctId_acctFC.put(accId, acctFC);
            }
            
            if(set_tempqy.size() > 1){

                list_sql.clear();
                list_sql.add(' Part__c , RSM_Price__c ');
                list_sql.add(' APL_Sales_Forecast__c ');
                list_sql.add(' WHERE Customer__r.STATDESC__c = \'Active\' '
                    + ClsAPLServiceRSMRelay.getRelayPartSearchQueryFilter(searchOb.cbc2Code, true)
                    + ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
                    + ' And Type__c = \'' + ClsGroupingRelayForecastUtil.RELAYFCTYPE + '\' ' 
                    + ' And Part__r.PRODUCT_CDE__c = \'' + searchOb.accnumber + '\' '
                    + ' And Fiscal_Year__c = \''+set_tempqy.get(0)+'\' '
                    + ' And Fiscal_Quarter__c = \''+set_tempqy.get(1)+'\' ');
                for(APL_Sales_Forecast__c result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
                    String accId = result.Part__c;
                    if(map_acctId_acctFC.containsKey(accId)) {
                        decimal price = (result.RSM_Price__c == null ? 0 : result.RSM_Price__c);
                        map_acctId_acctFC.get(accId).price = price.setScale((pricePlaces == '' ? 3 : Integer.valueOf(pricePlaces)));
                    }
                }
            }
            
            list_accFC.addAll(map_acctId_acctFC.values());

            return Json.serialize(list_accFC);
        }
        
        /**
         *  This function is used get all reference data list.
         *  
         * @author Juillet Yuan
         * @created 2014-10-29
         * @version 1.0
         * @since 31.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Juillet Yuan <Juillet.yuan@itbconsult.com>
         * - Created
         *
         */
        public override String getRefData(String sData) { 
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData,APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_currentdate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                Date currentdate = APL_ClsUtils.getCurrentFiscalDate();
                for(String datekey : searchOb.set_fiscalMonth) {
                    String year = datekey.substring(0, datekey.indexOf('_'));
                    String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
                    Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);

                    if(refdate < currentdate) {
                        list_beforedate.add(refdate);
                    }else if(refdate >= currentdate) {
                        list_currentdate.add(refdate);
                    }
                }
                
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();
                
                if(list_beforedate.size() > 0) {
                    
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_beforedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Quantity__c) billQty, sum(Book_Quantity__c) bookQty, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.STATDESC__c = \'Active\' '
                            + ' And Part__c = \'' + searchOb.partId + '\' '
                            + ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
                            + ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
                            + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
                            //update by nelson zheng 2015-10-21 for case 00900375
                        	//+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c = \'RPA\'  '
                        	+ ' And Profit_Center__c = \'APL\'  '
                            + ' And Fiscal_Year__c IN : years '
                            + ' And Fiscal_Month__c IN : months '
                            + ' Group by Fiscal_Date__c ');
                    System.debug('------APL_ClsRSMRelayService.cls (18 matches) 151-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.partId, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
                    //current
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                        
                    APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
    
                    list<String> list_sql = new list<String>();
                        
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Qty__c) billQty, sum(Book_Qty__c) bookQty, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.STATDESC__c = \'Active\' '
                            + ' And Part__c = \'' + searchOb.partId + '\' '
                            + ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
                            + ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
                            + ' And Fiscal_Year__c IN : years '
                            + ' And Fiscal_Month__c IN : months '
                            + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
                            //update by nelson zheng 2015-10-21 for case 00900375
                        	//+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c = \'RPA\'  '
                        	+ ' And Profit_Center__c = \'APL\'  '
                            + ' Group by Fiscal_Date__c  ' );
    
                    System.debug('------APL_ClsRSMRelayService.cls (18 matches) 16-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.partId, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = searchOb.partId;
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
        }
        
        /**
         *  This function is used get backlog reference data list.
         *  
         * @author Lei Tang
         * @created 2015-03-10
         * @version 1.0
         * @since 30.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Lei Tang <lei.tang@itbconsult.com>
         * - Created
         *
         */
        public override String getBacklogRefData(String sData) {
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                for(String datekey : searchOb.set_fiscalMonth) {
                    String year = datekey.substring(0, datekey.indexOf('_'));
                    String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
                    Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);
    
                    list_futruedate.add(refdate);
                }

                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();

                if(list_futruedate.size() > 0) {
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_futruedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount, sum(Backlog_Qty__c) qty, Customer_Request_Date_Fiscal_Date__c refdate ');
                    list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.STATDESC__c = \'Active\' '
                            + ' And Part__c = \'' + searchOb.partId + '\' '
                            + ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
                            + ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
                            + ' And Customer_Request_Date_Fiscal_Year__c IN : years '
                            + ' And Customer_Request_Date_Fiscal_Month__c  IN : months '
                            + ' And Backlog_Amount_USD__c != 0 '
                            //update by nelson zheng 2015-10-21 for case 00900375
                        	//+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c = \'RPA\'  '
                        	 + ' And Profit_Center__c = \'APL\' '
                            + ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
                    System.debug('------APL_ClsRSMRelayService.cls (18 matches) 17-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.partId, years, months, null, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = searchOb.partId;
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);

                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
            
        }
        
    }
}