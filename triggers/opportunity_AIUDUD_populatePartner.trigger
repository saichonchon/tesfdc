/**
 * This trigger used to populate Partner on Opportunity Level.
 *
 * @author      Yinfeng Guo
 * @created     2012-02-28
 * @since       23.0 (Force.com ApiVersion)      
 * @version     1.0 
 *
 * @changelog
 * 2012-02-28 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Created 
 * 
 */
trigger opportunity_AIUDUD_populatePartner on Opportunity (after delete, after insert, after undelete, 
after update) {

    String triggerName = 'Opportunity';
    Boolean isRun = true;
    //************************* BEGIN Pre-Processing **********************************************
    //System.debug('************************* ' + triggerName + ': BEGIN Pre-Processing ********');
    //************************* END Pre-Processing ************************************************
    //System.debug('************************* ' + triggerName + ': END Pre-Processing **********');
    
    //************************* BEGIN Before Trigger **********************************************
    //************************* END Before Trigger ************************************************
    
    //************************* BEGIN After Trigger ***********************************************
    
    Trigger_Configuration__c tc = Trigger_Configuration__c.getInstance('Populate Opportunity Partner');
    if(tc != null) isRun = tc.isRun__c;
    
    if(isRun){
        if(Trigger.isAfter) {
            System.debug('************************* ' + triggerName + ': After Trigger *************');
            if(trigger.isInsert || trigger.isUnDelete) {
                String mode;
                map<Id,Id> map_oppId_accId_new = new map<Id,Id>();
                /****Added by Abhijeet 24-7-2013
                **vNDRAccID receves the id of the 'Unidentified Account for NDR' account
                */
                
                Apex_Helper_Settings__c vNDRAccId = Apex_Helper_Settings__c.getInstance('Unidentified Account for NDR');
                for (Opportunity opp : trigger.new) {
                    //Added 'opp.AccountId != vNDRAccId.Value__c' condition in If to prevent creation of Opportunity partner 
                    //when End account 'Unidentified Account for NDR'.
                    if(opp.AccountId != null && opp.AccountId != vNDRAccId.Value__c){
                        map_oppId_accId_new.put(opp.Id, opp.AccountId);
                    } 
                }  
                if(!map_oppId_accId_new.isEmpty()){
                    mode = ClsOppyPartUtil.MODE_INSERT;
                    ClsOppyPartUtil.PopulateOpptyPartner(mode, map_oppId_accId_new, null);
                } 
            }
            else if(trigger.isUpdate){
                String mode;
                map<Id,Id> map_oppId_accId_old = new map<Id,Id>();
                map<Id,Id> map_oppId_accId_new = new map<Id,Id>();
                for(Opportunity opp : trigger.new) {
                    if(opp.AccountId != null && opp.AccountId != trigger.oldMap.get(opp.Id).AccountId){
                        //Whenever account on opportunity changes, we need to update the "primary" account with the new one. 
                        if(trigger.oldMap.get(opp.Id).AccountId != null) map_oppId_accId_old.put(opp.Id, trigger.oldMap.get(opp.Id).AccountId);
                        map_oppId_accId_new.put(opp.Id, opp.AccountId);
                    } 
                    
                }   
                if(!map_oppId_accId_old.isEmpty() || !map_oppId_accId_new.isEmpty()){
                    mode = ClsOppyPartUtil.MODE_UPDATE;
                    ClsOppyPartUtil.PopulateOpptyPartner(mode, map_oppId_accId_new, map_oppId_accId_old);
                }    
            }
        }
    }   
    //************************* END After Trigger *************************************************
}