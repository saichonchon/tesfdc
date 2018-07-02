/**
*   This test class is for ClsOppyForecastUtilAPL.
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

@changelog
* 2014-09-01 Padmaja D <padmaja.dadi@te.com>
* - Created
* - Test coverage 77%

@changelog
* 2016-10-21 Mrunal Parate
* - Created
* - Test coverage 82%
*/
@isTest(SeeAllData=true)
private class ClsOppyForecastUtilAPL_Test {

    static testMethod void testYearly() {
        
        Map<Integer, Decimal> map_date_amount_Cust = new Map<Integer, Decimal>();
        
        RecordType rt2 = ClsTestHelp.createTestRecordType10();
        RecordType rt3 = ClsTestHelp.createTestRecordType8();
        
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
        u.Te_Network_Id__c = 'Test123';
        insert u;

        Account acc = new Account();
        acc.Name = 't'+system.now().millisecond()+math.round(math.random()*10000);
        acc.BillingCity = 'Musterstadt';
        acc.BillingStreet = 'Teststr. 1';
        acc.BillingCountry = 'CN';
        acc.BillingPostalCode = '77777';
        acc.Industry_Code_Description__c= 'Appliances';
        acc.RecordTypeId = rt3.id;
        acc.LEVEL_1_INDUSTRY_CDE__c = '0283';
        insert acc;
        
        
        List<Opportunity> oppylst = new List<Opportunity>();
        Opportunity oppy = ClsTestHelp.createTestOpportunity();     
        oppy.Description = 'Test';
        oppy.Manufacturing_Start_Date__c = date.today();
        oppy.Type = 'New Business';
        oppy.AccountId= acc.Id;
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'USD';
        oppy.Five_Year_Revenue__c = 1;
        oppy.PLM_Created_By_Id__c = 'Test123';
        //insert oppy;
        oppylst.add(oppy);
        
        Opportunity oppy1 = ClsTestHelp.createTestOpportunity();
        oppy1.Description = 'Test';
        oppy1.Manufacturing_Start_Date__c = date.today();
        oppy1.Type = 'New Business';
        //oppy1.Type = 'CM';
        oppy1.Request_Type__c = 'Extension';
        oppy1.Method__c = 'BOM';
        oppy1.Level__c = 'Monthly';
        oppy1.Amount = 1;
        oppy1.CurrencyIsoCode = 'USD';
        oppy1.Five_Year_Revenue__c = 1;
        oppylst.add(oppy1);
        insert oppylst;
        
        Opportunity opp = [Select Industry_Code__c from Opportunity where id=: oppy.Id];
        System.assertEquals(opp.Industry_Code__c, 'Appliances');
              
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
        
        List<Opportunity_Forecast__c> oppyfcstlst = new List<Opportunity_Forecast__c>();
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
        oppyfcstlst.add(oppyForecast);
        //oppyForecast = [SELECT Fiscal_Month__c, Id, Date__c,opportunity__r.RecordType.Name, opportunity__r.level__c FROM Opportunity_Forecast__c WHERE Id = :oppyForecast.Id];
       
        Opportunity_Forecast__c oppyForecast2 = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast2.Opportunity__c = oppy.Id;
        oppyForecast2.Quantity__c = 12;
        oppyForecast2.Date__c = date.newInstance(2013, 09, 28);
        oppyForecast2.Amount__c = 1;
        oppyForecast2.Sales_Price__c = 1;
        oppyForecast2.Fiscal_Year__c = '2015';
        oppyForecast2.Fiscal_Quarter__c = '21';
        oppyForecast2.CurrencyIsoCode = 'USD';
        //insert oppyForecast2;
        oppyfcstlst.add(oppyForecast2);
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
        //insert oppyForecast1;
        oppyfcstlst.add(oppyForecast1);
        insert oppyfcstlst;
        //oppyForecast1 = [SELECT Fiscal_Month__c, Id, Date__c,opportunity__r.RecordType.Name, opportunity__r.level__c FROM Opportunity_Forecast__c WHERE id = :oppyForecast1.Id];
        
        List<Forecast_History__c> oppyfcsthistlst = new List<Forecast_History__c>();
        Forecast_History__c  forecastHistory = new Forecast_History__c();
        forecastHistory.Part__c = oppypart.Id;
        forecastHistory.Fiscal_Year__c = '2013';
        forecastHistory.Old_Value__c = 2000;
        forecastHistory.New_Value__c = 1800;
        forecastHistory.Opportunity__c = oppy.Id;        
        //insert forecastHistory;
        oppyfcsthistlst.add(forecastHistory);
        
        Forecast_History__c  forecastHistory1 = new Forecast_History__c();
        forecastHistory1.Part__c = oppypart.Id;
        forecastHistory1.Fiscal_Year__c = '2013';
        forecastHistory1.Old_Value__c = 2000;
        forecastHistory1.New_Value__c = 1800;
        forecastHistory1.Opportunity__c = oppy.Id;        
        //insert forecastHistory1;
        oppyfcsthistlst.add(forecastHistory1);
        insert oppyfcsthistlst;
        
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
        
        /*Forecast_History_Config__c history1 = new Forecast_History_Config__c();
        history1.Name  = 'Forecast Change Reason';
        history1.value__c = 'Quantity Changes, Price Changes, Project Postponed';
        insert history1;
        
        Forecast_History_Config__c history2 = new Forecast_History_Config__c();
        history2.Name  = 'Threshold_IND';
        history2.Inactive__c = true;
        history2.value__c = '0.1';
        insert history2;
        
        Forecast_History_Config__c history3 = new Forecast_History_Config__c();
        history3.Name  = 'Threshold_Appliances';
        history3.value__c = '0';
        history3.Inactive__c = true;
        insert history3;
        
        Forecast_History_Config__c history4 = new Forecast_History_Config__c();
        history4.Name  = 'Approval Period_IND';
        history4.value__c = '0';
        history4.Inactive__c = true;
        insert history4;
        
        Forecast_History_Config__c history5 = new Forecast_History_Config__c();
        history5.Name  = 'Approval Period_Appliances';
        history5.value__c = '0';
        history5.Inactive__c = true;
        insert history5;*/
        
        map<String, String> map_partId_partNumber = new map<String, String>();
        map_partId_partNumber.put(oppypart.Id, 'test');
        
        Test.startTest();
        
        ClsOppyForecastUtilAPL.getAllFiscalYear();
        ClsOppyForecastUtilAPL.getAllFiscalQuarter();
        ClsOppyForecastUtilAPL.getAllFiscalMonth();
        ClsOppyForecastUtilAPL.getYearList(set_forecastYears, true, 1);
        ClsOppyForecastUtilAPL.getAllPeriodYears();
        ClsOppyForecastUtilAPL.createNewOppyForecastStructure('2013', oppy, list_partIds);
        ClsOppyForecastUtilAPL.createNewOppyForecastStructure('2013', oppy, list_partIds,map_partId_price);
        ClsOppyForecastUtilAPL.getFiscalYearMonthMap();
        ClsOppyForecastUtilAPL.getFiscalMonthStartDate('2013', '12');
        ClsOppyForecastUtilAPL.getOpportunityById(oppy.Id); 
        ClsOppyForecastUtilAPL.getFiscalYearQuarterMap();
        ClsOppyForecastUtilAPL.getFiscalQuarterStartDate('2013', '51');
        ClsOppyForecastUtilAPL.getOppyYearMap(set_oppyIds);
        ClsOppyForecastUtilAPL.getLevelLabel(ClsOppyUtilAPL.MONTHLY);    
        ClsOppyForecastUtilAPL.getLevelLabel(ClsOppyUtilAPL.QUARTERLY);
        ClsOppyForecastUtilAPL.getLevelLabel(ClsOppyUtilAPL.YEARLY);
        ClsOppyForecastUtilAPL.getForecastLevel();
        ClsOppyForecastUtilAPL.getYearNumber();
        ClsOppyForecastUtilAPL.getOtherYears(list_years);
        ClsOppyForecastUtilAPL.getForecastMonth(date.today());
        ClsOppyForecastUtilAPL.getForecastQuarter(date.today());
        ClsOppyForecastUtilAPL.getForecastYear(date.today());
        ClsOppyForecastUtilAPL.getForecastFisMonth(date.today());
        ClsOppyForecastUtilAPL.transformIsoCode(12, 'EUR', 'EUR');
        ClsOppyForecastUtilAPL.getPartIdsByOppyId(set_oppyIds);
        ClsOppyForecastUtilAPL.getPartsByOppyId(set_oppyIds);
        ClsOppyForecastUtilAPL.buildOppyForeCastMap(oppy.Id);
        ClsOppyForecastUtilAPL.getOpportunitysByProgramId(oppy.Id);
        ClsOppyForecastUtilAPL.getStatusItems();
        ClsOppyForecastUtilAPL.getAllPartsByProgramId(oppy.Id);
        ClsOppyForecastUtilAPL.getOppyForeCastMap(set_oppyIds);
        ClsOppyForecastUtilAPL.buildAllPartForeCastMap(oppy.Id);
        ClsOppyForecastUtilAPL.buildProgramAllPartForeCastMap(oppy.Id);
        ClsOppyForecastUtilAPL.buildOppyAllPartForeCastMap(oppy.Id);
        ClsOppyForecastUtilAPL.buildOppyForeCastMapByYear(list_forecasts);
        ClsOppyForecastUtilAPL.getForecastMonthNum(date.today());
        
        ClsOppyForecastUtilAPL.createForcasts(oppy, null, quantities, 12, oppypart, '2013', map_oppyPartId_isoCode, map_partId_oppyId, map_date_amount, map_date_amount_Cust);
        
        ClsOppyForecastUtilAPL.saveProgram('Completed', list_forecastStructures, list_part, list_partIds, oppy, null, null, map_oppyPartId_isoCode, map_partId_oppyId, set_fYears);
        ClsOppyForecastUtilAPL.oppyYear = '2014';
        ClsOppyForecastUtilAPL.saveProgram('Completed', list_forecastStructures, list_part, list_partIds, oppy, null, null, map_oppyPartId_isoCode, map_partId_oppyId, set_fYears);
        ClsOppyForecastUtilAPL.saveProgram('Update', list_forecastStructures, list_part, list_partIds, oppy, null, null, map_oppyPartId_isoCode, map_partId_oppyId, set_fYears);
        ClsOppyForecastUtilAPL.addOppyYears(list_years, 2, list_forecastStructures, oppy, list_partIds);
        ClsOppyForecastUtilAPL.addOppyYears(list_years, 2, list_forecastStructures, oppy, list_partIds,map_partId_price);
        ClsOppyForecastUtilAPL.getPartForecastHistory(oppy.Id);
        ClsOppyForecastUtilAPL.getListForecastHistory(oppy.Id);
        ClsOppyForecastUtilAPL.getSendUserEmail(oppy.Id);
        String str_mapPartId_listForecastHistoryStructure = ClsOppyForecastUtilAPL.getOppyForecastHistory(oppy.Id);
        system.debug('>>>>>>'+str_mapPartId_listForecastHistoryStructure);
        ClsOppyForecastUtilAPL.saveOppForecastHitory(str_mapPartId_listForecastHistoryStructure,opp,'test');
        
        ClsOppyForecastUtilAPL.getDeleteBody(forecastHistory,'test',map_partId_partNumber);
        list<String> list_changeReasons = new list<String>();
        ClsOppyForecastUtilAPL.getChangeReasons(list_changeReasons);
        ClsOppyForecastUtilAPL.getFiveYearsInternal(set_startDate);
        ClsOppyForecastUtilAPL.getFiveYearsInternal(date.today(), ClsOppyUtilAPL.QUARTERLY);
        ClsOppyForecastUtilAPL.getFiveYearsInternal(date.today(), ClsOppyUtilAPL.MONTHLY);
        ClsOppyForecastUtilAPL.getFiveYearsInternal(date.today(), ClsOppyUtilAPL.YEARLY);
        ClsOppyForecastUtilAPL.yearByIndex(list_years, '2013', 0);
        ClsOppyForecastUtilAPL.yearByIndex(list_years, '2013', 1);
        ClsOppyForecastUtilAPL.yearByIndex(list_years, '2013', -2);
        ClsOppyForecastUtilAPL.buildStrucureItems(oppy, list_forecasts, editForecasts);
        
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
        
        //ClsOppyForecastUtilAPL.deleteForecastHistoryOnOppForecast(map_partId_mapYearOppForecast, set_year);
        ClsOppyForecastUtilAPL.getDeleteBody(forecastHistory,'',map_partId_partNumber);
        ClsOppyForecastUtilAPL.sentForecastApprovalNotification(list_forecast2Upsert,oppy,list_forecast2Delete, map_partId_partNumber, map_partId_partDescription, 'Quantity Changes');
        ClsOppyForecastUtilAPL.getBU(oppy);
        ClsOppyForecastUtilAPL.getChangePercentage('Appliances');
        ClsOppyForecastUtilAPL.isAppOrIndBu('Appliances');
        ClsOppyForecastUtilAPL.getMapOppForecast(set_years, set_partIds);
        ClsOppyForecastUtilAPL.generateRevenueMap();
        ClsOppyForecastUtilAPL.setFiscalMonthForBatch(list_forecasts);
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testMonthly() {
        Map<Integer, Decimal> map_date_amount_Cust = new Map<Integer, Decimal>();//
        List<Opportunity> oppylst = new List<Opportunity>();
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Description = 'Test';
        oppy.Manufacturing_Start_Date__c = date.today();
        oppy.Type = 'New Business';
        //oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Monthly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'USD';
        oppy.Five_Year_Revenue__c = 1;
        //insert oppy;
        oppylst.add(oppy);
        
        Opportunity oppy1 = ClsTestHelp.createTestOpportunity();
        oppy1.Description = 'Test';
        oppy1.Manufacturing_Start_Date__c = date.today();
        oppy1.Type = 'New Business';
        //oppy1.Type = 'CM';
        oppy1.Request_Type__c = 'Extension';
        oppy1.Method__c = 'BOM';
        oppy1.Level__c = 'Monthly';
        oppy1.Amount = 1;
        oppy1.CurrencyIsoCode = 'USD';
        oppy1.Five_Year_Revenue__c = 1;
        //insert oppy1;
        oppylst.add(oppy1);
        insert oppylst;
                  

                  
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
        
        ClsOppyForecastUtilAPL.getAllFiscalYear();
        ClsOppyForecastUtilAPL.getAllFiscalQuarter();
        ClsOppyForecastUtilAPL.getAllFiscalMonth();
        ClsOppyForecastUtilAPL.updateOpportunityAmounts(map_oppyid_opportunity, 'BOM', 'Yearly', oppy);
        ClsOppyForecastUtilAPL.getYearList(set_forecastYears, true, 1);
        ClsOppyForecastUtilAPL.getAllPeriodYears();
        ClsOppyForecastUtilAPL.applianceOpptyRecordTypeId();
        ClsOppyForecastUtilAPL.createNewOppyForecastStructure('2013', oppy, list_partIds);
        ClsOppyForecastUtilAPL.getFiscalYearMonthMap();
        ClsOppyForecastUtilAPL.getFiscalMonthStartDate('2013', '12');
        ClsOppyForecastUtilAPL.getOpportunityById(oppy.Id);
        ClsOppyForecastUtilAPL.getFiscalYearQuarterMap();
        ClsOppyForecastUtilAPL.getFiscalQuarterStartDate('2013', '51');
        ClsOppyForecastUtilAPL.getOppyYearMap(set_oppyIds);
        ClsOppyForecastUtilAPL.getLevelLabel(ClsOppyUtilAPL.MONTHLY);
        ClsOppyForecastUtilAPL.getLevelLabel(ClsOppyUtilAPL.QUARTERLY);
        ClsOppyForecastUtilAPL.getLevelLabel(ClsOppyUtilAPL.YEARLY);
        ClsOppyForecastUtilAPL.getForecastLevel();
        ClsOppyForecastUtilAPL.getYearNumber();
        ClsOppyForecastUtilAPL.getOtherYears(list_years);
        ClsOppyForecastUtilAPL.getForecastMonth(date.today());
        ClsOppyForecastUtilAPL.getForecastQuarter(date.today());
        ClsOppyForecastUtilAPL.getForecastYear(date.today());
        ClsOppyForecastUtilAPL.transformIsoCode(12, 'EUR', 'EUR');
        ClsOppyForecastUtilAPL.getPartIdsByOppyId(set_oppyIds);
        ClsOppyForecastUtilAPL.getPartsByOppyId(set_oppyIds);
        ClsOppyForecastUtilAPL.buildOppyForeCastMap(oppy.Id);
        ClsOppyForecastUtilAPL.getOpportunitysByProgramId(oppy.Id);
        ClsOppyForecastUtilAPL.getStatusItems();
        ClsOppyForecastUtilAPL.getAllPartsByProgramId(oppy.Id);
        ClsOppyForecastUtilAPL.getOppyForeCastMap(set_oppyIds);
        ClsOppyForecastUtilAPL.buildAllPartForeCastMap(oppy.Id);
        ClsOppyForecastUtilAPL.buildProgramAllPartForeCastMap(oppy.Id);
        ClsOppyForecastUtilAPL.buildOppyForeCastMapByYear(list_forecasts);
        ClsOppyForecastUtilAPL.getForecastMonthNum(date.today());
        ClsOppyForecastUtilAPL.createForcasts(oppy, null, quantities, 12, oppypart, '2013', map_oppyPartId_isoCode, map_partId_oppyId, map_date_amount, map_date_amount_Cust);
        ClsOppyForecastUtilAPL.createForcasts(oppy1, null, quantities, 12, oppypart, '2013', map_oppyPartId_isoCode, map_partId_oppyId, map_date_amount, map_date_amount_Cust);
        
        ClsOppyForecastUtilAPL.createForcastsNew(oppy, null, quantities, 12, oppypart, '2013', map_oppyPartId_isoCode, map_partId_oppyId, map_date_amount, map_date_amount_Cust,system.today());
        ClsOppyForecastUtilAPL.createForcastsNew(oppy1, null, quantities, 12, oppypart, '2013', map_oppyPartId_isoCode, map_partId_oppyId, map_date_amount, map_date_amount_Cust,system.today());
        
        ClsOppyForecastUtilAPL.calculateQantity(1200,11);
        ClsOppyForecastUtilAPL.GenerateForcasts('EUR', oppypart.Id, 2100, oppy, forecastOppyRecordTypeId, 12, oppypart,'2013',map_oppyPartId_isoCode, map_partId_oppyId, map_date_amount, map_date_amount_Cust, '11', '4', 4);
        ClsOppyForecastUtilAPL.GenerateForcasts('EUR', null, 2100, oppy, forecastOppyRecordTypeId, 12, oppypart,'2013',map_oppyPartId_isoCode, map_partId_oppyId, map_date_amount, map_date_amount_Cust, '11', '4', 4);
        ClsOppyForecastUtilAPL.buildStrucureItems(oppy, list_forecasts, editForecasts);
        ClsOppyForecastUtilAPL.buildPartMonthStructure(list_forecasts, quantities);
        ClsOppyForecastUtilAPL.buildMonthStructure(list_forecasts, editForecasts);
        ClsOppyForecastUtilAPL.appliancesprofileId();
        ClsOppyForecastUtilAPL.checkConflict(1, pQs, editForecasts);
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testQuarterly() {
        Map<Integer, Decimal> map_date_amount_Cust = new Map<Integer, Decimal>();//
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Description = 'Test';
        oppy.Manufacturing_Start_Date__c = date.today();
        oppy.Type = 'New Business';
        //oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Quarterly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'USD';
        oppy.Five_Year_Revenue__c = 1;
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
        
        ClsOppyForecastUtilAPL.getAllFiscalYear();
        ClsOppyForecastUtilAPL.getAllFiscalQuarter();
        ClsOppyForecastUtilAPL.getAllFiscalMonth();
        ClsOppyForecastUtilAPL.getYearList(set_forecastYears, true, 1);
        ClsOppyForecastUtilAPL.getAllPeriodYears();
        ClsOppyForecastUtilAPL.createNewOppyForecastStructure('2013', oppy, list_partIds);
        ClsOppyForecastUtilAPL.getFiscalYearMonthMap();
        ClsOppyForecastUtilAPL.getFiscalMonthStartDate('2013', '12');
        ClsOppyForecastUtilAPL.getOpportunityById(oppy.Id);
        ClsOppyForecastUtilAPL.getFiscalYearQuarterMap();
        ClsOppyForecastUtilAPL.getFiscalQuarterStartDate('2013', '51');
        ClsOppyForecastUtilAPL.getOppyYearMap(set_oppyIds);
        ClsOppyForecastUtilAPL.getLevelLabel(ClsOppyUtilAPL.MONTHLY);
        ClsOppyForecastUtilAPL.getLevelLabel(ClsOppyUtilAPL.QUARTERLY);
        ClsOppyForecastUtilAPL.getLevelLabel(ClsOppyUtilAPL.YEARLY);
        ClsOppyForecastUtilAPL.getForecastLevel();
        ClsOppyForecastUtilAPL.getYearNumber();
        ClsOppyForecastUtilAPL.getOtherYears(list_years);
        ClsOppyForecastUtilAPL.getForecastMonth(date.today());
        ClsOppyForecastUtilAPL.getForecastQuarter(date.today());
        ClsOppyForecastUtilAPL.getForecastYear(date.today());
        ClsOppyForecastUtilAPL.transformIsoCode(12, 'EUR', 'EUR');
        ClsOppyForecastUtilAPL.getPartIdsByOppyId(set_oppyIds);
        ClsOppyForecastUtilAPL.getPartsByOppyId(set_oppyIds);
        ClsOppyForecastUtilAPL.buildOppyForeCastMap(oppy.Id);
        ClsOppyForecastUtilAPL.getOpportunitysByProgramId(oppy.Id);
        ClsOppyForecastUtilAPL.getStatusItems();
        ClsOppyForecastUtilAPL.getAllPartsByProgramId(oppy.Id);
        ClsOppyForecastUtilAPL.getOppyForeCastMap(set_oppyIds);
        ClsOppyForecastUtilAPL.buildAllPartForeCastMap(oppy.Id);
        ClsOppyForecastUtilAPL.buildProgramAllPartForeCastMap(oppy.Id);
        ClsOppyForecastUtilAPL.buildOppyForeCastMapByYear(list_forecasts);
        ClsOppyForecastUtilAPL.getForecastMonthNum(date.today());
        ClsOppyForecastUtilAPL.createForcasts(oppy, null, quantities, 12, oppypart, '2013', map_oppyPartId_isoCode, map_partId_oppyId, map_date_amount, map_date_amount_Cust);
        ClsOppyForecastUtilAPL.createForcastsNew(oppy, null, quantities, 12, oppypart, '2013', map_oppyPartId_isoCode, map_partId_oppyId, map_date_amount, map_date_amount_Cust,system.today());
        
        ClsOppyForecastUtilAPL.buildStrucureItems(oppy, list_forecasts, editForecasts);
        ClsOppyForecastUtilAPL.buildPartStrucureItems(oppy, list_forecasts, quantities);
        ClsOppyForecastUtilAPL.buildPartQuarterStructure(list_forecasts, quantities);
        ClsOppyForecastUtilAPL.buildPartYearStructure(list_forecasts, quantities);
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testLessMethods() {
        Map<Integer, Decimal> map_date_amount_Cust = new Map<Integer, Decimal>();//
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Description = 'Test';
        oppy.Manufacturing_Start_Date__c = date.today();
        oppy.Type = 'New Business';
        //oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'USD';
        oppy.Five_Year_Revenue__c = 1;
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
        
        ClsOppyForecastUtilAPL.getOppyForeCastMap(set_oppyIds);
        ClsOppyForecastUtilAPL.recalculateRevenue(map_oppyid_opportunity, 'BOM', 'Yearly', date.today());
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testLessMethods2() {
        
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
        insert oppy2;  
          
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Description = 'Test';
        oppy.Manufacturing_Start_Date__c = date.today();
        oppy.Type = 'New Business';
        oppy.Program__c = oppy2.Id;   
        //oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        oppy.RecordTypeId = rt2.Id;
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
        ClsOppyForecastUtilAPL.buildProgramAllPartForeCastMap(oppy2.Id);
        ClsOppyForecastUtilAPL.updateOpportunityFromForecast(oppy2.Id, null);
        ClsOppyForecastUtilAPL.updateOpportunityAmounts(map_oppyid_opportunity, 'BOM', 'Yearly', oppy);
        ClsOppyForecastUtilAPL.updateProgramTotalFiveYearsAmount(oppy, set_programOppys);
        
        system.assert(true);
        Test.stopTest();
        }
    }
    static testMethod void testOther(){
        Test.startTest();
        
        RecordType rt2 = ClsTestHelp.createTestRecordType16();
              
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Description = 'Test';
        oppy.Manufacturing_Start_Date__c = date.today();
        oppy.Type = 'New Business';
        //oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'USD';
        oppy.Five_Year_Revenue__c = 1;
        insert oppy;
        
        List<Opportunity> oppylst = new List<Opportunity>();
        Opportunity oppy3 = ClsTestHelp.createTestOpportunity();
        oppy3.Description = 'Test';
        oppy3.Manufacturing_Start_Date__c = date.today();
        oppy3.Type = 'New Business';
        oppy3.Program__c = oppy.Id;   
        //oppy3.Type = 'CM';
        oppy3.Request_Type__c = 'Extension';
        oppy3.Method__c = 'BOM';
        oppy3.Level__c = 'Yearly';
        oppy3.Amount = 1;
        oppy3.CurrencyIsoCode = 'EUR';
        oppy3.Five_Year_Revenue__c = 1;
        oppy3.RecordTypeId = rt2.Id;
        //insert oppy3;
        oppylst.add(oppy3);
        
        Opportunity oppy1 = ClsTestHelp.createTestOpportunity();
        oppy1.Description = 'Test';
        oppy1.Manufacturing_Start_Date__c = date.today();
        oppy1.Type = 'New Business';
        oppy1.Type = 'CM';
        oppy1.Request_Type__c = 'Extension';
        oppy1.Method__c = 'BOM';
        oppy1.Level__c = 'Monthly';
        oppy1.Amount = 1;
        oppy1.CurrencyIsoCode = 'USD';
        oppy1.Five_Year_Revenue__c = 1;
        //insert oppy1;
        oppylst.add(oppy1);
        insert oppylst;
        
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
        
        
        ClsOppyForecastUtilAPL.getOpportunitysByProgramId(oppy3.Id);
        ClsOppyForecastUtilAPL.getAllPartsByProgramId(oppy3.Id);
        
        map<Date, String> map_date_quarterTest = new map<Date, String>();
        map_date_quarterTest.put(system.today(), '1');
        ClsOppyForecastUtilAPL.map_date_quarter = map_date_quarterTest;
        ClsOppyForecastUtilAPL.getForecastQuarter(system.today());
        ClsOppyForecastUtilAPL.getForecastMonthNum(system.today());
        ClsOppyForecastUtilAPL.map_isoCode_exchangeRate = new map<String, Decimal>();
        ClsOppyForecastUtilAPL.map_isoCode_exchangeRate.put('test', null);
        ClsOppyForecastUtilAPL.transformIsoCode(12,'test', 'test');
        map<String, String> map_year_oldNewValue = new map<String, String>();
        map_year_oldNewValue .put('test','test1');
        ClsOppyForecastUtilAPL.forecastHistoryInfos fhCase = new ClsOppyForecastUtilAPL.forecastHistoryInfos('12', map_year_oldNewValue);
         
        Test.stopTest();
    }
    static testMethod void testBatch(){
        Test.startTest();

              
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Description = 'Test';
        oppy.Manufacturing_Start_Date__c = date.today();
        oppy.Type = 'New Business';
        //oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'USD';
        oppy.Five_Year_Revenue__c = 1;
        insert oppy;
        
        Opportunity oppy1 = ClsTestHelp.createTestOpportunity();
        oppy1.Description = 'Test';
        oppy1.Manufacturing_Start_Date__c = date.today();
        oppy1.Type = 'New Business';
        //oppy1.Type = 'CM';
        oppy1.Request_Type__c = 'Extension';
        oppy1.Method__c = 'BOM';
        oppy1.Level__c = 'Monthly';
        oppy1.Amount = 1;
        oppy1.CurrencyIsoCode = 'USD';
        oppy1.Five_Year_Revenue__c = 1;
        insert oppy1;
        
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
        insert oppyForecast;
        
        
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
        insert oppyForecast1;
        
        oppyForecast = [SELECT Fiscal_Month__c, Id, Date__c,opportunity__r.RecordType.Name, opportunity__r.level__c FROM Opportunity_Forecast__c WHERE Id = :oppyForecast.Id];
        oppyForecast1 = [SELECT Fiscal_Month__c, Id, Date__c,opportunity__r.RecordType.Name, opportunity__r.level__c FROM Opportunity_Forecast__c WHERE id = :oppyForecast1.Id];
        
        list<Opportunity_Forecast__c> list_forecasts = new list<Opportunity_Forecast__c>();
        list_forecasts.add(oppyForecast);
        list_forecasts.add(oppyForecast1);
        
        //ClsOppyForecastUtilAPL.setFiscalMonthForBatch(list_forecasts);
        Test.stopTest();
    }
    static testMethod void test1(){
        Test.startTest();
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Description = 'Test';
        oppy.Manufacturing_Start_Date__c = date.today();
        oppy.Type = 'New Business';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'USD';
        oppy.Five_Year_Revenue__c = 1;
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
        
        ClsOppyForecastUtilAPL.getOppyForeCastMap(set_oppyIds);
        ClsOppyForecastUtilAPL.buildAllPartForeCastMap(oppy.Id);
        ClsOppyForecastUtilAPL.buildOppyAllPartForeCastMap(oppy.Id);
        ClsOppyForecastUtilAPL.buildOppyForeCastMapByYear(list_forecasts);

        Test.stopTest();
    }
   
    static testMethod void test2(){
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
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Description = 'Test';
        oppy.Manufacturing_Start_Date__c = date.today();
        oppy.Type = 'New Business';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'USD';
        oppy.Five_Year_Revenue__c = 1;
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
        
        
        ExtOppyForecastEntryPageAPL.ForecastHistoryStructure forecastClsObj = new ExtOppyForecastEntryPageAPL.ForecastHistoryStructure('2013',12,25);       
        //ClsOppyForecastUtilAPL.copyHistoryData(forecastClsObj,forecastHistory,oppypart1.Id,oppy.Id,list_forecast2Upsert,list_forecast2Notify,map_partId_partNumber,0,set_years,set_partIds);

        Test.stopTest();
    }
    }
    
}