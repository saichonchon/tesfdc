/** 
 *  The controller for vf page CtrlSearchAccountForOppyPartner
 *
 @author Yinfeng Guo
 @created 2012-03-09
 @version 1.0
 @since 23.0 (Force.com ApiVersion)
 *
 @changelog
 * 2012-03-09 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Created
 */

public without sharing class CtrlSearchAccountForOppyPartner {
   
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




//==================================================Regard to Account search result list PageBlock====================================
//==================================================Regard to Account search result list PageBlock==================================== 
    //Variable mean : search Part result list to show only single page
    public List<SelectAccountWrapper> list_singlePageSelectablePart{
        get{
            List<SelectAccountWrapper> pagedList = new List<SelectAccountWrapper>();
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
    

    //sorting for search results
    public String searchResultsSortField {get; set;}  
    public String searchResultsPrevSortField {get; set;}  

    //enable checkboxes to select search results
    public List<Account> list_selectedParts = new List<Account>();
        

    public List<SelectAccountWrapper> list_selectablePartList {get; set;}  
    public List<Account> list_searchResults {get; set;}
                
//==================================================Regard to Account search result list PageBlock====================================
//==================================================Regard to Account search result list PageBlock====================================


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
    
    public Id detailPartId { set; get; } 
    
    public Boolean isSaved { set; get;}
    public Boolean isSales{ set; get; }
    public Boolean isOnlySales{ set; get; }
    public Boolean isSaveComplete{ set; get; }
    public Boolean messageOnResult{ set; get; }
    
    public Boolean isInvokedFromHome{get;set;}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private id opportunityId;   
    private String requestType;
    private static final String REQUESTTYPE_CA = 'Cable Assembly';
    private static final String REQUESTTYPE_ND = 'New Development';
    public static final String REQUESTTYPE_E = 'Extension';
    private static final String REQUESTTYPE_SO = 'Sales Only';
    private final ApexPages.standardController stdCtrl;               
    
    private map<String, String> map_urlParams;                
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
    public CtrlSearchAccountForOppyPartner() {
    	
    	map_urlParams = ApexPages.currentPage().getParameters();
    	
    	isInvokedFromHome = false;
    	if(map_urlParams.containsKey('isHome')){
    		isInvokedFromHome = true;
    	}
        targetPartId = '';
        isSaved = true;
        isOnlySales = false;
        isSaveComplete = false;
        messageOnResult = false;
        mode = '';
        isSales = false;
        addAmount = '1';
        list_selectablePartList = new List<SelectAccountWrapper>();             
        list_searchResults = new List<Account>();   
        
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
            
            oppPartListJumpToPage = oppPartListPageNumber;
            searchResultsJumpToPage = searchResultsPageNumber;
                        
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
    * This method is used to search Account according to the user input value on Lookup mode
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
    public void SearchAccount(){

        list_selectablePartList.clear();    
        list_searchResults.clear();
        searchResultsPageNumber = 1;
        
        if(SalesforceUtils.ReplaceNullStringWithEmpty(searchStringLOOKUP).length() <= 0){
            string query = 'SELECT  SALES_TERRITORY_NM__c , Global_Account_Manager__c,Id, Name, AccountNumber, BillingCity, BillingCountry, BillingStreet, Account_Manager_Name__c, ACCTMGRNM__c, Industry_Code_Comb__c, Account_Manager__c, Field_Service_Engineer_Code__c, RecordTypeId, Account__c FROM Account ';
            query = query + 'limit ' + resultLimit;
            list_searchResults = database.query(query);
            for(Account p : list_searchResults){
                list_selectablePartList.add(new SelectAccountWrapper(p)); 
            }
            if(list_searchResults.size() == resultLimit && (searchSOSLLOOKUP == null || searchSOSLLOOKUP == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, system.Label.Only_the_first + ' ' + resultLimit + ' ' + system.Label.Try_More));                     
            }
            else if(list_searchResults.size() == 0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.Label.No_Records_Found));
            }           
        }
        else{
            List<String> list_searchSOSLLOOKUP = new List<String>();
            searchStringLOOKUP = SalesforceUtils.replaceNullStringWithEmpty(searchStringLOOKUP).replace('\n', ',');
            for(String sosl : SalesforceUtils.replaceNullStringWithEmpty(searchStringLOOKUP).split(',')){
                list_searchSOSLLOOKUP.add(sosl.trim());
            }
            for(String sosl : list_searchSOSLLOOKUP){
                if(SalesforceUtils.ReplaceNullStringWithEmpty(sosl).length() > 1){
                    List<List<Account>> searchSOSLResult = [FIND : sosl IN ALL FIELDS RETURNING Account (SALES_TERRITORY_NM__c , Id, Name, Global_Account_Manager__c, AccountNumber, BillingCity, BillingCountry, BillingStreet, Account_Manager_Name__c, ACCTMGRNM__c, Industry_Code_Comb__c, Account_Manager__c, Field_Service_Engineer_Code__c, RecordTypeId, Account__c )];
                    list_searchResults = searchSOSLResult.get(0);
                    for(Account p : list_searchResults){
                        list_selectablePartList.add(new SelectAccountWrapper(p)); 
                    }
                    if(list_searchResults.size() == 0){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.Label.No_Records_Found));     
                    }           
                    else if(list_searchResults.size() > resultLimit){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.Label.Search_Number_Limit));
                    }           
                }
                else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.Label.One_Character_Error)); 
                }   
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
            Map<Account, SelectAccountWrapper> sortMap = new Map<Account, SelectAccountWrapper>();
            
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
            for(Account result : list_searchResults){
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
     * This is a Inner Class 
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
    public class SelectAccountWrapper{  
         public Account account{get; set;}  
         public Boolean selected {get; set;} 
         public SelectAccountWrapper(Account a){  
             account = a;  
             selected = false;  
         }
     }               
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
    
}