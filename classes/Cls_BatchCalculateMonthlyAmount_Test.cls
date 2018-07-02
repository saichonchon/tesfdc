/**
*  This test class used to Cls_BatchCalculateMonthlyAmount.
*
@author Jinbo Shan
@created 2014-11-12
@version 1.0   
@since 30.0
*
@changelog
* coverage  82%
* 
* 
2014-11-12 Jinbo Shan <jinbo.shan@itbconsult.com>
* - Created
*/
@isTest(seeAllData=true) 
private class Cls_BatchCalculateMonthlyAmount_Test {

    static testMethod void myUnitTest() {
        map<String, Integer> MAP_MONTHLABELNUMBER = new map<String, Integer>{
            'Jan' => 4, 'Feb' => 5, 'Mar' => 6, 'Apr' => 7, 'May' => 8, 'Jun' => 9,
            'Jul' => 10, 'Aug' => 11, 'Sep' => 12, 'Oct' => 1, 'Nov' => 2, 'Dec' => 3
        };
        String fiscalYear;
        Integer fiscalMonth;
        for(Period p : [select FiscalYearSettings.Name, Id, Number, PeriodLabel, QuarterLabel, Type from Period where startdate<=Today and endDate >=Today and Type = 'Month']) {
            fiscalYear = p.FiscalYearSettings.Name;
            fiscalMonth = MAP_MONTHLABELNUMBER.get(p.PeriodLabel);
        }
        Account acc = ClsTestHelp.createTestAccounts();
        insert acc;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Name = '00122333';
        insert ph;
        
        Part__c p = new Part__c();
        p.Product_Hierarchy__c = ph.Id;
        insert p;
        
        set<Id> set_lockIds = new set<Id>();
        list<BBB_Year_Bill_Book_Cust_PN__c> list_sos = new list<BBB_Year_Bill_Book_Cust_PN__c>();
        BBB_Year_Bill_Book_Cust_PN__c so = new BBB_Year_Bill_Book_Cust_PN__c();
        so.Bill_Year_to_Date_Amount_Document__c = 100;
        so.Year__c = fiscalYear;
        so.Part__c = p.Id;
        so.Customer__c = acc.Id;
        so.Billings_Month_1__c = 10;
        insert so;
        set_lockIds.add(so.Id);
        list_sos.add(so);
        
        Test.startTest();
        Cls_BatchCalculateMonthlyAmount clsBatch = new Cls_BatchCalculateMonthlyAmount();
        clsBatch.filter = 'Id = \'' + so.Id + '\''; 
        if(fiscalMonth == 2) {
            clsBatch.currentDate = system.today().addMonths(2);
        }
        clsBatch.ERROR = 'test';
        clsBatch.errorNum = 1;
        clsBatch.set_lockRecordIds = set_lockIds;
        database.executeBatch(clsBatch);
        /*Database.BatchableContext BC;
        clsBatch.currentDate = system.today();
        clsBatch.start(BC);
        clsBatch.execute(BC, list_sos);
        clsBatch.finish(BC);*/
        Test.stopTest();
    }
}