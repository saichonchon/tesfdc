/*------------------------------------------------------------
Author:        Tangyong Li <tangyong.li@capgemini.com>
Description:   A queue class for insert Opportunity_Part__c when quote status changed to won.
Test Class:    ClsCopyLineItemsToOppyPartsQueue_Test
History
2018-05-04 	   Tangyong Li <tangyong.li@capgemini.com> Created
------------------------------------------------------------*/
public with sharing class ClsCopyLineItemsToOppyPartsQueue implements Queueable {
    
    public set<Id> set_ApprovedQuoteIds;
    public map<Id, String> map_oppId_oppIsoCode;
    
  	public ClsCopyLineItemsToOppyPartsQueue(set<Id> set_ApprovedQuoteIds, map<Id, String> map_oppId_oppIsoCode) {
        this.set_ApprovedQuoteIds = set_ApprovedQuoteIds;
        this.map_oppId_oppIsoCode = map_oppId_oppIsoCode;
  	}
  	
  	public void execute(QueueableContext queCont) {
  		map<Id, List<Energy_Quote_Line_Item__c>> map_oppId_listItems = new map<Id, List<Energy_Quote_Line_Item__c>>();
		map<String,String> map_part_gpl = new map<String,String>();
		list<Energy_Quote_Line_Item__c> list_quoteLineItems = new list<Energy_Quote_Line_Item__c>();
        list<Opportunity_Part__c> list_newParsToInsert = new list<Opportunity_Part__c>();
        list<Opportunity_Part__c> list_allNewParsToInsertInQueue = new list<Opportunity_Part__c>();
        try{
        String str_rectypeId = Schema.SObjectType.Opportunity_Part__c.getRecordTypeInfosByName().get('Energy Parts').getRecordTypeId();
        EnergyQuoteTrgHandler.isFromQuoteRecreateParts = true;
        if(set_ApprovedQuoteIds.size() > 0) {
        	set<String> set_partIds = new set<String>();
            for(Energy_Quote_Line_Item__c item: [Select Id, Energy_Quote_Name__c , Quantity__c,
                                                 Part_Number__c, UnitPrice__c, Price_List__c, Product_Hierarchy__c,Part__c,	 
                                                 Energy_Quote_Name__r.Opportunity_Name__c,Competitor__c,Competitor_Part__c,Primary_Pack_Quantity__c,
                                                 Customer_Part_Number1__c,Customer_Part_Number__c,Seq_No__c,Max_Qty_in_Standard_lead_time__c,
                                                 Lead_Time__c, LineNumber__c, Past_RSQ__c, Unit_of_measure__c,NDR_Unit_Package_Type__c,NDR_Minimum_Order_Quantity__c,
                                                 Comment__c,NDR_Customer_Comments__c
                                                 From Energy_Quote_Line_Item__c 
                                                 Where Energy_Quote_Name__c in: set_ApprovedQuoteIds]){
	             if(!map_oppId_listItems.containsKey(item.Energy_Quote_Name__r.Opportunity_Name__c)){
	                 map_oppId_listItems.put(item.Energy_Quote_Name__r.Opportunity_Name__c, new List<Energy_Quote_Line_Item__c>());
	             }
	             map_oppId_listItems.get(item.Energy_Quote_Name__r.Opportunity_Name__c).add(item);
	             set_partIds.add(item.Part__c);
	             list_quoteLineItems.add(item);
	         }
			for(part__c p : [select id,Product_Hierarchy__c from part__c where id IN :set_partIds]){
            	map_part_gpl.put(p.Id,p.Product_Hierarchy__c);
            }
        }
        
        if(list_quoteLineItems.size() > 0) {
        	for(Energy_Quote_Line_Item__c lineItem : list_quoteLineItems) {
                Opportunity_Part__c newPart = new Opportunity_Part__c();
                newPart.Opportunity__c = lineItem.Energy_Quote_Name__r.Opportunity_Name__c;
                newPart.RecordTypeId = str_rectypeId;
                newPart.CurrencyIsoCode = map_oppId_oppIsoCode.get(lineItem.Energy_Quote_Name__r.Opportunity_Name__c);
                newPart.Quantity__c = lineItem.Quantity__c;
                newPart.Part__c = lineItem.Part__c;
                newPart.Sales_Price__c = lineItem.Price_List__c;
                newPart.Offered_Price__c = lineItem.UnitPrice__c;
                newPart.GPL__c = lineItem.Product_Hierarchy__c;
                if(lineItem.Product_Hierarchy__c == null && lineItem.Part__c != null && map_part_gpl.containsKey(lineItem.Part__c)){
                	newPart.GPL__c = map_part_gpl.get(lineItem.Part__c);
                }
                newPart.Seq_No__c = lineItem.Seq_No__c;
                newPart.Max_Qty_in_Standard_lead_time__c = lineItem.Max_Qty_in_Standard_lead_time__c;
                newPart.Lead_Time__c = lineItem.Lead_Time__c;
                newPart.NDR_Item_Number__c = lineItem.LineNumber__c;
                newPart.Energy_Quote_Line_Item__c = lineItem.Past_RSQ__c;
                newPart.Code_for_unit_of_measurement__c = lineItem.Unit_of_measure__c;
                newPart.NDR_Competitor_Name__c = lineItem.Competitor__c;
                newPart.NDR_Competitor_Part_Number__c = lineItem.Competitor_Part__c;
                newPart.Customer_Part_Number1__c = lineItem.Customer_Part_Number1__c;
                newPart.Customer_Part_Number__c = lineItem.Customer_Part_Number__c;
                newPart.NDR_Minimum_Order_Quantity__c = lineItem.NDR_Minimum_Order_Quantity__c;
                newPart.NDR_Unit_Package_Type__c = lineItem.NDR_Unit_Package_Type__c;
                newPart.Primary_Pack_Quantity__c = lineItem.Primary_Pack_Quantity__c;
                newPart.Status__c = 'Won';
                newPart.Comments__c = lineItem.Comment__c;   
                newPart.NDR_Customer_Comments__c = lineItem.NDR_Customer_Comments__c;
                if(list_newParsToInsert.size() < 50) {
	                list_newParsToInsert.add(newPart);
                } else {
                	list_allNewParsToInsertInQueue.add(newPart);
                }
            }
        }
  		list<Opportunity_Part__c> list_newParsToInsertInQueue = new list<Opportunity_Part__c>();
        if(list_newParsToInsert.size() > 0) {
        	insert list_newParsToInsert;
            if(list_allNewParsToInsertInQueue.size() > 0) {
            	EnergyQuoteTrgHandler.insertNewOppPart(JSON.serialize(list_allNewParsToInsertInQueue));
            }
        }
        }catch(exception ex) {
            String vStrError = 'Error Type = ' + ex.getTypeName() + ' Error Line = ' + ex.getLineNumber() + ' Error Stack = ' + ex.getStackTraceString() + ' Error Message = ' + ex.getMessage();
        	SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError, '', '', '', '5','','','Exception', ex.getLineNumber() + '',ex.getStackTraceString());
            System.debug('--- Error ----------'+ ex);
        }
  	}
    
}