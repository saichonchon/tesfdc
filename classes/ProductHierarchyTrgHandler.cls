/*------------------------------------------------------------
Author:        Tangyong Li <tangyong.li@capgemini.com>
Description:   Handler class for Product_Hierarchy__c trigger.
Inputs:        
Test Class:    ProductHierarchyTrgHandlerTest
History
2017-08-23 	   Tangyong Li <tangyong.li@capgemini.com> Created
------------------------------------------------------------*/
public class ProductHierarchyTrgHandler extends ClsTriggerVirtual {
    
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
    	generatePartsWithProductHierarchy(trgCtx);
    }
    
    /*------------------------------------------------------------
	Author:        Tangyong Li <tangyong.li@capgemini.com>
	Description:   Generate different part records according different records relating to Energy
	Inputs:        trgCtx - ClsWrappers.TriggerContext
	Returns:       
	History
	2017-08-23 	   Tangyong Li <tangyong.li@capgemini.com> created
	------------------------------------------------------------*/
    private static void generatePartsWithProductHierarchy(ClsWrappers.TriggerContext trgCtx) {
    	if(trgCtx.isAfter) {
			list<Part__c> list_prodHierarchys = new list<Part__c>();
    		if(trgCtx.isInsert) {
    			for(SObject so : trgCtx.newList) {
                    Product_Hierarchy__c prodHierarchy = (Product_Hierarchy__c)so;
                    if(prodHierarchy.CBC1_Description__c == 'Energy' || prodHierarchy.CBC1_Description__c == 'ENERGY') {
	                    Part__c part = new Part__c();
	                    part.Name = 'Energy-Proposal-Part-' + prodHierarchy.Name;
	                    part.Description__c = 'Proposal Part for GPL ' + prodHierarchy.Name;
	                    part.Product_Hierarchy__c = prodHierarchy.Id;
	                    part.GPL_DESC__c = prodHierarchy.GPL_Description__c;
                        part.Proposal_Part__c = true;
                        part.isActive__c = true;
	                    list_prodHierarchys.add(part);
                    }
    			}
    		} else if(trgCtx.isUpdate){
    			map<String, Product_Hierarchy__c> map_Id_prodHierarchy = new map<String, Product_Hierarchy__c>();
    			map<String, Part__c> map_prodHieraId_part = new map<String, Part__c>();
    			for(SObject so : trgCtx.newList) {
                    Product_Hierarchy__c prodHierarchy = (Product_Hierarchy__c)so;
    				if(prodHierarchy.CBC1_Description__c == 'Energy' || prodHierarchy.CBC1_Description__c == 'ENERGY') {
	                    map_Id_prodHierarchy.put(prodHierarchy.Id, prodHierarchy);
    				}
    			}
    			for(Part__c part : [SELECT Id, Name, Description__c, Product_Hierarchy__c, GPL_DESC__c 
    								FROM Part__c 
    								WHERE Name like '%Proposal-Part%' AND Product_Hierarchy__c IN: map_Id_prodHierarchy.keySet()]) {
    				map_prodHieraId_part.put(part.Product_Hierarchy__c, part);
    			}
    			for(Product_Hierarchy__c ph : map_Id_prodHierarchy.values()) {
    				if(map_prodHieraId_part.containsKey(ph.Id)) {
    					Part__c part = map_prodHieraId_part.get(ph.Id);
						part.Name = 'Energy-Proposal-Part-' + ph.Name;
	                    part.Description__c = 'Proposal Part for GPL ' + ph.Name;
	                    part.GPL_DESC__c = ph.GPL_Description__c;
                        part.Proposal_Part__c = true;
	                    list_prodHierarchys.add(part);
    				} else {
    					Part__c part = new Part__c();
	                    part.Name = 'Energy-Proposal-Part-' + ph.Name;
	                    part.Description__c = 'Proposal Part for GPL ' + ph.Name;
	                    part.Product_Hierarchy__c = ph.Id;
	                    part.GPL_DESC__c = ph.GPL_Description__c;
                        part.Proposal_Part__c = true;
                        part.isActive__c = true;
	                    list_prodHierarchys.add(part);
    				}
    			}
    		}
    		if(list_prodHierarchys.size() > 0) {
    			try {
	    			upsert list_prodHierarchys;
    			} catch(Exception e){
					//ErrorLogging.Log(e);
					String vStrError = 'Error Type = ' + e.getTypeName() + ' Error Line = ' + e.getLineNumber() + ' Error Stack = ' + e.getStackTraceString() + ' Error Message = ' + e.getMessage();
	            	SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '',e.getStackTraceString());
                }
    		}
    	}
    }
    
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
    	
    }
    
}