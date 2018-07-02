/***  This test class is for Schedule_ClsBatch_DeleteDailyBBBBacklog Scheduler Class.
*@author Toshi @created 2013-07-19@version 1.0
*@changelog
* 2013-07-19 Toshi <toshi.darode@zensar.in>* - Created
* - Test coverage 100%
*/
@isTest
public class Schedule_ClsBatch_DeleteDailyBBB_Test{

    public static testMethod void testData() {
        Test.StartTest();
        Schedule_ClsBatch_DeleteDailyBBBBacklog objSchClass = new Schedule_ClsBatch_DeleteDailyBBBBacklog();
        String testSchedulerString = '0 0 23 * * ?';
        system.schedule('Test Scheduler for Deletion of DailyBBB Backlog Records Daily', testSchedulerString, objSchClass);
        Test.stopTest();
    }
}