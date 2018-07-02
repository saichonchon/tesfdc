/**
 *  This class used for managing Opportunity_Part__c and Part__c
 *
 @author Yinfeng Guo
 @created 2012-02-29
 @version 1.0
 @since 23.0 (Force.com ApiVersion)
 *
 @changelog
 * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Created
 * 2012-05-07 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - this class is not used recently
 */

public with sharing class ExtOpportunityPart {

   
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


//==================================================Regard to pagination====================================
//==================================================Regard to pagination====================================    
    //Variable mean : whether to show the next page link
    public boolean searchResultsShowNextPageLink{
        get { 
            return (searchResultsPageNumber < searchResultsTotalRecordCount / (searchResultsPageSize * 1.0)); 
        }
    }
    //Variable mean : whether to show the previous page link for search result list
    public boolean searchResultsShowPrevPageLink{
        get { 
            return (searchResultsPageNumber > 1); 
        }
    }
    //Variable mean : whether to show the previous page link for opportunity part list
    public boolean oppPartListShowPrevPageLink{
        get { 
            return (oppPartListPageNumber > 1); 
        }
    }
    //Variable mean : whether to show the next page link for opportunity part list
    public boolean oppPartListShowNextPageLink{
        get { 
            return (oppPartListPageNumber < oppPartListTotalRecordCount / (oppPartListPageSize * 1.0)); 
        }
    }    
    //Variable mean : recently page last record number for search result list
    public integer searchResultsLastRecordNbr{
        get { 
            return Math.min(searchResultsTotalRecordCount, searchResultsFirstRecordNbr + searchResultsPageSize - 1) ; 
        }
    }
    //Variable mean : recently page first record number for search result list
    public integer searchResultsFirstRecordNbr{
        get { 
            return (searchResultsPageNumber - 1) * searchResultsPageSize + 1; 
        }
    }
    //Variable mean : number of total page    
    public Integer oppPartListPageSize;
    
    //Variable mean : recently present page or the page will to show
    public Integer oppPartListPageNumber {
        get { 
            if (oppPartListPageNumber == null || oppPartListPageNumber == 0) oppPartListPageNumber = 1; 
            return oppPartListPageNumber; 
        } 
        set;
    }
    //Variable mean : the last page number for opportunity part list
    public Integer oppPartListLastPage {
        get{
            Integer lastPageNumber = system.math.abs(oppPartListTotalRecordCount / oppPartListPageSize);
            if(system.math.mod(oppPartListTotalRecordCount, oppPartListPageSize) > 0){
                lastPageNumber += 1;
            }
            return lastPageNumber;
        } 
        set;
    }
    //Variable mean : the page number will jump to
    public Integer oppPartListJumpToPage {get; set;}         
//==================================================Regard to pagination====================================    
//==================================================Regard to pagination====================================


//==================================================Regard to Opportunity_Part__c list PageBlock====================================
//==================================================Regard to Opportunity_Part__c list PageBlock====================================
    //Variable mean : opportunity parts list to show only single page
    public List<OpportunityPartWrapper> list_singlePageOpportunityParts{
        get{
            List<OpportunityPartWrapper> list_pagedParts = new List<OpportunityPartWrapper>();
            
            if (list_indexOpportunityParts != null){
                Integer startIdx = (oppPartListPageNumber - 1) * oppPartListPageSize;
                Integer endIdx = startIdx + oppPartListPageSize-1;
                for (Integer idx = startIdx; idx <= endIdx && list_indexOpportunityParts.size() > idx; idx++)
                  list_pagedParts.add(list_indexOpportunityParts[idx]);
            }
            system.debug('yinfeng:list_pagedParts:'+list_pagedParts);
            return list_pagedParts;
        } 
        set;
    }
    //Variable mean : the index will delete Opportunity_Part__c
    public Integer deleteOpportunityPartIndex {get; set;} 
    //sorting for part list
    public String oppPartListSortField {get; set;}  
    public String oppPartListSortFieldPrev {get; set;}   
    

    //Variable mean : the total data select from the database
    public List<Opportunity_Part__c> list_opportunityParts {get; set;}  
    public List<Opportunity_Part__c> list_savedOppParts {get; set;}
        
    //Variable mean : the first record number on the recently page  
    public Integer oppPartListFirstRecordNumber{
        get { 
            return (oppPartListPageNumber - 1) * oppPartListPageSize + 1; 
        }
    }

    //Variable mean : the last record number on the recently page
    public Integer oppPartListLastRecordNumber{
        get { 
            return Math.min(oppPartListTotalRecordCount, oppPartListFirstRecordNumber + oppPartListPageSize - 1) ; 
        }
    }
    
    //Variable mean : the total record number
    public Integer oppPartListTotalRecordCount{
        get { 
            if (list_indexOpportunityParts == null) return 0; 
            else return list_indexOpportunityParts.size(); 
        }      
    }
    
    //Variable mean : transfer common opportunity part list to list have specific index
    public List<OpportunityPartWrapper> list_indexOpportunityParts{
        get{
            List<OpportunityPartWrapper> list_indexOppPartWrapper = new List<OpportunityPartWrapper>();
            Integer counter = 0;
            for(Opportunity_Part__c oppPart : list_opportunityParts){
                list_indexOppPartWrapper.add(new OpportunityPartWrapper(oppPart, counter));
                counter++;  
            }
            system.debug('yinfeng:list_indexOppPartWrapper:'+list_indexOppPartWrapper);
            return list_indexOppPartWrapper; 
        }
        set;
    }  
    
    public Boolean returnAfterSave {get; set;}              
//==================================================Regard to Opportunity_Part__c list PageBlock====================================
//==================================================Regard to Opportunity_Part__c list PageBlock====================================


//==================================================Regard to Part__c search result list PageBlock====================================
//==================================================Regard to Part__c search result list PageBlock==================================== 
    //Variable mean : search Part result list to show only single page
    public List<SelectPartWrapper> list_singlePageSelectablePart{
        get{
            List<SelectPartWrapper> pagedList = new List<SelectPartWrapper>();
            if (list_selectablePartList != null){
                integer startIdx = (searchResultsPageNumber - 1) * searchResultsPageSize;
                integer endIdx = startIdx + searchResultsPageSize-1;
                for (integer idx = startIdx; idx <= endIdx && list_selectablePartList.size() > idx; idx++)
                    pagedList.add(list_selectablePartList[idx]);
            }
            return pagedList;
        } 
        set;
    }
    
    //Variable mean : the selected checkbox number
    public Integer nbrSelected{
        get{
            GetSelected();
            return list_selectedParts.size();           
        }
        set;
    }
    //sorting for search results
    public String searchResultsSortField {get; set;}  
    public String searchResultsPrevSortField {get; set;}  
    
    //properties and methods for search results grid pagination    
    public Integer searchResultsPageSize;
    public Integer searchResultsPageNumber {get { if (searchResultsPageNumber == null || searchResultsPageNumber == 0) searchResultsPageNumber = 1; return searchResultsPageNumber; } set;}
    public Integer searchResultsJumpToPage {get; set;}
    public Integer searchResultsLastPage{
        get{
            Integer lastPageNumber = system.math.abs(searchResultsTotalRecordCount / searchResultsPageSize);
       
            if(system.math.mod(searchResultsTotalRecordCount, searchResultsPageSize) > 0){
                lastPageNumber += 1;
            }
            return lastPageNumber;
        }
        set;
    } 
       
    public integer searchResultsTotalRecordCount{
        get { 
            if (list_selectablePartList == null) return 0; 
            else return list_selectablePartList.size(); 
        }
    }
    //enable checkboxes to select search results
    public List<Part__c> list_selectedParts = new List<Part__c>();
        

    public List<SelectPartWrapper> list_selectablePartList {get; set;}  
    public List<Part__c> list_searchResults {get; set;}
                
//==================================================Regard to Part__c search result list PageBlock====================================
//==================================================Regard to Part__c search result list PageBlock====================================

//==================================================Regard to Search PageBlock====================================  
//==================================================Regard to Search PageBlock====================================
    //sosl search
    public String searchSOSL {get; set;}    
    
    //part number search string
    public String searchString {get; set;}

    //advanced search fields
    private Integer resultLimit;
    public String searchPartNumber {get; set;}
    public String searchPartDesc {get; set;}
    public String searchGPL {get; set;}
    public String searchGPLDesc {get; set;} 

    //controls visibility in search section
    public String method {get; set;}
    public Boolean partNbrMethod {get; set;}
    public Boolean advancedMethod {get; set;}
    public Boolean proposalMethod {get; set;}   

    //proposal part fields
    public Integer nbrProposalParts {get; set;}         
//==================================================Regard to Search PageBlock====================================  
//==================================================Regard to Search PageBlock====================================
        
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private id opportunityId;   
    private String requestType;
    private static final String REQUESTTYPE_CA = 'Cable Assembly';
    private static final String REQUESTTYPE_ND = 'New Development';
    private static final String REQUESTTYPE_E = 'Extension';
    private static final String REQUESTTYPE_SO = 'Sales Only';
                   
                    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
   /**
    * The contsructor
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @changelog
    * 2012-02-29 YinFeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */      
    public ExtOpportunityPart(ApexPages.standardController stdCtrl) {
        list_selectablePartList = new List<SelectPartWrapper>();             
        list_searchResults = new List<Part__c>();   
        list_opportunityParts = new List<Opportunity_Part__c>();    
        system.debug('yinfeng:constructor');
        try
        {
            opportunityId = stdCtrl.getId();
            //opportunityId = ApexPages.currentPage().getParameters().get('Id');
            system.debug('yinfeng:opportunityId:'+opportunityId);
            getOpportunityParts();
            nbrProposalParts = 1;
            
            if(opportunityId != null){
                requestType = [SELECT Id, Request_Type__c FROM Opportunity where Id =: opportunityId].Request_Type__c;
            }
            //set saved list of opp parts to list retrieved from db on load
            list_savedOppParts = new List<Opportunity_Part__c>(list_opportunityParts);
            
                        
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
                oppPartListPageSize = 6;
                searchResultsPageSize = 6;
                resultLimit = 1000;
            }
            
            //set default search method
            if(method == null)
            {
                method = 'partNbr';
                SetSelectedSearchMethod();          
            }
            
            oppPartListJumpToPage = oppPartListPageNumber;
            
            searchResultsJumpToPage = searchResultsPageNumber;
            returnAfterSave = false;
            
        
        }
        catch (Exception e)
        {
            if(opportunityId == null)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Enter_Page_Wrong  ));     //  
            }
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Error_Loading_Page + e.getMessage()));    //          
            }
            //ErrorLogging.Log(e);
        }       
    }

    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
  	
   /**
	* This method is used to get the opportunity part record type id from custom setting
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param mode 		the string to decide which record type id to get from custom setting
    @return             the opportunity part record id
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */  
	public static Id oppRTId(String mode){
		Id oppId;
		if(mode == 'cap'){
			if(Apex_Helper_Settings__c.getInstance('Cable Asssembly Part RT Id') != null) oppId = Apex_Helper_Settings__c.getInstance('Cable Asssembly Part RT Id').Value__c;
		}
		else if(mode == 'sp'){
			if(Apex_Helper_Settings__c.getInstance('Sales Parts RT Id') != null) oppId = Apex_Helper_Settings__c.getInstance('Sales Parts RT Id').Value__c;
		}
		else if(mode == 'np'){
			if(Apex_Helper_Settings__c.getInstance('New Development RT Id') != null) oppId = Apex_Helper_Settings__c.getInstance('New Development RT Id').Value__c;
		}
		else if(mode == 'e'){
			if(Apex_Helper_Settings__c.getInstance('Extension RT Id') != null) oppId = Apex_Helper_Settings__c.getInstance('Extension RT Id').Value__c;
		}
		return oppId;
	}	

