//==================================================Regard to Search PageBlock====================================  
//==================================================Regard to Search PageBlock====================================
    //sosl search
    public String searchSOSL {get; set;}    
    public String searchSOSLLOOKUP {get; set;}      
    
    //part number search string
    public String searchString {get; set;}
    public String searchStringLOOKUP {get; set;}
    //advanced search fields
    private Integer resultLimit;
    public String searchPartNumber {get; set;}
    public String searchPartDesc {get; set;}
    public String searchGPL {get; set;}
    public String searchGPLDesc {get; set;} 


    public String searchPartNumberLOOKUP {get; set;}
    public String searchPartDescLOOKUP {get; set;}
    public String searchGPLLOOKUP {get; set;}
    public String searchGPLDescLOOKUP {get; set;} 
    
        
        
    //controls visibility in search section
    public String method {get; set;}
    public Boolean partNbrMethod {get; set;}
    public Boolean advancedMethod {get; set;}
    public Boolean proposalMethod {get; set;}   

       
//==================================================Regard to Search PageBlock====================================  
//==================================================Regard to Search PageBlock====================================



	/**
	 * Variable mean : whether to show the next page link
	 */
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
    

    

    //enable checkboxes to select search results
        

    public List<SelectPartWrapper> list_selectablePartList {get; set;}  
    public List<Part__c> list_searchResults {get; set;}
                
