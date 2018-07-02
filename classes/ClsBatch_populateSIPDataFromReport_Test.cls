/**
*  This test class used to test class ClsBatch_populateSIPDataFromReport.
*
@author Bin Yuan
@created 2014-09-28
@version 1.0
@since 30.0
*
@changelog
* coverage 85% 
* 
* 
2014-09-28 Bin Yuan <bin.yuan@itbconsult.com>
* - Created
*/
@isTest
private class ClsBatch_populateSIPDataFromReport_Test {
	static testMethod void myUnitTest() {
		Test.startTest();
        
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
        
	    ClsTestCustomSettingHelper.getSIPRecordTypes();
        
        list<SIP_Sharing_Setting__c> lstSIP_Sharing_Setting = new list<SIP_Sharing_Setting__c>();
        lstSIP_Sharing_Setting.add(new SIP_Sharing_Setting__c(name = 'Callout limit', Is_Active__c = true, Value__c = '95'));
        lstSIP_Sharing_Setting.add(new SIP_Sharing_Setting__c(name = 'SIP Run Report Query Limit', Is_Active__c = true, Value__c = '1'));
        insert lstSIP_Sharing_Setting;
        
		String recordTypeAM = Apex_Helper_Settings__c.getinstance('AM_Plan').Value__c;
		String recordTypeGAM = Apex_Helper_Settings__c.getinstance('GAM_Plan').Value__c;
		String recordTypeMM = Apex_Helper_Settings__c.getinstance('FE_Plan').Value__c;
		
		SIP__c sipAM = new SIP__c();
		sipAM.Plan_Participant__c = userinfo.getUserId();
		sipAM.RecordTypeId = recordTypeAM;
		sipAM.Plan_Year__c = '2013';
		sipAM.Name = 'test AM';
		sipAM.SIP_master_record__c = sipMaster.Id;
		sipAM.SIP_Mapping__c = sipMapping.Id;
		insert sipAM;
		
		ClsBatch_populateSIPDataFromReport cls = new ClsBatch_populateSIPDataFromReport();
        cls.query = 'Select Id, SIP_Mapping__c from SIP__c';
        Database.executeBatch(cls);
        
		Test.stopTest();
	}
}