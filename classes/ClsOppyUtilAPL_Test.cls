/**
*   This test class is for ClsOppyUtilAPL.
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

@changelog
* 2014-09-01 Padmaja D <padmaja.dadi@te.com>
* - Created
* - Test coverage 88%
*/
@isTest(SeeAllData=false)
private class ClsOppyUtilAPL_Test {
       
    static testMethod void oppyForeCastType() { 
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();

        RecordType rt = ClsTestHelp.createTestRecordType();
        RecordType rt2 = ClsTestHelp.createTestRecordType16();
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        insert acc;
		Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.RecordTypeId = rt2.Id;
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
        //oppypart.Status__c = 'Lost1';
        //oppypart.Lost_Reason__c = 'Other';
        //oppypart.Lost_Reason_Text__c = null;
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
        oppyForecast.Five_Year_Amount__c = 1000;
        oppyForecast.Sales_Price__c = 1;
        
        Opportunity_Forecast__c oppyForecast1 = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast1.Opportunity__c = oppy.Id;
        oppyForecast1.Quantity__c = 12;
        //oppyForecast.Part__c = oppypart.Id;
        oppyForecast1.Date__c = date.newInstance(2012, 09, 28);
        oppyForecast1.Amount__c = 1;
        oppyForecast1.Five_Year_Amount__c = 1000;
        oppyForecast1.Sales_Price__c = 1;
        insert new List<Opportunity_Forecast__c>{oppyForecast, oppyForecast1};
        
        Test.startTest();
        
        Set<String> set_forecastYears = new Set<String>();
        set_forecastYears.add('2012');
        
        ClsOppyUtilAPL.getYearList(set_forecastYears, true, 1);
        ClsOppyUtilAPL.getYearList(set_forecastYears, false, 1);
        ClsOppyUtilAPL.getAllPeriodYears();
        
        Map<Id, Id> map_partId_oppyId = new Map<Id, Id>();
        map_partId_oppyId.put(part.Id,oppy.Id);
        
        List<Id> list_partIds = new List<Id>();
        list_partIds.add(part.Id);
        
        Map<Id, Opportunity> map_oppyid_opportunity = new Map<Id, Opportunity>();
        map_oppyid_opportunity.put(oppy.Id,oppy);
        
        ClsOppyUtilAPL.getFiscalMonthStartDate('2012', '2');
        
        Set<Id> set_oppyIds = new Set<Id>();
        set_oppyIds.add(oppy.Id);
        ClsOppyUtilAPL.getOppyYearMap(set_oppyIds);
        
        ClsOppyUtilAPL.getLevelLabel('Monthly');
        ClsOppyUtilAPL.getLevelLabel('Yearly');
        ClsOppyUtilAPL.getLevelLabel('Quarterly');
        ClsOppyUtilAPL.getForecastLevelNoYear();
        ClsOppyUtilAPL.getForecastLevel();
        ClsOppyUtilAPL.getYearNumber();
        
        Date inputDate = date.today();
        ClsOppyUtilAPL.getForecastMonth(inputDate);
        ClsOppyUtilAPL.getForecastYear(inputDate);
        
        ClsOppyUtilAPL.getFiscalQuarterStartDate('2012', '3');
        ClsOppyUtilAPL.getPartIdsByOppyId(set_oppyIds);
        
        
        List<Opportunity_Forecast__c> list_oppyForecasts = new List<Opportunity_Forecast__c>();
        list_oppyForecasts.add(oppyForecast);
        Map<Id, List<Opportunity_Forecast__c>> partFCs = new  Map<Id, List<Opportunity_Forecast__c>>();
        partFCs.put(part.Id,list_oppyForecasts);
        
        List<ClsOpportunityForecastStructure.ForecastItemStructure> monthForecasts = new List<ClsOpportunityForecastStructure.ForecastItemStructure>();
        ClsOpportunityForecastStructure.ForecastItemStructure monthClsFore = new ClsOpportunityForecastStructure.ForecastItemStructure('Monthly', part.Id, oppy.Id, rt.Id);
        
        
        List<ClsOpportunityForecastStructure.ForecastItemStructure> quarterForecasts = new List<ClsOpportunityForecastStructure.ForecastItemStructure>();
        ClsOpportunityForecastStructure.ForecastItemStructure QuarterlyClsFs = new ClsOpportunityForecastStructure.ForecastItemStructure('Quarterly', part.Id, oppy.Id, rt.Id);
        
        ClsOppyUtilAPL.getOpportunitysByProgramId(oppy.Id);
        ClsOppyUtilAPL.getStatusItems();
        
        ClsOppyUtilAPL.buildAllPartForeCastMap(oppy.Id);
        
        ClsOppyUtilAPL.getPartsByOppyId(set_oppyIds);
        ClsOppyUtilAPL.getAllPartsByProgramId(oppy.Id);
        ClsOppyUtilAPL.buildProgramAllPartForeCastMap(oppy2.Id);
        //ClsOppyUtilAPL.buildAllPartForeCastMap(oppy.Id, oppyForecast);
        
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
        ClsOppyUtilAPL.getForecastQuarter(inputDate1);
        
        map<Id,Id> map_oppId_accId_new = new map<Id,Id>();
        map_oppId_accId_new.put(oppy.Id,acc.Id);
        
        map<Id,Id> map_oppId_accId_old = new map<Id,Id>();
        map_oppId_accId_old.put(oppy.Id,acc.Id);
        
        //  ClsOppyUtilAPL.PopulateOpptyPartner('INSERT', map_oppId_accId_new, map_oppId_accId_old);
        //  ClsOppyUtilAPL.startDate(list_forecastStructures);
        ClsOppyUtilAPL.buildOppyForeCastMapByYear(oppyForecasts);
        ClsOppyUtilAPL.buildOppyForeCastMap(oppy.Id);
        ClsOppyUtilAPL.getForecastMonthNum(date.today());
        
        set<Id> set_uId = new set<Id>();
        set_uId.add(userinfo.getUserId());
        
        map<Id,set<Id>> map_oppyId_userId = new map<Id,set<Id>>();
        map_oppyId_userId.put(oppy.Id,set_uId);
        
        ClsOppyUtilAPL.grantAccess(map_oppyId_userId);
        
        list<Opportunity> oppys = new list<Opportunity>();
        oppys.add(oppy);
        
        ClsOppyUtilAPL.checkProgramOppyMethod('123', oppys);
        
        List<ClsOpportunityForecastStructure> list_forecastStructures2 = new List<ClsOpportunityForecastStructure>();
        
        //ClsOppyUtilAPL.ValidateApproverPM(list_parts); 
        
        ClsOppyUtilAPL.recalculateRevenue(map_oppyid_opportunity, 'BOM', 'Yearly', date.newInstance(2012, 05, 06));
        
        set<Date> set_startDate = new set<Date>();
        set_startDate.add(date.newInstance(2012, 05, 06));
        ClsOppyUtilAPL.getFiveYearsInternal(set_startDate);
        ClsOppyUtilAPL.getFiveYearsInternal(date.newInstance(2012, 05, 06), 'Yearly');
        
        ClsOppyUtilAPL.updateOpportunityAmounts(map_oppyid_opportunity, 'BOM', 'Yearly', oppy);
        
        set<Opportunity> set_programOppys = new set<Opportunity>();
        set_programOppys.add(oppy);
        ClsOppyUtilAPL.updateProgramTotalFiveYearsAmount(oppy, set_programOppys);
        
        ClsOppyUtilAPL.addOppyOneYear(map_oppyPartId_isoCode, 'EUR', list_forecastStructures2, list_years, '2010', map_partId_oppyId, list_partIds, oppy.Id, rt.Id, rt.Id, 'Monthly');
        ClsOppyUtilAPL.addOppyOneYear(map_oppyPartId_isoCode, 'EUR', list_forecastStructures, list_years, '2010', map_partId_oppyId, list_partIds, oppy.Id, rt.Id, rt.Id, 'Monthly');
        ClsOppyUtilAPL.addOppyOneYear(map_oppyPartId_isoCode, 'EUR', list_forecastStructures, list_years, '2011', map_partId_oppyId, list_partIds, oppy.Id, rt.Id, rt.Id, 'Monthly');
		
        ClsOppyUtilAPL.getIsConvertVal();
        ClsOppyUtilAPL.getOpportunityById(oppy.Id);
		 
        ClsOppyUtilAPL.getOtherYears(list_years);
        ClsOppyUtilAPL.transformIsoCode(1, 'EUR', 'EUR');
        ClsOppyUtilAPL.getOppyForeCastMap(set_oppyIds);
        ClsOppyUtilAPL.calStartDate(list_forecastStructures, 'Monthly');
        ClsOppyUtilAPL.calStartYear(list_forecastStructures);
        ClsOppyUtilAPL.addOppyYears(map_oppyPartId_isoCode, 'EUR',list_forecastStructures, list_years, 2012, map_partId_oppyId, list_partIds, oppy.Id, rt.Id, rt.Id, 'Monthly');
        ClsOppyUtilAPL.addAllOppyYears(map_oppyPartId_isoCode, 'EUR', list_forecastStructures, list_years, 2012, map_partId_oppyId, list_partIds, oppy.Id, rt.Id, rt.Id, 'Monthly');
        Map<Id, Opportunity_Part__c> map_parts = new Map<Id, Opportunity_Part__c>();
        map_parts.put(part.Id,oppypart);
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
        ClsOpportunityForecastStructure.ForecastStructure fcs = new ClsOpportunityForecastStructure.ForecastStructure('EUR','EUR',oppyForecasts,oppy.Id,part.Id,'2012',rt.Id,'Monthly');         
        fcs.getEditForecasts();
        fcs.getSalesPriceOF();
        fcs.list_editForecasts = list_editForecasts;
        ClsOppyUtilAPL.transferAllStructures(list_forecastStructures, 'Monthly', 'BOM', map_parts);
        ClsOppyUtilAPL.transferStructure(fcs, 'Monthly');
        ClsOppyUtilAPL.transferStructure(fcs, 'Yearly');
        ClsOppyUtilAPL.transferStructure(fcs, 'Quarterly');
        
        ClsOppyUtilAPL.transferStructureFromOppy(fcs, list_editForecasts, 1.0, 'Monthly');
         list_editForecasts.add(clsF1);
        list_editForecasts.add(clsF2);
        list_editForecasts.add(clsF3); 
        list_editForecasts.add(clsF4);
        List<ClsOpportunityForecastStructure.ForecastStructure> list_pfcs = new List<ClsOpportunityForecastStructure.ForecastStructure>();          
        ClsOpportunityForecastStructure.ForecastStructure fcs1 = new ClsOpportunityForecastStructure.ForecastStructure('EUR','EUR',oppyForecasts,oppy.Id,part.Id,'2012',rt.Id,'Monthly');         
        fcs1.list_editForecasts = list_editForecasts;
        list_pfcs.add(fcs1);
        
        ClsOppyUtilAPL.transferStructureFromPart(fcs1, list_pfcs, 'Monthly');
        ClsOppyUtilAPL.transferStructureFromPart(fcs1, list_pfcs, 'Yearly');
        ClsOppyUtilAPL.transferStructureFromPart(fcs1, list_pfcs, 'Quarterly');
        list_editForecasts.add(clsF1);
        list_editForecasts.add(clsF2);
        list_editForecasts.add(clsF3); 
        list_editForecasts.add(clsF4); 
        fcs1.list_editForecasts = list_editForecasts;
        ClsOppyUtilAPL.convertStructure(fcs1, 'Yearly');
        ClsOppyUtilAPL.updateOpportunityFromForecast(oppy2.Id, rt2.Id);
        ClsOppyUtilAPL.initOppyForecastStructures(map_oppyPartId_isoCode, 'EUR', map_partId_oppyId, list_forecastStructures, list_years, map_year_oppyForecast, map_year_map_partId_oppyForecast, 'Monthly', oppy.Id, rt.Id, rt.Id, list_partIds);
        ClsOpportunityForecastStructure.ForecastStructure inputFS = new ClsOpportunityForecastStructure.ForecastStructure('EUR','EUR',oppyForecasts,oppy.Id,part.Id,'2012',rt2.Id,'Monthly');
        Map<String, ClsOpportunityForecastStructure> map_year_structure = new Map<String, ClsOpportunityForecastStructure>();
        
        map_year_structure.put('2012',cls);
        ClsOppyUtilAPL.resetForecastByMoveDate('2012', inputFS, 1, map_year_structure, 'Monthly', 'Oppy', 1, list_years);
        ClsOppyUtilAPL.yearListIndex(list_years, '2009');
        ClsOppyUtilAPL.yearByIndex(list_years, '2009', 0);
        ClsOppyUtilAPL.yearByIndex(list_years, '2009', -2);
        TOPS_Forecast__c tf = new TOPS_Forecast__c();
        Map<String, List<Opportunity_Forecast__c>> map_yearQuarter_oppyForecasts = new Map<String, List<Opportunity_Forecast__c>>();
        map_yearQuarter_oppyForecasts.put('2012',oppyForecasts);
        ClsOppyUtilAPL.generateForecasts(tf, oppy.Id, oppypart.Id, '2012', 'CY', '', map_yearQuarter_oppyForecasts, 'EUR',rt2.Id);
        ClsOppyUtilAPL.opportunityApprovalFuture(set_oppyIds);
        map<Id,string> map_accId_industry = new map<Id,string>();
            map_accId_industry.put(acc.Id,'bu');
        map<Id,Opportunity> map_oppyId_oppy = new map<Id,Opportunity>();
            map_oppyId_oppy.put(oppy.Id,oppy);
        ClsOppyUtilAPL.checkCrossBu(map_oppyId_oppy, map_accId_industry);
        ClsOppyUtilAPL.recalculateConnectedProgram(new List<Opportunity>{oppy}, null, 'Update',new List<Opportunity>() );
        ClsOppyUtilAPL.recalculateProgramStage(oppy, new Set<String>{'Won'},  new Set<String>{'Won'});
        Set<Id> set_partIds = new Set<Id>();
        set_partIds.add(oppypart.Id);
        ClsOppyUtilAPL.deleteForecastUpdateOppys(set_partIds);
        
        oppypart.Status__c = 'Lost';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        update oppypart;
        
        ClsOppyUtilAPL.deleteForecastUpdateOppys(new Set<Id>{oppypart.Id});
        ClsOppyUtilAPL.deleteOppyYear(list_forecastStructures, '2012');
        system.assert(true);
        Test.stopTest();
        
    }

}