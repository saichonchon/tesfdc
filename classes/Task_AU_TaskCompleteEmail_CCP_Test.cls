/**********************************************************************************************************************************************
*******
Name: Task_AU_TaskCompleteEmail_CCP_Test
Copyright © 2014 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This test class covers test coverage for Task_AU_TaskCompleteEmail_CCP trigger.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE       DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Ramakrishna Singara  04/25/2014    Test Class                       
***********************************************************************************************************************************************
*****/
@IsTest(SeeAllData=true)
private class Task_AU_TaskCompleteEmail_CCP_Test{
     public static testMethod void MytestTrigger() {   
         
        Test.startTest();     
            
        Profile p = [SELECT Id FROM Profile WHERE Name='Customer Care Service Cloud'];
        User activeUser = new User(Alias = 'stand', Email='ram1@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='std456@testorg.com');
        insert activeUser;
        
        Schema.DescribeSObjectResult cfrAccSchema = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> CaseRecordTypeInfo = cfrAccSchema.getRecordTypeInfosByName(); 
        Id CPPCasertId = CaseRecordTypeInfo.get('Customer Care Cloud').getRecordTypeId();
        
        Schema.DescribeSObjectResult cfrAccSchema1 = Schema.SObjectType.Task; 
        Map<String,Schema.RecordTypeInfo> TaskRecordTypeInfo = cfrAccSchema1.getRecordTypeInfosByName(); 
        Id CPPTaskrtId = TaskRecordTypeInfo.get('Customer Care Task').getRecordTypeId();
        
        Account acc =  ClsTestHelp.createTestAccounts();
        insert acc;
        
        Contact con;
        con = ClsTestHelp.createTestContacts();
        con.email='test@org.com';
        insert con;
        
        Case Cs = new Case();
        Cs.OwnerId= activeUser.id;
        Cs.Origin = 'Email-cip1';
        Cs.Inquiry_Type__c = 'Other';
        Cs.Other_Inquiry_Type__c = 'Other';
        Cs.Status= 'In Progress';
        Cs.Subject= 'Test';
        Cs.Description = 'Test Description';
        Cs.RecordTypeId = CPPCasertId;
        Cs.AccountId = acc.id;
        Cs.contactId=con.Id;
        insert Cs;
        
        Task tsk = new Task();
        tsk.OwnerId= activeUser.id;
        tsk.recordtypeid = CPPTaskrtId;
        tsk.Subject = 'Test';
        tsk.Status = 'In Progress';
        tsk.whatid = Cs.id;        
        insert tsk;
        
        tsk.Status = 'Completed';
        update tsk;
        Test.stopTest();
        
    }
}