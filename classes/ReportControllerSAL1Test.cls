@IsTest(SeeAllData=true)
private class ReportControllerSAL1Test {
 
   static testMethod void SAL1test(){
     
     Account testAccount = new Account();
     testAccount.Name='Test Accountjumanjijurasic' ;
     insert testAccount;
     
     Lead l = new Lead();
      l.Firstname = 'Test rameshhresma';
      l.LastName = 'Test jumanji';
      l.TEMarketing__Stage__c = 'Sales Accepted';
      l.TEMarketing__MQL_Date__c = DateTime.now();
      l.Company = 'Test goodgoog';
      l.City='Bangalore';
      l.country='India';
      l.dct_flag__c=true;
      l.Street='34975';
      insert l;       
       TEMarketing__MQLRecord__c mql= new TEMarketing__MQLRecord__c();
        mql.TEMarketing__MQL_Date__c=Date.Valueof('2017-07-11T06:47:00.000+0000');
        mql.TEMarketing__Inquiry_Status__c='Sales Accepted';
        //mql.TEMarketing__Inquiry_Status__c='Marketing Qualified';
        mql.TEMarketing__Lead__c=[select id from Lead where id=:l.id][0].id;
       insert mql;
       
      
      Lead l2 = new Lead();
      l2.Firstname = 'Test oopspoos';
      l2.LastName = 'Test oiiulfs';
      l2.TEMarketing__Stage__c = 'Sales Accepted';
      l2.TEMarketing__MQL_Date__c = DateTime.now();
      l2.Company = 'Test iukl';
      l2.City='Bangalore';
      l2.country='India';
      l2.Street='34515';
      insert l2;
       TEMarketing__MQLRecord__c mql1= new TEMarketing__MQLRecord__c();
        mql1.TEMarketing__MQL_Date__c=Date.Valueof('2017-07-11T06:47:00.000+0000');
        mql.TEMarketing__Inquiry_Status__c='Sales Accepted';
        //mql1.TEMarketing__Inquiry_Status__c='Marketing Qualified';
        mql1.TEMarketing__Lead__c=[select id from Lead where id=:l2.id][0].id;
       insert mql1;
       
       
       
      Contact c = new Contact();
      c.Firstname = 'Test kureshis980';
      c.LastName = 'Test ehsani9980';
      c.AccountId = testAccount.id;     
      c.email='tesramji@kl2.com';
      c.dct_flag__c=true;
      insert c;
       TEMarketing__MQLRecord__c mqlc= new TEMarketing__MQLRecord__c();
        mqlc.TEMarketing__MQL_Date__c=Date.Valueof('2017-07-11T06:47:00.000+0000');
        mqlc.TEMarketing__Inquiry_Status__c='Sales Accepted';
        //mql1.TEMarketing__Inquiry_Status__c='Marketing Qualified';
        mqlc.TEMarketing__Contact__c=[select id from Contact where id=:c.id][0].id;
       insert mqlc;
       
       
       Contact c1 = new Contact();
      c1.Firstname = 'Test jrim';
      c1.LastName = 'Test loim';
      c1.AccountId = testAccount.id;     
      c1.email='test98ilf1@gmail.com';
      c1.dct_flag__c=true;
      insert c1;
       TEMarketing__MQLRecord__c mqlc1= new TEMarketing__MQLRecord__c();
        mqlc1.TEMarketing__MQL_Date__c=Date.Valueof('2017-07-11T06:47:00.000+0000');
        mqlc1.TEMarketing__Inquiry_Status__c='Sales Accepted';
        //mql1.TEMarketing__Inquiry_Status__c='Marketing Qualified';
        mqlc1.TEMarketing__Contact__c=[select id from Contact where id=:c1.id][0].id;
       insert mqlc1;
       

      PageReference pageRef = Page.mysal; 
      pageRef.getParameters().put('id', String.valueOf(testAccount.Id));
      Test.setCurrentPage(pageRef);
    ReportControllerSAL1 SAL1 = new ReportControllerSAL1();
    
    //SAL1.runReport();
   // SAL1.reportId ='00OE0000002vaTs';
    //SAL1.runReport();
   // SAL1.instanceId='00OE0000002vaTs';
    SAL1.getReportResults();
    
     
      
     // ReportControllerSALLeadOwner RC = new ReportControllerSALLeadOwner();
      
    }  
}