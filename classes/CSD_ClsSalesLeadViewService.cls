/**
 *  This class is CSD Sales Leader View Service.
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
public without sharing class CSD_ClsSalesLeadViewService extends CSD_Interface.ACSDCtrlService {

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
        /*
        CSD_ClsEntityType.AccountObj totalFC = new CSD_ClsEntityType.AccountObj();
        CSD_ClsUtils.createAccountObj(totalFC, pageconf.map_financialMonth);
        String hexid = CSD_ClsUtils.getHexUID();
        totalFC.id = hexid;
        totalFC.accnumber = 'Total';
        totalFC.name = 'Total';
        totalFC.type = 'total';
        list_data.add(totalFC);
        */
        set<String> set_regions = new set<String>();
         for(CSD_Forecast_Management__c acc : [Select Id, Region__c from CSD_Forecast_Management__c where Role__c = 'Sales Leader' and Region__c != null And User__c = :UserInfo.getUserId() ]) {
         //if(acc.Region__c != null) {
            list<String> accregions = acc.Region__c.split(';'); 
            for(String region : accregions) {
              if(!set_regions.contains(region)) {
                set_regions.add(region);
              }
            }
          //}
        }
        pageconf.set_regions = set_regions;
        
        system.debug('@#set_regions:'+set_regions);
        list<String> list_sql = new list<String>();

        //string stringDate = pageconf.currentYear + '-' + String.valueOf(pageconf.currentMonth) + '-1';
        Date currentdate = Date.valueOf(pageconf.refStartDate);
        Date enddate = Date.valueOf(pageconf.refEndDate);
        String typename = 'OEM';
        //list_sql.add(' Billing_Region__c region, Fiscal_Year__c year, Fiscal_Month__c month, '
        list_sql.add( ((pageconf.viewMode == '' || pageconf.viewMode == 'billingRegion') ? ' Billing_Region__c' : ' OEM__r.Design_In_Region__c' ) + ' region, ' 
                + ' Fiscal_Year__c year, Fiscal_Month__c month, '
                + 'sum(DC_Forecast_Amount__c) sumDCFC, sum(Forecast__c) sumFC, sum(Previous_Month_Forecast__c) sumPMFC');
        list_sql.add(' CSD_Sales_Forecast__c ');
        list_sql.add(' WHERE Type__c IN (\'OEM\',\'Non-OEMs\') '
                    + ' And ' + ((pageconf.viewMode == '' || pageconf.viewMode == 'billingRegion') ? ' Billing_Region__c ' : ' OEM__r.Design_In_Region__c ' )  + ' IN : set_regions ' 
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, '
                    + ((pageconf.viewMode == '' || pageconf.viewMode == 'billingRegion') ? ' Billing_Region__c ' : ' OEM__r.Design_In_Region__c ' ) );
        //system.debug('@#list_sql : '+list_sql);
        map<String, CSD_ClsEntityType.AccountObj> map_acctId_acctFC = new map<String, CSD_ClsEntityType.AccountObj>();
        
        //map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result =
        //    new map<String, map<String, AggregateResult>>();


        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
            
            String accId = ((String)result.get('region')).toUpperCase(), 
                   year = (String) result.get('year'),
                   month = (String) result.get('month'), 
                   dateKey = (year + '_' + month);
                   
            CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
            
            if(!map_acctId_acctFC.containsKey(accId)) {
                CSD_ClsUtils.createAccountObj(acctFC, pageconf.map_financialMonth);
                Blob aes = Crypto.generateAesKey(128);
                String hex = EncodingUtil.convertToHex(aes);
                acctFC.id = hex;
                acctFC.name = accId;

                map_acctId_acctFC.put(accId, acctFC);
            }else {
                acctFC = map_acctId_acctFC.get(accId);
            }

            acctFC.csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
            acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
            acctFC.pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
            
            map_acctId_acctFC.put(accId, acctFC);            
        }
        
        /*list<CSD_ClsEntityType.AccountObj> list_accFc = new list<CSD_ClsEntityType.AccountObj>();
        list_accFc.addAll(map_acctId_acctFC.values());
        list_accFc.sort();
        system.debug('@#list_accFc:'+list_accFc);
        */
        /*if(pageconf.viewMode == '' || pageconf.viewMode == 'billingRegion') {
            if(set_regions.contains('TAIWAN')) {
                list<String> list_taiwansql = new list<String>();
                        
                list_taiwansql.add(' OEM__c oem, Sold_To_Number__c soldto ');
                list_taiwansql.add(' CSD_Sales_Forecast__c ');
                list_taiwansql.add(' WHERE Type__c = :typename '
                            + ' And Billing_Region__c = \'TAIWAN\' ' 
                            + ' And Fiscal_Date__c >= : currentdate '
                            + ' And Fiscal_Date__c < : enddate '
                            + ' Group by OEM__c, Sold_To_Number__c ');
                set<String> set_taiwanoems = new set<String>();
                set<String> set_taiwansoldtos = new set<String>();
                for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_taiwansql))) {
                    set_taiwanoems.add((String)result.get('oem'));
                    set_taiwansoldtos.add((String)result.get('soldto'));
                }
                
                system.debug('@#set_taiwanoems:'+set_taiwanoems);
                system.debug('@#set_taiwansoldtos:'+set_taiwansoldtos);
                
                typename = 'Part';
                list_sql.clear();
                list_sql.add(' Billing_Region__c region, ' 
                        + ' Fiscal_Year__c year, Fiscal_Month__c month, '
                        + 'sum(DC_Forecast_Amount__c) sumDCFC, sum(Forecast__c) sumFC, sum(Previous_Month_Forecast__c) sumPMFC');
                list_sql.add(' CSD_Sales_Forecast__c ');
                list_sql.add(' WHERE Type__c = :typename '
                            + ' And Billing_Region__c = \'TAIWAN\' ' 
                            + ' And Fiscal_Date__c >= : currentdate '
                            + ' And Fiscal_Date__c < : enddate '
                            + ' And Sold_To_Number__c NOT IN : set_taiwansoldtos '
                            + ' And OEM__c NOT IN : set_taiwanoems '
                            + ' Group by Fiscal_Year__c, Fiscal_Month__c, '
                            + ' Billing_Region__c ');
                CSD_ClsEntityType.AccountObj acctFC = null;
                system.debug('@#list_sql:'+CSD_ClsUtils.getQueryString(list_sql));
                for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                    if(map_acctId_acctFC.containsKey('TAIWAN')) {
                        acctFC = map_acctId_acctFC.get('TAIWAN');
                    }else {
                        acctFC = new CSD_ClsEntityType.AccountObj();
                        CSD_ClsUtils.createAccountObj(acctFC, pageconf.map_financialMonth);
                        Blob aes = Crypto.generateAesKey(128);
                        String hex = EncodingUtil.convertToHex(aes);
                        acctFC.id = hex;
                        acctFC.name = 'TAIWAN';
                        map_acctId_acctFC.put('TAIWAN', acctFC);
                    }
                    
                    String accId = ((String)result.get('region')).toUpperCase(), 
                           year = (String) result.get('year'),
                           month = (String) result.get('month'), 
                           dateKey = (year + '_' + month);

                    map_acctId_acctFC.get(accId).csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') + acctFC.csFC.get(dateKey) : acctFC.csFC.get(dateKey)));
                    map_acctId_acctFC.get(accId).dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') + acctFC.dcFC.get(dateKey) : acctFC.dcFC.get(dateKey)));
                    map_acctId_acctFC.get(accId).pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') + acctFC.pmFC.get(dateKey) : acctFC.pmFC.get(dateKey)));
                }
            }
        }*/
        setChannelForecastLevel1(pageconf, map_acctId_acctFC);
        list<CSD_ClsEntityType.AccountObj> list_accFc = new list<CSD_ClsEntityType.AccountObj>();
        if(map_acctId_acctFC.size() > 0) {
            list_accFc.addAll(map_acctId_acctFC.values());
            list_accFc.sort();
            
            CSD_ClsEntityType.AccountObj total=new CSD_ClsEntityType.AccountObj();
            total.id = CSD_ClsUtils.getHexUID();
            total.name = 'Total';
            total.type = 'total';
            list_data.add(total);
            
            for(Integer i = 0; i < list_accFc.size(); i++) {
                list_data.add(list_accFc.get(i));
            }
        }
        system.debug('@#list_data:'+list_data);
    }
    
    
    public override String setChannelForecast(Object config){
        CSD_ClsEntityType.PageConfig pageconf = (CSD_ClsEntityType.PageConfig)config;

        //list<Object> list_data = new list<Object>();
        
        map<String, Object> map_oems = new map<String, Object>();
        
        CSD_ClsEntityType.AccountObj total=new CSD_ClsEntityType.AccountObj();
        total.id = CSD_ClsUtils.getHexUID();
        total.name = 'Total';
        total.type = 'total';
        map_oems.put('total', total);
        /*CSD_ClsEntityType.AccountObj nonchannel=new CSD_ClsEntityType.AccountObj();
        nonchannel.id = CSD_ClsUtils.getHexUID();
        nonchannel.name = 'Non - Channel';
        nonchannel.type = 'nontotalchannel';
        
        CSD_ClsEntityType.AccountObj channel=new CSD_ClsEntityType.AccountObj();
        channel.id = CSD_ClsUtils.getHexUID();
        channel.name = 'Channel';
        channel.type = 'totalchannel';
         
        
        map_oems.put('nontotalchannel', nonchannel);
        map_oems.put('totalchannel', channel);
        */
        map<String, CSD_ClsEntityType.AccountObj> map_acctId_acctFC = new map<String, CSD_ClsEntityType.AccountObj>();
        
        //setChannelForecastLevel1(pageconf, map_acctId_acctFC);
        map_oems.put('channel', map_acctId_acctFC.values());
        
        return Json.serialize(map_oems);
    }
    
    public void setChannelForecastLevel1(CSD_ClsEntityType.PageConfig pageconf, 
                                        map<String, CSD_ClsEntityType.AccountObj> map_acctId_acctFC){
        set<String> set_regions = pageconf.set_regions;
        Date currentdate = Date.valueOf(pageconf.refStartDate);
        Date enddate = Date.valueOf(pageconf.refEndDate);
                                            
        list<String> list_sql = new list<String>();
        list_sql.add(((pageconf.viewMode == '' || pageconf.viewMode == 'billingRegion') ? ' Billing_Region__c' : ' OEM__r.Design_In_Region__c' ) 
                    + ' region, Fiscal_Year__c year, Fiscal_Month__c month, sum(Forecast__c) sumFC ');
        list_sql.add(' CSD_Channel_Forecast__c ');
        list_sql.add(' WHERE ' + ((pageconf.viewMode == '' || pageconf.viewMode == 'billingRegion') ? ' Billing_Region__c ' : ' OEM__r.Design_In_Region__c ' )  + ' IN : set_regions ' 
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, '
                    + ((pageconf.viewMode == '' || pageconf.viewMode == 'billingRegion') ? ' Billing_Region__c ' : ' OEM__r.Design_In_Region__c ' ) );
        
        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
            String accId = ((String)result.get('region')).toUpperCase(), 
                   year = (String) result.get('year'),
                   month = (String) result.get('month'), 
                   dateKey = (year + '_' + month);
                   
            CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
            
            if(!map_acctId_acctFC.containsKey(accId)) {
                CSD_ClsUtils.createAccountObj(acctFC, pageconf.map_financialMonth);
                Blob aes = Crypto.generateAesKey(128);
                String hex = EncodingUtil.convertToHex(aes);
                acctFC.id = hex;
                acctFC.name = accId;
                //acctFC.type = 'channel';
                map_acctId_acctFC.put(accId, acctFC);
            }else {
                acctFC = map_acctId_acctFC.get(accId);
            }

            acctFC.csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') + acctFC.csFC.get(dateKey) : acctFC.csFC.get(dateKey)));

            //acctFC.csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
            //acctFC.dcFC.put(dateKey, 0);
            //acctFC.pmFC.put(dateKey, 0);

            map_acctId_acctFC.put(accId, acctFC);    
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
                
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                CSD_ClsUtils.setRefDatelist(list_beforedate, list_futruedate, searchOb.set_fiscalMonth);
                
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();
                
                set<String> set_regions = new set<String>();
                set_regions.add(searchOb.region);
                
                set<String> set_soldtoIds = new set<String>();
                
                if(searchOb.viewMode == '' || searchOb.viewMode == 'billingRegion') {
                    list<String> list_sql = new list<String>();             
                    list_sql.add(' Sold_To_Number__c soldto ');
                    list_sql.add(' CSD_Sales_Forecast__c ');
                    list_sql.add(' WHERE Type__c = \'Sold-To\' '
                                + ' And Billing_Region__c IN : set_regions '
                                + ' Group by Sold_To_Number__c ' );
                    for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                        set_soldtoIds.add((String)result.get('soldto'));
                    }
                }

                if(list_beforedate.size() > 0) {
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    CSD_ClsUtils.setRefForecastDate(years, months, list_beforedate);

                    list<String> list_beforesql = new list<String>();
                    
                    if(searchOb.viewMode == '' || searchOb.viewMode == 'billingRegion') {
                        list_beforesql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                        list_beforesql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                        list_beforesql.add(' WHERE Customer__r.STATDESC__c = \'Active\' '
                            + ' And Customer__r.AccountNumber IN :set_soldtoIds '
                            + ' And Fiscal_Year__c IN : years '
                            + ' And Fiscal_Month__c IN : months '
                            + ' Group by Fiscal_Date__c ');
                        CSD_ClsUtils.setRegionMapRefData(searchOb.region, years, months, set_soldtoIds, list_beforesql, map_acctId_map_dateKey_result_before);
                    }else {
                        set<String> set_monthIds = new set<String>();
                        for(CSD_OEM_Mapping_Monthly_BBB__c csdmap : [select Monthly_Billings_Bookings_by_Part__c 
                                                                        from CSD_OEM_Mapping_Monthly_BBB__c 
                                                                        where Monthly_Billings_Bookings_by_Part__r.Fiscal_Year__c IN :years
                                                                            and Monthly_Billings_Bookings_by_Part__r.Fiscal_Month__c IN :months
                                                                            and Monthly_Billings_Bookings_by_Part__r.Customer__r.STATDESC__c = 'Active'
                                                                            and OEM_Mapping__r.OEM__r.OEM__r.Design_In_Region__c IN :set_regions]) {
                            set_monthIds.add(csdmap.Monthly_Billings_Bookings_by_Part__c);
                        }
                        
                        list_beforesql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                        list_beforesql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                        list_beforesql.add(' WHERE Id IN :set_monthids '
                                + ' Group by Fiscal_Date__c ');
                        //CSD_ClsUtils.setOEMPartMapRefData(set_monthIds, list_beforesql, map_acctId_map_dateKey_result_before);
                        CSD_ClsUtils.setGAMOEMMapRefData(searchOb.region, set_monthIds, list_beforesql, map_acctId_map_dateKey_result_before);
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
                
                set<String> set_regions = new set<String>();
                set_regions.add(searchOb.region);
                
                set<String> set_soldtoIds = new set<String>();
                
                if(searchOb.viewMode == '' || searchOb.viewMode == 'billingRegion') {
                    list<String> list_sql = new list<String>();             
                    list_sql.add(' Sold_To_Number__c soldto ');
                    list_sql.add(' CSD_Sales_Forecast__c ');
                    list_sql.add(' WHERE Type__c = \'Sold-To\' '
                                + ' And Billing_Region__c IN : set_regions '
                                + ' Group by Sold_To_Number__c ' );
                    for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                        set_soldtoIds.add((String)result.get('soldto'));
                    }
                }
                
                if(list_futruedate.size() > 0) {
                    // Updata the  Mingxing Qiu time is  2016-04-08 
                    //futrue
                    //set<String> years = new set<String>();
                    //set<Integer> months = new set<Integer>();
                    
                    //CSD_ClsUtils.setRefForecastDate(years, months, list_futruedate);
                    
                    list<String> list_futruesql = new list<String>();
                    if(searchOb.viewMode == '' || searchOb.viewMode == 'billingRegion') {
                        // Updata the  Mingxing Qiu time is  2016-04-08 
                      /*list_futruesql.add(' sum(Backlog_Amount_USD__c) amount, Fiscal_Date__c refdate');
                        list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
                        list_futruesql.add(' WHERE Customer__r.STATDESC__c = \'Active\' '
                            + ' And Customer__r.AccountNumber IN :set_soldtoIds '
                            + ' And Fiscal_Year__c IN : years '
                            + ' And Fiscal_Month__c IN : months '
                            + ' Group by Fiscal_Date__c ');     
                        CSD_ClsUtils.setRegionMapRefData(searchOb.region, years, months, set_soldtoIds, list_futruesql, map_acctId_map_dateKey_result_futrue);
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
                        list_futruesql.add(' sum(Backlog_Amount_USD__c) amount');
                        list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
                        list_futruesql.add(' WHERE Customer__r.STATDESC__c = \'Active\' '
                            + ' And Customer__r.AccountNumber IN :set_soldtoIds '
                            + ' And Customer_Request_Date__c >= :startDate '
                            + ' And Customer_Request_Date__c <= :endDate '); 
                              
                        CSD_ClsUtils.setRegionMapRefDataBacklog(searchOb.region, currentdate, startDate, endDate, set_soldtoIds, list_futruesql, map_acctId_map_dateKey_result_futrue);
                        }    
                        
                    }else {
                        //old  Updata the  Mingxing Qiu time is  2016-04-08 
                        /*set<String> set_dailyIds = new set<String>();
                        for(CSD_OEM_Mapping_Daily_BBB__c csdmap : [select Daily_Booking_Billing_Backlog_By_Part__c 
                                                                        from CSD_OEM_Mapping_Daily_BBB__c 
                                                                        where Daily_Booking_Billing_Backlog_By_Part__r.Fiscal_Year__c = :years 
                                                                            and Daily_Booking_Billing_Backlog_By_Part__r.Fiscal_Month__c IN :months
                                                                            and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.STATDESC__c = 'Active'
                                                                            and CSD_OEM_Mapping__r.OEM__r.OEM__r.Design_In_Region__c = :set_regions]) {
                            set_dailyIds.add(csdmap.Daily_Booking_Billing_Backlog_By_Part__c);
                        }
                        
                        list_futruesql.add(' Customer__r.AccountNumber refId, sum(Backlog_Amount_USD__c) amount, Fiscal_Date__c refdate');
                        list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
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
                                                                            and CSD_OEM_Mapping__r.OEM__r.OEM__r.Design_In_Region__c = :set_regions]) {
                            set_dailyIds.add(csdmap.Daily_Booking_Billing_Backlog_By_Part__c);
                        }

                        list_futruesql.add(' Customer__r.AccountNumber refId, sum(Backlog_Amount_USD__c) amount ');
                        list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
                        list_futruesql.add(' WHERE Id IN :set_monthids '
                            + ' Group by Customer__r.AccountNumber ');      
                        CSD_ClsUtils.setOEMPartMapRefDataBacklog(currentdate,set_dailyIds, list_futruesql, map_acctId_map_dateKey_result_futrue);   

                        }  
                    
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
            system.debug('@#searchOb : '+searchOb);
            
            map<String, CSD_ClsEntityType.AccountObj> map_acctId_acctFC = new map<String, CSD_ClsEntityType.AccountObj>();
            /*if(searchOb.type == 'channel'){
                getExistChannelForecast(searchOb, map_acctId_acctFC);
                list<CSD_ClsEntityType.AccountObj> list_accFC = new list<CSD_ClsEntityType.AccountObj>();
                list_accFC.addAll(map_acctId_acctFC.values());
                list_accFC.sort();
                return Json.serialize(list_accFC);
            }*/
            Date currentdate = Date.valueOf(searchOb.startDate);
            Date enddate = Date.valueOf(searchOb.endDate);
            
            list<String> list_sql = new list<String>();
            String typename = 'OEM';
            list_sql.add(' OEM__c oem, OEM__r.Name accname, Fiscal_Year__c year, Fiscal_Month__c month, '
                + ' sum(Quantity__c) quantity, sum(Forecast__c) sumFC, sum(Price__c) price, sum(Rest_Parts_Forecast__c) restPNFC, '
                + ' sum(DC_Forecast_Amount__c) sumDCFC, sum(Previous_Month_Forecast__c) sumPMFC ');
            list_sql.add(' CSD_Sales_Forecast__c ');
            /*
            list_sql.add(' WHERE Sold_To_Number__c = \''+ searchOb.accnumber +'\' ' 
                    + ' And ' + ((searchOb.viewMode == '' || searchOb.viewMode == 'billingRegion') ? ' Billing_Region__c ' : ' OEM__r.Design_In_Region__c ' )
            */
            list_sql.add(' WHERE ' + ((searchOb.viewMode == '' || searchOb.viewMode == 'billingRegion') ? ' Billing_Region__c ' : ' OEM__r.Design_In_Region__c ' )
                    +' = \'' + searchOb.region + '\' ' 
                    + ' And Type__c IN (\'OEM\',\'Non-OEMs\') '
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by OEM__c, OEM__r.Name, Fiscal_Year__c, Fiscal_Month__c  ');
            
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
                
                
            }
            /*if(searchOb.region == 'TAIWAN' && (searchOb.viewMode == '' || searchOb.viewMode == 'billingRegion')) {
                
                list<String> list_taiwansql = new list<String>();
                    
                list_taiwansql.add(' OEM__c oem, Sold_To_Number__c soldto ');
                list_taiwansql.add(' CSD_Sales_Forecast__c ');
                list_taiwansql.add(' WHERE Type__c = :typename '
                            //+ ' And Sold_To_Number__c = \''+ searchOb.accnumber +'\' '
                            + ' And Billing_Region__c = \'TAIWAN\' ' 
                            + ' And Fiscal_Date__c >= : currentdate '
                            + ' And Fiscal_Date__c < : enddate '
                            + ' Group by OEM__c, Sold_To_Number__c ');
                set<String> set_taiwanoems = new set<String>();
                for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_taiwansql))) {
                    set_taiwanoems.add((String)result.get('oem'));
                }
                
                typename = 'Part';
                //list_sql.add(2, ' WHERE Sold_To_Number__c = \''+ searchOb.accnumber +'\' ' 
                
                list_sql.add(2, ' WHERE Billing_Region__c = \'' + searchOb.region + '\' ' 
                    + ' And Type__c = \''+typename+'\' '
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' And OEM__c NOT IN :set_taiwanoems '
                    + ' Group by OEM__c, OEM__r.Name, Fiscal_Year__c, Fiscal_Month__c  ');
                for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                    String accId = (String)result.get('oem'), 
                           year = (String) result.get('year'),
                           month = (String) result.get('month'), 
                           dateKey = (year + '_' + month);
                    if(map_acctId_acctFC.containsKey(accId)) {
                        system.debug('@#map_acctId_acctFC.get(accId).csFC:'+map_acctId_acctFC.get(accId).csFC.get(dateKey));
                        system.debug('@#dateKey:'+dateKey);
                        map_acctId_acctFC.get(accId).csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') + map_acctId_acctFC.get(accId).csFC.get(dateKey) : map_acctId_acctFC.get(accId).csFC.get(dateKey)));
                        map_acctId_acctFC.get(accId).dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') + map_acctId_acctFC.get(accId).dcFC.get(dateKey) : map_acctId_acctFC.get(accId).dcFC.get(dateKey)));
                        map_acctId_acctFC.get(accId).pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') + map_acctId_acctFC.get(accId).pmFC.get(dateKey) : map_acctId_acctFC.get(accId).pmFC.get(dateKey)));
                    }else {
                        CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
                        CSD_ClsUtils.createAccountObj(acctFC, searchOb.map_year_monthsFuture);
                        acctFC.id = accId;
                        acctFC.name = (String)result.get('accname');
        
                        acctFC.csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
                        acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
                        acctFC.pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
                        acctFC.restPNFC.put(dateKey, (result.get('restPNFC') != null ? (decimal)result.get('restPNFC') : 0));
                        map_acctId_acctFC.put(accId, acctFC);
                    }
                }
            }
            */
            
            list_sql.clear();
            //map_acctId_map_dateKey_result.clear();
            list_sql.add('OEM__c oem, OEM__r.Name accname, Fiscal_Year__c year, Fiscal_Month__c month, '
                + ' sum(Quantity__c) quantity, sum(Forecast__c) sumFC, sum(Price__c) price, sum(Rest_Parts_Forecast__c) restPNFC, '
                + ' sum(DC_Forecast_Amount__c) sumDCFC, sum(Previous_Month_Forecast__c) sumPMFC');
                        
            list_sql.add(' CSD_Sales_Forecast__c ');
            //list_sql.add(' WHERE Sold_To_Number__c = \''+ searchOb.accnumber +'\' ' 
            list_sql.add(' WHERE Billing_Region__c = \'' + searchOb.region + '\' ' 
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
            
            getExistChannelForecast(searchOb, map_acctId_acctFC);
            
            list<CSD_ClsEntityType.AccountObj> list_accFC = new list<CSD_ClsEntityType.AccountObj>();
            list_accFC.addAll(map_acctId_acctFC.values());
            list_accFC.sort();
            system.debug('@#list_accFC :' + list_accFC);
            return Json.serialize(list_accFC);
        }
        
        
        private void getExistChannelForecast(CSD_ClsEntityType.SearchObj searchOb, map<String, CSD_ClsEntityType.AccountObj> map_acctId_acctFC){
            
            Date currentdate = Date.valueOf(searchOb.startDate);
            Date enddate = Date.valueOf(searchOb.endDate);
                        
            list<String> list_sql = new list<String>();
            list_sql.add( ' OEM__c oem, OEM__r.Name accname, '
                        + ' Fiscal_Year__c year, Fiscal_Month__c month, sum(Forecast__c) sumFC ');
            list_sql.add(' CSD_Channel_Forecast__c ');
            list_sql.add(' WHERE ' + ((searchOb.viewMode == '' || searchOb.viewMode == 'billingRegion') ? ' Billing_Region__c ' : ' OEM__r.Design_In_Region__c ' )  + ' = \'' + searchOb.region + '\' ' 
                        + ' And Fiscal_Date__c >= : currentdate '
                        + ' And Fiscal_Date__c < : enddate '
                        + ' Group by Fiscal_Year__c, Fiscal_Month__c, '
                        + ' OEM__c, OEM__r.Name ');
            
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                String accId = (String)result.get('oem'), 
                       year = (String) result.get('year'),
                       month = (String) result.get('month'), 
                       dateKey = (year + '_' + month);
                
                
                CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
                
                if(!map_acctId_acctFC.containsKey(accId)) {
                    CSD_ClsUtils.createAccountObj(acctFC, searchOb.map_year_monthsFuture);
                    
                    acctFC.id = accId;
                    acctFC.name = (String)result.get('accname');
                    acctFC.type = 'channel';
                    map_acctId_acctFC.put(accId, acctFC);
                }else {
                    acctFC = map_acctId_acctFC.get(accId);
                }
                system.debug('@#acctFC: '+acctFC);
                system.debug('@#result: '+result);
                if(acctFC.csFC.containsKey(dateKey)) {
                    acctFC.csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') + acctFC.csFC.get(dateKey) : acctFC.csFC.get(dateKey)));
                }else {
                    acctFC.csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
                }
                
                //acctFC.csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
                //acctFC.dcFC.put(dateKey, 0);
                //acctFC.pmFC.put(dateKey, 0);
    
                map_acctId_acctFC.put(accId, acctFC);    
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
                system.debug('@#searchOb : '+searchOb);
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
                    if(searchOb.viewMode == '' || searchOb.viewMode == 'billingRegion') {
                        set<String> set_soldtoIds = new set<String>();
                        list<String> list_sql = new list<String>();             
                        list_sql.add(' Sold_To_Number__c soldto ');
                        list_sql.add(' CSD_Sales_Forecast__c ');
                        list_sql.add(' WHERE Type__c = \'Sold-To\' '
                                    + ' And Billing_Region__c = \''+searchOb.region+'\' '
                                    + ' Group by Sold_To_Number__c ' );
                        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                            set_soldtoIds.add((String)result.get('soldto'));
                        }
                        for(CSD_OEM_Mapping_Monthly_BBB__c csdmap : [select Monthly_Billings_Bookings_by_Part__c 
                                                                        from CSD_OEM_Mapping_Monthly_BBB__c 
                                                                        where Monthly_Billings_Bookings_by_Part__r.Fiscal_Year__c IN :years
                                                                            and Monthly_Billings_Bookings_by_Part__r.Fiscal_Month__c IN :months
                                                                            and Monthly_Billings_Bookings_by_Part__r.Customer__r.STATDESC__c = 'Active'
                                                                            and Monthly_Billings_Bookings_by_Part__r.Customer__r.AccountNumber IN :set_soldtoIds
                                                                            and OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
                            set_monthIds.add(csdmap.Monthly_Billings_Bookings_by_Part__c);
                        }
                    }else {
                        for(CSD_OEM_Mapping_Monthly_BBB__c csdmap : [select Monthly_Billings_Bookings_by_Part__c 
                                                                        from CSD_OEM_Mapping_Monthly_BBB__c 
                                                                        where Monthly_Billings_Bookings_by_Part__r.Fiscal_Year__c IN :years
                                                                            and Monthly_Billings_Bookings_by_Part__r.Fiscal_Month__c IN :months
                                                                            and Monthly_Billings_Bookings_by_Part__r.Customer__r.STATDESC__c = 'Active'
                                                                            //and Monthly_Billings_Bookings_by_Part__r.Customer__r.AccountNumber = :searchOb.accnumber ]) {
                                                                            and OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
                            set_monthIds.add(csdmap.Monthly_Billings_Bookings_by_Part__c);
                        }
                    }
                    
                    list<String> list_beforesql = new list<String>();
                    list_beforesql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                    list_beforesql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_beforesql.add(' WHERE Id IN :set_monthids '
                            + ' Group by Fiscal_Date__c ');
                    //CSD_ClsUtils.setGAMOEMMapRefData(set_monthIds, list_beforesql, map_acctId_map_dateKey_result_before);
                    CSD_ClsUtils.setGAMOEMMapRefData(searchOb.oemId, set_monthIds, list_beforesql, map_acctId_map_dateKey_result_before);
                }
                
                CSD_ClsEntityType.CSDRefObj refdata = CSD_ClsUtils.createRefDataObj();
                refdata.id = searchOb.oemId;
                
                CSD_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                system.debug('@#refdata:'+refdata);
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
                system.debug('@#searchOb : '+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                CSD_ClsUtils.setRefDatelist(list_beforedate, list_futruedate, searchOb.set_fiscalMonth);
                
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();
                
                if(list_futruedate.size() > 0) {
                    //futrue
                    //set<String> years = new set<String>();
                    //set<Integer> months = new set<Integer>();
                    
                    //CSD_ClsUtils.setRefForecastDate(years, months, list_futruedate);
                   
                        //Updata the  Mingxing Qiu time is  2016-04-08 
                        /*for(CSD_OEM_Mapping_Daily_BBB__c csdmap : [select Daily_Booking_Billing_Backlog_By_Part__c 
                                                                        from CSD_OEM_Mapping_Daily_BBB__c 
                                                                        where Daily_Booking_Billing_Backlog_By_Part__r.Fiscal_Year__c IN :years
                                                                            and Daily_Booking_Billing_Backlog_By_Part__r.Fiscal_Month__c IN :months
                                                                            and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.STATDESC__c = 'Active'
                                                                            and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.AccountNumber IN :set_soldtoIds 
                                                                            and CSD_OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
                            set_dailyIds.add(csdmap.Daily_Booking_Billing_Backlog_By_Part__c);  
                          }
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
                        if(searchOb.viewMode == '' || searchOb.viewMode == 'billingRegion') {
                            set<String> set_soldtoIds = new set<String>();
                            list<String> list_sql = new list<String>();             
                            list_sql.add(' Sold_To_Number__c soldto ');
                            list_sql.add(' CSD_Sales_Forecast__c ');
                            list_sql.add(' WHERE Type__c = \'Sold-To\' '
                                        + ' And Billing_Region__c = \''+searchOb.region+'\' '
                                        + ' Group by Sold_To_Number__c ' );
                            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                                set_soldtoIds.add((String)result.get('soldto'));
                            }
                            
                            for(CSD_OEM_Mapping_Daily_BBB__c csdmap : [select Daily_Booking_Billing_Backlog_By_Part__c 
                                                                        from CSD_OEM_Mapping_Daily_BBB__c 
                                                                        where Daily_Booking_Billing_Backlog_By_Part__r.Customer_Request_Date__c >= :startDate 
                                                                            and Daily_Booking_Billing_Backlog_By_Part__r.Customer_Request_Date__c <= :endDate
                                                                            and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.STATDESC__c = 'Active'
                                                                            and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.AccountNumber IN :set_soldtoIds 
                                                                            and CSD_OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
                            set_dailyIds.add(csdmap.Daily_Booking_Billing_Backlog_By_Part__c);
                            }

                        }else {
                            //Updata the  Mingxing Qiu time is  2016-04-08 
                            /*for(CSD_OEM_Mapping_Daily_BBB__c csdmap : [select Daily_Booking_Billing_Backlog_By_Part__c 
                                                                            from CSD_OEM_Mapping_Daily_BBB__c 
                                                                            where Daily_Booking_Billing_Backlog_By_Part__r.Fiscal_Year__c IN :years
                                                                                and Daily_Booking_Billing_Backlog_By_Part__r.Fiscal_Month__c IN :months
                                                                                and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.STATDESC__c = 'Active'
                                                                                //and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.AccountNumber = :searchOb.accnumber ]) {
                                                                                and CSD_OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
                                set_dailyIds.add(csdmap.Daily_Booking_Billing_Backlog_By_Part__c);
                            }*/
                            for(CSD_OEM_Mapping_Daily_BBB__c csdmap : [select Daily_Booking_Billing_Backlog_By_Part__c 
                                                                        from CSD_OEM_Mapping_Daily_BBB__c 
                                                                        where Daily_Booking_Billing_Backlog_By_Part__r.Customer_Request_Date__c >= :startDate 
                                                                           and Daily_Booking_Billing_Backlog_By_Part__r.Customer_Request_Date__c <= :endDate
                                                                           and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.STATDESC__c = 'Active'
                                                                           and CSD_OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
                                set_dailyIds.add(csdmap.Daily_Booking_Billing_Backlog_By_Part__c);
                            }

                        }
                        
                            list<String> list_futruesql = new list<String>();
                            list_futruesql.add(' sum(Backlog_Amount_USD__c) amount ');
                            list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c    ');
                            list_futruesql.add(' WHERE Id IN :set_monthids ');
                            CSD_ClsUtils.setGAMOEMMapRefDataBacklog(currentdate, searchOb.oemId, set_dailyIds, list_futruesql, map_acctId_map_dateKey_result_futrue); 
                        
                    }
                    /*
                    list<String> list_futruesql = new list<String>();
                    list_futruesql.add(' sum(Backlog_Amount_USD__c) amount, Fiscal_Date__c refdate');
                    list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c    ');
                    list_futruesql.add(' WHERE Id IN :set_monthids '
                        + ' Group by Fiscal_Date__c ');      
                    //CSD_ClsUtils.setOEMPartMapRefData(set_dailyIds, list_futruesql, map_acctId_map_dateKey_result_futrue);
                    CSD_ClsUtils.setGAMOEMMapRefData(searchOb.oemId, set_dailyIds, list_futruesql, map_acctId_map_dateKey_result_futrue);
                    */
                     
                }

                CSD_ClsEntityType.CSDRefObj refdata = CSD_ClsUtils.createRefDataObj();
                refdata.id = searchOb.oemId;
                
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
            
            String typename = 'OEM';
            
            list<CSD_ClsEntityType.AccountObj> list_accFc = new list<CSD_ClsEntityType.AccountObj>();
            map<String, CSD_ClsEntityType.AccountObj> map_acctId_acctFC = new map<String, CSD_ClsEntityType.AccountObj>();

            if(searchOb.type == 'channel'){

                getExistChannelForecast(searchOb, map_acctId_acctFC); //added 2015-01-14 minghao.li@itbconsult.com 
                
                list_accFC.addAll(map_acctId_acctFC.values());
                list_accFC.sort();
                system.debug('@#list_accFC :'+list_accFC);
                return Json.serialize(list_accFC);
            } 
            
            list<String> list_sql = new list<String>();
            list_sql.add(' Sold_To_Number__c soldto ');
            list_sql.add(' CSD_Sales_Forecast__c ');
            list_sql.add(' WHERE Type__c IN (\'OEM\',\'Non-OEMs\') '
                        + ' And ' + ((searchOb.viewMode == '' || searchOb.viewMode == 'billingRegion') ? ' Billing_Region__c ' : ' OEM__r.Design_In_Region__c ' )
                        + ' = \'' + searchOb.region + '\' ' 
                        + ' And OEM__c = \''+ searchOb.oemId +'\' '
                        + ' And Fiscal_Date__c >= : currentdate '
                        + ' And Fiscal_Date__c < : enddate '
                        + ' Group by Sold_To_Number__c ');
            map<Integer, set<String>> map_set_soldto = new map<Integer, set<String>>();
            Integer i = 0;
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                Integer num = i/150;
                if(map_set_soldto.containsKey(num)) {
                    map_set_soldto.get(num).add((String)result.get('soldto'));
                }else {
                    set<String> set_soldto = new set<String>();
                    set_soldto.add((String)result.get('soldto'));
                    map_set_soldto.put(num, set_soldto);
                }
                i++;
            }
            
            for(Integer num : map_set_soldto.keySet()) {
                getExistResultForMore(searchOb, map_acctId_acctFC, currentdate, enddate, map_set_soldto.get(num));
            }

            list_accFc.addAll(map_acctId_acctFC.values());
            list_accFc.sort();
            
            return Json.serialize(list_accFC);
        }

        private void getExistResultForMore(CSD_ClsEntityType.SearchObj searchOb, map<String, CSD_ClsEntityType.AccountObj> map_acctId_acctFC, Date currentdate, Date enddate, set<String> set_key) {
            
            list<String> list_sql = new list<String>();
            list_sql.add('Sold_To_Number__c soldto, Sold_To_Name__c name, Fiscal_Year__c year, Fiscal_Month__c month, '
                    + 'sum(DC_Forecast_Amount__c) sumDCFC, sum(Forecast__c) sumFC, sum(Previous_Month_Forecast__c) sumPMFC');
                        
            list_sql.add(' CSD_Sales_Forecast__c ');
            list_sql.add(' WHERE Type__c IN (\'OEM\',\'Non-OEMs\') '
                        + ' And ' + ((searchOb.viewMode == '' || searchOb.viewMode == 'billingRegion') ? ' Billing_Region__c ' : ' OEM__r.Design_In_Region__c ' )
                        + ' = \'' + searchOb.region + '\' ' 
                        + ' And OEM__c = \''+ searchOb.oemId +'\' '
                        + ' And Sold_To_Number__c = :set_key ' 
                        + ' And Fiscal_Date__c >= : currentdate '
                        + ' And Fiscal_Date__c < : enddate '
                        + ' Group by Fiscal_Year__c, Fiscal_Month__c, Sold_To_Number__c, Sold_To_Name__c ');

            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                //system.debug('@#result : '+result);
                String accId = (String)result.get('soldto'), 
                       year = (String) result.get('year'),
                       month = (String) result.get('month'), 
                       dateKey = (year + '_' + month);
                   
                CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
    
                if(!map_acctId_acctFC.containsKey(accId)) {
                    CSD_ClsUtils.createAccountObj(acctFC, searchOb.map_year_monthsFuture);
                    acctFC.id = CSD_ClsUtils.getHexUID();
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
            
        }

        private void getExistChannelForecast(CSD_ClsEntityType.SearchObj searchOb, map<String, CSD_ClsEntityType.AccountObj> map_acctId_acctFC){
            
            Date currentdate = Date.valueOf(searchOb.startDate);
            Date enddate = Date.valueOf(searchOb.endDate);
                        
            list<String> list_sql = new list<String>();
            list_sql.add( ' OEM__c oem, OEM__r.Name accname, '
                        + ' Fiscal_Year__c year, Fiscal_Month__c month, sum(Forecast__c) sumFC ');
            list_sql.add(' CSD_Channel_Forecast__c ');
            list_sql.add(' WHERE ' + ((searchOb.viewMode == '' || searchOb.viewMode == 'billingRegion') ? ' Billing_Region__c ' : ' OEM__r.Design_In_Region__c ' )  + ' = \'' + searchOb.region + '\' '
                        + ' And OEM__c = \''+ searchOb.oemId +'\' '
                        + ' And Fiscal_Date__c >= : currentdate '
                        + ' And Fiscal_Date__c < : enddate '
                        + ' Group by Fiscal_Year__c, Fiscal_Month__c, '
                        + ' OEM__c, OEM__r.Name ');
            
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                String accId = (String)result.get('oem'), 
                       year = (String) result.get('year'),
                       month = (String) result.get('month'), 
                       dateKey = (year + '_' + month);
                
                
                CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
                
                if(!map_acctId_acctFC.containsKey(accId)) {
                    CSD_ClsUtils.createAccountObj(acctFC, searchOb.map_year_monthsFuture);
                    
                    acctFC.id = accId;
                    acctFC.name = (String)result.get('accname');
                    acctFC.type = 'channel';
                    map_acctId_acctFC.put(accId, acctFC);
                }else {
                    acctFC = map_acctId_acctFC.get(accId);
                }
                system.debug('@#acctFC: '+acctFC);
                system.debug('@#result: '+result);
                if(acctFC.csFC.containsKey(dateKey)) {
                    acctFC.csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') + acctFC.csFC.get(dateKey) : acctFC.csFC.get(dateKey)));
                }else {
                    acctFC.csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
                }
                
                //acctFC.csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
                //acctFC.dcFC.put(dateKey, 0);
                //acctFC.pmFC.put(dateKey, 0);
    
                map_acctId_acctFC.put(accId, acctFC);    
            }
        }
        
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
                        system.debug('!@# set_dailyIds:'+set_dailyIds );
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
    
    public class SearchLevel4 extends CSD_Interface.ACSDRemoteService{
        
        public override String getExistResult(String sData){
            CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData, CSD_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb:'+searchOb.oemId);
            
            Date currentdate = Date.valueOf(searchOb.startDate);
            Date enddate = Date.valueOf(searchOb.endDate);
            
            String samsungoemId = '';
            if(CSD_Configuration__c.getInstance('Samsung OEM Account') != null || CSD_Configuration__c.getInstance('Samsung OEM Account').Value__c != null) {
                samsungoemId = CSD_Configuration__c.getInstance('Samsung OEM Account').Value__c;
            }
            
            map<String, CSD_ClsEntityType.PartObj> map_acctId_acctFC = new map<String, CSD_ClsEntityType.PartObj>();
            
            list<String> list_sql = new list<String>();
            list_sql.add(' Part__c part ');   
            list_sql.add(' CSD_Sales_Forecast__c ');
            list_sql.add(' WHERE Sold_To_Number__c = \''+ searchOb.accnumber +'\' ' 
                    + ' And OEM__c = \''+ searchOb.oemId +'\' '
                    + ' And ' + ((searchOb.viewMode == '' || searchOb.viewMode == 'billingRegion') ? ' Billing_Region__c ' : ' OEM__r.Design_In_Region__c ' )
                    + ' = \'' + searchOb.region + '\' ' 
                    + ' And Type__c = ' + (samsungoemId.substring(0,15) == searchOb.oemId.substring(0,15) ? ' \'Sold-To\' ' : ' \'Part\' ') 
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Part__c ');
            
            map<Integer, set<String>> map_set_soldto = new map<Integer, set<String>>();
            Integer i = 0;
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                Integer num = i/150;
                if(map_set_soldto.containsKey(num)) {
                    map_set_soldto.get(num).add((String)result.get('part'));
                }else {
                    set<String> set_soldto = new set<String>();
                    set_soldto.add((String)result.get('part'));
                    map_set_soldto.put(num, set_soldto);
                }
                i++;
            }
            
            for(Integer num : map_set_soldto.keySet()) {
                getExistResultForMore(searchOb, map_acctId_acctFC, currentdate, enddate, samsungoemId, map_set_soldto.get(num));
            }
            

            list<CSD_ClsEntityType.PartObj> list_accFC = new list<CSD_ClsEntityType.PartObj>();
            list_accFC.addAll(map_acctId_acctFC.values());
            list_accFC.sort();
            return Json.serialize(list_accFC);

        }
        
        
        private void getExistResultForMore(CSD_ClsEntityType.SearchObj searchOb, map<String, CSD_ClsEntityType.PartObj> map_acctId_acctFC, Date currentdate, Date enddate, String samsungoemId, set<String> set_key) {
            
            list<String> list_sql = new list<String>();
            list_sql.add(' Part__c part, Part__r.Name partname, Part__r.Description__c descr, Fiscal_Year__c year, Fiscal_Month__c month, '
                    + ' sum(Quantity__c) quantity, sum(Forecast__c) sumFC, sum(Price__c) price,'
                    + ' sum(DC_Forecast_Amount__c) sumDCFC, sum(Previous_Month_Forecast__c) sumPMFC');
                    
            list_sql.add(' CSD_Sales_Forecast__c ');
            list_sql.add(' WHERE Sold_To_Number__c = \''+ searchOb.accnumber +'\' ' 
                    + ' And OEM__c = \''+ searchOb.oemId +'\' '
                    + ' And ' + ((searchOb.viewMode == '' || searchOb.viewMode == 'billingRegion') ? ' Billing_Region__c ' : ' OEM__r.Design_In_Region__c ' )
                    + ' = \'' + searchOb.region + '\' ' 
                    + ' And Type__c = ' + (samsungoemId.substring(0,15) == searchOb.oemId.substring(0,15) ? ' \'Sold-To\' ' : ' \'Part\' ') 
                    + ' And Part__c = :set_key '
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Part__c, Part__r.Name, Part__r.Description__c, Fiscal_Year__c, Fiscal_Month__c ');
            
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
                    acctFC.snumber = result.get('descr') != null ? (String)result.get('descr') : '';
    
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
                                                                        and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.AccountNumber = :searchOb.accnumber 
                                                                        and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.STATDESC__c = 'Active'
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
                                                                            and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.AccountNumber = :searchOb.accnumber 
                                                                            and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.STATDESC__c = 'Active'
                                                                            and Daily_Booking_Billing_Backlog_By_Part__r.Part__c = :searchOb.partId 
                                                                            and CSD_OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId ]) {
                        set_dailyIds.add(csdmap.Daily_Booking_Billing_Backlog_By_Part__c);
                        }
                        system.debug('@#set_dailyIds:'+set_dailyIds);
                        list<String> list_futruesql = new list<String>();
                        list_futruesql.add(' Customer__r.AccountNumber refId, sum(Backlog_Amount_USD__c) amount ');
                        list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c    ');
                        list_futruesql.add(' WHERE Id IN :set_monthids '
                            + ' Group by Customer__r.AccountNumber ');      
                        CSD_ClsUtils.setOEMPartMapRefDataBacklog(currentdate,set_dailyIds, list_futruesql, map_acctId_map_dateKey_result_futrue);
                        
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
                
                set<String> set_regions = new set<String>();
                for(CSD_Forecast_Management__c acc : [Select Id, Region__c from CSD_Forecast_Management__c where Role__c = 'Sales Leader' And User__c = :UserInfo.getUserId() ]) {
                    if(acc.Region__c != null) {
                        list<String> accregions = acc.Region__c.split(';');
                        for(String region : accregions) {
                            if(!set_regions.contains(region)) {
                                set_regions.add(region);
                            }
                        }
                    }
                }
                
                set<String> set_soldtoIds = new set<String>();
                
                if(searchOb.viewMode == '' || searchOb.viewMode == 'billingRegion') {
                    list<String> list_sql = new list<String>();             
                    list_sql.add(' Sold_To_Number__c soldto ');
                    list_sql.add(' CSD_Sales_Forecast__c ');
                    list_sql.add(' WHERE Type__c = \'Sold-To\' '
                                + ' And Billing_Region__c IN : set_regions '
                                + ' Group by Sold_To_Number__c ' );
                    for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                        set_soldtoIds.add((String)result.get('soldto'));
                    }
                }
                
                if(list_beforedate.size() > 0) {
                    
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    CSD_ClsUtils.setRefForecastDate(years, months, list_beforedate);

                    list<String> list_beforesql = new list<String>();
                    
                    
                    if(searchOb.viewMode == '' || searchOb.viewMode == 'billingRegion') {
                        list_beforesql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                        list_beforesql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                        list_beforesql.add(' WHERE Customer__r.STATDESC__c = \'Active\' '
                            + ' And Customer__r.AccountNumber IN :set_perm '
                            + ' And Fiscal_Year__c IN : years '
                            + ' And Fiscal_Month__c IN : months '
                            + ' Group by Fiscal_Date__c ');
                        CSD_ClsUtils.setTotelBillingData(years, months, set_soldtoIds, list_beforesql, map_acctId_map_dateKey_result_before);
                    }else {
                        set<String> set_monthIds = new set<String>();
                        for(CSD_OEM_Mapping_Monthly_BBB__c csdmap : [select Monthly_Billings_Bookings_by_Part__c 
                                                                        from CSD_OEM_Mapping_Monthly_BBB__c 
                                                                        where Monthly_Billings_Bookings_by_Part__r.Fiscal_Year__c IN :years
                                                                            and Monthly_Billings_Bookings_by_Part__r.Fiscal_Month__c IN :months
                                                                            and Monthly_Billings_Bookings_by_Part__r.Customer__r.STATDESC__c = 'Active'
                                                                            and OEM_Mapping__r.OEM__r.OEM__r.Design_In_Region__c IN :set_regions]) {
                            set_monthIds.add(csdmap.Monthly_Billings_Bookings_by_Part__c);
                        }
                        
                        list_beforesql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                        list_beforesql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                        list_beforesql.add(' WHERE Id IN :set_perm '
                                + ' Group by Fiscal_Date__c ');
                        CSD_ClsUtils.setTotelBillingData(years, months, set_monthIds, list_beforesql, map_acctId_map_dateKey_result_before);
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
    
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
}