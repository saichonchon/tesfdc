/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   A test class for CtrlMonthlyTargetBookings.cls.
			   The user story number is W-00145.
Inputs:        
Test Class:    
History
2017-10-18 Yiming Shen <yiming.shen@capgemini.com> Created
------------------------------------------------------------*/
@isTest(SeeAllData=false)
public class CtrlMonthlyTargetBookings_Test {
	@testSetup static void createConfig(){
		ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getADMTerritoryCode();
        ClsTestHelp.createTestOPTG4();
        OpportunityForecastsReportId__c customSetting1 = ClsTestHelp.createOpportunityForecastsReportId();
        customSetting1.Name = 'Commitment';
        customSetting1.Report_Id__c = '';
        insert customSetting1;
	}
	
    static testMethod void myUnitTest() {
        User u = ClsTestHelp.createTestUsers();
        u.Te_Network_Id__c = '0529';
        insert u;
        System.runAs(u) {
            Sales_Hierarchy__c sh4 = ClsTestHelp.createTestSalesHierarchy();
            sh4.Level_4_Territory_Code__c = 'A004';
            sh4.Level_7_Default_Owner__c = u.Id;
            sh4.Level_4_Territory_Name__c = 'A00734';
            sh4.Level_4_Assigned_Users__c = u.Id;
            sh4.Level_7_Territory_Code__c = 'A007357';
            sh4.Level_4_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
            sh4.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
            
            Sales_Hierarchy__c sh5 = ClsTestHelp.createTestSalesHierarchy();
            sh5.Level_5_Territory_Code__c = 'A005355';
            sh5.Level_7_Default_Owner__c = u.Id;
            sh5.Level_5_Assigned_Users__c = u.Id;
            sh5.Level_7_Territory_Code__c = 'A007357';
            sh5.Level_5_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
            sh5.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
            
            Sales_Hierarchy__c sh5_2 = ClsTestHelp.createTestSalesHierarchy();
            sh5_2.Level_5_Territory_Code__c = 'A007357';
            sh5_2.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
            sh5_2.Level_7_Default_Owner__c = u.Id;
            sh5_2.Level_5_Assigned_Users__c = u.Id;
            sh5_2.Level_7_Territory_Code__c = 'A007357';
            sh5_2.Level_5_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
            
            Sales_Hierarchy__c sh5_3 = ClsTestHelp.createTestSalesHierarchy();
            sh5_3.Level_5_Territory_Code__c = 'A007357';
            sh5_3.Level_6_Territory_Code__c = 'A007357';
            sh5_3.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
            sh5_3.Level_7_Default_Owner__c = u.Id;
            sh5_3.Level_5_Assigned_Users__c = u.Id;
            sh5_3.Level_7_Territory_Code__c = 'A007357';
            sh5_3.Level_5_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
            
            Sales_Hierarchy__c sh6 = ClsTestHelp.createTestSalesHierarchy();
            sh6.Level_6_Territory_Code__c = 'A006356';
            sh6.Level_7_Territory_Code__c = 'A007357';
            sh6.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
            sh6.Level_7_Default_Owner__c = u.Id;
            sh6.Level_6_Assigned_Users__c = u.Id;
            sh6.Level_6_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
            
            Sales_Hierarchy__c sh7 = ClsTestHelp.createTestSalesHierarchy();
            sh7.Level_7_Territory_Code__c = 'A007357';
            sh7.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
            sh7.Level_7_Default_Owner__c = u.Id;
            sh7.Level_7_Assigned_Users__c = u.Id;
            sh7.Level_7_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
            insert new List<Sales_Hierarchy__c>{sh4,sh5,sh5_2,sh5_3,sh6,sh7};
            
            Account acct = ClsTestHelp.createTestAccounts();
            acct.Type = 'CM';
            acct.AccountNumber = 'test';
            acct.INDUSTRY_BUSINESS_CDE__c = '115'; 
            acct.DD1_Industry_Business_Code__c = '104';
            acct.DD2_Industry_Business_Code__c = '203';
            acct.Sales_Hierarchy__c = sh7.Id;
            acct.GAMCD__c = 'Test GAMCD';
            insert acct;
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();  
            oppy.Type = 'CM';
            oppy.Request_Type__c = 'Extension';
            oppy.Method__c = 'BOM';
            oppy.Level__c = 'Yearly';
            oppy.Amount = 1;
            oppy.CurrencyIsoCode = 'EUR';
            oppy.Five_Year_Revenue__c = 1;
            oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
            oppy.AccountId = acct.Id;
            oppy.Probability__c = '80';
            oppy.Master_Opportunity__c = null; 
            oppy.Territory__c = sh7.Id;
            insert oppy;
            
            Product_Hierarchy__c ph = new Product_Hierarchy__c();
            ph.Hierarchy_Level_Type__c = 'CBC1';
            ph.Description__c = 'Industrial'; 
            insert ph;
            
            Part__c part = new Part__c();
            part.Description__c = 'Sniper';
            part.Product_Hierarchy__c = ph.Id;
            insert part;
            
            system.debug('limit query no:::1::   ' + Limits.getQueries());
            Test.startTest();
            Opportunity_Part__c oppypart = ClsTestHelp.createTestEnergyOpportunityPart();
            oppypart.Opportunity__c = oppy.Id;
            oppypart.Part__c = part.Id;
            oppypart.Offered_Price__c = 0;
            insert oppypart;
            system.debug('limit query no:::2::   ' + Limits.getQueries());
            
            Period currYearPeriod;
            String currentFiscalYearName;
            Integer currentFiscalMonthNum;
            Integer currentFiscalQuarterNumber;
            map<String, Integer> map_MonthAbbr_MonthNumber = new map<String, Integer>{'Oct' => 1,'Nov' => 2,'Dec' => 3,'Jan' => 4,'Feb' => 5,'Mar' => 6,'Apr' => 7,'May' => 8,'Jun' => 9,'Jul' => 10,'Aug' => 11,'Sep' => 12};
            for(Period currentPeriod : [SELECT EndDate, FiscalYearSettings.Name, Number, Id, PeriodLabel, 
                                        QuarterLabel, StartDate, Type 
                                        FROM Period 
                                        WHERE (Type = 'Year' OR Type = 'Month' OR Type = 'Quarter')
                                        AND StartDate <= TODAY
                                        AND EndDate >= TODAY ]){
                if(currentPeriod.Type == 'Year'){
                    currYearPeriod = currentPeriod;
                    currentFiscalYearName = currentPeriod.FiscalYearSettings.Name;
                }else if(currentPeriod.Type == 'Month'){
                    currentFiscalMonthNum = map_MonthAbbr_MonthNumber.get(currentPeriod.PeriodLabel);
                }else if(currentPeriod.Type == 'Quarter'){
                    currentFiscalQuarterNumber = currentPeriod.Number;
                }
            }
            
            Opportunity_Forecast__c oppyForecast1 = ClsTestHelp.createTestENGOpportunityForecasts();
            oppyForecast1.Opportunity__c = oppy.Id;
            oppyForecast1.Part__c = oppypart.Id;
            oppyForecast1.Amount__c = 100;
            oppyForecast1.Actual_Value__c = 100;
            oppyForecast1.CurrencyIsoCode = 'USD';
            oppyForecast1.Confidence_Level__c = '30';
            oppyForecast1.Fiscal_Month__c = '11';
            oppyForecast1.Fiscal_Quarter__c = 'Q4';
            oppyForecast1.Fiscal_Year__c = currentFiscalYearName;
            insert oppyForecast1;
            system.debug('limit query no:::3::   ' + Limits.getQueries());
            Monthly_Target__c monthlyTarget = new Monthly_Target__c();
            monthlyTarget.Data_Entry_Year__c = currentFiscalYearName;
            monthlyTarget.Data_Entry_Month__c = currentFiscalMonthNum;
            monthlyTarget.Territory_Code__c = 'A007357';
            monthlyTarget.GAM_Code__c = 'Test GAMCD';
            insert monthlyTarget;
            system.debug('limit query no:::4::   ' + Limits.getQueries());
            Monthly_Target__c monthlyTarget2 = new Monthly_Target__c();
            monthlyTarget2.Data_Entry_Year__c = currentFiscalYearName;
            monthlyTarget2.Territory_Code__c = 'A007357';
            monthlyTarget2.Territory_Level__c = '5';
            if(currentFiscalMonthNum == 1) {
                monthlyTarget2.Data_Entry_Month__c = currentFiscalMonthNum;
            }else if(currentFiscalMonthNum == 2) {
                monthlyTarget2.Data_Entry_Month__c = currentFiscalMonthNum - 1;
            }else if(currentFiscalMonthNum > 2) {
                monthlyTarget2.Data_Entry_Month__c = currentFiscalMonthNum - 2;
            }
            insert monthlyTarget2;
            system.debug('limit query no:::5::   ' + Limits.getQueries());
            Monthly_Target__c monthlyTarget3 = new Monthly_Target__c();
            monthlyTarget3.Data_Entry_Year__c = currentFiscalYearName;
            monthlyTarget3.Data_Entry_Month__c = currentFiscalMonthNum;
            monthlyTarget3.Territory_Code__c = 'A007357';
            monthlyTarget3.Territory_Level__c = '6';
            insert monthlyTarget3;
            system.debug('limit query no:::6::   ' + Limits.getQueries());
            Monthly_Target__c monthlyTarget4 = new Monthly_Target__c();
            monthlyTarget4.Data_Entry_Year__c = currentFiscalYearName;
            monthlyTarget4.Data_Entry_Month__c = currentFiscalMonthNum;
            monthlyTarget4.Territory_Code__c = 'A007357';
            monthlyTarget4.Territory_Level__c = '7';
            insert monthlyTarget4;
            list<CtrlMonthlyTargetBookings.TargetBookingMonth> list_monthlyTargets = new list<CtrlMonthlyTargetBookings.TargetBookingMonth>();
            CtrlMonthlyTargetBookings.TargetBookingMonth targetBookingMonth2Insert = new CtrlMonthlyTargetBookings.TargetBookingMonth();
            targetBookingMonth2Insert.monthAbbrName = 'Aug';
            targetBookingMonth2Insert.monthNumber = 11;
            targetBookingMonth2Insert.monthProposedValue = 101; 
            targetBookingMonth2Insert.monthTargetValue  = 101;
            targetBookingMonth2Insert.parentMonthlyTargetId = 'insert-new';
            targetBookingMonth2Insert.relatedTerritoryCode = 'test123';
            targetBookingMonth2Insert.relatedTerritoryName = 'test';
            targetBookingMonth2Insert.relatedTerritoryLevel = '6';
            targetBookingMonth2Insert.relatedGAMCode = 'ABC';
            targetBookingMonth2Insert.relatedGAMDescription = 'JAY';
            CtrlMonthlyTargetBookings.TargetBookingMonth targetBookingMonth2Update = new CtrlMonthlyTargetBookings.TargetBookingMonth();
            targetBookingMonth2Update.monthAbbrName = 'Sep';
            targetBookingMonth2Update.monthNumber = 12;
            targetBookingMonth2Update.monthProposedValue = 1011; 
            targetBookingMonth2Update.monthTargetValue  = 1011;
            targetBookingMonth2Update.parentMonthlyTargetId = monthlyTarget3.Id;
            targetBookingMonth2Update.relatedTerritoryCode = 'test1234';
            targetBookingMonth2Update.relatedTerritoryName = 'test4';
            list_monthlyTargets.add(targetBookingMonth2Insert);
            list_monthlyTargets.add(targetBookingMonth2Update);
            system.debug('limit query no:::111::   ' + Limits.getQueries());
            Test.stopTest();
            CtrlMonthlyTargetBookings cls = new CtrlMonthlyTargetBookings();
            cls.selectedTerritoryCode = 'A007357';
            cls.selectedSalesHierarchyId = acct.Sales_Hierarchy__c;
            cls.json_MonthlyTargets2Save = Json.serialize(list_monthlyTargets);
            
            cls.selectedTerritoryLevel = '4';
            cls.getMonthlyTargetBookings();
            cls.selectedTerritoryLevel = '5';
            cls.getChildrenMonthlyTargetForCurrentTerritory();
            cls.selectedTerritoryLevel = '6';
            cls.getChildrenMonthlyTargetForCurrentTerritory();
            cls.selectedTerritoryLevel = '7';
            cls.getChildrenMonthlyTargetForCurrentTerritory();
            cls.saveMonthlyTargets();
            system.debug('limit query no:::222::   ' + Limits.getQueries());
        }
    }
    
