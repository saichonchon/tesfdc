@isTest 
private class ICT_CreateTaskInTSTest{
    
    static testMethod void TestOne(){

     List<Opportunity> caselst= new List<Opportunity>{};
     //List<Attachment> attlist= new List<Attachment>{};
     Profile objProfile = [Select Id, Name from Profile where Name =: 'ICT Sales Standard User' limit 1];
     User u = new User();
     u.FirstName = 'testuser';
     u.LastName = 'ICTUser';
     u.ProfileId = objProfile.id;
     u.username ='amruta.d@te.com.dct';
     u.email ='amruta.d@te.com';
     u.alias ='abcd';
     u.TimeZoneSidKey = 'America/New_York';
     u.LocaleSidKey= 'en_US';
     u.EmailEncodingKey = 'UTF-8';
     u.LanguageLocaleKey = 'en_US';
     insert u;
     
     Recordtype RecordTypeIdopty = [select id from Recordtype where name='Opportunity - Sales Project' limit 1];

          
     
        TS_Org__c ts = new TS_Org__c();
        ts.name='TSIntegration';
        ts.EndPoint__c='https://tetransportation--qa.cs54.my.salesforce.com/services/data/v32.0/sobjects/Task';
        ts.accesstoken_url__c='https://tetransportation--qa.cs54.my.salesforce.com/services/oauth2/token';
        insert ts;
        //
        
         //Recordtype RecordTypeIdopty = [select id from Recordtype where name='Channel- Sales Opportunity' limit 1];
     
    
       Apex_Helper_Settings__c cs = new Apex_Helper_Settings__c();
       cs.Value__c = '012E0000000NImU';
       cs.name ='GAM Record Type Id';
       insert cs;
       
       Apex_Helper_Settings__c cs1= new Apex_Helper_Settings__c();
       cs1.Value__c = '012E0000000NImU';
       cs1.name ='Currency Confirm Except Users';
       insert cs1;
       
       Apex_Helper_Settings__c cs12= new Apex_Helper_Settings__c();
       cs12.Value__c = '012E0000000NImU';
       cs12.name ='Forecast Snapshot Part RT Id';
       insert cs12;
       
       
       Apex_Helper_Settings__c cs3= new Apex_Helper_Settings__c();
       cs3.Value__c = '012E0000000NImU';
       cs3.name ='Forecast Snapshot Oppy RT Id';
       insert cs3;
       
       Trigger_Configuration__c tc=new Trigger_Configuration__c();
       tc.Name='Identify Fiscal Year';
       tc.isRun__c=true;
       insert tc;
       
       Opportunity_Approvers__c oa=new Opportunity_Approvers__c();
       oa.Approver_Id__c=u.id;
       oa.Name='A&C GPLs 01';
       oa.Approver_Name__c='u.name';
       oa.GPLs__c='testGPL';
       oa.Test_Approver__c=u.id;
       insert oa;
       Opportunity_Approvers__c oa1=new Opportunity_Approvers__c();
       oa1.Approver_Id__c=u.id;
       oa1.Name='A&C GPLs 02';
       oa1.Approver_Name__c='u.name';
       oa1.GPLs__c='testGPL';
       oa1.Test_Approver__c=u.id;
       insert oa1;
       
       Opportunity_Approvers__c oa2=new Opportunity_Approvers__c();
       oa2.Approver_Id__c=u.id;
       oa2.Name='Rail GPLs';
       oa2.Approver_Name__c='u.name';
       oa2.GPLs__c='testGPL';
       oa2.Test_Approver__c=u.id;
       insert oa2;
       
       Opportunity_Approvers__c oa3=new Opportunity_Approvers__c();
       oa3.Approver_Id__c=u.id;
       oa3.Name='IB GPLs';
       oa3.Approver_Name__c='u.name';
       oa3.GPLs__c='testGPL';
       oa3.Test_Approver__c=u.id;
       insert oa3;
       
       Consumer_Device_Opportunity_Record_Types__c cdso=new Consumer_Device_Opportunity_Record_Types__c();
       cdso.Record_Type_Id__c='012E0000000eR0cIAE';
       cdso.Name='Engineering Opportunity-CSD';
       insert cdso;
       
       Consumer_Device_Opportunity_Record_Types__c cdso1=new Consumer_Device_Opportunity_Record_Types__c();
       cdso1.Record_Type_Id__c='012E0000000eR0dIAE';
       cdso1.Name='Sales Opportunity-CSD';
       insert cdso1;
       
       Trigger_Configuration__c tcg=new Trigger_Configuration__c();
       tcg.name='Populate Opportunity Partner';
       tcg.isRun__c=true;
       insert tcg;
        
        //
          
  
      
         
       system.runas(u) {   
        opportunity opp = new opportunity();
        opp.name ='Test1';
        opp.closedate = system.today();
        opp.stagename = 'Approved/Active';
        opp.recordtypeid=RecordTypeIdopty.id;
        opp.Currency_Confirm__c =true;
        opp.TS_TaskId__c = '1234';
     
        insert opp;
        
        test.starttest();
        
        
        
     
       Test.setMock(HTTPCalloutMock.class, new ICT_UploadFileMock());
       HTTPResponse res =null;
      
        ID opid = opp.id;
        
        ICT_CreateTaskInTS ict = new ICT_CreateTaskInTS();
        //ICT_CreateTaskInTS.accessToken='qweqeqwe72342900492099990';
        string s = ict.ReturnAccessToken(ict);
        
        ICT_CreateTaskInTS.createTask(opid);
        //ict.CCTestMethod();
        ICT_CreateTaskInTS.deserializeResponse d = new ICT_CreateTaskInTS.deserializeResponse();
        d.access_token = s;
        d.id = '123456';
        
        
        ICT_CreateTaskInTS.deserializeResponseNew d1 = new ICT_CreateTaskInTS.deserializeResponseNew();
        d1.success = true;
        d1.id = '1234';
        
        test.stoptest();
      }
  }   
  
}