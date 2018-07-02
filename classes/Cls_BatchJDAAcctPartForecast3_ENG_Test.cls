/**
 * This class used to test Cls_BatchJDAAccountPartForecast3_ENG.cls.
 * 
 * @author		Yiming Shen
 * @created		2017-12-14
 * @since 		37.0 (Force.com ApiVersion)
 * @version 	1.0
 * 
 * @changelog
 * 2017-12-14 Yiming Shen <yiming.shen@capgemini.com>
 * - Created
 * 
 */
@isTest
private class Cls_BatchJDAAcctPartForecast3_ENG_Test {
	@testSetup static void createConfig(){
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        Channelinsightdata_test.Channelinsightdata_test();
        ClsTestCustomSettingHelper.getADMTerritoryCode();
        ClsTestHelp.createTestOPTG4();
    }
    
    static testMethod void myUnitTest() {
        Account acct = ClsTestHelp.createTestAccounts();
        acct.Type = 'Other';
        acct.AccountNumber = '654321';
        acct.LAYER2_ORGANIZATION_ID__c = '0001';
        acct.INDUSTRY_BUSINESS_CDE__c = '511'; 
        acct.DD1_Industry_Business_Code__c = '401';
        acct.DD2_Industry_Business_Code__c = '302';
        insert acct;
        Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial1';
        ph.GPL_Description__c = 'GPL1'; 
        insert ph;
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.AccountId = acct.Id;   
        oppy.Type = 'New Business';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Is_Base_Business__c = true;
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        insert oppy;
        Part__c part = ClsTestHelp.createTestPart();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        part.GPL__c = ph.Id;
        insert part;
        Test.startTest();
        Opportunity_Part__c oppypart = ClsTestHelp.createTestEnergyOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = part.Id;
        oppypart.Offered_Price__c = 20;
        oppypart.Quantity__c = 10;
        insert oppypart;
        Period currPeriod = [
                select Id, FiscalYearSettings.Name, PeriodLabel
                from Period
                where StartDate <= :System.today() and EndDate >= :System.today() and Type = 'Month'
                limit 1
        ];
        Integer currentYear = Integer.valueOf (currPeriod.FiscalYearSettings.Name);
        Integer currentMonth = Integer.valueOf(Cls_BatchJDAAccountPartForecast3_ENG.MAP_MONTHLABELNUMBER.get(currPeriod.PeriodLabel));
        Opportunity_Forecast__c oppyForecast1 = ClsTestHelp.createTestENGOpportunityForecasts();
        oppyForecast1.Opportunity__c = oppy.Id;
        oppyForecast1.Part__c = oppypart.Id;
        oppyForecast1.Amount__c = 100;
        oppyForecast1.CurrencyIsoCode = 'USD';
        //oppyForecast1.Confidence_Level__c = '80';
        oppyForecast1.Confidence_Level__c = '30';
        oppyForecast1.Fiscal_Month__c = String.valueOf(currentMonth + 1);
        oppyForecast1.Fiscal_Year__c = String.valueOf(currentYear);
        insert oppyForecast1;
        
        Integer todayYearAndMonth = currentYear * 100 + currentMonth;
        Integer months = math.mod(todayYearAndMonth, 100);
        Integer years = todayYearAndMonth / 100;
        months += 6;
        years += 1;
        if (months > 12) {
            years += 1;
            months -= 12;
        }
        Integer eighteenMonthsFromNow = years * 100 + months;
        Opportunity_Part_Forecast__c oppyPartForecast = ClsTestHelp.createTestOpportunityPartForecast();
        oppyPartForecast.Name = 'testOppPartForecast' + system.now();
        oppyPartForecast.Opportunity_Part__c = oppypart.Id;
        oppyPartForecast.Opportunity_Forecast__c = oppyForecast1.Id;
        oppyPartForecast.Month__c = decimal.valueOf(oppyForecast1.Fiscal_Month__c);
        oppyPartForecast.Year__c = oppyForecast1.Fiscal_Year__c;
        oppyPartForecast.year_and_month__c = todayYearAndMonth + 60;
        insert oppyPartForecast;
        Database.executeBatch(new Cls_BatchJDAAccountPartForecast3_ENG(), 20);
        Test.stopTest();
    }
    
