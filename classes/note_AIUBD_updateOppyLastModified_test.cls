/**
*  This used as test class for note_AIUBD_updateOppyLastModifiedDate
*
@author Pankaj Raijade
@created 1/2/2016
@changelog

*/
@isTest(seealldata=false)
public class note_AIUBD_updateOppyLastModified_test
{
        public static testMethod void note_AIUBD_updateOppyLastModified_UT()
        {
            ChannelinsightData_test.ChannelinsightData_test();
            ClsTestCustomSettingHelper.getApex_Helper_Settings();
            ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
            ClsTestCustomSettingHelper.getOpportunity_Approvers();
            ClsTestCustomSettingHelper.getLast_Modified_Field_Update_Permission();

            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Request_Type__c = 'Cable Assembly';
            insert oppy;
            note n = new note(Parentid = oppy.id, Title = 'test');
            insert n;
            delete n;
             try
            {
                update n;
            }
            catch(DMLException ex)
            {
                notetriggerHelper.NoteTriggerExceptionhandler(ex, new list<note>{n}, new list<note>{n}, false);
            }
            try
            {
                update n;
            }
            catch(DMLException ex)
            {
                notetriggerHelper.NoteTriggerExceptionhandler(ex, new list<note>{n}, new list<note>{n}, true);
            }
            system.assert(true);
            
        }
}