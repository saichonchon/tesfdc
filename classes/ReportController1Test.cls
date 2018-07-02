@IsTest(SeeAllData=true)
private class ReportController1Test {
    static testmethod void Controller1test(){
        
        
        
        Account testAccount = new Account();
     testAccount.Name='Test Accountjunni' ;
     insert testAccount;
     
     Lead l = new Lead();
      l.Firstname = 'Test shartik1';
      l.LastName = 'Test thinkse';
      l.TEMarketing__Stage__c = 'Marketing Qualified';
      l.TEMarketing__MQL_Date__c = DateTime.now();
      l.Company = 'Test oklu';
      l.City='Bangalore';
      l.country='India';
      l.Street='34545';
      insert l;       
       TEMarketing__MQLRecord__c mql= new TEMarketing__MQLRecord__c();
        mql.TEMarketing__MQL_Date__c=Date.Valueof('2017-07-11T06:47:00.000+0000');
        //mql.TEMarketing__Inquiry_Status__c='Sales Accepted';
        mql.TEMarketing__Inquiry_Status__c='Marketing Qualified';
        mql.TEMarketing__Lead__c=[select id from Lead where id=:l.id][0].id;
       insert mql;
       
      
      Lead l2 = new Lead();
      l2.Firstname = 'Test ijjli2';
      l2.LastName = 'Test jijjs2';
      l2.TEMarketing__Stage__c = 'Marketing Qualified';
      l2.TEMarketing__MQL_Date__c = DateTime.now();
      l2.Company = 'Test 1lki';
      l2.City='Bangalore';
      l2.country='India';
      l2.Street='34545';
      insert l2;
       TEMarketing__MQLRecord__c mql1= new TEMarketing__MQLRecord__c();
        mql1.TEMarketing__MQL_Date__c=Date.Valueof('2017-07-11T06:47:00.000+0000');
        //mql.TEMarketing__Inquiry_Status__c='Sales Accepted';
        mql1.TEMarketing__Inquiry_Status__c='Marketing Qualified';
        mql1.TEMarketing__Lead__c=[select id from Lead where id=:l2.id][0].id;
       insert mql1;
       
       
       
      Contact c = new Contact();
      c.Firstname = 'Test 1kils';
      c.LastName = 'Test 1killsre';
      c.AccountId = testAccount.id;     
      c.email='testraosgood@gmail.com';
        c.DCT_Flag__c=true;
        c.ownerid=[select id from user where email ='jpcooney@te.com'][0].id;
      insert c;
       TEMarketing__MQLRecord__c mqlc= new TEMarketing__MQLRecord__c();
        mqlc.TEMarketing__MQL_Date__c=Date.Valueof('2017-07-11T06:47:00.000+0000');
        //mqlc.TEMarketing__Inquiry_Status__c='Sales Accepted';
        mql1.TEMarketing__Inquiry_Status__c='Marketing Qualified';
        mqlc.TEMarketing__Contact__c=[select id from Contact where id=:c.id][0].id;
        insert mqlc;       
       
       Contact c1 = new Contact();
       c1.Firstname = 'Test jrigus2';
       c1.LastName = 'Test 2kshs';
       c1.AccountId = testAccount.id;  
       c1.ownerid=[select id from user where email ='jpcooney@te.com'][0].id;
      c1.email='testrandeavor1@gdmail.com';
        c1.DCT_Flag__c=true;
      insert c1;
       TEMarketing__MQLRecord__c mqlc1= new TEMarketing__MQLRecord__c();
        mqlc1.TEMarketing__MQL_Date__c=Date.Valueof('2017-07-11T06:47:00.000+0000');
        //mqlc1.TEMarketing__Inquiry_Status__c='Sales Accepted';
        mql1.TEMarketing__Inquiry_Status__c='Marketing Qualified';
        mqlc1.TEMarketing__Contact__c=[select id from Contact where id=:c1.id][0].id;
        insert mqlc1;        
        
       List <Report> reportList = [SELECT Id,DeveloperName FROM Report WHERE developername ='My_MQLs_Dashboard_Leads_MQL_ICT'];        
        String reportId = (String)reportList.get(0).get('Id');
        Reports.ReportMetadata reportMetadata = Reports.ReportManager.describeReport(reportId).getReportMetadata();
        
        List<Reports.ReportFilter> filters = new List<Reports.ReportFilter>(); 
        Reports.ReportFilter newFilter = new Reports.ReportFilter();
        newFilter.setColumn('Type');
        newFilter.setOperator('equals');
        newFilter.setValue('ApexTestOpp');
        filters.add(newFilter);
       
        Reports.reportResults results = Reports.ReportManager.runReport(reportId, true); 
        Test.startTest();
        Reports.ReportInstance instanceObj = reports.ReportManager.runAsyncReport(reportId,true);
        String instanceId = instanceObj.getId();
        Test.stopTest();
        instanceObj = Reports.ReportManager.getReportInstance(instanceId);
        Reports.ReportResults result = instanceObj.getReportResults();
        Reports.ReportFact grandTotal = (Reports.ReportFact)result.getFactMap().get('reportList');
        Reports.ReportResults result1 = Reports.ReportManager.runReport(reportId,false); 
        Reports.ReportFact grandTotal1 = (Reports.ReportFact)result.getFactMap().get('T!T');
        
        List <Report> reportList1 = [SELECT Id,DeveloperName FROM Report where developername ='My_MQLs_Dashboard_Leads_MQL_ICT'];
        Reports.reportResults results1= Reports.ReportManager.runReport(reportList1[0].Id, true);        
        Reports.Dimension dim1 = results1.getGroupingsDown();        
        system.debug('==reportList1 =>'+reportList1 );
        system.debug('==reportList1 =>'+dim1);
        ReportController1 rep = new ReportController1();
        rep.retrieveAvailableReports();
        //rep.runReport();
        //try{
        //rep.checkForReportResults();
        //}catch(Exception e){}
        
        ApexPages.currentPage().getParameters().put(reportList[0].id, reportList[0].id);
       //Report reportResults = Reports.ReportManager.runReport(r[0].id, true);
       
       //Test.loadData(Account.sObjectType, 'accountRecords');
        ReportController1.MQLData MQLDataTest= new ReportController1.MQLData();
        //rep.processInstance(instanceObj);
        rep.getReportResults();
        MQLDataTest.FullName = 'testNamejunk';
        MQLDataTest.Id = reportList[0].id;
        MQLDataTest.MqlDate = system.today();
        MQLDataTest.Age = 22;
        MQLDataTest.AccountName = 'Test Accountjunni';
        MQLDataTest.AccountId = '0010m000005VOWE';
        MQLDataTest.Type = 'testType';
        MQLDataTest.MQLOwner = 'testMQL';
        MQLDataTest.DCTFlag = 'testDCT';
        MQLDataTest.LeadContactOwner = 'testLead';
        MQLDataTest.Rating = '1';
    } 
}