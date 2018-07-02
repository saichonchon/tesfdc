/**
 *  Contains a set of static methods used Financial Forecast batch classes.
 *
 @author Bin Yuan
 @created 2013-11-19
 @version 1.0
 @since 29.0 (Force.com ApiVersion)
 *
 @changelog
 * 2013-01-05 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created
 */
      
public class ClsFinancialFCBatchUtil {
  
    public static final Integer QNUMBER = 3;
    
    //********************************* -=BEGIN public methods=- **********************************
   /**
    * This method is used to 
    *
    @author Bin Yuan
    @created 2013-11-19
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2013-11-19 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void setCurrent(PageConfig pageConf) {
        for (Period period : [select Id, FiscalYearSettings.Name, PeriodLabel from Period where StartDate<=Today and EndDate >=Today and Type = 'Month']) {
            if(period.FiscalYearSettings.Name != null){
                pageConf.currentYear = period.FiscalYearSettings.Name;
            }
            if(period.PeriodLabel != null){
                pageConf.currentMonth = ClsBudgetPlanBreakDownUtil.MAP_MONTHLABELNUMBER.get(period.PeriodLabel);
            }
        }
    }
    /**
    * This method is used to 
    *
    @author Bin Yuan
    @created 2013-11-19
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2013-11-19 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void setfinancialMonths(map<String, Set<Integer>> map_financialMonth) {
      date startDate = date.today();
      date endDate = date.today();
      
      for (Period period : [select StartDate from Period where StartDate <= Today and Type = 'Quarter' order by StartDate desc limit: QNUMBER]) {
            if(period.startDate != null && period.StartDate < startDate){
                startDate = period.StartDate;
            }
        }
        
        for (Period period : [select EndDate from Period where EndDate >= Today and Type = 'Quarter' order by EndDate limit: QNUMBER]) {
            if(period.EndDate != null && period.EndDate > endDate){
                endDate = period.EndDate;
            }
        }
        
        for (Period period : [select Id, FiscalYearSettings.Name, PeriodLabel from Period where StartDate>= : startDate and EndDate<=: endDate and Type = 'Month']) {
            if(!map_financialMonth.containsKey(period.FiscalYearSettings.Name)) {
              map_financialMonth.put(period.FiscalYearSettings.Name, new Set<Integer>());
            }
            map_financialMonth.get(period.FiscalYearSettings.Name).add(ClsBudgetPlanBreakDownUtil.MAP_MONTHLABELNUMBER.get(period.PeriodLabel));
        }
    }
    public static boolean checkIfBeginOfQuarter(Date startDate) {
    	boolean isBeginOfQuarter = false;
    	Date quarterFirstMonthStartDate;
    	Date quarterFirstMonthEndDate;
    	Date quarterLastMonthStartDate;
    	Date quarterLastMonthEndDate;
    	
    	//get
    	for(Period period : [select EndDate, StartDate
    			 			 from Period 
    			 			 where StartDate <=: startDate 
    			 			 and EndDate >: startDate
    			 			 and Type = 'Quarter']) {
    	
    		quarterFirstMonthStartDate = period.StartDate;
    		quarterLastMonthEndDate = period.EndDate;
    	}
    	return isBeginOfQuarter;
    }
    /**
    * This method is used to 
    *
    @author Bin Yuan
    @created 2013-11-19
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2013-11-19 Bin Yuan <bin.yuan@itbconsult.com>
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
    * This method is used to 
    *
    @author Bin Yuan
    @created 2013-11-19
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2013-11-19 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static Integer getCurrentMonthIndex(map<String, Set<Integer>> map_financialMonth, String currentYear, Integer currentMonth) {
        Integer currentMonthIndex = 0;
        list<String> list_years = new list<String>();
        list_years.addAll(map_financialMonth.keySet());
        list_years.sort();
    
        for (String year : list_years) {
            if(year != null && year != '' && year > currentYear) {
                break;
            }
            else {
                if (map_financialMonth.get(year) != null && map_financialMonth.size() > 0) {
                    list<Integer> list_months = new list<Integer>();
                    list_months.addAll(map_financialMonth.get(year));
                    list_months.sort();

                    for (Integer month : list_months) {
                        currentMonthIndex++;
                        if(currentYear == year && currentMonth == month) {
                            break;
                        }
                    }               
                }
            }
        }    
        return currentMonthIndex;     
    }
    /**
    * This method is used to 
    *
    @author Lili Zhao
    @created 2013-11-20
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2013-11-20 Lili Zhao <lili.Zhao@itbconsult.com>
    * - Created
    */
    public static void setDate(Integer index,Integer currentYear,Integer currentMonth,Set<Date> set_date){
        if(index-6 == 1){
            set_date.add(date.newinstance(currentYear, currentMonth, 15));
        }else if(index-6 == 2){
            if(currentMonth == 1){
                set_date.add(date.newinstance(currentYear-1, 12, 15));
                set_date.add(date.newinstance(currentYear, currentMonth, 15));
            }else{
                set_date.add(date.newinstance(currentYear, currentMonth-1, 15));
                set_date.add(date.newinstance(currentYear, currentMonth, 15));
            }
        }else if(index-6 == 3){
            if(currentMonth == 2){
                set_date.add(date.newinstance(currentYear-1, 12, 15));
                set_date.add(date.newinstance(currentYear, currentMonth-1, 15));
                set_date.add(date.newinstance(currentYear, currentMonth, 15));
            }else if(currentMonth == 1){
                set_date.add(date.newinstance(currentYear-1, 12, 15));
                set_date.add(date.newinstance(currentYear-1, 11, 15));
                set_date.add(date.newinstance(currentYear, currentMonth, 15));
            }else{
                set_date.add(date.newinstance(currentYear, currentMonth-2, 15));
                set_date.add(date.newinstance(currentYear, currentMonth-1, 15));
                set_date.add(date.newinstance(currentYear, currentMonth, 15));
            }
        }
        if(currentMonth <= 6){
            for(Integer i=currentMonth+1;i<=currentMonth+6;i++){
                set_date.add(date.newinstance(currentYear, i, 15));
            }
        }else if(currentMonth > 6 && currentMonth != 12){
            for(Integer i=currentMonth+1;i<=12;i++){
                set_date.add(date.newinstance(currentYear, i, 15));
            }
              
            for(Integer i=1;i<=6-(12-currentMonth);i++){
                set_date.add(date.newinstance(currentYear+1, i, 15));
            }
        }else if(currentMonth == 12){
            for(Integer i=1;i<=6-(12-currentMonth);i++){
                set_date.add(date.newinstance(currentYear+1, i, 15));
            }
        }
    }
    
