/**
 *   This class will collect all functions about Account
 *
 * @author      Frederic Faisst 
 * @created     2012-06-07
 * @since       23.0    
 * @version     1.0                                                                 
 * 
 * @changelog
 * 2012-06-07 Frederic Faisst <frederic.faisst@itbconsult.com>
 * - Created
 *    
 */
global class ClsAccountUtil { 
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    // added by lili 2013-10-07 trigger for account currency Begin
	public static Map<String,String> map_SalesOrgCurrency = new Map<String,String>(); 
	//public static boolean isExecuteTrigger = true;
	// added by lili 2013-10-07 trigger for account currency End  
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    //********************************* -=BEGIN public methods=- **********************************
	/**
	 * This method is used to set account manager as account owner
	 *
	 @author Yinfeng Guo
	 @created 2012-03-27
	 @version 1.0
	 @since 23.0
	 *
	 @param map_accId_accManager       				map's key is Account Id and the value is Account Manager Id
	 @param map_accId_accSalesTerritoryCDE       	map's key is Account Id and the value is field SALES_TERRITORY_CDE__c on Account
	 @param list_accounts       	   				the account list that insert or update
  	 *
	 @return         void			
	 *
	 @changelog
	 * 2012-03-27 Yinfeng Guo <yinfeng.guo@itbconsult.com>
	 * - Created
  	 * 2012-06-06 Frederic Faisst <frederic.faisst@itbconsult.com>
  	 * - Changed code line 55: See description in line 54
  	 * 2012-07-18 Yinfeng Guo <yinfeng.guo@itbconsult.com>
  	 * - Changed code line 89
	 */		
	public static void SetAccManagerAsAccOwner(map<Id, Id> map_accId_accManager, map<Id, String> map_accId_accSalesTerritoryCDE, map<Id, Id> map_accId_salesHierarchyId, list<Account> list_accounts){
		
		map<Id, String> map_accManager_userPrimarySalesTerritory = new map<Id, String>();
		map<Id, String> map_accManager_teNetworkId = new map<Id, String>();
		map<Id, String> map_salesHierarchyIds_teNetworkId = new map<Id, String>();
		map<Id, Id> map_accId_ownerId = new map<Id, Id>();
		map<Id, Id> map_accId_salesHierarchyId2Search = new map<Id, Id>();
		
		set<Id> set_accManagerIds = new set<Id>();
		set_accManagerIds.addAll(map_accId_accManager.values());
		
		if(!map_accId_accManager.isEmpty() && !map_accId_accSalesTerritoryCDE.isEmpty()){
			//Step 1: If primary territory code of account manager's user record matches account territory code, then we set Account Owner = Account Manager.
			//Customized by Frederic Faisst, ITBconsult - 06.06.2012 - Added UserType = 'Standard' into Where Clause
			for(User u : [Select Id, Te_Network_Id__c, Primary_Sales_Territory__c from User where IsActive = TRUE and UserType = 'Standard']){
				if(set_accManagerIds.contains(u.Id)) map_accManager_userPrimarySalesTerritory.put(u.Id, u.Primary_Sales_Territory__c);
				map_accManager_teNetworkId.put(u.Id, u.Te_Network_Id__c);
			}
			for(Id accId : map_accId_accSalesTerritoryCDE.keySet()){
				if(map_accId_accSalesTerritoryCDE.get(accId) == map_accManager_userPrimarySalesTerritory.get( map_accId_accManager.get(accId) )) 
					map_accId_ownerId.put(accId,  map_accId_accManager.get(accId));
				else if(map_accId_salesHierarchyId.get(accId) != null && String.ValueOf(map_accId_salesHierarchyId.get(accId)) != ''){
					map_accId_salesHierarchyId2Search.put(accId, map_accId_salesHierarchyId.get(accId));
				}
			}
			
			//Step 2
			//system.debug('@@@####:map_accId_ownerId:'+map_accId_ownerId);
			if(!map_accId_salesHierarchyId2Search.isEmpty()){
				for(Sales_Hierarchy__c sh : [SELECT Id, Level_6_Assigned_User_Network_Ids__c FROM Sales_Hierarchy__c WHERE Id in: map_accId_salesHierarchyId2Search.values()]){
					map_salesHierarchyIds_teNetworkId.put(sh.Id, sh.Level_6_Assigned_User_Network_Ids__c);
				}
				/*
				for(Id accId : map_accId_salesHierarchyId2Search.keySet()){
					for(Id shId : map_salesHierarchyIds_teNetworkId.keySet()){
						for(Id userId : map_accManager_teNetworkId.keySet()){
							if(map_accId_salesHierarchyId2Search.get(accId) == shId && map_salesHierarchyIds_teNetworkId.get(shId) == map_accManager_teNetworkId.get(userId))
								map_accId_ownerId.put(accId,userId);
						}
					}
				}	
				*/
				//fix bugs for : Too many script statements: 200001
				Id shId;
				Id userId;
				for(Id accId : map_accId_salesHierarchyId2Search.keySet()){
					shId = map_accId_salesHierarchyId2Search.get(map_accId_salesHierarchyId2Search.get(accId));
					userId = map_accId_accManager.get(accId);
					if(map_salesHierarchyIds_teNetworkId.get(shId) != null && map_accManager_teNetworkId.get(userId) != null && map_salesHierarchyIds_teNetworkId.get(shId) == map_accManager_teNetworkId.get(userId))
						map_accId_ownerId.put(accId,userId);
				}
			}
			//system.debug('@@@####:map_accId_ownerId:'+map_accId_ownerId);
		}
		//system.debug('@@@####:Limits.getHeapSize()'+Limits.getHeapSize());
		//system.debug('@@@####:Limits.getScriptStatements()'+Limits.getScriptStatements());

		if(!map_accId_ownerId.isEmpty()){
			//system.debug('##map_accId_ownerId: ' + map_accId_ownerId);
			for(Account acc : list_accounts){
				if(map_accId_ownerId.containsKey(acc.Id)) acc.OwnerId = map_accId_ownerId.get(acc.Id);
			}
		}		
	}   
	
	/**
	 * This method is used to update plan group account
	 *
	 @author Xiaona Liu
	 @created 2013-05-30
	 @version 1.0
	 @since 23.0
	 *
	 @return         void			
	 *
	 @changelog
	 * 2013-05-30 Xiaona Liu <xiaona.liu@itbconsult.com>
	 * - Created
	 */

	public static void updatePlanGroupAccount(map<Id, Account> map_new, map<Id, Account> map_old){

		Set<Id> set_accIds = new Set<Id>();
		//**********************************************
		//START:find accounts which should be handled
		//**********************************************
		for(Account acc :map_new.values()){
			Account oldAcc;
			if(map_old.containsKey(acc.Id)) oldAcc = map_old.get(acc.Id);
			if(oldAcc != null){
				if(acc.SALES_TERRITORY_CDE__c != oldAcc.SALES_TERRITORY_CDE__c || acc.Individually_Planned__c != oldAcc.Individually_Planned__c || acc.Plan_Group_Account__c != oldAcc.Plan_Group_Account__c){
					set_accIds.add(acc.Id);
				}
			}			
		}

		//**********************************************
		//END:find accounts which should be handled
		//**********************************************	

		//**********************************************
		//START:populate correct plan group account
		//**********************************************			
		if(set_accIds.size() > 0){
			set<Id> set_parentAccIds = new Set<Id>();	    
		    for(Id accId:set_accIds){
		    	Account newAcc, oldAcc; 
		    	newAcc = map_new.get(accId);
		    	oldAcc = map_old.get(accId);
		    	
		        if(newAcc.Individually_Planned__c || oldAcc.Individually_Planned__c){
		            set_parentAccIds.add(newAcc.Id);
		        }
		        else{
		        	if(newAcc.Plan_Group_Account__c != null){
		            	set_parentAccIds.add(newAcc.Plan_Group_Account__c);
		        	}
		        }
		    }
		    
		    
		    map<Id,List<Account>> map_parentId_childAccounts = new map<Id,List<Account>>();
		    map<Id,Account> map_pId_parentAccount = new map<Id,Account>();
		    List<Account> list_acc2update = new list<Account>();
		    set<Id> set_aIds = new set<Id>();
		    for(Account acc:[select Id,Plan_Group_Account__c,SALES_TERRITORY_CDE__c, Plan_Group_Id__c, Individually_Planned__c from Account where Plan_Group_Account__c in:set_parentAccIds or Id in :set_parentAccIds]){
		    	Id pid = acc.Id;
		    	set_aIds.add(acc.Id);
		    	if(map_new.containsKey(acc.Id)) acc = map_new.get(acc.Id);
		    	
		    	if(set_parentAccIds.contains(acc.Id)){
		    		map_pId_parentAccount.put(acc.Id, acc);
		    	}
		    	else{
		    		pid = acc.Plan_Group_Account__c;
		    	}
		    	
		        if(!map_parentId_childAccounts.containsKey(pid)){
		            map_parentId_childAccounts.put(pid,new List<Account>());
		        }
		        if(!set_parentAccIds.contains(acc.Id)) map_parentId_childAccounts.get(pid).add(acc);
		    }
		    
		    for(Account acc : map_new.values()){
		    	if(acc.Plan_Group_Account__c != null && !set_aIds.contains(acc.Id) && map_parentId_childAccounts.containsKey(acc.Plan_Group_Account__c)){
		    		map_parentId_childAccounts.get(acc.Plan_Group_Account__c).add(acc);
		    	}
		    }
		    		    
		    for(Id pid: map_parentId_childAccounts.keySet()){
   				Account parent = map_pId_parentAccount.get(pid);   							                                      
                for(Account childrenAcc: map_parentId_childAccounts.get(pid)){							
            		if(childrenAcc.SALES_TERRITORY_CDE__c != parent.SALES_TERRITORY_CDE__c || !parent.Individually_Planned__c){                		
                    	childrenAcc.Plan_Group_Account__c = null;
                    	if(parent.Individually_Planned__c) childrenAcc.Individually_Planned__c = true;
                    	if(!map_new.containsKey(childrenAcc.Id)) list_acc2update.add(childrenAcc);
            		} 
                	                   
                }		                		        
		    }	

		    if(list_acc2update.size() > 0) update list_acc2update; 						
		}	
		//**********************************************
		//END:populate correct plan group account
		//**********************************************	
	   
	}
	
	/**
	* This method is used when insert a account for the Account_BIU_setSalesHierarchy.trigger, 
	* this method is used to set the currency of account 
	@author Lili Zhao
	@created 2013-10-07
	@version 1.0
	@since 28.0
	*
	@param 	map_SalesOrgCurrency       	map's key is Account Number and the value is currency value
  	*
	@return 	void			
	*
	@changelog
	* 2013-10-07 Lili Zhao <lili.zhao@itbconsult.com>
	* - Created
	*/		
	public static void setAccountCurrencyIsoCode(list<Account> list_accounts) {
		list<Account> list_updateAccounts = new list<Account>(); 
		if(map_SalesOrgCurrency.isEmpty()) {
			getSalesOrgCurrencyMapping();
		}		
		for(Account account : list_accounts) {
			if(account.AccountNumber != null) {
				String accountNum4 = account.AccountNumber.substring(0,4);
				if(map_SalesOrgCurrency.containsKey(accountNum4)) {
					account.CurrencyIsoCode = map_SalesOrgCurrency.get(accountNum4);
				}	
			}			
		}
	}
	/**
	* This method is used when insert a account for the Batch, 
	* this method is used to set the currency of account 
	@author Lili Zhao
	@created 2013-10-14
	@version 1.0
	@since 28.0
	*
	@param 	map_SalesOrgCurrency       	map's key is Account Number and the value is currency value
  	*
	@return 	void			
	*
	@changelog
	* 2013-10-14 Lili Zhao <lili.zhao@itbconsult.com>
	* - Created
	*/		
	public static void setAccountCurrencyIsoCodeBatch(list<Account> list_accounts) {
		list<Account> list_updateAccounts = new list<Account>(); 
		if(map_SalesOrgCurrency.isEmpty()) {
			getSalesOrgCurrencyMapping();
		}		
		for(Account account : list_accounts) {
			if(account.AccountNumber != null) {
				String accountNum4 = account.AccountNumber.substring(0,4);
				if(map_SalesOrgCurrency.containsKey(accountNum4)) {
					account.CurrencyIsoCode = map_SalesOrgCurrency.get(accountNum4);
					list_updateAccounts.add(account);
				}	
			}			
		}
		ClsSharingUtil.TriggerRecursionDefense = true;
		Database.update(list_updateAccounts, false);
	}
	
	/**
	* This method is used when insert a account for the Account_BIU_setSalesHierarchy.trigger, 
	* this method is used to set the currency of account 
	@author Lili Zhao
	@created 2013-10-07
	@version 1.0
	@since 28.0
	*
  	*
	@return 	void			   
	*
	@changelog
	* 2013-10-07 Lili Zhao <lili.zhao@itbconsult.com>
	* - Created
	*/	
	/*	
	public static void setBudgetDetailCurrentOwner(map<Id, Id> map_accId_accManagerId) {	
		list<Budget_Detail__c> list_budgetDetails = new list<Budget_Detail__c>();	
		for(Budget_Detail__c budgetDetail : [Select Account__c,Current_Owner__c,Budget__r.Status__c from Budget_Detail__c where Account__c in :map_accId_accManagerId.keySet() and Budget__r.Status__c = 'Draft']) {
			budgetDetail.Current_Owner__c = map_accId_accManagerId.get(budgetDetail.Account__c);
			system.debug('--budgetDetail.Current_Owner__c--'+budgetDetail.Current_Owner__c);
			list_budgetDetails.add(budgetDetail);
		}
		if(!list_budgetDetails.isEmpty()) { 
			update  list_budgetDetails;
		}      
	}
	*/
	
	/**
	* This method is used when insert a account for the Batch, 
	* this method is used to set the currency of account 
	@author Lili Zhao
	@created 2013-11-27
	@version 1.0
	@since 28.0
	*
	@param 	map_SalesOrgCurrency       	map's key is Account Number and the value is currency value
  	*
	@return 	void			
	*
	@changelog
	* 2013-11-27 Lili Zhao <lili.zhao@itbconsult.com>
	* - Created
	*/	  
	/*	
	public static void updateAccountField(list<Account> list_accounts) {
		//list<Account> list_updateAccounts = new list<Account>(); 				
		for(Account account : list_accounts) {
			
			// update account field IND_Customer_Classification__c
			if(account.INDUSTRY_BUSINESS_CDE__c == '081' || account.INDUSTRY_BUSINESS_CDE__c == '082' || account.INDUSTRY_BUSINESS_CDE__c == '084' || account.INDUSTRY_BUSINESS_CDE__c == '085') account.IND_Customer_Classification__c = 'Electrical DIS';
            else if(account.INDUSTRY_BUSINESS_CDE__c == '076' || account.INDUSTRY_BUSINESS_CDE__c == '077' || account.INDUSTRY_BUSINESS_CDE__c == '078' || account.INDUSTRY_BUSINESS_CDE__c == '079' || account.INDUSTRY_BUSINESS_CDE__c == '080' || account.INDUSTRY_BUSINESS_CDE__c == '083') account.IND_Customer_Classification__c = 'Electronic DIS';
            else if(account.Territory_L2_Code__c == '102206') account.IND_Customer_Classification__c = 'CD';            	
        	else if(account.GAMCD__c == 'G030' || account.GAMCD__c == 'G037' || account.GAMCD__c == 'G064' || account.GAMCD__c == 'G046' || account.GAMCD__c == 'G215' || account.GAMCD__c == 'G192' || account.GAMCD__c == 'G135' || account.GAMCD__c == 'G038' || account.GAMCD__c == 'G131' || account.GAMCD__c == 'G132' || account.GAMCD__c == 'G130') account.IND_Customer_Classification__c = 'A';			
			else if(account.INDUSTRY_BUSINESS_CDE__c == '105' || account.INDUSTRY_BUSINESS_CDE__c == '113' || account.INDUSTRY_BUSINESS_CDE__c == '106' || account.INDUSTRY_BUSINESS_CDE__c == '117' || account.INDUSTRY_BUSINESS_CDE__c == '116') account.IND_Customer_Classification__c = 'IND B';
			else if(account.INDUSTRY_BUSINESS_CDE__c == '211' && account.Territory_L2_Code__c == '102202') account.IND_Customer_Classification__c = 'IND B';
			else account.IND_Customer_Classification__c = 'Other BU B';
			
            // update account field IND_Billing_Region__c    
            if(account.RecordType.DeveloperName == 'CIS_Account') {
            	if(account.LAYER2_ORGANIZATION_ID__c == '0002' || account.LAYER2_ORGANIZATION_ID__c == '0933') account.IND_Billing_Region__c = 'Americas';
            	else if(account.LAYER3_ORGANIZATION_ID__c == '0988')  account.IND_Billing_Region__c = 'India';
            	else if(account.LAYER3_ORGANIZATION_ID__c == '0402' || account.LAYER3_ORGANIZATION_ID__c == '0414' || account.LAYER3_ORGANIZATION_ID__c == '0420') account.IND_Billing_Region__c = 'EMEA';
            	else if(account.Company_Reporting_Org__c == '0010' || account.Company_Reporting_Org__c == '0791' || account.Company_Reporting_Org__c == '0999' || account.Company_Reporting_Org__c == '1081' || account.Company_Reporting_Org__c == '1497' || account.Company_Reporting_Org__c == '1499' || account.Company_Reporting_Org__c == '1500') account.IND_Billing_Region__c = 'Japan';
            	else if(account.Company_Reporting_Org__c == '0448' || account.Company_Reporting_Org__c == '1001' || account.Company_Reporting_Org__c == '1114' || account.Company_Reporting_Org__c == '1864' || account.Company_Reporting_Org__c == '2149') account.IND_Billing_Region__c = 'Korea';
            	else if(account.BillingCountry != 'KP' && account.BillingCountry != 'KR' && account.BillingCountry != 'AU'  && (  
		            	 (account.Company_Reporting_Org__c == '0450' || account.Company_Reporting_Org__c == '1006' || account.Company_Reporting_Org__c == '1115' || 
			            	account.Company_Reporting_Org__c == '1286' || account.Company_Reporting_Org__c == '1287' || account.Company_Reporting_Org__c == '1473' || 
			            	account.Company_Reporting_Org__c == '0451' || account.Company_Reporting_Org__c == '1009' || account.Company_Reporting_Org__c == '1321' || (
			            	 (account.Company_Reporting_Org__c == '0463' || account.Company_Reporting_Org__c == '1914' || account.Company_Reporting_Org__c == '1014' || 
			            	  account.Company_Reporting_Org__c == '1160' || account.Company_Reporting_Org__c == '1591') && 
            				 (account.INDUSTRY_BUSINESS_CDE__c == '081' || account.INDUSTRY_BUSINESS_CDE__c == '082' || account.INDUSTRY_BUSINESS_CDE__c == '084' || 
            				  account.INDUSTRY_BUSINESS_CDE__c == '085' || account.INDUSTRY_BUSINESS_CDE__c == '076' || account.INDUSTRY_BUSINESS_CDE__c == '077' || 
            				  account.INDUSTRY_BUSINESS_CDE__c == '078' || account.INDUSTRY_BUSINESS_CDE__c == '079' || account.INDUSTRY_BUSINESS_CDE__c == '080' || 
            				  account.INDUSTRY_BUSINESS_CDE__c == '083' || account.Territory_L2_Code__c == '102206')
            				)
            			 ) 
            		  )) account.IND_Billing_Region__c = 'Greater China';
            	else if(account.BillingCountry == 'KR') account.IND_Billing_Region__c = 'Korea';
            	else if(account.LAYER2_ORGANIZATION_ID__c == '0442' || account.LAYER2_ORGANIZATION_ID__c == '0934') account.IND_Billing_Region__c = 'Rest of APAC';
            	else account.IND_Billing_Region__c = ' ';           	
            }else if(account.RecordType.DeveloperName == 'CIS_Prospect'){
            	if(account.Customer_Region__c == 'Asia (excl. China and Japan)' || account.Customer_Region__c == 'Australia / New Zealand')  account.IND_Billing_Region__c = 'Rest of APAC';
            	else if(account.Customer_Region__c == 'South America' || account.Customer_Region__c == 'North America')  account.IND_Billing_Region__c = 'Americas';
            	else if(account.Customer_Region__c == 'China / HK / Taiwan') account.IND_Billing_Region__c = 'Greater China';
            	else if(account.Customer_Region__c == 'Korea') account.IND_Billing_Region__c = 'Korea';
            	else if(account.Customer_Region__c == 'Japan') account.IND_Billing_Region__c = 'Japan';
            	else if(account.Customer_Region__c == 'India' || account.Customer_Region__c == 'EMEA (excl. India)') account.IND_Billing_Region__c = 'EMEA';
            	else  account.IND_Billing_Region__c = ' ';
            }else {
            	account.IND_Billing_Region__c = ' ';
            }           
		}
		ClsSharingUtil.TriggerRecursionDefense = true;
		Database.update(list_accounts, false);
	}
	*/
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************   
    /**
	* This method is used when insert a account for the Account_BIU_setSalesHierarchy.trigger, 
	* this method is used to get the currency from custom setting
	*
	@author Lili Zhao
	@created 2013-10-07
	@version 1.0
	@since 28.0
	*
	@param 	map_SalesOrgCurrency       	map's key is Account Number and the value is currency value
  	*
	@return 						void			
	*
	@changelog
	* 2013-10-07 Lili Zhao <lili.zhao@itbconsult.com>
	* - Created
	*/		
	private static void getSalesOrgCurrencyMapping(){
		for(SalesOrg_Currency__c  SalesOrgCurrency : SalesOrg_Currency__c.getAll().Values()){
            map_SalesOrgCurrency.put(SalesOrgCurrency.Name,SalesOrgCurrency.Currency__c);
        }
	}
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/  
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
}