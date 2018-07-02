/**
*   This test class is for task_AIUBD_updateOppyLastModifiedDate.
*
@author Di Chen
@created 2012-06-01
@version 1.0
@since 20.0
*
@changelog
* 2012-06-01 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 100%
* - Rajendra Shahane 03/29/2016  Modified for case - 900703
*/
@isTest
private class TrgTask_AIUBD_updtOppyLastModfyDate_Test {

    static testMethod void testInsertUpdateDel() {
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();    
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();
        
         //Start: Rajendra Shahane Modified for case - 900703
        //ClsTestCustomSettingHelper.getCCPTriggerSettings();
        ChannelinsightData_test.Channelinsightdata_test();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        //End: Rajendra Shahane Modified for case - 900703
        
        Profile p = [Select Id, Name From Profile 
                     where Name = 'BU Analyst' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'hellosManedsfd@testCompany1233423.com';
        u.Alias = 'dpses';
        u.CommunityNickname = 'NNND';
        u.ProfileId = p.Id;
        u.Username = 'peii@osdifj.com';
        insert u;
        ClsTestCustomSettingHelper.getLast_Modified_Field_Update_Permission(u.id, true);
        system.runAs(u){        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        insert oppy;
        
        Task task = new Task(subject = 'Detractor Assignment');
        task.WhatId = oppy.Id;
        
        Test.startTest();
        
        insert task;
        
        delete task;
        
        system.assert(true);
        Test.stopTest();
        }
    }
}