/**
*   This trigger is used to set the budget values on all BBBMonthly records when budgets are approved
*
@author min liu
@created 2013-01-16
@version 1.0
@since 23.0
*
@changelog
* 2013-01-16 min liu <min.liu@itbconsult.com>
* - Created
*/
trigger Budget_BU_setBBBMonthlyValues on Budget__c (before update) {
	// defence the re-execution of trigger when batch runs
	if(ClsTriggerRecursionDefense.bbbMonthlyUpdate){
		/*
		List<Budget__c> list_budgets = new List<Budget__c>();
		for(Budget__c b :trigger.new){
			// Only approved budgets
			if((b.Stage__c != trigger.oldMap.get(b.id).Stage__c && b.Stage__c == 'Final') || (b.Status__c != trigger.oldMap.get(b.id).Status__c && b.Status__c == 'Approved')) {
				list_budgets.add(b);
			}
		}
		if(!list_budgets.isEmpty()) ClsBudgetPlanningUtil.setBBBMonthlyValuesByBudgets(list_budgets);
		*/
	}		
}