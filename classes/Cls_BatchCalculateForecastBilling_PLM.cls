/**
 *  A batch job for Forecast Billing.
 *  
 * @author Jinbo Shan
 * @created 2014-11-03
 * @version 1.0
 * @since 30.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 *
 * 2014-11-03 Jinbo Shan <jinbo.shan@itbconsult.com>
 * - Created   
 *
 */
global class Cls_BatchCalculateForecastBilling_PLM implements Database.Batchable<SObject>,Database.Stateful {
    
    global Date currentDate;
    global String currentYear;
    global Integer currentMonth;
    global Integer currentQuarter;
    global String currentMonthString;
    global Date startDate;
    global string filter;
    public Date startDate4quarter;
    public Id fbillingrt;
    public Id salesPartRTId;
    
    //added by Jinbo Shan to add load status Id for forecast billing
    public Id loadStatusId;
    
    public static final map<String, Integer> MAP_MONTHLABELNUMBER = new map<String, Integer>{
        'Jan' => 4, 'Feb' => 5, 'Mar' => 6, 'Apr' => 7, 'May' => 8, 'Jun' => 9,
        'Jul' => 10, 'Aug' => 11, 'Sep' => 12, 'Oct' => 1, 'Nov' => 2, 'Dec' => 3
    };
    public static final map<Integer, String> MAP_NUMBERMONTHLABEL = new map<Integer, String>{
        4 => 'Jan', 5 => 'Feb', 6 => 'Mar', 7 => 'Apr', 8 => 'May', 9 => 'Jun',
        10 => 'Jul', 11 => 'Aug', 12 => 'Sep', 1 => 'Oct', 2 => 'Nov', 3 => 'Dec'
    };
    public map<String, Date> map_startAndEndDate = new map<String, Date>{'s' => currentDate, 'e' =>currentDate};
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        //added by Jinbo Shan to get the sales part record type Id 2015-11-05
        if(Apex_Helper_Settings__c.getInstance('Sales Parts RT Id') != null) salesPartRTId = Apex_Helper_Settings__c.getInstance('Sales Parts RT Id').Value__c;
        
        //added by Jinbo Shan to add load status Id for forecast billing
        if(Load_Status_Of_Forecast_Billing__c.getInstance('Engineering') != null) {
            loadStatusId = Load_Status_Of_Forecast_Billing__c.getInstance('Engineering').Load_Status_Id__c;
        }
        
        for(RecordType rt : [select Id from RecordType where DeveloperName = 'Engineering']) {
            fbillingrt = rt.Id;
        }
        
        if(currentDate == null) {
            currentDate = system.today();
        }
        //get the last Month and corresponding to year.
        for (Period period : [select Id, FiscalYearSettings.Name, PeriodLabel 
                            from Period where StartDate <= :currentDate and EndDate >= :currentDate and Type = 'Month']) {
            if(period.FiscalYearSettings.Name != null){ //set current year
                currentYear = period.FiscalYearSettings.Name;
            }
            if(period.PeriodLabel != null && MAP_MONTHLABELNUMBER.containsKey(period.PeriodLabel)){ //set current month
                currentMonth = MAP_MONTHLABELNUMBER.get(period.PeriodLabel);
            }                       
        }
        
        for (Period period : [select Id, FiscalYearSettings.Name, Number 
                            from Period where StartDate <= :currentDate and EndDate >= :currentDate and Type = 'Quarter']) {
            if(period.FiscalYearSettings.Name != null){ //set current year
                currentYear = period.FiscalYearSettings.Name;
            }
            if(period.Number != null){ //set current month
                currentQuarter = period.Number;
            }                       
        }
        
        //get the last fisical month and fisical quarter.
        currentQuarter = (Math.mod(currentMonth, 3) == 1) ? (currentQuarter - 1) : currentQuarter;
        
        currentQuarter = (currentQuarter <= 0) ? (currentQuarter + 4) : currentQuarter;
        if(currentMonth == 1) {
            currentMonth = 12;
            currentYear = Integer.valueOf(currentYear) - 1 + '';
        }else {
            currentMonth = currentMonth - 1;
        }
        //currentMonth = (currentMonth == 1) ? 12 : (currentMonth - 1);
        //currentYear = (currentMonth == 1) ? (Integer.valueOf(currentYear) - 1 + '') : currentYear;
        
        currentMonthString = currentMonth < 10 ? ('0' + currentMonth) : ('' + currentMonth);
        
        for (Period period : [select Id, StartDate, Type 
                            from Period where FiscalYearSettings.Name = :currentYear and PeriodLabel = :MAP_NUMBERMONTHLABEL.get(currentMonth) and (Type = 'Month' or Type = 'Quarter')]) {
            if(period.Type == 'Month') {
                startDate = period.StartDate;
            }
            if(period.Type == 'Quarter') {
                startDate4quarter = period.StartDate;
            }
            
        }
        system.debug('**@@currentMonthString = ' + currentMonthString);
        system.debug('**@@currentQuarter = ' + currentQuarter);
        system.debug('**@@startDate = ' + startDate);
        system.debug('**@@currentMonth = ' + currentMonth);
        system.debug('**@@currentYear = ' + currentYear);
        string query = 'select Id, PLM_Id__c from Opportunity where IsClosed = true and IsWon = true and PLM_Id__c != null ';//
        if(filter != null) {
            query += ' and ' + filter;
        }
        // where Industry_Code_Description__c=\'IB\' or Industry_Code_Description__c=\'A&C\'
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<Opportunity> list_oppys) { 
        
        boolean hasForecast = false;
        set<string> set_plmIds = new set<string>();
        map<Id, string> map_oppyId_PLMId = new map<Id, string>();
        set<Id> set_accIds4filter = new set<Id>();
        set<Id> set_partIds4filter = new set<Id>();
        set<Id> set_oppyPartIds4filter = new set<Id>(); //added by Jinbo shan 2015-12-07
        set<Id> set_fcIds4filter = new set<Id>();
        set<Date> set_forecastdate4filter = new set<Date>();
        set<Opportunity_Forecast__c> set_ofs = new set<Opportunity_Forecast__c>();
        
        //list<Opportunity_Forecast__c> list_ofs2update = new list<Opportunity_Forecast__c>();
        list<Forecast_Snapshot__c> list_fs2update = new list<Forecast_Snapshot__c>();
        
        for(Opportunity opp : list_oppys) {
            set_plmIds.add(opp.PLM_Id__c);
            map_oppyId_PLMId.put(opp.Id, opp.PLM_Id__c);
        }
        
        //clear all existing forecast billing for Opportunities
        list<Forecast_Billing__c> list_fbs4delete = new list<Forecast_Billing__c>();
        for(Forecast_Billing__c fb : [select Id 
                                     from Forecast_Billing__c 
                                     where (Opportunity_Forecast__r.Opportunity__c IN :map_oppyId_PLMId.keySet() 
                                     OR Opportunity_Part__r.Opportunity__c IN :map_oppyId_PLMId.keySet())
                                     and Date__c = : startDate
                                     and RecordTypeId = :fbillingrt]) {
            list_fbs4delete.add(fb);
        }
        
        if(list_fbs4delete.size() > 0) {
            delete list_fbs4delete;
        }
        
        system.debug('**@@ set_plmIds = ' + set_plmIds);
        system.debug('**@@ map_oppyId_PLMId = ' + map_oppyId_PLMId);
        //get all opportunity forecast in the account's Opprotunities.Contain Quarterly and Monthly.
        for(Opportunity_Forecast__c ofcast : [select Part__r.Part__c, Id, Part__r.PLM_Id__c, Part__r.RecordTypeId, 
                                             Opportunity__r.Level__c,  Part__c, CurrencyIsoCode, 
                                             POS_Amount__c, Direct_Amount__c, Date__c, Opportunity__c  
                                             from Opportunity_Forecast__c 
                                             where Opportunity__c IN :map_oppyId_PLMId.keySet() 
                                             and Part__c != null  //added by Jinbo Shan 2015-11-23
                                             and (Part__r.PLM_Id__c IN :set_plmIds or Part__r.PLM_Id__c = null) // or Part__r.PLM_Id__c = null added by Jinbo Shan 2015-11-04 for propesol part.
                                             and (((Opportunity__r.Level__c = 'Quarterly' or Opportunity__r.Level__c = 'Yearly') and Fiscal_Quarter__c = :('0' + currentQuarter) and Fiscal_Year__c = :currentYear) 
                                             or (Opportunity__r.Level__c = 'Monthly' and Fiscal_Month__c = :currentMonthString and Fiscal_Year__c = :currentYear))]) {
            if(map_oppyId_PLMId.get(ofcast.Opportunity__c) == ofcast.Part__r.PLM_Id__c || ofcast.Part__r.PLM_Id__c == null) {
                hasForecast = true;
                
                if (ofcast.Part__r.Part__c != null) {//added by Jinbo Shan 2015-11-23
                    set_partIds4filter.add(ofcast.Part__r.Part__c);
                    
                }
                set_oppyPartIds4filter.add(ofcast.Part__c);//added by Jinbo Shan 2015-12-07
                
                set_fcIds4filter.add(ofcast.Id);
                set_forecastdate4filter.add(ofcast.Date__c);
                set_ofs.add(ofcast);
            }
        }
        system.debug('**@@set_fcIds4filter = ' + set_fcIds4filter);
        system.debug('**@@set_partIds4filter = ' + set_partIds4filter);
        
        if(hasForecast){
            
            map<Id, map<Id, map<Date, map<string, map<string, map<Id, map<string, Forecast_Billing__c>>>>>>> map_oppyId_partId_date_reseller_type_accId_currency_fbs = new map<Id, map<Id, map<Date, map<string, map<string, map<Id, map<string, Forecast_Billing__c>>>>>>>();
            
            map<Id, map<Date, map<string, Forecast_Snapshot__c>>> map_oppyPartId_forecastdate_type_fss = new map<Id, map<Date, map<string, Forecast_Snapshot__c>>>();//for existing forecast snapshot
            
            map<Id, map<string, map<string, set<BBB_Year_Bill_Book_Cust_PN__c>>>> map_partId_year_plmId_set_ybbcps = new map<Id, map<string, map<string, set<BBB_Year_Bill_Book_Cust_PN__c>>>>();
            
            //found forecast snapshot by Account Id, Part Id, Forecast Date.
            for(Forecast_Snapshot__c fs : [select Id, Date__c, Opportunity__c, 
                                          Part__c, Snapshot_Type__c, Direct_Amount__c, 
                                          POS_Amount__c, CurrencyIsoCode, Opportunity__r.Level__c 
                                          from Forecast_Snapshot__c 
                                          where Part__c IN :set_oppyPartIds4filter 
                                          and Opportunity__c IN :map_oppyId_PLMId.keySet() 
                                          and Date__c IN :set_forecastdate4filter]) {
                if(!map_oppyPartId_forecastdate_type_fss.containsKey(fs.Part__c)) {
                    map_oppyPartId_forecastdate_type_fss.put(fs.Part__c, new map<Date, map<string, Forecast_Snapshot__c>>());
                }
                if(!map_oppyPartId_forecastdate_type_fss.get(fs.Part__c).containsKey(fs.Date__c)) {
                    map_oppyPartId_forecastdate_type_fss.get(fs.Part__c).put(fs.Date__c, new map<string, Forecast_Snapshot__c>());
                }
                if(!map_oppyPartId_forecastdate_type_fss.get(fs.Part__c).get(fs.Date__c).containsKey(fs.Snapshot_Type__c)) {
                    map_oppyPartId_forecastdate_type_fss.get(fs.Part__c).get(fs.Date__c).put(fs.Snapshot_Type__c, fs);
                }
            }
            
            map<Id, map<String, map<string, decimal>>> map_oppyId_plmId_currency_billing = new map<Id, map<String, map<string, decimal>>>();//added by JInbo Shan 2015-12-09
            
            //get all existing yearly billing booking except that the type of billing is CMA in current year.
            for(BBB_Year_Bill_Book_Cust_PN__c ybbcp : [select Id, Customer__c, Part__c, Year__c, 
                                                      Billings_Month_1__c, Bill_Type__c, 
                                                      Billings_Month_10__c, Billings_Month_11__c, 
                                                      Billings_Month_12__c, Billings_Month_3__c, 
                                                      Billings_Month_2__c, Billings_Month_4__c, 
                                                      Billings_Month_5__c, Billings_Month_6__c, 
                                                      Billings_Month_7__c, Billings_Month_8__c,
                                                      Billings_Month_9__c, CurrencyIsoCode, 
                                                      Reseller_Account_Name_Account_Number__c, 
                                                      Customer_Part__c, PLM_ID__c  
                                                      from BBB_Year_Bill_Book_Cust_PN__c 
                                                      where 
                                                      //Part__c IN :set_partIds4filter
                                                      Year__c = :currentYear 
                                                      and PLM_ID__c IN :map_oppyId_PLMId.values() //added by Jinbo Shan 2015-11-04 billing based on PLM Id
                                                      and Bill_Type__c != 'CMA' 
                                                      and Bill_Type__c != 'POS']) {
                if(!map_partId_year_plmId_set_ybbcps.containsKey(ybbcp.Part__c)) {
                    map_partId_year_plmId_set_ybbcps.put(ybbcp.Part__c, new map<string, map<string, set<BBB_Year_Bill_Book_Cust_PN__c>>>());
                }
                if(!map_partId_year_plmId_set_ybbcps.get(ybbcp.Part__c).containsKey(ybbcp.Year__c)) {
                    map_partId_year_plmId_set_ybbcps.get(ybbcp.Part__c).put(ybbcp.Year__c, new map<string, set<BBB_Year_Bill_Book_Cust_PN__c>>());
                }
                if (!map_partId_year_plmId_set_ybbcps.get(ybbcp.Part__c).get(ybbcp.Year__c).containsKey(ybbcp.PLM_ID__c)) {
                    map_partId_year_plmId_set_ybbcps.get(ybbcp.Part__c).get(ybbcp.Year__c).put(ybbcp.PLM_ID__c, new set<BBB_Year_Bill_Book_Cust_PN__c>());
                }
                map_partId_year_plmId_set_ybbcps.get(ybbcp.Part__c).get(ybbcp.Year__c).get(ybbcp.PLM_ID__c).add(ybbcp);
                
                //added by JInbo Shan 2015-12-09
                decimal currentMonthBilling = 0;
                if(ybbcp.get('Billings_Month_' + currentMonth + '__c') != null) {
                    currentMonthBilling = decimal.valueOf(string.valueOf(ybbcp.get('Billings_Month_' + currentMonth + '__c')));
                    //currentMonthBilling = ClsOppyUtil.transformIsoCode(currentMonthBilling, ybbcp.CurrencyIsoCode, 'USD');
                }
                for(Id oppyId : map_oppyId_PLMId.keySet()) {
                    
                    if(map_oppyId_PLMId.get(oppyId) == ybbcp.PLM_ID__c) {
                        if(!map_oppyId_plmId_currency_billing.containsKey(oppyId)) {
                            map_oppyId_plmId_currency_billing.put(oppyId, new map<String, map<string, decimal>>());
                        }
                        if(!map_oppyId_plmId_currency_billing.get(oppyId).containsKey(ybbcp.PLM_ID__c)) {
                            map_oppyId_plmId_currency_billing.get(oppyId).put(ybbcp.PLM_ID__c, new map<string, decimal>());
                        }
                        decimal beforeBilling=0;
                        if(map_oppyId_plmId_currency_billing.get(oppyId).get(ybbcp.PLM_ID__c).containsKey(ybbcp.CurrencyIsoCode)) {
                            beforeBilling = map_oppyId_plmId_currency_billing.get(oppyId).get(ybbcp.PLM_ID__c).get(ybbcp.CurrencyIsoCode);
                        }
                        map_oppyId_plmId_currency_billing.get(oppyId).get(ybbcp.PLM_ID__c).put(ybbcp.CurrencyIsoCode, beforeBilling + currentMonthBilling);
                    }
                }
                
                
            }
            system.debug('**@@map_oppyId_plmId_currency_billing = ' + map_oppyId_plmId_currency_billing);
            //map<Id, Opportunity_Forecast__c> map_ofcId_ofc4QY = new map<Id, Opportunity_Forecast__c>();
            list<Forecast_Billing__c> list_fbs4upsert = new list<Forecast_Billing__c>();
            
            //list<Forecast_Billing__c> list_fbs4update = new list<Forecast_Billing__c>();
            //
            for(Opportunity_Forecast__c ofcast : set_ofs) {
                boolean isUpdateOppyForecast = false;
                
                //get forecast snapshot Id for forecast billing and set POS_Amount__c and Direct_Amount__c for forecast snapshot.
                Id fsWonId;
                Id fsApproveId;
                if(map_oppyPartId_forecastdate_type_fss.containsKey(ofcast.Part__c) && map_oppyPartId_forecastdate_type_fss.get(ofcast.Part__c).containsKey(ofcast.Date__c)) {
                    Forecast_Snapshot__c fsTemp;
                    if(map_oppyPartId_forecastdate_type_fss.get(ofcast.Part__c).get(ofcast.Date__c).containsKey('Approval')) {
                        fsTemp = map_oppyPartId_forecastdate_type_fss.get(ofcast.Part__c).get(ofcast.Date__c).get('Approval');
                        fsApproveId = fsTemp.Id;
                        fsTemp.POS_Amount__c = 0;
                        fsTemp.Direct_Amount__c = 0;
                                
                    }
                    if(map_oppyPartId_forecastdate_type_fss.get(ofcast.Part__c).get(ofcast.Date__c).containsKey('Won')) {
                        fsTemp = map_oppyPartId_forecastdate_type_fss.get(ofcast.Part__c).get(ofcast.Date__c).get('Won');
                        fsWonId = fsTemp.Id;
                        fsTemp.POS_Amount__c = 0;
                        fsTemp.Direct_Amount__c = 0;
                    }
                }
                
                if(map_partId_year_plmId_set_ybbcps.containsKey(ofcast.Part__r.Part__c) && map_partId_year_plmId_set_ybbcps.get(ofcast.Part__r.Part__c).containsKey(currentYear) && map_partId_year_plmId_set_ybbcps.get(ofcast.Part__r.Part__c).get(currentYear).containsKey(map_oppyId_PLMId.get(ofcast.Opportunity__c))) {
                    
                    ofcast.POS_Amount__c = 0;
                    ofcast.Direct_Amount__c = 0;
                    //map_ofcId_ofc4QY.put(ofcast.Id, ofcast);
                    
                    for(BBB_Year_Bill_Book_Cust_PN__c ybbcp : map_partId_year_plmId_set_ybbcps.get(ofcast.Part__r.Part__c).get(currentYear).get(map_oppyId_PLMId.get(ofcast.Opportunity__c))) {
                        decimal currentMonthBilling = 0;
                        system.debug('**@@ybbcp = ' + ybbcp);
                        if(ybbcp.get('Billings_Month_' + currentMonth + '__c') != null) {
                            currentMonthBilling = decimal.valueOf(string.valueOf(ybbcp.get('Billings_Month_' + currentMonth + '__c')));
                        }   
                        
                        //added by Jinbo Shan 2015-12-09
                        if(map_oppyId_plmId_currency_billing.containsKey(ofcast.Opportunity__c) 
                            && map_oppyId_plmId_currency_billing.get(ofcast.Opportunity__c).containsKey(ybbcp.PLM_Id__c) 
                            && map_oppyId_plmId_currency_billing.get(ofcast.Opportunity__c).get(ybbcp.PLM_Id__c).containsKey(ybbcp.CurrencyIsoCode)) {
                            map_oppyId_plmId_currency_billing.get(ofcast.Opportunity__c).get(ybbcp.PLM_Id__c).put(ybbcp.CurrencyIsoCode, map_oppyId_plmId_currency_billing.get(ofcast.Opportunity__c).get(ybbcp.PLM_Id__c).get(ybbcp.CurrencyIsoCode) - currentMonthBilling);
                        }
                        
                        system.debug('**@@ map_oppyId_partId_date_reseller_type_accId_currency_fbs  = ' + map_oppyId_partId_date_reseller_type_accId_currency_fbs);
                        system.debug('**@@ ofcast.Opportunity__c  = ' + ofcast.Opportunity__c);
                        system.debug('**@@ ofcast.Part__r.Part__c  = ' + ofcast.Part__r.Part__c);
                        system.debug('**@@ startDate  = ' + startDate);
                        system.debug('**@@ ybbcp.Bill_Type__c  = ' + ybbcp.Bill_Type__c);
                        //check existing forecast billing, then update or insert forecast billing
                        if(map_oppyId_partId_date_reseller_type_accId_currency_fbs.containsKey(ofcast.Opportunity__c) && map_oppyId_partId_date_reseller_type_accId_currency_fbs.get(ofcast.Opportunity__c).containsKey(ofcast.Part__r.Part__c) && map_oppyId_partId_date_reseller_type_accId_currency_fbs.get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).containsKey(startDate) && map_oppyId_partId_date_reseller_type_accId_currency_fbs.get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).get(startDate).containsKey(ybbcp.Reseller_Account_Name_Account_Number__c) && map_oppyId_partId_date_reseller_type_accId_currency_fbs.get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).get(startDate).get(ybbcp.Reseller_Account_Name_Account_Number__c).containsKey(ybbcp.Bill_Type__c) && map_oppyId_partId_date_reseller_type_accId_currency_fbs.get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).get(startDate).get(ybbcp.Reseller_Account_Name_Account_Number__c).get(ybbcp.Bill_Type__c).containsKey(ybbcp.Customer__c) && map_oppyId_partId_date_reseller_type_accId_currency_fbs.get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).get(startDate).get(ybbcp.Reseller_Account_Name_Account_Number__c).get(ybbcp.Bill_Type__c).get(ybbcp.Customer__c).containsKey(ybbcp.CurrencyIsoCode)) {
                            (map_oppyId_partId_date_reseller_type_accId_currency_fbs.get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).get(startDate).get(ybbcp.Reseller_Account_Name_Account_Number__c).get(ybbcp.Bill_Type__c).get(ybbcp.Customer__c).get(ybbcp.CurrencyIsoCode)).Amount__c += currentMonthBilling;
                            if((map_oppyId_partId_date_reseller_type_accId_currency_fbs.get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).get(startDate).get(ybbcp.Reseller_Account_Name_Account_Number__c).get(ybbcp.Bill_Type__c).get(ybbcp.Customer__c).get(ybbcp.CurrencyIsoCode)).Customer_Part__c == '' || (map_oppyId_partId_date_reseller_type_accId_currency_fbs.get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).get(startDate).get(ybbcp.Reseller_Account_Name_Account_Number__c).get(ybbcp.Bill_Type__c).get(ybbcp.Customer__c).get(ybbcp.CurrencyIsoCode)).Customer_Part__c == null){
                                (map_oppyId_partId_date_reseller_type_accId_currency_fbs.get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).get(startDate).get(ybbcp.Reseller_Account_Name_Account_Number__c).get(ybbcp.Bill_Type__c).get(ybbcp.Customer__c).get(ybbcp.CurrencyIsoCode)).Customer_Part__c = ybbcp.Customer_Part__c;
                            }else {
                                (map_oppyId_partId_date_reseller_type_accId_currency_fbs.get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).get(startDate).get(ybbcp.Reseller_Account_Name_Account_Number__c).get(ybbcp.Bill_Type__c).get(ybbcp.Customer__c).get(ybbcp.CurrencyIsoCode)).Customer_Part__c += ';' + ybbcp.Customer_Part__c;
                            }
                        }else {
                            Forecast_Billing__c fb4insert = new Forecast_Billing__c();
                            //fb4insert.Key__c = keyOfForecastBilling;
                            fb4insert.RecordTypeId = fbillingrt;
                            fb4insert.Date__c = startDate;
                            fb4insert.CurrencyIsoCode = ybbcp.CurrencyIsoCode;
                            fb4insert.Opportunity_Forecast__c = ofcast.Id;
                            fb4insert.Opportunity_Part__c = ofcast.Part__c;
                            fb4insert.Won_Forecast_Snapshot__c = fsWonId;
                            fb4insert.Approval_Forecast_Snapshot__c = fsApproveId;
                            fb4insert.Bill_Type__c = ybbcp.Bill_Type__c;
                            fb4insert.Amount__c = currentMonthBilling;
                            fb4insert.Reseller__c = ybbcp.Reseller_Account_Name_Account_Number__c;
                            fb4insert.Customer_Part__c = ybbcp.Customer_Part__c;
                            fb4insert.Account_From_BBB__c = ybbcp.Customer__c;
                            fb4insert.Load_Status__c = loadStatusId;//added by Jinbo Shan to add load status Id for forecast billing
                            system.debug('**@@currentMonthBilling = ' + currentMonthBilling);
                            if(!map_oppyId_partId_date_reseller_type_accId_currency_fbs.containsKey(ofcast.Opportunity__c)) {
                                map_oppyId_partId_date_reseller_type_accId_currency_fbs.put(ofcast.Opportunity__c, new map<Id, map<Date, map<string, map<string, map<Id, map<string, Forecast_Billing__c>>>>>>());
                            }
                            if(!map_oppyId_partId_date_reseller_type_accId_currency_fbs.get(ofcast.Opportunity__c).containsKey(ofcast.Part__r.Part__c)) {
                                map_oppyId_partId_date_reseller_type_accId_currency_fbs.get(ofcast.Opportunity__c).put(ofcast.Part__r.Part__c, new map<Date, map<string, map<string, map<Id, map<string, Forecast_Billing__c>>>>>());
                            }
                            if(!map_oppyId_partId_date_reseller_type_accId_currency_fbs.get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).containsKey(startDate)){
                                map_oppyId_partId_date_reseller_type_accId_currency_fbs.get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).put(startDate, new map<string, map<string, map<Id, map<string, Forecast_Billing__c>>>>());
                            }
                            if(!map_oppyId_partId_date_reseller_type_accId_currency_fbs.get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).get(startDate).containsKey(ybbcp.Reseller_Account_Name_Account_Number__c)){
                                map_oppyId_partId_date_reseller_type_accId_currency_fbs.get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).get(startDate).put(ybbcp.Reseller_Account_Name_Account_Number__c, new map<string, map<Id, map<string, Forecast_Billing__c>>>());
                            }
                            if(!map_oppyId_partId_date_reseller_type_accId_currency_fbs.get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).get(startDate).get(ybbcp.Reseller_Account_Name_Account_Number__c).containsKey(ybbcp.Bill_Type__c)) {
                                map_oppyId_partId_date_reseller_type_accId_currency_fbs.get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).get(startDate).get(ybbcp.Reseller_Account_Name_Account_Number__c).put(ybbcp.Bill_Type__c, new map<Id, map<string, Forecast_Billing__c>>());
                            }
                            if(!map_oppyId_partId_date_reseller_type_accId_currency_fbs.get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).get(startDate).get(ybbcp.Reseller_Account_Name_Account_Number__c).get(ybbcp.Bill_Type__c).containsKey(ybbcp.Customer__c)) {
                                map_oppyId_partId_date_reseller_type_accId_currency_fbs.get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).get(startDate).get(ybbcp.Reseller_Account_Name_Account_Number__c).get(ybbcp.Bill_Type__c).put(ybbcp.Customer__c, new map<string, Forecast_Billing__c>());
                            }
                            if(!map_oppyId_partId_date_reseller_type_accId_currency_fbs.get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).get(startDate).get(ybbcp.Reseller_Account_Name_Account_Number__c).get(ybbcp.Bill_Type__c).get(ybbcp.Customer__c).containsKey(ybbcp.CurrencyIsoCode)) {
                                map_oppyId_partId_date_reseller_type_accId_currency_fbs.get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).get(startDate).get(ybbcp.Reseller_Account_Name_Account_Number__c).get(ybbcp.Bill_Type__c).get(ybbcp.Customer__c).put(ybbcp.CurrencyIsoCode, fb4insert);
                            }
                        }
                        system.debug('**@@ map_oppyId_partId_date_reseller_type_accId_currency_fbs  = ' + map_oppyId_partId_date_reseller_type_accId_currency_fbs);
                        
                        //fsApproveId = null;
                        //fsWonId = null;
                    }
                } else {
                    Forecast_Billing__c fb4insert = new Forecast_Billing__c();
                    //fb4insert.Key__c = keyOfForecastBilling;
                    fb4insert.Date__c = startDate;
                    //fb4insert.CurrencyIsoCode = ybbcp.CurrencyIsoCode;
                    fb4insert.Opportunity_Forecast__c = ofcast.Id;
                    fb4insert.Opportunity_Part__c = ofcast.Part__c;
                    fb4insert.Won_Forecast_Snapshot__c = fsWonId;
                    fb4insert.Approval_Forecast_Snapshot__c = fsApproveId;
                    fb4insert.Bill_Type__c = 'Direct';
                    fb4insert.RecordTypeId = fbillingrt;
                    fb4insert.Amount__c = 0;
                    //fb4insert.Reseller__c = ybbcp.Reseller_Account_Name_Account_Number__c;
                    //fb4insert.Customer_Part__c = ybbcp.Customer_Part__c;
                    fb4insert.Load_Status__c = loadStatusId;
                    list_fbs4upsert.add(fb4insert);
                }
            }
            
            //calculate all forecast billing that should be upsert from the map map_oppyId_partId_date_reseller_type_accId_currency_fbs;
            for(Id oppyIdTemp : map_oppyId_partId_date_reseller_type_accId_currency_fbs.keySet()) {
                for(Id partIdTemp : map_oppyId_partId_date_reseller_type_accId_currency_fbs.get(oppyIdTemp).keySet()) {
                    for(date startDateTemp : map_oppyId_partId_date_reseller_type_accId_currency_fbs.get(oppyIdTemp).get(partIdTemp).keySet()) {
                        for(string resellerTemp : map_oppyId_partId_date_reseller_type_accId_currency_fbs.get(oppyIdTemp).get(partIdTemp).get(startDateTemp).keySet()) {
                            for(string typeTemp : map_oppyId_partId_date_reseller_type_accId_currency_fbs.get(oppyIdTemp).get(partIdTemp).get(startDateTemp).get(resellerTemp).keySet()){
                                for(Id accIdTemp : map_oppyId_partId_date_reseller_type_accId_currency_fbs.get(oppyIdTemp).get(partIdTemp).get(startDateTemp).get(resellerTemp).get(typeTemp).keySet()) {
                                    list_fbs4upsert.addAll(map_oppyId_partId_date_reseller_type_accId_currency_fbs.get(oppyIdTemp).get(partIdTemp).get(startDateTemp).get(resellerTemp).get(typeTemp).get(accIdTemp).values());
                                }
                            }
                        }
                    }
                }
            }
            
            system.debug('**@@list_fbs4upsert = ' + list_fbs4upsert);
            if(list_fbs4upsert.size() > 0) {
                upsert list_fbs4upsert;
            }
            set<Id> set_fbId = new set<Id>();
            for(Forecast_Billing__c fb : list_fbs4upsert) {
                set_fbId.add(fb.Id);
            }
            
            list<Forecast_Billing__c> list_fbs4update = new list<Forecast_Billing__c>();
            map<Id, Forecast_Billing__c> map_oppyId_proposolfb = new map<Id, Forecast_Billing__c>();
            for(Forecast_Billing__c fb : [select Date__c, Opportunity_Forecast__c, Opportunity_Part__c, 
                                        Won_Forecast_Snapshot__c, Approval_Forecast_Snapshot__c, Bill_Type__c, 
                                        Reseller__c, Customer_Part__c, Account_From_BBB__c, Load_Status__c, 
                                        Opportunity_Part__r.Opportunity__c, CurrencyIsoCode, Amount__c 
                                        from Forecast_Billing__c 
                                        where Id IN :set_fbId 
                                        and Opportunity_Part__r.RecordTypeId != :salesPartRTId]) {
                map_oppyId_proposolfb.put(fb.Opportunity_Part__r.Opportunity__c, fb);
                /*if(map_oppyId_plmId_currency_billing.containsKey(fb.Opportunity_Part__r.Opportunity__c)) {
                    for(string plmId : map_oppyId_plmId_currency_billing.get(fb.Opportunity_Part__r.Opportunity__c).keySet()) {
                        if(map_oppyId_plmId_currency_billing.get(fb.Opportunity_Part__r.Opportunity__c).get(plmId).containsKey(fb.CurrencyIsoCode)) {
                            fb.Amount__c += map_oppyId_plmId_currency_billing.get(fb.Opportunity_Part__r.Opportunity__c).get(plmId).get(fb.CurrencyIsoCode);
                        }
                        map_oppyId_plmId_currency_billing.get(fb.Opportunity_Part__r.Opportunity__c).get(plmId).remove(fb.CurrencyIsoCode);
                        list_fbs4update.add(fb);
                    }
                }*/
            }
            //added by Jinbo Shan for different currency for proposal part.
            list<Forecast_Billing__c> list_fbsinsert4proposal = new list<Forecast_Billing__c>();
            
            for(Id oppyId : map_oppyId_plmId_currency_billing.keySet()) {
                for(string PLMId : map_oppyId_plmId_currency_billing.get(oppyId).keySet()) {
                    for(string currencyType : map_oppyId_plmId_currency_billing.get(oppyId).get(PLMId).keySet()) {
                        if(map_oppyId_proposolfb.containsKey(oppyId)) {
                            Forecast_Billing__c fb = map_oppyId_proposolfb.get(oppyId);
                            if(map_oppyId_proposolfb.get(oppyId).CurrencyIsoCode == currencyType) {
                                fb.Amount__c += map_oppyId_plmId_currency_billing.get(fb.Opportunity_Part__r.Opportunity__c).get(plmId).get(fb.CurrencyIsoCode);
                                list_fbs4update.add(fb);
                            }else {
                                Forecast_Billing__c fb4insert = new Forecast_Billing__c();
                                fb4insert.RecordTypeId = fbillingrt;
                                fb4insert.Date__c = fb.Date__c;
                                fb4insert.CurrencyIsoCode = currencyType;
                                fb4insert.Opportunity_Forecast__c = fb.Opportunity_Forecast__c;
                                fb4insert.Opportunity_Part__c = fb.Opportunity_Part__c;
                                fb4insert.Won_Forecast_Snapshot__c = fb.Won_Forecast_Snapshot__c;
                                fb4insert.Approval_Forecast_Snapshot__c = fb.Approval_Forecast_Snapshot__c;
                                fb4insert.Bill_Type__c = fb.Bill_Type__c;
                                fb4insert.Amount__c = map_oppyId_plmId_currency_billing.get(fb.Opportunity_Part__r.Opportunity__c).get(plmId).get(currencyType);
                                fb4insert.Reseller__c = fb.Reseller__c;
                                fb4insert.Customer_Part__c = fb.Customer_Part__c;
                                fb4insert.Account_From_BBB__c = fb.Account_From_BBB__c;
                                fb4insert.Load_Status__c = fb.Load_Status__c;
                                list_fbsinsert4proposal.add(fb4insert);
                            }
                        }
                        
                    }
                }
            }
            system.debug('**@@@' + list_fbs4update);
            if(list_fbs4update.size() > 0) {
                update list_fbs4update;
            }
            system.debug('**@@@' + list_fbsinsert4proposal);
            
            if(list_fbsinsert4proposal.size() > 0) {
                insert list_fbsinsert4proposal;
            }
            //end
            
            //map<Id, map<Id, map<Date, set<Id>>>> map_accId_partId_fbDate_set_fbIds = new map<Id, map<Id, map<Date, set<Id>>>>();
            //map<Id, map<Id, map<Date, set<Id>>>> map_accId_partId_fbDate_set_ofcIds = new map<Id, map<Id, map<Date, set<Id>>>>();
            map<Id, Forecast_Billing__c> map_fbId_fb = new map<Id, Forecast_Billing__c>();
            //map<string, set<Id>> map_key_set_fbIds = new map<string, set<Id>>();
            //map<string, set<Id>> map_key_set_ofcIds = new map<string, set<Id>>();
            
            //we should not recalculate the pos and direct amount in PLM, because we calculated that in privious batch.
            /*for(Forecast_Billing__c fb : [select Id, Date__c, 
                                          Opportunity_Part__r.Part__c, Amount__c, Won_Forecast_Snapshot__c, 
                                          Reseller__c, Duplicate_Checkbox__c, Opportunity_Forecast__c, CurrencyIsoCode, 
                                          Duplicate_Records__c, Bill_Type__c, Customer_Part__c, POS_Amount__c, 
                                          Direct_Amount__c, Opportunity_Forecast__r.Opportunity__r.Level__c 
                                          from Forecast_Billing__c 
                                          where Opportunity_Forecast__c IN : map_ofcId_ofc4QY.keySet() 
                                          and Date__c <= :startDate 
                                          and Date__c >= :startDate4quarter
                                          and RecordTypeId = '012c00000004uhO']) {
                if(fb.Opportunity_Forecast__r.Opportunity__r.Level__c == 'Monthly') {
                    if(fb.Date__c == startDate) {
                        map_ofcId_ofc4QY.get(fb.Opportunity_Forecast__c).POS_Amount__c += ClsOppyUtil.transformIsoCode(fb.POS_Amount__c, fb.CurrencyIsoCode, map_ofcId_ofc4QY.get(fb.Opportunity_Forecast__c).CurrencyIsoCode);
                        map_ofcId_ofc4QY.get(fb.Opportunity_Forecast__c).Direct_Amount__c += ClsOppyUtil.transformIsoCode(fb.Direct_Amount__c, fb.CurrencyIsoCode, map_ofcId_ofc4QY.get(fb.Opportunity_Forecast__c).CurrencyIsoCode);
                    }
                }else {
                    map_ofcId_ofc4QY.get(fb.Opportunity_Forecast__c).POS_Amount__c += ClsOppyUtil.transformIsoCode(fb.POS_Amount__c, fb.CurrencyIsoCode, map_ofcId_ofc4QY.get(fb.Opportunity_Forecast__c).CurrencyIsoCode);
                    map_ofcId_ofc4QY.get(fb.Opportunity_Forecast__c).Direct_Amount__c += ClsOppyUtil.transformIsoCode(fb.Direct_Amount__c, fb.CurrencyIsoCode, map_ofcId_ofc4QY.get(fb.Opportunity_Forecast__c).CurrencyIsoCode);
                }
                
                if(fb.Date__c == startDate) {
                    string key = '' + (Id)fb.Opportunity_Forecast__r.Opportunity__r.AccountId + (Id)fb.Opportunity_Part__r.Part__c + fb.Reseller__c + fb.Bill_Type__c;
                    if(!map_key_set_fbIds.containsKey(key)) {
                        map_key_set_fbIds.put(key, new set<Id>());
                    }
                    map_key_set_fbIds.get(key).add(fb.Id);
                    
                    if(!map_key_set_ofcIds.containsKey(key)) {
                        map_key_set_ofcIds.put(key, new set<Id>());
                    }
                    map_key_set_ofcIds.get(key).add(fb.Opportunity_Forecast__c);
                    if(map_key_set_ofcIds.get(key).size() > 1) {
                        fb.Duplicate_Checkbox__c = true;
                    }
                    map_fbId_fb.put(fb.Id, fb);
                }
            }
            
            for(Opportunity_Forecast__c ofcast : map_ofcId_ofc4QY.values()) {
                if(map_oppyId_partId_forecastdate_type_fss.containsKey(ofcast.Opportunity__c) && map_oppyId_partId_forecastdate_type_fss.get(ofcast.Opportunity__c).containsKey(ofcast.Part__c) && map_oppyId_partId_forecastdate_type_fss.get(ofcast.Opportunity__c).get(ofcast.Part__c).containsKey(ofcast.Date__c)) {
                    for(string approveType : map_oppyId_partId_forecastdate_type_fss.get(ofcast.Opportunity__c).get(ofcast.Part__c).get(ofcast.Date__c).keySet()) {
                        map_oppyId_partId_forecastdate_type_fss.get(ofcast.Opportunity__c).get(ofcast.Part__c).get(ofcast.Date__c).get(approveType).POS_Amount__c = ClsOppyUtil.transformIsoCode(ofcast.POS_Amount__c, ofcast.CurrencyIsoCode, map_oppyId_partId_forecastdate_type_fss.get(ofcast.Opportunity__c).get(ofcast.Part__c).get(ofcast.Date__c).get(approveType).CurrencyIsoCode);
                        map_oppyId_partId_forecastdate_type_fss.get(ofcast.Opportunity__c).get(ofcast.Part__c).get(ofcast.Date__c).get(approveType).Direct_Amount__c = ClsOppyUtil.transformIsoCode(ofcast.Direct_Amount__c, ofcast.CurrencyIsoCode, map_oppyId_partId_forecastdate_type_fss.get(ofcast.Opportunity__c).get(ofcast.Part__c).get(ofcast.Date__c).get(approveType).CurrencyIsoCode);
                    }
                }
            }*/
            
            /*for(string key : map_key_set_fbIds.keySet()) {
                for(Id fbId : map_key_set_fbIds.get(key)) {
                    Forecast_Billing__c fb = map_fbId_fb.get(fbId);
                    for(Id fbIdTemp : map_key_set_fbIds.get(key)) {
                        if(fb.Opportunity_Forecast__c != map_fbId_fb.get(fbIdTemp).Opportunity_Forecast__c) {
                            if(fb.Duplicate_Records__c == null) {
                                fb.Duplicate_Records__c = fbIdTemp;
                            }else {
                                fb.Duplicate_Records__c += ';' + fbIdTemp;
                            }
                        }
                    }
                    list_fbs4update.add(fb);
                }
            }
            system.debug('**@@list_fbs4update = ' + list_fbs4update);
            if(list_fbs4update.size() > 0) {
                update list_fbs4update;
            }*/
            
            //calculate all forecast snapshot that should be updated from the map map_oppyPartId_forecastdate_type_fss;
            for(Id partId : map_oppyPartId_forecastdate_type_fss.keySet()) {
                for(Date forecastDate : map_oppyPartId_forecastdate_type_fss.get(partId).keySet()) {
                    list_fs2update.addAll(map_oppyPartId_forecastdate_type_fss.get(partId).get(forecastDate).values());
                }
            }
            //system.debug('**@@map_ofcId_ofc4QY' + map_ofcId_ofc4QY);
            system.debug('**@@list_fs2update' + list_fs2update);
            /*if(map_ofcId_ofc4QY.size() > 0) {
                update map_ofcId_ofc4QY.values();
            }*/
            if(list_fs2update.size() > 0) {
                update list_fs2update;
            }
        }
        
    }
    
    global void finish(Database.BatchableContext BC) {
        boolean isupdate = false;
        Load_Status__c loadStatus;
        for( Load_Status__c ls : [select Id, Name, Current_Fiscal_Month__c, Fiscal_Working_Days_until_today__c from Load_Status__c where Id= :loadStatusId]) {
            loadStatus = ls;
        }
        if(loadStatus != null) {
            for(Load_Status__c ls : [select Id, Name, Current_Fiscal_Month__c, Fiscal_Working_Days_until_today__c from Load_Status__c where Name = 'BBB_Year_Bill_Book_Cust_PN__c Direct']) {
                loadStatus.Current_Fiscal_Month__c = ls.Current_Fiscal_Month__c;
                loadStatus.Fiscal_Working_Days_until_today__c = ls.Fiscal_Working_Days_until_today__c;
                isupdate = true;
            }
            if(isupdate) {
                update loadStatus;
            }
        }
    }
    
}