//==================================================Add proposal parts or existing parts to Opportunity Parts list====================================  
//==================================================Add proposal parts or existing parts to Opportunity Parts list==================================== 
  	

   /**
	* This method is used to add proposal parts to the proposal part list.
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             void
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */     	  
    public void DoAddProposalParts() {
        try{
            //Proposal part needs to exist for this to work
            //List<Part__c> TempPart = [select Id, Name, Description__c,  Product_Hierarchy__c, Product_Hierarchy__r.Product_Manager__c, Product_Hierarchy__r.Product_Manager__r.GIBU__c from Part__c where Description__c = 'Proposal Part' limit 1];
            List<Part__c> TempPart = [select Id, Name, Description__c,  Product_Hierarchy__c, Product_Hierarchy__r.Hierarchy_Level_Type__c, Product_Hierarchy__r.Description__c from Part__c where Description__c = 'Proposal Part' limit 1];
            
            for(Integer i = 0; i < nbrProposalParts; i++)
            {
                Opportunity_Part__c newPart = new Opportunity_Part__c();
                newPart.Opportunity__c = opportunityId;     
                //newPart.PricebookEntryId = custPbEntryIdByPrd2Id.get(TempPart[0].Id);             
                //newPart.Name = TempPart[0].Name;
                /*
                if(TempPart[0].Product_Hierarchy__c != null && TempPart[0].Product_Hierarchy__c != '' && TempPart[0].Product_Hierarchy__r.Product_Manager__c != null && TempPart[0].Product_Hierarchy__r.Product_Manager__c != '' && TempPart[0].Product_Hierarchy__r.Product_Manager__r.GIBU__c != null){
                    newPart.Product_Owning_GIBU__c = TempPart[0].Product_Hierarchy__r.Product_Manager__r.GIBU__c;
                }
                */
				system.debug('22222222: ' + TempPart);
                system.debug('11111111: ' + TempPart[0].Product_Hierarchy__r.Hierarchy_Level_Type__c);
                if(TempPart[0].Product_Hierarchy__c != null && TempPart[0].Product_Hierarchy__r.Hierarchy_Level_Type__c != null && TempPart[0].Product_Hierarchy__r.Hierarchy_Level_Type__c == 'CBC1'){
                    if(TempPart[0].Product_Hierarchy__r.Description__c == 'Industrial'){
                        newPart.Product_Owning_GIBU__c = 'Industrial';
                    }
                    else if(TempPart[0].Product_Hierarchy__r.Description__c == 'Appliances'){
                        newPart.Product_Owning_GIBU__c = 'Appliances';
                    }
                    else if(TempPart[0].Product_Hierarchy__r.Description__c == 'Data Communications'){
                        newPart.Product_Owning_GIBU__c = 'DataComm';
                    }
                    else if(TempPart[0].Product_Hierarchy__r.Description__c == 'Consumer Devices'){
                        newPart.Product_Owning_GIBU__c = 'Consumer Devices';
                    }
                }
                else{
                    newPart.Product_Owning_GIBU__c = 'Other BU';
                }
                
                
                if(requestType == REQUESTTYPE_CA){
                    newPart.RecordTypeId = oppRTId('cap');
                }
                else if(requestType == REQUESTTYPE_ND){
                    newPart.RecordTypeId = oppRTId('nd');
                }
                else if(requestType == REQUESTTYPE_E){
                    newPart.RecordTypeId = oppRTId('e');
                }
                else if(requestType == REQUESTTYPE_SO){
                    newPart.RecordTypeId = oppRTId('sp');
                }   
                                
                //setting defaults to avoid validation error
                newPart.Quantity__c = 1;
                newPart.Sales_Price__c = 0; 
                newPart.Status__c = 'Active';
                newPart.Part__c = TempPart[0].Id;                                       
                list_opportunityParts.add(newPart);                             
            }
            oppPartListPageNumber = oppPartListLastPage;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, nbrProposalParts +  system.Label.Parts_Added));                              
        }
        catch (QueryException e)
        {
            system.debug('Product2 QUERY EXCEPTION = ' + e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Error_Adding_Proposal_Parts  + e.getMessage()));        
            //ErrorLogging.Log(e);          
        }           
    }
    
   /**
	* This method is used to add the selected parts to the opportunity sales part list.
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             void
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */         
    public void AddResultToPartList() {
        try
        {
            getSelected();
            //need to get pricebookentry here first
            //addPbEntriesToBeCreated(selectedParts);
            
            //system.debug('***** - 1 - ' + selectedParts);             
            
            for(Part__c selected : list_selectedParts)
            {               
                Opportunity_Part__c newPart = new Opportunity_Part__c();
                
                newPart.Opportunity__c = opportunityId;
                /*
                if(selected.Product_Hierarchy__c != null && selected.Product_Hierarchy__c != '' && selected.Product_Hierarchy__r.Product_Manager__c != null && selected.Product_Hierarchy__r.Product_Manager__c != '' && selected.Product_Hierarchy__r.Product_Manager__r.GIBU__c != null){
                    newPart.Product_Owning_GIBU__c = selected.Product_Hierarchy__r.Product_Manager__r.GIBU__c;
                }*/
                if(selected.Product_Hierarchy__c != null && selected.Product_Hierarchy__r.Hierarchy_Level_Type__c != null && selected.Product_Hierarchy__r.Hierarchy_Level_Type__c == 'CBC1'){
                    if(selected.Product_Hierarchy__r.Description__c == 'Industrial'){
                        newPart.Product_Owning_GIBU__c = 'Industrial';
                    }
                    else if(selected.Product_Hierarchy__r.Description__c == 'Appliances'){
                        newPart.Product_Owning_GIBU__c = 'Appliances';
                    }
                    else if(selected.Product_Hierarchy__r.Description__c == 'Data Communications'){
                        newPart.Product_Owning_GIBU__c = 'DataComm';
                    }
                    else if(selected.Product_Hierarchy__r.Description__c == 'Consumer Devices'){
                        newPart.Product_Owning_GIBU__c = 'Consumer Devices';
                    }
                }
                else{
                    newPart.Product_Owning_GIBU__c = 'Other BU';
                }
                        
                if(requestType == REQUESTTYPE_CA){
                    newPart.RecordTypeId = oppRTId('sp');
                }
                else if(requestType == REQUESTTYPE_ND){
                    newPart.RecordTypeId = oppRTId('sp');
                }
                else if(requestType == REQUESTTYPE_E){
                    newPart.RecordTypeId = oppRTId('sp');
                }
                else if(requestType == REQUESTTYPE_SO){
                    newPart.RecordTypeId = oppRTId('sp');
                }   
                            
                //newPart.Name = selected.Name;
                //add part desc as line item description
                if(SalesforceUtils.replaceNullStringWithEmpty(selected.Description__c).length() > 255)
                {
                    newPart.New_Part_Description__c = selected.Description__c.subString(0, 255);
                }
                else
                {
                    newPart.New_Part_Description__c = selected.Description__c;              
                }
                newPart.Part__c = selected.Id;
                //setting defaults to avoid validation error
                newPart.Quantity__c = 1;
                newPart.Status__c = 'Active';
                newPart.Sales_Price__c = 0.00;                  
                list_opportunityParts.add(newPart);                         
            }
            
            //system.debug('***** - 2 - ' + oppParts);
            
            oppPartListPageNumber = oppPartListLastPage;
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, list_selectedParts.size() +  system.Label.Parts_Added)); //
            //selectedParts.clear();
            clearAllCheckboxes();
        }
        catch (Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Add_Part_Error + e.getMessage()));   //         
            //ErrorLogging.Log(e);  
        }        
    }
    
