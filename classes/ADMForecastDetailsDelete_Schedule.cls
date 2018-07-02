/**********************************************************************
Name: ADMForecastDetailsDelete_Schedule
Copyright © 2017
==========================================================================================================
==========================================================================================================
Purpose:Schedule class to run batch class for Forecast detail Deletion                                                      
==========================================================================================================
==========================================================================================================
History                                                            
-------                                                            
VERSION      AUTHOR               DATE             DETAIL Description
0.1          Supriya Ambre        09/20/2017       INITIAL DEVELOPMENT
***********************************************************************/

global class ADMForecastDetailsDelete_Schedule implements Schedulable {
  
    global void execute(SchedulableContext sc) {  // execute schedule job 
       ADMForecastDetailDelete_Batch b = new ADMForecastDetailDelete_Batch (); 
        
         database.executebatch(b, 200);      
   }
   }