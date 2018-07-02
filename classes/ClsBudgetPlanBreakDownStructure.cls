/** 
*    Controller for ExtBudgetPlanning page
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

public class ClsBudgetPlanBreakDownStructure {
	
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public id accountId {get; set;}
    public String accountName {get; set;}
    public String accountInfo {get; set;}   
    //public String type {get; set;}
    public AccountBillingMonthlyItem parentAccountItem;
    //public List<String> list_childIds;
    public set<Id> set_childIds;
    public map<String, AccountBillingMonthlyItem> accountBillingMonthlyItems;
    // total budget
    public Decimal TotalBudget4Direct {get; set;}
    public Decimal TotalBudget4POS {get; set;}
    public Decimal TotalBudget4CMA {get; set;}
    public Decimal TotalBudget4Total {get; set;}

    public Budget_Detail__c BudgetDetail4Total {get; set;}
    
    public boolean isRecalculate{get;set;}
    public string type{get;set;}

    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    public ClsBudgetPlanBreakDownStructure(Id recordTypeId, Id accountId){
        //type = '';
        //list_childIds = new List<String>();
        set_childIds = new set<Id>();
        accountBillingMonthlyItems = new map<String, AccountBillingMonthlyItem>();
        accountName = '';
        accountInfo = '';
        //showOldBBBM = false;
        
        // total budget
        TotalBudget4Direct = 0;
        TotalBudget4POS = 0;
        TotalBudget4CMA = 0;
        TotalBudget4Total = 0;
                
        
        // Total
        BudgetDetail4Total = new Budget_Detail__c();
        
        isRecalculate = false;

    }
    
    /**
    * This method is used to get account id for report
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param
    *
    @return      account id for report     
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public String getAccountId4Report(){
        String tmpAccId = String.valueOf(accountId);
        tmpAccId = tmpAccId.subString(0, tmpAccId.length()-3);
        return tmpAccId;
    }
    
    /**
    * This method is used to get the children account items
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param
    *
    @return      list of children account items for break down      
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public list<AccountBillingMonthlyItem> getChildrenAccountItems(){
        list<AccountBillingMonthlyItem> list_items = new list<AccountBillingMonthlyItem>();
        map<Decimal, list<AccountBillingMonthlyItem>> map_cyRR_AccountItems = new map<Decimal, list<AccountBillingMonthlyItem>>();
        
        
        if(set_childIds.size() > 0 && accountBillingMonthlyItems.size() > 0){
            Integer i = 1;
            for(String aid : set_childIds){
                if(accountBillingMonthlyItems.containsKey(aid)){
                	AccountBillingMonthlyItem item = accountBillingMonthlyItems.get(aid);
                	if(this.isRecalculate){
                		accountBillingMonthlyItems.get(aid).TotalBudget4Direct = calAccountDetailValue(TotalBudget4Direct, BudgetDetail4Total.Billings_CYRR__c, accountBillingMonthlyItems.get(aid).BillingsCYRR);
                    	accountBillingMonthlyItems.get(aid).TotalBudget4POS = calAccountDetailValue(TotalBudget4POS, BudgetDetail4Total.Billings_CYRR__c, accountBillingMonthlyItems.get(aid).BillingsCYRR);
                    	accountBillingMonthlyItems.get(aid).TotalBudget4CMA = calAccountDetailValue(TotalBudget4CMA, BudgetDetail4Total.Billings_CYRR__c, accountBillingMonthlyItems.get(aid).BillingsCYRR);
                    	//accountBillingMonthlyItems.get(aid).ForecastCY = calAccountFCValue(BudgetDetail4Total.Forecast_CY__c, BudgetDetail4Total.Billings_CYRR__c, accountBillingMonthlyItems.get(aid).BillingsCYRR, BudgetDetail4Total.Market_Growth__c, type);
                    
                	}else{
	                	List<Budget_Detail__c> details = new List<Budget_Detail__c>();
	                	details.add(item.BudgetDetail4Direct);
	                	details.add(item.BudgetDetail4POS);
	                	details.add(item.BudgetDetail4CMA);
	                	ClsBudgetPlanBreakDownUtil.calcAccountItemValues(item, details);
                	}
                	accountBillingMonthlyItems.get(aid).TotalBudget4Total = (accountBillingMonthlyItems.get(aid).TotalBudget4Direct + 
                                                                            accountBillingMonthlyItems.get(aid).TotalBudget4POS + 
                                                                            accountBillingMonthlyItems.get(aid).TotalBudget4CMA).setScale(0);                    
                    item.isLast = false;
                    if(!map_cyRR_AccountItems.containsKey(item.BillingsCYRR)){
                        map_cyRR_AccountItems.put(item.BillingsCYRR, new list<AccountBillingMonthlyItem>());
                    }
                    map_cyRR_AccountItems.get(item.BillingsCYRR).add(item);
                }
            }
            // sort by Billings CYRR
            if(map_cyRR_AccountItems.size() > 0){
                List<Decimal> list_cyRR = new list<Decimal>();
                list_cyRR.addAll(map_cyRR_AccountItems.keySet());
                list_cyRR.sort();
                Integer si = list_cyRR.size()-1;
                for(Integer p=si; p>=0;p--){
                    Decimal rate = list_cyRR.get(p);
                    if(i == list_cyRR.size()){
                        Integer s = map_cyRR_AccountItems.get(rate).size();
                        if(s > 0) map_cyRR_AccountItems.get(rate).get(s-1).isLast = true;
                    }               
                    for(AccountBillingMonthlyItem item : map_cyRR_AccountItems.get(rate)){
                        list_items.add(item);
                    }          
                    i++;
                }
            }
            /*
        	// calculate values of the last child                          
            Decimal sumDirect = 0;
            Decimal sumPOS = 0;
            Decimal sumCMA = 0;
            Decimal sumFCY = 0;
            // when not other accounts          
            if(parentAccountItem != null){
                	sumDirect = parentAccountItem.TotalBudget4Direct;
                	sumPOS = parentAccountItem.TotalBudget4POS;
                	sumCMA = parentAccountItem.TotalBudget4CMA;
                	sumFCY = parentAccountItem.ForecastCY;
            }           
            
            for(AccountBillingMonthlyItem child: list_items){
                if(!child.isLast){
                    sumDirect += child.TotalBudget4Direct;
                    sumPOS += child.TotalBudget4POS;
                    sumCMA += child.TotalBudget4CMA;
                    sumFCY += child.ForecastCY;
                }
                else{
                    child.TotalBudget4Direct = TotalBudget4Direct - sumDirect;
                    child.TotalBudget4POS = TotalBudget4POS - sumPOS;
                    child.TotalBudget4CMA = TotalBudget4CMA - sumCMA;
                    child.ForecastCY = BudgetDetail4Total.Forecast_CY__c - sumFCY;                  
                    child.TotalBudget4Total = child.TotalBudget4Direct + child.TotalBudget4POS + child.TotalBudget4CMA;
                }
            }  */                  
        }
        return list_items;
    }
    
    /**
    * This method is used to get the parent account item
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param
    *
    @return      parent account item for break down         
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public AccountBillingMonthlyItem getParentAccountItem(){ 	
		List<Budget_Detail__c> list_budgetDetails = new List<Budget_Detail__c>();
		if(parentAccountItem != null){
			if(this.isRecalculate){
				parentAccountItem.TotalBudget4Direct = calAccountDetailValue(TotalBudget4Direct, BudgetDetail4Total.Billings_CYRR__c, parentAccountItem.BillingsCYRR);
	            parentAccountItem.TotalBudget4POS = calAccountDetailValue(TotalBudget4POS, BudgetDetail4Total.Billings_CYRR__c, parentAccountItem.BillingsCYRR);
	            parentAccountItem.TotalBudget4CMA = calAccountDetailValue(TotalBudget4CMA, BudgetDetail4Total.Billings_CYRR__c, parentAccountItem.BillingsCYRR);
	            //parentAccountItem.ForecastCY = calAccountFCValue(BudgetDetail4Total.Forecast_CY__c, BudgetDetail4Total.Billings_CYRR__c, parentAccountItem.BillingsCYRR, BudgetDetail4Total.Market_Growth__c, type);		
			}else{
				list_budgetDetails.add(parentAccountItem.BudgetDetail4Direct);
	            list_budgetDetails.add(parentAccountItem.BudgetDetail4POS);
	            list_budgetDetails.add(parentAccountItem.BudgetDetail4CMA);
	            ClsBudgetPlanBreakDownUtil.calcAccountItemValues(parentAccountItem, list_budgetDetails);
			}
			parentAccountItem.TotalBudget4Total = (parentAccountItem.TotalBudget4Direct + parentAccountItem.TotalBudget4POS + parentAccountItem.TotalBudget4CMA).setScale(0);
        
            
        }
                
        return parentAccountItem;
    }
    
    public void setParentAccountItem(AccountBillingMonthlyItem item){
    	parentAccountItem = item;	
    }
    
    /**
    * This method is used to calculate budget values for account break down page
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param      budget value, total billings cyrr, account billings cyrr 
    *
    @return     account budget value       
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public Decimal calAccountDetailValue(Decimal totalBudget, Decimal totalBilling, Decimal billing){
        Decimal detailValue = 0;
        if(totalBilling != null && totalBilling != 0) detailValue = (totalBudget / totalBilling) * billing;     
        return detailValue.setScale(0);
    }
    
    /**
    * This method is used to calculate forecast CY values for account break down page
    *
    @author Min Liu
    @created 2012-04-25
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param      budget value, total billings cyrr, account billings cyrr, growth, account type
    *
    @return     account forecast CY value      
    *
    @changelog
    * 2012-04-25 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public Decimal calAccountFCValue(Decimal totalBudget, Decimal totalBilling, Decimal billing, Decimal growth, String type){
        Decimal detailValue = 0;
        if(billing == null || billing == 0){
            return 0;
        }
        else{
            if(type == 'other'){
                if(growth == null) growth = 0;
                return (billing*(100 + growth)/100).setScale(0);
            }
            else{
                if(totalBilling != null && totalBilling != 0 && totalBudget != null){ 
                    detailValue = (totalBudget / totalBilling) * billing;       
                }
                return detailValue.setScale(0);
            }
        }
    }
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
        
    //********************************* -=BEGIN public methods=- **********************************
    //********************************* -=END public methods=- ************************************
       
    //********************************* -=BEGIN private methods=- *********************************
    //********************************* -=END private methods=- ***********************************
        
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************           
    ///*>>>WrapperClass*/
    public class AccountBillingMonthlyItem{
        // total budget
        public Decimal TotalBudget4Direct {get; set;}
        public Decimal TotalBudget4POS {get; set;}
        public Decimal TotalBudget4CMA {get; set;}
        public Decimal TotalBudget4Total {get; set;}
        
        public Decimal ForecastCY {get; set;}   
        public Decimal BillingsLY {get; set;}
        public Decimal BillingsCY {get; set;}
        public Decimal BillingsCYRR {get; set;}
        
        public String accountId  {get; set;}            
        public String accountName {get; set;}
        public String accountInfo {get; set;}
        public String accountIsoCode {get; set;}
        
        public Budget_Detail__c BudgetDetail4Direct {get; set;} 
	    public Budget_Detail__c BudgetDetail4POS {get; set;}
	    public Budget_Detail__c BudgetDetail4CMA {get; set;}
        public Boolean isLast {get;set;} 
        // the constructor
        public AccountBillingMonthlyItem(String accId, String accInfo, String accIsoCode){
            accountInfo = accInfo;
            accountId = accId;
            accountIsoCode = accIsoCode;
             
            TotalBudget4Direct = 0;
            TotalBudget4POS = 0;
            TotalBudget4CMA = 0;
            TotalBudget4Total = 0;  
                
            ForecastCY = 0;
            BillingsLY = 0;
            BillingsCY = 0;
            BillingsCYRR = 0;   
            isLast = false;
            
            // Direct
	        BudgetDetail4Direct = new Budget_Detail__c();
	        BudgetDetail4Direct.Type__c = 'Direct';
	        // POS
	        BudgetDetail4POS = new Budget_Detail__c();
	        BudgetDetail4POS.Type__c = 'POS';
	        // CMA
	        BudgetDetail4CMA = new Budget_Detail__c();
	        BudgetDetail4CMA.Type__c = 'CMA';
	        
	        
	        if(accountId != null){
	            BudgetDetail4Direct.Account__c = accountId;
	            BudgetDetail4POS.Account__c = accountId;    
	            BudgetDetail4CMA.Account__c = accountId;                       
	        }
        }
    }
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
	
}