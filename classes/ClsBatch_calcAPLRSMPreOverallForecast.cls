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
global with sharing class ClsBatch_calcAPLRSMPreOverallForecast  implements Database.Batchable<SObject>, Database.stateful {
    
    global String query;
    global String filter;
    global String limitStr;
    global String currentYear;
    global Integer currentQuarter;
    
    public ClsBatch_calcAPLRSMPreOverallForecast(){

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
        Integer yearPlus3;
        yearPlus1 = Integer.valueOf(currentYear) + 1;
        yearPlus2 = Integer.valueOf(currentYear) + 2;
		system.debug('currentYear::: '+currentYear);
        filter = '((Fiscal_Year__c = \'' + yearPlus1 + '\' AND Fiscal_Quarter__c IN (\'01\', \'02\', \'03\'' ;
        if(currentQuarter == 4) {
            filter += ' , \'04\' )) OR (Fiscal_Year__c = \''+ currentYear + '\' AND Fiscal_Quarter__c IN (\'04\') ) OR ( Fiscal_Year__c = \'' + String.valueOf(yearPlus2) + '\' AND Fiscal_Quarter__c IN (\'01\', \'02\') ) ';
        }else if(currentQuarter == 3) {
            filter += ' , \'04\' )) OR (Fiscal_Year__c = \''+ currentYear + '\' AND Fiscal_Quarter__c IN (\'04\', \'03\') ) OR ( Fiscal_Year__c = \'' + String.valueOf(yearPlus2) + '\' AND Fiscal_Quarter__c IN (\'01\') ) ';
        
        }else if(currentQuarter == 2){
            filter += ' , \'04\' )) OR (Fiscal_Year__c = \''+ currentYear + '\' AND Fiscal_Quarter__c IN (\'04\', \'03\', \'02\' )) ';
        
        }else{
            filter += ' )) OR  (Fiscal_Year__c = \''+ currentYear + '\' AND Fiscal_Quarter__c IN (\'04\', \'03\', \'02\', \'01\' )) ';
        
        }
        filter += ' ) ';
        system.debug('filter::: '+filter);
        if(query == null || query.trim() == ''){
            query = ' Select Relay_RSM_Overall_Forecast__c, RSM_Overall_Forecast__c, '
            	  + ' Fiscal_Quarter__c, Fiscal_Year__c ';
            	  
            for (Integer i = 1; i <= 6; i++) {
                query += ', Current_' + i + '_Overall_Forecast__c ';
                query += ', Current_' + i + '_RR_Overall_Forecast__c ';
            }

            query += ' From APL_RSM_Overall_Forecast__c ';
        }
        
        if(filter != null && filter.trim() != ''){
            query += ' where ' + filter;
        }
        
        query += ' and (Relay_RSM_Overall_Forecast__c != null or RSM_Overall_Forecast__c != null ) ';
        query += ' order by Fiscal_Year__c, Fiscal_Quarter__c asc ';
        if(limitStr != null && limitStr.trim() != '') {
            query += limitStr;
        }
        system.debug('query:::' +query );      
        return Database.getQueryLocator(query);

    }
    
    global void execute(Database.BatchableContext BC, List<APL_RSM_Overall_Forecast__c> list_aplRSMForecasts){
        //system.debug('list_aplForecasts::: '+list_aplForecasts);
        ClsAPLForecastUtil.setAPLRSMOverallPrevFC(list_aplRSMForecasts, currentYear, currentQuarter);
        if(!list_aplRSMForecasts.isEmpty()) {
            update list_aplRSMForecasts;
        }
    }
    
    global void finish(Database.BatchableContext BC){ 
        
    }

}