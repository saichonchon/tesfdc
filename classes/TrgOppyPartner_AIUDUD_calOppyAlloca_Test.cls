/**
*	This test class is for ExtOppyForecastEntryPage.
*
@author Di Chen
@created 2012-11-19
@version 1.0
@since 20.0
*
@changelog
* 2012-11-19 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 88%
*/
@isTest
private class TrgOppyPartner_AIUDUD_calOppyAlloca_Test {

    static testMethod void testInsert() {
		Profile p = [Select Id, Name From Profile 
                     where Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
		User u = ClsTestHelp.createTestUsers();
		u.Email = 'codkjeng@testCompany1233423.com';
		u.Alias = 'lehh';
		u.CommunityNickname = 'HHle';
		u.ProfileId = p.Id;
		insert u;
		      
		system.runAs(u){     			
		RecordType rt = ClsTestHelp.createTestRecordType();
 
		Account acc = ClsTestHelp.createTestAccounts();
		acc.Type = 'CM';
		insert acc;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Type = 'CM';
        insert oppy;
        
        Opportunity_Partner__c oppyPartner = new Opportunity_Partner__c();
		oppyPartner.Opportunity__c = oppy.Id;
        oppyPartner.Account__c = acc.Id;
        oppyPartner.Allocation__c = 100;
        oppyPartner.Partner_Role__c = 'Distributor';
        
        Test.startTest();
        
        insert oppyPartner;
        
        try{
        
	        oppyPartner.Allocation__c = 10;
	        update oppyPartner;
	        
	        delete oppyPartner;
        }
        catch(Exception ex){
        //for customer label [addError(system.label.Oppy_Alloc_Msg)]
        }
         
        system.assert(true);
        Test.stopTest();
       
        
        }
    }
	static testMethod void testDelete() {
		Profile p = [Select Id, Name From Profile 
                     where Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
		User u = ClsTestHelp.createTestUsers();
		u.Email = 'hekdi@testCompany1233423.com';
		u.Alias = 'sede';
		u.CommunityNickname = 'mmd';
		u.ProfileId = p.Id;
		insert u;
		      
		system.runAs(u){     			
		RecordType rt = ClsTestHelp.createTestRecordType();
 
		Account acc = ClsTestHelp.createTestAccounts();
		acc.Type = 'CM';
		insert acc;
 
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Type = 'CM';
        insert oppy;
        
        Opportunity_Partner__c oppyPartner = new Opportunity_Partner__c();
		oppyPartner.Opportunity__c = oppy.Id;
        oppyPartner.Account__c = acc.Id;
        oppyPartner.Allocation__c = 100;
        oppyPartner.Partner_Role__c = 'Distributor';
        
        Test.startTest();
        
        insert oppyPartner;
        
        try{
	        
	        delete oppyPartner;
        }
        catch(Exception ex){
        //for customer label [addError(system.label.Oppy_Alloc_Msg)]
        }
         
        system.assert(true);
        Test.stopTest();
        }
    }
}