    /**
    * This method is used to set RSM previous month forecast
    *
    @author Yuda Zheng
    @created 2013-12-05
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2013-12-05 Yuda Zheng <yuda.zheng@itbconsult.com>
    * - Created
    */
    public static void setManagerForecast(List<Manager_Forecast__c> list_mgForecasts, Date startDate, boolean isQuarterStart, boolean isQuarterEnd) {   
    	for(Manager_Forecast__c managerForecast : list_mgForecasts){   
            Integer previous = startDate.monthsBetween(managerForecast.Fiscal_Date__c);
            
        	managerForecast.Previous_Month_Forecast_Document__c = managerForecast.Forecast_USD__c;
            if(previous > 1 && previous <= 6) {
            	managerForecast.put('Forecast_' + previous + '_Months_Document__c', managerForecast.Forecast_USD__c);
            }
            if(isQuarterStart && previous <= 2) {
            	managerForecast.Forecast_Begin_of_Quarter_Document__c = managerForecast.Forecast_USD__c;
            }
            if(isQuarterEnd && previous >= 1 && previous <= 3) {
            	managerForecast.Forecast_End_of_Previous_Quarter_Documen__c = managerForecast.Forecast_USD__c;
            }
    	}	
    }
    
    /**
    * This method is used to 
    *
    @author Lili Zhao
    @created 2013-11-20
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2013-11-20 Lili Zhao <lili.Zhao@itbconsult.com>
    * - Created
    
    public static void setManagerForecast(List<Manager_Forecast__c> list_mgForecasts,Integer index,Integer currentYear,Integer currentMonth) {
        Date quarterLastDate = list_mgForecasts[0].Last_Frozen_Month_Date__c;

        for(Manager_Forecast__c mgForecast : list_mgForecasts){
            Integer year = Integer.valueOf(mgForecast.Fiscal_Year__c);
            Integer month = Integer.valueOf(mgForecast.Fiscal_Month__c);
            if((currentYear -year == 1)){
                if(index-6 == 3 && (currentMonth == 2 || currentMonth == 1)){
                    if(quarterLastDate < Date.today()){
                        mgForecast.Forecast_Begin_of_Quarter_Document__c = mgForecast.Forecast_USD__c;
                    }
                }else if(index - 6 == 2){
                    if(quarterLastDate < Date.today()){
                        mgForecast.Forecast_Begin_of_Quarter_Document__c = mgForecast.Forecast_USD__c;
                    }
                }
                
            }else if(currentYear == year){
                if((month - currentMonth == -2 || month - currentMonth == -1 || month == currentMonth)  && index-6 == 3){
                    if(quarterLastDate < Date.today()){
                        mgForecast.Forecast_Begin_of_Quarter_Document__c = mgForecast.Forecast_USD__c;
                    }
                }
                if((month - currentMonth == -1 || month == currentMonth)  && index-6 == 2){
                    if(quarterLastDate < Date.today()){
                        mgForecast.Forecast_Begin_of_Quarter_Document__c = mgForecast.Forecast_USD__c;
                    }
                }                               
                if(month - currentMonth == 1){
                    if(index-6 == 2 || index-6 == 1){
                        if(quarterLastDate < Date.today()){
                            mgForecast.Forecast_Begin_of_Quarter_Document__c = mgForecast.Forecast_USD__c;
                        }
                    }                   
                    mgForecast.Previous_Month_Forecast_Document__c = mgForecast.Forecast_USD__c;
                }else if(month - currentMonth == 2){
                    if(index-6 == 1){
                        if(quarterLastDate < Date.today()){
                            mgForecast.Forecast_Begin_of_Quarter_Document__c = mgForecast.Forecast_USD__c;
                        }
                    }                   
                    mgForecast.Forecast_2_Months_Document__c = mgForecast.Forecast_USD__c;
                }else if(month - currentMonth == 3){
                    mgForecast.Forecast_3_Months_Document__c = mgForecast.Forecast_USD__c;
                }else if(month - currentMonth == 4){
                    mgForecast.Forecast_4_Months_Document__c = mgForecast.Forecast_USD__c;
                }else if(month - currentMonth == 5){
                    mgForecast.Forecast_5_Months_Document__c = mgForecast.Forecast_USD__c;
                }else if(month - currentMonth == 6){
                    mgForecast.Forecast_6_Months_Document__c = mgForecast.Forecast_USD__c;
                }
            }else if(year - currentYear == 1){
                if(currentMonth - month == 11){
                    mgForecast.Previous_Month_Forecast_Document__c = mgForecast.Forecast_USD__c;
                }else if(currentMonth - month == 10){
                    mgForecast.Forecast_2_Months_Document__c = mgForecast.Forecast_USD__c;
                }else if(currentMonth - month == 9){
                    mgForecast.Forecast_3_Months_Document__c = mgForecast.Forecast_USD__c;
                }else if(currentMonth - month == 8){
                    mgForecast.Forecast_4_Months_Document__c = mgForecast.Forecast_USD__c;
                }else if(currentMonth - month == 7){
                    mgForecast.Forecast_5_Months_Document__c = mgForecast.Forecast_USD__c;
                }else if(currentMonth - month == 6){
                    mgForecast.Forecast_6_Months_Document__c = mgForecast.Forecast_USD__c;
                }
            }
        }    
    }
    */
    /**
    * This method is used to 
    *
    @author Lili Zhao
    @created 2013-11-20
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2013-11-20 Lili Zhao <lili.Zhao@itbconsult.com>
    * - Created
    */
    public static void setYearMonth(Integer index,Integer currentYear,Integer currentMonth,Map<Integer,set<Integer>> map_year_months){
    	Integer quarterYear;
    	Integer quarterMonth; 
        if(index-6 == 1){
            quarterMonth = currentMonth;
            quarterYear = currentYear;
            
            if(!map_year_months.containsKey(currentYear))
                map_year_months.put(currentYear,new Set<Integer>());
            map_year_months.get(currentYear).add(currentMonth);
            
        }else if(index-6 == 2){
            if(currentMonth == 1){
                quarterMonth = 12;
                quarterYear = currentYear-1;
                
                if(!map_year_months.containsKey(currentYear))
                    map_year_months.put(currentYear,new Set<Integer>());
                map_year_months.get(currentYear).add(currentMonth);
                
                if(!map_year_months.containsKey(quarterYear))
                    map_year_months.put(quarterYear,new Set<Integer>());
                map_year_months.get(quarterYear).add(quarterMonth);
                
            }else{
                quarterMonth = currentMonth-1;
                quarterYear = currentYear;
                
                if(!map_year_months.containsKey(currentYear))
                    map_year_months.put(currentYear,new Set<Integer>());
                map_year_months.get(currentYear).add(currentMonth);
                map_year_months.get(currentYear).add(currentMonth-1);
                
            }
        }else if(index-6 == 3){
            if(currentMonth == 2){
                quarterMonth = 12;
                quarterYear = currentYear-1;
                
                if(!map_year_months.containsKey(currentYear))
                    map_year_months.put(currentYear,new Set<Integer>());
                map_year_months.get(currentYear).add(currentMonth);
                map_year_months.get(currentYear).add(currentMonth-1);
                
                if(!map_year_months.containsKey(quarterYear))
                    map_year_months.put(quarterYear,new Set<Integer>());
                map_year_months.get(quarterYear).add(12);
                
            }else if(currentMonth == 1){
                quarterMonth = 11;
                quarterYear = currentYear-1;
                
                if(!map_year_months.containsKey(currentYear))
                    map_year_months.put(currentYear,new Set<Integer>());
                map_year_months.get(currentYear).add(currentMonth);
                
                if(!map_year_months.containsKey(quarterYear))
                    map_year_months.put(quarterYear,new Set<Integer>());
                map_year_months.get(quarterYear).add(11);
                map_year_months.get(quarterYear).add(12);
                
            }else{
                quarterMonth = currentMonth-2;
                quarterYear = currentYear;
                
                if(!map_year_months.containsKey(currentYear))
                    map_year_months.put(currentYear,new Set<Integer>());
                map_year_months.get(currentYear).add(currentMonth);
                map_year_months.get(currentYear).add(currentMonth-1);
                map_year_months.get(currentYear).add(currentMonth-2);
                
            }
        }       
        
        if(currentMonth <= 6){
            if(!map_year_months.containsKey(currentYear))
                    map_year_months.put(currentYear,new Set<Integer>());
                    
            for(Integer i=currentMonth+1;i<=currentMonth+6;i++){
                map_year_months.get(currentYear).add(i);
            }

        }else if(currentMonth > 6 && currentMonth != 12){
            if(!map_year_months.containsKey(currentYear))
                    map_year_months.put(currentYear,new Set<Integer>());
            
            for(Integer i=currentMonth+1;i<=12;i++){
                map_year_months.get(currentYear).add(i);
            }
            
            Integer year2 = currentYear+1;
            if(!map_year_months.containsKey(year2))
                    map_year_months.put(year2,new Set<Integer>());
            
            for(Integer i=1;i<=6-(12-currentMonth);i++){
                map_year_months.get(year2).add(i);
            }
        }else if(currentMonth == 12){
            Integer year2 = currentYear+1;
            if(!map_year_months.containsKey(year2))
                map_year_months.put(year2,new Set<Integer>());
            
            String monthStr2 = '';
            for(Integer i=1;i<=6-(12-currentMonth);i++){
                map_year_months.get(year2).add(i);
            }
        }
    }
    
