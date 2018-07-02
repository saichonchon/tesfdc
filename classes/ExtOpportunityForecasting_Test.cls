/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   A test class for ExtOpportunityForecasting.cls.
			   The user story number is W-00145.
Inputs:        
Test Class:    
History
2017-07-10 	Yiming Shen <yiming.shen@capgemini.com> created
------------------------------------------------------------*/
@isTest
private class ExtOpportunityForecasting_Test {
	@testSetup static void createConfig(){
		ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping(); 
        ClsTestCustomSettingHelper.getADMTerritoryCode();
        Profit_BU_Center_Mapping_Rule2__c rule2 = ClsTestHelp.createTestProfitBUCenterMapping2();
        Consumer_Device_Opportunity_Record_Types__c cdort1 = ClsTestHelp.createTestCSD1();
    	Consumer_Device_Opportunity_Record_Types__c cdort2 = ClsTestHelp.createTestCSD2();
    	Consumer_Device_Opportunity_Record_Types__c cdort3 = ClsTestHelp.createTestCSD3();
    	Consumer_Device_Opportunity_Record_Types__c cdort4 = ClsTestHelp.createTestCSD4();
    	Consumer_Device_Opportunity_Record_Types__c cdort5 = ClsTestHelp.createTestCSD5();
    	Consumer_Device_Opportunity_Record_Types__c cdort6 = ClsTestHelp.createTestCSD6();
    	Consumer_Device_Opportunity_Record_Types__c cdort7 = ClsTestHelp.createTestCSD7();
        ClsTestHelp.createTestOrgWideSettings1();
        ClsTestHelp.createTestOpportunityApprovers();
    	ClsTestHelp.createTestOpportunityApprovers2();
    	ClsTestHelp.createTestOpportunityApprovers3();
    	ClsTestHelp.createTestOpportunityApprovers4();
    	ClsTestCustomSettingHelper.getProfilesAllowToEditPastForecasts(); 
	} 
	
    static testMethod void testOppyWithCloseDate() {
    	Profile p = [Select Id, Name From Profile 
                                    where Name = 'Energy - Salesman'
                                    limit 1];
        User uAM = ClsTestHelp.createTestUsers();
        uAM.Email = 'helloSand0728@testCompany1407281004.com';
        uAM.FirstName ='Test0728';
        uAM.LastName = 'User0728';
        uAM.Alias = 'dpse0723';
        uAM.CommunityNickname = 'TMD07281';
        uAM.ProfileId = p.Id;
        uAM.GIBU__c = 'Appliances';
        uAM.Username = 'helloSand072811@testCompany1407281004.com';
        insert uAM;
        
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
    	sh.Level_2_Territory_Code__c = '103004';
    	sh.Level_7_Default_Owner__c = uAM.Id;
        insert sh;
    	Account acct = ClsTestHelp.createTestAccounts();
        acct.Type = 'CM';
        acct.AccountNumber = 'test';
        insert acct;
    	 ClsTriggerRecursionDefense.OpportunityAnzClauseTrigger = false;
    	RecordType rtEnergy = ClsTestHelp.createTestRecordType32();
    	Opportunity testOppy = ClsTestHelp.createTestOpportunity();
    	testOppy.AccountId = acct.Id;
    	testOppy.RecordTypeId = rtEnergy.Id;
    	insert testOppy;
    	Integer currentFiscalYear;
    	Integer currentFiscalQuarter;
    	Integer currentFiscalMonth;
    	for(Period currentPeriod : [SELECT EndDate, FiscalYearSettings.Name, Number, Id, PeriodLabel, 
									QuarterLabel, StartDate, Type 
									FROM Period 
									WHERE (Type = 'Year' OR Type = 'Quarter' OR Type = 'Month')  
									AND StartDate <=: testOppy.CloseDate 
									AND EndDate >=: testOppy.CloseDate ]){
			if(currentPeriod.Type == 'Year'){
				currentFiscalYear = Integer.valueOf(currentPeriod.FiscalYearSettings.Name);
			}else if(currentPeriod.Type == 'Quarter'){
				currentFiscalQuarter = currentPeriod.Number;
			}else if(currentPeriod.Type == 'Month'){
				currentFiscalMonth = ExtOpportunityForecasting.map_MonthAbbr_MonthNumber.get(currentPeriod.PeriodLabel);
			} 
		}
    	Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestENGOpportunityForecasts();
        oppyForecast.Opportunity__c = testOppy.Id;
        oppyForecast.Amount__c = 1;
        oppyForecast.Confidence_Level__c = '30';
        oppyForecast.Fiscal_Month__c = String.valueOf(currentFiscalMonth);
		oppyForecast.Fiscal_Quarter__c = 'Q' + currentFiscalQuarter;
		oppyForecast.Fiscal_Year__c = String.valueOf(currentFiscalYear);
		insert oppyForecast;
		Test.startTest();
        List<ExtOpportunityForecasting.MonthlyForecastWrapper> list_MonthlyForecastWrappers = new List<ExtOpportunityForecasting.MonthlyForecastWrapper>();
		ExtOpportunityForecasting.MonthlyForecastWrapper testMonthlyForecastWrapper = new ExtOpportunityForecasting.MonthlyForecastWrapper();
		testMonthlyForecastWrapper.YearName = String.valueOf(currentFiscalYear);
		testMonthlyForecastWrapper.QuarterName = 'Q' + currentFiscalQuarter;
		testMonthlyForecastWrapper.MonthNumber = currentFiscalMonth;
		testMonthlyForecastWrapper.MonthlyForecastAmount = 23;
		testMonthlyForecastWrapper.OppyForeCastId = oppyForecast.Id;
		list_MonthlyForecastWrappers.add(testMonthlyForecastWrapper);
		ExtOpportunityForecasting.MonthlyForecastWrapper testMonthlyForecastWrapper2 = new ExtOpportunityForecasting.MonthlyForecastWrapper();
		testMonthlyForecastWrapper2.YearName = String.valueOf(currentFiscalYear+1);
		testMonthlyForecastWrapper2.QuarterName = 'Q' + currentFiscalQuarter;
		testMonthlyForecastWrapper2.MonthNumber = currentFiscalMonth;
		testMonthlyForecastWrapper2.MonthlyForecastAmount = null;
		testMonthlyForecastWrapper2.OppyForeCastId = null;
		list_MonthlyForecastWrappers.add(testMonthlyForecastWrapper2);
		ApexPages.StandardController sc = new ApexPages.StandardController(testOppy);
        ExtOpportunityForecasting ctrl = new ExtOpportunityForecasting(sc);
    	system.debug('list_MonthlyForecastWrappers::'+list_MonthlyForecastWrappers);
		ctrl.json_OppyForecasts2Save = JSON.serialize(list_MonthlyForecastWrappers);
        ctrl.SaveForecastValue();
        ctrl.initData();
        List<Opportunity_Forecast__c> list2Assert = [SELECT Id FROM Opportunity_Forecast__c WHERE Opportunity__c =: testOppy.Id ];
        System.assert(list2Assert.size() > 0);
        Test.stopTest();
    }
}