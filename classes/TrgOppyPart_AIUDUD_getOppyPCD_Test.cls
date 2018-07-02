/**
*	This test class is for opportunityPart_AIUDUD_getOppyProgramCloseDate.
*
@author Di Chen
@created 2012-09-12
@version 1.0
@since 20.0
*
@changelog
* 2012-09-12 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 100%
*/
@isTest(seealldata = true)
private class TrgOppyPart_AIUDUD_getOppyPCD_Test {

    static testMethod void testInsert() {
        
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
	    	
	    	
        	Test.startTest();
        	
    		insert oppypart;
    		
    		oppypart.Status__c = 'Won';
    		update oppypart;
    		
    		delete oppypart;
    		
    		undelete oppypart;
    		
    		Opportunity_Part__c oppypart2 = [select Id,Status__c from Opportunity_Part__c where Id =: oppypart.Id];
        	system.assertEquals('Won', oppypart2.Status__c);
       		Test.stopTest();
        }
    }
}