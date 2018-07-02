/**
*  This used as test class for event_AIUBD_updateOppyLastModifiedDate
*
@author Pankaj Raijade
@created 1/2/2016
@changelog

*/
@isTest(seealldata=false)
public class event_AIUBD_updateOppyLastModifld_test
{
        public static testMethod void event_AIUBD_updateOppyLastModifld_UT()
        {
            ChannelinsightData_test.ChannelinsightData_test();
            ClsTestCustomSettingHelper.getApex_Helper_Settings();
            ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
            ClsTestCustomSettingHelper.getOpportunity_Approvers();
            ClsTestCustomSettingHelper.getLast_Modified_Field_Update_Permission();

            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Request_Type__c = 'Cable Assembly';
            insert oppy;
            event e = new event(WhatId = oppy.id, DurationInMinutes = 30, ActivityDateTime = datetime.now());
            insert e;
            delete e;
            
        }
}