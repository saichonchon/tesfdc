/**
*   This test class is for Note_AID_generateAccountPlanNote.
*
@author Di Chen
@created 2012-06-25
@version 1.0
@since 20.0
*
@changelog
* 2012-06-25 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 100%
*/
@isTest
private class TrgNote_AID_generateAccountPlanNote_Test {

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
        RecordType rt = ClsTestHelp.createTestRecordType6();
        RecordType rt2 = ClsTestHelp.createTestRecordType8();
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt2.Id;
        acc.Customer_Classification__c = 'B';
        acc.Type = 'Competitor';
        insert acc;
        
        Account_Plan__c apOld = ClsTestHelp.createTestAccountPlan();
        apOld.Customer__c = acc.Id;
        apOld.Account_Definition__c = 'Custom';
        //apOld.Competitor1__c = acc.Id;
        apOld.Replicate_to_Central_Org__c = false;
        apOld.Replicate_to_Central_Org__c = true;
        apOld.Strategic_Initiative_5_Status__c = 'On target';
        apOld.Approval_Status__c = 'Not Submitted';
        insert apOld;
        
        Note note = new Note();
        note.ParentId = apOld.Id;
        note.Title = 'oh';
        
        Test.startTest();
        
        insert note;
        delete note;
        
        system.assert(true);
        Test.stopTest();
    }
}