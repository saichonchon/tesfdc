/** 
*    Controller for ExtBudgetPlanningBreakDown page
*
@author Xia Tong
@created 2013-04-25
@version 1.0
@since 23.0 (Force.com ApiVersion)
*
@changelog
* 2013-04-25 Xia Tong <xia.tong@itbconsult.com>
* - Created
*/

public class ExtBudgetPlanningBreakDown {
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public Budget__c budget {get; set;}
    //public transient List<ClsBudgetPlanBreakDownStructure> list_budgetPlanStructure {get; set;}
    public ClsBudgetPlanBreakDownStructure otherBudgetPlanStructure {get; set;}
    public transient map<String, ClsBudgetPlanBreakDownStructure> map_accId_budgetPlanStructures {get; set;}
    public String format{get;set;}  
    public boolean showEdit{get;set;}
    public boolean isRecalculate{get;set;}
    public boolean isInitBBBM{get;set;}
    
    public transient String sJson {get;set;}
    public String sJsonTest {get;set;}
    public transient String map_accId_budgetPlanStructuresJson {get;set;}
    public transient String saveJson {get;set;}
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private Id budgetId;
    private map<Id, set<Id>> map_parentId_childIds = new map<Id, set<Id>>();
    
    private map<String, Id> map_budgetDetail_recordTypeId = new map<String, Id>();
    private transient list<Budget_Detail__c> list_budgetDetail {get;set;}
    private set<Id> set_accId = new set<Id>(); 
    private Id userId;
    private transient map<Id,map<string,Budget_Detail__c>> map_accId_type_bd {get;set;}
    //START add by Yuda <yuda.zheng@itbconsult.com> 2013-09-16 
    private map<String, map<String,Decimal>> map_currency_type_Rate;
    private map<String, map<Integer, Decimal>> map_billType_monthRate;
    private map<Integer, Decimal> map_FC_monthRate;
    //END add by Yuda <yuda.zheng@itbconsult.com> 2013-09-16 
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public ExtBudgetPlanningBreakDown(ApexPages.standardController stdCtrl){
        showEdit = true;
        isRecalculate = false;
        isInitBBBM = true;
        sJson = '';
        userId = userInfo.getUserId();
        map_accId_type_bd = new map<Id,map<string,Budget_Detail__c>>();
        list_budgetDetail = new list<Budget_Detail__c>();
        if(ApexPages.currentPage().getParameters().containsKey('id')){
            budgetId =  ApexPages.currentPage().getParameters().get('id');
        }
        
        // get number format
        if(UserInfo.getLocale().indexOf('de') != -1){
            format = 'de';
        }
        else{
            format = 'other';
        }
        
        // get the record type Id of Budget Deails
        for(RecordType rt : [Select Id, DeveloperName from RecordType where SobjectType = 'Budget_Detail__c']){
            map_budgetDetail_recordTypeId.put(rt.DeveloperName, rt.Id);
        }
        List<ClsBudgetPlanBreakDownStructure> list_budgetPlanStructure = new List<ClsBudgetPlanBreakDownStructure>();
        this.map_accId_budgetPlanStructures = new map<String, ClsBudgetPlanBreakDownStructure>();
        otherBudgetPlanStructure = new ClsBudgetPlanBreakDownStructure(map_budgetDetail_recordTypeId.get('Other'), null);
        otherBudgetPlanStructure.type = 'other';
        map_accId_budgetPlanStructures.put(null, otherBudgetPlanStructure);
        if(budgetId != null){ 
            budget = ClsBudgetPlanBreakDownUtil.getBudgetPlanById(budgetId); 
            //Modified by Bin Yuan 2015-07-20 due to R-89 :: Remove edit restriction on budget after approval / open locked budgets
            //if(budget.OwnerId == userId && budget.Status__c == 'Draft'){
            if(budget.OwnerId == userId && budget.Status__c != 'Submitted') {
                showEdit = true;
            }
            //Added by Bin Yuan 2013-10-17 due to territory changed bug
            //ClsBudgetPlanBreakDownUtil.BuildBreakDownStructures(budgetId, list_budgetPlanStructure, otherBudgetPlanStructure, map_accId_budgetPlanStructures, map_budgetDetail_recordTypeId,list_budgetDetail,set_accId,map_accId_type_bd);
            ClsBudgetPlanBreakDownUtil.BuildBreakDownStructures(budgetId, budget.Territory__r.Level_7_Territory_Code__c, list_budgetPlanStructure, otherBudgetPlanStructure, map_accId_budgetPlanStructures, map_budgetDetail_recordTypeId,list_budgetDetail,set_accId,map_accId_type_bd);
            //End
            if(!map_accId_budgetPlanStructures.isEmpty()){
                ClsBudgetPlanBreakDownUtil.calAllValues(map_accId_budgetPlanStructures.values()); 
            }
            //sort by name
            //comment out by Lei Tang 2016-05-31 fix view state issue
            /*map<string,ClsBudgetPlanBreakDownStructure> map_name_structure = new map<string,ClsBudgetPlanBreakDownStructure>();
            list<string> list_name = new list<string>();
            for(ClsBudgetPlanBreakDownStructure s: list_budgetPlanStructure){
                map_name_structure.put(s.accountInfo,s);
                list_name.add(s.accountInfo);
            }
            list_name.sort();
            list_budgetPlanStructure.clear();
            for(string name: list_name){
                list_budgetPlanStructure.add(map_name_structure.get(name));
            }*/
            
        }
        system.debug('!@# map_accId_budgetPlanStructures : '+map_accId_budgetPlanStructures.get('001E000000jZQSTIA4'));
        //added by Lei Tang 2016-05-31 fix view state issue
        map_accId_budgetPlanStructuresJson = Json.serialize(map_accId_budgetPlanStructures);
        if(Test.isRunningTest()) {
    		sJsonTest = map_accId_budgetPlanStructuresJson;
    	}
        list_budgetPlanStructure.clear();
        otherBudgetPlanStructure = map_accId_budgetPlanStructures.get(null);
        map_accId_budgetPlanStructures.remove(null);
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'map_accId_budgetPlanStructures.values() :: ' + map_accId_budgetPlanStructures.values()));
    	
    	
    }
     
    public PageReference save(){
        /*saveBreakDown();
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'map_accId_budgetPlanStructures.values() :: ' + map_accId_budgetPlanStructures.values()));
        return null;
        if(ApexPages.hasMessages()){
            return null;         
        }*/
        return back();
    }
    
    public PageReference saveAndSubmit(){
        /*saveBreakDown();
        // submit for approval
        if(ApexPages.hasMessages()){
            return null;         
        }
        if(budget.Manager__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.label.Budget_Manager_Check));
            return null;
        }
        Savepoint sp = Database.setSavepoint();
        budget.Status__c = 'Submitted';

        try{
            update budget;
        }
        catch(exception ex){
            ApexPages.addMessages(ex);
            Database.rollback(sp);
            return null;                
        }*/
        return back();  
    	
    }
    
    public PageReference back(){
        PageReference page = new PageReference('/apex/ExtBudgetPlanning?id=' + budgetId);
        page.setRedirect(true);
        return page;
    }
    
    public void recalculate(){
        //system.debug('tongxia isRecalculate:' + isRecalculate);
        for(ClsBudgetPlanBreakDownStructure stc: map_accId_budgetPlanStructures.values()){
            stc.isRecalculate = isRecalculate;
        }
    }
    
    
    public List<ClsBudgetPlanBreakDownStructure> getBudgetPlanBreakDownStructureList() {
    	if(map_accId_budgetPlanStructures == null) {
    		map_accId_budgetPlanStructures = new map<String, ClsBudgetPlanBreakDownStructure>();
    	}
    	return map_accId_budgetPlanStructures.values();
    }
    
    
    public void saveBreakDown(){
    
        /*ApexPages.getMessages().clear();
        Savepoint sp = Database.setSavepoint();
		map_accId_type_bd = new map<Id,map<string,Budget_Detail__c>>();
		setTempDBData(budgetId, budget.Territory__r.Level_7_Territory_Code__c, map_accId_type_bd);
		
        //START edit by Yuda <yuda.zheng@itbconsult.com> 2013-09-16 
        //map<String, map<String,Decimal>> map_currency_type_Rate = ClsBudgetPlanBreakDownUtil.calBudgetRate(); 
        //map<String, Map<Integer, Decimal>> map_billType_monthRate = ClsBudgetPlanBreakDownUtil.calBBBMonthRateByQurater(budget);
        //map<Integer, Decimal> map_FC_monthRate = ClsBudgetPlanBreakDownUtil.calFCBBBMonthRateByQurater(budget);
        if(map_currency_type_Rate == null) {
            map_currency_type_Rate = ClsBudgetPlanBreakDownUtil.calBudgetRate(); 
        }
        if(map_billType_monthRate == null) {
            map_billType_monthRate = ClsBudgetPlanBreakDownUtil.calBBBMonthRateByQurater(budget);
        }
        if(map_FC_monthRate == null) {
            map_FC_monthRate = ClsBudgetPlanBreakDownUtil.calFCBBBMonthRateByQurater(budget);
        }
        
        //ENd edit by Yuda <yuda.zheng@itbconsult.com> 2013-09-16 
        list<Budget_Detail__c> list_bd2update = new list<Budget_Detail__c>();
        list<string>list_allTerritoryAccIds = new list<string>();
        list<BBB_Month_Bill_Book_Cust__c> list_BBBMonthly2Upsert = new List<BBB_Month_Bill_Book_Cust__c>();
        map<Id, map<Integer, map<string,BBB_Month_Bill_Book_Cust__c>>> map_accountId_BBBMonthly = ClsBudgetPlanBreakDownUtil.getBBBMonthlyByAccountId(set_accId, budget.Year__c);      
        
        budget.Total_Budget_TBR_NY__c = 0;
        budget.Total_Direct_Budget_TBR_NY__c = 0;
        budget.Total_POS_Budget_TBR_NY__c = 0;
        budget.Total_CMA_Budget_TBR_NY__c = 0;
        
        //added by Lei Tang 2016-06-01
        map_accId_budgetPlanStructures = (map<String, ClsBudgetPlanBreakDownStructure>)Json.deserialize(map_accId_budgetPlanStructuresJson, map<String, ClsBudgetPlanBreakDownStructure>.class);
		list<BudgetDetail> list_data = (list<BudgetDetail>)Json.deserialize(saveJson, list<BudgetDetail>.class);
        map<String, BudgetDetail> map_accid_data = new map<String, BudgetDetail>();
        
        set<Id> set_partAccId = new set<Id>();
 
        for(BudgetDetail sd : list_data){
        	map_accid_data.put(sd.accid, sd);
            if(!set_partAccId.contains(sd.accid)) {
                set_partAccId.add(sd.accid);
            }
        }*/
        //for(ClsBudgetPlanBreakDownStructure abp: map_accId_budgetPlanStructures.values()){
            /*ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem parentItem = abp.parentAccountItem;
            
            String accId;
            map<String,Decimal> map_type_Rate = new  map<String,Decimal>();
            map<Integer, map<string,BBB_Month_Bill_Book_Cust__c>> map_BBBMonthly = new map<Integer, map<string,BBB_Month_Bill_Book_Cust__c>>();
            if(parentItem != null && parentItem.accountId != null){ 
            	if(map_accid_data.containsKey(parentItem.accountId)) {
            		parentItem.TotalBudget4Direct = map_accid_data.get(parentItem.accountId).TotalBudget4Direct;
            		parentItem.TotalBudget4POS = map_accid_data.get(parentItem.accountId).TotalBudget4POS;
            		parentItem.TotalBudget4CMA = map_accid_data.get(parentItem.accountId).TotalBudget4CMA;
            	}
            	
                ClsBudgetPlanBreakDownUtil.calcBudgetDetailToSave(parentItem);
                list_bd2update.add(parentItem.BudgetDetail4Direct);
                list_bd2update.add(parentItem.BudgetDetail4POS);
                list_bd2update.add(parentItem.BudgetDetail4CMA);
                accId = parentItem.accountId;
                map_type_Rate.clear();
                map<string,Budget_Detail__c> map_type_bd = new map<string,Budget_Detail__c>();
                if(map_accId_type_bd.containsKey(accId)) map_type_bd = map_accId_type_bd.get(accId);
                for(Budget_Detail__c bd:map_type_bd.values()){
                    bd.Budget_TBR_NY__c = 0;
                    bd.Budget_Document_Currency__c = 0;
                }
                if(map_currency_type_Rate.containsKey(parentItem.accountIsoCode)) map_type_Rate = map_currency_type_Rate.get(parentItem.accountIsoCode);
                map_BBBMonthly.clear();
                if(map_accountId_BBBMonthly.containsKey(accId)) map_BBBMonthly = map_accountId_BBBMonthly.get(accId);
                for(Integer i=1;i<=12;i++){
                    if(!test.isRunningTest()){
                        list_BBBMonthly2Upsert.addAll(ClsBudgetPlanBreakDownUtil.refreshBBBMonthlyRecord(map_BBBMonthly, accId, budget, map_billType_monthRate, map_FC_monthRate.get(i), i, map_type_Rate, parentItem,map_type_bd));                                         
                    }
                }
            }
            
            for(ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem childItem : abp.accountBillingMonthlyItems.values()){
                if(childItem != null && childItem.accountId != null) {
                    ClsBudgetPlanBreakDownUtil.calcBudgetDetailToSave(childItem);
                    list_bd2update.add(childItem.BudgetDetail4Direct);
                    list_bd2update.add(childItem.BudgetDetail4POS);
                    list_bd2update.add(childItem.BudgetDetail4CMA);
                    accId = childItem.accountId;
                    map_type_Rate.clear();
                    map<string,Budget_Detail__c> map_type_bd = new map<string,Budget_Detail__c>();
                    if(map_accId_type_bd.containsKey(accId)) map_type_bd = map_accId_type_bd.get(accId);
                    for(Budget_Detail__c bd:map_type_bd.values()){
                        bd.Budget_TBR_NY__c = 0;
                        bd.Budget_Document_Currency__c = 0;
                    }
                    
                    if(map_currency_type_Rate.containsKey(childItem.accountIsoCode)) map_type_Rate = map_currency_type_Rate.get(childItem.accountIsoCode);    
                    map_BBBMonthly.clear();
                    if(map_accountId_BBBMonthly.containsKey(accId)) map_BBBMonthly = map_accountId_BBBMonthly.get(accId);                                   
                    
                    for(Integer i=1;i<=12;i++){
                        if(!test.isRunningTest()){
                            list_BBBMonthly2Upsert.addAll(ClsBudgetPlanBreakDownUtil.refreshBBBMonthlyRecord(map_BBBMonthly, accId, budget, map_billType_monthRate, map_FC_monthRate.get(i), i, map_type_Rate, childItem,map_type_bd));                                               
                        }
                    }
                }           
            }*/
        //}
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'list_BBBMonthly2Upsert: ' + list_BBBMonthly2Upsert));
        
        /*list_budgetDetail = new list<Budget_Detail__c>();
		for(String accid : map_accId_type_bd.keySet()) {
			for(Budget_Detail__c db : map_accId_type_bd.get(accid).values()) {
				list_budgetDetail.add(db);
			}
		}
		
        if(list_BBBMonthly2Upsert.size() > 0){
            try{
                upsert list_BBBMonthly2Upsert;
                update list_budgetDetail;                
            }
            catch(exception ex){
                ApexPages.addMessages(ex);
                Database.rollback(sp);                      
            }
        }*/
    
    }
    
    
    public void saveBreakDownBudgetMonthly(){
        
        //list<BudgetMonthly> list_bm = new list<BudgetMonthly>();
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, this.sJson+''));
        //list<String> list_accid = (list<String>)Json.deserialize(this.sJson, list<String>.class);
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, list_accid+''));
        //parseBudgetMonthlyJSON(list_bm, this.sJson);
        map_accId_type_bd = new map<Id,map<string,Budget_Detail__c>>();
        list_budgetDetail = new list<Budget_Detail__c>();
        List<ClsBudgetPlanBreakDownStructure> list_budgetPlanStructure = new List<ClsBudgetPlanBreakDownStructure>();
        this.map_accId_budgetPlanStructures = new map<String, ClsBudgetPlanBreakDownStructure>();
        otherBudgetPlanStructure = new ClsBudgetPlanBreakDownStructure(map_budgetDetail_recordTypeId.get('Other'), null);
        otherBudgetPlanStructure.type = 'other';
        map_accId_budgetPlanStructures.put(null, otherBudgetPlanStructure);
        ClsBudgetPlanBreakDownUtil.BuildBreakDownStructures(budgetId, budget.Territory__r.Level_7_Territory_Code__c, list_budgetPlanStructure, otherBudgetPlanStructure, map_accId_budgetPlanStructures, map_budgetDetail_recordTypeId, list_budgetDetail,set_accId,map_accId_type_bd);
         
        //setTempDBData(budgetId, budget.Territory__r.Level_7_Territory_Code__c, map_accId_type_bd);
        
        //system.debug('!@# map_accId_type_bd A1 : '+map_accId_type_bd.get('001E000000BzQFtIAN'));

        system.debug('!@# saveJson : '+saveJson);
        list<BudgetDetail> list_data = (list<BudgetDetail>)Json.deserialize(saveJson, list<BudgetDetail>.class);
        map<String, BudgetDetail> map_accid_data = new map<String, BudgetDetail>();
        
        set<Id> set_partAccId = new set<Id>();

        for(BudgetDetail sd : list_data){
        	map_accid_data.put(sd.accid, sd);
            if(!set_partAccId.contains(sd.accid)) {
                set_partAccId.add(sd.accid);
            }
        }
        
        
        system.debug('!@# map_accid_data : '+map_accid_data.keySet());
        if(map_currency_type_Rate == null) {
            map_currency_type_Rate = ClsBudgetPlanBreakDownUtil.calBudgetRate(); 
        }
        system.debug('!@# map_currency_type_Rate : '+map_currency_type_Rate);
        if(map_billType_monthRate == null) {
            map_billType_monthRate = ClsBudgetPlanBreakDownUtil.calBBBMonthRateByQurater(budget);
        }
        if(map_FC_monthRate == null) {
            map_FC_monthRate = ClsBudgetPlanBreakDownUtil.calFCBBBMonthRateByQurater(budget);
        }
        map<Id, map<Integer, map<string,BBB_Month_Bill_Book_Cust__c>>> map_accountId_BBBMonthly = ClsBudgetPlanBreakDownUtil.getBBBMonthlyByAccountId(set_partAccId, budget.Year__c);
        
        list<Budget_Detail__c> list_bd2update = new list<Budget_Detail__c>();
        list<BBB_Month_Bill_Book_Cust__c> list_BBBMonthly2Upsert = new List<BBB_Month_Bill_Book_Cust__c>();
        list<string>list_allTerritoryAccIds = new list<string>();

        budget.Total_Budget_TBR_NY__c = 0;
        budget.Total_Direct_Budget_TBR_NY__c = 0;
        budget.Total_POS_Budget_TBR_NY__c = 0;
        budget.Total_CMA_Budget_TBR_NY__c = 0;
        //system.debug('set_accId ::: ' + set_accId);
        
        if(Test.isRunningTest()) {
        	map_accId_budgetPlanStructuresJson = sJsonTest;
        }
        
        map_accId_budgetPlanStructures = (map<String, ClsBudgetPlanBreakDownStructure>)Json.deserialize(map_accId_budgetPlanStructuresJson, map<String, ClsBudgetPlanBreakDownStructure>.class);
		system.debug('!@# map_accId_budgetPlanStructures : '+map_accId_budgetPlanStructures.get('001E000000jZQSTIA4'));
        
        for(ClsBudgetPlanBreakDownStructure abp: map_accId_budgetPlanStructures.values()){
            //comment by bin yuan 2015-06-23 due to fix break down save issue
            /*
            if(!set_accId.contains(abp.accountId)) {
                //continue;
            }
            */    
            ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem parentItem = abp.parentAccountItem;
            
            String accId;
            map<String,Decimal> map_type_Rate = new  map<String,Decimal>();
            map<Integer, map<string,BBB_Month_Bill_Book_Cust__c>> map_BBBMonthly = new map<Integer, map<string,BBB_Month_Bill_Book_Cust__c>>();
            if(parentItem != null && parentItem.accountId != null){ 
        		if(map_accid_data.containsKey(parentItem.accountId)) {
        			
	        		parentItem.TotalBudget4Direct = map_accid_data.get(parentItem.accountId).TotalBudget4Direct;
	        		parentItem.TotalBudget4POS = map_accid_data.get(parentItem.accountId).TotalBudget4POS;
	        		parentItem.TotalBudget4CMA = map_accid_data.get(parentItem.accountId).TotalBudget4CMA;

	            	ClsBudgetPlanBreakDownUtil.calcBudgetDetailToSave(parentItem);

	            	map_accId_type_bd.get(parentItem.accountId).get(parentItem.BudgetDetail4Direct.Type__c).Adjustment__c = parentItem.BudgetDetail4Direct.Adjustment__c;
	                map_accId_type_bd.get(parentItem.accountId).get(parentItem.BudgetDetail4POS.Type__c).Adjustment__c = parentItem.BudgetDetail4POS.Adjustment__c;
	                map_accId_type_bd.get(parentItem.accountId).get(parentItem.BudgetDetail4CMA.Type__c).Adjustment__c = parentItem.BudgetDetail4CMA.Adjustment__c;
	                
	
	                list_bd2update.add(parentItem.BudgetDetail4Direct);
	                list_bd2update.add(parentItem.BudgetDetail4POS);
	                list_bd2update.add(parentItem.BudgetDetail4CMA);
	                accId = parentItem.accountId;
	                map_type_Rate.clear();
	                map<string,Budget_Detail__c> map_type_bd = new map<string,Budget_Detail__c>();
	                if(map_accId_type_bd.containsKey(accId)) map_type_bd = map_accId_type_bd.get(accId);
	                for(Budget_Detail__c bd:map_type_bd.values()){
	                    bd.Budget_TBR_NY__c = 0;
	                    bd.Budget_Document_Currency__c = 0;
	                }
	                
	                if(map_currency_type_Rate.containsKey(parentItem.accountIsoCode)) map_type_Rate = map_currency_type_Rate.get(parentItem.accountIsoCode);
	                
	                map_BBBMonthly.clear();
	                if(map_accountId_BBBMonthly.containsKey(accId)) map_BBBMonthly = map_accountId_BBBMonthly.get(accId);
	                for(Integer i=1;i<=12;i++){
	                    if(!test.isRunningTest()){
	                        list_BBBMonthly2Upsert.addAll(ClsBudgetPlanBreakDownUtil.refreshBBBMonthlyRecord(map_BBBMonthly, accId, budget, map_billType_monthRate, map_FC_monthRate.get(i), i, map_type_Rate, parentItem,map_type_bd));
	                    }
	                }
        		}else {
        			
        			parentItem.TotalBudget4Direct = abp.TotalBudget4Direct;
	        		parentItem.TotalBudget4POS = abp.TotalBudget4POS;
	        		parentItem.TotalBudget4CMA = abp.TotalBudget4CMA;

        			ClsBudgetPlanBreakDownUtil.calcBudgetDetailToSave(parentItem);
        			accId = parentItem.accountId;
	                map_type_Rate.clear();
	                map<string,Budget_Detail__c> map_type_bd = new map<string,Budget_Detail__c>();
	                if(map_accId_type_bd.containsKey(accId)) map_type_bd = map_accId_type_bd.get(accId);
	                for(Budget_Detail__c bd : map_type_bd.values()){
	                    bd.Budget_TBR_NY__c = 0;
	                    bd.Budget_Document_Currency__c = 0;
	                }
	                
	                if(map_currency_type_Rate.containsKey(parentItem.accountIsoCode)) map_type_Rate = map_currency_type_Rate.get(parentItem.accountIsoCode);
	                
	                map_BBBMonthly.clear();
	               
	                if(map_accountId_BBBMonthly.containsKey(accId)) map_BBBMonthly = map_accountId_BBBMonthly.get(accId);
	                for(Integer i = 1; i <= 12; i++){
	                    if(!test.isRunningTest()){
	                    	list_BBBMonthly2Upsert.addAll(ClsBudgetPlanBreakDownUtil.refreshBBBMonthlyRecord(map_BBBMonthly, accId, budget, map_billType_monthRate, map_FC_monthRate.get(i), i, map_type_Rate, parentItem,map_type_bd));
	                                                            
	                    }
	                }
	    
        		}
            }
                
            for(ClsBudgetPlanBreakDownStructure.AccountBillingMonthlyItem childItem : abp.accountBillingMonthlyItems.values()){
                if(childItem != null && childItem.accountId != null) {
                	if(map_accid_data.containsKey(childItem.accountId)) {

		        		childItem.TotalBudget4Direct = map_accid_data.get(childItem.accountId).TotalBudget4Direct;
		        		childItem.TotalBudget4POS = map_accid_data.get(childItem.accountId).TotalBudget4POS;
		        		childItem.TotalBudget4CMA = map_accid_data.get(childItem.accountId).TotalBudget4CMA;

	                    ClsBudgetPlanBreakDownUtil.calcBudgetDetailToSave(childItem);
	                    map_accId_type_bd.get(childItem.accountId).get(childItem.BudgetDetail4Direct.Type__c).Adjustment__c = childItem.BudgetDetail4Direct.Adjustment__c;
	                    map_accId_type_bd.get(childItem.accountId).get(childItem.BudgetDetail4POS.Type__c).Adjustment__c = childItem.BudgetDetail4POS.Adjustment__c;
	                    map_accId_type_bd.get(childItem.accountId).get(childItem.BudgetDetail4CMA.Type__c).Adjustment__c = childItem.BudgetDetail4CMA.Adjustment__c;
	
	                    //system.debug('!@# childItem'+childItem);
	                    list_bd2update.add(childItem.BudgetDetail4Direct);
	                    list_bd2update.add(childItem.BudgetDetail4POS);
	                    list_bd2update.add(childItem.BudgetDetail4CMA);
	                    accId = childItem.accountId;
	                    map_type_Rate.clear();
	                    map<string,Budget_Detail__c> map_type_bd = new map<string,Budget_Detail__c>();
	                    if(map_accId_type_bd.containsKey(accId)) map_type_bd = map_accId_type_bd.get(accId);
	                    for(Budget_Detail__c bd:map_type_bd.values()){
	                        bd.Budget_TBR_NY__c = 0;
	                        bd.Budget_Document_Currency__c = 0;
	                    }
	
	                    if(map_currency_type_Rate.containsKey(childItem.accountIsoCode)) map_type_Rate = map_currency_type_Rate.get(childItem.accountIsoCode);
	                        
	                    map_BBBMonthly.clear();
	                    if(map_accountId_BBBMonthly.containsKey(accId)) map_BBBMonthly = map_accountId_BBBMonthly.get(accId);                                   
	                    
	                    for(Integer i=1;i<=12;i++){
	                        if(!test.isRunningTest()){
	                            list_BBBMonthly2Upsert.addAll(ClsBudgetPlanBreakDownUtil.refreshBBBMonthlyRecord(map_BBBMonthly, accId, budget, map_billType_monthRate, map_FC_monthRate.get(i), i, map_type_Rate, childItem,map_type_bd));
	                        }
	                    }
                    }     
                }  
            }
        }
		
		list_budgetDetail = new list<Budget_Detail__c>();
		for(String accid : map_accId_type_bd.keySet()) { 
			list_budgetDetail.addAll(map_accId_type_bd.get(accid).values());
			/*for(Budget_Detail__c db : map_accId_type_bd.get(accid).values()) {
				list_budgetDetail.add(db);
				
			}
			*/
		}
		
        if(list_BBBMonthly2Upsert.size() > 0){
            
            try{
				upsert list_BBBMonthly2Upsert;
				update list_budgetDetail;    
            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, e+''));
            } 
        }

    }
    
    public PageReference saveBreakDownBudgetDetail(){
        Boolean isSubmit = Boolean.valueOf(ApexPages.currentPage().getParameters().get('isSubmit'));

        if(isSubmit){
            saveBreakDownBudgetMonthly();
            
            // submit for approval
            if(ApexPages.hasMessages()){
                return null;         
            }
            if(budget.Manager__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.label.Budget_Manager_Check));
                return null;
            }
            
            Savepoint sp = Database.setSavepoint();
            budget.Status__c = 'Submitted';
             
            try{
                update budget;
            }catch(Exception e){
                ApexPages.addMessages(e);
                Database.rollback(sp);
                return null;    
            }
        }
        return back(); 
    }
    
    
    /*private void parseBudgetMonthlyJSON(list<BudgetMonthly> list_bm, String sJson){
        JSONParser parser = JSON.createParser(sJson);
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {    // Start at the array of invoices. 
                while (parser.nextToken() != null) {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        BudgetMonthly bm= (BudgetMonthly)parser.readValueAs(ExtBudgetPlanningBreakDown.BudgetMonthly.class);
                        list_bm.add(bm);
                        parser.skipChildren();
                    }
                }
            }
        }
    }*/
    
    /*private void parseBudgetDetailJSON(list<BudgetDetail> list_bm, String sJson){
        JSONParser parser = JSON.createParser(sJson);
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {    // Start at the array of invoices. 
                while (parser.nextToken() != null) {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        BudgetDetail bm= (BudgetDetail)parser.readValueAs(ExtBudgetPlanningBreakDown.BudgetDetail.class);
                        list_bm.add(bm);
                        parser.skipChildren();
                    }
                }
            }
        }
    }*/
    
    
    
    private void setTempDBData(Id budgetId, String str_territory, map<Id, map<string,Budget_Detail__c>> map_accId_type_bd) {
    	for(Budget_Detail__c bd: [select id, Budget_TBR_NY__c, Budget_Document_Currency__c, Account__c, Type__c, Forecast_CY__c,
    								Obsoletion_EOL__c, Transfer_Out__c, Transfer_In__c, TAM_DTAM__c, Market_Growth__c, Price_Change__c,
    								Price_Increase__c, Opportunities_Won__c
    								from Budget_Detail__c where Budget__c =: budgetId And Account_Territory_Code__c =: str_territory]){
    		if(bd.Account__c != null && !map_accId_type_bd.containsKey(bd.Account__c)){
                map_accId_type_bd.put(bd.Account__c,new map<string,Budget_Detail__c>());
            }
            map_accId_type_bd.get(bd.Account__c).put(bd.Type__c,bd);
    	}
    }
    
    //********************************* -=BEGIN inner classes=- ***********************************
    
    /*public class BudgetMonthly{
        
        public Id cId {get;set;}    // id reference to Account
        public Id filterId{get;set;}    // id reference to Bill_Type_Filter__r
        public String fYear {get;set;}
        public String bType {get;set;}
        public String isoCode {get;set;}
        public Decimal fMonth {get;set;}
        public Decimal budget {get;set;}
        public Decimal budgetTBRNY {get;set;}
        public Decimal budgetDocumentCurrency{get;set;}
        
    }*/
    
    public class BudgetDetail {
    	public String accid {get; set;}
        public Decimal TotalBudget4Direct {get; set;}
        public Decimal TotalBudget4POS {get; set;}
        public Decimal TotalBudget4CMA {get; set;}
    }
    //********************************* -=END inner classes=- *************************************
    
}