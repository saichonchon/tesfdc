/** 
*    Controller for ExtBudgetPlanning page fix limit
*
@author Min Liu
@created 2012-04-25
@version 1.0
@since 23.0 (Force.com ApiVersion)
*
@changelog
* 2012-04-25 Min Liu <min.liu@itbconsult.com>
* - Created
* 2015-07-20 Bin Yuan <bin.yuan@oinio.com>
* - Modified due to R-89 :: Remove edit restriction on budget after approval / open locked budgets 
* 2016-05-26 Lei Tang <lei.tang@oinio.com>
* - Modified :: fix view status
*/
public without sharing class ExtBudgetPlanning {
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public String link_BudgetPlanAccounts{get;set;}
    public String link_OtherAccountsInTerritory{get;set;}
    public String link_WonOpportunities{get;set;}
    public String link_CommitOpportunities{get;set;}
    public String link_LikelyOpportunities{get;set;}
    public String link_5050Opportunities{get;set;}
    public String link_WeakOpportunities{get;set;}

    public Budget__c budget {get; set;}
    public String mode {get; set;}
    public Boolean showEdit {get; set;}
    public Boolean showNext {get; set;}
    public Boolean isNew {get; set;}
    public String theTerritory {get; set;}
    public List<SelectOption> list_territoryItems {get; set;}
    public List<SelectOption> list_yearItems {get; set;}
    //comment out by Lei Tang 2016-05-30
    //public transient List<ClsAnnualBudgetPlanStructure> list_budgetPlanStructure {get; set;}
    //added by Lei Tang 2016-07-12
    public ClsAnnualBudgetPlanStructureTemp otherBudgetPlanStructuretemp {get; set;}
    public transient ClsAnnualBudgetPlanStructure otherBudgetPlanStructure {get; set;}
    public String format {get; set;}
    public Boolean isRecalculate {get; set;}
    public Boolean isTerritoryChanged {get; set;}
    public Boolean invalidBudget {get;Set;}
    public Boolean sameTerriotry {get; set;}
    public BudgetPlanningInfo bpInfo{get;set;}
    public ClsAnnualBudgetPlanStructure totalBudgetPlan {get; set;} 
    public set<String> set_parentIds {get; set;}
    //Modified by Bin Yuan<bin.yuan@oinio.com> 2016-02-02 due to view state issue
    //public Map<String, ClsAnnualBudgetPlanStructure> map_accId_budgetPlanStructure;
    public Map<String, ClsAnnualBudgetPlanStructure> map_accId_budgetPlanStructure;
    public List<String> list_years = new List<String>(); 
    public String currentFiscalYear;
    
    public String firstBackURL {get;set;}   //added 2013-07-01 minghao.li@itbconsult.com
    
    //added by Lei Tang 2016-07-12 fix view state
    public transient String otherBPJsonStr {get;set;}
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private id userId;
    private final ApexPages.standardController stdCtrl;    
    private map<String, String> map_territoryId_Name = new map<String, String>();
    private Set<String> set_allTerritorys = new Set<String>();
    private list<String> list_allTerritoryAccIds = new list<String>();
    private List<String> list_individualParentChildIds = new List<String>();
    private map<String, Id> map_budgetDetail_recordTypeId = new map<String, Id>();
    private map<String, map<String,Budget_Detail__c>> map_existingDetails = new map<String, map<String,Budget_Detail__c>>();
    private String str_territoryCode = '';
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    public ExtBudgetPlanning(ApexPages.standardController stdCtrl){
        this.stdCtrl = stdCtrl;
        budget = (Budget__c) this.stdCtrl.getRecord();
        bpInfo = new BudgetPlanningInfo();
        this.otherBPJsonStr = '';
        
        //START added 2013-07-01 minghao.li@itbconsult.com
        this.firstBackURL = Apexpages.currentPage().getParameters().get('retURL');
        if(firstBackURL == null || firstBackURL == ''){
            this.firstBackURL = '/'+Budget__c.SObjectType.getDescribe().getKeyPrefix()+'/o';
        //  '/a19/o';
        }
        //END added 2013-07-01 minghao.li@itbconsult.com
        
        
        showEdit = false;
        isRecalculate = false;
        isTerritoryChanged = false;
        invalidBudget = false;
        sameTerriotry = true;
        userId = UserInfo.getUserId();
        currentFiscalYear = ClsBudgetPlanningUtil.getCurrentFiscalYear();
        //userId = '005E0000000XlEJ'; //only for Test
        mode = 'view';  
        isNew = true;
        theTerritory = '';
        showNext = false;
        set_parentIds = new set<String>();
        // get the record type Id of Budget Deails
        
        for(RecordType rt : [Select Id, DeveloperName from RecordType where SobjectType = 'Budget_Detail__c']){
            map_budgetDetail_recordTypeId.put(rt.DeveloperName, rt.Id);
        }   
        
        totalBudgetPlan = new ClsAnnualBudgetPlanStructure(null);      
        totalBudgetPlan.type = 'Total';  
        ClsAnnualBudgetPlanStructure otherBudgetPlanStructure = new ClsAnnualBudgetPlanStructure(null);
        otherBudgetPlanStructure.type = 'Other';     
                             
        // calculate total budget detail
        //comment out by Lei Tang 2016-05-30
        //list_budgetPlanStructure = new List<ClsAnnualBudgetPlanStructure>(); 
        map_accId_budgetPlanStructure = new Map<String, ClsAnnualBudgetPlanStructure>();        
        // get number format
        
        if(budget.Id == null){ 
            budget = new Budget__c();
            budget.Territory__c = null;
            budget.Year__c = null;
            budget.CurrencyIsoCode = 'USD'; //budget always usd
            initTerritoryItems();
            initYearItems();            
            getAllTerritoryByUser(userId); 
            list_years = ClsBudgetPlanningUtil.getDefaultYearList(2);
            addDefaultYearItems();       
            mode = 'edit';
            showEdit = true;
        }
        else{
            budget = ClsBudgetPlanningUtil.getBudgetPlanById(budget.Id);
            initTerritoryItems();
            initYearItems();     
            //Added by Bin Yuan due to fix nullpointer exception       
            //list_territoryItems.add(new SelectOption(budget.Territory__c, budget.Territory__r.Level_7_Territory_Code__c));
            if(budget.Territory__c != null) {
                list_territoryItems.add(new SelectOption(budget.Territory__c, budget.Territory__r.Level_7_Territory_Code__c));
            }
            //end add
            list_yearItems.add(new SelectOption(budget.Year__c, budget.Year__c));
            //Modified by Bin Yuan 2015-07-20 due to R-89 :: Remove edit restriction on budget after approval / open locked budgets
            //if(budget.OwnerId == userId && budget.Status__c == 'Draft' && budget.Year__c != '2013'){
            if(budget.OwnerId == userId && budget.Status__c != 'Submitted' && budget.Year__c != '2013'){
                showEdit = true;
            }    
            theTerritory = budget.Territory__c;
            map_territoryId_Name.put(budget.Territory__c, budget.Territory__r.Level_7_Territory_Code__c);  
            isNew = false;
            sameTerriotry = checkTerritoryHiearchy();
            if(ApexPages.currentPage().getParameters().get('mode') != null){
                mode = ApexPages.currentPage().getParameters().get('mode');
            }  
            if(mode == 'edit'){
                if(budget.Year__c != '2013' && !sameTerriotry && budget.OwnerId == userId){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.Msg_Budget_planning_recalculation));  
                    isRecalculate = true;      
                }  
                recalculateBudget();                    
            }  
            else{     
                userId = budget.OwnerId; // for admin                        
                buildBudgetPlanStructure();  
            }         
        }
        if(map_accId_budgetPlanStructure.get(null) != null) {
        	otherBudgetPlanStructure = map_accId_budgetPlanStructure.get(null);
        	map_accId_budgetPlanStructure.remove(null);
        	
        	//added by Lei Tang 2016-07-12
	        this.otherBudgetPlanStructuretemp = new ClsAnnualBudgetPlanStructureTemp(otherBudgetPlanStructure);
	        this.otherBPJsonStr = Json.serialize(otherBudgetPlanStructure);
        }
        
        InitReportIds();    
        system.debug('!@# this.otherBPJsonStr:'+this.otherBPJsonStr);
        
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  'budget : ' + budget + ''));
    }
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
    /**
    * The method is used to enter edit mode
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return             
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public PageReference editBudget(){
        /*
        mode = 'edit';
        invalidBudget = !sameTerriotry;
        if(budget.Year__c != '2013' && invalidBudget && budget.OwnerId == userId){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.Msg_Budget_planning_recalculation));  
            isRecalculate = true;
            rebuildBugdetAccounts();
            if(!map_accId_budgetPlanStructure.isEmpty()){
                ClsBudgetPlanningUtil.buildBudgetByAccountId(budget.Year__c, currentFiscalYear, map_accId_budgetPlanStructure, list_allTerritoryAccIds, budget, totalBudgetPlan);
            }     
            resortBugdetAccounts();           
        }         
        return null;
        */
        PageReference pageRef = new PageReference('/apex/ExtBudgetPlanning?id=' + budget.Id + '&mode=edit');
        pageRef.setRedirect(true);
        return pageRef;         
    }
    
    /**
    * The method is used to redirect to break down page from view page
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return             
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public pageReference goToBreakDown(){
        return new PageReference('/apex/ExtBudgetPlanningBreakDown?id=' + budget.Id);  
    }   
     
    public list<ClsAnnualBudgetPlanStructure> getBudgetPlanStructureList() {
        //list<ClsAnnualBudgetPlanStructure> list_budgetPlanStructure = new list<ClsAnnualBudgetPlanStructure>();
        return this.map_accId_budgetPlanStructure.values();
    }
    
    /**
    * This method is used to check if budget FQ values correct after territory changed
    *
    @author Bin Yuan
    @created 2013-10-16
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @changelog
    * 2013-10-16 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public void checkBudgetFQValue() {
        //Added by Bin Yuan 2013-10-16 :: due to account territory changed value don't match error
        if(mode == 'view') {
            decimal tempFQ4_CMA, tempFQ4_Direct, tempFQ4_POS, tempFQ4_Total;
            //tempFQ4_CMA =  totalBudgetPlan.detailCMA.TotalBudget - budget.FQ1_CMA__c - budget.FQ2_CMA__c - budget.FQ3_CMA__c; 
            //tempFQ4_Direct =  totalBudgetPlan.detailDirect.TotalBudget - budget.FQ1_Direct__c - budget.FQ2_Direct__c - budget.FQ3_Direct__c; 
            //tempFQ4_POS =  totalBudgetPlan.detailPOS.TotalBudget - budget.FQ1_POS__c - budget.FQ2_POS__c - budget.FQ3_POS__c; 
            //tempFQ4_Total =  totalBudgetPlan.detailTotal.TotalBudget - budget.FQ1_Total__c - budget.FQ2_Total__c - budget.FQ3_Total__c; 
            
            //Added by Kevin Shen 2016-04-14 :: check value if it 's equals to null
            
            tempFQ4_CMA = (totalBudgetPlan.detailCMA.TotalBudget == null? 0 : totalBudgetPlan.detailCMA.TotalBudget) - (budget.FQ1_CMA__c == null ? 0 : budget.FQ1_CMA__c) - (budget.FQ2_CMA__c == null?0:budget.FQ2_CMA__c) - (budget.FQ3_CMA__c == null?0:budget.FQ3_CMA__c); 

            tempFQ4_Direct =(totalBudgetPlan.detailDirect.TotalBudget == null ? 0 : totalBudgetPlan.detailDirect.TotalBudget) - (budget.FQ1_Direct__c == null?0:budget.FQ1_Direct__c) - (budget.FQ2_Direct__c == null?0:budget.FQ2_Direct__c) - (budget.FQ3_Direct__c == null?0:budget.FQ3_Direct__c); 

            tempFQ4_POS =  (totalBudgetPlan.detailPOS.TotalBudget == null ? 0: totalBudgetPlan.detailPOS.TotalBudget) - (budget.FQ1_POS__c == null?0:budget.FQ1_POS__c) - (budget.FQ2_POS__c == null?0:budget.FQ2_POS__c) - (budget.FQ3_POS__c == null?0:budget.FQ3_POS__c); 

            tempFQ4_Total =  (totalBudgetPlan.detailTotal.TotalBudget == null ? 0 : totalBudgetPlan.detailTotal.TotalBudget) - (budget.FQ1_Total__c == null?0:budget.FQ1_Total__c) - (budget.FQ2_Total__c == null?0:budget.FQ2_Total__c) - (budget.FQ3_Total__c ==null?0:budget.FQ3_Total__c); 

            
            if(budget.FQ4_CMA__c != tempFQ4_CMA || budget.FQ4_Direct__c != tempFQ4_Direct || budget.FQ4_POS__c != tempFQ4_POS) {
                budget.FQ4_CMA__c = tempFQ4_CMA;
                budget.FQ4_Direct__c = tempFQ4_Direct;
                budget.FQ4_POS__c = tempFQ4_POS;
                budget.FQ4_Total__c = tempFQ4_Total;
                update budget;
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'budget :: ' + budget));  
            } 
        }
        //End 
    }
    /**
    * This method is used to recalculate budget
    *
    @author Min Liu
    @created 2012-11-27
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param
    *
    @return            
    *
    @changelog
    * 2012-11-27 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    @TestVisible private void rebuildBugdetAccounts(){
        clearBugdetAccounts();
        list_individualParentChildIds = getValidAccountsByAMTerritory(userId, map_territoryId_Name.get(theTerritory), map_accId_budgetPlanStructure);        
        list_allTerritoryAccIds.addAll(list_individualParentChildIds);  
        //comment out By Lei Tang 2016-05-30
        map_accId_budgetPlanStructure.put(null,otherBudgetPlanStructure);
        getOtherAccountsByAMTerritory(userId, map_territoryId_Name.get(theTerritory), list_allTerritoryAccIds, otherBudgetPlanStructure);
        list_allTerritoryAccIds.addAll(otherBudgetPlanStructure.list_childIds);
		system.debug('!@# this.otherBudgetPlanStructure:'+this.otherBudgetPlanStructure);
    }
    
    @TestVisible private Boolean checkTerritoryHiearchy(){
        map<String, set<String>> map_pId_childIds = new map<String, set<String>>();
        //Added by Bin Yuan 2013-10-14 :: due to fix account territory changed bug
        str_territoryCode = map_territoryId_Name.get(theTerritory);
        //for(Budget_Detail__c bd : [Select Id from Budget_Detail__c where Budget__c = :budget.Id and Account__r.SALES_TERRITORY_CDE__c != :budget.Territory__r.Level_7_Territory_Code__c limit 1]){        
        for(Budget_Detail__c bd : [Select Id from Budget_Detail__c where Budget__c = :budget.Id and Account__r.SALES_TERRITORY_CDE__c != :budget.Territory__r.Level_7_Territory_Code__c And Account_Territory_Code__c =: str_territoryCode ]){      
        //End   
            return false;
        }

        Set<Id> set_accIds = new set<Id>();
        //Added by Bin Yuan 2013-10-14 :: due to fix account territory changed bug
        //for(Budget_Detail__c bd : [Select Id, Account__c, RecordType.DeveloperName, Parent_Account__c from Budget_Detail__c where Budget__c = :budget.Id]){
        system.debug('!@# theTerritory :: ' + theTerritory);
        for(Budget_Detail__c bd : [Select Id, Account__c, RecordType.DeveloperName, Parent_Account__c from Budget_Detail__c where Budget__c = :budget.Id And Account_Territory_Code__c =: str_territoryCode]){
        //End   
            if(bd.RecordType.DeveloperName == 'Other'){
                if(!map_pId_childIds.containsKey(null)){
                    map_pId_childIds.put(null, new set<String>());
                }  
                map_pId_childIds.get(null).add(bd.Account__c);              
            }
            else{
                String pId = bd.Account__c;
                if(bd.Parent_Account__c != null) pId = bd.Parent_Account__c;
                if(!map_pId_childIds.containsKey(pId)){
                    map_pId_childIds.put(pId, new set<String>());
                }
                map_pId_childIds.get(pId).add(bd.Account__c);
            }
            set_accIds.add(bd.Account__c);
        }

        for(Account acc: [select id, Individually_Planned__c, Name, Plan_Group_Id__c, Plan_Group_Account__c from Account where (RecordType.DeveloperName = 'CIS_Prospect' or RecordType.DeveloperName = 'CIS_Account') and Account_Manager__c = :userId and SALES_TERRITORY_CDE__c = :budget.Territory__r.Level_7_Territory_Code__c order by Name]){
            if(!set_accIds.contains(acc.Id)){
                return false;
            }
            if(acc.Individually_Planned__c){
                if(!map_pId_childIds.containsKey(acc.Id)){
                    return false;
                }
            }
            else{
                if(!map_pId_childIds.containsKey(acc.Plan_Group_Account__c)){
                    return false;
                }
                else{
                    if(!map_pId_childIds.get(acc.Plan_Group_Account__c).contains(acc.Id)){
                        return false;
                    }               
                }
            }
            set_accIds.remove(acc.Id);
        }
        
        if(set_accIds.size() > 0) return false; 
        return true;
    }
    
    @TestVisible private void clearBugdetAccounts(){
        //comment out by Lei Tang 2016-05-30
        //list_budgetPlanStructure.clear();       
        list_allTerritoryAccIds.clear();   
        //Modified by Bin Yuan<bin.yuan@oinio.com> 2016-02-02 due to view state issue     
        //map_accId_budgetPlanStructure.clear();
        map_accId_budgetPlanStructure = new Map<String, ClsAnnualBudgetPlanStructure>();
        totalBudgetPlan = new ClsAnnualBudgetPlanStructure(null);      
        totalBudgetPlan.type = 'Total';  
        
        otherBudgetPlanStructure = new ClsAnnualBudgetPlanStructure(null);
        otherBudgetPlanStructure.type = 'Other';      
    }
    
    @TestVisible private void resortBugdetAccounts(){
        /* Comment by Bin Yuan due to fix FQ budget display bug
        budget.FQ1_CMA__c = 0;
        budget.FQ1_Direct__c = 0;
        budget.FQ1_POS__c = 0;
        budget.FQ1_Total__c = 0;
        
        budget.FQ2_CMA__c = 0;
        budget.FQ2_Direct__c = 0;
        budget.FQ2_POS__c = 0;
        budget.FQ2_Total__c = 0;
        
        budget.FQ3_CMA__c = 0;
        budget.FQ3_Direct__c = 0;
        budget.FQ3_POS__c = 0;
        budget.FQ3_Total__c = 0;
                    
        budget.FQ4_CMA__c =  totalBudgetPlan.detailCMA.TotalBudget; 
        budget.FQ4_Direct__c = totalBudgetPlan.detailDirect.TotalBudget; 
        budget.FQ4_POS__c = totalBudgetPlan.detailPOS.TotalBudget; 
        budget.FQ4_Total__c = totalBudgetPlan.detailTotal.TotalBudget;      
        */      
           
        //Sort the list to show
        map<String,list<ClsAnnualBudgetPlanStructure>> map_name_structures = new map<String,list<ClsAnnualBudgetPlanStructure>>();
        list<String> list_name4sort = new list<string>();
        for(ClsAnnualBudgetPlanStructure s: map_accId_budgetPlanStructure.values()){
            if(s.accountId != null && s.accountId != ''){
                String tempSort = s.accountInfo + s.accountId;
                /* Comment by Bin Yuan due to duplication of account 2013-07-03
                list_name4sort.add(s.accountInfo);
                if(!map_name_structures.containsKey(s.accountInfo)){
                    map_name_structures.put(s.accountInfo,new list<ClsAnnualBudgetPlanStructure>());
                }
                map_name_structures.get(s.accountInfo).add(s);
                */
                list_name4sort.add(tempSort);
                if(!map_name_structures.containsKey(tempSort)){
                    map_name_structures.put(tempSort, new list<ClsAnnualBudgetPlanStructure>());
                }
                map_name_structures.get(tempSort).add(s);
            }
        }
        
        list_name4sort.sort(); 
        //comment out by Lei Tang 2016-05-30
        //for(String name: list_name4sort){
            //list_budgetPlanStructure.addAll(map_name_structures.get(name));
        //}               
    }
    
        
    public void recalculateBudget(){
    	system.debug('!@# 1 isRecalculate:'+isRecalculate);
    	system.debug('!@# 1 budget.Year__c:'+budget.Year__c);
    	system.debug('!@# 1 currentFiscalYear:'+currentFiscalYear);
        if(isRecalculate){ 
            rebuildBugdetAccounts();
            if(!map_accId_budgetPlanStructure.isEmpty()){
                //Added by Bin Yuan 2013-10-14 :: due to fix account territory changed bug
                //ClsBudgetPlanningUtil.buildBudgetByAccountId(budget.Year__c, currentFiscalYear, map_accId_budgetPlanStructure, list_allTerritoryAccIds, budget, totalBudgetPlan);
                ClsBudgetPlanningUtil.buildBudgetByAccountId(budget.Year__c, currentFiscalYear, map_accId_budgetPlanStructure, list_allTerritoryAccIds, budget, totalBudgetPlan, str_territoryCode, map_existingDetails);
                //End
            }   
        }
        else{
            clearBugdetAccounts();
            ClsBudgetPlanningUtil.buildBudgetStructure(map_accId_budgetPlanStructure, budget, totalBudgetPlan, otherBudgetPlanStructure);
            map_accId_budgetPlanStructure.put(null, otherBudgetPlanStructure);
        }
        if(map_accId_budgetPlanStructure.get(null) != null) {
	        otherBudgetPlanStructure = map_accId_budgetPlanStructure.get(null); 
	        map_accId_budgetPlanStructure.remove(null);
    
	        this.otherBudgetPlanStructuretemp = new ClsAnnualBudgetPlanStructureTemp(otherBudgetPlanStructure);
	        this.otherBPJsonStr = Json.serialize(otherBudgetPlanStructure);
        }
        //system.debug('!@# map_accId_budgetPlanStructure:'+map_accId_budgetPlanStructure);
        //resortBugdetAccounts();  

    }
    
    /**
    * The method is used to save budgets and budget details
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return             
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    private void save(){
        Apexpages.getMessages().clear();
        Savepoint sp = Database.setSavepoint();
        str_territoryCode = map_territoryId_Name.get(theTerritory); 
        try{
            if(isNew && theTerritory != '' && theTerritory != null && budget.Year__c != null && budget.Year__c != ''){
                String tCode = '';
                for(Sales_Hierarchy__c sh :[Select Id, Level_7_Territory_Code__c from Sales_Hierarchy__c where Id = :theTerritory limit 1]){
                    tCode = sh.Level_7_Territory_Code__c + '-';
                }
                budget.Territory__c = theTerritory;
                budget.Stage__c = 'Original';
                budget.Status__c = 'Draft';
                budget.Name = UserInfo.getName() + '-' + tCode + budget.Year__c;
                
            }
            if(theTerritory != '' && theTerritory != null && budget.Year__c != null && budget.Year__c != ''){
                if(budget.Id == null) insert budget;
                else{ 
                     //budget.Name = UserInfo.getName() + '-' + budget.Territory__r.Level_7_Territory_Code__c + '-' + budget.Year__c;
                     //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  'budget : ' + budget + ''));
                     update budget;
                }
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,budget+''));
                List<Budget_Detail__c> list_insertBDs = new List<Budget_Detail__c>();   
                //Added by bin yuan 2016-04-19 due to fix save null pointer issue
                list<ClsAnnualBudgetPlanStructure> list_tempStructure = new list<ClsAnnualBudgetPlanStructure>();
                //modify by Lei Tang 2016-05-30
                //list_tempStructure.addAll(list_budgetPlanStructure);
                list_tempStructure.addAll(this.map_accId_budgetPlanStructure.values());
                
                //modify by Lei Tang 2016-07-12
                //this.otherBPJsonStr = Apexpages.currentPage().getParameters().get('otherBPJsonStrId');
                this.otherBPJsonStr = Apexpages.currentPage().getParameters().get('otherBPJsonStrId');
                system.debug('!@# otherBPJsonStr:'+otherBPJsonStr);
                if(this.otherBPJsonStr != null && this.otherBPJsonStr != '') {
                	this.otherBudgetPlanStructure = (ClsAnnualBudgetPlanStructure)Json.deserialize(this.otherBPJsonStr, ClsAnnualBudgetPlanStructure.class);
	                if(this.otherBudgetPlanStructure != null && this.otherBudgetPlanStructure.map_accountStructure != null) {
	                	if(this.otherBudgetPlanStructuretemp != null) {
	                		this.otherBudgetPlanStructure.detailDirect = this.otherBudgetPlanStructuretemp.detailDirect;
					        this.otherBudgetPlanStructure.detailPOS = this.otherBudgetPlanStructuretemp.detailPOS;
					        this.otherBudgetPlanStructure.detailCMA = this.otherBudgetPlanStructuretemp.detailCMA;
					        
					        list_tempStructure.add(this.otherBudgetPlanStructure);
	                	}
	                }
                }
                
                //for(ClsAnnualBudgetPlanStructure bps: map_accId_budgetPlanStructure.values()){
                for(ClsAnnualBudgetPlanStructure bps: list_tempStructure){
                //end
                	
                    for(String accId : bps.map_accountStructure.keySet()){
                        String rId = map_budgetDetail_recordTypeId.get('Account');
                        if(bps.accountId == null) rId = map_budgetDetail_recordTypeId.get('Other');
                        String aId = accId.subString(0,15);
                        Integer size = bps.map_accountStructure.keySet().size();
                        ClsAnnualBudgetPlanStructure.BudgetPlanningAccountStructure bp = bps.map_accountStructure.get(accId);
                        //system.debug('bps.detailDirect :: ' + bps.detailDirect);
                        Budget_Detail__c detailD = ClsBudgetPlanningUtil.createBudgetDetailFromStructureDetail(budget.Id, 'Direct', accId, bps.detailDirect, bp.detailDirect, rId, size);
                        detailD.Comments__c = ( bps.detailDirect != null ? bps.detailDirect.comments : null);                         
                        Budget_Detail__c detailP = ClsBudgetPlanningUtil.createBudgetDetailFromStructureDetail(budget.Id, 'POS', accId, bps.detailPOS, bp.detailPOS, rId, size);
                        Budget_Detail__c detailC = ClsBudgetPlanningUtil.createBudgetDetailFromStructureDetail(budget.Id, 'CMA', accId, bps.detailCMA, bp.detailCMA, rId, size);
                        //Added by Bin Yuan 2013-10-14 :: due to fix account territory changed bug
                        if(map_existingDetails.containsKey(detailD.Account__c) && map_existingDetails.get(detailD.Account__c).containsKey(detailD.Type__c)) {
                            detailD = map_existingDetails.get(detailD.Account__c).get(detailD.Type__c);
                            detailD.Budget__c = budget.Id;
                        }
                        if(map_existingDetails.containsKey(detailP.Account__c) && map_existingDetails.get(detailP.Account__c).containsKey(detailP.Type__c)) {
                            detailP = map_existingDetails.get(detailP.Account__c).get(detailP.Type__c);
                            detailP.Budget__c = budget.Id;
                        }
                        if(map_existingDetails.containsKey(detailC.Account__c) && map_existingDetails.get(detailC.Account__c).containsKey(detailC.Type__c)) {
                            detailC = map_existingDetails.get(detailC.Account__c).get(detailC.Type__c);
                            detailC.Budget__c = budget.Id;
                        }
                        
                        //************************************************************
                        // START: set parent account for children accounts, others and 
                        // parent account dont have parent accounts
                        //************************************************************
                        if(aId != bps.accountId){
                            detailD.Parent_Account__c = bps.accountId;
                            detailP.Parent_Account__c = bps.accountId;
                            detailC.Parent_Account__c = bps.accountId;
                        }        
                        else{
                            detailD.Parent_Account__c = null;
                            detailP.Parent_Account__c = null;
                            detailC.Parent_Account__c = null;                           
                        }                
                        //************************************************************
                        // END: set parent account for children accounts, others and 
                        // parent account dont have parent accounts
                        //************************************************************
                        list_insertBDs.add(detailD);
                        list_insertBDs.add(detailP);
                        list_insertBDs.add(detailC);
                    }
                }
                
                List<Budget_Detail__c> list_old = new List<Budget_Detail__c>();   
                //Added by Bin Yuan 2013-10-14 :: due to fix account territory changed bug 
                //list_old = [Select Id from Budget_Detail__c where Budget__c = :budget.Id];
                list_old = [Select Id from Budget_Detail__c where Budget__c = :budget.Id and Account_Territory_Code__c =: str_territoryCode];
                
                //if(!list_insertBDs.isEmpty()) insert list_insertBDs;    
                if(!list_insertBDs.isEmpty()) upsert list_insertBDs;    
                //End
                if(list_old.size() > 0) delete list_old; //delete old details
            }  
                    
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getStackTraceString()));
            Database.rollback(sp);      
        } 
    }
    
    /**
    * The method is used to save budgets and budget details
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return     PageReference         
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */    
    public PageReference saveBudget(){
        
        save();
        if(ApexPages.hasMessages()){
            return null;    
        } 
        if(budget.Id != null){ 
            return backToBudgetPlanning();  
        }
        else{
            return backToView();                    
        }
        
        return null;
    }  
    
    /**
    * The method is used to save budgets and budget details and go to account break down page
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return     PageReference        
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public PageReference saveBudgetAndNext(){
        save();
        if(ApexPages.hasMessages()){
            return null;    
        } 
        if(budget.Id != null){ 
            return toBreakdown();  
        }
        else{
            return backToView();                    
        }
        
        return null;
    }      


    
    /**
    * The method is used to back to growth calculator page
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return     PageReference        
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public PageReference backAction(){
        return backToView();               
    }
    
    /**
    * The method is used to back to growth calculator page
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return     PageReference        
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
     public PageReference backToBudgetPlanning(){
        PageReference pageRef = new PageReference('/apex/ExtBudgetPlanning?id=' + budget.Id);
        pageRef.setRedirect(true);
        return pageRef;         
    }
    
    public PageReference toBreakdown(){
        PageReference pageRef = new PageReference('/apex/ExtBudgetPlanningBreakDown?id=' + budget.Id);
        pageRef.setRedirect(true);
        return pageRef;         
    }
    /**
    * The method is used to back to budget list view
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return     PageReference        
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public PageReference backToView(){
        pageReference pf = new pageReference(this.firstBackURL);
        pf.setRedirect(true);
        return pf;              
    }  
    

    
                  
    /**
    * This method is used to init the budget year select list
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param
    *
    @return            
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public void selectBudgetYear(){
    	//comment out by Lei Tang 2016-05-30
        //list_budgetPlanStructure = new List<ClsAnnualBudgetPlanStructure>(); 
        // if the terrority is selected on the page
        system.debug('!@# 2');
        if(theTerritory != null && theTerritory != ''){
            Set<String> set_freeYears = new Set<String>();  
            set_freeYears.addAll(list_years);   
            if(set_freeYears.size() > 0) {
                ClsBudgetPlanningUtil.filterYears(userId, theTerritory, set_freeYears);
            }
            initYearItems();
            if(set_freeYears.size() > 0){           
                addYearItems(set_freeYears);
                if(budget.Year__c != null && budget.Year__c != ''){ 
                    if(set_freeYears.contains(budget.Year__c )){
                        // build structures
                        buildBudgetPlanStructure();
                    }
                    else{
                        budget.Year__c = '';
                    }
                }
            }
        }
        else{
            initYearItems();
            list_years = ClsBudgetPlanningUtil.getDefaultYearList(2);
            addDefaultYearItems();
        }
        if(map_accId_budgetPlanStructure.get(null) != null) {
        	otherBudgetPlanStructure = map_accId_budgetPlanStructure.get(null); 
       		map_accId_budgetPlanStructure.remove(null);
       		        
	        this.otherBudgetPlanStructuretemp = new ClsAnnualBudgetPlanStructureTemp(otherBudgetPlanStructure);
	        this.otherBPJsonStr = Json.serialize(otherBudgetPlanStructure);
        }
        system.debug('!@# map_accId_budgetPlanStructure:'+map_accId_budgetPlanStructure);
    }
    
    /**
    * This method is used to init the budget territory select list
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param
    *
    @return            
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public void selectBudgetTerritory(){
        // if the terrority is selected on the page
        //comment out by Lei Tang 2016-05-30
        //list_budgetPlanStructure = new List<ClsAnnualBudgetPlanStructure>(); 
        
        system.debug('!@# 1');
        if(budget.Year__c != null && budget.Year__c != ''){
            Set<String> set_freeTerritorys = new Set<String>();
            set_freeTerritorys.addAll(map_territoryId_Name.keySet());       
            if(set_freeTerritorys.size() > 0) {
                ClsBudgetPlanningUtil.filterTerritory(userId, budget.Year__c, set_freeTerritorys);
            }
            initTerritoryItems();
            if(set_freeTerritorys.size() > 0){
                Map<String, String> map_tmp = new Map<String, String>();
                for(String tid : set_freeTerritorys){
                    map_tmp.put(tid, map_territoryId_Name.get(tid));
                }           
                addTerritoryItems(map_tmp);
                if(theTerritory != null && theTerritory != ''){
                    if(set_freeTerritorys.contains(theTerritory )){
                        // build structures
                        buildBudgetPlanStructure();
                    }
                    else{
                        theTerritory = '';
                    }
                }               
            }
        }
        else{
            initTerritoryItems();
            getAllTerritoryByUser(userId);
        }
        if(map_accId_budgetPlanStructure.get(null) != null) {
        	otherBudgetPlanStructure = map_accId_budgetPlanStructure.get(null); 
       		map_accId_budgetPlanStructure.remove(null);
       		        
	        this.otherBudgetPlanStructuretemp = new ClsAnnualBudgetPlanStructureTemp(otherBudgetPlanStructure);
	        this.otherBPJsonStr = Json.serialize(otherBudgetPlanStructure);
        }
        system.debug('!@# otherBPJsonStr:'+otherBPJsonStr);
    }    
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    /**
    * This method is used to init the budget year select list
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param
    *
    @return            
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    private void initYearItems(){
        list_yearItems = new List<SelectOption>();
        list_yearItems.add(new SelectOption('', system.label.None_Year));       
    }
    
    /**
    * This method is used to init the budget territory select list
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param
    *
    @return            
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    private void initTerritoryItems(){
        list_territoryItems = new List<SelectOption>();
        list_territoryItems.add(new SelectOption('', system.label.None_Territory));
    }
    
    /**
    * This method is used to add the years to select list
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param
    *
    @return            
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    private void addDefaultYearItems(){
        for(String year: list_years){
            list_yearItems.add(new SelectOption(year, year)); 
        }  
    } 
    
    /**
    * This method is used to add the years to select list
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param
    *
    @return            
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    private void addYearItems(Set<String> set_years){
        for(String year : set_years){
            list_yearItems.add(new SelectOption(year, year));   
        }    
    }
    
    /**
    * This method is used to add the territorys to select list
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param
    *
    @return            
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    @TestVisible private void addTerritoryItems(Map<String, String> map_territoryId_Name){
        for(String tid : map_territoryId_Name.keySet()){
            list_territoryItems.add(new SelectOption(tid, map_territoryId_Name.get(tid)));  
        }    
    }  

    /**
    * This method is used to set the values to structure for display
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param
    *
    @return            
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
        
    public static list<String> getValidAccountsByAMTerritory(id userId, String territoryCode, Map<String, ClsAnnualBudgetPlanStructure> map_accId_budgetPlanStructures){
        list<String> list_accIds = new list<String>();
        // get all parent accounts that have the gam or account plans
        for(Account acc: [select id, CurrencyIsoCode, Individually_Planned__c, Name, Plan_Group_Id__c, Plan_Group_Account__c, Plan_Group_Account__r.Name, Plan_Group_Account__r.CurrencyIsoCode, Plan_Group_Account__r.Account_Combined_Data__c, Account_Combined_Data__c from Account where (RecordType.DeveloperName = 'CIS_Prospect' or RecordType.DeveloperName = 'CIS_Account') and Account_Manager__c = :userId and SALES_TERRITORY_CDE__c = :territoryCode and (Individually_Planned__c = true or Plan_Group_Account__r.Individually_Planned__c = true) order by Name]){
            if(!map_accId_budgetPlanStructures.containsKey(acc.Plan_Group_Id__c)){                
                ClsAnnualBudgetPlanStructure budgetPlanStructure = new ClsAnnualBudgetPlanStructure(acc.Plan_Group_Id__c);
                if(acc.Individually_Planned__c){
                    budgetPlanStructure.accountName = acc.Name;
                    budgetPlanStructure.accountInfo = acc.Account_Combined_Data__c;
                }
                else{
                    budgetPlanStructure.accountName = acc.Plan_Group_Account__r.Name;
                    budgetPlanStructure.accountInfo = acc.Plan_Group_Account__r.Account_Combined_Data__c;        
                }
                map_accId_budgetPlanStructures.put(acc.Plan_Group_Id__c, budgetPlanStructure);
            }
            
            map_accId_budgetPlanStructures.get(acc.Plan_Group_Id__c).map_accountStructure.put(acc.Id, new ClsAnnualBudgetPlanStructure.BudgetPlanningAccountStructure(acc.Id));       
                 
            if(!acc.Individually_Planned__c){
                map_accId_budgetPlanStructures.get(acc.Plan_Group_Id__c).list_childIds.add(acc.Id);             
            }
            list_accIds.add(acc.Id);
        }
        return list_accIds;
    }     
    
    /**
    * The method is used to get the other accounts according to the conditions 
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param      user id, territory code, list of account ids, other account structure
    *
    @return             
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public static void getOtherAccountsByAMTerritory(id userId, String territoryCode, list<Id> list_individualAccIds, ClsAnnualBudgetPlanStructure otherbudgetPlanStructure){
        for(Account acc: [select id from Account where Account_Manager__c = :userId and SALES_TERRITORY_CDE__c = :territoryCode and (RecordType.DeveloperName = 'CIS_Prospect' or RecordType.DeveloperName = 'CIS_Account') and id NOT IN :list_individualAccIds order by Name]){     
            otherbudgetPlanStructure.list_childIds.add(acc.Id);
            otherbudgetPlanStructure.map_accountStructure.put(acc.Id, new ClsAnnualBudgetPlanStructure.BudgetPlanningAccountStructure(acc.Id));               
        }
    } 


    /**
    * This method is used to set the values to structure for display
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param
    *
    @return            
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    private void buildBudgetPlanStructure(){        
        str_territoryCode = map_territoryId_Name.get(theTerritory);  
        if(budget.Id == null){ 
            rebuildBugdetAccounts();
            if(!map_accId_budgetPlanStructure.isEmpty()){
                //Added by Bin Yuan 2013-10-14 :: due to fix account territory changed bug
                //ClsBudgetPlanningUtil.buildBudgetByAccountId(budget.Year__c, currentFiscalYear, map_accId_budgetPlanStructure, list_allTerritoryAccIds, budget, totalBudgetPlan);
                ClsBudgetPlanningUtil.buildBudgetByAccountId(budget.Year__c, currentFiscalYear, map_accId_budgetPlanStructure, list_allTerritoryAccIds, budget, totalBudgetPlan, str_territoryCode, map_existingDetails);
                //End
            }   
        }
        else{
            clearBugdetAccounts();
            ClsBudgetPlanningUtil.buildBudgetStructure(map_accId_budgetPlanStructure, budget, totalBudgetPlan, otherBudgetPlanStructure);
            map_accId_budgetPlanStructure.put(null, otherBudgetPlanStructure);
        }
        if(map_accId_budgetPlanStructure.get(null) != null) {
        	otherBudgetPlanStructure = map_accId_budgetPlanStructure.get(null); 
       		map_accId_budgetPlanStructure.remove(null);
       		        
	        this.otherBudgetPlanStructuretemp = new ClsAnnualBudgetPlanStructureTemp(otherBudgetPlanStructure);
	        this.otherBPJsonStr = Json.serialize(otherBudgetPlanStructure);
        }
        
        system.debug('!@# map_accId_budgetPlanStructure:'+map_accId_budgetPlanStructure);
        //resortBugdetAccounts();
    }
                  
    /**
    * This method is used to get the initialize the select list
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param
    *
    @return            
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    @TestVisible private void getAllTerritoryByUser(id userId){
        // initialize the territory item list
        for(AggregateResult acc: [select SALES_TERRITORY_CDE__c from Account where Account_Manager__c = :userId and SALES_TERRITORY_CDE__c != null group by SALES_TERRITORY_CDE__c order by SALES_TERRITORY_CDE__c limit 2000]){
            set_allTerritorys.add(String.valueOf(acc.get('SALES_TERRITORY_CDE__c')));
        }
        
        if(set_allTerritorys.size() > 0){
            for(Sales_Hierarchy__c sh : [Select Id, Level_7_Territory_Code__c from Sales_Hierarchy__c where Level_7_Territory_Code__c in :set_allTerritorys]){
                list_territoryItems.add(new SelectOption(sh.Id, sh.Level_7_Territory_Code__c));
                map_territoryId_Name.put(sh.Id, sh.Level_7_Territory_Code__c);
            }
        }
    }
    
    /**
    * This method is used to get territory code for report
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param
    *
    @return            
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public String getTerritoryCode4Report(){
        String tc;
        if(theTerritory != ''){
            if(map_territoryId_Name.containsKey(theTerritory)) tc = map_territoryId_Name.get(theTerritory);
        }
        return tc;
    }
    
      

   /**
    * The method is used to get report type id from custom setting
    *
    @author Yinfeng Guo
    @created 2012-07-09
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return     void        
    *
    @changelog
    * 2012-07-09 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */    
    private void InitReportIds(){
        //currentUrl = ApexPages.currentPage().getUrl();
        if(Apex_Helper_Settings__c.getInstance('Budget Plan Accounts') != null && Apex_Helper_Settings__c.getInstance('Budget Plan Accounts').Value__c != null && Apex_Helper_Settings__c.getInstance('Budget Plan Accounts').Value__c != '') 
            link_BudgetPlanAccounts = '/'+ Apex_Helper_Settings__c.getInstance('Budget Plan Accounts').Value__c + '?pv0=';
        else    link_BudgetPlanAccounts = '';
        
        if(Apex_Helper_Settings__c.getInstance('Other Accounts in Territory') != null && Apex_Helper_Settings__c.getInstance('Other Accounts in Territory').Value__c != null && Apex_Helper_Settings__c.getInstance('Other Accounts in Territory').Value__c != '') 
            link_OtherAccountsInTerritory = '/'+ Apex_Helper_Settings__c.getInstance('Other Accounts in Territory').Value__c + '?pv1=';
        else    link_OtherAccountsInTerritory = '';
        
        if(Apex_Helper_Settings__c.getInstance('Won Opportunities') != null && Apex_Helper_Settings__c.getInstance('Won Opportunities').Value__c != null && Apex_Helper_Settings__c.getInstance('Won Opportunities').Value__c != '') 
            link_WonOpportunities = '/'+ Apex_Helper_Settings__c.getInstance('Won Opportunities').Value__c;
        else    link_WonOpportunities = '';
        
        if(Apex_Helper_Settings__c.getInstance('Commit Opportunities') != null && Apex_Helper_Settings__c.getInstance('Commit Opportunities').Value__c != null && Apex_Helper_Settings__c.getInstance('Commit Opportunities').Value__c != '') 
            link_CommitOpportunities = '/'+ Apex_Helper_Settings__c.getInstance('Commit Opportunities').Value__c;
        else    link_CommitOpportunities = '';
        
        if(Apex_Helper_Settings__c.getInstance('Likely Opportunities') != null && Apex_Helper_Settings__c.getInstance('Likely Opportunities').Value__c != null && Apex_Helper_Settings__c.getInstance('Likely Opportunities').Value__c != '') 
            link_LikelyOpportunities = '/'+ Apex_Helper_Settings__c.getInstance('Likely Opportunities').Value__c;
        else    link_LikelyOpportunities = '';
        
        if(Apex_Helper_Settings__c.getInstance('50/50 Opportunities') != null && Apex_Helper_Settings__c.getInstance('50/50 Opportunities').Value__c != null && Apex_Helper_Settings__c.getInstance('50/50 Opportunities').Value__c != '') 
            link_5050Opportunities = '/'+ Apex_Helper_Settings__c.getInstance('50/50 Opportunities').Value__c;
        else    link_5050Opportunities = '';
        
        if(Apex_Helper_Settings__c.getInstance('Weak Opportunities') != null && Apex_Helper_Settings__c.getInstance('Weak Opportunities').Value__c != null && Apex_Helper_Settings__c.getInstance('Weak Opportunities').Value__c != '') 
            link_WeakOpportunities = '/'+ Apex_Helper_Settings__c.getInstance('Weak Opportunities').Value__c;
        else    link_WeakOpportunities = '';
    } 
    
      
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************           
    ///*>>>WrapperClass*/
    
    public class BudgetPlanningInfo{
        
        public list<String> list_detail {get{
            if(list_detail == null){
                list_detail = new list<String>();
                list_detail.add('Billings LY $');
                list_detail.add('Billings YTD CY $');
                list_detail.add('Billings RR CY $');
                list_detail.add('Backlog $');
                list_detail.add('Estimated Final CY $');
                list_detail.add('Obsoletion/EOL $');
                list_detail.add('Transfer Out $');
                list_detail.add('Transfer In $');       
                list_detail.add('TAM/DTAM $');
                list_detail.add('Repeat Business $');
                list_detail.add('Customer Growth %');  
                list_detail.add('Market Price Change %');
                list_detail.add('Price Increase %');
                list_detail.add('Adj. Repeat Business $');        
                list_detail.add('Opportunities Won $');     
                list_detail.add('Forecast $');
                list_detail.add('Opportunities Commit $');
                list_detail.add('Opportunities Likely $');   
                list_detail.add('Opportunities 50/50 $');
                list_detail.add('Opportunities Weak $');
                list_detail.add('Adjustment $');     
                list_detail.add('Growth %');    
                list_detail.add('Comments');
            }
            return list_detail;
        }set;} 
    
        public map<String, String> map_detail {get;set;}
        public String jsPath {get; set;}
        public String locale {get; set;}
        
        public BudgetPlanningInfo(){
            if(map_detail == null){
                map_detail = new map<String, String>{
                    'Billings LY $' => 'Billings_LY__c',
                    'Billings YTD CY $' => 'Billings_CYTD__c',
                    'Billings RR CY $'  => 'Billings_CYRR__c',
                    'Backlog $' => 'Backlog__c',
                    'Estimated Final CY $' => 'Forecast_CY__c',
                    'Obsoletion/EOL $' => 'Obsoletion_EOL__c',
                    'Transfer Out $' => 'Transfer_Out__c',
                    'Transfer In $' => 'Transfer_In__c',        
                    'TAM/DTAM $' => 'TAM_DTAM__c',
                    'Repeat Business $' =>'Run_Rate_Business__c' ,
                    'Customer Growth %' => 'Market_Growth__c',   
                    'Market Price Change %' => 'Price_Change__c',
                    'Price Increase %' => 'Price_Increase__c',
                    'Adj. Repeat Business $' => 'Adjusted_Business__c',           
                    'Opportunities Won $' => 'Opportunities_Won__c',        
                    'Forecast $' => 'Calculated_Budget__c',
                    'Opportunities Commit $' => 'Opportunities_Commit__c',
                    'Opportunities Likely $' => 'Opportunities_Likely__c',   
                    'Opportunities 50/50 $' => 'Opportunities50_50__c',
                    'Opportunities Weak $' => 'Opportunities_Weak__c',
                    'Adjustment $' => 'Adjustment__c',       
                    'Growth %' => 'Growth__c',      
                    'Comments' => 'Comments__c'
                };
            }
            
            try{
                this.locale= userInfo.getLocale();
                List<String> list_s = locale.split('_');
                this.locale = list_s[0]+'-'+list_s[1];
                if(locale.indexOf('de') == -1){
                    locale = 'de-DE';
                }
            }
            catch(Exception e){
                this.locale = 'de-DE';
            } 
            this.jsPath = '/glob-cultures/cultures/globalize.culture.'+locale+'.js';
            
        }
        
    }
    
    //added by Lei Tang 2016-07-12
    public class ClsAnnualBudgetPlanStructureTemp { 
   
	    public String accountId {get; set;}
	    public transient String accountName {get; set;}
	    public transient String accountInfo {get; set;}   
	    public String type {get; set;}
	    public transient List<String> list_childIds;
		public transient String comment {get;set;}
		
	    public ClsAnnualBudgetPlanStructure.BudgetPlanningItem detailDirect {get; set;}
	    public ClsAnnualBudgetPlanStructure.BudgetPlanningItem detailPOS {get; set;}
	    public ClsAnnualBudgetPlanStructure.BudgetPlanningItem detailCMA {get; set;}
	    public transient ClsAnnualBudgetPlanStructure.BudgetPlanningItem detailTotal {get; set;}
	    
	    public ClsAnnualBudgetPlanStructureTemp(ClsAnnualBudgetPlanStructure clsObj){
	        this.type = clsObj.type;
	        this.list_childIds = clsObj.list_childIds;
	        //map_accountStructure = new map<String, BudgetPlanningAccountStructure>();
	        this.accountId = clsObj.accountId;
	        this.accountName = clsObj.accountName;
	        this.accountInfo = clsObj.accountInfo;
	        
	        this.detailDirect = clsObj.detailDirect;
	        this.detailPOS = clsObj.detailPOS;
	        this.detailCMA = clsObj.detailCMA;
	        this.detailTotal = clsObj.detailTotal;
	    }
	
	    public String getAccountId4Report(){
	    	if(accountId != null){
		        String tmpAccId = String.valueOf(accountId);
		        tmpAccId = tmpAccId.subString(0, 15);
		        return tmpAccId;
	    	}
	    	return '';
	    }
    }
    
    
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
    
}