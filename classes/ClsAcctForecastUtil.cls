/**
 *  Controll class for page CtrlAccountForecast
 *
 @author    Bin Yuan
 @created   2013-09-18
 @version   1.0
 @since     27.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-08-10 Bin Yuan <bin.yuan@itbconsult.com>
 * - Modified to remove ind profit center filter for bbb monthly records
 * 2013-09-18 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created
 */

public class ClsAcctForecastUtil {
   
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public static map<String, Decimal> map_isoCode_exchangeRate; 
    public static map<String, Decimal> map_convertionRate = new Map<String, Decimal>();
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
        4 => 'Jan',
        5 => 'Feb',
        6 => 'Mar',
        7 => 'Apr',
        8 => 'May',
        9 => 'Jun',
        10 => 'Jul',
        11 => 'Aug',
        12 => 'Sep',
        1 => 'Oct',
        2 => 'Nov',
        3 => 'Dec'
    };
    public static final Integer QNUMBER = 3;
    public static final Integer FUTUREQNUMBER = 7;
    public static Map<String, Map<String, Map<String, Date>>> map_fiscalYear_fiscalMonth_SEDate;
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private static final Integer DECIMALSCALE = 2;
    private static final String USDCODE = 'USD';
    private static final String OTHER = 'OTHER';
    private static final String STR_NULL = 'NULL';
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
   
    
    //********************************* -=BEGIN public methods=- **********************************
   /**
    * This method is used to set PageConfig Financial month for current month
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void setfinancialMonths(CtrlAccountForecast.PageConfig pageConf) {
        date startDate = date.today();
        date endDate = date.today();
        //pageConf.map_financialMonth = new  Map<String, Set<Integer>>();
        list<String> list_years = new list<String>();
        //set current year & current month
        for (Period period : [select Id, FiscalYearSettings.Name, PeriodLabel from Period where StartDate<=Today and EndDate >=Today and Type = 'Month']) {
            if(period.FiscalYearSettings.Name != null){
                pageConf.currentYear = period.FiscalYearSettings.Name;
            }
            if(period.PeriodLabel != null){
                pageConf.currentMonth = MAP_MONTHLABELNUMBER.get(period.PeriodLabel);
            }
        }
        //Set financial month
        for (Period period : [select StartDate from Period where StartDate <= Today and Type = 'Quarter' order by StartDate desc limit: QNUMBER]) {
            if(period.startDate != null && period.StartDate < startDate){
                startDate = period.StartDate;
            }
        }
        
        for (Period period : [select EndDate from Period where EndDate >= Today and Type = 'Quarter' order by EndDate limit: FUTUREQNUMBER]) {
            if(period.EndDate != null && period.EndDate > endDate){
                endDate = period.EndDate;
            }
        }                
        
        for (Period period : [select Id, FiscalYearSettings.Name, PeriodLabel, StartDate, EndDate from Period where StartDate>= : startDate and EndDate<=: endDate and Type = 'Month' order by StartDate]) {
            if(!pageConf.map_financialMonth.containsKey(period.FiscalYearSettings.Name)) {
                pageConf.map_financialMonth.put(period.FiscalYearSettings.Name, new Set<Integer>());
                
            }
            //set monthly last day
            if(!pageConf.map_year_month_lastDay.containsKey(period.FiscalYearSettings.Name)) {
                pageConf.map_year_month_lastDay.put(period.FiscalYearSettings.Name, new map<Integer, String>());
            }
            pageConf.map_year_month_lastDay.get(period.FiscalYearSettings.Name).put(MAP_MONTHLABELNUMBER.get(period.PeriodLabel), '');
            //end set monthly last day
            pageConf.map_financialMonth.get(period.FiscalYearSettings.Name).add(MAP_MONTHLABELNUMBER.get(period.PeriodLabel));
        }
        
        for(AggregateResult aggr : [select FiscalYearSettings.Name year, PeriodLabel label, EndDate ed, DAY_IN_MONTH(EndDate) lastDay 
                                    from Period 
                                    where StartDate>= : startDate and EndDate<=: endDate and Type = 'Month' 
                                    group by EndDate, FiscalYearSettings.Name, PeriodLabel  
                                    order by EndDate]) {
            
            String aggrYear = (String) aggr.get('year');
            Integer aggrlabel = MAP_MONTHLABELNUMBER.get((String) aggr.get('label'));
            String aggrLastDay = String.valueOf((Integer) aggr.get('lastDay'));
            
            if(pageConf.map_year_month_lastDay.containsKey(aggrYear) && pageConf.map_year_month_lastDay.get(aggrYear).containsKey(aggrlabel)) {
                pageConf.map_year_month_lastDay.get(aggrYear).put(aggrlabel, aggrLastDay);
            }
        }
        // set current month index
        list_years.addAll(pageConf.map_financialMonth.keySet());
        list_years.sort();
        for (String year : list_years) {
            list<Integer> list_months = new list<Integer>();
            list_months.addAll(pageConf.map_financialMonth.get(year));
            list_months.sort();
            
            for (Integer month : list_months) {
                pageConf.list_yearMonth.add(year + ';' + month);
                if(pageConf.currentYear == year && pageConf.currentMonth == month) {
                    //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'pageConf.list_yearMonth.size() :: ' + pageConf.list_yearMonth.size()));
                    pageConf.currentMonthIndex = pageConf.list_yearMonth.size();
                }
            }
        }
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'pageConf :: ' + pageConf));
    }    
    
   /**
    * This method is used to get account bbb monthly data for gaven months and accounts
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void getAcctForecastData(map<String, set<Integer>> map_financialMonth, set<String> set_acctIds, map<String, set<String>> map_parentAcctId_set_childrenAcctIds, map<String, map<String, ClsAccountForecastItem>> map_acctId_map_year_fcItem, map<String, String> map_parentId_acctName, String selectedTerritory) {
        //map<String, map<String, map<Integer, ClsAccountForecastItem>>> map_acctId_map_year_map_month_fcItem = new map<String, map<String, map<Integer, ClsAccountForecastItem>>>();
        map<String, map<String, map<Integer, double>>> map_parentId_map_year_map_month_agreements = new map<String, map<String, map<Integer, decimal>>>();
        String str_select = ' Select sum(Bill_Amount_USD__c) Bills, sum(Book_Amount_USD__c) Book2Bill, sum(Budget__c) Budgets, sum(forecast__c) Forecasts, sum(Previous_Month_Forecast_Document__c) PrevForecasts, sum(Demand_Shipped__c) DemandShipped, sum(Demand_Open__c) DemandOpen, ' 
                          + ' sum(Backlog_0__c) Backlog0, sum(Backlog_1__c) Backlog1, sum(Backlog_2__c) Backlog2, sum(Backlog_3__c) Backlog3, sum(Currency_1_USD__c) Currency1, sum(Forecast_2_Months_Document__c) forecast_2, sum(Forecast_Begin_of_Quarter_Document__c) forecast_3, sum(Forecast_6_Months_Document__c) forecast_6, '
                          + ' sum(Currency_2_USD__c) Currency2, sum(Currency_3_USD__c) Currency3, sum(Currency_4_USD__c) Currency4, Customer__r.Plan_Group_Id__c ParentId, Fiscal_date__c FDate, currencyIsocode'; //, Effective_Working_Days__c effectDays
        String str_from = ' From BBB_Month_Bill_Book_Cust__c ';
        String str_where = ' Where Customer__c IN : set_acctIds and Bill_Type__c = \'Direct\'  ';  // And IND_Profit_Centre_Groups__c != null may need to be changed in the future
        String str_orderBy = ' Group by Customer__r.Plan_Group_Id__c, Fiscal_date__c, currencyIsocode '; //, Effective_Working_Days__c
        String monthFilter = buildMonthFilter(map_financialMonth);
        if(selectedTerritory.trim() != '') {
            str_where += ' And Customer__r.SALES_TERRITORY_CDE__c = \'' + selectedTerritory + '\' ';
        }
        if(monthFilter != '') {
            str_where += ' And ' + monthFilter;
        }
        String query = str_select + str_from + str_where + str_orderBy;
        //get Scheduled Agreements data
        getScheduledAgreements(map_financialMonth, map_parentId_map_year_map_month_agreements, set_acctIds, map_parentAcctId_set_childrenAcctIds);
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'query :: '  + query));
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'set_acctIds :: '  + set_acctIds));
        for(AggregateResult bbb : database.query(query)) {
            String parentId = (bbb.get('ParentId') == null ? null : String.valueOf(bbb.get('ParentId')));
            String parentName = (parentId == null ? OTHER : map_parentId_acctName.get(parentId));
            if(parentId != null && map_parentAcctId_set_childrenAcctIds.containsKey(parentId)) {
                calcFCItems(map_acctId_map_year_fcItem, parentId, parentName, bbb, map_parentId_map_year_map_month_agreements);
            }
            else {
                calcFCItems(map_acctId_map_year_fcItem, OTHER, parentName, bbb, map_parentId_map_year_map_month_agreements);
            }
        }
        getAcctComtIndicator(map_acctId_map_year_fcItem, monthFilter, set_acctIds);
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'map_acctId_map_year_fcItem :: '  + map_acctId_map_year_fcItem.get('001E000000BzVnT')));
    }

   /**
    * This method is used to generate account forecast item map
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void calcFCItems(map<String, map<String, ClsAccountForecastItem>> map_acctId_map_year_fcItem, String parentId, String parentName, AggregateResult bbbM,map<String, map<String, map<Integer, decimal>>> map_parentId_map_year_map_month_agreements) {
        Date fiscalDate = date.valueOf(bbbM.get('FDate'));
        String bbbYear = String.valueOf(fiscalDate.year());
        Integer bbbMonth = fiscalDate.month();
        decimal agreements = 0;
        generateAcctFCItem(map_acctId_map_year_fcItem, parentId, bbbYear, bbbMonth);
        
        ClsAccountForecastItem fcItem = map_acctId_map_year_fcItem.get(parentId).get(bbbYear);
        fcItem.acctName = parentName;
        ClsAccountForecastItem.AccountForecastMonthlyItem fcMonthItem = fcItem.map_acctMonthlyFCItem.get(bbbMonth);
        
        if(map_parentId_map_year_map_month_agreements.containsKey(parentId) && map_parentId_map_year_map_month_agreements.get(parentId).containsKey(bbbYear) && map_parentId_map_year_map_month_agreements.get(parentId).get(bbbYear).containsKey(bbbMonth)) {
            agreements = map_parentId_map_year_map_month_agreements.get(parentId).get(bbbYear).get(bbbMonth);
        }
        //generate fc item form bbb monthly data
        copyBBBM2MonthFCItem(fcMonthItem, bbbM, agreements);
    }
    
   /**
    * This method is used to assign values for account forecast item map
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void copyBBBM2MonthFCItem(ClsAccountForecastItem.AccountForecastMonthlyItem fcMonthItem, AggregateResult bbbM, decimal agreements) {
        //fcItem.
        String fromCurrencyCode = (String) bbbM.get('currencyIsocode');
        
        decimal fc = (bbbM.get('Forecasts') == null ? 0 : (decimal) bbbM.get('Forecasts'));
        decimal prevFc = (bbbM.get('PrevForecasts') == null ? 0 : (decimal) bbbM.get('PrevForecasts'));
        decimal budgetPlanBL = (bbbM.get('Budgets') == null ? 0 : (decimal) bbbM.get('Budgets'));
        decimal bill = (bbbM.get('Bills') == null ? 0 : (decimal) bbbM.get('Bills'));
        decimal bookToBill = (bbbM.get('Book2Bill') == null ? 0 : (decimal) bbbM.get('Book2Bill'));
        decimal orderBacklog = (bbbM.get('Backlog0') == null ? 0 : (decimal) bbbM.get('Backlog0'));
        decimal backlog0 = (bbbM.get('Backlog0') == null ? 0 : (decimal) bbbM.get('Backlog0'));
        decimal backlog1 = (bbbM.get('Backlog1') == null ? 0 : (decimal) bbbM.get('Backlog1'));
        decimal backlog2 = (bbbM.get('Backlog2') == null ? 0 : (decimal) bbbM.get('Backlog2'));
        decimal backlog3 = (bbbM.get('Backlog3') == null ? 0 : (decimal) bbbM.get('Backlog3'));
        decimal currency1 = (bbbM.get('Currency1') == null ? 0 : (decimal) bbbM.get('Currency1'));
        decimal currency2 = (bbbM.get('Currency2') == null ? 0 : (decimal) bbbM.get('Currency2'));
        decimal currency3 = (bbbM.get('Currency3') == null ? 0 : (decimal) bbbM.get('Currency3'));
        decimal currency4 = (bbbM.get('Currency4') == null ? 0 : (decimal) bbbM.get('Currency4'));
        decimal qtAccuracy = (bbbM.get('forecast_3') == null ? 0 : (decimal) bbbM.get('forecast_3'));
        decimal forecast2Month = (bbbM.get('forecast_2') == null ? 0 : (decimal) bbbM.get('forecast_2'));
        decimal forecast6Month = (bbbM.get('forecast_6') == null ? 0 : (decimal) bbbM.get('forecast_6'));
        decimal demandShipped = (bbbM.get('DemandShipped') == null ? 0 : (decimal) bbbM.get('DemandShipped'));
        decimal demandOpen = (bbbM.get('DemandOpen') == null ? 0 : (decimal) bbbM.get('DemandOpen'));
        
        fcMonthItem.fc += fc;
        fcMonthItem.prevMonthFC += prevFc;
        fcMonthItem.budgetPlanBL += budgetPlanBL;
        fcMonthItem.bill += bill;
        fcMonthItem.bookToBill += bookToBill;
        fcMonthItem.orderBacklog += orderBacklog;
        fcMonthItem.backlog0 += backlog0;
        fcMonthItem.backlog1 += backlog1;
        fcMonthItem.backlog2 += backlog2;
        fcMonthItem.backlog3 += backlog3;
        fcMonthItem.currency1 += currency1;
        fcMonthItem.currency2 += currency2;
        fcMonthItem.currency3 += currency3;
        fcMonthItem.currency4 += currency4;
        fcMonthItem.qtAccuracy += qtAccuracy;
        fcMonthItem.forecast2Month += forecast2Month;
        fcMonthItem.forecast6Month += forecast6Month;
        fcMonthItem.demandShipped += demandShipped;
        fcMonthItem.demandOpen += demandOpen;
        if(fcMonthItem.scheAgreements == 0) {
            fcMonthItem.scheAgreements = agreements;
        }
    }
   /**
    * This method is used to set account comment indicator if it has comments
    *
    @author Bin Yuan
    @created 2014-02-28
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-28 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
	public static void getAcctComtIndicator(map<String, map<String, ClsAccountForecastItem>> map_acctId_map_year_fcItem, String monthFilter, set<String> set_acctIds) {
		String query = 'select customer__r.Plan_Group_Id__c ParentId, Fiscal_date__c Fiscal_date From BBB_Month_Bill_Book_Cust__c ' 
					+  ' where Bill_Type__c = \'Direct\' and Is_Comment__c = true '
					+  ' and Customer__c IN : set_acctIds '
					+  ' and Monthly_BBB_External_Key__c = null ';
					
        if(monthFilter != '') {
            query += ' And ' + monthFilter;
        }	
		query +=  'group by customer__r.Plan_Group_Id__c, Fiscal_date__c';
		
		for(AggregateResult result : database.query(query)) {
			String parentId = (result.get('ParentId') == null ? OTHER : String.valueOf(result.get('ParentId')));
			Date fiscalDate = (Date) result.get('Fiscal_date');
			String year = String.valueOf(fiscalDate.year());
			Integer month = Integer.valueOf(fiscalDate.month());
			if(map_acctId_map_year_fcItem.containsKey(parentId) && map_acctId_map_year_fcItem.get(parentId).containsKey(year)) {
				ClsAccountForecastItem item = map_acctId_map_year_fcItem.get(parentId).get(year);
				if(item.map_acctMonthlyFCItem.containsKey(month)) {
					ClsAccountForecastItem.AccountForecastMonthlyItem monthlyItem = item.map_acctMonthlyFCItem.get(month);
					monthlyItem.comtIndicator = true;
				}
			}
		}
	}

   /**
    * This method is used to generate account forecast item map
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void generateAcctFCItem(map<String, map<String, ClsAccountForecastItem>> map_acctId_map_year_fcItem, String parentId, String year, Integer month) {
        if(!map_acctId_map_year_fcItem.containsKey(parentId)) {
            map_acctId_map_year_fcItem.put(parentId, new map<String, ClsAccountForecastItem>{year => new ClsAccountForecastItem(parentId)});
        }
        if(!map_acctId_map_year_fcItem.get(parentId).containsKey(year)) {
            map_acctId_map_year_fcItem.get(parentId).put(year, new ClsAccountForecastItem(parentId));
        }
        ClsAccountForecastItem fcItem = map_acctId_map_year_fcItem.get(parentId).get(year);
        
        if(!fcItem.map_acctMonthlyFCItem.containsKey(month)) {
            fcItem.map_acctMonthlyFCItem.put(month, new ClsAccountForecastItem.AccountForecastMonthlyItem());
        }
    }

   /**
    * This method is used to get Scheduled Agreements data for gaven months and accounts
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void getScheduledAgreements(map<String, set<Integer>> map_financialMonth, map<String, map<String, map<Integer, decimal>>> map_parentId_map_year_map_month_agreements, set<String> set_acctIds, map<String, set<String>> map_parentAcctId_set_childrenAcctIds) {
        String str_select = ' Select sum(Forecast_Amount_USD__c) forecast, Sold_To_Customer__r.Plan_Group_Id__c ParentId, Fiscal_Year__c year, Fiscal_Month_Text__c month ';
        String str_from = ' From Scheduled_Agreements__c ';
        String str_where = ' Where Sold_To_Customer__c IN : set_acctIds and Forecast_Amount_USD__c > 0 ';
        String str_groupBy = ' group by Sold_To_Customer__r.Plan_Group_Id__c, Fiscal_Year__c, Fiscal_Month_Text__c ';
        String monthFilter = buildMonthFilter(map_financialMonth);
        
        if(monthFilter != '') {
            str_where += 'And ' + monthFilter;
        }
        String query = str_select + str_from + str_where + str_groupBy;
        
        for(AggregateResult forecasts : database.query(query)) {
            String parentId = (forecasts.get('parentId') == null ? null : String.valueOf(forecasts.get('parentId')));
            String year = String.valueOf(forecasts.get('year'));
            Integer month = Integer.valueOf(forecasts.get('month'));
            //String customId = String.valueOf(forecasts.get('acctId'));
            double forecast = double.valueOf(forecasts.get('forecast'));
            if(parentId != null && map_parentAcctId_set_childrenAcctIds.containsKey(parentId)) {
                generateAgreementsMap(map_parentId_map_year_map_month_agreements, parentId, year, month, map_parentAcctId_set_childrenAcctIds);
            }
            else {
                generateAgreementsMap(map_parentId_map_year_map_month_agreements, OTHER, year, month, map_parentAcctId_set_childrenAcctIds);
                parentId = OTHER;
            }
            decimal agreement = map_parentId_map_year_map_month_agreements.get(parentId).get(year).get(month);
            agreement += forecast;
            map_parentId_map_year_map_month_agreements.get(parentId).get(year).put(month, agreement);
        }
    }
    
   /**
    * This method is used to generate Scheduled Agreements map
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void generateAgreementsMap(map<String, map<String, map<Integer, decimal>>> map_parentId_map_year_map_month_agreements, String parentId, String year, Integer month, map<String, set<String>> map_parentAcctId_set_childrenAcctIds) {
        if(parentId != null && map_parentAcctId_set_childrenAcctIds.containsKey(parentId)) {
            if(!map_parentId_map_year_map_month_agreements.containsKey(parentId)) {
                map_parentId_map_year_map_month_agreements.put(parentId, new map<String, map<Integer, double>>{year => new map<Integer, decimal>{month => 0}});
            }
            if(!map_parentId_map_year_map_month_agreements.get(parentId).containsKey(year)) {
                map_parentId_map_year_map_month_agreements.get(parentId).put(year, new map<Integer, decimal>{month => 0});
            }
            if(!map_parentId_map_year_map_month_agreements.get(parentId).get(year).containsKey(month)) {
                map_parentId_map_year_map_month_agreements.get(parentId).get(year).put(month, 0);
            }
        }
    }
    
   /**
    * This method is used to get comments for gaven month and gaven account group
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void getComments(set<String> set_acctIds, String year, Integer month, ClsForecastComments forecastComments, String currentYear, Integer currentMoth) {
        set<String> set_acctIdsTemp = new set<String>();
        for(BBB_Month_Bill_Book_Cust__c bbb : [Select Id, Comment__c, Fiscal_Year__c, Fiscal_Month__c, forecast__c, Customer__c, Customer__r.Name, IND_Profit_Centre_Groups__c, Customer__r.Account_Combined_Data__c
                                               From BBB_Month_Bill_Book_Cust__c
                                               Where Customer__c IN : set_acctIds 
                                               and Monthly_BBB_External_Key__c = null
                                               and Is_Comment__c = true
                                               And IND_Profit_Centre_Groups__c != null
                                               and Bill_Type__c = 'Direct' 
                                               and Fiscal_Year__c = : year
                                               and Fiscal_Month__c = : month]) {
            
            if(bbb.Comment__c != null) {
                parseXML(bbb.Comment__c, forecastComments.list_commentItem, bbb.Id, bbb.Customer__c, bbb.Customer__r.Account_Combined_Data__c, bbb.IND_Profit_Centre_Groups__c);
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'bbb.Comment__c:: ' + bbb.Comment__c));
            }
        }

        
        //String lastYear = String.valueOf(Integer.valueOf(year) - 1);
        map<String, decimal> map_parentId_totalBills = new map<String, decimal>();
        String str_select = ' Select sum(Bill_Amount_USD__c) Bills, Customer__r.Plan_Group_Id__c ParentId, Customer__c childId, IND_Profit_Centre_Groups__c profitCtr, currencyIsocode'; //, Effective_Working_Days__c effectDays
        String str_from = ' From BBB_Month_Bill_Book_Cust__c ';
        String str_where = ' Where Customer__c IN : set_acctIds and Bill_Type__c = \'Direct\' and Bill_Amount_USD__c > 0 And IND_Profit_Centre_Groups__c != null ';
        String str_orderBy = ' Group by Customer__r.Plan_Group_Id__c, Customer__c, IND_Profit_Centre_Groups__c, currencyIsocode '; //, Effective_Working_Days__c
        String str_filter = getAcctPercentFiscalDateQuery(currentYear, currentMoth);
        String query = str_select + str_from + str_where + str_filter + str_orderBy;
        
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'set_childAcctIds :: ' + set_childAcctIds ));
        for(AggregateResult bbb : database.query(query)) {
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'bbb :: ' + bbb ));
            String childId = String.valueOf(bbb.get('childId'));
            String profitCtr = String.valueOf((bbb.get('profitCtr') == null ? '' : bbb.get('profitCtr')));
            if(profitCtr != '') {
                if(!forecastComments.map_acctId_set_profitCtrs.containsKey(childId)) {
                    forecastComments.map_acctId_set_profitCtrs.put(childId, new set<String>());
                }
                if(!forecastComments.map_acctId_set_profitCtrs.get(childId).contains(profitCtr)) {
                    forecastComments.map_acctId_set_profitCtrs.get(childId).add(profitCtr);
                }
                set_acctIdsTemp.add(childId);
            }
        }
        //Only load accounts which have history data and profit centre
        if(!set_acctIdsTemp.isEmpty()) {
            for(Account acct : [Select Id, Name, Profit_ctr_code__c, Account_Combined_Data__c From Account Where Id IN : set_acctIdsTemp]) {
                ClsForecastComments.CommentOption childOption = new ClsForecastComments.CommentOption(acct.Id, acct.Account_Combined_Data__c);
                forecastComments.list_childAcctOption.add(childOption);
            }        
        }
    }

   /**
    * This method is used to get comments for gaven month and gaven account group
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void getComments(set<String> set_acctIds, String year, Integer month, ClsForecastComments forecastComments, String currentYear, Integer currentMoth, String territoryCode) {
        set<String> set_acctIdsTemp = new set<String>();
        String bbbQuery = ' Select Id, Comment__c, Fiscal_Year__c, Fiscal_Month__c, forecast__c, Customer__c, Customer__r.Name, IND_Profit_Centre_Groups__c, Customer__r.Account_Combined_Data__c ' 
                       + ' From BBB_Month_Bill_Book_Cust__c '   
                       + ' Where Customer__c IN : set_acctIds  '    
                       + ' and Monthly_BBB_External_Key__c = null ' 
                       + ' and Is_Comment__c = true '   
                       + ' And IND_Profit_Centre_Groups__c != null '    
                       + ' and Bill_Type__c = \'Direct\' '  
                       + ' and Fiscal_Year__c = : year '    
                       + ' and Fiscal_Month__c = : month '  ;
        bbbQuery += ((territoryCode == null || territoryCode == '') ? '' : ' And Customer__r.SALES_TERRITORY_CDE__c = \'' + territoryCode + '\'');
        for(BBB_Month_Bill_Book_Cust__c bbb : database.query(bbbQuery)) {
            
            if(bbb.Comment__c != null) {
                parseXML(bbb.Comment__c, forecastComments.list_commentItem, bbb.Id, bbb.Customer__c, bbb.Customer__r.Account_Combined_Data__c, bbb.IND_Profit_Centre_Groups__c);
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'bbb.Comment__c:: ' + bbb.Comment__c));
            }
        }

        
        //String lastYear = String.valueOf(Integer.valueOf(year) - 1);
        map<String, decimal> map_parentId_totalBills = new map<String, decimal>();
        String str_select = ' Select sum(Bill_Amount_USD__c) Bills, Customer__r.Plan_Group_Id__c ParentId, Customer__c childId, IND_Profit_Centre_Groups__c profitCtr, currencyIsocode'; //, Effective_Working_Days__c effectDays
        String str_from = ' From BBB_Month_Bill_Book_Cust__c ';
        String str_where = ' Where Customer__c IN : set_acctIds and Bill_Type__c = \'Direct\' and Bill_Amount_USD__c > 0 And IND_Profit_Centre_Groups__c != null ';
        str_where += ((territoryCode == null || territoryCode == '') ? '' : ' And Customer__r.SALES_TERRITORY_CDE__c = \'' + territoryCode + '\'');
        
        String str_orderBy = ' Group by Customer__r.Plan_Group_Id__c, Customer__c, IND_Profit_Centre_Groups__c, currencyIsocode '; //, Effective_Working_Days__c
        String str_filter = getAcctPercentFiscalDateQuery(currentYear, currentMoth);
        String query = str_select + str_from + str_where + str_filter + str_orderBy;
        
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'set_acctIds :: ' + set_acctIds ));
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'query :: ' + query ));
        for(AggregateResult bbb : database.query(query)) {
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'bbb :: ' + bbb ));
            String childId = String.valueOf(bbb.get('childId'));
            String profitCtr = String.valueOf((bbb.get('profitCtr') == null ? '' : bbb.get('profitCtr')));
            if(profitCtr != '') {
                if(!forecastComments.map_acctId_set_profitCtrs.containsKey(childId)) {
                    forecastComments.map_acctId_set_profitCtrs.put(childId, new set<String>());
                }
                if(!forecastComments.map_acctId_set_profitCtrs.get(childId).contains(profitCtr)) {
                    forecastComments.map_acctId_set_profitCtrs.get(childId).add(profitCtr);
                }
                set_acctIdsTemp.add(childId);
            }
        }
        //Only load accounts which have history data and profit centre
        if(!set_acctIdsTemp.isEmpty()) {
            for(Account acct : [Select Id, Name, Profit_ctr_code__c, Account_Combined_Data__c From Account Where Id IN : set_acctIdsTemp]) {
                ClsForecastComments.CommentOption childOption = new ClsForecastComments.CommentOption(acct.Id, acct.Account_Combined_Data__c);
                forecastComments.list_childAcctOption.add(childOption);
            }        
        }
    }

   /**
    * This method is used to transform currency for different currency iso code while save forecast for non-USD currency
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static Decimal transformIsoCode(Decimal sourceValue, String fromIsoCode, String toIsoCode){
        Decimal result = 0;
        if(sourceValue != null){
            String k = fromIsoCode + toIsoCode;
            if(map_convertionRate.containsKey(k)){
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'from :: ' + fromIsoCode +' :: ' + sourceValue + ' :: TO :: ' + toIsoCode + ' :: ' + sourceValue * map_convertionRate.get(k)));
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
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'from :: ' + fromIsoCode +' :: ' + sourceValue + ' :: TO :: ' + toIsoCode + ' :: ' + result));
        return result;
    }
    
   /**
    * This method is used to get account hieraychy
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void getAcctHieraychy(map<String, set<String>> map_parentAcctId_set_childrenAcctIds, String managerId, set<String> set_totalAcctIds, map<String, String> map_parentId_acctName) {
        
        map_parentAcctId_set_childrenAcctIds.put(OTHER, new set<String>());
        
        //get valid parent and children accounts
        for(Account acct : [Select Id, Name, Plan_Group_Id__c, Individually_Forecasted__c 
                            FROM Account 
                            WHERE Account_Manager__c =: managerId
                            And (
                                (Plan_Group_Account__c = null And Individually_Forecasted__c = true)
                                or(Plan_Group_Account__r.Plan_Group_Account__c = null and Plan_Group_Account__r.Individually_Forecasted__c = true)
                            )]){
            String pid;
            String acctId = acct.Id;
            pid = acct.Plan_Group_Id__c;
            if(acctId.contains(pid)) {
                map_parentId_acctName.put(pid, acct.Name);
            }
            if(!map_parentAcctId_set_childrenAcctIds.containsKey(pid)) {
                map_parentAcctId_set_childrenAcctIds.put(pid, new set<String>());
            }            
            map_parentAcctId_set_childrenAcctIds.get(pid).add(acct.Id);
            set_totalAcctIds.add(acct.Id);                              
        }
        
        //get other accounts
        for(Account acct : [Select Id, Name, Plan_Group_Id__c, Individually_Forecasted__c 
                            FROM Account 
                            WHERE Account_Manager__c =: managerId
                            And id not in :set_totalAcctIds]) {
            map_parentAcctId_set_childrenAcctIds.get(OTHER).add(acct.Id);
            set_totalAcctIds.add(acct.Id);
        }    
    }
   /**
    * This method is used to get account hieraychy
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void getAcctHieraychy(map<String, set<String>> map_parentAcctId_set_childrenAcctIds, String managerId, set<String> set_totalAcctIds, map<String, String> map_parentId_acctName, String territoryCode) {
        map_parentAcctId_set_childrenAcctIds.put(OTHER, new set<String>());
        String groupAcctQuery = ' Select Id, Name, Plan_Group_Id__c, Individually_Forecasted__c, Account_Combined_Data__c ';
        groupAcctQuery += ' FROM Account ';
        groupAcctQuery += ' WHERE Account_Manager__c =: managerId ';
        groupAcctQuery += ' And ( ';
        groupAcctQuery += '     (Plan_Group_Account__c = null And Individually_Forecasted__c = true) ';
        groupAcctQuery += '     or(Plan_Group_Account__r.Plan_Group_Account__c = null and Plan_Group_Account__r.Individually_Forecasted__c = true) ';
        groupAcctQuery += ' ) ';
        groupAcctQuery += (territoryCode == '' ? ' ' : ' And SALES_TERRITORY_CDE__c = \'' + territoryCode + '\' ');
        
        String otherAcctQuery = ' Select Id, Name, Plan_Group_Id__c, Individually_Forecasted__c, Account_Combined_Data__c ';
        otherAcctQuery += ' FROM Account ';
        otherAcctQuery += ' WHERE Account_Manager__c =: managerId ';
        otherAcctQuery += ' And id not in :set_totalAcctIds ';
        otherAcctQuery += (territoryCode == '' ? ' ' : ' And SALES_TERRITORY_CDE__c = \'' + territoryCode + '\' ');
        
        //get valid parent and children accounts
        //due to group by for bbb monthly query, we need use Plan_Group_Id__c as the parent id
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'groupAcctQuery :: ' + groupAcctQuery ));
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'otherAcctQuery :: ' + otherAcctQuery ));
        for(Account acct : database.query(groupAcctQuery)){
            String pid;
            String acctId = acct.Id;
            pid = ((acct.Plan_Group_Id__c == null || acct.Plan_Group_Id__c == '' ) ? acctId : acct.Plan_Group_Id__c);
            if(acctId.contains(pid)) {
                map_parentId_acctName.put(pid, acct.Account_Combined_Data__c);
            }
            if(!map_parentAcctId_set_childrenAcctIds.containsKey(pid)) {
                map_parentAcctId_set_childrenAcctIds.put(pid, new set<String>());
            }
                        
            map_parentAcctId_set_childrenAcctIds.get(pid).add(acct.Id);
            set_totalAcctIds.add(acct.Id);                              
        }
        
        //get other accounts
        map_parentId_acctName.put(OTHER, OTHER);
        for(Account acct : database.query(otherAcctQuery)) {
            map_parentAcctId_set_childrenAcctIds.get(OTHER).add(acct.Id);
            set_totalAcctIds.add(acct.Id);
        }    
    }

   /**
    * This method is used to get every child account billing percentage for a plan group account
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void getAcctPercentage(set<String> set_childAcctIds, map<String, set<String>> map_parentAcctId_set_childrenAcctIds, map<String, map<String, map<String,decimal>>> map_parentId_map_childId_map_profitCtr_percent, String year, Integer month, String selectedTerritory) {
        String lastYear = String.valueOf(Integer.valueOf(year) - 1);
        map<String, decimal> map_parentId_totalBills = new map<String, decimal>();
        //String str_select = ' Select sum(Bill_Amount_USD__c) Bills, Customer__r.Plan_Group_Id__c ParentId, Customer__c childId, IND_Profit_Centre_Groups__c profitCtr, currencyIsocode'; //, Effective_Working_Days__c effectDays
        String str_select = ' Select sum(Bill_Amount_USD__c) Bills, Customer__r.Plan_Group_Id__c ParentId, Customer__c childId, SAP_Profit_Center_Code__c profitCtr, currencyIsocode'; //, Effective_Working_Days__c effectDays
        String str_from = ' From BBB_Month_Bill_Book_Cust__c ';
        
        //String str_where = ' Where Customer__c IN : set_childAcctIds and Bill_Type__c = \'Direct\' and Bill_Amount_USD__c > 0 And IND_Profit_Centre_Groups__c != null ';
        String str_where = ' Where Customer__c IN : set_childAcctIds and Bill_Type__c = \'Direct\' and Bill_Amount_USD__c > 0 And IND_Profit_Centre_Groups__c != null ';// ';
        str_where += (selectedTerritory == '' ? ' ' : ' And Customer__r.SALES_TERRITORY_CDE__c = \'' + selectedTerritory + '\' ');
        
        //String str_orderBy = ' Group by Customer__r.Plan_Group_Id__c, Customer__c, IND_Profit_Centre_Groups__c, currencyIsocode '; //, Effective_Working_Days__c
        String str_orderBy = ' Group by Customer__r.Plan_Group_Id__c, Customer__c, SAP_Profit_Center_Code__c, currencyIsocode '; //, Effective_Working_Days__c
        String str_filter = getAcctPercentFiscalDateQuery(year, month);
        String query = str_select + str_from + str_where + str_filter + str_orderBy;
        
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'query :: ' + query ));
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'set_childAcctIds :: ' + set_childAcctIds ));
        for(AggregateResult bbb : database.query(query)) {
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'bbb :: ' + bbb ));
            String parentId = (bbb.get('ParentId') == null ? null : String.valueOf(bbb.get('ParentId')));
            String childId = String.valueOf(bbb.get('childId'));
            if(parentId != null && map_parentAcctId_set_childrenAcctIds.containsKey(parentId)) {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'parentId :: ' + parentId ));
                copyAcctBillPercentage(parentId, childId, bbb, map_parentId_map_childId_map_profitCtr_percent, map_parentId_totalBills);
            }
            else {
                copyAcctBillPercentage(OTHER, childId, bbb, map_parentId_map_childId_map_profitCtr_percent, map_parentId_totalBills);
            }
        }
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'map_parentId_totalBills :: ' + map_parentId_totalBills ));
        calcAcctBillPercentage(map_parentId_map_childId_map_profitCtr_percent, map_parentId_totalBills);
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'map_parentId_map_childId_map_profitCtr_percent :: ' + map_parentId_map_childId_map_profitCtr_percent ));
    }

   /**
    * This method is used to save account forecast
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void saveAcctForecast(list<ClsAccountForecastItem.AcctForecastSaveItem> list_fcSaveItems, set<String> set_totalAcctIds, map<String, map<String, map<String,decimal>>> map_parentId_map_childId_map_profitCtr_percent, CtrlAccountForecast.PageConfig pageConf, map<String, set<Integer>> map_fiscalMonth4Save) {

        String currentYear = pageConf.currentYear;
        Integer currentMonth = pageConf.currentMonth;
        set<String> set_updatedBBBMIds = new set<String>();
        map<String, BBB_Month_Bill_Book_Cust__c> map_bbbMId_bbbM = new map<String, BBB_Month_Bill_Book_Cust__c>();
        list<BBB_Month_Bill_Book_Cust__c> list_bbbM2Delete = new list<BBB_Month_Bill_Book_Cust__c>();
        
        //set<String> set_childIds = new set<String>();
        
        //map<String, BBB_Month_Bill_Book_Cust__c> map_acctId_bbbM = new map<String, BBB_Month_Bill_Book_Cust__c>();
        
        map<String, map<String, BBB_Month_Bill_Book_Cust__c>> map_acctId_map_profitCtr_bbbM = new map<String, map<String, BBB_Month_Bill_Book_Cust__c>>();
        map<String, map<String, map<Integer, map<String, BBB_Month_Bill_Book_Cust__c>>>> map_acctId_year_month_profitCtr_bbbM = new map<String, map<String, map<Integer, map<String, BBB_Month_Bill_Book_Cust__c>>>>();
        map<String, String> map_acctId_currencyCode = new map<String, String>();
        list<BBB_Month_Bill_Book_Cust__c> list_bbbM2Upsert = new list<BBB_Month_Bill_Book_Cust__c>();
        map<String, String> map_acctId_keyId = new map<String, String>();
        decimal forecast = 0;
        if(map_parentId_map_childId_map_profitCtr_percent.isEmpty()) {
            return;
        }
        //set_childIds = map_parentId_map_childId_map_profitCtr_percent.get(parentId).keySet();
        for(Account acct : [Select Id, CurrencyIsoCode, TE_Customer_Key_Id__c From Account Where Id IN : set_totalAcctIds]) {
            map_acctId_currencyCode.put(acct.Id, acct.CurrencyIsoCode);
            map_acctId_keyId.put(acct.Id, String.valueOf(Integer.valueOf(acct.TE_Customer_Key_Id__c)));
        }
        //String query = 'Select Id, Fiscal_Month__c, Fiscal_Year__c, forecast__c, Customer__c, Customer__r.CurrencyIsoCode, IND_Profit_Centre_Groups__c '
        String query = 'Select Id, Fiscal_Month__c, Fiscal_Year__c, forecast__c, Customer__c, Customer__r.CurrencyIsoCode, SAP_Profit_Center_Code__c '
                     + 'From BBB_Month_Bill_Book_Cust__c '
                     //+ 'Where Customer__c IN : set_totalAcctIds And IND_Profit_Centre_Groups__c != null '
                     + 'Where Customer__c IN : set_totalAcctIds  '  //And SAP_Profit_Center_Code__c != null
                     + 'And Bill_Type__c = \'Direct\' '
                     + 'And Is_Comment__c != true '
                     //Added to fix delete budget planning records bug
                     + 'And Monthly_BBB_External_Key__c != null ';
                     //End
        query += (pageConf.selectTerritory == '' ? ' ' : ' And Customer__r.SALES_TERRITORY_CDE__c = \'' + pageConf.selectTerritory + '\' ');
        String monthFilter = buildMonthFilter(map_fiscalMonth4Save);
        query = query + ' And ' + monthFilter;
        for(BBB_Month_Bill_Book_Cust__c bbbM : database.query(query)) {
            //STR_NULL
            //String str_profitCtr = ((bbbM.IND_Profit_Centre_Groups__c == null || bbbM.IND_Profit_Centre_Groups__c == '') ? STR_NULL : bbbM.IND_Profit_Centre_Groups__c);
            String str_profitCtr = ((bbbM.SAP_Profit_Center_Code__c == null || bbbM.SAP_Profit_Center_Code__c == '') ? STR_NULL : bbbM.SAP_Profit_Center_Code__c);
            //if(str_profitCtr != STR_NULL) {
                Integer bbbmMonth = Integer.valueOf(bbbM.Fiscal_Month__c);
                if(!map_acctId_year_month_profitCtr_bbbM.containsKey(bbbM.Customer__c)) {
                    map_acctId_year_month_profitCtr_bbbM.put(bbbM.Customer__c, new map<String, map<Integer, map<String, BBB_Month_Bill_Book_Cust__c>>>());
                }
                if(!map_acctId_year_month_profitCtr_bbbM.get(bbbM.Customer__c).containsKey(bbbM.Fiscal_Year__c)) {
                    map_acctId_year_month_profitCtr_bbbM.get(bbbM.Customer__c).put(bbbM.Fiscal_Year__c, new map<Integer, map<String, BBB_Month_Bill_Book_Cust__c>>());
                }
                if(!map_acctId_year_month_profitCtr_bbbM.get(bbbM.Customer__c).get(bbbM.Fiscal_Year__c).containsKey(bbbmMonth)) {
                    map_acctId_year_month_profitCtr_bbbM.get(bbbM.Customer__c).get(bbbM.Fiscal_Year__c).put(bbbmMonth, new map<String, BBB_Month_Bill_Book_Cust__c>());
                }
                if(!map_acctId_year_month_profitCtr_bbbM.get(bbbM.Customer__c).get(bbbM.Fiscal_Year__c).get(bbbmMonth).containsKey(str_profitCtr)) {
                    map_acctId_year_month_profitCtr_bbbM.get(bbbM.Customer__c).get(bbbM.Fiscal_Year__c).get(bbbmMonth).put(str_profitCtr, bbbM);
                }
           // }
            map_bbbMId_bbbM.put(bbbM.Id, bbbM);
        }
        for(ClsAccountForecastItem.AcctForecastSaveItem item : list_fcSaveItems) {
        	//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'item :: ' + item));
            String parentId = item.parentAcctId;
            String year = item.year;
            Integer month = item.month;
            String monthLabel = MAP_NUMBERMONTHLABEL.get(month).toUpperCase();
            
            String monthLastDay = ((pageConf.map_year_month_lastDay.containsKey(year) && pageConf.map_year_month_lastDay.get(year).containsKey(month)) ? pageConf.map_year_month_lastDay.get(year).get(month) : String.valueOf(date.daysInMonth(Integer.valueOf(year), month)));
            decimal forecastForTopAcct = item.totalForecast;
            set<String> set_childAcctIds;
            if(map_parentId_map_childId_map_profitCtr_percent.containsKey(parentId)) {
            	set_childAcctIds = map_parentId_map_childId_map_profitCtr_percent.get(parentId).keySet();
            }
            if(set_childAcctIds != null) {
                for(String acctId : set_childAcctIds) {
                    if(map_parentId_map_childId_map_profitCtr_percent.containsKey(parentId) && map_parentId_map_childId_map_profitCtr_percent.get(parentId).containsKey(acctId)) {
                        for(String profitCtr : map_parentId_map_childId_map_profitCtr_percent.get(parentId).get(acctId).keySet()) {
                            //if(profitCtr != STR_NULL && year != null && month != null) {
                            if(year != null && month != null) {           
                                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'Par Id :: ' + parentId + ' profitCtr :: ' + profitCtr + ' share:: ' + map_parentId_map_childId_map_profitCtr_percent.get(parentId).get(acctId).get(profitCtr) + ' forecastForTopAcct:: ' + forecastForTopAcct));
                                decimal currencyConvert = 1;
                                decimal forecast4USD = 0;
                                decimal prevFCRate = 1;
                                BBB_Month_Bill_Book_Cust__c bbbM;
                                if(USDCODE != map_acctId_currencyCode.get(acctId)) {
                                    currencyConvert = transformIsoCode(1, USDCODE, map_acctId_currencyCode.get(acctId));
                                }
                                forecast4USD = map_parentId_map_childId_map_profitCtr_percent.get(parentId).get(acctId).get(profitCtr) * forecastForTopAcct;
                                forecast = forecast4USD * currencyConvert;

                                prevFCRate = (forecast == 0 ? 1 : (forecast4USD / forecast));
                                if(map_acctId_year_month_profitCtr_bbbM.containsKey(acctId) 
                                    && map_acctId_year_month_profitCtr_bbbM.get(acctId).containsKey(year) 
                                    && map_acctId_year_month_profitCtr_bbbM.get(acctId).get(year).containskey(month)
                                    && map_acctId_year_month_profitCtr_bbbM.get(acctId).get(year).get(month).containsKey(profitCtr)) {
                                    bbbM = map_acctId_year_month_profitCtr_bbbM.get(acctId).get(year).get(month).get(profitCtr);
                                    set_updatedBBBMIds.add(bbbM.Id);
                                }
                                else {
                                    bbbM = new BBB_Month_Bill_Book_Cust__c();
                                    bbbM.Customer__c = acctId;
                                    bbbM.Fiscal_Year__c = year;
                                    bbbM.Fiscal_Month__c = month;
                                    //bbbM.IND_Profit_Centre_Groups__c = (profitCtr == STR_NULL ? null : profitCtr);
                                    //external id format = Customer Key Id + "Direct" + SAP Profit Center Code + Sales Period Date + ISO Currency Code
                                    //bbbM.Monthly_BBB_External_Key__c = map_acctId_keyId.get(acctId) + 'Direct' + (profitCtr == STR_NULL ? '' : profitCtr) + '-' + monthLabel + '-' + 'monthLastDay' + map_acctId_currencyCode.get(acctId);
                                    bbbM.SAP_Profit_Center_Code__c = (profitCtr == STR_NULL ? null : profitCtr);
                                    bbbM.Bill_Type__c = 'Direct';
                                    bbbM.CurrencyIsoCode = map_acctId_currencyCode.get(acctId);
                                }
                                bbbM.forecast__c = forecast;
                                bbbM.Previous_Exchange_Rate__c = prevFCRate;
                                //bbbM.IND_Profit_Centre_Groups__c = (profitCtr == STR_NULL ? null : profitCtr);
                                bbbM.SAP_Profit_Center_Code__c = (profitCtr == STR_NULL ? null : profitCtr);
                                bbbM.Sales_period__c = getSalesPeriodDate(bbbM.Fiscal_Year__c, Integer.valueOf(bbbM.Fiscal_Month__c));
                                bbbM.Monthly_BBB_External_Key__c = map_acctId_keyId.get(acctId) + 'Direct' + (profitCtr == STR_NULL ? '' : profitCtr) + monthLastDay + '-' + monthLabel + '-' + String.valueOf(bbbM.Sales_period__c.year()).substring(2) + map_acctId_currencyCode.get(acctId);
                                //Process Sales_period__c
                                
                                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'bbbM.Monthly_BBB_External_Key__c :: ' + bbbM.Monthly_BBB_External_Key__c));
                                list_bbbM2Upsert.add(bbbM);
                            }
                        }
                    }
                }
            }
        }
        for(String bbbMId : map_bbbMId_bbbM.keySet()) {
            if(!set_updatedBBBMIds.contains(bbbMId)) {
                list_bbbM2Delete.add(map_bbbMId_bbbM.get(bbbMId));
            }
        }
        if(!list_bbbM2Upsert.isEmpty()) {
            upsert list_bbbM2Upsert;
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'list_bbbM2Upsert :: ' + list_bbbM2Upsert.size()));
        }
        if(!list_bbbM2Delete.isEmpty()) {
            delete list_bbbM2Delete;
            
        }
    }
    
   /**
    * This method is used to save account forecast commnets
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void saveComments(map<String, map<String, map<Integer, map<String, String>>>> map_acctId_year_month_profitCtr_comt, map<String, set<Integer>> map_fiscalMonth4Save) {
        set<String> set_tempAcctIds = map_acctId_year_month_profitCtr_comt.keySet();
        map<String, map<String, map<Integer, map<String, BBB_Month_Bill_Book_Cust__c>>>> map_existingComts = new map<String, map<String, map<Integer, map<String, BBB_Month_Bill_Book_Cust__c>>>>();
        list<BBB_Month_Bill_Book_Cust__c> list_bbbM2Upsert = new list<BBB_Month_Bill_Book_Cust__c>();
        list<BBB_Month_Bill_Book_Cust__c> list_bbbM2Delete = new list<BBB_Month_Bill_Book_Cust__c>();
        String query = 'Select Id, Fiscal_Month__c, Fiscal_Year__c, forecast__c, Customer__c, Customer__r.CurrencyIsoCode, IND_Profit_Centre_Groups__c, Comment__c '
                     + 'From BBB_Month_Bill_Book_Cust__c '
                     + 'Where Customer__c IN : set_tempAcctIds '
                     + 'And Bill_Type__c = \'Direct\' And IND_Profit_Centre_Groups__c != null and Monthly_BBB_External_Key__c = null and Is_Comment__c = true';
        String monthFilter = buildMonthFilter(map_fiscalMonth4Save);
        query = query + ' And ' + monthFilter;
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'map_fiscalMonth4Save :: ' + map_fiscalMonth4Save));
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'query :: ' + query));
        for(BBB_Month_Bill_Book_Cust__c bbbM : database.query(query)) {
            String profitCtr = (bbbM.IND_Profit_Centre_Groups__c == null ? STR_NULL : bbbM.IND_Profit_Centre_Groups__c);
            if(profitCtr != STR_NULL) {
                Integer month = Integer.valueOf(bbbM.Fiscal_Month__c);
                
                if(!map_existingComts.containsKey(bbbM.Customer__c)) {
                    map_existingComts.put(bbbM.Customer__c, new map<String, map<Integer, map<String, BBB_Month_Bill_Book_Cust__c>>>());
                }
                if(!map_existingComts.get(bbbM.Customer__c).containsKey(bbbM.Fiscal_Year__c)) {
                    map_existingComts.get(bbbM.Customer__c).put(bbbM.Fiscal_Year__c, new map<Integer, map<String, BBB_Month_Bill_Book_Cust__c>>());
                }
                if(!map_existingComts.get(bbbM.Customer__c).get(bbbM.Fiscal_Year__c).containsKey(month)) {
                    map_existingComts.get(bbbM.Customer__c).get(bbbM.Fiscal_Year__c).put(month, new map<String, BBB_Month_Bill_Book_Cust__c>());
                }
                if(!map_existingComts.get(bbbM.Customer__c).get(bbbM.Fiscal_Year__c).get(month).containsKey(profitCtr)) {
                    map_existingComts.get(bbbM.Customer__c).get(bbbM.Fiscal_Year__c).get(month).put(profitCtr, bbbM);
                }   
                bbbM.Comment__c = '';
                list_bbbM2Upsert.add(bbbM);
            }
        }
        
        for(String acctId : map_acctId_year_month_profitCtr_comt.keySet()) {
            if(!map_existingComts.containsKey(acctId)) {
                for(String year : map_acctId_year_month_profitCtr_comt.get(acctId).keySet()) {
                    for(Integer fMonth : map_acctId_year_month_profitCtr_comt.get(acctId).get(year).keySet()) {
                        for(String pf : map_acctId_year_month_profitCtr_comt.get(acctId).get(year).get(fMonth).keySet()) {
                            String comment = map_acctId_year_month_profitCtr_comt.get(acctId).get(year).get(fMonth).get(pf);
                            generateBBBMForComment(acctId, year, fMonth, pf, comment, list_bbbM2Upsert);
                        }   
                    }
                }
            }
            else {
                for(String year : map_acctId_year_month_profitCtr_comt.get(acctId).keySet()) {
                    if(!map_existingComts.get(acctId).containsKey(year)) {
                        for(Integer fMonth : map_acctId_year_month_profitCtr_comt.get(acctId).get(year).keySet()) {
                            for(String pf : map_acctId_year_month_profitCtr_comt.get(acctId).get(year).get(fMonth).keySet()) {
                                String comment = map_acctId_year_month_profitCtr_comt.get(acctId).get(year).get(fMonth).get(pf);
                                generateBBBMForComment(acctId, year, fMonth, pf, comment, list_bbbM2Upsert);
                            }   
                        }
                    }
                    else {
                        for(Integer fMonth : map_acctId_year_month_profitCtr_comt.get(acctId).get(year).keySet()) {
                            if(!map_existingComts.get(acctId).get(year).containsKey(fMonth)) {
                                for(String pf : map_acctId_year_month_profitCtr_comt.get(acctId).get(year).get(fMonth).keySet()) {
                                    String comment = map_acctId_year_month_profitCtr_comt.get(acctId).get(year).get(fMonth).get(pf);
                                    generateBBBMForComment(acctId, year, fMonth, pf, comment, list_bbbM2Upsert);
                                }
                            }
                            else {
                                for(String pf : map_acctId_year_month_profitCtr_comt.get(acctId).get(year).get(fMonth).keySet()) {
                                    
                                    if(!map_existingComts.get(acctId).get(year).get(fMonth).containsKey(pf)) {
                                        String comment = map_acctId_year_month_profitCtr_comt.get(acctId).get(year).get(fMonth).get(pf);
                                        generateBBBMForComment(acctId, year, fMonth, pf, comment, list_bbbM2Upsert);
                                    }
                                    else {
                                        BBB_Month_Bill_Book_Cust__c bbbM = map_existingComts.get(acctId).get(year).get(fMonth).get(pf);
                                        String comment = map_acctId_year_month_profitCtr_comt.get(acctId).get(year).get(fMonth).get(pf);
                                        bbbM.Comment__c = comment;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        for(Integer i = 0; i < list_bbbM2Upsert.size(); i++) {
        	BBB_Month_Bill_Book_Cust__c bbbM = list_bbbM2Upsert[i];
        	String comt = bbbM.Comment__c;
        	if(comt == null || comt.trim() == '') {
        		list_bbbM2Delete.add(bbbM);
        		list_bbbM2Upsert.remove(i);
        	}

        }
        if(!list_bbbM2Upsert.isEmpty()) {
            upsert list_bbbM2Upsert;
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'list_bbbM2Upsert :: ' + list_bbbM2Upsert));
        }
        if(!list_bbbM2Delete.isEmpty()) {
            delete list_bbbM2Delete;
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'list_bbbM2Upsert :: ' + list_bbbM2Upsert));
        }
        removeDutyComts(map_fiscalMonth4Save);
    }
   /**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void removeDutyComts(map<String, set<Integer>> map_fiscalMonth4Save) {
    	String query = 'Select Id, Fiscal_Month__c, Fiscal_Year__c, forecast__c, Customer__c, Comment__c '
                     + 'From BBB_Month_Bill_Book_Cust__c '
                     + ' Where Customer__c IN (Select Id FROM Account '
                     + '       WHERE Account_Manager__c = \'' + UserInfo.getUserId() + '\') '
                     + 'And Bill_Type__c = \'Direct\' and Monthly_BBB_External_Key__c = null and Is_Comment__c = true';
        String monthFilter = buildMonthFilter(map_fiscalMonth4Save);
        query = query + ' And ' + monthFilter;
        list<BBB_Month_Bill_Book_Cust__c> list_comt2Delete = new list<BBB_Month_Bill_Book_Cust__c>();
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'map_fiscalMonth4Save :: ' + map_fiscalMonth4Save));
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'query :: ' + query));
        for(BBB_Month_Bill_Book_Cust__c bbbM : database.query(query)) {
        	String comt = bbbM.Comment__c;
        	if(comt == null || comt.trim() == '') {
        		list_comt2Delete.add(bbbM);
        	}
        }
        if(!list_comt2Delete.isEmpty()) {
        	delete list_comt2Delete;
        }
    }
        
   /**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static string buildMonthFilter(map<String, Set<Integer>> map_financialMonth) {
        string monthFilter = '';
        if(map_financialMonth != null && map_financialMonth.size() > 0) {
            monthFilter += '(';
            for (string year : map_financialMonth.keySet()) {
                if(year != 'null') {
                    monthFilter += '(Fiscal_Year__c = \'' + year +'\'';
                    if(map_financialMonth.get(year) != null && map_financialMonth.get(year).size() > 0) {
                        monthFilter += ' AND Fiscal_Month__c IN (';
                        for(Integer month : map_financialMonth.get(year)) {
                            monthFilter += month + ', ';
                        }
                        monthFilter = monthFilter.substring(0, monthFilter.lastIndexOf(',')) + ')';
                    }
                    monthFilter += ') OR ';
                }
            }
            monthFilter = monthFilter.substring(0, monthFilter.lastIndexOf(' OR')) + ')';
        }
        return monthFilter;
    }

   /**
    * This method is used generate account forecast item map for all month
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void checkFCMap4Year(map<String, map<String, ClsAccountForecastItem>> map_acctId_map_year_fcItem, map<String, Set<Integer>> map_financialMonth, map<String, set<String>> map_parentAcctId_set_childrenAcctIds, map<String, String> map_parentId_acctName) {
        //for(String id : map_acctId_map_year_fcItem.keySet()) {
        for(String id : map_parentAcctId_set_childrenAcctIds.keySet()) {
        	if(!map_acctId_map_year_fcItem.containsKey(id)) {
        		map_acctId_map_year_fcItem.put(id, new map<String, ClsAccountForecastItem>());
        	}
            for(String year : map_financialMonth.keySet()) {
            
                if(!map_acctId_map_year_fcItem.get(id).containsKey(year)) {
                	ClsAccountForecastItem fcItem = new ClsAccountForecastItem(id);
                	fcItem.acctName = map_parentId_acctName.get(id);
                    map_acctId_map_year_fcItem.get(id).put(year, fcItem);
                }
            }
        }
    }
    
   /**
    * This method is used to parse xml string
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void parseXML(String comments, list<ClsForecastComments.ForecastCommentItem> list_comtItem, String fcId, String acctId, String acctName, String profitCtr) {
        DOM.Document doc = new DOM.Document();      
        doc.load(comments);    
        DOM.XMLNode topNode = doc.getRootElement();
        if(topNode.getName() == 'comments') {
            for(DOM.XMLNode node : topNode.getChildElements()) {
                if(node.getName() == 'comment' && node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
                    ClsForecastComments.ForecastCommentItem item = new ClsForecastComments.ForecastCommentItem();
                    item.fcId = fcId;
                    item.acctId = acctId;
                    item.acctName = acctName;
                    item.profitCenter = profitCtr;
                    item.comment = node.getText();
                    item.value = '';
                    if (node.getAttributeCount() > 0) { 
                        for (Integer i = 0; i< node.getAttributeCount(); i++ ) {
                            item.value += node.getAttributeValue(node.getAttributeKeyAt(i), node.getAttributeKeyNsAt(i));
                        }  
                    }
                    
                    list_comtItem.add(item);
                }
            }
        }
    }
    
   /**
    * This method is used to generate effective working days map
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void getEffectiveWorkingDays(map<String, set<Integer>> map_financialMonth, map<String, map<Integer, Integer>> map_year_map_month_effWorkingDays) {
        String baseQuery = 'select Id, Days__c, Fiscal_Date__c, Fiscal_Year__c, Fiscal_Month__c from Effective_Working_Days__c ';
        String monthFilter = buildMonthFilter(map_financialMonth);
        String query = baseQuery + ' Where ' + monthFilter;
        for(Effective_Working_Days__c eff : database.query(query)) {
            Integer month = Integer.valueOf(eff.Fiscal_Month__c);
            if(!map_year_map_month_effWorkingDays.containsKey(eff.Fiscal_Year__c)) {
                map_year_map_month_effWorkingDays.put(eff.Fiscal_Year__c, new map<Integer, Integer>());
            }
            if(!map_year_map_month_effWorkingDays.get(eff.Fiscal_Year__c).containsKey(month)) {
                map_year_map_month_effWorkingDays.get(eff.Fiscal_Year__c).put(month, Integer.valueOf(eff.Days__c));
            }
        }
    }
    
   /**
    * This method is used to check if current date is frozen for forecast planning
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static boolean isDateFrozen(CtrlAccountForecast.PageConfig pageConf) {
        boolean isFrozen = false;
        Date frozenDate ;
        String year = pageConf.currentYear;
        Integer month = pageConf.currentMonth;
        Date startDate = Date.newInstance(Integer.valueOf(year), month, 15);
        String str_select = ' Select max(Last_Frozen_Month_Date__c) frozenDate'; //, Effective_Working_Days__c effectDays
        String str_from = ' From BBB_Month_Bill_Book_Cust__c ';
        String str_where = ' Where Fiscal_Date__c >=: startDate and Bill_Type__c = \'Direct\' and Last_Frozen_Month_Date__c != null ';
        String query = str_select + str_from + str_where;
        
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'year :: ' + year ));
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'month :: ' + month ));
        for(AggregateResult bbb : database.query(query)) {
            frozenDate = (Date) bbb.get('frozenDate');
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'bbb :: ' + bbb ));
        }
        if(frozenDate != null && frozenDate >= date.today()) {
            isFrozen = true;
        }
        return isFrozen;
    }

   /**
    * This method is used to get active account territory for current user
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void getAccountTerritory(String userId, list<String> list_territoryCodes) {
        for(AggregateResult acct : [Select SALES_TERRITORY_CDE__c territoryCode 
                                    From Account 
                                    Where Account_Manager__c = : userId and SALES_TERRITORY_CDE__c != null group by SALES_TERRITORY_CDE__c order by SALES_TERRITORY_CDE__c]) {
            String territoryCode = (String) acct.get('territoryCode');
            //system.debug(acct);
            if(territoryCode != '') {
                list_territoryCodes.add(territoryCode);
            }                           
        }
    }

   /**
    * This method is used to get color config for am page
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void getAMColorConfigFromSetting(list<CtrlAccountForecast.ColorConfig> list_colorConf, CtrlAccountForecast.PageConfig pageConf) {
        for(Finanical_Forecast_Color_Config__c conf : Finanical_Forecast_Color_Config__c.getAll().values()) {
            if(conf.IsActive__c != null && conf.Name != null && conf.IsActive__c == true && conf.Name.startsWith('AM')) {
            	
                CtrlAccountForecast.ColorConfig cc = new CtrlAccountForecast.ColorConfig();
                cc.colorName = conf.Name;
                cc.color = conf.Color__c;
                double maxValue;
                double minValue;
                
            	if(conf.Max_Value__c != null && String.valueOf(conf.Max_Value__c).trim() != '') {
            		try {
            			maxValue = double.valueOf(conf.Max_Value__c);
            		}
            		catch(Exception ex) {
            			maxValue = null;
            		}
            	}
            	else {
            		maxValue = null;
            	}
            	
            	if(conf.Min_Value__c != null && String.valueOf(conf.Min_Value__c).trim() != '') {
            		try {
            			minValue = double.valueOf(conf.Min_Value__c);
            		}
            		catch(Exception ex) {
            			minValue = null;
            		}
            	}
            	else {
            		minValue = null;
            	}
            	
                cc.maxValue = maxValue;
                cc.minValue = minValue;
                list_colorConf.add(cc);
                
                if(cc.colorName.contains('AM Red')) {
                	pageConf.amRed = conf.Color__c;
                }
                if(cc.colorName.contains('AM Green')) {
                	pageConf.amGreen = conf.Color__c;
                }
            }
        }
        pageConf.colorJson = json.serialize(list_colorConf);
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'pageConf.colorJson :: ' + pageConf.colorJson ));
    }
    
    /**
    * The method is used to get sales period date
    *
    @author Bin Yuan
    @created 2014-03-10
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    @param             
    *
    @return     sales period date
    *
    @changelog
    * 2014-03-10 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static Date getSalesPeriodDate(String fiscalYear, Integer fiscalMonth){
    	String monthLabel = '';
    	Date salesPeriodDate;
    	Date endDate;
    	if(map_fiscalYear_fiscalMonth_SEDate == null){
	    	getAllFiscalMonthDateRange();	
    	}
    	if(MAP_NUMBERMONTHLABEL.containsKey(fiscalMonth)) {
    		monthLabel = MAP_NUMBERMONTHLABEL.get(fiscalMonth);
    	}
    	if(map_fiscalYear_fiscalMonth_SEDate.containsKey(fiscalYear) && map_fiscalYear_fiscalMonth_SEDate.get(fiscalYear).containsKey(monthLabel)){
    		endDate = map_fiscalYear_fiscalMonth_SEDate.get(fiscalYear).get(monthLabel).get('End');
    	}
    	if(endDate != null){
    		/*
    		Date tmpDate = Date.newinstance(endDate.year(), endDate.month(), 15);
    		if(endDate >= tmpDate) salesPeriodDate = tmpDate;
    		else salesPeriodDate = tmpDate.addMonths(-1);
    		*/
    		
    	}
    	return endDate;
    }
    
    /**
    * The method is used to get fiscal month setting for all date range
    *
    @author Bin Yuan
    @created 2014-03-10
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    @param             
    *
    @return     sales period date
    *
    @changelog
    * 2014-03-10 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
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
    //********************************* -=END public methods=- ************************************
    
    //********************************* -=BEGIN private methods=- *********************************
   /**
    * This method is used to get generate forecast comments for save
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    private static void generateBBBMForComment(String acctId, String year, Integer month, String profitCtr, String comment, list<BBB_Month_Bill_Book_Cust__c> list_bbbM2Upsert) {
    	if(comment.trim() == '') {
    		return;
    	}
        BBB_Month_Bill_Book_Cust__c bbbM = new BBB_Month_Bill_Book_Cust__c();
        bbbM.Customer__c = acctId;
        bbbM.Fiscal_Year__c = year;
        bbbM.Fiscal_Month__c = month;
        bbbM.Comment__c = comment;
        bbbM.IND_Profit_Centre_Groups__c = profitCtr;
        bbbM.Bill_Type__c = 'Direct';
        bbbM.Is_Comment__c = true;
        list_bbbM2Upsert.add(bbbM);
    }
    
   /**
    * This method is used to generate account percentage query
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    private static String getAcctPercentFiscalDateQuery(String year, Integer month) {
        String query = ' And ( TEMP )';
        String subQuery = '';
        for(Integer i = 1; i <= 6; i ++) {
            month -= 1;
            if(month == 0) {
                year = String.valueOf(Integer.valueOf(year) - 1);
                month = 12;
            }
            subQuery += ' ( Fiscal_Month__c =' + month + ' And Fiscal_Year__c = \'' + year+'\') OR ';
            
        }
        subQuery = subQuery.substringBeforeLast('OR');
        //system.debug('subQuery :: ' + subQuery);
        query = query.replace('TEMP', subQuery);
        return query;
    }
    
   /**
    * This method is used to build currency iso map 
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
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
    * This method is used to generate account billing percentage map
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    private static void copyAcctBillPercentage(String parentId, String childId, AggregateResult bbbM, map<String, map<String, map<String,decimal>>> map_parentId_map_childId_map_profitCtr_percent, map<String, decimal> map_parentId_totalBills) {
        decimal bills = (decimal) bbbM.get('Bills');
        String profitCtr = (String) bbbM.get('profitCtr');
        if(!map_parentId_totalBills.containsKey(parentId)) {
            map_parentId_totalBills.put(parentId, 0);
        }
        decimal total = map_parentId_totalBills.get(parentId);
        total += bills;
        map_parentId_totalBills.put(parentId, total);
        if(profitCtr == null || profitCtr == '') {
            return; 
        }
        
        if(!map_parentId_map_childId_map_profitCtr_percent.containsKey(parentId)) {
            map_parentId_map_childId_map_profitCtr_percent.put(parentId, new map<String, map<String, decimal>> {childId => new map<String, decimal> {profitCtr => 0}});
        }
        else if(!map_parentId_map_childId_map_profitCtr_percent.get(parentId).containsKey(childId)) {
            map_parentId_map_childId_map_profitCtr_percent.get(parentId).put(childId, new map<String, decimal> {profitCtr => 0});
        }
        else if(!map_parentId_map_childId_map_profitCtr_percent.get(parentId).get(childId).containsKey(profitCtr)) {
            map_parentId_map_childId_map_profitCtr_percent.get(parentId).get(childId).put(profitCtr, 0);
        }
        
        decimal partTotal = map_parentId_map_childId_map_profitCtr_percent.get(parentId).get(childId).get(profitCtr);
        partTotal += bills;
        map_parentId_map_childId_map_profitCtr_percent.get(parentId).get(childId).put(profitCtr, partTotal);
    }

   /**
    * This method is used to calc account billing percentage.
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    private static void calcAcctBillPercentage(map<String, map<String, map<String,decimal>>> map_parentId_map_childId_map_profitCtr_percent, map<String, decimal> map_parentId_totalBills) {
        try {
            for(String parentId : map_parentId_map_childId_map_profitCtr_percent.keySet()) {
                decimal avgPercent = 0;
                if(map_parentId_totalBills.get(parentId) == null || map_parentId_totalBills.get(parentId) == 0) {
                    //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'map_parentId_map_childId_map_profitCtr_percent :: ' + map_parentId_map_childId_map_profitCtr_percent.get(parentId)));
                    Integer counter = 1;
                    for(String childId : map_parentId_map_childId_map_profitCtr_percent.get(parentId).keySet()) {
                        for(String profitCtr : map_parentId_map_childId_map_profitCtr_percent.get(parentId).get(childId).keySet()) {
                            counter ++;
                        }
                    }
                    avgPercent = 1 / counter;
                }
                for(String childId : map_parentId_map_childId_map_profitCtr_percent.get(parentId).keySet()) {
                    for(String profitCtr : map_parentId_map_childId_map_profitCtr_percent.get(parentId).get(childId).keySet()) {
                        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'profitCtr :: ' + profitCtr));
                        decimal totalBills = map_parentId_totalBills.get(parentId);
                        decimal percent = ((totalBills == 0 || totalBills == null)? avgPercent : map_parentId_map_childId_map_profitCtr_percent.get(parentId).get(childId).get(profitCtr) / totalBills);
                        percent.setScale(DECIMALSCALE);
                        map_parentId_map_childId_map_profitCtr_percent.get(parentId).get(childId).put(profitCtr, percent);
                    }
                }
            }
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'map_parentId_map_childId_map_profitCtr_percent :: ' + map_parentId_map_childId_map_profitCtr_percent));
        }
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
        }
    }

   /**
    * This method is used to set account forecast pervious TBR rate
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    private static void setPrevTBR(BBB_Month_Bill_Book_Cust__c bbbM, decimal currencyConvert) {
        bbbM.Forecast_Previous_TBR_USD__c = currencyConvert;
    }
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
}