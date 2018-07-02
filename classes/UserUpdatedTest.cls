@isTest
private class UserUpdatedTest {

    static testMethod void myUnitTest() {
        /*  Apex_Helper_Settings__c ahs1 = ClsTestHelp.createTestName1();
      Apex_Helper_Settings__c ahs2 = ClsTestHelp.createTestName2();
      Apex_Helper_Settings__c ahs3 = ClsTestHelp.createTestName3();
      Apex_Helper_Settings__c ahs4 = ClsTestHelp.createTestName4();
      Apex_Helper_Settings__c ahs5 = ClsTestHelp.createTestName5();
      Apex_Helper_Settings__c ahs6 = ClsTestHelp.createTestName6();
      Apex_Helper_Settings__c ahs7 = ClsTestHelp.createTestName7();
      Apex_Helper_Settings__c ahs8 = ClsTestHelp.createTestName8();
      Apex_Helper_Settings__c ahs9 = ClsTestHelp.createTestName9();
      Apex_Helper_Settings__c ahs10 = ClsTestHelp.createTestName10();
      Apex_Helper_Settings__c ahs11 = ClsTestHelp.createTestName11();
      Apex_Helper_Settings__c ahs12 = ClsTestHelp.createTestName12();
      List<Apex_Helper_Settings__c> tmpList = new List<Apex_Helper_Settings__c>();
      Apex_Helper_Settings__c exceptUser = new Apex_Helper_Settings__c();
        exceptUser.name = 'Currency Confirm Except Users';
        exceptUser.value__c = '005E0000000XIav';
        tmpList.add(exceptUser);
        Apex_Helper_Settings__c lostRecordType = new Apex_Helper_Settings__c();
        lostRecordType.name = 'Lost Business - Appliances';
        lostRecordType.value__c = '012E0000000NFbV';
        tmpList.add(lostRecordType);
        Apex_Helper_Settings__c emailTemplate = new Apex_Helper_Settings__c();
        emailTemplate.name = 'APL_Email_Alert_Template';
        emailTemplate.value__c = 'https://c2s.my.salesforce.com/servlet/servlet.ImageServer?;id=015E0000000P3MB;id=015E0000001hKDe;&oid=00DE0000000Hkve;https://c2s.my.salesforce.com/';
        tmpList.add(emailTemplate);
        insert tmpList;*/
        
        CSD_Exception_Email__c eu = new CSD_Exception_Email__c();
        eu.Name = 'Exception User';
      eu.user_Id__c = '005E0000006CX4x';
      insert eu;
      Consumer_Device_Opportunity_Record_Types__c cdort1 = ClsTestHelp.createTestCSD1();
      Consumer_Device_Opportunity_Record_Types__c cdort2 = ClsTestHelp.createTestCSD2();
      Consumer_Device_Opportunity_Record_Types__c cdort3 = ClsTestHelp.createTestCSD3();
      Consumer_Device_Opportunity_Record_Types__c cdort4 = ClsTestHelp.createTestCSD4();
      Consumer_Device_Opportunity_Record_Types__c cdort5 = ClsTestHelp.createTestCSD5();
      Consumer_Device_Opportunity_Record_Types__c cdort6 = ClsTestHelp.createTestCSD6();
      Consumer_Device_Opportunity_Record_Types__c cdort7 = ClsTestHelp.createTestCSD7();
      
      Opportunity_Approvers__c oa = ClsTestHelp.createTestOpportunityApprovers();
        Opportunity_Approvers__c oa2 = ClsTestHelp.createTestOpportunityApprovers2();
        Opportunity_Approvers__c oa3 = ClsTestHelp.createTestOpportunityApprovers3();
        Opportunity_Approvers__c oa4 = ClsTestHelp.createTestOpportunityApprovers4();
        Profit_BU_Center_Mapping_Rule1__c pb1 = ClsTestHelp.createTestProfitBUCenterMapping1();
        Profit_BU_Center_Mapping_Rule2__c pb2 = ClsTestHelp.createTestProfitBUCenterMapping2();
        Profit_BU_Center_Mapping_Rule3__c pb3 = ClsTestHelp.createTestProfitBUCenterMapping3();
      
      RecordType rt2 = ClsTestHelp.createTestRecordType8();
      
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
        insert sh;
           
        // User Record
        Profile p = [SELECT Id FROM Profile WHERE Name='Appliance Standard User'];
        User u1 = new User(GIBU__c='Data & Devices', Alias = 'standt', Email='tst111@testorg.com', EmailEncodingKey='UTF-8', LastName='Tst', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='tst026111@test.com', CSD_Region__c='Taiwan');
        insert u1;
        User u2 = new User(ManagerId = u1.Id,GIBU__c='Data & Devices', Alias = 'standt', Email='tt@testorg.com', EmailEncodingKey='UTF-8', LastName='Tt', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='tst03@test.com', CSD_Region__c='Taiwan');
        insert u2; 
        
        u2.GIBU__c = 'Appliances';
        update u2;
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();  
        List<Account> aL = new List<Account>();
        
        Account amAcct = ClsTestHelp.createTestAccounts();
        amAcct.Name = 'axx';
        amAcct.RecordTypeId = rt2.Id;
        amAcct.STATDESC__c = 'active';
        amAcct.APL_AM_Currency__c = 'USD';
        amAcct.APL_AM_Display_Name__c = 'amName';       
        amAcct.Account_Manager__c = u2.Id;
        amAcct.SALES_TERRITORY_CDE__c = '123456';
        aL.add(amAcct);
        insert aL;
        
        RecordType rt = [select id, Name, DeveloperName from RecordType where SobjectType = 'Opportunity' and DeveloperName = 'Lost_Business_Appliances'];
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        //oppy.Program__c = oppy2.Id;   
        oppy.AccountId = amAcct.Id;
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.StageName = 'Lost/Dead';
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        oppy.RecordTypeId = rt.Id; 
        oppy.APL_Billing_Receive_Region__c = 'North America';
        oppy.Need_Send_Lost_Mail__c = true;
        oppy.Existing_Business_Lost_Reason__c = 'Migration - sales moved to other region';
        oppy.first_fiscal_year_lost__c = 1000;
        oppy.second_fiscal_year_lost__c = 1000;
        insert oppy;
        
        u2.ManagerId = null;
        update u2;
    }
}