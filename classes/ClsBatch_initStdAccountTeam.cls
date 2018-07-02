/**
 *  Contains a set of static methods used in invoice creation triggers and VF pages
 *
 @author Bin Yuan
 @created 2012-01-05
 @version 1.0
 @since 25.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-04-17 Bin Yu <bin.yu@itbconsult.com>
 * - excluded the Chatter free user from account team
 * 2012-01-05 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created
 */

global class ClsBatch_initStdAccountTeam implements Database.Batchable<SObject> {

    /**
     * the email address to tell people the status of the batch class after run the batch class
     * before run the batch class, we can define the email manual
     * if not define email address, after the batch completed, will not send email
     */ 
    public String email;
    Public String chatterFreeUser = 'Chatter Free User';
    
    /**
     * the sql query statement that will select the data will be used in this batch class
     */ 
    public String query;

    /**
     * the record type id for gam account, the value get from custom setting
     */     
    global final Id rt_cis_gam = ClsSharingUtil.gamCustomSetting();
    global final set<String> set_role = new set<String>{'Account Manager (AM)','Relay Specialist (IS)','Field Engineer (FE)','Global Account Manager (GAM)','Tubing FE (MM)','Field Service Engineer (FSE)'};
    global map<string,integer>  map_access_int = new  map<string,integer>{
        'Edit' => 3,
        'Read-Only' => 2,
        'No Access' => 1
    } ; 
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        if (query == '' || query == null){
            query = 'Select Id, ParentId, RecordTypeId, Public_Group_Id__c from Account'; // where Id = \'001E000000BzPdwIAF\'' ;
        }
        return Database.getQueryLocator(query);  
    }

    global void execute(Database.BatchableContext BC, List<Account> list_accounts){
        set<Id> set_accountIds = new set<Id>();
        map<Id, Account_Team__c> map_acctTeamId_acctTeam = new map<Id, Account_Team__c>();
        map<Id,map<Id,Account_Team__c>> map_accId_uId_atm = new map<Id,map<Id,Account_Team__c>>();
        for(Account acct : list_accounts) {
            set_accountIds.add(acct.Id);
        }
        
        for(Account_Team__c acctTeam : [SELECT Account__c, Name, Opportunity_Access__c, ConnectionReceivedId, Id, RecordTypeId, 
                                               Role__c, ConnectionSentId, Team_Member_Contact__c, Team_Member_Formula__c, 
                                               Team_Member__c, Team_Member_txt__c, Team_Member_Key__c, View__c 
                                        FROM   Account_Team__c
                                        WHERE  Account__c IN : set_accountIds 
                                        AND    RecordType.DeveloperName = 'SFDC_User' and Team_Member__r.IsActive = true and Team_Member__r.Profile.Name != :chatterFreeUser]) { //added ' and Team_Member__r.Profile.Name != :chatterFreeUser' by BYU at 2014-04-17 
            
            // check opportunity access
            if(!map_accId_uId_atm.containsKey(acctTeam.Account__c)){
                map_accId_uId_atm.put(acctTeam.Account__c, new map<Id,Account_Team__c>());
            }
            
            if(map_accId_uId_atm.get(acctTeam.Account__c).containsKey(acctTeam.Team_Member__c)){
                Account_Team__c temp = map_accId_uId_atm.get(acctTeam.Account__c).get(acctTeam.Team_Member__c);
                if(!set_role.contains(temp.Role__c)){
                    if(map_access_int.get(temp.Opportunity_Access__c) < map_access_int.get(acctTeam.Opportunity_Access__c)){
                        map_accId_uId_atm.get(acctTeam.Account__c).put(acctTeam.Team_Member__c,acctTeam);
                    }   
                }
            }else{
                map_accId_uId_atm.get(acctTeam.Account__c).put(acctTeam.Team_Member__c,acctTeam);
            }
                                        
        }

        
        list<Account_Team__c> list_tmp = new list<Account_Team__c>();
        for(Id accId: map_accId_uId_atm.keyset()){
            list_tmp.addAll(map_accId_uId_atm.get(accId).values());
        }
        //Delete old standard account team members by using set_accountIds.
        ClsAccountTeamUtil.deleteOldStdAccountTeam(set_accountIds);
        //Copy custom account team members' information to create new standard account team members.
        if(!list_tmp.isEmpty()){
            ClsAccountTeamUtil.generateStdAcctTeamFromCustomAcctTeam(list_tmp);
        }           
        
    }

    global void finish(Database.BatchableContext BC){ 
        if(email != null) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] {email});
            mail.setReplyTo(Email);
            mail.setSenderDisplayName('Cleanup job');
            mail.setSubject('Batch Processing ClsBatch_AccountSharing Completed');
            mail.setPlainTextBody('Batch Processing ClsBatch_AccountSharing has completed');
            //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        } 
    }   
    
}