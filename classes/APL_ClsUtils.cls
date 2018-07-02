/**
 *  This class is APL forecast util class
 *  
 * @author Lei Tang
 * @created 2015-03-19
 * @version 1.0
 * @since 30.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2015-03-19 Lei Tang lei.tang@itbconsult.com>
 * - Created
 *
 */
public without sharing class APL_ClsUtils {
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public static final Integer QNUMBER = 5;
    public static final Integer FUTUREQNUMBER = 7;
    
    public static final Integer QNUMBERCOMP = 1;
    public static final Integer FUTUREQNUMBERCOMP = 4;
    
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
    
    public static final set<String> SET_RELAY_CBC2CODE = new set<String> {
    	//change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
        '30005', '13213', '41553'
    };
    
    public static final map<String, String> MAP_CBC2ID_CBC2LABEL = new map<String, String>{
        '30012' => '[ 30012 ] - Power/Signal', '30015' => '[ 30015 ] - RAST', 
        '30016' => '[ 30016 ] - Terminals & Splices', '30017' => '[ 30017 ] - Tubing', 
        '30042' => '[ 30042 ] - Magnet' 
    };
    
    
    
    public static final map<String, String> MAP_ROWLABEL_ROWNAME = new map<String, String>{
        'Current Sales Forecast' => 'CurrentSalesForecast',
        'Rest PNs Forecast' => 'RestPNsForecast',
        'Previous Sales Forecast' => 'PreviousSalesForecast',
        'Last Cycle DC forecast' => 'LastCycleDCforecast',
        'Statistical forecast' => 'Statisticalforecast',
        'Total Billing' => 'TotalBilling',
        'Total Booking' => 'TotalBooking',
        'Total Backlog' => 'TotalBacklog',
        'Total SA' => 'TotalSA'
    };
    
    public static final map<String, String> MAP_RSMMANAGERLABEL = new map<String, String>{
        'AM' => 'Sales Manager',
        'Relay' => 'Relay Sales Manager'
    };
    
    public static final map<String, String> MAP_RSMLABEL_MANAGER = new map<String, String>{
        'Sales Manager' => 'AM'  ,
        'Relay Sales Manager' =>  'Relay' 
    };
    
    public static final map<String, String> MAP_REGIONNAME_REGIONCODE =  new map<String, String>{
        'AMERICAS' => 'S001',
        'ASIA PACIFIC' => 'S002',
        'EMEA' => 'S003',
        'SOUTH ASIA PACIFIC' => 'S018',
        'JAPAN' => 'S025',
        'KOREA' => 'S026',
        'TAIWAN' => 'S029',
        'CHINA' => 'S030'
    };
    
    public static final map<String, String> MAP_REGIONCODE_REGIONNAME =  new map<String, String> {
        'S001'=>'AMERICAS',
        'S002' => 'ASIA PACIFIC',
        'S003' => 'EMEA',
        'S018' => 'SOUTH ASIA PACIFIC',
        'S025' => 'JAPAN',
        'S026' => 'KOREA',
        'S029' => 'TAIWAN',
        'S030' => 'CHINA'
    };
   
    
    public static final map<String, String> BinaryIdLookup = new map<String, String> {
        '00000' => 'A', '00001' => 'B', '00010' => 'C', '00011' => 'D', '00100' => 'E',
        '00101' => 'F', '00110' => 'G', '00111' => 'H', '01000' => 'I', '01001' => 'J',
        '01010' => 'K', '01011' => 'L', '01100' => 'M', '01101' => 'N', '01110' => 'O', 
        '01111' => 'P', '10000' => 'Q', '10001' => 'R', '10010' => 'S', '10011' => 'T', 
        '10100' => 'U', '10101' => 'V', '10110' => 'W', '10111' => 'X', '11000' => 'Y', 
        '11001' => 'Z', '11010' => '0', '11011' => '1', '11100' => '2', '11101' => '3', 
        '11110' => '4', '11111' => '5'
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
    public static final String OTHER = 'Other AM Grouped Accounts';
    public static final String RELAYPRODUCTCODEFCTYPE = 'Relay Product Code';
    
    public static final String AMFCTYPE = 'AM';
    public static final String GAMFCTYPE = 'GAM';
    public static final String RSMFCTYPE = 'RSM';
    
    
    public static Boolean isExecutionTrigger = true;
    
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    //********************************* -=BEGIN public methods=- **********************************
    
        
    public static string Convert15CharTo18CharId(String id)
    {
        if(id.length() == 18) return id;
        String suffix = '';
        for(integer i = 0; i < 3; i++){
            Integer flags = 0;
            for(integer j = 0; j < 5; j++){
                String c = id.substring(i * 5 + j, i * 5 + j + 1);
                if(c.compareTo('A')  >= 0 && c.compareTo('Z') <= 0){
                    flags += 1 << j;
                }
            }

            if (flags <= 25) {
                suffix += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.substring(flags, flags+1);
            }else {
                suffix += '012345'.substring(flags - 26, flags - 26 + 1);
            }
        }

        return id + suffix;
    }
    
    /**
    * Method to id encryption to password.
    *
    @author Lei Tang
    @created 2015-03-02
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-03-02 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public static String encryptionFormID(String id) {
        String temppass = id.substring(0, 15);

        String tempstart = id.substring(0, 7);
        String tempend = id.substring(8, temppass.length());
        
        Integer random = Integer.valueOf(Math.random() * 1000);
        
        String randomstring = String.valueOf(random);
        while(randomstring.length() < 3) {
            randomstring = String.valueOf(randomstring.length()) + randomstring;
        }
        
        String password = randomstring + tempend + temppass.substring(7, 8) + tempstart;
        return password;
    }
    
    /**
    * Method to password decryption to id .
    *
    @author Lei Tang
    @created 2015-03-02
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-03-02 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public static String decryptionFormInput(String possword) {
        
        String tempid = possword.substring(3, possword.length());
        
        String tempstart = tempid.substring(0, 7);
        String tempend = tempid.substring(8, tempid.length());
        
        String id = tempend + tempid.substring(7, 8) + tempstart;
        return id;
    }
    
    
    /**
    * Method to set user locale.
    *
    @author Lei Tang
    @created 2015-05-30
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-05-30 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public static void setUserLocale(APL_ClsEntityType.LocaleConfig localeConfig, String userLocale){
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
    * This method is used to get the children account billing percent
    *
    @author Lili Zhao
    @created 20154-05-23
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-05-23 Lili Zhao <lili.zhao@itbconsult.com>
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
    @created 2015-05-23
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-05-23 Lili Zhao <lili.zhao@itbconsult.com>
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
    
    
    public static String getPricePlaces() {
        if(APL_Forecast_Settings__c.getInstance('Price Decimal Places') != null 
            && APL_Forecast_Settings__c.getInstance('Price Decimal Places').Value__c != null) {
            return (String) APL_Forecast_Settings__c.getInstance('Price Decimal Places').Value__c;
        }
        return '';
    }
    
    /**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2015-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-04-22 Bin Yuan <bin.yuan@itbconsult.com>
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
    * This method is used to get GPLs for CBC2
    *
    @author Bin Yuan
    @created 2015-04-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-04-11 Bin Yuan <bin.yuan@itbconsult.com>
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
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2015-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-04-22 Bin Yuan <bin.yuan@itbconsult.com>
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
    * This method is used to build query string by gaven string list
    *
    @author Bin Yuan
    @created 2015-06-02
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-06-02 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static String getQueryString(String [] params) {

        return (String.format('Select {0} From {1} {2} ', params));

    }
    
    public static String getHexUID(){
        Blob aes = Crypto.generateAesKey(128);
        String hex = EncodingUtil.convertToHex(aes);
        return hex;
    }
    
    /**
    * This method is used to get manage user id
    *
    @author Lei Tang
    @created 2015-02-28
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-02-28 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public static String getManageUserId(String userId) {

        if(userId == null || userId.trim() == '') {
            return UserInfo.getUserId();
        }else {
            return userId;
        }
    }
    
    
    /**
    * This method is used to build string by gaven string list
    *
    @author Bin Yuan
    @created 2015-06-02
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-06-02 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static String getFormatString(list<String> list_str){
        
        String t = '';
        
        for(Integer i=0, max=list_str.size(); i<max; i++){
            t += ('{'+i+'},');
        }
        if(t == ''){
            return t;
        }
        t = t.subString(0, t.length()-1);
        return (String.format(t, list_str));
    }
    
    /**
    * This method is used to build query string by gaven string list
    *
    @author Bin Yuan
    @created 2015-06-02
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-06-02 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static Date getCurrentFiscalDate() {
        Integer year, month;
        Date currentFiscalDate;
        for (Period period : [select Id, FiscalYearSettings.Name, PeriodLabel 
                                from Period where StartDate<=Today and EndDate >=Today and Type = 'Month']) {
              
            if(period.FiscalYearSettings.Name != null){ //set current year
                year = Integer.valueOf(period.FiscalYearSettings.Name);
            }
            if(period.PeriodLabel != null && MAP_MONTHLABELNUMBER.containsKey(period.PeriodLabel)){ //set current month
                month = Integer.valueOf(MAP_MONTHLABELNUMBER.get(period.PeriodLabel));
            }
        }
        currentFiscalDate = Date.newInstance(year, month, 15);
        return currentFiscalDate;
    }

    /**
    * This method is used to get the children account billing percent
    *
    @author Lili Zhao
    @created 2015-05-23
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-05-23 Lili Zhao <lili.zhao@itbconsult.com>
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
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2015-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-04-22 Bin Yuan <bin.yuan@itbconsult.com>
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
    * This method is used get account hierarchy for current account manager.
    *
    @author Bin Yuan
    @created 2015-03-27
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-03-27 Bin Yuan <bin.yuan@itbconsult.com>
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
    * This method is used get account hierarchy for current account manager.
    *
    @author Bin Yuan
    @created 2015-03-27
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-03-27 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void createDateItem(APL_ClsEntityType.PageConfig pageConf, list<APL_ClsEntityType.DateItem> list_allDateItems) {
        
        String str_monthLabel = '';
        String str_qLabel = '';
        String str_mLabel = '';
        String str_yearLabel = '';
        Integer monthCounter = 0;
        String currentclonum = '4';
        APL_ClsEntityType.DateItem tempDateItem;
        String temp_qMonths = '';
        //generate table header for history, current and future date type
        pageConf.str_tableHead = ((pageConf.str_tableHead == null || pageConf.str_tableHead == '')
                                    ? '<th class="fixthh th_historicalc historicalcls tl" colspan="16" style="height: 0px !important;"><div class="fix_lh historicalc">' + system.label.APL_Forecast_Header_Label_History + '</div></th>'
                                    + '<th class="fixthh th_current currentcls tl" old="4" colspan="4"><div class="fix_lh current_cls"><div class="absdiv">' + system.label.APL_Forecast_Header_Label_Current + '</div></div></th>'
                                    + '<th class="fixthh th_futurec futurec futurecls tl" colspan="999" ><div class="fix_lh head_futurec">' + system.label.APL_Forecast_Header_Label_Future + '</div></th>' : pageConf.str_tableHead);
        
        for(Integer i = 1; i <= 33; i++) {
            
            if (i == 1) {
                tempDateItem = new APL_ClsEntityType.DateItem('Historical Data');
                tempDateItem.type = 'historicalc';
                
            }
            else if (i == 13) {
                tempDateItem = new APL_ClsEntityType.DateItem('Current Month');
                tempDateItem.cls = 'none';
                tempDateItem.type = 'currentc cfixw';
            }
            else if (i == 16){
                tempDateItem = new APL_ClsEntityType.DateItem('Future Plan');
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
            //set data item month label format 2015-3
            str_mLabel = str_yearFullLabel + '_' + monthCounter;
            
            str_yearLabel = 'FY' + str_yearLabel.subString(2);
            str_monthLabel = MAP_NUMBERMONTHLABEL.get(monthCounter);
            if(i <= 15) {
                APL_ClsEntityType.DateItem tempMonthItem = new APL_ClsEntityType.DateItem('');
                
                tempMonthItem.type2 = 'cfixmonthw';
                tempMonthItem.type3 = 'totalbg';
                tempMonthItem.itemName = str_monthLabel + ' / ' + str_yearLabel;
                tempMonthItem.monthCls = 'monthCls historicalcls';
                if (i < pageConf.currentMonthIndex) {
                    Integer t = (i - pageConf.currentMonthIndex);
                    tempMonthItem.type = '';
                    if(t == -1 || t == -2 || t == -3){
                        tempMonthItem.type += ' cm'+t+' ';
                        tempMonthItem.monthCls = 'monthCls currentcls';
                    }
                }
                else if (i == pageConf.currentMonthIndex) {
                    tempMonthItem.isInput = false;
                    tempMonthItem.monthCls = 'monthCls currentcls';
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
                        tempMonthItem.monthCls = 'monthCls currentcls';
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
            String quarter4 = '';
            if (Math.mod(i, 3) == 0) {
                APL_ClsEntityType.DateItem tempYearItem = null;
                
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
                    quarter4 = 'qtfcls';
                    /*if (i >= pageConf.currentMonthIndex) {
                        tempYearItem = new APL_ClsEntityType.DateItem('FY' + str_yearFullLabel);
                        tempYearItem.qtotalCls = 'futuretotalcls';
                        tempYearItem.type = 'futurec ';
                        tempYearItem.isInput = false;
                        tempYearItem.qLabel = str_yearLabel;
                        tempYearItem.monthCls = 'monthCls futurecls';
                        tempYearItem.qMonths = 'Q1' + ' / ' + str_yearLabel+','+'Q2' + ' / ' + str_yearLabel+','+'Q3' + ' / ' + str_yearLabel+','+'Q4' + ' / ' + str_yearLabel;
                        if(pageConf.currentYear == str_yearFullLabel && (pageConf.currentMonth == 10 || pageConf.currentMonth == 11 || pageConf.currentMonth == 12)) {
                            tempYearItem.monthCls = 'monthCls currentcls';
                            currentclonum = '5';
                        }
                        
                    }*/
                }
                
                APL_ClsEntityType.DateItem tempTotalItem = new APL_ClsEntityType.DateItem(str_qLabel);
                tempTotalItem.qtotalCls = ('qtotalCls' + (i <= 15 ? ' exp_coll ' : ' '));
                tempTotalItem.qtotalCls += (i == 15 ? ' crtQtotal ' : ' ') + quarter4;
                tempTotalItem.qMonths = temp_qMonths;
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'tempTotalItem :: '+ tempTotalItem));
                temp_qMonths = '';
                //DateItem tempTotalItem = new DateItem('Q Total');
                tempTotalItem.total = 'q' + i / 3;
                if (i < pageConf.currentMonthIndex) {
                    tempTotalItem.type = ('historicalc ' + (tempDateItem.type == 'currentc cfixw' ? 'currentc' : tempDateItem.type) + '1');
                    tempTotalItem.monthCls = 'monthCls historicalcls';
                }
                else {
                    tempTotalItem.type = ('futurec ' + (tempDateItem.type == 'currentc cfixw' ? 'currentc' : tempDateItem.type) + '1');
                    tempTotalItem.monthCls = 'monthCls futurecls ';
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
                /*if(tempYearItem != null) {
                    list_allDateItems.add(tempYearItem);
                }*/
                 
            }
        }
        
        /*pageConf.str_tableHead = ((pageConf.str_tableHead == null || pageConf.str_tableHead == '')
                                    ? '<th class="fixthh th_historicalc historicalcls tl" colspan="16" style="height: 0px !important;"><div class="fix_lh historicalc">' + system.label.APL_Forecast_Header_Label_History + '</div></th>'
                                    + '<th class="fixthh th_current currentcls tl" old="4" colspan="'+currentclonum+'"><div class="fix_lh current_cls"><div class="absdiv">' + system.label.APL_Forecast_Header_Label_Current + '</div></div></th>'
                                    + '<th class="fixthh th_futurec futurec futurecls tl" colspan="999" ><div class="fix_lh head_futurec">' + system.label.APL_Forecast_Header_Label_Future + '</div></th>' : pageConf.str_tableHead);
        */
        
        
        pageConf.str_futureQuarterMap = Json.serialize(pageConf.map_year_quartersFuture);
        pageConf.str_futureMonthMap = Json.serialize(pageConf.map_year_monthsFuture);
        //clear map
    }
    
    
    /**
    * This method is used get account hierarchy for current account manager.
    *
    @author Bin Yuan
    @created 2015-03-27
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-03-27 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void setFiscalMonth(APL_ClsEntityType.PageConfig pageConf){   //set current year & current month
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
    @created 2015-03-27
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-03-27 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void setCurrentMonthIndex(APL_ClsEntityType.PageConfig pageConf) {
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
    * This method is used get the entire date range's start date and end date.
    *
    @author Bin Yuan
    @created 2015-03-27
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-03-27 Bin Yuan <bin.yuan@itbconsult.com>
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
    * This method is used get current fiscal date.
    *
    @author Lei Tang
    @created 2015-05-10
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-05-10 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public static Date getFiscalDate() {
        Date fiscaldate = Date.today();
        
        for (Period period : [select Id, FiscalYearSettings.Name, PeriodLabel 
                                from Period where StartDate<=Today and EndDate >=Today and Type = 'Month']) {
                                    
            if(period.FiscalYearSettings.Name != null && period.PeriodLabel != null && MAP_MONTHLABELNUMBER.containsKey(period.PeriodLabel)){
                fiscaldate = Date.newInstance(Integer.valueOf(period.FiscalYearSettings.Name), Integer.valueOf(MAP_MONTHLABELNUMBER.get(period.PeriodLabel)), 15); //period.FiscalYearSettings.Name;
            }
            
        }
        
        return fiscaldate;
    }
    
    /**
    * This method is used set map of Account ref data.
    *
    @author Lei Tang
    @created 2015-05-10
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-05-10 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public static void setRegionMapRefData(String regionId, set<String> years, set<Integer> months, set<String> set_soldtoIds, list<String> list_sql, map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result) {
        system.debug('@#readly : '+set_soldtoIds);
        system.debug('@#sql : ' + APL_ClsUtils.getQueryString(list_sql));
        for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
            
            //String accId = (String)result.get('refId');
            Date refdate = (Date)result.get('refdate');
            String year = String.valueOf(refdate.year());
            String month = String.valueOf(refdate.month());
            String dateKey = (year + '_' + month);
            APL_ClsUtils.setResultMap(result, regionId, dateKey, map_acctId_map_dateKey_result);       
            
        }    
    }
    
    /**
    * This method is used set map of Account ref data.
    *
    @author Lei Tang
    @created 2015-05-10
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-05-10 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public static void setSoldToMapRefData(set<String> years, set<Integer> months, list<Date> listdate, list<String> list_sql, map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result) {
            system.debug('xxxxxxxxxxxxxxxxx:'+APL_ClsUtils.getQueryString(list_sql));
        for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
            //system.debug('@#result : '+result);
            String accId = (String)result.get('refId');
            Date refdate = (Date)result.get('refdate');
            String year = String.valueOf(refdate.year());
            String month = String.valueOf(refdate.month());
            String dateKey = (year + '_' + month);
            APL_ClsUtils.setResultMap(result, accId, dateKey, map_acctId_map_dateKey_result);       
            
        }    
    }
    
    
    /**
    * This method is used set map of totle billing data.
    *
    @author Lei Tang
    @created 2015-05-10
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-05-10 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public static void setTotelBillingData(set<String> years, set<Integer> months, Object set_perm, list<String> list_sql, map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result) {
        for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
            //system.debug('@#result : '+result);
            String accId = 'Total';
            Date refdate = (Date)result.get('refdate');
            String year = String.valueOf(refdate.year());
            String month = String.valueOf(refdate.month());
            String dateKey = (year + '_' + month);
            APL_ClsUtils.setResultMap(result, accId, dateKey, map_acctId_map_dateKey_result);       
            
        }    
    }
    
    
    /**
    * This method is used set map OEM and Part ref data.
    *
    @author Lei Tang
    @created 2015-05-10
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    * 
    *
    @changelog
    * 2015-05-10 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public static void setOEMPartMapRefData(set<String> set_monthids, list<String> list_sql, map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result) {
            
        for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
            //system.debug('@#result : '+result);
            String accId = (String)result.get('refId');
            Date refdate = (Date)result.get('refdate');
            String year = String.valueOf(refdate.year());
            String month = String.valueOf(refdate.month());
            String dateKey = (year + '_' + month);
            APL_ClsUtils.setResultMap(result, accId, dateKey, map_acctId_map_dateKey_result);       
            
        }    
    }
    
    /**
    * This method is used set map OEM and Part ref data.
    *
    @author Lei Tang
    @created 2015-05-10
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    * 
    *
    @changelog
    * 2015-05-10 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public static void setGAMOEMMapRefData(String oemId, set<String> set_monthids, list<String> list_sql, map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result) {
            
        for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
            //system.debug('@#result : '+result);
            Date refdate = (Date)result.get('refdate');
            String year = String.valueOf(refdate.year());
            String month = String.valueOf(refdate.month());
            String dateKey = (year + '_' + month);
            system.debug('@#result:'+result);
            system.debug('@#dateKey:'+dateKey);
            APL_ClsUtils.setResultMap(result, oemId, dateKey, map_acctId_map_dateKey_result);       
            
        }    
    }
    
    public static void setRefDatelist(list<Date> list_beforedate, list<Date> list_futruedate, set<String> set_fiscalMonth) {
        Date curretdate = getFiscalDate();
        for(String datekey : set_fiscalMonth) {
            String year = datekey.substring(0, datekey.indexOf('_'));
            String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
            Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);
            
            if(curretdate <= refdate) {
                list_futruedate.add(refdate);
            }
            if(curretdate >= refdate) {
                list_beforedate.add(refdate);
            }
        }
    }
    

    public static void setRefDateObject(list<Date> list_beforedate, list<Date> list_futruedate, list<Date> list_statisticaldate, 
            Date curretdate, APL_ClsEntityType.APLRefObj refdata,
            map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before, 
            map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue) {

        if(list_beforedate.size() > 0) {
            for(Date refdate : list_beforedate) {
                String year = String.valueOf(refdate.year());
                String month = String.valueOf(refdate.month());
                String dateKey = (year + '_' + month);

                AggregateResult result;
                
                if(map_acctId_map_dateKey_result_before.containsKey(refdata.id) 
                    && map_acctId_map_dateKey_result_before.get(refdata.id).containsKey(dateKey)) {
                    
                    result = map_acctId_map_dateKey_result_before.get(refdata.id).get(dateKey);
                }
                refdata.map_billingrefdata.put(dateKey, 0);
                refdata.map_bookingrefdata.put(dateKey, 0);
                
                if(result != null) {
                    try{
                        refdata.map_billingrefdata.put(dateKey, (result.get('billamount') != null ? (decimal)result.get('billamount') : 0));
                    }catch(Exception e) { }
                    try{
                         refdata.map_bookingrefdata.put(dateKey, (result.get('bookamount') != null ? (decimal)result.get('bookamount') : 0));
                    }catch(Exception e) { }
                }
            }
        }

        if(list_futruedate.size() > 0) {
            for(Date refdate : list_futruedate) {
                String year = String.valueOf(refdate.year());
                String month = String.valueOf(refdate.month());
                String dateKey = (year + '_' + month);
                
                AggregateResult result;
                
                if(map_acctId_map_dateKey_result_futrue.containsKey(refdata.id) 
                    && map_acctId_map_dateKey_result_futrue.get(refdata.id).containsKey(dateKey)) {
                    
                    result = map_acctId_map_dateKey_result_futrue.get(refdata.id).get(dateKey);
                }
                
                refdata.map_backlogrefdata.put(dateKey, 0);  
                refdata.map_statisticalrefdata.put(dateKey, 0);
                if(result != null) {
                    try{
                         refdata.map_backlogrefdata.put(dateKey, (result.get('amount') != null ? (decimal)result.get('amount') : 0));
                    }catch(Exception e) { }
                    
                }
            }
        }

    }

    
    public static void setRefDateObject(list<Date> list_beforedate, list<Date> list_futruedate, APL_ClsEntityType.APLRefObj refdata,
            map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before, 
            map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue) {

        if(list_beforedate.size() > 0) {
            //for(String dateKey : map_acctId_map_dateKey_result_before.get(searchOb.soldtoId).keySet()) {
            for(Date refdate : list_beforedate) {
                String year = String.valueOf(refdate.year());
                String month = String.valueOf(refdate.month());
                String dateKey = (year + '_' + month);
                
                system.debug('@#refdate:'+refdate);
                AggregateResult result;
                //system.debug('@#dateKey :'+dateKey);
                if(map_acctId_map_dateKey_result_before.containsKey(refdata.id) 
                    && map_acctId_map_dateKey_result_before.get(refdata.id).containsKey(dateKey)) {
                    
                    result = map_acctId_map_dateKey_result_before.get(refdata.id).get(dateKey);
                }
                refdata.map_billingrefdata.put(dateKey, 0);
                refdata.map_bookingrefdata.put(dateKey, 0);
                
                if(result != null) {
                    //refdata.name = (String)result.get('name');
                    refdata.map_billingrefdata.put(dateKey, (result.get('billamount') != null ? (decimal)result.get('billamount') : 0));
                    refdata.map_bookingrefdata.put(dateKey, (result.get('bookamount') != null ? (decimal)result.get('bookamount') : 0));
                }
            }
        }
        
        system.debug('@#list_futruedate:'+list_futruedate);
        if(list_futruedate.size() > 0) {

            for(Date refdate : list_futruedate) {
                String year = String.valueOf(refdate.year());
                String month = String.valueOf(refdate.month());
                String dateKey = (year + '_' + month);
                
                AggregateResult result;
                //system.debug('@#dateKey :'+dateKey);
                if(map_acctId_map_dateKey_result_futrue.containsKey(refdata.id) 
                    && map_acctId_map_dateKey_result_futrue.get(refdata.id).containsKey(dateKey)) {
                    
                    result = map_acctId_map_dateKey_result_futrue.get(refdata.id).get(dateKey);
                }
                
                refdata.map_backlogrefdata.put(dateKey, 0);  
                refdata.map_statisticalrefdata.put(dateKey, 0);
                if(result != null) {
                    //refdata.name = (String)result.get('name');
                    refdata.map_backlogrefdata.put(dateKey, (result.get('amount') != null ? (decimal)result.get('amount') : 0));  
                }

            }
        }
        
        
    }
    
    
    public static void setRelayRefDateObject(list<Date> list_beforedate, list<Date> list_futruedate, APL_ClsEntityType.APLRelayRefObj refdata,
            map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before, 
            map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue) {

        if(list_beforedate.size() > 0) {
            //for(String dateKey : map_acctId_map_dateKey_result_before.get(searchOb.soldtoId).keySet()) {
            for(Date refdate : list_beforedate) {
                String year = String.valueOf(refdate.year());
                String month = String.valueOf(refdate.month());
                String dateKey = (year + '_' + month);
                
                system.debug('@#refdate:'+refdate);
                AggregateResult result;
                //system.debug('@#dateKey :'+dateKey);
                if(map_acctId_map_dateKey_result_before.containsKey(refdata.id) 
                    && map_acctId_map_dateKey_result_before.get(refdata.id).containsKey(dateKey)) {
                    
                    result = map_acctId_map_dateKey_result_before.get(refdata.id).get(dateKey);
                }
                refdata.map_billingrefdata.put(dateKey, 0);
                refdata.map_billingrefdataQty.put(dateKey, 0);
                refdata.map_bookingrefdata.put(dateKey, 0);
                refdata.map_bookingrefdataQty.put(dateKey, 0);
                if(result != null) {
                    //refdata.name = (String)result.get('name');
                    refdata.map_billingrefdata.put(dateKey, (result.get('billamount') != null ? (decimal)result.get('billamount') : 0));
                    refdata.map_billingrefdataQty.put(dateKey, (result.get('billQty') != null ? (decimal)result.get('billQty') : 0));
                    refdata.map_bookingrefdata.put(dateKey, (result.get('bookamount') != null ? (decimal)result.get('bookamount') : 0));
                    refdata.map_bookingrefdataQty.put(dateKey, (result.get('bookQty') != null ? (decimal)result.get('bookQty') : 0));
                }
            }
        }
        
        system.debug('@#list_futruedate:'+list_futruedate);
        if(list_futruedate.size() > 0) {

            for(Date refdate : list_futruedate) {
                String year = String.valueOf(refdate.year());
                String month = String.valueOf(refdate.month());
                String dateKey = (year + '_' + month);
                
                AggregateResult result;
                //system.debug('@#dateKey :'+dateKey);
                if(map_acctId_map_dateKey_result_futrue.containsKey(refdata.id) 
                    && map_acctId_map_dateKey_result_futrue.get(refdata.id).containsKey(dateKey)) {
                    
                    result = map_acctId_map_dateKey_result_futrue.get(refdata.id).get(dateKey);
                }
                
                refdata.map_backlogrefdata.put(dateKey, 0);  
                refdata.map_backlogrefdataQty.put(dateKey, 0);  
                if(result != null) {
                    //refdata.name = (String)result.get('name');
                    refdata.map_backlogrefdata.put(dateKey, (result.get('amount') != null ? (decimal)result.get('amount') : 0)); 
                    refdata.map_backlogrefdataQty.put(dateKey, (result.get('qty') != null ? (decimal)result.get('qty') : 0)); 
                }

            }
        }
        
        
    }
    
    
    public static void createRSMAMroupingObj(APL_ClsEntityType.RSMAccountObj acctFC, map<String, set<String>> map_year_quartersFuture){
        
        acctFC.map_type_FC = new map<String, map<String, decimal>>();
        
        map<String, decimal> csFC = new map<String, decimal>();
        map<String, decimal> pmFC = new map<String, decimal>();
        
        for(String year : map_year_quartersFuture.keySet()) {
            //String yeardate = (year + '_' + year);
            //csFC.put(yeardate, 0);
            //pmFC.put(yeardate, 0);
            
            for(String quarter : map_year_quartersFuture.get(year)) {
                String dateKey = (year + '_' + quarter);
                csFC.put(dateKey, 0);
                pmFC.put(dateKey, 0);
            }
        }
        acctFC.map_type_FC.put('csFC', csFC);
        acctFC.map_type_FC.put('pmFC', pmFC);

    }
    
    
    
    public static void createRSMRelayGroupingObj(APL_ClsEntityType.RSMAccountObj acctFC, map<String, set<String>> map_year_quartersFuture){
        
        acctFC.map_type_FC = new map<String, map<String, decimal>>();
        
        map<String, decimal> csFC = new map<String, decimal>();
        map<String, decimal> pmFC = new map<String, decimal>();
        map<String, decimal> amFC = new map<String, decimal>();
        
        for(String year : map_year_quartersFuture.keySet()) {
            //String yeardate = (year + '_' + year);
            //csFC.put(yeardate, 0);
            //pmFC.put(yeardate, 0);
            
            for(String quarter : map_year_quartersFuture.get(year)) {
                String dateKey = (year + '_' + quarter);
                csFC.put(dateKey, 0);
                pmFC.put(dateKey, 0);
                amFC.put(dateKey, 0);
            }
        }
        acctFC.map_type_FC.put('csFC', csFC);
        acctFC.map_type_FC.put('pmFC', pmFC);
        acctFC.map_type_FC.put('amFC', amFC);
    }
    
    
    public static void createRSMAccountObj(APL_ClsEntityType.RSMAccountObj acctFC, map<String, set<String>> map_year_quartersFuture){
        
        acctFC.map_type_FC = new map<String, map<String, decimal>>();
        
        map<String, decimal> csFC = new map<String, decimal>();
        map<String, decimal> pmFC = new map<String, decimal>();
        map<String, decimal> rsmFC = new map<String, decimal>();
        
        for(String year : map_year_quartersFuture.keySet()) {
            //String yeardate = (year + '_' + year);
            //csFC.put(yeardate, 0);
            //pmFC.put(yeardate, 0);
            
            for(String quarter : map_year_quartersFuture.get(year)) {
                String dateKey = (year + '_' + quarter);
                csFC.put(dateKey, 0);
                pmFC.put(dateKey, 0);
                rsmFC.put(dateKey, 0);
            }
        }
        acctFC.map_type_FC.put('csFC', csFC);
        acctFC.map_type_FC.put('pmFC', pmFC);
        acctFC.map_type_FC.put('rsmFC', rsmFC);
    }
    
    public static void createRSMRelayAccountObj(APL_ClsEntityType.RSMAccountObj acctFC, map<String, set<String>> map_year_quartersFuture){
        
        acctFC.map_type_FC = new map<String, map<String, decimal>>();
        
        map<String, decimal> csFC = new map<String, decimal>();
        map<String, decimal> pmFC = new map<String, decimal>();
        map<String, decimal> quantity = new map<String, decimal>();
        for(String year : map_year_quartersFuture.keySet()) {
            
            for(String quarter : map_year_quartersFuture.get(year)) {
                String dateKey = (year + '_' + quarter);
                csFC.put(dateKey, 0);
                quantity.put(dateKey, 0);
                pmFC.put(dateKey, 0);
            }
        }
        acctFC.map_type_FC.put('csFC', csFC);
        acctFC.map_type_FC.put('quantity', csFC);
        acctFC.map_type_FC.put('pmFC', pmFC);
    }
    
    public static void createRSMRelayPartObj(APL_ClsEntityType.RSMAccountObj acctFC, map<String, set<String>> map_year_quartersFuture){
        
        acctFC.map_type_FC = new map<String, map<String, decimal>>();
        
        map<String, decimal> csFC = new map<String, decimal>();
        map<String, decimal> pmFC = new map<String, decimal>();
        map<String, decimal> quantity = new map<String, decimal>();
        map<String, decimal> rsmFC = new map<String, decimal>();
        for(String year : map_year_quartersFuture.keySet()) {
            
            for(String quarter : map_year_quartersFuture.get(year)) {
                String dateKey = (year + '_' + quarter);
                quantity.put(dateKey, 0);
                pmFC.put(dateKey, 0);
                rsmFC.put(dateKey, 0);
            }
        }
        acctFC.map_type_FC.put('quantity', csFC);
        acctFC.map_type_FC.put('pmFC', pmFC);
        acctFC.map_type_FC.put('rsmFC', rsmFC);
    }
    
    public static void createSearchRSMRelayPartObj(APL_ClsEntityType.RSMPartObj acctFC, map<String, set<String>> map_year_quartersFuture){
        
        acctFC.map_type_FC = new map<String, map<String, decimal>>();
        
        map<String, decimal> csFC = new map<String, decimal>();
        map<String, decimal> pmFC = new map<String, decimal>();
        map<String, decimal> quantity = new map<String, decimal>();
        map<String, decimal> rsmFC = new map<String, decimal>();
        for(String year : map_year_quartersFuture.keySet()) {
            
            for(String quarter : map_year_quartersFuture.get(year)) {
                String dateKey = (year + '_' + quarter);
                quantity.put(dateKey, 0);
                pmFC.put(dateKey, 0);
                rsmFC.put(dateKey, 0);
            }
        }
        acctFC.map_type_FC.put('quantity', csFC);
        acctFC.map_type_FC.put('pmFC', pmFC);
        acctFC.map_type_FC.put('rsmFC', rsmFC);
    }
    
    
    public static void createAccountObj(APL_ClsEntityType.AccountObj acctFC, map<String, set<Integer>> map_year_monthsFuture){
        
        acctFC.csFC = new map<String, decimal>();
        acctFC.dcFC = new map<String, decimal>();
        acctFC.pmFC = new map<String, decimal>();
        acctFC.restPNFC = new map<String, decimal>();
        //map_acctId_acctFC.put(map_soldto_region.get(acctId), acctFC);

        for(String year : map_year_monthsFuture.keySet()) {
            for(Integer month : map_year_monthsFuture.get(year)) {
                String dateKey = (year + '_' + String.valueOf(month));
                acctFC.csFC.put(dateKey, 0);
                acctFC.dcFC.put(dateKey, 0);
                acctFC.pmFC.put(dateKey, 0);
                acctFC.restPNFC.put(dateKey, 0);
            }
        }
    }
    
    public static void createOEMAccountObj(APL_ClsEntityType.OEMAccountObj acctFC, map<String, set<Integer>> map_year_monthsFuture){
        
        acctFC.csFC = new map<String, decimal>();
        acctFC.dcFC = new map<String, decimal>();
        acctFC.pmFC = new map<String, decimal>();
        acctFC.restPNFC = new map<String, decimal>();
        //map_acctId_acctFC.put(map_soldto_region.get(acctId), acctFC);

        for(String year : map_year_monthsFuture.keySet()) {
            for(Integer month : map_year_monthsFuture.get(year)) {
                String dateKey = (year + '_' + String.valueOf(month));
                acctFC.csFC.put(dateKey, 0);
                acctFC.dcFC.put(dateKey, 0);
                acctFC.pmFC.put(dateKey, 0);
                acctFC.restPNFC.put(dateKey, 0);
            }
        }
    }
    
    public static void createAccountObjForComprison(APL_ClsEntityType.AccountObjForComparison acctFC, map<String, String> map_quarter_months){
        
        acctFC.csFC = new map<String, decimal>();
        acctFC.dcFC = new map<String, decimal>();
        acctFC.pmFC = new map<String, decimal>();
        acctFC.csFCamount = 0;
        
        for(String quarter : map_quarter_months.keySet()) {
            //String dateKey = (year + '_' + String.valueOf(month));
            acctFC.csFC.put(quarter, 0);
            acctFC.dcFC.put(quarter, 0);
            acctFC.pmFC.put(quarter, 0);
        }
    }
    
    
    
    public static void createPartObj(APL_ClsEntityType.PartObj acctFC, map<String, set<Integer>> map_year_monthsFuture){
        
        acctFC.csFC = new map<String, APL_ClsEntityType.AccountValueobj>();
        acctFC.dcFC = new map<String, decimal>();
        acctFC.pmFC = new map<String, decimal>();
        //map_acctId_acctFC.put(map_soldto_region.get(acctId), acctFC);

        for(String year : map_year_monthsFuture.keySet()) {
            for(Integer month : map_year_monthsFuture.get(year)) {
                String dateKey = (year + '_' + String.valueOf(month));
                APL_ClsEntityType.AccountValueobj valueobj = new APL_ClsEntityType.AccountValueobj();
                valueobj.forecast = 0;
                valueobj.price = 0;
                valueobj.quantity = 0;
                acctFC.csFC.put(dateKey, valueobj);
                acctFC.dcFC.put(dateKey, 0);
                acctFC.pmFC.put(dateKey, 0);
                
            }
        }
    }
    
    public static APL_ClsEntityType.APLRefObj createRefDataObj() {
        APL_ClsEntityType.APLRefObj refdata = new APL_ClsEntityType.APLRefObj();
        refdata.map_backlogrefdata = new map<String, decimal>();
        refdata.map_billingrefdata = new map<String, decimal>();
        refdata.map_bookingrefdata = new map<String, decimal>();
        refdata.map_statisticalrefdata = new map<String, decimal>();
        
        return refdata;
    }
    
     
    public static APL_ClsEntityType.APLRelayRefObj createRelayRefDataObj() {
        APL_ClsEntityType.APLRelayRefObj refdata = new APL_ClsEntityType.APLRelayRefObj();
        refdata.map_backlogrefdata = new map<String, decimal>();
        refdata.map_billingrefdata = new map<String, decimal>();
        refdata.map_bookingrefdata = new map<String, decimal>();
        
        refdata.map_backlogrefdataQty = new map<String, decimal>();
        refdata.map_billingrefdataQty = new map<String, decimal>();
        refdata.map_bookingrefdataQty = new map<String, decimal>();
        
        return refdata;
    }
    
    
    
    public static String copyCFTForecast(String sData) {
        
        return '';
    }

    
    /**
     * P1: We can find backlog records for the particular Org ID, Part, Sold to for the future 24 months. ASP equals to sum (backlog amt) / sum(backlog units)
     * P2: We can find billing records for the particular Org ID, Part, Sold to for the previous 6 months. ASP equals to sum (6M billing amt) / sum(6M billing units)
     * P3: We can find backlog records for the particular Org ID, Part for the future 24 months. ASP equals to sum (backlog amt) / sum(backlog units)
     * P4: We can find billing records for the particular Org ID, Part for the previous 6 months. ASP equals to sum (6M billing amt) / sum(6M billing units)
     * P5: We can find backlog records for the particular region, Part for the future 24 months. ASP equals to sum (backlog amt) / sum(backlog units)
     * P6: We can find billing records for the particular region, Part for the previous 6 months. ASP equals to sum (6M billing amt) / sum(6M billing units)
     * P7: We can find backlog records for the particular Part for the future 24 months. ASP equals to sum (backlog amt) / sum(backlog units)
     * P8: We can find billing records for the particular Part for the previous 6 months. ASP equals to sum (6M billing amt) / sum(6M billing units)
     *  
     * @author Lei Tang
     * @created 2015-04-29
     * @version 1.0
     * @since 30.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2015-04-29 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public static String getASP(String sData) {
        return '';
    }
 
    
    /**
     * This function is set Statistical Forecast date set
     * 
     * @author Lei Tang
     * @created 2015-05-29
     * @version 1.0
     * @since 30.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2015-05-29 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public static void setStatisticalForecastDate(set<String> years, set<Integer> months, list<Date> list_beforedate) {
        for(Date dates : list_beforedate) {
            for(Integer i = -3; i <= 0; i++){
                Date lastmonth = dates.addMonths(i);
                if(!years.contains(String.valueOf(lastmonth.year()))){
                    years.add(String.valueOf(lastmonth.year()));
                }
                if(!months.contains(lastmonth.month())){
                    months.add(lastmonth.month());
                }
            }
        }
    }
    
    /**
     * This function is set reference Forecast years and months set
     * 
     * @author Lei Tang
     * @created 2015-05-29
     * @version 1.0
     * @since 30.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2015-05-29 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public static void setRefForecastDate(set<String> years, set<Integer> months, list<Date> list_date) {
        
        for(Date dates : list_date) {
            if(!years.contains(String.valueOf(dates.year()))){
                years.add(String.valueOf(dates.year()));
            }
            if(!months.contains(dates.month())){
                months.add(dates.month());
            }
        }
    }

    
    
    /**
    * This method is used get account hierarchy for current account manager.
    *
    @author Bin Yuan
    @created 2015-03-27
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-03-27 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void createDateItemForComparison(APL_ClsEntityType.PageConfig pageConf, list<APL_ClsEntityType.DateItem> list_allDateItems) {
        
        String str_monthLabel = '';
        String str_qLabel = '';
        String str_mLabel = '';
        String str_yearLabel = '';
        String str_yearColmunLabel = '';
        Integer monthCounter = 0;
        APL_ClsEntityType.DateItem tempDateItem;
        String temp_qMonths = '';
        //generate table header for history, current and future date type
        pageConf.str_tableHead = ((pageConf.str_tableHead == null || pageConf.str_tableHead == '')
                                    ? '<th class="fixthh th_historicalcls tl" colspan="4" style="height: 0px !important;"><div class="fix_lh historicalc">Current Cycle Latest Sales Fcst</div></th>'
                                    + '<th class="fixthh th_currentcls tl" old="4" colspan="4"><div class="fix_lh current_cls"><div class="absdiv">Last Cycle DC Fcst</div></div></th>'
                                    + '<th class="fixthh th_futurecls futurec tl" colspan="999" ><div class="fix_lh head_futurec">GAP</div></th>' : pageConf.str_tableHead);

        for(Integer i = 1; i <= 3; i++) {
            String clsname = 'historicalcls';
            Boolean isfutrue = false;
            String itemname = 'Current Cycle Latest Sales Fcst';
            if (i == 1) {
                itemname = 'Current Cycle Latest Sales Fcst';
                clsname = 'historicalcls';
            }
            else if (i == 2) {
                itemname = 'Last Cycle DC Fcst';
                clsname = 'currentcls';
            }
            else if (i == 3){
                itemname = 'GAP';
                clsname = 'futurecls';
                isfutrue = true;
            }
            
            for(Integer j = 1; j <= 12; j++) {
                //tempDateItem = new APL_ClsEntityType.DateItem(itemname);
                //tempDateItem.cls = clsname;
                //tempDateItem.isFutrue = isfutrue;
                
                //generate history and current type month date item
                monthCounter = (j - pageConf.currentMonthIndex);
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
                //set data item month label format 2015-3
                str_mLabel = str_yearFullLabel + '_' + monthCounter;
                
                str_yearLabel = 'FY' + str_yearLabel.subString(2);
                
                str_monthLabel = MAP_NUMBERMONTHLABEL.get(monthCounter);
                //if(j < pageConf.currentMonthIndex) {
                APL_ClsEntityType.DateItem tempMonthItem = new APL_ClsEntityType.DateItem('');
                tempMonthItem.itemName = str_monthLabel + ' / ' + str_yearLabel;
                tempMonthItem.monthCls = 'monthCls';
                tempMonthItem.cls = clsname;
                tempMonthItem.isFutrue = isfutrue;
                String ymStr = pageConf.list_yearMonth.get(j - 1);
                tempMonthItem.fYear = ymStr.subString(0, ymStr.indexOf('_'));
                tempMonthItem.fMonth = Integer.valueOf(ymStr.subString(ymStr.indexOf('_') + 1));
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'tempMonthItem :: ' + tempMonthItem));
                tempMonthItem.mLabel = str_mLabel;
                //list_allDateItems.add(tempMonthItem); 
                //}
                //if(j >= pageConf.currentMonthIndex) {
                if(!pageConf.map_year_monthsFuture.containsKey(str_yearFullLabel)) {
                    pageConf.map_year_monthsFuture.put(str_yearFullLabel, new set<Integer>());
                }
                pageConf.map_year_monthsFuture.get(str_yearFullLabel).add(monthCounter);
                //}
                //generate quarterly date item
                String quarterCounter = '';
                if (Math.mod(j, 3) == 0) {
                    if(monthCounter == 3) {
                        quarterCounter = 'Q1';
                        //str_qLabel = str_yearLabel + ' ' + quarterCounter;
                    }
                    else if(monthCounter == 6) {
                        quarterCounter = 'Q2';
                        //str_qLabel = 'Q2' + ' / ' + str_yearLabel;
                    }
                    else if(monthCounter == 9) {
                        quarterCounter = 'Q3';
                        //str_qLabel = 'Q3' + ' / ' + str_yearLabel;
                    }
                    else if(monthCounter == 12) {
                        quarterCounter = 'Q4';
                        //str_qLabel = 'Q4' + ' / ' + str_yearLabel;
                    }
                    str_qLabel = str_yearLabel + ' ' + quarterCounter;
                    APL_ClsEntityType.DateItem tempTotalItem = new APL_ClsEntityType.DateItem(str_qLabel);
                    tempTotalItem.qtotalCls = ('qtotalCls' + (j < pageConf.currentMonthIndex ? ' exp_coll ' : ' '));
                    tempTotalItem.qtotalCls += (j == pageConf.currentMonthIndex ? ' crtQtotal ' : ' ');
                    tempTotalItem.qMonths = temp_qMonths;
                    tempTotalItem.monthCls = 'monthCls';
                    tempTotalItem.cls = clsname;
                    tempTotalItem.isFutrue = isfutrue;
                    //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'tempTotalItem :: '+ tempTotalItem));
                    temp_qMonths = '';
                    //DateItem tempTotalItem = new DateItem('Q Total');
                    tempTotalItem.total = 'q' + j / 3;
                    tempTotalItem.isInput = false;
                    tempTotalItem.qLabel = str_yearFullLabel + '_' + quarterCounter.replace('Q', '0');
                    
                    if(j > pageConf.currentMonthIndex) {
                        if(!pageConf.map_year_quartersFuture.containsKey(str_yearFullLabel)) {
                            pageConf.map_year_quartersFuture.put(str_yearFullLabel, new set<String>());
                        }
                        pageConf.map_year_quartersFuture.get(str_yearFullLabel).add(quarterCounter.replace('Q', '0'));
                    }
                    //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'tempTotalItem :: ' + tempTotalItem));
                    list_allDateItems.add(tempTotalItem); 
                    pageConf.map_quarter_months.put(tempTotalItem.qLabel, tempTotalItem.qMonths);
                    
                }
            }
            
        }
        
        pageConf.str_futureQuarterMap = Json.serialize(pageConf.map_year_quartersFuture);
        pageConf.str_futureMonthMap = Json.serialize(pageConf.map_year_monthsFuture);
        pageConf.json_map_quarter_months = Json.serialize(pageConf.map_quarter_months);
    }

    public static void setGAMViewAccountObjMap(map<String, APL_ClsEntityType.AccountObj> map_acctId_acctFC, APL_ClsEntityType.PageConfig pageconf, list<String> list_sql, set<String> set_oemIds, Date currentdate, Date enddate) {
        for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
            //system.debug('@#result : '+result);
            String accId = (String)result.get('oem'), 
                   year = (String) result.get('year'),
                   month = (String) result.get('month'), 
                   dateKey = (year + '_' + month);
                   
            APL_ClsEntityType.AccountObj acctFC = new APL_ClsEntityType.AccountObj();
    
            if(!map_acctId_acctFC.containsKey(accId)) {
                APL_ClsUtils.createAccountObj(acctFC, pageconf.map_financialMonth);
                
                acctFC.id = accId;
                acctFC.name = (String)result.get('accname');

                map_acctId_acctFC.put(accId, acctFC);
            }else {
                acctFC = map_acctId_acctFC.get(accId);
            }

            acctFC.csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
            acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
            acctFC.pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
            acctFC.restPNFC.put(dateKey, (result.get('restPNFC') != null ? (decimal)result.get('restPNFC') : 0));
            map_acctId_acctFC.put(accId, acctFC);            
        }
    }
    
    /**
    * This method is used to create a new interface instance
    *
    @author Bin Yuan
    @created 2015-06-02
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-06-02 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void setTerritoryInfo(set<String> set_rsmTerritoryCodes, String rsmType, String managerId) {
        
        String rsmQueryFields = ' A6_Code__c territoryCode, RecordType.DeveloperName rtName, RSM__r.Display_Name__c displayName, RSM__r.Type__c rsmType, RSM__c rsmId, RSM_Freeze__c isFrozen';
        String rsmQueryObj = ' APL_Forecast_Management__c ';
        String rsmQueryFilter = ' Where RecordType.DeveloperName = \''+rsmType+'\' and RSM__r.Manager__c = \'' + managerId + '\' And  A6_Code__c != null and RecordTypeId != null group by A6_Code__c, RSM__r.Display_Name__c, RSM__c, RSM__r.Type__c, RecordType.DeveloperName, RSM_Freeze__c ';
        String rsmQuery = APL_ClsUtils.getQueryString(new list<String>{rsmQueryFields, rsmQueryObj, rsmQueryFilter});
        
        for(AggregateResult result : database.query(rsmQuery)) {
            String territoryCode = (String) result.get('territoryCode');
            String rtName = (String) result.get('rtName');
            if(rtName == rsmType) {
                set_rsmTerritoryCodes.add(territoryCode);
            }
        }
    }
    
    /**
    * This method is used to create a new interface instance
    *
    @author Bin Yuan
    @created 2015-06-02
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-06-02 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void setTerritoryUserName(map<String, String> map_territory_name, String rsmType, String managerId) {
        
        String rsmQueryFields = ' A6_Code__c territoryCode, Manager__r.Name username';
        String rsmQueryObj = ' APL_Forecast_Management__c ';
        String rsmQueryFilter = ' Where RecordType.DeveloperName = \''+rsmType+'\' and RSM__r.Manager__c = \'' + managerId + '\' And  A6_Code__c != null and RecordTypeId != null group by A6_Code__c, Manager__r.Name ';
        String rsmQuery = APL_ClsUtils.getQueryString(new list<String>{rsmQueryFields, rsmQueryObj, rsmQueryFilter});
        
        for(AggregateResult result : database.query(rsmQuery)) {
            String territoryCode = (String) result.get('territoryCode');
            String username = (String) result.get('username');
            if(!map_territory_name.containsKey(territoryCode)) {
                map_territory_name.put(territoryCode, username);
            }
        }
    }
    
    
    
    public static void setAllTerritoryCode(String managerId,set<String> set_rsmAMTerritoryCodes,set<String> set_rsmRelayTerritoryCodes,set<String> set_rsmDisplayName, String displayNameType){
        
        
        String rsmQueryFields = ' A6_Code__c territoryCode, RecordType.DeveloperName rtName, RSM__r.Display_Name__c displayName, RSM__r.Type__c rsmType, RSM__c rsmId, RSM_Freeze__c isFrozen';
        String rsmQueryObj = ' APL_Forecast_Management__c ';
        String rsmQueryFilter = ' Where RSM__r.Manager__c = \'' + managerId + '\' And A6_Code__c != null and RecordTypeId != null group by A6_Code__c, RSM__r.Display_Name__c, RSM__c, RSM__r.Type__c, RecordType.DeveloperName, RSM_Freeze__c ';
        String rsmQuery = APL_ClsUtils.getQueryString(new list<String>{rsmQueryFields, rsmQueryObj, rsmQueryFilter});
        
        for(AggregateResult result : database.query(rsmQuery)) {
            String territoryCode = (String) result.get('territoryCode');
            String rtName = (String) result.get('rtName');
            String displayname = (String) result.get('displayName');
            if(rtName == 'AM') {
                set_rsmAMTerritoryCodes.add(territoryCode);
            }else if(rtName == 'Relay') {
                set_rsmRelayTerritoryCodes.add(territoryCode);
            }
            
            if(rtName == displayNameType) {
                set_rsmDisplayName.add(displayname);
            }
        }
        
    }

    public static String getHasForecastProdectCodeQuery(String grouping, String cbc2Code, String territoryCode,
                                               map<String, set<String>> map_year_quartersFuture, boolean isForHighlight) {
        
        String query = ' Select ' + (isForHighlight ? ' Customer__c acctId, PRODUCT_CDE__c partId ' : ' PRODUCT_CDE__c partId ');
        query += ' FROM APL_Sales_Forecast__c ';
        query += ' WHERE Id != null ';
        query += ' And Customer__r.STATDESC__c != \'Not Active\' '; 
        query += ClsGroupingRelayForecastUtil.getRelayPartSearchQueryFilter(cbc2Code, true);  
        query += ClsAPLForecastUtil.getMonthFilter(map_year_quartersFuture);
        
        String str_filter = ClsGroupingRelayForecastUtil.getForecastParentFilter(grouping, territoryCode, false);
        //str_filter += ' And Type__c = \'' + PARTFCTYPE + '\'';
        str_filter += ' And Type__c = \'' + RELAYPRODUCTCODEFCTYPE + '\'';
        String str_groupby = ' Group by' + (isForHighlight ? ' Customer__c, PRODUCT_CDE__c ' : ' PRODUCT_CDE__c ');
        
        query += (str_filter + str_groupby);
        
        return query;
    }


    /**
    * This method is used to get the 
    *
    @author Weihang Li
    @created 2015-06-20
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-06-20 Weihang Li <weihnag.li@itbconsult.com>
    * - Created
    */
    public static void getExistingProductCodeFC(String grouping, String cbc2Code, String territoryCode, String quartNumb, 
                                        map<String, set<String>> map_year_quartersFuture,
                                        map<String, map<String, map<String, APL_Sales_Forecast__c>>> map_partId_map_acctId_map_dateKey_fc) {
                                            
        String query = ' Select Id, Customer__c, Fiscal_Quarter__c, Fiscal_Year__c, PRODUCT_CDE__c, CurrencyIsoCode  '
                     + ' From APL_Sales_Forecast__c '
                     + ' Where Type__c = \'' + RELAYPRODUCTCODEFCTYPE + '\' ';
        query += ' And Customer__r.STATDESC__c != \'Not Active\' '; 
        query += ClsGroupingRelayForecastUtil.getForecastParentFilter(grouping, territoryCode, false);
        query += ClsAPLForecastUtil.getMonthFilter(map_year_quartersFuture);
        query += ' And Relay_CBC2_Code__c = \'' + cbc2Code + '\' ';
        
        system.debug('!@#old query:'+query);
        
        for(APL_Sales_Forecast__c fc : database.query(query)) {
            String dateKey = fc.Fiscal_Year__c + '_' + fc.Fiscal_Quarter__c;
            String acctId = fc.Customer__c;
            String productcode = fc.PRODUCT_CDE__c;
            
            if(!map_partId_map_acctId_map_dateKey_fc.containsKey(productcode)) {
                map_partId_map_acctId_map_dateKey_fc.put(productcode, new map<String, map<String, APL_Sales_Forecast__c>>());
            }
            if(!map_partId_map_acctId_map_dateKey_fc.get(productcode).containsKey(acctId)) {
                map_partId_map_acctId_map_dateKey_fc.get(productcode).put(acctId, new map<String, APL_Sales_Forecast__c>());
            }
            if(!map_partId_map_acctId_map_dateKey_fc.get(productcode).get(acctId).containsKey(dateKey)) {
                map_partId_map_acctId_map_dateKey_fc.get(productcode).get(acctId).put(dateKey, fc);
            }
        }
    }
    
    /**
    * This method is used to get the 
    *
    @author Weihang Li
    @created 2015-06-20
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-06-20 Weihang Li <weihnag.li@itbconsult.com>
    * - Created
    */
    public static void getExistingPartFC(String grouping, String cbc2Code, String territoryCode, String quartNumb, 
                                        map<String, set<String>> map_year_quartersFuture,
                                        map<String, map<String, map<String, APL_Sales_Forecast__c>>> map_partId_map_acctId_map_dateKey_fc) {
        String query = ' Select Id, Customer__c, Fiscal_Quarter__c, Fiscal_Year__c, Part__c,CurrencyIsoCode '
                     + ' From APL_Sales_Forecast__c '
                     + ' Where Type__c = \'' + RELAYFCTYPE + '\' ';
        query += ' And Customer__r.STATDESC__c != \'Not Active\' '; 
        query += ClsGroupingRelayForecastUtil.getForecastParentFilter(grouping, territoryCode, false);
        query += ClsAPLForecastUtil.getMonthFilter(map_year_quartersFuture);
        query += ' And Part__r.Product_Hierarchy__r.' + ClsAPLServiceRSMRelay.getRelayField(cbc2Code) + ' = \'' + cbc2Code + '\' ';        
        for(APL_Sales_Forecast__c fc : database.query(query)) {
            String dateKey = fc.Fiscal_Year__c + '_' + fc.Fiscal_Quarter__c;
            String acctId = fc.Customer__c;
            String partId = fc.Part__c;
            
            if(!map_partId_map_acctId_map_dateKey_fc.containsKey(partId)) {
                map_partId_map_acctId_map_dateKey_fc.put(partId, new map<String, map<String, APL_Sales_Forecast__c>>());
            }
            if(!map_partId_map_acctId_map_dateKey_fc.get(partId).containsKey(acctId)) {
                map_partId_map_acctId_map_dateKey_fc.get(partId).put(acctId, new map<String, APL_Sales_Forecast__c>());
            }
            if(!map_partId_map_acctId_map_dateKey_fc.get(partId).get(acctId).containsKey(dateKey)) {
                map_partId_map_acctId_map_dateKey_fc.get(partId).get(acctId).put(dateKey, fc);
            }
        }
    }
    
    
    /**
    * This method is used to get the children account billing percent
    *
    @author Weihang Li
    @created 2015-06-20
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-06-20 Weihnag Li <weihang.li@itbconsult.com>
    * - Created
    */
    public static void generateProductFC(APL_ClsEntityType.APLForecastValueObj valueObj,
                                      map<String, map<String, decimal>> map_partId_map_acctId_partPercent, 
                                      map<String, map<String, map<String, APL_Sales_Forecast__c>>> map_partId_map_acctId_map_dateKey_fc,
                                      map<String, decimal> map_acctId_avgPercent,String forecastType, String forecastlevel, 
                                      list<APL_Sales_Forecast__c> list_acctFC2Insert,
                                      list<APL_Sales_Forecast__c> list_acctFC2Update,
                                      list<APL_Sales_Forecast__c> list_acctFC2Delete) {
        system.debug('map_acctId_avgPercent::: '+map_acctId_avgPercent);
        system.debug('map_partId_map_acctId_partPercent::: '+map_partId_map_acctId_partPercent);
        //generate or update part forecast records                  
        //for(String partFC : valueObj.csFC.keySet()) {
            //String partId = partFC.partId.trim();
            //string gplId = partFC.gplId.trim();
            //map<String, map<String, APL_Sales_Forecast__c>> temp_map_acctId_map_dateKey_fc = map_partId_map_acctId_map_dateKey_fc.get(partId);
        
        String datakey = valueObj.partId;
        if(String.isEmpty(valueObj.partId)) {
            datakey = valueObj.productcode;
        }    
        
        map<String, map<String, APL_Sales_Forecast__c>> temp_map_acctId_map_dateKey_fc = new map<String, map<String, APL_Sales_Forecast__c>>();
        map<String, decimal> map_acctId_billingPercent = new map<String, decimal>();
        
        system.debug('map_partId_map_acctId_partPercent::: '+map_partId_map_acctId_partPercent);
        //system.debug('partId::: '+ partId);  
        if(map_partId_map_acctId_partPercent.containsKey(datakey)) {
            map_acctId_billingPercent = map_partId_map_acctId_partPercent.get(datakey);
            system.debug('map_acctId_billingPercent:::: '+map_acctId_billingPercent);
        }else {
            map_acctId_billingPercent = map_acctId_avgPercent;
        }           
        
        if(map_partId_map_acctId_map_dateKey_fc.containsKey(datakey)) {
            temp_map_acctId_map_dateKey_fc = map_partId_map_acctId_map_dateKey_fc.get(datakey);
        }
        //map<String, decimal> map_acctId_billingPercent = map_partId_map_acctId_partPercent.get(partId);
        if(temp_map_acctId_map_dateKey_fc == null) {
            temp_map_acctId_map_dateKey_fc = new map<String, map<String, APL_Sales_Forecast__c>>();
        }
        
        generateFC(map_acctId_billingPercent, valueObj.map_datekey_csFC, temp_map_acctId_map_dateKey_fc, 
                    valueObj.currencyIso, forecastType, valueObj.productcode, valueObj.productname, 
                    valueObj.cbc2Code, valueObj.partId,valueObj.price, forecastlevel, list_acctFC2Insert, list_acctFC2Update, list_acctFC2Delete);
        //}
    }
    
    
    /**
    * This method is used to build currency iso map 
    *
    @author Weihang Li
    @created 2015-06-20
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-06-20 Weihang Li <weihang.li@itbconsult.com>
    * - Created
    */
    private static void generateFC(map<String, decimal> map_acctId_billingPercent, map<String, decimal> map_dateKey_fc,
                                    map<String, map<String, APL_Sales_Forecast__c>> map_acctId_map_dateKey_fc, 
                                    String currencyIso, String fcType, String productcode, String productName, String cbc2code, String partId, decimal price,
                                    String forecastType, 
                                    list<APL_Sales_Forecast__c> list_acctFC2Insert,
                                    list<APL_Sales_Forecast__c> list_acctFC2Update, 
                                    list<APL_Sales_Forecast__c> list_acctFC2Delete) {
        
        set<String> set_updatedAcctFCIds = new set<String>();
        system.debug('@#partId : '+partId);
        if(map_acctId_map_dateKey_fc == null) {
            map_acctId_map_dateKey_fc = new map<String, map<String, APL_Sales_Forecast__c>>();
        }
        integer i = 0;
        map<String, decimal> dateKey_sumQuantity = new map<String, decimal>();
        //create or update account forecast records
        for(String acctId : map_acctId_billingPercent.keySet()) {
            for(String dateKey : map_dateKey_fc.keySet()) {
                //if has such account percent will not generate apl forecast record for this account
                if(!map_acctId_billingPercent.containsKey(acctId)) {
                    continue;
                }
                String year = dateKey.substringBefore('_');
                String quarter = dateKey.substringAfter('_');
                decimal amount = map_dateKey_fc.get(dateKey);
                system.debug('fcamount::: '+amount);
                
                decimal percent = map_acctId_billingPercent.get(acctId);
                
                if(!dateKey_sumQuantity.containsKey(dateKey)) {
                    dateKey_sumQuantity.put(dateKey, 0);
                }
                decimal sumQuantity = dateKey_sumQuantity.get(dateKey); 
                APL_Sales_Forecast__c acctFC = new APL_Sales_Forecast__c();
                if(map_acctId_map_dateKey_fc.containsKey(acctId) 
                        && map_acctId_map_dateKey_fc.get(acctId).containsKey(dateKey)) {
                    acctFC = map_acctId_map_dateKey_fc.get(acctId).get(dateKey);
                    system.debug('acctFC：：： '+acctFC);
                }
                
                if(acctFC.Id == null) {
                    acctFC.Customer__c = acctId;
                    acctFC.CurrencyIsoCode = currencyIso;
                }
                
                //
                acctFC.Type__c = fcType;
                acctFC.Fiscal_Year__c = year;
                acctFC.Fiscal_Quarter__c = quarter;
                
                
                if(!String.isEmpty(partId)) {
                    acctFC.Part__c = partId;
                }
                system.debug('fc.amount::: ' + amount);    
                system.debug('percent::: ' + percent); 
                decimal quantity = amount * percent;
                if(quantity != 0) {
                    quantity = quantity.setScale(0, System.Roundingmode.HALF_UP);
                }
                
                if(i == (map_acctId_billingPercent.size() -1)) {
                    quantity = amount - sumQuantity;
                }
                
                if(forecastType == AMFCTYPE) {
                	decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, currencyIso, 'USD');
                    acctFC.CurrencyIsoCode = currencyIso;
                    acctFC.Price__c = price;
                    acctFC.RSM_Price__c = price;

                    acctFC.Quantity__c = quantity;
                    acctFC.RSM_Quantity__c = quantity;
                    
                    acctFC.Forecast__c = price * acctFC.Quantity__c;
                    acctFC.RSM_Forecast__c = acctFC.Forecast__c * currencyRate;
                    acctFC.GAM_Forecast__c = acctFC.Forecast__c * currencyRate;  
                    
                    
                }else if(forecastType == GAMFCTYPE){
                    decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1,'USD', acctFC.CurrencyIsoCode);
                    acctFC.RSM_Price__c = price * currencyRate;

                    acctFC.RSM_Quantity__c = quantity;
                    
                    acctFC.RSM_Forecast__c = price * acctFC.RSM_Quantity__c;
                    acctFC.GAM_Forecast__c = acctFC.RSM_Forecast__c;
                }else if(forecastType == RSMFCTYPE) {
                    decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1,'USD', acctFC.CurrencyIsoCode);
                    acctFC.RSM_Price__c = price * currencyRate;
                    acctFC.RSM_Quantity__c = quantity;
                    acctFC.RSM_Forecast__c = price * acctFC.RSM_Quantity__c;
                }
                
                sumQuantity += quantity;
                if(dateKey_sumQuantity.containsKey(dateKey)) {
                    dateKey_sumQuantity.put(dateKey, sumQuantity);
                }
                
                if(fcType == RELAYPRODUCTCODEFCTYPE) {
                    acctFC.PRODUCT_CDE__c = productcode;
                    acctFC.PROD_NAME__c = productName;
                    acctFC.Relay_CBC2_Code__c = cbc2code;
                }
                if(acctFC.Id != null) {
                    
                    list_acctFC2Update.add(acctFC);
                    set_updatedAcctFCIds.add(acctFC.Id);
                }else {
                    
                    list_acctFC2Insert.add(acctFC);
                }
            }
            i++;
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
    * This method is used to build currency iso map 
    *
    @author Weihang Li
    @created 2015-06-20
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-06-20 Weihang Li <weihang.li@itbconsult.com>
    * - Created
    */
    public static void generateAMFC(map<String, decimal> map_acctId_billingPercent, map<String, decimal> map_dateKey_fc,
                                    map<String, map<String, APL_Sales_Forecast__c>> map_acctId_map_dateKey_fc, 
                                    String currencyIso, String fcType, String gplId, String partId, String forecastType, 
                                    list<APL_Sales_Forecast__c> list_acctFC2Insert,
                                    list<APL_Sales_Forecast__c> list_acctFC2Update, 
                                    list<APL_Sales_Forecast__c> list_acctFC2Delete) {

        set<String> set_updatedAcctFCIds = new set<String>();
        //decimal usdcurrencyRate = ClsAPLForecastUtil.transformIsoCode(1, currencyIso, 'USD');
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
                decimal amount = map_dateKey_fc.get(dateKey);
                decimal percent = map_acctId_billingPercent.get(acctId);
                decimal fc = amount * percent;
                
                APL_Sales_Forecast__c acctFC = new APL_Sales_Forecast__c();
                if(map_acctId_map_dateKey_fc.containsKey(acctId) 
                        && map_acctId_map_dateKey_fc.get(acctId).containsKey(dateKey)) {
                    acctFC = map_acctId_map_dateKey_fc.get(acctId).get(dateKey);
                    system.debug('acctFC：：： '+acctFC);
                }
                
                if(acctFC.Id == null) {
                    acctFC.Customer__c = acctId;
                    acctFC.CurrencyIsoCode = currencyIso;
                }
                
                //
                acctFC.Type__c = fcType;
                acctFC.Fiscal_Year__c = year;
                acctFC.Fiscal_Quarter__c = quarter;
                acctFC.GPL__c = ((gplId != null && gplId != 'null' && gplId != '')? gplId : null);
                
                acctFC.Part__c = (fcType == PARTFCTYPE ? partId : null);
				decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, currencyIso, 'USD');
                if(forecastType == AMFCTYPE) {
                    acctFC.CurrencyIsoCode = currencyIso;
                    acctFC.Forecast__c = fc;
                    acctFC.GAM_Forecast__c = fc * currencyRate;
                    acctFC.RSM_Forecast__c = fc * currencyRate;

                }else if(forecastType == GAMFCTYPE){

                    acctFC.RSM_Forecast__c = fc;
                    acctFC.GAM_Forecast__c = fc;
                }else if(forecastType == RSMFCTYPE) {
                    acctFC.RSM_Forecast__c = fc;
                }

                if(acctFC.Id != null) {
                    
                    list_acctFC2Update.add(acctFC);
                    set_updatedAcctFCIds.add(acctFC.Id);
                }else {
                    
                    list_acctFC2Insert.add(acctFC);
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
    * This method is used to get GPLs for CBC2
    *
    @author Bin Yuan
    @created 2015-04-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-04-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static String getRelayCBC2CodeQuery() {
        String str_relayQuery = 'And ( TEMP ) ';
        String tempQuery = '';
        for(String cbc2code: SET_RELAY_CBC2CODE) {
            tempQuery += ('Relay_CBC2_Code__c = '+ ' \'' + cbc2code + '\' ' + ' OR ' ); 
        }
        tempQuery = tempQuery.removeEnd('OR ');
        str_relayQuery = str_relayQuery.replace('TEMP', tempQuery);
        return str_relayQuery;
    }
    
    /**
    * This method is used to apl previous month forecast
    *
    @author Lili Zhao
    @created 2015-05-18
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-05-18 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static String getRelayCBCFilter(String cbcKey) {
        String filter = ' Part__r.Product_Hierarchy__r.';
        for(String cbcAPI : map_RELAY_CBCFIELD_CBCDESC.keySet()) {
            if(map_RELAY_CBCFIELD_CBCDESC.get(cbcAPI).contains(cbcKey)) {
                filter += (cbcAPI + ' = \'' + cbcKey + '\'');
            }
        }
        return filter; 
    }
    
    /**
    * This method is used to build currency iso map 
    *
    @author Bin Yuan
    @created 2015-04-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-04-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static boolean deletePart(String grouping, String territoryCode, boolean isOther, String cbc2Code, String gplId, String partId) {
        list<APL_Sales_Forecast__c> list_aplFC = new list<APL_Sales_Forecast__c>();
        String query = ' Select Id From APL_Sales_Forecast__c WHERE Id != null ';
        query += ClsGroupingAMForecastUtil.getForecastParentFilter(grouping, territoryCode, false);
        query += ClsGroupingAMForecastUtil.getPartSearchQueryFilter(gplId, isOther, true);
        query += ' And Part__c = \'' + partId + '\'';
        query += ' And Type__c = \'Part\' ';
        try {
            system.debug('deletePart query :: ' + query);
            for(APL_Sales_Forecast__c fc : database.query(query)) {
                list_aplFC.add(fc);
            }
            if(!list_aplFC.isEmpty()) {
                delete list_aplFC;
            }
            return true;
        }
        catch(Exception ex) {
            return false;
        }
    }
    
    
    public static void setHighlight(APL_ClsEntityType.SearchObj searchOb, String fcType, String fclevel, map<String, APL_ClsEntityType.RSMAccountObj> map_acctId_acctFC) {
        
        if(map_acctId_acctFC.size() > 0) {
            set<String> set_key = map_acctId_acctFC.keySet();
            String year = '';
            String quarter = '';
            list<String> list_date = new list<String>();
            for(String yearkey : searchOb.map_year_quartersFuture.keySet()) {
                year = yearkey;
                for(String quarterkey : searchOb.map_year_quartersFuture.get(yearkey)) {
                    quarter  = quarterkey;
                    break;
                }
                break;
            }

            list<String> list_sql = new list<String>();
            
            
            
            if(fcType == RELAYFCTYPE && fclevel == AMFCTYPE && searchOb.isOtherMethod != null && searchOb.isOtherMethod) { // AM-Relay
                list_sql.add(' Part__r.PRODUCT_CDE__c acctid ');
                list_sql.add(' APL_Sales_Forecast__c ');
                list_sql.add(' WHERE Customer__r.STATDESC__c = \'Active\' '
                    + ' ANd Customer__r.APL_AM_forecast_Plan_Account__c = ' 
                    + (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ')
                    + ' And Customer__r.SALES_TERRITORY_CDE__c = \'' + searchOb.territoryCode + '\' '
                    //+ ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
                    + ' And Fiscal_Year__c = \''+year+'\' '
                    + ' And Fiscal_Quarter__c = \''+quarter+'\' '
                    + ' And Type__c = \'' + fcType + '\' ' 
                    + ' And Part__r.PRODUCT_CDE__c IN :set_key '
                    + ' Group by Part__r.PRODUCT_CDE__c '); 
            }else if(fcType == RELAYFCTYPE && fclevel == AMFCTYPE) { //Relay
                list_sql.add(' Part__r.PRODUCT_CDE__c acctid ');
                list_sql.add(' APL_Sales_Forecast__c ');
                list_sql.add(' WHERE Customer__r.STATDESC__c = \'Active\' '
                    + ' ANd Customer__r.APL_Relay_forecast_Plan_Account__c = ' 
                    + (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ')
                    + ' And Customer__r.Relay_Specialist_Territory_Code__c = \'' + searchOb.territoryCode + '\' '
                    //+ ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
                    + ' And Fiscal_Year__c = \''+year+'\' '
                    + ' And Fiscal_Quarter__c = \''+quarter+'\' '
                    + ' And Type__c = \'' + fcType + '\' ' 
                    + ' And Part__r.PRODUCT_CDE__c IN :set_key '
                    + ' Group by Part__r.PRODUCT_CDE__c '); 
            }else if(fcType == PARTFCTYPE && fclevel == RSMFCTYPE) { //RSM AM 
                list_sql.add(' GPL__c acctid ');
                list_sql.add(' APL_Sales_Forecast__c ');
                list_sql.add(' WHERE Customer__r.APL_AM_forecast_Plan_Account__c = ' 
                    + (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ') 
                    + ' And Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ')
                    + ' And GPL__c IN : set_key '
                    + ' And Part__c != null '
                    + ' And Type__c = \'' + fcType + '\' ' 
                    + ' And Fiscal_Year__c = \''+year+'\' '
                    + ' And Fiscal_Quarter__c = \''+quarter+'\' '
                    + ' And Customer__r.STATDESC__c = \'Active\' '
                    + ' Group by GPL__c ');
            }else if(fcType == RELAYFCTYPE && fclevel == RSMFCTYPE) { //RSM Relay
                list_sql.add(' Part__r.PRODUCT_CDE__c acctid ');
                list_sql.add(' APL_Sales_Forecast__c ');
                list_sql.add(' WHERE Customer__r.APL_Relay_forecast_Plan_Account__c = \'' + searchOb.grouping + '\' '
                    + ' And Customer__r.STATDESC__c = \'Active\' '
                    + ' And Part__r.PRODUCT_CDE__c IN :set_key '
                    + ' And Fiscal_Year__c = \''+year+'\' '
                    + ' And Fiscal_Quarter__c = \''+quarter+'\' '
                    + ' And Type__c = \'' + fcType + '\' '  
                    + ' Group by Part__r.PRODUCT_CDE__c '); 
            }else if(fcType == RELAYFCTYPE && fclevel == GAMFCTYPE) {//GAM
                list_sql.add(' Part__r.PRODUCT_CDE__c acctid ');
                list_sql.add(' APL_Sales_Forecast__c ');
                list_sql.add(' WHERE Customer__c = \'' + searchOb.soldtoId + '\' '
                    + ' And Part__c != null '
                    + ' And Fiscal_Year__c = \''+year+'\' '
                    + ' And Fiscal_Quarter__c = \''+quarter+'\' '
                    + ' And Type__c = \'' + fcType + '\' '  
                    + ' And Part__r.PRODUCT_CDE__c IN :set_key '
                    + ' Group by Part__r.PRODUCT_CDE__c ');
            }
            
            if(list_sql.size() == 0) {
                return;
            }
            system.debug('!@#list_sql : '+ APL_ClsUtils.getQueryString(list_sql));
            for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
                String accId = (String) result.get('acctid');
                
                if(map_acctId_acctFC.containsKey(accId)) {
                    APL_ClsEntityType.RSMAccountObj acctFC = map_acctId_acctFC.get(accId);
                    acctFC.isHighLighted = true;
                    map_acctId_acctFC.put(accId, acctFC);
                }
            }
        }

    }
    

    public static void setAMGPLHighlight(String cbc2Name, CtrlGroupingRemoteBase.GPLInfo gpl, map<String, ClsGroupingAMForecastUtil.GPLViewFields> map_gplId_fcViewObj) {
        
        if(map_gplId_fcViewObj.size() > 0) {
            set<String> set_key = map_gplId_fcViewObj.keySet();
            
            String year = '';
            String quarter = '';
            
            for(String yearkey : gpl.map_year.keySet()) {
                year = yearkey;
                for(String quarterkey : gpl.map_year.get(yearkey)) {
                    quarter  = quarterkey;
                    break;
                }
                break;
            }
            list<String> list_sql = new list<String>();
            list_sql.add(' GPL__c acctid ');
            list_sql.add(' APL_Sales_Forecast__c ');
            list_sql.add(' WHERE Customer__r.APL_AM_forecast_Plan_Account__c = \''+gpl.aid+'\'' 
                + ' And GPL__r.CBC2__c =\'' + cbc2Name + '\' '
                + ' And GPL__c IN : set_key '
                + ' And Part__c != null '
                + ' And Type__c = \'Part\' ' 
                + ' And Fiscal_Year__c = \''+year+'\' '
                + ' And Fiscal_Quarter__c = \''+quarter+'\' '
                + ' And Customer__r.STATDESC__c = \'Active\' '
                + ' Group by GPL__c ');
                    
            for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
                String accId = (String) result.get('acctid');
                
                if(map_gplId_fcViewObj.containsKey(accId)) {
                    ClsGroupingAMForecastUtil.GPLViewFields acctFC = map_gplId_fcViewObj.get(accId);
                    acctFC.isHighLighted = true;
                    map_gplId_fcViewObj.put(accId, acctFC);
                }
            }
        }
    }
    
    public static void setRSMAMGPLHighlight(ClsAPLEntityTypes.RSMGPLFCInfo rsmGPL, map<String, ClsAPLEntityTypes.GPLFCValueObj> map_gplId_gplFC) {
        
        if(map_gplId_gplFC.size() > 0) {
            set<String> set_key = map_gplId_gplFC.keySet();
            
            String year = '';
            String quarter = '';
            
            for(String yearkey : rsmGPL.map_year_quartersFuture.keySet()) {
                year = yearkey;
                for(String quarterkey : rsmGPL.map_year_quartersFuture.get(yearkey)) {
                    quarter  = quarterkey;
                    break;
                }
                break;
            }
            list<String> list_sql = new list<String>();
            list_sql.add(' GPL__c acctid ');
            list_sql.add(' APL_Sales_Forecast__c ');
            list_sql.add(' WHERE Customer__r.APL_AM_forecast_Plan_Account__c = ' 
                    + (rsmGPL.acctId == ClsAPLForecastUtil.OTHERACCTID ? ' null ' : '\'' +  rsmGPL.acctId + '\' ') 
                    + ' And Customer__r.SALES_TERRITORY_CDE__c = \'' + rsmGPL.territoryCode + '\' '
                    + (rsmGPL.cbc2Code == ClsAPLForecastUtil.CBCRELAY ? ClsAPLForecastUtil.getRelayGPLQuery(false) : ' And GPL__r.CBC2__c =\'' + rsmGPL.cbc2Code + '\' ')
                    + ' And GPL__c IN : set_key '
                    + ' And Part__c != null '
                    + ' And Type__c = \'Part\' ' 
                    + ' And Fiscal_Year__c = \''+year+'\' '
                    + ' And Fiscal_Quarter__c = \''+quarter+'\' '
                    + ' And Customer__r.STATDESC__c = \'Active\' '
                    + ' Group by GPL__c ');

            for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
                String accId = (String) result.get('acctid');
                
                if(map_gplId_gplFC.containsKey(accId)) {
                    ClsAPLEntityTypes.GPLFCValueObj acctFC = map_gplId_gplFC.get(accId);
                    acctFC.isHighLighted = true;
                    map_gplId_gplFC.put(accId, acctFC);
                }
            }
        }
    }
    
    public static void setGAMAMGPLHighlight(ClsAPLEntityTypes.GAMGPLFCInfo gamGPL, map<String, ClsAPLEntityTypes.GPLFCValueObj> map_gplId_gplFC) {
        
        if(map_gplId_gplFC.size() > 0) {
            set<String> set_key = map_gplId_gplFC.keySet();
            
            String year = '';
            String quarter = '';
            
            for(String yearkey : gamGPL.map_year_quartersFuture.keySet()) {
                year = yearkey;
                for(String quarterkey : gamGPL.map_year_quartersFuture.get(yearkey)) {
                    quarter  = quarterkey;
                    break;
                }
                break;
            }
            list<String> list_sql = new list<String>();
            list_sql.add(' GPL__c acctid ');
            list_sql.add(' APL_Sales_Forecast__c ');
            list_sql.add(' WHERE Customer__c = \'' + gamGPL.acctId + '\' ' 
                    + ' And GPL__r.CBC2__c =\'' + gamGPL.cbc2Code + '\' '
                    + ' And GPL__c IN : set_key '
                    + ' And Part__c != null '
                    + ' And Type__c = \'Part\' ' 
                    + ' And Fiscal_Year__c = \''+year+'\' '
                    + ' And Fiscal_Quarter__c = \''+quarter+'\' '
                    + ' And Customer__r.STATDESC__c = \'Active\' '
                    + ' Group by GPL__c ');

            for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
                String accId = (String) result.get('acctid');
                
                if(map_gplId_gplFC.containsKey(accId)) {
                    ClsAPLEntityTypes.GPLFCValueObj acctFC = map_gplId_gplFC.get(accId);
                    acctFC.isHighLighted = true;
                    map_gplId_gplFC.put(accId, acctFC);
                }
            }
        }
    }
    
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
}