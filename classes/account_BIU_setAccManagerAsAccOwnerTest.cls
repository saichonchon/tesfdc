/**********************************************************************************************************************************************
*******
Name: account_BIU_setAccManagerAsAccOwnerTest
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This test class covers test coverage for account_BIU_setAccManagerAsAccOwner trigger .
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
AUTHOR              DATE       DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
Rajendra Shahane 10/12/2016    Modified version as 37 of Test Class for case 829400
***********************************************************************************************************************************************
*****/
@isTest
private class account_BIU_setAccManagerAsAccOwnerTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();
        
        RecordType rt2 = ClsTestHelp.createTestRecordType8();
        
        Consumer_Device_Opportunity_Record_Types__c cdort1 = ClsTestHelp.createTestCSD1();
        Consumer_Device_Opportunity_Record_Types__c cdort2 = ClsTestHelp.createTestCSD2();
        Consumer_Device_Opportunity_Record_Types__c cdort3 = ClsTestHelp.createTestCSD3();
        Consumer_Device_Opportunity_Record_Types__c cdort4 = ClsTestHelp.createTestCSD4();
        Consumer_Device_Opportunity_Record_Types__c cdort5 = ClsTestHelp.createTestCSD5();
        Consumer_Device_Opportunity_Record_Types__c cdort6 = ClsTestHelp.createTestCSD6();
        Consumer_Device_Opportunity_Record_Types__c cdort7 = ClsTestHelp.createTestCSD7();
        
        /* Poonam -Added custom setting to fix test failure- Start*/
        List<Trigger_Configuration__c> lstTriggerConfig = new  List<Trigger_Configuration__c>();
       
        Trigger_Configuration__c tc = new Trigger_Configuration__c(); 
        tc.Name='Avoid Duplicate PLM Id';
        tc.isRun__c=true;
        lstTriggerConfig .add(tc);
               
        Trigger_Configuration__c tc2 = new Trigger_Configuration__c(); 
        tc2.Name='DND Lead Conversion Initialization';
        tc2.isRun__c=true;
        lstTriggerConfig .add(tc2);
        
        Trigger_Configuration__c tc3 = new Trigger_Configuration__c(); 
        tc3.Name='Identify Fiscal Year';
        tc3.isRun__c=true;
        lstTriggerConfig .add(tc3);
        
        Trigger_Configuration__c tc4 = new Trigger_Configuration__c(); 
        tc4.Name='Populate Opportunity Partner';
        tc4.isRun__c=true;
        lstTriggerConfig .add(tc4);
        
        Trigger_Configuration__c tc5 = new Trigger_Configuration__c(); 
        tc5.Name='updateAccountBusinessUnit';
        tc5.isRun__c=true;
        lstTriggerConfig .add(tc5);
        
        insert lstTriggerConfig ;
        
        ADMTerritoryCode__c admTerritoryCode= new ADMTerritoryCode__c();
        admTerritoryCode.Name='ADMTerritoryCode';
        admTerritoryCode.Territory_Code__c='101485';
        insert admTerritoryCode;
        
        /*Poonam -Added custom setting to fix test failure -End*/
        
        Profile p = [Select Id, Name From Profile 
                                    where Name = 'Appliance Standard User'
                                    limit 1];
        List<User> uList = new List<User>();                            
        User uRSM = ClsTestHelp.createTestUsers();
        uRSM.Email = 'helloSand0728@testCompany1407281004.com';
        uRSM.FirstName ='Test0728';
        uRSM.LastName = 'User0728';
        uRSM.Alias = 'dpse0728';
        uRSM.CommunityNickname = 'TMD0728';
        uRSM.ProfileId = p.Id;
        uRSM.GIBU__c = 'Appliances';
        uRSM.Username = 'helloSand0728@testCompany1407281004.com';
        uList.add(uRSM);
        User uAM = ClsTestHelp.createTestUsers();
        uAM.Email = 'helloSand0728@testCompany1407281004.com';
        uAM.FirstName ='Test0728';
        uAM.LastName = 'User0728';
        uAM.Alias = 'dpse0723';
        uAM.CommunityNickname = 'TMD07281';
        uAM.ProfileId = p.Id;
        uAM.GIBU__c = 'Appliances';
        uAM.Username = 'helloSand072811@testCompany1407281004.com';
        uList.add(uAM);
        insert uList;
        
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
        sh.Level_2_Territory_Code__c = '103004';
        sh.Level_7_Default_Owner__c = uAM.Id;
        sh.Level_1_Territory_Code__c='101485';
        sh.Hierarchy_Type__c='Sales Hierarchy (AM)';
        insert sh;
        
        Account acct = ClsTestHelp.createTestAccounts();
        acct.Name = 'axx';
        acct.RecordTypeId = rt2.Id;
        acct.AccountNumber = '123456';
        acct.APL_Relay_forecast_Plan_Account__c = acct.Id;
        acct.APL_Relay_Currency__c = 'USD';
        acct.APL_Relay_Display_Name__c = 'testName';
        acct.APL_AM_forecast_Plan_Account__c = acct.Id;
        acct.APL_AM_Currency__c = 'USD';
        acct.APL_AM_Display_Name__c = 'acct';
        //acct.Account_Manager__c = uAM.Id;
        acct.Account_Manager__c = uAM.Id;
        acct.STATDESC__c = 'Active';
        acct.GAMCD__c = '1234'; 
        acct.SALES_TERRITORY_CDE__c = '123456';
        acct.Relay_Specialist_Territory_Code__c = '123456';  
        acct.Relay_Hierarchy__c = sh.Id; 
        acct.Sales_Hierarchy__c=sh.Id;
        insert acct;
        
        acct.Account_Manager__c = uRSM.Id;
        update acct;
    }
}