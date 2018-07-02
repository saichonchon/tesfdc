/**
*  This test class used to test class ExtRecalculateBudget.
*
@author Lili Zhao
@created 2013-08-28
@version 1.0
@since 27.0
*
@changelog
* coverage 85% 
* 
* 
2013-08-28 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest
private class SIP_Mapping_AU_Test {
 	static testMethod void myUnitTest() {
    	test.startTest(); 
		SIP_master__c sipMaster = new SIP_master__c();
		sipMaster.Name = 'Test Master';
		insert sipMaster;	
		SIP_Mapping__c sipMapping = new SIP_Mapping__c();		
		sipMapping.Report_Field_1__c = 'T!0_1';
		sipMapping.Report_ID_1__c = '00OE0000002QYDq';
		sipMapping.Report_Parameters_1__c = 'AM_Codes__c,2';
		sipMapping.Target_Field_1__c = 'Prev_Year_YTD_POS__c';
		sipMapping.Target_Field_Name_1__c = 'Revenue Base Line';
		insert sipMapping;
		User user = new User();
		user=ClsTestHelp.createTestUsers();
		user.Te_Network_Id__c = 'testUser';
		user.username = 'test2081.te@test991.com';
		insert user;
			
		String recordTypeAM;
		String recordTypeGAM;
		String recordTypeMM;
		
		for (RecordType recordType : [select Id, Name, DeveloperName from RecordType where SobjectType = 'SIP__c' and IsActive = true and (DeveloperName = 'AM_plan' or DeveloperName = 'FE_Plan' or DeveloperName = 'GAM_plan' or DeveloperName = 'Sales_Manager_Plan')]) {
			if(recordType.DeveloperName == 'AM_plan'){
				recordTypeAM = recordType.Id;				
			}else if (recordType.DeveloperName == 'GAM_plan') {				
				recordTypeGAM = recordType.Id;
			}else {			
				recordTypeMM = recordType.Id;
			}
		}
		SIP__c sipAM = new SIP__c();
		sipAM.Plan_Participant__c = user.Id;
		sipAM.RecordTypeId = recordTypeAM;
		sipAM.Plan_Year__c = '2013';
		sipAM.Name = 'test AM';
		sipAM.SIP_master_record__c = sipMaster.Id;
		sipAM.SIP_Mapping__c = sipMapping.Id;
		insert sipAM;
		
		sipMapping.Name = 'Test mapping';
		
		update sipMapping;
		test.stopTest();
		
    } 
}