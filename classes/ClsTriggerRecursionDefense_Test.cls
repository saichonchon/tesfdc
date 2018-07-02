/**
*	This test class is for ClsTriggerRecursionDefense.
*
@author Di Chen
@created 2012-10-25
@version 1.0
@since 20.0
*
@changelog
* 2012-10-25 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 100
*/
@isTest(seeAllData=false)
private class ClsTriggerRecursionDefense_Test {

    static testMethod void myUnitTest() {
        Account testAcct1 = ClsTestHelp.createTestAccounts();
        insert testAcct1;
        //create Opportunity
        RecordType oppyRecordTypeEnergy = ClsTestHelp.createTestRecordType32();
        RecordType oppyRecordTypeNoEnergy = ClsTestHelp.createTestRecordType30();
        Opportunity oppy1 = ClsTestHelp.createTestOpportunity();
        oppy1.Name = 'TestOppy1';
        oppy1.AccountId = testAcct1.Id;
        oppy1.RecordTypeId = oppyRecordTypeEnergy.Id;
        oppy1.StageName = 'initiation';
        oppy1.Probability__c = '10';
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Name = 'TestOppy2';
        oppy2.AccountId = testAcct1.Id;
        oppy2.StageName = 'Concept';
        //oppy2.Probability__c = '10';
        oppy2.RecordTypeId = oppyRecordTypeNoEnergy.Id;
        insert new List<Opportunity>{oppy1,oppy2};
        Test.startTest();
        Boolean flag2 = ClsTriggerRecursionDefense.avoidMultipleRunningForTrigger(new Set<Id>{oppy1.Id,oppy2.Id});
        System.assert(flag2 == true);
        flag2 = ClsTriggerRecursionDefense.avoidMultipleRunningForTrigger(new Set<Id>{oppy1.Id,oppy2.Id});
        Test.stopTest();
    }
}