/**
 *  Class to manage Account' sharing , such as : Group, Group Member, AccountShare, AccountTeamMember  
 *  Methods in class are used when new, delete, update Account or Account Team or Customer Focus Team
 *  
 * @author Yinfeng Guo
 * @created 2012-02-09
 * @version 1.0
 * @since 23.0
 * 
 *
 * @changelog
 * 2012-02-09 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Created   
 *
 */

public class ClsSharingUtil { 
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    /**
     * the mode to invoke the trigger, the value here is for insert 
     */
    public static final String MODE_INSERT = 'INSERT';
    
    /**   
     * the mode to invoke the trigger, the value here is for update 
     */ 
    public static final String MODE_UPDATE = 'UPDATE';
       
    /**   
     * the mode to invoke the trigger, the value here is for delete 
     */ 
    public static final String MODE_DELETE = 'DELETE';
       
    /**
     * Update from considered record type to not considered record type 
     */
    public static final String MODE_UPDATE_RT_NRT = 'RT_to_NRT';
    
    /**
     * Update from not considered record type to considered record type 
     */
    public static final String MODE_UPDATE_NRT_RT = 'NRT_to_RT';
    
    /**
     * Update from not parent to with parent 
     */ 
    public static final String MODE_UPDATE_NP_P = 'NP_to_P';
    
    /**
     * Update from with parent to no parent 
     */
    public static final String MODE_UPDATE_P_NP = 'P_to_NP';
    
    /**
     * Update from with parent to with parent, but not the same parent 
     */
    public static final String MODE_UPDATE_P_P = 'P_to_P';  

    /**
     * this boolean variable to prevent the tigger invoked in recyle
     */ 
    public static Boolean TriggerRecursionDefense = false;
    
    //added by xia 2013-04-03 trigger defense for sales hierarchy
    public static boolean TriggerRecursion4SalesHierarchy = false;
        
    
    /**
     * this boolean variable to prevent the tigger to be called out from a batch
     */ 
    public static Boolean fireAccountTeamMemberTrigger = true;  
    public  static  String NAME_PREFIX = 'CIS_GAM_';
    public static  String NAME_PREFIX_B = 'B_Account_';    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 


    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    /**
     * The prefix name of public group for account  
     */
    //private static final String NAME_PREFIX = 'CIS_GAM_';
    //private static final String NAME_PREFIX_B = 'B_Account_';
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        
        

    
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public static method=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    /**
     * This method is used to get custom setting 'GAM Record Type Id' value.
     *
     @author Yinfeng Guo
     @created 2012-02-13
     @version 1.0
     @since 23.0
     *
     @return         GAM Record Type Id get from Custom Setting     
     *
     @changelog
     * 2012-02-13 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    public static Id gamCustomSetting(){
        Id rt_cis_gam;
        if(Apex_Helper_Settings__c.getInstance('GAM Record Type Id') != null) rt_cis_gam = Apex_Helper_Settings__c.getInstance('GAM Record Type Id').Value__c;
        return rt_cis_gam;
    }

    /**
     * This method is used to get custom setting 'Account Team User Record Type Id' value
     *
     @author Yinfeng Guo
     @created 2012-02-13
     @version 1.0
     @since 23.0
     *
     @return         Account Team User Record Type Id get from Custom Setting       
     *
     @changelog
     * 2012-02-13 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    public static Id sfdcUserCustomSetting(){
        Id rt_sfdc_user;
        if(Apex_Helper_Settings__c.getInstance('Account Team User Record Type Id') != null) rt_sfdc_user = Apex_Helper_Settings__c.getInstance('Account Team User Record Type Id').Value__c;
        return rt_sfdc_user;
    }
    
    
        /**
     * This method is used to get custom setting 'Account Team User Record Type Id' value
     *
     @author Yinfeng Guo
     @created 2012-02-13
     @version 1.0
     @since 23.0
     *
     @return         Account Team User Record Type Id get from Custom Setting       
     *
     @changelog
     * 2012-02-13 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    public static Id accountCustomSetting(){
        Id rt_cis_account;
        if(Apex_Helper_Settings__c.getInstance('Account Record Type Id') != null) rt_cis_account = Apex_Helper_Settings__c.getInstance('Account Record Type Id').Value__c;
        return rt_cis_account;
    }
    
    /**
     * This method is used when update a account from Not GAM to GAM. 
     * At this moment, we should create public group for account and put the group into AccountShare
     * Implemented process : 
     * 1.this method to create Group and then replicate Group id to Account' field Public_Group_Id__c,
     * 2.and create AccountShare for the created Account
     *
     @author Yinfeng Guo
     @created 2012-02-13
     @version 1.0
     @since 23.0
     *
     @param map_id_account       map's key is Account id and the value is Account
     *
     @return Map<Id, Group>      map's key is Account id and the value is Group         
     *
     @changelog
     * 2012-02-13 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    public static Map<Id, Group> InsertGroupShare(Map<Id, Account> map_id_account){
        Id rt_cis_gam = gamCustomSetting();
        Map<Id, Group> map_id_group = new Map<Id, Group>();
        for(Id aid :map_id_account.keySet()){
            Group g = new Group();
            g.Name = NAME_PREFIX + map_id_account.get(aid).GAMCD__c;
            map_id_group.put(aid, g);
        }
        insert map_id_group.values();
        List<AccountShare> list_accShrs  = new List<AccountShare>();
        for(Id aid : map_id_group.keySet()){
            map_id_account.get(aid).Public_Group_Id__c =  map_id_group.get(aid).Id;
            AccountShare accShr = new AccountShare();
            accShr = new AccountShare();
            accShr.AccountId = aid;
            accShr.UserOrGroupId = map_id_group.get(aid).Id;
            accShr.AccountAccessLevel = 'Edit';
            accShr.CaseAccessLevel = 'Edit';
            accShr.OpportunityAccessLevel = 'Edit';
            list_accShrs.add(accShr);
        }
        insert list_accShrs;
        return map_id_group;
    }

    /**
     * This method is used when delete a Customer Focus Team.
     * At this moment, we should delete gropu member for the customer focus team user.
     * this method is used to delete Group Member if exist
     *
     @author Yinfeng Guo
     @created 2012-02-27
     @version 1.0
     @since 23.0
     *
     @param map_aid_uidList       map's key are Account id and the value are Customer Focus Team Members' Id
     *
     @return void           
     *
     @changelog
     * 2012-02-27 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    @future
    public static void deleteCustomerFocusTeamMember(map<id, string> map_aid_uidList){
        
        Id rt_cis_gam = gamCustomSetting();
        if(map_aid_uidList != null && !map_aid_uidList.isEmpty() && rt_cis_gam != null){
            
            map<id, set<id>> map_aid_uids = new map<id, set<id>>();
            for(id aid: map_aid_uidList.keySet()) {
                set<id> set_uids = new set<id>();
                for(string uid: map_aid_uidList.get(aid).split(',')) {
                    if(uid != ''){
                        set_uids.add(uid);
                    }
                }
                map_aid_uids.put(aid, set_uids);
            }
            map<id, account> map_id_acc = new map<id, account>([select Id, RecordTypeId, Public_Group_Id__c from Account where id in: map_aid_uids.keySet()]);
            set<id> set_gids = new set<id>();
            for(account a: map_id_acc.values()) {
                if(a.Public_Group_Id__c != null) {
                    set_gids.add(a.Public_Group_Id__c);
                }
            }
            
            map<id, map<id, GroupMember>> map_gid_uid_gm = new map<id, map<id, GroupMember>>();
            for(GroupMember gm: [select id, GroupId, UserOrGroupId from GroupMember where GroupId in: set_gids]) {
                if(!map_gid_uid_gm.containskey(gm.GroupId)) {
                    map_gid_uid_gm.put(gm.GroupId, new map<id, GroupMember>());
                }
                if(!map_gid_uid_gm.get(gm.GroupId).containsKey(gm.UserOrGroupId)) {
                    map_gid_uid_gm.get(gm.GroupId).put(gm.UserOrGroupId, gm);
                }
            }
            
            list<GroupMember> list_groupMembers = new list<GroupMember>();
            Account acc;
            for(id aid: map_aid_uids.keySet()) {
                acc = map_id_acc.get(aid);
                for(id uid: map_aid_uids.get(aid)) {
                    if(acc.recordTypeId != null && acc.recordTypeId == rt_cis_gam) {
                        if(acc.Public_Group_Id__c != null && map_gid_uid_gm.containsKey(acc.Public_Group_Id__c) && map_gid_uid_gm.get(acc.Public_Group_Id__c).containsKey(uid)) {
                            list_groupMembers.add(map_gid_uid_gm.get(acc.Public_Group_Id__c).get(uid));
                        }
                    }
                    
                }
            }
            
            if(!list_groupMembers.isEmpty()) delete list_groupMembers; 
        }           
    }

    /**
     * This method is used when delete a team member or update a team member, 
     * this method is used to delete old Group Member or AccountShare if exist
     *
     @author Yinfeng Guo
     @created 2012-02-13
     @version 1.0
     @since 23.0
     *
     @param map_aid_uidList       map's key are Account id and the value are Account Team Members' Id
     *
     @return void           
     *
     @changelog
     * 2012-02-13 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    @future
    public static void deleteTeamShare(map<id, string> map_aid_uidList){
        Id rt_cis_gam = gamCustomSetting();
        
        if(map_aid_uidList != null && !map_aid_uidList.isEmpty() && rt_cis_gam != null){
            
            map<id, set<id>> map_aid_uids = new map<id, set<id>>();
            for(id aid: map_aid_uidList.keySet()) {
                set<id> set_uids = new set<id>();
                for(string uid: map_aid_uidList.get(aid).split(',')) {
                    if(uid != ''){
                        set_uids.add(uid);
                    }
                }
                map_aid_uids.put(aid, set_uids);
            }
            
            map<id, account> map_id_acc = new map<id, account>([select Id, RecordTypeId, Public_Group_Id__c from Account where id in: map_aid_uids.keySet()]);
            
            list<GroupMember> list_groupMembers = new list<GroupMember>();
            List<AccountShare> list_accShrs  = new List<AccountShare>();
            
            set<Id> set_temMebIds = new set<Id>();
            Account acc;
            GroupMember grpMeb;
            AccountShare accShr;
            set<id> set_gids = new set<id>();
            
            for(account a: map_id_acc.values()) {
                if(a.Public_Group_Id__c != null) {
                    set_gids.add(a.Public_Group_Id__c);
                }
            }
            
            map<id, map<id, GroupMember>> map_gid_uid_gm = new map<id, map<id, GroupMember>>();
            for(GroupMember gm: [select id, GroupId, UserOrGroupId from GroupMember where GroupId in: set_gids]) {
                if(!map_gid_uid_gm.containskey(gm.GroupId)) {
                    map_gid_uid_gm.put(gm.GroupId, new map<id, GroupMember>());
                }
                if(!map_gid_uid_gm.get(gm.GroupId).containsKey(gm.UserOrGroupId)) {
                    map_gid_uid_gm.get(gm.GroupId).put(gm.UserOrGroupId, gm);
                }
            }
            
            map<id, map<id, AccountShare>> map_aid_uid_as = new map<id, map<id, AccountShare>>();
            for(AccountShare gm: [select id, AccountId, UserOrGroupId, RowCause from AccountShare where AccountId in: map_aid_uids.keySet() and RowCause = 'Manual']) {
                if(!map_aid_uid_as.containskey(gm.AccountId)) map_aid_uid_as.put(gm.AccountId, new map<id, AccountShare>());
                if(!map_aid_uid_as.get(gm.AccountId).containsKey(gm.UserOrGroupId)) map_aid_uid_as.get(gm.AccountId).put(gm.UserOrGroupId, gm);
            }
            
            for(id aid: map_aid_uids.keySet()) {
                acc = map_id_acc.get(aid);
                for(id uid: map_aid_uids.get(aid)) {
                    if(acc.recordTypeId != null && acc.recordTypeId == rt_cis_gam) {
                        if(acc.Public_Group_Id__c != null && map_gid_uid_gm.containsKey(acc.Public_Group_Id__c) && map_gid_uid_gm.get(acc.Public_Group_Id__c).containsKey(uid)) {
                            list_groupMembers.add(map_gid_uid_gm.get(acc.Public_Group_Id__c).get(uid));
                        }
                    }
                    else {
                        if(map_aid_uid_as.containsKey(aid) && map_aid_uid_as.get(aid).containsKey(uid)) {
                            list_accShrs.add(map_aid_uid_as.get(aid).get(uid));
                        }
                    }
                }
            }
            
            List<AccountTeamMember> list_accTemebs2Del  = new List<AccountTeamMember>();
            for(AccountTeamMember accTemeb : [SELECT Id, AccountId, UserId from AccountTeamMember where AccountId in : map_aid_uids.keySet()  ]){
                if(map_aid_uids.containsKey(accTemeb.AccountId) && map_aid_uids.get(accTemeb.AccountId).contains(accTemeb.UserId)){
                    list_accTemebs2Del.add(accTemeb);
                }
            }
            if(!list_accTemebs2Del.isEmpty()) delete list_accTemebs2Del;
            if(!list_groupMembers.isEmpty()) delete list_groupMembers; 
            if(!list_accShrs.isEmpty()) delete list_accShrs; 
        }   
    }
    
    /**
     * This method is used when update a account from not GAM to GAM, 
     * this method is used to delete old AccountShare if exist
     *
     @author Yinfeng Guo
     @created 2012-02-13
     @version 1.0
     @since 23.0
     *
     @param set_aids       the account's id who are update from not GAM to GAM
     @param set_uids       the updated account's team members' id
     *
     @return void           
     *
     @changelog
     * 2012-02-13 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */
    @future 
    public static void deleteAccountTeamShare(set<id> set_aids, set<id> set_uids){
        map<id, map<id, AccountShare>> map_aid_uid_as = new map<id, map<id, AccountShare>>();
        List<AccountShare> list_accShrs  = new List<AccountShare>();
        for(AccountShare gm: [select id, AccountId, UserOrGroupId, RowCause from AccountShare where AccountId in: set_aids and RowCause = 'Manual']) {
            if(!map_aid_uid_as.containskey(gm.AccountId)) map_aid_uid_as.put(gm.AccountId, new map<id, AccountShare>());
            if(!map_aid_uid_as.get(gm.AccountId).containsKey(gm.UserOrGroupId)) map_aid_uid_as.get(gm.AccountId).put(gm.UserOrGroupId, gm);
        }
        for(Id aid:set_aids) {
            for(id uid: set_uids) {
                if(map_aid_uid_as.containsKey(aid) && map_aid_uid_as.get(aid).containsKey(uid)) {
                    list_accShrs.add(map_aid_uid_as.get(aid).get(uid));
                }
            }
        }
        if(!list_accShrs.isEmpty()) delete list_accShrs;
    }

