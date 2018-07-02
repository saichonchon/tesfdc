/**
*  This used as test class for Opportunity_Competitor_AIUBD_updateOppyLastModifiedDate
*
@author Pankaj Raijade
@created 1/2/2016
@changelog

*/
@isTest(seealldata=false)
public class Opportunity_Competitor_AIUBD_LstMFD_test
{
        public static testMethod void Opportunity_Competitor_AIUBD_LstMFD_UT()
        {
            ChannelinsightData_test.ChannelinsightData_test();
            ClsTestCustomSettingHelper.getApex_Helper_Settings();
            ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
            ClsTestCustomSettingHelper.getOpportunity_Approvers();
            ClsTestCustomSettingHelper.getLast_Modified_Field_Update_Permission();

            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Request_Type__c = 'Cable Assembly';
            insert oppy;
            Opportunity_Competitor__c oOpportunity_Competitor = new Opportunity_Competitor__c (Opportunity__c = oppy.Id);
            insert oOpportunity_Competitor;
            delete oOpportunity_Competitor;
        }
}