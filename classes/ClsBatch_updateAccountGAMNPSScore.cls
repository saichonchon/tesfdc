/** 
*    batch class for NPS_Score__c of Account object
*
@author Lili Zhao
@created 2013-09-23 
@version 1.0
@since 26.0 (Force.com ApiVersion)
*
@changelog
* 2013-09-23 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
global class ClsBatch_updateAccountGAMNPSScore implements Database.Batchable<sObject>{

    public String query;
    public String filter;
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        if(query == null || query == ''){
            query = 'SELECT NPS_Score__c, Id, GAMCD__c, Type FROM Account WHERE GAMCD__c != null and Type = \'Global Account\'';
        }
        if(filter != null) query += filter;
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<Account> list_accounts){
    
        set<String> set_gamcd = new set<String>();
        
        for(Account account : list_accounts){
            set_gamcd.add(account.GAMCD__c);
        }
        ClsContactUtil.calculateAllAccountGAMNPSScoreOnContact(set_gamcd);
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}