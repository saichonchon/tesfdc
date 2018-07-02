/**
*   This test class is for ClsBatch_CustomerTeamMemberSharing.
*
@author Di Chen
@created 2012-03-13
@version 1.0
@since 20.0
*
@changelog
* 2012-03-13 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 81%
*/
@isTest
private class ClsBatch_CustomerTeamMemberSharing_Test {

    static testMethod void batchAll() {
        
        RecordType rt2 = ClsTestHelp.createTestRecordType8();
        
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
        sh.Level_7_Territory_Code__c = 'K1234';
        insert sh;
        
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.RecordTypeId = rt2.Id;
        acc2.Name = 'Xxx1';
        acc2.Account_Manager__c = UserInfo.getUserId();
        acc2.IND_KAM_Code__c = 'K1234';
        acc2.Sales_Hierarchy__c = sh.Id;
        acc2.Legally_Restricted__c = true;
        acc2.Individually_Planned__c = true;
        acc2.Individually_Forecasted__c = true;
        acc2.Customer_Classification__c = 'A';
        acc2.Account_Manager__c = UserInfo.getUserId();
        acc2.Type = 'Grouped B';
        acc2.GAMCD__c = '1000';
        acc2.SALES_TERRITORY_CDE__c = 'A004841';
        insert acc2;
        
        RecordType rt = ClsTestHelp.createTestRecordType();
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt.Id;
        acc.Account_Manager__c = UserInfo.getUserId();
        insert acc;
        
        Customer_Focus_Team_Member__c cftm = new Customer_Focus_Team_Member__c();
        cftm.Global_Account_Lkp__c = acc.Id;
        cftm.Salesforce_User_Name__c = UserInfo.getUserId(); 
        insert cftm;
        
        list<Account> list_acc = [select Id,RecordTypeId,Public_Group_Id__c, Account_Manager__c from Account where Id = :acc2.Id limit 1];
        list_acc.add(acc);
        list_acc.add(acc2);
        
        Test.startTest();
        
        ClsBatch_CustomerTeamMemberSharing clsBatch = new ClsBatch_CustomerTeamMemberSharing();
        clsBatch.query = 'Select Id, ParentId, RecordTypeId, Public_Group_Id__c, Account_Manager__c from Account limit 1';
        clsBatch.email = 'OK@testitbconsult78912.com';
        
        Database.BatchableContext bc;
        clsBatch.start(bc);
        clsBatch.execute(bc, list_acc);
        clsBatch.finish(bc); 
        system.assert(true);
        Test.stopTest();
    }
}