    /**
     * This method is used when delete a Account Team, 
     * this method is used to delete Account Team Member if exist
     *
     @author Yinfeng Guo
     @created 2012-02-27
     @version 1.0
     @since 23.0
     *
     @param map_aid_uidList       map's key are Account id and the value are Customer Focus Team Members' Id
     *
     @return void           
     *
     @changelog
     * 2012-02-27 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    //@future
    public static void deleteAccountTeamMember(map<id, string> map_aid_uidList){
        Id rt_cis_gam = gamCustomSetting();
        if(map_aid_uidList != null && !map_aid_uidList.isEmpty() && rt_cis_gam != null){
            map<id, set<id>> map_aid_uids = new map<id, set<id>>();
            for(id aid: map_aid_uidList.keySet()) {
                set<id> set_uids = new set<id>();
                if(map_aid_uidList.get(aid) != null){
                    for(string uid: map_aid_uidList.get(aid).split(',')) {
                        if(uid != null && uid != 'null' && uid != ''){
                            set_uids.add(uid);
                        }
                    }
                    map_aid_uids.put(aid, set_uids);    
                }
            }
            
            //Begin : cancel only "Read" access on the Opportunities for Account Team Members.
            map<id, set<id>> map_oppyId_uids = new map<id, set<id>>();
            list<OpportunityShare> list_oppyShare2Delete = new list<OpportunityShare>();
            for(Opportunity o : [Select Id, AccountId from Opportunity where AccountId in: map_aid_uids.keySet() ]){
                map_oppyId_uids.put(o.Id, map_aid_uids.get(o.AccountId));
            }
            
            for(OpportunityShare os : [Select Id, OpportunityId, UserOrGroupId, RowCause from OpportunityShare where RowCause = 'Manual' and OpportunityId in: map_oppyId_uids.keySet()]){
                if(map_oppyId_uids.get(os.OpportunityId).contains(os.UserOrGroupId)) list_oppyShare2Delete.add(os);
            }
            if(!list_oppyShare2Delete.isEmpty()){
                delete list_oppyShare2Delete;
            }
            //End : cancel only "Read" access on the Opportunities for Account Team Members.
            // Change start by Mrunal for R-1113
            set<String> custAccMemRoleKey = new set<string>();
            for (Account_Team__c acctm : [SELECT Id, Account__c, Team_Member__c, Role__c FROM Account_Team__c WHERE Account__c IN:map_aid_uids.keySet()]){
                custAccMemRoleKey.add(acctm.Team_Member__c);
            }
            List<AccountTeamMember> list_accTemebs2Del  = new List<AccountTeamMember>();
            for(AccountTeamMember accTemeb : [SELECT Id, AccountId, UserId, TeamMemberRole from AccountTeamMember where AccountId in : map_aid_uids.keySet()  ]){
                if(map_aid_uids.containsKey(accTemeb.AccountId) && map_aid_uids.get(accTemeb.AccountId).contains(accTemeb.UserId)){
                    string stdAccMemRoleKey = accTemeb.UserId;
                    if(!custAccMemRoleKey.contains(stdAccMemRoleKey))
                    list_accTemebs2Del.add(accTemeb);
                }
            }
            /*List<AccountTeamMember> list_accTemebs2Del  = new List<AccountTeamMember>();
            for(AccountTeamMember accTemeb : [SELECT Id, AccountId, UserId from AccountTeamMember where AccountId in : map_aid_uids.keySet()  ]){
                if(map_aid_uids.containsKey(accTemeb.AccountId) && map_aid_uids.get(accTemeb.AccountId).contains(accTemeb.UserId)){
                    list_accTemebs2Del.add(accTemeb);
                }
            }*/
            // Change end by Mrunal for R-1113
            //system.debug('yinfeng:test:inin:list_accTemebs2Del:'+list_accTemebs2Del);
            if(!list_accTemebs2Del.isEmpty()) delete list_accTemebs2Del;    
        }
    }

    @future
    public static void deleteAccountTeamShare(map<id, string> map_aid_uidList){
        Id rt_cis_gam = gamCustomSetting();
        if(map_aid_uidList != null && !map_aid_uidList.isEmpty() && rt_cis_gam != null){
            map<id, set<id>> map_aid_uids = new map<id, set<id>>();
            for(id aid: map_aid_uidList.keySet()) {
                set<id> set_uids = new set<id>();
                for(string uid: map_aid_uidList.get(aid).split(',')) {
                    if(uid != ''){
                        set_uids.add(uid);
                    }
                }
                map_aid_uids.put(aid, set_uids);
            }
            
            List<AccountShare> list_accShares2Del  = new List<AccountShare>();
            for(AccountShare accs : [SELECT Id, AccountId, UserOrGroupId from AccountShare where RowCause = 'Manual' and AccountId in : map_aid_uids.keySet()  ]){
                if(map_aid_uids.containsKey(accs.AccountId) && map_aid_uids.get(accs.AccountId).contains(accs.UserOrGroupId)){
                    list_accShares2Del.add(accs);
                }
            }
            //system.debug('yinfeng:test:inin:list_accShares2Del:'+list_accShares2Del);
            if(!list_accShares2Del.isEmpty()) delete list_accShares2Del;    
        }
    }   
    /**
     * This method is used when insert a new Customer Focus Team, 
     * this method is used to insert Group member
     *
     @author Yinfeng Guo
     @created 2012-02-27
     @version 1.0
     @since 23.0
     *
     @param map_aid_uidList      map's key are Accounts' id and map's value are Account team members' id
     *
     @return void           
     *
     @changelog
     * 2012-02-27 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    @future
    public static void insertCustomerFocusTeamMember(map<id, string> map_aid_uidList){
        Id rt_cis_gam = gamCustomSetting();
        if(map_aid_uidList != null && !map_aid_uidList.isEmpty()  && rt_cis_gam != null){
            /*to transfer from map<id, string> to map<id, set<id>>*/
            map<id, set<id>> map_aid_uids = new map<id, set<id>>();
            for(id aid: map_aid_uidList.keySet()) {
                set<id> set_uids = new set<id>();
                for(string uid: map_aid_uidList.get(aid).split(',')) {
                    if(uid != ''){
                        set_uids.add(uid);
                    }
                }
                map_aid_uids.put(aid, set_uids);
            }
            list<GroupMember> list_groupMembers = new list<GroupMember>();
            Account acc;
            GroupMember grpMeb;
            map<id, account> map_id_acc = new map<id, account>([select id, recordTypeId, Public_Group_Id__c from account where id in: map_aid_uids.keySet()]);
            for(Id aid: map_aid_uids.keySet()) {
                acc = map_id_acc.get(aid);
                for(Id uid: map_aid_uids.get(aid)) {
                    if(acc.recordTypeId != null && acc.recordTypeId == rt_cis_gam && acc.Public_Group_Id__c != null) {
                        grpMeb = new GroupMember();
                        grpMeb.GroupId = acc.Public_Group_Id__c;
                        grpMeb.UserOrGroupId = uid;
                        list_groupMembers.add(grpMeb);
                    }
                }
            }
            if(!list_groupMembers.isEmpty() && !Test.isRunningTest()) insert list_groupMembers;         
        }       
    }

    /**
     * This method is used when insert a new Account Team, 
     * this method is used to insert account team member
     *
     @author Yinfeng Guo
     @created 2012-02-27
     @version 1.0
     @since 23.0
     *
     @param map_aid_uidList      map's key are Accounts' id and map's value are Account team members' id
     *
     @return void           
     *
     @changelog
     * 2012-02-27 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    @future
    public static void upsertAccountTeamMember(map<id, string> map_aid_uidList){
        upsertAccountTeamMemberCommonForFutureAndBatch(map_aid_uidList);
        /*
        Id rt_cis_gam = gamCustomSetting();
        if(map_aid_uidList != null && !map_aid_uidList.isEmpty()){
            map<id, set<id>> map_aid_uids = new map<id, set<id>>();
            for(id aid: map_aid_uidList.keySet()) {
                set<id> set_uids = new set<id>();
                for(string uid: map_aid_uidList.get(aid).split(',')) {
                    if(uid.trim() != ''){
                        set_uids.add(uid.trim());
                    }
                }
                map_aid_uids.put(aid, set_uids);
            }
            map<id, Boolean> map_uid_isActive = new map<id, Boolean>();
            map<id, String> map_uid_userType = new map<id, String>();
            set<id> set_allUserId = new set<Id>();
            for(set<Id> set_uid : map_aid_uids.values()){
                set_allUserId.addAll(set_uid);
            }
            for(User u : [select Id, Name, IsActive, UserType from User Where Id in: set_allUserId]){
                map_uid_isActive.put(u.Id, u.IsActive);
                map_uid_userType.put(u.Id, u.UserType);
            }
            list<Account_Team__c> list_accTeams = new list<Account_Team__c>();
            map<id, map<id, Account_Team__c>> map_aid_uid = new map<id, map<id, Account_Team__c>>();
            for(Account_Team__c atc : [select Opportunity_Access__c, Id, Account__c, Role__c, Team_Member__c from Account_Team__c where Account__c in: map_aid_uids.keySet()]){
                list_accTeams.add(atc);
                if(!map_aid_uid.containsKey(atc.Account__c)) map_aid_uid.put(atc.Account__c, new map<id, Account_Team__c>()); 
                map_aid_uid.get(atc.Account__c).put(atc.Team_Member__c, atc);
            }
            AccountTeamMember accTmeb;
            Account_Team__c atc_custom;
            List<AccountTeamMember> list_accTmebs  = new List<AccountTeamMember>();
            for(id aid: map_aid_uid.keySet()) {
                for(id uid: map_aid_uid.get(aid).keySet()) {
                    atc_custom = map_aid_uid.get(aid).get(uid);
                    if(map_uid_isActive.get(uid)== true && map_uid_userType.get(uid) == 'Standard') {
                        accTmeb = new AccountTeamMember();
                        accTmeb.AccountId = aid;
                        accTmeb.UserId = uid;
                        accTmeb.TeamMemberRole = atc_custom.Role__c;
                        list_accTmebs.add(accTmeb);
                    }
                }
            }
            if(!list_accTmebs.isEmpty()) insert list_accTmebs;
            AccountShare accSha;
            List<AccountShare> list_accShare = new List<AccountShare>();
            map<id, id> map_accId_uids_existowner = new map<id, id>();
            for(AccountShare a : [Select Id, AccountId, UserOrGroupId from AccountShare where AccountId in: map_aid_uids.keySet() and RowCause = 'Owner']){
                map_accId_uids_existowner.put(a.AccountId, a.UserOrGroupId);
            }           
            for(id aid: map_aid_uid.keySet()) {
                for(id uid: map_aid_uid.get(aid).keySet()) {
                    atc_custom = map_aid_uid.get(aid).get(uid);
                    if(map_uid_isActive.get(uid)== true && map_uid_userType.get(uid) == 'Standard'  && map_accId_uids_existowner.get(aid) != uid) {
                        accSha = new AccountShare();
                        accSha.AccountId = aid;
                        accSha.UserOrGroupId = uid;
                        //To check if it is correct.
                        accSha.AccountAccessLevel = 'Edit';
                        if(atc_custom.Opportunity_Access__c == 'Edit') accSha.OpportunityAccessLevel = 'Edit';
                        else if(atc_custom.Opportunity_Access__c == 'Read-Only') accSha.OpportunityAccessLevel = 'Read';
                        else if(atc_custom.Opportunity_Access__c == 'No Access') accSha.OpportunityAccessLevel = 'None';
                        if(accSha.OpportunityAccessLevel != null)  list_accShare.add(accSha);
                    }
                }
            }
            if(!list_accShare.isEmpty()) insert list_accShare;
            map<id, set<id>> map_oppyId_uids_delete = new map<id, set<id>>();
            map<id, id> map_oppyId_uids_existowner = new map<id, id>();
            list<OpportunityShare> list_oppyShare2Delete = new list<OpportunityShare>();
            list<OpportunityShare> list_oppyShare = new list<OpportunityShare>();
            map<id, Opportunity> map_id_opp = new map<id, Opportunity>([Select Id, AccountId from Opportunity where AccountId in: map_aid_uids.keySet() ]);
            for(OpportunityShare o : [Select Id, OpportunityId, UserOrGroupId from OpportunityShare where OpportunityId in: map_id_opp.keySet() and RowCause = 'Owner']){
                map_oppyId_uids_existowner.put(o.OpportunityId, o.UserOrGroupId);
            }
            for(Opportunity o: map_id_opp.values()) {
                set<Id> set_uids2Delete = new set<Id>();
                for(id userId: map_aid_uids.get(o.AccountId)) {
                    if(map_uid_isActive.get(userId)== true && map_uid_userType.get(userId) == 'Standard' && map_oppyId_uids_existowner.get(o.id) != userId) {
                        OpportunityShare oppyShare = new OpportunityShare();
                        oppyShare.OpportunityId = o.id;
                        oppyShare.UserOrGroupId = userId;
                        String oppAL = map_aid_uid.get(o.AccountId).get(userId).Opportunity_Access__c;
                        if(oppAL == 'Edit') oppyShare.OpportunityAccessLevel = 'Edit';
                        else if(oppAL == 'Read-Only') oppyShare.OpportunityAccessLevel = 'Read';
                        else if(oppAL == 'No Access') set_uids2Delete.add(userId);
                        if(oppyShare.OpportunityAccessLevel != null) list_oppyShare.add(oppyShare);
                    }
                }
                if(!set_uids2Delete.isEmpty()) map_oppyId_uids_delete.put(o.id, set_uids2Delete);
            }
            if(!list_oppyShare.isEmpty()) insert list_oppyShare;
            for(OpportunityShare os : [Select Id, OpportunityId, UserOrGroupId, RowCause from OpportunityShare where RowCause = 'Manual' and OpportunityId in: map_oppyId_uids_delete.keySet()]){
                if(map_oppyId_uids_delete.get(os.OpportunityId).contains(os.UserOrGroupId)) list_oppyShare2Delete.add(os);
            }
            if(!list_oppyShare2Delete.isEmpty()){
                delete list_oppyShare2Delete;
            }
        }*/     
    }
    
    /**
     * This method is used when insert a new Account or delete a Account, 
     * this method is used to manage Account's Sharing using such as Group or AccountShare
     *
     @author Yinfeng Guo
     @created 2012-02-13
     @version 1.0
     @since 23.0
     *
     @param mode                    mode to validate whether insert or delete
     @param set<Id> set_ids         accounts' id inserted or deleted
     *
     @return void           
     *
     @changelog
     * 2012-02-13 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    @future
    public static void modifyAccountSharing (String mode, set<Id> set_ids){
        Id rt_cis_gam = gamCustomSetting();
        if(set_ids != null && !set_ids.isEmpty()) {
            
            if(mode == MODE_INSERT){
                afterInsertAccount(set_ids);
                grantParentAccess(set_ids);
            }
            else if(mode == MODE_DELETE){
                /*when delete a account with the record type ,the correspond public group should delete two*/
                list<Group> list_groups = [Select Id  From Group where Id in: set_ids];
                if(!list_groups.isEmpty()){
                    delete list_groups;
                }
            }
        }
    }
    
    /**
     * This method is used when update a Account, 
     * this method is used to manage Account's Sharing using such as Group or AccountShare
     * Implement process:
     * If update recordtype from GAM to not GAM, Delete sharing and Delete Group, (mode = MODE_UPDATE_RT_NRT)
     @author Yinfeng Guo
     @created 2012-02-13
     @version 1.0
     @since 23.0
     *
     @param mode                                    mode to validate whether insert or delete
     @param set<Id> set_ids                         accounts' id  updated
     @param map<id, string> map_pId_cIdList         map's key are parent account id and map's value are child account id
     *
     @return void           
     *
     @changelog
     * 2012-02-13 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    @future
    public static void updateAccount(String mode, set<Id> set_ids,  map<id, string> map_pId_cIdList){
        
        if(set_ids != null && !set_ids.isEmpty()){
            if(mode == MODE_UPDATE_RT_NRT){
                list<Group> list_groups = new list<Group>();
                list<AccountShare> list_shrs = new list<AccountShare>();
                set<Id> pGroupIds = new set<Id>();
                
                for(Group g : [Select Id  From Group where Id in: set_ids]) {
                    pGroupIds.add(g.Id);
                    list_groups.add(g);
                }
                if(!pGroupIds.isEmpty()){
                    list_shrs = [Select Id  From AccountShare where Id in: pGroupIds ]; 
                }   
                if(!list_shrs.isEmpty()){
                    delete list_shrs;
                }
                if( list_groups!=null && !list_groups.isEmpty()){
                    delete list_groups;
                }
            }
            else if(mode == MODE_UPDATE_NP_P){
                grantParentAccess(set_ids);
            }
        }
        
        if((map_pId_cIdList != null && !map_pId_cIdList.isEmpty())){
            set<Id> set_newAccs = new set<Id>();
            map<id, set<id>> map_pid_cids = new map<id, set<id>>();
            for(Id pid: map_pId_cIdList.keySet()) {
                set<id> set_cids = new set<id>();
                for(string cid: map_pId_cIdList.get(pid).split(',')) {
                    set_cids.add(cid);
                    set_newAccs.add(cid);
                }
                map_pid_cids.put(pid, set_cids);
            }
            if(mode == MODE_UPDATE_P_NP){
                cancelParentAccess(map_pid_cids);
            }
            else if(mode == MODE_UPDATE_P_P){
                cancelParentAccess(map_pid_cids);
                grantParentAccess(set_newAccs);
            }
        }
    }

    /**
     * This method is used when insert a new Product_Hierarchy__c or update a Product_Hierarchy__c, 
     * this method is used to manage Product_Hierarchy__c's Sharing
     *
     @author Yinfeng Guo
     @created 2012-03-16
     @version 1.0
     @since 23.0
     *
     @param mode                    mode to validate whether insert or update
     @param set_ids                 accounts' id inserted or updated
     *
     @return void           
     *
     @changelog
     * 2012-03-16 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    @future
    public static void ModifyProductHierarchySharing (String mode, set<Id> set_ids){
        if(set_ids != null && !set_ids.isEmpty()) {

            if(mode == MODE_INSERT){//Insert Product_Hierarchy__Share
                
                map<id, set<id>> map_aid_uids2Insert = new map<id, set<id>>();
                
                for(Product_Hierarchy__c ph : [Select Id, OwnerId, Product_Manager__c, Regional_PM_AP__c, Regional_PM_EU__c, Regional_PM_US__c, Global_PM__c, Approver_PM__c from Product_Hierarchy__c where Id in: set_ids]){
                    if(ph.Product_Manager__c != null && ph.Product_Manager__c != ph.OwnerId){
                        
                        if(!map_aid_uids2Insert.containsKey(ph.Id)) {
                            map_aid_uids2Insert.put(ph.Id, new set<Id>());
                            map_aid_uids2Insert.get(ph.Id).add(ph.Product_Manager__c);
                        }
                        else map_aid_uids2Insert.get(ph.Id).add(ph.Product_Manager__c);
                    }
                    if(ph.Regional_PM_AP__c != null && ph.Regional_PM_AP__c != ph.OwnerId ){
                        if(!map_aid_uids2Insert.containsKey(ph.Id)) {
                            map_aid_uids2Insert.put(ph.Id, new set<Id>());
                            map_aid_uids2Insert.get(ph.Id).add(ph.Regional_PM_AP__c);
                        }
                        else map_aid_uids2Insert.get(ph.Id).add(ph.Regional_PM_AP__c);
                    }
                    if(ph.Regional_PM_EU__c != null && ph.Regional_PM_EU__c != ph.OwnerId){
                        if(!map_aid_uids2Insert.containsKey(ph.Id)) {
                            map_aid_uids2Insert.put(ph.Id, new set<Id>());
                            map_aid_uids2Insert.get(ph.Id).add(ph.Regional_PM_EU__c);
                        }
                        else map_aid_uids2Insert.get(ph.Id).add(ph.Regional_PM_EU__c);
                    }
                    if(ph.Regional_PM_US__c != null && ph.Regional_PM_US__c != ph.OwnerId){
                        if(!map_aid_uids2Insert.containsKey(ph.Id)) {
                            map_aid_uids2Insert.put(ph.Id, new set<Id>());
                            map_aid_uids2Insert.get(ph.Id).add(ph.Regional_PM_US__c);
                        }
                        else map_aid_uids2Insert.get(ph.Id).add(ph.Regional_PM_US__c);
                    }
                    if(ph.Global_PM__c != null && ph.Global_PM__c != ph.OwnerId){
                        if(!map_aid_uids2Insert.containsKey(ph.Id)) {
                            map_aid_uids2Insert.put(ph.Id, new set<Id>());
                            map_aid_uids2Insert.get(ph.Id).add(ph.Global_PM__c);
                        }
                        else map_aid_uids2Insert.get(ph.Id).add(ph.Global_PM__c);
                    }
                    if(ph.Approver_PM__c != null && ph.Approver_PM__c != ph.OwnerId){
                        if(!map_aid_uids2Insert.containsKey(ph.Id)) {
                            map_aid_uids2Insert.put(ph.Id, new set<Id>());
                            map_aid_uids2Insert.get(ph.Id).add(ph.Approver_PM__c);
                        }
                        else map_aid_uids2Insert.get(ph.Id).add(ph.Approver_PM__c);
                    }
                }
                
                if(!map_aid_uids2Insert.isEmpty()) insertProductHierarchyShare(map_aid_uids2Insert);
            }
            else if(mode == MODE_DELETE){//Delete Product_Hierarchy__Share
                
                map<id, set<id>> map_aid_uids = new map<id, set<id>>();
                
                for(Product_Hierarchy__c ph : [Select Id, OwnerId, Product_Manager__c, Regional_PM_AP__c, Regional_PM_EU__c, Regional_PM_US__c, Global_PM__c, Approver_PM__c from Product_Hierarchy__c where Id in: set_ids]){
                    if(ph.Product_Manager__c != null && ph.Product_Manager__c != ph.OwnerId){
                        
                        if(!map_aid_uids.containsKey(ph.Id)) {
                            map_aid_uids.put(ph.Id, new set<Id>());
                            map_aid_uids.get(ph.Id).add(ph.Product_Manager__c);
                        }
                        else {
                            map_aid_uids.get(ph.Id).add(ph.Product_Manager__c);
                        }
                    }
                    if(ph.Regional_PM_AP__c != null && ph.Regional_PM_AP__c != ph.OwnerId ){
                        if(!map_aid_uids.containsKey(ph.Id)) {
                            map_aid_uids.put(ph.Id, new set<Id>());
                            map_aid_uids.get(ph.Id).add(ph.Regional_PM_AP__c);
                        }
                        else {
                            map_aid_uids.get(ph.Id).add(ph.Regional_PM_AP__c);
                        }
                    }
                    if(ph.Regional_PM_EU__c != null && ph.Regional_PM_EU__c != ph.OwnerId){
                        if(!map_aid_uids.containsKey(ph.Id)) {
                            map_aid_uids.put(ph.Id, new set<Id>());
                            map_aid_uids.get(ph.Id).add(ph.Regional_PM_EU__c);
                        }
                        else {
                            map_aid_uids.get(ph.Id).add(ph.Regional_PM_EU__c);
                        }
                    }
                    if(ph.Regional_PM_US__c != null && ph.Regional_PM_US__c != ph.OwnerId){
                        if(!map_aid_uids.containsKey(ph.Id)) {
                            map_aid_uids.put(ph.Id, new set<Id>());
                            map_aid_uids.get(ph.Id).add(ph.Regional_PM_US__c);
                        }
                        else {
                            map_aid_uids.get(ph.Id).add(ph.Regional_PM_US__c);
                        }
                    }
                    if(ph.Global_PM__c != null && ph.Global_PM__c != ph.OwnerId){
                        if(!map_aid_uids.containsKey(ph.Id)) {
                            map_aid_uids.put(ph.Id, new set<Id>());
                            map_aid_uids.get(ph.Id).add(ph.Global_PM__c);
                        }
                        else {
                            map_aid_uids.get(ph.Id).add(ph.Global_PM__c);
                        }
                    }
                    if(ph.Approver_PM__c != null && ph.Approver_PM__c != ph.OwnerId){
                        if(!map_aid_uids.containsKey(ph.Id)) {
                            map_aid_uids.put(ph.Id, new set<Id>());
                            map_aid_uids.get(ph.Id).add(ph.Approver_PM__c);
                        }
                        else {
                            map_aid_uids.get(ph.Id).add(ph.Approver_PM__c);
                        }
                    }
                }
                if(!map_aid_uids.isEmpty()){
                    deleteProductHierarchy(map_aid_uids );
                }
            }
        }
    }

    /**
     * This method is used when update a Product_Hierarchy__c record from GPL record type to not GPL record type, 
     * this method is used to delete Product_Hierarchy__c's Sharing : Product_Hierarchy__Share
     *
     @author Yinfeng Guo
     @created 2012-03-19
     @version 1.0
     @since 23.0
     *
     @param map_pId_cIdList         the key is opportunity id, the value is user id collect from fields  "Product_Manager__c", "Regional_PM_AP__c", "Regional_PM_EU__c", "Regional_PM_US__c", "Global_PM__c" and "Approver_PM__c" 
     *
     @return void           
     *
     @changelog
     * 2012-03-19 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    @future
    public static void DeleteProductHierarchySharing (map<id, string> map_pId_cIdList){ 
        if(map_pId_cIdList!= null && !map_pId_cIdList.isEmpty()){
            map<id, set<id>> map_aid_uids = new map<id, set<id>>();
            for(id aid: map_pId_cIdList.keySet()) {
                set<id> set_uids = new set<id>();
                for(string uid: map_pId_cIdList.get(aid).split(',')) {
                    if(uid !=null && uid != ''){
                        set_uids.add(uid);
                    }
                }
                map_aid_uids.put(aid, set_uids);
            }   
            if(!map_aid_uids.isEmpty()) deleteProductHierarchy(map_aid_uids );
        }
    }   
    
//============================================================method for Batch cls============================================================
//============================================================method for Batch cls============================================================

    /**
     * This method is used by batch cls to initilize Customer Team Member
     *
     @author Yinfeng Guo
     @created 2012-02-27
     @version 1.0
     @since 23.0
     *
     @param map_aid_uidList      map's key are Accounts' id and map's value are Account team members' id
     *
     @return void           
     *
     @changelog
     * 2012-02-27 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */
    public static void insertCustomerFocusTeamMemberBatch(map<id, string> map_aid_uidList){
        Id rt_cis_gam = gamCustomSetting();
        if(map_aid_uidList != null && !map_aid_uidList.isEmpty()  && rt_cis_gam != null ){
            /*to transfer from map<id, string> to map<id, set<id>>*/
            map<id, set<id>> map_aid_uids = new map<id, set<id>>();
            for(id aid: map_aid_uidList.keySet()) {
                set<id> set_uids = new set<id>();
                for(string uid: map_aid_uidList.get(aid).split(',')) {
                    if(uid != ''){
                        set_uids.add(uid);
                    }
                }
                map_aid_uids.put(aid, set_uids);
            }
            list<GroupMember> list_groupMembers = new list<GroupMember>();
            Account acc;
            GroupMember grpMeb;
            map<id, account> map_id_acc = new map<id, account>([select id, recordTypeId, Public_Group_Id__c from account where id in: map_aid_uids.keySet()]);
            for(Id aid: map_aid_uids.keySet()) {
                acc = map_id_acc.get(aid);
                for(Id uid: map_aid_uids.get(aid)) {
                    if(acc.recordTypeId != null && acc.recordTypeId == rt_cis_gam && acc.Public_Group_Id__c != null) {
                        grpMeb = new GroupMember();
                        grpMeb.GroupId = acc.Public_Group_Id__c;
                        grpMeb.UserOrGroupId = uid;
                        list_groupMembers.add(grpMeb);
                    }
                }
            }
            //system.debug('tongxia list_groupMembers:' + list_groupMembers);
            if(!list_groupMembers.isEmpty()) //database.insert(list_groupMembers, false);
            insert  list_groupMembers;      
        }       
    }
    
    /**
     * This method is used by batch cls to initilize Account Team Member
     *
     @author Yinfeng Guo
     @created 2012-02-27
     @version 1.0
     @since 23.0
     *
     @param map_aid_uidList      map's key are Accounts' id and map's value are Account team members' id
     *
     @return void           
     *
     @changelog
     * 2012-02-27 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */ 
    public static void upsertAccountTeamMemberBatch(map<id, string> map_aid_uidList){
        upsertAccountTeamMemberCommonForFutureAndBatch(map_aid_uidList);
    }
    
    /**
     * This method is used by batch cls to initilize Account 
     * such as create public group for Account
     *
     @author Yinfeng Guo
     @created 2012-02-13
     @version 1.0
     @since 23.0
     *
     @param set<Id> set_ids         accounts' id inserted or deleted
     *
     @return void           
     *
     @changelog
     * 2012-02-13 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */ 
    public static void modifyAccountSharingBatch (set<Id> set_ids){
        if(set_ids != null && !set_ids.isEmpty()) {
            afterInsertAccount(set_ids);
            grantParentAccess(set_ids);
        }
    }
