/** 
 *  This class used to search Part Number for Similar TE Part Number
 *
 @author Yinfeng Guo
 @created 2012-04-11
 @version 1.0
 @since 23.0 (Force.com ApiVersion)
 *
 @changelog
 * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Created
 */
public with sharing class CtrlSearchPartForProposal {
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

//==================================================Regard to pagination====================================
//==================================================Regard to pagination====================================    
    //Variable mean : whether to show the next page link
    public boolean isSearchByPartNumberOnly{get;set;}
    
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

    //Variable mean : the page number will jump to
    public Integer oppPartListJumpToPage {get; set;}       


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
    


    //Variable mean : the first record number on the recently page  
    public Integer oppPartListFirstRecordNumber{
        get { 
            return (oppPartListPageNumber - 1) * oppPartListPageSize + 1; 
        }
    }
//==================================================Regard to pagination====================================    
//==================================================Regard to pagination====================================








//==================================================Regard to Opportunity_Part__c Sales list PageBlock====================================
//==================================================Regard to Opportunity_Part__c Sales list PageBlock====================================

    //Variable mean : the index will delete Opportunity_Part__c
    public Integer deleteOpportunityPartIndex {get; set;} 
    //sorting for part list
    public String oppPartListSortField {get; set;}  
    public String oppPartListSortFieldPrev {get; set;}   
    

    //Variable mean : the total data select from the database
    public List<Opportunity_Part__c> list_opportunityParts {get; set;}  
    public List<Opportunity_Part__c> list_savedOppParts {get; set;}
 
    
    public Boolean returnAfterSave {get; set;}              
//==================================================Regard to Opportunity_Part__c Sales list PageBlock====================================
//==================================================Regard to Opportunity_Part__c Sales list PageBlock====================================









//==================================================Regard to Opportunity_Part__c Proposal list PageBlock====================================
//==================================================Regard to Opportunity_Part__c Proposal list PageBlock====================================

    //Variable mean : the index will delete Opportunity_Part__c
    public Integer deleteOpportunityPartIndexProposal {get; set;} 
    //sorting for part list
    public String oppPartListSortFieldProposal {get; set;}  
    public String oppPartListSortFieldPrevProposal {get; set;}   
    

    //Variable mean : the total data select from the database
    public List<Opportunity_Part__c> list_opportunityPartsProposal {get; set;}  
    public List<Opportunity_Part__c> list_savedOppPartsProposal {get; set;}
  
    
    public Boolean returnAfterSaveProposal {get; set;}              
//==================================================Regard to Opportunity_Part__c Proposal list PageBlock====================================
//==================================================Regard to Opportunity_Part__c Proposal list PageBlock====================================









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
    public CtrlSearchPartForProposal() {
        isSearchByPartNumberOnly = false;
        
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
        list_opportunityParts = new List<Opportunity_Part__c>();    
        list_opportunityPartsProposal = new List<Opportunity_Part__c>();  
        
        try{
            
            nbrProposalParts = 1;
           
            
            //set saved list of opp parts to list retrieved from db on load
            list_savedOppParts = new List<Opportunity_Part__c>(list_opportunityParts);
            list_savedOppPartsProposal = new List<Opportunity_Part__c>(list_opportunityPartsProposal);
                        
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
            
            oppPartListJumpToPage = oppPartListPageNumber;
            searchResultsJumpToPage = searchResultsPageNumber;
                        
            returnAfterSave = false;
        }
        catch (Exception e){
            if(opportunityId == null) ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Enter_Page_Wrong  ));  
            else ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Error_Loading_Page + e.getMessage()));    
        }       
    }

    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    







    
    //********************************* -=BEGIN public methods=- **********************************
    /**
     * This method is used to get select list for the amount the user want to add proposal part
     *
     @author Yin Feng
     @created 2012-03-13
     @version 1.0
     @since 23.0
     *
     @return            the return Amounts option list
     *
     @changelog
     * 2012-01-31 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */ 
    public List<SelectOption> getAmounts() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1', '1'));
        options.add(new SelectOption('2', '2'));
        options.add(new SelectOption('3', '3'));
        options.add(new SelectOption('4', '4'));
        options.add(new SelectOption('5', '5'));
        options.add(new SelectOption('6', '6'));
        options.add(new SelectOption('7', '7'));
        options.add(new SelectOption('8', '8'));
        options.add(new SelectOption('9', '9'));
        options.add(new SelectOption('10', '10'));
        return options;
    }

   /**
    * This method is used to get the proposal part id from custom setting
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             proposal part id
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */ 
    public static Id SalesOnlyRecordTypeId(){
        Id rt_id;
        if(Apex_Helper_Settings__c.getInstance('Sales Parts Only') != null) rt_id = Apex_Helper_Settings__c.getInstance('Sales Parts Only').Value__c;
        return rt_id;
    }
    
   /**
    * This method is used to get the proposal part id from custom setting
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             proposal part id
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */ 
    public static Id proposalPartId(){
        Id rt_id;
        if(Apex_Helper_Settings__c.getInstance('Proposal Part Template Id') != null) rt_id = Apex_Helper_Settings__c.getInstance('Proposal Part Template Id').Value__c;
        return rt_id;
    }

   /**
    * This method is used to get the opportunity part record type id from custom setting
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param mode         the string to decide which record type id to get from custom setting
    @return             opportunity record type id
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
        else if(mode == 'nd'){
            if(Apex_Helper_Settings__c.getInstance('New Development RT Id') != null) oppId = Apex_Helper_Settings__c.getInstance('New Development RT Id').Value__c;
        }
        else if(mode == 'e'){
            if(Apex_Helper_Settings__c.getInstance('Extension RT Id') != null) oppId = Apex_Helper_Settings__c.getInstance('Extension RT Id').Value__c;
        }
        return oppId;
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
    public pageReference ClearSearchString() {
        searchStringLOOKUP = null;
        return null;
    }


   /**
    * This method is used to search Part according to the user input value on Lookup mode
    *
    @author Yinfeng Guo
    @created 2012-04-10
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             void
    *
    @changelog
    * 2012-04-10 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */         
    public void SearchPart(){

        list_selectablePartList.clear();    
        list_searchResults.clear();
        searchResultsPageNumber = 1;
        
        if(SalesforceUtils.ReplaceNullStringWithEmpty(searchStringLOOKUP).length() <= 0){
            string query = 'Select p.Id, p.Name, p.Description__c, p.GPL__r.Name, p.GPL_Description__c,  p.Product_Hierarchy__r.Name, p.Product_Hierarchy__c, p.Product_Hierarchy__r.Hierarchy_Level_Type__c, p.Product_Hierarchy__r.Description__c from Part__c p ';
            string whereClause = 'where p.Name != \'Proposal Part\' ';
            query = query + whereClause + 'limit ' + resultLimit;
            list_searchResults = database.query(query);
            for(Part__c p : list_searchResults){
                list_selectablePartList.add(new SelectPartWrapper(p)); 
            }
            if(list_searchResults.size() == resultLimit && (searchSOSLLOOKUP == null || searchSOSLLOOKUP == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, system.Label.Only_the_first + ' ' + resultLimit + ' ' + system.Label.Try_More));                     
            }
            else if(list_searchResults.size() == 0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.Label.No_Records_Found));
            }           
        }
        else if(isSearchByPartNumberOnly == true){
            set<String> set_partNumbers = new set<String>();
            searchStringLOOKUP = SalesforceUtils.replaceNullStringWithEmpty(searchStringLOOKUP).replace('\n', ',');
        
            for(String pNbr : SalesforceUtils.replaceNullStringWithEmpty(searchStringLOOKUP).split(',')){
                set_partNumbers.add(pNbr.trim());
            }
        
            string query = 'Select Id, Name, Description__c, GPL__r.Name, GPL_Description__c,  Product_Hierarchy__r.Name, Product_Hierarchy__c, Product_Hierarchy__r.Hierarchy_Level_Type__c, Product_Hierarchy__r.Description__c from Part__c ';
            string whereClause = ' where Name != \'Proposal Part\'  and Name in :set_partNumbers ';
            system.debug('queryquery:'+query);
            query = query + whereClause + ' limit ' + resultLimit;
            system.debug('queryquery:'+query);
            list_searchResults = database.query(query);
            for(Part__c p : list_searchResults){
                list_selectablePartList.add(new SelectPartWrapper(p)); 
            }
            if(list_searchResults.size() == resultLimit && (searchSOSLLOOKUP == null || searchSOSLLOOKUP == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, system.Label.Only_the_first + ' ' + resultLimit + ' ' + system.Label.Try_More));                     
            }
            else if(list_searchResults.size() == 0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.Label.No_Records_Found));
            }           
        }
        else{
            Integer i = 0;
            String temp = '';
            String sql_bd = 'FIND ### IN ALL FIELDS RETURNING Part__c (Id, Name, Description__c, GPL__r.Name, GPL_Description__c, Product_Hierarchy__c, Product_Hierarchy__r.Name, Product_Hierarchy__r.Hierarchy_Level_Type__c, Product_Hierarchy__r.Description__c)';
            searchStringLOOKUP = SalesforceUtils.replaceNullStringWithEmpty(searchStringLOOKUP).replace('\n', ',');
            for(String sosl : SalesforceUtils.replaceNullStringWithEmpty(searchStringLOOKUP).split(',')){
                if(sosl.trim() != null && sosl.trim() != ''){
				    temp += ' \'\"' + sosl + '\"\' or';//modified by xia 2013-06-14
				    i++;
			    }
            }
            if(i <= 20){
                if(temp != ''){
                	try{
	                    temp = temp.substring(0, temp.length() - 2);
	                	sql_bd = sql_bd.replace('###', temp);
	                    List<List<Part__c>> searchSOSLResult =  search.query(sql_bd);
	                    list_searchResults = searchSOSLResult.get(0);
	                    for(Part__c p : list_searchResults){
	                        list_selectablePartList.add(new SelectPartWrapper(p)); 
	                    }
	                    if(list_searchResults.size() == 0){
	                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.Label.No_Records_Found));     
	                    }           
	                    else if(list_searchResults.size() > resultLimit){
	                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.Label.Search_Number_Limit));
	                    }
                	}
                	catch(Exception ex){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Invalid_Characters));
                    }              
                }
                else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.Label.One_Character_Error)); 
                    //return null;
                }
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, system.Label.Only_20));  
            }   
        }
        messageOnResult = true; 
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
    





    
    //********************************* -=BEGIN private methods=- *********************************
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
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
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
    
 
}