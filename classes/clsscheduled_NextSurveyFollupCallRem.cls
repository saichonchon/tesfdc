/**
*  This class is used as scheduler class for clsBatch_NextSurveyFollupCallRem
*
@author Pankaj Raijade
@created 1/2/2016
@Test Class : clsscheduled_NextSurveyFollupCall_test
@ coverage  100%
@changelog

*/

global class clsscheduled_NextSurveyFollupCallRem implements Schedulable 
{
    global void execute(SchedulableContext sc) 
    {
        clsBatch_NextSurveyFollupCallReminder oclsBatch_NextSurveyFollupCallReminder = new clsBatch_NextSurveyFollupCallReminder();
        database.executeBatch(oclsBatch_NextSurveyFollupCallReminder, 1000);
    }
}