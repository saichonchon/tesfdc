/***  This test class is for clsSchedule_Del_DbbbOnMonthChange Scheduler Class.
*@author Toshi @created 2013-12-12@version 1.0
*@changelog
* 2013-07-19 Toshi <toshi.darode@zensar.in>* - Created
* - Test coverage 100%
*/
@isTest(SeeAllData = True)
public class clsSchedule_Del_DbbbOnMonthChange_Test{

    public static testMethod void testData() {
        Test.StartTest();
        clsSchedule_Del_DbbbOnMonthChange objSchClass = new clsSchedule_Del_DbbbOnMonthChange();
        String testSchedulerString = '0 0 23 * * ?';
        system.schedule('Test Scheduler for Deletion of DailyBBB', testSchedulerString, objSchClass);
        Test.stopTest();
    }
}