//==================================================Regard to Part__c search result list PageBlock====================================
//==================================================Regard to Part__c search result list PageBlock====================================





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
    public class SelectPartWrapper{  
         public Part__c part{get; set;}  
         public Boolean selected {get; set;}  
         public SelectPartWrapper(Part__c a){  
             part = a;  
             selected = false;  
         }  
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
    public void DoSearchResultsSort(){  
        try {
            String order = 'asc';  
    
            /*This checks to see if the same header was click two times in a row, if so it switches the order.*/ 
    
            if(searchResultsPrevSortField == searchResultsSortField){  
                order = 'desc';  
                searchResultsPrevSortField = null;  
            }
            else{  
                searchResultsPrevSortField = searchResultsSortField;  
            }  
            
            //create map to save checked status of partwrapper object before re-sorting both lists
            Map<Part__c, SelectPartWrapper> sortMap = new Map<Part__c, SelectPartWrapper>();
            
            //take advantage of the fact that the index orders should match between searchResults and selectablePartList at this point
            for(integer i = 0; i < list_searchResults.size(); i++){
                //add Product2 and partwrapper with matching list indexes to map
                sortMap.put(list_searchResults.get(i), list_selectablePartList.get(i));
            }
            
            //sort searchResults
            if(searchResultsSortField != 'GPL__r.Name') 
            	TableSortSupport.sortList(list_searchResults,searchResultsSortField,order); 
            
            list_selectablePartList.clear();
            
            //reorder selectablePartList by clearing and reinserting partwrappers from map based on new order in searchResults list
            for(Part__c result : list_searchResults){
                list_selectablePartList.add(sortMap.get(result));
            }
        }
        catch (ListException e){
            if(list_searchResults.size() > 0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Sort_Error  + e.getMessage()));     //      
            }
            else{
                searchResultsSortField = null;
                searchResultsPrevSortField = null;
            }
        }
        catch (Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Sort_Error  + e.getMessage()));  //          
        }    
    }       
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
        
        string query = 'Select p.Id, p.Name, p.Description__c, p.GPL__r.Name, p.GPL_Description__c,  p.Product_Hierarchy__c, p.Product_Hierarchy__r.Hierarchy_Level_Type__c, p.Product_Hierarchy__r.Description__c from Part__c p ';
        string whereClause = 'where p.Name != \'Proposal Part\' ';
        if(!SalesforceUtils.isNullOrEmpty(searchPartNumber)){
            searchPartNumber = '%' + searchPartNumber.replace('*', '%') + '%';          
            whereClause = whereClause + 'and p.Name like : searchPartNumber ';
        }
        if(!SalesforceUtils.isNullOrEmpty(searchPartDesc)){
            searchPartDesc = '%' + searchPartDesc.replace('*', '%') + '%';          
            whereClause = whereClause + 'and p.Description__c like : searchPartDesc ';
        }
        if(!SalesforceUtils.isNullOrEmpty(searchGPL)){
            searchGPL = '%' + searchGPL.replace('*', '%') + '%';            
            whereClause = whereClause + 'and p.GPL__r.Name like : searchGPL ';
        }
        if(!SalesforceUtils.isNullOrEmpty(searchGPLDesc)){
            searchGPLDesc = '%' + searchGPLDesc.replace('*', '%') + '%';            
            whereClause = whereClause + 'and p.GPL_Description__c like : searchGPLDesc ';
        }
                
        query = query + whereClause + 'limit ' + resultLimit;
        
        list_searchResults = database.query(query);
        for(Part__c p : list_searchResults){
            list_selectablePartList.add(new SelectPartWrapper(p)); 
        }
        
        if(list_searchResults.size() == resultLimit  && (searchSOSL == null || searchSOSL == '') ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, system.Label.Only_the_first + resultLimit + system.Label.Try_More));                     
        }
        else if(list_searchResults.size() == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.Label.No_Records_Found));        //
        }
        
        DoSOSLSearch();
        messageOnResult = true;
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
    public void DoSOSLSearch(){
        if(SalesforceUtils.ReplaceNullStringWithEmpty(searchSOSL).length() > 1){
            list_selectablePartList.clear();        
            list_searchResults.clear();
            searchResultsPageNumber = 1;                    

            system.debug('**** - ' + searchSOSL);

            //Max results returned = 200
            List<List<Part__c>> searchSOSLResult = [FIND : searchSOSL IN ALL FIELDS RETURNING Part__c (Id, Name, Description__c, GPL__r.Name, GPL_Description__c, Product_Hierarchy__c, Product_Hierarchy__r.Hierarchy_Level_Type__c, Product_Hierarchy__r.Description__c )];
            
            list_searchResults = searchSOSLResult.get(0);
            
            //system.debug('***** - ' + searchResults);
                    
            for(Part__c p : list_searchResults){
                list_selectablePartList.add(new SelectPartWrapper(p)); 
            }
            
            if(list_searchResults.size() == 0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.Label.No_Records_Found));    //system.Label.Not_Choose_File      
            }           
            else if(list_searchResults.size() > resultLimit){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.Label.Search_Number_Limit));//
            }           
        }
        else{       
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, system.Label.Search_Field_Length));      //  
        }
    }
    
   /**
	* This method is used to search Part according to the combine condition user input on Lookup mode
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
    public void DoAdvancedSearchLOOKUP() {        

        list_selectablePartList.clear();    
        list_searchResults.clear();
        searchResultsPageNumber = 1;
        
        string query = 'Select p.Id, p.Name, p.Description__c, p.GPL__r.Name, p.GPL_Description__c,  p.Product_Hierarchy__c, p.Product_Hierarchy__r.Hierarchy_Level_Type__c, p.Product_Hierarchy__r.Description__c from Part__c p ';
        string whereClause = 'where p.Name != \'Proposal Part\' ';
        if(!SalesforceUtils.isNullOrEmpty(searchPartNumberLOOKUP)){
            searchPartNumberLOOKUP = '%' + searchPartNumberLOOKUP.replace('*', '%') + '%';          
            whereClause = whereClause + 'and p.Name like : searchPartNumberLOOKUP ';
        }
        if(!SalesforceUtils.isNullOrEmpty(searchPartDescLOOKUP)){
            searchPartDescLOOKUP = '%' + searchPartDescLOOKUP.replace('*', '%') + '%';          
            whereClause = whereClause + 'and p.Description__c like : searchPartDescLOOKUP ';
        }
        if(!SalesforceUtils.isNullOrEmpty(searchGPLLOOKUP)){
            searchGPLLOOKUP = '%' + searchGPLLOOKUP.replace('*', '%') + '%';            
            whereClause = whereClause + 'and p.GPL__r.Name like : searchGPLLOOKUP ';
        }
        if(!SalesforceUtils.isNullOrEmpty(searchGPLDescLOOKUP)){
            searchGPLDescLOOKUP = '%' + searchGPLDescLOOKUP.replace('*', '%') + '%';            
            whereClause = whereClause + 'and p.GPL_Description__c like : searchGPLDescLOOKUP ';
        }
                
        query = query + whereClause + 'limit ' + resultLimit;
        
        list_searchResults = database.query(query);
        for(Part__c p : list_searchResults){
            list_selectablePartList.add(new SelectPartWrapper(p)); 
        }
        
        if(list_searchResults.size() == resultLimit && (searchSOSLLOOKUP == null || searchSOSLLOOKUP == '')){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, system.Label.Only_the_first + ' ' + resultLimit + ' ' + system.Label.Try_More));                     
        }
        else if(list_searchResults.size() == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.Label.No_Records_Found));        //
        }
        
        DoSOSLSearchLOOKUP();
        
        messageOnResult = true;
    }

   /**
	* This method is used to search Part according to the user input value on Lookup mode
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
    public void DoSOSLSearchLOOKUP(){
        if(SalesforceUtils.ReplaceNullStringWithEmpty(searchSOSLLOOKUP).length() > 1){
            list_selectablePartList.clear();        
            list_searchResults.clear();
            searchResultsPageNumber = 1;                    

            system.debug('**** - ' + searchSOSLLOOKUP);

            //Max results returned = 200
            List<List<Part__c>> searchSOSLResult = [FIND : searchSOSLLOOKUP IN ALL FIELDS RETURNING Part__c (Id, Name, Description__c, GPL__r.Name, GPL_Description__c, Product_Hierarchy__c, Product_Hierarchy__r.Hierarchy_Level_Type__c, Product_Hierarchy__r.Description__c )];
            
            list_searchResults = searchSOSLResult.get(0);
            
            //system.debug('***** - ' + searchResults);
                    
            for(Part__c p : list_searchResults){
                list_selectablePartList.add(new SelectPartWrapper(p)); 
            }
            
            if(list_searchResults.size() == 0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.Label.No_Records_Found));    //system.Label.Not_Choose_File      
            }           
            else if(list_searchResults.size() > resultLimit){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.Label.Search_Number_Limit));//
            }           
        }
        else{       
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, system.Label.Search_Field_Length));      //  
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
        for(String pNbr : SalesforceUtils.replaceNullStringWithEmpty(searchString).split(',')){
            partNumbers.add(pNbr.trim());
        }
        list_selectablePartList.clear();    
        list_searchResults.clear();
        searchResultsPageNumber = 1;        
        if(partNumbers.size() <= resultLimit)
        {       
            //need to add in correct price field once it's on product2
            list_searchResults = [select p.Id, p.Name, p.Description__c, p.GPL__r.Name, p.GPL_Description__c, p.Product_Hierarchy__c, p.Product_Hierarchy__r.Hierarchy_Level_Type__c, p.Product_Hierarchy__r.Description__c from Part__c p where p.Name in : partNumbers and p.Name != 'Proposal Part'];
            for(Part__c p : list_searchResults){
                list_selectablePartList.add(new SelectPartWrapper(p)); 
            }

            if(list_searchResults.size() == 0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.Label.No_Records_Found));//system.Label.Not_Choose_File          
            }                           
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.Label.Search_Up + resultLimit +  system.Label.Search_one_time));//
        }
        messageOnResult = true;   
    }
    
   /**
	* This method is used to search Part according to the Part Number on Lookup mode
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
    public void DoPartNbrSearchLOOKUP() {
        List<String> partNumbers = new List<String>();
        searchStringLOOKUP = SalesforceUtils.replaceNullStringWithEmpty(searchStringLOOKUP).replace('\n', ',');
        for(String pNbr : SalesforceUtils.replaceNullStringWithEmpty(searchStringLOOKUP).split(',')){
            partNumbers.add(pNbr.trim());
        }
        list_selectablePartList.clear();    
        list_searchResults.clear();
        searchResultsPageNumber = 1;        
        if(partNumbers.size() <= resultLimit){       
            //need to add in correct price field once it's on product2
            list_searchResults = [select p.Id, p.Name, p.Description__c, p.GPL__r.Name, p.GPL_Description__c, p.Product_Hierarchy__c, p.Product_Hierarchy__r.Hierarchy_Level_Type__c, p.Product_Hierarchy__r.Description__c from Part__c p where p.Name in : partNumbers and p.Name != 'Proposal Part'];
            for(Part__c p : list_searchResults){
                list_selectablePartList.add(new SelectPartWrapper(p)); 
            }

            if(list_searchResults.size() == 0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.Label.No_Records_Found));//system.Label.Not_Choose_File          
            }                           
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.Label.Search_Up + resultLimit +  system.Label.Search_one_time));//
        }
        messageOnResult = true;    
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
        for(SelectPartWrapper p : list_selectablePartList){
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
    public void SelectAllCheckboxes(){
        for(SelectPartWrapper p : list_selectablePartList){
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
        try{
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
                /******Product_Hierarchy__c******/
                /*
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
                */   
                /*     
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
                 */   
                newPart.RecordTypeId = oppRTId('sp');        
                //newPart.Name = selected.Name;
                //add part desc as line item description
                if(SalesforceUtils.replaceNullStringWithEmpty(selected.Description__c).length() > 255){
                    newPart.New_Part_Description__c = selected.Description__c.subString(0, 255);
                }
                else{
                    newPart.New_Part_Description__c = selected.Description__c;              
                }
             	newPart.Temporary_Part_Name__c = selected.Name + ' - ' + selected.Description__c;
                newPart.Part__c = selected.Id;
                //setting defaults to avoid validation error
                newPart.Quantity__c = 1;
                newPart.GPL__c = selected.GPL__c;
                newPart.Status__c = '50/50';
                newPart.Sales_Price__c = 0.00;                  
                list_opportunityParts.add(newPart);                         
            }
            
            //system.debug('***** - 2 - ' + oppParts);
            oppPartListPageNumber = oppPartListLastPage;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, list_selectedParts.size() +  system.Label.Parts_Added)); //
            //selectedParts.clear();
            clearAllCheckboxes();
            //SaveOpportunityParts();
        }
        catch (Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Add_Part_Error + e.getMessage()));   //         
            //ErrorLogging.Log(e);  
        }
        messageOnResult = false;        
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
	* This method is used to clear all inputfield or inputtext on the advanced search section for lookup mode
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
    public void ClearAdvancedSearchLOOKUP() {
        searchPartNumberLOOKUP = null;
        searchPartDescLOOKUP = null;
        searchGPLLOOKUP = null;
        searchGPLDescLOOKUP = null;
        searchSOSLLOOKUP = null;  
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
	* This method is used to clear textarea on the search by part number section for lookup mode
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
    public pageReference ClearPartNbrSearchLOOKUP() {
        searchStringLOOKUP = null;
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
    public pageReference JumpToOppPartListPage(){
        if(oppPartListJumpToPage <= oppPartListLastPage && oppPartListJumpToPage >= 1){
            oppPartListPageNumber = oppPartListJumpToPage;
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, system.Label.Page_Not_Exist)); //system.Label.Not_Choose_File          
        }     
        return null;  
    }  

   /**
	* This method is used to jump to a specfic page for Proposal Parts list
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
    public pageReference JumpToOppPartListPageProposal(){
        if(oppPartListJumpToPageProposal <= oppPartListLastPageProposal && oppPartListJumpToPageProposal >= 1){
            oppPartListPageNumberProposal = oppPartListJumpToPageProposal;
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, system.Label.Page_Not_Exist)); //system.Label.Not_Choose_File          
        }     
        return null;  
    } 
    
    
    
    
    
  
    
    
    
    
    
    
    
    



   