/*------------------------------------------------------------
Author:        Tangyong Li <tangyong.li@capgemini.com>
Description:   Trigger for object Product_Hierarchy__c.
Inputs:        
Test Class:    ProductHierarchyTrgHandlerTest
History
2017-08-11 	   Tangyong Li <tangyong.li@capgemini.com> Created
------------------------------------------------------------*/
trigger ProductHierarchyTrigger on Product_Hierarchy__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
	
	
	ClsTriggerFactory.createHandler(Product_Hierarchy__c.sObjectType);
	
}