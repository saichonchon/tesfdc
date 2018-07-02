/** 
*    trigger on Task level which sets the "Related To" user as Sales Team Member is case that 
	 user has no access to the related Opportunity.


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
trigger Task_AIU_grantAssigneeAccess on Task (after insert, after update) {
	String prefix = Opportunity.SObjectType.getDescribe().getKeyPrefix();
	map<Id,set<Id>> map_oppyId_userId = new map<Id,set<Id>>();
	for(Task t: trigger.new){
		if(t.WhatId != null && ((String)t.WhatId).substring(0,3) == prefix){
			if(trigger.isInsert){
				if(!map_oppyId_userId.containsKey(t.WhatId)){
					map_oppyId_userId.put(t.WhatId,new set<Id>());
				}
				map_oppyId_userId.get(t.WhatId).add(t.OwnerId);
			}else if(trigger.isUpdate && (t.WhatId != trigger.oldMap.get(t.Id).WhatId || t.OwnerId != trigger.oldMap.get(t.Id).OwnerId)){
				if(!map_oppyId_userId.containsKey(t.WhatId)){
					map_oppyId_userId.put(t.WhatId,new set<Id>());
				}
				map_oppyId_userId.get(t.WhatId).add(t.OwnerId);
			}
		}
	}
	
	if(!map_oppyId_userId.isEmpty()) ClsOppyUtil.grantAccess(map_oppyId_userId); 
}