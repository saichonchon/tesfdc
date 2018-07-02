/**
 *  This class is CSD Sales Person View Service.
 *  
 * @author Lei Tang
 * @created 2014-09-19
 * @version 1.0
 * @since 30.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2014-09-19 Lei Tang <lei.tang@itbconsult.com>
 * - Created
 *
 *
 * @changelog
 * 2016-04-08 Mingxing <Qiumingxing.qiu@oinio.com>
 * - Created
 */
public without sharing class CSD_ClsSalesPersonViewService extends CSD_Interface.ACSDCtrlService  {

    /**
     *  This class is get Soldto level data.
     *  
     * @author Lei Tang
     * @created 2014-10-28
     * @version 1.0
     * @since 30.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2014-10-28 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public override void setLevel1Data(list<Object> list_data, Object config) {
        //list<CSD_ClsEntityType.SoldToValueObj> list_soldto = new list<CSD_ClsEntityType.SoldToValueObj>();
        CSD_ClsEntityType.PageConfig pageconf = (CSD_ClsEntityType.PageConfig)config;
        
        CSD_ClsEntityType.AccountObj totalFC = new CSD_ClsEntityType.AccountObj();
        CSD_ClsUtils.createAccountObj(totalFC, pageconf.map_financialMonth);
        String hexid = CSD_ClsUtils.getHexUID();
        totalFC.id = hexid;
        totalFC.accnumber = 'Total';
        totalFC.name = 'Total';
        totalFC.type = 'total';
        list_data.add(totalFC);
        
        list<String> list_sql = new list<String>();
        set<String> set_acctIds = new set<String>();
        
        list<CSD_ClsEntityType.UserObj> list_users = new list<CSD_ClsEntityType.UserObj>();
        CSD_ClsUtils.setSubordinateUserForMultilevelHead(pageconf.managerId, list_users);
        
        set<String> set_userIds = new set<String>();
        set_userIds.add(pageconf.managerId);
        for(CSD_ClsEntityType.UserObj userobj : list_users) {
            set_userIds.add(userobj.id);
        }
        
        CSD_ClsUtils.setTerritoryAccountSetBySubordinate(set_acctIds, set_userIds);
        
        Date currentdate = Date.valueOf(pageconf.refStartDate);
        Date enddate = Date.valueOf(pageconf.refEndDate);
        
        /*list_sql.add('Sold_To_Number__c soldto');
        list_sql.add(' CSD_Sales_Forecast__c ');
        list_sql.add(' WHERE Type__c = \'Sold-To\' '
                    + ' And Sold_To_Number__c in : set_acctIds ' 
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Sold_To_Number__c ');
        //Generate forecast view object
        */
        map<String, CSD_ClsEntityType.AccountObj> map_acctId_acctFC = new map<String, CSD_ClsEntityType.AccountObj>();
        
        map<Integer, set<String>> map_set_soldto = new map<Integer, set<String>>();
        Integer i = 0;
        for(String result : set_acctIds) {
            Integer num = i/150;
            if(map_set_soldto.containsKey(num)) {
                map_set_soldto.get(num).add(result);
            }else {
                set<String> set_soldto = new set<String>();
                set_soldto.add(result);
                map_set_soldto.put(num, set_soldto);
            }
            i++;
        }
        
        for(Integer num : map_set_soldto.keySet()) {
            getExistResultForMore(pageconf, map_acctId_acctFC, currentdate, enddate, map_set_soldto.get(num));
        }
        system.debug('@#map_acctId_acctFC.size : '+map_acctId_acctFC.size());
        list<CSD_ClsEntityType.AccountObj> list_accFc = new list<CSD_ClsEntityType.AccountObj>();
        list_accFc.addAll(map_acctId_acctFC.values());
        list_accFc.sort();
        for(Integer y = 0; y < list_accFc.size(); y++) {
            list_data.add(list_accFc.get(y));
        }
        
        map_acctId_acctFC.clear();
        system.debug('@#list_data.size : '+list_data.size());
        list_sql.clear();
        map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result =
            new map<String, map<String, AggregateResult>>();
        list_sql.add(' Fiscal_Year__c year, Fiscal_Month__c month, '
                + 'sum(DC_Forecast_Amount__c) sumDCFC, sum(Forecast__c) sumFC, sum(Previous_Month_Forecast__c) sumPMFC');
                    
        list_sql.add(' CSD_Sales_Forecast__c ');
        list_sql.add(' WHERE Type__c = \'Rest-SoldTo\' '
                    + ' And Sold_To_Number__c in : set_acctIds ' 
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Fiscal_Year__c, Fiscal_Month__c ');
        
        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
            //system.debug('@#result : '+result);
            //accId = (String)result.get('soldto'), 
            String year = (String) result.get('year'),
                   month = (String) result.get('month'), 
                   dateKey = (year + '_' + month);
                   
            CSD_ClsUtils.setResultMap(result, CSD_ClsUtils.RESTSOLDTOID, dateKey, map_acctId_map_dateKey_result);       
                   
        }
        
        CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
        acctFC.id = CSD_ClsUtils.RESTSOLDTOID;
        acctFC.accnumber = 'Rest Sold To Accounts';
        acctFC.name = 'Rest Sold To Accounts';
        acctFC.csFC = new map<String, decimal>();
        acctFC.dcFC = new map<String, decimal>();
        acctFC.pmFC = new map<String, decimal>();
        map_acctId_acctFC.put(CSD_ClsUtils.RESTSOLDTOID, acctFC);
        for(String year : pageconf.map_financialMonth.keySet()) {
            for(Integer month : pageconf.map_financialMonth.get(year)) {
                String dateKey = (year + '_' + String.valueOf(month));
                AggregateResult result;
                
                if(map_acctId_map_dateKey_result.containsKey(CSD_ClsUtils.RESTSOLDTOID) 
                    && map_acctId_map_dateKey_result.get(CSD_ClsUtils.RESTSOLDTOID).containsKey(dateKey)) {
                    
                    result = map_acctId_map_dateKey_result.get(CSD_ClsUtils.RESTSOLDTOID).get(dateKey);
                }
                
                if(result != null) {
                    map_acctId_acctFC.get(CSD_ClsUtils.RESTSOLDTOID).csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
                    map_acctId_acctFC.get(CSD_ClsUtils.RESTSOLDTOID).dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
                    map_acctId_acctFC.get(CSD_ClsUtils.RESTSOLDTOID).pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
                }else {
                    map_acctId_acctFC.get(CSD_ClsUtils.RESTSOLDTOID).csFC.put(dateKey, 0);
                    map_acctId_acctFC.get(CSD_ClsUtils.RESTSOLDTOID).dcFC.put(dateKey, 0);
                    map_acctId_acctFC.get(CSD_ClsUtils.RESTSOLDTOID).pmFC.put(dateKey, 0);
                }

            }
        }       
        
        system.debug('@#map_acctId_acctFC.size : '+map_acctId_acctFC.size());
        for(CSD_ClsEntityType.AccountObj obj : map_acctId_acctFC.values()) {
            system.debug('@#obj :'+obj);
            list_data.add(obj);
        }
        //list_data.addAll();
        //system.debug('@#list_data :'+list_data);
    }
    
    private void getExistResultForMore(CSD_ClsEntityType.PageConfig pageconf, map<String, CSD_ClsEntityType.AccountObj> map_acctId_acctFC, Date currentdate, Date enddate, set<String> set_key) {
            
        list<String> list_sql = new list<String>();
        list_sql.add('Sold_To_Number__c soldto, Sold_To_Name__c name, Fiscal_Year__c year, Fiscal_Month__c month, '
                + 'sum(DC_Forecast_Amount__c) sumDCFC, sum(Forecast__c) sumFC, sum(Previous_Month_Forecast__c) sumPMFC');
                    
        list_sql.add(' CSD_Sales_Forecast__c ');
        list_sql.add(' WHERE Type__c = \'Sold-To\' '
                    + ' And Sold_To_Number__c in : set_key ' 
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, Sold_To_Number__c, Sold_To_Name__c ');

        map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result =
            new map<String, map<String, AggregateResult>>();
        
        map<String, String> map_accId_name = new map<String, String>();
        
        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
            //system.debug('@#result : '+result);
            String accId = (String)result.get('soldto'), 
                   year = (String) result.get('year'),
                   month = (String) result.get('month'), 
                   dateKey = (year + '_' + month);
            map_accId_name.put(accId, (String)result.get('name'));       
            CSD_ClsUtils.setResultMap(result, accId, dateKey, map_acctId_map_dateKey_result);       
                   
        }
        //system.debug('@#map_acctId_map_dateKey_result :'+map_acctId_map_dateKey_result.keySet());
        for(String acctId : map_acctId_map_dateKey_result.keySet()) {
            CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
            Blob aes = Crypto.generateAesKey(128);
            String hex = EncodingUtil.convertToHex(aes);
            acctFC.id = hex;
            acctFC.accnumber = acctId;
            acctFC.name = (map_accId_name.containsKey(acctId) ? map_accId_name.get(acctId) : null);
            acctFC.csFC = new map<String, decimal>();
            acctFC.dcFC = new map<String, decimal>();
            acctFC.pmFC = new map<String, decimal>();
            
            map_acctId_acctFC.put(acctId, acctFC);
            
            
            for(String year : pageconf.map_financialMonth.keySet()) {
                for(Integer month : pageconf.map_financialMonth.get(year)) {
                    String dateKey = (year + '_' + String.valueOf(month));
                    AggregateResult result;
                    //system.debug('@#dateKey :'+dateKey);
                    if(map_acctId_map_dateKey_result.containsKey(acctId) 
                        && map_acctId_map_dateKey_result.get(acctId).containsKey(dateKey)) {
                        
                        result = map_acctId_map_dateKey_result.get(acctId).get(dateKey);
                    }
                    //system.debug('@#result :'+result);
                    if(result != null) {
                        //map_acctId_acctFC.get(acctId).name = (String)result.get('accname');
                        map_acctId_acctFC.get(acctId).csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
                        map_acctId_acctFC.get(acctId).dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
                        map_acctId_acctFC.get(acctId).pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
                        
                    }else {
                        map_acctId_acctFC.get(acctId).csFC.put(dateKey, 0);
                        map_acctId_acctFC.get(acctId).dcFC.put(dateKey, 0);
                        map_acctId_acctFC.get(acctId).pmFC.put(dateKey, 0);
                    }               
                }
            }
        }
            
    }
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
     
    //********************************* -=BEGIN public methods=- **********************************

    /**
     *  This class is Soldto level remote service.
     *  
     * @author Lei Tang
     * @created 2014-10-28
     * @version 1.0
     * @since 30.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2014-10-28 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public class SearchLevel1 extends CSD_Interface.ACSDRemoteService{

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
                CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
                
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                CSD_ClsUtils.setRefDatelist(list_beforedate, list_futruedate, searchOb.set_fiscalMonth);
                
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();
                
                if(list_beforedate.size() > 0) {
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    CSD_ClsUtils.setRefForecastDate(years, months, list_beforedate);
                    
                    list<String> list_beforesql = new list<String>();
                    list_beforesql.add(' Customer__r.AccountNumber refId, sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                    list_beforesql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_beforesql.add(' WHERE Customer__r.AccountNumber = \''+ searchOb.accnumber +'\' '
                        + ' And Customer__r.STATDESC__c = \'Active\' '
                        + ' And Fiscal_Year__c IN : years '
                        + ' And Fiscal_Month__c IN : months '
                        + ' Group by Customer__r.AccountNumber, Fiscal_Date__c ');
                    CSD_ClsUtils.setSoldToMapRefData(years, months, list_beforedate, list_beforesql, map_acctId_map_dateKey_result_before);
                }
                
                CSD_ClsEntityType.CSDRefObj refdata = CSD_ClsUtils.createRefDataObj();
                refdata.id = searchOb.accnumber;
                
                CSD_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
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
                CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
                
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();

                CSD_ClsUtils.setRefDatelist(list_beforedate, list_futruedate, searchOb.set_fiscalMonth);

                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();
                
                if(list_futruedate.size() > 0) {
                    //futrue
                    // Updata the  Mingxing Qiu time is  2016-04-08
                    /*set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    CSD_ClsUtils.setRefForecastDate(years, months, list_futruedate);
                    
                    list<String> list_futruesql = new list<String>();
                    list_futruesql.add(' Customer__r.AccountNumber refId, sum(Backlog_Amount_USD__c) amount, Fiscal_Date__c refdate');
                    list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
                    list_futruesql.add(' WHERE Customer__r.AccountNumber = \''+ searchOb.accnumber +'\' '
                        + ' And Customer__r.STATDESC__c = \'Active\' '
                        + ' And Fiscal_Year__c IN : years '
                        + ' And Fiscal_Month__c IN : months '
                        + ' Group by Customer__r.AccountNumber, Fiscal_Date__c ');      
                    CSD_ClsUtils.setSoldToMapRefData(years, months, list_futruedate, list_futruesql, map_acctId_map_dateKey_result_futrue);
                */
                    for(Date currentdate : list_futruedate) {
                        Date startDate = currentdate.toStartOfMonth();
                        Date endDate = currentdate.toStartOfMonth().addMonths(1).addDays(-1);
                        String monthlabel = CSD_ClsUtils.MAP_NUMBERMONTHLABEL.get(currentdate.month());
                        for (Period period : [select Id, PeriodLabel, StartDate, EndDate
                                                from Period where FiscalYearSettings.Name = :String.valueOf(currentdate.year()) 
                                                and Type = 'Month' and PeriodLabel = :monthlabel]) {
                            
                            startDate = period.StartDate;
                            endDate = period.EndDate;
                        }
                        list<String> list_futruesql = new list<String>();
                        list_futruesql.add(' Customer__r.AccountNumber refId, sum(Backlog_Amount_USD__c) amount  ');
                        list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
                        list_futruesql.add(' WHERE Customer__r.AccountNumber = \''+ searchOb.accnumber +'\' '
                            + ' And Customer__r.STATDESC__c = \'Active\' '
                            + ' And Customer_Request_Date__c >= :startDate '
                            + ' And Customer_Request_Date__c <= :endDate '
                            + ' Group by Customer__r.AccountNumber ');      
                        CSD_ClsUtils.setSoldToMapRefDataBacklog(currentdate, startDate, endDate, list_futruesql, map_acctId_map_dateKey_result_futrue);
                
                    }
                }

                CSD_ClsEntityType.CSDRefObj refdata = CSD_ClsUtils.createRefDataObj();
                refdata.id = searchOb.accnumber;
                
                CSD_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata,
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
        } 
    }


    public class SearchRestSoldTo extends CSD_Interface.ACSDRemoteService{

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
                CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();

                CSD_ClsUtils.setRefDatelist(list_beforedate, list_futruedate, searchOb.set_fiscalMonth);

                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();
                
                
                set<String> set_acctIds = new set<String>();
        
                list<CSD_ClsEntityType.UserObj> list_users = new list<CSD_ClsEntityType.UserObj>();
                CSD_ClsUtils.setSubordinateUserForMultilevelHead(searchOb.managerId, list_users);
                
                set<String> set_userIds = new set<String>();
                set_userIds.add(searchOb.managerId);
                for(CSD_ClsEntityType.UserObj userobj : list_users) {
                    set_userIds.add(userobj.id);
                }
                
                CSD_ClsUtils.setTerritoryAccountSetBySubordinate(set_acctIds, set_userIds);

                set<String> set_restacctIds = new set<String>();
                for(String accnum : set_acctIds) {
                    if(!searchOb.set_selectedId.contains(accnum)) {
                        set_restacctIds.add(accnum);
                    }
                }
                
                if(list_beforedate.size() > 0 && set_restacctIds.size() > 0) {
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    CSD_ClsUtils.setRefForecastDate(years, months, list_beforedate);
                    
                    list<String> list_beforesql = new list<String>();
                    list_beforesql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                    list_beforesql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_beforesql.add(' WHERE Customer__r.AccountNumber IN :set_perm  '
                        + ' And Customer__r.STATDESC__c = \'Active\' '
                        + ' And Fiscal_Year__c IN : years '
                        + ' And Fiscal_Month__c IN : months '
                        + ' Group by Fiscal_Date__c ');
                    CSD_ClsUtils.setTotelBillingData(years, months, set_restacctIds, list_beforesql, map_acctId_map_dateKey_result_before);
                }
                
                CSD_ClsEntityType.CSDRefObj refdata = CSD_ClsUtils.createRefDataObj();
                refdata.id = 'Total';
                
                CSD_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata,
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
                CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
                
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();

                CSD_ClsUtils.setRefDatelist(list_beforedate, list_futruedate, searchOb.set_fiscalMonth);

                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();
                
                set<String> set_acctIds = new set<String>();
        
                list<CSD_ClsEntityType.UserObj> list_users = new list<CSD_ClsEntityType.UserObj>();
                CSD_ClsUtils.setSubordinateUserForMultilevelHead(searchOb.managerId, list_users);
                
                set<String> set_userIds = new set<String>();
                set_userIds.add(searchOb.managerId);
                for(CSD_ClsEntityType.UserObj userobj : list_users) {
                    set_userIds.add(userobj.id);
                }
                
                CSD_ClsUtils.setTerritoryAccountSetBySubordinate(set_acctIds, set_userIds);

                set<String> set_restacctIds = new set<String>();
                for(String accnum : set_acctIds) {
                    if(!searchOb.set_selectedId.contains(accnum)) {
                        set_restacctIds.add(accnum);
                    }
                }
                
                if(list_futruedate.size() > 0 && set_restacctIds.size() > 0) {
                    //futrue
                    // Updata the  Mingxing Qiu time is  2016-04-08
                    /*set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    CSD_ClsUtils.setRefForecastDate(years, months, list_futruedate);
                    
                    list<String> list_futruesql = new list<String>();
                    list_futruesql.add(' sum(Backlog_Amount_USD__c) amount, Fiscal_Date__c refdate');
                    list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
                    list_futruesql.add(' WHERE Customer__r.AccountNumber IN :set_perm  '
                        + ' And Customer__r.STATDESC__c = \'Active\' '
                        + ' And Fiscal_Year__c IN : years '
                        + ' And Fiscal_Month__c IN : months '
                        + ' Group by Fiscal_Date__c '); 
                    CSD_ClsUtils.setTotelBillingData(years, months, set_restacctIds, list_futruesql, map_acctId_map_dateKey_result_futrue);
                */
                    for(Date currentdate : list_futruedate) {
                        Date startDate = currentdate.toStartOfMonth();
                        Date endDate = currentdate.toStartOfMonth().addMonths(1).addDays(-1);
                        String monthlabel = CSD_ClsUtils.MAP_NUMBERMONTHLABEL.get(currentdate.month());
                        for (Period period : [select Id, PeriodLabel, StartDate, EndDate
                                                from Period where FiscalYearSettings.Name = :String.valueOf(currentdate.year()) 
                                                and Type = 'Month' and PeriodLabel = :monthlabel]) {
                            
                            startDate = period.StartDate;
                            endDate = period.EndDate;
                        }
                         list<String> list_futruesql = new list<String>();
                        list_futruesql.add(' sum(Backlog_Amount_USD__c) amount ');
                        list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
                        list_futruesql.add(' WHERE Customer__r.AccountNumber IN :set_perm  '
                            + ' And Customer__r.STATDESC__c = \'Active\' '
                               + ' And Customer_Request_Date__c >= :startDate '
                            + ' And Customer_Request_Date__c <= :endDate '); 
                        CSD_ClsUtils.setTotelBillingDataBacklog(currentdate, startDate, endDate, set_restacctIds, list_futruesql, map_acctId_map_dateKey_result_futrue);
                    
                    }
                }

                CSD_ClsEntityType.CSDRefObj refdata = CSD_ClsUtils.createRefDataObj();
                refdata.id = 'Total';
                
                CSD_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata,
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
        } 

    }


    public class SearchLevel2 extends CSD_Interface.ACSDRemoteService{
        
        
        
        /**
         *  This function is get value of OEM level by SoldTO level
         *  
         * @author Lei Tang
         * @created 2014-10-28
         * @version 1.0
         * @since 30.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-28 Lei Tang <lei.tang@itbconsult.com>
         * - Created
         *
        */
        public override String getExistResult(String sData){
            
            CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData, CSD_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb'+searchOb);
            
            Date currentdate = Date.valueOf(searchOb.startDate);
            Date enddate = Date.valueOf(searchOb.endDate);
            
            list<String> list_sql = new list<String>();
            
            list_sql.add('OEM__c oem, OEM__r.Name accname, Fiscal_Year__c year, Fiscal_Month__c month,'
                + ' sum(Quantity__c) quantity, sum(Forecast__c) forecast, sum(Price__c) price, sum(Rest_Parts_Forecast__c) restPNFC,'
                + ' sum(DC_Forecast_Amount__c) sumDCFC, sum(Previous_Month_Forecast__c) sumPMFC');
                    
            list_sql.add(' CSD_Sales_Forecast__c ');
            list_sql.add(' WHERE Sold_To_Number__c = \''+ searchOb.accnumber +'\' ' 
                    + ' And Type__c = \'OEM\''
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by OEM__c, OEM__r.Name, Fiscal_Year__c, Fiscal_Month__c  ');
            
            map<String, CSD_ClsEntityType.AccountObj> map_acctId_acctFC = new map<String, CSD_ClsEntityType.AccountObj>();
        
            map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result =
                new map<String, map<String, AggregateResult>>();
            
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                //system.debug('@#result : '+result);
                String accId = (String)result.get('oem'), 
                       year = (String)result.get('year'),
                       month = (String)result.get('month'), 
                       dateKey = (year + '_' + month);
                       
                CSD_ClsUtils.setResultMap(result, accId, dateKey, map_acctId_map_dateKey_result);       
                
            }
            
            //map<String, set<Integer>> map_year_monthsFuture = (map<String, set<Integer>>)JSON.deserialize(searchOb.str_futureMonthMap, map<String, set<Integer>>.class);
            
            for(String acctId : map_acctId_map_dateKey_result.keySet()) {
                CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
                acctFC.id = acctId;
                acctFC.csFC = new map<String, decimal>();
                acctFC.restPNFC = new map<String, decimal>();
                acctFC.dcFC = new map<String, decimal>();
                acctFC.pmFC = new map<String, decimal>();

                map_acctId_acctFC.put(acctId, acctFC);
                
                
                for(String year : searchOb.map_year_monthsFuture.keySet()) {
                    for(Integer month : searchOb.map_year_monthsFuture.get(year)) {
                        String dateKey = (year + '_' + String.valueOf(month));
                        AggregateResult result;
                        system.debug('@#dateKey :'+dateKey);
                        if(map_acctId_map_dateKey_result.containsKey(acctId) 
                            && map_acctId_map_dateKey_result.get(acctId).containsKey(dateKey)) {
                            
                            result = map_acctId_map_dateKey_result.get(acctId).get(dateKey);
                        }
                        system.debug('@#result :'+result);
                        if(result != null) {
                            map_acctId_acctFC.get(acctId).name = (String)result.get('accname');
                            map_acctId_acctFC.get(acctId).csFC.put(dateKey, (result.get('forecast') != null ? (decimal)result.get('forecast') : 0));
                            map_acctId_acctFC.get(acctId).restPNFC.put(dateKey, (result.get('restPNFC') != null ? (decimal)result.get('restPNFC') : 0));
                            map_acctId_acctFC.get(acctId).dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
                            map_acctId_acctFC.get(acctId).pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
                        }else {
                            map_acctId_acctFC.get(acctId).csFC.put(dateKey, 0);
                            map_acctId_acctFC.get(acctId).restPNFC.put(dateKey, 0);
                            map_acctId_acctFC.get(acctId).dcFC.put(dateKey, 0);
                            map_acctId_acctFC.get(acctId).pmFC.put(dateKey, 0);
                        }                       
                    }
                }
            }
            
            if(CSD_Configuration__c.getInstance('Non OEM Account') != null && CSD_Configuration__c.getInstance('Non OEM Account').Value__c != null) {
                String nonoemid = CSD_Configuration__c.getInstance('Non OEM Account').Value__c;
                list_sql.clear();
                map_acctId_map_dateKey_result.clear();
                list_sql.add('OEM__c oem, OEM__r.Name accname, Fiscal_Year__c year, Fiscal_Month__c month, '
                    + ' sum(Quantity__c) quantity, sum(Forecast__c) forecast, sum(Price__c) price, sum(Rest_Parts_Forecast__c) restPNFC, '
                    + ' sum(DC_Forecast_Amount__c) sumDCFC, sum(Previous_Month_Forecast__c) sumPMFC');
                            
                list_sql.add(' CSD_Sales_Forecast__c ');
                list_sql.add(' WHERE Sold_To_Number__c = \''+ searchOb.accnumber +'\' ' 
                        + ' And Type__c = \'Non-OEMs\''
                        + ' And Fiscal_Date__c >= : currentdate '
                        + ' And Fiscal_Date__c < : enddate '
                        + ' Group by OEM__c, OEM__r.Name, Fiscal_Year__c, Fiscal_Month__c  ');
                
                for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                    //system.debug('@#result : '+result);
                    String accId = (String)result.get('oem'), 
                           year = (String) result.get('year'),
                           month = (String) result.get('month'), 
                           dateKey = (year + '_' + month);
                    //system.debug('@#result :' + result);
                    CSD_ClsUtils.setResultMap(result, nonoemid, dateKey, map_acctId_map_dateKey_result);       
                           
                }
                
                CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
                acctFC.id = nonoemid;
                acctFC.name = 'NON OEM';
                acctFC.csFC = new map<String, decimal>();
                acctFC.dcFC = new map<String, decimal>();
                acctFC.pmFC = new map<String, decimal>();
                acctFC.restPNFC = new map<String, decimal>();
                map_acctId_acctFC.put(nonoemid, acctFC);
                for(String year : searchOb.map_year_monthsFuture.keySet()) {
                    for(Integer month : searchOb.map_year_monthsFuture.get(year)) {
                        String dateKey = (year + '_' + String.valueOf(month));
                        AggregateResult result;
                        
                        if(map_acctId_map_dateKey_result.containsKey(nonoemid) 
                            && map_acctId_map_dateKey_result.get(nonoemid).containsKey(dateKey)) {
                            
                            result = map_acctId_map_dateKey_result.get(nonoemid).get(dateKey);
                        }
                        
                        system.debug('@#result :' + result);
                        if(result != null) {
                            
                            map_acctId_acctFC.get(nonoemid).csFC.put(dateKey, (result.get('forecast') != null ? (decimal)result.get('forecast') : 0));
                            map_acctId_acctFC.get(nonoemid).restPNFC.put(dateKey, (result.get('restPNFC') != null ? (decimal)result.get('restPNFC') : 0));
                            map_acctId_acctFC.get(nonoemid).dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
                            map_acctId_acctFC.get(nonoemid).pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
                        }else {
                            map_acctId_acctFC.get(nonoemid).csFC.put(dateKey, 0);
                            map_acctId_acctFC.get(nonoemid).restPNFC.put(dateKey, 0);
                            map_acctId_acctFC.get(nonoemid).dcFC.put(dateKey, 0);
                            map_acctId_acctFC.get(nonoemid).pmFC.put(dateKey, 0);
                        }
    
                    }
                }   

            }
            
            list<CSD_ClsEntityType.AccountObj> list_accFC = new list<CSD_ClsEntityType.AccountObj>();
            list_accFC.addAll(map_acctId_acctFC.values());
            list_accFC.sort();
        
            system.debug('@#list_accFC :' + list_accFC);
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
                CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
                
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                CSD_ClsUtils.setRefDatelist(list_beforedate, list_futruedate, searchOb.set_fiscalMonth);
                
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();
                
                
                
                
                if(list_beforedate.size() > 0) {
                    //before    
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    CSD_ClsUtils.setRefForecastDate(years, months, list_beforedate);
                    
                    set<String> set_monthIds = new set<String>();
                    for(CSD_OEM_Mapping_Monthly_BBB__c csdmap : [select Monthly_Billings_Bookings_by_Part__c 
                                                                    from CSD_OEM_Mapping_Monthly_BBB__c 
                                                                    where Monthly_Billings_Bookings_by_Part__r.Fiscal_Year__c IN :years
                                                                        and Monthly_Billings_Bookings_by_Part__r.Fiscal_Month__c IN :months
                                                                        and Monthly_Billings_Bookings_by_Part__r.Customer__r.STATDESC__c = 'Active'
                                                                        and Monthly_Billings_Bookings_by_Part__r.Customer__r.AccountNumber = :searchOb.accnumber 
                                                                        and OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
                        set_monthIds.add(csdmap.Monthly_Billings_Bookings_by_Part__c);
                    }
                    
                    
                    list<String> list_beforesql = new list<String>();
                    list_beforesql.add(' Customer__r.AccountNumber refId, sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                    list_beforesql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_beforesql.add(' WHERE Id IN :set_monthids '
                            + ' Group by Customer__r.AccountNumber, Fiscal_Date__c ');
                    CSD_ClsUtils.setOEMPartMapRefData(set_monthIds, list_beforesql, map_acctId_map_dateKey_result_before);
                    
                }
                
                CSD_ClsEntityType.CSDRefObj refdata = CSD_ClsUtils.createRefDataObj();
                refdata.id = searchOb.accnumber;

                CSD_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
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
                CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
                
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();

                CSD_ClsUtils.setRefDatelist(list_beforedate, list_futruedate, searchOb.set_fiscalMonth);

                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();
                
                if(list_futruedate.size() > 0) {
                    //futrue
                    // Updata the  Mingxing Qiu time is  2016-04-08
                    /*set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    CSD_ClsUtils.setRefForecastDate(years, months, list_futruedate);
                    
                    set<String> set_dailyIds = new set<String>();
                    for(CSD_OEM_Mapping_Daily_BBB__c csdmap : [select Daily_Booking_Billing_Backlog_By_Part__c 
                                                                    from CSD_OEM_Mapping_Daily_BBB__c 
                                                                    where Daily_Booking_Billing_Backlog_By_Part__r.Fiscal_Year__c = :years 
                                                                        and Daily_Booking_Billing_Backlog_By_Part__r.Fiscal_Month__c IN :months
                                                                        and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.STATDESC__c = 'Active'
                                                                        and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.AccountNumber = :searchOb.accnumber 
                                                                        and CSD_OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
                        set_dailyIds.add(csdmap.Daily_Booking_Billing_Backlog_By_Part__c);
                    }

                    list<String> list_futruesql = new list<String>();
                    list_futruesql.add(' Customer__r.AccountNumber refId, sum(Backlog_Amount_USD__c) amount, Fiscal_Date__c refdate');
                    list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c    ');
                    list_futruesql.add(' WHERE Id IN :set_monthids '
                        + ' Group by Customer__r.AccountNumber, Fiscal_Date__c ');      
                    CSD_ClsUtils.setOEMPartMapRefData(set_dailyIds, list_futruesql, map_acctId_map_dateKey_result_futrue);
                    */
                     for(Date currentdate : list_futruedate) {
                        Date startDate = currentdate.toStartOfMonth();
                        Date endDate = currentdate.toStartOfMonth().addMonths(1).addDays(-1);
                        String monthlabel = CSD_ClsUtils.MAP_NUMBERMONTHLABEL.get(currentdate.month());
                        for (Period period : [select Id, PeriodLabel, StartDate, EndDate
                                                from Period where FiscalYearSettings.Name = :String.valueOf(currentdate.year()) 
                                                and Type = 'Month' and PeriodLabel = :monthlabel]) {
                            
                            startDate = period.StartDate;
                            endDate = period.EndDate;
                        }
                        set<String> set_dailyIds = new set<String>();
                        for(CSD_OEM_Mapping_Daily_BBB__c csdmap : [select Daily_Booking_Billing_Backlog_By_Part__c 
                                                                        from CSD_OEM_Mapping_Daily_BBB__c 
                                                                        where Daily_Booking_Billing_Backlog_By_Part__r.Customer_Request_Date__c >= :startDate 
                                                                            and Daily_Booking_Billing_Backlog_By_Part__r.Customer_Request_Date__c <= :endDate
                                                                            and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.STATDESC__c = 'Active'
                                                                            and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.AccountNumber = :searchOb.accnumber 
                                                                            and CSD_OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
                            set_dailyIds.add(csdmap.Daily_Booking_Billing_Backlog_By_Part__c);
                        }
    
                        list<String> list_futruesql = new list<String>();
                        list_futruesql.add(' Customer__r.AccountNumber refId, sum(Backlog_Amount_USD__c) amount ');
                        list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c    ');
                        list_futruesql.add(' WHERE Id IN :set_monthids '
                            + ' Group by Customer__r.AccountNumber ');      
                        CSD_ClsUtils.setOEMPartMapRefDataBacklog(currentdate, set_dailyIds, list_futruesql, map_acctId_map_dateKey_result_futrue);
                     }
                }

                CSD_ClsEntityType.CSDRefObj refdata = CSD_ClsUtils.createRefDataObj();
                refdata.id = searchOb.accnumber;
                
                CSD_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata,
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
        } 
    } 
    
    
    public class SearchLevel3 extends CSD_Interface.ACSDRemoteService{
        
        public override String getExistResult(String sData){
            CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData, CSD_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb'+searchOb);
            
            Date currentdate = Date.valueOf(searchOb.startDate);
            Date enddate = Date.valueOf(searchOb.endDate);
            
            list<String> list_sql = new list<String>();
            
            list_sql.add('Part__c part ');
            list_sql.add(' CSD_Sales_Forecast__c ');
            list_sql.add(' WHERE Sold_To_Number__c = \''+ searchOb.accnumber +'\' ' 
                    + ' And OEM__c = \''+ searchOb.oemId +'\' '
                    + ' And Type__c = \'Part\''
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Part__c ');
            
            map<String, CSD_ClsEntityType.PartObj> map_acctId_acctFC = new map<String, CSD_ClsEntityType.PartObj>();
            set<String> set_partid = new set<String>();
            set<String> set_hascftpartid = new set<String>();
            
            map<Integer, set<String>> map_set_soldto = new map<Integer, set<String>>();
            Integer i = 0;
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                Integer num = i/150;
                set_partid.add((String)result.get('part'));
                if(map_set_soldto.containsKey(num)) {
                    map_set_soldto.get(num).add((String)result.get('part'));
                }else {
                    set<String> set_soldto = new set<String>();
                    set_soldto.add((String)result.get('part'));
                    map_set_soldto.put(num, set_soldto);
                }
                i++;
            }
            
            CSD_ClsUtils.hasCFTForecast(searchOb.accnumber, searchOb.oemId, set_partid, currentdate, enddate, set_hascftpartid);
            
            for(Integer num : map_set_soldto.keySet()) {
                getExistResultForMore(searchOb, map_acctId_acctFC, currentdate, enddate, set_hascftpartid, map_set_soldto.get(num));
            }

            list<CSD_ClsEntityType.PartObj> list_accFC = new list<CSD_ClsEntityType.PartObj>();
            list_accFC.addAll(map_acctId_acctFC.values());
            list_accFC.sort();
            return Json.serialize(list_accFC);

            //return Json.serialize(map_acctId_acctFC.values());
        }
        
        private void getExistResultForMore(CSD_ClsEntityType.SearchObj searchOb, map<String, CSD_ClsEntityType.PartObj> map_acctId_acctFC, Date currentdate, Date enddate, set<String> set_hascftpartid, set<String> set_key) {
            
            list<String> list_sql = new list<String>();
            list_sql.add('Part__c part, Part__r.Name partname, Part__r.Description__c descr, Fiscal_Year__c year, Fiscal_Month__c month, '
                    + ' sum(Quantity__c) quantity, sum(Forecast__c) forecast, sum(Price__c) price,'
                    + ' sum(DC_Forecast_Amount__c) sumDCFC, sum(Previous_Month_Forecast__c) sumPMFC');
            list_sql.add(' CSD_Sales_Forecast__c ');
            list_sql.add(' WHERE Sold_To_Number__c = \''+ searchOb.accnumber +'\' ' 
                    + ' And OEM__c = \''+ searchOb.oemId +'\' '
                    + ' And Part__c = :set_key '
                    + ' And Type__c = \'Part\' '
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Part__c, Part__r.Name, Part__r.Description__c, Fiscal_Year__c, Fiscal_Month__c  ');
            
            map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result =
                new map<String, map<String, AggregateResult>>();
            
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                //system.debug('@#result : '+result);
                String accId = (String)result.get('part'), 
                       year = (String)result.get('year'),
                       month = (String)result.get('month'), 
                       dateKey = (year + '_' + month);
                //set_partid.add(accId);
                CSD_ClsUtils.setResultMap(result, accId, dateKey, map_acctId_map_dateKey_result);       
                
            }
            
            for(String acctId : map_acctId_map_dateKey_result.keySet()) {
                CSD_ClsEntityType.PartObj acctFC = new CSD_ClsEntityType.PartObj();
                acctFC.id = acctId;
                acctFC.csFC = new map<String, CSD_ClsEntityType.AccountValueobj>();
                acctFC.dcFC = new map<String, decimal>();
                acctFC.pmFC = new map<String, decimal>();
                acctFC.hasCFTFC = false;
                if(set_hascftpartid.contains(acctId)) {
                    acctFC.hasCFTFC = true;
                }
                map_acctId_acctFC.put(acctId, acctFC);
                
                
                for(String year : searchOb.map_year_monthsFuture.keySet()) {
                    for(Integer month : searchOb.map_year_monthsFuture.get(year)) {
                        String dateKey = (year + '_' + String.valueOf(month));
                        AggregateResult result;
                        system.debug('@#dateKey :'+dateKey);
                        if(map_acctId_map_dateKey_result.containsKey(acctId) 
                            && map_acctId_map_dateKey_result.get(acctId).containsKey(dateKey)) {
                            
                            result = map_acctId_map_dateKey_result.get(acctId).get(dateKey);
                        }
                        system.debug('@#result :'+result);
                        CSD_ClsEntityType.AccountValueobj valueobj = new CSD_ClsEntityType.AccountValueobj();
                        if(result != null) {
                            map_acctId_acctFC.get(acctId).name = (String)result.get('partname') + (result.get('descr') == null ? '' : ' - '+(String)result.get('descr'));
                            map_acctId_acctFC.get(acctId).snumber = result.get('descr') != null ? (String)result.get('descr') : '';
                            
                            valueobj.forecast = (decimal)result.get('forecast');
                            valueobj.price = (decimal)result.get('price');
                            valueobj.quantity = (decimal)result.get('quantity');
                            map_acctId_acctFC.get(acctId).csFC.put(dateKey, valueobj);
                            map_acctId_acctFC.get(acctId).dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
                            map_acctId_acctFC.get(acctId).pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
                        }else {
                            
                            valueobj.forecast = 0;
                            valueobj.price = 0;
                            valueobj.quantity = 0;
                            map_acctId_acctFC.get(acctId).csFC.put(dateKey, valueobj);
                            map_acctId_acctFC.get(acctId).dcFC.put(dateKey, 0);
                            map_acctId_acctFC.get(acctId).pmFC.put(dateKey, 0);
                        }                       
                    }
                }
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
                CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
                
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                CSD_ClsUtils.setRefDatelist(list_beforedate, list_futruedate, searchOb.set_fiscalMonth);

                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();

                if(list_beforedate.size() > 0) {
                    //before        
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    CSD_ClsUtils.setRefForecastDate(years, months, list_beforedate);

                    set<String> set_monthIds = new set<String>();
                    for(CSD_OEM_Mapping_Monthly_BBB__c csdmap : [select Monthly_Billings_Bookings_by_Part__c 
                                                                    from CSD_OEM_Mapping_Monthly_BBB__c 
                                                                    where Monthly_Billings_Bookings_by_Part__r.Fiscal_Year__c IN :years
                                                                        and Monthly_Billings_Bookings_by_Part__r.Fiscal_Month__c IN :months
                                                                        and Monthly_Billings_Bookings_by_Part__r.Customer__r.AccountNumber = :searchOb.accnumber 
                                                                        and Monthly_Billings_Bookings_by_Part__r.Customer__r.STATDESC__c = 'Active'
                                                                        and Monthly_Billings_Bookings_by_Part__r.Part__c = :searchOb.partId 
                                                                        and OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
                        set_monthIds.add(csdmap.Monthly_Billings_Bookings_by_Part__c);
                    }
                    
                    list<String> list_beforesql = new list<String>();
                    list_beforesql.add(' Customer__r.AccountNumber refId, sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                    list_beforesql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_beforesql.add(' WHERE Id IN :set_monthids '
                            + ' Group by Customer__r.AccountNumber, Fiscal_Date__c ');
                    CSD_ClsUtils.setOEMPartMapRefData(set_monthIds, list_beforesql, map_acctId_map_dateKey_result_before);
                    
                }
                system.debug('@#map_acctId_map_dateKey_result_before:'+map_acctId_map_dateKey_result_before);
                CSD_ClsEntityType.CSDRefObj refdata = CSD_ClsUtils.createRefDataObj();
                refdata.id = searchOb.accnumber;
                
                CSD_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
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
                CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
                
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();

                CSD_ClsUtils.setRefDatelist(list_beforedate, list_futruedate, searchOb.set_fiscalMonth);

                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();
                        
                if(list_futruedate.size() > 0) {
                    //futrue
                    // Updata the  Mingxing Qiu time is  2016-04-08
                    /*set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    CSD_ClsUtils.setRefForecastDate(years, months, list_futruedate);
                    
                    set<String> set_dailyIds = new set<String>();
                    for(CSD_OEM_Mapping_Daily_BBB__c csdmap : [select Daily_Booking_Billing_Backlog_By_Part__c 
                                                                    from CSD_OEM_Mapping_Daily_BBB__c 
                                                                    where Daily_Booking_Billing_Backlog_By_Part__r.Fiscal_Year__c IN :years
                                                                        and Daily_Booking_Billing_Backlog_By_Part__r.Fiscal_Month__c IN :months
                                                                        and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.AccountNumber = :searchOb.accnumber 
                                                                        and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.STATDESC__c = 'Active'
                                                                        and Daily_Booking_Billing_Backlog_By_Part__r.Part__c = :searchOb.partId 
                                                                        and CSD_OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId ]) {
                        set_dailyIds.add(csdmap.Daily_Booking_Billing_Backlog_By_Part__c);
                    }
                    
                    list<String> list_futruesql = new list<String>();
                    list_futruesql.add(' Customer__r.AccountNumber refId, sum(Backlog_Amount_USD__c) amount, Fiscal_Date__c refdate');
                    list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c    ');
                    list_futruesql.add(' WHERE Id IN :set_monthids '
                        + ' Group by Customer__r.AccountNumber, Fiscal_Date__c ');      
                    CSD_ClsUtils.setOEMPartMapRefData(set_dailyIds, list_futruesql, map_acctId_map_dateKey_result_futrue);
                    */
                    for(Date currentdate : list_futruedate) {
                        Date startDate = currentdate.toStartOfMonth();
                        Date endDate = currentdate.toStartOfMonth().addMonths(1).addDays(-1);
                        String monthlabel = CSD_ClsUtils.MAP_NUMBERMONTHLABEL.get(currentdate.month());
                        for (Period period : [select Id, PeriodLabel, StartDate, EndDate
                                                from Period where FiscalYearSettings.Name = :String.valueOf(currentdate.year()) 
                                                and Type = 'Month' and PeriodLabel = :monthlabel]) {
                            
                            startDate = period.StartDate;
                            endDate = period.EndDate;
                        }
                        set<String> set_dailyIds = new set<String>();
                        for(CSD_OEM_Mapping_Daily_BBB__c csdmap : [select Daily_Booking_Billing_Backlog_By_Part__c 
                                                                        from CSD_OEM_Mapping_Daily_BBB__c 
                                                                        where Daily_Booking_Billing_Backlog_By_Part__r.Customer_Request_Date__c >= :startDate 
                                                                            and Daily_Booking_Billing_Backlog_By_Part__r.Customer_Request_Date__c <= :endDate
                                                                            and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.AccountNumber = :searchOb.accnumber 
                                                                            and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.STATDESC__c = 'Active'
                                                                            and Daily_Booking_Billing_Backlog_By_Part__r.Part__c = :searchOb.partId 
                                                                            and CSD_OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId ]) {
                            set_dailyIds.add(csdmap.Daily_Booking_Billing_Backlog_By_Part__c);
                        }
                        
                        list<String> list_futruesql = new list<String>();
                        list_futruesql.add(' Customer__r.AccountNumber refId, sum(Backlog_Amount_USD__c) amount  ');
                        list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c    ');
                        list_futruesql.add(' WHERE Id IN :set_monthids '
                            + ' Group by Customer__r.AccountNumber  ');      
                        CSD_ClsUtils.setOEMPartMapRefDataBacklog(currentdate, set_dailyIds, list_futruesql, map_acctId_map_dateKey_result_futrue);
                    }
                }

                CSD_ClsEntityType.CSDRefObj refdata = CSD_ClsUtils.createRefDataObj();
                refdata.id = searchOb.accnumber;
                
                CSD_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata,
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
        } 
        
    }
    
    public class SearchTotal extends CSD_Interface.ACSDRemoteService{
        
        public override String getTotalBillingData(String sData) {
        
            try {
                CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
                
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
    
                CSD_ClsUtils.setRefDatelist(list_beforedate, list_futruedate, searchOb.set_fiscalMonth);
    
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();
                
                set<String> set_acctIds = new set<String>();
                
                list<CSD_ClsEntityType.UserObj> list_users = new list<CSD_ClsEntityType.UserObj>();
                CSD_ClsUtils.setSubordinateUserForMultilevelHead(searchOb.managerId, list_users);
                
                set<String> set_userIds = new set<String>();
                set_userIds.add(searchOb.managerId);
                for(CSD_ClsEntityType.UserObj userobj : list_users) {
                    set_userIds.add(userobj.id);
                }
                system.debug('!@#set_userIds : '+ set_userIds);
                CSD_ClsUtils.setTerritoryAccountSetBySubordinate(set_acctIds, set_userIds);
                system.debug('!@#set_acctIds : '+ set_acctIds);
                if(list_beforedate.size() > 0) {
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                        
                    CSD_ClsUtils.setRefForecastDate(years, months, list_beforedate);
                        
                    list<String> list_beforesql = new list<String>();
                    list_beforesql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                    list_beforesql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_beforesql.add(' WHERE Customer__r.AccountNumber IN :set_perm '
                        + ' And Customer__r.STATDESC__c = \'Active\' '
                        + ' And Fiscal_Year__c IN : years '
                        + ' And Fiscal_Month__c IN : months '
                        + ' Group by Fiscal_Date__c ');
                    CSD_ClsUtils.setTotelBillingData(years, months, set_acctIds, list_beforesql, map_acctId_map_dateKey_result_before);
                }
                    
                CSD_ClsEntityType.CSDRefObj refdata = CSD_ClsUtils.createRefDataObj();
                refdata.id = 'Total';
                    
                CSD_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata,
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
            
        }
    }
    
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
}