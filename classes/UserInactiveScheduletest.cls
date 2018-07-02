@istest
public class UserInactiveScheduletest
{
    public static testMethod void unitTest()

    {
        Test.startTest();
        
        userinactiveScheduledApex m = new userinactiveScheduledApex ();
        String stime = '0 0 8 * * ?';
        system.schedule('Inactive', stime, m);
        
        Test.stopTest();
        
    }
}