    /**
    * This method is used to set BBBM backlog
    *
    @author Yuda Zheng
    @created 2013-12-06
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2013-12-06 Yuda Zheng <yuda.zheng@itbconsult.com>
    * - Created
    */
    public static void setBBBMonthBacklog(List<BBB_Month_Bill_Book_Cust__c> list_BBMonths, Date endDate, String bbbMQuery) {   
    	
    	map<String, map<String, map<Date, BBB_Month_Bill_Book_Cust__c>>> map_accountDateBBM = new map<String, map<String, map<Date, BBB_Month_Bill_Book_Cust__c>>>();
    	set<String> set_bbbMIds = new set<String>();
    	list<BBB_Month_Bill_Book_Cust__c> list_bbbmForCalc = new list<BBB_Month_Bill_Book_Cust__c>();
    	set<String> set_acctIds = new set<String>();
    	
		generateBBBMonthMap(list_BBMonths, map_accountDateBBM, set_bbbMIds);
    	set_acctIds = map_accountDateBBM.keySet();
		
    	bbbMQuery += ' and Customer__c IN : set_acctIds and Id not in : set_bbbMIds ';
		for(BBB_Month_Bill_Book_Cust__c bbbm : database.query(bbbMQuery)) {
			list_bbbmForCalc.add(bbbm);
		}
		if(!list_bbbmForCalc.isEmpty()) {}
		generateBBBMonthMap(list_bbbmForCalc, map_accountDateBBM, set_bbbMIds);
		
    	for(String account : map_accountDateBBM.keySet()) {
    		for(String pcenter : map_accountDateBBM.get(account).keySet()) {
    			if(map_accountDateBBM.get(account).get(pcenter).get(endDate) != null) {
    				for (Integer i = 1; i <= 3; i++) {
    					if(map_accountDateBBM.get(account).get(pcenter).get(endDate.addMonths(-i)) != null && map_accountDateBBM.get(account).get(pcenter).get(endDate.addMonths(-i)).get('Backlog_' + i + '__c') != null) {
    						map_accountDateBBM.get(account).get(pcenter).get(endDate).put('Backlog_' + (i + 3) + '__c', map_accountDateBBM.get(account).get(pcenter).get(endDate.addMonths(-i)).get('Backlog_' + i + '__c'));
    					}
    				}
    			}
    		}
    	}
    }
    
