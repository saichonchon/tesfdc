/** 
*    batch class for BBB_Month_Bill_Book_Cust__c
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
global class ClsBatch_UpdateBBBMonthBillBookCustField implements Database.Batchable<sObject>{
    public String query;
    public String filter;
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        if(query == null || query == ''){
            query = 'SELECT SAP_Profit_Center_Code__c,Id,IND_Profit_Workflow_Timestamp__c,IND_Profit_Centre_Groups__c  FROM BBB_Month_Bill_Book_Cust__c ';
        }
        if(filter != null) query += filter;
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, list<BBB_Month_Bill_Book_Cust__c > list_BBBMonthBills){        
       for(BBB_Month_Bill_Book_Cust__c  BBBMonthBill : list_BBBMonthBills) {
           BBBMonthBill.IND_Profit_Workflow_Timestamp__c = DateTime.now();
       }
       Database.update(list_BBBMonthBills, false);
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}