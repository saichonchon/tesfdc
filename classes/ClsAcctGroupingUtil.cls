/**
 *  Util class for page CtrlAcctGrouping
 *
 @author    Bin Yuan
 @created   2014-03-27
 @version   1.0
 @since     29.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-03-27 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created
 */
public without sharing class ClsAcctGroupingUtil {
   
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public static String OTHER = system.label.APL_Other_Accounts;
    public static String OTHERAcctId = ClsAPLForecastUtil.OTHERACCTID;
    public static String DEFAULT_CURRENCY = 'USD';
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
   /**
    * This method is used get account hierarchy for current account manager.
    *
    @author Bin Yuan
    @created 2014-03-27
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-27 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void getAcctHieraychy(String managerId, list<ParentAcctObj> list_parentAccts, CtrlAccountGrouping.PageConfig pageConf) {
    	pageConf.map_acctId_acct.clear();
    	
    	map<String, ParentAcctObj> map_parentAcctId_parentAcct = new map<String, ParentAcctObj>();
    	set<String> set_totalAcctIds = new set<String>();
    	//boolean isRelay = false;
    	
    	String groupAcctQuery = getAccountQuery(managerId, pageConf);
    	if(groupAcctQuery == ''){
    		return;
    	}
    	
    	
    	/*String username = '';
    	String stringsql = '';
        stringsql += 'Select  A6_Code__c , Manager__r.Name ';
        stringsql += ' from APL_Forecast_Management__c ';
        stringsql += ' Where RecordType.DeveloperName = \''+(pageConf.isRelay ? 'AM' : 'Relay')+'\' And A6_Code__c = \''+pageConf.territoryCode+'\' ';
        for(APL_Forecast_Management__c mananger : database.query(stringsql)){	
        	username = mananger.Manager__r.Name;
        }*/
        
    	
        //get grouped accounts
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'groupAcctQuery :: '+ groupAcctQuery));
        for(Account acct : database.query(groupAcctQuery)){	
        	pageConf.map_acctId_acct.put(acct.Id, acct);
        	String relayname = (acct.Account_Manager_Name__c != null ? acct.Account_Manager_Name__c : '' );
        	String amname = (acct.Relay_Hierarchy__r.Level_7_Default_Owner__r.Name != null ? acct.Relay_Hierarchy__r.Level_7_Default_Owner__r.Name : '' );
        	String username = (pageConf.isRelay ? relayname : amname ); 
        	String acctId = acct.Id,
        			pid = (pageConf.isRelay ? (acct.APL_Relay_forecast_Plan_Account__c == null ? OTHERAcctId : acct.APL_Relay_forecast_Plan_Account__c) 
        										: (acct.APL_AM_forecast_Plan_Account__c == null ? OTHERAcctId : acct.APL_AM_forecast_Plan_Account__c)),
        			parentAcctNumb = ((pid == OTHERAcctId ) ? OTHER : 
		        					 (pageConf.isRelay ? (acct.APL_Relay_ParentAccount__c == null ? (acct.AccountNumber) 
		        					 						: (acct.APL_Relay_ParentAccount__r.AccountNumber)) 
		        					 : (acct.APL_AM_ParentAccount__c == null ? (acct.AccountNumber) 
		        					 						: (acct.APL_AM_ParentAccount__r.AccountNumber)))),
        			parentAcctName = ((pid == OTHERAcctId ) ? OTHER : 
		        					 (pageConf.isRelay ? (acct.APL_Relay_ParentAccount__c == null ? ((acct.AccountNumber == null ? '' : acct.AccountNumber) + ' ' + acct.Name) 
		        					 						: ((acct.APL_Relay_ParentAccount__r.AccountNumber == null ? '' : acct.APL_Relay_ParentAccount__r.AccountNumber) + ' ' + acct.APL_Relay_ParentAccount__r.Name)) 
		        					 : (acct.APL_AM_ParentAccount__c == null ? ((acct.AccountNumber == null ? '' : acct.AccountNumber) + ' ' + acct.Name) 
		        					 						: ((acct.APL_AM_ParentAccount__r.AccountNumber == null ? '' : acct.APL_AM_ParentAccount__r.AccountNumber) + ' ' + acct.APL_AM_ParentAccount__r.Name)))),
        					
					parentAcctDisplayName = ((pid == OTHERAcctId ) ? OTHER : 
				        					(pageConf.isRelay ? (acct.APL_Relay_ParentAccount__c == null ? acct.APL_Relay_Display_Name__c : acct.APL_Relay_ParentAccount__r.APL_Relay_Display_Name__c) : 
				        					(acct.APL_AM_ParentAccount__c == null ? acct.APL_AM_Display_Name__c : acct.APL_AM_ParentAccount__r.APL_AM_Display_Name__c))),
        					 
					parentCurrencyIsoCode = ((pid == OTHERAcctId ) ? DEFAULT_CURRENCY : 
				        					(pageConf.isRelay ? (acct.APL_Relay_ParentAccount__c == null ? acct.APL_Relay_Currency__c : acct.APL_Relay_ParentAccount__r.APL_Relay_Currency__c) : 
				        					(acct.APL_AM_ParentAccount__c == null ? acct.APL_AM_Currency__c : acct.APL_AM_ParentAccount__r.APL_AM_Currency__c)));
        					
            //Create parent object
            if(!map_parentAcctId_parentAcct.containsKey(pid)) {		
            	
		    	ParentAcctObj parentAcct = new ParentAcctObj(pid, (pid == OTHERAcctId ? OTHERAcctId : pid), parentAcctName,
		    											parentCurrencyIsoCode, parentAcctName,
		    											(parentAcctDisplayName == null ? '' : parentAcctDisplayName),
		    											pid, parentCurrencyIsoCode, (acct.BillingState == null ? '' : acct.BillingState), username);
		
				parentAcct.acctNumb = parentAcctNumb;
		    	map_parentAcctId_parentAcct.put(pid, parentAcct);
		    	if(pid != OTHERAcctId) {
		        	list_parentAccts.add(parentAcct);
		    	}
            }
            //build child list
            if(pid != acctId) {	
            	
            	String childDisplayName = (pageConf.isRelay ? acct.APL_Relay_Display_Name__c : acct.APL_AM_Display_Name__c);
            	
            	ChildAcctObj child = new ChildAcctObj(pid, acct.id, (acct.AccountNumber == null ? '' : acct.AccountNumber + ' ') + acct.Name,
            										(pageConf.isRelay ? acct.APL_Relay_Currency__c : acct.APL_AM_Currency__c),
            										(acct.AccountNumber == null ? '' : acct.AccountNumber + ' ') + acct.Name,
            										(childDisplayName == null ? '' : childDisplayName), pid, (pageConf.isRelay ? acct.APL_Relay_Currency__c : acct.APL_AM_Currency__c), (acct.BillingState == null ? '' : acct.BillingState), username);
				child.acctNumb = acct.AccountNumber;
            	map_parentAcctId_parentAcct.get(pid).list_childAccts.add(child);
            }   
        }

        if(!map_parentAcctId_parentAcct.containsKey(OTHERAcctId)) {	//Add Other group as last
        	ParentAcctObj parentAcct = new ParentAcctObj(OTHERAcctId, OTHERAcctId, OTHER, DEFAULT_CURRENCY, OTHER,
        												OTHER, OTHERAcctId, DEFAULT_CURRENCY);

        	map_parentAcctId_parentAcct.put(OTHERAcctId, parentAcct);
        }
        
        list_parentAccts.add(map_parentAcctId_parentAcct.get(OTHERAcctId));
        
        for(ParentAcctObj parent : map_parentAcctId_parentAcct.values()) {	//parse child list into json string
        	list<ChildAcctObj> list_childAccts = new list<ChildAcctObj>();
        	list_childAccts.addAll(parent.list_childAccts);
        	list_childAccts.sort();
        	
        	parent.children = Json.serialize(list_childAccts);
        }
    }
	
   /**
    * This method is used get account hierarchy for current account manager.
    *
    @author Bin Yuan
    @created 2014-03-27
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-27 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
	public static String getAccountQuery(String managerId, CtrlAccountGrouping.PageConfig pageConf){
		String query = '';
        query = ' Select Id, AccountNumber, Name, BillingState, SALES_TERRITORY_CDE__c, Relay_Specialist_Territory_Code__c, Account_Manager_Name__c, Relay_Hierarchy__r.Level_7_Default_Owner__r.Name, '; 
        String str_relatQuery = ' APL_Relay_forecast_Plan_Account__c, APL_Relay_Currency__c, APL_Relay_Display_Name__c, APL_Relay_ParentAccount__c, '
        					  + ' APL_Relay_ParentAccount__r.APL_Relay_Display_Name__c, APL_Relay_ParentAccount__r.APL_Relay_Currency__c, APL_Relay_ParentAccount__r.AccountNumber, APL_Relay_ParentAccount__r.Name ';
        					  
        String str_amQuery = ' APL_AM_forecast_Plan_Account__c, APL_AM_Currency__c, APL_AM_Display_Name__c, APL_AM_ParentAccount__c, APL_AM_ParentAccount__r.APL_AM_Display_Name__c, '
        				   + ' APL_AM_ParentAccount__r.APL_AM_Currency__c, APL_AM_ParentAccount__r.AccountNumber, APL_AM_ParentAccount__r.Name ';
        query += (pageConf.isRelay ? str_relatQuery : str_amQuery);				   
        query += ' FROM Account ';
        query += ' WHERE ' + (pageConf.isRelay ? 'Relay_Specialist_Territory_Code__c' : 'SALES_TERRITORY_CDE__c') + ' = \'' + pageConf.territoryCode + '\'';
        query += ' And STATDESC__c = \'Active\' ';
        
        return query;
	}
	
   /**
    * This method is used get account hierarchy for current account manager.
    *
    @author Bin Yuan
    @created 2014-03-27
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-27 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
	public static boolean checkIfRelayOrAM(String managerId, map<String, list<ClsAPLEntityTypes.AcctGroupingTerritroy>> map_managerType_list_Codes, CtrlAccountGrouping.PageConfig pageConf){
		boolean shouPopup = false;
		for(APL_Forecast_Management__c forecastManager : [Select Id, A6_Code__c, Manager__c, AM_Freeze__c, RecordType.DeveloperName
														  From APL_Forecast_Management__c
														  Where Manager__c = : managerId
														  And A6_Code__c != null
														  And RecordTypeId != null]) {
			pageConf.isRelay = (forecastManager.RecordType.DeveloperName == 'Relay' ? true : false);
			pageConf.territoryCode = forecastManager.A6_Code__c;	
			pageConf.isFrozen = forecastManager.AM_Freeze__c;
			if(!map_managerType_list_Codes.containsKey(forecastManager.RecordType.DeveloperName)) {
				map_managerType_list_Codes.put(forecastManager.RecordType.DeveloperName, new list<ClsAPLEntityTypes.AcctGroupingTerritroy>());
			}
			ClsAPLEntityTypes.AcctGroupingTerritroy territory = new ClsAPLEntityTypes.AcctGroupingTerritroy(forecastManager.A6_Code__c, forecastManager.AM_Freeze__c);
			map_managerType_list_Codes.get(forecastManager.RecordType.DeveloperName).add(territory);
		}
		if(map_managerType_list_Codes.keySet().size() > 1) {
			shouPopup = true;
		}
		for(String rtType : map_managerType_list_Codes.keySet()) {
			if(map_managerType_list_Codes.get(rtType).size() > 1) {
				shouPopup = true;
			}
		}
		return shouPopup;
	}
	
    
   /**
    * This method is used get account hierarchy for current account manager.
    *
    @author Bin Yuan
    @created 2014-03-27
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-27 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void saveAcctGroup(list<ParentAcctObj> list_parentAccts2Save, CtrlAccountGrouping.PageConfig pageConf) {
    	try {

	    	map<String, ParentAcctObj> map_acctId_parentAcct = new map<String, ParentAcctObj>();
	    	map<String, ChildAcctObj> map_acctId_childAcct = new map<String, ChildAcctObj>();
	    	list<Account> list_accts2Update = new list<Account>();
	    	
	    	map<Id, Account> map_updateAttc = new map<Id, Account>();
	    	
	    	set<String> set_acctIds = new set<String>();
	    	
	    	for(ParentAcctObj parent : list_parentAccts2Save) {	//loop to get all account ids and build account map
	    		map_acctId_parentAcct.put(parent.parentAcctId, parent);
	    		if(parent.parentAcctId != OTHERAcctId) {
	    			set_acctIds.add(parent.parentAcctId);
	    		}
	    		if(!parent.list_childAccts.isEmpty()) {
		    		for(ChildAcctObj child : parent.list_childAccts) {
		    			map_acctId_childAcct.put(child.acctId, child);
		    			set_acctIds.add(child.acctId);
		    		}
	    		}
	    	}
	    	//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'set_acctIds :: ' + set_acctIds));
	    	//get all accounts and update account information
	    	for(Account acct : [Select Id, Account_Combined_Data__c, APL_AM_Currency__c, APL_Relay_Currency__c, APL_AM_Display_Name__c, APL_Relay_Display_Name__c,  
	    							   APL_Relay_ParentAccount__c, APL_AM_ParentAccount__c, APL_Relay_forecast_Plan_Account__c, APL_AM_forecast_Plan_Account__c
								From Account 
								Where Id in : set_acctIds
								And STATDESC__c != 'Not Active' ]) {

				if(map_acctId_parentAcct.containsKey(acct.Id)) {
					ParentAcctObj parent = map_acctId_parentAcct.get(acct.Id);
					if(parent.parentAcctId != OTHERAcctId) {
						generateAcctInfo(acct.Id, parent.parentAcctIsoCode, parent.displayName, acct, pageConf.isRelay);
						String newParentId = (pageConf.isRelay ? (acct.APL_Relay_forecast_Plan_Account__c == '' ? OTHERAcctId : acct.APL_Relay_forecast_Plan_Account__c) 
        										: (acct.APL_AM_forecast_Plan_Account__c == '' ? OTHERAcctId : acct.APL_AM_forecast_Plan_Account__c));
                        checkAcctInfo(parent.oldParentId, parent.oldCurrency, parent.parentAcctIsoCode, newParentId, acct, pageConf);
					}
				}
				if(map_acctId_childAcct.containsKey(acct.id)) {
					ChildAcctObj child = map_acctId_childAcct.get(acct.id);
					ParentAcctObj parent = map_acctId_parentAcct.get(child.parentAcctId);
					generateAcctInfo(child.parentAcctId, parent.parentAcctIsoCode, parent.displayName, acct, pageConf.isRelay);
					
					String newParentId = (pageConf.isRelay ? (acct.APL_Relay_forecast_Plan_Account__c == '' ? OTHERAcctId : acct.APL_Relay_forecast_Plan_Account__c) 
        										: (acct.APL_AM_forecast_Plan_Account__c == '' ? OTHERAcctId : acct.APL_AM_forecast_Plan_Account__c));
                    checkAcctInfo(child.oldParentId, child.oldCurrency, parent.parentAcctIsoCode, newParentId, acct, pageConf);

				}	
				
				list_accts2Update.add(acct);					
			}
	    	if(!list_accts2Update.isEmpty()) {
				//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'list_accts2Update :: ' + list_accts2Update));
	    		update list_accts2Update;
	    	}
    	}catch(Exception ex) {
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getStackTraceString()));
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
    		throw ex;
    	}
    }
    
    
    public static void checkAccountChanged(list<ParentAcctObj> list_save, list<ParentAcctObj> list_old, CtrlAccountGrouping.PageConfig pc){
    	
    	
    }
    
    
   /**
    * This method is used get account hierarchy for current account manager.
    *
    @author Bin Yuan
    @created 2014-03-27
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-27 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void checkAcctIsChanged(list<ParentAcctObj> list_parentAccts2Save, CtrlAccountGrouping.PageConfig pageConf) {
    	try {
	    	map<String, ParentAcctObj> map_acctId_parentAcct = new map<String, ParentAcctObj>();
	    	map<String, ChildAcctObj> map_acctId_childAcct = new map<String, ChildAcctObj>();
	    	set<String> set_acctIds = new set<String>();
	    	list<Account> list_accts2Update = new list<Account>();
	    	for(ParentAcctObj parent : list_parentAccts2Save) {	//loop to get all account ids and build account map
	    		map_acctId_parentAcct.put(parent.parentAcctId, parent);
	    		if(parent.parentAcctId != OTHERAcctId) {
	    			set_acctIds.add(parent.parentAcctId);
	    		}
	    		if(!parent.list_childAccts.isEmpty()) {
		    		for(ChildAcctObj child : parent.list_childAccts) {
		    			map_acctId_childAcct.put(child.acctId, child);
		    			set_acctIds.add(child.acctId);
		    		}
	    		}
	    	}
	    	//get all accounts and update account information
	    	for(Account acct : pageConf.map_acctId_acct.values()) {

				String pid = (pageConf.isRelay ? (acct.APL_Relay_forecast_Plan_Account__c == null ? OTHER : acct.APL_Relay_forecast_Plan_Account__c) 
        										: (acct.APL_AM_forecast_Plan_Account__c == null ? OTHER : acct.APL_AM_forecast_Plan_Account__c));
				if(map_acctId_parentAcct.containsKey(acct.Id)) {
					ParentAcctObj parent = map_acctId_parentAcct.get(acct.Id);
					if(parent.parentAcctId != OTHERAcctId) {
						generateAcctInfo(acct.Id, parent.parentAcctIsoCode, parent.displayName, acct, pageConf.isRelay);
						String newParentId = (pageConf.isRelay ? (acct.APL_Relay_forecast_Plan_Account__c == '' ? OTHERAcctId : acct.APL_Relay_forecast_Plan_Account__c) 
        										: (acct.APL_AM_forecast_Plan_Account__c == '' ? OTHERAcctId : acct.APL_AM_forecast_Plan_Account__c));
                        checkAcctInfo(parent.oldParentId, parent.oldCurrency, parent.parentAcctIsoCode, newParentId, acct, pageConf);
					}
				}
				if(map_acctId_childAcct.containsKey(acct.id)) {
					ChildAcctObj child = map_acctId_childAcct.get(acct.id);
					ParentAcctObj parent = map_acctId_parentAcct.get(child.parentAcctId);
					generateAcctInfo(child.parentAcctId, parent.parentAcctIsoCode, parent.displayName, acct, pageConf.isRelay);
					String newParentId = (pageConf.isRelay ? (acct.APL_Relay_forecast_Plan_Account__c == '' ? OTHERAcctId : acct.APL_Relay_forecast_Plan_Account__c) 
        										: (acct.APL_AM_forecast_Plan_Account__c == '' ? OTHERAcctId : acct.APL_AM_forecast_Plan_Account__c));
                    checkAcctInfo(child.oldParentId, child.oldCurrency, parent.parentAcctIsoCode, newParentId, acct, pageConf);
				}	
				list_accts2Update.add(acct);
			}
			
	    	if(!list_accts2Update.isEmpty()) {
				//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'list_accts2Update :: ' + list_accts2Update));
	    		update list_accts2Update;
	    	}
    	}catch(Exception ex) {
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getStackTraceString()));
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
    		throw ex;
    	}
    }
    
   /**
    * This method is used get account hierarchy for current account manager.
    *
    @author Bin Yuan
    @created 2014-03-27
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-27 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void updateAcctForGrouping(CtrlAccountGrouping.PageConfig pageConf) {
    	try {
    		list<Account> list_accts2Update = new list<Account>();
	    	for(String acctId : pageConf.set_modifiedAcctIds) {
    			list_accts2Update.addAll(pageConf.map_acctId_acct.values());
	    	}
	    	if(!list_accts2Update.isEmpty()) {
	    		update list_accts2Update;
	    	}
    	}catch(Exception ex) {
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getStackTraceString()));
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
    		throw ex;
    	}
    }
    
   /**
    * This method is used to generate account grouping information.
    *
    @author Bin Yuan
    @created 2014-03-27
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-27 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void generateAcctInfo(String parentAcctId, String isoCode, String displayName, Account acct, boolean isRelay) {
		
		if(parentAcctId == OTHERAcctId || parentAcctId == '') {
			if(isRelay) {
				acct.APL_Relay_ParentAccount__c = null;
				acct.APL_Relay_forecast_Plan_Account__c = '';
				acct.APL_Relay_Display_Name__c = system.label.APL_Other_Accounts;
			}
			else {
				acct.APL_AM_ParentAccount__c = null;
				acct.APL_AM_forecast_Plan_Account__c = '';
				acct.APL_AM_Display_Name__c = system.label.APL_Other_Accounts;
			}
		}
		if(isRelay) {
			acct.APL_Relay_Currency__c = (isoCode == OTHER ? acct.APL_Relay_Currency__c : isoCode);
			acct.APL_Relay_Display_Name__c = displayName;
			if(parentAcctId != OTHERAcctId) {
				acct.APL_Relay_ParentAccount__c = (parentAcctId == acct.Id ? null : parentAcctId);
				acct.APL_Relay_forecast_Plan_Account__c = parentAcctId;
			}
			else {
				acct.APL_Relay_forecast_Plan_Account__c = '';
				acct.APL_Relay_Display_Name__c = system.label.APL_Other_Accounts;
			}
		}
		else {
			acct.APL_AM_Currency__c = (isoCode == OTHER ? acct.APL_AM_Currency__c : isoCode);
			acct.APL_AM_Display_Name__c = displayName;
			if(parentAcctId != OTHERAcctId) {
				acct.APL_AM_ParentAccount__c = (parentAcctId == acct.Id ? null : parentAcctId);
				acct.APL_AM_forecast_Plan_Account__c = parentAcctId;
			}
			else {
				acct.APL_AM_forecast_Plan_Account__c = '';
				acct.APL_AM_Display_Name__c = system.label.APL_Other_Accounts;
			}
		}
		
    }

   /**
    * This method is used to generate account grouping information.
    *
    @author Bin Yuan
    @created 2014-03-27
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-27 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void checkAcctInfo(String oldParentId, String oldCurrency, String newCurrency, String newParentId, Account acct, CtrlAccountGrouping.PageConfig pageConf) {
        if(newParentId != oldParentId || oldCurrency != newCurrency) { 
        	if(!(oldParentId == OTHERAcctId && newParentId == '')) {
	            pageConf.set_modifiedAcctIds.add(acct.Id);
        	}
        }
    }

   /**
    * This method is used to generate account grouping information.
    *
    @author Bin Yuan
    @created 2014-03-27
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-27 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void updateAcctForecast(CtrlAccountGrouping.PageConfig pageConf) {
        set<String> set_acctIds = pageConf.set_modifiedAcctIds;
        list<APL_Sales_Forecast__c> list_aplSalesForecast2Update = new list<APL_Sales_Forecast__c>();
        String query = ' Select Id, Customer__c, CurrencyIsoCode, Customer__r.APL_Relay_Currency__c, Customer__r.APL_AM_Currency__c '
                    + ' From APL_Sales_Forecast__c '
                    + ' Where Customer__c IN: set_acctIds ';
        String filter = (pageConf.str_lastAcctForecastId != '' ? ' And Id > \'' + pageConf.str_lastAcctForecastId +'\'' : '');
        String orderBy = ' order by Id Asc limit 500 ';

        query += (filter + orderBy);
        Integer counter = 0;
        for(APL_Sales_Forecast__c salesFC : database.query(query)) {
            if(pageConf.isRelay) {
                salesFC.CurrencyIsoCode = salesFC.Customer__r.APL_Relay_Currency__c;
            }
            else {
                salesFC.CurrencyIsoCode = salesFC.Customer__r.APL_AM_Currency__c;
            }
            list_aplSalesForecast2Update.add(salesFC);
            pageConf.str_lastAcctForecastId = salesFC.Id;
            counter ++;
        }
        if(!list_aplSalesForecast2Update.isEmpty()) {
        	update list_aplSalesForecast2Update;
        }
        pageConf.str_lastAcctForecastId = (counter < 500 ? '' : pageConf.str_lastAcctForecastId);
    }
    
   /**
    * This method is used to generate account grouping information.
    *
    @author Bin Yuan
    @created 2014-03-27
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-27 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void removeRelayOtherFC(CtrlAccountGrouping.PageConfig pageConf) {
    	list<APL_Sales_Forecast__c> list_aplRelayFC2Delete = new list<APL_Sales_Forecast__c>();
    	if(pageConf.currentYear == '' || pageConf.currentQuarter == '') {
    		for(Period p : [select FiscalYearSettings.Name, Number from Period where StartDate <= Today and EndDate >= Today and Type = 'Quarter']) {
    			pageConf.currentYear = p.FiscalYearSettings.Name;
    			pageConf.currentQuarter = '0' + String.valueOf(p.Number);
    		}
    	}
    	Integer recordCounter = 0;
		String query = ' Select Id '
			 		 + ' From APL_Sales_Forecast__c '
			 		 + ' Where Customer__r.Relay_Specialist_Territory_Code__c = \'' + pageConf.territoryCode + '\' '
			 		 + ' And Type__c = \'' + ClsAPLForecastUtil.RELAYFCTYPE + '\' '
			 		 + ' And Customer__r.APL_Relay_forecast_Plan_Account__c = null '
			 		 + ' And (Fiscal_Year__c > \'' + pageConf.currentYear + '\''
			 		 + '    OR (Fiscal_Year__c = \'' + pageConf.currentYear + '\''
			 		 + '		And Fiscal_quarter__c >= \'' + pageConf.currentQuarter + '\' )'		
			 		 + ' 	)'	
			 		 + (pageConf.str_lastRemoveId == ''? '' : ' And Id > \'' + pageConf.str_lastRemoveId + '\''
			 		 + ' Order by Id ');
			 		 
		for(APL_Sales_Forecast__c aplFC : database.query(query)) {
			list_aplRelayFC2Delete.add(aplFC);
			pageConf.str_lastRemoveId = aplFC.Id;
			recordCounter ++;
			
		}
		pageConf.str_lastRemoveId = (recordCounter <500 ? '' : pageConf.str_lastRemoveId);
		if(!list_aplRelayFC2Delete.isEmpty()) {
			delete list_aplRelayFC2Delete;
		}
    }
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>InnerClass*/
    public class ParentAcctObj implements Comparable {
    	public String parentAcctName {get; set;}
    	public String acctNumb {get; set;}
    	public String parentAcctId {get; set;}
    	public String acctId {get; set;}
    	public String parentAcctIsoCode {get; set;}
    	public String acctIsoCode {get; set;}
    	public String title {get; set;}
    	public boolean folder {get; set;}
    	public boolean expanded {get; set;}
    	public String children {get; set;}
    	public String displayName {get; set;}
        public String oldParentId {get; set;}
        public String oldCurrency {get; set;}
        public String billingprovince {get; set;}
        public String username {get; set;}

    	//public list<Account> list_childAccts {get; set;}
    	public list<ChildAcctObj> list_childAccts {get; set;}
    	
    	public ParentAcctObj() {
    		this.parentAcctName = '';
    		this.acctId = '';
    		this.parentAcctId = '';
    		this.parentAcctIsoCode = '';
    		this.acctIsoCode = '';
    		//this.list_childAccts = new list<Account>();
    		this.list_childAccts = new list<ChildAcctObj>();
    		this.title = '';
    		this.folder = true;
    		this.expanded = false;
    		this.children = '';
    		this.displayName = '';
            this.oldParentId = '';
            this.oldCurrency = '';
            this.acctNumb = '';
            this.billingprovince = '';
            this.username = '';
    	}
    	public ParentAcctObj(String pid, String acctId, String pName, String pCode, String title, String dName, String oldPid, String oldpCode) {
				
			this.parentAcctId = pid;
			this.acctId = acctId;
    		this.parentAcctName = pName;
    		this.acctIsoCode = (pCode == null || pCode == '' ? DEFAULT_CURRENCY : pCode);
    		this.title = title;
    		this.displayName = dName;
        	this.oldParentId = oldPid;
        	this.oldCurrency = oldpCode;
        	this.billingprovince = '';
            this.username = '';
        	this.folder = true;
        	this.expanded = false;
        	this.list_childAccts = new list<ChildAcctObj>();
    	}
    	
    	public ParentAcctObj(String pid, String acctId, String pName, String pCode, String title, String dName, String oldPid, String oldpCode, String billingprovince, String username) {
				
			this.parentAcctId = pid;
			this.acctId = acctId;
    		this.parentAcctName = pName;
    		this.acctIsoCode = (pCode == null || pCode == '' ? DEFAULT_CURRENCY : pCode);
    		this.title = title;
    		this.displayName = dName;
        	this.oldParentId = oldPid;
        	this.oldCurrency = oldpCode;
        	this.billingprovince = billingprovince;
            this.username = username;
        	this.folder = true;
        	this.expanded = false;
        	this.list_childAccts = new list<ChildAcctObj>();
    	}
    	
        public Integer compareTo(Object compareTo) {
            ChildAcctObj compareToAcct = (ChildAcctObj) compareTo;
            if (this.acctNumb == compareToAcct.acctNumb) return 0;
            if (this.acctNumb > compareToAcct.acctNumb) return 1;
            return -1;        
        }
    }
    
    public class ChildAcctObj implements Comparable {
    	public String acctName {get; set;}
    	public String acctId {get; set;}
    	public String acctIsoCode {get; set;}
    	public String acctNumb {get; set;}
    	public String parentAcctId {get; set;}
    	public String title {get; set;}
    	public boolean folder {get; set;}
    	public boolean expanded {get; set;}
    	public String displayName {get; set;}
        public String oldParentId {get; set;}
        public String oldCurrency {get; set;}
        public String billingprovince {get; set;}
        public String username {get; set;}

    	public ChildAcctObj() {
    		this.acctName = '';
    		this.acctId = '';
    		this.acctIsoCode = '';
    		this.title = '';
    		this.folder = true;
    		this.expanded = false;
    		this.displayName = '';
    		this.parentAcctId = '';
            this.oldParentId = '';
            this.oldCurrency = '';
            this.acctNumb = '';
            this.billingprovince = '';
            this.username = '';
    	}
    	
    	public ChildAcctObj(String pid, String acctId, String acctName, String isoCode, String title, String dName, String oldpId, String oldisoCode){
    		this.parentAcctId = pid;
    		this.acctId = acctId;
    		this.acctName = acctName;
    		this.acctIsoCode = (isoCode == null || isoCode == '' ? DEFAULT_CURRENCY : isoCode);
    		this.title = title;
    		this.displayName = dName;
    		this.oldParentId = oldpId;
    		this.oldCurrency = oldisoCode;
    		this.billingprovince = '';
    		this.username = '';
            this.folder = true;
    		this.expanded = false;
    	}
    	
    	public ChildAcctObj(String pid, String acctId, String acctName, String isoCode, String title, String dName, String oldpId, String oldisoCode, String billingprovince, String username){
    		this.parentAcctId = pid;
    		this.acctId = acctId;
    		this.acctName = acctName;
    		this.acctIsoCode = (isoCode == null || isoCode == '' ? DEFAULT_CURRENCY : isoCode);
    		this.title = title;
    		this.displayName = dName;
    		this.oldParentId = oldpId;
    		this.oldCurrency = oldisoCode;
    		this.billingprovince = billingprovince;
    		this.username = username;
            this.folder = true;
    		this.expanded = false;
    	}
    	
    	
        public Integer compareTo(Object compareTo) {
            ChildAcctObj compareToAcct = (ChildAcctObj) compareTo;
            if (this.acctNumb == compareToAcct.acctNumb) return 0;
            if (this.acctNumb > compareToAcct.acctNumb) return 1;
            return -1;        
        }
    	
    }
    ///*<<<InnerClass*/
    //********************************* -=END inner classes=- *************************************

}