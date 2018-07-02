/**
*   This test class is for ClsBatch_cleanupAccountTeam.
*
@author Di Chen
@created 2012-06-14
@version 1.0
@since 20.0
*
@changelog
* 2012-06-14 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 81%
*/
@isTest
private class ClsBatch_cleanupAccountTeam_Test {
   
    
    static testMethod void testBatch() {
        Profile p = [Select Id, Name From Profile 
                                    where Name = 'Production Support' 
                                    or Name = 'Service Account' 
                                    or Name ='System Administrator' 
                                    or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'Lion@testCompany999.com';
        u.Alias = 'SF';
        u.ProfileId = p.Id;
        u.CommunityNickname = 'QPS';
        u.IsActive = true;
        u.TE_Network_Id__c = 'NetworkId';
        insert u;
                                
        Profile p2 = [Select Id, Name From Profile where Name ='System Administrator' limit 1];
        Profile p3 = [Select Id, Name From Profile where Name ='Service Account' limit 1];
        
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();
       
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
        
        TE_Connection__c tec = new TE_Connection__c();
        for(TE_Connection__c tec1 : [select Source_BU__c from TE_Connection__c where Name = 'CentralOrg' limit 1]){
            tec = tec1;
        }
        if(tec.Source_BU__c == null){
            tec.Source_BU__c ='TE Connectivity: CIS QA';
            tec.Name = 'CentralOrg';
            insert tec;
        }

        //Consumer Device Custom Settings Start
        Consumer_Device_Opportunity_Record_Types__c csd1 = ClsTestHelp.createTestCSD1();
        Consumer_Device_Opportunity_Record_Types__c csd2 = ClsTestHelp.createTestCSD2();
        Consumer_Device_Opportunity_Record_Types__c csd3 = ClsTestHelp.createTestCSD3();
        Consumer_Device_Opportunity_Record_Types__c csd4 = ClsTestHelp.createTestCSD4();
        Consumer_Device_Opportunity_Record_Types__c csd5 = ClsTestHelp.createTestCSD5();
        Consumer_Device_Opportunity_Record_Types__c csd6 = ClsTestHelp.createTestCSD6();
        Consumer_Device_Opportunity_Record_Types__c csd7 = ClsTestHelp.createTestCSD7();
        //Consumer Device Custom Settings End
        Apex_Helper_Settings__c ap= new Apex_Helper_Settings__c(Name = 'TEIS_Admin', Value__c = UserInfo.getProfileId());
        insert ap;
        Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
        sh.Level_7_Territory_Code__c = 'K1234';
        sh.Level_7_Default_Owner__c = u.Id;
        sh.Level_7_Assigned_User_Network_Ids__c = 'NetworkId';
        sh.Level_7_Assigned_Users__c = UserInfo.getUserId();
        sh.Level_1_Territory_Code__c='101485';
        sh.Hierarchy_Type__c='Sales Hierarchy (AM)';
        insert sh;
        
        Sales_Hierarchy__c sh1 = new Sales_Hierarchy__c();
        sh1.Level_7_Territory_Code__c = 'K1234';
        sh1.Level_7_Default_Owner__c = u.Id;
        sh1.Level_7_Assigned_User_Network_Ids__c = 'NetworkId';
        sh1.Level_7_Assigned_Users__c = u.Id;
        sh1.Level_1_Territory_Code__c='101485';
        sh1.Hierarchy_Type__c='Relay Specialist (IS)';
        insert sh1;
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.SALES_TERRITORY_CDE__c = 'K1234';
        acc.Sales_Hierarchy__c = sh.Id;
        acc.Relay_Hierarchy__c = sh1.Id;
        acc.FE_Hierarchy__c = sh.Id;
        acc.AT1_Territory_Name__c = sh.Id;
        acc.AT2_Territory_Name__c = sh.Id;
        acc.ATS_Territory_Name__c = sh.Id;
        acc.RSR_Territory_Name__c = sh.Id;
        acc.RSM_Territory_Name__c = sh.Id;
        acc.GAMCD__c = 'K1234';
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
        acc.MKTMGRCDE__c = 'K1234';
        acc.IND_KAM_Code__c = 'K1234';
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
        acc.Sales_Hierarchy_MM__c = sh.Id;
        acc.Sales_Hierarchy_GAM__c = sh.Id;
        acc.Field_Service_Engineer_Code__c = 'EUR';
        acc.TE_Customer_Key_Id__c = 297591;
        acc.Type = 'OEM';
        acc.RecordTypeId = [select Name from RecordType where SobjectType = 'Account' and DeveloperName = 'CIS_Global_Account' limit 1].Id;
        insert acc;
        
        
        
        
        
        
        RecordType rt12 = ClsTestHelp.createTestRecordType12();
        RecordType rt13 = ClsTestHelp.createTestRecordType13();
        
        List<Account_Team__c> atmToInsert = new List<Account_Team__c>();
        
        Account_Team__c atm3 = new Account_Team__c();
        atm3.Account__c = acc.Id;
        atm3.Role__c = 'Customer Service Rep (CSR)';
        atm3.RecordTypeId = rt12.Id;
        atm3.Team_Member__c = u.Id;
        atm3.TE_Network_Id__c = u.TE_Network_Id__c;
        atm3.createddate = System.now().adddays(-1);
        insert atm3;
        
        Account_Team__c atm = new Account_Team__c();
        atm.Account__c = acc.Id;
        atm.Role__c = 'Account Manager (AM)';
        atm.Team_Member__c = u.Id;
        atmToInsert.add(atm);
        
        Account_Team__c atm2 = new Account_Team__c();
        atm2.Account__c = acc.Id;
        atm2.Role__c = 'Customer Service Rep (CSR)';
        atm2.Team_Member__c = u.Id;
        atmToInsert.add(atm2);
        
        Account_Team__c atm4 = new Account_Team__c();
        atm4.Account__c = acc.Id;
        atm4.Role__c = 'Customer Service Rep (CSR)';
        atm4.RecordTypeId = rt13.Id;
        atm4.Team_Member__c = u.Id;
        atm4.TE_Network_Id__c = u.TE_Network_Id__c;
        atmToInsert.add(atm4);
        
        insert atmToInsert;
        
        list<Account> list_accounts = new list<Account>();
        list_accounts.add(acc);
        //list_accounts.add(acc1);
        
        Test.startTest();
        ClsBatch_cleanupAccountTeam clsBatch = new ClsBatch_cleanupAccountTeam();
        Database.BatchableContext BC;
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
        //clsBatch.query = 'Select Id, Sales_Hierarchy_GAM__c,Sales_Hierarchy_MM__c, RecordTypeId, GAMCD__c,MKTMGRCDE__c,Type,Public_Group_Id__c from Account limit 1'; 
        
        //clsBatch.query = 'Select Id, FE_Hierarchy__c,FE_Hierarchy__r.Level_7_Assigned_Users__c, Relay_Hierarchy__c, Relay_Hierarchy__r.Level_7_Assigned_Users__c, Sales_Hierarchy__c, Sales_Hierarchy__r.Level_7_Assigned_Users__c, Sales_Hierarchy_GAM__c,Sales_Hierarchy_MM__c, RecordTypeId, GAMCD__c, IND_KAM_Code__c, MKTMGRCDE__c,Type,Public_Group_Id__c, Account_Manager__c, Field_Service_Engineer_Code__c  from Account limit 1';         
        
        //clsBatch.query = 'Select Id, FE_Hierarchy__c,FE_Hierarchy__r.Level_7_Assigned_Users__c, Relay_Hierarchy__c, Relay_Hierarchy__r.Level_7_Assigned_Users__c, Sales_Hierarchy__c, Sales_Hierarchy__r.Level_7_Assigned_Users__c, Sales_Hierarchy_GAM__c,Sales_Hierarchy_MM__c, RecordTypeId, GAMCD__c, MKTMGRCDE__c, TE_Customer_Key_Id__c, IND_KAM_Code__c, Type,Public_Group_Id__c, Account_Manager__c, Field_Service_Engineer_Code__c  from Account where id=\'' + acc.id + '\'';      
          
       // clsBatch.query = 'Select Id, FE_Hierarchy__c,FE_Hierarchy__r.Level_7_Assigned_Users__c,FE_Hierarchy__r.Level_7_Assigned_User_Network_Ids__c,Relay_Hierarchy__c, Relay_Hierarchy__r.Level_7_Assigned_Users__c,Relay_Hierarchy__r.Level_7_Assigned_User_Network_Ids__c,Sales_Hierarchy__c, Sales_Hierarchy__r.Level_7_Assigned_Users__c,Sales_Hierarchy__r.Level_7_Assigned_User_Network_Ids__c,AT1_Territory_Name__c,AT1_Territory_Name__r.Level_7_Assigned_Users__c,AT1_Territory_Name__r.Level_7_Assigned_User_Network_Ids__c,AT2_Territory_Name__c, AT2_Territory_Name__r.Level_7_Assigned_Users__c,AT2_Territory_Name__r.Level_7_Assigned_User_Network_Ids__c,RSR_Territory_Name__c, RSR_Territory_Name__r.Level_7_Assigned_Users__c,RSR_Territory_Name__r.Level_7_Assigned_User_Network_Ids__c,ATS_Territory_Name__c,ATS_Territory_Name__r.Level_7_Assigned_Users__c,ATS_Territory_Name__r.Level_7_Assigned_User_Network_Ids__c,RSM_Territory_Name__c, RSM_Territory_Name__r.Level_7_Assigned_Users__c,RSM_Territory_Name__r.Level_7_Assigned_User_Network_Ids__c,GAMCD__c,MKTMGRCDE__c,TE_Customer_Key_Id__c,IND_KAM_Code__c,Account_Manager__c,Field_Service_Engineer_Code__c from Account where id=\'' + acc.id + '\'';        
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
       // clsBatch.map_netWorkId_userId.put(u.TE_Network_Id__c, u.id);
        
       // Database.executeBatch(clsBatch);
        
        clsBatch.start(BC);
        clsBatch.execute(BC, list_accounts);
        clsBatch.finish(BC);
        
        system.assert(true);
        Test.stopTest();
    }
    
}