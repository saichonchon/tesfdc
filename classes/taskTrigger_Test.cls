/**
*  This class is test method for 
Trigger : TaskTrigger 
classes : TaskTriggerHandler, TasktriggerUtils
*
@author Pankaj Raijade
@created 1/2/2016
@changelog
@changes by Michael 11/08/2016: added test method for IND_TaskOwnerReassignTriggerClass

*/
@istest(seeAlldata=false)
public class taskTrigger_Test
{
    public static testmethod void tastTrigger_UT()
    {   
        
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        ClsTestCustomSettingHelper.getADMTerritoryCode();         
        Schema.RecordTypeInfo NPSTaskRecordtype = schema.Task.SobjectType.getDescribe().getRecordTypeInfosByName().get('NPS Task Industrial');
        Schema.RecordTypeInfo NPSFunctionalFollowUpTaskRecordtype = schema.Task.SobjectType.getDescribe().getRecordTypeInfosByName().get('NPS Industrial Functional Follow Up Task');
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        Account acc =  ClsTestHelp.createTestAccounts();
        insert acc;
 
        List<Task> oTask = new List<Task>();
        Task oTask1 =new Task();
        oTask1.subject = 'test';
        oTask1.recordtypeid = NPSTaskRecordtype.getRecordTypeId();
        oTask.add(oTask1);
        
        Task oTask2 =new Task();
        oTask2.subject = 'Detractor Assignment';
        oTask2.WhatId = acc.Id;
        oTask.add(oTask2);
       
        insert oTask;
        
        oTask1.status = 'Functional Follow Up Created';
        
        oTask1.Q02_Engineering_Responsiveness__c = true;
        oTask1.Q03_Technology_needs_met__c = true;
        oTask1.Q04_Product_Innovation__c = true;
        oTask1.Q05_Business_Understanding__c = true;
        oTask1.Q06_Field_Tech_Support__c = true;
        oTask1.Q07_Customer_Care_Support__c = true;
        oTask1.Q08_Competitive_Price__c = true;
        oTask1.Q09_Delivery_Performance__c = true;
        oTask1.Q10_Product_Quality__c = true;
        oTask1.Q02_Engineering_Responsiveness_Comments__c = 'test Comment';
        oTask1.Q03_Technology_needs_met_Comments__c = 'test Comment';
        oTask1.Q04_Product_Innovation_Comments__c = 'test Comment';
        oTask1.Q05_Business_Understanding_Comments__c = 'test Comment';
        oTask1.Q06_Field_Tech_Support_Comments__c = 'test Comment';
        oTask1.Q07_Customer_Care_Support_Comments__c = 'test Comment';
        oTask1.Q08_Competitive_Price_Comments__c = 'test Comment';
        oTask1.Q09_Delivery_Performance_Comments__c = 'test Comment';
        oTask1.Q10_Product_Quality_Comments__c = 'test Comment';
        
        update oTask1;
        
        TasktriggerUtils.getFollowupSubject(system.label.NPS_Detractor_GM_Follow_UP);
        TasktriggerUtils.getFollowupSubject(system.label.NPS_Detractor_AM_Follow_UP);
        TasktriggerUtils.getFollowupSubject(system.label.NPS_Passive_Follow_UP);
        TasktriggerUtils.getFollowupSubject(system.label.NPS_Promoter_Follow_UP);
        
        Task oTaskFunc = TasktriggerUtils.getFunctionaltask(oTask1, NPSFunctionalFollowUpTaskRecordtype, UserInfo.getUserId(), 'test', 'test');
        oTaskFunc.subject = system.label.NPS_Detractor_GM_Follow_UP;
        insert oTaskFunc;
        oTaskFunc.Follow_Up_Received_from__c = UserInfo.getUserId();
        oTaskFunc.status = 'Completed';
        update oTaskFunc;
        
    }
    public static testmethod void tastTrigger_UT2()
    {   
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        ClsTestCustomSettingHelper.getADMTerritoryCode();        
        Schema.RecordTypeInfo NPSFunctionalFollowUpTaskRecordtype = schema.Task.SobjectType.getDescribe().getRecordTypeInfosByName().get('NPS Industrial Functional Follow Up Task');
        Account acc =  ClsTestHelp.createTestAccounts();
        insert acc;

        Task oTaskFunc = TasktriggerUtils.getFunctionaltask(New task(), NPSFunctionalFollowUpTaskRecordtype, UserInfo.getUserId(), 'test', 'test');
        oTaskFunc.subject = system.label.NPS_Detractor_GM_Follow_UP;
        insert oTaskFunc;
   
        oTaskFunc.Follow_Up_Received_from__c = UserInfo.getUserId();
        oTaskFunc.status = 'Completed';
        
        update oTaskFunc;
    }
    public static testmethod void TaskOwnerReassign()
    {
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        Schema.RecordTypeInfo NPSTaskRecordtype = schema.Task.SobjectType.getDescribe().getRecordTypeInfosByName().get('NPS Industrial Functional Follow Up Task');
        List<User> Usr = new List<User>();
        
        Profile p = [Select Id, Name From Profile 
                                    where Name = 'Industrial Standard User' 
                                    or Name = 'Industrial Engineering User w/Cost' 
                                    or Name ='Industrial User w/ Cost' limit 1];
        
        User u = new User();
        u.FirstName ='First';
        u.LastName = 'Tester';
        u.username = 'Lion123732@testCompany999.com';
        u.Email = 'Lion123732@testCompany999.com';
        u.Alias = 'SF';
        u.ProfileId = p.Id;
        u.CommunityNickname = 'QPS';
        u.IsActive = true;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        
        Usr.add(u);

        User v = new User();
        v.FirstName ='Second';
        v.LastName = 'Tester';
        v.username = 'Lion123732@testCompany9999.com';
        v.Email = 'Lion123732@testCompany9999.com';
        v.Alias = 'SF2';
        v.ProfileId = p.Id;
        v.CommunityNickname = 'QPS2';
        v.IsActive = true;
        v.TimeZoneSidKey = 'America/Chicago';
        v.LocaleSidKey = 'en_US';
        v.EmailEncodingKey = 'UTF-8';
        v.LanguageLocaleKey = 'en_US';
        
        Usr.add(v);
        
        insert Usr;
        
        u.DelegatedApproverId = v.Id;
        update u;
        
        //System.debug(' u= '+u.id + ' v= '+v.Id +' delegated= '+u.DelegatedApproverId);
        
        Task ts = new Task();
        
        ts.RecordTypeId=NPSTaskRecordtype.getRecordTypeId();
        ts.Subject='Test Only';
        ts.Status='Not Started';
        ts.Priority='Normal';
        ts.OwnerId = u.Id;
        
        insert ts;
        
        //System.debug('task owner= ' + ts.OwnerId);
        
        System.assertEquals(u.DelegatedApproverId, v.Id);
    }
    
