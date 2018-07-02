/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   Test class for EventModule.trigger
Inputs:        
Test Class:    
History
2018-02-06 	   Yiming Shen <yiming.shen@capgemini.com> Created
------------------------------------------------------------*/
@isTest
private class EventModule_Test {

    static testMethod void myUnitTest() {
		Events_Exhibitions__c ee = ClsTestHelp.createTestEventsExhibitions();
		Test.startTest();
		ee.Fiscal_Year__c = 'FY15';
		insert ee;       
		Test.stopTest();  
		List<EventModules__c> list_EventModulesAssert = new List<EventModules__c>();
		for(EventModules__c em : [SELECT Id FROM EventModules__c WHERE Events_Exhibitions__c =: ee.Id]){
			list_EventModulesAssert.add(em);
		}
		System.assert(list_EventModulesAssert.size() > 0);
    }
}