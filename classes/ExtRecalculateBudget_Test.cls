/**
*  This test class used to test class ExtRecalculateBudget.
*
@author Xia Tong
@created 2012-07-11
@version 1.0
@since 24.0
*
@changelog
* coverage 100% 
* 
* 
2012-07-11 Xia Tong <xia.tong@itbconsult.com>
* - Created
*/
@isTest
private class ExtRecalculateBudget_Test {

    static testMethod void testRecalculateBudget() {
       test.startTest();
       Budget_Rate__c br = new Budget_Rate__c();
       br.CurrencyIsoCode = 'USD';
       Date d = system.today(); 
       br.Effective_Date__c = d;
       br.Expiration_Date__c = d.addDays(30);
       br.OwnerId = UserInfo.getUserId();
       insert br;
       ApexPages.StandardController stdCtl = new ApexPages.StandardController(br);
       ExtRecalculateBudget ext = new ExtRecalculateBudget(stdCtl);
       ext.runBatchJob();
       
       test.stopTest();
    }
}