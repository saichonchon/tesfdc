global class ClsBatch_DeleteObsoleteYearlySales implements Database.Batchable<SObject>, Database.Stateful{       

    global Database.QueryLocator start(Database.BatchableContext BC){
       
        String query = 'SELECT Id FROM BBB_Year_Bill_Book_Cust_PN__c where isDeleted=false AND Obsolete__c=true order by Customer__c';
        
        if(Test.isRunningTest()) query += ' LIMIT 1';
        
        return Database.getQueryLocator(query);     
    }
    
   
    global void execute(Database.BatchableContext BC, list<BBB_Year_Bill_Book_Cust_PN__c> list_BBB){
        if(list_BBB != null && list_BBB.size()>0) {
            delete list_BBB;
            Database.emptyRecycleBin(list_BBB);
        }
    }
    
  
    global void finish(Database.BatchableContext info) {
      // Query the AsyncApexJob object to retrieve the current job's information. 
            AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =: info.getJobId()];
            
        // Send an email to the Apex job's submitter notifying of job completion. 
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           String[] toAddresses = new String[] {'crmsupport@te.com'};
           mail.setToAddresses(toAddresses);
           mail.setSubject('Yearly BBB Delete ' + a.Status);
           mail.setPlainTextBody('The batch Apex job for Yearly BBB Delete processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
        
        if(!test.isRunningTest()) { 
           Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } 
    } 
    

}