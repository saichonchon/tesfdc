/**
*   This test class is for ExtOppyForecastEntryPageAPL.
*
@author Di Chen
@created 2012-03-14
@version 1.0
@since 20.0.
*
@changelog
* 2012-03-14 Di Chen <di.chen@itbconsult.com>
* 2014-09-01 Padmaja D <padmaja.dadi@te.com>
* - Created
* - Test coverage 82%
* 2016-10-28 Mrunal Parate
* - Changed
* - Test coverage 85%
*/
@isTest(SeeAllData=false)
private class ExtOppyForecastEntryPageAPL_Test {
     
    static testMethod void testAll() {
         
        User u = ClsTestHelp.createTestUsers();

        u.GIBU__c = 'Industrial';
        u.Sub_Vertical__c = 'A&C';
        u.Country = 'US';
        
        insert u;

        system.runAs(u){         
          
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
        Channelinsightdata_test.Channelinsightdata_test();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
          
        /*Profile p = [Select Id, Name From Profile 
                     where Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
        User user = [select id from user where GIBU__c = 'Industrial' and  Sub_Vertical__c = 'A&C' and isactive = true limit 1]; */



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
      oppy2.Probability = 0;
      //insert oppy2;  
        
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
      //insert oppy;
      insert new List<Opportunity>{oppy, oppy2};      
      
      oppy.Program__c = oppy2.Id;
      update oppy;
      
      Product_Hierarchy__c ph = new Product_Hierarchy__c();
      ph.Hierarchy_Level_Type__c = 'CBC1';
      ph.Description__c = 'Industrial'; 
      insert ph;
      
      Part__c part = new Part__c();
      part.Description__c = 'Sniper';
      part.Product_Hierarchy__c = ph.Id;
      insert part;
      
      //OpportunityPartTriggerHandler.isRecursive = false;
      
      Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
      oppypart.Opportunity__c = oppy.Id;
      oppypart.Part__c = part.Id;
      oppypart.Similar_TE_Part_Number__c = part.Id;
      oppypart.initial_billing_date__c = date.today();
      oppypart.Initial_Order_Date__c = date.today();
      oppypart.Process_Status__c = 'Production';
      insert oppypart;
      
      Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
      oppyForecast.Opportunity__c = oppy.Id;
      oppyForecast.Quantity__c = 12;
      oppyForecast.Part__c = oppypart.Id;
      oppyForecast.Date__c = date.today();
      oppyForecast.Amount__c = 1;
      //insert oppyForecast;
      
      Opportunity_Forecast__c oppyForecast2 = ClsTestHelp.createTestOpportunityForecasts();
      oppyForecast2.Opportunity__c = oppy.Id;
      oppyForecast2.Quantity__c = 12;
      oppyForecast2.Part__c = oppypart.Id;
      oppyForecast2.Date__c = date.today();
      oppyForecast2.Amount__c = 1;
      
      Opportunity_Forecast__c oppyForecast3 = ClsTestHelp.createTestOpportunityForecasts();
      oppyForecast3.Opportunity__c = oppy.Id;
      oppyForecast3.Quantity__c = 12;        
      oppyForecast3.Date__c = date.today();
      oppyForecast3.Amount__c = 1;
      insert new List<Opportunity_Forecast__c>{oppyForecast, oppyForecast2, oppyForecast3};
        
      map<Id, Decimal> map_partId_price = new map<Id, Decimal>();
      map_partId_price.put(part.Id,0);
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
      
      ExtOppyForecastEntryPageAPL.PartStructure extPart = new ExtOppyForecastEntryPageAPL.PartStructure(oppypart);      

      Test.startTest();
      
      ApexPages.StandardController ctrl = new ApexPages.StandardController(oppy2); 
      ExtOppyForecastEntryPageAPL ext = new ExtOppyForecastEntryPageAPL(ctrl);
      ExtOppyForecastEntryPageAPL.buildOppyForeCastMap(oppy.Id);
      ext.isAPL = true;
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
      ext.saveString = 'Completed';
      ext.saveProgram();
      ext.saveOppy();
      ext.cancelToProgram();
      ext.editOppy(); 
      ext.cancelToOppy();
      ext.buildStructures(map_oppyForeCasts,map_year_map_partId_oppyForecast,map_partId_oppyId,map_oppyPartId_isoCode,oppy,list_years,list_partIds,map_partId_price );
      ext.editPrograms();
      ext.getConfidenceItem();
      system.debug('@@ IsAPL : ' + ext.isAPL);
      ext.getProcessStatusItems();
      ext.getOppyPartDefaultConfidenceAndProcessStatus();
      
      ext.reActiveForecast();
      ExtOppyForecastEntryPageAPL.ForecastHistoryStructure ForecastHistoryStructure = new ExtOppyForecastEntryPageAPL.ForecastHistoryStructure('test',10.00,11.00);
      
      ExtOppyForecastEntryPageAPL ext1 = new ExtOppyForecastEntryPageAPL(new ApexPages.StandardController(oppy));

      ext1.opportunity = oppy;
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
      ext1.saveProgram();
      //ext1.saveOppy();
      ext1.cancelToProgram();
      ext1.editOppy(); 
      ext1.cancelToOppy();
      ext1.buildStructures(map_oppyForeCasts,map_year_map_partId_oppyForecast,map_partId_oppyId,map_oppyPartId_isoCode,oppy,list_years,list_partIds,map_partId_price );
      ext1.editPrograms();
      ext1.getConfidenceItem();
      
      Test.stopTest();
        }
    }
  static testMethod void testAll1() {

        User u = ClsTestHelp.createTestUsers();
        
        u.GIBU__c = 'Industrial';
        u.Sub_Vertical__c = 'A&C';
        u.Country = 'US';
        
        insert u;
        
        system.runAs(u){        
      /*  Trigger_Configuration__c trgval = new Trigger_Configuration__c();
        trgval.name = 'Populate Opportunity Partner';
        trgval.isRun__c = true;
        insert trgval;*/
         ClsTestCustomSettingHelper.getTriggerConfigurationSettings();                  
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
        Channelinsightdata_test.Channelinsightdata_test();               

          RecordType rt = ClsTestHelp.createTestRecordType();
          RecordType rt2 = ClsTestHelp.createTestRecordType16();
          RecordType rt3 = ClsTestHelp.createTestRecordType11();
          
          Account acc = ClsTestHelp.createTestAccounts();
          acc.Type = 'CM';
          insert acc;
            
          List<Opportunity> oppylst = new List<Opportunity>();
          Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
          oppy2.Program_level_Forecasting__c =true; 
          oppy2.Name = 'Pain of Queen';
          oppy2.Type = 'CM';
          oppy2.Request_Type__c = 'Extension';
          oppy2.RecordTypeId = rt2.Id;
          oppy2.Probability = 0;  
          oppylst.add(oppy2);
            
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
          oppylst.add(oppy);
          
          Opportunity oppy1 = ClsTestHelp.createTestOpportunity();   
          oppy1.Type = 'CM';
          oppy1.Request_Type__c = 'Extension';
          oppy1.Method__c = 'BOM';
          oppy1.Level__c = 'Yearly';
          oppy1.Amount = 1;
          oppy1.CurrencyIsoCode = 'EUR';
          oppy1.Five_Year_Revenue__c = 1;
          oppy1.RecordTypeId = rt3.Id;
          oppy1.stagename ='Approved/Active';
          oppylst.add(oppy1);
          insert oppylst;
          
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

          List<Opportunity_Part__c> opartlst = new List<Opportunity_Part__c>();
          Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
          oppypart.Opportunity__c = oppy.Id;
          oppypart.Part__c = part.Id;
          oppypart.Similar_TE_Part_Number__c = part.Id;
          oppypart.initial_billing_date__c = date.today();
          oppypart.Initial_Order_Date__c = date.today();
          oppypart.Process_Status__c = 'Production';
          opartlst.add(oppypart);
          
          Opportunity_Part__c oppypart1 = ClsTestHelp.createTestOpportunityPart();
          oppypart1.Opportunity__c = oppy1.Id;
          oppypart1.Part__c = part.Id;
          oppypart1.Similar_TE_Part_Number__c = part.Id;
          oppypart1.initial_billing_date__c = date.today();
          oppypart1.Initial_Order_Date__c = date.today();
          oppypart1.Process_Status__c = 'Production';
          opartlst.add(oppypart1);
          insert opartlst;
            
          map<Id, Decimal> map_partId_price = new map<Id, Decimal>();
          map_partId_price.put(part.Id,0);
      
          Map<Id, Id> map_partId_oppyId = new Map<Id, Id>();
          map_partId_oppyId.put(oppypart.Id,oppy.Id);
          
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
          
          List<String> list_years = new List<String>();
          list_years.add('2012');
          
          Test.startTest();
          ApexPages.StandardController ctrl = new ApexPages.StandardController(oppy2); 
          ExtOppyForecastEntryPageAPL ext = new ExtOppyForecastEntryPageAPL(ctrl);
          ExtOppyForecastEntryPageAPL ext1 = new ExtOppyForecastEntryPageAPL(new ApexPages.StandardController(oppy1));
          Test.stopTest();
        }
    }
    static testMethod void testAll2() {

        User u = ClsTestHelp.createTestUsers();
        
        u.GIBU__c = 'Industrial';
        u.Sub_Vertical__c = 'A&C';
        u.Country = 'US';
        
        insert u;
        
        system.runAs(u){        
      /*  Trigger_Configuration__c trgval = new Trigger_Configuration__c();
        trgval.name = 'Populate Opportunity Partner';
        trgval.isRun__c = true;
        insert trgval;*/
                          
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
        Channelinsightdata_test.Channelinsightdata_test();                     

          RecordType rt2 = ClsTestHelp.createTestRecordType20();
          RecordType rt3 = ClsTestHelp.createTestRecordType11();
          
          Account acc = ClsTestHelp.createTestAccounts();
          acc.Type = 'CM';
          insert acc;
          
          Opportunity oppy1 = ClsTestHelp.createTestOpportunity();   
          oppy1.Type = 'CM';
          oppy1.Request_Type__c = 'Extension';
          oppy1.Method__c = 'BOM';
          oppy1.Level__c = 'Yearly';
          oppy1.Amount = 1;
          oppy1.CurrencyIsoCode = 'EUR';
          oppy1.Five_Year_Revenue__c = 1;
          oppy1.RecordTypeId = rt3.Id;
          oppy1.stagename ='Approved/Active';
          insert oppy1;

          
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
          ExtOppyForecastEntryPageAPL ext1 = new ExtOppyForecastEntryPageAPL(new ApexPages.StandardController(oppy1));
          ext1.saveOppy();
          Test.stopTest();
        }
    }
}