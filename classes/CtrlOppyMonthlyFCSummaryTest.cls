/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   A test class for CtrlOppyMonthlyFCSummary.cls.
			   The user story number is W-00146.
Inputs:        
Test Class:    
History
2017-10-18 	Yiming Shen <yiming.shen@capgemini.com> created
------------------------------------------------------------*/
@isTest
private class CtrlOppyMonthlyFCSummaryTest {
	@testSetup static void createConfig(){
		ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getADMTerritoryCode();
        Consumer_Device_Opportunity_Record_Types__c cdort1 = ClsTestHelp.createTestCSD1();
    	Consumer_Device_Opportunity_Record_Types__c cdort2 = ClsTestHelp.createTestCSD2();
    	Consumer_Device_Opportunity_Record_Types__c cdort3 = ClsTestHelp.createTestCSD3();
    	Consumer_Device_Opportunity_Record_Types__c cdort4 = ClsTestHelp.createTestCSD4();
    	Consumer_Device_Opportunity_Record_Types__c cdort5 = ClsTestHelp.createTestCSD5();
    	Consumer_Device_Opportunity_Record_Types__c cdort6 = ClsTestHelp.createTestCSD6();
    	Consumer_Device_Opportunity_Record_Types__c cdort7 = ClsTestHelp.createTestCSD7();
    	ClsTestHelp.createTestOpportunityApprovers();
    	ClsTestHelp.createTestOpportunityApprovers2();
    	ClsTestHelp.createTestOpportunityApprovers3();
    	ClsTestHelp.createTestOpportunityApprovers4();
	}
    static testMethod void myUnitTest() {
    	RecordType rt2 = ClsTestHelp.createTestRecordType8();
    	Profile p = [Select Id, Name From Profile 
                                    where Name = 'Appliance Standard User'
                                    limit 1];
        List<User> uList = new List<User>();                            
        User uRSM = ClsTestHelp.createTestUsers();
        uRSM.Email = 'helloSand0728@testCompany1407281004.com';
        uRSM.FirstName ='Test0728';
        uRSM.LastName = 'User0728';
        uRSM.Alias = 'dpse0728';
        uRSM.CommunityNickname = 'TMD0728';
        uRSM.ProfileId = p.Id;
        uRSM.Te_Network_Id__c = '0529';
        uRSM.GIBU__c = 'Appliances';
        uRSM.Username = 'helloSand0728@testCompany1407281004.com';
        uList.add(uRSM);
        insert uList;
        User u = [SELECT Id,Te_Network_Id__c FROM User WHERE Username = 'helloSand0728@testCompany1407281004.com' limit 1];
    	
    	System.runAs(u){
    		Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
	    	sh.Level_7_Territory_Code__c = '103007';
	    	sh.Level_7_Default_Owner__c = u.Id;
	        sh.Level_7_Territory_Name__c = 'test aa7';
	        sh.Level_7_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
	        sh.Level_7_Assigned_Users__c = u.Id;
	        sh.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
	        
	        Sales_Hierarchy__c sh1 = ClsTestHelp.createTestSalesHierarchy();
	        sh1.Level_6_Territory_Code__c = '103006';
	    	sh1.Level_7_Default_Owner__c = u.Id;
	        sh1.Level_6_Territory_Name__c = 'test bb6';
	        sh1.Level_6_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
	        sh1.Level_6_Assigned_Users__c = u.Id;
	        sh1.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
	        
	        Sales_Hierarchy__c sh2 = ClsTestHelp.createTestSalesHierarchy();
	        sh2.Level_5_Territory_Code__c = '103005';
	    	sh2.Level_7_Default_Owner__c = u.Id;
	        sh2.Level_5_Territory_Name__c = 'test cc5';
	        sh2.Level_5_Assigned_Users__c = u.Id;
	        sh2.Level_5_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
	        sh2.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
	        
	        Sales_Hierarchy__c sh4 = ClsTestHelp.createTestSalesHierarchy();
	    	sh4.Level_4_Territory_Code__c = '103004';
	    	sh4.Level_7_Default_Owner__c = u.Id;
	        sh4.Level_4_Territory_Name__c = 'test dd4';
	        sh4.Level_4_Assigned_Users__c = u.Id;
	        sh4.Level_4_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
	        sh4.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
	        
	        list<Sales_Hierarchy__c> list_salesHierarchy = new Sales_Hierarchy__c[] {sh,sh1,sh2,sh4};
	        insert list_salesHierarchy;
	        
             ClsTriggerRecursionDefense.OpportunityAnzClauseTrigger = false;
        	Account testAcct = ClsTestHelp.createTestAccounts();
        	testAcct.Sales_Hierarchy__c = sh.Id; 
        	testAcct.SALES_TERRITORY_CDE__c = sh.Level_7_Territory_Code__c;
        	insert testAcct;
    		RecordType rtEnergy = ClsTestHelp.createTestRecordType32();
        	Opportunity testOppy = ClsTestHelp.createTestOpportunity();
        	testOppy.RecordTypeId = rtEnergy.Id;
        	testOppy.AccountId = testAcct.Id;
        	testOppy.Probability__c = '60';
	    	insert testOppy;
	    	Integer currentFiscalYear;
	    	Integer currentFiscalQuarter;
	    	Integer currentFiscalMonth;
            
	    	for(Period currentPeriod : [SELECT EndDate, FiscalYearSettings.Name, Number, Id, PeriodLabel, 
										QuarterLabel, StartDate, Type 
										FROM Period 
										WHERE (Type = 'Year' OR Type = 'Quarter' OR Type = 'Month')  
										AND StartDate <= TODAY 
										AND EndDate >= TODAY ]){
				if(currentPeriod.Type == 'Year'){
					currentFiscalYear = Integer.valueOf(currentPeriod.FiscalYearSettings.Name);
				}else if(currentPeriod.Type == 'Quarter'){
					currentFiscalQuarter = currentPeriod.Number;
				}else if(currentPeriod.Type == 'Month'){
					currentFiscalMonth = CtrlOppyMonthlyFCSummary.map_MonthAbbr_MonthNumber.get(currentPeriod.PeriodLabel);
				} 
			}
	    	Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestENGOpportunityForecasts();
	        oppyForecast.Opportunity__c = testOppy.Id;
	        oppyForecast.Amount__c = 1;
	        oppyForecast.Fiscal_Month__c = String.valueOf(currentFiscalMonth);
			oppyForecast.Fiscal_Year__c = String.valueOf(currentFiscalYear);
            oppyForecast.Confidence_Level__c = '80';
            oppyForecast.Amount__c = 96;
			
			Opportunity_Forecast__c oppyForecast2 = ClsTestHelp.createTestENGOpportunityForecasts();
	        oppyForecast2.Opportunity__c = testOppy.Id;
	        oppyForecast2.Amount__c = 2;
            Integer secondMonth = currentFiscalMonth+1;
            if(secondMonth >12){
                secondMonth = secondMonth -12;
            }
	        oppyForecast2.Fiscal_Month__c = String.valueOf(secondMonth);
			oppyForecast2.Fiscal_Year__c = String.valueOf(currentFiscalYear);
            oppyForecast2.Confidence_Level__c = '100';
            oppyForecast2.Amount__c = 98;
			
			Opportunity_Forecast__c oppyForecast3 = ClsTestHelp.createTestENGOpportunityForecasts();
	        oppyForecast3.Opportunity__c = testOppy.Id;
	        oppyForecast3.Amount__c = 3;
            Integer thirdMonth = currentFiscalMonth+2;
            if(thirdMonth >12){
                thirdMonth = thirdMonth-12;
            }
	        oppyForecast3.Fiscal_Month__c = String.valueOf(thirdMonth);
			oppyForecast3.Fiscal_Year__c = String.valueOf(currentFiscalYear);
            oppyForecast3.Confidence_Level__c = '0';
            oppyForecast3.Amount__c = 99;
			insert new List<Opportunity_Forecast__c>{oppyForecast,oppyForecast2,oppyForecast3};
            
            Month_Forecast__c mothFore = ClsTestHelp.createTestMonthForecast();
            mothFore.User__c = u.id;
            mothFore.Month__c = currentFiscalMonth;
            mothFore.Year__c = String.valueOf(currentFiscalYear);
            mothFore.Territory_Code__c = '103007';
            mothFore.Territory_Level_5_6_or_7__c = '7';
            insert mothFore;
			Test.startTest();
			List<BBB_Month_Bill_Book_Cust__c> list_Books = new List<BBB_Month_Bill_Book_Cust__c>();
            for(Integer i = -2; i < 3; i++){
            	BBB_Month_Bill_Book_Cust__c book1 = ClsTestHelp.createTestBBBMonthBillBookCust();
	            book1.Customer__c = testAcct.Id;
	            book1.Book_Amount_USD__c = i;
	            book1.Fiscal_Year__c = String.valueOf(currentFiscalYear);
	            if(0 > (currentFiscalMonth + i)){
	            	book1.Fiscal_Month__c = currentFiscalMonth + i + 12;
	            }else if((currentFiscalMonth + i) > 12){
	            	book1.Fiscal_Month__c = currentFiscalMonth + i - 12;
	            }else{
	            	book1.Fiscal_Month__c = currentFiscalMonth + i;
	            }
	            list_Books.add(book1);
            }
            insert list_Books;
			CtrlOppyMonthlyFCSummary ctrl = new CtrlOppyMonthlyFCSummary();
            ctrl.forecastInputValue = '12.5';
            ctrl.currentFiscalMonth = currentFiscalMonth;
            ctrl.currentFiscalYear = currentFiscalYear;
            ctrl.selectedMonthValue = String.valueOf(currentFiscalMonth);
            ctrl.GetMonthForecastValue();
            ctrl.CalculateOppyForecastSummaryByLevelAndMonth();
            ctrl.SaveMonthFcValue();
            ctrl.populateValueForChart();
            List<CtrlOppyMonthlyFCSummary.MonthlyForcecastWrapper> list_MonthlyForcecastWrappers = new List<CtrlOppyMonthlyFCSummary.MonthlyForcecastWrapper>();
            CtrlOppyMonthlyFCSummary.MonthlyForcecastWrapper monthlyForcecastWrapper = new CtrlOppyMonthlyFCSummary.MonthlyForcecastWrapper();
            monthlyForcecastWrapper.oppForId = oppyForecast3.Id;
            monthlyForcecastWrapper.FcValue = 123;
            list_MonthlyForcecastWrappers.add(monthlyForcecastWrapper);
            ctrl.json_MonthlyOppyForecasts2Save = JSON.serialize(list_MonthlyForcecastWrappers);
            ctrl.saveOpportunityForecastValue();
			Test.stopTest();
			Month_Forecast__c mfAssert = [SELECT Forecast_Override__c FROM Month_Forecast__c WHERE Id =: mothFore.Id limit 1];
			System.assert(mfAssert.Forecast_Override__c == 12.5);
			Opportunity_Forecast__c opAssert = [SELECT Amount__c FROM Opportunity_Forecast__c WHERE Id =: oppyForecast3.Id limit 1];
			System.assert(opAssert.Amount__c == 123);
        }
    }
    
