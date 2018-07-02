/**
*	This test class is for Account_BIU_setSalesHierarchy.
*
@author Di Chen
@created 2013-04-03
@version 1.0
@since 20.0
*
@changelog
* 2013-04-03 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage  100%
*/
@isTest
private class TrgAccount_BIU_setSalesHierarchy_Test {

    static testMethod void testCondition1() {
		RecordType rt2 = ClsTestHelp.createTestRecordType();
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.Name = 'axx';
    	acc.RecordTypeId = rt2.Id;
    	acc.Customer_Classification__c = 'A';
    	acc.Type = 'Global Account';
    	acc.GAMCD__c = '1000';
    	
        Test.startTest();
        
    	insert acc;    	        
    	
		acc.Type = 'Grouped B';
		//****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//		
		acc.MKTMGRCDE__c = '123';
		acc.IND_KAM_Code__c = '123';
		//****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//		
		update acc;      
		
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testCondition2() {
		RecordType rt2 = ClsTestHelp.createTestRecordType();
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.Name = 'axx';
    	acc.RecordTypeId = rt2.Id;
    	acc.Customer_Classification__c = 'A';
    	acc.Type = 'Grouped B';
    	//****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//		
    	acc.MKTMGRCDE__c = '123';
    	acc.IND_KAM_Code__c = '123';
    	//****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//		
    	
        Test.startTest();
        
    	insert acc;    	        
    	
    	acc.Type = 'Global Account';
    	acc.GAMCD__c = '1000';
		update acc;      
		
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void testCondition3() {
		RecordType rt2 = ClsTestHelp.createTestRecordType8();
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.Name = 'axx';
    	acc.RecordTypeId = rt2.Id;
    	acc.Customer_Classification__c = 'A';
    	acc.Type = 'Grouped B';
    	//****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//		
    	acc.MKTMGRCDE__c = '123';
    	acc.IND_KAM_Code__c = '123';
    	//****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//		
    	acc.GAMCD__c = '1000';
    	
        Test.startTest();
        
    	insert acc;    	        
		
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void testCondition4() {
		RecordType rt2 = ClsTestHelp.createTestRecordType();
		RecordType rt3 = ClsTestHelp.createTestRecordType8();
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.Name = 'axx';
    	acc.RecordTypeId = rt2.Id;
    	acc.Customer_Classification__c = 'A';
    	acc.Type = 'Grouped B';
    	//****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//		
    	acc.MKTMGRCDE__c = '123';
    	acc.IND_KAM_Code__c = '123';
    	//****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//		
    	acc.GAMCD__c = '1000';
    	
        Test.startTest();
        
    	insert acc;    	        
    	
    	acc.RecordTypeId = rt3.Id;
    	update acc;
		
        system.assert(true);
        Test.stopTest();
    }
}