    static testMethod void myUnitTest2() {
        User u = ClsTestHelp.createTestUsers();
        insert u;
        System.runAs(u) {
            Sales_Hierarchy__c sh5 = ClsTestHelp.createTestSalesHierarchy();
            sh5.Level_5_Territory_Code__c = 'A005355';
            sh5.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
            sh5.Level_7_Default_Owner__c = u.Id;
            sh5.Level_5_Assigned_Users__c = u.Id;
            sh5.Level_5_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
            
            Sales_Hierarchy__c sh6 = ClsTestHelp.createTestSalesHierarchy();
            sh6.Level_6_Territory_Code__c = 'A006356';
            sh6.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
            sh6.Level_7_Default_Owner__c = u.Id;
            sh6.Level_6_Assigned_Users__c = u.Id;
            sh6.Level_6_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
            
            Sales_Hierarchy__c sh7 = ClsTestHelp.createTestSalesHierarchy();
            sh7.Level_7_Territory_Code__c = 'A007357';
            sh7.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
            sh7.Level_7_Default_Owner__c = u.Id;
            sh7.Level_7_Assigned_Users__c = u.Id;
            sh7.Level_7_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
            insert new List<Sales_Hierarchy__c>{sh5,sh6,sh7};
            
            Period currYearPeriod;
            String currentFiscalYearName;
            Integer currentFiscalMonthNum;
            Integer currentFiscalQuarterNumber;
            map<String, Integer> map_MonthAbbr_MonthNumber = new map<String, Integer>{'Oct' => 1,'Nov' => 2,'Dec' => 3,'Jan' => 4,'Feb' => 5,'Mar' => 6,'Apr' => 7,'May' => 8,'Jun' => 9,'Jul' => 10,'Aug' => 11,'Sep' => 12};
            for(Period currentPeriod : [SELECT EndDate, FiscalYearSettings.Name, Number, Id, PeriodLabel, 
                                        QuarterLabel, StartDate, Type 
                                        FROM Period 
                                        WHERE (Type = 'Year' OR Type = 'Month' OR Type = 'Quarter')
                                        AND StartDate <= TODAY
                                        AND EndDate >= TODAY ]){
                if(currentPeriod.Type == 'Year'){
                    currYearPeriod = currentPeriod;
                    currentFiscalYearName = currentPeriod.FiscalYearSettings.Name;
                }else if(currentPeriod.Type == 'Month'){
                    currentFiscalMonthNum = map_MonthAbbr_MonthNumber.get(currentPeriod.PeriodLabel);
                }else if(currentPeriod.Type == 'Quarter'){
                    currentFiscalQuarterNumber = currentPeriod.Number;
                }
            }
            
            Monthly_Target__c monthlyTarget = new Monthly_Target__c();
            monthlyTarget.Data_Entry_Year__c = currentFiscalYearName;
            monthlyTarget.Data_Entry_Month__c = currentFiscalMonthNum;
            monthlyTarget.Territory_Code__c = 'A006356';
            monthlyTarget.Territory_Level__c = '6';
            insert monthlyTarget;
            
            Test.startTest();
            CtrlMonthlyTargetBookings cls = new CtrlMonthlyTargetBookings();
            cls.selectedTerritoryCode = 'A007357';
            
            cls.selectedTerritoryLevel = '5';
            cls.getMonthlyTargetBookings();
            Test.stopTest();
        }
    }
    
