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
public without sharing class APL_ClsRSMGroupingForecastService extends APL_Interface.AAPLCtrlService {
	
	public override void setTotalRow(list<APL_ClsEntityType.APLColumn> list_acctColumns, Object config){ 
		
		APL_ClsEntityType.PageConfig pageconf = (APL_ClsEntityType.PageConfig)config;
		system.debug('@#pageconf:'+pageconf.map_year_quartersFuture);
		list<APL_ClsEntityType.APLColumn> list_ref1 = new list<APL_ClsEntityType.APLColumn> {
            new APL_ClsEntityType.APLColumn('Total Billing', 'TotalBilling', '', '', false),
            new APL_ClsEntityType.APLColumn('Total Booking', 'TotalBooking', '', '', false),
            new APL_ClsEntityType.APLColumn('Total Backlog', 'TotalBacklog', '', '', false)
		};
		
		list<APL_ClsEntityType.APLColumn> list_ref2 = new list<APL_ClsEntityType.APLColumn> {
            new APL_ClsEntityType.APLColumn('Total Billing', 'TotalBilling', '', '', false),
            new APL_ClsEntityType.APLColumn('Total Booking', 'TotalBooking', '', '', false),
            new APL_ClsEntityType.APLColumn('Total Backlog', 'TotalBacklog', '', '', false)
		};
		
		String overRelayId = 'OverallRelayProducts';
		
		APL_ClsEntityType.APLColumn totalT = new APL_ClsEntityType.APLColumn(APL_ClsUtils.getHexUID(),'Total Forecast Current Cycle', 'TotalForecastCurrentCycle', ' trt_0 trt_trt col ', '', true);
		APL_ClsEntityType.APLColumn total = new APL_ClsEntityType.APLColumn('Total', 'Total', totalT.id, '', false);
		APL_ClsEntityType.APLColumn TCProducts = new APL_ClsEntityType.APLColumn(APL_ClsUtils.getHexUID(),'T&CProducts', 'TCProducts', totalT.id, '', true);
		APL_ClsEntityType.APLColumn RelayProducts = new APL_ClsEntityType.APLColumn(APL_ClsUtils.getHexUID(),'Relay Products', 'RelayProducts', totalT.id, '', true);
		APL_ClsEntityType.APLColumn OverallRelayProducts = new APL_ClsEntityType.APLColumn('Overall Relay Products', overRelayId, totalT.id, ' overrelaychild ', false);
		
		set<String> set_rsmAMTerritoryCodes = new set<String>();
		set<String> set_rsmRelayTerritoryCodes = new set<String>();
		set<String> set_rsmDisplayName = new set<String>();
		 
		APL_ClsUtils.setAllTerritoryCode(pageconf.managerId, set_rsmAMTerritoryCodes, set_rsmRelayTerritoryCodes, set_rsmDisplayName, 'AM');
		
		list<String> list_oversql = new list<String>();
        list_oversql.add(' sum(RSM_Overall_Forecast__c) fc, Fiscal_Year__c year, Fiscal_Quarter__c quarter ');
		list_oversql.add(' APL_RSM_Overall_Forecast__c ');
		list_oversql.add(' WHERE APL_RSM__r.Manager__c = \'' + pageconf.managerId + '\' '
				+ ' And APL_RSM__r.Display_Name__c IN :set_rsmDisplayName '
				+ ' And RSM_Overall_Forecast__c > 0 '
				+ ClsAPLForecastUtil.getMonthFilter(pageconf.map_year_quartersFuture) 
				+ ' Group by Fiscal_Year__c, Fiscal_Quarter__c ');
       	
       	map<String, APL_ClsEntityType.RSMAccountObj> map_acctId_acctFC = new map<String, APL_ClsEntityType.RSMAccountObj>();
       	
       	for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_oversql))) {
    		String year = (String) result.get('year'),
				   quarter = (String) result.get('quarter'), 
				   dateKey = (year + '_' + quarter);
			//ClsAPLForecastUtil.setResultMap(result, tempAcctId, dateKey, map_acctId_map_dateKey_result);
			APL_ClsEntityType.RSMAccountObj acctFC = new APL_ClsEntityType.RSMAccountObj();
            
            if(!map_acctId_acctFC.containsKey(overRelayId)) {
        		APL_ClsUtils.createRSMAccountObj(acctFC, pageconf.map_year_quartersFuture);
                acctFC.id = overRelayId;
	            acctFC.name = 'Overall Relay Products';
	            map_acctId_acctFC.put(overRelayId, acctFC);
			}else {
				acctFC = map_acctId_acctFC.get(overRelayId);
			}

            acctFC.map_type_FC.get('csFC').put(dateKey, (result.get('fc') != null ? (decimal)result.get('fc') : 0));
            map_acctId_acctFC.put(overRelayId, acctFC);
    	}
    	OverallRelayProducts.json_ForecastData = '{}';
    	if(map_acctId_acctFC.get(overRelayId) != null) {
    		OverallRelayProducts.json_ForecastData =  Json.serialize(map_acctId_acctFC.get(overRelayId).map_type_FC.get('csFC'));
    	}
		system.debug('@#OverallRelayProducts.json_ForecastData: '+OverallRelayProducts.json_ForecastData);
		TCProducts.list_ChildColumn.addAll(list_ref1);
		RelayProducts.list_ChildColumn.addAll(list_ref2);
		
		list<APL_ClsEntityType.APLColumn> list_t = new list<APL_ClsEntityType.APLColumn>();
		list_t.add(totalT);
		list_t.add(total);
		list_t.add(TCProducts);
		list_t.add(RelayProducts);
		list_t.add(OverallRelayProducts);
		
		
		list_acctColumns.addAll(list_t);
		system.debug('@#list_acctColumns: '+list_acctColumns);
	}
	
	public override void setGroupForecast(list<Object> list_data, Object config) { 
		APL_ClsEntityType.PageConfig pageconf = (APL_ClsEntityType.PageConfig)config;
		system.debug('!@#pageconf:'+pageconf);
		
		set<String> set_rsmAMTerritoryCodes = new set<String>();
		APL_ClsUtils.setTerritoryInfo(set_rsmAMTerritoryCodes, 'AM', pageconf.managerId);
		
		list<APL_ClsEntityType.RSMParentAcctObj> list_parentAccts = new list<APL_ClsEntityType.RSMParentAcctObj>();
		if(set_rsmAMTerritoryCodes.size() == 0) {
			return;
		}
		
		map<String, String> map_terr_name = new map<String, String>();
		APL_ClsUtils.setTerritoryUserName(map_terr_name, 'AM', pageconf.managerId);
		
		map<String, APL_ClsEntityType.RSMParentAcctObj> map_rsmgroup_parentAcctId_parentAcct = new map<String, APL_ClsEntityType.RSMParentAcctObj>();

    	String query = '';
        query = ' Select Id, AccountNumber, Name, SALES_TERRITORY_CDE__c,  '; 
        query += ' APL_AM_forecast_Plan_Account__c, APL_AM_Currency__c, APL_AM_Display_Name__c, APL_AM_ParentAccount__c, APL_AM_ParentAccount__r.APL_AM_Display_Name__c, '
        				   + ' APL_AM_ParentAccount__r.APL_AM_Currency__c, APL_AM_ParentAccount__r.AccountNumber, APL_AM_ParentAccount__r.Name, '
        				   + ' APL_RSM_Display_Name__c, APL_RSM_Parent_Account__c, APL_RSM_Parent_Account__r.APL_RSM_Display_Name__c, '
        				   + ' APL_RSM_Parent_Account__r.APL_AM_Currency__c, APL_RSM_Parent_Account__r.AccountNumber, APL_RSM_Parent_Account__r.Name ';
			   
        query += ' FROM Account ';
        query += ' WHERE SALES_TERRITORY_CDE__c IN :set_rsmAMTerritoryCodes ';
        query += ' And STATDESC__c = \'Active\' ';
    	query += ' And APL_AM_forecast_Plan_Account__c != null ';
    	//query += ' And APL_AM_ParentAccount__c != null ';
        //get grouped accounts
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'groupAcctQuery :: '+ groupAcctQuery));
        for(Account acct : database.query(query)){	
        	String acctId = acct.Id,
        			terrcode = acct.SALES_TERRITORY_CDE__c ,
        			pid = (acct.APL_AM_forecast_Plan_Account__c == null ? ClsAcctGroupingUtil.OTHERAcctId : acct.APL_AM_forecast_Plan_Account__c),
        			parentAcctNumb = ((pid == ClsAcctGroupingUtil.OTHERAcctId ) ? ClsAcctGroupingUtil.OTHER : 
		        					 (acct.APL_AM_ParentAccount__c == null ? (acct.AccountNumber) 
		        					 						: (acct.APL_AM_ParentAccount__r.AccountNumber))),
        			parentAcctName = ((pid == ClsAcctGroupingUtil.OTHERAcctId ) ? ClsAcctGroupingUtil.OTHER 
		        					 : (acct.APL_AM_ParentAccount__c == null ? ((acct.AccountNumber == null ? '' : acct.AccountNumber) + ' ' + acct.Name) 
		        					 						: ((acct.APL_AM_ParentAccount__r.AccountNumber == null ? '' : acct.APL_AM_ParentAccount__r.AccountNumber) + ' ' + acct.APL_AM_ParentAccount__r.Name))),
					parentAcctDisplayName = ((pid == ClsAcctGroupingUtil.OTHERAcctId ) ? ClsAcctGroupingUtil.OTHER : 
				        					(acct.APL_AM_ParentAccount__c == null ? acct.APL_AM_Display_Name__c : acct.APL_AM_ParentAccount__r.APL_AM_Display_Name__c)),
					parentCurrencyIsoCode = ((pid == ClsAcctGroupingUtil.OTHERAcctId ) ? 'USD' : 
			        					(acct.APL_AM_ParentAccount__c == null ? acct.APL_AM_Currency__c : acct.APL_AM_ParentAccount__r.APL_AM_Currency__c)),

        			rsmpid = (String.isEmpty(acct.APL_RSM_Display_Name__c) ? ClsAPLForecastUtil.OTHERAcctId : acct.Id),
        			rsmparentAcctDisplayName = (rsmpid == ClsAcctGroupingUtil.OTHERAcctId ? APL_ClsUtils.OTHER : acct.APL_RSM_Display_Name__c),
        			rsmparentAcctNumb = (rsmpid == ClsAcctGroupingUtil.OTHERAcctId ? APL_ClsUtils.OTHER : acct.AccountNumber),
        			rsmparentAcctName = (rsmpid == ClsAcctGroupingUtil.OTHERAcctId ? APL_ClsUtils.OTHER : (String.isEmpty(acct.AccountNumber) ? '' : acct.AccountNumber) + ' ' + acct.Name);
							
					        					
        	if(!map_rsmgroup_parentAcctId_parentAcct.containsKey(rsmparentAcctDisplayName)) {		
	            	
		    	APL_ClsEntityType.RSMParentAcctObj rsmparentAcct = new APL_ClsEntityType.RSMParentAcctObj(rsmpid, rsmparentAcctDisplayName, '', rsmparentAcctDisplayName, rsmpid, '1', rsmparentAcctDisplayName);

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
		
		set<String> set_rsmAMTerritoryCodes = new set<String>();
		APL_ClsUtils.setTerritoryInfo(set_rsmAMTerritoryCodes, 'AM', pageconf.managerId);
		
		list<APL_ClsEntityType.RSMParentAcctObj> list_parentAccts = new list<APL_ClsEntityType.RSMParentAcctObj>();
		if(set_rsmAMTerritoryCodes.size() == 0) {
			return;
		}

    	list<String> list_sql = new list<String>();
    	
    	map<String, APL_ClsEntityType.RSMAccountObj> map_acctId_acctFC = new map<String, APL_ClsEntityType.RSMAccountObj>();
    	//Get account grouping
    	String tempAcctId = 'temp';
    	//get account forecast
    	list_sql.add(' Customer__r.APL_RSM_Display_Name__c groupname, Fiscal_Year__c year, sum(RSM_Forecast__c) fc, '		//, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
    					+' sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter, sum(Forecast__c) amFC ');
    	list_sql.add(' APL_Sales_Forecast__c ');
    	list_sql.add(' WHERE (Type__c = \'GPL\' ' 
	 	            + ' OR Type__c = \'' + APL_ClsUtils.OTHERFCTYPE + '\''
					+ ' OR (Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' ' 
					+ ' ) )'
    					+ ClsAPLForecastUtil.getMonthFilter(pageconf.map_year_quartersFuture) 
    					+ ' And Customer__r.STATDESC__c = \'Active\' '
    					//+ ' And Customer__r.APL_RSM_Display_Name__c != null '
    					+ ' And Customer__r.APL_AM_forecast_Plan_Account__c != null '
    					+ ' And Customer__r.SALES_TERRITORY_CDE__c IN :set_rsmAMTerritoryCodes '
    					+ ' Group by Fiscal_Year__c, Fiscal_Quarter__c, Customer__r.APL_RSM_Display_Name__c ');
    	system.debug('getRSMAcctFC :: ' + APL_ClsUtils.getQueryString(list_sql));
    	for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
    		String accId = (String) result.get('groupname'),
    			   year = (String) result.get('year'),
				   quarter = (String) result.get('quarter'), 
				   dateKey = (year + '_' + quarter);
			//ClsAPLForecastUtil.setResultMap(result, tempAcctId, dateKey, map_acctId_map_dateKey_result);
			if(String.isEmpty(accId)){
				accId = APL_ClsUtils.OTHER;
			}
			
			APL_ClsEntityType.RSMAccountObj acctFC = new APL_ClsEntityType.RSMAccountObj();
            //decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, (String) result.get('currency'), 'USD');
            if(!map_acctId_acctFC.containsKey(accId)) {
        		APL_ClsUtils.createRSMAccountObj(acctFC, pageconf.map_year_quartersFuture);
        		Blob aes = Crypto.generateAesKey(128);
                String hex = EncodingUtil.convertToHex(aes);
                acctFC.id = hex;
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
	
	public override void setOverRelayProductsForecast(list<Object> list_data, Object config) { 
		
		APL_ClsEntityType.PageConfig pageconf = (APL_ClsEntityType.PageConfig)config;
		
		set<String> set_rsmAMTerritoryCodes = new set<String>();
		set<String> set_rsmRelayTerritoryCodes = new set<String>();
		set<String> set_rsmDisplayName = new set<String>();
		 
		APL_ClsUtils.setAllTerritoryCode(pageconf.managerId, set_rsmAMTerritoryCodes, set_rsmRelayTerritoryCodes, set_rsmDisplayName, 'AM');
		
		list<String> list_oversql = new list<String>();
        list_oversql.add(' sum(RSM_Overall_Forecast__c) fc, Fiscal_Year__c year, Fiscal_Quarter__c quarter ');
		list_oversql.add(' APL_RSM_Overall_Forecast__c ');
		list_oversql.add(' WHERE APL_RSM__r.Manager__c = \'' + pageconf.managerId + '\' '
				+ ' And APL_RSM__r.Display_Name__c IN :set_rsmDisplayName '
				+ ' And RSM_Overall_Forecast__c > 0 '
				+ ClsAPLForecastUtil.getMonthFilter(pageconf.map_year_quartersFuture) 
				+ ' Group by Fiscal_Year__c, Fiscal_Quarter__c ');
       	
       	map<String, APL_ClsEntityType.RSMAccountObj> map_acctId_acctFC = new map<String, APL_ClsEntityType.RSMAccountObj>();
        String overRelayId = 'OverallRelayProducts';
       	
       	for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_oversql))) {
    		String year = (String) result.get('year'),
				   quarter = (String) result.get('quarter'), 
				   dateKey = (year + '_' + quarter);
			//ClsAPLForecastUtil.setResultMap(result, tempAcctId, dateKey, map_acctId_map_dateKey_result);
			APL_ClsEntityType.RSMAccountObj acctFC = new APL_ClsEntityType.RSMAccountObj();
            
            if(!map_acctId_acctFC.containsKey(overRelayId)) {
        		APL_ClsUtils.createRSMAccountObj(acctFC, pageconf.map_year_quartersFuture);
                acctFC.id = overRelayId;
	            acctFC.name = 'OverallRelayProducts';
	            map_acctId_acctFC.put(overRelayId, acctFC);
			}else {
				acctFC = map_acctId_acctFC.get(overRelayId);
			}

            acctFC.map_type_FC.get('csFC').put(dateKey, (result.get('fc') != null ? (decimal)result.get('fc') : 0));
			//acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
			//acctFC.map_type_FC.get('pmFC').put(dateKey, (result.get('prevFC') != null ? (decimal)result.get('prevFC') : 0));
			acctFC.json_FCData = Json.serialize(acctFC.map_type_FC);
            map_acctId_acctFC.put(overRelayId, acctFC);
			
    	}
    	for(APL_ClsEntityType.RSMAccountObj rao : map_acctId_acctFC.values()) {
    		list_data.add(rao);
    	}
	}
	
	
	public class SearchLevelTotal extends APL_Interface.AAPLRemoteService {
		
		public override String getExistResult(String sData){
			system.debug('@#sData:'+sData);
            APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb:'+searchOb);
            
            set<String> set_rsmAMTerritoryCodes = new set<String>();
			set<String> set_rsmRelayTerritoryCodes = new set<String>();
			set<String> set_rsmDisplayName = new set<String>();		
			APL_ClsUtils.setAllTerritoryCode(searchOb.managerId, set_rsmAMTerritoryCodes, set_rsmRelayTerritoryCodes, set_rsmDisplayName, 'AM');

			map<String, APL_ClsEntityType.RSMAccountObj> map_acctId_acctFC = new map<String, APL_ClsEntityType.RSMAccountObj>();
			
			String relayId = 'RelayProducts';
			APL_ClsEntityType.RSMAccountObj relayFC = new APL_ClsEntityType.RSMAccountObj();
			APL_ClsUtils.createRSMAccountObj(relayFC, searchOb.map_year_quartersFuture);
            relayFC.id = relayId;
            relayFC.name = relayId;
            map_acctId_acctFC.put(relayId, relayFC);

			if(set_rsmAMTerritoryCodes.size() == 0){
				return Json.serialize(map_acctId_acctFC.get(relayId).map_type_FC.get('csFC'));
			}
			list<String> list_relaySQL = new list<String>();
			
            list_relaySQL.add(' Fiscal_Year__c year, sum(RSM_Forecast__c) fc, Fiscal_Quarter__c quarter ');
	        list_relaySQL.add(' APL_Sales_Forecast__c ');
	        list_relaySQL.add(' WHERE Customer__r.SALES_TERRITORY_CDE__c IN : set_rsmAMTerritoryCodes '
	        			 + ' And Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' '
	        			 + ' And Customer__r.STATDESC__c = \'Active\' '
	        			 + ClsAPLForecastUtil.getMonthFilter(searchOb.map_year_quartersFuture)
	        			 + ' Group by Fiscal_Year__c, Fiscal_Quarter__c ');

	       	for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_relaySQL))) {
	    		String year = (String) result.get('year'),
					   quarter = (String) result.get('quarter'), 
					   dateKey = (year + '_' + quarter);
				//ClsAPLForecastUtil.setResultMap(result, tempAcctId, dateKey, map_acctId_map_dateKey_result);
				APL_ClsEntityType.RSMAccountObj acctFC = new APL_ClsEntityType.RSMAccountObj();
	            
	            if(!map_acctId_acctFC.containsKey(relayId)) {
	        		APL_ClsUtils.createRSMAccountObj(acctFC, searchOb.map_year_quartersFuture);
	                acctFC.id = relayId;
		            acctFC.name = relayId;
		            map_acctId_acctFC.put(relayId, acctFC);
				}else {
					acctFC = map_acctId_acctFC.get(relayId);
				}
	
	            acctFC.map_type_FC.get('csFC').put(dateKey, (result.get('fc') != null ? (decimal)result.get('fc') : 0));
	            map_acctId_acctFC.put(relayId, acctFC);
				
	    	}
	    	//list<APL_ClsEntityType.RSMAccountObj> list_accFC = new list<APL_ClsEntityType.RSMAccountObj>();
	    	//list_accFC.addAll(map_acctId_acctFC.values());
            return Json.serialize(map_acctId_acctFC.get(relayId).map_type_FC.get('csFC'));
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
				
				APL_ClsUtils.setAllTerritoryCode(searchOb.managerId, set_rsmAMTerritoryCodes, set_rsmRelayTerritoryCodes, set_rsmDisplayName, 'AM');
                
                if(searchOb.type == 'RelayProducts') {
					return getRelayRefData(searchOb, set_rsmAMTerritoryCodes);
				}
                Date currentdate = APL_ClsUtils.getCurrentFiscalDate();
                
                set<String> set_acctIds = new set<String>();
				ClsAPLForecastUtil.setRSMAccountIds(true, set_rsmAMTerritoryCodes, set_acctIds);
                
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_currentdate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
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
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate ');
    				list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
    				
    				list_sql.add(' WHERE Customer__c IN : set_soldtoIds '
    						//+ ' And Customer__r.APL_AM_forecast_Plan_Account__c != null '
							+ ClsAPLForecastUtil.getNoneRelayPartQuery()
		    				+ ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
		    				+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
		    				+ ' And Profit_Center__c IN (\'APL\', \'RPA\') '
		    				+ ' Group by Fiscal_Date__c ' );

                    APL_ClsUtils.setRegionMapRefData('tctotal', years, months, set_acctIds, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
	                //current
	                set<String> years = new set<String>();
	                set<Integer> months = new set<Integer>();
	                    
	                APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
	
	                list<String> list_sql = new list<String>();
	                    
	                list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
	                list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
	                list_sql.add(' WHERE Customer__c IN : set_soldtoIds '
	                		//+ ' And Customer__r.APL_AM_forecast_Plan_Account__c != null '
							+ ClsAPLForecastUtil.getNoneRelayPartQuery()
		    				+ ' And Fiscal_Year__c IN : years '
		                    + ' And Fiscal_Month__c  IN : months '
							+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
							+ ' And Profit_Center__c IN (\'APL\', \'RPA\') '
		    				+ ' Group by Fiscal_Date__c  ' );
	
	                APL_ClsUtils.setRegionMapRefData('tctotal', years, months, set_acctIds, list_sql, map_acctId_map_dateKey_result_before);
	            }
                list_beforedate.addALl(list_currentdate);
                
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = 'tctotal';
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
        }
		
		private String getRelayRefData(APL_ClsEntityType.SearchObj searchOb, set<String> set_rsmRelayTerritoryCodes) { 
            try {
            	
            	set<String> set_acctIds = new set<String>();
				ClsAPLForecastUtil.setRSMAccountIds(true, set_rsmRelayTerritoryCodes, set_acctIds);
            	
            	Date currentdate = APL_ClsUtils.getCurrentFiscalDate();
            	
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_currentdate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
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
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate ');
    				list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
    				
    				list_sql.add(' WHERE Customer__c IN : set_soldtoIds '
							//+ ' And Customer__r.APL_AM_forecast_Plan_Account__c != null '
							+ ClsAPLForecastUtil.getRelayPartQuery()
		    				+ ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
		    				+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
		    				+ ' And Profit_Center__c IN (\'APL\', \'RPA\') '
		    				+ ' Group by Fiscal_Date__c ' );

                    APL_ClsUtils.setRegionMapRefData('relaytotal', years, months, set_acctIds, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
	                //current
	                set<String> years = new set<String>();
	                set<Integer> months = new set<Integer>();
	                    
	                APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
	
	                list<String> list_sql = new list<String>();
	                    
	                list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
	                list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
	                list_sql.add(' WHERE Customer__c IN : set_soldtoIds '
							+ ClsAPLForecastUtil.getRelayPartQuery()
		    				+ ' And Fiscal_Year__c IN : years '
		                    + ' And Fiscal_Month__c  IN : months '
							+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
							+ ' And Profit_Center__c IN (\'APL\', \'RPA\') '
		    				+ ' Group by Fiscal_Date__c  ' );
	
	                APL_ClsUtils.setRegionMapRefData('relaytotal', years, months, set_acctIds, list_sql, map_acctId_map_dateKey_result_before);
	            }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = 'relaytotal';
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
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
				
				APL_ClsUtils.setAllTerritoryCode(searchOb.managerId, set_rsmAMTerritoryCodes, set_rsmRelayTerritoryCodes, set_rsmDisplayName, 'AM');
                
                if(searchOb.type == 'RelayProducts') {
					return getRelayBacklogRefData(searchOb, set_rsmAMTerritoryCodes);
				}
                set<String> set_acctIds = new set<String>();
				ClsAPLForecastUtil.setRSMAccountIds(true, set_rsmAMTerritoryCodes, set_acctIds);
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
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount, Customer_Request_Date_Fiscal_Date__c refdate ');
    				list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
					list_sql.add(' WHERE Customer__c IN : set_soldtoIds '
						+ ClsAPLForecastUtil.getNoneRelayPartQuery()
	    				+ ' And Customer_Request_Date_Fiscal_Year__c IN : years '
	                    + ' And Customer_Request_Date_Fiscal_Month__c  IN : months '
						+ ' And Backlog_Amount_USD__c != 0 '
						+ ' And Profit_Center__c IN (\'APL\', \'RPA\') '
	    				+ ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
	                APL_ClsUtils.setRegionMapRefData('tctotal', years, months, set_acctIds, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = 'tctotal';
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
            
        }
		
		
		private String getRelayBacklogRefData(APL_ClsEntityType.SearchObj searchOb, set<String> set_rsmRelayTerritoryCodes) {
            try {
                set<String> set_acctIds = new set<String>();
				ClsAPLForecastUtil.setRSMAccountIds(true, set_rsmRelayTerritoryCodes, set_acctIds);
				
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
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount, Customer_Request_Date_Fiscal_Date__c refdate ');
    				list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
					list_sql.add(' WHERE Customer__c IN : set_soldtoIds '
						+ ClsAPLForecastUtil.getRelayPartQuery()
	    				+ ' And Customer_Request_Date_Fiscal_Year__c IN : years '
	                    + ' And Customer_Request_Date_Fiscal_Month__c  IN : months '
						+ ' And Backlog_Amount_USD__c != 0 '
						+ ' And Profit_Center__c IN (\'APL\', \'RPA\') '
	    				+ ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
	                APL_ClsUtils.setRegionMapRefData('relaytotal', years, months, set_acctIds, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = 'relaytotal';
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
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
                Date currentdate = APL_ClsUtils.getCurrentFiscalDate();
				
				list<Date> list_beforedate = new list<Date>();
				list<Date> list_currentdate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
				
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
				APL_ClsUtils.setTerritoryInfo(set_rsmAMTerritoryCodes, 'AM', searchOb.managerId);
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
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
	                    	+ ' And Customer__r.APL_AM_forecast_Plan_Account__c != null '
	                    	+ ' And Customer__r.STATDESC__c = \'Active\' '
	                    	+ ' And Customer__r.SALES_TERRITORY_CDE__c IN :set_soldtoIds '
	                    	+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
				    		+ ' And Profit_Center__c IN (\'APL\', \'RPA\') '
	                        + ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
	                        + ' Group by Fiscal_Date__c ');

                    APL_ClsUtils.setRegionMapRefData(searchOb.rsmgrouping, years, months, set_rsmAMTerritoryCodes, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
	                //current
	                set<String> years = new set<String>();
	                set<Integer> months = new set<Integer>();
	                    
	                APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
	
	                list<String> list_sql = new list<String>();
	                    
	                list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
	                list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
	                list_sql.add(' WHERE Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
	    					+ ' And Customer__r.APL_AM_forecast_Plan_Account__c != null '
	                    	+ ' And Customer__r.STATDESC__c = \'Active\' '
	                    	+ ' And Customer__r.SALES_TERRITORY_CDE__c IN :set_soldtoIds '
	                    	+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
				    		+ ' And Profit_Center__c IN (\'APL\', \'RPA\') '
	                        + ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
	                        + ' Group by Fiscal_Date__c ');
	
	                APL_ClsUtils.setRegionMapRefData(searchOb.rsmgrouping, years, months, set_rsmAMTerritoryCodes, list_sql, map_acctId_map_dateKey_result_before);
	            }
                list_beforedate.addALl(list_currentdate);
                
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.rsmgrouping;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
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
				APL_ClsUtils.setTerritoryInfo(set_rsmAMTerritoryCodes, 'AM', searchOb.managerId);
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
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount, Customer_Request_Date_Fiscal_Date__c refdate ');
    				list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
					list_sql.add(' WHERE Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
						+ ' And Customer__r.APL_AM_forecast_Plan_Account__c != null '
						+ ' And Customer__r.STATDESC__c = \'Active\' '
						+ ' And Customer__r.SALES_TERRITORY_CDE__c IN :set_soldtoIds '
	    				+ ' And Customer_Request_Date_Fiscal_Year__c IN : years '
	                    + ' And Customer_Request_Date_Fiscal_Month__c  IN : months '
						+ ' And Backlog_Amount_USD__c != 0 '
						+ ' And Profit_Center__c IN (\'APL\', \'RPA\') '
	    				+ ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
	                APL_ClsUtils.setRegionMapRefData(searchOb.rsmgrouping, years, months, set_rsmAMTerritoryCodes, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.rsmgrouping;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
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

			set<String> set_rsmAMTerritoryCodes = new set<String>();
			APL_ClsUtils.setTerritoryInfo(set_rsmAMTerritoryCodes, 'AM', searchOb.managerId);
			list<APL_ClsEntityType.RSMAccountObj> list_accFC = new list<APL_ClsEntityType.RSMAccountObj>();
			if(set_rsmAMTerritoryCodes.size() == 0) {
				return Json.serialize(list_accFC);
			}
            list<String> list_sql = new list<String>();
            list_sql.add(' Fiscal_Year__c year, sum(RSM_Forecast__c) fc, Customer__r.APL_AM_Display_Name__c groupname, Customer__r.APL_AM_forecast_Plan_Account__c parentId, '		//, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
    					+' sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter ');
	    	list_sql.add(' APL_Sales_Forecast__c ');
	    	list_sql.add(' WHERE Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
						+ ' AND  (Type__c = \'GPL\' ' 
	 	            	+ ' OR Type__c = \'' + APL_ClsUtils.OTHERFCTYPE + '\''
						+ ' OR (Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' ' 
						+ ' ) )' 
						+ ' And Customer__r.APL_AM_forecast_Plan_Account__c != null '
						+ ' And Customer__r.STATDESC__c = \'Active\' '
						+ ' And Customer__r.SALES_TERRITORY_CDE__c IN :set_rsmAMTerritoryCodes '
						+ ClsAPLForecastUtil.getMonthFilter(searchOb.map_year_quartersFuture) 
						+ ' Group by Customer__r.APL_AM_Display_Name__c, Fiscal_Year__c, Fiscal_Quarter__c, Customer__r.APL_AM_forecast_Plan_Account__c ');
            
            map<String, APL_ClsEntityType.RSMAccountObj> map_acctId_acctFC = new map<String, APL_ClsEntityType.RSMAccountObj>();
        
            for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
	    		String accId = (String) result.get('parentId'),
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
                Date currentdate = APL_ClsUtils.getCurrentFiscalDate();
                
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_currentdate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
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
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
                    		+ ' And Customer__r.APL_AM_forecast_Plan_Account__c = ' + (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ')	
	                    	+ ' And Customer__r.STATDESC__c = \'Active\' '
	                    	+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
				    		+ ' And Profit_Center__c IN (\'APL\', \'RPA\') '
	                        + ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
	                        + ' Group by Fiscal_Date__c ');
                    APL_ClsUtils.setRegionMapRefData(searchOb.grouping, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
	                //current
	                set<String> years = new set<String>();
	                set<Integer> months = new set<Integer>();
	                    
	                APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
	
	                list<String> list_sql = new list<String>();
	                    
	                list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
	                list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
	                list_sql.add(' WHERE Customer__r.APL_RSM_Display_Name__c = \'' + searchOb.rsmgrouping + '\' '
                    		+ ' And Customer__r.APL_AM_forecast_Plan_Account__c = ' + (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ')	
						+ ' And Customer__r.STATDESC__c = \'Active\' '
	    				+ ' And Fiscal_Year__c IN : years '
	                    + ' And Fiscal_Month__c  IN : months '
						+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
						+ ' And Profit_Center__c IN (\'APL\', \'RPA\') '
	    				+ ' Group by Fiscal_Date__c  ' );
	
	                APL_ClsUtils.setRegionMapRefData(searchOb.grouping, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
	            }
                list_beforedate.addALl(list_currentdate);
                
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.grouping;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
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
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount, Customer_Request_Date_Fiscal_Date__c refdate ');
    				list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
					list_sql.add(' WHERE Customer__r.APL_RSM_Display_Name__c = \'' + searchOb.rsmgrouping + '\' '
                    		+ ' And Customer__r.APL_AM_forecast_Plan_Account__c = ' + (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ')	
						+ ' And Customer__r.STATDESC__c = \'Active\' '
	    				+ ' And Customer_Request_Date_Fiscal_Year__c IN : years '
	                    + ' And Customer_Request_Date_Fiscal_Month__c  IN : months '
						+ ' And Backlog_Amount_USD__c != 0 '
						+ ' And Profit_Center__c IN (\'APL\', \'RPA\') '
	    				+ ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
	                APL_ClsUtils.setRegionMapRefData(searchOb.grouping, years, months, null, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.grouping;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
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
            
            set<String> set_rsmAMTerritoryCodes = new set<String>();
			APL_ClsUtils.setTerritoryInfo(set_rsmAMTerritoryCodes, 'AM', searchOb.managerId);
			list<APL_ClsEntityType.RSMAccountObj> list_accFC = new list<APL_ClsEntityType.RSMAccountObj>();
			if(set_rsmAMTerritoryCodes.size() == 0) {
				return Json.serialize(list_accFC);
			}
            
            list<String> list_sql = new list<String>();

	    	map<String, map<String, AggregateResult>> map_cbcName_map_dateKey_result =
	    		new map<String, map<String, AggregateResult>>();
	    	list_sql.add(' Fiscal_Year__c year, sum(RSM_Forecast__c) fc,  ' 		//, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
						+ ' sum(Forecast__c) amFC, sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter, '
						+ ' GPL__r.CBC2__c cbc2Name, GPL__r.CBC3__c cbc3Name ');
						
			list_sql.add(' APL_Sales_Forecast__c ');
			list_sql.add(' WHERE Customer__r.APL_AM_forecast_Plan_Account__c = ' 
						+ (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ') 
						+ ' And Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
						+ ' AND  (Type__c = \'GPL\' ' 
		 	            + ' OR Type__c = \'' + APL_ClsUtils.OTHERFCTYPE + '\' )'
						+ ' And Customer__r.STATDESC__c = \'Active\' '
						+ ' And Customer__r.SALES_TERRITORY_CDE__c IN :set_rsmAMTerritoryCodes '
						+ ClsAPLForecastUtil.getMonthFilter(searchOb.map_year_quartersFuture) +
						' Group by Fiscal_Year__c, Fiscal_Quarter__c, GPL__r.CBC2__c, GPL__r.CBC3__c ');
			//Generate forecast view result
			//system.debug('getRSMCBCFC query :: ' + ClsAPLForecastUtil.getQueryString(list_sql));
			list<String> list_relaysql = new list<String>();
			list_relaysql.add(' Fiscal_Year__c year, sum(RSM_Forecast__c) fc,  ' 		//, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
						+ ' sum(Forecast__c) amFC, sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter, '
						+ '  Relay_CBC2_Code__c cbc2Name');
			list_relaysql.add(' APL_Sales_Forecast__c ');
			list_relaysql.add(' WHERE Customer__r.APL_AM_forecast_Plan_Account__c = ' 
						+ (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ') 
						+ ' And Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
						+ ' AND Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' ' 
					    + 	APL_ClsUtils.getRelayCBC2CodeQuery()
						+ ' And Customer__r.STATDESC__c = \'Active\' '
						+ ' And Customer__r.SALES_TERRITORY_CDE__c IN :set_rsmAMTerritoryCodes '
						+ ClsAPLForecastUtil.getMonthFilter(searchOb.map_year_quartersFuture) +
						' Group by Fiscal_Year__c, Fiscal_Quarter__c, Relay_CBC2_Code__c ');
			
			
			map<String, APL_ClsEntityType.RSMAccountObj> map_acctId_acctFC = new map<String, APL_ClsEntityType.RSMAccountObj>();
			
			list<APL_ClsEntityType.Cbc2Object> list_cbc2column = new list<APL_ClsEntityType.Cbc2Object>();
	    	setCBC2Column(list_cbc2column);
	    	map<String, APL_ClsEntityType.Cbc2Object> map_cbcRowKey_cbcName = new map<String, APL_ClsEntityType.Cbc2Object>();
	    	for(APL_ClsEntityType.Cbc2Object cbc2 : list_cbc2column) {
	    		map_cbcRowKey_cbcName.put(cbc2.code, cbc2);
	    		APL_ClsEntityType.RSMAccountObj rsmcbc = new APL_ClsEntityType.RSMAccountObj();
	    		APL_ClsUtils.createRSMAccountObj(rsmcbc, searchOb.map_year_quartersFuture);
                rsmcbc.id = APL_ClsUtils.getHexUID();
	    		rsmcbc.name = cbc2.name;
	    		rsmcbc.accnumber = cbc2.code;
	    		map_acctId_acctFC.put(cbc2.code, rsmcbc);
	    	}
			system.debug('!@#list_sql : '+ClsAPLForecastUtil.getQueryString(list_sql));
			for(AggregateResult  result : Database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
				String year = (String) result.get('year'),
					   quarter = (String) result.get('quarter'), 
					   dateKey = (year + '_' + quarter),
					   cbc2 = (String) (result.get('cbc2Name') == null ? '' : result.get('cbc2Name')),
					   cbc3 = (String) (result.get('cbc3Name') == null ? '' : result.get('cbc3Name')),
					   cbcName = ClsAPLForecastUtil.getCBCKeyName(cbc2, cbc3);
	    		
	    		APL_ClsEntityType.RSMAccountObj rsmcbc = new APL_ClsEntityType.RSMAccountObj();
	    		//decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, (String) result.get('currency'), 'USD');
	    		if(!map_acctId_acctFC.containsKey(cbcName)) {
	        		APL_ClsUtils.createRSMAccountObj(rsmcbc, searchOb.map_year_quartersFuture);
	                rsmcbc.id = APL_ClsUtils.getHexUID();
		            rsmcbc.name = map_cbcRowKey_cbcName.get(cbcName).name;
					rsmcbc.accnumber = map_cbcRowKey_cbcName.get(cbcName).code;
		            map_acctId_acctFC.put(cbcName, rsmcbc);
				}else {
					rsmcbc = map_acctId_acctFC.get(cbcName);
				}
	    		
	    		rsmcbc.map_type_FC.get('csFC').put(dateKey, (result.get('fc') != null ? (decimal)result.get('fc') + rsmcbc.map_type_FC.get('csFC').get(dateKey) : rsmcbc.map_type_FC.get('csFC').get(dateKey)));
				//acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
				rsmcbc.map_type_FC.get('pmFC').put(dateKey, (result.get('prevFC') != null ? (decimal)result.get('prevFC') + rsmcbc.map_type_FC.get('pmFC').get(dateKey) : rsmcbc.map_type_FC.get('pmFC').get(dateKey)));
	            map_acctId_acctFC.put(cbcName, rsmcbc);
	    	}
	    	
	    	for(AggregateResult  result : Database.query(ClsAPLForecastUtil.getQueryString(list_relaysql))) {
				String year = (String) result.get('year'),
					   quarter = (String) result.get('quarter'), 
					   dateKey = (year + '_' + quarter),
					   cbcName = 'Relay';
					   //cbc3 = (String) (result.get('cbc3Name') == null ? '' : result.get('cbc3Name')),
					   //cbcName = ClsAPLForecastUtil.getCBCKeyName(cbc2, cbc3);
	    		
	    		APL_ClsEntityType.RSMAccountObj rsmcbc = new APL_ClsEntityType.RSMAccountObj();
	    		//decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, (String) result.get('currency'), 'USD');
	    		if(!map_acctId_acctFC.containsKey(cbcName)) {
	        		APL_ClsUtils.createRSMAccountObj(rsmcbc, searchOb.map_year_quartersFuture);
	                rsmcbc.id = APL_ClsUtils.getHexUID();
		            rsmcbc.name = map_cbcRowKey_cbcName.get(cbcName).name;
					rsmcbc.accnumber = map_cbcRowKey_cbcName.get(cbcName).code;
		            map_acctId_acctFC.put(cbcName, rsmcbc);
				}else {
					rsmcbc = map_acctId_acctFC.get(cbcName);
				}

	            rsmcbc.map_type_FC.get('csFC').put(dateKey, (result.get('fc') != null ? (decimal)result.get('fc') + rsmcbc.map_type_FC.get('csFC').get(dateKey) : rsmcbc.map_type_FC.get('csFC').get(dateKey)));
				//acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
				rsmcbc.map_type_FC.get('pmFC').put(dateKey, (result.get('prevFC') != null ? (decimal)result.get('prevFC') + rsmcbc.map_type_FC.get('pmFC').get(dateKey) : rsmcbc.map_type_FC.get('pmFC').get(dateKey)));
	            map_acctId_acctFC.put(cbcName, rsmcbc);
	    	}
	    	
	    	for(APL_ClsEntityType.Cbc2Object cbc2 : list_cbc2column) {
	    		list_accFC.add(map_acctId_acctFC.get(cbc2.code));
	    	}

	    	system.debug('@#list_accFC:'+list_accFC);
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
                Date currentdate = APL_ClsUtils.getCurrentFiscalDate();
                
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_currentdate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
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
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
                    		+ ' And Customer__r.APL_AM_forecast_Plan_Account__c = ' + (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ')	
	                    	+ ' And Customer__r.STATDESC__c = \'Active\' '
	                    	+ (searchOb.cbc2Code == ClsAPLForecastUtil.CBCOTHER ? ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\'', '') : '')
							+ (searchOb.cbc2Code == ClsAPLForecastUtil.CBCRELAY ? ClsAPLForecastUtil.getRelayPartQuery() : '')
							+ ((searchOb.cbc2Code != ClsAPLForecastUtil.CBCOTHER && searchOb.cbc2Code != ClsAPLForecastUtil.CBCRELAY) 
									? 'And Part__r.Product_Hierarchy__r.CBC2__c = \'' + searchOb.cbc2Code +'\'' : '')
	                    	+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
				    		+ ' And Profit_Center__c IN (\'APL\', \'RPA\') '
	                        + ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
	                        + ' Group by Fiscal_Date__c ');
                    APL_ClsUtils.setRegionMapRefData(searchOb.cbc2Code, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
	                //current
	                set<String> years = new set<String>();
	                set<Integer> months = new set<Integer>();
	                    
	                APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
	
	                list<String> list_sql = new list<String>();
	                    
	                list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
	                list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
	                list_sql.add(' WHERE Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ')
                    		+ ' And Customer__r.APL_AM_forecast_Plan_Account__c = ' + (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ')	
							+ ' And Customer__r.STATDESC__c = \'Active\' '
							+ (searchOb.cbc2Code == ClsAPLForecastUtil.CBCOTHER ? ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\'', '') : '')
								+ (searchOb.cbc2Code == ClsAPLForecastUtil.CBCRELAY ? ClsAPLForecastUtil.getRelayPartQuery() : '')
								+ ((searchOb.cbc2Code != ClsAPLForecastUtil.CBCOTHER && searchOb.cbc2Code != ClsAPLForecastUtil.CBCRELAY) 
										? 'And Part__r.Product_Hierarchy__r.CBC2__c = \'' + searchOb.cbc2Code +'\'' : '')
		    				+ ' And Fiscal_Year__c IN : years '
		                    + ' And Fiscal_Month__c  IN : months '
							+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
							+ ' And Profit_Center__c IN (\'APL\', \'RPA\') '
		    				+ ' Group by Fiscal_Date__c  ' );
	
	                APL_ClsUtils.setRegionMapRefData(searchOb.cbc2Code, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
	            }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.cbc2Code;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
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
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount, Customer_Request_Date_Fiscal_Date__c refdate ');
    				list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
					list_sql.add(' WHERE Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ')
                    		+ ' And Customer__r.APL_AM_forecast_Plan_Account__c = ' + (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ')	
						+ ' And Customer__r.STATDESC__c = \'Active\' '
						+ (searchOb.cbc2Code == ClsAPLForecastUtil.CBCOTHER ? ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\'', '') : '')
							+ (searchOb.cbc2Code == ClsAPLForecastUtil.CBCRELAY ? ClsAPLForecastUtil.getRelayPartQuery() : '')
							+ ((searchOb.cbc2Code != ClsAPLForecastUtil.CBCOTHER && searchOb.cbc2Code != ClsAPLForecastUtil.CBCRELAY) 
									? 'And Part__r.Product_Hierarchy__r.CBC2__c = \'' + searchOb.cbc2Code +'\'' : '')
	    				+ ' And Customer_Request_Date_Fiscal_Year__c IN : years '
	                    + ' And Customer_Request_Date_Fiscal_Month__c  IN : months '
						+ ' And Backlog_Amount_USD__c != 0 '
						+ ' And Profit_Center__c IN (\'APL\', \'RPA\') '
	    				+ ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
	                APL_ClsUtils.setRegionMapRefData(searchOb.cbc2Code, years, months, null, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.cbc2Code;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
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
            
            if(searchOb.cbc2Code == 'Relay') {
            	getRelayExistResult(searchOb, list_accFC);
            	return Json.serialize(list_accFC);
            }
			
			set<String> set_rsmAMTerritoryCodes = new set<String>();
			APL_ClsUtils.setTerritoryInfo(set_rsmAMTerritoryCodes, 'AM', searchOb.managerId);
			if(set_rsmAMTerritoryCodes.size() == 0) {
				return Json.serialize(list_accFC);
			}
			
			
            list<String> list_sql = new list<String>();
			
	    	map<String, String> map_prodHichyId_gplCode = new map<String, String>();
	    	map<String, String> map_gplId_gplName = new map<String, String>();
			map<String, ClsAPLEntityTypes.GPLFCValueObj> map_gplId_gplFC 
				= new map<String, ClsAPLEntityTypes.GPLFCValueObj>();
			//set gpl code & gpl name map
	        ClsAPLForecastUtil.setGPLCode(map_prodHichyId_gplCode, searchOb.cbc2Code, map_gplId_gplName);
        	system.debug('@#map_prodHichyId_gplCode:'+map_prodHichyId_gplCode);
        	list<String> list_sortedRelayCBC = ClsAPLForecastUtil.getSortedRelayCBCKey();
        	
	        //get query string for gpl forecast
	    	list_sql.add(' Fiscal_Year__c year, sum(RSM_Forecast__c) fc, GPL__c gplId,   ' 		//, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
					+ ' sum(Forecast__c) amFC, sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter');
					
			list_sql.add(' APL_Sales_Forecast__c ');
			list_sql.add(' WHERE Customer__r.APL_AM_forecast_Plan_Account__c = ' 
					+ (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ') 
					+ ' And Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ')
					+ ' And Type__c = \'' + ClsAPLForecastUtil.GPLFCTYPE + '\' '
					+ ClsAPLForecastUtil.getMonthFilter(searchOb.map_year_quartersFuture)
					+ (searchOb.cbc2Code == ClsAPLForecastUtil.CBCRELAY ? ClsAPLForecastUtil.getRelayGPLQuery(false) : ' And GPL__r.CBC2__c =\'' + searchOb.cbc2Code + '\' ')
					+ ' And Customer__r.STATDESC__c = \'Active\' '
					+ ' And Customer__r.SALES_TERRITORY_CDE__c IN :set_rsmAMTerritoryCodes '
					+ ' Group by Fiscal_Year__c, Fiscal_Quarter__c, GPL__c ');
            
            map<String, APL_ClsEntityType.RSMAccountObj> map_acctId_acctFC = new map<String, APL_ClsEntityType.RSMAccountObj>();
            
            for(String gplId : map_gplId_gplName.keySet()) {
        		APL_ClsEntityType.RSMAccountObj acctFC = new APL_ClsEntityType.RSMAccountObj();
        		APL_ClsUtils.createRSMAccountObj(acctFC, searchOb.map_year_quartersFuture);
        		acctFC.id = gplId;
        		acctFC.isHighLighted = false;
        		acctFC.accnumber = map_prodHichyId_gplCode.get(gplId);
                acctFC.name = '[ ' + acctFC.accnumber + ' ] - ' + map_gplId_gplName.get(gplId);
                map_acctId_acctFC.put(gplId, acctFC);
                
        	}
            
            for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
	    		String accId = (String) result.get('gplId'),
	    			   year = (String) result.get('year'),
					   quarter = (String) result.get('quarter'), 
					   dateKey = (year + '_' + quarter);
					   
				APL_ClsEntityType.RSMAccountObj acctFC = new APL_ClsEntityType.RSMAccountObj();
	            //decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, (String) result.get('currency'), 'USD');
	            if(!map_acctId_acctFC.containsKey(accId)) {
	        		APL_ClsUtils.createRSMAccountObj(acctFC, searchOb.map_year_quartersFuture);
	                acctFC.id = accId;
		            acctFC.accnumber = map_prodHichyId_gplCode.get(accId);
                	acctFC.name = '[ ' + acctFC.accnumber + ' ] - ' + map_gplId_gplName.get(accId);
                	acctFC.isHighLighted = false;
		            map_acctId_acctFC.put(accId, acctFC);
				}else {
					acctFC = map_acctId_acctFC.get(accId);
				}
	
	            acctFC.map_type_FC.get('csFC').put(dateKey, (result.get('fc') != null ? (decimal)result.get('fc') : 0));
				//acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
				acctFC.map_type_FC.get('pmFC').put(dateKey, (result.get('prevFC') != null ? (decimal)result.get('prevFC') : 0));
	            map_acctId_acctFC.put(accId, acctFC);
					   
            }
             
            APL_ClsUtils.setHighlight(searchOb, APL_ClsUtils.PARTFCTYPE, APL_ClsUtils.RSMFCTYPE, map_acctId_acctFC);
   
            list_accFC.addAll(map_acctId_acctFC.values());
            
            return Json.serialize(list_accFC);
		}
		
		
		private void getRelayExistResult(APL_ClsEntityType.SearchObj searchOb, list<APL_ClsEntityType.RSMAccountObj> list_accFC) {
			//list_accFC = new list<APL_ClsEntityType.RSMAccountObj>();
			
			list<String> list_sortedRelayCBC = ClsAPLForecastUtil.getSortedRelayCBCKey();
	        list<String> list_sql = new list<String>();
			system.debug('@#list_sortedRelayCBC:'+list_sortedRelayCBC);
	        //get query string for gpl forecast
	    	list_sql.add(' Fiscal_Year__c year, sum(RSM_Forecast__c) fc, ' 		//, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
						+ ' sum(Forecast__c) amFC, sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter, '
						+ ' Relay_CBC2_Code__c cbc2Name ');
						
			list_sql.add(' APL_Sales_Forecast__c ');
			list_sql.add(' WHERE Customer__r.APL_AM_forecast_Plan_Account__c = ' 
						+ (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ') 
						+ ' And Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ')
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
	            String quarter = (String) result.get('quarter');
	            String dateKey = year + '_' + quarter;
	            
	            APL_ClsEntityType.RSMAccountObj acctFC = new APL_ClsEntityType.RSMAccountObj();
	            //decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, (String) result.get('currency'), 'USD');
	            if(!map_acctId_acctFC.containsKey(cbcKeyName)) {
	        		APL_ClsUtils.createRSMAccountObj(acctFC, searchOb.map_year_quartersFuture);
	                acctFC.id = cbcKeyName;
		            acctFC.name = ' [ '+cbcKeyName+' ] - ' + ClsAPLForecastUtil.map_RELAY_CBCCode_CBCDESC.get(cbcKeyName);
					acctFC.accnumber = cbcKeyName;
					acctFC.isHighLighted = false;
		            map_acctId_acctFC.put(cbcKeyName, acctFC);
				}else {
					acctFC = map_acctId_acctFC.get(cbcKeyName);
				}
	
	            acctFC.map_type_FC.get('csFC').put(dateKey, (result.get('fc') != null ? (decimal)result.get('fc') : 0));
				//acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
				acctFC.map_type_FC.get('pmFC').put(dateKey, (result.get('prevFC') != null ? (decimal)result.get('prevFC') : 0));
	            map_acctId_acctFC.put(cbcKeyName, acctFC);
	        }
	        
	        APL_ClsUtils.setHighlight(searchOb, APL_ClsUtils.RELAYFCTYPE, APL_ClsUtils.RSMFCTYPE, map_acctId_acctFC);
	        
        	system.debug('@#map_acctId_acctFC:'+map_acctId_acctFC);
			list_accFC.addAll(map_acctId_acctFC.values());		
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

                Date currentdate = APL_ClsUtils.getCurrentFiscalDate();
                
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_currentdate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
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
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ')
                    		+ ' And Customer__r.APL_AM_forecast_Plan_Account__c = ' + (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ')	
	                    	+ ' And Customer__r.STATDESC__c = \'Active\' '
	                    	+ (searchOb.cbc2Code == 'Relay' ? ClsAPLForecastUtil.getRelayCBCFilter(searchOb.gplId) : ' And Part__r.Product_Hierarchy__c = \'' + searchOb.gplId + '\'')
	                    	+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
				    		+ ' And Profit_Center__c IN (\'APL\', \'RPA\') '
	                        + ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
	                        + ' Group by Fiscal_Date__c ');
                    APL_ClsUtils.setRegionMapRefData(searchOb.gplId, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
	                //current
	                set<String> years = new set<String>();
	                set<Integer> months = new set<Integer>();
	                    
	                APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
	
	                list<String> list_sql = new list<String>();
	                    
	                list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
	                list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
	                list_sql.add(' WHERE Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ')
                    		+ ' And Customer__r.APL_AM_forecast_Plan_Account__c = ' + (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ')	
						+ ' And Customer__r.STATDESC__c = \'Active\' '
						+ (searchOb.cbc2Code == 'Relay' ? ClsAPLForecastUtil.getRelayCBCFilter(searchOb.gplId) : ' And Part__r.Product_Hierarchy__c = \'' + searchOb.gplId + '\'')
	    				+ ' And Fiscal_Year__c IN : years '
	                    + ' And Fiscal_Month__c  IN : months '
						+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0)  '
						+ ' And Profit_Center__c IN (\'APL\', \'RPA\') '
	    				+ ' Group by Fiscal_Date__c  ' );
	
	                APL_ClsUtils.setRegionMapRefData(searchOb.gplId, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
	            }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.gplId;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
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
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount, Customer_Request_Date_Fiscal_Date__c refdate ');
    				list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
					list_sql.add(' WHERE Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ')
                    		+ ' And Customer__r.APL_AM_forecast_Plan_Account__c = ' + (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ')	
						+ ' And Customer__r.STATDESC__c = \'Active\' '
						+ (searchOb.cbc2Code == 'Relay' ? ClsAPLForecastUtil.getRelayCBCFilter(searchOb.gplId) : ' And Part__r.Product_Hierarchy__c = \'' + searchOb.gplId + '\'')
	    				+ ' And Customer_Request_Date_Fiscal_Year__c IN : years '
	                    + ' And Customer_Request_Date_Fiscal_Month__c  IN : months '
						+ ' And Backlog_Amount_USD__c != 0 '
						+ ' And Profit_Center__c IN (\'APL\', \'RPA\') '
	    				+ ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
	                APL_ClsUtils.setRegionMapRefData(searchOb.gplId, years, months, null, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.gplId;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
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
            set<String> set_rsmAMTerritoryCodes = new set<String>();
			APL_ClsUtils.setTerritoryInfo(set_rsmAMTerritoryCodes, 'AM', searchOb.managerId);
			if(set_rsmAMTerritoryCodes.size() == 0) {
				return Json.serialize(list_accFC);
			}
			map<String, APL_ClsEntityType.RSMAccountObj> map_acctId_acctFC = new map<String, APL_ClsEntityType.RSMAccountObj>();
			if(searchOb.cbc2Code == ClsAPLForecastUtil.RELAYFCTYPE) {
				getRelayExistResult(searchOb, list_accFC);

            	return Json.serialize(list_accFC);
			} 
            list<String> list_sql = new list<String>();
        
	        //get query string for gpl forecast
	    	list_sql.add(' Fiscal_Year__c year, sum(RSM_Forecast__c) fc, Part__c partId, Part__r.Description__c partDesc, ' 		//, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
					+ 'Part__r.Name partName, sum(Forecast__c) amFC, sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter ');
						
			list_sql.add(' APL_Sales_Forecast__c ');
			list_sql.add(' WHERE Customer__r.APL_AM_forecast_Plan_Account__c = ' 
					+ (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ') 
					+ ' And Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ')
					+ ' And Part__c != null '
					+ ClsAPLForecastUtil.getMonthFilter(searchOb.map_year_quartersFuture)
					+ (searchOb.cbc2Code == ClsAPLForecastUtil.CBCOTHER ? ' And ' + ClsAPLForecastUtil.getOtherPartQuery() 
						: ' And GPL__c =\'' + searchOb.gplId + '\' ')
					+ ' And Customer__r.STATDESC__c = \'Active\' '
					+ ' And Customer__r.SALES_TERRITORY_CDE__c IN :set_rsmAMTerritoryCodes '
					+ ' Group by Part__c, Part__r.Name, Part__r.Description__c, Fiscal_Year__c, Fiscal_Quarter__c ');
	        
            
            
            for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
	    		String accId = (String) result.get('partId'),
	    			   year = (String) result.get('year'),
					   quarter = (String) result.get('quarter'), 
					   dateKey = (year + '_' + quarter);
					   
				APL_ClsEntityType.RSMAccountObj acctFC = new APL_ClsEntityType.RSMAccountObj();
	            //decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, (String) result.get('currency'), 'USD');
	            if(!map_acctId_acctFC.containsKey(accId)) {
	        		APL_ClsUtils.createRSMAccountObj(acctFC, searchOb.map_year_quartersFuture);
	                acctFC.id = accId;
		            acctFC.name = (String) result.get('partName');
					acctFC.accnumber = (String) result.get('partDesc');
		            map_acctId_acctFC.put(accId, acctFC);
				}else {
					acctFC = map_acctId_acctFC.get(accId);
				}
	
	            acctFC.map_type_FC.get('csFC').put(dateKey, (result.get('fc') != null ? (decimal)result.get('fc') : 0));
				//acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
				acctFC.map_type_FC.get('pmFC').put(dateKey, (result.get('prevFC') != null ? (decimal)result.get('prevFC') : 0));
	            map_acctId_acctFC.put(accId, acctFC);
					   
            }
            
            list_accFC.addAll(map_acctId_acctFC.values());
            
            return Json.serialize(list_accFC);
		}
		
		
		private void getRelayExistResult(APL_ClsEntityType.SearchObj searchOb, list<APL_ClsEntityType.RSMAccountObj> list_accFC) {
			//list_accFC = new list<APL_ClsEntityType.RSMAccountObj>();
			
			list<String> list_sortedRelayCBC = ClsAPLForecastUtil.getSortedRelayCBCKey();
	        list<String> list_sql = new list<String>();
	        list<String> set_tempqy = new list<String>();
			system.debug('@#list_sortedRelayCBC:'+list_sortedRelayCBC);
	        //get query string for gpl forecast
	    	list_sql.add(' Fiscal_Year__c year, Fiscal_Quarter__c quarter, PRODUCT_CDE__c procode, PROD_NAME__c proname, ' //Part__r.Product_Hierarchy__c gplId , 
	        		+ ' sum(RSM_Forecast__c) fc, sum(RSM_Quantity__c) quantity,sum(Current_month_1_RSM_forecast__c) prevFC, sum(Forecast__c) amFC, avg(RSM_Price__c) price ');
	        list_sql.add(' APL_Sales_Forecast__c ');
	        list_sql.add(' WHERE Customer__r.APL_AM_forecast_Plan_Account__c = ' 
					+ (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ') 
					+ ' And Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ')
			        + ' And Customer__r.STATDESC__c = \'Active\' '
			        + ' And Relay_CBC2_Code__c = \'' + searchOb.gplId + '\' '
			        //+ ClsAPLForecastUtil.getRelayCBCFilter(searchOb.gplId)
			        + ClsAPLForecastUtil.getMonthFilter(searchOb.map_year_quartersFuture)
			        + ' And Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' '  
			        + ' Group by Part__c, Fiscal_Year__c, Fiscal_Quarter__c, PRODUCT_CDE__c, PROD_NAME__c');
						
			map<String, APL_ClsEntityType.RSMAccountObj> map_acctId_acctFC = new map<String, APL_ClsEntityType.RSMAccountObj>();
			String pricePlaces = APL_ClsUtils.getPricePlaces();
        	//system.debug('@#list_sql:'+APL_ClsUtils.getQueryString(list_sql));
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
                list_sql.add(' PRODUCT_CDE__c , RSM_Price__c ');
                list_sql.add(' APL_Sales_Forecast__c ');
                list_sql.add(' WHERE Customer__r.APL_AM_forecast_Plan_Account__c = ' 
					+ (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ') 
					+ ' And Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ')
			        + ' And Customer__r.STATDESC__c = \'Active\' '
			        + ' And Relay_CBC2_Code__c = \'' + searchOb.gplId + '\' '
			        + ' And Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' '  
                    + ' And Fiscal_Year__c = \''+set_tempqy.get(0)+'\' '
                    + ' And Fiscal_Quarter__c = \''+set_tempqy.get(1)+'\' ');
                system.debug('@#list_sql:'+APL_ClsUtils.getQueryString(list_sql));
                for(APL_Sales_Forecast__c result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
                    String accId = result.PRODUCT_CDE__c;
                    system.debug('@#accId:'+accId);
                    system.debug('@#accId:'+map_acctId_acctFC.get(accId));
                    if(map_acctId_acctFC.containsKey(accId)) {
                        decimal price = (result.RSM_Price__c == null ? 0 : result.RSM_Price__c);
                        map_acctId_acctFC.get(accId).price = price.setScale((pricePlaces == '' ? 3 : Integer.valueOf(pricePlaces)));
                    }
                }
            }
	        
	        APL_ClsUtils.setHighlight(searchOb, APL_ClsUtils.RELAYFCTYPE, APL_ClsUtils.RSMFCTYPE, map_acctId_acctFC);
	        
        	system.debug('@#map_acctId_acctFC:'+map_acctId_acctFC);
			list_accFC.addAll(map_acctId_acctFC.values());		
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
                
                if(searchOb.cbc2Code == 'Relay') {
                	return getRelayRefData(sData);
                }
                
                Date currentdate = APL_ClsUtils.getCurrentFiscalDate();
                
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_currentdate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
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
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ')
                    		+ ' And Customer__r.APL_AM_forecast_Plan_Account__c = ' + (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ')	
	                    	+ ' And Customer__r.STATDESC__c = \'Active\' '
	                    	+ (searchOb.cbc2Code == 'Relay' ? ClsAPLForecastUtil.getRelayCBCFilter(searchOb.gplId) : ' And Part__r.Product_Hierarchy__c = \'' + searchOb.gplId + '\'')
	                    	+ ' And Part__c = \'' + searchOb.partId + '\' '
	                    	+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
				    		+ ' And Profit_Center__c IN (\'APL\', \'RPA\') '
	                        + ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
	                        + ' Group by Fiscal_Date__c ');
                    APL_ClsUtils.setRegionMapRefData(searchOb.partId, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
	                //current
	                set<String> years = new set<String>();
	                set<Integer> months = new set<Integer>();
	                    
	                APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
	
	                list<String> list_sql = new list<String>();
	                    
	                list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
	                list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
	                list_sql.add(' WHERE Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ')
                    		+ ' And Customer__r.APL_AM_forecast_Plan_Account__c = ' + (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ')	
							+ ' And Customer__r.STATDESC__c = \'Active\' '
							+ (searchOb.cbc2Code == 'Relay' ? ClsAPLForecastUtil.getRelayCBCFilter(searchOb.gplId) : ' And Part__r.Product_Hierarchy__c = \'' + searchOb.gplId + '\'')
							+ ' And Part__c = \'' + searchOb.partId + '\' '
		    				+ ' And Fiscal_Year__c IN : years '
		                    + ' And Fiscal_Month__c  IN : months '
							+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0)  '
							+ ' And Profit_Center__c IN (\'APL\', \'RPA\') '
		    				+ ' Group by Fiscal_Date__c  ' );
	
	                APL_ClsUtils.setRegionMapRefData(searchOb.partId, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
	            }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.partId;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
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
        private String getRelayRefData(String sData) { 
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData,APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                Date currentdate = APL_ClsUtils.getCurrentFiscalDate();
                
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_currentdate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
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
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ')
                    		+ ' And Customer__r.APL_AM_forecast_Plan_Account__c = ' + (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ')	
	                    	+ ' And Customer__r.STATDESC__c = \'Active\' '
	                    	+ ClsAPLForecastUtil.getRelayCBCFilter(searchOb.gplId)
	                    	+ ' And Part__r.PRODUCT_CDE__c = \'' + searchOb.relayCode + '\' '
	                    	+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
				    		//update by nelson zheng 2015-10-21 for case 00900375
                        	//+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	+ ' And Profit_Center__c = \'APL\' '
	                        + ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
	                        + ' Group by Fiscal_Date__c ');
                    APL_ClsUtils.setRegionMapRefData(searchOb.relayCode, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
	                //current
	                set<String> years = new set<String>();
	                set<Integer> months = new set<Integer>();
	                    
	                APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
	
	                list<String> list_sql = new list<String>();
	                    
	                list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
	                list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
	                list_sql.add(' WHERE Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ')
                    		+ ' And Customer__r.APL_AM_forecast_Plan_Account__c = ' + (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ')	
							+ ' And Customer__r.STATDESC__c = \'Active\' '
							+ ClsAPLForecastUtil.getRelayCBCFilter(searchOb.gplId)
		                    + ' And Part__r.PRODUCT_CDE__c = \'' + searchOb.relayCode + '\' '
		    				+ ' And Fiscal_Year__c IN : years '
		                    + ' And Fiscal_Month__c  IN : months '
							+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0)  '
							//update by nelson zheng 2015-10-21 for case 00900375
                        	//+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c =  \'RPA\' '
                        	+ ' And Profit_Center__c =  \'APL\' '
		    				+ ' Group by Fiscal_Date__c  ' );
					System.debug('------APL_ClsRSMGroupingForecastService.cls (26 matches) 1-----');
	                APL_ClsUtils.setRegionMapRefData(searchOb.relayCode, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
	            }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.relayCode;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
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
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount, Customer_Request_Date_Fiscal_Date__c refdate ');
    				list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
					list_sql.add(' WHERE Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ')
                    		+ ' And Customer__r.APL_AM_forecast_Plan_Account__c = ' + (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ')	
							+ ' And Customer__r.STATDESC__c = \'Active\' '
							+ ClsAPLForecastUtil.getRelayCBCFilter(searchOb.gplId)
	                    	+ ' And Part__r.PRODUCT_CDE__c = \'' + searchOb.relayCode + '\' '
		    				+ ' And Customer_Request_Date_Fiscal_Year__c IN : years '
		                    + ' And Customer_Request_Date_Fiscal_Month__c  IN : months '
							+ ' And Backlog_Amount_USD__c != 0 '
							+ ' And Profit_Center__c IN (\'APL\', \'RPA\') '
		    				+ ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
	                APL_ClsUtils.setRegionMapRefData(searchOb.relayCode, years, months, null, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.relayCode;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
            
        }
		
	}
	
	public class SearchLevel6 extends APL_Interface.AAPLRemoteService {
		public override String getExistResult(String sData){
			APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb:'+searchOb);
            list<APL_ClsEntityType.RSMAccountObj> list_accFC = new list<APL_ClsEntityType.RSMAccountObj>();
            
            list<String> list_sql = new list<String>();
        	list<String> set_tempqy = new list<String>();
        	list_sql.add(' Fiscal_Year__c year, Fiscal_Quarter__c quarter, Part__c partId, Part__r.Description__c partDesc, Part__r.Name partName, ' //Part__r.Product_Hierarchy__c gplId , 
	        		+ ' sum(RSM_Forecast__c) fc, sum(Current_month_1_forecast__c) prevFC, sum(Forecast__c) amFC, '
	        		+ ' sum(RSM_Quantity__c) quantity, sum(Current_month_1_RSM_quantity__c) preQuantity, avg(RSM_Price__c) price, avg(Current_month_1_RSM_price__c) prePrice ');
	        list_sql.add(' APL_Sales_Forecast__c ');
	        list_sql.add(' WHERE Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
                    + ' And Customer__r.APL_AM_forecast_Plan_Account__c = ' + (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ')
			        + ' And Customer__r.STATDESC__c = \'Active\' '
			        + ClsAPLServiceRSMRelay.getRelayPartSearchQueryFilter(searchOb.accnumber, true)
			        + ' And Part__r.PRODUCT_CDE__c = \'' + searchOb.relayCode + '\' '
			        + ClsAPLForecastUtil.getMonthFilter(searchOb.map_year_quartersFuture)
			        + ' And Type__c = \'' + APL_ClsUtils.RELAYFCTYPE + '\' '  
			        + ' Group by Part__c, Fiscal_Year__c, Fiscal_Quarter__c, Part__r.Description__c, Part__r.Name '); //, Part__r.Product_Hierarchy__c 
			system.debug('!@#sql :　'+APL_ClsUtils.getQueryString(list_sql));
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
                list_sql.add(' Part__c , RSM_Price__c  ');
                list_sql.add(' APL_Sales_Forecast__c ');
                list_sql.add(' WHERE Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
                    + ' And Customer__r.APL_AM_forecast_Plan_Account__c = ' + (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ')
			        + ' And Customer__r.STATDESC__c = \'Active\' '
			        + ClsAPLServiceRSMRelay.getRelayPartSearchQueryFilter(searchOb.accnumber, true)
			        + ' And Part__r.PRODUCT_CDE__c = \'' + searchOb.relayCode + '\' '
			        + ' And Type__c = \'' + APL_ClsUtils.RELAYFCTYPE + '\' '  
                    + ' And Fiscal_Year__c = \''+set_tempqy.get(0)+'\' '
                    + ' And Fiscal_Quarter__c = \''+set_tempqy.get(1)+'\' ');
                for(APL_Sales_Forecast__c result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
                    String accId = result.Part__c;
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
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
                    + ' And Customer__r.APL_AM_forecast_Plan_Account__c = ' + (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ')
	                    	+ ' And Customer__r.STATDESC__c = \'Active\' '
	                    	//+ ' And Part__r.PRODUCT_CDE__c = \'' + searchOb.accnumber + '\' '
	                    	+ ClsAPLForecastUtil.getRelayCBCFilter(searchOb.accnumber)
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
	                System.debug('------APL_ClsRSMGroupingForecastService.cls (26 matches) 2-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.partId, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
	                //current
	                set<String> years = new set<String>();
	                set<Integer> months = new set<Integer>();
	                    
	                APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
	
	                list<String> list_sql = new list<String>();
	                    
	                list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
	                list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
	            	list_sql.add(' WHERE Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
                    + ' And Customer__r.APL_AM_forecast_Plan_Account__c = ' + (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ')
							+ ' And Customer__r.STATDESC__c = \'Active\' '
							//+ ' And Part__r.PRODUCT_CDE__c = \'' + searchOb.accnumber + '\' '
							+ ClsAPLForecastUtil.getRelayCBCFilter(searchOb.accnumber)
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
	    				
	                System.debug('------APL_ClsRSMGroupingForecastService.cls (26 matches) 3-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.partId, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
	            }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.partId;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
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
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount, Customer_Request_Date_Fiscal_Date__c refdate ');
    				list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
					list_sql.add(' WHERE Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ') 
                    + ' And Customer__r.APL_AM_forecast_Plan_Account__c = ' + (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ')
						+ ' And Customer__r.STATDESC__c = \'Active\' '
						//+ ' And Part__r.PRODUCT_CDE__c = \'' + searchOb.accnumber + '\' '
						+ ClsAPLForecastUtil.getRelayCBCFilter(searchOb.accnumber)
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
	                System.debug('------APL_ClsRSMGroupingForecastService.cls (26 matches) 4-----');
                    APL_ClsUtils.setRegionMapRefData(searchOb.partId, years, months, null, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.partId;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
            
        }
	}
	
	public class SearchLevelOther extends APL_Interface.AAPLRemoteService {
		
		
		public override String getExistResult(String sData){
            APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb:'+searchOb);
            integer maxmonths = 1;
            for(APL_Forecast_Settings__c setting : [select Id, Value__c from APL_Forecast_Settings__c where Name = 'Search Other BU Billing Months']) {
            	if(setting.Value__c != null) {
            		try{
            			maxmonths = Integer.valueOf(setting.Value__c);
            		}catch(Exception ex) { }
            	}
            }
            maxmonths = 0 - maxmonths;
            
			list<Date> list_beforedate = new list<Date>();
            Date currentDate = APL_ClsUtils.getCurrentFiscalDate().addMonths(-1);
            for(integer i = 0; i > maxmonths; i--) {
            	Date tempdate = currentDate.addMonths(i);
            	list_beforedate.add(tempdate);
            }
            
            set<String> years = new set<String>();
            set<Integer> months = new set<Integer>();
            
            APL_ClsUtils.setRefForecastDate(years, months, list_beforedate);

            set<String> set_acctIds = new set<String>();
            ClsAPLForecastUtil.setAccountIds(true, searchOb.grouping, searchOb.territoryCode, set_acctIds);
                                               
	        list<String> list_sql = new list<String>();
	        list_sql.add(' Part__r.Product_Hierarchy__r.CBC1__c cbc1Code, Part__r.Product_Hierarchy__r.CBC1_Description__c cbc1disc ');
	        list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
	        
	        list_sql.add(' WHERE Customer__r.APL_AM_forecast_Plan_Account__c = ' 
						+ (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ') 
						+ ' And Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ')
	                    + ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\'', '')             
	                    + ' And Fiscal_Year__c IN : years '
	                    + ' And Fiscal_Month__c IN : months '
	                    + ' And Profit_Center__c = \'APL\' '
	                    + ' And Customer__r.STATDESC__c = \'Active\' '
	                    + ' And Part__r.Product_Hierarchy__r.CBC1__c != \'30007\' '
	                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
	                    + ' Group by Part__r.Product_Hierarchy__r.CBC1__c, Part__r.Product_Hierarchy__r.CBC1_Description__c ' );

			map<String, APL_ClsEntityType.RSMAccountObj> map_acctId_acctFC = new map<String, APL_ClsEntityType.RSMAccountObj>();
			for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
	    		String accId = (String) result.get('cbc1Code');

				APL_ClsEntityType.RSMAccountObj acctFC = new APL_ClsEntityType.RSMAccountObj();
	            
	            if(!map_acctId_acctFC.containsKey(accId)) {
	        		APL_ClsUtils.createRSMRelayAccountObj(acctFC, searchOb.map_year_quartersFuture);
	        		acctFC.id = APL_ClsUtils.getHexUID();
		            acctFC.name = '[ '+accId  + ' ] - ' + (String) result.get('cbc1disc');
					acctFC.accnumber = accId;
					acctFC.price = 0;
		            map_acctId_acctFC.put(accId, acctFC);
	            }
            }
            /*
            APL_ClsEntityType.RSMAccountObj acctFC1 = new APL_ClsEntityType.RSMAccountObj();
            APL_ClsUtils.createRSMRelayAccountObj(acctFC1, searchOb.map_year_quartersFuture);
    		acctFC1.id = APL_ClsUtils.getHexUID();
            acctFC1.name = '[ 10011 ] - Application Tooling';
			acctFC1.accnumber = '10011';
			acctFC1.price = 0;
            map_acctId_acctFC.put('10011', acctFC1);
            
            APL_ClsEntityType.RSMAccountObj acctFC2 = new APL_ClsEntityType.RSMAccountObj();
            APL_ClsUtils.createRSMRelayAccountObj(acctFC2, searchOb.map_year_quartersFuture);
    		acctFC2.id = APL_ClsUtils.getHexUID();
            acctFC2.name = '[ 13003 ] - Telecom LTE';
			acctFC2.accnumber = '13003';
			acctFC2.price = 0;
            map_acctId_acctFC.put('13003', acctFC2);
            */
			list<APL_ClsEntityType.RSMAccountObj> list_accFC = new list<APL_ClsEntityType.RSMAccountObj>();
			list_accFC.addAll(map_acctId_acctFC.values());
	    	system.debug('@#list_accFC:'+list_accFC);
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
                Date currentdate = APL_ClsUtils.getCurrentFiscalDate();
                
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_currentdate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
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
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.APL_AM_forecast_Plan_Account__c = ' 
							+ (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ') 
							+ ' And Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ')
	                    	+ ' And Customer__r.STATDESC__c = \'Active\' '
	                    	+ ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\'', '')
							+ ' And Part__r.Product_Hierarchy__r.CBC1__c = \'' + searchOb.accnumber + '\' '
	                    	+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
				    		+ ' And Profit_Center__c = \'APL\' '
	                        + ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
	                        + ' Group by Fiscal_Date__c ');
                    APL_ClsUtils.setRegionMapRefData(searchOb.accnumber, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
	                //current
	                set<String> years = new set<String>();
	                set<Integer> months = new set<Integer>();
	                    
	                APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
	
	                list<String> list_sql = new list<String>();
	                    
	                list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
	                list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
	                list_sql.add(' WHERE  Customer__r.APL_AM_forecast_Plan_Account__c = ' 
							+ (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ') 
							+ ' And Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ')
	                    	+ ' And Customer__r.STATDESC__c = \'Active\' '
	                    	+ ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\'', '')
							+ ' And Part__r.Product_Hierarchy__r.CBC1__c = \'' + searchOb.accnumber + '\' '
	                    	+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
				    		+ ' And Profit_Center__c = \'APL\' '
	                        + ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
	                        + ' Group by Fiscal_Date__c ');
	
	                APL_ClsUtils.setRegionMapRefData(searchOb.accnumber, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
	            }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.accnumber;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
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
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount, Customer_Request_Date_Fiscal_Date__c refdate ');
    				list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
					list_sql.add(' WHERE  Customer__r.APL_AM_forecast_Plan_Account__c = ' 
							+ (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ') 
							+ ' And Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ')
						+ ' And Customer__r.STATDESC__c = \'Active\' '
						+ ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\'', '') 
						+ ' And Part__r.Product_Hierarchy__r.CBC1__c = \'' + searchOb.accnumber + '\' '
	    				+ ' And Customer_Request_Date_Fiscal_Year__c IN : years '
	                    + ' And Customer_Request_Date_Fiscal_Month__c  IN : months '
						+ ' And Backlog_Amount_USD__c != 0 '
						+ ' And Profit_Center__c IN (\'APL\', \'RPA\') '
	    				+ ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
	                APL_ClsUtils.setRegionMapRefData(searchOb.accnumber, years, months, null, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.accnumber;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
            
        }

	}
	
}