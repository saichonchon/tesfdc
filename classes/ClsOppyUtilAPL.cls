/**
 * 
 *   This class will collect all functions about opportunity, opportunity part, opportunity forecast etc...
 *
 * @author      Bin Yu  
 * @created     2012-02-27
 * @since       23.0    
 * @version     1.0                                                                 
 * 
 * @changelog
 * 2012-02-27 Bin Yu <bin.yu@itbconsult.com>
 * - Created
 * 2012-10-24 Frederic Faisst <frederic.faisst@itbconsult.com>
 * - Changed method "saveProgram"   
 */
 
global class ClsOppyUtilAPL { 
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public static list<Opportunity_Forecast__c> list_oppysForecast2Del;  
    public static String deletePartException;
    public static final String MODE_INSERT = 'INSERT';
    public static final String MODE_UPDATE = 'UPDATE'; 
    public static final String MONTHLY = 'Monthly';
    public static final String YEARLY = 'Yearly';
    public static final String QUARTERLY = 'Quarterly';
    public static Boolean cloneOppty = false;
    public String appliance {get;set;}
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
    
    public static final map<string, String> MAP_REVENUE = new map<string, String>{
        '2011' => 'Revenue_FY11__c',
        '2012' => 'Revenue_FY12__c',
        '2013' => 'Revenue_FY13__c',
        '2014' => 'Revenue_FY14__c',
        '2015' => 'Revenue_FY15__c',
        '2016' => 'Revenue_FY16__c',
        '2017' => 'Revenue_FY17__c',
        '2018' => 'Revenue_FY18__c',
        '2019' => 'Revenue_FY19__c',
        '2020' => 'Revenue_FY20__c'
    }; 
    public static List<Period> list_fiscalYear; 
    public static List<Period> list_fiscalQuarter;
    public static List<Period> list_fiscalMonth;
    public static map<String, Map<String, Period>> map_fiscalyear_months;
    public static map<String, Map<String, Period>> map_fiscalyear_quarters;
    public static map<String, Decimal> map_isoCode_exchangeRate; 
    public static map<String, Decimal> map_convertionRate = new Map<String, Decimal>();
    public static map<Date, String> map_date_quarter = new map<Date, String>();
    public static map<Date, String> map_date_month = new map<Date, String>();
    public static map<Date, String> map_date_monthNum = new map<Date, String>();
    //Start :: Added by Bin Yuan due to optimize trigger OpportunityStageValidation
    public static User runUser;
    public static list<RecordType> list_recordType = new list<RecordType>();
    //End
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private static final String ACCOUNT_CM = 'CM';
    private static final String ACCOUNT_DISTRIBUTOR = 'Distributor';
    private static final String ACCOUNT_OEM = 'OEM';
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
    //added by weihang 2013-05-28 begin
    public static boolean getIsConvertVal(){
        boolean isConvert = false;
        if(Apex_Helper_Settings__c.getInstance('MigrateOppyForecastCurrConvert') != null){
            isConvert = Apex_Helper_Settings__c.getInstance('MigrateOppyForecastCurrConvert').Active__c;
        }
        return isConvert;
    }
    //added by weihang 2013-05-28 end
    
    public static void getAllFiscalYear(){
        if(list_fiscalYear == null){
            list_fiscalYear = new List<Period>();
            for(Period p: [select FiscalYearSettingsId, FiscalYearSettings.Name, PeriodLabel, Number, StartDate, EndDate from Period where type = 'year'  and FiscalYearSettings.IsStandardYear = false order by FiscalYearSettings.Name]){
                list_fiscalYear.add(p);
            }
        }
    }
    
    public static void getAllFiscalQuarter(){
        if(list_fiscalQuarter == null){
            list_fiscalQuarter = new List<Period>();
            for(Period p:  [select FiscalYearSettingsId, FiscalYearSettings.Name, Number, PeriodLabel, StartDate, EndDate from Period where type = 'quarter']){
                list_fiscalQuarter.add(p);
            }
        }
    }    
    
    public static void getAllFiscalMonth(){
        if(list_fiscalMonth == null){
            list_fiscalMonth = new List<Period>();
            for(Period p: [select FiscalYearSettingsId, FiscalYearSettings.Name, Number, PeriodLabel, StartDate, EndDate from Period where type = 'month' order by StartDate]){
                list_fiscalMonth.add(p);
            }
        }
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
    public static ClsOpportunityForecastStructure createNewOppyForecastStructure(map<Id, String> map_oppyPartId_isoCode, String opportunityIsocode, Map<Id, Id> map_partId_oppyId, List<Id> list_partIds, String year, Id oppyId, Id forecastOppyRecordTypeId, Id forecastPartRecordTypeId, String level){
        Map<Id, List<Opportunity_Forecast__c>> map_tmp = new Map<Id, List<Opportunity_Forecast__c>>();
        for(Id id: list_partIds){ 
            map_tmp.put(id, new List<Opportunity_Forecast__c>{});
        } 
        ClsOpportunityForecastStructure OppyForecastStructure = new ClsOpportunityForecastStructure(
                                                                    map_oppyPartId_isoCode,opportunityIsocode,
                                                                    new List<Opportunity_Forecast__c>{},
                                                                    map_tmp,
                                                                    year, oppyId, map_partId_oppyId, forecastOppyRecordTypeId, forecastPartRecordTypeId, level, list_partIds);  
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
        getFiscalYearMonthMap();
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
        opportunity = [select Industry_Code__c,Owner.GIBU__c,Record_Type_Name__c,CloseDate,Manufacturing_Start_Date__c, Id, Name, stageName, RecordTypeId, Program__c, Five_Year_Value__c, Total_Opportunity_Value__c, Program__r.Program_level_Forecasting__c, Amount, Five_Year_Revenue__c, Method__c, CurrencyIsoCode, Level__c, Competitor_Count__c,Account.Customer_Region__c,Account.Customer_Industry__c,Account.LEVEL_1_INDUSTRY_CDE__c from Opportunity where Id = :oppyId];//modified by xia 2013-04-09,add field Account.Customer_Region__c  
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
        List<Period> list_period = [select FiscalYearSettingsId, FiscalYearSettings.Name, PeriodLabel, Number, StartDate, EndDate from Period where type = 'year' order by FiscalYearSettings.Name];
        // get parts according to opportunities
        for(Opportunity_Part__c part: [select Id, Opportunity__c from Opportunity_Part__c where Opportunity__c in :set_oppyIds order by Name]){
            set_partIds.add(part.Id);
            list_parts.add(part);   
        }
        // get forecasts according to opportunies and parts
        List<Opportunity_Forecast__c> list_forecasts = [select Id, Name, RecordTypeId, Date__c, Sales_Price__c, Five_Year_Amount__c, Quantity__c, Amount__c, Opportunity__c, Part__c from Opportunity_Forecast__c where Opportunity__c in :set_oppyIds and Part__c in :set_partIds and Date__c != null];
        
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
        if(level == ClsOppyUtilAPL.MONTHLY){
            for(Integer i=1; i<=12; i++){
                list_labels.add(ClsOppyUtilAPL.MAP_MONTHLABEL.get(MAP_MONTH.get(i)));
            }
        }
        else if(level == ClsOppyUtilAPL.QUARTERLY){
            for(Integer i=1; i<=4; i++){
                list_labels.add(ClsOppyUtilAPL.MAP_QUARTERLABEL.get(i));
            }
        }
         else if(level == ClsOppyUtilAPL.YEARLY){
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
        //added by Padmaja 2014-06-25 begin
         List<SelectOption> list_forecastLevel = new List<SelectOption>();
         list_forecastLevel.add(new SelectOption(ClsOppyUtilAPL.YEARLY, ClsOppyUtilAPL.YEARLY));
         list_forecastLevel.add(new SelectOption(ClsOppyUtilAPL.QUARTERLY, ClsOppyUtilAPL.QUARTERLY));
         list_forecastLevel.add(new SelectOption(ClsOppyUtilAPL.MONTHLY, ClsOppyUtilAPL.MONTHLY));
            
         return list_forecastLevel;
    }
    //Ended
    public static List<SelectOption> getForecastLevelNoYear(){
        //added by Padmaja 2014-06-25 begin        
        List<SelectOption> list_forecastLevel = new List<SelectOption>();       
        list_forecastLevel.add(new SelectOption(ClsOppyUtilAPL.QUARTERLY, ClsOppyUtilAPL.QUARTERLY));
        list_forecastLevel.add(new SelectOption(ClsOppyUtilAPL.MONTHLY, ClsOppyUtilAPL.MONTHLY));             
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
         list_otherYears.add(new SelectOption(System.label.None_Value, System.label.None_Value));
         getAllFiscalYear();
         for(Period p :list_fiscalYear){
            Boolean hasYear = false;
            for(String year: list_years){
                if(p.FiscalYearSettings.Name == year){
                    hasYear = true;
                    break;
                }
            }
            if(!hasYear){
                list_otherYears.add(new SelectOption(p.FiscalYearSettings.Name, p.FiscalYearSettings.Name));
            }
         }
          
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
        if(map_date_month.containsKey(inputDate)){
            return map_date_month.get(inputDate);
        }
        getAllFiscalMonth();
        if(inputDate != null){
            for(Period p: list_fiscalMonth){                
                if(inputDate >= p.StartDate && inputDate <= p.EndDate){
                    if(MAP_MONTHLABEL.containsKey(p.PeriodLabel)){
                        month = MAP_MONTHLABEL.get(p.PeriodLabel);
                        map_date_month.put(inputDate, month);
                        break;
                    }
                }
            }           
        }
        return month; 
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
            system.debug('******************************'+toRate);  
            system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'+fromRate);  
            result = sourceValue * ( toRate / fromRate );
            system.debug('##############################'+result);   
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
    */
    public static List<Opportunity_Part__c> getPartsByOppyId(Set<Id> set_oppyIds){
        list<Opportunity_Part__c> list_parts = new List<Opportunity_Part__c>();
        
        String sql_query = 'Select Id, Name, Part_Name__c, Opportunity__c, Opportunity__r.Name, Opportunity__r.StageName,' +  //
                                'Quantity__c, Status__c, Process_Status__c, Lost_Reason__c,Lost_Reason_Text__c, Competitor__c, Similar_TE_Part_Number__r.Name,' + //
                                ' GPL__c, Part__r.Name, New_Part_Description__c, RecordType.Name ' + //
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
        for(Opportunity_Forecast__c ofc : [select Id, Name, RecordTypeId, Five_Year_Amount__c, Fiscal_Year__c, Date__c, Sales_Price__c, Quantity__c, Amount__c, Opportunity__c, Part__c,Part__r.Status__c, Forecasting_Start_Date__c from Opportunity_Forecast__c where Opportunity__c = :oppyId and Part__c = null and Date__c != null order by Date__c]){
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
        for(Opportunity oppy : [select Id,CloseDate,Manufacturing_Start_Date__c, Five_Year_Value__c, Total_Opportunity_Value__c, Name, Program__c, Amount, Five_Year_Revenue__c, Method__c, CurrencyIsoCode, Level__c, stageName, Competitor_Count__c from Opportunity where Program__c = :oppyId]){
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
        for(Opportunity_Part__c part : [select Id, Name, Part_Name__c, Opportunity__c, Opportunity__r.Name, Opportunity__r.StageName, Quantity__c, Status__c, Process_Status__c, Won_Date__c, Lost_Reason__c,Lost_Reason_Text__c, Competitor__c, Similar_TE_Part_Number__r.Name, GPL__c, Part__r.Name, New_Part_Description__c, RecordType.Name from Opportunity_Part__c where Opportunity__r.Program__c = :oppyId order by Opportunity__r.Name, Name]){
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
        for(Opportunity_Forecast__c ofc : [select Id, Date__c, Five_Year_Amount__c, Fiscal_Year__c, Sales_Price__c, Quantity__c, Amount__c, Opportunity__c from Opportunity_Forecast__c where Opportunity__c in :set_oppyIds and Part__c = null and Date__c != null]){
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
        for(Opportunity_Forecast__c ofc : [select Id, Date__c,  Five_Year_Amount__c, Fiscal_Year__c, Sales_Price__c, Quantity__c, Amount__c, Opportunity__c, Part__c, Forecasting_Start_Date__c from Opportunity_Forecast__c where Opportunity__c = :oppyId and Part__c != null and Date__c != null order by Part__r.Name, Date__c]){
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
        for(Opportunity_Forecast__c ofc : [select Id, Name, Five_Year_Amount__c, RecordTypeId, Date__c, Fiscal_Year__c, Sales_Price__c, Quantity__c, Amount__c, Opportunity__c, Part__c, Forecasting_Start_Date__c from Opportunity_Forecast__c where Opportunity__r.Program__c = :oppyId and Part__c != null and Date__c != null order by Part__r.Name]){
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
    * The method is used to get the forecasting start date
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
    //added by min
    public static Date calStartDate(List<ClsOpportunityForecastStructure> list_forecastStructures, String level){
        Date startDate = null;
        Boolean findDate = false;
        //getFiscalYearQuarterMap();
        Map<String, String> map_m = new Map<String, String>();
        if(level == ClsOppyUtilAPL.MONTHLY){
            for(String label :ClsOppyUtilAPL.MAP_MONTHLABEL.keySet()){
                map_m.put(ClsOppyUtilAPL.MAP_MONTHLABEL.get(label), label);
            }
        }
        else{
            for(Integer i=1; i<=ClsOppyUtilAPL.MAP_QUARTERLABEL.size(); i++){
                map_m.put(ClsOppyUtilAPL.MAP_QUARTERLABEL.get(i), String.valueOf(i));
            }       
        }
        for(ClsOpportunityForecastStructure structure: list_forecastStructures){
            for(ClsOpportunityForecastStructure.ForecastItemStructure item :structure.forecastStructure.list_editForecasts){  
                if(item.forecast.Quantity__c != null && item.forecast.Quantity__c != 0){
                    // monthly
                    if(level == MONTHLY){
                        startDate = ClsOppyUtilAPL.getFiscalMonthStartDate(structure.year, map_m.get(item.label));
                    }
                    // quarterly
                    else{
                        startDate = ClsOppyUtilAPL.getFiscalQuarterStartDate(structure.year, map_m.get(item.label));
                    }                       
                    findDate = true;
                    break;
                }                     
            }
            if(findDate) return startDate;               
        }   
        return startDate;   
    }   
    
      /**
    * The method is used to get the forecasting start date
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
    //added by min
    public static String calStartYear(List<ClsOpportunityForecastStructure> list_forecastStructures){
        String startYear = '';
        Boolean findYear = false;
        for(ClsOpportunityForecastStructure structure: list_forecastStructures){
            for(ClsOpportunityForecastStructure.ForecastItemStructure item :structure.forecastStructure.list_editForecasts){  
                if(item.forecast.Quantity__c != null && item.forecast.Quantity__c != 0){
                    startYear = structure.year;
                    findYear = true;
                    break;
                }                     
            }
            if(findYear) return startYear;             
        }   
        return startYear;   
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
    public static void addOppyYears(map<Id, String> map_oppyPartId_isoCode, String opportunityIsocode, List<ClsOpportunityForecastStructure> list_forecastStructures, List<String> list_years, Integer newYears, Map<Id, Id> map_partId_oppyId, List<Id> list_partIds, Id oppyId, Id forecastOppyRecordTypeId, Id forecastPartRecordTypeId, String level){     
        Set<String> set_periodYears = ClsOppyUtilAPL.getAllPeriodYears();
        Integer lastYear = 0;
        Integer currentYear = system.today().year();
        if(list_years.size() > 0){
            lastYear = Integer.valueOf(list_years.get(list_years.size() - 1));
            if(currentYear > lastYear){
                lastYear = currentYear - 1;
            }
        }
        else{
            lastYear = system.today().year() - 1;
        }
        for(Integer i=0; i < newYears; i++){
            lastYear++;
            if(set_periodYears.contains(String.valueOf(lastYear))){
                ClsOpportunityForecastStructure OppyForecastStructure = ClsOppyUtilAPL.createNewOppyForecastStructure(map_oppyPartId_isoCode, opportunityIsocode, map_partId_oppyId, list_partIds, String.valueOf(lastYear), oppyId, forecastOppyRecordTypeId, forecastPartRecordTypeId, level);
                list_forecastStructures.add(OppyForecastStructure); 
                list_years.add(String.valueOf(lastYear));
            }
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
    public static void addAllOppyYears(map<Id, String> map_oppyPartId_isoCode, String opportunityIsocode, List<ClsOpportunityForecastStructure> list_forecastStructures, List<String> list_years, Integer newYears, Map<Id, Id> map_partId_oppyId, List<Id> list_partIds, Id oppyId, Id forecastOppyRecordTypeId, Id forecastPartRecordTypeId, String level){     
        Set<String> set_periodYears = ClsOppyUtilAPL.getAllPeriodYears();
        Integer lastYear = Integer.valueOf(list_years[list_years.size() - 1]);
        for(Integer i=1; i<=newYears; i++){
            lastYear++;
            if(set_periodYears.contains(String.valueOf(lastYear))){
                list_years.add(String.valueOf(lastYear));
            }
        }
        for(String year: list_years){
            if(set_periodYears.contains(String.valueOf(year))){
                ClsOpportunityForecastStructure OppyForecastStructure = ClsOppyUtilAPL.createNewOppyForecastStructure(map_oppyPartId_isoCode, opportunityIsocode, map_partId_oppyId, list_partIds, String.valueOf(year), oppyId, forecastOppyRecordTypeId, forecastPartRecordTypeId, level);
                list_forecastStructures.add(OppyForecastStructure); 
            }
        }
    }
      /**
    * The method is the add one year method
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
    public static void addOppyOneYear(map<Id, String> map_oppyPartId_isoCode, String opportunityIsocode, List<ClsOpportunityForecastStructure> list_forecastStructures, List<String> list_years, String oneYear, Map<Id, Id> map_partId_oppyId, List<Id> list_partIds, Id oppyId, Id forecastOppyRecordTypeId, Id forecastPartRecordTypeId, String level){
        ClsOpportunityForecastStructure OppyForecastStructure = ClsOppyUtilAPL.createNewOppyForecastStructure(map_oppyPartId_isoCode, opportunityIsocode, map_partId_oppyId, list_partIds, oneYear, oppyId, forecastOppyRecordTypeId, forecastPartRecordTypeId, level);
        //when add one year, sort the structure
        if(list_forecastStructures.isEmpty() || OppyForecastStructure.year > list_forecastStructures[list_forecastStructures.size()-1].year){
            list_forecastStructures.add(OppyForecastStructure);
            list_years.add(oneYear);
        }
        else{
            for(Integer i=0; i<list_forecastStructures.size(); i++){
                if(i == 0){
                    if(OppyForecastStructure.year < list_forecastStructures[i].year){
                        list_forecastStructures.add(i, OppyForecastStructure);
                        list_years.add(i, oneYear);
                        break;
                    }
                }
                else{
                    if(OppyForecastStructure.year < list_forecastStructures[i].year && OppyForecastStructure.year > list_forecastStructures[i-1].year){
                        list_forecastStructures.add(i, OppyForecastStructure);
                        list_years.add(i, oneYear);
                        break;
                    }
                }               
            }
        }
    }
 
      /**
    * The method is the delete year method
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param     list of forecast structures, the year that need deleting
    *
    @return            
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static void deleteOppyYear(List<ClsOpportunityForecastStructure> list_forecastStructures, String year2Delete){           
        for(Integer i=0; i< list_forecastStructures.size(); i++){
            ClsOpportunityForecastStructure forecastStructure = list_forecastStructures.get(i);
            if(forecastStructure.year == year2Delete){
                for(ClsOpportunityForecastStructure.ForecastItemStructure item :forecastStructure.forecastStructure.list_editForecasts){
                    item.forecast.Quantity__c = 0;
                    item.forecast.Amount__c = 0;                                
                }
                forecastStructure.forecastStructure.salesPriceOF = new Opportunity_Forecast__c();
                for(ClsOpportunityForecastStructure.ForecastStructure  fs: forecastStructure.partForecasts){                
                    for(ClsOpportunityForecastStructure.ForecastItemStructure item :fs.list_editForecasts){
                        item.forecast.Quantity__c = 0;
                        item.forecast.Amount__c = 0;
                    }
                    fs.salesPriceOF = new Opportunity_Forecast__c();                
                }
                break;
            }
        }
    }
    
    /**
    * The method is used to transfer all structures
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param     list of forecast structures, level
    *
    @return            
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */  

    public static void transferAllStructures(List<ClsOpportunityForecastStructure> list_forecastStructures, String level, String method, Map<Id, Opportunity_Part__c> map_parts){
        for(ClsOpportunityForecastStructure structure: list_forecastStructures){ 
            //handle the opportunity forecast(BOM)
            if(method == 'BOM'){
                structure.forecastStructure.level = level;
                transferStructure(structure.forecastStructure, level);
            }                       
            for(ClsOpportunityForecastStructure.ForecastStructure fcs : structure.partForecasts){
                fcs.level = level;
                // add
                if(method == 'BOM'){
                    Decimal q = 0;
                    if(map_parts.containsKey(fcs.partId)){
                        if(map_parts.get(fcs.partId).Quantity__c != null){
                            q = map_parts.get(fcs.partId).Quantity__c;
                        }
                    }
                    // handle the part forecast(BOM)
                    transferStructureFromOppy(fcs, structure.forecastStructure.list_editForecasts, q, level);
                }
                else {
                    // handle the part forecast(Manual) 
                    transferStructure(fcs, level);
                }
            }
            // handle the opportunity forecast(Manual)
            if(structure.partForecasts.size() > 0 && method != 'BOM') transferStructureFromPart(structure.forecastStructure, structure.partForecasts, level);
            // recalculate the opportunity forecast revenue(BOM)
            else if(structure.partForecasts.size() > 0 && method == 'BOM') {
                Integer i = 0;
                for(ClsOpportunityForecastStructure.ForecastItemStructure oppyForecastItem :structure.forecastStructure.list_editForecasts){
                    Decimal totalRevenue = 0;
                    for(ClsOpportunityForecastStructure.ForecastStructure partForecast :structure.partForecasts){
                        if(partForecast.list_editForecasts[i].forecast.Amount__c != null) {
                            if(map_parts.containsKey(partForecast.partId)){
                                if(map_parts.get(partForecast.partId).Status__c != 'Dead' && map_parts.get(partForecast.partId).Status__c != 'Lost') totalRevenue += partForecast.list_editForecasts[i].forecast.Amount__c;
                            }                           
                        }
                    }
                    oppyForecastItem.forecast.Amount__c = totalRevenue;
                    i++;
                }               
            }
        }       
    }   
        
      /**
    * The method is used to transfer structure
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param     forecast structure, level
    *
    @return            
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static void transferStructure(ClsOpportunityForecastStructure.ForecastStructure fcs, String level){
        if(level == ClsOppyUtilAPL.MONTHLY){
            if(fcs.list_editForecasts.size() == 4){
                List<ClsOpportunityForecastStructure.ForecastItemStructure> list_tmp = fcs.calMonthForecastByQurater(fcs.list_editForecasts);
                fcs.list_editForecasts.clear();
                fcs.list_editForecasts.addAll(list_tmp);
            }
            else if(fcs.list_editForecasts.size() == 1){
                List<ClsOpportunityForecastStructure.ForecastItemStructure> list_tmp = fcs.calMonthForecastByYear(fcs.list_editForecasts.get(0));
                fcs.list_editForecasts.clear();
                fcs.list_editForecasts.addAll(list_tmp);
            }
        }
        else if(level == ClsOppyUtilAPL.QUARTERLY){
            if(fcs.list_editForecasts.size() == 12){
                List<ClsOpportunityForecastStructure.ForecastItemStructure> list_tmp = fcs.calQuarterForecastByMonth(fcs.list_editForecasts);
                fcs.list_editForecasts.clear();
                fcs.list_editForecasts.addAll(list_tmp);
            }
            else if(fcs.list_editForecasts.size() == 1){
                List<ClsOpportunityForecastStructure.ForecastItemStructure> list_tmp = fcs.calQuarterForecastByYear(fcs.list_editForecasts.get(0));
                fcs.list_editForecasts.clear();
                fcs.list_editForecasts.addAll(list_tmp);
            }
        }
        else if(level == ClsOppyUtilAPL.YEARLY){
            if(fcs.list_editForecasts.size() == 12 || fcs.list_editForecasts.size() == 4) {
                List<ClsOpportunityForecastStructure.ForecastItemStructure> list_tmp = fcs.calYearStructure(fcs.list_editForecasts);
                fcs.list_editForecasts.clear();
                fcs.list_editForecasts.addAll(list_tmp);
            }
        }
    }   

      /**
    * The method is used to convert part forecast structure for BOM
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param     forecast structure, level
    *
    @return            
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static void transferStructureFromOppy(ClsOpportunityForecastStructure.ForecastStructure fcs, List<ClsOpportunityForecastStructure.ForecastItemStructure> ofcs, Decimal q, String level){
        Id partId = fcs.partId;
        Id recordTypeId = fcs.recordTypeId;       
        List<ClsOpportunityForecastStructure.ForecastItemStructure> list_tmp = new List<ClsOpportunityForecastStructure.ForecastItemStructure>();
        Integer i = 0;
        for(ClsOpportunityForecastStructure.ForecastItemStructure item: ofcs){
            ClsOpportunityForecastStructure.ForecastItemStructure tempItem = new ClsOpportunityForecastStructure.ForecastItemStructure(level, partId, fcs.oppyId, recordTypeId);
            if(item.forecast.Quantity__c != null)
            tempItem.forecast.Quantity__c = item.forecast.Quantity__c * q;
            tempItem.forecast.Date__c = item.forecast.Date__c;
            tempItem.label= item.label;
            if(fcs.salesPriceOF.Sales_Price__c  != null && tempItem.forecast.Quantity__c != null){
                tempItem.forecast.Amount__c = tempItem.forecast.Quantity__c * fcs.salesPriceOF.Sales_Price__c;
            }
            // recalculate the revenue of opportunity forecast
            if(item.forecast.Amount__c == null) item.forecast.Amount__c = 0;
            if(tempItem.forecast.Amount__c != null) item.forecast.Amount__c += tempItem.forecast.Amount__c;
            
            list_tmp.add(tempItem);
        }
        fcs.list_editForecasts.clear();
        fcs.list_editForecasts.addAll(list_tmp);       
    }
    
      /**
    * The method is used to convert opportunity forecast structure for Manual
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param     forecast structure, level
    *
    @return            
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static void transferStructureFromPart(ClsOpportunityForecastStructure.ForecastStructure fcs, List<ClsOpportunityForecastStructure.ForecastStructure> list_pfcs, String level){
        fcs.list_editForecasts.clear();        
        Integer index = 0;
        for(ClsOpportunityForecastStructure.ForecastStructure pfcs :list_pfcs){         
            if(index == 0){
                for(ClsOpportunityForecastStructure.ForecastItemStructure pItem :pfcs.list_editForecasts){
                    ClsOpportunityForecastStructure.ForecastItemStructure oItem = new ClsOpportunityForecastStructure.ForecastItemStructure(level, null, fcs.oppyId, fcs.recordTypeId);
                    oItem.forecast.Quantity__c = pItem.forecast.Quantity__c;
                    oItem.forecast.Date__c = pItem.forecast.Date__c;
                    oItem.label= pItem.label;
                    oItem.forecast.Amount__c = pItem.forecast.Amount__c;                
                    fcs.list_editForecasts.add(oItem);
                }
            }
            else if(index > 0){
                Integer i = 0;
                for(ClsOpportunityForecastStructure.ForecastItemStructure pItem :pfcs.list_editForecasts){
                    if(fcs.list_editForecasts[i].forecast.Quantity__c == null) fcs.list_editForecasts[i].forecast.Quantity__c = 0;
                    if(fcs.list_editForecasts[i].forecast.Amount__c == null) fcs.list_editForecasts[i].forecast.Amount__c = 0;                  
                    if(pItem.forecast.Quantity__c != null) fcs.list_editForecasts[i].forecast.Quantity__c += pItem.forecast.Quantity__c;
                    if(pItem.forecast.Amount__c != null) fcs.list_editForecasts[i].forecast.Amount__c += pItem.forecast.Amount__c;                  
                    i++;
                }
            }           
            index++;
        }              
    }
    
      /**
    * The method is used to convert structure
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param     forecast structure, level
    *
    @return            
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static void convertStructure(ClsOpportunityForecastStructure.ForecastStructure fcs, String level){
        if(level == ClsOppyUtilAPL.YEARLY){
            List<ClsOpportunityForecastStructure.ForecastItemStructure> list_tmp = fcs.calQuarterForecastByYear(fcs.list_editForecasts.get(0));
            fcs.list_editForecasts.clear();
            fcs.list_editForecasts.addAll(list_tmp);
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
        List<Opportunity_Forecast__c> list_upsertForecasts = new List<Opportunity_Forecast__c>();
        Map<String, Map<Id, Opportunity_Forecast__c>> map_forecasts = new Map<String, Map<Id, Opportunity_Forecast__c>>();
        Map<String, Map<Id, Opportunity_Forecast__c>> map_oppyForecasts = new Map<String, Map<Id, Opportunity_Forecast__c>>();
        getAllFiscalQuarter();
        // aggregate all forecasts of parts
        for(Opportunity_Forecast__c ofc : [select Id, Name, Five_Year_Amount__c, RecordTypeId, CurrencyIsoCode, Date__c, Sales_Price__c, Quantity__c, Amount__c, Opportunity__c, Part__c, Part__r.Quantity__c, Part__r.Status__c, Forecasting_Start_Date__c from Opportunity_Forecast__c where Opportunity__r.Program__c = :oppyId and Part__c != null and Date__c != null order by Part__r.Name]){   
            String ym = ofc.Date__c.format();         
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
                //else fc.Amount__c = ofc.Amount__c;
                else{
                    fc.Amount__c = ofc.Amount__c;
                }
                fc.Five_Year_Amount__c= ofc.Five_Year_Amount__c; // ADDED FOR R1168
                fc.RecordTypeId = RecordTypeId;
                fc.Opportunity__c = ofc.Opportunity__c;
                fc.Sales_Price__c = ofc.Sales_Price__c;
                fc.Date__c = ofc.Date__c;
                fc.CurrencyIsoCode = ofc.CurrencyIsoCode;
                fc.Fiscal_Year__c = getForecastYear(ofc.Date__c);
                String tmpQuarter = getForecastQuarter(ofc.Date__c);
                if(tmpQuarter != '') fc.Fiscal_Quarter__c = '0' + tmpQuarter;
                fc.Forecasting_Start_Date__c = ofc.Forecasting_Start_Date__c;
                map_forecasts.get(ym).put(ofc.Opportunity__c, fc);
            }
            else {
                // added by min
                if(ofc.Part__r.Status__c != 'Lost' && ofc.Part__r.Status__c != 'Dead') map_forecasts.get(ym).get(ofc.Opportunity__c).Amount__c += ofc.Amount__c==null?0:ofc.Amount__c;               
                map_forecasts.get(ym).get(ofc.Opportunity__c).Five_Year_Amount__c+= ofc.Five_Year_Amount__c==null?0:ofc.Five_Year_Amount__c;
            }       
        }
        
        // get the forecasts to delete and update
        for(String ym: map_forecasts.keySet()){
            list_upsertForecasts.addAll(map_forecasts.get(ym).values());                    
        }
        
        try{
            //system.debug('list_upsertForecasts: ' + list_upsertForecasts);
            if(list_upsertForecasts.size() > 0){
                upsert list_upsertForecasts;
            }
        }   
        catch(Exception ex){
            ApexPages.addMessages(ex);          
        }       
    } 
        
      /**
    * The method is initialize the opportunity forecast structures
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
    public static void initOppyForecastStructures(map<Id, String> map_oppyPartId_isoCode, String opportunityIsocode, Map<Id, Id> map_partId_oppyId, List<ClsOpportunityForecastStructure> list_forecastStructures, List<String> list_years, Map<String, List<Opportunity_Forecast__c>> map_year_oppyForecast, Map<String, Map<Id, List<Opportunity_Forecast__c>>> map_year_map_partId_oppyForecast, String level, Id oppyId, Id forecastOppyRecordTypeId, Id forecastPartRecordTypeId, List<Id> list_partIds){         
        list_forecastStructures.clear();
        for(String year: list_years){
            if(!map_year_oppyForecast.containsKey(year)){
                map_year_oppyForecast.put(year, new List<Opportunity_Forecast__c>{});       
            }
            if(!map_year_map_partId_oppyForecast.containsKey(year)){
                Map<Id, List<Opportunity_Forecast__c>> map_id_newOpp = new Map<Id, List<Opportunity_Forecast__c>>();
                map_year_map_partId_oppyForecast.put(year, map_id_newOpp);
                for(Id id: list_partIds){
                    map_year_map_partId_oppyForecast.get(year).put(id, new List<Opportunity_Forecast__c>{});                        
                }       
            }
            else{
                for(Id id: list_partIds){
                    if(!map_year_map_partId_oppyForecast.get(year).containsKey(id)){
                        map_year_map_partId_oppyForecast.get(year).put(id, new List<Opportunity_Forecast__c>{});
                    }
                }
            }                           
        }
        
        for(String year: list_years){
            ClsOpportunityForecastStructure OppyForecastStructure = new ClsOpportunityForecastStructure(
                                                                         map_oppyPartId_isoCode, opportunityIsocode,
                                                                         map_year_oppyForecast.get(year),
                                                                         map_year_map_partId_oppyForecast.get(year),
                                                                         year, oppyId, map_partId_oppyId, forecastOppyRecordTypeId, forecastPartRecordTypeId, level, list_partIds);
            list_forecastStructures.add(OppyForecastStructure);
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
            for(Opportunity_Forecast__c ofc: [select id, Name, Five_Year_Amount__c, Quantity__c, Amount__c, Opportunity__c, Part__c, Sales_Price__c, Date__c,Fiscal_Year__c, Fiscal_Quarter__c from Opportunity_Forecast__c where Opportunity__c in :map_oppyid_opportunity.keySet() and Part__c = null and Date__c != null order by Opportunity__c, Date__c]){
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
                                if((y != null && y > startYear && y < endYear) || (y != null && q != null && y == startYear && q >= startQuarter) || (y != null && q != null && y == endYear && q <= endQuarter)){
                                    year5Revenue += ofc.Amount__c;
                                    year5Revenue_Cust += ofc.Five_Year_Amount__c;
                                }
                            }
                            // calculate total revenue
                            totalRevenue += ofc.Amount__c;
                             totalRevenue_Cust += ofc.Five_Year_Amount__c;
                        }                       
                    }
                }            
                map_oppyid_opportunity.get(id).Amount = totalRevenue;
                map_oppyid_opportunity.get(id).Five_Year_Revenue__c = year5Revenue;
                 // ######### Added Five Year Value,Total Opportunity value functionality BY RAVI <ravikumar.vasimalla@zensar.in>##########
    
                map_oppyid_opportunity.get(id).Total_Opportunity_Value__c = totalRevenue_Cust;
                map_oppyid_opportunity.get(id).Five_Year_Value__c = year5Revenue_Cust;
 
                map_oppyid_opportunity.get(id).Manufacturing_Start_Date__c = closeDate;
                if(method != null){
                    map_oppyid_opportunity.get(id).Method__c = method;
                }
                if(level != null){
                    map_oppyid_opportunity.get(id).Level__c = level;
                }
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
        if(level == ClsOppyUtilAPL.MONTHLY){
            query += ' and Type = \'Month\''; 
        }
        else if(level == ClsOppyUtilAPL.QUARTERLY){
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
        if(level == ClsOppyUtilAPL.MONTHLY){
            query += ' and Type = \'Month\' order by StartDate limit 60'; 
        }
        else if(level == ClsOppyUtilAPL.QUARTERLY){
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
    */
    public static void updateOpportunityAmounts(Map<Id, Opportunity> map_oppyid_opportunity, String method, String level, Opportunity opportunity){     
        Map<Id, List<Opportunity_Forecast__c>> map_oppyid_forecasts = new Map<Id, List<Opportunity_Forecast__c>>();
        
        //************************************************
        //START: update the oppys and program
        //************************************************
        recalculateRevenue(map_oppyid_opportunity, method, level, opportunity.Manufacturing_Start_Date__c);
        try{
            if(map_oppyid_opportunity.size() > 0){
                update map_oppyid_opportunity.values();
            }
        }   
        catch(Exception ex){
            ApexPages.addMessages(ex);          
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
            for(Opportunity oppy: [select id, Program__c, Name, Amount, Five_Year_Value__c, Total_Opportunity_Value__c, CurrencyIsoCode, Five_Year_Revenue__c from Opportunity where Program__c = :opportunity.Program__c or Id = :opportunity.Program__c]){
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
            }
        }
        //************************************************
        //END: update the program if necessary 
        //************************************************          
    }
    
    public static void updateProgramTotalFiveYearsAmount(Opportunity program, set<Opportunity> set_programOppys){
        Decimal totalRevenue = 0;
        Decimal year5Revenue = 0;
        // FOR R1168
        Decimal totalRevenue_Cust = 0;
        Decimal year5Revenue_Cust = 0;
        
        
        getExchangeRate();
        for(Opportunity oppy :set_programOppys){ 
            if(oppy.CurrencyIsoCode == program.CurrencyIsoCode){       
                totalRevenue += oppy.Amount==null?0:oppy.Amount;
                // FOR R1168
                totalRevenue_Cust += oppy.Total_Opportunity_Value__c==null?0:oppy.Total_Opportunity_Value__c;
            }
            else if(oppy.Amount != null){
                totalRevenue += transformIsoCode(oppy.Amount, oppy.CurrencyIsoCode, program.CurrencyIsoCode);
                //FOR 1168
                totalRevenue_Cust += transformIsoCode(oppy.Total_Opportunity_Value__c, oppy.CurrencyIsoCode, program.CurrencyIsoCode);
            }
            if(oppy.CurrencyIsoCode == program.CurrencyIsoCode){       
                year5Revenue += oppy.Five_Year_Revenue__c==null?0:oppy.Five_Year_Revenue__c;
                //FOR R1168
                year5Revenue_Cust += oppy.Five_Year_Value__c==null?0:oppy.Five_Year_Value__c;
            }
            else if(oppy.Five_Year_Revenue__c != null){
                year5Revenue += transformIsoCode(oppy.Five_Year_Revenue__c, oppy.CurrencyIsoCode, program.CurrencyIsoCode);
                //FOR 1168
                year5Revenue_Cust += transformIsoCode(oppy.Five_Year_Value__c, oppy.CurrencyIsoCode, program.CurrencyIsoCode);
            }
            
            program.Amount = totalRevenue;
            program.Five_Year_Revenue__c = year5Revenue;
            // ######### Added Five Year Value,Total Opportunity value functionality BY RAVI <ravikumar.vasimalla@zensar.in>##########
    
            program.Total_Opportunity_Value__c = totalRevenue_Cust;
            program.Five_Year_Value__c = year5Revenue_Cust;
 
        }       
    }
    
    
    
    
    /**
    * The method is used to reset the forecast according to year and quarter(or month)
    *
    @author Bin yu
    @created 2012-03-01
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param  year to set, list of items, difference of quarter or month, map of the new structures
    *
    @return            
    *
    @changelog
    * 2012-03-01 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static void resetForecastByMoveDate(String keyYear, ClsOpportunityForecastStructure.ForecastStructure inputFS, Integer diffQtMn, Map<String, ClsOpportunityForecastStructure> map_year_structure, String level, String dataType, Integer partIndex, List<String>list_years){
        // set the label of quarter or month
        Integer itemQtMn = 1;
        Integer qtMnNumber = 4;
        // quarterly
        if(level == QUARTERLY) {
            qtMnNumber = 4;
        }
        // monthly
        else if(level == MONTHLY) {
            qtMnNumber = 12;
        }
        // yearly
        else {
            qtMnNumber = 1;
        }
        for(ClsOpportunityForecastStructure.ForecastItemStructure item: inputFS.list_editForecasts){            
            if(level == QUARTERLY) {
                itemQtMn = MAP_QUARTERVALUE.get(item.label) + diffQtMn;
            }
            else if(level == MONTHLY) {
                itemQtMn = MAP_MONTHVALUE.get(item.label) + diffQtMn;
            }
            String tmpKeyYear = keyYear;
            // decide if the forecast will be put into next year or previous year
            if(itemQtMn > qtMnNumber){
                tmpKeyYear = ClsOppyUtilAPL.yearByIndex(list_years, tmpKeyYear, 1);
                if(tmpKeyYear == '') continue;
                itemQtMn = itemQtMn - qtMnNumber;
            }
            else if(itemQtMn < 1){
                tmpKeyYear = ClsOppyUtilAPL.yearByIndex(list_years, tmpKeyYear, -1);
                if(tmpKeyYear == '') continue;
                itemQtMn = qtMnNumber + itemQtMn;
            }
            
            if(level == QUARTERLY) item.label = MAP_QUARTERLABEL.get(itemQtMn);
            else if(level == MONTHLY) item.label = MAP_THEMONTHLABEL.get(itemQtMn);
            else item.label = 'year';
            
            if(map_year_structure.containsKey(tmpKeyYear)){             
                // rebuild opportunity forecasts
                if(dataType == 'Oppy'){
                    //map_year_structure.get(tmpKeyYear).forecastStructure.salesPriceOF.Sales_Price__c = inputFS.salesPriceOF.Sales_Price__c;
                    for(ClsOpportunityForecastStructure.ForecastItemStructure newItem: map_year_structure.get(tmpKeyYear).forecastStructure.list_editForecasts){
                        if(newItem.label == item.label) {
                            newItem.forecast = item.forecast;
                            newItem.forecast.Amount__c = 0;
                            newItem.forecast.Fiscal_Year__c = tmpKeyYear;
                            break;
                        }
                    }
                }
                // rebuild part forecasts
                else{
                    //map_year_structure.get(tmpKeyYear).partForecasts[partIndex].salesPriceOF.Sales_Price__c = inputFS.salesPriceOF.Sales_Price__c;
                    for(ClsOpportunityForecastStructure.ForecastItemStructure newItem: map_year_structure.get(tmpKeyYear).partForecasts[partIndex].list_editForecasts){                     
                        if(newItem.label == item.label) {
                            newItem.forecast = item.forecast;
                            newItem.forecast.Fiscal_Year__c = tmpKeyYear;
                            if(newItem.forecast.Quantity__c != null && map_year_structure.get(tmpKeyYear).partForecasts[partIndex].salesPriceOF.Sales_Price__c != null){
                                newItem.forecast.Amount__c = newItem.forecast.Quantity__c * map_year_structure.get(tmpKeyYear).partForecasts[partIndex].salesPriceOF.Sales_Price__c ;                               
                            }                           
                            break;
                        }
                    }
                }           
            }
        }
    }
    
     /**
    * The method is used to get the index of the year list
    *
    @author Bin yu
    @created 2012-03-03
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param    list of years, the specified year
    *
    @return   the index of the specified year        
    *
    @changelog
    * 2012-03-03 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public static Integer yearListIndex(List<String> list_years, String inputYear){
        Integer index = 0;
        for(String year: list_years){
            if(inputYear == year) return index;
            index++;
        }       
        return index;
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
    * The method is used to delete the oppy forecasts of a oppy part, if this part has been deleted, and update the total revenue and five years revenue of this part's oppy 
    
    *
    @author Bin yu
    @created 2012-05-08
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param             
    *
    @return     
    *
    @changelog
    * 2012-05-08 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */

    public static List<Opportunity_Forecast__c> deleteForecastUpdateOppys(Set<Id> set_partIds){     
        Map<Id, Opportunity_Forecast__c> map_forecast2Del = new Map<Id, Opportunity_Forecast__c>();
        try{
            if(set_partIds.size() > 0){
                list<Opportunity> list_oppys2update = new list<Opportunity>();
                list<Opportunity_Forecast__c> list_fcs2update = new list<Opportunity_Forecast__c>();
                Map<Id, List<Opportunity_Forecast__c>> map_oppyid_forecasts = new Map<Id, List<Opportunity_Forecast__c>>(); 
                Set<Id> set_oppyPrgmIdNoParts = new Set<Id>();       
                Set<Id> set_oppyPrgmIds = new Set<Id>();
                Set<Id> set_programIds = new Set<Id>();
                map<Id, Map<Date, Decimal>> map_oppyId_date_reducedAmount= new map<Id, Map<Date, Decimal>>(); 
                map<Id, Map<Date, Decimal>> map_oppyId_date_reducedAmount_Cust= new map<Id, Map<Date, Decimal>>(); 
                
                
                //added by xia 2012-12-20
                for(Opportunity_Part__c part : [Select Opportunity__c, Opportunity__r.Program__c from Opportunity_Part__c where Id in :set_partIds ]){
                    if(part.Opportunity__c != null)set_oppyPrgmIds.add(part.Opportunity__c);
                    if(part.Opportunity__r.Program__c != null)set_oppyPrgmIds.add(part.Opportunity__r.Program__c);
                
                }
                for(Opportunity_Forecast__c ofc: [select  id, Name, Five_Year_Amount__c, Quantity__c, Amount__c, Opportunity__c, Opportunity__r.Program__c, Part__c, Part__r.Quantity__c, Part__r.Status__c, Date__c, Opportunity__r.Method__c  from Opportunity_Forecast__c where Part__c in :set_partIds order by Opportunity__c, Date__c]){
                    //************************************************
                    //START: get all related oppy and programs
                    //************************************************   
                    set_oppyPrgmIds.add(ofc.Opportunity__c);
                    if(ofc.Opportunity__r.Program__c != null) set_oppyPrgmIds.add(ofc.Opportunity__r.Program__c);
                    //************************************************
                    //END: get all related oppy and programs
                    //************************************************   
                    
                    // put Forecasts to be deleted into a map               
                    map_forecast2Del.put(ofc.Id, ofc);   
                }
                
                //************************************************
                //START: calculate the quantity and amount to be reduced
                //************************************************ 
                for(Opportunity_Forecast__c ofc: map_forecast2Del.values()){    
                    if(ofc.Date__c != null && ofc.Quantity__c != null && ofc.Part__r.Status__c != 'Lost' && ofc.Part__r.Status__c != 'Dead'){        
                        Decimal amount = 0;
                        Decimal amount_Cust = 0;
                        if(!map_oppyId_date_reducedAmount.containsKey(ofc.Opportunity__c)){
                            map_oppyId_date_reducedAmount.put(ofc.Opportunity__c, new map<Date,Decimal>());
                        }                   
                        
                        if(!map_oppyId_date_reducedAmount.get(ofc.Opportunity__c).containsKey(ofc.Date__c)){
                            map_oppyId_date_reducedAmount.get(ofc.Opportunity__c).put(ofc.Date__c, 0);
                        }
                        
                        if(!map_oppyId_date_reducedAmount_Cust.containsKey(ofc.Opportunity__c)){
                            map_oppyId_date_reducedAmount_Cust.put(ofc.Opportunity__c, new map<Date,Decimal>());
                        }                   
                        
                        if(!map_oppyId_date_reducedAmount_Cust.get(ofc.Opportunity__c).containsKey(ofc.Date__c)){
                            map_oppyId_date_reducedAmount_Cust.get(ofc.Opportunity__c).put(ofc.Date__c, 0);
                        }
                        
                        amount =  map_oppyId_date_reducedAmount.get(ofc.Opportunity__c).get(ofc.Date__c);
                        amount += ofc.Amount__c==null?0:ofc.Amount__c;
                        map_oppyId_date_reducedAmount.get(ofc.Opportunity__c).put(ofc.Date__c,amount); 
                        amount_cust =  map_oppyId_date_reducedAmount_Cust.get(ofc.Opportunity__c).get(ofc.Date__c);
                        amount_cust += ofc.Five_Year_Amount__c==null?0:ofc.Five_Year_Amount__c;
                        map_oppyId_date_reducedAmount_Cust.get(ofc.Opportunity__c).put(ofc.Date__c,amount_cust); 
                        
                        if(ofc.Opportunity__r.Program__c != null){
                            if(!map_oppyId_date_reducedAmount.containsKey(ofc.Opportunity__r.Program__c)){
                                map_oppyId_date_reducedAmount.put(ofc.Opportunity__r.Program__c, new map<Date, Decimal>());
                            }                   
                            if(!map_oppyId_date_reducedAmount_Cust.containsKey(ofc.Opportunity__r.Program__c)){
                                map_oppyId_date_reducedAmount_Cust.put(ofc.Opportunity__r.Program__c, new map<Date, Decimal>());
                            } 
                            if(!map_oppyId_date_reducedAmount.get(ofc.Opportunity__r.Program__c).containsKey(ofc.Date__c)){
                                map_oppyId_date_reducedAmount.get(ofc.Opportunity__r.Program__c).put(ofc.Date__c, amount);
                            }
                            else{
                                amount +=  map_oppyId_date_reducedAmount.get(ofc.Opportunity__r.Program__c).get(ofc.Date__c);
                                map_oppyId_date_reducedAmount.get(ofc.Opportunity__r.Program__c).put(ofc.Date__c,amount);           
                            } 
                            if(!map_oppyId_date_reducedAmount_Cust.get(ofc.Opportunity__r.Program__c).containsKey(ofc.Date__c)){
                                map_oppyId_date_reducedAmount_Cust.get(ofc.Opportunity__r.Program__c).put(ofc.Date__c, amount_Cust);
                            }
                            else{
                                amount_Cust +=  map_oppyId_date_reducedAmount.get(ofc.Opportunity__r.Program__c).get(ofc.Date__c);
                                map_oppyId_date_reducedAmount_Cust.get(ofc.Opportunity__r.Program__c).put(ofc.Date__c,amount_Cust);           
                            }                        
 
                        }                               
                    } 
                    else{
                        //Added to calculate lost and hold ofc details.
                        Decimal amount_Cust = 0;
 
                        if(!map_oppyId_date_reducedAmount_Cust.containsKey(ofc.Opportunity__c)){
                            map_oppyId_date_reducedAmount_Cust.put(ofc.Opportunity__c, new map<Date,Decimal>());
                        }                   
                        
                        if(!map_oppyId_date_reducedAmount_Cust.get(ofc.Opportunity__c).containsKey(ofc.Date__c)){
                            map_oppyId_date_reducedAmount_Cust.get(ofc.Opportunity__c).put(ofc.Date__c, 0);
                        }
                        
                        amount_cust =  map_oppyId_date_reducedAmount_Cust.get(ofc.Opportunity__c).get(ofc.Date__c);
                        amount_cust += ofc.Five_Year_Amount__c==null?0:ofc.Five_Year_Amount__c;
                        map_oppyId_date_reducedAmount_Cust.get(ofc.Opportunity__c).put(ofc.Date__c,amount_cust); 
                        
 
                        if(ofc.Opportunity__r.Program__c != null){
                            if(!map_oppyId_date_reducedAmount_Cust.containsKey(ofc.Opportunity__r.Program__c)){
                                map_oppyId_date_reducedAmount_Cust.put(ofc.Opportunity__r.Program__c, new map<Date, Decimal>());
                            }                   
                            
                            if(!map_oppyId_date_reducedAmount_Cust.get(ofc.Opportunity__r.Program__c).containsKey(ofc.Date__c)){
                                map_oppyId_date_reducedAmount_Cust.get(ofc.Opportunity__r.Program__c).put(ofc.Date__c, amount_Cust);
                            }
                            else{
                                amount_Cust +=  map_oppyId_date_reducedAmount_Cust.get(ofc.Opportunity__r.Program__c).get(ofc.Date__c);
                                map_oppyId_date_reducedAmount_Cust.get(ofc.Opportunity__r.Program__c).put(ofc.Date__c,amount_Cust);           
                            }  
                        }                               
                    }                                   
                }
                
                
                
                
                
                
                                    
                //************************************************
                //END: calculate the quantity and amount to be reduced
                //************************************************              
                                              
                //system.debug('map_oppyId_date_reducedAmount: ' + map_oppyId_date_reducedAmount);
                
                if(set_oppyPrgmIds.size() > 0){
                    //************************************************
                    //START: get oppy und program which has no parts
                    //************************************************  
                    //set_oppyPrgmIdNoParts.addAll(set_oppyPrgmIds);
                    set_oppyPrgmIdNoParts = set_oppyPrgmIds.clone();
                    //for(Opportunity_Part__c part : [Select Opportunity__c, Opportunity__r.Program__c from Opportunity_Part__c where Id not in :set_partIds and (Opportunity__c in :set_oppyPrgmIds or Opportunity__r.Program__c in :set_oppyPrgmIds)]){         
                    //    set_oppyPrgmIdNoParts.remove(part.Opportunity__c);
                    //    set_oppyPrgmIdNoParts.remove(part.Opportunity__r.Program__c);
                    //}
                    
                    for(Opportunity_Forecast__c ofc: [select Opportunity__c, Five_Year_Amount__c, Opportunity__r.Program__c from Opportunity_Forecast__c where Part__c != null and id not in: map_forecast2Del.keySet() and (Opportunity__c in :set_oppyPrgmIds or Opportunity__r.Program__c in :set_oppyPrgmIds)]){
                        set_oppyPrgmIdNoParts.remove(ofc.Opportunity__c);
                        set_oppyPrgmIdNoParts.remove(ofc.Opportunity__r.Program__c);
                    }
                    //************************************************
                    //END: get oppy und program which has no parts
                    //************************************************  
                    
                    //************************************************
                    //START: update the forecast for oppys/programs
                    //************************************************                  
                    for(Opportunity_Forecast__c ofc: [select id, Name, Quantity__c, Five_Year_Amount__c, Amount__c, Opportunity__c, Date__c from Opportunity_Forecast__c where Opportunity__c in :set_oppyPrgmIds and Part__c = null order by Opportunity__c, Date__c]){
                        if(set_oppyPrgmIdNoParts.contains(ofc.Opportunity__c)){
                            map_forecast2Del.put(ofc.Id, ofc);   
                        }
                        else{
                            if(map_oppyId_date_reducedAmount.containsKey(ofc.Opportunity__c) && map_oppyId_date_reducedAmount.get(ofc.Opportunity__c).containsKey(ofc.Date__c)){
                               ofc.Amount__c -= map_oppyId_date_reducedAmount.get(ofc.Opportunity__c).get(ofc.Date__c);
                            }
                            if(map_oppyId_date_reducedAmount_Cust.containsKey(ofc.Opportunity__c) && map_oppyId_date_reducedAmount_Cust.get(ofc.Opportunity__c).containsKey(ofc.Date__c)){
                               ofc.Five_Year_Amount__c-= map_oppyId_date_reducedAmount_Cust.get(ofc.Opportunity__c).get(ofc.Date__c);
                            }
                            
                            list_fcs2update.add(ofc);   
                        }
                    }
    
                    if(list_fcs2update.size() > 0){
                        //system.debug('list_fcs2update: ' + list_fcs2update);
                        update list_fcs2update;
                        list_fcs2update.clear();
                    }               
                    //************************************************
                    //END: update the forecast for oppys/programs
                    //************************************************      
                    
                    //************************************************
                    //START: update all related oppys/programs
                    //************************************************                  
                    for(Opportunity_Forecast__c ofc: [select id, Five_Year_Amount__c, Name, Quantity__c, Amount__c, Opportunity__c, Opportunity__r.Program__c, Opportunity__r.closeDate,Opportunity__r.Manufacturing_Start_Date__c, Part__c, Sales_Price__c, Date__c, Fiscal_Year__c, Fiscal_Quarter__c, Part__r.Status__c from Opportunity_Forecast__c where Opportunity__c in :set_oppyPrgmIds and Part__c != null and Part__c not in :set_partIds and Date__c != null and Id not in :map_forecast2Del.keySet() order by Opportunity__c, Date__c]){
                        if(!map_oppyid_forecasts.containsKey(ofc.Opportunity__c)){
                            map_oppyid_forecasts.put(ofc.Opportunity__c, new List<Opportunity_Forecast__c>());
                        }
                        map_oppyid_forecasts.get(ofc.Opportunity__c).add(ofc);     
                    }    
                                                        
                    map<Id, Opportunity> map_oppyid_opportunity = new map<Id, Opportunity>();
                    set<Date> set_startDate = new set<Date>();
                    
                    
                    
                                                          
                    for(Opportunity opp : [Select Id, Program__c, RecordType.DeveloperName, Five_Year_Value__c, Total_Opportunity_Value__c, CurrencyIsoCode, Amount, Five_Year_Revenue__c, closeDate,Manufacturing_Start_Date__c from Opportunity where Id in :set_oppyPrgmIds or Program__c in :set_oppyPrgmIds]){
                        map_oppyid_opportunity.put(opp.Id, opp);
                        if(map_oppyid_forecasts.containsKey(opp.Id)){
                            set_startDate.add(opp.Manufacturing_Start_Date__c);
                        }
                    }
                    
                    Map<Date, Map<String, Map<Integer, Integer>>> map_date_startEndQuarter = getFiveYearsInternal(set_startDate); 
                    Map<Id, Map<String, Integer>> map_oppyId_startEndDate = new Map<Id, Map<String, Integer>>();
                    //system.debug('map_oppyid_forecasts: ' + map_oppyid_forecasts);
                    
                    for(Id id: map_oppyid_opportunity.keySet()){
                        Opportunity oppy = map_oppyid_opportunity.get(id);
                        if(oppy.RecordType.DeveloperName != 'Program' ){ // only oppys
                            if(map_oppyid_forecasts.containsKey(id)){
                                Integer startYear, startQuarter, endYear, endQuarter; 
                                map_oppyId_startEndDate.put(id, new Map<String, Integer>());
                                for(String t: map_date_startEndQuarter.get(oppy.Manufacturing_Start_Date__c).keySet()){           
                                    for(Integer y : map_date_startEndQuarter.get(oppy.Manufacturing_Start_Date__c).get(t).keySet()){
                                        if(t == 'Start'){
                                            startYear = y;
                                            startQuarter = map_date_startEndQuarter.get(oppy.Manufacturing_Start_Date__c).get(t).get(y);
                                            map_oppyId_startEndDate.get(id).put('startYear', startYear);
                                            map_oppyId_startEndDate.get(id).put('startQuarter', startQuarter);
                                        }
                                        else{
                                            endYear = y;
                                            endQuarter = map_date_startEndQuarter.get(oppy.Manufacturing_Start_Date__c).get(t).get(y);  
                                            map_oppyId_startEndDate.get(id).put('endYear', endYear);
                                            map_oppyId_startEndDate.get(id).put('endQuarter', endQuarter);                  
                                        }
                                    }
                                }
                            }
                        }              
                    }
                    
                    Map<Id, Set<Opportunity>> map_programId_oppys = new Map<Id, Set<Opportunity>>();
                    for(Id id: map_oppyid_opportunity.keySet()){                        
                        Opportunity oppy = map_oppyid_opportunity.get(id);
                        if(oppy.RecordType.DeveloperName != 'Program' ){ // only oppys
                            
                            if(map_oppyid_forecasts.containsKey(id)){
                                Decimal totalRevenue = 0;
                                Decimal year5Revenue = 0; 
                                
                                Decimal totalRevenue_Cust = 0;
                                Decimal year5Revenue_Cust = 0;                                
                                                          
                                Integer startYear, startQuarter, endYear, endQuarter; 
                                startYear = map_oppyId_startEndDate.get(id).get('startYear');          
                                startQuarter = map_oppyId_startEndDate.get(id).get('startQuarter'); 
                                endYear = map_oppyId_startEndDate.get(id).get('endYear');   
                                endQuarter = map_oppyId_startEndDate.get(id).get('endQuarter');     
                                for(Opportunity_Forecast__c  ofc: map_oppyid_forecasts.get(id)){
                                    if(ofc.Part__r.Status__c != 'Dead' && ofc.Part__r.Status__c != 'Lost'){
                                        if(ofc.Date__c != null && ofc.Opportunity__r.Manufacturing_Start_Date__c != null){
                                              // calculate the five year revenue
                                              Integer y = Integer.valueOf(ofc.Fiscal_Year__c);
                                              Integer q = Integer.valueOf(ofc.Fiscal_Quarter__c);
                                              if((y > startYear && y < endYear) || (y == startYear && q >= startQuarter) || (y == endYear && q <= endQuarter)){
                                                  // modify by lili zhao 2014-08-05 begin due to fix the bug of Update Oppotunity failed.   
                                                  //year5Revenue += ofc.Amount__c;
                                                  //year5Revenue_Cust += ofc.Five_Year_Amount__c;                                                 
                                                  year5Revenue += (ofc.Amount__c != null ? ofc.Amount__c : 0);      
                                                  year5Revenue_Cust += (ofc.Five_Year_Amount__c != null ? ofc.Five_Year_Amount__c : 0);                                                                                       
                                                  // end
                                               }                    
                                        }   
                                      // modify by lili zhao 2014-08-05 begin due to fix the bug of Update Oppotunity failed.                                          
                                      totalRevenue += (ofc.Amount__c != null ? ofc.Amount__c : 0);      
                                      totalRevenue_Cust += (ofc.Five_Year_Amount__c != null ? ofc.Five_Year_Amount__c : 0);   
                                      //totalRevenue += ofc.Amount__c;
                                      //totalRevenue_Cust += ofc.Five_Year_Amount__c;   
                                      // end
                                  }                                         
                                  else{
                                      if(ofc.Date__c != null && ofc.Opportunity__r.Manufacturing_Start_Date__c != null){
                                          // calculate the five year revenue
                                          Integer y = Integer.valueOf(ofc.Fiscal_Year__c);
                                          Integer q = Integer.valueOf(ofc.Fiscal_Quarter__c);
                                          if((y > startYear && y < endYear) || (y == startYear && q >= startQuarter) || (y == endYear && q <= endQuarter)){
                                              //year5Revenue += ofc.Amount__c;
                                              // modify by lili zhao 2014-08-05 begin due to fix the bug of Update Oppotunity failed.   
                                              //year5Revenue_Cust += ofc.Five_Year_Amount__c;
                                              year5Revenue_Cust += (ofc.Five_Year_Amount__c != null ? ofc.Five_Year_Amount__c : 0);  
                                              // end
                                          }                    
                                      }              
                                      //totalRevenue += ofc.Amount__c;
                                      // modify by lili zhao 2014-08-05 begin due to fix the bug of Update Oppotunity failed.   
                                      //totalRevenue_Cust += ofc.Five_Year_Amount__c;
                                      totalRevenue_Cust += (ofc.Five_Year_Amount__c != null ? ofc.Five_Year_Amount__c : 0);
                                      // end
                                  }
                                }   
                                oppy.Amount = totalRevenue;
                                oppy.Five_Year_Revenue__c = year5Revenue;  
                                 
        // ######### Added Five Year Value,Total Opportunity value functionality BY RAVI <ravikumar.vasimalla@zensar.in>##########
        
                                oppy.Total_Opportunity_Value__c = totalRevenue_Cust;
                                oppy.Five_Year_Value__c = year5Revenue_Cust;  
                                
                                system.debug('--------Total Opportunity Value------------'+oppy.Total_Opportunity_Value__c);
                                system.debug('--------Five Year Value------------'+oppy.Five_Year_Value__c);
                                                                
                                list_oppys2update.add(oppy);                            
                            }
                            else{
                                if(set_oppyPrgmIdNoParts.contains(id)){
                                    oppy.Five_Year_Revenue__c = 0;
                                    oppy.Amount = 0;
                                                                       
    // ######### Added Five Year Value,Total Opportunity value functionality BY RAVI <ravikumar.vasimalla@zensar.in>##########
    
                                    oppy.Five_Year_Value__c = 0;
                                    oppy.Total_Opportunity_Value__c = 0;
      
                                    list_oppys2update.add(oppy);
                                }                       
                            }
                            if(oppy.Program__c != null){ // only oppys
                                if(!map_programId_oppys.containsKey(oppy.Program__c)){
                                    map_programId_oppys.put(oppy.Program__c, new Set<Opportunity>());
                                }                           
                                map_programId_oppys.get(oppy.Program__c).add(oppy);   
                            }                       
                        }  
                    } 
                    //system.debug('list_oppys2update: ' + list_oppys2update);
                    for(Id pid : map_programId_oppys.keySet()){
                        Opportunity program = map_oppyid_opportunity.get(pid);
                        if(set_oppyPrgmIdNoParts.contains(pid)){
                            program.Five_Year_Revenue__c = 0;
                            program.Amount = 0;
                                                        
    // ######### Added Five Year Value,Total Opportunity value functionality BY RAVI <ravikumar.vasimalla@zensar.in>##########
    
                            program.Five_Year_Value__c = 0;
                            program.Total_Opportunity_Value__c = 0;
 
                        }
                        else{
                            updateProgramTotalFiveYearsAmount(program, map_programId_oppys.get(pid));
                        }
                        list_oppys2update.add(program);
                    }
                    
                    if(list_oppys2update.size() > 0){
                        //system.debug('list_oppys2update: ' + list_oppys2update);
                        update list_oppys2update;
                    }
                    //************************************************
                    //END: update all related oppys/programs 
                    //************************************************                              
                }  
            }
        }
        catch(Exception ex){
            deletePartException = ex.getMessage();
            system.debug('exception: ' + ex);
        }   
        return map_forecast2Del.values();       
    }
    
    /** 
    * The method is used to created a opportunity part forecast for forecast migration batch 
    *
    @author Min Liu
    @created 2012-08-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @changelog
    * 2012-08-29 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public static void generateForecasts(SObject tf, Id oppyId, Id partId, String theYear, String yearType, String yearNum, Map<String, List<Opportunity_Forecast__c>> map_yearQuarter_partForecasts, String oppyCurrencyIsoCode, Id recordTypeId){
        getExchangeRate();
        getFiscalYearQuarterMap();
        //added by weihang 2013-05-28 begin
        boolean isConvert = getIsConvertVal();
        //added by weihang 2013-05-28 end
        for(Integer j = 1; j < 5; j++){
            // part forecast
            Opportunity_Forecast__c forecast4Part = new Opportunity_Forecast__c();
            forecast4Part.Opportunity__c = oppyId;
            forecast4Part.Part__c = partId;
            forecast4Part.Quantity__c = 0;
            forecast4Part.Sales_Price__c = 0;
            
            // quantity
            if(tf.get(yearType + yearNum + '_Q' + String.valueOf(j) + '_Forecast_Qty__c') != null) forecast4Part.Quantity__c = (Decimal)tf.get(yearType + yearNum + '_Q' + String.valueOf(j) + '_Forecast_Qty__c');            
            
            // sales price
            String topsCurrency = 'USD';    
            if(tf.get('CurrencyIsoCode') != null && String.valueOf(tf.get('CurrencyIsoCode')).trim() != '') topsCurrency = String.valueOf(tf.get('CurrencyIsoCode'));
            if(tf.get(yearType + yearNum + '_Estimated_Market_Price__c') != null){
                // the currency of tops forecast is always USD, so we should transfer it
                forecast4Part.Sales_Price__c = (Decimal)tf.get(yearType + yearNum + '_Estimated_Market_Price__c');          
                if(topsCurrency != 'USD' && isConvert){
                    forecast4Part.Sales_Price__c = transformIsoCode(forecast4Part.Sales_Price__c, 'USD', topsCurrency);
                }
                // set sales price according to opportunity currency
            }          
            // amount 
            forecast4Part.Amount__c = forecast4Part.Quantity__c * forecast4Part.Sales_Price__c;      
            forecast4Part.Fiscal_Year__c = theYear;
            forecast4Part.Fiscal_Quarter__c = '0' + String.valueOf(j);
            forecast4Part.CurrencyIsoCode = topsCurrency;
            //forecast4Part.CurrencyIsoCode = oppyCurrencyIsoCode;
            if(recordTypeId != null) forecast4Part.RecordTypeId = RecordTypeId;
                         
            // date
            if(theYear != ''){
                forecast4Part.Date__c = ClsOppyUtilAPL.getFiscalQuarterStartDate(theYear, String.valueOf(j));
            }
            // add forecast to list
            String tmpStr = forecast4Part.Fiscal_Year__c + forecast4Part.Fiscal_Quarter__c;
            if(!map_yearQuarter_partForecasts.containsKey(tmpStr)){
                map_yearQuarter_partForecasts.put(tmpStr, new List<Opportunity_Forecast__c>());
            }                           
            map_yearQuarter_partForecasts.get(tmpStr).add(forecast4Part);                   
        }
    }
    
    /** 
    * The method is the common method to update the close date, phase of programs
    *
    @author Min Liu
    @created 2012-09-17
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @changelog
    * 2012-09-17 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public static void recalculateConnectedProgram(List<Opportunity> list_triggerOppys, Set<Id> set_programId4Phase, String extType, List<Opportunity> list_program2Update){
        Map<Id, List<Date>> map_programId_closeDates = new Map<Id, List<Date>>();        
        Map<Id, Decimal> map_programId_totalRevenue = new Map<Id, Decimal>();
        Map<Id, Decimal> map_programId_5yearRevenue = new Map<Id, Decimal>();
         
        Map<Id, Decimal> map_programId_totalRevenue_Cust = new Map<Id, Decimal>();
        Map<Id, Decimal> map_programId_5yearRevenue_Cust = new Map<Id, Decimal>();
 
 
        Map<Id, String> map_programId_currencyIsoCode = new Map<Id, String>();
        Map<Id, Set<String>> map_programId_stages = new Map<Id, Set<String>>();
        //added by Jinbo Shan
        Map<Id, Set<String>> map_programId_approveStatus = new Map<Id, Set<String>>();
        
        getExchangeRate();
        for(Opportunity oppy :list_triggerOppys){
            if(oppy.Program__c != null){
                if(!map_programId_closeDates.containsKey(oppy.Program__c)){
                    map_programId_closeDates.put(oppy.Program__c, new List<Date>());                    
                    map_programId_totalRevenue.put(oppy.Program__c, 0);
                    map_programId_5yearRevenue.put(oppy.Program__c, 0);
                    
                    map_programId_totalRevenue_Cust.put(oppy.Program__c, 0);
                    map_programId_5yearRevenue_Cust.put(oppy.Program__c, 0);
                }               
            }
        }
        
        if(!map_programId_closeDates.isEmpty() || (set_programId4Phase != null && !set_programId4Phase.isEmpty())){
            for(Opportunity oppy :[select Program__c, closeDate,Manufacturing_Start_Date__c, Program__r.CurrencyIsoCode, StageName from Opportunity where Program__c != null and (Program__c IN :map_programId_closeDates.keySet() or Program__c IN :set_programId4Phase)]){
                if(map_programId_closeDates.containsKey(oppy.Program__c)){
                    if(oppy.Manufacturing_Start_Date__c != null) map_programId_closeDates.get(oppy.Program__c).add(oppy.Manufacturing_Start_Date__c);            
                    if(!map_programId_currencyIsoCode.containsKey(oppy.Program__c)){
                        map_programId_currencyIsoCode.put(oppy.Program__c, oppy.Program__r.CurrencyIsoCode);
                    }
                }
                if(!map_programId_stages.containsKey(oppy.Program__c)) map_programId_stages.put(oppy.Program__c, new Set<String>());           
                if(oppy.stageName != null) map_programId_stages.get(oppy.Program__c).add(oppy.StageName);
                //added by Jinbo Shan for PMV
                //Commented by padmaja 2014-08-20
                /*if(!map_programId_approveStatus.containsKey(oppy.Program__c)){
                    map_programId_approveStatus.put(oppy.Program__c, new Set<String>());
                }
                if(oppy.Approval_Status_PMV__c != null) {
                    map_programId_approveStatus.get(oppy.Program__c).add(oppy.Approval_Status_PMV__c);
                }
                */
            }
        }        
        for(Opportunity oppy :list_triggerOppys){
            if(oppy.Program__c != null){
                if(map_programId_currencyIsoCode.containsKey(oppy.Program__c)){
                    // get amount and 5 yeare revenue
                    Decimal totalRevenue = map_programId_totalRevenue.get(oppy.Program__c);
                    Decimal fiveYearRevenue = map_programId_5yearRevenue.get(oppy.Program__c);
                     
                    Decimal totalRevenue_Cust = map_programId_totalRevenue.get(oppy.Program__c);
                    Decimal fiveYearRevenue_Cust = map_programId_5yearRevenue.get(oppy.Program__c);
 
                    String programIsoCode = map_programId_currencyIsoCode.get(oppy.Program__c);
                    if(oppy.Amount != null){
                        if(oppy.CurrencyIsoCode != programIsoCode) {
                           totalRevenue = totalRevenue + transformIsoCode(oppy.Amount, oppy.CurrencyIsoCode, programIsoCode);
               totalRevenue_Cust = totalRevenue_cust + transformIsoCode(oppy.Total_Opportunity_Value__c, oppy.CurrencyIsoCode, programIsoCode);
                        }
                        else{
               totalRevenue += oppy.Amount;
               if(oppy.Total_Opportunity_Value__c != NULL){
               totalRevenue_Cust += oppy.Total_Opportunity_Value__c ; 
               }else{
                   totalRevenue_Cust += 0;
               }              
            }
                    }
                    if(oppy.Five_Year_Revenue__c != null){
                        if(oppy.CurrencyIsoCode != programIsoCode){
              fiveYearRevenue = fiveYearRevenue + transformIsoCode(oppy.Five_Year_Revenue__c, oppy.CurrencyIsoCode, programIsoCode);
              fiveYearRevenue_Cust = fiveYearRevenue_Cust + transformIsoCode(oppy.Five_Year_Value__c, oppy.CurrencyIsoCode, programIsoCode);
            }
                        else{
               fiveYearRevenue += oppy.Five_Year_Revenue__c;
               if(oppy.Five_Year_Value__c != NULL){
                   fiveYearRevenue_Cust += oppy.Five_Year_Value__c;
               }else{
                   fiveYearRevenue_Cust += 0;
               }
            }
                    }
                    
                    map_programId_totalRevenue.remove(oppy.Program__c);
                    map_programId_5yearRevenue.remove(oppy.Program__c);
                     
                    map_programId_totalRevenue_Cust.remove(oppy.Program__c);
                    map_programId_5yearRevenue_Cust.remove(oppy.Program__c);
 
                    map_programId_totalRevenue.put(oppy.Program__c, totalRevenue);
                    map_programId_5yearRevenue.put(oppy.Program__c, fiveYearRevenue);
                
                    map_programId_totalRevenue_Cust.put(oppy.Program__c, totalRevenue_Cust);
                    map_programId_5yearRevenue_Cust.put(oppy.Program__c, fiveYearRevenue_Cust);
 
                }                          
            }
        }
        
        if(!map_programId_closeDates.isEmpty() || (set_programId4Phase != null && !set_programId4Phase.isEmpty())){
            for(Opportunity program : [select id, Total_Opportunity_Value__c,Five_Year_Value__c, closeDate,Manufacturing_Start_Date__c, Amount, Five_Year_Revenue__c from Opportunity where id IN :map_programId_closeDates.keySet() or id IN :set_programId4Phase]){
                if(map_programId_closeDates.containsKey(program.id)){
                    // close date
                    if(!map_programId_closeDates.get(program.id).isEmpty()){
                        map_programId_closeDates.get(program.id).sort();
                        program.Manufacturing_Start_Date__c = map_programId_closeDates.get(program.id).get(0);
                    }            
                    
                    // revenue and five year revenue
                    if(program.Amount == null) program.Amount = 0;
                   if(program.Total_Opportunity_Value__c == null) program.Total_Opportunity_Value__c = 0;
                    
    // ######### Added Five Year Value,Total Opportunity value functionality BY RAVI <ravikumar.vasimalla@zensar.in>##########
    
                    if(program.Five_Year_Revenue__c == null) program.Five_Year_Revenue__c = 0;
                    if(program.Five_Year_Value__c == null) program.Five_Year_Value__c = 0;
 
                    
                    // if the program has no opportunities
                    if(!map_programId_currencyIsoCode.containsKey(program.id)){
                        program.Amount = 0;
                        program.Five_Year_Revenue__c = 0;
                        
    // ######### Added Five Year Value,Total Opportunity value functionality BY RAVI <ravikumar.vasimalla@zensar.in>##########
    
                        program.Five_Year_Value__c = 0;
                        program.Total_Opportunity_Value__c = 0;
 
                    }
                    else if(extType != 'Delete') {
                        program.Amount += map_programId_totalRevenue.get(program.id);
                        program.Five_Year_Revenue__c += map_programId_5yearRevenue.get(program.id);
                     
                        program.Total_Opportunity_Value__c += map_programId_totalRevenue_Cust.get(program.id);
                        program.Five_Year_Value__c += map_programId_5yearRevenue_Cust.get(program.id);
 
                    }
                    else{
                        program.Total_Opportunity_Value__c -= map_programId_totalRevenue_Cust.get(program.id);
                        program.Five_Year_Value__c -= map_programId_5yearRevenue_Cust.get(program.id);
 
                        program.Amount -= map_programId_totalRevenue.get(program.id);
                        program.Five_Year_Revenue__c -= map_programId_5yearRevenue.get(program.id);
                    }
                }           
                // stage
                program.isFromCode__c = true;
                if(map_programId_stages.containsKey(program.id) && map_programId_approveStatus.containsKey(program.id)) recalculateProgramStage(program, map_programId_stages.get(program.id), map_programId_approveStatus.get(program.id));
                list_program2Update.add(program);
            }
        }              
    }
    
    /** 
    * The method is used to decide the phase of program level
    *
    @author Min Liu
    @created 2012-09-17
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @changelog
    * 2012-09-17 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public static void recalculateProgramStage(Opportunity program, Set<String> set_oppyStage, Set<String> set_approveStatus){
        // stage
        Set<String> set_allNew = new Set<String>{'New'};
        Set<String> set_allIA = new Set<String>{'In Approval'};
        Set<String> set_allLDC = new Set<String>{'Lost/Dead - closed'};
        Set<String> set_allLRC = new Set<String>{'Rejected - Closed'};
        
        Set<String> set_allPLD = new Set<String>{'Production', 'Lost', 'Dead'};
        Set<String> set_allLD = new Set<String>{'Lost', 'Dead'};
        Set<String> set_allOH = new Set<String>{'On Hold'};
        Set<String> set_allG0R = new Set<String>{'G0 Rejected'};
        
        if(!set_oppyStage.isEmpty()){
            if(set_oppyStage.contains('Won - Open') || set_oppyStage.contains('Won')) program.stageName = 'Won - Open';// added  || set_oppyStage.contains('Won') for PMV
            else if(set_oppyStage.contains('Won - Closed')){
                if(set_oppyStage.contains('In Approval') || set_oppyStage.contains('Approved/Active') || set_oppyStage.contains('New')){
                    program.stageName = 'Won - Open';
                }
                //else if(set_tmpStage.contains('Lost/Dead - closed')) program.stageName = 'Won - Closed';
                else program.stageName = 'Won - Closed';
            }
            
            else if(set_allNew.containsAll(set_oppyStage)) program.stageName = 'New';
            else if(set_allIA.containsAll(set_oppyStage)) program.stageName = 'In Approval';
            else if(set_allLDC.containsAll(set_oppyStage)) program.stageName = 'Lost/Dead - closed';
            //else if(set_allLRC.containsAll(set_oppyStage)) program.stageName = 'Rejected - Closed';
            
            else program.stageName = 'Approved/Active';
            
            //Start:Jinbo Shan 2014-06-30 added for PMV.
            if(set_oppyStage.contains('Production')) {
                if(set_allPLD.containsAll(set_oppyStage)) {
                    program.stageName = 'Won - Closed';
                }
            } else {
                if(set_allLD.containsAll(set_oppyStage)) {
                    program.stageName = 'Lost/Dead - closed';
                }
            }
            
            if(set_allOH.containsAll(set_oppyStage)) {
                program.stageName = 'On Hold';
            }
            if(set_allG0R.containsAll(set_approveStatus)) {
                program.stageName = 'Rejected - Closed';
            }
            //End:
            
        }
    }
    
        /** 
    * The method is check if the methods between program and opportunities are different
    *
    @author Min Liu
    @created 2012-09-17
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @changelog
    * 2012-09-17 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public static boolean checkProgramOppyMethod(String pMethod,list<Opportunity> oppys){
        boolean result = false;
        for(Opportunity opp: oppys){
            if(opp.Method__c != pMethod){
                result = true;
                break;
            }
        }
        return result;
    }
    
    
    
    /** 
    *    add users to opportunity team with read/write access to opportunity
    
    
    *
    @author Xia Tong
    @created 2013-01-15 
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @changelog
    * 2013-01-15 Xia Tong <xia.tong@itbconsult.com>
    * - Created
    */
    public static void grantAccess(map<Id,set<Id>> map_oppyId_userId){
        system.debug('tongxia grantAccess');
        system.debug('tongxia map_oppyId_userId:' + map_oppyId_userId);
        list<OpportunityTeamMember> list_otm2Insert = new list<OpportunityTeamMember>();
        List<OpportunityShare> list_share = new List<OpportunityShare>();
        for(OpportunityTeamMember otm: [SELECT OpportunityAccessLevel, OpportunityId,Id, UserId FROM OpportunityTeamMember where OpportunityId in: map_oppyId_userId.keyset()]){
            if(map_oppyId_userId.get(otm.OpportunityId).contains(otm.UserId)){
                if(otm.OpportunityAccessLevel == 'Edit'){
                    map_oppyId_userId.get(otm.OpportunityId).remove(otm.UserId);
                }
                
            }
        }
        for(Id oppyId: map_oppyId_userId.keySet()){
            for(Id uId: map_oppyId_userId.get(oppyId)){
                OpportunityTeamMember member = new OpportunityTeamMember();
                member.OpportunityId = oppyId;
                member.UserId = uId;
                member.TeamMemberRole = 'Please Update';
                list_otm2Insert.add(member);
            }
        }
        system.debug('tongxia list_otm2Insert:' + list_otm2Insert);
        if(!list_otm2Insert.isEmpty()){
            insert list_otm2Insert;
            for(OpportunityShare share: [select Id, OpportunityAccessLevel,RowCause,UserOrGroupId,OpportunityId from OpportunityShare where OpportunityId IN :map_oppyId_userId.keySet() and RowCause = 'Team' and OpportunityAccessLevel != 'Edit']){
                if(map_oppyId_userId.get(share.OpportunityId).contains(share.UserOrGroupId)){
                    share.OpportunityAccessLevel = 'Edit';
                    list_share.add(share);
                }
            }
            if(!list_share.isEmpty()) update list_share;
        }
    }
    
    /** 
    *    future method to insert opportunity Approval
    
    
    *
    @author Xia Tong
    @created 2013-01-16 
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @changelog
    * 2013-01-16 Xia Tong <xia.tong@itbconsult.com>
    * - Created
    */
    
    @future 
    public static void opportunityApprovalFuture(set<Id> set_oppyId) {
        list<Opportunity_Approval__c> list_oa = new list<Opportunity_Approval__c>();
        for(Id oppyId: set_oppyId){
            Opportunity_Approval__c oa = new Opportunity_Approval__c();   
            oa.Opportunity__c = oppyId;
            list_oa.add(oa);
        }
        
        insert list_oa;
        system.debug('tongxia list_oa:' + list_oa);
        system.debug(system.now());
    }
    
    public static void checkCrossBu(map<Id,Opportunity> map_oppyId_oppy,map<Id,string> map_accId_industry){
        Map<Id, Set<String>> map_OppyId_setProductOwningGIBUs = new Map<Id, Set<String>>();
        Map<String, Map<String, String>> map_customerBU_map_ProductGibu = new Map<String, Map<String, String>>();
        List<Opportunity> list_oppies2Update = new List<Opportunity>();
        Id salesPartsRecordTypeId = Apex_Helper_Settings__c.getInstance('Sales Parts RT Id').Value__c;
        
        //Get all data out of the custom setting "Cross BU Check" which contains the Customer BU vs. Product Owning BU matching table
        for(Cross_BU_Check__c cbucheck : Cross_BU_Check__c.getAll().values()){
            if(!map_customerBU_map_ProductGibu.containsKey(cbucheck.Customer_GIBU__c)){
                map_customerBU_map_ProductGibu.put(cbucheck.Customer_GIBU__c, new Map<String, String>());
            }
            map_customerBU_map_ProductGibu.get(cbucheck.Customer_GIBU__c).put(cbucheck.Product_Owning_GIBU__c, cbucheck.Result__c);
        }
        
        
        //Get all parts of oppies those new or updated parts are in trigger loop
        for(Opportunity_Part__c oppyPart : [Select Id, Product_Owning_BU__c, Opportunity__c From Opportunity_Part__c Where Opportunity__c in :map_oppyId_oppy.keySet() and RecordTypeId != :salesPartsRecordTypeId]){ 
            if(!map_OppyId_setProductOwningGIBUs.containsKey(oppyPart.Opportunity__c)){
                map_OppyId_setProductOwningGIBUs.put(oppyPart.Opportunity__c,new set<String>());    
            }
            map_OppyId_setProductOwningGIBUs.get(oppyPart.Opportunity__c).add(oppyPart.Product_Owning_BU__c);
        }
                
        //Customer BU vs. Product Owning GIBU comparison
        for(Opportunity oppy : map_oppyId_oppy.values()){
            if(map_OppyId_setProductOwningGIBUs.containsKey(oppy.Id)){
                //For single product owning GIBU
                if(map_OppyId_setProductOwningGIBUs.get(oppy.Id).size() == 1){
                    String productGibu = '';
                    for(String bbb : map_OppyId_setProductOwningGIBUs.get(oppy.Id)){
                        productGibu = bbb;
                    }
                    if(map_customerBU_map_ProductGibu.containsKey(map_accId_industry.get(oppy.AccountId)) && map_customerBU_map_ProductGibu.get(map_accId_industry.get(oppy.AccountId)).containsKey(productGibu)){
                        String owningGibu = map_customerBU_map_ProductGibu.get(map_accId_industry.get(oppy.AccountId)).get(productGibu);
                        if(owningGibu == 'AP'){
                            oppy.Cross_BU_Check__c = true;
                            list_oppies2Update.add(oppy);
                        }
                        else{
                            oppy.Cross_BU_Check__c = false;
                            list_oppies2Update.add(oppy);
                        }   
                    }
                }
                else{
                    if(oppy.Cross_BU_Check__c == true){
                        oppy.Cross_BU_Check__c = false;
                    }
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