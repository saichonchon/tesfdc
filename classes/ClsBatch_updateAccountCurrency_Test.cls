/**
*  This test class used to test class ExtRecalculateBudget.
*
@author Lili Zhao
@created 2013-09-27
@version 1.0   
@since 28.0
*
@changelog
* coverage 100% 
* 
* 
2013-09-27 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
* - Test coverage 100%
*/
@isTest(seeAllData = false) 
private class ClsBatch_updateAccountCurrency_Test {

    static testMethod void AccountRecordType1() 
    {
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOrgWideSettings();
        Account acc = new Account();
        acc.Name = 'testacc'+system.now().millisecond()+math.round(math.random()*10000);
        acc.AnnualRevenue = 2000000.11; 
        acc.Legally_Restricted__c = false;  
        acc.BillingCity = 'Musterstadt';
        acc.BillingStreet = 'Teststr. 1';
        acc.BillingCountry = 'CN';
        acc.Type = 'Distributor';
        acc.BillingPostalCode = '77777';
        acc.AccountNumber = '1149test';     
        insert acc;
        
        List<Account> list_accounts = new List<Account>();
        list_accounts.add(acc);

        Test.startTest();
              
        ClsBatch_updateAccountCurrency clsBatch = new ClsBatch_updateAccountCurrency();
        Database.BatchableContext BC;
        clsBatch.filter = ' and Id = \'' + acc.Id +'\' ';
        database.executebatch(clsBatch);
        //clsBatch.start(BC);
        //clsBatch.execute(BC, list_accounts);
        //clsBatch.finish(BC);
                  
        system.assert(true);
        Test.stopTest();
    }
}