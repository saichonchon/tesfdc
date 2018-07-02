/**
 * This class is OpportunityPartner's class.
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
public class OpportunityPartnerTrgHandler extends ClsTriggerVirtual{
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
		if(trgCtx.isAfter) return;        
    }
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
        if(trgCtx.isBefore) return;
        
        //set Opportunity__Code__c for OpportunityPartner
        updateOppyGamCode(trgCtx);
    }
    
    public void updateOppyGamCode(ClsWrappers.TriggerContext trgCtx) {
       	String currentProfileId = '';
        set<String> set_oppyIds = new set<String>();
        set<String> set_profileIds = new set<String>();
        list<Opportunity> list_oppys = new list<Opportunity>();
        list<Sobject> list_oppyPartners = new list<Sobject>();
        list<OpportunityPartnerTrgHelper__c> list_oppyPartnerHelpers = new list<OpportunityPartnerTrgHelper__c>();
        
        list_oppyPartnerHelpers = OpportunityPartnerTrgHelper__c.getall().values();
        
        for(OpportunityPartnerTrgHelper__c oppyPH : list_oppyPartnerHelpers) {
            if(String.valueOf(oppyPH.Value__c).length() >= 3) {
                if(oppyPH.Value__c.substring(0,3) == '00e') {//Profile
                    if(String.valueOf(oppyPH.Value__c).length() >= 15)
                    set_profileIds.add(String.valueOf(oppyPH.Value__c).substring(0,15)); 
                }
            }
        }
        
        currentProfileId = UserInfo.getProfileId();
        currentProfileId = currentProfileId.substring(0,15);
        
        if(!set_profileIds.contains(currentProfileId)) {
            return ;
        }
        
        if(trgCtx.isInsert || trgCtx.isUnDelete) {
            set_oppyIds = ClsOppyPartnerUtil.getOppyIds(trgCtx.newList);
        }else if(trgCtx.isUpdate) {
            //list_oppyPartners
            //get oppyPartners when update
            for(String oppyId : trgCtx.newMap.keySet()) {
                if(trgCtx.oldMap.get(oppyId).get('Opportunity__c') != trgCtx.newMap.get(oppyId).get('Opportunity__c') ||
                   trgCtx.oldMap.get(oppyId).get('Account__c') != trgCtx.newMap.get(oppyId).get('Account__c')) {
                    list_oppyPartners.add(trgCtx.newMap.get(oppyId));
                    list_oppyPartners.add(trgCtx.oldMap.get(oppyId));
                }
            }
            set_oppyIds = ClsOppyPartnerUtil.getOppyIds(list_oppyPartners);
        } 
        else if(trgCtx.isDelete) {
            set_oppyIds = ClsOppyPartnerUtil.getOppyIds(trgCtx.oldList);
        }
        
        if(set_oppyIds.size() > 0) {
            //get Opportunity_Gam_Code__c in Opportunity according to OpportunityPartner
            if(trgCtx.isInsert || trgCtx.isUnDelete || trgCtx.isUpdate) {
                list_oppys = ClsOppyPartnerUtil.updateOppyGamCodebyTriggerData(set_oppyIds,trgCtx.newList);
            }else if(trgCtx.isDelete) {
            	list_oppys = ClsOppyPartnerUtil.updateOppyGamCode(set_oppyIds);
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