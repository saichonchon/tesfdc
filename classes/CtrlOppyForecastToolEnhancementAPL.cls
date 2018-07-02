/**
 *  Contains a set of static methods used CtrlOppyForecastToolEnhancementAPL pages
 *
 @author Minghao Li
 @created 2017-08-21
 @version 1.0
 @since 38.0 (Force.com ApiVersion)
 *
 @changelog
 * 2017-08-21 Minghao Li <minghao.li@capgemini.com>
 * - Created
 */
public class CtrlOppyForecastToolEnhancementAPL {
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public transient LocaleConfig lc {get;set;}
    public transient CustomObject co {get;set;}
    public transient APL_Lost_Dead_Project__c aplProject {get;set;}
    public transient APL_Forecast_Management__c aplForecastMagt {get;set;} //Added by Tangyong Li 2017-10-24
    
    public static final map<String, Integer> MAP_MONTHLABELNUMBER = new map<String, Integer>{
        'Jan' => 4, 'Feb' => 5, 'Mar' => 6, 'Apr' => 7, 'May' => 8, 'Jun' => 9,
        'Jul' => 10, 'Aug' => 11, 'Sep' => 12, 'Oct' => 1, 'Nov' => 2, 'Dec' => 3
    };
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    {
        this.lc = new LocaleConfig();
    }
    
    public CtrlOppyForecastToolEnhancementAPL(){
        try{
            
            this.setSectionCookies();
            
            this.aplProject = new APL_Lost_Dead_Project__c();
            this.co = new CustomObject();
            this.setCustomSetting();
            
            this.setTerritoryCode();
            this.setAplForecastMagt(); //Added by Tangyong Li 2017-10-24
            
            this.setExsitingBusinessLostField();
            this.setOtherField();
            this.setCurrentFiscalYear();

        }catch(Exception ex){
            system.debug(ex);
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
        }
    }
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
    public CtrlOppyForecastToolEnhancementAPL getThis(){
        return this;
    }
    
    
    @RemoteAction public static String exsitingBusinessLost(String params){
        CustomPramas cp = (CustomPramas)JSON.deserialize(params, CustomPramas.class);
        
        cp.list_o = new list<sObject>();
        
        set<String> set_accId = new set<String>();
        for(Account acct : database.query(cp.sql)){ 
            set_accId.add(acct.Id);
        }
        

        String pYear = (cp.periodYear-1)+'';
        for(APL_Lost_Dead_Project__c aldp : [SELECT Id, Name, Account_Manager__c, Account_Name__c, Account_Name__r.Name, 
                        Account_Name__r.SALES_TERRITORY_CDE__c, Business_Receive_Region__c, Description__c, 
                        Estimated_Billing_Impact_for_Current_FY__c, Estimated_Billing_Impact_for_Next_FY__c, Estimated_Business_Value_Per_Quarter__c,
                        Existing_Business_Lost_reason__c, Lost_Start_Fiscal_Year__c, Lost_Start_Fiscal_Month__c , Primary_Product__c, CurrencyIsoCode, CreatedBy.Name From APL_Lost_Dead_Project__c 
                        Where ( Account_Name__c IN :set_accId OR CreatedById = :UserInfo.getUserId() ) 
                            and (Lost_Start_Fiscal_Year__c =: cp.periodYear+'' or Lost_Start_Fiscal_Year__c =: pYear) ]) {
                                
            cp.list_o.add(aldp);
        }

        return JSON.serialize(cp);
    }
    
    @RemoteAction public static String deleteExsitingBusinessLost(String params){
        list<String> list_ids = (list<String>)JSON.deserialize(params, list<String>.class);
        
        list<APL_Lost_Dead_Project__c> list_aldp = new list<APL_Lost_Dead_Project__c>();
        
        for(APL_Lost_Dead_Project__c aldp : [Select Id From APL_Lost_Dead_Project__c Where id in: list_ids]){
            list_aldp.add(aldp);
        }
        
        if(list_aldp.size() > 0){
            delete list_aldp;
        }
        
        return 'true';
    }
    
