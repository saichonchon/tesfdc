trigger InventoryTrg on Inventory__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
	
	
	ClsTriggerFactory.createHandler(Inventory__c.sObjectType);
}