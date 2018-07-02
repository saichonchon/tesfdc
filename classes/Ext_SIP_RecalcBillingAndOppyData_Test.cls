/**
*  This test class used to test class ExtRecalculateBudget.
*
@author Lili Zhao
@created 2013-08-28
@version 1.0
@since 27.0
*
@changelog
* coverage 80% 
* 
* 
2013-08-28 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest(seeAllData = false)
private class Ext_SIP_RecalcBillingAndOppyData_Test {

    static testMethod void myUnitTest() { 
        ClsTestCustomSettingHelper.getSIPRecordTypes();
    	test.startTest();
		
		SIP_master__c sipMaster = new SIP_master__c();
		sipMaster.Name = 'Test Master';
		insert sipMaster;
		
		SIP__c sipGAM = new SIP__c();
		sipGAM.GAM_codes__c = 'testGAM';
		sipGAM.Plan_Participant__c = userinfo.getUserId();
		//RecordType recordType = [select Id, Name, DeveloperName from RecordType where SobjectType = 'SIP__c' and IsActive = true and DeveloperName = 'GAM_plan'];		
		sipGAM.RecordTypeId = Apex_Helper_Settings__c.getInstance('GAM_Plan').Value__c;
        sipGAM.GAM_codes__c = 'a,b,c';
        sipGAM.Profit_Center_Codes__c = 'a;b;c';
		sipGAM.Plan_Year__c = '2014';
		sipGAM.Name = 'test GAM'; 
		sipGAM.SIP_master_record__c = sipMaster.Id;
        sipGAM.Is_Report_Finished__c = true;
        
        SIP__c sipGAM1 = new SIP__c();
		sipGAM1.GAM_codes__c = 'testGAM';
		sipGAM1.Plan_Participant__c = userinfo.getUserId();
		//RecordType recordType = [select Id, Name, DeveloperName from RecordType where SobjectType = 'SIP__c' and IsActive = true and DeveloperName = 'GAM_plan'];		
		sipGAM1.RecordTypeId = Apex_Helper_Settings__c.getInstance('GAM_Plan').Value__c;
        sipGAM1.GAM_codes__c = 'a,b,c';
        sipGAM1.Profit_Center_Codes__c = 'a;b;c';
		sipGAM1.Plan_Year__c = '2015';
		sipGAM1.Name = 'test GAM'; 
		sipGAM1.SIP_master_record__c = sipMaster.Id;
        sipGAM1.Is_Report_Finished__c = true;
		//insert sipGAM;
		
        SIP__c sipGAM2 = new SIP__c();
		sipGAM2.GAM_codes__c = 'testGAM';
		sipGAM2.Plan_Participant__c = userinfo.getUserId();
		//RecordType recordType = [select Id, Name, DeveloperName from RecordType where SobjectType = 'SIP__c' and IsActive = true and DeveloperName = 'GAM_plan'];		
		sipGAM2.RecordTypeId = Apex_Helper_Settings__c.getInstance('GAM_Plan').Value__c;
        sipGAM2.GAM_codes__c = 'a;b;c';
        sipGAM2.Profit_Center_Codes__c = 'a;b;c';
		sipGAM2.Plan_Year__c = '2014';
		sipGAM2.Name = 'test GAM'; 
		sipGAM2.SIP_master_record__c = sipMaster.Id;
        sipGAM2.Is_Report_Finished__c = true;
        
        SIP__c sipAM = new SIP__c();
		sipAM.Plan_Participant__c = userinfo.getUserId();
		//RecordType recordTypeAM = [select Id, Name, DeveloperName from RecordType where SobjectType = 'SIP__c' and IsActive = true and DeveloperName = 'AM_plan'];		
		sipAM.RecordTypeId = Apex_Helper_Settings__c.getInstance('AM_Plan').Value__c;
		sipAM.Plan_Year__c = '2014';
		sipAM.Name = 'test AM';
		sipAM.SIP_master_record__c = sipMaster.Id; 
		//insert sipAM;
        
        SIP__c sipFE = new SIP__c();
		sipFE.Plan_Participant__c = userinfo.getUserId();
		//RecordType recordTypeFE = [select Id, Name, DeveloperName from RecordType where SobjectType = 'SIP__c' and IsActive = true and DeveloperName = 'FE_plan'];		
		sipFE.RecordTypeId = Apex_Helper_Settings__c.getInstance('FE_Plan').Value__c;
		sipFE.Plan_Year__c = '2014';
        sipFE.FE_codes__c = 'a,b,c';
		sipFE.Name = 'test FE'; 
		sipFE.SIP_master_record__c = sipMaster.Id;
        insert new List<SIP__c> {sipFE, sipAM, sipGAM, sipGAM1, sipGAM2};
        
		ApexPages.StandardController stdCtl = new ApexPages.StandardController(sipGAM);
		Ext_SIP_RecalcBillingAndOppyData ext = new Ext_SIP_RecalcBillingAndOppyData(stdCtl);
		ext.recalcBillsAndOppyData(); 
        ext.refreshRecalcStatus();
		ext.goBack();
        
        ApexPages.StandardController stdCtl1 = new ApexPages.StandardController(sipGAM1);
		Ext_SIP_RecalcBillingAndOppyData ext11 = new Ext_SIP_RecalcBillingAndOppyData(stdCtl1);
		ext11.recalcBillsAndOppyData(); 
        ext11.refreshRecalcStatus();
		ext11.goBack();
        
        ApexPages.StandardController stdCtl22 = new ApexPages.StandardController(sipGAM2);
		Ext_SIP_RecalcBillingAndOppyData ext22 = new Ext_SIP_RecalcBillingAndOppyData(stdCtl22);
		ext22.recalcBillsAndOppyData(); 
        ext22.refreshRecalcStatus();
		ext22.goBack();
        
		ApexPages.StandardController stdCtlAM = new ApexPages.StandardController(sipAM);
		Ext_SIP_RecalcBillingAndOppyData extAM = new Ext_SIP_RecalcBillingAndOppyData(stdCtlAM);
		extAM.recalcBillsAndOppyData(); 
		extAM.goBack();
		
		ApexPages.StandardController stdCtlFE = new ApexPages.StandardController(sipFE);
		Ext_SIP_RecalcBillingAndOppyData extFE = new Ext_SIP_RecalcBillingAndOppyData(stdCtlFE);
		extFE.recalcBillsAndOppyData(); 
		extFE.goBack();
		
		test.stopTest();
    }
}