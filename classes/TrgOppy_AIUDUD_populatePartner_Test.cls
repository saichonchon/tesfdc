/**
*  This test class is for Opportunity_AIUDUD_populatePartner.
*
@author Di Chen
@created 2012-03-12
@version 1.0
@since 20.0
*
@changelog
* 2012-03-12 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 100%
*/
@isTest
private class TrgOppy_AIUDUD_populatePartner_Test {

  static testMethod void NullAccountId() {
    Profile p = [Select Id, Name From Profile 
                     where Name = 'Channel Standard User' 
                     or Name = 'Service Account' 
                     or Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'qscfd@helool.com';
        u.Alias = 'rfg';
        u.CommunityNickname = 'jkl';
        u.FirstName = 'lmk';
        u.ProfileId = p.Id;
        insert u;
      
        system.runAs(u){
        Test.startTest();
        
        RecordType rt = ClsTestHelp.createTestRecordType10();
  
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        insert acc;

        Opportunity oppy = ClsTestHelp.createTestOpportunity(); 
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        oppy.AccountId = acc.Id;
        oppy.StageName = 'New';
        oppy.RecordTypeId = rt.Id;
        insert oppy;
        
        Opportunity oppy2 = [select Id,
                      StageName
                   from Opportunity
                   where Id = :oppy.Id];
        system.assertEquals('New', oppy2.StageName);
        Test.stopTest();
        }
    }
  static testMethod void NotNullAccountId() {
        Profile p = [Select Id, Name From Profile 
                     where Name = 'Channel Standard User' 
                     or Name = 'Service Account' 
                     or Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'qscfd@helool.com';
        u.Alias = 'rfg';
        u.CommunityNickname = 'jkl';
        u.FirstName = 'lmk';
        u.ProfileId = p.Id;
        insert u;
      
        system.runAs(u){
        RecordType rt = ClsTestHelp.createTestRecordType10();
        Account acc = ClsTestHelp.createTestAccounts();
        insert acc;
        
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.Name = 'Sand King';
        insert acc2;
        
        Test.startTest();
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity(); 
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        oppy.AccountId = acc.Id;
        oppy.StageName = 'New';
        oppy.RecordTypeId = rt.Id;
        insert oppy;
        
        oppy.AccountId = acc2.Id;
        update oppy;
        
        Opportunity oppy2 = [select Id,
                      StageName
                   from Opportunity
                   where Id = :oppy.Id];
        system.assertEquals('New', oppy2.StageName);
        Test.stopTest();
     }
    }
    static testMethod void NotNullAccountId1() {
        Profile p = [Select Id, Name From Profile 
                     where Name = 'Channel Standard User' 
                     or Name = 'Service Account' 
                     or Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'qscfd@helool123.com';
        u.Alias = 'rfg123';
        u.CommunityNickname = 'jkl123';
        u.FirstName = 'lmk123';
        u.ProfileId = p.Id;
        insert u;
      
        system.runAs(u){
        RecordType rt = ClsTestHelp.createTestRecordType30();
        Account acc = ClsTestHelp.createTestAccounts();
        insert acc;
        
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.Name = 'TstAcc 123';
        insert acc2;
        
        Test.startTest();
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity(); 
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 10;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        oppy.AccountId = acc.Id;
        oppy.StageName = 'New';
        oppy.RecordTypeId = rt.Id;
        insert oppy;
        
        oppy.AccountId = acc2.Id;
        update oppy;
        
        Opportunity oppy2 = [select Id,
                      StageName
                   from Opportunity
                   where Id = :oppy.Id];
        system.assertEquals('New', oppy2.StageName);
        Test.stopTest();
        }
    }
}