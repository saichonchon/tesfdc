/**
     *  This class is CSD ODM Service.
     *  
     * @author Jinbo Shan
     * @created 2014-10-23
     * @version 1.0
     * @since 30.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2014-10-23 Jinbo Shan <jinbo.shan@itbconsult.com>
     * - Created
     *
       @changelog
     * 2016-04-08 Mingxing <Qiumingxing.qiu@oinio.com>
     * - Created
     */
    public without sharing class CSD_ClsODMViewService extends CSD_Interface.ACSDCtrlService {

        
        
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
            CSD_ClsEntityType.PageConfig pageconf = (CSD_ClsEntityType.PageConfig)config;
            system.debug('@#pageconf : '+pageconf);
            
            CSD_ClsEntityType.AccountObj totalFC = new CSD_ClsEntityType.AccountObj();
            CSD_ClsUtils.createAccountObj(totalFC, pageconf.map_financialMonth);
            String hexid = CSD_ClsUtils.getHexUID();
            totalFC.id = hexid;
            totalFC.accnumber = 'Total';
            totalFC.name = 'Total';
            totalFC.type = 'total';
            list_data.add(totalFC);
             
            set<String> set_WWACCodes = new set<String>();
            for(CSD_Forecast_Management__c acc : [Select Id, WWAC_Code__c from CSD_Forecast_Management__c where Role__c = 'ODM' And User__c = :UserInfo.getUserId() ]) {
                set_WWACCodes.add(acc.WWAC_Code__c);
            }
            
            map<String, String> map_Account_WWAC = new map<String, String>();
            set<String> set_accnumber = new set<String>();
            for(Account acc : [select Id, AccountNumber, WWCORPACCT__c from Account where STATDESC__c = 'Active' and WWCORPACCT__c IN :set_WWACCodes]) {
                map_Account_WWAC.put(acc.AccountNumber, acc.WWCORPACCT__c);
            }
            set_accnumber = map_Account_WWAC.keySet();

            list<String> list_sql = new list<String>();
            
            Date currentdate = Date.valueOf(pageconf.refStartDate);
            Date enddate = Date.valueOf(pageconf.refEndDate);
            
            list_sql.add(' Sold_To_Number__c acc, Sold_To_Name__c name, Fiscal_Year__c year, Fiscal_Month__c month, '
                    + 'sum(DC_Forecast_Amount__c) sumDCFC, sum(Forecast__c) sumFC, sum(Previous_Month_Forecast__c) sumPMFC');
            list_sql.add(' CSD_Sales_Forecast__c ');
            list_sql.add(' WHERE Type__c = \'Sold-To\' '
                        + ' And Sold_To_Number__c IN : set_accnumber ' 
                        + ' And Fiscal_Date__c >= : currentdate '
                        + ' And Fiscal_Date__c < : enddate '
                        + ' Group by Fiscal_Year__c, Fiscal_Month__c, Sold_To_Number__c, Sold_To_Name__c ');
            
            map<String, CSD_ClsEntityType.AccountObj> map_acctId_acctFC = new map<String, CSD_ClsEntityType.AccountObj>();
            
            map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result =
                new map<String, map<String, AggregateResult>>();

            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                //system.debug('@#result : '+result);
                String accId = (String)result.get('acc'), 
                       year = (String) result.get('year'),
                       month = (String) result.get('month'), 
                       dateKey = (year + '_' + month);
                       
                CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
                
                String wwac = '';
                if(map_Account_WWAC.containsKey(accId)) {
                    wwac = map_Account_WWAC.get(accId);
                }else {
                    continue;
                }
                
                if(!map_acctId_acctFC.containsKey(wwac)) {
                    CSD_ClsUtils.createAccountObj(acctFC, pageconf.map_financialMonth);
                    Blob aes = Crypto.generateAesKey(128);
                    String hex = EncodingUtil.convertToHex(aes);
                    acctFC.id = hex;
                    acctFC.name = wwac;
                    acctFC.accnumber = (String)result.get('name');
                    map_acctId_acctFC.put(wwac, acctFC);
                }else {
                    acctFC = map_acctId_acctFC.get(wwac);
                }

                acctFC.csFC.put(dateKey, (result.get('sumFC') != null ? acctFC.csFC.get(dateKey) + (decimal)result.get('sumFC') : acctFC.csFC.get(dateKey)));
                acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? acctFC.dcFC.get(dateKey) + (decimal)result.get('sumDCFC') : acctFC.dcFC.get(dateKey)));
                acctFC.pmFC.put(dateKey, (result.get('sumPMFC') != null ? acctFC.pmFC.get(dateKey) + (decimal)result.get('sumPMFC') : acctFC.pmFC.get(dateKey)));
                
                map_acctId_acctFC.put(wwac, acctFC);    
                             
            }
            

            list<CSD_ClsEntityType.AccountObj> list_accFc = new list<CSD_ClsEntityType.AccountObj>();
            list_accFc.addAll(map_acctId_acctFC.values());
            list_accFc.sort();
            for(Integer i = 0; i < list_accFc.size(); i++) {
                list_data.add(list_accFc.get(i));
            }
            
        }
        
        //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
        /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
        
         
        //********************************* -=BEGIN public methods=- **********************************

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
                    system.debug('@#searchOb:'+searchOb.region);
                    list<Date> list_beforedate = new list<Date>();
                    list<Date> list_futruedate = new list<Date>();
                    
                    CSD_ClsUtils.setRefDatelist(list_beforedate, list_futruedate, searchOb.set_fiscalMonth);
                    
                    map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                                new map<String, map<String, AggregateResult>>();
                    map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                            new map<String, map<String, AggregateResult>>();
                    
                    //set<String> set_soldtoIds = new set<String>();
                    set<String> set_WWACCodes = new set<String>();
                    set_WWACCodes.add(searchOb.region);
                    
                    set<String> set_accnumber = new set<String>();
                    for(Account acc : [select Id, AccountNumber, WWCORPACCT__c from Account where STATDESC__c = 'Active' and WWCORPACCT__c IN :set_WWACCodes]) {
                        set_accnumber.add(acc.AccountNumber);
                    }

                    if(list_beforedate.size() > 0) {
                        //before
                        set<String> years = new set<String>();
                        set<Integer> months = new set<Integer>();
                        
                        CSD_ClsUtils.setRefForecastDate(years, months, list_beforedate);
                        
                        list<String> list_beforesql = new list<String>();
                        list_beforesql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                        list_beforesql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                        list_beforesql.add(' WHERE Customer__r.AccountNumber IN :set_soldtoIds '
                            + ' And Customer__r.STATDESC__c = \'Active\' '
                            + ' And Fiscal_Year__c IN : years '
                            + ' And Fiscal_Month__c IN : months '
                            + ' Group by Fiscal_Date__c ');
                        CSD_ClsUtils.setRegionMapRefData(searchOb.region, years, months, set_accnumber, list_beforesql, map_acctId_map_dateKey_result_before);
                    }
                    
                    CSD_ClsEntityType.CSDRefObj refdata = CSD_ClsUtils.createRefDataObj();
                    refdata.id = searchOb.region;
                    
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
                    
                    set<String> set_WWACCodes = new set<String>();
                    set_WWACCodes.add(searchOb.region);
                    
                    set<String> set_accnumber = new set<String>();
                    for(Account acc : [select Id, AccountNumber, WWCORPACCT__c from Account where STATDESC__c = 'Active' and WWCORPACCT__c IN :set_WWACCodes]) {
                        set_accnumber.add(acc.AccountNumber);
                    }
                    
                    if(list_futruedate.size() > 0) {
                        //futrue old
                        //Updata the  Mingxing Qiu time is  2016-04-08
                        /*set<String> years = new set<String>();
                        set<Integer> months = new set<Integer>();
                        
                        CSD_ClsUtils.setRefForecastDate(years, months, list_futruedate);

                        list<String> list_futruesql = new list<String>();
                        list_futruesql.add(' sum(Backlog_Amount_USD__c) amount, Fiscal_Date__c refdate');
                        list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
                        list_futruesql.add(' WHERE Customer__r.AccountNumber IN :set_soldtoIds '
                            + ' And Customer__r.STATDESC__c = \'Active\' '
                            + ' And Fiscal_Year__c IN : years '
                            + ' And Fiscal_Month__c IN : months '
                            + ' Group by Fiscal_Date__c ');     
                        CSD_ClsUtils.setRegionMapRefData(searchOb.region, years, months, set_accnumber, list_futruesql, map_acctId_map_dateKey_result_futrue);
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
                            list_futruesql.add(' WHERE Customer__r.AccountNumber IN :set_soldtoIds '
                                + ' And Customer__r.STATDESC__c = \'Active\' '
                                + ' And Customer_Request_Date__c >= :startDate '
                                + ' And Customer_Request_Date__c <= :endDate ');   
                            CSD_ClsUtils.setRegionMapRefDataBacklog(searchOb.region, currentdate, startDate, endDate, set_accnumber, list_futruesql, map_acctId_map_dateKey_result_futrue);
                        } 
                    }
                    CSD_ClsEntityType.CSDRefObj refdata = CSD_ClsUtils.createRefDataObj();
                    refdata.id = searchOb.region;
                    
                    CSD_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata,
                                map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                    
                    return Json.serialize(refdata);
                }catch(Exception ex) {
                    throw ex;
                }
            }
        }


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
                
                set<String> set_accnumber = new set<String>();
                for(Account acc : [select Id, AccountNumber, WWCORPACCT__c from Account where STATDESC__c = 'Active' and WWCORPACCT__c = :searchOb.region]) {
                    set_accnumber.add(acc.AccountNumber);
                }

                Date currentdate = Date.valueOf(searchOb.startDate);
                Date enddate = Date.valueOf(searchOb.endDate);
                
                list<String> list_sql = new list<String>();
                list_sql.add('Sold_To_Number__c soldto, Sold_To_Name__c name, Fiscal_Year__c year, Fiscal_Month__c month, '
                        + 'sum(DC_Forecast_Amount__c) sumDCFC, sum(Forecast__c) sumFC, sum(Previous_Month_Forecast__c) sumPMFC ');
                list_sql.add(' CSD_Sales_Forecast__c ');
                list_sql.add(' WHERE Type__c = \'Sold-To\' '
                            + ' And Sold_To_Number__c IN :set_accnumber ' 
                            + ' And Fiscal_Date__c >= : currentdate '
                            + ' And Fiscal_Date__c < : enddate '
                            + ' Group by Fiscal_Year__c, Fiscal_Month__c, Sold_To_Number__c, Sold_To_Name__c ');
                //Generate forecast view object
                
                map<String, CSD_ClsEntityType.AccountObj> map_acctId_acctFC = new map<String, CSD_ClsEntityType.AccountObj>();
                
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result =
                    new map<String, map<String, AggregateResult>>();
                
                for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                    //system.debug('@#result : '+result);
                    String accId = (String)result.get('soldto'), 
                           year = (String) result.get('year'),
                           month = (String) result.get('month'), 
                           dateKey = (year + '_' + month);
                       
                    CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
        
                    if(!map_acctId_acctFC.containsKey(accId)) {
                        CSD_ClsUtils.createAccountObj(acctFC, searchOb.map_year_monthsFuture);
                        Blob aes = Crypto.generateAesKey(128);
                        String hex = EncodingUtil.convertToHex(aes);
                        acctFC.id = hex;
                        acctFC.accnumber = accId;
                        acctFC.name = (String)result.get('name');
        
                        map_acctId_acctFC.put(accId, acctFC);
                    }else {
                        acctFC = map_acctId_acctFC.get(accId);
                    }

                    acctFC.csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
                    acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
                    acctFC.pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
                    
                    map_acctId_acctFC.put(accId, acctFC);
          
                }
                
                list<CSD_ClsEntityType.AccountObj> list_accFc = new list<CSD_ClsEntityType.AccountObj>();
                list_accFc.addAll(map_acctId_acctFC.values());
                list_accFc.sort();
                
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
                    
                    if(list_futruedate.size() > 0) {
                        //futrue
                        set<String> years = new set<String>();
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
                    }
                    
                    
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
                         //Updata the  Mingxing Qiu time is  2016-04-08
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
                        list_futruesql.add(' Customer__r.AccountNumber refId, sum(Backlog_Amount_USD__c) amount ');
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
        
        public class SearchLevel3 extends CSD_Interface.ACSDRemoteService{
            
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
                    + ' sum(Quantity__c) quantity, sum(Forecast__c) sumFC, sum(Price__c) price, sum(Rest_Parts_Forecast__c) restPNFC,'
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
                    
                    
                    CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
        
                    if(!map_acctId_acctFC.containsKey(accId)) {
                        CSD_ClsUtils.createAccountObj(acctFC, searchOb.map_year_monthsFuture);
                        
                        acctFC.id = accId;
                        acctFC.name = (String)result.get('accname');
        
                        map_acctId_acctFC.put(accId, acctFC);
                    }else {
                        acctFC = map_acctId_acctFC.get(accId);
                    }

                    acctFC.csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
                    acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
                    acctFC.pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
                    acctFC.restPNFC.put(dateKey, (result.get('restPNFC') != null ? (decimal)result.get('restPNFC') : 0));
                    map_acctId_acctFC.put(accId, acctFC);
                    
                    //CSD_ClsUtils.setResultMap(result, accId, dateKey, map_acctId_map_dateKey_result);       
                    
                }
                
                //map<String, set<Integer>> map_year_monthsFuture = (map<String, set<Integer>>)JSON.deserialize(searchOb.str_futureMonthMap, map<String, set<Integer>>.class);
                
                
                list_sql.clear();
                map_acctId_map_dateKey_result.clear();
                list_sql.add('OEM__c oem, OEM__r.Name accname, Fiscal_Year__c year, Fiscal_Month__c month, '
                    + ' sum(Quantity__c) quantity, sum(Forecast__c) sumFC, sum(Price__c) price, sum(Rest_Parts_Forecast__c) restPNFC, '
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
                    
                    CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
        
                    if(!map_acctId_acctFC.containsKey(accId)) {
                        CSD_ClsUtils.createAccountObj(acctFC, searchOb.map_year_monthsFuture);
                        
                        acctFC.id = accId;
                        acctFC.name = (String)result.get('accname');
        
                        map_acctId_acctFC.put(accId, acctFC);
                    }else {
                        acctFC = map_acctId_acctFC.get(accId);
                    }

                    acctFC.csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
                    acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
                    acctFC.pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
                    acctFC.restPNFC.put(dateKey, (result.get('restPNFC') != null ? (decimal)result.get('restPNFC') : 0));
                    map_acctId_acctFC.put(accId, acctFC);
                    
                    //CSD_ClsUtils.setResultMap(result, CSD_ClsUtils.NONOEMSID, dateKey, map_acctId_map_dateKey_result);       
                           
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
                        //Updata the  Mingxing Qiu time is  2016-04-08
                       /* set<String> years = new set<String>();
                        set<Integer> months = new set<Integer>();
                        
                        CSD_ClsUtils.setRefForecastDate(years, months, list_futruedate);
                        
                        set<String> set_dailyIds = new set<String>();
                        for(CSD_OEM_Mapping_Daily_BBB__c csdmap : [select Daily_Booking_Billing_Backlog_By_Part__c 
                                                                        from CSD_OEM_Mapping_Daily_BBB__c 
                                                                        where Daily_Booking_Billing_Backlog_By_Part__r.Fiscal_Year__c IN :years
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

        
        public class SearchLevel4 extends CSD_Interface.ACSDRemoteService{
            
            public override String getExistResult(String sData){
                CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData, CSD_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb'+searchOb);
                
                Date currentdate = Date.valueOf(searchOb.startDate);
                Date enddate = Date.valueOf(searchOb.endDate);
                
                list<String> list_sql = new list<String>();
                
                list_sql.add('Part__c part, Part__r.Name partname, Part__r.Description__c descr, Fiscal_Year__c year, Fiscal_Month__c month, '
                        + ' sum(Quantity__c) quantity, sum(Forecast__c) sumFC, sum(Price__c) price,'
                        + ' sum(DC_Forecast_Amount__c) sumDCFC, sum(Previous_Month_Forecast__c) sumPMFC');
                        
                list_sql.add(' CSD_Sales_Forecast__c ');
                list_sql.add(' WHERE Sold_To_Number__c = \''+ searchOb.accnumber +'\' ' 
                        + ' And OEM__c = \''+ searchOb.oemId +'\' '
                        + ' And Type__c = \'Part\' '
                        + ' And Fiscal_Date__c >= : currentdate '
                        + ' And Fiscal_Date__c < : enddate '
                        + ' Group by Part__c, Part__r.Name, Part__r.Description__c, Fiscal_Year__c, Fiscal_Month__c  ');
                
                map<String, CSD_ClsEntityType.PartObj> map_acctId_acctFC = new map<String, CSD_ClsEntityType.PartObj>();
            
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result =
                    new map<String, map<String, AggregateResult>>();
                
                for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                    //system.debug('@#result : '+result);
                    String accId = (String)result.get('part'), 
                           year = (String)result.get('year'),
                           month = (String)result.get('month'), 
                           dateKey = (year + '_' + month);
                    
                    
                    CSD_ClsEntityType.PartObj acctFC = new CSD_ClsEntityType.PartObj();
        
                    if(!map_acctId_acctFC.containsKey(accId)) {
                        CSD_ClsUtils.createPartObj(acctFC, searchOb.map_year_monthsFuture);
                        
                        acctFC.id = accId;
                        acctFC.name = (String)result.get('partname') + (result.get('descr') == null ? '' : ' - '+(String)result.get('descr'));
                        acctFC.snumber = (result.get('descr') == null ? '' : (String)result.get('descr'));
                        map_acctId_acctFC.put(accId, acctFC);
                    }else {
                        acctFC = map_acctId_acctFC.get(accId);
                    }
                    
                    CSD_ClsEntityType.AccountValueobj valueobj = new CSD_ClsEntityType.AccountValueobj();
                    
                    valueobj.forecast = result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0;
                    valueobj.price = result.get('price') != null ? (decimal)result.get('price') : 0;
                    valueobj.quantity = result.get('quantity') != null ? (decimal)result.get('quantity') : 0;
                    
                    acctFC.csFC.put(dateKey, valueobj);
                    acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
                    acctFC.pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
                    
                    map_acctId_acctFC.put(accId, acctFC);  
                    
                    
                    //CSD_ClsUtils.setResultMap(result, accId, dateKey, map_acctId_map_dateKey_result);       
                    
                }
                
                //map<String, set<Integer>> map_year_monthsFuture = (map<String, set<Integer>>)JSON.deserialize(searchOb.str_futureMonthMap, map<String, set<Integer>>.class);
                
                list<CSD_ClsEntityType.PartObj> list_accFC = new list<CSD_ClsEntityType.PartObj>();
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
                         //Updata the  Mingxing Qiu time is  2016-04-08
                        /*set<String> years = new set<String>();
                        set<Integer> months = new set<Integer>();
                        
                        CSD_ClsUtils.setRefForecastDate(years, months, list_futruedate);
                        
                        set<String> set_dailyIds = new set<String>();
                        for(CSD_OEM_Mapping_Daily_BBB__c csdmap : [select Daily_Booking_Billing_Backlog_By_Part__c 
                                                                        from CSD_OEM_Mapping_Daily_BBB__c 
                                                                        where Daily_Booking_Billing_Backlog_By_Part__r.Fiscal_Year__c IN :years
                                                                            and Daily_Booking_Billing_Backlog_By_Part__r.Fiscal_Month__c IN :months
                                                                            and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.STATDESC__c = 'Active'
                                                                            and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.AccountNumber = :searchOb.accnumber 
                                                                            and Daily_Booking_Billing_Backlog_By_Part__r.Part__c = :searchOb.partId 
                                                                            and CSD_OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId ]) {
                            set_dailyIds.add(csdmap.Daily_Booking_Billing_Backlog_By_Part__c);
                        }
                        system.debug('@#set_dailyIds:'+set_dailyIds);
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
                                                                                and Daily_Booking_Billing_Backlog_By_Part__r.Part__c = :searchOb.partId 
                                                                                and CSD_OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId ]) {
                                set_dailyIds.add(csdmap.Daily_Booking_Billing_Backlog_By_Part__c);
                            }
                            system.debug('@#set_dailyIds:'+set_dailyIds);
                            list<String> list_futruesql = new list<String>();
                            list_futruesql.add(' Customer__r.AccountNumber refId, sum(Backlog_Amount_USD__c) amount ');
                            list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c  ');
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
                    
                   set<String> set_WWACCodes = new set<String>();
                    for(CSD_Forecast_Management__c acc : [Select Id, WWAC_Code__c from CSD_Forecast_Management__c where Role__c = 'ODM' And User__c = :UserInfo.getUserId() ]) {
                        set_WWACCodes.add(acc.WWAC_Code__c);
                    }
                    
                    map<String, String> map_Account_WWAC = new map<String, String>();
                    set<String> set_accnumber = new set<String>();
                    for(Account acc : [select Id, AccountNumber, WWCORPACCT__c from Account where STATDESC__c = 'Active' and WWCORPACCT__c IN :set_WWACCodes]) {
                        map_Account_WWAC.put(acc.AccountNumber, acc.WWCORPACCT__c);
                    }
                    set_accnumber = map_Account_WWAC.keySet();
                    
                    if(list_beforedate.size() > 0) {
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

                        CSD_ClsUtils.setTotelBillingData(years, months, set_accnumber, list_beforesql, map_acctId_map_dateKey_result_before);
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