/** 
*   Util calss for RSM Forecast
*
@author Yuda Zheng
@created 2013-09-30
@version 1.0
@since 27.0 (Force.com ApiVersion)
*
@changelog
* 2013-09-30 Yuda Zheng <yuda.zheng@itbconsult.com>
* - Created
*/
public class ClsRSMForecastUtil {
    public static Map<String, Set<Integer>> map_financialMonth {get; set;}
    public static List<String> list_yearMonth {get; set;} 
    public static Map<String, Decimal> map_workingDays {get; set;}
    public static Integer currentMonth {get; set;}
    public static String currentYear {get; set;}
    public static Integer currentMonthIndex {get; set;}
    public static Set<String> set_region {get; set;}
    public static Set<String> set_pcenter {get; set;}
    
    public static final Integer QNUMBER = 3;
    public static final Integer FUTUREQNUMBER = 8;
    
    public ClsRSMForecastUtil() {
        
    }
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
    
    /**
    public static List<Forecast_Definition__c> getForecastDefinition(Id userId) {
        List<Forecast_Definition__c> list_fDefinition = new List<Forecast_Definition__c>();
        for (Forecast_Definition__c fDefinition : [Select Id, RSM__c, Name, Category__c, RSM_Se_quence__c, Subtotal__c, Region__c, Profit_Center__c, RSM_Forecast_Category_Includes__c, RSM_Forecast_Category_Excludes__c, Industrial_Sales_Team_Include__c from Forecast_Definition__c where RSM__c =: userId Order By RSM_Se_quence__c Asc]) {
            list_fDefinition.add(fDefinition);
        }
        return list_fDefinition;
    }
    **/
    
    public static void createDefinition(Id userId, Map<String, Map<String, List<Forecast_Definition__c>>> map_regionPcenterDefinitions, Map<String, List<String>> map_regionPcenters, List<String> list_pcenter_region) {
        //Set<String> set_pcenters = new Set<String>();
        Map<String, Set<String>> map_tempRegionPcenters = new Map<String, Set<String>>();
        Set<String> set_pcenter_region = new Set<String>();
        for (Forecast_Definition__c fDefinition : [Select (Select Forecast_USD__c, Fiscal_Month__c, Fiscal_Year__c, Previous_Month_Forecast_Document__c From Manager_Forecasts__r Where Fiscal_Month__c != null And Fiscal_Year__c != null), Id, RSM__c, Name, Category__c, Category_Label__c, RSM_Se_quence__c, Subtotal__c, Region__c, Profit_Center__c, Profit_Center_Region__c, RSM_Forecast_Category_Includes__c, RSM_Forecast_Category_Excludes__c, Industrial_Sales_Team_Include__c, IND_Customer_Classification__c from Forecast_Definition__c where RSM__c =: userId And IND_Customer_Classification__c != null Order By RSM_Se_quence__c Asc]) {
            if(!map_regionPcenterDefinitions.containsKey(fDefinition.Region__c)) {
                map_regionPcenterDefinitions.put(fDefinition.Region__c, new Map<String, List<Forecast_Definition__c>>());
                map_tempRegionPcenters.put(fDefinition.Region__c, new Set<String>());
            }
            if(!map_regionPcenterDefinitions.get(fDefinition.Region__c).containsKey(fDefinition.Profit_Center__c)) {
                map_regionPcenterDefinitions.get(fDefinition.Region__c).put(fDefinition.Profit_Center__c, new List<Forecast_Definition__c>());
            }
            map_regionPcenterDefinitions.get(fDefinition.Region__c).get(fDefinition.Profit_Center__c).add(fDefinition);
            if(!set_pcenter_region.contains( (fDefinition.Profit_Center__c+'_'+fDefinition.Region__c) )){
                set_pcenter_region.add( (fDefinition.Profit_Center__c+'_'+fDefinition.Region__c) );
            }
            /*
            if(!set_pcenter_region.contains(fDefinition.Profit_Center_Region__c)) {
                set_pcenter_region.add(fDefinition.Profit_Center_Region__c);
            }
            */
            if(!map_tempRegionPcenters.get(fDefinition.Region__c).contains(fDefinition.Profit_Center__c)) {
                map_tempRegionPcenters.get(fDefinition.Region__c).add(fDefinition.Profit_Center__c);
            }
        }
        list_pcenter_region.addAll(set_pcenter_region);
        //list_regions.addAll(map_regionPcenterDefinitions.keySet());
        for (String region : map_tempRegionPcenters.keySet()) {
            map_regionPcenters.put(region, new List<String>());
            map_regionPcenters.get(region).addAll(map_tempRegionPcenters.get(region));
        }
        //list_pcenters.addAll(set_pcenters);
    }
    
    public static List<Forecast_Definition__c> getChoosenDefinition(Map<String, Map<String, List<Forecast_Definition__c>>> map_regionPcenterDefinitions, String region, String pcenter, set<String> set_classification) {
        List<Forecast_Definition__c> list_fDefinition = new List<Forecast_Definition__c>();
        if(map_regionPcenterDefinitions.containsKey(region) && map_regionPcenterDefinitions.get(region).containsKey(pcenter)) {
            /**for (String pcenter : list_pcenters) {
                map_regionPcenterDefinitions.get(region).containsKey(pcenter);
                list_fDefinition.addAll(map_regionPcenterDefinitions.get(region).get(pcenter));
            }**/
            list_fDefinition.addAll(map_regionPcenterDefinitions.get(region).get(pcenter));
        }
        for(Forecast_Definition__c fd : list_fDefinition){
            if(fd.IND_Customer_Classification__c != null){
                set_classification.add(fd.IND_Customer_Classification__c);
            }
        }
        return list_fDefinition;
    }

    public static void getRSMDefinitionItemMap(List<Forecast_Definition__c> list_fDefinition, Map<String, List<CtrlRSMForecast.RSMDefinitionItem>> map_rSMDefinitionItems, Map<String, List<CtrlRSMForecast.RSMDefinitionItem>> map_totalItems, Map<String, Map<String, List<CtrlRSMForecast.RSMDefinitionItem>>> map_otherItems, map<String, String> map_classifications) {
        for (Forecast_Definition__c fDefinition : list_fDefinition) {
            CtrlRSMForecast.RSMDefinitionItem rSMItem = new CtrlRSMForecast.RSMDefinitionItem();
            rSMItem.id = fDefinition.Id;
            rSMItem.name = fDefinition.Name != null ? fDefinition.Name : '';
            rSMItem.category = fDefinition.Category__c != null ? fDefinition.Category__c : '';
            rSMItem.sequence = fDefinition.RSM_Se_quence__c != null ? fDefinition.RSM_Se_quence__c : 0;
            rSMItem.label = fDefinition.Category_Label__c != null ? fDefinition.Category_Label__c : '';   
            rSMItem.subtotal = fDefinition.Subtotal__c != null ? fDefinition.Subtotal__c : false;
            rSMItem.profitCenter = fDefinition.Profit_Center__c != null ? fDefinition.Profit_Center__c : '';           
            rSMItem.categoryInclude = fDefinition.RSM_Forecast_Category_Includes__c != null ? fDefinition.RSM_Forecast_Category_Includes__c : '';
            rSMItem.categoryExclude = fDefinition.RSM_Forecast_Category_Excludes__c != null ? fDefinition.RSM_Forecast_Category_Excludes__c : '';
            rSMItem.industrialSalesTeamInclude = fDefinition.Industrial_Sales_Team_Include__c != null ? fDefinition.Industrial_Sales_Team_Include__c : '';
            rSMItem.oldClassifications = fDefinition.IND_Customer_Classification__c;
            rSMItem.classifications = '';
            
            map<String, Decimal> map_mfc= new map<String, Decimal>();
            map<String, Decimal> map_prevMFC= new map<String, Decimal>();
            for(Manager_Forecast__c mf : fDefinition.Manager_Forecasts__r){
                if(mf.Forecast_USD__c != 0){
                    map_mfc.put(mf.Fiscal_Year__c + '-' + (Integer.valueOf(mf.Fiscal_Month__c)), mf.Forecast_USD__c);
                }
                if(mf.Previous_Month_Forecast_Document__c != null && mf.Previous_Month_Forecast_Document__c != 0 ){
                    map_prevMFC.put(mf.Fiscal_Year__c + '-' + (Integer.valueOf(mf.Fiscal_Month__c)), mf.Previous_Month_Forecast_Document__c);
                }
            }
            rSMItem.managerfc = Json.serialize(map_mfc);
            rSMItem.prevManagerFc = Json.serialize(map_prevMFC); //'{"2014-5":35000}';
            if(map_classifications.containsKey(rSMItem.oldClassifications)){
                //rSMItem.classifications = map_classifications.get(rSMItem.oldClassifications);
                rSMItem.classifications = rSMItem.oldClassifications;
            }
            
            
            if(rSMItem.subtotal == true) {
                if(!map_totalItems.containsKey(rSMItem.category)) {
                    map_totalItems.put(rSMItem.category, new List<CtrlRSMForecast.RSMDefinitionItem>());
                }
                map_totalItems.get(rSMItem.category).add(rSMItem); 
                continue;
            }
            else if(rSMItem.category != rSMItem.label) {
                if(!map_otherItems.containsKey(rSMItem.category)) {
                    map_otherItems.put(rSMItem.category, new Map<String, List<CtrlRSMForecast.RSMDefinitionItem>>());
                }
                if(!map_otherItems.get(rSMItem.category).containsKey(rSMItem.label)) {
                    map_otherItems.get(rSMItem.category).put(rSMItem.label, new List<CtrlRSMForecast.RSMDefinitionItem>());
                }
                map_otherItems.get(rSMItem.category).get(rSMItem.label).add(rSMItem);
                continue;
            }
            else {
                if(!map_rSMDefinitionItems.containsKey(fDefinition.Category__c)) {
                    map_rSMDefinitionItems.put(fDefinition.Category__c, new List<CtrlRSMForecast.RSMDefinitionItem>());
                }
                map_rSMDefinitionItems.get(fDefinition.Category__c).add(rSMItem);                  
            }    
        }
    }
    
