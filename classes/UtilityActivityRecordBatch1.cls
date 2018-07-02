/***********************************************************************************************************************
 Name: UtilityActivityRecordBatch1
 Copyright © 2013 TE Connectivity | Salesforce Instance : Central Org
========================================================================================================================
 Purpose: Used for Cascade schedule for the ActivityRecordBatch1                                                  
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
 VERSION AUTHOR                DATE       DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
     1.0 Ankit                 05/02/2013 Initial Development                                 
***********************************************************************************************************************/

public class UtilityActivityRecordBatch1 {
    public static  string returnScheduleString(integer schDelay){
        Datetime schDate = system.now();
        system.debug('Date schDate :'+schDate );
        schDate = schDate.addSeconds(schDelay);
        Integer schDay = schDate.day();
        Integer schMon = schDate.month();
        Integer schHr = schDate.hour();
        Integer schSeco = schDate.second();
        Integer schMin = schDate.minute();
        Integer schYr = schDate.year();
        
        String sch = string.valueof(schSeco ) + ' ' + 
                     string.valueof(schMin ) + ' ' + 
                     string.valueof(schHr ) + ' ' + 
                     string.valueof(schDay ) + ' ' + 
                     string.valueof(schMon ) + ' ' + '?' + ' ' +
                     string.valueof(schYr );
        return sch;
    }
}