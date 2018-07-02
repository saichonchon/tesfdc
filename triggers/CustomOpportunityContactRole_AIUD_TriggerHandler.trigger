/**
* This trigger used to test the order of trigger execution Custom_Opportunity_Contact_Role__c.
*
* @author      Phil Hiemstra
* @created     2014-09-17
* @since       31.0 (Force.com ApiVersion)      
* @version     1.0 
*
* @changelog
* 2014-09-17 Phil Hiemstra <phil.hiemstra@te.com>
* - Created 
* 
*/

trigger CustomOpportunityContactRole_AIUD_TriggerHandler  on Custom_Opportunity_Contact_Role__c (after insert, after update, after delete) {
    
       
    
    // Update OpportunityContactRole
    
    map<Id, set<Custom_Opportunity_Contact_Role__c>> map_oppyId_conRoles = new map<Id, set<Custom_Opportunity_Contact_Role__c>>();
    map<Id, set<Custom_Opportunity_Contact_Role__c>> map_oppyId_conRoles4delete = new map<Id, set<Custom_Opportunity_Contact_Role__c>>();
    list<OpportunityContactRole> list_ocrs4inset = new list<OpportunityContactRole>();
    list<OpportunityContactRole> list_ocrs4update = new list<OpportunityContactRole>();
    list<OpportunityContactRole> list_ocrs4delete = new list<OpportunityContactRole>();
    set<Id> set_conRoleIds = new set<Id>();//all contact role Ids need to delete.
    
    if(!ClsPMV_Util.isRunningBatch) {
        if(trigger.isInsert){
            for(Custom_Opportunity_Contact_Role__c cocr : trigger.new) {
                OpportunityContactRole ocr = new OpportunityContactRole();
                ocr.ContactId = cocr.Contact__c;
                ocr.OpportunityId = cocr.Opportunity__c;
                ocr.Role = cocr.Role__c;
                ocr.IsPrimary = cocr.Primary__c;
                list_ocrs4inset.add(ocr);
            }
        }else {
            
            for(Custom_Opportunity_Contact_Role__c cocr : trigger.old){
                if(cocr.Opportunity__c != null && cocr.Contact__c != null){
                    if(!map_oppyId_conRoles4delete.containsKey(cocr.Opportunity__c)) map_oppyId_conRoles4delete.put(cocr.Opportunity__c, new set<Custom_Opportunity_Contact_Role__c>());
                    map_oppyId_conRoles4delete.get(cocr.Opportunity__c).add(cocr);
                }
            }
            
            if(map_oppyId_conRoles4delete.size() > 0) {
                for(OpportunityContactRole ocr : [SELECT Id, ContactId, OpportunityId FROM OpportunityContactRole WHERE OpportunityId IN : map_oppyId_conRoles4delete.keySet()]){
                    for(Custom_Opportunity_Contact_Role__c cocr : map_oppyId_conRoles4delete.get(ocr.OpportunityId)){
                        if(cocr.Contact__c == ocr.ContactId && !set_conRoleIds.contains(ocr.Id)){
                            list_ocrs4delete.add(ocr);
                            set_conRoleIds.add(ocr.Id);
                        }
                    }
                }
            }
            if(list_ocrs4delete.size()>0){
                delete list_ocrs4delete;
            }
            
            if(trigger.isUpdate){
                for(Custom_Opportunity_Contact_Role__c cocr : trigger.new) {
                    if(cocr.Opportunity__c != null && cocr.Contact__c != null){
                        if(!map_oppyId_conRoles.containsKey(cocr.Opportunity__c)) map_oppyId_conRoles.put(cocr.Opportunity__c, new set<Custom_Opportunity_Contact_Role__c>());
                        map_oppyId_conRoles.get(cocr.Opportunity__c).add(cocr);
                    }
                }
                
                if(map_oppyId_conRoles.size() > 0) {
                    for(OpportunityContactRole ocr : [SELECT Id, ContactId, OpportunityId FROM OpportunityContactRole WHERE OpportunityId IN : map_oppyId_conRoles.keySet()]){
                        for(Custom_Opportunity_Contact_Role__c cocr : map_oppyId_conRoles.get(ocr.OpportunityId)){
                            if(cocr.Contact__c == ocr.ContactId){
                                ocr.IsPrimary = cocr.Primary__c;
                                ocr.Role = cocr.Role__c;
                                list_ocrs4update.add(ocr);
                                map_oppyId_conRoles.get(ocr.OpportunityId).remove(cocr);
                            }
                        }
                    }
                }
                if(map_oppyId_conRoles.size() > 0){
                    for(Id oppyId : map_oppyId_conRoles.keySet()){
                        if(map_oppyId_conRoles.get(oppyId).size() > 0){
                            for(Custom_Opportunity_Contact_Role__c cocr : map_oppyId_conRoles.get(oppyId)){
                                OpportunityContactRole ocr = new OpportunityContactRole();
                                ocr.ContactId = cocr.Contact__c;
                                ocr.OpportunityId = cocr.Opportunity__c;
                                ocr.Role = cocr.Role__c;
                                ocr.IsPrimary = cocr.Primary__c;
                                list_ocrs4inset.add(ocr);
                            }
                        }
                    }
                }
            }
            
        }
        
        if(list_ocrs4inset.size() > 0){
            insert list_ocrs4inset;
        }
        
        if(list_ocrs4update.size() > 0){
            update list_ocrs4update;
        }
    }
    
     // Update NPS Score
        set<Id> set_deletedIds = new set<Id>(); 
        set<Id> set_oppyIds = new set<Id>();
        
        if(trigger.isDelete) {
            for(Custom_Opportunity_Contact_Role__c cocr : trigger.old) {
                set_oppyIds.add(cocr.Opportunity__c);
            }
        } else if(trigger.isInsert) {
            for(Custom_Opportunity_Contact_Role__c cocr : trigger.new) {
                set_oppyIds.add(cocr.Opportunity__c);
            }
        } else {
            for(Custom_Opportunity_Contact_Role__c cocr : trigger.new) {
                if(cocr.Opportunity__c != trigger.oldMap.get(cocr.Id).Opportunity__c || cocr.Contact__c != trigger.oldMap.get(cocr.Id).Contact__c) {
                    set_oppyIds.add(cocr.Opportunity__c);
                }
            }
        }
        
        if(set_oppyIds.size() > 0){
            ClsPMV_Util.updateOpportunityNPSScore(set_oppyIds, set_deletedIds);
        }
}