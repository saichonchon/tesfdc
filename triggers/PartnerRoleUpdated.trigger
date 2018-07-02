trigger PartnerRoleUpdated on Partner_Role__c (after insert, after update) 
{
  // Update the Sales team object with new records for any Partner Roles:
  
  // 1 - An new account is added as a Partner Role to this Oppty: Create Sales Team Member record for the Account owner
  
  // 2 - The Account reference on a Partner Role record is changed: Create a Sales Team Member record for the new Account, and remove the Sales Team Record for the previous account.`
  
  // 3 - The Partner Role record is changed, but the Opportunity is changed: ??
  
  // 4 - The Partner Role record is changed, only the role name is changed: Update the OpportunityTeamMember recordd?
  
  // 5 - The Partner Role record is deleted:  Delete the corresponding Sales Team Record.
  
  // issue:  What if the owner of the Account record changes?  Should this change be reflected in the Sales team table?
  
  
  // Get a list of all the Account ids we care about
  Set<Id> acctIds = new Set<Id>();
  Set<Id> opptyIds = new Set<Id>();
  for (Partner_Role__c pr : trigger.new)
  {
    // TODO - we dont need every account do we?
    if (pr.Account__c != null)
      acctIds.add (pr.Account__c);
      
    // If the Account or Opportunity has changed, keep the Oppty Id.  Later we will load all the OpportunityTeamMembers for this Opportunity
    if (trigger.isUpdate && (trigger.oldMap.get(pr.Id).Account__c != pr.Account__c || trigger.oldMap.get(pr.Id).Opportunity__c != pr.Opportunity__c))
    {
      // Keep the old Oppty Id
      opptyIds.add(trigger.oldMap.get(pr.Id).Opportunity__c);
      system.debug('***** - ' + trigger.oldMap.get(pr.Id).Opportunity__r.OwnerId);      
    }
  }
  
  if (acctIds.size() > 0)
  {
    List<OpportunityTeamMember> newOpptyTeamMembers = new List<OpportunityTeamMember>();
    List<OpportunityTeamMember> updateOpptyTeamMembers = new List<OpportunityTeamMember>();
    List<OpportunityTeamMember> deleteOpptyTeamMembers = new List<OpportunityTeamMember>();
    List<OpportunityShare> newShares = new List<OpportunityShare>();

    // Get the Accounts and owners
    Map<Id, Account> AccountOwnerMap = new Map<Id, Account>([Select Id, OwnerId from Account where id in :acctIds]);
    
    Map<Id, OpportunityTeamMember> existingOpptyTeamMembers = new Map<Id, OpportunityTeamMember>([Select Id, OpportunityId, UserId, TeamMemberRole from OpportunityTeamMember Where OpportunityId in :opptyIds]);

	Set<Id> oppIds = new Set<Id>();
	
    for (Partner_Role__c pr : trigger.new)
    {
    	oppIds.add(pr.Opportunity__c);
    }
    
    Map<Id,Id> oppOwners = new Map<Id,Id>();
    
    List<Opportunity> getOwners = [Select Id, OwnerId from Opportunity where Id in : oppIds];
    
    for(Opportunity o : getOwners)
    {
    	oppOwners.put(o.Id, o.OwnerId);
    }	
    
    //system.debug('***** - ' + oppOwners);
    
    for (Partner_Role__c pr : trigger.new)
    {
    //system.debug('***** - ' + AccountOwnerMap.get(pr.Account__c).OwnerId + ' ' + oppOwners.get(pr.Opportunity__c));    	
      if(AccountOwnerMap.get(pr.Account__c).OwnerId != oppOwners.get(pr.Opportunity__c))
      {
	      if (trigger.isInsert)
	      {
	        if (pr.Account__c != null && pr.Opportunity__c != null)
	        {
	            // Create Team Member record and Share record
	            newOpptyTeamMembers.add(SharingUtils.CreateOpptyTeamMember(pr.Opportunity__c, AccountOwnerMap.get(pr.Account__c).OwnerId, pr.Role__c));
	            newShares.add(SharingUtils.CreateOpportunityShare(pr.Opportunity__c, AccountOwnerMap.get(pr.Account__c).OwnerId)); 
	            system.debug('*** - ' + newShares);
	        }
	      } 
	      else if (trigger.isUpdate)
	      {
	        Partner_Role__c oldVals = trigger.oldMap.get(pr.Id);
	        if (oldVals.Account__c != pr.Account__c || oldVals.Opportunity__c != pr.Opportunity__c)
	        {
	          // Add the new one, 
	          newOpptyTeamMembers.add(SharingUtils.CreateOpptyTeamMember(pr.Opportunity__c, AccountOwnerMap.get(pr.Account__c).OwnerId, pr.Role__c));
	          
	          // Remove the old one   TODO : need to find the correct one.
	        }
	      }
	      else if (trigger.isDelete)
	      {
	        // TODO Remove the old records.
	      }
      }
    }
    
    system.debug('*** Number of new Team members: ' + newOpptyTeamMembers.size());
    system.debug('*** Number of new Shares: ' + newShares.size());
    if (newOpptyTeamMembers.size() > 0)
      Database.insert(newOpptyTeamMembers);
      
    if (newShares.size() > 0)
      Database.insert(newShares);
  }
}