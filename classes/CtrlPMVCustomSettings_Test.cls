/**
 *  Test class for CtrlPMVCustomSettings
 *
 @author Yuanyuan Zhang
 @created 2014-04-28
 @version 1.0
 @since 29.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-04-28 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
 * - Created
 * - coverate 93%
 */
 
 @isTest(seealldata=true)
private class CtrlPMVCustomSettings_Test {
	static testmethod void  test(){
		Test.startTest();
		
		CtrlPMVCustomSettings cscs = new CtrlPMVCustomSettings();
		cscs.getThis();
		cscs.initialRecord();
		cscs.getStageName();
		cscs.getSalesStage();
		cscs.getBuyerCycle();
		cscs.getOpportunityPartsProcessStatus();
		cscs.getOpportunityPartsConfidence();
		cscs.getTeamViewColumn();
		cscs.getUserRoleid();
		cscs.getSalesProcessID();
		cscs.getPMVTypeInitialization();
		cscs.getSubVerticalBU();
		cscs.getGIBU();
		cscs.getApprovalStatusPMV();
		cscs.getHelptextfield();
		cscs.getQuestiontextfield();
		cscs.getLanguageConfigName();
		
		//language
		cscs.entryLanguageConfig = new CtrlPMVCustomSettings.LanguageConfig();
		cscs.entryLanguageConfig.Name = 'test';
		cscs.entryLanguageConfig.Active = true;
		cscs.entryLanguageConfig.Help_text_field = 'test';
		cscs.entryLanguageConfig.Question_text_field = 'test';
		cscs.entryLanguageConfig.Language = 'en';
		cscs.saveLanguageConfig();
		cscs.pageConf.recordId = cscs.listLCs[0].Id;
		cscs.initialRecord();
		cscs.deleteLanguageConfig();
		
		//PMV team view
		cscs.pageConf.pageTab = 'PMV Team View';
		cscs.refershPage();
		cscs.pageConf.recordId = '';
		cscs.initialRecord();
		cscs.pageConf.recordId = cscs.listTVs[0].Id;
		cscs.initialRecord();
		cscs.saveTeamView();
		cscs.deleteTeamView();
		
		//sales process stage
		cscs.pageConf.pageTab = 'PMV Sales Stage';
		cscs.refershPage();
		cscs.saveWholeCustomSetting();
		
		cscs.refershRecordType();
		
		cscs.addNewRecordType();
		cscs.getRecordTypeList();
		cscs.getPMVType();
		cscs.PMVTypeindex = -1;
		cscs.saveWholeCustomSetting();
		cscs.PMVTypeindex = 0;
		
		cscs.recordTypeId = cscs.listRTs.get(0).recordTypeLists.get(0).recordTypeId;
		
		cscs.deleteRecordType();
		cscs.deletePMVType();
		cscs.reloadSalesStage();
		cscs.selectSameProcessIdByRecordType();
		
		cscs.addNewPMVType();
		
		
		Test.stopTest();   
	}
}