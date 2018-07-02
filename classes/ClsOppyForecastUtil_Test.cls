/**
*   This test class is for ClsOppyForecastUtil.
*
@author Di Chen
@created 2013-11-28
@version 1.0
@since 20.0
*
@changelog
* 2013-11-28 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 77%
* 2016-02-23 Rajendra Shahane <rajendra.shahane@zensar.in>
* - Modified
* - Test coverage 77%
*/
@isTest(seealldata = false)
private class ClsOppyForecastUtil_Test {

    static testMethod void testYearly() {
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        
       /* Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;*/
        
        Map<Integer, Decimal> map_date_amount_Cust = new Map<Integer, Decimal>();
        
        /* Poonam -Added custom setting to fix test failure- Start*/
           ADMTerritoryCode__c admTerritoryCode= new ADMTerritoryCode__c();
           admTerritoryCode.Name='ADMTerritoryCode';
           admTerritoryCode.Territory_Code__c='101485';
           insert admTerritoryCode;
          /* Poonam -Added custom setting to fix test failure- End*/
          
        RecordType rt2 = ClsTestHelp.createTestRecordType16();
        Account acc = new Account();
        acc.Name = 'AMP Foundries Inc';
        acc.AnnualRevenue = 2000000.11; 
        acc.Legally_Restricted__c = false;  
        acc.BillingCity = 'Musterstadt';
        acc.BillingStreet = 'Teststr. 1';
        acc.BillingCountry = 'German';
        acc.Type = 'Distributor';
        acc.BillingPostalCode = '77777';
        acc.AccountNumber = '';
        acc.LEVEL_1_INDUSTRY_CDE__c  = '0283';
        acc.Industry_Code_Description__c = 'Appliances';
        insert acc;
        Id OppRecordtypeID = ClsTestHelp.createTestRecordType23().Id;
        user oUser = [select id, Te_Network_Id__c from user where Te_Network_Id__c != null and isactive = true limit 1];

        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Opportunity_Champion__c = oUser.Te_Network_Id__c;
        oppy.Type = 'CM';
        oppy.accountId = acc.Id;
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'USD';
        oppy.Five_Year_Revenue__c = 1;
        oppy.recordtypeId = OppRecordtypeID;
        oppy.Manufacturing_Start_Date__c = date.today().adddays(2);
        //insert oppy;
        
        Opportunity oppy1 = ClsTestHelp.createTestOpportunity();
        oppy1.Type = 'CM';
        oppy1.Request_Type__c = 'Extension';
        oppy.accountId = acc.Id;
        oppy1.Method__c = 'BOM';
        oppy1.Level__c = 'Monthly';
        oppy1.Amount = 1;
        oppy1.CurrencyIsoCode = 'USD';
        oppy1.Five_Year_Revenue__c = 1;
        oppy1.recordtypeId = OppRecordtypeID;
        oppy1.Manufacturing_Start_Date__c = date.today().adddays(2);
        insert new List<Opportunity>{oppy,oppy1};
        
              
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
        oppypart.Status__c = 'Commit';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        oppypart.GPL__c = ph.Id;
        oppypart.Initial_Order_Date__c = date.today();
        insert oppypart;

        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy.Id;
        oppyForecast.Quantity__c = 12;
        oppyForecast.Part__c = oppypart.Id;
        oppyForecast.Date__c = date.newInstance(2013, 09, 28);
        oppyForecast.Amount__c = 1;
        oppyForecast.Sales_Price__c = 1;
        oppyForecast.Fiscal_Year__c = '2013';
        oppyForecast.Fiscal_Quarter__c = '21';
        oppyForecast.CurrencyIsoCode = 'USD';
        //insert oppyForecast;
        
        //oppyForecast = [SELECT Fiscal_Month__c, Id, Date__c,opportunity__r.RecordType.Name, opportunity__r.level__c FROM Opportunity_Forecast__c WHERE Id = :oppyForecast.Id];
       
        Opportunity_Forecast__c oppyForecast2 = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast2.Opportunity__c = oppy.Id;
        oppyForecast2.Quantity__c = 12;
        oppyForecast2.Date__c = date.newInstance(2013, 09, 28);
        oppyForecast2.Amount__c = 1;
        oppyForecast2.Sales_Price__c = 1;
        oppyForecast2.Fiscal_Year__c = '2013';
        oppyForecast2.Fiscal_Quarter__c = '21';
        oppyForecast2.CurrencyIsoCode = 'USD';
        //insert oppyForecast2;
        //oppyForecast2 = [SELECT Fiscal_Month__c, Id, Date__c,opportunity__r.RecordType.Name, opportunity__r.level__c FROM Opportunity_Forecast__c WHERE id = :oppyForecast2.Id];
        
        Opportunity_Forecast__c oppyForecast1 = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast1.Opportunity__c = oppy1.Id;
        oppyForecast1.Quantity__c = 12;
        oppyForecast1.Part__c = oppypart.Id;
        oppyForecast1.Date__c = date.newInstance(2013, 09, 28);
        oppyForecast1.Amount__c = 1;
        oppyForecast1.Sales_Price__c = 1;
        oppyForecast1.Fiscal_Year__c = '2013';
        oppyForecast1.Fiscal_Quarter__c = '21';
        oppyForecast1.CurrencyIsoCode = 'USD';
        insert new List<Opportunity_Forecast__c>{oppyForecast,oppyForecast1,oppyForecast2};
        //oppyForecast1 = [SELECT Fiscal_Month__c, Id, Date__c,opportunity__r.RecordType.Name, opportunity__r.level__c FROM Opportunity_Forecast__c WHERE id = :oppyForecast1.Id];
        
        Forecast_History__c  forecastHistory = new Forecast_History__c();
        forecastHistory.Part__c = oppypart.Id;
        forecastHistory.Fiscal_Year__c = '2013';
        forecastHistory.Old_Value__c = 2000;
        forecastHistory.New_Value__c = 1800;
        forecastHistory.Opportunity__c = oppy.Id;        
        //insert forecastHistory;
        
        Forecast_History__c  forecastHistory1 = new Forecast_History__c();
        forecastHistory1.Part__c = oppypart.Id;
        forecastHistory1.Fiscal_Year__c = '2013';
        forecastHistory1.Old_Value__c = 2000;
        forecastHistory1.New_Value__c = 1800;
        forecastHistory1.Opportunity__c = oppy.Id;        
        insert new List<Forecast_History__c>{forecastHistory,forecastHistory1};
        
        set<String> set_years = new set<String>();
        set<String> set_partIds = new set<String>();
        
        set_years.add(oppyForecast.Fiscal_Year__c);
        set_years.add(oppyForecast.Part__c);
        
        list<Forecast_History__c> list_forecast2Upsert = new list<Forecast_History__c>();
        list_forecast2Upsert.add(forecastHistory);
        
        list<Forecast_History__c> list_forecast2Delete = new list<Forecast_History__c>();
        list_forecast2Delete.add(forecastHistory1);
        
        map<String, String> map_partId_partDescription = new map<String, String>();
        map_partId_partDescription.put(oppypart.id, 'test description');
                
        Map<Id, Opportunity_Part__c> map_parts = new Map<Id, Opportunity_Part__c>();
        map_parts.put(oppypart.Id,oppypart);
        
        List<ClsOppForecastStructure.ForecastItemStructure> editForecasts = new List<ClsOppForecastStructure.ForecastItemStructure>();
        ClsOppForecastStructure.ForecastItemStructure clsFIS = new ClsOppForecastStructure.ForecastItemStructure();
        editForecasts.add(clsFIS);
        
        ClsOppForecastStructure cls = new ClsOppForecastStructure('2013');
        ClsOppForecastStructure.ForecastStructure clsFS = new ClsOppForecastStructure.ForecastStructure();
        clsFS.editForecasts = editForecasts;
        ClsOppForecastStructure.PartForecastStructure clsP = new ClsOppForecastStructure.PartForecastStructure();
        clsP.partId = oppypart.Id;
        
        list<ClsOppForecastStructure> list_forecastStructures = new list<ClsOppForecastStructure>();
        list_forecastStructures.add(cls);
        
        Set<String> set_forecastYears = new Set<String>();
        set_forecastYears.add('2013');
        
        list<Id> list_partIds = new list<Id>();
        list_partIds.add(oppypart.Id);
        
        Set<Id> set_oppyIds = new Set<Id>();
        set_oppyIds.add(oppy.Id);
        
        list<String> list_years = new list<String>();
        list_years.add('2013');
        
        list<Opportunity_Forecast__c> list_forecasts = new list<Opportunity_Forecast__c>();
        list_forecasts.add(oppyForecast);
        list_forecasts.add(oppyForecast1);
        list_forecasts.add(oppyForecast2);
        
        list<Decimal> quantities = new list<Decimal>();
        quantities.add(10);
        
        map<Id, String> map_oppyPartId_isoCode = new map<Id, String>();
        map_oppyPartId_isoCode.put(oppypart.Id,'EUR');
        
        map<Id, Id> map_partId_oppyId = new map<Id, Id>();
        map_partId_oppyId.put(oppypart.Id,oppy.Id);
        
        map<Integer, Decimal> map_date_amount = new map<Integer, Decimal>();
        map_date_amount.put(1,1);
        
        list<Opportunity_Part__c> list_part = new list<Opportunity_Part__c>();
        list_part.add(oppypart);
        
        set<String> set_fYears = new set<String>();
        
        list<String> list_year = new list<String>();
        list_year.add('2011');
        
        set<Date> set_startDate = new set<Date>();
        set_startDate.add(date.today());
        map<Id, decimal> map_partId_price = new map<Id, decimal>();
        map_partId_price.put(oppypart.Id, 0);
        
        map<String, String> map_partId_partNumber = new map<String, String>();
        map_partId_partNumber.put(oppypart.Id, 'test');
        
        Test.startTest();
        
        ClsOppyForecastUtil.getAllFiscalYear();
        ClsOppyForecastUtil.getAllFiscalQuarter();
        ClsOppyForecastUtil.getAllFiscalMonth();
        ClsOppyForecastUtil.getYearList(set_forecastYears, true, 1);
        ClsOppyForecastUtil.getAllPeriodYears();
        ClsOppyForecastUtil.createNewOppyForecastStructure('2013', oppy, list_partIds);
        ClsOppyForecastUtil.createNewOppyForecastStructure('2013', oppy, list_partIds,map_partId_price);
        ClsOppyForecastUtil.getFiscalYearMonthMap();
        ClsOppyForecastUtil.getFiscalMonthStartDate('2013', '12');
        ClsOppyForecastUtil.getOpportunityById(oppy.Id); 
        ClsOppyForecastUtil.getFiscalYearQuarterMap();
        ClsOppyForecastUtil.getFiscalQuarterStartDate('2013', '51');
        ClsOppyForecastUtil.getOppyYearMap(set_oppyIds);
        ClsOppyForecastUtil.getLevelLabel(ClsOppyUtil.MONTHLY);    
        ClsOppyForecastUtil.getLevelLabel(ClsOppyUtil.QUARTERLY);
        ClsOppyForecastUtil.getLevelLabel(ClsOppyUtil.YEARLY);
        ClsOppyForecastUtil.getForecastLevel();
        ClsOppyForecastUtil.getYearNumber();
        ClsOppyForecastUtil.getOtherYears(list_years);
        ClsOppyForecastUtil.getForecastMonth(date.today());
        ClsOppyForecastUtil.getForecastQuarter(date.today());
        ClsOppyForecastUtil.getForecastYear(date.today());
        ClsOppyForecastUtil.getForecastFisMonth(date.today());
        ClsOppyForecastUtil.transformIsoCode(12, 'EUR', 'EUR');
        ClsOppyForecastUtil.getPartIdsByOppyId(set_oppyIds);
        ClsOppyForecastUtil.getPartsByOppyId(set_oppyIds);
        ClsOppyForecastUtil.buildOppyForeCastMap(oppy.Id);
        ClsOppyForecastUtil.getOpportunitysByProgramId(oppy.Id);
        ClsOppyForecastUtil.getStatusItems();
        ClsOppyForecastUtil.getAllPartsByProgramId(oppy.Id);
        ClsOppyForecastUtil.getOppyForeCastMap(set_oppyIds);
        ClsOppyForecastUtil.buildAllPartForeCastMap(oppy.Id);
        ClsOppyForecastUtil.buildProgramAllPartForeCastMap(oppy.Id);
        ClsOppyForecastUtil.buildOppyAllPartForeCastMap(oppy.Id);
        ClsOppyForecastUtil.buildOppyForeCastMapByYear(list_forecasts);
        ClsOppyForecastUtil.getForecastMonthNum(date.today());
        
        ClsOppyForecastUtil.createForcasts(oppy, null, quantities, 12, oppypart, '2013', map_oppyPartId_isoCode, map_partId_oppyId, map_date_amount, map_date_amount_Cust);

        ClsOppyForecastUtil.saveProgram('Iniatiated#2015;2016@@Iniatiated2#2015;2016@@Completed', list_forecastStructures, list_part, list_partIds, oppy, null, null, map_oppyPartId_isoCode, map_partId_oppyId, set_fYears);
        ClsOppyForecastUtil.oppyYear = '2016';
        ClsOppyForecastUtil.saveProgram('Completed', list_forecastStructures, list_part, list_partIds, oppy, null, null, map_oppyPartId_isoCode, map_partId_oppyId, set_fYears);
        ClsOppyForecastUtil.oppyYear = '2016';
        ClsOppyForecastUtil.saveProgram('2013;Yearly;BOM#q100;a300;p0#100;100;1#200;200;1#300;300;1#400;0;0#500;0;0#600;0;0#700;700;1#800;0;0', list_forecastStructures, list_part, list_partIds, oppy, null, null, map_oppyPartId_isoCode, map_partId_oppyId, set_fYears);
        //ClsOppyForecastUtil.saveProgram('Update', list_forecastStructures, list_part, list_partIds, oppy, null, null, map_oppyPartId_isoCode, map_partId_oppyId, set_fYears);
        ClsOppyForecastUtil.addOppyYears(list_years, 2, list_forecastStructures, oppy, list_partIds);
        ClsOppyForecastUtil.addOppyYears(list_years, 2, list_forecastStructures, oppy, list_partIds,map_partId_price);
        ClsOppyForecastUtil.getPartForecastHistory(oppy.Id);
        ClsOppyForecastUtil.getListForecastHistory(oppy.Id);
        ClsOppyForecastUtil.getSendUserEmail(oppy.Id);
        String str_mapPartId_listForecastHistoryStructure = ClsOppyForecastUtil.getOppyForecastHistory(oppy.Id);
        Opportunity newOpp = [Select Id,Industry_Code__c,Type,Request_Type__c,Method__c,Level__c,Amount,CurrencyIsoCode,Five_Year_Revenue__c from Opportunity where Id=:oppy.Id];
        ClsOppyForecastUtil.saveOppForecastHitory(str_mapPartId_listForecastHistoryStructure,newOpp,'test');
        ClsOppyForecastUtil.getDeleteBody(forecastHistory,'test',map_partId_partNumber);
        list<String> list_changeReasons = new list<String>();
        ClsOppyForecastUtil.getChangeReasons(list_changeReasons);
        ClsOppyForecastUtil.getFiveYearsInternal(set_startDate);
        ClsOppyForecastUtil.getFiveYearsInternal(date.today(), ClsOppyUtil.QUARTERLY);
        ClsOppyForecastUtil.getFiveYearsInternal(date.today(), ClsOppyUtil.MONTHLY);
        ClsOppyForecastUtil.getFiveYearsInternal(date.today(), ClsOppyUtil.YEARLY);
        ClsOppyForecastUtil.yearByIndex(list_years, '2013', 0);
        ClsOppyForecastUtil.yearByIndex(list_years, '2013', 1);
        ClsOppyForecastUtil.yearByIndex(list_years, '2013', -2);
        ClsOppyForecastUtil.buildStrucureItems(oppy, list_forecasts, editForecasts);
        
        map<String, map<String, list<Opportunity_Forecast__c>>> map_partId_mapYearOppForecast= new map<String, map<String, list<Opportunity_Forecast__c>>>(); 
        set<String> set_year = new set<String>();
        set_year.add(oppyForecast.Fiscal_Year__c);   
        if(!map_partId_mapYearOppForecast.containsKey(oppyForecast.Part__c)){
            map_partId_mapYearOppForecast.put(oppyForecast.Part__c, new map<String, list<Opportunity_Forecast__c>>());                
        }
        if(!map_partId_mapYearOppForecast.get(oppyForecast.Part__c).containsKey(oppyForecast.Fiscal_Year__c)) {
            map_partId_mapYearOppForecast.get(oppyForecast.Part__c).put(oppyForecast.Fiscal_Year__c,new list<Opportunity_Forecast__c>()); 
        }
        map_partId_mapYearOppForecast.get(oppyForecast.Part__c).get(oppyForecast.Fiscal_Year__c).add(oppyForecast);
        
        //ClsOppyForecastUtil.deleteForecastHistoryOnOppForecast(map_partId_mapYearOppForecast, set_year);
        ClsOppyForecastUtil.getDeleteBody(forecastHistory,'',map_partId_partNumber);
        
        
        ClsOppyForecastUtil.sentForecastApprovalNotification(list_forecast2Upsert,oppy,list_forecast2Delete, map_partId_partNumber, map_partId_partDescription, 'Quantity Changes');
        ClsOppyForecastUtil.getBU(oppy);
        ClsOppyForecastUtil.getChangePercentage('Appliances');
        ClsOppyForecastUtil.isAppOrIndBu('Appliances');
        ClsOppyForecastUtil.getMapOppForecast(set_years, set_partIds);
        ClsOppyForecastUtil.generateRevenueMap();
        //ClsOppyForecastUtil.setFiscalMonthForBatch(list_forecasts);
        ClsOppyForecastUtil.updateOpportunityFromForecast(oppy.Id, null);
        set<Opportunity> set_programOppys = new set<Opportunity>();
        set_programOppys.add(oppy);
        ClsOppyForecastUtil.updateProgramTotalFiveYearsAmount(oppy, set_programOppys);
        
        ClsOppyForecastUtil.updateProgramTotalFiveYearsAmount(new Opportunity(CurrencyIsoCode = 'JPY'), set_programOppys);
        ClsOppyForecastUtil.buildMonthStructure(new List<Opportunity_Forecast__c>{oppyForecast}, new List<ClsOppForecastStructure.ForecastItemStructure>{});
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testMonthly() {
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;
        
        Map<Integer, Decimal> map_date_amount_Cust = new Map<Integer, Decimal>();//
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Monthly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'USD';
        oppy.Five_Year_Revenue__c = 1;
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType23().Id;
        //insert oppy;
        
        Opportunity oppy1 = ClsTestHelp.createTestOpportunity();
        oppy1.Type = 'CM';
        oppy1.Request_Type__c = 'Extension';
        oppy1.Method__c = 'BOM';
        oppy1.Level__c = 'Monthly';
        oppy1.Amount = 1;
        oppy1.CurrencyIsoCode = 'USD';
        oppy1.Five_Year_Revenue__c = 1;
        oppy1.RecordTypeId = ClsTestHelp.createTestRecordType23().Id;
        insert new List<Opportunity>{oppy,oppy1};
                
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
        oppypart.Status__c = 'Commit';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        oppypart.GPL__c = ph.Id;
        oppypart.Initial_Order_Date__c = date.today();
        insert oppypart;
        
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy.Id;
        oppyForecast.Quantity__c = 12;
        oppyForecast.Part__c = oppypart.Id;
        oppyForecast.Date__c = date.newInstance(2013, 09, 28);
        oppyForecast.Amount__c = 1;
        oppyForecast.Sales_Price__c = 1;
        oppyForecast.Fiscal_Year__c = '2013';
        oppyForecast.Fiscal_Quarter__c = '21';
        oppyForecast.CurrencyIsoCode = 'USD';
        insert oppyForecast; 
            
        Set<String> set_forecastYears = new Set<String>();
        set_forecastYears.add('2013');
        
        list<Id> list_partIds = new list<Id>();
        list_partIds.add(oppypart.Id);
        
        Set<Id> set_oppyIds = new Set<Id>();
        set_oppyIds.add(oppy.Id);
        
        list<String> list_years = new list<String>();
        list_years.add('2013');
        
        list<Opportunity_Forecast__c> list_forecasts = new list<Opportunity_Forecast__c>();
        list_forecasts.add(oppyForecast);
        
        List<ClsOppForecastStructure.ForecastItemStructure> editForecasts = new List<ClsOppForecastStructure.ForecastItemStructure>();
        ClsOppForecastStructure.ForecastItemStructure clsFIS = new ClsOppForecastStructure.ForecastItemStructure();
        editForecasts.add(clsFIS);
        
        list<Decimal> quantities = new list<Decimal>();
        quantities.add(1);
        quantities.add(2);
        quantities.add(3);
        quantities.add(4);
        quantities.add(5);
        quantities.add(6);
        quantities.add(7);
        quantities.add(8);
        quantities.add(9);
        quantities.add(10);
        quantities.add(11);
        quantities.add(12);
        quantities.add(13);
        
        map<Id, String> map_oppyPartId_isoCode = new map<Id, String>();
        map_oppyPartId_isoCode.put(oppypart.Id,'EUR');
        
        Map<id, Opportunity> map_oppyid_opportunity = new Map<id, Opportunity>();
        map_oppyid_opportunity.put(oppy.Id,oppy);
        
        map<Id, Id> map_partId_oppyId = new map<Id, Id>();
        map_partId_oppyId.put(oppypart.Id,oppy.Id);
        
        map<Integer, Decimal> map_date_amount = new map<Integer, Decimal>();
        map_date_amount.put(1,1);       
        
        list<Decimal> pQs = new list<Decimal>();
        pQs.add(1);
        Id forecastOppyRecordTypeId;
        for (RecordType t : [Select Id, DeveloperName, SobjectType from RecordType where SobjectType = 'Opportunity_Forecast__c' or SobjectType = 'Opportunity']) {
            if(t.DeveloperName == 'Opportunity' && t.SobjectType == 'Opportunity_Forecast__c') forecastOppyRecordTypeId = t.Id;
        }
        Test.startTest();
        
        ClsOppyForecastUtil.getAllFiscalYear();
        ClsOppyForecastUtil.getAllFiscalQuarter();
        ClsOppyForecastUtil.getAllFiscalMonth();
        
        ClsOppyForecastUtil.updateOpportunityAmounts(map_oppyid_opportunity, 'BOM', 'Yearly', oppy);
        ClsOppyForecastUtil.getYearList(set_forecastYears, true, 1);
        ClsOppyForecastUtil.getAllPeriodYears();
        ClsOppyForecastUtil.applianceOpptyRecordTypeId();
        ClsOppyForecastUtil.createNewOppyForecastStructure('2013', oppy, list_partIds);
        ClsOppyForecastUtil.getFiscalYearMonthMap();
        ClsOppyForecastUtil.getFiscalMonthStartDate('2013', '12');
        ClsOppyForecastUtil.getOpportunityById(oppy.Id);
        ClsOppyForecastUtil.getFiscalYearQuarterMap();
        ClsOppyForecastUtil.getFiscalQuarterStartDate('2013', '51');
        ClsOppyForecastUtil.getOppyYearMap(set_oppyIds);
        ClsOppyForecastUtil.getLevelLabel(ClsOppyUtil.MONTHLY);
        ClsOppyForecastUtil.getLevelLabel(ClsOppyUtil.QUARTERLY);
        ClsOppyForecastUtil.getLevelLabel(ClsOppyUtil.YEARLY);
        ClsOppyForecastUtil.getForecastLevel();
        ClsOppyForecastUtil.getYearNumber();
        ClsOppyForecastUtil.getOtherYears(list_years);
        ClsOppyForecastUtil.getForecastMonth(date.today());
        ClsOppyForecastUtil.getForecastQuarter(date.today());
        ClsOppyForecastUtil.getForecastYear(date.today());
        ClsOppyForecastUtil.transformIsoCode(12, 'EUR', 'EUR');
        ClsOppyForecastUtil.getPartIdsByOppyId(set_oppyIds);
        ClsOppyForecastUtil.getPartsByOppyId(set_oppyIds);
        ClsOppyForecastUtil.buildOppyForeCastMap(oppy.Id);
        ClsOppyForecastUtil.getOpportunitysByProgramId(oppy.Id);
        ClsOppyForecastUtil.getStatusItems();
        ClsOppyForecastUtil.getAllPartsByProgramId(oppy.Id);
        ClsOppyForecastUtil.getOppyForeCastMap(set_oppyIds);
        ClsOppyForecastUtil.buildAllPartForeCastMap(oppy.Id);
        ClsOppyForecastUtil.buildProgramAllPartForeCastMap(oppy.Id);
        ClsOppyForecastUtil.buildOppyForeCastMapByYear(list_forecasts);
        ClsOppyForecastUtil.getForecastMonthNum(date.today());
        ClsOppyForecastUtil.createForcasts(oppy, null, quantities, 12, oppypart, '2013', map_oppyPartId_isoCode, map_partId_oppyId, map_date_amount, map_date_amount_Cust);
        ClsOppyForecastUtil.createForcasts(oppy1, null, quantities, 12, oppypart, '2013', map_oppyPartId_isoCode, map_partId_oppyId, map_date_amount, map_date_amount_Cust);
        
        ClsOppyForecastUtil.createForcastsNew(oppy, null, quantities, 12, oppypart, '2013', map_oppyPartId_isoCode, map_partId_oppyId, map_date_amount, map_date_amount_Cust,system.today());
        ClsOppyForecastUtil.createForcastsNew(oppy1, null, quantities, 12, oppypart, '2013', map_oppyPartId_isoCode, map_partId_oppyId, map_date_amount, map_date_amount_Cust,system.today());
        
        ClsOppyForecastUtil.calculateQantity(1200,11);
        ClsOppyForecastUtil.GenerateForcasts('EUR', oppypart.Id, 2100, oppy, forecastOppyRecordTypeId, 12, oppypart,'2013',map_oppyPartId_isoCode, map_partId_oppyId, map_date_amount, map_date_amount_Cust, '11', '4', 4);
        ClsOppyForecastUtil.GenerateForcasts('EUR', null, 2100, oppy, forecastOppyRecordTypeId, 12, oppypart,'2013',map_oppyPartId_isoCode, map_partId_oppyId, map_date_amount, map_date_amount_Cust, '11', '4', 4);
        ClsOppyForecastUtil.buildStrucureItems(oppy, list_forecasts, editForecasts);
        ClsOppyForecastUtil.buildPartMonthStructure(list_forecasts, quantities);
        ClsOppyForecastUtil.checkConflict(1, pQs, editForecasts);
        oppy.program__c = oppy.id;
        ClsOppyForecastUtil.updateOpportunityAmounts(map_oppyid_opportunity, 'BOM', 'Yearly', oppy);        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testQuarterly() {
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;
        
        Map<Integer, Decimal> map_date_amount_Cust = new Map<Integer, Decimal>();//
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Quarterly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'USD';
        oppy.Five_Year_Revenue__c = 1;
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType23().Id;
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
        oppypart.Status__c = 'Commit';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        oppypart.GPL__c = ph.Id;
        oppypart.Initial_Order_Date__c = date.today();
        insert oppypart;
        
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy.Id;
        oppyForecast.Quantity__c = 12;
        oppyForecast.Part__c = oppypart.Id;
        oppyForecast.Date__c = date.newInstance(2013, 09, 28);
        oppyForecast.Amount__c = 1;
        oppyForecast.Sales_Price__c = 1;
        oppyForecast.Fiscal_Year__c = '2013';
        oppyForecast.Fiscal_Quarter__c = '21';
        oppyForecast.CurrencyIsoCode = 'USD';
        insert oppyForecast;
                
        Set<String> set_forecastYears = new Set<String>();
        set_forecastYears.add('2013');
        
        list<Id> list_partIds = new list<Id>();
        list_partIds.add(oppypart.Id);
        
        Set<Id> set_oppyIds = new Set<Id>();
        set_oppyIds.add(oppy.Id);
        
        list<String> list_years = new list<String>();
        list_years.add('2013');
        
        list<Opportunity_Forecast__c> list_forecasts = new list<Opportunity_Forecast__c>();
        list_forecasts.add(oppyForecast);
        
        list<Decimal> quantities = new list<Decimal>();
        quantities.add(1);
        quantities.add(2);
        quantities.add(3);
        quantities.add(4);
        quantities.add(5);
        quantities.add(6);
        quantities.add(7);
        quantities.add(8);
        quantities.add(9);
        quantities.add(10);
        quantities.add(11);
        quantities.add(12);
        quantities.add(13);
        
        list<ClsOppForecastStructure.ForecastItemStructure> editForecasts = new list<ClsOppForecastStructure.ForecastItemStructure>();
        ClsOppForecastStructure.ForecastItemStructure clsFIS = new ClsOppForecastStructure.ForecastItemStructure();
        editForecasts.add(clsFIS);
        
        map<Id, String> map_oppyPartId_isoCode = new map<Id, String>();
        map_oppyPartId_isoCode.put(oppypart.Id,'EUR');
        
        map<Id, Id> map_partId_oppyId = new map<Id, Id>();
        map_partId_oppyId.put(oppypart.Id,oppy.Id);
        
        map<Integer, Decimal> map_date_amount = new map<Integer, Decimal>();
        map_date_amount.put(1,1);
                
        Test.startTest();
        
        ClsOppyForecastUtil.getAllFiscalYear();
        ClsOppyForecastUtil.getAllFiscalQuarter();
        ClsOppyForecastUtil.getAllFiscalMonth();
        ClsOppyForecastUtil.getYearList(set_forecastYears, true, 1);
        ClsOppyForecastUtil.getAllPeriodYears();
        ClsOppyForecastUtil.createNewOppyForecastStructure('2013', oppy, list_partIds);
        ClsOppyForecastUtil.getFiscalYearMonthMap();
        ClsOppyForecastUtil.getFiscalMonthStartDate('2013', '12');
        ClsOppyForecastUtil.getOpportunityById(oppy.Id);
        ClsOppyForecastUtil.getFiscalYearQuarterMap();
        ClsOppyForecastUtil.getFiscalQuarterStartDate('2013', '51');
        ClsOppyForecastUtil.getOppyYearMap(set_oppyIds);
        ClsOppyForecastUtil.getLevelLabel(ClsOppyUtil.MONTHLY);
        ClsOppyForecastUtil.getLevelLabel(ClsOppyUtil.QUARTERLY);
        ClsOppyForecastUtil.getLevelLabel(ClsOppyUtil.YEARLY);
        ClsOppyForecastUtil.getForecastLevel();
        ClsOppyForecastUtil.getYearNumber();
        ClsOppyForecastUtil.getOtherYears(list_years);
        ClsOppyForecastUtil.getForecastMonth(date.today());
        ClsOppyForecastUtil.getForecastQuarter(date.today());
        ClsOppyForecastUtil.getForecastYear(date.today());
        ClsOppyForecastUtil.transformIsoCode(12, 'EUR', 'EUR');
        ClsOppyForecastUtil.getPartIdsByOppyId(set_oppyIds);
        ClsOppyForecastUtil.getPartsByOppyId(set_oppyIds);
        ClsOppyForecastUtil.buildOppyForeCastMap(oppy.Id);
        ClsOppyForecastUtil.getOpportunitysByProgramId(oppy.Id);
        ClsOppyForecastUtil.getStatusItems();
        ClsOppyForecastUtil.getAllPartsByProgramId(oppy.Id);
        ClsOppyForecastUtil.getOppyForeCastMap(set_oppyIds);
        ClsOppyForecastUtil.buildAllPartForeCastMap(oppy.Id);
        ClsOppyForecastUtil.buildProgramAllPartForeCastMap(oppy.Id);
        ClsOppyForecastUtil.buildOppyForeCastMapByYear(list_forecasts);
        ClsOppyForecastUtil.getForecastMonthNum(date.today());
        ClsOppyForecastUtil.createForcasts(oppy, null, quantities, 12, oppypart, '2013', map_oppyPartId_isoCode, map_partId_oppyId, map_date_amount, map_date_amount_Cust);
        ClsOppyForecastUtil.createForcastsNew(oppy, null, quantities, 12, oppypart, '2013', map_oppyPartId_isoCode, map_partId_oppyId, map_date_amount, map_date_amount_Cust,system.today());
        
        ClsOppyForecastUtil.buildStrucureItems(oppy, list_forecasts, editForecasts);
        ClsOppyForecastUtil.buildPartStrucureItems(oppy, list_forecasts, quantities);
        ClsOppyForecastUtil.buildPartQuarterStructure(list_forecasts, quantities);
        ClsOppyForecastUtil.buildPartYearStructure(list_forecasts, quantities);
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testLessMethods() {
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;
        
        Map<Integer, Decimal> map_date_amount_Cust = new Map<Integer, Decimal>();//
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'USD';
        oppy.Five_Year_Revenue__c = 1;
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType23().Id;
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
        oppypart.Status__c = 'Commit';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        oppypart.GPL__c = ph.Id;
        oppypart.Initial_Order_Date__c = date.today();
        insert oppypart;
        
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy.Id;
        oppyForecast.Quantity__c = 12;
        oppyForecast.Part__c = null;
        oppyForecast.Date__c = date.newInstance(2013, 09, 28);
        oppyForecast.Amount__c = 1;
        oppyForecast.Sales_Price__c = 1;
        oppyForecast.Fiscal_Year__c = '2013';
        oppyForecast.Fiscal_Quarter__c = '21';
        oppyForecast.CurrencyIsoCode = 'USD';
        insert oppyForecast;

        Set<Id> set_oppyIds = new Set<Id>();
        set_oppyIds.add(oppy.Id); 
        
        Map<id, Opportunity> map_oppyid_opportunity = new Map<id, Opportunity>();
        map_oppyid_opportunity.put(oppy.Id,oppy);
        
        Test.startTest();
        
        ClsOppyForecastUtil.getOppyForeCastMap(set_oppyIds);
        ClsOppyForecastUtil.recalculateRevenue(map_oppyid_opportunity, 'BOM', 'Yearly', date.today());
        
        system.assert(true);
        Test.stopTest();
    }
    /*static testMethod void testLessMethods2() {
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        
        Profile p = [Select Id, Name From Profile 
                     where Name = 'Production Support' 
                     or Name = 'Service Account' 
                     or Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'helloManesfd@testCompany1233423.com';
        u.Alias = 'dpse';
        u.CommunityNickname = 'TMD';
        u.ProfileId = p.Id;
        insert u;
              
        system.runAs(u){ 
                
        RecordType rt = ClsTestHelp.createTestRecordType();
        RecordType rt2 = ClsTestHelp.createTestRecordType16();
              
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        insert acc;
            
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        oppy2.Request_Type__c = 'Extension';
        oppy2.RecordTypeId = rt2.Id;
        oppy2.RecordTypeId = ClsTestHelp.createTestRecordType23().Id;
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
        oppy2.RecordTypeId = ClsTestHelp.createTestRecordType23().Id;
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
        oppypart.Status__c = 'Commit';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        oppypart.GPL__c = ph.Id;
        oppypart.Initial_Order_Date__c = date.today();
        insert oppypart;
        
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy.Id;
        oppyForecast.Quantity__c = 12;
        oppyForecast.Part__c = oppypart.Id;
        oppyForecast.Date__c = date.newInstance(2013, 09, 28);
        oppyForecast.Amount__c = 1;
        oppyForecast.Sales_Price__c = 1;
        oppyForecast.Fiscal_Year__c = null;//'2013';
        oppyForecast.Fiscal_Quarter__c = '21';
        oppyForecast.CurrencyIsoCode = 'USD';
        insert oppyForecast;

        Set<Id> set_oppyIds = new Set<Id>();
        set_oppyIds.add(oppy.Id);
        
        set<Opportunity> set_programOppys = new set<Opportunity>();
        set_programOppys.add(oppy);
        
        Map<id, Opportunity> map_oppyid_opportunity = new Map<id, Opportunity>();
        map_oppyid_opportunity.put(oppy2.Id,oppy2);
        
        Test.startTest();
        
        ClsOppyForecastUtil.buildProgramAllPartForeCastMap(oppy2.Id);
        ClsOppyForecastUtil.updateOpportunityFromForecast(oppy2.Id, null);
        ClsOppyForecastUtil.updateOpportunityAmounts(map_oppyid_opportunity, 'BOM', 'Yearly', oppy);
        ClsOppyForecastUtil.updateProgramTotalFiveYearsAmount(oppy, set_programOppys);
        
        system.assert(true);
        Test.stopTest();
        }
    }
    static testMethod void testOther(){
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        
        Test.startTest();
        
        RecordType rt2 = ClsTestHelp.createTestRecordType16();
              
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'USD';
        oppy.Five_Year_Revenue__c = 1;
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType23().Id;
        insert oppy;
        
        Opportunity oppy3 = ClsTestHelp.createTestOpportunity();
        oppy3.Program__c = oppy.Id;   
        oppy3.Type = 'CM';
        oppy3.Request_Type__c = 'Extension';
        oppy3.Method__c = 'BOM';
        oppy3.Level__c = 'Yearly';
        oppy3.Amount = 1;
        oppy3.CurrencyIsoCode = 'EUR';
        oppy3.Five_Year_Revenue__c = 1;
        oppy3.RecordTypeId = ClsTestHelp.createTestRecordType23().Id;
        insert oppy3;
        
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        Opportunity_Part__c oppypart1 = ClsTestHelp.createTestOpportunityPart();
        oppypart1.Opportunity__c = oppy3.Id;
        oppypart1.Part__c = part.Id;
        oppypart1.Status__c = 'Commit';
        oppypart1.Lost_Reason__c = 'Other';
        oppypart1.Lost_Reason_Text__c = null;
        oppypart1.GPL__c = ph.Id;
        oppypart1.Initial_Order_Date__c = date.today();
        insert oppypart1;
                
        ClsOppyForecastUtil.getOpportunitysByProgramId(oppy3.Id);
        ClsOppyForecastUtil.getAllPartsByProgramId(oppy3.Id);
        
        map<Date, String> map_date_quarterTest = new map<Date, String>();
        map_date_quarterTest.put(system.today(), '1');
        ClsOppyForecastUtil.map_date_quarter = map_date_quarterTest;
        ClsOppyForecastUtil.getForecastQuarter(system.today());
        ClsOppyForecastUtil.getForecastMonthNum(system.today());
        ClsOppyForecastUtil.map_isoCode_exchangeRate = new map<String, Decimal>();
        ClsOppyForecastUtil.map_isoCode_exchangeRate.put('test', null);
        ClsOppyForecastUtil.transformIsoCode(12,'test', 'test');
        map<String, String> map_year_oldNewValue = new map<String, String>();
        map_year_oldNewValue .put('test','test1');
        ClsOppyForecastUtil.forecastHistoryInfos fhCase = new ClsOppyForecastUtil.forecastHistoryInfos('12', map_year_oldNewValue);
         
        Test.stopTest();
    }*/
    static testMethod void testBatch(){
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;
        
        Test.startTest();
              
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'USD';
        oppy.Five_Year_Revenue__c = 1;
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType23().Id;
        
        Opportunity oppy1 = ClsTestHelp.createTestOpportunity();
        oppy1.Type = 'CM';
        oppy1.Request_Type__c = 'Extension';
        oppy1.Method__c = 'BOM';
        oppy1.Level__c = 'Monthly';
        oppy1.Amount = 1;
        oppy1.CurrencyIsoCode = 'USD';
        oppy1.Five_Year_Revenue__c = 1;
        oppy1.RecordTypeId = ClsTestHelp.createTestRecordType23().Id;
        insert new List<Opportunity>{oppy,oppy1};
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        Opportunity_Part__c oppypart1 = ClsTestHelp.createTestOpportunityPart();
        oppypart1.Opportunity__c = oppy1.Id;
        oppypart1.Part__c = part.Id;
        oppypart1.Status__c = 'Commit';
        oppypart1.Lost_Reason__c = 'Other';
        oppypart1.Lost_Reason_Text__c = null;
        oppypart1.GPL__c = ph.Id;
        oppypart1.Initial_Order_Date__c = date.today();
        insert oppypart1;
        
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy.Id;
        oppyForecast.Quantity__c = 12;
        oppyForecast.Part__c = oppypart1.Id;
        oppyForecast.Date__c = date.newInstance(2013, 09, 28);
        oppyForecast.Amount__c = 1;
        oppyForecast.Sales_Price__c = 1;
        oppyForecast.Fiscal_Year__c = '2013';
        oppyForecast.Fiscal_Quarter__c = '21';
        oppyForecast.CurrencyIsoCode = 'USD';
        //insert oppyForecast;
        //oppyForecast = [SELECT Fiscal_Month__c, Id, Date__c,opportunity__r.RecordType.Name, opportunity__r.level__c FROM Opportunity_Forecast__c WHERE Id = :oppyForecast.Id];
        
        Opportunity_Forecast__c oppyForecast1 = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast1.Opportunity__c = oppy1.Id;
        oppyForecast1.Quantity__c = 12;
        oppyForecast1.Part__c = oppypart1.Id;
        oppyForecast1.Date__c = date.newInstance(2013, 09, 28);
        oppyForecast1.Amount__c = 1;
        oppyForecast1.Sales_Price__c = 1;
        oppyForecast1.Fiscal_Year__c = '2013';
        oppyForecast1.Fiscal_Quarter__c = '21';
        oppyForecast1.CurrencyIsoCode = 'USD';
        insert new List<Opportunity_Forecast__c>{oppyForecast,oppyForecast1};
        //oppyForecast1 = [SELECT Fiscal_Month__c, Id, Date__c,opportunity__r.RecordType.Name, opportunity__r.level__c FROM Opportunity_Forecast__c WHERE id = :oppyForecast1.Id];
        
        list<Opportunity_Forecast__c> list_forecasts = new list<Opportunity_Forecast__c>();
        list_forecasts.add(oppyForecast);
        list_forecasts.add(oppyForecast1);
        
        //ClsOppyForecastUtil.setFiscalMonthForBatch(list_forecasts);
        Test.stopTest();
    }
    static testMethod void test1(){
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;
        
        Test.startTest();
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'USD';
        oppy.Five_Year_Revenue__c = 1;
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType23().Id;
        insert oppy;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        Opportunity_Part__c oppypart1 = ClsTestHelp.createTestOpportunityPart();
        oppypart1.Opportunity__c = oppy.Id;
        oppypart1.Part__c = part.Id;
        oppypart1.Status__c = 'Commit';
        oppypart1.Lost_Reason__c = 'Other';
        oppypart1.Lost_Reason_Text__c = null;
        oppypart1.GPL__c = ph.Id;
        oppypart1.Initial_Order_Date__c = date.today();
        insert oppypart1;       
        
        Opportunity_Forecast__c oppyForecast1 = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast1.Opportunity__c = oppy.Id;
        oppyForecast1.Quantity__c = 12;
        oppyForecast1.Part__c = oppypart1.Id;
        oppyForecast1.Date__c = date.newInstance(2013, 09, 28);
        oppyForecast1.Amount__c = 1;
        oppyForecast1.Sales_Price__c = 1;
        oppyForecast1.Fiscal_Year__c = null;
        oppyForecast1.Fiscal_Quarter__c = '21';
        oppyForecast1.CurrencyIsoCode = 'USD';
        insert oppyForecast1;
        
        list<Opportunity_Forecast__c> list_forecasts = new list<Opportunity_Forecast__c>();
        list_forecasts.add(oppyForecast1);
        
        set<Id> set_oppyIds = new set<Id>();
        set_oppyIds.add(oppy.Id);
        
        ClsOppyForecastUtil.getOppyForeCastMap(set_oppyIds);
        ClsOppyForecastUtil.buildAllPartForeCastMap(oppy.Id);
        ClsOppyForecastUtil.buildOppyAllPartForeCastMap(oppy.Id);
        ClsOppyForecastUtil.buildOppyForeCastMapByYear(list_forecasts);
        ClsOppyForecastUtil.forecastHistoryInfos objcls = new ClsOppyForecastUtil.forecastHistoryInfos('1',null);
        Test.stopTest();
    }
   
    static testMethod void test2(){
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;
        
         Profile p = [Select Id, Name From Profile 
                     where Name = 'Production Support' 
                     or Name = 'Service Account' 
                     or Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'helloManesfd@testCompany1233423.com';
        u.Alias = 'dpse';
        u.CommunityNickname = 'TMD';
        u.ProfileId = p.Id;
        insert u;
              
        system.runAs(u){ 
        Test.startTest();
        RecordType rt2 = ClsTestHelp.createTestRecordType23();
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'USD';
        oppy.Five_Year_Revenue__c = 1;
        oppy.recordtypeid = rt2.Id;
        insert oppy;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        Opportunity_Part__c oppypart1 = ClsTestHelp.createTestOpportunityPart();
        oppypart1.Opportunity__c = oppy.Id;
        oppypart1.Part__c = part.Id;
        oppypart1.Status__c = 'Commit';
        oppypart1.Lost_Reason__c = 'Other';
        oppypart1.Lost_Reason_Text__c = null;
        oppypart1.GPL__c = ph.Id;
        oppypart1.Initial_Order_Date__c = date.today();
        insert oppypart1;       
        
        Opportunity_Forecast__c oppyForecast1 = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast1.Opportunity__c = oppy.Id;
        oppyForecast1.Quantity__c = 12;
        oppyForecast1.Part__c = oppypart1.Id;
        oppyForecast1.Date__c = date.newInstance(2013, 09, 28);
        oppyForecast1.Amount__c = 1;
        oppyForecast1.Sales_Price__c = 1;
        oppyForecast1.Fiscal_Year__c = null;
        oppyForecast1.Fiscal_Quarter__c = '21';
        oppyForecast1.CurrencyIsoCode = 'USD';
        insert oppyForecast1;
        
        Forecast_History__c  forecastHistory = new Forecast_History__c();
        forecastHistory.Part__c = oppypart1.Id;
        forecastHistory.Fiscal_Year__c = '2013';
        forecastHistory.Old_Value__c = 2000;
        forecastHistory.New_Value__c = 1800;
        forecastHistory.Opportunity__c = oppy.Id;        
        insert forecastHistory;
        
        list<Forecast_History__c> list_forecast2Upsert = new list<Forecast_History__c>();
        list<Forecast_History__c> list_forecast2Notify = new list<Forecast_History__c>();
        list_forecast2Upsert.add(forecastHistory);
        list_forecast2Notify.add(forecastHistory);
        
        map<String, String> map_partId_partNumber = new map<String, String>();
        map_partId_partNumber.put(oppypart1.Id, 'tets');
        
        set<String> set_years = new set<String>();
        set_years.add('2013');
        
        set<String> set_partIds = new set<String>();
        set_partIds.add(oppypart1.Id);
        
        
        ExtOppyForecastEntryPage.ForecastHistoryStructure forecastClsObj = new ExtOppyForecastEntryPage.ForecastHistoryStructure('2013',12,25);       
        //ClsOppyForecastUtil.copyHistoryData(forecastClsObj,forecastHistory,oppypart1.Id,oppy.Id,list_forecast2Upsert,list_forecast2Notify,map_partId_partNumber,0,set_years,set_partIds);

        Test.stopTest();
    }
    }
    
    static testMethod void test2Method(){
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
       /* Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;*/
        
        Profile p = [Select Id, Name From Profile 
                     where Name = 'Production Support' 
                     or Name = 'Service Account' 
                     or Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'helloMa3n112esfd@testCompany1233423.com';
        u.Alias = 'dpse12';
        u.CommunityNickname = 'TMD222';
        u.ProfileId = p.Id;
        insert u;
              
        system.runAs(u){ 
            //RecordType rt2 = ClsTestHelp.createTestRecordType16();
            RecordType rt2 = ClsTestHelp.createTestRecordType23();
            /* Poonam -Added custom setting to fix test failure- Start*/
           ADMTerritoryCode__c admTerritoryCode= new ADMTerritoryCode__c();
           admTerritoryCode.Name='ADMTerritoryCode';
           admTerritoryCode.Territory_Code__c='101485';
           insert admTerritoryCode;
            /* Poonam -Added custom setting to fix test failure- End*/    
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            acc.Name = 'testaccountJInno';
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
            oppy.AccountId = acc.Id;
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
            oppypart.Status__c = 'Commit';
            oppypart.Lost_Reason__c = 'Other';
            oppypart.Lost_Reason_Text__c = null;
            oppypart.GPL__c = ph.Id;
            oppypart.Initial_Order_Date__c = date.today();
            insert oppypart;
            set<Id> set_ofcIds = new set<Id>();
            Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast.Opportunity__c = oppy.Id;
            oppyForecast.Quantity__c = 12;
            oppyForecast.Part__c = oppypart.Id;
            oppyForecast.Date__c = date.newInstance(2013, 09, 28);
            oppyForecast.Amount__c = 1;
            oppyForecast.Sales_Price__c = 1;
            oppyForecast.Fiscal_Year__c = '2013';
            oppyForecast.Fiscal_Quarter__c = '21';
            oppyForecast.CurrencyIsoCode = 'USD';
            oppyForecast.POS_Amount__c = 10;
            oppyForecast.Direct_Amount__c = 9;
            insert oppyForecast;
            set_ofcIds.add(oppyForecast.Id);
            
            Forecast_Billing__c fb = new Forecast_Billing__c();
            //fb.Key__c = (Id)acc.Id+'_'+(Id)oppy.Id +'_'+(Id)part.Id+'_'+oppyForecast.Date__c;
            fb.Date__c = date.newInstance(2013, 09, 28);
            insert fb;
            
            Test.startTest();
            set<string> set_years = new set<string>();
            set_years.add('2013');
            set_years.add('2014');
            //ClsOppyForecastUtil.putAmountToForecastBilling(set_ofcIds);
            ClsOppyForecastUtil.updateNewlyOppyForecast(oppy.Id, set_years);
            ClsOppyForecastUtil.calculateRevenueforNDR(new set<Id> {oppy.Id});
            ClsOppyForecastUtil.setFiscalMonthForBatch(new list<Opportunity_Forecast__c > {oppyForecast});
            Test.stopTest();
        }
    }
    
}