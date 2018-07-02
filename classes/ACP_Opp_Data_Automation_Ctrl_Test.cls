/*****************************************************************************************************************************************
Name: ACP_Opp_Data_Automation_Ctrl_Test
Copyright © 2017 TE Connectivity
==========================================================================================================================================
Requirement:
Test class for ACP_Opportunity_Data_Automation_Ctrl
Comments: Please populate custom setting ACP_User_BU__c with the below values.
(Name - UserBU = ACP_ADM - AD&M, ACP_Appliances - Appliances, ACP_Channel - Channel, ACP_DND - Data & Devices, ACP_Industrial - Industrial, ACP_Medical - Medical)
==========================================================================================================================================
Purpose:
Test class to cover the ACP_Opportunity_Data_Automation_Ctrl code
==========================================================================================================================================
History
-------
VERSION     AUTHOR                       DATE                              DETAIL
1.0         Haripriya Maturi           8/10/2017                       Created this test class for code coverage of ACP_Opportunity_Data_Automation_Ctrl
2.0         Haripriya Maturi           11/3/2017                       Updated Header Comments
3.0         Haripriya Maturi           11/27/2017                      Written test method for Channel BU
******************************************************************************************************************************************/
@isTest(SeeAllData = true)
Private Class ACP_Opp_Data_Automation_Ctrl_Test {

   private static testMethod void DataAutomation_TestMethod1() {
      User thisUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
      Profile p;
      User u;

      System.runAs(thisUser) {
         ACP_User_BU__c adm_setting = new ACP_User_BU__c();
         adm_setting.Name = 'ACP_ADM_test';
         adm_setting.UserBU__c = 'AD&M';
         insert adm_setting;

         p = [select id from Profile where Name = 'Standard User'];
         u = new User(alias = 'standt', email = 'standarduser@testorg.com', emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US',
            localesidkey = 'en_US',
            profileid = p.Id,
            timezonesidkey = 'America/Los_Angeles',
            GIBU__c = adm_setting.UserBU__c,
            username = 'acpuser17122017@example1.com');

         insert u;
      }

      Test.startTest();

      String reportName_PL4Q = 'ACP_ADM';
      String reportName_Conv = 'ACP_ADM_Conversion';
      String reportName_Lost = 'ACP_ADM_L12MLost';
      String reportName_Won = 'ACP_ADM_L12MWon';
      String reportName_CY = 'ACP_ADM_CY_Pipeline';
      String reportName_NY = 'ACP_ADM_NY_Pipeline';
      String reportName_5Y = 'ACP_ADM_5Y_Pipeline';

      Map < String, ACP_User_BU__c > userBUs = ACP_User_BU__c.getAll();

      Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Grouped Accounts').getRecordTypeId();

      Account account = new Account(
         Name = 'TestAccount1PlanAccount1089',
         GAMCD__c = 'G0007',
         RecordTypeId = recType,
         IND_KAM_Code__c = '');
      Insert account;
      system.debug('ac creat' + account);
      // Create Account Plan
      ACP_Account_Plan__c newAccPlan = new ACP_Account_Plan__c(
         Name = 'TestAccount1Plan3564',
         ACP_Account_Name__c = account.Id,
         Account_Plan_Type__c = 'GAM Account',
         ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3564');
      insert(newAccPlan);


      List < ACP_Opportunity_TAM_Revenue__c > OppTAM = ACP_TestDataFactory.createOppTamRevenue(newAccPlan.id, 'CBC3 - 30033 - Tubing Materials');
      insert OppTam;
      Report report1 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_PL4Q');
      Report report2 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_Conv');
      Report report3 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_Lost');
      Report report4 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_Won');
      Report report5 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_CY');
      Report report6 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_NY');
      Report report7 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_5Y');

      List < ACP_Oppty_TAM_Report__c > oppTAMRepList = new List < ACP_Oppty_TAM_Report__c > ();
      system.debug(' report list ' + opptamreplist);
      System.debug('userBUs.get(ACP_ADM_test).UserBU__c ==' + userBUs.get('ACP_ADM_test').UserBU__c);
      Id recType2 = Schema.SObjectType.ACP_Oppty_TAM_Report__c.getRecordTypeInfosByName().get(userBUs.get('ACP_ADM_test').UserBU__c).getRecordTypeId();
      System.Debug('recType2 == ' + recType2);
      ACP_Oppty_TAM_Report__c oppTAMReport = new ACP_Oppty_TAM_Report__c(
         recordtypeid = recType2,
         ACP_Pipeline__c = (String) report1.Id,
         ACP_Conversion__c = (String) report2.Id,
         ACP_L12_Lost__c = (String) report3.Id,
         ACP_L12_Won__c = (String) report4.Id,
         ACP_CY_Pipeline__c = (String) report5.Id,
         ACP_NY_Pipeline__c = (String) report6.Id,
         ACP_X5Y_Pipeline__c = (String) report7.Id,
         ACP_PL4Q_Won_Date__c = 'THIS FISCAL YEAR',
         ACP_PL4Q_Confidence__c = 'Won',
         ACP_PL4Q_Date__c = 'NEXT 4 FISCAL QUARTERS',
         ACP_Conv_Won_Date__c = 'THIS FISCAL YEAR',
         ACP_Conv_Confidence__c = 'Won',
         ACP_Lost_Lost_Date__c = '10/18/2017',
         ACP_Won_Won_Date__c = '10/18/2017',
         ACP_CYPL_Won_Date__c = '10/18/2017',
         ACP_CYPL_Date__c = 'THIS FISCAL YEAR',
         ACP_NYPL_Won_Date__c = '10/18/2017',
         ACP_NYPL_Confidence__c = 'Won',
         ACP_NYPL_Date__c = 'THIS FISCAL YEAR',
         ACP_5YPL_Won_Date__c = '10/18/2017',
         ACP_5YPL_Date__c = 'THIS FISCAL YEAR',
         ACP_PL4Q_aplActivePL__c = false,
         ACP_CYPL_aplActivePL__c = false,
         ACP_NYPL_aplActivePL__c = false,
         ACP_5YPL_aplActivePL__c = false,
         ACP_Conv_Date__c = 'THIS FISCAL YEAR',
         ACP_Lost_Confidence__c = 'Lost',
         ACP_Lost_Date__c = 'THIS FISCAL YEAR',
         ACP_Won_Confidence__c = 'Won',
         ACP_Won_Date__c = 'THIS FISCAL YEAR',
         ACP_PL4Q_Phase__c = 'Discussion;Design;Test',
         ACP_Conv_Phase__c = 'Discussion;Design;Test',
         ACP_CYPL_Phase__c = 'Discussion;Design;Test',
         ACP_NYPL_Phase__c = 'Discussion;Design;Test',
         ACP_5YPL_Phase__c = 'Discussion;Design;Test',
         ACP_PL4Q_Opp_Record_Type__c = 'ADM',
         ACP_Conv_Opp_Record_Type__c = 'ADM',
         ACP_Lost_Opp_Record_Type__c = 'ADM',
         ACP_Won_Opp_Record_Type__c = 'ADM',
         ACP_CYPL_Opp_Record_Type__c = 'ADM',
         ACP_NYPL_Opp_Record_Type__c = 'ADM',
         ACP_5YPL_Opp_Record_Type__c = 'ADM'
      );
      system.debug('record ---- ' + oppTAMReport);
      oppTAMRepList.add(oppTAMReport);

      Insert oppTAMRepList;
      system.debug('opp tam list --- ' + oppTAMRepList);

      Apexpages.currentPage().getParameters().put('acpid', newAccPlan.id);
      ACP_Opportunity_Data_Automation_Ctrl obj = new ACP_Opportunity_Data_Automation_Ctrl(new ApexPages.StandardController(newAccPlan));
      string acpid = newAccPlan.Id;
      obj.userBU = u.GIBU__c;
      obj.oppTamRevRecordId = OppTam[0].id;
      obj.updateRecords();
      obj.reloadThePage();
      Test.stopTest();
   }

   private static testMethod void DataAutomation_TestMethod2() {
      User thisUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
      Profile p;
      User u;

      System.runAs(thisUser) {
         ACP_User_BU__c med_setting = new ACP_User_BU__c();
         med_setting.Name = 'ACP_Medical_test';
         med_setting.UserBU__c = 'Medical';
         insert med_setting;
         p = [select id from Profile where Name = 'Standard User'];
         u = new User(alias = 'standt', email = 'standarduser@testorg.com', emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US',
            localesidkey = 'en_US',
            profileid = p.Id,
            timezonesidkey = 'America/Los_Angeles',
            GIBU__c = med_setting.UserBU__c,
            MED_Region__c = 'India',
            username = 'acpuser17122017@example2.com');

         insert u;
      }


      Test.startTest();

      Map < String, ACP_User_BU__c > userBUs = ACP_User_BU__c.getAll();

      String reportName_PL4Q = 'ACP_MED_Pipeline_4Q_Rolling';
      String reportName_Conv = 'ACP_MED_YTD_Conversion';
      String reportName_Lost = 'ACP_MED_L12MLost';
      String reportName_Won = 'ACP_MED_L12MWon';
      String reportName_CY = 'ACP_MED_CY_Pipeline';
      String reportName_NY = 'ACP_MED_NY_Pipeline';
      String reportName_5Y = 'ACP_MED_5Y_Pipeline';

      Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Grouped Accounts').getRecordTypeId();

      Account account = new Account(
         Name = 'TestAccount1PlanAccount10893',
         GAMCD__c = '',
         RecordTypeId = recType,
         IND_KAM_Code__c = 'K0007');
      Insert account;
      system.debug('ac creat' + account);
      // Create Account Plan
      ACP_Account_Plan__c newAccPlan = new ACP_Account_Plan__c(
         Name = 'TestAccount1Plan3564',
         ACP_Account_Name__c = account.Id,
         Account_Plan_Type__c = 'KAM Account',
         ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3564');
      insert(newAccPlan);


      List < ACP_Opportunity_TAM_Revenue__c > OppTAM = ACP_TestDataFactory.createOppTamRevenue(newAccPlan.id, 'CBC3 - 30033 - Tubing Materials');
      insert OppTam;
      Report report1 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_PL4Q');
      Report report2 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_Conv');
      Report report3 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_Lost');
      Report report4 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_Won');
      Report report5 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_CY');
      Report report6 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_NY');
      Report report7 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_5Y');
      List < ACP_Oppty_TAM_Report__c > oppTAMRepList = new List < ACP_Oppty_TAM_Report__c > ();
      system.debug(' report list ' + opptamreplist);
      Id recType2 = Schema.SObjectType.ACP_Oppty_TAM_Report__c.getRecordTypeInfosByName().get(userBUs.get('ACP_Medical_test').UserBU__c).getRecordTypeId();
      ACP_Oppty_TAM_Report__c oppTAMReport = new ACP_Oppty_TAM_Report__c(
         recordtypeid = recType2,
         ACP_Pipeline__c = (String) report1.Id,
         ACP_Conversion__c = (String) report2.Id,
         ACP_L12_Lost__c = (String) report3.Id,
         ACP_L12_Won__c = (String) report4.Id,
         ACP_CY_Pipeline__c = (String) report5.Id,
         ACP_NY_Pipeline__c = (String) report6.Id,
         ACP_X5Y_Pipeline__c = (String) report7.Id,
         ACP_PL4Q_Type__c = 'Transfer existing Business;Defend existing Business',
         ACP_PL4Q_Days_since_last_user_update__c = 60.0,
         ACP_PL4Q_Won_Date__c = 'THIS FISCAL YEAR',
         ACP_PL4Q_Confidence__c = 'Weak;50/50;Likely;Commit',
         ACP_PL4Q_Date__c = 'NEXT 4 FISCAL QUARTERS',
         ACP_PL4Q_Opp_Group__c = 'Engineering;Sales;NDR',
         ACP_Conv_Won_Date__c = 'THIS FISCAL YEAR',
         ACP_PL4Q_Process_Status__c = 'Pre-prod',
         ACP_Lost_Lost_Date__c = 'LAST 12 MONTHS',
         ACP_Won_Won_Date__c = 'LAST 12 MONTHS',
         ACP_CYPL_Won_Date__c = 'THIS FISCAL YEAR',
         ACP_CYPL_Date__c = 'THIS FISCAL YEAR',
         ACP_NYPL_Date__c = 'NEXT FISCAL YEAR',
         ACP_5YPL_Date__c = 'NEXT 5 FISCAL YEARS',
         ACP_PL4Q_Confidence2__c = 'Won',
         ACP_PL4Q_aplActivePL__c = false,
         ACP_CYPL_aplActivePL__c = false,
         ACP_NYPL_aplActivePL__c = false,
         ACP_5YPL_aplActivePL__c = false,
         ACP_Conv_Date__c = 'THIS FISCAL YEAR',
         ACP_Lost_Date__c = 'THIS FISCAL YEAR',
         ACP_Won_Date__c = 'THIS FISCAL YEAR',
         ACP_PL4Q_MEDOppStatus__c = 'P3 - In Quoting Opportunity;QR - Quote Released;AC - Active Project;CM - Complete',
         ACP_Conv_MEDOppStatus__c = 'P3 - In Quoting Opportunity;QR - Quote Released;AC - Active Project;CM - Complete',
         ACP_CYPL_MEDOppStatus__c = 'P3 - In Quoting Opportunity;QR - Quote Released;AC - Active Project;CM - Complete',
         ACP_PL4Q_MED_Portfolio__c = 'CREG',
         ACP_Conv_MED_Portfolio__c = 'CREG',
         ACP_Lost_MED_Portfolio__c = 'CREG',
         ACP_Won_MED_Portfolio__c = 'CREG',
         ACP_CYPL_MED_Portfolio__c = 'CREG',
         ACP_NYPL_MED_Portfolio__c = 'CREG',
         ACP_5YPL_MED_Portfolio__c = 'CREG'

      );
      oppTAMRepList.add(oppTAMReport);

      Insert oppTAMRepList;

      Apexpages.currentPage().getParameters().put('acpid', newAccPlan.id);
      ACP_Opportunity_Data_Automation_Ctrl obj = new ACP_Opportunity_Data_Automation_Ctrl(new ApexPages.StandardController(newAccPlan));
      string acpid = newAccPlan.Id;
      obj.userBU = u.GIBU__c;
      obj.oppTamRevRecordId = OppTam[0].id;
      obj.updateRecords();
      obj.reloadThePage();
      Test.stopTest();
   }

   private static testMethod void DataAutomation_TestMethod3() {
      User thisUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
      Profile p;
      User u;
      System.runAs(thisUser) {
         ACP_User_BU__c apl_setting = new ACP_User_BU__c();
         apl_setting.Name = 'ACP_Appliances_test';
         apl_setting.UserBU__c = 'Appliances';
         insert apl_setting;

         p = [select id from Profile where Name = 'Standard User'];
         u = new User(alias = 'standt', email = 'standarduser@testorg.com', emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US',
            localesidkey = 'en_US',
            profileid = p.Id,
            timezonesidkey = 'America/Los_Angeles',
            GIBU__c = apl_setting.UserBU__c,
            MED_Region__c = 'India',
            username = 'acpuser17122017@example3.com');

         insert u;
      }

      Test.startTest();

      Map < String, ACP_User_BU__c > userBUs = ACP_User_BU__c.getAll();

      String reportName_PL4Q = 'ACP_APL_Pipeline_4Q_Rolling';
      String reportName_Conv = 'ACP_APL_Conversion';
      String reportName_Lost = 'ACP_APL_L12MLost';
      String reportName_Won = 'ACP_APL_L12MWon';
      String reportName_CY = 'ACP_APL_CY_Pipeline';
      String reportName_NY = 'ACP_APL_NY_Pipeline';
      String reportName_5Y = 'ACP_APL_5Y_Pipeline';

      Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Grouped Accounts').getRecordTypeId();

      Account account = new Account(
         Name = 'TestAccount1PlanAccount10894',
         GAMCD__c = '',
         RecordTypeId = recType,
         WWCORPACCT__c = 'WW001',
         IND_KAM_Code__c = '');
      Insert account;
      system.debug('ac creat' + account);
      // Create Account Plan
      ACP_Account_Plan__c newAccPlan = new ACP_Account_Plan__c(
         Name = 'TestAccount1Plan3564',
         ACP_Account_Name__c = account.Id,
         Account_Plan_Type__c = 'WW Account',
         ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3564');
      insert(newAccPlan);


      List < ACP_Opportunity_TAM_Revenue__c > OppTAM = ACP_TestDataFactory.createOppTamRevenue(newAccPlan.id, 'CBC3 - 30033 - Tubing Materials');
      insert OppTam;
      Report report1 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_PL4Q');
      Report report2 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_Conv');
      Report report3 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_Lost');
      Report report4 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_Won');
      Report report5 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_CY');
      Report report6 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_NY');
      Report report7 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_5Y');
      List < ACP_Oppty_TAM_Report__c > oppTAMRepList = new List < ACP_Oppty_TAM_Report__c > ();
      system.debug(' report list ' + opptamreplist);
      Id recType2 = Schema.SObjectType.ACP_Oppty_TAM_Report__c.getRecordTypeInfosByName().get(userBUs.get('ACP_Appliances_test').UserBU__c).getRecordTypeId();
      ACP_Oppty_TAM_Report__c oppTAMReport = new ACP_Oppty_TAM_Report__c(
         recordtypeid = recType2,
         ACP_Pipeline__c = (String) report1.Id,
         ACP_Conversion__c = (String) report2.Id,
         ACP_L12_Lost__c = (String) report3.Id,
         ACP_L12_Won__c = (String) report4.Id,
         ACP_CY_Pipeline__c = (String) report5.Id,
         ACP_NY_Pipeline__c = (String) report6.Id,
         ACP_X5Y_Pipeline__c = (String) report7.Id,
         ACP_CYPL_Confidence2__c = 'Won',
         ACP_PL4Q_Type__c = 'Transfer existing Business;Defend existing Business',
         ACP_PL4Q_Days_since_last_user_update__c = 60.0,
         ACP_PL4Q_Won_Date__c = 'THIS FISCAL YEAR',
         ACP_PL4Q_Confidence__c = 'Weak;50/50;Likely;Commit',
         ACP_PL4Q_Date__c = 'NEXT 4 FISCAL QUARTERS',
         ACP_PL4Q_Opp_Group__c = 'Engineering;Sales;NDR',
         ACP_Conv_Type__c = 'Transfer existing Business;Defend existing Business',
         ACP_Conv_Won_Date__c = 'THIS FISCAL YEAR',
         ACP_Conv_Confidence__c = 'Won',
         ACP_Conv_Opp_Group__c = 'Engineering;Sales;NDR',
         ACP_PL4Q_Process_Status__c = 'Pre-prod',
         ACP_Conv_Process_Status__c = 'Production',
         ACP_Lost_Opp_Group__c = 'Engineering;Sales;NDR',
         ACP_Lost_Phase__c = 'Lost;Dead;Lost - Closed;Dead - Closed;Lost/Dead - Closed',
         ACP_Lost_Lost_Date__c = 'LAST 12 MONTHS',
         ACP_Won_Opp_Group__c = 'Engineering;Sales;NDR',
         ACP_Won_Phase__c = 'Won - Open;Won - Closed;Won/Qualified;Won/Qualified/G3 Approved;Order Received or Mass Production;Won;Production',
         ACP_Won_Won_Date__c = 'LAST 12 MONTHS',
         ACP_CYPL_Process_Status__c = 'Pre-prod;Production;Ramp-down;EOL',
         ACP_CYPL_Days_since_last_user_update__c = 55.0,
         ACP_CYPL_Won_Date__c = 'THIS FISCAL YEAR',
         ACP_CYPL_Confidence__c = 'Won;Weak;50/50;Likely;Commit',
         ACP_CYPL_Date__c = 'THIS FISCAL YEAR',
         ACP_CYPL_Opp_Group__c = 'Engineering;Sales;NDR',
         ACP_NYPL_Process_Status__c = 'Pre-prod;Production;Ramp-down;EOL',
         ACP_NYPL_Days_since_last_user_update__c = 60.0,
         ACP_NYPL_Won_Date__c = 'THIS FISCAL YEAR',
         ACP_NYPL_Confidence__c = 'Won;Weak;50/50',
         ACP_NYPL_Date__c = 'NEXT FISCAL YEAR',
         ACP_NYPL_Opp_Group__c = 'Engineering;Sales;NDR',
         ACP_5YPL_Process_Status__c = 'Pre-prod;Production;Ramp-down;EOL',
         ACP_5YPL_Type__c = 'Transfer existing Business;Defend existing Business',
         ACP_5YPL_Days_since_last_user_update__c = 55.0,
         ACP_5YPL_Won_Date__c = 'THIS FISCAL YEAR',
         ACP_5YPL_Confidence__c = 'Won;Weak;50/50;Likely;Commit',
         ACP_5YPL_Date__c = 'NEXT 5 FISCAL YEARS',
         ACP_5YPL_Opp_Group__c = 'Engineering;Sales;NDR',
         ACP_PL4Q_Confidence2__c = 'Won',
         ACP_NYPL_Confidence2__c = 'Won',
         ACP_5YPL_Confidence2__c = 'Won',
         ACP_PL4Q_aplActivePL__c = true,
         ACP_CYPL_aplActivePL__c = true,
         ACP_NYPL_aplActivePL__c = true,
         ACP_5YPL_aplActivePL__c = true,
         ACP_Conv_Date__c = 'THIS FISCAL YEAR',
         ACP_Lost_Confidence__c = 'Dead;Lost',
         ACP_Lost_Date__c = 'NEXT 4 FISCAL QUARTERS',
         ACP_Won_Confidence__c = 'Won',
         ACP_Won_Date__c = 'NEXT 4 FISCAL QUARTERS',
         ACP_Won_Process_Status__c = 'Production'
      );
      oppTAMRepList.add(oppTAMReport);

      Insert oppTAMRepList;

      Apexpages.currentPage().getParameters().put('acpid', newAccPlan.id);
      ACP_Opportunity_Data_Automation_Ctrl obj = new ACP_Opportunity_Data_Automation_Ctrl(new ApexPages.StandardController(newAccPlan));
      string acpid = newAccPlan.Id;
      obj.userBU = u.GIBU__c;
      obj.oppTamRevRecordId = OppTam[0].id;
      obj.updateRecords();
      obj.reloadThePage();
      Test.stopTest();
   }

   private static testMethod void DataAutomation_TestMethod4() {System.Debug('INDUSTRIAL !!');
      User thisUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
      Profile p;
      User u;
      System.runAs(thisUser) {
         ACP_User_BU__c ind_setting = new ACP_User_BU__c();
         ind_setting.Name = 'ACP_Industrial_test';
         ind_setting.UserBU__c = 'Industrial';
         insert ind_setting;

         p = [select id from Profile where Name = 'Standard User'];
         u = new User(alias = 'standt', email = 'standarduser@testorg.com', emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US',
            localesidkey = 'en_US',
            profileid = p.Id,
            timezonesidkey = 'America/Los_Angeles',
            GIBU__c = ind_setting.UserBU__c,
            MED_Region__c = 'India',
            username = 'acpuser17122017@example4.com');

         insert u;
      }
      Test.startTest();

      Map < String, ACP_User_BU__c > userBUs = ACP_User_BU__c.getAll();

      String reportName_PL4Q = 'ACP_IND_Pipeline_4Q_Rolling';
      String reportName_Conv = 'ACP_IND_Conversion';
      String reportName_Lost = 'ACP_IND_L12MLost';
      String reportName_Won = 'ACP_IND_L12MWon';
      String reportName_CY = 'ACP_IND_CY_Pipeline';
      String reportName_NY = 'ACP_IND_NY_Pipeline';
      String reportName_5Y = 'ACP_IND_5Y_Pipeline';

      Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Grouped Accounts').getRecordTypeId();

      Account account = new Account(
         Name = 'TestAccount1PlanAccount10895',
         GAMCD__c = '',
         RecordTypeId = recType,
         IND_KAM_Code__c = '');
      Insert account;

      // Create Account Plan
      ACP_Account_Plan__c newAccPlan = new ACP_Account_Plan__c(
         Name = 'TestAccount1Plan3564',
         ACP_Account_Name__c = account.Id,
         Account_Plan_Type__c = 'Sold-to Account',
         ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3564');
      insert(newAccPlan);


      List < ACP_Opportunity_TAM_Revenue__c > OppTAM = ACP_TestDataFactory.createOppTamRevenue(newAccPlan.id, 'CBC3 - 30033 - Tubing Materials');
      insert OppTam;
      Report report1 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_PL4Q');
      Report report2 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_Conv');
      Report report3 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_Lost');
      Report report4 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_Won');
      Report report5 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_CY');
      Report report6 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_NY');
      Report report7 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_5Y');
      List < ACP_Oppty_TAM_Report__c > oppTAMRepList = new List < ACP_Oppty_TAM_Report__c > ();
      system.debug(' report list ' + opptamreplist);
      Id recType2 = Schema.SObjectType.ACP_Oppty_TAM_Report__c.getRecordTypeInfosByName().get(userBUs.get('ACP_Industrial_test').UserBU__c).getRecordTypeId();
      ACP_Oppty_TAM_Report__c oppTAMReport = new ACP_Oppty_TAM_Report__c(
         recordtypeid = recType2,
         ACP_Pipeline__c = (String) report1.Id,
         ACP_Conversion__c = (String) report2.Id,
         ACP_L12_Lost__c = (String) report3.Id,
         ACP_L12_Won__c = (String) report4.Id,
         ACP_CY_Pipeline__c = (String) report5.Id,
         ACP_NY_Pipeline__c = (String) report6.Id,
         ACP_X5Y_Pipeline__c = (String) report7.Id,
         ACP_CYPL_Confidence2__c = 'Won',
         ACP_PL4Q_Type__c = 'Transfer existing Business;Defend existing Business',
         ACP_PL4Q_Days_since_last_user_update__c = 60.0,
         ACP_PL4Q_Won_Date__c = 'THIS FISCAL YEAR',
         ACP_PL4Q_Confidence__c = 'Weak;50/50;Likely;Commit',
         ACP_PL4Q_Date__c = 'NEXT 4 FISCAL QUARTERS',
         ACP_PL4Q_Opp_Group__c = 'Engineering;Sales;NDR',
         ACP_Conv_Type__c = 'Transfer existing Business;Defend existing Business',
         ACP_Conv_Won_Date__c = 'THIS FISCAL YEAR',
         ACP_Conv_Confidence__c = 'Won',
         ACP_Conv_Opp_Group__c = 'Engineering;Sales;NDR',
         ACP_PL4Q_Process_Status__c = 'Pre-prod',
         ACP_Conv_Process_Status__c = 'Production;Ramp-down;EOL',
         ACP_Lost_Opp_Group__c = 'Engineering;Sales;NDR',
         ACP_Lost_Phase__c = 'Lost;Dead;Lost - Closed;Dead - Closed;Lost/Dead - Closed',
         ACP_Lost_Lost_Date__c = 'LAST 365 DAYS',
         ACP_Won_Opp_Group__c = 'Engineering;Sales;NDR',
         ACP_Won_Phase__c = 'Won - Open;Won - Closed;Won/Qualified;Won/Qualified/G3 Approved;Order Received or Mass Production;Won;Production',
         ACP_Won_Won_Date__c = 'LAST 365 DAYS',
         ACP_CYPL_Process_Status__c = 'Pre-prod',
         ACP_CYPL_Type__c = 'Transfer existing Business;Defend existing Business',
         ACP_CYPL_Days_since_last_user_update__c = 60.0,
         ACP_CYPL_Won_Date__c = 'THIS FISCAL YEAR',
         ACP_CYPL_Confidence__c = 'Weak;50/50;Likely;Commit',
         ACP_CYPL_Date__c = 'THIS FISCAL YEAR',
         ACP_CYPL_Opp_Group__c = 'Engineering;Sales;NDR',
         ACP_NYPL_Process_Status__c = 'Pre-prod',
         ACP_NYPL_Type__c = 'Transfer existing Business;Defend existing Business',
         ACP_NYPL_Days_since_last_user_update__c = 60.0,
         ACP_NYPL_Won_Date__c = 'THIS FISCAL YEAR',
         ACP_NYPL_Confidence__c = 'Weak;50/50;Likely;Commit',
         ACP_NYPL_Date__c = 'NEXT FISCAL YEAR',
         ACP_NYPL_Opp_Group__c = 'Engineering;Sales;NDR',
         ACP_5YPL_Process_Status__c = 'Pre-prod',
         ACP_5YPL_Type__c = 'Transfer existing Business;Defend existing Business',
         ACP_5YPL_Days_since_last_user_update__c = 60.0,
         ACP_5YPL_Won_Date__c = 'THIS FISCAL YEAR',
         ACP_5YPL_Confidence__c = 'Weak;50/50;Likely;Commit',
         ACP_5YPL_Date__c = 'THIS FISCAL YEAR',
         ACP_5YPL_Opp_Group__c = 'Engineering;Sales;NDR',
         ACP_PL4Q_Confidence2__c = 'Won',
         ACP_NYPL_Confidence2__c = 'Won',
         ACP_5YPL_Confidence2__c = 'Won',
         ACP_PL4Q_aplActivePL__c = false,
         ACP_CYPL_aplActivePL__c = false,
         ACP_NYPL_aplActivePL__c = false,
         ACP_5YPL_aplActivePL__c = false
      );
      oppTAMRepList.add(oppTAMReport);

      Insert oppTAMRepList;

      Apexpages.currentPage().getParameters().put('acpid', newAccPlan.id);
      ACP_Opportunity_Data_Automation_Ctrl obj = new ACP_Opportunity_Data_Automation_Ctrl(new ApexPages.StandardController(newAccPlan));
      string acpid = newAccPlan.Id;
      obj.userBU = u.GIBU__c;
      obj.oppTamRevRecordId = OppTam[0].id;
      obj.updateRecords();
      obj.reloadThePage();
      Test.stopTest();
   }

   private static testMethod void DataAutomation_TestMethod5() {
      User thisUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
      Profile p;
      User u;
      System.runAs(thisUser) {
         ACP_User_BU__c dnd_setting = new ACP_User_BU__c();
         dnd_setting.Name = 'ACP_DND_test';
         dnd_setting.UserBU__c = 'Data & Devices';
         insert dnd_setting;

         p = [select id from Profile where Name = 'Standard User'];
         u = new User(alias = 'standt', email = 'standarduser@testorg.com', emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US',
            localesidkey = 'en_US',
            profileid = p.Id,
            timezonesidkey = 'America/Los_Angeles',
            GIBU__c = dnd_setting.UserBU__c,
            MED_Region__c = 'India',
            username = 'acpuser17122017@examp5.com');

         insert u;
      }
      Test.startTest();

      Map < String, ACP_User_BU__c > userBUs = ACP_User_BU__c.getAll();

      String reportName_PL4Q = 'ACP_DND_Pipeline_4Q_Rolling';
      String reportName_Conv = 'ACP_DND_Conversion';
      String reportName_Lost = 'ACP_DND_L12MLost';
      String reportName_Won = 'ACP_DND_L12MWon';
      String reportName_CY = 'ACP_DND_CY_Pipeline';
      String reportName_NY = 'ACP_DND_NY_Pipeline';
      String reportName_5Y = 'ACP_DND_5Y_Pipeline';

      Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Grouped Accounts').getRecordTypeId();

      Account account = new Account(
         Name = 'TestAccount1PlanAccount10896',
         GAMCD__c = 'G0007',
         RecordTypeId = recType,
         IND_KAM_Code__c = 'K0007');
      Insert account;

      // Create Account Plan
      ACP_Account_Plan__c newAccPlan = new ACP_Account_Plan__c(
         Name = 'TestAccount1Plan3564',
         ACP_Account_Name__c = account.Id,
         Account_Plan_Type__c = 'GAM Account',
         ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3564');
      insert(newAccPlan);


      List < ACP_Opportunity_TAM_Revenue__c > OppTAM = ACP_TestDataFactory.createOppTamRevenue(newAccPlan.id, 'CBC2 - 30033 - Tubing Materials');
      insert OppTam;
      Report report1 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_PL4Q');
      Report report2 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_Conv');
      Report report3 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_Lost');
      Report report4 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_Won');
      Report report5 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_CY');
      Report report6 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_NY');
      Report report7 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_5Y');
      List < ACP_Oppty_TAM_Report__c > oppTAMRepList = new List < ACP_Oppty_TAM_Report__c > ();
      system.debug(' report list ' + opptamreplist);
      Id recType2 = Schema.SObjectType.ACP_Oppty_TAM_Report__c.getRecordTypeInfosByName().get(userBUs.get('ACP_DND_test').UserBU__c).getRecordTypeId();
      ACP_Oppty_TAM_Report__c oppTAMReport = new ACP_Oppty_TAM_Report__c(
         recordtypeid = recType2,
         ACP_Pipeline__c = (String) report1.Id,
         ACP_Conversion__c = (String) report2.Id,
         ACP_L12_Lost__c = (String) report3.Id,
         ACP_L12_Won__c = (String) report4.Id,
         ACP_CY_Pipeline__c = (String) report5.Id,
         ACP_NY_Pipeline__c = (String) report6.Id,
         ACP_X5Y_Pipeline__c = (String) report7.Id,
         ACP_CYPL_Confidence2__c = 'Won',
         ACP_PL4Q_Type__c = 'Transfer existing Business;Defend existing Business',
         ACP_PL4Q_Days_since_last_user_update__c = 60.0,
         ACP_PL4Q_Won_Date__c = 'THIS FISCAL YEAR',
         ACP_PL4Q_Confidence__c = 'Weak;50/50;Likely;Commit',
         ACP_PL4Q_Date__c = 'NEXT 4 FISCAL QUARTERS',
         ACP_PL4Q_Opp_Group__c = 'Engineering;Sales;NDR',
         ACP_PL4Q_BU_Profit_Center__c = 'Data and Devices;Data & Devices',
         ACP_Conv_Won_Date__c = 'THIS FISCAL YEAR',
         ACP_Conv_Confidence__c = 'Won',
         ACP_PL4Q_Process_Status__c = 'Pre-prod',
         ACP_Lost_Lost_Date__c = 'LAST 12 MONTHS',
         ACP_Won_Won_Date__c = 'LAST 12 MONTHS',
         ACP_CYPL_Won_Date__c = 'THIS FISCAL YEAR',
         ACP_CYPL_Confidence__c = 'Weak;50/50;Likely;Commit',
         ACP_CYPL_Date__c = 'THIS FISCAL YEAR',
         ACP_NYPL_Won_Date__c = 'THIS FISCAL YEAR',
         ACP_NYPL_Confidence__c = 'Weak;50/50;Likely;Commit',
         ACP_NYPL_Date__c = 'NEXT FISCAL YEAR',
         ACP_5YPL_Won_Date__c = '10/24/2017',
         ACP_5YPL_Confidence__c = 'Weak;50/50;Likely;Commit',
         ACP_5YPL_Date__c = 'NEXT 5 FISCAL YEARS',
         ACP_PL4Q_Confidence2__c = 'Won',
         ACP_NYPL_Confidence2__c = 'Won',
         ACP_5YPL_Confidence2__c = 'Won',
         ACP_PL4Q_aplActivePL__c = false,
         ACP_CYPL_aplActivePL__c = false,
         ACP_NYPL_aplActivePL__c = false,
         ACP_5YPL_aplActivePL__c = false,
         ACP_Conv_Date__c = 'THIS FISCAL YEAR',
         ACP_Lost_Confidence__c = 'Dead;Lost',
         ACP_Lost_Date__c = 'THIS FISCAL YEAR',
         ACP_Won_Confidence__c = 'Won',
         ACP_Won_Date__c = 'THIS FISCAL YEAR',
         ACP_Conv_BU_Profit_Center__c = 'Data and Devices;Data & Devices',
         ACP_Lost_BU_Profit_Center__c = 'Data and Devices;Data & Devices',
         ACP_Won_BU_Profit_Center__c = 'Data and Devices;Data & Devices',
         ACP_CYPL_BU_Profit_Center__c = 'Data and Devices;Data & Devices',
         ACP_NYPL_BU_Profit_Center__c = 'Data and Devices;Data & Devices',
         ACP_5YPL_BU_Profit_Center__c = 'Data and Devices;Data & Devices',
         ACP_PL4Q_Opp_Record_Type__c = 'DND Opportunity',
         ACP_Conv_Opp_Record_Type__c = 'DND Opportunity',
         ACP_Lost_Opp_Record_Type__c = 'DND Opportunity',
         ACP_Won_Opp_Record_Type__c = 'DND Opportunity',
         ACP_CYPL_Opp_Record_Type__c = 'DND Opportunity',
         ACP_NYPL_Opp_Record_Type__c = 'DND Opportunity',
         ACP_5YPL_Opp_Record_Type__c = 'DND Opportunity',
         ACP_PL4Q_Oppty_Rec_Type__c = 'DND Opportunity',
         ACP_Conv_Oppty_Rec_Type__c = 'DND Opportunity',
         ACP_Lost_Oppty_Rec_Type__c = 'DND Opportunity',
         ACP_Won_Oppty_Rec_Type__c = 'DND Opportunity',
         ACP_CYPL_Oppty_Rec_Type__c = 'DND Opportunity',
         ACP_NYPL_Oppty_Rec_Type__c = 'DND Opportunity',
         ACP_5YPL_Oppty_Rec_Type__c = 'DND Opportunity'
      );
      oppTAMRepList.add(oppTAMReport);

      Insert oppTAMRepList;

      Apexpages.currentPage().getParameters().put('acpid', newAccPlan.id);
      ACP_Opportunity_Data_Automation_Ctrl obj = new ACP_Opportunity_Data_Automation_Ctrl(new ApexPages.StandardController(newAccPlan));
      string acpid = newAccPlan.Id;
      obj.userBU = u.GIBU__c;
      obj.oppTamRevRecordId = OppTam[0].id;
      obj.updateRecords();
      obj.reloadThePage();
      Test.stopTest();
   }

  private static testMethod void DataAutomation_TestMethod6() {System.Debug('Channel Method');
      User thisUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
      Profile p;
      User u;
      System.runAs(thisUser) {
         ACP_User_BU__c chn_setting = new ACP_User_BU__c();
         chn_setting.Name = 'ACP_Channel_test';
         chn_setting.UserBU__c = 'Channel';
         insert chn_setting;

         p = [select id from Profile where Name = 'Standard User'];
         u = new User(alias = 'standt', email = 'standarduser@testorg.com', emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US',
            localesidkey = 'en_US',
            profileid = p.Id,
            timezonesidkey = 'America/Los_Angeles',
            GIBU__c = chn_setting.UserBU__c,
            MED_Region__c = 'India',
            username = 'acpuser17122017@examp6.com');

         insert u;
      }
      Test.startTest();

      Map < String, ACP_User_BU__c > userBUs = ACP_User_BU__c.getAll();

	  String reportName_PL4Q = 'ACP_CHN_Pipeline_4Q_Rolling';
      String reportName_Conv = 'ACP_CHN_Conversion';
      String reportName_Lost = 'ACP_CHN_L12MLost';
      String reportName_Won = 'ACP_CHN_L12MWon';
      String reportName_CY = 'ACP_CHN_CY_Pipeline';
      String reportName_NY = 'ACP_CHN_NY_Pipeline';
      String reportName_5Y = 'ACP_CHN_5Y_Pipeline';      
      Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Grouped Accounts').getRecordTypeId();

      Account account = new Account(
         Name = 'TestAccount1PlanAccount10897',
         GAMCD__c = 'G0007',
         RecordTypeId = recType,
         IND_KAM_Code__c = 'K0007');
      Insert account;

      // Create Account Plan
      ACP_Account_Plan__c newAccPlan = new ACP_Account_Plan__c(
         Name = 'TestAccount1Plan3564',
         ACP_Account_Name__c = account.Id,
         Account_Plan_Type__c = 'GAM Account',
         ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3564');
      insert(newAccPlan);

      List < ACP_Opportunity_TAM_Revenue__c > OppTAM = ACP_TestDataFactory.createOppTamRevenue(newAccPlan.id, 'CBC1 - 30033 - Tubing Materials');
      insert OppTam;
      Report report1 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_PL4Q');
      Report report2 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_Conv');
      Report report3 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_Lost');
      Report report4 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_Won');
      Report report5 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_CY');
      Report report6 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_NY');
      Report report7 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName_5Y');
                                                               
      List < ACP_Oppty_TAM_Report__c > oppTAMRepList = new List < ACP_Oppty_TAM_Report__c > ();
      system.debug(' report list ' + opptamreplist);
      Id recType2 = Schema.SObjectType.ACP_Oppty_TAM_Report__c.getRecordTypeInfosByName().get(userBUs.get('ACP_Channel_test').UserBU__c).getRecordTypeId();
      ACP_Oppty_TAM_Report__c oppTAMReport = new ACP_Oppty_TAM_Report__c(
         recordtypeid = recType2,
         ACP_Pipeline__c = (String) report1.Id,
         ACP_Conversion__c = (String) report2.Id,
         ACP_L12_Lost__c = (String) report3.Id,
         ACP_L12_Won__c = (String) report4.Id,
         ACP_CY_Pipeline__c = (String) report5.Id,
         ACP_NY_Pipeline__c = (String) report6.Id,
         ACP_X5Y_Pipeline__c = (String) report7.Id,
         ACP_PL4Q_Type__c = 'Transfer existing Business;Defend existing Business;Stocking Package',
         ACP_PL4Q_Days_since_last_user_update__c = 60.0,
         ACP_PL4Q_Won_Date__c = 'THIS FISCAL YEAR',
         ACP_PL4Q_Confidence__c = 'Weak;50/50;Likely;Commit',
         ACP_PL4Q_Date__c = 'NEXT 4 FISCAL QUARTERS',
         ACP_Conv_Type__c = 'Transfer existing Business;Defend existing Business;Stocking Package',
         ACP_Conv_Won_Date__c = 'THIS FISCAL YEAR',
         ACP_Conv_Confidence__c = 'Won',
         ACP_Conv_Process_Status__c = 'Production;Ramp-down;EOL',
         ACP_Lost_Lost_Date__c = 'LAST 365 DAYS',
         ACP_Won_Won_Date__c = 'LAST 365 DAYS',
         ACP_CYPL_Process_Status__c = 'Production;Ramp-down;EOL',
         ACP_CYPL_Type__c = 'Transfer existing Business;Defend existing Business;Stocking Package',
         ACP_CYPL_Won_Date__c = 'THIS FISCAL YEAR',
         ACP_CYPL_Confidence__c = 'Won',
         ACP_CYPL_Date__c = 'THIS FISCAL YEAR',
         ACP_NYPL_Type__c = 'Transfer existing Business;Defend existing Business;Stocking Package',
         ACP_NYPL_Days_since_last_user_update__c = 60.0,
         ACP_NYPL_Won_Date__c = 'THIS FISCAL YEAR',
         ACP_NYPL_Confidence__c = 'Weak;50/50;Likely;Commit',
         ACP_NYPL_Date__c = 'NEXT FISCAL YEAR',
         ACP_5YPL_Type__c = 'Transfer existing Business;Defend existing Business;Stocking Package',
         ACP_5YPL_Days_since_last_user_update__c = 60.0,
         ACP_5YPL_Won_Date__c = 'THIS FISCAL YEAR',
         ACP_5YPL_Confidence__c = 'Weak;50/50;Likely;Commit',
         ACP_5YPL_Date__c = 'NEXT 20 FISCAL QUARTERS',
         ACP_PL4Q_Confidence2__c = 'Won',
         ACP_NYPL_Confidence2__c = 'Won',
         ACP_5YPL_Confidence2__c = 'Won',
         ACP_PL4Q_aplActivePL__c = false,
         ACP_CYPL_aplActivePL__c = false,
         ACP_NYPL_aplActivePL__c = false,
         ACP_5YPL_aplActivePL__c = false,
         ACP_Conv_Date__c = 'THIS FISCAL YEAR',
         ACP_Lost_Date__c = 'LAST 3 FISCAL QUARTERS',
         ACP_Won_Date__c = 'LAST 3 FISCAL QUARTERS',
         ACP_Lost_Part_Confidence__c = 'Lost',
         ACP_Won_Part_Confidence__c = 'Won',
         ACP_PL4Q_Days_since_last_user_update2__c = 90.0,
         ACP_5YPL_Days_since_last_user_update2__c = 90.0,
         ACP_Lost_Date2__c = 'THIS FISCAL QUARTER',
         ACP_Won_Date2__c = 'THIS FISCAL QUARTER',
         ACP_NYPL_Opportunity_Record_Type2__c = 'CCR Opportunity;NDR Opportunity',
         ACP_5YPL_Opportunity_Record_Type2__c = 'CCR Opportunity;NDR Opportunity',
         ACP_PL4Q_Oppty_Rec_Type__c = 'DND Opportunity;Channel- Engineering Opportunity;Channel- Sales Opportunity;Opportunity - Engineering Project;Opportunity - Sales Project;Engineering Opportunity-CSD;Sales Opportunity-CSD;IND - Sales Project;IND - Engineering project;ADM',
         ACP_Conv_Oppty_Rec_Type__c = 'DND Opportunity;Channel- Engineering Opportunity;Channel- Sales Opportunity;Opportunity - Engineering Project;Opportunity - Sales Project;Engineering Opportunity-CSD;Sales Opportunity-CSD;IND - Sales Project;IND - Engineering project;ADM',
         ACP_Lost_Oppty_Rec_Type__c = 'DND Opportunity;Channel- Engineering Opportunity;Channel- Sales Opportunity;Opportunity - Engineering Project;Opportunity - Sales Project;Engineering Opportunity-CSD;Sales Opportunity-CSD;IND - Sales Project;IND - Engineering project;ADM',
         ACP_Won_Oppty_Rec_Type__c = 'DND Opportunity;Channel- Engineering Opportunity;Channel- Sales Opportunity;Opportunity - Engineering Project;Opportunity - Sales Project;Engineering Opportunity-CSD;Sales Opportunity-CSD;IND - Sales Project;IND - Engineering project;ADM',
         ACP_CYPL_Oppty_Rec_Type__c = 'DND Opportunity;Channel- Engineering Opportunity;Channel- Sales Opportunity;Opportunity - Engineering Project;Opportunity - Sales Project;Engineering Opportunity-CSD;Sales Opportunity-CSD;IND - Sales Project;IND - Engineering project;ADM',
         ACP_NYPL_Oppty_Rec_Type__c = 'DND Opportunity;Channel- Engineering Opportunity;Channel- Sales Opportunity;Opportunity - Engineering Project;Opportunity - Sales Project;Engineering Opportunity-CSD;Sales Opportunity-CSD;IND - Sales Project;IND - Engineering project;ADM',
         ACP_5YPL_Oppty_Rec_Type__c = 'DND Opportunity;Channel- Engineering Opportunity;Channel- Sales Opportunity;Opportunity - Engineering Project;Opportunity - Sales Project;Engineering Opportunity-CSD;Sales Opportunity-CSD;IND - Sales Project;IND - Engineering project;ADM',
         ACP_PL4Q_DISTRIBUTOR__c = 'None-Direct Business',
         ACP_Conv_DISTRIBUTOR__c = 'None-Direct Business',
         ACP_Lost_DISTRIBUTOR__c = 'None-Direct Business',
         ACP_Won_DISTRIBUTOR__c = 'None-Direct Business',
         ACP_CYPL_DISTRIBUTOR__c = 'None-Direct Business',
         ACP_NYPL_DISTRIBUTOR__c = 'None-Direct Business',
         ACP_5YPL_DISTRIBUTOR__c = 'None-Direct Business',
         ACP_Lost_Type__c = 'Transfer existing Business;Defend existing Business;Stocking Package',
         ACP_Won_Type__c = 'Transfer existing Business;Defend existing Business;Stocking Package',
         ACP_NYPL_Days_since_last_user_update2__c = 90.0
      );
      oppTAMRepList.add(oppTAMReport);

      Insert oppTAMRepList;

      Apexpages.currentPage().getParameters().put('acpid', newAccPlan.id);
      ACP_Opportunity_Data_Automation_Ctrl obj = new ACP_Opportunity_Data_Automation_Ctrl(new ApexPages.StandardController(newAccPlan));
      string acpid = newAccPlan.Id;
      obj.userBU = u.GIBU__c;
      obj.oppTamRevRecordId = OppTam[0].id;
      obj.updateRecords();
      obj.reloadThePage();
      Test.stopTest();
   }

   static testMethod void MarketComp_RunReport_Method() {
      Test.startTest();
      Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Grouped Accounts').getRecordTypeId();

      Account acct = new Account(
         Name = 'TestAccount1PlanAccount289',
         GAMCD__c = 'G0007',
         RecordTypeId = recType,
         IND_KAM_Code__c = 'K0007');
      Insert acct;

      ACP_Account_Plan__c accplan = new ACP_Account_Plan__c(
         Name = 'TestAcc4',
         ACP_Account_Name__c = acct.Id,
         Account_Plan_Type__c = 'GAM Account',
         ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3546');
      insert accplan;

      RecordType rcdType = [Select Id, name from RecordType where Name = 'General Market and Competition'];
      Id recordId = rcdType.Id;
      ACP_Market_and_Competition__c mark = new ACP_Market_and_Competition__c();
      mark.RecordTypeId = recordId;
      mark.ACP_Account_Plan__c = accPlan.id;
      mark.ACP_Main_Competitor_Share__c = 14;
      mark.ACP_Market_Share__c = 12;
      mark.ACP_NY_Fcst__c = 20;
      mark.ACP_PAM__c = 200;
      mark.ACP_SAM__c = 200;
      mark.ACP_TAM__c = 200;
      mark.ACP_TE_Position__c = 'Flat';
      mark.ACP_CBC__c = 'CBC3 - Tubing Materials - 30049';
      mark.ACP_TAM_LY_Bill__c = 20.00;
      mark.ACP_TAM_CYRR__c = 20.00;
      mark.ACP_TAM_NY_Fcst__c = 20.00;
      mark.ACP_LY_Bill__c = 200;
      mark.ACP_CY_YTD__c = 300;
      mark.ACP_LY_YTD__c = 400;

      insert mark;

      List < BBB_Year_Bill_Book_Cust_PN__c > yearlyBBBList = ACP_TestDataFactory.createYearlyBBB('30049', 'GAM Account', acct.id);
      for (BBB_Year_Bill_Book_Cust_PN__c ybb: yearlyBBBList) {
         ybb.Customer__c = acct.id;
      }
      insert yearlyBBBList;

      String reportName1 = 'ACP_Yearly_Billing_Report';
      Report report1 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName1');

      /*  ACP_BBB_Reports__c cs = new ACP_BBB_Reports__c(
Name = 'Yearly_BBB_Report1',
ACP_Report_Id__c = (String) report1.Id);
insert cs;
*/
      Apexpages.currentPage().getParameters().put('acpid', accplan.id);
      ACP_Opportunity_Data_Automation_Ctrl ctrlObj = new ACP_Opportunity_Data_Automation_Ctrl(new ApexPages.StandardController(accplan));

      ctrlObj.acpId = accPlan.id;

      ACP_Opportunity_Data_Automation_Ctrl.marketRunReport('CBC3', '30049', 'GAM Account', '00000', acct.id, report1.id);
      ctrlObj.updateMarkRecords();
      ctrlObj.getMarketReportIds(mark);

      Test.stopTest();
   }
   static testMethod void MarketComp_RunReport_Method1() {
      Test.startTest();
      Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Grouped Accounts').getRecordTypeId();

      Account acct = new Account(
         Name = 'TestAccount1PlanAccount289',
         GAMCD__c = 'G0004',
         RecordTypeId = recType,
         IND_KAM_Code__c = 'K0004');
      Insert acct;

      ACP_Account_Plan__c accplan = new ACP_Account_Plan__c(
         Name = 'TestAcc5',
         ACP_Account_Name__c = acct.Id,
         Account_Plan_Type__c = 'KAM Account',
         ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3565');
      insert accplan;

      RecordType rcdType = [Select Id, name from RecordType where Name = 'General Market and Competition'];
      Id recordId = rcdType.Id;
      ACP_Market_and_Competition__c mark = new ACP_Market_and_Competition__c();
      mark.RecordTypeId = recordId;
      mark.ACP_Account_Plan__c = accPlan.id;
      mark.ACP_Main_Competitor_Share__c = 14;
      mark.ACP_Market_Share__c = 12;
      mark.ACP_NY_Fcst__c = 20;
      mark.ACP_PAM__c = 200;
      mark.ACP_SAM__c = 200;
      mark.ACP_TAM__c = 200;
      mark.ACP_TE_Position__c = 'Flat';
      mark.ACP_CBC__c = 'CBC2 - 30023 - Tubing Materials';
      mark.ACP_TAM_LY_Bill__c = 20.00;
      mark.ACP_TAM_CYRR__c = 20.00;
      mark.ACP_TAM_NY_Fcst__c = 20.00;
      mark.ACP_LY_Bill__c = 200;
      mark.ACP_CY_YTD__c = 300;
      mark.ACP_LY_YTD__c = 400;

      insert mark;

      List < BBB_Year_Bill_Book_Cust_PN__c > yearlyBBBList = ACP_TestDataFactory.createYearlyBBB('30023', 'KAM Account', acct.id);

      for (BBB_Year_Bill_Book_Cust_PN__c ybb: yearlyBBBList) {
         ybb.Customer__c = acct.id;
      }
      insert yearlyBBBList;

      String reportName1 = 'ACP_Yearly_Billing_Report';
      Report report1 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName1');

      /*  ACP_BBB_Reports__c cs = new ACP_BBB_Reports__c(
Name = 'Yearly_BBB_Report2',
ACP_Report_Id__c = (String) report1.Id);
insert cs;*/

      Apexpages.currentPage().getParameters().put('acpid', accplan.id);
      ACP_Opportunity_Data_Automation_Ctrl ctrlObj = new ACP_Opportunity_Data_Automation_Ctrl(new ApexPages.StandardController(accplan));

      ctrlObj.acpId = accPlan.id;

      ACP_Opportunity_Data_Automation_Ctrl.marketRunReport('CBC2', '30023', 'KAM Account', '00000', acct.id, report1.id);
      ctrlObj.updateMarkRecords();
      ctrlObj.getMarketReportIds(mark);
      Test.stopTest();
   }
   static testMethod void MarketComp_RunReport_Method2() {
      Test.startTest();
      Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Grouped Accounts').getRecordTypeId();

      Account acct = new Account(
         Name = 'TestAccount1244',
         Type = 'Prospect',
         RecordTypeId = recType);
      Insert acct;

      ACP_Account_Plan__c accplan = new ACP_Account_Plan__c(
         Name = 'TestAcc6',
         ACP_Account_Name__c = acct.Id,
         Account_Plan_Type__c = 'WW Account',
         ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3566');
      insert accplan;

      RecordType rcdType = [Select Id, name from RecordType where Name = 'General Market and Competition'];
      Id recordId = rcdType.Id;
      ACP_Market_and_Competition__c mark = new ACP_Market_and_Competition__c();
      mark.RecordTypeId = recordId;
      mark.ACP_Account_Plan__c = accPlan.id;
      mark.ACP_Main_Competitor_Share__c = 14;
      mark.ACP_Market_Share__c = 12;
      mark.ACP_NY_Fcst__c = 20;
      mark.ACP_PAM__c = 200;
      mark.ACP_SAM__c = 200;
      mark.ACP_TAM__c = 200;
      mark.ACP_TE_Position__c = 'Flat';
      mark.ACP_CBC__c = 'CBC1 - 30013 - Tubing Materials';
      mark.ACP_TAM_LY_Bill__c = 20.00;
      mark.ACP_TAM_CYRR__c = 20.00;
      mark.ACP_TAM_NY_Fcst__c = 20.00;
      mark.ACP_LY_Bill__c = 200;
      mark.ACP_CY_YTD__c = 300;
      mark.ACP_LY_YTD__c = 400;

      insert mark;

      List < BBB_Year_Bill_Book_Cust_PN__c > yearlyBBBList = ACP_TestDataFactory.createYearlyBBB('30013', 'KAM Account', acct.id);
      for (BBB_Year_Bill_Book_Cust_PN__c ybb: yearlyBBBList) {
         ybb.Customer__c = acct.id;
      }
      insert yearlyBBBList;

      String reportName1 = 'ACP_Yearly_Billing_Report';
      Report report1 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName1');

      /*   ACP_BBB_Reports__c cs = new ACP_BBB_Reports__c(
Name = 'Yearly_BBB_Report3',
ACP_Report_Id__c = (String) report1.Id);
insert cs;
system.debug('cs' + cs);*/
      Apexpages.currentPage().getParameters().put('acpid', accplan.id);
      ACP_Opportunity_Data_Automation_Ctrl ctrlObj = new ACP_Opportunity_Data_Automation_Ctrl(new ApexPages.StandardController(accplan));

      ctrlObj.acpId = accPlan.id;

      ACP_Opportunity_Data_Automation_Ctrl.marketRunReport('CBC1', '30013', 'WW Account', '00000', acct.id, report1.id);
      ctrlObj.updateMarkRecords();
      ctrlObj.getMarketReportIds(mark);
      Test.stopTest();
   }
   static testMethod void MarketComp_RunReport_Method3() {
      Test.startTest();
      Id recType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account').getRecordTypeId();

      Account acct = new Account(
         Name = 'TestAccount1PlanAccount289',
         GAMCD__c = 'G0004',
         RecordTypeId = recType,
         IND_KAM_Code__c = 'K0004'
      );
      Insert acct;

      ACP_Account_Plan__c accplan = new ACP_Account_Plan__c(
         Name = 'TestAcc7',
         ACP_Account_Name__c = acct.Id,
         Account_Plan_Type__c = 'Sold-to Account',
         ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3567');
      insert accplan;

      RecordType rcdType = [Select Id, name from RecordType where Name = 'General Market and Competition'];
      Id recordId = rcdType.Id;
      ACP_Market_and_Competition__c mark = new ACP_Market_and_Competition__c();
      mark.RecordTypeId = recordId;
      mark.ACP_Account_Plan__c = accPlan.id;
      mark.ACP_Main_Competitor_Share__c = 14;
      mark.ACP_Market_Share__c = 12;
      mark.ACP_NY_Fcst__c = 20;
      mark.ACP_PAM__c = 200;
      mark.ACP_SAM__c = 200;
      mark.ACP_TAM__c = 200;
      mark.ACP_TE_Position__c = 'Flat';
      mark.ACP_CBC__c = 'CBC3 - Tubing Materials - 30049';
      mark.ACP_TAM_LY_Bill__c = 20.00;
      mark.ACP_TAM_CYRR__c = 20.00;
      mark.ACP_TAM_NY_Fcst__c = 20.00;
      mark.ACP_LY_Bill__c = 200;
      mark.ACP_CY_YTD__c = 300;
      mark.ACP_LY_YTD__c = 400;

      insert mark;

      List < BBB_Year_Bill_Book_Cust_PN__c > yearlyBBBList = ACP_TestDataFactory.createYearlyBBB('30049', 'Sold-to Account', acct.id);
      for (BBB_Year_Bill_Book_Cust_PN__c ybb: yearlyBBBList) {
         ybb.Customer__c = acct.id;
      }
      insert yearlyBBBList;

      String reportName1 = 'ACP_Yearly_Billing_Report';
      Report report1 = Database.query('SELECT Id, Developername FROM Report WHERE Developername =: reportName1');

      /*  ACP_BBB_Reports__c cs = new ACP_BBB_Reports__c(
Name = 'Yearly_BBB_Report4',
ACP_Report_Id__c = (String) report1.Id);
insert cs;*/

      Apexpages.currentPage().getParameters().put('acpid', accplan.id);
      ACP_Opportunity_Data_Automation_Ctrl ctrlObj = new ACP_Opportunity_Data_Automation_Ctrl(new ApexPages.StandardController(accplan));
      ctrlObj.acpId = accPlan.id;

      ACP_Opportunity_Data_Automation_Ctrl.marketRunReport('CBC3', '30049', 'Sold-to Account', '000000000000000', acct.id, report1.id);

      ctrlObj.updateMarkRecords();
      ctrlObj.getMarketReportIds(mark);
      Test.stopTest();
   }
}