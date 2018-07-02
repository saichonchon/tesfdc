/**
 *  Batch class to valid account team member.
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
 //Code Added to check multiple TE Network IDs Case No:00758872 - 19/2/2015 Pankaj Raijade <pankaj.raijade@zensar.in>
 Line 277 - 279
 //Code Modified to check multiple TE Network IDs Case No:00758872 - 19/2/2015
 Line 287 - 336
 *
 */     
          
global class ClsBatch_cleanupAccountTeam implements Database.Batchable<SObject>,Database.Stateful{
     
    public String query;
    global map<String,String> map_netWorkId_userId = new map<String,String>();
    global map<String,Sales_Hierarchy__c> map_hierarchyId_userId = new map<String,Sales_Hierarchy__c>();
    global map<String,Sales_Hierarchy__c> map_hierarchyCode_userId = new map<String,Sales_Hierarchy__c>();
    global map<Id,String> map_uId_networkId = new map<Id,String>();
        
    global String str_amRole = 'Account Manager (AM)';
    global String str_isRole = 'Relay Specialist (IS)';
    global String str_feRole = 'Field Engineer (FE)';
    global String str_gamRole = 'Global Account Manager (GAM)';
    global String str_indRole = 'Account Manager (KAM)';
    global String str_mmRole = 'Tubing FE (MM)';
    global String str_fseRole = 'Field Service Engineer (FSE)';
    //Started - Added by Subramanian for AT & Sensors
    global String str_AT1Role = 'Alternative Territory 1 (AT1)'; 
    global String str_AT2Role = 'Alternative Territory 2 (AT2)'; 
    global String str_ATSRole = 'Alternative Territory Inside Sales (ATS)'; 
    global String str_RSRRole = 'Regional Sales Rep (RSR)'; 
    global String str_RSMRole = 'Regional Sales Manager (RSM)';
    //End
    global String str_amType = 'Sales Hierarchy (AM)';
    global String str_isType = 'Relay Specialist Hierarchy (IS)';
    global String str_feType = 'Account Manager Hierarchy (FE)';
    global String str_gamType = 'Global Account Manager Hierarchy (GAM)';
    global String str_indType = 'IND KAM Hierarchy';    
    global String str_mmType = 'Market Manager Hierarchy (MM)';
    global String str_fseType = 'Field Service Engineer Hierarchy (FSE)';
    
    global Id sFDCRt = [SELECT Id FROM RecordType WHERE DeveloperName = 'SFDC_User' Limit 1].Id; 
    
    // Modified by Anil <anil.attelli@zensar.in> inorder to restrict the start method query with "Account" record type. 
    
    Apex_Helper_Settings__c accountRT = Apex_Helper_Settings__c.getInstance('Account Record Type Id'); 
    global String recordtypeId = accountRT.value__c;    
    
    //included where clause by Anil <anil.attelli@zensar.in>.
    global Database.QueryLocator start(Database.BatchableContext BC){    
        if (query == null || query == ''){
            /* Commented by Subramanian for AT & Sensors
            query =   'SELECT Id,' 
                    + '       FE_Hierarchy__c,FE_Hierarchy__r.Level_7_Assigned_Users__c,' 
                    + '       Relay_Hierarchy__c, Relay_Hierarchy__r.Level_7_Assigned_Users__c,' 
                    + '       Sales_Hierarchy__c, Sales_Hierarchy__r.Level_7_Assigned_Users__c,'
                    + '       GAMCD__c,' 
                    + '       MKTMGRCDE__c,TE_Customer_Key_Id__c,' 
                    + '       IND_KAM_Code__c,'
                    + '       Account_Manager__c,'
                    + '       Field_Service_Engineer_Code__c '                     
                    + 'FROM   Account where RecordTypeId = \''+ recordtypeId +'\'';// where Id = \'001E000000Ba9H8\'';
             */
             query = 'SELECT Id,' 
                    + ' FE_Hierarchy__c,FE_Hierarchy__r.Level_7_Assigned_Users__c,FE_Hierarchy__r.Level_7_Assigned_User_Network_Ids__c,' 
                    + ' Relay_Hierarchy__c, Relay_Hierarchy__r.Level_7_Assigned_Users__c,Relay_Hierarchy__r.Level_7_Assigned_User_Network_Ids__c,' 
                    + ' Sales_Hierarchy__c, Sales_Hierarchy__r.Level_7_Assigned_Users__c,Sales_Hierarchy__r.Level_7_Assigned_User_Network_Ids__c,' 
                    + ' AT1_Territory_Name__c,AT1_Territory_Name__r.Level_7_Assigned_Users__c,AT1_Territory_Name__r.Level_7_Assigned_User_Network_Ids__c,' 
                    + ' AT2_Territory_Name__c, AT2_Territory_Name__r.Level_7_Assigned_Users__c,AT2_Territory_Name__r.Level_7_Assigned_User_Network_Ids__c,' 
                    + ' RSR_Territory_Name__c, RSR_Territory_Name__r.Level_7_Assigned_Users__c,RSR_Territory_Name__r.Level_7_Assigned_User_Network_Ids__c,' 
                    + ' ATS_Territory_Name__c,ATS_Territory_Name__r.Level_7_Assigned_Users__c,ATS_Territory_Name__r.Level_7_Assigned_User_Network_Ids__c,' 
                    + ' RSM_Territory_Name__c, RSM_Territory_Name__r.Level_7_Assigned_Users__c,RSM_Territory_Name__r.Level_7_Assigned_User_Network_Ids__c,' 
                    + ' GAMCD__c,' 
                    + ' MKTMGRCDE__c,TE_Customer_Key_Id__c,' 
                    + ' IND_KAM_Code__c,' 
                    + ' Account_Manager__c,' 
                    + ' Field_Service_Engineer_Code__c ' 
                    + 'FROM Account where RecordTypeId = \''+ recordtypeId +'\'';// where Id = \'001E000000Ba9H8\''; 
                    
        }
        return Database.getQueryLocator(query); 
    }          

    global void execute(Database.BatchableContext BC, list<Account> scope){

        list<Account_Team__c> list_atm2Insert = new list<Account_Team__c>();
        list<Account_Team__c> list_atm2Del = new list<Account_Team__c>();
        system.debug('###scope' + scope);        
        map<String, list<Account>> map_amHierarchyId_listAccts = new map<String, list<Account>>();
        /* Commented by Subramanian for AT & Sensors
        map<String, list<Account>> map_feHierarchyId_listAccts = new map<String, list<Account>>();
        map<String, list<Account>> map_isHierarchyId_listAccts = new map<String, list<Account>>();
        */
        map<String, list<Account>> map_gamHierarchyCode_listAccts = new map<String, list<Account>>();
        map<String, list<Account>> map_mmHierarchyCode_listAccts = new map<String, list<Account>>();
        map<String, list<Account>> map_fseHierarchyCode_listAccts = new map<String, list<Account>>();
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
        map<String, list<Account>> map_mmNewHierarchyCode_listAccts = new map<String, list<Account>>();
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
        
        map<Id,Integer> map_accId_customeKey = new map<Id,Integer>();
        
        set<Id> set_allAccId = new set<Id>();
        map<String,map<String, Sales_Hierarchy__c>> map_role_map_accId_userId = new map<String,map<String, Sales_Hierarchy__c>>(); 
        Set<String> rolesToDelete = new Set<String>{str_amRole, str_isRole, str_feRole, str_AT1Role, str_AT2Role, str_ATSRole, str_RSRRole, str_RSMRole, str_gamRole, str_mmRole, str_fseRole};
        
        //************************************************************************************************
        // START: build map for sales hierarchy of all roles
        //************************************************************************************************
        for(Account acc : scope){           
            set_allAccId.add(acc.Id);
            if(acc.TE_Customer_Key_Id__c != null){
                map_accId_customeKey.put(acc.id,(Integer)acc.TE_Customer_Key_Id__c);
            }

            // Account Manager
            //if(acc.Sales_Hierarchy__c != null){ Commented by Subramanian for AT & Sensors
            if(acc.Sales_Hierarchy__c != null && acc.Sales_Hierarchy__r.Level_7_Assigned_Users__c != '' && acc.Sales_Hierarchy__r.Level_7_Assigned_User_Network_Ids__c != ''){ 
                if(!map_amHierarchyId_listAccts.containsKey(acc.Sales_Hierarchy__c)){
                    map_amHierarchyId_listAccts.put(acc.Sales_Hierarchy__c, new list<Account>());
                }
                map_amHierarchyId_listAccts.get(acc.Sales_Hierarchy__c).add(acc);
                //Added by Subramanian for AT & Sensors
                if(!map_role_map_accId_userId.ContainsKey(str_amRole)){
                    map_role_map_accId_userId.put(str_amRole, new map<String, Sales_Hierarchy__c>());
                }
                map_role_map_accId_userId.get(str_amRole).PutAll(ClsAccountTeamUtil.refreshAccountTeamMemberByHierarchyId(acc.Id, acc.Sales_Hierarchy__c, acc.Sales_Hierarchy__r.Level_7_Assigned_Users__c, acc.Sales_Hierarchy__r.Level_7_Assigned_User_Network_Ids__c)); 
            }
            system.debug('acc.Relay_Hierarchy__c###' + acc.Relay_Hierarchy__c);
            // Relay Specialist
            //if(acc.Relay_Hierarchy__c != null) { Commented by Subramanian for AT & Sensors
            if(acc.Relay_Hierarchy__c != null && acc.Relay_Hierarchy__r.Level_7_Assigned_Users__c != '' && acc.Relay_Hierarchy__r.Level_7_Assigned_User_Network_Ids__c != ''){ 
                /* Commented by Subramanian for AT & Sensors
                if(!map_isHierarchyId_listAccts.containsKey(acc.Relay_Hierarchy__c)) {
                    map_isHierarchyId_listAccts.put(acc.Relay_Hierarchy__c, new list<Account>());
                }
                map_isHierarchyId_listAccts.get(acc.Relay_Hierarchy__c).add(acc);
                */
                //Added by Subramanian for AT & Sensors
                if(!map_role_map_accId_userId.ContainsKey(str_isRole)){
                    map_role_map_accId_userId.put(str_isRole, new map<String, Sales_Hierarchy__c>());
                }
                map_role_map_accId_userId.get(str_isRole).PutAll(ClsAccountTeamUtil.refreshAccountTeamMemberByHierarchyId(acc.Id, acc.Relay_Hierarchy__c, acc.Relay_Hierarchy__r.Level_7_Assigned_Users__c, acc.Relay_Hierarchy__r.Level_7_Assigned_User_Network_Ids__c)); 
            }

            // Field Engineer
            //if(acc.FE_Hierarchy__c != null) { Commented by Subramanian for AT & Sensors
            if(acc.FE_Hierarchy__c != null && acc.FE_Hierarchy__r.Level_7_Assigned_Users__c != '' && acc.FE_Hierarchy__r.Level_7_Assigned_User_Network_Ids__c != ''){ 
                /* Commented by Subramanian for AT & Sensors
                if(!map_feHierarchyId_listAccts.containsKey(acc.FE_Hierarchy__c)) {
                    map_feHierarchyId_listAccts.put(acc.FE_Hierarchy__c, new list<Account>());
                }
                map_feHierarchyId_listAccts.get(acc.FE_Hierarchy__c).add(acc);
                */
                //Added by Subramanian for AT & Sensors
                if(!map_role_map_accId_userId.ContainsKey(str_feRole)){
                    map_role_map_accId_userId.put(str_feRole, new map<String, Sales_Hierarchy__c>());
                }
                map_role_map_accId_userId.get(str_feRole).PutAll(ClsAccountTeamUtil.refreshAccountTeamMemberByHierarchyId(acc.Id, acc.FE_Hierarchy__c, acc.FE_Hierarchy__r.Level_7_Assigned_Users__c, acc.FE_Hierarchy__r.Level_7_Assigned_User_Network_Ids__c)); 
                
            }
            
            //Start - Added by Subramanian for AT & Sensors
            if(acc.AT1_Territory_Name__c != null && acc.AT1_Territory_Name__r.Level_7_Assigned_Users__c != '' && acc.AT1_Territory_Name__r.Level_7_Assigned_User_Network_Ids__c != ''){ 
                if(!map_role_map_accId_userId.ContainsKey(str_AT1Role)){
                    map_role_map_accId_userId.put(str_AT1Role, new map<String, Sales_Hierarchy__c>());
                }
                map_role_map_accId_userId.get(str_AT1Role).putall(ClsAccountTeamUtil.refreshAccountTeamMemberByHierarchyId(acc.Id, acc.AT1_Territory_Name__c, acc.AT1_Territory_Name__r.Level_7_Assigned_Users__c, acc.AT1_Territory_Name__r.Level_7_Assigned_User_Network_Ids__c)); 
            
            } 
            if(acc.AT2_Territory_Name__c != null && acc.AT2_Territory_Name__r.Level_7_Assigned_Users__c != '' && acc.AT2_Territory_Name__r.Level_7_Assigned_User_Network_Ids__c != ''){ 
                if(!map_role_map_accId_userId.ContainsKey(str_AT2Role)){
                    map_role_map_accId_userId.put(str_AT2Role, new map<String, Sales_Hierarchy__c>());
                }
                map_role_map_accId_userId.get(str_AT2Role).PutAll(ClsAccountTeamUtil.refreshAccountTeamMemberByHierarchyId(acc.Id, acc.AT2_Territory_Name__c, acc.AT2_Territory_Name__r.Level_7_Assigned_Users__c, acc.AT2_Territory_Name__r.Level_7_Assigned_User_Network_Ids__c)); 
            
            } 
            if(acc.ATS_Territory_Name__c != null && acc.ATS_Territory_Name__r.Level_7_Assigned_Users__c != '' && acc.ATS_Territory_Name__r.Level_7_Assigned_User_Network_Ids__c != ''){ 
                if(!map_role_map_accId_userId.ContainsKey(str_ATSRole)){
                    map_role_map_accId_userId.put(str_ATSRole, new map<String, Sales_Hierarchy__c>());
                }
                map_role_map_accId_userId.get(str_ATSRole).PutAll(ClsAccountTeamUtil.refreshAccountTeamMemberByHierarchyId(acc.Id, acc.ATS_Territory_Name__c, acc.ATS_Territory_Name__r.Level_7_Assigned_Users__c, acc.ATS_Territory_Name__r.Level_7_Assigned_User_Network_Ids__c)); 
            
            } 
            if(acc.RSR_Territory_Name__c != null && acc.RSR_Territory_Name__r.Level_7_Assigned_Users__c != '' && acc.RSR_Territory_Name__r.Level_7_Assigned_User_Network_Ids__c != ''){ 
                if(!map_role_map_accId_userId.ContainsKey(str_RSRRole)){
                    map_role_map_accId_userId.put(str_RSRRole, new map<String, Sales_Hierarchy__c>());
                }
                map_role_map_accId_userId.get(str_RSRRole).PutAll(ClsAccountTeamUtil.refreshAccountTeamMemberByHierarchyId(acc.Id, acc.RSR_Territory_Name__c, acc.RSR_Territory_Name__r.Level_7_Assigned_Users__c, acc.RSR_Territory_Name__r.Level_7_Assigned_User_Network_Ids__c)); 
            
            } 
            if(acc.RSM_Territory_Name__c != null && acc.RSM_Territory_Name__r.Level_7_Assigned_Users__c != '' && acc.RSM_Territory_Name__r.Level_7_Assigned_User_Network_Ids__c != ''){ 
                if(!map_role_map_accId_userId.ContainsKey(str_RSMRole)){
                    map_role_map_accId_userId.put(str_RSMRole, new map<String, Sales_Hierarchy__c>());
                }
                map_role_map_accId_userId.get(str_RSMRole).PutAll(ClsAccountTeamUtil.refreshAccountTeamMemberByHierarchyId(acc.Id, acc.RSM_Territory_Name__c, acc.RSM_Territory_Name__r.Level_7_Assigned_Users__c, acc.RSM_Territory_Name__r.Level_7_Assigned_User_Network_Ids__c)); 
            
            } 
            //End
            
            // Global Account Manager
            if(acc.GAMCD__c != null){
                if(!map_gamHierarchyCode_listAccts.containsKey(acc.GAMCD__c)){
                    map_gamHierarchyCode_listAccts.put(acc.GAMCD__c, new list<Account>());
                }
                map_gamHierarchyCode_listAccts.get(acc.GAMCD__c).add(acc);
            }

            // Tubing FE
            if(acc.MKTMGRCDE__c != null) {
                if(!map_mmHierarchyCode_listAccts.containsKey(acc.MKTMGRCDE__c)) {
                    map_mmHierarchyCode_listAccts.put(acc.MKTMGRCDE__c, new list<Account>());
                }
                map_mmHierarchyCode_listAccts.get(acc.MKTMGRCDE__c).add(acc);
            }

            //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
            if(acc.IND_KAM_Code__c != null) {
                if(!map_mmNewHierarchyCode_listAccts.containsKey(acc.IND_KAM_Code__c)) {
                    map_mmNewHierarchyCode_listAccts.put(acc.IND_KAM_Code__c, new list<Account>());
                }
                map_mmNewHierarchyCode_listAccts.get(acc.IND_KAM_Code__c).add(acc);
            }

            //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
            
            // Field Service Engineer
            if(acc.Field_Service_Engineer_Code__c != null) {
                if(!map_fseHierarchyCode_listAccts.containsKey(acc.Field_Service_Engineer_Code__c)) {
                    map_fseHierarchyCode_listAccts.put(acc.Field_Service_Engineer_Code__c, new list<Account>());
                }
                map_fseHierarchyCode_listAccts.get(acc.Field_Service_Engineer_Code__c).add(acc);
            }
            
        }
        
        //************************************************************************************************
        // END: build map for sales hierarchy of all roles
        //************************************************************************************************       
        
        ClsAccountTeamUtil.getAccountTeamMember(map_amHierarchyId_listAccts,true); // Change added by Mrunal to Update Account Manager based of Sales Hierarchy Update
        
        /* Commented by Subramanian for AT & Sensors
        map_role_map_accId_userId.put(str_amRole,ClsAccountTeamUtil.refreshAccountTeamMemberByHierarchyId(map_amHierarchyId_listAccts, map_hierarchyId_userId,map_uId_networkId));
        map_role_map_accId_userId.put(str_isRole,ClsAccountTeamUtil.refreshAccountTeamMemberByHierarchyId(map_isHierarchyId_listAccts, map_hierarchyId_userId,map_uId_networkId));
        map_role_map_accId_userId.put(str_feRole,ClsAccountTeamUtil.refreshAccountTeamMemberByHierarchyId(map_feHierarchyId_listAccts, map_hierarchyId_userId,map_uId_networkId));        
        */
        map_role_map_accId_userId.put(str_gamRole,ClsAccountTeamUtil.refreshAccountTeamMemberByHierarchyCode(map_gamHierarchyCode_listAccts, map_hierarchyCode_userId, str_gamType,map_uId_networkId));
        map_role_map_accId_userId.put(str_mmRole,ClsAccountTeamUtil.refreshAccountTeamMemberByHierarchyCode(map_mmHierarchyCode_listAccts, map_hierarchyCode_userId, str_mmType,map_uId_networkId));
        map_role_map_accId_userId.put(str_fseRole,ClsAccountTeamUtil.refreshAccountTeamMemberByHierarchyCode(map_fseHierarchyCode_listAccts, map_hierarchyCode_userId, str_fseType,map_uId_networkId));
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
        // add lili 2013.11.18
        if(map_role_map_accId_userId.containsKey(str_indRole)) {
            map_role_map_accId_userId.get(str_indRole).putAll(ClsAccountTeamUtil.refreshAccountTeamMemberByHierarchyCode(map_mmNewHierarchyCode_listAccts, map_hierarchyCode_userId, str_indType,map_uId_networkId));
        } else {
            map_role_map_accId_userId.put(str_indRole,ClsAccountTeamUtil.refreshAccountTeamMemberByHierarchyCode(map_mmNewHierarchyCode_listAccts, map_hierarchyCode_userId, str_indType,map_uId_networkId));
        }        
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
       
        
        //dont fire the account team member trigger
        ClsSharingUtil.fireAccountTeamMemberTrigger = false;
        //delete the custom account team with the 6 roles 
        
        // list<Account_Team__c> list_at2Delete = new list<Account_Team__c>(); Commented by Subramanian for AT & Sensors
        Map<String, Account_Team__c> map_at2Delete = new Map<String, Account_Team__c>();
        
        //system.debug('+map_role_map_accId_userId==='+map_role_map_accId_userId);
        // handle custom account team
        map<Id, Account_Team__c> map_atId_accountTeamMember = new map<Id, Account_Team__c>();
        list<Account_Team__c> list_accountTeam2update = new list<Account_Team__c>();
        list<Account_Team__c> list_accountTeam2Del = new list<Account_Team__c>();
        map<String, list<Account_Team__c>> map_teId_list_accountTeamMember = new map<String, list<Account_Team__c>>();
        for(Account_Team__c atm : [SELECT Account__c, Account__r.Sales_Hierarchy__c, Account__r.FE_Hierarchy__c,
                                          Account__r.FE_Hierarchy__r.Level_7_Assigned_User_Network_Ids__c,
                                          Account__r.GAMCD__c, Account__r.Sales_Hierarchy__r.Level_7_Territory_Code__c,
                                          Account__r.Sales_Hierarchy__r.Hierarchy_Type__c,
                                          Account__r.Sales_Hierarchy__r.Level_7_Assigned_User_Network_Ids__c,
                                          Account__r.Relay_Hierarchy__c,
                                          Account__r.TE_Customer_Key_Id__c,Team_Member_Key__c,
                                          Account__r.Relay_Hierarchy__r.Level_7_Assigned_User_Network_Ids__c,
                                          Name, Id,  RecordTypeId, RecordType.DeveloperName, Role__c, TE_Network_Id__c, Team_Member__c,
                                          Team_Member__r.IsActive, View__c,Opportunity_Access__c, Createddate
                                     FROM Account_Team__c
                                     WHERE Account__c IN :set_allAccId
                                     AND Account__c != null  ]){
            
            // Added for Case#00901244 by Subramanian                           
            if(atm.role__c == 'Customer Service Rep (CSR)' && (atm.Team_Member__r.IsActive || atm.RecordType.DeveloperName == 'Non_SFDC_User')){
              if(map_atId_accountTeamMember.containsKey(atm.Account__c)){                
                if(map_atId_accountTeamMember.get(atm.Account__c).Createddate < atm.Createddate){
                  // list_at2Delete.add(map_atId_accountTeamMember.get(atm.Account__c)); Commented by Subramanian for AT & Sensors
                  map_at2Delete.put(map_atId_accountTeamMember.get(atm.Account__c).Team_Member_Key__c, map_atId_accountTeamMember.get(atm.Account__c));
                  map_atId_accountTeamMember.put(atm.Account__c, atm);
                }else{
                  // list_at2Delete.add(atm); Commented by Subramanian for AT & Sensors
                  map_at2Delete.put(atm.Team_Member_Key__c, atm);
                }                
              }else{
                map_atId_accountTeamMember.put(atm.Account__c, atm);
              }
            }
            // End for Case#00901244
            
            if(rolesToDelete.contains(atm.Role__c)){// for the 6 role; delete it;
                // list_at2Delete.add(atm); Commented by Subramanian for AT & Sensors
                map_at2Delete.put(atm.Team_Member_Key__c, atm);
            }            
            else{
                if(atm.Team_Member__c != null){
                // for SFDC, if team member is inactive, delete it;                 
                    if(atm.RecordType.DeveloperName == 'SFDC_User'){
                        if(!atm.Team_Member__r.IsActive){
                            // list_at2Delete.add(atm); Commented by Subramanian for AT & Sensors
                            map_at2Delete.put(atm.Team_Member_Key__c, atm);
                        }else{
                            if(atm.Account__r.TE_Customer_Key_Id__c != null){
                                if(atm.TE_Network_Id__c != null){
                                    atm.Team_Member_Key__c = atm.Account__r.TE_Customer_Key_Id__c + atm.role__c + atm.TE_Network_Id__c;
                                }else{
                                    atm.Team_Member_Key__c = atm.Account__r.TE_Customer_Key_Id__c + atm.role__c;
                                }
                                list_accountTeam2update.add(atm);
                            }
                        }
                       
                    }
                }
                //for NON SFDC, check if according user is active, if yes,change to SFDC.
                if(atm.RecordType.DeveloperName == 'Non_SFDC_User' && atm.TE_Network_Id__c != null){
                    if(map_netWorkId_userId.containsKey(atm.TE_Network_Id__c)){
                        if(atm.Account__r.TE_Customer_Key_Id__c != null){
                            atm.Team_Member_Key__c = atm.Account__r.TE_Customer_Key_Id__c + atm.role__c + atm.TE_Network_Id__c;
                        }
                        atm.RecordTypeId = sFDCRt;
                        atm.Team_Member__c = map_netWorkId_userId.get(atm.TE_Network_Id__c);
                        list_accountTeam2update.add(atm);
                    }
                    else{
                        if(!map_teId_list_accountTeamMember.containsKey(atm.TE_Network_Id__c)){
                            map_teId_list_accountTeamMember.put(atm.TE_Network_Id__c,new list<Account_Team__c>());
                        }
                        map_teId_list_accountTeamMember.get(atm.TE_Network_Id__c).add(atm);
                    }
                }
            }                               
        }

        if(!map_teId_list_accountTeamMember.isEmpty()){
            for(User u : [SELECT Id,
                                 Te_Network_Id__c,
                                 IsActive
                          FROM User
                          WHERE Te_Network_Id__c IN :map_teId_list_accountTeamMember.keySet()
                          AND IsActive = true]){
                map_netWorkId_userId.put(u.Te_Network_Id__c, u.Id);             
                if(map_teId_list_accountTeamMember.containsKey(u.Te_Network_Id__c)){
                    for(Account_Team__c atm : map_teId_list_accountTeamMember.get(u.Te_Network_Id__c)){
                        if(atm.RecordTypeId != sFDCRt || atm.Team_Member__c != u.Id){
                            atm.Team_Member_Key__c = atm.Account__r.TE_Customer_Key_Id__c + atm.role__c + atm.TE_Network_Id__c;
                            atm.RecordTypeId = sFDCRt;
                            atm.Team_Member__c = u.Id;
                            list_accountTeam2update.add(atm);
                        }   
                    } 
                }             
            }         
        }
        /* Commented by Subramanian Jairam for AT & Sensors
        if(list_at2Delete.size() > 0){
           // delete list_at2Delete; // Commented for Case - 00900695 by Developer Subramanian on 10th Feb 2016
            Database.DeleteResult[] results = Database.delete(list_at2Delete, false);
        }
        */
        if(list_accountTeam2update.size() > 0){
            // update list_accountTeam2update; // Commented for Case - 00900695 by Developer Subramanian on 10th Feb 2016
            Database.SaveResult[] results = Database.Update(list_accountTeam2update, false);
        } 
        //Start : Code Modified to check multiple TE Network IDs Case No:00758872 - 19/2/2015
        map<id, user> mapUser = new map<id, user>([select id, Te_Network_Id__c from user]);
        map<string, ID> mapUserNetworkId = new map<string, ID>();
        for(user oUser : mapUser.values())
            if(oUser.Te_Network_Id__c != null && oUser.Te_Network_Id__c != '')
                mapUserNetworkId.put(oUser.Te_Network_Id__c, oUser.id);
        //End : Code Modified to check multiple TE Network IDs Case No:00758872 - 19/2/2015
        
        //generate custom account team for role AM,IS,FE,GAM, MM and FSE           
        for(String role: map_role_map_accId_userId.keyset()){
            for(Id acctId : map_role_map_accId_userId.get(role).keySet()){
                //system.debug('acctId =='+acctId  );
                 //Start : Code Modified to check multiple TE Network IDs Case No:00758872 - 17/3/2015
                Sales_Hierarchy__c oSH = map_role_map_accId_userId.get(role).get(acctId);
                string strTeam_Member = oSH.Level_7_Assigned_Users__c;
               system.debug('##role' + role);
               system.debug('##oSH' + oSH);
               system.debug('##map_role_map_accId_userId' + map_role_map_accId_userId);
                string strTeam_MemberTEID = oSH.Level_7_Assigned_User_Network_Ids__c;
                set<string> setstrTeam_Member = new set<string>();
                if(String.isNotBlank(strTeam_Member)) { setstrTeam_Member.addAll(strTeam_Member.split(';')); }
                list<string> lststrTeam_MemberTEID = new list<string>();
                if(String.isNotBlank(strTeam_MemberTEID)) { lststrTeam_MemberTEID.addAll(strTeam_MemberTEID.split(';')); }
                
                if(lststrTeam_MemberTEID.size() > 0)
                {
                    for(string strTEID :lststrTeam_MemberTEID)
                        if(mapUserNetworkId.containsKey(strTEID) && !setstrTeam_Member.contains((string)mapUserNetworkId.get(strTEID)) && mapUserNetworkId.get(strTEID) != null)
                            setstrTeam_Member.add(mapUserNetworkId.get(strTEID));
                            
                }
                //list<string> lstNetworkID = map_uId_networkId.get(strTeam_Member).split(';');

                if(setstrTeam_Member.size() > 0 && oSH != null)
                {
                    /*if(setstrTeam_Member.size() == 1)
                    {
                            Account_Team__c acctTeam= new Account_Team__c();
                            acctTeam.Account__c = acctId;
                            acctTeam.Role__c = role;
                            acctTeam.RecordTypeId = sFDCRt;
                            acctTeam.Opportunity_Access__c = 'Edit';
                            if(setstrTeam_Member.get(0) != null && setstrTeam_Member.get(0) != '')
                                acctTeam.Team_Member__c = setstrTeam_Member.get(0) ;
                        
                            //if(map_uId_networkId.containsKey(acctTeam.Team_Member__c)){
                                acctTeam.TE_Network_Id__c = mapUser.get(acctTeam.Team_Member__c).TE_Network_Id__c;
                            //}else{
                                //acctTeam.TE_Network_Id__c = '';
                            ///}
                            if(map_accId_customeKey.containsKey(acctId)){
                                acctTeam.Team_Member_Key__c = map_accId_customeKey.get(acctId) + role + acctTeam.TE_Network_Id__c;
                            }
                            //system.debug('acctTeam=='+acctTeam);
                            if(setstrTeam_Member[0] != null && setstrTeam_Member[0] != '')
                                list_atm2Insert.add(acctTeam);
                    }
                    else 
                    {*/
                        for(string strtempTeam_Member : setstrTeam_Member)
                        {
                            Account_Team__c acctTeam= new Account_Team__c();
                            acctTeam.Account__c = acctId;
                            acctTeam.Role__c = role;
                            acctTeam.RecordTypeId = sFDCRt;
                            acctTeam.Opportunity_Access__c = 'Edit';
                            if(strtempTeam_Member != null && strtempTeam_Member != '')
                                acctTeam.Team_Member__c = strtempTeam_Member;
                        
                            //if(map_uId_networkId.containsKey(acctTeam.Team_Member__c)){
                            if(mapUser.containsKey(strtempTeam_Member))
                                acctTeam.TE_Network_Id__c = mapUser.get(strtempTeam_Member).TE_Network_Id__c;
                            //}else{
                                //acctTeam.TE_Network_Id__c = '';
                            ///}
                            if(map_accId_customeKey.containsKey(acctId)){
                                acctTeam.Team_Member_Key__c = map_accId_customeKey.get(acctId) + role + acctTeam.TE_Network_Id__c;
                            }
                            
                            if(strtempTeam_Member != null && strtempTeam_Member != '' && !map_at2Delete.containskey(acctTeam.Team_Member_Key__c)){
                                list_atm2Insert.add(acctTeam);
                            }else{
                                map_at2Delete.remove(acctTeam.Team_Member_Key__c);
                            }
                        }
                    //}
                }
                //end : Code Modified to check multiple TE Network IDs Case No:00758872
            }
        }
        
        if(map_at2Delete.size() > 0){
           // delete list_at2Delete; // Commented for Case - 00900695 by Developer Subramanian on 10th Feb 2016
           //  Database.DeleteResult[] results = Database.delete(list_at2Delete, false); Commented by Subramanian Jairam for AT & Sensors
            Database.DeleteResult[] results = Database.delete(map_at2Delete.values(), false);
        }
        
        //system.debug('list_atm2Insert=='+list_atm2Insert);
        if(list_atm2Insert.size() > 0){
            // insert list_atm2Insert; // Commented for Case - 00900695 by Developer Subramanian on 10th Feb 2016
            Database.SaveResult[] results = Database.insert(list_atm2Insert, false);
        }   
    }

    global void finish(Database.BatchableContext BC){ 
        ClsBatch_initStdAccountTeam cls = new ClsBatch_initStdAccountTeam();
        database.executeBatch(cls);
    }
    
}