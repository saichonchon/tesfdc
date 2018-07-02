/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   A test class for ClsOppyPartForecastDeleteQueue.cls.
               The user story number is Opportunity Part Forecast.
Inputs:        
Test Class:    
History
2017-10-17 Yiming Shen <yiming.shen@capgemini.com> Created
------------------------------------------------------------*/
@isTest
private class ClsOppyPartForecastDeleteQueue_Test {
    @testSetup static void createConfig(){
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        ClsTestCustomSettingHelper.getADMTerritoryCode();
        Channelinsightdata_test.Channelinsightdata_test();
        ClsTestHelp.createTestOrgWideSettings1();
        ClsTestHelp.createTestOPTG4();
    }
    
    static testMethod void myUnitTest() {
        Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial'; 
        insert ph;
        
        Account acct = ClsTestHelp.createTestAccounts();
        acct.Type = 'CM';
        acct.AccountNumber = 'test';
        acct.INDUSTRY_BUSINESS_CDE__c = '115'; 
        acct.DD1_Industry_Business_Code__c = '104';
        acct.DD2_Industry_Business_Code__c = '203';
        insert acct;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.AccountId = acct.Id;   
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        insert oppy;
        
        Part__c part = ClsTestHelp.createTestPart();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        Test.startTest();
        Opportunity_Part__c oppypart = ClsTestHelp.createTestEnergyOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = part.Id;
        oppypart.Offered_Price__c = 0;
        insert oppypart;
        
        Opportunity_Forecast__c oppyForecast1 = ClsTestHelp.createTestENGOpportunityForecasts();
        oppyForecast1.Opportunity__c = oppy.Id;
        oppyForecast1.Part__c = oppypart.Id;
        oppyForecast1.Amount__c = 100;
        oppyForecast1.CurrencyIsoCode = 'USD';
        oppyForecast1.Confidence_Level__c = '30';
        oppyForecast1.Fiscal_Month__c = '12';
        oppyForecast1.Fiscal_Quarter__c = 'Q4';
        oppyForecast1.Fiscal_Year__c = '2017';
        insert oppyForecast1;
        
        Opportunity_Part_Forecast__c oppyPartForecast = ClsTestHelp.createTestOpportunityPartForecast();
        oppyPartForecast.Name = 'testOppPartForecast' + system.now();
        oppyPartForecast.Opportunity_Part__c = oppypart.Id;
        oppyPartForecast.Opportunity_Forecast__c = oppyForecast1.Id;
        oppyPartForecast.Month__c = decimal.valueOf(oppyForecast1.Fiscal_Month__c);
        oppyPartForecast.Year__c = oppyForecast1.Fiscal_Year__c;
        insert oppyPartForecast; 
        
        list<Opportunity_Part_Forecast__c> list_opportunityPart2delete = new list<Opportunity_Part_Forecast__c>();
        list_opportunityPart2delete.add(oppyPartForecast);
        
        Opportunity_Part_Forecast__c oppyPartForecast2 = new Opportunity_Part_Forecast__c();
        oppyPartForecast2.Name = 'testOppyPartForecast2';
        oppyPartForecast2.Opportunity_Part__c = oppypart.Id;
        oppyPartForecast2.Opportunity_Forecast__c = oppyForecast1.Id;
        oppyPartForecast2.Month__c = decimal.valueOf(oppyForecast1.Fiscal_Month__c);
        oppyPartForecast2.Year__c = oppyForecast1.Fiscal_Year__c;
        list<Opportunity_part_Forecast__c> list_opportunityPart2Insert = new list<Opportunity_part_Forecast__c>();
        list_opportunityPart2Insert.add(oppyPartForecast2);
        System.enqueueJob(new ClsOppyPartForecastDeleteQueue(list_opportunityPart2delete,list_opportunityPart2Insert));
        Test.stopTest();
        Opportunity_Part_Forecast__c OPFAssert = [SELECT Opportunity_Part__c FROM Opportunity_Part_Forecast__c];
        System.assert(OPFAssert.Opportunity_Part__c == oppypart.Id);
    }
}