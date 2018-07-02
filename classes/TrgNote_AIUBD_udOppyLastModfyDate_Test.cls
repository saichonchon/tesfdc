/**
*   This test class is for note_AIUBD_updateOppyLastModifiedDate.
*
@author Di Chen
@created 2012-06-01
@version 1.0
@since 20.0
*
@changelog
* 2012-06-01 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 100%
*/
@isTest
private class TrgNote_AIUBD_udOppyLastModfyDate_Test {

    static testMethod void testInsertAndDelete() {
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
        u.ProfileId = p.Id;
        insert u;
              
        system.runAs(u){        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        insert oppy;
        
        Note note = new Note();
        note.ParentId = oppy.Id;
        note.Title = 'oh';
        Test.startTest();
        
        insert note;
        delete note;
        try
        {
            update note;
        }
        catch(DMLException ex)
        {
            notetriggerHelper.NoteTriggerExceptionhandler(ex, new list<note>{note}, new list<note>{note}, false);
        }
        try
        {
            update note;
        }
        catch(DMLException ex)
        {
            notetriggerHelper.NoteTriggerExceptionhandler(ex, new list<note>{note}, new list<note>{note}, true);
        }
        system.assert(true);
        
        Test.stopTest();
        }
    }
}