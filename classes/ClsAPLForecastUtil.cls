/**
 *  Util class for APL Sales forecast pages
 *
 @author    Bin Yuan
 @created   2014-06-02
 @version   1.0
 @since     29.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-06-02 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created
 */
public class ClsAPLForecastUtil {
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public static final Integer QNUMBER = 5;
    public static final Integer FUTUREQNUMBER = 7;
    public static final String OTHER = system.label.APL_Other_Accounts;
    public static map<String, Decimal> map_isoCode_exchangeRate; 
    public static map<String, Decimal> map_convertionRate = new Map<String, Decimal>();
    public static final map<String, Integer> MAP_MONTHLABELNUMBER = new map<String, Integer>{
        'Jan' => 4, 'Feb' => 5, 'Mar' => 6, 'Apr' => 7, 'May' => 8, 'Jun' => 9,
        'Jul' => 10, 'Aug' => 11, 'Sep' => 12, 'Oct' => 1, 'Nov' => 2, 'Dec' => 3
    };
    public static final map<Decimal, String> MAP_NUMBERMONTHLABEL = new map<Decimal, String>{
        4 => 'Jan', 5 => 'Feb', 6 => 'Mar', 7 => 'Apr', 8 => 'May', 9 => 'Jun',
        10 => 'Jul', 11 => 'Aug', 12 => 'Sep', 1 => 'Oct', 2 => 'Nov', 3 => 'Dec'
    };
    public static final map<Integer, String> MAP_MONTH_INT_STRING = new map<Integer, String>{
        1 => '01', 2 => '02', 3 => '03', 4 => '04', 5 => '05', 6 => '06',
        7 => '07', 8 => '08', 9 => '09', 10 => '10', 11 => '11', 12 => '12'
    };
    public static final map<String, set<String>> map_RELAY_CBCFIELD_CBCDESC = new map<String, set<String>> {
        'CBC2__c' => new set<String> {'30005', '13213'},
        //change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
        'CBC3__c' => new set<String> {'41553'}
    };
    public static final map<String, String> map_RELAY_CBCCode_CBCDESC = new map<String, String> {
        '13213' => 'CBC2 / Automotive Relays',
        '30005' => 'CBC2 / APPLIANCES GENERAL PURPOSE RELAYS',
        '41553' => 'CBC3 / Relays IND'
        //change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
        //'40308' => 'CBC3 / Relays A&C',
        //'40309' => 'CBC3 / Relays IB'
    };
    public static final map<String, String> map_CBC2ID_CBC2NAME = new map<String, String>{
        '30012' => 'Power', '30014' => 'Signal',  '30015' => 'RAST', '30016' => 'Terminals & Splices', '30017' => 'Tubing', '30042' => 'Magnet'
    };
    public static final map<String, String> map_LV2TerritoryCode_Region = new map<String, String>{
        '103004' => 'Appl EMEA',
        '102264' => 'Appl Americas',
        '102706' => 'Appl Asia Pacific'
    };
    public static final String ACCTFCTYPE = 'Account';
    public static final String GPLFCTYPE = 'GPL';
    public static final String PARTFCTYPE = 'Part';
    public static final String RELAYFCTYPE = 'Relay';
    public static final String OTHERFCTYPE = 'Other CBC2';
    public static final String OTHERACCTID = 'OTHERACCTID';
    public static final String OTHERPARTID = 'null';
    public static final String CBCRELAY = system.label.APL_CBC_Relay;
    public static final String CBCOTHER = system.label.APL_CBC_Other;
    public static final map<String, String> map_RSMTYPE_INSTANCENAME = new map<String, String> {
        'AM' => 'ClsAPLServiceRSM',
        'Relay' => 'ClsAPLServiceRSMRelay'
    };
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
   /**
    * This method is used to set account ids for a gaven filters
    *
    @author Bin Yuan
    @created 2015-03-10
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-03-10 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void setAccountIds(boolean isAM, String planAcctId, String territoryCode, set<String> set_acctIds) {
        list<String> list_sql = new list<String>();
        list_sql.add(' id ');
        list_sql.add(' Account ');
        list_sql.add(' WHERE ' 
        			+ (isAM ? ' APL_AM_forecast_Plan_Account__c = ' : ' APL_Relay_forecast_Plan_Account__c = ') 
                    + (planAcctId == ClsAPLForecastUtil.OTHERACCTID ? ' null ' : '\'' +  planAcctId + '\' ') 
                    + ' And '
                    + (isAM ? ' SALES_TERRITORY_CDE__c ' : ' Relay_Specialist_Territory_Code__c ') 
                    + ' = \'' + territoryCode + '\' '
                    + ' And STATDESC__c = \'Active\' ');
		system.debug('query ::: ' + ClsAPLForecastUtil.getQueryString(list_sql));
		for(Account acct : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
			set_acctIds.add(acct.Id);
		}
    }
    
   /**
    * This method is used to set account ids for a gaven filters
    *
    @author Bin Yuan
    @created 2015-03-10
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-03-10 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void setGAMAccountIds(String territoryCode, set<String> set_gamCodes, set<String> set_acctIds) {
    	set<String> tempGamCodes = new set<String>();
    	tempGamCodes.addAll(set_gamCodes);
        list<String> list_sql = new list<String>();
        list_sql.add(' id ');
        list_sql.add(' Account ');
        list_sql.add(' WHERE Territory_L2_code__c = \'' + territoryCode + '\' ' 
                    + ' And GAMCD__c IN : tempGamCodes '
                    + ' And STATDESC__c = \'Active\' '
                    + ' And RecordType.DeveloperName != \'Grouped Accounts\' '
                    );
		system.debug('setGAMAccountIds query ::: ' + ClsAPLForecastUtil.getQueryString(list_sql));
		for(Account acct : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
			set_acctIds.add(acct.Id);
		}
    }
    
   /**
    * This method is used to set account ids for a gaven filters
    *
    @author Bin Yuan
    @created 2015-03-10
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-03-10 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void setRSMAccountIds(boolean isAM, set<String> set_territoryCodes, set<String> set_acctIds) {
    	set<String> tempTerritoryCodes = new set<String>();
    	tempTerritoryCodes.addAll(set_territoryCodes);
        list<String> list_sql = new list<String>();
        list_sql.add(' id ');
        list_sql.add(' Account ');
        list_sql.add(' WHERE ' + (isAM ? 'SALES_TERRITORY_CDE__c ' : 'Relay_Specialist_Territory_Code__c')
                    + ' IN : tempTerritoryCodes '
                    + ' And STATDESC__c = \'Active\' '
                    );
		system.debug('setGAMAccountIds query ::: ' + ClsAPLForecastUtil.getQueryString(list_sql));
		for(Account acct : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
			set_acctIds.add(acct.Id);
		}
    }
   /**
    * This method is used to create a new interface instance
    *
    @author Bin Yuan
    @created 2014-06-02
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-02 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static ClsAPLInterface.IAPLFCService newClassInstance(String className){
        try{
            Type t = Type.forName(className);
            return (ClsAPLInterface.IAPLFCService) t.newInstance();
        }catch(Exception e){
            throw e;
        }
    }
    
   /**
    * This method is used to create a new interface instance
    *
    @author Bin Yuan
    @created 2014-06-02
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-02 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static ClsAPLInterface.IAPLRefDataService newRefDataInstance(String className){
        try{
            system.debug('className::: '+className);
            Type t = Type.forName(className);
            system.debug('t::: ' + t);
            return (ClsAPLInterface.IAPLRefDataService) t.newInstance();
        }catch(Exception e){
            throw e;
        }
    }
    
   /**
    * This method is used to create a new interface instance
    *
    @author Bin Yuan
    @created 2014-06-02
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-02 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static ClsAPLInterface.IAPLControllerService newCtrlInstance(String className){
        try{
            Type t = Type.forName(className);
            return (ClsAPLInterface.IAPLControllerService) t.newInstance();
        }catch(Exception e){
            throw e;
        }
    }
    
   /**
    * Method to set user locale.
    *
    @author Bin Yuan
    @created 2014-05-30
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-05-30 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void setUserLocale(ClsAPLEntityTypes.LocaleConfig localeConfig, String userLocale){
        try{
            localeConfig.locale= userLocale;
            list<String> list_s = localeConfig.locale.split('_');
            localeConfig.locale = list_s[0]+'-'+list_s[1];
        }catch(Exception e){
            localeConfig.locale = 'de-DE';
        }   
        localeConfig.jsPath = '/glob-cultures/cultures/globalize.culture.'+localeConfig.locale+'.js';
    }
    
   /**
    * This method is used to build query string by gaven string list
    *
    @author Bin Yuan
    @created 2014-06-02
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-02 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static String getQueryString(String [] params) {

        return (String.format('Select {0} From {1} {2} ', params));

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
        if(sourceValue == null){    //check source value
            return result;
        }

        String k = fromIsoCode + toIsoCode;
        if(map_convertionRate.containsKey(k)){  //check convertion reate contains
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
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'from :: ' + fromIsoCode +' :: ' + sourceValue + ' :: TO :: ' + toIsoCode + ' :: ' + result));
        return result;
    }
    
   /**
    * This method is used get the entire date range's start date and end date.
    *
    @author Bin Yuan
    @created 2014-03-27
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-27 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void setAllPeriodStartEndDate(map<String, Date> map_financialDate){   //set financial month
        
        for (Period period : [select StartDate from Period where StartDate <= Today and Type = 'Quarter' order by StartDate desc limit: QNUMBER]) {
            if(period.startDate != null && period.StartDate < map_financialDate.get('s')){
                map_financialDate.put('s', period.StartDate);
            }
        }
        
        for (Period period : [select EndDate from Period where EndDate >= Today and Type = 'Quarter' order by EndDate limit: FUTUREQNUMBER]) {
            if(period.EndDate != null && period.EndDate > map_financialDate.get('e')){
                map_financialDate.put('e', period.EndDate);
            }
        }                
        
    }
   /**
    * This method is used get the entire date range's start date and end date.
    *
    @author Bin Yuan
    @created 2014-03-27
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-27 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static String getCurrentYearQuart(){   //set financial month
        String year = '',
        	   quarter = '';
        //get quarter	   
        for (Period period : [select Number from Period where type='Quarter' and startdate <= today and enddate >= today]) {
            quarter = '0' + period.Number;
        }
        //get year	   
        for (Period period : [select FiscalYearSettings.name from Period where type='Year' and startdate <= today and enddate >= today]) {
            year = period.FiscalYearSettings.name;
        }
        return year + '_' + quarter;  
    }
    
   /**
    * This method is used get account hierarchy for current account manager.
    *
    @author Bin Yuan
    @created 2014-03-27
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-27 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void setFiscalMonth(ClsAPLEntityTypes.PageConfig pageConf){   //set current year & current month
        //just set pageConfig for one time
        if(pageConf.isSetupDone) {
            return;
        }
        pageConf.isSetupDone = true;
        map<String, Date> map_startAndEndDate = new map<String, Date>{'s' => system.today(), 'e' =>system.today()};
        //get the entire date range's start date and end date in map. 
        setAllPeriodStartEndDate(map_startAndEndDate);
        
        //get each fiscal month by using gaven start date and end date
        for (Period period : [select Id, FiscalYearSettings.Name, PeriodLabel 
                                from Period where StartDate<=Today and EndDate >=Today and Type = 'Month']) {
                                    
            if(period.FiscalYearSettings.Name != null){ //set current year
                pageConf.currentYear = period.FiscalYearSettings.Name;
            }
            if(period.PeriodLabel != null && MAP_MONTHLABELNUMBER.containsKey(period.PeriodLabel)){ //set current month
                pageConf.currentMonth = MAP_MONTHLABELNUMBER.get(period.PeriodLabel);
            }
        }
        
        for (Period period : [select Id, FiscalYearSettings.Name, PeriodLabel from Period 
                                where StartDate>= : map_startAndEndDate.get('s') 
                                and EndDate<=: map_startAndEndDate.get('e') and Type = 'Month']) {
                                    
            String fiscalDateKey = '';
            if(!pageConf.map_financialMonth.containsKey(period.FiscalYearSettings.Name)) {
                pageConf.map_financialMonth.put(period.FiscalYearSettings.Name, new Set<Integer>());
            }
            pageConf.map_financialMonth.get(period.FiscalYearSettings.Name).add(MAP_MONTHLABELNUMBER.get(period.PeriodLabel));
            fiscalDateKey = period.FiscalYearSettings.Name + '_' + MAP_MONTHLABELNUMBER.get(period.PeriodLabel);
            pageConf.set_dateKey.add(fiscalDateKey);
        }
        map_startAndEndDate.clear();
        
        //set current month index
        setCurrentMonthIndex(pageConf);
        
        //set currency rate  & price decimal Places
        if(APL_Forecast_Settings__c.getInstance('Price Decimal Places') != null 
            && APL_Forecast_Settings__c.getInstance('Price Decimal Places').Value__c != null) {
            pageConf.pricePlaces = (String) APL_Forecast_Settings__c.getInstance('Price Decimal Places').Value__c;
        }
        if(APL_Forecast_Settings__c.getInstance('Currency Rate Decimal Places') != null 
            && APL_Forecast_Settings__c.getInstance('Currency Rate Decimal Places').Value__c != null) {
            pageConf.currencyPlaces = (String) APL_Forecast_Settings__c.getInstance('Currency Rate Decimal Places').Value__c;
        }
    }
    
   /**
    * This method is used get account hierarchy for current account manager.
    *
    @author Bin Yuan
    @created 2014-03-27
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-27 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void setCurrentMonthIndex(ClsAPLEntityTypes.PageConfig pageConf) {
        
        list<String> list_years = new list<String>();
                             
        list_years.addAll(pageConf.map_financialMonth.keySet());    // set current month index
        list_years.sort();
        String lastYear = '';
        Integer lastMonth = 0;
        Date tempCurrentDate = Date.newInstance(Integer.valueOf(pageConf.currentYear), pageConf.currentMonth, 1);
        
        for (String year : list_years) {
            list<Integer> list_months = new list<Integer>();
            list_months.addAll(pageConf.map_financialMonth.get(year));
            list_months.sort();
            lastYear = year;
            for (Integer month : list_months) {
                String str_month = (month <= 9 ? '0' + String.valueOf(month) : String.valueOf(month));
                pageConf.periodStartDate = (pageConf.periodStartDate == '' ? year + '-' + str_month + '-01' : pageConf.periodStartDate);
                pageConf.list_yearMonth.add(year + '_' + month);
                Date tempDate = Date.newInstance(Integer.valueOf(year), month, 1);
                if(pageConf.currentYear == year && pageConf.currentMonth == month) {
                    pageConf.quarterNumb = 'Q' + String.valueOf((math.mod(month, 3) == 0 ? (month / 3) : (month / 3) + 1 ));
                    pageConf.currentMonthIndex = pageConf.list_yearMonth.size();
                }
                else if(tempDate < tempCurrentDate) {
                    //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'list_months :: '+ list_months));
                    if(!pageConf.map_year_monthsHistory.containsKey(year)) {
                        pageConf.map_year_monthsHistory.put(year, new set<Integer>());
                    }
                    pageConf.map_year_monthsHistory.get(year).add(month);
                }
                lastMonth = month;
            }
        }
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'lastYear :: lastMonth :: ' + lastYear   + ' ' + lastMonth));
        //set reference data query start date and end date
        pageConf.refStartDate = pageConf.currentYear + '-' + (pageConf.currentMonth <= 9 ? '0' 
                                + String.valueOf(pageConf.currentMonth) : String.valueOf(pageConf.currentMonth)) + '-01';
        pageConf.refEndDate = (lastMonth == 12 ? String.valueOf((Integer.valueOf(lastYear) + 1)) + '-01-01' 
                                : lastYear + '-' + (lastMonth <= 8 ? '0' + String.valueOf((lastMonth + 1)) : String.valueOf((lastMonth + 1))) + '-01');
        pageConf.str_historyMonthMap = Json.serialize(pageConf.map_year_monthsHistory);
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'pageConf.refEndDate :: ' + pageConf.refEndDate));
    }
    
    
   /**
    * This method is used get account hierarchy for current account manager.
    *
    @author Bin Yuan
    @created 2014-03-27
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-27 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void createDateItem(ClsAPLEntityTypes.PageConfig pageConf, list<ClsAPLEntityTypes.DateItem> list_allDateItems) {
        
        String str_monthLabel = '';
        String str_qLabel = '';
        String str_mLabel = '';
        String str_yearLabel = '';
        Integer monthCounter = 0;
        ClsAPLEntityTypes.DateItem tempDateItem;
        String temp_qMonths = '';
        //generate table header for history, current and future date type
        pageConf.str_tableHead = ((pageConf.str_tableHead == null || pageConf.str_tableHead == '')
                                    ? '<th class="fixthh th_historicalc tl" colspan="16" style="height: 0px !important;"><div class="fix_lh historicalc">' + system.label.APL_Forecast_Header_Label_History + '</div></th>'
                                    + '<th class="fixthh th_current tl" old="4" colspan="4"><div class="fix_lh current_cls"><div class="absdiv">' + system.label.APL_Forecast_Header_Label_Current + '</div></div></th>'
                                    + '<th class="fixthh th_futurec futurec tl" colspan="999" ><div class="fix_lh head_futurec">' + system.label.APL_Forecast_Header_Label_Future + '</div></th>' : pageConf.str_tableHead);

        for(Integer i = 1; i <= 33; i++) {
            
            if (i == 1) {
                tempDateItem = new ClsAPLEntityTypes.DateItem('Historical Data');
                tempDateItem.type = 'historicalc';
            }
            else if (i == 13) {
                tempDateItem = new ClsAPLEntityTypes.DateItem('Current Month');
                tempDateItem.cls = 'none';
                tempDateItem.type = 'currentc cfixw';
            }
            else if (i == 16){
                tempDateItem = new ClsAPLEntityTypes.DateItem('Future Plan');
                tempDateItem.cls = 'none';
                tempDateItem.type = 'futurec';
            }
            //generate history and current type month date item
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
            String str_yearFullLabel = str_yearLabel;
            temp_qMonths += ((temp_qMonths == ''? '' : ',') + str_yearFullLabel + '_' + monthCounter);
            //set data item month label format 2014-3
            str_mLabel = str_yearFullLabel + '_' + monthCounter;
            
            str_yearLabel = 'FY' + str_yearLabel.subString(2);
            
            str_monthLabel = MAP_NUMBERMONTHLABEL.get(monthCounter);
            if(i <= 15) {
                ClsAPLEntityTypes.DateItem tempMonthItem = new ClsAPLEntityTypes.DateItem('');
                tempMonthItem.type2 = 'cfixmonthw';
                tempMonthItem.type3 = 'totalbg';
                tempMonthItem.itemName = str_monthLabel + ' / ' + str_yearLabel;
                tempMonthItem.monthCls = 'monthCls';
                if (i < pageConf.currentMonthIndex) {
                    Integer t = (i - pageConf.currentMonthIndex);
                    tempMonthItem.type = '';
                    if(t == -1 || t == -2 || t == -3){
                        tempMonthItem.type += ' cm'+t+' ';
                    }
                }
                else if (i == pageConf.currentMonthIndex) {
                    tempMonthItem.isInput = false;
                    tempMonthItem.type = 'currentc ' ;
                    tempMonthItem.type1 = 'current_fixcls';
                    tempMonthItem.type2 = 'cfixcurentmonthw';
                }
                else {
                    Integer t = 0;
                    if (i == pageConf.currentMonthIndex + 1) {
                        t = 0;
                    }
                    else {
                        t = (i - pageConf.currentMonthIndex - 1);        
                    }
                    tempMonthItem.isInput = false;
                    tempMonthItem.type = '';
                    if(t == 0 || t == 1 || t == 2){
                        tempMonthItem.type += ' _cnm'+t+' ';
                    }
                }    
                String ymStr = pageConf.list_yearMonth.get(i - 1);
                tempMonthItem.fYear = ymStr.subString(0, ymStr.indexOf('_'));
                tempMonthItem.fMonth = Integer.valueOf(ymStr.subString(ymStr.indexOf('_') + 1));
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'tempMonthItem :: ' + tempMonthItem));
                tempMonthItem.mLabel = str_mLabel;
                list_allDateItems.add(tempMonthItem); 
            }
            if(i >= pageConf.currentMonthIndex) {
                if(!pageConf.map_year_monthsFuture.containsKey(str_yearFullLabel)) {
                    pageConf.map_year_monthsFuture.put(str_yearFullLabel, new set<Integer>());
                }
                pageConf.map_year_monthsFuture.get(str_yearFullLabel).add(monthCounter);
            }
            //generate quarterly date item
            String quarterCounter = '';
            if (Math.mod(i, 3) == 0) {
                if(monthCounter == 3) {
                    quarterCounter = 'Q1';
                    str_qLabel = 'Q1' + ' / ' + str_yearLabel;
                }
                else if(monthCounter == 6) {
                    quarterCounter = 'Q2';
                    str_qLabel = 'Q2' + ' / ' + str_yearLabel;
                }
                else if(monthCounter == 9) {
                    quarterCounter = 'Q3';
                    str_qLabel = 'Q3' + ' / ' + str_yearLabel;
                }
                else if(monthCounter == 12) {
                    quarterCounter = 'Q4';
                    str_qLabel = 'Q4' + ' / ' + str_yearLabel;
                }
                
                ClsAPLEntityTypes.DateItem tempTotalItem = new ClsAPLEntityTypes.DateItem(str_qLabel);
                tempTotalItem.qtotalCls = ('qtotalCls' + (i <= 15 ? ' exp_coll ' : ' '));
                tempTotalItem.qtotalCls += (i == 15 ? ' crtQtotal ' : ' ');
                tempTotalItem.qMonths = temp_qMonths;
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'tempTotalItem :: '+ tempTotalItem));
                temp_qMonths = '';
                //DateItem tempTotalItem = new DateItem('Q Total');
                tempTotalItem.total = 'q' + i / 3;
                if (i < pageConf.currentMonthIndex) {
                    tempTotalItem.type = ('historicalc ' + (tempDateItem.type == 'currentc cfixw' ? 'currentc' : tempDateItem.type) + '1');
                }
                else {
                    tempTotalItem.type = ('futurec ' + (tempDateItem.type == 'currentc cfixw' ? 'currentc' : tempDateItem.type) + '1');
                }       
                tempTotalItem.type += ' cfixqtotalw';
                tempTotalItem.type2 = 'cfixqtotalw';
                tempTotalItem.isInput = (i >= 15 ? true : false);
                tempTotalItem.qLabel = str_yearFullLabel + '_' + quarterCounter.replace('Q', '0');
                
                if(i >= 15) {
                    if(!pageConf.map_year_quartersFuture.containsKey(str_yearFullLabel)) {
                        pageConf.map_year_quartersFuture.put(str_yearFullLabel, new set<String>());
                    }
                    pageConf.map_year_quartersFuture.get(str_yearFullLabel).add(quarterCounter.replace('Q', '0'));
                }
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'tempTotalItem :: ' + tempTotalItem));
                list_allDateItems.add(tempTotalItem); 
            }
        }
        pageConf.str_futureQuarterMap = Json.serialize(pageConf.map_year_quartersFuture);
        pageConf.str_futureMonthMap = Json.serialize(pageConf.map_year_monthsFuture);
        //clear map
    }
    
   /**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static String getMonthFilter(map<String, Set<String>> map_year_quarter) {
        if(map_year_quarter == null || map_year_quarter.isEmpty()) {
            return '';
        }
        string monthFilter = ' And ';
        if(map_year_quarter != null && map_year_quarter.size() > 0) {
            monthFilter += '(';
            for (string year : map_year_quarter.keySet()) {
                if(year != 'null') {
                    monthFilter += '(Fiscal_Year__c = \'' + year +'\'';
                    if(map_year_quarter.get(year) != null && map_year_quarter.get(year).size() > 0) {
                        monthFilter += ' AND Fiscal_Quarter__c IN (';
                        for(String quarter : map_year_quarter.get(year)) {
                            monthFilter += '\'' + quarter + '\', ';
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
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static String getCustomRequestMonthFilter(map<String, set<Integer>> map_financialMonth) {
        if(map_financialMonth == null || map_financialMonth.isEmpty()) {
            return '';
        }
        string monthFilter = ' And ';
        if(map_financialMonth != null && map_financialMonth.size() > 0) {
            monthFilter += '(';
            for (string year : map_financialMonth.keySet()) {
                if(year != 'null') {
                    monthFilter += '(Customer_Request_Date_Fiscal_Year__c = \'' + year +'\'';
                    if(map_financialMonth.get(year) != null && map_financialMonth.get(year).size() > 0) {
                        monthFilter += ' AND Customer_Request_Date_Fiscal_Month__c IN (';
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
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static map<String, set<Integer>> getFiscalMonthMap(list<String> list_dateKey) {
        map<String, set<Integer>> map_financialMonth = new map<String, set<Integer>>();
        for(String dateKey : list_dateKey) {
            String year = dateKey.subStringBefore('_');
            Integer month = Integer.valueOf(dateKey.subStringAfter('_'));
            if(!map_financialMonth.containsKey(year)) {
                map_financialMonth.put(year, new set<Integer>());
            }
            map_financialMonth.get(year).add(month);
        }
        return map_financialMonth;
    }
    
   /**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static String getFiscalMonthFilter(map<String, set<Integer>> map_financialMonth) {
        if(map_financialMonth == null || map_financialMonth.isEmpty()) {
            return '';
        }
        string monthFilter = ' And ';
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
    * This method is used to get the children account billing percent
    *
    @author Lili Zhao
    @created 2014-05-23
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-05-23 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static void aplFCRecordsDML(list<APL_Sales_Forecast__c> list_acctFC2Insert, 
                                       list<APL_Sales_Forecast__c> list_acctFC2Update,
                                       list<APL_Sales_Forecast__c> list_acctFC2Delete) {
        if(!list_acctFC2Insert.isEmpty()) {
            insert list_acctFC2Insert;
        }
        if(!list_acctFC2Update.isEmpty()) {
            update list_acctFC2Update;
        }
        //????? remove dirty records for current parents 
        if(!list_acctFC2Delete.isEmpty()) {
            //delete list_acctFC2Delete;
        }
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
    public static void calcPercentage(map<String, decimal> map_key_percent, decimal totalAmount, boolean isAVG) {
        decimal remaining = 1;
        if(map_key_percent.isEmpty()) {
            return;
        } 
        Integer indicator = 1;
        for(String key : map_key_percent.keySet()) {
            decimal percent = (totalAmount == 0 ? (isAVG ? 1.0 / map_key_percent.size() : 0) : map_key_percent.get(key) / totalAmount);
            percent = percent.setScale(2);
            if(isAVG && indicator == map_key_percent.size()) {
                map_key_percent.put(key, remaining);
            }
            else {
                map_key_percent.put(key, percent);
            }
            remaining = remaining - percent;
            indicator ++;
        }
    }
    
   /**
    * This method is used get account hierarchy for current account manager.
    *
    @author Bin Yuan
    @created 2014-03-27
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-27 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static String getCBCKeyName(String cbc2Name, String cbc3Name) {

        if(map_CBC2ID_CBC2NAME.containsKey(cbc2Name)) {
            return cbc2Name;
        }
        
        for(String field : map_RELAY_CBCFIELD_CBCDESC.keySet()) {
            for(String cbcValue : map_RELAY_CBCFIELD_CBCDESC.get(field)) {
                
                if(cbc2Name == cbcValue || cbc3Name == cbcValue) {
                    return CBCRELAY;
                }
            }
        }
        return CBCOTHER;
    }
    
   /**
    * This method is used get account hierarchy for current account manager.
    *
    @author Bin Yuan
    @created 2014-03-27
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-27 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void setResultMap(AggregateResult result, String str_mapKey, String dateKey, 
                                     map<String, map<String, AggregateResult>> map_key_map_dateKey_result) {
        if(!map_key_map_dateKey_result.containsKey(str_mapKey)) {
            map_key_map_dateKey_result.put(str_mapKey, new map<String, AggregateResult>());
        }
        if(!map_key_map_dateKey_result.get(str_mapKey).containsKey(dateKey)) {
            map_key_map_dateKey_result.get(str_mapKey).put(dateKey, result);
        }
    }
    
   /**
    * This method is used to get GPLs for CBC2
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
    public static String getRelayGPLQuery(boolean isProdHierchary) {
        String str_relayQuery = 'And ( TEMP ) ';
        String tempQuery = '';
        for(String cbcField : map_RELAY_CBCFIELD_CBCDESC.keySet()) {
            for(String cbcName : map_RELAY_CBCFIELD_CBCDESC.get(cbcField)) {
                tempQuery += ((isProdHierchary ? '' : 'GPL__r.') + cbcField + ' = '
                                + ' \'' + cbcName + '\' ' + ' OR ' ); 
            }
        }
        tempQuery = tempQuery.removeEnd('OR ');
        str_relayQuery = str_relayQuery.replace('TEMP', tempQuery);
        return str_relayQuery;
    }
    
   /**
    * This method is used to get GPLs for CBC2
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
    public static String getRelayPartQuery() {
        String str_relayQuery = 'And ( TEMP ) ';
        String tempQuery = '';
        for(String cbcField : map_RELAY_CBCFIELD_CBCDESC.keySet()) {
            for(String cbcName : map_RELAY_CBCFIELD_CBCDESC.get(cbcField)) {
                tempQuery += ('Part__r.Product_Hierarchy__r.' + cbcField + ' = '
                                + ' \'' + cbcName + '\' ' + ' OR ' ); 
            }
        }
        tempQuery = tempQuery.removeEnd('OR ');
        str_relayQuery = str_relayQuery.replace('TEMP', tempQuery);
        return str_relayQuery;
    }
    
   /**
    * This method is used to get GPLs for CBC2
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
    public static String getNoneRelayPartQuery() {
        String str_relayQuery = 'And ( TEMP ) ';
        String tempQuery = '';
        for(String cbcField : map_RELAY_CBCFIELD_CBCDESC.keySet()) {
            for(String cbcName : map_RELAY_CBCFIELD_CBCDESC.get(cbcField)) {
                tempQuery += ('Part__r.Product_Hierarchy__r.' + cbcField + ' != '
                                + ' \'' + cbcName + '\' ' + ' And ' ); 
            }
        }
        tempQuery = tempQuery.removeEnd('And ');
        str_relayQuery = str_relayQuery.replace('TEMP', tempQuery);
        return str_relayQuery;
    }
    
   /**
    * This method is used to get GPLs for CBC2
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
    public static String getOtherPartQuery() {
        String str_otherQuery = '( TEMP ) ';
        String tempQuery = '';
        for(String cbcField : map_RELAY_CBCFIELD_CBCDESC.keySet()) {
            for(String cbcName : map_RELAY_CBCFIELD_CBCDESC.get(cbcField)) {
                tempQuery += (' Part__r.Product_Hierarchy__r.' + cbcField + ' != ' 
                                + ' \'' + cbcName + '\' ' + ' And ' ); 
            }
        }
        
        for(String cbc2Code : map_CBC2ID_CBC2NAME.keySet()) {
            tempQuery += ' Part__r.Product_Hierarchy__r.CBC2__c != \'' + cbc2Code + '\' And ';
        }
        tempQuery += ' Type__c = \'Part\' ';
        str_otherQuery = str_otherQuery.replace('TEMP', tempQuery);
        return str_otherQuery;
    }
    
    /**
    * This method is used get account cbc forecast
    * 
    *
    @author Lei Tang
    @created 2014-06-03
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *@param FCInfo request - parentId is AccountId
    *@return FCResults - include APL_Sales_Forecast__c list
    *
    @changelog
    * 2014-06-0-3 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public static void setGPLCode(map<String, String> map_prodHichyId_gplCode, String cbcCode, 
                                    map<String, String> map_gplId_gplName) {
        list<String> list_sql = new list<String>();                                 
        //get all gpls info under this cbc
        list_sql.add(' Id, GPL_Description__c, Name ');
        list_sql.add(' Product_Hierarchy__c ');
        list_sql.add(' Where CBC1_Description__c = \'Appliances\' '
                   + (cbcCode == ClsAPLForecastUtil.CBCRELAY ? ClsAPLForecastUtil.getRelayGPLQuery(true) : ' And CBC2__c =\'' + cbcCode + '\' ')
        );
        for(Product_Hierarchy__c prodHchy : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            if(prodHchy.GPL_Description__c != null) {
                map_prodHichyId_gplCode.put(prodHchy.Id, prodHchy.Name);
                map_gplId_gplName.put(prodHchy.Id, prodHchy.GPL_Description__c);
            }
        }
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
    public static void generateFC(map<String, decimal> map_acctId_billingPercent, map<String, decimal> map_dateKey_fc,
                                    map<String, map<String, APL_Sales_Forecast__c>> map_acctId_map_dateKey_fc, 
                                    String fcType, String gplId, String partId, String currencyIso, 
                                    boolean isAM, boolean isGAM, boolean isRSM,
                                    list<APL_Sales_Forecast__c> list_acctFC2Insert,
                                    list<APL_Sales_Forecast__c> list_acctFC2Update, 
                                    list<APL_Sales_Forecast__c> list_acctFC2Delete) {
        
        set<String> set_updatedAcctFCIds = new set<String>();
        
        if(map_acctId_map_dateKey_fc == null) {
            map_acctId_map_dateKey_fc = new map<String, map<String, APL_Sales_Forecast__c>>();
        }
        //create or update account forecast records
        for(String acctId : map_acctId_billingPercent.keySet()) {
            for(String dateKey : map_dateKey_fc.keySet()) {
                //if has such account percent will not generate apl forecast record for this account
                if(!map_acctId_billingPercent.containsKey(acctId)) {
                    continue;
                }
                String year = dateKey.substringBefore('_');
                String quarter = dateKey.substringAfter('_');
                decimal fc = map_dateKey_fc.get(dateKey);
                decimal percent = map_acctId_billingPercent.get(acctId);
                fc = fc * percent;
                APL_Sales_Forecast__c acctFC;
                if(map_acctId_map_dateKey_fc.containsKey(acctId) 
                    && map_acctId_map_dateKey_fc.get(acctId).containsKey(dateKey)) {
                
                    acctFC = map_acctId_map_dateKey_fc.get(acctId).get(dateKey);
                    if(isAM) {
                        acctFC.Forecast__c = fc;
                        acctFC.GAM_Forecast__c = fc;
                        acctFC.RSM_Forecast__c = fc;
                    }
                    if(isGAM) {
                        acctFC.GAM_Forecast__c = fc;
                        acctFC.RSM_Forecast__c = fc;
                    }
                    if(isRSM) {
                        acctFC.RSM_Forecast__c = fc;
                    }
                    acctFC.currencyIsoCode = currencyIso;
                    acctFC.GPL__c = ((gplId != null && gplId != 'null' && gplId != '')? gplId : null);
                    list_acctFC2Update.add(acctFC);
                    set_updatedAcctFCIds.add(acctFC.Id);
                    system.debug('acctFC u ::' + acctFC);
                }
                else {
                    acctFC = new APL_Sales_Forecast__c();
                    acctFC.currencyIsoCode = currencyIso;
                    acctFC.Customer__c = acctId;
                    acctFC.Type__c = fcType;
                    acctFC.Fiscal_Year__c = year;
                    acctFC.Fiscal_Quarter__c = quarter;
                    if(isAM) {
                        acctFC.Forecast__c = fc;
                        acctFC.GAM_Forecast__c = fc;
                        acctFC.RSM_Forecast__c = fc;
                    }
                    if(isGAM) {
                        acctFC.GAM_Forecast__c = fc;
                        acctFC.RSM_Forecast__c = fc;
                    }
                    if(isRSM) {
                        acctFC.RSM_Forecast__c = fc;
                    }
                    acctFC.GPL__c = ((gplId != null && gplId != 'null' && gplId != '')? gplId : null);
                    acctFC.Part__c = ((fcType == PARTFCTYPE || fcType == RELAYFCTYPE) ? partId : null);
                    list_acctFC2Insert.add(acctFC);
                    system.debug('acctFC i ::' + acctFC);
                }
                
            }
        }
        //check forecast records to remove
        for(String acctId : map_acctId_map_dateKey_fc.keySet()) {
            for(APL_Sales_Forecast__c aplFC : map_acctId_map_dateKey_fc.get(acctId).values()) {
                if(!set_updatedAcctFCIds.contains(aplFC.Id)) {
                    list_acctFC2Delete.add(aplFC);
                }
            }
        }
        
    }
    
    /**
    * This method is used to get the children account billing percent
    *
    @author Lili Zhao
    @created 2014-05-23
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-05-23 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static void getChildrenAccts(String parentId, String territoryCode, set<String> set_acctIds, boolean isForRelay) {
        list<String> list_sql = new list<String>();
        
        list_sql.add(' Id ');
        list_sql.add(' Account ');
        list_sql.add(' WHERE ' + (isForRelay ? 'APL_Relay_forecast_Plan_Account__c' : 'APL_AM_forecast_Plan_Account__c') + ' = ' 
                    + (parentId == ClsAPLForecastUtil.OTHERACCTID ? ' null ' : '\'' +  parentId + '\' ') 
                    + ' And ' + (isForRelay ? 'Relay_Specialist_Territory_Code__c' : 'SALES_TERRITORY_CDE__c') 
                    + ' = \'' + territoryCode + '\' ');
                    
        for(Account acct : database.query(getQueryString(list_sql))) {
            set_acctIds.add(acct.Id);
        }
    }
    
    /**
    * This method is used to get the children account billing percent
    *
    @author Lili Zhao
    @created 2014-05-23
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-05-23 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static String getStartDate(String dateKey) {
        String startDate = dateKey.subStringBefore('_') 
                        + (Integer.valueOf(dateKey.subStringAfter('_')) < 10 
                            ? '-0' + dateKey.subStringAfter('_') 
                            : '-' + dateKey.subStringAfter('_'))
                        + '-01';
        return startDate;
    }    
    
    /**
    * This method is used to get the children account billing percent
    *
    @author Lili Zhao
    @created 2014-05-23
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-05-23 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static String getEndDate(String dateKey) {
        String endYear = dateKey.subStringBefore('_'),
               endMonth = dateKey.subStringAfter('_'),
               endDate;
        
        endYear = (endMonth == '12' ? String.valueOf(Integer.valueOf(endYear) + 1) : endYear);
        endMonth = ((Integer.valueOf(endMonth) + 1) < 10 ? '0' + (Integer.valueOf(endMonth) + 1) : (Integer.valueOf(endMonth) + 1) + '');
        endMonth = (endMonth == '13' ? '01' : endMonth);
        endDate = endYear + '-' + endMonth + '-01';
        return endDate;
    }    
    
    
    /**
    * This method is used to get the children account billing percent
    *
    @author Lili Zhao
    @created 2014-05-23
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-05-23 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static void getDividedFiscalMap(Date currentDate, list<String> list_dateKey, 
                                                map<String, set<Integer>> map_history, map<String, set<Integer>> map_future) {
        for(String dateKey : list_dateKey) {
            String year = dateKey.subStringBefore('_');
            String month = dateKey.subStringAfter('_');
            Date divideDate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 1);
            if(currentDate > divideDate) {
                if(!map_history.containsKey(year)) {
                    map_history.put(year, new set<Integer>());
                }
                map_history.get(year).add(Integer.valueOf(month));
            }
            else {
                if(!map_future.containsKey(year)) {
                    map_future.put(year, new set<Integer>());
                }
                map_future.get(year).add(Integer.valueOf(month));
            }
        }
    }    
    
    /**
    * This method is used to apl previous month forecast
    *
    @author Lili Zhao
    @created 2014-07-18
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-07-18 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static void setAPLPrevFC(list<APL_Sales_Forecast__c> list_apls, String currentYear, Integer currentQuarter) {   
        for(APL_Sales_Forecast__c apl : list_apls){   
            Integer previous;
            Integer quarter = Integer.valueOf(apl.Fiscal_Quarter__c);

            String yearPlus1 = String.valueOf(Integer.valueOf(currentYear) + 1);
            String yearPlus2 = String.valueOf(Integer.valueOf(currentYear) + 2);

            if(apl.Fiscal_Year__c == currentYear){
                previous = quarter - currentQuarter;
            }else if(apl.Fiscal_Year__c == yearPlus1) {
                previous = 4 + quarter - currentQuarter;
            }else if(apl.Fiscal_Year__c == yearPlus2) {
                previous = 8 + quarter - currentQuarter;
            }
            system.debug('previous::: '+previous);
            apl.Current_month_1_forecast__c = apl.forecast__c;
            apl.Current_month_1_price__c = apl.Price__c;
            apl.Current_month_1_quantity__c = apl.Quantity__c;

            apl.Current_month_1_RSM_forecast__c = apl.RSM_Forecast__c;
            apl.Current_month_1_RSM_price__c = apl.RSM_Price__c;
            apl.Current_month_1_RSM_quantity__c = apl.RSM_Quantity__c;  
            
            apl.Current_month_1_GAM_forecast__c = apl.GAM_Forecast__c;
            
            if(previous > 1 && previous <= 13) {      
                apl.put('Current_month_' + previous + '_forecast__c', apl.Forecast__c);
                apl.put('Current_month_' + previous + '_price__c', apl.Price__C);
                apl.put('Current_month_' + previous + '_quantity__c', apl.Quantity__c);
                                
                apl.put('Current_month_' + previous + '_RSM_forecast__c', apl.RSM_Forecast__c);
                apl.put('Current_month_' + previous + '_RSM_price__c', apl.RSM_Price__C);
                apl.put('Current_month_' + previous + '_RSM_quantity__c', apl.RSM_Quantity__c);
                
                apl.put('Current_month_' + previous + '_GAM_forecast__c', apl.GAM_Forecast__c);
            }               
        }      
    }
    
    
    /**
    * This method is used to apl previous month forecast
    *
    @author Lili Zhao
    @created 2014-07-18
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-07-18 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static void setAPLPrevFCNew(list<APL_Sales_Forecast__c> list_apls) {   
    	decimal currencyRate = 0;
        for(APL_Sales_Forecast__c apl : list_apls){ 
        	currencyRate = ClsAPLForecastUtil.transformIsoCode(1, apl.CurrencyIsoCode, 'USD');
        	for(Integer i = 13; i >= 2; i-- ) {
        		Integer previous = i-1;
        		apl.put('Current_month_' + i + '_forecast__c', apl.get('Current_month_' + previous + '_forecast__c'));
                apl.put('Current_month_' + i + '_price__c', apl.get('Current_month_' + previous + '_price__c'));
                apl.put('Current_month_' + i + '_quantity__c', apl.get('Current_month_' + previous + '_quantity__c'));
                apl.put('Current_month_' + i + '_RSM_forecast__c', apl.get('Current_month_' + previous + '_RSM_forecast__c'));
                apl.put('Current_month_' + i + '_RSM_price__c', apl.get('Current_month_' + previous + '_RSM_price__c'));
                apl.put('Current_month_' + i + '_RSM_quantity__c', apl.get('Current_month_' + previous + '_RSM_quantity__c'));
                apl.put('Current_month_' + i + '_GAM_forecast__c', apl.get('Current_month_' + previous + '_GAM_forecast__c'));
        	}
        	apl.Current_month_1_forecast__c = apl.forecast__c == null ? apl.forecast__c : apl.forecast__c * currencyRate;
            apl.Current_month_1_price__c = apl.Price__c == null ? apl.Price__c : apl.Price__c * currencyRate;
            apl.Current_month_1_quantity__c = apl.Quantity__c;
            apl.Current_month_1_RSM_forecast__c = apl.RSM_Forecast__c;
            apl.Current_month_1_RSM_price__c = apl.RSM_Price__c;
            apl.Current_month_1_RSM_quantity__c = apl.RSM_Quantity__c;  
            apl.Current_month_1_GAM_forecast__c = apl.GAM_Forecast__c;
             
        }      
    }
    
    
    /**
    * This method is used to apl previous month RSM Overall forecast
    *
    @author Lili Zhao
    @created 2014-07-18
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-07-18 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static void setAPLRSMOverallPrevFC(List<APL_RSM_Overall_Forecast__c> list_aplRSMForecasts, String currentYear, Integer currentQuarter) {   
        for(APL_RSM_Overall_Forecast__c apl : list_aplRSMForecasts){   
            Integer previous;
            Integer quarter = Integer.valueOf(apl.Fiscal_Quarter__c);

            String yearPlus1 = String.valueOf(Integer.valueOf(currentYear) + 1);
            String yearPlus2 = String.valueOf(Integer.valueOf(currentYear) + 2);

            if(apl.Fiscal_Year__c == currentYear){
                previous = quarter - currentQuarter;
            }else if(apl.Fiscal_Year__c == yearPlus1) {
                previous = 4 + quarter - currentQuarter;
            }else if(apl.Fiscal_Year__c == yearPlus2) {
                previous = 8 + quarter - currentQuarter;
            }
            system.debug('previous::: '+previous);
            apl.Current_1_Overall_Forecast__c = apl.RSM_Overall_Forecast__c;
            apl.Current_1_RR_Overall_Forecast__c = apl.Relay_RSM_Overall_Forecast__c;
            
            if(previous > 1 && previous <= 6) {      
                apl.put('Current_' + previous + '_Overall_Forecast__c', apl.RSM_Overall_Forecast__c);
                apl.put('Current_' + previous + '_RR_Overall_Forecast__c', apl.Relay_RSM_Overall_Forecast__c);
            }               
        }      
    }
    
    /**
    * This method is used to apl previous month RSM Overall forecast
    *
    @author Lili Zhao
    @created 2014-07-18
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-07-08 Lei Tang <lei.tang@itbconsult.com>
    * - Modify :add "Relay_CBC2_Code__c,PRODUCT_CDE__c,PROD_NAME__c"
    * 2014-07-18 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created   
    */
    public static void calcAPLNextQuarterForecast(list<APL_Sales_Forecast__c> list_aplFCs, String currentDateKey, String nextQuarterDateKey,
                                                    String perv_1_QuarterDateKey, String current_prev_4_QuarterDateKey, set<String> set_dateKeys,
                                                    String prev_1_prev_4_QuarterDateKey, String next_prev_4_QuarterDateKey) {
        
        list<APL_Sales_Forecast__c> list_newAPLFCs = new list<APL_Sales_Forecast__c>();                                             
        set<String> set_acctIds = new set<String>();
        map<String, set<String>> map_year_set_quarters = new map<String, set<String>>();
        String strNull = 'NULL';
        String query = '';
        map<String, map<String, map<String, map<String, map<String, APL_Sales_Forecast__c>>>>> map_acctId_fcType_gpl_part_dateKey_fc
            = new map<String, map<String, map<String, map<String, map<String, APL_Sales_Forecast__c>>>>>();
        
        //loop to generate apl fc records into map
        for(APL_Sales_Forecast__c fc : list_aplFCs) {
            set_acctIds.add(fc.Customer__c);
        }
        //get fiscal date filters
        for(String dateKey : set_dateKeys) {
            String year = dateKey.subStringBefore('_');
            String quarter = dateKey.subStringAfter('_');
            if(!map_year_set_quarters.containsKey(year)) {
                map_year_set_quarters.put(year, new set<String>());
            }
            map_year_set_quarters.get(year).add(quarter);
        }
        
        //query related fc records      
        query = ' Select Id, Customer__c, GPL__c, Part__c, Type__c, Quantity__c, Price__c, '
              + ' RSM_Price__c, RSM_Quantity__c, RSM_Forecast__c, GAM_Forecast__c, Forecast__c, '
              + ' Fiscal_Year__c, Fiscal_Quarter__c, CurrencyIsoCode'
              //add by Lei Tang 2015-07-08
              + ' ,Relay_CBC2_Code__c, PRODUCT_CDE__c, PROD_NAME__c '
              + ' From APL_Sales_Forecast__c '
              + ' where Customer__c in : set_acctIds '
              + getMonthFilter(map_year_set_quarters);
        
        
        system.debug('query ::: ' + query);
        
        //get related fc records
        for(APL_Sales_Forecast__c fc : database.query(query)) {
            String acctId = fc.Customer__c;
            String fcType = fc.Type__c;
            String gplId = (fc.GPL__c == null ? (fc.Relay_CBC2_Code__c == null ? strNull : fc.Relay_CBC2_Code__c) : fc.GPL__c);
            String partId = (fc.Part__c == null ? (fc.PRODUCT_CDE__c == null ? strNull : fc.PRODUCT_CDE__c) : fc.Part__c);
            String dateKey = fc.Fiscal_Year__c + '_' + fc.Fiscal_Quarter__c;
            
            if(!map_acctId_fcType_gpl_part_dateKey_fc.containsKey(acctId)) {
                map_acctId_fcType_gpl_part_dateKey_fc.put(acctId, new map<String, map<String, map<String, map<String, APL_Sales_Forecast__c>>>>());
            }
            if(!map_acctId_fcType_gpl_part_dateKey_fc.get(acctId).containsKey(fcType)) {
                map_acctId_fcType_gpl_part_dateKey_fc.get(acctId).put(fcType, new map<String, map<String, map<String, APL_Sales_Forecast__c>>>());
            }
            if(!map_acctId_fcType_gpl_part_dateKey_fc.get(acctId).get(fcType).containsKey(gplId)) {
                map_acctId_fcType_gpl_part_dateKey_fc.get(acctId).get(fcType).put(gplId, new map<String, map<String, APL_Sales_Forecast__c>>());
            }
            if(!map_acctId_fcType_gpl_part_dateKey_fc.get(acctId).get(fcType).get(gplId).containsKey(partId)) {
                map_acctId_fcType_gpl_part_dateKey_fc.get(acctId).get(fcType).get(gplId).put(partId, new map<String, APL_Sales_Forecast__c>());
            }
            if(!map_acctId_fcType_gpl_part_dateKey_fc.get(acctId).get(fcType).get(gplId).get(partId).containsKey(dateKey)) {
                map_acctId_fcType_gpl_part_dateKey_fc.get(acctId).get(fcType).get(gplId).get(partId).put(dateKey, fc);
            }
        }
        
        //loop next_prev_4_Quarter fc records as base to generate next quarter fc 
        String nextYear = nextQuarterDateKey.subStringBefore('_');
        String nextQuarter = nextQuarterDateKey.subStringAfter('_');
        for(APL_Sales_Forecast__c baseFC : list_aplFCs) {
            String acctId = baseFC.Customer__c;
            String fcType = baseFC.Type__c;
            String gplId = (baseFC.GPL__c == null ? (baseFC.Relay_CBC2_Code__c == null ? strNull : baseFC.Relay_CBC2_Code__c) : baseFC.GPL__c);
            String partId = (baseFC.Part__c == null ? (baseFC.PRODUCT_CDE__c == null ? strNull : baseFC.PRODUCT_CDE__c) : baseFC.Part__c);
            String dateKey = baseFC.Fiscal_Year__c + '_' + baseFC.Fiscal_Quarter__c;
            
            APL_Sales_Forecast__c fc = new APL_Sales_Forecast__c();
            fc.Fiscal_Year__c = nextYear;
            fc.Fiscal_Quarter__c = nextQuarter;
            fc.CurrencyIsoCode = baseFC.CurrencyIsoCode;
            fc.Type__c = baseFC.Type__c;
            fc.Customer__c = baseFC.Customer__c;
            fc.GPL__c = baseFC.GPL__c;
            fc.Part__c = baseFC.Part__c;
            fc.Price__c = baseFC.Price__c;
            fc.Relay_CBC2_Code__c = baseFC.Relay_CBC2_Code__c;
            fc.PRODUCT_CDE__c = baseFC.PRODUCT_CDE__c;
            fc.PROD_NAME__c = baseFC.PROD_NAME__c;
            fc.RSM_Price__c = baseFC.RSM_Price__c;
            if(map_acctId_fcType_gpl_part_dateKey_fc.containsKey(acctId) 
                && map_acctId_fcType_gpl_part_dateKey_fc.get(acctId).containsKey(fcType)
                && map_acctId_fcType_gpl_part_dateKey_fc.get(acctId).get(fcType).containsKey(gplId)
                && map_acctId_fcType_gpl_part_dateKey_fc.get(acctId).get(fcType).get(gplId).containsKey(partId)
                && map_acctId_fcType_gpl_part_dateKey_fc.get(acctId).get(fcType).get(gplId).get(partId).containsKey(currentDateKey)
                && map_acctId_fcType_gpl_part_dateKey_fc.get(acctId).get(fcType).get(gplId).get(partId).containsKey(current_prev_4_QuarterDateKey)
                && map_acctId_fcType_gpl_part_dateKey_fc.get(acctId).get(fcType).get(gplId).get(partId).containsKey(perv_1_QuarterDateKey)
                && map_acctId_fcType_gpl_part_dateKey_fc.get(acctId).get(fcType).get(gplId).get(partId).containsKey(prev_1_prev_4_QuarterDateKey)) {
            
                APL_Sales_Forecast__c currentFC = map_acctId_fcType_gpl_part_dateKey_fc.get(acctId).get(fcType).get(gplId).get(partId).get(currentDateKey);
                APL_Sales_Forecast__c current_prev_4_FC = map_acctId_fcType_gpl_part_dateKey_fc.get(acctId).get(fcType).get(gplId).get(partId).get(current_prev_4_QuarterDateKey);
                APL_Sales_Forecast__c perv_1_FC = map_acctId_fcType_gpl_part_dateKey_fc.get(acctId).get(fcType).get(gplId).get(partId).get(perv_1_QuarterDateKey);
                APL_Sales_Forecast__c prev_1_prev_4_FC = map_acctId_fcType_gpl_part_dateKey_fc.get(acctId).get(fcType).get(gplId).get(partId).get(prev_1_prev_4_QuarterDateKey);
                
                    
                fc.Quantity__c = (baseFC.Quantity__c == null ? null 
                                    : baseFC.Quantity__c * getQuarterlyRate(currentFC.Quantity__c, current_prev_4_FC.Quantity__c, perv_1_FC.Quantity__c, prev_1_prev_4_FC.Quantity__c));
                fc.RSM_Quantity__c = (baseFC.RSM_Quantity__c == null ? null 
                                    : baseFC.RSM_Quantity__c * getQuarterlyRate(currentFC.RSM_Quantity__c, current_prev_4_FC.RSM_Quantity__c, perv_1_FC.RSM_Quantity__c, prev_1_prev_4_FC.RSM_Quantity__c));
                fc.RSM_Forecast__c = (baseFC.RSM_Forecast__c == null ? null 
                                    : baseFC.RSM_Forecast__c * getQuarterlyRate(currentFC.RSM_Forecast__c, current_prev_4_FC.RSM_Forecast__c, perv_1_FC.RSM_Forecast__c, prev_1_prev_4_FC.RSM_Forecast__c));
                fc.GAM_Forecast__c = (baseFC.GAM_Forecast__c == null ? null 
                                    : baseFC.GAM_Forecast__c * getQuarterlyRate(currentFC.GAM_Forecast__c, current_prev_4_FC.GAM_Forecast__c, perv_1_FC.GAM_Forecast__c, prev_1_prev_4_FC.GAM_Forecast__c));
                try{
                fc.Forecast__c = (baseFC.Forecast__c == null ? null 
                                    : baseFC.Forecast__c * getQuarterlyRate(currentFC.Forecast__c, current_prev_4_FC.Forecast__c, perv_1_FC.Forecast__c, prev_1_prev_4_FC.Forecast__c));
                }catch(Exception ex) {
                	system.debug('!@#error : ' + currentFC);
                	system.debug('!@#error : ' + baseFC);
                	throw ex;
                }      
                if(fc.Quantity__c != null) {
                    fc.Quantity__c = fc.Quantity__c.setScale(0, System.Roundingmode.HALF_UP);
                }
                if(fc.RSM_Quantity__c != null) {
                    fc.RSM_Quantity__c = fc.RSM_Quantity__c.setScale(0, System.Roundingmode.HALF_UP);
                }
                fc.Forecast__c = ((fc.Quantity__c != null && fc.Price__c != null) ? fc.Price__c * fc.Quantity__c : fc.Forecast__c);
                fc.RSM_Forecast__c = ((fc.Quantity__c != null && fc.Price__c != null) ? fc.RSM_Price__c * fc.RSM_Quantity__c : fc.RSM_Forecast__c);
                list_newAPLFCs.add(fc);
            }
            
        }
        if(!list_newAPLFCs.isEmpty()) {
        	system.debug('list_newAPLFCs :: ' + list_newAPLFCs);
            insert list_newAPLFCs;
        }
    }
     
