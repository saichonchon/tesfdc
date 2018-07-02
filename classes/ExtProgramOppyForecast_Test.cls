/**
*   This test class is for ExtProgramOppyForecast.
*
@author Di Chen
@created 2012-03-14
@version 1.0
@since 20.0
*
@changelog
* 2012-03-14 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 85%
*/
@isTest
private class ExtProgramOppyForecast_Test {
  
    static testMethod void testExt() {
        User u =  [Select Id, Name,Email , country,GIBU__c,Sub_Vertical__c,PMV_Type_Initialization__c  From User 
                 where GIBU__c='Industrial' and Sub_Vertical__c='Industrial' and country != 'China' and PMV_Type_Initialization__c = 'Standard' and isactive=true 
                  limit 1];
        
        system.runAs(u){
            ClsTestCustomSettingHelper.getApex_Helper_Settings();
            ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
            ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
            ClsTestCustomSettingHelper.getOpportunity_Approvers();
            ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
            ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
                    
            List<Trigger_Configuration__c> lstTC = new List<Trigger_Configuration__c>();
            Trigger_Configuration__c tc = new Trigger_Configuration__c();
            tc.Name = 'Identify Fiscal Year';
            tc.isRun__c = true;
            lstTC.add(tc);
            
            Trigger_Configuration__c tc1 = new Trigger_Configuration__c();
            tc1.Name = 'Populate Opportunity Partner';
            tc1.isRun__c = true;
            lstTC.add(tc1);
            
            Trigger_Configuration__c tc2 = new Trigger_Configuration__c();
            tc2.Name = 'updateAccountBusinessUnit';
            tc2.isRun__c = true;
            lstTC.add(tc2);
            insert lstTC;
                    
            RecordType rt = ClsTestHelp.createTestRecordType();
            RecordType rt2 = ClsTestHelp.createTestRecordType16();
            
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            insert acc;
            
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.CurrencyIsoCode = 'USD';
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
            //oppy.StageName = 'Mass-prod';
//            oppy.Mass_prod_Status__c = False;
            oppy.CurrencyIsoCode = 'EUR';
            oppy.Five_Year_Revenue__c = 1;
            oppy.RecordTypeId = rt2.Id;
            //oppy.Probability = 0;
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
            
            List<Opportunity_Part__c> list_parts = new List<Opportunity_Part__c>();
            list_parts.add(oppypart);
            
            List<Opportunity> list_oppys = new List<Opportunity>();
            list_oppys.add(oppy);
            
            ExtProgramOppyForecast.OppyForecastStructure extOppy = new ExtProgramOppyForecast.OppyForecastStructure(oppy);
            extOppy.oppy = oppy;
            
            
            Test.startTest();
           
            ApexPages.StandardController ctrl = new ApexPages.StandardController(oppy2); 
            ExtProgramOppyForecast ext = new ExtProgramOppyForecast(ctrl);
            ApexPages.currentPage().getParameters().put('isSaved','true');
            ext.list_oppys = list_oppys;
            ext.list_parts = list_parts;
            ext.opportunity = oppy;
            ext.isProgramLevelForecasting = true;
            
            ext.getYears();
            ext.getTotalRevenues();
            ext.getOppyForecastStructures();
            ext.editProgram();  
            ext.deterRedirect();
            system.assert(true);
            Test.stopTest();
        }
    }
    static testMethod void testExt2() {
        User u =  [Select Id, Name,Email , country,GIBU__c,Sub_Vertical__c,PMV_Type_Initialization__c  From User 
                 where GIBU__c='Industrial' and Sub_Vertical__c='Industrial' and country != 'China' and PMV_Type_Initialization__c = 'Standard' and isactive=true 
                  limit 1];
        
        system.runAs(u){
            ClsTestCustomSettingHelper.getApex_Helper_Settings();
            ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
            ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
            ClsTestCustomSettingHelper.getOpportunity_Approvers();
            ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
            ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
            
            List<Trigger_Configuration__c> lstTC = new List<Trigger_Configuration__c>();
            Trigger_Configuration__c tc = new Trigger_Configuration__c();
            tc.Name = 'Identify Fiscal Year';
            tc.isRun__c = true;
            lstTC.add(tc);
            
            Trigger_Configuration__c tc1 = new Trigger_Configuration__c();
            tc1.Name = 'Populate Opportunity Partner';
            tc1.isRun__c = true;
            lstTC.add(tc1);
            
            Trigger_Configuration__c tc2 = new Trigger_Configuration__c();
            tc2.Name = 'updateAccountBusinessUnit';
            tc2.isRun__c = true;
            lstTC.add(tc2);
            insert lstTC;
                    
            RecordType rt = ClsTestHelp.createTestRecordType();
            RecordType rt2 = ClsTestHelp.createTestRecordType16();
            
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            insert acc;
      
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.CurrencyIsoCode = 'USD';
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
            oppy.CurrencyIsoCode = 'USD';
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
            oppyForecast.Part__c = null;
            oppyForecast.Date__c = date.newInstance(2012, 09, 28);
            oppyForecast.Amount__c = 1;
            insert oppyForecast;
            
            
            List<Opportunity_Part__c> list_parts = new List<Opportunity_Part__c>();
            list_parts.add(oppypart);
            
            List<Opportunity> list_oppys = new List<Opportunity>();
            list_oppys.add(oppy);
            
            ExtProgramOppyForecast.OppyForecastStructure extOppy = new ExtProgramOppyForecast.OppyForecastStructure(oppy);
            extOppy.oppy = oppy;
            
            
            Test.startTest();
            
            ApexPages.StandardController ctrl = new ApexPages.StandardController(oppy2); 
            ExtProgramOppyForecast ext = new ExtProgramOppyForecast(ctrl);
            ext.list_oppys = list_oppys;
            ext.list_parts = list_parts;
            ext.opportunity = oppy;
            ext.isProgramLevelForecasting = false;
            
            ext.getTotalRevenues();

            system.assert(true);
            Test.stopTest();
        }
    }  
    static testMethod void testExt3() {
        User u =  [Select Id, Name,Email , country,GIBU__c,Sub_Vertical__c,PMV_Type_Initialization__c  From User 
                 where GIBU__c='Industrial' and Sub_Vertical__c='Industrial' and country != 'China' and PMV_Type_Initialization__c = 'Standard' and isactive=true 
                  limit 1];
        
        system.runAs(u){
            ClsTestCustomSettingHelper.getApex_Helper_Settings();
            ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
            ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
            ClsTestCustomSettingHelper.getOpportunity_Approvers();
            ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
            ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
            
            List<Trigger_Configuration__c> lstTC = new List<Trigger_Configuration__c>();
            Trigger_Configuration__c tc = new Trigger_Configuration__c();
            tc.Name = 'Identify Fiscal Year';
            tc.isRun__c = true;
            lstTC.add(tc);
            
            Trigger_Configuration__c tc1 = new Trigger_Configuration__c();
            tc1.Name = 'Populate Opportunity Partner';
            tc1.isRun__c = true;
            lstTC.add(tc1);
            
            Trigger_Configuration__c tc2 = new Trigger_Configuration__c();
            tc2.Name = 'updateAccountBusinessUnit';
            tc2.isRun__c = true;
            lstTC.add(tc2);
            insert lstTC;
                    
            RecordType rt = ClsTestHelp.createTestRecordType();
            RecordType rt2 = ClsTestHelp.createTestRecordType16();
            
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            insert acc;
      
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.CurrencyIsoCode = 'USD';
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
            oppy.CurrencyIsoCode = 'USD';
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
            oppyForecast.Part__c = null;
            oppyForecast.Date__c = date.newInstance(2012, 09, 28);
            oppyForecast.Amount__c = 1;
            insert oppyForecast;
            
            List<Opportunity_Part__c> list_parts = new List<Opportunity_Part__c>();
            list_parts.add(oppypart);
            
            List<Opportunity> list_oppys = new List<Opportunity>();
            list_oppys.add(oppy);
            
            ExtProgramOppyForecast.OppyForecastStructure extOppy = new ExtProgramOppyForecast.OppyForecastStructure(oppy);
            extOppy.oppy = oppy;
            
            
            Map<Id, Opportunity> map_id_opportunity = new Map<Id, Opportunity>();
            map_id_opportunity.put(oppy.Id,oppy);
            
            List<Opportunity_Forecast__c> forecasts = new List<Opportunity_Forecast__c>();
            forecasts.add(oppyForecast);
            
            ExtProgramOppyForecast.OppyForecastStructureItem extItem = new ExtProgramOppyForecast.OppyForecastStructureItem(oppy.Id,'USD',map_id_opportunity,'2012',forecasts);
            
            
            Test.startTest();
            
            ApexPages.StandardController ctrl = new ApexPages.StandardController(oppy); 
            ExtProgramOppyForecast ext = new ExtProgramOppyForecast(ctrl);
            ext.list_oppys = list_oppys;
            ext.list_parts = list_parts;
            ext.opportunity = oppy;
            ext.isProgramLevelForecasting = false;
            
            ext.getTotalRevenues();
            ext.getOppyForecastStructures();
            
            system.assert(true);
            Test.stopTest();
        }
    }
 
