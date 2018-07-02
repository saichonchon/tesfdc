/**
 * 
 *   This is the test class for the class - BatchCls_DeleteSObjects
 *
 * @author      Prabhanjan Nandyala
 * @created     2016-03-07
 * @since      36.0     
 * @version     1.0                                                                
 * 
 * @changelog
 * 2016-03-07 Prabhanjan Nandyala <prabhanjan.nandyala@te.com>
 * - Created
 * - test coverage - 86%
 */

@isTest
public class BatchCls_DeleteSObjects_Test{
    static testMethod void BatchCls_Test1(){
        
        
        ClsTestCustomSettingHelper.getApex_Helper_Settings(); 
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ChannelinsightData_test.ChannelinsightData_test();
        
        List<Case> cs = new List<Case>(); 
        //prepare custom settings data
        Batch_Delete_Inputs__c inputs = new Batch_Delete_Inputs__c();
        inputs.Age_in_Days__c = 180;
        inputs.Email_Body_of_Report__c = 'test';
        inputs.Email_For_Notifications__c = 'prabhanjan.nandyala@zensar.in,prabhanjan.nandyala@te.com';
        inputs.Name = 'JOB1';
        inputs.Parent_Record_Types__c = 'All';
        
        insert inputs;
        //insert account
        Account acc =  ClsTestHelp.createTestAccounts();
        insert acc;
        //insert contact
        Contact con;
        con = ClsTestHelp.createTestContacts();
        con.email='test@org.com';
        con.accountid = acc.id;
        insert con;  
        Case Cs1 = new Case(); 
        Cs1.Status= 'In Progress';
        Cs1.Description = 'Test Description';
        Cs1.AccountId = acc.id;
        cs1.contactId=con.Id;
        Cs1.ClosedDate = system.today().addDays(-200); 
        cs.add(Cs1);  
        
        Case Cs2 = new Case();  
        Cs2.Status= 'In Progress';
        Cs2.Description = 'Test Description';
        Cs2.AccountId = acc.id;
        cs2.contactId=con.Id;
        Cs2.ClosedDate = system.today().addDays(-200); 
        cs.add(Cs2); 
        insert Cs;
        
        List<EMAILMESSAGE> m1 = new List<EMAILMESSAGE>();
        for(case c:cs){
            EmailMessage Mail = new EmailMessage();
            Mail.ParentId = c.Id; 
            Mail.FromAddress = 'test@gmail.com';
            Mail.ToAddress ='test@gmail.com';
            Mail.ccAddress = 'test@gmail.com';
            Mail.bccAddress = 'test@gmail.com';
            m1.add(Mail);
            
            // changing status to closed.
            c.status= 'Closed';
        }
        insert m1; 
        update cs;
        Test.startTest();
        system.debug('sri### emailmessages in testmethod1' +m1);
        BatchCls_DeleteSObjects BC = new BatchCls_DeleteSObjects();
        Database.executebatch(BC,200);
        Test.stopTest();
    }
    static testMethod void BatchCls_Test2(){
        
        
        ClsTestCustomSettingHelper.getApex_Helper_Settings(); 
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ChannelinsightData_test.ChannelinsightData_test();
        
        List<Case> cs = new List<Case>(); 
        //prepare custom settings data
        Batch_Delete_Inputs__c inputs = new Batch_Delete_Inputs__c();
        inputs.Age_in_Days__c = 180;
        inputs.Email_Body_of_Report__c = 'test';
        inputs.Email_For_Notifications__c = 'prabhanjan.nandyala@zensar.in';
        inputs.Name = 'JOB1';
        inputs.Parent_Record_Types__c = 'C2S Cases,Customer Care Cloud';
        
        insert inputs;
        //prepare custom settings data for case groups
        list<Case_Record_Type_Groups__c> CaseRTList = new list<Case_Record_Type_Groups__c>();
        Case_Record_Type_Groups__c CaseRT = new Case_Record_Type_Groups__c();
        CaseRT.Name = 'C2S Cases';
        CaseRT.Active__c = true;
        CaseRT.API_Name__c = 'C2S_Cases';
        CaseRT.RecordTypeID__c = '012E0000000f8tj';
        CaseRTList.add(CaseRT);
        Case_Record_Type_Groups__c CaseRT2 = new Case_Record_Type_Groups__c();
        CaseRT2.Name = 'Customer Care Cloud';
        CaseRT2.Active__c = true;
        CaseRT2.API_Name__c = 'Customer_Care_Cloud';
        CaseRT2.RecordTypeID__c = '012E0000000f8in';
        CaseRTList.add(CaseRT2);
        
        insert CaseRTList;
        //insert account
        Account acc =  ClsTestHelp.createTestAccounts();
        insert acc;
        //insert contact
        Contact con;
        con = ClsTestHelp.createTestContacts();
        con.email='test@org.com';
        con.accountid = acc.id;
        insert con;  
        Case Cs1 = new Case(); 
        Cs1.Status= 'In Progress';        
        Cs1.Description = 'Test Description';
        Cs1.AccountId = acc.id;
        cs1.contactId=con.Id;
        cs1.RecordTypeId ='012E0000000f8in';  // record type of custome care cloud
        Cs1.ClosedDate = system.today().addDays(-400); 
        cs.add(Cs1);  
        
        Case Cs2 = new Case();  
        Cs2.Status= 'In Progress';       
        Cs2.Description = 'Test Description';
        Cs2.AccountId = acc.id;
        cs2.contactId=con.Id;
        Cs2.ClosedDate = system.today().addDays(-400); 
        cs.add(Cs2); 
        insert Cs;
        
        List<EMAILMESSAGE> m1 = new List<EMAILMESSAGE>();
        for(case c:cs){
            EmailMessage Mail = new EmailMessage();
            Mail.ParentId = c.Id; 
            Mail.FromAddress = 'test@gmail.com';
            Mail.ToAddress ='test@gmail.com';
            Mail.ccAddress = 'test@gmail.com';
            Mail.bccAddress = 'test@gmail.com';
            m1.add(Mail);
            
            // changing status to closed.
            c.status= 'Closed';
            //c.ClosedDate = system.today().addDays(-400);
        }
        insert m1; 
        update cs;
        //SELECT ID,PARENTID FROM EMAILMESSAGE WHERE PARENT.STATUS=\''+'Closed'+'\' AND parent.closeddate <=:';
        //List<EmailMessage> emlist = [SELECT ID,PARENTID FROM EMAILMESSAGE WHERE PARENT.Status = 'Closed' AND parent.closeddate <=: Date.today().adddays(-182) AND parent.ID =: cs[0].id];
        Date tempdate = Date.today().adddays(-200);
        system.debug('sri### tempdate' +tempdate);
        List<EmailMessage> emlist = [SELECT ID,PARENTID, PARENT.closeddate, PARENT.Status FROM EMAILMESSAGE WHERE PARENT.Status = 'Closed' AND PARENT.Closeddate <=: tempdate ];
        system.debug('List query'+emlist );
        Test.startTest();
        system.debug('sri### emailmessages in testmethod2 closeddate' +m1[0].PARENT.closeddate);
        system.debug('sri### emailmessages in testmethod2 parent id' +m1[0].Parentid);
        
        system.debug('sri### Cases in testmethod2' +cs[0].closeddate+'id'+ cs[0].id);  
        system.debug('sri### Cases in testmethod2 id' +cs[0].id); 
        
        BatchCls_DeleteSObjects BC = new BatchCls_DeleteSObjects();
        //BC.start(null);
        //BC.execute(null,null);
        //BC.finish(null);
        Database.executebatch(BC,200);
        Test.stopTest();
    }
}