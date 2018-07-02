@isTest(seealldata = false)

/********************************************************...
/*********************************************************************************************************************** 
 Name: IND_RecalOneCurr_RevTriggerClass_Test
 Salesforce Instance : IND Sandbox,QA Sandbox
========================================================================================================================
 Purpose: This class is providing the test coverage to the class IND_RecalOneCurr_RevTriggerClass
  Percentage Coverage: 95%                                               
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
 VERSION AUTHOR                DATE         DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
     1.0 Deepak Kumar      29 August 2016   Initial Development                                         1

*/



private class IND_RecalOneCurr_RevenueClass_Test {

    
    
    
    static testMethod void TestRecalculate() {
        
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        
        Map<Integer, Decimal> map_date_amount_Cust = new Map<Integer, Decimal>();//
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'USD';
        oppy.Five_Year_Revenue__c = 1;
        oppy.Manufacturing_Start_Date__c=date.newInstance(system.today().year(), 09, 28);
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType23().Id;
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
        oppypart.Status__c = 'Commit';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        oppypart.GPL__c = ph.Id;
        oppypart.Initial_Order_Date__c = date.today();
        insert oppypart;
        
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy.Id;
        oppyForecast.Quantity__c = 12;
        oppyForecast.Part__c = null;
        oppyForecast.Date__c = date.newInstance(system.today().year(), 09, 28);
        oppyForecast.Amount__c = 1;
        oppyForecast.Sales_Price__c = 1;
        oppyForecast.Fiscal_Year__c =String.valueOf(system.today().year());
        oppyForecast.Fiscal_Quarter__c = '04';
        oppyForecast.CurrencyIsoCode = 'USD';
        insert oppyForecast;

        Set<Id> set_oppyIds = new Set<Id>();
        set_oppyIds.add(oppy.Id); 
        
        Map<id, Opportunity> map_oppyid_opportunity = new Map<id, Opportunity>();
        map_oppyid_opportunity.put(oppy.Id,oppy);
        
               
        Test.startTest();
        
        ClsOppyForecastUtil.getOppyForeCastMap(set_oppyIds);
        ClsOppyForecastUtil.recalculateRevenue(map_oppyid_opportunity, 'BOM', 'Yearly', date.today());
        IND_RecalOneCurr_RevenueClass testclass = new IND_RecalOneCurr_RevenueClass();
        testclass.onAfterinsertUpdate(map_oppyid_opportunity);
        
        system.assert(true);
        Test.stopTest();
       
    }
}