    /**
    * This method is used to set BBBM Currency 1~4
    *
    @author Bin Yuan
    @created 2014-03-11
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void setBBBMonthCurrency(list<BBB_Month_Bill_Book_Cust__c> list_bbbMonthlys, String bbbMQuery, Date calcStartDate) {   
    	
    	map<String, map<String, map<Date, BBB_Month_Bill_Book_Cust__c>>> map_acctId_map_sapProfitCtr_map_date_bbbm = new map<String, map<String, map<Date, BBB_Month_Bill_Book_Cust__c>>>();
    	set<String> set_bbbmIds = new set<String>();
    	list<BBB_Month_Bill_Book_Cust__c> list_bbbmForCalc = new list<BBB_Month_Bill_Book_Cust__c>();
    	set<String> set_acctIds = new set<String>();
    	String str_null = 'null';
		generateBBBMonthMap(list_bbbMonthlys, map_acctId_map_sapProfitCtr_map_date_bbbm, set_bbbmIds);
    	set_acctIds = map_acctId_map_sapProfitCtr_map_date_bbbm.keySet();
    	
		//get all bbb monthly records for all accounts and all months
    	bbbMQuery += ' and Customer__c IN : set_acctIds and Id not in : set_bbbMIds ';
    	system.debug('bbbm query :: ' + bbbMQuery);
		for(BBB_Month_Bill_Book_Cust__c bbbm : database.query(bbbMQuery)) {
			list_bbbmForCalc.add(bbbm);
		}
		
		if(!list_bbbmForCalc.isEmpty()) {
			generateBBBMonthMap(list_bbbmForCalc, map_acctId_map_sapProfitCtr_map_date_bbbm, set_bbbmIds);
		}
		//loop for assign currency values
		for(BBB_Month_Bill_Book_Cust__c currentMonthBBBM : list_bbbMonthlys) {
			
			String acctId = currentMonthBBBM.Customer__c;
			String sapProfitCtrCode = ((currentMonthBBBM.SAP_Profit_Center_Code__c == null || currentMonthBBBM.SAP_Profit_Center_Code__c == '') ? str_null : currentMonthBBBM.SAP_Profit_Center_Code__c);
			Date calcDate = currentMonthBBBM.Fiscal_date__c;
			system.debug('calcDate  :: ' + calcDate);
			if(calcDate == null) {
				return;
			}
			BBB_Month_Bill_Book_Cust__c prev1MonthBBBM = (map_acctId_map_sapProfitCtr_map_date_bbbm.get(acctId).get(sapProfitCtrCode).get(calcDate.addMonths(-1)) == null ? null : map_acctId_map_sapProfitCtr_map_date_bbbm.get(acctId).get(sapProfitCtrCode).get(calcDate.addMonths(-1)));
			BBB_Month_Bill_Book_Cust__c prev2MonthBBBM = (map_acctId_map_sapProfitCtr_map_date_bbbm.get(acctId).get(sapProfitCtrCode).get(calcDate.addMonths(-2)) == null ? null : map_acctId_map_sapProfitCtr_map_date_bbbm.get(acctId).get(sapProfitCtrCode).get(calcDate.addMonths(-2)));
			BBB_Month_Bill_Book_Cust__c prev3MonthBBBM = (map_acctId_map_sapProfitCtr_map_date_bbbm.get(acctId).get(sapProfitCtrCode).get(calcDate.addMonths(-3)) == null ? null : map_acctId_map_sapProfitCtr_map_date_bbbm.get(acctId).get(sapProfitCtrCode).get(calcDate.addMonths(-3)));
			system.debug('currentMonthBBBM :: ' + currentMonthBBBM);
			system.debug('prev1MonthBBBM :: ' + prev1MonthBBBM);
			system.debug('prev2MonthBBBM :: ' + prev2MonthBBBM);
			system.debug('prev3MonthBBBM :: ' + prev3MonthBBBM);
			decimal demandShipped = (currentMonthBBBM.Demand_Shipped__c == null ? 0 : currentMonthBBBM.Demand_Shipped__c);
			decimal demandOpen = (currentMonthBBBM.Demand_Open__c == null ? 0 : currentMonthBBBM.Demand_Open__c);
			decimal totalDemand = (demandShipped + demandOpen);
			totalDemand = (currentMonthBBBM.CurrencyIsoCode != 'USD' ? ClsAcctForecastUtil.transformIsoCode(totalDemand, currentMonthBBBM.CurrencyIsoCode, 'USD') : totalDemand);
			decimal backlog0 = (currentMonthBBBM.Backlog_0__c == null ? 0 : ClsAcctForecastUtil.transformIsoCode(currentMonthBBBM.Backlog_0__c, currentMonthBBBM.CurrencyIsoCode, 'USD'));
			decimal	prev1Back1 = ((prev1MonthBBBM == null || prev1MonthBBBM.Backlog_1__c == null) ? 0 : ClsAcctForecastUtil.transformIsoCode(prev1MonthBBBM.Backlog_1__c, prev1MonthBBBM.CurrencyIsoCode, 'USD'));
			decimal	prev2Back2 = ((prev2MonthBBBM == null || prev2MonthBBBM.Backlog_2__c == null) ? 0 : ClsAcctForecastUtil.transformIsoCode(prev2MonthBBBM.Backlog_2__c, prev2MonthBBBM.CurrencyIsoCode, 'USD'));
			decimal	prev3Back3 = ((prev3MonthBBBM == null || prev3MonthBBBM.Backlog_3__c == null) ? 0 : ClsAcctForecastUtil.transformIsoCode(prev3MonthBBBM.Backlog_3__c, prev3MonthBBBM.CurrencyIsoCode, 'USD'));
			
			
				
			currentMonthBBBM.Currency_1_USD__c = totalDemand - backlog0;
			
			currentMonthBBBM.Currency_2_USD__c = totalDemand - prev1Back1;
			
			currentMonthBBBM.Currency_3_USD__c = totalDemand - prev2Back2;
		
			currentMonthBBBM.Currency_4_USD__c = totalDemand - prev3Back3;
		}
    }
    
    /**
    * This method is used to set BBBM currency
    *
    @author Yuda Zheng
    @created 2013-12-06
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2013-12-06 Yuda Zheng <yuda.zheng@itbconsult.com>
    * - Created
    */
    public static void setBBBMonthCurrency(List<BBB_Month_Bill_Book_Cust__c> list_BBMonths) {   
    	for(BBB_Month_Bill_Book_Cust__c monthBill : list_BBMonths){   
    		if(monthBill.Bill_Amount_USD__c != null) {
    			if(monthBill.Backlog_0__c != null ) {
    				monthBill.Currency_1_USD__c = monthBill.Bill_Amount_USD__c - monthBill.Backlog_0__c;
    			}
    			if(monthBill.Backlog_4__c != null ) {
    				monthBill.Currency_2_USD__c = monthBill.Bill_Amount_USD__c - monthBill.Backlog_4__c;
    			}
    			if(monthBill.Backlog_5__c != null ) {
    				monthBill.Currency_3_USD__c = monthBill.Bill_Amount_USD__c - monthBill.Backlog_5__c;
    			}
    			if(monthBill.Backlog_6__c != null ) {
    				monthBill.Currency_4_USD__c = monthBill.Bill_Amount_USD__c - monthBill.Backlog_6__c;
    			}
    		}
    	}	
    }
    