    static testMethod void myUnitTest3() {
        User u = ClsTestHelp.createTestUsers();
        insert u;
        System.runAs(u) {
            Sales_Hierarchy__c sh5 = ClsTestHelp.createTestSalesHierarchy();
            sh5.Level_5_Territory_Code__c = 'A005355';
            sh5.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
            sh5.Level_7_Default_Owner__c = u.Id;
            sh5.Level_5_Assigned_Users__c = u.Id;
            sh5.Level_5_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
            
            Sales_Hierarchy__c sh5_2 = ClsTestHelp.createTestSalesHierarchy();
            sh5_2.Level_5_Territory_Code__c = 'A007357';
            sh5_2.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
            sh5_2.Level_7_Default_Owner__c = u.Id;
            sh5_2.Level_5_Assigned_Users__c = u.Id;
            sh5_2.Level_5_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
            
            Sales_Hierarchy__c sh5_3 = ClsTestHelp.createTestSalesHierarchy();
            sh5_3.Level_5_Territory_Code__c = 'A007357';
            sh5_3.Level_6_Territory_Code__c = 'A007357';
            sh5_3.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
            sh5_3.Level_7_Default_Owner__c = u.Id;
            sh5_3.Level_5_Assigned_Users__c = u.Id;
            sh5_3.Level_5_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
            
            Sales_Hierarchy__c sh6 = ClsTestHelp.createTestSalesHierarchy();
            sh6.Level_6_Territory_Code__c = 'A006356';
            sh6.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
            sh6.Level_7_Default_Owner__c = u.Id;
            sh6.Level_6_Assigned_Users__c = u.Id;
            sh6.Level_6_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
            
            Sales_Hierarchy__c sh7 = ClsTestHelp.createTestSalesHierarchy();
            sh7.Level_7_Territory_Code__c = 'A007357';
            sh7.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
            sh7.Level_7_Default_Owner__c = u.Id;
            sh7.Level_7_Assigned_Users__c = u.Id;
            sh7.Level_7_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
            insert new List<Sales_Hierarchy__c>{sh5,sh5_2,sh5_3,sh6,sh7};
            
            Account acct = ClsTestHelp.createTestAccounts();
            acct.Type = 'CM';
            acct.AccountNumber = 'test';
            acct.INDUSTRY_BUSINESS_CDE__c = '115'; 
            acct.DD1_Industry_Business_Code__c = '104';
            acct.DD2_Industry_Business_Code__c = '203';
            acct.Sales_Hierarchy__c = sh7.Id;
            insert acct;
            
            Period currYearPeriod;
            String currentFiscalYearName;
            Integer currentFiscalMonthNum;
            Integer currentFiscalQuarterNumber;
            map<String, Integer> map_MonthAbbr_MonthNumber = new map<String, Integer>{'Oct' => 1,'Nov' => 2,'Dec' => 3,'Jan' => 4,'Feb' => 5,'Mar' => 6,'Apr' => 7,'May' => 8,'Jun' => 9,'Jul' => 10,'Aug' => 11,'Sep' => 12};
            for(Period currentPeriod : [SELECT EndDate, FiscalYearSettings.Name, Number, Id, PeriodLabel, 
                                        QuarterLabel, StartDate, Type 
                                        FROM Period 
                                        WHERE (Type = 'Year' OR Type = 'Month' OR Type = 'Quarter')
                                        AND StartDate <= TODAY
                                        AND EndDate >= TODAY ]){
                if(currentPeriod.Type == 'Year'){
                    currYearPeriod = currentPeriod;
                    currentFiscalYearName = currentPeriod.FiscalYearSettings.Name;
                }else if(currentPeriod.Type == 'Month'){
                    currentFiscalMonthNum = map_MonthAbbr_MonthNumber.get(currentPeriod.PeriodLabel);
                }else if(currentPeriod.Type == 'Quarter'){
                    currentFiscalQuarterNumber = currentPeriod.Number;
                }
            }
            
            Monthly_Target__c monthlyTarget = new Monthly_Target__c();
            monthlyTarget.Data_Entry_Year__c = currentFiscalYearName;
            monthlyTarget.Data_Entry_Month__c = currentFiscalMonthNum;
            monthlyTarget.Territory_Code__c = 'A007357';
            monthlyTarget.Territory_Level__c = '7';
            insert monthlyTarget;
            
            Monthly_Target__c monthlyTarget2 = new Monthly_Target__c();
            monthlyTarget2.Data_Entry_Year__c = currentFiscalYearName;
            monthlyTarget2.Territory_Code__c = 'A007357';
            monthlyTarget.Territory_Level__c = '7';
            if(currentFiscalMonthNum == 1) {
                monthlyTarget2.Data_Entry_Month__c = currentFiscalMonthNum;
            }else if(currentFiscalMonthNum == 2) {
                monthlyTarget2.Data_Entry_Month__c = currentFiscalMonthNum - 1;
            }else if(currentFiscalMonthNum > 2) {
                monthlyTarget2.Data_Entry_Month__c = currentFiscalMonthNum - 2;
            }
            insert monthlyTarget2;
            
            Test.startTest();
            CtrlMonthlyTargetBookings cls = new CtrlMonthlyTargetBookings();
            cls.selectedTerritoryCode = 'A007357';
            cls.selectedSalesHierarchyId = acct.Sales_Hierarchy__c;
            
            cls.selectedTerritoryLevel = '4';
            cls.getMonthlyTargetBookings();
            cls.selectedTerritoryLevel = '5';
            cls.getChildrenMonthlyTargetForCurrentTerritory();
            cls.selectedTerritoryLevel = '6';
            cls.getChildrenMonthlyTargetForCurrentTerritory();
            cls.selectedTerritoryLevel = '7';
            cls.getChildrenMonthlyTargetForCurrentTerritory();
            Test.stopTest();
        }
    }
}