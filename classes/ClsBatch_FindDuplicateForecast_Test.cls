/**
*  This test class used to test class ClsBatch_populateSIPDataFromReport.
*
@author Bin Yuan
@created 2014-09-28
@version 1.0
@since 30.0
*
@changelog
* coverage 85% 
* 
* 
2014-09-28 Bin Yuan <bin.yuan@itbconsult.com>
* - Created
*/
@isTest (SeeAllData = false)
private class ClsBatch_FindDuplicateForecast_Test {
    static testMethod void myUnitTest() {
        Test.startTest();   
        
        RecordType rt2 = ClsTestHelp.createTestRecordType10();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        
        Opportunity duplicateoppy = new Opportunity();
            duplicateoppy.StageName = 'Approved/Active';
            duplicateoppy.Name = 'SandKing';
            duplicateoppy.CloseDate = date.today();
            duplicateoppy.Manufacturing_Start_Date__c = date.today().addMonths(1);
            duplicateoppy.RecordTypeId = rt2.Id; 
            duplicateoppy.StageName = 'New';
            duplicateoppy.Mass_prod_Status__c = true; 
            duplicateoppy.currency_confirm__c = true;          
            insert duplicateoppy;
        
        Product_Hierarchy__c duplicateph = new Product_Hierarchy__c();
            duplicateph.Hierarchy_Level_Type__c = 'CBC1';
            duplicateph.Description__c = 'Industrial';
            insert duplicateph;
        
        Part__c duplicatePart = new Part__c();
            duplicatePart.Description__c = 'Sniper';
            duplicatePart.Product_Hierarchy__c = duplicateph.Id;
            duplicatePart.Market_Date__c = date.today();
            insert duplicatePart;
            
        Opportunity_Part__c duplicateOppyPart = ClsTestHelp.createTestOpportunityPart();
            duplicateOppyPart.Opportunity__c = duplicateoppy.Id;
            duplicateOppyPart.Part__c = duplicatePart.Id;
            insert duplicateOppyPart;
        
        List<Opportunity_Forecast__c> lst_oppyf = new List<Opportunity_Forecast__c>();
        
        Opportunity_Forecast__c oppyForecast1 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast1.Opportunity__c = duplicateoppy.Id;
            oppyForecast1.Quantity__c = 12;
            oppyForecast1.Part__c = duplicateOppyPart.Id;
            oppyForecast1.Fiscal_Year__c = '2015';
            oppyForecast1.Fiscal_Quarter__c = '1';
            oppyForecast1.Date__c = date.parse('03/28/2015');
            oppyForecast1.Amount__c = 1;
            //insert oppyForecast1;                        
            lst_oppyf.add(oppyForecast1);
        
        Opportunity_Forecast__c oppyForecast5 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast5.Opportunity__c = duplicateoppy.Id;
            oppyForecast5.Quantity__c = 12;
            oppyForecast5.Part__c = duplicateOppyPart.Id;
            oppyForecast5.Fiscal_Year__c = '2015';
            oppyForecast5.Fiscal_Quarter__c = '1';
            oppyForecast5.Date__c = date.parse('03/28/2015');
            oppyForecast5.Amount__c = 1;
            //insert oppyForecast5;
            lst_oppyf.add(oppyForecast5);
                
        Opportunity_Forecast__c oppyForecast2 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast2.Opportunity__c = duplicateoppy.Id;
            oppyForecast2.Quantity__c = 12;
            oppyForecast2.Part__c = duplicateOppyPart.Id;
            oppyForecast2.Fiscal_Year__c = '2015';
            oppyForecast2.Fiscal_Quarter__c = '2';
            oppyForecast2.Date__c = date.parse('06/27/2015');
            oppyForecast2.Amount__c = 1;
            //insert oppyForecast2;
            lst_oppyf.add(oppyForecast2);
        
        Opportunity_Forecast__c oppyForecast6 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast6.Opportunity__c = duplicateoppy.Id;
            oppyForecast6.Quantity__c = 12;
            oppyForecast6.Part__c = duplicateOppyPart.Id;
            oppyForecast6.Fiscal_Year__c = '2015';
            oppyForecast6.Fiscal_Quarter__c = '2';
            oppyForecast6.Date__c = date.parse('06/27/2015');
            oppyForecast6.Amount__c = 1;
            //insert oppyForecast6;
            lst_oppyf.add(oppyForecast6);
        
        Opportunity_Forecast__c oppyForecast3 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast3.Opportunity__c = duplicateoppy.Id;
            oppyForecast3.Quantity__c = 12;
            oppyForecast3.Part__c = duplicateOppyPart.Id;
            oppyForecast3.Fiscal_Year__c = '2015';
            oppyForecast3.Fiscal_Quarter__c = '3';
            oppyForecast3.Date__c = date.parse('09/26/2015');
            oppyForecast3.Amount__c = 1;
            //insert oppyForecast3;
            lst_oppyf.add(oppyForecast3);
        
        Opportunity_Forecast__c oppyForecast7 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast7.Opportunity__c = duplicateoppy.Id;
            oppyForecast7.Quantity__c = 12;
            oppyForecast7.Part__c = duplicateOppyPart.Id;
            oppyForecast7.Fiscal_Year__c = '2015';
            oppyForecast7.Fiscal_Quarter__c = '3';
            oppyForecast7.Date__c = date.parse('09/26/2015');
            oppyForecast7.Amount__c = 1;
            //insert oppyForecast7;
            lst_oppyf.add(oppyForecast7);
            insert lst_oppyf;
        /*    
        Opportunity_Forecast__c oppyForecast4 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast4.Opportunity__c = duplicateoppy.Id;
            oppyForecast4.Quantity__c = 12;
            oppyForecast4.Part__c = duplicateOppyPart.Id;
            oppyForecast4.Fiscal_Year__c = '2015';
            oppyForecast4.Fiscal_Quarter__c = '4';
            oppyForecast4.Date__c = date.parse('12/26/2015');
            oppyForecast4.Amount__c = 1;
            insert oppyForecast4;
            lst_oppyf.add(oppyForecast4);            
        
        Opportunity_Forecast__c oppyForecast8 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast8.Opportunity__c = duplicateoppy.Id;
            oppyForecast8.Quantity__c = 12;
            oppyForecast8.Part__c = duplicateOppyPart.Id;
            oppyForecast8.Fiscal_Year__c = '2015';
            oppyForecast8.Fiscal_Quarter__c = '4';
            oppyForecast8.Date__c = date.parse('12/26/2015');
            oppyForecast8.Amount__c = 1;
            insert oppyForecast8;
            lst_oppyf.add(oppyForecast8);
       */ 
      //  insert lst_oppyf;
        

        ClsBatch_FindDuplicateForecast cls = new ClsBatch_FindDuplicateForecast();
        
        Database.BatchableContext BC;
        
        cls.execute(BC, lst_oppyf );
        
        cls.start(BC);
        
        cls.finish(BC);
       
        Test.stopTest();
    }
}