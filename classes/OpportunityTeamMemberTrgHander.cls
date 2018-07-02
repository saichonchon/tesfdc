/**
 * This class is OpportunityTeamMember's class.
 * 
 * @author		Chen Chen
 * @created		2017-03-21
 * @since 		39.0 (Force.com ApiVersion)
 * @version 	1.0
 * 
 * @changelog
 * 2017-03-21 Chen Chen <chen.chen@oinio.com>
 * - Created
 */
public class OpportunityTeamMemberTrgHander extends ClsTriggerVirtual{
	 public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
		if(trgCtx.isAfter) return;        
    }
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
        if(trgCtx.isBefore) return;
        
        //set Opportunity_Sales_Team__c for OpportunityPartner
        updateOppySalesTeam(trgCtx);
    }
    public void updateOppySalesTeam(ClsWrappers.TriggerContext trgCtx) {
        String currentProfileId = '';
        set<String> set_oppyIds = new set<String>();
        set<String> set_profileIds = new set<String>();
        list<Opportunity> list_oppys = new list<Opportunity>();
        list<Sobject> list_oppyTeamMember = new list<Sobject>();
        list<OpportunityTeamMemberTrgHelper__c> list_oppyTeamHelpers = new list<OpportunityTeamMemberTrgHelper__c>();
        
        list_oppyTeamHelpers = OpportunityTeamMemberTrgHelper__c.getall().values();//get profileId From custom setting
        for(OpportunityTeamMemberTrgHelper__c oppyPH : list_oppyTeamHelpers) {
            if(String.valueOf(oppyPH.Value__c).length() >= 3) {
                if(oppyPH.Value__c.substring(0,3) == '00e') {//Profile
                    if(String.valueOf(oppyPH.Value__c).length() >= 15)
                    set_profileIds.add(String.valueOf(oppyPH.Value__c).substring(0,15)); 
                }
            }
        }
        
        //get Current User Id
        currentProfileId = UserInfo.getProfileId();
        currentProfileId = currentProfileId.substring(0,15);
        
        if(!set_profileIds.contains(currentProfileId)) {
            return ;
        }
        
        if(trgCtx.isInsert || trgCtx.isUnDelete) {
            set_oppyIds = ClsOppyTeamMemberUtil.getOppyIds(trgCtx.newList);
        }else if(trgCtx.isUpdate) {
            //get oppyTeamMember when update
            for(String oppyId : trgCtx.newMap.keySet()) {
                if(trgCtx.oldMap.get(oppyId).get('OpportunityId') != trgCtx.newMap.get(oppyId).get('OpportunityId') ||
                   trgCtx.oldMap.get(oppyId).get('UserId') != trgCtx.newMap.get(oppyId).get('UserId') ||
                   trgCtx.oldMap.get(oppyId).get('TeamMemberRole') != trgCtx.newMap.get(oppyId).get('TeamMemberRole')) {
                    list_oppyTeamMember.add(trgCtx.newMap.get(oppyId));
                    list_oppyTeamMember.add(trgCtx.oldMap.get(oppyId));
                }
            }
            set_oppyIds = ClsOppyTeamMemberUtil.getOppyIds(list_oppyTeamMember);
        } 
        else if(trgCtx.isDelete) {
            set_oppyIds = ClsOppyTeamMemberUtil.getOppyIds(trgCtx.oldList);
        }
        
        if(set_oppyIds.size() > 0) {
            //get OpportunitySalesTeam in Opportunity according to OpportunityPartner
            if(trgCtx.isInsert || trgCtx.isUnDelete || trgCtx.isUpdate) {
                list_oppys = ClsOppyTeamMemberUtil.updateOppySalesTeambyTriggerData(set_oppyIds,trgCtx.newList);
            }else if(trgCtx.isDelete) {
            	list_oppys = ClsOppyTeamMemberUtil.updateOppySalesTeam(set_oppyIds);
            }
        }
        if(list_oppys.size() > 0) {
            try{
            	update list_oppys;
            }catch(exception ex){
                throw new ClsTriggerException('Update Opportunity Fail : '+ ex);
            }
        }
    }
}