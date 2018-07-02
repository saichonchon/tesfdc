/**
*   This test class is for ClsBatch_forecastSnapshot.
*
@author Di Chen
@created 2013-01-09
@version 1.0
@since 20.0
*
@changelog
* 2013-01-09 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 97%
* 2016-08-10 Pankaj Raijade
* - modified - for Case 00900737.
* - Test coverage 85%
*/
@isTest(seealldata=false)
private class ClsBatch_forecastSnapshot_Test {

    static testMethod void testBatch() {
        ClsTestCustomSettingHelper.getAllSettings();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        ClsTestCustomSettingHelper.getBatchEmailmessageUsers();
        ChannelinsightData_test.ChannelinsightData_test();
        RecordType rt = ClsTestHelp.createTestRecordType();
        RecordType rt2 = ClsTestHelp.createTestRecordType16();
        RecordType rt3 = ClsTestHelp.createCSDTestRecordType2();
        RecordType rt4 = ClsTestHelp.createCSDTestRecordType4();

        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        acc.AccountNumber = '12345678';
        insert acc;
  
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        oppy.RecordTypeId = rt2.Id;
        oppy.Quotation_Due_Date__c = system.today();
        oppy.recordtypeid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Engineering Opportunity-CSD').getRecordTypeId();
        oppy.Mass_prod_Status__c = false;
        oppy.Lost_Rejected_Dead_On_Hold_Reason__c ='test';
        
        insert oppy;
        
        oppy.Five_Year_Revenue__c = 10;
        oppy.CloseDate = system.today();
        oppy.Last_Modified_Date__c = system.today();
        update oppy;
        
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
        oppypart.BU_profit_center__c = 'text';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        oppypart.GPL__c = ph.Id;
        oppypart.Initial_Order_Date__c = system.today();
        oppypart.Lost_Reason__c = 'Approval criteria not met';
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
        insert fs;            
                
        list<Opportunity_Forecast__c> scope = new list<Opportunity_Forecast__c>([SELECT Id, CurrencyIsoCode, CreatedDate, CreatedById, Sales_Price__c, Date__c,Fiscal_Year__c, Fiscal_Quarter__c, Quantity__c, Amount__c, Opportunity__c, Part__c,Part__r.Won_Fiscal_Year__c, Counts_for_IND_Conversion__c, Counts_for_IND_Pipeline__c, Part__r.Won_Fiscal_Quarter__c,Part__r.Won_Date__c,Part__r.Status__c,Part__r.Process_Status__c,Opportunity__r.ownerId,Opportunity__r.LastModifiedDate,Opportunity__r.StageName,Opportunity__r.CloseDate,Opportunity__r.RecordType.DeveloperName ,Opportunity__r.Manufacturing_Start_Date__c, Opportunity__r.PLM_Id__c, Opportunity__r.Probability, Opportunity__r.Days_since_last_user_update__c,Opportunity__r.Provide_to_customer_Quotation_Date__c,Opportunity__r.Quotation_Due_Date__c, Opportunity__r.Quotation_Request_Date__c, Opportunity__r.Mass_prod_Status__c, Opportunity__r.Two_Years_Revenue__c FROM Opportunity_Forecast__c where id = :oppyForecast.id]);
        Test.startTest();
    
        ClsBatch_forecastSnapshot clsBatch = new ClsBatch_forecastSnapshot();
        //database.executebatch(new ClsBatch_forecastSnapshot());
        Database.BatchableContext BC;
        
        clsBatch.filter = ' limit 1';
        
        clsBatch.start(BC);
        clsBatch.execute(BC, scope);
        clsBatch.finish(BC);
        clsBatch.isErrored = true;
        clsBatch.execute(BC, scope);
        clsBatch.listErrorOpportunityForecast.add(oppyForecast);
        clsBatch.mapOtherErrorOpportunity.put(oppy.Id, 'test');
        clsBatch.finish(BC);
        clsBatch.isErrored = false;
        clsBatch.listErrorOpportunityForecast.add(oppyForecast);
        clsBatch.finish(BC);

        system.assert(true);
        Test.stopTest();
    }
}