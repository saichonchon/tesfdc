/*------------------------------------------------------------
Author:        Jinliang Chen <jinliang.chen@oinio.com>
Description:   This class is to test CtrlMTOHighRunnerDataLoader.
			   The user story number is W-00152.
Inputs:        
History
2017-07-25 	Jinliang Chen <jinliang.chen@oinio.com> created
------------------------------------------------------------*/
@isTest
public with sharing class CtrlMTOHighRunnerDataLoader_Test {
	@testSetup static void createConfig(){
		ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping(); 
        Profit_BU_Center_Mapping_Rule2__c rule2 = ClsTestHelp.createTestProfitBUCenterMapping2();
        ClsTestHelp.createTestOrgWideSettings1();
	}
	
    static testMethod void testCtrlMTOHighRunnerDataLoaderCtrl(){
    	Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
    	sh.Level_7_Assigned_Users__c = Userinfo.getUserId() +','+Userinfo.getUserId();
    	sh.Level_7_Territory_Code__c = 'test001';
    	insert sh;
    	
    	Sales_Hierarchy__c sh2 = ClsTestHelp.createTestSalesHierarchy();
    	sh2.Level_7_Assigned_Users__c = '0123456789012345678,123123123123';
    	sh2.Level_7_Territory_Code__c = 'test002';
    	insert sh2;
    	
    	/** insert test data */
    	MTO_High_Runner_File__c mtoHiRuFi = ClsTestHelp.createTestMTOHighRunnerFile();
    	mtoHiRuFi.Filename__c = 'MTO High Runner File 1';
    	insert mtoHiRuFi;
    	
    	MTO_High_Runner_Field_Mapping__c mtoHiRuFiMa = ClsTestHelp.createTestMTOHighRunnerFieldMapping();
    	mtoHiRuFiMa.Name = 'MTO High Runner Field Mapping 1';
    	mtoHiRuFiMa.API_Name__c = 'CSR_Manager__c';
    	mtoHiRuFiMa.Active__c = true;
    	insert mtoHiRuFiMa;
    	Test.startTest();
    	/** test controller */
    	CtrlMTOHighRunnerDataLoader ctrlMtHiRuDaLo = new CtrlMTOHighRunnerDataLoader();
    	Test.stopTest();
    	/** assert */
    	System.assertEquals('',ctrlMtHiRuDaLo.str_newSaveFileName);
    	System.assertNotEquals(null,ctrlMtHiRuDaLo.str_mtoImportFieldsMappingJson);
    	System.assertNotEquals(null,ctrlMtHiRuDaLo.str_fileNamesJson);
    	
    }
    
    static testMethod void testSaveUploadFileName(){
    	/** insert test data */
    	CtrlMTOHighRunnerDataLoader ctrlMtHiRuDaLo = new CtrlMTOHighRunnerDataLoader();
    	ctrlMtHiRuDaLo.str_newSaveFileName = 'test saveFileName';
    	Test.startTest();
    	/** test method */
    	ctrlMtHiRuDaLo.saveUploadFileName();
    	Test.stopTest();
    	/** assert */
    	MTO_High_Runner_File__c mtoHiRuFi = [select Id from MTO_High_Runner_File__c limit 1];
    	System.assert(mtoHiRuFi != null);
    }
    
    static testMethod void testImportRecords(){
    	/** insert test data */
    	CtrlMTOHighRunnerDataLoader ctrlMtHiRuDaLo = new CtrlMTOHighRunnerDataLoader();
    	ctrlMtHiRuDaLo.str_mtoRunnerRecordsJson = '[{"Name":"test MTO High Runner","CONTRACT_LEAD_TIME__c":"2020"}]';
    	Test.startTest();
    	/** test method */
    	ctrlMtHiRuDaLo.importRecords();
    	
    	ctrlMtHiRuDaLo.str_mtoRunnerRecordsJson = 'test exception json';
    	
    	/** test method */
    	ctrlMtHiRuDaLo.importRecords();
    	
    	ctrlMtHiRuDaLo.str_tempRunnerRecordsJson = '[{"Name":"test MTO High Runner","CONTRACT_LEAD_TIME__c":"2020"}]';
    	
    	ctrlMtHiRuDaLo.reRenderPage();
    	Test.stopTest();
    	/** assert */
    }
    
    static testMethod void testExportRecords(){
    	/** insert test data */
    	MTO_High_Runner__c mtoHiRu = ClsTestHelp.createTestMTOHighRunner();
    	mtoHiRu.Name = 'test Mto High Runner';
    	mtoHiRu.Filename__c = 'test FileName';
    	CtrlMTOHighRunnerDataLoader ctrlMtHiRuDaLo = new CtrlMTOHighRunnerDataLoader();
    	ctrlMtHiRuDaLo.str_selectedFileName = 'test FileName';
    	Test.startTest();
    	/** test method */
    	ctrlMtHiRuDaLo.exportRecords();
    	ctrlMtHiRuDaLo.exportRecordsForDataLoader();
    	Test.stopTest();
    	/** assert */
    	System.assert(ctrlMtHiRuDaLo.str_mtoExportReocrdsJson != null);
    }
    
}