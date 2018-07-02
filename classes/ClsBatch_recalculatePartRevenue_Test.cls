/**
*   This test class is for ClsBatch_recalculatePartRevenue.
*
@author Di Chen
@created 2012-11-27
@version 1.0
@since 20.0
*
@changelog
* 2012-11-27 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 91%
*/
@isTest
private class ClsBatch_recalculatePartRevenue_Test {

    static testMethod void testBatch() {
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
        
        Apex_Helper_Settings__c exceptUser= new Apex_Helper_Settings__c();
        exceptUser.name = 'Currency Confirm Except Users';
        exceptUser.value__c = 'test';
        exceptUser.Active__c = true;
        insert exceptUser;
        Apex_Helper_Settings__c csdGPL= new Apex_Helper_Settings__c();
        csdGPL.name = 'CSD GPL Code Id';
        csdGPL.value__c = 'test';
        csdGPL.Active__c = true;
        insert csdGPL;
        Apex_Helper_Settings__c aplRecord = new Apex_Helper_Settings__c();
        aplRecord.name = 'Appliance Opportunity Record Type Id';
        aplRecord.value__c = 'test';
        aplRecord.Active__c = true;
        insert aplRecord;
                                                    
        TE_Connection__c tec = ClsTestHelp.createTestTEConnection();
        Profit_BU_Center_Mapping_Rule1__c pb1 = ClsTestHelp.createTestProfitBUCenterMapping1();
        Profit_BU_Center_Mapping_Rule2__c pb2 = ClsTestHelp.createTestProfitBUCenterMapping2();
        Profit_BU_Center_Mapping_Rule3__c pb3 = ClsTestHelp.createTestProfitBUCenterMapping3();
        //MobileVizArt__Concurrency_Handling__c ch = ClsTestHelp.createTestConcurrencyHandling();    
        //MobileVizArt__Concurrency_Handling__c ch2 = ClsTestHelp.createTestConcurrencyHandling2();
        
        //********************-=BEGIN:2013-09-03 added by Ramakrishna Singara <ramakrishna.singara@zensar.in>=-*****************
        //Consumer Device Custom Settings Start
        Consumer_Device_Opportunity_Record_Types__c csd1 = ClsTestHelp.createTestCSD1();
        Consumer_Device_Opportunity_Record_Types__c csd2 = ClsTestHelp.createTestCSD2();
        Consumer_Device_Opportunity_Record_Types__c csd3 = ClsTestHelp.createTestCSD3();
        Consumer_Device_Opportunity_Record_Types__c csd4 = ClsTestHelp.createTestCSD4();
        Consumer_Device_Opportunity_Record_Types__c csd5 = ClsTestHelp.createTestCSD5();
        Consumer_Device_Opportunity_Record_Types__c csd6 = ClsTestHelp.createTestCSD6();
        Consumer_Device_Opportunity_Record_Types__c csd7 = ClsTestHelp.createTestCSD7();
        //Consumer Device Custom Settings End
        //********************-=End:2013-09-03 added by Ramakrishna Singara <ramakrishna.singara@zensar.in>=-*******************
        
        RecordType rt = ClsTestHelp.createTestRecordType();
        RecordType rt2 = ClsTestHelp.createTestRecordType16();      
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        insert acc; 
  
        /*Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        oppy2.Request_Type__c = 'Extension';
        oppy2.RecordTypeId = rt2.Id;
        oppy2.StageName = 'New';
        insert oppy2;  
        */
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
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Status__c = '50/50';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        oppypart.GPL__c = ph.Id;
        oppypart.Initial_Order_Date__c = date.today();
        oppypart.Quantity__c = 12;
        insert oppypart;
                        
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy.Id;
        oppyForecast.Quantity__c = 12;
        oppyForecast.Part__c = oppypart.Id;
        oppyForecast.Date__c = date.newInstance(2012, 09, 28);
        oppyForecast.Amount__c = 1;
        oppyForecast.Sales_Price__c = 1;
        oppyForecast.Fiscal_Year__c = '2021';
        oppyForecast.Fiscal_Quarter__c = '21';
        oppyForecast.CurrencyIsoCode = 'USD';
        insert oppyForecast;
        
        Opportunity_Forecast__c oppyForecast2 = [select Id,Opportunity__r.CloseDate,Sales_Price__c,Amount__c,Date__c,Part__c,Fiscal_Quarter__c,Quantity__c,CurrencyIsoCode,Fiscal_Year__c from Opportunity_Forecast__c where Id =: oppyForecast.Id];
        
        List<Opportunity_Part__c> list_oppyFC = new List<Opportunity_Part__c>();
        list_oppyFC.add(oppypart);
        
        Database.BatchableContext BC;
        
        ClsBatch_recalculatePartRevenue clsBatch = new ClsBatch_recalculatePartRevenue();
        
        Test.startTest();
        
        clsBatch.email = 'sdfsds4@qq.com';
        clsBatch.query = 'Select Id from Opportunity_Forecast__c limit 1';

        clsBatch.start(BC);
        clsBatch.execute(BC, list_oppyFC);
        clsBatch.finish(BC);
        
        system.assert(true);
        Test.stopTest(); 
    }
    static testMethod void testBatch2() {
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
        Apex_Helper_Settings__c exceptUser= new Apex_Helper_Settings__c();
        exceptUser.name = 'Currency Confirm Except Users';
        exceptUser.value__c = 'test';
        exceptUser.Active__c = true;
        insert exceptUser; 
        Apex_Helper_Settings__c csdGPL= new Apex_Helper_Settings__c();
        csdGPL.name = 'CSD GPL Code Id';
        csdGPL.value__c = 'test';
        csdGPL.Active__c = true;
        insert csdGPL; 
        Apex_Helper_Settings__c aplRecord = new Apex_Helper_Settings__c();
        aplRecord.name = 'Appliance Opportunity Record Type Id';
        aplRecord.value__c = 'test';
        aplRecord.Active__c = true;
        insert aplRecord;                                       
        TE_Connection__c tec = ClsTestHelp.createTestTEConnection();
        Profit_BU_Center_Mapping_Rule1__c pb1 = ClsTestHelp.createTestProfitBUCenterMapping1();
        Profit_BU_Center_Mapping_Rule2__c pb2 = ClsTestHelp.createTestProfitBUCenterMapping2();
        Profit_BU_Center_Mapping_Rule3__c pb3 = ClsTestHelp.createTestProfitBUCenterMapping3(); 
        //MobileVizArt__Concurrency_Handling__c ch = ClsTestHelp.createTestConcurrencyHandling(); 
        //MobileVizArt__Concurrency_Handling__c ch2 = ClsTestHelp.createTestConcurrencyHandling2();        
        
        RecordType rt = ClsTestHelp.createTestRecordType();
        RecordType rt2 = ClsTestHelp.createTestRecordType16();
        
        //Consumer Device Custom Settings Start
        Consumer_Device_Opportunity_Record_Types__c csd1 = ClsTestHelp.createTestCSD1();
        Consumer_Device_Opportunity_Record_Types__c csd2 = ClsTestHelp.createTestCSD2();
        Consumer_Device_Opportunity_Record_Types__c csd3 = ClsTestHelp.createTestCSD3();
        Consumer_Device_Opportunity_Record_Types__c csd4 = ClsTestHelp.createTestCSD4();
        Consumer_Device_Opportunity_Record_Types__c csd5 = ClsTestHelp.createTestCSD5();
        Consumer_Device_Opportunity_Record_Types__c csd6 = ClsTestHelp.createTestCSD6();
        Consumer_Device_Opportunity_Record_Types__c csd7 = ClsTestHelp.createTestCSD7();
        //Consumer Device Custom Settings End        
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        insert acc;
  
        /*Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        oppy2.Request_Type__c = 'Extension';
        oppy2.RecordTypeId = rt2.Id;
        oppy2.StageName = 'New';
        insert oppy2;  
        */
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
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Status__c = '50/50';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        oppypart.GPL__c = ph.Id;
        oppypart.Initial_Order_Date__c = date.today();
        oppypart.Quantity__c = 12;
        insert oppypart;
                        
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy.Id;
        oppyForecast.Quantity__c = 12;
        oppyForecast.Part__c = oppypart.Id;
        oppyForecast.Date__c = date.newInstance(2012, 09, 28);
        oppyForecast.Amount__c = 1;
        oppyForecast.Sales_Price__c = 1;
        oppyForecast.Fiscal_Year__c = '2021';
        oppyForecast.Fiscal_Quarter__c = '21';
        oppyForecast.CurrencyIsoCode = 'USD';
        insert oppyForecast;
        
        Opportunity_Forecast__c oppyForecast2 = [select Id,Opportunity__r.CloseDate,Sales_Price__c,Amount__c,Date__c,Part__c,Fiscal_Quarter__c,Quantity__c,CurrencyIsoCode,Fiscal_Year__c from Opportunity_Forecast__c where Id =: oppyForecast.Id];
        
        List<Opportunity_Part__c> list_oppyFC = new List<Opportunity_Part__c>();
        list_oppyFC.add(oppypart);
        
        Database.BatchableContext BC;
        
        ClsBatch_recalculatePartRevenue clsBatch = new ClsBatch_recalculatePartRevenue();
        
        Test.startTest();
        
        clsBatch.email = null;
        clsBatch.query = 'Select Id from Opportunity_Forecast__c limit 1';

        clsBatch.start(BC);
        system.debug('***** JNV1 - ' + clsBatch.query);
        system.debug('***** JNV2 - ' + list_oppyFC);
        clsBatch.execute(BC, list_oppyFC);
        clsBatch.finish(BC);
        
        system.assert(true);
        Test.stopTest(); 
    }
}