//==================================================Add proposal parts or existing parts to Opportunity Parts list====================================  
//==================================================Add proposal parts or existing parts to Opportunity Parts list==================================== 






//==================================================Search method====================================  
//==================================================Search method====================================  
   /**
	* This method is used to search Part according to the combine condition user input on Sales mode
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             void
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */   
    public void DoAdvancedSearch() {        

        list_selectablePartList.clear();    
        list_searchResults.clear();
        searchResultsPageNumber = 1;
        
        system.debug('yinfeng:test:searchGPL:'+searchGPL);
        //string query = 'Select p.Id, p.Name, p.Description__c, p.GPL__r.Name, p.GPL_Description__c, p.Product_Hierarchy__c, p.Product_Hierarchy__r.Product_Manager__c, p.Product_Hierarchy__r.Product_Manager__r.GIBU__c from Part__c p ';
        string query = 'Select p.Id, p.Name, p.Description__c, p.GPL__r.Name, p.GPL_Description__c,  p.Product_Hierarchy__c, p.Product_Hierarchy__r.Hierarchy_Level_Type__c, p.Product_Hierarchy__r.Description__c from Part__c p ';
        string whereClause = 'where p.Name != \'Proposal Part\' ';
        if(!SalesforceUtils.isNullOrEmpty(searchPartNumber))
        {
            searchPartNumber = '%' + searchPartNumber.replace('*', '%') + '%';          
            whereClause = whereClause + 'and p.Name like : searchPartNumber ';
        }
        if(!SalesforceUtils.isNullOrEmpty(searchPartDesc))
        {
            searchPartDesc = '%' + searchPartDesc.replace('*', '%') + '%';          
            whereClause = whereClause + 'and p.Description__c like : searchPartDesc ';
        }
        if(!SalesforceUtils.isNullOrEmpty(searchGPL))
        {
            searchGPL = '%' + searchGPL.replace('*', '%') + '%';            
            whereClause = whereClause + 'and p.GPL__r.Name like : searchGPL ';
        }
        if(!SalesforceUtils.isNullOrEmpty(searchGPLDesc))
        {
            searchGPLDesc = '%' + searchGPLDesc.replace('*', '%') + '%';            
            whereClause = whereClause + 'and p.GPL_Description__c like : searchGPLDesc ';
        }
                
        query = query + whereClause + 'limit ' + resultLimit;
        system.debug('====:'+query);
        
        /*
        for(Part__c p: database.query(query)){
            if(p.Product_Hierarchy__c == null ){
                p.Product_Hierarchy__c = '';
            }
            if(p.Product_Hierarchy__r.Hierarchy_Level_Type__c == null){
                p.Product_Hierarchy__r.Hierarchy_Level_Type__c = '';
            }
            if(p.Product_Hierarchy__r.Description__c == null){
                p.Product_Hierarchy__r.Description__c = '';
            }
            list_searchResults.add(p);
        }
        */
        list_searchResults = database.query(query);
        system.debug('yinfeng:test:searchresult:'+list_searchResults);      
        for(Part__c p : list_searchResults)
        {
            list_selectablePartList.add(new SelectPartWrapper(p)); 
        }
        
        if(list_searchResults.size() == resultLimit)
        {//
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, system.Label.Only_the_first + resultLimit + system.Label.Try_More));                     
        }
        else if(list_searchResults.size() == 0)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.Label.No_Records_Found));        //
        }
    }
    
   /**
	* This method is used to search Part according to the user input value on Sales mode
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             void
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */        
    public void DoSOSLSearch()
    {
        if(SalesforceUtils.ReplaceNullStringWithEmpty(searchSOSL).length() > 1)
        {
            list_selectablePartList.clear();        
            list_searchResults.clear();
            searchResultsPageNumber = 1;                    

            system.debug('**** - ' + searchSOSL);

            //Max results returned = 200
            List<List<Part__c>> searchSOSLResult = [FIND : searchSOSL IN ALL FIELDS RETURNING Part__c (Id, Name, Description__c, GPL__r.Name, GPL_Description__c, Product_Hierarchy__c, Product_Hierarchy__r.Hierarchy_Level_Type__c, Product_Hierarchy__r.Description__c )];
            
            list_searchResults = searchSOSLResult.get(0);
            
            //system.debug('***** - ' + searchResults);
                    
            for(Part__c p : list_searchResults)
            {
                list_selectablePartList.add(new SelectPartWrapper(p)); 
            }
            
            if(list_searchResults.size() == 0)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.Label.No_Records_Found));    //system.Label.Not_Choose_File      
            }           
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.Label.Search_Number_Limit));//
            }           
        }
        else
        {       
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, system.Label.Search_Field_Length));      //  
        }
    }
    
   /**
	* This method is used to search Part according to the Part Number on Sales mode
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             void
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */       
    public void DoPartNbrSearch() {
        List<String> partNumbers = new List<String>();
        searchString = SalesforceUtils.replaceNullStringWithEmpty(searchString).replace('\n', ',');
        for(String pNbr : SalesforceUtils.replaceNullStringWithEmpty(searchString).split(','))
        {
            partNumbers.add(pNbr.trim());
        }
        list_selectablePartList.clear();    
        list_searchResults.clear();
        searchResultsPageNumber = 1;        
        //system.debug('yinfeng:test:partNumbers.size():'+partNumbers.size());
        //system.debug('yinfeng:test:resultLimit:'+resultLimit);
        if(partNumbers.size() <= resultLimit)
        {       
            //need to add in correct price field once it's on product2
            list_searchResults = [select p.Id, p.Name, p.Description__c, p.GPL__r.Name, p.GPL_Description__c, p.Product_Hierarchy__c, p.Product_Hierarchy__r.Hierarchy_Level_Type__c, p.Product_Hierarchy__r.Description__c from Part__c p where p.Name in : partNumbers and p.Name != 'Proposal Part'];
            for(Part__c p : list_searchResults)
            {
                list_selectablePartList.add(new SelectPartWrapper(p)); 
            }

            if(list_searchResults.size() == 0)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.Label.No_Records_Found));//system.Label.Not_Choose_File          
            }                           
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.Label.Search_Up + resultLimit +  system.Label.Search_one_time));//
        }   
    }
