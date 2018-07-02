@isTest
/* -------------------------------------------------------------------------------------
 Test Class Written by Deepak Kumar 15/04/2016
 
/**
*   This test class is for IND_MyToDos_AppControllerMain.
*
@author Deepak Kumar
@created 15/04/2016
@version 1.0
@since 35.0
*

* - Created
* IND_MyToDos_AppControllerMain- Test coverage 85%
  

* ------------------------------------------------------------------------------------- */
private class IND_MyToDosApp_TestClass {


static testMethod void myUnitTest1() {

   Test.startTest();
       
        
        ClsTestCustomSettingHelper.getApex_Helper_Settings(); 
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
    	ClsTestCustomSettingHelper.getADM_Territory_Code();
    	
        ChannelinsightData_test.ChannelinsightData_test();
        
       
        RecordType rt = ClsTestHelp.createTestRecordType();
        RecordType rt2 = ClsTestHelp.createTestRecordType16();
        
        
              
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
        oppy2.Project_Status_Level__c='CANCELLED (3)';
        oppy2.PLM_Id__c='34drrgdg';
        Listopp.add(oppy2);  
        
        Opportunity oppy3 = ClsTestHelp.createTestOpportunity();
        oppy3.CloseDate =system.today()-31; 
        oppy3.Name = 'Pain of Queen';
        oppy3.Manufacturing_Start_Date__c=system.today()-31;
        oppy3.Request_Type__c = 'Extension';
        oppy3.RecordTypeId = '012E0000000fCzr';
        oppy3.StageName='Dead';
        
        oppy3.Project_Status_Level__c='OPEN (1)';
        oppy3.Ownerid = userinfo.getUserId();
        oppy3.PLM_Id__c='3rrrrrfgdg';
        Listopp.add(oppy3);
         
         
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        
        oppy.Request_Type__c = 'Extension';
        
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        oppy.RecordTypeId ='012E0000000fCzr';
        oppy.Project_Status_Level__c='OPEN (1)';
        oppy.Ownerid = userinfo.getUserId();
        oppy.PLM_Id__c='34dfgdg';
        Listopp.add(oppy);
        
        Insert Listopp;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial'; 
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy2.Id;
        oppypart.Part__c = part.Id;
        insert oppypart;
        
        List<Opportunity_Forecast__c> Listfor = new List<Opportunity_Forecast__c>();
        
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy2.Id;
        oppyForecast.Quantity__c = 12;
        oppyForecast.Part__c = oppypart.Id;
        oppyForecast.Date__c = date.newInstance(2016, 01, 01);
        oppyForecast.Amount__c = 1000;
        
        Listfor.add(oppyForecast);
        
        Opportunity_Forecast__c oppyForecast2 = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast2.Opportunity__c = oppy2.Id;
        oppyForecast2.Quantity__c = 12;
        oppyForecast2.Part__c = oppypart.Id;
        oppyForecast2.Date__c = date.newInstance(2016, 01, 01);
        oppyForecast2.Amount__c = 1;
        Listfor.add(oppyForecast2);
        
        Insert Listfor;
         
        list<Engineering_Milestone__c> listEM = new list<Engineering_Milestone__c>(); 
        Engineering_Milestone__c OppEnggMileS= new Engineering_Milestone__c(Opportunity__c=oppy.id,Actual__c=system.today(),Gate__c='Design Completion (G3)'); 
         listEM.add(OppEnggMileS); 
        Engineering_Milestone__c OppEnggMileS2= new Engineering_Milestone__c(Opportunity__c=oppy2.id,Actual__c=system.today(),Gate__c='Design Completion (G3)');
         listEM.add(OppEnggMileS2);
        Engineering_Milestone__c OppEnggMileS3= new Engineering_Milestone__c(Opportunity__c=oppy3.id,Actual__c=system.today(),Gate__c='Design Completion (G3)');           
         listEM.add(OppEnggMileS3); 
       
        insert listEM;
        
        Contact Cont1= new contact(salutation='Mr.',AccountID=acc.id,lastname='testlast',firstname='testfirst',email='tobias.schock@tts-ffestool.com');
        insert cont1;
        
        //TEMarketing__MQLRecord__c  mql = new TEMarketing__MQLRecord__c(TEMarketing__BU_Channel__c=true,TEMarketing__MQL_Date__c=system.now(),TEMarketing__contact__c=Cont1.id,ownerid=userinfo.getUserId(),TEMarketing__Inquiry_Status__c='Marketing Qualified'); 
          
          //insert mql;
         
         List<Task> listtast = new List<Task>();
        
         Task MyTask = new Task(Subject='test',Priority='Normal',Status='open',ActivityDate=system.today()-30,ownerid=userinfo.getUserId());
         listtast.add(MyTask);
         Task MyTask2 = new Task(Subject='test',Priority='Normal',Status='open',ActivityDate=system.today()+1,ownerid=userinfo.getUserId());
         listtast.add(MyTask2);
         Task MyTask3 = new Task(Subject='test',Priority='Normal',Status='open',ActivityDate=system.today(),ownerid=userinfo.getUserId());
         listtast.add(MyTask3);
         Task MyTask4 = new Task(Subject='test',Priority='Normal',Status='open',ActivityDate=system.today()-3,ownerid=userinfo.getUserId());
         listtast.add(MyTask4);
      
    
        insert listtast;
        

        PageReference pageRef1 = Page.IND_My_ToDo_s_App;
        //pageRef1.getParameters().put('id', String.valueOf(lact1.Id));
        test.setCurrentPage(pageRef1);
        //ApexPages.StandardController str1= new ApexPages.StandardController(lact1);
        IND_MyToDos_AppControllerMain Appcontroller = new IND_MyToDos_AppControllerMain();
        
        
        //Appcontroller.mainInit();
        Appcontroller.InvalidDataMethod();
        Appcontroller.HotCoolNormal();
        Appcontroller.selectedtraining='None';
        Appcontroller.ThisTasknewlist();
         Appcontroller.selectedtraining='Overdue';
        Appcontroller.ThisTasknewlist();
         Appcontroller.selectedtraining='Today';
        Appcontroller.ThisTasknewlist();
         Appcontroller.selectedtraining='Todayoverdue';
        Appcontroller.ThisTasknewlist();
   		 Appcontroller.selectedtraining='AllOpen';
        Appcontroller.ThisTasknewlist();
   		 Appcontroller.selectedtraining='ThisMonth';
        Appcontroller.ThisTasknewlist();
    	Appcontroller.selectedtraining='Next7Days';
        Appcontroller.ThisTasknewlist();
    	Appcontroller.selectedtraining='Tomorrow';
        Appcontroller.ThisTasknewlist();
        
    
    	double d= 20.8;        
        List<IND_MyToDos_AppControllerMain.subClassInvalidDatatInfo> MyInvData= new List<IND_MyToDos_AppControllerMain.subClassInvalidDatatInfo>();   
        MyInvData.add(new IND_MyToDos_AppControllerMain.subClassInvalidDatatInfo(d,oppy3));
        List<IND_MyToDos_AppControllerMain.subClassMissMatchInfo> MyInvData1= new List<IND_MyToDos_AppControllerMain.subClassMissMatchInfo>();   
        MyInvData1.add(new IND_MyToDos_AppControllerMain.subClassMissMatchInfo(Date.Today(),Date.Today(),OppEnggMileS3));
       
        
   Test.StopTest();
  }
}