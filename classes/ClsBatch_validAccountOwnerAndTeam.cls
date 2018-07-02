/**
 *  Batch class to valid account team member and account owner.
 * 
 * @author Yuanyuan Zhang
 * @created 2012-06-08
 * @version 1.0
 * @since 24.0
 * 
 * return
 *
 * @changelog
 * 2012-06-08 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
 * - Created   
 *
 */

global class ClsBatch_validAccountOwnerAndTeam implements Database.Batchable<SObject>,Database.Stateful{
    
    /**
     * the sql query statement that will select the data will be used in this batch class
     */ 
    public String query;
    
    /**
     * the email address to tell people the status of the batch class after run the batch class
     * before run the batch class, we can define the email manual
     * if not define email address, after the batch completed, will not send email
     */ 
    public String email;
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        if (query == null || query == ''){
            query = 'SELECT Sales_Hierarchy__c, AM_Prime_Territory__c, Account__c, CurrencyIsoCode, Description, Id, Account_Manager__c, Account_Manager_Name__c, Account_Manager_Territory__c, Name, Customer_Region__c, FE_Hierarchy__c, GAMCD__c, My_Hierarchy_Code__c, ConnectionReceivedId, RecordTypeId, Relay_Hierarchy__c, ConnectionSentId FROM Account';// where Id = \'001M000000BQJqY\'' ;
        }
        return Database.getQueryLocator(query); 
    }

    global void execute(Database.BatchableContext BC, list<Account> list_accounts){
        set<String> set_netWorkIds = new set<String>();//contains all network ids for query user.
        map<Id, Account> map_accId_account = new map<Id, Account>();//use to Validate Account Team Members
        map<Id, list<Account>> map_salesHierId_list_accounts = new map<Id, list<Account>>();
        map<Id, set<String>> map_saleshierId_set_netWorkId = new map<Id, set<String>>();//map store sales hierarchy id and correspondings network id
        map<String,Id> map_netWorkId_userId = new map<String,Id>();//map store network id and correspondings network id.
        set<Id> set_allAccId = new set<Id>();
        list<Account> list_account2Update = new list<Account>();
        list<Account_Team__c> list_atm2Insert = new list<Account_Team__c>();
        list<Account_Team__c> list_atm2Del = new list<Account_Team__c>();
        //Map 
        map<Id, String> map_accId_set_AMInfo = new map<Id, String>();
        
        if(list_accounts.size() != 0){
            for(Account acc : list_accounts){
            	set_allAccId.add(acc.Id);
                if(acc.Sales_Hierarchy__c != null){
                    map_accId_account.put(acc.Id, acc);
                    list<Account> list_temp = new list<Account>();
                    if(map_salesHierId_list_accounts.containsKey(acc.Sales_Hierarchy__c)){
                        list_temp = map_salesHierId_list_accounts.get(acc.Sales_Hierarchy__c);
                    }
                    list_temp.add(acc);
                    map_salesHierId_list_accounts.put(acc.Sales_Hierarchy__c, list_temp);
                }
            }
            /*
            * START : Validate Account Manager
            */
            if(!map_salesHierId_list_accounts.isEmpty()){
                for(Sales_Hierarchy__c sh : [SELECT Character_Count__c, 
                                                    CurrencyIsoCode, 
                                                    DefaultOwnerActive__c, 
                                                    Hierarchy_Type__c, 
                                                    Level_7_Assigned_User_Names__c, 
                                                    Level_7_Assigned_User_Network_Ids__c, 
                                                    Level_7_Assigned_Users__c, 
                                                    Level_7_Default_Owner__c, 
                                                    Level_7_Territory_Code__c, 
                                                    Level_7_Territory_Name__c, 
                                                    My_Hierarchy_Code__c, 
                                                    OwnerId, 
                                                    ConnectionReceivedId, 
                                                    Id, 
                                                    Name, 
                                                    ConnectionSentId, 
                                                    Test_RTF__c 
                                             FROM Sales_Hierarchy__c
                                             WHERE Id IN :map_salesHierId_list_accounts.keySet()]){
                    if(sh.Level_7_Default_Owner__c != null){
                        for(Account acc : map_salesHierId_list_accounts.get(sh.Id)){
                            if(acc.Account_Manager__c != sh.Level_7_Default_Owner__c){
                                acc.Account_Manager__c = sh.Level_7_Default_Owner__c;
                                list_account2Update.add(acc);
                                String aminfo = sh.Level_7_Assigned_User_Network_Ids__c + ';' + sh.Level_7_Default_Owner__c;
                                map_accId_set_AMInfo.put(acc.Id, aminfo);
                            }
                            
                        }
                    }
                    else if(sh.Level_7_Assigned_User_Network_Ids__c != null){
                        set<String> set_temp = new set<String>();
                        if(map_saleshierId_set_netWorkId.containsKey(sh.Id)){
                            set_temp = map_saleshierId_set_netWorkId.get(sh.Id);
                        }
                        if(sh.Level_7_Assigned_User_Network_Ids__c.contains(';')){
                            for(String netWorkerId : sh.Level_7_Assigned_User_Network_Ids__c.split(';')){
                                set_netWorkIds.add(netWorkerId);
                                set_temp.add(netWorkerId);
                            }
                        }
                        else{
                            set_netWorkIds.add(sh.Level_7_Assigned_User_Network_Ids__c);
                            set_temp.add(sh.Level_7_Assigned_User_Network_Ids__c);
                        }
                        map_saleshierId_set_netWorkId.put(sh.Id,set_temp);
                    }
                }
                if(!set_netWorkIds.isEmpty()){
                    Id castIronSeviceId = (Id)Apex_Helper_Settings__c.getInstance('TEIS Admin User Id').Value__c;
                    //Id castIronSeviceId = [SELECT Id, Name FROM User WHERE Name = 'TEIS Admin' LIMIT 1].Id;
                    for(User u : [SELECT Id, 
                                         Te_Network_Id__c, 
                                         IsActive 
                                  FROM User 
                                  WHERE Te_Network_Id__c IN :set_netWorkIds
                                  AND IsActive = true]){
                        map_netWorkId_userId.put(u.Te_Network_Id__c, u.Id);
                    }
                    for(Id shId : map_salesHierId_list_accounts.keySet()){
                        if(map_saleshierId_set_netWorkId.containsKey(shId)){
                            Id userId;
                            String teNetWorkId;
                            Boolean isContains = false;
                            for(String netWorkId : map_saleshierId_set_netWorkId.get(shId)){
                                if(map_netWorkId_userId.containsKey(netWorkId)){
                                    userId = map_netWorkId_userId.get(netWorkId);
                                    teNetWorkId = netWorkId;
                                    isContains = true;
                                    break;
                                }
                            }
                            if(isContains){
                                for(Account acc : map_salesHierId_list_accounts.get(shId)){
                                	if(userId != null && acc.Account_Manager__c != userId){
	                                    acc.Account_Manager__c = userId;
	                                    list_account2Update.add(acc);
	                                    if(!map_accId_set_AMInfo.containsKey(acc.Id)){
	                                    	String aminfo = teNetWorkId + ';' + userId;
                                			map_accId_set_AMInfo.put(acc.Id, aminfo);
	                                    }
	                                }
                                }
                            }
                            else{
                                for(Account acc : map_salesHierId_list_accounts.get(shId)){
                                	if(acc.Account_Manager__c != castIronSeviceId){
	                                    acc.Account_Manager__c = castIronSeviceId;
	                                    list_account2Update.add(acc);
                                	}
                                }
                            }
                        }
                    }
                }
            }
            if(list_account2Update.size() != 0){
                update list_account2Update;
            }
        }
        /*
        * END : Validate Account Manager
        */
        /*
        * START : Validate Account Team Members
        */
        map<String, list<Account_Team__c>> map_teId_list_accountTeamMember = new map<String, list<Account_Team__c>>();
        map<id, string> map_new_aid_uidList_ForAccountTeamMember = new map<id, string>();
        map<id, string> map_old_aid_uidList_ForAccountTeamMember = new map<id, string>();
        map<Id, Account_Team__c> map_atId_accountTeamMember = new map<Id, Account_Team__c>();
        list<Account_Team__c> list_accountTeam2Del = new list<Account_Team__c>();
        list<Account_Team__c> list_accountTeam2update = new list<Account_Team__c>();
        Id sFDCRt = [SELECT Id FROM RecordType WHERE DeveloperName = 'SFDC_User' Limit 1].Id;
        Boolean fisrtTime = true;
        
        String rolesList;
        set<String> set_roles = new set<String>();
        if(Apex_Helper_Settings__c.getInstance('Custom Account Team Roles') != null) rolesList = Apex_Helper_Settings__c.getInstance('Custom Account Team Roles').Value__c;
        for(String role : rolesList.split(';')){
            set_roles.add(role);
        }
        
        
        for(Account_Team__c atm : [SELECT Account__c,
                                          Account__r.Sales_Hierarchy__c,
                                          Account__r.FE_Hierarchy__c,
                                          Account__r.FE_Hierarchy__r.Level_7_Assigned_User_Network_Ids__c,
                                          Account__r.GAMCD__c,
                                          Account__r.Sales_Hierarchy__r.Level_7_Territory_Code__c,
                                          Account__r.Sales_Hierarchy__r.Hierarchy_Type__c,
                                          Account__r.Sales_Hierarchy__r.Level_7_Assigned_User_Network_Ids__c,
                                          Account__r.Relay_Hierarchy__c,
                                          Account__r.Relay_Hierarchy__r.Level_7_Assigned_User_Network_Ids__c,
                                          Name, 
                                          Id, 
                                          RecordTypeId,
                                          RecordType.Name, 
                                          Role__c, 
                                          TE_Network_Id__c, 
                                          Team_Member__c,
                                          Team_Member__r.IsActive, 
                                          View__c 
                                     FROM Account_Team__c
                                     WHERE Account__c IN :set_allAccId
                                     AND Account__c != null 
                                     AND Role__c IN :set_roles
                                     /*AND (Role__c = 'Account Manager (AM)'
                                     OR Role__c = 'Global Account Manager (GAM)'
                                     OR Role__c = 'Field Engineer (FE)' 
                                     OR Role__c = 'Relay Specialist (IS)')*/]){
            map_atId_accountTeamMember.put(atm.Id, atm);
            if(atm.Team_Member__c != null){
                if(atm.RecordType.Name == 'SFDC User'){
                    if(!atm.Team_Member__r.IsActive){
                        list_accountTeam2Del.add(atm);
                        map_atId_accountTeamMember.remove(atm.Id);
                        if(!map_old_aid_uidList_ForAccountTeamMember.containsKey(atm.Account__c)) {
                            map_old_aid_uidList_ForAccountTeamMember.put(atm.Account__c, atm.Team_Member__c);
                        } 
                        else {
                            String uids = map_old_aid_uidList_ForAccountTeamMember.get(atm.Account__c);
                            map_old_aid_uidList_ForAccountTeamMember.put(atm.Account__c, uids + ',' + atm.Team_Member__c);
                        }	                                               
                    }
                }
            }
            //2012-08-17 if there are account team with same role/user/networkid in database, then dont do insert.
            if(map_accId_set_AMInfo.containsKey(atm.Account__c) && atm.Role__c == 'Account Manager (AM)'){
            	list<String> list_temp = map_accId_set_AMInfo.get(atm.Account__c).split(';');
            	if(atm.Team_Member__c == list_temp[1] && atm.TE_Network_Id__c == list_temp[0]){
            		map_accId_set_AMInfo.remove(atm.Account__c);
            	}
            	if(atm.Team_Member__c != null){
            		if(!map_new_aid_uidList_ForAccountTeamMember.containsKey(atm.Account__c)) {
	            		map_new_aid_uidList_ForAccountTeamMember.put(atm.Account__c, atm.Team_Member__c);
		            }
		            else {
		                String uids = map_new_aid_uidList_ForAccountTeamMember.get(atm.Account__c);
		                map_new_aid_uidList_ForAccountTeamMember.put(atm.Account__c, uids + ',' + atm.Team_Member__c);
		            }
            	}           	
            }
            
            
            if(atm.RecordType.Name == 'Non SFDC User' && atm.TE_Network_Id__c != null){
                if(atm.Role__c == 'Relay Specialist (IS)' || atm.Role__c == 'Account Manager (AM)' || atm.Role__c == 'Field Engineer (FE)'){
                    if((atm.Role__c == 'Relay Specialist (IS)' && atm.Account__r.Relay_Hierarchy__c != null && atm.TE_Network_Id__c == atm.Account__r.Relay_Hierarchy__r.Level_7_Assigned_User_Network_Ids__c) || 
                        (atm.Role__c == 'Account Manager (AM)' && atm.Account__r.Sales_Hierarchy__c != null && atm.TE_Network_Id__c == atm.Account__r.Sales_Hierarchy__r.Level_7_Assigned_User_Network_Ids__c) || 
                        (atm.Role__c == 'Field Engineer (FE)' && atm.Account__r.FE_Hierarchy__c != null && atm.TE_Network_Id__c == atm.Account__r.FE_Hierarchy__r.Level_7_Assigned_User_Network_Ids__c)){
                        list<Account_Team__c> list_temp = new list<Account_Team__c>();
                        if(map_teId_list_accountTeamMember.containsKey(atm.TE_Network_Id__c)){
                            list_temp = map_teId_list_accountTeamMember.get(atm.TE_Network_Id__c);
                        }
                        list_temp.add(atm);
                        map_teId_list_accountTeamMember.put(atm.TE_Network_Id__c, list_temp);
                        
                    }
                }
                else{
                    list<Account_Team__c> list_temp = new list<Account_Team__c>();
                    if(map_teId_list_accountTeamMember.containsKey(atm.TE_Network_Id__c)){
                        list_temp = map_teId_list_accountTeamMember.get(atm.TE_Network_Id__c);
                    }
                    list_temp.add(atm);
                    map_teId_list_accountTeamMember.put(atm.TE_Network_Id__c, list_temp);
                }    
            } 
        }
        
        if(!map_accId_set_AMInfo.isEmpty()){
        	for(Id accId : map_accId_set_AMInfo.keySet()){
        		list<String> list_temp = map_accId_set_AMInfo.get(accId).split(';');
        		Account_Team__c atm = new Account_Team__c();
        		atm.Account__c = accId;
        		atm.TE_Network_Id__c = list_temp[0];
        		atm.Role__c = 'Account Manager (AM)';
        		atm.RecordTypeId = sFDCRt;
        		atm.Team_Member__c = list_temp[1];
        		list_atm2Insert.add(atm);
        		if(atm.Team_Member__c != null){
        			if(!map_new_aid_uidList_ForAccountTeamMember.containsKey(accId)) {
	            		map_new_aid_uidList_ForAccountTeamMember.put(accId, atm.Team_Member__c);
		            }
		            else {
		                String uids = map_new_aid_uidList_ForAccountTeamMember.get(accId);
		                map_new_aid_uidList_ForAccountTeamMember.put(accId, uids + ',' + atm.Team_Member__c);
		            }
        		}       		
        	}
        	
        }
        
        if(!map_teId_list_accountTeamMember.isEmpty()){
        	set<String> set_tempNetworkId = new set<String>();
            for(User u : [SELECT Id,
                                 Te_Network_Id__c,
                                 IsActive
                          FROM User
                          WHERE Te_Network_Id__c IN :map_teId_list_accountTeamMember.keySet()
                          AND IsActive = true]){
                if(map_teId_list_accountTeamMember.containsKey(u.Te_Network_Id__c) && !set_tempNetworkId.contains(u.Te_Network_Id__c)){
                	set_tempNetworkId.add(u.Te_Network_Id__c);
                    for(Account_Team__c atm : map_teId_list_accountTeamMember.get(u.Te_Network_Id__c)){
                    	if(atm.RecordTypeId != sFDCRt || atm.Team_Member__c != u.Id){
	                        atm.RecordTypeId = sFDCRt;
	                        if(atm.Team_Member__c != u.Id){
		                        if(!map_old_aid_uidList_ForAccountTeamMember.containsKey(atm.Account__c)) {
		                            map_old_aid_uidList_ForAccountTeamMember.put(atm.Account__c, atm.Team_Member__c);
		                        } 
		                        else {
		                            String uids = map_old_aid_uidList_ForAccountTeamMember.get(atm.Account__c);
		                            map_old_aid_uidList_ForAccountTeamMember.put(atm.Account__c, uids + ',' + atm.Team_Member__c);
		                        }		
	                        	atm.Team_Member__c = u.Id;
	                        	if(atm.Team_Member__c != null){
	                        		if(!map_new_aid_uidList_ForAccountTeamMember.containsKey(atm.Account__c)) {
			                        	map_new_aid_uidList_ForAccountTeamMember.put(atm.Account__c, atm.Team_Member__c);
			                        }
			                        else {
			                            String uids = map_new_aid_uidList_ForAccountTeamMember.get(atm.Account__c);
			                            map_new_aid_uidList_ForAccountTeamMember.put(atm.Account__c, uids + ',' + atm.Team_Member__c);
			                        }
	                        	}		                        	                        	                                               	
	                        }
	                        list_accountTeam2update.add(atm);
                    	}
                    }
                }
            }
        }
        
        //dont fire the account team member trigger
        ClsSharingUtil.fireAccountTeamMemberTrigger = false;
        
        if(list_atm2Insert.size() != 0){
            insert list_atm2Insert;
        }
        
        if(list_accountTeam2update.size() != 0){
            update list_accountTeam2update;
        }
        if(!map_new_aid_uidList_ForAccountTeamMember.isEmpty()) ClsSharingUtil.upsertAccountTeamMemberBatch(map_new_aid_uidList_ForAccountTeamMember);
        if(list_accountTeam2Del.size() != 0){
        	if(!map_old_aid_uidList_ForAccountTeamMember.isEmpty())  ClsSharingUtil.deleteAccountTeamMember(map_old_aid_uidList_ForAccountTeamMember);
            delete list_accountTeam2Del;
        }
        //list<Account_Team__c> list_atm2Del = new list<Account_Team__c>();
        //valid Level_7_Assigned_User_Network_Ids__c
        if(!map_atId_accountTeamMember.isEmpty()){
            for(Account_Team__c atm : map_atId_accountTeamMember.values()){
                if(atm.Role__c == 'Account Manager (AM)'){//Level_7_Assigned_User_Network_Ids__c has only one te network id.
                    if(atm.TE_Network_Id__c != atm.Account__r.Sales_Hierarchy__r.Level_7_Assigned_User_Network_Ids__c){
                        list_atm2Del.add(atm);
                    }
                }
            }
            if(list_atm2Del.size() != 0){
                delete list_atm2Del;
            }
        }
        /*if(!map_atId_accountTeamMember.isEmpty()){
            for(Account_Team__c atm : map_atId_accountTeamMember.values()){
                if(atm.Role__c == 'Account Manager (AM)'){//Level_7_Assigned_User_Network_Ids__c has only one te network id.
                    if(atm.TE_Network_Id__c != atm.Account__r.Sales_Hierarchy__r.Level_7_Assigned_User_Network_Ids__c){
                        list_atm2Del.add(atm);
                    }
                }
                else if(atm.Role__c == 'Field Engineer (FE)'){
                    if(atm.TE_Network_Id__c != atm.Account__r.FE_Hierarchy__r.Level_7_Assigned_User_Network_Ids__c){
                        list_atm2Del.add(atm);
                    }
                }
                else if(atm.Role__c == 'Global Account Manager (GAM)'){
                    if(atm.Account__r.Sales_Hierarchy__r.Hierarchy_Type__c == 'Global Account Manager Hierarchy (GAM)' 
                       && atm.Account__r.Sales_Hierarchy__r.Level_7_Territory_Code__c == atm.Account__r.GAMCD__c){
                        if(atm.TE_Network_Id__c != atm.Account__r.Sales_Hierarchy__r.Level_7_Assigned_User_Network_Ids__c){
                            list_atm2Del.add(atm);
                        }
                    }
                }
                else if(atm.Role__c == 'Relay Specialist (IS)'){
                    if(atm.TE_Network_Id__c != atm.Account__r.Relay_Hierarchy__r.Level_7_Assigned_User_Network_Ids__c){
                        list_atm2Del.add(atm);
                    }
                }
            }
            if(list_atm2Del.size() != 0){
                delete list_atm2Del;
            }
        }*/
        
        
        
        /*
        * END : Validate Account Team Members
        */
        
    }

    global void finish(Database.BatchableContext BC){ 
        if(email != null) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] {email});
            mail.setReplyTo(Email);
            mail.setSenderDisplayName('Batch Processing');
            mail.setSubject('Batch Processing ClsBatch_AccountTeamMemberSharing Completed');
            mail.setPlainTextBody('Batch Processing ClsBatch_AccountTeamMemberSharing has completed');
            //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        } 
    }
    
}