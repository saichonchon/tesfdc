/***********************************************************************************************************************
Name: ClsSchedule_deleteForecastSnapshot_Test
========================================================================================================================
Purpose: Test Class for ClsSchedule_deleteForecastSnapshot                                                  
========================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                            
------------------------------------------------------------------------------------------------------------------------
1.0    Mrunal            09/15/2015     Initial Development 
                                        Test Coverage = 100%
***********************************************************************************************************************/

@isTest(seeAllData = FALSE)
public class ClsSchedule_deleteForecastSnapshot_Test{

    public static testMethod void testData() {
        Test.StartTest();
        ClsSchedule_deleteForecastSnapshot objSchClass = new ClsSchedule_deleteForecastSnapshot();
        String testSchedulerString = '0 0 23 * * ?';
        system.schedule('Test Scheduler for Deletion of Forecast Snapshot', testSchedulerString, objSchClass);
        Test.stopTest();
    }
}