/**
*   This test class is for opportunity_AU_generateEngMileStone.
*
@author Yuanyuan zhang
@created 2012-06-01
@version 1.0
@since 29.0
*
@changelog
* 2012-06-01 yuanyuan zhang <yuanyuan.zhang@itbconsult.com>
* - Created
* - Test coverage 100%
* 2016-02-19 Rajendra Shahane <rajendra.shahane@zensar.in>
* - modified
* - Test coverage 100%
*/
@isTest(seealldata=false)
private class TrgOppy_AU_generateEngMileStone_Test
{

    static testMethod void testgenerateEngMileStone()
    {
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getTrigger_Configuration();

        Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;
                
        //Id EngCSDRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('DND Opportunity').getRecordTypeId();
        Id EngChannelRecordTypeId = (Id)(Opportunity_Record_Type_Groups__c.getinstance('Channel- Engineering Opportunity_EM').RecordTypeID__c);      
        Opportunity oppy = new Opportunity(PLM_Id__c = '12345',CCAO_Manager__c = userinfo.getUserId(),Global_Product_Manager__c = userinfo.getUserId(),CloseDate = date.today().addDays(5), recordtypeid = EngChannelRecordTypeId, name = 'Opportunity Engmilestone', StageName = 'Concept', Type = 'CM', Request_Type__c = 'Extension', Method__c = 'BOM', Level__c = 'Yearly', Amount = 1, Five_Year_Revenue__c = 1, Currency_Confirm__c = true);
                
        Test.startTest();
        
        insert new List<Opportunity>{oppy};
                
        oppy.PLM_Id__c = '123456789';
        update oppy;
        
        Test.stopTest();
    }
}