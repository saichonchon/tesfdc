/**
 *  Contains a set of static methods used GSM Forecast VF pages
 *
 @author Bin Yuan
 @created 2013-11-25
 @version 1.0
 @since 28.0 (Force.com ApiVersion)
 *
 @changelog
 * 2013-11-25 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created
 */
public class ClsGSMForecastUtil {
   
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public static String CATEGORY_A = 'A';
    public static String CATEGORY_B = 'B';
    public static String CATEGORY_AB = 'A_B';
    public static String CATEGORY_BC = 'B_C';
    public static String CATEGORY_CHANNEL = 'Channel';
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
    
    public static final map<String, String> MAP_RSMTAB_GSMTAB = new map<String, String> {
        'fc' => 'rsmtotal',
        'billing' => 'billingtotal',
        'blog' => 'backlogtotal',
        'curcy' => 'currencytotal'
    };
    public static final map<String, String> MAP_BACKLOG = new map<String, String> {
        'oblog' => 'blog',
        'sched' => 'blog'
    };
    public static final set<String>  SET_GSM_QUARTER_CALC = new set<String> {'fc','mypmfc'};
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
   /**
    * This method is used to 
    *
    @author Bin Yuan
    @created 2013-11-25
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    @param year         year string
    @param ownerId      owner id string
    *
    @return             the visit capacity
    *
    @changelog
    * 2013-11-25 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void getGSMForecastDef(list<Forecast_Definition__c> list_gsmDef, String userId, String selectedRegion, list<String> list_region) {
        set<String> set_tempRegions = new set<String>();
        String query = ' Select (Select Forecast_USD__c, Fiscal_Month__c, Fiscal_Year__c, Previous_Month_Forecast_Document__c From Manager_Forecasts__r Where Fiscal_Month__c != null And Fiscal_Year__c != null), ' +
                    ' Id, Category__c, GSM_Name__c, GSM_Sequence__c,Industrial_Sales_Team_Include__c, ';
        query += '              Profit_Center__c, Profit_Center_Region__c, Region__c, Category_Label__c,';
        query += '              RSM_Forecast_Category_Excludes__c, RSM_Forecast_Category_Includes__c, ';
        query += '              RSM__c, RSM_Se_quence__c, Subtotal__c, IND_Customer_Classification__c ';
        query += '       From Forecast_Definition__c ';
        query += '       Where GSM__c =: userId  and IND_Customer_Classification__c != null ';
        query += ((selectedRegion == null || selectedRegion == '' || selectedRegion == 'All') ? '' : ' And Region__c =: selectedRegion ');
        query += '       order by Category__c, GSM_Sequence__c, Region__c ';
   //     ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'selectedRegion :: ' + selectedRegion));
   //     ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'query :: ' + query));
        for(Forecast_Definition__c def : database.query(query)) {
            set_tempRegions.add(def.Region__c);
            list_gsmDef.add(def);
        }
        if(list_region != null && !set_tempRegions.isEmpty()) {
            list_region.addAll(set_tempRegions);
            list_region.sort();
        }
    }
    
    public static void getGSMDefinitionItems(list<Forecast_Definition__c> list_gsmDef, map<String, list<CtrlGSMForecast.GSMLineItem>> map_category_list_gsmItems, map<String, list<CtrlGSMForecast.GSMDefinitionItem>> map_total_list_gsmDefItems, map<String, list<CtrlGSMForecast.GSMLineItem>> map_other_list_gsmItems, map<String, map<String, String>> map_gsmName_date_fc, map<String, map<String, String>> map_gsmName_date_prevFC) {
        //map<String, list<String>>
        String str_tempCategory = '';
        set<String> set_aRegions = new set<String>();
        set<String> set_bRegions = new set<String>();
        set<String> set_channelRegions = new set<String>();
        set<String> set_abRegions = new set<String>();
        set<String> set_abcRegions = new set<String>();
        
        list<String> list_aRegions = new list<String>();
        list<String> list_bRegions = new list<String>();
        list<String> list_channelRegions = new list<String>();
        list<String> list_abRegions = new list<String>();
        list<String> list_abcRegions = new list<String>();
        
        CtrlGSMForecast.GSMDefinitionItem defItem = new CtrlGSMForecast.GSMDefinitionItem();
        CtrlGSMForecast.GSMLineItem gsmItem ;
        map<String, CtrlGSMForecast.GSMLineItem> map_temp_gsmDefKey_gsmLineItem = new map<String, CtrlGSMForecast.GSMLineItem>();
        
        for(Integer i = 0, max = list_gsmDef.size(); i < max; i += 1){
            //Integer index = 1;
            Forecast_Definition__c def = list_gsmDef[i];
            String str_defClassification = (def.IND_Customer_Classification__c == null ? '' : def.IND_Customer_Classification__c);
            String defLabel = (def.Category_Label__c == null ? '' : def.Category_Label__c);
            
            str_tempCategory = (str_tempCategory == '' ? def.Category__c : str_tempCategory);
            if(def.Category__c == defLabel && !def.Subtotal__c && (str_tempCategory != def.Category__c || gsmItem == null || def.GSM_Name__c != gsmItem.name)) {
                gsmItem = new CtrlGSMForecast.GSMLineItem();
                gsmItem.name = def.GSM_Name__c;
                gsmItem.id = i + '';
                gsmItem.managerfc = json.serialize(new map<String, String>());
                gsmItem.pmfc = json.serialize(new map<String, String>());
                if(map_gsmName_date_prevFC.containsKey(def.GSM_Name__c)) {
                    gsmItem.pmfc = Json.serialize(map_gsmName_date_prevFC.get(def.GSM_Name__c));
                }
                if(map_gsmName_date_fc.containsKey(def.GSM_Name__c)) {
                    gsmItem.managerfc = Json.serialize(map_gsmName_date_fc.get(def.GSM_Name__c));
                }
                map_category_list_gsmItems.get(def.Category__c).add(gsmItem);
                str_tempCategory = def.Category__c;
                
            }
            
            //get regions for each category
            if(def.Category__c == CATEGORY_A) {
                if(!set_aRegions.contains(def.Region__c)) {
                    set_aRegions.add(def.Region__c);
                    list_aRegions.add(def.Region__c);
                }
                
            }
            else if(def.Category__c == CATEGORY_B) {
                if(!set_bRegions.contains(def.Region__c)) {
                    set_bRegions.add(def.Region__c);
                    list_bRegions.add(def.Region__c);
                }
            }
            else {
                if(!set_channelRegions.contains(def.Region__c)) {
                    set_channelRegions.add(def.Region__c);
                    list_channelRegions.add(def.Region__c);
                }
            }

            
            
        }
        //generate total section
        generateGSMDefTotalItem(CATEGORY_A, list_aRegions, map_total_list_gsmDefItems);
        generateGSMDefTotalItem(CATEGORY_B, list_bRegions, map_total_list_gsmDefItems);
        generateGSMDefTotalItem(CATEGORY_CHANNEL, list_channelRegions, map_total_list_gsmDefItems);
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'list_aRegions :: ' + list_aRegions));
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'list_bRegions :: ' + list_bRegions));
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'list_channelRegions :: ' + list_channelRegions));
        for(String aRegion : list_aRegions) {
            if(!set_abRegions.contains(aRegion)) {
                list_abRegions.add(aRegion);
                set_abRegions.add(aRegion);
            }
            
            for(Integer i = 0; i < list_bRegions.size(); i ++ ) {
                String bRegion = list_bRegions[i];
              
                if(aRegion == bRegion) {
                    list_bRegions.remove(i);
                    break;
                }
                else {
                    if(!set_abRegions.contains(bRegion)) {
                        list_abRegions.add(bRegion);
                        set_abRegions.add(bRegion);
                    }
                    list_bRegions.remove(i);
                    break;
                }
            }
        }
        if(!list_bRegions.isEmpty()) {
            for(String bRegion : list_bRegions) {
                if(!set_abRegions.contains(bRegion)) {
                    list_abRegions.add(bRegion);
                    set_abRegions.add(bRegion);
                }
            }
        }
        
        
        for(String abRegion : list_abRegions) {
            if(!set_abcRegions.contains(abRegion)) {
                list_abcRegions.add(abRegion);
                set_abcRegions.add(abRegion);
            }
            for(Integer i = 0; i < list_channelRegions.size(); i ++ ) {
                String cRegion = list_channelRegions[i];
                if(abRegion == cRegion) {
                    list_channelRegions.remove(i);
                    break;
                }
                else {
                    if(!set_abcRegions.contains(cRegion)) {
                        list_abcRegions.add(cRegion);
                        set_abcRegions.add(cRegion);
                    }
                    list_channelRegions.remove(i);
                    break;
                }
            }
        }
        if(!list_channelRegions.isEmpty()) {
            for(String cRegion : list_channelRegions) {
                if(!set_abcRegions.contains(cRegion)) {
                    list_abcRegions.add(cRegion);
                    set_abcRegions.add(cRegion);
                }
            }
        }

        
        generateGSMDefTotalItem(CATEGORY_AB, list_abRegions, map_total_list_gsmDefItems);
        generateGSMDefTotalItem(CATEGORY_BC, list_abcRegions, map_total_list_gsmDefItems);
        
        
        
        
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'map_category_list_gsmItems :: ' + map_category_list_gsmItems));
        for(CtrlGSMForecast.GSMLineItem gItem: map_category_list_gsmItems.get(CATEGORY_A)) {
            for(Forecast_Definition__c def : list_gsmDef) {
                
                if(def.Category__c == CATEGORY_A && !def.Subtotal__c && gItem.name == def.GSM_Name__c) {
                    generateGSMDefItem(def, gItem.list_gsmDefinitions, defItem, map_temp_gsmDefKey_gsmLineItem);
                }
            }
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'gItem.list_gsmDefinitions :: ' + gItem.list_gsmDefinitions));
        }   
        for(CtrlGSMForecast.GSMLineItem gItem : map_category_list_gsmItems.get(CATEGORY_B)) {
            for(Forecast_Definition__c def : list_gsmDef) {
                
                if(def.Category__c == CATEGORY_B && !def.Subtotal__c && gItem.name == def.GSM_Name__c) {
                    generateGSMDefItem(def, gItem.list_gsmDefinitions, defItem, map_temp_gsmDefKey_gsmLineItem);
                }
            }
        }    
        for(CtrlGSMForecast.GSMLineItem gItem : map_category_list_gsmItems.get(CATEGORY_CHANNEL)) {
            for(Forecast_Definition__c def : list_gsmDef) {
                
                if(def.Category__c == CATEGORY_CHANNEL && !def.Subtotal__c && gItem.name == def.GSM_Name__c) {
                    generateGSMDefItem(def, gItem.list_gsmDefinitions, defItem, map_temp_gsmDefKey_gsmLineItem);
                }
            }
        }    
        
        for(String str_category : map_category_list_gsmItems.keySet()) {
            for(CtrlGSMForecast.GSMLineItem gsmLineItem : map_category_list_gsmItems.get(str_category)) {
                for(CtrlGSMForecast.GSMDefinitionItem dItem: gsmLineItem.list_gsmDefinitions) {
                    String defKey = dItem.defItemKey;
                    if(map_temp_gsmDefKey_gsmLineItem.containsKey(defKey)) {
                        String str_Json = Json.serialize(map_temp_gsmDefKey_gsmLineItem.get(defKey));
                        dItem.map_defKey_listDefs.put(defKey, str_Json);
                    }
                }
            }
        }   

    }
    public static void generateGSMDefTotalItem(String category, list<String> list_regions, map<String, list<CtrlGSMForecast.GSMDefinitionItem>> map_total_list_gsmDefItems) {
        //generate total section
        for(Integer i = 0 ; i < list_regions.size() ; i ++ ) {
            String region = list_regions[i];
            String idPrefix = category + 'Total_';
            
            CtrlGSMForecast.GSMDefinitionItem defItem = new CtrlGSMForecast.GSMDefinitionItem();
            defItem.category = category;
            defItem.id = idPrefix + i;
            defItem.name = region;
            defItem.rsmName = region;
            
            map_total_list_gsmDefItems.get(category).add(defItem);
        }
    }
    
    public static void generateGSMDefItem(Forecast_Definition__c def, list<CtrlGSMForecast.GSMDefinitionItem> list_gsmDefinitions, CtrlGSMForecast.GSMDefinitionItem defItem, map<String, CtrlGSMForecast.GSMLineItem> map_temp_gsmDefKey_gsmLineItem) {
        defItem = new CtrlGSMForecast.GSMDefinitionItem();
        map<String, Decimal> map_mfc= new map<String, Decimal>();
        map<String, Decimal> map_prevMFC= new map<String, Decimal>();
        String defKey = def.Category__c + def.GSM_Name__c.replaceAll(' ', '') + def.Region__c.replaceAll(' ', '');
        
        defItem.defItemKey = defKey;
        defItem.map_defKey_listDefs = new map<String, String>();
        defItem.category = def.Category__c;
        defItem.categoryExclude = (def.RSM_Forecast_Category_Excludes__c == null ? '' : def.RSM_Forecast_Category_Excludes__c);
        defItem.categoryInclude = (def.RSM_Forecast_Category_Includes__c == null ? '' : def.RSM_Forecast_Category_Includes__c);
        defItem.gsmSequence = (def.GSM_Sequence__c == null ? 0 : def.GSM_Sequence__c);
        defItem.id = def.Id;
        defItem.industrialSalesTeamInclude = (def.Industrial_Sales_Team_Include__c == null ? '' : def.Industrial_Sales_Team_Include__c);
        defItem.name = def.GSM_Name__c;
        defItem.rsmName = def.Region__c;
        defItem.profitCenter = def.Profit_Center__c;
        defItem.region = def.Region__c;
        defItem.subtotal = def.Subtotal__c;
        defItem.label = (def.Category_Label__c == null ? '' : def.Category_Label__c);
        defItem.classification = (def.IND_Customer_Classification__c == null ? '' : def.IND_Customer_Classification__c);
        for(Manager_Forecast__c mf : def.Manager_Forecasts__r){
            if(mf.Forecast_USD__c != null && mf.Forecast_USD__c != 0){
                map_mfc.put(mf.Fiscal_Year__c + '_' + (Integer.valueOf(mf.Fiscal_Month__c)), mf.Forecast_USD__c);
            }
            if(mf.Previous_Month_Forecast_Document__c != 0 && mf.Previous_Month_Forecast_Document__c != null){
                map_prevMFC.put(mf.Fiscal_Year__c + '_' + (Integer.valueOf(mf.Fiscal_Month__c)), mf.Previous_Month_Forecast_Document__c);
            }
        }
        defItem.managerfc = Json.serialize(map_mfc);
        defItem.prevManagerFc = Json.serialize(map_prevMFC);//'{"2014_5":35000}';
        
        if(!map_temp_gsmDefKey_gsmLineItem.containsKey(defKey)) {
            if(defItem.label == defItem.category) {
                list_gsmDefinitions.add(defItem);
            }
            map_temp_gsmDefKey_gsmLineItem.put(defKey, new CtrlGSMForecast.GSMLineItem());
        }
        else {
            for(CtrlGSMForecast.GSMDefinitionItem dItem : list_gsmDefinitions) {
                if(dItem.defItemKey == defKey) {
                    map<String, Decimal> map_mfc_old = new map<String, Decimal>();
                    map_mfc_old = (map<String, Decimal>) Json.deserialize(dItem.managerfc, map<String, Decimal>.class);
                    map<String, Decimal> map_prevMFC_old = new map<String, Decimal>();
                    map_prevMFC_old = (map<String, Decimal>) Json.deserialize(dItem.prevManagerFc, map<String, Decimal>.class);
                    for(String dateKey : map_mfc.keySet()) {
                        if(!map_mfc_old.containsKey(dateKey) && map_mfc.get(dateKey) != null) {
                            map_mfc_old.put(dateKey, map_mfc.get(dateKey));
                        }
                        else if(map_mfc.get(dateKey) != null) {
                            map_mfc_old.put(dateKey, (map_mfc.get(dateKey) + map_mfc_old.get(dateKey)));
                        }
                    }
                    for(String dateKey : map_prevMFC.keySet()) {
                        if(!map_prevMFC_old.containsKey(dateKey) && map_prevMFC.get(dateKey) != null) {
                            map_prevMFC_old.put(dateKey, map_prevMFC.get(dateKey));
                        }
                        else if(map_prevMFC.get(dateKey) != null) {
                            map_prevMFC_old.put(dateKey, (map_prevMFC.get(dateKey) + map_prevMFC_old.get(dateKey)));
                        }
                    }
                    dItem.managerfc = Json.serialize(map_mfc_old);
                    dItem.prevManagerFc = Json.serialize(map_prevMFC_old);
                    defItem.managerfc = '';
                    defItem.prevManagerFc = '';
                }
            }
        }
        map_temp_gsmDefKey_gsmLineItem.get(defKey).list_gsmDefinitions.add(defItem);
    }
    
    public static String integrateString(String str_old, String str_new) {
        if(str_new !=  '' && !str_old.contains(str_new)) {
            return (str_old == '' ? str_new : str_old + ',' + str_new);
        }
        return str_old;
    }
    
    public static void setfinancialMonths(CtrlGSMForecast.PageConfig pageConf, set<String> set_dateKey) {
        date startDate = date.today();
        date endDate = date.today();
        pageConf.map_financialMonth = new  Map<String, Set<Integer>>();
        list<String> list_years = new list<String>();
        //set current year & current month
        for (Period period : [select Id, FiscalYearSettings.Name, PeriodLabel from Period where StartDate<=Today and EndDate >=Today and Type = 'Month']) {
            if(period.FiscalYearSettings.Name != null){
                pageConf.currentYear = period.FiscalYearSettings.Name;
            }
            if(period.PeriodLabel != null){
                pageConf.currentMonth = ClsBudgetPlanBreakDownUtil.MAP_MONTHLABELNUMBER.get(period.PeriodLabel);
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
        
        for (Period period : [select Id, FiscalYearSettings.Name, PeriodLabel from Period where StartDate>= : startDate and EndDate<=: endDate and Type = 'Month']) {
            String fiscalDateKey = '';
            if(!pageConf.map_financialMonth.containsKey(period.FiscalYearSettings.Name)) {
                pageConf.map_financialMonth.put(period.FiscalYearSettings.Name, new Set<Integer>());
            }
            pageConf.map_financialMonth.get(period.FiscalYearSettings.Name).add(MAP_MONTHLABELNUMBER.get(period.PeriodLabel));
            fiscalDateKey = period.FiscalYearSettings.Name + '_' + MAP_MONTHLABELNUMBER.get(period.PeriodLabel);
            set_dateKey.add(fiscalDateKey);
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
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'pageConf.currentYear :: ' + pageConf.currentYear));
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'pageConf.currentMonth :: ' + pageConf.currentMonth));
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'pageConf.currentMonthIndex :: ' + pageConf.currentMonthIndex));
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'pageConf.map_financialMonth :: ' + pageConf.map_financialMonth));
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'pageConf.list_yearMonth :: ' + pageConf.list_yearMonth));
    }

    public static void createDateItem(List<CtrlGSMForecast.DateItem> list_dateItems, Map<String, List<CtrlGSMForecast.DateItem>> map_dateItems, List<CtrlGSMForecast.DateItem> list_allDateItems, CtrlGSMForecast.PageConfig pageConf) {                 
        String str_monthLabel = '';
        String str_qLabel = '';
        String str_yearLabel = '';
        Integer monthCounter = 0;
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'pageConf :: ' + pageConf));
        CtrlGSMForecast.DateItem tempDateItem;
        List<CtrlGSMForecast.DateItem> list_tempDateItem;
        for (Integer i = 1; i < = 27; i++) {
            if (i == 1) {
                tempDateItem = new CtrlGSMForecast.DateItem('Historical Data');
                tempDateItem.type = 'historicalc';
                //tempDateItem.type1 = '<th class="trh historicalc tc" colspan="' + (ClsRSMForecastUtil.currentMonthIndex + 1) + '">Historical Data</th>';
                tempDateItem.type1 = '';//'<th class="trh historicalc tc" colspan="'+(pageConf.currentMonthIndex + 1)+'" style="height: 0px !important;"><div class="fix_lh historicalc">Historical Data</div></th>';
                list_dateItems.add(tempDateItem);
                
                list_tempDateItem = new List<CtrlGSMForecast.DateItem>();
                map_dateItems.put('Historical Data', list_tempDateItem);
            }
            else if (i == 7) {
                tempDateItem = new CtrlGSMForecast.DateItem('Current Month');
                tempDateItem.cls = 'none';
                tempDateItem.type = 'currentc cfixw';
                //tempDateItem.type1 = '<th class="trh currentc tc"> </th>';
                //tempDateItem.type1 = '<th class="trh historicalc tc" colspan="'+(pageConf.currentMonthIndex + 1 + ( Math.mod(pageConf.currentMonthIndex, 3) == 0 ? 2 : 1))+'" style="height: 0px !important;"><div class="fix_lh historicalc">Historical Data</div></th>';
                tempDateItem.type1 = '<th class="fixthh th_historicalc historicalc tc" old="'+pageConf.currentMonthIndex+'" colspan="'+(pageConf.currentMonthIndex + 1 + ( Math.mod(pageConf.currentMonthIndex, 3) == 0 ? 2 : 1))+'"><div class="fix_lh head_historicalc"><div class="absdiv">' + system.label.RSM_HistoricalData + '</div></div></th>';
            //    tempDateItem.type1 = '<th class="trh currentc tc" colspan="' + ( Math.mod(pageConf.currentMonthIndex, 3) == 0 ? 2 : 1) + '"  style="height: 0px !important;"><div class="fix_lh currentc"> </div></th>';
                list_dateItems.add(tempDateItem);
                
                list_tempDateItem = new List<CtrlGSMForecast.DateItem>();
                map_dateItems.put('Current Month', list_tempDateItem);
            }
            else if (i == 10){
                tempDateItem = new CtrlGSMForecast.DateItem('Future Plan');
                tempDateItem.cls = 'none';
                tempDateItem.type = 'futurec';
                //tempDateItem.type1 = '<th class="trh futurec tc" colspan="' + (18 - ClsRSMForecastUtil.currentMonthIndex) + '"><div>Future Plan</div></th>';
                //tempDateItem.type1 = '<th class="trh futurec tc" colspan="999" style="height: 0px !important;"><div class="fix_lh futurec">Future Plan</div></th>';
                tempDateItem.type1 = '<th class="fixthh th_futurec futurec tc" colspan="999" ><div class="fix_lh head_futurec">' + system.label.RSM_FuturePlan + '</div></th>';
                list_dateItems.add(tempDateItem);
                
                list_tempDateItem = new List<CtrlGSMForecast.DateItem>();
                map_dateItems.put('Future Plan', list_tempDateItem);
            }                
            
            CtrlGSMForecast.DateItem tempMonthItem = new CtrlGSMForecast.DateItem('');
            tempMonthItem.type2 = 'cfixmonthw';
            tempMonthItem.type3 = 'totalbg';
            monthCounter = (i - pageConf.currentMonthIndex);
            str_yearLabel = pageConf.currentYear;
            if(monthCounter + pageConf.currentMonth <= 0) {
                monthCounter += 12;
                str_yearLabel = String.valueOf(integer.valueOf(str_yearLabel) - 1);
            }
            else if((monthCounter + pageConf.currentMonth) > 12 && (monthCounter + pageConf.currentMonth) <= 24) {
                monthCounter -= 12;
                str_yearLabel = String.valueOf(integer.valueOf(str_yearLabel) + 1);
            }
            else if((monthCounter + pageConf.currentMonth) > 24) {
                monthCounter -= 24;
                str_yearLabel = String.valueOf(integer.valueOf(str_yearLabel) + 2);
            }
            monthCounter += pageConf.currentMonth;
            str_yearLabel = str_yearLabel.subString(2);
            str_monthLabel = MAP_NUMBERMONTHLABEL.get(monthCounter);
            tempMonthItem.itemName = str_monthLabel + ' / ' + str_yearLabel;
            
            if (i < pageConf.currentMonthIndex) {
                Integer t = (i - pageConf.currentMonthIndex);
                //tempMonthItem.itemName = 'CM' + t; 
                tempMonthItem.type = ('historicalc ' + (tempDateItem.type == 'currentc cfixw' ? 'currentc' : tempDateItem.type) + '1 cfixmonthw');
                if(t == -1 || t == -2 || t == -3){
                    tempMonthItem.type += ' cm'+t+' ';
                }
            }
            else if (i == pageConf.currentMonthIndex) {
                //tempMonthItem.itemName = 'Current Month';
                tempMonthItem.isInput = false;
                tempMonthItem.type = ('currentc ' + (tempDateItem.type == 'currentc cfixw' ? 'currentc' : tempDateItem.type) + '1 ' + 'cfixw');
                tempMonthItem.type1 = 'current_fixcls';
                tempMonthItem.type2 = 'cfixcurentmonthw';
            }
            else {
                Integer t = 0;
                if (i == pageConf.currentMonthIndex + 1) {
                    //tempMonthItem.itemName = 'NM';
                    t = 0;
                }
                else {
                    //tempMonthItem.itemName = 'NM+' + (i - ClsRSMForecastUtil.currentMonthIndex - 1);   
                    t = (i - pageConf.currentMonthIndex - 1);        
                }
                tempMonthItem.isInput = true;
                tempMonthItem.type = ('futurec ' + (tempDateItem.type == 'currentc cfixw' ? 'currentc' : tempDateItem.type) + '1 cfixmonthw');
                if(t == 0 || t == 1 || t == 2){
                    tempMonthItem.type += ' _cnm'+t+' ';
                }
            }    
            String ymStr = pageConf.list_yearMonth.get(i - 1);
            tempMonthItem.fYear = ymStr.subString(0, ymStr.indexOf(';'));
            tempMonthItem.fMonth = Integer.valueOf(ymStr.subString(ymStr.indexOf(';') + 1));
            if(pageConf.map_workingDays.get(ymStr) != null) {
                tempMonthItem.workingDays = pageConf.map_workingDays.get(ymStr);
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
                
                CtrlGSMForecast.DateItem tempTotalItem = new CtrlGSMForecast.DateItem(str_qLabel);
                //CtrlGSMForecast.DateItem tempTotalItem = new CtrlGSMForecast.DateItem('Q Total');
                tempTotalItem.total = 'q' + i / 3;
                if (i < pageConf.currentMonthIndex) {
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
    
    public Static void createWorkingDaysMap(CtrlGSMForecast.PageConfig pageConf) {
        //map_workingDays = new Map<String, Decimal>();
        map<String, map<String, decimal>> map_region_workingDays = new map<String, map<String, decimal>>();
        //list<String> list_tempRegions = new list<String>();
        //list_tempRegions = pageConf.list_regions;
        //String query = 'Select Id, Days__c, Fiscal_Year__c, Fiscal_Month__c, IND_Billing_region__c From Effective_Working_Days__c Where ( ';
        String query = 'Select Id, Days__c, Fiscal_Year__c, Fiscal_Month__c From Effective_Working_Days__c Where ( ';
        for (Integer i = pageConf.currentMonthIndex - 4; i <= pageConf.currentMonthIndex + 2; i++) {
            if(pageConf.list_yearMonth.get(i) != null) {
                String ymStr = pageConf.list_yearMonth.get(i);
                pageConf.map_workingDays.put(ymStr, 0);
                query += '(Fiscal_Year__c = \'' + ymStr.substring(0, ymStr.indexOf(';')) + '\' And Fiscal_Month__c = ' + ymStr.substring(ymStr.indexOf(';') + 1) + ') Or ';
            }
        }
        query = query.substring(0, query.lastIndexOf('Or'));
        query += ' ) ';
        //query += (list_tempRegions.isEmpty() ? '' : ' And IND_Billing_region__c IN : list_tempRegions ');
        for (Effective_Working_Days__c workingDays : database.query(query)) {
            String str_dateKey = workingDays.Fiscal_Year__c + ';' + workingDays.Fiscal_Month__c;
            pageConf.map_workingDays.put(str_dateKey, workingDays.Days__c);
        }
        /* comment for region field on effective working day object
        
        for (Effective_Working_Days__c workingDays : database.query(query)) {
            if(!map_region_workingDays.containsKey(workingDays.IND_Billing_region__c)) {
                map_region_workingDays.put(workingDays.IND_Billing_region__c, new map<String, decimal>());
            }
            map_region_workingDays.get(workingDays.IND_Billing_region__c).put((workingDays.Fiscal_Year__c + '-' + workingDays.Fiscal_Month__c), workingDays.Days__c);
        }
        pageConf.str_workingDayJson = Json.serialize(map_region_workingDays);
        */
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
    */
    public static void getQueryStrForBBBM(set<String> set_dateKey, map<String, String> map_fiscalDate_bbbMQuery){
        for(String dateKey : set_dateKey) {
            String year = dateKey.substringBefore('_');
            Integer month = Integer.valueOf(dateKey.substringAfter('_'));
            String map_key = 'bbb@' + dateKey;
            String query ='Select sum(Bill_Amount_USD__c) Billings, sum(Book_Amount_USD__c) Book2Bill, sum(Demand_Shipped__c) DemandShipped, sum(Demand_Open__c) DemandOpen, ';
            query += ' sum(forecast__c) Forecasts, sum(Backlog_0__c) Backlog0,  sum(Currency_1_USD__c) Currency1, ';
            query += ' sum(Currency_2_USD__c) Currency2, sum(Currency_3_USD__c) Currency3, sum(Currency_4_USD__c) Currency4, ';
            query += ' sum(Forecast_2_Months_Document__c) month2Forecast, sum(Forecast_6_Months_Document__c) month6Forecast, Customer__r.IND_Customer_Classification__c classification, ';
            query += ' sum(Forecast_Begin_of_Quarter_Document__c) beginQuarterForecast, sum(Previous_Month_Forecast_Document__c) PreviousForecast, ';
            query += ' Customer__r.IND_RSM_Forecast_Category__c Category, Customer__r.IND_Billing_Region__c region, IND_Profit_Centre_Groups__c profitCtr ';
            query += ' From BBB_Month_Bill_Book_Cust__c Where Bill_Type__c = \'Direct\' ';
            query += ' And Fiscal_Year__c = \''+year+'\' ';
            query += ' And Fiscal_Month__c = '+month+' ';
            query += ' And IND_Profit_Centre_Groups__c != null ';
            //query += ' And Customer__r.IND_RSM_Forecast_Category__c != null ';
            query += ' And Customer__r.IND_Billing_Region__c != null ';
            query += ' And Customer__r.IND_Customer_Classification__c != null ';
            query += ' Group By Customer__r.IND_RSM_Forecast_Category__c, IND_Profit_Centre_Groups__c,  ';
            query += ' Customer__r.IND_Customer_Classification__c, Customer__r.IND_Billing_Region__c';
            
            map_fiscalDate_bbbMQuery.put(map_key, query);
        }
        
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
    public static void getQueryStrForScheduledAgreements(set<String> set_dateKey, map<String, String> map_fiscalDate_scheduledQuery){
        for(String dateKey : set_dateKey) {
            String year = dateKey.substringBefore('_');
            Integer month = Integer.valueOf(dateKey.substringAfter('_'));
            String map_key = 'sch@' + dateKey;
            String query ='Select sum(Forecast_Amount_USD__c) forecast, ';
            query += ' Sold_To_Customer__r.IND_RSM_Forecast_Category__c Category, ';
            query += ' Sold_To_Customer__r.IND_Customer_Classification__c classification,  ';
            query += ' Sold_To_Customer__r.IND_Billing_Region__c region ';
            query += ' From Scheduled_Agreements__c Where Forecast_Amount_USD__c > 0';
            query += ' And Fiscal_Year__c = \''+year+'\' ';
            query += ' And Fiscal_Month_Text__c = \''+month+'\' ';
            query += ' And Sold_To_Customer__r.IND_RSM_Forecast_Category__c != null ';
            query += ' And Sold_To_Customer__r.IND_Billing_Region__c != null ';
            query += ' And Sold_To_Customer__r.IND_Customer_Classification__c != null ';
            query += ' Group By Sold_To_Customer__r.IND_RSM_Forecast_Category__c, Sold_To_Customer__r.IND_Billing_Region__c, ';
            query += '  Sold_To_Customer__r.IND_Customer_Classification__c ';
            map_fiscalDate_scheduledQuery.put(map_key, query);
            
        }
        
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
    public static void getGSMManagerForecast(String userId, map<String, set<Integer>> map_financialMonth, map<String, map<String, String>> map_gsmName_date_fc, map<String, map<String, String>> map_gsmName_date_prevFC){
        String query = ' Select Id, Forecast_USD__c, GSM_Name__c, Previous_Month_Forecast_Document__c, ';
        query += '              Fiscal_Month__c, Fiscal_Year__c, Fiscal_Date__c, GSM__c ';
        query += '       From Manager_Forecast__c ';
        query += '       Where GSM__c =: userId ';
        query += '       and Forecast_Definition__c = null ';
        
        String monthFilter = CtrlAccountForecastUtil.buildMonthFilter(map_financialMonth);
        query += (monthFilter == '' ? '' : ' And ' + monthFilter);
        
        for(Manager_Forecast__c mf : database.query(query)) {
            Integer month = Integer.valueOf(mf.Fiscal_Month__c);
            String fiscalDate = mf.Fiscal_Year__c + '_' + month;
            if(mf.Forecast_USD__c  != 0 && mf.Forecast_USD__c != null) {
                if(!map_gsmName_date_fc.containsKey(mf.GSM_Name__c)) {
                    map_gsmName_date_fc.put(mf.GSM_Name__c, new map<String, String>());
                }
                if(!map_gsmName_date_fc.get(mf.GSM_Name__c).containsKey(fiscalDate)) {
                    map_gsmName_date_fc.get(mf.GSM_Name__c).put(fiscalDate, mf.Forecast_USD__c + '');
                }
            }
            if(mf.Previous_Month_Forecast_Document__c != 0 && mf.Previous_Month_Forecast_Document__c != null) {
                if(!map_gsmName_date_prevFC.containsKey(mf.GSM_Name__c)) {
                    map_gsmName_date_prevFC.put(mf.GSM_Name__c, new map<String, String>());
                }
                if(!map_gsmName_date_prevFC.get(mf.GSM_Name__c).containsKey(fiscalDate)) {
                    map_gsmName_date_prevFC.get(mf.GSM_Name__c).put(fiscalDate, mf.Previous_Month_Forecast_Document__c + '');
                }
            }
        }
        
    } 
    
    public static void saveGSMManagerForecast(String userId, map<String, set<Integer>> map_financialMonth, list<CtrlGSMForecast.GSMSaveItem> list_gsmSaveItems){
        map<String, map<String, map<Integer, Manager_Forecast__c>>> map_gsmName_year_month_mf = new map<String, map<String, map<Integer, Manager_Forecast__c>>>();
        list<Manager_Forecast__c> list_gsmMF2upsert = new list<Manager_Forecast__c>();
        
        String query = ' Select Id, Forecast_USD__c, GSM_Name__c, Previous_Month_Forecast_Document__c, ';
        query += '              Fiscal_Month__c, Fiscal_Year__c, Fiscal_Date__c, GSM__c ';
        query += '       From Manager_Forecast__c ';
        query += '       Where GSM__c =: userId ';
        query += '       and Forecast_Definition__c = null ';
        
        String monthFilter = CtrlAccountForecastUtil.buildMonthFilter(map_financialMonth);
        query += (monthFilter == '' ? '' : ' And ' + monthFilter);
        
        for(Manager_Forecast__c mf : database.query(query)) {
            Integer month = Integer.valueOf(mf.Fiscal_Month__c);
            
            if(!map_gsmName_year_month_mf.containsKey(mf.GSM_Name__c)) {
                map_gsmName_year_month_mf.put(mf.GSM_Name__c, new map<String, map<Integer, Manager_Forecast__c>>());
            }
            if(!map_gsmName_year_month_mf.get(mf.GSM_Name__c).containsKey(mf.Fiscal_Year__c)) {
                map_gsmName_year_month_mf.get(mf.GSM_Name__c).put(mf.Fiscal_Year__c, new map<Integer, Manager_Forecast__c>());
            }
            if(!map_gsmName_year_month_mf.get(mf.GSM_Name__c).get(mf.Fiscal_Year__c).containsKey(month)) {
                map_gsmName_year_month_mf.get(mf.GSM_Name__c).get(mf.Fiscal_Year__c).put(month, mf);
            }
        }
        
        for(CtrlGSMForecast.GSMSaveItem item : list_gsmSaveItems) {
            item.fiscalYear = item.gsmDate.subStringBefore('-');
            item.fiscalMonth = Integer.valueOf(item.gsmDate.subStringAfter('-'));
            
            if(map_gsmName_year_month_mf.containsKey(item.gsmName) && 
               map_gsmName_year_month_mf.get(item.gsmName).containsKey(item.fiscalYear) && 
               map_gsmName_year_month_mf.get(item.gsmName).get(item.fiscalYear).containsKey(item.fiscalMonth)) {
                
                Manager_Forecast__c mf = map_gsmName_year_month_mf.get(item.gsmName).get(item.fiscalYear).get(item.fiscalMonth);
                mf.Forecast_USD__c = item.fc;
                list_gsmMF2upsert.add(mf);
            }
            else {
                generateGSMSaveItem(userId, list_gsmMF2upsert, item);
            }
        }
        if(!list_gsmMF2upsert.isEmpty()) {
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'list_gsmMF2upsert :: ' + list_gsmMF2upsert));
            upsert list_gsmMF2upsert;
        } 
    } 
    public static void generateGSMSaveItem(String userId, list<Manager_Forecast__c> list_gsmMF2upsert, CtrlGSMForecast.GSMSaveItem item) {
        Manager_Forecast__c mf = new Manager_Forecast__c();
        
        mf.Forecast_USD__c = item.fc;
        mf.GSM_Name__c = item.gsmName;
        mf.GSM__c = userId;
        mf.Fiscal_Year__c = item.fiscalYear;
        mf.Fiscal_Month__c = item.fiscalMonth;
        
        list_gsmMF2upsert.add(mf);
    }

