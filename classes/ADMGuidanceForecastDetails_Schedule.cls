/**********************************************************************
Name:  ADMGuidanceForecastDetails_Schedule
Copyright © 2017
======================================================
======================================================
Purpose: Scheduler for ADMGuidanceForecastDetails_Batch
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR                DATE             DETAIL               Description
0.1          Kartik  G           9/14/2017         INITIAL DEVELOPMENT	 Scheduler for ADMGuidanceForecastDetails_Batch
***********************************************************************/

global class ADMGuidanceForecastDetails_Schedule implements Schedulable {
  
    global void execute(SchedulableContext sc) {
        ADMGuidanceForecastDetails_Batch b = new ADMGuidanceForecastDetails_Batch(); 
        database.executebatch(b);
   
    }
}