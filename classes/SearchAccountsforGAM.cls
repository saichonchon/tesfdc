/********************************************************** 
 *  The controller for vf page SearchAccountsForGamEntry
 ***********************************************************/

public without sharing class SearchAccountsforGAM {
   
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
    //Variable mean : whether to show the previous page link for Selected Account list
    public boolean gamAccountListShowPrevPageLink{
        get { 
            return (gamAccountListPageNumber > 1); 
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
    public Integer gamAccountListPageSize;
    
    //Variable mean : recently present page or the page will to show
    public Integer gamAccountListPageNumber {
        get { 
            if (gamAccountListPageNumber == null || gamAccountListPageNumber == 0) gamAccountListPageNumber = 1; 
            return gamAccountListPageNumber; 
        } 
        set;
    }

    //Variable mean : the page number will jump to
    public Integer gamAccountListJumpToPage {get; set;}       

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
            if (list_selectableaccountList == null) return 0; 
            else return list_selectableaccountList.size(); 
        }
    }    

    //Variable mean : the first record number on the recently page  
    public Integer gamAccountListFirstRecordNumber{
        get { 
            return (gamAccountListPageNumber - 1) * gamAccountListPageSize + 1; 
        }
    }
//==================================================Regard to pagination====================================    
//==================================================Regard to pagination====================================




//==================================================Regard to Account search result list PageBlock====================================
//==================================================Regard to Account search result list PageBlock==================================== 
    //Variable mean : search account result list to show only single page
    public List<SelectAccountWrapper> list_singlePageSelectableAccount{
        get{
            List<SelectAccountWrapper> pagedList = new List<SelectAccountWrapper>();
            if (list_selectableaccountList != null){
                integer startIdx = (searchResultsPageNumber - 1) * searchResultsPageSize;
                integer endIdx = startIdx + searchResultsPageSize-1;
                for (integer idx = startIdx; idx <= endIdx && list_selectableaccountList.size() > idx; idx++)
                    pagedList.add(list_selectableaccountList[idx]);
            }
            return pagedList;
        } 
        set;
    }
    

    //sorting for search results
    public String searchResultsSortField {get; set;}  
    public String searchResultsPrevSortField {get; set;}  

    //enable checkboxes to select search results
    public List<Account> list_selectedaccounts = new List<Account>();
        

    public List<SelectAccountWrapper> list_selectableaccountList {get; set;}  
    public List<Account> list_searchResults {get; set;}
                
//==================================================Regard to Account search result list PageBlock====================================
//==================================================Regard to Account search result list PageBlock====================================


//==================================================Regard to Search PageBlock====================================  
//==================================================Regard to Search PageBlock====================================
    //sosl search
    public String searchSOSL {get; set;}    
    public String searchSOSLLOOKUP {get; set;}      
    
    //account number search string
    public String searchString {get; set;}
    public String searchStringLOOKUP {get; set;}
    //advanced search fields
    private Integer resultLimit;
    public String searchaccountNumber {get; set;}
    public String searchaccountDesc {get; set;}
    public String searchGPL {get; set;}
    public String searchGPLDesc {get; set;} 

    public String searchaccountNumberLOOKUP {get; set;}
    public String searchaccountDescLOOKUP {get; set;}
    public String searchGPLLOOKUP {get; set;}
    public String searchGPLDescLOOKUP {get; set;} 
        
    //controls visibility in search section
    public String method {get; set;}
    public Boolean accountNbrMethod {get; set;}
    public Boolean advancedMethod {get; set;}
    public Boolean proposalMethod {get; set;}   

    //proposal account fields
    public Integer nbrProposalaccounts {get; set;}         
//==================================================Regard to Search PageBlock====================================  
//==================================================Regard to Search PageBlock====================================

    public String addAmount{ set; get; }
    public String targetaccountId { set; get; }
    public String mode { set; get; }
    
    public Id detailaccountId { set; get; } 
    
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
    public list<Sales_Hierarchy__c> lst_SH = new list <Sales_Hierarchy__c>();   
    public list<String> lst_GamCodes = new list <String>();
    public string AccountRecordType = 'Account';
    public string Active = 'Active';
    public String AccountGroupCode = '0001';             
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
   /******************************************************************
    * The contsructor
    *******************************************************************/      
    public SearchAccountsforGAM() {
    	
    	map_urlParams = ApexPages.currentPage().getParameters();
    	
    	isInvokedFromHome = false;
    	if(map_urlParams.containsKey('isHome')){
    		isInvokedFromHome = true;
    	}
        targetaccountId = '';
        isSaved = true;
        isOnlySales = false;
        isSaveComplete = false;
        messageOnResult = false;
        mode = '';
        isSales = false;
        addAmount = '1';
        list_selectableaccountList = new List<SelectAccountWrapper>();             
        list_searchResults = new List<Account>();  
        lst_sh= [select id , Level_7_Territory_Code__c, Level_7_Default_Owner__c, Hierarchy_Type__c 
                                from Sales_Hierarchy__c 
                                where Level_7_Default_Owner__r.ID=: UserInfo.getUserId() 
                                and  Hierarchy_Type__c = 'Global Account Manager Hierarchy (GAM)'];
        for (Sales_Hierarchy__c sh: lst_sh){
        	lst_GamCodes.add(sh.Level_7_Territory_Code__c);
        }
        
        try{
            
            nbrProposalaccounts = 1;
                        
            //set table page sizes and result limit
            OrgWideSettings__c settingsObj;
            settingsObj = OrgWideSettings__c.getValues('Default');
            
            if(settingsObj != null){  
                gamAccountListPageSize = Integer.valueOf(settingsObj.Datatable_Page_Size__c);
                searchResultsPageSize = Integer.valueOf(settingsObj.Datatable_Page_Size__c);
                resultLimit = Integer.valueOf(settingsObj.Search_Result_Limit__c);
                
            }
            else{
                gamAccountListPageSize = 6;
                searchResultsPageSize = 6;
                resultLimit = 1000;
            }
            
            gamAccountListJumpToPage = gamAccountListPageNumber;
            searchResultsJumpToPage = searchResultsPageNumber;
                        
        }
        catch (Exception e){
            if(opportunityId == null) ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Enter_Page_Wrong  ));  
            else ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Error_Loading_Page + e.getMessage()));    
        }       
    }

    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    







    
    //********************************* -=BEGIN public methods=- **********************************
    /**********************************************************************************************
     * This method is used to get select list for the amount the user want to add proposal account
     **************************************************************************************************/ 
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

   /********************************************************************************
    * This method is used to jump to a specfic page for Search Result accounts list
    *********************************************************************************/   
    public void JumpToSearchResultsPage(){   
        if(searchResultsJumpToPage <= searchResultsLastPage && searchResultsJumpToPage >= 1){
            searchResultsPageNumber = searchResultsJumpToPage;
        }
        else{
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, system.Label.Page_Not_Exist));     //        
        }
    } 
    

   /**********************************************************************************
    * This method is used to go to next page for Search result accounts list
    **********************************************************************************/     
    public void SearchResultsNextPage() {
        searchResultsPageNumber++;
    }

   /****************************************************************************************
    * This method is used to go to previous page for Search result accounts list
    ******************************************************************************************/   
    public void SearchResultsPreviousPage() {
        searchResultsPageNumber--;
    }

   /********************************************************************************************
    * This method is used to clear textarea on the search by account number section for lookup mode
    **********************************************************************************************/
    public pageReference ClearSearchString() {
        searchStringLOOKUP = null;
        return null;
    }


   /**************************************************************************************************
    * This method is used to search Account according to the user input value on Lookup mode
    *************************************************************************************************/         
    public void SearchAccount(){

        list_selectableaccountList.clear();    
        list_searchResults.clear();
        searchResultsPageNumber = 1;
        
        if(SalesforceUtils.ReplaceNullStringWithEmpty(searchStringLOOKUP).length() <= 0){
        	
        	/* TODO - Change filter criteria for accounts!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        	Filter criteria:
        		GAM Code != null 
        		LVL7 User = me	(I think this is incorrect. I think it is only for GAM code and not account number.)
				Filter on Account Status = Active too? Yes, but need to verify that there are no other questionable types that we want to include/exclude.
				Sold TO 0001 ("Accoutn Group Code")
				Account record type only
        	*/
        	
            string query = 'SELECT  SALES_TERRITORY_NM__c , Global_Account_Manager__c,Id, Name, AccountNumber, BillingCity, BillingCountry, BillingStreet, Account_Manager_Name__c, ACCTMGRNM__c, Industry_Code_Comb__c, Account_Manager__c, Field_Service_Engineer_Code__c, RecordTypeId, Account__c, GAMCD__c, Focus_Account__c FROM Account where (GAMCD__c IN :lst_GamCodes and AccountNumber!= null and recordtype.name =:AccountRecordType and STATDESC__c =: Active and ACCT_GROUP_CDE__c = :AccountGroupCode ) ';
        //    query = query + lst_GamCodes;
            
            query = query + 'limit ' + resultLimit;
            System.Debug('@@@@query'+query);
            
            list_searchResults = database.query(query);
            for(Account p : list_searchResults){
                list_selectableaccountList.add(new SelectAccountWrapper(p)); 
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
                    List<List<Account>> searchSOSLResult = [FIND : sosl IN ALL FIELDS RETURNING Account (SALES_TERRITORY_NM__c , Id, Name, GAMCD__c, Global_Account_Manager__c, AccountNumber, BillingCity, BillingCountry, BillingStreet, Account_Manager_Name__c, ACCTMGRNM__c, Industry_Code_Comb__c, Account_Manager__c, Field_Service_Engineer_Code__c, RecordTypeId, Account__c, STATDESC__c, ACCT_GROUP_CDE__c, Focus_Account__c where (STATDESC__c = 'Active' and ACCT_GROUP_CDE__c = '0001' and AccountNumber !=  Null and GAMCD__c IN:lst_GamCodes ) )];
                    list_searchResults = searchSOSLResult.get(0);
                    for(Account p : list_searchResults){
                        list_selectableaccountList.add(new SelectAccountWrapper(p)); 
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
    
   /**********************************************************************************************
    * This method is used to sort the Search result account list according the different column field
    **********************************************************************************************/   
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
            
            //create map to save checked status of accountwrapper object before re-sorting both lists
            Map<Account, SelectAccountWrapper> sortMap = new Map<Account, SelectAccountWrapper>();
            
            //take advantage of the fact that the index orders should match between searchResults and selectableaccountList at this point
            for(integer i = 0; i < list_searchResults.size(); i++){
                //add Product2 and accountwrapper with matching list indexes to map
                sortMap.put(list_searchResults.get(i), list_selectableaccountList.get(i));
            }
            
            /* TODO 
            	remove all references to accountList and GPL?????????????????????????????????????????
            */
            
            //sort searchResults
            if(searchResultsSortField != 'GPL__r.Name') 
                TableSortSupport.sortList(list_searchResults,searchResultsSortField,order); 
            
            list_selectableaccountList.clear();
            
            //reorder selectableaccountList by clearing and reinserting accountwrappers from map based on new order in searchResults list
            for(Account result : list_searchResults){
                list_selectableaccountList.add(sortMap.get(result));
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
    /***************************************************************************************************
     * This is a Inner Class 
     ***************************************************************************************************************/     
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