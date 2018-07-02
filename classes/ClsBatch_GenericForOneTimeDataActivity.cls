/** 
*    
*    General batch class for any functionality to perform one time data activity where the data update/Insert/Delete by anonymous code block 
*    or data loader is not possible. Just Change the Query and execute functionality in this batch as per the requirement and do the data activity.
*
*
@author Mrunal Parate
@created 2014-11-19 
@version 1.0
@since 26.0 (Force.com ApiVersion)
*
*/
global class ClsBatch_GenericForOneTimeDataActivity implements Database.Batchable<SObject>{
    public String query;
    global Database.QueryLocator start(Database.BatchableContext BC){
        if(query == null || query == '')
            query = 'Select Id from BBB_Year_Bill_Book_Cust_PN__c where Year__c = \'2014\' order by Customer__c, Part__c';
        return Database.getQueryLocator(query);  
    }
    global void execute(Database.BatchableContext BC, List<BBB_Year_Bill_Book_Cust_PN__c> scope){        
        if(scope != null && scope.size() > 0){
            delete scope;
            Database.emptyRecycleBin(scope);
        }
    }
     global void finish(Database.BatchableContext info){
            AsyncApexJob Apexjob = [SELECT Id, Status,MethodName, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =: info.getJobId()];
    
            // Send an email to the Apex job's submitter notifying of job completion. 
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSaveAsActivity(false);
            mail.setTargetObjectId(Userinfo.getuserId());
            mail.setSubject('Yearly BBB Delete ' + Apexjob.Status);
            mail.setPlainTextBody('"ClsBatch_GenericForOneTimeDataActivity"  Apex job processed ' + Apexjob.TotalJobItems + ' batches with '+ Apexjob.NumberOfErrors + ' Errors.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
     }
 }