    @RemoteAction public static String saveExsitingBusinessLost(String params){
        APL_Lost_Dead_Project__c aldp = (APL_Lost_Dead_Project__c)JSON.deserialize(params, APL_Lost_Dead_Project__c.class);
        
        if(aldp.Id == null){
            insert aldp;
        }else{
            update aldp;
        }
        for(APL_Lost_Dead_Project__c a : [Select Id, Name, Account_Manager__c, Account_Name__c, Account_Name__r.Name, Business_Receive_Region__c, Description__c, 
                                                Account_Name__r.SALES_TERRITORY_CDE__c, 
                                                Estimated_Billing_Impact_for_Current_FY__c, Estimated_Billing_Impact_for_Next_FY__c, Estimated_Business_Value_Per_Quarter__c,
                                                Existing_Business_Lost_reason__c, Lost_Start_Fiscal_Year__c, Lost_Start_Fiscal_Month__c, Primary_Product__c, CurrencyIsoCode   
                                          From APL_Lost_Dead_Project__c Where Id =: aldp.Id]){
            aldp = a;
        } 
        
        //Integer i = 1/0;
        
        return JSON.serialize(aldp);
    }
    
    
    @RemoteAction public static String otherWon(String params){
        CustomPramas cp = (CustomPramas)JSON.deserialize(params, CustomPramas.class);
        
        cp.list_other = new list<CustomOther>();
        
        set<String> set_accId = new set<String>();
        for(Account acct : database.query(cp.sql)){ 
            set_accId.add(acct.Id);
        }
        
        set<String> set_OppyId = new set<String>();
        
        
        Period monthperiod = [select Id, FiscalYearSettings.Name, PeriodLabel 
                                from Period where StartDate<=Today and EndDate >=Today and Type = 'Month'];
        Period quarterperiod = [Select Id, FiscalYearSettings.Name, Number
                                from Period where StartDate<=Today and EndDate >=Today and Type = 'Quarter'];
        
        set<String> set_years = new set<String>();
        String nextFiscalYear = '';
        String currentFiscalYear = '';
        String previousFiscalYear = '';
        Date currentDate = Date.today();
        Date wondatemin = Date.today();
        Date wondatemax = Date.today();
        
        list<Period> list_Period = new list<Period>();
        
        if(monthperiod.FiscalYearSettings.Name != null){ //set current year
            Integer intcurrentFiscalYear = Integer.valueOf(monthperiod.FiscalYearSettings.Name);
            set_years.add(String.valueOf(intcurrentFiscalYear));
            set_years.add(String.valueOf(intcurrentFiscalYear-1));
            currentFiscalYear = String.valueOf(intcurrentFiscalYear);
            nextFiscalYear = String.valueOf(intcurrentFiscalYear+1);
            previousFiscalYear = String.valueOf(intcurrentFiscalYear-1);
            currentDate = Date.newInstance(intcurrentFiscalYear, CtrlOppyForecastToolEnhancementAPL.MAP_MONTHLABELNUMBER.get(monthperiod.PeriodLabel), Date.daysInMonth(intcurrentFiscalYear, CtrlOppyForecastToolEnhancementAPL.MAP_MONTHLABELNUMBER.get(monthperiod.PeriodLabel)));
            
        }
        
        for(Period period : [select Id, FiscalYearSettings.Name, PeriodLabel, StartDate, EndDate
                                    from Period where FiscalYearSettings.Name IN :set_years and Type = 'Month']) {
            /*if(period.StartDate <= Date.today() && period.EndDate >= Date.today()) {
                Integer intcurrentFiscalYear = Integer.valueOf(period.FiscalYearSettings.Name);
                currentFiscalYear = String.valueOf(intcurrentFiscalYear);
                nextFiscalYear = String.valueOf(intcurrentFiscalYear+1);
                previousFiscalYear = String.valueOf(intcurrentFiscalYear-1);
                currentDate = Date.newInstance(intcurrentFiscalYear, CtrlOppyForecastToolEnhancementAPL.MAP_MONTHLABELNUMBER.get(period.PeriodLabel), Date.daysInMonth(intcurrentFiscalYear, CtrlOppyForecastToolEnhancementAPL.MAP_MONTHLABELNUMBER.get(period.PeriodLabel)));
            }*/
            
            if(wondatemin > period.StartDate) {
                wondatemin =  period.StartDate;
            }
            if(wondatemax < period.EndDate) {
                wondatemax = period.EndDate;
            }
            list_Period.add(period);
        }
        
        
        /*if(cp.intCurrentFiscalYear != null){
            Integer intcurrentFiscalYear = cp.intCurrentFiscalYear;
            
            set_years.add(String.valueOf(intcurrentFiscalYear));
            set_years.add(String.valueOf(intcurrentFiscalYear-1));
            wondatemin = Date.newInstance(intcurrentFiscalYear-1, 1, 1);
            wondatemax = Date.newInstance(intcurrentFiscalYear, 12, 31);
            currentFiscalYear = String.valueOf(intcurrentFiscalYear);
            nextFiscalYear = String.valueOf(intcurrentFiscalYear+1);
            previousFiscalYear = String.valueOf(intcurrentFiscalYear-1);
            currentDate = Date.newInstance(intcurrentFiscalYear, cp.intCurrentFiscalMonth, Date.daysInMonth(intcurrentFiscalYear, cp.intCurrentFiscalMonth));
        
        }
        
        if(period.FiscalYearSettings.Name != null){ //set current year
            Integer intcurrentFiscalYear = Integer.valueOf(period.FiscalYearSettings.Name);
            set_years.add(String.valueOf(intcurrentFiscalYear));
            set_years.add(String.valueOf(intcurrentFiscalYear-1));
            wondatemin = Date.newInstance(intcurrentFiscalYear-1, 1, 1);
            wondatemax = Date.newInstance(intcurrentFiscalYear, 12, 31);
            currentFiscalYear = String.valueOf(intcurrentFiscalYear);
            nextFiscalYear = String.valueOf(intcurrentFiscalYear+1);
            previousFiscalYear = String.valueOf(intcurrentFiscalYear-1);
            currentDate = Date.newInstance(intcurrentFiscalYear, CtrlOppyForecastToolEnhancementAPL.MAP_MONTHLABELNUMBER.get(period.PeriodLabel), Date.daysInMonth(intcurrentFiscalYear, CtrlOppyForecastToolEnhancementAPL.MAP_MONTHLABELNUMBER.get(period.PeriodLabel)));
        
        } */
        

        map<String, Decimal> map_oppy_Allocation = new map<String, Decimal>();
        map<String, Boolean> map_oppy_WithinSOP = new map<String, Boolean>();
        for(Opportunity_Partner__c oppypartner : [select Id, Opportunity__c, Allocation__c, Within_S_OP__c, Account__c from Opportunity_Partner__c where Account__c IN :set_accId]) {
            set_OppyId.add(oppypartner.Opportunity__c);
            if(!map_oppy_Allocation.containsKey(oppypartner.Opportunity__c)) {
                map_oppy_Allocation.put(oppypartner.Opportunity__c, 0);
            }
            if(!map_oppy_WithinSOP.containsKey(oppypartner.Opportunity__c)) {
                map_oppy_WithinSOP.put(oppypartner.Opportunity__c, false);
            }
            Decimal allocation = oppypartner.Allocation__c != null ? oppypartner.Allocation__c : 0;
            map_oppy_Allocation.put(oppypartner.Opportunity__c, map_oppy_Allocation.get(oppypartner.Opportunity__c) + allocation);
            map_oppy_WithinSOP.put(oppypartner.Opportunity__c, oppypartner.Within_S_OP__c);
        }
        
        map<String, map<String, CustomOther>> map_year_oppy_co = new map<String, map<String, CustomOther>>();
        
        map<String, map<String, set<String>>> map_year_oppy_parts = new map<String, map<String, set<String>>>();
        map<String, map<String, set<String>>> map_year_oppy_partids = new map<String, map<String, set<String>>>();
        set<String> set_allOppyPartIds = new set<String>();
        set<String> set_allPartIds = new set<String>();
        for(Opportunity_Part__c oppypart : [select Id, Opportunity__c, Won_Date__c, Opportunity__r.Name, Opportunity__r.Account.Name, Opportunity__r.Account.AccountNumber,
                                                    Opportunity__r.Owner.Name, Opportunity__r.New_Business_Percentage__c, Part__c
                                            from Opportunity_Part__c where Status__c = 'Won'AND Opportunity__c IN :set_OppyId  AND Won_Date__c >= :wondatemin AND Won_Date__c <= :wondatemax]) { //AND Opportunity__r.AccountId IN :set_accId
            String fiscalYearName = String.valueOf(Date.today().year());
            Integer fiscalMonth = Date.today().month();
            for(Period period : list_Period) {
                if(period.StartDate <= oppypart.Won_Date__c && period.EndDate >= oppypart.Won_Date__c) {
                    fiscalYearName = period.FiscalYearSettings.Name;
                    fiscalMonth = CtrlOppyForecastToolEnhancementAPL.MAP_MONTHLABELNUMBER.get(period.PeriodLabel);
                    //break;
                }
            }
            
            if(!map_year_oppy_co.containsKey(fiscalYearName)) {
                map_year_oppy_co.put(fiscalYearName, new map<String, CustomOther>());
                map_year_oppy_parts.put(fiscalYearName, new map<String, set<String>>());
                map_year_oppy_partids.put(fiscalYearName, new map<String, set<String>>());
            }
            if(!map_year_oppy_co.get(fiscalYearName).containsKey(oppypart.Opportunity__c)) {
                map_year_oppy_co.get(fiscalYearName).put(oppypart.Opportunity__c, new CustomOther());
                map_year_oppy_parts.get(fiscalYearName).put(oppypart.Opportunity__c, new set<String>());
                map_year_oppy_partids.get(fiscalYearName).put(oppypart.Opportunity__c, new set<String>());
            }
            
            map_year_oppy_parts.get(fiscalYearName).get(oppypart.Opportunity__c).add(oppypart.Id);
            map_year_oppy_partids.get(fiscalYearName).get(oppypart.Opportunity__c).add(oppypart.Part__c);
            set_allPartIds.add(oppypart.Part__c);
            set_allOppyPartIds.add(oppypart.Id);
            
            CustomOther co = map_year_oppy_co.get(fiscalYearName).get(oppypart.Opportunity__c);
            DateTime wondate = DateTime.newInstance(oppypart.Won_Date__c.year(), oppypart.Won_Date__c.month(), oppypart.Won_Date__c.day());
            co.WonDate += wondate.format('MMM dd, yyyy')+'\r\n';
            co.Name = oppypart.Opportunity__r.Name;
            co.oppId = oppypart.Opportunity__c;
            co.AccountName = oppypart.Opportunity__r.Account.Name;
            co.OwnerName = oppypart.Opportunity__r.Owner.Name;
            co.NewBusiness = oppypart.Opportunity__r.New_Business_Percentage__c;

            if(String.isNotBlank(co.NewBusiness)) {
                co.decNewBusiness = (Decimal.valueOf(co.NewBusiness.substring(0, co.NewBusiness.indexOf('%'))) / 100.0);
            }
            if(map_oppy_Allocation.containsKey(oppypart.Opportunity__c)) {
                co.CurrentTerritoryAllocation = map_oppy_Allocation.get(oppypart.Opportunity__c);
            }
            if(map_oppy_WithinSOP.containsKey(oppypart.Opportunity__c)) {
                co.relevantforSOP = map_oppy_WithinSOP.get(oppypart.Opportunity__c);
            }
            if(String.isNotBlank(oppypart.Opportunity__r.Account.AccountNumber)) {
                co.hasAccountNumber = true;
            }
            if(fiscalYearName == previousFiscalYear) {
                co.isCurrentYear = false;
            }
            
        }
        system.debug(map_year_oppy_co.keySet());
        set_years.add(nextFiscalYear);
        map<String, map<String, Decimal>> map_oppy_year_FYForecast = new map<String, map<String, Decimal>>();
        
        for(Opportunity_Forecast__c oppyforecast : [select Id, Opportunity__c, Part__c, Amount__c, Fiscal_Year__c, Fiscal_Month__c, CurrencyIsoCode
                                                        from Opportunity_Forecast__c 
                                                        where Fiscal_Year__c IN :set_years and Opportunity__c IN :set_OppyId and Part__c IN :set_allOppyPartIds]) {
            decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, oppyforecast.CurrencyIsoCode, 'USD');
            decimal amount = oppyforecast.Amount__c * currencyRate;
            for(String year : map_year_oppy_co.keySet()) {
                if(map_year_oppy_parts.get(year).containsKey(oppyforecast.Opportunity__c)){ //fixed minghao.li 2017-09-19
                    if(map_year_oppy_parts.get(year).get(oppyforecast.Opportunity__c).contains(oppyforecast.Part__c)) {
                        CustomOther co = map_year_oppy_co.get(year).get(oppyforecast.Opportunity__c);
                        if(co != null) {
                            if(oppyforecast.Fiscal_Year__c == currentFiscalYear) {
                                co.CurrentFYForecast += amount != null ? amount : 0;
                                
                                
                                Date fiscalDate = Date.newInstance(Integer.valueOf(oppyforecast.Fiscal_Year__c), Integer.valueOf(oppyforecast.Fiscal_Month__c), Date.daysInMonth(Integer.valueOf(oppyforecast.Fiscal_Year__c), Integer.valueOf(oppyforecast.Fiscal_Month__c)));
                                if(fiscalDate <= currentDate) {
                                    Integer quarternum = Integer.valueOf(Math.ceil(fiscalDate.month() / 3.0));
                                    if(quarternum < quarterperiod.Number) {
                                        co.currentmonthForecast += amount;
                                    }else {
                                        Decimal tempde =  (currentDate.month() - ((quarternum-1) * 3.0));
                                        co.currentmonthForecast += amount != null ? (amount * tempde / 3.0) : 0;
                                    }
                                }
                                    
                                
                            }else if(oppyforecast.Fiscal_Year__c ==  nextFiscalYear) {
                                co.NextFYForecast += amount != null ? amount : 0;
                            }else if(oppyforecast.Fiscal_Year__c ==  previousFiscalYear) {
                                co.PreviousFYForecast += amount != null ? amount : 0;
                            }
                        }
                        
                    }
                    
                }
            }
        }

        for(APL_Billing_Result_of_Covnerted_Opp__c abrco : [select Id, Opportunity__c, Opportunity_Partner__c, Part__c, 
                                                                Bill_Year_to_Date_Amount_USD__c, Bill_Prior_Year_Amount_USD__c
                                                            from APL_Billing_Result_of_Covnerted_Opp__c
                                                            where Opportunity__c IN :map_oppy_Allocation.keySet() 
                                                                and Opportunity_Partner__c IN :set_accId
                                                                and Part__c IN :set_allPartIds and Bill_Type__c = 'Direct']) {
            for(String year : map_year_oppy_co.keySet()) {
                if(map_year_oppy_partids.get(year).containsKey(abrco.Opportunity__c) && map_year_oppy_partids.get(year).get(abrco.Opportunity__c).contains(abrco.Part__c)) {
                    CustomOther co = map_year_oppy_co.get(year).get(abrco.Opportunity__c);
                    co.YTDActualBillingIncrease += (abrco.Bill_Year_to_Date_Amount_USD__c);// - abrco.Bill_Prior_Year_Amount_USD__c);
                }
            }
        }
        
        list<CustomOther> list_CO = new list<CustomOther>();
        
        for(String year : map_year_oppy_co.keySet()) {
            for(String oppy : map_year_oppy_co.get(year).keySet()) {
                CustomOther co = map_year_oppy_co.get(year).get(oppy);
                map<String, set<String>> map_oppy_partid = new map<String, set<String>>{ oppy => map_year_oppy_partids.get(year).get(oppy)};
                co.idmap = map_oppy_partid;
            }
            
            list_CO.addAll(map_year_oppy_co.get(year).values());
        }
        
        
        
        for(CustomOther co : list_CO) {
            if(co.isCurrentYear){
                co.CurrentFYNewBusinessIncremental = (co.CurrentFYForecast) * co.decNewBusiness * (co.CurrentTerritoryAllocation/100) ;
            }else{
                co.CurrentFYNewBusinessIncremental = (co.CurrentFYForecast- co.PreviousFYForecast) * co.decNewBusiness * (co.CurrentTerritoryAllocation/100) ;
            }
            
            co.YTDNewBusinessForecast = co.currentmonthForecast * (co.CurrentTerritoryAllocation/100);//* co.decNewBusiness
            if(co.isCurrentYear) {
                co.NextFYNewBusinessIncremental = (co.NextFYForecast - co.CurrentFYForecast) * (co.decNewBusiness) * (co.CurrentTerritoryAllocation/100);
            }
        }
        
        
        cp.list_other.addAll(list_CO);
        
