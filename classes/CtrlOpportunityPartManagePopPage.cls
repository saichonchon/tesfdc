public with sharing class CtrlOpportunityPartManagePopPage {

   
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




//==================================================Regard to pagination====================================
//==================================================Regard to pagination====================================    
 	/******Sales Parts*****/
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
           
//==================================================Regard to pagination====================================    
//==================================================Regard to pagination====================================










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

    //proposal part fields
    public Integer nbrProposalParts {get; set;}         
//==================================================Regard to Search PageBlock====================================  
//==================================================Regard to Search PageBlock====================================




        

	public String addAmount{ set; get; }
	public String targetPartId { set; get; }
	public String mode { set; get; }
	
	public Opportunity_Part__c oppPart { set; get; }
	public Id detailPartId { set; get; } 
	
	public Boolean isSaved { set; get;}
	public Boolean isSales{ set; get; }
	public Boolean isOnlySales{ set; get; }
	public Boolean isSaveComplete{ set; get; }
	public Boolean messageOnResult{ set; get; }
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private id opportunityId;   
    private String requestType;
    private static final String REQUESTTYPE_CA = 'Cable Assembly';
    private static final String REQUESTTYPE_ND = 'New Development';
    public static final String REQUESTTYPE_E = 'Extension';
    private static final String REQUESTTYPE_SO = 'Sales Only';
    private final ApexPages.standardController stdCtrl;               
                    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




	
	public Opportunity_Part__c part {get; set;}
	public String partId {get; set;}
	public String status {get; set;}	
	public String field {get;Set;}

	public String selectedOppyPartInputTextId;
		
	public CtrlOpportunityPartManagePopPage(){
		partId = ApexPages.currentPage().getParameters().get('partId');
		status = ApexPages.currentPage().getParameters().get('status');
		field = ApexPages.currentPage().getParameters().get('fieldId');

		targetPartId = '';
    	isSaved = true;
    	isOnlySales = false;
    	isSaveComplete = false;
    	messageOnResult = false;
    	mode = '';
		isSales = false;
		addAmount = '1';
        list_selectablePartList = new List<SelectPartWrapper>();             
        list_searchResults = new List<Part__c>();   
        
        try{
            nbrProposalParts = 1;
            
                        
            //set table page sizes and result limit
            OrgWideSettings__c settingsObj;
            settingsObj = OrgWideSettings__c.getValues('Default');
            
            if(settingsObj != null){  
                oppPartListPageSize = Integer.valueOf(settingsObj.Datatable_Page_Size__c);
                searchResultsPageSize = Integer.valueOf(settingsObj.Datatable_Page_Size__c);
                resultLimit = Integer.valueOf(settingsObj.Search_Result_Limit__c);
                
            }
            else{
                oppPartListPageSize = 6;
                searchResultsPageSize = 6;
                resultLimit = 1000;
            }
            
            searchResultsJumpToPage = searchResultsPageNumber;
                        
        }
        catch (Exception e){
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
        catch (ListException e)
        {
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
    //********************************* -=END public methods=- ************************************
    

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
        for(String pNbr : SalesforceUtils.replaceNullStringWithEmpty(searchStringLOOKUP).split(','))
        {
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
         public SelectPartWrapper(Part__c a){  
             part = a;  
             selected = false;  
         }  
     }    	
}