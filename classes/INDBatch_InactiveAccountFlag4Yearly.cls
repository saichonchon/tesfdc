/** 
*    batch class for marking inactive account records for deletion
*
@author Deepak Kumar (deepak.kumar89@te.com)
@created 22nd April 2015 
@version 1.0
@since 30.0 (Force.com ApiVersion)
*


*/
global class INDBatch_InactiveAccountFlag4Yearly implements Database.Batchable<sObject>, Database.stateful{
   public String query;
  Public Map<id,account> map_idfinal = new Map<id,account>(); // map used for checking monthly records.
 
  Set<id> Acct_Id_for_nextcheckbillings=new set<id>(); // Account id passed from the previous batch and also containing the total id after checking the monthly records from all the batches for passing to next batch.
  List<account> finalAcct_Passed = new List<account>();
  
   Public Map<id,id> map_id = new Map<id,id>(); 
 // ************************************************* start of Controller Class *************************************************************************
  global INDBatch_InactiveAccountFlag4Yearly (List<Account> listPassedAccounts)
    {
        //Acct_Passed =new List<account>(listPassedAccounts);
        for(account a:listPassedAccounts)
        {
         map_idfinal.put(a.id,a);
         map_id.put(a.id,a.id);
         Acct_Id_for_nextcheckbillings.add(a.id); // adding Account id from current batch. and also contains id from previous batch to pass to next batch after process.
        }
    }
    
 // ************************************************* End of Controller Class *************************************************************************
 
// Quering for the accounts here with accounts whose status is inactive and prospect accounts(here not checking for inactive status, please see the where condition)
      
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        if(query == null || query == ''){            
            query = 'Select id,Customer__c,Customer__r.id,Reseller_Customer__r.id '
                + ' From BBB_Year_Bill_Book_Cust_PN__c '
                + ' where Customer__c IN :Acct_Id_for_nextcheckbillings';
               
        }
        // Added by Mrunal for Test Class 'INDBatch_InactiveAccountFlag_Test'
       if(Test.isRunningTest()) 
                query += ' LIMIT 2'; 
        // Change end by Mrunal        
       return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<BBB_Year_Bill_Book_Cust_PN__c> list_bbb){ 
      
     
  //************* Start of Code to check the Case records for the accounts which have no non billing Child records***************************************************************           
    
      
       for(BBB_Year_Bill_Book_Cust_PN__c caseaa: list_bbb)
       {
          if(caseaa.Customer__c == map_id.get(caseaa.Customer__r.id) || caseaa.Reseller_Customer__r.id == map_id.get(caseaa.Customer__r.id))
            {
            
             map_idfinal.remove(caseaa.Customer__r.id);
            
            }
       } 
        
        
    }      
       
      
    
    global void finish(Database.BatchableContext BC){
        for(account a:map_idfinal.values())
      {
      
      finalAcct_Passed.add(a);
      }
      Database.executeBatch(new INDBatch_InactiveAccountFlagupdate(finalAcct_Passed),200);
     
      
    }
}