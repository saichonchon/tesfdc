trigger CFTTeamMemberUpdated on Customer_Focus_Team_Member__c (before delete, after insert, after update) 
{

  // Sync changes with any Account Team member records for this member.
  
  // First get all the Accounts for this Global Account
  List<Id> globalAcctIds = new List<Id>();
  List<Id> sfUserIds = new List<Id>();
  List<Global_Account__Share> addGamShares = new List<Global_Account__Share>();
  List<Global_Account__Share> removeGamShares = new List<Global_Account__Share>();
  List<Global_Account__Share> deleteGamShares = new List<Global_Account__Share>();    
  if (trigger.isdelete)
  {
	  for (Customer_Focus_Team_Member__c tmpTeamMember : trigger.old)
	  {
	  	if(!SalesforceUtils.IsNullOrEmpty(tmpTeamMember.Global_Account__c))
	  	{
	      globalAcctIds.add (tmpTeamMember.Global_Account__c);
		  sfUserIds.add (tmpTeamMember.Salesforce_User_Name__c);
	      //add global account and user combination to list of shares to global accounts to remove
	      Global_Account__Share gamShare = SharingUtils.CreateGlobalAccountShare(tmpTeamMember.Global_Account__c, tmpTeamMember.Salesforce_User_Name__c);
	      removeGamShares.add(gamShare);
	  	}	       
	  }
  }
  else
  {
	  for (Customer_Focus_Team_Member__c tmpTeamMember : trigger.new)
	  {
	  	if(!SalesforceUtils.IsNullOrEmpty(tmpTeamMember.Global_Account__c))
	  	{
		  globalAcctIds.add (tmpTeamMember.Global_Account__c);
      	  sfUserIds.add (tmpTeamMember.Salesforce_User_Name__c);
	  	}
	  }
  }
  
  system.debug ('*****GlobalAccountIds = ' + globalAcctIds);
  Map<Id, Account> AccountsMap = new Map<Id, Account> ([Select Id, OwnerId, Global_Account__r.OwnerId from Account where Global_Account__c in :globalAcctIds]);
  system.debug ('*****Accounts = ' + AccountsMap);
  
  List<Id> usersToDelete = new List<Id>();
  List<Id> removeFromGAMIds = new List<Id>();  
  List<AccountShare> newShares = new List<AccountShare>();
  List<AccountTeamMember> newTeamMembers = new List<AccountTeamMember>();
  List<AccountTeamMember> deleteTeamMembers = new List<AccountTeamMember>();  
  if (Trigger.isInsert || trigger.isUpdate)
  {
	  for (Customer_Focus_Team_Member__c tmpTeamMember : trigger.new)
	  {
	  	  //tmpTeamMember.Global_Account__r.OwnerId doesn't work from the trigger, so need to get gam owner from accounts...
		  Id gamOwner = null;		  
		  if (Trigger.isInsert)
		  {
		  	for (Account act : AccountsMap.values())
		  	{		  	  
		  	  if(act.Global_Account__c == tmpTeamMember.Global_Account__c)
		  	  {		  		
			  	// Add this member to the Account Teams for the same global Account
		      	newTeamMembers.add (SharingUtils.CreateAccountTeamMember(act.id, tmpTeamMember.Salesforce_User_Name__c, tmpTeamMember.Role__c));
		      	
		      	if(gamOwner == null)
		      	{
		      		gamOwner = act.Global_Account__r.OwnerId;
		      	}
		
		      	// Create the Account Share object, but only if this is not the Owner
		      	if (tmpTeamMember.Salesforce_User_Name__c != act.OwnerId)
		      	{
		        	newShares.add(SharingUtils.CreateAccountShare(act.id, tmpTeamMember.Salesforce_User_Name__c));    		  		          
		      	}
		  	  }		        	          
		  	}	  	
		  	if(gamOwner != tmpTeamMember.Salesforce_User_Name__c && gamOwner != null)
		  	{
	    		//add to list of shares to global accounts to add			  		
		      	Global_Account__Share gamShare = SharingUtils.CreateGlobalAccountShare(tmpTeamMember.Global_Account__c, tmpTeamMember.Salesforce_User_Name__c);
		      	addGamShares.add(gamShare);		  	
		  	}
		  }	  
		  else if (Trigger.isUpdate)
		  {
		  	Customer_Focus_Team_Member__c tmpOldValues = trigger.oldMap.get(tmpTeamMember.id);
		  	// Does the Account Team Member records need to change?  Maybe the role is different?  What if the user changes?
		  	// TODO May have to do and oldvalues == newvalues comparsion
		  	
		  	// If the user field has changed, this will need to perform a delete and an insert
		  	if (tmpOldValues.Salesforce_User_Name__c != tmpTeamMember.Salesforce_User_Name__c || tmpOldValues.Global_Account__c != tmpTeamMember.Global_Account__c)
		  	{		  		
		  		// Put the old userid in the delete list
		  		usersToDelete.add(tmpOldValues.Salesforce_User_Name__c);
                //Prabhanjan filtering null values out
                if(string.valueOf(tmpOldValues.Global_Account__c)<>null && string.valueOf(tmpOldValues.Global_Account__c)!=''){
                    //system.debug(':::prabhan:values added :::'+tmpOldValues.Global_Account__c);
                    removeFromGAMIds.add(tmpOldValues.Global_Account__c);
                } 
	    		//put old user/gam in delete list for global account shares to remove		  		
	    		Global_Account__Share gamShare1 = SharingUtils.CreateGlobalAccountShare(tmpOldValues.Global_Account__c, tmpOldValues.Salesforce_User_Name__c);
	    		removeGamShares.add(gamShare1);		  		 		
	          for (Account act : AccountsMap.values())
	          {
			  	  if(act.Global_Account__c == tmpTeamMember.Global_Account__c)
		  	  	  {	          		          	
	            	newTeamMembers.add (SharingUtils.CreateAccountTeamMember(act.id, tmpTeamMember.Salesforce_User_Name__c, tmpTeamMember.Role__c));

		      		if(gamOwner == null)
		      		{
		      			gamOwner = act.Global_Account__r.OwnerId;
		      		}
	            
		          	// Create the Account Share object, but only if this is not the Owner
		          	if (tmpTeamMember.Salesforce_User_Name__c != act.OwnerId)
		          	{
		            	newShares.add(SharingUtils.CreateAccountShare(act.id, tmpTeamMember.Salesforce_User_Name__c));
		          	}
		  	  	  }		          		            
	          }
	          //bug - there's an issue if you add a CFTMember and there are no accounts on the Global Account
	          //the trigger does not grant a global_account_share to the CFTMember user in that case.  You would
	          //need to change some information on the CFTMember to get that to update.	          
			  if(gamOwner != tmpTeamMember.Salesforce_User_Name__c && gamOwner != null)
			  {
			  		//add to list of new shares to global accounts
			      	Global_Account__Share gamShare2 = SharingUtils.CreateGlobalAccountShare(tmpTeamMember.Global_Account__c, tmpTeamMember.Salesforce_User_Name__c);
			      	addGamShares.add(gamShare2);		  	
			  }	              
		  	}
		  	else if (tmpOldValues.Role__c != tmpTeamMember.Role__c)
		  	{
		  		// Just create the teammeber again, which will reset the role.
	          for (Account act : AccountsMap.values())
	          {
	            newTeamMembers.add (SharingUtils.CreateAccountTeamMember(act.id, tmpTeamMember.Salesforce_User_Name__c, tmpTeamMember.Role__c));
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
  	removeFromGAMIds = globalAcctIds;
  }
  else if(trigger.isUpdate && removeFromGAMIds.size() > 0)
  {
     // system.debug(':::Prabhan:testing:::'+removeFromGAMIds[0]);
  	AccountsMap = new Map<Id, Account> ([Select Id, OwnerId from Account where Global_Account__c in :removeFromGAMIds]);  	
  }

  if (usersToDelete.size() > 0)
  {
  	List<Global_Account__Share> filteredGamShares = new List<Global_Account__Share>();
  	//get existing global account shares that might need to be deleted
  	filteredGamShares = [Select Id, ParentId, UserOrGroupId from Global_Account__Share where RowCause != 'Owner' and ParentId in: removeFromGAMIds and UserOrGroupId in: usersToDelete];  	
  	for(Global_Account__Share share : removeGamShares)
  	{
  		for(Global_Account__Share listshare : filteredGamShares)
  		{
  			if(share.ParentId == listshare.ParentId && share.UserOrGroupId == listshare.UserOrGroupId)
  			{
  				//add shares to delete list where global account and user id match old share
  				deleteGamShares.add(listshare);
  				break;
  			}
  		}
  	}  	
  	
    // Remove this user from any Account Team for the Global Account
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

  if (deleteGamShares.size() > 0)
  	Database.delete(deleteGamShares);
    
  if (addGamShares.size() > 0)
  	Database.insert(addGamShares); 	
  
}