/**
*   This trigger is used to add Oppty owner to oppty team when insert oppty or update oppty owner -- For Consumer Device Oppty and DND oppty
*   which record type is: Engineering Opportunity-CSD or Sales Opportunity-CSD,DND Opportunity.
*
@  author Michael Cui
@  created 2014-06-23

@  updated by Nelson Zheng for case 00806794 3/10/2015
@  updated by Padmaja Dadi for PT-02338 06/29/2015
*
*/
trigger opportunity_AIAU_AddOpptyTeam on Opportunity (after insert, after update) 
{
    List<OpportunityTeamMember> newOpptyTeamMembers = new List<OpportunityTeamMember>();
    map<Id,set<Id>> map_oppyId_userId = new map<Id,set<Id>>();
    List<OpportunityShare> list_share = new List<OpportunityShare>();
    if(Trigger.isInsert)
    {
        for (Opportunity opp : trigger.new) 
        {
        //Added by Padmaja Dadi DND Opportunity record type for DND merge project
            if(opp.OwnerId != null && (opp.Record_Type_Name__c =='Engineering_Opportunity_CSD' || opp.Record_Type_Name__c =='Sales_Opportunity_CSD' || opp.Record_Type_Name__c == 'DND_Opportunity'))
            {
                newOpptyTeamMembers.add(new OpportunityTeamMember(OpportunityId = opp.Id, UserId=opp.OwnerId));
                if(map_oppyId_userId.containskey(opp.Id))
                {
                    map_oppyId_userId.get(opp.Id).add(opp.OwnerId);
                }
                else
                {
                    map_oppyId_userId.put(opp.Id, new set<id>());
                    map_oppyId_userId.get(opp.Id).add(opp.OwnerId);
                }
            }
        }
    }
    if(Trigger.isUpdate)
    {
        for (Opportunity opp : trigger.new) 
        {
            //add '&& trigger.oldMap.get(opp.Id).Opportunity_Owner_IsActive__c' by Nelson Zheng
            //Added by Padmaja Dadi DND Opportunity record type for DND merge project 
            if(trigger.oldMap.get(opp.Id).OwnerId != opp.OwnerId && trigger.oldMap.get(opp.Id).Opportunity_Owner_IsActive__c && (opp.Record_Type_Name__c =='Engineering_Opportunity_CSD' || opp.Record_Type_Name__c =='Sales_Opportunity_CSD' || opp.Record_Type_Name__c == 'DND_Opportunity'))
            {
                newOpptyTeamMembers.add(new OpportunityTeamMember(OpportunityId = opp.Id, TeamMemberRole = 'Previous Owner', UserId=trigger.oldMap.get(opp.Id).OwnerId));
                if(map_oppyId_userId.containskey(opp.Id))
                {
                    map_oppyId_userId.get(opp.Id).add(trigger.oldMap.get(opp.Id).OwnerId);
                }
                else
                {
                    map_oppyId_userId.put(opp.Id, new set<id>());
                    map_oppyId_userId.get(opp.Id).add(trigger.oldMap.get(opp.Id).OwnerId);
                }
            }
        }
    }
    if(newOpptyTeamMembers.size()>0)
    {
        insert newOpptyTeamMembers;
        for(OpportunityShare share: [select Id, OpportunityAccessLevel,RowCause,UserOrGroupId,OpportunityId from OpportunityShare where OpportunityId IN :map_oppyId_userId.keySet() and RowCause = 'Team' and OpportunityAccessLevel != 'Edit']){
            if(map_oppyId_userId.get(share.OpportunityId).contains(share.UserOrGroupId))
            {
                share.OpportunityAccessLevel = 'Edit';
                list_share.add(share);
            }
        }
        if(!list_share.isEmpty()) update list_share;
    }
}