    public static void getRSMColorConfigFromSetting(list<CtrlGSMForecast.ColorConfig> list_colorConf) {
        for(Finanical_Forecast_Color_Config__c conf : Finanical_Forecast_Color_Config__c.getAll().values()) {
            if(conf.IsActive__c != null && conf.Name != null && conf.IsActive__c == true && conf.Name.startsWith('RSM')) {
                CtrlGSMForecast.ColorConfig cc = new CtrlGSMForecast.ColorConfig();
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
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'list_colorConf :: ' + list_colorConf ));
    }
    public static void getRSMComments(set<String> set_rsmFCDefIds, String fiscalDate, list<CtrlGSMForecast.Comment> list_cmts) {
        String year = fiscalDate.subStringBefore('-');
        Integer month = Integer.valueOf(fiscalDate.subStringAfter('-'));
        if(list_cmts == null) {
            list_cmts = new list<CtrlGSMForecast.Comment>();
        }
        for(Manager_Forecast__c mf : [Select Id, Forecast_Definition__c, Comment__c, Fiscal_Year__c, Fiscal_Month__c, Forecast_Definition__r.Region__c
                                      From Manager_Forecast__c
                                      Where Forecast_Definition__c IN: set_rsmFCDefIds 
                                      and Fiscal_Year__c =: year
                                      And Fiscal_Month__c =: month]) {
            
            if(mf.Comment__c != null && mf.Comment__c != '') {
                parseXML(mf.Comment__c, list_cmts, mf);
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'mf.Comment__c :: ' + mf.Comment__c));
            }                             
        }
    }
    
    public static void parseXML(String comments, list<CtrlGSMForecast.Comment> list_comtItem, Manager_Forecast__c mf) {
        DOM.Document doc = new DOM.Document();   
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'mf ::' + mf)); 
        doc.load(comments);    
        DOM.XMLNode topNode = doc.getRootElement();
        if(topNode.getName() == 'comments') {
            for(DOM.XMLNode node : topNode.getChildElements()) {
                if(node.getName() == 'comment' && node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
                    CtrlGSMForecast.Comment item = new CtrlGSMForecast.Comment();
                    item.comment = node.getText();
                    item.value = '';
                    item.region = mf.Forecast_Definition__r.Region__c;
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
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
}