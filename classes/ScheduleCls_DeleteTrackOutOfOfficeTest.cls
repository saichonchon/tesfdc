@isTest
public class ScheduleCls_DeleteTrackOutOfOfficeTest{
  
  public static testMethod void testScheduler() {
    // CRON expression 
    String cronExpr = '0 0 0 15 9 ? 2022';
    Track_Out_Of_Office__c track= new Track_Out_Of_Office__c();
    track.Out_of_office_Disabled_On__c=System.now();
    track.Out_of_office_Enabled_On__c= System.now().addDays(1);
    //track.User__c=;
    insert track;
    // Verify that AsyncApexJob is empty
    List<AsyncApexJob> jobsBefore = [select Id, ApexClassID, ApexClass.Name, Status, JobType from AsyncApexJob];
    System.assertEquals(0, jobsBefore.size(), 'not expecting any asyncjobs');

    Test.startTest();
    // Schedule the test job
    String jobId = 
        System.schedule('myJobTestJobName', cronExpr, new ScheduleCls_DeleteTrackOutOfOffice());
    Test.stopTest();

    // There will now be two things in AsyncApexJob - the Schedulable itself
    // and also the Batch Apex job. This code looks for both of them

    // Check schedulable is in the job list
    List<AsyncApexJob> jobsScheduled = [select Id, ApexClassID, ApexClass.Name, Status, JobType from AsyncApexJob where JobType = 'ScheduledApex'];
    System.assertEquals(1, jobsScheduled.size(), 'expecting one scheduled job');
    System.assertEquals('ScheduleCls_DeleteTrackOutOfOffice', jobsScheduled[0].ApexClass.Name, 'expecting specific scheduled job');

}
public static testMethod void outOfofficeUserTest() {

 UserRole r = new UserRole(DeveloperName = 'CC_Americas_CSSC_CCP_new', Name = 'CC Americas CSSC CCP');
     insert r;
 User u = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'CC CCP'].Id,
     LastName = 'last',
     Email = 'puser000@amamama.com',
     Username = 'puser000@amamama.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey='en_US',
     LocaleSidKey = 'en_US',
     UserRoleId = r.Id);
     
     insert u;
     
     u.Out_Of_Office__c=true;
     update u;
     
    system.RunAs(u){
         Track_Out_Of_Office__c track= new Track_Out_Of_Office__c();
         track.Out_of_office_Enabled_On__c=System.now();
         track.User__c=u.id;
         insert track;
    }
    
    u.Out_Of_Office__c=false;
    update u;

}

}