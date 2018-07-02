/**
*  This test class is for ClsBatch_MigrateOpportunityForecasts.
*
@author Di Chen
@created 2012-09-12
@version 1.0
@since 20.0
*
@changelog
* 2012-09-12 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 96%
*/
@isTest(seealldata = true)
private class ClsBatch_MigrateOppyForecasts_Test {

    static testMethod void testBatch() {
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
		oppy.Program__c = oppy2.Id;   
		oppy.Type = 'CM';
		oppy.Request_Type__c = 'Extension';
		oppy.Method__c = 'BOM';
		oppy.Level__c = 'Yearly';
		oppy.Amount = 1;
		oppy.CurrencyIsoCode = 'EUR';
		oppy.Five_Year_Revenue__c = 1;
		oppy2.RecordTypeId = rt2.Id;
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
        oppypart.Initial_Order_Date__c = date.today();
        //oppypart.isDeleted = false;
        insert oppypart;
      
		TOPS_Forecast__c tops = new TOPS_Forecast__c();
		tops.TOPS_Oppy_ID__c = oppy2.Id; 
		tops.TOPS_Part_ID__c = oppypart.Id; 
		tops.Opportunity_Currency__c = '12';
		insert tops;
		      
		List<TOPS_Forecast__c> list_topsForecast = new List<TOPS_Forecast__c>();
		list_topsForecast.add(tops);
		      
		Test.startTest();
		      
		ClsBatch_MigrateOpportunityForecasts clsBatch = new ClsBatch_MigrateOpportunityForecasts();
		Database.BatchableContext BC;
		clsBatch.email = 'sdfsds3@qq.com';
		
		//clsBatch.start(BC);
		clsBatch.execute(BC, list_topsForecast);
		clsBatch.finish(BC);
		      
		system.assert(true);
		Test.stopTest();
      }
    }
	static testMethod void testBatch2() {
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
		oppy.Program__c = oppy2.Id;   
		oppy.Type = 'CM';
		oppy.Request_Type__c = 'Extension';
		oppy.Method__c = 'BOM';
		oppy.Level__c = 'Yearly';
		oppy.Amount = 1;
		oppy.CurrencyIsoCode = 'EUR';
		oppy.Five_Year_Revenue__c = 1;
		oppy.RecordTypeId = rt2.Id;
		oppy.TOPS_ID__c = oppy2.Id;
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
		oppypart.Opportunity__c = oppy2.Id;
		oppypart.Part__c = part.Id;
		oppypart.Status__c = 'Lost';
		oppypart.Lost_Reason__c = 'Other';
		oppypart.Lost_Reason_Text__c = null;
		oppypart.GPL__c = ph.Id;
		oppypart.Initial_Order_Date__c = date.today();
		insert oppypart;
		      
		TOPS_Forecast__c tops = new TOPS_Forecast__c();
		tops.TOPS_Oppy_ID__c = oppy2.Id; 
		tops.TOPS_Part_ID__c = oppypart.Id; 
		tops.Opportunity_Currency__c = '12';
		insert tops;
      
		List<TOPS_Forecast__c> list_topsForecast = new List<TOPS_Forecast__c>();
		list_topsForecast.add(tops);
		      
		Test.startTest();
		      
		ClsBatch_MigrateOpportunityForecasts clsBatch = new ClsBatch_MigrateOpportunityForecasts();
		Database.BatchableContext BC;
		clsBatch.email = null;
		
		//clsBatch.start(BC);
		clsBatch.execute(BC, list_topsForecast);
		clsBatch.finish(BC);
      
		system.assert(true);
		Test.stopTest();
      }
    }
	static testMethod void testBatch3() {
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
				          
		Product_Hierarchy__c ph = new Product_Hierarchy__c();
		ph.Hierarchy_Level_Type__c = 'CBC1';
		ph.Description__c = 'Industrial';
		insert ph;
          
		Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
            
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
		oppy.RecordTypeId = rt2.Id;
		oppy.TOPS_ID__c = oppy2.Id;
		insert oppy;
        
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = part.Id;
        oppypart.Status__c = 'Lost';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        oppypart.GPL__c = ph.Id;
        oppypart.Initial_Order_Date__c = date.today();
        oppypart.TOPS_ID__c = part.Id;
        oppypart.Quantity__c = 12;
        insert oppypart;
      
		TOPS_Forecast__c tops = new TOPS_Forecast__c();
		tops.TOPS_Oppy_ID__c = oppy2.Id; 
		tops.TOPS_Part_ID__c = part.Id; 
		tops.Opportunity_Currency__c = '12';
		insert tops;
		
		Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
    	oppyForecast.Opportunity__c = oppy.Id;
    	oppyForecast.Quantity__c = 12;
    	oppyForecast.Part__c = null;//oppypart.Id;
    	oppyForecast.Date__c = date.newInstance(2012, 09, 28);
    	oppyForecast.Amount__c = 1;
    	oppyForecast.Sales_Price__c = 1;
    	oppyForecast.Fiscal_Year__c = '2012';
    	oppyForecast.Fiscal_Quarter__c = '21';
    	oppyForecast.CurrencyIsoCode = 'USD';
		insert oppyForecast;
	    	     
		List<TOPS_Forecast__c> list_topsForecast = new List<TOPS_Forecast__c>();
		list_topsForecast.add(tops);
		      
		Test.startTest();
		      
		ClsBatch_MigrateOpportunityForecasts clsBatch = new ClsBatch_MigrateOpportunityForecasts();
		Database.BatchableContext BC;
		clsBatch.email = 'sdfsds3@qq.com';
		
		//clsBatch.start(BC);
		clsBatch.execute(BC, list_topsForecast);
		clsBatch.finish(BC);
		      
		system.assert(true);
		Test.stopTest();
      }
    }
}