     static testMethod void testExt4() {
        User u =  [Select Id, Name,Email , country,GIBU__c,Sub_Vertical__c,PMV_Type_Initialization__c  From User 
                 where GIBU__c='Industrial' and Sub_Vertical__c='Industrial' and country != 'China' and PMV_Type_Initialization__c = 'Standard' and isactive=true 
                  limit 1];
        
        system.runAs(u){
            ClsTestCustomSettingHelper.getApex_Helper_Settings();
            ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
            ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
            ClsTestCustomSettingHelper.getOpportunity_Approvers();
            ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
            ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
            
            List<Trigger_Configuration__c> lstTC = new List<Trigger_Configuration__c>();
            Trigger_Configuration__c tc = new Trigger_Configuration__c();
            tc.Name = 'Identify Fiscal Year';
            tc.isRun__c = true;
            lstTC.add(tc);
            
            Trigger_Configuration__c tc1 = new Trigger_Configuration__c();
            tc1.Name = 'Populate Opportunity Partner';
            tc1.isRun__c = true;
            lstTC.add(tc1);
            
            Trigger_Configuration__c tc2 = new Trigger_Configuration__c();
            tc2.Name = 'updateAccountBusinessUnit';
            tc2.isRun__c = true;
            lstTC.add(tc2);
            insert lstTC;
                    
            RecordType rt = ClsTestHelp.createTestRecordType();
            RecordType rt2 = ClsTestHelp.createTestRecordType16();
            
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            insert acc;
      
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.CurrencyIsoCode = 'USD';
            oppy2.Request_Type__c = 'Extension';
            oppy2.RecordTypeId = rt2.Id;
            oppy2.StageName = 'In Approval';
            insert oppy2;  
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Program__c = oppy2.Id;   
            oppy.Type = 'CM';
            oppy.Request_Type__c = 'Extension';
            oppy.Method__c = 'BOM';
            oppy.Level__c = 'Yearly';
            oppy.Amount = 1;
            oppy.CurrencyIsoCode = 'USD';
            oppy.Five_Year_Revenue__c = 1;
            oppy.RecordTypeId = rt2.Id;
            oppy.StageName = 'In Approval';
            insert oppy;
            system.assertequals(oppy.Program__c,oppy2.Id);
            system.assertequals(oppy2.StageName,'In Approval');
            
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
            oppyForecast.Amount__c = 1;
            oppyForecast.Fiscal_Year__c = '2012';
            //oppyForecast.CurrencyIsoCode = 'EUR';
            insert oppyForecast;
            
            Test.startTest();
            
            ApexPages.StandardController ctrl = new ApexPages.StandardController(oppy2); 
            ExtProgramOppyForecast ext = new ExtProgramOppyForecast(ctrl);

            system.assert(true);
            Test.stopTest();
        }
    }   
    
