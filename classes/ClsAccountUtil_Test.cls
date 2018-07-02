/**
*   This test class is for ClsAccountUtil.
*
@author Di Chen
@created 2012-03-13
@version 1.0
@since 20.0
*
@changelog
* 2012-03-13 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 88%
*/
@isTest
private class ClsAccountUtil_Test {

    static testMethod void testMostMethods() {
        
        RecordType rt = ClsTestHelp.createTestRecordType2();
        
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
        insert sh;
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Account_Manager__c = UserInfo.getUserId();
        acc.SALES_TERRITORY_CDE__c = 'A003154';
        acc.Sales_Hierarchy__c = sh.Id;
        acc.Legally_Restricted__c = true;
        acc.Individually_Planned__c = false;
        insert acc;
        
        acc.Individually_Planned__c = true;
        update acc;
        
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.Account_Manager__c = UserInfo.getUserId();
        acc2.SALES_TERRITORY_CDE__c = 'A003154';
        acc2.Sales_Hierarchy__c = sh.Id;
        acc2.Legally_Restricted__c = false;
        acc2.Individually_Planned__c = false;
        insert acc2;
        
        acc2.Individually_Planned__c = true;
        update acc2; 
        
        Test.startTest();
        
        map<Id, Id> map_accId_accManager = new map<Id, Id>();
        map_accId_accManager.put(acc.Id,UserInfo.getUserId());
        
        map<Id, String> map_accId_accSalesTerritoryCDE = new map<Id, String>();
        map_accId_accSalesTerritoryCDE.put(acc.Id,'A003154');
        
        map<Id, Id> map_accId_salesHierarchyId = new map<Id, Id>();
        map_accId_salesHierarchyId.put(acc.Id,sh.Id);
        
        list<Account> list_accounts = new list<Account>();
        list_accounts.add(acc);
        ClsAccountUtil.SetAccManagerAsAccOwner(map_accId_accManager, map_accId_accSalesTerritoryCDE, map_accId_salesHierarchyId, list_accounts);        
        //ClsAccountUtil.updateAccountField(list_accounts); // add lili 2013.11.27  // add lili 2013.12.04
        list<Account> list_NewAccounts = new list<Account>();
        list_NewAccounts.add(acc2);   
        //AccountUtil.cascadeUnrestriction(list_NewAccounts, list_accounts);
        
        system.assert(true);
        Test.stopTest();
    }
    // add lili begin
    static testMethod void testMostMethods2() {
        Account account = ClsTestHelp.createTestAccounts();
        account.AccountNumber = '1149test';     
        insert account;
        
        list<Account> list_accounts = new list<Account>();
        list_accounts.add(account);
        Test.startTest();
        ClsAccountUtil.setAccountCurrencyIsoCode(list_accounts); // add lili
        ClsAccountUtil.setAccountCurrencyIsoCodeBatch(list_accounts); // add lili
        //ClsAccountUtil.updateAccountField(list_accounts); // add lili 2013.11.27  // add lili 2013.12.04
        Test.stopTest();            
    }
    // add lili end
}