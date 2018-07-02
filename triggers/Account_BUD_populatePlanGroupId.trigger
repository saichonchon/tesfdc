/**
 * This trigger used to populate the plan group id
 *
 * @author      Min Liu
 * @created     2012-09-10
 * @since       23.0 (Force.com ApiVersion)      
 * @version     1.0 
 *
 * @changelog
 * 2012-09-10 Min Liu <min.liu@itbconsult.com>
 * - Created 
 * 
 * 
 * 2013-5-30 Modified by Xiaona Liu<xiaona.liu@itbconsult.com>
 * update This is used to update plan group account
 */
trigger Account_BUD_populatePlanGroupId on Account (before delete, before update) {
    //
    
    //*******************************************************************
    //START: This is used to update plan group account
    // by xiaona liu at 2013-5-30 
    //
    if(trigger.isUpdate){
        ClsAccountUtil.updatePlanGroupAccount(trigger.newMap, trigger.oldMap);
    }
    
    //*******************************************************************
    //END: This is used to update plan group account
    // by xiaona liu at 2013-5-30 
    //*******************************************************************
    
    
    
    // when insert
    // insert is doing in workflow

    // when update
    //else if(trigger.isUpdate){
    
    //*******************************************************************
    //START: comment line
    // by xiaona liu at 2013-5-30 
    //*******************************************************************
    /*
    if(trigger.isUpdate){
        Map<Id, Boolean> map_parentId_planned = new Map<Id, Boolean>();     
        for(Account acc :Trigger.New){
            if(acc.Plan_Group_Id__c == Trigger.oldMap.get(acc.id).Plan_Group_Id__c){
                // only Individually_Planned__c or Plan_Group_Account__c is changed
                if(acc.Individually_Planned__c != Trigger.oldMap.get(acc.id).Individually_Planned__c || acc.Plan_Group_Account__c != Trigger.oldMap.get(acc.id).Plan_Group_Account__c){
                    if(acc.Plan_Group_Account__c == null) {
                        if(acc.Individually_Planned__c) acc.Plan_Group_Id__c = String.valueOf(acc.id).subString(0, 15);
                        else{
                            acc.Plan_Group_Id__c = '';
                            map_parentId_planned.put(acc.id, acc.Individually_Planned__c);
                        }
                    }
                    else{
                        if(!acc.Individually_Planned__c) acc.Plan_Group_Id__c = String.valueOf(acc.Plan_Group_Account__c).subString(0, 15);
                        else{
                            acc.Plan_Group_Id__c = String.valueOf(acc.id).subString(0, 15);
                            acc.Plan_Group_Account__c = null;
                        }                       
                        if(Trigger.oldMap.get(acc.id).Plan_Group_Account__c == null) map_parentId_planned.put(acc.id, acc.Individually_Planned__c);                 
                    }                   
                }
            }           
        }
        if(!map_parentId_planned.isEmpty()) ClsBudgetPlanningUtil.updatePlanGroupId(null, map_parentId_planned, 'trigger', 'update');
    }
    
    // when delete
    else if(trigger.isDelete){
        Map<Id, Boolean> map_parentId_planned = new Map<Id, Boolean>();
        for(Account acc :Trigger.old){
            if(acc.Plan_Group_Account__c == null) {
                map_parentId_planned.put(acc.id, acc.Individually_Planned__c);
            }
        }
        if(!map_parentId_planned.isEmpty()) ClsBudgetPlanningUtil.updatePlanGroupId(null, map_parentId_planned, 'trigger', 'delete');
    }
    */
    
    
    //*******************************************************************
    //START: comment line
    // by xiaona liu at 2013-5-30 
    //*******************************************************************
}