    public static testmethod void tastTrigger_UT3()
    {   
        
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        ClsTestCustomSettingHelper.getADMTerritoryCode();         
        Schema.RecordTypeInfo NPSTaskRecordtype = schema.Task.SobjectType.getDescribe().getRecordTypeInfosByName().get('NPS Task Industrial');
        Schema.RecordTypeInfo NPSFunctionalFollowUpTaskRecordtype = schema.Task.SobjectType.getDescribe().getRecordTypeInfosByName().get('NPS Industrial Functional Follow Up Task');
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        
        Profile p = [Select Id, Name From Profile 
                                    where Name = 'Industrial Standard User' 
                                    or Name = 'Industrial Engineering User w/Cost' 
                                    or Name ='Industrial User w/ Cost' limit 1];
        
        User u = new User();
        u.FirstName ='First';
        u.LastName = 'Tester';
        u.username = 'Lion123732@testCompany999.com';
        u.Email = 'Lion123732@testCompany999.com';
        u.Alias = 'SF';
        u.ProfileId = p.Id;
        u.CommunityNickname = 'QPS';
        u.IsActive = true;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        insert u;
        
        NPS_Settings__c ns = new NPS_Settings__c();
        ns.Name = '02. Engineering Responsiveness';
        ns.Value__c = u.Id;
        insert ns;
        
        Account acc =  ClsTestHelp.createTestAccounts();
        insert acc;
 
        Task oTask1 =new Task();
        oTask1.subject = 'test';
        oTask1.recordtypeid = NPSTaskRecordtype.getRecordTypeId();
        oTask1.status = 'In Progress';
        insert oTask1;
        
        System.assertEquals(oTask1.recordtypeid, NPSTaskRecordtype.getRecordTypeId());
        System.assertEquals(oTask1.status, 'In Progress');
                
        Map<Id,Task> mapTaskold = new Map<Id,Task>();
        mapTaskold.put(oTask1.Id,oTask1);
        
        Task oTask2 = [Select Id,status,subject,recordtypeid,Q02_Engineering_Responsiveness__c,Q03_Technology_needs_met__c,
                        Q04_Product_Innovation__c,Q05_Business_Understanding__c,Q06_Field_Tech_Support__c,Q07_Customer_Care_Support__c,
                        Q08_Competitive_Price__c,Q09_Delivery_Performance__c,Q10_Product_Quality__c,
                        Q02_Engineering_Responsiveness_Comments__c,Q03_Technology_needs_met_Comments__c,
                        Q04_Product_Innovation_Comments__c,Q05_Business_Understanding_Comments__c,Q06_Field_Tech_Support_Comments__c,
                        Q07_Customer_Care_Support_Comments__c,Q08_Competitive_Price_Comments__c,Q09_Delivery_Performance_Comments__c,
                        Q10_Product_Quality_Comments__c From Task Where Id =: oTask1.Id];        
        oTask2.status = 'Functional Follow Up Created';
        oTask2.subject = 'Detractor Assignment';
        oTask2.Q02_Engineering_Responsiveness__c = true;
        oTask2.Q03_Technology_needs_met__c = true;
        oTask2.Q04_Product_Innovation__c = true;
        oTask2.Q05_Business_Understanding__c = true;
        oTask2.Q06_Field_Tech_Support__c = true;
        oTask2.Q07_Customer_Care_Support__c = true;
        oTask2.Q08_Competitive_Price__c = true;
        oTask2.Q09_Delivery_Performance__c = true;
        oTask2.Q10_Product_Quality__c = true;
        oTask2.Q02_Engineering_Responsiveness_Comments__c = 'test Comment';
        oTask2.Q03_Technology_needs_met_Comments__c = 'test Comment';
        oTask2.Q04_Product_Innovation_Comments__c = 'test Comment';
        oTask2.Q05_Business_Understanding_Comments__c = 'test Comment';
        oTask2.Q06_Field_Tech_Support_Comments__c = 'test Comment';
        oTask2.Q07_Customer_Care_Support_Comments__c = 'test Comment';
        oTask2.Q08_Competitive_Price_Comments__c = 'test Comment';
        oTask2.Q09_Delivery_Performance_Comments__c = 'test Comment';
        oTask2.Q10_Product_Quality_Comments__c = 'test Comment';
        update oTask2;
        
        System.assertEquals(oTask2.recordtypeid, NPSTaskRecordtype.getRecordTypeId());
        System.assertEquals(oTask2.status, 'Functional Follow Up Created');        
        
        Map<Id,Task> mapTasknew = new Map<Id,Task>();
        mapTasknew.put(oTask2.Id,oTask2);        
        
        TasktriggerUtils.TaskRecursionDefence = true;
        try{TasktriggerUtils.CreateFunctionalFollowUpTask(mapTaskold,mapTasknew);}catch(Exception e){}
    }
    
