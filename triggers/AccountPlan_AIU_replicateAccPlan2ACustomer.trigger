/**
 *  Class to generate Snapshot of object account plan
 * 
 * @author Yuanyuan Zhang
 * @created 2012-05-24
 * @version 1.0
 * @since 23.0
 * 
 * return
 *
 * @changelog
 * 2012-05-24 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
 * - Created   
 *
 */

trigger AccountPlan_AIU_replicateAccPlan2ACustomer on Account_Plan__c (after insert, after update) {
    //************************* BEGIN Pre-Processing **********************************************
    //list<Account_Plan__c> list_accountPlan = new list<Account_Plan__c>();
    //************************* END Pre-Processing ************************************************
    //************************* BEGIN Before Trigger **********************************************
    if(trigger.isInsert){
        //ClsAccountPlanUtility.replicateAccountPlan2ACustomer(trigger.new, null);
    }
    else{
        ClsAccountPlanUtility.replicateAccountPlan2ACustomer(trigger.new, trigger.oldMap);
    }
    
    
    //************************* END Before Trigger ************************************************
    
    //************************* BEGIN After Trigger ***********************************************
    
    //************************* END After Trigger *************************************************
    
}