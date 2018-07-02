/** 
*    trigger to check cross bu if account is changed

*
@author Xia Tong
@created 2013-01-23 
@version 1.0
@since 23.0 (Force.com ApiVersion)
*
@changelog
* 2013-01-23 Xia Tong <xia.tong@itbconsult.com>
* - Created
*/
trigger Opportunity_BU_checkCrossBU on Opportunity (before update) {
	map<Id,Opportunity> map_oppyId_oppy = new map<Id,Opportunity>();
	map<Id,string> map_accId_industry = new map<Id,string>();
	set<Id> set_accId = new set<Id>();
	for(Opportunity o: trigger.new){
		if(o.AccountId != trigger.oldMap.get(o.Id).AccountId) {
			map_oppyId_oppy.put(o.Id,o);
			set_accId.add(o.AccountId);
		}
	}
	
	if(!set_accId.isEmpty()){
		for(Account a: [select id, Customer_Industry__c from Account where id in:set_accId]){
			map_accId_industry.put(a.Id,a.Customer_Industry__c);
		}
	}
	if(!map_accId_industry.isEmpty()) {
		ClsOppyUtil.checkCrossBu(map_oppyId_oppy, map_accId_industry);
	}
}