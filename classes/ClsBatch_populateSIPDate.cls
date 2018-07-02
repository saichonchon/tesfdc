/** 
*    batch class for SIP date
*
@author Lili Zhao
@created 2013-11-11 
@version 1.0
@since 27.0 (Force.com ApiVersion)
*
@changelog
* 2013-11-11 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
global class ClsBatch_populateSIPDate implements Database.Batchable<sObject>{
	public String query;
    public String filter;
    public set<Id> set_loadStatus;
    list<SIP__c> list_sipPopulateBillings = new list<SIP__c>(); 
    list<SIP__c> list_sipPopulateOpportunityData = new list<SIP__c>(); 
    set<String> set_AMCodes = new set<String>();
    set<String> set_FECodes = new set<String>();
    set<String> set_GAMCodes = new set<String>();
    map<Id,set<String>> map_sipId_set_amCode = new map<Id,set<String>>();
    map<Id,set<String>> map_sipId_set_feCode = new map<Id,set<String>>();   
    map<Id,set<String>> map_sipId_set_gamCode = new map<Id,set<String>>();
    map<String, set<String>> map_sipId_set_profitCtrs4GAM = new map<String, set<String>>(); 
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        if(query == null || query == ''){            
            query = 'Select Id, AM_codes__c, Conversion_result__c, Pipeline_Result__c, Profit_Center_Codes__c, FE_codes__c,Exclude_From_Automatic_Update__c, GAM_codes__c, Prev_Year_1__c, Prev_Year_1_POS_Result__c, Plan_Year__c,Prev_Year_YTD_Direct_billings__c, Prev_Year_YTD_POS__c, Current_Year_Direct_Bill_YTD__c, Plan_Participant__c, Current_Year_POS_Bill_YTD__c, Prev_Year_Pipeline_YTD_Result_Dollar__c, Prev_Year_Conversion_YTD_Result_Dollar__c,RecordType.DeveloperName From SIP__c where Exclude_From_Automatic_Update__c != true ';
        }
        if(set_loadStatus != null && !set_loadStatus.isEmpty()) {
        	query += ' And ( Load_Status_Monthly_Direct__c IN : set_loadStatus OR Load_Status_Record_Indirect__c IN : set_loadStatus) ';
        }
        if(filter != null) query += filter;
        //system.debug('query:::'+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<SIP__c> list_sips){ 
    	//system.debug('list_sips batch:::'+list_sips);   	
    	ClsSIPUitl.recalcBillingAndOppyData(list_sips, list_sipPopulateOpportunityData, list_sipPopulateBillings, set_AMCodes, set_FECodes, set_GAMCodes, map_sipId_set_amCode, map_sipId_set_feCode, map_sipId_set_gamCode, map_sipId_set_profitCtrs4GAM);    		    			   	
    }      
    
    global void finish(Database.BatchableContext BC){
    	
    }
        
}