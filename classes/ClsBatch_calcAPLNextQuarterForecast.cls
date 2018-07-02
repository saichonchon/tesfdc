/**
 *  This class is used to recalculate APL_Sales_Forecast__c.
 *  
 * @author Lili Zhao
 * @created 2014-07-21
 * @version 1.0
 * @since 28.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2014-07-21 Lili Zhao <lili.zhao@itbconsult.com>
 * - Created   
 *
 */
global class ClsBatch_calcAPLNextQuarterForecast implements Database.Batchable<SObject>, Database.stateful {
    
    global String query;
    global String filter;
    global String currentYear;
    global String currentQuarter;
    global String currentDateKey;
    global String nextQuarterDateKey;
    global String perv_1_QuarterDateKey;
    global String current_prev_4_QuarterDateKey;
    global String prev_1_prev_4_QuarterDateKey;
    global String next_prev_4_QuarterDateKey;
    global set<String> set_dateKeys = new set<String>();
    
    global ClsBatch_calcAPLNextQuarterForecast(){
        if(currentYear == null || currentQuarter == null) {
            for (Period period : [select FiscalYearSettings.Name, Number 
                                  from Period 
                                  where EndDate >=Today 
                                  and Type = 'Quarter' 
                                  order by EndDate limit 7]) {
                if(period.FiscalYearSettings.Name != null){
                    currentYear = period.FiscalYearSettings.Name;
                }
                if(period.Number != null){
                    currentQuarter = '0' + period.Number;
                }
            }
            if(currentQuarter == '01') {
                currentYear = String.valueOf(Integer.valueOf(currentYear) - 1);
                currentQuarter = '04';
            }
            else {
                currentQuarter = '0' + (Integer.valueOf(currentQuarter) - 1);
            }
        }
        //get current quarter date key   sample as '2014_01'
        currentDateKey = currentYear + '_' + currentQuarter;
        set_dateKeys.add(currentDateKey);
        //next quarter date key sample as '2014_02'
        if(currentQuarter == '04') {
            nextQuarterDateKey = String.valueOf(Integer.valueOf(currentYear) + 1) + '_' + '01';
        }
        else {
            nextQuarterDateKey = currentYear + '_0' + String.valueOf(Integer.valueOf(currentQuarter) + 1);
        }
        //set_dateKeys.add(nextQuarterDateKey);
        //previous quarter date key sample as '2013_04'
        if(currentQuarter == '01') {
            perv_1_QuarterDateKey = String.valueOf(Integer.valueOf(currentYear) - 1) + '_' + '04';
        }
        else {
            perv_1_QuarterDateKey = currentYear + '_0' + String.valueOf(Integer.valueOf(currentQuarter) - 1);
        }
        set_dateKeys.add(perv_1_QuarterDateKey);
        //previous 4 quarters of current quarter date key sample as '2013_01'
        current_prev_4_QuarterDateKey = String.valueOf(Integer.valueOf(currentYear) - 1) + '_' + currentQuarter;
        set_dateKeys.add(current_prev_4_QuarterDateKey);
        //previous 4 quarters of previous quarter date key sample as '2012_04'
        prev_1_prev_4_QuarterDateKey = String.valueOf(Integer.valueOf(perv_1_QuarterDateKey.substringBefore('_')) - 1) + '_' + perv_1_QuarterDateKey.subStringAfter('_');
        set_dateKeys.add(prev_1_prev_4_QuarterDateKey);
        //previous 4 quarters of new quarter date key sample as '2013_02'
        next_prev_4_QuarterDateKey = String.valueOf(Integer.valueOf(nextQuarterDateKey.substringBefore('_')) - 1) + '_' + nextQuarterDateKey.subStringAfter('_');
        system.debug('currentYear::: '+currentYear);
        system.debug('currentQuarter::: '+currentQuarter);
        system.debug('currentDateKey::: '+currentDateKey);
        system.debug('nextQuarterDateKey::: '+nextQuarterDateKey);
        system.debug('perv_1_QuarterDateKey::: '+perv_1_QuarterDateKey);
        system.debug('current_prev_4_QuarterDateKey::: '+current_prev_4_QuarterDateKey);
        system.debug('prev_1_prev_4_QuarterDateKey::: '+prev_1_prev_4_QuarterDateKey);
        system.debug('next_prev_4_QuarterDateKey::: '+next_prev_4_QuarterDateKey);
        system.debug('set_dateKeys::: '+set_dateKeys);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        map<String, set<String>> map_year_set_quarters = new map<String, set<String>>();
        
        if(query == null || query.trim() == ''){
            query = ' Select Id, Customer__c, GPL__c, Part__c, Type__c, Quantity__c, Price__c, '
                  + ' RSM_Price__c, RSM_Quantity__c, RSM_Forecast__c, GAM_Forecast__c, Forecast__c, '
                  + ' Fiscal_Year__c, Fiscal_Quarter__c, CurrencyIsoCode'
                  //add by Lei Tang 2015-07-08
              	  + ' ,Relay_CBC2_Code__c, PRODUCT_CDE__c, PROD_NAME__c '
                  + ' From APL_Sales_Forecast__c '
                  + ' where Fiscal_Year__c = \'' + next_prev_4_QuarterDateKey.subStringBefore('_') + '\' '
                  + ' AND Fiscal_Quarter__c = \'' + next_prev_4_QuarterDateKey.subStringAfter('_') + '\' ';
        }
        
        if(filter != null && filter.trim() != '') {
            query += filter;
        }
        query += ' order by Customer__c, GPL__c, Part__c ';
        system.debug('query :: ' + query);      
        return Database.getQueryLocator(query);

    }
    
    global void execute(Database.BatchableContext BC, list<APL_Sales_Forecast__c> list_aplFCs){
        ClsAPLForecastUtil.calcAPLNextQuarterForecast(list_aplFCs, currentDateKey, nextQuarterDateKey, perv_1_QuarterDateKey, current_prev_4_QuarterDateKey,
                                                    set_dateKeys, prev_1_prev_4_QuarterDateKey, next_prev_4_QuarterDateKey); 
    }
    
    global void finish(Database.BatchableContext BC){ 
        
    }
}