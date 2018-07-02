/**
    * This trigger is used to Calculate the average NPS_Sore__c for Account when Contact.NPS_Score__c changed
    *
    @author     Jinbo Shan
    @created    2013-09-11
    @version    1.0
    @since      23.0 (Force.com ApiVersion)
    *          
    *
    @changelog
    * 2013-09-11 Jinbo Shan <jinbo.shan@itbconsult.com>
    * - Created
    */
trigger Contact_AUD_updateAccountNPSScore on Contact (after delete, after update) {
    //************************* BEGIN Pre-Processing **********************************************

    set<String> set_accountIds = new set<String>();

    //************************* END Pre-Processing ************************************************

    //************************* BEGIN After Trigger ***********************************************
    // for update ,if the NPS_Score__c  have changed
    if(trigger.isUpdate){       
        for(Contact contact : trigger.new) {
            if(contact.NPS_Score__c != trigger.oldMap.get(contact.Id).NPS_Score__c || contact.Survey_Attended_Date__c != trigger.oldMap.get(contact.Id).Survey_Attended_Date__c ){ 
                set_accountIds.add(contact.AccountId);
            }
        }
    }else{    // for delete    
        for(Contact contact : trigger.old){
            if(contact.NPS_Score__c != null){  
                set_accountIds.add(contact.AccountId);
            }
        }       
    }
    
    // ************************* calculate the NPS Scroe of account as the contact *************************
    if(!set_accountIds.isEmpty()) {  
        ClsContactUtil.AVGForAccountNPSScoreOnContact(set_accountIds);
    }
    //************************* END After Trigger *************************************************
}