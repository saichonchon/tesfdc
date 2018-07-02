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
 *
 * @changelog
 * 2016-04-08 Mingxing <Qiumingxing.qiu@oinio.com>
 * - Created
 *
*/
public without sharing class CSD_ClsSamsungViewService extends CSD_Interface.ACSDCtrlService {
    
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
        
        CSD_ClsUtils.getSamsungGPLFamilyByManage('', '', set_GPLFamilys, set_GPLCodes, set_SoldTos, set_Parts);
        
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
        
        system.debug('@#list_sql:'+CSD_ClsUtils.getQueryString(list_sql));
        system.debug('@#currentdate:'+currentdate);
        system.debug('@#enddate:'+enddate);
        
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
                
                set<String> set_GPLFamilys = new set<String>();
                set<String> set_GPLCodes = new set<String>();
                set<String> set_SoldTos = new set<String>();
                set<String> set_Parts = new set<String>();
                CSD_ClsUtils.getSamsungGPLFamilyByManage('', '', set_GPLFamilys, set_GPLCodes, set_SoldTos, set_Parts);

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
                system.debug('@#map_acctId_map_dateKey_result_before:'+map_acctId_map_dateKey_result_before);
                system.debug('@#refdata:'+Json.serialize(refdata));
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
                CSD_ClsUtils.getSamsungGPLFamilyByManage('', '', set_GPLFamilys, set_GPLCodes, set_SoldTos, set_Parts);
                
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
                        list_futruesql.add(' sum(Backlog_Amount_USD__c) amount  ');
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
            
            CSD_ClsUtils.getSamsungGPLFamilyByManage(searchOb.gplfamily, '', set_GPLFamilys, set_GPLCodes, set_SoldTos, set_Parts);
            
            
            if(searchOb.viewMode != null && searchOb.viewMode == 'view' ) {
                if(searchOb.isOtherMethod != null && searchOb.isOtherMethod) {
                    return getExistResultBySoldToView(sData, set_Parts, set_SoldTos);
                }else {
                    return getExistResultByGPLCodeView(sData, set_Parts, set_SoldTos);
                }
            }
                
            Date currentdate = Date.valueOf(searchOb.startDate);
            Date enddate = Date.valueOf(searchOb.endDate);
            
            list<String> list_sql = new list<String>();
            
            list_sql.add(' GPL_Code__c gplcode, Fiscal_Year__c year, Fiscal_Month__c month, Part__r.Product_Hierarchy__r.GPL_Description__c gpldescr, '
                        + ' max(Quantity__c) quantity, sum(Forecast__c) sumFC, max(Price__c) price, '
                        + ' sum(DC_Forecast_Amount__c) sumDCFC, sum(Previous_Month_Forecast__c) sumPMFC ');
            list_sql.add(' CSD_Sales_Forecast__c ');
            list_sql.add(' WHERE OEM__c = \'' + searchOb.oemId + '\' ' 
                    + ' And Part__c IN :set_Parts '
                    + ' And Sold_To_Number__c = null '
                    + ' And Type__c = \'Sold-To\' '
                    + ' And (Samsung_Type__c = null or Samsung_Type__c = \'Non SoldTo\') '
                    + ' And GPL_Family__c = \'' + searchOb.gplfamily + '\''
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, GPL_Code__c, Part__r.Product_Hierarchy__r.GPL_Description__c ');
            
            map<String, CSD_ClsEntityType.AccountObj> map_acctId_acctFC = new map<String, CSD_ClsEntityType.AccountObj>();
            system.debug('@#SOQL = '+CSD_ClsUtils.getQueryString(list_sql));
            system.debug('@#set_Parts = '+set_Parts);
            system.debug('@#searchOb.gplfamily = '+CSD_ClsUtils.getQueryString(list_sql));
            system.debug('@#currentdate = '+currentdate);
            system.debug('@#enddate = '+ enddate);
            
            
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
        private String getExistResultByGPLCodeView(String sData, set<String> set_Parts, set<String> set_SoldTos){
            
            CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData, CSD_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb'+searchOb);
            
            Date currentdate = Date.valueOf(searchOb.startDate);
            Date enddate = Date.valueOf(searchOb.endDate);

            list<String> list_sql = new list<String>();
            
            list_sql.add(' GPL_Code__c gplcode, Fiscal_Year__c year, Fiscal_Month__c month, Part__r.Product_Hierarchy__r.GPL_Description__c gpldescr, '
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
                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, GPL_Code__c, Part__r.Product_Hierarchy__r.GPL_Description__c  ');
            
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
                    acctFC.accnumber = (result.get('gpldescr') == null ? '' :(String)result.get('gpldescr'));
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
        private String getExistResultBySoldToView(String sData, set<String> set_Parts, set<String> set_SoldTos){
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
                
                set<String> set_GPLFamilys = new set<String>();
                set<String> set_GPLCodes = new set<String>();
                set<String> set_SoldTos = new set<String>();
                set<String> set_Parts = new set<String>();
                CSD_ClsUtils.getSamsungGPLFamilyByManage(searchOb.gplfamily, searchOb.gplcode, 
                                                        set_GPLFamilys, set_GPLCodes, set_SoldTos, set_Parts);
               
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
                
                set<String> set_GPLFamilys = new set<String>();
                set<String> set_GPLCodes = new set<String>();
                set<String> set_SoldTos = new set<String>();
                set<String> set_Parts = new set<String>();
                CSD_ClsUtils.getSamsungGPLFamilyByManage(searchOb.gplfamily, '', 
                                                        set_GPLFamilys, set_GPLCodes, set_SoldTos, set_Parts);
               
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
                CSD_ClsUtils.getSamsungGPLFamilyByManage(searchOb.gplfamily, searchOb.gplcode, 
                                                        set_GPLFamilys, set_GPLCodes, set_SoldTos, set_Parts);
                
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
                        list_futruesql.add(' sum(Backlog_Amount_USD__c) amount  ');
                        list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c    ');
                        list_futruesql.add(' WHERE Id IN :set_monthids ');    
                           
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
                CSD_ClsUtils.getSamsungGPLFamilyByManage(searchOb.gplfamily, '', 
                                                        set_GPLFamilys, set_GPLCodes, set_SoldTos, set_Parts);
                                                        
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
            
            CSD_ClsUtils.getSamsungGPLFamilyByManage(searchOb.gplfamily, searchOb.gplcode, set_GPLFamilys, set_GPLCodes, set_SoldTos, set_Parts);

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
        private String getExistResultBySoldToView(String sData, set<String> set_Parts){
            
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
                
                for(User user : [select Email from User where Id = :UserInfo.getUserId()]) {
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
        private String getOtherRefData(String sData) { 
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

                set<String> set_SoldTos = new set<String>();
                String useremail = '%null%';
                
                for(User user : [select Email from User where Id = :UserInfo.getUserId()]) {
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
                    // Updata the  Mingxing Qiu time is  2016-04-08
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
                        list_futruesql.add(' sum(Backlog_Amount_USD__c) amount  ');
                        list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c    ');
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
    
            for(CSD_Samsung_Mapping__c sm : [select GPL_Family__c, GPL_Code__c, Category__c, Part__c 
                                            from CSD_Samsung_Mapping__c 
                                            where GPL_Family__c = :searchOb.gplfamily 
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

                    for(CSD_Samsung_Mapping__c sm : [select GPL_Family__c, GPL_Code__c, Category__c, Part__c 
                                                    from CSD_Samsung_Mapping__c 
                                                    where GPL_Family__c = :searchOb.gplfamily
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

                    for(CSD_Samsung_Mapping__c sm : [select GPL_Family__c, GPL_Code__c, Category__c, Part__c 
                                                    from CSD_Samsung_Mapping__c 
                                                    where GPL_Family__c = :searchOb.gplfamily
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
                
                CSD_ClsUtils.getSamsungGPLFamilyByManage('', '', set_GPLFamilys, set_GPLCodes, set_SoldTos, set_Parts);
                
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