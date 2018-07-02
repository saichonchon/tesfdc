/** 
*    trigger to check if an Approver has access to the opportunity, if yes do nothing, 
	 if not save this user as Sales Team Member with Read/Write access.

*
@author Xia Tong
@created 2013-01-15 
@version 1.0
@since 23.0 (Force.com ApiVersion)
*
@changelog
* 2013-01-15 Xia Tong <xia.tong@itbconsult.com>
* - Created
*/

trigger OpportunityApproval_BU_grantAccess on Opportunity_Approval__c (before update) {
	system.debug('tongxia OpportunityApproval_BU_grantAccess');
	map<Id,set<Id>> map_oppyId_approverId = new map<Id,set<Id>>();
	set<Id> set_oppyId = new set<Id>();
	for(Opportunity_Approval__c oa: trigger.new){
		if(oa.Approval_Step__c > 0 && oa.Approval_Step__c != trigger.oldMap.get(oa.Id).Approval_Step__c) set_oppyId.add(oa.Opportunity__c);
	}
	system.debug('tongxia set_oppyId:' + set_oppyId);
	if(!set_oppyId.isEmpty()){
		for(ProcessInstanceWorkitem p:[select ActorId, Id, ProcessInstance.TargetObjectId from ProcessInstanceWorkitem where ProcessInstance.TargetObjectId in:set_oppyId and ProcessInstance.Status='Pending']){
			if(!map_oppyId_approverId.containsKey(p.ProcessInstance.TargetObjectId)){
				map_oppyId_approverId.put(p.ProcessInstance.TargetObjectId,new set<Id>());
			}
			map_oppyId_approverId.get(p.ProcessInstance.TargetObjectId).add(p.ActorId);	
		}
	}
	
	if(!map_oppyId_approverId.isEmpty())	ClsOppyUtil.grantAccess(map_oppyId_approverId);  
}