     static testMethod void testExt5() {
        User u =  [Select Id, Name,Email , country,GIBU__c,Sub_Vertical__c,PMV_Type_Initialization__c  From User 
                 where GIBU__c='Industrial' and Sub_Vertical__c='Industrial' and country != 'China' and PMV_Type_Initialization__c = 'Standard' and isactive=true 
                  limit 1];
        
        system.runAs(u){
            ClsTestCustomSettingHelper.getApex_Helper_Settings();
            ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
            ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
            ClsTestCustomSettingHelper.getOpportunity_Approvers();
            ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
            ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
            
            List<Trigger_Configuration__c> lstTC = new List<Trigger_Configuration__c>();
            Trigger_Configuration__c tc = new Trigger_Configuration__c();
            tc.Name = 'Identify Fiscal Year';
            tc.isRun__c = true;
            lstTC.add(tc);
            
            Trigger_Configuration__c tc1 = new Trigger_Configuration__c();
            tc1.Name = 'Populate Opportunity Partner';
            tc1.isRun__c = true;
            lstTC.add(tc1);
            
            Trigger_Configuration__c tc2 = new Trigger_Configuration__c();
            tc2.Name = 'updateAccountBusinessUnit';
            tc2.isRun__c = true;
            lstTC.add(tc2);
            insert lstTC;
                    
            RecordType rt = ClsTestHelp.createTestRecordType();
            RecordType rt2 = ClsTestHelp.createTestRecordType16();
            
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            insert acc;
      
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.CurrencyIsoCode = 'USD';
            oppy2.Request_Type__c = 'Extension';
            oppy2.RecordTypeId = rt2.Id;
            oppy2.StageName = 'Rejected - Closed';
            insert oppy2;  
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Program__c = oppy2.Id;   
            oppy.Type = 'CM';
            oppy.Request_Type__c = 'Extension';
            oppy.Method__c = 'BOM';
            oppy.Level__c = 'Yearly';
            oppy.Amount = 1;
            oppy.CurrencyIsoCode = 'USD';
            oppy.Five_Year_Revenue__c = 1;
            oppy.RecordTypeId = rt2.Id;
            oppy.StageName = 'Rejected - Closed';
            insert oppy;
            system.assertequals(oppy.Program__c,oppy2.Id);
            system.assertequals(oppy2.StageName,'Rejected - Closed');
            
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
            oppyForecast.Amount__c = 1;
            oppyForecast.Fiscal_Year__c = '2012';
            //oppyForecast.CurrencyIsoCode = 'EUR';
            insert oppyForecast;
            
            Test.startTest();
            
            ApexPages.StandardController ctrl = new ApexPages.StandardController(oppy2); 
            ExtProgramOppyForecast ext = new ExtProgramOppyForecast(ctrl);

            system.assert(true);
            Test.stopTest();
        }
    }
        
}