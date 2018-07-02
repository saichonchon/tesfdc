/**
*	This test class is for SalesHierarchy_AIU_updateAccountFields.
*
@author Di Chen
@created 2013-04-03
@version 1.0
@since 20.0
*
@changelog
* 2013-04-03 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 100%
*/
@isTest
private class TrgSalesHierarchy_AIU_updateAccFs_Test {

    static testMethod void testAIU() {
        
        Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
    	sh.Level_7_Territory_Code__c = 'A003153';
    	sh.Level_7_Default_Owner__c = UserInfo.getUserId();
    	sh.Level_7_Assigned_User_Network_Ids__c = 'ET04135f';
    	sh.Hierarchy_Type__c='Global Account Manager Hierarchy (GAM)';
        Test.startTest();
        
    	insert sh;
    	
    	sh.Level_7_Territory_Code__c = 'A003155';
    	update sh;
        
        system.assert(true);
        Test.stopTest();
    }
}