    /**
    * This method is used to set ASM previous month forecast
    *
    @author Yuda Zheng
    @created 2013-12-05
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2013-12-05 Yuda Zheng <yuda.zheng@itbconsult.com>
    * - Created
    */
    public static void setBBBMonthBillBookCust(List<BBB_Month_Bill_Book_Cust__c> list_BBMonths, Date startDate, boolean isQuarterStart, boolean isQuarterEnd) {   
    	for(BBB_Month_Bill_Book_Cust__c monthBill : list_BBMonths){   
            Integer previous = startDate.monthsBetween(monthBill.Fiscal_Date__c);
            
        	monthBill.Previous_Month_Forecast_Document__c = monthBill.forecast__c;
            if(previous > 1 && previous <= 6) {
            	monthBill.put('Forecast_' + previous + '_Months_Document__c', monthBill.forecast__c);
            }
            if(isQuarterStart && previous <= 2) {
            	monthBill.Forecast_Begin_of_Quarter_Document__c = monthBill.forecast__c;
            }
            if(isQuarterEnd && previous >= 1 && previous <= 3) {
            	monthBill.Forecast_End_of_Prev_Quarter_Document__c = monthBill.forecast__c;
            }
            
    	}	
    }
    
    /**
    * This method is used to 
    *
    @author Lili Zhao
    @created 2013-11-20
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2013-11-20 Lili Zhao <lili.Zhao@itbconsult.com>
    * - Created
    
    public static void setBBBMonthBillBookCust(List<BBB_Month_Bill_Book_Cust__c> list_BBMonths,Integer index,Integer currentYear,Integer currentMonth) {   
        Date quarterLastDate = list_BBMonths[0].Last_Frozen_Month_Date__c;
        
        for(BBB_Month_Bill_Book_Cust__c monthBill : list_BBMonths){         
            Integer month = Integer.valueOf(monthBill.Fiscal_Month__c);
            Integer year = Integer.valueOf(monthBill.Fiscal_year__c);
            
            if((currentYear -year == 1)){
                if(index-6 == 3 && (currentMonth == 2 || currentMonth == 1)){
                    if(quarterLastDate < Date.today()){
                        monthBill.Forecast_Begin_of_Quarter_Document__c = monthBill.forecast__c;
                    }
                }else if(index - 6 == 2){
                    if(quarterLastDate < Date.today()){
                        monthBill.Forecast_Begin_of_Quarter_Document__c = monthBill.forecast__c;
                    }
                }
                
           	}else if(currentYear == year){
                if((month - currentMonth == -2 || month - currentMonth == -1 || month == currentMonth)  && index-6 == 3){
                    if(quarterLastDate < Date.today()){
                        monthBill.Forecast_Begin_of_Quarter_Document__c = monthBill.forecast__c;
                    }
                }
                if((month - currentMonth == -1 || month == currentMonth)  && index-6 == 2){
                    if(quarterLastDate < Date.today()){
                        monthBill.Forecast_Begin_of_Quarter_Document__c = monthBill.forecast__c;
                    }
                }
                
                if(month - currentMonth == 1){
                    if(index-6 == 2 || index-6 == 1){
                        if(quarterLastDate < Date.today()){
                            monthBill.Forecast_Begin_of_Quarter_Document__c = monthBill.forecast__c;
                        }
                    }
                    monthBill.Previous_Month_Forecast_Document__c = monthBill.forecast__c;
                }else if(month - currentMonth == 2){
                    if(index-6 == 1){
                        if(quarterLastDate < Date.today()){
                            monthBill.Forecast_Begin_of_Quarter_Document__c = monthBill.forecast__c;
                        }
                	}
                    monthBill.Forecast_2_Months_Document__c = monthBill.forecast__c;
                }else if(month - currentMonth == 3){
                    monthBill.Forecast_3_Months_Document__c = monthBill.forecast__c;
                }else if(month - currentMonth == 4){
                    monthBill.Forecast_4_Months_Document__c = monthBill.forecast__c;
                }else if(month - currentMonth == 5){
                    monthBill.Forecast_5_Months_Document__c = monthBill.forecast__c;
                }else if(month - currentMonth == 6){
                    monthBill.Forecast_6_Months_Document__c = monthBill.forecast__c;
                }
            }else if(year - currentYear == 1){
                if(currentMonth - month == 11){
                    monthBill.Previous_Month_Forecast_Document__c = monthBill.forecast__c;
                }else if(currentMonth - month == 10){
                    monthBill.Forecast_2_Months_Document__c = monthBill.forecast__c;
                }else if(currentMonth - month == 9){
                    monthBill.Forecast_3_Months_Document__c = monthBill.forecast__c;
                }else if(currentMonth - month == 8){
                    monthBill.Forecast_4_Months_Document__c = monthBill.forecast__c;
                }else if(currentMonth - month == 7){
                    monthBill.Forecast_5_Months_Document__c = monthBill.forecast__c;
                }else if(currentMonth - month == 6){
                    monthBill.Forecast_6_Months_Document__c = monthBill.forecast__c;
                }
            }
        }

    }          
	*/
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    /**
    * This method is used to generate bbb monthly map by using gaven bbb month list
    *
    @author Bin Yuan
    @created 2014-02-25
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2013-12-05 Yuda Zheng <yuda.zheng@itbconsult.com>
    * - Created
    */
	private static void generateBBBMonthMap(list<BBB_Month_Bill_Book_Cust__c> list_bbbMonthly, map<String, map<String, map<Date, BBB_Month_Bill_Book_Cust__c>>> map_accountDateBBM, set<String> set_bbbMIds) {
    	String str_null = 'null';
    	for(BBB_Month_Bill_Book_Cust__c monthBill : list_bbbMonthly){   
    		set_bbbMIds.add(monthBill.Id);
    		String sapProfitCtrCode = ((monthBill.SAP_Profit_Center_Code__c == null || monthBill.SAP_Profit_Center_Code__c == '') ? str_null : monthBill.SAP_Profit_Center_Code__c);
    		if(!map_accountDateBBM.containsKey(monthBill.Customer__c)) {
    			map_accountDateBBM.put(monthBill.Customer__c, new map<String, map<Date, BBB_Month_Bill_Book_Cust__c>>());
    		}
    		if(!map_accountDateBBM.get(monthBill.Customer__c).containsKey(sapProfitCtrCode)) {
    			map_accountDateBBM.get(monthBill.Customer__c).put(sapProfitCtrCode, new map<Date, BBB_Month_Bill_Book_Cust__c>());
    		}
    		map_accountDateBBM.get(monthBill.Customer__c).get(sapProfitCtrCode).put(monthBill.Fiscal_date__c, monthBill);
    	}
	}    
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
    public class PageConfig {

        public Integer currentMonth{get; set;}
        public String currentYear {get; set;}
        public Integer currentMonthIndex{get; set;}
        public map<String, Set<Integer>> map_financialMonth {get; set;}
        public PageConfig() {   
            this.currentMonthIndex = 0;
            this.currentYear = '';
            this.currentMonth = 0;   
            this.map_financialMonth = new Map<String,Set<Integer>>();
        } 
    }
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
}