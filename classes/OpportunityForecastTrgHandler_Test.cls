/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   A test class for OpportunityForecastTrgHandler.cls.
			   The user story number is W-00145.
Inputs:        
Test Class:    
History
2017-08-22 Yuan Yao <yuan.yao@capgemini.com> created
------------------------------------------------------------*/
@isTest
public class OpportunityForecastTrgHandler_Test {
    @testSetup static void testCreateConfig(){
    	ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        Channelinsightdata_test.Channelinsightdata_test();
        ClsTestCustomSettingHelper.getADMTerritoryCode();
        ClsTestHelp.createTestOPTG4();
        ClsTestCustomSettingHelper.getAllowToSetForecastUSDCurrency();
    }
    
    static testMethod void testForWrongOppyType() {
        User u = ClsTestHelp.createTestUsers();
        insert u;
        System.runAs(u) {
            Account testAcct1 = ClsTestHelp.createTestAccounts();
            testAcct1.AccountNumber = 'test';
            insert testAcct1;
            
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.AccountId = testAcct1.Id;
            oppy2.Currency_Confirm__c = true;
            insert oppy2;
            Opportunity_Part__c oppyPart = ClsTestHelp.createTestEnergyOpportunityPart();
			oppyPart.Opportunity__c = oppy2.Id;
			insert oppyPart;
            
            Integer currentFiscalYear;
            Integer currentFiscalQuarter;
            Integer currentFiscalMonth;
            for(Period currentPeriod : [SELECT EndDate, FiscalYearSettings.Name, Number, Id, PeriodLabel, 
                                        QuarterLabel, StartDate, Type 
                                        FROM Period 
                                        WHERE (Type = 'Year' OR Type = 'Quarter' OR Type = 'Month')  
                                        AND StartDate <=: oppy2.CloseDate 
                                        AND EndDate >=: oppy2.CloseDate ]){
                                            if(currentPeriod.Type == 'Year'){
                                                currentFiscalYear = Integer.valueOf(currentPeriod.FiscalYearSettings.Name);
                                            }else if(currentPeriod.Type == 'Quarter'){
                                                currentFiscalQuarter = currentPeriod.Number;
                                            }else if(currentPeriod.Type == 'Month'){
                                                currentFiscalMonth = ExtOpportunityForecasting.map_MonthAbbr_MonthNumber.get(currentPeriod.PeriodLabel);
                                            } 
            }
            Opportunity_Forecast__c oppyForecast2 = ClsTestHelp.createTestENGOpportunityForecasts();
            oppyForecast2.Opportunity__c = oppy2.Id;
            oppyForecast2.Amount__c = 50;
            oppyForecast2.Confidence_Level__c = '30';
            oppyForecast2.Fiscal_Month__c = String.valueOf(currentFiscalMonth);
            oppyForecast2.Fiscal_Quarter__c = 'Q' + currentFiscalQuarter;
            oppyForecast2.Fiscal_Year__c = String.valueOf(currentFiscalYear);
            Test.startTest();
            insert oppyForecast2;
            Opportunity opp = [Select Id,CurrencyIsoCode,Amount From Opportunity Where id =: oppy2.Id];
            System.assert(opp.amount == null);
            Test.stopTest();
        }
    }
    
