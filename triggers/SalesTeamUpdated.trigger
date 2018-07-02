trigger SalesTeamUpdated on Sales_Team__c (before delete, after insert, after update) 
{

  // Sync changes with any Account Team member records for this member.
  
  // First get all the Accounts for this Market
  List<Id> marketIds = new List<Id>();
  List<Id> sfUserIds = new List<Id>();
  List<Market__Share> addMktShares = new List<Market__Share>();
  List<Market__Share> removeMktShares = new List<Market__Share>();
  List<Market__Share> deleteMktShares = new List<Market__Share>();    
  if (trigger.isdelete)
  {
	  for (Sales_Team__c tmpTeamMember : trigger.old)
	  {
	  	if(!SalesforceUtils.IsNullOrEmpty(tmpTeamMember.Market__c))
	  	{
	        marketIds.add (tmpTeamMember.Market__c);
		    sfUserIds.add (tmpTeamMember.Team_Member__c);
		    //add market and user combination to list of shares to markets to remove	    
		    Market__Share mktShare = SharingUtils.CreateMarketShare(tmpTeamMember.Market__c, tmpTeamMember.Team_Member__c);
		    removeMktShares.add(mktShare);
	  	}		    
	  }
  }
  else
  {
	  for (Sales_Team__c tmpTeamMember : trigger.new)
	  {
	  	if(!SalesforceUtils.IsNullOrEmpty(tmpTeamMember.Market__c))
	  	{	  	
	    	marketIds.add (tmpTeamMember.Market__c);
        	sfUserIds.add (tmpTeamMember.Team_Member__c);
	  	}
	  }
  }
  
  system.debug ('*****MarketIds = ' + marketIds);
  Map<Id, Account> AccountsMap = new Map<Id, Account> ([Select Id, OwnerId, Channel_Market__r.OwnerId from Account where Channel_Market__c in :marketIds]);
  system.debug ('*****Accounts = ' + AccountsMap);
  
  List<Id> usersToDelete = new List<Id>();
  List<Id> removeFromMarketIds = new List<Id>();
  List<AccountShare> newShares = new List<AccountShare>();
  List<AccountTeamMember> newTeamMembers = new List<AccountTeamMember>();
  List<AccountTeamMember> deleteTeamMembers = new List<AccountTeamMember>();
  if (Trigger.isInsert || trigger.isUpdate)
  {
	  for (Sales_Team__c tmpTeamMember : trigger.new)
	  {
	  	  //tmpTeamMember.Market__r.OwnerId doesn't work from the trigger, so need to get market owner from accounts...	  	
		  Id mktOwner = null;	  	
		  if (Trigger.isInsert)
		  {
		  	for (Account act : AccountsMap.values())
		  	{
		  	  if(act.Channel_Market__c == tmpTeamMember.Market__c)
		  	  {			  		
			  	// Add this member to the Account Teams for the same Market
			    newTeamMembers.add (SharingUtils.CreateAccountTeamMember(act.id, tmpTeamMember.Team_Member__c, tmpTeamMember.Team_Role__c));
			      
		      	if(mktOwner == null)
		      	{
		      		mktOwner = act.Channel_Market__r.OwnerId;
		      	}			      
			
			    // Create the Account Share object, but only if this is not the Owner
			    if (tmpTeamMember.Team_Member__c != act.OwnerId)
			    {
			        newShares.add(SharingUtils.CreateAccountShare(act.id, tmpTeamMember.Team_Member__c));
			    }
		  	  }	          
		  	}
	          //bug - there's an issue if you add a Sales Team Member and there are no accounts on the Market
	          //the trigger does not grant a market_share to the Sales Team Member user in that case.  You would
	          //need to change some information on the member to get that to update.	  		  	
		  	if(mktOwner != tmpTeamMember.Team_Member__c && mktOwner != null)
		  	{
		        //add to list of shares to markets to add	
		      	Market__Share mktShare = SharingUtils.CreateMarketShare(tmpTeamMember.Market__c, tmpTeamMember.Team_Member__c);
		      	addMktShares.add(mktShare);		  		
		  	}
		  }		  
		  else if (Trigger.isUpdate)
		  {
		  	Sales_Team__c tmpOldValues = trigger.oldMap.get(tmpTeamMember.id);
		  	// Does the Account Team Member records need to change?  Maybe the role is different?  What if the user changes?
		  	// TODO May have to do and oldvalues == newvalues comparsion
		  	
		  	// If the user field has changed, this will need to perform a delete and an insert
		  	if (tmpOldValues.Team_Member__c != tmpTeamMember.Team_Member__c || tmpOldValues.Market__c != tmpTeamMember.Market__c)
		  	{		  		
		  		// Put the old userid in the delete list
		  		usersToDelete.add(tmpOldValues.Team_Member__c);
		  		removeFromMarketIds.add(tmpOldValues.Market__c);		  		
		  		//put old user/market in delete list for market shares to remove	
	    		Market__Share mktShare1 = SharingUtils.CreateMarketShare(tmpOldValues.Market__c, tmpOldValues.Team_Member__c);
	    		removeMktShares.add(mktShare1);	
	    			  		
	          for (Account act : AccountsMap.values())
	          {
			  	  if(act.Channel_Market__c == tmpTeamMember.Market__c)
			  	  {		          	
		            newTeamMembers.add (SharingUtils.CreateAccountTeamMember(act.id, tmpTeamMember.Team_Member__c, tmpTeamMember.Team_Role__c));
	
			      	if(mktOwner == null)
			      	{
			      		mktOwner = act.Channel_Market__r.OwnerId;
			      	}	
		            
			        // Create the Account Share object, but only if this is not the Owner
			        if (tmpTeamMember.Team_Member__c != act.OwnerId)
			        {
			            newShares.add(SharingUtils.CreateAccountShare(act.id, tmpTeamMember.Team_Member__c));
			        }	 
			  	  }           
	          }
	          if(mktOwner != tmpTeamMember.Team_Member__c && mktOwner != null)
	          {
		        //add to list of new shares to markets
		      	Market__Share mktShare2 = SharingUtils.CreateMarketShare(tmpTeamMember.Market__c, tmpTeamMember.Team_Member__c);
		      	addMktShares.add(mktShare2);	          	
	          }    
		  	}
		  	else if (tmpOldValues.Team_Role__c != tmpTeamMember.Team_Role__c)
		  	{
		  		// Just create the teammember again, which will reset the role.
	          for (Account act : AccountsMap.values())
	          {
	            newTeamMembers.add (SharingUtils.CreateAccountTeamMember(act.id, tmpTeamMember.Team_Member__c, tmpTeamMember.Team_Role__c));
	          }
		  	}		  	
		  	else
		  	{	
		  		// Something else changed, and we really dont care.
		  	}
		  }
	  }
  }
  
  if (trigger.isDelete)
  {
  	usersToDelete = sfUserIds;
  	removeFromMarketIds = marketIds;  	
  }
  else if(trigger.isUpdate && removeFromMarketIds.size() > 0)
  {
	AccountsMap = new Map<Id, Account> ([Select Id, OwnerId from Account where Channel_Market__c in :removeFromMarketIds]);  	
  }  

  if (usersToDelete.size() > 0)
  {
  	List<Market__Share> filteredMktShares = new List<Market__Share>();
  	//get existing global account shares that might need to be deleted
  	filteredMktShares = [Select Id, ParentId, UserOrGroupId from Market__Share where RowCause != 'Owner' and ParentId in: removeFromMarketIds and UserOrGroupId in: usersToDelete];
  	for(Market__Share share : removeMktShares)
  	{
  		for(Market__Share listshare : filteredMktShares)
  		{
  			if(share.ParentId == listshare.ParentId && share.UserOrGroupId == listshare.UserOrGroupId)
  			{
	  			//add shares to delete list where global account and user id match old share	
  				deleteMktShares.add(listshare);
  				break;
  			}
  		}
  	}  	
  	
    // Remove this user from any Account Team for the Market
    deleteTeamMembers = new List<AccountTeamMember> ([Select Id from AccountTeamMember where AccountId in :AccountsMap.keyset()
                                                                          And UserId in :usersToDelete]);
  }
  
  system.debug ('*** I want to add these folks: ' + newTeamMembers);
      
  if (newTeamMembers.size() > 0)
    Database.SaveResult[] saveResults = Database.insert(newTeamMembers);

  if (deleteTeamMembers.size() > 0)
    Database.delete(deleteTeamMembers);

  if (newShares.size() > 0)
    Database.insert(newShares);
    
  if (deleteMktShares.size() > 0)
  	Database.delete(deleteMktShares);
    
  if (addMktShares.size() > 0)	
  	Database.insert(addMktShares);      
  
}