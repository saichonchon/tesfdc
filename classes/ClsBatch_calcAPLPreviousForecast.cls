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
global with sharing class ClsBatch_calcAPLPreviousForecast  implements Database.Batchable<SObject>, Database.stateful {
    
    global String query;
    global String filter;
    global String limitStr;
    global String currentYear;
    global Integer currentQuarter;
    
    public ClsBatch_calcAPLPreviousForecast(){

        if(currentYear == null || currentQuarter == null) {
            for (Period period : [select FiscalYearSettings.Name, Number from Period where StartDate<= today and EndDate >= today and Type = 'Quarter']) {
                if(period.FiscalYearSettings.Name != null){
                    currentYear = period.FiscalYearSettings.Name;
                }
                if(period.Number != null){
                    currentQuarter = period.Number;
                }
            }
        }
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        Integer yearPlus1;
        Integer yearPlus2;
        Integer yearPrevious1;
        yearPlus1 = Integer.valueOf(currentYear) + 1;
        yearPlus2 = Integer.valueOf(currentYear) + 2;
        yearPrevious1 = Integer.valueOf(currentYear) - 1;
		system.debug('currentYear::: '+currentYear);
        filter = '((Fiscal_Year__c = \'' + yearPlus1 + '\' AND Fiscal_Quarter__c IN (\'01\', \'02\', \'03\'' ;
        if(currentQuarter == 4) {
            filter += ' , \'04\' )) OR (Fiscal_Year__c = \''+ currentYear + '\' AND Fiscal_Quarter__c IN (\'01\', \'02\', \'03\', \'04\')) OR (Fiscal_Year__c = \'' + String.valueOf(yearPlus2) + '\' AND Fiscal_Quarter__c IN (\'01\', \'02\')) ';
        	filter += ' OR (Fiscal_Year__c = \''+ String.valueOf(yearPrevious1) + '\' AND Fiscal_Quarter__c IN (\'04\')) ';
        }else if(currentQuarter == 3) {
            filter += ' , \'04\' )) OR (Fiscal_Year__c = \''+ currentYear + '\' AND Fiscal_Quarter__c IN (\'01\', \'02\', \'03\', \'04\')) OR (Fiscal_Year__c = \'' + String.valueOf(yearPlus2) + '\' AND Fiscal_Quarter__c IN (\'01\') ) ';
        	filter += ' OR (Fiscal_Year__c = \''+ String.valueOf(yearPrevious1) + '\' AND Fiscal_Quarter__c IN (\'03\', \'04\')) ';
        }else if(currentQuarter == 2){
            filter += ' , \'04\' )) OR (Fiscal_Year__c = \''+ currentYear + '\' AND Fiscal_Quarter__c IN (\'01\', \'02\', \'03\', \'04\')) ';
        	filter += ' OR (Fiscal_Year__c = \''+ String.valueOf(yearPrevious1) + '\' AND Fiscal_Quarter__c IN (\'02\', \'03\', \'04\')) ';
        }else{
            filter += ' )) OR  (Fiscal_Year__c = \''+ currentYear + '\' AND Fiscal_Quarter__c IN (\'01\', \'02\', \'03\', \'04\')) ';
        	filter += ' OR (Fiscal_Year__c = \''+ String.valueOf(yearPrevious1) + '\' AND Fiscal_Quarter__c IN (\'01\', \'02\', \'03\', \'04\')) ';
        }
        filter += ' ) ';
        system.debug('filter::: '+filter);
        if(query == null || query.trim() == ''){
            query = ' Select Forecast__c, GAM_Forecast__c, RSM_Forecast__c, '
            	  + ' Price__c, RSM_Price__c, Quantity__c, RSM_Quantity__c, Fiscal_Quarter__c, Fiscal_Year__c, CurrencyIsoCode  ';
            	  
            for (Integer i = 1; i <= 13; i++) {
                query += ', Current_month_' + i + '_forecast__c ';
                query += ', Current_month_' + i + '_price__c ';
                query += ', Current_month_' + i + '_quantity__c ';
                
                query += ', Current_month_' + i + '_RSM_forecast__c ';
                query += ', Current_month_' + i + '_RSM_price__c ';
                query += ', Current_month_' + i + '_RSM_quantity__c ';

                query += ', Current_month_' + i + '_GAM_forecast__c ';
            }

            query += ' From APL_Sales_Forecast__c ';
        }
        
        if(filter != null && filter.trim() != ''){
            query += ' where ' + filter;
        }
        
        query += ' and (Forecast__c != null or GAM_Forecast__c != null or RSM_Forecast__c != null) ';
        query += ' order by Fiscal_Year__c, Fiscal_Quarter__c asc ';
        if(limitStr != null && limitStr.trim() != '') {
            query += limitStr;
        }
        system.debug('query:::' +query );      
        return Database.getQueryLocator(query);

    }
    
    global void execute(Database.BatchableContext BC, List<APL_Sales_Forecast__c> list_aplForecasts){
        system.debug('list_aplForecasts::: '+list_aplForecasts);
        //ClsAPLForecastUtil.setAPLPrevFC(list_aplForecasts, currentYear, currentQuarter);
        ClsAPLForecastUtil.setAPLPrevFCNew(list_aplForecasts);
        if(!list_aplForecasts.isEmpty()) {
            update list_aplForecasts;
        }
    }
    
    global void finish(Database.BatchableContext BC){ 
        if(!test.isRunningTest()){
            ClsBatch_calcAPLRSMPreOverallForecast batchCls = new ClsBatch_calcAPLRSMPreOverallForecast();
            batchCls.currentQuarter = currentQuarter;
            batchCls.currentYear = currentYear;
            database.executeBatch(batchCls);    
        }
    }

}