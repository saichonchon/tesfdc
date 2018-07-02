/**********************************************************************
Name:  ADMYOYForecastDetails_Schedule
Copyright © 2017
======================================================
======================================================
Purpose: Scheduler for ADMYOYForecastDetails_Batch
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR                DATE             DETAIL                   Description
=================================================================================================================================
1.0          Altaf	            11/06/2017        INITIAL DEVELOPMENT	   Scheduler for ADMYOYForecastDetails_Batch
**********************************************************************************************************************************/

global class ADMYOYForecastDetails_Schedule implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        ADM_Custom_Setting__c forecastBatchSizeCustomSetting = ADM_Custom_Setting__c.getValues('Forecast_BatchSize');
        Integer forecastBatchSize = 50;
        
        if(forecastBatchSizeCustomSetting != null){
            forecastBatchSize = Integer.valueOf(forecastBatchSizeCustomSetting.Value__c);
            system.debug('forecastBatchSize--> '+forecastBatchSize);
        }    
        
        ADMYOYForecastDetails_Batch b = new ADMYOYForecastDetails_Batch(); 
        database.executebatch(b,forecastBatchSize);
        
    }
}