/**
 *  This class is CSD forecast util class
 *  
 * @author Lei Tang
 * @created 2014-09-19
 * @version 1.0
 * @since 30.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2014-09-19 Lei Tang lei.tang@itbconsult.com>
 * - Created
 * - 02/09/2016 Rajendra <Shahane rajendra.shahane@zensar.com>
* - Modified for project DND Forecast Tool Enhancement 2
* - Test Class : CSD_ClsUtils _Test
 */
public without sharing class CSD_ClsUtils {
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public static final Integer QNUMBER = 7;
    public static final Integer FUTUREQNUMBER = 19;
    
    public static final Integer QNUMBERCOMP = 1;
    public static final Integer FUTUREQNUMBERCOMP = 6;
    
    public static final map<String, Integer> MAP_MONTHLABELNUMBER = new map<String, Integer>{
        'Jan' => 4, 'Feb' => 5, 'Mar' => 6, 'Apr' => 7, 'May' => 8, 'Jun' => 9,
        'Jul' => 10, 'Aug' => 11, 'Sep' => 12, 'Oct' => 1, 'Nov' => 2, 'Dec' => 3
    };
    public static final map<Decimal, String> MAP_NUMBERMONTHLABEL = new map<Decimal, String>{
        4 => 'Jan', 5 => 'Feb', 6 => 'Mar', 7 => 'Apr', 8 => 'May', 9 => 'Jun',
        10 => 'Jul', 11 => 'Aug', 12 => 'Sep', 1 => 'Oct', 2 => 'Nov', 3 => 'Dec'
    };
    public static final map<Decimal, String> MAP_NUMBERFULLMONTHLABEL = new map<Decimal, String>{
        4 => 'January', 5 => 'February', 6 => 'March', 7 => 'April', 8 => 'May', 9 => 'June',
        10 => 'July', 11 => 'August', 12 => 'September', 1 => 'October', 2 => 'November', 3 => 'December'
    };
    public static final map<Integer, String> MAP_MONTH_INT_STRING = new map<Integer, String>{
        1 => '01', 2 => '02', 3 => '03', 4 => '04', 5 => '05', 6 => '06',
        7 => '07', 8 => '08', 9 => '09', 10 => '10', 11 => '11', 12 => '13',12 => '13',14 => '14',15 => '15',16 => '16',17 => '17',18 => '18'
    };
    public static final map<String, set<String>> map_RELAY_CBCFIELD_CBCDESC = new map<String, set<String>> {
        'CBC2__c' => new set<String> {'30005', '13213'},
        'CBC3__c' => new set<String> {'40308', '40309'}
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
    
    public static final set<String> SET_INDIAORGID = new set<String> {
        '0464', '1337', '2142'
    };
    
    public static final set<String> SET_CHINAMOBILEOEMNAME = new set<String> {
        'OPPO', 'VIVO', 'XIAOMI', 'COOLPAD', 'CHINA WHITEBOX'
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
    
    public static final String TEMPUSERID = '005E0000003b5Qp';
    public static final String RESTSOLDTOID = '00100RestSoldTo';
    public static final String NONOEMSID = '001c000000gBPUJAA4';
    public static final String RESTPARTID = '00100RestPartId';
    
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
    public static void setUserLocale(CSD_ClsEntityType.LocaleConfig localeConfig, String userLocale){
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
    @created 2014-06-02
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-02 Bin Yuan <bin.yuan@itbconsult.com>
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
    @created 2014-06-02
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-02 Bin Yuan <bin.yuan@itbconsult.com>
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
    public static void createDateItem(CSD_ClsEntityType.PageConfig pageConf, list<CSD_ClsEntityType.DateItem> list_allDateItems) {
        
        String str_monthLabel = '';
        String str_qLabel = '';
        String str_mLabel = '';
        String str_yearLabel = '';
        Integer monthCounter = 0;
        CSD_ClsEntityType.DateItem tempDateItem;
        String temp_qMonths = '';
        //generate table header for history, current and future date type
        pageConf.str_tableHead = ((pageConf.str_tableHead == null || pageConf.str_tableHead == '')
                                    ? '<th class="fixthh th_historicalcls tl" colspan="6" style="height: 0px !important;"><div class="fix_lh historicalc">Historical</div></th>'
                                    + '<th class="fixthh th_currentcls tl" old="4" colspan="1"><div class="fix_lh current_cls"><div class="absdiv">Current</div></div></th>'
                                    + '<th class="fixthh th_futurecls futurec tl" colspan="999" ><div class="fix_lh head_futurec">Future</div></th>' : pageConf.str_tableHead);

        /*for(Integer i = pageConf.currentMonth - 6 ; i <= pageConf.currentMonth + 11; i++) {
            //To Do
            //get year month columns 
            CSD_ClsEntityType.DateItem tempMonthItem = new CSD_ClsEntityType.DateItem('');
            //tempMonthItem.type2 = 'cfixmonthw';
            //tempMonthItem.type3 = 'totalbg';
            if(i < pageConf.currentMonth) {
                tempMonthItem.cls = 'historicalcls';
            }else if(i == pageConf.currentMonth) {
                tempMonthItem.cls = 'currentcls';
            }else {
                tempMonthItem.cls = 'futurecls';
                tempMonthItem.isInput = true;
            }
            str_yearLabel = pageConf.currentYear;
            monthCounter = i;
            
            if(i <= 0) {
                monthCounter += 12;
                str_yearLabel = String.valueOf(integer.valueOf(str_yearLabel) - 1);
            }
            else if(i > 12) {
                monthCounter -= 12;
                str_yearLabel = String.valueOf(integer.valueOf(str_yearLabel) + 1);
            }
            
            //monthCounter += pageConf.currentMonth;
            String str_yearFullLabel = str_yearLabel;
            
            //set data item month label format 2014-3
            str_mLabel = str_yearFullLabel + '_' + monthCounter;
            str_monthLabel = MAP_NUMBERMONTHLABEL.get(monthCounter);
            
            tempMonthItem.itemName = str_monthLabel + ' / ' + str_yearLabel;
            tempMonthItem.monthCls = 'monthCls';
            
            String ymStr = pageConf.list_yearMonth.get(i - 1);
            tempMonthItem.fYear = str_yearFullLabel;
            tempMonthItem.fMonth = monthCounter;
            tempMonthItem.mLabel = str_mLabel;
            
            list_allDateItems.add(tempMonthItem); 
            
            
            
        }
        pageConf.str_futureQuarterMap = Json.serialize(pageConf.map_year_quartersFuture);
        pageConf.str_futureMonthMap = Json.serialize(pageConf.map_year_monthsFuture);
        //clear map
        */
        
        //Change: Rajendra Shahane: For DND Forecast tool Enhancement 2: Start
        /*for(Integer i = 1; i <= 19; i++) {
            CSD_ClsEntityType.DateItem tempMonthItem = new CSD_ClsEntityType.DateItem('');
            if (i < 7) {
                tempMonthItem.cls = 'historicalcls';
                
            }
            else if (i == 7) {
                tempMonthItem.cls = 'currentcls';
                tempMonthItem.isInput = true;
                
            }
            else if (i > 7){
                tempMonthItem.cls = 'futurecls';
                tempMonthItem.isInput = true;
                tempMonthItem.isFutrue = true;
            }*/
        for(Integer i = 1; i <= (QNUMBER + FUTUREQNUMBER - 1); i++) {
            CSD_ClsEntityType.DateItem tempMonthItem = new CSD_ClsEntityType.DateItem('');
            if (i < QNUMBER) {
                tempMonthItem.cls = 'historicalcls';
                
            }
            else if (i == QNUMBER) {
                tempMonthItem.cls = 'currentcls';
                tempMonthItem.isInput = true;
                
            }
            else if (i > QNUMBER){
                tempMonthItem.cls = 'futurecls';
                tempMonthItem.isInput = true;
                tempMonthItem.isFutrue = true;
            } 
        //Change: Rajendra Shahane: For DND Forecast tool Enhancement 2: End
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

            tempMonthItem.itemName = str_monthLabel + ' / ' + str_yearLabel;
            tempMonthItem.monthCls = 'monthCls';
            //system.debug('@#pageConf.list_yearMonth.size : '+pageConf.list_yearMonth.size());
            //system.debug('@#pageConf.list_yearMonth : '+pageConf.list_yearMonth);
            String ymStr = pageConf.list_yearMonth.get(i - 1);
            tempMonthItem.fYear = ymStr.subString(0, ymStr.indexOf('_'));
            tempMonthItem.fMonth = Integer.valueOf(ymStr.subString(ymStr.indexOf('_') + 1));
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'tempMonthItem :: ' + tempMonthItem));
            tempMonthItem.mLabel = str_mLabel;
            list_allDateItems.add(tempMonthItem); 
            
            if(i >= pageConf.currentMonthIndex) {
                if(!pageConf.map_year_monthsFuture.containsKey(str_yearFullLabel)) {
                    pageConf.map_year_monthsFuture.put(str_yearFullLabel, new set<Integer>());
                }
                pageConf.map_year_monthsFuture.get(str_yearFullLabel).add(monthCounter);
            }
            //system.debug('@#i : '+i);
            //system.debug('@#pageConf.map_year_monthsFuture : '+pageConf.map_year_monthsFuture);
        }
        pageConf.str_futureQuarterMap = Json.serialize(pageConf.map_year_quartersFuture);
        pageConf.str_futureMonthMap = Json.serialize(pageConf.map_year_monthsFuture);
        pageConf.str_financialMonthMap = Json.serialize(pageConf.map_financialMonth);
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
    public static void setFiscalMonth(CSD_ClsEntityType.PageConfig pageConf){   //set current year & current month
        //just set pageConfig for one time
        if(pageConf.isSetupDone) {
            return;
        }
        pageConf.isSetupDone = true;
        map<String, Date> map_startAndEndDate = new map<String, Date>{'s' => system.today(), 'e' =>system.today()};
        //get the entire date range's start date and end date in map. 
        setAllPeriodStartEndDate(map_startAndEndDate);
        //system.debug('@#map_startAndEndDate : '+map_startAndEndDate);
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
        
        system.debug('@#pageConf.map_financialMonth:'+pageConf.map_financialMonth);
        
        map_startAndEndDate.clear();
        
        //set current month index
        setCurrentMonthIndex(pageConf);
        
        //set currency rate  & price decimal Places
        /*if(APL_Forecast_Settings__c.getInstance('Price Decimal Places') != null 
            && APL_Forecast_Settings__c.getInstance('Price Decimal Places').Value__c != null) {
            pageConf.pricePlaces = (String) APL_Forecast_Settings__c.getInstance('Price Decimal Places').Value__c;
        }
        if(APL_Forecast_Settings__c.getInstance('Currency Rate Decimal Places') != null 
            && APL_Forecast_Settings__c.getInstance('Currency Rate Decimal Places').Value__c != null) {
            pageConf.currencyPlaces = (String) APL_Forecast_Settings__c.getInstance('Currency Rate Decimal Places').Value__c;
        }*/
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
    public static void setCurrentMonthIndex(CSD_ClsEntityType.PageConfig pageConf) {
        
        list<String> list_years = new list<String>();
        //system.debug('@#pageConf.map_financialMonth : '+pageConf.map_financialMonth);
        list_years.addAll(pageConf.map_financialMonth.keySet());    // set current month index
        list_years.sort();
        String lastYear = '';
        Integer lastMonth = 0;
        Date tempCurrentDate = Date.newInstance(Integer.valueOf(pageConf.currentYear), pageConf.currentMonth, 1);
        
        String startYear = '';
        Integer startMonth = 1;
        startYear = list_years.get(0);
        list<Integer> list_startmonths = new list<Integer>();
        list_startmonths.addAll(pageConf.map_financialMonth.get(startYear));
        list_startmonths.sort();
        startMonth = list_startmonths.get(0);
        
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
        pageConf.refStartDate = startYear + '-' + (startMonth <= 9 ? '0' 
                               + String.valueOf(startMonth) : String.valueOf(startMonth)) + '-01';
        pageConf.refEndDate = (lastMonth == 12 ? String.valueOf((Integer.valueOf(lastYear) + 1)) + '-01-01' 
                                : lastYear + '-' + (lastMonth <= 8 ? '0' + String.valueOf((lastMonth + 1)) : String.valueOf((lastMonth + 1))) + '-01');
        pageConf.str_historyMonthMap = Json.serialize(pageConf.map_year_monthsHistory);
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'pageConf.refEndDate :: ' + pageConf.refEndDate));
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
        
        for (Period period : [select StartDate from Period where StartDate <= Today and Type = 'Month' order by StartDate desc limit: QNUMBER]) {
            if(period.startDate != null && period.StartDate < map_financialDate.get('s')){
                map_financialDate.put('s', period.StartDate);
            }
        }
        
        for (Period period : [select EndDate from Period where EndDate >= Today and Type = 'Month' order by EndDate limit: FUTUREQNUMBER]) {
            if(period.EndDate != null && period.EndDate > map_financialDate.get('e')){
                map_financialDate.put('e', period.EndDate);
            }
        }                
        
    }
    
    /**
    * This method is used get user territory account list.
    *
    @author Lei Tang
    @created 2014-11-10
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-11-10 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public static void setTerritoryAccountSetBySubordinate(set<String> set_acctIds, set<String> set_userIds) {
        
        set<String> set_TerritoryCodes = new set<String>();
        
        //String likeuserid = '%'+UserInfo.getUserId()+'%';
        for(Sales_Hierarchy__c sh : [select Level_7_Territory_Code__c 
                                        from Sales_Hierarchy__c 
                                        where Level_7_Assigned_Users__c IN :set_userIds ]) {
            set_TerritoryCodes.add(sh.Level_7_Territory_Code__c);
        } 
        
        if(set_TerritoryCodes.size() > 0) {
            
            list<String> list_sql = new list<String>();
            list_sql.add(' AccountNumber ');
            list_sql.add(' Account ');
            list_sql.add(' WHERE RecordType.Name = \'Account\' '
                    + ' And SALES_TERRITORY_CDE__c in : set_TerritoryCodes ' 
                    + ' And STATDESC__c = \'Active\' ');
            
            for(Account acct : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                if(!set_acctIds.contains(acct.AccountNumber)) {
                    set_acctIds.add(acct.AccountNumber);
                }
            }

        }
        
    }
    
    /**
    * This method is used get user territory account list.
    *
    @author Lei Tang
    @created 2014-11-10
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-11-10 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public static void setTerritoryAccountSetByUserId(set<String> set_acctIds, String userId) {
        
        set<String> set_TerritoryCodes = new set<String>();
        
        String likeuserid = '%' + Convert15CharTo18CharId(userId) + '%';
        for(Sales_Hierarchy__c sh : [select Level_7_Territory_Code__c 
                                        from Sales_Hierarchy__c 
                                        where Level_7_Assigned_Users__c like :likeuserid ]) {
            set_TerritoryCodes.add(sh.Level_7_Territory_Code__c);
        } 
        
        if(set_TerritoryCodes.size() > 0) {
            
            list<String> list_sql = new list<String>();
            list_sql.add(' AccountNumber soldtonumber ');
            list_sql.add(' Account ');
            list_sql.add(' WHERE RecordType.Name = \'Account\' '
                    + ' And SALES_TERRITORY_CDE__c in : set_TerritoryCodes ' 
                    + ' And STATDESC__c = \'Active\' '
                    + ' Group by AccountNumber ');
            
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                set_acctIds.add((String)result.get('soldtonumber'));
            }
        }
        
    }
    
    
    /**
    * This method is used get user territory account list.
    *
    @author Lei Tang
    @created 2014-11-10
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-11-10 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public static String getTerritoryCodeByUserId(String userId) {
        
        //set<String> set_TerritoryCodes = new set<String>();
        
        String likeuserid = '%' + userId + '%';
        for(Sales_Hierarchy__c sh : [select Level_7_Territory_Code__c 
                                        from Sales_Hierarchy__c 
                                        where Level_7_Assigned_Users__c like :likeuserid  order by LastModifiedDate desc limit 1]) {
            return sh.Level_7_Territory_Code__c;
            //set_TerritoryCodes.add(sh.Level_7_Territory_Code__c);
        }
        return '';
    }
    
    
    /**
    * This method is used get Subordinate user list.
    *
    @author Lei Tang
    @created 2014-11-10
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-11-10 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public static void setSubordinateUser(String userId, list<CSD_ClsEntityType.UserObj> list_users) {
        
        set<String> set_Users = new set<String>();
        //set<String> set_Codes = new set<String>();
        String likeuserid = '%' + userId + '%';
        
        for(Sales_Hierarchy__c sh : [select Level_7_Assigned_Users__c, Level_6_Assigned_Users__c, Level_5_Assigned_Users__c,
                                    Level_4_Assigned_Users__c, Level_3_Assigned_Users__c, Level_2_Assigned_Users__c, Level_1_Assigned_Users__c
                                    //Level_7_Territory_Code__c, Level_6_Territory_Code__c, Level_5_Territory_Code__c,
                                    //Level_4_Territory_Code__c, Level_3_Territory_Code__c, Level_2_Territory_Code__c, Level_1_Territory_Code__c 
                                        from Sales_Hierarchy__c 
                                        where Level_7_Assigned_Users__c like :likeuserid or Level_6_Assigned_Users__c like :likeuserid
                                            or Level_5_Assigned_Users__c like :likeuserid or Level_4_Assigned_Users__c like :likeuserid
                                            or Level_3_Assigned_Users__c like :likeuserid or Level_2_Assigned_Users__c like :likeuserid
                                            or Level_1_Assigned_Users__c like :likeuserid ]) {

            if(sh.Level_1_Assigned_Users__c != null && sh.Level_1_Assigned_Users__c.contains(userId) && sh.Level_2_Assigned_Users__c != null){
                list<String> users = sh.Level_2_Assigned_Users__c.split(';');
                for(String tempid : users){
                    if(!set_Users.contains(tempid) && tempid != userId){
                        set_Users.add(tempid);
                    }
                }
            }                               
            
            if(sh.Level_2_Assigned_Users__c != null && sh.Level_2_Assigned_Users__c.contains(userId) && sh.Level_3_Assigned_Users__c != null){
                list<String> users = sh.Level_3_Assigned_Users__c.split(';');
                for(String tempid : users){
                    if(!set_Users.contains(tempid) && tempid != userId){
                        set_Users.add(tempid);
                    }
                }
            }
            
            if(sh.Level_3_Assigned_Users__c != null && sh.Level_3_Assigned_Users__c.contains(userId) && sh.Level_4_Assigned_Users__c != null){
                list<String> users = sh.Level_4_Assigned_Users__c.split(';');
                for(String tempid : users){
                    if(!set_Users.contains(tempid) && tempid != userId){
                        set_Users.add(tempid);
                    }
                }
            }
            
            if(sh.Level_4_Assigned_Users__c != null && sh.Level_4_Assigned_Users__c.contains(userId) && sh.Level_5_Assigned_Users__c != null){
                list<String> users = sh.Level_5_Assigned_Users__c.split(';');
                for(String tempid : users){
                    if(!set_Users.contains(tempid) && tempid != userId){
                        set_Users.add(tempid);
                    }
                }
            }
            
            if(sh.Level_5_Assigned_Users__c != null && sh.Level_5_Assigned_Users__c.contains(userId) && sh.Level_6_Assigned_Users__c != null){
                list<String> users = sh.Level_6_Assigned_Users__c.split(';');
                for(String tempid : users){
                    if(!set_Users.contains(tempid) && tempid != userId){
                        set_Users.add(tempid);
                    }
                }
            }
            
            if(sh.Level_6_Assigned_Users__c != null && sh.Level_6_Assigned_Users__c.contains(userId) && sh.Level_7_Assigned_Users__c != null){
                list<String> users = sh.Level_7_Assigned_Users__c.split(';');
                for(String tempid : users){
                    if(!set_Users.contains(tempid) && tempid != userId){
                        set_Users.add(tempid);
                    }
                }
            }
        } 
        if(set_Users.size() > 0) {
            list<User> list_user = new list<User>();
            set<String> set_useremail = new set<String>();

            for(User user : [select Id, Name, SmallPhotoUrl ,Email
                                from User where Id IN :set_Users ]) {
                list_user.add(user);
                if(!set_useremail.contains(user.Email)) {
                    set_useremail.add(user.Email);
                }
            }
            set<String> set_samsunguseremail = new set<String>();
            for(CSD_Samsung_Mapping__c sm : [select Sales_Email__c
                                        from CSD_Samsung_Mapping__c 
                                        where Sales_Email__c IN :set_useremail ]) {
                set_samsunguseremail.add(sm.Sales_Email__c);
            }

            
            for(User user : list_user) {
                CSD_ClsEntityType.UserObj userobj = new CSD_ClsEntityType.UserObj();
                userobj.key = userobj.id = user.Id;
                userobj.title = userobj.name = user.name;
                userobj.photoUrl = user.SmallPhotoUrl;
                userobj.lazy = true;
                userobj.isSamsung = (set_samsunguseremail.contains(user.Email) ? true : false);
                list_users.add(userobj);

            }
        }
        
    }
    
    public static void setSubordinateUserForMultilevelHead(String userId, list<CSD_ClsEntityType.UserObj> list_users) {
        
        set<String> set_Users = new set<String>();
        set_Users.add(userId);
        
        set_Users.addAll(CSD_ClsUtils.setSubordinateUserForMultilevel(set_Users));
        
        if(set_Users.size() > 0) {
            for(User user : [select Id, Name, SmallPhotoUrl 
                                from User where Id IN :set_Users ]) {
                CSD_ClsEntityType.UserObj userobj = new CSD_ClsEntityType.UserObj();
                userobj.key = userobj.id = user.Id;
                userobj.title = userobj.name = user.name;
                userobj.photoUrl = user.SmallPhotoUrl;
                userobj.lazy = true;
                list_users.add(userobj);

            }
        }
        
    }
    
    
    /**
    * This method is used get Subordinate user list.
    *
    @author Lei Tang
    @created 2014-11-10
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-11-10 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public static set<String> setSubordinateUserForMultilevel(set<String> set_userIds) {
        
        set<String> set_Users = new set<String>();
        list<Sales_Hierarchy__c> list_sh = new list<Sales_Hierarchy__c>();
        for(Sales_Hierarchy__c sh : [select Level_7_Assigned_Users__c, Level_6_Assigned_Users__c, Level_5_Assigned_Users__c,
                                    Level_4_Assigned_Users__c, Level_3_Assigned_Users__c, Level_2_Assigned_Users__c, Level_1_Assigned_Users__c
                                        from Sales_Hierarchy__c 
                                        where Level_7_Assigned_Users__c IN :set_userIds or Level_6_Assigned_Users__c IN :set_userIds
                                            or Level_5_Assigned_Users__c IN :set_userIds or Level_4_Assigned_Users__c IN :set_userIds
                                            or Level_3_Assigned_Users__c IN :set_userIds or Level_2_Assigned_Users__c IN :set_userIds
                                            or Level_1_Assigned_Users__c IN :set_userIds ]) {
            list_sh.add(sh);
        }
        for(String userId : set_userIds) {
            
            set<String> set_SubUsers = new set<String>();
            
            for(Sales_Hierarchy__c sh :list_sh) {
                if(sh.Level_1_Assigned_Users__c != null && sh.Level_1_Assigned_Users__c.contains(userId) && sh.Level_2_Assigned_Users__c != null){
                    list<String> users = sh.Level_2_Assigned_Users__c.split(';');
                    for(String tempid : users){
                        if(!set_SubUsers.contains(tempid) && tempid != userId){
                            set_SubUsers.add(tempid);
                        }
                    }
                }                               
                
                if(sh.Level_2_Assigned_Users__c != null && sh.Level_2_Assigned_Users__c.contains(userId) && sh.Level_3_Assigned_Users__c != null){
                    list<String> users = sh.Level_3_Assigned_Users__c.split(';');
                    for(String tempid : users){
                        if(!set_SubUsers.contains(tempid) && tempid != userId){
                            set_SubUsers.add(tempid);
                        }
                    }
                }
                
                if(sh.Level_3_Assigned_Users__c != null && sh.Level_3_Assigned_Users__c.contains(userId) && sh.Level_4_Assigned_Users__c != null){
                    list<String> users = sh.Level_4_Assigned_Users__c.split(';');
                    for(String tempid : users){
                        if(!set_SubUsers.contains(tempid) && tempid != userId){
                            set_SubUsers.add(tempid);
                        }
                    }
                }
                
                if(sh.Level_4_Assigned_Users__c != null && sh.Level_4_Assigned_Users__c.contains(userId) && sh.Level_5_Assigned_Users__c != null){
                    list<String> users = sh.Level_5_Assigned_Users__c.split(';');
                    for(String tempid : users){
                        if(!set_SubUsers.contains(tempid) && tempid != userId){
                            set_SubUsers.add(tempid);
                        }
                    }
                }
                
                if(sh.Level_5_Assigned_Users__c != null && sh.Level_5_Assigned_Users__c.contains(userId) && sh.Level_6_Assigned_Users__c != null){
                    list<String> users = sh.Level_6_Assigned_Users__c.split(';');
                    for(String tempid : users){
                        if(!set_SubUsers.contains(tempid) && tempid != userId){
                            set_SubUsers.add(tempid);
                        }
                    }
                }
                
                if(sh.Level_6_Assigned_Users__c != null && sh.Level_6_Assigned_Users__c.contains(userId) && sh.Level_7_Assigned_Users__c != null){
                    list<String> users = sh.Level_7_Assigned_Users__c.split(';');
                    for(String tempid : users){
                        if(!set_SubUsers.contains(tempid) && tempid != userId){
                            set_SubUsers.add(tempid);
                        }
                    }
                }
            }
            
            if(set_SubUsers.size() > 0) {
                set_Users.addAll(set_SubUsers);
                set_Users.addAll(CSD_ClsUtils.setSubordinateUserForMultilevel(set_SubUsers));
            }

        }
        
        return set_Users;
        
    }
    
    /**
    * This method is used get current fiscal date.
    *
    @author Lei Tang
    @created 2014-11-10
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-11-10 Lei Tang <lei.tang@itbconsult.com>
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
    * This method is used get current fiscal date.
    *
    @author Lei Tang
    @created 2014-11-10
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-11-10 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    *
    @changelog
    * 2016-10-13 Mingxing Qiu<Mingxing.Qiu@oinio.com>
    * - Created
    */
    public static void setFiscalDateRangeNew(Date currentDate, Date startDate, Date endDate) {
        String monthlabel = MAP_NUMBERMONTHLABEL.get(currentDate.month());
        system.debug('!@# monthlabel:'+monthlabel);
        for (Period period : [select Id, PeriodLabel, StartDate, EndDate
                                from Period where FiscalYearSettings.Name = :String.valueOf(currentDate.year()) 
                                and Type = 'Month' and PeriodLabel = :monthlabel]) {
            
            startDate = period.StartDate;
            endDate = period.EndDate;
            system.debug('!@# startDate:'+period.StartDate);
            system.debug('!@# endDate:'+period.EndDate);
        }
 
    }
    
    /**
    * This method is used set map of Account ref data.
    *
    @author Lei Tang
    @created 2014-11-10
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-11-10 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public static void setRegionMapRefData(String regionId, set<String> years, set<Integer> months, set<String> set_soldtoIds, list<String> list_sql, map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result) {
        system.debug('@#readly : '+set_soldtoIds);
        system.debug('@#sql : ' + CSD_ClsUtils.getQueryString(list_sql));
        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
            
            //String accId = (String)result.get('refId');
            Date refdate = (Date)result.get('refdate');
            String year = String.valueOf(refdate.year());
            String month = String.valueOf(refdate.month());
            String dateKey = (year + '_' + month);
            CSD_ClsUtils.setResultMap(result, regionId, dateKey, map_acctId_map_dateKey_result);       
            
        }    
    }
    
    /**
    * This method is used set map of Account ref data.
    *
    @author Mingxing Qiu
    @created 2016-04-07
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2016-04-07 Mingxing Qiu <Mingxing.Qiu@itbconsult.com>
    * - Created
    
    @changelog
    * 2016-10-13 Mingxing Qiu <Mingxing.Qiu@oinio.com>
    * - Created
    */
    public static void setRegionMapRefDataBacklog(String regionId,Date refdate, Date startDate,Date endDate, set<String> set_soldtoIds, list<String> list_sql, map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result) {   
       
        system.debug('@#sql : ' + CSD_ClsUtils.getQueryString(list_sql));
        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
            
            //String accId = (String)result.get('refId');
            //Date refdate = (Date)result.get('refdate');
            String year = String.valueOf(refdate.year());
            String month = String.valueOf(refdate.month());
            String dateKey = (year + '_' + month);
            CSD_ClsUtils.setResultMap(result, regionId, dateKey, map_acctId_map_dateKey_result);       
            
        }    
    }
    
    
    /**
    * This method is used set map of Account ref data.
    *
    @author Lei Tang
    @created 2014-11-10
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-11-10 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public static void setSoldToMapRefData(set<String> years, set<Integer> months, list<Date> listdate, list<String> list_sql, map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result) {
            
        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
            //system.debug('@#result : '+result);
            String accId = (String)result.get('refId');
            Date refdate = (Date)result.get('refdate');
            String year = String.valueOf(refdate.year());
            String month = String.valueOf(refdate.month());
            String dateKey = (year + '_' + month);
            CSD_ClsUtils.setResultMap(result, accId, dateKey, map_acctId_map_dateKey_result);       
            
        }    
    }
    
    
    /**
    * This method is used set map of Account ref data.
    *
    @author Lei Tang
    @created 2016-04-06
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2016-04-06 Lei Tang <lei.tang@oinio.com>
    * - Created
    
    @changelog
    * 2016-10-13 Mingxing Qiu <Mingxing.Qiu@oinio.com>
    * - Created
    */
    public static void setSoldToMapRefDataBacklog(Date refdate, Date startDate, Date endDate, list<String> list_sql, map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result) {
            
        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
            //system.debug('@#result : '+result);
            String accId = (String)result.get('refId');
            //Date refdate = (Date)result.get('refdate');
            String year = String.valueOf(refdate.year());
            String month = String.valueOf(refdate.month());
            String dateKey = (year + '_' + month);
            CSD_ClsUtils.setResultMap(result, accId, dateKey, map_acctId_map_dateKey_result);       
            
        }    
    }
    
    /**
    * This method is used set map of totle billing data.
    *
    @author Lei Tang
    @created 2014-11-10
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-11-10 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    
    @changelog
    * 2016-10-13 Mingxing Qiu <Mingxing.Qiu@oinio.com>
    * - Created
    */
    public static void setTotelBillingData(set<String> years, set<Integer> months, Object set_perm, list<String> list_sql, map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result) {
            
        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
            //system.debug('@#result : '+result);
            String accId = 'Total';
            Date refdate = (Date)result.get('refdate');
            String year = String.valueOf(refdate.year());
            String month = String.valueOf(refdate.month());
            String dateKey = (year + '_' + month);
            CSD_ClsUtils.setResultMap(result, accId, dateKey, map_acctId_map_dateKey_result);       
            
        }    
    }
    
    
        /**
    * This method is used set map of totle billing data.
    *
    @author Lei Tang
    @created 2014-11-10
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-11-10 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public static void setTotelBillingDataBacklog(Date refdate, Date startDate, Date endDate, Object set_perm, list<String> list_sql, map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result) {
            
        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
            //system.debug('@#result : '+result);
            String accId = 'Total';
            //Date refdate = (Date)result.get('refdate');
            String year = String.valueOf(refdate.year());
            String month = String.valueOf(refdate.month());
            String dateKey = (year + '_' + month);
            CSD_ClsUtils.setResultMap(result, accId, dateKey, map_acctId_map_dateKey_result);       
            
        }    
    }
    
    /**
    * This method is used set map OEM and Part ref data.
    *
    @author Lei Tang
    @created 2014-11-10
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    * 
    *
    @changelog
    * 2014-11-10 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public static void setOEMPartMapRefData(set<String> set_monthids, list<String> list_sql, map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result) {
            
        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
            //system.debug('@#result : '+result);
            String accId = (String)result.get('refId');
            Date refdate = (Date)result.get('refdate');
            String year = String.valueOf(refdate.year());
            String month = String.valueOf(refdate.month());
            String dateKey = (year + '_' + month);
            CSD_ClsUtils.setResultMap(result, accId, dateKey, map_acctId_map_dateKey_result);       
            
        }    
    }
    
    /**
    * This method is used set map OEM and Part ref data.
    *
    @author Lei Tang
    @created 2014-11-10
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    * 
    *
    @changelog
    * 2014-11-10 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    
    @changelog
    * 2016-10-13 Mingxing Qiu <Mingxing.Qiu@oinio.com>
    * - Created
    */ 
    public static void setOEMPartMapRefDataBacklog(Date refdate, set<String> set_monthids, list<String> list_sql, map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result) {
            
        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
            //system.debug('@#result : '+result);
            String accId = (String)result.get('refId');
            //Date refdate = (Date)result.get('refdate');
            String year = String.valueOf(refdate.year());
            String month = String.valueOf(refdate.month());
            String dateKey = (year + '_' + month);
            CSD_ClsUtils.setResultMap(result, accId, dateKey, map_acctId_map_dateKey_result);       
            
        }    
    }
    
    
    /**
    * This method is used set map OEM and Part ref data.
    *
    @author Lei Tang
    @created 2014-11-10
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    * 
    *
    @changelog
    * 2014-11-10 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public static void setGAMOEMMapRefData(String oemId, set<String> set_monthids, list<String> list_sql, map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result) {
            
        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
            //system.debug('@#result : '+result);
            Date refdate = (Date)result.get('refdate');
            String year = String.valueOf(refdate.year());
            String month = String.valueOf(refdate.month());
            String dateKey = (year + '_' + month);
            system.debug('@#result:'+result);
            system.debug('@#dateKey:'+dateKey);
            CSD_ClsUtils.setResultMap(result, oemId, dateKey, map_acctId_map_dateKey_result);       
            
        }    
    }
    
    /**
    * This method is used set map OEM and Part ref data.
    *
    @author Mingxing Qiu
    @created 2016-04-08
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    * 
    *
    @changelog
    * 2016-10-13 Mingxing Qiu <Mingxing.Qiu@oinio.com>
    * - Created
    */
    public static void setGAMOEMMapRefDataBacklog(Date refdate, String oemId, set<String> set_monthids, list<String> list_sql, map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result) {
            
        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
            //system.debug('@#result : '+result);
            //Date refdate = (Date)result.get('refdate');
            String year = String.valueOf(refdate.year());
            String month = String.valueOf(refdate.month());
            String dateKey = (year + '_' + month);
            system.debug('@#result:'+result);
            system.debug('@#dateKey:'+dateKey);
            CSD_ClsUtils.setResultMap(result, oemId, dateKey, map_acctId_map_dateKey_result);       
            
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
            Date curretdate, CSD_ClsEntityType.CSDRefObj refdata,
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

    
    public static void setRefDateObject(list<Date> list_beforedate, list<Date> list_futruedate, CSD_ClsEntityType.CSDRefObj refdata,
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
    
    
     public static void setRefDateObjectBacklog(list<Date> list_beforedate, list<Date> list_futruedate, CSD_ClsEntityType.CSDRefObj refdata,
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
                if(refdata.map_backlogrefdata.get(dateKey) == null) {
                    refdata.map_backlogrefdata.put(dateKey, 0);  
                }
                if(result != null) {
                    //refdata.name = (String)result.get('name');
                    refdata.map_backlogrefdata.put(dateKey, (result.get('amount') != null ? refdata.map_backlogrefdata.get(dateKey) + (decimal)result.get('amount') : refdata.map_backlogrefdata.get(dateKey)));  
                }
            }
        }
        
        
    }
    
    public static void createAccountObj(CSD_ClsEntityType.AccountObj acctFC, map<String, set<Integer>> map_year_monthsFuture){
        
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
    
    public static void createOEMAccountObj(CSD_ClsEntityType.OEMAccountObj acctFC, map<String, set<Integer>> map_year_monthsFuture){
        
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
    
    public static void createAccountObjForComprison(CSD_ClsEntityType.AccountObjForComparison acctFC, map<String, String> map_quarter_months){
        
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
    
    
    
    public static void createPartObj(CSD_ClsEntityType.PartObj acctFC, map<String, set<Integer>> map_year_monthsFuture){
        
        acctFC.csFC = new map<String, CSD_ClsEntityType.AccountValueobj>();
        acctFC.dcFC = new map<String, decimal>();
        acctFC.pmFC = new map<String, decimal>();
        //map_acctId_acctFC.put(map_soldto_region.get(acctId), acctFC);

        for(String year : map_year_monthsFuture.keySet()) {
            for(Integer month : map_year_monthsFuture.get(year)) {
                String dateKey = (year + '_' + String.valueOf(month));
                CSD_ClsEntityType.AccountValueobj valueobj = new CSD_ClsEntityType.AccountValueobj();
                valueobj.forecast = 0;
                valueobj.price = 0;
                valueobj.quantity = 0;
                acctFC.csFC.put(dateKey, valueobj);
                acctFC.dcFC.put(dateKey, 0);
                acctFC.pmFC.put(dateKey, 0);
                
            }
        }
    }
    
    public static CSD_ClsEntityType.CSDRefObj createRefDataObj() {
        CSD_ClsEntityType.CSDRefObj refdata = new CSD_ClsEntityType.CSDRefObj();
        refdata.map_backlogrefdata = new map<String, decimal>();
        refdata.map_billingrefdata = new map<String, decimal>();
        refdata.map_bookingrefdata = new map<String, decimal>();
        refdata.map_statisticalrefdata = new map<String, decimal>();
        
        return refdata;
    }
    
    public static void getSamsungGPLFamilyByUser(String userId, String gplFamily, String gplCode, set<String> set_GPLFamilys,
                                set<String> set_GPLCodes, set<String> set_SoldTos, set<String> set_Parts) {
        String useremail = '%null%';
        String strgplfamily = '%' + gplFamily  + '%';
        String strgplcode = '%' + gplCode  + '%';
        
        for(User user : [select Email from User where Id = :userId]) {
            useremail = '%' + user.Email + '%';
        }

        for(CSD_Samsung_Mapping__c sm : [select GPL_Family__c, GPL_Code__c, Category__c, Part__c 
                                        from CSD_Samsung_Mapping__c 
                                        where Sales_Email__c like :useremail 
                                            AND GPL_Family__c like :strgplfamily 
                                            AND GPL_Code__c like :strgplcode ]) {
            if(!set_GPLFamilys.contains(sm.GPL_Family__c)) {
                set_GPLFamilys.add(sm.GPL_Family__c);
            }
            if(!set_GPLCodes.contains(sm.GPL_Code__c)) {
                set_GPLCodes.add(sm.GPL_Code__c);
            }
            if(!set_SoldTos.contains(sm.Category__c)) {
                set_SoldTos.add(sm.Category__c);
            }
            if(!set_Parts.contains(sm.Part__c)) {
                set_Parts.add(sm.Part__c);
            }
        }
    }
    
    
    public static void getSamsungGPLFamilyByManage(String gplFamily, String gplCode, set<String> set_GPLFamilys,
                                set<String> set_GPLCodes, set<String> set_SoldTos, set<String> set_Parts) {
        
        String strgplfamily = '%' + gplFamily  + '%';
        String strgplcode = '%' + gplCode  + '%';

        for(CSD_Samsung_Mapping__c sm : [select GPL_Family__c, GPL_Code__c, Category__c, Part__c 
                                        from CSD_Samsung_Mapping__c 
                                        where GPL_Family__c like :strgplfamily 
                                            AND GPL_Code__c like :strgplcode ]) {
            if(!set_GPLFamilys.contains(sm.GPL_Family__c)) {
                set_GPLFamilys.add(sm.GPL_Family__c);
            }
            if(!set_GPLCodes.contains(sm.GPL_Code__c)) {
                set_GPLCodes.add(sm.GPL_Code__c);
            }
            if(!set_SoldTos.contains(sm.Category__c)) {
                set_SoldTos.add(sm.Category__c);
            }
            if(!set_Parts.contains(sm.Part__c)) {
                set_Parts.add(sm.Part__c);
            }
        }
    }
    
    
    public static String copyCFTForecast(String sData) {
        
        CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData, CSD_ClsEntityType.SearchObj.class);
        system.debug('@#searchOb:'+searchOb);
        Date currentdate = Date.valueOf(searchOb.startDate);
        Date enddate = Date.valueOf(searchOb.endDate);
        
        
        map<String, CSD_ClsEntityType.CFTDataObj> map_date_cft = new map<String, CSD_ClsEntityType.CFTDataObj>();
        
        for(String year : searchOb.map_year_monthsFuture.keySet()) {
            for(Integer month : searchOb.map_year_monthsFuture.get(year)) {
                CSD_ClsEntityType.CFTDataObj cftdata = new CSD_ClsEntityType.CFTDataObj();
                cftdata.quantity = 0;
                cftdata.dateKey = (year + '_' + String.valueOf(month));
                system.debug('asdfcftdata.dateKey'+cftdata.dateKey);
                cftdata.hasvalue = false;
                map_date_cft.put(cftdata.dateKey, cftdata);
            }
        }
        system.debug('asdf'+searchOb.accnumber);
        system.debug('asdf'+searchOb.oemId);
        system.debug('asdf'+searchOb.partId);
        system.debug('asdf'+currentdate);
        system.debug('asdf'+enddate);
        system.debug('asdf'+[select Id, Part__c, Quantity__c, Fiscal_Year__c, Fiscal_Month__c
                                        from CSD_CFT_Forecast__c
                                        where Sold_To_Number__c = :searchOb.accnumber and OEM__c = :searchOb.oemId
                                            and Part__c = :searchOb.partId 
                                            And Fiscal_Date__c >= : currentdate
                                            And Fiscal_Date__c < : enddate ].size());
        for(CSD_CFT_Forecast__c cft : [select Id, Part__c, Quantity__c, Fiscal_Year__c, Fiscal_Month__c
                                        from CSD_CFT_Forecast__c
                                        where Sold_To_Number__c = :searchOb.accnumber and OEM__c = :searchOb.oemId
                                            and Part__c = :searchOb.partId 
                                            And Fiscal_Date__c >= : currentdate
                                            And Fiscal_Date__c < : enddate ]) {
            String  year = cft.Fiscal_Year__c,
                       month = cft.Fiscal_Month__c, 
                       dateKey = (year + '_' + month);
            
            if(map_date_cft.containsKey(dateKey)) {
                map_date_cft.get(dateKey).quantity = cft.Quantity__c;
                map_date_cft.get(dateKey).hasvalue = true;
                system.debug('asdfdateKey'+dateKey);
            }
            
        }
        
        //list<CSD_ClsEntityType.CFTDataObj> list_cft = new list<CSD_ClsEntityType.CFTDataObj>();
        //list_cft.addAll(map_date_cft.values());
        
        //system.debug('@#list_cft:'+list_cft);
        
        return Json.serialize(map_date_cft);
    }
    
    /**
     * This method is used to judge Part has CFT forecast value.
     *  
     * @author Lei Tang
     * @created 2014-10-29
     * @version 1.0
     * @since 30.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2014-10-29 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public static void hasCFTForecast(String soldtoId, String oemId, set<String> partIds, Date currentdate, Date enddate
                                        , set<String> set_hascftpartid) {
        
        list<String> list_sql = new list<String>();
        list_sql.add(' Part__c part ');
        list_sql.add(' CSD_CFT_Forecast__c ');
        list_sql.add(' where Sold_To_Number__c = :soldtoId and OEM__c = :oemId '
                    + ' And Part__c IN :partIds  ' 
                    + ' And Quantity__c > 0 ' 
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Part__c ');
        
        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
            set_hascftpartid.add((String)result.get('part'));
        }   
    }
    
    /**
     * This method is used to judge SoldTo has CFT forecast value for Samsung.
     *  
     * @author Lei Tang
     * @created 2014-10-29
     * @version 1.0
     * @since 30.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2014-10-29 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public static void hasCFTForecastForSamsung(String oemId, String partId, set<String> soldtoIds, Date currentdate, Date enddate
                                        , set<String> set_hascftpartid) {
        
        list<String> list_sql = new list<String>();
        list_sql.add(' Sold_To_Number__c number ');
        list_sql.add(' CSD_CFT_Forecast__c ');
        list_sql.add(' where Sold_To_Number__c IN :soldtoIds and OEM__c = :oemId '
                    + ' And Part__c = :partId  ' 
                    + ' And Quantity__c != 0 ' 
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Sold_To_Number__c ');
        
        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
            set_hascftpartid.add((String)result.get('number'));
        }   
    }
    
    /**
     * This method is used to get sales forecast region value.
     *  
     * @author Lei Tang
     * @created 2014-10-29
     * @version 1.0
     * @since 30.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2014-10-29 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public static map<String, String> getPartRegion(String accnumber, String oemId, set<String> partIds) {
        map<String, String> map_part_region = new map<String, String>();
        
        Account soldto = null;
        if(accnumber != '') {
            for(Account acc : [select Id, AccountNumber, Name, DD1_SALES_OFFICE_CDE__c, Company_Reporting_Org__c
                        , DD3_SALES_OFFICE_CDE__c, Account_Number_Short__c, SAP_Account_Number__c, WWCORPACCT__c
                      from Account where AccountNumber = :accnumber and STATDESC__c = 'Active' limit 1]) {
                soldto = acc;
            }
        }
        
        Account oem = null;
        if(oemId != '') {
            for(Account acc : [select Id, Name, Account_Number_Short__c
                      from Account where Id = :oemId]) {
                oem = acc;
            }
        }
        
        if(soldto == null || oem == null){ 
            return map_part_region;
        }
        Boolean hasregion = false;
        String regionname = '';
        if(SET_INDIAORGID.contains(soldto.Company_Reporting_Org__c)) {
            regionname = 'ASIA';
            hasregion = true;
        }else if(soldto.DD1_SALES_OFFICE_CDE__c != null && (soldto.DD1_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('AMERICAS')
            || soldto.DD1_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('EMEA'))) {
            regionname = CSD_ClsUtils.MAP_REGIONCODE_REGIONNAME.get(soldto.DD1_SALES_OFFICE_CDE__c);
            hasregion = true;
        }else if(soldto.DD1_SALES_OFFICE_CDE__c != null && (soldto.DD1_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('ASIA PACIFIC'))) {
            regionname = 'ASIA';
            hasregion = true;
        }else if(soldto.DD1_SALES_OFFICE_CDE__c != null) {
            if(CSD_ClsUtils.MAP_REGIONCODE_REGIONNAME.containsKey(soldto.DD1_SALES_OFFICE_CDE__c)){
                regionname = CSD_ClsUtils.MAP_REGIONCODE_REGIONNAME.get(soldto.DD1_SALES_OFFICE_CDE__c);
                hasregion = true;
            }
        }   
        /*else if(soldto.DD3_SALES_OFFICE_CDE__c != null && (soldto.DD3_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('JAPAN') 
            || soldto.DD3_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('KOREA'))) {
            regionname = CSD_ClsUtils.MAP_REGIONCODE_REGIONNAME.get(soldto.DD3_SALES_OFFICE_CDE__c);
            hasregion = true;
        }/*else if((soldto.WWCORPACCT__c != null && soldto.WWCORPACCT__c == '00038464') 
            || (CSD_ClsUtils.SET_CHINAMOBILEOEMNAME.contains(oem.Name))) {
            regionname = 'CHINA MOBILE';
            hasregion = true;
        }*/
        
        for(String partid : partIds) {
            String regiontemp = regionname;
            map_part_region.put(partid.substring(0,15), regiontemp);
        }
        
        /*
        if(soldto.DD1_SALES_OFFICE_CDE__c != null && soldto.DD1_SALES_OFFICE_CDE__c != CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('AMERICA')
            && soldto.DD1_SALES_OFFICE_CDE__c != CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('EMEA') 
            && soldto.DD1_SALES_OFFICE_CDE__c != CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('ASIA PACIFIC')) {
            regionname = 'OTHERS';
            hasregion = true;
        }else if(soldto.DD1_SALES_OFFICE_CDE__c != null && (soldto.DD1_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('AMERICA') 
            || soldto.DD1_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('EMEA'))) {
            regionname = CSD_ClsUtils.MAP_REGIONCODE_REGIONNAME.get(soldto.DD1_SALES_OFFICE_CDE__c);
            hasregion = true;
        }else if(soldto.DD2_SALES_OFFICE_CDE__c != null && (soldto.DD2_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('KOREA') 
                || soldto.DD2_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('JAPAN') 
                || soldto.DD2_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('SOUTH ASIA PACIFIC'))) {
            regionname = CSD_ClsUtils.MAP_REGIONCODE_REGIONNAME.get(soldto.DD2_SALES_OFFICE_CDE__c);
            hasregion = true;
        }else if(soldto.Account_Number_Short__c != null && (soldto.Account_Number_Short__c == '01379274' 
                || soldto.Account_Number_Short__c == '02844953' || soldto.Account_Number_Short__c == '02987544')) {
            regionname = 'CHINA';
            hasregion = true;
        }else if(oem != null && (oem.Name == 'GIANTS' || oem.Name == 'MARINERS')) {
            regionname = 'CHINA';
            hasregion = true;
        }else if(soldto.DD3_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('TAIWAN')) {
            regionname = 'TAIWAN';
            hasregion = true;
        }
        
        for(String partid : partIds) {
            String regiontemp = regionname;
            if(!hasregion && map_part_sap.containsKey(partid) && map_part_sap.get(partid) == '0000000259') {
                regiontemp = 'TAIWAN';
            }else if(!hasregion && soldto.WWCORPACCT__c != null && (soldto.WWCORPACCT__c == '00033915' ||soldto.WWCORPACCT__c == '00001242')) {
                regiontemp = 'TAIWAN';
            }
            map_part_region.put(partid.substring(0,15), regiontemp);
        }
        system.debug('@#map_part_sap:'+map_part_sap);*/
        return map_part_region;
        
    }
    
    /**
     * This method is used to get sales forecast region value.
     *  
     * @author Lei Tang
     * @created 2014-10-29
     * @version 1.0
     * @since 30.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2014-10-29 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public static map<String, String> getOEMRegion(String accnumber, set<String> oemIds) {
        map<String, String> map_oem_region = new map<String, String>();
        
        Account soldto = null;
        if(accnumber != '') {
            for(Account acc : [select Id, AccountNumber, Name, DD1_SALES_OFFICE_CDE__c, Company_Reporting_Org__c
                        , DD3_SALES_OFFICE_CDE__c, Account_Number_Short__c, SAP_Account_Number__c, WWCORPACCT__c
                      from Account where AccountNumber = :accnumber and STATDESC__c = 'Active' limit 1]) {
                soldto = acc;
            }
        }
        
        if(soldto == null){ 
            return map_oem_region;
        }
        Boolean hasregion = false;
        String regionname = '';
        if(SET_INDIAORGID.contains(soldto.Company_Reporting_Org__c)) {
            regionname = 'ASIA';
            hasregion = true;
        }else if(soldto.DD1_SALES_OFFICE_CDE__c != null && (soldto.DD1_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('AMERICAS')
            || soldto.DD1_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('EMEA'))) {
            regionname = CSD_ClsUtils.MAP_REGIONCODE_REGIONNAME.get(soldto.DD1_SALES_OFFICE_CDE__c);
            hasregion = true;
        }else if(soldto.DD1_SALES_OFFICE_CDE__c != null && (soldto.DD1_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('ASIA PACIFIC'))) {
            regionname = 'ASIA';
            hasregion = true;
        }else if(soldto.DD1_SALES_OFFICE_CDE__c != null) {
            if(CSD_ClsUtils.MAP_REGIONCODE_REGIONNAME.containsKey(soldto.DD1_SALES_OFFICE_CDE__c)){
                regionname = CSD_ClsUtils.MAP_REGIONCODE_REGIONNAME.get(soldto.DD1_SALES_OFFICE_CDE__c);
               	hasregion = true;
            }           
        }  
        /*else if(soldto.DD3_SALES_OFFICE_CDE__c != null && (soldto.DD3_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('JAPAN') 
            || soldto.DD3_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('KOREA'))) {
            regionname = CSD_ClsUtils.MAP_REGIONCODE_REGIONNAME.get(soldto.DD3_SALES_OFFICE_CDE__c);
            hasregion = true;
        }/*else if(soldto.WWCORPACCT__c != null && soldto.WWCORPACCT__c == '00038464') {
            regionname = 'CHINA MOBILE';
            hasregion = true;
        }*/
        
        if(oemIds.size() > 0) {
            for(Account acc : [select Id, Name, Account_Number_Short__c
                      from Account where Id IN :oemIds]) {
                String regiontemp = regionname;
                /*if(!hasregion && SET_CHINAMOBILEOEMNAME.contains(acc.Name)) {
                    regiontemp = 'CHINA MOBILE';
                }*/
                map_oem_region.put(String.valueOf(acc.Id).substring(0,15), regiontemp);
            }
        }

        /*
        String regionname = 'CHINA';
        if(soldto.DD1_SALES_OFFICE_CDE__c != null && soldto.DD1_SALES_OFFICE_CDE__c != CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('AMERICA')
            && soldto.DD1_SALES_OFFICE_CDE__c != CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('EMEA') 
            && soldto.DD1_SALES_OFFICE_CDE__c != CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('ASIA PACIFIC')) {
            regionname = 'OTHERS';
            hasregion = true;
        }else if(soldto.DD1_SALES_OFFICE_CDE__c != null && (soldto.DD1_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('AMERICA') 
            || soldto.DD1_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('EMEA'))) {
            regionname = CSD_ClsUtils.MAP_REGIONCODE_REGIONNAME.get(soldto.DD1_SALES_OFFICE_CDE__c);
            hasregion = true;
        }else if(soldto.DD2_SALES_OFFICE_CDE__c != null && (soldto.DD2_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('KOREA')
                || soldto.DD2_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('JAPAN') 
                || soldto.DD2_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('SOUTH ASIA PACIFIC'))) {
            regionname = CSD_ClsUtils.MAP_REGIONCODE_REGIONNAME.get(soldto.DD2_SALES_OFFICE_CDE__c);
            hasregion = true;
        }else if(soldto.Account_Number_Short__c != null && (soldto.Account_Number_Short__c == '01379274' 
                || soldto.Account_Number_Short__c == '02844953' || soldto.Account_Number_Short__c == '02987544')) {
            regionname = 'CHINA';
            hasregion = true;
        }
        
        if(oemIds.size() > 0) {
            for(Account acc : [select Id, Name, Account_Number_Short__c
                      from Account where Id IN :oemIds]) {
                String regiontemp = regionname;
                if(!hasregion && (acc.Name == 'GIANTS' || acc.Name == 'MARINERS')) {
                    regiontemp = 'CHINA';
                }else if(!hasregion && soldto.DD3_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('TAIWAN')) {
                    regiontemp = 'TAIWAN';
                }else if(!hasregion && soldto.WWCORPACCT__c != null && (soldto.WWCORPACCT__c == '00033915' ||soldto.WWCORPACCT__c == '00001242')) {
                    regiontemp = 'TAIWAN';
                }
                map_oem_region.put(String.valueOf(acc.Id).substring(0,15), regiontemp);
            }
        }
        */
        return map_oem_region;
        
    }
    
    
    /**
     * This method is used to get sales forecast region value.
     *  
     * @author Lei Tang
     * @created 2014-10-29
     * @version 1.0
     * @since 30.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2014-10-29 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */ 
    public static map<String, String> getRegionForSoldTo(set<String> soldtonumbers, String oemId, String partId) {
        map<String, String> map_accnumber_region = new map<String, String>();
        
        String oemname = '';
        if(oemId != '') {
            for(Account oem : [select Id, Name, Account_Number_Short__c
                      from Account where Id = :oemId]) {
                oemname = oem.Name;
            }
        }
        /*system.debug('@#oemname: '+oemname);
        String sap = '';
        if(partId != '') {
            
            Date fiscaldate = CSD_ClsUtils.getFiscalDate();
            Date enddate = fiscaldate.addMonths(-12);
            
            set<String> set_dailyIds = new set<String>();
            for(CSD_OEM_Mapping_Monthly_BBB__c csdmap : [select Monthly_Billings_Bookings_by_Part__c 
                                                            from CSD_OEM_Mapping_Monthly_BBB__c 
                                                            where Monthly_Billings_Bookings_by_Part__r.Fiscal_Date__c < :fiscaldate
                                                                and Monthly_Billings_Bookings_by_Part__r.Fiscal_Date__c >= :enddate
                                                                and Monthly_Billings_Bookings_by_Part__r.Customer__r.AccountNumber IN :soldtonumbers
                                                                and Monthly_Billings_Bookings_by_Part__r.Customer__r.STATDESC__c = 'Active'
                                                                and Monthly_Billings_Bookings_by_Part__r.Part__c = :partId
                                                                and OEM_Mapping__r.OEM__r.OEM__c = :oemId ]) {
                set_dailyIds.add(csdmap.Monthly_Billings_Bookings_by_Part__c);
            }
            
            list<String> list_sql = new list<String>();
            list_sql.add(' SAP_Profit_Center_Code__c sap');
            list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
            list_sql.add(' WHERE Id IN :set_dailyIds '
                + ' Group by SAP_Profit_Center_Code__c ');
 
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                //String part = (String)result.get('refId');
                String sappro = (String)result.get('sap');
                if(sap == 'Parent') {
                    break;
                }else if(sap == '') {
                    sap = sappro;
                }else if(sap != sappro) {
                    sap = 'Parent';
                }
            }    
        }
        */
        
        for(Account acc : [select Id, AccountNumber, Name, DD1_SALES_OFFICE_CDE__c, Company_Reporting_Org__c
                        , DD3_SALES_OFFICE_CDE__c, Account_Number_Short__c, SAP_Account_Number__c, WWCORPACCT__c
                      from Account where AccountNumber IN :soldtonumbers and STATDESC__c = 'Active']) {
            String regionname = '';
            if(SET_INDIAORGID.contains(acc.Company_Reporting_Org__c)) {
                regionname = 'ASIA';
            }else if(acc.DD1_SALES_OFFICE_CDE__c != null && (acc.DD1_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('AMERICAS')
                || acc.DD1_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('EMEA'))) {
                regionname = CSD_ClsUtils.MAP_REGIONCODE_REGIONNAME.get(acc.DD1_SALES_OFFICE_CDE__c);
            }else if(acc.DD1_SALES_OFFICE_CDE__c != null && (acc.DD1_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('ASIA PACIFIC'))) {
            	regionname = 'ASIA';
        	}else if(acc.DD1_SALES_OFFICE_CDE__c != null) {
            	if(CSD_ClsUtils.MAP_REGIONCODE_REGIONNAME.containsKey(acc.DD1_SALES_OFFICE_CDE__c)){
                	regionname = CSD_ClsUtils.MAP_REGIONCODE_REGIONNAME.get(acc.DD1_SALES_OFFICE_CDE__c);  
                }
        	}  
            /*else if(acc.DD3_SALES_OFFICE_CDE__c != null && (acc.DD3_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('JAPAN') 
                || acc.DD3_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('KOREA'))) {
                regionname = CSD_ClsUtils.MAP_REGIONCODE_REGIONNAME.get(acc.DD3_SALES_OFFICE_CDE__c);
            }/*else if((acc.WWCORPACCT__c != null && acc.WWCORPACCT__c == '00038464') 
                || (SET_CHINAMOBILEOEMNAME.contains(oemname))) {
                regionname = 'CHINA MOBILE';
            }*/
            /*
            String regionname = 'CHINA';
            if(acc.DD1_SALES_OFFICE_CDE__c != null && acc.DD1_SALES_OFFICE_CDE__c != CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('AMERICA')
                && acc.DD1_SALES_OFFICE_CDE__c != CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('EMEA') 
                && acc.DD1_SALES_OFFICE_CDE__c != CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('ASIA PACIFIC')) {
                regionname = 'OTHERS';
            }else if(acc.DD1_SALES_OFFICE_CDE__c != null && (acc.DD1_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('AMERICA') 
                || acc.DD1_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('EMEA'))) {
                regionname = CSD_ClsUtils.MAP_REGIONCODE_REGIONNAME.get(acc.DD1_SALES_OFFICE_CDE__c);
            }else if(acc.DD2_SALES_OFFICE_CDE__c != null && (acc.DD2_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('KOREA')
                    || acc.DD2_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('JAPAN') 
                    || acc.DD2_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('SOUTH ASIA PACIFIC'))) {
                regionname = CSD_ClsUtils.MAP_REGIONCODE_REGIONNAME.get(acc.DD2_SALES_OFFICE_CDE__c);
            }else if(acc.Account_Number_Short__c != null && (acc.Account_Number_Short__c == '01379274' 
                    || acc.Account_Number_Short__c == '02844953' || acc.Account_Number_Short__c == '02987544')) {
                regionname = 'CHINA';
            }else if(oemname == 'GIANTS' || oemname == 'MARINERS') {
                regionname = 'CHINA';
            }else if(acc.DD3_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('TAIWAN')) {
                regionname = 'TAIWAN';
            }else if(sap == '0000000259') {
                regionname = 'TAIWAN';
            }else if(acc.WWCORPACCT__c != null && (acc.WWCORPACCT__c == '00033915' ||acc.WWCORPACCT__c == '00001242')) {
                regionname = 'TAIWAN';
            }
            */
            
            map_accnumber_region.put(acc.AccountNumber, regionname);
        }
        
    
        return map_accnumber_region;
        
    }
    
    
    /**
     * This method is used to get sales forecast region value.
     *  
     * @author Lei Tang
     * @created 2014-10-29
     * @version 1.0
     * @since 30.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2014-10-29 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */ 
    public static map<String, String> getRegionForCreateSoldTo(set<String> soldtonumbers) {
        map<String, String> map_accnumber_region = new map<String, String>();

        for(Account acc : [select Id, AccountNumber, Name, DD1_SALES_OFFICE_CDE__c, Company_Reporting_Org__c
                        , DD3_SALES_OFFICE_CDE__c, Account_Number_Short__c, SAP_Account_Number__c, WWCORPACCT__c
                      from Account where AccountNumber IN :soldtonumbers and STATDESC__c = 'Active']) {
            String regionname = '';
            if(SET_INDIAORGID.contains(acc.Company_Reporting_Org__c)) {
                regionname = 'ASIA';
            }else if(acc.DD1_SALES_OFFICE_CDE__c != null && (acc.DD1_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('AMERICAS')
                || acc.DD1_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('EMEA'))) {
                regionname = CSD_ClsUtils.MAP_REGIONCODE_REGIONNAME.get(acc.DD1_SALES_OFFICE_CDE__c);
            }else if(acc.DD1_SALES_OFFICE_CDE__c != null && (acc.DD1_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('ASIA PACIFIC'))) {
            	regionname = 'ASIA';
        	}else if(acc.DD1_SALES_OFFICE_CDE__c != null) {
            	if(CSD_ClsUtils.MAP_REGIONCODE_REGIONNAME.containsKey(acc.DD1_SALES_OFFICE_CDE__c)){
                	regionname = CSD_ClsUtils.MAP_REGIONCODE_REGIONNAME.get(acc.DD1_SALES_OFFICE_CDE__c);  
                }
        	}/*else if(acc.DD3_SALES_OFFICE_CDE__c != null && (acc.DD3_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('JAPAN') 
                || acc.DD3_SALES_OFFICE_CDE__c == CSD_ClsUtils.MAP_REGIONNAME_REGIONCODE.get('KOREA'))) {
                regionname = CSD_ClsUtils.MAP_REGIONCODE_REGIONNAME.get(acc.DD3_SALES_OFFICE_CDE__c);
            }/*else if(acc.WWCORPACCT__c != null && acc.WWCORPACCT__c == '00038464') {
                regionname = 'CHINA MOBILE';
            }*/
            map_accnumber_region.put(acc.AccountNumber, regionname);
        }
        return map_accnumber_region;
        
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
     * @created 2014-10-29
     * @version 1.0
     * @since 30.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2014-10-29 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public static String getASP(String sData) {
        try {
            CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData, CSD_ClsEntityType.SearchObj.class);

            String aspAPIName = 'BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c';
                
            Date backlogStartdate = Date.valueOf(searchOb.startDate);
            Date backlogEnddate = backlogStartdate.addMonths(24);
            String backlogSelect = ' sum(Backlog_Amount_USD__c) amount, sum(Backlog_Qty__c) qty ';
       
            String aspbillAPIName = 'BBB_Month_Bill_Book_Cust_PN__c';
            Date billEnddate = Date.valueOf(searchOb.startDate);
            Date billStartdate = billEnddate.addMonths(-6);
            String billSelect = ' sum(Bill_Amount_USD__c) amount, sum(Bill_Quantity__c) qty ';
            String region = '';
            String orgNum = '';
            String accNum = '';
            //for(Account acc : [select Id, Name, AccountNumber, Billing_Region__c from Account where Id = :searchOb.soldtoId ]) {
            //    if(acc.AccountNumber != null && acc.AccountNumber != '') {
                    orgNum = searchOb.accnumber.substring(0, searchOb.accnumber.indexOf(':')+1);
                    accNum = searchOb.accnumber.substring(searchOb.accnumber.indexOf(':')+1, searchOb.accnumber.length());
                //}
                //if(acc.Billing_Region__c != null && acc.Billing_Region__c != '') {
                //    region = acc.Billing_Region__c;
                //}
            //}
                
                
            list<String> list_sql = new list<String>();
            decimal asp = null;
                
                
            //P1: We can find backlog records for the particular Org ID, Part, Sold to for the future 24 months.
            //  ASP equals to sum (backlog amt) / sum(backlog units)
            list_sql.add(backlogSelect);
            list_sql.add(aspAPIName);
            list_sql.add(' WHERE Customer__r.AccountNumber = \''+ searchOb.accnumber +'\' ' 
                + ' And Part__c = \''+ searchOb.partId +'\' '
                + ' And Fiscal_Date__c >= : backlogStartdate '
                + ' And Fiscal_Date__c < : backlogEnddate ');

            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                if(result.get('amount') != null && (decimal)result.get('amount') != 0 && result.get('qty') != null && (decimal)result.get('qty') != 0 ) {
                    decimal sumamount = (decimal)result.get('amount');
                    decimal sumqty = (decimal)result.get('qty');
                    asp = sumamount / sumqty;
                }
            }
                
            //P2: We can find billing records for the particular Org ID, Part, Sold to for the previous 6 months. 
            //  ASP equals to sum (6M billing amt) / sum(6M billing units)
            if(asp == null) {
                list_sql.clear();
                list_sql.add(billSelect);
                list_sql.add(aspbillAPIName);
                list_sql.add(' WHERE Customer__r.AccountNumber = \''+ searchOb.accnumber +'\' ' 
                    + ' And Part__c = \''+ searchOb.partId +'\' '
                    + ' And Fiscal_Date__c >= : billStartdate '
                    + ' And Fiscal_Date__c < : billEnddate ');
                    
                for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                    if(result.get('amount') != null && (decimal)result.get('amount') != 0 && result.get('qty') != null && (decimal)result.get('qty') != 0 ) {
                        decimal sumamount = (decimal)result.get('amount');
                        decimal sumqty = (decimal)result.get('qty');
                        asp = sumamount / sumqty;
                    }
                }
            }
                
            //P3: We can find backlog records for the particular Org ID, Part for the future 24 months. 
            //  ASP equals to sum (backlog amt) / sum(backlog units)
            if(asp == null) {
                list_sql.clear();
                list_sql.add(backlogSelect);
                list_sql.add(aspAPIName);
                list_sql.add(' WHERE Customer__r.AccountNumber like \''+ orgNum +'%\' ' 
                    + ' And Part__c = \''+ searchOb.partId +'\' '
                    + ' And Fiscal_Date__c >= : backlogStartdate '
                    + ' And Fiscal_Date__c < : backlogEnddate ');
                    
                for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                    if(result.get('amount') != null && (decimal)result.get('amount') != 0 && result.get('qty') != null && (decimal)result.get('qty') != 0 ) {
                        decimal sumamount = (decimal)result.get('amount');
                        decimal sumqty = (decimal)result.get('qty');
                        asp = sumamount / sumqty;
                    }
                }
            }
                
            //P4: We can find billing records for the particular Org ID, Part for the previous 6 months. 
            //  ASP equals to sum (6M billing amt) / sum(6M billing units)
            if(asp == null) {
                list_sql.clear();
                list_sql.add(billSelect);
                list_sql.add(aspbillAPIName);
                list_sql.add(' WHERE Customer__r.AccountNumber like \''+ orgNum +'%\' ' 
                    + ' And Part__c = \''+ searchOb.partId +'\' '
                    + ' And Fiscal_Date__c >= : billStartdate '
                    + ' And Fiscal_Date__c < : billEnddate ');
                    
                for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                    if(result.get('amount') != null && (decimal)result.get('amount') != 0 && result.get('qty') != null && (decimal)result.get('qty') != 0 ) {
                        decimal sumamount = (decimal)result.get('amount');
                        decimal sumqty = (decimal)result.get('qty');
                        asp = sumamount / sumqty;
                    }
                }
            }
                
            //P5: We can find backlog records for the particular region, Part for the future 24 months. 
            //  ASP equals to sum (backlog amt) / sum(backlog units)
            if(asp == null) {
                list_sql.clear();
                list_sql.add(backlogSelect);
                list_sql.add(aspAPIName);
                list_sql.add(' WHERE Customer__r.Billing_Region__c = \''+ region +'\' ' 
                    + ' And Part__c = \''+ searchOb.partId +'\' '
                    + ' And Fiscal_Date__c >= : backlogStartdate '
                    + ' And Fiscal_Date__c < : backlogEnddate ');
                    
                for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                    if(result.get('amount') != null && (decimal)result.get('amount') != 0 && result.get('qty') != null && (decimal)result.get('qty') != 0 ) {
                        decimal sumamount = (decimal)result.get('amount');
                        decimal sumqty = (decimal)result.get('qty');
                        asp = sumamount / sumqty;
                    }
                }
            }
                
                
            //P6: We can find billing records for the particular region, Part for the previous 6 months. 
            //  ASP equals to sum (6M billing amt) / sum(6M billing units)
            if(asp == null) {
                list_sql.clear();
                list_sql.add(billSelect);
                list_sql.add(aspbillAPIName);
                list_sql.add(' WHERE Customer__r.Billing_Region__c = \''+ region +'\' ' 
                    + ' And Part__c = \''+ searchOb.partId +'\' '
                    + ' And Fiscal_Date__c >= : billStartdate '
                    + ' And Fiscal_Date__c < : billEnddate ');
                    
                for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                    if(result.get('amount') != null && (decimal)result.get('amount') != 0 && result.get('qty') != null && (decimal)result.get('qty') != 0 ) {
                        decimal sumamount = (decimal)result.get('amount');
                        decimal sumqty = (decimal)result.get('qty');
                        asp = sumamount / sumqty;
                    }
                }
            }
                
                
            //P7: We can find backlog records for the particular Part for the future 24 months. 
            //  ASP equals to sum (backlog amt) / sum(backlog units)
            if(asp == null) {
                list_sql.clear();
                list_sql.add(backlogSelect);
                list_sql.add(aspAPIName);
                list_sql.add(' WHERE Part__c = \''+ searchOb.partId +'\' '
                    + ' And Fiscal_Date__c >= : backlogStartdate '
                    + ' And Fiscal_Date__c < : backlogEnddate ');
                    
                for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                    if(result.get('amount') != null && (decimal)result.get('amount') != 0 && result.get('qty') != null && (decimal)result.get('qty') != 0 ) {
                        decimal sumamount = (decimal)result.get('amount');
                        decimal sumqty = (decimal)result.get('qty');
                        asp = sumamount / sumqty;
                    }
                }
            }
                
                
            //P8: We can find billing records for the particular Part for the previous 6 months. 
            //  ASP equals to sum (6M billing amt) / sum(6M billing units)
            if(asp == null) {
                list_sql.clear();
                list_sql.add(billSelect);
                list_sql.add(aspbillAPIName);
                list_sql.add(' WHERE Part__c = \''+ searchOb.partId +'\' '
                    + ' And Fiscal_Date__c >= : billStartdate '
                    + ' And Fiscal_Date__c < : billEnddate ');
                    
                for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                    if(result.get('amount') != null && (decimal)result.get('amount') != 0 && result.get('qty') != null && (decimal)result.get('qty') != 0 ) {
                        decimal sumamount = (decimal)result.get('amount');
                        decimal sumqty = (decimal)result.get('qty');
                        asp = sumamount / sumqty;
                    }
                }
            }
                
                
            if(asp != null) {
                return String.valueOf(asp.setScale(4, System.RoundingMode.HALF_UP));
            }else {
                return '0';
            }
        }catch(Exception ex) {
            throw ex;
        }
    }
 
    
    /**
     * This function is set Statistical Forecast date set
     * 
     * @author Lei Tang
     * @created 2014-10-29
     * @version 1.0
     * @since 30.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2014-10-29 Lei Tang <lei.tang@itbconsult.com>
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
     * @created 2014-10-29
     * @version 1.0
     * @since 30.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2014-10-29 Lei Tang <lei.tang@itbconsult.com>
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
     * This function is set Statistical Forecast month percent map
     * 
     * @author Lei Tang
     * @created 2014-10-29
     * @version 1.0
     * @since 30.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2014-10-29 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public static void setStatisticalPercentMap(map<Integer, decimal> map_month_Percent) {
        
        for(Integer i = 1; i < 13; i++) {
            map_month_Percent.put(i, 0);
        }
        
        for(Statistical_Forecast_Monthly_Percentage__c sfmp : [select Name, Fiscal_Month__c, Percentage__c 
                                                                from Statistical_Forecast_Monthly_Percentage__c]) {
            map_month_Percent.put((Integer)sfmp.Fiscal_Month__c, sfmp.Percentage__c);
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
    public static void setAllPeriodStartEndDateForComparison(map<String, Date> map_financialDate){   //set financial month
        
        for (Period period : [select StartDate from Period where StartDate <= Today and Type = 'Quarter' order by StartDate desc limit : QNUMBERCOMP]) {
            if(period.startDate != null && period.StartDate < map_financialDate.get('s')){
                map_financialDate.put('s', period.StartDate);
            }
        }
        
        for (Period period : [select EndDate from Period where EndDate >= Today and Type = 'Quarter' order by EndDate limit : FUTUREQNUMBERCOMP]) {
            if(period.EndDate != null && period.EndDate > map_financialDate.get('e')){
                map_financialDate.put('e', period.EndDate);
            }
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
    public static void setFiscalMonthForComparison(CSD_ClsEntityType.PageConfig pageConf){   //set current year & current month
        //just set pageConfig for one time
        if(pageConf.isSetupDone) {
            return;
        }
        pageConf.isSetupDone = true;
        map<String, Date> map_startAndEndDate = new map<String, Date>{'s' => system.today(), 'e' =>system.today()};
        //get the entire date range's start date and end date in map. 
        setAllPeriodStartEndDateForComparison(map_startAndEndDate);
        //system.debug('@#map_startAndEndDate : '+map_startAndEndDate);
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
        
        system.debug('@#pageConf.map_financialMonth:'+pageConf.map_financialMonth);
        
        map_startAndEndDate.clear();
        //set current month index
        setCurrentMonthIndex(pageConf);

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
    public static void createDateItemForComparison(CSD_ClsEntityType.PageConfig pageConf, list<CSD_ClsEntityType.DateItem> list_allDateItems) {
        
        String str_monthLabel = '';
        String str_qLabel = '';
        String str_mLabel = '';
        String str_yearLabel = '';
        Integer monthCounter = 0;
        CSD_ClsEntityType.DateItem tempDateItem;
        String temp_qMonths = '';
        //generate table header for history, current and future date type
        pageConf.str_tableHead = ((pageConf.str_tableHead == null || pageConf.str_tableHead == '')
                                    ? '<th class="fixthh th_historicalcls tl" colspan="6" style="height: 0px !important;"><div class="fix_lh historicalc">Current Cycle Latest Sales Fcst</div></th>'
                                    + '<th class="fixthh th_currentcls tl" old="4" colspan="6"><div class="fix_lh current_cls"><div class="absdiv">Last Cycle DC Fcst</div></div></th>'
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
            
            for(Integer j = 1; j <= 18; j++) {
                //tempDateItem = new CSD_ClsEntityType.DateItem(itemname);
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
                //set data item month label format 2014-3
                str_mLabel = str_yearFullLabel + '_' + monthCounter;
                
                str_yearLabel = 'FY' + str_yearLabel.subString(2);
                
                str_monthLabel = MAP_NUMBERMONTHLABEL.get(monthCounter);
                //if(j < pageConf.currentMonthIndex) {
                CSD_ClsEntityType.DateItem tempMonthItem = new CSD_ClsEntityType.DateItem('');
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
                    CSD_ClsEntityType.DateItem tempTotalItem = new CSD_ClsEntityType.DateItem(str_qLabel);
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
    
    
    
    public static list<CSD_ClsEntityType.AccountObjForComparison> getExistResultForComparisonBase(list<AggregateResult> list_Results,
                                            map<String, String> map_quarter_months, String name, Boolean ishaxId, String labelname) {
        
        list<CSD_ClsEntityType.AccountObjForComparison> list_AccountObj = new list<CSD_ClsEntityType.AccountObjForComparison>();
        
        map<String, CSD_ClsEntityType.AccountObjForComparison> map_acctId_acctFC = new map<String, CSD_ClsEntityType.AccountObjForComparison>();

        for(AggregateResult result : list_Results) {
            //system.debug('@#result : '+result);
            String accId = (String)result.get(name), 
                   year = (String) result.get('year'),
                   month = (String) result.get('month'), 
                   dateKey = (year + '_' + month);
                       
            CSD_ClsEntityType.AccountObjForComparison acctFC = new CSD_ClsEntityType.AccountObjForComparison();
                
            if(!map_acctId_acctFC.containsKey(accId)) {
                CSD_ClsUtils.createAccountObjForComprison(acctFC, map_quarter_months);
                if(ishaxId) {
                    Blob aes = Crypto.generateAesKey(128);
                    String hex = EncodingUtil.convertToHex(aes);
                    acctFC.id = hex;
                }else {
                    acctFC.id = accId;
                }
                
                acctFC.name = (String)result.get(labelname);
                acctFC.accnumber = accId;
                map_acctId_acctFC.put(accId, acctFC);
            }else {
                acctFC = map_acctId_acctFC.get(accId);
            }
                
            for(String quarter : map_quarter_months.keySet()) {
                
                set<String> set_months = new set<String>();
                set_months.addAll(map_quarter_months.get(quarter).split(','));

                if(set_months.contains(dateKey)) {
                    
                    Decimal sumFC = (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0);
                    Decimal totalFC = 0;
                    if(acctFC.csFC.containsKey(quarter)) {
                        totalFC = acctFC.csFC.get(quarter);
                    }
                    totalFC += sumFC;
                    acctFC.csFC.put(quarter, totalFC);
                    
                //  system.debug('@@@@@@@@@@@minghao.li@@@@@@@@@@@@@@');
                //  system.debug( ( String.valueOf( result.get('sumDCFC') ) == 'null' )   );
                //  system.debug( ( String.valueOf( result.get('sumDCFC') ) == null )   );
                //  system.debug('@@@@@@@@@@@minghao.li@@@@@@@@@@@@@@');
                    
                    Decimal sumDCFC = 0;
                    try{//the try checked channel forecast query DCFC field used.
                        sumDCFC = (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0);
                    }catch(Exception e){ }
                    
                //  Decimal sumDCFC = (String.valueOf(result.get('sumDCFC')) != null ? (decimal)result.get('sumDCFC') : 0);
                    Decimal totalDCFC = 0;
                    if(acctFC.dcFC.containsKey(quarter)) {
                        totalDCFC = acctFC.dcFC.get(quarter);
                    }
                    totalDCFC += sumDCFC;
                    acctFC.dcFC.put(quarter, totalDCFC);
                    
                    acctFC.pmFC.put(quarter, (totalFC - totalDCFC));
                }
            }
            
            acctFC.json_csFC = JSON.serialize(acctFC.csFC);
            acctFC.json_dcFC = JSON.serialize(acctFC.dcFC);
            acctFC.json_pmFC = JSON.serialize(acctFC.pmFC);
            
            map_acctId_acctFC.put(accId, acctFC);    
            
        }
        
        return compareListByDate(map_acctId_acctFC);

    }
    
    
    public static void getExistResultForComparisonBaseNew(list<AggregateResult> list_Results, 
                                            map<String, CSD_ClsEntityType.AccountObjForComparison> map_acctId_acctFC,
                                            map<String, String> map_quarter_months, String name, Boolean ishaxId, String labelname, Boolean isChannel) {

        for(AggregateResult result : list_Results) {
            //system.debug('@#result : '+result);
            String accId = (String)result.get(name), 
                   year = (String) result.get('year'),
                   month = (String) result.get('month'), 
                   dateKey = (year + '_' + month);
                       
            CSD_ClsEntityType.AccountObjForComparison acctFC = new CSD_ClsEntityType.AccountObjForComparison();
            
            if(!map_acctId_acctFC.containsKey(accId)) {
                CSD_ClsUtils.createAccountObjForComprison(acctFC, map_quarter_months);
                if(ishaxId) {
                    Blob aes = Crypto.generateAesKey(128);
                    String hex = EncodingUtil.convertToHex(aes);
                    acctFC.id = hex;
                }else {
                    acctFC.id = accId;
                }
                try {
                    acctFC.name = (String)result.get(labelname) + (result.get('descr') == null ? '' : ' - '+(String)result.get('descr'));
                }catch(Exception ex) {
                    acctFC.name = (String)result.get(labelname);
                }
                acctFC.accnumber = accId;
                
                map_acctId_acctFC.put(accId, acctFC);
            }else {
                acctFC = map_acctId_acctFC.get(accId);
            }
            
            if(isChannel) {
                acctFC.type = 'channel';
            }
            
            for(String quarter : map_quarter_months.keySet()) {
                
                set<String> set_months = new set<String>();
                set_months.addAll(map_quarter_months.get(quarter).split(','));
                
                if(set_months.contains(dateKey)) {
                    
                    Decimal sumFC = (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0);
                   
                    Decimal totalFC = 0;
                    if(acctFC.csFC.containsKey(quarter)) {
                        totalFC = acctFC.csFC.get(quarter);
                    }
                    totalFC += sumFC;
                    system.debug('@#quarter:'+totalFC+'='+acctFC.csFC.get(quarter)+'+'+sumFC);
                    acctFC.csFC.put(quarter, totalFC);
                    
                    Decimal sumDCFC = 0;
                    try{//the try checked channel forecast query DCFC field used.
                        //Decimal sumDCFC = (String.valueOf(result.get('sumDCFC')) != null ? (decimal)result.get('sumDCFC') : 0);
                        sumDCFC = (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0);
                    }catch(Exception e) { }
                    Decimal totalDCFC = 0;
                    if(acctFC.dcFC.containsKey(quarter)) {
                        totalDCFC = acctFC.dcFC.get(quarter);
                    }
                    totalDCFC += sumDCFC;
                    acctFC.dcFC.put(quarter, totalDCFC);
                    
                    acctFC.pmFC.put(quarter, (totalFC - totalDCFC));
                }
            }
            
            acctFC.json_csFC = JSON.serialize(acctFC.csFC);
            acctFC.json_dcFC = JSON.serialize(acctFC.dcFC);
            acctFC.json_pmFC = JSON.serialize(acctFC.pmFC);
            
            map_acctId_acctFC.put(accId, acctFC);    
            
        }
    }
    
    
    public static list<CSD_ClsEntityType.AccountObjForComparison> compareListByDate(map<String, CSD_ClsEntityType.AccountObjForComparison> map_acctId_acctFC) {
        list<CSD_ClsEntityType.AccountObjForComparison> list_AccountObj = new list<CSD_ClsEntityType.AccountObjForComparison>();
        
        list_AccountObj.addAll(map_acctId_acctFC.values());
        
        for(CSD_ClsEntityType.AccountObjForComparison obj : list_AccountObj) {
            String samildate = '9999_01';
            for(String datekey : obj.csFC.keySet()) {
                String tempdate = datekey;
                if(samildate > tempdate) {
                    samildate = tempdate;
                }
            }
            obj.csFCamount = obj.csFC.get(samildate);
        }
        list_AccountObj.sort();
        system.debug('@#list_AccountObj:'+list_AccountObj);
        return list_AccountObj;
    }
    
    
    
    /**
    * This method is get data of comparison.
    *
    @author Lei Tang
    @created 2014-12-23
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-12-23 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public static void getExistResultForComparison(map<String, String> map_quarter_months, 
                                            map<String, CSD_ClsEntityType.AccountObjForComparison> map_acctId_acctFC, 
                                            set<String> set_regions, list<String> list_sql, 
                                            Date currentdate, Date enddate, String name, Boolean ishaxId, String labelname, Boolean isChannel) {
        list<AggregateResult> list_Results = new list<AggregateResult>();
        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
            list_Results.add(result);
        }
        
        CSD_ClsUtils.getExistResultForComparisonBaseNew(list_Results, map_acctId_acctFC, map_quarter_months, name, ishaxId, labelname, isChannel);
        //return CSD_ClsUtils.getExistResultForComparisonBase(list_Results, pageconf.map_quarter_months, name, ishaxId, labelname);
        
    }
    
    
    /**
    * This method is used auto Create SoldTo Forecast.
    *
    @author Lei Tang
    @created 2014-12-23
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-12-23 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public static void autoCreateOEMForecast(map<String, set<String>> map_hasBillingSoldto_OEMs, Date fiscaldate, set<String> set_accnumber) {
        
        //map<String, set<String>> map_hasBillingSoldto_OEMs = new map<String, set<String>>();
        //CSD_ClsUtils.setautoOEMIds(map_hasBillingSoldto_OEMs, set_acctIds, fiscaldate);
        
        if(map_hasBillingSoldto_OEMs.size() == 0) {
            return;
        }
        
        Date currentdate = fiscaldate.addMonths(1);
        Date enddate = currentdate.addMonths(12);
        
        list<String> list_sql = new list<String>();
        set<String> set_soldto = map_hasBillingSoldto_OEMs.keySet();
        
        list_sql.add(' Sold_To_Number__c soldto, OEM__c oem ');
        list_sql.add(' CSD_Sales_Forecast__c ');
        list_sql.add(' WHERE Sold_To_Number__c IN :set_accnumber ' 
                + ' And Type__c = \'OEM\' '
                //+ ' And OEM__c IN :set_autoOEMs '
                + ' And Fiscal_Date__c >= : currentdate '
                + ' And Fiscal_Date__c < : enddate '
                + ' Group by Sold_To_Number__c, OEM__c ');
        
        map<String, set<String>> map_soldto_oem = new map<String, set<String>>();
        
        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
            if(map_soldto_oem.containsKey((String)result.get('soldto'))) {
                map_soldto_oem.get((String)result.get('soldto')).add((String)result.get('oem'));
            }else {
                set<String> set_oems = new set<String>();
                set_oems.add((String)result.get('oem'));
                map_soldto_oem.put((String)result.get('soldto'), set_oems);
            }
        }
        
        
        
        list<CSD_Sales_Forecast__c> list_restforecast = new list<CSD_Sales_Forecast__c>();
        for(CSD_Sales_Forecast__c fc : [select Id, Fiscal_Year__c, Fiscal_Month__c, Sold_To_Number__c, Rest_Parts_Forecast__c, 
                                            OEM__c, Part__c, Price__c, Quantity__c, Forecast__c, Type__c
                                        From CSD_Sales_Forecast__c 
                                        where Sold_To_Number__c IN :map_hasBillingSoldto_OEMs.keySet() And Type__c = 'Rest-SoldTo' ]) {
             list_restforecast.add(fc);
        }
        if(list_restforecast.size() > 0) {
            delete list_restforecast;
        }
        
        system.debug('@#map_soldto_oem:' + map_soldto_oem);
        list<CSD_Sales_Forecast__c> list_forecast = new list<CSD_Sales_Forecast__c>();
        
        map<String, String> map_acctid_name = new map<String, String>();
        
        for(Account a : [Select Name, AccountNumber From Account Where AccountNumber IN: map_hasBillingSoldto_OEMs.keySet()]){
            map_acctid_name.put(a.AccountNumber, a.Name);
        }
        
        map<String, String> map_soldto_region  = CSD_ClsUtils.getRegionForCreateSoldTo(map_hasBillingSoldto_OEMs.keySet());
        
        //map<String, String> map_accid_region = new map<String, String>();
        //map_accid_region  = CSD_ClsUtils.getRegionForSoldTo(map_hasBillingSoldto_OEMs.keySet(), '', '');

        for(String soldto : map_hasBillingSoldto_OEMs.keySet()) {
            String accountName = (map_acctid_name.containsKey(soldto) ? map_acctid_name.get(soldto) : null);
            if(!map_soldto_oem.containsKey(soldto)) {
                CSD_Sales_Forecast__c forecast = new CSD_Sales_Forecast__c(
                    Price__c = 0, Quantity__c = 0, Forecast__c = 0,
                    Fiscal_Year__c = String.valueOf(currentdate.year()),
                    Fiscal_Month__c = String.valueOf(currentdate.month()),
                    Sold_To_Number__c = soldto, Billing_Region__c = map_soldto_region.get(soldto),
                    Sold_To_Name__c = accountName, Type__c = 'Sold-To', CurrencyIsoCode = 'USD'
                );

                list_forecast.add(forecast);

                for(String oem : map_hasBillingSoldto_OEMs.get(soldto)) {
                    CSD_Sales_Forecast__c forecastOEM = new CSD_Sales_Forecast__c(
                        Price__c = 0, Quantity__c = 0, Forecast__c = 0, Rest_Parts_Forecast__c = 0,
                        Fiscal_Year__c = String.valueOf(currentdate.year()), Fiscal_Month__c = String.valueOf(currentdate.month()),
                        Sold_To_Number__c = soldto,  OEM__c = oem, Type__c = 'OEM', Billing_Region__c = map_soldto_region.get(soldto),
                        Sold_To_Name__c = accountName, CurrencyIsoCode = 'USD'
                    );
                    list_forecast.add(forecastOEM);
                }

            }else {
                
                for(String oem : map_hasBillingSoldto_OEMs.get(soldto)) {
                    if(!map_soldto_oem.get(soldto).contains(oem)) {
                        CSD_Sales_Forecast__c forecastOEM = new CSD_Sales_Forecast__c(
                            Price__c = 0, Quantity__c = 0, Forecast__c = 0, Rest_Parts_Forecast__c = 0,
                            Fiscal_Year__c = String.valueOf(currentdate.year()), Fiscal_Month__c = String.valueOf(currentdate.month()),
                            Sold_To_Number__c = soldto, OEM__c = oem, Type__c = 'OEM', Billing_Region__c = map_soldto_region.get(soldto),
                            Sold_To_Name__c = accountName, CurrencyIsoCode = 'USD'
                        );
                        
                        list_forecast.add(forecastOEM);
                    }
                }
            }
        }
        system.debug('@#list_forecast:'+list_forecast);
        //list<CSD_ClsEntityType.AccountObj> list_accFc = new list<CSD_ClsEntityType.AccountObj>();
        if(list_forecast.size() > 0) {
            insert list_forecast;
        }

    }
    
    
    /**
    * This method is used get Level 1 data for SOld-To forecast page.
    *
    @author Lei Tang
    @created 2014-12-23
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-12-23 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public static void getSoldtoLevel1Data(list<Object> list_data, String sData, set<String> set_acctIds, set<String> set_autoOEMs, set<String> set_allaccIds) {
        
        
        CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData, CSD_ClsEntityType.SearchObj.class);
        list<String> list_sql = new list<String>();
        
        Date currentdate = Date.valueOf(searchOb.startDate);
        Date enddate = Date.valueOf(searchOb.endDate);

        list_sql.add('Sold_To_Number__c soldto, Sold_To_Name__c name, Billing_Region__c region, Fiscal_Year__c year, Fiscal_Month__c month, '
                + 'sum(DC_Forecast_Amount__c) sumDCFC, sum(Forecast__c) sumFC, sum(Previous_Month_Forecast__c) sumPMFC');  
        list_sql.add(' CSD_Sales_Forecast__c ');
        list_sql.add(' WHERE Type__c = \'Sold-To\' '
                    + ' And Sold_To_Number__c in : set_acctIds ' 
                    + ' And Samsung_Type__c = null ' 
                    + (CSD_Configuration__c.getInstance('Samsung OEM Account') != null && CSD_Configuration__c.getInstance('Samsung OEM Account').Value__c != '' ? ' And OEM__c != \'' + CSD_Configuration__c.getInstance('Samsung OEM Account').Value__c + '\' ' : '')
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, Sold_To_Number__c, Sold_To_Name__c, Billing_Region__c ');
        //Generate forecast view object
        
        map<String, CSD_ClsEntityType.AccountObj> map_acctId_acctFC = new map<String, CSD_ClsEntityType.AccountObj>();
        //map<String, String> map_accid_name = new map<String, String>();
        map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result =
            new map<String, map<String, AggregateResult>>();
        
        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
            //system.debug('@#result : '+result);
            String accId = (String)result.get('soldto'), 
                   year = (String) result.get('year'),
                   month = (String) result.get('month'), 
                   dateKey = (year + '_' + month);
            //map_accid_name.put(accId, (String)result.get('name'));
            CSD_ClsUtils.setResultMap(result, accId, dateKey, map_acctId_map_dateKey_result);               
        }
        
        map<String, String> map_accid_Comment = new map<String, String>();
        if(map_acctId_map_dateKey_result.size() > 0) {
            for(Account acc : [select AccountNumber, Name, CSD_EOL_Comment__c from Account where AccountNumber IN :map_acctId_map_dateKey_result.keySet() ] ) {
                map_accid_Comment.put(acc.AccountNumber, acc.CSD_EOL_Comment__c);
            }
        }
        
        map<String, Boolean> map_soldto_haskeyoem = new map<String, Boolean>();
        CSD_ClsUtils.setMapSoldtohasKeyOEM(map_soldto_haskeyoem, map_acctId_map_dateKey_result.keySet(), set_autoOEMs, currentdate);
        
        //map<String, String> map_accid_region = CSD_ClsUtils.getRegionForSoldTo(map_acctId_map_dateKey_result.keySet(), '', '');
        
        //system.debug('@#map_acctId_map_dateKey_result :'+map_acctId_map_dateKey_result.keySet());
        for(String acctId : map_acctId_map_dateKey_result.keySet()) {
            CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
            CSD_ClsUtils.createAccountObj(acctFC, searchOb.map_year_monthsFuture);
            
            String hex = CSD_ClsUtils.getHexUID();
            acctFC.id = hex;
            acctFC.accnumber = acctId;
            acctFc.eolcomment = map_accid_Comment.get(acctId);
            acctFC.type = (map_soldto_haskeyoem.containsKey(acctId) ? 'NoDel' : '');

            map_acctId_acctFC.put(acctId, acctFC);

            for(String year : searchOb.map_year_monthsFuture.keySet()) {
                for(Integer month : searchOb.map_year_monthsFuture.get(year)) {
                    String dateKey = (year + '_' + String.valueOf(month));
                    AggregateResult result;
                    
                    if(map_acctId_map_dateKey_result.containsKey(acctId) 
                        && map_acctId_map_dateKey_result.get(acctId).containsKey(dateKey)) {
                        
                        result = map_acctId_map_dateKey_result.get(acctId).get(dateKey);
                        
                        acctFC.name = (result.get('name') != null ? (String)result.get('name') : '');
                        acctFC.region = (result.get('region') != null ? (String)result.get('region') : '');
                    }
                    
                    if(result != null) {
                        map_acctId_acctFC.get(acctId).csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
                        map_acctId_acctFC.get(acctId).dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
                        map_acctId_acctFC.get(acctId).pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
                    }             
                }
            }
        }
        
        list<CSD_ClsEntityType.AccountObj> list_accFc = new list<CSD_ClsEntityType.AccountObj>();
        list_accFc.addAll(map_acctId_acctFC.values());
        list_accFc.sort();
        for(Integer i = 0; i < list_accFc.size(); i++) {
            list_data.add(list_accFc.get(i));
        }
        //system.debug('@#obj :'+map_acctId_acctFC.get('001c000000gFkUpAAK'));
        map_acctId_acctFC.clear();
        
        list_sql.clear();
        map_acctId_map_dateKey_result.clear();
        list_sql.add(' Fiscal_Year__c year, Fiscal_Month__c month, '
                + 'sum(DC_Forecast_Amount__c) sumDCFC, sum(Forecast__c) sumFC, sum(Previous_Month_Forecast__c) sumPMFC');
        list_sql.add(' CSD_Sales_Forecast__c ');
        list_sql.add(' WHERE Type__c = \'Rest-SoldTo\' '
                    + ' And Sold_To_Number__c in : set_allaccIds ' 
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Fiscal_Year__c, Fiscal_Month__c ');
        
        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
            String year = (String) result.get('year'),
                   month = (String) result.get('month'), 
                   dateKey = (year + '_' + month);      
            CSD_ClsUtils.setResultMap(result, CSD_ClsUtils.RESTSOLDTOID, dateKey, map_acctId_map_dateKey_result);              
        }
        
        CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
        CSD_ClsUtils.createAccountObj(acctFC, searchOb.map_year_monthsFuture);
        acctFC.id = CSD_ClsUtils.RESTSOLDTOID;
        acctFC.accnumber = 'Rest Sold To Accounts';
        acctFC.name = 'Rest Sold To Accounts';
        
        map_acctId_acctFC.put(CSD_ClsUtils.RESTSOLDTOID, acctFC);
        for(String year : searchOb.map_year_monthsFuture.keySet()) {
            for(Integer month : searchOb.map_year_monthsFuture.get(year)) {
                String dateKey = (year + '_' + String.valueOf(month));
                AggregateResult result;
                
                if(map_acctId_map_dateKey_result.containsKey(CSD_ClsUtils.RESTSOLDTOID) 
                    && map_acctId_map_dateKey_result.get(CSD_ClsUtils.RESTSOLDTOID).containsKey(dateKey)) {
                    
                    result = map_acctId_map_dateKey_result.get(CSD_ClsUtils.RESTSOLDTOID).get(dateKey);
                }
                
                if(result != null) {
                    map_acctId_acctFC.get(CSD_ClsUtils.RESTSOLDTOID).csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
                    map_acctId_acctFC.get(CSD_ClsUtils.RESTSOLDTOID).dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
                    map_acctId_acctFC.get(CSD_ClsUtils.RESTSOLDTOID).pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
                }
            }
        }       
        /*
        CSD_ClsEntityType.AccountObj testFC = new CSD_ClsEntityType.AccountObj();
        CSD_ClsUtils.createAccountObj(testFC, searchOb.map_year_monthsFuture);
        String hexaid = CSD_ClsUtils.getHexUID();
        testFC.id = hexaid;
        testFC.accnumber = 'Test';
        testFC.name = 'test';
        testFC.type = 'NoDel';
        list_data.add(testFC);
        */
        for(CSD_ClsEntityType.AccountObj obj : map_acctId_acctFC.values()) {
            //system.debug('@#obj.csFC :'+obj.csFC);
            list_data.add(obj);
        }
    }
    
    
    /**
    * This method is used get auto create OEM Id.
    *
    @author Lei Tang
    @created 2014-12-23
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-12-23 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public static void setautoOEMIds(map<String, set<String>> map_hasBillingSoldto_OEMs, set<String> set_accnumber, Date fiscaldate) {
        //map_hasBillingSoldto_OEMs = new map<String, set<String>>();
        Date startdate = fiscaldate.addMonths(-6);
        String nonoemid = '';
        if(CSD_Configuration__c.getInstance('Non OEM Account') != null && CSD_Configuration__c.getInstance('Non OEM Account').Value__c != null) {
            nonoemid = CSD_Configuration__c.getInstance('Non OEM Account').Value__c;
        }
        
        for(AggregateResult result  : [select Monthly_Billings_Bookings_by_Part__r.Customer__r.AccountNumber soldto, OEM_Mapping__r.OEM__r.OEM__c oem
                                                        from CSD_OEM_Mapping_Monthly_BBB__c 
                                                        where Monthly_Billings_Bookings_by_Part__r.Fiscal_Date__c >= :startdate
                                                            and Monthly_Billings_Bookings_by_Part__r.Fiscal_Date__c <= :fiscaldate
                                                            and Monthly_Billings_Bookings_by_Part__r.Customer__r.STATDESC__c = 'Active'
                                                            and Monthly_Billings_Bookings_by_Part__r.Bill_Amount_USD__c > 0
                                                            and Monthly_Billings_Bookings_by_Part__r.Customer__r.AccountNumber IN :set_accnumber 
                                                            and OEM_Mapping__r.OEM__r.OEM__c != :nonoemid
                                                            group by Monthly_Billings_Bookings_by_Part__r.Customer__r.AccountNumber, OEM_Mapping__r.OEM__r.OEM__c]) {
            if(map_hasBillingSoldto_OEMs.containsKey((String)result.get('soldto'))) {
                map_hasBillingSoldto_OEMs.get((String)result.get('soldto')).add((String)result.get('oem'));
            }else {
                set<String> oems = new set<String>();
                oems.add((String)result.get('oem'));
                map_hasBillingSoldto_OEMs.put((String)result.get('soldto'), oems);
            }       
        }

    }
    
    
    public static void setMapSoldtohasKeyOEM(map<String, Boolean> map_soldto_haskeyoem, set<String> set_acctIds, set<String> set_keyOEMs, Date fiscaldate) {
        
        list<String> list_sql = new list<String>();

        Date currentdate = fiscaldate;
        Date enddate = currentdate.addMonths(13);
        
        list_sql.add('Sold_To_Number__c soldto, OEM__c oem');  
        list_sql.add(' CSD_Sales_Forecast__c ');
        list_sql.add(' WHERE Type__c = \'OEM\' '
                    + ' And Sold_To_Number__c in : set_acctIds ' 
                    + ' And OEM__c in : set_keyOEMs ' 
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Sold_To_Number__c, OEM__c ');
        
        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
            
            String accId = (String)result.get('soldto');
            if(!map_soldto_haskeyoem.containsKey(accId)) {
                map_soldto_haskeyoem.put(accId, true);
            }
               
        }

    }
    
    
    /**
    * This method is used auto Create SoldTo Forecast.
    *
    @author Lei Tang
    @created 2014-12-23
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-12-23 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public static void autoCreateOEMForecastAndGetSoldtoData(list<Object> list_data, String sData) {
         
        Date fiscaldate = CSD_ClsUtils.getFiscalDate();
        CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData, CSD_ClsEntityType.SearchObj.class);
        system.debug('@#searchOb.managerId : '+searchOb.managerId);
        set<String> set_acctIds = new set<String>();
        CSD_ClsUtils.setTerritoryAccountSetByUserId(set_acctIds, CSD_ClsUtils.getManageUserId(searchOb.managerId));
        set<String> set_newacctIds = new set<String>();
        if(set_acctIds.size() > 0 ) {
            for(String accid : set_acctIds) {
                if(!searchOb.set_selectedId.contains(accid)) {
                    set_newacctIds.add(accid);
                }
            }
        }
        system.debug('@#searchOb.set_selectedId : '+searchOb.set_selectedId);
        system.debug('@#set_acctIds : '+set_acctIds);
        system.debug('@#set_newacctIds : '+set_newacctIds);
        map<String, set<String>> map_hasBillingSoldto_OEMs = new map<String, set<String>>();
        CSD_ClsUtils.setautoOEMIds(map_hasBillingSoldto_OEMs, set_newacctIds, fiscaldate);
        set<String> set_autoOEMs = new set<String>();
        for(set<String> oems : map_hasBillingSoldto_OEMs.values()) {
            for(String oem : oems) {
                if(!set_autoOEMs.contains(oem)) {
                    set_autoOEMs.add(oem);
                }
            }
        }
        system.debug('@#set_autoOEMs : '+set_autoOEMs);
        CSD_ClsUtils.autoCreateOEMForecast(map_hasBillingSoldto_OEMs, fiscaldate, set_newacctIds);
        CSD_ClsUtils.getSoldtoLevel1Data(list_data, sData, set_newacctIds, set_autoOEMs, set_acctIds);
        
    }
    
    
    public static void setGAMViewAccountObjMap(map<String, CSD_ClsEntityType.AccountObj> map_acctId_acctFC, CSD_ClsEntityType.PageConfig pageconf, list<String> list_sql, set<String> set_oemIds, Date currentdate, Date enddate) {
        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
            //system.debug('@#result : '+result);
            String accId = (String)result.get('oem'), 
                   year = (String) result.get('year'),
                   month = (String) result.get('month'), 
                   dateKey = (year + '_' + month);
                   
            CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
    
            if(!map_acctId_acctFC.containsKey(accId)) {
                CSD_ClsUtils.createAccountObj(acctFC, pageconf.map_financialMonth);
                
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
    * This method is used set OEM competence of GAM view and Global GAM Comparison view 
    *
    @author Lei Tang
    @created 2015-01-09
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-01-09 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public static void setGAMOEMCompetence(String rolename,set<String> set_oemIds) {
        
        Boolean isSalesLeader = false;
        for(CSD_Forecast_Management__c acc : [Select Id from CSD_Forecast_Management__c where Role__c = :rolename And User__c = :UserInfo.getUserId() ]) {
            isSalesLeader = true;
            break;
        }
        
        if(isSalesLeader) {
            for(Account acc:  [select Id, Name 
                               from Account 
                               where RecordType.Name = 'OEM' 
                                    and Active__c = true
                                    //and Profit_ctr_code__c = 'CSD'  
                                    ]) {
                set_oemIds.add(acc.Id);
            }
        }else {
            for(Account acc:  [select Id, Name 
                               from Account 
                               where RecordType.Name = 'OEM' 
                                    and Account_Manager__c = :UserInfo.getUserId()
                                    and Active__c = true
                                    //and Profit_ctr_code__c = 'CSD'  
                                    ]) {
                set_oemIds.add(acc.Id);
            }
        }
    }
    
    
    
    public static String getAttentionString() {
        
        Integer month = 1, day = 26;
        //Date currentFiscalDate;
        for (Period period : [select Id, PeriodLabel, EndDate
                                from Period where StartDate<=Today and EndDate >=Today and Type = 'Month']) {
            if(period.PeriodLabel != null && MAP_MONTHLABELNUMBER.containsKey(period.PeriodLabel)){ //set current month
                month = Integer.valueOf(MAP_MONTHLABELNUMBER.get(period.PeriodLabel));
            }
            day = period.EndDate.adddays(-7).day();//day = period.EndDate.day();
        }
        
        map<Integer, CSD_ClsEntityType.AttentionString> map_AttentionString = new map<Integer, CSD_ClsEntityType.AttentionString>();
        CSD_ClsEntityType.AttentionString attention1 = new CSD_ClsEntityType.AttentionString();
        attention1.attentionString = 'Attention';
        attention1.isRed = true;
        map_AttentionString.put(1,attention1);
        CSD_ClsEntityType.AttentionString attention2 = new CSD_ClsEntityType.AttentionString();
        attention2.attentionString = ': Cutoff date for ';
        attention2.isRed = false;
        map_AttentionString.put(2,attention2);
        CSD_ClsEntityType.AttentionString attention3 = new CSD_ClsEntityType.AttentionString();
        attention3.attentionString = (month == 12 ? MAP_NUMBERFULLMONTHLABEL.get(1) : MAP_NUMBERFULLMONTHLABEL.get(month+1));
        attention3.isRed = true;
        map_AttentionString.put(3,attention3);
        CSD_ClsEntityType.AttentionString attention4 = new CSD_ClsEntityType.AttentionString();
        attention4.attentionString = ' Cycle sales forecast entry is ';
        attention4.isRed = false;
        map_AttentionString.put(4,attention4);
        CSD_ClsEntityType.AttentionString attention5 = new CSD_ClsEntityType.AttentionString();
        string strCutoffday = String.valueOf(day);
        if(strCutoffday.endswith('1'))
            attention5.attentionString = strCutoffday  + 'st ' + MAP_NUMBERFULLMONTHLABEL.get(month) + '.';
        if(strCutoffday.endswith('2'))
            attention5.attentionString = strCutoffday  + 'nd ' + MAP_NUMBERFULLMONTHLABEL.get(month) + '.';        
        else if(strCutoffday.endswith('3'))
            attention5.attentionString = strCutoffday  + 'rd ' + MAP_NUMBERFULLMONTHLABEL.get(month) + '.';
        else
            attention5.attentionString = strCutoffday  + 'th ' + MAP_NUMBERFULLMONTHLABEL.get(month) + '.';
        attention5.isRed = true;
        map_AttentionString.put(5,attention5);
        
        return Json.serialize(map_AttentionString);
        
    }
    
    
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
}