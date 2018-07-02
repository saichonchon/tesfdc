@isTest(seealldata=false)
private class ClsBatch_GenericForOneTimeDataAct_Test {
    static testMethod void TestGenericForOneTimeDataAct()
    {
        Test.startTest();
            Product_Hierarchy__c ph = new Product_Hierarchy__c();
            ph.Name = '00122333';
            insert ph;
            ClsBatch_GenericForOneTimeDataActivity oemMBBB = new ClsBatch_GenericForOneTimeDataActivity();
            oemMBBB.query = 'select id from Product_Hierarchy__c ';
            Database.executeBatch(oemMBBB); 
        Test.stopTest();
    }

}