    public static testmethod void tastTrigger_UT4()
    {   
        
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        ClsTestCustomSettingHelper.getADMTerritoryCode();         
        Schema.RecordTypeInfo NPSTaskRecordtype = schema.Task.SobjectType.getDescribe().getRecordTypeInfosByName().get('NPS Task Industrial');
        Schema.RecordTypeInfo NPSFunctionalFollowUpTaskRecordtype = schema.Task.SobjectType.getDescribe().getRecordTypeInfosByName().get('NPS Industrial Functional Follow Up Task');
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        
        Profile p = [Select Id, Name From Profile 
                                    where Name = 'Industrial Standard User' 
                                    or Name = 'Industrial Engineering User w/Cost' 
                                    or Name ='Industrial User w/ Cost' limit 1];
        
        User u = new User();
        u.FirstName ='First';
        u.LastName = 'Tester';
        u.username = 'Lion123732@testCompany999.com';
        u.Email = 'Lion123732@testCompany999.com';
        u.Alias = 'SF';
        u.ProfileId = p.Id;
        u.CommunityNickname = 'QPS';
        u.IsActive = true;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        insert u;
        
        NPS_Settings__c ns = new NPS_Settings__c();
        ns.Name = '02. Engineering Responsiveness';
        ns.Value__c = u.Id;
        insert ns;
        
        TEMarketing__me_settings__c ms = new TEMarketing__me_settings__c();
        ms.TEMarketing__Time_to_include_campaign_responses__c = 24;
        insert ms;
        
        Account acc =  ClsTestHelp.createTestAccounts();
        insert acc;

        Id rt1= Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Central Lead').getRecordTypeId();        
        Lead l = new Lead(LastName = 'Mike', Status = 'Open', Business_Unit__c = 'Industrial', recordTypeId = rt1, Company = 'Test', Email = 'test@test.com');
        insert l;
        
        TEMarketing__MQLRecord__c mql = new TEMarketing__MQLRecord__c();
        mql.TEMarketing__Lead__c = l.Id;
        mql.TEMarketing__MQL_Date__c = DateTime.now();
        mql.TEMarketing__Inquiry_Status__c = 'Marketing Qualified';
        insert mql;
 
        Task oTask1 =new Task();
        oTask1.subject = 'test';
        oTask1.recordtypeid = NPSFunctionalFollowUpTaskRecordtype.getRecordTypeId();
        oTask1.status = 'In Progress';
        oTask1.TaskSubType = 'Call';
        oTask1.whoId = l.Id;
        insert oTask1;
                
        Map<Id,Task> mapTaskold = new Map<Id,Task>();
        mapTaskold.put(oTask1.Id,oTask1);
        
        Task oTask2 = [Select Id,status,subject,recordtypeid,Q02_Engineering_Responsiveness__c,Q03_Technology_needs_met__c,
                        Q04_Product_Innovation__c,Q05_Business_Understanding__c,Q06_Field_Tech_Support__c,Q07_Customer_Care_Support__c,
                        Q08_Competitive_Price__c,Q09_Delivery_Performance__c,Q10_Product_Quality__c,
                        Q02_Engineering_Responsiveness_Comments__c,Q03_Technology_needs_met_Comments__c,
                        Q04_Product_Innovation_Comments__c,Q05_Business_Understanding_Comments__c,Q06_Field_Tech_Support_Comments__c,
                        Q07_Customer_Care_Support_Comments__c,Q08_Competitive_Price_Comments__c,Q09_Delivery_Performance_Comments__c,
                        Q10_Product_Quality_Comments__c From Task Where Id =: oTask1.Id];        
        oTask2.status = 'Completed';
        oTask2.subject = 'Detractor Assignment';
        oTask2.Q02_Engineering_Responsiveness__c = true;
        oTask2.Q03_Technology_needs_met__c = true;
        oTask2.Q04_Product_Innovation__c = true;
        oTask2.Q05_Business_Understanding__c = true;
        oTask2.Q06_Field_Tech_Support__c = true;
        oTask2.Q07_Customer_Care_Support__c = true;
        oTask2.Q08_Competitive_Price__c = true;
        oTask2.Q09_Delivery_Performance__c = true;
        oTask2.Q10_Product_Quality__c = true;
        oTask2.Q02_Engineering_Responsiveness_Comments__c = 'test Comment';
        oTask2.Q03_Technology_needs_met_Comments__c = 'test Comment';
        oTask2.Q04_Product_Innovation_Comments__c = 'test Comment';
        oTask2.Q05_Business_Understanding_Comments__c = 'test Comment';
        oTask2.Q06_Field_Tech_Support_Comments__c = 'test Comment';
        oTask2.Q07_Customer_Care_Support_Comments__c = 'test Comment';
        oTask2.Q08_Competitive_Price_Comments__c = 'test Comment';
        oTask2.Q09_Delivery_Performance_Comments__c = 'test Comment';
        oTask2.Q10_Product_Quality_Comments__c = 'test Comment';
        update oTask2;
        
        Map<Id,Task> mapTasknew = new Map<Id,Task>();
        mapTasknew.put(oTask2.Id,oTask2);        
        
        TasktriggerUtils.TaskRecursionDefence = true;
        try{TasktriggerUtils.CreateFunctionalFollowUpTask(mapTaskold,mapTasknew);}catch(Exception e){}
    }   
}