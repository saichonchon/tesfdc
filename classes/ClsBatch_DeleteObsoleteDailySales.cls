global class ClsBatch_DeleteObsoleteDailySales implements Database.Batchable<SObject>, Database.Stateful{       

    global Database.QueryLocator start(Database.BatchableContext BC){
       
        String query = 'SELECT Id FROM BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c where isDeleted=false AND Obsolete__c=true order by Customer__c';
        return Database.getQueryLocator(query);     
    }
    
   
    global void execute(Database.BatchableContext BC, list<BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c> list_BBB){
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
           mail.setSubject('Daily BBB Delete ' + a.Status);
           mail.setPlainTextBody('The batch Apex job for Daily BBB Delete processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
        
        if(!test.isRunningTest()) { 
           Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    } 
    

}