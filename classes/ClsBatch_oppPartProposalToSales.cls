global class ClsBatch_oppPartProposalToSales implements Database.Batchable<SObject>,Database.Stateful{

    public String query;
    global Id SalesPartRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_Parts' Limit 1].Id;

    global Database.QueryLocator start(Database.BatchableContext BC)
    { 
        if (query == null || query == '')
        {
            query =   'SELECT Id,' 
                    + ' RecordTypeId, Proposal_Part_Key_Id__c, Part__c ' 
                    + ' FROM   Opportunity_Part__c '
                    + ' WHERE Proposal_Part_Key_Id__c != null ' 
                    + ' AND RecordTypeId !=\'' + SalesPartRT + '\''
                    + ' AND Matches_Part_from_PLM__c = \'false\'';                                        
        }
        return Database.getQueryLocator(query); 
    }

    global void execute(Database.BatchableContext BC, list<Opportunity_Part__c> oppyPartBatch)
    {    
        set<Decimal> PartKeyIds = new set<Decimal>();
        map<Decimal, Id> map_ExistingParts = new map<Decimal, Id>();
            
        for(Opportunity_Part__c oppyPart : oppyPartBatch)
        {   
            PartKeyIds.add(oppyPart.Proposal_Part_Key_Id__c);
        }
        
        for(Part__c part : [SELECT Part_Key_Id__c, Id from Part__c where Part_Key_Id__c in: PartKeyIds])
        {
            map_ExistingParts.put(part.Part_Key_Id__c, part.Id);
        }
        
        for(Opportunity_Part__c updatePart : oppyPartBatch)
        {           
            if(map_ExistingParts.containsKey(updatePart.Proposal_Part_Key_Id__c))
            {
            	//JNV 1/18/2013 - it was decided that the record type of the part should stay
            	//proposal, even if a part number was added for it
                //updatePart.RecordTypeId = SalesPartRT;
                updatePart.Part__c = map_ExistingParts.get(updatePart.Proposal_Part_Key_Id__c);
            }
            else if (updatePart.Proposal_Part_Key_Id__c == -1)
            {
            	updatePart.Proposal_Part_Key_Id__c = null;
            	updatePart.Part__c = null;
            }
        }
        
        update oppyPartBatch;       
    }
    
    global void finish(Database.BatchableContext BC)
    {
        
    }    
    
}