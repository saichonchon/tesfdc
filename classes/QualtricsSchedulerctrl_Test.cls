@isTest
Public Class QualtricsSchedulerctrl_Test{
    public Static testMethod void Qualschedule(){
    /* Creating Campaign and campaignmember list*/
        List<campaign> camp = new List<campaign>();
        List<campaignmember> campmember = new List<campaignmember>();
            
        Contact con = new Contact(); 
        con.FirstName='vignesh';
        con.LastName='kotha';
        con.email = 'test@test.com';
        insert con; 
        campaign caminsert = new campaign();
        caminsert.name='vignesh';
        //caminsert.Qualtrics_Schedule_Date__c=Datetime.now();
        //caminsert.Qualtrics_Schedule_Reminder1__c=Datetime.now();
        //caminsert.Qualtrics_Schedule_Reminder2__c=Datetime.now();
        caminsert.isActive=true;
        caminsert.Qualtrics_Schedule_Date__c=system.now();
        insert caminsert;
        
       // system.assertEquals(caminsert.Qualtrics_Schedule_Date__c,Datetime.now());
        
       // update caminsert;
       
       
       campaign cm = [select id,Qualtrics_Schedule_Date__c,Qualtrics_Schedule_Reminder1__c,Qualtrics_Schedule_Reminder2__c from campaign where id=:caminsert.id];
       
       //system.assertEquals(cm.Qualtrics_Schedule_Date__c,datetime.now());
       
   //     apexpages.currentpage().getparameters().put('campaignid',caminsert.id);
        campaignmember cammeminsert = new campaignmember ();
        cammeminsert.ContactId=con.id;
         
        cammeminsert.campaignid =caminsert.id;
        cammeminsert.Status='Sent';
        cammeminsert.Qualtrics_Survey_Sent__c=true;
        cammeminsert.Qualtrics_Schedule_Date__c=system.now();
        cammeminsert.Qualtrics_Schedule_Reminder1__c=cm.Qualtrics_Schedule_Reminder1__c;
        cammeminsert.Qualtrics_Schedule_Reminder2__c=cm.Qualtrics_Schedule_Reminder2__c;
        cammeminsert.NPS_Language__c='EN';
        insert cammeminsert;
        //update cammeminsert;
        
        Test.setCurrentPageReference(new PageReference('Page.QualtricsScheduler')); 
System.currentPageReference().getParameters().put('campaignid',caminsert.id );
        QualtricsSchedulerctrl qualsched = new QualtricsSchedulerctrl();
        qualsched.camp = caminsert;
        qualsched.schedule();
         
        //PageReference pr= Page.QualtricsScheduler;
       // pr.getParameters().put('id',caminsert.Id);
        //Test.setCurrentPage(pr);
        
       
    }
    }