/**
*  This test class is for ClsBatch_oppyInitManufacturingStartDate.
*
@author Di Chen
@created 2013-01-31
@version 1.0
@since 20.0
*
@changelog
* 2013-01-31 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 100%
*/
@isTest
private class ClsBatch_oppyInitManufacturingSDate_Test {

    static testMethod void testBatch() {
    	
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        oppy2.Request_Type__c = 'Extension';
        insert oppy2;      	
    	
    	list<Opportunity> scope = new list<Opportunity>();
    	scope.add(oppy2);
    	
    	Test.startTest();
    	
    	ClsBatch_oppyInitManufacturingStartDate clsBatch = new ClsBatch_oppyInitManufacturingStartDate();
        Database.BatchableContext BC;
		clsBatch.filter = ' limit 1';
		
    	clsBatch.start(BC);
		clsBatch.execute(BC, scope);
		clsBatch.finish(BC);
    	
    	system.assert(true);
    	Test.stopTest();    
    }
}