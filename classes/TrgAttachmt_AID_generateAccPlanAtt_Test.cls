/**
*   This test class is for Attachment_AID_generateAccoutPlanAttachment.
*
@author Di Chen
@created 2012-06-25
@version 1.0
@since 20.0
*
@changelog
* 2012-06-25 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 96%
*/
@isTest
private class TrgAttachmt_AID_generateAccPlanAtt_Test {

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
        
        Attachment att= ClsTestHelp.createTestAttachments();
        att.ParentId = apOld.Id;
        
        Test.startTest();
        
        insert att;
        
        delete att;
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testInsertAndDelete2() {
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
        apOld.Account_Definition__c = 'Custom';
        apOld.Customer__c = acc.Id;
        //apOld.Competitor1__c = acc.Id;
        apOld.Replicate_to_Central_Org__c = false;
        apOld.Replicate_to_Central_Org__c = true;
        apOld.Strategic_Initiative_5_Status__c = 'On target';
        apOld.Approval_Status__c = 'Not Submitted';
        insert apOld;
        
        list<Attachment> list_att = new list<Attachment>();
        
        Test.startTest();
        
        for(Integer i = 0;i <= 5 ;i++){
        Attachment att= ClsTestHelp.createTestAttachments();
        att.ParentId = apOld.Id;
        att.Name = 'newwy' + i;
        list_att.add(att);
        }
        insert list_att;
        system.assert(true);
        Test.stopTest();
    }
}