/**
 * This class is Energy_Price_Book_Entry__c trigger handler class.
 * 
 * @author      Tangyong Li
 * @created     2017-10-25
 * @since       38.0 (Force.com ApiVersion)
 * @version     1.0
 * 
 * @changelog
 * 2017-10-25   Tangyong Li <tangyong.li@capgemini.com>
 * - Created
 */
public class EnergyPriceBookEntryTriggerHandler extends ClsTriggerVirtual{
    
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
    	setEPBEPart(trgCtx);
    }
    
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
    }
    
    /**
     * Set the lookup to the Part record based on the Name of Energy_Price_Book_Entry__c.
     *
     * @author     Tangyong Li
     * @created    2017-10-25  
     * @version    1.0
     * @since      38.0 (Force.com ApiVersion)
     *
     * @changelog
     * 2017-10-25  Tangyong Li <tangyong.li@capgemini.com>
     * - Created
     */
    private static void setEPBEPart(ClsWrappers.TriggerContext trgCtx) {
    	set<String> set_partName = new set<String>();
    	list<Energy_Price_Book_Entry__c> list_epbes = new list<Energy_Price_Book_Entry__c>();
    	if(trgCtx.isInsert || trgCtx.isUpdate) {
    		for(Sobject sobj : trgCtx.newList) {
    			Energy_Price_Book_Entry__c epbe = (Energy_Price_Book_Entry__c)sobj;
    			if(epbe.Name != null && epbe.Name != '') {
    				set_partName.add(epbe.Name);
    				list_epbes.add(epbe);
    			}
    		}
    		list<Part__c> list_parts = [SELECT Id, Name FROM Part__c WHERE Name IN: set_partName];
    		for(Energy_Price_Book_Entry__c epbe : list_epbes) {
    			for(Part__c part : list_parts) {
    				if(epbe.Name == part.Name) {
    					epbe.Part__c = part.Id;
    					break;
    				}
    			}
    		}
    	}
    }
    
}