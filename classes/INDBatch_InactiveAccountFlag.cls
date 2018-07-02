/** 
*    batch class for marking inactive account records for deletion
*
@author Deepak Kumar (deepak.kumar89@te.com)
@created 20th July 2015 
@version 1.0
@since 30.0 (Force.com ApiVersion)
*
 To execute the batch:--- Id batjobId = Database.executeBatch(new INDBatch_InactiveAccountFlag(),50);

*/
global class INDBatch_InactiveAccountFlag implements Database.Batchable<sObject>, Database.stateful{
  public String query;
  Public Map<id,account> map_idfinal = new Map<id,account>();
  Public Set<id> Acct_Id = new set<id>();
 
  Date dt= system.Today()-90;
  List<Account> Acct_for_nextcheck = new List<Account>();
  
 

 
 
// Quering for the accounts here with accounts whose status is inactive and prospect accounts(here not checking for inactive status, please see the where condition)
      
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        
       
        if(query == null || query == ''){            
            query = 'Select Id,Inactive_Account_Marked_for_Delete__c,STATDESC__c,CreatedDate,RecordType.name'
                + ' From Account '
                + ' where Inactive_Account_Marked_for_Delete__c = False AND ((STATDESC__c =\'Not Active\' AND RecordType.Name = \'Account\' ) OR (RecordType.Name = \'Prospect\' ))';
                //+' LIMIT 200';
        }
        // Added by Mrunal for Test Class 'INDBatch_InactiveAccountFlag_Test'
       if(Test.isRunningTest()) 
                query += 'AND Name LIKE \'%test%\' LIMIT 100'; 
        // Change end by Mrunal        
       return Database.getQueryLocator(query);
       

    
    }
    
    global void execute(Database.BatchableContext BC, list<Account> list_Acc){ 
      
  //**********Start of Creeating a map of accounts with ids to use in the checking process and to aces the data faster**********************************   
      Acct_Id=new set<id>();
      for(account a:list_Acc)
      {
       if((date.valueof(a.CreatedDate)<=dt && a.RecordType.Name == 'Prospect') || a.RecordType.Name == 'Account' )
        {
        
        Acct_Id.add(a.id);
        map_idfinal.put(a.id,a);
       // Acct_Id_for_billings.add(a.id);
        //System.Debug('################################################## the value of Acct_Id is ' + Acct_Id.size());
       // System.Debug('################################################## the value of Acct_Id_for_billings is ' + Acct_Id_for_billings.size());
        //System.Debug('################################################## the value of map_idfinal is ' + map_idfinal.size());
        }
      }
    
   //##################################################################################################################################   
     // System.Debug('################################################## the value of Setid is ' + Acct_Id.size());
    //  System.Debug('################################################## the value of MApfinal is ' + map_idfinal.size());
 
 
      for(opportunity opp: [Select id,AccountId from opportunity where AccountId in: Acct_Id])
       {
         map_idfinal.remove(opp.AccountID);
         Acct_Id.remove(opp.AccountID);
           
       }   
       
       for(Contact conta: [Select id,AccountId from Contact where AccountId in: Acct_Id])
       {
         map_idfinal.remove(conta.AccountID);
         Acct_Id.remove(conta.AccountID);
          
       }
     
       
              
       for(OEM_Details__c OEM : [Select id,OEM__c from OEM_Details__c where OEM__c  in: Acct_Id])
       {
         map_idfinal.remove(OEM.OEM__c);
         Acct_Id.remove(OEM.OEM__c);
       }
       
       for(Scheduled_Agreements__c SchA: [Select id,Sold_To_Customer__c from Scheduled_Agreements__c where Sold_To_Customer__c  in: Acct_Id])
       {
        map_idfinal.remove(SchA.Sold_To_Customer__c);
        Acct_Id.remove(SchA.Sold_To_Customer__c);
       }   
       
      
       
       for(Quote__c quote_x : [Select id,Account__c from Quote__c where Account__c  in: Acct_Id])
       {
         map_idfinal.remove(quote_x.Account__c);
         Acct_Id.remove(quote_x.Account__c);
                  
       }
      for(Entitlement Entitlement_x : [Select id, Accountid from Entitlement where Accountid  in: Acct_Id])
       {
       map_idfinal.remove(Entitlement_x.Accountid);
       Acct_Id.remove(Entitlement_x.Accountid);
       }
       
       for(AccountContactRole accontarole : [Select id, Accountid from AccountContactRole where Accountid  in: Acct_Id])
       {
        map_idfinal.remove(accontarole.Accountid);
        Acct_Id.remove(accontarole.Accountid);
       }
   
    
    }      
 //******************************************************************** End of code to mark the account for deletion*****************************************************************************          
  
    global void finish(Database.BatchableContext BC){
        
         for(Account a: map_idfinal.values())
         {
           Acct_for_nextcheck.add(a);       
         }
       
         Database.executeBatch(new INDBatch_InactiveAccountFlag4Cases(Acct_for_nextcheck),200);
      
    }
}