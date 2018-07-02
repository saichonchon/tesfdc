@isTest
private class TrgCase_caseRoundRobin_Test {
    static testMethod void Test1(){
         Profile p = [Select Id, Name From Profile 
                                where Name = 'Channel Standard User' 
                                or Name = 'Service Account' 
                                or Name ='System Administrator' 
                                or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'ver@testCompany1233423.com';
        u.Alias = 'ver';
        u.CommunityNickname = 'ver';
        u.ProfileId = p.Id;
        u.Username = 'vedke@xxde.com';
        insert u;
        
        User u1 = ClsTestHelp.createTestUsers();
        u1.Email = 'ver@testCompany12334231.com';
        u1.Alias = 'ver1';
        u1.CommunityNickname = 'ver1';
        u1.ProfileId = p.Id;
        u1.Username = 'vedke@xxde1.com';
        insert u1;        

        User u2 = ClsTestHelp.createTestUsers();
        u2.Email = 'ver@testCompany123342312.com';
        u2.Alias = 'ver2';
        u2.CommunityNickname = 'ver2';
        u2.ProfileId = p.Id;
        u2.Username = 'vedke@xxde2.com';
        insert u2; 
                
        system.runAs(u){
            
            ClsTestCustomSettingHelper.getApex_Helper_Settings();
            
            Group testGroup = new Group ();
            testGroup.Name = 'AMER CSSC TEAM';
            testGroup.Type = 'Queue';
            insert testGroup;
            
            QueueSObject testQueue = new QueueSObject();
            testQueue.QueueId = testGroup.id;
            testQueue.SObjectType = 'Case';
            insert testQueue;
            
            Assignment_Group_Name__c ag = new Assignment_Group_Name__c (Name='AMER CSSC TEAM', Type__c = 'Case');
            insert ag;
            
            Assignment_Group_Queues__c agq = new Assignment_Group_Queues__c(name='AMER CSSC TEAM',Assignment_Group_Name__c = ag.id );
            insert agq;
            
            Assignment_Groups__c a = new Assignment_Groups__c();
            a.Group_Name__c = ag.Id;
            a.Active__c = 'True';
            a.User__c = u1.Id;
            insert a;
            
            Id RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Care Cloud').getRecordTypeId();
            Case c = new Case();
            c.RecordTypeId = RecordTypeId;
            c.Subject = 'test case 001';
            c.Inquiry_Type__c = 'Other';
            c.Other_Inquiry_Type__c = 'Other';
            c.Status = 'In Progress';
            c.OwnerId = testGroup.Id;
            insert c;
            
            c.OwnerId = u2.Id;
            update c;            
        }
    }
    
    static testMethod void Test2(){
         Profile p = [Select Id, Name From Profile 
                                where Name = 'Channel Standard User' 
                                or Name = 'Service Account' 
                                or Name ='System Administrator' 
                                or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'ver@testCompany1233423.com';
        u.Alias = 'ver';
        u.CommunityNickname = 'ver';
        u.ProfileId = p.Id;
        u.Username = 'vedke@xxde.com';
        insert u;
        
        User u1 = ClsTestHelp.createTestUsers();
        u1.Email = 'ver@testCompany12334231.com';
        u1.Alias = 'ver1';
        u1.CommunityNickname = 'ver1';
        u1.ProfileId = p.Id;
        u1.Username = 'vedke@xxde1.com';
        insert u1;        

        User u2 = ClsTestHelp.createTestUsers();
        u2.Email = 'ver@testCompany123342312.com';
        u2.Alias = 'ver2';
        u2.CommunityNickname = 'ver2';
        u2.ProfileId = p.Id;
        u2.Username = 'vedke@xxde2.com';
        insert u2; 
                
        system.runAs(u){
            
             ClsTestCustomSettingHelper.getApex_Helper_Settings();
            
            Group testGroup = new Group ();
            testGroup.Name = 'AMER CSSC TEAM';
            testGroup.Type = 'Queue';
            insert testGroup;
            
            QueueSObject testQueue = new QueueSObject();
            testQueue.QueueId = testGroup.id;
            testQueue.SObjectType = 'Case';
            insert testQueue;
            
            Assignment_Group_Name__c ag = new Assignment_Group_Name__c (Name='AMER CSSC TEAM', Type__c = 'Case');
            insert ag;
            
            Assignment_Group_Queues__c agq = new Assignment_Group_Queues__c(name='AMER CSSC TEAM',Assignment_Group_Name__c = ag.id );
            insert agq;
            
            Assignment_Groups__c a = new Assignment_Groups__c();
            a.Group_Name__c = ag.Id;
            a.Active__c = 'True';
            a.User__c = u1.Id;
            insert a;
            
            Id RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Care Cloud').getRecordTypeId();
            Case c = new Case();
            c.RecordTypeId = RecordTypeId;
            c.Subject = 'test case 001';
            c.Inquiry_Type__c = 'Other';
            c.Other_Inquiry_Type__c = 'Other';
            c.Status = 'In Progress';
            c.OwnerId = testGroup.Id;
            insert c;
            
            c.OwnerId = u2.Id;
            c.TempOwnerId__c = 'SKIP';
            update c;            
        }
    }    
}