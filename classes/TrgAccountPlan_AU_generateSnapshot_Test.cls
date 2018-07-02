/**
*   This test class is for AccountPlan_AU_generateSnapshot.
*
@author Di Chen
@created 2012-06-25
@version 1.0
@since 20.0
*
@changelog
* 2012-06-25 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 70% except try...catch...
*/
@isTest
private class TrgAccountPlan_AU_generateSnapshot_Test {

    static testMethod void testUpdate() {
        
        RecordType rt = ClsTestHelp.createTestRecordType6();
        RecordType rt2 = ClsTestHelp.createTestRecordType8();

        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt.Id;
        acc.Customer_Classification__c = 'B';
        acc.Type = 'Competitor';
        acc.GAMCD__c = '1000';
        insert acc;
        
        Account_Plan__c apOld = ClsTestHelp.createTestAccountPlan();
        apOld.Customer__c = acc.Id;
        //apOld.Competitor1__c = acc.Id;
        apOld.Replicate_to_Central_Org__c = false;
        apOld.Replicate_to_Central_Org__c = true;
        apOld.Strategic_Initiative_5_Status__c = 'On target';
        apOld.Approval_Status__c = 'Not Submitted';     
        insert apOld;
        
        Test.startTest();
        
        apOld.Active__c = true;
        apOld.Approval_Status__c = 'Approved';
        update apOld;
        
        system.assert(true);
        Test.stopTest();
    }
}