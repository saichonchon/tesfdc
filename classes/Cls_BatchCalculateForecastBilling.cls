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
 * 2016-12-20 Pavan T <pavan.temididepati@te.com> 
 * - Modified for Case 901115
 */
global class Cls_BatchCalculateForecastBilling implements Database.Batchable<SObject>,Database.Stateful {
    
    global Date currentDate;
    global String currentYear;
    global Integer currentMonth;
    global Integer currentQuarter;
    global String currentMonthString;
    global Date startDate;
    global string filter;
    global set<Id> sIds = new set<Id>(); // Added by Pavan for Case 901115 
    global set<Id> failedIds = new set<Id>(); // Added by Pavan for Case 901115 
	global boolean testLmt = false; // Added by Pavan for Case 901115 
    global Integer batchSize = 0; // Added by Pavan for Case 901115 
    public Date startDate4quarter;
    public Id fbillingrt;
    
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
    // Start : Added by Pavan for Case 901115 
    global Cls_BatchCalculateForecastBilling (set<id> accIds, Integer idCount, boolean tstLmt){ 
            failedIds = new set<Id>();
			testLmt = tstLmt;
            batchSize = idCount;
        if(!accIds.isEmpty()){
            sIds = accIds; 
            filter = 'id in :sIds';    
        }      
    }    
    // End : Added by Pavan for Case 901115 
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        failedIds = new set<Id>(); // Added by Pavan for Case 901115
        //added by Jinbo Shan to add load status Id for forecast billing
        if(Load_Status_Of_Forecast_Billing__c.getInstance('Regular') != null) {
            loadStatusId = Load_Status_Of_Forecast_Billing__c.getInstance('Regular').Load_Status_Id__c;
        }
        
        for(RecordType rt : [select Id from RecordType where DeveloperName = 'Regular']) {
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
        string query = 'select Id from Account';
        if(filter != null) {
            query += ' where ' + filter;
        }
		// where Industry_Code_Description__c=\'IB\' or Industry_Code_Description__c=\'A&C\'
		// Start : Added by Pavan for Case 901115 
		if(Test.isRunningTest()){
            query = 'select id from account limit 199';
        }
		// End : Added by Pavan for Case 901115 
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<Account> list_accs) { 
        //Start: Added by Pavan for Case 901115 
        Savepoint sp = Database.setSavepoint();
        Boolean govLimitReached = false;
        integer soqlRowCount = 0;
        integer dmlRowCount  = 0;
        //End: Added by Pavan for Case 901115 
        boolean hasForecast = false;
        set<Id> set_accIds = new set<Id>();
        set<Id> set_accIds2filters = new set<Id>();
        set<Id> set_accIds4filter = new set<Id>();
        set<Id> set_partIds4filter = new set<Id>();
        set<Id> set_fcIds4filter = new set<Id>();
        set<Date> set_forecastdate4filter = new set<Date>();
        set<Opportunity_Forecast__c> set_ofs = new set<Opportunity_Forecast__c>();
        
        //list<Opportunity_Forecast__c> list_ofs2update = new list<Opportunity_Forecast__c>();
        list<Forecast_Snapshot__c> list_fs2update = new list<Forecast_Snapshot__c>();
        
        for(Account acc : list_accs) {
            set_accIds.add(acc.Id);
        }
        
        //clear all existing forecast billing for accounts
        list<Forecast_Billing__c> list_fbs4delete = new list<Forecast_Billing__c>();
        
        //start: Modified by Pavan for Case 901115 
        try{
			Database.QueryLocator q1;
			if(Test.isRunningTest() && testLmt == true){
			   	q1 = Database.getQueryLocator([select Id 
                                         from Forecast_Billing__c]);
     		} else {
			   	q1 = Database.getQueryLocator([select Id 
                                         from Forecast_Billing__c 
                                         where (Opportunity_Forecast__r.Opportunity__r.AccountId IN :set_accIds 
                                         or Opportunity_Part__r.Opportunity__r.AccountId IN :set_accIds) 
                                         and Date__c = : startDate 
                                         and RecordTypeId = :fbillingrt]);
			}							 
            Database.QueryLocatorIterator it1 =  q1.iterator();
            while (it1.hasNext() && soqlRowCount <= 49500)
            {     
                if(soqlRowCount <49500){   
                    list_fbs4delete.add((Forecast_Billing__c)it1.next());
                } else {
                            system.debug('1-------> exception');  
                            govLimitReached  = true;
                }  
                soqlRowCount = soqlRowCount + 1;            
            }   
            /* for(Forecast_Billing__c fb : [select Id 
                                         from Forecast_Billing__c 
                                         where (Opportunity_Forecast__r.Opportunity__r.AccountId IN :set_accIds 
                                         or Opportunity_Part__r.Opportunity__r.AccountId IN :set_accIds) 
                                         and Date__c = : startDate 
                                         and RecordTypeId = :fbillingrt ]) {// 
                list_fbs4delete.add(fb);
            }
            */
            if(govLimitReached==false){ 
                if(list_fbs4delete.size() > 0) {
                    dmlRowCount   = dmlRowCount  + list_fbs4delete.size();
                    if(dmlRowCount <= 9990){
                        delete list_fbs4delete;
                    } else { 
                            govLimitReached = true;
                            system.debug('2-------> exception');     
                    } 
                }
                //End: Modified by Pavan for Case 901115 
                /*for(Opportunity oppy : [select Id, AccountId from Opportunity where AccountId IN :set_accIds and IsClosed = true and IsWon = true]) {
                        if(!map_accId_set_oppyIds.containsKey(oppy.AccountId)) {
                            map_accId_set_oppyIds.put(oppy.AccountId, new set<Id>());
                        }
                        map_accId_set_oppyIds.get(oppy.AccountId).add(oppy.Id);
                }*/
                //get all opportunity forecast in the account's Opprotunities.Contain Quarterly and Monthly.
                //Start: Modified by Pavan for Case 901115 
                if(govLimitReached==false){
                    Database.QueryLocator q2 = Database.getQueryLocator([select Part__r.Part__c, Opportunity__r.AccountId, Id, 
                                                         Opportunity__r.Level__c,  Part__c, CurrencyIsoCode, 
                                                         POS_Amount__c, Direct_Amount__c, Date__c, Opportunity__c  
                                                         from Opportunity_Forecast__c 
                                                         where Opportunity__r.IsClosed = true 
                                                         and Opportunity__r.IsWon = true 
                                                         and Opportunity__r.AccountId IN :set_accIds 
                                                         and Part__r.Part__c != null 
                                                         and (((Opportunity__r.Level__c = 'Quarterly' or Opportunity__r.Level__c = 'Yearly') and Fiscal_Quarter__c = :('0' + currentQuarter) and Fiscal_Year__c = :currentYear) 
                                                         or (Opportunity__r.Level__c = 'Monthly' and Fiscal_Month__c = :currentMonthString and Fiscal_Year__c = :currentYear))]);
                    Database.QueryLocatorIterator it2 =  q2.iterator();
                    while (it2.hasNext() && soqlRowCount <= 49500)
                    {     
                        if(soqlRowCount <49500){        
                            Opportunity_Forecast__c ofcast = new Opportunity_Forecast__c();
                            ofcast = (Opportunity_Forecast__c)it2.next();
                            hasForecast = true; 
                            set_partIds4filter.add(ofcast.Part__r.Part__c);
                            set_accIds2filters.add(ofcast.Opportunity__r.AccountId);
                            set_fcIds4filter.add(ofcast.Id);
                            set_forecastdate4filter.add(ofcast.Date__c);
                            set_ofs.add(ofcast);
                        } else {
                                system.debug('3-------> exception');
                                govLimitReached  = true;
                        }   
                        soqlRowCount = soqlRowCount + 1;
                    }   
                            
                    /* for(Opportunity_Forecast__c ofcast : [select Part__r.Part__c, Opportunity__r.AccountId, Id, 
                                                         Opportunity__r.Level__c,  Part__c, CurrencyIsoCode, 
                                                         POS_Amount__c, Direct_Amount__c, Date__c, Opportunity__c  
                                                         from Opportunity_Forecast__c 
                                                         where Opportunity__r.IsClosed = true 
                                                         and Opportunity__r.IsWon = true 
                                                         and Opportunity__r.AccountId IN :set_accIds 
                                                         and Part__r.Part__c != null 
                                                         //and Opportunity__r.RecordType.DeveloperName like '%Engineering%' 
                                                         and (((Opportunity__r.Level__c = 'Quarterly' or Opportunity__r.Level__c = 'Yearly') and Fiscal_Quarter__c = :('0' + currentQuarter) and Fiscal_Year__c = :currentYear) 
                                                         or (Opportunity__r.Level__c = 'Monthly' and Fiscal_Month__c = :currentMonthString and Fiscal_Year__c = :currentYear))]) {
                        
                        hasForecast = true;
                        set_partIds4filter.add(ofcast.Part__r.Part__c);
                        set_accIds2filters.add(ofcast.Opportunity__r.AccountId);
                        set_fcIds4filter.add(ofcast.Id);
                        set_forecastdate4filter.add(ofcast.Date__c);
                        set_ofs.add(ofcast);
                    } */
                    
                    if(hasForecast && govLimitReached==false){
                    //End: Modified by Pavan for Case 901115    
                        map<Id, map<Id, map<Id, map<Date, map<string, map<string, Forecast_Billing__c>>>>>> map_accId_oppyId_partId_date_reseller_type_fbs = new map<Id, map<Id, map<Id, map<Date, map<string, map<string, Forecast_Billing__c>>>>>>();
                        map<Id, map<Id, map<Date, map<string, Forecast_Snapshot__c>>>> map_accId_partId_forecastdate_type_fss = new map<Id, map<Id, map<Date, map<string, Forecast_Snapshot__c>>>>();//for existing forecast snapshot
                        map<Id, map<Id, map<string, set<BBB_Year_Bill_Book_Cust_PN__c>>>> map_accId_partId_year_set_ybbcps = new map<Id, map<Id, map<string, set<BBB_Year_Bill_Book_Cust_PN__c>>>>();
                        
                        //search all existing forecast billing
                        /*for(Forecast_Billing__c fb : [select Id, Date__c, Opportunity_Forecast__r.Opportunity__r.AccountId, 
                                                     Opportunity_Part__r.Part__c, Amount__c, Won_Forecast_Snapshot__c, 
                                                     Reseller__c, Duplicate_Checkbox__c, Key__c, Opportunity_Forecast__c, 
                                                     Duplicate_Records__c, Bill_Type__c, Customer_Part__c 
                                                     from Forecast_Billing__c 
                                                     where Opportunity_Forecast__r.Opportunity__r.AccountId IN :set_accIds2filters 
                                                     and Opportunity_Part__r.Part__c IN :set_partIds4filter 
                                                     and Opportunity_Forecast__c IN:set_fcIds4filter
                                                     and Date__c = : startDate]) {
                            
                            if(!map_accId_oppyId_partId_date_reseller_type_fbs.containsKey(fb.Opportunity_Forecast__r.Opportunity__r.AccountId)) {
                                map_accId_oppyId_partId_date_reseller_type_fbs.put(fb.Opportunity_Forecast__r.Opportunity__r.AccountId, new map<Id, map<Id, map<Date, map<string, map<string, Forecast_Billing__c>>>>>());
                            }
                            if(!map_accId_oppyId_partId_date_reseller_type_fbs.get(fb.Opportunity_Forecast__r.Opportunity__r.AccountId).containsKey(fb.Opportunity_Forecast__r.Opportunity__c)) {
                                map_accId_oppyId_partId_date_reseller_type_fbs.get(fb.Opportunity_Forecast__r.Opportunity__r.AccountId).put(fb.Opportunity_Forecast__r.Opportunity__c, new map<Id, map<Date, map<string, map<string, Forecast_Billing__c>>>>());
                            }
                            if(!map_accId_oppyId_partId_date_reseller_type_fbs.get(fb.Opportunity_Forecast__r.Opportunity__r.AccountId).get(fb.Opportunity_Forecast__r.Opportunity__c).containsKey(fb.Opportunity_Part__r.Part__c)) {
                                map_accId_oppyId_partId_date_reseller_type_fbs.get(fb.Opportunity_Forecast__r.Opportunity__r.AccountId).get(fb.Opportunity_Forecast__r.Opportunity__c).put(fb.Opportunity_Part__r.Part__c, new map<Date, map<string, map<string, Forecast_Billing__c>>>());
                            }
                            if(!map_accId_oppyId_partId_date_reseller_type_fbs.get(fb.Opportunity_Forecast__r.Opportunity__r.AccountId).get(fb.Opportunity_Forecast__r.Opportunity__c).get(fb.Opportunity_Part__r.Part__c).containsKey(fb.Date__c)){
                                map_accId_oppyId_partId_date_reseller_type_fbs.get(fb.Opportunity_Forecast__r.Opportunity__r.AccountId).get(fb.Opportunity_Forecast__r.Opportunity__c).get(fb.Opportunity_Part__r.Part__c).put(fb.Date__c, new map<string, map<string, Forecast_Billing__c>>());
                            }
                            if(!map_accId_oppyId_partId_date_reseller_type_fbs.get(fb.Opportunity_Forecast__r.Opportunity__r.AccountId).get(fb.Opportunity_Forecast__r.Opportunity__c).get(fb.Opportunity_Part__r.Part__c).get(fb.Date__c).containsKey(fb.Reseller__c)){
                                map_accId_oppyId_partId_date_reseller_type_fbs.get(fb.Opportunity_Forecast__r.Opportunity__r.AccountId).get(fb.Opportunity_Forecast__r.Opportunity__c).get(fb.Opportunity_Part__r.Part__c).get(fb.Date__c).put(fb.Reseller__c, new map<string, Forecast_Billing__c>());
                            }
                            if(!map_accId_oppyId_partId_date_reseller_type_fbs.get(fb.Opportunity_Forecast__r.Opportunity__r.AccountId).get(fb.Opportunity_Forecast__r.Opportunity__c).get(fb.Opportunity_Part__r.Part__c).get(fb.Date__c).get(fb.Reseller__c).containsKey(fb.Bill_Type__c)) {
                                fb.Amount__c = 0;
                                fb.Customer_Part__c = '';
                                fb.Duplicate_Checkbox__c = false;
                                fb.Duplicate_Records__c = null;
                                map_accId_oppyId_partId_date_reseller_type_fbs.get(fb.Opportunity_Forecast__r.Opportunity__r.AccountId).get(fb.Opportunity_Forecast__r.Opportunity__c).get(fb.Opportunity_Part__r.Part__c).get(fb.Date__c).get(fb.Reseller__c).put(fb.Bill_Type__c, fb);
                            }
                                
                        }*/
                        //Start: Modified by Pavan for Case 901115
                        //found forecast snapshot by Account Id, Part Id, Forecast Date.
                        Database.QueryLocator q3 = Database.getQueryLocator([select Id, Date__c, Opportunity__r.AccountId, 
                                                      Part__r.Part__c, Snapshot_Type__c, Direct_Amount__c, 
                                                      POS_Amount__c, CurrencyIsoCode, Opportunity__r.Level__c 
                                                      from Forecast_Snapshot__c 
                                                      where Part__r.Part__c IN :set_partIds4filter 
                                                      and Opportunity__r.AccountId IN :set_accIds2filters 
                                                      and Date__c IN :set_forecastdate4filter]);
                        Database.QueryLocatorIterator it3 =  q3.iterator();
                        list<Forecast_Snapshot__c> lstfcs1 = new list<Forecast_Snapshot__c>();
                        while (it3.hasNext() && soqlRowCount <= 49500)
                        {     
                            if(soqlRowCount <49500){        
                                lstfcs1.add((Forecast_Snapshot__c)it3.next());
                                
                            } else {    
                                        system.debug('4-------> exception');
                                        govLimitReached  = true;
                            }    
                            soqlRowCount = soqlRowCount + 1;    
                        }                                 
                                                      
                        /* for(Forecast_Snapshot__c fs : [select Id, Date__c, Opportunity__r.AccountId, 
                                                      Part__r.Part__c, Snapshot_Type__c, Direct_Amount__c, 
                                                      POS_Amount__c, CurrencyIsoCode, Opportunity__r.Level__c 
                                                      from Forecast_Snapshot__c 
                                                      where Part__r.Part__c IN :set_partIds4filter 
                                                      and Opportunity__r.AccountId IN :set_accIds2filters 
                                                      and Date__c IN :set_forecastdate4filter]) {
                        */
                        if(govLimitReached==false){
                            for(Forecast_Snapshot__c fs : lstfcs1){
                            //End: Modified by Pavan for Case 901115
                                if(!map_accId_partId_forecastdate_type_fss.containsKey(fs.Opportunity__r.AccountId)) {
                                    map_accId_partId_forecastdate_type_fss.put(fs.Opportunity__r.AccountId, new map<Id, map<Date, map<string, Forecast_Snapshot__c>>>());
                                }
                                if(!map_accId_partId_forecastdate_type_fss.get(fs.Opportunity__r.AccountId).containsKey(fs.Part__c)) {
                                    map_accId_partId_forecastdate_type_fss.get(fs.Opportunity__r.AccountId).put(fs.Part__c, new map<Date, map<string, Forecast_Snapshot__c>>());
                                }
                                if(!map_accId_partId_forecastdate_type_fss.get(fs.Opportunity__r.AccountId).get(fs.Part__c).containsKey(fs.Date__c)) {
                                    map_accId_partId_forecastdate_type_fss.get(fs.Opportunity__r.AccountId).get(fs.Part__c).put(fs.Date__c, new map<string, Forecast_Snapshot__c>());
                                }
                                if(!map_accId_partId_forecastdate_type_fss.get(fs.Opportunity__r.AccountId).get(fs.Part__c).get(fs.Date__c).containsKey(fs.Snapshot_Type__c)) {
                                    map_accId_partId_forecastdate_type_fss.get(fs.Opportunity__r.AccountId).get(fs.Part__c).get(fs.Date__c).put(fs.Snapshot_Type__c, fs);
                                }
                            }
                            //get all existing yearly billing booking except that the type of billing is CMA in current year.
                            //Start: Modified by Pavan for Case 901115
                            Database.QueryLocator q4 = Database.getQueryLocator([select Id, Customer__c, Part__c, Year__c, 
                                                                      Billings_Month_1__c, Bill_Type__c, 
                                                                      Billings_Month_10__c, Billings_Month_11__c, 
                                                                      Billings_Month_12__c, Billings_Month_3__c, 
                                                                      Billings_Month_2__c, Billings_Month_4__c, 
                                                                      Billings_Month_5__c, Billings_Month_6__c, 
                                                                      Billings_Month_7__c, Billings_Month_8__c,
                                                                      Billings_Month_9__c, CurrencyIsoCode, 
                                                                      Reseller_Account_Name_Account_Number__c, 
                                                                      Customer_Part__c  
                                                                      from BBB_Year_Bill_Book_Cust_PN__c 
                                                                      where Customer__c IN :set_accIds2filters 
                                                                      and Part__c IN :set_partIds4filter
                                                                      and Year__c = :currentYear
                                                                      and Bill_Type__c != 'CMA']);
                            Database.QueryLocatorIterator it4 =  q4.iterator();
                            list<BBB_Year_Bill_Book_Cust_PN__c> lstYbb1 = new list<BBB_Year_Bill_Book_Cust_PN__c>();
                            while (it4.hasNext() && soqlRowCount <= 49500)
                            {     
                                if(soqlRowCount <49500){        
                                    lstYbb1.add((BBB_Year_Bill_Book_Cust_PN__c)it4.next());
                                    
                                } else {    
                                            system.debug('5-------> exception');
                                            govLimitReached  = true;
                                } 
                                soqlRowCount = soqlRowCount + 1;                            
                            }   
                            
                            /*for(BBB_Year_Bill_Book_Cust_PN__c ybbcp : [select Id, Customer__c, Part__c, Year__c, 
                                                                      Billings_Month_1__c, Bill_Type__c, 
                                                                      Billings_Month_10__c, Billings_Month_11__c, 
                                                                      Billings_Month_12__c, Billings_Month_3__c, 
                                                                      Billings_Month_2__c, Billings_Month_4__c, 
                                                                      Billings_Month_5__c, Billings_Month_6__c, 
                                                                      Billings_Month_7__c, Billings_Month_8__c,
                                                                      Billings_Month_9__c, CurrencyIsoCode, 
                                                                      Reseller_Account_Name_Account_Number__c, 
                                                                      Customer_Part__c  
                                                                      from BBB_Year_Bill_Book_Cust_PN__c 
                                                                      where Customer__c IN :set_accIds2filters 
                                                                      and Part__c IN :set_partIds4filter
                                                                      and Year__c = :currentYear
                                                                      and Bill_Type__c != 'CMA']) {
                            */                                        
                            if(govLimitReached==false){
                            //End: Modified by Pavan for Case 901115
                                for(BBB_Year_Bill_Book_Cust_PN__c ybbcp : lstYbb1){
                                    if(!map_accId_partId_year_set_ybbcps.containsKey(ybbcp.Customer__c)) {
                                        map_accId_partId_year_set_ybbcps.put(ybbcp.Customer__c, new map<Id, map<string, set<BBB_Year_Bill_Book_Cust_PN__c>>>());
                                    }
                                    if(!map_accId_partId_year_set_ybbcps.get(ybbcp.Customer__c).containsKey(ybbcp.Part__c)) {
                                        map_accId_partId_year_set_ybbcps.get(ybbcp.Customer__c).put(ybbcp.Part__c, new map<string, set<BBB_Year_Bill_Book_Cust_PN__c>>());
                                    }
                                    if(!map_accId_partId_year_set_ybbcps.get(ybbcp.Customer__c).get(ybbcp.Part__c).containsKey(ybbcp.Year__c)) {
                                        map_accId_partId_year_set_ybbcps.get(ybbcp.Customer__c).get(ybbcp.Part__c).put(ybbcp.Year__c, new set<BBB_Year_Bill_Book_Cust_PN__c>());
                                    }
                                    map_accId_partId_year_set_ybbcps.get(ybbcp.Customer__c).get(ybbcp.Part__c).get(ybbcp.Year__c).add(ybbcp);
                                }
                                system.debug('**@@map_accId_partId_year_set_ybbcps = ' + map_accId_partId_year_set_ybbcps);
                                map<Id, Opportunity_Forecast__c> map_ofcId_ofc4QY = new map<Id, Opportunity_Forecast__c>();
                                list<Forecast_Billing__c> list_fbs4upsert = new list<Forecast_Billing__c>();
                                list<Forecast_Billing__c> list_fbs4update = new list<Forecast_Billing__c>();
                                //
                                for(Opportunity_Forecast__c ofcast : set_ofs) {
                                    boolean isUpdateOppyForecast = false;
                                    string keyOfForecastBilling = (Id)ofcast.Opportunity__r.AccountId + '_' + (Id)ofcast.Opportunity__c + '_' + (Id)ofcast.Part__r.Part__c + '_' + startDate;
                                    
                                    //get forecast snapshot Id for forecast billing and set POS_Amount__c and Direct_Amount__c for forecast snapshot.
                                    Id fsWonId;
                                    Id fsApproveId;
                                    if(map_accId_partId_forecastdate_type_fss.containsKey(ofcast.Opportunity__r.AccountId) && map_accId_partId_forecastdate_type_fss.get(ofcast.Opportunity__r.AccountId).containsKey(ofcast.Part__c) && map_accId_partId_forecastdate_type_fss.get(ofcast.Opportunity__r.AccountId).get(ofcast.Part__c).containsKey(ofcast.Date__c)) {
                                        Forecast_Snapshot__c fsTemp;
                                        if(map_accId_partId_forecastdate_type_fss.get(ofcast.Opportunity__r.AccountId).get(ofcast.Part__c).get(ofcast.Date__c).containsKey('Approval')) {
                                            fsTemp = map_accId_partId_forecastdate_type_fss.get(ofcast.Opportunity__r.AccountId).get(ofcast.Part__c).get(ofcast.Date__c).get('Approval');
                                            fsApproveId = fsTemp.Id;
                                            fsTemp.POS_Amount__c = 0;
                                            fsTemp.Direct_Amount__c = 0;
                                                    
                                        }
                                        if(map_accId_partId_forecastdate_type_fss.get(ofcast.Opportunity__r.AccountId).get(ofcast.Part__c).get(ofcast.Date__c).containsKey('Won')) {
                                            fsTemp = map_accId_partId_forecastdate_type_fss.get(ofcast.Opportunity__r.AccountId).get(ofcast.Part__c).get(ofcast.Date__c).get('Won');
                                            fsWonId = fsTemp.Id;
                                            fsTemp.POS_Amount__c = 0;
                                            fsTemp.Direct_Amount__c = 0;
                                        }
                                    }
                                    
                                    if(map_accId_partId_year_set_ybbcps.containsKey(ofcast.Opportunity__r.AccountId) && map_accId_partId_year_set_ybbcps.get(ofcast.Opportunity__r.AccountId).containsKey(ofcast.Part__r.Part__c) && map_accId_partId_year_set_ybbcps.get(ofcast.Opportunity__r.AccountId).get(ofcast.Part__r.Part__c).containsKey(currentYear)) {
                                        
                                        ofcast.POS_Amount__c = 0;
                                        ofcast.Direct_Amount__c = 0;
                                        map_ofcId_ofc4QY.put(ofcast.Id, ofcast);
                                        
                                        for(BBB_Year_Bill_Book_Cust_PN__c ybbcp : map_accId_partId_year_set_ybbcps.get(ofcast.Opportunity__r.AccountId).get(ofcast.Part__r.Part__c).get(currentYear)) {
                                            decimal currentMonthBilling = 0;
                                            system.debug('**@@ybbcp = ' + ybbcp);
                                            if(ybbcp.get('Billings_Month_' + currentMonth + '__c') != null) {
                                                currentMonthBilling = decimal.valueOf(string.valueOf(ybbcp.get('Billings_Month_' + currentMonth + '__c')));
                                            }   
                                            
                                            system.debug('**@@ map_accId_oppyId_partId_date_reseller_type_fbs  = ' + map_accId_oppyId_partId_date_reseller_type_fbs);
                                            system.debug('**@@ ofcast.Opportunity__r.AccountId  = ' + ofcast.Opportunity__r.AccountId);
                                            system.debug('**@@ ofcast.Opportunity__c  = ' + ofcast.Opportunity__c);
                                            system.debug('**@@ ofcast.Part__r.Part__c  = ' + ofcast.Part__r.Part__c);
                                            system.debug('**@@ startDate  = ' + startDate);
                                            system.debug('**@@ ybbcp.Bill_Type__c  = ' + ybbcp.Bill_Type__c);
                                            //check existing forecast billing, then update or insert forecast billing
                                            if(map_accId_oppyId_partId_date_reseller_type_fbs.containsKey(ofcast.Opportunity__r.AccountId) && map_accId_oppyId_partId_date_reseller_type_fbs.get(ofcast.Opportunity__r.AccountId).containsKey(ofcast.Opportunity__c) && map_accId_oppyId_partId_date_reseller_type_fbs.get(ofcast.Opportunity__r.AccountId).get(ofcast.Opportunity__c).containsKey(ofcast.Part__r.Part__c) && map_accId_oppyId_partId_date_reseller_type_fbs.get(ofcast.Opportunity__r.AccountId).get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).containsKey(startDate) && map_accId_oppyId_partId_date_reseller_type_fbs.get(ofcast.Opportunity__r.AccountId).get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).get(startDate).containsKey(ybbcp.Reseller_Account_Name_Account_Number__c) && map_accId_oppyId_partId_date_reseller_type_fbs.get(ofcast.Opportunity__r.AccountId).get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).get(startDate).get(ybbcp.Reseller_Account_Name_Account_Number__c).containsKey(ybbcp.Bill_Type__c)) {
                                                (map_accId_oppyId_partId_date_reseller_type_fbs.get(ofcast.Opportunity__r.AccountId).get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).get(startDate).get(ybbcp.Reseller_Account_Name_Account_Number__c).get(ybbcp.Bill_Type__c)).Amount__c += ClsOppyUtil.transformIsoCode(currentMonthBilling, ybbcp.CurrencyIsoCode, (map_accId_oppyId_partId_date_reseller_type_fbs.get(ofcast.Opportunity__r.AccountId).get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).get(startDate).get(ybbcp.Reseller_Account_Name_Account_Number__c).get(ybbcp.Bill_Type__c)).CurrencyIsoCode);
                                                if((map_accId_oppyId_partId_date_reseller_type_fbs.get(ofcast.Opportunity__r.AccountId).get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).get(startDate).get(ybbcp.Reseller_Account_Name_Account_Number__c).get(ybbcp.Bill_Type__c)).Customer_Part__c == '' || (map_accId_oppyId_partId_date_reseller_type_fbs.get(ofcast.Opportunity__r.AccountId).get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).get(startDate).get(ybbcp.Reseller_Account_Name_Account_Number__c).get(ybbcp.Bill_Type__c)).Customer_Part__c == null){
                                                    (map_accId_oppyId_partId_date_reseller_type_fbs.get(ofcast.Opportunity__r.AccountId).get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).get(startDate).get(ybbcp.Reseller_Account_Name_Account_Number__c).get(ybbcp.Bill_Type__c)).Customer_Part__c = ybbcp.Customer_Part__c;
                                                }else {
                                                    (map_accId_oppyId_partId_date_reseller_type_fbs.get(ofcast.Opportunity__r.AccountId).get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).get(startDate).get(ybbcp.Reseller_Account_Name_Account_Number__c).get(ybbcp.Bill_Type__c)).Customer_Part__c += ';' + ybbcp.Customer_Part__c;
                                                }
                                            }else {
                                                Forecast_Billing__c fb4insert = new Forecast_Billing__c();
                                                //fb4insert.Key__c = keyOfForecastBilling;
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
                                                fb4insert.RecordTypeId = fbillingrt;
                                                fb4insert.Load_Status__c = loadStatusId;
                                                system.debug('**@@currentMonthBilling = ' + currentMonthBilling);
                                                if(!map_accId_oppyId_partId_date_reseller_type_fbs.containsKey(ofcast.Opportunity__r.AccountId)) {
                                                    map_accId_oppyId_partId_date_reseller_type_fbs.put(ofcast.Opportunity__r.AccountId, new map<Id, map<Id, map<Date, map<string, map<string, Forecast_Billing__c>>>>>());
                                                }
                                                if(!map_accId_oppyId_partId_date_reseller_type_fbs.get(ofcast.Opportunity__r.AccountId).containsKey(ofcast.Opportunity__c)) {
                                                    map_accId_oppyId_partId_date_reseller_type_fbs.get(ofcast.Opportunity__r.AccountId).put(ofcast.Opportunity__c, new map<Id, map<Date, map<string, map<string, Forecast_Billing__c>>>>());
                                                }
                                                if(!map_accId_oppyId_partId_date_reseller_type_fbs.get(ofcast.Opportunity__r.AccountId).get(ofcast.Opportunity__c).containsKey(ofcast.Part__r.Part__c)) {
                                                    map_accId_oppyId_partId_date_reseller_type_fbs.get(ofcast.Opportunity__r.AccountId).get(ofcast.Opportunity__c).put(ofcast.Part__r.Part__c, new map<Date, map<string, map<string, Forecast_Billing__c>>>());
                                                }
                                                if(!map_accId_oppyId_partId_date_reseller_type_fbs.get(ofcast.Opportunity__r.AccountId).get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).containsKey(startDate)){
                                                    map_accId_oppyId_partId_date_reseller_type_fbs.get(ofcast.Opportunity__r.AccountId).get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).put(startDate, new map<string, map<string, Forecast_Billing__c>>());
                                                }
                                                if(!map_accId_oppyId_partId_date_reseller_type_fbs.get(ofcast.Opportunity__r.AccountId).get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).get(startDate).containsKey(ybbcp.Reseller_Account_Name_Account_Number__c)){
                                                    map_accId_oppyId_partId_date_reseller_type_fbs.get(ofcast.Opportunity__r.AccountId).get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).get(startDate).put(ybbcp.Reseller_Account_Name_Account_Number__c, new map<string, Forecast_Billing__c>());
                                                }
                                                if(!map_accId_oppyId_partId_date_reseller_type_fbs.get(ofcast.Opportunity__r.AccountId).get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).get(startDate).get(ybbcp.Reseller_Account_Name_Account_Number__c).containsKey(fb4insert.Bill_Type__c)) {
                                                    map_accId_oppyId_partId_date_reseller_type_fbs.get(ofcast.Opportunity__r.AccountId).get(ofcast.Opportunity__c).get(ofcast.Part__r.Part__c).get(startDate).get(ybbcp.Reseller_Account_Name_Account_Number__c).put(fb4insert.Bill_Type__c, fb4insert);
                                                }
                                            }
                                            system.debug('**@@ map_accId_oppyId_partId_date_reseller_type_fbs  = ' + map_accId_oppyId_partId_date_reseller_type_fbs);
                                            
                                            //fsApproveId = null;
                                            //fsWonId = null;
                                        }
                                    }else {
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
                                        list_fbs4upsert.add(fb4insert);
                                    }
                                }
                                
                                //calculate all forecast billing that should be upsert from the map map_accId_partId_date_type_fb;
                                for(Id accIdTemp : map_accId_oppyId_partId_date_reseller_type_fbs.keySet()) {
                                    for(Id oppyIdTemp : map_accId_oppyId_partId_date_reseller_type_fbs.get(accIdTemp).keySet()) {
                                        for(Id partIdTemp : map_accId_oppyId_partId_date_reseller_type_fbs.get(accIdTemp).get(oppyIdTemp).keySet()) {
                                            for(date startDateTemp : map_accId_oppyId_partId_date_reseller_type_fbs.get(accIdTemp).get(oppyIdTemp).get(partIdTemp).keySet()) {
                                                for(string resellerTemp : map_accId_oppyId_partId_date_reseller_type_fbs.get(accIdTemp).get(oppyIdTemp).get(partIdTemp).get(startDateTemp).keySet()) {
                                                    list_fbs4upsert.addAll(map_accId_oppyId_partId_date_reseller_type_fbs.get(accIdTemp).get(oppyIdTemp).get(partIdTemp).get(startDateTemp).get(resellerTemp).values());
                                                }
                                            }
                                        }
                                    }
                                }
                                system.debug('**@@list_fbs4upsert = ' + list_fbs4upsert);
                                if(list_fbs4upsert.size() > 0) {
                                //Start: Modified by Pavan for Case 901115 
                                    dmlRowCount   = dmlRowCount  + list_fbs4upsert.size();
                                    if(dmlRowCount <= 9990){
                                        upsert list_fbs4upsert;
                                    } else { 
                                            govLimitReached = true;
                                            system.debug('6-------> exception');     
                                    }
                                }
                                if(govLimitReached==false){
                                //End: Modified by Pavan for Case 901115 
                                    //map<Id, map<Id, map<Date, set<Id>>>> map_accId_partId_fbDate_set_fbIds = new map<Id, map<Id, map<Date, set<Id>>>>();
                                    //map<Id, map<Id, map<Date, set<Id>>>> map_accId_partId_fbDate_set_ofcIds = new map<Id, map<Id, map<Date, set<Id>>>>();
                                    map<Id, Forecast_Billing__c> map_fbId_fb = new map<Id, Forecast_Billing__c>();
                                    map<string, set<Id>> map_key_set_fbIds = new map<string, set<Id>>();
                                    map<string, set<Id>> map_key_set_ofcIds = new map<string, set<Id>>();
                                    //Start: Modified by Pavan for Case 901115   
                                    Database.QueryLocator q5 = Database.getQueryLocator([select Id, Date__c, Opportunity_Forecast__r.Opportunity__r.AccountId, 
                                                                  Opportunity_Part__r.Part__c, Amount__c, Won_Forecast_Snapshot__c, 
                                                                  Reseller__c, Duplicate_Checkbox__c, Opportunity_Forecast__c, CurrencyIsoCode, 
                                                                  Duplicate_Records__c, Bill_Type__c, Customer_Part__c, POS_Amount__c, 
                                                                  Direct_Amount__c, Opportunity_Forecast__r.Opportunity__r.Level__c 
                                                                  from Forecast_Billing__c 
                                                                  where Opportunity_Forecast__c IN : map_ofcId_ofc4QY.keySet() 
                                                                  and Date__c <= :startDate 
                                                                  and Date__c >= :startDate4quarter 
                                                                  and RecordTypeId = :fbillingrt]);
                                    Database.QueryLocatorIterator it5 =  q5.iterator();
                                    list<Forecast_Billing__c> lstfb1 = new list<Forecast_Billing__c>();
                                      
                                    while (it5.hasNext() && soqlRowCount <= 49500)
                                    {     
                                        if(soqlRowCount <49500){        
                                            lstfb1.add((Forecast_Billing__c)it5.next());
                                            
                                        } else {
                                                    system.debug('7-------> exception');
                                                    govLimitReached  = true;
                                        } 
                                        soqlRowCount = soqlRowCount + 1;            
                                    }       
                                    if(govLimitReached==false){
                                        /* for(Forecast_Billing__c fb : [select Id, Date__c, Opportunity_Forecast__r.Opportunity__r.AccountId, 
                                                                      Opportunity_Part__r.Part__c, Amount__c, Won_Forecast_Snapshot__c, 
                                                                      Reseller__c, Duplicate_Checkbox__c, Opportunity_Forecast__c, CurrencyIsoCode, 
                                                                      Duplicate_Records__c, Bill_Type__c, Customer_Part__c, POS_Amount__c, 
                                                                      Direct_Amount__c, Opportunity_Forecast__r.Opportunity__r.Level__c 
                                                                      from Forecast_Billing__c 
                                                                      where Opportunity_Forecast__c IN : map_ofcId_ofc4QY.keySet() 
                                                                      and Date__c <= :startDate 
                                                                      and Date__c >= :startDate4quarter 
                                                                      and RecordTypeId = :fbillingrt]) {
                                        */
                                        for(Forecast_Billing__c fb : lstfb1){
                                        //End: Modified by Pavan for Case 901115
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
                                                /*if(!map_accId_partId_fbDate_set_fbIds.containsKey(fb.Opportunity_Forecast__r.Opportunity__r.AccountId)) {
                                                    map_accId_partId_fbDate_set_fbIds.put(fb.Opportunity_Forecast__r.Opportunity__r.AccountId, new map<Id, map<Date, set<Id>>>());
                                                }
                                                if(!map_accId_partId_fbDate_set_ofcIds.containsKey(fb.Opportunity_Forecast__r.Opportunity__r.AccountId)) {
                                                    map_accId_partId_fbDate_set_ofcIds.put(fb.Opportunity_Forecast__r.Opportunity__r.AccountId, new map<Id, map<Date, set<Id>>>());
                                                }
                                                if(!map_accId_partId_fbDate_set_fbIds.get(fb.Opportunity_Forecast__r.Opportunity__r.AccountId).containsKey(fb.Opportunity_Part__r.Part__c)) {
                                                    map_accId_partId_fbDate_set_fbIds.get(fb.Opportunity_Forecast__r.Opportunity__r.AccountId).put(fb.Opportunity_Part__r.Part__c, new map<Date, set<Id>>());
                                                }
                                                if(!map_accId_partId_fbDate_set_ofcIds.get(fb.Opportunity_Forecast__r.Opportunity__r.AccountId).containsKey(fb.Opportunity_Part__r.Part__c)) {
                                                    map_accId_partId_fbDate_set_ofcIds.get(fb.Opportunity_Forecast__r.Opportunity__r.AccountId).put(fb.Opportunity_Part__r.Part__c, new map<Date, set<Id>>());
                                                }
                                                if(!map_accId_partId_fbDate_set_fbIds.get(fb.Opportunity_Forecast__r.Opportunity__r.AccountId).get(fb.Opportunity_Part__r.Part__c).containsKey(startDate)) {
                                                    map_accId_partId_fbDate_set_fbIds.get(fb.Opportunity_Forecast__r.Opportunity__r.AccountId).get(fb.Opportunity_Part__r.Part__c).put(startDate, new set<Id>());
                                                }
                                                if(!map_accId_partId_fbDate_set_ofcIds.get(fb.Opportunity_Forecast__r.Opportunity__r.AccountId).get(fb.Opportunity_Part__r.Part__c).containsKey(startDate)) {
                                                    map_accId_partId_fbDate_set_ofcIds.get(fb.Opportunity_Forecast__r.Opportunity__r.AccountId).get(fb.Opportunity_Part__r.Part__c).put(startDate, new set<Id>());
                                                }
                                                map_accId_partId_fbDate_set_fbIds.get(fb.Opportunity_Forecast__r.Opportunity__r.AccountId).get(fb.Opportunity_Part__r.Part__c).get(startDate).add(fb.Id);
                                                map_accId_partId_fbDate_set_ofcIds.get(fb.Opportunity_Forecast__r.Opportunity__r.AccountId).get(fb.Opportunity_Part__r.Part__c).get(startDate).add(fb.Opportunity_Forecast__c);
                                                if(map_accId_partId_fbDate_set_ofcIds.get(fb.Opportunity_Forecast__r.Opportunity__r.AccountId).get(fb.Opportunity_Part__r.Part__c).get(startDate).size() > 1) {
                                                    fb.Duplicate_Checkbox__c = true;
                                                }*/
                                            }
                                        }
                                        
                                        for(Opportunity_Forecast__c ofcast : map_ofcId_ofc4QY.values()) {
                                            if(map_accId_partId_forecastdate_type_fss.containsKey(ofcast.Opportunity__r.AccountId) && map_accId_partId_forecastdate_type_fss.get(ofcast.Opportunity__r.AccountId).containsKey(ofcast.Part__c) && map_accId_partId_forecastdate_type_fss.get(ofcast.Opportunity__r.AccountId).get(ofcast.Part__c).containsKey(ofcast.Date__c)) {
                                                for(string approveType : map_accId_partId_forecastdate_type_fss.get(ofcast.Opportunity__r.AccountId).get(ofcast.Part__c).get(ofcast.Date__c).keySet()) {
                                                    map_accId_partId_forecastdate_type_fss.get(ofcast.Opportunity__r.AccountId).get(ofcast.Part__c).get(ofcast.Date__c).get(approveType).POS_Amount__c = ClsOppyUtil.transformIsoCode(ofcast.POS_Amount__c, ofcast.CurrencyIsoCode, map_accId_partId_forecastdate_type_fss.get(ofcast.Opportunity__r.AccountId).get(ofcast.Part__c).get(ofcast.Date__c).get(approveType).CurrencyIsoCode);
                                                    map_accId_partId_forecastdate_type_fss.get(ofcast.Opportunity__r.AccountId).get(ofcast.Part__c).get(ofcast.Date__c).get(approveType).Direct_Amount__c = ClsOppyUtil.transformIsoCode(ofcast.Direct_Amount__c, ofcast.CurrencyIsoCode, map_accId_partId_forecastdate_type_fss.get(ofcast.Opportunity__r.AccountId).get(ofcast.Part__c).get(ofcast.Date__c).get(approveType).CurrencyIsoCode);
                                                }
                                            }
                                        }
                                        
                                        for(string key : map_key_set_fbIds.keySet()) {
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
                                        /*for(Id accIdTemp : map_accId_partId_fbDate_set_fbIds.keySet()) {
                                            for(Id partIdTemp : map_accId_partId_fbDate_set_fbIds.get(accIdTemp).keySet()) {
                                                for(Date startDateTemp : map_accId_partId_fbDate_set_fbIds.get(accIdTemp).get(partIdTemp).keySet()) {
                                                    for(Id fbIdTemp : map_accId_partId_fbDate_set_fbIds.get(accIdTemp).get(partIdTemp).get(startDateTemp)) {
                                                        Forecast_Billing__c fbTemp = map_fbId_fb.get(fbIdTemp);
                                                        for(Id fbIdTemp1 : map_accId_partId_fbDate_set_fbIds.get(accIdTemp).get(partIdTemp).get(startDateTemp)) {
                                                            if(fbTemp.Id != fbIdTemp1 && fbTemp.Opportunity_Forecast__c != map_fbId_fb.get(fbIdTemp1).Opportunity_Forecast__c) {
                                                                if(fbTemp.Duplicate_Records__c == null) {
                                                                    fbTemp.Duplicate_Records__c = fbIdTemp1;
                                                                }else {
                                                                    fbTemp.Duplicate_Records__c += ';' + fbIdTemp1;
                                                                }
                                                            }
                                                        }
                                                        list_fbs4update.add(fbTemp);
                                                    }
                                                }
                                            }
                                        }*/
                                        system.debug('**@@list_fbs4update = ' + list_fbs4update);
                                        if(list_fbs4update.size() > 0) {
                                        //Start: Modified by Pavan for Case 901115 
                                            dmlRowCount   = dmlRowCount  + list_fbs4update.size();
                                            if(dmlRowCount <= 9990){
                                                update list_fbs4update;
                                            } else { 
                                                      govLimitReached = true;
                                                      system.debug('8-------> exception');     
                                            }   
                                        }
                                        if(govLimitReached==false){
                                        //End: Modified by Pavan for Case 901115 
                                            //calculate all forecast snapshot that should be uodated from the map map_accId_partId_forecastdate_set_fss;
                                            for(Id accId : map_accId_partId_forecastdate_type_fss.keySet()) {
                                                for(Id partId : map_accId_partId_forecastdate_type_fss.get(accId).keySet()) {
                                                    for(Date forecastDate : map_accId_partId_forecastdate_type_fss.get(accId).get(partId).keySet()) {
                                                        list_fs2update.addAll(map_accId_partId_forecastdate_type_fss.get(accId).get(partId).get(forecastDate).values());
                                                    }
                                                }
                                            }
                                            system.debug('**@@map_ofcId_ofc4QY' + map_ofcId_ofc4QY);
                                            system.debug('**@@list_fs2update' + list_fs2update);
                                            if(map_ofcId_ofc4QY.size() > 0) {
                                            //Start: Modified by Pavan for Case 901115 
                                                dmlRowCount   = dmlRowCount  + map_ofcId_ofc4QY.size();
                                                if(dmlRowCount <= 9990){
                                                    update map_ofcId_ofc4QY.values();
                                                } else { 
                                                          govLimitReached = true;
                                                          system.debug('9-------> exception');     
                                                }   
                                            }
                                            if(govLimitReached==false){
                                            //End: Modified by Pavan for Case 901115 
                                                if(list_fs2update.size() > 0) {
                                                //Start: Modified by Pavan for Case 901115 
                                                    dmlRowCount   = dmlRowCount  + list_fs2update.size();
                                                    if(dmlRowCount <= 9990){
                                                        update list_fs2update;
                                                    } else { 
                                                              govLimitReached = true;
                                                              system.debug('10-------> exception');     
                                                    }  
                                                //End: Modified by Pavan for Case 901115    
                                                }
                                            }   
                                        }   
                                    }   
                                }   
                            }   
                        }   
                    }
                }
            }
        }
        catch (Exception e){
            govLimitReached = true;
            system.debug('11-------> exception');     
        }
        if(govLimitReached){
            failedIds.addAll(set_accIds);
            Database.rollback(sp);      
        }
    }
    
    global void finish(Database.BatchableContext BC) {
		boolean isupdate = false; 
        Load_Status__c loadStatus;
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
        
        if(failedIds.isEmpty() || (!failedIds.isEmpty() && batchSize == 1)){
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
            if(failedIds.isEmpty()){
                Batch_Email_message_Users__c emailUsers = Batch_Email_message_Users__c.getValues('Error_BatchCalculateForecastBilling');
                if(emailUsers != null){
                    list<string> lstEmail = emailUsers.Email_ID__c.split(';');
                            mail = new Messaging.SingleEmailMessage(); 
                            mail.setSubject('Success Message for Batch run - Cls_BatchCalculateForecastBilling');
                            String body = 'Hello, <br/> <br/>';
                            body += 'All Accounts processed successfully <br/><br/>';
                                
                            mail.setHtmlBody(body);                                       
                            mail.setToAddresses(lstEmail);
                            mails.add(mail); 
                }
                try{
                    Messaging.sendEmail(mails);                  
                }catch(System.EmailException ex){
                    System.debug('***Success mail error***'+ex);
                }
            }
            if(!failedIds.isEmpty()){
				Batch_Email_message_Users__c emailUsers = Batch_Email_message_Users__c.getValues('Error_BatchCalculateForecastBilling');
                if(emailUsers != null){
                    list<string> lstEmail = emailUsers.Email_ID__c.split(';');
                            mail = new Messaging.SingleEmailMessage(); 
                            mail.setSubject('Failed Account Ids for Batch run - Cls_BatchCalculateForecastBilling');
                            String body = 'Hello, <br/> <br/>';
                            body += 'Below Account Ids have failed during batch run: <br/><br/>';
                            for(Id each: failedIds){
                                body += each+ '<br/>';
                            }    
                            mail.setHtmlBody(body);                                       
                            mail.setToAddresses(lstEmail);
                            mails.add(mail); 
                }
                try{
                    Messaging.sendEmail(mails);                  
                }catch(System.EmailException ex){
                    System.debug('*** Failed Accounts mail error***'+ex);
                }
            }
        } else if(!Test.isRunningTest()){
           Cls_BatchCalculateForecastBilling bCalcFc = new Cls_BatchCalculateForecastBilling(failedIds,1,false);
           database.executeBatch(bCalcFc,1);
        } 
	}
}