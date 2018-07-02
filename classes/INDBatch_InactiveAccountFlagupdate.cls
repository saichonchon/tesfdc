/** 
*    batch class for marking inactive account records for deletion
*
@author Deepak Kumar (deepak.kumar89@te.com)
@created 22nd April 2015 
@version 1.0
@since 30.0 (Force.com ApiVersion)
*


*/
global class INDBatch_InactiveAccountFlagupdate implements Database.Batchable<sObject>, Database.stateful{
   public String query;   
   //List<account> Acct_Passed = new List<account>(); //Storing Accounts from previous batch
  Set<id> Acct_Id_for_nextcheckbillings=new set<id>(); // Account id passed from the previous batch and also containing the total id after checking the monthly records from all the batches for passing to next batch.
  List<account> finalAcct_Passed = new List<account>();
  // ************************************************* start of Controller Class *************************************************************************
  global INDBatch_InactiveAccountFlagupdate(List<Account> listPassedAccounts)
    {
       // Acct_Passed =new List<account>(listPassedAccounts);
        for(account a:listPassedAccounts)
        {
        
         Acct_Id_for_nextcheckbillings.add(a.id); // adding Account id from current batch. and also contains id from previous batch to pass to next batch after process.
        }
    }
    
 // ************************************************* End of Controller Class *************************************************************************
 
// Quering for the accounts here with accounts whose status is inactive and prospect accounts(here not checking for inactive status, please see the where condition)
      
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        if(query == null || query == ''){            
            query = 'Select id,Inactive_Account_Marked_for_Delete__c '
                + ' From account '
                + ' where Id IN :Acct_Id_for_nextcheckbillings';
               
        }
        // Added by Mrunal for Test Class 'INDBatch_InactiveAccountFlag_Test'
       if(Test.isRunningTest()) 
                query += ' LIMIT 2'; 
        // Change end by Mrunal        
       return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<account> list_acc){ 
      
       finalAcct_Passed = new List<account>();
       for(account aa: list_acc)
       {
          aa.Inactive_Account_Marked_for_Delete__c =true;
           finalAcct_Passed.add(aa);          
       }
      
            
     
      update finalAcct_Passed;
    }      
  
    global void finish(Database.BatchableContext BC){
    
     
      
    }
}