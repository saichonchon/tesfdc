/***********************************************************************************************************************
      Name : Cls_Update_opp_Regional_PM_test
       Org : C2S
 Copyright : © 2013 TE Connectivity 
========================================================================================================================
   Summary : Code Coverage clss for "Cls_Update_opp_Regional_PM" class
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE        DETAIL               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Ravi    11/11/2013  Initial Development         R-1316
     1.1 Rajendra Shahane 04/11/2016  Modified for case - 900786
***********************************************************************************************************************/

@istest
(seealldata=false)
public class Cls_Update_opp_Regional_PM_test{
      static testMethod void Regional_pm_update()
      {
          //Start : Rajendra Shahane 04/11/2016  Modified for case - 900786
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings(); 
        Opportunity_Approvers__c oa = ClsTestHelp.createTestOpportunityApprovers();        
        Opportunity_Approvers__c oa2 = ClsTestHelp.createTestOpportunityApprovers2();        
        Opportunity_Approvers__c oa3 = ClsTestHelp.createTestOpportunityApprovers3();
        Opportunity_Approvers__c oa4 = ClsTestHelp.createTestOpportunityApprovers4();        
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9(); 
        Apex_Helper_Settings__c ahs10 = ClsTestHelp.createTestName10();
        Apex_Helper_Settings__c ahs11 = ClsTestHelp.createTestName11(); 
        Apex_Helper_Settings__c newSetting = new Apex_Helper_Settings__c (name = 'APL_Email_Alert_Template',value__c = 'https://c2s.my.salesforce.com/servlet/servlet.ImageServer?;id=015E0000000P3MB;id=015E0000001hKDe;&oid=00DE0000000Hkve;https://c2s.my.salesforce.com/');
        Apex_Helper_Settings__c exceptUser= new Apex_Helper_Settings__c();
        exceptUser.name = 'Currency Confirm Except Users';
        exceptUser.value__c = 'test';
        exceptUser.Active__c = true;
        //insert exceptUser;
        Apex_Helper_Settings__c csdGPL= new Apex_Helper_Settings__c();
        csdGPL.name = 'CSD GPL Code Id';
        csdGPL.value__c = 'test';
        csdGPL.Active__c = true;
        //insert csdGPL;
        Apex_Helper_Settings__c aplRecord = new Apex_Helper_Settings__c();
        aplRecord.name = 'Appliance Opportunity Record Type Id';
        aplRecord.value__c = 'test';
        aplRecord.Active__c = true;
        insert new List<Apex_Helper_Settings__c> {aplRecord,csdGPL,exceptUser,newSetting};
                                                    
        TE_Connection__c tec = ClsTestHelp.createTestTEConnection();
        Profit_BU_Center_Mapping_Rule1__c pb1 = ClsTestHelp.createTestProfitBUCenterMapping1();
        Profit_BU_Center_Mapping_Rule2__c pb2 = ClsTestHelp.createTestProfitBUCenterMapping2();
        Profit_BU_Center_Mapping_Rule3__c pb3 = ClsTestHelp.createTestProfitBUCenterMapping3();
        Consumer_Device_Opportunity_Record_Types__c csd1 = ClsTestHelp.createTestCSD1();
        Consumer_Device_Opportunity_Record_Types__c csd2 = ClsTestHelp.createTestCSD2();
        Consumer_Device_Opportunity_Record_Types__c csd3 = ClsTestHelp.createTestCSD3();
        Consumer_Device_Opportunity_Record_Types__c csd4 = ClsTestHelp.createTestCSD4();
        Consumer_Device_Opportunity_Record_Types__c csd5 = ClsTestHelp.createTestCSD5();
        Consumer_Device_Opportunity_Record_Types__c csd6 = ClsTestHelp.createTestCSD6();
        Consumer_Device_Opportunity_Record_Types__c csd7 = ClsTestHelp.createTestCSD7();
          
     Profile p = [Select Id, Name From Profile 
     where Name = 'System Administrator'];
     User u = ClsTestHelp.createTestUsers();
     u.Email = 'test11112233@test555Company.com';
     u.username = 'test115551233@test555Company.com';
     u.Alias = 'abc';
     u.CommunityNickname = 'TsMD';
     u.ProfileId = p.Id;
     u.Region__c = 'Asia Pacific';
     insert u;
       
        RecordType rt2 = ClsTestHelp.createTestRecordType16();
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        //oppy.Program__c = oppy2.Id;   
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.StageName = 'New';
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Currency_confirm__c = true;
        oppy.Five_Year_Revenue__c = 1;
        oppy.RecordTypeId = rt2.Id; 
        //oppy.Mass_prod_Status__c = true;
        insert oppy;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.name = 'Test Zensar';
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        ph.Regional_PM_AP__c=u.id;
        insert ph;
        
        list<Opportunity_Part__c> partList = new list<Opportunity_Part__c>();
        
        //Opportunity_Part__c oppypart1 = new Opportunity_Part__c();
        Opportunity_Part__c oppypart1 = ClsTestHelp.createTestOpportunityPart();
        oppypart1.Cable_Assembly_Type__c = 'Fiber Optic';
        oppypart1.Opportunity__C=oppy.id;
        oppypart1.Gpl__C=ph.id;
        partList.add(oppypart1);
         
        //Opportunity_Part__c oppypart2 = new Opportunity_Part__c();
        Opportunity_Part__c oppypart2 = ClsTestHelp.createTestOpportunityPart();
        oppypart2.Cable_Assembly_Type__c = 'Fiber Optic';
        oppypart2.Opportunity__C=oppy.id;
        oppypart2.Gpl__C=ph.id;
        partList.add(oppypart2);
        insert partList;
        //End : Rajendra Shahane 04/11/2016  Modified for case - 900786
        list<Opportunity_Part__c> partList_del = new list<Opportunity_Part__c>();
       
        Opportunity_Part__c oppypart_del1 = new Opportunity_Part__c();
        oppypart_del1.Cable_Assembly_Type__c = 'Fiber Optic';
        oppypart_del1.Opportunity__C=oppy.id;
        oppypart_del1.Gpl__C=ph.id;
        partList_del .add(oppypart_del1);
        
        Opportunity_Part__c oppypart_del2= new Opportunity_Part__c();
        oppypart_del2.Cable_Assembly_Type__c = 'Fiber Optic';
        oppypart_del2.Opportunity__C=oppy.id;
        oppypart_del2.Gpl__C=ph.id;
        partList_del.add(oppypart_del2);
 
        insert partList_del;
        
         delete oppypart_del2;
        
    test.starttest();
     Cls_Update_opp_Regional_PM.Update_Regional_pm(partList);
     Cls_Update_opp_Regional_PM.Update_Regional_pm_del(partList_del);
    test.stoptest();
    
     
}
}