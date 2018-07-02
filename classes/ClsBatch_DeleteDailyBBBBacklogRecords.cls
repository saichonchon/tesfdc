/***********************************************************************************************************************
Name: ClsBatch_DeleteDailyBBBBacklogRecords
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S
========================================================================================================================
Purpose: Delete the DailyBBB Backlog Records(By Keeping the DailyBBB Backlog records of last 4 months into the system)                                                  
========================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
1.0    Toshi            07/16/2013     Initial Development
2.0 Harinath Reddy      10/21/2014     Added Order BY Caluse to the Queries to minimize the row locks                                
***********************************************************************************************************************/
global class ClsBatch_DeleteDailyBBBBacklogRecords implements Database.Batchable<SObject>, Database.Stateful{    
    /**     
    * the email address to tell people the status of the batch class after run the batch class     
    * before run the batch class, we can define the email manual     
    * if not define email address, after the batch completed, will not send email     
    */     
    public String email;    
    /**     
    * the sql query statement that will select the data will be used in this batch class     
    */
            
    global String query;
    global Date StartDate;
    global Date today;
    public ClsBatch_DeleteDailyBBBBacklogRecords(){
        //CREATE THE QUERY IF THE CUSTOM SETTING HAVE SOME VALUE IN IT
        Daily_Backlog_Cleanup__c vConfig =  Daily_Backlog_Cleanup__c.getValues('Default');
        if(vConfig != NULL && (vConfig.Months_To_Keep_DailyBBB_Backlog_Records__c != NULL)){
            integer MonthToKeepData = Math.round(vConfig.Months_To_Keep_DailyBBB_Backlog_Records__c);
            Date DateBeforeMonth;
            today = System.Today();
            DateBeforeMonth = today.addMonths(-MonthToKeepData); 
            StartDate= date.newinstance(DateBeforeMonth.year(),DateBeforeMonth.month(),1);
            query = 'SELECT Id, Backlog_Amount_USD__c, Transaction_Date__c FROM BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c WHERE Transaction_Date__c <: StartDate ORDER BY Customer__c , Part__c';
            System.debug('-----Constrter Query---------'+query);
       }
    }    
    
    /*_____________________________________________________________________________________________________________________
    | Purpose : Start                                                                                                     |
    |_____________________________________________________________________________________________________________________|
    | Input Parameter  :  Query String                                                                                                |
    |_____________________________________________________________________________________________________________________|
    |  I1. Name        : Batchable Context                                                                                | 
    |      Data Type   : Database.BatchableContext                                                                        | 
    |      Description :                                                                                                  |
    |_____________________________________________________________________________________________________________________| 
    | Output Parameter : List of DailyBBB records returned by Qyery                                                                                              
     ______________________________________________________________________________________________________________________*/                                                                                         
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        // USE STANDARD VALUE IF CUSTOM SETTING IS NULL
        if (query == '' || query == null){
             today = System.Today(); Date DateBeforeMonth = today.addMonths(-4); Date DefaultStartDate= date.newinstance(DateBeforeMonth.year(),DateBeforeMonth.month(),1);
             query = 'SELECT Id, Backlog_Amount_USD__c, Transaction_Date__c FROM BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c WHERE Transaction_Date__c <: DefaultStartDate ORDER BY Customer__c , Part__c';
        }
        if(Test.isRunningTest()){
            if (query != '' || query != null){
                query+= ' LIMIT 1';
            }
        }
        return Database.getQueryLocator(query);     
    }
    
    /*_____________________________________________________________________________________________________________________
    | Purpose : Execute                                                                                                   |
    |_____________________________________________________________________________________________________________________|
    | Input Parameter  :  List of DailyBBB records returned by Stsrt() method                                                                                                
    |_____________________________________________________________________________________________________________________|
    |  I1. Name        : List of 'DailyBBB records'                                                                       | 
    |      Data Type   : Database.BatchableContext                                                                        | 
    |      Description : Delete the DailyBBB Backlog records                      |
    |_____________________________________________________________________________________________________________________| 
    | Output Parameter : None                                                                                             |
    |____________________________________________________________________________________________________________________*/ 
    
    global void execute(Database.BatchableContext BC, list<BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c> list_DailyBBBBacklogRecords){
        if(list_DailyBBBBacklogRecords != null && list_DailyBBBBacklogRecords.size()>0) {
           
                     delete list_DailyBBBBacklogRecords;
            Database.emptyRecycleBin(list_DailyBBBBacklogRecords);  
        }
    }
    
    /*_____________________________________________________________________________________________________________________
    | Purpose : Finish and mail the status of the batch class                                                             |
    |_____________________________________________________________________________________________________________________|
    | Input Parameter  :   None                                                                                           |
    |_____________________________________________________________________________________________________________________|
    |  I1. Name        : Batchable Context                                                                                | 
    |      Data Type   : Database.BatchableContext                                                                        | 
    |      Description :                                                                                                  |
    |_____________________________________________________________________________________________________________________| 
    | Output Parameter : None                                                                                             |
    |____________________________________________________________________________________________________________________*/
     
    global void finish(Database.BatchableContext info) {
        
        // Query the AsyncApexJob object to retrieve the current job's information. 
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =: info.getJobId()];
        
    // Send an email to the Apex job's submitter notifying of job completion. 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'toshi.darode@zensar.in'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Apex Sharing Recalculation ' + a.Status);
        mail.setHtmlBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures  ' );
        if(!test.isRunningTest()) {         
           Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }    
    

}