    /**
    public static List<String> getCategory() {
        List<String> list_Category = new List<String>();
        
        Schema.DescribeFieldResult fieldResult = Forecast_Definition__c.Category__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            list_Category.add(f.getValue());
        }       
        return list_Category;
    }
    **/
    
    public static void setCurrent() {
        for (Period period : [select Id, FiscalYearSettings.Name, PeriodLabel from Period where StartDate<=Today and EndDate >=Today and Type = 'Month']) {
            if(period.FiscalYearSettings.Name != null){
                currentYear = period.FiscalYearSettings.Name;
            }
            if(period.PeriodLabel != null){
                currentMonth = ClsBudgetPlanBreakDownUtil.MAP_MONTHLABELNUMBER.get(period.PeriodLabel);
            }
        }
    }
    
    public static void setfinancialMonths() {
        date startDate = date.today();
        date endDate = date.today();
        map_financialMonth = new  Map<String, Set<Integer>>();
        
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
        
        for (Period period : [select Id, FiscalYearSettings.Name, PeriodLabel from Period where StartDate>= : startDate and EndDate<=: endDate and Type = 'Month']) {
            if(!map_financialMonth.containsKey(period.FiscalYearSettings.Name)) {
                map_financialMonth.put(period.FiscalYearSettings.Name, new Set<Integer>());
            }
            map_financialMonth.get(period.FiscalYearSettings.Name).add(ClsBudgetPlanBreakDownUtil.MAP_MONTHLABELNUMBER.get(period.PeriodLabel));
        }
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'map_financialMonth ::' + map_financialMonth));
    }
    
    public static void setCurrentMonthIndex() {     
        list_yearMonth = new List<String>();
        list<String> list_years = new list<String>();
        list_years.addAll(map_financialMonth.keySet());
        list_years.sort();
        
        for (String year : list_years) {
            list<Integer> list_months = new list<Integer>();
            list_months.addAll(map_financialMonth.get(year));
            list_months.sort();
            
            for (Integer month : list_months) {
                list_yearMonth.add(year + ';' + month);
                if(currentYear == year && currentMonth == month) {
                    currentMonthIndex = list_yearMonth.size();
                }
            }
        }
    }
   /**
    * This method is used to set date key by using gaven month map
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
    public static void setDateKey(map<String, set<Integer>> map_financialMonthDate, set<String> set_dateKey) {
        if(map_financialMonth == null || map_financialMonth.isEmpty()) {
            setfinancialMonths();
        }
        for(String year : map_financialMonth.keySet()) {
            for(Integer month : map_financialMonth.get(year)) {
                String dateKey = year + '_' + month;
                set_dateKey.add(dateKey);
            }
        }
    }
    public Static void createWorkingDaysMap(String region) {
        map_workingDays = new Map<String, Decimal>();
        String query = 'Select Id, Days__c, Fiscal_Year__c, Fiscal_Month__c From Effective_Working_Days__c Where ( ';
        for (Integer i = currentMonthIndex - 4; i <= currentMonthIndex + 2; i++) {
            if(list_yearMonth.get(i) != null) {
                String ymStr = list_yearMonth.get(i);
                map_workingDays.put(ymStr, 0);
                query += '(Fiscal_Year__c = \'' + ymStr.substring(0, ymStr.indexOf(';')) + '\' And Fiscal_Month__c = ' + ymStr.substring(ymStr.indexOf(';') + 1) + ') Or ';
            }
        }
        query = query.substring(0, query.lastIndexOf('Or'));
        query += ' ) ';
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'query:' + query + ' Region   ' + region));
        for (Effective_Working_Days__c workingDays : database.query(query)) {
            map_workingDays.put((workingDays.Fiscal_Year__c + ';' + workingDays.Fiscal_Month__c), workingDays.Days__c);
        }
    }

    public static void createDateItem(List<CtrlRSMForecast.DateItem> list_dateItems, Map<String, List<CtrlRSMForecast.DateItem>> map_dateItems, List<CtrlRSMForecast.DateItem> list_allDateItems, String region) {                 
        String str_monthLabel = '';
        String str_qLabel = '';
        String str_yearLabel = '';
        Integer monthCounter = 0;
        setCurrent();
        setfinancialMonths();
        setCurrentMonthIndex();
        createWorkingDaysMap(region);

        CtrlRSMForecast.DateItem tempDateItem;
        List<CtrlRSMForecast.DateItem> list_tempDateItem;
        for (Integer i = 1; i < = 27; i++) {
            if (i == 1) {
                tempDateItem = new CtrlRSMForecast.DateItem('Historical Data');
                tempDateItem.type = 'historicalc';
                //tempDateItem.type1 = '<th class="trh historicalc tc" colspan="' + (ClsRSMForecastUtil.currentMonthIndex + 1) + '">Historical Data</th>';
                //tempDateItem.type1 = '<th class="trh historicalc tc" colspan="'+(ClsRSMForecastUtil.currentMonthIndex + 1)+'" style="height: 0px !important;"><div class="fix_lh historicalc">Historical Data</div></th>';
                
                list_dateItems.add(tempDateItem);
                
                list_tempDateItem = new List<CtrlRSMForecast.DateItem>();
                map_dateItems.put('Historical Data', list_tempDateItem);
            }
            else if (i == 7) {
                tempDateItem = new CtrlRSMForecast.DateItem('Current Month');
                tempDateItem.cls = 'none';
                tempDateItem.type = 'currentc cfixw';
                //tempDateItem.type1 = '<th class="trh currentc tc"> </th>';
                //tempDateItem.type1 = '<th class="trh currentc tc " colspan="' + ( Math.mod(currentMonthIndex, 3) == 0 ? 2 : 1) + '" style="height: 0px !important;"><div class="fix_lh currentc"> </div></th>';
                tempDateItem.type1 = '<th class="fixthh th_historicalc tc" old="'+currentMonthIndex+'" colspan="'+(currentMonthIndex + 1 + ( Math.mod(currentMonthIndex, 3) == 0 ? 2 : 1))+'" ><div class="fix_lh head_historicalc"><div class="absdiv">' + system.label.RSM_HistoricalData + '</div></div></th>';
                list_dateItems.add(tempDateItem);
                
                list_tempDateItem = new List<CtrlRSMForecast.DateItem>();
                map_dateItems.put('Current Month', list_tempDateItem);
            }
            else if (i == 10){
                tempDateItem = new CtrlRSMForecast.DateItem('Future Plan');
                tempDateItem.cls = 'none';
                tempDateItem.type = 'futurec';
                //tempDateItem.type1 = '<th class="trh futurec tc" colspan="' + (18 - ClsRSMForecastUtil.currentMonthIndex) + '"><div>Future Plan</div></th>';
                //tempDateItem.type1 = '<th class="trh futurec tc" colspan="'+(18 - ClsRSMForecastUtil.currentMonthIndex)+'" style="height: 0px !important;"><div class="fix_lh futurec">Future Plan</div></th>';
                tempDateItem.type1 = '<th class="fixthh th_futurec tc" colspan="999" ><div class="fix_lh head_futurec">' + system.label.RSM_FuturePlan + '</div></th>';
                list_dateItems.add(tempDateItem);
                
                list_tempDateItem = new List<CtrlRSMForecast.DateItem>();
                map_dateItems.put('Future Plan', list_tempDateItem);
            }                
            
            CtrlRSMForecast.DateItem tempMonthItem = new CtrlRSMForecast.DateItem('');
            tempMonthItem.type2 = 'cfixmonthw';
            tempMonthItem.type3 = 'totalbg';
            monthCounter = (i - ClsRSMForecastUtil.currentMonthIndex);
            str_yearLabel = currentYear;
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, ' monthCounter + currentMonth :: ' + (monthCounter + currentMonth)));
            if(monthCounter + currentMonth <= 0) {
                monthCounter += 12;
                str_yearLabel = String.valueOf(integer.valueOf(str_yearLabel) - 1);
            }
            else if((monthCounter + currentMonth) > 12 && (monthCounter + currentMonth) <= 24) {
                monthCounter -= 12;
                str_yearLabel = String.valueOf(integer.valueOf(str_yearLabel) + 1);
            }else if((monthCounter + currentMonth) >= 24) {
                monthCounter -= 24;
                str_yearLabel = String.valueOf(integer.valueOf(str_yearLabel) + 2);
            }
            monthCounter += currentMonth;
            str_yearLabel = str_yearLabel.subString(2);
            str_monthLabel = MAP_NUMBERMONTHLABEL.get(monthCounter);
            tempMonthItem.itemName = str_monthLabel + ' / ' + str_yearLabel;
            
            if (i < ClsRSMForecastUtil.currentMonthIndex) {
                Integer t = (i - ClsRSMForecastUtil.currentMonthIndex);
                //tempMonthItem.itemName = 'CM' + t; 
                tempMonthItem.type = ('historicalc ' + (tempDateItem.type == 'currentc cfixw' ? 'currentc' : tempDateItem.type) + '1 cfixmonthw');
                if(t == -1 || t == -2 || t == -3){
                    tempMonthItem.type += ' cm'+t+' ';
                }
            }
            else if (i == ClsRSMForecastUtil.currentMonthIndex) {
                //tempMonthItem.itemName = 'Current Month';
                tempMonthItem.isInput = false;
                tempMonthItem.type = ('currentc ' + (tempDateItem.type == 'currentc cfixw' ? 'currentc' : tempDateItem.type) + '1 ' + 'cfixw');
                tempMonthItem.type1 = 'current_fixcls';
                tempMonthItem.type2 = 'cfixcurentmonthw';
            }
            else {
                Integer t = 0;
                if (i == ClsRSMForecastUtil.currentMonthIndex + 1) {
                    //tempMonthItem.itemName = 'NM';
                    t = 0;
                }
                else {
                    //tempMonthItem.itemName = 'NM+' + (i - ClsRSMForecastUtil.currentMonthIndex - 1);   
                    t = (i - ClsRSMForecastUtil.currentMonthIndex - 1);        
                }
                tempMonthItem.isInput = true;
                tempMonthItem.type = ('futurec ' + (tempDateItem.type == 'currentc cfixw' ? 'currentc' : tempDateItem.type) + '1 cfixmonthw');
                if(t == 0 || t == 1 || t == 2){
                    tempMonthItem.type += ' _cnm'+t+' ';
                }
            }    
            String ymStr = list_yearMonth.get(i - 1);
            tempMonthItem.fYear = ymStr.subString(0, ymStr.indexOf(';'));
            tempMonthItem.fMonth = Integer.valueOf(ymStr.subString(ymStr.indexOf(';') + 1));
            if(map_workingDays.get(ymStr) != null) {
                tempMonthItem.workingDays = map_workingDays.get(ymStr);
            }
            list_tempDateItem.add(tempMonthItem); 
            list_allDateItems.add(tempMonthItem); 
            if (Math.mod(i, 3) == 0) {
                if(monthCounter == 3) {
                    str_qLabel = 'Q1' + ' / ' + str_yearLabel;
                }
                else if(monthCounter == 6) {
                    str_qLabel = 'Q2' + ' / ' + str_yearLabel;
                }
                else if(monthCounter == 9) {
                    str_qLabel = 'Q3' + ' / ' + str_yearLabel;
                }
                else if(monthCounter == 12) {
                    str_qLabel = 'Q4' + ' / ' + str_yearLabel;
                }
                
                CtrlRSMForecast.DateItem tempTotalItem = new CtrlRSMForecast.DateItem(str_qLabel);
                //CtrlRSMForecast.DateItem tempTotalItem = new CtrlRSMForecast.DateItem('Q Total');
                tempTotalItem.total = 'q' + i / 3;
                if (i < ClsRSMForecastUtil.currentMonthIndex) {
                    tempTotalItem.type = ('historicalc ' + (tempDateItem.type == 'currentc cfixw' ? 'currentc' : tempDateItem.type) + '1');
                }
                else {
                    tempTotalItem.type = ('futurec ' + (tempDateItem.type == 'currentc cfixw' ? 'currentc' : tempDateItem.type) + '1');
                }       
                tempTotalItem.type += ' cfixqtotalw';
                tempTotalItem.type2 = 'cfixqtotalw';
                list_tempDateItem.add(tempTotalItem);
                list_allDateItems.add(tempTotalItem); 
            }
        }        
    }
    /*
    public static String getQueryStrForBBBM(String region, String pcenter, Map<String, Set<Integer>> map_Month){
        String query =' Select sum(Bill_Amount_USD__c) Billings, sum(Book_Amount_USD__c) Book2Bill, ';
        query += ' sum(forecast__c) Forecasts, sum(Backlog_0__c) Backlog0,  sum(Currency_1_USD__c) Currency1, ';
        query += ' sum(Currency_2_USD__c) Currency2, sum(Currency_3_USD__c) Currency3, sum(Currency_4_USD__c) Currency4, ';
        query += ' sum(Forecast_2_Months_Document__c) month2Forecast, sum(Forecast_6_Months_Document__c) month6Forecast, ';
        query += ' sum(Forecast_Begin_of_Quarter_Document__c) beginQuarterForecast, sum(Previous_Month_Forecast_Document__c) PreviousForecast, ';
        query += ' Fiscal_date__c, Customer__r.IND_RSM_Forecast_Category__c Category, ';
        query += ' Customer__r.Sales_Hierarchy__r.Level_2_Territory_Code__c SalesTeam ';
        query += ' From BBB_Month_Bill_Book_Cust__c Where Bill_Type__c = \'Direct\'';
        
        if(region != null && region != '') {
            query += ' And Customer__r.IND_Billing_Region__c = \'' + region + '\'';
        }
        if(pcenter != null && pcenter != '') {
            query += ' And IND_Profit_Centre_Groups__c = \'' + pcenter + '\'';
        }
        String monthFilter = CtrlAccountForecastUtil.buildMonthFilter(map_Month);      
        if(monthFilter != '') {
            query += ' And ' + monthFilter;
        }        
        query += ' Group By Fiscal_date__c, Customer__r.IND_RSM_Forecast_Category__c, ';
        query += ' Customer__r.Sales_Hierarchy__r.Level_2_Territory_Code__c';
        return query;
    }
    */
    
    /**
    * This method get BBB_Month_Bill_Book_Cust__c sql
    *
    @author Minghao Li
    @created 2013-11-29
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    @param year         region string
    @param ownerId      map_Month Map<String, Set<Integer>>
    @param filter       filter string
    *
    @return             the bbb sql
    *
    @changelog
    * 2013-11-29 Minghao Li <minghao.li@itbconsult.com>
    * - Created
    */
    public static String getQueryStrForBBBM(String dateKey, String region, String pcenter){
        String year = dateKey.substringBefore('_');
        Integer month = Integer.valueOf(dateKey.substringAfter('_'));
        
        
        String query =' Select sum(Bill_Amount_USD__c) Billings, sum(Book_Amount_USD__c) Book2Bill, sum(Demand_Shipped__c) DemandShipped, sum(Demand_Open__c) DemandOpen,';
        query += ' sum(forecast__c) Forecasts, sum(Backlog_0__c) Backlog0,  sum(Currency_1_USD__c) Currency1, ';
        query += ' sum(Currency_2_USD__c) Currency2, sum(Currency_3_USD__c) Currency3, sum(Currency_4_USD__c) Currency4, ';
        query += ' sum(Forecast_2_Months_Document__c) month2Forecast, sum(Forecast_6_Months_Document__c) month6Forecast, ';
        query += ' sum(Forecast_Begin_of_Quarter_Document__c) beginQuarterForecast,  ';  //sum(Previous_Month_Forecast_Document__c) PreviousForecast,
        query += ' Customer__r.IND_RSM_Forecast_Category__c Category, Customer__r.IND_Customer_Classification__c classification, ';
        query += ' Customer__r.Sales_Hierarchy__r.Level_2_Territory_Code__c SalesTeam ';
        query += ' From BBB_Month_Bill_Book_Cust__c Where Bill_Type__c = \'Direct\'';
        //query += ' And Customer__r.IND_Customer_Classification__c = \''+filter+'\'';
        
        if(region != null && region != '') {
            query += ' And Customer__r.IND_Billing_Region__c = \'' + region + '\'';
        }
        if(pcenter != null && pcenter != '') {
            query += ' And IND_Profit_Centre_Groups__c = \'' + pcenter + '\'';
        }
        query += ' And Fiscal_Year__c = \''+year+'\' ';
        query += ' And Fiscal_Month__c = '+month+' ';        
        query += ' Group By Customer__r.IND_Customer_Classification__c, Customer__r.IND_RSM_Forecast_Category__c, ';
        query += ' Customer__r.Sales_Hierarchy__r.Level_2_Territory_Code__c';
        
        return query;
            
        
    }
    /**
    * This method get ScheduledAgreements sql
    *
    @author Minghao Li
    @created 2013-11-29
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    @param year         region string
    @param ownerId      map_Month Map<String, Set<Integer>>
    @param filter       filter string
    *
    @return             the ScheduledAgreements sql
    *
    @changelog
    * 2013-11-29 Minghao Li <minghao.li@itbconsult.com>
    * - Created
    */        
    public static String getQueryStrForScheduledAgreements(String dateKey, String region){
        String year = dateKey.substringBefore('_');
        Integer month = Integer.valueOf(dateKey.substringAfter('_'));
        
        String query =' Select sum(Forecast_Amount_USD__c) forecast, ';
        query += ' Sold_To_Customer__r.IND_RSM_Forecast_Category__c Category, ';
        query += ' Sold_To_Customer__r.Sales_Hierarchy__r.Level_2_Territory_Code__c SalesTeam, Sold_To_Customer__r.IND_Customer_Classification__c classification ';
        query += ' From Scheduled_Agreements__c Where Forecast_Amount_USD__c > 0';
        //query += ' And Sold_To_Customer__r.IND_Customer_Classification__c = \''+filter+'\'';
        
        if(region != null && region != '') {
            query += ' And Sold_To_Customer__r.IND_Billing_Region__c = \'' + region + '\'';
        }
        query += ' And Fiscal_Year__c = \''+year+'\' ';
        query += ' And Fiscal_Month_Text__c = \''+month+'\' ';
        query += ' Group By Sold_To_Customer__r.IND_RSM_Forecast_Category__c, ';
        query += 'Sold_To_Customer__r.Sales_Hierarchy__r.Level_2_Territory_Code__c, Sold_To_Customer__r.IND_Customer_Classification__c ';          
        
        return query;            
        
    } 
    
    /**
    * This method get BBB_Month_Bill_Book_Cust__c sql
    *
    @author Minghao Li
    @created 2013-11-29
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    @param year         region string
    @param ownerId      map_Month Map<String, Set<Integer>>
    @param filter       filter string
    *
    @return             the bbb sql
    *
    @changelog
    * 2013-11-29 Minghao Li <minghao.li@itbconsult.com>
    * - Created
    
    public static String getQueryStrForBBBM(String region, String pcenter, Map<String, Set<Integer>> map_Month, String filter){
        String query =' Select sum(Bill_Amount_USD__c) Billings, sum(Book_Amount_USD__c) Book2Bill, ';
        query += ' sum(forecast__c) Forecasts, sum(Backlog_0__c) Backlog0,  sum(Currency_1_USD__c) Currency1, ';
        query += ' sum(Currency_2_USD__c) Currency2, sum(Currency_3_USD__c) Currency3, sum(Currency_4_USD__c) Currency4, ';
        query += ' sum(Forecast_2_Months_Document__c) month2Forecast, sum(Forecast_6_Months_Document__c) month6Forecast, ';
        query += ' sum(Forecast_Begin_of_Quarter_Document__c) beginQuarterForecast,  ';  //sum(Previous_Month_Forecast_Document__c) PreviousForecast,
        query += ' Fiscal_date__c, Customer__r.IND_RSM_Forecast_Category__c Category, ';
        query += ' Customer__r.Sales_Hierarchy__r.Level_2_Territory_Code__c SalesTeam ';
        query += ' From BBB_Month_Bill_Book_Cust__c Where Bill_Type__c = \'Direct\'';
        query += ' And Customer__r.IND_Customer_Classification__c = \''+filter+'\'';
        
        if(region != null && region != '') {
            query += ' And Customer__r.IND_Billing_Region__c = \'' + region + '\'';
        }
        if(pcenter != null && pcenter != '') {
            query += ' And IND_Profit_Centre_Groups__c = \'' + pcenter + '\'';
        }
        String monthFilter = CtrlAccountForecastUtil.buildMonthFilter(map_Month);      
        if(monthFilter != '') {
            query += ' And ' + monthFilter;
        }        
        query += ' Group By Fiscal_date__c, Customer__r.IND_RSM_Forecast_Category__c, ';
        query += ' Customer__r.Sales_Hierarchy__r.Level_2_Territory_Code__c';
        return query;
    }
    */
    /*
    public static String getQueryStrForScheduledAgreements(String region, Map<String, Set<Integer>> map_Month){
        String query =' Select sum(Forecast_Amount_USD__c) forecast, Fiscal_Year__c, Fiscal_Month_Text__c, ';
        query += ' Sold_To_Customer__r.IND_RSM_Forecast_Category__c Category, ';
        query += ' Sold_To_Customer__r.Sales_Hierarchy__r.Level_2_Territory_Code__c SalesTeam ';
        query += ' From Scheduled_Agreements__c Where Forecast_Amount_USD__c > 0';
        if(region != null && region != '') {
            query += ' And Sold_To_Customer__r.IND_Billing_Region__c = \'' + region + '\'';
        }
        String monthFilter = CtrlAccountForecastUtil.buildMonthFilter(map_Month);      
        if(monthFilter != '') {
            query += ' And ' + monthFilter;
        }
        query += ' Group By Fiscal_Year__c, Fiscal_Month_Text__c, Sold_To_Customer__r.IND_RSM_Forecast_Category__c, ';
        query += 'Sold_To_Customer__r.Sales_Hierarchy__r.Level_2_Territory_Code__c';
        
        return query;
    }
    */
    /**
    * This method get ScheduledAgreements sql
    *
    @author Minghao Li
    @created 2013-11-29
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    @param year         region string
    @param ownerId      map_Month Map<String, Set<Integer>>
    @param filter       filter string
    *
    @return             the ScheduledAgreements sql
    *
    @changelog
    * 2013-11-29 Minghao Li <minghao.li@itbconsult.com>
    * - Created
            
    public static String getQueryStrForScheduledAgreements(String region, Map<String, Set<Integer>> map_Month, String filter){
        String query =' Select sum(Forecast_Amount_USD__c) forecast, Fiscal_Year__c, Fiscal_Month_Text__c, ';
        query += ' Sold_To_Customer__r.IND_RSM_Forecast_Category__c Category, ';
        query += ' Sold_To_Customer__r.Sales_Hierarchy__r.Level_2_Territory_Code__c SalesTeam ';
        query += ' From Scheduled_Agreements__c Where Forecast_Amount_USD__c > 0';
        query += ' And Sold_To_Customer__r.IND_Customer_Classification__c = \''+filter+'\'';
        
        if(region != null && region != '') {
            query += ' And Sold_To_Customer__r.IND_Billing_Region__c = \'' + region + '\'';
        }
        String monthFilter = CtrlAccountForecastUtil.buildMonthFilter(map_Month);      
        if(monthFilter != '') {
            query += ' And ' + monthFilter;
        }
        query += ' Group By Fiscal_Year__c, Fiscal_Month_Text__c, Sold_To_Customer__r.IND_RSM_Forecast_Category__c, ';
        query += 'Sold_To_Customer__r.Sales_Hierarchy__r.Level_2_Territory_Code__c';
        
        return query;
    }        
    */
    public static void saveRSMForecast(List<CtrlRSMForecast.RSMForecastItem> list_rsm) {
        List<Manager_Forecast__c> list_mForecast2uperst = new List<Manager_Forecast__c>();
        Set<String> set_definitions = new Set<String>();
        Set<Date> set_fdates = new Set<date>();
        Map<String, Map<Date, Manager_Forecast__c>> map_definition_date_Forecasts = new Map<String, Map<Date, Manager_Forecast__c>>();
        
        for (CtrlRSMForecast.RSMForecastItem rsmItem : list_rsm) {
            Manager_Forecast__c mForecast = new Manager_Forecast__c();
            mForecast.Billings_USD__c = rsmItem.billings;
            mForecast.Bookings_USD__c = rsmItem.bookings;
            mForecast.AM_Forecast_USD__c = rsmItem.asmForecast;
            mForecast.Forecast_USD__c = rsmItem.rsmForecast;
            mForecast.Forecast_Definition__c = rsmItem.definition;
            //mForecast.Fiscal_Date__c = rsmItem.fiscalDate;
            mForecast.Fiscal_Year__c = rsmItem.fiscalDate.subString(0, rsmItem.fiscalDate.indexOf('-'));
            mForecast.Fiscal_Month__c = Integer.valueOf(rsmItem.fiscalDate.subString(rsmItem.fiscalDate.indexOf('-') + 1));

            if(rsmItem.definition != null && !map_definition_date_Forecasts.containsKey(rsmItem.definition)) {
                map_definition_date_Forecasts.put(rsmItem.definition, new Map<Date, Manager_Forecast__c>());
            }
            if(rsmItem.fiscalDate != null) {
                Date fDate =  date.newinstance(Integer.valueOf(rsmItem.fiscalDate.subString(0, rsmItem.fiscalDate.indexOf('-'))), Integer.valueOf(rsmItem.fiscalDate.subString(rsmItem.fiscalDate.indexOf('-') + 1)), 15);
                
                if(!map_definition_date_Forecasts.get(rsmItem.definition).containsKey(fDate)) {
                    map_definition_date_Forecasts.get(rsmItem.definition).put(fDate, mForecast);
                }
                if(!set_fdates.contains(fDate)) {
                    set_fdates.add(fDate);
                }
            }
        }
        set_definitions = map_definition_date_Forecasts.keySet();
        
        for (Manager_Forecast__c mForecast : [Select Id, Billings_USD__c, Bookings_USD__c, AM_Forecast_USD__c, Forecast_USD__c, Forecast_Definition__c, Fiscal_Date__c, Fiscal_Year__c, Fiscal_Month__c From Manager_Forecast__c Where Forecast_Definition__c in: set_definitions And Fiscal_Date__c in: set_fdates]) {
            if(mForecast != null) {
                if(mForecast.Forecast_Definition__c != null && !map_definition_date_Forecasts.containsKey(mForecast.Forecast_Definition__c)) {
                    map_definition_date_Forecasts.put(mForecast.Forecast_Definition__c, new Map<Date, Manager_Forecast__c>());
                }
                if(mForecast.Fiscal_Date__c != null && !map_definition_date_Forecasts.get(mForecast.Forecast_Definition__c).containsKey(mForecast.Fiscal_Date__c)) {
                    map_definition_date_Forecasts.get(mForecast.Forecast_Definition__c).put(mForecast.Fiscal_Date__c, mForecast);
                }
                else {
                    mForecast.Billings_USD__c = map_definition_date_Forecasts.get(mForecast.Forecast_Definition__c).get(mForecast.Fiscal_Date__c).Billings_USD__c;
                    mForecast.Bookings_USD__c = map_definition_date_Forecasts.get(mForecast.Forecast_Definition__c).get(mForecast.Fiscal_Date__c).Bookings_USD__c;
                    mForecast.AM_Forecast_USD__c = map_definition_date_Forecasts.get(mForecast.Forecast_Definition__c).get(mForecast.Fiscal_Date__c).AM_Forecast_USD__c;
                    mForecast.Forecast_USD__c = map_definition_date_Forecasts.get(mForecast.Forecast_Definition__c).get(mForecast.Fiscal_Date__c).Forecast_USD__c;
                    
                    map_definition_date_Forecasts.get(mForecast.Forecast_Definition__c).put(mForecast.Fiscal_Date__c, mForecast);
                }
            }
        }
        
        for (String definition : map_definition_date_Forecasts.keySet()) {
            for (Date fDate : map_definition_date_Forecasts.get(definition).keySet()) {
                list_mForecast2uperst.add(map_definition_date_Forecasts.get(definition).get(fDate));
            }
        }
        
        if(list_mForecast2uperst != null && list_mForecast2uperst.size() > 0) {
            upsert list_mForecast2uperst;
        }
    }
    
    public static Boolean checkFrozenDate() {
        Boolean editable = true;
        Date startDate = Date.newInstance(Integer.valueOf(currentYear), currentMonth, 15);
        String query = ' Select Max(Last_Frozen_Month_Date__c) frozenDate From Manager_Forecast__c ';
        query += ' Where  Fiscal_Date__c >=: startDate and Last_Frozen_Month_Date__c != null';
        for(AggregateResult forecast : Database.query(query)) {
            if(forecast.get('frozenDate') != null && Date.today() <= (Date) forecast.get('frozenDate')) {
                editable = false;
            }
        }
        return editable;
    }
    
    public static List<AggregateResult> getAccountManagers(String userId, String viewType, set<String> set_re, set<String> set_pc) {
        set_region = new Set<String>();
        set_pcenter = new Set<String>();
        for (Forecast_Definition__c fDefinition : [Select Region__c, Profit_Center__c From Forecast_Definition__c where RSM__c = : userId]) {
            if(!set_region.contains(fDefinition.Region__c)) {
                set_region.add(fDefinition.Region__c);
                set_re.add(fDefinition.Region__c);
            }
            if(!set_pcenter.contains(fDefinition.Profit_Center__c)) {
                set_pcenter.add(fDefinition.Profit_Center__c);
                set_pc.add(fDefinition.Profit_Center__c);
            }
        }
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'userId ::' + userId));
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'set_pcenter ::' + set_pcenter));
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'set_region ::' + set_region));
        if(viewType == 'ProfitCenterView') {
            return [Select Account_Manager__c aId, Account_Manager__r.Name aName From Account where IND_Billing_Region__c in: set_region and My_Territory_Code__c = 'true' and Customer_Industry__c in: set_pcenter Group by Account_Manager__c, Account_Manager__r.Name];
        }
        else {
            return [Select Account_Manager__c aId, Account_Manager__r.Name aName From Account where IND_Billing_Region__c in: set_region and My_Territory_Code__c = 'true' Group by Account_Manager__c, Account_Manager__r.Name];
        }
        
    }
    
    public static String getChangeScreenBBBMQuery(String viewType){
        String query =' Select sum(Bill_Amount_USD__c) Billings, sum(Book_Amount_USD__c) Book2Bill, sum(Demand_Shipped__c) DemandShipped, sum(Demand_Open__c) DemandOpen,';
        query += ' sum(forecast__c) Forecasts, sum(Currency_1_USD__c) Currency1, sum(Budget__c) Budgets, ';
        query += ' sum(Currency_2_USD__c) Currency2, sum(Currency_3_USD__c) Currency3, sum(Currency_4_USD__c) Currency4, ';
        query += ' sum(Forecast_2_Months_Document__c) month2Forecast, sum(Forecast_6_Months_Document__c) month6Forecast, ';
        query += ' sum(Forecast_Begin_of_Quarter_Document__c) beginQuarterForecast, sum(Previous_Month_Forecast_Document__c) PreviousForecast, ';
        query += ' sum(Backlog_0__c) Backlog0, sum(Backlog_1__c) Backlog1, sum(Backlog_2__c) Backlog2, sum(Backlog_3__c) Backlog3, ';
        query += ' Fiscal_date__c';
        if(viewType != 'other') {
            query += ', Customer__r.Account_Manager__c';
        }
        query += ' From BBB_Month_Bill_Book_Cust__c Where Bill_Type__c = \'Direct\'';
        
        if(set_region != null && set_region.size() > 0) {
            query += ' And Customer__r.IND_Billing_Region__c In (';
            for (String region : set_region) {
                query += '\'' + region + '\', ';
            }
            query = query.substring(0, query.lastIndexOf(',')) + ')';
        }
        if(map_financialMonth == null || map_financialMonth.isEmpty()) {
            setfinancialMonths();
        }
        String monthFilter = CtrlAccountForecastUtil.buildMonthFilter(map_financialMonth);      
        if(monthFilter != '') {
            query += ' And ' + monthFilter;
        } 
        
        if(viewType == 'other') {
            query += ' And Customer__r.My_Hierarchy_Code__c = \'false\'';
        }
        else {
            query += ' And Customer__r.My_Hierarchy_Code__c = \'true\'';
        }
        
        if((viewType == 'ProfitCenterView' || viewType == 'other') && set_pcenter != null && set_pcenter.size() > 0) {
            query += ' And IND_Profit_Centre_Groups__c In (';
            for (String pcenter : set_pcenter) {
                query += '\'' + pcenter + '\', ';
            }
            query = query.substring(0, query.lastIndexOf(',')) + ')';
        }
      
        query += ' Group By Fiscal_date__c';
        if(viewType != 'other') {
            query += ', Customer__r.Account_Manager__c';
        }
        return query;
    } 
    public static void getChangeScreenBBBMQuery(String viewType, set<String> set_dateKey, map<String, String> map_fiscalDate_bbbMQuery) {
        for(String dateKey : set_dateKey) {
            String year = dateKey.substringBefore('_');
            Integer month = Integer.valueOf(dateKey.substringAfter('_'));
            String map_key = 'bbb@' + dateKey;
        
            String query =' Select sum(Bill_Amount_USD__c) Billings, sum(Book_Amount_USD__c) Book2Bill, sum(Demand_Shipped__c) DemandShipped, sum(Demand_Open__c) DemandOpen,';
            query += ' sum(forecast__c) Forecasts, sum(Currency_1_USD__c) Currency1, sum(Budget__c) Budgets, ';
            query += ' sum(Currency_2_USD__c) Currency2, sum(Currency_3_USD__c) Currency3, sum(Currency_4_USD__c) Currency4, ';
            query += ' sum(Forecast_2_Months_Document__c) month2Forecast, sum(Forecast_6_Months_Document__c) month6Forecast, ';
            query += ' sum(Forecast_Begin_of_Quarter_Document__c) beginQuarterForecast, sum(Previous_Month_Forecast_Document__c) PreviousForecast, ';
            query += ' sum(Backlog_0__c) Backlog0, sum(Backlog_1__c) Backlog1, sum(Backlog_2__c) Backlog2, sum(Backlog_3__c) Backlog3 ';
            if(viewType != 'other') {
                query += ', Customer__r.Account_Manager__c';
            }
            query += ' From BBB_Month_Bill_Book_Cust__c Where Bill_Type__c = \'Direct\'';
            if(set_region != null && set_region.size() > 0) {
                query += ' And Customer__r.IND_Billing_Region__c In (';
                for (String region : set_region) {
                    query += '\'' + region + '\', ';
                }
                query = query.substring(0, query.lastIndexOf(',')) + ')';
            }

            query += ' And Fiscal_Year__c = \''+year+'\' ';
            query += ' And Fiscal_Month__c = '+month+' ';
                        
            if(viewType == 'other') {
                query += ' And Customer__r.My_Hierarchy_Code__c = \'false\'';
            }
            else {
                query += ' And Customer__r.My_Hierarchy_Code__c = \'true\'';
            }
            
            if((viewType == 'ProfitCenterView' || viewType == 'other') && set_pcenter != null && set_pcenter.size() > 0) {
                query += ' And IND_Profit_Centre_Groups__c In (';
                for (String pcenter : set_pcenter) {
                    query += '\'' + pcenter + '\', ';
                }
                query = query.substring(0, query.lastIndexOf(',')) + ')';
            }
          
            if(viewType != 'other') {
                query += ' Group By Customer__r.Account_Manager__c';
            }
            
            map_fiscalDate_bbbMQuery.put(map_key, query);
        }
    } 
    
    public static String getQueryStrForScheduledAgreements(String viewType){
        String query =' Select sum(Forecast_Amount_USD__c) forecast, Fiscal_Year__c, Fiscal_Month_Text__c, Sold_To_Customer__r.Account_Manager__c ';
        query += ' From Scheduled_Agreements__c Where Forecast_Amount_USD__c > 0';
        if(set_region != null && set_region.size() > 0) {
            query += ' And Sold_To_Customer__r.IND_Billing_Region__c In (';
            for (String region : set_region) {
                query += '\'' + region + '\', ';
            }
            query = query.substring(0, query.lastIndexOf(',')) + ')';
        }
        if(map_financialMonth == null || map_financialMonth.isEmpty()) {
            setfinancialMonths();
        }
        String monthFilter = CtrlAccountForecastUtil.buildMonthFilter(map_financialMonth);      
        if(monthFilter != '') {
            query += ' And ' + monthFilter;
        }
        
        if(viewType == 'other') {
            query += ' And Sold_To_Customer__r.My_Hierarchy_Code__c = \'false\'';
        }
        else {
            query += ' And Sold_To_Customer__r.My_Hierarchy_Code__c = \'true\'';
        }
        
        query += ' Group By Fiscal_Year__c, Fiscal_Month_Text__c, Sold_To_Customer__r.Account_Manager__c';   
        return query;
    }
    
    public static void getQueryStrForScheduledAgreements(String viewType, set<String> set_dateKey, map<String, String> map_fiscalDate_scheduledQuery) {
        for(String dateKey : set_dateKey) {
            String year = dateKey.substringBefore('_');
            Integer month = Integer.valueOf(dateKey.substringAfter('_'));
            String map_key = 'sch@' + dateKey;
            
            
            String query =' Select sum(Forecast_Amount_USD__c) forecast, Sold_To_Customer__r.Account_Manager__c ';
            query += ' From Scheduled_Agreements__c Where Forecast_Amount_USD__c > 0';
            if(set_region != null && set_region.size() > 0) {
                query += ' And Sold_To_Customer__r.IND_Billing_Region__c In (';
                for (String region : set_region) {
                    query += '\'' + region + '\', ';
                }
                query = query.substring(0, query.lastIndexOf(',')) + ')';
            }
            
            query += ' And Fiscal_Year__c = \''+year+'\' ';
            query += ' And Fiscal_Month__c = '+month+' ';
            
            if(viewType == 'other') {
                query += ' And Sold_To_Customer__r.My_Hierarchy_Code__c = \'false\'';
            }
            else {
                query += ' And Sold_To_Customer__r.My_Hierarchy_Code__c = \'true\'';
            }
            
            query += ' Group By Sold_To_Customer__r.Account_Manager__c';   
            
            map_fiscalDate_scheduledQuery.put(map_key, query);
        }
    }

    public static void getComments(String acctId, String year, Integer month, ClsForecastComments forecastComments, set<String> set_re, set<String> set_pc) {
        set<String> set_acctIds = new set<String>();
        if(acctId == 'OTHER') {
            for(Account acct : [Select Id, Name From Account where IND_Billing_Region__c in: set_re and My_Hierarchy_Code__c = 'false' and Customer_Industry__c in: set_pc]) {
                set_acctIds.add(acct.Id);
            } 
        }
        else {
            set_acctIds.add(acctId);
        }
        set<String> set_acctIdsTemp = new set<String>();
        for(BBB_Month_Bill_Book_Cust__c bbb : [Select Id, Comment__c, Fiscal_Year__c, Fiscal_Month__c, forecast__c, Customer__c, Customer__r.Name, SAP_Profit_Center_Short_Description__c
                                               From BBB_Month_Bill_Book_Cust__c
                                               Where Customer__r.Account_Manager__c IN : set_acctIds 
                                               and Bill_Type__c = 'Direct' 
                                               //and SAP_Profit_Center_Short_Description__c != null
                                               and Customer__r.IND_Billing_Region__c in: set_re
                                               and Customer__r.Customer_Industry__c in: set_pc
                                               and Monthly_BBB_External_Key__c = null 
                                               and Is_Comment__c = true
                                               and Fiscal_Year__c = : year
                                               and Fiscal_Month__c = : month]) {
            
            if(bbb.Comment__c != null) {
                ClsAcctForecastUtil.parseXML(bbb.Comment__c, forecastComments.list_commentItem, bbb.Id, bbb.Customer__c, bbb.Customer__r.Name, bbb.SAP_Profit_Center_Short_Description__c);
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'bbb.Comment__c:: ' + bbb.Comment__c));
            }
        }
        forecastComments.list_commentItem.sort();
    }
    
    public static void getMFComments(String fcDefId, String fiscalDate, list<CtrlRSMForecast.Comment> list_comments) {
        String year = fiscalDate.subStringBefore('-');
        Integer month = Integer.valueOf(fiscalDate.subStringAfter('-'));
        if(list_comments == null) {
            list_comments = new list<CtrlRSMForecast.Comment>();
        }
        for(Manager_Forecast__c mf : [Select Id, Forecast_Definition__c, Comment__c, Fiscal_Year__c, Fiscal_Month__c
                                      From Manager_Forecast__c
                                      Where Forecast_Definition__c =: fcDefId 
                                      and Fiscal_Year__c =: year
                                      And Fiscal_Month__c =: month]) {
            
            if(mf.Comment__c != null && mf.Comment__c != '') {
                parseXML(mf.Comment__c, list_comments, mf);
            }                             
        }
    }
    
    public static void saveComments(map<String, map<String, list<CtrlRSMForecast.Comment>>> map_fcDefId_fiscalDate_listComts, map<String, String> map_fcDefId_fiscalDate2Delete) {
        try{
            String query = '';
            set<String> set_fcDefIds = new set<String>();
            list<Manager_Forecast__c> list_mfExisting = new list<Manager_Forecast__c>();
            list<Manager_Forecast__c> list_mf2Upsert = new list<Manager_Forecast__c>();
            map<String, map<String, map<Integer, Manager_Forecast__c>>> map_fcDefId_year_month_mf = new map<String, map<String, map<Integer, Manager_Forecast__c>>>();
            
            if(!map_fcDefId_fiscalDate_listComts.isEmpty()) {
                set_fcDefIds.addAll(map_fcDefId_fiscalDate_listComts.keySet());
            }
            if(!map_fcDefId_fiscalDate2Delete.isEmpty()) {
                    set_fcDefIds.addAll(map_fcDefId_fiscalDate2Delete.keySet());
            }
            
            query += ' Select Id, Forecast_Definition__c, Comment__c, Fiscal_Year__c, Fiscal_Month__c ';
            query += ' From Manager_Forecast__c Where Forecast_Definition__c IN: set_fcDefIds ';

            if(map_financialMonth == null || map_financialMonth.isEmpty()) {
                setfinancialMonths();
            }
            String monthFilter = CtrlAccountForecastUtil.buildMonthFilter(map_financialMonth);      
            if(monthFilter != '') {
                query += ' And ' + monthFilter;
            }
            for(Manager_Forecast__c mf : database.query(query)) {
                String year = mf.Fiscal_Year__c;
                Integer month = Integer.valueOf(mf.Fiscal_Month__c);
                if(!map_fcDefId_year_month_mf.containsKey(mf.Forecast_Definition__c)) {
                    map_fcDefId_year_month_mf.put(mf.Forecast_Definition__c, new map<String, map<Integer, Manager_Forecast__c>>());
                }
                if(!map_fcDefId_year_month_mf.get(mf.Forecast_Definition__c).containsKey(year)) {
                    map_fcDefId_year_month_mf.get(mf.Forecast_Definition__c).put(year, new map<Integer, Manager_Forecast__c>());
                }
                if(!map_fcDefId_year_month_mf.get(mf.Forecast_Definition__c).get(year).containsKey(month)) {
                    map_fcDefId_year_month_mf.get(mf.Forecast_Definition__c).get(year).put(month, mf);
                }
            }
            
            //delete comments
            
            for(String fcDefId : map_fcDefId_fiscalDate2Delete.keySet()) {
                String fDate = map_fcDefId_fiscalDate2Delete.get(fcDefId); 
                String year = fDate.subStringBefore('-');
                Integer month = Integer.valueOf(fDate.subStringAfter('-'));
                
                if(map_fcDefId_year_month_mf.containsKey(fcDefId) && 
                    map_fcDefId_year_month_mf.get(fcDefId).containsKey(year) && 
                    map_fcDefId_year_month_mf.get(fcDefId).get(year).containsKey(month) ) {
                
                    Manager_Forecast__c mf = map_fcDefId_year_month_mf.get(fcDefId).get(year).get(month);
                    mf.Comment__c = '';
                    list_mf2Upsert.add(mf);     
                }
                    
            }
            //save comments
            for(String fcDefId : map_fcDefId_fiscalDate_listComts.keySet()) {
                for(String fDate : map_fcDefId_fiscalDate_listComts.get(fcDefId).keySet()) {
                    String year = fDate.subStringBefore('-');
                    Integer month = Integer.valueOf(fDate.subStringAfter('-'));
                    list<CtrlRSMForecast.Comment> list_cmts = map_fcDefId_fiscalDate_listComts.get(fcDefId).get(fDate);
                    
                    if(map_fcDefId_year_month_mf.containsKey(fcDefId) && 
                        map_fcDefId_year_month_mf.get(fcDefId).containsKey(year) && 
                        map_fcDefId_year_month_mf.get(fcDefId).get(year).containsKey(month) ) {
                        
                        
                        Manager_Forecast__c mf = map_fcDefId_year_month_mf.get(fcDefId).get(year).get(month);
                        generateCommentXML(list_cmts, mf);
                        list_mf2Upsert.add(mf);
                    }
                    else {
                        Manager_Forecast__c mf = new Manager_Forecast__c();
                        mf.Forecast_Definition__c = fcDefId;
                        mf.Fiscal_Year__c = year;
                        mf.Fiscal_Month__c = month;
                        generateCommentXML(list_cmts, mf);
                        list_mf2Upsert.add(mf);
                    }
                }
            }
            if(!list_mf2Upsert.isEmpty()) {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'list_mf2Upsert ::' + list_mf2Upsert));
                upsert list_mf2Upsert;
            }
        }catch(Exception e){
                throw e;
        }
    }
    
    public static void parseXML(String comments, list<CtrlRSMForecast.Comment> list_comtItem, Manager_Forecast__c mf) {
        DOM.Document doc = new DOM.Document();   
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'mf ::' + mf)); 
        doc.load(comments);    
        DOM.XMLNode topNode = doc.getRootElement();
        if(topNode.getName() == 'comments') {
            for(DOM.XMLNode node : topNode.getChildElements()) {
                if(node.getName() == 'comment' && node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
                    CtrlRSMForecast.Comment item = new CtrlRSMForecast.Comment();
                    item.comment = node.getText();
                    item.value = '';
                    item.fcDefId = mf.Forecast_Definition__c;
                    item.fiscalDate = mf.Fiscal_Year__c + '-' + Integer.valueOf(mf.Fiscal_Month__c);
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
    
    public static void generateCommentXML(list<CtrlRSMForecast.Comment> list_comtItem, Manager_Forecast__c mf) {
        String str_xml = '<comments>';
        for(CtrlRSMForecast.Comment cmt : list_comtItem) {
            cmt.value = (cmt.value == null ? '' : cmt.value);
            cmt.comment = (cmt.comment == null ? '' : cmt.comment);
            str_xml += '<comment value="' + cmt.value + '">' + cmt.comment + '</comment>';
        }
        str_xml += '</comments>';
        if(list_comtItem.size() == 0) {
            str_xml = '';
        }
        mf.Comment__c = str_xml;
    }
    public static void getASMComments(list<CtrlRSMForecast.RSMDefinitionItem > list_fcDefs, CtrlRSMForecast.ASMCommentSearch searchObj, list<CtrlRSMForecast.Comment> list_comts, String region, String pcenter) {
        String fcDefId = searchObj.cls2;
        String year = searchObj.cls3.subStringBefore('_');
        Integer month = Integer.valueOf(searchObj.cls3.subStringAfter('_'));
        
        CtrlRSMForecast.RSMDefinitionItem defItem = new CtrlRSMForecast.RSMDefinitionItem();
        
        for(CtrlRSMForecast.RSMDefinitionItem tempItem : list_fcDefs) {
            if(tempItem.id == fcDefId) {
                defItem = tempItem;
                break;
            }
        }
        
        if(defItem.id == '') {
            return;
        }
        set<String> set_include = new set<String>();
        set<String> set_exclude = new set<String>();
        String classification = defItem.oldClassifications;
        
        for(String include : defItem.categoryInclude.split(',')) {
            if(include.trim() != '') set_include.add(include.trim());
        }

        for(String exclude : defItem.categoryExclude.split(',')) {
            if(exclude.trim() != '') set_exclude.add(exclude.trim());
        }
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'set_include :: ' + set_include));
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'set_exclude :: ' + set_exclude));  
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'set_exclude :: ' + set_exclude.size()));         
        String str_select = ' Select Id, Comment__c, Fiscal_Year__c, Fiscal_Month__c, forecast__c, Customer__c, Customer__r.Name, IND_Profit_Centre_Groups__c, Customer__r.Account_Combined_Data__c '; 
        String str_from = ' From BBB_Month_Bill_Book_Cust__c ';
        String str_where = ' Where Fiscal_Year__c = : year and Fiscal_Month__c =: month and Bill_Type__c = \'Direct\'  ';
        str_where += (set_include.size()>0 ? ' and Customer__r.IND_RSM_Forecast_Category__c IN : set_include ' : '');
        str_where += (set_exclude.size()>0 ? ' and Customer__r.IND_RSM_Forecast_Category__c  NOT IN : set_exclude ' : '');
        str_where += (classification != '' ? ' And Customer__r.IND_Customer_Classification__c =: classification ' : '');
        str_where += ' And Customer__r.IND_Billing_Region__c = \'' + region + '\' and Monthly_BBB_External_Key__c = null and Is_Comment__c = true And IND_Profit_Centre_Groups__c != null ';
        str_where += ' And IND_Profit_Centre_Groups__c = \'' + pcenter + '\'';
        
        String query = str_select + str_from + str_where;
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'query :: ' + query));
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'defItem :: ' + defItem));
        
        for(BBB_Month_Bill_Book_Cust__c bbbm : database.query(query)) {
            if(bbbm.Comment__c != null && bbbm.Comment__c != '') {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'bbbm.Comment__c :: ' + bbbm.Comment__c));
                if(list_comts == null) {
                    list_comts = new list<CtrlRSMForecast.Comment>();
                }
                parseXMLForASM(bbbm.Comment__c, list_comts, bbbm.Customer__r.Account_Combined_Data__c, bbbm.IND_Profit_Centre_Groups__c, defItem.id, searchObj.cls3);
            }
        }
        
    }
    
    public static void parseXMLForASM(String comments, list<CtrlRSMForecast.Comment> list_comt, String acctName, String profitCtr, String defId, String fiscalDate) {
        DOM.Document doc = new DOM.Document();      
        doc.load(comments);    
        DOM.XMLNode topNode = doc.getRootElement();
        if(topNode.getName() == 'comments') {
            for(DOM.XMLNode node : topNode.getChildElements()) {
                if(node.getName() == 'comment' && node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
                    CtrlRSMForecast.Comment item = new CtrlRSMForecast.Comment();
                    item.fcDefId = defId;
                    item.fiscalDate = fiscalDate;
                    item.acctName = acctName;
                    item.profitCtr = profitCtr;
                    item.comment = node.getText();
                    item.value = '';
                    if (node.getAttributeCount() > 0) { 
                        for (Integer i = 0; i< node.getAttributeCount(); i++ ) {
                            item.value += node.getAttributeValue(node.getAttributeKeyAt(i), node.getAttributeKeyNsAt(i));
                        }  
                    }
                    
                    list_comt.add(item);
                }
            }
        }
    }
    
    public static void getRSMColorConfigFromSetting(list<CtrlRSMForecast.ColorConfig> list_colorConf) {
        for(Finanical_Forecast_Color_Config__c conf : Finanical_Forecast_Color_Config__c.getAll().values()) {
            if(conf.IsActive__c != null && conf.Name != null && conf.IsActive__c == true && conf.Name.startsWith('RSM')) {
                CtrlRSMForecast.ColorConfig cc = new CtrlRSMForecast.ColorConfig();
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
            }
        }
    }
 
    public static void getColorConfigFromSetting(list<CtrlRSMChangeScreen.ColorConfig> list_colorConf) {
        for(Finanical_Forecast_Color_Config__c conf : Finanical_Forecast_Color_Config__c.getAll().values()) {
            if(conf.IsActive__c != null && conf.Name != null && conf.IsActive__c == true && conf.Name.startsWith('R-Change')) {
                CtrlRSMChangeScreen.ColorConfig cc = new CtrlRSMChangeScreen.ColorConfig();
                cc.colorName = conf.Color__c;
                
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
            }
        }
    }
}