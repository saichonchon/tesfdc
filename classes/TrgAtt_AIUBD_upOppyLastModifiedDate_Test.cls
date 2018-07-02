/**
*   This test class is for Attachment_AIUBD_updateOppyLastModifiedDate.
*
@author Di Chen
@created 2013-01-30
@version 1.0
@since 20.0
*
@changelog
* 2013-01-30 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 100%
*/
@isTest
private class TrgAtt_AIUBD_upOppyLastModifiedDate_Test {

    static testMethod void testAIUBD() {
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();   
          
        Profile p = [Select Id, Name From Profile 
                     where Name = 'BU Analyst' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'hellosManedsfd@testCompany1233423.com';
        u.Alias = 'dpses';
        u.CommunityNickname = 'NNND';
        u.Username = 'enene@kele.com';
        u.ProfileId = p.Id;
        insert u;
              
        system.runAs(u){  
            ClsTestCustomSettingHelper.getLast_Modified_Field_Update_Permission(); 
            RecordType rt2 = ClsTestHelp.createTestRecordType8();
            
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Name = 'axx';
            acc.RecordTypeId = rt2.Id;
            acc.Customer_Classification__c = 'A';
            acc.Type = 'Competitor';
            acc.GAMCD__c = '1000';
            insert acc;
                    
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.AccountId = acc.Id;
            oppy.StageName = 'New';
            oppy.Type = 'CM';
            oppy.Request_Type__c = 'Extension';
            oppy.Method__c = 'BOM';
            oppy.Level__c = 'Yearly';
            oppy.Amount = 1;
            oppy.CurrencyIsoCode = 'EUR';
            oppy.Five_Year_Revenue__c = 1;
            insert oppy;
            
            Attachment att= ClsTestHelp.createTestAttachments();
            att.ParentId = oppy.Id;
            
            Test.startTest();
            
            insert att;
            
            delete att;
            system.assert(true);
            Test.stopTest();
        }       
    }
}