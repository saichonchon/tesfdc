/**
*  This test class is for Opportunity_BU_checkCrossBU.
*
@author Di Chen
@created 2013-01-28
@version 1.0
@since 20.0
*
@changelog
* 2013-01-28 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage  
*/
@isTest
private class TrgOpportunity_BU_checkCrossBU_Test {

    static testMethod void testBU() {
        if(!Last_Modified_Field_Update_Permission__c.getInstance().Allow_Update__c)
            ClsTestCustomSettingHelper.getLast_Modified_Field_Update_Permission();
        Account acc = ClsTestHelp.createTestAccounts();
        insert acc;

        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.Name = 'New Name';
        insert acc2;
         
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Program_level_Forecasting__c =true; 
        oppy.Name = 'Pain of Queen';
        oppy.Type = 'CM';
        oppy.AccountId = acc.Id;
        insert oppy;
        
        Test.startTest();
        
        oppy.AccountId = acc2.Id;
        update oppy;
        
        system.assert(true);
        Test.stopTest();
    }
}