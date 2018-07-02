/**
*  This test class used to test class ExtRecalculateBudget.
*
@author Lili Zhao
@created 2013-08-28
@version 1.0
@since 27.0
*
@changelog
* coverage 81% 
* 
* 
2013-08-28 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest 
private class TrgSIP_AI_Test {

    static testMethod void myUnitTest() {
    	test.startTest(); 
    	User user = new User();
		user=ClsTestHelp.createTestUsers();
		user.Te_Network_Id__c = 'testUser';
		insert user;
		
		String recordTypeAM;
		String recordTypeFE;
		String recordTypeGAM;
		String recordTypeMM;
		
		for (RecordType recordType : [select Id, Name, DeveloperName from RecordType where SobjectType = 'SIP__c' and IsActive = true and (DeveloperName = 'AM_plan' or DeveloperName = 'FE_Plan' or DeveloperName = 'GAM_plan' or DeveloperName = 'Sales_Manager_Plan')]) {
			if(recordType.DeveloperName == 'AM_plan'){
				recordTypeAM = recordType.Id;				
			} else if(recordType.DeveloperName == 'FE_Plan') {				
				recordTypeFE = recordType.Id;
			}else if (recordType.DeveloperName == 'GAM_plan') {				
				recordTypeGAM = recordType.Id;
			}else {			
				recordTypeMM = recordType.Id;
			}
		}
		
		SIP_master__c sipMaster = new SIP_master__c();
		sipMaster.Name = 'Test Master';
		insert sipMaster;
		
    	SIP__c sipAM = new SIP__c();
		sipAM.Plan_Participant__c = user.Id;
		sipAM.RecordTypeId = recordTypeAM;
		sipAM.Plan_Year__c = '2013';
		sipAM.Name = 'test AM';
		sipAM.Approver__c = user.Id;
		sipAM.SIP_master_record__c = sipMaster.Id;
		
		insert sipAM;
    	test.stopTest();       
    }
    static testMethod void myUnitTest2() {
    	test.startTest(); 
    	User user = new User();
		user=ClsTestHelp.createTestUsers();
		user.Te_Network_Id__c = 'testUser';
		user.ManagerId = UserInfo.getUserId();
		insert user;
		
		String recordTypeAM;
		String recordTypeFE;
		String recordTypeGAM;
		String recordTypeMM;
		
		for (RecordType recordType : [select Id, Name, DeveloperName from RecordType where SobjectType = 'SIP__c' and IsActive = true and (DeveloperName = 'AM_plan' or DeveloperName = 'FE_Plan' or DeveloperName = 'GAM_plan' or DeveloperName = 'Sales_Manager_Plan')]) {
			if(recordType.DeveloperName == 'AM_plan'){
				recordTypeAM = recordType.Id;				
			} else if(recordType.DeveloperName == 'FE_Plan') {				
				recordTypeFE = recordType.Id;
			}else if (recordType.DeveloperName == 'GAM_plan') {				
				recordTypeGAM = recordType.Id;
			}else {			
				recordTypeMM = recordType.Id;
			}
		}
		
		SIP_master__c sipMaster = new SIP_master__c();
		sipMaster.Name = 'Test Master';
		insert sipMaster;
		
    	SIP__c sipAM = new SIP__c();
		sipAM.Plan_Participant__c = user.Id;
		sipAM.RecordTypeId = recordTypeAM;
		sipAM.Plan_Year__c = '2013';
		sipAM.Name = 'test AM';
		sipAM.SIP_master_record__c = sipMaster.Id;
		
		insert sipAM;
    	test.stopTest();
        
    }
}