public without sharing class PricebookUtils 
{
  public static Map<Id, Account> GetPricebooksForAccounts(List<Id> accountIds)
  {
	  Map<Id, Account> results;
	  try
	  {
	   results = new Map<Id, Account> (
	    [SELECT id, global_account__c, global_account__r.Pricebook_Id__c
	     FROM account 
	     WHERE id in :accountIds]);
	  } 
	  catch (Exception ex)
	  {
	   System.debug('Exception in GetPricebooksForAccounts() : ' + ex.getMessage());
     ErrorLogging.Log(ex, 'PricebookUtils', 'GetPricebooksForAccounts', null);
	   results =  null;
	  } 
	  
	  return results;      	
  }
  
  public static Map<Id, Market__c> GetPricebooksForMarkets(List<Id> marketIds)
  {
	  Map<Id, Market__c> results;
	  try
	  {
	   results = new Map<Id, Market__c> (
	    [SELECT id, Pricebook_Id__c
	     FROM Market__c 
	     WHERE id in :marketIds]);
	  } 
	  catch (Exception ex)
	  {
	   System.debug('Exception in GetPricebooksForMarkets() : ' + ex.getMessage());
     ErrorLogging.Log(ex, 'PricebookUtils', 'GetPricebooksForMarkets', null);
	   results =  null;
	  } 
	  
	  return results;      	
  }  
  
  public static Id GetStandardPriceBookId()
  {
    Id results;
    try
    {
     results = 
      [SELECT id 
       FROM Pricebook2 
       WHERE IsActive=true 
            AND IsStandard = true][0].Id;
    } 
    catch (Exception ex)
    {
     System.debug('Exception in GetStandardPriceBookId() : ' + ex.getMessage());
     ErrorLogging.Log(ex, 'PricebookUtils', 'GetStandardPriceBookId', null);
     results =  null;
    } 
    
    return results;       
  }
}