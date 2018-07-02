/***********************************************************************************************************************
      Name : Account_AddSpecialist
       Org : C2S
 Copyright : © 2013 TE Connectivity 
========================================================================================================================
   Summary : Add user as Account Team member when they are added in  Idento Labels Specialist and Relays Application 
             Engineer fields of account with role  Idento Specialist and Relays Specialist resp. 
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE        DETAIL                                            User Story #                  
________________________________________________________________________________________________________________________
   1.0 Mrunal         07/24/2014                                                    R-1113
***********************************************************************************************************************/
    /** Add user as Account Team member when they are added in  Idento Labels Specialist and Relays Application 
        Engineer fields of account with role  Idento Specialist and Relays Specialist resp. **/
    /**
    1. On Insert :: 
        A. AccountUserMap Map is created to map the Idento Labels Specialist and Relays Application Engineer with account which are to be inserted in Account Team. 
        B. AccountSet is created to store set of account id.
    2. On Update :: When old value not equals to new value or old value is not null and new value is null.
        A. AccountUserMap Map is created to map the Idento Labels Specialist and Relays Application Engineer with account which are to be inserted in Account Team. 
        B. AccountSet is created to store set of account id.
        C. deleteUserMap to store the user that should be deleted.
    3. Generate a map of account with its existing account team member.
    4. Store the user to be deleted in the 'deleteAccoutTeamList' List .
    5. Store the User to be added in the 'upsertList' List.
    6. Delete 'deleteAccoutTeamList' List if its not null.
    7. Upsert 'upsertList' List if its not null.
    **/
trigger Account_AddSpecialist on Account (after insert, after update) {

    Map<String,string> accountUserMap = new Map<String,string>();
    List<Account_Team__c> deleteAccoutTeamList= new List<Account_Team__c>();
    List<Account_Team__c> upsertList = new List<Account_Team__c>();
    set<id> accountSet = new Set<Id>();
    Map<String,Id> deleteUserMap = new Map<String,Id>();
    
    List<Specialist_Field__c> mcs = Specialist_Field__c.getall().values();
   
    /* 1. On Insert ::  
        A. AccountUserMap Map is created to map the Idento Labels Specialist and Relays Application Engineer with account which are to be inserted in Account Team. 
        B. AccountSet is created to store set of account id.*/   
   if(trigger.isInsert && trigger.isAfter){
        for(Account actObj: trigger.new){
            for(Specialist_Field__c fld: mcs){
                sObject actObjT = new Account();
                actObjT = actObj;
                if(actObjT.get(fld.API_Name__c) != null){
                    accountUserMap.put(actObj.id+fld.Role__c, fld.Role__c+','+string.valueof(actObjT.get(fld.API_Name__c)));
                    accountSet.add(actObj.id);
                }
            }             
        }
    }
    /*    2. On Update :: When old value not equals to new value or old value is not null and new value is null.
        A. AccountUserMap Map is created to map the Idento Labels Specialist and Relays Application Engineer with account which are to be inserted in Account Team. 
        B. AccountSet is created to store set of account id.
        C. deleteUserMap to store the user that should be deleted.*/
    if(trigger.isUpdate && trigger.isAfter){
        for(Account actObj : trigger.new){
            
            for(Specialist_Field__c fld: mcs){
                sObject actObjTN = new Account();
                sObject actObjTO = new Account();
                actObjTN = actObj;
                actObjTO = trigger.oldmap.get(actObj.Id);
                //When old value not equals to new value
                if(actObjTN.get(fld.API_Name__c) != null && actObjTO.get(fld.API_Name__c) != actObjTN.get(fld.API_Name__c)){
                    accountUserMap.put(actObj.id+fld.Role__c, fld.Role__c+','+string.valueof(actObjTN.get(fld.API_Name__c)));
                    accountSet.add(actObj.id);
                    String vKeyString =  string.valueof(actObjTO.get(fld.API_Name__c))+'_'+actObjTO.Id  +'_'+ fld.Role__c;
                    deleteUserMap.put(vKeyString,actObj.id);
                }
                //old value is not null and new value is null
                if(actObjTN.get(fld.API_Name__c) == null && actObjTO.get(fld.API_Name__c) != null){
                    String vKeyString =string.valueof(actObjTO.get(fld.API_Name__c))+'_'+actObjTO.Id +'_'+ fld.Role__c;               
                    deleteUserMap.put(vKeyString,actObj.id);
                    accountSet.add(actObj.id);
                }
            }
        }
    }
    
    // 3. Generate a map of account with its existing account team member.
    Map<Id,List<Account_Team__c>> accountTeamMap = new Map<Id,List<Account_Team__c>>();
    for(Account_Team__c aTeam: [SELECT Id, Account__c, Team_Member__c, Role__c FROM Account_Team__c WHERE Account__c IN:accountSet]){
        List<Account_Team__c> accTeamList = accountTeamMap.get(aTeam.Account__c);
        if(accTeamList == null)
            accTeamList = new list<Account_Team__c> ();
        accTeamList.add(aTeam);
        accountTeamMap.put(aTeam.Account__c, accTeamList);
    }
    
    //4. Store the user to be deleted in the 'deleteAccoutTeamList' List .    
    for(Id accountId : accountTeamMap.keyset()){
        List<Account_Team__c> teamList= accountTeamMap.get(accountId);

        for(Account_Team__c teamObj: teamList){
            String vKeyTeamRole =  teamObj.Team_Member__c+'_'+teamObj.Account__c +'_'+teamObj.Role__c  ;
            Id deleteaccountId = deleteUserMap.get(vKeyTeamRole);
            if(deleteaccountId !=null && deleteaccountId == teamObj.Account__c){ 
                deleteAccoutTeamList.add(teamObj);
            }
        }
    }
    
    //5. Store the User to be added in the 'upsertList' List.   
    for(Account actObj: trigger.new){
        
        for(String accid: accountUserMap.keyset()){
            if(accid.Contains(actObj.Id)){
            String identoId = accountUserMap.get(accid);          
            String[] parts = identoId.split(',');           
                if(identoId!= null && parts[0] != null && parts[1] != null){
                    Account_Team__c accTeamMember = new Account_Team__c();
                        accTeamMember.Account__c = actObj.Id;
                        accTeamMember.Team_Member__c = parts[1];
                        accTeamMember.Opportunity_Access__c = 'Edit';
                        accTeamMember.Role__c = parts[0];
                        upsertList.add(accTeamMember );
                }
                }
        }
    }
    
    
    //6. Delete 'deleteAccoutTeamList' List if its not null.
    if(deleteAccoutTeamList !=null && deleteAccoutTeamList.size()>0){
        Delete deleteAccoutTeamList; 
    }
    
    //7. Upsert 'upsertList' List if its not null.
    if(upsertList!=null && upsertList.size()>0){
        upsert upsertList;
    }
}