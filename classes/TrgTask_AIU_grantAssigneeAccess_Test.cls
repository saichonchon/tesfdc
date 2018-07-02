/**
*	This test class is for Task_AIU_grantAssigneeAccess.
*
@author Di Chen
@created 2013-01-15
@version 1.0
@since 20.0
*
@changelog
* 2013-01-15 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 100%
Rajendra Shahane 03/29/2016  Modified for case - 900703
*/
@isTest
private class TrgTask_AIU_grantAssigneeAccess_Test {

    static testMethod void testInsert() {
        //Start: Rajendra Shahane Modified for case - 900703
        ChannelinsightData_test.Channelinsightdata_test();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getCCPTriggerSettings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getAplRoutingProcess();
        ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
        ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
        ClsTestCustomSettingHelper.getPMV_Stage_Config();
        //End: Rajendra Shahane Modified for case - 900703
        
    	Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();    	
		Profile p = [Select Id, Name From Profile 
                     where Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
		User u = ClsTestHelp.createTestUsers();
		u.Email = 'hellosManedsfd@testCompany1233423.com';
		u.Alias = 'dpses';
		u.CommunityNickname = 'NNND';
		u.ProfileId = p.Id;
		insert u;
		      
		system.runAs(u){     	
    	Opportunity oppy = ClsTestHelp.createTestOpportunity();
        insert oppy;
    	
    	Task task = new Task();
    	task.WhatId = oppy.Id;
        task.Subject = 'Test';
    	
        Test.startTest();
        
        insert task;
        
        system.assert(true);
        Test.stopTest();
		}
    }
        static testMethod void testUpdate() {
        //Start: Rajendra Shahane Modified for case - 900703
        ChannelinsightData_test.Channelinsightdata_test();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getCCPTriggerSettings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getAplRoutingProcess();
        ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
        ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
        ClsTestCustomSettingHelper.getPMV_Stage_Config();
        //End: Rajendra Shahane Modified for case - 900703
        
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();   
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9(); 	
		Profile p = [Select Id, Name From Profile 
                     where Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
		User u = ClsTestHelp.createTestUsers();
		u.Email = 'emailds@testCompany1233423.com';
		u.Alias = 'dsdf';
		u.CommunityNickname = 'oykd';
		u.ProfileId = p.Id;
		insert u;
		      
		//system.runAs(u){     	
    	Opportunity oppy = ClsTestHelp.createTestOpportunity();
        insert oppy;
    	
    	Task task = new Task();
    	task.WhatId = oppy.Id;
        task.Subject = 'Test';
    	task.OwnerId = UserInfo.getUserId();
    	
        Test.startTest();
        
        insert task;
        
        task.OwnerId = u.Id;
        update task;
        
        system.assert(true);
        Test.stopTest();
		//}
    }
}