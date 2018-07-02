@isTest(seealldata=false)
private class ClsBatch_populateSIPRunningNumbers_Test {
    static testMethod void TestpopulateSIPRunningNumbers()
    {
        String recordTypeFE;
        for (RecordType recordType : [select Id, Name, DeveloperName from RecordType where SobjectType = 'SIP__c' and IsActive = true and DeveloperName = 'FE_Plan' ]) {		
            recordTypeFE = recordType.Id; 
        }
        
        SIP_Mapping__c sipMapping = new SIP_Mapping__c();		
		sipMapping.Report_Field_1__c = 'T!0_1';
		sipMapping.Report_ID_1__c = '00OE0000002QYDq';
		sipMapping.Report_Parameters_1__c = 'AM_Codes__c,2';
		sipMapping.Target_Field_1__c = 'Prev_Year_YTD_POS__c';
		sipMapping.Target_Field_Name_1__c = 'Revenue Base Line';
		insert sipMapping;
        
        SIP_master__c sipMaster = new SIP_master__c();
        sipMaster.Name = 'Test Master';
        insert sipMaster;
        
        SIP__c sipFE = new SIP__c();
        sipFE.Plan_Participant__c = userinfo.getUserId();
        sipFE.RecordTypeId = recordTypeFE;
        sipFE.Plan_Year__c = '2016';
        sipFE.Name = 'test FE';
        sipFE.Exclude_From_Automatic_Update__c = false;
        sipFE.SIP_Mapping__c = sipMapping.Id;
        sipFE.Approver__c = userinfo.getUserId();
        sipFE.SIP_master_record__c = sipMaster.Id;
        sipFE.Prev_Year_YTD_Direct_billings__c  = 100;
        insert sipFE;
        
        Test.startTest();
        
        ClsBatch_populateSIPRunningNumbers objBatch = new ClsBatch_populateSIPRunningNumbers();
        Database.executeBatch(objBatch);
        
        Test.stopTest();
    }

}