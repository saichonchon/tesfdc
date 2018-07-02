public class AccountBTerritoryUtil {
    
    //Prabhanjan N: 2016-10-24
    // setting up variables for B-territory logic
    
    /*
-------------------------------------------------------------------------------------------------------------------------------------
| Purpose : This method returns the level7 user Id based on the territory codes by querying Sales Hierarchy in a map  |
-------------------------------------------------------------------------------------------------------------------------------------
*/ 
    public static map<string,string> UserNetworkIdMap;
    public static map<string,Id> getLevel7UserfromSalesHierarchy(set<string> TerrCodes){      
        try{
            map<string,string> terrToUser7 = new map<string,string>();
            UserNetworkIdMap = new map<string,string>();
            for(Sales_Hierarchy__c SH: [SELECT Id,Level_7_Default_Owner__c,Level_7_Default_Owner__r.TE_Network_Id__c,Level_7_Territory_Code__c FROM Sales_Hierarchy__c WHERE Level_7_Territory_Code__c in: TerrCodes]){
                if(SH.Level_7_Default_Owner__c!=null) terrToUser7.put(SH.Level_7_Territory_Code__c, SH.Level_7_Default_Owner__c);
                UserNetworkIdMap.put(SH.Level_7_Default_Owner__c,SH.Level_7_Default_Owner__r.TE_Network_Id__c);
            }
            return terrToUser7;
        }
        catch(exception e){
            system.debug(e.getMessage()+' at '+ e.getStackTraceString());
            return  new map<string,string>();
        }
    }
    
    //Prabhanjan N: 2016-10-24
    // setting up variables for B-territory logic
    
    /*
-------------------------------------------------------------------------------------------------------------------------------------
| Purpose : This method inserts the SFDC users based on the territorries in B-territory field...    Level_7_Assigned_User_Network_Ids__c                                 |
-------------------------------------------------------------------------------------------------------------------------------------
*/ 
    public static void insertAccountTeamB_Terr(map<Id, list<string>> AccIdToTerrCodes, map<string ,string> terrToUser7,map<Id, string> AccIdToCusKey){      
        try{
            list<Account_team__c> accTeamLst = new list<Account_team__c>();
            for(string accId: AccIdToTerrCodes.keySet()){
                for(string terrCode: AccIdToTerrCodes.get(accId)){
                    string TEnetworkId = '';
                    string role = 'ADM Sales Team (B-Territory)';
                    if(UserNetworkIdMap.containsKey(terrToUser7.get(terrCode)))  TEnetworkId =UserNetworkIdMap.get(terrToUser7.get(terrCode));
                    string teamkey = AccIdToCusKey.get(accId)+role+TEnetworkId;
                    accTeamLst.add(new Account_team__c( 
                        Account__c = accId,
                        Opportunity_Access__c = 'Edit',
                        Role__c=role,
                        TE_Network_Id__c = TEnetworkId,
                        Team_Member__c=terrToUser7.get(terrCode),
                        Team_Member_Key__c = teamkey,
                        recordTypeId = Apex_Helper_Settings__c.getInstance('Account Team User Record Type Id').value__c
                    ));
                }
            }
            if(accTeamLst.size()>0) insert accTeamLst;
        }
        catch (exception e){ system.debug(e.getMessage()+' at '+ e.getStackTraceString());  }
    }
    
    /*
-------------------------------------------------------------------------------------------------------------------------------------
| Purpose : This method deletes the SFDC users based on the territorries in B-territory field...                                     |
-------------------------------------------------------------------------------------------------------------------------------------
*/ 
    public static void deleteAccountTeamB_Terr(map<Id, list<string>> AccIdToTerrCodes_del, map<string ,string> terrToUser7){      
        try{
            list<Account_team__c> accTeamLst = new list<Account_team__c>([select id,account__c,Team_Member__c from Account_team__c 
                                                                          where account__c in :AccIdToTerrCodes_del.keySet()]);
            list<Account_team__c> accTeamLst_del = new list<Account_team__c>();
            map<Id, list<string>> AccIdToTerrCodes_del2 = new map<Id, list<string>> (); 
            for(string accId: AccIdToTerrCodes_del.keySet()){
                for(string terrCode: AccIdToTerrCodes_del.get(accId)){ 
                    if(!AccIdToTerrCodes_del2.containsKey(accId)) AccIdToTerrCodes_del2.put(accId, new list<string>());
                    AccIdToTerrCodes_del2.get(accId).add(terrToUser7.get(terrCode));  
                }
            }
            
            for(Account_team__c at: accTeamLst){
                set<string> teamids = new set<string>();
                teamids.addAll(AccIdToTerrCodes_del2.get(at.Account__c));
                if(teamids.contains(at.Team_Member__c)) accTeamLst_del.add(at);
            }
            
            if(accTeamLst_del.size()>0) delete accTeamLst_del;
        }
        
        catch (exception e){  system.debug(e.getMessage()+' at '+ e.getStackTraceString()); }
    } //Prabhanjan N: 2016-10-24  end of deleteAccountTeamB_Terr//
    
    /* End of B-terrotory logic -------------------------------------------------------------------------------------------------------------------------------*/
    
}