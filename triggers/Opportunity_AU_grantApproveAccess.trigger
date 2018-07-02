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
trigger Opportunity_AU_grantApproveAccess on Opportunity (after update) {
	set<Id> set_oppyId = new set<Id>();
	for(Opportunity oppy: trigger.new){
		//system.debug('tongxia oppy.Approval_Step__c:' + oppy.Approval_Step__c);
		//system.debug('tongxia oppy.Approval_Step__c old:' + trigger.oldMap.get(oppy.Id).Approval_Step__c);
		if(oppy.Approval_Step__c > 0 && oppy.Approval_Step__c != trigger.oldMap.get(oppy.Id).Approval_Step__c){
			set_oppyId.add(oppy.Id);
		}
	}
	if(!set_oppyId.isEmpty())	ClsOppyUtil.opportunityApprovalFuture(set_oppyId);
}