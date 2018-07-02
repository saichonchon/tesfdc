/**
* This trigger used to manage Sharing of Account.
*
* @author      Yinfeng Guo
* @created     2012-02-09
* @since       23.0 (Force.com ApiVersion)      
* @version     1.0 
*
* @changelog
* 2012-02-09 Yinfeng Guo <yinfeng.guo@itbconsult.com>
* - Created 
* 
* @Prabhanjan Nandyala
* 2016-10-24 Prabhanjan N <prabhanjan.nandyala@zensar.com>
* - Modified
* Changes made: Incorporated B-territory logic for ADM BU as it is merged into C2S. 
* 
* Territory_L1_Name__c
*/


trigger account_AIDUD_BU_managedSharing on Account (after delete, after insert, after undelete,after update) {
    
    
    Id rt_cis_gam = ClsSharingUtil.gamCustomSetting();
    Id rt_cis_account = ClsSharingUtil.accountCustomSetting();
    Id rt_sfdc_user = ClsSharingUtil.sfdcUserCustomSetting(); 
    
    //Prabhanjan N: 2016-10-24
    // Adding variables for B-territory logic
    // 
    list<string> TempTerrCodes  = new list<string>();
    map<Id, list<string>> AccIdToTerrCodes = new map<Id, list<string>> ();
    map<Id, string> AccIdToCusKey = new map<Id, string> ();
    map<Id, list<string>> AccIdToTerrCodes_del = new map<Id, list<string>> ();
    map<Id, list<string>> AccIdToTerrCodes_ins = new map<Id, list<string>> ();
    
    // this is used for querying all the territories 
    set<string> TerrCodes = new  set<string>();
    
    if(trigger.isInsert || trigger.isUnDelete){
        //  insert public group , sharing to parent account
        //  share public group to child accouts
        // Added by Lili Zhao 2014-03-10 begin due to add the account Manager to GroupMember
        map<Id, String> map_accManager_GropName = new map<Id, String>();     
        // Added by Lili Zhao 2014-03-10 end due to add the account Manager to GroupMember
        map<Id,String> map_shId_groupName = new map<Id,String>();
        map<String,Id> map_groupName_shId4child = new map<String,Id>();
        map<Id,Id> map_shId_accId = new map<Id,Id>();
        set<Id> set_childId = new set<Id>();
        for(Account a: trigger.new){
            
            //Prabhanjan: ADM Migration: building consumer key
            AccIdToCusKey.put(a.Id, string.valueOf(a.TE_Customer_Key_Id__c));
            
            system.debug('a.RecordTypeId:::'+a.RecordTypeId + ':::rt_cis_gam:::'+rt_cis_gam + ':::rt_cis_account:::'+rt_cis_account);
            if(a.RecordTypeId == rt_cis_gam){
                
                if(a.Type == 'Global Account' && a.GAMCD__c != null && a.Sales_Hierarchy_GAM__c != null){
                    map_shId_groupName.put(a.Sales_Hierarchy_GAM__c,ClsSharingUtil.NAME_PREFIX + a.GAMCD__c);
                    map_shId_accId.put(a.Sales_Hierarchy_GAM__c,a.Id); 
                    // Added by Lili Zhao 2014-03-10 begin due to add the account Manager to GroupMember
                    if(a.Account_Manager__c != null) map_accManager_GropName.put(a.Account_Manager__c, ClsSharingUtil.NAME_PREFIX + a.GAMCD__c);
                    // Added by Lili Zhao 2014-03-10 end due to add the account Manager to GroupMember
                    //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//             
                }else if(a.Type == 'Grouped B' && a.IND_KAM_Code__c != null && a.Sales_Hierarchy_MM__c != null){
                    map_shId_groupName.put(a.Sales_Hierarchy_MM__c,ClsSharingUtil.NAME_PREFIX_B + a.IND_KAM_Code__c);
                    map_shId_accId.put(a.Sales_Hierarchy_MM__c,a.Id);
                    // Added by Lili Zhao 2014-03-10 begin due to add the account Manager to GroupMember
                    if(a.Account_Manager__c != null) map_accManager_GropName.put(a.Account_Manager__c, ClsSharingUtil.NAME_PREFIX_B + a.IND_KAM_Code__c);
                    // Added by Lili Zhao 2014-03-10 end due to add the account Manager to GroupMember   
                }/*
else if(a.Type == 'Grouped B' && a.MKTMGRCDE__c != null && a.Sales_Hierarchy_MM__c != null){
map_shId_groupName.put(a.Sales_Hierarchy_MM__c,ClsSharingUtil.NAME_PREFIX_B + a.MKTMGRCDE__c);
map_shId_accId.put(a.Sales_Hierarchy_MM__c,a.Id);   
}
*/
                //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
            }else if(a.RecordTypeId == rt_cis_account){
                if(a.Sales_Hierarchy_GAM__c != null && a.GAMCD__c != null){
                    map_groupName_shId4child.put(ClsSharingUtil.NAME_PREFIX + a.GAMCD__c,a.Sales_Hierarchy_GAM__c);
                    set_childId.add(a.Id);
                }
                //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****// 
                /*
if(a.Sales_Hierarchy_MM__c != null && a.MKTMGRCDE__c != null){
map_groupName_shId4child.put(ClsSharingUtil.NAME_PREFIX_B + a.MKTMGRCDE__c,a.Sales_Hierarchy_MM__c);
set_childId.add(a.Id);
}
*/
                if(a.Sales_Hierarchy_MM__c != null && a.IND_KAM_Code__c != null){
                    map_groupName_shId4child.put(ClsSharingUtil.NAME_PREFIX_B + a.IND_KAM_Code__c,a.Sales_Hierarchy_MM__c);
                    set_childId.add(a.Id);
                }
                //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****// 
           
            //Prabhanjan N: 2016-10-24
            // setting up variables for B-territory logic in insert
            //  
            System.debug('**a.Territory_L1_Name__c**' +a.Territory_L1_Name__c + '**B_Territory_Codes__c**' +a.B_Territory_Codes__c ); //added by Rahul goyal on 04-11-16 to debug the test class
            if((a.Territory_L1_Name__c==Worldwide_Aero_Def_Mari__c.getInstance().ADM_BU_Name__c) && a.B_Territory_Codes__c!=null ){
                
                TempTerrCodes = a.B_Territory_Codes__c.split(',');
                TerrCodes.addAll(TempTerrCodes);
                if(!AccIdToTerrCodes.containsKey(a.Id))     AccIdToTerrCodes.put(a.Id, new list<string>());
                AccIdToTerrCodes.get(a.Id).addAll(TempTerrCodes);
            }
            
            // AccIdToTerrCodes
            // TerrCodes
            
            }   
            
            
            
        }
        system.debug('map_shId_groupName::::'+map_shId_groupName+'::::map_shId_accId::::'+map_shId_accId+':::::map_groupName_shId4child:::'+map_groupName_shId4child+':::set_childId:::'+set_childId);
        //ClsSharingUtil.insertPublicGroupSharing(map_shId_groupName, map_shId_accId,map_groupName_shId4child,set_childId);        
        ClsSharingUtil.insertPublicGroupSharing(map_shId_groupName, map_shId_accId,map_groupName_shId4child,set_childId);
        if(!map_accManager_GropName.isEmpty())   ClsSharingUtil.addCustomerFocusTeamAsGroupMember(map_accManager_GropName);
        // Added by Lili Zhao 2014-03-10 end due to add the account Manager to GroupMember
        
    }
    else if(trigger.isDelete){
        // delete public group
        set<String> set_groupName2Delete = new set<String>();
        for(Account a:trigger.old){
            if(a.RecordTypeId == rt_cis_gam){
                if(a.Type == 'Global Account' && a.GAMCD__c != null){
                    set_groupName2Delete.add(ClsSharingUtil.NAME_PREFIX + a.GAMCD__c);  
                    //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****// 
                }
                /*
else if(a.Type == 'Grouped B' && a.MKTMGRCDE__c != null){
set_groupName2Delete.add(ClsSharingUtil.NAME_PREFIX_B + a.MKTMGRCDE__c);
}
*/
                else if(a.Type == 'Grouped B' && a.IND_KAM_Code__c != null){
                    set_groupName2Delete.add(ClsSharingUtil.NAME_PREFIX_B + a.IND_KAM_Code__c);
                }
                
                //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//  
            }
        }
        if(!set_groupName2Delete.isEmpty()) ClsSharingUtil.deletPublicGroup(set_groupName2Delete);
        
        
        
    }
    else if(!ClsSharingUtil.TriggerRecursionDefense && trigger.isUpdate){
        //ClsSharingUtil.TriggerRecursionDefense = true;
        // Added by Lili Zhao 2014-03-10 begin due to add the account Manager to GroupMember
        map<Id, String> map_accManager_GropName = new map<Id, String>();
        map<Id, String> map_oldAccManager_GropName = new map<Id, String>();     
        // Added by Lili Zhao 2014-03-10 end due to add the account Manager to GroupMember
        map<Id,String> map_shId_groupName = new map<Id,String>();
        map<Id,String> map_accId_groupName = new map<Id,String>();
        map<String,Id> map_groupName_shId4child = new map<String,Id>();
        map<Id,Id> map_shId_accId = new map<Id,Id>();
        set<String> set_groupName2Delete = new set<String>();
        set<Id> set_childId = new set<Id>();
        set<Id> set_accId4ATM = new set<Id>();
        map<string,set<Id>> map_groupName_setAccId = new map<string,set<Id>>();
        set<Id> set_childId2DeleteAccountSharing = new set<Id>();
        id accid;
        for(Account a: trigger.new){
            accid = a.Id;
            AccIdToCusKey.put(a.Id, string.valueOf(a.TE_Customer_Key_Id__c));
            system.debug('::::::a.IND_KAM_Code__c ='+a.IND_KAM_Code__c +':::trigger.oldMap.get(a.Id).IND_KAM_Code__c ='+trigger.oldMap.get(a.Id).IND_KAM_Code__c+':::a.GAMCD__c='+a.GAMCD__c+':::trigger.oldMap.get(a.Id).GAMCD__c='+trigger.oldMap.get(a.Id).GAMCD__c );
            // Added by Lili Zhao 2014-03-10 begin due to add the account Manager to GroupMember
            if(Trigger.oldMap.get(a.Id).Account_Manager__c != a.Account_Manager__c){
                if(a.RecordTypeId == rt_cis_gam){
                    if(a.Type == 'Global Account' && a.GAMCD__c != null && a.Sales_Hierarchy_GAM__c != null){
                        // Added by Lili Zhao 2014-03-10 begin due to add the account Manager to GroupMember
                        if(a.Account_Manager__c != null) map_accManager_GropName.put(a.Account_Manager__c, ClsSharingUtil.NAME_PREFIX + a.GAMCD__c);
                        if(Trigger.oldMap.get(a.Id).Account_Manager__c != null) map_oldAccManager_GropName.put(Trigger.oldMap.get(a.Id).Account_Manager__c, ClsSharingUtil.NAME_PREFIX + a.GAMCD__c);
                        // Added by Lili Zhao 2014-03-10 end due to add the account Manager to GroupMember    
                        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//         
                    }else if(a.Type == 'Grouped B' && a.IND_KAM_Code__c != null && a.Sales_Hierarchy_MM__c != null){
                        // Added by Lili Zhao 2014-03-10 begin due to add the account Manager to GroupMember
                        if(a.Account_Manager__c != null) map_accManager_GropName.put(a.Account_Manager__c, ClsSharingUtil.NAME_PREFIX_B + a.IND_KAM_Code__c);
                        if(Trigger.oldMap.get(a.Id).Account_Manager__c != null) map_oldAccManager_GropName.put(Trigger.oldMap.get(a.Id).Account_Manager__c, ClsSharingUtil.NAME_PREFIX_B + a.IND_KAM_Code__c);
                        // Added by Lili Zhao 2014-03-10 end due to add the account Manager to GroupMember 
                    }
                }
            }
            system.debug('a: ' + a);
            // Added by Lili Zhao 2014-03-10 end due to add the account Manager to GroupMember   
            if(a.GAMCD__c != trigger.oldMap.get(a.Id).GAMCD__c || a.IND_KAM_Code__c != trigger.oldMap.get(a.Id).IND_KAM_Code__c ){                      
                system.debug('testlili:::');
                set_accId4ATM.add(a.Id);   
                // delete old public group
                if(trigger.oldMap.get(a.Id).RecordTypeId == rt_cis_gam){
                    if(trigger.oldMap.get(a.Id).Type == 'Global Account' && trigger.oldMap.get(a.Id).GAMCD__c != null){
                        set_groupName2Delete.add(ClsSharingUtil.NAME_PREFIX + trigger.oldMap.get(a.Id).GAMCD__c); 
                        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//   
                    }else if(trigger.oldMap.get(a.Id).Type == 'Grouped B' && trigger.oldMap.get(a.Id).IND_KAM_Code__c != null){
                        set_groupName2Delete.add(ClsSharingUtil.NAME_PREFIX_B + trigger.oldMap.get(a.Id).IND_KAM_Code__c);
                    }
                    //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****// 
                }else if(trigger.oldMap.get(a.Id).RecordTypeId == rt_cis_account){
                    if(trigger.oldMap.get(a.Id).Sales_Hierarchy_GAM__c != null && trigger.oldMap.get(a.Id).GAMCD__c != null){
                        String groupName = ClsSharingUtil.NAME_PREFIX + trigger.oldMap.get(a.Id).GAMCD__c;
                        if(!map_groupName_setAccId.containsKey(groupName)){
                            map_groupName_setAccId.put(groupName,new set<Id>());    
                        }
                        map_groupName_setAccId.get(groupName).add(a.Id);
                        set_childId2DeleteAccountSharing.add(a.Id);     
                    }
                    if(trigger.oldMap.get(a.Id).Sales_Hierarchy_MM__c != null && trigger.oldMap.get(a.Id).IND_KAM_Code__c != null){
                        String groupName = ClsSharingUtil.NAME_PREFIX_B + trigger.oldMap.get(a.Id).IND_KAM_Code__c;
                        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
                        if(!map_groupName_setAccId.containsKey(groupName)){
                            map_groupName_setAccId.put(groupName,new set<Id>());    
                        }
                        map_groupName_setAccId.get(groupName).add(a.Id);
                        set_childId2DeleteAccountSharing.add(a.Id);     
                    }
                }
                
                if(a.RecordTypeId == rt_cis_gam){
                    
                    if(a.Type == 'Global Account' && a.GAMCD__c != null && a.Sales_Hierarchy_GAM__c != null){
                        map_shId_groupName.put(a.Sales_Hierarchy_GAM__c,ClsSharingUtil.NAME_PREFIX + a.GAMCD__c);
                        map_accId_groupName.put(a.Id,ClsSharingUtil.NAME_PREFIX + a.GAMCD__c);
                        map_shId_accId.put(a.Sales_Hierarchy_GAM__c,a.Id); 
                        // Added by Lili Zhao 2014-03-10 begin due to add the account Manager to GroupMember
                        if(a.Account_Manager__c != null) map_accManager_GropName.put(a.Account_Manager__c, ClsSharingUtil.NAME_PREFIX + a.GAMCD__c);
                        
                        // Added by Lili Zhao 2014-03-10 end due to add the account Manager to GroupMember    
                        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//         
                    }else if(a.Type == 'Grouped B' && a.IND_KAM_Code__c != null && a.Sales_Hierarchy_MM__c != null){
                        map_shId_groupName.put(a.Sales_Hierarchy_MM__c,ClsSharingUtil.NAME_PREFIX_B + a.IND_KAM_Code__c);
                        map_accId_groupName.put(a.Id,ClsSharingUtil.NAME_PREFIX_B + a.IND_KAM_Code__c);
                        map_shId_accId.put(a.Sales_Hierarchy_MM__c,a.Id);  
                        // Added by Lili Zhao 2014-03-10 begin due to add the account Manager to GroupMember
                        if(a.Account_Manager__c != null) map_accManager_GropName.put(a.Account_Manager__c, ClsSharingUtil.NAME_PREFIX_B + a.IND_KAM_Code__c);
                        system.debug('map_accManager_GropName:::'+map_accManager_GropName);
                        // Added by Lili Zhao 2014-03-10 end due to add the account Manager to GroupMember 
                    }
                }else if(a.RecordTypeId == rt_cis_account){
                    if(a.Sales_Hierarchy_GAM__c != null && a.GAMCD__c != null){
                        map_groupName_shId4child.put(ClsSharingUtil.NAME_PREFIX + a.GAMCD__c,a.Sales_Hierarchy_GAM__c);
                        set_childId.add(a.Id);
                    }
                    //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****// 
                    
                    if(a.Sales_Hierarchy_MM__c != null && a.IND_KAM_Code__c != null){
                        map_groupName_shId4child.put(ClsSharingUtil.NAME_PREFIX_B + a.IND_KAM_Code__c,a.Sales_Hierarchy_MM__c);
                        set_childId.add(a.Id);
                    }
                    //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****// 
                }
            }
            
            
            //Prabhanjan N: 2016-10-24
            // setting up variables for B-territory logic
            
            //Checking for ADM BU 
            if(a.Territory_L1_Name__c==Worldwide_Aero_Def_Mari__c.getInstance().ADM_BU_Name__c ){
                if( Trigger.oldMap.get(a.Id).B_Territory_Codes__c!= a.B_Territory_Codes__c){
                    
                    if(a.B_Territory_Codes__c<>null) TempTerrCodes = a.B_Territory_Codes__c.split(','); 
                    TerrCodes.addAll(TempTerrCodes);
                    
                    //this adds the new territories
                    set<string> TempTerrCodes_new = new set<string>();
                    TempTerrCodes_new.addAll(TempTerrCodes);
                    
                    //this adds the old territories
                    set<string> TempTerrCodes_old = new set<string>();
                    string oldbterrcodestemp = Trigger.oldMap.get(a.Id).B_Territory_Codes__c;
                    if(oldbterrcodestemp<>null)  TempTerrCodes_old.addAll( oldbterrcodestemp.split(',')); 
                    
                    //now TerrCodes contains old and new territory codes
                    TerrCodes.addAll(TempTerrCodes_old);
                    
                    //take only new territories
                    TempTerrCodes_new.removeAll(TempTerrCodes_old);
                    //take only old territories
                    TempTerrCodes_old.removeAll(TempTerrCodes);
                                        
                    // find out the changes between two sets using removeall
                    if(!AccIdToTerrCodes_ins.containsKey(a.Id) && TempTerrCodes_new.size()>0) {
                        AccIdToTerrCodes_ins.put(a.Id, new list<string>());
                        AccIdToTerrCodes_ins.get(a.Id).addAll(TempTerrCodes_new);
                    }
                    
                    if(!AccIdToTerrCodes_del.containsKey(a.Id)&& TempTerrCodes_old.size()>0) {
                        AccIdToTerrCodes_del.put(a.Id, new list<string>());
                        AccIdToTerrCodes_del.get(a.Id).addAll(TempTerrCodes_old);        
                    }
                    
                }
            }
            //    AccIdToTerrCodes
            //  TerrCodes
            
            
        }
        system.debug('map_shId_accId::::'+map_shId_accId);
        if(!set_childId2DeleteAccountSharing.isEmpty()) ClsSharingUtil.deleteAccountSharingOnPublicGroup(map_groupName_setAccId, set_childId2DeleteAccountSharing);
        if(!set_groupName2Delete.isEmpty()) ClsSharingUtil.deletPublicGroup(set_groupName2Delete);
        //if(set_childId.size() > 0) ClsSharingUtil.insertPublicGroupSharing(map_shId_groupName, map_shId_accId,map_groupName_shId4child,set_childId);
        // Added by Lili Zhao 2014-03-10 begin due to add the account Manager to GroupMember
        //ClsSharingUtil.insertPublicGroupSharing(map_shId_groupName, map_shId_accId,map_groupName_shId4child,set_childId);
        if(!map_shId_groupName.isEmpty() || !map_shId_accId.isEmpty() || !map_groupName_shId4child.isEmpty() || !set_childId.isEmpty()) ClsSharingUtil.insertPublicGroupSharing(map_shId_groupName, map_shId_accId,map_groupName_shId4child,set_childId);
        if(!map_accManager_GropName.isEmpty() || !map_oldAccManager_GropName.isEmpty())   ClsSharingUtil.addAccMangermAsGroupMember(map_accManager_GropName, map_oldAccManager_GropName);
        // Added by Lili Zhao 2014-03-10 end due to add the account Manager to GroupMember
        //update account team,same logic as before
        if(!set_accId4ATM.isEmpty()){
            String uids;
            /*according to the all updated account id, to select the Account Team*/
            map<id, string> map_old_aid_uidList_account = new map<id, string>();
            for(Account_Team__c accTeam : [Select Id, Account__c, Team_Member__c, RecordTypeId from Account_Team__c where Account__c in: set_accId4ATM]){
                if(accTeam.RecordTypeId != null && accTeam.RecordTypeId == rt_sfdc_user && accTeam.Account__c != null && accTeam.Team_Member__c != null) {
                    if(!map_old_aid_uidList_account.containsKey(accTeam.Account__c)) {
                        map_old_aid_uidList_account.put(accTeam.Account__c, accTeam.Team_Member__c);
                    }
                    else {
                        uids = map_old_aid_uidList_account.get(accTeam.Account__c);
                        map_old_aid_uidList_account.put(accTeam.Account__c, uids + ',' + accTeam.Team_Member__c);
                    }
                }
            }
            /*delete Account Team Member*/
            if(!map_old_aid_uidList_account.isEmpty()) ClsSharingUtil.deleteAccountTeamMember(map_old_aid_uidList_account);
            
            /*according to the all updated account id, to select the Account Team*/
            map<id, string> map_new_aid_uidList_account = new map<id, string>();
            for(Account_Team__c accTeam : [Select Id, Account__c, Team_Member__c, RecordTypeId from Account_Team__c where Account__c in: set_childId]){
                if(accTeam.RecordTypeId != null && accTeam.RecordTypeId == rt_sfdc_user && accTeam.Account__c != null && accTeam.Team_Member__c != null) {
                    if(!map_new_aid_uidList_account.containsKey(accTeam.Account__c)) {
                        map_new_aid_uidList_account.put(accTeam.Account__c, accTeam.Team_Member__c);
                    }
                    else {
                        uids = map_new_aid_uidList_account.get(accTeam.Account__c);
                        map_new_aid_uidList_account.put(accTeam.Account__c, uids + ',' + accTeam.Team_Member__c);
                    }
                }
            }
            /*new Account Team Member*/
            if(!map_new_aid_uidList_account.isEmpty()) ClsSharingUtil.upsertAccountTeamMember(map_new_aid_uidList_account);
        } 
        system.debug('map_shId_accId:::'+map_shId_accId);
        // add customer focus team to public group.
        if(!map_shId_accId.isEmpty()){
            
            map<Id,String> map_uid_groupName = new map<Id,String>();
            for(Customer_Focus_Team_Member__c cusTeam : [Select Id, Global_Account_Lkp__c, Salesforce_User_Name__c from Customer_Focus_Team_Member__c where Global_Account_Lkp__c in: map_accId_groupName.keySet()]){
                if(cusTeam.Salesforce_User_Name__c != null){
                    map_uid_groupName.put(cusTeam.Salesforce_User_Name__c,map_accId_groupName.get(cusTeam.Global_Account_Lkp__c));
                }       
            }
            system.debug('map_uid_groupName:::'+map_uid_groupName);
            if(!map_uid_groupName.isEmpty()) ClsSharingUtil.addCustomerFocusTeamAsGroupMember(map_uid_groupName);
        } 
        Account acc = (Account)[select id,IND_KAM_Code__c,Sales_Hierarchy_MM__c  from account where id =:accid];
        system.debug('acc ::::'+ acc );                     
    }
    
    try{
    // Prabhanjan: B- territory  
    // Get the territory and users mapping    
    map<string,string> terrToUser7 = new map<string,string>();
    if(TerrCodes.size()>0){
        terrToUser7 = AccountBTerritoryUtil.getLevel7UserfromSalesHierarchy(TerrCodes);
    }
    
    //Add the users collected from trigger.insert into final variable
     AccIdToTerrCodes_ins.putAll(AccIdToTerrCodes);
    
    //Get the account-and-account team members to insert
    if(AccIdToTerrCodes_ins.size()>0) AccountBTerritoryUtil.insertAccountTeamB_Terr(AccIdToTerrCodes_ins, terrToUser7, AccIdToCusKey);
    
    //Get the account-and-account team members to delete
    if(AccIdToTerrCodes_del.size()>0)   AccountBTerritoryUtil.deleteAccountTeamB_Terr(AccIdToTerrCodes_del, terrToUser7);
    
    //Get the account-and-account team members to insert
    }
    
    catch(exception e){
        
            system.debug(e.getMessage()+' at '+ e.getStackTraceString());
    }
    
    
}