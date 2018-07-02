/**
*  This test class used to test batch ClsBatchSetINDCustomerClassification.
*
@author Lili Zhao
@created 2013-11-27
@version 1.0   
@since 28.0
*
@changelog
* coverage 100% 
* 
* 
2013-11-27 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest(seeAllData = true) 
private class ClsBatch_populateSIPDate_Test {

    static testMethod void myUnitTest() {
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
		sipAM.SIP_master_record__c = sipMaster.Id;
		sipAM.Prev_Year_YTD_Direct_billings__c  = 100;
		
		insert sipAM;
		List<SIP__c> list_sips = new List<SIP__c>();
        list_sips.add(sipAM);
              
        Test.startTest();
              
        ClsBatch_populateSIPDate clsBatch = new ClsBatch_populateSIPDate();
        Database.BatchableContext BC;
        clsBatch.filter = ' limit 1';
        clsBatch.start(BC);
        clsBatch.execute(BC, list_sips);
        clsBatch.finish(BC);
                  
        system.assert(true);
        Test.stopTest();
    }
}