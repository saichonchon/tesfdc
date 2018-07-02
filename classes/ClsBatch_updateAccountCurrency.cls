/** 
*    batch class for Currency__c of Account object
*
@author Lili Zhao
@created 2013-10-14 
@version 1.0
@since 27.0 (Force.com ApiVersion)
*
@changelog
* 2013-10-14 Lili Zhao <lili.zhao@itbconsult.com>
* - Created    
*/

global class ClsBatch_updateAccountCurrency implements Database.Batchable<sObject>{
    public String query;
    public String filter;
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        if(query == null || query == ''){
            query = 'SELECT AccountNumber, Id, CurrencyIsoCode From Account WHERE AccountNumber != null ';
        }
        if(filter != null) query += filter;
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, list<Account> list_accounts){
        ClsAccountUtil.setAccountCurrencyIsoCodeBatch(list_accounts);
    }
    global void finish(Database.BatchableContext BC){   
    	   
    }
}