/**
 *  Test class for ClsPMVCustomSettingUtil
 *
 @author Yuanyuan Zhang
 @created 2014-04-29
 @version 1.0
 @since 29.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-04-29 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
 * - Created
 * - coverate 90%
 */
 @isTest(seealldata=true)
private class ClsPMVCustomSettingUtil_Test {
	static testmethod void test(){
		
		Test.startTest();
		
		
		
		
		list<ClsPMVCustomSettingUtil.PMVRecordType> list_srt = ClsPMVCustomSettingUtil.getPMVRecordTypeList();
		String pid = '';
		String selectPMVType;
		pid = list_srt.get(0).salesProcessId;
		
		ClsPMVCustomSettingUtil.addNewRecordType(list_srt,list_srt.get(0).recordTypeLists.get(0).recordTypeId);
		
		
		selectPMVType = list_srt.get(0).PMVTypeList.get(0).PMV_Type;
		ClsPMVCustomSettingUtil.addNewPMVType(list_srt,pid,selectPMVType);
		
		List<ClsPMVCustomSettingUtil.PMVType> list_del = new List<ClsPMVCustomSettingUtil.PMVType>();
		
		ClsPMVCustomSettingUtil.refershPMVRecordTypeList(list_srt,pid,list_del,-1);
		ClsPMVCustomSettingUtil.validateWholeCustomSetting(list_srt,pid);
		
		
		ClsPMVCustomSettingUtil.selectSameProcessIdByRecordType(list_srt,selectPMVType);
		
		ClsPMVCustomSettingUtil.getPicklistValues(Opportunity.PMV_Type__c.getDescribe());
		
		Test.stopTest();   
	}
}