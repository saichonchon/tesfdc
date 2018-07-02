/***********************************************************************************************************************
Name: ClsBatch_Del_DbbbOnMonthChange  
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S
========================================================================================================================
Purpose: Delete the DailbBBB over month Change  
Modified: Removed the billing and booking amount criteria from query                                                
========================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR            DATE           DETAIL                                            User Story#
------------------------------------------------------------------------------------------------------------------------
1.0     Toshi             12/10/2013     Initial Development                               R-1242               
1.1     Shantinath        05/09/2014     Enhancement in Query                              R-1242
1.2 	Harsh			  30/01/2015	 Added order by in query 						   Case - 792581
***********************************************************************************************************************/    
global class ClsBatch_Del_DbbbOnMonthChange implements Database.Batchable<SObject>, Database.Stateful{       
    global String query;
    global Date vFiscalStartDate;
    
 /*_____________________________________________________________________________________________________________________
    | Purpose : Start                                                                                                     |
    |_____________________________________________________________________________________________________________________|
    | Input Parameter  :  Query String                                                                                                |
    |_____________________________________________________________________________________________________________________|
    |  I1. Name        : Batchable Context                                                                                | 
    |      Data Type   : Database.BatchableContext                                                                        | 
    |      Description :                                                                                                  |
    |_____________________________________________________________________________________________________________________| 
    | Output Parameter : List of DailyBBB records returned by Query                                                                                              
     ______________________________________________________________________________________________________________________*/                                                                                         
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        Period vPeriod = [SELECT StartDate, EndDate 
                            FROM Period 
                           WHERE Type = 'Month' 
                             AND StartDate <= TODAY 
                             AND EndDate >= TODAY]; 
                                                 
        //vFisaclStartDate = vPeriod.StartDate.addDays(2);
        vFiscalStartDate = vPeriod.StartDate;
        query = 'SELECT Id, Backlog_Amount_USD__c, Transaction_Date__c FROM BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ' +
               +'WHERE Transaction_Date__c <: vFiscalStartDate '+
               +'AND Backlog_Amount_USD__c != 0 order by Customer__c, Part__c';

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
    | Input Parameter  :  List of DailyBBB records returned by Start() method                                                                                                
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
         //   AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =: info.getJobId()];
            
        // Send an email to the Apex job's submitter notifying of job completion. 
        /*   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           String[] toAddresses = new String[] {'toshi.darode@zensar.in'};
           mail.setToAddresses(toAddresses);
           mail.setSubject('Apex Sharing Recalculation ' + a.Status);
           mail.setPlainTextBody('The batch Apex job ClsBatch_Del_DbbbOnMonthChange processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
           Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
    } 
    

}