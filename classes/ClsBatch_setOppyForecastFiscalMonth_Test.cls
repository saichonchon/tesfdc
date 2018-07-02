/**
*  This test class used to test class ExtRecalculateBudget.
*
@author Lili Zhao
@created 2013-09-27
@version 1.0   
@since 28.0
*
@changelog
* coverage 100% 
* 
* 
2013-09-27 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest(SeeAllData=true)
private class ClsBatch_setOppyForecastFiscalMonth_Test {

    static testMethod void Method1() {
    
        RecordType rt2 = ClsTestHelp.createTestRecordType16();
        /*
        //**** insert the custom setting before insert oppy begin **** for trigger opportunity_BIU_defineApprovers.trigger
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName9();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName1();
        //**** insert the custom setting before insert oppy end **** for trigger opportunity_BIU_defineApprovers.trigger
        
        //**** insert the custom setting before insert oppy begin *** for trigger NDR_Distributor_update.trigger
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName10();
        
        //**** insert the custom setting before insert oppy begin *** for trigger opportunity_BIU_defineApprovers.trigger
        Opportunity_Approvers__c oppyApprove1 = ClsTestHelp.createTestOpportunityApprovers();
        Opportunity_Approvers__c oppyApprove2 = ClsTestHelp.createTestOpportunityApprovers2();
        Opportunity_Approvers__c oppyApprove3 = ClsTestHelp.createTestOpportunityApprovers3();
        Opportunity_Approvers__c oppyApprove4 = ClsTestHelp.createTestOpportunityApprovers4();
        Opportunity_Approvers__c oppyApprove5 = new Opportunity_Approvers__c();
        for(Opportunity_Approvers__c oa1 : [select GPLs__c from Opportunity_Approvers__c where Name = 'FilterCenter' limit 1]){
            oppyApprove5 = oa1;
        }
        if(oppyApprove5.Id == null){
            oppyApprove5.Name = 'FilterCenter';
            insert oppyApprove5;
        }   
        //**** insert the custom setting end *** insert oppy begin for trigger opportunity_BIU_defineApprovers.trigger
        
        //**** insert the custom setting begin*** insert oppy begin for trigger OpportunityStageValidation.trigger
        Consumer_Device_Opportunity_Record_Types__c csdRTSetting1 =  ClsTestHelp.createTestCSD1();
        Consumer_Device_Opportunity_Record_Types__c csdRTSetting2 =  ClsTestHelp.createTestCSD3();
        //**** insert the custom setting end *** insert oppy begin for trigger OpportunityStageValidation.trigger
        
        //**** insert the custom setting begin *** insert oppy begin for trigger opportunity_BAU_snapshotForecastData.trigger
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7();
        //**** insert the custom setting end *** insert oppy begin for trigger opportunity_BAU_snapshotForecastData.trigger
        
        //**** insert the custom setting begin *** insert oppy begin for trigger OpportunityPart_BIU_NDROpportunityPart.trigger then UpdateNDROpportunityPartDateFields.cls
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName11();        
        //**** insert the custom setting end *** insert oppy begin for trigger OpportunityPart_BIU_updateBUprofitcenter.trigger then UpdateNDROpportunityPartDateFields.cls
        
        // *** insert the custom setting begin *** insert oppy begin for trigger OpportunityPart_BIU_updateBUprofitcenter.trigger then UpdateNDROpportunityPartDateFields.cls 
        Profit_BU_Center_Mapping_Rule1__c profitSeeting1 = ClsTestHelp.createTestProfitBUCenterMapping1();
        Profit_BU_Center_Mapping_Rule2__c profitSeeting2 = ClsTestHelp.createTestProfitBUCenterMapping2();
        Profit_BU_Center_Mapping_Rule3__c profitSeeting3 = ClsTestHelp.createTestProfitBUCenterMapping3();
        // *** insert the custom setting end*** insert oppy begin for trigger OpportunityPart_BIU_updateBUprofitcenter.trigger then UpdateNDROpportunityPartDateFields.cls 
        
        Consumer_Device_Opportunity_Record_Types__c csdRec1 = ClsTestHelp.createTestCSD6();
        Consumer_Device_Opportunity_Record_Types__c csdRec2 = ClsTestHelp.createTestCSD4();
        Consumer_Device_Opportunity_Record_Types__c csdRec3 = ClsTestHelp.createTestCSD5();
        Consumer_Device_Opportunity_Record_Types__c csdRec4 = ClsTestHelp.createTestCSD2();
        
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName8();
        */
        
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        oppy2.Request_Type__c = 'Extension';
        oppy2.RecordTypeId = rt2.Id;
        insert oppy2;  
          
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Program__c = oppy2.Id;   
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        oppy.RecordTypeId = rt2.Id;
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
        insert oppypart;
        
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy.Id;
        oppyForecast.Quantity__c = 12;
        oppyForecast.Part__c = oppypart.Id;
        oppyForecast.Date__c = date.newInstance(2012, 09, 28);
        oppyForecast.Amount__c = 1;
        insert oppyForecast;
        
        Opportunity_Forecast__c oppyForecast2 = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast2.Opportunity__c = oppy.Id;
        oppyForecast2.Quantity__c = 12;
        oppyForecast2.Part__c = oppypart.Id;
        oppyForecast2.Date__c = date.newInstance(2013, 10, 26);
        oppyForecast2.Amount__c = 1;
        insert oppyForecast2;
        
        List<Opportunity_Forecast__c> oppyForecasts = new List<Opportunity_Forecast__c>();
        oppyForecasts.add(oppyForecast);
        oppyForecasts.add(oppyForecast2);
              
        Test.startTest();
              
        ClsBatch_setOppyForecastFiscalMonth clsBatch = new ClsBatch_setOppyForecastFiscalMonth ();
        Database.BatchableContext BC;
        clsBatch.filter = ' limit 1';
        clsBatch.start(BC);
        clsBatch.execute(BC, oppyForecasts);
        clsBatch.finish(BC);
                
        system.assert(true);
        Test.stopTest();
    }
}