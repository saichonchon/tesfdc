@isTest(seealldata=false)
private class clsscheduled_SendScheduledEmailAlrt_Test {
    static testMethod void Testclsscheduled_SendScheduledEmailAlrt() {
        test.startTest();
        
        ClsTestCustomSettingHelper.getBatchEmailmessageUsers();
        
        string STime ='0 0 23 * * ?';
        
        clsscheduled_SendScheduledEmailAlert oclsscheduled_SendScheduledEmailAlert3days = new clsscheduled_SendScheduledEmailAlert();
        oclsscheduled_SendScheduledEmailAlert3days.BatchName = 'Test Batch';
        oclsscheduled_SendScheduledEmailAlert3days.EmailSubject = 'Test Schedule';
        oclsscheduled_SendScheduledEmailAlert3days.EmailBody = 'This is a test';
        
        system.schedule('Test Schedule' + ' 3 days alert', STime, oclsscheduled_SendScheduledEmailAlert3days);
        
        test.stopTest();
    }
}