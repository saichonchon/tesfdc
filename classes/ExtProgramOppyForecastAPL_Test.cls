/**
*   This test class is for ExtProgramOppyForecastAPL.
*
@author Di Chen
@created 2012-03-14
@version 1.0
	@since 20.0.
*
@changelog
* 2012-03-14 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 85%

@changelog
* 2014-09-01 Padmaja D <padmaja.dadi@te.com>
* - Created
* - Test coverage 85%
*/
@isTest(SeeAllData=true)
private class ExtProgramOppyForecastAPL_Test {
  
    static testMethod void testExt() {
       Profile p = [Select Id, Name From Profile 
                                    where Name = 'Production Support' 
                                    or Name = 'Service Account' 
                                    or Name ='System Administrator' 
                                    or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        
        
        u.Email = 'helloSand@testCompany1233423.com';
        u.Alias = 'dpse';
        u.CommunityNickname = 'TMD';
        u.ProfileId = p.Id;
        u.Username = u.Email;
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
            oppy2.StageName = 'Mass-prod';
//            oppy2.Mass_prod_Status__c = False;
            oppy2.Probability = 0;
            insert oppy2;  
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Program__c = oppy2.Id;   
            oppy.Type = 'CM';
            oppy.Request_Type__c = 'Extension';
            oppy.Method__c = 'BOM';
            oppy.Level__c = 'Yearly';
            oppy.Amount = 1;
            oppy.StageName = 'Mass-prod';
//            oppy.Mass_prod_Status__c = False;
            oppy.CurrencyIsoCode = 'EUR';
            oppy.Five_Year_Revenue__c = 1;
            oppy.RecordTypeId = rt2.Id;
            oppy.Probability = 0;
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
            
            ExtProgramOppyForecastAPL.OppyForecastStructure extOppy = new ExtProgramOppyForecastAPL.OppyForecastStructure(oppy);
            extOppy.oppy = oppy;
            
            
            Test.startTest();
            
            ApexPages.StandardController ctrl = new ApexPages.StandardController(oppy2); 
            ExtProgramOppyForecastAPL ext = new ExtProgramOppyForecastAPL(ctrl);
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
       Profile p = [Select Id, Name From Profile 
                                    where Name = 'Production Support' 
                                    or Name = 'Service Account' 
                                    or Name ='System Administrator' 
                                    or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'helloking@testCompany1233423.com';
        u.Alias = 'dpse';
        u.CommunityNickname = 'TMD';
        u.ProfileId = p.Id;
        u.Username = u.Email;
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
            
            ExtProgramOppyForecastAPL.OppyForecastStructure extOppy = new ExtProgramOppyForecastAPL.OppyForecastStructure(oppy);
            extOppy.oppy = oppy;
            
            
            Test.startTest();
            
            ApexPages.StandardController ctrl = new ApexPages.StandardController(oppy2); 
            ExtProgramOppyForecastAPL ext = new ExtProgramOppyForecastAPL(ctrl);
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
       Profile p = [Select Id, Name From Profile 
                                    where Name = 'Production Support' 
                                    or Name = 'Service Account' 
                                    or Name ='System Administrator' 
                                    or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'helloSoul@testCompany1233423.com';
        u.Alias = 'dpse';
        u.CommunityNickname = 'TMD';
        u.ProfileId = p.Id;
        u.Username = u.Email;
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
            
            ExtProgramOppyForecastAPL.OppyForecastStructure extOppy = new ExtProgramOppyForecastAPL.OppyForecastStructure(oppy);
            extOppy.oppy = oppy;
            
            
            Map<Id, Opportunity> map_id_opportunity = new Map<Id, Opportunity>();
            map_id_opportunity.put(oppy.Id,oppy);
            
            List<Opportunity_Forecast__c> forecasts = new List<Opportunity_Forecast__c>();
            forecasts.add(oppyForecast);
            
            ExtProgramOppyForecastAPL.OppyForecastStructureItem extItem = new ExtProgramOppyForecastAPL.OppyForecastStructureItem(oppy.Id,'USD',map_id_opportunity,'2012',forecasts);
            
            
            Test.startTest();
            
            ApexPages.StandardController ctrl = new ApexPages.StandardController(oppy); 
            ExtProgramOppyForecastAPL ext = new ExtProgramOppyForecastAPL(ctrl);
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
    
}