//============================================================method for Batch cls============================================================
//============================================================method for Batch cls============================================================


    /**
     * This method is used when insert a new Account team member or update a Account team member, 
     * this method is used to insert Account Share if need
     *
     @author Yinfeng Guo
     @created 2012-04-12
     @version 1.0
     @since 23.0
     *
     @param map_aid_uidList      map's key are Accounts' id and map's value are Account team members' id
     *
     @return void           
     *
     @changelog
     * 2012-04-12 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    @future
    public static void upsertAccountTeamShare(map<id, string> map_aid_uidList){
        upsertAccountTeamShareCommonForFutureAndBatch(map_aid_uidList);
        /*
        if(map_aid_uidList != null && !map_aid_uidList.isEmpty()){
            map<id, set<id>> map_aid_uids = new map<id, set<id>>();
            for(id aid: map_aid_uidList.keySet()) {
                set<id> set_uids = new set<id>();
                for(string uid: map_aid_uidList.get(aid).split(',')) {
                    if(uid != ''){
                        set_uids.add(uid);
                    }
                }
                map_aid_uids.put(aid, set_uids);
            }
            
            map<id, Boolean> map_uid_isActive = new map<id, Boolean>();
            map<id, String> map_uid_userType = new map<id, String>();
            set<id> set_allUserId = new set<Id>();
            for(set<Id> set_uid : map_aid_uids.values()){
                set_allUserId.addAll(set_uid);
            }
            for(User u : [select Id, Name, IsActive, UserType from User Where Id in: set_allUserId]){
                map_uid_isActive.put(u.Id, u.IsActive);
                map_uid_userType.put(u.Id, u.UserType);
            }
            
            map<id, map<id, Account_Team__c>> map_aid_uid_Account_Team = new map<id, map<id, Account_Team__c>>();
            for(Account_Team__c atc : [select Opportunity_Access__c, Id, Account__c, Role__c, Team_Member__c from Account_Team__c where Account__c in: map_aid_uids.keySet()]){
                if(!map_aid_uid_Account_Team.containsKey(atc.Account__c)) map_aid_uid_Account_Team.put(atc.Account__c, new map<id, Account_Team__c>()); 
                map_aid_uid_Account_Team.get(atc.Account__c).put(atc.Team_Member__c, atc);
            }
    
            Account_Team__c atc_custom;
            List<AccountShare> list_accShrs  = new List<AccountShare>();
            
            AccountShare accShr;
            
            for(id aid: map_aid_uid_Account_Team.keySet()) {
                for(id uid: map_aid_uid_Account_Team.get(aid).keySet()) {
                    atc_custom = map_aid_uid_Account_Team.get(aid).get(uid);
                    if(map_uid_isActive.get(uid)== true && map_uid_userType.get(uid) == 'Standard') {
                        accShr = new AccountShare();
                        accShr.AccountId = aid;
                        accShr.UserOrGroupId = uid;
                        accShr.AccountAccessLevel = 'Edit';
                        accShr.CaseAccessLevel = 'Edit';
                        //accShr.RowCause = 'Manual';
                        if(atc_custom.Opportunity_Access__c == 'Edit') accShr.OpportunityAccessLevel = 'Edit';
                        else if(atc_custom.Opportunity_Access__c == 'Read-Only') accShr.OpportunityAccessLevel = 'Read';
                        else if(atc_custom.Opportunity_Access__c == 'No Access') accShr.OpportunityAccessLevel = 'None';
                        list_accShrs.add(accShr);
                    }
                }
            }
            //system.debug('yinfeng:test:inin:list_accShrs:'+list_accShrs);
            if(!list_accShrs.isEmpty()) insert list_accShrs;
        }
        */
    }
    /**
     * This method is used when insert a new Account team member or update a Account team member, 
     * this method is used to insert Account Share if need
     * this method is invoked in batch class
     *
     @author Yinfeng Guo
     @created 2012-04-12
     @version 1.0
     @since 23.0
     *
     @param map_aid_uidList      map's key are Accounts' id and map's value are Account team members' id
     *
     @return void           
     *
     @changelog
     * 2012-04-12 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    public static void upsertAccountTeamShareBatch(map<id, string> map_aid_uidList){
        upsertAccountTeamShareCommonForFutureAndBatch(map_aid_uidList);
    }   
    
    

    

    

    


    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public static method=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%








    //********************************* -=BEGIN private methods=- *********************************
    /**
     * This method is used when update a account from Not GAM to GAM. 
     * at this moment, a new public group will be created, at the same time, we should let the child account grant access to this public group in Parent Account
     *
     @author Yinfeng Guo
     @created 2012-06-26
     @version 1.0
     @since 23.0
     *
     @param map_id_group       map's key is Account id and the value is Group of this Account
     *
     @return void           
     *
     @changelog
     * 2012-06-26 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created 
     */     
    private void GrantParentGroupShare(Map<Id, Group> map_id_group){
        map<Id, Id> map_childAccId_parentAccId = new map<Id, Id>();
        for(Account a : [select Id, ParentId from Account where ParentId in: map_id_group.keySet()]){
            map_childAccId_parentAccId.put(a.Id, a.ParentId);
        }
        AccountShare cAccShr;
        list<AccountShare> list_cAccShrs = new list<AccountShare>();
        for(Id childId : map_childAccId_parentAccId.keySet()){
            Id publicGroupId = map_id_group.get(map_childAccId_parentAccId.get(childId)).Id;
            if( publicGroupId != null && String.valueOf(publicGroupId) != ''){
                cAccShr = new AccountShare();
                cAccShr.AccountId = childId;
                cAccShr.UserOrGroupId = publicGroupId;
                cAccShr.AccountAccessLevel = 'Edit';
                cAccShr.CaseAccessLevel = 'Edit';
                cAccShr.OpportunityAccessLevel = 'Edit';
                list_cAccShrs.add(cAccShr);
            }
        }
        //system.debug('list_cAccShrs:aaa@@@@:'+list_cAccShrs);
        if(!list_cAccShrs.isEmpty()) insert list_cAccShrs;
    }

    /**
     * This method is used when insert a new Account team member or update a Account team member, 
     * this method is used to insert Account Share if need
     *
     @author Yinfeng Guo
     @created 2012-04-12
     @version 1.0
     @since 23.0
     *
     @param map_aid_uidList      map's key are Accounts' id and map's value are Account team members' id
     *
     @return void           
     *
     @changelog
     * 2012-04-12 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    private static void upsertAccountTeamShareCommonForFutureAndBatch(map<id, string> map_aid_uidList){
        if(map_aid_uidList != null && !map_aid_uidList.isEmpty()){
            map<id, set<id>> map_aid_uids = new map<id, set<id>>();
            for(id aid: map_aid_uidList.keySet()) {
                set<id> set_uids = new set<id>();
                for(string uid: map_aid_uidList.get(aid).split(',')) {
                    if(uid != ''){
                        set_uids.add(uid);
                    }
                }
                map_aid_uids.put(aid, set_uids);
            }
            map<id, Boolean> map_uid_isActive = new map<id, Boolean>();
            map<id, String> map_uid_userType = new map<id, String>();
            set<id> set_allUserId = new set<Id>();
            for(set<Id> set_uid : map_aid_uids.values()){
                set_allUserId.addAll(set_uid);
            }
            for(User u : [select Id, Name, IsActive, UserType from User Where Id in: set_allUserId]){
                map_uid_isActive.put(u.Id, u.IsActive);
                map_uid_userType.put(u.Id, u.UserType);
            }
            map<id, map<id, Account_Team__c>> map_aid_uid_Account_Team = new map<id, map<id, Account_Team__c>>();
            for(Account_Team__c atc : [select Opportunity_Access__c, Id, Account__c, Role__c, Team_Member__c from Account_Team__c where Account__c in: map_aid_uids.keySet()]){
                if(!map_aid_uid_Account_Team.containsKey(atc.Account__c)) map_aid_uid_Account_Team.put(atc.Account__c, new map<id, Account_Team__c>()); 
                map_aid_uid_Account_Team.get(atc.Account__c).put(atc.Team_Member__c, atc);
            }
            map<id, id> map_accId_uids_existowner = new map<id, id>();
            for(AccountShare a : [Select Id, AccountId, UserOrGroupId from AccountShare where AccountId in: map_aid_uids.keySet() and RowCause = 'Owner']){
                map_accId_uids_existowner.put(a.AccountId, a.UserOrGroupId);
            }   
            Account_Team__c atc_custom;
            List<AccountShare> list_accShrs  = new List<AccountShare>();
            AccountShare accShr;
            for(id aid: map_aid_uid_Account_Team.keySet()) {
                for(id uid: map_aid_uid_Account_Team.get(aid).keySet()) {
                    atc_custom = map_aid_uid_Account_Team.get(aid).get(uid);
                    if(map_uid_isActive.get(uid)== true && map_uid_userType.get(uid) == 'Standard' && map_accId_uids_existowner.get(aid) != uid) {
                        accShr = new AccountShare();
                        accShr.AccountId = aid;
                        accShr.UserOrGroupId = uid;
                        accShr.AccountAccessLevel = 'Edit';
                        accShr.CaseAccessLevel = 'Edit';
                        //accShr.RowCause = 'Manual';
                        if(atc_custom.Opportunity_Access__c == 'Edit') accShr.OpportunityAccessLevel = 'Edit';
                        else if(atc_custom.Opportunity_Access__c == 'Read-Only') accShr.OpportunityAccessLevel = 'Read';
                        else if(atc_custom.Opportunity_Access__c == 'No Access') accShr.OpportunityAccessLevel = 'None';
                        list_accShrs.add(accShr);
                    }
                }
            }
            //system.debug('yinfeng:test:inin:list_accShrs:'+list_accShrs);
            if(!list_accShrs.isEmpty()) insert list_accShrs;
        }       
    }
    
    /**
     * When to use this method: when need to insert AccountTeamMember record , no matter in future method or method in batch class.
     *                          when insert some Account_Team__c records or update some Account_Team__c records need to invoke this method
     * This method to do :
     *  1.Create AccountTeamMember
     *  2.Insert related AccountShare 
     *  3.Grant access to related Opportunity 
     *
     @author Yinfeng Guo
     @created 2012-04-12
     @version 1.0
     @since 23.0
     *
     @param map_pId_uIds        the key is account id, the value is a string that contains User Id, this string use comma to separate different User Id
     *
     @return                    void            
     *
     @changelog
     * 2012-04-12 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */ 
    private static void upsertAccountTeamMemberCommonForFutureAndBatch(map<id, string> map_aid_uidList){
        Id rt_cis_gam = gamCustomSetting();
        if(map_aid_uidList != null && !map_aid_uidList.isEmpty()){
            /*to transfer from map<id, string> to map<id, set<id>>*/
            map<id, set<id>> map_aid_uids = new map<id, set<id>>();
            for(id aid: map_aid_uidList.keySet()) {
                set<id> set_uids = new set<id>();
                for(string uid: map_aid_uidList.get(aid).split(',')) {
                    if(uid.trim() != ''){
                        set_uids.add(uid.trim());
                    }
                }
                map_aid_uids.put(aid, set_uids);
            }
            map<id, Boolean> map_uid_isActive = new map<id, Boolean>();
            map<id, String> map_uid_userType = new map<id, String>();
            set<id> set_allUserId = new set<Id>();
            for(set<Id> set_uid : map_aid_uids.values()){
                set_allUserId.addAll(set_uid);
            }
            for(User u : [select Id, Name, IsActive, UserType from User Where Id in: set_allUserId]){
                map_uid_isActive.put(u.Id, u.IsActive);
                map_uid_userType.put(u.Id, u.UserType);
            }
            list<Account_Team__c> list_accTeams = new list<Account_Team__c>();
            map<id, map<id, Account_Team__c>> map_aid_uid = new map<id, map<id, Account_Team__c>>();
            for(Account_Team__c atc : [select Opportunity_Access__c, Id, Account__c, Role__c, Team_Member__c from Account_Team__c where Account__c in: map_aid_uids.keySet()]){
                list_accTeams.add(atc);
                if(!map_aid_uid.containsKey(atc.Account__c)) map_aid_uid.put(atc.Account__c, new map<id, Account_Team__c>()); 
                map_aid_uid.get(atc.Account__c).put(atc.Team_Member__c, atc);
            }
            AccountTeamMember accTmeb;
            Account_Team__c atc_custom;
            List<AccountTeamMember> list_accTmebs  = new List<AccountTeamMember>();
            for(id aid: map_aid_uid.keySet()) {
                for(id uid: map_aid_uid.get(aid).keySet()) {
                    atc_custom = map_aid_uid.get(aid).get(uid);
                    if(map_uid_isActive.get(uid)== true && map_uid_userType.get(uid) == 'Standard') {
                        accTmeb = new AccountTeamMember();
                        accTmeb.AccountId = aid;
                        accTmeb.UserId = uid;
                        accTmeb.TeamMemberRole = atc_custom.Role__c;
                        list_accTmebs.add(accTmeb);
                    }
                }
            }
            if(!list_accTmebs.isEmpty()) insert list_accTmebs;
            AccountShare accSha;
            List<AccountShare> list_accShare = new List<AccountShare>();
            map<id, id> map_accId_uids_existowner = new map<id, id>();
            for(AccountShare a : [Select Id, AccountId, UserOrGroupId from AccountShare where AccountId in: map_aid_uids.keySet() and RowCause = 'Owner']){
                map_accId_uids_existowner.put(a.AccountId, a.UserOrGroupId);
            }           
            for(id aid: map_aid_uid.keySet()) {
                for(id uid: map_aid_uid.get(aid).keySet()) {
                    atc_custom = map_aid_uid.get(aid).get(uid);
                    if(map_uid_isActive.get(uid)== true && map_uid_userType.get(uid) == 'Standard'  && map_accId_uids_existowner.get(aid) != uid) {
                        accSha = new AccountShare();
                        accSha.AccountId = aid;
                        accSha.UserOrGroupId = uid;
                        //To check if it is correct.
                        accSha.AccountAccessLevel = 'Edit';
                        if(atc_custom.Opportunity_Access__c == 'Edit') accSha.OpportunityAccessLevel = 'Edit';
                        else if(atc_custom.Opportunity_Access__c == 'Read-Only') accSha.OpportunityAccessLevel = 'Read';
                        else if(atc_custom.Opportunity_Access__c == 'No Access') accSha.OpportunityAccessLevel = 'None';
                        if(accSha.OpportunityAccessLevel != null)  list_accShare.add(accSha);
                    }
                }
            }
            
            if(!list_accShare.isEmpty()) insert list_accShare;
            map<id, set<id>> map_oppyId_uids_delete = new map<id, set<id>>();
            map<id, id> map_oppyId_uids_existowner = new map<id, id>();
            list<OpportunityShare> list_oppyShare2Delete = new list<OpportunityShare>();
            list<OpportunityShare> list_oppyShare = new list<OpportunityShare>();
            map<id, Opportunity> map_id_opp = new map<id, Opportunity>([Select Id, AccountId from Opportunity where AccountId in: map_aid_uids.keySet() ]);
            for(OpportunityShare o : [Select Id, OpportunityId, UserOrGroupId from OpportunityShare where OpportunityId in: map_id_opp.keySet() and RowCause = 'Owner']){
                map_oppyId_uids_existowner.put(o.OpportunityId, o.UserOrGroupId);
            }
            for(Opportunity o: map_id_opp.values()) {
                set<Id> set_uids2Delete = new set<Id>();
                for(id userId: map_aid_uids.get(o.AccountId)) {
                    if(map_uid_isActive.get(userId)== true && map_uid_userType.get(userId) == 'Standard' && map_oppyId_uids_existowner.get(o.id) != userId) {
                        OpportunityShare oppyShare = new OpportunityShare();
                        oppyShare.OpportunityId = o.id;
                        oppyShare.UserOrGroupId = userId;
                        String oppAL = map_aid_uid.get(o.AccountId).get(userId).Opportunity_Access__c;
                        if(oppAL == 'Edit') oppyShare.OpportunityAccessLevel = 'Edit';
                        else if(oppAL == 'Read-Only') oppyShare.OpportunityAccessLevel = 'Read';
                        else if(oppAL == 'No Access') set_uids2Delete.add(userId);
                        if(oppyShare.OpportunityAccessLevel != null) list_oppyShare.add(oppyShare);
                    }
                }
                if(!set_uids2Delete.isEmpty()) map_oppyId_uids_delete.put(o.id, set_uids2Delete);
            }
            if(!list_oppyShare.isEmpty()) insert list_oppyShare;
            for(OpportunityShare os : [Select Id, OpportunityId, UserOrGroupId, RowCause from OpportunityShare where RowCause = 'Manual' and OpportunityId in: map_oppyId_uids_delete.keySet()]){
                if(map_oppyId_uids_delete.get(os.OpportunityId).contains(os.UserOrGroupId)) list_oppyShare2Delete.add(os);
            }
            if(!list_oppyShare2Delete.isEmpty()){
                delete list_oppyShare2Delete;
            }
        }       
    }
    /**
     * This method is used when insert a Product_Hierarchy__c that Record type is GPL or update Product_Hierarchy__c from Not GPL Record Type to GPL Record Type,
     * this method to create Product_Hierarchy__Share for "Product_Manager__c", "Regional_PM_AP__c", "Regional_PM_EU__c", "Regional_PM_US__c", "Global_PM__c" and "Approver_PM__c" 
     * Implement process : New Product_Hierarchy__Share, record's ParentId is Opportunity Id, record's UserOrGroupId is User Id.
     *
     @author Yinfeng Guo
     @created 2012-03-19
     @version 1.0
     @since 23.0
     *
     @param map_pId_uIds        the key is opportunity id, the value is user id collect from "Product_Manager__c", "Regional_PM_AP__c", "Regional_PM_EU__c", "Regional_PM_US__c", "Global_PM__c" and "Approver_PM__c" 
     *
     @return                void            
     *
     @changelog
     * 2012-03-19 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    private static void insertProductHierarchyShare(map<id, set<id>> map_pId_uIds){
        if(!map_pId_uIds.isEmpty()){
            list<Product_Hierarchy__Share> list_phShare2Insert = new list<Product_Hierarchy__Share>();
            for(Id pId : map_pId_uIds.keySet()){
                for(Id uId : map_pId_uIds.get(pId)){
                    Product_Hierarchy__Share phShare = new Product_Hierarchy__Share();
                    phShare.ParentId = pId;
                    phShare.UserOrGroupId = uId;
                    phShare.AccessLevel = 'Read';
                    list_phShare2Insert.add(phShare);
                }
            }
            if(!list_phShare2Insert.isEmpty()){
                insert list_phShare2Insert;
            }
        }
    }
    
    /**
     * This method is used when update Product_Hierarchy__c from GPL Record Type to Not GPL Record Type, this moment we need to delete some related Product_Hierarchy__Share
     * this method to delete Product_Hierarchy__Share for "Product_Manager__c", "Regional_PM_AP__c", "Regional_PM_EU__c", "Regional_PM_US__c", "Global_PM__c" and "Approver_PM__c" 
     * Implement process : select out Product_Hierarchy__Share, the where condition is : ParentId = Opportunity Id, RowCause = 'Manual'. Then delete the lists selected out. 
     *
     @author Yinfeng Guo
     @created 2012-03-19
     @version 1.0
     @since 23.0
     *
     @param map_pId_uIds        the key is opportunity id, the value is user id collect from "Product_Manager__c", "Regional_PM_AP__c", "Regional_PM_EU__c", "Regional_PM_US__c", "Global_PM__c" and "Approver_PM__c" 
     *
     @return                void            
     *
     @changelog
     * 2012-03-19 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    private static void deleteProductHierarchy(map<id, set<id>> map_pId_uIds){
        if(!map_pId_uIds.isEmpty()){
            list<Product_Hierarchy__Share> list_phShare2Delete = new list<Product_Hierarchy__Share>();
            for(Product_Hierarchy__Share phShare : [Select Id, UserOrGroupId, ParentId, RowCause from Product_Hierarchy__Share where ParentId in: map_pId_uIds.keySet() and RowCause =: 'Manual']){
                if(map_pId_uIds.get(phShare.ParentId).contains(phShare.UserOrGroupId)){
                    list_phShare2Delete.add(phShare);
                }
            }
            if(!list_phShare2Delete.isEmpty()){
                delete list_phShare2Delete;
            }
        }
    }
    
    /**
     * This method is used when insert a new Account,
     * this method to create Group and then replicate Group id to Account' field Public_Group_Id__c,
     * and create AccountShare for the created Account.
     * Implement process : validate whether is RT, if right, create group ,then save the group id into account, and then create Account share for the group
     *
     @author Yinfeng Guo
     @created 2012-02-13
     @version 1.0
     @since 23.0
     *
     @param set_ids         the inserted accounts' id
     *
     @return                void            
     *
     @changelog
     * 2012-02-13 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */          
    private static void afterInsertAccount(set<Id> set_ids){
        //need to change by xia 2013-03-19 add b account;
        
        Id rt_cis_gam = gamCustomSetting();
        map<Integer,Account> map_int_account = new  map<Integer,Account>();
        map<Integer,Group> map_int_group = new  map<Integer,Group>();
        list<Account> list_accounts = [Select Id, Name, ParentId, RecordTypeId, Public_Group_Id__c, GAMCD__c From Account where Id in: set_ids and RecordTypeId =: rt_cis_gam];
        for(Integer i = 0; i < list_accounts.size(); i++){
            map_int_account.put(i,list_accounts[i]);
            Group g = new Group();
            g.Name = NAME_PREFIX + list_accounts[i].GAMCD__c;
            map_int_group.put(i,g); 
                    
        }
        insert map_int_group.values();
        for(Integer i : map_int_group.keySet()){
            map_int_account.get(i).Public_Group_Id__c =  map_int_group.get(i).Id;
        }
        if(!map_int_account.isEmpty()){
            ClsSharingUtil.TriggerRecursionDefense = true;
            update map_int_account.values();
            ClsSharingUtil.TriggerRecursionDefense = false;
        }
        /*Share the Account with the created Public Group, including Opportunity and Case Access. (Access Level: "Edit")*/
        List<AccountShare> list_accShrs  = new List<AccountShare>();
        AccountShare accShr;
        for(Account a :map_int_account.values()){
            accShr = new AccountShare();
            accShr.AccountId = a.Id;
            accShr.UserOrGroupId = a.Public_Group_Id__c;
            accShr.AccountAccessLevel = 'Edit';
            accShr.CaseAccessLevel = 'Edit';
            accShr.OpportunityAccessLevel = 'Edit';
            list_accShrs.add(accShr);
        }
        insert list_accShrs;
        /*Share the Account with the created Public Group, including Opportunity and Case Access. (Access Level: "Edit")*/
    }
    
    
    /**
     * This method is used when insert a new account with a parent id or when update a account with a parent id
     * this method is used to grant parent access
     * Implement process : validate whether exist parent id, if exist, create Account share for the parent group
     *
     @author Yinfeng Guo
     @created 2012-02-13
     @version 1.0
     @since 23.0
     *
     @param set_ids         the inserted or updated accounts' id
     *
     @return                void            
     *
     @changelog
     * 2012-02-13 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    private static void grantParentAccess(set<Id> set_ids){
        //need to change by xia 2013-03-19
        
        Id rt_cis_gam = gamCustomSetting();
        /*Grand Parent Access*/
        
        //map<Id,Id> map_parentId_childId = new map<Id,Id>();
        list<Account> list_pAccs = new list<Account>();
        List<AccountShare> list_cAccShrs  = new List<AccountShare>();
        
        AccountShare cAccShr;
        
        map<Id,Id> map_childAccId_parentAccId = new map<Id,Id>();
        for(Account childAcc : [Select Id, Name, ParentId, RecordTypeId, Public_Group_Id__c From Account where Id in: set_ids]){
            if(childAcc.ParentId != null && String.valueOf(childAcc.ParentId) != ''){
                //map_parentId_childId.put(childAcc.ParentId, childAcc.Id);
                map_childAccId_parentAccId.put(childAcc.Id, childAcc.ParentId);
            }
        }
        /*
        list_pAccs = [Select Id, RecordTypeId, Public_Group_Id__c from Account where Id in: map_parentId_childId.keySet()];
        for(Account a : list_pAccs){
            if(a.RecordTypeId == rt_cis_gam && a.Public_Group_Id__c != null){
                if(map_parentId_childId.containsKey(a.Id)){
                    cAccShr = new AccountShare();
                    cAccShr.AccountId = map_parentId_childId.get(a.Id);
                    cAccShr.UserOrGroupId = a.Public_Group_Id__c;
                    cAccShr.AccountAccessLevel = 'Edit';
                    cAccShr.CaseAccessLevel = 'Edit';
                    cAccShr.OpportunityAccessLevel = 'Edit';
                    list_cAccShrs.add(cAccShr);
                }
            }
        }
        */
        
        map<Id, Account> map_parentAccId_parentAcc = new map<Id, Account>();
        for(Account a : [Select Id, RecordTypeId, Public_Group_Id__c from Account where Id in: map_childAccId_parentAccId.values()]){
            map_parentAccId_parentAcc.put(a.Id, a);
        }
        
        for(Id childId : map_childAccId_parentAccId.keySet()){
            Account a = map_parentAccId_parentAcc.get(map_childAccId_parentAccId.get(childId));
            if(a != null){
                if(a.RecordTypeId == rt_cis_gam && a.Public_Group_Id__c != null && String.valueOf(a.Public_Group_Id__c) != ''){
                    //system.debug('childId:aaa@@@@:'+childId);
                    //system.debug('a.Public_Group_Id__c:aaa@@@@:'+a.Public_Group_Id__c);
                    cAccShr = new AccountShare();
                    cAccShr.AccountId = childId;
                    cAccShr.UserOrGroupId = a.Public_Group_Id__c;
                    cAccShr.AccountAccessLevel = 'Edit';
                    cAccShr.CaseAccessLevel = 'Edit';
                    cAccShr.OpportunityAccessLevel = 'Edit';
                    list_cAccShrs.add(cAccShr);
                }
            }   
        }
        //system.debug('list_cAccShrs:aaa@@@@:'+list_cAccShrs);
        if(!list_cAccShrs.isEmpty()) insert list_cAccShrs;
        /*Grand Parent Access*/ 
    }
    
    

    /**
     * This method is used when updata a account with a parent id, 
     * and update from with valid parent Account to invalid parent Account or delete the parent Account id field
     * this method is used to cancel parent access, delete AccountShare for the parent account
     *
     @author Yinfeng Guo
     @created 2012-02-13
     @version 1.0
     @since 23.0
     *
     @param     map_pid_cids        map's key is parent account id and the value is child account id
     *
     @return                        void            
     *
     @changelog
     * 2012-02-13 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    private static void cancelParentAccess(map<id, set<id>> map_pid_cids){
        if((map_pid_cids != null && !map_pid_cids.isEmpty())){
            map<Id,Id> map_groupId_pAccId = new map<Id,Id>();
            list<AccountShare> list_accShrs2Del = new list<AccountShare>();
            for(Account a : [Select Id, Name, ParentId, RecordTypeId, Public_Group_Id__c From Account where Id in: map_pid_cids.keySet()]){
                map_groupId_pAccId.put(a.Public_Group_Id__c, a.Id);
            }
            for(AccountShare accShr : [Select Id, AccountId, UserOrGroupId  From AccountShare where UserOrGroupId in: map_groupId_pAccId.keySet()]){
                if(map_pid_cids.get( map_groupId_pAccId.get(accShr.UserOrGroupId) ).contains(accShr.AccountId) ){
                    list_accShrs2Del.add(accShr);
                }
            }
            if(!list_accShrs2Del.isEmpty()){
                delete list_accShrs2Del;
            }
        }
    }
    
    //********************************* -=END private methods=- ***********************************
    
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************    



//============================================================below methods are not used now============================================================
//============================================================below methods are not used now============================================================
    /*
    @future 
    public static void deleteGroupMember(set<id> set_gids, set<id> set_uids){
            Id rt_cis_gam = gamCustomSetting();
            Account acc;
            map<id, map<id, GroupMember>> map_gid_uid_gm = new map<id, map<id, GroupMember>>();
            list<GroupMember> list_groupMembers = new list<GroupMember>();
            for(GroupMember gm: [select id, GroupId, UserOrGroupId from GroupMember where GroupId in: set_gids]) {
                if(!map_gid_uid_gm.containskey(gm.GroupId)) {
                    map_gid_uid_gm.put(gm.GroupId, new map<id, GroupMember>());
                }
                if(!map_gid_uid_gm.get(gm.GroupId).containsKey(gm.UserOrGroupId)) {
                    map_gid_uid_gm.get(gm.GroupId).put(gm.UserOrGroupId, gm);
                }
            }
            for(Id gid : set_gids){
                for(Id uid : set_uids){
                    if(gid != null && uid != null && map_gid_uid_gm.containsKey(gid) && map_gid_uid_gm.get(gid).containsKey(uid)){
                        list_groupMembers.add(map_gid_uid_gm.get(gid).get(uid));
                    }
                }
            }
            if(!list_groupMembers.isEmpty()) delete list_groupMembers; 
    }
    */  

    /**
     * This method is used when insert a new Account team member or update a Account team member, 
     * this method is used to insert Group member or Account Share if need
     *
     @author Yinfeng Guo
     @created 2012-02-13
     @version 1.0
     @since 23.0
     *
     @param map_aid_uidList      map's key are Accounts' id and map's value are Account team members' id
     *
     @return void           
     *
     @changelog
     * 2012-02-13 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    @future
    public static void insertTeamShare_notuse(map<id, string> map_aid_uidList){
        Id rt_cis_gam = gamCustomSetting();
        if(map_aid_uidList != null && !map_aid_uidList.isEmpty()){
            /*to transfer from map<id, string> to map<id, set<id>>*/
            map<id, set<id>> map_aid_uids = new map<id, set<id>>();
            for(id aid: map_aid_uidList.keySet()) {
                set<id> set_uids = new set<id>();
                for(string uid: map_aid_uidList.get(aid).split(',')) {
                    if(uid != ''){
                        set_uids.add(uid);
                    }
                }
                map_aid_uids.put(aid, set_uids);
            }
            
            map<id, account> map_id_acc = new map<id, account>([select id, recordTypeId, Public_Group_Id__c from account where id in: map_aid_uids.keySet()]);

            map<Id, Account_Team__c> map_id_accTmeb = new map<Id, Account_Team__c>();
            map<Id, String> map_uid_role = new map<Id, String>();
            map<Id, Id> map_accId_atId = new map<Id, Id>();
            for(Account_Team__c atc : [select Id, Account__c, Role__c, Team_Member__c from Account_Team__c where Account__c in: map_aid_uids.keySet()]){
                map_id_accTmeb.put(atc.Id, atc);
                map_accId_atId.put(atc.Account__c, atc.Id );
                map_uid_role.put(atc.Team_Member__c, atc.Role__c);
            }
            AccountTeamMember accTmeb;
            List<AccountTeamMember> list_accTmebs  = new List<AccountTeamMember>();
            
                        
            list<GroupMember> list_groupMembers = new list<GroupMember>();
            //List<AccountShare> list_accShrs  = new List<AccountShare>();
            
            set<Id> set_temMebIds = new set<Id>();
            account acc;
            GroupMember grpMeb;
            //AccountShare accShr;
            
            for(Id aid: map_aid_uids.keySet()) {
                acc = map_id_acc.get(aid);
                for(Id uid: map_aid_uids.get(aid)) {
                    if(acc.recordTypeId != null && rt_cis_gam != null && acc.recordTypeId == rt_cis_gam) {
                        if(acc.Public_Group_Id__c != null) {
                            grpMeb = new GroupMember();
                            grpMeb.GroupId = acc.Public_Group_Id__c;
                            grpMeb.UserOrGroupId = uid;
                            list_groupMembers.add(grpMeb);
                        }
                    }
                    else {
                        accTmeb = new AccountTeamMember();
                        accTmeb.AccountId = aid;
                        accTmeb.UserId = uid;
                        //accTmeb.AccountAccessLevel = 'Edit';
                        //if(map_accId_atId.containsKey(acc.Id) && map_accId_atId.get(acc.Id) != null && map_id_accTmeb.containsKey(map_accId_atId.get(acc.Id)) && map_id_accTmeb.get(map_accId_atId.get(acc.Id)).Team_Member__c == uid ){
                        //  accTmeb.TeamMemberRole = map_id_accTmeb.get(map_accId_atId.get(acc.Id)).Role__c;
                        //}
                        if(map_uid_role.containsKey(uid) && map_uid_role.get(uid) != null){
                            accTmeb.TeamMemberRole = map_uid_role.get(uid);
                        }
                        list_accTmebs.add(accTmeb);
                        //system.debug('yinfeng:test:accTmeb:'+accTmeb);
                        /*
                        accShr = new AccountShare();
                        accShr.AccountId = aid;
                        accShr.UserOrGroupId = uid;
                        accShr.AccountAccessLevel = 'Edit';
                        accShr.CaseAccessLevel = 'Edit';
                        accShr.OpportunityAccessLevel = 'Edit';
                        list_accShrs.add(accShr);
                        */
                    }
                }
            }
            //system.debug('yinfeng:test:list_accTmebs:'+list_accTmebs);
            if(!list_groupMembers.isEmpty()) insert list_groupMembers;
            if(!list_accTmebs.isEmpty()) insert list_accTmebs;
            
        }
    }       

    public static void insertTeamShareBatch(map<id, string> map_aid_uidList){
        Id rt_cis_gam = gamCustomSetting();
        if(map_aid_uidList != null && !map_aid_uidList.isEmpty() && rt_cis_gam != null){
            map<id, set<id>> map_aid_uids = new map<id, set<id>>();
            for(id aid: map_aid_uidList.keySet()) {
                set<id> set_uids = new set<id>();
                for(string uid: map_aid_uidList.get(aid).split(',')) {
                    if(uid != ''){
                        set_uids.add(uid);
                    }
                }
                map_aid_uids.put(aid, set_uids);
            }
            
            map<Id, account> map_id_acc = new map<Id, account>([select Id, RecordTypeId, Public_Group_Id__c from account where id in: map_aid_uids.keySet()]);
            
            
            map<Id, Account_Team__c> map_id_accTmeb = new map<Id, Account_Team__c>();
            map<Id, Id> map_accId_atId = new map<Id, Id>();
            map<Id, String> map_uid_role = new map<Id, String>();
            for(Account_Team__c atc : [select Id, Account__c, Role__c, Team_Member__c from Account_Team__c where Account__c in: map_aid_uids.keySet()]){
                map_id_accTmeb.put(atc.Id, atc);
                map_accId_atId.put(atc.Account__c, atc.Id );
                map_uid_role.put(atc.Team_Member__c, atc.Role__c);
            }
            AccountTeamMember accTmeb;
            List<AccountTeamMember> list_accTmebs  = new List<AccountTeamMember>();
            
            
            list<GroupMember> list_groupMembers = new list<GroupMember>();
            //List<AccountShare> list_accShrs  = new List<AccountShare>();
            
            set<Id> set_temMebIds = new set<Id>();
            account acc;
            GroupMember grpMeb;
            //AccountShare accShr;
            
            for(Id aid: map_aid_uids.keySet()) {
                acc = map_id_acc.get(aid);
                for(Id uid: map_aid_uids.get(aid)) {
                    if(acc.recordTypeId != null && acc.recordTypeId == rt_cis_gam) {
                        if(acc.Public_Group_Id__c != null) {
                            grpMeb = new GroupMember();
                            grpMeb.GroupId = acc.Public_Group_Id__c;
                            grpMeb.UserOrGroupId = uid;
                            list_groupMembers.add(grpMeb);
                        }
                    }
                    else {
                        accTmeb = new AccountTeamMember();
                        accTmeb.AccountId = aid;
                        accTmeb.UserId = uid;
                        //accTmeb.AccountAccessLevel = 'Edit';
                        if(map_uid_role.containsKey(uid) && map_uid_role.get(uid) != null){
                            accTmeb.TeamMemberRole = map_uid_role.get(uid);
                        }
                        list_accTmebs.add(accTmeb);
                        /*
                        accShr = new AccountShare();
                        accShr.AccountId = aid;
                        accShr.UserOrGroupId = uid;
                        accShr.AccountAccessLevel = 'Edit';
                        accShr.CaseAccessLevel = 'Edit';
                        accShr.OpportunityAccessLevel = 'Edit';
                        list_accShrs.add(accShr);
                        */
                    }
                }
            }
            if(!list_groupMembers.isEmpty()) insert list_groupMembers;
            if(!list_accTmebs.isEmpty()) insert list_accTmebs;
            
        }
    }
    
        /**
     * This method is used to set Account Sales Hierarchy
     *
     @author Xia Tong
     @created 2013-03-26
     @version 1.0
     @since 23.0
     *
     @param map_code_accounts      map's key are GAM code or Marketing manager code and map's value are list of Account 
     *
     @return void           
     *
     @changelog
     * 2013-03-26 Xia Tong <xia.tong@itbconsult.com>
     * - Created
     */ 
    public static void setAccountSalesHierarchy(map<String, list<Account>> map_code_accounts){
        
        map<Id, String> map_acctId_acctTeamMemberUserId = new map<Id, String>();
        map<Id, set<String>> map_hierarchyId_set_userId = new map<Id, set<String>>();
        map<String, list<Account>> map_hierarchyId_list_accounts = new map<String, list<Account>>();
        set<Id> set_userIds = new set<Id>();
        Id castIronSeviceId = (Id) Apex_Helper_Settings__c.getInstance('TEIS Admin User Id').Value__c;
        
        for(Sales_Hierarchy__c sh: [select Id, Level_7_Territory_Code__c, Level_7_Assigned_Users__c, Level_7_Default_Owner__c  
                                    from Sales_Hierarchy__c 
                                    where Level_7_Territory_Code__c in:map_code_accounts.keyset()]){
            for(Account acc: map_code_accounts.get(sh.Level_7_Territory_Code__c)){
                if(acc.GAMCD__c == sh.Level_7_Territory_Code__c){
                    acc.Sales_Hierarchy_GAM__c = sh.Id;
                }else if(acc.IND_KAM_Code__c == sh.Level_7_Territory_Code__c){
                    acc.Sales_Hierarchy_MM__c = sh.Id;
                }
            }        
        }        
    }
    
        /**
     * This method is used to delete public group
     *
     @author Xia Tong
     @created 2013-03-26
     @version 1.0
     @since 23.0
     *
     @param set_groupName2Delete      set of group name 
     *
     @return void           
     *
     @changelog
     * 2013-03-26 Xia Tong <xia.tong@itbconsult.com>
     * - Created
     */     
    @future
    public static void deletPublicGroup(set<String> set_groupName2Delete){
        //system.debug('tongxia:deletPublicGroup start');
        //system.debug('tongxia set_groupName2Delete:' + set_groupName2Delete);
        list<Group> list_group2Delete = new list<Group>();
        list_group2Delete = [select id,name from Group where name in: set_groupName2Delete];
        if(!list_group2Delete.isEmpty()) delete list_group2Delete;
        //system.debug('tongxia:deletPublicGroup end');
    }
    
            /**
     * This method is used to insert public group and add account sharing for the public group
     *
     @author Xia Tong
     @created 2013-03-26
     @version 1.0
     @since 23.0
     *
     @param map_shId_groupName          key: sales Hierarchy Id; value: public group name
     @param map_shId_accId              key: sales Hierarchy Id; value: account Id 
     @param map_groupName_shId4child    key: public group name; value: sales Hierarchy Id of child account
     @param set_childId                 set of child account id
     *
     @return void           
     *
     @changelog
     * 2013-03-26 Xia Tong <xia.tong@itbconsult.com>
     * - Created
     */
    public static void insertPublicGroupSharing(map<Id,String> map_shId_groupName,map<Id,Id> map_shId_accId,map<String,Id> map_groupName_shId4child,set<Id> set_childId){
        //system.debug('tongxia:insertPublicGroupSharing start:::');
        
        // Added by Lili Zhao 2014-03-10 begin due to add the account Manager to GroupMember
        list<GroupMember> list_groupMembers = new list<GroupMember>();
        map<Id, String> map_accMangerGropNam = new map<Id, String>();
        map<String, String> map_groupName_groupId = new map<String, String>();
        // Added by Lili Zhao 2014-03-10 end due to add the account Manager to GroupMember
        
        Id rt_cis_account = ClsSharingUtil.accountCustomSetting();
        map<Id,Id> map_shId_groupId4child = new map<Id,Id>();
        map<Id,Group> map_shId_group = new map<Id,Group>();
        list<AccountShare> list_accShrs = new list<AccountShare>();
        map<Id,Id> map_accId_groupId = new map<Id,Id>(); 
        for(Id shId: map_shId_groupName.keySet()){
            Group g = new Group(); 
            g.Name = map_shId_groupName.get(shId);
            map_shId_group.put(shId,g); 
        }   
        //system.debug('tongxia map_shId_group:' + map_shId_group);
        if(!map_shId_group.isEmpty()) insert map_shId_group.values();
        //add account sharing to parent account
        for(Id shId:map_shId_group.keyset()){
            if(map_shId_accId.containsKey(shId)){
                AccountShare accShr = new AccountShare();
                accShr.AccountId = map_shId_accId.get(shId);
                accShr.UserOrGroupId = map_shId_group.get(shId).Id;
                accShr.AccountAccessLevel = 'Edit';
                accShr.CaseAccessLevel = 'Edit';
                accShr.OpportunityAccessLevel = 'Edit';
                list_accShrs.add(accShr);
                map_accId_groupId.put(map_shId_accId.get(shId),map_shId_group.get(shId).Id);
            }   
        }
       
        //add account sharing to child accounts
        //system.debug('tongxia map_groupName_shId4child:' + map_groupName_shId4child);
        for(Group g:[select id,name from Group where Name in:map_groupName_shId4child.keyset()]){
            map_shId_groupId4child.put(map_groupName_shId4child.get(g.name),g.Id);
        }
        //system.debug('rt_cis_account::::'+rt_cis_account+':::::map_shId_group::::'+map_shId_group+':::map_shId_groupId4child:::'+map_shId_groupId4child+':::set_childId:::'+set_childId);
        for(Account a: [select id, Sales_Hierarchy_GAM__c,Sales_Hierarchy_MM__c,RecordTypeId from Account 
                        where RecordTypeId =: rt_cis_account 
                        and ((Sales_Hierarchy_GAM__c in:map_shId_group.keyset() or Sales_Hierarchy_MM__c in:map_shId_group.keyset()) 
                        or((Sales_Hierarchy_GAM__c in:map_shId_groupId4child.keyset() or Sales_Hierarchy_MM__c in:map_shId_groupId4child.keyset()) and id in: set_childId))]){
            if(a.Sales_Hierarchy_GAM__c != null){
                Id groupId;
                if(map_shId_group.containsKey(a.Sales_Hierarchy_GAM__c)){
                    groupId = map_shId_group.get(a.Sales_Hierarchy_GAM__c).Id;
                }else if(map_shId_groupId4child.containsKey(a.Sales_Hierarchy_GAM__c)){
                    groupId = map_shId_groupId4child.get(a.Sales_Hierarchy_GAM__c);
                }
                if(groupId != null){
                    AccountShare accShr = new AccountShare();
                    accShr.AccountId = a.Id;
                    accShr.UserOrGroupId = groupId;
                    accShr.AccountAccessLevel = 'Edit';
                    accShr.CaseAccessLevel = 'Edit';
                    accShr.OpportunityAccessLevel = 'Edit';
                    list_accShrs.add(accShr);
                }
            }
            if(a.Sales_Hierarchy_MM__c != null){
                Id groupId;
                if(map_shId_group.containsKey(a.Sales_Hierarchy_MM__c)){
                    groupId = map_shId_group.get(a.Sales_Hierarchy_MM__c).Id;
                }else if(map_shId_groupId4child.containsKey(a.Sales_Hierarchy_MM__c)){
                    groupId = map_shId_groupId4child.get(a.Sales_Hierarchy_MM__c);
                }
                if(groupId != null){
                    AccountShare accShr = new AccountShare();
                    accShr.AccountId = a.Id;
                    accShr.UserOrGroupId = groupId;
                    accShr.AccountAccessLevel = 'Edit';
                    accShr.CaseAccessLevel = 'Edit';
                    accShr.OpportunityAccessLevel = 'Edit';
                    list_accShrs.add(accShr);
                }
            }   
        }
        //system.debug('tongxia list_accShrs:' + list_accShrs);
        if(!list_accShrs.isEmpty()) insert list_accShrs;
        //set public group id on parent account
        // modify by lili zhao 2014.4.08 begin
        //updateAccount(map_accId_groupId);
        
        if(!map_accId_groupId.isEmpty()) {
            list<Account> list_acc = new list<Account>();
            for(Account a: [select id,Public_Group_Id__c from Account where id in:map_accId_groupId.keySet()]){
                a.Public_Group_Id__c = map_accId_groupId.get(a.Id);
                list_acc.add(a);
            }
            if(!list_acc.isEmpty()){
                TriggerRecursionDefense = true;
                update list_acc;
                //TriggerRecursionDefense = false;
            } 
        }
        // modify by lili zhao 2014.4.08 end
        //system.debug('tongxia:insertPublicGroupSharing end');
       
    
    }
    
    public static void insertPublicGroupSharing4Batch(map<Id,String> map_shId_groupName,map<Id,Id> map_shId_accId){
        Id rt_cis_account = ClsSharingUtil.accountCustomSetting();
        map<Id,Id> map_shId_groupId4child = new map<Id,Id>();
        map<Id,Group> map_shId_group = new map<Id,Group>();
        list<AccountShare> list_accShrs = new list<AccountShare>();
        map<Id,Id> map_accId_groupId = new map<Id,Id>(); 
        for(Id shId: map_shId_groupName.keySet()){
            Group g = new Group(); 
            g.Name = map_shId_groupName.get(shId);
            map_shId_group.put(shId,g); 
        }
        if(!map_shId_group.isEmpty()) insert map_shId_group.values();
        //add account sharing to parent account
        for(Id shId:map_shId_group.keyset()){
            if(map_shId_accId.containsKey(shId)){
                AccountShare accShr = new AccountShare();
                accShr.AccountId = map_shId_accId.get(shId);
                accShr.UserOrGroupId = map_shId_group.get(shId).Id;
                accShr.AccountAccessLevel = 'Edit';
                accShr.CaseAccessLevel = 'Edit';
                accShr.OpportunityAccessLevel = 'Edit';
                list_accShrs.add(accShr);
                map_accId_groupId.put(map_shId_accId.get(shId),map_shId_group.get(shId).Id);
            }   
        }
        for(Account a: [select id, Sales_Hierarchy_GAM__c,Sales_Hierarchy_MM__c,RecordTypeId from Account 
                        where RecordTypeId =: rt_cis_account 
                        and (Sales_Hierarchy_GAM__c in:map_shId_group.keyset() or Sales_Hierarchy_MM__c in:map_shId_group.keyset())]){
            if(a.Sales_Hierarchy_GAM__c != null){
                Id groupId;
                if(map_shId_group.containsKey(a.Sales_Hierarchy_GAM__c)){
                    groupId = map_shId_group.get(a.Sales_Hierarchy_GAM__c).Id;
                }else if(map_shId_groupId4child.containsKey(a.Sales_Hierarchy_GAM__c)){
                    groupId = map_shId_groupId4child.get(a.Sales_Hierarchy_GAM__c);
                }
                if(groupId != null){
                    AccountShare accShr = new AccountShare();
                    accShr.AccountId = a.Id;
                    accShr.UserOrGroupId = groupId;
                    accShr.AccountAccessLevel = 'Edit';
                    accShr.CaseAccessLevel = 'Edit';
                    accShr.OpportunityAccessLevel = 'Edit';
                    list_accShrs.add(accShr);
                }
            }
            if(a.Sales_Hierarchy_MM__c != null){
                Id groupId;
                if(map_shId_group.containsKey(a.Sales_Hierarchy_MM__c)){
                    groupId = map_shId_group.get(a.Sales_Hierarchy_MM__c).Id;
                }else if(map_shId_groupId4child.containsKey(a.Sales_Hierarchy_MM__c)){
                    groupId = map_shId_groupId4child.get(a.Sales_Hierarchy_MM__c);
                }
                if(groupId != null){
                    AccountShare accShr = new AccountShare();
                    accShr.AccountId = a.Id;
                    accShr.UserOrGroupId = groupId;
                    accShr.AccountAccessLevel = 'Edit';
                    accShr.CaseAccessLevel = 'Edit';
                    accShr.OpportunityAccessLevel = 'Edit';
                    list_accShrs.add(accShr);
                }
            }   
        }
        if(!list_accShrs.isEmpty()) insert list_accShrs;
    }

        /**
     * This method is used to add customer focus team member into public group
     *
     @author Xia Tong
     @created 2013-03-26
     @version 1.0
     @since 23.0
     *
     @param map_uid_groupName      key: customer focus team member's user id; value: public group name 
     *
     @return void           
     *
     @changelog
     * 2013-03-26 Xia Tong <xia.tong@itbconsult.com>
     * - Created
     */ 
    @future
    public static void addCustomerFocusTeamAsGroupMember(map<Id,String> map_uid_groupName){
        //system.debug('tongxia:addCustomerFocusTeamAsGroupMember start');
        //system.debug('tongxia map_uid_groupName:' + map_uid_groupName);
        // add customer focus team to public group.
        list<GroupMember> list_groupMembers = new list<GroupMember>();
        map<String,Id> map_groupName_groupId = new map<String,Id>();
        for(Group g:[select id,Name from Group where name in:map_uid_groupName.values()]){
            map_groupName_groupId.put(g.name,g.Id); 
        }
       
        
        for(Id uid: map_uid_groupName.keySet()){
            if(map_uid_groupName.get(uid) != null && map_groupName_groupId.containsKey(map_uid_groupName.get(uid))){
                GroupMember grpMeb = new GroupMember();
                grpMeb.GroupId = map_groupName_groupId.get(map_uid_groupName.get(uid));
                grpMeb.UserOrGroupId = uid;
                list_groupMembers.add(grpMeb);  
            }       
        }
        //system.debug('tongxia list_groupMembers:' + list_groupMembers);
        
        if(!list_groupMembers.isEmpty()) insert list_groupMembers;
        
        //system.debug('tongxia:addCustomerFocusTeamAsGroupMember end');  
    } 
    
    /**
     * This method is used to add customer focus team member into public group
     *
     @author Xia Tong
     @created 2013-03-26
     @version 1.0
     @since 23.0
     *
     @param map_uid_groupName      key: customer focus team member's user id; value: public group name 
     *
     @return void           
     *
     @changelog
     * 2013-03-26 Xia Tong <xia.tong@itbconsult.com>
     * - Created
     */ 
    @future
    public static void addAccMangermAsGroupMember(map<Id,String> map_uid_groupName, map<Id,String> map_oldAccManager_GropName){
        //system.debug('tongxia:addCustomerFocusTeamAsGroupMember start');
        //system.debug('tongxia map_uid_groupName:' + map_uid_groupName);
        // add customer focus team to public group.
        list<GroupMember> list_groupMembers = new list<GroupMember>();
        list<GroupMember> list_delGroupMembers = new list<GroupMember>();
        map<String,Id> map_groupName_groupId = new map<String,Id>();
        map<Id, GroupMember> map_groupId_GroupMember = new map<Id, GroupMember>();
        for(Group g:[select id,Name from Group where name in:map_uid_groupName.values()]){
            map_groupName_groupId.put(g.name,g.Id); 
        }
        // Added by Lili Zhao 2014-03-12 begin due to add the account Manager to GroupMember
        for(GroupMember grpMeb :[Select GroupId, UserOrGroupId from GroupMember where GroupId in:map_groupName_groupId.values()]) {
            map_groupId_GroupMember .put(grpMeb.GroupId, grpMeb);
        }
        for(Id oldId : map_oldAccManager_GropName.keySet()) {
            if(map_oldAccManager_GropName.get(oldId) != null && map_groupName_groupId.containsKey(map_oldAccManager_GropName.get(oldId))){
                if(map_groupId_GroupMember.containsKey(map_groupName_groupId.get(map_oldAccManager_GropName.get(oldId)))) {
                    GroupMember grpMeb = map_groupId_GroupMember.get(map_groupName_groupId.get(map_oldAccManager_GropName.get(oldId)));
                    list_delGroupMembers.add(grpMeb);
                }
            }
            
        }
        
        for(Id uid: map_uid_groupName.keySet()){
            if(map_uid_groupName.get(uid) != null && map_groupName_groupId.containsKey(map_uid_groupName.get(uid))){
                GroupMember grpMeb = new GroupMember();
                grpMeb.GroupId = map_groupName_groupId.get(map_uid_groupName.get(uid));
                grpMeb.UserOrGroupId = uid;
                list_groupMembers.add(grpMeb);  
            }       
        }
        //system.debug('tongxia list_groupMembers:' + list_groupMembers);
        // Added by Lili Zhao 2014-03-12 begin due to add the account Manager to GroupMember
       
        if(!list_delGroupMembers.isEmpty()) delete list_delGroupMembers;
        if(!list_groupMembers.isEmpty()) insert list_groupMembers;
        // Added by Lili Zhao 2014-03-12 begin due to add the account Manager to GroupMember  
        //system.debug('tongxia:addCustomerFocusTeamAsGroupMember end');  
    } 
    

        /**
     * This method is used to delete account sharing on public group
     *
     @author Xia Tong
     @created 2013-03-26
     @version 1.0
     @since 23.0
     *
     @param map_groupName_setAccId                  key: public group name; value: set of account id 
     @param set_childId2DeleteAccountSharing        child account id to delete account sharing 
     *
     @return void           
     *
     @changelog
     * 2013-03-26 Xia Tong <xia.tong@itbconsult.com>
     * - Created
     */ 
    public static void deleteAccountSharingOnPublicGroup(map<string,set<Id>> map_groupName_setAccId,set<Id> set_childId2DeleteAccountSharing){
        //system.debug('tongxia:deleteAccountSharingOnPublicGroup start');
        //system.debug('tongxia map_groupName_setAccId:' + map_groupName_setAccId);
        //system.debug('tongxia set_childId2DeleteAccountSharing:' + set_childId2DeleteAccountSharing);
        map<id,string> map_groupId_name = new map<Id,string>();
        list<AccountShare> list_accshare = new list<AccountShare>();
        for(Group g:[select id,name from Group where name in:map_groupName_setAccId.keyset()]){
            map_groupId_name.put(g.Id,g.Name);
        }
        
        for(AccountShare accShare: [select Id, AccountId, UserOrGroupId from AccountShare where AccountId in:set_childId2DeleteAccountSharing and UserOrGroupId in: map_groupId_name.keySet()]){
            if(map_groupName_setAccId.containsKey(map_groupId_name.get(accShare.UserOrGroupId)) && map_groupName_setAccId.get(map_groupId_name.get(accShare.UserOrGroupId)).contains(accShare.AccountId)){
                list_accshare.add(accShare);
            }
        }
        //system.debug('tongxia list_accshare:' + list_accshare);
        if(!list_accshare.isEmpty()) delete list_accshare;
        //system.debug('tongxia:deleteAccountSharingOnPublicGroup end');  
    } 
            /**
     * This method is used to set public group id on parent account
     *
     @author Xia Tong
     @created 2013-03-26
     @version 1.0
     @since 23.0
     *
     @param map_accId_groupId               key: account id; value: public group id 
     *
     @return void           
     *
     @changelog
     * 2013-03-26 Xia Tong <xia.tong@itbconsult.com>
     * - Created
     */ 
    @future
    public static void updateAccount(map<Id,Id> map_accId_groupId){
        //set parent account public group id
        list<Account> list_acc = new list<Account>();
        for(Account a: [select id,Public_Group_Id__c from Account where id in:map_accId_groupId.keySet()]){
            a.Public_Group_Id__c = map_accId_groupId.get(a.Id);
            list_acc.add(a);
        }
        if(!list_acc.isEmpty()){
            TriggerRecursionDefense = true;
            update list_acc;
            //TriggerRecursionDefense = false;
        }   
    }
}