/**
 *  This class is used for update Opportunity.
 *  
 * @author Xiaona Liu
 * @created 2013-06-04
 * @version 1.0
 * 
 *
 * @changelog
 * 2013-06-04 Xiaona Liu <xiaona.liu@itbconsult.com>
 * - Created   
 *
 */
global class ClsBatch_updateOpportunity implements Database.Batchable<SObject>{
    public String query;
    public String filter;
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        if(''==query || null==query){
            query = 'Select Id, StageName From Opportunity where StageName != \'In Approval\' and StageName != \'New\'';
        }
        if(filter != null) query += filter;
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> list_opportunity){    
        map<Id, Opportunity> map_oppy2Update = new map<Id, Opportunity>();
        list<Opportunity> list_oppy2update = new list<Opportunity>();        
        map<Id, String> map_oppyId_oppyStage = new map<Id, String>();        
        Set<Id> set_wonOpenOppyId = new Set<Id>();        
        map<Id, set<String>> map_oppyId_oppyPartConfidenceSet = new map<Id, set<String>>();        
        map<Id,Set<String>> map_oppyId_OppyPartProcessStatusSet = new Map<Id,Set<String>>();
        set<String> set_openStatus = new set<String>{'Production', 'Ramp-down', 'EOL'};
        if(null!=list_opportunity && list_opportunity.size()>0){
            for(Opportunity opp:list_opportunity){
                map_oppy2Update.put(opp.Id, opp);
            }
        }
        
        for(Opportunity_Part__c oppyPart : [Select Id, Status__c, Opportunity__c,Process_Status__c From Opportunity_Part__c Where Opportunity__c in :map_oppy2Update.keySet() ]) {           
            if(oppyPart.Status__c == 'Won' && !set_openStatus.contains(oppyPart.Process_Status__c)){
                System.debug('Xiaona:'+oppyPart.Opportunity__c);
                set_wonOpenOppyId.add(oppyPart.Opportunity__c);
            }
            
            if(map_oppyId_oppyPartConfidenceSet.containsKey(oppyPart.Opportunity__c)) {
                if(!map_oppyId_oppyPartConfidenceSet.get(oppyPart.Opportunity__c).contains(oppyPart.Status__c)) {
                    map_oppyId_oppyPartConfidenceSet.get(oppyPart.Opportunity__c).add(oppyPart.Status__c);
                }
            } 
            else {
                map_oppyId_oppyPartConfidenceSet.put(oppyPart.Opportunity__c, new set<String>{oppyPart.Status__c});
            }
            
            if(map_oppyId_OppyPartProcessStatusSet.containsKey(oppyPart.Opportunity__c)){
                if(!map_oppyId_OppyPartProcessStatusSet.get(oppyPart.Opportunity__c).contains(oppyPart.Process_Status__c)) {
                    map_oppyId_OppyPartProcessStatusSet.get(oppyPart.Opportunity__c).add(oppyPart.Process_Status__c);
                }
            }
            else{
                 map_oppyId_OppyPartProcessStatusSet.put(oppyPart.Opportunity__c, new Set<String>{oppyPart.Process_Status__c});
            }
                    
        }

        set<String> set_oppyPartConfidenceClosedDead = new set<String>{'Dead', 'Lost'};
        set<String> set_oppyPartConfidenceWonClosed = new set<String>{'Won', 'Dead', 'Lost'};
        
        for(Id oppyId : map_oppy2Update.keySet()) {
        	Opportunity opp = map_oppy2Update.get(oppyId);
        	String newStage = opp.StageName;
            if(set_wonOpenOppyId.contains(oppyId)){
            	System.debug('oppyId:'+oppyId+'Won-open');
                newStage = 'Won - Open';
            }
            else if(map_oppyId_oppyPartConfidenceSet.containsKey(oppyId) && set_oppyPartConfidenceClosedDead.containsAll(map_oppyId_oppyPartConfidenceSet.get(oppyId))) {
                System.debug('oppyId:'+oppyId+'Lost/Dead - closed');
                newStage = 'Lost/Dead - closed';
            }
            else if(map_oppyId_oppyPartConfidenceSet.containsKey(oppyId) && map_oppyId_oppyPartConfidenceSet.get(oppyId).contains('Won') && set_oppyPartConfidenceWonClosed.containsAll(map_oppyId_oppyPartConfidenceSet.get(oppyId)) && !map_oppyId_OppyPartProcessStatusSet.get(oppyId).contains('Pre-prod')) {
                System.debug('oppyId:'+oppyId+'won-close');
                newStage = 'Won - Closed';
            }
            else{
            	if(map_oppyId_oppyPartConfidenceSet.containsKey(oppyId)){
					if(map_oppyId_oppyPartConfidenceSet.get(oppyId).contains('Weak') || 
	                    map_oppyId_oppyPartConfidenceSet.get(oppyId).contains('50/50') ||
	                    map_oppyId_oppyPartConfidenceSet.get(oppyId).contains('Likely') ||
	                    map_oppyId_oppyPartConfidenceSet.get(oppyId).contains('Commit') ||
	                    map_oppyId_oppyPartConfidenceSet.get(oppyId).contains('On Hold')) {
	                    	
	                    if(map_oppyId_oppyPartConfidenceSet.get(oppyId).contains('Won')) {
	                        newStage = 'Won - Open';
	                    } 
	               	}   
            	}        
            }
            
            if(opp.StageName != newStage){
            	opp.StageName = newStage;
            	list_oppy2update.add(opp);
            }
        }

        if(!list_oppy2update.isEmpty()) {
            database.update(list_oppy2update,false);
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}