    static testMethod void myUnitTest2() {
        Account acct = ClsTestHelp.createTestAccounts();
        acct.Type = 'CM';
        acct.AccountNumber = '123456';
        acct.LAYER2_ORGANIZATION_ID__c = '0002';
        acct.INDUSTRY_BUSINESS_CDE__c = '115'; 
        acct.DD1_Industry_Business_Code__c = '104';
        acct.DD2_Industry_Business_Code__c = '203';
        insert acct;
        Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
        ph.Hierarchy_Level_Type__c = 'GPL';
        ph.Description__c = 'Industrial2'; 
        ph.GPL_Description__c = 'GPL2'; 
        insert ph;
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.AccountId = acct.Id;   
        oppy.Type = 'Sales Projects';
        oppy.Request_Type__c = 'Sales Only';
        oppy.Method__c = 'Manual';
        oppy.Level__c = 'Quarterly';
        oppy.Is_Base_Business__c = true;
        oppy.Amount = 100;
        oppy.CurrencyIsoCode = 'USD';
        oppy.Five_Year_Revenue__c = 1;
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        insert oppy;
        Part__c part = ClsTestHelp.createTestPart();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        part.GPL__c = ph.Id;
        insert part;
        Test.startTest();
        Opportunity_Part__c oppypart = ClsTestHelp.createTestEnergyOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = part.Id;
        oppypart.Offered_Price__c = 20;
        oppypart.Quantity__c = 10;
        insert oppypart;
        Period currPeriod = [
                select Id, FiscalYearSettings.Name, PeriodLabel
                from Period
                where StartDate <= :System.today() and EndDate >= :System.today() and Type = 'Month'
                limit 1
        ];
        Integer currentYear = Integer.valueOf (currPeriod.FiscalYearSettings.Name);
        Integer currentMonth = Integer.valueOf(Cls_BatchJDAAccountPartForecast3_ENG.MAP_MONTHLABELNUMBER.get(currPeriod.PeriodLabel));
        Opportunity_Forecast__c oppyForecast1 = ClsTestHelp.createTestENGOpportunityForecasts();
        oppyForecast1.Opportunity__c = oppy.Id;
        oppyForecast1.Part__c = oppypart.Id;
        oppyForecast1.Amount__c = 100;
        oppyForecast1.CurrencyIsoCode = 'USD';
        //oppyForecast1.Confidence_Level__c = '80';
        oppyForecast1.Confidence_Level__c = '30';
        oppyForecast1.Fiscal_Month__c = String.valueOf(currentMonth + 1);
        oppyForecast1.Fiscal_Year__c = String.valueOf(currentYear);
        insert oppyForecast1;
        
        Integer todayYearAndMonth = currentYear * 100 + currentMonth;
        Integer months = math.mod(todayYearAndMonth, 100);
        Integer years = todayYearAndMonth / 100;
        months += 6;
        years += 1;
        if (months > 12) {
            years += 1;
            months -= 12;
        }
        Integer eighteenMonthsFromNow = years * 100 + months;
        Opportunity_Part_Forecast__c oppyPartForecast = ClsTestHelp.createTestOpportunityPartForecast();
        oppyPartForecast.Name = 'testOppPartForecast' + system.now();
        oppyPartForecast.Opportunity_Part__c = oppypart.Id;
        oppyPartForecast.Opportunity_Forecast__c = oppyForecast1.Id;
        oppyPartForecast.Month__c = decimal.valueOf(oppyForecast1.Fiscal_Month__c);
        oppyPartForecast.Year__c = oppyForecast1.Fiscal_Year__c;
        oppyPartForecast.year_and_month__c = todayYearAndMonth + 60;
        insert oppyPartForecast;
        System.assert(oppyPartForecast.Id != null);
        Database.executeBatch(new Cls_BatchJDAAccountPartForecast3_ENG(), 20);
        Test.stopTest();
    }
}