/**
*   This trigger is used to recalculate NPS2,NPS3 value when update initial Billing date/initial order date on oppty 
*   -- only for Appliance Oppty which oppty record type is: Opportunity - Engineering Project or Opportunity - Product Platform  
*   or Opportunity - Sales Project. Case 00689465.
*
@  author Michael Cui
@  created 2014-07-15

** edited by nelson zheng 01-21-2015
** case 00783570 by Nelson Zheng 01-20-2015
*
*/
trigger opportunityPart_AU_RecalculateNPSMSG on Opportunity_Part__c (before update)//change from after update to before update 
{
	/*comment by nelson zheng 01-21-2015
    if( !APL_One_Time_Execution.batchRun && APL_One_Time_Execution.canTrigger('opportunityPart_AU_RecalculateNPSMSG')){
        
        CSD_Utils_Class.recalcuNPSMSGonOppyPart(Trigger.New);
    } */ 
    
    //add by nelson zheng 01-21-2015
    System.debug('-----------------ran--------------------');
    Set<Id> oppIdSet = new Set<Id>();
    if(Trigger.isupdate){
	    for(Opportunity_Part__c oppPart : Trigger.new){
	    	oppPart.need_recalculate_PartNPSMSGRevenue__c = true;
	    	oppIdSet.add(oppPart.Opportunity__c);
	    }
    }
    //added by nelson 05/29/2015
    APL_Utils_Class.updateNPSMSGonPartNew(oppIdSet);
    /*
    Set<Id> managerId = new Set<Id>();
    
    for(Opportunity_Part__c oPart : Trigger.new){
    	
        managerId.add(oPart.Opportunity_Owner_Manager__c);
    }
    System.debug('--------------managerId--------------'+managerId);
    Map<Id,User> managerMap = new Map<Id,User>([select Id,Email from User where Id in: managerId]);
    System.debug('--------------managerMap--------------'+managerMap);
    for(Opportunity_Part__c oPart : Trigger.new){
        User manager = managerMap.get(oPart.Opportunity_Owner_Manager__c);
        if(manager != null){
            oPart.Manager_s_email__c = manager.Email;
        }
    } */ 
}