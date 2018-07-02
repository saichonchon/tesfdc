/**********************************************************************
Name: ADMJDABookingForecast_Schedule
Copyright © 2017
==========================================================================================================
==========================================================================================================
Purpose: ADMJDABookingForecast_Schedule is scheduler for batch class which push Forecast details records with 
type as OEM, DISTY and Market Adjustment to INFRA Managed Package                                                        
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR               DATE             DETAIL Description
0.1          Kartik Gohad           10/11/2017       INITIAL DEVELOPMENT
***********************************************************************/
global class ADMJDABookingForecast_Schedule implements schedulable{

 global void execute(SchedulableContext ctx){
        ADMJDABookingForecastDisty_Batch  b = new ADMJDABookingForecastDisty_Batch();
        Database.executeBatch(b, 100);   
    }
}