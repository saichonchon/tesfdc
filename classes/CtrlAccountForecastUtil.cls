/** 
*    Util calss for CtrlAccountForecast
*
@author Yuda Zheng
@created 2013-09-23
@version 1.0
@since 27.0 (Force.com ApiVersion)
*
@changelog
* 2013-09-23 Yuda Zheng <yuda.zheng@itbconsult.com>
* - Created
*/

public class CtrlAccountForecastUtil {
    
    public static final Integer QNUMBER = 3;
    public static final Integer FUTUREQNUMBER = 9;

    public static void setCurrent(CtrlAccountForecast.PageConfig pageConf) {
        for (Period period : [select Id, FiscalYearSettings.Name, PeriodLabel from Period where StartDate<=Today and EndDate >=Today and Type = 'Month']) {
            if(period.FiscalYearSettings.Name != null){
                pageConf.currentYear = period.FiscalYearSettings.Name;
            }
            if(period.PeriodLabel != null){
                pageConf.currentMonth = ClsAcctForecastUtil.MAP_MONTHLABELNUMBER.get(period.PeriodLabel);
            }
        }
    }
    
    public static void setfinancialMonths(map<String, Set<Integer>> map_financialMonth) {
        date startDate = date.today();
        date endDate = date.today();
        
        for (Period period : [select StartDate from Period where StartDate <= Today and Type = 'Quarter' order by StartDate desc limit: QNUMBER]) {
            if(period.startDate != null && period.StartDate < startDate){
                startDate = period.StartDate;
            }
        }
        
        for (Period period : [select EndDate from Period where EndDate >= Today and Type = 'Quarter' order by EndDate limit:  FUTUREQNUMBER]) {
            if(period.EndDate != null && period.EndDate > endDate){
                endDate = period.EndDate;
            }
        }
        
        for (Period period : [select Id, FiscalYearSettings.Name, PeriodLabel from Period where StartDate>= : startDate and EndDate<=: endDate and Type = 'Month']) {
            if(!map_financialMonth.containsKey(period.FiscalYearSettings.Name)) {
                map_financialMonth.put(period.FiscalYearSettings.Name, new Set<Integer>());
            }
            map_financialMonth.get(period.FiscalYearSettings.Name).add(ClsAcctForecastUtil.MAP_MONTHLABELNUMBER.get(period.PeriodLabel));
        }
    }
    
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
}