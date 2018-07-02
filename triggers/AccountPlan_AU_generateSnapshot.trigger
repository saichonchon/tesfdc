/**
 *  Class to generate Snapshot of object account plan
 * 
 * @author Yuanyuan Zhang
 * @created 2012-05-18
 * @version 1.0
 * @since 23.0
 * 
 * return
 *
 * @changelog
 * 2012-05-18 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
 * - Created   
 *
 */

trigger AccountPlan_AU_generateSnapshot on Account_Plan__c (after update) {
	//************************* BEGIN Pre-Processing **********************************************
	list<Account_Plan__c> list_accountPlan2Insert = new list<Account_Plan__c>();
	
	Id snapShot;
	Apex_Helper_Settings__c ahs = Apex_Helper_Settings__c.getInstance('AccountPlan_Snapshot');
	if(ahs.Active__c){
		snapShot = ahs.value__c;
	}
	
	/*try{
		snapShot = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Account_Plan__c' AND DeveloperName = 'Snapshot' LIMIT 1].Id;
	}
	catch(Exception ex) {
		String error = ex.getMessage();
		for(Account_Plan__c ap : trigger.new){
			ap.addError(error);
		}
	}*/
	//************************* END Pre-Processing ************************************************
	//************************* BEGIN Before Trigger **********************************************
	for(Account_Plan__c ap : trigger.new){
		if(ap.Active__c && ap.Approval_Status__c == 'Approved' && trigger.oldMap.get(ap.Id).Approval_Status__c != ap.Approval_Status__c && ap.RecordTypeId != snapShot){
			Account_Plan__c accPlan = ap.clone(false,true);
			accPlan.RecordTypeId = snapShot;
			list_accountPlan2Insert.add(accPlan);
		}
	}
	if(list_accountPlan2Insert.size() != 0){
		insert list_accountPlan2Insert;
	}
	
	//************************* END Before Trigger ************************************************
	
	//************************* BEGIN After Trigger ***********************************************
	
	//************************* END After Trigger *************************************************
	
}