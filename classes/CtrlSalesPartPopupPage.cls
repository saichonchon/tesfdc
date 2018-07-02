public with sharing class CtrlSalesPartPopupPage {

   
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

    //Variable mean : the first record number on the recently page  
    public Integer oppPartListFirstRecordNumber{
        get { 
            return (oppPartListPageNumber - 1) * oppPartListPageSize + 1; 
        }
    }

    
    /******Propoasl Parts*****/
    //Variable mean : whether to show the previous page link for opportunity part list
    public boolean oppPartListShowPrevPageLinkProposal{
        get { 
            return (oppPartListPageNumberProposal > 1); 
        }
    }
    //Variable mean : whether to show the next page link for opportunity part list
    public boolean oppPartListShowNextPageLinkProposal{
        get { 
            return (oppPartListPageNumberProposal < oppPartListTotalRecordCountProposal / (oppPartListPageSizeProposal * 1.0)); 
        }
    }    

    //Variable mean : number of total page    
    public Integer oppPartListPageSizeProposal;
    
    //Variable mean : recently present page or the page will to show
    public Integer oppPartListPageNumberProposal {
        get { 
            if (oppPartListPageNumberProposal == null || oppPartListPageNumberProposal == 0) oppPartListPageNumberProposal = 1; 
            return oppPartListPageNumberProposal; 
        } 
        set;
    }
    //Variable mean : the last page number for opportunity part list
    public Integer oppPartListLastPageProposal {
        get{
            Integer lastPageNumberProposal = system.math.abs(oppPartListTotalRecordCountProposal / oppPartListPageSizeProposal);
            if(system.math.mod(oppPartListTotalRecordCountProposal, oppPartListPageSizeProposal) > 0){
                lastPageNumberProposal += 1;
            }
            return lastPageNumberProposal;
        } 
        set;
    }
    //Variable mean : the page number will jump to
    public Integer oppPartListJumpToPageProposal {get; set;}  

    //Variable mean : the last record number on the recently page
    public Integer oppPartListLastRecordNumberProposal{
        get { 
            return Math.min(oppPartListTotalRecordCountProposal, oppPartListFirstRecordNumberProposal + oppPartListPageSizeProposal - 1) ; 
        }
    }
    
    //Variable mean : the total record number
    public Integer oppPartListTotalRecordCountProposal{
        get { 
            if (list_indexOpportunityPartsProposal == null) return 0; 
            else return list_indexOpportunityPartsProposal.size(); 
        }      
    } 

    //Variable mean : the first record number on the recently page  
    public Integer oppPartListFirstRecordNumberProposal{
        get { 
            return (oppPartListPageNumberProposal - 1) * oppPartListPageSizeProposal + 1; 
        }
    }             
//==================================================Regard to pagination====================================    
//==================================================Regard to pagination====================================








//==================================================Regard to Opportunity_Part__c Sales list PageBlock====================================
//==================================================Regard to Opportunity_Part__c Sales list PageBlock====================================
    //Variable mean : opportunity parts list to show only single page
    public List<OpportunityPartWrapper> list_singlePageOpportunityParts{
        get{
            List<OpportunityPartWrapper> list_pagedParts = new List<OpportunityPartWrapper>();
            
            if (list_indexOpportunityParts != null && !list_indexOpportunityParts.isEmpty()){
            	if(oppPartListPageNumber == null) oppPartListPageNumber = 1;
                Integer startIdx = (oppPartListPageNumber - 1) * oppPartListPageSize;
                Integer endIdx = startIdx + oppPartListPageSize-1;
                for (Integer idx = startIdx; idx <= endIdx && list_indexOpportunityParts.size() > idx; idx++)
                  list_pagedParts.add(list_indexOpportunityParts[idx]);
            }
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
        
    
    //Variable mean : transfer common opportunity part list to list have specific index
    public List<OpportunityPartWrapper> list_indexOpportunityParts{
        get{
            List<OpportunityPartWrapper> list_indexOppPartWrapper = new List<OpportunityPartWrapper>();
            Integer counter = 0;
            String partName='';
            String similarName='';
            for(Opportunity_Part__c oppPart : list_opportunityParts){
                list_indexOppPartWrapper.add(new OpportunityPartWrapper(oppPart, counter, partName, similarName));//important
                counter++;  
            }
            return list_indexOppPartWrapper; 
        }
        set;
    }  
    
    public Boolean returnAfterSave {get; set;}              
//==================================================Regard to Opportunity_Part__c Sales list PageBlock====================================
//==================================================Regard to Opportunity_Part__c Sales list PageBlock====================================









//==================================================Regard to Opportunity_Part__c Proposal list PageBlock====================================
//==================================================Regard to Opportunity_Part__c Proposal list PageBlock====================================
    //Variable mean : opportunity parts list to show only single page
    public List<OpportunityPartWrapper> list_singlePageOpportunityPartsProposal{
        get{
            List<OpportunityPartWrapper> list_pagedPartsProposal = new List<OpportunityPartWrapper>();
            
            if (list_indexOpportunityPartsProposal != null && !list_indexOpportunityPartsProposal.isEmpty()){
            	if(oppPartListPageNumberProposal == null) oppPartListPageNumberProposal = 1;
                Integer startIdxProposal = (oppPartListPageNumberProposal - 1) * oppPartListPageSizeProposal;
                Integer endIdxProposal = startIdxProposal + oppPartListPageSizeProposal-1;
                for (Integer idx = startIdxProposal; idx <= endIdxProposal && list_indexOpportunityPartsProposal.size() > idx; idx++)
                  list_pagedPartsProposal.add(list_indexOpportunityPartsProposal[idx]);
            }
            return list_pagedPartsProposal;
        } 
        set;
    }
    //Variable mean : the index will delete Opportunity_Part__c
    public Integer deleteOpportunityPartIndexProposal {get; set;} 
    //sorting for part list
    public String oppPartListSortFieldProposal {get; set;}  
    public String oppPartListSortFieldPrevProposal {get; set;}   
    

    //Variable mean : the total data select from the database
    public List<Opportunity_Part__c> list_opportunityPartsProposal {get; set;}  
    public List<Opportunity_Part__c> list_savedOppPartsProposal {get; set;}
        
    
    //Variable mean : transfer common opportunity part list to list have specific index
    public List<OpportunityPartWrapper> list_indexOpportunityPartsProposal{
        get{
            List<OpportunityPartWrapper> list_indexOppPartWrapperProposal = new List<OpportunityPartWrapper>();
            Integer counter = 0;
            
            String partName='';
            String similarName='';
         /*   
            map<Id, Id> map_oppyPartId_partId_null = new  map<Id, Id>();
            map<Id, String> map_oppyPartId_PartName = new  map<Id, String>();
            map<Id, String> map_oppyPartId_SimilarName = new  map<Id, String>();
            set<Id> set_nullId = new set<Id>();
            set<Id> set_withidSimilarId = new set<Id>();
            set<Id> set_noidSimilarId = new set<Id>();
            
            for(Opportunity_Part__c oppPart : list_opportunityPartsProposal){
            	if(oppPart.Id == null && oppPart.Similar_TE_Part_Number__c == null && oppPart.GPL__c == null){
            		//set_nullId.add(oppPart.Part__c);
            		map_oppyPartId_partId_null.put(oppPart.Id, oppPart.Part__c);
            	}
            	else if(oppPart.Id == null && oppPart.Similar_TE_Part_Number__c != null){
            		set_noidSimilarId.add(oppPart.Similar_TE_Part_Number__c);
            	}
            	else if(oppPart.Id == null && oppPart.GPL__c != null){
            		
            	}
            	else if(oppPart.Id != null && oppPart.Similar_TE_Part_Number__c != null){
            		set_withidSimilarId.add(oppPart.Similar_TE_Part_Number__c);
            	}
            }
            if(!map_oppyPartId_partId_null.isEmpty()){
            	for(Part__c p : [SELECT Id, Name, Description__c from Part__c where Id in: map_oppyPartId_partId_null.value()]){
            		map_oppyPartId_PartName.put(p.Id, p.Name + ' - ' + p.Description__c);
            	}
            }
            if(!set_withidSimilarId.isEmpty()){
            	for(Part__c p : [SELECT Id, Name, Description__c from Part__c where Id in: set_withidSimilarId]){
            		map_oppyPartId_SimilarName.put(p.Id, p.Name);
            	}
            }
            if(!set_noidSimilarId.isEmpty()){
            	for(Part__c p : [SELECT Id, Name, Description__c from Part__c where Id in: set_noidSimilarId]){
            		map_oppyPartId_SimilarName.put(p.Id, p.Name);
            	}
            }
            */
            for(Opportunity_Part__c oppPart : list_opportunityPartsProposal){
            	/*if(oppPart.Id == null && oppPart.Similar_TE_Part_Number__c == null && oppPart.GPL__c == null) partName = map_oppyPartId_PartName.get(oppPart.Part__c) ;
            	//else if(oppPart.Id == null && oppPart.Similar_TE_Part_Number__c != null) partName = 'oppPart.Id = null';
            	else if(oppPart.Id != null && oppPart.Similar_TE_Part_Number__c != null && String.valueof(oppPart.Similar_TE_Part_Number__c) != ''){
            		similarName = map_oppyPartId_SimilarName.get(oppPart.Similar_TE_Part_Number__c) ;
            	}*/
                list_indexOppPartWrapperProposal.add(new OpportunityPartWrapper(oppPart, counter, partName, similarName));//important
                similarName = '';
                partName = '';
                counter++;  
            }
            return list_indexOppPartWrapperProposal; 
        }
        set;
    }  
    
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
    public CtrlSalesPartPopupPage() {
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
                
                oppPartListPageSizeProposal = Integer.valueOf(settingsObj.Datatable_Page_Size__c);
            }
            else{
                oppPartListPageSize = 6;
                searchResultsPageSize = 6;
                resultLimit = 1000;
                oppPartListPageSizeProposal = 6;
            }
            
            oppPartListJumpToPage = oppPartListPageNumber;
            searchResultsJumpToPage = searchResultsPageNumber;
            oppPartListJumpToPageProposal = oppPartListPageNumberProposal;
                        
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
	 @return 			the return Amounts option list
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
    @param mode 		the string to decide which record type id to get from custom setting
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

//==================================================Add proposal parts or existing parts to Opportunity Parts list====================================  
//==================================================Add proposal parts or existing parts to Opportunity Parts list==================================== 
   /**
	* This method is used to add specific number Proposal parts to the proposal part list
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
  	public void NewAddProposalParts() {
  		isSaved = true;
  		messageOnResult = false;
  		nbrProposalParts = Integer.valueOf(addAmount);
  		DoAddProposalParts();
  	} 

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
            Part__c TempPart = new Part__c();
            //Product_Hierarchy__c comment
            
            for(Part__c p : [select Id, Name, Description__c,  Product_Hierarchy__c, Product_Hierarchy__r.Hierarchy_Level_Type__c, Product_Hierarchy__r.Description__c from Part__c where Description__c = 'Proposal Part' limit 1]){
            	TempPart = p;
            }
            if(TempPart.Id != null){
 				for(Integer i = 0; i < nbrProposalParts; i++)
	            {
	                Opportunity_Part__c newPart = new Opportunity_Part__c();
	                system.debug('yinfeng:opportunityid:opportunityId:'+opportunityId);
	                newPart.Opportunity__c = opportunityId;  
                 	system.debug('yinfeng:opportunityid:newPart.Opportunity__c:'+newPart.Opportunity__c); 
	                /****Product_Hierarchy__c****/
	                /*  
	                if(TempPart.Product_Hierarchy__c != null && TempPart.Product_Hierarchy__r.Hierarchy_Level_Type__c != null && TempPart.Product_Hierarchy__r.Hierarchy_Level_Type__c == 'CBC1'){
	                    if(TempPart.Product_Hierarchy__r.Description__c == 'Industrial'){
	                        newPart.Product_Owning_GIBU__c = 'Industrial';
	                    }
	                    else if(TempPart.Product_Hierarchy__r.Description__c == 'Appliances'){
	                        newPart.Product_Owning_GIBU__c = 'Appliances';
	                    }
	                    else if(TempPart.Product_Hierarchy__r.Description__c == 'Data Communications'){
	                        newPart.Product_Owning_GIBU__c = 'DataComm';
	                    }
	                    else if(TempPart.Product_Hierarchy__r.Description__c == 'Consumer Devices'){
	                        newPart.Product_Owning_GIBU__c = 'Consumer Devices';
	                    }
	                }
	                else{
	                    newPart.Product_Owning_GIBU__c = 'Other BU';
	                }
	                */
	                
	                if(requestType == REQUESTTYPE_CA){
	                    newPart.RecordTypeId = oppRTId('cap');
	                }
	                else if(requestType == REQUESTTYPE_ND){
	                    newPart.RecordTypeId = oppRTId('nd');
	                }
	                else if(requestType == REQUESTTYPE_E){
	                    newPart.RecordTypeId = oppRTId('e');
	                }
	                /*
	                else if(requestType == REQUESTTYPE_SO){
	                    newPart.RecordTypeId = oppRTId('sp');
	                }   
	                */               
	                //setting defaults to avoid validation error
	                newPart.Quantity__c = 1;
	                newPart.Sales_Price__c = 0; 
	                newPart.Status__c = '50/50';
	                newPart.Temporary_Part_Name__c = TempPart.Description__c + ' - ' + TempPart.Name;
	                //newPart.Part_Name__c = TempPart.Description__c + '-' + TempPart.Name;
	                //newPart.Part__c = proposalPartId(); 
	                newPart.Part__c = TempPart.Id; 
	                list_opportunityPartsProposal.add(newPart);                             
	            }
	            oppPartListPageNumberProposal = oppPartListLastPageProposal;
	            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, nbrProposalParts +  system.Label.Parts_Added));            	
            }
            else{
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  system.Label.No_proposal_part_template));
            }
        }
        catch (QueryException e){
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
                if(SalesforceUtils.replaceNullStringWithEmpty(selected.Description__c).length() > 255)
                {
                    newPart.New_Part_Description__c = selected.Description__c.subString(0, 255);
                }
                else
                {
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
        
        string query = 'Select Id, Name, Description__c, GPL__r.Name, GPL_Description__c,  Product_Hierarchy__c, Product_Hierarchy__r.Hierarchy_Level_Type__c, Product_Hierarchy__r.Description__c from Part__c ';//
        string whereClause = 'where Name != \'Proposal Part\' ';
        if(!SalesforceUtils.isNullOrEmpty(searchPartNumber)){
            searchPartNumber = '%' + searchPartNumber.replace('*', '%') + '%';          
            whereClause = whereClause + 'and Name like : searchPartNumber ';
        }
        if(!SalesforceUtils.isNullOrEmpty(searchPartDesc)){
            searchPartDesc = '%' + searchPartDesc.replace('*', '%') + '%';          
            whereClause = whereClause + 'and Description__c like : searchPartDesc ';
        }
        if(!SalesforceUtils.isNullOrEmpty(searchGPL)){
            searchGPL = '%' + searchGPL.replace('*', '%') + '%';            
            whereClause = whereClause + 'and GPL__r.Name like : searchGPL ';
        }
        if(!SalesforceUtils.isNullOrEmpty(searchGPLDesc)){
            searchGPLDesc = '%' + searchGPLDesc.replace('*', '%') + '%';            
            whereClause = whereClause + 'and GPL_Description__c like : searchGPLDesc ';
        }
                
        query = query + whereClause + 'limit ' + resultLimit;
        system.debug('yinfeng:Test:query:'+query);
        try{
        	list_searchResults = database.query(query);
        	system.debug('yinfeng:Test:list_searchResults1:'+list_searchResults);
        }
     	catch (Exception e){
	     	system.debug('yinfeng:Test:e:'+e.getMessage());
     	}
        
        for(Part__c p : list_searchResults){
            list_selectablePartList.add(new SelectPartWrapper(p)); 
        }
        system.debug('yinfeng:Test:list_searchResults:'+list_searchResults);
        system.debug('yinfeng:Test:list_selectablePartList:'+list_selectablePartList);
        if(list_searchResults.size() == resultLimit  && (searchSOSL == null || searchSOSL == '') ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, system.Label.Only_the_first + resultLimit + system.Label.Try_More));                     
        }
        else if(list_searchResults.size() == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.Label.No_Records_Found)); 
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
        for(String pNbr : SalesforceUtils.replaceNullStringWithEmpty(searchString).split(','))
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
            for(Part__c p : list_searchResults)
            {
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

	public String idString{set;get;}
	public void GenerateSelectedPartId(){
		idString = '';
		list_selectedParts.clear();
        for(SelectPartWrapper pwrapper : list_selectablePartList){
            if(pwrapper.selected == true){ 
            	idString =  idString + ',' + pwrapper.part.Id;
                //list_selectedParts.add(pwrapper.part);
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
    public pageReference OppPartListPreviousPage(){
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
    public pageReference OppPartListNextPage(){
        oppPartListPageNumber++;
        return null;
    }

   /**
	* This method is used to go to previous page for Proposal Parts list
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
    public pageReference OppPartListPreviousPageProposal(){
        oppPartListPageNumberProposal--;
        return null;
    }

   /**
	* This method is used to go to next page for Proposal Parts list
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
    public pageReference OppPartListNextPageProposal(){
        oppPartListPageNumberProposal++;
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
                     
   /**
	* This method is used to delete Opportunity Parts for Sales Parts list
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
    public PageReference DeleteOpportunityParts() {
        try{
            //get index of clicked row passed in from vf page and remove from list
            if(deleteOpportunityPartIndex != null){
                list_opportunityParts.remove(deleteOpportunityPartIndex);
            }
            //if on last page and last page number changed, then go to new last page    
            if(oppPartListPageNumber > oppPartListLastPage){
                oppPartListPageNumber = oppPartListLastPage;
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, system.Label.Delete_After_Save));
        }
        catch (Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Delete_Error   + e.getMessage()));     
        }
        return null;
    }

	/**
	 * This method is used to delete Opportunity Parts for Proposal Parts list
	 *	 
	 @author Yinfeng Guo
	 @created 2012-02-29
	 @version 1.0
	 @since 23.0
  	 *
	 @return         null
	 *
	 @changelog
	 * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
	 * - Created
	 */	    
    public PageReference DeleteOpportunityPartsProposal() {
        try{
            //get index of clicked row passed in from vf page and remove from list
            if(deleteOpportunityPartIndexProposal != null){
                list_opportunityPartsProposal.remove(deleteOpportunityPartIndexProposal);
            }
            //if on last page and last page number changed, then go to new last page    
            if(oppPartListPageNumberProposal > oppPartListLastPageProposal){
                oppPartListPageNumberProposal = oppPartListLastPageProposal;
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, system.Label.Delete_After_Save)); 
        }
        catch (Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Delete_Error   + e.getMessage()));    
        }
        return null;
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
        try{
        	/*
        	for(Opportunity_Part__c op : list_opportunityParts){
        		if(op.Part__c != null){
        			op.GPL__c = [Select Id, GPL__c from Part__c where Id =: op.Part__c].GPL__c;
        		}
        	}
        	*/
            List<Opportunity_Part__c> list_oppParts2Delete = new List<Opportunity_Part__c>();
            Map<Id, Opportunity_Part__c> map_id_oppParts = new Map<Id, Opportunity_Part__c>();  
            for(Opportunity_Part__c op : list_opportunityParts){
                if(op.Id != null){
                    map_id_oppParts.put(op.Id, op);                 
                }
            }
            //save updates and inserts on opportunity line items            
            upsert  list_opportunityParts;
            for(Opportunity_Part__c savedPart : list_savedOppParts)
            {
                //check if saved list of parts contains any id's not on current list of opportunity parts
                if(!map_id_oppParts.containsKey(savedPart.Id)){
                    //if true, add to list for deletion
                    list_oppParts2Delete.add(savedPart);
                }
            }
            delete list_oppParts2Delete;
            
            //update saved list of opportunity parts (to match them as they exist in database)
            list_savedOppParts = new List<Opportunity_Part__c>(list_opportunityParts);



			map<Id, Id> map_id_gplid = new map<Id, Id>();
			map<Id, Id> map_id_partid = new map<Id, Id>();
			set<Id> set_oppyIds = new set<Id>();
			/* proposal parts */
        	for(Opportunity_Part__c op : list_opportunityPartsProposal){
        		if(op.Id == null && op.Part__c == proposalPartId() && (op.Similar_TE_Part_Number__c == null || String.valueOf(op.Similar_TE_Part_Number__c) == '')   && (op.GPL__c == null || String.valueOf(op.GPL__c) == '')){
        			 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  system.Label.Both_Similar_Part_Number_GPL_NULL)); 
        			 return null;
        		}
        		if(op.Id != null) set_oppyIds.add(op.Id);
        		if(op.Similar_TE_Part_Number__c != null ){//&& String.valueOf(op.Similar_TE_Part_Number__c) != ''
        			system.debug('yinfeng:Test:op.Part__c:old'+op.Part__c);
        			op.Part__c = op.Similar_TE_Part_Number__c;
        			system.debug('yinfeng:Test:op.Part__c:proposal:'+proposalPartId());
        			system.debug('yinfeng:Test:op.Part__c:'+op.Part__c);
        			//if(op.Id != null) map_id_gplid.put(op.Id, op.GPL__c);
        			//op.GPL__c = [Select Id, GPL__c from Part__c where Id =: op.Similar_TE_Part_Number__c].GPL__c;
        			//op.Similar_TE_Part_Number__c = op.Similar_TE_Part_Number__c;
        		}	
        	}
        	for(Opportunity_Part__c op : [SELECT Id, GPL__c, Part__c from Opportunity_Part__c where Id in: set_oppyIds]){
        		map_id_gplid.put(op.Id, op.GPL__c);
        		map_id_partid.put(op.Id, op.Part__c);
        	}
        	system.debug('yinfeng:Test:map_id_gplid:'+map_id_gplid);
            List<Opportunity_Part__c> list_oppParts2DeleteProposal = new List<Opportunity_Part__c>();
            Map<Id, Opportunity_Part__c> map_id_oppPartsProposal = new Map<Id, Opportunity_Part__c>();  
            for(Opportunity_Part__c op : list_opportunityPartsProposal){
                if(op.Id != null){
                    map_id_oppPartsProposal.put(op.Id, op);                 
                }
            }
            //save updates and inserts on opportunity line items  
            try{
           		upsert  list_opportunityPartsProposal;
            }
			catch (Exception e){
				system.debug('yinfeng:exception'+map_id_gplid);
				set<Id> set_oppyPartsId = new set<Id>();
				list<Integer> list_int = new list<Integer>();
				integer i = 0;
				for(Opportunity_Part__c op : list_opportunityPartsProposal){
	        		if(op.Id == null){
	        			op.GPL__c = null;
	        			op.Temporary_Part_Name__c = 'Proposal Part - Proposal Part';
	        			op.Similar_TE_Part_Number__c = null;
	        		}
	        		if(op.Id != null){
	        			system.debug('yinfeng:Test:op.GPL__c:'+op.GPL__c);
	        			if(map_id_gplid.containsKey(op.Id)) op.GPL__c = map_id_gplid.get(op.Id);
	        			if(map_id_partid.containsKey(op.Id)) op.Part__c = map_id_gplid.get(op.Id);
						set_oppyPartsId.add(op.Id);
						list_int.add(i);
	        		}
        		}
        		isSaved = true;
        		return null;
    		}
    		
            for(Opportunity_Part__c savedPart : list_savedOppPartsProposal){
                //check if saved list of parts contains any id's not on current list of opportunity parts
                if(!map_id_oppPartsProposal.containsKey(savedPart.Id)){
                    //if true, add to list for deletion
                    list_oppParts2DeleteProposal.add(savedPart);
                }
            }
            
            delete list_oppParts2DeleteProposal;
            getOpportunityParts();
            
            //update saved list of opportunity parts (to match them as they exist in database)
            list_savedOppPartsProposal = new List<Opportunity_Part__c>(list_opportunityPartsProposal);
            
            isSaved = false;
            isSaveComplete = true;  
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, system.Label.Save_Completed));  
               
        }
        catch (Exception e){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Error_Saving + e.getMessage())); 
            system.debug(system.Label.Error_Saving + e.getMessage());
            if(returnAfterSave == true) throw(e);                       
        }
        return null;    
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
    public PageReference SelectSimilarParts() {   

    	for(OpportunityPartWrapper op : list_indexOpportunityPartsProposal){
    		
    		if(op.opportunityPart.Similar_TE_Part_Number__c != null &&  String.valueOf(op.opportunityPart.Similar_TE_Part_Number__c) != ''){
    			for(Part__c p : [Select Id, Name, Description__c, GPL__c from Part__c where Id =: op.opportunityPart.Similar_TE_Part_Number__c]){
    				op.opportunityPart.GPL__c =p.GPL__c;
    				op.opportunityPart.Temporary_Part_Name__c = p.Name + ' - ' + p.Description__c;
    				//op.opportunityPart.Similar_TE_Part_Number__c = op.opportunityPart.Similar_TE_Part_Number__c;
    				//op.opportunityPart.Similar_TE_Part_Number__r.Name = p.Name;
    			}
    			
    			op.opportunityPart.Similar_TE_Part_Number__c = op.opportunityPart.Similar_TE_Part_Number__c;
    		}
    		/*
        	if(op.opportunityPart.Id == null &&  op.opportunityPart.Part__c == proposalPartId() && op.opportunityPart.Similar_TE_Part_Number__c != null){
            	String partName;
            	String partDescription;
            	for(Part__c p : [SELECT Name, Description__c from Part__c where Id =: op.opportunityPart.Similar_TE_Part_Number__c]){
            		partName = p.Name;
            		partDescription = p.Description__c;
            	}
            	//op.TembSimilarName = partName;
            	op.TembPartName = partName + ' - ' + partDescription;
            }
            else if(op.opportunityPart.Id == null && op.opportunityPart.Part__c == proposalPartId() && op.opportunityPart.GPL__c != null){
            	String gplName;
            	String galDescription;
            	for(Product_Hierarchy__c ph : [SELECT Name, Description__c from Product_Hierarchy__c where Id =: op.opportunityPart.GPL__c]){
            		gplName = ph.Name;
            		galDescription = ph.Description__c;
            	}
            	op.TembPartName = gplName + ' - ' + galDescription;
            }	*/
    	}
        messageOnResult = false;
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
    public pageReference DoSaveAndReturn(){
        returnAfterSave = true;
        try{
        	for(Opportunity_Part__c op : list_opportunityPartsProposal){
        		if((op.Similar_TE_Part_Number__c == null || String.valueOf(op.Similar_TE_Part_Number__c) == '')   && (op.GPL__c == null || String.valueOf(op.GPL__c) == '')){
        			 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  system.Label.Both_Similar_Part_Number_GPL_NULL)); 
        			 return null;
        		}
        	}
            SaveOpportunityParts();
            if(isSaveComplete) return GotoOpportunity();  
            else return null;
                     
        }
        catch (Exception e){
            returnAfterSave = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Error_Saving + e.getMessage()));    
            return null;            
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
        String queryStringSales = '';
        String queryStringProposal = '';
        for(String s : allFields.keySet()) {
             queryString += ' ' + s + ',';
        }
        queryString += 'Part__r.Name,';
        queryString += 'Similar_TE_Part_Number__r.Name,';
        queryString += 'GPL__r.Name,';
        queryString = queryString.subString(0,queryString.Length()-1) + ' from ' + objectName + ' where Opportunity__c = \''+ opportunityId + '\'';
        //queryStringSales = queryString + 'and Part__c != \''+proposalPartId()+'\' ';
     	queryStringSales = queryString + 'and RecordTypeId = \''+ oppRTId('sp') +'\' ';
        try {
            list_opportunityParts = database.query(queryStringSales);    
        } 
        catch (QueryException e){}
        
        queryStringProposal = queryString + 'and RecordTypeId != \''+oppRTId('sp')+'\' ';
        try {
            list_opportunityPartsProposal = database.query(queryStringProposal);    
        } 
        catch (QueryException e){}
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
        public String TembPartName{get; set; }
        public String TembSimilarName{get; set; }
        public OpportunityPartWrapper(Opportunity_Part__c op, Integer i, String partName, String similarName){
            opportunityPart = op;
           	index = i;
           	TembPartName = partName;
           	TembSimilarName = similarName;
           	//TembSimilarName = '';
           	/*
           	if(op.Id != null && op.Similar_TE_Part_Number__c != null){
           		for(Part__c p : [SELECT Name, Description__c from Part__c where Id =: op.Similar_TE_Part_Number__c]){
            		TembSimilarName = p.Name;
            	}
           	}
           	
            else if(op.Id == null &&  op.Part__c == proposalPartId() && op.Similar_TE_Part_Number__c != null){
            	
            	String partName;
            	String partDescription;
            	for(Part__c p : [SELECT Name, Description__c from Part__c where Id =: op.Similar_TE_Part_Number__c]){
            		partName = p.Name;
            		partDescription = p.Description__c;
            		TembSimilarName = p.Name;
            	}
            	TembPartName = partName + ' - ' + partDescription;
            }
            else if(op.Id == null && op.Part__c == proposalPartId() && op.GPL__c != null){
            	String gplName;
            	String galDescription;
            	for(Product_Hierarchy__c ph : [SELECT Name, Description__c from Product_Hierarchy__c where Id =: op.GPL__c]){
            		gplName = ph.Name;
            		galDescription = ph.Description__c;
            	}
            	TembPartName = gplName + ' - ' + galDescription;
            }
            
            else if(op.Id == null &&  op.Part__c == proposalPartId() && op.Similar_TE_Part_Number__c == null){
            	String partName;
            	String partDescription;
            	for(Part__c p : [SELECT Name, Description__c from Part__c where Id =: proposalPartId() limit 1]){
            		partName = p.Name;
            		partDescription = p.Description__c;
            	}
            	TembPartName = partName + ' - ' + partDescription;
            }
            
            else if(op.Id == null  && op.Part__c != proposalPartId()){
            	String partName;
            	String partDescription;
            	for(Part__c p : [SELECT Name, Description__c from Part__c where Id =: op.Part__c]){
            		partName = p.Name;
            		partDescription = p.Description__c;
            	}
            	TembPartName = partName + ' - ' + partDescription;
            }
            */
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