/**
*	This test class is for ClsOpportunityForecastStructure.
*
@author Di Chen
@created 2012-02-23
@version 1.0
@since 20.0
*
@changelog
* 2012-02-23 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 90%
*/
@isTest
private class ClsOpportunityForecastStructure_Test {

    static testMethod void testConstrustor() {
		Profile p = [Select Id, Name From Profile 
                     where Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
		User u = ClsTestHelp.createTestUsers();
		u.Email = 'hellosManedsfd@testCompany1233423.com';
		u.Alias = 'dpses';
		u.CommunityNickname = 'NNND';
		u.ProfileId = p.Id;
		insert u;
		      
		system.runAs(u){     			
		RecordType rt = ClsTestHelp.createTestRecordType();
 
		Account acc = ClsTestHelp.createTestAccounts();
		acc.Type = 'CM';
		insert acc;
 
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        insert oppy2;  
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        //oppy.Program__c = oppy2.Id;   
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
    	oppyForecast.Quantity__c = 0;
    	oppyForecast.Part__c = oppypart.Id;
    	oppyForecast.Date__c = date.newInstance(2012, 09, 28);
    	oppyForecast.Amount__c = 1;
    	insert oppyForecast;
    	
    	map<Id, String> map_oppyPartId_isoCode = new map<Id, String>();
    	map_oppyPartId_isoCode.put(oppypart.Id,'EUR');
    	
    	List<Opportunity_Forecast__c> oppyForecasts = new List<Opportunity_Forecast__c>();
    	oppyForecasts.add(oppyForecast);
    	
    	Map<Id, List<Opportunity_Forecast__c>> partFCs = new Map<Id, List<Opportunity_Forecast__c>>();
    	partFCs.put(part.Id,oppyForecasts);
    	
    	Map<Id, Id> map_partId_oppyId = new Map<Id, Id>();
    	map_partId_oppyId.put(part.Id,oppy.Id);
    	
    	List<Id> list_partIds = new List<Id>();
    	list_partIds.add(part.Id);
    	
        Test.startTest();
        
        ClsOpportunityForecastStructure cls = new ClsOpportunityForecastStructure(map_oppyPartId_isoCode,'EUR',oppyForecasts,partFCs,'2012',oppy.Id,map_partId_oppyId,rt.Id,rt.Id,'Monthly',list_partIds);
        
        ClsOpportunityForecastStructure.ForecastStructure clsForeCastS = new ClsOpportunityForecastStructure.ForecastStructure('EUR','EUR',oppyForecasts,oppy.Id,part.Id,'2012',rt.Id,'Monthly');         
        clsForeCastS.level = 'Monthly';
        clsForeCastS.getEditForecasts();
        clsForeCastS.getSalesPriceOF();
        
        map<String, Opportunity_Forecast__c> map_ofcs = new map<String, Opportunity_Forecast__c>();
        map_ofcs.put('1',oppyForecast);
        clsForeCastS.buildFCStructure(oppyForecasts, map_ofcs, 'Yearly');
        clsForeCastS.buildFCStructure(oppyForecasts, map_ofcs, 'Quarterly');
        
        List<ClsOpportunityForecastStructure.ForecastItemStructure> list_fcs = new List<ClsOpportunityForecastStructure.ForecastItemStructure>();
        ClsOpportunityForecastStructure.ForecastItemStructure clsOppyItem = new ClsOpportunityForecastStructure.ForecastItemStructure('Monthly',oppypart.Id,oppy.Id,rt.Id);
        clsOppyItem.forecast = oppyForecast;
        clsOppyItem.level = 'Monthly';
        clsOppyItem.type = 'Part';
        clsOppyItem.label = 'FM12 Sep';
        list_fcs.add(clsOppyItem);
        
        clsForeCastS.buildQuarterStructure(oppyForecasts, map_ofcs, list_fcs);
 		List<ClsOpportunityForecastStructure.ForecastItemStructure> list_fcsS = new List<ClsOpportunityForecastStructure.ForecastItemStructure>();
       // clsForeCastS.calYearStructure(list_fcsS);
       // clsForeCastS.calQuarterForecastByMonth(list_fcsS);
        clsForeCastS.calQuarterForecastByYear(clsOppyItem);
        clsForeCastS.calMonthForecastByYear(clsOppyItem);
        system.assert(true);
        Test.stopTest();
		}
    }
	static testMethod void testConstrustor2() {
    	Profile p = [Select Id, Name From Profile 
                     where Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
		User u = ClsTestHelp.createTestUsers();
		u.Email = 'hellosManedsfd@testCompany1233423.com';
		u.Alias = 'dpses';
		u.CommunityNickname = 'NNND';
		u.ProfileId = p.Id;
		insert u;
		      
		system.runAs(u){ 		
		RecordType rt = ClsTestHelp.createTestRecordType();

		Account acc = ClsTestHelp.createTestAccounts();
		acc.Type = 'CM';
		insert acc;
 
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        insert oppy2;  
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        //oppy.Program__c = oppy2.Id;   
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
    	insert oppyForecast;
    	
    	map<Id, String> map_oppyPartId_isoCode = new map<Id, String>();
    	map_oppyPartId_isoCode.put(oppypart.Id,'EUR');
    	
    	List<Opportunity_Forecast__c> oppyForecasts = new List<Opportunity_Forecast__c>();
    	oppyForecasts.add(oppyForecast);
    	
    	Map<Id, List<Opportunity_Forecast__c>> partFCs = new Map<Id, List<Opportunity_Forecast__c>>();
    	partFCs.put(part.Id,oppyForecasts);
    	
    	Map<Id, Id> map_partId_oppyId = new Map<Id, Id>();
    	map_partId_oppyId.put(part.Id,oppy.Id);
    	
    	List<Id> list_partIds = new List<Id>();
    	list_partIds.add(part.Id);
    	
        Test.startTest();
        
      
        
        ClsOpportunityForecastStructure cls = new ClsOpportunityForecastStructure(map_oppyPartId_isoCode,'EUR',oppyForecasts,partFCs,'2012',oppy.Id,map_partId_oppyId,rt.Id,rt.Id,'Monthly',list_partIds);
        
        ClsOpportunityForecastStructure.ForecastStructure clsForeCastS = new ClsOpportunityForecastStructure.ForecastStructure('EUR','USD',oppyForecasts,oppy.Id,part.Id,'2012',rt.Id,'Monthly');         
        clsForeCastS.getEditForecasts();
        clsForeCastS.getSalesPriceOF();
        
        map<String, Opportunity_Forecast__c> map_ofcs = new map<String, Opportunity_Forecast__c>();
        map_ofcs.put('1',oppyForecast);
        clsForeCastS.buildFCStructure(oppyForecasts, map_ofcs, 'Yearly');
        clsForeCastS.buildFCStructure(oppyForecasts, map_ofcs, 'Quarterly');
        
        List<ClsOpportunityForecastStructure.ForecastItemStructure> list_fcs = new List<ClsOpportunityForecastStructure.ForecastItemStructure>();
        ClsOpportunityForecastStructure.ForecastItemStructure clsOppyItem = new ClsOpportunityForecastStructure.ForecastItemStructure('Monthly',oppypart.Id,oppy.Id,rt.Id);
        list_fcs.add(clsOppyItem);
        
        clsForeCastS.buildQuarterStructure(oppyForecasts, map_ofcs, list_fcs);
        system.assert(true);
        Test.stopTest();
		}
    }
	static testMethod void testConstrustor3() {
    	Profile p = [Select Id, Name From Profile 
                     where Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
		User u = ClsTestHelp.createTestUsers();
		u.Email = 'hellosManedsfd@testCompany1233423.com';
		u.Alias = 'dpses';
		u.CommunityNickname = 'NNND';
		u.ProfileId = p.Id;
		insert u;
		      
		system.runAs(u){ 		
		RecordType rt = ClsTestHelp.createTestRecordType();
 
		Account acc = ClsTestHelp.createTestAccounts();
		acc.Type = 'CM';
		insert acc;
 
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        insert oppy2;  
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        //oppy.Program__c = oppy2.Id;   
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
    	oppyForecast.Quantity__c = 0;
    	oppyForecast.Part__c = oppypart.Id;
    	oppyForecast.Date__c = date.newInstance(2012, 09, 28);
    	oppyForecast.Amount__c = 1;
    	insert oppyForecast;
    	
    	map<Id, String> map_oppyPartId_isoCode = new map<Id, String>();
    	map_oppyPartId_isoCode.put(oppypart.Id,'EUR');
    	
    	List<Opportunity_Forecast__c> oppyForecasts = new List<Opportunity_Forecast__c>();
    	oppyForecasts.add(oppyForecast);
    	
    	Map<Id, List<Opportunity_Forecast__c>> partFCs = new Map<Id, List<Opportunity_Forecast__c>>();
    	partFCs.put(part.Id,oppyForecasts);
    	
    	Map<Id, Id> map_partId_oppyId = new Map<Id, Id>();
    	map_partId_oppyId.put(part.Id,oppy.Id);
    	
    	List<Id> list_partIds = new List<Id>();
    	list_partIds.add(part.Id);
    	
        Test.startTest();
        
        ClsOpportunityForecastStructure cls = new ClsOpportunityForecastStructure(map_oppyPartId_isoCode,'EUR',oppyForecasts,partFCs,'2012',oppy.Id,map_partId_oppyId,rt.Id,rt.Id,'Monthly',list_partIds);
        
        ClsOpportunityForecastStructure.ForecastStructure clsForeCastS = new ClsOpportunityForecastStructure.ForecastStructure('EUR','EUR',oppyForecasts,oppy.Id,part.Id,'2012',rt.Id,'Monthly');         
        clsForeCastS.level = 'Monthly';
        
        map<String, Opportunity_Forecast__c> map_ofcs = new map<String, Opportunity_Forecast__c>();
        map_ofcs.put('1',oppyForecast);
        
        List<ClsOpportunityForecastStructure.ForecastItemStructure> list_fcs = new List<ClsOpportunityForecastStructure.ForecastItemStructure>();
        ClsOpportunityForecastStructure.ForecastItemStructure clsOppyItem = new ClsOpportunityForecastStructure.ForecastItemStructure('Monthly',oppypart.Id,oppy.Id,rt.Id);
        clsOppyItem.forecast = oppyForecast;
        clsOppyItem.level = 'Monthly';
        clsOppyItem.type = 'Part';
        clsOppyItem.label = 'FM12 Sep';
        list_fcs.add(clsOppyItem);
        
        clsForeCastS.calYearStructure(list_fcs);
        clsForeCastS.calQuarterForecastByMonth(list_fcs);
        system.assert(true);
        Test.stopTest();
		}
    }
}