        return JSON.serialize(cp);
    }
    
    @RemoteAction public static String addremoveOtherWonWithinSOP(String params){
        CustomPramas cp = (CustomPramas)JSON.deserialize(params, CustomPramas.class);
        
        set<String> set_accId = new set<String>();
        for(Account acct : database.query(cp.sql)){ 
            set_accId.add(acct.Id);
        }
        
        DateTime currentDatetime = DateTime.now();
        Date mincurrentDate = Date.today(); 
        Date maxcurrentDate = Date.today().addMonths(15);
        
        Period monthperiod = [select Id, FiscalYearSettings.Name, PeriodLabel 
                                from Period where StartDate<=Today and EndDate >=Today and Type = 'Month'];
        
        
        if(monthperiod.FiscalYearSettings.Name != null){ 
            Integer intcurrentFiscalYear = Integer.valueOf(monthperiod.FiscalYearSettings.Name);
            currentDatetime = DateTime.newInstance(intcurrentFiscalYear, CtrlOppyForecastToolEnhancementAPL.MAP_MONTHLABELNUMBER.get(monthperiod.PeriodLabel), 2, 1, 0 ,1);
            mincurrentDate = Date.newInstance(intcurrentFiscalYear, CtrlOppyForecastToolEnhancementAPL.MAP_MONTHLABELNUMBER.get(monthperiod.PeriodLabel), 2);
        }
        
        set<String> set_FiscalDate = new set<String>();
        
        for(Integer i = 0; i <= 18; i++) {
            DateTime futureDateTime = currentDatetime.addMonths(i);
            set_FiscalDate.add(futureDateTime.format('YYYYMM'));
            maxcurrentDate = Date.newInstance(futureDateTime.year(), futureDateTime.month(), Date.daysInMonth(futureDateTime.year(), futureDateTime.month()));
        }
        
        map<String, set<String>> map_oppy_partid = cp.idmap;
        String oppyId = '';
        for(String opp : map_oppy_partid.keySet()) {
             oppyId = opp;
        }
        set<String> set_partids = map_oppy_partid.get(oppyId);
        
        map<String, Decimal> map_acc_allocation = new map<String, Decimal>();
        list<Opportunity_Partner__c> list_newOP = new list<Opportunity_Partner__c>();
        for(Opportunity_Partner__c oppypartner : [select Id, Opportunity__c, Allocation__c, Account__c, Within_S_OP__c from Opportunity_Partner__c where Opportunity__c=:oppyId and Account__c IN :set_accId]) {
            map_acc_allocation.put(oppypartner.Account__c, oppypartner.Allocation__c);
            
            oppypartner.Within_S_OP__c = cp.isRemove;
            list_newOP.add(oppypartner);
        }

        if(list_newOP.size() > 0) {
            update list_newOP;
        }
        
        cp.addRemoveSuccess = true;
        
        return JSON.serialize(cp);
     }
    
    
    @RemoteAction public static String addremoveOtherWon(String params){
        CustomPramas cp = (CustomPramas)JSON.deserialize(params, CustomPramas.class);
        
        set<String> set_accId = new set<String>();
        map<Id, Id> map_accId_groupId = new map<Id, Id>();
        map<Id, list<Id>> map_groupId_accIdList = new map<Id, list<Id>>();
        
        set<Id> set_PlanAccount = new set<Id>();
        set<String> set_relaycode = new set<String>();
        for(Account acct : database.query(cp.sql)){ 
            set_accId.add(acct.Id);
            map_groupId_accIdList.put(acct.APL_Relay_forecast_Plan_Account__c, new list<Id>());
            map_accId_groupId.put(acct.Id, acct.APL_Relay_forecast_Plan_Account__c);
            if(acct.Relay_Specialist_Territory_Code__c != null && acct.Relay_Specialist_Territory_Code__c != '') {
                set_relaycode.add(acct.Relay_Specialist_Territory_Code__c);
            }
        }
        
        
        set_PlanAccount.addAll(map_groupId_accIdList.keySet());
        String query  = ' Select Id, APL_Relay_forecast_Plan_Account__c ';
        query += ' FROM Account ';
        query += ' WHERE Relay_Specialist_Territory_Code__c IN :set_relaycode And APL_Relay_forecast_Plan_Account__c IN :set_PlanAccount And STATDESC__c = \'Active\' ';
        
        set<Id> set_groupAccount = new set<Id>();
        for(Account acct : database.query(query)){ 
            map_groupId_accIdList.get(acct.APL_Relay_forecast_Plan_Account__c).add(acct.Id);
            set_groupAccount.add(acct.Id);
        }
        
        DateTime currentDatetime = DateTime.now();
        Date mincurrentDate = Date.today(); 
        Date maxcurrentDate = Date.today().addMonths(15);
        Period monthperiod = [select Id, FiscalYearSettings.Name, PeriodLabel 
                                from Period where StartDate<=Today and EndDate >=Today and Type = 'Month'];

        set<String> set_years = new set<String>();
        Date wondatemin = Date.today();
        Date wondatemax = Date.today();
        list<Period> list_Period = new list<Period>();
        Integer intcurrentFiscalYear = wondatemin.year();
        if(monthperiod.FiscalYearSettings.Name != null){ //set current year
            intcurrentFiscalYear = Integer.valueOf(monthperiod.FiscalYearSettings.Name);
            set_years.add(String.valueOf(intcurrentFiscalYear));
            set_years.add(String.valueOf(intcurrentFiscalYear-1));
            
            currentDatetime = DateTime.newInstance(intcurrentFiscalYear, MAP_MONTHLABELNUMBER.get(monthperiod.PeriodLabel), 2, 1, 0 ,0);
            mincurrentDate = Date.newInstance(intcurrentFiscalYear, MAP_MONTHLABELNUMBER.get(monthperiod.PeriodLabel), 2);
        }
        
        for(Period period : [select Id, FiscalYearSettings.Name, PeriodLabel, StartDate, EndDate
                                    from Period where FiscalYearSettings.Name IN :set_years and Type = 'Month' order by StartDate]) {
            if(wondatemin > period.StartDate) {
                wondatemin =  period.StartDate;
            }
            if(wondatemax < period.EndDate) {
                wondatemax = period.EndDate;
            }
            //list_Period.add(period);
        }
        
        set<String> set_FiscalDate = new set<String>();
        set<Integer> set_QuarterMonth = new set<Integer>{1,4,7,10};
        map<Integer, String> map_MonthQuarter = new map<Integer, String> {
            1=>'01',2=>'01',3=>'01',4=>'02',5=>'02',6=>'02',7=>'03',8=>'03',9=>'03',10=>'04',11=>'04',12=>'04'
        };
        if(!set_QuarterMonth.contains(currentDatetime.month())) {
            DateTime previousDateTime = currentDatetime;
            for(Integer i = -1; !set_QuarterMonth.contains(previousDateTime.month()); i--) {
                previousDateTime = currentDatetime.addMonths(i);
                String year = String.valueOf(previousDateTime.year());
                String month = map_MonthQuarter.get(previousDateTime.month());
                set_FiscalDate.add(year + '-' + month);
            }
        }
        String maxcurrentDateFormat = String.valueOf(currentDatetime.year()) + '-' + map_MonthQuarter.get(currentDatetime.month());
        String currentDateFormat = String.valueOf(currentDatetime.year()) + '-' + map_MonthQuarter.get(currentDatetime.month());
        for(Integer i = 0; i <= 18; i++) {
            DateTime futureDateTime = currentDatetime.addMonths(i);
            String year = String.valueOf(futureDateTime.year());
            String month = map_MonthQuarter.get(futureDateTime.month());
            set_FiscalDate.add(year + '-' + month);
            maxcurrentDateFormat = year + '-' + month;
            maxcurrentDate = Date.newInstance(futureDateTime.year(), futureDateTime.month(), Date.daysInMonth(futureDateTime.year(), futureDateTime.month()));
            
        }
        map<String, set<String>> map_oppy_partid = cp.idmap;
        String oppyId = '';
        for(String opp : map_oppy_partid.keySet()) {
             oppyId = opp;
        }
        //set<String> set_partids = map_oppy_partid.get(oppyId);
        //set<String> set_partids = new set<String>();
        map<String, Decimal> map_acc_allocation = new map<String, Decimal>();
        list<Opportunity_Partner__c> list_newOP = new list<Opportunity_Partner__c>();
        for(Opportunity_Partner__c oppypartner : [select Id, Opportunity__c, Allocation__c, Account__c, Within_S_OP__c from Opportunity_Partner__c where Opportunity__c=:oppyId and Account__c IN :set_accId]) {
            map_acc_allocation.put(oppypartner.Account__c, (oppypartner.Allocation__c/100.00));
            
            oppypartner.Within_S_OP__c = !cp.isRemove;
            list_newOP.add(oppypartner);
        }
        system.debug('!@# map_acc_allocation:'+map_acc_allocation);
        set<String> set_aplcbc2 = new set<String>{'30012','30014','30015', '30016', '30017', '30042'};
        map<String, set<String>> map_RELAY_CBCFIELD_CBCDESC = new map<String, set<String>>  {
        'CBC2__c' => new set<String> {'30005', '13213'},
        'CBC3__c' => new set<String> {'41553'}};
        map<String, String> map_partid_type = new map<String, String>();
        set<String> set_partids = new set<String>();
        map<String, Opportunity_Part__c> map_partid_part = new map<String, Opportunity_Part__c>();
        set<String> set_partcode = new set<String>();
        set<String> set_partname = new set<String>();
        map<String, String> map_partid_relaycbc2 = new map<String, String>();
        map<String, String> map_partid_ProductHierarchy = new map<String, String>();
        map<String, Decimal> map_partId_decNewBusiness = new map<String, Decimal>();
        map<String, map<String, Decimal>> map_partcode_partname_decNewBusiness = new map<String, map<String, Decimal>>();
        
        for(Opportunity_Part__c oppypart : [select Id, Part__c, Part__r.Product_Hierarchy__r.CBC2__c, Part__r.Product_Hierarchy__r.CBC3__c, Part__r.Product_Hierarchy__c, 
                                                    Part__r.PRODUCT_CDE__c, Part__r.PROD_NAME__c, Opportunity__r.New_Business_Percentage__c
                                                from Opportunity_Part__c
                                                where Status__c = 'Won' AND Opportunity__c = :oppyId  AND Won_Date__c >= :wondatemin AND Won_Date__c <= :wondatemax]) { //AND Opportunity__r.AccountId IN :set_accId
            
            set_partids.add(oppypart.Part__c);
            if(set_aplcbc2.contains(oppypart.Part__r.Product_Hierarchy__r.CBC2__c)) {
                map_partid_type.put(oppypart.Part__r.Product_Hierarchy__c, 'GPL');
            }else if(map_RELAY_CBCFIELD_CBCDESC.get('CBC2__c').contains(oppypart.Part__r.Product_Hierarchy__r.CBC2__c) || map_RELAY_CBCFIELD_CBCDESC.get('CBC3__c').contains(oppypart.Part__r.Product_Hierarchy__r.CBC3__c)) {
                map_partid_type.put(oppypart.Part__r.Product_Hierarchy__c, 'Relay Product Code');
                if(map_RELAY_CBCFIELD_CBCDESC.get('CBC2__c').contains(oppypart.Part__r.Product_Hierarchy__r.CBC2__c)){
                    map_partid_relaycbc2.put(oppypart.Part__r.Product_Hierarchy__c, oppypart.Part__r.Product_Hierarchy__r.CBC2__c);
                }else {
                    map_partid_relaycbc2.put(oppypart.Part__r.Product_Hierarchy__c, oppypart.Part__r.Product_Hierarchy__r.CBC3__c);
                }
                
                set_partcode.add(oppypart.Part__r.PRODUCT_CDE__c);
                set_partname.add(oppypart.Part__r.PROD_NAME__c);
            }else {
                map_partid_type.put(oppypart.Part__r.Product_Hierarchy__c, 'Other CBC2');
            }
            map_partid_ProductHierarchy.put(oppypart.Part__c, oppypart.Part__r.Product_Hierarchy__c);
            map_partid_part.put(oppypart.Part__c, oppypart);
            
            
            
            //map_partid_GLPId.put(oppypart.Part__c, oppypart.Part__r.Product_Hierarchy__c);
        }
        
        
        set<String> set_yearquarter = new set<String>();
        map<String, map<String, map<String, Decimal>>> map_partid_year_month_forecast = new map<String, map<String, map<String, Decimal>>>();
        map<String, map<String, map<String, Decimal>>> map_partid_year_month_quantity = new map<String, map<String, map<String, Decimal>>>();
        String lastYear = '';
        String lastMonth = '';
        system.debug('!@# maxcurrentDateFormat:'+maxcurrentDateFormat);
        for(Opportunity_Forecast__c oppyforecast : [select Id, Part__r.Part__r.Product_Hierarchy__c, Amount__c, Fiscal_Year__c, Fiscal_Quarter__c, Fiscal_Year_Quarter__c, 
                                                            Part__r.Part__c, CurrencyIsoCode, Quantity__c, Opportunity__r.New_Business_Percentage__c
                                                        from Opportunity_Forecast__c 
                                                        where  Opportunity__c = :oppyId and Part__r.Part__c IN :set_partids
                                                            and Fiscal_Year_Quarter__c IN :set_FiscalDate Order by Fiscal_Year__c, Fiscal_Quarter__c]) {
            if(oppyforecast.Fiscal_Year_Quarter__c == maxcurrentDateFormat) {
                lastYear = oppyforecast.Fiscal_Year__c;
                lastMonth = oppyforecast.Fiscal_Quarter__c;
            }
            Decimal decNewBusiness = 1;
            if(String.isNotBlank(oppyforecast.Opportunity__r.New_Business_Percentage__c)) {
                decNewBusiness = (Decimal.valueOf(oppyforecast.Opportunity__r.New_Business_Percentage__c.substring(0, oppyforecast.Opportunity__r.New_Business_Percentage__c.indexOf('%'))) / 100.0);
            }
            set_yearquarter.add(oppyforecast.Fiscal_Year__c+'-'+oppyforecast.Fiscal_Quarter__c);
            if(!map_partid_year_month_forecast.containsKey(oppyforecast.Part__r.Part__c)) {
                map_partid_year_month_forecast.put(oppyforecast.Part__r.Part__c, new map<String, map<String, Decimal>>());
            }
            if(!map_partid_year_month_forecast.get(oppyforecast.Part__r.Part__c).containsKey(oppyforecast.Fiscal_Year__c)) {
                map_partid_year_month_forecast.get(oppyforecast.Part__r.Part__c).put(oppyforecast.Fiscal_Year__c, new map<String, Decimal>());
            }
            if(!map_partid_year_month_forecast.get(oppyforecast.Part__r.Part__c).get(oppyforecast.Fiscal_Year__c).containsKey(oppyforecast.Fiscal_Quarter__c)) {
                 map_partid_year_month_forecast.get(oppyforecast.Part__r.Part__c).get(oppyforecast.Fiscal_Year__c).put(oppyforecast.Fiscal_Quarter__c, 0);
            }
            
            decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, oppyforecast.CurrencyIsoCode, 'USD');
            decimal amount = oppyforecast.Amount__c * currencyRate;
            map_partid_year_month_forecast.get(oppyforecast.Part__r.Part__c).get(oppyforecast.Fiscal_Year__c).put(oppyforecast.Fiscal_Quarter__c, (map_partid_year_month_forecast.get(oppyforecast.Part__r.Part__c).get(oppyforecast.Fiscal_Year__c).get(oppyforecast.Fiscal_Quarter__c)+amount));
             
            //added oppyforecast Quantity__c
            if(!map_partid_year_month_quantity.containsKey(oppyforecast.Part__r.Part__c)) {
                map_partid_year_month_quantity.put(oppyforecast.Part__r.Part__c, new map<String, map<String, Decimal>>());
            }
            if(!map_partid_year_month_quantity.get(oppyforecast.Part__r.Part__c).containsKey(oppyforecast.Fiscal_Year__c)) {
                map_partid_year_month_quantity.get(oppyforecast.Part__r.Part__c).put(oppyforecast.Fiscal_Year__c, new map<String, Decimal>());
            }
            if(!map_partid_year_month_quantity.get(oppyforecast.Part__r.Part__c).get(oppyforecast.Fiscal_Year__c).containsKey(oppyforecast.Fiscal_Quarter__c)) {
                 map_partid_year_month_quantity.get(oppyforecast.Part__r.Part__c).get(oppyforecast.Fiscal_Year__c).put(oppyforecast.Fiscal_Quarter__c, 0);
            }
            if(oppyforecast.Quantity__c != null) {
                map_partid_year_month_quantity.get(oppyforecast.Part__r.Part__c).get(oppyforecast.Fiscal_Year__c).put(oppyforecast.Fiscal_Quarter__c, (map_partid_year_month_quantity.get(oppyforecast.Part__r.Part__c).get(oppyforecast.Fiscal_Year__c).get(oppyforecast.Fiscal_Quarter__c) + oppyforecast.Quantity__c));
            }
        }
        system.debug('!@# lastYear:'+lastYear);
        system.debug('!@# lastMonth:'+lastMonth);
        system.debug('!@# set_yearquarter:'+set_yearquarter);
        system.debug('!@# map_partid_year_month_forecast:'+map_partid_year_month_forecast);
        list<APL_Sales_Forecast__c> list_newaplsf = new list<APL_Sales_Forecast__c>();
        
        map<String, map<String, map<String, map<String, APL_Sales_Forecast__c>>>> map_accid_partid_year_month_forecast = new map<String, map<String, map<String, map<String, APL_Sales_Forecast__c>>>>();
        for(APL_Sales_Forecast__c aplsf : [select Id, Fiscal_Date__c, Customer__c, Part__c, Forecast__c, Fiscal_Quarter__c, 
                                                Fiscal_Year__c, Type__c, GPL__c, CurrencyIsoCode, RSM_Forecast__c, GAM_Forecast__c, Price__c, Quantity__c
                                            from APL_Sales_Forecast__c
                                            where Customer__c IN :map_acc_allocation.keySet() and GPL__c IN :map_partid_type.keySet() and Type__c IN ('GPL','Other CBC2')
                                                and Fiscal_YEAR_Quarter__c IN :set_yearquarter]) {
            if(!map_accid_partid_year_month_forecast.containsKey(aplsf.Customer__c)) {
                map_accid_partid_year_month_forecast.put(aplsf.Customer__c, new map<String, map<String, map<String, APL_Sales_Forecast__c>>>());
            }
            
            if(!map_accid_partid_year_month_forecast.get(aplsf.Customer__c).containsKey(aplsf.GPL__c)) {
                map_accid_partid_year_month_forecast.get(aplsf.Customer__c).put(aplsf.GPL__c, new map<String, map<String, APL_Sales_Forecast__c>>());
            }
            
            if(!map_accid_partid_year_month_forecast.get(aplsf.Customer__c).get(aplsf.GPL__c).containsKey(aplsf.Fiscal_Year__c)) {
                map_accid_partid_year_month_forecast.get(aplsf.Customer__c).get(aplsf.GPL__c).put(aplsf.Fiscal_Year__c, new map<String, APL_Sales_Forecast__c>());
            }
            
            if(!map_accid_partid_year_month_forecast.get(aplsf.Customer__c).get(aplsf.GPL__c).get(aplsf.Fiscal_Year__c).containsKey(aplsf.Fiscal_Quarter__c)) {
                map_accid_partid_year_month_forecast.get(aplsf.Customer__c).get(aplsf.GPL__c).get(aplsf.Fiscal_Year__c).put(aplsf.Fiscal_Quarter__c, aplsf);
            }
        }
        

        map<String, map<String,map<String, map<String, map<String, APL_Sales_Forecast__c>>>>> map_accid_partcode_partname_year_month_forecast = new map<String, map<String,map<String, map<String, map<String, APL_Sales_Forecast__c>>>>>();
        for(APL_Sales_Forecast__c aplsf : [select Id, Fiscal_Date__c, Customer__c, Part__c, Forecast__c, Fiscal_Quarter__c, Fiscal_Year__c, Type__c, RSM_Price__c, RSM_Quantity__c, 
                                                PRODUCT_CDE__c, PROD_NAME__c, Relay_CBC2_Code__c, CurrencyIsoCode, RSM_Forecast__c, GAM_Forecast__c, Price__c, Quantity__c
                                            from APL_Sales_Forecast__c
                                            where Customer__c IN :map_acc_allocation.keySet() and PRODUCT_CDE__c IN :set_partcode and PROD_NAME__c IN :set_partname and Relay_CBC2_Code__c IN :map_partid_relaycbc2.values() and Type__c = 'Relay Product Code'
                                                and Fiscal_YEAR_Quarter__c IN :set_yearquarter]) {
            if(!map_accid_partcode_partname_year_month_forecast.containsKey(aplsf.Customer__c)) {
                map_accid_partcode_partname_year_month_forecast.put(aplsf.Customer__c, new map<String,map<String, map<String, map<String, APL_Sales_Forecast__c>>>>());
            }
            
            if(!map_accid_partcode_partname_year_month_forecast.get(aplsf.Customer__c).containsKey(aplsf.PRODUCT_CDE__c)) {
                map_accid_partcode_partname_year_month_forecast.get(aplsf.Customer__c).put(aplsf.PRODUCT_CDE__c, new map<String, map<String, map<String, APL_Sales_Forecast__c>>>());
            }
            
            if(!map_accid_partcode_partname_year_month_forecast.get(aplsf.Customer__c).get(aplsf.PRODUCT_CDE__c).containsKey(aplsf.PROD_NAME__c)) {
                map_accid_partcode_partname_year_month_forecast.get(aplsf.Customer__c).get(aplsf.PRODUCT_CDE__c).put(aplsf.PROD_NAME__c, new map<String,map<String, APL_Sales_Forecast__c>>());
            }
            
            if(!map_accid_partcode_partname_year_month_forecast.get(aplsf.Customer__c).get(aplsf.PRODUCT_CDE__c).get(aplsf.PROD_NAME__c).containsKey(aplsf.Fiscal_Year__c)) {
                map_accid_partcode_partname_year_month_forecast.get(aplsf.Customer__c).get(aplsf.PRODUCT_CDE__c).get(aplsf.PROD_NAME__c).put(aplsf.Fiscal_Year__c, new map<String, APL_Sales_Forecast__c>());
            }
            
            if(!map_accid_partcode_partname_year_month_forecast.get(aplsf.Customer__c).get(aplsf.PRODUCT_CDE__c).get(aplsf.PROD_NAME__c).get(aplsf.Fiscal_Year__c).containsKey(aplsf.Fiscal_Quarter__c)) {
                map_accid_partcode_partname_year_month_forecast.get(aplsf.Customer__c).get(aplsf.PRODUCT_CDE__c).get(aplsf.PROD_NAME__c).get(aplsf.Fiscal_Year__c).put(aplsf.Fiscal_Quarter__c, aplsf);
            }
        }
        system.debug('!@# currentDateFormat : '+ currentDateFormat);
        system.debug('!@# set_partcode : '+ set_partcode);
        system.debug('!@# set_groupAccount : '+ set_groupAccount);
        system.debug('!@# set_partname : '+ set_partname);
        system.debug('!@# map_partid_relaycbc2.values() : '+ map_partid_relaycbc2.values());
        map<String, map<String,map<String,APL_Sales_Forecast__c>>> map_groupaccid_partcode_partname_forecast = new map<String, map<String,map<String,APL_Sales_Forecast__c>>>();
        for(APL_Sales_Forecast__c aplsf : [select Id, Fiscal_Date__c, Customer__c, Part__c, Forecast__c, Fiscal_Quarter__c, Fiscal_Year__c, Type__c, RSM_Price__c, RSM_Quantity__c, 
                                                PRODUCT_CDE__c, PROD_NAME__c, Relay_CBC2_Code__c, CurrencyIsoCode, RSM_Forecast__c, GAM_Forecast__c, Price__c, Quantity__c
                                            from APL_Sales_Forecast__c
                                            where Customer__c IN :set_groupAccount and PRODUCT_CDE__c IN :set_partcode and PROD_NAME__c IN :set_partname and Relay_CBC2_Code__c IN :map_partid_relaycbc2.values() and Type__c = 'Relay Product Code'
                                                and Fiscal_YEAR_Quarter__c = :currentDateFormat]) {
            if(!map_groupaccid_partcode_partname_forecast.containsKey(aplsf.Customer__c)) {
                map_groupaccid_partcode_partname_forecast.put(aplsf.Customer__c, new map<String,map<String,APL_Sales_Forecast__c>>());
            }
            
            if(!map_groupaccid_partcode_partname_forecast.get(aplsf.Customer__c).containsKey(aplsf.PRODUCT_CDE__c)) {
                map_groupaccid_partcode_partname_forecast.get(aplsf.Customer__c).put(aplsf.PRODUCT_CDE__c, new map<String,APL_Sales_Forecast__c>());
            }
            
            if(!map_groupaccid_partcode_partname_forecast.get(aplsf.Customer__c).get(aplsf.PRODUCT_CDE__c).containsKey(aplsf.PROD_NAME__c)) {
                map_groupaccid_partcode_partname_forecast.get(aplsf.Customer__c).get(aplsf.PRODUCT_CDE__c).put(aplsf.PROD_NAME__c, aplsf);
            }
            
        }
        
        system.debug('!@# map_groupaccid_partcode_partname_forecast : '+ map_groupaccid_partcode_partname_forecast);
        //system.debug('!@# map_accid_partid_year_month_forecast:'+map_accid_partid_year_month_forecast);
        for(String accid : map_acc_allocation.keySet()) {
            for(String partid : map_partid_year_month_forecast.keySet()) {
                String gplid = map_partid_ProductHierarchy.get(partid);
                Opportunity_Part__c oppypart = map_partid_part.get(partid);
                
                Decimal decNewBusiness = 1.0;

                if(String.isNotBlank(oppypart.Opportunity__r.New_Business_Percentage__c)) {
                    decNewBusiness = (Decimal.valueOf(oppypart.Opportunity__r.New_Business_Percentage__c.substring(0, oppypart.Opportunity__r.New_Business_Percentage__c.indexOf('%'))) / 100.0);
                }
                
                
                Id groupId = map_accId_groupId.get(accid);
                decimal oldpartprice = 1;
                Boolean hasOldforecast = false;
                for(Id childaccid : map_groupId_accIdList.get(groupId)) {
                    if(map_groupaccid_partcode_partname_forecast.containsKey(childaccid) &&
                        map_groupaccid_partcode_partname_forecast.get(childaccid).containsKey(oppypart.Part__r.PRODUCT_CDE__c) &&
                        map_groupaccid_partcode_partname_forecast.get(childaccid).get(oppypart.Part__r.PRODUCT_CDE__c).containsKey(oppypart.Part__r.PROD_NAME__c)) {
                        oldpartprice = map_groupaccid_partcode_partname_forecast.get(childaccid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).RSM_Price__c;
                        hasOldforecast = true;
                        break;
                    }
                }
                system.debug('!@# groupId : '+ groupId);
                system.debug('!@# oldpartprice : '+ oldpartprice);
                system.debug('!@# hasOldforecast : '+ hasOldforecast);
                
                for(String year : map_partid_year_month_forecast.get(partid).keySet()) {
                    for(String month : map_partid_year_month_forecast.get(partid).get(year).keySet()) {
                        
                        if(cp.isRemove) {
                            if(map_accid_partid_year_month_forecast.containsKey(accid) 
                                    && map_accid_partid_year_month_forecast.get(accid).containsKey(gplid)
                                    && map_accid_partid_year_month_forecast.get(accid).get(gplid).containsKey(year)
                                    && map_accid_partid_year_month_forecast.get(accid).get(gplid).get(year).containsKey(month)) {
                                        
                                if(map_accid_partid_year_month_forecast.get(accid).get(gplid).get(year).get(month).Type__c == map_partid_type.get(gplid)) {
                                    decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, 'USD',map_accid_partid_year_month_forecast.get(accid).get(gplid).get(year).get(month).CurrencyIsoCode);
                                    Decimal addforecast = map_partid_year_month_forecast.get(partid).get(year).get(month)  * currencyRate;
                                    map_accid_partid_year_month_forecast.get(accid).get(gplid).get(year).get(month).Forecast__c -= (addforecast * map_acc_allocation.get(accid) * decNewBusiness);
                                    map_accid_partid_year_month_forecast.get(accid).get(gplid).get(year).get(month).RSM_Forecast__c -= (addforecast * map_acc_allocation.get(accid) * decNewBusiness);
                                    map_accid_partid_year_month_forecast.get(accid).get(gplid).get(year).get(month).GAM_Forecast__c -= (addforecast * map_acc_allocation.get(accid) * decNewBusiness);
                                }
                            }else if(map_accid_partcode_partname_year_month_forecast.containsKey(accid) 
                                    && map_accid_partcode_partname_year_month_forecast.get(accid).containsKey(oppypart.Part__r.PRODUCT_CDE__c)
                                    && map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).containsKey(oppypart.Part__r.PROD_NAME__c)
                                    && map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).containsKey(year)
                                    && map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).get(year).containsKey(month)
                                    && map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).get(year).get(month).Type__c == map_partid_type.get(gplid)) {
                                
                                decimal partprice = map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).get(year).get(month).Price__c;
                                Integer quantity = Math.round(map_partid_year_month_quantity.get(partid).get(year).get(month) * map_acc_allocation.get(accid) * decNewBusiness);
                                Decimal addforecast = partprice * quantity;

                                //map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).get(year).get(month).Forecast__c -= (addforecast * map_acc_allocation.get(accid));
                                map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).get(year).get(month).Quantity__c -= quantity;
                                map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).get(year).get(month).RSM_Quantity__c -= quantity;
                                map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).get(year).get(month).Forecast__c -= addforecast;
                                map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).get(year).get(month).RSM_Forecast__c -= addforecast;
                                map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).get(year).get(month).GAM_Forecast__c -= addforecast;
                                
                                
                            }
                            
                        }else {
                            
                            if(map_accid_partid_year_month_forecast.containsKey(accid) 
                                    && map_accid_partid_year_month_forecast.get(accid).containsKey(gplid)
                                    && map_accid_partid_year_month_forecast.get(accid).get(gplid).containsKey(year)
                                    && map_accid_partid_year_month_forecast.get(accid).get(gplid).get(year).containsKey(month)
                                    && map_accid_partid_year_month_forecast.get(accid).get(gplid).get(year).get(month).Type__c == map_partid_type.get(gplid)) {
                                decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, 'USD', map_accid_partid_year_month_forecast.get(accid).get(gplid).get(year).get(month).CurrencyIsoCode);
                                Decimal addforecast = map_partid_year_month_forecast.get(partid).get(year).get(month) * currencyRate;
                                map_accid_partid_year_month_forecast.get(accid).get(gplid).get(year).get(month).Forecast__c += (addforecast * map_acc_allocation.get(accid) * decNewBusiness);
                                map_accid_partid_year_month_forecast.get(accid).get(gplid).get(year).get(month).RSM_Forecast__c += (addforecast * map_acc_allocation.get(accid) * decNewBusiness);
                                map_accid_partid_year_month_forecast.get(accid).get(gplid).get(year).get(month).GAM_Forecast__c += (addforecast * map_acc_allocation.get(accid) * decNewBusiness);
                            }else if(map_accid_partcode_partname_year_month_forecast.containsKey(accid) 
                                    && map_accid_partcode_partname_year_month_forecast.get(accid).containsKey(oppypart.Part__r.PRODUCT_CDE__c)
                                    && map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).containsKey(oppypart.Part__r.PROD_NAME__c)
                                    && map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).containsKey(year)
                                    && map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).get(year).containsKey(month)
                                    && map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).get(year).get(month).Type__c == map_partid_type.get(gplid)) {
                                //decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, 'USD', map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).get(year).get(month).CurrencyIsoCode);
                                //Decimal addforecast = map_partid_year_month_forecast.get(partid).get(year).get(month) * currencyRate;
                                //map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).get(year).get(month).Forecast__c += (addforecast * map_acc_allocation.get(accid));
                                Integer addquantity = Math.round(map_partid_year_month_quantity.get(partid).get(year).get(month) * map_acc_allocation.get(accid) * decNewBusiness);

                                if(!hasOldforecast || map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).get(year).get(month).Id == null) {
                                    Decimal addforecast = map_partid_year_month_forecast.get(partid).get(year).get(month) * map_acc_allocation.get(accid) * decNewBusiness;
                                
                                    map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).get(year).get(month).Quantity__c += addquantity;
                                    map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).get(year).get(month).RSM_Quantity__c += addquantity;
                                    map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).get(year).get(month).Forecast__c += addforecast;
                                    map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).get(year).get(month).RSM_Forecast__c += addforecast;
                                    map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).get(year).get(month).GAM_Forecast__c += addforecast;
                                
                                    Decimal price = 1;
                                    if(map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).get(year).get(month).RSM_Quantity__c != 0) {
                                        price = map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).get(year).get(month).RSM_Forecast__c / 
                                                    map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).get(year).get(month).RSM_Quantity__c ;
                                    }
                                    price = price.setscale(4);
                                    map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).get(year).get(month).Price__c = price;
                                    map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).get(year).get(month).RSM_Price__c = price;
                                }else {
                                    if(!hasOldforecast) {
                                        oldpartprice = map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).get(year).get(month).Price__c;
                                    }
                                    Decimal addforecast = oldpartprice * addquantity;
                                    map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).get(year).get(month).Quantity__c += addquantity;
                                    map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).get(year).get(month).RSM_Quantity__c += addquantity;
                                    map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).get(year).get(month).Forecast__c += addforecast;
                                    map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).get(year).get(month).RSM_Forecast__c += addforecast;
                                    map_accid_partcode_partname_year_month_forecast.get(accid).get(oppypart.Part__r.PRODUCT_CDE__c).get(oppypart.Part__r.PROD_NAME__c).get(year).get(month).GAM_Forecast__c += addforecast;
                                
                                }
                                
                            }else {
                                if(year == lastYear && month == lastMonth) {
                                    continue;
                                }
                                
                                Decimal addforecast = map_partid_year_month_forecast.get(partid).get(year).get(month) * map_acc_allocation.get(accid) * decNewBusiness;
                                Integer quantity = Integer.valueOf(map_partid_year_month_quantity.get(partid).get(year).get(month) * map_acc_allocation.get(accid) * decNewBusiness);
                                system.debug('!@# quantity :'+quantity);
                                system.debug('!@# map_acc_allocation.get(accid) :'+map_acc_allocation.get(accid));
                                if(map_partid_type.get(gplid) == 'GPL' || map_partid_type.get(gplid) == 'Other CBC2') {
                                    APL_Sales_Forecast__c aplsf  = new APL_Sales_Forecast__c(Customer__c=accid, GPL__c=gplid, RSM_Forecast__c=addforecast, GAM_Forecast__c=addforecast, Forecast__c=addforecast, Fiscal_Quarter__c=month, Fiscal_Year__c=year, Type__c=map_partid_type.get(gplid), CurrencyIsoCode='USD');
                                    
                                    
                                    if(!map_accid_partid_year_month_forecast.containsKey(accid)) {
                                        map_accid_partid_year_month_forecast.put(accid, new map<String, map<String, map<String, APL_Sales_Forecast__c>>>());
                                    }
                                    
                                    if(!map_accid_partid_year_month_forecast.get(accid).containsKey(gplid)) {
                                        map_accid_partid_year_month_forecast.get(accid).put(gplid, new map<String, map<String, APL_Sales_Forecast__c>>());
                                    }
                                    
                                    if(!map_accid_partid_year_month_forecast.get(accid).get(gplid).containsKey(year)) {
                                        map_accid_partid_year_month_forecast.get(accid).get(gplid).put(year, new map<String, APL_Sales_Forecast__c>());
                                    }
                                    
                                    if(!map_accid_partid_year_month_forecast.get(accid).get(gplid).get(year).containsKey(month)) {
                                        map_accid_partid_year_month_forecast.get(accid).get(gplid).get(year).put(month, aplsf);
                                    }
                                }else {
                                    Decimal price = oldpartprice;
                                    if(!hasOldforecast) {
                                        if(quantity != 0) {
                                            price = addforecast / Decimal.valueOf(quantity);
                                        }
                                    }else {
                                        addforecast = quantity * oldpartprice;
                                    }
                                    price = price.setscale(4);
                                    APL_Sales_Forecast__c aplsf  = new APL_Sales_Forecast__c(Customer__c=accid, PRODUCT_CDE__c=oppypart.Part__r.PRODUCT_CDE__c,
                                                                         PROD_NAME__c=oppypart.Part__r.PROD_NAME__c, Relay_CBC2_Code__c=map_partid_relaycbc2.get(gplid), 
                                                                         RSM_Forecast__c=addforecast, GAM_Forecast__c=addforecast, Forecast__c=addforecast, 
                                                                         Price__c = price, Quantity__c = quantity, RSM_Quantity__c = quantity, RSM_Price__c = price, 
                                                                         Fiscal_Quarter__c=month, Fiscal_Year__c=year, Type__c=map_partid_type.get(gplid), 
                                                                         CurrencyIsoCode='USD');
                                    system.debug('!@# aplsf :'+aplsf);
                                    
                                    if(!map_accid_partcode_partname_year_month_forecast.containsKey(aplsf.Customer__c)) {
                                        map_accid_partcode_partname_year_month_forecast.put(aplsf.Customer__c, new map<String,map<String, map<String, map<String, APL_Sales_Forecast__c>>>>());
                                    }
                                    
                                    if(!map_accid_partcode_partname_year_month_forecast.get(aplsf.Customer__c).containsKey(aplsf.PRODUCT_CDE__c)) {
                                        map_accid_partcode_partname_year_month_forecast.get(aplsf.Customer__c).put(aplsf.PRODUCT_CDE__c, new map<String, map<String, map<String, APL_Sales_Forecast__c>>>());
                                    }
                                    
                                    if(!map_accid_partcode_partname_year_month_forecast.get(aplsf.Customer__c).get(aplsf.PRODUCT_CDE__c).containsKey(aplsf.PROD_NAME__c)) {
                                        map_accid_partcode_partname_year_month_forecast.get(aplsf.Customer__c).get(aplsf.PRODUCT_CDE__c).put(aplsf.PROD_NAME__c, new map<String,map<String, APL_Sales_Forecast__c>>());
                                    }
                                    
                                    if(!map_accid_partcode_partname_year_month_forecast.get(aplsf.Customer__c).get(aplsf.PRODUCT_CDE__c).get(aplsf.PROD_NAME__c).containsKey(aplsf.Fiscal_Year__c)) {
                                        map_accid_partcode_partname_year_month_forecast.get(aplsf.Customer__c).get(aplsf.PRODUCT_CDE__c).get(aplsf.PROD_NAME__c).put(aplsf.Fiscal_Year__c, new map<String, APL_Sales_Forecast__c>());
                                    }
                                    
                                    if(!map_accid_partcode_partname_year_month_forecast.get(aplsf.Customer__c).get(aplsf.PRODUCT_CDE__c).get(aplsf.PROD_NAME__c).get(aplsf.Fiscal_Year__c).containsKey(aplsf.Fiscal_Quarter__c)) {
                                        map_accid_partcode_partname_year_month_forecast.get(aplsf.Customer__c).get(aplsf.PRODUCT_CDE__c).get(aplsf.PROD_NAME__c).get(aplsf.Fiscal_Year__c).put(aplsf.Fiscal_Quarter__c, aplsf);
                                    }
                                }
                                 
                            }
                        }   
                    }
                }
            }
        }
        
        
        for(String accid : map_accid_partid_year_month_forecast.keySet()) {
            for(String partid : map_accid_partid_year_month_forecast.get(accid).keySet()) {
                for(String year : map_accid_partid_year_month_forecast.get(accid).get(partid).keySet()) {
                    for(String month : map_accid_partid_year_month_forecast.get(accid).get(partid).get(year).keySet()) {
                        list_newaplsf.add(map_accid_partid_year_month_forecast.get(accid).get(partid).get(year).get(month));
                    }
                }
            }
        }
        
        map<String, map<String, map<String, Decimal>>> map_accid_partcode_partname_newPrice = new map<String, map<String, map<String, Decimal>>>();
        
        for(String accid : map_accid_partcode_partname_year_month_forecast.keySet()) {
            for(String partcode : map_accid_partcode_partname_year_month_forecast.get(accid).keySet()) {
                for(String partname : map_accid_partcode_partname_year_month_forecast.get(accid).get(partcode).keySet()) {
                    Boolean hasNewForecast = false;
                    Decimal newPrice = 0;
                    Id groupId = map_accId_groupId.get(accid);
                    Boolean hasOldforecast = false;
                    for(Id childaccid : map_groupId_accIdList.get(groupId)) {
                        if(map_groupaccid_partcode_partname_forecast.containsKey(childaccid) &&
                            map_groupaccid_partcode_partname_forecast.get(childaccid).containsKey(partcode) &&
                            map_groupaccid_partcode_partname_forecast.get(childaccid).get(partcode).containsKey(partname)) {
                            hasOldforecast = true;
                            break;
                        }
                    }
                    if(!hasOldforecast) {
                    
                        Decimal allforecast = 0;
                        Decimal allquantity = 0;
                        for(String year : map_accid_partcode_partname_year_month_forecast.get(accid).get(partcode).get(partname).keySet()) {
                            for(String month : map_accid_partcode_partname_year_month_forecast.get(accid).get(partcode).get(partname).get(year).keySet()) {
                                //list_newaplsf.add(map_accid_partcode_partname_year_month_forecast.get(accid).get(partcode).get(partname).get(year).get(month));
                                if(hasNewForecast || map_accid_partcode_partname_year_month_forecast.get(accid).get(partcode).get(partname).get(year).get(month).Id == null) {
                                    hasNewForecast = true;
                                    allforecast += map_accid_partcode_partname_year_month_forecast.get(accid).get(partcode).get(partname).get(year).get(month).RSM_Forecast__c;
                                    allquantity += map_accid_partcode_partname_year_month_forecast.get(accid).get(partcode).get(partname).get(year).get(month).RSM_Quantity__c;
                                }
                            }
                        }
                        
                        newPrice = (allquantity != 0 ? (allforecast / allquantity) : 0);
                        newPrice = newPrice.setscale(4);
                        
                    }
                    //reset price
                    for(String year : map_accid_partcode_partname_year_month_forecast.get(accid).get(partcode).get(partname).keySet()) {
                        for(String month : map_accid_partcode_partname_year_month_forecast.get(accid).get(partcode).get(partname).get(year).keySet()) {
                            
                            //if(map_accid_partcode_partname_newPrice.containsKey(accid) && 
                            //  map_accid_partcode_partname_newPrice.get(accid).containsKey(partcode) &&
                            //  map_accid_partcode_partname_newPrice.get(accid).get(partcode).containsKey(partname)) {
                                    
                            //  Decimal newPrice = map_accid_partcode_partname_newPrice.get(accid).get(partcode).get(partname);
                            if(hasNewForecast) {
                                map_accid_partcode_partname_year_month_forecast.get(accid).get(partcode).get(partname).get(year).get(month).Price__c = newPrice;
                                map_accid_partcode_partname_year_month_forecast.get(accid).get(partcode).get(partname).get(year).get(month).RSM_Price__c = newPrice;
                            }
                            //}
                            list_newaplsf.add(map_accid_partcode_partname_year_month_forecast.get(accid).get(partcode).get(partname).get(year).get(month));
                        }
                    }
                    
                }
            }
        }
        
        
        /*for(String accid : map_accid_partcode_partname_year_month_forecast.keySet()) {
            for(String partcode : map_accid_partcode_partname_year_month_forecast.get(accid).keySet()) {
                for(String partname : map_accid_partcode_partname_year_month_forecast.get(accid).get(partcode).keySet()) {
                    
                }
            }
        }*/
        
        
        
        system.debug('!@# list_newaplsf:'+list_newaplsf);
        if(list_newaplsf.size() > 0) {
            upsert list_newaplsf;
        }
        
        if(list_newOP.size() > 0) {
            update list_newOP;
        }
        
        cp.addRemoveSuccess = true;
        
        return JSON.serialize(cp);
     }
    
    
    
    
    
    
    public String getCookieTotal() {
        Cookie total = ApexPages.currentPage().getCookies().get('total');
        return (total == null ? 'true': total.getValue());
    }
    
    public String getCookieLost() {
        Cookie lost = ApexPages.currentPage().getCookies().get('lost');
        return (lost == null ? 'true': lost.getValue());
    }
    
    public String getCookieOther() {
        Cookie other = ApexPages.currentPage().getCookies().get('other');
        return (other == null ? 'true': other.getValue());
    }
    //********************************* -=END public methods=- ************************************
    
    //********************************* -=BEGIN private methods=- *********************************
    private void setSectionCookies(){
        Cookie total = ApexPages.currentPage().getCookies().get('total');
        Cookie lost = ApexPages.currentPage().getCookies().get('lost');
        Cookie other = ApexPages.currentPage().getCookies().get('other');
        
        total = (total == null ? new Cookie('total', 'true', null, -1, false) : total);
        lost = (lost == null ? new Cookie('lost', 'true', null, -1, false) : lost);
        other = (other == null ? new Cookie('other', 'true', null, -1, false) : other);
    
        ApexPages.currentPage().setCookies(new Cookie[]{total, lost, other});
    }
    
    private void setCustomSetting(){
        
        try{
            APL_Lost_Dead_Project_Show_Hide__c aldpsh = APL_Lost_Dead_Project_Show_Hide__c.getValues('Show/Hide Sections');
            System.debug('wwww aldpsh=' + aldpsh);
            
            this.co.map_sectionConfig.put('total', aldpsh.Show_Forecast_Total__c);
            this.co.map_sectionConfig.put('business', aldpsh.Show_Business_Won__c);
            this.co.map_sectionConfig.put('other', aldpsh.Show_Business_Lost__c);
            
        }catch(Exception e){
            throw e;
        }
        
    }
    
    
    private void setExsitingBusinessLostField(){
        try{
            if(!this.co.map_sectionConfig.get('business')){
                return;
            }
            
            String query = '';
            query = ' Select Id , AccountNumber, Name, BillingState, SALES_TERRITORY_CDE__c, Relay_Specialist_Territory_Code__c, Account_Manager_Name__c ';              
            query += ' FROM Account ';
            query += ' WHERE ' + (this.co.territoryInfo.isRelay ? 'Relay_Specialist_Territory_Code__c' : 'SALES_TERRITORY_CDE__c') + ' = \'' + this.co.territoryInfo.Code + '\'';
            query += ' And STATDESC__c = \'Active\' ';
            this.co.sqlLost = query;
            
            map<String, Schema.FieldSet> map_fs = Schema.getGlobalDescribe().get('APL_Lost_Dead_Project__c').getDescribe().fieldSets.getMap();
            
            for(Schema.FieldSetMember f : map_fs.get('APLLostDeadProjectFieldModal').getFields()){
                String field = f.getFieldPath(), gType=String.valueOf(f.getType());
                if(field.toLowerCase() == 'id'){
                    continue;
                }
                CustomFieldSetMember cfsm = new CustomFieldSetMember(f.getFieldPath(), f.getLabel(), gType, f.getRequired());
                co.list_modal_lost.add( cfsm );
    
            }
            for(Schema.FieldSetMember f : map_fs.get('APLLostDeadProjectFieldCheck').getFields()){
                String field = f.getFieldPath(), gType=String.valueOf(f.getType());
                if(field.toLowerCase() == 'id'){
                    continue;
                }
                CustomFieldSetMember cfsm = new CustomFieldSetMember(field, f.getLabel(), gType, f.getRequired());
                if(gType == 'DOUBLE' || gType == 'INTEGER' || gType == 'DOUBLE'){
                    cfsm.cls = 'slds-text-align--right';
                }
                
                if(field == 'Estimated_Business_Value_Per_Quarter__c' || field == 'Estimated_Billing_Impact_for_Current_FY__c' || field == 'Estimated_Billing_Impact_for_Next_FY__c'){
                    cfsm.isOrder = true;
                }
                
                co.list_cfsm_lost.add( cfsm );
            }
            this.co.columnLost = co.list_cfsm_lost.size()-2;
        }catch(Exception e){
            throw e;
        }
    }
    
    
    private void setOtherField(){
        
        CustomFieldSetMember cfsm1 = new CustomFieldSetMember('Name', 'Opportunity Number / Name', 'LINK', false);
        cfsm1.isInternalClass = false;
        co.list_cfsm_other.add( cfsm1 );
        co.list_cfsm_other_previous.add( cfsm1 );
        CustomFieldSetMember cfsm2 = new CustomFieldSetMember('AccountName', 'Account Name', 'STRING', false);
        cfsm2.isInternalClass = false;
        co.list_cfsm_other.add( cfsm2 );
        co.list_cfsm_other_previous.add( cfsm2 );
        CustomFieldSetMember cfsm3 = new CustomFieldSetMember('OwnerName', 'Opportunity Owner', 'STRING', false);
        cfsm3.isInternalClass = false;
        co.list_cfsm_other.add( cfsm3 );
        co.list_cfsm_other_previous.add( cfsm3 );
        CustomFieldSetMember cfsm4 = new CustomFieldSetMember('WonDate', 'Won Date', 'STRING', false);
        co.list_cfsm_other.add( cfsm4 );
        co.list_cfsm_other_previous.add( cfsm4 );
        CustomFieldSetMember cfsm5 = new CustomFieldSetMember('NewBusiness', '% New Business', 'STRING', false);
        cfsm5.cls = 'slds-text-align--right';
        co.list_cfsm_other.add( cfsm5 );
        co.list_cfsm_other_previous.add( cfsm5 );
        CustomFieldSetMember cfsm6 = new CustomFieldSetMember('CurrentTerritoryAllocation', 'Current Territory Allocation', 'PERCENT', false);
        cfsm6.cls = 'slds-text-align--right';
        co.list_cfsm_other.add( cfsm6 );
        co.list_cfsm_other_previous.add( cfsm6 );
        CustomFieldSetMember cfsm7 = new CustomFieldSetMember('CurrentFYForecast', 'Current FY Forecast', 'DOUBLE', false);
        cfsm7.cls = 'slds-text-align--right';
        cfsm7.isOrder = true;
        co.list_cfsm_other.add( cfsm7 );
        co.list_cfsm_other_previous.add( cfsm7 );
        CustomFieldSetMember cfsm8 = new CustomFieldSetMember('NextFYForecast', 'Next FY Forecast', 'DOUBLE', false);
        cfsm8.cls = 'slds-text-align--right';
        cfsm8.isOrder = true;
        co.list_cfsm_other.add( cfsm8 );
        CustomFieldSetMember cfsmpervioys8 = new CustomFieldSetMember('PreviousFYForecast', 'Previous FY Forecast', 'DOUBLE', false);
        cfsmpervioys8.cls = 'slds-text-align--right';
        cfsmpervioys8.isOrder = true;
        co.list_cfsm_other_previous.add( cfsmpervioys8 );
        CustomFieldSetMember cfsm9 = new CustomFieldSetMember('YTDNewBusinessForecast', 'YTD Opportunity Forecast (Current Territory Only)', 'DOUBLE', false);
        cfsm9.cls = 'slds-text-align--right';
        co.list_cfsm_other.add( cfsm9 );
        cfsm9.isOrder = true;
        co.list_cfsm_other_previous.add( cfsm9 );
        CustomFieldSetMember cfsm10 = new CustomFieldSetMember('YTDActualBillingIncrease', 'YTD Actual Billing Received (Current Territory Only)', 'DOUBLE', false);
        cfsm10.cls = 'slds-text-align--right';
        cfsm10.isOrder = true;
        co.list_cfsm_other.add( cfsm10 );
        co.list_cfsm_other_previous.add( cfsm10 );
        CustomFieldSetMember cfsm11 = new CustomFieldSetMember('CurrentFYNewBusinessIncremental', 'Current FY New Business Incremental (Current Territory Only)', 'DOUBLE', false);
        cfsm11.cls = 'slds-text-align--right';
        cfsm11.isOrder = true;
        co.list_cfsm_other.add( cfsm11 );
        co.list_cfsm_other_previous.add( cfsm11 );
        CustomFieldSetMember cfsm12 = new CustomFieldSetMember('NextFYNewBusinessIncremental', 'Next FY New Business Incremental (Current Territory Only)', 'DOUBLE', false);
        cfsm12.cls = 'slds-text-align--right';
        cfsm12.isOrder = true;
        co.list_cfsm_other.add( cfsm12 );
        co.list_cfsm_other_previous.add( cfsm12 );
        
        
        String query = '';
        query = ' Select Id , AccountNumber, Name, BillingState, SALES_TERRITORY_CDE__c, Relay_Specialist_Territory_Code__c, Account_Manager_Name__c, APL_Relay_forecast_Plan_Account__c ';              
        query += ' FROM Account ';
        query += ' WHERE ' + (this.co.territoryInfo.isRelay ? 'Relay_Specialist_Territory_Code__c' : 'SALES_TERRITORY_CDE__c') + ' = \'' + this.co.territoryInfo.Code + '\'';
        query += ' And STATDESC__c = \'Active\' ';
        
        this.co.sqlOther = query;

    }
    
    private void setAplForecastMagt() {
        try{
            for(APL_Forecast_Management__c forecastManager : [Select Id, Add_APL_Won_Forecast__c, Manager__c, RecordType.DeveloperName
                                                              From APL_Forecast_Management__c
                                                              Where Manager__c = : UserInfo.getUserId()
                                                              And RecordType.DeveloperName = 'AM' limit 1]) {
                this.aplForecastMagt = forecastManager;
            }
        } catch(Exception e) {
            throw e;
        }
    }

    private void setTerritoryCode() {
        try{
            for(APL_Forecast_Management__c forecastManager : [Select Id, A6_Code__c, Manager__c, AM_Freeze__c, RecordType.DeveloperName
                                                              From APL_Forecast_Management__c
                                                              Where Manager__c = : UserInfo.getUserId() 
                                                              And RecordType.DeveloperName = 'AM' 
                                                              And A6_Code__c != null
                                                              And RecordTypeId != null]) {
                //this.co.territoryInfo.isRelay = (forecastManager.RecordType.DeveloperName == 'Relay' ? true : false);
                this.co.territoryInfo.isRelay = false;
                this.co.territoryInfo.Code = forecastManager.A6_Code__c;    
            }
    
            for(Sales_Hierarchy__c sh : [select Id, Level_7_Territory_Code__c, Level_7_Territory_Name__c from Sales_Hierarchy__c where Level_7_Territory_Code__c = :this.co.territoryInfo.Code]) {
                this.co.territoryInfo.territoryName = sh.Level_7_Territory_Name__c; 
            }
            
            for(Period p : [select Id, FiscalYearSettings.Name, PeriodLabel 
                                    from Period where StartDate<=Today and EndDate >=Today and Type = 'Month']){
                this.co.periodYear = Integer.valueOf(p.FiscalYearSettings.Name);
                this.co.periodMonth = MAP_MONTHLABELNUMBER.get(p.PeriodLabel);
            }
            
            
                                
                                
        }catch(Exception e){
            throw e;
        }
        
    }
    
    private void setCurrentFiscalYear() {
        try{
            for(Load_Status__c ls : [Select Current_Fiscal_Year__c, Current_Fiscal_Month__c 
                                        from Load_Status__c 
                                        where Data_Source_Description__c = 'Bookings/Billings Direct PN detail Monthly' limit 1]){
                                       // where Data_Source_Description__c = 'Bookings/Billings POS/CMA PN detail Monthly' limit 1]){
                
                this.co.territoryInfo.intCurrentFiscalYear = Integer.valueOf(ls.Current_Fiscal_Year__c);
                this.co.territoryInfo.strCurrentFiscalYear = ls.Current_Fiscal_Year__c;
                
                this.co.territoryInfo.intCurrentFiscalMonth = Integer.valueOf(ls.Current_Fiscal_Month__c);
                this.co.territoryInfo.strCurrentFiscalMonth = ls.Current_Fiscal_Month__c+'';
            }
            /*
            Period period = [select Id, FiscalYearSettings.Name, PeriodLabel 
                                    from Period where StartDate<=Today and EndDate >=Today and Type = 'Month'];
            
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, period+''));
            
            if(period.FiscalYearSettings.Name != null){ //set current year
                this.co.territoryInfo.intCurrentFiscalYear = Integer.valueOf(period.FiscalYearSettings.Name);
                this.co.territoryInfo.strCurrentFiscalYear = period.FiscalYearSettings.Name;
            } 
            
            if(period.PeriodLabel != null && MAP_MONTHLABELNUMBER.containsKey(period.PeriodLabel)){ //set current month
                this.co.territoryInfo.intCurrentFiscalMonth = MAP_MONTHLABELNUMBER.get(period.PeriodLabel);
                this.co.territoryInfo.strCurrentFiscalMonth = String.valueOf(MAP_MONTHLABELNUMBER.get(period.PeriodLabel));
            }
            */
          
        }catch(Exception e){
            throw e;
        }
    }
    
    
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
    public class CustomPramas{
        
        public Integer periodYear {get;set;}
        
        public String sql {get;set;}
        
        public list<sObject> list_o {get;set;}
        
        public list<CustomOther> list_other {get;set;}
        
        public map<String, set<String>> idmap {get;set;}
        public Boolean isRemove {get;set;}
                
        public Boolean addRemoveSuccess {get;set;}
        
        public Integer intCurrentFiscalYear {get;set;}
        public Integer intCurrentFiscalMonth {get;set;}
        
    }
    
    public class CustomObject{
        
        public String sqlLost {get;set;}
        public String sqlOther {get;set;}
        
        public Integer periodYear {get;set;}
        public Integer periodMonth {get;set;}
        
        public Integer columnLost {get;set;}
        public Integer columnOther {get;set;}
        
        public list<CustomFieldSetMember> list_cfsm_lost {get;set;}
        public list<CustomFieldSetMember> list_modal_lost {get;set;}
        public list<CustomFieldSetMember> list_cfsm_other {get;set;}
        public list<CustomFieldSetMember> list_cfsm_other_previous {get;set;}

        public map<String, Boolean> map_sectionConfig {get;set;}
        
        public CustomTerritoryInfo territoryInfo {get;set;}
        
        public CustomObject(){
            
            
            this.sqlLost = '';
            this.sqlOther = '';
            
            this.columnLost = 0;
            this.columnOther = 0;
            
            this.periodYear = Date.today().year(); 
            this.periodMonth = Date.today().month();
            
            this.list_modal_lost = new list<CustomFieldSetMember>();
            this.list_cfsm_lost = new list<CustomFieldSetMember>();
            this.list_cfsm_other = new list<CustomFieldSetMember>();
            list_cfsm_other_previous = new list<CustomFieldSetMember>();
            
            this.map_sectionConfig = new map<String, Boolean>();
            
            this.territoryInfo = new CustomTerritoryInfo();
        }
        
    }
    
    public class CustomOther{
        public String ID {get;set;}
        public String Name {get;set;}
        public String oppId {get;set;}  //this oppy id.
        public String AccountName {get;set;}
        public String OwnerName {get;set;}
        
        public sObject o {get;set;}
        public String WonDate {get;set;}
        public String NewBusiness {get;set;}
        public Decimal CurrentTerritoryAllocation {get;set;}
        public Decimal CurrentFYForecast {get;set;}
        public Decimal NextFYForecast {get;set;}
        public Decimal PreviousFYForecast {get;set;}
        public Decimal YTDNewBusinessForecast {get;set;}
        public Decimal YTDActualBillingIncrease {get;set;}
        public Decimal CurrentFYNewBusinessIncremental {get;set;}
        public Decimal NextFYNewBusinessIncremental {get;set;}
        public Boolean isCurrentYear {get;set;}
        
        public Decimal decNewBusiness {get;set;}
        public Decimal currentmonthForecast {get;set;}
        
        public Boolean relevantforSOP {get;set;}
        public Boolean hasAccountNumber {get;set;}
        
        public map<String, set<String>> idmap {get;set;}
        
        public CustomOther() {
            this.ID = '';
            this.Name = '';
            this.AccountName = '';
            this.OwnerName = '';
            this.WonDate = '';
            this.NewBusiness = '';
            this.decNewBusiness = 0;
            this.CurrentTerritoryAllocation = 0;
            this.CurrentFYForecast = 0;
            this.NextFYForecast = 0;
            this.PreviousFYForecast = 0;
            this.YTDNewBusinessForecast = 0;
            this.YTDActualBillingIncrease = 0;
            this.CurrentFYNewBusinessIncremental = 0;
            this.NextFYNewBusinessIncremental = 0;
            this.isCurrentYear = true;
            this.currentmonthForecast = 0;
            this.relevantforSOP = false;
            this.hasAccountNumber = false;
            this.idmap = new map<String, set<String>>();
        }
    }
    
    public class CustomTerritoryInfo {
        public String territoryName {get;set;}
        public String Code {get;set;}
        public String strCurrentFiscalYear {get;set;}
        public String strCurrentFiscalMonth {get;set;}
        
        public Integer intCurrentFiscalYear {get;set;}
        public Integer intCurrentFiscalMonth {get;set;}
        
        public Boolean isRelay {get;set;}
        
        public  CustomTerritoryInfo() {
            this.territoryName = '';
            this.Code = '';
            
            this.intCurrentFiscalYear = Date.today().year();
            this.intCurrentFiscalMonth = Date.today().month();
            
            this.strCurrentFiscalYear = String.valueOf(this.intCurrentFiscalYear);
            this.strCurrentFiscalMonth = String.valueOf(this.intCurrentFiscalMonth);
            
            this.isRelay = false;
        }
    }
    
    public class CustomFieldSetMember{
        
        public String apiName {get;set;}
        public String labelName {get;set;}
        public String gType {get;set;}
        public Boolean required {get;set;}
        public String orderBy {get;set;}
        public String icon {get;set;}
        public String cls {get;set;}
        public Boolean isOrder {get;set;}
        public Boolean isInternalClass {get;set;}
        
        public CustomFieldSetMember(String apiName, String labelName, String gType, Boolean required){
            this.apiName = apiName;
            this.labelName = labelName;
            this.gType = gType;
            this.required = required;
            this.orderBy = '';
            this.cls = '';
            this.icon = 'utility:arrowup';
            this.isInternalClass = false;
            this.isOrder = false;
        }
    }
    
    
    public class CustomSelectOption{
        public String label {get;set;}
        public String value {get;set;}
        
        public CustomSelectOption(String label, String value){
            this.value = value;
            this.label = label;
        }
    }
    
    
    public class LocaleConfig{
        public String locale {get;set;}
        public String jsPath {get;set;}
        
        public LocaleConfig(){
            try{
                this.locale= userInfo.getLocale();
                list<String> list_s = this.locale.split('_');
                this.locale = list_s[0]+'-'+list_s[1];
            }catch(Exception e){
                this.locale = 'de-DE';
            }   
            this.jsPath = '/glob-cultures/cultures/globalize.culture.'+this.locale+'.js';
        }
    }
    
    
    
    public class CustomException extends Exception{ }
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
}