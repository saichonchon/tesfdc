/** 
*    batch class for NPS_Score__c of Account object
*
@author Lili Zhao
@created 2013-11-28 
@version 1.0
@since 27.0 (Force.com ApiVersion)
*
@changelog
* 2013-11-28 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
global class ClsBatch_UpdateAccountField implements Database.Batchable<sObject>{
    public String query;
    public String filter;
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        if(query == null || query == ''){
            //query = 'Select Id, NPS_Score__c,AccountId From Contact';
            query = 'SELECT  IND_KAM_Code__c, IND_Forecasting_Workflow_Timestamp__c, RecordTypeId, Id, IND_RSM_Forecast_Category__c, GAMCD__c, IND_Customer_Classification__c, Territory_L2_Code__c, LAYER2_ORGANIZATION_ID__c, LAYER3_ORGANIZATION_ID__c, IND_Billing_Region__c, Company_Reporting_Org__c, BillingCountry, INDUSTRY_BUSINESS_CDE__c, RecordType.DeveloperName, Customer_Region__c  FROM Account ';
        }
        if(filter != null) query += filter;
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, list<Account> list_accounts){        
        // ClsAccountUtil.updateAccountField(list_accounts);  // add lili 2013.12.03
        // add lili 2013.12.03 begin
        for(Account acc : list_accounts) {
        	acc.IND_Forecasting_Workflow_Timestamp__c = DateTime.now();
        	system.debug('acc.IND_Forecasting_Workflow_Timestamp__c++++'+acc.IND_Forecasting_Workflow_Timestamp__c);
        }
        ClsSharingUtil.TriggerRecursionDefense = true;
		Database.update(list_accounts, false);
        // add lili 2013.12.03 end workflow changed
    }
    global void finish(Database.BatchableContext BC){
        
    }
}