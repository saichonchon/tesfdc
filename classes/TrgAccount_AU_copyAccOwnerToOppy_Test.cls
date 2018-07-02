/**
*	This test class is for account_AU_copyAccOwnerToOppies.
*
@author Di Chen
@created 2012-05-03
@version 1.0
@since 20.0
*
@changelog
* 2012-05-03 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 100%
*/
@isTest
private class TrgAccount_AU_copyAccOwnerToOppy_Test{

    static testMethod void testAfterUpdate() {
    	
    	Profile p1 = [select Id from Profile where Name = 'System Administrator' limit 1];
    	Profile p2 = [select Id from Profile where Name = 'Service Account' limit 1];
    	RecordType rt1 = [select Id from RecordType where Name = 'Account' limit 1];
    	RecordType rt2 = [select Id from RecordType where Name = 'Prospect' limit 1];
    	
    	Apex_Helper_Settings__c systemAdminId = new Apex_Helper_Settings__c();
        for(Apex_Helper_Settings__c systemAdminId1 : [select Value__c from Apex_Helper_Settings__c where Name = 'System Admin Profile Id' limit 1]){
        	systemAdminId = systemAdminId1;
        }
	    if(systemAdminId.Value__c == null){
	        systemAdminId.Value__c = p1.Id;
	        systemAdminId.Name = 'System Admin Profile Id';
	        insert systemAdminId;
	    }
	    
    	
		Apex_Helper_Settings__c integrationAdminId = new Apex_Helper_Settings__c();
        for(Apex_Helper_Settings__c integrationAdminId1 : [select Value__c from Apex_Helper_Settings__c where Name = 'Service Account Profile Id' limit 1]){
        	integrationAdminId = integrationAdminId1;
        }
	    if(integrationAdminId.Value__c == null){
	        integrationAdminId.Value__c = p2.Id;
	        integrationAdminId.Name = 'Service Account Profile Id';
	        insert integrationAdminId;
	    }
	    
	    Apex_Helper_Settings__c cisAccountRecordTypeId = new Apex_Helper_Settings__c();
        for(Apex_Helper_Settings__c cisAccountRecordTypeId1 : [select Value__c from Apex_Helper_Settings__c where Name = 'Account Record Type Id' limit 1]){
        	cisAccountRecordTypeId = cisAccountRecordTypeId1;
        }
	    if(cisAccountRecordTypeId.Value__c == null){
	        cisAccountRecordTypeId.Value__c = rt1.Id;
	        cisAccountRecordTypeId.Name = 'Account Record Type Id';
	        insert cisAccountRecordTypeId;
	    }
	    
	   	Apex_Helper_Settings__c prospectRecordTypeId = new Apex_Helper_Settings__c();
        for(Apex_Helper_Settings__c prospectRecordTypeId1 : [select Value__c from Apex_Helper_Settings__c where Name = 'Prospect Record Type Id' limit 1]){
        	prospectRecordTypeId = prospectRecordTypeId1;
        }
	    if(prospectRecordTypeId.Value__c == null){
	        prospectRecordTypeId.Value__c = rt2.Id;
	        prospectRecordTypeId.Name = 'Prospect Record Type Id';
	        insert prospectRecordTypeId;
	    }
	    
	    Apex_Helper_Settings__c serviceAccountProfileId = new Apex_Helper_Settings__c();
        for(Apex_Helper_Settings__c serviceAccountProfileId1 : [select Value__c from Apex_Helper_Settings__c where Name = 'Service Account Profile Id' limit 1]){
        	serviceAccountProfileId = serviceAccountProfileId1;
        }
	    if(serviceAccountProfileId.Value__c == null){
	        serviceAccountProfileId.Value__c = rt1.Id;
	        serviceAccountProfileId.Name = 'Service Account Profile Id';
	        insert serviceAccountProfileId;
	    } 
	    
	    Pricebook2 pb2 = new Pricebook2();
        for(Pricebook2 pb1 : [SELECT id FROM Pricebook2 WHERE IsActive=true AND IsStandard = true limit 1]){
        	pb2 = pb1;
        }
	    if(pb2.Id == null){
	        pb2.IsActive = true;
	        pb2.Name = 'Standard Price Book';
	        insert pb2;
	    } 
	    OrgWideSettings__c OrgSettings = new OrgWideSettings__c();
	    for(OrgWideSettings__c OrgSettings1 : [SELECT Id FROM OrgWideSettings__c where Name = 'Default' limit 1]){
        	OrgSettings = OrgSettings1;
        }
	    if(OrgSettings.Id == null){
	        OrgSettings.Name = 'Default';
	        insert OrgSettings;
	    } 
	    
    	
    	User u = ClsTestHelp.createTestUsers();
    	u.ProfileId = p1.Id;
    	u.Username = 'KO@testKOistbconsult.com';
    	u.Email = 'hohos@testItbconsult.com';
    	u.CommunityNickname = 'xxs.xxx';
    	u.Alias = 'rsrr';
    	insert u;
        
        Test.startTest();
    	
    	system.runAs(u){
	    	
		    TE_Connection__c tec = new TE_Connection__c();
	        for(TE_Connection__c tec1 : [select Source_BU__c from TE_Connection__c where Name = 'CentralOrg' limit 1]){
	        	tec = tec1;
	        }
		    if(tec.Source_BU__c == null){
		        tec.Source_BU__c ='TE Connectivity: CIS QA';
		        tec.Name = 'CentralOrg';
		        insert tec;
		    }
	    	User u2 = ClsTestHelp.createTestUsers();
	    	u2.Username = 'KAO@testEmails.com';
	    	u2.Email = 'zzzszz@testItbconsult.com';
	    	u2.CommunityNickname = 'zszz.zzz';
	    	u2.Alias = 'zzsz';
	    	insert u2;
	    	
	        Account acc = ClsTestHelp.createTestAccounts();
	        acc.OwnerId = u.Id;
	        acc.Source_BU__c = 'TE Connectivity: CIS QA';
	        insert acc;
	        
	        Contact con = ClsTestHelp.createTestContacts();
	        con.AccountId = acc.Id;
	        con.FirstName = 'Hello';
	        insert con;
	        
	        Opportunity oppy = ClsTestHelp.createTestOpportunity();
		    oppy.StageName = 'New';
	        oppy.Program_level_Forecasting__c =true; 
	        oppy.Name = 'Pain of Queen';
	        oppy.Type = 'CM';
	        oppy.AccountId = acc.Id;
	        insert oppy;
	        
	        acc.OwnerId = u2.Id;
	        update acc;
	        
    	}
    	system.assert(true);
        Test.stopTest();
    
    
    
    }
}