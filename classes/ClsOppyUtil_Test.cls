/**
*   This test class is for ClsOppyUtil.
*
@author Di Chen
@created 2012-02-23
@version 1.0
@since 20.0
*
@changelog
* 2012-02-23 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 88%
*/
@isTest
private class ClsOppyUtil_Test {
       
    static testMethod void oppyForeCastType() { 
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
      
            /*Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.Request_Type__c = 'Extension';
            oppy2.RecordTypeId = rt2.Id;
            insert oppy2;  */
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            //oppy.Program__c = oppy2.Id;   
            oppy.Type = 'CM';
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
            oppypart.Status__c = 'Lost';
            oppypart.Lost_Reason__c = 'Other';
            oppypart.Lost_Reason_Text__c = null;
            oppypart.GPL__c = ph.Id;
            insert oppypart;
            
            Opportunity_Partner__c oppyPartner = ClsTestHelp.createTestOpportunityPartner();
            oppyPartner.Opportunity__c = oppy.Id;
            oppyPartner.Account__c = acc.Id;
            oppyPartner.Allocation__c = 100;
            insert oppyPartner;
            
            Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast.Opportunity__c = oppy.Id;
            oppyForecast.Quantity__c = 12;
            oppyForecast.Part__c = oppypart.Id;
            oppyForecast.Date__c = date.newInstance(2012, 09, 28);
            oppyForecast.Amount__c = 1;
            oppyForecast.Sales_Price__c = 1;
            insert oppyForecast;
            
            Test.startTest();
            
            Set<String> set_forecastYears = new Set<String>();
            set_forecastYears.add('2012');
            
            ClsOppyUtil.getYearList(set_forecastYears, true, 1);
            ClsOppyUtil.getYearList(set_forecastYears, false, 1);
            ClsOppyUtil.getAllPeriodYears();
            
            Map<Id, Id> map_partId_oppyId = new Map<Id, Id>();
            map_partId_oppyId.put(part.Id,oppy.Id);
            
            List<Id> list_partIds = new List<Id>();
            list_partIds.add(part.Id);
            
            Map<Id, Opportunity> map_oppyid_opportunity = new Map<Id, Opportunity>();
            map_oppyid_opportunity.put(oppy.Id,oppy);
            
            ClsOppyUtil.getFiscalMonthStartDate('2012', '2');
            
            Set<Id> set_oppyIds = new Set<Id>();
            set_oppyIds.add(oppy.Id);
            ClsOppyUtil.getOppyYearMap(set_oppyIds);
            
            ClsOppyUtil.getLevelLabel('Monthly');
            ClsOppyUtil.getLevelLabel('Yearly');
            ClsOppyUtil.getLevelLabel('Quarterly');
            ClsOppyUtil.getForecastLevelNoYear();
            ClsOppyUtil.getForecastLevel();
            ClsOppyUtil.getYearNumber();
            
            Date inputDate = date.today();
            ClsOppyUtil.getForecastMonth(inputDate);
            ClsOppyUtil.getForecastYear(inputDate);
            
            ClsOppyUtil.getFiscalQuarterStartDate('2012', '3');
            ClsOppyUtil.getPartIdsByOppyId(set_oppyIds);
            
            
            List<Opportunity_Forecast__c> list_oppyForecasts = new List<Opportunity_Forecast__c>();
            list_oppyForecasts.add(oppyForecast);
            Map<Id, List<Opportunity_Forecast__c>> partFCs = new  Map<Id, List<Opportunity_Forecast__c>>();
            partFCs.put(part.Id,list_oppyForecasts);
    
            List<ClsOpportunityForecastStructure.ForecastItemStructure> monthForecasts = new List<ClsOpportunityForecastStructure.ForecastItemStructure>();
            ClsOpportunityForecastStructure.ForecastItemStructure monthClsFore = new ClsOpportunityForecastStructure.ForecastItemStructure('Monthly', part.Id, oppy.Id, rt.Id);
      
            
            List<ClsOpportunityForecastStructure.ForecastItemStructure> quarterForecasts = new List<ClsOpportunityForecastStructure.ForecastItemStructure>();
            ClsOpportunityForecastStructure.ForecastItemStructure QuarterlyClsFs = new ClsOpportunityForecastStructure.ForecastItemStructure('Quarterly', part.Id, oppy.Id, rt.Id);
    
            ClsOppyUtil.getOpportunitysByProgramId(oppy.Id);
            ClsOppyUtil.getStatusItems();
            
            ClsOppyUtil.buildAllPartForeCastMap(oppy.Id);
    
            ClsOppyUtil.getPartsByOppyId(set_oppyIds);
            ClsOppyUtil.getAllPartsByProgramId(oppy.Id);
            ClsOppyUtil.buildProgramAllPartForeCastMap(oppy.Id);
            //ClsOppyUtil.buildAllPartForeCastMap(oppy.Id, oppyForecast);
            
            map<Id, String> map_oppyPartId_isoCode = new map<Id, String>();
            map_oppyPartId_isoCode.put(oppypart.Id,'EUR');
            
            List<Opportunity_Part__c> list_parts = new List<Opportunity_Part__c>();
            list_parts.add(oppypart);        
            
            List<ClsOpportunityForecastStructure> list_forecastStructures = new List<ClsOpportunityForecastStructure>();
            
            List<Opportunity_Forecast__c> oppyForecasts = new List<Opportunity_Forecast__c>();
            oppyForecasts.add(oppyForecast);
            
            Map<Id, List<Opportunity_Forecast__c>> partFCs1 = new Map<Id, List<Opportunity_Forecast__c>>();
            partFCs1.put(part.Id,oppyForecasts);
            
            Map<Id, Id> map_partId_oppyId1 = new Map<Id, Id>();
            map_partId_oppyId1.put(part.Id,oppy.Id);
            
            List<Id> list_partIds1 = new List<Id>();
            list_partIds1.add(part.Id);
            ClsOpportunityForecastStructure cls = new ClsOpportunityForecastStructure(map_oppyPartId_isoCode,'EUR',oppyForecasts,partFCs,'2012',oppy.Id,map_partId_oppyId,rt.Id,rt.Id,'Monthly',list_partIds);
            cls.year = '2012';
            list_forecastStructures.add(cls);
            
            List<String> list_years = new List<String>();
            list_years.add('2012');
            Map<String, List<Opportunity_Forecast__c>> map_year_oppyForecast = new Map<String, List<Opportunity_Forecast__c>>();
            map_year_oppyForecast.put('2012',oppyForecasts);
            
            Map<String, Map<Id, List<Opportunity_Forecast__c>>> map_year_map_partId_oppyForecast = new Map<String, Map<Id, List<Opportunity_Forecast__c>>>();
            map_year_map_partId_oppyForecast.put('2012',partFCs1);
            
            Date inputDate1 = date.newInstance(2010, 09, 24); 
            ClsOppyUtil.getForecastQuarter(inputDate1);
            
            map<Id,Id> map_oppId_accId_new = new map<Id,Id>();
            map_oppId_accId_new.put(oppy.Id,acc.Id);
            
            map<Id,Id> map_oppId_accId_old = new map<Id,Id>();
            map_oppId_accId_old.put(oppy.Id,acc.Id);
            
          //  ClsOppyUtil.PopulateOpptyPartner('INSERT', map_oppId_accId_new, map_oppId_accId_old);
          //  ClsOppyUtil.startDate(list_forecastStructures);
            ClsOppyUtil.buildOppyForeCastMapByYear(oppyForecasts);
            ClsOppyUtil.buildOppyForeCastMap(oppy.Id);
            ClsOppyUtil.getForecastMonthNum(date.today());
            
            set<Id> set_uId = new set<Id>();
            set_uId.add(u.Id);
            
            map<Id,set<Id>> map_oppyId_userId = new map<Id,set<Id>>();
            map_oppyId_userId.put(oppy.Id,set_uId);
            
            ClsOppyUtil.grantAccess(map_oppyId_userId);
            
            list<Opportunity> oppys = new list<Opportunity>();
            oppys.add(oppy);
            
            ClsOppyUtil.checkProgramOppyMethod('123', oppys);
            
            List<ClsOpportunityForecastStructure> list_forecastStructures2 = new List<ClsOpportunityForecastStructure>();
            
            //ClsOppyUtil.ValidateApproverPM(list_parts); 
            
            ClsOppyUtil.recalculateRevenue(map_oppyid_opportunity, 'BOM', 'Yearly', date.newInstance(2012, 05, 06));
             
            set<Date> set_startDate = new set<Date>();
            set_startDate.add(date.newInstance(2012, 05, 06));
            ClsOppyUtil.getFiveYearsInternal(set_startDate);
            ClsOppyUtil.getFiveYearsInternal(date.newInstance(2012, 05, 06), 'Yearly');
            
            ClsOppyUtil.updateOpportunityAmounts(map_oppyid_opportunity, 'BOM', 'Yearly', oppy);
            
            set<Opportunity> set_programOppys = new set<Opportunity>();
            set_programOppys.add(oppy);
            ClsOppyUtil.updateProgramTotalFiveYearsAmount(oppy, set_programOppys);
          
            ClsOppyUtil.addOppyOneYear(map_oppyPartId_isoCode, 'EUR', list_forecastStructures2, list_years, '2010', map_partId_oppyId, list_partIds, oppy.Id, rt.Id, rt.Id, 'Monthly');
            ClsOppyUtil.addOppyOneYear(map_oppyPartId_isoCode, 'EUR', list_forecastStructures, list_years, '2010', map_partId_oppyId, list_partIds, oppy.Id, rt.Id, rt.Id, 'Monthly');
            ClsOppyUtil.addOppyOneYear(map_oppyPartId_isoCode, 'EUR', list_forecastStructures, list_years, '2011', map_partId_oppyId, list_partIds, oppy.Id, rt.Id, rt.Id, 'Monthly');
            system.assert(true);
            Test.stopTest();
        }
    }
    static testMethod void oppyForeCastType2() {
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
            oppy2.RecordTypeId = rt2.Id;
            insert oppy2;  
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Program__c = oppy2.Id;   
            oppy.Type = 'CM';
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
            oppypart.Status__c = 'Lost';
            oppypart.Lost_Reason__c = 'Other';
            oppypart.Lost_Reason_Text__c = null;
            insert oppypart;
            
            Opportunity_Partner__c oppyPartner = ClsTestHelp.createTestOpportunityPartner();
            oppyPartner.Opportunity__c = oppy.Id;
            oppyPartner.Account__c = acc.Id;
            oppyPartner.Allocation__c = 100;
            insert oppyPartner;
            
            Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast.Opportunity__c = oppy.Id;
            oppyForecast.Quantity__c = 12;
            oppyForecast.Part__c = oppypart.Id;
            oppyForecast.Date__c = date.newInstance(2012, 09, 28);
            oppyForecast.Amount__c = 1;
            oppyForecast.Sales_Price__c = 1;
            insert oppyForecast;
            
            Test.startTest();
            
            Set<String> set_forecastYears = new Set<String>();
            set_forecastYears.add('2012');
            
            ClsOppyUtil.getYearList(set_forecastYears, true, 1);
            ClsOppyUtil.getYearList(set_forecastYears, false, 1);
            ClsOppyUtil.getAllPeriodYears();
            
            Map<Id, Id> map_partId_oppyId = new Map<Id, Id>();
            map_partId_oppyId.put(part.Id,oppy.Id);
            
            List<Id> list_partIds = new List<Id>();
            list_partIds.add(part.Id);
            
            Map<Id, Opportunity> map_oppyid_opportunity = new Map<Id, Opportunity>();
            map_oppyid_opportunity.put(oppy.Id,oppy);
            
            ClsOppyUtil.getFiscalMonthStartDate('2012', '2');
            
            Set<Id> set_oppyIds = new Set<Id>();
            set_oppyIds.add(oppy.Id);
            ClsOppyUtil.getOppyYearMap(set_oppyIds);
            
            ClsOppyUtil.getLevelLabel('Monthly');
            ClsOppyUtil.getLevelLabel('Yearly');
            ClsOppyUtil.getLevelLabel('Quarterly');
            ClsOppyUtil.getForecastLevelNoYear();
            ClsOppyUtil.getForecastLevel();
            ClsOppyUtil.getYearNumber();
            
            Date inputDate = date.today();
            ClsOppyUtil.getForecastMonth(inputDate);
            ClsOppyUtil.getForecastYear(inputDate);
            
            ClsOppyUtil.getFiscalQuarterStartDate('2012', '3');
            ClsOppyUtil.getPartIdsByOppyId(set_oppyIds);
            
            
            List<Opportunity_Forecast__c> list_oppyForecasts = new List<Opportunity_Forecast__c>();
            list_oppyForecasts.add(oppyForecast);
            Map<Id, List<Opportunity_Forecast__c>> partFCs = new  Map<Id, List<Opportunity_Forecast__c>>();
            partFCs.put(part.Id,list_oppyForecasts);
    
            List<ClsOpportunityForecastStructure.ForecastItemStructure> monthForecasts = new List<ClsOpportunityForecastStructure.ForecastItemStructure>();
            ClsOpportunityForecastStructure.ForecastItemStructure monthClsFore = new ClsOpportunityForecastStructure.ForecastItemStructure('Monthly', part.Id, oppy.Id, rt.Id);
      
            
            List<ClsOpportunityForecastStructure.ForecastItemStructure> quarterForecasts = new List<ClsOpportunityForecastStructure.ForecastItemStructure>();
            ClsOpportunityForecastStructure.ForecastItemStructure QuarterlyClsFs = new ClsOpportunityForecastStructure.ForecastItemStructure('Quarterly', part.Id, oppy.Id, rt.Id);
    
            ClsOppyUtil.updateOpportunityFromForecast(oppy.Id, rt.Id);
            ClsOppyUtil.getOpportunitysByProgramId(oppy2.Id);
            ClsOppyUtil.getStatusItems();
            ClsOppyUtil.getOppyForeCastMap(set_oppyIds);
          //  ClsOppyUtil.buildAllPartForeCastMap(oppy.Id);
    
            ClsOppyUtil.getPartsByOppyId(set_oppyIds);
            ClsOppyUtil.getAllPartsByProgramId(oppy.Id);
          //  ClsOppyUtil.buildProgramAllPartForeCastMap(oppy.Id,oppyForecast);
        //    ClsOppyUtil.buildProgramAllPartForeCastMap(oppy2.Id,oppyForecast);
            
            List<Opportunity_Part__c> list_parts = new List<Opportunity_Part__c>();
            list_parts.add(oppypart);        
            
            List<ClsOpportunityForecastStructure> list_forecastStructures = new List<ClsOpportunityForecastStructure>();
            
            List<Opportunity_Forecast__c> oppyForecasts = new List<Opportunity_Forecast__c>();
            oppyForecasts.add(oppyForecast);
            
            Map<Id, List<Opportunity_Forecast__c>> partFCs1 = new Map<Id, List<Opportunity_Forecast__c>>();
            partFCs1.put(part.Id,oppyForecasts);
            
            Map<Id, Id> map_partId_oppyId1 = new Map<Id, Id>();
            map_partId_oppyId1.put(part.Id,oppy.Id);
            
            map<Id, String> map_oppyPartId_isoCode = new map<Id, String>();
            map_oppyPartId_isoCode.put(oppypart.Id,'EUR');
            
            List<Id> list_partIds1 = new List<Id>();
            list_partIds1.add(part.Id);
            ClsOpportunityForecastStructure cls = new ClsOpportunityForecastStructure(map_oppyPartId_isoCode,'EUR',oppyForecasts,partFCs,'2012',oppy.Id,map_partId_oppyId,rt.Id,rt.Id,'Monthly',list_partIds);
            list_forecastStructures.add(cls);
            
            List<String> list_years = new List<String>();
            list_years.add('2012');
            Map<String, List<Opportunity_Forecast__c>> map_year_oppyForecast = new Map<String, List<Opportunity_Forecast__c>>();
            map_year_oppyForecast.put('2012',oppyForecasts);
            
            Map<String, Map<Id, List<Opportunity_Forecast__c>>> map_year_map_partId_oppyForecast = new Map<String, Map<Id, List<Opportunity_Forecast__c>>>();
            map_year_map_partId_oppyForecast.put('2012',partFCs1);
            
            Date inputDate1 = date.newInstance(2010, 09, 24);
            ClsOppyUtil.getForecastQuarter(inputDate1);
            
            map<Id,Id> map_oppId_accId_new = new map<Id,Id>();
            map_oppId_accId_new.put(oppy2.Id,acc.Id);
            
            map<Id,Id> map_oppId_accId_old = new map<Id,Id>();
            map_oppId_accId_old.put(oppy.Id,acc.Id);
            
            //ClsOppyUtil.PopulateOpptyPartner('UPDATE', map_oppId_accId_new, map_oppId_accId_old);
            ClsOppyUtil.getOtherYears(list_years);
            system.assert(true);
            Test.stopTest();
        }
    }
    static testMethod void generalMethod() {
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

        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.CloseDate = date.newInstance(2012, 09, 28);
        oppy2.RecordTypeId = rt2.Id;
        insert oppy2;  
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Program__c = oppy2.Id;   
        oppy.CloseDate = date.newInstance(2012, 09, 28);
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
        oppypart.Status__c = 'Lost';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        insert oppypart;
        
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy.Id;
        oppyForecast.Quantity__c = 12;
        oppyForecast.Part__c = oppypart.Id;
        oppyForecast.Date__c = date.newInstance(2012, 09, 28);
        oppyForecast.Amount__c = 1;
        oppyForecast.Fiscal_Year__c = '2012';
        oppyForecast.Sales_Price__c = 1;
        insert oppyForecast;
        
        Test.startTest();
        
        Set<String> set_forecastYears = new Set<String>();
        set_forecastYears.add('2012');
        
        ClsOppyUtil.getYearList(set_forecastYears, true, 1);
        ClsOppyUtil.getYearList(set_forecastYears, false, 1);
        ClsOppyUtil.getAllPeriodYears();
        
        Map<Id, Id> map_partId_oppyId = new Map<Id, Id>();
        map_partId_oppyId.put(part.Id,oppy.Id);
        
        List<Id> list_partIds = new List<Id>();
        list_partIds.add(part.Id);
        
        ClsOppyUtil.getFiscalMonthStartDate('2012', '2');
        
        Set<Id> set_oppyIds = new Set<Id>();
        set_oppyIds.add(oppy.Id);
        ClsOppyUtil.getOppyYearMap(set_oppyIds);
        
        ClsOppyUtil.getLevelLabel('Monthly');
        ClsOppyUtil.getLevelLabel('Yearly');
        ClsOppyUtil.getLevelLabel('Quarterly');
        ClsOppyUtil.getForecastLevelNoYear();
        ClsOppyUtil.getForecastLevel();
        ClsOppyUtil.getYearNumber();
        
        Date inputDate = date.today();
        ClsOppyUtil.getForecastMonth(inputDate);
        ClsOppyUtil.getForecastYear(inputDate);
        
        ClsOppyUtil.getFiscalQuarterStartDate('2012', '3');
        ClsOppyUtil.getPartIdsByOppyId(set_oppyIds);
        
        
        List<Opportunity_Forecast__c> list_oppyForecasts = new List<Opportunity_Forecast__c>();
        list_oppyForecasts.add(oppyForecast);
        Map<Id, List<Opportunity_Forecast__c>> partFCs = new  Map<Id, List<Opportunity_Forecast__c>>();
        partFCs.put(part.Id,list_oppyForecasts);

        List<ClsOpportunityForecastStructure.ForecastItemStructure> monthForecasts = new List<ClsOpportunityForecastStructure.ForecastItemStructure>();
        ClsOpportunityForecastStructure.ForecastItemStructure monthClsFore = new ClsOpportunityForecastStructure.ForecastItemStructure('Monthly', part.Id, oppy.Id, rt.Id);
  
        
        List<ClsOpportunityForecastStructure.ForecastItemStructure> quarterForecasts = new List<ClsOpportunityForecastStructure.ForecastItemStructure>();
        ClsOpportunityForecastStructure.ForecastItemStructure QuarterlyClsFs = new ClsOpportunityForecastStructure.ForecastItemStructure('Quarterly', part.Id, oppy.Id, rt.Id);

        ClsOppyUtil.getOpportunitysByProgramId(oppy.Id);
        ClsOppyUtil.getStatusItems();
        ClsOppyUtil.getOppyForeCastMap(set_oppyIds);
       // ClsOppyUtil.buildAllPartForeCastMap(oppy.Id);
        
        ClsOppyUtil.getPartsByOppyId(set_oppyIds);
        ClsOppyUtil.getAllPartsByProgramId(oppy2.Id);
      //  ClsOppyUtil.buildProgramAllPartForeCastMap(oppy.Id);
        
        List<Opportunity_Part__c> list_parts = new List<Opportunity_Part__c>();
        list_parts.add(oppypart);        
        
        List<ClsOpportunityForecastStructure> list_forecastStructures = new List<ClsOpportunityForecastStructure>();
        
        List<Opportunity_Forecast__c> oppyForecasts = new List<Opportunity_Forecast__c>();
        oppyForecasts.add(oppyForecast);
        
        Map<Id, List<Opportunity_Forecast__c>> partFCs1 = new Map<Id, List<Opportunity_Forecast__c>>();
        partFCs1.put(part.Id,oppyForecasts);
        
        map<Id, String> map_oppyPartId_isoCode = new map<Id, String>();
        map_oppyPartId_isoCode.put(oppypart.Id,'EUR');
        
        Map<Id, Id> map_partId_oppyId1 = new Map<Id, Id>();
        map_partId_oppyId1.put(part.Id,oppy.Id);
        
        List<Id> list_partIds1 = new List<Id>();
        list_partIds1.add(part.Id);
        ClsOpportunityForecastStructure cls = new ClsOpportunityForecastStructure(map_oppyPartId_isoCode,'EUR',oppyForecasts,partFCs,'2012',oppy.Id,map_partId_oppyId,rt.Id,rt.Id,'Monthly',list_partIds);
        list_forecastStructures.add(cls);
        
        List<String> list_years = new List<String>();
        list_years.add('2012');
        Map<String, List<Opportunity_Forecast__c>> map_year_oppyForecast = new Map<String, List<Opportunity_Forecast__c>>();
        map_year_oppyForecast.put('2012',oppyForecasts);
        
        Map<String, Map<Id, List<Opportunity_Forecast__c>>> map_year_map_partId_oppyForecast = new Map<String, Map<Id, List<Opportunity_Forecast__c>>>();
        map_year_map_partId_oppyForecast.put('2012',partFCs1);
        
        Date inputDate1 = date.newInstance(2010, 09, 24);
        ClsOppyUtil.getForecastQuarter(inputDate1);
        
        //ClsOppyUtil.saveProgram(list_parts, list_forecastStructures, true, list_years, map_year_oppyForecast, map_year_map_partId_oppyForecast, 'Monthly', 'BOM',oppy.Id, 'EUR', rt.Id, rt.Id, list_partIds,system.today());
       // ClsOppyUtil.saveProgram(list_parts, list_forecastStructures, false, list_years, map_year_oppyForecast, map_year_map_partId_oppyForecast, 'Monthly', oppy.Id, 'EUR', rt.Id, rt.Id, list_partIds,system.today());
        system.assert(true);
        Test.stopTest();
        }
    }
    static testMethod void Status2() {
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
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true;
        oppy2.Name = 'Pain of Queen';
        oppy2.RecordTypeId = rt2.Id;
        insert oppy2;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Program__c = oppy2.Id;
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
        oppypart.Status__c = 'Dead';
        oppypart.Lost_Reason__c = '';
        oppypart.Competitor__c = null;
        insert oppypart;
        
        
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy.Id;
        oppyForecast.Amount__c = 1;
        oppyForecast.Quantity__c =2;
        oppyForecast.Part__c = null;
        oppyForecast.Date__c = date.today();
        oppyForecast.Sales_Price__c = 1;
        insert oppyForecast;
        
        Test.startTest();
        
        Set<String> set_forecastYears = new Set<String>();
        set_forecastYears.add('2012');
        
        
        Map<Id, Id> map_partId_oppyId = new Map<Id, Id>();
        map_partId_oppyId.put(part.Id,oppy.Id);
        
        List<Id> list_partIds = new List<Id>();
        list_partIds.add(part.Id);
        
        
        Set<Id> set_oppyIds = new Set<Id>();
        set_oppyIds.add(oppy.Id);

        List<Opportunity_Forecast__c> list_oppyForecasts = new List<Opportunity_Forecast__c>();
        list_oppyForecasts.add(oppyForecast);
        Map<Id, List<Opportunity_Forecast__c>> partFCs = new  Map<Id, List<Opportunity_Forecast__c>>();
        partFCs.put(part.Id,list_oppyForecasts);

        List<Opportunity_Part__c> list_parts = new List<Opportunity_Part__c>();
        list_parts.add(oppypart);       
        
        List<ClsOpportunityForecastStructure> list_forecastStructures = new List<ClsOpportunityForecastStructure>();
        
        List<Opportunity_Forecast__c> oppyForecasts = new List<Opportunity_Forecast__c>();
        oppyForecasts.add(oppyForecast);
        
        Map<Id, List<Opportunity_Forecast__c>> partFCs1 = new Map<Id, List<Opportunity_Forecast__c>>();
        partFCs1.put(part.Id,oppyForecasts);
        
        Map<Id, Id> map_partId_oppyId1 = new Map<Id, Id>();
        map_partId_oppyId1.put(part.Id,oppy.Id);
        
        map<Id, String> map_oppyPartId_isoCode = new map<Id, String>();
        map_oppyPartId_isoCode.put(oppypart.Id,'EUR');
        
        List<Id> list_partIds1 = new List<Id>();
        list_partIds1.add(part.Id);
        ClsOpportunityForecastStructure cls = new ClsOpportunityForecastStructure(map_oppyPartId_isoCode,'EUR',oppyForecasts,partFCs,'2012',oppy.Id,map_partId_oppyId,rt.Id,rt.Id,'Monthly',list_partIds);
        list_forecastStructures.add(cls);
        
        List<String> list_years = new List<String>();
        list_years.add('2012');
        Map<String, List<Opportunity_Forecast__c>> map_year_oppyForecast = new Map<String, List<Opportunity_Forecast__c>>();
        map_year_oppyForecast.put('2012',oppyForecasts);
        
        Map<String, Map<Id, List<Opportunity_Forecast__c>>> map_year_map_partId_oppyForecast = new Map<String, Map<Id, List<Opportunity_Forecast__c>>>();
        map_year_map_partId_oppyForecast.put('2012',partFCs1);
        

      //  ClsOppyUtil.buildOppyForeCastMap(oppy2.Id);
        system.assert(true);
        Test.stopTest();
        }
    }
    static testMethod void Status3() {
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
        
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true;
        oppy2.RecordTypeId = rt2.Id;
        oppy2.Name = 'Pain of Queen';
        oppy2.Five_Year_Revenue__c = 12;
        oppy2.Amount = 1;
        oppy2.Method__c = 'BOM';
        //oppy2.Quantity__c = 12;
        insert oppy2;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Program__c = oppy2.Id;
        oppy.Five_Year_Revenue__c = 12;
        oppy.Amount = 1;
        oppy.Method__c = 'BOM';
        //oppy.Quantity__c = 12;
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
        oppypart.Status__c = 'Dead';
        oppypart.Lost_Reason__c = 'Others';
        oppypart.Competitor__c = null;
        insert oppypart;
        
        
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy.Id;
        oppyForecast.Amount__c = 1;
        oppyForecast.Quantity__c =2;
        oppyForecast.Part__c = null;
        oppyForecast.Date__c = date.today();
        oppyForecast.Sales_Price__c = 1;
        insert oppyForecast;
        
        Test.startTest();
        
        Set<String> set_forecastYears = new Set<String>();
        set_forecastYears.add('2012');
        
        
        Map<Id, Id> map_partId_oppyId = new Map<Id, Id>();
        map_partId_oppyId.put(part.Id,oppy.Id);
        
        List<Id> list_partIds = new List<Id>();
        list_partIds.add(part.Id);
        
        
        Set<Id> set_oppyIds = new Set<Id>();
        set_oppyIds.add(oppy.Id);

        List<Opportunity_Forecast__c> list_oppyForecasts = new List<Opportunity_Forecast__c>();
        list_oppyForecasts.add(oppyForecast);
        Map<Id, List<Opportunity_Forecast__c>> partFCs = new  Map<Id, List<Opportunity_Forecast__c>>();
        partFCs.put(part.Id,list_oppyForecasts);

        List<Opportunity_Part__c> list_parts = new List<Opportunity_Part__c>();
        list_parts.add(oppypart);       
        
        List<ClsOpportunityForecastStructure> list_forecastStructures = new List<ClsOpportunityForecastStructure>();
        
        List<Opportunity_Forecast__c> oppyForecasts = new List<Opportunity_Forecast__c>();
        oppyForecasts.add(oppyForecast);
        
        Map<Id, List<Opportunity_Forecast__c>> partFCs1 = new Map<Id, List<Opportunity_Forecast__c>>();
        partFCs1.put(part.Id,oppyForecasts);
        
        Map<Id, Id> map_partId_oppyId1 = new Map<Id, Id>();
        map_partId_oppyId1.put(part.Id,oppy.Id);
        map<Id, String> map_oppyPartId_isoCode = new map<Id, String>();
        map_oppyPartId_isoCode.put(oppypart.Id,'EUR');
        List<Id> list_partIds1 = new List<Id>();
        list_partIds1.add(part.Id);
        ClsOpportunityForecastStructure cls = new ClsOpportunityForecastStructure(map_oppyPartId_isoCode,'EUR',oppyForecasts,partFCs,'2012',oppy.Id,map_partId_oppyId,rt.Id,rt.Id,'Monthly',list_partIds);
        cls.year = '2012';
        list_forecastStructures.add(cls);
        
        List<String> list_years = new List<String>();
        list_years.add('2012');
        Map<String, List<Opportunity_Forecast__c>> map_year_oppyForecast = new Map<String, List<Opportunity_Forecast__c>>();
        map_year_oppyForecast.put('2012',oppyForecasts);
        
        Map<String, Map<Id, List<Opportunity_Forecast__c>>> map_year_map_partId_oppyForecast = new Map<String, Map<Id, List<Opportunity_Forecast__c>>>();
        map_year_map_partId_oppyForecast.put('2012',partFCs1);
        
        
        ClsOpportunityForecastStructure clsOppy = new ClsOpportunityForecastStructure(map_oppyPartId_isoCode,'EUR',oppyForecasts,partFCs,'2012',oppy.Id,map_partId_oppyId,rt.Id,rt.Id,'Monthly',list_partIds);
        List<ClsOpportunityForecastStructure> list_forecastStructures2 = new List<ClsOpportunityForecastStructure>();
        list_forecastStructures2.add(clsOppy);
        
        List<String> list_year2 = new List<String>();
        list_year2.add('2020');
        ClsOppyUtil.initOppyForecastStructures(map_oppyPartId_isoCode, 'EUR', map_partId_oppyId, list_forecastStructures, list_years, map_year_oppyForecast, map_year_map_partId_oppyForecast, 'Monthly', oppy.Id, rt.Id, rt.Id, list_partIds);
        ClsOppyUtil.initOppyForecastStructures(map_oppyPartId_isoCode, 'EUR', map_partId_oppyId, list_forecastStructures, list_year2, map_year_oppyForecast, map_year_map_partId_oppyForecast, 'Monthly', oppy.Id, rt.Id, rt.Id, list_partIds);        
       
        Map<Id, Opportunity> map_oppyid_opportunity = new Map<Id, Opportunity>();
        map_oppyid_opportunity.put(oppy.Id,oppy);
        
        Map<Id, Opportunity_Part__c> map_parts = new Map<Id, Opportunity_Part__c>();
        map_parts.put(part.Id,oppypart);
        
        ClsOppyUtil.deleteOppyYear(list_forecastStructures, '2012');
        ClsOppyUtil.addOppyYears(map_oppyPartId_isoCode, 'EUR',list_forecastStructures, list_years, 2012, map_partId_oppyId, list_partIds, oppy.Id, rt.Id, rt.Id, 'Monthly');
        ClsOppyUtil.addAllOppyYears(map_oppyPartId_isoCode, 'EUR', list_forecastStructures, list_years, 2012, map_partId_oppyId, list_partIds, oppy.Id, rt.Id, rt.Id, 'Monthly');
        
        ClsOppyUtil.transferAllStructures(list_forecastStructures, 'Monthly', 'BOM', map_parts);
        ClsOppyUtil.transferAllStructures(list_forecastStructures, 'Yearly', 'BOM', map_parts);
        ClsOppyUtil.transferAllStructures(list_forecastStructures, 'Quarterly', 'BOM', map_parts);

        system.assert(true);
        Test.stopTest(); 
        }
    }
    static testMethod void Status4() {
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
        
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.RecordTypeId = rt2.Id;
        insert oppy2;  
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Program__c = oppy2.Id;   
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
        insert oppypart;
        
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy.Id;
        oppyForecast.Quantity__c = 12;
        oppyForecast.Part__c = null;
        oppyForecast.Date__c = date.newInstance(2012, 09, 28);
        oppyForecast.Forecasting_Start_Date__c = date.newInstance(2011, 09, 28);
        oppyForecast.Amount__c = 1;
        oppyForecast.CurrencyIsoCode = 'EUR';
        oppyForecast.Sales_Price__c = 1;
        insert oppyForecast;
        
        List<Opportunity_Forecast__c> oppyForecasts = new List<Opportunity_Forecast__c>();
        oppyForecasts.add(oppyForecast);
        
        Map<Id, List<Opportunity_Forecast__c>> partFCs = new Map<Id, List<Opportunity_Forecast__c>>();
        partFCs.put(part.Id,oppyForecasts);
        
        Map<Id, Id> map_partId_oppyId = new Map<Id, Id>();
        map_partId_oppyId.put(part.Id,oppy.Id);
        
        List<Id> list_partIds = new List<Id>();
        list_partIds.add(part.Id);
        
        ClsOpportunityForecastStructure.ForecastItemStructure clsF1 = new ClsOpportunityForecastStructure.ForecastItemStructure('Monthly',part.Id,oppy.Id,rt.Id);
        clsF1.forecast = oppyForecast;
        clsF1.label = 'FM01 Oct';
        clsF1.level = 'Monthly';
        
        ClsOpportunityForecastStructure.ForecastItemStructure clsF2 = new ClsOpportunityForecastStructure.ForecastItemStructure('Yearly',part.Id,oppy.Id,rt.Id);
        clsF2.forecast = oppyForecast;
        clsF2.level = 'Yearly';
        
        ClsOpportunityForecastStructure.ForecastItemStructure clsF3 = new ClsOpportunityForecastStructure.ForecastItemStructure('Yearly',part.Id,oppy.Id,rt.Id);
        clsF3.forecast = oppyForecast;
        clsF3.level = 'Quarterly';
        
        ClsOpportunityForecastStructure.ForecastItemStructure clsF4 = new ClsOpportunityForecastStructure.ForecastItemStructure('Yearly',part.Id,oppy.Id,rt.Id);
        clsF4.forecast = oppyForecast;
        clsF4.level = 'Quarterly';
        
        List<ClsOpportunityForecastStructure.ForecastItemStructure> list_editForecasts = new List<ClsOpportunityForecastStructure.ForecastItemStructure>();
        list_editForecasts.add(clsF1);
        list_editForecasts.add(clsF2);
        list_editForecasts.add(clsF3); 
        list_editForecasts.add(clsF4); 
        
        List<ClsOpportunityForecastStructure.ForecastItemStructure> list_editForecasts1 = new List<ClsOpportunityForecastStructure.ForecastItemStructure>();
        list_editForecasts1.add(clsF1);
        
        List<ClsOpportunityForecastStructure.ForecastStructure> list_pfcs = new List<ClsOpportunityForecastStructure.ForecastStructure>();          
        ClsOpportunityForecastStructure.ForecastStructure fcs1 = new ClsOpportunityForecastStructure.ForecastStructure('EUR','EUR',oppyForecasts,oppy.Id,part.Id,'2012',rt.Id,'Monthly');         
        fcs1.list_editForecasts = list_editForecasts;
        list_pfcs.add(fcs1);
        
        Test.startTest();

        ClsOppyUtil.transferStructureFromPart(fcs1, list_pfcs, 'Monthly');
        ClsOppyUtil.transferStructureFromPart(fcs1, list_pfcs, 'Yearly');
        ClsOppyUtil.transferStructureFromPart(fcs1, list_pfcs, 'Quarterly');
        Map<String, List<Opportunity_Forecast__c>> map_yearQuarter_oppyForecasts = new Map<String, List<Opportunity_Forecast__c>>();
        map_yearQuarter_oppyForecasts.put('2012',oppyForecasts);
        TOPS_Forecast__c tf = new TOPS_Forecast__c();
        ClsOppyUtil.generateForecasts(tf, oppy.Id, oppypart.Id, '2012', 'CY', '', map_yearQuarter_oppyForecasts, 'EUR',rt2.Id);

        system.assert(true);
        Test.stopTest(); 
        }
    }
    
    
    static testMethod void Status5() {
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
            
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        insert acc;
        
        RecordType rt2 = ClsTestHelp.createTestRecordType11();
        
        /*Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.RecordTypeId = rt9.Id;
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.StageName = 'New';
        insert oppy2;  
        */


        Opportunity oppy2 = ClsTestHelp.createTestOpportunity(); 
        oppy2.Type = 'CM';
        oppy2.Request_Type__c = 'Extension';
        oppy2.Method__c = 'BOM';
        oppy2.Level__c = 'Yearly';
        oppy2.Amount = 1;
        oppy2.CurrencyIsoCode = 'EUR';
        oppy2.Five_Year_Revenue__c = 1;
        oppy2.AccountId = acc.Id;
        oppy2.StageName = 'New';
        oppy2.RecordTypeId = rt2.Id;
        insert oppy2;
        

        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy2.Id;
        oppypart.Part__c = part.Id;
        insert oppypart;
        
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy2.Id;
        oppyForecast.Quantity__c = 12;
        oppyForecast.Part__c = oppypart.Id;
        oppyForecast.Date__c = date.newInstance(2012, 09, 28);
        oppyForecast.Amount__c = 1;
        oppyForecast.CurrencyIsoCode = 'EUR';
        oppyForecast.Sales_Price__c = 1;
        insert oppyForecast;
        
        map<Id, String> map_oppyPartId_isoCode = new map<Id, String>();
        map_oppyPartId_isoCode.put(oppypart.Id,'EUR');
        
        List<Opportunity_Part__c> list_parts = new List<Opportunity_Part__c>();
        list_parts.add(oppypart);        
        
        List<ClsOpportunityForecastStructure> list_forecastStructures = new List<ClsOpportunityForecastStructure>();
        
        List<Opportunity_Forecast__c> oppyForecasts = new List<Opportunity_Forecast__c>();
        oppyForecasts.add(oppyForecast);
        
        Map<Id, List<Opportunity_Forecast__c>> partFCs = new Map<Id, List<Opportunity_Forecast__c>>();
        partFCs.put(part.Id,oppyForecasts);
        
        Map<Id, Id> map_partId_oppyId1 = new Map<Id, Id>();
        map_partId_oppyId1.put(part.Id,oppy2.Id);
        
        List<Id> list_partIds = new List<Id>();
        list_partIds.add(part.Id);
        
        Map<Id, Id> map_partId_oppyId = new Map<Id, Id>();
        map_partId_oppyId.put(part.Id,oppy2.Id);
        
        ClsOpportunityForecastStructure cls = new ClsOpportunityForecastStructure(map_oppyPartId_isoCode,'EUR',oppyForecasts,partFCs,'2012',oppy2.Id,map_partId_oppyId,rt2.Id,rt2.Id,'Monthly',list_partIds);
        cls.year = '2012';
        
        list_forecastStructures.add(cls);
        
        ClsOpportunityForecastStructure.ForecastStructure inputFS = new ClsOpportunityForecastStructure.ForecastStructure('EUR','EUR',oppyForecasts,oppy2.Id,part.Id,'2012',rt2.Id,'Monthly');
        
        ClsOpportunityForecastStructure.ForecastItemStructure clsF1 = new ClsOpportunityForecastStructure.ForecastItemStructure('Monthly',part.Id,oppy2.Id,rt2.Id);
        clsF1.forecast = oppyForecast;
        clsF1.label = 'FM01 Oct';
        clsF1.level = 'Monthly';
        
        Map<String, ClsOpportunityForecastStructure> map_year_structure = new Map<String, ClsOpportunityForecastStructure>();
        
        map_year_structure.put('2012',cls);
        
        Test.startTest();
        
        ClsOppyUtil.buildAllPartForeCastMap(oppy2.Id);
        ClsOppyUtil.deleteOppyYear(list_forecastStructures, '2012');
        ClsOppyUtil.calStartDate(list_forecastStructures, 'Monthly');
        ClsOppyUtil.calStartDate(list_forecastStructures, 'Yearly');
        ClsOppyUtil.calStartDate(list_forecastStructures, 'Quarterly');
        ClsOppyUtil.calStartYear(list_forecastStructures);
        ClsOppyUtil.updateOpportunityFromForecast(oppy2.Id, rt2.Id);
        List<String> list_years = new List<String>();
        list_years.add('2009');
        
        ClsOppyUtil.resetForecastByMoveDate('2012', inputFS, 1, map_year_structure, 'Monthly', 'Oppy', 1, list_years);
        ClsOppyUtil.resetForecastByMoveDate('2012', inputFS, 1, map_year_structure, 'Yearly', 'Part', 0, list_years);
        
       
        system.assert(true);
        Test.stopTest();
        }
    }
    
    static testMethod void Status5andaHalf() {
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
            
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        insert acc;
        
        RecordType rt9 = ClsTestHelp.createTestRecordType10();
        RecordType rt2 = ClsTestHelp.createTestRecordType11();
            
        Opportunity oppy = ClsTestHelp.createTestOpportunity(); 
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        oppy.AccountId = acc.Id;
        oppy.StageName = 'New';
        oppy.RecordTypeId = rt9.Id;
        insert oppy;
        
        /*Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Program__c = oppy2.Id;   
        oppy.StageName = 'Analyze';
        oppy.Request_Type__c = 'Sales Parts';
        oppy.RecordTypeId = rt2.Id;
        insert oppy;
        */
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
        insert oppypart;
        
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy.Id;
        oppyForecast.Quantity__c = 12;
        oppyForecast.Part__c = oppypart.Id;
        oppyForecast.Date__c = date.newInstance(2012, 09, 28);
        oppyForecast.Amount__c = 1;
        oppyForecast.CurrencyIsoCode = 'EUR';
        oppyForecast.Sales_Price__c = 1;
        insert oppyForecast;
        
        map<Id, String> map_oppyPartId_isoCode = new map<Id, String>();
        map_oppyPartId_isoCode.put(oppypart.Id,'EUR');
        
        List<Opportunity_Part__c> list_parts = new List<Opportunity_Part__c>();
        list_parts.add(oppypart);        
        
        List<ClsOpportunityForecastStructure> list_forecastStructures = new List<ClsOpportunityForecastStructure>();
        
        List<Opportunity_Forecast__c> oppyForecasts = new List<Opportunity_Forecast__c>();
        oppyForecasts.add(oppyForecast);
        
        Map<Id, List<Opportunity_Forecast__c>> partFCs = new Map<Id, List<Opportunity_Forecast__c>>();
        partFCs.put(part.Id,oppyForecasts);
        
        Map<Id, Id> map_partId_oppyId1 = new Map<Id, Id>();
        map_partId_oppyId1.put(part.Id,oppy.Id);
        
        List<Id> list_partIds = new List<Id>();
        list_partIds.add(part.Id);
        
        Map<Id, Id> map_partId_oppyId = new Map<Id, Id>();
        map_partId_oppyId.put(part.Id,oppy.Id);
        
        ClsOpportunityForecastStructure cls = new ClsOpportunityForecastStructure(map_oppyPartId_isoCode,'EUR',oppyForecasts,partFCs,'2012',oppy.Id,map_partId_oppyId,rt2.Id,rt2.Id,'Monthly',list_partIds);
        cls.year = '2012';
        
        list_forecastStructures.add(cls);
        
        ClsOpportunityForecastStructure.ForecastStructure inputFS = new ClsOpportunityForecastStructure.ForecastStructure('EUR','EUR',oppyForecasts,oppy.Id,part.Id,'2012',rt2.Id,'Monthly');
        
        ClsOpportunityForecastStructure.ForecastItemStructure clsF1 = new ClsOpportunityForecastStructure.ForecastItemStructure('Monthly',part.Id,oppy.Id,rt2.Id);
        clsF1.forecast = oppyForecast;
        clsF1.label = 'FM01 Oct';
        clsF1.level = 'Monthly';
        
        Map<String, ClsOpportunityForecastStructure> map_year_structure = new Map<String, ClsOpportunityForecastStructure>();
        
        map_year_structure.put('2012',cls);
        
        Test.startTest();
        
        
        List<String> list_years = new List<String>();
        list_years.add('2009');
        
        ClsOppyUtil.yearListIndex(list_years, '2009');
        ClsOppyUtil.yearByIndex(list_years, '2009', 0);
        ClsOppyUtil.yearByIndex(list_years, '2009', 1);
        Set<Id> set_partIds = new Set<Id>();
        set_partIds.add(oppypart.Id);
        ClsOppyUtil.deleteForecastUpdateOppys(set_partIds);
        system.assert(true);
        Test.stopTest();
        }
    }
    
    static testMethod void Status6() {
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
        
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.RecordTypeId = rt2.Id;
        insert oppy2;  
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Program__c = oppy2.Id;   
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
        insert oppypart;
        
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy.Id;
        oppyForecast.Quantity__c = 12;
        oppyForecast.Part__c = null;
        oppyForecast.Date__c = date.newInstance(2012, 09, 28);
        oppyForecast.Forecasting_Start_Date__c = date.newInstance(2011, 09, 28);
        oppyForecast.Amount__c = 1;
        oppyForecast.CurrencyIsoCode = 'EUR';
        oppyForecast.Sales_Price__c = 1;
        insert oppyForecast;
        
        List<Opportunity_Forecast__c> oppyForecasts = new List<Opportunity_Forecast__c>();
        oppyForecasts.add(oppyForecast);
        
        Map<Id, List<Opportunity_Forecast__c>> partFCs = new Map<Id, List<Opportunity_Forecast__c>>();
        partFCs.put(part.Id,oppyForecasts);
        
        Map<Id, Id> map_partId_oppyId = new Map<Id, Id>();
        map_partId_oppyId.put(part.Id,oppy.Id);
        
        List<Id> list_partIds = new List<Id>();
        list_partIds.add(part.Id);
        
        ClsOpportunityForecastStructure.ForecastItemStructure clsF1 = new ClsOpportunityForecastStructure.ForecastItemStructure('Monthly',part.Id,oppy.Id,rt.Id);
        clsF1.forecast = oppyForecast;
        clsF1.label = 'FM01 Oct';
        clsF1.level = 'Monthly';
        
        ClsOpportunityForecastStructure.ForecastItemStructure clsF2 = new ClsOpportunityForecastStructure.ForecastItemStructure('Yearly',part.Id,oppy.Id,rt.Id);
        clsF2.forecast = oppyForecast;
        clsF2.level = 'Yearly';
        
        ClsOpportunityForecastStructure.ForecastItemStructure clsF3 = new ClsOpportunityForecastStructure.ForecastItemStructure('Yearly',part.Id,oppy.Id,rt.Id);
        clsF3.forecast = oppyForecast;
        clsF3.level = 'Quarterly';
        
        ClsOpportunityForecastStructure.ForecastItemStructure clsF4 = new ClsOpportunityForecastStructure.ForecastItemStructure('Yearly',part.Id,oppy.Id,rt.Id);
        clsF4.forecast = oppyForecast;
        clsF4.level = 'Quarterly';
        
        List<ClsOpportunityForecastStructure.ForecastItemStructure> list_editForecasts = new List<ClsOpportunityForecastStructure.ForecastItemStructure>();
        list_editForecasts.add(clsF1);
        list_editForecasts.add(clsF2);
        list_editForecasts.add(clsF3); 
        list_editForecasts.add(clsF4); 
        
        List<ClsOpportunityForecastStructure.ForecastItemStructure> list_editForecasts1 = new List<ClsOpportunityForecastStructure.ForecastItemStructure>();
        list_editForecasts1.add(clsF1);
        
        ClsOpportunityForecastStructure.ForecastStructure fcs = new ClsOpportunityForecastStructure.ForecastStructure('EUR','EUR',oppyForecasts,oppy.Id,part.Id,'2012',rt.Id,'Monthly');         
        fcs.getEditForecasts();
        fcs.getSalesPriceOF();
        fcs.list_editForecasts = list_editForecasts;
        

        List<ClsOpportunityForecastStructure.ForecastStructure> list_pfcs = new List<ClsOpportunityForecastStructure.ForecastStructure>();
        ClsOpportunityForecastStructure.ForecastStructure fcs1 = new ClsOpportunityForecastStructure.ForecastStructure('EUR','EUR',oppyForecasts,oppy.Id,part.Id,'2012',rt.Id,'Monthly');         
        fcs1.getEditForecasts();
        fcs1.getSalesPriceOF();
        fcs1.list_editForecasts = list_editForecasts;
        list_pfcs.add(fcs1);
        
        Test.startTest();
        
        ClsOppyUtil.getOpportunityById(oppy.Id);
        
        ClsOppyUtil.transferStructure(fcs, 'Monthly');
        ClsOppyUtil.transferStructure(fcs, 'Yearly');
        ClsOppyUtil.transferStructure(fcs, 'Quarterly');
        ClsOppyUtil.transferStructure(fcs1, 'Monthly');
        ClsOppyUtil.transferStructure(fcs1, 'Yearly');
        ClsOppyUtil.transferStructure(fcs1, 'Quarterly');
        ClsOppyUtil.transferStructureFromOppy(fcs1, list_editForecasts1, 1.0, 'Monthly');
        ClsOppyUtil.convertStructure(fcs, 'Yearly');
        ClsOppyUtil.transformIsoCode(1, 'EUR', 'EUR');

        
        Map<Id, Opportunity> map_oppyid_opportunity = new Map<Id, Opportunity>();
        map_oppyid_opportunity.put(oppy.Id,oppy);
        //ClsOppyUtil.updateOpportunityAmounts(map_oppyid_opportunity, 'BOM', 'Monthly', oppy);
        system.assert(true);
        Test.stopTest(); 
        }
    }
    static testMethod void generalMethod2() {
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
        
        /*Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.CloseDate = date.newInstance(2012, 09, 28);
        oppy2.RecordTypeId = rt2.Id;
        oppy2.StageName = 'Sampling and Quotation';
        insert oppy2;  
        */
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        //oppy.Program__c = oppy2.Id;   
        oppy.CloseDate = date.newInstance(2012, 09, 28);
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
        oppypart.Status__c = 'Won';
        oppypart.Won_Date__c = null;
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        insert oppypart;
        
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy.Id;
        oppyForecast.Quantity__c = 12;
        oppyForecast.Part__c = oppypart.Id;
        oppyForecast.Date__c = date.newInstance(2012, 06, 28);
        oppyForecast.Amount__c = 1;
        oppyForecast.Fiscal_Year__c = '2012';
        oppyForecast.Fiscal_Quarter__c = 'x';
        oppyForecast.Sales_Price__c = 1;
        insert oppyForecast;
        
        Test.startTest();
        
        Set<String> set_forecastYears = new Set<String>();
        set_forecastYears.add('2012');
        

        Map<Id, Id> map_partId_oppyId = new Map<Id, Id>();
        map_partId_oppyId.put(oppypart.Id,oppy.Id);
        
        List<Id> list_partIds = new List<Id>();
        list_partIds.add(oppypart.Id);
        

        Set<Id> set_oppyIds = new Set<Id>();
        set_oppyIds.add(oppy.Id);


        Date inputDate = date.today();

        
        List<Opportunity_Forecast__c> list_oppyForecasts = new List<Opportunity_Forecast__c>();
        list_oppyForecasts.add(oppyForecast);
        Map<Id, List<Opportunity_Forecast__c>> partFCs = new  Map<Id, List<Opportunity_Forecast__c>>();
        partFCs.put(oppypart.Id,list_oppyForecasts);

        List<Opportunity_Part__c> list_parts = new List<Opportunity_Part__c>();
        list_parts.add(oppypart);        
        
        List<ClsOpportunityForecastStructure> list_forecastStructures = new List<ClsOpportunityForecastStructure>();
        
        List<Opportunity_Forecast__c> oppyForecasts = new List<Opportunity_Forecast__c>();
        oppyForecasts.add(oppyForecast);
        
        Map<Id, List<Opportunity_Forecast__c>> partFCs1 = new Map<Id, List<Opportunity_Forecast__c>>();
        partFCs1.put(oppypart.Id,oppyForecasts);
        
        map<Id, String> map_oppyPartId_isoCode = new map<Id, String>();
        map_oppyPartId_isoCode.put(oppypart.Id,'EUR');
        
        
        List<Id> list_partIds1 = new List<Id>();
        list_partIds1.add(part.Id);
        ClsOpportunityForecastStructure cls = new ClsOpportunityForecastStructure(map_oppyPartId_isoCode,'EUR',oppyForecasts,partFCs,'2012',oppy.Id,map_partId_oppyId,rt.Id,rt.Id,'Monthly',list_partIds);
        list_forecastStructures.add(cls);
        
        List<String> list_years = new List<String>();
        list_years.add('2012');
        Map<String, List<Opportunity_Forecast__c>> map_year_oppyForecast = new Map<String, List<Opportunity_Forecast__c>>();
        map_year_oppyForecast.put('2012',oppyForecasts);
        
        Map<String, Map<Id, List<Opportunity_Forecast__c>>> map_year_map_partId_oppyForecast = new Map<String, Map<Id, List<Opportunity_Forecast__c>>>();
        map_year_map_partId_oppyForecast.put('2012',partFCs1);
        
        //ClsOppyUtil.saveProgram(list_parts, list_forecastStructures, true, list_years, map_year_oppyForecast, map_year_map_partId_oppyForecast, 'Monthly', 'BOM', oppy.Id, 'EUR', rt.Id, rt.Id, list_partIds,system.today());
        //ClsOppyUtil.saveProgram(list_parts, list_forecastStructures, false, list_years, map_year_oppyForecast, map_year_map_partId_oppyForecast, 'Monthly', 'BOM', oppy.Id, 'EUR', rt.Id, rt.Id, list_partIds,system.today());
        system.assert(true);
        Test.stopTest();
        }
    }
     static testMethod void PartIsNull() {
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
      
            /*Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.Request_Type__c = 'Extension';
            oppy2.RecordTypeId = rt2.Id;
            insert oppy2; */ 
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            //oppy.Program__c = oppy2.Id;   
            oppy.Type = 'CM';
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
            oppypart.Status__c = 'Lost';
            oppypart.Lost_Reason__c = 'Other';
            oppypart.Lost_Reason_Text__c = null;
            oppypart.GPL__c = ph.Id;
            insert oppypart;
            
            Opportunity_Partner__c oppyPartner = new Opportunity_Partner__c();
            oppyPartner.Opportunity__c = oppy.Id;
            oppyPartner.Account__c = acc.Id;
            oppyPartner.Allocation__c = 100;
            insert oppyPartner;
            
            Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast.Opportunity__c = oppy.Id;
            oppyForecast.Quantity__c = 12;
            oppyForecast.Part__c = null;
            oppyForecast.Sales_Price__c = 1;
            oppyForecast.Date__c = date.newInstance(2012, 09, 28);
            oppyForecast.Amount__c = 1;
            insert oppyForecast;
            
            Set<Id> set_oppyIds = new Set<Id>();
            set_oppyIds.add(oppy.Id);
            
            Test.startTest();
            
            ClsOppyUtil.getOppyForeCastMap(set_oppyIds);
            ClsOppyUtil.buildOppyForeCastMap(oppy.Id);
            
            system.assert(true);
            Test.stopTest();  
        }
     }      
    static testMethod void PartIsNotNull() {
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
      
            /*Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.Request_Type__c = 'Extension';
            oppy2.RecordTypeId = rt2.Id;
            insert oppy2;  
            */
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            //oppy.Program__c = oppy2.Id;   
            oppy.Type = 'CM';
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
            oppypart.Status__c = 'Lost';
            oppypart.Lost_Reason__c = 'Other';
            oppypart.Lost_Reason_Text__c = null;
            oppypart.GPL__c = ph.Id;
            insert oppypart;
            
            Opportunity_Partner__c oppyPartner = new Opportunity_Partner__c();
            oppyPartner.Opportunity__c = oppy.Id;
            oppyPartner.Account__c = acc.Id;
            oppyPartner.Allocation__c = 100;
            insert oppyPartner;
            
            Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast.Opportunity__c = oppy.Id;
            oppyForecast.Quantity__c = 12;
            oppyForecast.Part__c = oppypart.Id;
            oppyForecast.Date__c = date.newInstance(2012, 09, 28);
            oppyForecast.Amount__c = 1;
            oppyForecast.Sales_Price__c = 1;
            oppyForecast.CurrencyIsoCode = 'EUR';
            insert oppyForecast;
            
            Set<Id> set_oppyIds = new Set<Id>();
            set_oppyIds.add(oppy.Id);
            
            map<Id, String> map_oppyPartId_isoCode = new map<Id, String>();
            map_oppyPartId_isoCode.put(oppypart.Id,'EUR');
            
            Map<Id, Id> map_partId_oppyId = new Map<Id, Id>();
            map_partId_oppyId.put(oppypart.Id,oppy.Id);
                
            map<Id,Opportunity> map_oppyId_oppy = new map<Id,Opportunity>();
            map_oppyId_oppy.put(oppy.Id,oppy);
            
            map<Id,string> map_accId_industry = new map<Id,string>();
            map_accId_industry.put(acc.Id,'bu');
                
            Test.startTest();
            
            //ClsOppyUtil.initOppyForecastStructures(map_oppyPartId_isoCode, 'EUR', map_partId_oppyId, list_forecastStructures, list_years, map_year_oppyForecast, map_year_map_partId_oppyForecast, 'Monthly', oppy.Id, rt.Id, rt.Id, list_partIds);
            ClsOppyUtil.buildProgramAllPartForeCastMap(oppy.Id);
            ClsOppyUtil.opportunityApprovalFuture(set_oppyIds);
            ClsOppyUtil.checkCrossBu(map_oppyId_oppy, map_accId_industry);
            
            system.assert(true);
            Test.stopTest();  
        }
     }
}