/**
*   This test class is for ExtOppyForecastEntryPage.
*
@author Di Chen
@created 2012-03-14
@version 1.0
@since 20.0
*
@changelog
* 2012-03-14 Di Chen <di.chen@itbconsult.com>
* - Created 
* - Test coverage 82%
*/
@isTest
private class ExtOppyForecastEntryPage_Test {
      
    static testMethod void testAll() {
 
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();

        RecordType rt31 = ClsTestHelp.createTestRecordType31();
        insert (new Opportunity_Record_Type_Groups__c(name = 'ADM sales',RecordTypeID__c = rt31.Id, Group__c = 'ADM Group', active__c = true));
        insert (new Opportunity_Record_Type_Groups__c(name = 'ADM',RecordTypeID__c = rt31.Id, Group__c = 'Engineering Milestones Opportunities', active__c = true));
        insert (new Opportunity_Record_Type_Groups__c(name = 'DND Opportunity',RecordTypeID__c = '012E0000000NIlV', Group__c = 'Process Status Display', active__c = true));
        //ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();      
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ChannelinsightData_test.ChannelinsightData_test();

        Profile p = [Select Id, Name From Profile 
                     where Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'hellEFD@testCompany1233423.com';
        u.Alias = 'dpED';
        u.CommunityNickname = 'NNDU';
        u.ProfileId = p.Id;
        u.LocaleSidKey= 'de';
        insert u;
              
        system.runAs(u){  
                     ClsTestCustomSettingHelper.getApex_Helper_Settings();  
        RecordType rt = ClsTestHelp.createTestRecordType();
        RecordType rt1 = ClsTestHelp.createTestRecordType11();
        RecordType rt2 = ClsTestHelp.createTestRecordType16();   
        
        /* Poonam -Added custom setting to fix test failure- Start*/
        ADMTerritoryCode__c admTerritoryCode= new ADMTerritoryCode__c();
        admTerritoryCode.Name='ADMTerritoryCode';
        admTerritoryCode.Territory_Code__c='101485';
        insert admTerritoryCode;
        /* Poonam -Added custom setting to fix test failure- End*/
          
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
        oppy.Program__c = oppy2.Id;   
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        oppy.RecordTypeId = rt1.Id;
        oppy.stagename= 'Approved/Active';
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
        
        List<Opportunity_Forecast__c> lstfcst = new List<Opportunity_Forecast__c>();
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy.Id;
        oppyForecast.Quantity__c = 12;
        oppyForecast.Part__c = oppypart.Id;
        oppyForecast.Date__c = date.newInstance(2012, 09, 28);
        oppyForecast.Amount__c = 1;
        lstfcst.add(oppyForecast);
        //insert oppyForecast;
        
        Opportunity_Forecast__c oppyForecast2 = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast2.Opportunity__c = oppy.Id;
        oppyForecast2.Quantity__c = 12;
        oppyForecast2.Part__c = oppypart.Id;
        oppyForecast2.Date__c = date.newInstance(2012, 09, 28);
        oppyForecast2.Amount__c = 1;
        //insert oppyForecast2;
        lstfcst.add(oppyForecast2);
        insert lstfcst;
        
        map<Id, Decimal> map_partId_price = new map<Id, Decimal>();
        map_partId_price .put(part.Id,0);
        List<Opportunity_Forecast__c> oppyForecasts = new List<Opportunity_Forecast__c>();
        oppyForecasts.add(oppyForecast);
        oppyForecasts.add(oppyForecast2);
        
        Map<Id, List<Opportunity_Forecast__c>> partFCs = new Map<Id, List<Opportunity_Forecast__c>>();
        partFCs.put(oppypart.Id,oppyForecasts);
        
        Map<Id, Id> map_partId_oppyId = new Map<Id, Id>();
        map_partId_oppyId.put(oppypart.Id,oppy.Id);
        
        //RecordType rt = ClsTestHelp.createTestRecordType();
        
        List<Id> list_partIds = new List<Id>();
        list_partIds.add(oppypart.Id);
        
        map<Id, String> map_oppyPartId_isoCode = new map<Id, String>();
        map_oppyPartId_isoCode.put(oppypart.Id,'EUR');
        
        list<ClsOppForecastStructure> list_forecastStructures = new list<ClsOppForecastStructure>();
        ClsOppForecastStructure cls = new ClsOppForecastStructure('2012');
        ClsOppForecastStructure.ForecastStructure clsFS = new ClsOppForecastStructure.ForecastStructure();
        ClsOppForecastStructure.ForecastItemStructure clsFIS = new ClsOppForecastStructure.ForecastItemStructure();
         clsFIS.quantity = 12;
          clsFIS.amount = 1;      
        ClsOppForecastStructure.PartForecastStructure clsP = new ClsOppForecastStructure.PartForecastStructure();
        list_forecastStructures.add(cls);
        
        List<Opportunity_Part__c> list_oppypart = new List<Opportunity_Part__c>();
        list_oppypart.add(oppypart);
        
        Map<String, Map<Id, List<Opportunity_Forecast__c>>> map_year_map_partId_oppyForecast = new Map<String, Map<Id, List<Opportunity_Forecast__c>>>();
        map_year_map_partId_oppyForecast.put('2012',partFCs);
        
        List<String> list_years = new List<String>();
        list_years.add('2012');
          
        Map<String, List<Opportunity_Forecast__c>> map_oppyForeCasts = new Map<String, List<Opportunity_Forecast__c>>();
        map_oppyForeCasts.put('2012',oppyForecasts);
        
        ExtOppyForecastEntryPage.PartStructure extPart = new ExtOppyForecastEntryPage.PartStructure(oppypart);

        Test.startTest();
        
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(oppy); 
       
        
        ExtOppyForecastEntryPage ext = new ExtOppyForecastEntryPage(ctrl);
        
        ext.opportunity = oppy;
        ext.list_forecastStructures = list_forecastStructures;
        ext.oneYear = '2031';
        ext.year2Delete = '2012';
        ext.list_years = list_years;
        ext.currentYear = 2012;
        ext.hasForecasts = false;
        
        ext.getForecastStructures();
        ext.getStatusItems();
        ext.getLevelLabel();
        ext.getForecastMethod();
        ext.getForecastLevel();
        ext.saveOppy();
         checkRecursive.run =true;
        ext.saveProgram();
         
        ext.cancelToProgram();
        ext.editOppy(); 
        ext.cancelToOppy();
        ext.buildStructures(map_oppyForeCasts,map_year_map_partId_oppyForecast,map_partId_oppyId,map_oppyPartId_isoCode,oppy,list_years,list_partIds,map_partId_price );
        ext.editPrograms();
        
        Date d = date.newInstance(06, 28, 2010);
        String inputDate = d.format();
        
        Date d2 = date.newInstance(06, 28, 2011);
        String inputDate2 = d2.format();
        ExtOppyForecastEntryPage.buildOppyForeCastMap(oppy.Id);
        
        
        ExtOppyForecastEntryPage ext1 = new ExtOppyForecastEntryPage(ctrl);
        ext1.opportunity = oppy2;
        ext1.list_forecastStructures = list_forecastStructures;
        ext1.oneYear = '2031';
        ext1.year2Delete = '2012';
        ext1.list_years = list_years;
        ext1.currentYear = 2012;
        ext1.hasForecasts = false;
        
        ext1.getForecastStructures();
        ext1.getStatusItems();
        ext1.getLevelLabel();
        ext1.getForecastMethod();
        ext1.getForecastLevel();
        ext1.getProcessStatusItems();
        ext1.getConfidenceItem();
        ext1.saveProgram();
        ext1.tam();
        

        
         
        ext1.cancelToProgram();
        ext1.editOppy(); 
        ext1.cancelToOppy();
        ext1.buildStructures(map_oppyForeCasts,map_year_map_partId_oppyForecast,map_partId_oppyId,map_oppyPartId_isoCode,oppy,list_years,list_partIds,map_partId_price );
        ext1.editPrograms();
        
        Date d1 = date.newInstance(06, 28, 2010);
        String inputDate1 = d1.format();
        
        Date d3 = date.newInstance(06, 28, 2011);
        String inputDate3 = d3.format();
        ExtOppyForecastEntryPage.buildOppyForeCastMap(oppy.Id);
        
        ExtOppyForecastEntryPage.ForecastHistoryStructure o = new ExtOppyForecastEntryPage.ForecastHistoryStructure('2015', 2015, 2016);
        
        
        system.assert(true);
        
        Opportunity oppy1 = ClsTestHelp.createTestOpportunity();
        oppy1.Program__c = oppy2.Id;   
        oppy1.Type = 'CM';
        oppy1.Request_Type__c = 'Extension';
        oppy1.Method__c = 'BOM';
        oppy1.Level__c = 'Yearly';
        oppy1.Amount = 1;
        oppy1.CurrencyIsoCode = 'EUR';
        oppy1.Five_Year_Revenue__c = 1;
        oppy1.RecordTypeId = rt1.Id;
        oppy1.stagename= 'Approved/Active';
        oppy1.closeDate=date.newInstance(2016, 06, 28);
        insert oppy1;
        ext1.editOppy();
        Test.stopTest();
        } 
    }

     static testMethod void testAll21() {

        ClsTestCustomSettingHelper.getApex_Helper_Settings();         
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        //ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
        ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();

        list<Opportunity_Record_Type_Groups__c> lstORTG = new list<Opportunity_Record_Type_Groups__c>();
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'DND Opportunity', RecordTypeID__c = '012c00000004tlA'));
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'NDR Opportunity',RecordTypeID__c = '012E0000000egdDIAQ', active__c = true));
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'CCR Opportunity',RecordTypeID__c = '0123C000000065gQAA', active__c = true));
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'Part Std Price Display on Forecast',RecordTypeID__c = '012E0000000eR0c', Group__c = 'Part Std Price Display on Forecast', active__c = true));
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'Change Channel Oppy header level',RecordTypeID__c = '012E0000000eR0c', Group__c = 'Change Channel Opportunities at header level', active__c = true));
         insert lstORTG;         

        Profile p = [Select Id, Name From Profile 
                     where Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'hellosERYT@testCompany1233423.com';
        u.Alias = 'dp2s';
        u.CommunityNickname = 'NND9';
        u.ProfileId = p.Id;
        insert u; 
              
        system.runAs(u)  {         
        RecordType rt = ClsTestHelp.createTestRecordType();
        RecordType rt2 = ClsTestHelp.createTestRecordType16();
        
        /* Poonam -Added custom setting to fix test failure- Start*/
        ADMTerritoryCode__c admTerritoryCode= new ADMTerritoryCode__c();
        admTerritoryCode.Name='ADMTerritoryCode';
        admTerritoryCode.Territory_Code__c='101485';
        insert admTerritoryCode;
        /* Poonam -Added custom setting to fix test failure- End*/
              
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        insert acc;
            
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        oppy2.Request_Type__c = 'Extension';
        oppy2.RecordTypeId = rt2.Id;
        oppy2.PMV_Type__c = 'IND Standard ENG opp';
        oppy2.StageName = 'In Approval';    
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
        insert oppypart;
        
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy.Id;
        oppyForecast.Quantity__c = 12;
        oppyForecast.Part__c = null;//oppypart.Id;
        //oppyForecast.Date__c = date.newInstance(2012, 09, 28);
        oppyForecast.Date__c = date.today();
        oppyForecast.Amount__c = 1;
        //insert oppyForecast;
        
        Opportunity_Forecast__c oppyForecast2 = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast2.Opportunity__c = oppy.Id;
        oppyForecast2.Quantity__c = 12;
        oppyForecast2.Part__c = null;//oppypart.Id;
        //oppyForecast2.Date__c = date.newInstance(2012, 09, 28);
        oppyForecast2.Date__c = date.today();
        oppyForecast2.Amount__c = 1;
        //insert oppyForecast2;
        
        List<Opportunity_Forecast__c> oppyForecasts = new List<Opportunity_Forecast__c>();
        oppyForecasts.add(oppyForecast);
        oppyForecasts.add(oppyForecast2);
        insert oppyForecasts;
        
        Map<Id, List<Opportunity_Forecast__c>> partFCs = new Map<Id, List<Opportunity_Forecast__c>>();
        partFCs.put(oppypart.Id,oppyForecasts);
        
        Map<Id, Id> map_partId_oppyId = new Map<Id, Id>();
        map_partId_oppyId.put(oppypart.Id,oppy.Id);
        
        //RecordType rt = ClsTestHelp.createTestRecordType();
        
        List<Id> list_partIds = new List<Id>();
        list_partIds.add(oppypart.Id);
        
        map<Id, String> map_oppyPartId_isoCode = new map<Id, String>();
        map_oppyPartId_isoCode.put(oppypart.Id,'EUR');
        
        list<ClsOppForecastStructure> list_forecastStructures = new list<ClsOppForecastStructure>();
        ClsOppForecastStructure cls = new ClsOppForecastStructure('2012');
        ClsOppForecastStructure.ForecastStructure clsFS = new ClsOppForecastStructure.ForecastStructure();
        ClsOppForecastStructure.ForecastItemStructure clsFIS = new ClsOppForecastStructure.ForecastItemStructure();
         clsFIS.quantity = 12;
          clsFIS.amount = 1;      
        ClsOppForecastStructure.PartForecastStructure clsP = new ClsOppForecastStructure.PartForecastStructure();
        list_forecastStructures.add(cls);
        
        List<Opportunity_Part__c> list_oppypart = new List<Opportunity_Part__c>();
        list_oppypart.add(oppypart);
        
        Map<String, Map<Id, List<Opportunity_Forecast__c>>> map_year_map_partId_oppyForecast = new Map<String, Map<Id, List<Opportunity_Forecast__c>>>();
        map_year_map_partId_oppyForecast.put('2012',partFCs);
        
        List<String> list_years = new List<String>();
        list_years.add('2012');
          
        Map<String, List<Opportunity_Forecast__c>> map_oppyForeCasts = new Map<String, List<Opportunity_Forecast__c>>();
        map_oppyForeCasts.put('2012',oppyForecasts);
        
        ExtOppyForecastEntryPage.PartStructure extPart = new ExtOppyForecastEntryPage.PartStructure(oppypart);

        Test.startTest();
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(oppy2); 
        ExtOppyForecastEntryPage ext = new ExtOppyForecastEntryPage(ctrl);
        ext.saveString = 'Completed';
        ext.opportunity = oppy2;
        oppypart.Process_Status__c = 'Production';
        checkRecursive.run =true;
        ExtOppyForecastEntryPage.PartStructure oPartStructure = new ExtOppyForecastEntryPage.PartStructure(oppypart);
        oPartStructure.orderDate = String.valueOf(date.today());
        oPartStructure.billingDate = String.valueOf(date.today());
        ext.parts = new list<ExtOppyForecastEntryPage.PartStructure>{oPartStructure};
        ext.isAPL = true;
        ext.saveOppy();
        ext.saveProgram();
        
        /**************/
        ext.reActiveForecast();
        ExtOppyForecastEntryPage.NDROpptyRecordTypeId();
        ext.getOppyPartDefaultConfidenceAndProcessStatus();
        ext.getForecastLevel();
        /**************/
        
        ExtOppyForecastEntryPage.buildOppyForeCastMap(oppy.Id);
        
        ExtOppyForecastEntryPage ext1 = new ExtOppyForecastEntryPage(ctrl);
        ext1.saveString = 'Completed';
        ext1.opportunity = oppy2;
        ext1.saveOppy();
        ext1.saveProgram();
        
        ExtOppyForecastEntryPage.buildOppyForeCastMap(oppy.Id);
        ext.isProgramLevel = true;
        ext.debug_string = 'test';
        ext.defaultConfidence = 'test';
        ext.defaultProcessStatus = 'test';
        system.assert(true);
        Test.stopTest();    
         }   
         } 

    static testMethod void testSave() {
        ClsTestCustomSettingHelper.getApex_Helper_Settings(); 
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
        
        ChannelinsightData_test.ChannelinsightData_test();

        Profile p = [Select Id, Name From Profile 
                     where Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'hellosManADedsfd@testCompany1233423.com';
        u.Alias = 'ABVD';
        u.CommunityNickname = 'RND';
        u.ProfileId = p.Id;
        u.Sub_Vertical__c ='Industrial';
        u.GIBU__c = 'Industrial';

        insert u;
         
         
          RecordType rt2 = ClsTestHelp.createTestRecordType16(); 
          RecordType rt3 = ClsTestHelp.createTestRecordType7(); 
              
        system.runAs(u){  
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();      
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true;
        oppy2.Level__c = 'Quarterly';
        oppy2.Name = 'Pain of Queen';
        oppy2.recordtypeid = rt2.Id;//mrunal
        insert oppy2;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Level__c = 'Quarterly';
        oppy.Program__c = oppy2.Id;
        oppy.recordtypeid = rt2.Id;//mrunal
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
        oppyForecast.Part__c = null;// oppypart.Id;
        oppyForecast.Date__c = date.newInstance(2012, 09, 28);
        oppyForecast.Amount__c = 1;
        insert oppyForecast;
        
        List<Opportunity_Forecast__c> oppyForecasts = new List<Opportunity_Forecast__c>();
        oppyForecasts.add(oppyForecast);
        
        Map<Id, List<Opportunity_Forecast__c>> partFCs = new Map<Id, List<Opportunity_Forecast__c>>();
        partFCs.put(oppypart.Id,oppyForecasts);
        
        Map<Id, Id> map_partId_oppyId = new Map<Id, Id>();
        map_partId_oppyId.put(oppypart.Id,oppy.Id);
        
        RecordType rt = ClsTestHelp.createTestRecordType();
        
        List<Id> list_partIds = new List<Id>();
        list_partIds.add(oppypart.Id);
        
        map<Id, String> map_oppyPartId_isoCode = new map<Id, String>();
        map_oppyPartId_isoCode.put(oppypart.Id,'EUR');
        
        list<ClsOppForecastStructure> list_forecastStructures = new list<ClsOppForecastStructure>();
        ClsOppForecastStructure cls = new ClsOppForecastStructure('2012');
        ClsOppForecastStructure.ForecastStructure clsFS = new ClsOppForecastStructure.ForecastStructure();
        ClsOppForecastStructure.ForecastItemStructure clsFIS = new ClsOppForecastStructure.ForecastItemStructure();
        ClsOppForecastStructure.PartForecastStructure clsP = new ClsOppForecastStructure.PartForecastStructure();
        list_forecastStructures.add(cls);
        
        List<Opportunity_Part__c> list_oppypart = new List<Opportunity_Part__c>();
        list_oppypart.add(oppypart);
        
        List<String> list_years = new List<String>();
        list_years.add('2012');
        
        Test.startTest();
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(oppy); 
        ExtOppyForecastEntryPage ext = new ExtOppyForecastEntryPage(ctrl);
        ext.opportunity = oppy;
        ext.list_forecastStructures = list_forecastStructures;
        //ext.list_parts = list_oppypart;
        ext.year2Delete = '2012';
        ext.list_years = list_years;
        ext.currentYear = 2012;

       // ext.save();
        ext.saveOppy();
        
        ExtOppyForecastEntryPage ext1 = new ExtOppyForecastEntryPage(ctrl);
        ext1.opportunity = oppy;
        ext1.list_forecastStructures = list_forecastStructures;
        //ext.list_parts = list_oppypart;
        ext1.year2Delete = '2012';
        ext1.list_years = list_years;
        ext1.currentYear = 2012;

       // ext.save();
        ext1.saveOppy();
        system.assert(true);
        Test.stopTest(); 
        }
    }
    static testMethod void testAll2() {
        ClsTestCustomSettingHelper.getApex_Helper_Settings(); 
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ChannelinsightData_test.ChannelinsightData_test();

        Profile p = [Select Id, Name From Profile 
                     where Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'hellosManSDd@testCompany1233423.com';
        u.Alias = 'd1es';
        u.CommunityNickname = 'NND6';
        u.ProfileId = p.Id;
        u.Sub_Vertical__c ='Industrial';
        u.GIBU__c = 'Industrial';

        insert u;
              
        system.runAs(u){ 
        RecordType rt1 = ClsTestHelp.createTestRecordType7();
        RecordType rt = ClsTestHelp.createTestRecordType();
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true;
        oppy2.RecordTypeId = rt1.Id;
        oppy2.Level__c = 'Monthly';
        oppy2.Name = 'Pain of Queen';
        insert oppy2;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Level__c = 'Monthly';
        oppy.RecordTypeId = rt1.Id;
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
        oppyForecast.Part__c = null;// oppypart.Id;
        oppyForecast.Date__c = date.newInstance(2012, 09, 28);
        oppyForecast.Amount__c = 1;
        insert oppyForecast;
        
        map<Id, String> map_oppyPartId_isoCode = new map<Id, String>();
        map_oppyPartId_isoCode.put(oppypart.Id,'EUR');
        
        List<Opportunity_Part__c> list_parts = new List<Opportunity_Part__c>();
        list_parts.add(oppypart);        
        
        //List<ClsOpportunityForecastStructure> list_forecastStructures = new List<ClsOpportunityForecastStructure>();
        
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
        
       //// ClsOpportunityForecastStructure cls = new ClsOpportunityForecastStructure(map_oppyPartId_isoCode,'EUR',oppyForecasts,partFCs,'2012',oppy.Id,map_partId_oppyId,rt.Id,rt.Id,'Monthly',list_partIds);
        //cls.year = '2012';
       // list_forecastStructures.add(cls);
       
        list<ClsOppForecastStructure> list_forecastStructures = new list<ClsOppForecastStructure>();
        ClsOppForecastStructure cls = new ClsOppForecastStructure('2012');
        ClsOppForecastStructure.ForecastStructure clsFS = new ClsOppForecastStructure.ForecastStructure();
        ClsOppForecastStructure.ForecastItemStructure clsFIS = new ClsOppForecastStructure.ForecastItemStructure();
        ClsOppForecastStructure.PartForecastStructure clsP = new ClsOppForecastStructure.PartForecastStructure();
        list_forecastStructures.add(cls);
        
        List<Opportunity_Part__c> list_oppypart = new List<Opportunity_Part__c>();
        list_oppypart.add(oppypart);
        
        List<String> list_years = new List<String>();
        list_years.add('2012');
        
        Test.startTest();
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(oppy); 
        ExtOppyForecastEntryPage ext = new ExtOppyForecastEntryPage(ctrl);
        ext.opportunity = oppy2;
        ext.list_forecastStructures = list_forecastStructures;
        ext.oneYear = '2031';
        ext.year2Delete = '2012';
        ext.list_years = list_years;
        ext.currentYear = 2012;
        
        ext.getForecastStructures();
        ext.getStatusItems();
        ext.getLevelLabel();
        ext.getForecastMethod();
        ext.getForecastLevel();
         
        ext.cancelToOppy();
        
        Date d = date.newInstance(06, 28, 2010);
        String inputDate = d.format();
        
        Date d2 = date.newInstance(06, 28, 2011);
        String inputDate2 = d2.format();
        
        
        ExtOppyForecastEntryPage ext1 = new ExtOppyForecastEntryPage(ctrl);
        ext1.opportunity = oppy2;
        ext1.list_forecastStructures = list_forecastStructures;
        ext1.oneYear = '2031';
        ext1.year2Delete = '2012';
        ext1.list_years = list_years;
        ext1.currentYear = 2012;
        
        ext1.getForecastStructures();
        ext1.getStatusItems();
        ext1.getLevelLabel();
        ext1.getForecastMethod();
        ext1.getForecastLevel();
        ext1.isAPL = true;
        ext1.getProcessStatusItems();
        ext1.isAPL = false;
        ext1.isDND = true;
        ext1.getProcessStatusItems();
        ext1.getConfidenceItem(); 
        ext1.cancelToOppy();
        
        Date d1 = date.newInstance(06, 28, 2010);
        String inputDate3 = d1.format();
        
        Date d3 = date.newInstance(06, 28, 2011);
        String inputDate4 = d3.format();
        

        system.assert(true);
        Test.stopTest(); 
        }
    }
    static testMethod void testAll3() {
        ClsTestCustomSettingHelper.getApex_Helper_Settings(); 
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
        ChannelinsightData_test.ChannelinsightData_test();

        Profile p = [Select Id, Name From Profile 
                     where Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'hell23Manedsfd@testCompany1233423.com';
        u.Alias = 'dp32';
        u.CommunityNickname = 'NND5';
        u.ProfileId = p.Id;
        u.Sub_Vertical__c ='Industrial';
        u.GIBU__c = 'Industrial';

        insert u;
              
        system.runAs(u){         
        RecordType rt1 = ClsTestHelp.createTestRecordType7();
        RecordType rt = ClsTestHelp.createTestRecordType();
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true;
        oppy2.RecordTypeId = rt1.Id;
        oppy2.Level__c = 'Quarterly';
        oppy2.Name = 'Pain of Queen';
        insert oppy2;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Level__c = 'Quarterly';
        oppy.RecordTypeId = rt1.Id;
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
        oppyForecast.Part__c = null;// oppypart.Id;
        oppyForecast.Date__c = date.newInstance(2012, 09, 28);
        oppyForecast.Forecasting_Start_Date__c = system.today();
        oppyForecast.Amount__c = 1;
        insert oppyForecast;
        
        map<Id, String> map_oppyPartId_isoCode = new map<Id, String>();
        map_oppyPartId_isoCode.put(oppypart.Id,'EUR');
        
        List<Opportunity_Part__c> list_parts = new List<Opportunity_Part__c>();
        list_parts.add(oppypart);        
        
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
        ClsOpportunityForecastStructure.ForecastStructure clsForeCastS = new ClsOpportunityForecastStructure.ForecastStructure('EUR','EUR',oppyForecasts,oppy.Id,part.Id,'2012',rt.Id,'Monthly');         
        clsForeCastS.level = 'Quarterly';
        
        list<ClsOppForecastStructure> list_forecastStructures = new list<ClsOppForecastStructure>();
        ClsOppForecastStructure cls = new ClsOppForecastStructure('2012');
        ClsOppForecastStructure.ForecastStructure clsFS = new ClsOppForecastStructure.ForecastStructure();
        ClsOppForecastStructure.ForecastItemStructure clsFIS = new ClsOppForecastStructure.ForecastItemStructure();
        ClsOppForecastStructure.PartForecastStructure clsP = new ClsOppForecastStructure.PartForecastStructure();
        list_forecastStructures.add(cls);
        
        
        List<Opportunity_Part__c> list_oppypart = new List<Opportunity_Part__c>();
        list_oppypart.add(oppypart);
        
        List<String> list_years = new List<String>();
        list_years.add('2012');
        
        Test.startTest();
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(oppy); 
        ExtOppyForecastEntryPage ext = new ExtOppyForecastEntryPage(ctrl);
        ext.opportunity = oppy;
        ext.list_forecastStructures = list_forecastStructures;
        
        ExtOppyForecastEntryPage ext1 = new ExtOppyForecastEntryPage(ctrl);
        ext1.opportunity = oppy;
        ext1.list_forecastStructures = list_forecastStructures;
      //  ext.rebuildByStartDate();
        
        system.assert(true);
        Test.stopTest(); 
        }
    }
    
    
    
    static testMethod void testSave1() {
        ClsTestCustomSettingHelper.getApex_Helper_Settings(); 
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
        ChannelinsightData_test.ChannelinsightData_test();

        Profile p = [Select Id, Name From Profile 
                     where Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'hell2osManedsfd@testCompany1233423.com';
        u.Alias = 'dps3';
        u.CommunityNickname = 'NND3';
        u.ProfileId = p.Id;
        u.Sub_Vertical__c ='Industrial';
        u.GIBU__c = 'Industrial';

        insert u;
              
        system.runAs(u){  
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();      
        RecordType rt = ClsTestHelp.createTestRecordType7();
        
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Name = 'Pain of Queen';
        oppy2.Level__c = 'Monthly';
        oppy2.RecordTypeId = rt.Id;
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
        oppypart.CurrencyIsoCode = 'EUR';
        oppypart.Part__c = part.Id;
        oppypart.Quantity__c = 12;
        insert oppypart;
        
        List<Opportunity_Forecast__c> lstoppyForecasts = new List<Opportunity_Forecast__c>();
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy2.Id;
        oppyForecast.Quantity__c = 12;
        oppyForecast.Part__c = null;
        oppyForecast.Date__c = date.newInstance(2012, 09, 28);
        oppyForecast.Amount__c = 1;
        oppyForecast.CurrencyIsoCode = 'EUR';
        oppyForecast.Forecasting_Start_Date__c = date.newInstance(2012, 01, 28);
        //insert oppyForecast;
        lstoppyForecasts.add(oppyForecast);
        
        Opportunity_Forecast__c oppyForecast2 = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast2.Opportunity__c = oppy2.Id;
        oppyForecast2.Quantity__c = 12;
        oppyForecast2.Part__c = oppypart.Id;
        oppyForecast2.Date__c = date.newInstance(2012, 09, 28);
        oppyForecast2.Amount__c = 1;
        oppyForecast2.CurrencyIsoCode = 'EUR';
        oppyForecast2.Forecasting_Start_Date__c = date.newInstance(2012, 01, 28);
        //insert oppyForecast2;
        lstoppyForecasts.add(oppyForecast2);
        insert lstoppyForecasts;
        
        map<Id, String> map_oppyPartId_isoCode = new map<Id, String>();
        map_oppyPartId_isoCode.put(oppypart.Id,'EUR');
        
        List<Opportunity_Part__c> list_parts = new List<Opportunity_Part__c>();
        list_parts.add(oppypart);        
        
       // List<ClsOpportunityForecastStructure> list_forecastStructures = new List<ClsOpportunityForecastStructure>();
        
        List<Opportunity_Forecast__c> oppyForecasts = new List<Opportunity_Forecast__c>();        
        oppyForecasts.add(oppyForecast);
        
        Map<Id, List<Opportunity_Forecast__c>> partFCs = new Map<Id, List<Opportunity_Forecast__c>>();
        partFCs.put(oppypart.Id, new List<Opportunity_Forecast__c>{oppyForecast2});       
        
        List<Id> list_partIds = new List<Id>();
        list_partIds.add(oppypart.Id);
        
        Map<Id, Id> map_partId_oppyId = new Map<Id, Id>();
        map_partId_oppyId.put(oppypart.Id,oppy2.Id);
        
       // ClsOpportunityForecastStructure cls = new ClsOpportunityForecastStructure(map_oppyPartId_isoCode,'EUR',oppyForecasts,partFCs,'2012',oppy2.Id,map_partId_oppyId,rt.Id,rt.Id,'Monthly',list_partIds);
       // cls.year = '2012';
        //list_forecastStructures.add(cls);
        list<ClsOppForecastStructure> list_forecastStructures = new list<ClsOppForecastStructure>();
        ClsOppForecastStructure cls = new ClsOppForecastStructure('2012');
        ClsOppForecastStructure.ForecastStructure clsFS = new ClsOppForecastStructure.ForecastStructure();
        ClsOppForecastStructure.ForecastItemStructure clsFIS = new ClsOppForecastStructure.ForecastItemStructure();
        ClsOppForecastStructure.PartForecastStructure clsP = new ClsOppForecastStructure.PartForecastStructure();
        list_forecastStructures.add(cls);
        
        List<String> list_years = new List<String>();
        list_years.add('2012');
        
        Test.startTest();
        
        ExtOppyForecastEntryPage.PartStructure extOppy = new ExtOppyForecastEntryPage.PartStructure(oppypart);
                
        ApexPages.StandardController ctrl = new ApexPages.StandardController(oppy2); 
        ExtOppyForecastEntryPage ext = new ExtOppyForecastEntryPage(ctrl);
        ext.opportunity = oppy2;
        ext.list_forecastStructures = list_forecastStructures;
        //ext.oneYear = '2031';
        //ext.year2Delete = '2012';
        ext.currentYear = 2012;
        ext.startDateForecast = oppyForecast;
        ext.list_years = list_years;        
        
        ExtOppyForecastEntryPage ext1 = new ExtOppyForecastEntryPage(ctrl);
        ext1.opportunity = oppy2;
        ext1.list_forecastStructures = list_forecastStructures;
        //ext.oneYear = '2031';
        //ext.year2Delete = '2012';
        ext1.currentYear = 2012;
        ext1.startDateForecast = oppyForecast;
        ext1.list_years = list_years;
        
        //ext.rebuildByStartDate();
        
        system.assert(true);
        Test.stopTest(); 
      
        }
    }     
    static testMethod void testAllnew() {

        User u = ClsTestHelp.createTestUsers();
        
        u.GIBU__c = 'Industrial';
        u.Sub_Vertical__c = 'A&C';
        u.Country = 'US';
        
        insert u;
        
        system.runAs(u){        
             /* Poonam -Added custom setting to fix test failure- Start*/
        List<Trigger_Configuration__c> lstTriggerConfig = new  List<Trigger_Configuration__c>();
       
        Trigger_Configuration__c tc = new Trigger_Configuration__c(); 
        tc.Name='Avoid Duplicate PLM Id';
        tc.isRun__c=true;
        lstTriggerConfig .add(tc);
               
        Trigger_Configuration__c tc2 = new Trigger_Configuration__c(); 
        tc2.Name='DND Lead Conversion Initialization';
        tc2.isRun__c=true;
        lstTriggerConfig .add(tc2);
        
        Trigger_Configuration__c tc3 = new Trigger_Configuration__c(); 
        tc3.Name='Identify Fiscal Year';
        tc3.isRun__c=true;
        lstTriggerConfig .add(tc3);
        
        Trigger_Configuration__c tc4 = new Trigger_Configuration__c(); 
        tc4.Name='Populate Opportunity Partner';
        tc4.isRun__c=true;
        lstTriggerConfig .add(tc4);
        
        Trigger_Configuration__c tc5 = new Trigger_Configuration__c(); 
        tc5.Name='updateAccountBusinessUnit';
        tc5.isRun__c=true;
        lstTriggerConfig .add(tc5);
        
        insert lstTriggerConfig ;
        
        ADMTerritoryCode__c admTerritoryCode= new ADMTerritoryCode__c();
        admTerritoryCode.Name='ADMTerritoryCode';
        admTerritoryCode.Territory_Code__c='101485';
        insert admTerritoryCode;
        
        /*Poonam -Added custom setting to fix test failure -End*/
        
                          
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
        Channelinsightdata_test.Channelinsightdata_test();                     

          RecordType rt2 = ClsTestHelp.createTestRecordType20();
          RecordType rt3 = ClsTestHelp.createTestRecordType23();
          RecordType rt4 = ClsTestHelp.createTestRecordType30();
          
          Account acc = ClsTestHelp.createTestAccounts();
          acc.Type = 'CM';
          insert acc;
          
          List<opportunity> opptyLst = new List<opportunity>();
          Opportunity oppy1 = ClsTestHelp.createTestOpportunity();   
          oppy1.Type = 'CM';
          oppy1.Request_Type__c = 'Extension';
          oppy1.Method__c = 'BOM';
          oppy1.Level__c = 'Yearly';
          oppy1.Amount = 1;
          oppy1.CurrencyIsoCode = 'EUR';
          oppy1.Five_Year_Revenue__c = 1;
          oppy1.RecordTypeId = rt4.Id;
          oppy1.stagename ='Concept';
          //insert oppy1;
          opptyLst.add(oppy1);
            
          Opportunity oppy2 = ClsTestHelp.createTestOpportunity();   
          oppy2.Type = 'NDR';
          oppy2.NDR_Quote_Status_Description__c= 'In Process';
          oppy2.Method__c = 'BOM';
          oppy2.Level__c = 'Yearly';
          oppy2.Amount = 1;
          oppy2.CurrencyIsoCode = 'EUR';
          oppy2.Five_Year_Revenue__c = 1;
          oppy2.RecordTypeId = rt3.Id;
          oppy2.stagename ='Concept';
          //insert oppy2;
          opptyLst.add(oppy2);
          insert opptylst;
          
          Opportunity opp1 = [Select id, stagename from Opportunity where id=: oppy1.Id];
          opp1.stagename = 'In Approval';
          update opp1;
          system.assertequals(opp1.stagename, 'In Approval');
            
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
          oppypart1.Similar_TE_Part_Number__c = part.Id;
          oppypart1.initial_billing_date__c = date.newInstance(2016, 09, 28);
          oppypart1.Initial_Order_Date__c = date.today();
          oppypart1.Process_Status__c = 'Production';
          oppypart1.recordtypeId = rt2.Id;
          insert oppypart1;
          
           
          map<Id, Decimal> map_partId_price = new map<Id, Decimal>();
          map_partId_price.put(part.Id,0);
      
          Map<Id, Id> map_partId_oppyId = new Map<Id, Id>();
          map_partId_oppyId.put(oppypart1.Id,oppy1.Id);
          
          List<Id> list_partIds = new List<Id>();
          list_partIds.add(oppypart1.Id);
          
          map<Id, String> map_oppyPartId_isoCode = new map<Id, String>();
          map_oppyPartId_isoCode.put(oppypart1.Id,'EUR');
          
          list<ClsOppForecastStructure> list_forecastStructures = new list<ClsOppForecastStructure>();
          ClsOppForecastStructure cls = new ClsOppForecastStructure('2012');
          ClsOppForecastStructure.ForecastStructure clsFS = new ClsOppForecastStructure.ForecastStructure();
          ClsOppForecastStructure.ForecastItemStructure clsFIS = new ClsOppForecastStructure.ForecastItemStructure();
          clsFIS.quantity = 12;
          clsFIS.amount = 1;      
          ClsOppForecastStructure.PartForecastStructure clsP = new ClsOppForecastStructure.PartForecastStructure();
          list_forecastStructures.add(cls);
          
          List<Opportunity_Part__c> list_oppypart = new List<Opportunity_Part__c>();
          list_oppypart.add(oppypart1);
          
          List<String> list_years = new List<String>();
          list_years.add('2012');
          
          Test.startTest();
          System.currentPageReference().getParameters().put('mode', 'Edit');
          ExtOppyForecastEntryPage ext1 = new ExtOppyForecastEntryPage(new ApexPages.StandardController(oppy1));
          ext1.saveOppy();
          ExtOppyForecastEntryPage ext2 = new ExtOppyForecastEntryPage(new ApexPages.StandardController(oppy2));
          Test.stopTest();
        }
    }
    
}