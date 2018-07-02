/**
    * This trigger is used to Calculate the average NPS_Sore__c for the related opportunity when Custom_Opportunity_Contact_Role__c update insert or delete
    *
    @author     Jinbo Shan
    @created    2014-06-06
    @version    1.0
    @since      29.0 (Force.com ApiVersion)
    *          
    *
    @changelog
    * 2014-06-06 Jinbo Shan <jinbo.shan@itbconsult.com>
    * - Created
    */
trigger CustomOpportunityContactRole_AIUD_updateOppyNPSScore on Custom_Opportunity_Contact_Role__c (after delete, after insert, after update) {
    
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