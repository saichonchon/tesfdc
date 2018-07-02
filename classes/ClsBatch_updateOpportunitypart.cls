/** 
*    batch class for Opportunity_part__c
*
@author Xiaona Liu
@created 2013-06-17 
@version 1.0
@since 26.0 (Force.com ApiVersion)
*
@changelog
* 2013-06-17 Xiaona Liu <xiaona.liu@itbconsult.com>
* - Created
@changelog
* 2013-08-28 Nooreen Shaikh <nooreen.i@zensar.in>
* - Modified for R-1216
*/
global class ClsBatch_updateOpportunitypart implements Database.Batchable<sObject>, Database.stateful {
    public String query;
    public static String filter = '';
    global list<String> list_errorInfos = new list<String>();
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        if(query == null || query == ''){
            query = 'select Id,Name,CBC5_Code__c,BU_profit_center__c,Account_IBC_code__c,Distributor__c,Customer_Industry__c,SAP_Profit_Center_Short_Desc_Filter__c from Opportunity_Part__c';
        }
        /*if(Test.isRunningTest()) { 
            filter = ' limit 1'; 
            query += filter; }    */     
        return Database.getQueryLocator(query+filter);
    }
    
    global void execute(Database.BatchableContext BC, list<Opportunity_Part__c> list_oppParts){
        ClsOppyPartUtil.allocateBUProfitCenter(list_oppParts);
        //Database.update(list_oppParts,false);
        CSD_Utils_Class.canCallBatch = false; //Added to avoid calling the batch from mentioned class. 
        
        Database.SaveResult[] srList = Database.update(list_oppParts,false);        
        for(Database.SaveResult sr : srList) {
            if(sr.isSuccess()) {              
                System.debug('Successfully updated record--- ' +sr.getId());
            }
            else {
                    for(Database.Error err : sr.getErrors()) {   
                        String errorInfo = '';
                        errorInfo += 'Record Id: ' + sr.getId() + ' \n ';             
                        errorInfo += 'Errors: '+ err.getStatusCode() + ' : ' + err.getMessage() + ' \n ';             
                        errorInfo += 'Fields affecting this error: ' + err.getFields() + '\n\n';
    
                        list_errorInfos.add(errorInfo);             
                        System.debug('**Errors** '+ err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Fields affecting this error: ' + err.getFields());
                }
            }
        }
    }
    
    global void finish(Database.BatchableContext BC){        
        //Cls_batchUtil.errorReportForBatch(list_errorInfos, 'Batch job: ClsBatch_updateOpportunitypart is finished'); 
    }
}