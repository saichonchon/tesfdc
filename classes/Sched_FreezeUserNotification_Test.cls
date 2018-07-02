/**  
 * @Author: Subba Vanipenta
 * @Date :09/24/2015
 * @Description : This test class is used for testing the Sched_FreezeUserNotificationToBUAdmins
 * @Version:1 - Initial Development
 */
@isTest
public class Sched_FreezeUserNotification_Test{
    public static testMethod void testData() {          
        ClsTestCustomSettingHelper.getOrgWideSettings();
        list<FreezeUserNotificationToBUAdmins__c> vFreezeUserCS = Batch_FreezeUserNoticeToBUAdmin_Test.createFreezeUserSettingsList();       
        Sched_FreezeUserNotificationToBUAdmins vObjSchClass = new Sched_FreezeUserNotificationToBUAdmins();
        String testSchedulerString = '0 0 22 * * ?';        
        system.schedule('Test Scheduler for FreezeUsers WhoareLeavingTE', testSchedulerString, vObjSchClass);
        
    }
}