/**
*   
*   This Before Insert Update Trigger sets Account Manager (AM) as Account Owner.
*   And in case of an Account Owner Change, the Account Owner Change the Account Owner will be stored in Account Owner Lookup on related Oppies.
*   Test Class: account_BIU_setAccManagerAsAccOwnerTest
*
*   Author              |Author-Email                       |Date        |Comment
*   --------------------|---------------------------------- |------------|-------------------------------------
*   Frederic Faisst     |frederic.faisst@itbconsult.com     |22.02.2012  |Initial Draft
*   Yinfeng  Guo        |yinfeng.guo@itbconsult.com         |27.03.2012  |Modified
*   Frederic Faisst     |frederic.faisst@itbconsult.com     |27.04.2012  |Copy of account type. This functionality was in another trigger which is no more needed.
*   Nelson zheng        |yimin.zheng@te.com                 |13.10.2015  |update the opportunity team member when am is changed
*   Rajendra Shahae     |rajendra.shahane@zensar.com        |12/10/2016  |updated for case 829400
*/

trigger account_BIU_setAccManagerAsAccOwner on Account (before insert, before update, after insert, after update) {


    String triggerName = 'Account';
    //************************* BEGIN Pre-Processing **********************************************
    //System.debug('************************* ' + triggerName + ': BEGIN Pre-Processing ********');

   /*
    *   Parameters
    */
    Id systemAdminProfileId = Apex_Helper_Settings__c.getInstance('System Admin Profile Id').Value__c;     
    Id integrationAdminProfileId = Apex_Helper_Settings__c.getInstance('Service Account Profile Id').Value__c;
    Id teisAdminUserId = Apex_Helper_Settings__c.getInstance('TEIS Admin User Id').Value__c;
    Id actualUserProfileId = Userinfo.getProfileId();
    List<AccountTeamMember> list_atms2Insert = new List<AccountTeamMember>();
    List<AccountTeamMember> list_atms2Update = new List<AccountTeamMember>();
    Set<Id> set_accIds = new Set<Id>();
    Map<Id, Id> map_accId_accManager = new Map<Id, Id>();
    Id cisAccountRecordTypeId = Apex_Helper_Settings__c.getInstance('Account Record Type Id').Value__c; //Get "CIS Account" RecordType Id out of Custom Setting
    
    
    /*modified by yinfeng.guo*/
    map<Id, Id> map_accId_salesHierarchyId = new map<Id, Id>();
    map<Id, String> map_accId_accSalesTerritoryCDE = new map<Id, String>();//add by yinfeng.guo 
    /*modified by yinfeng.guo*/
    
    //************************* END Pre-Processing ************************************************
    //System.debug('************************* ' + triggerName + ': END Pre-Processing **********');



    //************************* BEGIN Before Trigger **********************************************
    if(Trigger.isBefore){
        System.debug('************************* ' + triggerName + ': Before Trigger ************');
        //If Trigger is insert  
        if(Trigger.isInsert){
            for(Account acc : Trigger.new){
            //System.debug('########: HALLO');
                if(acc.Account_Manager__c != null && (actualUserProfileId == systemAdminProfileId || actualUserProfileId == integrationAdminProfileId)){
                    if(teisAdminUserId != null && acc.Account_Manager__c == teisAdminUserId){//if Account_Manager__c = teisAdminUserId --> teisAdminUserId user Id must be set as Account Manager and as Account Owner
                    System.debug('########@@########: HALLO');
                        acc.OwnerId = teisAdminUserId;
                        //System.debug('########@@########: HALLO'+teisAdminUserId);
                    }
                    else{
                        map_accId_accSalesTerritoryCDE.put(acc.Id, acc.SALES_TERRITORY_CDE__c);//add by yinfeng.guo
                        map_accId_accManager.put(acc.Id, acc.Account_Manager__c);
                        if(acc.Sales_Hierarchy__c != null && String.ValueOf(acc.Sales_Hierarchy__c) != '') map_accId_salesHierarchyId.put(acc.Id, acc.Sales_Hierarchy__c);//add by yinfeng.guo                      
                        //acc.OwnerId = acc.Account_Manager__c;comment by yinfeng.guo
                        if(acc.Account_Manager__c != null){
                        acc.OwnerId = acc.Account_Manager__c;// added by Kruti bhusan Mohanty
                        }// added by Kruti
                        //set_accIds.add(acc.Id);//comment by yinfeng.guo
                    }
                }
                //Copy value of formula field "Account_Type__c" into standard "Type" field.
                if(acc.RecordTypeId == cisAccountRecordTypeId){
                    acc.Type = acc.Account_Type__c;
                }
            }
         /*if(!map_accId_accManager.isEmpty() && !map_accId_accSalesTerritoryCDE.isEmpty() && !map_accId_salesHierarchyId.isEmpty()){
                system.debug('First method call111:'); 
                //ClsAccountUtil.SetAccManagerAsAccOwner(map_accId_accManager, map_accId_accSalesTerritoryCDE, map_accId_salesHierarchyId, Trigger.new);// commented by Kruti bhusan Mohanty
        }*/
        }
        //If Trigger is update
        else{
            for(Account acc : Trigger.new){
                //for updates only if account manager field changed.
                
                if(
(Trigger.oldMap.get(acc.Id).Account_Manager__c != acc.Account_Manager__c && acc.Account_Manager__c != null && (actualUserProfileId == systemAdminProfileId || actualUserProfileId == integrationAdminProfileId))
||
(acc.OwnerId != acc.Account_Manager__c )
){
                   
                    if(teisAdminUserId != null && acc.Account_Manager__c == teisAdminUserId){//if Account_Manager__c = teisAdminUserId --> teisAdminUserId user Id must be set as Account Manager and as Account Owner 
                        acc.OwnerId = teisAdminUserId;
                    }
                    else{
                        //acc.OwnerId = acc.Account_Manager__c; comment by yinfeng.guo
                        //System.debug(acc.Account_Manager__c + ' ' + acc.Account_Manager__r.ProfileId + ' ' + integrationAdminProfileId);
                        map_accId_accSalesTerritoryCDE.put(acc.Id, acc.SALES_TERRITORY_CDE__c);//add by yinfeng.guo
                        if(acc.Account_Manager__c != null){
                        acc.OwnerId = acc.Account_Manager__c;// added by Kruti bhusan Mohanty
                        }// added kruti
                        map_accId_accManager.put(acc.Id, acc.Account_Manager__c);
                        if(acc.Sales_Hierarchy__c != null && String.ValueOf(acc.Sales_Hierarchy__c) != '') map_accId_salesHierarchyId.put(acc.Id, acc.Sales_Hierarchy__c);//add by yinfeng.guo
                    }
                }
            }
            
            /*if(!map_accId_accManager.isEmpty() && !map_accId_accSalesTerritoryCDE.isEmpty() && !map_accId_salesHierarchyId.isEmpty()){
                system.debug('Second method call222:'); 
                //ClsAccountUtil.SetAccManagerAsAccOwner(map_accId_accManager, map_accId_accSalesTerritoryCDE, map_accId_salesHierarchyId , Trigger.new); Commented by Kruti bhusan Mohanty
        }*/
        }       
    }   
    //************************* END Before Trigger ************************************************
    
    
    

    //************************* BEGIN After Trigger *********************************************** 
    //if(Trigger.isAfter && !set_accIds.isEmpty()){ //comment by yinfeng.guo : for Di.Chen to write test class, here need to modify some code and below
    if(Trigger.isAfter){
        
        System.debug('************************* ' + triggerName + ': After Trigger *************');
        
        /*added by yinfeng.guo*/
        for(Account acc : Trigger.new){
            if(acc.Account_Manager__c != null && (actualUserProfileId == systemAdminProfileId || actualUserProfileId == integrationAdminProfileId)){
                set_accIds.add(acc.Id);
            }
        }
        /*added by yinfeng.guo*/
        
        if(!set_accIds.isEmpty()){//this line added by yinfeng.guo
            for(Account acc : [Select Id, Account_Manager__c, Account_Manager__r.IsActive From Account Where Id in :set_accIds And Account_Manager__r.IsActive = true]){
                //if(acc.Account_Manager__r.IsActive == true){//this line added by yinfeng.guo 06/06/2012    //--code optimized-case901452--//
                    AccountTeamMember atm = new AccountTeamMember();
                    atm.AccountId = acc.Id;
                    atm.UserId = acc.Account_Manager__c;
                    atm.TeamMemberRole = 'Account Manager (AM)';
                    atm.CaseAccessLevel = 'Read';//Added by Rajendra for case 829400 
                    list_atms2Insert.add(atm);  
                //}//this line added by yinfeng.guo 06/06/2012
            }   
        }//this line added by yinfeng.guo
        
                
        if(!list_atms2Insert.isEmpty()){
        //try{
            insert list_atms2Insert;
            //} catch(Exception e){
               // system.debug('++++++++++++++++++++++++++++++++++'+e);
            //}
        }
    }   
    //************************* END After Trigger ************************************************* 
        

    
    /*if(Trigger.isAfter && !map_accId_accManager.isEmpty()){
        for(AccountTeamMember atm : [Select AccountId, UserId From AccountTeamMember Where AccountId in :map_accId_accManager.keySet() and TeamMemberRole = 'Account Manager (AM)']){
            atm.UserId = map_accId_accManager.get(atm.AccountId);
            
            list_atms2Update.add(atm);
        }
        
        if(!list_atms2Update.isEmpty()){
            update list_atms2Update;
        }
    }*/
    
    //added by nelson zheng 10/13/2015
    if(Trigger.isUpdate && Trigger.isAfter){
        Map<Id,Id> newAMIdMap = new Map<Id,Id>();
        Map<Id,Id> oldAMIdMap = new Map<Id,Id>();
        for(Account a : Trigger.new){
            if(a.Account_Manager__c != Trigger.oldMap.get(a.Id).Account_Manager__c){
                if(a.Account_Manager__c != null){
                    newAMIdMap.put(a.Id,a.Account_Manager__c);
                }
                
                if(Trigger.oldMap.get(a.Id).Account_Manager__c != null){
                    oldAMIdMap.put(Trigger.oldMap.get(a.Id).Id,Trigger.oldMap.get(a.Id).Account_Manager__c);
                }
            }
        }
        
        SharingUtils.updateOppyTeamWhenAccountAMChanged(newAMIdMap,oldAMIdMap);
        
    }
}