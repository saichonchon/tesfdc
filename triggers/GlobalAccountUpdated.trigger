/*****************************************************************************************************************************************************
Name: GlobalAccountUpdated.trigger 
Copyright © 2011 TE Connectivity
======================================================================================================================================================
Purpose: Trigger which creates a starting Pricebook for the Global Account. 

======================================================================================================================================================
History:                                                        
------------------------------------------------------------------------------------------------------------------------------------------------------                                                         
VERSION AUTHOR        DATE         DETAIL                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 R. Dress      06/21/2011   Initial Development 
*****************************************************************************************************************************************************/
trigger GlobalAccountUpdated on Global_Account__c (before insert, before update, after delete) 
{
	try
	{
  if (Trigger.isdelete)
  {
  	// Todo - Should we be deleting price books?  Can we if they are used in Opptys?
  	// Should we be deleting CFTMembers too?
  	
  }
  else
  {
  	List<Pricebook2> newPbooks = new List<Pricebook2>();
  	for (Global_Account__c ga : trigger.new)
  	{
	  	if (ga.Pricebook_Id__c == null)
	  	{
	  		// Create a price book object
	  		Pricebook2 newPB = new Pricebook2();
	  		newPB.Name = 'Pricebook for ' + ga.Name;
	  		newPB.IsActive = true;
	  		newPbooks.add(newPB);
	  	}
  	}
  	
  	if (newPbooks.size() > 0)
  	{
  		Database.insert(newPbooks);

  		// loop through the trigger again, and set the field
  		integer idx = 0;
	    for (Global_Account__c ga : trigger.new)
	    {
	      if (ga.Pricebook_Id__c == null)
	      {
	      	ga.Pricebook_Id__c = newPbooks[idx].Id;
	      	idx++;
	      }
	    }
  	}
  }
	}
	catch (Exception ex)
	{
	  system.debug('Exception thrown: ' + ex);
	  ErrorLogging.Log(ex, 'GlobalAccountUpdate', 'Trigger', null);
	}
}