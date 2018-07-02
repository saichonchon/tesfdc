trigger EnergyPriceBookEntryTrigger on Energy_Price_Book_Entry__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
    

	
	ClsTriggerFactory.createHandler(Energy_Price_Book_Entry__c.sObjectType);
    
}