    /**
    * This method is used to apl previous month forecast
    *
    @author Lili Zhao
    @created 2014-07-18
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-07-18 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static decimal getQuarterlyRate(decimal currentData, decimal current_4Data, decimal prev_1Data, decimal prev_1_4Data) {
        if((current_4Data == null || current_4Data == 0) && (prev_1_4Data == null || prev_1_4Data == 0)) {
            return 1;
        }
        if(current_4Data == null || current_4Data == 0) {
            return prev_1Data / prev_1_4Data;
        }
        if(prev_1_4Data == null || prev_1_4Data == 0) {
            return currentData / current_4Data;
        }
        return ((currentData / current_4Data + prev_1Data / prev_1_4Data) / 2);
    }
    
    /**
    * This method is used to apl previous month forecast
    *
    @author Lili Zhao
    @created 2014-07-18
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-07-18 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static String getRelayCBCKey(String cbc2Name, String cbc3Name) {
        String cbcKey = '';
        for(String cbcAPI : map_RELAY_CBCFIELD_CBCDESC.keySet()) {
            if(map_RELAY_CBCFIELD_CBCDESC.get(cbcAPI).contains(cbc2Name)) {
                cbcKey = cbc2Name;
            }
            else if(map_RELAY_CBCFIELD_CBCDESC.get(cbcAPI).contains(cbc3Name)) {
                cbcKey = cbc3Name;
            }
        }
        return cbcKey;
    }
    
    /**
    * This method is used to apl previous month forecast
    *
    @author Lili Zhao
    @created 2014-07-18
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-07-18 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static list<String> getSortedRelayCBCKey() {
        list<String> list_cbcKeys = new list<String>();
        for(String cbcAPI : map_RELAY_CBCFIELD_CBCDESC.keySet()) {
            for(String cbcKey : map_RELAY_CBCFIELD_CBCDESC.get(cbcAPI)) {
                list_cbcKeys.add(cbcKey);
            }
        }
        list_cbcKeys.sort();
        return list_cbcKeys;
    }
    
    /**
    * This method is used to apl previous month forecast
    *
    @author Lili Zhao
    @created 2014-07-18
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-07-18 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static String getRelayCBCFilter(String cbcKey) {
        String filter = ' And Part__r.Product_Hierarchy__r.';
        for(String cbcAPI : map_RELAY_CBCFIELD_CBCDESC.keySet()) {
            if(map_RELAY_CBCFIELD_CBCDESC.get(cbcAPI).contains(cbcKey)) {
                filter += (cbcAPI + ' = \'' + cbcKey + '\'');
            }
        }
        return filter; 
    }
    /**
    * This method is used to add Frozen message 
    *
    @author Lili Zhao
    @created 2014-07-18
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-07-18 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static void addFrozenMsg() {
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, system.label.APL_Cycle_Frozen_Msg));
    }
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
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
            for(CurrencyType ct : [SELECT  IsActive, IsCorporate, CreatedById, CreatedDate, 
                                            IsoCode, Id, DecimalPlaces, LastModifiedById, LastModifiedDate, 
                                            SystemModstamp, ConversionRate  
                                   from CurrencyType]){
                map_isoCode_exchangeRate.put(ct.IsoCode, ct.ConversionRate);
            }
        }
    }
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
}