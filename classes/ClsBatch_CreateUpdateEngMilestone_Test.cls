/**
*   This test class is for ClsBatch_CreateUpdateEngMilestone.
*
@author Rajendra Shahane
@created 2012-06-01
@version 1.0
@since 29.0
*
@changelog
* 2016-02-19 Rajendra Shahane <rajendra.shahane@zensar.in>
* - Created
* - Test coverage 98%
*/
@isTest(seealldata=false)
private class ClsBatch_CreateUpdateEngMilestone_Test
{
    static testMethod void testClsBatch_CreateUpdateEngMilestone()
    {
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        //Id EngCSDRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('DND Opportunity').getRecordTypeId();
        Id EngChannelRecordTypeId = (Id)(Opportunity_Record_Type_Groups__c.getinstance('Channel- Engineering Opportunity_EM').RecordTypeID__c);
        Opportunity oppy = new Opportunity(PLM_Id__c = '12345',CCAO_Manager__c = userinfo.getUserId(),Global_Product_Manager__c = userinfo.getUserId(),CloseDate = date.today().addDays(5), recordtypeid = EngChannelRecordTypeId , name = 'Opportunity Engmilestone', StageName = 'Concept', Type = 'CM', Request_Type__c = 'Extension', Method__c = 'BOM', Level__c = 'Yearly', Amount = 1, Five_Year_Revenue__c = 1, Currency_Confirm__c = true);
        Opportunity oppy1 = new Opportunity(PLM_Id__c = '123456',CCAO_Manager__c = userinfo.getUserId(),Global_Product_Manager__c = userinfo.getUserId(),CloseDate = date.today().addDays(5), recordtypeid = EngChannelRecordTypeId , name = 'Opportunity Engmilestone1', StageName = 'Concept', Type = 'CM', Request_Type__c = 'Extension', Method__c = 'BOM', Level__c = 'Yearly', Amount = 1, Five_Year_Revenue__c = 1, Currency_Confirm__c = true);
        Test.startTest();
        
        insert new List<Opportunity>{oppy,oppy1};
        List<Engineering_Milestone__c> list_engMileStones2Update = new List<Engineering_Milestone__c>();
        List<Engineering_Milestone__c> list_engMileStones2delete = new List<Engineering_Milestone__c>();
        List<Engineering_Milestone__c> list_engMileStones = [select Id,external_Id__c,Opportunity__c from Engineering_Milestone__c where Opportunity__c=:oppy.id or Opportunity__c=:oppy1.id];
        if(list_engMileStones!= null && list_engMileStones.size()> 0)
        {
            for(Engineering_Milestone__c EngineeringMilestone : list_engMileStones)
            {
                if(EngineeringMilestone.Opportunity__c == oppy.id)
                    list_engMileStones2delete.add(EngineeringMilestone);
                else
                {
                    EngineeringMilestone.external_Id__c = null;
                    list_engMileStones2Update.add(EngineeringMilestone);
                }
                    
            }
        }
        if(list_engMileStones2delete.size() > 0)
            delete list_engMileStones2delete;
        if(list_engMileStones2Update.size() > 0)
            update list_engMileStones2Update;
        
        ClsBatch_CreateUpdateEngMilestone objBatch = new ClsBatch_CreateUpdateEngMilestone();
        Database.executeBatch(objBatch);
        
        Test.stopTest();
    }
}