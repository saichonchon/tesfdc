/**
*   This test class is for Opportunity_AU_modifyOppPartsStatus.
*
@author Di Chen
@created 2012-03-12
@version 1.0
@since 20.0
*
@changelog
* 2012-03-12 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 82%
*/
@isTest
private class TrgOppy_AU_modifyOppPartsStatus_Test {
	 /*
     static testMethod void testForUpdate() {
     	
     	Profile p = [Select Id, Name From Profile 
     								where Name = 'Service Account' 
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
	        
	        Account acc = ClsTestHelp.createTestAccounts();
	        acc.RecordTypeId = rt.Id;
	        acc.AccountNumber = '1082:0133787600';
	        insert acc;
	        Test.startTest();
	        
	        Opportunity oppy = ClsTestHelp.createTestOpportunity();
	        oppy.AccountId = acc.Id;
	        oppy.Lost_Rejected_Dead_On_Hold_Reason__c = 'Price';
	        insert oppy;
	                
	        Opportunity_Part__c oppypart = new Opportunity_Part__c();
	        oppypart.Opportunity__c = oppy.Id;
	        oppypart.Status__c = 'Likely';
	        oppypart.Cable_Assembly_Type__c = 'Fiber Optic';
	        insert oppypart;
	        
	        oppy.StageName = 'New';
	        update oppy;
	        system.assert(true);
	        Test.stopTest();
    	} 
    }

	static testMethod void testForUpdate2() {
		Profile p = [Select Id, Name From Profile 
     								where Name = 'Service Account' 
     								or Name ='System Administrator' 
     								or Name ='Systemadministrator' limit 1];
     	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'helloManesfd2@testCompany1233423.com';
    	u.Alias = 'apsd';
    	u.CommunityNickname = 'TMD2';
    	u.ProfileId = p.Id;
		insert u;
    	
    	system.runAs(u){							
	     	
	        RecordType rt = ClsTestHelp.createTestRecordType();
	        
	        Account acc = ClsTestHelp.createTestAccounts();
	        acc.RecordTypeId = rt.Id;
	        acc.AccountNumber = '1082:0133787600';
	        insert acc;
	           
	        Test.startTest();
	        
	        Opportunity oppy = ClsTestHelp.createTestOpportunity();
	        oppy.StageName = 'Lost';
	        oppy.AccountId = acc.Id;
	        oppy.Lost_Rejected_Dead_On_Hold_Reason__c = 'Price';
	        insert oppy;
	                
	        Opportunity_Part__c oppypart = new Opportunity_Part__c();
	        oppypart.Opportunity__c = oppy.Id;
	        oppypart.Status__c = 'Likely';
	        oppypart.Cable_Assembly_Type__c = 'Fiber Optic';
	        insert oppypart;
	        
	        oppy.StageName = 'Dead';
	        update oppy;
	        
	        Opportunity oppy2 = [select Id,StageName from Opportunity where Id =: oppy.Id];
	        system.assertEquals('Lost/Dead - closed', oppy2.StageName);
	        
	        Test.stopTest(); 
    	}
    }
	static testMethod void testForUpdate3() {
		Profile p = [Select Id, Name From Profile 
     								where Name = 'Service Account' 
     								or Name ='System Administrator' 
     								or Name ='Systemadministrator' limit 1];
     	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'helloManesfd3@testCompany1233423.com';
    	u.Alias = 'dp3e';
    	u.CommunityNickname = 'TMD';
    	u.ProfileId = p.Id;
		insert u;
    	
    	system.runAs(u){							
	     	
	        RecordType rt = ClsTestHelp.createTestRecordType();
	        
	        Account acc = ClsTestHelp.createTestAccounts();
	        acc.RecordTypeId = rt.Id;
	        acc.AccountNumber = '1082:0133787600';
	        insert acc;
	           
	        Test.startTest();
	        
	        Opportunity oppy = ClsTestHelp.createTestOpportunity();
	        oppy.StageName = 'Lost';
	        oppy.AccountId = acc.Id;
	        oppy.Lost_Rejected_Dead_On_Hold_Reason__c = 'Price';
	        insert oppy;
	                
	        Opportunity_Part__c oppypart = new Opportunity_Part__c();
	        oppypart.Opportunity__c = oppy.Id;
	        oppypart.Status__c = 'Likely';
			oppypart.Lost_Reason__c = null;
			oppypart.Cable_Assembly_Type__c = 'Fiber Optic';
	        insert oppypart;
	        
	        oppy.StageName = 'On Hold';
	        update oppy;
	        
	        Opportunity oppy2 = [select Id,StageName from Opportunity where Id =: oppy.Id];
	        system.assertEquals('Approved/Active', oppy2.StageName);
	        
	        Test.stopTest(); 
    	}
    }
	static testMethod void testForUpdate4() {
		
		Profile p = [Select Id, Name From Profile 
     								where Name = 'Service Account' 
     								or Name ='System Administrator' 
     								or Name ='Systemadministrator' limit 1];
     	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'helloManesfd4@testCompany1233423.com';
    	u.Alias = 'dp4e';
    	u.CommunityNickname = 'TMD';
    	u.ProfileId = p.Id;
		insert u;
    	
    	system.runAs(u){							
     	
	        RecordType rt = ClsTestHelp.createTestRecordType();
	        
	        Account acc = ClsTestHelp.createTestAccounts();
	        acc.RecordTypeId = rt.Id;
	        acc.AccountNumber = '1082:0133787600';
	        insert acc;
	           
	        Test.startTest();
	        
	        Opportunity oppy = ClsTestHelp.createTestOpportunity();
	        oppy.StageName = 'New';
	        oppy.AccountId = acc.Id;
	        oppy.Lost_Rejected_Dead_On_Hold_Reason__c = 'Price';
	        oppy.Other_Description__c = 'KAO';
	        insert oppy;
	                
	        Opportunity_Part__c oppypart = new Opportunity_Part__c();
	        oppypart.Opportunity__c = oppy.Id;
	        oppypart.Status__c = 'Likely';
	        oppypart.Cable_Assembly_Type__c = 'Fiber Optic';
	        insert oppypart;
	        
	        oppy.Lost_Rejected_Dead_On_Hold_Reason__c = 'Other';
	        update oppy;
	        
	        Opportunity oppy2 = [select Id,Lost_Rejected_Dead_On_Hold_Reason__c from Opportunity where Id =: oppy.Id];
	        system.assertEquals('Other', oppy2.Lost_Rejected_Dead_On_Hold_Reason__c);
	        
	        Test.stopTest(); 
    	}
    }
    
    
    static testMethod void testForUpdate5() {
    	Profile p = [Select Id, Name From Profile 
     								where Name = 'Service Account' 
     								or Name ='System Administrator' 
     								or Name ='Systemadministrator' limit 1];
     	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'helloManesfd5@testCompany1233423.com';
    	u.Alias = 'dp5e';
    	u.CommunityNickname = 'TMD';
    	u.ProfileId = p.Id;
		insert u;
    	
    	system.runAs(u){							
     	
	        RecordType rt = ClsTestHelp.createTestRecordType();
	        
	        Account acc = ClsTestHelp.createTestAccounts();
	        acc.RecordTypeId = rt.Id;
	        acc.AccountNumber = '1082:0133787633';
	        insert acc;
	           
	        Test.startTest();
	        
	        Opportunity oppy = ClsTestHelp.createTestOpportunity();
	        oppy.StageName = 'New';
	        oppy.AccountId = acc.Id;
	        oppy.CloseDate = Date.today() + 5;
	        insert oppy;
	        
	        oppy.PLM_Id__c = '123456';
	        update oppy;
	        
	        Test.stopTest(); 
        }
    }
	static testMethod void testForUpdate6() {
		Profile p = [Select Id, Name From Profile 
     								where Name = 'Service Account' 
     								or Name ='System Administrator' 
     								or Name ='Systemadministrator' limit 1];
     	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'helloManesfd6@testCompany1233423.com';
    	u.Alias = 'dp6e';
    	u.CommunityNickname = 'TMD';
    	u.ProfileId = p.Id;
		insert u;
    	
    	system.runAs(u){							
     	
	        RecordType rt = ClsTestHelp.createTestRecordType();
	        
	        Account acc = ClsTestHelp.createTestAccounts();
	        acc.RecordTypeId = rt.Id;
	        acc.AccountNumber = '1082:0133787600';
	        insert acc;
	        Test.startTest();
	        
	        Opportunity oppy = ClsTestHelp.createTestOpportunity();
	        oppy.StageName = 'Lost';
	        oppy.AccountId = acc.Id;
	        oppy.Lost_Rejected_Dead_On_Hold_Reason__c = 'Price';
	        insert oppy;
	        
	        ExecuteOnce.SF2SF_OPPORTUNITY = false;
	        oppy.StageName = 'Pre-prod';
	        update oppy;
	        
	        system.assert(true);
	        Test.stopTest(); 
    	}
    }
	static testMethod void testForUpdate7() {
		Profile p = [Select Id, Name From Profile 
     								where Name = 'Service Account' 
     								or Name ='System Administrator' 
     								or Name ='Systemadministrator' limit 1];
     	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'helloManesfd7@testCompany1233423.com';
    	u.Alias = 'dp7e';
    	u.CommunityNickname = 'TMD';
    	u.ProfileId = p.Id;
		insert u;
    	
    	system.runAs(u){							
     	
	        RecordType rt = ClsTestHelp.createTestRecordType6();
	        
	        Account acc = ClsTestHelp.createTestAccounts();
	        acc.RecordTypeId = rt.Id;
	        acc.Type = 'Competitor';
	        acc.AccountNumber = '1082:0133787600';
	        insert acc;
	        Test.startTest();
	        
	        Opportunity oppy = ClsTestHelp.createTestOpportunity();
	        oppy.StageName = 'New';
	        oppy.AccountId = acc.Id;
	        oppy.Lost_Rejected_Dead_On_Hold_Reason__c = 'Price';
	        insert oppy;
	        
	        oppy.StageName = 'Lost';
	        update oppy;
	        
	        system.assert(true);
	        Test.stopTest(); 
        }
    }
	static testMethod void testForUpdate8() {
		Profile p = [Select Id, Name From Profile 
     								where Name = 'Service Account' 
     								or Name ='System Administrator' 
     								or Name ='Systemadministrator' limit 1];
     	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'helloManesfd8@testCompany1233423.com';
    	u.Alias = 'dp8e';
    	u.CommunityNickname = 'TMD';
    	u.ProfileId = p.Id;
		insert u;
    	
    	system.runAs(u){							
     	
	        RecordType rt = ClsTestHelp.createTestRecordType();
	        
	        Account acc = ClsTestHelp.createTestAccounts();
	        acc.RecordTypeId = rt.Id;
	        acc.AccountNumber = '1082:0133787600';
	        insert acc;
	           
	        Test.startTest();
	        
	        Opportunity oppy = ClsTestHelp.createTestOpportunity();
	        oppy.StageName = 'New';
	        oppy.AccountId = acc.Id;
	        oppy.Lost_Rejected_Dead_On_Hold_Reason__c = 'Price';
	        oppy.Other_Description__c = 'KAO';
	        insert oppy;
	                
	        Opportunity_Part__c oppypart = new Opportunity_Part__c();
	        oppypart.Opportunity__c = oppy.Id;
	        oppypart.Status__c = 'Likely';
	        oppypart.Cable_Assembly_Type__c = 'Fiber Optic';
	        insert oppypart;
	        
	        oppy.Lost_Rejected_Dead_On_Hold_Reason__c = 'Other';
	        oppy.StageName = 'Lost';
	        update oppy;
	        
	        system.assert(true);
	        Test.stopTest();
        }
    } 
	static testMethod void testForUpdate9() {
		Profile p = [Select Id, Name From Profile 
     								where Name = 'Service Account' 
     								or Name ='System Administrator' 
     								or Name ='Systemadministrator' limit 1];
     	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'helloManesfd9@testCompany1233423.com';
    	u.Alias = 'dp9e';
    	u.CommunityNickname = 'TMD';
    	u.ProfileId = p.Id;
		insert u;
    	
    	system.runAs(u){							
	     	
	        RecordType rt = ClsTestHelp.createTestRecordType();
	        
	        Account acc = ClsTestHelp.createTestAccounts();
	        acc.RecordTypeId = rt.Id;
	        acc.AccountNumber = '1082:0133787600';
	        insert acc;
	           
	        Test.startTest();
	        
	        Opportunity oppy = ClsTestHelp.createTestOpportunity();
	        oppy.StageName = 'Lost';
	        oppy.AccountId = acc.Id;
	        oppy.Lost_Rejected_Dead_On_Hold_Reason__c = 'Price';
	        oppy.Other_Description__c = 'KAO';
	        insert oppy;
	                
	        Opportunity_Part__c oppypart = new Opportunity_Part__c();
	        oppypart.Opportunity__c = oppy.Id;
	        oppypart.Status__c = 'Likely';
	        oppypart.Cable_Assembly_Type__c = 'Fiber Optic';
	        insert oppypart;
	        
	        oppy.Lost_Rejected_Dead_On_Hold_Reason__c = 'Other';
	        oppy.StageName = 'New';
	        update oppy;
	        
	        system.assert(true);
	        Test.stopTest();
    	}
    } */
}