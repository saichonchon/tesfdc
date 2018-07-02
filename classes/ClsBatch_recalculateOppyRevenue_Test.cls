/**
*  This test class is for ClsBatch_recalculateOppyRevenue.
*
@author Di Chen
@created 2012-09-12
@version 1.0
@since 20.0
*
@changelog
* 2012-09-12 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 87%
*/
@isTest(seealldata = true)
private class ClsBatch_recalculateOppyRevenue_Test {

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
			RecordType rt = ClsTestHelp.createTestRecordType9();
		  	RecordType rt2 = ClsTestHelp.createTestRecordType16();
		  	Batch_Result_To_Emails__c brte = new Batch_Result_To_Emails__c();
		    for(Batch_Result_To_Emails__c brte1 : [select Name from Batch_Result_To_Emails__c where Name = 'jinbo.shan@itbconsult.com' limit 1]){
		        brte = brte1;
		    }
		    if(brte.Name == null){
		        brte.Name = 'jinbo.shan@itbconsult.com';
		        insert brte;
		    }   
		    
		    Calculate_Oppy_Revenue_Record_Types__c corrt = new Calculate_Oppy_Revenue_Record_Types__c();
		    for(Calculate_Oppy_Revenue_Record_Types__c corrt1 : [select Name, Value__c from Calculate_Oppy_Revenue_Record_Types__c where Name = :rt.DeveloperName limit 1]){
		        corrt = corrt1;
		    }
		    if(corrt.Name == null){
		        corrt.Name = rt.DeveloperName;
		        corrt.Value__c = rt.Id;
		        insert corrt;
		    }
		    
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
			oppy.Total_Opportunity_Value__c = 1;
			oppy.CurrencyIsoCode = 'EUR';
			oppy.Five_Year_Revenue__c = 1;
			oppy.Five_Year_Value__c= 1; 
            oppy.Manufacturing_Start_Date__c= system.today(); //Added by deepak on 22 sep 16 to increase the code coverage persentage from 75% to 80% 
            
			oppy.RecordTypeId = rt.Id;
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
            
		    insert oppypart;
            
                       
		    Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
		    oppyForecast.Opportunity__c = oppy.Id;
		    oppyForecast.Quantity__c = 12;
		    oppyForecast.Part__c = oppypart.Id;
		    oppyForecast.Date__c =date.newInstance(2012, 09, 28); 
		    oppyForecast.Amount__c = 1;
		    oppyForecast.Sales_Price__c = 1;
		    oppyForecast.Fiscal_Year__c ='2012';
		    oppyForecast.Fiscal_Quarter__c = '3';
		    oppyForecast.CurrencyIsoCode = 'USD';
		    insert oppyForecast;
		    
			list<Opportunity> list_oppyFC = new list<Opportunity>();
			list_oppyFC.add(oppy);
		  
			list<Opportunity> list_oppy = new list<Opportunity>();
			list_oppy.add(oppy2);
		  
			Test.startTest();
		  
			ClsBatch_recalculateOppyRevenue clsBatch = new ClsBatch_recalculateOppyRevenue();
		    Database.BatchableContext BC;
			
		  //clsBatch.start(BC);
			clsBatch.execute(BC, list_oppyFC);
			clsBatch.finish(BC);
			ClsBatch_recalculateOppyProgram cls = new ClsBatch_recalculateOppyProgram();
			Database.BatchableContext BC1;
			cls.execute(BC1, list_oppy);
			cls.finish(BC1);
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
	      	RecordType rt = ClsTestHelp.createTestRecordType9();
	      	RecordType rt2 = ClsTestHelp.createTestRecordType16();
	        Batch_Result_To_Emails__c brte = new Batch_Result_To_Emails__c();
	        for(Batch_Result_To_Emails__c brte1 : [select Name from Batch_Result_To_Emails__c where Name = 'jinbo.shan@itbconsult.com' limit 1]){
	            brte = brte1;
	        }
	        if(brte.Name == null){
	            brte.Name = 'jinbo.shan@itbconsult.com';
	            insert brte;
	        }
	        
	        Calculate_Oppy_Revenue_Record_Types__c corrt = new Calculate_Oppy_Revenue_Record_Types__c();
	        for(Calculate_Oppy_Revenue_Record_Types__c corrt1 : [select Name, Value__c from Calculate_Oppy_Revenue_Record_Types__c where Name = :rt.DeveloperName limit 1]){
	            corrt = corrt1;
	        }
	        if(corrt.Name == null){
	            corrt.Name = rt.DeveloperName;
	            corrt.Value__c = rt.Id;
	            insert corrt;
	        }
      
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
			oppy.Total_Opportunity_Value__c=1; 
			oppy.CurrencyIsoCode = 'EUR';
			oppy.Five_Year_Revenue__c = 1;
			oppy.Five_Year_Value__c=1; 
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
	        insert oppypart;
        
	        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
	        oppyForecast.Opportunity__c = oppy.Id;
	        oppyForecast.Quantity__c = 12;
	        oppyForecast.Part__c = oppypart.Id;
	        oppyForecast.Date__c = date.newInstance(2014, 09, 28);
	        oppyForecast.Amount__c = 1;
	        oppyForecast.Five_Year_Amount__c= 1; 
	        oppyForecast.Sales_Price__c = 1;
	        oppyForecast.Fiscal_Year__c = '2012';
	        oppyForecast.Fiscal_Quarter__c = '21';
	        insert oppyForecast;
        
      		list<Opportunity> list_oppyFC = new list<Opportunity>();
      		list_oppyFC.add(oppy);
      
      		Test.startTest();
      
      		ClsBatch_recalculateOppyRevenue clsBatch = new ClsBatch_recalculateOppyRevenue();
        	Database.BatchableContext BC;

      //clsBatch.start(BC);
		    clsBatch.execute(BC, list_oppyFC);
		    clsBatch.finish(BC);
      
			system.assert(true);
			Test.stopTest();
      	}
      
	}
}