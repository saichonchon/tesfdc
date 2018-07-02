/***********************************************************************************************************************
Name: ClsBatch_deleteForecastSnapshot_Test 
========================================================================================================================
Purpose: This test class is for ClsBatch_deleteForecastSnapshot.                                                  
========================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                            
------------------------------------------------------------------------------------------------------------------------
1.0    Mrunal            09/10/2015     Initial Development
                                        Test Coverage = 100%     
***********************************************************************************************************************/

@isTest(seeAllData = FALSE)
private class ClsBatch_deleteForecastSnapshot_Test {

    static testMethod void testBatch() {
        
        RecordType rt2 = ClsTestHelp.createTestRecordType11();
        RecordType fsrt1 = ClsTestHelp.createTestRecordType18();
        
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getTimeframeSetting();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        Channelinsightdata_test.Channelinsightdata_test();
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Type = 'CM';
        oppy.StageName= 'Approved/Active';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.currency_confirm__c = true;
        oppy.Five_Year_Revenue__c = 1;
        oppy.RecordTypeId = rt2.Id;
        oppy.Quotation_Due_Date__c = system.today();
        insert oppy;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
         
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = part.Id;
        oppypart.Status__c = 'Lost';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        oppypart.GPL__c = ph.Id;
        oppypart.Initial_Order_Date__c = system.today();
        insert oppypart;
    
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy.Id;
        oppyForecast.Quantity__c = 12;
        oppyForecast.Part__c = oppypart.Id;
        oppyForecast.Date__c = system.today();
        oppyForecast.Amount__c = 1;
        oppyForecast.Sales_Price__c = 1;
        oppyForecast.Fiscal_Year__c = string.valueOf(system.today().year());
        oppyForecast.Fiscal_Quarter__c = '21';
        oppyForecast.CurrencyIsoCode = 'USD';
        insert oppyForecast;
    
        Forecast_Snapshot__c fs = new Forecast_Snapshot__c();
        fs.Opportunity__c = oppy.Id;
        fs.Opportunity_Stage__c = 'Won - Open';
        fs.Snapshot_Type__c = 'Monthly';
        fs.RecordTypeId = fsrt1.Id;
        fs.createdDate = system.today().addMonths(-4);
        //fs.createdDate = date.newInstance(2016, 5, 23);
        insert fs;
        
        list<Forecast_Snapshot__c> list_forecastSnapshot = new list<Forecast_Snapshot__c>();
        list_forecastSnapshot.add(fs);

        Test.startTest();
        ClsBatch_deleteForecastSnapshot clsBatch = new ClsBatch_deleteForecastSnapshot();
        clsBatch.email = 'mrunal.parate@te.com';
        database.executebatch(clsBatch);
        Test.stopTest();
    }
}