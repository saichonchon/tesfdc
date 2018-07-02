/**
*   util class for opptunity forecast
*
@author Xia Tong
@created 2012-11-06
@version 1.0
@since 23.0 (Force.com ApiVersion)
*
@changelog   
* 2015-06-05 Nelson Zheng
* - Add some System.debug() to do some investigation.

* 2014-04-18 Lili Zhao <lili.zhao@itbconsult.com>
* -due to set the field of Fiscal_Month__c
*
@changelog   
* 2012-11-06 Xia Tong <xia.tong@itbconsult.com>
* - Created
* - Modified 2016-02-22 Rajendra Shahane <rajendra.shahane@zensar.in>
* - Modified saveProgram and updateNewlyOppyForecast methods for case 00900667
* - Modified 2016-06-13 Rajendra Shahane <rajendra.shahane@zensar.in> for case 900762
*/

global class ClsOppyForecastUtil {

    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public static list<Opportunity_Forecast__c> list_oppysForecast2Del;  
    public static map<string,string> map_year_revApi;
    public static map<string,string> map_year_QTYApi;
    public static map<string,string> map_year_PRICEApi;
    public static String deletePartException;
    public static final String MODE_INSERT = 'INSERT';
    public static final String MODE_UPDATE = 'UPDATE'; 
    public static final String MONTHLY = 'Monthly';
    public static final String YEARLY = 'Yearly';
    public static final String QUARTERLY = 'Quarterly';
    public static String currentFisicalYear;
    
    public static final map<Integer, String> MAP_MONTH = new map<Integer, String>{
        1 => 'Oct',
        2 => 'Nov',
        3 => 'Dec',
        4 => 'Jan',
        5 => 'Feb',
        6 => 'Mar',
        7 => 'Apr',
        8 => 'May',
        9 => 'Jun',
        10 => 'Jul',
        11 => 'Aug',
        12 => 'Sep'
        
    };
    
    // add lili 2014-04-18 begin ** dute to set the field of Fiscal_Month__c when the lever is QUARTER
    public static final map<Integer, String> MAP_QUARTERYear = new map<Integer, String>{
        1 => 'Oct',
        2 => 'Jan',
        3 => 'Apr',
        4 => 'Jul'
    };
    // add lili 2014-04-18 end
    
    public static final map<Integer, String> MAP_THEMONTHLABEL = new map<Integer, String>{
        4 => System.label.January,
        5 => System.label.February,
        6 => System.label.March,
        7 => System.label.April,
        8 => System.label.May,
        9 => System.label.June,
        10 => System.label.July,
        11 => System.label.August,
        12 => System.label.September,
        1 => System.label.October,
        2 => System.label.November,
        3 => System.label.December
    };
    
    public static final map<String, String> MAP_MONTHLABEL = new map<String, String>{
        'Jan' => System.label.January,
        'Feb' => System.label.February,
        'Mar' => System.label.March,
        'Apr' => System.label.April,
        'May' => System.label.May,
        'Jun' => System.label.June,
        'Jul' => System.label.July,
        'Aug' => System.label.August,
        'Sep' => System.label.September,
        'Oct' => System.label.October,
        'Nov' => System.label.November,
        'Dec' => System.label.December
    }; 
    
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
    public static final map<String, Integer> MAP_MONTHVALUE = new map<String, Integer>{
        System.label.January => 4,
        System.label.February => 5,
        System.label.March => 6,
        System.label.April => 7,
        System.label.May => 8,
        System.label.June => 9,
        System.label.July => 10,
        System.label.August => 11,
        System.label.September => 12,
        System.label.October => 1,
        System.label.November => 2,
        System.label.December => 3
    };       
    public static final map<Integer, String> MAP_QUARTERLABEL = new map<Integer, String>{
        1 => System.label.Q1,
        2 => System.label.Q2,
        3 => System.label.Q3,
        4 => System.label.Q4
    };
    
    public static final map<String, Integer> MAP_QUARTERVALUE = new map<String, Integer>{
        System.label.Q1 => 1,
        System.label.Q2 => 2,
        System.label.Q3 => 3,
        System.label.Q4 => 4
    };   
    public static final map<Integer, String> MAP_QUARTER = new map<Integer, String>{
        1 => '1',
        2 => '2',
        3 => '3',
        4 => '4'
    };
 
    public static List<Period> list_fiscalYear; 
    public static List<Period> list_fiscalQuarter;
    public static List<Period> list_fiscalMonth;
    public static map<String, Map<String, Period>> map_fiscalyear_months;
    public static map<String, Map<String, Period>> map_fiscalyear_quarters;
    public static map<String, Decimal> map_isoCode_exchangeRate; 
    public static map<String, Decimal> map_convertionRate = new Map<String, Decimal>();
    public static map<Date, String> map_date_quarter = new map<Date, String>();
    public static map<Date, String> map_date_monthNum = new map<Date, String>();
    public static map<Id, Opportunity> map_oppyId_oppy;
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private static final String ACCOUNT_CM = 'CM';
    private static final String ACCOUNT_DISTRIBUTOR = 'Distributor';
    private static final String ACCOUNT_OEM = 'OEM';
    private static final string SPLIT_YEAR = '@@';
    private static final string SPLIT_OUTER = '#';
    private static final string SPLIT_INNER = ';';
    //add lili 2014.04.08 begin due to oppy Forecast approval 
    private static final Map<String, String> map_BU_IND = new Map<String, String>{
        'Rail' => 'IND',
        'A&C' => 'IND',
        'IB' => 'IND',
        'Solar' => 'IND'
    };
    private static final Map<String, String> map_BU_Appliances = new Map<String, String>{
        'Appliances' => 'Appliances',
        'EMS' => 'Appliances'
    };
    //add lili 2014.04.08 end due to oppy Forecast approval 
    public static String oppyYear;
    private static String saveYear;
    private static Map<String, String> map_fiscalYear_order;
    private static  set<String> set_Saveyears = new set<String>();
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
    public static void getAllFiscalYear(){
        if(list_fiscalYear == null){
            list_fiscalYear = new List<Period>();
            for(Period p: [select FiscalYearSettingsId, FiscalYearSettings.Name, PeriodLabel, Number, StartDate, EndDate from Period where type = 'Year' and FiscalYearSettings.IsStandardYear = false order by FiscalYearSettings.Name]){
                list_fiscalYear.add(p);
            }
        }
    }
    
    public static void getAllFiscalQuarter(){
        if(list_fiscalQuarter == null){
            list_fiscalQuarter = new List<Period>();
            for(Period p:  [select FiscalYearSettingsId, FiscalYearSettings.Name, Number, PeriodLabel, StartDate, EndDate from Period where type = 'Quarter']){
                list_fiscalQuarter.add(p);
            }
        }
    }    
    
    public static void getAllFiscalMonth(){
        if(list_fiscalMonth == null){
            list_fiscalMonth = new List<Period>();
            for(Period p: [select FiscalYearSettingsId, FiscalYearSettings.Name, Number, PeriodLabel, StartDate, EndDate from Period where type = 'Month' order by StartDate]){
                list_fiscalMonth.add(p);
            }
        }
    }      
  
    
    //06-12-2014 Michael Cui: added for Case 00677873: APL Oppty Part process status consolidation.
    public static set<Id> applianceOpptyRecordTypeId(){
        Set<Id> rt_id = new Set<Id>();
        if(Apex_Helper_Settings__c.getInstance('Appliance Opportunity Record Type Id') != null && Apex_Helper_Settings__c.getInstance('Appliance Opportunity Record Type Id').Active__c && Apex_Helper_Settings__c.getInstance('Appliance Opportunity Record Type Id').value__c != null)
        {
            string temp = Apex_Helper_Settings__c.getInstance('Appliance Opportunity Record Type Id').value__c;
            for(Id appId :temp.split(',')){
                rt_id.add(appId);
            }
        }
        
        return rt_id;
    }
    /**
    * The method is used to get the list of year
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              set of years, add fiscal year, the number of adding years
    *
    @return             list of years
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static list<String> getYearList(Set<String> set_forecastYears, Boolean addFiscalYear, Integer newYears){
        list<String> list_years = new list<String>();
        
        Set<String> set_tmp = new Set<String>();
        if(set_forecastYears != null && set_forecastYears.size() > 0){
            set_tmp.addAll(set_forecastYears);
        }
        if(addFiscalYear){
            Integer currentYear = system.today().year();
            
            for(Integer i = 0; i< newYears; i++){
                Integer year = currentYear + i;
                set_tmp.add(String.valueOf(year));
            }
        }
        if(set_tmp.size() > 0){
            list_years.addAll(set_tmp);  
            list_years.sort();
        }
        return list_years;      
    }
    
    /**
    * The method is used to get all year from period object
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param             
    *
    @return             set of years
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static Set<String> getAllPeriodYears(){
        Set<String> set_years = new Set<String>();
        getAllFiscalYear();
        for(Period p: list_fiscalYear){
            set_years.add(p.FiscalYearSettings.Name);
        }    
        return set_years;
    }
    
     /**
    * The method is used to create new structure of opportunity forecast
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param             map of partId and oppyId, list of partId, year, opportunityId, recordTypeId of opportunity,  recordTypeId of part, selected level
    *
    @return            structure of opportunity forecast
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static ClsOppForecastStructure createNewOppyForecastStructure(String year, Opportunity oppy, List<Id> list_partIds){
        ClsOppForecastStructure OppyForecastStructure = new ClsOppForecastStructure(year);
        // opportunity forecast
        ClsOppForecastStructure.ForecastStructure fs = new ClsOppForecastStructure.ForecastStructure();
        fs.totalQuantity = 0;
        fs.totalAmount = 0;
        Integer size = 4;
        if(oppy.Level__c == Monthly) size = 12;
        else if(oppy.Level__c == YEARLY) size = 1;
        for(Integer i = 0; i < size; i++){
            ClsOppForecastStructure.ForecastItemStructure fsItem = new ClsOppForecastStructure.ForecastItemStructure();
            fsItem.quantity = 0;
            fsItem.amount = 0;
            fs.editForecasts.add(fsItem);
        }
        OppyForecastStructure.forecastStructure = fs;
        // part forecast
        for(Id partId :list_partIds){
            ClsOppForecastStructure.PartForecastStructure pfs = new ClsOppForecastStructure.PartForecastStructure();
            pfs.partId = partId;
            pfs.totalQuantity = 0;
            pfs.totalAmount = 0;
            
            for(Integer i = 0; i < size; i++){
                pfs.quantitys.add(0);
            }
            OppyForecastStructure.partForecasts.add(pfs);
        } 
        return OppyForecastStructure;
    }
    
    /**     
    * The method is used to create new structure of opportunity forecast
    *
    @author Lili Zhao
    @created 2014-03-18
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param             map of partId and oppyId, list of partId, year, opportunityId, recordTypeId of opportunity,  recordTypeId of part, selected level
    *
    @return            structure of opportunity forecast
    *
    @changelog
    * 2014-03-18 Lili Zhao <bin.yu@itbconsult.com>
    * - Created
    */
    public static ClsOppForecastStructure createNewOppyForecastStructure(String year, Opportunity oppy, List<Id> list_partIds, map<Id, Decimal> map_partId_price){
        ClsOppForecastStructure OppyForecastStructure = new ClsOppForecastStructure(year);
        // opportunity forecast
        ClsOppForecastStructure.ForecastStructure fs = new ClsOppForecastStructure.ForecastStructure();
        fs.totalQuantity = 0;
        fs.totalAmount = 0;
        Integer size = 4;
        if(oppy.Level__c == Monthly) size = 12;
        else if(oppy.Level__c == YEARLY) size = 1;
        for(Integer i = 0; i < size; i++){
            ClsOppForecastStructure.ForecastItemStructure fsItem = new ClsOppForecastStructure.ForecastItemStructure();
            fsItem.quantity = 0;
            fsItem.amount = 0;
            fs.editForecasts.add(fsItem);
        }
        OppyForecastStructure.forecastStructure = fs;
        // part forecast
        for(Id partId :list_partIds){
            ClsOppForecastStructure.PartForecastStructure pfs = new ClsOppForecastStructure.PartForecastStructure();
            pfs.partId = partId;
            pfs.totalQuantity = 0;
            pfs.totalAmount = 0;
            // added lili zhao 2014.03.18 begin due to add the salesprice as the AverageSellPrice__c 
            if(map_partId_price.containsKey(partId)) pfs.salesPrice = map_partId_price.get(partId);
            // added lili zhao 2014.03.18 end due to add the salesprice as the AverageSellPrice__c 
            for(Integer i = 0; i < size; i++){
                pfs.quantitys.add(0);
            }
            OppyForecastStructure.partForecasts.add(pfs);
        } 
        return OppyForecastStructure;
    }
    
    /**
    * The method is used to get the fiscal years in map
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param             
    *
    @return             map of fiscal years
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static void getFiscalYearMonthMap(){
        if(map_fiscalyear_months == null){
            map_fiscalyear_months = new map<String, Map<String, Period>>();
            getAllFiscalMonth();
            for(Period p : list_fiscalMonth){
                if(!map_fiscalyear_months.containsKey(p.FiscalYearSettings.Name)){
                    map_fiscalyear_months.put(p.FiscalYearSettings.Name, new Map<String, Period>());
                }
                map_fiscalyear_months.get(p.FiscalYearSettings.Name).put(String.valueOf(p.PeriodLabel), p);
            }
            //system.debug('tongxia map_fiscalyear_months 2:' + map_fiscalyear_months);
        } 
    }
    
     /**
    * The method is used to get the start date of specified month in the specified year
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              year, month
    *
    @return             the start date of specified month in the specified year
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static Date getFiscalMonthStartDate(String year, String month){
       // system.debug('tongxia map_fiscalyear_months: ' + map_fiscalyear_months);
        getFiscalYearMonthMap();
        //system.debug('tongxia map_fiscalyear_months: ' + map_fiscalyear_months);
        if(map_fiscalyear_months.containsKey(year) && map_fiscalyear_months.get(year).containsKey(month)){
            return map_fiscalyear_months.get(year).get(month).StartDate;
        }
        return null;
    }
    
     /**
    * The method is used to get the opportunity object with the specified opportunity id
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param             opportunity id
    *
    @return             opportunity object
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static Opportunity getOpportunityById(Id oppyId){
        Opportunity opportunity = new Opportunity();
        opportunity = [Select PLM_Id__c ,Email_Send__c,PLM_Created_By_Id__c, Industry_Code__c, CloseDate, IsClosed, AccountId, 
                              Manufacturing_Start_Date__c, Id, Name, stageName, RecordTypeId, Program__c, IsWon, Opportunity_Forecast_Recalculation__c, 
                              Program__r.Program_level_Forecasting__c, Amount, Five_Year_Revenue__c, Method__c,Active_Opportunity_Parts__c,Record_Type_Name__c,
                              CurrencyIsoCode, Level__c, Competitor_Count__c, NDR_Quote_Status_Description__c, Approval_Status_PMV__c ,Probability,CreatedDate
                       From Opportunity 
                       Where Id = :oppyId]; 
        return opportunity;  
    }
    
     /**
    * The method is used to get the quarter of fiscal year in map
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param             
    *
    @return             the quarters of fiscal year
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static void getFiscalYearQuarterMap(){
        if(map_fiscalyear_quarters == null){
            map_fiscalyear_quarters = new map<String, map<String, Period>>();
            getAllFiscalQuarter();
            for(Period p : list_fiscalQuarter){
                if(!map_fiscalyear_quarters.containsKey(p.FiscalYearSettings.Name)){
                    map_fiscalyear_quarters.put(p.FiscalYearSettings.Name, new Map<String, Period>());
                }
                map_fiscalyear_quarters.get(p.FiscalYearSettings.Name).put(String.valueOf(p.Number), p);
            }
        }
    }
    
    /**
    * The method is used to get the start date of the specified quarter in the specified year
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              year, quarter
    *
    @return             the start date of the specified quarter in the specified year
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
     public static Date getFiscalQuarterStartDate(String year, String quarter){
        getFiscalYearQuarterMap();
        
        if(map_fiscalyear_quarters.containsKey(year) && map_fiscalyear_quarters.get(year).containsKey(quarter)){
            return map_fiscalyear_quarters.get(year).get(quarter).StartDate;
        }
        return null;
    }
    
    /**
    * The method is used to get the opportunity forcasts in every opportunities, parts and years
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param             the set of opportunity ids
    *
    @return            the opportunity forcasts in every opportunities, parts and years
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    // get the opportunites in every years
    public static Map<String, Map<Id, Map<Id, List<Opportunity_Forecast__c>>>> getOppyYearMap(Set<Id> set_oppyIds){
        Map<String, Map<Id, Map<Id, List<Opportunity_Forecast__c>>>> map_year_oppyId_partId_forecasts = new Map<String, Map<Id, Map<Id, List<Opportunity_Forecast__c>>>>();
        Set<Id> set_partIds = new Set<Id>();
        List<Opportunity_Part__c> list_parts = new List<Opportunity_Part__c>();
        // get year
        List<Period> list_period = [select FiscalYearSettingsId, FiscalYearSettings.Name, PeriodLabel, Number, StartDate, EndDate from Period where type = 'Year' order by FiscalYearSettings.Name];
        // get parts according to opportunities
        for(Opportunity_Part__c part: [select Id, Opportunity__c from Opportunity_Part__c where Opportunity__c in :set_oppyIds order by Name]){
            set_partIds.add(part.Id);
            list_parts.add(part);   
        }
        // get forecasts according to opportunies and parts
        List<Opportunity_Forecast__c> list_forecasts = [select Id, Name, RecordTypeId, Date__c, Sales_Price__c, Quantity__c, Amount__c, Opportunity__c, Part__c from Opportunity_Forecast__c where Opportunity__c in :set_oppyIds and Part__c in :set_partIds and Date__c != null];
        
        if(!list_forecasts.isEmpty() && !list_period.isEmpty()){
            for(Opportunity_Forecast__c forecast: list_forecasts){        
                for(Period p: list_period){
                    if(forecast.Date__c >= p.StartDate && forecast.Date__c <= p.EndDate){
                        if(!map_year_oppyId_partId_forecasts.containsKey(p.FiscalYearSettings.Name)){
                            map_year_oppyId_partId_forecasts.put(p.FiscalYearSettings.Name, new Map<Id, Map<Id, List<Opportunity_Forecast__c>>>());
                        }
                        if(!map_year_oppyId_partId_forecasts.get(p.FiscalYearSettings.Name).containsKey(forecast.Opportunity__c)) {
                            map_year_oppyId_partId_forecasts.get(p.FiscalYearSettings.Name).put(forecast.Opportunity__c, new Map<Id, List<Opportunity_Forecast__c>>());
                        }
                        if(!map_year_oppyId_partId_forecasts.get(p.FiscalYearSettings.Name).get(forecast.Opportunity__c).containsKey(forecast.Part__c)){
                            map_year_oppyId_partId_forecasts.get(p.FiscalYearSettings.Name).get(forecast.Opportunity__c).put(forecast.Part__c, new List<Opportunity_Forecast__c>());
                        }
                        map_year_oppyId_partId_forecasts.get(p.FiscalYearSettings.Name).get(forecast.Opportunity__c).get(forecast.Part__c).add(forecast); 
                        break;                                  
                    }       
                }               
            }
        }        
        
        return map_year_oppyId_partId_forecasts;
    }
    
    /**
    * The method is used to get the labels of the specified level
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param             level
    *
    @return            the labels of the specified level
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
     public static List<String> getLevelLabel(String level){
        List<String> list_labels = new List<String>();
        if(level == ClsOppyUtil.MONTHLY){
            for(Integer i=1; i<=12; i++){
                list_labels.add(ClsOppyUtil.MAP_MONTHLABEL.get(MAP_MONTH.get(i)));
            }
        }
        else if(level == ClsOppyUtil.QUARTERLY){
            for(Integer i=1; i<=4; i++){
                list_labels.add(ClsOppyUtil.MAP_QUARTERLABEL.get(i));
            }
        }
         else if(level == ClsOppyUtil.YEARLY){
            list_labels.add('year');
         }
         return list_labels;
     }
     
     /**
    * The method is used to get the forecast level
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param             
    *
    @return            the forecast level(yearly, quarterly, monthly)
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
     public static List<SelectOption> getForecastLevel(){
         List<SelectOption> list_forecastLevel = new List<SelectOption>();
         list_forecastLevel.add(new SelectOption(ClsOppyUtil.YEARLY, ClsOppyUtil.YEARLY));
         list_forecastLevel.add(new SelectOption(ClsOppyUtil.QUARTERLY, ClsOppyUtil.QUARTERLY));
         list_forecastLevel.add(new SelectOption(ClsOppyUtil.MONTHLY, ClsOppyUtil.MONTHLY));
      
         return list_forecastLevel;
     }
     
      /**
    * The method is used to get the available numbers for adding years
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param             
    *
    @return            the available numbers for adding years
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
     public static List<SelectOption> getYearNumber(){
         List<SelectOption> list_yearNumber = new List<SelectOption>();
         list_yearNumber.add(new SelectOption('1', '1'));
         list_yearNumber.add(new SelectOption('2', '2'));
         list_yearNumber.add(new SelectOption('3', '3'));
         list_yearNumber.add(new SelectOption('4', '4'));
         list_yearNumber.add(new SelectOption('5', '5'));
          
         return list_yearNumber;
     }
     
       /**
    * The method is used to get the other years to select
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param             
    *
    @return            the available other years
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
     public static List<SelectOption> getOtherYears(List<String> list_years){
         List<SelectOption> list_otherYears = new List<SelectOption>();
         system.debug('list_years: ' + list_years);
         set<String> set_years = new set<String>();
         for(String y :list_years){
             set_years.add(y);        
         } 
         
         list_otherYears.add(new SelectOption(System.label.None_Value, System.label.None_Value));
         getAllFiscalYear();
         String currentYear = getForecastYear(system.today());
         for(Period p :list_fiscalYear){
            Boolean hasYear = false;
            if(set_years.size() > 0 && set_years.contains(p.FiscalYearSettings.Name)) hasYear = true;
            /*
            for(String year: list_years){
                if(p.FiscalYearSettings.Name == year){
                    hasYear = true;
                    break;
                }
            }
            */
            if(!hasYear && p.FiscalYearSettings.Name >= currentYear){
                list_otherYears.add(new SelectOption(p.FiscalYearSettings.Name, p.FiscalYearSettings.Name));
            }
         }
         system.debug('list_otherYears: ' + list_otherYears); 
         return list_otherYears;
     }
         
    /**
    * The method is used to get the month according to the specified date
    *
    @author Min Liu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              the forecast date
    *
    @return             month
    *
    @changelog
    * 2012-03-01 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public static String getForecastMonth(Date inputDate){
        String month = '';
        getAllFiscalMonth();
        if(inputDate != null){
            for(Period p: list_fiscalMonth){                
                if(inputDate >= p.StartDate && inputDate <= p.EndDate){
                    if(MAP_MONTHLABEL.containsKey(p.PeriodLabel)){
                        month = MAP_MONTHLABEL.get(p.PeriodLabel);
                        break;
                    }
                }
            }           
        }
        return month;
    }
    
    public static Integer getForecastFisMonth(Date inputDate){
        Integer month;
        getAllFiscalMonth();
        if(inputDate != null){
            for(Period p: list_fiscalMonth){                
                if(inputDate >= p.StartDate && inputDate <= p.EndDate){
                    if(MAP_MONTHLABELNUMBER.containsKey(p.PeriodLabel)){
                        month = MAP_MONTHLABELNUMBER.get(p.PeriodLabel);
                        break;
                    }
                }
            }           
        }
        return month;
    }
    
    /**
    * The method is used to get the quarter according to the specified date
    *
    @author Min Liu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              the forecast date
    *
    @return             quarter
    *
    @changelog   
    * 2012-03-01 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public static String getForecastQuarter(Date inputDate){
        String quarter = '';
        if(inputDate != null){
            if(map_date_quarter.containsKey(inputDate)){ 
                return map_date_quarter.get(inputDate);
            }
            else{
                getAllFiscalQuarter();
                //system.debug('map_date_quarter: ' + map_date_quarter);
                //system.debug('inputDate: ' + inputDate);
                for(Period p: list_fiscalQuarter){              
                    if(inputDate >= p.StartDate && inputDate <= p.EndDate){
                        if(MAP_QUARTER.containsKey(p.Number)){
                            quarter = MAP_QUARTER.get(p.Number);
                            map_date_quarter.put(inputDate, quarter);
                            break;
                        } 
                    }
                } 
            }          
            
        }
        return quarter;
    }
    
    /**
    * The method is used to get the year according to the specified date
    *
    @author Min Liu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              the forecast date
    *
    @return             year
    *
    @changelog
    * 2012-03-01 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public static String getForecastYear(Date inputDate){
        String year = '';
        getAllFiscalYear();
        if(inputDate != null){
            for(Period p: list_fiscalYear){   
                if(inputDate >= p.StartDate && inputDate <= p.EndDate){
                    year = p.FiscalYearSettings.Name;
                    break;
                }
            } 
        }          
        return year;
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
           
   /**
    * The method is used to get the part ids of the specified opportunity ids
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param             set of opportunity ids
    *
    @return            the part ids of the specified opportunity ids
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static List<Id> getPartIdsByOppyId(Set<Id> set_oppyIds){
        list<Id> list_partIds = new List<Id>();
        for(Opportunity_Part__c part : [select Id, Opportunity__c from Opportunity_Part__c where Opportunity__c in :set_oppyIds order by Name]){      
            list_partIds.add(part.Id);
        }
        return list_partIds;
    }
    
      /**
    * The method is used to get the part objects of the specified opportunity ids
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param             set of opportunity ids
    *
    @return            the part objects of the specified opportunity ids
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    * 
    * 
    @changelog
    * 2015-06-01 Prabhanjan Nandyala <prabhanjan.nandyala@zensar.in> , adding one more field, Available_for_TAM__c, for the query. TEam up req: 
    * 2015-06-09 Prabhanjan Nandyala <prabhanjan.nandyala@zensar.in> , adding one more field, won_reason__c.
    */
    public static List<Opportunity_Part__c> getPartsByOppyId(Set<Id> set_oppyIds){
        list<Opportunity_Part__c> list_parts = new List<Opportunity_Part__c>();
        
        String sql_query = 'Select CurrencyIsoCode,AverageSellPrice__c,Available_for_TAM__c,ADM_TE_Shipset_Percentage__c, won_reason__c, Id, Part_Name__c, Opportunity__c, Opportunity__r.Name, Opportunity__r.StageName,' +  //
                                'Quantity__c, Status__c, Process_Status__c, Lost_Reason__c,Lost_Reason_Text__c, Competitor__c, Similar_TE_Part_Number__r.Name,'+// Won_Date__c,' + //
                                ' GPL__c, Part__r.Name, New_Part_Description__c, RecordType.Name, initial_billing_date__c, Initial_Order_Date__c ' + //
                            'From Opportunity_Part__c  ' + //
                            'Where Opportunity__c in :set_oppyIds order by Name';
        
        for(Opportunity_Part__c part : Database.query(sql_query)){      
            list_parts.add(part);
        }
        return list_parts;
    }


        
      /**
    * The method is used to get the forecasts of the specified opportunity id in map
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param             opportunity id
    *
    @return            the forecasts of the specified opportunity id in map
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */    
    public static Map<String, List<Opportunity_Forecast__c>> buildOppyForeCastMap(Id oppyId){
        List<Opportunity_Forecast__c> list_forecasts = new List<Opportunity_Forecast__c>();
        for(Opportunity_Forecast__c ofc : [select Id, RecordTypeId, Fiscal_Year__c, Date__c, Sales_Price__c, Quantity__c, Amount__c, Opportunity__c, Part__c,Part__r.Status__c, Forecasting_Start_Date__c from Opportunity_Forecast__c where Opportunity__c = :oppyId and Part__c = null and Date__c != null order by Date__c ]){
            list_forecasts.add(ofc);
        }
        Map<String, List<Opportunity_Forecast__c>> map_oppyForeCasts = buildOppyForeCastMapByYear(list_forecasts);      
        return map_oppyForeCasts;
    }
    
      /**
    * The method is used to get the opportunity objects of the specified program id
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion) 
    *
    @param             program id
    *
    @return            the opportunity objects of the specified program id
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */   
    public static Map<Id, Opportunity> getOpportunitysByProgramId(Id oppyId){
        Map<Id, Opportunity> map_id_opportunity = new Map<Id, Opportunity>();
        for(Opportunity oppy : [select Id, Five_Year_Value__c, Total_Opportunity_Value__c,CloseDate,Manufacturing_Start_Date__c, Name, Program__c, Amount, Five_Year_Revenue__c, Method__c, CurrencyIsoCode, Level__c, stageName, Competitor_Count__c from Opportunity where Program__c = :oppyId]){
            map_id_opportunity.put(oppy.Id, oppy);
        }   
        return map_id_opportunity;
    }
    
      /**
    * The method is used to get the status select options
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param             
    *
    @return            the status select options
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static List<SelectOption> getStatusItems(){
        List<SelectOption> list_status = new List<SelectOption>();
        Schema.DescribeFieldResult desResult = Opportunity_Part__c.Status__c.getDescribe();
        for(Schema.PicklistEntry pri : desResult.getPicklistValues()){
            list_status.add(new SelectOption(pri.getValue(), pri.getLabel())); 
        }
        return list_status;
    }
    
      /**
    * The method is used to get all parts of the specified program id
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param             program id
    *
    @return            all parts of the specified program id
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static List<Opportunity_Part__c> getAllPartsByProgramId(Id oppyId){
        List<Opportunity_Part__c> list_allParts = new List<Opportunity_Part__c>();
        for(Opportunity_Part__c part : [select CurrencyIsoCode,Available_for_TAM__c,ADM_TE_Shipset_Percentage__c,won_reason__c, AverageSellPrice__c, Id, Part_Name__c, Opportunity__c, Opportunity__r.Name, Opportunity__r.StageName, Quantity__c, Status__c, Process_Status__c, Won_Date__c, Lost_Reason__c,Lost_Reason_Text__c, Competitor__c, Similar_TE_Part_Number__r.Name, GPL__c, Part__r.Name, New_Part_Description__c, RecordType.Name from Opportunity_Part__c where Opportunity__r.Program__c = :oppyId order by Opportunity__r.Name, Name]){
            list_allParts.add(part);
        }           
        return list_allParts;
    }
    
      /**
    * The method is used to get the forecasts of the specified opportunity ids
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param             set of opportunity ids
    *
    @return            the forecasts of the specified opportunity ids
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static Map<String, Map<Id, List<Opportunity_Forecast__c>>> getOppyForeCastMap(set<Id> set_oppyIds){
        Map<String, Map<Id, List<Opportunity_Forecast__c>>> map_forecasts = new Map<String, Map<Id, List<Opportunity_Forecast__c>>>();
        for(Opportunity_Forecast__c ofc : [select Id, Date__c, Fiscal_Year__c, Sales_Price__c, Quantity__c, Amount__c, Opportunity__c from Opportunity_Forecast__c where Opportunity__c in :set_oppyIds and Part__c = null and Date__c != null]){
            String year = ofc.Fiscal_Year__c;
            if(year == null){
                year = String.valueOf(ofc.Date__c.Year());
            }
            
            if(!map_forecasts.containsKey(year)){
                Map<Id, List<Opportunity_Forecast__c>> map_tmp = new Map<Id, List<Opportunity_Forecast__c>>();
                map_forecasts.put(year, map_tmp);
            }
        
            if(!map_forecasts.get(year).containsKey(ofc.Opportunity__c)){
                map_forecasts.get(year).put(ofc.Opportunity__c, new List<Opportunity_Forecast__c>{});
            }       
            map_forecasts.get(year).get(ofc.Opportunity__c).add(ofc);
        }   
        return map_forecasts;
    }
    
      /**
    * The method is used to get the forecasts of every parts of the specified opportunity id
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param             opportunity id
    *
    @return            the forecasts of every parts of the specified opportunity id
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static Map<String, Map<Id, List<Opportunity_Forecast__c>>> buildAllPartForeCastMap(Id oppyId){
        Map<String, Map<Id, List<Opportunity_Forecast__c>>> map_forecasts = new Map<String, Map<Id, List<Opportunity_Forecast__c>>>();
        for(Opportunity_Forecast__c ofc : [select Id, Date__c, Fiscal_Year__c, Sales_Price__c, Quantity__c, Amount__c, Opportunity__c, Part__c, Forecasting_Start_Date__c from Opportunity_Forecast__c where Opportunity__c = :oppyId and Part__c != null and Date__c != null order by Part__r.Name, Date__c]){
            String year = ofc.Fiscal_Year__c;
            if(year == null){
                year = String.valueOf(ofc.Date__c.Year());
            }
            
            if(!map_forecasts.containsKey(year)){
                Map<Id, List<Opportunity_Forecast__c>> map_tmp = new Map<Id, List<Opportunity_Forecast__c>>();
                map_forecasts.put(year, map_tmp);
            }
        
            if(!map_forecasts.get(year).containsKey(ofc.Part__c)){
                map_forecasts.get(year).put(ofc.Part__c, new List<Opportunity_Forecast__c>{});
            }
            map_forecasts.get(year).get(ofc.Part__c).add(ofc);
        }   
        return map_forecasts;
    }
    
      /**
    * The method is used to get the forecasts of every parts of the specified program id
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param             program id
    *
    @return            the forecasts of every parts of the specified program id
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static Map<String, Map<Id, List<Opportunity_Forecast__c>>> buildProgramAllPartForeCastMap(Id oppyId){
        Map<String, Map<Id, List<Opportunity_Forecast__c>>> map_forecasts = new Map<String, Map<Id, List<Opportunity_Forecast__c>>>();
        for(Opportunity_Forecast__c ofc : [select Id, Name, RecordTypeId, Date__c, Fiscal_Year__c, Sales_Price__c, Quantity__c, Amount__c, Opportunity__c, Part__c, Forecasting_Start_Date__c from Opportunity_Forecast__c where Opportunity__r.Program__c = :oppyId and Part__c != null and Date__c != null order by Part__r.Name,Date__c]){
            String year = ofc.Fiscal_Year__c;
            if(year == null){
                year = String.valueOf(ofc.Date__c.Year());
            }
            
            if(!map_forecasts.containsKey(year)){
                Map<Id, List<Opportunity_Forecast__c>> map_tmp = new Map<Id, List<Opportunity_Forecast__c>>();
                map_forecasts.put(year, map_tmp);
            }
        
            if(!map_forecasts.get(year).containsKey(ofc.Part__c)){
                map_forecasts.get(year).put(ofc.Part__c, new List<Opportunity_Forecast__c>{});
            }       
            map_forecasts.get(year).get(ofc.Part__c).add(ofc);
        }   
        return map_forecasts;
    }

    public static Map<String, Map<Id, List<Opportunity_Forecast__c>>> buildOppyAllPartForeCastMap(Id oppyId){
        Map<String, Map<Id, List<Opportunity_Forecast__c>>> map_forecasts = new Map<String, Map<Id, List<Opportunity_Forecast__c>>>();
        for(Opportunity_Forecast__c ofc : [select Id, Date__c,Part__c, Fiscal_Year__c, Sales_Price__c, Quantity__c from Opportunity_Forecast__c where Opportunity__c = :oppyId and Part__c != null and Date__c != null order by Part__r.Name]){
            String year = ofc.Fiscal_Year__c;
            if(year == null){
                year = String.valueOf(ofc.Date__c.Year());
            }
            
            if(!map_forecasts.containsKey(year)){
                Map<Id, List<Opportunity_Forecast__c>> map_tmp = new Map<Id, List<Opportunity_Forecast__c>>();
                map_forecasts.put(year, map_tmp);
            }
        
            if(!map_forecasts.get(year).containsKey(ofc.Part__c)){
                map_forecasts.get(year).put(ofc.Part__c, new List<Opportunity_Forecast__c>{});
            }       
            map_forecasts.get(year).get(ofc.Part__c).add(ofc);
        }   
        return map_forecasts;
    }
        
      /**
    * The method is used to get the forecasts according to years in map
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param             specified forecasts
    *
    @return            the forecasts according to years in map
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static Map<String, List<Opportunity_Forecast__c>> buildOppyForeCastMapByYear(List<Opportunity_Forecast__c> list_forecasts){
        Map<String, List<Opportunity_Forecast__c>> map_oppyForeCasts = new Map<String, List<Opportunity_Forecast__c>>();
        for(Opportunity_Forecast__c ofc : list_forecasts){
            String year = ofc.Fiscal_Year__c;
            if(year == null){
                year = String.valueOf(ofc.Date__c.Year());
            }
            
            if(!map_oppyForeCasts.containsKey(year)){
                map_oppyForeCasts.put(year, new List<Opportunity_Forecast__c>{});
            }
            map_oppyForeCasts.get(year).add(ofc);
        }
        return map_oppyForeCasts;
    }
    
      
    /**
    * The method is used to get the month according to the specified date
    *
    @author Min Liu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              the forecast date
    *
    @return             month
    *
    @changelog
    * 2012-03-01 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public static String getForecastMonthNum(Date inputDate){
        String month = '';
        if(map_date_monthNum.containsKey(inputDate)){
            return map_date_monthNum.get(inputDate);
        }
        getAllFiscalMonth();
        if(inputDate != null){
            for(Period p: list_fiscalMonth){                
                if(inputDate >= p.StartDate && inputDate <= p.EndDate){
                    if(MAP_MONTHLABELNUMBER.containsKey(p.PeriodLabel)){
                        month = String.valueOf(MAP_MONTHLABELNUMBER.get(p.PeriodLabel));
                        map_date_monthNum.put(inputDate, month);
                        break;
                    }
                }
            }           
        }
        return month; 
    }
    
    public static List<Opportunity_Forecast__c> createForcasts(Opportunity oppy, Id recordTypeId, List<Decimal> quantities, Decimal sp, Opportunity_Part__c part, String year, Map<Id, String> map_oppyPartId_isoCode, Map<Id, Id> map_partId_oppyId, Map<Integer, Decimal> map_date_amount, Map<Integer, Decimal> map_date_amount_Cust){
        system.debug('createForcasts Quantiry ::: ' + String.valueOf(quantities));
        List<Opportunity_Forecast__c> list_new = new List<Opportunity_Forecast__c>();
        Map<String, Decimal> map_currency_rate = new Map<String, Decimal>();
        Map<Integer, String> map_int_counter = new Map<Integer, String>();
        // added lili 2014.03.20 begin add the field Fiscal_Month__c
        Map<Integer, String> map_intMonth_strMonth = new Map<Integer, String>();
        map_intMonth_strMonth.put(1,'01');
        map_intMonth_strMonth.put(2,'02');
        map_intMonth_strMonth.put(3,'03');
        map_intMonth_strMonth.put(4,'04');
        map_intMonth_strMonth.put(5,'05');
        map_intMonth_strMonth.put(6,'06');
        map_intMonth_strMonth.put(7,'07');
        map_intMonth_strMonth.put(8,'08');
        map_intMonth_strMonth.put(9,'09');
        map_intMonth_strMonth.put(10,'10');
        map_intMonth_strMonth.put(11,'11');
        map_intMonth_strMonth.put(12,'12');
        // added lili 2014.03.20 end add the field Fiscal_Month__c
        if(oppy.level__c == ClsOppyForecastUtil.MONTHLY){
            map_int_counter.put(1,'1');
            map_int_counter.put(2,'1');
            map_int_counter.put(3,'1');
            map_int_counter.put(4,'2');
            map_int_counter.put(5,'2');
            map_int_counter.put(6,'2');
            map_int_counter.put(7,'3');
            map_int_counter.put(8,'3');
            map_int_counter.put(9,'3');
            map_int_counter.put(10,'4');
            map_int_counter.put(11,'4');
            map_int_counter.put(12,'4');            
        }
        
        // change currency of sale price
        String partCurrencyIsoCode;
        Id pid;
        if(part != null) pid = part.id;
        if(pid != null) partCurrencyIsoCode = map_oppyPartId_isoCode.get(pid);
        else partCurrencyIsoCode = oppy.CurrencyIsoCode;
        if(partCurrencyIsoCode != oppy.CurrencyIsoCode){
            sp = transformIsoCode(sp, oppy.CurrencyIsoCode, partCurrencyIsoCode);
        }
                
        if(oppy.level__c == ClsOppyForecastUtil.MONTHLY){
            
            for(integer i=1; i <= 12; i++){                         
                Opportunity_Forecast__c fc = new Opportunity_Forecast__c();             
                fc.Part__c = pid;
                fc.Quantity__c = quantities.get(i-1);
                fc.RecordTypeId = recordTypeId;
                if(pid == null) {
                    fc.Opportunity__c = oppy.Id;                    
                    if(map_date_amount.containsKey(i)) fc.Amount__c = map_date_amount.get(i);
                    if(map_date_amount_Cust.containsKey(i)) fc.Five_Year_Amount__c= map_date_amount_Cust.get(i);                    
                }
                else {
                    fc.Opportunity__c = map_partId_oppyId.get(pid);
                    fc.Sales_Price__c = sp;
                    fc.Amount__c = fc.Quantity__c * sp;
                    fc.Five_Year_Amount__c= fc.Quantity__c * sp;
                    
                    if(!map_date_amount.containsKey(i)) map_date_amount.put(i, 0);
                    if(!map_date_amount_Cust.containsKey(i)) map_date_amount_Cust.put(i, 0);
                                      
                    // add amount if part status is NOT dead and lost
                    if(part.Status__c != 'Dead' && part.Status__c != 'Lost'){
                        Decimal tmp = map_date_amount.get(i);
                        if(partCurrencyIsoCode != oppy.CurrencyIsoCode) tmp = tmp + transformIsoCode(fc.Amount__c, partCurrencyIsoCode, oppy.CurrencyIsoCode);
                        else tmp += fc.Amount__c;
                        map_date_amount.put(i, tmp);
                    }  
                    Decimal tmp_Cust = map_date_amount_Cust.get(i);
                    if(partCurrencyIsoCode != oppy.CurrencyIsoCode) tmp_Cust = tmp_Cust + transformIsoCode(fc.Five_Year_Amount__c, partCurrencyIsoCode, oppy.CurrencyIsoCode);
                    else tmp_Cust += fc.Five_Year_Amount__c;
                    map_date_amount_Cust.put(i, tmp_Cust);                 
                }
                
                fc.Date__c = getFiscalMonthStartDate(year, MAP_MONTH.get(i));
                fc.CurrencyIsoCode = partCurrencyIsoCode;
                fc.Fiscal_Year__c = year;                           
                fc.Fiscal_Quarter__c = '0' + map_int_counter.get(i);
                // added lili 2014.03.19 begin due to add the field Fiscal_Month__c,modify by lili zhao due to set Fiscal_Month__c as i ,not Date__c
                //fc.Fiscal_Month__c = map_intMonth_strMonth.get(fc.Date__c.month());
                fc.Fiscal_Month__c = map_intMonth_strMonth.get(MAP_MONTHLABELNUMBER.get(MAP_MONTH.get(i)));
                // added lili 2014.03.19 end
                list_new.add(fc);
            }
        }
        else if(oppy.level__c == ClsOppyForecastUtil.QUARTERLY){
            for(integer i=1; i <= 4; i++){                      
                Opportunity_Forecast__c fc = new Opportunity_Forecast__c();
                
                fc.Part__c = pid;
                fc.Quantity__c = quantities.get(i-1);
                fc.RecordTypeId = recordTypeId;
                if(pid == null) {
                    fc.Opportunity__c = oppy.Id;
                    if(map_date_amount.containsKey(i)) fc.Amount__c = map_date_amount.get(i);
                    if(map_date_amount_Cust.containsKey(i)) fc.Five_Year_Amount__c= map_date_amount_Cust.get(i);
                }
                else {
                    fc.Opportunity__c = map_partId_oppyId.get(pid);
                    fc.Sales_Price__c = sp;
                    fc.Amount__c = fc.Quantity__c * sp;
                    fc.Five_Year_Amount__c=fc.Quantity__c * sp;
                   
                    if(!map_date_amount.containsKey(i)) map_date_amount.put(i, 0);
                    if(!map_date_amount_Cust.containsKey(i)) map_date_amount_Cust.put(i, 0);
                                      
                    // add amount if part status is NOT dead and lost
                    if(part.Status__c != 'Dead' && part.Status__c != 'Lost'){
                        Decimal tmp = map_date_amount.get(i);
                        if(partCurrencyIsoCode != oppy.CurrencyIsoCode) tmp = tmp + transformIsoCode(fc.Amount__c, partCurrencyIsoCode, oppy.CurrencyIsoCode);
                        else tmp += fc.Amount__c;
                        map_date_amount.put(i, tmp);
                    }
                    Decimal tmp_Cust = map_date_amount_Cust.get(i);
                    if(partCurrencyIsoCode != oppy.CurrencyIsoCode) tmp_Cust = tmp_Cust + transformIsoCode(fc.Five_Year_Amount__c, partCurrencyIsoCode, oppy.CurrencyIsoCode);
                    else tmp_Cust += fc.Five_Year_Amount__c;
                    map_date_amount_Cust.put(i, tmp_Cust);
                }
                
                fc.Date__c = getFiscalQuarterStartDate(year, String.valueOf(i));
                fc.CurrencyIsoCode = partCurrencyIsoCode;
                fc.Fiscal_Year__c = year;                           
                fc.Fiscal_Quarter__c = '0' + String.valueOf(i);
                // added lili 2014.03.19 begin  **due to add the field Fiscal_Month__c,modify by lili zhao due to set Fiscal_Month__c as i ,not Date__c of oppyforecast
                //fc.Fiscal_Month__c = map_intMonth_strMonth.get(fc.Date__c.month());
                fc.Fiscal_Month__c = map_intMonth_strMonth.get(MAP_MONTHLABELNUMBER.get(MAP_QUARTERYear.get(i)));
                // added lili 2014.03.19 end
                list_new.add(fc);
            }                       
        }
        else{
            Integer quantityVal_q = (Integer) math.floor(quantities.get(0));
            Integer quanVal_q = (Integer) math.floor(quantityVal_q / 4);
            Integer counter = math.mod(quantityVal_q, 4);
            
            for(integer i=1; i <= 4; i++){                          
                Opportunity_Forecast__c fc = new Opportunity_Forecast__c();             
                fc.Part__c = pid;
                fc.Quantity__c = quanVal_q;
                if(counter > 0){
                    fc.Quantity__c += 1;
                    counter--;
                }
                fc.RecordTypeId = recordTypeId;
                if(pid == null) {
                    fc.Opportunity__c = oppy.Id;
                    if(map_date_amount.containsKey(i)) fc.Amount__c = map_date_amount.get(i);
                    if(map_date_amount_Cust.containsKey(i)) fc.Five_Year_Amount__c= map_date_amount_Cust.get(i);
                    
                }
                else {
                    fc.Opportunity__c = map_partId_oppyId.get(pid);
                    fc.Sales_Price__c = sp;
                    fc.Amount__c = fc.Quantity__c * sp;
                    fc.Five_Year_Amount__c= fc.Quantity__c * sp;
                    
                    if(!map_date_amount.containsKey(i)) map_date_amount.put(i, 0); 
                    if(!map_date_amount_Cust.containsKey(i)) map_date_amount_Cust.put(i, 0); 
                                     
                    // add amount if part status is NOT dead and lost
                    if(part.Status__c != 'Dead' && part.Status__c != 'Lost'){
                        Decimal tmp = map_date_amount.get(i);
                        if(partCurrencyIsoCode != oppy.CurrencyIsoCode) tmp = tmp + transformIsoCode(fc.Amount__c, partCurrencyIsoCode, oppy.CurrencyIsoCode);
                        else tmp += fc.Amount__c;
                        map_date_amount.put(i, tmp);
                    }
                    Decimal tmp_Cust = map_date_amount_Cust.get(i);
                    if(partCurrencyIsoCode != oppy.CurrencyIsoCode) tmp_Cust = tmp_Cust + transformIsoCode(fc.Five_Year_Amount__c, partCurrencyIsoCode, oppy.CurrencyIsoCode);
                    else tmp_Cust += fc.Five_Year_Amount__c;
                    map_date_amount_Cust.put(i, tmp_Cust);
                }
                
                fc.Date__c = getFiscalQuarterStartDate(year, String.valueOf(i));
                fc.CurrencyIsoCode = partCurrencyIsoCode;
                fc.Fiscal_Year__c = year;                           
                fc.Fiscal_Quarter__c = '0' + String.valueOf(i);
                // added lili 2014.03.19 begin ** due to add the field Fiscal_Month__c,modify by lili zhao due to set Fiscal_Month__c as i ,not Date__c of oppyforecast
                //fc.Fiscal_Month__c = map_intMonth_strMonth.get(fc.Date__c.month());
                fc.Fiscal_Month__c = map_intMonth_strMonth.get(MAP_MONTHLABELNUMBER.get(MAP_QUARTERYear.get(i)));
                // added lili 2014.03.19 end
                list_new.add(fc);
            }               
        }
        return list_new;
    }
    
    public static List<Opportunity_Forecast__c> createForcastsNew(Opportunity oppy, Id recordTypeId, List<Decimal> quantities, Decimal sp, Opportunity_Part__c part, String year, Map<Id, String> map_oppyPartId_isoCode, Map<Id, Id> map_partId_oppyId, Map<Integer, Decimal> map_date_amount, Map<Integer, Decimal> map_date_amount_Cust, Date creatForDate){
        List<Opportunity_Forecast__c> list_new = new List<Opportunity_Forecast__c>();
        Map<String, Decimal> map_currency_rate = new Map<String, Decimal>();
        Map<Integer, String> map_int_counter = new Map<Integer, String>();
        // added lili 2014.03.19 begin due to add the field Fiscal_Month__c 
        Map<Integer, String> map_intMonth_strMonth = new Map<Integer, String>();
        map_intMonth_strMonth.put(1,'01');
        map_intMonth_strMonth.put(2,'02');
        map_intMonth_strMonth.put(3,'03');
        map_intMonth_strMonth.put(4,'04');
        map_intMonth_strMonth.put(5,'05');
        map_intMonth_strMonth.put(6,'06');
        map_intMonth_strMonth.put(7,'07');
        map_intMonth_strMonth.put(8,'08');
        map_intMonth_strMonth.put(9,'09');
        map_intMonth_strMonth.put(10,'10');
        map_intMonth_strMonth.put(11,'11');
        map_intMonth_strMonth.put(12,'12');
        //added lili 2014.03.19 end due to add the field Fiscal_Month__c 
        if(oppy.level__c == ClsOppyForecastUtil.MONTHLY){
            map_int_counter.put(1,'1');
            map_int_counter.put(2,'1');
            map_int_counter.put(3,'1');
            map_int_counter.put(4,'2');
            map_int_counter.put(5,'2');
            map_int_counter.put(6,'2');
            map_int_counter.put(7,'3');
            map_int_counter.put(8,'3');
            map_int_counter.put(9,'3');
            map_int_counter.put(10,'4');
            map_int_counter.put(11,'4');
            map_int_counter.put(12,'4');            
        }
        
        // change currency of sale price
        String partCurrencyIsoCode;
        Id pid;
        if(part != null) pid = part.id;
        if(pid != null) partCurrencyIsoCode = map_oppyPartId_isoCode.get(pid);
        else partCurrencyIsoCode = oppy.CurrencyIsoCode;
        if(partCurrencyIsoCode != oppy.CurrencyIsoCode){
            sp = transformIsoCode(sp, oppy.CurrencyIsoCode, partCurrencyIsoCode);
        }
                
        if(oppy.level__c == ClsOppyForecastUtil.MONTHLY){
            
            for(integer i=1; i <= 12; i++){                         
                Opportunity_Forecast__c fc = new Opportunity_Forecast__c();             
                fc.Part__c = pid;
                fc.Quantity__c = quantities.get(i-1);
                fc.RecordTypeId = recordTypeId;
                if(pid == null) {
                    fc.Opportunity__c = oppy.Id;                    
                    if(map_date_amount.containsKey(i)) fc.Amount__c = map_date_amount.get(i);
                    if(map_date_amount_Cust.containsKey(i)) fc.Five_Year_Amount__c= map_date_amount_Cust.get(i);                    
                }
                else {
                    fc.Opportunity__c = map_partId_oppyId.get(pid);
                    fc.Sales_Price__c = sp;
                    fc.Amount__c = fc.Quantity__c * sp;
                    fc.Five_Year_Amount__c= fc.Quantity__c * sp;
                    
                    if(!map_date_amount.containsKey(i)) map_date_amount.put(i, 0);
                    if(!map_date_amount_Cust.containsKey(i)) map_date_amount_Cust.put(i, 0);
                                      
                    // add amount if part status is NOT dead and lost
                    if(part.Status__c != 'Dead' && part.Status__c != 'Lost'){
                        Decimal tmp = map_date_amount.get(i);
                        if(partCurrencyIsoCode != oppy.CurrencyIsoCode) tmp = tmp + transformIsoCode(fc.Amount__c, partCurrencyIsoCode, oppy.CurrencyIsoCode);
                        else tmp += fc.Amount__c;
                        map_date_amount.put(i, tmp);
                    }  
                    Decimal tmp_Cust = map_date_amount_Cust.get(i);
                    if(partCurrencyIsoCode != oppy.CurrencyIsoCode) tmp_Cust = tmp_Cust + transformIsoCode(fc.Five_Year_Amount__c, partCurrencyIsoCode, oppy.CurrencyIsoCode);
                    else tmp_Cust += fc.Five_Year_Amount__c;
                    map_date_amount_Cust.put(i, tmp_Cust);                 
                }
                
                fc.Date__c = getFiscalMonthStartDate(year, MAP_MONTH.get(i));
                fc.CurrencyIsoCode = partCurrencyIsoCode;
                fc.Fiscal_Year__c = year;                           
                fc.Fiscal_Quarter__c = '0' + map_int_counter.get(i);
                // added lili 2014.03.19 begin ** due to add the field Fiscal_Month__c,modify by lili zhao due to set Fiscal_Month__c as i ,not Date__c of oppyforecast
                //fc.Fiscal_Month__c = map_intMonth_strMonth.get(fc.Date__c.month());
                fc.Fiscal_Month__c = map_intMonth_strMonth.get(MAP_MONTHLABELNUMBER.get(MAP_MONTH.get(i)));
                // added lili 2014.03.19 end
                list_new.add(fc);
            }
        }
        else{
            for(integer i=1; i <= 4; i++){                      
                Opportunity_Forecast__c fc = new Opportunity_Forecast__c();
                
                fc.Part__c = pid;
                fc.Quantity__c = quantities.get(i-1);
                fc.RecordTypeId = recordTypeId;
                if(pid == null) {
                    fc.Opportunity__c = oppy.Id;
                    if(map_date_amount.containsKey(i)) fc.Amount__c = map_date_amount.get(i);
                    if(map_date_amount_Cust.containsKey(i)) fc.Five_Year_Amount__c= map_date_amount_Cust.get(i);
                }
                else {
                    fc.Opportunity__c = map_partId_oppyId.get(pid);
                    fc.Sales_Price__c = sp;
                    fc.Amount__c = fc.Quantity__c * sp;
                    fc.Five_Year_Amount__c=fc.Quantity__c * sp;
                    
                    if(!map_date_amount.containsKey(i)) map_date_amount.put(i, 0);
                    if(!map_date_amount_Cust.containsKey(i)) map_date_amount_Cust.put(i, 0);
                                      
                    // add amount if part status is NOT dead and lost
                    if(part.Status__c != 'Dead' && part.Status__c != 'Lost'){
                        Decimal tmp = map_date_amount.get(i);
                        if(partCurrencyIsoCode != oppy.CurrencyIsoCode) tmp = tmp + transformIsoCode(fc.Amount__c, partCurrencyIsoCode, oppy.CurrencyIsoCode);
                        else tmp += fc.Amount__c;
                        map_date_amount.put(i, tmp);
                    }
                    Decimal tmp_Cust = map_date_amount_Cust.get(i);
                    if(partCurrencyIsoCode != oppy.CurrencyIsoCode) tmp_Cust = tmp_Cust + transformIsoCode(fc.Five_Year_Amount__c, partCurrencyIsoCode, oppy.CurrencyIsoCode);
                    else tmp_Cust += fc.Five_Year_Amount__c;
                    map_date_amount_Cust.put(i, tmp_Cust);
                }
                
                fc.Date__c = getFiscalQuarterStartDate(year, String.valueOf(i));
                fc.CurrencyIsoCode = partCurrencyIsoCode;
                fc.Fiscal_Year__c = year;                           
                fc.Fiscal_Quarter__c = '0' + String.valueOf(i);
                // added lili 2014.03.19 begin ** due to add the field Fiscal_Month__c,modify by lili zhao due to set Fiscal_Month__c as i ,not Date__c of oppyforecast
                //fc.Fiscal_Month__c = map_intMonth_strMonth.get(fc.Date__c.month());
                fc.Fiscal_Month__c = map_intMonth_strMonth.get(MAP_MONTHLABELNUMBER.get(MAP_QUARTERYear.get(i)));
                // added lili 2014.03.19 end
                list_new.add(fc);
            }                       
        }
        return list_new;
    }
    
    public static List<Decimal> calculateQantity(Decimal quantity, Integer months){        
        List<Decimal> quantityValues = new List<Decimal>();             
        if(months == 1){
            quantityValues.add(quantity);
            return quantityValues;
        }   
        
        Integer yearlyQuantity = quantity.intValue();  
        Integer dividedQuantity = yearlyQuantity / months;
        Integer remainderQuantity = Math.mod(yearlyQuantity, months);        
        
        for(Integer iter = 1; iter <= months; iter++){
            if(iter == months){
                quantityValues.add(dividedQuantity + remainderQuantity);
            }
            else{
                quantityValues.add(dividedQuantity);
            }           
        }
        return quantityValues;
    }
    
    
    public static Opportunity_Forecast__c GenerateForcasts(String partCurrencyIsoCode, Id pid, Decimal Quantity, Opportunity oppy, Id recordTypeId, Decimal sp, Opportunity_Part__c part, String year, Map<Id, String> map_oppyPartId_isoCode, Map<Id, Id> map_partId_oppyId, Map<Integer, Decimal> map_date_amount, Map<Integer, Decimal> map_date_amount_Cust, String month, String strQuarter, Integer i){
        Opportunity_Forecast__c fc = new Opportunity_Forecast__c();             
        fc.Part__c = pid;
        fc.Quantity__c = Quantity;
        fc.RecordTypeId = recordTypeId;
        if(pid == null) {
            fc.Opportunity__c = oppy.Id;                    
            if(map_date_amount.containsKey(i)) fc.Amount__c = map_date_amount.get(i);
            if(map_date_amount_Cust.containsKey(i)) fc.Five_Year_Amount__c= map_date_amount_Cust.get(i);                    
        }
        else {
            fc.Opportunity__c = map_partId_oppyId.get(pid);
            fc.Sales_Price__c = sp;
            fc.Amount__c = fc.Quantity__c * sp;
            fc.Five_Year_Amount__c= fc.Quantity__c * sp;
            
            if(!map_date_amount.containsKey(i)) map_date_amount.put(i, 0);
            if(!map_date_amount_Cust.containsKey(i)) map_date_amount_Cust.put(i, 0);
    
            if(part.Status__c != 'Dead' && part.Status__c != 'Lost'){
                Decimal tmp = map_date_amount.get(i);
                if(partCurrencyIsoCode != oppy.CurrencyIsoCode) tmp = tmp + transformIsoCode(fc.Amount__c, partCurrencyIsoCode, oppy.CurrencyIsoCode);
                else tmp += fc.Amount__c;
                map_date_amount.put(i, tmp);
            }  
            Decimal tmp_Cust = map_date_amount_Cust.get(i);
            if(partCurrencyIsoCode != oppy.CurrencyIsoCode) tmp_Cust = tmp_Cust + transformIsoCode(fc.Five_Year_Amount__c, partCurrencyIsoCode, oppy.CurrencyIsoCode);
            else tmp_Cust += fc.Five_Year_Amount__c;
            map_date_amount_Cust.put(i, tmp_Cust);                 
        }
        fc.CurrencyIsoCode = partCurrencyIsoCode;
        fc.Fiscal_Year__c = year;                           
        fc.Fiscal_Quarter__c = '0' + strQuarter;
        return fc;
    }
      /**
    * The method is used to save the program forecasts
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param             
    *
    @return            
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    2012-10-24 Frederic Faisst <frederic.faisst@itbconsult.com>
    * - Changed code line 1135 --> Filter removed: part.Process_Status__c == 'Production'
    */
    public static void saveProgram(String saveString, List<ClsOppForecastStructure> list_forecastStructures, List<Opportunity_Part__c> list_parts, List<Id> list_partIds, Opportunity oppy, Id forecastOppyRecordTypeId, Id forecastPartRecordTypeId, map<Id, String> map_oppyPartId_isoCode, Map<Id, Id> map_partId_oppyId,set<String>set_fYears){                        
        system.debug('@@ Current Time start saveProgram : ' + system.now());
        generateRevenueMap();
        boolean bForecastRecalculation = false;
        integer yearOrder = 0;
        if(map_oppyId_oppy == null){
            map_oppyId_oppy = new map<Id, Opportunity>();
            for(Opportunity o : [Select Id, CurrencyIsoCode, CloseDate, Manufacturing_Start_Date__c,RecordType.DeveloperName from Opportunity where Id = :oppy.id or Program__c = :oppy.id]){
                map_oppyId_oppy.put(o.Id, o);
            }
        }
        // when all the forecasts are saved
        try{                      
                List<Opportunity_Forecast__c> list_new = new List<Opportunity_Forecast__c>();
                //String year;
                Integer index = 0;
                Integer qtMnNumber = 4;
                // quarterly
                
                //in case more than one year --begin
                List<String> yearStr = saveString.split(SPLIT_YEAR);
                integer j = yearStr.size();
                List<Decimal> list_oppyquantity;//
                List<Decimal> list_partquantity;//
                //set<String> set_Saveyears = new set<String>();
                Decimal sp = 0;
                
                List<String> list_s;
                //START: added by Jinbo Shan 2014-12-08 for reparenting
                set<Id> set_fbIds = new set<Id>();
                if(oppy.AccountId != null) {
                    string keyLike = string.valueOf(oppy.AccountId).subString(0, 15) + '_' + string.valueOf(oppy.Id).subString(0, 15) + '%';
                    system.debug('@@ Current Time : ' + system.now());
                    for(Forecast_Billing__c fb : [select Id from Forecast_Billing__c where Opportunity_Part__r.Opportunity__r.AccountId =: oppy.AccountId and Opportunity_Part__r.Opportunity__c =: oppy.Id limit 1]) {//[select Id from Forecast_Billing__c where acc_opp_part__c like :keyLike limit 1]) {
                        system.debug('@@ Current Time1 : ' + system.now());
                        set_fbIds.add(fb.Id);
                    }
                }
                system.debug('@@ Current Time11 : ' + system.now());
                system.debug('j::: '+j);
                system.debug('set_fbIds::: '+set_fbIds);
                //END:
                for(integer k=0;k<j;k++){
                    if('Completed' != yearStr[k]){
                        //yearStr[k]:2013;Yearly;BOM#q100;a300;p0#100;100;1#200;200;1#300;300;1#400;0;0#500;0;0#600;0;0#700;700;1#800;0;0
                        Map<Integer, Decimal> map_date_amount = new Map<Integer, Decimal>();//
                        Map<Integer, Decimal> map_date_amount_Cust = new Map<Integer, Decimal>();// add lili 2014.1.20
                        list_oppyquantity = new List<Decimal>();
                        list_partquantity = new List<Decimal>();
                        sp = 0;
                        list_s = yearStr[k].split(SPLIT_OUTER);
                        index = 0;
                        for(String s: list_s){
                            if(index == 0){
                                integer i = 0;
                                for(string info:s.split(SPLIT_INNER)){
                                    if(info.trim() != null && info.trim() != ''){
                                        if(i == 0){
                                            saveYear = info.trim();
                                            set_Saveyears.add(saveYear);
                                            set_fYears.add(saveYear);
                                        }else if(i == 1){
                                            oppy.level__c = info.trim();
                                            if(oppy.Level__c == ClsOppyForecastUtil.QUARTERLY) {
                                                qtMnNumber = 4;
                                            }
                                            // monthly
                                            else if(oppy.Level__c == ClsOppyForecastUtil.MONTHLY) {
                                                qtMnNumber = 12;
                                            }
                                            // yearly
                                            else {
                                                qtMnNumber = 1;
                                            }
                                        }else{
                                            oppy.Method__c = info.trim();
                                        }
                                    }
                                    i++;
                                }
                                //saveYear = s; 
                                            
                            }else{                  
                                integer pIndex = (index - 1)/qtMnNumber;
                                integer fIndex = Math.mod(index,qtMnNumber);
                                // get info of opportunity forecasts
                                if(pIndex < 1){
                                    integer i = 0;
                                    for(string info:s.split(SPLIT_INNER)){
                                        if(i == 0) list_oppyquantity.add(Decimal.valueOf(info));
                                        break;
                                    }       
                                }
                                // get info of part forecasts
                                else{
                                    if((pIndex-1) < list_partIds.size()){
                                        //id pid = list_partIds.get(pIndex-1);
                                        integer i = 0;
                                        for(string info:s.split(SPLIT_INNER)){
                                            
                                            if(i == 0) list_partquantity.add(Decimal.valueOf(info));
                                            if(i == 2) sp = Decimal.valueOf(info);
                                            i++;
                                        }
                                        if(fIndex == 0){
                                            list_new.addAll(createForcasts(oppy, forecastPartRecordTypeId, list_partquantity, sp, list_parts.get(pIndex-1), saveYear, map_oppyPartId_isoCode, map_partId_oppyId, map_date_amount, map_date_amount_Cust));
                                            list_partquantity.clear();
                                        }
                                    }                   
                                }
                            }
                            index ++;
                        }           
                        //system.debug('tongxia saveYear:' + saveYear);
                        //system.debug('tongxia list_oppyquantity:' + list_oppyquantity);
                        system.debug('@@ Current Time createForcasts : ' + system.now());
                        list_new.addAll(createForcasts(oppy, forecastOppyRecordTypeId, list_oppyquantity, sp, null, saveYear, map_oppyPartId_isoCode, map_partId_oppyId, map_date_amount, map_date_amount_Cust));
                        system.debug('@@ Current Time createForcasts end : ' + system.now());
                    }else{
                        list_oppyquantity = null;
                        list_partquantity = null;
                        list_s = null;
                        
                        
                         //added by xia 2012-12-20
                               
                        if(oppyYear == null || oppyYear == ''){
                            oppyYear = getForecastYear(oppy.Manufacturing_Start_Date__c);
                        }
                        if(oppyYear != null && oppyYear != ''){
                            map_fiscalYear_order = new Map<String, String>(); 
                            for(Integer i=0; i<10; i++){
                               String y = String.valueOf(Integer.valueOf(oppyYear) + i);
                               map_fiscalYear_order.put(y , String.valueOf(i+1));
                            } 
                            for(Opportunity_Part__c part: list_parts){
                                //Added by bin yuan 2014-04-16 due to clear lost reason if oppy part is active
                                /*
                                if(part.Status__c != 'Lost' && part.Status__c != 'Dead') {
                                    part.Lost_Reason__c = null;
                                    part.Lost_Reason_Text__c = null;
                                    part.Competitor__c = null;
                                }
                                */
                                //End 
                                for(String y: map_year_revApi.keyset()){
                                    if(!set_fYears.contains(y)){
                                        part.put(map_year_revApi.get(y),0);
                                        part.put(map_year_QTYApi.get(y),0);
                                        part.put(map_year_PRICEApi.get(y),0);
                                    
                                    }
                                
                                }
                                for(String y:map_fiscalYear_order.keySet()){
                                    if(!set_fYears.contains(y)){
                                        part.put('FCSTYR'+ map_fiscalYear_order.get(y)+'QTY__c', 0);
                                        part.put('FCSTYR'+ map_fiscalYear_order.get(y)+'AMT__c', 0);
                                        part.put('FC_FY'+ map_fiscalYear_order.get(y)+'_PRICE__c', 0);
                                        part.put('YRLYFCSTYR'+ map_fiscalYear_order.get(y)+'__c', null);
                                    }
                                }
                            }
                        }
                        //system.debug('list_parts:::: 1773'+list_parts);
                        //start: Commented by Rajendra on 02-22-2016 for case 00900667
                        //update list_parts;
                        //end: Commented by Rajendra on 02-22-2016 for case 00900667
                        oppyYear = '';
                        
                        //START: added by Jinbo Shan for reparenting
                        if(set_fbIds.size() > 0) {
                            //start: Commented by Rajendra on 02-22-2016 for case 00900667
                            /*oppy.Opportunity_Forecast_Recalculation__c = true;                            
                            update oppy;*/
                            //end: Commented by Rajendra on 02-22-2016 for case 00900667
                            bForecastRecalculation = true;
                        }
                        //END
                        if(set_fYears.isEmpty() ){
                            delete [select Id, Date__c, Fiscal_Year__c, Sales_Price__c, Quantity__c, Amount__c, Opportunity__c, Part__c, Forecasting_Start_Date__c from Opportunity_Forecast__c where (Opportunity__c = :oppy.Id or Opportunity__r.Program__c = :oppy.Id)];
                        
                        }else{
                            delete [select Id, Date__c, Fiscal_Year__c, Sales_Price__c, Quantity__c, Amount__c, Opportunity__c, Part__c, Forecasting_Start_Date__c from Opportunity_Forecast__c where (Opportunity__c = :oppy.Id or Opportunity__r.Program__c = :oppy.Id) and Fiscal_Year__c NOT IN: set_fYears];
                            set_fYears.clear();
                        } 
            
                    }
                }
                
                if(!set_Saveyears.isEmpty())
                delete [select Id, Date__c, Fiscal_Year__c, Sales_Price__c, Quantity__c, Amount__c, Opportunity__c, Part__c, Forecasting_Start_Date__c from Opportunity_Forecast__c where (Opportunity__c = :oppy.Id or Opportunity__r.Program__c = :oppy.Id)  and Fiscal_Year__c in : set_Saveyears];
                //system.debug('tongxia list_new:' + list_new);
                if(!list_new.isEmpty()) insert list_new;
    
                //handle parts and opportunity ---added by xia 2012-11-23
                Map<Id, Opportunity_Part__c> map_parts = new Map<Id, Opportunity_Part__c>();
                
                for(Opportunity_Part__c part : list_parts){
                    map_parts.put(part.Id, part);
                }

                if(oppyYear == null || oppyYear == ''){
                    oppyYear = getForecastYear(oppy.Manufacturing_Start_Date__c);
                }
                 
                // when fiscal year of closeDate exist in org 
                if(oppyYear != ''){  
                    integer oppy_Year = Integer.valueOf(oppyYear);             
                    map_fiscalYear_order = new Map<String, String>();        
                    for(Integer i=0; i<10; i++){
                       String y = String.valueOf(oppy_Year + i);
                       map_fiscalYear_order.put(y , String.valueOf(i+1));
                    }                    
                    
                    for(Opportunity_Part__c part : map_parts.values()){
                        for(String save_Year : set_Saveyears){
                            if(map_fiscalYear_order.containsKey(save_Year)){
                                part.put('FCSTYR'+ map_fiscalYear_order.get(save_Year)+'QTY__c', 0);
                                part.put('FCSTYR'+ map_fiscalYear_order.get(save_Year)+'AMT__c', 0);
                                part.put('FC_FY'+ map_fiscalYear_order.get(save_Year)+'_PRICE__c', 0);
                                part.put('YRLYFCSTYR'+ map_fiscalYear_order.get(save_Year)+'__c', null);
                            }
                            if(map_year_revApi.containsKey(save_Year)){
                                part.put(map_year_revApi.get(save_Year),0);
                                part.put(map_year_QTYApi.get(save_Year),0);
                                part.put(map_year_PRICEApi.get(save_Year),0);
                            }
                        }
                    }
                    //START: Added By Jinbo Shan 2014-12-01 to reparent the Opportunity Forecast for forecast billing.
                    set<string> set_fiscalYears4reparent = new set<string>();
                    if(currentFisicalYear == null) {
                        for(Period p : [select FiscalYearSettings.Name from Period where startDate<=Today and enddate>=Today and Type='Month']) {
                            currentFisicalYear = p.FiscalYearSettings.Name;
                        }
                    }
                    //END
                    for(Opportunity_Forecast__c fc : list_new){
                        if(fc.Part__c != null && fc.Fiscal_Year__c != null){
                            Opportunity_Part__c part = map_parts.get(fc.Part__c);
                            //START: Added By Jinbo Shan 2014-12-01 to reparent the Opportunity Forecast for forecast billing.
                            if(fc.Fiscal_Year__c <= currentFisicalYear) {
                                set_fiscalYears4reparent.add(fc.Fiscal_Year__c);
                            }
                            //END
                            if(map_fiscalYear_order.containsKey(fc.Fiscal_Year__c)){
                                part.put('YRLYFCSTYR'+ map_fiscalYear_order.get(fc.Fiscal_Year__c) +'__c', fc.Fiscal_Year__c);
                                if(fc.Quantity__c != null && fc.Quantity__c > 0){
                                    Decimal qty = (Decimal) part.get('FCSTYR'+ map_fiscalYear_order.get(fc.Fiscal_Year__c)+'QTY__c');
                                    qty += fc.Quantity__c;
                                    part.put('FCSTYR'+ map_fiscalYear_order.get(fc.Fiscal_Year__c) +'QTY__c', qty);
                                    if(fc.Sales_Price__c != null) {
                                        Decimal p = fc.CurrencyIsoCode != 'USD'? transformIsoCode(fc.Sales_Price__c, fc.CurrencyIsoCode, 'USD'):fc.Sales_Price__c;
                                        part.put('FC_FY'+ map_fiscalYear_order.get(fc.Fiscal_Year__c)+'_PRICE__c', p);
                                        Decimal amount = (Decimal) part.get('FCSTYR'+ map_fiscalYear_order.get(fc.Fiscal_Year__c) +'AMT__c');
                                        amount += fc.Quantity__c * p;
                                        part.put('FCSTYR'+ map_fiscalYear_order.get(fc.Fiscal_Year__c) +'AMT__c', amount);
                                        
                                    }
                                }
                               
                            }
                            
                            //added by xia 2012-11-23 calculate revent field;
                            if(fc.Quantity__c != null && fc.Quantity__c > 0 && map_year_QTYApi.containsKey(fc.Fiscal_Year__c)){
                                Decimal quantity = (Decimal)part.get(map_year_QTYApi.get(fc.Fiscal_Year__c));
                                quantity += fc.Quantity__c;
                                part.put(map_year_QTYApi.get(fc.Fiscal_Year__c), quantity);

                            }
                            if(fc.Sales_Price__c != null && fc.Sales_Price__c != 0 && map_year_PRICEApi.containsKey(fc.Fiscal_Year__c)){
                                Decimal salesprice = transformIsoCode(fc.Sales_Price__c, fc.CurrencyIsoCode, 'USD');
                                part.put(map_year_PRICEApi.get(fc.Fiscal_Year__c), salesprice);
                            }
                            if(fc.Quantity__c != null && fc.Quantity__c > 0 && fc.Sales_Price__c != null){
                                if(map_year_revApi.containsKey(fc.Fiscal_Year__c)){
                                    Decimal revenue = (Decimal) part.get(map_year_revApi.get(fc.Fiscal_Year__c));
                                    
                                    
                                    revenue += fc.Quantity__c * transformIsoCode(fc.Sales_Price__c, fc.CurrencyIsoCode, 'USD');
                                    part.put(map_year_revApi.get(fc.Fiscal_Year__c), revenue);
                                   
                                                                        
                                }
                                    
                            }
                        }
                    }
                    system.debug('@@ Current Time updateNewlyOppyForecast : ' + system.now());
                    //START: added by Jinbo Shan 2014-12-01 for reparenting
                    system.debug('**@@set_fiscalYears4reparent = ' + set_fiscalYears4reparent);                    
                    //Commented by Rajendra on 02-22-2016 for case 00900667
                    //if(oppy.Opportunity_Forecast_Recalculation__c) {
                    if(bForecastRecalculation) {
                        updateNewlyOppyForecast(oppy.Id, set_fiscalYears4reparent);
                    }
                    //END
                }
                //system.debug('tongxia list_parts:' + list_parts); 
                update map_parts.values();
        system.debug('@@ Current Time end saveProgram : ' + system.now());
            //}
        }
        catch(exception ex){
            ApexPages.addMessages(ex);
        }
        
    }       
    
    /**
    * The method is the add year(s) method
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param     forecast structures, list of current years, the number of adding year, list of current parts, opportunity id, the record type, level
    *
    @return            
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static void addOppyYears(List<String> list_years, Integer newYears, List<ClsOppForecastStructure> list_forecastStructures, Opportunity oppy, List<Id> list_partIds){     
        Set<String> set_periodYears = ClsOppyForecastUtil.getAllPeriodYears();
        Integer lastYear = 0;
        //Integer currentYear = system.today().year();
        Integer currentYear = Integer.valueOf(getFiscalYear());
        if(list_years.size() > 0){
            lastYear = Integer.valueOf(list_years.get(list_years.size() - 1));
            if(currentYear > lastYear){
                lastYear = currentYear - 1;
            }
        }
        else{
              //lastYear = system.today().year() - 1;
            lastYear = Integer.valueOf(getFiscalYear()) - 1;
        }
        for(Integer i=0; i < newYears; i++){
            lastYear++;
            if(set_periodYears.contains(String.valueOf(lastYear))){
                ClsOppForecastStructure OppyForecastStructure = ClsOppyForecastUtil.createNewOppyForecastStructure(String.valueOf(lastYear), oppy, list_partIds);
                list_forecastStructures.add(OppyForecastStructure); 
                list_years.add(String.valueOf(lastYear));
            }
        }
    }
    
    /**
    * The method is the add year(s) method
    *
    @author Lili Zhao
    @created 2014-03-18
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param     forecast structures, list of current years, the number of adding year, list of current parts, opportunity id, the record type, level
    *
    @return            
    *
    @changelog
    * 2014-03-18 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static void addOppyYears(List<String> list_years, Integer newYears, List<ClsOppForecastStructure> list_forecastStructures, Opportunity oppy, List<Id> list_partIds,map<Id, Decimal> map_partId_price){     
        Set<String> set_periodYears = ClsOppyForecastUtil.getAllPeriodYears();
        Integer lastYear = 0;
        //Integer currentYear = system.today().year();
        Integer currentYear = Integer.valueOf(getFiscalYear());
        if(list_years.size() > 0){
            lastYear = Integer.valueOf(list_years.get(list_years.size() - 1));
            if(currentYear > lastYear){
                lastYear = currentYear - 1;
            }
        }
        else{
             //lastYear = system.today().year() - 1;
            lastYear = Integer.valueOf(getFiscalYear()) - 1;
        }
        for(Integer i=0; i < newYears; i++){
            lastYear++;
            if(set_periodYears.contains(String.valueOf(lastYear))){
                // modified by lili 2014.03.18 begin
                ClsOppForecastStructure OppyForecastStructure = ClsOppyForecastUtil.createNewOppyForecastStructure(String.valueOf(lastYear), oppy, list_partIds, map_partId_price);
                // modified by lili 2014.03.18 end
                list_forecastStructures.add(OppyForecastStructure); 
                list_years.add(String.valueOf(lastYear));
            }
        }
    }

    
      /**
    * The method is used to upsert all opportunity forecasts
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param     opportunity id, record type
    *
    @return            
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static void updateOpportunityFromForecast(Id oppyId, Id RecordTypeId){
        system.debug('tongxia:updateOpportunityFromForecast');
        system.debug('tongxia:set_Saveyears: ' + set_Saveyears);  
        List<Opportunity_Forecast__c> list_upsertForecasts = new List<Opportunity_Forecast__c>();
        Map<String, Map<Id, Opportunity_Forecast__c>> map_forecasts = new Map<String, Map<Id, Opportunity_Forecast__c>>();
        Map<String, Map<Id, Opportunity_Forecast__c>> map_oppyForecasts = new Map<String, Map<Id, Opportunity_Forecast__c>>();
        getAllFiscalQuarter();
        // aggregate all forecasts of parts
        for(Opportunity_Forecast__c ofc : [select Id, CurrencyIsoCode,Name, RecordTypeId, Date__c, Sales_Price__c, Quantity__c, Amount__c, Opportunity__c, Part__c, Part__r.Quantity__c, Part__r.Status__c, Forecasting_Start_Date__c from Opportunity_Forecast__c where Opportunity__r.Program__c = :oppyId and Part__c != null and Date__c != null and Fiscal_Year__c in: set_Saveyears order by Part__r.Name ]){   
            system.debug('tongxia:ofc: ' + ofc);
            String ym = ofc.Date__c.format(); 
            system.debug('tongxia:ym: ' + ym);        
            if(!map_forecasts.containsKey(ym)){
                Map<Id, Opportunity_Forecast__c> map_tmp = new Map<Id, Opportunity_Forecast__c>();
                map_forecasts.put(ym, map_tmp);
            }
        
            if(!map_forecasts.get(ym).containsKey(ofc.Opportunity__c)){
                Opportunity_Forecast__c fc = new Opportunity_Forecast__c();
                if(ofc.Part__r.Quantity__c != null && ofc.Part__r.Quantity__c != 0){
                    fc.Quantity__c = ofc.Quantity__c/ofc.Part__r.Quantity__c;                             
                }
                else {
                    fc.Quantity__c = 0;
                }
                // added by min
                if(ofc.Amount__c == null || ofc.Part__r.Status__c == 'Lost' || ofc.Part__r.Status__c == 'Dead'){
                    fc.Amount__c = 0;
                }
                else fc.Amount__c = ofc.Amount__c;
                fc.RecordTypeId = RecordTypeId;
                fc.Opportunity__c = ofc.Opportunity__c;
                fc.Sales_Price__c = ofc.Sales_Price__c;
                fc.Date__c = ofc.Date__c;
                fc.CurrencyIsoCode = ofc.CurrencyIsoCode;
                fc.Fiscal_Year__c = getForecastYear(ofc.Date__c);
                fc.Fiscal_Quarter__c = '0' + getForecastQuarter(ofc.Date__c);
                fc.Forecasting_Start_Date__c = ofc.Forecasting_Start_Date__c;
                map_forecasts.get(ym).put(ofc.Opportunity__c, fc);
            }
            else {
                // added by min
                if(ofc.Part__r.Status__c != 'Lost' && ofc.Part__r.Status__c != 'Dead') map_forecasts.get(ym).get(ofc.Opportunity__c).Amount__c += ofc.Amount__c==null?0:ofc.Amount__c;               
            }       
        }
        
        // get the forecasts to delete and update
        for(String ym: map_forecasts.keySet()){
            list_upsertForecasts.addAll(map_forecasts.get(ym).values());                    
        }
        
        try{
            system.debug('tongxia:list_upsertForecasts: ' + list_upsertForecasts);
            if(list_upsertForecasts.size() > 0){
                upsert list_upsertForecasts;
            }
        }   
        catch(Exception ex){
            ApexPages.addMessages(ex);          
        }       
    } 
        
     
    /**
    * The method is used to recalculate revenue
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param             
    *
    @return            
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static void recalculateRevenue(Map<id, Opportunity> map_oppyid_opportunity, String method, String level, Date closeDate){
        Map<Id, List<Opportunity_Forecast__c>> map_oppyid_forecasts = new Map<Id, List<Opportunity_Forecast__c>>();
        Map<Id, Date> map_oppyid_firstDate = new Map<Id, Date>();
        
        if(!map_oppyid_opportunity.isEmpty()){
            // get the forecasts according to opportunity id
            for(Opportunity_Forecast__c ofc: [select id, Name, Five_Year_Amount__c,CurrencyIsoCode, Quantity__c, Amount__c, Opportunity__c, Part__c, Sales_Price__c, Date__c,Fiscal_Year__c, Fiscal_Quarter__c from Opportunity_Forecast__c where Opportunity__c in :map_oppyid_opportunity.keySet() and Part__c = null and Date__c != null order by Opportunity__c, Date__c]){
                if(!map_oppyid_forecasts.containsKey(ofc.Opportunity__c)){
                    map_oppyid_forecasts.put(ofc.Opportunity__c, new List<Opportunity_Forecast__c>());
                }
                map_oppyid_forecasts.get(ofc.Opportunity__c).add(ofc);          
            }
            Map<Date, Map<String, Map<Integer, Integer>>> map_date_startEndQuarter = getFiveYearsInternal(new set<Date>{closeDate});
            Integer startYear, startQuarter, endYear, endQuarter; 
            for(String t: map_date_startEndQuarter.get(closeDate).keySet()){        
                for(Integer y : map_date_startEndQuarter.get(closeDate).get(t).keySet()){
                    if(t == 'Start'){
                        startYear = y;
                        startQuarter = map_date_startEndQuarter.get(closeDate).get(t).get(y);
                    }
                    else{
                        endYear = y;
                        endQuarter = map_date_startEndQuarter.get(closeDate).get(t).get(y);                 
                    }
                }
            } 
            //system.debug('tongxia startYear:' + startYear) ;  
            //system.debug('tongxia endYear:' + endYear) ; 
            //system.debug('tongxia startQuarter:' + startQuarter) ; 
            //system.debug('tongxia endQuarter:' + endQuarter) ;     
            // start to calculate revenues
            for(Id id: map_oppyid_opportunity.keySet()){
                Decimal totalRevenue = 0;
                Decimal year5Revenue = 0;
                Decimal totalRevenue_Cust = 0;
                Decimal year5Revenue_Cust = 0;

                if(map_oppyid_forecasts.containsKey(id)){
                    for(Opportunity_Forecast__c  ofc: map_oppyid_forecasts.get(id)){
                        if(ofc.Amount__c != null){
                            if(ofc.Date__c != null && closeDate != null){
                                // calculate the five year revenue
                                Integer y;
                                Integer q;
                                if(ofc.Fiscal_Year__c != null) y = Integer.valueOf(ofc.Fiscal_Year__c);
                                if(ofc.Fiscal_Quarter__c != null) q = Integer.valueOf(ofc.Fiscal_Quarter__c);
                                //system.debug('tongxia y:' + y);
                                //system.debug('tongxia q:' + q);
                                if((y != null && y > startYear && y < endYear) || (y != null && q != null && y == startYear && q >= startQuarter) || (y != null && q != null && y == endYear && q <= endQuarter)){
                                    //system.debug('tongxia year5Revenue:' + year5Revenue);
                                    year5Revenue += ofc.Amount__c;
                                    if(ofc.Five_Year_Amount__c!=null){year5Revenue_Cust += ofc.Five_Year_Amount__c;}
                                    else{year5Revenue_Cust+= ofc.Amount__c;}
 
                                    //system.debug('tongxia year5Revenue after:' + year5Revenue);
                                }
                            }
                            // calculate total revenue
                            totalRevenue +=  ofc.Amount__c;
                            if(ofc.Five_Year_Amount__c!=null){totalRevenue_Cust += ofc.Five_Year_Amount__c;}
                            else{totalRevenue_Cust += ofc.Amount__c;}
                            
                        }                       
                    }
                }            
                map_oppyid_opportunity.get(id).Amount = totalRevenue;
                
                map_oppyid_opportunity.get(id).Five_Year_Revenue__c = year5Revenue;
                // ######### Added Five Year Value,Total Opportunity value functionality BY RAVI <ravikumar.vasimalla@zensar.in>##########
               
                map_oppyid_opportunity.get(id).Total_Opportunity_Value__c = totalRevenue_Cust;
                map_oppyid_opportunity.get(id).Five_Year_Value__c = year5Revenue_Cust;
                if(method != null){
                    map_oppyid_opportunity.get(id).Method__c = method;
                }
                if(level != null){
                    map_oppyid_opportunity.get(id).Level__c = level;
                }
            }
            
           IND_RecalOneCurr_RevenueClass reclaOnECurr = new IND_RecalOneCurr_RevenueClass();
           if(reclaOnECurr.onAfterinsertUpdate(map_oppyid_opportunity)!=null){
           map_oppyid_opportunity.putall(reclaOnECurr.onAfterinsertUpdate(map_oppyid_opportunity)); // Code added by Deepak Kumar on 15th sep 2016 for TeamUp case number  00901050                
           }
        }
    }


    public static Map<Date, Map<String, Map<Integer, Integer>>> getFiveYearsInternal(set<Date> set_startDate){
        Map<Date, Map<String, Map<Integer, Integer>>> map_date_startEndQuarter = new Map<Date, Map<String, Map<Integer, Integer>>>();
        String s = 'Start';
        getAllFiscalQuarter();
        for(Date inputDate : set_startDate){
            map_date_startEndQuarter.put(inputDate, new Map<String, Map<Integer, Integer>>());
            map_date_startEndQuarter.get(inputDate).put(s, new Map<Integer, Integer>());
            for(Period p: list_fiscalQuarter){
                if(inputDate >= p.StartDate && inputDate <= p.EndDate){
                    Integer year = Integer.valueOf(p.FiscalYearSettings.Name);
                    map_date_startEndQuarter.get(inputDate).get(s).put(year, p.Number);
                    break;
                }         
            }
        }
        //system.debug('map_date_startEndQuarter: ' + map_date_startEndQuarter);
        String e = 'End';
        for(Date inputDate : map_date_startEndQuarter.keySet()){
            map_date_startEndQuarter.get(inputDate).put(e, new Map<Integer, Integer>());
            Integer year;
            Integer quarter;
            for(Integer y: map_date_startEndQuarter.get(inputDate).get(s).keySet()){
                quarter = map_date_startEndQuarter.get(inputDate).get(s).get(y) + 3;
                if(quarter == 4) {
                    year = y + 4;
                }
                else{
                    quarter = quarter - 4;
                    year = y + 5;
                }
                map_date_startEndQuarter.get(inputDate).get(e).put(year, quarter);
            }
        }
        //system.debug('map_date_startEndQuarter: ' + map_date_startEndQuarter);
        return map_date_startEndQuarter;
    }
    
        
    public static Map<Date, Date> getFiveYearsInternal(Date startDate, String level){
        String dateStr = String.valueOf(startDate).subString(0,10);
        String query = 'Select StartDate from Period where StartDate <= ' + dateStr + ' and EndDate >= ' + dateStr;
        if(level == ClsOppyUtil.MONTHLY){
            query += ' and Type = \'Month\''; 
        }
        else if(level == ClsOppyUtil.QUARTERLY){
            query += ' and Type = \'Quarter\''; 
        }
        else{
            query += ' and Type = \'Year\''; 
        }               
        Date sDate;
        Date eDate;
        for(Period p : Database.query(query)){
            sDate = p.StartDate;
        }
        //system.debug('query: ' + query);
        dateStr = String.valueOf(sDate).subString(0,10);
        query = 'Select EndDate from Period where StartDate >= ' + dateStr;
        if(level == ClsOppyUtil.MONTHLY){
            query += ' and Type = \'Month\' order by StartDate limit 60'; 
        }
        else if(level == ClsOppyUtil.QUARTERLY){
            query += ' and Type = \'Quarter\' order by StartDate limit 20'; 
        }
        else{
            query += ' and Type = \'Year\' order by StartDate limit 5'; 
        }       
        //system.debug('query: ' + query);
        for(Period p : Database.query(query)){
            eDate = p.EndDate;
        }
        Map<Date, Date> map_tmp = new Map<Date, Date>();
        map_tmp.put(sDate, eDate);      
        //system.debug('map_tmp: ' + map_tmp);
        return map_tmp;
    }    
    /**
    * The method is used to calculate revenue, method, level for each opportunity and update each opportunity
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param             
    *
    @return             map of oppyId and opportunity object, selected method, selected level
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    *
    * 2014-03-05 Bin Yuan <bin.yuan@itbconsult.com>
    * - Modified Error message for code line 2094
    */    
    public static void updateOpportunityAmounts(Map<Id, Opportunity> map_oppyid_opportunity, String method, String level, Opportunity opportunity){     
        Map<Id, List<Opportunity_Forecast__c>> map_oppyid_forecasts = new Map<Id, List<Opportunity_Forecast__c>>();
        
        //************************************************
        //START: update the oppys and program
        //************************************************
        recalculateRevenue(map_oppyid_opportunity, method, level, opportunity.Manufacturing_Start_Date__c);
        try{
            if(map_oppyid_opportunity.size() > 0){
                system.debug('tongxia updateOpportunityAmounts map_oppyid_opportunity:' + map_oppyid_opportunity);
                update map_oppyid_opportunity.values();
            }
        }   
        catch(Exception ex){
            ApexPages.addMessages(ex); 
            /*
            string stackMsg = '' + ex.getStackTraceString();
            //Added by Bin Yuan 2014-03-05 due to change error message info
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error! Line number:'+string.valueOf(ex.getLineNumber()) + ' Reason:' + stackMsg + ' Cause:'+ex.getCause()+' Msg:'+ex.getMessage());
            String errorMsgFullInfo = 'Error! Line number:'+string.valueOf(ex.getLineNumber()) + ' Reason:' + stackMsg + ' Cause:'+ex.getCause()+' Msg:'+ex.getMessage();
            //system.debug('ex.getMessage():::'+ex.getMessage());
            //system.debug('::::lili'+ex.getMessage().contains(system.label.Oppy_SOP_Opps_only_on_monthly_FC_level));
            String errMessLable = system.label.Oppy_SOP_Opps_only_on_monthly_FC_level + system.label.Oppy_SOP_Opps_only_on_monthly_FC_level_1;
            String errorMessage = (ex.getMessage().contains(system.label.Oppy_SOP_Opps_only_on_monthly_FC_level) ? errMessLable : errorMsgFullInfo);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,  ex.getMessage());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,  ex.getMessage() ); 

            //End 
            ApexPages.addMessage(myMsg);   
            */              
        }
        //************************************************
        //END: update the oppys and program
        //************************************************  
                
        //************************************************
        //START: update the program if necessary 
        //************************************************      
        if(opportunity.Program__c != null){
            Set<Opportunity> set_programOppys = new Set<Opportunity>();
            Opportunity program;
            for(Opportunity oppy: [select id, Program__c, Name, Amount,Five_Year_Value__c, Total_Opportunity_Value__c,CurrencyIsoCode, Five_Year_Revenue__c from Opportunity where Program__c = :opportunity.Program__c or Id = :opportunity.Program__c]){
                if(oppy.Id == opportunity.Program__c){
                    program = oppy;
                }
                else{
                    set_programOppys.add(oppy);
                }
            }
            //system.debug('set_programOppys: ' + set_programOppys);
            updateProgramTotalFiveYearsAmount(program, set_programOppys);
            try{
                //system.debug('program: ' + program);
                update program;
            }   
            catch(Exception ex){
                ApexPages.addMessages(ex);
                /*
                string stackMsg = '' + ex.getStackTraceString();
                
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error! Line number:'+string.valueOf(ex.getLineNumber()) + ' Reason:' + stackMsg + ' Cause:'+ex.getCause()+' Msg:'+ex.getMessage());
                ApexPages.addMessage(myMsg);      
                */          
            }
        }
        //************************************************
        //END: update the program if necessary 
        //************************************************          
    }
    
    public static void updateProgramTotalFiveYearsAmount(Opportunity program, set<Opportunity> set_programOppys){
        Decimal totalRevenue = 0;
        Decimal year5Revenue = 0;
        Decimal totalRevenue_Cust = 0;
        Decimal year5Revenue_Cust = 0;
        getExchangeRate();
        for(Opportunity oppy :set_programOppys){ 
            if(oppy.CurrencyIsoCode == program.CurrencyIsoCode){       
                totalRevenue += oppy.Amount==null?0:oppy.Amount;
                totalRevenue_Cust += oppy.Total_Opportunity_Value__c==null?0:oppy.Total_Opportunity_Value__c;
            }
            else if(oppy.Amount != null){
                totalRevenue += transformIsoCode(oppy.Amount, oppy.CurrencyIsoCode, program.CurrencyIsoCode);
                totalRevenue_Cust += transformIsoCode(oppy.Total_Opportunity_Value__c, oppy.CurrencyIsoCode, program.CurrencyIsoCode);
            }
            // ######### Added Five Year Value,Total Opportunity value functionality BY RAVI <ravikumar.vasimalla@zensar.in>##########
            if(oppy.CurrencyIsoCode == program.CurrencyIsoCode){       
                year5Revenue += oppy.Five_Year_Revenue__c==null?0:oppy.Five_Year_Revenue__c;
                year5Revenue_Cust += oppy.Five_Year_Value__c==null?0:oppy.Five_Year_Value__c;
            }
            else if(oppy.Five_Year_Revenue__c != null){
                year5Revenue += transformIsoCode(oppy.Five_Year_Revenue__c, oppy.CurrencyIsoCode, program.CurrencyIsoCode);
                year5Revenue_Cust += transformIsoCode(oppy.Five_Year_Value__c, oppy.CurrencyIsoCode, program.CurrencyIsoCode);
            }
            
            program.Amount = totalRevenue;
            program.Five_Year_Revenue__c = year5Revenue;
             // ######### Added Five Year Value,Total Opportunity value functionality BY RAVI <ravikumar.vasimalla@zensar.in>##########
           
            program.Total_Opportunity_Value__c = totalRevenue_cust;
            program.Five_Year_Value__c = year5Revenue_Cust;
        }       
    }
    

    
      /**
    * The method is used to get the year according to the index
    *
    @author Bin yu
    @created 2012-03-03
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param    list of years, the specified year, the difference of the index in the list
    *
    @return   the year          
    *
    @changelog
    * 2012-03-03 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static String yearByIndex(List<String> list_years, String inputYear, Integer diff){
        Integer index = 0;
        Boolean yearFind = false;
        String findYear = '';
        if(diff == 0) return inputYear;
        // move forward
        else if(diff > 0){
            for(String year: list_years){
                if(yearFind){
                    index++;
                }
                else{
                    if(inputYear == year) yearFind = true;
                }
                if(index == diff) {
                    return year;
                }
            }
        }
        // move backward
        else{
            for(Integer i=list_years.size()-1; i>=0; i--){
                if(yearFind){
                    index++;
                }
                else{
                    if(inputYear == list_years[i]) yearFind = true;
                }
                if(index == Math.abs(diff)) {
                    return list_years[i];
                }
            }
        }
        
        return findYear;
    }
           
    
    /**
    * The method is used to 
    *
    @author Bin yu
    @created 2012-03-03
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @
    *
    @        
    *
    @changelog
    * 2012-03-03 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static void buildStrucureItems(Opportunity oppy,List<Opportunity_Forecast__c> oppyForecasts,List<ClsOppForecastStructure.ForecastItemStructure> list_fcs){
        if(oppy.Level__c == ClsOppyForecastUtil.MONTHLY){
            buildMonthStructure(oppyForecasts, list_fcs);               
        }
        else if(oppy.Level__c == ClsOppyForecastUtil.QUARTERLY){
            buildQuarterStructure(oppyForecasts, list_fcs);             
        }   
        else{
            buildYearStructure(oppyForecasts, list_fcs);                
        }   
    
    }
    
    
    /**
    * The method is used to 
    *
    @author Bin yu
    @created 2012-03-03
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @
    *
    @        
    *
    @changelog
    * 2012-03-03 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    
    public static void buildYearStructure(List<Opportunity_Forecast__c> oppyForecasts, List<ClsOppForecastStructure.ForecastItemStructure> list_fcs){   
        list_fcs.clear();   
        ClsOppForecastStructure.ForecastItemStructure fcs = new ClsOppForecastStructure.ForecastItemStructure();
        fcs.quantity = 0;
        for(Opportunity_Forecast__c fc : oppyForecasts){
            if(fc.Quantity__c != null){
                if(fcs.quantity == null){
                    fcs.quantity = fc.Quantity__c;
                }
                else{
                    fcs.quantity += fc.Quantity__c;
                }
            }   
        }   
        list_fcs.add(fcs);      
    }
    
    /**
    * The method is used to 
    *
    @author Bin yu
    @created 2012-03-03
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @
    *
    @        
    *
    @changelog
    * 2012-03-03 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static void buildPartStrucureItems(Opportunity oppy,List<Opportunity_Forecast__c> oppyForecasts,List<Decimal> quantitys){
        if(oppy.Level__c == ClsOppyForecastUtil.MONTHLY){
            buildPartMonthStructure(oppyForecasts, quantitys);              
        }
        else if(oppy.Level__c == ClsOppyForecastUtil.QUARTERLY){
            buildPartQuarterStructure(oppyForecasts, quantitys);                
        }   
        else{
            buildPartYearStructure(oppyForecasts, quantitys);               
        }   
    
    }
    
    /**
    * The method is used to 
    *
    @author Bin yu
    @created 2012-03-03
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @
    *
    @        
    *
    @changelog
    * 2012-03-03 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static void buildMonthStructure(List<Opportunity_Forecast__c> oppyForecasts, List<ClsOppForecastStructure.ForecastItemStructure> list_fcs){
        for(Integer i = 1; i<=12; i++){
            ClsOppForecastStructure.ForecastItemStructure fcs = new ClsOppForecastStructure.ForecastItemStructure();
            fcs.quantity = 0;
            if(i <= oppyForecasts.size()) {
                Opportunity_Forecast__c forecast = oppyForecasts.get(i-1);
                if(forecast != null && forecast.Quantity__c != null) fcs.quantity = forecast.Quantity__c;
            }
            list_fcs.add(fcs);      
        }   
    }  
      
    /**
    * The method is used to 
    *
    @author Bin yu
    @created 2012-03-03
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @
    *
    @        
    *
    @changelog
    * 2012-03-03 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static void buildQuarterStructure(List<Opportunity_Forecast__c> oppyForecasts, List<ClsOppForecastStructure.ForecastItemStructure> list_fcs){
        for(Integer i = 1; i<=4; i++){  
            ClsOppForecastStructure.ForecastItemStructure fcs = new ClsOppForecastStructure.ForecastItemStructure();
            fcs.quantity = 0;
            if(i <= oppyForecasts.size()) {
                Opportunity_Forecast__c forecast = oppyForecasts.get(i-1);
                if(forecast != null && forecast.Quantity__c != null) fcs.quantity = forecast.Quantity__c;
            }
            list_fcs.add(fcs);      
        }
    }   
    
    /**
    * The method is used to 
    *
    @author Bin yu
    @created 2012-03-03
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @
    *
    @        
    *
    @changelog
    * 2012-03-03 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static void buildPartMonthStructure(List<Opportunity_Forecast__c> oppyForecasts, List<Decimal> quantitys){
        for(Integer i = 1; i<=12; i++){
            Decimal q = 0;
            if(i <= oppyForecasts.size()) {
                q = oppyForecasts.get(i-1).Quantity__c;
            }
            quantitys.add(q);       
        }   
    }
    
    /**
    * The method is used to 
    *
    @author Bin yu
    @created 2012-03-03
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @
    *
    @        
    *
    @changelog
    * 2012-03-03 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static void buildPartQuarterStructure(List<Opportunity_Forecast__c> oppyForecasts, List<Decimal> quantitys){
        for(Integer i = 1; i<=4; i++){  
            Decimal q = 0;
            if(i <= oppyForecasts.size()) {
                q = oppyForecasts.get(i-1).Quantity__c;
            }
            quantitys.add(q);       
        }
    }
    
    /**
    * The method is used to 
    *
    @author Bin yu
    @created 2012-03-03
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @
    *
    @        
    *
    @changelog
    * 2012-03-03 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static void buildPartYearStructure(List<Opportunity_Forecast__c> oppyForecasts, List<Decimal> quantitys){    
        Decimal q = 0;
        for(Opportunity_Forecast__c fc : oppyForecasts){
            if(fc.Quantity__c != null){
                q += fc.Quantity__c;
            }   
        }   
        quantitys.add(q);       
    }
    
    /**
    * The method is used to 
    *
    @author Bin yu
    @created 2012-03-03
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @
    *
    @        
    *
    @changelog
    * 2012-03-03 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static boolean checkConflict(Decimal scale, list<Decimal> pQs, List<ClsOppForecastStructure.ForecastItemStructure> list_fcs){
        boolean result = false;
        if(scale == null) scale = 0;
        for(integer i=0; i < pQs.size(); i++){
            //if(list_fcs.get(i).quantity != 0){
                //if(pQs.get(i) != 0 && list_fcs.get(i).quantity != pQs.get(i)/scale){
                Decimal pq = 0, oq = 0;
                if(pQs.get(i) != null) pq = pQs.get(i);
                if(list_fcs.get(i).quantity != null) oq = list_fcs.get(i).quantity;
                if(pq != oq * scale){                    
                    result = true;
                    break;
                }
            //}
            //else{
                //list_fcs.get(i).quantity = pQs.get(i)/scale;
            //}
        }
        return result;
    }
    /**
    * The method is used to 
    *
    @author Bin yu
    @created 2012-03-03
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @
    *
    @        
    *
    @changelog
    * 2012-03-03 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static void generateRevenueMap(){
        if(map_year_revApi == null){
            map_year_revApi = new map<string,string>();
            map_year_QTYApi = new map<string,string>();
            map_year_PRICEApi = new map<string,string>();
            String currentFiscalYear;
            for(Period p: [select FiscalYearSettingsId, FiscalYearSettings.Name from Period where type = 'Year' and FiscalYearSettings.IsStandardYear = false and startDate <= today and enddate >= today]){
                system.debug('p.FiscalYearSettings.Name' + p.FiscalYearSettings.Name);
                currentFiscalYear = p.FiscalYearSettings.Name;
                map_year_revApi.put(currentFiscalYear,'Current_Year__c');
                map_year_QTYApi.put(currentFiscalYear,'Current_Year_QTY__c');
                map_year_PRICEApi.put(currentFiscalYear,'Current_Year_PRICE__c');
                break;
            }
            
            for(integer i=-2; i<= 7; i++){
                string tempYear = String.valueOf(Integer.valueOf(currentFiscalYear) + i);
                if(i < 0){
                    map_year_revApi.put(tempYear,'Current_Year_minus_' + i*(-1) + '__c');
                    map_year_QTYApi.put(tempYear,'Current_Year_minus_' + i*(-1) + '_QTY__c');
                    map_year_PRICEApi.put(tempYear,'Current_Year_minus_' + i*(-1) + '_PRICE__c');
                }else if(i > 0){
                    map_year_revApi.put(tempYear,'Current_Year_add_' + i + '__c');
                    map_year_QTYApi.put(tempYear,'Current_Year_add_' + i + '_QTY__c');
                    map_year_PRICEApi.put(tempYear,'Current_Year_add_' + i + '_PRICE__c');
                }
            }
        }
    }
    
    /**
    * The method is used to get the Forecast_History__c as the oppyId
    *
    @author Lili Zhao
    @created 2013-10-17
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param             level
    *
    @return 
    *
    @changelog
    * 2013-10-17 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static  map<String,map<String, Forecast_History__c>> getPartForecastHistory(String oppId) {
        map<String,map <String, Forecast_History__c>> map_partId_map_fiscalYear_forecastHistory = new map<String,map <String, Forecast_History__c>>(); 
        for(Forecast_History__c forecastHistory: [Select Fiscal_Year__c, Part__c, New_Value__c, Old_Value__c, Part__r.Part__r.Name, Opportunity__c 
                                                  From Forecast_History__c  
                                                  where ((Opportunity__c = : oppId)
                                                        Or
                                                        (Opportunity__r.Program__c = :oppId)) and Part__c != null]) {
            if(!map_partId_map_fiscalYear_forecastHistory.containsKey(forecastHistory.Part__c)) {
                map_partId_map_fiscalYear_forecastHistory.put(forecastHistory.Part__c, new map<String, Forecast_History__c>());
            }
            map_partId_map_fiscalYear_forecastHistory.get(forecastHistory.Part__c).put(forecastHistory.Fiscal_Year__c,forecastHistory);                  
        }      
        return  map_partId_map_fiscalYear_forecastHistory;          
    }
    
    /**
    * The method is used to get the list of Forecast_History__c as the oppyId
    *
    @author Lili Zhao
    @created 2013-10-17
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param             level
    *
    @return 
    *
    @changelog
    * 2013-10-17 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static  list<Forecast_History__c> getListForecastHistory(String oppId) {
        list<Forecast_History__c> list_forecastHistory = new list<Forecast_History__c>(); 
        for(Forecast_History__c forecastHistory: [Select Fiscal_Year__c, New_Value__c, Part__c,Part__r.part_number__c, Old_Value__c, Part__r.Part__r.Name, Opportunity__c 
                                                  From Forecast_History__c  
                                                  where ((Opportunity__c = : oppId)
                                                        Or
                                                        (Opportunity__r.Program__c = :oppId)) and Part__c != null]) {
            list_forecastHistory.add(forecastHistory);                
        }      
        return  list_forecastHistory;          
    }
    /**
    * The method is used to get the users to send emails
    *
    @author Lili Zhao
    @created 2013-10-17
    @version 1.0
    @since 27.0 (Force.com ApiVersion)   
    *
    @param             
    *
    @return list_userEmails  
    *
    @changelog
    * 2013-10-17 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static list<String> getSendUserEmail(String oppId) {
        list<String> list_userEmails = new list<String>();
        Opportunity opp = (Opportunity) [Select PLM_Created_By_Id__c, id, Opportunity_Champion__c from Opportunity where id =: oppId];
        for(User user :[Select Te_Network_Id__c, Name,DelegatedApproverId,Email from User where (Te_Network_Id__c =: opp.PLM_Created_By_Id__c and Te_Network_Id__c != null) or (Te_Network_Id__c =: opp.Opportunity_Champion__c and Te_Network_Id__c != null) or (DelegatedApproverId =: opp.PLM_Created_By_Id__c and DelegatedApproverId != null) or (DelegatedApproverId =: opp.Opportunity_Champion__c and DelegatedApproverId != null)]) {
            list_userEmails.add(user.Email);
        }
        return list_userEmails;
    }
    /**
    * The method is used to upsert the Forecast_History__c
    *
    @author Bin Yuan
    @created 2013-10-17
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param             
    *
    @return void
    *
    @changelog
    * 2013-10-17 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */  
    
    //public static void updateForecastHistory(map<String,map<String, ExtOppyForecastEntryPage.ForecastHistoryStructure>> map_partId_map_fiscalYear_historyNew, String oppyId, String bu, decimal threshold, String oppName, String selectedReason, Boolean isSendEmail) {
     
    public static void updateForecastHistory(map<String,map<String, ExtOppyForecastEntryPage.ForecastHistoryStructure>> map_partId_map_fiscalYear_historyNew, Opportunity oppy, String bu, decimal threshold, String selectedReason) {
        //get all history
        map<String,map<String, Forecast_History__c>> map_partId_map_fiscalYear_historyExisting = new map<String,map<String, Forecast_History__c>>();
        list<Forecast_History__c> list_forecast2Upsert = new list<Forecast_History__c>(),
                                  list_forecast2Delete = new list<Forecast_History__c>(),
                                  list_forecast2Notify = new list<Forecast_History__c>();
        map<String, String> map_partId_partNumber = new map<String, String>();
        map<String, String> map_partId_partDescription = new map<String, String>();
        
        //map<String,Opportunity_Forecast__c> map_Id_OppForecastDel = new map<String,Opportunity_Forecast__c>();
        //map<String,Opportunity_Forecast__c> map_Id_OppForecastUpdate = new map<String,Opportunity_Forecast__c>();
        //map<String,Opportunity_Forecast__c> map_Id_OppForecast = new map<String,Opportunity_Forecast__c>();
        map<String, map<String, list<Opportunity_Forecast__c>>> map_partId_mapYearOppForecastDel = new map<String, map<String, list<Opportunity_Forecast__c>>>();
        map<String, map<String, list<Opportunity_Forecast__c>>> map_partId_mapYearOppForecastUpdate = new map<String, map<String, list<Opportunity_Forecast__c>>>();
        list<Opportunity_Forecast__c> list_updateOppForecast = new list<Opportunity_Forecast__c>();
        list<Forecast_History__c> list_AllOppForecastHis = new list<Forecast_History__c>();
        set<String> set_updateYears = new set<String>();
        set<String> set_delYears = new set<String>();
        set<String> set_updatePartIds = new set<String>();
        set<String> set_delPartIds = new set<String>();
        
        map_partId_map_fiscalYear_historyExisting = getPartForecastHistory(oppy.Id);  
        decimal changePercentage = 0;     
        //threshold = getThresholdFromSetting(bu);
        threshold = 0;
        //system.debug('map_partId_map_fiscalYear_historyNew::::'+map_partId_map_fiscalYear_historyNew);
        //system.debug('map_partId_map_fiscalYear_historyExisting ::::'+map_partId_map_fiscalYear_historyExisting+'threshold :::'+threshold);
        for(String partId : map_partId_map_fiscalYear_historyNew.keySet()) {
            //if no history, create a new history data 
            if(!map_partId_map_fiscalYear_historyExisting.containsKey(partId)) {
                for(String fiscalYear : map_partId_map_fiscalYear_historyNew.get(partId).keySet()) {
                    ExtOppyForecastEntryPage.ForecastHistoryStructure forecastClsObj = map_partId_map_fiscalYear_historyNew.get(partId).get(fiscalYear);
                    if(forecastClsObj.newValue != forecastClsObj.oldValue) {
                        Forecast_History__c history = new Forecast_History__c();
                        copyHistoryData(forecastClsObj, history, partId, oppy.Id, list_forecast2Upsert, list_forecast2Notify, map_partId_partNumber, threshold,set_updateYears,set_updatePartIds);                   
                    }                   
                }    
            }
            else {  
                for(String fiscalYear : map_partId_map_fiscalYear_historyNew.get(partId).keySet()) {
                    //if no history, create a new history data
                    if(!map_partId_map_fiscalYear_historyExisting.get(partId).containsKey(fiscalYear)) {
                        ExtOppyForecastEntryPage.ForecastHistoryStructure forecastClsObj = map_partId_map_fiscalYear_historyNew.get(partId).get(fiscalYear);
                            if(forecastClsObj.newValue != forecastClsObj.oldValue) {
                                Forecast_History__c history = new Forecast_History__c();
                                copyHistoryData(forecastClsObj, history, partId, oppy.Id, list_forecast2Upsert, list_forecast2Notify, map_partId_partNumber, threshold,set_updateYears,set_updatePartIds);
                            }
                     }
                    else {       
                        ExtOppyForecastEntryPage.ForecastHistoryStructure forecastClsObj = map_partId_map_fiscalYear_historyNew.get(partId).get(fiscalYear) ;
                        Forecast_History__c history = map_partId_map_fiscalYear_historyExisting.get(partId).get(fiscalYear);
                        //if old == new value delete existing history
                        if(forecastClsObj.newValue == forecastClsObj.oldValue) {
                            list_forecast2Delete.add(history);
                            list_forecast2Notify.add(history); 
                            set_delYears.add(fiscalYear);
                            set_delPartIds.add(partId);
                        }
                        else {
                            // add lili begin 
                            if(forecastClsObj.oldValue != 0 && forecastClsObj.newValue != 0) {
                                decimal changeage = Math.abs(forecastClsObj.oldValue - forecastClsObj.newValue);
                                changePercentage = changeage/forecastClsObj.oldValue;
                            }else {
                                changePercentage = 1;
                            }
                            if(changePercentage != 0 && changePercentage < threshold){
                                list_forecast2Delete.add(history);
                                list_forecast2Notify.add(history);
                                set_delYears.add(fiscalYear);
                                set_delPartIds.add(partId);
                            }
                            if (changePercentage != 0 && changePercentage >= threshold) {
                                //if(history.New_Value__c != forecastClsObj.newValue) {
                                    history.New_Value__c = forecastClsObj.newValue;
                            // add lili end
                                    list_forecast2Upsert.add(history); 
                                    list_forecast2Notify.add(history);
                                    map_partId_partNumber.put(history.Part__c, null); 
                                    set_updateYears.add(fiscalYear);
                                    set_updatePartIds.add(partId);
                                //}
                            }                           
                            //always reset isReject to false
                            //history.Is_Reject__c = false;                                                     
                        }                        
                    }
                }
            }
        }
        if(!map_partId_partNumber.isEmpty()) {
            for(Opportunity_Part__c part : [select Id, part_number__c,Item_Description__c from Opportunity_Part__c where Id IN : map_partId_partNumber.keySet()]) {
                map_partId_partNumber.put(part.Id, part.part_number__c);
                map_partId_partDescription.put(part.Id,part.Item_Description__c);
            }
        }
        //get users who receive notification mail and history data
        //UPSERT DATA BASE
        // add lili 2013.10.16 begin 
        // if the Forecast_History__c of  Opportunity_Forecast__c was deleted,the value of IsLocked__c will change to true
        if(!list_forecast2Delete.isEmpty()) {          
            map_partId_mapYearOppForecastDel = getMapOppForecast(set_delYears,set_delPartIds);
            //system.debug('map_partId_mapYearOppForecastDel:::'+map_partId_mapYearOppForecastDel );
            //system.debug('list_forecast2Delete:::'+list_forecast2Delete);
            for(Forecast_History__c forecastHistory:  list_forecast2Delete) {                                                           
                if(map_partId_mapYearOppForecastDel.containsKey(forecastHistory.Part__c) && map_partId_mapYearOppForecastDel.get(forecastHistory.Part__c).containsKey(forecastHistory.Fiscal_Year__c) && map_partId_mapYearOppForecastDel.get(forecastHistory.Part__c).get(forecastHistory.Fiscal_Year__c).size() > 0) {                                
                    for(Opportunity_Forecast__c oppForecast:map_partId_mapYearOppForecastDel.get(forecastHistory.Part__c).get(forecastHistory.Fiscal_Year__c)) {
                        oppForecast.IsLocked__c = false;
                        list_updateOppForecast.add(oppForecast);   
                    }               
                }
            }                                                                                      
          try{
                delete list_forecast2Delete;
            }   
            catch(Exception ex){
                ApexPages.addMessages(ex);          
            }
            // begin change the oppy Email_Send__c  field to false if have no Forecast_History__c
            for(Forecast_History__c forecastHistory : [select Id, Part__r.Name, Part__r.Part_Number__c, Part__c, Fiscal_Year__c,Old_Value__c, New_Value__c, Opportunity__c  
                                                       From Forecast_History__c 
                                                       Where ((Opportunity__c = : oppy.Id)
                                                            Or
                                                            (Opportunity__r.Program__c = :oppy.Id)) and Part__c != null ]) {
                list_AllOppForecastHis.add(forecastHistory);
                       
            }
            if(list_AllOppForecastHis.size() == 0) {
                list<FeedItem> list_posts = new list<FeedItem>();
                for(FeedItem post : [select id,ParentId from FeedItem  where ParentId =: oppy.Id]) {
                    list_posts.add(post);
                }
                Opportunity opp = ClsOppyForecastUtil.getOpportunityById(oppy.Id);
                opp.Email_Send__c = false;
                try{
                     if(list_posts.size() > 0) delete list_posts;               
                     update opp;
                }   
                catch(Exception ex){
                    ApexPages.addMessages(ex);          
                }
               
            }
        // end change the oppy Email_Send__c  field to false if have no Forecast_History__c    
        }
        // if the Opportunity_Forecast__c have Forecast_History__c,the value of IsLocked__c will change to fasle
        if(!list_forecast2Upsert.isEmpty()) {
            upsert list_forecast2Upsert;
            map_partId_mapYearOppForecastUpdate = getMapOppForecast(set_updateYears,set_updatePartIds);    
            //system.debug('map_partId_mapYearOppForecastUpdate :::'+map_partId_mapYearOppForecastUpdate );
            //system.debug('list_forecast2Upsert:::'+list_forecast2Upsert);      
            for(Forecast_History__c forecastHistory:  list_forecast2Upsert) {                                                           
                if(map_partId_mapYearOppForecastUpdate.containsKey(forecastHistory.Part__c) && map_partId_mapYearOppForecastUpdate.get(forecastHistory.Part__c).containsKey(forecastHistory.Fiscal_Year__c) && map_partId_mapYearOppForecastUpdate.get(forecastHistory.Part__c).get(forecastHistory.Fiscal_Year__c).size() > 0) {                               
                    for(Opportunity_Forecast__c oppForecast:map_partId_mapYearOppForecastUpdate.get(forecastHistory.Part__c).get(forecastHistory.Fiscal_Year__c)) {
                        oppForecast.IsLocked__c = true;
                        list_updateOppForecast.add(oppForecast);   
                    }               
                }
            }                                                                                      
        }       
        // update the changed  Opportunity_Forecast__c
        if(!list_updateOppForecast.isEmpty()) {      
           try{
                 Database.update(list_updateOppForecast, false);         
            }   
            catch(Exception ex){
                ApexPages.addMessages(ex);          
            }   
        }
        
        if(!list_forecast2Notify.isEmpty() && !oppy.Email_Send__c) {           
            //sentForecastApprovalNotification(list_forecast2Upsert,oppy.Id,list_forecast2Delete,map_partId_partNumber,map_partId_partDescription,oppy.Name, selectedReason);
            sentForecastApprovalNotification(list_forecast2Upsert,oppy,list_forecast2Delete,map_partId_partNumber,map_partId_partDescription, selectedReason);
        }
        // add lili 2013.10.16 end 
    }
    
    /**
    * The method is used to get the Opportunity_Forecast__c
    *
    @author lili zhao
    @created 2013-10-28
    @version 1.0  
    @since 27.0 (Force.com ApiVersion)
    *
    @param    
    *
    @return  boolean              
    * 
    @changelog
    * 2013-10-28 lili zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static map<String,map<String,list<Opportunity_Forecast__c>>> getMapOppForecast(set<String> set_years, set<String> set_partIds) {
        map<String,map<String,list<Opportunity_Forecast__c>>> map_partId_mapYearOppForecast = new map<String,map<String,list<Opportunity_Forecast__c>>>();
        //map<String,Opportunity_Forecast__c> map_Id_OppForecast = new map<String,Opportunity_Forecast__c>();
        for(Opportunity_Forecast__c oppForecast : [SELECT Opportunity__c, Id, Fiscal_Year__c, Part__c, IsLocked__c FROM Opportunity_Forecast__c where Part__c IN : set_partIds and Fiscal_Year__c IN : set_years ]){                                         
            //map_Id_OppForecast.put(oppForecast.Id, oppForecast); 
            if(!map_partId_mapYearOppForecast.containsKey(oppForecast.Part__c)){
                map_partId_mapYearOppForecast.put(oppForecast.Part__c, new map<String, list<Opportunity_Forecast__c>>());                
            }
            if(!map_partId_mapYearOppForecast.get(oppForecast.Part__c).containsKey(oppForecast.Fiscal_Year__c)) {
                map_partId_mapYearOppForecast.get(oppForecast.Part__c).put(oppForecast.Fiscal_Year__c,new list<Opportunity_Forecast__c>()); 
            }
            map_partId_mapYearOppForecast.get(oppForecast.Part__c).get(oppForecast.Fiscal_Year__c).add(oppForecast);
        }
        return map_partId_mapYearOppForecast;
    }
    /**
    * The method is used to check the bu is IND , Appliances or other
    *
    @author lili zhao
    @created 2013-10-15
    @version 1.0  
    @since 27.0 (Force.com ApiVersion)
    *
    @param    
    *
    @return  boolean          
    *
    @changelog
    * 2013-10-15 lili zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static Boolean isAppOrIndBu(String BU) {
        Boolean isAppOrIndBu;
        // modify by lili zhao 2014.04.10 begin due to approve only for applian BU
        //if(BU == 'IND' || BU == 'Appliances') {
        if(BU == 'Appliances') {
        // modify by lili zhao 2014.04.10 end due to approve only for applian BU
            isAppOrIndBu = true;
        }else{
            isAppOrIndBu = false;
        }
        return isAppOrIndBu;
    } 
    /**
    * The method is used to get the changePercentage as the BU type
    *
    @author lili zhao
    @created 2013-10-15
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param    
    *
    @return  boolean          
    *
    @changelog
    * 2013-10-15 lili zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static decimal getChangePercentage(String BU){
        decimal changePercentage;
        //changePercentage = getThresholdFromSetting(BU);
        changePercentage = 0;
        return changePercentage;
    }   
    /**
    * The method is used to get the BU type
    *
    @author Lili Zhao
    @created 2013-10-17
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param             
    *
    @return BU
    *
    @changelog
    * 2013-10-17 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static String getBU(Opportunity opp) {
        String BU;
        if(map_BU_IND.containsKey(opp.Industry_Code__c)) {
            BU = 'IND'; 
        }else if(map_BU_Appliances.containsKey(opp.Industry_Code__c)) {
            BU = 'Appliances';
        }else{
            BU = 'other';
        }
        return BU;
    }
    /**
    * The method is used to save the changed value,as the opportunityForecastHistory
    *
    @author lili zhao
    @created 2013-10-15
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param    
    *
    @return            
    *
    @changelog
    * 2013-10-15 lili zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static String getOppyForecastHistory(String oppId) {
        map<String,list<ExtOppyForecastEntryPage.ForecastHistoryStructure>> map_partId_list_ForecastHistoryStructure = new map<String,list<ExtOppyForecastEntryPage.ForecastHistoryStructure>>();
        for(Forecast_History__c forecastHistory : [select Id, Part__r.Name, Part__r.Part_Number__c, Part__c, Fiscal_Year__c,Old_Value__c, New_Value__c, Opportunity__c  
                                                   From Forecast_History__c 
                                                   where ((Opportunity__c = : oppId)
                                                        Or
                                                        (Opportunity__r.Program__c = :oppId)) and Part__c != null 
                                                   order by Fiscal_Year__c ASC]) {     
            if(!map_partId_list_ForecastHistoryStructure.containsKey(forecastHistory.Part__c)){
                map_partId_list_ForecastHistoryStructure.put(forecastHistory.Part__c,new list<ExtOppyForecastEntryPage.ForecastHistoryStructure>());                
            } 
            ExtOppyForecastEntryPage.ForecastHistoryStructure  forhisStr = new  ExtOppyForecastEntryPage.ForecastHistoryStructure(forecastHistory.Fiscal_Year__c,forecastHistory.New_Value__c,forecastHistory.Old_Value__c);                         
            map_partId_list_ForecastHistoryStructure.get(forecastHistory.Part__c).add(forhisStr);        
        }
        String str_mapPartId_listForecastHistoryStructure = JSON.serialize(map_partId_list_ForecastHistoryStructure);                
        return str_mapPartId_listForecastHistoryStructure;
    }
    
    /**
    * The method is used to save the changed value,as the opportunityForecastHistory
    *
    @author lili zhao
    @created 2013-10-15
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param    
    *
    @return            
    *
    @changelog
    * 2013-10-15 lili zhao <lili.zhao@itbconsult.com>
    * - Created
    */ 
   
    public static void saveOppForecastHitory(String str_mapPartId_listForecastHistoryStructure,Opportunity opp, String selectedReason){
        try{
            map<String,map<String,ExtOppyForecastEntryPage.ForecastHistoryStructure>> map_partId_map_fiscalYear_historyNew = new map<String,map<String,ExtOppyForecastEntryPage.ForecastHistoryStructure>>();
            map<String,list<ExtOppyForecastEntryPage.ForecastHistoryStructure>> map_partId_list_ForecastHistoryStructure = new map<String,list<ExtOppyForecastEntryPage.ForecastHistoryStructure>>();
            Map<Id, String> map_parts = new Map<Id, String>();
            String bu = '';
            decimal threshold;
            map_partId_list_ForecastHistoryStructure = (map<String,list<ExtOppyForecastEntryPage.ForecastHistoryStructure>>) JSON.deserializeStrict(str_mapPartId_listForecastHistoryStructure, map<String,list<ExtOppyForecastEntryPage.ForecastHistoryStructure>>.class);
            String buType = getBU(opp);
            if(buType == 'Appliances') {
                bu = 'Appliances';
            }
            if(bu != '') {
                for(String partId : map_partId_list_ForecastHistoryStructure.keyset()) {
                    if(map_partId_list_ForecastHistoryStructure.get(partId).size() > 0) {
                        if(!map_partId_map_fiscalYear_historyNew.containsKey(partId)) {
                            map_partId_map_fiscalYear_historyNew.put(partId,new map<String,ExtOppyForecastEntryPage.ForecastHistoryStructure>());
                        }                      
                        for(ExtOppyForecastEntryPage.ForecastHistoryStructure forHisStr : map_partId_list_ForecastHistoryStructure.get(partId)) {                    
                            map_partId_map_fiscalYear_historyNew.get(partId).put(forHisStr.fiscalYear,forHisStr);
                        }
                    }
                }
                if(!map_partId_map_fiscalYear_historyNew.isEmpty()) {  
                    //updateForecastHistory(map_partId_map_fiscalYear_historyNew, opp.Id, bu,threshold,opp.Name, selectedReason,opp.Email_Send__c);
                    updateForecastHistory(map_partId_map_fiscalYear_historyNew, opp, bu,threshold,selectedReason);
                }
                
            }   
        }catch(exception ex){
            ApexPages.addMessages(ex);
        }    
    }
    /**
    * The method is used to send the emails
    *
    @author lili zhao
    @created 2013-10-15
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param    
    *
    @return            
    *
    @changelog
    * 2013-10-15 lili zhao <lili.zhao@itbconsult.com>
    * - Created
    */ 
    //public static void sentForecastApprovalNotification(list<String> list_userEmails, list<Forecast_History__c> list_forecast2Upsert, list<Forecast_History__c> list_forecast2Delete,map<String, String> map_partId_partNumber) {
    //public static void sentForecastApprovalNotification(list<Forecast_History__c> list_forecast2Upsert,String oppId, list<Forecast_History__c> list_forecast2Delete, map<String, String> map_partId_partNumber,map<String, String> map_partId_partDescription,String oppName, String selectedReason) {
    
    public static void sentForecastApprovalNotification(list<Forecast_History__c> list_forecast2Upsert,Opportunity oppy, list<Forecast_History__c> list_forecast2Delete, map<String, String> map_partId_partNumber,map<String, String> map_partId_partDescription,String selectedReason) {
    
        //String OpportunityId;  
        String emailBody = '';
        String deleteEmailBody = '';
        List<forecastHistoryInfos> list_forecastHistoryInfos = new List<forecastHistoryInfos>();
        list<String> list_years = new list<String>();    
        set<String> set_years = new set<String>();
        map<String,map<String,String>> map_partId_mapOldNewValue = new map<String,map<String,String>>();
        map<String,String> map_partNumber_partDescription = new map<String,String>();
        
        // add lili 2013.10.17
        list<String> list_userEmails = new list<String>();
        list_userEmails = getSendUserEmail(oppy.Id);
        //list_userEmails.add('lili.zhao@itbconsult.com');// test
        //list_userEmails.add('bin.yuan@itbconsult.com'); // test
        //list_userEmails.add('bin.yu@itbconsult.com'); // test
        //list_userEmails.add('eric_wu@te.com'); // test  
        // add lili 2013.10.17
        if(list_userEmails.isEmpty()) {
            return;
        }
        //Generate upsert history table
        if(!list_forecast2Upsert.isEmpty()) {
            emailBody = '<br><div>Your Forecast of Opportunity \'' + oppy.Name + '\' has been changged!</div><br><div> The updated forecast will not be sent to Program Central until you have confirmed this change.</div><br>';
            emailBody += '<div><table border=\'1\'><tr><th>&nbsp;&nbsp;Part Number&nbsp;&nbsp;</th><th width=\'200px\'>&nbsp;&nbsp;Description&nbsp;&nbsp;</th>';   
            for(Forecast_History__c fcHistory : list_forecast2Upsert) {
                set_years.add(fcHistory.Fiscal_Year__c);
                String partNumber = ((map_partId_partNumber.containsKey(fcHistory.Part__c) && map_partId_partNumber.get(fcHistory.Part__c) != null) ? map_partId_partNumber.get(fcHistory.Part__c) : 'Part Id : ' + fcHistory.Part__c);
                if(!map_partId_mapOldNewValue.containsKey(partNumber)){
                    map_partId_mapOldNewValue.put(partNumber, new map<String, String>());                
                }                       
                String value =  fcHistory.New_Value__c + ' / ' + fcHistory.Old_Value__c;            
                map_partId_mapOldNewValue.get(partNumber).put(fcHistory.Fiscal_Year__c, value); 
                if(map_partId_partDescription.get(fcHistory.Part__c) != null) {
                    map_partNumber_partDescription.put(partNumber,map_partId_partDescription.get(fcHistory.Part__c)); 
                } else {
                    map_partNumber_partDescription.put(partNumber,' ');
                }     
            }
            list_years.addAll(set_years);
            list_years.sort();  
            for(String year : list_years) {    
                for(String oppPart : map_partId_mapOldNewValue.keySet()) {
                    if(!map_partId_mapOldNewValue.get(oppPart).containsKey(year)) {
                        //Forecast_History__c forecastHistoryNew = new Forecast_History__c();
                        //forecastHistoryNew.Old_Value__c = 0;
                        //forecastHistoryNew.New_Value__c = 0;
                        map_partId_mapOldNewValue.get(oppPart).put(year, '0 / 0');
                    }
                }
            }
            for(String str:list_years) {
                emailBody += '<th>&nbsp;&nbsp;' + str + '&nbsp;&nbsp;</th>';
            }
            emailBody += '</tr><tr>';
            for(String strPartNum : map_partId_mapOldNewValue.keySet()) { 
                emailBody += '<td>&nbsp;&nbsp;' + strPartNum + '&nbsp;&nbsp;</td>';  
                emailBody += '<td>&nbsp;&nbsp;' + map_partNumber_partDescription.get(strPartNum) + '&nbsp;&nbsp;</td>';    
                for(String strYear:list_years) {
                    if(map_partId_mapOldNewValue.get(strPartNum).containsKey(strYear)) {
                        emailBody += '<td>&nbsp;&nbsp;' + map_partId_mapOldNewValue.get(strPartNum).get(strYear) + '&nbsp;&nbsp;</td>';
                    }
                } 
                emailBody += '</tr>';
            }
            emailBody += '</table></div><br><div>*(New Value/Old Value)</div><br>'; 
            emailBody += 'Click here to view/confirm the change: <a href=' + URL.getSalesforceBaseUrl().toExternalForm() +'/apex/ExtOpportunityForecastHistory?id=' + Oppy.Id + '>' +  ' View' +'</a>' + '<br><br>Best regards,<br>System Administrator';    
        }
        //if upsert table is null then generate change back message
        else if(!list_forecast2Delete.isEmpty()) {
            emailBody = '<br><div>Your Forecast of Opportunity \'' + oppy.Name + '\' has change to old value,please notice!<br><br>Best regards,<br>System Administrator';  
        }
        if(emailBody != '') {
        //send email Begin   
        Messaging.SingleEmailMessage  mail = new Messaging.SingleEmailMessage ();
        String emailSubject = 'Your value of Opportunity \"' + oppy.Name + '\" was changed';                           
        mail.setToAddresses(list_userEmails);       
        //mail.setHtmlBody('Dear ' + user.Name + ',<br>' + emailBody);
        mail.setHtmlBody('Dear,<br>' + emailBody);
        mail.setSubject(emailSubject);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                  
        //send email End 
                    
        //add chatter post Begin   
        FeedItem post = new FeedItem();
        post.ParentId = Oppy.Id; 
        if(selectedReason != null || selectedReason != '') {
            post.body = 'Forecast change reason : ' + selectedReason;   
        }    
        post.Title = 'Here to view the change';      
        post.LinkUrl = URL.getSalesforceBaseUrl().toExternalForm() +'/apex/ExtOpportunityForecastHistory?id=' + Oppy.Id;      
        insert post;                                
        // add chatter post END  
        // set the Email_Send__c to true  begin
        oppy.Email_Send__c = true;
        update oppy;
        // set the Email_Send__c to true  end
        }
    }
    /**
    * The method is used to get the body
    *
    @author lili zhao
    @created 2013-10-15
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param    
    *
    @return            
    *
    @changelog
    * 2013-10-15 lili zhao <lili.zhao@itbconsult.com>
    * - Created
    */        
    public static String getDeleteBody(Forecast_History__c forecastHistory,String emailBody,map<String, String> map_partId_partNumber) {
        String deleteEmailBody = ''; 
        if(emailBody == '') {
            deleteEmailBody = forecastHistory.Fiscal_Year__c + ':' +  map_partId_partNumber.get(forecastHistory.Part__c);
        }else {
            deleteEmailBody = emailBody + ', ' + forecastHistory.Fiscal_Year__c + ':'+ map_partId_partNumber.get(forecastHistory.Part__c);
        }
        return deleteEmailBody;
    } 
    /**
    * The method is used to get forecast change reasons
    *
    @author lili zhao
    @created 2013-10-15
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param    
    *
    @return            
    *
    @changelog
    * 2013-10-15 lili zhao <lili.zhao@itbconsult.com>
    * - Created
    */        
    public static void getChangeReasons(list<String> list_changeReasons) {
        if(Forecast_History_Config__c.getInstance('Forecast Change Reason') != null && Forecast_History_Config__c.getInstance('Forecast Change Reason').Value__c != null ) {
            String reasons = (String) Forecast_History_Config__c.getInstance('Forecast Change Reason').value__c;
            for(String reason : reasons.split(',')) {
                list_changeReasons.add(reason.trim());
            }
        }
    } 
    
    /**
    * The method is used to update the POS Amount and Direct Amount fields for the newly Opportunity Forecast records
    *
    @author Jinbo Shan
    @created 2014-11-19
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param    
    *
    @return            
    *
    @changelog
    * 2014-11-19 Jinbo Shan <jinbo.shan@itbconsult.com>
    * - Created
    */ 
    @future 
    public static void updateNewlyOppyForecast(Id oppyId, set<string> set_fisicalYears) {
        
        list<Forecast_Billing__c> list_fbs2update = new list<Forecast_Billing__c>();
        list<Opportunity> list_oppys2update = new list<Opportunity>();
        map<Date, Date> map_sDate_eDate4Quarter = new map<Date, Date>();
        map<Date, set<Date>> map_sDate_set_monthTypeDates = new map<Date, set<Date>>();
        
        getAllMonthMapOrderByQuarter(map_sDate_eDate4Quarter, map_sDate_set_monthTypeDates, set_fisicalYears);//
        
        system.debug('**@@ map_sDate_set_monthTypeDates = ' + map_sDate_set_monthTypeDates);
        
        map<Id, map<Date, Opportunity_Forecast__c>> map_key_ofcDate_ofc = new map<Id, map<Date, Opportunity_Forecast__c>>();
        map<Date, set<Date>> map_ofcDate_set_ofcDates = new map<Date, set<Date>>();
        set<Date> set_ofcDates = new set<Date>();
        for(Opportunity_Forecast__c oppyForecast : [select Id, CurrencyIsoCode, Opportunity__c, 
                                                    Opportunity__r.AccountId, Part__r.Part__c, Part__c, 
                                                    Date__c, POS_Amount__c, Direct_Amount__c, Opportunity__r.Level__c 
                                                    from Opportunity_Forecast__c where Opportunity__c = :oppyId 
                                                    //and Part__r.Part__c != null
                                                    //change is required for case 901133
                                                    and RecordType.Name!= 'Opportunity'
                                                    and Part__c!= null
                                                    and Fiscal_Year__c IN :set_fisicalYears]) {
            //string keyPre = string.valueOf(oppyForecast.Opportunity__r.AccountId).subString(0, 15) + '_' + string.valueOf(oppyForecast.Opportunity__c).subString(0, 15) + '_' +  string.valueOf(oppyForecast.Part__r.Part__c).subString(0, 15);
            if(!map_key_ofcDate_ofc.containsKey(oppyForecast.Part__c)) {
                map_key_ofcDate_ofc.put(oppyForecast.Part__c, new map<Date, Opportunity_Forecast__c>());
            }
            if(!map_key_ofcDate_ofc.get(oppyForecast.Part__c).containsKey(oppyForecast.Date__c)) {
                map_key_ofcDate_ofc.get(oppyForecast.Part__c).put(oppyForecast.Date__c, oppyForecast);
            }
            set_ofcDates.add(oppyForecast.Date__c);
            
            if(oppyForecast.Opportunity__r.Level__c == 'Quarterly' || oppyForecast.Opportunity__r.Level__c == 'Yearly') {
                if(!map_ofcDate_set_ofcDates.containsKey(oppyForecast.Date__c)) {
                    map_ofcDate_set_ofcDates.put(oppyForecast.Date__c, new set<Date>());
                }
                if(map_sDate_set_monthTypeDates.containsKey(oppyForecast.Date__c)) {
                    for(Date next2MonthDate : map_sDate_set_monthTypeDates.get(oppyForecast.Date__c)) {
                        set_ofcDates.add(next2MonthDate);
                        map_ofcDate_set_ofcDates.get(oppyForecast.Date__c).add(next2MonthDate);
                    }
                }
            }
        }
        for(Forecast_Billing__c fb : [select Id, Opportunity_Forecast__c, CurrencyIsoCode, Date__c, 
                                     Bill_Type__c, acc_opp_part__c, POS_Amount__c, Direct_Amount__c, Opportunity_Part__c 
                                     from Forecast_Billing__c 
                                     where Opportunity_Part__c IN : map_key_ofcDate_ofc.keySet() and 
                                     Date__c IN :set_ofcDates]) {
            if(map_key_ofcDate_ofc.get(fb.Opportunity_Part__c).containsKey(fb.Date__c)) {
                calculateOpporforecastAmountAndReparent(map_key_ofcDate_ofc, fb.Opportunity_Part__c, fb.Date__c, fb);
            }else {
                for(Date dateTemp : map_ofcDate_set_ofcDates.keySet()) {
                    if(map_ofcDate_set_ofcDates.get(dateTemp).contains(fb.Date__c) && map_key_ofcDate_ofc.get(fb.Opportunity_Part__c).containsKey(dateTemp)) {
                        calculateOpporforecastAmountAndReparent(map_key_ofcDate_ofc, fb.Opportunity_Part__c, dateTemp, fb);
                    }
                }
            }
            
            list_fbs2update.add(fb);
        }
        
        //added by Jinbo Shan 2015-11-25
        /*map<Id, map<Date, set<Forecast_Billing__c>>> map_opId_date_set_fbs = new map<Id, map<Date, set<Forecast_Billing__c>>>();
        set<Date> set_ofcDate = new set<Date>();
        for(Forecast_Billing__c fb : [select Id, Opportunity_Forecast__c, CurrencyIsoCode, Date__c, 
                                     Bill_Type__c, acc_opp_part__c, POS_Amount__c, Direct_Amount__c, 
                                     Opportunity_Part__c 
                                     from Forecast_Billing__c 
                                     where Opportunity_Part__r.Opportunity__c = :oppyId 
                                     and Opportunity_Forecast__c = null 
                                     and Opportunity_Part__r.Part__c = null]) {
            if (!map_opId_date_set_fbs.containsKey(fb.Opportunity_Part__c)) {
                map_opId_date_set_fbs.put(fb.Opportunity_Part__c, new map<Date, set<Forecast_Billing__c>>());
            }
            if (!map_opId_date_set_fbs.get(fb.Opportunity_Part__c).containsKey(fb.Date__c)) {
                map_opId_date_set_fbs.get(fb.Opportunity_Part__c).put(fb.Date__c, new set<Forecast_Billing__c>());
            }
            map_opId_date_set_fbs.get(fb.Opportunity_Part__c).get(fb.Date__c).add(fb);
            set_ofcDate.add(fb.Date__c);
        }
         
        for(Opportunity_Forecast__c oppyForecast : [select Id, CurrencyIsoCode, Opportunity__c, 
                                                    Opportunity__r.AccountId, Part__r.Part__c, 
                                                    Date__c, POS_Amount__c, Direct_Amount__c, Opportunity__r.Level__c 
                                                    from Opportunity_Forecast__c where Part__c IN :map_opId_date_set_fbs.keySet() 
                                                    and Date__c IN :set_ofcDate 
                                                    and Fiscal_Year__c IN :set_fisicalYears]) {
            if(map_opId_date_set_fbs.containsKey(oppyForecast.Part__c) && map_opId_date_set_fbs.get(oppyForecast.Part__c).containsKey(oppyForecast.Date__c)) {
                for (Forecast_Billing__c fb : map_opId_date_set_fbs.get(oppyForecast.Part__c).get(oppyForecast.Date__c)) {
                    fb.Opportunity_Forecast__c = oppyForecast.Id;
                    list_fbs2update.add(fb);
                }
            }
        }*/
         
        //end
        //Start: Commented by Rajendra on 02-22-2016 for case 00900667
        /*for(Opportunity oppy : [select Id, Opportunity_Forecast_Recalculation__c from Opportunity where Id = :oppyId]) {
            if(oppy.Opportunity_Forecast_Recalculation__c) {
                oppy.Opportunity_Forecast_Recalculation__c = false;
                list_oppys2update.add(oppy);
            }
        }*/
        //end: Commented by Rajendra on 02-22-2016 for case 00900667
        
        list<Opportunity_Forecast__c> list_ofcs4update = new list<Opportunity_Forecast__c>();
        system.debug('**@@list_fbs2update = ' + list_fbs2update);
        if(list_fbs2update.size() > 0) {
            update list_fbs2update;
        }
        for(Id keyv : map_key_ofcDate_ofc.keySet()) {
            list_ofcs4update.addAll(map_key_ofcDate_ofc.get(keyv).values());
        }
        if(list_ofcs4update.size() > 0) {
            update list_ofcs4update;
        }
        //Start: Commented by Rajendra on 02-22-2016 for case 00900667
        /*if(list_oppys2update.size() > 0) {
            update list_oppys2update;
        }*/
        //End: Commented by Rajendra on 02-22-2016 for case 00900667
    }
    /**
    * The method is used to calculate Opportunity Forecast direct and pos amount.Fill the opportunity forecast field of the forecast billing.
    *
    @author Jinbo Shan
    @created 2014-11-19
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param    
    *
    @return            
    *
    @changelog
    * 2014-11-19 Jinbo Shan <jinbo.shan@itbconsult.com>
    * - Created
    */ 
    public static void calculateOpporforecastAmountAndReparent(map<Id, map<Date, Opportunity_Forecast__c>> map_key_ofcDate_ofc, Id key, Date dateTemp, Forecast_Billing__c fb) {
        if(fb.Direct_Amount__c != null) {
            map_key_ofcDate_ofc.get(key).get(dateTemp).Direct_Amount__c = (map_key_ofcDate_ofc.get(key).get(dateTemp).Direct_Amount__c != null) ? map_key_ofcDate_ofc.get(key).get(dateTemp).Direct_Amount__c + ClsOppyUtil.transformIsoCode(fb.Direct_Amount__c, fb.CurrencyIsoCode, map_key_ofcDate_ofc.get(key).get(dateTemp).CurrencyIsoCode) : ClsOppyUtil.transformIsoCode(fb.Direct_Amount__c, fb.CurrencyIsoCode, map_key_ofcDate_ofc.get(key).get(dateTemp).CurrencyIsoCode);
        }
        if(fb.POS_Amount__c != null) {
            map_key_ofcDate_ofc.get(key).get(dateTemp).POS_Amount__c = (map_key_ofcDate_ofc.get(key).get(dateTemp).POS_Amount__c != null) ? map_key_ofcDate_ofc.get(key).get(dateTemp).POS_Amount__c + ClsOppyUtil.transformIsoCode(fb.POS_Amount__c, fb.CurrencyIsoCode, map_key_ofcDate_ofc.get(key).get(dateTemp).CurrencyIsoCode) : ClsOppyUtil.transformIsoCode(fb.POS_Amount__c, fb.CurrencyIsoCode, map_key_ofcDate_ofc.get(key).get(dateTemp).CurrencyIsoCode);
        }
        fb.Opportunity_Forecast__c = map_key_ofcDate_ofc.get(key).get(dateTemp).Id;
    }
     /**
    * The method is used to get all month to map order by quarter that should be reparent.
    *
    @author Jinbo Shan
    @created 2014-11-19
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param    
    *
    @return            
    *
    @changelog
    * 2014-11-19 Jinbo Shan <jinbo.shan@itbconsult.com>
    * - Created
    */ 
    public static void getAllMonthMapOrderByQuarter(map<Date, Date> map_sDate_eDate4Quarter, map<Date, set<Date>> map_sDate_set_monthTypeDates, set<string> set_fisicalYears){
        for(Period p : [select Id, StartDate, EndDate, Type from Period where FiscalYearSettings.Name IN :set_fisicalYears and (Type = 'Quarter' or Type = 'Month') order by Type desc]) {
            if(p.Type == 'Quarter') {
                map_sDate_eDate4Quarter.put(p.StartDate, p.EndDate);    
            }else if(p.Type == 'Month') {
                for(Date sDate : map_sDate_eDate4Quarter.keySet()) {
                    if(!map_sDate_set_monthTypeDates.containsKey(sDate)) {
                        map_sDate_set_monthTypeDates.put(sDate, new set<Date>());
                    }
                    if(sDate < p.StartDate && map_sDate_eDate4Quarter.get(sDate) >= p.StartDate) {
                        map_sDate_set_monthTypeDates.get(sDate).add(p.StartDate);
                    }
                }
            }
        }
    }
    
    /**
    * The method is used for batch
    *
    @author lili zhao
    @created 2013-10-28
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param    
    *
    @return            
    *
    @changelog
    * 2013-10-28 lili zhao <lili.zhao@itbconsult.com>
    * - Created
    */ /*
       public static void deleteForecastHistoryOnOppForecast(map<String, map<String, list<Opportunity_Forecast__c>>> map_partId_mapYearOppForecast, set<String> set_year) {
        list<Forecast_History__c> list_deleteForecastHistory = new list<Forecast_History__c>();
        list<Opportunity_Forecast__c> list_updateOppForecast = new list<Opportunity_Forecast__c>();
        list<Opportunity_Forecast__c> list_oppForecast = new list<Opportunity_Forecast__c>();
            
        Integer INDHoldingDays = getHoldingDays('IND');
        Integer AppliancesHoldingDays = getHoldingDays('Appliances');       
        for(Forecast_History__c forecastHistory: [Select LastModifiedDate,Fiscal_Year__c, Part__c, New_Value__c, Old_Value__c, Part__r.Part__r.Name, Opportunity__c,Opportunity__r.Industry_Code__c         
                                                  From Forecast_History__c    
                                                  where (Part__c IN : map_partId_mapYearOppForecast.keySet()) and (Fiscal_Year__c IN : set_year)and  Part__c != null]) {                                                           
            if(map_partId_mapYearOppForecast.containsKey(forecastHistory.Part__c) && map_partId_mapYearOppForecast.get(forecastHistory.Part__c).containsKey(forecastHistory.Fiscal_Year__c) && map_partId_mapYearOppForecast.get(forecastHistory.Part__c).get(forecastHistory.Fiscal_Year__c).size() > 0) {                             
                Date lastModifiedDate = forecastHistory.LastModifiedDate.date();
                
                if(map_BU_IND.containsKey(forecastHistory.Opportunity__r.Industry_Code__c)) {
                //BU = 'IND';   
                    lastModifiedDate = lastModifiedDate.addDays(INDHoldingDays);
                    if(lastModifiedDate < Date.today() ){
                        list_deleteForecastHistory.add(forecastHistory);                        
                        for(Opportunity_Forecast__c oppForecast : map_partId_mapYearOppForecast.get(forecastHistory.Part__c).get(forecastHistory.Fiscal_Year__c)) {
                            oppForecast.IsLocked__c = false;
                            list_updateOppForecast.add(oppForecast);   
                        }               
                    }
                }else 
                
                if(map_BU_Appliances.containsKey(forecastHistory.Opportunity__r.Industry_Code__c)) {
                    //BU = 'Appliances';
                    lastModifiedDate = lastModifiedDate.addDays(AppliancesHoldingDays);
                    if(lastModifiedDate < Date.today() ){
                        list_deleteForecastHistory.add(forecastHistory);                        
                        for(Opportunity_Forecast__c oppForecast : map_partId_mapYearOppForecast.get(forecastHistory.Part__c).get(forecastHistory.Fiscal_Year__c)) {
                            oppForecast.IsLocked__c = false;
                            list_updateOppForecast.add(oppForecast);   
                        }                           
                    }     
                }           
            }                                                                               
        }  
        
        if(!list_deleteForecastHistory.isEmpty()) {     
            delete list_deleteForecastHistory;
        }
        
        if(!list_updateOppForecast.isEmpty()) { 
            //update  list_updateOppForecast;
            Database.update(list_updateOppForecast, false);

        }                           
    }
    */
   /**
    * This method is used to set fiscal year setting
    *
    @author Bin Yuan
    @created 2014-10-21
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-10-21 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static String getFiscalYear() {
        String currentYear = '';
        //set current fiscal month
        for (Period period : [select Id, FiscalYearSettings.Name, PeriodLabel 
                                from Period where StartDate<=Today and EndDate >=Today and Type = 'Month']) {
                                    
            if(period.FiscalYearSettings.Name != null){ //set current year
                currentYear = period.FiscalYearSettings.Name;
            }
        }
        return currentYear;
    }
    //********************************* -=END public methods=- ************************************
       
    
    //********************************* -=BEGIN private methods=- *********************************  
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
    * The method is used to 
    *
    @author Bin Yuan
    @created 2013-10-17       
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param             level
    *
    @return threshold
    *
    @changelog
    * 2013-10-17 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    /*
    private static void createVOBaseObj(ClsForecastEnrtyPageFactory.ForecastVOBase vo, Opportunity_Forecast__c fc, Opportunity oppy) {
        vo.qty = Integer.valueOf((fc.Part__r.Quantity__c == null ? 0 : fc.Part__r.Quantity__c));
        vo.year = fc.Fiscal_Year__c;
        vo.price = transformIsoCode(fc.Sales_Price__c, fc.CurrencyIsoCode, oppy.CurrencyIsoCode);
        vo.partId = fc.Part__c; 
        vo.list_manualqty = new list<Integer>();
    }
    */
    /**
    * The method is used to get the change level
    *
    @author Bin Yuan
    @created 2013-10-17       
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param             level
    *
    @return threshold
    *
    @changelog
    * 2013-10-17 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    /*
    private static decimal getThresholdFromSetting(String bu) {
        String str_threshold = 'Threshold_' + bu;
        decimal threshold = 0;
        if(Forecast_History_Config__c.getInstance(str_threshold) != null && Forecast_History_Config__c.getInstance(str_threshold).Inactive__c == true ) {
            threshold = decimal.valueOf((String) Forecast_History_Config__c.getInstance(str_threshold).Value__c);
        }
        return threshold;
    }
    */
    /**
    * The method is used to get the days 
    *
    @author Bin Yuan
    @created 2013-10-17
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param             level
    *
    @return 
    *
    @changelog
    * 2013-10-17 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    /*
    private static Integer getHoldingDays(String bu) {
        Integer int_holdingDays = 0;
        String str_holdingDay = 'Approval Period_' + bu;
        if(Forecast_History_Config__c.getInstance(str_holdingDay) != null && Forecast_History_Config__c.getInstance(str_holdingDay).Inactive__c == true ) {
            int_holdingDays = Integer.valueOf((String) Forecast_History_Config__c.getInstance(str_holdingDay).Value__c);
        }
        return int_holdingDays;
    }
    */
    /**
    * The method is used to create Forecast_History__c
    *
    @author Bin Yuan
    @created 2013-10-17
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param             level
    *
    @return 
    *
    @changelog
    * 2013-10-17 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void copyHistoryData(ExtOppyForecastEntryPage.ForecastHistoryStructure forecastClsObj, Forecast_History__c forecastHistory, String partId, String oppyId, list<Forecast_History__c> list_forecast2Upsert, list<Forecast_History__c> list_forecast2Notify, map<String, String> map_partId_partNumber, decimal threshold,set<String> set_years,set<String> set_partIds) {
        decimal changePercentage = 0;
        if(forecastClsObj.oldValue != 0) {
            decimal changeage = Math.abs(forecastClsObj.oldValue - forecastClsObj.newValue);
            changePercentage = changeage/forecastClsObj.oldValue;
        }else {
            changePercentage = 1;
        }
        changePercentage = changePercentage.setScale(3);
        if(changePercentage != 0 && changePercentage >= threshold) {
            //forecastHistory.Opportunity__c = forecastClsObj.oppyId; //add lili 2013.10.17
            forecastHistory.Opportunity__c = oppyId;
            forecastHistory.Part__c = partId;
            forecastHistory.Fiscal_Year__c = forecastClsObj.fiscalYear;
            forecastHistory.New_Value__c = forecastClsObj.newValue;
            forecastHistory.Old_Value__c = forecastClsObj.oldValue;
            //forecastHistory.Part__c = forecastClsObj.oppyPartId; //add lili 2013.10.17
            // add lili 2013.10.15 end
            list_forecast2Notify.add(forecastHistory);
            map_partId_partNumber.put(forecastHistory.Part__c, null);
            list_forecast2Upsert.add(forecastHistory);
            set_years.add(forecastClsObj.fiscalYear);
            set_partIds.add(partId);
        }
    } 
    
    /**
    * The method is used to batch 
    *
    @author lili zhao
    @created 2014-04-18
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param    
    *
    @return            
    *
    @changelog
    * 2014-04-18 lili zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static void setFiscalMonthForBatch(list<Opportunity_Forecast__c > list_oppyForcasts) {
        
        list<Opportunity_Forecast__c > list_UpdateOppyForcasts = new list<Opportunity_Forecast__c >();
        set<Date> setMonthDate= new set<Date>();
        set<Date> setYearQuarterDate = new set<Date>();
        map<Date, String> map_MonthDate_MonthPeriodLabel = new map<Date, String>();
        map<Date, Integer> map_YearQuarterDate_YearQuarterNumber = new map<Date, Integer>();     
        map<Integer, String> map_intMonth_strMonth = new map<Integer, String>();
        
        map_intMonth_strMonth.put(1,'01');
        map_intMonth_strMonth.put(2,'02');
        map_intMonth_strMonth.put(3,'03');
        map_intMonth_strMonth.put(4,'04');
        map_intMonth_strMonth.put(5,'05');
        map_intMonth_strMonth.put(6,'06');
        map_intMonth_strMonth.put(7,'07');
        map_intMonth_strMonth.put(8,'08');
        map_intMonth_strMonth.put(9,'09');
        map_intMonth_strMonth.put(10,'10');
        map_intMonth_strMonth.put(11,'11');
        map_intMonth_strMonth.put(12,'12');        
        
        // ****** get the oppyForecast date as the  level__c of oppy    
        for(Opportunity_Forecast__c oppyForecast : list_oppyForcasts) {
            if(oppyForecast.Opportunity__r.level__c == ClsOppyForecastUtil.MONTHLY) {
                setMonthDate.add(oppyForecast.Date__c);
            }else {
                setYearQuarterDate.add(oppyForecast.Date__c);
            }
        }
        
        // get the PeriodLabel as the oppyForecast date for month and the Number for Quarter******* 
        for(Period p: [select FiscalYearSettingsId, type, FiscalYearSettings.Name, Number, PeriodLabel, StartDate, EndDate 
                       from Period 
                       where (StartDate IN: setMonthDate 
                            and type = 'Month' and PeriodLabel != null )
                       or (StartDate IN: setYearQuarterDate 
                           and type = 'Quarter' )
                       order by StartDate]){
            if(p.type == 'Month') {
                map_MonthDate_MonthPeriodLabel.put(p.StartDate, String.valueOf(p.PeriodLabel));
            }else {
                map_YearQuarterDate_YearQuarterNumber.put(p.StartDate, p.Number);
            }   
        }

        //******* set the oppyForecast Fiscal_Month__c******* 
        for(Opportunity_Forecast__c oppyForecast : list_oppyForcasts) {
            if(oppyForecast.Opportunity__r.level__c == ClsOppyForecastUtil.MONTHLY) {
                if(map_MonthDate_MonthPeriodLabel.containsKey(oppyForecast.Date__c)) {
                    oppyForecast.Fiscal_Month__c = map_intMonth_strMonth.get(MAP_MONTHLABELNUMBER.get(map_MonthDate_MonthPeriodLabel.get(oppyForecast.Date__c)));
                    list_UpdateOppyForcasts.add(oppyForecast);
                }
            }else {
                if(map_YearQuarterDate_YearQuarterNumber.containsKey(oppyForecast.Date__c)) {
                    oppyForecast.Fiscal_Month__c = map_intMonth_strMonth.get(MAP_MONTHLABELNUMBER.get(MAP_QUARTERYear.get(map_YearQuarterDate_YearQuarterNumber.get(oppyForecast.Date__c))));                   
                    list_UpdateOppyForcasts.add(oppyForecast);
                }
            }
        }
        //*** update the oppyForecast******* 
        if(list_UpdateOppyForcasts.size() > 0) {
            Database.update(list_UpdateOppyForcasts, false);
        }
    }
    

    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    public class forecastHistoryInfos{
        public String partNumber{get;set;}   
        public map<String, String> map_year_oldNewValue{get;set;}
        public forecastHistoryInfos(String num, map<String, String> map_Value) {
            this.partNumber = num;
            this.map_year_oldNewValue = map_Value;          
        }
    } 
    ///*>>>WrapperClass*/
    ///*<<<WrapperClass*/   
    //********************************* -=END inner classes=- *************************************                       
    
    /**
    * The method is used to call revenue calculation method for NDR when Forecast are created automatically
    *
    @author Mrunal Parate
    @created 2015-09-21
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param    
    *
    @return            
    *
    @changelog
    * 2015-09-21 Mrunal Parate
    * - Created
    */ 
    public static void calculateRevenueforNDR(set<Id> set_oppyIdPar) {
        if(!set_oppyIdPar.isEmpty()) {    
            for(Opportunity oppy : [Select Id, StageName, RecordTypeId,Amount,Method__c,Program__c,Level__c, Five_Year_Revenue__c, Total_Opportunity_Value__c, Five_Year_Value__c, Manufacturing_Start_Date__c From Opportunity Where Id in :set_oppyIdPar]){
                Map<Id, Opportunity> mapOpptytoOpptyId = new Map<Id, Opportunity>();
                mapOpptytoOpptyId.put(oppy.Id, oppy);
                updateOpportunityAmounts(mapOpptytoOpptyId, oppy.Method__c, oppy.Level__c, oppy); 
            }
        }
    }
    
}