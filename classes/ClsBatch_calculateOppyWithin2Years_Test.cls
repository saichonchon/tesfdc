/**
*  This test class used to test class ClsBatch_calculateOppyWithin2Years.
*
@author Jinbo Shan
@created 2014-06-25
@version 1.0   
@since 29.0
*
@changelog
* coverage  86%
* 
* 
2014-06-25 Jinbo Shan <weihang.li@itbconsult.com>
* - Created
*/
@isTest(SeeAllData = false)
private class ClsBatch_calculateOppyWithin2Years_Test 
{

    static testMethod void myUnitTest() 
    {
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        
        Oppy_Created_Config__c occ = new Oppy_Created_Config__c();
        occ.Name = 'test';
        occ.Default_Value__c = true;
        occ.Months__c = 24;
        insert occ;
        
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Type = 'CM';
            oppy.Created_Within_2_Years__c = false;
            insert oppy;
        test.startTest();
            
            ClsBatch_calculateOppyWithin2Years cls = new ClsBatch_calculateOppyWithin2Years();
            cls.filter = ' and Id = \'' + oppy.Id + '\'';
            database.executeBatch(cls);
        test.stopTest();
        
    }
}