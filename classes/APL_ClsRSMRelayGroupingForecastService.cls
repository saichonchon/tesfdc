/**
 *  Ctrl class for APL_ClsRSMGroupingForecastSerivce
 *
 @author    Lei Tang
 @created   2015-05-07
 @version   1.0
 @since     33.0 (Force.com ApiVersion)
 *
 @changelog
 * 2015-05-07 Lei Tang <lei.tang@itbconsult.com>
 * - Created
 */ 
public without sharing class APL_ClsRSMRelayGroupingForecastService extends APL_Interface.AAPLCtrlService {
	
	public override void setTotalRow(list<APL_ClsEntityType.APLColumn> list_acctColumns, Object config){ 
		
		APL_ClsEntityType.PageConfig pageconf = (APL_ClsEntityType.PageConfig)config;
		system.debug('!@#pageconf:'+pageconf);

		list<APL_ClsEntityType.APLColumn> list_ref1 = new list<APL_ClsEntityType.APLColumn> {
            new APL_ClsEntityType.APLColumn('Total Billing', 'TotalBilling', '', '', false),
            new APL_ClsEntityType.APLColumn('Total Booking', 'TotalBooking', '', '', false),
            new APL_ClsEntityType.APLColumn('Total Backlog', 'TotalBacklog', '', '', false)
		};
		
		APL_ClsEntityType.APLColumn totalT = new APL_ClsEntityType.APLColumn(APL_ClsUtils.getHexUID(),'Total Forecast Current Cycle', 'TotalForecastCurrentCycle', ' trt_0 trt_trt col ', '', true);
		APL_ClsEntityType.APLColumn RelayProducts = new APL_ClsEntityType.APLColumn(APL_ClsUtils.getHexUID(),'Relay Products', 'NewRelayProducts', totalT.id, '', true);
		APL_ClsEntityType.APLColumn OverallRelayProducts = new APL_ClsEntityType.APLColumn('Total Overall Relay Products', 'OverallRelayProducts', totalT.id, '', false);
		
		RelayProducts.list_ChildColumn.addAll(list_ref1);
		
		//set<String> set_rsmAMTerritoryCodes = new set<String>();
		//set<String> set_rsmRelayTerritoryCodes = new set<String>();
		set<String> set_rsmDisplayName = new set<String>();
		 
		//APL_ClsUtils.setAllTerritoryCode(pageconf.managerId, set_rsmAMTerritoryCodes, set_rsmRelayTerritoryCodes, set_rsmDisplayName, 'Relay');
		
		String rsmQueryFields = ' A6_Code__c territoryCode, RecordType.DeveloperName rtName, RSM__r.Display_Name__c displayName, RSM__r.Type__c rsmType, RSM__c rsmId, RSM_Freeze__c isFrozen';
        String rsmQueryObj = ' APL_Forecast_Management__c ';
        String rsmQueryFilter = ' Where RSM__r.Manager__c = \'' + pageConf.managerId + '\' And  A6_Code__c != null and RecordTypeId != null group by A6_Code__c, RSM__r.Display_Name__c, RSM__c, RSM__r.Type__c, RecordType.DeveloperName, RSM_Freeze__c ';
		String rsmQuery = ClsAPLForecastUtil.getQueryString(new list<String>{rsmQueryFields, rsmQueryObj, rsmQueryFilter});
		set<String> set_rsmId = new set<String>();
		for(AggregateResult result : database.query(rsmQuery)) {
			String rsmType = (String) result.get('rtName');
            String displayName = (String) result.get('displayName');
            String rsmId = (String) result.get('rsmId');
            String typeName = (String) result.get('rsmType');
		
			if(rsmType == 'Relay' && (typeName == 'Relay' || typeName == 'Both')) {
				set_rsmId.add(rsmId);
			}
		}
		
		list<String> list_sql = new list<String>();
        list_sql.add(' Id, Display_Name__c, APL_RSM__r.Type__c ');
		list_sql.add(' APL_RSM__c ');
		list_sql.add(' Where APL_RSM__c IN : set_rsmId'
					+ ' And APL_RSM__r.Type__c != \'AM\' ');
		for(APL_RSM__c rsm : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
			if(rsm.Id != null) {
        		set_rsmDisplayName.add(rsm.Display_Name__c);
        	}
		}
		
		
		list<String> list_oversql = new list<String>();
        list_oversql.add(' sum(RSM_Overall_Forecast__c) fc, Fiscal_Year__c year, Fiscal_Quarter__c quarter, APL_RSM__r.Display_Name__c displayname ');
		list_oversql.add(' APL_RSM_Overall_Forecast__c ');
		list_oversql.add(' WHERE APL_RSM__r.Display_Name__c IN :set_rsmDisplayName '
				+ ' And RSM_Overall_Forecast__c > 0 '
				+ ClsAPLForecastUtil.getMonthFilter(pageconf.map_year_quartersFuture) 
				+ ' Group by Fiscal_Year__c, Fiscal_Quarter__c, APL_RSM__r.Display_Name__c ');
       	
       	map<String, APL_ClsEntityType.RSMAccountObj> map_acctId_acctFC = new map<String, APL_ClsEntityType.RSMAccountObj>();
       	system.debug('@#set_rsmDisplayName: '+set_rsmDisplayName);
       	system.debug('@#sql: '+APL_ClsUtils.getQueryString(list_oversql));
       	for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_oversql))) {
    		String accId = (String) result.get('displayname'),
    			   year = (String) result.get('year'),
				   quarter = (String) result.get('quarter'), 
				   dateKey = (year + '_' + quarter);
			//ClsAPLForecastUtil.setResultMap(result, tempAcctId, dateKey, map_acctId_map_dateKey_result);
			APL_ClsEntityType.RSMAccountObj acctFC = new APL_ClsEntityType.RSMAccountObj();
            
            if(!map_acctId_acctFC.containsKey(accId)) {
        		APL_ClsUtils.createRSMAccountObj(acctFC, pageconf.map_year_quartersFuture);
                acctFC.id = accId.replaceAll(' ','');
	            acctFC.name = accId;
	            map_acctId_acctFC.put(accId, acctFC);
			}else {
				acctFC = map_acctId_acctFC.get(accId);
			}

            acctFC.map_type_FC.get('csFC').put(dateKey, (result.get('fc') != null ? (decimal)result.get('fc') : 0));
            map_acctId_acctFC.put(accId, acctFC);
    	}
		
		list<APL_ClsEntityType.APLColumn> list_t = new list<APL_ClsEntityType.APLColumn>();
		
		list_t.add(totalT);
		list_t.add(RelayProducts);
		list_t.add(OverallRelayProducts);
		
		for(String dn : map_acctId_acctFC.keySet()) {
			APL_ClsEntityType.RSMAccountObj acctFC = map_acctId_acctFC.get(dn);
			APL_ClsEntityType.APLColumn tempcolumn = new APL_ClsEntityType.APLColumn(acctFC.id, acctFC.name, totalT.id, ' overrelaychild ', false);
			tempcolumn.json_ForecastData = Json.serialize(acctFC.map_type_FC.get('csFC'));
			list_t.add(tempcolumn);
		}

		list_acctColumns.addAll(list_t);
		system.debug('@#list_acctColumns: '+list_acctColumns);
	}
	
	public override void setGroupForecast(list<Object> list_data, Object config) { 
		
		APL_ClsEntityType.PageConfig pageconf = (APL_ClsEntityType.PageConfig)config;
		system.debug('!@#pageconf:'+pageconf);
		
		set<String> set_rsmTerritoryCodes = new set<String>();
		APL_ClsUtils.setTerritoryInfo(set_rsmTerritoryCodes, 'Relay', pageconf.managerId);
		
		list<APL_ClsEntityType.RSMParentAcctObj> list_parentAccts = new list<APL_ClsEntityType.RSMParentAcctObj>();
		if(set_rsmTerritoryCodes.size() == 0) {
			return;
		}
		
		map<String, String> map_terr_name = new map<String, String>();
		APL_ClsUtils.setTerritoryUserName(map_terr_name, 'Relay', pageconf.managerId);
		
		map<String, APL_ClsEntityType.RSMParentAcctObj> map_rsmgroup_parentAcctId_parentAcct = new map<String, APL_ClsEntityType.RSMParentAcctObj>();

    	String query = '';
        query = ' Select Id, AccountNumber, Name, Relay_Specialist_Territory_Code__c, '; 
        query += ' APL_Relay_forecast_Plan_Account__c, APL_Relay_Currency__c, APL_Relay_Display_Name__c, APL_Relay_ParentAccount__c, APL_Relay_ParentAccount__r.APL_Relay_Display_Name__c, '
        				   + ' APL_Relay_ParentAccount__r.APL_Relay_Currency__c, APL_Relay_ParentAccount__r.AccountNumber, APL_Relay_ParentAccount__r.Name, '
        				   + ' APL_RSM_Relay_Display_Name__c, APL_RSM_Parent_Account__c, APL_RSM_Parent_Account__r.APL_RSM_Relay_Display_Name__c, '
        				   + ' APL_RSM_Parent_Account__r.APL_AM_Currency__c, APL_RSM_Parent_Account__r.AccountNumber, APL_RSM_Parent_Account__r.Name ';
			   
        query += ' FROM Account ';
        query += ' WHERE Relay_Specialist_Territory_Code__c IN :set_rsmTerritoryCodes ';
        query += ' And STATDESC__c = \'Active\' ';
    	query += ' And APL_Relay_forecast_Plan_Account__c != null ';
        //get grouped accounts
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'groupAcctQuery :: '+ groupAcctQuery));
        for(Account acct : database.query(query)){	
        	String acctId = acct.Id,
        			terrcode = acct.Relay_Specialist_Territory_Code__c ,
        			pid = (acct.APL_Relay_forecast_Plan_Account__c == null ? ClsAcctGroupingUtil.OTHERAcctId : acct.APL_Relay_forecast_Plan_Account__c),
        			parentAcctNumb = ((pid == ClsAcctGroupingUtil.OTHERAcctId ) ? ClsAcctGroupingUtil.OTHER : 
		        					  (acct.APL_Relay_ParentAccount__c == null ? (acct.AccountNumber) : (acct.APL_Relay_ParentAccount__r.AccountNumber))),
        			parentAcctName = ((pid == ClsAcctGroupingUtil.OTHERAcctId ) ? ClsAcctGroupingUtil.OTHER : 
		        					  (acct.APL_Relay_ParentAccount__c == null ? ((acct.AccountNumber == null ? '' : acct.AccountNumber) + ' ' + acct.Name) 
		        					 						: ((acct.APL_Relay_ParentAccount__r.AccountNumber == null ? '' : acct.APL_Relay_ParentAccount__r.AccountNumber) + ' ' + acct.APL_Relay_ParentAccount__r.Name))),
					parentAcctDisplayName = ((pid == ClsAcctGroupingUtil.OTHERAcctId ) ? ClsAcctGroupingUtil.OTHER : 
				        					(acct.APL_Relay_ParentAccount__c == null ? acct.APL_Relay_Display_Name__c : acct.APL_Relay_ParentAccount__r.APL_Relay_Display_Name__c)),
					parentCurrencyIsoCode = ((pid == ClsAcctGroupingUtil.OTHERAcctId ) ? 'USD' : 
			        					(acct.APL_Relay_ParentAccount__c == null ? acct.APL_Relay_Currency__c : acct.APL_Relay_ParentAccount__r.APL_Relay_Currency__c)),
					
					rsmpid = (String.isEmpty(acct.APL_RSM_Relay_Display_Name__c) ? ClsAPLForecastUtil.OTHERAcctId : acct.Id),
    				rsmparentAcctDisplayName = (rsmpid == ClsAcctGroupingUtil.OTHERAcctId ? APL_ClsUtils.OTHER : acct.APL_RSM_Relay_Display_Name__c),
    				rsmparentAcctNumb = (rsmpid == ClsAcctGroupingUtil.OTHERAcctId ? APL_ClsUtils.OTHER : acct.AccountNumber),
    				rsmparentAcctName = (rsmpid == ClsAcctGroupingUtil.OTHERAcctId ? APL_ClsUtils.OTHER : (String.isEmpty(acct.AccountNumber) ? '' : acct.AccountNumber) + ' ' + acct.Name);
					        					
        	if(!map_rsmgroup_parentAcctId_parentAcct.containsKey(rsmparentAcctDisplayName)) {		
	            	
		    	APL_ClsEntityType.RSMParentAcctObj rsmparentAcct = new APL_ClsEntityType.RSMParentAcctObj(rsmpid, rsmparentAcctName, rsmparentAcctNumb, rsmparentAcctDisplayName, rsmpid, '1', rsmparentAcctDisplayName);

		    	APL_ClsEntityType.RSMParentAcctObj parentAcct = new APL_ClsEntityType.RSMParentAcctObj(pid, parentAcctName, parentAcctNumb, parentAcctDisplayName, rsmpid, '2', rsmparentAcctDisplayName, map_terr_name.get(terrcode));
			    	
		    	APL_ClsEntityType.RSMParentAcctObj rootacct = new APL_ClsEntityType.RSMParentAcctObj(acctId, acct.Name, acct.AccountNumber, '', pid,'3', rsmparentAcctDisplayName, map_terr_name.get(terrcode));
			    	 
		    	parentAcct.list_childAccts.add(rootacct);
		    	rsmparentAcct.list_childAccts.add(parentAcct);
		    	map_rsmgroup_parentAcctId_parentAcct.put(rsmparentAcctDisplayName, rsmparentAcct);

            }else {
	            	
            	APL_ClsEntityType.RSMParentAcctObj rsmparentAcct = map_rsmgroup_parentAcctId_parentAcct.get(rsmparentAcctDisplayName);
            	Boolean ischild = false;
            	if(rsmparentAcct.list_childAccts.size() > 0) {
	            	for(APL_ClsEntityType.RSMParentAcctObj parentAcct : rsmparentAcct.list_childAccts) {
	            		if(parentAcct.displayName == parentAcctDisplayName && pid == parentAcct.acctId) {
	            			APL_ClsEntityType.RSMParentAcctObj rootacct = new APL_ClsEntityType.RSMParentAcctObj(acctId, acct.Name, acct.AccountNumber, '', pid, '3', rsmparentAcctDisplayName, map_terr_name.get(terrcode));
	            			parentAcct.list_childAccts.add(rootacct);
	            			ischild = true;
	            			break;
	            		}
	            	}
		            	
	            	if(!ischild) {
            			APL_ClsEntityType.RSMParentAcctObj parentAcct = new APL_ClsEntityType.RSMParentAcctObj(pid, parentAcctName, parentAcctNumb, parentAcctDisplayName, rsmpid, '2', rsmparentAcctDisplayName, map_terr_name.get(terrcode));
            			APL_ClsEntityType.RSMParentAcctObj rootacct = new APL_ClsEntityType.RSMParentAcctObj(acctId, acct.Name, acct.AccountNumber, '', pid, '3', rsmparentAcctDisplayName, map_terr_name.get(terrcode));
            			parentAcct.list_childAccts.add(rootacct);
		    			rsmparentAcct.list_childAccts.add(parentAcct);
            		}
            	}
            	else {
            		APL_ClsEntityType.RSMParentAcctObj parentAcct = new APL_ClsEntityType.RSMParentAcctObj(pid, parentAcctName, parentAcctNumb, parentAcctDisplayName, rsmpid, '2', rsmparentAcctDisplayName, map_terr_name.get(terrcode));
        			APL_ClsEntityType.RSMParentAcctObj rootacct = new APL_ClsEntityType.RSMParentAcctObj(acctId, acct.Name, acct.AccountNumber, '', pid, '3', rsmparentAcctDisplayName, map_terr_name.get(terrcode));
        			parentAcct.list_childAccts.add(rootacct);
	    			rsmparentAcct.list_childAccts.add(parentAcct);
            	}
            }

        }
	    
        if(!map_rsmgroup_parentAcctId_parentAcct.containsKey(APL_ClsUtils.OTHER)) {	//Add Other group as last
			APL_ClsEntityType.RSMParentAcctObj rsmparentAcct = new APL_ClsEntityType.RSMParentAcctObj(APL_ClsUtils.OTHERACCTID, APL_ClsUtils.OTHER, APL_ClsUtils.OTHER, APL_ClsUtils.OTHER, APL_ClsUtils.OTHERACCTID, '1', '');
			
        	map_rsmgroup_parentAcctId_parentAcct.put(ClsAPLForecastUtil.OTHER, rsmparentAcct);
        }
	        
        list_parentAccts.addAll(map_rsmgroup_parentAcctId_parentAcct.values());
	
        list_parentAccts.sort();
        for(APL_ClsEntityType.RSMParentAcctObj pacc : list_parentAccts) {
        	
        	list_data.add(pacc);
        }
	}
	
	/**
	 *  This class is get Soldto level data.
	 *  
	 * @author Lei Tang
	 * @created 2014-10-28
	 * @version 1.0
	 * @since 30.0 (Force.com ApiVersion)  
	 * 
	 *
	 * @changelog
	 * 2014-10-28 Lei Tang <lei.tang@itbconsult.com>
	 * - Created
	 *
	*/
	public override void setLevel1Data(list<Object> list_data, Object config) {
		
		APL_ClsEntityType.PageConfig pageconf = (APL_ClsEntityType.PageConfig)config;
		
		set<String> set_rsmTerritoryCodes = new set<String>();
		APL_ClsUtils.setTerritoryInfo(set_rsmTerritoryCodes, 'Relay', pageconf.managerId);

		list<APL_ClsEntityType.RSMParentAcctObj> list_parentAccts = new list<APL_ClsEntityType.RSMParentAcctObj>();
		if(set_rsmTerritoryCodes.size() == 0) {
			return;
		}

    	list<String> list_sql = new list<String>();
    	
    	map<String, APL_ClsEntityType.RSMAccountObj> map_acctId_acctFC = new map<String, APL_ClsEntityType.RSMAccountObj>();
    	//Get account grouping
    	String tempAcctId = 'temp';
    	//get account forecast
    	list_sql.add(' Customer__r.APL_RSM_Relay_Display_Name__c groupname, Fiscal_Year__c year, sum(RSM_Forecast__c) fc, '		//, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
    					+' sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter, sum(Forecast__c) amFC ');
    	list_sql.add(' APL_Sales_Forecast__c ');
    	list_sql.add(' WHERE Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' ' 
    					+ APL_ClsUtils.getRelayCBC2CodeQuery()
    					+ ClsAPLForecastUtil.getMonthFilter(pageconf.map_year_quartersFuture) 
    					+ ' And Customer__r.STATDESC__c = \'Active\' '
    					//+ ' And Customer__r.APL_RSM_Relay_Display_Name__c != null '
    					+ ' And Customer__r.APL_Relay_forecast_Plan_Account__c != null '
    					+ ' And Customer__r.Relay_Specialist_Territory_Code__c IN :set_rsmTerritoryCodes '
    					+ ' Group by Fiscal_Year__c, Fiscal_Quarter__c, Customer__r.APL_RSM_Relay_Display_Name__c ');
    	system.debug('getRSMAcctFC :: ' + APL_ClsUtils.getQueryString(list_sql));
    	for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
    		String accId = (String) result.get('groupname'),
    			   year = (String) result.get('year'),
				   quarter = (String) result.get('quarter'), 
				   dateKey = (year + '_' + quarter);
				   
			if(String.isEmpty(accId)){
				accId = APL_ClsUtils.OTHER;
			}	   
			
			//ClsAPLForecastUtil.setResultMap(result, tempAcctId, dateKey, map_acctId_map_dateKey_result);
			APL_ClsEntityType.RSMAccountObj acctFC = new APL_ClsEntityType.RSMAccountObj();
            //decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, (String) result.get('currency'), 'USD');
            if(!map_acctId_acctFC.containsKey(accId)) {
        		APL_ClsUtils.createRSMAccountObj(acctFC, pageconf.map_year_quartersFuture);
        		
                acctFC.id = APL_ClsUtils.getHexUID();
	            acctFC.name = accId;

	            map_acctId_acctFC.put(accId, acctFC);
			}else {
				acctFC = map_acctId_acctFC.get(accId);
			}

            acctFC.map_type_FC.get('csFC').put(dateKey, (result.get('fc') != null ? (decimal)result.get('fc') : 0));
			//acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
			acctFC.map_type_FC.get('pmFC').put(dateKey, (result.get('prevFC') != null ? (decimal)result.get('prevFC') : 0));
            acctFC.json_FCData = Json.serialize(acctFC.map_type_FC);
            map_acctId_acctFC.put(accId, acctFC);

    	}
    	
    	list<APL_ClsEntityType.RSMAccountObj> list_temp = new list<APL_ClsEntityType.RSMAccountObj>();
    	list_temp.addAll(map_acctId_acctFC.values());
    	list_temp.sort();
    	for(APL_ClsEntityType.RSMAccountObj obj : list_temp) {
    		list_data.add(obj);
    	}
		
	}
	
	public class SearchLevelTotal extends APL_Interface.AAPLRemoteService {
		
		public override String getExistResult(String sData){
            APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb:'+searchOb);
            
            set<String> set_rsmAMTerritoryCodes = new set<String>();
			set<String> set_rsmRelayTerritoryCodes = new set<String>();
			set<String> set_rsmDisplayName = new set<String>();
			 
			APL_ClsUtils.setAllTerritoryCode(searchOb.managerId, set_rsmAMTerritoryCodes, set_rsmRelayTerritoryCodes, set_rsmDisplayName, 'Relay');
			
			list<String> list_relaySQL = new list<String>();
			
            list_relaySQL.add(' Fiscal_Year__c year, sum(RSM_Forecast__c) fc, Fiscal_Quarter__c quarter ');
	        list_relaySQL.add(' APL_Sales_Forecast__c ');
	        list_relaySQL.add(' WHERE Customer__r.Relay_Specialist_Territory_Code__c IN : set_rsmRelayTerritoryCodes '
	        			 + ' And Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' '
	        			 + ' And Customer__r.STATDESC__c = \'Active\' '
	        			 + ClsAPLForecastUtil.getMonthFilter(searchOb.map_year_quartersFuture)
	        			 + ' Group by Fiscal_Year__c, Fiscal_Quarter__c ');
	       	
	       	map<String, APL_ClsEntityType.RSMAccountObj> map_acctId_acctFC = new map<String, APL_ClsEntityType.RSMAccountObj>();
            String relayId = 'RelayProducts';
	       	
	       	for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_relaySQL))) {
	    		String year = (String) result.get('year'),
					   quarter = (String) result.get('quarter'), 
					   dateKey = (year + '_' + quarter);
				//ClsAPLForecastUtil.setResultMap(result, tempAcctId, dateKey, map_acctId_map_dateKey_result);
				APL_ClsEntityType.RSMAccountObj acctFC = new APL_ClsEntityType.RSMAccountObj();
	            
	            if(!map_acctId_acctFC.containsKey(relayId)) {
	        		APL_ClsUtils.createRSMAccountObj(acctFC, searchOb.map_year_quartersFuture);
	                acctFC.id = relayId;
		            acctFC.name = 'T&C Products';
		            map_acctId_acctFC.put(relayId, acctFC);
				}else {
					acctFC = map_acctId_acctFC.get(relayId);
				}
	
	            acctFC.map_type_FC.get('csFC').put(dateKey, (result.get('fc') != null ? (decimal)result.get('fc') : 0));
				//acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
				//acctFC.map_type_FC.get('pmFC').put(dateKey, (result.get('prevFC') != null ? (decimal)result.get('prevFC') : 0));
	            map_acctId_acctFC.put(relayId, acctFC);
	
	    	}
	    	list<APL_ClsEntityType.RSMAccountObj> list_accFC = new list<APL_ClsEntityType.RSMAccountObj>();
	    	list_accFC.addAll(map_acctId_acctFC.values());
            return Json.serialize(list_accFC);
        }
		
		
		/**
         *  This function is used get all reference data list.
         *  
         * @author Juillet Yuan
         * @created 2014-10-29
         * @version 1.0
         * @since 31.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Juillet Yuan <Juillet.yuan@itbconsult.com>
         * - Created
         *
         */
        public override String getRefData(String sData) { 
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData,APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                
                set<String> set_rsmAMTerritoryCodes = new set<String>();
				set<String> set_rsmRelayTerritoryCodes = new set<String>();
				set<String> set_rsmDisplayName = new set<String>();
				
				APL_ClsUtils.setAllTerritoryCode(searchOb.managerId, set_rsmAMTerritoryCodes, set_rsmRelayTerritoryCodes, set_rsmDisplayName, 'Relay');
                
                set<String> set_acctIds = new set<String>();
				ClsAPLForecastUtil.setRSMAccountIds(false, set_rsmRelayTerritoryCodes, set_acctIds);
            	
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_currentdate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                Date currentdate = APL_ClsUtils.getCurrentFiscalDate();
                
                for(String datekey : searchOb.set_fiscalMonth) {
		            String year = datekey.substring(0, datekey.indexOf('_'));
		            String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
		            Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);
		            if(refdate < currentdate) {
						list_beforedate.add(refdate);
					}else if(refdate >= currentdate) {
						list_currentdate.add(refdate);
					}
		        }

                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();

                if(list_beforedate.size() > 0) {
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_beforedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Quantity__c) billQty, sum(Book_Quantity__c) bookQty, Fiscal_Date__c refdate ');
    				list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
    				
    				list_sql.add(' WHERE Customer__c IN : set_soldtoIds '
    						//+ ' And Customer__r.APL_Relay_forecast_Plan_Account__c != null '
							+ ClsAPLForecastUtil.getRelayPartQuery()
		    				+ ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
		    				+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
		    				//update by nelson zheng 2015-10-21 for case 00900375
                        	//+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c = \'RPA\' '
                        	+ ' And Profit_Center__c = \'APL\' '
		    				+ ' Group by Fiscal_Date__c ' );

                    System.debug('------APL_ClsRSMRelayGroupingForecastService.cls (18 matches) 1-----');
                    APL_ClsUtils.setRegionMapRefData('relaytotal', years, months, set_acctIds, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
	                //current
	                set<String> years = new set<String>();
	                set<Integer> months = new set<Integer>();
	                    
	                APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
	
	                list<String> list_sql = new list<String>();
	                    
	                list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Qty__c) billQty, sum(Book_Qty__c) bookQty, Fiscal_Date__c refdate');
	                list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
	                list_sql.add(' WHERE Customer__c IN : set_soldtoIds '
	                    //+ ' And Customer__r.APL_Relay_forecast_Plan_Account__c != null '
	                    + ClsAPLForecastUtil.getRelayPartQuery()  
	                    + ' And Fiscal_Year__c IN : years '
	                   	+ ' And Fiscal_Month__c IN : months '
	                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
	                    //update by nelson zheng 2015-10-21 for case 00900375
                        //+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        //+ ' And Profit_Center__c = \'RPA\'  '
                        + ' And Profit_Center__c = \'APL\'  '
	                    + ' Group by Fiscal_Date__c  ' );
	
	                System.debug('------APL_ClsRSMRelayGroupingForecastService.cls (18 matches) 2-----');
                    APL_ClsUtils.setRegionMapRefData('relaytotal', years, months, set_acctIds, list_sql, map_acctId_map_dateKey_result_before);
	            }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = 'relaytotal';
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
        }
		
		/**
         *  This function is used get backlog reference data list.
         *  
         * @author Lei Tang
         * @created 2015-03-10
         * @version 1.0
         * @since 30.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Lei Tang <lei.tang@itbconsult.com>
         * - Created
         *
         */
        public override String getBacklogRefData(String sData) {
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                
                set<String> set_rsmAMTerritoryCodes = new set<String>();
				set<String> set_rsmRelayTerritoryCodes = new set<String>();
				set<String> set_rsmDisplayName = new set<String>();
				
				APL_ClsUtils.setAllTerritoryCode(searchOb.managerId, set_rsmAMTerritoryCodes, set_rsmRelayTerritoryCodes, set_rsmDisplayName, 'Relay');
                
                set<String> set_acctIds = new set<String>();
				ClsAPLForecastUtil.setRSMAccountIds(false, set_rsmRelayTerritoryCodes, set_acctIds);
                
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                for(String datekey : searchOb.set_fiscalMonth) {
		            String year = datekey.substring(0, datekey.indexOf('_'));
		            String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
		            Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);
	
					list_futruedate.add(refdate);
		        }

                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();

                if(list_futruedate.size() > 0) {
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_futruedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount, sum(Backlog_Qty__c) qty, Customer_Request_Date_Fiscal_Date__c refdate ');
    				list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
					list_sql.add(' WHERE Customer__c IN : set_soldtoIds '
	                    //+ ' And Customer__r.APL_Relay_forecast_Plan_Account__c != null '
	                    + ClsAPLForecastUtil.getRelayPartQuery()  
	                    + ' And Customer_Request_Date_Fiscal_Year__c IN : years '
	                   	+ ' And Customer_Request_Date_Fiscal_Month__c IN : months '
	                    + ' And Backlog_Amount_USD__c != 0 '
	                    //update by nelson zheng 2015-10-21 for case 00900375
                        //+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        //+ ' And Profit_Center__c = \'RPA\' '
                        + ' And Profit_Center__c = \'APL\' '
	                    + ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
	                System.debug('------APL_ClsRSMRelayGroupingForecastService.cls (18 matches) 3-----');
                    APL_ClsUtils.setRegionMapRefData('relaytotal', years, months, set_acctIds, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = 'relaytotal';
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
            
        }

	}
	
	public class SearchLevel1 extends APL_Interface.AAPLRemoteService {
	
		/**
         *  This function is used get all reference data list.
         *  
         * @author Juillet Yuan
         * @created 2014-10-29
         * @version 1.0
         * @since 31.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Juillet Yuan <Juillet.yuan@itbconsult.com>
         * - Created
         *
         */
        public override String getRefData(String sData) { 
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData,APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_currentdate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                Date currentdate = APL_ClsUtils.getCurrentFiscalDate();
                for(String datekey : searchOb.set_fiscalMonth) {
		            String year = datekey.substring(0, datekey.indexOf('_'));
		            String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
		            Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);

		            if(refdate < currentdate) {
						list_beforedate.add(refdate);
					}else if(refdate >= currentdate) {
						list_currentdate.add(refdate);
					}
		        }
				
				set<String> set_rsmAMTerritoryCodes = new set<String>();
				set<String> set_rsmRelayTerritoryCodes = new set<String>();
				set<String> set_rsmDisplayName = new set<String>();
				
				APL_ClsUtils.setAllTerritoryCode(searchOb.managerId, set_rsmAMTerritoryCodes, set_rsmRelayTerritoryCodes, set_rsmDisplayName, 'Relay');
                
                set<String> set_acctIds = new set<String>();
				ClsAPLForecastUtil.setRSMAccountIds(false, set_rsmRelayTerritoryCodes, set_acctIds);
				
				
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();

                if(list_beforedate.size() > 0) {
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_beforedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Quantity__c) billQty, sum(Book_Quantity__c) bookQty, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.APL_RSM_Relay_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
                    		+ ' And Customer__r.APL_Relay_forecast_Plan_Account__c != null '
	                    	+ ' And Customer__c IN : set_soldtoIds '
	                    	+ ' And Customer__r.STATDESC__c = \'Active\' '
	                    	+ ClsAPLForecastUtil.getRelayPartQuery()
	                    	+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
				    		//update by nelson zheng 2015-10-21 for case 00900375
                        	//+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c = \'RPA\'  '
                        	+ ' And Profit_Center__c = \'APL\'  '
	                        + ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
	                        + ' Group by Fiscal_Date__c ');
                    System.debug('------APL_ClsRSMRelayGroupingForecastService.cls (18 matches) 4-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.rsmgrouping, years, months, set_acctIds, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
	                //current
	                set<String> years = new set<String>();
	                set<Integer> months = new set<Integer>();
	                    
	                APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
	
	                list<String> list_sql = new list<String>();
	                    
	                list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Qty__c) billQty, sum(Book_Qty__c) bookQty, Fiscal_Date__c refdate');
	                list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
	               list_sql.add(' WHERE Customer__r.APL_RSM_Relay_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
						+ ' And Customer__r.APL_Relay_forecast_Plan_Account__c != null '
						+ ' And Customer__c IN : set_soldtoIds '
						+ ' And Customer__r.STATDESC__c = \'Active\' '
	    				+ ClsAPLForecastUtil.getRelayPartQuery()
	    				+ ' And Fiscal_Year__c IN : years '
	                    + ' And Fiscal_Month__c  IN : months '
						+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
						//update by nelson zheng 2015-10-21 for case 00900375
                        //+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        //+ ' And Profit_Center__c = \'RPA\'  '
                        + ' And Profit_Center__c = \'APL\'  '
	    				+ ' Group by Fiscal_Date__c  ' );
	
	                System.debug('------APL_ClsRSMRelayGroupingForecastService.cls (18 matches) 5-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.rsmgrouping, years, months, set_acctIds, list_sql, map_acctId_map_dateKey_result_before);
	            }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = searchOb.rsmgrouping;
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
        }
		
		/**
         *  This function is used get backlog reference data list.
         *  
         * @author Lei Tang
         * @created 2015-03-10
         * @version 1.0
         * @since 30.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Lei Tang <lei.tang@itbconsult.com>
         * - Created
         *
         */
        public override String getBacklogRefData(String sData) {
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                for(String datekey : searchOb.set_fiscalMonth) {
		            String year = datekey.substring(0, datekey.indexOf('_'));
		            String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
		            Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);
	
					list_futruedate.add(refdate);
		        }
				
				set<String> set_rsmAMTerritoryCodes = new set<String>();
				set<String> set_rsmRelayTerritoryCodes = new set<String>();
				set<String> set_rsmDisplayName = new set<String>();
				
				APL_ClsUtils.setAllTerritoryCode(searchOb.managerId, set_rsmAMTerritoryCodes, set_rsmRelayTerritoryCodes, set_rsmDisplayName, 'Relay');
                
                set<String> set_acctIds = new set<String>();
				ClsAPLForecastUtil.setRSMAccountIds(false, set_rsmRelayTerritoryCodes, set_acctIds);
				
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();

                if(list_futruedate.size() > 0) {
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_futruedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount, sum(Backlog_Qty__c) qty, Customer_Request_Date_Fiscal_Date__c refdate ');
    				list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
					list_sql.add(' WHERE Customer__r.APL_RSM_Relay_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
						+ ' And Customer__r.APL_Relay_forecast_Plan_Account__c != null '
						+ ' And Customer__c IN : set_soldtoIds '
						+ ' And Customer__r.STATDESC__c = \'Active\' '
						+ ClsAPLForecastUtil.getRelayPartQuery()
	    				+ ' And Customer_Request_Date_Fiscal_Year__c IN : years '
	                    + ' And Customer_Request_Date_Fiscal_Month__c  IN : months '
						+ ' And Backlog_Amount_USD__c != 0 '
						//update by nelson zheng 2015-10-21 for case 00900375
                        //+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        //+ ' And Profit_Center__c = \'RPA\'  '
                        + ' And Profit_Center__c = \'APL\'  '
	    				+ ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
	                System.debug('------APL_ClsRSMRelayGroupingForecastService.cls (18 matches) 51-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.rsmgrouping, years, months, set_acctIds, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = searchOb.rsmgrouping;
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
            
        }
		
		
	}
	
	public class SearchLevel2 extends APL_Interface.AAPLRemoteService {
		
		public override String getExistResult(String sData){
            APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb:'+searchOb);
            
            list<String> list_sql = new list<String>();
            list_sql.add(' Fiscal_Year__c year, sum(RSM_Forecast__c) fc, Customer__r.APL_Relay_Display_Name__c groupname, Customer__r.APL_Relay_forecast_Plan_Account__c accId, '      //, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
                        +' sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter, sum(Forecast__c) amFC ');
	        list_sql.add(' APL_Sales_Forecast__c ');
	        list_sql.add(' WHERE Customer__r.APL_RSM_Relay_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
	                    + ' And Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' '
	                    + APL_ClsUtils.getRelayCBC2CodeQuery()
	                    + ' And Customer__r.STATDESC__c = \'Active\' '
	                    + ' And Customer__r.APL_Relay_forecast_Plan_Account__c != null '
	                    + ClsAPLForecastUtil.getMonthFilter(searchOb.map_year_quartersFuture) 
	                    + ' Group by Fiscal_Year__c, Fiscal_Quarter__c, Customer__r.APL_Relay_Display_Name__c, Customer__r.APL_Relay_forecast_Plan_Account__c ');

            map<String, APL_ClsEntityType.RSMAccountObj> map_acctId_acctFC = new map<String, APL_ClsEntityType.RSMAccountObj>();
        	
            for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
	    		String accId = (String) result.get('accId'),
	    			   year = (String) result.get('year'),
					   quarter = (String) result.get('quarter'), 
					   dateKey = (year + '_' + quarter);
				//ClsAPLForecastUtil.setResultMap(result, tempAcctId, dateKey, map_acctId_map_dateKey_result);
				APL_ClsEntityType.RSMAccountObj acctFC = new APL_ClsEntityType.RSMAccountObj();
	            //decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, (String) result.get('currency'), 'USD');
	            if(!map_acctId_acctFC.containsKey(accId)) {
	        		APL_ClsUtils.createRSMAccountObj(acctFC, searchOb.map_year_quartersFuture);
	        		
	                acctFC.id = accId;
		            acctFC.name = (String) result.get('groupname');
	
		            map_acctId_acctFC.put(accId, acctFC);
				}else {
					acctFC = map_acctId_acctFC.get(accId);
				}
	
	            acctFC.map_type_FC.get('csFC').put(dateKey, (result.get('fc') != null ? (decimal)result.get('fc') : 0));
				//acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
				acctFC.map_type_FC.get('pmFC').put(dateKey, (result.get('prevFC') != null ? (decimal)result.get('prevFC') : 0));
	            map_acctId_acctFC.put(accId, acctFC);
	
	    	}

            list<APL_ClsEntityType.RSMAccountObj> list_accFC = new list<APL_ClsEntityType.RSMAccountObj>();
            list_accFC.addAll(map_acctId_acctFC.values());
            list_accFC.sort();
            return Json.serialize(list_accFC);

        }
		
		/**
         *  This function is used get all reference data list.
         *  
         * @author Juillet Yuan
         * @created 2014-10-29
         * @version 1.0
         * @since 31.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Juillet Yuan <Juillet.yuan@itbconsult.com>
         * - Created
         *
         */
        public override String getRefData(String sData) { 
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData,APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_currentdate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                Date currentdate = APL_ClsUtils.getCurrentFiscalDate();
                for(String datekey : searchOb.set_fiscalMonth) {
		            String year = datekey.substring(0, datekey.indexOf('_'));
		            String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
		            Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);

		            if(refdate < currentdate) {
						list_beforedate.add(refdate);
					}else if(refdate >= currentdate) {
						list_currentdate.add(refdate);
					}
		        }

                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();

                if(list_beforedate.size() > 0) {
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_beforedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Quantity__c) billQty, sum(Book_Quantity__c) bookQty, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.APL_RSM_Relay_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
                    		+ ' And Customer__r.APL_Relay_forecast_Plan_Account__c = \'' +  searchOb.grouping + '\' '
	                    	+ ' And Customer__r.STATDESC__c = \'Active\' '
	                    	+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
				    		//update by nelson zheng 2015-10-21 for case 00900375
				    		//change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
                        	+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'41553\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c = \'RPA\'  '
	                        + ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
	                        + ' Group by Fiscal_Date__c ');
                    System.debug('------APL_ClsRSMRelayGroupingForecastService.cls (18 matches) 6-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.grouping, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
	                //current
	                set<String> years = new set<String>();
	                set<Integer> months = new set<Integer>();
	                    
	                APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
	
	                list<String> list_sql = new list<String>();
	                    
	                list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Qty__c) billQty, sum(Book_Qty__c) bookQty, Fiscal_Date__c refdate');
	                list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
	            	list_sql.add(' WHERE Customer__r.APL_RSM_Relay_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
                    		+ ' And Customer__r.APL_Relay_forecast_Plan_Account__c = ' + (searchOb.grouping == ClsAPLForecastUtil.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ')	
						+ ' And Customer__r.STATDESC__c = \'Active\' '
                    	+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
                        + ' And Fiscal_Year__c IN : years '
                        + ' And Fiscal_Month__c IN : months '
						//update by nelson zheng 2015-10-21 for case 00900375
						//change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
                        +' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'41553\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        //+ ' And Profit_Center__c = \'RPA\'  '
	    				+ ' Group by Fiscal_Date__c  ' );
	
	                System.debug('------APL_ClsRSMRelayGroupingForecastService.cls (18 matches) 7-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.grouping, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
	            }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = searchOb.grouping;
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
        }
		
		/**
         *  This function is used get backlog reference data list.
         *  
         * @author Lei Tang
         * @created 2015-03-10
         * @version 1.0
         * @since 30.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Lei Tang <lei.tang@itbconsult.com>
         * - Created
         *
         */
        public override String getBacklogRefData(String sData) {
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                for(String datekey : searchOb.set_fiscalMonth) {
		            String year = datekey.substring(0, datekey.indexOf('_'));
		            String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
		            Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);
	
					list_futruedate.add(refdate);
		        }

                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();

                if(list_futruedate.size() > 0) {
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_futruedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount, sum(Backlog_Qty__c) qty, Customer_Request_Date_Fiscal_Date__c refdate ');
    				list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
					list_sql.add(' WHERE Customer__r.APL_RSM_Relay_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
                    		+ ' And Customer__r.APL_Relay_forecast_Plan_Account__c = ' + (searchOb.grouping == ClsAPLForecastUtil.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ')	
						+ ' And Customer__r.STATDESC__c = \'Active\' '
	    				+ ' And Customer_Request_Date_Fiscal_Year__c IN : years '
	                    + ' And Customer_Request_Date_Fiscal_Month__c  IN : months '
						+ ' And Backlog_Amount_USD__c != 0 '
						//update by nelson zheng 2015-10-21 for case 00900375
						//change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
                        +' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'41553\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        //+ ' And Profit_Center__c = \'RPA\'  '
	    				+ ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
	                System.debug('------APL_ClsRSMRelayGroupingForecastService.cls (18 matches) 8-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.grouping, years, months, null, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = searchOb.grouping;
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
            
        }
	}
	
	public class SearchLevel3 extends APL_Interface.AAPLRemoteService {
	
		public override String getExistResult(String sData){
            APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb:'+searchOb);
            
            list<APL_ClsEntityType.RSMAccountObj> list_accFC = new list<APL_ClsEntityType.RSMAccountObj>();
            
            list<String> list_sortedRelayCBC = ClsAPLForecastUtil.getSortedRelayCBCKey();
	        list<String> list_sql = new list<String>();
			//system.debug('@#list_sortedRelayCBC:'+list_sortedRelayCBC);
	        //get query string for gpl forecast
	    	list_sql.add(' Fiscal_Year__c year, sum(RSM_Forecast__c) fc, ' 		//, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
						+ ' sum(Forecast__c) amFC, sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter, '
						+ ' Relay_CBC2_Code__c cbc2Name');
						
			list_sql.add(' APL_Sales_Forecast__c ');

			list_sql.add(' WHERE Customer__r.APL_Relay_forecast_Plan_Account__c = \'' +  searchOb.grouping + '\' '
						+ ' And Customer__r.APL_RSM_Relay_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
						+ ' And Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' '
						+ ClsAPLForecastUtil.getMonthFilter(searchOb.map_year_quartersFuture)
						+ APL_ClsUtils.getRelayCBC2CodeQuery() 
						+ ' And Customer__r.STATDESC__c = \'Active\' '
						+ ' Group by Fiscal_Year__c, Fiscal_Quarter__c, Relay_CBC2_Code__c ');
			
			map<String, APL_ClsEntityType.RSMAccountObj> map_acctId_acctFC = new map<String, APL_ClsEntityType.RSMAccountObj>();
			
			for(String cbcKey : list_sortedRelayCBC) {
        		APL_ClsEntityType.RSMAccountObj acctFC = new APL_ClsEntityType.RSMAccountObj();
        		APL_ClsUtils.createRSMAccountObj(acctFC, searchOb.map_year_quartersFuture);
        		acctFC.name = ' [ '+cbcKey+' ] - ' + ClsAPLForecastUtil.map_RELAY_CBCCode_CBCDESC.get(cbcKey);
            	acctFC.accnumber = cbcKey;
            	acctFC.id = cbcKey;
                map_acctId_acctFC.put(cbcKey, acctFC);
                
        	}
        	
        	
        	for(AggregateResult  result : Database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
	            String year = (String) result.get('year');
	            String cbcKeyName = (String) result.get('cbc2Name');
	            //String cbc3Name = (String) result.get('cbc3Name');
	            //String cbcKeyName = ClsAPLForecastUtil.getRelayCBCKey(cbc2Name, cbc3Name);
	            String quarter = (String) result.get('quarter');
	            String dateKey = year + '_' + quarter;
	            
	            APL_ClsEntityType.RSMAccountObj acctFC = new APL_ClsEntityType.RSMAccountObj();
	            //decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, (String) result.get('currency'), 'USD');
	            if(!map_acctId_acctFC.containsKey(cbcKeyName)) {
	        		APL_ClsUtils.createRSMAccountObj(acctFC, searchOb.map_year_quartersFuture);
	                acctFC.id = cbcKeyName;
		            acctFC.name = ' [ '+cbcKeyName+' ] - ' + ClsAPLForecastUtil.map_RELAY_CBCCode_CBCDESC.get(cbcKeyName);
					acctFC.accnumber = cbcKeyName;
		            map_acctId_acctFC.put(cbcKeyName, acctFC);
				}else {
					acctFC = map_acctId_acctFC.get(cbcKeyName);
				}
	
	            acctFC.map_type_FC.get('csFC').put(dateKey, (result.get('fc') != null ? (decimal)result.get('fc') : 0));
				//acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
				acctFC.map_type_FC.get('pmFC').put(dateKey, (result.get('prevFC') != null ? (decimal)result.get('prevFC') : 0));
	            map_acctId_acctFC.put(cbcKeyName, acctFC);
	        }
        	system.debug('@#map_acctId_acctFC:'+map_acctId_acctFC);
			list_accFC.addAll(map_acctId_acctFC.values());
			
			return Json.serialize(list_accFC);
        }
		
		
		/**
         *  This function is used get all reference data list.
         *  
         * @author Juillet Yuan
         * @created 2014-10-29
         * @version 1.0
         * @since 31.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Juillet Yuan <Juillet.yuan@itbconsult.com>
         * - Created
         *
         */
        public override String getRefData(String sData) { 
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData,APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_currentdate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                Date currentdate = APL_ClsUtils.getCurrentFiscalDate();
                for(String datekey : searchOb.set_fiscalMonth) {
		            String year = datekey.substring(0, datekey.indexOf('_'));
		            String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
		            Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);

		            if(refdate < currentdate) {
						list_beforedate.add(refdate);
					}else if(refdate >= currentdate) {
						list_currentdate.add(refdate);
					}
		        }

                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();

                if(list_beforedate.size() > 0) {
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_beforedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Quantity__c) billQty, sum(Book_Quantity__c) bookQty, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.APL_RSM_Relay_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
                    		+ ' And Customer__r.APL_Relay_forecast_Plan_Account__c = \'' +  searchOb.grouping + '\' '	
	                    	+ ' And Customer__r.STATDESC__c = \'Active\' '
	                    	+ ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
	                    	+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
				    		//update by nelson zheng 2015-10-21 for case 00900375
                        	//+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c = \'RPA\'  '
                        	+ ' And Profit_Center__c = \'APL\'  '
	                        + ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
	                        + ' Group by Fiscal_Date__c ');
                    System.debug('------APL_ClsRSMRelayGroupingForecastService.cls (18 matches) 9-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.cbc2Code, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
	                //current
	                set<String> years = new set<String>();
	                set<Integer> months = new set<Integer>();
	                    
	                APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
	
	                list<String> list_sql = new list<String>();
	                    
	                list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Qty__c) billQty, sum(Book_Qty__c) bookQty, Fiscal_Date__c refdate');
	                list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
	            	list_sql.add(' WHERE Customer__r.APL_RSM_Relay_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
                    		+ ' And Customer__r.APL_Relay_forecast_Plan_Account__c = \'' +  searchOb.grouping + '\' '
							+ ' And Customer__r.STATDESC__c = \'Active\' '
							+ ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
		    				+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
				    		//update by nelson zheng 2015-10-21 for case 00900375
                        	//+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c = \'RPA\'  '
                        	+ ' And Profit_Center__c = \'APL\'  '
	                        + ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
		    				+ ' Group by Fiscal_Date__c  ' );
	
	                System.debug('------APL_ClsRSMRelayGroupingForecastService.cls (18 matches) 10-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.cbc2Code, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
	            }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = searchOb.cbc2Code;
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
        }
		
		/**
         *  This function is used get backlog reference data list.
         *  
         * @author Lei Tang
         * @created 2015-03-10
         * @version 1.0
         * @since 30.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Lei Tang <lei.tang@itbconsult.com>
         * - Created
         *
         */
        public override String getBacklogRefData(String sData) {
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                for(String datekey : searchOb.set_fiscalMonth) {
		            String year = datekey.substring(0, datekey.indexOf('_'));
		            String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
		            Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);
	
					list_futruedate.add(refdate);
		        }

                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();

                if(list_futruedate.size() > 0) {
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_futruedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount, sum(Backlog_Qty__c) qty, Customer_Request_Date_Fiscal_Date__c refdate ');
    				list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
					list_sql.add(' WHERE Customer__r.APL_RSM_Relay_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
                    		+ ' And Customer__r.APL_Relay_forecast_Plan_Account__c = \'' +  searchOb.grouping + '\' '
						+ ' And Customer__r.STATDESC__c = \'Active\' '
						+ ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
	    				+ ' And Customer_Request_Date_Fiscal_Year__c IN : years '
	                    + ' And Customer_Request_Date_Fiscal_Month__c  IN : months '
						+ ' And Backlog_Amount_USD__c != 0 '
						//update by nelson zheng 2015-10-21 for case 00900375
                        //+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        //+ ' And Profit_Center__c = \'RPA\'  '
                        + ' And Profit_Center__c = \'APL\'  '
	    				+ ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
	                System.debug('------APL_ClsRSMRelayGroupingForecastService.cls (18 matches) 11-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.cbc2Code, years, months, null, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = searchOb.cbc2Code;
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
            
        }
		
	}
	
	public class SearchLevel4 extends APL_Interface.AAPLRemoteService {
		
		public override String getExistResult(String sData){
			APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb:'+searchOb);
            list<APL_ClsEntityType.RSMAccountObj> list_accFC = new list<APL_ClsEntityType.RSMAccountObj>();
            
            list<String> list_sql = new list<String>();
        	
        	list_sql.add(' Fiscal_Year__c year, Fiscal_Quarter__c quarter, PRODUCT_CDE__c procode, PROD_NAME__c proname, ' //Part__r.Product_Hierarchy__c gplId , 
	        		+ ' sum(RSM_Forecast__c) fc, sum(Current_month_1_forecast__c) prevFC, sum(Forecast__c) amFC, '
	        		+ ' sum(RSM_Quantity__c) quantity, sum(Current_month_1_RSM_quantity__c) preQuantity ');
	        list_sql.add(' APL_Sales_Forecast__c ');
	        list_sql.add(' WHERE Customer__r.APL_RSM_Relay_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
		        + ' And Customer__r.STATDESC__c = \'Active\' '
		        + ' And Relay_CBC2_Code__c = \'' + searchOb.cbc2Code + '\' '
		        + ClsAPLForecastUtil.getMonthFilter(searchOb.map_year_quartersFuture)
		        + ' And Customer__r.APL_Relay_forecast_Plan_Account__c = \'' + searchOb.grouping + '\' '
		        + ' And Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' '  
		        + ' Group by Part__c, Fiscal_Year__c, Fiscal_Quarter__c, PRODUCT_CDE__c, PROD_NAME__c'); //, Part__r.Product_Hierarchy__c 
			list<String> set_tempqy = new list<String>();
			
            map<String, APL_ClsEntityType.RSMAccountObj> map_acctId_acctFC = new map<String, APL_ClsEntityType.RSMAccountObj>();
            String pricePlaces = APL_ClsUtils.getPricePlaces();
            for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
	    		String accId = (String) result.get('procode'),
	    			   year = (String) result.get('year'),
					   quarter = (String) result.get('quarter'), 
					   dateKey = (year + '_' + quarter);
				if(set_tempqy.size() == 0) {
					set_tempqy.add(year);
					set_tempqy.add(quarter);
				}
				APL_ClsEntityType.RSMAccountObj acctFC = new APL_ClsEntityType.RSMAccountObj();
	            //decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, (String) result.get('currency'), 'USD');
	            if(!map_acctId_acctFC.containsKey(accId)) {
	        		APL_ClsUtils.createRSMRelayAccountObj(acctFC, searchOb.map_year_quartersFuture);
	        		acctFC.id = APL_ClsUtils.getHexUID();
		            acctFC.name = '['+accId+']-'+(String) result.get('proname');
					acctFC.accnumber = accId;
					acctFC.isHighLighted = false;
					//acctFC.price = (result.get('price') == null ? 0 : (decimal)result.get('price'));
            		//acctFC.price = acctFC.price.setScale((pricePlaces == '' ? 3 : Integer.valueOf(pricePlaces)));
		            map_acctId_acctFC.put(accId, acctFC);
				}else {
					acctFC = map_acctId_acctFC.get(accId);
				}
	
	            acctFC.map_type_FC.get('csFC').put(dateKey, (result.get('fc') != null ? (decimal)result.get('fc') : 0));
				acctFC.map_type_FC.get('quantity').put(dateKey, (result.get('quantity') != null ? (decimal)result.get('quantity') : 0));
				
				acctFC.map_type_FC.get('pmFC').put(dateKey, (result.get('prevFC') != null ? (decimal)result.get('prevFC') : 0));
	            map_acctId_acctFC.put(accId, acctFC);
					   
            }
            
            if(set_tempqy.size() > 1){

	            list_sql.clear();
	            list_sql.add(' PRODUCT_CDE__c , RSM_Price__c');
		        list_sql.add(' APL_Sales_Forecast__c ');
			    list_sql.add(' WHERE Customer__r.APL_RSM_Relay_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
			        + ' And Customer__r.STATDESC__c = \'Active\' '
			        + ' And Relay_CBC2_Code__c = \'' + searchOb.cbc2Code + '\' '
			        + ' And Customer__r.APL_Relay_forecast_Plan_Account__c = \'' + searchOb.grouping + '\' '
			        + ' And Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' '  
			        + ' And Fiscal_Year__c = \''+set_tempqy.get(0)+'\' '
			        + ' And Fiscal_Quarter__c = \''+set_tempqy.get(1)+'\' ');
	
				for(APL_Sales_Forecast__c result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
					String accId = result.PRODUCT_CDE__c;
					//decimal currencyRatePrice = ClsAPLForecastUtil.transformIsoCode(1, result.CurrencyIsoCode, searchOb.currencyIso);
					if(map_acctId_acctFC.containsKey(accId)) {
						decimal price = (result.RSM_Price__c == null ? 0 : result.RSM_Price__c);
						map_acctId_acctFC.get(accId).price = price.setScale((pricePlaces == '' ? 3 : Integer.valueOf(pricePlaces)));
					}
				}
			}
            
            
            APL_ClsUtils.setHighlight(searchOb, APL_ClsUtils.RELAYFCTYPE, APL_ClsUtils.RSMFCTYPE, map_acctId_acctFC);
            
            list_accFC.addAll(map_acctId_acctFC.values());
            
            return Json.serialize(list_accFC);
		}
		
		/**
         *  This function is used get all reference data list.
         *  
         * @author Juillet Yuan
         * @created 2014-10-29
         * @version 1.0
         * @since 31.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Juillet Yuan <Juillet.yuan@itbconsult.com>
         * - Created
         *
         */
        public override String getRefData(String sData) { 
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData,APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_currentdate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                Date currentdate = APL_ClsUtils.getCurrentFiscalDate();
                for(String datekey : searchOb.set_fiscalMonth) {
		            String year = datekey.substring(0, datekey.indexOf('_'));
		            String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
		            Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);

		            if(refdate < currentdate) {
						list_beforedate.add(refdate);
					}else if(refdate >= currentdate) {
						list_currentdate.add(refdate);
					}
		        }

                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();

                if(list_beforedate.size() > 0) {
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_beforedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Quantity__c) billQty, sum(Book_Quantity__c) bookQty, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.APL_RSM_Relay_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
                    		+ ' And Customer__r.APL_Relay_forecast_Plan_Account__c = \'' +  searchOb.grouping + '\' '
	                    	+ ' And Customer__r.STATDESC__c = \'Active\' '
	                    	+ ' And Part__r.PRODUCT_CDE__c = \'' + searchOb.accnumber + '\' '
	                    	+ ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
	                    	//+ (searchOb.cbc2Code == 'Relay' ? ClsAPLForecastUtil.getRelayCBCFilter(searchOb.gplId) : ' And Part__r.Product_Hierarchy__c = \'' + searchOb.gplId + '\'')
	                    	+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
				    		//update by nelson zheng 2015-10-21 for case 00900375
                        	//+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c = \'RPA\'  '
                        	+ ' And Profit_Center__c = \'APL\'  '
	                        + ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
	                        + ' Group by Fiscal_Date__c ');
                    System.debug('------APL_ClsRSMRelayGroupingForecastService.cls (18 matches) 12-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.gplId, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
	                //current
	                set<String> years = new set<String>();
	                set<Integer> months = new set<Integer>();
	                    
	                APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
	
	                list<String> list_sql = new list<String>();
	                    
	                list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Qty__c) billQty, sum(Book_Qty__c) bookQty, Fiscal_Date__c refdate');
	                list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
	            	list_sql.add(' WHERE Customer__r.APL_RSM_Relay_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
                    		+ ' And Customer__r.APL_Relay_forecast_Plan_Account__c = \'' +  searchOb.grouping + '\' '
							+ ' And Customer__r.STATDESC__c = \'Active\' '
							+ ' And Part__r.PRODUCT_CDE__c = \'' + searchOb.accnumber + '\' '
		                    + ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
							//+ (searchOb.cbc2Code == 'Relay' ? ClsAPLForecastUtil.getRelayCBCFilter(searchOb.gplId) : ' And Part__r.Product_Hierarchy__c = \'' + searchOb.gplId + '\'')
		    				+ ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
							+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
							//update by nelson zheng 2015-10-21 for case 00900375
                        	//+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c = \'RPA\'  '
                        	+ ' And Profit_Center__c = \'APL\'  '
		    				+ ' Group by Fiscal_Date__c  ' );
	
	                System.debug('------APL_ClsRSMRelayGroupingForecastService.cls (18 matches) 13-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.gplId, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
	            }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = searchOb.gplId;
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
        }
		
		/**
         *  This function is used get backlog reference data list.
         *  
         * @author Lei Tang
         * @created 2015-03-10
         * @version 1.0
         * @since 30.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Lei Tang <lei.tang@itbconsult.com>
         * - Created
         *
         */
        public override String getBacklogRefData(String sData) {
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                for(String datekey : searchOb.set_fiscalMonth) {
		            String year = datekey.substring(0, datekey.indexOf('_'));
		            String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
		            Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);
	
					list_futruedate.add(refdate);
		        }

                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();

                if(list_futruedate.size() > 0) {
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_futruedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount, sum(Backlog_Qty__c) qty, Customer_Request_Date_Fiscal_Date__c refdate ');
    				list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
					list_sql.add(' WHERE Customer__r.APL_RSM_Relay_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
                    		+ ' And Customer__r.APL_Relay_forecast_Plan_Account__c = \'' +  searchOb.grouping + '\' '
						+ ' And Customer__r.STATDESC__c = \'Active\' '
						+ ' And Part__r.PRODUCT_CDE__c = \'' + searchOb.accnumber + '\' '
	                    + ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
						//+ (searchOb.cbc2Code == 'Relay' ? ClsAPLForecastUtil.getRelayCBCFilter(searchOb.gplId) : ' And Part__r.Product_Hierarchy__c = \'' + searchOb.gplId + '\'')
	    				+ ' And Customer_Request_Date_Fiscal_Year__c IN : years '
	                    + ' And Customer_Request_Date_Fiscal_Month__c  IN : months '
						+ ' And Backlog_Amount_USD__c != 0 '
						//update by nelson zheng 2015-10-21 for case 00900375
                        //+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        //+ ' And Profit_Center__c = \'RPA\'  '
                        + ' And Profit_Center__c = \'APL\'  '
	    				+ ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
	                System.debug('------APL_ClsRSMRelayGroupingForecastService.cls (18 matches) 14-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.gplId, years, months, null, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = searchOb.gplId;
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
            
        }
		
		
	}
	
	
	public class SearchLevel5 extends APL_Interface.AAPLRemoteService {
		
		public override String getExistResult(String sData){
			APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb:'+searchOb);
            list<APL_ClsEntityType.RSMAccountObj> list_accFC = new list<APL_ClsEntityType.RSMAccountObj>();
            
            list<String> list_sql = new list<String>();
        	
        	list_sql.add(' Fiscal_Year__c year, Fiscal_Quarter__c quarter, Part__c partId, Part__r.Description__c partDesc, Part__r.Name partName, ' //Part__r.Product_Hierarchy__c gplId , 
	        		+ ' sum(RSM_Forecast__c) fc, sum(Current_month_1_forecast__c) prevFC, sum(Forecast__c) amFC, '
	        		+ ' sum(RSM_Quantity__c) quantity, sum(Current_month_1_RSM_quantity__c) preQuantity, avg(RSM_Price__c) price, avg(Current_month_1_RSM_price__c) prePrice');
	        list_sql.add(' APL_Sales_Forecast__c ');
	        list_sql.add(' WHERE Customer__r.APL_RSM_Relay_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
		        + ' And Customer__r.STATDESC__c = \'Active\' '
		        + ClsAPLServiceRSMRelay.getRelayPartSearchQueryFilter(searchOb.cbc2Code, true)
		        + ' And Part__r.PRODUCT_CDE__c = \'' + searchOb.accnumber + '\' '
		        + ClsAPLForecastUtil.getMonthFilter(searchOb.map_year_quartersFuture)
		        + ' And Customer__r.APL_Relay_forecast_Plan_Account__c = \'' + searchOb.grouping + '\' '
		        + ' And Type__c = \'' + APL_ClsUtils.RELAYFCTYPE + '\' '  
		        + ' Group by Part__c, Fiscal_Year__c, Fiscal_Quarter__c, Part__r.Description__c, Part__r.Name'); //, Part__r.Product_Hierarchy__c 
			list<String> set_tempqy = new list<String>();
            map<String, APL_ClsEntityType.RSMAccountObj> map_acctId_acctFC = new map<String, APL_ClsEntityType.RSMAccountObj>();
            String pricePlaces = APL_ClsUtils.getPricePlaces();
            for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
	    		String accId = (String) result.get('partId'),
	    			   year = (String) result.get('year'),
					   quarter = (String) result.get('quarter'), 
					   dateKey = (year + '_' + quarter);
				if(set_tempqy.size() == 0) {
					set_tempqy.add(year);
					set_tempqy.add(quarter);
				} 
				APL_ClsEntityType.RSMAccountObj acctFC = new APL_ClsEntityType.RSMAccountObj();
	            //decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, (String) result.get('currency'), 'USD');
	            if(!map_acctId_acctFC.containsKey(accId)) {
	        		APL_ClsUtils.createRSMRelayAccountObj(acctFC, searchOb.map_year_quartersFuture);
	                acctFC.id = accId;
		            acctFC.name = (String) result.get('partName');
					acctFC.accnumber = (String) result.get('partDesc');
					//acctFC.price = (result.get('price') == null ? 0 : (decimal)result.get('price'));
            		//acctFC.price = acctFC.price.setScale((pricePlaces == '' ? 3 : Integer.valueOf(pricePlaces)));
		            map_acctId_acctFC.put(accId, acctFC);
				}else {
					acctFC = map_acctId_acctFC.get(accId);
				}
	
	            acctFC.map_type_FC.get('csFC').put(dateKey, (result.get('fc') != null ? (decimal)result.get('fc') : 0));
				acctFC.map_type_FC.get('quantity').put(dateKey, (result.get('quantity') != null ? (decimal)result.get('quantity') : 0));
				acctFC.map_type_FC.get('pmFC').put(dateKey, (result.get('prevFC') != null ? (decimal)result.get('prevFC') : 0));
	            map_acctId_acctFC.put(accId, acctFC);
					   
            }
            if(set_tempqy.size() > 1){

	            list_sql.clear();
	            list_sql.add(' Part__c , RSM_Price__c ');
		        list_sql.add(' APL_Sales_Forecast__c ');
			    list_sql.add(' WHERE Customer__r.APL_RSM_Relay_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
			        + ' And Customer__r.STATDESC__c = \'Active\' '
			        + ClsAPLServiceRSMRelay.getRelayPartSearchQueryFilter(searchOb.cbc2Code, true)
			        + ' And Part__r.PRODUCT_CDE__c = \'' + searchOb.accnumber + '\' '
			        + ' And Customer__r.APL_Relay_forecast_Plan_Account__c = \'' + searchOb.grouping + '\' '
			        + ' And Type__c = \'' + APL_ClsUtils.RELAYFCTYPE + '\' ' 
			        + ' And Fiscal_Year__c = \''+set_tempqy.get(0)+'\' '
			        + ' And Fiscal_Quarter__c = \''+set_tempqy.get(1)+'\' ');
	
				for(APL_Sales_Forecast__c result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
					String accId = result.Part__c;
					//decimal currencyRatePrice = ClsAPLForecastUtil.transformIsoCode(1, result.CurrencyIsoCode, searchOb.currencyIso);
					if(map_acctId_acctFC.containsKey(accId)) {
						decimal price = (result.RSM_Price__c == null ? 0 : result.RSM_Price__c);
						map_acctId_acctFC.get(accId).price = price.setScale((pricePlaces == '' ? 3 : Integer.valueOf(pricePlaces)));
					}
				}
			}
            list_accFC.addAll(map_acctId_acctFC.values());
            
            return Json.serialize(list_accFC);
		}
		
		/**
         *  This function is used get all reference data list.
         *  
         * @author Juillet Yuan
         * @created 2014-10-29
         * @version 1.0
         * @since 31.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Juillet Yuan <Juillet.yuan@itbconsult.com>
         * - Created
         *
         */
        public override String getRefData(String sData) { 
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData,APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_currentdate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                Date currentdate = APL_ClsUtils.getCurrentFiscalDate();
                for(String datekey : searchOb.set_fiscalMonth) {
		            String year = datekey.substring(0, datekey.indexOf('_'));
		            String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
		            Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);

		            if(refdate < currentdate) {
						list_beforedate.add(refdate);
					}else if(refdate >= currentdate) {
						list_currentdate.add(refdate);
					}
		        }

                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();

                if(list_beforedate.size() > 0) {
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_beforedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Quantity__c) billQty, sum(Book_Quantity__c) bookQty, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.APL_RSM_Relay_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
                    		+ ' And Customer__r.APL_Relay_forecast_Plan_Account__c = \'' +  searchOb.grouping + '\' '
	                    	+ ' And Customer__r.STATDESC__c = \'Active\' '
	                    	//+ ' And Part__r.PRODUCT_CDE__c = \'' + searchOb.accnumber + '\' '
	                    	+ ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
	                    	//+ (searchOb.cbc2Code == 'Relay' ? ClsAPLForecastUtil.getRelayCBCFilter(searchOb.gplId) : ' And Part__r.Product_Hierarchy__c = \'' + searchOb.gplId + '\'')
	                    	+ ' And Part__c = \'' + searchOb.partId + '\' '
	                    	+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
				    		//update by nelson zheng 2015-10-21 for case 00900375
                       	 	//+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c = \'RPA\'  '
                        	+ ' And Profit_Center__c = \'APL\'  '
	                        + ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
	                        + ' Group by Fiscal_Date__c ');
                    System.debug('------APL_ClsRSMRelayGroupingForecastService.cls (18 matches) 15-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.partId, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
	                //current
	                set<String> years = new set<String>();
	                set<Integer> months = new set<Integer>();
	                    
	                APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
	
	                list<String> list_sql = new list<String>();
	                    
	                list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Qty__c) billQty, sum(Book_Qty__c) bookQty, Fiscal_Date__c refdate');
	                list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
	            	list_sql.add(' WHERE Customer__r.APL_RSM_Relay_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
                    		+ ' And Customer__r.APL_Relay_forecast_Plan_Account__c = ' + (searchOb.grouping == ClsAPLForecastUtil.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ')	
							+ ' And Customer__r.STATDESC__c = \'Active\' '
							//+ ' And Part__r.PRODUCT_CDE__c = \'' + searchOb.accnumber + '\' '
							+ ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
							//+ (searchOb.cbc2Code == 'Relay' ? ClsAPLForecastUtil.getRelayCBCFilter(searchOb.gplId) : ' And Part__r.Product_Hierarchy__c = \'' + searchOb.gplId + '\'')
		    				+ ' And Part__c = \'' + searchOb.partId + '\' '
		    				+ ' And Fiscal_Year__c IN : years '
		                    + ' And Fiscal_Month__c  IN : months '
							+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0)  '
							//update by nelson zheng 2015-10-21 for case 00900375
                        	//+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c = \'RPA\'  '
                        	+ ' And Profit_Center__c = \'APL\'  '
		    				+ ' Group by Fiscal_Date__c  ' );
	    				
	                System.debug('------APL_ClsRSMRelayGroupingForecastService.cls (18 matches) 16-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.partId, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
	            }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = searchOb.partId;
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
        }
		
		/**
         *  This function is used get backlog reference data list.
         *  
         * @author Lei Tang
         * @created 2015-03-10
         * @version 1.0
         * @since 30.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Lei Tang <lei.tang@itbconsult.com>
         * - Created
         *
         */
        public override String getBacklogRefData(String sData) {
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                for(String datekey : searchOb.set_fiscalMonth) {
		            String year = datekey.substring(0, datekey.indexOf('_'));
		            String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
		            Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);
	
					list_futruedate.add(refdate);
		        }

                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();

                if(list_futruedate.size() > 0) {
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_futruedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount, sum(Backlog_Qty__c) qty, Customer_Request_Date_Fiscal_Date__c refdate ');
    				list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
					list_sql.add(' WHERE Customer__r.APL_RSM_Relay_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
                    		+ ' And Customer__r.APL_Relay_forecast_Plan_Account__c = ' + (searchOb.grouping == ClsAPLForecastUtil.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ')	
						+ ' And Customer__r.STATDESC__c = \'Active\' '
						//+ ' And Part__r.PRODUCT_CDE__c = \'' + searchOb.accnumber + '\' '
						+ ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
						//+ (searchOb.cbc2Code == 'Relay' ? ClsAPLForecastUtil.getRelayCBCFilter(searchOb.gplId) : ' And Part__r.Product_Hierarchy__c = \'' + searchOb.gplId + '\'')
	    				+ ' And Part__c = \'' + searchOb.partId + '\' '
	    				+ ' And Customer_Request_Date_Fiscal_Year__c IN : years '
	                    + ' And Customer_Request_Date_Fiscal_Month__c  IN : months '
						+ ' And Backlog_Amount_USD__c != 0 '
						//update by nelson zheng 2015-10-21 for case 00900375
                        //+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        //+ ' And Profit_Center__c = \'RPA\'  '
                        + ' And Profit_Center__c = \'APL\'  '
	    				+ ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
	                System.debug('------APL_ClsRSMRelayGroupingForecastService.cls (18 matches) 17-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.partId, years, months, null, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                 
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = searchOb.partId;
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
            
        }
		
	}

}