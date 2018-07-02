public with sharing class OpportunityPartEditController {
	
	//lists for opportunity line items grid and search results grid
	public List<OpportunityLineItem> oppParts {get; set;}
	public List<OpportunityLineItem> savedOppParts {get; set;}
	public List<Product2> searchResults {get; set;}
	
	//to store which new pricebook entries need inserted
	public List<PricebookEntry> insertPbEntries = new List<PricebookEntry>();
	public List<PricebookEntry> insertStandardPbEntries = new List<PricebookEntry>();	
	public Map<String, PricebookEntry> newPbEntriesByPartNbr = new Map<String, PricebookEntry>();
	
	//to enable display of all product2 info on opportunity line items grid, even before saving
	public Map<Id, String> partNbrByProduct2Id = new Map<Id, String>();	
	public Map<Id, Id> custPbEntryIdByPrd2Id = new Map<Id, Id>();	
	
	//opportunity and pricebook ids			
	private string oppId;
	private string oppPricebookId;
	private string standardPricebookId;	

	//part number search string
	public String searchString {get; set;}
	
	//advanced search fields
	private Integer resultLimit;
	public String searchPartNumber {get; set;}
	public String searchPartDesc {get; set;}
	public String searchGPL {get; set;}
	public String searchGPLDesc {get; set;}	
	
	//sosl search
	public String searchSOSL {get; set;}	
	
	//proposal part fields
	public Integer nbrProposalParts {get; set;}				
	
	//enable checkboxes to select search results
    public List<Product2> selectedParts = new List<Product2>();
    public Integer nbrSelected
    {
    	get
    	{
    		getSelected();
    		return selectedParts.size();    		
    	}
    	set;
    }	
    public List<partwrapper> SelectablePartList {get; set;}    
    
    //properties for deleting grid rows in oppParts list
    public Integer deleteLI {get; set;}    
    public List<oppPartWrapper> deleteList  
    {
    	get
    	{
    		List<oppPartWrapper> dellist = new List<oppPartWrapper>();
    		Integer counter = 0;
    		for(OpportunityLineItem oppPart : oppParts)
	        {
		        //add each opp part to list of wrapper items
		        dellist.add(new oppPartWrapper(oppPart, counter));
		        counter++;	        
	        }
	        return dellist;  
    	}
    	set;
    }
         
    public Boolean returnAfterSave {get; set;}
        
    //controls visibility in search section
    public String method {get; set;}
    public Boolean partNbrMethod {get; set;}
    public Boolean advancedMethod {get; set;}
    public Boolean proposalMethod {get; set;}

	//properties and methods for opportunity part list grid pagination
    public Integer oppPartListPageSize;
    public Integer oppPartListPageNumber {get { if (oppPartListPageNumber == null || oppPartListPageNumber == 0) oppPartListPageNumber = 1; return oppPartListPageNumber; } set;}
    public Integer oppPartListJumpToPage {get; set;}
    public Integer oppPartListLastPage 
    {
    	get
    	{
	       integer lastPageNumber = system.math.abs(oppPartListTotalRecordCount / oppPartListPageSize);
       
       		if(system.math.mod(oppPartListTotalRecordCount, oppPartListPageSize) > 0)
    	   	{
       	  		lastPageNumber += 1;
       		}
       		      		
    		return lastPageNumber;
    	} 
    	set;
    }
    public List<oppPartWrapper> singlePageOppPartList
    {
      get
      {
          List<oppPartWrapper> pagedList = new List<oppPartWrapper>();
          if (deleteList != null)          
          {
              integer startIdx = (oppPartListPageNumber - 1) * oppPartListPageSize;
              integer endIdx = startIdx + oppPartListPageSize-1;
              for (integer idx = startIdx; idx <= endIdx && deleteList.size() > idx; idx++)
                  pagedList.add(deleteList[idx]);
          }
          return pagedList;
      } 
      set;
    }

    public void oppPartListNextPage() 
    {
      oppPartListPageNumber++;
    }
  
    public void oppPartListPreviousPage() 
    {
      oppPartListPageNumber--;
    }
  
    public integer oppPartListFirstRecordNbr
    {
      get { return (oppPartListPageNumber - 1) * oppPartListPageSize + 1; }
    }
  
    public integer oppPartListLastRecordNbr
    {
      get { return Math.min(oppPartListTotalRecordCount, oppPartListFirstRecordNbr + oppPartListPageSize - 1) ; }
    }
  
    public integer oppPartListTotalRecordCount
    {
      get { if (deleteList == null) return 0; else return deleteList.size(); }      
    }
  
    public boolean oppPartListShowNextPageLink
    {
      get { return (oppPartListPageNumber < oppPartListTotalRecordCount / (oppPartListPageSize * 1.0)); }
    }
  
    public boolean oppPartListShowPrevPageLink
    {
      get { return (oppPartListPageNumber > 1); }
    }
  
    public void jumpToOppPartListPage()
    {  	   	
       if(oppPartListJumpToPage <= oppPartListLastPage && oppPartListJumpToPage >= 1)
       {
     	  oppPartListPageNumber = oppPartListJumpToPage;
       }
       else
       {
		  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Page Number Specified does not exist.'));       	  
       }       
    }  
    //end of opportunity part list pagination section

	//properties and methods for search results grid pagination    
    public Integer searchResultsPageSize;
    public Integer searchResultsPageNumber {get { if (searchResultsPageNumber == null || searchResultsPageNumber == 0) searchResultsPageNumber = 1; return searchResultsPageNumber; } set;}
    public Integer searchResultsJumpToPage {get; set;}
    public Integer searchResultsLastPage
    {
    	get
    	{
    		integer lastPageNumber = system.math.abs(searchResultsTotalRecordCount / searchResultsPageSize);
       
       		if(system.math.mod(searchResultsTotalRecordCount, searchResultsPageSize) > 0)
       		{
       	  		lastPageNumber += 1;
       		}
       		return lastPageNumber;
    	}
    	set;
    }    
    public List<partwrapper> singlePageSelectablePartList
    {
      get
      {
          List<partwrapper> pagedList = new List<partwrapper>();
          if (SelectablePartList != null)
          {
              integer startIdx = (searchResultsPageNumber - 1) * searchResultsPageSize;
              integer endIdx = startIdx + searchResultsPageSize-1;
              for (integer idx = startIdx; idx <= endIdx && SelectablePartList.size() > idx; idx++)
                  pagedList.add(SelectablePartList[idx]);
          }
          return pagedList;
      } 
      set;
    }

    public void searchResultsNextPage() 
    {
      searchResultsPageNumber++;
    }
  
    public void searchResultsPreviousPage() 
    {
      searchResultsPageNumber--;
    }
  
    public integer searchResultsFirstRecordNbr
    {
      get { return (searchResultsPageNumber - 1) * searchResultsPageSize + 1; }
    }
  
    public integer searchResultsLastRecordNbr
    {
      get { return Math.min(searchResultsTotalRecordCount, searchResultsFirstRecordNbr + searchResultsPageSize - 1) ; }
    }
  
    public integer searchResultsTotalRecordCount
    {
      get { if (SelectablePartList == null) return 0; else return SelectablePartList.size(); }
    }
  
    public boolean searchResultsShowNextPageLink
    {
      get { return (searchResultsPageNumber < searchResultsTotalRecordCount / (searchResultsPageSize * 1.0)); }
    }
  
    public boolean searchResultsShowPrevPageLink
    {
      get { return (searchResultsPageNumber > 1); }
    }
    public void jumpToSearchResultsPage()
    {   
       if(searchResultsJumpToPage <= searchResultsLastPage && searchResultsJumpToPage >= 1)
       {
     	  searchResultsPageNumber = searchResultsJumpToPage;
       }
       else
       {
		  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Page Number Specified does not exist.'));       	  
       }
    }    
	//end of search results grid pagination section 
            
    //get selected (where checkbox checked) search results               
    public void getSelected()  
    {  
         selectedParts.clear();
           
         for(partwrapper pwrapper : SelectablePartList)
         {           
         	if(pwrapper.selected == true)
         	{  
         		selectedParts.add(pwrapper.part);
         	}
         }  
    }            
	
	//wrapper for search results to make selectable via checkbox
    public class partwrapper  
    {  
         public Product2 part{get; set;}  
	     public Boolean selected {get; set;}  
         public partwrapper(Product2 a)  
         {  
             part = a;  
             selected = false;  
         }  
     }
     
	//wrapper for opportunity parts to add index for deletion
    public class oppPartWrapper  
    {  
         public OpportunityLineItem oppLineItem{get; set;}  
	     public Integer index {get; set;}  
         public oppPartWrapper(OpportunityLineItem o, Integer i)  
         {  
             oppLineItem = o;
             index = i;  
         }  
     }       
				
	//constructor			
	public OpportunityPartEditController() {
		selectablePartList = new List<partwrapper>();			 
		searchResults = new List<Product2>();			
		
		try
		{
			oppId = ApexPages.currentPage().getParameters().get('Id');
			getOppLineItems();
			getOppPriceBook();
			nbrProposalParts = 1;
			
			//set saved list of opp parts to list retrieved from db on load
			savedOppParts = new List<OpportunityLineItem>(oppParts);
	
			//set table page sizes and result limit
			OrgWideSettings__c settingsObj;
	      	settingsObj = OrgWideSettings__c.getValues('Default');
	      	
	      	if(settingsObj != null)
	      	{	
		      	oppPartListPageSize = Integer.valueOf(settingsObj.Datatable_Page_Size__c);
		      	searchResultsPageSize = Integer.valueOf(settingsObj.Datatable_Page_Size__c);
	    	  	resultLimit = Integer.valueOf(settingsObj.Search_Result_Limit__c);
	      	}
	      	else
	      	{
		      	oppPartListPageSize = 20;
		      	searchResultsPageSize = 20;
	    	  	resultLimit = 1000;	      		
	      	}
		
			//set default search method
			if(method == null)
			{
				method = 'partNbr';
				setSelectedSearchMethod();			
			}
			
			oppPartListJumpToPage = oppPartListPageNumber;
			searchResultsJumpToPage = searchResultsPageNumber;
			returnAfterSave = false;
		}
		catch (Exception e)
		{
			if(oppId == null)
			{
		        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must enter this page through an Opportunity.'));				
			}
			else
			{
		        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Loading Page: ' + e.getMessage()));				
			}
			ErrorLogging.Log(e);
		}		
	}

	//return button
    public PageReference gotoOpportunity(){
        return new PageReference('/' + oppId);
    }
	
	//delete button
	public void DeleteLineItems() {
		try{
			//get index of clicked row passed in from vf page and remove from list
			if(deleteLI != null)
			{
				oppParts.remove(deleteLI);
			}
			
			//if on last page and last page number changed, then go to new last page	
			if(oppPartListPageNumber > oppPartListLastPage)
			{
				oppPartListPageNumber = oppPartListLastPage;
			}
			
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Existing Line Items not permanently deleted until page is saved.'));	
		}
		catch (Exception e)
		{
			ErrorLogging.Log(e);
	        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Deleting Lines: ' + e.getMessage()));				
		}
	}
	
	//save button
	public void SaveLineItems() {	
		try
		{
			List<OpportunityLineItem> partsToDeleteOffOpp = new List<OpportunityLineItem>();
			Map<Id, OpportunityLineItem> oppPartsMap = new Map<Id, OpportunityLineItem>();			
			
			insert insertStandardPbEntries;		
			insert insertPbEntries;
						
			for(PricebookEntry PbEntry : insertPbEntries)
			{
				//Map new pricebook entry id's to part numbers (product2.name)
				newPbEntriesByPartNbr.put(partNbrByProduct2Id.get(PbEntry.Product2Id), PbEntry);
			}
 			
			insertStandardPbEntries.clear();		
			insertPbEntries.clear(); 			
 			
			for(OpportunityLineItem oli : oppParts)
			{
				if(oli.PricebookEntryId == null)
				{	
					//add pricebook entry id on to opportunity line item records, now that they've been inserted and ids were generated								
					oli.PricebookEntryId = newPbEntriesByPartNbr.get(oli.Part_Number__c).Id;
				}
				
				if(oli.Id != null)					
				{
					//map opportunity parts by id
					oppPartsMap.put(oli.Id, oli);					
				}
				
				if(oli.Comments__c != null)
				{
					//for some reason, entering the less than sign in text areas eats any subsequent text in the field, so pre-html encode that input
					oli.Comments__c = oli.Comments__c.replace('<', '&lt;');
				}
			}
			
			//save updates and inserts on opportunity line items
			upsert oppParts;
			
			for(OpportunityLineItem savedPart : savedOppParts)
			{
				//check if saved list of parts contains any id's not on current list of opportunity parts
				if(!oppPartsMap.containsKey(savedPart.Id))
				{
					//if true, add to list for deletion
					partsToDeleteOffOpp.add(savedPart);
				}
			}
			
			delete partsToDeleteOffOpp;
			
			//update saved list of opportunity parts (to match them as they exist in database)
			savedOppParts = new List<OpportunityLineItem>(oppParts);

	        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Save Completed'));		
		}
		catch (DmlException e)
		{
			ErrorLogging.Log(e);
	        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Saving: ' + e.getMessage()));
	        if(returnAfterSave == true)
		        throw(e);	        			
		}		
	}
	
	public pageReference doSaveAndReturn()
	{
		returnAfterSave = true;
		try{
			SaveLineItems();
			return gotoOpportunity();			
		}
		catch (Exception e)
		{
			ErrorLogging.Log(e, 'OpportunityPartEditController', 'doSaveAndReturn', oppId);
			returnAfterSave = false;
	        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Saving: ' + e.getMessage()));			
			return null;			
		}	
	}
	
	public void setSelectedSearchMethod()
	{
		if(method == 'partNbr')
		{
			partNbrMethod=true;
			advancedMethod=false;
			proposalMethod=false;			
		}
		else if(method == 'advanced')
		{
			partNbrMethod=false;
			advancedMethod=true;
			proposalMethod=false;			
		}
		else if(method == 'proposal')
		{
			partNbrMethod=false;
			advancedMethod=false;			
			proposalMethod=true;			
		}
		else
		{
			partNbrMethod=false;
			advancedMethod=false;			
			proposalMethod=false;			
		}		

		selectablePartList.clear();	
		searchResults.clear();
		searchResultsPageNumber = 1;						
	}		

    private void getOppLineItems(){
        // select * method
        String objectName = 'OpportunityLineItem';
        Map<String, Schema.SObjectField> allFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        String queryString = 'select';
        for(String s : allFields.keySet()) {
             queryString += ' ' + s + ',';
        }
        //add relationships fields that are needed. Must end in a comma.
        queryString += 'PriceBookEntry.Product2Id, PriceBookEntry.Product2.Name,';
        queryString = queryString.subString(0,queryString.Length()-1) + ' from ' + objectName + ' where OpportunityId = \''+ oppId + '\'';
        
        try {
            oppParts = database.query(queryString);
            
	        for(OpportunityLineItem oppPart : oppParts)
	        {
	        	//if part number field not set on existing opportunity line item, get from related product2 record
	        	if(SalesforceUtils.isNullOrEmpty(oppPart.Part_Number__c))
		        {
		        	oppPart.Part_Number__c = oppPart.PricebookEntry.Product2.Name;     	
		        }   
	        }	        
         
        } catch (QueryException e){
        	
            system.debug('Opportunity line item QUERY EXCEPTION = ' + e.getMessage());
            ErrorLogging.Log(e);
        }
    }
    
    private void getOppPriceBook(){
        try {
        	//find standard pricebook id
        	PriceBook2 tempPB;
            tempPB = [select Id from Pricebook2 where IsStandard = true];
            standardPriceBookId = String.valueOf(tempPB.Id);
            
            //find custom pricebook id on opportunity        	
	    	Opportunity tempOpp;        	            
            tempOpp = [select PriceBook2Id from Opportunity where Id = : oppId];
            oppPriceBookId = String.valueOf(tempOpp.PriceBook2Id);            
        } catch (QueryException e){
        	//if no custom pricebook id on opportunity, set pricebook to standard
        	ErrorLogging.Log(e, 'OpportunityPartEditController', 'getOppPriceBook', '');
            oppPriceBookId = standardPriceBookId;
            //although this allows you to continue on the edit screen, i think you still get an error if trying to save and the opportunity itself has no pricebook id            
        }
    }    

	public void doPartNbrSearch() {
		List<String> partNumbers = new List<String>();
		
		searchString = SalesforceUtils.replaceNullStringWithEmpty(searchString).replace('\n', ',');
		
		for(String pNbr : SalesforceUtils.replaceNullStringWithEmpty(searchString).split(','))
		{
			partNumbers.add(pNbr.trim());
		}

		selectablePartList.clear();	
		searchResults.clear();
		searchResultsPageNumber = 1;		
		
		if(partNumbers.size() <= resultLimit)
		{		
			//need to add in correct price field once it's on product2
			searchResults = [select p.Id, p.Name, p.Description, p.GPL__c, p.GPL_Desc__c, p.Standard_Price__c from Product2 p where p.Name in : partNumbers and p.Name != 'Proposal Part'];
				
			for(Product2 p : searchResults)
			{
				SelectablePartList.add(new partwrapper(p)); 
			}

			if(searchResults.size() == 0)
			{
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No Records Found.'));			
			}							
		}
		else
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'You can only search on up to ' + resultLimit + ' PN\'s at a time'));
		}	
	}
	
	public void clearPartNbrSearch() {
		searchString = null;
	}	
	
	public void doAdvancedSearch() {		

		selectablePartList.clear();	
		searchResults.clear();
		searchResultsPageNumber = 1;
		
		string query = 'select p.Id, p.Name, p.Description, p.GPL__c, p.GPL_Desc__c, p.Standard_Price__c from Product2 p ';
		string whereClause = 'where p.Name != \'Proposal Part\' ';
		
		if(!SalesforceUtils.isNullOrEmpty(searchPartNumber))
		{
			searchPartNumber = '%' + searchPartNumber.replace('*', '%') + '%';			
			whereClause = whereClause + 'and p.Name like : searchPartNumber ';
		}
		if(!SalesforceUtils.isNullOrEmpty(searchPartDesc))
		{
			searchPartDesc = '%' + searchPartDesc.replace('*', '%') + '%';			
			whereClause = whereClause + 'and p.Description like : searchPartDesc ';
		}
		if(!SalesforceUtils.isNullOrEmpty(searchGPL))
		{
			searchGPL = '%' + searchGPL.replace('*', '%') + '%';			
			whereClause = whereClause + 'and p.GPL__c like : searchGPL ';
		}
		if(!SalesforceUtils.isNullOrEmpty(searchGPLDesc))
		{
			searchGPLDesc = '%' + searchGPLDesc.replace('*', '%') + '%';			
			whereClause = whereClause + 'and p.GPL_Desc__c like : searchGPLDesc ';
		}
				
		query = query + whereClause + 'limit ' + resultLimit;
		//system.debug(query);
		searchResults = database.query(query);
				
		for(Product2 p : searchResults)
		{
			SelectablePartList.add(new partwrapper(p)); 
		}
		
		if(searchResults.size() == resultLimit)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Only the first ' + resultLimit + ' records matching your search criteria are retrieved.  Please try more specific criteria if the part you need is not included.'));						
		}
		else if(searchResults.size() == 0)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No Records Found.'));			
		}
	}
	
	public void doSOSLSearch()
	{
		if(SalesforceUtils.ReplaceNullStringWithEmpty(searchSOSL).length() > 1)
		{
			selectablePartList.clear();		
			searchResults.clear();
			searchResultsPageNumber	= 1;					

			system.debug('**** - ' + searchSOSL);

			//Max results returned = 200
			List<List<Product2>> searchSOSLResult = [FIND : searchSOSL IN ALL FIELDS RETURNING Product2 (id, name, description, gpl__c, gpl_desc__c, standard_price__c)];
			
			searchResults = searchSOSLResult.get(0);
			
			//system.debug('***** - ' + searchResults);
					
			for(Product2 p : searchResults)
			{
				SelectablePartList.add(new partwrapper(p)); 
			}
			
			if(searchResults.size() == 0)
			{
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No Records Found.'));			
			}			
			else
			{
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Searching all fields only returns up to 200 results.'));
			}			
		}
		else
		{		
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Search All Fields Search String must be longer than 1 character'));			
		}
	}
	
	public void clearAdvancedSearch() {
		searchPartNumber = null;
		searchPartDesc = null;
		searchGPL = null;
		searchGPLDesc = null;
		searchSOSL = null;	
	}	
	
	public void doAddProposalParts() {
		try{
			//Proposal part needs to exist for this to work
			List<Product2> TempPart = [select Id, Name, Description, Standard_Price__c from Product2 where Description = 'Proposal Part' limit 1];
	
			//need to get pricebookentry here first				
			addPbEntriesToBeCreated(TempPart);			
			
			for(integer i = 0; i < nbrProposalParts; i++)
			{
				OpportunityLineItem newItem = new OpportunityLineItem();
				
				newItem.OpportunityId = oppId;		
				newItem.PricebookEntryId = custPbEntryIdByPrd2Id.get(TempPart[0].Id);				
				newItem.Part_Number__c = TempPart[0].Name;
				//setting defaults to avoid validation error
				newItem.Quantity = 1;
				newItem.UnitPrice = 0;											
				oppParts.add(newItem);						        
			}
			
			oppPartListPageNumber = oppPartListLastPage;
			
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, nbrProposalParts +  ' part(s) added.'));				           					
		}
		catch (QueryException e)
		{
            system.debug('Product2 QUERY EXCEPTION = ' + e.getMessage());
	        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Adding Proposal Parts: ' + e.getMessage()));            
            ErrorLogging.Log(e);			
		}			
	}		
	
	public void clearAddProposalParts() {
		nbrProposalParts = null;
	}	
	
	public void addResultToPartList() {
		try
		{
			getSelected();
			//need to get pricebookentry here first
			addPbEntriesToBeCreated(selectedParts);
			
			//system.debug('***** - 1 - ' + selectedParts);				
			
			for(Product2 selected : selectedParts)
			{				
				OpportunityLineItem newItem = new OpportunityLineItem();
				
				newItem.OpportunityId = oppId;
				
				newItem.PricebookEntryId = custPbEntryIdByPrd2Id.get(selected.Id);
				newItem.Part_Number__c = selected.Name;
				//add part desc as line item description
				if(SalesforceUtils.replaceNullStringWithEmpty(selected.Description).length() > 255)
				{
					newItem.Description = selected.Description.subString(0, 255);
				}
				else
				{
					newItem.Description = selected.Description;				
				}
				
				//setting defaults to avoid validation error
				newItem.Quantity = 1;
				newItem.UnitPrice = selected.Standard_Price__c;					
				oppParts.add(newItem);				        	
			}
			
			//system.debug('***** - 2 - ' + oppParts);
			
			oppPartListPageNumber = oppPartListLastPage;
			
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, selectedParts.size() +  ' part(s) added.')); 
			//selectedParts.clear();
			clearAllCheckboxes();
		}
		catch (Exception e)
		{
	        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Adding to Opportunity Part List: ' + e.getMessage()));            
            ErrorLogging.Log(e);	
		}		 
	}
	
	public void selectAllCheckboxes()
	{
		for(partWrapper p : selectablePartList)
		{
			p.selected = true;
		}
	}
	public void clearAllCheckboxes()
	{
		for(partWrapper p : selectablePartList)
		{
			p.selected = false;
		}
	}	
	
	public void addPbEntriesToBeCreated(List<Product2> partsToAdd)
	{
			List<PricebookEntry> standardParts = new List<PricebookEntry>();			
			List<PricebookEntry> theseParts = new List<PricebookEntry>();
			List<Id> prd2Ids = new List<Id>();			
			Map<Id, Id> stdPbEntryIdByPrd2Id = new Map<Id, Id>();

			//get list of prd2 id's						
			for(Product2 p2 : partsToAdd)
			{
				prd2Ids.add(p2.Id);
			}
		
			try {
				
				if(oppPriceBookId != standardPriceBookId)
				{	
					//check if pricebookentry exists on standardpricebook				
					standardParts = [select Id, Product2Id from PricebookEntry pb where pb.Product2Id in : prd2Ids and pb.PriceBook2Id =: standardPricebookId];
				}
				//check if pricebookentry exists on custom pricebook, if opportunity's pricebook isn't the standard pricebook, otherwise check for existence on standardpricebook here
				theseParts = [select Id, Product2Id from PricebookEntry pb where pb.Product2Id in : prd2Ids and pb.PriceBook2Id =: oppPricebookId];
								
				for(PricebookEntry stdEntry : standardParts)
				{
					stdPbEntryIdByPrd2Id.put(stdEntry.Product2Id, stdEntry.Id);
				}
				
				for(PricebookEntry custEntry : theseParts)
				{
					custPbEntryIdByPrd2Id.put(custEntry.Product2Id, custEntry.Id);
				}				
				
				//for each product2, determine if there are existing pricebook entries/standard pricebook entries
				for(Product2 partToAdd : partsToAdd)
				{
					//if not add new pricebook entries to lists for insertion
					if(!custPbEntryIdbyPrd2Id.containsKey(partToAdd.Id))
					{
						PricebookEntry thisPart = new PricebookEntry();
						thisPart.Pricebook2Id = oppPricebookId;
						thisPart.Product2Id = partToAdd.Id;
						thisPart.IsActive = true;
						thisPart.UnitPrice = (partToAdd.Standard_Price__c == null ? 0 :partToAdd.Standard_Price__c);
						insertPbEntries.add(thisPart);
					}

					if(!stdPbEntryIdbyPrd2Id.containsKey(partToAdd.Id) && oppPriceBookId != standardPriceBookId)
					{
						PricebookEntry standardPart = new PricebookEntry();
						standardPart.Pricebook2Id = standardPricebookId;					
						standardPart.UseStandardPrice = false;
						standardPart.Product2Id = partToAdd.Id;
						standardPart.IsActive = true;
						standardPart.UnitPrice = (partToAdd.Standard_Price__c == null ? 0 :partToAdd.Standard_Price__c);					
						insertStandardPbEntries.add(standardPart);						
					}
									
					//build map to allow display of product2 name in edit grid
					partNbrByProduct2Id.put(partToAdd.Id, partToAdd.Name);					
				}				
			}
			catch (QueryException e){
				//one of the above queries failed, so all parts need to be created on custom and/or standard pricebook
				//create new pricebook entry on custom pricebook
				for(Product2 partToAdd : partsToAdd)
				{
					PricebookEntry thisPart = new PricebookEntry();
					thisPart.Pricebook2Id = oppPricebookId;
					thisPart.Product2Id = partToAdd.Id;
					thisPart.IsActive = true;
					thisPart.UnitPrice = (partToAdd.Standard_Price__c == null ? 0 :partToAdd.Standard_Price__c);
					insertPbEntries.add(thisPart);	
					
					//create new pricebook entry on standard pricebook if one doesn't already exist
					if(standardParts == null && oppPriceBookId != standardPriceBookId)
					{
						PricebookEntry standardPart = new PricebookEntry();
						standardPart.Pricebook2Id = standardPricebookId;					
						standardPart.UseStandardPrice = false;
						standardPart.Product2Id = thisPart.Product2Id;
						standardPart.IsActive = thisPart.IsActive;
						standardPart.UnitPrice = thisPart.UnitPrice;					
						insertStandardPbEntries.add(standardPart);
					}
					partNbrByProduct2Id.put(partToAdd.Id, partToAdd.Name);														
				}									
			}
		catch (Exception e)
		{
	        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Adding Pricebook Entries: ' + e.getMessage()));            
            ErrorLogging.Log(e);	
		}						
	}

	//sorting for search results
	public String searchResultsSortField {get; set;}  
	public String searchResultsPrevSortField {get; set;}  
	
	public void doSearchResultsSort()
	{  
		try {
			String order = 'asc';  
	
			/*This checks to see if the same header was click two times in a row, if so   
			it switches the order.*/ 
	
			if(searchResultsPrevSortField == searchResultsSortField)
			{  
				order = 'desc';  
				searchResultsPrevSortField = null;  
			}
			else
			{  
				searchResultsPrevSortField = searchResultsSortField;  
			}  
			
			//create map to save checked status of partwrapper object before re-sorting both lists
			Map<Product2, partwrapper> sortMap = new Map<Product2, partwrapper>();
			
			//take advantage of the fact that the index orders should match between searchResults and selectablePartList at this point
			for(integer i = 0; i < searchResults.size(); i++)
			{
				//add Product2 and partwrapper with matching list indexes to map
				sortMap.put(searchResults.get(i), selectablePartList.get(i));
			}
			
			//sort searchResults
			TableSortSupport.sortList(searchResults,searchResultsSortField,order); 
			
			selectablePartList.clear();
			
			//reorder selectablePartList by clearing and reinserting partwrappers from map based on new order in searchResults list
			for(Product2 result : searchResults)
			{
				selectablePartList.add(sortMap.get(result));
			}
		}
		catch (ListException e)
		{
			if(searchResults.size() > 0)
			{
		        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Sorting: ' + e.getMessage()));            
    	        ErrorLogging.Log(e);				
			}
			else
			{
				searchResultsSortField = null;
				searchResultsPrevSortField = null;
			}
		}
		catch (Exception e)
		{
	        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Sorting: ' + e.getMessage()));            
            ErrorLogging.Log(e);	
		}	 
	}
	
	//sorting for part list
	public String oppPartListSortField {get; set;}  
	public String oppPartListPrevSortField {get; set;}  
	
	public void doOppPartListSort()
	{  
		try
		{
			String order = 'asc';  
	
			/*This checks to see if the same header was click two times in a row, if so   
			it switches the order.*/ 
	
			if(oppPartListPrevSortField == oppPartListSortField)
			{  
				order = 'desc';  
				oppPartListPrevSortField = null;  
			}
			else
			{  
				oppPartListPrevSortField = oppPartListSortField;  
			}  			
			
			TableSortSupport.sortList(oppParts,oppPartListSortField,order);
		}
		catch (ListException e)
		{
			if(searchResults.size() > 0)
			{
		        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Sorting: ' + e.getMessage()));            
    	        ErrorLogging.Log(e);				
			}
			else
			{
				oppPartListSortField = null;
				oppPartListPrevSortField = null;
			}
		}
		catch (Exception e)
		{
	        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Sorting: ' + e.getMessage()));            
            ErrorLogging.Log(e);	
		}		
				  
	}  	  
	
}