//==================================================Search method====================================  
//==================================================Search method==================================== 
   /**
	* This method is used to cancel select all the parts on the search result part list.
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             void
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */  
    public void ClearAllCheckboxes(){
        for(SelectPartWrapper p : list_selectablePartList)
        {
            p.selected = false;
        }
    }   
   /**
	* This method is used to select all the parts on the search result part list.
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             void
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */      
    public void SelectAllCheckboxes()
    {
        for(SelectPartWrapper p : list_selectablePartList)
        {
            p.selected = true;
        }
    }

   /**
	* This method is used to jump to a specfic page for Search Result Parts list
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             void
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */  
    public void JumpToSearchResultsPage(){   
        if(searchResultsJumpToPage <= searchResultsLastPage && searchResultsJumpToPage >= 1){
            searchResultsPageNumber = searchResultsJumpToPage;
        }
        else{
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, system.Label.Page_Not_Exist));     //        
        }
    } 
    
   /**
	* This method is used to get selected (where checkbox checked) search results
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             void
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */                
    public void GetSelected() {  
        list_selectedParts.clear();
        for(SelectPartWrapper pwrapper : list_selectablePartList){           
            if(pwrapper.selected == true){  
                list_selectedParts.add(pwrapper.part);
            }
         }  
    }  
   /**
	* This method is used to go to next page for Search result Parts list
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             void
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */        
    public void SearchResultsNextPage() {
        searchResultsPageNumber++;
    }
   /**
	* This method is used to go to previous page for Search result Parts list
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             void
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */   
    public void SearchResultsPreviousPage() {
        searchResultsPageNumber--;
    }

   /**
	* This method is used to sort the Search result Part list according the different column field
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             void
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */   
    public void DoSearchResultsSort()
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
            Map<Part__c, SelectPartWrapper> sortMap = new Map<Part__c, SelectPartWrapper>();
            
            //take advantage of the fact that the index orders should match between searchResults and selectablePartList at this point
            for(integer i = 0; i < list_searchResults.size(); i++)
            {
                //add Product2 and partwrapper with matching list indexes to map
                sortMap.put(list_searchResults.get(i), list_selectablePartList.get(i));
            }
            
            //sort searchResults
            TableSortSupport.sortList(list_searchResults,searchResultsSortField,order); 
            
            list_selectablePartList.clear();
            
            //reorder selectablePartList by clearing and reinserting partwrappers from map based on new order in searchResults list
            for(Part__c result : list_searchResults)
            {
                list_selectablePartList.add(sortMap.get(result));
            }
        }
        catch (ListException e)
        {
            if(list_searchResults.size() > 0)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Sort_Error  + e.getMessage()));     //      
                //ErrorLogging.Log(e);              
            }
            else
            {
                searchResultsSortField = null;
                searchResultsPrevSortField = null;
            }
        }
        catch (Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Sort_Error  + e.getMessage()));  //          
            //ErrorLogging.Log(e);  
        }    
    }
    
   /**
	* This method is used to clear the inputtext for amount of proposal part user want to add.
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             void
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */     
    public void ClearAddProposalParts() {
        nbrProposalParts = null;
    }   
    
   /**
	* This method is used to clear all inputfield or inputtext on the advanced search section for sales mode
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             void
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */        
    public void ClearAdvancedSearch() {
        searchPartNumber = null;
        searchPartDesc = null;
        searchGPL = null;
        searchGPLDesc = null;
        searchSOSL = null;  
    }

   /**
	* This method is used to clear textarea on the search by part number section for sales mode
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             null
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */        
    public pageReference ClearPartNbrSearch() {
        searchString = null;
        return null;
    }

   /**
	* This method is used to go to previous page for sales Parts list
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             null
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */       
    public pageReference OppPartListPreviousPage() 
    {
        oppPartListPageNumber--;
        return null;
    }

   /**
	* This method is used to go to next page for Sales Parts list
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             null
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */    
    public pageReference OppPartListNextPage() 
    {
        oppPartListPageNumber++;
        return null;
    }

   /**
	* This method is used to jump to a specfic page for Sales Parts list
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             null
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */       
    public pageReference JumpToOppPartListPage()
    {
        //system.debug('yinfeng:test:oppPartListJumpToPage:'+oppPartListJumpToPage); 
        //system.debug('yinfeng:test:oppPartListLastPage:'+oppPartListLastPage);  
        if(oppPartListJumpToPage <= oppPartListLastPage && oppPartListJumpToPage >= 1){
            oppPartListPageNumber = oppPartListJumpToPage;
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, system.Label.Page_Not_Exist)); //system.Label.Not_Choose_File          
        }     
        return null;  
    }  
                
    
   /**
    * This method is used when click Delete on the Parts List PageBlock
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             null
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */  
    //delete button
    public PageReference DeleteOpportunityParts() {
        try{
            
            //get index of clicked row passed in from vf page and remove from list
            if(deleteOpportunityPartIndex != null)
            {
                list_opportunityParts.remove(deleteOpportunityPartIndex);
            }
            
            //if on last page and last page number changed, then go to new last page    
            if(oppPartListPageNumber > oppPartListLastPage)
            {
                oppPartListPageNumber = oppPartListLastPage;
            }
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, system.Label.Delete_After_Save));    //
        }
        catch (Exception e)
        {
            //ErrorLogging.Log(e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Delete_Error   + e.getMessage()));    //      
        }
        return null;
    }
    
   /**
    * This method is used to sort the Opportunity Parts List
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             void
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */  
    public void SortOpportunityPartList()
    {  
        try
        {
            //system.debug('yinfeng:test:oppPartListSortFieldPrev:'+oppPartListSortFieldPrev);
            //system.debug('yinfeng:test:oppPartListSortField:'+oppPartListSortField);
            String order = 'asc';  
    
            /*This checks to see if the same header was click two times in a row, if so   
            it switches the order.*/ 
    
            if(oppPartListSortFieldPrev == oppPartListSortField)
            {  
                order = 'desc';  
                oppPartListSortFieldPrev = null;  
            }
            else
            {  
                oppPartListSortFieldPrev = oppPartListSortField;  
            }           
            //system.debug('yinfeng:test:list_opportunityParts:'+list_opportunityParts);
            //system.debug('yinfeng:test:oppPartListSortField:'+oppPartListSortField);
            //system.debug('yinfeng:test:order:'+order);
            TableSortSupport.sortList(list_opportunityParts,oppPartListSortField,order);
        }
        catch (ListException e)
        {
            if(list_searchResults.size() > 0)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Sort_Error + e.getMessage()));    //        
                //ErrorLogging.Log(e);              
            }
            else
            {
                oppPartListSortField = null;
                oppPartListSortFieldPrev = null;
            }
        }
        catch (Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Sort_Error + e.getMessage()));   //system.Label.Not_Choose_File         
            //ErrorLogging.Log(e);  
        }       
                  
    }  

   /**
	* This method is used to set the mode such as : serach by part number, advanced search, add proposal part
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             void
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */      
    public void SetSelectedSearchMethod()
    {
        if(method == 'partNbr')
        {
            //system.debug('yinfeng:test:method');
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
        if(list_selectablePartList != null){
            list_selectablePartList.clear();
        }
        if(list_searchResults != null){
            list_searchResults.clear();
        }           
        
        searchResultsPageNumber = 1;                        
    }       


	/**
	 * This method is used to save Opportunity Parts on the page
	 *	 
	 @author Yinfeng Guo
	 @created 2012-02-29
	 @version 1.0
	 @since 23.0
  	 *
	 @return         Opportunity page according to Opportunity id
	 *
	 @changelog
	 * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
	 * - Created
	 */	  
    public PageReference SaveOpportunityParts() {   
        try
        {

            List<Opportunity_Part__c> list_oppParts2Delete = new List<Opportunity_Part__c>();
            Map<Id, Opportunity_Part__c> map_id_oppParts = new Map<Id, Opportunity_Part__c>();  
            for(Opportunity_Part__c op : list_opportunityParts){
                if(op.Id != null)                   
                {
                    //map opportunity parts by id
                    map_id_oppParts.put(op.Id, op);                 
                }
            }
            //save updates and inserts on opportunity line items            
            upsert  list_opportunityParts;
            
            for(Opportunity_Part__c savedPart : list_savedOppParts)
            {
                //check if saved list of parts contains any id's not on current list of opportunity parts
                if(!map_id_oppParts.containsKey(savedPart.Id))
                {
                    //if true, add to list for deletion
                    list_oppParts2Delete.add(savedPart);
                }
            }
            
            delete list_oppParts2Delete;
            
            //update saved list of opportunity parts (to match them as they exist in database)
            list_savedOppParts = new List<Opportunity_Part__c>(list_opportunityParts);

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, system.Label.Save_Completed));       //
        }
        catch (Exception e)
        {
            //ErrorLogging.Log(e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Error_Saving + e.getMessage()));//
            if(returnAfterSave == true)
                throw(e);                       
        }   
        return null;    
    }

	/**
	 * This method is used when click 'Return' button on vf page,
	 * this method to redirect to Opportunity page
	 *	 
	 @author Yinfeng Guo
	 @created 2012-02-29
	 @version 1.0
	 @since 23.0
  	 *
	 @return         Opportunity page according to Opportunity id
	 *
	 @changelog
	 * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
	 * - Created
	 */	
    public PageReference GotoOpportunity(){
        return new PageReference('/' + opportunityId);
    }

	/**
	 * This method is used when click 'Save' on vf page,
	 * this method to save Opportunity Part first, then redirect to Opportunity page
	 *	 
	 @author Yinfeng Guo
	 @created 2012-02-29
	 @version 1.0
	 @since 23.0
  	 *
	 @return         Opportunity page according to Opportunity id
	 *
	 @changelog
	 * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
	 * - Created
	 */	        
    public pageReference DoSaveAndReturn()
    {
        returnAfterSave = true;
        try{
            SaveOpportunityParts();
            return GotoOpportunity();           
        }
        catch (Exception e)
        {
            //ErrorLogging.Log(e, 'OpportunityPartEditController', 'doSaveAndReturn', opportunityId);
            returnAfterSave = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Error_Saving + e.getMessage()));  //  
            return null;            
        }   
    }
            
    //********************************* -=END public methods=- ************************************
    




    
    //********************************* -=BEGIN private methods=- *********************************
	/**
	 * This method is used to get the Opportunity Parts according to the Opportunity Id
	 *
	 @author Yinfeng Guo
	 @created 2012-02-29
	 @version 1.0
	 @since 23.0
	 *
	 @return 				void			
	 *
	 @changelog
	 * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
	 * - Created
	 */		    
    private void getOpportunityParts(){
        // select * method
        String objectName = 'Opportunity_Part__c';
        Map<String, Schema.SObjectField> allFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        String queryString = 'select';
        for(String s : allFields.keySet()) {
             queryString += ' ' + s + ',';
        }
        //add relationships fields that are needed. Must end in a comma.
        queryString += 'Part__r.Name,';
        system.debug('yinfeng:Test:opportunityId:'+opportunityId);
        queryString = queryString.subString(0,queryString.Length()-1) + ' from ' + objectName + ' where Opportunity__c = \''+ opportunityId + '\'';
        
        system.debug('yinfeng:Test:opportunityId:'+opportunityId);
        system.debug('yinfeng:Test:queryString:'+queryString);
        try {
            list_opportunityParts = database.query(queryString);
            
            /*
            for(Opportunity_Part__c oppPart : list_opportunityParts)
            {
                //if part number field not set on existing opportunity line item, get from related product2 record
                if(SalesforceUtils.isNullOrEmpty(oppPart.Name))
                {
                    oppPart.Name = oppPart.Part__r.Name;        
                }   
            } 
            */          
         
        } catch (QueryException e){
            //system.debug('Opportunity line item QUERY EXCEPTION = ' + e.getMessage());
            //ErrorLogging.Log(e);
        }
        //system.debug('yinfeng:list_opportunityParts:'+list_opportunityParts);
    }     
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/

   /**
    * Inner class to warp Opportunity Part 
	* This is a Inner Class : wrapper for search results to make selectable via checkbox
	* Class field contains : 1.Custom object Opportunity_Part__c 2.The index of opportunityPart list
	* Class method contains : Constructor of this class.
	*
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */      
    public class OpportunityPartWrapper{
        public Opportunity_Part__c opportunityPart{get; set; }
        public Integer index{get; set; }
        public OpportunityPartWrapper(Opportunity_Part__c op, Integer i){
            opportunityPart = op;
            index = i;
        }
    }

	/**
	 * This is a Inner Class : wrapper for search results to make selectable via checkbox
	 * Class field contains : 1.Standard object Part 2.Whether show this Part's checkbox selected on page
	 * Class method contains : Constructor of this class.
	 *
	 @author Yinfeng Guo
	 @created 2012-02-29
	 @version 1.0
	 @since 23.0
  	 *
	 @changelog
	 * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
	 * - Created
	 */	    
    public class SelectPartWrapper  
    {  
         public Part__c part{get; set;}  
         public Boolean selected {get; set;}  
         public SelectPartWrapper(Part__c a)  
         {  
             part = a;  
             selected = false;  
         }  
     }               
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
    
}