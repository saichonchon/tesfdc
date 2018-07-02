trigger SIP_Mapping_AU on SIP_Mapping__c (after update) {
	//update sip mapping related sip report fields
	map<String, SIP_Mapping__c> map_sipMappingId_sipMapping = new map<String, SIP_Mapping__c>();
	for(SIP_Mapping__c sipMapping : trigger.new) {
		map_sipMappingId_sipMapping.put(sipMapping.Id, sipMapping);
	}
	ClsSIPUitl.ISAFTERUPDATE = true;
	ClsSIPUitl.getSIPMappingRecords(map_sipMappingId_sipMapping);
	//ClsSIPUitl.populatDataFromReportAsynForMapping(map_sipMappingId_sipMapping.keySet());
	/*
	ExtSIP_analyticsAPICall cls = new ExtSIP_analyticsAPICall(new ApexPages.standardController(new SIP_Mapping__c()));
	cls.set_sipMappingIds.addAll(map_sipMappingId_sipMapping.keySet());
	cls.runReportAync();
	*/
	ClsSIPUitl.populateSIPReportLink(map_sipMappingId_sipMapping, new set<String>());
	ClsSIPUitl.ISAFTERUPDATE = false;
}