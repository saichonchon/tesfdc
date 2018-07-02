/*------------------------------------------------------------
Author:        Buwen Guo <buwen.guo@capgemini.com>
Description:   Trigger for object MTO_High_Runner__c.
			   The user story number is W-00152.
Inputs:        
Test Class:    ClsMTOHighRunnerTriggerHandlerTest
History
2017-07-28 	   Buwen Guo <buwen.guo@capgemini.com> Created
------------------------------------------------------------*/
trigger MTOHighRunner on MTO_High_Runner__c (after delete, after insert, after undelete, 
		after update, before insert, before update) {
	
	
	//Modified by Buwen Guo 2017-12-27 :  Modified into trigger factory.
	ClsTriggerFactory.createHandler(MTO_High_Runner__c.sObjectType);
	//End
	/*
	if(trigger.isBefore){
		if (trigger.isInsert) {
            System.debug('trigger.newMap++'+ trigger.newMap);
			ClsMTOHighRunnerTriggerHandler.beforeInsert(trigger.new, trigger.newMap);
		}
		if (trigger.isUpdate) {
			ClsMTOHighRunnerTriggerHandler.beforeUpdate(trigger.newMap, trigger.oldMap);
		}
		if (trigger.isUndelete) {
			
		}
		if (trigger.isDelete) {
			
		}
	}
	
	if (trigger.isAfter) {
		if (trigger.isInsert) {
			
		}
		if (trigger.isUpdate) {
			
		}
		if (trigger.isUndelete) {
			
		}
		if (trigger.isDelete) {
			
		}
	}
	*/
}