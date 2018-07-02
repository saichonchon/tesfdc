/*********************************************************************************************************************** 
 Name: IND_ScheduledMytodoApp_TestClass
 Salesforce Instance : QA Sandbox
========================================================================================================================
 Purpose: This test class is covering the below class test coverage:
  1. IND_ScheduledMytodoAppBatchClass: 100%
  2. INDBatch_MytoDoEmailClassCall: 100%
  3.IND_MyToDoReminderEmailClass : 88%
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
 VERSION AUTHOR                DATE         DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
     1.0 Deepak                6 August 2016   Initial Development                                         



***********************************************************************************************************************/




@isTest()
class IND_ScheduledMytodoApp_TestClass {

   static testmethod void test() {
   Test.startTest();
      
        ClsTestCustomSettingHelper.getApex_Helper_Settings(); 
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ChannelinsightData_test.Channelinsightdata_test();
       
        RecordType rt = ClsTestHelp.createTestRecordType();
        RecordType rt2 = ClsTestHelp.createTestRecordType16();
        
      // added by deepak kumar on 2nd jan 2017 to set the from address of email. 
       IND_MYTODO_App__c mytodocus = new IND_MYTODO_App__c(); 
        mytodocus.name='test';
        mytodocus.active__c=true;
        mytodocus.Email_Address__c='test_test@Abcd.com';
        insert mytodocus;
        // added by deepak kumar on 2nd jan 2017 to set the from address of email.
        
      Profile p = [Select Id, Name From Profile 
                                    where Name = 'Industrial Standard User' 
                                    or Name = 'Industrial Engineering User w/Cost' 
                                    or Name ='Industrial User w/ Cost' limit 1];

       
         User u = new User();
        u.FirstName ='First';
        u.LastName = 'Tester';
        u.username = 'Lion123732@testCompany999.com';
        u.Email = 'Lion123732@testCompany999.com';
        u.Alias = 'SF';
        u.ProfileId = p.Id;
        u.CommunityNickname = 'QPS';
        u.IsActive = true;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
       
        insert u;
        
       
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        acc.Ownerid=u.id;
        acc.Billingcountry='DE';
        acc.DD1_Industry_Business_Name__c ='Industrial';
        insert acc;
        
        List<Opportunity> Listopp = new List<Opportunity>();
        
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.CloseDate =system.today()-31; 
        oppy2.Name = 'Pain of Queen';
        oppy2.Manufacturing_Start_Date__c=system.today()-31;
        oppy2.Request_Type__c = 'Extension';
        oppy2.RecordTypeId = '012E0000000fCzr';
        oppy2.StageName='New';
        oppy2.Ownerid = u.id;
        oppy2.Project_Status_Level__c='CANCELLED (3)';
        oppy2.PLM_Id__c='34drrgdg';
       	oppy2.segment__c='A&C - does not match focus application';
        Listopp.add(oppy2);  
        
        Opportunity oppy3 = ClsTestHelp.createTestOpportunity();
        oppy3.CloseDate =system.today()-31; 
        oppy3.Name = 'Pain of Queen';
        oppy3.Manufacturing_Start_Date__c=system.today()-31;
        oppy3.Request_Type__c = 'Extension';
        oppy3.RecordTypeId = '012E0000000fCzr';
        oppy3.StageName='Dead';
        oppy3.segment__c='A&C - does not match focus application';
        oppy3.Project_Status_Level__c='OPEN (1)';
        oppy3.Ownerid = u.id;
        oppy3.PLM_Id__c='3rrrrrfgdg';
        Listopp.add(oppy3);
         
         
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        
        oppy.Request_Type__c = 'Cable Assembly - New Dev';
        
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1000000;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 500000000;
        oppy.RecordTypeId ='012E0000000fCzr';
        oppy.Project_Status_Level__c='OPEN (1)';
        oppy.Ownerid = u.id;
        oppy.PLM_Id__c='34dfgdg';
        oppy.Total_Opportunity_Value__c=null;
        oppy.TEMarketing__Marketing_Sourced__c='Marketing Sourced';
        oppy.Approval_Status_PMV__c='Conversion Rejected';
       	oppy.segment__c='A&C - does not match focus application';
        
       Listopp.add(oppy);
        
        Insert Listopp;
       
        Contact Cont1= new contact(EmailBouncedReason='test reason',Inactive__c=False,salutation='Mr.',AccountID=acc.id,lastname='testlast',firstname='testfirst',email='tobias.schock@tts-ffestool.com',Ownerid=u.id);
        insert cont1;
        
     
 
        Task MyTask = new Task(Subject='test',Priority='Normal',Status='open',ActivityDate=system.today(),ownerid=u.id);
        insert MyTask;
      
       
      // Schedule the test job

      String jobId = System.schedule('testBasicScheduledApex',
      IND_ScheduledMytodoAppBatchClass.CRON_EXP, 
         new IND_ScheduledMytodoAppBatchClass());

      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

      // Verify the expressions are the same
      System.assertEquals(IND_ScheduledMytodoAppBatchClass.CRON_EXP, 
         ct.CronExpression);

      // Verify the job has not run
      System.assertEquals(0, ct.TimesTriggered);

      // Verify the next time the job will run
      System.assertEquals('2022-09-03 00:00:00', 
         String.valueOf(ct.NextFireTime));
      

   Test.stopTest();

   
   }
   

  
}