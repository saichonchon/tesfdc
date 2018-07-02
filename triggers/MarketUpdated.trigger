trigger MarketUpdated on Market__c (after update, before insert, before update) 
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
  	for (Market__c mkt : trigger.new)
  	{
	  	if (mkt.Pricebook_Id__c == null)
	  	{
	  		// Create a price book object
	  		Pricebook2 newPB = new Pricebook2();
	  		newPB.Name = 'Pricebook for ' + mkt.Name;
	  		newPB.IsActive = true;
	  		newPbooks.add(newPB);
	  	}
  	}
  	
  	if (newPbooks.size() > 0)
  	{
  		Database.insert(newPbooks);

  		// loop through the trigger again, and set the field
  		integer idx = 0;
	    for (Market__c mkt : trigger.new)
	    {
	      if (mkt.Pricebook_Id__c == null)
	      {
	      	mkt.Pricebook_Id__c = newPbooks[idx].Id;
	      	idx++;
	      }
	    }
  	}
  }
	}
	catch (Exception ex)
	{
	  system.debug('Exception thrown: ' + ex);
	  ErrorLogging.Log(ex, 'MarketUpdate', 'Trigger', null);
	}
}