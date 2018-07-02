/**
*  This used as test class for SensitiveAttachments_AIUBD_updateOppyLastModifiedDate
*
@author Pankaj Raijade
@created 1/2/2016
@changelog

*/
@isTest(seealldata=false)
public class SensitiveAttachments_AIUBD_LastMFD_test
{
        public static testMethod void SensitiveAttachments_AIUBD_LastMFD_UT()
        {
            ChannelinsightData_test.ChannelinsightData_test();
            ClsTestCustomSettingHelper.getApex_Helper_Settings();
            ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
            ClsTestCustomSettingHelper.getOpportunity_Approvers();
            ClsTestCustomSettingHelper.getLast_Modified_Field_Update_Permission();

            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Request_Type__c = 'Cable Assembly';
            insert oppy;
            Sensitive_Attachment__c oSensitive_Attachment = new Sensitive_Attachment__c (Opportunity__c = oppy.Id);
            insert oSensitive_Attachment;
            delete oSensitive_Attachment;
        }
}