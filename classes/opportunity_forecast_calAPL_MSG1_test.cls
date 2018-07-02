/**
*  This used as test class for Opportunity_Forecast_AIUBD_updateOppyLastModifiedDate
*
@author Pankaj Raijade
@created 1/2/2016
@changelog

*/
@isTest
public class opportunity_forecast_calAPL_MSG1_test {
    static testMethod void testCase1() {
        ChannelinsightData_test.ChannelinsightData_test();        
        ClsTestCustomSettingHelper.getCSDExceptionEmail();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getSIPRecordTypes();
        ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
        ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
        ClsTestCustomSettingHelper.getLast_Modified_Field_Update_Permission();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        RecordType rt8 = ClsTestHelp.createTestRecordType8();
        RecordType rt2 = ClsTestHelp.createTestRecordType10();
        RecordType rt = ClsTestHelp.createTestRecordType14();
        
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt.Id;
        acc.Type = 'Global Account';
        acc.Industry_Code_Description__c = 'Appliances';
        acc.LEVEL_1_INDUSTRY_CDE__c = '0283';
        insert acc;
        
        Test.startTest();
            
        Opportunity oppy = new Opportunity();
        oppy.StageName = 'New';
        oppy.AccountId = acc.Id;
        oppy.Name = 'SandKing';
        oppy.currency_confirm__c = true;
        oppy.PMV_Type__c = '-None-';
        oppy.CloseDate = date.today();
        oppy.Manufacturing_Start_Date__c = date.today().addMonths(1);
        oppy.RecordTypeId = rt2.Id;             
        oppy.Mass_prod_Status__c = true; 
        insert oppy;
            
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        ph.CBC3__c = '13213';
        insert ph;
            
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        part.Market_Date__c = date.today();
        insert part;
          
        List<Opportunity_Part__c> oppypartList = new List<Opportunity_Part__c>();    
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = part.Id;
        oppypartList.add(oppypart);
            
        Opportunity_Part__c oppypart1 = ClsTestHelp.createTestOpportunityPart();
        oppypart1.Opportunity__c = oppy.Id;            
        oppypartList.add(oppypart1); 
        insert oppypartList;                     
            
        List<Opportunity_Forecast__c> lst_oppyf = new List<Opportunity_Forecast__c>();
            
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy.Id;
        oppyForecast.Quantity__c = 12;
        oppyForecast.Part__c = oppypart.Id;
        oppyForecast.Fiscal_Year__c = String.valueOf(date.today().year());
        oppyForecast.Fiscal_Quarter__c = '4';
        oppyForecast.Date__c = date.today().addMonths(1);
        oppyForecast.Amount__c = 1;
        lst_oppyf.add(oppyForecast);
            
        Opportunity_Forecast__c oppyForecast1 = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast1.Opportunity__c = oppy.Id;
        oppyForecast1.Quantity__c = 12;
        oppyForecast1.Part__c = oppypart.Id;
        oppyForecast1.Fiscal_Year__c = String.valueOf(date.today().year()+1);
        oppyForecast1.Fiscal_Quarter__c = '1';
        oppyForecast1.Date__c = date.today().addMonths(1);
        oppyForecast1.Amount__c = 1;
        lst_oppyf.add(oppyForecast1);
            
        insert lst_oppyf;
        
        oppyForecast1.part__c = null;
        oppyForecast1.nps1__c = 10;
        update oppyForecast1;
        delete oppyForecast1;
        Test.stopTest();
        
    }
}