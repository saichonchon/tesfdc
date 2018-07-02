/*------------------------------------------------------------
Author:        Tangyong Li <tangyong.li@capgemini.com>
Description:   Handler class for Inventory__c trigger.
			   The user story number is W-00458.
Inputs:        
Test Class:    InventoryTrgHandlerTest
History
2017-09-20 	   Tangyong Li <tangyong.li@capgemini.com> Created
------------------------------------------------------------*/
public class InventoryTrgHandler extends ClsTriggerVirtual {
    
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
    	setInventoryPart(trgCtx);
    }
    
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
    }
    
    /*------------------------------------------------------------
	Author:        Tangyong Li <tangyong.li@capgemini.com>
	Description:   Set the lookup to the Part record based on the Part Number.
	Inputs:        
	Returns:       
	History
	2017-09-20 	   Tangyong Li <tangyong.li@capgemini.com> created
	------------------------------------------------------------*/
    private static void setInventoryPart(ClsWrappers.TriggerContext trgCtx) {
    	set<String> set_partNum = new set<String>();
    	list<Inventory__c> list_inventorys = new list<Inventory__c>();
    	if(trgCtx.isInsert) {
    		for(Sobject sobj : trgCtx.newList) {
    			Inventory__c invent = (Inventory__c)sobj;
    			if(invent.Part_Number__c != null && invent.Part_Number__c != '') {
    				set_partNum.add(invent.Part_Number__c);
    				list_inventorys.add(invent);
    			}
    		}
    		list<Part__c> list_parts = [SELECT Id, Name FROM Part__c WHERE Name IN: set_partNum];
    		for(Inventory__c invent : list_inventorys) {
    			for(Part__c part : list_parts) {
    				if(invent.Part_Number__c == part.Name) {
    					invent.PartNbr__c = part.Id;
    					break;
    				}
    			}
    		}
    	}
    }
    
}