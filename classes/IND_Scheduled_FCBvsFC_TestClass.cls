/*********************************************************************************************************************** 
 Name:  IND_Scheduled_FCBvsFC_TestClass
 Salesforce Instance : QA Sandbox
========================================================================================================================
 Purpose: This test class is covering the below class test coverage:
  1. INDBatch_Recal_Billing_AchievedClass: 100%
  2. IND_ScheduleForecastAttainmentClass: 100%
  3.IND_Recal_Billing_Achieved : 88%
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
 VERSION AUTHOR                DATE         DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
     1.0 Deepak               16 Jan 2017   Initial Development                                         



***********************************************************************************************************************/




@isTest()
class IND_Scheduled_FCBvsFC_TestClass {

   static testmethod void test() {
   Test.startTest();
      
       ClsTestCustomSettingHelper.getApex_Helper_Settings(); 
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ChannelinsightData_test.ChannelinsightData_test();
        
       
        RecordType rt = ClsTestHelp.createTestRecordType();
        RecordType rt2 = ClsTestHelp.createTestRecordType16();
        id rt3 = Schema.SObjectType.Opportunity_Forecast__c.getRecordTypeInfosByName().get('Part').getRecordTypeId();
        id rt4 = Schema.SObjectType.Forecast_Billing__c.getRecordTypeInfosByName().get('Engineering').getRecordTypeId();
        id rt5 = Schema.SObjectType.Forecast_Billing__c.getRecordTypeInfosByName().get('Regular').getRecordTypeId();
        
        List<Opportunity_Record_Type_Groups__c> ListcusTemp = new List<Opportunity_Record_Type_Groups__c>();
        
       Opportunity_Record_Type_Groups__c cusTemp = new Opportunity_Record_Type_Groups__c();
       Opportunity_Record_Type_Groups__c cusTemp1 = new Opportunity_Record_Type_Groups__c();
        cusTemp.Active__c= True;
        cusTemp.name= 'Test';
        cusTemp.Group__c='Forecast Attainment Percentage Calculation';
        cusTemp.API_Name__c='tets_test';
        ListcusTemp.add(cusTemp);
       
        cusTemp1.Active__c= True;
        cusTemp1.name= 'Test1';
        cusTemp1.Group__c='Forecast Attainment Percentage Calculation';
        cusTemp1.API_Name__c='tets_test1';
        ListcusTemp.add(cusTemp1);       
       
       
       Insert ListcusTemp;
        
       Batch_Email_message_Users__c EmailmessageUsers =new Batch_Email_message_Users__c();
       EmailmessageUsers.name='INDBatch_Recal_Billing_AchievedClass';
       EmailmessageUsers.Email_ID__c='test@test.com';
       
       Insert EmailmessageUsers;
              
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        acc.Ownerid=userinfo.getUserId();
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
        oppy2.Ownerid = userinfo.getUserId();
       
        oppy2.PLM_Id__c='34drrgdg';
        Listopp.add(oppy2);  
        
        Opportunity oppy3 = ClsTestHelp.createTestOpportunity();
        oppy3.CloseDate =system.today()-31; 
        oppy3.Name = 'Pain of Queen';
        oppy3.Manufacturing_Start_Date__c=system.today()-31;
        oppy3.Request_Type__c = 'Extension';
        //oppy3.RecordTypeId = '012E0000000fCzr';
       
        
        oppy3.Project_Status_Level__c='OPEN (1)';
        oppy3.Ownerid = userinfo.getUserId();
         
        Listopp.add(oppy3); 
       
        Insert Listopp;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial'; 
        insert ph;
        
        List<Part__c> Listpart =new List<Part__c>();
       
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        Part.PLM_ID__c='34drrgdg';
        
        Listpart.add(part);
        
       Part__c part1 = new Part__c();
        part1.Description__c = 'Sniper';
        part1.Product_Hierarchy__c = ph.Id;
         Listpart.add(part1);
       
       insert Listpart;
      
        List< Opportunity_Part__c> Listoppypart = new  List<Opportunity_Part__c>();
       
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy2.Id;
        oppypart.Part__c = part.Id;
        oppypart.Status__c='Won' ;
         Listoppypart.add(oppypart);
       
       
         
        Opportunity_Part__c oppypart1 = ClsTestHelp.createTestOpportunityPart();
        oppypart1.Opportunity__c = oppy3.Id;
        oppypart1.Part__c = part1.Id;
        oppypart1.Status__c='won' ;
         Listoppypart.add(oppypart1);
       
       insert Listoppypart;
       
        List<Opportunity_Forecast__c> Listfor = new List<Opportunity_Forecast__c>();
        
       
        
        Opportunity_Forecast__c oppyForecast2 = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast2.Opportunity__c = oppy2.Id;
        oppyForecast2.Quantity__c = 12;
        oppyForecast2.Part__c = Null;
        oppyForecast2.Date__c = system.today();
        oppyForecast2.Amount__c = 1;
        oppyForecast2.Fiscal_Year__c='2017'; 
        oppyForecast2.Fiscal_Quarter__c='01';
        oppyForecast2.RecordTypeid=rt3;
       
       
        Listfor.add(oppyForecast2);
       
       
        Opportunity_Forecast__c oppyForecast3 = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast3.Opportunity__c = oppy2.Id;
        oppyForecast3.Quantity__c = 12;
        oppyForecast3.Part__c = Null;
        oppyForecast3.Date__c = system.today();
        oppyForecast3.Amount__c = 1;
        oppyForecast3.Fiscal_Year__c='2016'; 
        oppyForecast3.Fiscal_Quarter__c='03';
        oppyForecast3.RecordTypeid=rt3;
       
       
        Listfor.add(oppyForecast3);
       
       
        Opportunity_Forecast__c oppyForecast4 = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast4.Opportunity__c = oppy3.Id;
        oppyForecast4.Quantity__c = 12;
        oppyForecast4.Part__c = Null;
        oppyForecast4.Date__c = system.today();
        oppyForecast4.Amount__c = 1;
        oppyForecast4.Fiscal_Year__c='2017'; 
        oppyForecast4.Fiscal_Quarter__c='02';
        oppyForecast4.RecordTypeid=rt3;
       
       
        Listfor.add(oppyForecast4);
       
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy3.Id;
        oppyForecast.Quantity__c = 12;
        oppyForecast.Part__c = null;
        oppyForecast.Date__c = system.today();
        oppyForecast.Amount__c = 1000;
        oppyForecast.Fiscal_Year__c='2017'; 
        oppyForecast.Fiscal_Quarter__c='01';
        oppyForecast.RecordTypeid=rt3;
        
        Listfor.add(oppyForecast); 
        
        Insert Listfor;
     
       List<Forecast_Billing__c> ListFCB = new List<Forecast_Billing__c>();
       
       Forecast_Billing__c FCB = new Forecast_Billing__c();
       FCB.Opportunity_Forecast__c=oppyForecast2.id;
       FCB.Opportunity_Part__c=oppypart.id;
       FCB.Date__c = system.today()-80;
       FCB.RecordTypeid=rt4;
       FCB.Amount__c=1000;
       ListFCB.add(FCB);
      
       Forecast_Billing__c FCB1 = new Forecast_Billing__c();
       FCB1.Opportunity_Forecast__c=oppyForecast.id;
       FCB1.Opportunity_Part__c=oppypart1.id;
       FCB1.Date__c = system.today()-80;
       FCB1.RecordTypeid=rt5;
       FCB1.Amount__c=1000;
       ListFCB.add(FCB1);
       
       Insert ListFCB;
       
      // Schedule the test job

      String jobId = System.schedule('testBasicScheduledApex',
      IND_ScheduleForecastAttainmentClass.CRON_EXP, 
         new IND_ScheduleForecastAttainmentClass());

      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

      // Verify the expressions are the same
      System.assertEquals(IND_ScheduleForecastAttainmentClass.CRON_EXP, 
         ct.CronExpression);

      // Verify the job has not run
      System.assertEquals(0, ct.TimesTriggered);

      // Verify the next time the job will run
      System.assertEquals('2022-09-03 00:00:00', 
         String.valueOf(ct.NextFireTime));
       
       map<string,double> Convertedrate;
        if(Convertedrate == null){
           Convertedrate= new  map<string,double>();
            for(currencytype cr:[SELECT conversionrate,isocode FROM currencytype]){
                Convertedrate.put(cr.isocode,cr.conversionrate);
              } 
          }
       IND_Recal_Billing_Achieved tempCott = New IND_Recal_Billing_Achieved(1,2017,Convertedrate);
       integer ih =tempCott.UpdateBillingOpp(Listopp);
       IND_Recal_Billing_Achieved tempCott1 = New IND_Recal_Billing_Achieved(2,2017,Convertedrate);
       integer ij =tempCott1.UpdateBillingOpp(Listopp);
       IND_Recal_Billing_Achieved tempCott2 = New IND_Recal_Billing_Achieved(3,2017,Convertedrate);
       integer ii =tempCott2.UpdateBillingOpp(Listopp);
       IND_Recal_Billing_Achieved tempCott3 = New IND_Recal_Billing_Achieved(4,2017,Convertedrate);
       integer ik =tempCott3.UpdateBillingOpp(Listopp);
       

   Test.stopTest();

   
   }
    
    
  
}