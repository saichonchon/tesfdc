trigger ContactUpdate on Contact (before insert, before update) 
{
  List<Id> accountIds = new List<Id>();
  List<Account> accountGamList = new List<Account>();
  
  for (integer idx = 0; idx < trigger.new.size(); idx++)
  {
    Contact c = trigger.new[idx];
    //system.debug('c=' + c);

    if(c.AccountId != null)
    {
        accountIds.add(c.AccountId);
    }    
  }
  
  accountGamList = [Select Id, Global_Account__r.Id From Account where Id in : accountIds and Global_Account__c != null];
  Map<Id, Id> acctToGblAcctIds = new Map<Id, Id>();
  
  for(Account gamInfo : accountGamList)  
  {
    acctToGblAcctIds.put(gamInfo.Id, gamInfo.Global_Account__r.Id);
  }
  for(integer idx2 = 0; idx2 < trigger.new.size(); idx2++)
  {
    Contact c = trigger.new[idx2];
    c.Global_Rollup__c = acctToGblAcctIds.get(c.AccountId);
  }
}