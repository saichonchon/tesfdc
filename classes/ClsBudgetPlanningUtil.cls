/** 
 * 
 *   This class will collect all functions about budget planning
 *
 * @author      Min Liu
 * @created     2012-04-25
 * @since       23.0    
 * @version     1.0                                                                 
 * 
 * @changelog
 * 2014-08-22 Bin Yuan <bin.yuan@itbconsult.com>
 * - Modified due to fix CustomerGrowth, MarketPriceChange or PriceIncrease < 0 not calc bug('< 0' ==> '!= 0')
 * 2012-04-25 Min Liu <min.liu@itbconsult.com>
 * - Created
 *    
 */
global class ClsBudgetPlanningUtil {
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    global static Map<String, map<Date, Integer>> map_year_endDate_week = new Map<String, map<Date, Integer>>(); 
    global static Map<String, map<String, map<String, Integer>>> map_year_accountId_billType_MaxWeek = new Map<String, map<String, map<String, Integer>>>();
    global static Map<String, map<String, Integer>> map_year_billType_currentWeek = new Map<String, map<String, Integer>>(); 
    global static Map<String, map<String, Decimal>> map_year_billType_fiscalDayRate = new Map<String, map<String, Decimal>>(); 
    global static Map<String, map<Integer, Date>> map_year_month_endDate = new Map<String, map<Integer, Date>>();
    global static Map<String, map<String, Load_Status__c>> map_year_loadStatus = new Map<String, map<String, Load_Status__c>>();
    public static final String BUDGETQUERYFIELDS = 'Id, OwnerId, Name, Manager__c, CurrencyIsoCode, Stage__c, Year__c, Territory__c, Territory_Code__c, Territory__r.Level_7_Territory_Code__c, Status__c, Original_Direct_Budget__c, Original_POS_Budget__c, Original_CMA_Budget__c, Final_Direct_Budget__c, Final_POS_Budget__c, Final_CMA_Budget__c, Final_Total_Budget__c, Original_Total_Budget__c, FQ1_Direct__c, FQ1_POS__c, FQ1_CMA__c, FQ2_Direct__c, FQ2_POS__c, FQ2_CMA__c, FQ3_Direct__c, FQ3_POS__c, FQ3_CMA__c, FQ4_Direct__c, FQ4_POS__c, FQ4_CMA__c, FQ4_Total__c, FQ3_Total__c, FQ2_Total__c,FQ1_Total__c, Final_Total_Budget_TBR_NY__c, Original_Total_Budget_TBR_NY__c, Manager_Total_Budget__c, Total_Direct_Budget_TBR_NY__c, Total_CMA_Budget_TBR_NY__c, Total_POS_Budget_TBR_NY__c, Total_Budget_TBR_NY__c, Level_6_Assigned_User_Network_Id__c, Manager_Final_Budget__c,sales_period__c, Total_Direct_Budget_TBR_NY_Rollup__c, Total_POS_Budget_TBR_NY_Rollup__c, Total_CMA_Budget_TBR_NY_Rollup__c, Total_Budget_TBR_NY_Rollup__c ';
    public static final String DETAILSQUERYSTR = 'select Id, RecordTypeId, Budget__c, Account__c, Adjusted_Business__c, Adjustment__c, Backlog__c, Billings_CYRR__c, Billings_CYTD__c, Billings_LY__c, Calculated_Budget__c, Comments__c, Forecast_CY__c, Manager_Final_Budget__c, Manager_Total_Budget__c, Market_Growth__c, Obsoletion_EOL__c, Opportunities50_50__c, Opportunities_Commit__c, Opportunities_Likely__c, Opportunities_Pipeline__c, Opportunities_Weak__c, Opportunities_Won__c, Price_Change__c, Price_Increase__c, Run_Rate_Business__c, TAM_DTAM__c, Total_Budget__c, Transfer_In__c, Transfer_Out__c, Type__c, Budget_Year__c, Business_Transfers__c, Growth__c from Budget_Detail__c ';
    public static final map<String, Integer> MAP_MONTHLABELNUMBER = new map<String, Integer>{
        'Jan' => 4,
        'Feb' => 5,
        'Mar' => 6,
        'Apr' => 7,
        'May' => 8,
        'Jun' => 9,
        'Jul' => 10,
        'Aug' => 11,
        'Sep' => 12,
        'Oct' => 1,
        'Nov' => 2,
        'Dec' => 3
    };
    public static final map<Decimal, String> MAP_NUMBERMONTHLABEL = new map<Decimal, String>{
        1 => 'Jan',
        2 => 'Feb',
        3 => 'Mar',
        4 => 'Apr',
        5 => 'May',
        6 => 'Jun',
        7 => 'Jul',
        8 => 'Aug',
        9 => 'Sep',
        10 => 'Oct',
        11 => 'Nov',
        12 => 'Dec'
    };
    public static Map<String, Map<String, Map<String, Date>>> map_fiscalYear_fiscalMonth_SEDate;
    public static map<String, Decimal> map_convertionRate = new Map<String, Decimal>();
    public static map<String, Decimal> map_isoCode_exchangeRate;
    global static final String budgetPrefix = Schema.SObjectType.Budget__c.getKeyPrefix();          
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
       
    //********************************* -=BEGIN public methods=- **********************************         
    public static void getAllFiscalMonthDateRange(){
        if(map_fiscalYear_fiscalMonth_SEDate == null){
            map_fiscalYear_fiscalMonth_SEDate = new Map<String, Map<String, Map<String, Date>>>();
            for(Period p: [select FiscalYearSettingsId, FiscalYearSettings.Name, PeriodLabel, Number, StartDate, EndDate from Period where type = 'month' and PeriodLabel != null]){
                if(!map_fiscalYear_fiscalMonth_SEDate.containsKey(p.FiscalYearSettings.Name)){
                    map_fiscalYear_fiscalMonth_SEDate.put(p.FiscalYearSettings.Name, new Map<String, Map<String, Date>>());
                }
                if(!map_fiscalYear_fiscalMonth_SEDate.get(p.FiscalYearSettings.Name).containsKey(p.PeriodLabel)){
                    map_fiscalYear_fiscalMonth_SEDate.get(p.FiscalYearSettings.Name).put(p.PeriodLabel, new Map<String, Date>());
                }
                map_fiscalYear_fiscalMonth_SEDate.get(p.FiscalYearSettings.Name).get(p.PeriodLabel).put('Start', p.StartDate);
                map_fiscalYear_fiscalMonth_SEDate.get(p.FiscalYearSettings.Name).get(p.PeriodLabel).put('End', p.EndDate);
            }
        }
    }
    
    /**
    * The method is used to get sales period
    *
    @author Min Liu
    @created 2012-10-10
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param             
    *
    @return     sales period date
    *
    @changelog
    * 2012-10-10 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public static Date salesPeriodDate(String fiscalYear, Decimal fiscalMonth){
        String monthLabel = '';
        Date salesPeriodDate;
        Date endDate;
        getAllFiscalMonthDateRange();   
        if(MAP_NUMBERMONTHLABEL.containsKey(Integer.valueOf(fiscalMonth))) monthLabel = MAP_NUMBERMONTHLABEL.get(Integer.valueOf(fiscalMonth));
        if(map_fiscalYear_fiscalMonth_SEDate.containsKey(fiscalYear) && map_fiscalYear_fiscalMonth_SEDate.get(fiscalYear).containsKey(monthLabel)){
            endDate = map_fiscalYear_fiscalMonth_SEDate.get(fiscalYear).get(monthLabel).get('End');
        }
        if(endDate != null){
            Date tmpDate = Date.newinstance(endDate.year(), endDate.month(), 15);
            if(endDate >= tmpDate) salesPeriodDate = tmpDate;
            else salesPeriodDate = tmpDate.addMonths(-1);
        }
        return salesPeriodDate;
    }

    public static Date calBudgetPlanningSalesPeriodDate(String year){
        Date salesPeriodDate;
        Decimal month;
        for(Load_Status__c ls : [select Id, Name, Current_Fiscal_Month__c, Current_Fiscal_Working_Day_in_Year__c, Current_Date__c                                                  
                                      from Load_Status__c
                                      where Current_Fiscal_Year__c = :year and Name = 'BBB_Month_Bill_Book_Cust__c Direct' limit 1]){                                       
            month = ls.Current_Fiscal_Month__c;                                                     
        }       
        
        String label; 
        if(MAP_NUMBERMONTHLABEL.containskey(month)) label = MAP_NUMBERMONTHLABEL.get(month);
        Integer m = Integer.valueOf(month);
        for(Period p: [select PeriodLabel, Number, StartDate, EndDate from Period where type = 'month' and FiscalYearSettings.Name = :year and (Number = :m or PeriodLabel = :label) limit 1]){
            Date tmpDate = Date.newinstance(p.EndDate.year(), p.EndDate.month(), 15);
            if(p.EndDate >= tmpDate) salesPeriodDate = tmpDate;
            else salesPeriodDate = tmpDate.addMonths(-1);            
        }        
        return salesPeriodDate;
    }       
    /**
    * The method is used to get the next fiscal year
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param             
    *
    @return     fiscal next year
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public static String getCurrentFiscalYear(){
        String currentYear = '';
        for(Period p : [select FiscalYearSettings.Name from Period where Type = 'Year' and EndDate >= today order by EndDate limit 1]){
            currentYear = p.FiscalYearSettings.Name;
        }
        return currentYear;
    }        
    /**
    * The method is used to get the filtered year set
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              user id, territory, set of years
    *
    @return             filtered set of years
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public static void FilterYears(Id userId, String territory, Set<String> set_years){
        Set<String> set_filterYears = new Set<String>();
        for(Budget__c bg: [select Year__c from Budget__c where OwnerId = :userId and Territory__c = :territory]){
            set_filterYears.add(bg.Year__c);
        }
        for(String theYear: set_filterYears){
            if(set_years.contains(theYear)) set_years.remove(theYear);
        }
    }
    
    /**
    * The method is used to get the filtered territory set
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              user id, year, set of territory
    *
    @return             filtered set of territory
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public static void filterTerritory(Id userId, String year, Set<String> set_territory){
        Set<String> set_filterTerritory = new Set<String>();
        for(Budget__c bg: [select Territory__c from Budget__c where OwnerId = :userId and Year__c = :year]){
            set_filterTerritory.add(bg.Territory__c);
        }
        for(String theTerritory: set_filterTerritory){
            if(set_territory.contains(theTerritory)) set_territory.remove(theTerritory);
        }
    }

    /**
    * This method is used to get budget planning by id
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param      budget id
    *
    @return     budget by budget id      
    * 
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public static Budget__c getBudgetPlanById(Id bid){
        Budget__c budget = new Budget__c();
        String q = 'Select '+ BUDGETQUERYFIELDS + '  from Budget__c where Id = :bid';
        for(Budget__c b : database.query(q)){
            budget = b;
        }
        return budget;
    } 
    

    
    /**
    * This method is used to get the map of budget rate
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param      year
    *
    @return     map with isoCode, year, budget rate   
    * 
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */  
    public static map<String, map<String,Decimal>> calBudgetRate(){ 
        map<String, map<String,Decimal>> map_currency_type_Rate = new map<String, map<String,Decimal>>(); 
        for(Budget_Rate__c br: [SELECT  CurrencyIsoCode, Rate__c FROM Budget_Rate__c where Rate__c != null and Rate__c != 0]){
            map_currency_type_Rate.put(br.CurrencyIsoCode, new map<String,Decimal>());
            map_currency_type_Rate.get(br.CurrencyIsoCode).put('Rate', br.Rate__c); 
        }    
            
        for(CurrencyType ct : [select Id, IsoCode, ConversionRate from CurrencyType where IsActive = true and ConversionRate != null]){
            if(map_currency_type_Rate.containsKey(ct.IsoCode)){
                Decimal r = ct.ConversionRate / map_currency_type_Rate.get(ct.IsoCode).get('Rate');
                map_currency_type_Rate.get(ct.IsoCode).put('Rate', r);
            }
            else {
                map_currency_type_Rate.put(ct.IsoCode, new map<String,Decimal>());
                map_currency_type_Rate.get(ct.IsoCode).put('Rate', 1); 
            } 
            
            map_currency_type_Rate.get(ct.IsoCode).put('Standard', ct.ConversionRate);          
        }        
        return map_currency_type_Rate;
    }
        
    
    
    /**
    * This method is used to calculate monthly rate
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param      quarter value, total value, month
    *
    @return     map of month and monthly rate
    * 
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public static Map<Integer, Decimal> calMonthRate(Decimal q, Decimal total, Integer qr){ 
        Map<Integer, Decimal> map_monthRates = new Map<Integer, Decimal>();
        Decimal q1 = 0; 
        Decimal q2 = 0;
        if(q != null && total != 0){
            q1 = (q * 4 / 13)/total;
            q2 = (q/total) - (2*q1); //q2 = (q/total) - 2*(q1);
        }
        map_monthRates.put(qr, q1);
        map_monthRates.put(qr+1, q2);
        map_monthRates.put(qr+2, q1);
        return map_monthRates;
    }
              
        
          
    /**
    * The method is used to get default year list
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param      year        
    *
    @return     list of years        
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */       
    public static List<String> getDefaultYearList(Integer year){
        List<String> list_tmp = new List<String>();
        if(year != null && year >=0){
            String tmp = ClsOppyForecastUtil.getForecastYear(system.today());
            if(tmp != ''){
                list_tmp.add(tmp);
                Integer cy = Integer.valueOf(tmp);
                Integer my = cy + year;
                for(Integer i=cy+1; i<my; i++){
                    list_tmp.add(String.valueOf(i));
                }
            }     
        }   
        return list_tmp;
    }

    /**
    * The method is used to get max week of year of billing type
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param      year, list of account ids      
    *
    @return             
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */    
    public static void getLoadStatusByYear(String year){
        if(!map_year_loadStatus.containsKey(year)){
            Set<String> set_loadStatusName = new Set<String>{'BBB_Month_Bill_Book_Cust__c Indirect', 'BBB_Month_Bill_Book_Cust__c Direct', 'BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c'};
            map_year_loadStatus.put(year, new map<String, Load_Status__c>());
            for(Load_Status__c ls : [select Id, Name, Current_Fiscal_Month__c, Current_Fiscal_Working_Day_in_Year__c, Current_Date__c                                                  
                                      from Load_Status__c
                                      where Current_Fiscal_Year__c = :year and Name in: set_loadStatusName and Current_Fiscal_Working_Day_in_Year__c != null and Current_Fiscal_Working_Day_in_Year__c != 0 ]){                                     
                if(ls.Name == 'BBB_Month_Bill_Book_Cust__c Direct'){
                    map_year_loadStatus.get(year).put('Direct', ls); //new change Billings RR CY $  =  Billings YTD CY $ / Current_Fiscal_Working_Day_in_Year__c * 260
                }
                else if(ls.Name == 'BBB_Month_Bill_Book_Cust__c Indirect'){
                    map_year_loadStatus.get(year).put('Indirect', ls); //new change Billings RR CY $  =  Billings YTD CY $ / Current_Fiscal_Working_Day_in_Year__c * 260
                }    
                else if(ls.Name == 'BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c'){
                    map_year_loadStatus.get(year).put('DailyDirect', ls); //new change Billings RR CY $  =  Billings YTD CY $ / Current_Fiscal_Working_Day_in_Year__c * 260
                }                                                       
            }
        }       
    }
    
    /**
    * The method is used to get end date of the year
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param      year
    *
    @return             
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */    
    private static void copyBudgetDeatilIntoStructure(Budget_Detail__c detail, ClsAnnualBudgetPlanStructure.BudgetPlanningItem item){
        if(detail.Total_Budget__c != null) item.TotalBudget += detail.Total_Budget__c;
        item.TotalOtherBudget = 0;
        item.TotalAccountBudget = 0; 
        if(detail.Billings_LY__c != null) item.BillingsLY += detail.Billings_LY__c;
        if(detail.Billings_CYTD__c != null) item.BillingsYTDCY += detail.Billings_CYTD__c;
        //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'BillingsYTDCY :' + item.BillingsYTDCY));
        if(detail.Billings_CYRR__c != null) item.BillingsRRCY += detail.Billings_CYRR__c;
        if(detail.Backlog__c != null) item.Backlog += detail.Backlog__c;
        if(detail.Forecast_CY__c != null) item.EstimatedFinalCY += detail.Forecast_CY__c;
        if(detail.Obsoletion_EOL__c != null) item.ObsoletionEOL += detail.Obsoletion_EOL__c;
        if(detail.Transfer_Out__c != null) item.TransferOut += detail.Transfer_Out__c;
        if(detail.Transfer_In__c != null) item.TransferIn += detail.Transfer_In__c;
        if(detail.TAM_DTAM__c != null) item.TAMDTAM  += detail.TAM_DTAM__c;
        if(detail.Run_Rate_Business__c != null) item.RepeatBusiness += detail.Run_Rate_Business__c;
        if(detail.Market_Growth__c != null) item.CustomerGrowth = detail.Market_Growth__c;
        if(detail.Price_Change__c != null)  item.MarketPriceChange = detail.Price_Change__c;
        if(detail.Price_Increase__c != null)  item.PriceIncrease = detail.Price_Increase__c;
        if(detail.Adjusted_Business__c != null) item.AdjRepeatBusiness += detail.Adjusted_Business__c;
        if(detail.Opportunities_Won__c != null) item.OpportunitiesWon += detail.Opportunities_Won__c;
        if(detail.Calculated_Budget__c != null) item.Forecast += detail.Calculated_Budget__c;
        if(detail.Opportunities_Commit__c != null) item.OpportunitiesCommit += detail.Opportunities_Commit__c;
        if(detail.Opportunities_Likely__c != null) item.OpportunitiesLikely += detail.Opportunities_Likely__c;
        if(detail.Opportunities50_50__c != null) item.Opportunities5050 += detail.Opportunities50_50__c;
        if(detail.Opportunities_Weak__c != null) item.OpportunitiesWeak += detail.Opportunities_Weak__c;
        if(detail.Adjustment__c != null) item.Adjustment += detail.Adjustment__c;
        if(detail.Growth__c != null) item.Growth += detail.Growth__c;       
        //Start by Bin Yuan 2013-10-21 due to fix Budget NY bug
        item.budgetNY += (detail.Budget_TBR_NY__c == null ? 0 : detail.Budget_TBR_NY__c);
        //End           
    }

    private static void buildStructureFromBudgetDeatil(Budget_Detail__c detail, ClsAnnualBudgetPlanStructure.BudgetPlanningAccountItem item){
        if(detail.Billings_LY__c != null) item.BillingsLY += detail.Billings_LY__c;
        if(detail.Billings_CYTD__c != null) item.BillingsYTDCY += detail.Billings_CYTD__c;
        if(detail.Billings_CYRR__c != null) item.BillingsRRCY += detail.Billings_CYRR__c;
        if(detail.Backlog__c != null) item.Backlog += detail.Backlog__c;        
        if(detail.Opportunities_Won__c != null) item.OpportunitiesWon += detail.Opportunities_Won__c;
        if(detail.Opportunities_Commit__c != null) item.OpportunitiesCommit += detail.Opportunities_Commit__c;
        if(detail.Opportunities_Likely__c != null) item.OpportunitiesLikely += detail.Opportunities_Likely__c;
        if(detail.Opportunities50_50__c != null) item.Opportunities5050 += detail.Opportunities50_50__c;
        if(detail.Opportunities_Weak__c != null) item.OpportunitiesWeak += detail.Opportunities_Weak__c;
        
    }
    public static void buildBudgetStructure(Map<String, ClsAnnualBudgetPlanStructure> map_accId_budgetPlanStructures, Budget__c budget, ClsAnnualBudgetPlanStructure totalBP, ClsAnnualBudgetPlanStructure otherBP){
        system.debug('map_accId_budgetPlanStructures==: ' + map_accId_budgetPlanStructures);
        for(Budget_Detail__c detail : [select Id, RecordType.DeveloperName, Budget__c,
                                                    Account__r.Account_Combined_Data__c, Account__c, Account__r.Name,
                                                    Parent_Account__c, Parent_Account__r.Account_Combined_Data__c, Parent_Account__r.Name, 
                                                    Adjusted_Business__c, Adjustment__c, Backlog__c, Billings_CYRR__c, 
                                                    Billings_CYTD__c, Billings_LY__c, Calculated_Budget__c, Comments__c, 
                                                    Forecast_CY__c, Manager_Final_Budget__c, Manager_Total_Budget__c, 
                                                    Market_Growth__c, Obsoletion_EOL__c, Opportunities50_50__c, 
                                                    Opportunities_Commit__c, Opportunities_Likely__c, Opportunities_Pipeline__c, 
                                                    Opportunities_Weak__c, Opportunities_Won__c, Price_Change__c, Price_Increase__c, 
                                                    Run_Rate_Business__c, TAM_DTAM__c, Total_Budget__c, Transfer_In__c, Transfer_Out__c, 
                                                    Type__c, Budget_Year__c, Business_Transfers__c, Growth__c 
                                                    //Added by Bin Yuan 2013-10-14 :: due to fix account territory changed bug
                                                    //from Budget_Detail__c where Budget__c = :budget.Id]){
                                                    , Budget_TBR_NY__c
                                                    from Budget_Detail__c where Budget__c = :budget.Id And Account_Territory_Code__c =: budget.Territory__r.Level_7_Territory_Code__c]){
                                                    //End
            system.debug('detail=='+detail);
            ClsAnnualBudgetPlanStructure bps;
            if(detail.RecordType.DeveloperName != 'Other'){//parent/children accounts
                String parentId = detail.Account__c;
                String accName = detail.Account__r.Name;
                String accInfo = detail.Account__r.Account_Combined_Data__c;
                //Child Account
                if(detail.Parent_Account__c != null){
                    parentId = detail.Parent_Account__c;
                    accName = detail.Parent_Account__r.Name;
                    accInfo = detail.Parent_Account__r.Account_Combined_Data__c;
                }
                parentId = parentId.subString(0, 15);
                if(!map_accId_budgetPlanStructures.containsKey(parentId)){  
                    bps = new ClsAnnualBudgetPlanStructure(parentId);
                    bps.accountName = accName;
                    bps.accountInfo = accInfo;      
                    map_accId_budgetPlanStructures.put(parentId, bps);
                }
                bps = map_accId_budgetPlanStructures.get(parentId);             
            }
            else{
                bps = otherBP;              
            }
            ClsAnnualBudgetPlanStructure.BudgetPlanningAccountStructure bp;
            if(bps.map_accountStructure.containsKey(detail.Account__c)){
                bp = bps.map_accountStructure.get(detail.Account__c);
            }else{
                bp = new ClsAnnualBudgetPlanStructure.BudgetPlanningAccountStructure(detail.Account__c);
            }
            if(detail.Type__c == 'Direct'){
                copyBudgetDeatilIntoStructure(detail, bps.detailDirect);
                if(detail.Comments__c != null) bps.detailDirect.comments = detail.Comments__c;          
                buildStructureFromBudgetDeatil(detail, bp.detailDirect);        
            }
            else if(detail.Type__c == 'CMA'){
                copyBudgetDeatilIntoStructure(detail, bps.detailCMA);
                buildStructureFromBudgetDeatil(detail, bp.detailCMA);   
            }
            else{
                copyBudgetDeatilIntoStructure(detail, bps.detailPOS);
                buildStructureFromBudgetDeatil(detail, bp.detailPOS);   
            }
            bps.map_accountStructure.put(detail.Account__c, bp);            
        }   
        
        for(String accId: map_accId_budgetPlanStructures.keySet()){     
            setStructureValues(map_accId_budgetPlanStructures.get(accId), totalBP, accId, false);
            //Start by Bin Yuan due to fix Growth bug
            calcGrowth(map_accId_budgetPlanStructures.get(accId).detailDirect);
            calcGrowth(map_accId_budgetPlanStructures.get(accId).detailPOS);
            calcGrowth(map_accId_budgetPlanStructures.get(accId).detailCMA);
            //End
        } 
        
        setStructureValues(otherBP, totalBP, null, false);
        //system.debug('otherBP: ' + otherBP.map_accountStructure);
        setTotalAccountGrowth(totalBP.detailDirect);
        setTotalAccountGrowth(totalBP.detailPOS);
        setTotalAccountGrowth(totalBP.detailCMA);
        setTotalAccountGrowth(totalBP.detailTotal);
    }
    

    public static Integer getFiscalMonthByDate(Date d, String year){
        Integer m;
        for(Period p :[select Id, PeriodLabel, Number from Period where Type = 'month' and StartDate <=:d and EndDate >= :d and FiscalYearSettings.Name = :year]){
            if(p.Number != null) return p.Number;
            else if(p.PeriodLabel != null && MAP_MONTHLABELNUMBER.containsKey(p.PeriodLabel)) return MAP_MONTHLABELNUMBER.get(p.PeriodLabel);
        }
        return m;
    }   
    
    public static void allocatedOpportunityValues(String status, ClsAnnualBudgetPlanStructure.BudgetPlanningItem bpsItem, ClsAnnualBudgetPlanStructure.BudgetPlanningAccountItem bpItem, Decimal amount){
        if(status == 'Won'){                    
            bpsItem.OpportunitiesWon += amount;
            bpItem.OpportunitiesWon += amount;                      
        }
        else if(status == 'Weak'){
            bpsItem.OpportunitiesWeak += amount; 
            bpItem.OpportunitiesWeak += amount;                                         
        }
        else if(status == 'Commit'){
            bpsItem.OpportunitiesCommit += amount;
            bpItem.OpportunitiesCommit += amount;                                          
        }
        else if(status == 'Likely'){
            bpsItem.OpportunitiesLikely += amount;
            bpItem.OpportunitiesLikely += amount;                                      
        }
        else if(status == '50/50'){
            bpsItem.Opportunities5050 += amount; 
            bpItem.Opportunities5050 += amount;                                       
        }               
    }
    
    
    public static map<String, map<String,Budget_Detail__c>> fillOldBudgetDetailsIntoStructure(String budgetFiscalYear, List<Id> list_accIds, Budget__c budget, String theTerritory, map<String, map<String,Budget_Detail__c>> map_existingDetails){
        map<String, map<String,Budget_Detail__c>> map_tmp = new map<String, map<String,Budget_Detail__c>>();
        set<Id> set_allAccIds = new Set<Id>();
        set_allAccIds.addAll(list_accIds);
        String BudgetId;
        if(budget != null && budget.Id != null){
            BudgetId = budget.Id;
            for(Budget_Detail__c detail : [select Id, RecordType.DeveloperName, Budget__c, Comments__c, Run_Rate_Business__c,
                                                        Adjustment__c, Price_Increase__c, Account__c, Forecast_CY__c, 
                                                        Market_Growth__c, Obsoletion_EOL__c, Price_Change__c, 
                                                        TAM_DTAM__c, Transfer_In__c, Transfer_Out__c, 
                                                        Type__c, Business_Transfers__c, Growth__c 
                                                        //Added by Bin Yuan 2013-10-14 :: due to fix account territory changed bug
                                                        //from Budget_Detail__c where Budget__c = :budget.Id]){
                                                        from Budget_Detail__c where Budget__c = :budget.Id And Account_Territory_Code__c =: theTerritory]){
                                                        //End
                if(!map_tmp.containsKey(detail.Account__c)){
                    map_tmp.put(detail.Account__c, new map<String,Budget_Detail__c>());             
                }
                map_tmp.get(detail.Account__c).put(detail.Type__c, detail);
                set_allAccIds.remove(detail.Account__c);
            }
        }
        if(set_allAccIds.size() > 0){
            for(Budget_Detail__c detail : [select Id, RecordType.DeveloperName, Budget__c, Comments__c, Run_Rate_Business__c,
                                                        Adjustment__c, Price_Increase__c, Account__c, Forecast_CY__c, 
                                                        Market_Growth__c, Obsoletion_EOL__c, Price_Change__c, 
                                                        TAM_DTAM__c, Transfer_In__c, Transfer_Out__c, 
                                                        Type__c, Business_Transfers__c, Growth__c 
                                                        //Added by Bin Yuan 2013-10-14 :: due to fix account territory changed bug
                                                        //from Budget_Detail__c where Budget__r.Year__c = :budgetFiscalYear and Account__c in :set_allAccIds and Budget__c != :BudgetId order by CreatedDate desc]){
                                                        from Budget_Detail__c where Budget__r.Year__c = :budgetFiscalYear and Account__c in :set_allAccIds And Budget__r.Status__c != 'Approved' And
                                                             Budget__c != :BudgetId And Account_Territory_Code__c =: theTerritory order by CreatedDate desc]){
                if(!map_tmp.containsKey(detail.Account__c)){
                    map_tmp.put(detail.Account__c, new map<String,Budget_Detail__c>());
                    map_tmp.get(detail.Account__c).put(detail.Type__c, detail);
                }
                else{
                    Budget_Detail__c d = map_tmp.get(detail.Account__c).values()[0];
                    if(d.Budget__c == detail.Budget__c){
                        map_tmp.get(detail.Account__c).put(detail.Type__c, detail);
                    }
                }           
                //Added by Bin Yuan 2013-10-14 :: due to fix account territory changed bug
                if(!map_existingDetails.containsKey(detail.Account__c)) {
                    map_existingDetails.put(detail.Account__c, new map<String, Budget_Detail__c>());
                }
                if(!map_existingDetails.get(detail.Account__c).containsKey(detail.Type__c)) {
                    map_existingDetails.get(detail.Account__c).put(detail.Type__c, detail);
                }
                //End
            } 
        }
        return map_tmp;
    }   
    //Added by Bin Yuan 2013-10-14 :: due to fix account territory changed bug
    //public static void buildBudgetByAccountId(String budgetFiscalYear, String year, Map<String, ClsAnnualBudgetPlanStructure> map_accId_budgetPlanStructures, List<Id> list_accIds, Budget__c budget, ClsAnnualBudgetPlanStructure totalBP){
    public static void buildBudgetByAccountId(String budgetFiscalYear, String year, Map<String, ClsAnnualBudgetPlanStructure> map_accId_budgetPlanStructures, List<Id> list_accIds, Budget__c budget, ClsAnnualBudgetPlanStructure totalBP, String theTerritory, map<String, map<String,Budget_Detail__c>> map_existingDetails){
        
        String lastYear = String.valueOf(Integer.valueOf(year) - 1);
        String lastBudgetFiscalYear = String.valueOf(Integer.valueOf(budgetFiscalYear) - 1);
        getLoadStatusByYear(year);        
        Decimal directRate = 1, indirectRate = 1;
        Load_Status__c directLS;
        set<Id> set_accIds = new set<Id>();
        set_accIds.addAll(list_accIds);
        if(map_year_loadStatus.containsKey(year)){
            if(map_year_loadStatus.get(year).containsKey('Direct')) {
                directLS = map_year_loadStatus.get(year).get('Direct');                         
            }
            if(map_year_loadStatus.get(year).containsKey('DailyDirect')) {
                directRate = 260/map_year_loadStatus.get(year).get('DailyDirect').Current_Fiscal_Working_Day_in_Year__c;                        
            }           
            if(map_year_loadStatus.get(year).containsKey('Indirect')) {
                indirectRate = 260/map_year_loadStatus.get(year).get('Indirect').Current_Fiscal_Working_Day_in_Year__c;
            }
        }

        // get Daily Booking/Billing/Backlog By Part according to account ids for BillingsRRCY
        if(directLS != null && directLS.Current_Fiscal_Month__c < 12 ){
            Integer nextMonth = Integer.valueOf(directLS.Current_Fiscal_Month__c) +1;
			//Added by Kevin Shen 2016/04/14 ::set all the nextmonth to set collection.
            set<Integer> set_nextMonths = new set<Integer>();
            for(Integer i= nextMonth; i<=12; i++) {
                 set_nextMonths.add(i);
            }
            
            for(AggregateResult agg: [select sum(Bill_Amount_USD__c) amount, 
                                             Customer__r.Plan_Group_Id__c planGroupId, 
                                             Customer__c accId
                                     from BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c
                                     //where Customer__c IN :list_accIds and Fiscal_Year__c = :year and Fiscal_Month__c >= :nextMonth and Bill_Type__c = 'Direct'
                                     //edited by kevin shen 2016/04/14  apply set_nextMonths to query
                                     where Customer__c IN :list_accIds and Fiscal_Year__c = :year and Fiscal_Month__c IN :set_nextMonths and Bill_Type__c = 'Direct'
                                      group by Customer__r.Plan_Group_Id__c, Customer__c]){                   //maybe are changed to Current_Schedule_Date__c             
                String accId, bpType, parentId;
                accId = String.valueOf(agg.get('accId'));   
                Decimal amount = (Decimal) agg.get('amount');
                if(agg.get('planGroupId') != null)  parentId = String.valueOf(agg.get('planGroupId'));   
                if(map_accId_budgetPlanStructures.containsKey(parentId)){
                    ClsAnnualBudgetPlanStructure budgetPlanStructure = map_accId_budgetPlanStructures.get(parentId);              
                    ClsAnnualBudgetPlanStructure.BudgetPlanningAccountStructure bp = budgetPlanStructure.map_accountStructure.get(accId);
                    if(bp != null){
                        budgetPlanStructure.detailDirect.BillingsYTDCY += amount;
                        budgetPlanStructure.detailDirect.BillingsRRCY += (amount * directRate).setScale(2);    
                        bp.detailDirect.BillingsYTDCY = amount;
                    }
                }
            }                   
        }
                
        // get Yearly Booking/Billings By Part data according to account ids    
        for(AggregateResult agg: [select sum(Bill_Amount_USD__c) sum,
                                         Customer__c accId, Bill_Type__c type,
                                         Fiscal_Year__c year, Customer__r.Plan_Group_Id__c parentId 
                                 from BBB_Month_Bill_Book_Cust__c
                                 where Customer__c IN :list_accIds and (Fiscal_Year__c = :year or Fiscal_Year__c = :lastYear) and Monthly_BBB_External_Key__c != null group by Fiscal_Year__c,Customer__r.Plan_Group_Id__c, Customer__c, Bill_Type__c]){
            String accId, bpType, y, parentId;
            accId = String.valueOf(agg.get('accId'));
            bpType = String.valueOf(agg.get('type'));    
            y = String.valueOf(agg.get('year'));
            if(agg.get('parentId') != null)  parentId = String.valueOf(agg.get('parentId'));      
            decimal amount = (decimal) agg.get('sum');
            if(amount == null) amount = 0;    
                  
            if(map_accId_budgetPlanStructures.containsKey(parentId)){
                ClsAnnualBudgetPlanStructure budgetPlanStructure = map_accId_budgetPlanStructures.get(parentId);
                ClsAnnualBudgetPlanStructure.BudgetPlanningAccountStructure bp = budgetPlanStructure.map_accountStructure.get(accId);
                if(bp != null){
                    if(y == lastYear){
                        if(bpType == 'Direct'){
                            budgetPlanStructure.detailDirect.BillingsLY += amount;
                            bp.detailDirect.BillingsLY = amount;
                        }
                        else if(bpType == 'POS'){
                            budgetPlanStructure.detailPOS.BillingsLY += amount;
                            bp.detailPOS.BillingsLY = amount;
                        }
                        else{
                            budgetPlanStructure.detailCMA.BillingsLY += amount;
                            bp.detailCMA.BillingsLY = amount;
                        }                
                    }
                    else{                    
                        // get current year                                                   
                        if(bpType == 'Direct'){
                            budgetPlanStructure.detailDirect.BillingsYTDCY += amount;
                            budgetPlanStructure.detailDirect.BillingsRRCY += (amount * directRate).setScale(2);    
                            bp.detailDirect.BillingsYTDCY += amount;
                            bp.detailDirect.BillingsRRCY = (bp.detailDirect.BillingsYTDCY * directRate).setScale(2);
                            //system.debug('bp.detailDirect.BillingsYTDCY: ' + bp.detailDirect.BillingsYTDCY);
                        }
                        else if(bpType == 'POS'){
                            budgetPlanStructure.detailPOS.BillingsYTDCY += amount;
                            budgetPlanStructure.detailPOS.BillingsRRCY += (amount * indirectRate).setScale(2); 
                            bp.detailPOS.BillingsYTDCY = amount;
                            bp.detailPOS.BillingsRRCY = (amount * indirectRate).setScale(2);                        
                        } 
                        else{
                            budgetPlanStructure.detailCMA.BillingsYTDCY += amount;
                            budgetPlanStructure.detailCMA.BillingsRRCY += (amount * indirectRate).setScale(2); 
                            bp.detailCMA.BillingsYTDCY = amount;
                            bp.detailCMA.BillingsRRCY = (amount * indirectRate).setScale(2);                        
                        }   
                    }                                                                        
                }
            }                           
        }
        
        // get Daily Booking/Billing/Backlog By Part according to account ids
        //Period p = [select Id, StartDate, EndDate from Period where FiscalYearSettings.Name = :year and Type = 'Year' limit 1];  // changed by BYU based on R-1210
        Integer lastdays = 7;
        // Start by Bin Yuan due to change query filter 2013-07-04
        String strFilter = '';
        String strGroupBy =  ' group by Customer__r.Plan_Group_Id__c, Customer__c, Bill_Type__c '; 
        
        Period p = [select Id, StartDate, EndDate from Period where FiscalYearSettings.Name = :year and Type = 'Year' limit 1];

        if(Backlog_Snapshot_Config__c.getInstance('Open Backlog last days') != null 
            && Backlog_Snapshot_Config__c.getInstance('Open Backlog last days').isActive__c != null
            && Backlog_Snapshot_Config__c.getInstance('Open Backlog last days').isActive__c == true
            && Backlog_Snapshot_Config__c.getInstance('Open Backlog last days').Days__c != null){
                
            lastdays = (Integer) Backlog_Snapshot_Config__c.getInstance('Open Backlog last days').Days__c;
            strFilter = ' and Current_Schedule_Date__c >= LAST_N_DAYS:' + lastdays + ' '; 
            
        }
        else if(p.Id != null && p.StartDate != null && p.EndDate != null){
            String periodStartDate = String.valueOf(p.StartDate);
            String periodEndDate = String.valueOf(p.EndDate);
            strFilter = ' and Current_Schedule_Date__c >=' + periodStartDate + ' and Current_Schedule_Date__c <=' + periodEndDate + ' '; 
        }
        
        String query = 'select sum(Backlog_Amount_USD__c) sumBacklog, ' +
                                         'Customer__r.Plan_Group_Id__c planGroupId, Customer__c accId, Bill_Type__c type' +
                                 ' from BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c' +
                                 ' where Customer__c IN :list_accIds';
        query += strFilter;
        query += strGroupBy;
        // End by Bin Yuan due to change query filter 2013-07-04
        for(AggregateResult agg: database.query(query)) {                   //maybe are changed to Current_Schedule_Date__c             
            String accId, bpType, parentId;
            accId = String.valueOf(agg.get('accId')); 
            bpType = String.valueOf(agg.get('type'));   
            if(agg.get('planGroupId') != null)  parentId = String.valueOf(agg.get('planGroupId'));   
            if(map_accId_budgetPlanStructures.containsKey(parentId)){
                ClsAnnualBudgetPlanStructure budgetPlanStructure = map_accId_budgetPlanStructures.get(parentId);    
                ClsAnnualBudgetPlanStructure.BudgetPlanningAccountStructure bp = budgetPlanStructure.map_accountStructure.get(accId);
                if(bp != null){                
                    if(bpType == 'Direct'){
                        budgetPlanStructure.detailDirect.Backlog += (decimal) agg.get('sumBacklog');
                        bp.detailDirect.Backlog = (decimal) agg.get('sumBacklog');
                    }
                    else if(bpType == 'POS'){
                        budgetPlanStructure.detailPOS.Backlog += (decimal) agg.get('sumBacklog');
                        bp.detailPOS.Backlog = (decimal) agg.get('sumBacklog');
                    } 
                    else{
                        budgetPlanStructure.detailCMA.Backlog += (decimal) agg.get('sumBacklog');
                        bp.detailCMA.Backlog = (decimal) agg.get('sumBacklog');
                    }
                }
            }
        }
        
        Set<Id> set_oppyIds = new set<Id>();
        for(AggregateResult partner : [Select Opportunity__c oppId from Opportunity_Partner__c where (Account__c IN :list_accIds or Opportunity__r.AccountId in :list_accIds) and Partner_Role__c in ('Distributor','OEM','CM') and Allocation__c != null and Allocation__c != 0 group by Opportunity__c]){    
            set_oppyIds.add(String.valueOf(partner.get('oppId')));
        }                                                       
        
        // Opportunity according to account ids
        set<String> set_partStatusInvalid = new set<String>{'On Hold','Lost','Dead', 'TAM'};
        set<Id> set_pmvrtIds = ClsPMV_Util.getAllPMVRecordtypes();
        map<String, map<String,Decimal>> map_oppyId_status_value = new map<String, map<String,Decimal>>();
        
        for(AggregateResult ofc: [select Sum(Amount__c) total,
                                                 Part__r.Status__c status,
                                                 Opportunity__c oppId, 
                                                 Opportunity__r.accountId accId, 
                                                 Fiscal_Year__c FY,
                                                 Opportunity__r.account.Plan_Group_Id__c planGroupId                                               
                                          from Opportunity_forecast__c 
                                          where (Fiscal_Year__c = :lastBudgetFiscalYear or Fiscal_Year__c = :budgetFiscalYear)
                                                and Opportunity__c in :set_oppyIds //and Opportunity__r.accountId IN :list_accIds 
                                                and Part__c != null and Amount__c != null 
                                                and (Part__r.Won_Fiscal_Year__c = :year or Part__r.Status__c != 'Won')
                                                and Part__r.Status__c not in :set_partStatusInvalid 
                                                and (Opportunity__r.recordtype.developername='Opportunity_Engineering_Project' or Opportunity__r.RecordTypeId IN :set_pmvrtIds or (Opportunity__r.recordtype.developername='Opportunity_Sales_Parts_Only' and (Opportunity__r.type = 'New Business' or Opportunity__r.type = 'Replacement of Existing Business'))) 
                                                group by Part__r.Status__c,
                                                        Opportunity__r.accountId, 
                                                        Opportunity__r.account.Plan_Group_Id__c,
                                                        Opportunity__c,                                                 
                                                        Fiscal_Year__c]){
                                                            
            String parentId, accId, FY, status, oppId;  
            status = (String) ofc.get('status'); 
            accId = (String) ofc.get('accId');
            oppId = (String) ofc.get('oppId');
            FY = (String) ofc.get('FY');
            Decimal amount = 0;
            if(ofc.get('planGroupId') != null) parentId = (String) ofc.get('planGroupId');
            if(ofc.get('total') != null && ofc.get('total') != '') amount = (Decimal) ofc.get('total');
            if(FY == lastBudgetFiscalYear){
                amount = -amount;
            }
        
            if(!map_oppyId_status_value.containsKey(oppId)){
                map_oppyId_status_value.put(oppId, new map<String,Decimal>());
            }
            if(!map_oppyId_status_value.get(oppId).containsKey(status)){
                map_oppyId_status_value.get(oppId).put(status, 0);
            }
            Decimal curr = map_oppyId_status_value.get(oppId).get(status);
            amount += curr;    
            map_oppyId_status_value.get(oppId).put(status, amount);                        
        }
        
        //Opportunity data in Direct / POS / CMA based on partner allocation of the opportunity. User Story:https://c2s.my.salesforce.com/a0kE0000001rO19
        for(Opportunity_Partner__c partner : [Select Account__c,Account__r.Plan_Group_Id__c,  Opportunity__c, Opportunity__r.AccountId, Opportunity__r.Account.Plan_Group_Id__c, Allocation__c, Partner_Role__c from Opportunity_Partner__c where Opportunity__c in :map_oppyId_status_value.keySet() and Partner_Role__c in ('Distributor','OEM','CM') and Allocation__c != null and Allocation__c != 0]){                                                         
            String parentId, accId, role, oppId, partnerAccId, partnerParentId;  
            parentId = partner.Opportunity__r.Account.Plan_Group_Id__c;
            role = partner.Partner_Role__c; 
            accId = partner.Opportunity__r.AccountId;
            partnerAccId = partner.Account__c;
            partnerParentId = partner.Account__r.Plan_Group_Id__c;
            oppId = partner.Opportunity__c;
            Decimal amount = 0;
            ClsAnnualBudgetPlanStructure budgetPlanStructure;
            ClsAnnualBudgetPlanStructure.BudgetPlanningAccountStructure bp;
            map<String, Decimal> map_status_value = map_oppyId_status_value.get(oppId);           
            if(map_accId_budgetPlanStructures.containsKey(parentId) && map_accId_budgetPlanStructures.get(parentId).map_accountStructure.containsKey(accId)){
                budgetPlanStructure = map_accId_budgetPlanStructures.get(parentId);
                bp = budgetPlanStructure.map_accountStructure.get(accId);   
                if(bp != null){ 
                    for(String status : map_status_value.keySet()){
                        amount = map_status_value.get(status) * partner.Allocation__c /100;
                        if(amount != 0){
                            //only the value of account self can be shown as direct
                            if(role == 'OEM' && partnerAccId == accId){     
                                allocatedOpportunityValues(status, budgetPlanStructure.detailDirect, bp.detailDirect, amount);                                              
                            }
                            else if(partnerAccId != accId){
                                if(role == 'Distributor'){
                                    allocatedOpportunityValues(status, budgetPlanStructure.detailPOS, bp.detailPOS, amount);                                    
                                }                       
        
                                else if(role == 'CM'){
                                    allocatedOpportunityValues(status, budgetPlanStructure.detailCMA, bp.detailCMA, amount);                                                
                                }                                                               
                            }  
                        }           
                    }
                }
            }
            
            if(partnerAccId != accId && set_accIds.contains(partnerAccId)){             
                if(map_accId_budgetPlanStructures.containsKey(partnerAccId)){
                    budgetPlanStructure = map_accId_budgetPlanStructures.get(partnerAccId);   
                    bp = budgetPlanStructure.map_accountStructure.get(partnerAccId);  
                    if(bp != null){
                        for(String status : map_status_value.keySet()){
                            amount = map_status_value.get(status) * partner.Allocation__c /100;
                            allocatedOpportunityValues(status, budgetPlanStructure.detailDirect, bp.detailDirect, amount);  
                        } 
                    }                   
                }
                else{                   
                    if(map_accId_budgetPlanStructures.containsKey(partnerParentId)){
                        budgetPlanStructure = map_accId_budgetPlanStructures.get(partnerParentId);   
                        bp = budgetPlanStructure.map_accountStructure.get(partnerAccId);   
                        if(bp != null){
                            for(String status : map_status_value.keySet()){
                                amount = map_status_value.get(status) * partner.Allocation__c /100; 
                                allocatedOpportunityValues(status, budgetPlanStructure.detailDirect, bp.detailDirect, amount);
                            }
                        }                   
                    }
                }                                           
            }               
        } 
        //Added by Bin Yuan 2013-10-14 :: due to fix account territory changed bug
        //map<String, map<String,Budget_Detail__c>> map_tmp = fillOldBudgetDetailsIntoStructure(budgetFiscalYear, list_accIds, budget);
        map<String, map<String,Budget_Detail__c>> map_tmp = fillOldBudgetDetailsIntoStructure(budgetFiscalYear, list_accIds, budget, theTerritory, map_existingDetails);
        //End
        
        //set EstimatedFinalCY
        for(String accId: map_accId_budgetPlanStructures.keySet()){
            ClsAnnualBudgetPlanStructure budgetPlanStructure = map_accId_budgetPlanStructures.get(accId);  
            for(String aId : map_accId_budgetPlanStructures.get(accId).map_accountStructure.keySet()){
                ClsAnnualBudgetPlanStructure.BudgetPlanningAccountStructure bp = map_accId_budgetPlanStructures.get(accId).map_accountStructure.get(aId);
                if(bp != null){
                    if(map_tmp.containsKey(aId)){
                        for(String s : map_tmp.get(aId).keySet()){
                            if(s == 'Direct'){
                                copyDeatilIntoStructure(budgetPlanStructure.detailDirect, map_tmp.get(aId).get(s));
                                copyDeatilIntoAccountStructure(bp.detailDirect, map_tmp.get(aId).get(s));
                            }
                            else if(s == 'POS'){
                                copyDeatilIntoStructure(budgetPlanStructure.detailPOS, map_tmp.get(aId).get(s));
                                copyDeatilIntoAccountStructure(bp.detailPOS, map_tmp.get(aId).get(s));
                            }   
                            else if(s == 'CMA'){
                                copyDeatilIntoStructure(budgetPlanStructure.detailCMA, map_tmp.get(aId).get(s));
                                copyDeatilIntoAccountStructure(bp.detailCMA, map_tmp.get(aId).get(s));
                            }                                           
                        }
                    }
                    else{
                                    
                        budgetPlanStructure.detailDirect.EstimatedFinalCY += bp.detailDirect.BillingsRRCY;
                        budgetPlanStructure.detailPOS.EstimatedFinalCY += bp.detailPOS.BillingsRRCY;
                        budgetPlanStructure.detailCMA.EstimatedFinalCY += bp.detailCMA.BillingsRRCY;
                    }
                }
            }
        }
        
        for(String accId: map_accId_budgetPlanStructures.keySet()){
            ClsAnnualBudgetPlanStructure budgetPlanStructure = map_accId_budgetPlanStructures.get(accId);  
                
            // run rate business
            calRunRateBusiValue(budgetPlanStructure.detailDirect);
            calRunRateBusiValue(budgetPlanStructure.detailPOS);
            calRunRateBusiValue(budgetPlanStructure.detailCMA);

            setTotalByType(budgetPlanStructure.detailDirect);   
            setTotalByType(budgetPlanStructure.detailPOS);  
            setTotalByType(budgetPlanStructure.detailCMA);  
                                             
            // adjusted business
            calAdjustedBusiValue(budgetPlanStructure.detailDirect);
            calAdjustedBusiValue(budgetPlanStructure.detailPOS);
            calAdjustedBusiValue(budgetPlanStructure.detailCMA);
    
            // calculated budget
            budgetPlanStructure.detailDirect.Forecast = budgetPlanStructure.detailDirect.AdjRepeatBusiness + budgetPlanStructure.detailDirect.OpportunitiesWon;
            budgetPlanStructure.detailPOS.Forecast = budgetPlanStructure.detailPOS.AdjRepeatBusiness + budgetPlanStructure.detailPOS.OpportunitiesWon;
            budgetPlanStructure.detailCMA.Forecast = budgetPlanStructure.detailCMA.AdjRepeatBusiness + budgetPlanStructure.detailCMA.OpportunitiesWon;
            
            // calculated Market growth
            calGrowthPer(budgetPlanStructure.detailDirect);
            calGrowthPer(budgetPlanStructure.detailPOS);
            calGrowthPer(budgetPlanStructure.detailCMA);
            //Start :: 2013-07-05 by Bin Yuan due to fix recalculate value missing
            setStructureValues(budgetPlanStructure, totalBP, accId, true);
            //setStructureValues(budgetPlanStructure, totalBP, accId, false);
            //End ::
        } 
        
        setTotalAccountGrowth(totalBP.detailDirect);
        setTotalAccountGrowth(totalBP.detailPOS);
        setTotalAccountGrowth(totalBP.detailCMA);
        setTotalAccountGrowth(totalBP.detailTotal);       
    }

    private static void copyDeatilIntoStructure(ClsAnnualBudgetPlanStructure.BudgetPlanningItem item, Budget_Detail__c detail){
        if(detail.Forecast_CY__c != null) item.EstimatedFinalCY += detail.Forecast_CY__c;
        if(detail.Obsoletion_EOL__c != null) item.ObsoletionEOL += detail.Obsoletion_EOL__c;
        if(detail.Transfer_Out__c != null) item.TransferOut += detail.Transfer_Out__c;
        if(detail.Transfer_In__c != null) item.TransferIn += detail.Transfer_In__c;
        if(detail.TAM_DTAM__c != null) item.TAMDTAM  += detail.TAM_DTAM__c;
        //Start :: 2013-07-05 by Bin Yuan due to fix value missing bug(customer growth %, market price change % and comments) 
        //if(detail.Market_Growth__c != null) item.CustomerGrowth += detail.Market_Growth__c ;
        //if(detail.Price_Increase__c != null)  item.PriceIncrease += detail.Price_Increase__c;
        if(detail.Market_Growth__c != null) item.CustomerGrowth += detail.Run_Rate_Business__c == 0 ? detail.Market_Growth__c : (detail.Market_Growth__c * detail.Run_Rate_Business__c).setScale(1);
        if(detail.Price_Increase__c != null) item.PriceIncrease += detail.Run_Rate_Business__c == 0 ? detail.Price_Increase__c : (detail.Price_Increase__c * detail.Run_Rate_Business__c).setScale(1);
        //End ::
        if(detail.Price_Change__c != null)  item.MarketPriceChange += detail.Price_Change__c;
        if(detail.Adjustment__c != null) item.Adjustment += detail.Adjustment__c;
        if(detail.Growth__c != null) item.Growth += detail.Growth__c;       
        //Start :: 2013-07-05 by Bin Yuan due to fix value missing bug(customer growth %, market price change % and comments) 
        if(detail.Comments__c != null) item.Comments = detail.Comments__c;  
        //End ::           
    }

    private static void copyDeatilIntoAccountStructure(ClsAnnualBudgetPlanStructure.BudgetPlanningAccountItem item, Budget_Detail__c detail){
        if(detail.Forecast_CY__c != null) item.EstimatedFinalCY = detail.Forecast_CY__c;
        if(detail.Obsoletion_EOL__c != null) item.ObsoletionEOL = detail.Obsoletion_EOL__c;
        if(detail.Transfer_Out__c != null) item.TransferOut = detail.Transfer_Out__c;
        if(detail.Transfer_In__c != null) item.TransferIn = detail.Transfer_In__c;
        if(detail.TAM_DTAM__c != null) item.TAMDTAM  = detail.TAM_DTAM__c;
        if(detail.Market_Growth__c != null) item.CustomerGrowth = detail.Market_Growth__c;
        if(detail.Price_Change__c != null)  item.MarketPriceChange = detail.Price_Change__c;
        if(detail.Price_Increase__c != null)  item.PriceIncrease = detail.Price_Increase__c;
        if(detail.Adjustment__c != null) item.Adjustment = detail.Adjustment__c;               
    }                   
        
    /**
    * The method is used to calculate the Growth % value in single budget detail
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return             
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    private static void setTotalByType(ClsAnnualBudgetPlanStructure.BudgetPlanningItem detail){
        detail.CustomerGrowth = detail.RepeatBusiness==0? 0:(detail.CustomerGrowth/detail.RepeatBusiness).setScale(1);
        detail.MarketPriceChange = detail.RepeatBusiness==0? 0:(detail.MarketPriceChange/detail.RepeatBusiness).setScale(1);
        detail.PriceIncrease = detail.RepeatBusiness==0? 0:(detail.PriceIncrease/detail.RepeatBusiness).setScale(1);                                          
    }

    public static Budget_Detail__c createBudgetDetailFromStructureDetail(String budgetId, String t, String accId, ClsAnnualBudgetPlanStructure.BudgetPlanningItem item, ClsAnnualBudgetPlanStructure.BudgetPlanningAccountItem accItem,  String recordTypeId, Integer size){
        Budget_Detail__c detail = new Budget_Detail__c();
        detail.Account__c = accId;
        detail.Type__c = t;
        detail.RecordTypeId = recordTypeId;
        detail.Budget__c = budgetId;
        detail.Billings_LY__c = accItem.BillingsLY;
        detail.Billings_CYTD__c = accItem.BillingsYTDCY;
        detail.Billings_CYRR__c = accItem.BillingsRRCY;
        detail.Backlog__c = accItem.Backlog;
        detail.Opportunities_Won__c = accItem.OpportunitiesWon;
        detail.Opportunities_Commit__c = accItem.OpportunitiesCommit;
        detail.Opportunities50_50__c = accItem.Opportunities5050;
        detail.Opportunities_Weak__c = accItem.OpportunitiesWeak;
        detail.Opportunities_Likely__c = accItem.OpportunitiesLikely;
        decimal p = 1.0;
        if(item.BillingsRRCY != 0) p = accItem.BillingsRRCY / item.BillingsRRCY;
        else if(size != null && size != 0) p = 1.0/size;
        
        detail.Forecast_CY__c = item.EstimatedFinalCY * p;
        detail.Obsoletion_EOL__c = item.ObsoletionEOL * p;
        detail.Transfer_In__c = item.TransferIn * p;
        detail.Transfer_Out__c = item.TransferOut * p;
        detail.TAM_DTAM__c = item.TAMDTAM * p;
        detail.Adjustment__c = item.Adjustment * p;
        detail.Market_Growth__c = item.CustomerGrowth;// * p;
        detail.Price_Change__c = item.MarketPriceChange;// * p;
        detail.Price_Increase__c = item.PriceIncrease;// * p;
        return detail;
    }   
    
            
    private static void setStructureValues(ClsAnnualBudgetPlanStructure budgetPlanStructure, ClsAnnualBudgetPlanStructure totalBP, String accId, Boolean setTotalByType4Other){            
        budgetPlanStructure.detailTotal.BillingsLY = budgetPlanStructure.detailDirect.BillingsLY + budgetPlanStructure.detailPOS.BillingsLY + budgetPlanStructure.detailCMA.BillingsLY;
        budgetPlanStructure.detailTotal.BillingsYTDCY = budgetPlanStructure.detailDirect.BillingsYTDCY + budgetPlanStructure.detailPOS.BillingsYTDCY + budgetPlanStructure.detailCMA.BillingsYTDCY;
        budgetPlanStructure.detailTotal.BillingsRRCY = budgetPlanStructure.detailDirect.BillingsRRCY + budgetPlanStructure.detailPOS.BillingsRRCY + budgetPlanStructure.detailCMA.BillingsRRCY;
        budgetPlanStructure.detailTotal.Backlog = budgetPlanStructure.detailDirect.Backlog + budgetPlanStructure.detailPOS.Backlog + budgetPlanStructure.detailCMA.Backlog;
        budgetPlanStructure.detailTotal.EstimatedFinalCY = budgetPlanStructure.detailDirect.EstimatedFinalCY + budgetPlanStructure.detailPOS.EstimatedFinalCY + budgetPlanStructure.detailCMA.EstimatedFinalCY;
        budgetPlanStructure.detailTotal.MarketPriceChange = budgetPlanStructure.detailDirect.MarketPriceChange * budgetPlanStructure.detailDirect.RepeatBusiness + budgetPlanStructure.detailPOS.MarketPriceChange * budgetPlanStructure.detailPOS.RepeatBusiness + budgetPlanStructure.detailCMA.MarketPriceChange * budgetPlanStructure.detailCMA.RepeatBusiness;
        //budgetPlanStructure.detailTotal.PriceIncrease = (budgetPlanStructure.detailDirect.PriceIncrease * budgetPlanStructure.detailDirect.RepeatBusiness + budgetPlanStructure.detailPOS.PriceIncrease * budgetPlanStructure.detailPOS.RepeatBusiness + budgetPlanStructure.detailCMA.PriceIncrease * budgetPlanStructure.detailCMA.RepeatBusiness)/budgetPlanStructure.detailTotal.RepeatBusiness;          
        budgetPlanStructure.detailTotal.OpportunitiesWon = budgetPlanStructure.detailDirect.OpportunitiesWon + budgetPlanStructure.detailPOS.OpportunitiesWon + budgetPlanStructure.detailCMA.OpportunitiesWon;         
        budgetPlanStructure.detailTotal.OpportunitiesCommit = budgetPlanStructure.detailDirect.OpportunitiesCommit + budgetPlanStructure.detailPOS.OpportunitiesCommit + budgetPlanStructure.detailCMA.OpportunitiesCommit;                                             
        budgetPlanStructure.detailTotal.OpportunitiesLikely = budgetPlanStructure.detailDirect.OpportunitiesLikely + budgetPlanStructure.detailPOS.OpportunitiesLikely + budgetPlanStructure.detailCMA.OpportunitiesLikely;                     
        budgetPlanStructure.detailTotal.Opportunities5050 = budgetPlanStructure.detailDirect.Opportunities5050 + budgetPlanStructure.detailPOS.Opportunities5050 + budgetPlanStructure.detailCMA.Opportunities5050;                     
        budgetPlanStructure.detailTotal.OpportunitiesWeak = budgetPlanStructure.detailDirect.OpportunitiesWeak + budgetPlanStructure.detailPOS.OpportunitiesWeak + budgetPlanStructure.detailCMA.OpportunitiesWeak;                                                     
        budgetPlanStructure.detailTotal.RepeatBusiness = budgetPlanStructure.detailDirect.RepeatBusiness + budgetPlanStructure.detailPOS.RepeatBusiness + budgetPlanStructure.detailCMA.RepeatBusiness;
        //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'accId:' + accId + ' budgetPlanStructure.detailTotal.RepeatBusiness:' + budgetPlanStructure.detailTotal.RepeatBusiness)); //+', budgetPlanStructure.detailDirect.CustomerGrowth:' + budgetPlanStructure.detailDirect.CustomerGrowth + ' budgetPlanStructure.detailDirect.PriceIncrease:' + budgetPlanStructure.detailDirect.PriceIncrease));
        budgetPlanStructure.detailTotal.ObsoletionEOL = budgetPlanStructure.detailDirect.ObsoletionEOL + budgetPlanStructure.detailPOS.ObsoletionEOL + budgetPlanStructure.detailCMA.ObsoletionEOL;
        budgetPlanStructure.detailTotal.TransferOut = budgetPlanStructure.detailDirect.TransferOut + budgetPlanStructure.detailPOS.TransferOut + budgetPlanStructure.detailCMA.TransferOut;
        budgetPlanStructure.detailTotal.TransferIn = budgetPlanStructure.detailDirect.TransferIn + budgetPlanStructure.detailPOS.TransferIn + budgetPlanStructure.detailCMA.TransferIn;
        budgetPlanStructure.detailTotal.TAMDTAM = budgetPlanStructure.detailDirect.TAMDTAM + budgetPlanStructure.detailPOS.TAMDTAM + budgetPlanStructure.detailCMA.TAMDTAM;
        budgetPlanStructure.detailTotal.ObsoletionEOL = budgetPlanStructure.detailDirect.ObsoletionEOL + budgetPlanStructure.detailPOS.ObsoletionEOL + budgetPlanStructure.detailCMA.ObsoletionEOL;
        //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'ObsoletionEOL :: ' + budgetPlanStructure.detailTotal.ObsoletionEOL)); 
        budgetPlanStructure.detailTotal.CustomerGrowth = (budgetPlanStructure.detailDirect.CustomerGrowth * budgetPlanStructure.detailDirect.RepeatBusiness + budgetPlanStructure.detailPOS.CustomerGrowth * budgetPlanStructure.detailPOS.RepeatBusiness + budgetPlanStructure.detailCMA.CustomerGrowth * budgetPlanStructure.detailCMA.RepeatBusiness);
        budgetPlanStructure.detailTotal.PriceIncrease = (budgetPlanStructure.detailDirect.PriceIncrease * budgetPlanStructure.detailDirect.RepeatBusiness + budgetPlanStructure.detailPOS.PriceIncrease * budgetPlanStructure.detailPOS.RepeatBusiness + budgetPlanStructure.detailCMA.PriceIncrease * budgetPlanStructure.detailCMA.RepeatBusiness);           
        /*
        if(setTotalByType4Other){
            setTotalByType(budgetPlanStructure.detailDirect);   
            setTotalByType(budgetPlanStructure.detailPOS);  
            setTotalByType(budgetPlanStructure.detailCMA);              
        }
        */
        //Start by Bin Yuan 2013-10-21 due to fix Budget NY bug
        budgetPlanStructure.detailTotal.budgetNY = budgetPlanStructure.detailDirect.budgetNY + budgetPlanStructure.detailPOS.budgetNY + budgetPlanStructure.detailCMA.budgetNY;
        //End
        
        setTotalByType(budgetPlanStructure.detailTotal);    
        
        budgetPlanStructure.detailTotal.AdjRepeatBusiness = budgetPlanStructure.detailDirect.AdjRepeatBusiness + budgetPlanStructure.detailPOS.AdjRepeatBusiness + budgetPlanStructure.detailCMA.AdjRepeatBusiness;
        budgetPlanStructure.detailTotal.Forecast = budgetPlanStructure.detailDirect.Forecast + budgetPlanStructure.detailPOS.Forecast + budgetPlanStructure.detailCMA.Forecast;             
        budgetPlanStructure.detailTotal.Adjustment = budgetPlanStructure.detailDirect.Adjustment+ budgetPlanStructure.detailPOS.Adjustment+ budgetPlanStructure.detailCMA.Adjustment;   
        calGrowthPer(budgetPlanStructure.detailTotal);      
        
        budgetPlanStructure.detailDirect.TotalBudget = budgetPlanStructure.detailDirect.Forecast + budgetPlanStructure.detailDirect.Adjustment; 
        budgetPlanStructure.detailPOS.TotalBudget = budgetPlanStructure.detailPOS.Forecast + budgetPlanStructure.detailPOS.Adjustment;  
        budgetPlanStructure.detailCMA.TotalBudget = budgetPlanStructure.detailCMA.Forecast + budgetPlanStructure.detailCMA.Adjustment;                      
        budgetPlanStructure.detailTotal.TotalBudget = budgetPlanStructure.detailTotal.Forecast + budgetPlanStructure.detailTotal.Adjustment;      
                                            
        //Top Total Budget Planning
        setTotalAccountValue(totalBP.detailTotal, budgetPlanStructure.detailTotal);
        setTotalAccountValue(totalBP.detailDirect, budgetPlanStructure.detailDirect);   
        setTotalAccountValue(totalBP.detailPOS, budgetPlanStructure.detailPOS);
        setTotalAccountValue(totalBP.detailCMA, budgetPlanStructure.detailCMA);
                                            
        if(accId != null){
            totalBP.detailDirect.TotalAccountBudget += budgetPlanStructure.detailDirect.TotalBudget;
            totalBP.detailPOS.TotalAccountBudget += budgetPlanStructure.detailPOS.TotalBudget;
            totalBP.detailCMA.TotalAccountBudget += budgetPlanStructure.detailCMA.TotalBudget;
            totalBP.detailTotal.TotalAccountBudget += budgetPlanStructure.detailTotal.TotalBudget;
        }   
        else{
            totalBP.detailDirect.TotalOtherBudget += budgetPlanStructure.detailDirect.TotalBudget;
            totalBP.detailPOS.TotalOtherBudget += budgetPlanStructure.detailPOS.TotalBudget;
            totalBP.detailCMA.TotalOtherBudget += budgetPlanStructure.detailCMA.TotalBudget;
            totalBP.detailTotal.TotalOtherBudget += budgetPlanStructure.detailTotal.TotalBudget;                
        }       
    
    }
    
    private static void setTotalAccountValue(ClsAnnualBudgetPlanStructure.BudgetPlanningItem totalBPDetail, ClsAnnualBudgetPlanStructure.BudgetPlanningItem detail){
        totalBPDetail.BillingsLY += detail.BillingsLY; 
        totalBPDetail.BillingsYTDCY += detail.BillingsYTDCY;   
        totalBPDetail.BillingsRRCY += detail.BillingsRRCY;   
        //Start :: by Bin Yuan due to fix STC-2013-07-23-3185
        //totalBPDetail.BillingsYTDCY += detail.BillingsYTDCY;   
        //End
        totalBPDetail.Backlog += detail.Backlog;   
        totalBPDetail.EstimatedFinalCY += detail.EstimatedFinalCY;   
        totalBPDetail.RepeatBusiness += detail.RepeatBusiness;   
        totalBPDetail.AdjRepeatBusiness += detail.AdjRepeatBusiness;   
        //totalBPDetail.CustomerGrowth += detail.CustomerGrowth;   
        totalBPDetail.MarketPriceChange += detail.MarketPriceChange;   
        //totalBPDetail.PriceIncrease += detail.PriceIncrease;   
        totalBPDetail.OpportunitiesWon += detail.OpportunitiesWon;              
        totalBPDetail.OpportunitiesCommit += detail.OpportunitiesCommit;   
        totalBPDetail.OpportunitiesLikely += detail.OpportunitiesLikely;   
        totalBPDetail.Opportunities5050 += detail.Opportunities5050;  
        totalBPDetail.Adjustment += detail.Adjustment; 
        
        totalBPDetail.OpportunitiesWeak += detail.OpportunitiesWeak;
        totalBPDetail.CustomerGrowth +=  detail.CustomerGrowth * detail.RepeatBusiness;
        totalBPDetail.PriceIncrease +=  detail.PriceIncrease * detail.RepeatBusiness;   
        //Added by Bin Yuan 2013-07-15 to fix total value not roll up bug
        totalBPDetail.ObsoletionEOL += detail.ObsoletionEOL;
        totalBPDetail.TransferOut += detail.TransferOut;
        totalBPDetail.TransferIn += detail.TransferIn;
        totalBPDetail.TAMDTAM += detail.TAMDTAM;
        totalBPDetail.Forecast += detail.Forecast;
        //End     
        //Start by Bin Yuan 2013-10-21 due to fix Budget NY bug
        totalBPDetail.budgetNY += detail.budgetNY;
        //End
    }
    
    private static void setTotalAccountGrowth(ClsAnnualBudgetPlanStructure.BudgetPlanningItem totalBPDetail){
        //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'RepeatBusiness :: ' + totalBPDetail.RepeatBusiness));       
        totalBPDetail.CustomerGrowth = totalBPDetail.RepeatBusiness==0? 1:(totalBPDetail.CustomerGrowth/totalBPDetail.RepeatBusiness).setScale(1);
        totalBPDetail.MarketPriceChange = totalBPDetail.RepeatBusiness==0? 1:(totalBPDetail.MarketPriceChange/totalBPDetail.RepeatBusiness).setScale(1);
        totalBPDetail.PriceIncrease = totalBPDetail.RepeatBusiness==0? 1:(totalBPDetail.PriceIncrease/totalBPDetail.RepeatBusiness).setScale(1);  
        totalBPDetail.TotalBudget = totalBPDetail.TotalAccountBudget + totalBPDetail.TotalOtherBudget;
        totalBPDetail.Growth = (totalBPDetail.EstimatedFinalCY == 0 ? 0 : (totalBPDetail.TotalBudget / totalBPDetail.EstimatedFinalCY - 1));
        totalBPDetail.Growth = (totalBPDetail.Growth * 100);    
        //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'totalBPDetail.TotalBudget :: ' + totalBPDetail.TotalBudget));
        //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'totalBPDetail.EstimatedFinalCY :: ' + totalBPDetail.EstimatedFinalCY));
        //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'totalBPDetail.Growth :: ' + totalBPDetail.Growth));
    }
    
    public static void calGrowthPer(ClsAnnualBudgetPlanStructure.BudgetPlanningItem detail){
        Decimal growth = detail.Forecast;
        growth += detail.Adjustment;
        //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'detail.Forecast :: ' + detail.Forecast));
        //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'detail.Adjustment :: ' + detail.Adjustment));
        growth = (detail.EstimatedFinalCY ==0 ? 0 : growth/detail.EstimatedFinalCY - 1);       
        detail.Growth = (growth*100).setScale(1);
        //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'detail.EstimatedFinalCY :: ' + detail.EstimatedFinalCY));
        //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'detail.Growth :: ' + detail.Growth));        
    }    
    /**
    * The method is used to calculate the run rate business value in single budget detail
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return             
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */   
    public static void calRunRateBusiValue(ClsAnnualBudgetPlanStructure.BudgetPlanningItem detail){
        // run rate business
        Decimal runRateBusiValue = 0;
        runRateBusiValue += detail.EstimatedFinalCY;
        runRateBusiValue += detail.ObsoletionEOL;
        runRateBusiValue += detail.TransferOut;
        runRateBusiValue += detail.TransferIn;
        runRateBusiValue += detail.TAMDTAM;   
        detail.RepeatBusiness = runRateBusiValue;
    }
    
    /**
    * The method is used to calculate the adjusted business value in single budget detail
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return             
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */   
    public static void calAdjustedBusiValue(ClsAnnualBudgetPlanStructure.BudgetPlanningItem detail){
        // run rate business
        Decimal adjustedBusiValue = detail.RepeatBusiness;
        // Modified by Bin Yuan due to fix CustomerGrowth, MarketPriceChange or PriceIncrease < 0 not calc bug('< 0' ==> '!= 0')
        if(detail.CustomerGrowth != 0) adjustedBusiValue += detail.RepeatBusiness * (detail.CustomerGrowth / 100);
        if(detail.MarketPriceChange != 0) adjustedBusiValue += detail.RepeatBusiness * (detail.MarketPriceChange / 100);
        if(detail.PriceIncrease != 0) adjustedBusiValue += detail.RepeatBusiness * (detail.PriceIncrease / 100);
        detail.AdjRepeatBusiness = adjustedBusiValue;
    }
    

    
    /**
    * The method is used to get the currency IsoCode, currency Rate
    *
    @author Bin yu
    @created 2012-03-23
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return            map<String, >   key is IsoCode, value is Rate.
    *
    @changelog
    * 2012-03-23 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */

    private static void getExchangeRate(){
        if(map_isoCode_exchangeRate == null){
            map_isoCode_exchangeRate = new map<String, Decimal>();
            for(CurrencyType ct : [SELECT  IsActive, IsCorporate, CreatedById, CreatedDate, IsoCode, Id, DecimalPlaces, LastModifiedById, LastModifiedDate, SystemModstamp, ConversionRate  from CurrencyType]){
                map_isoCode_exchangeRate.put(ct.IsoCode, ct.ConversionRate);
            }
        }
    }
    
    /**
    * The method is used to exchange the value between different IsoCode
    *
    @author Bin yu
    @created 2012-03-23
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return            map<String, >   key is IsoCode, value is Rate.
    *
    @changelog
    * 2012-03-23 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static Decimal transformIsoCode(Decimal sourceValue, String fromIsoCode, String toIsoCode){
        Decimal result = 0;
        if(sourceValue != null){
            String k = fromIsoCode + toIsoCode;
            if(map_convertionRate.containsKey(k)){
                return sourceValue * map_convertionRate.get(k);
            }
            
            Decimal fromRate = 1; 
            Decimal toRate = 1; 
            getExchangeRate();
            if(map_isoCode_exchangeRate.get(fromIsoCode) != null && String.ValueOf(map_isoCode_exchangeRate.get(fromIsoCode)) != '') fromRate =  map_isoCode_exchangeRate.get(fromIsoCode);
            else fromRate = 1;
            if(map_isoCode_exchangeRate.get(toIsoCode) != null && String.ValueOf(map_isoCode_exchangeRate.get(toIsoCode)) != '') toRate =  map_isoCode_exchangeRate.get(toIsoCode);
            else toRate = 1;
            
            result = sourceValue * ( toRate / fromRate );
            map_convertionRate.put(k, toRate / fromRate);
        }           
        return result;
    }
    
    
    public static void determineApprover(Budget__c budget){
        List<Sales_Hierarchy__c> list_sh = [Select Id, Level_6_Assigned_User_Network_Ids__c From Sales_Hierarchy__c Where id = :budget.Territory__c];
        if(!list_sh.isEmpty()){
            List<User> list_users = [Select Id, Te_Network_Id__c From User Where Te_Network_Id__c = :list_sh[0].Level_6_Assigned_User_Network_Ids__c limit 1];      
            if(!list_users.isEmpty()){
                budget.manager__c = list_users[0].Id;
            }
        }       
    }
    
    /**
    * The method is used to populate the plan group id on Account
    *
    @author Min Liu
    @created 2012-09-10
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param     budget detail          
    *
    @return             
    *
    @changelog
    * 2012-09-10 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public static void updatePlanGroupId(List<Account> list_accounts, Map<Id, Boolean> map_parentId_planned,  String extType, String sqlType){
        if(extType == 'trigger'){
            List<Account> list_childrenAccounts = new List<Account>();
            for(Account acc :[select id, Plan_Group_Id__c, Plan_Group_Account__c, Individually_Planned__c from Account where Plan_Group_Account__c IN :map_parentId_planned.keySet() and Plan_Group_Account__c != null]){
                if(sqlType != 'delete'){
                    if(!map_parentId_planned.get(acc.Plan_Group_Account__c)){
                        acc.Plan_Group_Id__c = '';
                        acc.Plan_Group_Account__c = null;
                    }               
                }
                else{
                    acc.Plan_Group_Id__c = '';
                    acc.Plan_Group_Account__c = null;
                }
                list_childrenAccounts.add(acc);
            }
            if(!list_childrenAccounts.isEmpty()) update list_childrenAccounts;
        }
        else if(extType == 'batch'){
            if(list_accounts != null && !list_accounts.isEmpty()) {
                for(Account acc : list_accounts){
                    if(acc.Individually_Planned__c){
                        acc.Plan_Group_Id__c = acc.Plan_Group_Account__c == null ? String.valueOf(acc.id).subString(0, 15) : String.valueOf(acc.Plan_Group_Account__c).subString(0, 15);
                    }else{
                        if(acc.Plan_Group_Account__c == null){
                            acc.Plan_Group_Id__c = '';
                        }
                        else{
                            if(acc.Plan_Group_Account__r.Individually_Planned__c){
                                acc.Plan_Group_Id__c = String.valueOf(acc.Plan_Group_Account__c).subString(0, 15);
                            }
                            else{
                                acc.Plan_Group_Id__c = '';
                                acc.Plan_Group_Account__c = null;
                            }
                        }                   
                    }
                }
                update list_accounts;                   
            }
        }       
    }
    
    //added by xia 2013-06-04
    public static Decimal getFiscalMonth(Date d){
        String monthLab;
        for(Period p:[select Id, FiscalYearSettingsId, Type, StartDate, EndDate, SystemModstamp, IsForecastPeriod, QuarterLabel, PeriodLabel, Number from Period where Type='Month' and StartDate <=: d and EndDate >=: d limit 1]){
            monthLab = p.PeriodLabel;
        }
        return MAP_MONTHLABELNUMBER.get(monthLab);
    } 

    public static void setBBBMonthlyValuesByBudgets(List<Budget__c> list_budgets){
        set<Id> set_ownerIds = new Set<Id>();
        Set<String> set_territory = new Set<String>();
        Set<Id> set_accIds = new Set<Id>();
        Set<String> set_years = new Set<String>();
        
        map<Id, Budget__c> map_bId_budget = new map<Id, Budget__c>();
        map<Id, map<String, Budget__c>> map_accId_year_budget = new map<Id, map<String, Budget__c>>();
        map<Id, map<String, map<String, Budget__c>>> map_ownerId_territory_year_budget = new map<Id, map<String, map<String, Budget__c>>>();
        
        for(Budget__c b :list_budgets){
            map_bId_budget.put(b.id, b);
            set_ownerIds.add(b.ownerId);
            if(b.Territory_Code__c != null && b.Year__c != null){
                set_territory.add(b.Territory_Code__c);
                set_years.add(b.Year__c);
                if(!map_ownerId_territory_year_budget.containsKey(b.ownerId)) map_ownerId_territory_year_budget.put(b.ownerId, new map<String, map<String, Budget__c>>());
                if(!map_ownerId_territory_year_budget.get(b.ownerId).containsKey(b.Territory_Code__c)) map_ownerId_territory_year_budget.get(b.ownerId).put(b.Territory_Code__c, new map<String, Budget__c>());
                if(!map_ownerId_territory_year_budget.get(b.ownerId).get(b.Territory_Code__c).containsKey(b.Year__c)){
                    map_ownerId_territory_year_budget.get(b.ownerId).get(b.Territory_Code__c).put(b.Year__c, b);
                }
            }                   
        }
        
        // get parent account ids
        for(Budget_Detail__c bd :[Select Account__c, Budget__c, Budget__r.Year__c from Budget_Detail__c where Budget__c IN :map_bId_budget.keySet()]){
            if(bd.Account__c != null && !map_accId_year_budget.containsKey(bd.Account__c)) {
                set_accIds.add(bd.Account__c);
                if(!map_accId_year_budget.containsKey(bd.Account__c)){
                    map_accId_year_budget.put(bd.Account__c,new map<String, Budget__c>());
                }
                if(!map_accId_year_budget.get(bd.Account__c).containsKey(bd.Budget__r.Year__c)) map_accId_year_budget.get(bd.Account__c).put(bd.Budget__r.Year__c, map_bId_budget.get(bd.Budget__c));           
            }       
        }
        // children account ids
        for(Account acc :[Select id, Plan_Group_Account__c from Account where (RecordType.DeveloperName = 'CIS_Prospect' or RecordType.DeveloperName = 'CIS_Account') and Account_Manager__c IN :set_ownerIds and SALES_TERRITORY_CDE__c IN :set_territory and Plan_Group_Account__c IN :set_accIds]){
            set_accIds.add(acc.id);
            if(map_accId_year_budget.containsKey(acc.Plan_Group_Account__c)) {
                map_accId_year_budget.put(acc.id, new map<String, Budget__c>());
                for(String year :map_accId_year_budget.get(acc.Plan_Group_Account__c).keySet()){
                    map_accId_year_budget.get(acc.id).put(year, map_accId_year_budget.get(acc.Plan_Group_Account__c).get(year));
                }               
            }
        }
        // other account ids
        for(Account acc :[Select id, SALES_TERRITORY_CDE__c, Account_Manager__c from Account where (RecordType.DeveloperName = 'CIS_Prospect' or RecordType.DeveloperName = 'CIS_Account') and Account_Manager__c IN :set_ownerIds and SALES_TERRITORY_CDE__c IN :set_territory and id NOT IN :set_accIds]){
            set_accIds.add(acc.id);
            if(map_ownerId_territory_year_budget.containsKey(acc.Account_Manager__c) && map_ownerId_territory_year_budget.get(acc.Account_Manager__c).containsKey(acc.SALES_TERRITORY_CDE__c)){
                map_accId_year_budget.put(acc.id, new map<String, Budget__c>());
                for(String year :map_ownerId_territory_year_budget.get(acc.Account_Manager__c).get(acc.SALES_TERRITORY_CDE__c).keySet()){
                    map_accId_year_budget.get(acc.id).put(year, map_ownerId_territory_year_budget.get(acc.Account_Manager__c).get(acc.SALES_TERRITORY_CDE__c).get(year));
                }
            }
        }           
        
        // get BBBMonthly records
        if(!map_accId_year_budget.isEmpty()){
            /*
            processUpdateBBBMonthlyVlaues(map_accId_year_budget,set_accIds,set_years);
            */
            ClsBatch_updateBBBMonthlyValues bc = new ClsBatch_updateBBBMonthlyValues(map_accId_year_budget,set_accIds,set_years);
            DataBase.executeBatch(bc);
                
        }           
    }    
    //Start by Bin Yuan due to fix budget Growth bug
    
    public static void calcGrowth(ClsAnnualBudgetPlanStructure.BudgetPlanningItem detail) {
        //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'detail.TotalBudget :: ' + detail.TotalBudget));
        //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'detail.EstimatedFinalCY :: ' + detail.EstimatedFinalCY));
        Decimal growth;
        growth = (detail.EstimatedFinalCY ==0 ? 0 : detail.TotalBudget/detail.EstimatedFinalCY - 1);       
        detail.Growth = (growth*100).setScale(1);
    } 
    //********************************* -=END public methods=- ************************************
       
    //********************************* -=BEGIN private methods=- *********************************
    
    //********************************* -=END private methods=- ***********************************
    //commented by bin Yuan due to improve test coverage
    /*
    private static void processUpdateBBBMonthlyVlaues(map<Id, map<String, Budget__c>> map_accId_year_budget,Set<Id> set_accIds,Set<String> set_years) {
        map<String, Map<String,Decimal>> map_currency_type_Rate = new Map<String, Map<String,Decimal>>();
        map<Id, Budget__c> map_bId_budget = new map<Id, Budget__c>();
        
        String query = 'Select id,Budget__c,Budget_Direct__c,Budget_POS__c,Budget_CMA__c,Budget_Billings_LY__c,Budget_Billings_CYTD__c,Budget_Billing_CYRR__c,'
                         + 'Budget_Direct_Disp__c,Budget_POS_Disp__c,Budget_CMA_Disp__c,Forecast_Disp__c,Budget_Billings_LY_Disp__c,Budget_Billings_CYTD_Disp__c,'
                         + 'Budget_Billing_CYRR_Disp__c,Customer__c,Fiscal_Month__c,CurrencyIsoCode, Original_Budget__c '
                         + 'from BBB_Month_Bill_Book_Cust__c where Fiscal_Year__c IN :set_years and Customer__c IN :set_accIds and Monthly_BBB_External_Key__c = null';
                         
        String countQuery = 'Select Id from BBB_Month_Bill_Book_Cust__c where Fiscal_Year__c IN :set_years and Customer__c IN :set_accIds and Monthly_BBB_External_Key__c = null limit 8001';
        
        list<BBB_Month_Bill_Book_Cust__c> list_bbbMonthlyTemp = new list<BBB_Month_Bill_Book_Cust__c>();
        
        list_bbbMonthlyTemp = Database.query(countQuery);
        
        if(list_bbbMonthlyTemp.size() <= 8000) {
            map_currency_type_Rate = ClsBudgetPlanningUtil.calBudgetRate();
            list<BBB_Month_Bill_Book_Cust__c> list_bbbMonthly = new list<BBB_Month_Bill_Book_Cust__c>();
            
            list_bbbMonthly = Database.query(query);
            
            for(BBB_Month_Bill_Book_Cust__c bbbM: list_bbbMonthly){                         
                Map<String,Decimal> map_type_Rate = new  Map<String,Decimal>();
                if(map_currency_type_Rate.containsKey(bbbM.CurrencyIsoCode)) map_type_Rate = map_currency_type_Rate.get(bbbM.CurrencyIsoCode);
                
                if(bbbM.Budget_Direct_Disp__c == null) bbbM.Budget_Direct_Disp__c = 0;
                if(bbbM.Budget_POS_Disp__c == null) bbbM.Budget_POS_Disp__c = 0;
                if(bbbM.Budget_CMA_Disp__c == null) bbbM.Budget_CMA_Disp__c = 0;
                
                bbbM.Budget_Direct__c = bbbM.Budget_Direct_Disp__c;
                bbbM.Budget_POS__c = bbbM.Budget_POS_Disp__c;
                bbbM.Budget_CMA__c = bbbM.Budget_CMA_Disp__c;
                
                bbbM.Budget_Billings_LY__c = bbbM.Budget_Billings_LY_Disp__c;
                bbbM.Budget_Billings_CYTD__c = bbbM.Budget_Billings_CYTD_Disp__c;
                bbbM.Budget_Billing_CYRR__c = bbbM.Budget_Billing_CYRR_Disp__c;
                
                Decimal total = bbbM.Budget_Direct__c + bbbM.Budget_POS__c + bbbM.Budget_CMA__c;       
                if(bbbM.Original_Budget__c == null || bbbM.Original_Budget__c == 0) {
                    bbbM.Original_Budget__c = bbbM.Budget__c;
                }           
            }
            if(!list_bbbMonthly.isEmpty()) update list_bbbMonthly;          
            
        }
        else {
            ClsBatch_updateBBBMonthlyValues bc = new ClsBatch_updateBBBMonthlyValues(map_accId_year_budget,set_accIds,set_years);
            DataBase.executeBatch(bc);          
        }
    }
    */
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
}