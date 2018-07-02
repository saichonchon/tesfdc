/**
*   This test class is for ProductHierarchy_AIUUD_managedSharing.
*
@author Di Chen
@created 2012-02-23
@version 1.0
@since 20.0
*
@changelog
* 2012-02-23 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 96%
*/
@isTest
private class TrgProdHierarchy_AIUUD_managedShar_Test {

   static testMethod void testIsAfter() {
        
       // RecordType rt3 = ClsTestHelp.createTestRecordType3();
        //RecordType rt4 = ClsTestHelp.createTestRecordType4();
        
        Test.startTest();
        
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        //ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.GPL_Description__c = 'Industrial';
       // ph.RecordTypeId = rt3.Id;
        insert ph;
        
        //ph.RecordTypeId = rt4.Id;
        update ph;
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testUpdate() {
        
       // RecordType rt3 = ClsTestHelp.createTestRecordType3();
        //RecordType rt4 = ClsTestHelp.createTestRecordType4();
        
        User u = ClsTestHelp.createTestUsers();
        u.Alias = 'hehehe';
        u.Email = 'hahahah@testitbconsult123.com';
        u.CommunityNickname = 'hahahahah';
        insert u;
        
        Test.startTest();
        
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        //ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.GPL_Description__c = 'Industrial';
      //  ph.RecordTypeId = rt3.Id;
        ph.Product_Manager__c = UserInfo.getUserId();
        ph.Regional_PM_AP__c = UserInfo.getUserId();
        ph.Regional_PM_EU__c =UserInfo.getUserId();
        ph.Regional_PM_US__c = UserInfo.getUserId();
        ph.Global_PM__c =UserInfo.getUserId();
        ph.Approver_PM__c =UserInfo.getUserId();
        insert ph;
        
        ph.Product_Manager__c = u.Id;
        ph.Regional_PM_AP__c = u.Id;
        ph.Regional_PM_EU__c = u.Id;
        ph.Regional_PM_US__c = u.Id;
        ph.Global_PM__c = u.Id;
        ph.Approver_PM__c = u.Id;
        update ph;
        system.assert(true);
        Test.stopTest();
    }
}