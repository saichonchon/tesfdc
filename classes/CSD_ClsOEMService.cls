/**
 *  This class is CSD OEM seriver.
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
   @changelog
 * 2016-04-08 Mingxing <Qiumingxing.qiu@oinio.com>
 * - Created
 */
public without sharing class CSD_ClsOEMService extends CSD_Interface.ACSDCtrlService {

    
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public override void setPopUPBoxColumnLevel1(list<Object> list_column){
        CSD_ClsEntityType.CSDColumn column1 = new CSD_ClsEntityType.CSDColumn();
        column1.name = 'Name';
        column1.fieldname = 'name';
        CSD_ClsEntityType.CSDColumn column2 = new CSD_ClsEntityType.CSDColumn();
        column2.name = 'Description';
        column2.fieldname = 'snumber';
        CSD_ClsEntityType.CSDColumn gplcolumn = new CSD_ClsEntityType.CSDColumn();
        gplcolumn.name = 'GPL Code';
        gplcolumn.fieldname = 'gplcode';
        CSD_ClsEntityType.CSDColumn gpldescolumn = new CSD_ClsEntityType.CSDColumn();
        gpldescolumn.name = 'GPL Description';
        gpldescolumn.fieldname = 'accnumber';
        list_column.add(column1);
        list_column.add(column2);
        list_column.add(gplcolumn);
        list_column.add(gpldescolumn);
    }
    
    public override void setPopUPBoxColumnLevel2(list<Object> list_column){
        CSD_ClsEntityType.CSDColumn column1 = new CSD_ClsEntityType.CSDColumn();
        column1.name = 'Name';
        column1.fieldname = 'name';
        CSD_ClsEntityType.CSDColumn column2 = new CSD_ClsEntityType.CSDColumn();
        column2.name = 'Number';
        column2.fieldname = 'snumber';
        list_column.add(column2);
        list_column.add(column1);
        
    }
    
    public override void setPopUPBoxColumnLevel3(list<Object> list_column){
        CSD_ClsEntityType.CSDColumn column1 = new CSD_ClsEntityType.CSDColumn();
        column1.name = 'Name';
        column1.fieldname = 'name';
        CSD_ClsEntityType.CSDColumn column2 = new CSD_ClsEntityType.CSDColumn();
        column2.name = 'Number';
        column2.fieldname = 'snumber';
        list_column.add(column2);
        list_column.add(column1);
        
    }

    
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
        
        Date currentdate = Date.valueOf(pageconf.refStartDate);
        Date enddate = Date.valueOf(pageconf.refEndDate);

        set<String> set_GPLFamilys = new set<String>();
        set<String> set_GPLCodes = new set<String>();
        set<String> set_SoldTos = new set<String>();
        set<String> set_Parts = new set<String>();
        system.debug('@#managerId:'+CSD_ClsUtils.getManageUserId(pageconf.managerId));
        CSD_ClsUtils.getSamsungGPLFamilyByUser(CSD_ClsUtils.getManageUserId(pageconf.managerId), '', '', set_GPLFamilys, set_GPLCodes, set_SoldTos, set_Parts);
        
        map<String, CSD_ClsEntityType.AccountObj> map_acctId_acctFC = new map<String, CSD_ClsEntityType.AccountObj>();
        
        for(String gplfamily : set_GPLFamilys) {
            CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
            
            CSD_ClsUtils.createAccountObj(acctFC, pageconf.map_financialMonth);
            Blob aes = Crypto.generateAesKey(128);
            String hex = EncodingUtil.convertToHex(aes);
            acctFC.id = hex;
            acctFC.name = gplfamily;

            map_acctId_acctFC.put(gplfamily, acctFC);
            
        }
        
        list<String> list_sql = new list<String>();
        
        list_sql.add(' GPL_Family__c gplfamily, Fiscal_Year__c year, Fiscal_Month__c month, '
                + 'sum(DC_Forecast_Amount__c) sumDCFC, sum(Forecast__c) sumFC, sum(Previous_Month_Forecast__c) sumPMFC');
        list_sql.add(' CSD_Sales_Forecast__c ');
        list_sql.add(' WHERE OEM__c = \'' + pageconf.samsungId + '\' ' 
                    + ' And GPL_Family__c IN :set_GPLFamilys '
                    + ' And (Sold_To_Number__c IN :set_SoldTos or Sold_To_Number__c = null) '
                    + ' And Part__c IN :set_Parts '
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' And Type__c = \'Sold-To\' '
                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, GPL_Family__c ');
        
        system.debug('@#list_sql:'+list_sql);
        system.debug('@#set_SoldTos:'+set_SoldTos);
        system.debug('@#set_Parts:'+set_Parts);
        
        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
            //system.debug('@#result : '+result);
            String accId = (String)result.get('gplfamily'), 
                   year = (String) result.get('year'),
                   month = (String) result.get('month'), 
                   dateKey = (year + '_' + month);
            
            CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
            
            if(!map_acctId_acctFC.containsKey(accId)) {
                CSD_ClsUtils.createAccountObj(acctFC, pageconf.map_financialMonth);
                
                acctFC.id = accId;
                acctFC.name = accId;
 
                map_acctId_acctFC.put(accId, acctFC);
            }else {
                acctFC = map_acctId_acctFC.get(accId);
            }
            acctFC.csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
            acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
            acctFC.pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
            //acctFC.restPNFC.put(dateKey, (result.get('restPNFC') != null ? (decimal)result.get('restPNFC') : 0));
            map_acctId_acctFC.put(accId, acctFC);    
                   
        }
        
        list<CSD_ClsEntityType.AccountObj> list_accFc = new list<CSD_ClsEntityType.AccountObj>();
        list_accFc.addAll(map_acctId_acctFC.values());
        list_accFc.sort();
        for(Integer i = list_accFc.size()-1; i >= 0; i--) {
            list_data.add(list_accFc.get(i));
        }
        system.debug('@#list_data:'+list_data);
    }
    
    
    
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
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                CSD_ClsUtils.setRefDatelist(list_beforedate, list_futruedate, searchOb.set_fiscalMonth);
                
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();
                
                set<String> set_GPLFamilys = new set<String>();
                set<String> set_GPLCodes = new set<String>();
                set<String> set_SoldTos = new set<String>();
                set<String> set_Parts = new set<String>();
                CSD_ClsUtils.getSamsungGPLFamilyByUser(CSD_ClsUtils.getManageUserId(searchOb.managerId), searchOb.gplfamily, '', set_GPLFamilys, set_GPLCodes, set_SoldTos, set_Parts);
                
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
                                                                        and Monthly_Billings_Bookings_by_Part__r.Customer__r.AccountNumber IN :set_SoldTos
                                                                        and Monthly_Billings_Bookings_by_Part__r.Customer__r.STATDESC__c = 'Active'
                                                                        and Monthly_Billings_Bookings_by_Part__r.Part__c IN :set_Parts
                                                                        and OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
                        set_monthIds.add(csdmap.Monthly_Billings_Bookings_by_Part__c);
                    }
                    
                    
                    list<String> list_beforesql = new list<String>();
                    list_beforesql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                    list_beforesql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_beforesql.add(' WHERE Id IN :set_monthids '
                            + ' Group by Fiscal_Date__c ');
                    CSD_ClsUtils.setGAMOEMMapRefData(searchOb.gplfamily, set_monthIds, list_beforesql, map_acctId_map_dateKey_result_before);
                }
                
                CSD_ClsEntityType.CSDRefObj refdata = CSD_ClsUtils.createRefDataObj();
                refdata.id = searchOb.gplfamily;
                
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
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                CSD_ClsUtils.setRefDatelist(list_beforedate, list_futruedate, searchOb.set_fiscalMonth);
                
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();
                
                set<String> set_GPLFamilys = new set<String>();
                set<String> set_GPLCodes = new set<String>();
                set<String> set_SoldTos = new set<String>();
                set<String> set_Parts = new set<String>();
                CSD_ClsUtils.getSamsungGPLFamilyByUser(CSD_ClsUtils.getManageUserId(searchOb.managerId), searchOb.gplfamily, '', set_GPLFamilys, set_GPLCodes, set_SoldTos, set_Parts);

                
                if(list_futruedate.size() > 0) {
                    //futrue
                    //old  Updata the  Mingxing Qiu time is  2016-04-08 
                   /* set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    CSD_ClsUtils.setRefForecastDate(years, months, list_futruedate);

                    set<String> set_dailyIds = new set<String>();
                    for(CSD_OEM_Mapping_Daily_BBB__c csdmap : [select Daily_Booking_Billing_Backlog_By_Part__c 
                                                                    from CSD_OEM_Mapping_Daily_BBB__c 
                                                                    where Daily_Booking_Billing_Backlog_By_Part__r.Fiscal_Year__c IN :years
                                                                        and Daily_Booking_Billing_Backlog_By_Part__r.Fiscal_Month__c IN :months
                                                                        and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.AccountNumber IN :set_SoldTos
                                                                        and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.STATDESC__c = 'Active'
                                                                        and Daily_Booking_Billing_Backlog_By_Part__r.Part__c IN :set_Parts
                                                                        and CSD_OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
                        set_dailyIds.add(csdmap.Daily_Booking_Billing_Backlog_By_Part__c);
                    }

                    list<String> list_futruesql = new list<String>();
                    list_futruesql.add(' sum(Backlog_Amount_USD__c) amount, Fiscal_Date__c refdate');
                    list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c    ');
                    list_futruesql.add(' WHERE Id IN :set_monthids '
                        + ' Group by Fiscal_Date__c ');      
                       
                    CSD_ClsUtils.setGAMOEMMapRefData(searchOb.gplfamily, set_dailyIds, list_futruesql, map_acctId_map_dateKey_result_futrue);
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
                                                                            and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.AccountNumber IN :set_SoldTos
                                                                            and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.STATDESC__c = 'Active'
                                                                            and Daily_Booking_Billing_Backlog_By_Part__r.Part__c IN :set_Parts
                                                                            and CSD_OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
                            set_dailyIds.add(csdmap.Daily_Booking_Billing_Backlog_By_Part__c);
                        }

                        list<String> list_futruesql = new list<String>();
                        list_futruesql.add(' sum(Backlog_Amount_USD__c) amount ');
                        list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c    ');
                        list_futruesql.add(' WHERE Id IN :set_monthids ');

                        CSD_ClsUtils.setGAMOEMMapRefDataBacklog(currentdate, searchOb.gplfamily, set_dailyIds, list_futruesql, map_acctId_map_dateKey_result_futrue);
                    
                    }
                
                }

                CSD_ClsEntityType.CSDRefObj refdata = CSD_ClsUtils.createRefDataObj();
                refdata.id = searchOb.gplfamily;
                
                CSD_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata,
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
        } 
        
        
    }
    
    public class SearchLevel2 extends CSD_Interface.ACSDRemoteService{
        
                
        public override String deleteCSDObject(String sData) { 
            try {
                CSD_ClsEntityType.SearchObj valueobj = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
                
                system.debug('@#valueobj123:'+valueobj);
                set<String> set_GPLFamilys = new set<String>();
                set<String> set_GPLCodes = new set<String>();
                set<String> set_SoldTos = new set<String>();
                set<String> set_Parts = new set<String>();
                
                CSD_ClsUtils.getSamsungGPLFamilyByUser(CSD_ClsUtils.getManageUserId(valueobj.managerId), valueobj.gplfamily, valueobj.gplcode, 
                                                        set_GPLFamilys, set_GPLCodes, set_SoldTos, set_Parts);
                
                list<CSD_Sales_Forecast__c> lsit_forecast = new list<CSD_Sales_Forecast__c>();
                //map<String, CSD_Sales_Forecast__c> map_date_forecast = new map<String, CSD_Sales_Forecast__c>();
                for(CSD_Sales_Forecast__c fc : [select Id 
                                                From CSD_Sales_Forecast__c 
                                                where GPL_Family__c = :valueobj.gplfamily and GPL_Code__c = :valueobj.gplcode
                                                 and Part__c IN :set_Parts and (Sold_To_Number__c = null or Sold_To_Number__c IN :set_SoldTos)
                                                 and OEM__c = :valueobj.oemId and Type__c = 'Sold-To' 
                                                 and (Samsung_Type__c = null or Samsung_Type__c = 'Non SoldTo')  ]) {
                     
                     lsit_forecast.add(fc);
                }
                system.debug('@#lsit_forecast:'+lsit_forecast);
                if(lsit_forecast.size() > 0){
                    delete lsit_forecast;
                }

                return 'true'; 
            }catch(Exception ex) {
                throw ex;
            }
        }
        
        
        /**
         *  This function is get value of level2 by level1
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
            
            set<String> set_GPLFamilys = new set<String>();
            set<String> set_GPLCodes = new set<String>();
            set<String> set_SoldTos = new set<String>();
            set<String> set_Parts = new set<String>();
            
            CSD_ClsUtils.getSamsungGPLFamilyByUser(CSD_ClsUtils.getManageUserId(searchOb.managerId), searchOb.gplfamily, '', set_GPLFamilys, set_GPLCodes, set_SoldTos, set_Parts);
            
            
            if(searchOb.viewMode != null && searchOb.viewMode == 'view' ) {
                if(searchOb.isOtherMethod != null && searchOb.isOtherMethod) {
                    return getExistResultBySoldToView(sData, set_Parts, set_SoldTos);
                }else {
                    return getExistResultByGPLCodeView(sData, set_Parts, set_SoldTos);
                }
            }
            
            /*  
            if(searchOb.isOtherMethod != null && searchOb.isOtherMethod) {
                return getOtherExistResult(sData);
            }
            
            if(searchOb.viewMode != null && searchOb.viewMode == 'view') {
                return getExistResultView(sData);
            }*/

            
                
            Date currentdate = Date.valueOf(searchOb.startDate);
            Date enddate = Date.valueOf(searchOb.endDate);
            
            list<String> list_sql = new list<String>();
            
            list_sql.add(' GPL_Code__c gplcode, Fiscal_Year__c year, Fiscal_Month__c month, Part__r.Product_Hierarchy__r.GPL_Description__c gpldescr, '
                        + ' max(Quantity__c) quantity, sum(Forecast__c) sumFC, max(Price__c) price, '
                        + ' sum(DC_Forecast_Amount__c) sumDCFC, sum(Previous_Month_Forecast__c) sumPMFC ');
            list_sql.add(' CSD_Sales_Forecast__c ');
            list_sql.add(' WHERE OEM__c = \'' + searchOb.oemId + '\' ' 
                    + ' And Part__c IN :set_Parts '
                    + ' And Sold_To_Number__c IN :set_SoldTos '
                    + ' And Type__c = \'Sold-To\' '
                    + ' And (Samsung_Type__c = null or Samsung_Type__c = \'Non SoldTo\') '
                    + ' And GPL_Family__c = \'' + searchOb.gplfamily + '\''
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, GPL_Code__c, Part__r.Product_Hierarchy__r.GPL_Description__c ');
            
            map<String, CSD_ClsEntityType.AccountObj> map_acctId_acctFC = new map<String, CSD_ClsEntityType.AccountObj>();
            
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                //system.debug('@#result : '+result);
                String accId = (String)result.get('gplcode'), 
                       year = (String)result.get('year'),
                       month = (String)result.get('month'), 
                       dateKey = (year + '_' + month);
                system.debug('@#result'+result);
                CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
    
                if(!map_acctId_acctFC.containsKey(accId)) {
                    CSD_ClsUtils.createAccountObj(acctFC, searchOb.map_year_monthsFuture);
                    Blob aes = Crypto.generateAesKey(128);
                    String hex = EncodingUtil.convertToHex(aes);
                    acctFC.id = hex;
                    acctFC.name = (String)result.get('gplcode');
                    acctFC.accnumber = (result.get('gpldescr') == null ? '' :(String)result.get('gpldescr'));
                    acctFC.type = 'GPLCode';
                    map_acctId_acctFC.put(accId, acctFC);
                }else {
                    acctFC = map_acctId_acctFC.get(accId);
                }
                
                acctFC.csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
                acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
                acctFC.pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
 
            }
            
            list<CSD_ClsEntityType.AccountObj> list_codesoldtos = new list<CSD_ClsEntityType.AccountObj>();
            list_codesoldtos.addAll(map_acctId_acctFC.values());
            list_codesoldtos.sort();
            
            
            list_sql.clear();
            map_acctId_acctFC.clear();
            
            list_sql.add(' Sold_To_Number__c soldto, Sold_To_Name__c name, Fiscal_Year__c year, Fiscal_Month__c month, '
                        + ' max(Quantity__c) quantity, sum(Forecast__c) sumFC, max(Price__c) price, '
                        + ' sum(DC_Forecast_Amount__c) sumDCFC, sum(Previous_Month_Forecast__c) sumPMFC ');
            list_sql.add(' CSD_Sales_Forecast__c ');
            list_sql.add(' WHERE OEM__c = \'' + searchOb.oemId + '\' ' 
                    + ' And Part__c IN :set_Parts '
                    + ' And Type__c = \'Sold-To\' '
                    + ' And Sold_To_Number__c IN :set_SoldTos '
                    + ' And Samsung_Type__c = \'Non Part\' '
                    + ' And GPL_Family__c = \'' + searchOb.gplfamily + '\''
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, Sold_To_Number__c, Sold_To_Name__c ');

            
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                //system.debug('@#result : '+result);
                String accId = (String)result.get('soldto'), 
                       year = (String)result.get('year'),
                       month = (String)result.get('month'), 
                       dateKey = (year + '_' + month);
                system.debug('@#result'+result);
                CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
    
                if(!map_acctId_acctFC.containsKey(accId)) {
                    CSD_ClsUtils.createAccountObj(acctFC, searchOb.map_year_monthsFuture);
                    Blob aes = Crypto.generateAesKey(128);
                    String hex = EncodingUtil.convertToHex(aes);
                    acctFC.id = hex;
                    acctFC.accnumber = accId;
                    acctFC.name = (String)result.get('name');
                    //acctFC.gplcode = (String)result.get('gplcode');
                    acctFC.type = 'NonPart';
                    map_acctId_acctFC.put(accId, acctFC);
                }else {
                    acctFC = map_acctId_acctFC.get(accId);
                }
                
                acctFC.csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
                acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
                acctFC.pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
 
            }
            
            list<CSD_ClsEntityType.AccountObj> list_soldtos = new list<CSD_ClsEntityType.AccountObj>();
            list_soldtos.addAll(map_acctId_acctFC.values());
            list_soldtos.sort();
            
            list_codesoldtos.addAll(list_soldtos);

            return Json.serialize(list_codesoldtos);
        }
        
        
        /**
         *  This function is get value of level2 by level1
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
        public String getExistResultByGPLCodeView(String sData, set<String> set_Parts, set<String> set_SoldTos){
            
            CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData, CSD_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb'+searchOb);
            
            Date currentdate = Date.valueOf(searchOb.startDate);
            Date enddate = Date.valueOf(searchOb.endDate);

            list<String> list_sql = new list<String>();
            
            list_sql.add(' GPL_Code__c gplcode, Fiscal_Year__c year, Fiscal_Month__c month, '
                        + ' max(Quantity__c) quantity, sum(Forecast__c) sumFC, max(Price__c) price, '
                        + ' sum(DC_Forecast_Amount__c) sumDCFC, sum(Previous_Month_Forecast__c) sumPMFC ');
            list_sql.add(' CSD_Sales_Forecast__c ');
            list_sql.add(' WHERE OEM__c = \'' + searchOb.oemId + '\' ' 
                    + ' And Part__c IN :set_Parts '
                    + ' And (Sold_To_Number__c IN :set_SoldTos or Sold_To_Number__c = null)'
                    + ' And Type__c = \'Sold-To\' '
                    + ' And GPL_Family__c = \'' + searchOb.gplfamily + '\''
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, GPL_Code__c  ');
            
            map<String, CSD_ClsEntityType.AccountObj> map_acctId_acctFC = new map<String, CSD_ClsEntityType.AccountObj>();
            
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                //system.debug('@#result : '+result);
                String accId = (String)result.get('gplcode'), 
                       year = (String)result.get('year'),
                       month = (String)result.get('month'), 
                       dateKey = (year + '_' + month);
                system.debug('@#result'+result);
                CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
    
                if(!map_acctId_acctFC.containsKey(accId)) {
                    CSD_ClsUtils.createAccountObj(acctFC, searchOb.map_year_monthsFuture);
                    Blob aes = Crypto.generateAesKey(128);
                    String hex = EncodingUtil.convertToHex(aes);
                    acctFC.id = hex;
                    acctFC.accnumber = accId;
                    acctFC.name = accId;
                    //acctFC.gplcode = (String)result.get('gplcode');
                    acctFC.type = 'GPLCode';
                    map_acctId_acctFC.put(accId, acctFC);
                }else {
                    acctFC = map_acctId_acctFC.get(accId);
                }
                
                acctFC.csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
                acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
                acctFC.pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
 
            }
            
            list<CSD_ClsEntityType.AccountObj> list_codesoldtos = new list<CSD_ClsEntityType.AccountObj>();
            list_codesoldtos.addAll(map_acctId_acctFC.values());
            list_codesoldtos.sort();

            return Json.serialize(list_codesoldtos);
        }
        
        
        /**
         *  This function is get value of level2 by level1
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
        public String getExistResultBySoldToView(String sData, set<String> set_Parts, set<String> set_SoldTos){
            CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData, CSD_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb'+searchOb);
            
            Date currentdate = Date.valueOf(searchOb.startDate);
            Date enddate = Date.valueOf(searchOb.endDate);

            list<String> list_sql = new list<String>();
            
            list_sql.add(' Sold_To_Number__c soldto, Sold_To_Name__c name, Fiscal_Year__c year, Fiscal_Month__c month, '
                        + ' max(Quantity__c) quantity, sum(Forecast__c) sumFC, max(Price__c) price, '
                        + ' sum(DC_Forecast_Amount__c) sumDCFC, sum(Previous_Month_Forecast__c) sumPMFC ');
            list_sql.add(' CSD_Sales_Forecast__c ');
            list_sql.add(' WHERE OEM__c = \'' + searchOb.oemId + '\' ' 
                    + ' And Type__c = \'Sold-To\' '
                    + ' And Part__c IN :set_Parts '
                    + ' And Sold_To_Number__c IN :set_SoldTos '
                    + ' And GPL_Family__c = \'' + searchOb.gplfamily + '\' '
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, Sold_To_Number__c, Sold_To_Name__c ');
            
            map<String, CSD_ClsEntityType.AccountObj> map_acctId_acctFC = new map<String, CSD_ClsEntityType.AccountObj>();
        
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                //system.debug('@#result : '+result);
                String accId = (String)result.get('soldto'), 
                       year = (String)result.get('year'),
                       month = (String)result.get('month'), 
                       dateKey = (year + '_' + month);
                system.debug('@#result'+result);
                CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
    
                if(!map_acctId_acctFC.containsKey(accId)) {
                    CSD_ClsUtils.createAccountObj(acctFC, searchOb.map_year_monthsFuture);
                    Blob aes = Crypto.generateAesKey(128);
                    String hex = EncodingUtil.convertToHex(aes);
                    acctFC.id = hex;
                    acctFC.accnumber = accId;
                    acctFC.name = (String)result.get('name');
                    //acctFC.gplcode = (String)result.get('gplcode');
                    acctFC.type = 'GPLCode';
                    map_acctId_acctFC.put(accId, acctFC);
                }else {
                    acctFC = map_acctId_acctFC.get(accId);
                }
                
                acctFC.csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
                acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
                acctFC.pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
                
            }
            
            list<CSD_ClsEntityType.AccountObj> list_codesoldtos = new list<CSD_ClsEntityType.AccountObj>();
            list_codesoldtos.addAll(map_acctId_acctFC.values());
            list_codesoldtos.sort(); 
            
            return Json.serialize(list_codesoldtos);
        }
        
        
        /**
         *  This method is used for Part searching 
         *  
         * @author Lei Tang
         * @created 2014-11-18
         * @version 1.0
         * @since 30.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-11-18 Lei Tang <lei.tang@itbconsult.com>
         * - Created
         *
        */
        public override String getSearchResult(String sData){
            
            list<CSD_ClsEntityType.AccountObj> list_parts = new list<CSD_ClsEntityType.AccountObj>();
            CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);

            String searchDescOrNumber = '%' + (searchOb.searchKey != null ? searchOb.searchKey : '') + '%';
            
            set<String> set_GPLFamilys = new set<String>();
            set<String> set_GPLCodes = new set<String>();
            set<String> set_SoldTos = new set<String>();
            set<String> set_Parts = new set<String>();
            
            CSD_ClsUtils.getSamsungGPLFamilyByUser(CSD_ClsUtils.getManageUserId(searchOb.managerId), searchOb.gplfamily, searchOb.gplcode, 
                                                    set_GPLFamilys, set_GPLCodes, set_SoldTos, set_Parts);
            
            list<String> list_sql = new list<String>();
            set<String> set_selectedCode = new set<String>();
            if(searchOb.set_selectedId == null) {
                searchOb.set_selectedId = new set<string>();
            }
            if(searchOb.set_deletedId == null){
                searchOb.set_deletedId = new set<string>();
            }
            

            list_sql.add(' Part__c part , GPL_Code__c gplcode');
            list_sql.add(' CSD_Sales_Forecast__c ');
            list_sql.add(' WHERE Type__c = \'Sold-To\' '
                    + ' And (Samsung_Type__c = null or Samsung_Type__c = \'Non SoldTo\') '
                    + ' AND OEM__c = \'' + searchOb.oemId + '\' '
                    + ' And GPL_Family__c = \'' + searchOb.gplfamily + '\' '
                    + ' And Part__c IN :set_Parts '
                    + ' And Sold_To_Number__c IN :set_SoldTos '
                    + ' Group by Part__c, GPL_Code__c ');
            
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                if(!searchOb.set_selectedId.contains((String)result.get('gplcode')) && !searchOb.set_deletedId.contains((String)result.get('gplcode'))) {
                    searchOb.set_selectedId.add((String)result.get('gplcode'));
                }
            }
            
            system.debug('@#searchOb.set_selectedId : '+searchOb.set_selectedId);
            system.debug('@#searchOb.set_deletedId : '+searchOb.set_deletedId);
            
            set<String> set_selectedId = searchOb.set_selectedId;
            
            list_sql.clear();
            list_sql.add(' GPL_Code__c gplcode, Part__c part, Part__r.Name partname, Part__r.Description__c descr, Part__r.Product_Hierarchy__r.GPL_Description__c gpldescr');
            list_sql.add(' CSD_Samsung_Mapping__c ');
            String strwhere = ' where GPL_Family__c = \'' + searchOb.gplfamily + '\' '
                    + ' And Category__c IN :set_SoldTos ' 
                    + ' And Part__c IN :set_Parts '
                    + ' And GPL_Code__c not IN :set_selectedId '
                    + ' And (Part__r.Name like :searchDescOrNumber or Part__r.Description__c like :searchDescOrNumber or GPL_Code__c like :searchDescOrNumber or Part__r.Product_Hierarchy__r.GPL_Description__c like :searchDescOrNumber) ';

            strwhere += ' group by GPL_Code__c, Part__c, Part__r.Name, Part__r.Description__c, Part__r.Product_Hierarchy__r.GPL_Description__c order by Part__r.Name limit 100';

            list_sql.add(strwhere);
            map<String, CSD_ClsEntityType.AccountObj> map_part_result = new map<String, CSD_ClsEntityType.AccountObj>();
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                
                CSD_ClsEntityType.AccountObj partObj = new CSD_ClsEntityType.AccountObj();
                CSD_ClsUtils.createAccountObj(partObj, searchOb.map_year_monthsFuture);
                partObj.id = (String)result.get('part');
                partObj.name = (String)result.get('partname');
                partObj.snumber = (String)result.get('descr');
                partObj.gplcode = (String)result.get('gplcode');
                partObj.accnumber = (String)result.get('gpldescr');
                partObj.gplfamily = searchOb.gplfamily;
                map_part_result.put(partObj.id, partObj);
                //list_parts.add(partObj);
            }
            
            
            Date currentdate = Date.valueOf(searchOb.startDate);
            Date enddate = Date.valueOf(searchOb.endDate);
            
            set<String> set_partIds = map_part_result.keySet();
            list_sql.clear();
            list_sql.add('Part__c part, Fiscal_Year__c year, Fiscal_Month__c month, '
                        + ' max(Quantity__c) quantity, sum(Forecast__c) sumFC, max(Price__c) price, sum(Rest_SoldTo_Forecast__c) restSTFC, '
                        + ' sum(DC_Forecast_Amount__c) sumDCFC, sum(Previous_Month_Forecast__c) sumPMFC');
            list_sql.add(' CSD_Sales_Forecast__c ');
            list_sql.add(' WHERE OEM__c = \'' + searchOb.oemId + '\' ' 
                    + ' And Type__c = \'Sold-To\' And (Samsung_Type__c = null or Samsung_Type__c = \'Non SoldTo\') '
                    + ' And GPL_Family__c = \''+searchOb.gplfamily+'\''
                    + ' And Part__c IN :set_partIds '
                    + ' And Sold_To_Number__c IN :set_SoldTos '
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Part__c, Fiscal_Year__c, Fiscal_Month__c');
            
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                //system.debug('@#result : '+result);
                String accId = (String)result.get('part'), 
                       year = (String)result.get('year'),
                       month = (String)result.get('month'), 
                       dateKey = (year + '_' + month);

                if(!map_part_result.containsKey(accId)) {
                    continue;
                }else {
                    //CSD_ClsEntityType.AccountObj acctFC = map_part_result.get(accId);
                    
                    map_part_result.get(accId).restPNFC.put(dateKey, (result.get('restSTFC') != null ? (decimal)result.get('restSTFC') : 0));
                    map_part_result.get(accId).csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
                    map_part_result.get(accId).dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
                    map_part_result.get(accId).pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
                }
            }
            
            system.debug('@#map_part_result.values:' + map_part_result.values());
            return JSON.serialize(map_part_result.values());

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
                
                if(searchOb.isOtherMethod != null && searchOb.isOtherMethod) {
                    return getOtherRefData(sData);
                }

                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                CSD_ClsUtils.setRefDatelist(list_beforedate, list_futruedate, searchOb.set_fiscalMonth);
                
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();     
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();
                
                set<String> set_GPLFamilys = new set<String>();
                set<String> set_GPLCodes = new set<String>();
                set<String> set_SoldTos = new set<String>();
                set<String> set_Parts = new set<String>();
                CSD_ClsUtils.getSamsungGPLFamilyByUser(CSD_ClsUtils.getManageUserId(searchOb.managerId), searchOb.gplfamily, searchOb.gplcode, 
                                                        set_GPLFamilys, set_GPLCodes, set_SoldTos, set_Parts);
               

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
                                                                    and Monthly_Billings_Bookings_by_Part__r.Customer__r.AccountNumber IN :set_SoldTos
                                                                    and Monthly_Billings_Bookings_by_Part__r.Customer__r.STATDESC__c = 'Active'
                                                                    and Monthly_Billings_Bookings_by_Part__r.Part__c IN :set_Parts
                                                                    and OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
                        set_monthIds.add(csdmap.Monthly_Billings_Bookings_by_Part__c);
                    }

                    list<String> list_beforesql = new list<String>();
                    list_beforesql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                    list_beforesql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_beforesql.add(' WHERE Id IN :set_monthids '
                            + ' Group by Fiscal_Date__c ');
                    CSD_ClsUtils.setGAMOEMMapRefData(searchOb.gplcode, set_monthIds, list_beforesql, map_acctId_map_dateKey_result_before);
                }
                
                CSD_ClsEntityType.CSDRefObj refdata = CSD_ClsUtils.createRefDataObj();
                refdata.id = searchOb.gplcode;
                
                CSD_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
        }
        
        
        /**
         *  This function is used get other reference data list.
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
        public String getOtherRefData(String sData) { 
            try {
                CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
                
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                CSD_ClsUtils.setRefDatelist(list_beforedate, list_futruedate, searchOb.set_fiscalMonth);

                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();
                
                set<String> set_GPLFamilys = new set<String>();
                set<String> set_GPLCodes = new set<String>();
                set<String> set_SoldTos = new set<String>();
                set<String> set_Parts = new set<String>();
                CSD_ClsUtils.getSamsungGPLFamilyByUser(CSD_ClsUtils.getManageUserId(searchOb.managerId), searchOb.gplfamily, '', 
                                                        set_GPLFamilys, set_GPLCodes, set_SoldTos, set_Parts);
                
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
                                                                    and Monthly_Billings_Bookings_by_Part__r.Part__c IN :set_Parts
                                                                    and OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
                        set_monthIds.add(csdmap.Monthly_Billings_Bookings_by_Part__c);
                    }

                    list<String> list_beforesql = new list<String>();
                    list_beforesql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                    list_beforesql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_beforesql.add(' WHERE Id IN :set_monthids '
                            + ' Group by Fiscal_Date__c ');
                    CSD_ClsUtils.setGAMOEMMapRefData(searchOb.accnumber, set_monthIds, list_beforesql, map_acctId_map_dateKey_result_before);
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
                system.debug('@#searchOb:'+searchOb);
                
                if(searchOb.isOtherMethod != null && searchOb.isOtherMethod) {
                    return getOtherBacklogRefData(sData);
                }
                
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                CSD_ClsUtils.setRefDatelist(list_beforedate, list_futruedate, searchOb.set_fiscalMonth);
                
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();
                
                set<String> set_GPLFamilys = new set<String>();
                set<String> set_GPLCodes = new set<String>();
                set<String> set_SoldTos = new set<String>();
                set<String> set_Parts = new set<String>();
                CSD_ClsUtils.getSamsungGPLFamilyByUser(CSD_ClsUtils.getManageUserId(searchOb.managerId), searchOb.gplfamily, '', set_GPLFamilys, set_GPLCodes, set_SoldTos, set_Parts);

                
                if(list_futruedate.size() > 0) {
                    //futrue
                    //old  Updata the  Mingxing Qiu time is  2016-04-08 
                   /* set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    CSD_ClsUtils.setRefForecastDate(years, months, list_futruedate);
                    
                    set<String> set_dailyIds = new set<String>();
                    
                    for(CSD_OEM_Mapping_Daily_BBB__c csdmap : [select Daily_Booking_Billing_Backlog_By_Part__c 
                                                                from CSD_OEM_Mapping_Daily_BBB__c 
                                                                where Daily_Booking_Billing_Backlog_By_Part__r.Fiscal_Year__c IN :years
                                                                    and Daily_Booking_Billing_Backlog_By_Part__r.Fiscal_Month__c IN :months
                                                                    and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.AccountNumber IN :set_SoldTos
                                                                    and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.STATDESC__c = 'Active'
                                                                    and Daily_Booking_Billing_Backlog_By_Part__r.Part__c IN :set_Parts
                                                                    and CSD_OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
                        set_dailyIds.add(csdmap.Daily_Booking_Billing_Backlog_By_Part__c);
                    }

                    list<String> list_futruesql = new list<String>();
                    list_futruesql.add(' sum(Backlog_Amount_USD__c) amount, Fiscal_Date__c refdate');
                    list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c    ');
                    list_futruesql.add(' WHERE Id IN :set_monthids '
                        + ' Group by Fiscal_Date__c ');      
                       
                    CSD_ClsUtils.setGAMOEMMapRefData(searchOb.gplcode, set_dailyIds, list_futruesql, map_acctId_map_dateKey_result_futrue);
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
                                                                    and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.AccountNumber IN :set_SoldTos
                                                                    and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.STATDESC__c = 'Active'
                                                                    and Daily_Booking_Billing_Backlog_By_Part__r.Part__c IN :set_Parts
                                                                    and CSD_OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
                        set_dailyIds.add(csdmap.Daily_Booking_Billing_Backlog_By_Part__c);
                        }
    
                        list<String> list_futruesql = new list<String>();
                        list_futruesql.add(' sum(Backlog_Amount_USD__c) amount ');
                        list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c   ');
                        list_futruesql.add(' WHERE Id IN :set_monthids  ');  
                        CSD_ClsUtils.setGAMOEMMapRefDataBacklog(currentdate, searchOb.gplcode, set_dailyIds, list_futruesql, map_acctId_map_dateKey_result_futrue);
    
                    }
                }

                CSD_ClsEntityType.CSDRefObj refdata = CSD_ClsUtils.createRefDataObj();
                refdata.id = searchOb.gplcode;
                
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
        public String getOtherBacklogRefData(String sData) { 
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
                
                set<String> set_GPLFamilys = new set<String>();
                set<String> set_GPLCodes = new set<String>();
                set<String> set_SoldTos = new set<String>();
                set<String> set_Parts = new set<String>();
                CSD_ClsUtils.getSamsungGPLFamilyByUser(CSD_ClsUtils.getManageUserId(searchOb.managerId), searchOb.gplfamily, '', 
                                                        set_GPLFamilys, set_GPLCodes, set_SoldTos, set_Parts);
                                                        
                if(list_futruedate.size() > 0) {
                    //futrue
                    //old  Updata the  Mingxing Qiu time is  2016-04-08 
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
                                                                    and Daily_Booking_Billing_Backlog_By_Part__r.Part__c IN :set_Parts
                                                                    and CSD_OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
                        set_dailyIds.add(csdmap.Daily_Booking_Billing_Backlog_By_Part__c);
                    }

                    list<String> list_futruesql = new list<String>();
                    list_futruesql.add(' sum(Backlog_Amount_USD__c) amount, Fiscal_Date__c refdate');
                    list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c    ');
                    list_futruesql.add(' WHERE Id IN :set_monthids '
                        + ' Group by Fiscal_Date__c ');      
                       
                    CSD_ClsUtils.setGAMOEMMapRefData(searchOb.accnumber, set_dailyIds, list_futruesql, map_acctId_map_dateKey_result_futrue);
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
                                                                    and Daily_Booking_Billing_Backlog_By_Part__r.Part__c IN :set_Parts
                                                                    and CSD_OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
                        set_dailyIds.add(csdmap.Daily_Booking_Billing_Backlog_By_Part__c);
                        }

                        list<String> list_futruesql = new list<String>();
                        list_futruesql.add(' sum(Backlog_Amount_USD__c) amount ');
                        list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c    ');
                        list_futruesql.add(' WHERE Id IN :set_monthids ');                       
                        CSD_ClsUtils.setGAMOEMMapRefDataBacklog(currentdate, searchOb.accnumber, set_dailyIds, list_futruesql, map_acctId_map_dateKey_result_futrue);
                  
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
        
        public override String saveSObjectData(String sData) { 
            try {
                CSD_ClsEntityType.CSDForecastValueObj valueobj = (CSD_ClsEntityType.CSDForecastValueObj)JSON.deserialize(sData,CSD_ClsEntityType.CSDForecastValueObj.class);
                system.debug('@#valueobj:'+valueobj);
                //set<String> set_GPLFamilys = new set<String>();
                //set<String> set_GPLCodes = new set<String>();
                set<String> set_SoldTos = new set<String>();
                //set<String> set_Parts = new set<String>();
                
                //CSD_ClsUtils.getSamsungGPLFamilyByUser(UserInfo.getUserId(), valueobj.gplfamily, valueobj.gplcode, set_GPLFamilys, set_GPLCodes, set_SoldTos, set_Parts);
                
                String useremail = '%null%';
                for(User user : [select Email from User where Id = :CSD_ClsUtils.getManageUserId(valueobj.managerId)]) {
                    useremail = '%' + user.Email + '%';
                }
        
                for(CSD_Samsung_Mapping__c sm : [select GPL_Family__c, GPL_Code__c, Category__c, Part__c 
                                                from CSD_Samsung_Mapping__c 
                                                where Sales_Email__c like :useremail 
                                                    AND GPL_Family__c = :valueobj.gplfamily 
                                                    And Part__c = :valueobj.partId ]) {
                    set_SoldTos.add(sm.Category__c);
                }
                
                set<String> set_selectedId = new set<String>();
                list<String> list_sql = new list<String>();
                list_sql.add(' Sold_To_Number__c soldto ');
                list_sql.add(' CSD_Sales_Forecast__c ');
                list_sql.add(' WHERE Type__c = \'Sold-To\' '
                        + ' And Sold_To_Number__c in :set_SoldTos '
                        + ' And Part__c = \'' + valueobj.partId + '\' '
                        + ' And OEM__c = \'' + valueobj.oemId + '\' '
                        + ' And Samsung_Type__c = null '
                        + ' Group by Sold_To_Number__c ');
                        
                for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                    set_selectedId.add((String)result.get('soldto'));
                }
                
                
                set<String> set_nonselectedId = new set<String>();
                for(String accid : set_SoldTos) {
                    if(!set_selectedId.contains(accid)){
                        set_nonselectedId.add(accid);
                    }
                }
                map<String, String> map_accid_name = new map<String, String>();
                for(Account a : [Select Name, AccountNumber from Account Where AccountNumber IN: set_nonselectedId]){
                    map_accid_name.put(a.AccountNumber, a.Name);
                }
                
                
                system.debug('@#set_selectedId:'+set_selectedId);
                system.debug('@#set_nonselectedId:'+set_nonselectedId);
                
                map<String, decimal> map_accid_ratio = new map<String, decimal>();
                if(set_nonselectedId.size() > 0) {
                    Date fiscaldate = CSD_ClsUtils.getFiscalDate();
                    Date startdate = fiscaldate.addMonths(-6);
                    
                    list_sql.clear();
                    list_sql.add(' Customer__r.AccountNumber soldto, sum(Bill_Amount_USD__c) amount ');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.AccountNumber IN : set_nonselectedId ' 
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
                    
                    
                    for(String accid : set_nonselectedId) {
                        decimal ratio = 0;
                        if( map_accid_amount.get(accid) != null && map_accid_amount.get(accid) != 0) {
                            decimal amount = map_accid_amount.get(accid);
                            ratio = amount / allamount;
                        }
                        map_accid_ratio.put(accid, ratio);
                    }

                }   
                
                    map<String, map<String, CSD_Sales_Forecast__c>> map_key_map_dateKey_result = 
                            new map<String, map<String, CSD_Sales_Forecast__c>>();
                    //map<String, CSD_Sales_Forecast__c> map_date_forecast = new map<String, CSD_Sales_Forecast__c>();
                    for(CSD_Sales_Forecast__c fc : [select Id, GPL_Family__c, GPL_Code__c, Sold_To_Number__c, OEM__c, Part__c,
                                                        Type__c, Samsung_Type__c, Billing_Region__c, Price__c, Quantity__c, Forecast__c, 
                                                        Fiscal_Year__c, Fiscal_Month__c, Rest_SoldTo_Forecast__c
                                                    From CSD_Sales_Forecast__c 
                                                    where Sold_To_Number__c IN : set_nonselectedId 
                                                        And OEM__c = :valueobj.oemId 
                                                        And Part__c = :valueobj.partId
                                                        And Type__c = 'Sold-To' and Samsung_Type__c != null
                                                        ]) {
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
                    
                    /*map<String, map<String, CSD_Sales_Forecast__c>> map_key_map_dateKey_resultPart = 
                            new map<String, map<String, CSD_Sales_Forecast__c>>();
                            
                    for(CSD_Sales_Forecast__c fc : [select Id, GPL_Family__c, GPL_Code__c, Sold_To_Number__c, OEM__c, Part__c,
                                                        Type__c, Samsung_Type__c, Billing_Region__c, Price__c, Quantity__c, Forecast__c, 
                                                        Fiscal_Year__c, Fiscal_Month__c, Rest_SoldTo_Forecast__c
                                                    From CSD_Sales_Forecast__c 
                                                    where Sold_To_Number__c = null
                                                        And OEM__c = :valueobj.oemId 
                                                        And Part__c = :valueobj.partId
                                                        And Type__c = 'Part' and Samsung_Type__c = null
                                                        ]) {
                         String accId = fc.Part__c, 
                                year = (String)fc.Fiscal_Year__c,
                                month = (String)fc.Fiscal_Month__c, 
                                dateKey = (year + '_' + month);
                        if(!map_key_map_dateKey_resultPart.containsKey(accId)) {
                            map_key_map_dateKey_resultPart.put(accId, new map<String, CSD_Sales_Forecast__c>());
                        }
                        if(!map_key_map_dateKey_resultPart.get(accId).containsKey(dateKey)) {
                            map_key_map_dateKey_resultPart.get(accId).put(dateKey, fc);
                        }
                    }
                    */
                    list<CSD_Sales_Forecast__c> list_forecast = new list<CSD_Sales_Forecast__c>();
                    
                    for(String datekey : valueobj.csFC.keySet()) {
                        
                        String year = dateKey.substring(0, dateKey.indexOf('_'));
                        String month = dateKey.substring(dateKey.indexOf('_')+1, dateKey.length());
                        /*
                        CSD_Sales_Forecast__c forecastPart = new CSD_Sales_Forecast__c();
                        forecastPart.GPL_Family__c = valueobj.gplfamily;
                        forecastPart.GPL_Code__c = valueobj.gplcode;

                        forecastPart.Sold_To_Number__c = null;
                        forecastPart.OEM__c = valueobj.oemId;
                        forecastPart.Part__c = valueobj.partId;
                        forecastPart.Type__c = 'Part';
                        forecastPart.Samsung_Type__c = null;
                        if(map_key_map_dateKey_resultPart.containsKey(valueobj.partId) && map_key_map_dateKey_resultPart.get(valueobj.partId).containsKey(dateKey)) {
                            forecastPart.Id = map_key_map_dateKey_resultPart.get(valueobj.partId).get(dateKey).Id;
                        }
                        forecastPart.Sold_To_Name__c = null;
                        forecastPart.Billing_Region__c  = 'KOREA';
                        
                        forecastPart.Price__c = 0;
                        forecastPart.Quantity__c = 0;
                        forecastPart.Fiscal_Year__c = year;
                        forecastPart.Fiscal_Month__c = month;
                        forecastPart.Forecast__c = valueobj.csFC.get(dateKey).forecast;
                        forecastPart.Rest_SoldTo_Forecast__c = valueobj.csFC.get(dateKey).restPNFC;
                        forecastPart.CurrencyIsoCode = 'USD';
                        list_forecast.add(forecastPart);
                        */
                        //system.debug('@#forecastPart:'+forecastPart);
                        for(String accid : set_nonselectedId) {
                            CSD_Sales_Forecast__c forecast = new CSD_Sales_Forecast__c();
                            forecast.GPL_Family__c = valueobj.gplfamily;
                            forecast.GPL_Code__c = valueobj.gplcode;
                            forecast.Sold_To_Name__c = map_accid_name.containsKey(accid) ? map_accid_name.get(accid) : null;
                            forecast.Sold_To_Number__c = accid;
                            forecast.OEM__c = valueobj.oemId;
                            forecast.Part__c = valueobj.partId;
                            forecast.Type__c = 'Sold-To';
                            forecast.Samsung_Type__c = 'Non SoldTo';
                            if(map_key_map_dateKey_result.containsKey(accid) && map_key_map_dateKey_result.get(accid).containsKey(dateKey)) {
                                forecast.Id = map_key_map_dateKey_result.get(accid).get(dateKey).Id;
                            }
                            forecast.Billing_Region__c  = 'KOREA';
                            forecast.CurrencyIsoCode = 'USD';
                            forecast.Price__c = 0;
                            forecast.Quantity__c = 0;
                            forecast.Fiscal_Year__c = year;
                            forecast.Fiscal_Month__c = month;
                            forecast.Forecast__c = (valueobj.csFC.get(dateKey).restPNFC * map_accid_ratio.get(accid));
                            forecast.Rest_SoldTo_Forecast__c = forecast.Forecast__c;
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
            
            return 'true';
        }

        
        public override String deleteCSDObject(String sData) { 
            try {
                CSD_ClsEntityType.SearchObj valueobj = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
                
                String useremail = '%null%';
                for(User user : [select Email from User where Id = :CSD_ClsUtils.getManageUserId(valueobj.managerId)]) {
                    useremail = '%' + user.Email + '%';
                }
                set<String> set_SoldTos = new set<String>();
                for(CSD_Samsung_Mapping__c sm : [select GPL_Family__c, GPL_Code__c, Category__c, Part__c 
                                                from CSD_Samsung_Mapping__c 
                                                where Sales_Email__c like :useremail 
                                                    AND GPL_Family__c = :valueobj.gplfamily
                                                    AND Part__c = :valueobj.partId   ]) {
                    set_SoldTos.add(sm.Category__c);
                }
                
                list<CSD_Sales_Forecast__c> lsit_forecast = new list<CSD_Sales_Forecast__c>();
                
                for(CSD_Sales_Forecast__c fc : [select Id
                                                From CSD_Sales_Forecast__c 
                                                where Part__c = :valueobj.partId and OEM__c = :valueobj.oemId
                                                    and (Sold_To_Number__c IN :set_SoldTos or Sold_To_Number__c = null) and Type__c = 'Sold-To']) {
                                                    //and (Samsung_Type__c = null or Samsung_Type__c = 'Non SoldTo' )]) {
                     
                     lsit_forecast.add(fc);
                }
                if(lsit_forecast.size() > 0){
                    delete lsit_forecast;
                }

                return 'true'; 
            }catch(Exception ex) {
                throw ex;
            }
        }
        
        /**
         *  This method is used for Part searching 
         *  
         * @author Lei Tang
         * @created 2014-11-18
         * @version 1.0
         * @since 30.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-11-18 Lei Tang <lei.tang@itbconsult.com>
         * - Created
         *
        */
        public override String getSearchResult(String sData){
            
            list<CSD_ClsEntityType.AccountObj> list_parts = new list<CSD_ClsEntityType.AccountObj>();
            CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb:'+searchOb);
            String searchDescOrNumber = '%' + (searchOb.searchKey != null ? searchOb.searchKey : '') + '%';
            
            set<String> set_GPLFamilys = new set<String>();
            set<String> set_GPLCodes = new set<String>();
            set<String> set_SoldTos = new set<String>();
            set<String> set_Parts = new set<String>();
            
            CSD_ClsUtils.getSamsungGPLFamilyByUser(CSD_ClsUtils.getManageUserId(searchOb.managerId), searchOb.gplfamily, searchOb.gplcode, 
                                                    set_GPLFamilys, set_GPLCodes, set_SoldTos, set_Parts);
            
            system.debug('@#set_SoldTos:'+set_SoldTos);
            system.debug('@#set_Parts:'+set_Parts);
            
            list<String> list_sql = new list<String>();
            set<String> set_selectedCode = new set<String>();
            if(searchOb.set_selectedId == null) {
                searchOb.set_selectedId = new set<string>();
            }
            if(searchOb.set_deletedId == null){
                searchOb.set_deletedId = new set<string>();
            }
            /*
            list_sql.add(' Part__c part , GPL_Code__c gplcode');
            list_sql.add(' CSD_Sales_Forecast__c ');
            list_sql.add(' WHERE Type__c = \'Part\' '
                    + ' And Part__c IN :set_Parts  ' 
                    + ' And Samsung_Type__c = null '
                    + ' AND OEM__c = \'' + searchOb.oemId + '\' '
                    + ' And GPL_Family__c = \'' + searchOb.gplfamily + '\' '
                    + ' Group by Part__c, GPL_Code__c ');
            
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                if(!searchOb.set_selectedId.contains((String)result.get('part')) && !searchOb.set_deletedId.contains((String)result.get('part'))) {
                    searchOb.set_selectedId.add((String)result.get('part'));
                }
                if(!set_selectedCode.contains((String)result.get('gplcode')) && !searchOb.set_deletedId.contains((String)result.get('part'))){
                    set_selectedCode.add((String)result.get('gplcode'));
                }  
            }
            */
            system.debug('@#searchOb.set_selectedId:'+searchOb.set_selectedId);
            system.debug('@#set_selectedCode:'+set_selectedCode);
            set<String> set_selectedId = searchOb.set_selectedId;
            
            list_sql.clear();
            list_sql.add(' GPL_Code__c gplcode, Part__c part, Part__r.Name partname, Part__r.Description__c descr, Part__r.Product_Hierarchy__r.GPL_Description__c gpldescr ');
            list_sql.add(' CSD_Samsung_Mapping__c ');
            String strwhere = ' where GPL_Family__c = \'' + searchOb.gplfamily + '\' '
                    + ' And Category__c IN :set_SoldTos ' 
                    + ' And Part__c IN :set_Parts '
                    + ' And Part__c not IN :set_selectedId '
                    + ' And (Part__r.Name like :searchDescOrNumber or Part__r.Description__c like :searchDescOrNumber or GPL_Code__c like :searchDescOrNumber or Part__r.Product_Hierarchy__r.GPL_Description__c like :searchDescOrNumber) ';
            strwhere += ' And GPL_Code__c = \'' + searchOb.gplcode + '\' ';
            strwhere += ' group by GPL_Code__c, Part__c, Part__r.Name, Part__r.Description__c, Part__r.Product_Hierarchy__r.GPL_Description__c order by Part__r.Name limit 100';

            list_sql.add(strwhere);
            
            map<String, CSD_ClsEntityType.AccountObj> map_part_result = new map<String, CSD_ClsEntityType.AccountObj>();
            system.debug('@#slist_sql:'+list_sql);
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                
                CSD_ClsEntityType.AccountObj partObj = new CSD_ClsEntityType.AccountObj();
                CSD_ClsUtils.createAccountObj(partObj, searchOb.map_year_monthsFuture);
                partObj.id = (String)result.get('part');
                partObj.name = (String)result.get('partname');
                partObj.snumber = (String)result.get('descr');
                partObj.gplcode = (String)result.get('gplcode');
                partObj.accnumber = (String)result.get('gpldescr');
                partObj.gplfamily = searchOb.gplfamily;
                //list_parts.add(partObj);
                
                map_part_result.put(partObj.id, partObj);
            }
            
            
            Date currentdate = Date.valueOf(searchOb.startDate);
            Date enddate = Date.valueOf(searchOb.endDate);
            
            set<String> set_partIds = map_part_result.keySet();
            list_sql.clear();
            list_sql.add('Part__c part, Fiscal_Year__c year, Fiscal_Month__c month, '
                        + ' max(Quantity__c) quantity, sum(Forecast__c) sumFC, max(Price__c) price, sum(Rest_SoldTo_Forecast__c) restSTFC, '
                        + ' sum(DC_Forecast_Amount__c) sumDCFC, sum(Previous_Month_Forecast__c) sumPMFC');
            list_sql.add(' CSD_Sales_Forecast__c ');
            list_sql.add(' WHERE OEM__c = \'' + searchOb.oemId + '\' ' 
                    + ' And Type__c = \'Sold-To\' And (Samsung_Type__c = null or Samsung_Type__c = \'Non SoldTo\') '
                    + ' And GPL_Family__c = \''+searchOb.gplfamily+'\''
                    + ' And Part__c IN :set_partIds  '
                    + ' And Sold_To_Number__c IN :set_SoldTos  '
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Part__c, Fiscal_Year__c, Fiscal_Month__c');
            
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                //system.debug('@#result : '+result);
                String accId = (String)result.get('part'), 
                       year = (String)result.get('year'),
                       month = (String)result.get('month'), 
                       dateKey = (year + '_' + month);

                if(!map_part_result.containsKey(accId)) {
                    continue;
                }else {
                    //CSD_ClsEntityType.AccountObj acctFC = map_part_result.get(accId);
                    
                    map_part_result.get(accId).restPNFC.put(dateKey, (result.get('restSTFC') != null ? (decimal)result.get('restSTFC') : 0));
                    map_part_result.get(accId).csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
                    map_part_result.get(accId).dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
                    map_part_result.get(accId).pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
                }
            }
            
            
            return JSON.serialize(map_part_result.values());

        }
        
        
        /**
         *  This function is get value of level2 by level1
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
            
            set<String> set_GPLFamilys = new set<String>();
            set<String> set_GPLCodes = new set<String>();
            set<String> set_SoldTos = new set<String>();
            set<String> set_Parts = new set<String>();
            
            CSD_ClsUtils.getSamsungGPLFamilyByUser(CSD_ClsUtils.getManageUserId(searchOb.managerId), searchOb.gplfamily, searchOb.gplcode, set_GPLFamilys, set_GPLCodes, set_SoldTos, set_Parts);

            if(searchOb.viewMode != null && searchOb.viewMode == 'view' ) {
                if(searchOb.isOtherMethod != null && searchOb.isOtherMethod) {
                    return getExistResultBySoldToView(sData, set_Parts);
                }
            }
            
            Date currentdate = Date.valueOf(searchOb.startDate);
            Date enddate = Date.valueOf(searchOb.endDate);

            list<String> list_sql = new list<String>();
            
            list_sql.add('Part__c part, Part__r.Name partname, Part__r.Description__c descr, Fiscal_Year__c year, Fiscal_Month__c month, '
                        + ' max(Quantity__c) quantity, sum(Forecast__c) sumFC, max(Price__c) price, sum(Rest_SoldTo_Forecast__c) restSTFC, '
                        + ' sum(DC_Forecast_Amount__c) sumDCFC, sum(Previous_Month_Forecast__c) sumPMFC');
            list_sql.add(' CSD_Sales_Forecast__c ');
            list_sql.add(' WHERE OEM__c = \'' + searchOb.oemId + '\' ' 
                    + (searchOb.viewMode == 'view' ? ' And Type__c = \'Sold-To\' ' : ' And Type__c = \'Sold-To\' And (Samsung_Type__c = null or Samsung_Type__c = \'Non SoldTo\') ')
                    + ' And GPL_Family__c = \''+searchOb.gplfamily+'\''
                    + ' And GPL_Code__c = \''+searchOb.gplcode+'\' '
                    + ' And Sold_To_Number__c IN :set_SoldTos '
                    + ' And Part__c IN :set_Parts  '
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Part__c, Part__r.Name, Fiscal_Year__c, Fiscal_Month__c, Part__r.Description__c ');
            
            map<String, CSD_ClsEntityType.AccountObj> map_acctId_acctFC = new map<String, CSD_ClsEntityType.AccountObj>();
        
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                //system.debug('@#result : '+result);
                String accId = (String)result.get('part'), 
                       year = (String)result.get('year'),
                       month = (String)result.get('month'), 
                       dateKey = (year + '_' + month);

                CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
    
                if(!map_acctId_acctFC.containsKey(accId)) {
                    CSD_ClsUtils.createAccountObj(acctFC, searchOb.map_year_monthsFuture);
                    
                    acctFC.id = accId;
                    acctFC.name = (String)result.get('partname') + (result.get('descr') == null ? '' : ' - '+(String)result.get('descr'));
                    acctFC.snumber = result.get('descr') != null ? (String)result.get('descr') : '';
                    map_acctId_acctFC.put(accId, acctFC);
                }else {
                    acctFC = map_acctId_acctFC.get(accId);
                }
                
                acctFC.restPNFC.put(dateKey, (result.get('restSTFC') != null ? (decimal)result.get('restSTFC') : 0));
                acctFC.csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
                acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
                acctFC.pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
                
                
            }
            
            list<CSD_ClsEntityType.AccountObj> list_partnonsoldtos = new list<CSD_ClsEntityType.AccountObj>();
            list_partnonsoldtos.addAll(map_acctId_acctFC.values());
            list_partnonsoldtos.sort();
            
            return Json.serialize(list_partnonsoldtos);

        }

        /**
         *  This function is get value of level2 by level1
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
        public String getExistResultBySoldToView(String sData, set<String> set_Parts){
            
            CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData, CSD_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb'+searchOb);

            Date currentdate = Date.valueOf(searchOb.startDate);
            Date enddate = Date.valueOf(searchOb.endDate);

            list<String> list_sql = new list<String>();
            
            list_sql.add(' Part__c part, Part__r.Name partname, Part__r.Description__c descr, Fiscal_Year__c year, Fiscal_Month__c month, '
                        + ' max(Quantity__c) quantity, sum(Forecast__c) sumFC, max(Price__c) price, '
                        + ' sum(DC_Forecast_Amount__c) sumDCFC, sum(Previous_Month_Forecast__c) sumPMFC ');
            list_sql.add(' CSD_Sales_Forecast__c ');
            list_sql.add(' WHERE OEM__c = \'' + searchOb.oemId + '\' ' 
                    + ' And Sold_To_Number__c = \'' + searchOb.accnumber + '\' '
                    + ' And Type__c = \'Sold-To\' '
                    + ' And Part__c IN :set_Parts '
                    + ' And GPL_Family__c = \'' + searchOb.gplfamily + '\''
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, Part__c, Part__r.Name, Part__r.Description__c ');
            
            map<String, CSD_ClsEntityType.AccountObj> map_acctId_acctFC = new map<String, CSD_ClsEntityType.AccountObj>();

            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                //system.debug('@#result : '+result);
                String accId = (String)result.get('part'), 
                       year = (String)result.get('year'),
                       month = (String)result.get('month'), 
                       dateKey = (year + '_' + month);
                system.debug('@#result'+result);
                CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
    
                if(!map_acctId_acctFC.containsKey(accId)) {
                    CSD_ClsUtils.createAccountObj(acctFC, searchOb.map_year_monthsFuture);
                    
                    acctFC.id = accId;
                    acctFC.name = (String)result.get('partname');
                    acctFC.snumber = result.get('descr') != null ? (String)result.get('descr') : '';
                    //acctFC.gplcode = (String)result.get('gplcode');
                    acctFC.type = 'NonPart';
                    map_acctId_acctFC.put(accId, acctFC);
                }else {
                    acctFC = map_acctId_acctFC.get(accId);
                }
                
                acctFC.csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
                acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
                acctFC.pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
 
            }
            
            list<CSD_ClsEntityType.AccountObj> list_codesoldtos = new list<CSD_ClsEntityType.AccountObj>();
            list_codesoldtos.addAll(map_acctId_acctFC.values());
            list_codesoldtos.sort();
            
            return Json.serialize(list_codesoldtos);
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
                
                if(searchOb.isOtherMethod != null && searchOb.isOtherMethod) {
                    return getOtherRefData(sData);
                }
                
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                CSD_ClsUtils.setRefDatelist(list_beforedate, list_futruedate, searchOb.set_fiscalMonth);
                
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();
                
                set<String> set_SoldTos = new set<String>();
                String useremail = '%null%';
                
                for(User user : [select Email from User where Id = :CSD_ClsUtils.getManageUserId(searchOb.managerId)]) {
                    useremail = '%' + user.Email + '%';
                }
                for(CSD_Samsung_Mapping__c sm : [select GPL_Family__c, GPL_Code__c, Category__c, Part__c 
                                                from CSD_Samsung_Mapping__c 
                                                where Sales_Email__c like :useremail 
                                                    AND GPL_Family__c = :searchOb.gplfamily
                                                    AND Part__c = :searchOb.partId]) {
                    if(!set_SoldTos.contains(sm.Category__c)) {
                        set_SoldTos.add(sm.Category__c);
                    }
                }

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
                                                                    and Monthly_Billings_Bookings_by_Part__r.Customer__r.AccountNumber IN :set_SoldTos
                                                                    and Monthly_Billings_Bookings_by_Part__r.Customer__r.STATDESC__c = 'Active'
                                                                    and Monthly_Billings_Bookings_by_Part__r.Part__c = :searchOb.partId
                                                                    and OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
                        set_monthIds.add(csdmap.Monthly_Billings_Bookings_by_Part__c);
                    }
                    
                    
                    
                    list<String> list_beforesql = new list<String>();
                    list_beforesql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                    list_beforesql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_beforesql.add(' WHERE Id IN :set_monthids '
                            + ' Group by Fiscal_Date__c ');
                    CSD_ClsUtils.setGAMOEMMapRefData(searchOb.partId, set_monthIds, list_beforesql, map_acctId_map_dateKey_result_before);
                }
                
                CSD_ClsEntityType.CSDRefObj refdata = CSD_ClsUtils.createRefDataObj();
                refdata.id = searchOb.partId;
                
                CSD_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
        }
        
        
        /**
         *  This function is used get other reference data list.
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
        public String getOtherRefData(String sData) { 
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
                    list_beforesql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                    list_beforesql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_beforesql.add(' WHERE Id IN :set_monthids '
                            + ' Group by Fiscal_Date__c ');
                    CSD_ClsUtils.setGAMOEMMapRefData(searchOb.partId, set_monthIds, list_beforesql, map_acctId_map_dateKey_result_before);
                }
                
                CSD_ClsEntityType.CSDRefObj refdata = CSD_ClsUtils.createRefDataObj();
                refdata.id = searchOb.partId;
                
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
                system.debug('@#searchOb:'+searchOb);
                
                if(searchOb.isOtherMethod != null && searchOb.isOtherMethod) {
                    return getOtherBacklogRefData(sData);
                }
                
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                CSD_ClsUtils.setRefDatelist(list_beforedate, list_futruedate, searchOb.set_fiscalMonth);
                
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();
                
                set<String> set_SoldTos = new set<String>();
                String useremail = '%null%';
                
                for(User user : [select Email from User where Id = :CSD_ClsUtils.getManageUserId(searchOb.managerId)]) {
                    useremail = '%' + user.Email + '%';
                }
                for(CSD_Samsung_Mapping__c sm : [select GPL_Family__c, GPL_Code__c, Category__c, Part__c 
                                                from CSD_Samsung_Mapping__c 
                                                where Sales_Email__c like :useremail 
                                                    AND GPL_Family__c = :searchOb.gplfamily
                                                    AND Part__c = :searchOb.partId]) {
                    if(!set_SoldTos.contains(sm.Category__c)) {
                        set_SoldTos.add(sm.Category__c);
                    }
                }
                
                if(list_futruedate.size() > 0) {
                    //futrue
                    //old  Updata the  Mingxing Qiu time is  2016-04-08 
                  /*set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    CSD_ClsUtils.setRefForecastDate(years, months, list_futruedate);
                    
                    set<String> set_dailyIds = new set<String>();
                    
                    for(CSD_OEM_Mapping_Daily_BBB__c csdmap : [select Daily_Booking_Billing_Backlog_By_Part__c 
                                                                from CSD_OEM_Mapping_Daily_BBB__c 
                                                                where Daily_Booking_Billing_Backlog_By_Part__r.Fiscal_Year__c IN :years
                                                                    and Daily_Booking_Billing_Backlog_By_Part__r.Fiscal_Month__c IN :months
                                                                    and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.AccountNumber IN :set_SoldTos
                                                                    and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.STATDESC__c = 'Active'
                                                                    and Daily_Booking_Billing_Backlog_By_Part__r.Part__c = :searchOb.partId
                                                                    and CSD_OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
                        set_dailyIds.add(csdmap.Daily_Booking_Billing_Backlog_By_Part__c);
                    }

                    list<String> list_futruesql = new list<String>();
                    list_futruesql.add(' sum(Backlog_Amount_USD__c) amount, Fiscal_Date__c refdate');
                    list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c    ');
                    list_futruesql.add(' WHERE Id IN :set_monthids '
                        + ' Group by Fiscal_Date__c ');      
                       
                    CSD_ClsUtils.setGAMOEMMapRefData(searchOb.partId, set_dailyIds, list_futruesql, map_acctId_map_dateKey_result_futrue);
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
                                                                    and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.AccountNumber IN :set_SoldTos
                                                                    and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.STATDESC__c = 'Active'
                                                                    and Daily_Booking_Billing_Backlog_By_Part__r.Part__c = :searchOb.partId
                                                                    and CSD_OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
                        set_dailyIds.add(csdmap.Daily_Booking_Billing_Backlog_By_Part__c);
                        }

                        list<String> list_futruesql = new list<String>();
                        list_futruesql.add(' sum(Backlog_Amount_USD__c) amount ');
                        list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c    ');
                        list_futruesql.add(' WHERE Id IN :set_monthids '); 
                        CSD_ClsUtils.setGAMOEMMapRefDataBacklog(currentdate, searchOb.partId, set_dailyIds, list_futruesql, map_acctId_map_dateKey_result_futrue);
                   
                    }
                }

                CSD_ClsEntityType.CSDRefObj refdata = CSD_ClsUtils.createRefDataObj();
                refdata.id = searchOb.partId;
                
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
        public String getOtherBacklogRefData(String sData) { 
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
                
                set<String> set_GPLFamilys = new set<String>();
                set<String> set_GPLCodes = new set<String>();
                set<String> set_SoldTos = new set<String>();
                set<String> set_Parts = new set<String>();
                CSD_ClsUtils.getSamsungGPLFamilyByUser(CSD_ClsUtils.getManageUserId(searchOb.managerId), searchOb.gplfamily, '', 
                                                        set_GPLFamilys, set_GPLCodes, set_SoldTos, set_Parts);
                                                        
                if(list_futruedate.size() > 0) {
                    //futrue
                    //old  Updata the  Mingxing Qiu time is  2016-04-08 
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
                                                                    and CSD_OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
                        set_dailyIds.add(csdmap.Daily_Booking_Billing_Backlog_By_Part__c);
                    }

                    list<String> list_futruesql = new list<String>();
                    list_futruesql.add(' sum(Backlog_Amount_USD__c) amount, Fiscal_Date__c refdate');
                    list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c    ');
                    list_futruesql.add(' WHERE Id IN :set_monthids '
                        + ' Group by Fiscal_Date__c ');      
                       
                    CSD_ClsUtils.setGAMOEMMapRefData(searchOb.partId, set_dailyIds, list_futruesql, map_acctId_map_dateKey_result_futrue);
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
                                                                    and CSD_OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
                        set_dailyIds.add(csdmap.Daily_Booking_Billing_Backlog_By_Part__c);
                        }
    
                        list<String> list_futruesql = new list<String>();
                        list_futruesql.add(' sum(Backlog_Amount_USD__c) amount ');
                        list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
                        list_futruesql.add(' WHERE Id IN :set_monthids ');     
                        CSD_ClsUtils.setGAMOEMMapRefDataBacklog(currentdate, searchOb.partId, set_dailyIds, list_futruesql, map_acctId_map_dateKey_result_futrue);
                 
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
                system.debug('@#valueobj:'+valueobj);
                if(valueobj.partId == null || valueobj.partId == '') {
                    return saveNonPartSoldToData(sData);
                }
                map<String, CSD_Sales_Forecast__c> map_date_forecast = new map<String, CSD_Sales_Forecast__c>();
                for(CSD_Sales_Forecast__c fc : [select Id, Fiscal_Year__c, Fiscal_Month__c, Sold_To_Number__c
                                                , OEM__c, Part__c, Price__c, Quantity__c, Forecast__c, Type__c
                                                From CSD_Sales_Forecast__c 
                                                where Sold_To_Number__c = : valueobj.accnumber 
                                                    And OEM__c = :valueobj.oemId 
                                                    And Part__c = :valueobj.partId 
                                                    And Type__c = 'Sold-To' 
                                                    And (Samsung_Type__c = null or Samsung_Type__c != 'Non Part') ] ) {
                     map_date_forecast.put((fc.Fiscal_Year__c + '_' + fc.Fiscal_Month__c ), fc);
                }

                list<CSD_Sales_Forecast__c> list_forecast = new list<CSD_Sales_Forecast__c>();
                for(String key : valueobj.csFC.keySet()) {
                    CSD_Sales_Forecast__c forecast = new CSD_Sales_Forecast__c();
                    forecast.GPL_Family__c = valueobj.gplfamily;
                    forecast.GPL_Code__c = valueobj.gplcode;
                    
                    forecast.Price__c = valueobj.csFC.get(key).price;
                    forecast.Quantity__c = valueobj.csFC.get(key).quantity;
                    forecast.Forecast__c = valueobj.csFC.get(key).forecast;
                    forecast.Rest_SoldTo_Forecast__c = 0;
                    forecast.Fiscal_Year__c = key.substring(0, key.indexOf('_'));
                    forecast.Fiscal_Month__c = key.substring(key.indexOf('_')+1, key.length());
                    forecast.CurrencyIsoCode = 'USD';
                    forecast.Sold_To_Number__c = valueobj.accnumber;
                    forecast.Sold_To_Name__c = valueobj.name;
                    forecast.OEM__c = valueobj.oemId;
                    forecast.Part__c = valueobj.partId;
                    forecast.Samsung_Type__c = null;
                    forecast.Billing_Region__c  = 'KOREA';
                    forecast.Type__c = 'Sold-To';
                    if(map_date_forecast.containsKey(key)) {
                        forecast.Id = map_date_forecast.get(key).Id;
                    }
                    
                    list_forecast.add(forecast);
                }
                
                for(CSD_Sales_Forecast__c sf : list_forecast) {
                    system.debug('@#sf :'+sf);
                }
                
                
                if(list_forecast.size() > 0) {
                    upsert list_forecast;
                }
                return 'true';
            }catch(Exception ex) {
                throw ex;
            }
        }
        
        
        
        public String saveNonPartSoldToData(String sData) { 
            
            try {
                CSD_ClsEntityType.CSDForecastValueObj valueobj = (CSD_ClsEntityType.CSDForecastValueObj)JSON.deserialize(sData,CSD_ClsEntityType.CSDForecastValueObj.class);
                system.debug('@#valueobj:'+valueobj);
                String useremail = '%null%';
                for(User user : [select Email from User where Id = :CSD_ClsUtils.getManageUserId(valueobj.managerId)]) {
                    useremail = '%' + user.Email + '%';
                }
                set<String> set_Parts = new set<String>();
                map<String, String> map_partid_gplcode = new map<String, String>();
                
                for(CSD_Samsung_Mapping__c sm : [select GPL_Family__c, GPL_Code__c, Category__c, Part__c 
                                                from CSD_Samsung_Mapping__c 
                                                where Sales_Email__c like :useremail 
                                                    AND GPL_Family__c = :valueobj.gplfamily
                                                    AND Category__c = :valueobj.accnumber   ]) {
                    set_Parts.add(sm.Part__c);
                    map_partid_gplcode.put(sm.Part__c, sm.GPL_Code__c);
                }
                
                set<String> set_selectedId = new set<String>();
                list<String> list_sql = new list<String>();
                list_sql.add(' Part__c part ');
                list_sql.add(' CSD_Sales_Forecast__c ');
                list_sql.add(' WHERE Type__c = \'Sold-To\' '
                        + ' And Part__c IN :set_Parts '
                        + ' And Sold_To_Number__c = \'' + valueobj.accnumber + '\' '
                        + ' And OEM__c = \'' + valueobj.oemId + '\' '
                        + ' And (Samsung_Type__c = null or Samsung_Type__c = \'Non SoldTo\') '
                        + ' Group by Part__c ');
                        
                for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                    set_selectedId.add((String)result.get('part'));
                }
                
                set<String> set_nonselectedId = new set<String>();
                for(String partid : map_partid_gplcode.keySet()) {
                    if(!set_selectedId.contains(partid)){
                        set_nonselectedId.add(partid);
                    }
                }
                
                
                if(set_nonselectedId.size() > 0) {
                    Date fiscaldate = CSD_ClsUtils.getFiscalDate();
                    Date startdate = fiscaldate.addMonths(-6);
    
                    set<String> set_monthIds = new set<String>();
                    for(CSD_OEM_Mapping_Monthly_BBB__c csdmap : [select Monthly_Billings_Bookings_by_Part__c 
                                                                from CSD_OEM_Mapping_Monthly_BBB__c 
                                                                where Monthly_Billings_Bookings_by_Part__r.Fiscal_Date__c >= : startdate 
                                                                    and Monthly_Billings_Bookings_by_Part__r.Fiscal_Date__c < : fiscaldate
                                                                    and Monthly_Billings_Bookings_by_Part__r.Customer__r.AccountNumber = :valueobj.accnumber
                                                                    and Monthly_Billings_Bookings_by_Part__r.Part__c IN :set_nonselectedId
                                                                    and OEM_Mapping__r.OEM__r.OEM__c = :valueobj.oemId]) {
                        set_monthIds.add(csdmap.Monthly_Billings_Bookings_by_Part__c);
                    }
                    
                    
                    
                    
                    list_sql.clear();
                    list_sql.add(' Part__c part, sum(Bill_Amount_USD__c) amount ');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Id IN :set_monthids '
                            + ' group by Part__c ');
                    map<String, decimal> map_partid_amount = new map<String, decimal>();
                    decimal allamount = 0;
                    for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                        if(result.get('amount') != null ) {
                            decimal amount = (decimal)result.get('amount');
                            allamount += amount;
                            map_partid_amount.put((String)result.get('part'), amount);
                        }
                    }
                    
                    map<String, decimal> map_partid_ratio = new map<String, decimal>();
                    for(String partid : set_nonselectedId) {
                        decimal ratio = 0;
                        if( map_partid_amount.get(partid) != null && map_partid_amount.get(partid) != 0) {
                            decimal amount = map_partid_amount.get(partid);
                            ratio = amount / allamount;
                        }
                        map_partid_ratio.put(partid, ratio);
                    }
                    
                    map<String, map<String, CSD_Sales_Forecast__c>> map_key_map_dateKey_result = 
                            new map<String, map<String, CSD_Sales_Forecast__c>>();
                    //map<String, CSD_Sales_Forecast__c> map_date_forecast = new map<String, CSD_Sales_Forecast__c>();
                    for(CSD_Sales_Forecast__c fc : [select Id, Fiscal_Year__c, Fiscal_Month__c, Sold_To_Number__c, 
                                                     OEM__c, Part__c, Price__c, Quantity__c, Forecast__c, Type__c
                                                    From CSD_Sales_Forecast__c 
                                                    where Sold_To_Number__c = : valueobj.accnumber 
                                                        And OEM__c = :valueobj.oemId 
                                                        And Part__c IN :set_nonselectedId
                                                        And Type__c = 'Sold-To' 
                                                        ] ) {
                         
                         String partId = fc.Part__c, 
                                year = (String)fc.Fiscal_Year__c,
                                month = (String)fc.Fiscal_Month__c, 
                                dateKey = (year + '_' + month);
                        if(!map_key_map_dateKey_result.containsKey(partId)) {
                            map_key_map_dateKey_result.put(partId, new map<String, CSD_Sales_Forecast__c>());
                        }
                        if(!map_key_map_dateKey_result.get(partId).containsKey(dateKey)) {
                            map_key_map_dateKey_result.get(partId).put(dateKey, fc);
                        }
                         
                        //map_date_forecast.put((fc.Fiscal_Year__c + '_' + fc.Fiscal_Month__c ), fc);
                    }
                    
                    list<CSD_Sales_Forecast__c> list_forecast = new list<CSD_Sales_Forecast__c>();
                    
                    for(String datekey : valueobj.csFC.keySet()) {
                        
                        String year = dateKey.substring(0, dateKey.indexOf('_'));
                        String month = dateKey.substring(dateKey.indexOf('_')+1, dateKey.length());
                        
                        for(String partid : set_nonselectedId) {
                            CSD_Sales_Forecast__c forecast = new CSD_Sales_Forecast__c();
                            forecast.GPL_Family__c = valueobj.gplfamily;
                            forecast.GPL_Code__c = map_partid_gplcode.get(partid);
                            
                            forecast.OEM__c = valueobj.oemId;
                            forecast.Sold_To_Number__c = valueobj.accnumber;
                            forecast.Sold_To_Name__c = valueobj.name;
                            forecast.Part__c = partid;
                            forecast.Type__c = 'Sold-To';
                            forecast.Samsung_Type__c = 'Non Part';
                            if(map_key_map_dateKey_result.containsKey(partid) && map_key_map_dateKey_result.get(partid).containsKey(dateKey)) {
                                forecast.Id = map_key_map_dateKey_result.get(partid).get(dateKey).Id;
                            }
                            
                            forecast.Billing_Region__c  = 'KOREA';
                            forecast.CurrencyIsoCode = 'USD';
                            forecast.Price__c = 0;
                            forecast.Quantity__c = 0;
                            forecast.Rest_SoldTo_Forecast__c = 0;
                            forecast.Fiscal_Year__c = year;
                            forecast.Fiscal_Month__c = month;
                            forecast.Forecast__c = (valueobj.csFC.get(dateKey).forecast * map_partid_ratio.get(partid));
                            list_forecast.add(forecast);
                        }
                    }
                    if(list_forecast.size() > 0) {
                        upsert list_forecast;
                    }
                }
                
                
                return 'true';
            }catch(Exception ex) {
                throw ex;
            }
            
            return 'true';
        }
        
        
        public override String deleteCSDObject(String sData) { 
            try {
                CSD_ClsEntityType.SearchObj valueobj = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
                
                list<CSD_Sales_Forecast__c> lsit_forecast = new list<CSD_Sales_Forecast__c>();
                system.debug('@#valueobj:'+valueobj);
                if(valueobj.isExpansionSoldto != null && valueobj.isExpansionSoldto) {
                     for(CSD_Sales_Forecast__c fc : [select Id 
                                                    From CSD_Sales_Forecast__c 
                                                    where GPL_Family__c = :valueobj.gplfamily 
                                                     and Sold_To_Number__c = :valueobj.accnumber
                                                     and OEM__c = :valueobj.oemId and Type__c = 'Sold-To' 
                                                     and Samsung_Type__c = 'Non Part'  ]) {
                         lsit_forecast.add(fc);
                    }
                }else {
                    for(CSD_Sales_Forecast__c fc : [select Id 
                                                    From CSD_Sales_Forecast__c 
                                                    where GPL_Family__c = :valueobj.gplfamily and GPL_Code__c = :valueobj.gplcode
                                                     and Part__c = :valueobj.partId and Sold_To_Number__c = :valueobj.accnumber
                                                     and OEM__c = :valueobj.oemId and Type__c = 'Sold-To' 
                                                     and Samsung_Type__c = null  ]) {
                         lsit_forecast.add(fc);
                    }
                }
                if(lsit_forecast.size() > 0){
                    delete lsit_forecast;
                }

                return 'true'; 
            }catch(Exception ex) {
                throw ex;
            }
        }
        
        
        public override String getSearchResult(String sData){
            
            CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData, CSD_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb:'+searchOb);
            if(searchOb.isExpansionSoldto != null && searchOb.isExpansionSoldto) {
                return getSearchResultByNonPart(sData);
                //searchOb.partId = '';
            }
            
            list<CSD_ClsEntityType.PartObj> list_soldTos = new list<CSD_ClsEntityType.PartObj>();
            String searchNameOrNumber = '%'+searchOb.searchKey+'%';
            
            Date fiscaldate = Date.valueOf(searchOb.startDate);
            Date enddate = Date.valueOf(searchOb.endDate);
            
            set<String> set_GPLFamilys = new set<String>();
            set<String> set_GPLCodes = new set<String>();
            set<String> set_SoldTos = new set<String>();
            set<String> set_Parts = new set<String>();
            
            CSD_ClsUtils.getSamsungGPLFamilyByUser(CSD_ClsUtils.getManageUserId(searchOb.managerId), searchOb.gplfamily, searchOb.gplcode, 
                                                        set_GPLFamilys, set_GPLCodes, set_SoldTos, set_Parts);
            system.debug('@#set_SoldTos:'+set_SoldTos);

            list<String> list_sql = new list<String>();
            
            if(searchOb.set_selectedId == null) {
                searchOb.set_selectedId = new set<string>();
            }
            if(searchOb.set_deletedId == null){
                searchOb.set_deletedId = new set<string>();
            }
            
            list_sql.add(' Sold_To_Number__c soldto ');
            list_sql.add(' CSD_Sales_Forecast__c ');
            
            String strwhere = ' WHERE Type__c = \'Sold-To\' '
                            + ' And OEM__c = \'' + searchOb.oemId + '\' '
                            + ' And Sold_To_Number__c IN :set_SoldTos '
                            + ' And Fiscal_Date__c >= : fiscaldate '
                            + ' And Fiscal_Date__c < : enddate ';
                strwhere += ' And Part__c = \'' + searchOb.partId + '\' '
                         + ' And Samsung_Type__c = null ';
            strwhere += ' Group by Sold_To_Number__c ';
            list_sql.add(strwhere);
            //system.debug('@#list_sql 1:'+CSD_ClsUtils.getQueryString(list_sql));
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                if(!searchOb.set_selectedId.contains((String)result.get('soldto')) && !searchOb.set_deletedId.contains((String)result.get('soldto'))) {
                    searchOb.set_selectedId.add((String)result.get('soldto'));
                }
            }
            
            strwhere = '';
            list_sql.clear();
            
            set<String> selectedids = searchOb.set_selectedId;
            system.debug('@#selectedids:'+selectedids);
            list_sql.add(' Category__c soldto, Sold_to_Name__c accname ');
            list_sql.add(' CSD_Samsung_Mapping__c ');
            
            strwhere = ' WHERE GPL_Family__c = \'' + searchOb.gplfamily + '\' '
                                + ' And (Category__c like :searchNameOrNumber or Sold_to_Name__c like :searchNameOrNumber)';
            
                strwhere += ' And Part__c = \'' + searchOb.partId + '\' ';
            
            strwhere += ' And Category__c IN :set_SoldTos '
                            + ' And Category__c not IN :selectedids '
                            + ' Group by Category__c, Sold_to_Name__c Order by Category__c limit 100';          
            list_sql.add(strwhere);
            system.debug('@#list_sql 2:'+CSD_ClsUtils.getQueryString(list_sql));   
            
            set<String> set_hascftsoldtoid = new set<String>();
            map<String, AggregateResult> map_soldtoid_soldto = new map<String, AggregateResult>();
            
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                map_soldtoid_soldto.put((String)result.get('soldto'), result);
            }
            /*
            map<String, String> map_accnumber_name = new map<String, String>();
                
            for(Account a : [Select Name, AccountNumber From Account where AccountNumber in: map_soldtoid_soldto.keySet()]){
                map_accnumber_name.put(a.AccountNumber, a.Name);
            }
            */
            map<String, CSD_ClsEntityType.PartObj> map_SoldTo_result = new map<String, CSD_ClsEntityType.PartObj>();
            if(map_soldtoid_soldto.size() > 0) {
                CSD_ClsUtils.hasCFTForecastForSamsung(searchOb.oemId, searchOb.partId, map_soldtoid_soldto.keySet(), fiscaldate, enddate, set_hascftsoldtoid);
                
                for(AggregateResult result : map_soldtoid_soldto.values()) {
                    CSD_ClsEntityType.PartObj partObj = new CSD_ClsEntityType.PartObj();
                    CSD_ClsUtils.createPartObj(partObj, searchOb.map_year_monthsFuture);
                    Blob aes = Crypto.generateAesKey(128);
                    String hex = EncodingUtil.convertToHex(aes);
                    partObj.id = hex;
                    partObj.accnumber = (String)result.get('soldto');
                    partObj.snumber = (String)result.get('soldto');
                    partObj.name = (String)result.get('accname');
                    partObj.gplfamily = searchOb.gplfamily;
                    if(searchOb.isExpansionSoldto != null && searchOb.isExpansionSoldto) {
                        partObj.type= 'NonPart';
                    }
                    partObj.hasCFTFC = (set_hascftsoldtoid.contains(partObj.accnumber) ? true : false);
                    //false;
                    //if(set_hascftsoldtoid.contains(accnumber)) {
                    //  partObj.hasCFTFC = true;
                    //}
                    //list_soldTos.add(partObj);
                    map_SoldTo_result.put(partObj.accnumber, partObj);
                }
            }
            
            //Date currentdate = Date.valueOf(searchOb.startDate);
            //Date enddate = Date.valueOf(searchOb.endDate);
            
            set<String> set_accnumbers = map_SoldTo_result.keySet();
            list_sql.clear();
            list_sql.add('Sold_To_Number__c soldto, Fiscal_Year__c year, Fiscal_Month__c month, '
                        + ' max(Quantity__c) quantity, sum(Forecast__c) sumFC, max(Price__c) price, '
                        + ' sum(DC_Forecast_Amount__c) sumDCFC, sum(Previous_Month_Forecast__c) sumPMFC');
            list_sql.add(' CSD_Sales_Forecast__c ');
            list_sql.add(' WHERE OEM__c = \'' + searchOb.oemId + '\' ' 
                    + ' And Part__c = \'' + searchOb.partId + '\' '
                    + ' And GPL_Family__c = \''+searchOb.gplfamily+'\' '
                    + ' And Type__c = \'Sold-To\' '
                    + ' And Samsung_Type__c = null '
                    + ' And Sold_To_Number__c IN :set_accnumbers '
                    + ' And Fiscal_Date__c >= : fiscaldate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Sold_To_Number__c, Fiscal_Year__c, Fiscal_Month__c ');
            
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                //system.debug('@#result : '+result);
                String accId = (String)result.get('soldto'), 
                       year = (String)result.get('year'),
                       month = (String)result.get('month'), 
                       dateKey = (year + '_' + month);

                if(!map_SoldTo_result.containsKey(accId)) {
                    continue;
                }else {

                    CSD_ClsEntityType.AccountValueobj valueobj = new CSD_ClsEntityType.AccountValueobj();
                        
                    valueobj.forecast = (decimal)result.get('sumFC');
                    valueobj.price = (decimal)result.get('price');
                    valueobj.quantity = (decimal)result.get('quantity');
                    
                    map_SoldTo_result.get(accId).csFC.put(dateKey, valueobj);
                    map_SoldTo_result.get(accId).dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
                    map_SoldTo_result.get(accId).pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
                    
                }
            }
            
            system.debug('@#map_SoldTo_result.values:' + map_SoldTo_result.values());
            
            return JSON.serialize(map_SoldTo_result.values());
        }
        
        
        public String getSearchResultByNonPart(String sData){
            
            CSD_ClsEntityType.SearchObjExpand searchOb = (CSD_ClsEntityType.SearchObjExpand)JSON.deserialize(sData, CSD_ClsEntityType.SearchObjExpand.class);
            system.debug('@#searchOb:'+searchOb);
            map<String, set<String>> map_Soldto_part = new map<String, set<String>>();

            String searchNameOrNumber = '%'+searchOb.searchKey+'%';
            
            Date fiscaldate = Date.valueOf(searchOb.startDate);
            Date enddate = Date.valueOf(searchOb.endDate);

            String useremail = '%null%';
            for(User user : [select Email from User where Id = :CSD_ClsUtils.getManageUserId(searchOb.managerId)]) {
                useremail = '%' + user.Email + '%';
            }
    
            for(CSD_Samsung_Mapping__c sm : [select GPL_Family__c, GPL_Code__c, Category__c, Part__c
                                            from CSD_Samsung_Mapping__c 
                                            where Sales_Email__c like :useremail 
                                                AND (Category__c like :searchNameOrNumber or Sold_to_Name__c like :searchNameOrNumber)
                                                AND GPL_Family__c = :searchOb.gplfamily  ]) {
                if(map_Soldto_part.containsKey(sm.Category__c)) {
                    map_Soldto_part.get(sm.Category__c).add(sm.Part__c);
                }else {
                    set<String> set_parts = new set<String>();
                    set_parts.add(sm.Part__c);
                    map_Soldto_part.put(sm.Category__c, set_parts);
                }
            }
            
            list<String> list_sql = new list<String>();
            
            if(searchOb.set_selectedPartIds == null) {
                searchOb.set_selectedPartIds = new set<string>();
            }
            if(searchOb.set_deletedPartIds == null){
                searchOb.set_deletedPartIds = new set<string>();
            }
            if(searchOb.set_selectdsoldtonumbers == null) {
                searchOb.set_selectdsoldtonumbers = new set<string>();
            }   
            if(searchOb.set_deletedsoldtonumbers == null) {
                searchOb.set_deletedsoldtonumbers = new set<string>();
            }
            if(searchOb.set_deletedgplcodes == null) {
                searchOb.set_deletedgplcodes = new set<string>();
            }
            
            set<String> deletedpart = searchOb.set_deletedPartIds;
            set<String> deletedgplcode = searchOb.set_deletedgplcodes;
            
            
            list_sql.add(' Part__c part , GPL_Code__c gplcode');
            list_sql.add(' CSD_Sales_Forecast__c ');
            list_sql.add(' WHERE Type__c = \'Sold-To\' '
                    + ' And (Samsung_Type__c = null or Samsung_Type__c = \'Non SoldTo\') '
                    + ' AND OEM__c = \'' + searchOb.oemId + '\' '
                    + ' And GPL_Family__c = \'' + searchOb.gplfamily + '\' '
                    + ' And Fiscal_Date__c >= : fiscaldate '
                    + ' And Fiscal_Date__c < : enddate '
                    + (deletedpart.size() > 0 ? ' And Part__c not IN :deletedpart ' : '')
                    + (deletedgplcode.size() > 0 ? ' And GPL_Code__c not IN :deletedgplcode ' : '' )
                    + ' Group by Part__c, GPL_Code__c');
            
            system.debug('@#searchOb.set_selectedPartIds:' + searchOb.set_selectedPartIds);
            system.debug('@#searchOb.set_deletedgplcodes:' + searchOb.set_selectedPartIds);
            system.debug('@#searchOb.set_deletedPartIds:' + searchOb.set_selectedPartIds);
            
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                
                if(!searchOb.set_selectedPartIds.contains((String)result.get('part')) ) {
                    //if(!searchOb.set_deletedgplcodes.contains((String)result.get('gplcode')) || !searchOb.set_deletedPartIds.contains((String)result.get('part'))) {
                    //  continue;
                    //}
                    searchOb.set_selectedPartIds.add((String)result.get('part'));
                }
            }
            system.debug('@#searchOb.set_selectedPartIds:' + searchOb.set_selectedPartIds);
            list<CSD_ClsEntityType.AccountObj> list_soldTos = new list<CSD_ClsEntityType.AccountObj>();
            
            set<String> haspartsoldto = new set<String>();
            for(String soldto : map_Soldto_part.keySet()) {
                
                if(searchOb.set_selectdsoldtonumbers.contains(soldto)) {
                    continue;
                }
                
                Boolean hasotherpart = false;
                for(String part : map_Soldto_part.get(soldto)) {
                    if(!searchOb.set_selectedPartIds.contains(part)) {
                        hasotherpart = true;
                    }
                }
                if(hasotherpart){
                    haspartsoldto.add(soldto);
                }
            }
            
            if(haspartsoldto.size() > 0) {
                /*set<String> set_hascftsoldtoid = new set<String>();
                CSD_ClsUtils.hasCFTForecastForSamsung(searchOb.oemId, '', haspartsoldto, fiscaldate, enddate, set_hascftsoldtoid);
                */
                map<String, String> map_accnumber_name = new map<String, String>();
                for(Account a : [Select Name, AccountNumber From Account where AccountNumber in: haspartsoldto]){
                    map_accnumber_name.put(a.AccountNumber, a.Name);
                }
                
                for(String soldto : haspartsoldto) {
                    CSD_ClsEntityType.AccountObj partObj = new CSD_ClsEntityType.AccountObj();
                    CSD_ClsUtils.createAccountObj(partObj, searchOb.map_year_monthsFuture);
                    Blob aes = Crypto.generateAesKey(128);
                    String hex = EncodingUtil.convertToHex(aes);
                    partObj.id = hex;
                    partObj.accnumber = soldto;
                    partObj.snumber = soldto;
                    partObj.name = (map_accnumber_name.containsKey(soldto) ? map_accnumber_name.get(soldto) : '');
                    partObj.gplfamily = searchOb.gplfamily;
                    partObj.type= 'NonPart';
                    //partObj.hasCFTFC = (set_hascftsoldtoid.contains(soldto) ? true : false);
                    
                    list_soldTos.add(partObj);
                }
            }
            

            return JSON.serialize(list_soldTos);
        }
        
        /**
         *  This function is get value of level3 
         *  
         * @author Lei Tang
         * @created 2014-11-18
         * @version 1.0
         * @since 30.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-11-18 Lei Tang <lei.tang@itbconsult.com>
         * - Created
         *
        */
        public override String getExistResult(String sData){
            
            CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData, CSD_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb'+searchOb);
            
            Date currentdate = Date.valueOf(searchOb.startDate);
            Date enddate = Date.valueOf(searchOb.endDate);
            
            set<String> set_SoldTos = new set<String>();

            String useremail = '%null%';
            for(User user : [select Email from User where Id = :CSD_ClsUtils.getManageUserId(searchOb.managerId)]) {
                useremail = '%' + user.Email + '%';
            }
    
            for(CSD_Samsung_Mapping__c sm : [select GPL_Family__c, GPL_Code__c, Category__c, Part__c 
                                            from CSD_Samsung_Mapping__c 
                                            where Sales_Email__c like :useremail 
                                                AND GPL_Family__c = :searchOb.gplfamily 
                                                And Part__c = :searchOb.partId ]) {
                set_SoldTos.add(sm.Category__c);
            }
            
            
            list<String> list_sql = new list<String>();
            
            list_sql.add('Sold_To_Number__c soldto, Sold_To_Name__c name, Fiscal_Year__c year, Fiscal_Month__c month, '
                        + ' max(Quantity__c) quantity, sum(Forecast__c) sumFC, max(Price__c) price, '
                        + ' sum(DC_Forecast_Amount__c) sumDCFC, sum(Previous_Month_Forecast__c) sumPMFC');
            list_sql.add(' CSD_Sales_Forecast__c ');
            list_sql.add(' WHERE OEM__c = \'' + searchOb.oemId + '\' ' 
                    + ' And Part__c = \'' + searchOb.partId + '\' '
                    + ' And GPL_Family__c = \''+searchOb.gplfamily+'\' '
                    + ' And Type__c = \'Sold-To\' '
                    + ' And Sold_To_Number__c IN :set_SoldTos '
                    + ((searchOb.viewMode != null && searchOb.viewMode == 'view') ? ' ' : ' And Samsung_Type__c = null ')
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Sold_To_Number__c, Sold_To_Name__c, Fiscal_Year__c, Fiscal_Month__c order by Sold_To_Number__c ');
            
            map<String, CSD_ClsEntityType.PartObj> map_acctId_acctFC = new map<String, CSD_ClsEntityType.PartObj>();
            map<String, String> map_accid_name = new map<String, String>();
            map<String, AggregateResult> map_soldtoid_soldto = new map<String, AggregateResult>();
            map<String, map<String, AggregateResult>> map_soldtoid_map_dateKey_result =
                new map<String, map<String, AggregateResult>>();
                
            set<String> set_hascftsoldtoid = new set<String>();
            
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                
                String accId = (String)result.get('soldto'), 
                       year = (String)result.get('year'),
                       month = (String)result.get('month'), 
                       dateKey = (year + '_' + month);
                map_accid_name.put(accId, (String)result.get('name'));
                CSD_ClsUtils.setResultMap(result, accId, dateKey, map_soldtoid_map_dateKey_result);   
                
                //map_soldtoid_soldto.put((String)result.get('soldto'), result);
            }
            system.debug('@#map_accid_name:'+map_accid_name);
            if(map_soldtoid_map_dateKey_result.size() > 0) {
                CSD_ClsUtils.hasCFTForecastForSamsung(searchOb.oemId, searchOb.partId, map_soldtoid_map_dateKey_result.keySet(), currentdate, enddate, set_hascftsoldtoid);
                
                for(String acctId : map_soldtoid_map_dateKey_result.keySet()) {
                    
                    CSD_ClsEntityType.PartObj acctFC = new CSD_ClsEntityType.PartObj();
            
                    if(!map_acctId_acctFC.containsKey(acctId)) {
                        CSD_ClsUtils.createPartObj(acctFC, searchOb.map_year_monthsFuture);
                        Blob aes = Crypto.generateAesKey(128);
                        String hex = EncodingUtil.convertToHex(aes);
                        acctFC.id = hex;
                        acctFC.accnumber = acctId;
                        acctFC.name = map_accid_name.containsKey(acctId) ? map_accid_name.get(acctId) : '';
                        acctFC.hasCFTFC = (set_hascftsoldtoid.contains(acctId) ? true : false);

                        map_acctId_acctFC.put(acctId, acctFC);
                    }else {
                        acctFC = map_acctId_acctFC.get(acctId);
                    }
                    
                    for(AggregateResult result : map_soldtoid_map_dateKey_result.get(acctId).values()) {
                        //system.debug('@#result : '+result);
                        String accId = (String)result.get('soldto'), 
                               year = (String)result.get('year'),
                               month = (String)result.get('month'), 
                               dateKey = (year + '_' + month);
                        
                        CSD_ClsEntityType.AccountValueobj valueobj = new CSD_ClsEntityType.AccountValueobj();
                        
                        valueobj.forecast = (decimal)result.get('sumFC');
                        valueobj.price = (decimal)result.get('price');
                        valueobj.quantity = (decimal)result.get('quantity');
                        
                        acctFC.csFC.put(dateKey, valueobj);
                        acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
                        acctFC.pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
                    }
                }
            }
            
            
            return Json.serialize(map_acctId_acctFC.values());
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
                
                set<String> set_Parts = new set<String>();
                
                if(searchOb.isExpansionSoldto != null && searchOb.isExpansionSoldto) {
                    String useremail = '%null%';
                    for(User user : [select Email from User where Id = :CSD_ClsUtils.getManageUserId(searchOb.managerId)]) {
                        useremail = '%' + user.Email + '%';
                    }
                    for(CSD_Samsung_Mapping__c sm : [select GPL_Family__c, GPL_Code__c, Category__c, Part__c 
                                                    from CSD_Samsung_Mapping__c 
                                                    where Sales_Email__c like :useremail 
                                                        AND GPL_Family__c = :searchOb.gplfamily
                                                        AND Category__c = :searchOb.accnumber]) {
                        if(!set_Parts.contains(sm.Part__c)) {
                            set_Parts.add(sm.Part__c);
                        }
                    }
                }else {
                    set_Parts.add(searchOb.partId);
                }

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
                                                                    and Monthly_Billings_Bookings_by_Part__r.Part__c IN :set_Parts
                                                                    and OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
                        set_monthIds.add(csdmap.Monthly_Billings_Bookings_by_Part__c);
                    }

                    list<String> list_beforesql = new list<String>();
                    list_beforesql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                    list_beforesql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_beforesql.add(' WHERE Id IN :set_monthids '
                            + ' Group by Fiscal_Date__c ');
                    CSD_ClsUtils.setGAMOEMMapRefData(searchOb.accnumber, set_monthIds, list_beforesql, map_acctId_map_dateKey_result_before);
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
                system.debug('@#searchOb:'+searchOb);
                
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                CSD_ClsUtils.setRefDatelist(list_beforedate, list_futruedate, searchOb.set_fiscalMonth);
                
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();
                
                set<String> set_Parts = new set<String>();
                
                if(searchOb.isExpansionSoldto != null && searchOb.isExpansionSoldto) {
                    String useremail = '%null%';
                    for(User user : [select Email from User where Id = :CSD_ClsUtils.getManageUserId(searchOb.managerId)]) {
                        useremail = '%' + user.Email + '%';
                    }
                    for(CSD_Samsung_Mapping__c sm : [select GPL_Family__c, GPL_Code__c, Category__c, Part__c 
                                                    from CSD_Samsung_Mapping__c 
                                                    where Sales_Email__c like :useremail 
                                                        AND GPL_Family__c = :searchOb.gplfamily
                                                        AND Category__c = :searchOb.accnumber]) {
                        if(!set_Parts.contains(sm.Part__c)) {
                            set_Parts.add(sm.Part__c);
                        }
                    }
                }else {
                    set_Parts.add(searchOb.partId);
                }
                
                if(list_futruedate.size() > 0) {
                    //futrue
                    //  Updata the  Mingxing Qiu time is  2016-04-08 
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
                                                                    and Daily_Booking_Billing_Backlog_By_Part__r.Part__c IN :set_Parts
                                                                    and CSD_OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
                        set_dailyIds.add(csdmap.Daily_Booking_Billing_Backlog_By_Part__c);
                    }

                    list<String> list_futruesql = new list<String>();
                    list_futruesql.add(' sum(Backlog_Amount_USD__c) amount, Fiscal_Date__c refdate');
                    list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c    ');
                    list_futruesql.add(' WHERE Id IN :set_monthids '
                        + ' Group by Fiscal_Date__c ');      
                       
                    CSD_ClsUtils.setGAMOEMMapRefData(searchOb.accnumber, set_dailyIds, list_futruesql, map_acctId_map_dateKey_result_futrue);
                
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
                                                                    and Daily_Booking_Billing_Backlog_By_Part__r.Part__c IN :set_Parts
                                                                    and CSD_OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
                            set_dailyIds.add(csdmap.Daily_Booking_Billing_Backlog_By_Part__c);
                        }

                        list<String> list_futruesql = new list<String>();
                        list_futruesql.add(' sum(Backlog_Amount_USD__c) amount ');
                        list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c    ');
                        list_futruesql.add(' WHERE Id IN :set_monthids ');  
                        CSD_ClsUtils.setGAMOEMMapRefDataBacklog(currentdate, searchOb.accnumber, set_dailyIds, list_futruesql, map_acctId_map_dateKey_result_futrue);

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
                
                set<String> set_GPLFamilys = new set<String>();
                set<String> set_GPLCodes = new set<String>();
                set<String> set_SoldTos = new set<String>();
                set<String> set_Parts = new set<String>();
                
                CSD_ClsUtils.getSamsungGPLFamilyByUser(CSD_ClsUtils.getManageUserId(searchOb.managerId), '', '', set_GPLFamilys, set_GPLCodes, set_SoldTos, set_Parts);
        
                
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
                                                                        and Monthly_Billings_Bookings_by_Part__r.Customer__r.AccountNumber IN :set_SoldTos
                                                                        and Monthly_Billings_Bookings_by_Part__r.Customer__r.STATDESC__c = 'Active'
                                                                        and Monthly_Billings_Bookings_by_Part__r.Part__c IN :set_Parts
                                                                        and OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
                        set_monthIds.add(csdmap.Monthly_Billings_Bookings_by_Part__c);
                    }

                    list<String> list_beforesql = new list<String>();
                    list_beforesql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                    list_beforesql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_beforesql.add(' WHERE Id IN :set_perm '
                            + ' Group by Fiscal_Date__c ');
                    CSD_ClsUtils.setTotelBillingData(years, months, set_monthIds, list_beforesql, map_acctId_map_dateKey_result_before);
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

}