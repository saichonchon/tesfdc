trigger AccountUpdated on Account (after insert, after update) 
{
	
	// Has the Global Account reference changed?  If so, rebuild the Account Team
	
	// Get all the cft memmbers I need.
	// Which global accounts are used in this trigger?
  Set<Id> globalAcctIds = new Set<Id>();
  Set<Id> accountIds2 = new Set<Id>();
  Set<Id> marketIds = new Set<Id>();
  for (integer idx=0; idx < trigger.new.size(); idx++)
  {
    if ((trigger.isUpdate && trigger.new[idx].Global_Account__c != trigger.old[idx].Global_Account__c)
      || (trigger.isInsert && trigger.new[idx].Global_Account__c != null))
    {
    	accountIds2.add(trigger.new[idx].Id);
    	if (trigger.new[idx].Global_Account__c != null)
    	  globalAcctIds.add(trigger.new[idx].Global_Account__c);
    	if (trigger.isUpdate && trigger.old[idx].Global_Account__c != null)
        globalAcctIds.add(trigger.old[idx].Global_Account__c);        
    }
    else if((trigger.isUpdate && trigger.new[idx].Channel_Market__c != trigger.old[idx].Channel_Market__c)
      || (trigger.isInsert && trigger.new[idx].Channel_Market__c != null))
    {
    	accountIds2.add(trigger.new[idx].Id);
    	if (trigger.new[idx].Channel_Market__c != null)
    	  marketIds.add(trigger.new[idx].Channel_Market__c);
    	if (trigger.isUpdate && trigger.old[idx].Channel_Market__c != null)
    	  marketIds.add(trigger.old[idx].Channel_Market__c);    	            	
    }
  }
  
  // globalAcctIds contains a list of all global account ids which will be needed.
  // accountIds contains a list of all affect Account ids
  // Get the list of CFT members for all these global accounts
  
  Map<Id, Customer_Focus_Team_Member__c>  cftMembersMap = new Map<Id, Customer_Focus_Team_Member__c>();
  Map<Id, Sales_Team__c>  marketTeamMap = new Map<Id, Sales_Team__c>();  
  if (globalAcctIds.size() > 0)
    cftMembersMap = SharingUtils.GetCFTMembersMap(globalAcctIds);
  if (marketIds.size() > 0)
    marketTeamMap = SharingUtils.GetMarketTeamMembersMap(marketIds);        

system.debug ('**** global acounts: ' + cftMembersMap);

  // Now get all account team members currently in place.
  Map<Id, AccountTeamMember> acctTeamMbrs;
  if (accountIds2.size() > 0)
    acctTeamMbrs = SharingUtils.GetAcctTeamMembersMap(accountIds2);
	 
system.debug ('**** existing team members: ' + acctTeamMbrs);
  
  List<AccountShare> newShares = new List<AccountShare>();
  List<AccountTeamMember> newTeamMembers = new List<AccountTeamMember>();
  List<AccountTeamMember> changeTeamMembers = new List<AccountTeamMember>();
  List<AccountTeamMember> deleteTeamMembers = new List<AccountTeamMember>();
  for (integer idx=0; idx < trigger.new.size(); idx++)
  {
  	Id newGblAcctId = null;
  	Id oldGblAcctId = null;
  	Map<Id, Customer_Focus_Team_Member__c> newMembers = new Map<Id, Customer_Focus_Team_Member__c>();
  	Map<Id, Customer_Focus_Team_Member__c> oldMembers = new Map<Id, Customer_Focus_Team_Member__c>();
  	if (trigger.isUpdate && trigger.new[idx].Global_Account__c != trigger.old[idx].Global_Account__c)
  	{
  		oldGblAcctId = trigger.old[idx].Global_Account__c;
  		newGblAcctId = trigger.new[idx].Global_Account__c;
  	}
  	
  	if (trigger.isInsert && trigger.new[idx].Global_Account__c != null)
  	{
  		newGblAcctId = trigger.new[idx].Global_Account__c;
  	}
  	
  	// oldGblAcctId contains the global account id of those members who should be removed
  	// newGblAcctId contains the global account id of those members who should be added

      for (Customer_Focus_Team_Member__c tmpMember : cftMembersMap.values())
      {
        if (tmpMember.Global_Account__c == oldGblAcctId)
           oldMembers.put (tmpMember.Salesforce_User_Name__c, tmpMember);

        if (tmpMember.Global_Account__c == newGblAcctId)
           newMembers.put (tmpMember.Salesforce_User_Name__c, tmpMember);
      } 

      // At this point we have the old list (oldMembers) and a new list (newMemmbers)
      // Compare the lists and decide who should be removed and who should be added.
      for (Customer_Focus_Team_Member__c tmpNewMember : newMembers.values())
      {
      	// Is this member in the old list too?  for the same account and user?
      	
        boolean found = false;
        integer idx2 = 0;
      	
/**************************************
      	//tmpMember
      	found = false;
      	idx2 = 0;
      	While (!found && idx2 < oldMembers.size())
      	{
      		// TODO - get the actual Account Team record
      		Customer_Focus_Team_Member__c tmpOldMember;
      		tmpOldMember = oldMembers.values().get(idx2); 
      		if (tmpOldMember.Salesforce_User_Name__c == tmpNewMember.Salesforce_User_Name__c)
      		{
            // If a record is in the newMembers list and also in the oldMembers list, maybe it needs to be updated for role
            if (tmpOldMember.Role_Name__c != tmpNewMember.Role_Name__c)
            {
              // Change the role, if needs be, and add to the update list
		          boolean found3 = false;
		          integer idx3 = 0;
		          while (!found3 && idx3 < acctTeamMbrs.size())
		          {
		            if (acctTeamMbrs.values()[idx3].AccountId == trigger.new[idx].Id
		               && acctTeamMbrs.values()[idx3].UserId == tmpOldMember.Salesforce_User_Name__c)
		            {
		            	acctTeamMbrs.values()[idx3].TeamMemberRole = tmpNewMember.Role_Name__c;
		              changeTeamMembers.add(acctTeamMbrs.values()[idx3]);
		              found3 = true;
		            }
		            idx3++;
              }
            }
            
            
      			found = true;
      		} 
      		idx2++;
      	}
      	
********************************/
      	
      	// Lets just always add
      	if (!found)
      	{
          // If a record is in the newMembers list, but not in the oldMembers list create a new record
          // Create a new record
          newTeamMembers.add (SharingUtils.CreateAccountTeamMember(trigger.new[idx].id, tmpNewMember.Salesforce_User_Name__c, tmpNewMember.Role__c));

          // Create the Account Share object, but only if this is not the Owner
          if (tmpNewMember.Salesforce_User_Name__c != trigger.new[idx].ownerId)
          	newShares.add(SharingUtils.CreateAccountShare(trigger.new[idx].id, tmpNewMember.Salesforce_User_Name__c));
      	}
      }
      
      // If a record is in the oldMembers list and not in the new list, this record needs to be deleted.
      // Check any oldMembers who are not in the new group too
      for (Customer_Focus_Team_Member__c tmpOldMember : oldMembers.values())
      {
        boolean found = false;
        integer idx2 = 0;
        While (!found && idx2 < newMembers.size())
        {
          Customer_Focus_Team_Member__c tmpNewMember;
          tmpNewMember = newMembers.values().get(idx2); 
          if (tmpOldMember.Salesforce_User_Name__c == tmpNewMember.Salesforce_User_Name__c)
          {
            found = true;
          } 
          
          idx2++;
        }
        
        if (!found)
        {
        	// Remove the old member
        	// TODO - Get the AccountTeamMember
	        found = false;
	        idx2 = 0;
	        while (!found && idx2 < acctTeamMbrs.size())
	        {
	          if (acctTeamMbrs.values()[idx2].AccountId == trigger.new[idx].Id
	             && acctTeamMbrs.values()[idx2].UserId == tmpOldMember.Salesforce_User_Name__c)
	          {
              deleteTeamMembers.add(acctTeamMbrs.values()[idx2]);
              found = true;
	          }
	          idx2++;
	        }
        }
      }

	/*** Start market sales team members section here ***/

  	Id newMarketId = null;
  	Id oldMarketId = null;
  	Map<Id, Sales_Team__c> newMarketMembers = new Map<Id, Sales_Team__c>();
  	Map<Id, Sales_Team__c> oldMarketMembers = new Map<Id, Sales_Team__c>();
  	if (trigger.isUpdate && trigger.new[idx].Channel_Market__c != trigger.old[idx].Channel_Market__c)
  	{
  		oldMarketId = trigger.old[idx].Channel_Market__c;
  		newMarketId = trigger.new[idx].Channel_Market__c;
  	}
  	
  	if (trigger.isInsert && trigger.new[idx].Channel_Market__c != null)
  	{
  		newMarketId = trigger.new[idx].Channel_Market__c;
  	}
  	
  	// oldGblAcctId contains the global account id of those members who should be removed
  	// newGblAcctId contains the global account id of those members who should be added

      for (Sales_Team__c tmpMarketMember : marketTeamMap.values())
      {
        if (tmpMarketMember.Market__c == oldMarketId)
           oldMarketMembers.put (tmpMarketMember.Team_Member__c, tmpMarketMember);

        if (tmpMarketMember.Market__c == newMarketId)
           newMarketMembers.put (tmpMarketMember.Team_Member__c, tmpMarketMember);
      } 

      // At this point we have the old list (oldMembers) and a new list (newMemmbers)
      // Compare the lists and decide who should be removed and who should be added.
      for (Sales_Team__c tmpNewMarketMember : newMarketMembers.values())
      {
      	// Is this member in the old list too?  for the same account and user?
      	
        boolean found = false;
        integer idx2 = 0;
      	
      	// Lets just always add
      	if (!found)
      	{
          // If a record is in the newMembers list, but not in the oldMembers list create a new record
          // Create a new record
          newTeamMembers.add (SharingUtils.CreateAccountTeamMember(trigger.new[idx].id, tmpNewMarketMember.Team_Member__c, tmpNewMarketMember.Team_Role__c));

          // Create the Account Share object, but only if this is not the Owner
          if (tmpNewMarketMember.Team_Member__c != trigger.new[idx].ownerId)
          	newShares.add(SharingUtils.CreateAccountShare(trigger.new[idx].id, tmpNewMarketMember.Team_Member__c));
      	}
      }
      
      // If a record is in the oldMembers list and not in the new list, this record needs to be deleted.
      // Check any oldMembers who are not in the new group too
      for (Sales_Team__c tmpOldMarketMember : oldMarketMembers.values())
      {
        boolean found = false;
        integer idx2 = 0;
        While (!found && idx2 < newMarketMembers.size())
        {
          Sales_Team__c tmpNewMarketMember;
          tmpNewMarketMember = newMarketMembers.values().get(idx2); 
          if (tmpOldMarketMember.Team_Member__c == tmpNewMarketMember.Team_Member__c)
          {
            found = true;
          } 
          
          idx2++;
        }
        
        if (!found)
        {
        	// Remove the old member
        	// TODO - Get the AccountTeamMember
	        found = false;
	        idx2 = 0;
	        while (!found && idx2 < acctTeamMbrs.size())
	        {
	          if (acctTeamMbrs.values()[idx2].AccountId == trigger.new[idx].Id
	             && acctTeamMbrs.values()[idx2].UserId == tmpOldMarketMember.Team_Member__c)
	          {
              deleteTeamMembers.add(acctTeamMbrs.values()[idx2]);
              found = true;
	          }
	          idx2++;
	        }
        }
      }


  system.debug ('*** I want to add these folks: ' + newTeamMembers);
  system.debug ('*** I want to change these: ' + changeTeamMembers);
  system.debug ('*** I want to remove these: ' + deleteTeamMembers);      
      
  }
	
	if (newTeamMembers.size() > 0)
	  Database.SaveResult[] saveResults = Database.insert(newTeamMembers);

  if (deleteTeamMembers.size() > 0)
    Database.delete(deleteTeamMembers);

  if (changeTeamMembers.size() > 0)
  	Database.update(changeTeamMembers);
	
	if (newShares.size() > 0)
	  Database.insert(newShares);
	
}