    static testMethod void myUnitTest2() {
    	RecordType rt2 = ClsTestHelp.createTestRecordType8();
    	Profile p = [Select Id, Name From Profile 
                                    where Name = 'Appliance Standard User'
                                    limit 1];
        List<User> uList = new List<User>();                            
        User uRSM = ClsTestHelp.createTestUsers();
        uRSM.Email = 'helloSand0728@testCompany1407281004.com';
        uRSM.FirstName ='Test0728';
        uRSM.LastName = 'User0728';
        uRSM.Alias = 'dpse0728';
        uRSM.CommunityNickname = 'TMD0728';
        uRSM.ProfileId = p.Id;
        uRSM.Te_Network_Id__c = '0529';
        uRSM.GIBU__c = 'Appliances';
        uRSM.Username = 'helloSand0728@testCompany1407281004.com';
        uList.add(uRSM);
        insert uList;
        User u = [SELECT Id,Te_Network_Id__c FROM User WHERE Username = 'helloSand0728@testCompany1407281004.com' limit 1];
    	
    	System.runAs(u){
    		Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
	    	sh.Level_7_Territory_Code__c = '103007';
	    	sh.Level_7_Default_Owner__c = u.Id;
	        sh.Level_7_Territory_Name__c = 'test aa7';
	        sh.Level_7_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
	        sh.Level_7_Assigned_Users__c = u.Id;
	        sh.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
	        
	        Sales_Hierarchy__c sh1 = ClsTestHelp.createTestSalesHierarchy();
	        sh1.Level_6_Territory_Code__c = '103006';
	    	sh1.Level_7_Default_Owner__c = u.Id;
	        sh1.Level_6_Territory_Name__c = 'test bb6';
	        sh1.Level_6_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
	        sh1.Level_6_Assigned_Users__c = u.Id;
	        sh1.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
	        
	        Sales_Hierarchy__c sh2 = ClsTestHelp.createTestSalesHierarchy();
	        sh2.Level_5_Territory_Code__c = '103005';
	    	sh2.Level_7_Default_Owner__c = u.Id;
	        sh2.Level_5_Territory_Name__c = 'test cc5';
	        sh2.Level_5_Assigned_Users__c = u.Id;
	        sh2.Level_5_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
	        sh2.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
	        
	        Sales_Hierarchy__c sh4 = ClsTestHelp.createTestSalesHierarchy();
	    	sh4.Level_4_Territory_Code__c = '103004';
	    	sh4.Level_7_Default_Owner__c = u.Id;
	        sh4.Level_4_Territory_Name__c = 'test dd4';
	        sh4.Level_4_Assigned_Users__c = u.Id;
	        sh4.Level_4_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
	        sh4.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
	        
	        list<Sales_Hierarchy__c> list_salesHierarchy = new Sales_Hierarchy__c[] {sh,sh1,sh2,sh4};
	        insert list_salesHierarchy;
	        
            ClsTriggerRecursionDefense.OpportunityAnzClauseTrigger = false;
        	Account testAcct = ClsTestHelp.createTestAccounts();
        	testAcct.Sales_Hierarchy__c = sh.Id; 
        	testAcct.SALES_TERRITORY_CDE__c = sh.Level_7_Territory_Code__c;
        	insert testAcct;
    		RecordType rtEnergy = ClsTestHelp.createTestRecordType32();
        	Opportunity testOppy = ClsTestHelp.createTestOpportunity();
        	testOppy.RecordTypeId = rtEnergy.Id;
        	testOppy.AccountId = testAcct.Id;
        	testOppy.Probability__c = '60';
	    	insert testOppy;
	    	Integer currentFiscalYear;
	    	Integer currentFiscalQuarter;
	    	Integer currentFiscalMonth;
            
	    	for(Period currentPeriod : [SELECT EndDate, FiscalYearSettings.Name, Number, Id, PeriodLabel, 
										QuarterLabel, StartDate, Type 
										FROM Period 
										WHERE (Type = 'Year' OR Type = 'Quarter' OR Type = 'Month')  
										AND StartDate <= TODAY 
										AND EndDate >= TODAY ]){
				if(currentPeriod.Type == 'Year'){
					currentFiscalYear = Integer.valueOf(currentPeriod.FiscalYearSettings.Name);
				}else if(currentPeriod.Type == 'Quarter'){
					currentFiscalQuarter = currentPeriod.Number;
				}else if(currentPeriod.Type == 'Month'){
					currentFiscalMonth = CtrlOppyMonthlyFCSummary.map_MonthAbbr_MonthNumber.get(currentPeriod.PeriodLabel);
				} 
			}
	    	Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestENGOpportunityForecasts();
	        oppyForecast.Opportunity__c = testOppy.Id;
	        oppyForecast.Amount__c = 1;
	        oppyForecast.Fiscal_Month__c = String.valueOf(currentFiscalMonth);
			oppyForecast.Fiscal_Year__c = String.valueOf(currentFiscalYear);
            oppyForecast.Confidence_Level__c = '80';
            oppyForecast.Amount__c = 96;
			
			Opportunity_Forecast__c oppyForecast2 = ClsTestHelp.createTestENGOpportunityForecasts();
	        oppyForecast2.Opportunity__c = testOppy.Id;
	        oppyForecast2.Amount__c = 2;
            Integer secondMonth = currentFiscalMonth+1;
            if(secondMonth >12){
                secondMonth = secondMonth -12;
            }
	        oppyForecast2.Fiscal_Month__c = String.valueOf(secondMonth);
			oppyForecast2.Fiscal_Year__c = String.valueOf(currentFiscalYear);
            oppyForecast2.Confidence_Level__c = '100';
            oppyForecast2.Amount__c = 98;
			
			Opportunity_Forecast__c oppyForecast3 = ClsTestHelp.createTestENGOpportunityForecasts();
	        oppyForecast3.Opportunity__c = testOppy.Id;
	        oppyForecast3.Amount__c = 3;
            Integer thirdMonth = currentFiscalMonth+2;
            if(thirdMonth >12){
                thirdMonth = thirdMonth-12;
            }
	        oppyForecast3.Fiscal_Month__c = String.valueOf(thirdMonth);
			oppyForecast3.Fiscal_Year__c = String.valueOf(currentFiscalYear);
            oppyForecast3.Confidence_Level__c = '0';
            oppyForecast3.Amount__c = 99;
			insert new List<Opportunity_Forecast__c>{oppyForecast,oppyForecast2,oppyForecast3};
            
			Test.startTest();
			List<BBB_Month_Bill_Book_Cust__c> list_Books = new List<BBB_Month_Bill_Book_Cust__c>();
            for(Integer i = -2; i < 3; i++){
            	BBB_Month_Bill_Book_Cust__c book1 = ClsTestHelp.createTestBBBMonthBillBookCust();
	            book1.Customer__c = testAcct.Id;
	            book1.Book_Amount_USD__c = i;
	            book1.Fiscal_Year__c = String.valueOf(currentFiscalYear);
	            if(0 > (currentFiscalMonth + i)){
	            	book1.Fiscal_Month__c = currentFiscalMonth + i + 12;
	            }else if((currentFiscalMonth + i) > 12){
	            	book1.Fiscal_Month__c = currentFiscalMonth + i - 12;
	            }else{
	            	book1.Fiscal_Month__c = currentFiscalMonth + i;
	            }
	            list_Books.add(book1);
            }
            insert list_Books;
			CtrlOppyMonthlyFCSummary ctrl = new CtrlOppyMonthlyFCSummary();
            ctrl.forecastInputValue = '12.5';
            ctrl.currentFiscalMonth = currentFiscalMonth;
            ctrl.currentFiscalYear = currentFiscalYear;
            ctrl.selectedMonthValue = String.valueOf(currentFiscalMonth);
            ctrl.GetMonthForecastValue();
            ctrl.CalculateOppyForecastSummaryByLevelAndMonth();
            ctrl.SaveMonthFcValue();
            ctrl.populateValueForChart();
            List<CtrlOppyMonthlyFCSummary.MonthlyForcecastWrapper> list_MonthlyForcecastWrappers = new List<CtrlOppyMonthlyFCSummary.MonthlyForcecastWrapper>();
            CtrlOppyMonthlyFCSummary.MonthlyForcecastWrapper monthlyForcecastWrapper = new CtrlOppyMonthlyFCSummary.MonthlyForcecastWrapper();
            monthlyForcecastWrapper.oppForId = oppyForecast3.Id;
            monthlyForcecastWrapper.FcValue = 123;
            list_MonthlyForcecastWrappers.add(monthlyForcecastWrapper);
            ctrl.json_MonthlyOppyForecasts2Save = JSON.serialize(list_MonthlyForcecastWrappers);
            ctrl.saveOpportunityForecastValue();
			Test.stopTest(); 
			Opportunity_Forecast__c opAssert = [SELECT Amount__c FROM Opportunity_Forecast__c WHERE Id =: oppyForecast3.Id limit 1];
			System.assert(opAssert.Amount__c == 123);
        }
    }
}