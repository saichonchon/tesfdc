/**
 *  This class is Sold To Forecast Service.
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
 */
public without sharing class CSD_ClsSoldToService extends CSD_Interface.ACSDCtrlService  {

    public override void setPopUPBoxColumnLevel1(list<Object> list_column){
        CSD_ClsEntityType.CSDColumn column1 = new CSD_ClsEntityType.CSDColumn();
        column1.name = 'Name';
        column1.fieldName = 'name';
        CSD_ClsEntityType.CSDColumn column2 = new CSD_ClsEntityType.CSDColumn();
        column2.name = 'Number';
        column2.fieldName = 'snumber';
        CSD_ClsEntityType.CSDColumn column3 = new CSD_ClsEntityType.CSDColumn();
        column3.name = 'Region';
        column3.fieldName = 'region';
        list_column.add(column2);
        list_column.add(column1);
        list_column.add(column3);
    }
    
    public override void setPopUPBoxColumnLevel2(list<Object> list_column){
        CSD_ClsEntityType.CSDColumn column1 = new CSD_ClsEntityType.CSDColumn();
        column1.name = 'Name';
        column1.fieldName = 'name';
        CSD_ClsEntityType.CSDColumn column2 = new CSD_ClsEntityType.CSDColumn();
        column2.name = 'Rank';
        column2.fieldName = 'rank';
        CSD_ClsEntityType.CSDColumn column3 = new CSD_ClsEntityType.CSDColumn();
        column3.name = 'Account Manager';
        column3.fieldName = 'accmanager';

        list_column.add(column1);
        list_column.add(column2);
        list_column.add(column3);
        
    }
    
    public override void setPopUPBoxColumnLevel3(list<Object> list_column){
        CSD_ClsEntityType.CSDColumn column1 = new CSD_ClsEntityType.CSDColumn();
        column1.name = 'Name';
        column1.fieldName = 'name';
        CSD_ClsEntityType.CSDColumn column2 = new CSD_ClsEntityType.CSDColumn();
        column2.name = 'Description';
        column2.fieldName = 'snumber';
        CSD_ClsEntityType.CSDColumn column3 = new CSD_ClsEntityType.CSDColumn();
        column3.name = 'Region';
        column3.fieldName = 'region';
        /*CSD_ClsEntityType.CSDColumn column4 = new CSD_ClsEntityType.CSDColumn();
        column4.name = 'Billing';
        column4.fieldName = 'accnumber';*/
        
        list_column.add(column1);
        list_column.add(column2);
        list_column.add(column3);
        //list_column.add(column4);
    }
    
    
    
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
        
        CSD_ClsEntityType.AccountObj totalFC = new CSD_ClsEntityType.AccountObj();
        CSD_ClsUtils.createAccountObj(totalFC, pageconf.map_financialMonth);
        String hexid = CSD_ClsUtils.getHexUID();
        totalFC.id = hexid;
        totalFC.accnumber = 'Total';
        totalFC.name = 'Total';
        totalFC.type = 'total';
        list_data.add(totalFC);
        
        set<String> set_acctIds = new set<String>();
        CSD_ClsUtils.setTerritoryAccountSetByUserId(set_acctIds, CSD_ClsUtils.getManageUserId(pageconf.managerId));
        system.debug('@#pageconf.managerId : '+pageconf.managerId);
        system.debug('@#set_acctIds : '+set_acctIds);
        
        list<String> list_sql = new list<String>();
        
        Date currentdate = Date.valueOf(pageconf.refStartDate);
        Date enddate = Date.valueOf(pageconf.refEndDate);
        system.debug('qmx_currentdate'+currentdate);
        system.debug('qmx_enddate'+enddate);
        
        list_sql.add('Sold_To_Number__c soldto, Sold_To_Name__c name, Billing_Region__c region, Fiscal_Year__c year, Fiscal_Month__c month, '
                + 'sum(DC_Forecast_Amount__c) sumDCFC, sum(Forecast__c) sumFC, sum(Previous_Month_Forecast__c) sumPMFC');  
        list_sql.add(' CSD_Sales_Forecast__c ');
        list_sql.add(' WHERE Type__c = \'Sold-To\' '
                    + ' And Sold_To_Number__c in : set_acctIds ' 
                    + ' And Samsung_Type__c = null ' 
                    + (CSD_Configuration__c.getInstance('Samsung OEM Account') != null && CSD_Configuration__c.getInstance('Samsung OEM Account').Value__c != '' ? ' And OEM__c != \'' + CSD_Configuration__c.getInstance('Samsung OEM Account').Value__c + '\' ' : '')
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, Sold_To_Number__c, Sold_To_Name__c, Billing_Region__c ');
        
        map<String, CSD_ClsEntityType.AccountObj> map_acctId_acctFC = new map<String, CSD_ClsEntityType.AccountObj>();
        
        map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result =
            new map<String, map<String, AggregateResult>>();

        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
            String accId = (String)result.get('soldto'), 
                   year = (String) result.get('year'),
                   month = (String) result.get('month'), 
                   dateKey = (year + '_' + month);
            CSD_ClsUtils.setResultMap(result, accId, dateKey, map_acctId_map_dateKey_result);             
        }
        
        Date fiscaldate = CSD_ClsUtils.getFiscalDate();
        
        map<String, set<String>> map_hasBillingSoldto_OEMs = new map<String, set<String>>();
        CSD_ClsUtils.setautoOEMIds(map_hasBillingSoldto_OEMs, set_acctIds, fiscaldate);
        system.debug('@#map_hasBillingSoldto_OEMs :'+map_hasBillingSoldto_OEMs);
        map<String, String> map_accid_Comment = new map<String, String>();
        if(map_acctId_map_dateKey_result.size() > 0) {
            for(Account acc : [select AccountNumber, Name, CSD_EOL_Comment__c from Account where AccountNumber IN :map_acctId_map_dateKey_result.keySet() ] ) {
                map_accid_Comment.put(acc.AccountNumber, acc.CSD_EOL_Comment__c);
            }
        }

        for(String acctId : map_acctId_map_dateKey_result.keySet()) {
            CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
            CSD_ClsUtils.createAccountObj(acctFC, pageconf.map_financialMonth);
            String hex = CSD_ClsUtils.getHexUID();
            acctFC.id = hex;
            acctFC.accnumber = acctId;
            
            acctFc.eolcomment = map_accid_Comment.get(acctId);
            acctFC.type = (map_hasBillingSoldto_OEMs.containsKey(acctId) ? 'NoDel' : '');

            map_acctId_acctFC.put(acctId, acctFC);

            for(String year : pageconf.map_financialMonth.keySet()) {
                for(Integer month : pageconf.map_financialMonth.get(year)) {
                    String dateKey = (year + '_' + String.valueOf(month));
                    AggregateResult result;
                    //system.debug('@#dateKey :'+dateKey);
                    if(map_acctId_map_dateKey_result.containsKey(acctId) 
                        && map_acctId_map_dateKey_result.get(acctId).containsKey(dateKey)) {
                        
                        result = map_acctId_map_dateKey_result.get(acctId).get(dateKey);
                        
                        acctFC.name = (result.get('name') != null ? (String)result.get('name') : '');
                        acctFC.region = (result.get('region') != null ? (String)result.get('region') : '');
                    }

                    if(result != null) {
                        map_acctId_acctFC.get(acctId).csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
                        map_acctId_acctFC.get(acctId).dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
                        map_acctId_acctFC.get(acctId).pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
                        
                    }              
                }
            }
        }
        
        list<CSD_ClsEntityType.AccountObj> list_accFc = new list<CSD_ClsEntityType.AccountObj>();
        list_accFc.addAll(map_acctId_acctFC.values());
        list_accFc.sort();
        for(Integer i = 0; i < list_accFc.size(); i++) {
            list_data.add(list_accFc.get(i));
        }
        system.debug('@#list_data :'+list_data);
        
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
    public class SearchSoldTo extends CSD_Interface.ACSDRemoteService{
        
        public override String saveSObjectData(String sData) { 
            
            try {
                CSD_ClsEntityType.AccountObj valueobj = (CSD_ClsEntityType.AccountObj)JSON.deserialize(sData,CSD_ClsEntityType.AccountObj.class);
                //TO DO
                map<String, CSD_Sales_Forecast__c> map_date_forecast = new map<String, CSD_Sales_Forecast__c>();
                for(CSD_Sales_Forecast__c fc : [select Id, Sold_To_Name__c, Fiscal_Year__c, Fiscal_Month__c, Sold_To_Number__c, Rest_Parts_Forecast__c, 
                                                    OEM__c, Part__c, Price__c, Quantity__c, Forecast__c, Type__c
                                                From CSD_Sales_Forecast__c 
                                                where Sold_To_Number__c = : valueobj.accnumber 
                                                And Type__c IN ('Sold-To','Rest-SoldTo') 
                                                And Samsung_Type__c = null 
                                                And OEM__c != :CSD_Configuration__c.getInstance('Samsung OEM Account').Value__c ]) {
                     map_date_forecast.put((fc.Fiscal_Year__c + '_' + fc.Fiscal_Month__c ), fc);
                }
                
                list<CSD_Sales_Forecast__c> list_forecast = new list<CSD_Sales_Forecast__c>();
                
                set<String> soldtoIds = new set<String>();
                soldtoIds.add(valueobj.accnumber);
                
                map<String, String> map_accid_region = CSD_ClsUtils.getRegionForSoldTo(soldtoIds, '', '');
                
                for(String key : valueobj.csFC.keySet()) {
                    CSD_Sales_Forecast__c forecast = new CSD_Sales_Forecast__c(
                        Price__c = 0, Quantity__c = 0, Forecast__c = valueobj.csFC.get(key),
                        Sold_To_Name__c = valueobj.name, Fiscal_Year__c = key.substring(0, key.indexOf('_')),
                        Fiscal_Month__c = key.substring(key.indexOf('_')+1, key.length()), Sold_To_Number__c = valueobj.accnumber,
                        Type__c = 'Sold-To', CurrencyIsoCode = 'USD', 
                        Billing_Region__c = map_accid_region.get(valueobj.accnumber) != null ? map_accid_region.get(valueobj.accnumber) : ''
                    );
                    if(map_date_forecast.containsKey(key)) {
                        forecast.Id = map_date_forecast.get(key).Id;
                    }
                    
                    list_forecast.add(forecast);
                }
                if(list_forecast.size() > 0) {
                    upsert list_forecast;
                }

                return 'true'; 
            }catch(Exception ex) {
                throw ex;
            }
        }
        
        public override String deleteCSDObject(String sData) { 
            try {
                CSD_ClsEntityType.SearchObj valueobj = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
                //TO DO
                list<CSD_Sales_Forecast__c> list_forecast = new list<CSD_Sales_Forecast__c>();
                //map<String, CSD_Sales_Forecast__c> map_date_forecast = new map<String, CSD_Sales_Forecast__c>();
                for(CSD_Sales_Forecast__c fc : [select Id, Fiscal_Year__c, Fiscal_Month__c, Sold_To_Number__c
                                                , OEM__c, Part__c, Price__c, Quantity__c, Forecast__c, Type__c
                                                From CSD_Sales_Forecast__c 
                                                //where Sold_To__c = : valueobj.soldtoId ]) {
                                                where Sold_To_Number__c = : valueobj.accnumber 
                                                //and CreatedById = :UserInfo.getUserId()
                                                ]) {
                     list_forecast.add(fc);
                }
                if(list_forecast.size() > 0){
                    delete list_forecast;

                }

                return 'true'; 
            }catch(Exception ex) {
                throw ex;
            }
        }
        
        
        
        /**
         *  This method is used for SoldTo searching : We can search sold to account by account name or account number, 
         *  user can only get sold-to account whose account_manager_c equals to current user ID and type!=OEM
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
        public override String getSearchResult(String sData){
            set<String> set_acctIds = new set<String>();
            CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData, CSD_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb:'+searchOb);
            
            CSD_ClsUtils.setTerritoryAccountSetByUserId(set_acctIds, CSD_ClsUtils.getManageUserId(searchOb.managerId));
            //CSD_ClsUtils.setTerritoryAccountSetByUserId(set_acctIds, CSD_ClsUtils.TEMPUSERID);
            
            list<CSD_ClsEntityType.AccountObj> list_soldTos = new list<CSD_ClsEntityType.AccountObj>();
            String searchNameOrNumber = '%'+searchOb.searchKey+'%';
            
            Date fiscaldate = Date.valueOf(searchOb.startDate);
            Date enddate = Date.valueOf(searchOb.endDate);
            
            //Date fiscaldate = CSD_ClsUtils.getFiscalDate();
            //Date enddate = fiscaldate.addMonths(13);
            //if(searchOb.set_selectedId == null || searchOb.set_selectedId.size() == 0){
            if(searchOb.set_selectedId == null) {
                searchOb.set_selectedId = new set<string>();
            }
            if(searchOb.set_deletedId == null){
                searchOb.set_deletedId = new set<string>();
            }
            
            list<String> list_sql = new list<String>();
            list_sql.add(' Sold_To_Number__c soldto ');
            list_sql.add(' CSD_Sales_Forecast__c ');
            list_sql.add(' WHERE Type__c = \'Sold-To\' '
                    + ' And Sold_To_Number__c in : set_acctIds ' 
                    + ' And Fiscal_Date__c >= : fiscaldate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Sold_To_Number__c ');
            
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                if(!searchOb.set_selectedId.contains((String)result.get('soldto')) && !searchOb.set_deletedId.contains((String)result.get('soldto'))) {
                    searchOb.set_selectedId.add((String)result.get('soldto'));
                }
            }
            //}
            set<String> set_unselectedid = new set<String>();
            for(String accnumber : set_acctIds) {
                if(!searchOb.set_selectedId.contains(accnumber)) {
                    set_unselectedid.add(accnumber);
                }
            }
            
            map<String, CSD_ClsEntityType.AccountObj> map_number_acc = new map<String, CSD_ClsEntityType.AccountObj>();
            
            if(set_unselectedid.size() > 0) {
                
                map<String, String> map_accid_region = CSD_ClsUtils.getRegionForSoldTo(set_unselectedid, '', '');
                
                system.debug('@#map_accid_region:'+map_accid_region);
                for(Account acc : [select Id, Name, AccountNumber, CSD_EOL_Comment__c from Account where AccountNumber != null 
                                    and AccountNumber IN :set_unselectedid
                                    and (Name like :searchNameOrNumber or AccountNumber like :searchNameOrNumber) 
                                    and RecordType.Name = 'Account' and STATDESC__c = 'Active'
                                    order by AccountNumber, Name limit 100]) {
                    if(!map_number_acc.containsKey(acc.AccountNumber)) {
                        CSD_ClsEntityType.AccountObj soldTo = new CSD_ClsEntityType.AccountObj();
                        CSD_ClsUtils.createAccountObj(soldTo, searchOb.map_year_monthsFuture);
                        Blob aes = Crypto.generateAesKey(128);
                        String hex = EncodingUtil.convertToHex(aes);
                        soldTo.id = hex;
                        soldTo.name = acc.Name;
                        soldTo.accnumber = acc.AccountNumber;
                        soldTo.region = map_accid_region.containsKey(acc.AccountNumber) ? map_accid_region.get(acc.AccountNumber) : '';
                        soldTo.snumber = acc.AccountNumber;
                        soldTo.eolcomment = acc.CSD_EOL_Comment__c;
                        map_number_acc.put(acc.AccountNumber, soldTo);
                    }
                }
                
                list_sql.clear();
                list_sql.add('Sold_To_Number__c soldto, Fiscal_Year__c year, Fiscal_Month__c month, '
                        + 'sum(DC_Forecast_Amount__c) sumDCFC, sum(Forecast__c) sumFC, sum(Previous_Month_Forecast__c) sumPMFC');  
                list_sql.add(' CSD_Sales_Forecast__c ');
                list_sql.add(' WHERE Type__c = \'Sold-To\' '
                            + ' And Sold_To_Number__c in : set_unselectedid ' 
                            + ' And Fiscal_Date__c >= : fiscaldate '
                            + ' And Fiscal_Date__c < : enddate '
                            + ' Group by Fiscal_Year__c, Fiscal_Month__c, Sold_To_Number__c ');
                            
                for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                    String accId = (String)result.get('soldto'), 
                       year = (String)result.get('year'),
                       month = (String)result.get('month'), 
                       dateKey = (year + '_' + month);
                    
                    if(!map_number_acc.containsKey(accId)) {
                        continue;
                    }else {
                        
                        map_number_acc.get(accId).csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
                        map_number_acc.get(accId).dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
                        map_number_acc.get(accId).pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
                    }
                }
            }
            
            if(map_number_acc.size() > 0) {
                list_soldTos.addAll(map_number_acc.values());
            }
            
            return JSON.serialize(list_soldTos);
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
            system.debug('asdfsData1'+sData);
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
                    //futrue old
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
                        system.debug('!@# startDate:'+startDate);
                        list<String> list_futruesql = new list<String>();
                        list_futruesql.add(' Customer__r.AccountNumber refId, sum(Backlog_Amount_USD__c) amount ');
                        list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
                        list_futruesql.add(' WHERE Customer__r.AccountNumber = \''+ searchOb.accnumber +'\' '
                            + ' And Customer__r.STATDESC__c = \'Active\' '
                            + ' And Customer_Request_Date__c >= :startDate '
                            + ' And Customer_Request_Date__c <= :endDate '
                            + ' Group by Customer__r.AccountNumber  ');   
                             
                        CSD_ClsUtils.setSoldToMapRefDataBacklog(currentdate, startDate, endDate, list_futruesql, map_acctId_map_dateKey_result_futrue);
                        
                    }
                }
                CSD_ClsEntityType.CSDRefObj refdata = CSD_ClsUtils.createRefDataObj();
                refdata.id = searchOb.accnumber;
                
                CSD_ClsUtils.setRefDateObjectBacklog(list_beforedate, list_futruedate, refdata,
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
        } 
    }


    public class SearchRestSoldTo extends CSD_Interface.ACSDRemoteService{
        
        public override String saveSObjectData(String sData) { 
            
            try {
                CSD_ClsEntityType.AccountObj valueobj = (CSD_ClsEntityType.AccountObj)JSON.deserialize(sData,CSD_ClsEntityType.AccountObj.class);
                
                //1.select SoldTo Accounts of not include in the selected SoldTo Account .
                //2.get rest SoldTo Accounts ratio.
                //3.set each rest SoldTo Account forecast value.
                set<String> set_acctIds = new set<String>();
                CSD_ClsUtils.setTerritoryAccountSetByUserId(set_acctIds, CSD_ClsUtils.getManageUserId(valueobj.managerId));
                //CSD_ClsUtils.setTerritoryAccountSetByUserId(set_acctIds, CSD_ClsUtils.TEMPUSERID);
                
                //get Fiscal Date
                Date fiscaldate = CSD_ClsUtils.getFiscalDate();
                Date startdate = fiscaldate.addMonths(-6);
                
                set<String> set_selectedId = new set<String>();
                list<String> list_sql = new list<String>();
                list_sql.add(' Sold_To_Number__c soldto ');
                list_sql.add(' CSD_Sales_Forecast__c ');
                list_sql.add(' WHERE Type__c = \'Sold-To\' '
                        + ' And Sold_To_Number__c in : set_acctIds '
                        + ' And Samsung_Type__c = null ' 
                        + (CSD_Configuration__c.getInstance('Samsung OEM Account') != null && CSD_Configuration__c.getInstance('Samsung OEM Account').Value__c != '' ? ' And OEM__c != \'' + CSD_Configuration__c.getInstance('Samsung OEM Account').Value__c + '\' ' : '')
                        + ' Group by Sold_To_Number__c ');
                
                for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                    set_selectedId.add((String)result.get('soldto'));
                }
                
                set<String> set_restaccId = new set<String>();
                for(String accid : set_acctIds) {
                    if(!set_selectedId.contains(accid)) {
                        set_restaccId.add(accid);
                    }
                }
                system.debug('@#set_selectedId:'+set_selectedId);
                system.debug('@#set_restaccId:'+set_restaccId);
                
                //get rest SoldTo Accounts ratio
                list_sql.clear();
                list_sql.add(' Customer__r.AccountNumber soldto, sum(Bill_Amount_USD__c) amount ');
                list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                list_sql.add(' WHERE Customer__r.AccountNumber IN : set_restaccId ' 
                        + ' And Fiscal_Date__c >= : startdate '
                        + ' And Fiscal_Date__c < : fiscaldate '
                        + ' group by Customer__r.AccountNumber ');
                map<String, decimal> map_accid_amount = new map<String, decimal>();
                decimal allamount = 0;
                for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                    if(result.get('amount') != null ) {
                        decimal amount = (decimal)result.get('amount');
                        allamount += amount;
                        map_accid_amount.put((String)result.get('soldto'), amount);
                    }
                }
                
                map<String, decimal> map_accid_ratio = new map<String, decimal>();
                for(String accid : set_restaccId) {
                    decimal ratio = 0;
                    if( map_accid_amount.get(accid) != null && map_accid_amount.get(accid) != 0) {
                        decimal amount = map_accid_amount.get(accid);
                        ratio = amount / allamount;
                    }
                    map_accid_ratio.put(accid, ratio);
                }
                
                //3.set each rest SoldTo Account forecast value.
                map<String, CSD_Sales_Forecast__c> map_date_forecast = new map<String, CSD_Sales_Forecast__c>();
                
                map<String, map<String, CSD_Sales_Forecast__c>> map_key_map_dateKey_result = 
                            new map<String, map<String, CSD_Sales_Forecast__c>>();
                            
                for(CSD_Sales_Forecast__c fc : [select Id, Fiscal_Year__c, Fiscal_Month__c, Sold_To_Number__c, Forecast__c, Type__c
                                                From CSD_Sales_Forecast__c 
                                                where Sold_To_Number__c IN : set_restaccId And Type__c = 'Rest-SoldTo']) {
                    String accId = fc.Sold_To_Number__c, 
                            year = (String)fc.Fiscal_Year__c,
                            month = (String)fc.Fiscal_Month__c, 
                            dateKey = (year + '_' + month);
                    if(!map_key_map_dateKey_result.containsKey(accId)) {
                        map_key_map_dateKey_result.put(accId, new map<String, CSD_Sales_Forecast__c>());
                    }
                    if(!map_key_map_dateKey_result.get(accId).containsKey(dateKey)) {
                        map_key_map_dateKey_result.get(accId).put(dateKey, fc);
                    }
                }

                map<String, String> map_accid_region = new map<String, String>(),
                                    map_accid_name = new map<String, String>();
                map_accid_region  = CSD_ClsUtils.getRegionForSoldTo(set_restaccId, '', '');
                
                list<CSD_Sales_Forecast__c> list_forecast = new list<CSD_Sales_Forecast__c>();
                
                for(Account a : [Select Name, AccountNumber from Account Where AccountNumber IN: set_restaccId]){
                    map_accid_name.put(a.AccountNumber, a.Name);
                }
                
                for(String dateKey : valueobj.csFC.keySet() ) {
                    String year = dateKey.substring(0, dateKey.indexOf('_'));
                    String month = dateKey.substring(dateKey.indexOf('_')+1, dateKey.length());
                    
                    for(String acctId : set_restaccId) {
                        CSD_Sales_Forecast__c forecast = new CSD_Sales_Forecast__c(
                            Sold_To_Number__c = acctId, Billing_Region__c = map_accid_region.get(acctId),
                            Price__c = 0, Quantity__c = 0, Fiscal_Year__c = year, Fiscal_Month__c = month,
                            Forecast__c = valueobj.csFC.get(dateKey) * map_accid_ratio.get(acctId),
                            CurrencyIsoCode = 'USD', Type__c = 'Rest-SoldTo',
                            Sold_To_Name__c = (map_accid_name.containsKey(acctId) ? map_accid_name.get(acctId) : null)
                        );

                        if(map_key_map_dateKey_result.containsKey(acctId) && map_key_map_dateKey_result.get(acctId).containsKey(dateKey)) {
                            forecast.Id = map_key_map_dateKey_result.get(acctId).get(dateKey).Id;
                        }
                        list_forecast.add(forecast);
                    }
                }

                if(list_forecast.size() > 0) {
                    upsert list_forecast;
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
                CSD_ClsUtils.setTerritoryAccountSetByUserId(set_acctIds, CSD_ClsUtils.getManageUserId(searchOb.managerId));
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
        system.debug('asdfsData2'+sData);
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
                CSD_ClsUtils.setTerritoryAccountSetByUserId(set_acctIds, CSD_ClsUtils.getManageUserId(searchOb.managerId));
                set<String> set_restacctIds = new set<String>();
                for(String accnum : set_acctIds) {
                    if(!searchOb.set_selectedId.contains(accnum)) {
                        set_restacctIds.add(accnum);
                    }
                }
                
                if(list_futruedate.size() > 0 && set_restacctIds.size() > 0) {
                    //futrue
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
                    CSD_ClsUtils.setTotelBillingDataNew(years, months, set_restacctIds, list_futruesql, map_acctId_map_dateKey_result_futrue);
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
                
                CSD_ClsUtils.setRefDateObjectBacklog(list_beforedate, list_futruedate, refdata,
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
        } 

    }
    
    
    public class SearchOEM extends CSD_Interface.ACSDRemoteService{
        
        public override String saveSObjectData(String sData) { 
            
            try {
                //system.debug('@#sData: '+sData);
                CSD_ClsEntityType.AccountObj valueobj = (CSD_ClsEntityType.AccountObj)JSON.deserialize(sData,CSD_ClsEntityType.AccountObj.class);
                
                map<String, CSD_Sales_Forecast__c> map_date_forecast = new map<String, CSD_Sales_Forecast__c>();
                for(CSD_Sales_Forecast__c fc : [select Id, Fiscal_Year__c, Fiscal_Month__c, Sold_To_Number__c
                                                , OEM__c, Part__c, Price__c, Quantity__c, Forecast__c, Type__c
                                                From CSD_Sales_Forecast__c 
                                                where Sold_To_Number__c = : valueobj.accnumber And OEM__c = :valueobj.oemId And Type__c = 'OEM']) {
                     map_date_forecast.put((fc.Fiscal_Year__c + '_' + fc.Fiscal_Month__c ), fc);
                }
                
                
                //system.debug('@#valueobj: '+valueobj);
                if(valueobj.csFC != null) {
                    list<CSD_Sales_Forecast__c> list_forecast = new list<CSD_Sales_Forecast__c>();
                    for(String key : valueobj.csFC.keySet()) {
                        CSD_Sales_Forecast__c forecast = new CSD_Sales_Forecast__c(
                            Price__c = 0, Quantity__c = 0, Forecast__c = valueobj.csFC.get(key), Rest_Parts_Forecast__c = valueobj.restPNFC.get(key),
                            Fiscal_Year__c = key.substring(0, key.indexOf('_')), Fiscal_Month__c = key.substring(key.indexOf('_')+1, key.length()),
                            Sold_To_Number__c = valueobj.accnumber, Sold_To_Name__c = valueobj.name, Type__c = 'OEM',
                            OEM__c = valueobj.oemId, Billing_Region__c = valueobj.region, CurrencyIsoCode = 'USD'
                        );
                        /*
                        forecast.Price__c = 0;
                        forecast.Quantity__c = 0;
                        forecast.Forecast__c = valueobj.csFC.get(key);
                        forecast.Rest_Parts_Forecast__c = valueobj.restPNFC.get(key);
                        forecast.Fiscal_Year__c = key.substring(0, key.indexOf('_'));
                        forecast.Fiscal_Month__c = key.substring(key.indexOf('_')+1, key.length());
                        forecast.Sold_To_Number__c = valueobj.accnumber;
                        forecast.OEM__c = valueobj.oemId;
                        forecast.Type__c = 'OEM';
                        forecast.Billing_Region__c = valueobj.region;
                        forecast.CurrencyIsoCode = 'USD';
                        */
                        if(map_date_forecast.containsKey(key)) {
                            forecast.Id = map_date_forecast.get(key).Id;
                        }
                        list_forecast.add(forecast);
                    }
                    if(list_forecast.size() > 0) { 
                        upsert list_forecast;
                    }
                }
                return 'true';
            }catch(Exception ex) {
                throw ex;
            }
        }
        
        
        public override String deleteCSDObject(String sData) { 
            try {
                CSD_ClsEntityType.SearchObj valueobj = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
                //TO DO
                
                list<CSD_Sales_Forecast__c> list_forecast = new list<CSD_Sales_Forecast__c>();
                //map<String, CSD_Sales_Forecast__c> map_date_forecast = new map<String, CSD_Sales_Forecast__c>();
                for(CSD_Sales_Forecast__c fc : [select Id, Fiscal_Year__c, Fiscal_Month__c, Sold_To_Number__c
                                                , OEM__c, Part__c, Price__c, Quantity__c, Forecast__c, Type__c
                                                From CSD_Sales_Forecast__c 
                                                where Sold_To_Number__c = :valueobj.accnumber and OEM__c = :valueobj.oemId 
                                                    //and CreatedById = :UserInfo.getUserId() 
                                                    ]) {
                     
                     list_forecast.add(fc);
                }
                if(list_forecast.size() > 0){
                    delete list_forecast;
                }

                return 'true'; 
            }catch(Exception ex) {
                throw ex;
            }
        }
        
        /**
         *  This method is used for OEM searching : you can only find OEMs which Account Type = OEM and Profit center = CSD.
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
        public override String getSearchResult(String sData){
            list<CSD_ClsEntityType.OEMAccountObj> list_oems = new list<CSD_ClsEntityType.OEMAccountObj>();
            CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
            
            if(searchOb.isOtherMethod) {
                return getOEMFrmHistory(sData);
            }
            
            Date fiscaldate = Date.valueOf(searchOb.startDate);
            Date enddate = Date.valueOf(searchOb.endDate);
            
            //Date fiscaldate = CSD_ClsUtils.getFiscalDate();
            //Date enddate = fiscaldate.addMonths(13);
            String searchNameOrNumber = '%'+searchOb.searchKey+'%';
            
            if(searchOb.set_selectedId == null){
                searchOb.set_selectedId = new set<string>();
            }
            if(searchOb.set_deletedId == null){
                searchOb.set_deletedId = new set<string>();
            }
            
            list<String> list_sql = new list<String>();
            list_sql.add(' OEM__c oem ');
            list_sql.add(' CSD_Sales_Forecast__c ');
            list_sql.add(' WHERE Type__c = \'OEM\' '
                    + ' And Sold_To_Number__c = \''+searchOb.accnumber+'\'  ' 
                    + ' And Fiscal_Date__c >= : fiscaldate '
                    + ' And Fiscal_Date__c < : enddate '
                    + (CSD_Configuration__c.getInstance('Samsung OEM Account') != null && CSD_Configuration__c.getInstance('Samsung OEM Account').Value__c != '' ? ' And OEM__c != \'' + CSD_Configuration__c.getInstance('Samsung OEM Account').Value__c + '\' ' : '')
                    + ' Group by OEM__c ');
            
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                if(!searchOb.set_selectedId.contains((String)result.get('oem')) && !searchOb.set_deletedId.contains((String)result.get('oem'))) { 
                    searchOb.set_selectedId.add((String)result.get('oem'));
                }
            }
            system.debug('@#searchOb.set_selectedId:'+searchOb.set_selectedId);
            map<String, Account> map_oemid_oem = new map<String, Account>();
            /*String samsung = (CSD_Configuration__c.getInstance('Samsung OEM Account') != null && CSD_Configuration__c.getInstance('Samsung OEM Account').Value__c != '' ? CSD_Configuration__c.getInstance('Samsung OEM Account').Value__c : '' );
            if(samsung != '' && !searchOb.set_selectedId.contains(samsung.substring(0,15))) {
                searchOb.set_selectedId.add(samsung.substring(0,15));
            }*/
            for(Account acc : [select Id, Name, OEM_ID__c, Rank__c, Account_Manager__r.Name from Account 
                                where RecordType.Name = 'OEM' 
                                    and Active__c = true 
                                    and Id not IN :searchOb.set_selectedId
                                    //and Profit_ctr_code__c = 'CSD' 
                                    and Id != :CSD_Configuration__c.getInstance('Samsung OEM Account').Value__c
                                    //and Name != 'OTHERS'
                                    and OEM_ID__c != '000'
                                    and (Name like :searchNameOrNumber or OEM_ID__c like :searchNameOrNumber or Account_Manager__r.Name like :searchNameOrNumber) 
                                    limit 100]) {
                //if(!searchOb.set_selectedId.contains(acc.Id)){
                    map_oemid_oem.put(acc.Id, acc);
                //}
            }
            
            system.debug('@#map_oemid_oem: '+map_oemid_oem);
            if(map_oemid_oem.size() > 0) {
                map<String, String> map_oem_region = CSD_ClsUtils.getOEMRegion(searchOb.accnumber, map_oemid_oem.keySet());
                map<String, CSD_ClsEntityType.OEMAccountObj> map_oemId_result = new map<String, CSD_ClsEntityType.OEMAccountObj>();
                
                for(String oemid : map_oemid_oem.keySet()) {
                    Account acc = map_oemid_oem.get(oemid);
                    CSD_ClsEntityType.OEMAccountObj oem = new CSD_ClsEntityType.OEMAccountObj();
                    CSD_ClsUtils.createOEMAccountObj(oem, searchOb.map_year_monthsFuture);
                    
                    oem.id = acc.Id;
                    oem.name = acc.Name;
                    oem.snumber = (acc.OEM_ID__c == null ? '' : acc.OEM_ID__c);
                    oem.region = map_oem_region.containsKey(oem.id.substring(0,15)) ? map_oem_region.get(oem.id.substring(0,15)) : '';
                    
                    oem.rank = (acc.Rank__c == null ? '' : acc.Rank__c);
                    oem.accmanager = (acc.Account_Manager__r.Name == null ? '' : acc.Account_Manager__r.Name);
                    map_oemId_result.put(oem.id, oem);
                    //list_oems.add(oem);
                }
                
                list_sql.clear();
                list_sql.add('OEM__c oem, Fiscal_Year__c year, Fiscal_Month__c month,'
                    + ' sum(Forecast__c) sumFC, sum(Rest_Parts_Forecast__c) restPNFC,'
                    + ' sum(DC_Forecast_Amount__c) sumDCFC, sum(Previous_Month_Forecast__c) sumPMFC');
                list_sql.add(' CSD_Sales_Forecast__c ');
                list_sql.add(' WHERE Sold_To_Number__c = \''+ searchOb.accnumber +'\' ' 
                    + ' And Type__c = \'OEM\''
                    + ' And Fiscal_Date__c >= : fiscaldate '
                    + ' And Fiscal_Date__c < : enddate '
                    + (CSD_Configuration__c.getInstance('Samsung OEM Account') != null && CSD_Configuration__c.getInstance('Samsung OEM Account').Value__c != '' ? ' And OEM__c != \'' + CSD_Configuration__c.getInstance('Samsung OEM Account').Value__c + '\' ' : '')
                    + ' Group by OEM__c, Fiscal_Year__c, Fiscal_Month__c  ');
                            
                for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                    String accId = (String)result.get('oem'), 
                       year = (String)result.get('year'),
                       month = (String)result.get('month'), 
                       dateKey = (year + '_' + month);
                    
                    if(!map_oemId_result.containsKey(accId)) {
                        continue;
                    }else {
                        
                        map_oemId_result.get(accId).csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
                        map_oemId_result.get(accId).dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
                        map_oemId_result.get(accId).pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
                    }
                }
                list_oems = map_oemId_result.values();
            }
            list_oems.sort();
            system.debug('@#list_oems:'+list_oems);
            return JSON.serialize(list_oems);
        }
        
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
                    + (CSD_Configuration__c.getInstance('Samsung OEM Account') != null && CSD_Configuration__c.getInstance('Samsung OEM Account').Value__c != '' ? ' And OEM__c != \'' + CSD_Configuration__c.getInstance('Samsung OEM Account').Value__c + '\' ' : '')
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
            
            map<String, CSD_ClsEntityType.AccountObj> map_acctId_keyOEM = new map<String, CSD_ClsEntityType.AccountObj>();
            
            Date fiscaldate = CSD_ClsUtils.getFiscalDate();
            set<String> set_acctIds = new set<String>();
            set_acctIds.add(searchOb.accnumber);
            map<String, set<String>> map_hasBillingSoldto_OEMs = new map<String, set<String>>();
            CSD_ClsUtils.setautoOEMIds(map_hasBillingSoldto_OEMs, set_acctIds, fiscaldate);
            
            set<String> set_keyOEMs = new set<String>();
            if(map_hasBillingSoldto_OEMs.containsKey(searchOb.accnumber)) {
                set_keyOEMs.addAll(map_hasBillingSoldto_OEMs.get(searchOb.accnumber));
            }
            map<String, String> map_oem_region = CSD_ClsUtils.getOEMRegion(searchOb.accnumber, map_acctId_map_dateKey_result.keySet());
            system.debug('@#map_oem_region:'+map_oem_region);
            for(String acctId : map_acctId_map_dateKey_result.keySet()) {
                CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
                CSD_ClsUtils.createAccountObj(acctFC, searchOb.map_year_monthsFuture);
                
                acctFC.id = acctId;
                acctFC.region = map_oem_region.containsKey(acctId.substring(0,15)) ? map_oem_region.get(acctId.substring(0,15)) : '';
                if(set_keyOEMs.contains(acctId)) {
                    acctFC.type = 'NoDel';
                    map_acctId_keyOEM.put(acctId, acctFC);
                }else {
                    map_acctId_acctFC.put(acctId, acctFC);
                }
                //acctFC.type = (set_keyOEMs.containsKey(acctId) ? 'NoDel' : '');
                //map_acctId_acctFC.put(acctId, acctFC);
                
                for(String year : searchOb.map_year_monthsFuture.keySet()) {
                    for(Integer month : searchOb.map_year_monthsFuture.get(year)) {
                        String dateKey = (year + '_' + String.valueOf(month));
                        AggregateResult result;
                        
                        if(map_acctId_map_dateKey_result.containsKey(acctId) 
                            && map_acctId_map_dateKey_result.get(acctId).containsKey(dateKey)) {
                            result = map_acctId_map_dateKey_result.get(acctId).get(dateKey);
                        }
                        
                        CSD_ClsEntityType.AccountObj oemacc = null;
                        if(set_keyOEMs.contains(acctId)) {
                            oemacc = map_acctId_keyOEM.get(acctId);
                        }else {
                            oemacc = map_acctId_acctFC.get(acctId);
                        }
                        
                        if(result != null) {
                            oemacc.name = (String)result.get('accname');
                            oemacc.csFC.put(dateKey, (result.get('forecast') != null ? (decimal)result.get('forecast') : 0));
                            oemacc.restPNFC.put(dateKey, (result.get('restPNFC') != null ? (decimal)result.get('restPNFC') : 0));
                            oemacc.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
                            oemacc.pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
                        }                    
                    }
                }
            }
            
            list<CSD_ClsEntityType.AccountObj> list_oemFC = new list<CSD_ClsEntityType.AccountObj>();
            list_oemFC.addAll(map_acctId_acctFC.values());
            list_oemFC.sort();
            
            list<CSD_ClsEntityType.AccountObj> list_keyoemFC = new list<CSD_ClsEntityType.AccountObj>();
            list_keyoemFC.addAll(map_acctId_keyOEM.values());
            list_keyoemFC.sort();
            
            map<String, CSD_ClsEntityType.AccountObj> map_acctId_NonOEM = new map<String, CSD_ClsEntityType.AccountObj>();
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
                
                map<String,String> map_nonoem_regin = CSD_ClsUtils.getOEMRegion(searchOb.accnumber,new set<String>{nonoemid});
                
                CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
                acctFC.id = nonoemid;
                acctFC.name = 'NON OEM';
                acctFC.csFC = new map<String, decimal>();
                acctFC.dcFC = new map<String, decimal>();
                acctFC.pmFC = new map<String, decimal>();
                acctFC.restPNFC = new map<String, decimal>();
                acctFC.region = map_nonoem_regin.containsKey(nonoemid.substring(0,15)) ? map_nonoem_regin.get(nonoemid.substring(0,15)) : '';
                acctFC.type = 'NoDel';
                
                map_acctId_NonOEM.put(nonoemid, acctFC);
                
                for(String year : searchOb.map_year_monthsFuture.keySet()) {
                    for(Integer month : searchOb.map_year_monthsFuture.get(year)) {
                        String dateKey = (year + '_' + String.valueOf(month));
                        AggregateResult result;
                        
                        if(map_acctId_map_dateKey_result.containsKey(nonoemid) 
                            && map_acctId_map_dateKey_result.get(nonoemid).containsKey(dateKey)) {
                            
                            result = map_acctId_map_dateKey_result.get(nonoemid).get(dateKey);
                        }
                        
                        
                        if(result != null) {
                            
                            map_acctId_NonOEM.get(nonoemid).csFC.put(dateKey, (result.get('forecast') != null ? (decimal)result.get('forecast') : 0));
                            map_acctId_NonOEM.get(nonoemid).restPNFC.put(dateKey, (result.get('restPNFC') != null ? (decimal)result.get('restPNFC') : 0));
                            map_acctId_NonOEM.get(nonoemid).dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
                            map_acctId_NonOEM.get(nonoemid).pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
                        }else {
                            map_acctId_NonOEM.get(nonoemid).csFC.put(dateKey, 0);
                            map_acctId_NonOEM.get(nonoemid).restPNFC.put(dateKey, 0);
                            map_acctId_NonOEM.get(nonoemid).dcFC.put(dateKey, 0);
                            map_acctId_NonOEM.get(nonoemid).pmFC.put(dateKey, 0);
                        }
    
                    }
                }   

            }
            
            list<CSD_ClsEntityType.AccountObj> list_accFC = new list<CSD_ClsEntityType.AccountObj>();
            
            list_accFC.addAll(list_oemFC);
            list_accFC.addAll(list_keyoemFC);
            list_accFC.addAll(map_acctId_NonOEM.values());
            //list_accFC.sort();
            
            list<CSD_ClsEntityType.AccountObj> list_sortaccFC = new list<CSD_ClsEntityType.AccountObj>();
            for(Integer i = list_accFC.size()-1; i > -1; i--) {
                list_sortaccFC.add(list_accFC.get(i));
            }
            
            system.debug('@#list_sortaccFC :' + list_sortaccFC);
            return Json.serialize(list_sortaccFC);
        }
        
        
        
        
        
        /**
         *  This method is used to Add all OEM from History, it can provide sales a possibility to 
         *    add all OEMs that TE has business in last 6 month with by one click. The founded OEMs 
         *    should also has business with the current sold-to account
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
        public String getOEMFrmHistory(String sData){
            list<CSD_ClsEntityType.OEMAccountObj> list_oems = new list<CSD_ClsEntityType.OEMAccountObj>();
            CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
            set<string> set_OEMIds = new set<string>();
            list<String> list_sql = new list<String>();
            
            Date fiscaldate = Date.valueOf(searchOb.startDate);
            Date enddate = Date.valueOf(searchOb.endDate);
            //Date fiscaldate = CSD_ClsUtils.getFiscalDate();
            //Date enddate = fiscaldate.addMonths(13);
            if(searchOb.set_selectedId == null){
                searchOb.set_selectedId = new set<string>();
            }
            if(searchOb.set_deletedId == null){
                searchOb.set_deletedId = new set<string>();
            }
                
            list_sql.add(' OEM__c oem ');
            list_sql.add(' CSD_Sales_Forecast__c ');
            list_sql.add(' WHERE Type__c = \'OEM\' '
                    + ' And Sold_To_Number__c = \''+ searchOb.accnumber +'\' ' 
                    + ' And Fiscal_Date__c >= : fiscaldate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by OEM__c ');
            
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                if(!searchOb.set_selectedId.contains((String)result.get('oem')) && !searchOb.set_deletedId.contains((String)result.get('oem'))) { 
                    searchOb.set_selectedId.add((String)result.get('oem'));
                }
            }
            
            //system.debug('@#searchOb.set_selectedId : '+searchOb.set_selectedId);
            list_sql.clear();
            Date earliestDate = CSD_ClsUtils.getFiscalDate().addMonths(-6).addDays(-15);
            
            list_sql.add('OEM_Mapping__r.OEM__r.OEM__c OEMId, OEM_Mapping__r.OEM__r.OEM__r.Name OEMname, '
                    + ' OEM_Mapping__r.OEM__r.OEM__r.Rank__c rank, OEM_Mapping__r.OEM__r.OEM__r.Account_Manager__r.Name accmanager, '
                    + ' OEM_Mapping__r.OEM__r.OEM__r.AccountNumber OEMaccNum ');
            list_sql.add('CSD_OEM_Mapping_Monthly_BBB__c ');   
            list_sql.add(' where Monthly_Billings_Bookings_by_Part__r.Customer__r.AccountNumber = \''+searchOb.accnumber+'\''
                    + ' and (Monthly_Billings_Bookings_by_Part__r.Fiscal_Date__c >=  :earliestDate) '
                    //+ ' and OEM_Mapping__r.OEM__r.OEM__r.Profit_ctr_code__c = \'CSD\' '
                    + ' and OEM_Mapping__r.OEM__r.OEM__r.Active__c = true '
                    + ' and OEM_Mapping__r.OEM__r.OEM__r.Name != \'OTHERS\' '
                    + (CSD_Configuration__c.getInstance('Samsung OEM Account') != null && CSD_Configuration__c.getInstance('Samsung OEM Account').Value__c != '' ? ' And OEM_Mapping__r.OEM__r.OEM__c != \'' + CSD_Configuration__c.getInstance('Samsung OEM Account').Value__c + '\' ' : '')
                    + ' and Monthly_Billings_Bookings_by_Part__r.Customer__r.STATDESC__c = \'Active\' '
                    + ' group by OEM_Mapping__r.OEM__r.OEM__c, OEM_Mapping__r.OEM__r.OEM__r.Name, OEM_Mapping__r.OEM__r.OEM__r.AccountNumber, OEM_Mapping__r.OEM__r.OEM__r.Rank__c, OEM_Mapping__r.OEM__r.OEM__r.Account_Manager__r.Name '
                    + ' order by OEM_Mapping__r.OEM__r.OEM__r.Rank__c NULLS LAST, OEM_Mapping__r.OEM__r.OEM__r.Name');
            
            map<String, AggregateResult> map_oemid_oem = new map<String, AggregateResult>();
            
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                if(!set_OEMIds.contains((String)result.get('OEMId')) && !searchOb.set_selectedId.contains((String)result.get('OEMId'))){
                    map_oemid_oem.put((String)result.get('OEMId'), result);
                    
                    
                }
            }
            
            if(map_oemid_oem.size() > 0) {
                map<String, String> map_oem_region = CSD_ClsUtils.getOEMRegion(searchOb.accnumber, map_oemid_oem.keySet());
                
                for(String oemid : map_oemid_oem.keySet()) {
                    AggregateResult result = map_oemid_oem.get(oemid);
                    CSD_ClsEntityType.OEMAccountObj oem = new CSD_ClsEntityType.OEMAccountObj();
                    oem.id = (String)result.get('OEMId');
                    oem.name = (String)result.get('OEMname');
                    oem.snumber = (String)result.get('OEMaccNum');
                    oem.region = map_oem_region.containsKey(oemid.substring(0,15)) ? map_oem_region.get(oemid.substring(0,15)) : '';
                    
                    oem.rank = (result.get('rank') == null ? '' : (String)result.get('rank'));
                    oem.accmanager = (result.get('accmanager') == null ? '' : (String)result.get('accmanager'));
                    
                    list_oems.add(oem);
                    set_OEMIds.add((String)result.get('OEMId'));
                }
            }
            
            list_oems.sort();
            
            return JSON.serialize(list_oems);
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
            system.debug('asdfsData3'+sData);
            try {
                CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
                
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                system.debug('asdf1'+searchOb );
                CSD_ClsUtils.setRefDatelist(list_beforedate, list_futruedate, searchOb.set_fiscalMonth);


                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();
                if(list_futruedate.size() > 0) {
                    //futrue
                    /* old
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    CSD_ClsUtils.setRefForecastDate(years, months, list_futruedate);
                    system.debug('asdf11'+years );            
                    system.debug('asdf12'+months);
                    system.debug('asdf13'+list_futruedate);
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
                    system.debug('asdf2'+set_dailyIds);
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
                        system.debug('!@# set_dailyIds:'+set_dailyIds );
                        list<String> list_futruesql = new list<String>();
                        list_futruesql.add(' Customer__r.AccountNumber refId, sum(Backlog_Amount_USD__c) amount ');
                        list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
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
    
    
    public class SearchNonOEMs extends CSD_Interface.ACSDRemoteService{
        
        public override String saveSObjectData(String sData) { 
            
            try {
                CSD_ClsEntityType.AccountObj valueobj = (CSD_ClsEntityType.AccountObj)JSON.deserialize(sData,CSD_ClsEntityType.AccountObj.class);
                system.debug('@#valueobj: '+valueobj);
                map<String, CSD_Sales_Forecast__c> map_date_forecast = new map<String, CSD_Sales_Forecast__c>();
                for(CSD_Sales_Forecast__c fc : [select Id, Fiscal_Year__c, Fiscal_Month__c, Sold_To_Number__c
                                                , OEM__c, Part__c, Price__c, Quantity__c, Forecast__c, Type__c
                                                From CSD_Sales_Forecast__c 
                                                where Sold_To_Number__c = : valueobj.accnumber And Type__c = 'Non-OEMs']) {
                     map_date_forecast.put((fc.Fiscal_Year__c + '_' + fc.Fiscal_Month__c ), fc);
                }
                if(CSD_Configuration__c.getInstance('Non OEM Account') == null || CSD_Configuration__c.getInstance('Non OEM Account').Value__c == null) {
                    return 'false';
                }

                String nonoemId = CSD_Configuration__c.getInstance('Non OEM Account').Value__c;
                
                list<CSD_Sales_Forecast__c> list_forecast = new list<CSD_Sales_Forecast__c>();
                for(String key : valueobj.csFC.keySet()) {
                    CSD_Sales_Forecast__c forecast = new CSD_Sales_Forecast__c(
                        Price__c = 0, Quantity__c = 0, Forecast__c = valueobj.csFC.get(key),
                        Rest_Parts_Forecast__c = valueobj.restPNFC.get(key), 
                        Fiscal_Year__c = key.substring(0, key.indexOf('_')),
                        Fiscal_Month__c = key.substring(key.indexOf('_')+1, key.length()),
                        Sold_To_Number__c = valueobj.accnumber, OEM__c = nonoemId, Billing_Region__c = valueobj.region,
                        Type__c = 'Non-OEMs', CurrencyIsoCode = 'USD', Sold_To_Name__c =  valueobj.name
                    );
                    /*
                    forecast.Price__c = 0;
                    forecast.Quantity__c = 0;
                    forecast.Forecast__c = valueobj.csFC.get(key);
                    forecast.Rest_Parts_Forecast__c = valueobj.restPNFC.get(key);
                    forecast.Fiscal_Year__c = key.substring(0, key.indexOf('_'));
                    forecast.Fiscal_Month__c = key.substring(key.indexOf('_')+1, key.length());
                    forecast.Sold_To_Number__c = valueobj.accnumber;
                    forecast.OEM__c = nonoemId;
                    //forecast.Part__c = valueobj.partId;
                    forecast.Billing_Region__c = valueobj.region;
                    forecast.Type__c = 'Non-OEMs';
                    forecast.CurrencyIsoCode = 'USD';
                    */
                    if(map_date_forecast.containsKey(key)) {
                        forecast.Id = map_date_forecast.get(key).Id;
                    }
                    list_forecast.add(forecast);
                }
                if(list_forecast.size() > 0) {
                    upsert list_forecast;
                }
                
                return 'true';
            }catch(Exception ex) {
                throw ex;
            }
        }
        
    }
    
    
    public class SearchPart extends CSD_Interface.ACSDRemoteService{
        
        public override String useASP(String sData) { 
            try {
                return CSD_ClsUtils.getASP(sData);
            }catch(Exception ex) {
                throw ex;
            }
        }
        
        public override String copyCFTForecast(String sData) { 
            try {
                return CSD_ClsUtils.copyCFTForecast(sData);
            }catch(Exception ex) {
                throw ex;
            }
        }
        
        public override String saveSObjectData(String sData) { 
            try {
                CSD_ClsEntityType.CSDForecastValueObj valueobj = (CSD_ClsEntityType.CSDForecastValueObj)JSON.deserialize(sData,CSD_ClsEntityType.CSDForecastValueObj.class);
                
                map<String, CSD_Sales_Forecast__c> map_date_forecast = new map<String, CSD_Sales_Forecast__c>();
                for(CSD_Sales_Forecast__c fc : [select Id, Fiscal_Year__c, Fiscal_Month__c, Sold_To_Number__c
                                                , OEM__c, Part__c, Price__c, Quantity__c, Forecast__c, Type__c
                                                From CSD_Sales_Forecast__c 
                                                where Sold_To_Number__c = : valueobj.accnumber And OEM__c = :valueobj.oemId And Part__c = :valueobj.partId And Type__c = 'Part']) {
                     map_date_forecast.put((fc.Fiscal_Year__c + '_' + fc.Fiscal_Month__c ), fc);
                }
                 
                list<CSD_Sales_Forecast__c> list_forecast = new list<CSD_Sales_Forecast__c>();
                for(String key : valueobj.csFC.keySet()) {
                    CSD_Sales_Forecast__c forecast = new CSD_Sales_Forecast__c(
                        Price__c = valueobj.csFC.get(key).price, Quantity__c = valueobj.csFC.get(key).quantity,
                        Forecast__c = valueobj.csFC.get(key).forecast, 
                        Fiscal_Year__c = key.substring(0, key.indexOf('_')), 
                        Fiscal_Month__c = key.substring(key.indexOf('_')+1, key.length()),
                        Sold_To_Number__c = valueobj.accnumber, OEM__c = valueobj.oemId, Part__c = valueobj.partId,
                        Billing_Region__c = valueobj.region, Type__c = 'Part',
                        CurrencyIsoCode = 'USD', Sold_To_Name__c=valueobj.name
                    );
                    /*
                    forecast.Price__c = valueobj.csFC.get(key).price;
                    forecast.Quantity__c = valueobj.csFC.get(key).quantity;
                    forecast.Forecast__c = valueobj.csFC.get(key).forecast;
                    forecast.Fiscal_Year__c = key.substring(0, key.indexOf('_'));
                    forecast.Fiscal_Month__c = key.substring(key.indexOf('_')+1, key.length());
                    forecast.Sold_To_Number__c = valueobj.accnumber;
                    forecast.OEM__c = valueobj.oemId;
                    forecast.Part__c = valueobj.partId;
                    forecast.Billing_Region__c = valueobj.region;
                    forecast.Type__c = 'Part';
                    forecast.CurrencyIsoCode = 'USD';
                    */
                    if(map_date_forecast.containsKey(key)) {
                        forecast.Id = map_date_forecast.get(key).Id;
                    }
                    list_forecast.add(forecast);
                }
                if(list_forecast.size() > 0) {
                    upsert list_forecast;
                }
                return 'true';
            }catch(Exception ex) {
                throw ex;
            }
        }
        
        
        public override String deleteCSDObject(String sData) { 
            try {
                CSD_ClsEntityType.SearchObj valueobj = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData, CSD_ClsEntityType.SearchObj.class);
                //TO DO
                list<CSD_Sales_Forecast__c> list_forecast = new list<CSD_Sales_Forecast__c>();
                //map<String, CSD_Sales_Forecast__c> map_date_forecast = new map<String, CSD_Sales_Forecast__c>();
                for(CSD_Sales_Forecast__c fc : [select Id, Fiscal_Year__c, Fiscal_Month__c, Sold_To_Number__c
                                                , OEM__c, Part__c, Price__c, Quantity__c, Forecast__c, Type__c
                                                From CSD_Sales_Forecast__c 
                                                where Sold_To_Number__c = : valueobj.accnumber 
                                                    and OEM__c = : valueobj.oemId 
                                                    and Part__c = : valueobj.partId
                                                    and Type__c = 'Part' 
                                                    //and CreatedById = :UserInfo.getUserId()
                                                    ]) {
                     
                     list_forecast.add(fc);
                }
                if(list_forecast.size() > 0){
                    delete list_forecast;
                }

                return 'true'; 
            }catch(Exception ex) {
                throw ex;
            }
        }
        
        /**
         *  This method is used for Part searching :  we can search by part description or part number, 
         *   the number of the displayed parts should be limited to 200. 
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
        public override String getSearchResult(String sData){
            list<CSD_ClsEntityType.PartObj> list_parts = new list<CSD_ClsEntityType.PartObj>();
            CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData, CSD_ClsEntityType.SearchObj.class);
            if(searchOb.isOtherMethod) {
                return getTopSalesParts(sData);
            }
            Date fiscaldate = Date.valueOf(searchOb.startDate);
            Date enddate = Date.valueOf(searchOb.endDate);
            
            //Date fiscaldate = CSD_ClsUtils.getFiscalDate();
            //Date enddate = fiscaldate.addMonths(13);
            String searchDescOrNumber = '%'+searchOb.searchKey+'%';
            
            if(searchOb.set_selectedId == null){
                searchOb.set_selectedId = new set<string>();
            }
            if(searchOb.set_deletedId == null){
                searchOb.set_deletedId = new set<string>();
            }
            
            list<String> list_sql = new list<String>();
            list_sql.add(' Part__c part ');
            list_sql.add(' CSD_Sales_Forecast__c ');
            list_sql.add(' WHERE Type__c = \'Part\' '
                    + ' And Sold_To_Number__c = \''+searchOb.accnumber+'\' ' 
                    + ' AND OEM__c = \''+searchOb.oemId+'\' '
                    + ' And Fiscal_Date__c >= : fiscaldate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Part__c ');
            system.debug('@#searchOb: '+searchOb);
            system.debug('@#list_sql: '+list_sql);
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                if(!searchOb.set_selectedId.contains((String)result.get('part')) && !searchOb.set_deletedId.contains((String)result.get('part'))){
                    searchOb.set_selectedId.add((String)result.get('part'));
                }
            }

            set<String> set_SamsungpPNs = new set<String>();
            for(AggregateResult result : [select Part__c part from CSD_Samsung_Mapping__c where PN_indicator__c = true group by Part__c ]) {
                set_SamsungpPNs.add((String)result.get('part'));
            }
            
            
            set<String> set_hascftpartid = new set<String>();
            map<String, Part__c> map_partid_part = new map<String, Part__c>();
            
            for(Part__c part : [select Id, Name, Description__c from Part__c 
                                where (Description__c like :searchDescOrNumber or name like :searchDescOrNumber )
                                And Id not IN :set_SamsungpPNs
                                limit 100]) {
                if(!searchOb.set_selectedId.contains(part.Id)){
                    map_partid_part.put(String.valueOf(part.Id).substring(0,15), part);
                }
            }
            map<String, CSD_ClsEntityType.PartObj> map_part_result = new map<String, CSD_ClsEntityType.PartObj>();
            if(map_partid_part.size() > 0) {
                CSD_ClsUtils.hasCFTForecast(searchOb.accnumber, searchOb.oemId, map_partid_part.keySet(), fiscaldate, enddate, set_hascftpartid);
                
                map<String, String> map_part_region = CSD_ClsUtils.getPartRegion(searchOb.accnumber, searchOb.oemId, map_partid_part.keySet());
                
                for(Part__c part : map_partid_part.values()) {
                    CSD_ClsEntityType.PartObj partObj = new CSD_ClsEntityType.PartObj();
                    CSD_ClsUtils.createPartObj(partObj, searchOb.map_year_monthsFuture);
                    
                    partObj.id = part.Id;
                    partObj.name = part.Name;
                    partObj.snumber = part.Description__c;
                    partObj.region = map_part_region.containsKey(String.valueOf(part.Id).substring(0,15)) ? map_part_region.get(String.valueOf(part.Id).substring(0,15)) : '';
                    partObj.hasCFTFC = false;
                    if(set_hascftpartid.contains(part.Id)) {
                        partObj.hasCFTFC = true;
                    }
                    
                    map_part_result.put(partObj.id, partObj);
                    //list_parts.add(partObj);
                }
                system.debug('@#map_part_result: '+map_part_result);
                set<String> set_partids = map_part_result.keySet();
                list_sql.clear();
                list_sql.add('Part__c part, Fiscal_Year__c year, Fiscal_Month__c month, '
                    + ' sum(Quantity__c) quantity, sum(Forecast__c) sumFC, sum(Price__c) price,'
                    + ' sum(DC_Forecast_Amount__c) sumDCFC, sum(Previous_Month_Forecast__c) sumPMFC');
                list_sql.add(' CSD_Sales_Forecast__c ');
                list_sql.add(' WHERE Sold_To_Number__c = \''+ searchOb.accnumber +'\' ' 
                        + ' And OEM__c = \''+ searchOb.oemId +'\' '
                        + ' And Part__c IN :set_partids'
                        + ' And Type__c = \'Part\''
                        + ' And Fiscal_Date__c >= : fiscaldate '
                        + ' And Fiscal_Date__c < : enddate '
                        + ' Group by Part__c, Fiscal_Year__c, Fiscal_Month__c  ');
                for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                    //system.debug('@#result : '+result);
                    String accId = (String)result.get('part'), 
                           year = (String)result.get('year'),
                           month = (String)result.get('month'), 
                           dateKey = (year + '_' + month);
    
                    if(!map_part_result.containsKey(accId)) {
                        continue;
                    }else {
    
                        CSD_ClsEntityType.AccountValueobj valueobj = new CSD_ClsEntityType.AccountValueobj();
                            
                        valueobj.forecast = (decimal)result.get('sumFC');
                        valueobj.price = (decimal)result.get('price');
                        valueobj.quantity = (decimal)result.get('quantity');
                        
                        map_part_result.get(accId).csFC.put(dateKey, valueobj);
                        map_part_result.get(accId).dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
                        map_part_result.get(accId).pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
                        
                    }
                }
            }
            
            return JSON.serialize(map_part_result.values());
        }
        
        
        public override String getExistResult(String sData){
            CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData, CSD_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb'+searchOb);
            
            Date currentdate = Date.valueOf(searchOb.startDate);
            Date enddate = Date.valueOf(searchOb.endDate);
            
            list<String> list_sql = new list<String>();
            
            list_sql.add(' Part__c , Part__r.Name , Part__r.Description__c , Fiscal_Year__c , Fiscal_Month__c , '
                    + ' Quantity__c, Forecast__c, Price__c,'
                    + ' DC_Forecast_Amount__c , Previous_Month_Forecast__c ');
                    
            list_sql.add(' CSD_Sales_Forecast__c ');
            list_sql.add(' WHERE Sold_To_Number__c = \''+ searchOb.accnumber +'\' ' 
                    + ' And OEM__c = \''+ searchOb.oemId +'\' '
                    + ' And Type__c = \'Part\''
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate ' );
                    //+ ' Group by Part__c, Part__r.Name, Part__r.Description__c, Fiscal_Year__c, Fiscal_Month__c  ');
            
            map<String, CSD_ClsEntityType.PartObj> map_acctId_acctFC = new map<String, CSD_ClsEntityType.PartObj>();
        
            map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result =
                new map<String, map<String, AggregateResult>>();
            
            set<String> set_partid = new set<String>();
            set<String> set_hascftpartid = new set<String>();
            
            for(CSD_Sales_Forecast__c result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                String dateKey = (result.Fiscal_Year__c + '_' + result.Fiscal_Month__c);
                set_partid.add(((String)result.Part__c).substring(0,15));
                CSD_ClsEntityType.PartObj acctFC = new CSD_ClsEntityType.PartObj();
    
                if(!map_acctId_acctFC.containsKey(result.Part__c)) {
                    CSD_ClsUtils.createPartObj(acctFC, searchOb.map_year_monthsFuture);
                    
                    acctFC.id = result.Part__c;
                    acctFC.name = result.Part__r.Name + (result.Part__r.Description__c == null ? '' : ' - '+result.Part__r.Description__c);
                    acctFC.snumber = result.Part__r.Description__c != null ? result.Part__r.Description__c : '';
    
                    map_acctId_acctFC.put(result.Part__c, acctFC);
                }else {
                    acctFC = map_acctId_acctFC.get(result.Part__c);
                }
                
                CSD_ClsEntityType.AccountValueobj valueobj = new CSD_ClsEntityType.AccountValueobj();
                
                valueobj.forecast = result.Forecast__c != null ? result.Forecast__c : 0;
                valueobj.price = result.Price__c != null ? result.Price__c : 0;
                valueobj.quantity = result.Quantity__c != null ? result.Quantity__c : 0;
                
                acctFC.csFC.put(dateKey, valueobj);
                acctFC.dcFC.put(dateKey, (result.DC_Forecast_Amount__c != null ? result.DC_Forecast_Amount__c : 0));
                acctFC.pmFC.put(dateKey, (result.Previous_Month_Forecast__c != null ? result.Previous_Month_Forecast__c : 0));
                
                map_acctId_acctFC.put(result.Part__c, acctFC);  

            }
            
            
            
            /*for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                //system.debug('@#result : '+result);
                String accId = (String)result.get('part'), 
                       year = (String)result.get('year'),
                       month = (String)result.get('month'), 
                       dateKey = (year + '_' + month);
                set_partid.add(accId.substring(0,15));
                CSD_ClsUtils.setResultMap(result, accId, dateKey, map_acctId_map_dateKey_result);       
                
            }*/
            
            CSD_ClsUtils.hasCFTForecast(searchOb.accnumber, searchOb.oemId, set_partid, currentdate, enddate, set_hascftpartid);
            map<String, String> map_part_region = CSD_ClsUtils.getPartRegion(searchOb.accnumber, searchOb.oemId, set_partid);
            
            for(String acctId : map_acctId_acctFC.keySet()) {
                CSD_ClsEntityType.PartObj acctFC = map_acctId_acctFC.get(acctId);
                acctFC.hasCFTFC = false;
                acctFC.region = map_part_region.containsKey(acctId.substring(0,15)) ? map_part_region.get(acctId.substring(0,15)) : '';
                if(set_hascftpartid.contains(acctId)) {
                    acctFC.hasCFTFC = true;
                }
            }
            
            /*
            for(String acctId : map_acctId_map_dateKey_result.keySet()) {
                CSD_ClsEntityType.PartObj acctFC = new CSD_ClsEntityType.PartObj();
                acctFC.id = acctId;
                acctFC.csFC = new map<String, CSD_ClsEntityType.AccountValueobj>();
                acctFC.dcFC = new map<String, decimal>();
                acctFC.pmFC = new map<String, decimal>();
                acctFC.hasCFTFC = false;
                acctFC.region = map_part_region.containsKey(acctId.substring(0,15)) ? map_part_region.get(acctId.substring(0,15)) : '';
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
                            map_acctId_acctFC.get(acctId).snumber = (result.get('descr') == null ? '' : (String)result.get('descr'));
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
            }*/
            
            list<CSD_ClsEntityType.PartObj> list_accFC = new list<CSD_ClsEntityType.PartObj>();
            list_accFC.addAll(map_acctId_acctFC.values());
            list_accFC.sort();
            return Json.serialize(list_accFC);

        }
        
        /**
         *  This method is used for Part searching which is called ??TOP Sales??, which automatically displayed the top 5 parts 
         *   that have the best billing history in the past 6 months. The founded parts should also be limited to the current 
         *   sold to and OEM account.
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
        private String getTopSalesParts(String sData){
            
            list<CSD_ClsEntityType.PartObj> list_parts = new list<CSD_ClsEntityType.PartObj>();
            CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
            
            list<String> list_sql = new list<String>();
            Date fiscaldate = Date.valueOf(searchOb.startDate);
            Date enddate = Date.valueOf(searchOb.endDate);
            //Date fiscaldate = CSD_ClsUtils.getFiscalDate();
            //Date enddate = fiscaldate.addMonths(13);
            if(searchOb.set_selectedId == null){
                searchOb.set_selectedId = new set<string>();
            }
            if(searchOb.set_deletedId == null){
                searchOb.set_deletedId = new set<string>();
            }
            set<String> set_selectpartids = new set<String>();
            set_selectpartids.addAll(searchOb.set_selectedId);
            list_sql.add(' Part__c part ');
            list_sql.add(' CSD_Sales_Forecast__c ');
            list_sql.add(' WHERE Type__c = \'Part\' '
                    + ' And Sold_To_Number__c = \''+ searchOb.accnumber +'\' ' 
                    + ' AND OEM__c = \''+ searchOb.oemId +'\' '
                    + ' And Fiscal_Date__c >= : fiscaldate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Part__c ');
            
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                if(!set_selectpartids.contains((String)result.get('part')) && !searchOb.set_deletedId.contains((String)result.get('part'))) {
                    set_selectpartids.add((String)result.get('part'));
                }
            }
            
            list_sql.clear();
            Date earliestDate = CSD_ClsUtils.getFiscalDate().addMonths(-6).addDays(-15);
            set<String> set_SamsungpPNs = new set<String>();
            for(AggregateResult result : [select Part__c part from CSD_Samsung_Mapping__c where PN_indicator__c = true group by Part__c ]) {
                set_SamsungpPNs.add((String)result.get('part'));
            }
            list_sql.add(' Monthly_Billings_Bookings_by_Part__r.Part__c PartId, Monthly_Billings_Bookings_by_Part__r.Part__r.Name partName, '
                        + ' Monthly_Billings_Bookings_by_Part__r.Part__r.Description__c descr, '
                        + ' sum(Monthly_Billings_Bookings_by_Part__r.Bill_Amount_USD__c) bill ');
            list_sql.add('CSD_OEM_Mapping_Monthly_BBB__c ');
            list_sql.add(' where Monthly_Billings_Bookings_by_Part__r.Customer__r.AccountNumber = '+ '\'' +searchOb.accnumber+'\'' 
                    + ' and Monthly_Billings_Bookings_by_Part__r.Customer__r.STATDESC__c = \'Active\' ' 
                    + ' and OEM_Mapping__r.OEM__r.OEM__c = ' + '\'' +searchOb.oemId+'\' ' 
                    + ' and Monthly_Billings_Bookings_by_Part__r.Part__c not IN : set_selectpartids '
                    + ' and Monthly_Billings_Bookings_by_Part__r.Part__c not IN : set_SamsungpPNs '
                    + ' and Monthly_Billings_Bookings_by_Part__r.Fiscal_Date__c >= :earliestDate '
                    
                    + ' group by Monthly_Billings_Bookings_by_Part__r.Part__c, Monthly_Billings_Bookings_by_Part__r.Part__r.Name, Monthly_Billings_Bookings_by_Part__r.Part__r.Description__c order by sum(Monthly_Billings_Bookings_by_Part__r.Bill_Amount_USD__c) desc limit 5 ');
            //system.debug('@#list_sql: '+list_sql);
            
            
            set<String> set_hascftpartid = new set<String>();
            map<String, AggregateResult> map_partid_part = new map<String, AggregateResult>();
            
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) { 
                map_partid_part.put((String)result.get('PartId'), result); 
            }
            
            if(map_partid_part.size() > 0) {
                CSD_ClsUtils.hasCFTForecast(searchOb.accnumber, searchOb.oemId, map_partid_part.keySet(), fiscaldate, enddate, set_hascftpartid);
                map<String, String> map_part_region = CSD_ClsUtils.getPartRegion(searchOb.accnumber, searchOb.oemId, map_partid_part.keySet());
                
                for(AggregateResult result : map_partid_part.values()) {
                    CSD_ClsEntityType.PartObj partObj = new CSD_ClsEntityType.PartObj();
                    CSD_ClsUtils.createPartObj(partObj, searchOb.map_year_monthsFuture);
                    partObj.id = (String)result.get('PartId');
                    partObj.name = (String)result.get('partName');
                    partObj.snumber = (String)result.get('descr');
                    //partObj.accnumber = String.valueOf(result.get('bill'));
                    partObj.region = map_part_region.containsKey(partObj.id.substring(0,15)) ? map_part_region.get(partObj.id.substring(0,15)) : '';
                    partObj.hasCFTFC = false;
                    if(set_hascftpartid.contains(partObj.id)) {
                        partObj.hasCFTFC = true;
                    }
                    list_parts.add(partObj);
                }
            }
            
            system.debug('@#list_parts: '+list_parts);
            return JSON.serialize(list_parts);
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
        system.debug('asdfsData4'+sData);
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
                        list_futruesql.add(' Customer__r.AccountNumber refId, sum(Backlog_Amount_USD__c) amount');
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
                CSD_ClsUtils.setTerritoryAccountSetByUserId(set_acctIds, CSD_ClsUtils.getManageUserId(searchOb.managerId));
                
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