    static testMethod void testMethod0() {
    	ClsTestCustomSettingHelper.getTriggerDisableUserIdSetting();
        Account testAcct1 = ClsTestHelp.createTestAccounts();
        testAcct1.AccountNumber = 'test';
        insert testAcct1;
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.AccountId = testAcct1.Id;
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        oppy.Currency_Confirm__c = true;
        oppy.Probability__c = '80';
        insert oppy;
        Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial'; 
        insert ph;
        Part__c part = ClsTestHelp.createTestPart();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        Test.startTest();
        ClsTriggerFactory.setSkipHandler('AccountTrgHandler',true); 
    	ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);
        Opportunity_Part__c oppyPart = ClsTestHelp.createTestEnergyOpportunityPart();
		oppyPart.Opportunity__c = oppy.Id;
		oppyPart.Part__c = part.Id;
		ClsTriggerFactory.setSkipHandler('OpportunityPartTrgHandler',true);
		insert oppyPart;
        Opportunity_Forecast__c oppyForecast1 = ClsTestHelp.createTestENGOpportunityForecasts();
        oppyForecast1.Opportunity__c = oppy.Id;
        oppyForecast1.Amount__c = 50;
        oppyForecast1.CurrencyIsoCode = 'USD';
        oppyForecast1.Confidence_Level__c = '30';
        oppyForecast1.Fiscal_Month__c = '12';
        oppyForecast1.Fiscal_Quarter__c = 'Q4';
        oppyForecast1.Fiscal_Year__c = '2017';
        insert oppyForecast1;
        oppyForecast1.Amount__c = 100;
        OpportunityForecastTrgHandler.isInUpdateOppyPartForecast = false;
        update oppyForecast1;
        Test.stopTest();
        Opportunity_Forecast__c oppyForecastAssert = [SELECT Amount__c FROM Opportunity_Forecast__c WHERE Id =: oppyForecast1.Id limit 1];
        System.assert(oppyForecastAssert.Amount__c == 100);
    }
    
    static testMethod void testForUpdateEnergyOppyType() {
        User u = ClsTestHelp.createTestUsers();
        insert u;
        System.runAs(u) {
            list<account> testAccounts = new list<account>();
            Account testAcct1 = ClsTestHelp.createTestAccounts();
            testAcct1.AccountNumber = 'test';
            insert testAcct1;
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.AccountId = testAcct1.Id;
            oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
            oppy.Currency_Confirm__c = true;
            oppy.Probability__c = '80';
            insert oppy;
            Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
            ph.Hierarchy_Level_Type__c = 'CBC1';
            ph.Description__c = 'Industrial'; 
            insert ph;
            Part__c part = ClsTestHelp.createTestPart();
            part.Description__c = 'Sniper';
            part.Product_Hierarchy__c = ph.Id;
            insert part;
            Test.startTest();
            ClsTriggerFactory.setSkipHandler('AccountTrgHandler',true); 
        	ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);
            Opportunity_Part__c oppyPart = ClsTestHelp.createTestEnergyOpportunityPart();
			oppyPart.Opportunity__c = oppy.Id;
			oppyPart.Part__c = part.Id;
			ClsTriggerFactory.setSkipHandler('OpportunityPartTrgHandler',true);
			insert oppyPart;
            Opportunity_Forecast__c oppyForecast1 = ClsTestHelp.createTestENGOpportunityForecasts();
            oppyForecast1.Opportunity__c = oppy.Id;
            oppyForecast1.Amount__c = 50;
            oppyForecast1.CurrencyIsoCode = 'USD';
            oppyForecast1.Confidence_Level__c = '30';
            oppyForecast1.Fiscal_Month__c = '12';
            oppyForecast1.Fiscal_Quarter__c = 'Q4';
            oppyForecast1.Fiscal_Year__c = '2017';
            insert oppyForecast1;
            oppyForecast1.Amount__c = 100;
            OpportunityForecastTrgHandler.isInUpdateOppyPartForecast = false;
            update oppyForecast1; 
            Test.stopTest();
            Opportunity_Forecast__c oppyForecastAssert = [SELECT Amount__c FROM Opportunity_Forecast__c WHERE Id =: oppyForecast1.Id limit 1];
        	System.assert(oppyForecastAssert.Amount__c == 100);
        } 
    }
    
    static testMethod void testForUpdateEnergyOppyType2() {
        User u = ClsTestHelp.createTestUsers();
        insert u;
        System.runAs(u) {
            Account testAcct1 = ClsTestHelp.createTestAccounts();
            testAcct1.AccountNumber = 'test';
            insert testAcct1;
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.AccountId = testAcct1.Id;
            oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
            oppy.Currency_Confirm__c = true;
            insert oppy;
            Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
            ph.Hierarchy_Level_Type__c = 'CBC1';
            ph.Description__c = 'Industrial'; 
            insert ph;
            Part__c part = ClsTestHelp.createTestPart();
            part.Description__c = 'Sniper';
            part.Product_Hierarchy__c = ph.Id;
            insert part;
            Test.startTest();
            ClsTriggerFactory.setSkipHandler('AccountTrgHandler',true); 
        	ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);
            Opportunity_Part__c oppyPart = ClsTestHelp.createTestEnergyOpportunityPart();
			oppyPart.Opportunity__c = oppy.Id;
			oppyPart.Part__c = part.Id;
			insert oppyPart;
            Opportunity_Forecast__c oppyForecast1 = ClsTestHelp.createTestENGOpportunityForecasts();
            oppyForecast1.Opportunity__c = oppy.Id;
            oppyForecast1.Amount__c = 0;
            oppyForecast1.CurrencyIsoCode = 'USD';
            oppyForecast1.Confidence_Level__c = '30';
            oppyForecast1.Fiscal_Month__c = '12';
            oppyForecast1.Fiscal_Quarter__c = 'Q4';
            oppyForecast1.Fiscal_Year__c = '2017';
            insert oppyForecast1;
            oppyForecast1.Amount__c = 100;
            OpportunityForecastTrgHandler.isInUpdateOppyPartForecast = false; 
            update oppyForecast1; 
            Test.stopTest();
            Opportunity_Forecast__c oppyForecastAssert = [SELECT Amount__c FROM Opportunity_Forecast__c WHERE Id =: oppyForecast1.Id limit 1];
        	System.assert(oppyForecastAssert.Amount__c == 100);
        }
    }
    
    static testMethod void testForUpdateEnergyOppyType3() {
        User u = ClsTestHelp.createTestUsers();
        insert u;
        System.runAs(u) {
            Account testAcct1 = ClsTestHelp.createTestAccounts();
            testAcct1.AccountNumber = 'test';
            insert testAcct1;
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.AccountId = testAcct1.Id;
            oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
            oppy.Currency_Confirm__c = true;
            oppy.Probability__c = '80';
            insert oppy;
            Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
            ph.Hierarchy_Level_Type__c = 'CBC1'; 
            ph.Description__c = 'Industrial'; 
            insert ph; 
            Part__c part = ClsTestHelp.createTestPart();
            part.Description__c = 'Sniper';
            part.Product_Hierarchy__c = ph.Id;
            insert part;
            Test.startTest();
            ClsTriggerFactory.setSkipHandler('AccountTrgHandler',true); 
        	ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);
            Opportunity_Part__c oppyPart = ClsTestHelp.createTestEnergyOpportunityPart();
			oppyPart.Opportunity__c = oppy.Id;
			oppyPart.Part__c = part.Id;
			ClsTriggerFactory.setSkipHandler('OpportunityPartTrgHandler',true);
			insert oppyPart;
            Opportunity_Forecast__c oppyForecast1 = ClsTestHelp.createTestENGOpportunityForecasts();
            oppyForecast1.Opportunity__c = oppy.Id;
            oppyForecast1.Amount__c = 100;
            oppyForecast1.CurrencyIsoCode = 'USD';
            oppyForecast1.Confidence_Level__c = '30';
            oppyForecast1.Fiscal_Month__c = '12';
            oppyForecast1.Fiscal_Quarter__c = 'Q4';
            oppyForecast1.Fiscal_Year__c = '2017';
            insert oppyForecast1;
            oppyForecast1.Amount__c = 0; 
            OpportunityForecastTrgHandler.isInUpdateOppyPartForecast = false;
            update oppyForecast1; 
            Test.stopTest();
            Opportunity_Forecast__c oppyForecastAssert = [SELECT Amount__c FROM Opportunity_Forecast__c WHERE Id =: oppyForecast1.Id limit 1];
        	System.assert(oppyForecastAssert.Amount__c == 0);
        }
    }
    
    static testMethod void testForDeleteEnergyOppyType() {
        User u = ClsTestHelp.createTestUsers();
        insert u;
        System.runAs(u) {
            Account testAcct1 = ClsTestHelp.createTestAccounts();
            testAcct1.AccountNumber = 'test';
            insert testAcct1;
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.AccountId = testAcct1.Id;
            oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
            oppy.Currency_Confirm__c = true;
            oppy.Probability__c = '80';
            insert oppy;
            Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
            ph.Hierarchy_Level_Type__c = 'CBC1';
            ph.Description__c = 'Industrial'; 
            insert ph;
            Part__c part = ClsTestHelp.createTestPart();
            part.Description__c = 'Sniper';
            part.Product_Hierarchy__c = ph.Id;
            insert part;
            Test.startTest();
            ClsTriggerFactory.setSkipHandler('AccountTrgHandler',true); 
        	ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true);
            Opportunity_Part__c oppyPart = ClsTestHelp.createTestEnergyOpportunityPart();
			oppyPart.Opportunity__c = oppy.Id;
			oppyPart.Part__c = part.Id;
			insert oppyPart;
            Opportunity_Forecast__c oppyForecast1 = ClsTestHelp.createTestENGOpportunityForecasts();
            oppyForecast1.Opportunity__c = oppy.Id;
            oppyForecast1.Amount__c = 100;
            oppyForecast1.CurrencyIsoCode = 'USD';
            oppyForecast1.Confidence_Level__c = '30';
            oppyForecast1.Fiscal_Month__c = '12';
            oppyForecast1.Fiscal_Quarter__c = 'Q4';
            oppyForecast1.Fiscal_Year__c = '2017';
            insert oppyForecast1;
			OpportunityForecastTrgHandler.isInUpdateOppyPartForecast = false;
            delete oppyForecast1;
            Test.stopTest();
            Opportunity_Forecast__c oppyForecastAssert;
            for(Opportunity_Forecast__c oppyForecast : [SELECT Amount__c FROM Opportunity_Forecast__c WHERE Id =: oppyForecast1.Id limit 1]){
            	oppyForecastAssert = oppyForecast;
            } 
        	System.assert(oppyForecastAssert == null);
        }
    }
}