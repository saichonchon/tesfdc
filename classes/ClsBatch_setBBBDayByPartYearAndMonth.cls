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
global class ClsBatch_setBBBDayByPartYearAndMonth implements Database.Batchable<sObject>{

    public String query;
    public String filter;
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        if(query == null || query == ''){
            query = 'SELECT Customer_Request_Date_Fiscal_Month__c, Customer_Request_Date_Fiscal_Year__c, Customer_Request_Date__c FROM BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c WHERE Customer_Request_Date__c != null and Customer_Request_Date_Fiscal_Month__c = null and Customer_Request_Date_Fiscal_Year__c = null ';
        }
        if(filter != null) query += filter;
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c> list_bbbDayBillBookBklgCustPNs){
    
        Date StartDate;
        Date EndDate;
        
        for(BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c bbbDayBillBookBklgCustPN : list_bbbDayBillBookBklgCustPNs){
            if(StartDate == null || EndDate == null ) {
                StartDate = bbbDayBillBookBklgCustPN.Customer_Request_Date__c;
                EndDate = bbbDayBillBookBklgCustPN.Customer_Request_Date__c;
            }else{
                if(StartDate < bbbDayBillBookBklgCustPN.Customer_Request_Date__c) {
                    StartDate = bbbDayBillBookBklgCustPN.Customer_Request_Date__c;
                }
                if(EndDate > bbbDayBillBookBklgCustPN.Customer_Request_Date__c) {
                    EndDate = bbbDayBillBookBklgCustPN.Customer_Request_Date__c;
                }
            }
        }
        //system.debug('StartDate::::'+StartDate + '::::EndDate:: ' + EndDate);
        ClsDailyBookingBillingBacklogByPartsUtil.setBbbDayBillBookBklgCustPNYearAndMonth(list_bbbDayBillBookBklgCustPNs, StartDate, EndDate, true);
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}