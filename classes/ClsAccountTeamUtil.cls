/**
 *  Contains a set of static methods used for object Account_Team__c.
 *
 @author Bin Yuan
 @created 2012-11-15
 @version 1.0
 @since 25.0 (Force.com ApiVersion)
 *
 @changelog
 * 2012-11-15 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created

//Code Added to check multiple TE Network IDs Case No:00758872 - 17/3/2015 Pankaj Raijade <pankaj.raijade@zensar.in>
 Line 312 and line 379
 


 */

global class ClsAccountTeamUtil {
   
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private static String customOppyAccessRead = 'Read-Only';
    private static String acctShrOppyAccessRead = 'Read';
    private static String customOppyAccessEdit = 'Edit';
    private static String acctShrOppyAccessEdit = 'Edit';
    private static String customOppyAccessNoAccess = 'No Access';
    private static String acctShrOppyAccessNoAccess = 'None';
    private static String acctShrRowCase = 'Team';
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////

    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
   /**
    * This method is used to delete old standard account team members.
    *
    @author Bin Yuan
    @created 2012-11-15
    @version 1.0
    @since 25.0 (Force.com ApiVersion)
    *
    @param set<Id>      set_accountIds
    *
    @return             void
    *
    @changelog
    * 2012-11-15 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void deleteOldStdAccountTeam(set<Id> set_accountIds) {
        
        list<AccountTeamMember> list_oldStdAcctTeam2Delete = new list<AccountTeamMember>();
        for(AccountTeamMember stdAcctTeam : [SELECT AccountId, Id FROM AccountTeamMember WHERE AccountId IN : set_accountIds]) {
            list_oldStdAcctTeam2Delete.add(stdAcctTeam);
        }
        
        if(!list_oldStdAcctTeam2Delete.isEmpty()) delete list_oldStdAcctTeam2Delete;
    }
    
   /**
    * This method is used to generate standard account team member by using information from custom account team member.
    *
    @author Bin Yuan
    @created 2012-11-15
    @version 1.0
    @since 25.0 (Force.com ApiVersion)
    *
    @param set<Id>      set_accountIds
    *
    @return             void
    *
    @changelog
    * 2012-11-15 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void generateStdAcctTeamFromCustomAcctTeam(list<Account_Team__c> list_accTeams) {
        
        list<AccountTeamMember> list_stdAcctTeam2Insert = new list<AccountTeamMember>();
        map<Id, String> map_acctId_oppyAccess = new map<Id, String>();
        set<Id> set_userIds = new set<Id>();
        map<Id, map<Id, String>> map_acctId_userId_oppyAccess = new map<Id, map<Id, String>>();

        for(Account_Team__c customAcctTeam : list_accTeams) {
            set_userIds.add(customAcctTeam.Team_Member__c);
            if(!map_acctId_userId_oppyAccess.containsKey(customAcctTeam.Account__c)) {
                map_acctId_userId_oppyAccess.put(customAcctTeam.Account__c, new map<Id, String>());
            }
            map_acctId_userId_oppyAccess.get(customAcctTeam.Account__c).put(customAcctTeam.Team_Member__c, customAcctTeam.Opportunity_Access__c);
            AccountTeamMember newStdAcctTeam = copyCustomAcctTeam(customAcctTeam);
            list_stdAcctTeam2Insert.add(newStdAcctTeam);
        }
        if(!list_stdAcctTeam2Insert.isEmpty()) insert list_stdAcctTeam2Insert;
        if(!map_acctId_userId_oppyAccess.isEmpty()) updateAcctSharing(set_userIds, map_acctId_userId_oppyAccess);
        
    }
    
   /**
    * This method is used to copy fields from custom account team members.
    *
    @author Bin Yuan
    @created 2012-11-15
    @version 1.0
    @since 25.0 (Force.com ApiVersion)
    *
    @param Account_Team__c      customAcctTeam
    *
    @return     AccountTeamMember
    *
    @changelog
    * 2012-11-15 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static AccountTeamMember copyCustomAcctTeam(Account_Team__c customAcctTeam) {
        
        AccountTeamMember newStdAcctTeam = new AccountTeamMember();     
        newStdAcctTeam.AccountId = customAcctTeam.Account__c;
        newStdAcctTeam.TeamMemberRole = customAcctTeam.Role__c;
        newStdAcctTeam.UserId = customAcctTeam.Team_Member__c;      
        return newStdAcctTeam;
    }
    
   /**
    * This method is used to update account sharing OpportunityAccessLevel field according to custom account team Opportunity_Access__c field.
    *
    @author Bin Yuan
    @created 2012-11-15
    @version 1.0
    @since 25.0 (Force.com ApiVersion)
    *
    @param set<Id>      set_accountIds
    *
    @return             void
    *
    @changelog
    * 2012-11-15 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void updateAcctSharing(set<Id> set_userIds, map<Id, map<Id, String>> map_acctId_userId_oppyAccess) {
        
        list<AccountShare> list_acctShr2Insert = new list<AccountShare>();
        for(AccountShare acctShr : [SELECT AccountAccessLevel, AccountId, Id, OpportunityAccessLevel, RowCause, UserOrGroupId 
                                    FROM   AccountShare
                                    WHERE  AccountId IN : map_acctId_userId_oppyAccess.keySet()
                                    AND    UserOrGroupId IN : set_userIds
                                    AND    RowCause = : acctShrRowCase]) {

            for(Id acctId : map_acctId_userId_oppyAccess.keySet()) {        
                if(acctShr.AccountId == acctId && map_acctId_userId_oppyAccess.get(acctId).containsKey(acctShr.UserOrGroupId)){ 
                    acctShr.AccountAccessLevel = 'Edit';
                    acctShr.CaseAccessLevel = 'Edit';
                    if(map_acctId_userId_oppyAccess.get(acctId).get(acctShr.UserOrGroupId) == customOppyAccessRead) acctShr.OpportunityAccessLevel = acctShrOppyAccessRead;
                    if(map_acctId_userId_oppyAccess.get(acctId).get(acctShr.UserOrGroupId) == customOppyAccessEdit) acctShr.OpportunityAccessLevel = acctShrOppyAccessEdit;
                    if(map_acctId_userId_oppyAccess.get(acctId).get(acctShr.UserOrGroupId) == customOppyAccessNoAccess) acctShr.OpportunityAccessLevel = acctShrOppyAccessNoAccess;
                    
                    list_acctShr2Insert.add(acctShr);
                }
            }                                   
        }
        
        if(!list_acctShr2Insert.isEmpty()) update list_acctShr2Insert;
    }
   /**
    * This method is used to update account sharing OpportunityAccessLevel field according to custom account team Opportunity_Access__c field.
    *
    @author Bin Yuan
    @created 2012-11-15
    @version 1.0
    @since 25.0 (Force.com ApiVersion)
    *
    @param set<Id>      set_accountIds
    *
    @return             void
    *
    @changelog
    * 2012-11-15 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static map<Id, String> getAccountTeamMember(map<String, list<Account>> map_hierarchyId_listAccts, boolean isAcctManager) {
        
        map<Id, String> map_acctId_acctTeamMemberUserId = new map<Id, String>();
        map<Id, set<String>> map_hierarchyId_set_userId = new map<Id, set<String>>();
        // set<Id> set_userIds = new set<Id>();     //Commented by Subramanian for AT & Sensors Project
        Id castIronSeviceId = (Id) Apex_Helper_Settings__c.getInstance('TEIS Admin User Id').Value__c;
        list<Account> list_acct2Update = new list<Account>();

        if(!map_hierarchyId_listAccts.isEmpty()){
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
                                         WHERE Id IN :map_hierarchyId_listAccts.keySet()]){

                if(sh.Level_7_Default_Owner__c != null){
                    for(Account acct : map_hierarchyId_listAccts.get(sh.Id)){
                        if(acct.Account_Manager__c != sh.Level_7_Default_Owner__c){
                            acct.Account_Manager__c = sh.Level_7_Default_Owner__c;
                            list_acct2Update.add(acct);
                        }
                        map_acctId_acctTeamMemberUserId.put(acct.Id, sh.Level_7_Default_Owner__c);
                    }
                }
                /* Commented by Subramanian for AT & Sensors Project (this code will not exe)
                else if(sh.Level_7_Assigned_Users__c != null){
                    set<String> set_tempUserIds = new set<String>();
                    
                    if(sh.Level_7_Assigned_Users__c.contains(';')){
                        for(String userId : sh.Level_7_Assigned_Users__c.split(';')){
                            if(userId != null) {
                                set_userIds.add(userId);
                                set_tempUserIds.add(userId);
                            }
                        }
                    }
                    else{
                        set_userIds.add(sh.Level_7_Assigned_Users__c);
                        set_tempUserIds.add(sh.Level_7_Assigned_Users__c);
                    }                        
                    map_hierarchyId_set_userId.put(sh.Id, set_tempUserIds);
                } */ // END
                
            }
            /* Commented by Subramanian for AT & Sensors Project (this code will not exe)
            if(!set_userIds.isEmpty()){
                for(User u : [SELECT Id, Te_Network_Id__c, IsActive 
                              FROM User 
                              WHERE Id IN :set_userIds
                              AND IsActive = true]) {
                                
                    for(Id hierarchyId : map_hierarchyId_set_userId.keySet()) {
                        if(map_hierarchyId_set_userId.get(hierarchyId).contains(u.Id)) {
                            for(Account acct : map_hierarchyId_listAccts.get(hierarchyId)) {
                                if(acct.Account_Manager__c != u.Id) {
                                    acct.Account_Manager__c = u.Id;
                                    list_acct2Update.add(acct);
                                    map_acctId_acctTeamMemberUserId.put(acct.Id, u.Id);
                                }
                            }
                        
                        }
                        else {
                            for(Account acct : map_hierarchyId_listAccts.get(hierarchyId)) {
                                if(acct.Account_Manager__c != castIronSeviceId){
                                    acct.Account_Manager__c = castIronSeviceId;
                                    list_acct2Update.add(acct);
                                }
                            }
                        }
                    
                    }           
                }
                
            } */ // END
        }
        if(isAcctManager && !list_acct2Update.isEmpty()){
            update list_acct2Update;
        }
        return map_acctId_acctTeamMemberUserId;
    }
    
    public static map<String, Sales_Hierarchy__c> refreshAccountTeamMemberByHierarchyId(Id ACCOUNT_ID, Id SALESHIERICHY_ID , String LEVEL7_USER, String LEVEL7_NETWORKID){ 
        
        map<String, Sales_Hierarchy__c> map_accId_userId = new map<String, Sales_Hierarchy__c>(); 
        
        Sales_Hierarchy__c oSH = new Sales_Hierarchy__c(Id = SALESHIERICHY_ID, Level_7_Assigned_Users__c = LEVEL7_USER, Level_7_Assigned_User_Network_Ids__c = LEVEL7_NETWORKID); 
        
        map_accId_userId.put(ACCOUNT_ID, oSH);         
    
        return map_accId_userId; 
    } 
    
    /* Commented by Subramanian Jairam At & Sensor
    public static map<String, Sales_Hierarchy__c> refreshAccountTeamMemberByHierarchyId(map<String, list<Account>> map_hierarchyId_listAccts, map<String, Sales_Hierarchy__c> map_hierarchyId_userId,map<Id,string> map_uId_networkId) {
        
        map<String, Sales_Hierarchy__c> map_acctId_acctTeamMemberUserId = new map<String, Sales_Hierarchy__c>();
    
        if(!map_hierarchyId_listAccts.isEmpty()){
            //************************************************************************************
            // START: get the unassigned user with map
            //************************************************************************************
            set<String> set_shId = new set<String>();
            for(String shId :map_hierarchyId_listAccts.keySet()){
                if(!map_hierarchyId_userId.containsKey(shId)){
                    set_shId.add(shId);
                }
            }
            
            //************************************************************************************
            // END: get the unassigned user with map
            //************************************************************************************      
            
            //************************************************************************************
            // START: search the assigned user
            //************************************************************************************  
            if(!set_shId.isEmpty()){                                    
                for(Sales_Hierarchy__c sh : [SELECT Hierarchy_Type__c, 
                                                    Level_7_Assigned_Users__c, 
                                                    Level_7_Assigned_User_Network_Ids__c,
                                                    Id
                                             FROM Sales_Hierarchy__c
                                             WHERE Id IN :set_shId]){   
                    // get the assigned users 
                    if(sh.Level_7_Assigned_Users__c != null && sh.Level_7_Assigned_Users__c.length() >= 15){
                        try{
                            //Code modified to check multiple TE Network IDs Case No:00758872 - 17/3/2015 Pankaj Raijade <pankaj.raijade@zensar.in>
                            map_hierarchyId_userId.put(sh.Id, sh);
                            if(sh.Level_7_Assigned_User_Network_Ids__c != null){
                                //Code modified to check multiple TE Network IDs Case No:00758872 - 17/3/2015 Pankaj Raijade <pankaj.raijade@zensar.in>
                                if(sh.Level_7_Assigned_Users__c != null && sh.Level_7_Assigned_Users__c != '')
                                    map_uId_networkId.put(sh.Level_7_Assigned_Users__c.subString(0,15),sh.Level_7_Assigned_User_Network_Ids__c);
                            }
                        }
                        catch(Exception ex){
                            system.debug('Exception: ' + ex);
                        }
                    }
                }                   
            }
            //************************************************************************************
            // END: search the assigned user 
            //************************************************************************************              
    
            //************************************************************************************
            // START: get the assigned user from map for all roles
            //************************************************************************************              
            
            for(String shId :map_hierarchyId_listAccts.keySet()){
                if(map_hierarchyId_userId.containsKey(shId)){
                    Sales_Hierarchy__c oSH = map_hierarchyId_userId.get(shId);
                    for(Account acc :map_hierarchyId_listAccts.get(shId)){
                        map_acctId_acctTeamMemberUserId.put(acc.Id, oSH);
                    }
                }
            }
            //************************************************************************************
            // END: get the assigned user from map for all roles
            //************************************************************************************                  
        }
        
        return map_acctId_acctTeamMemberUserId;
    }       
    */
    public static map<String, Sales_Hierarchy__c> refreshAccountTeamMemberByHierarchyCode(map<String, list<Account>> map_hierarchyCode_listAccts, map<String, Sales_Hierarchy__c> map_hierarchyCode_userId, String hierarchyType,map<Id,String> map_uId_networkId) {
        map<String, Sales_Hierarchy__c> map_acctId_acctTeamMemberUserId = new map<String, Sales_Hierarchy__c>();
        
        if(!map_hierarchyCode_listAccts.isEmpty()){
            //************************************************************************************
            // START: get the unassigned user with map
            //************************************************************************************
            set<String> set_shCode = new set<String>();
            for(String shCode :map_hierarchyCode_listAccts.keySet()){
                if(!map_hierarchyCode_userId.containsKey(shCode)){
                    set_shCode.add(shCode);
                }
            }
            //************************************************************************************
            // END: get the unassigned user with map
            //************************************************************************************      
            
            //************************************************************************************
            // START: search the assigned user
            //************************************************************************************  
            if(!set_shCode.isEmpty()){                                  
                for(Sales_Hierarchy__c sh : [SELECT Level_7_Territory_Code__c, 
                                                    Level_7_Assigned_Users__c, Hierarchy_Type__c,
                                                    Level_7_Assigned_User_Network_Ids__c,
                                                    Id
                                             FROM Sales_Hierarchy__c
                                             WHERE Level_7_Territory_Code__c IN :set_shCode and Hierarchy_Type__c = :hierarchyType]){   
                    // get the assigned users 
                    if(sh.Level_7_Assigned_Users__c != null && sh.Level_7_Assigned_Users__c.length() >= 15){
                        try{
                            //Code modified to check multiple TE Network IDs Case No:00758872 - 17/3/2015 Pankaj Raijade <pankaj.raijade@zensar.in>
                            map_hierarchyCode_userId.put(sh.Level_7_Territory_Code__c + hierarchyType, sh);
                            if(sh.Level_7_Assigned_User_Network_Ids__c != null){
                                //Code modified to check multiple TE Network IDs Case No:00758872 - 17/3/2015 Pankaj Raijade <pankaj.raijade@zensar.in>
                                if(sh.Level_7_Assigned_Users__c != null && sh.Level_7_Assigned_Users__c != '')
                                    map_uId_networkId.put(sh.Level_7_Assigned_Users__c.subString(0,15),sh.Level_7_Assigned_User_Network_Ids__c);
                            }
                        }
                        catch(Exception ex){
                            system.debug('Exception: ' + ex);
                        }
                    }
                                        
                }                   
            }
            //************************************************************************************
            // END: search the assigned user 
            //************************************************************************************              
    
            //************************************************************************************
            // START: get the assigned user from map for all roles
            //************************************************************************************              
            for(String shCode :map_hierarchyCode_listAccts.keySet()){
                if(map_hierarchyCode_userId.containsKey(shCode + hierarchyType)){
                    Sales_Hierarchy__c oSH = map_hierarchyCode_userId.get(shCode + hierarchyType);
                    for(Account acc :map_hierarchyCode_listAccts.get(shCode)){
                        map_acctId_acctTeamMemberUserId.put(acc.Id, oSH);
                    }
                }
            }
            //************************************************************************************
            // END: get the assigned user from map for all roles
            //************************************************************************************                  
        }
        return map_acctId_acctTeamMemberUserId;
    }                   
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
}