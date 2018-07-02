global class INDBatch_InactiveAccountFlag4deliveryPer implements Database.Batchable<sObject>,Database.stateful{
  public String query;
  Public Map<id,account> map_idfinal = new Map<id,account>(); // map used for checking monthly records.
  Set<id> Acct_Id_for_nextcheckdelperf=new set<id>(); // Account id passed from the previous batch and also containing the total id after checking the monthly records from all the batches for passing to next batch.
  List<account> finalAcct_Passed = new List<account>();
  
  Public Map<id,id> map_id = new Map<id,id>(); 
 // ************************************************* start of Controller Class *************************************************************************
  global INDBatch_InactiveAccountFlag4deliveryPer(List<Account> listPassedAccounts)
    {
       
        for(account a:listPassedAccounts)
        {
         map_idfinal.put(a.id,a);
         map_id.put(a.id,a.id);
         Acct_Id_for_nextcheckdelperf.add(a.id); // adding Account id from current batch. and also contains id from previous batch to pass to next batch after process.
          
        }
    }
    
 // ************************************************* End of Controller Class *************************************************************************
 
// Quering for the accounts here with accounts whose status is inactive and prospect accounts(here not checking for inactive status, please see the where condition)
      
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        if(query == null || query == ''){            
            query = 'Select Id,Account__c,Account__r.id'
                + ' From Delivery_Performance__c '
                + ' where Account__r.id IN :Acct_Id_for_nextcheckdelperf';
               
        }
        // Added by Mrunal for Test Class 'INDBatch_InactiveAccountFlag_Test'
       if(Test.isRunningTest()) 
                query += ' LIMIT 2'; 
        // Change end by Mrunal        
       return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<Delivery_Performance__c> list_DElperf){ 
   
     
    //System.Debug('################################################## the value of Acct_Id_for_nextcheckdelperf is ' + Acct_Id_for_nextcheckdelperf.size());    
      for(Delivery_Performance__c caseaa: list_DElperf)
       {
         if(caseaa.Account__r.id == map_id.get(caseaa.Account__r.id))
            {
           
             map_idfinal.remove(caseaa.Account__r.id);
             
            }
       } 
        
    }
 
 //******************************************************************** End of code to mark the account for deletion*****************************************************************************          
  
    
    global void finish(Database.BatchableContext BC){
      
      for(account a:map_idfinal.values())
      {
       finalAcct_Passed.add(a);
      }
      Database.executeBatch(new INDBatch_InactiveAccountFlag4Monthly(finalAcct_Passed),200);
   
    
    }
}