/**
 *	Batch class used for Restatement calculation.
 *
 @author Bin Yuan
 @created 2013-11-27
 @version 1.0
 @since 28.0 (Force.com ApiVersion)
 *
 @changelog
 * 2013-11-27 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created
 */
global class ClsBatch_FinancialplanningRestatement implements Database.Batchable<SObject>, Database.stateful{  
   
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	//global map<String, map<String,map<Integer, map<Decimal, Decimal>>>> map_gsm_rate = new map<String, map<String,map<Integer, map<Decimal, Decimal>>>>();
	global map<String, map<String, map<Integer, RestatementItem>>> map_gsmKey_year_month_restItem;
	global map<String, set<String>> map_pfCtrRegionKey_gsmKey;
	global list<String> list_regions;
	public String region;
	public String query = '';
	public String currentYear = '';
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	/////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
   /**
	* The contsructor
	*
	@author Bin Yuan
	@created 2013-11-27
	@version 1.0
	@since 28.0 (Force.com ApiVersion)
	*
	@changelog
	* 2013-11-27 Bin Yuan <bin.yuan@itbconsult.com>
	* - Created
	*/
	global ClsBatch_FinancialplanningRestatement(){
        for (Period period : [select Id, FiscalYearSettings.Name, PeriodLabel from Period where StartDate<=Today and EndDate >=Today and Type = 'Month']) {
            if(period.FiscalYearSettings.Name != null){
                currentYear = period.FiscalYearSettings.Name;
            }
        }
		//get all regions from forecast definition and build gsm related map
		if(list_regions == null) {
			set<String> set_tempRegion = new set<String>();
			list_regions = new list<String>();
			
			map_gsmKey_year_month_restItem = new map<String, map<String, map<Integer, RestatementItem>>>();
			map_pfCtrRegionKey_gsmKey = new map<String, set<String>>();
			
			for(Forecast_Definition__c fd : [Select Id, Profit_Center__c, Region__c, GSM_Name__c, GSM__c, Profit_Center_Region__c 
											 From Forecast_Definition__c]) {
				String gsmKey = fd.GSM__c + '_' + fd.GSM_Name__c;
				if(!set_tempRegion.contains(fd.Region__c)) {
					set_tempRegion.add(fd.Region__c);
				}
				if(!map_gsmKey_year_month_restItem.containsKey(gsmKey)) {
					map_gsmKey_year_month_restItem.put(gsmKey, new map<String, map<Integer, RestatementItem>>());
				}
				if(!map_pfCtrRegionKey_gsmKey.containsKey(fd.Profit_Center_Region__c)) {
					map_pfCtrRegionKey_gsmKey.put(fd.Profit_Center_Region__c, new set<String>());
				}
				map_pfCtrRegionKey_gsmKey.get(fd.Profit_Center_Region__c).add(gsmKey);
			}
			list_regions.addAll(set_tempRegion);
		}
		
		region = (list_regions.isEmpty() ? '' : list_regions[0]);
	  	// repeat run batch by region
	}
	/////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
	global Database.QueryLocator start(Database.BatchableContext BC){ 
		query = 'Select id, Fiscal_Year__c, Fiscal_Month__c, Forecast_USD__c, forecast_Definition__r.Profit_Center__c, ' +
				' 		Forecast_Definition__r.Region__c, Fiscal_Date__c, Forecast_Definition__r.Profit_Center_Region__c,  '+
				' 		Forecast_Definition__r.GSM__c, Forecast_Definition__r.GSM_Name__c  '+
				' From Manager_Forecast__c '+
				' Where forecast_Definition__r.Profit_Center__c != null '+
				' and Forecast_Definition__r.Region__c = \'' + region + '\'' + 
				' and Forecast_Definition__c != null ' +
				' and Fiscal_Year__c >= \''+ currentYear +'\' ' + 
				' and Fiscal_Year__c != null and Fiscal_Month__c != null ';
		system.debug('query:::'+query);
	 	return Database.getQueryLocator(query);  
	}
	 
	global void execute(Database.BatchableContext BC, List<Manager_Forecast__c> scope){
		String bbbMQuery = '';
		set<String> set_profitCtrs = new set<String>();  
		//set<Integer> set_month = new set<Integer>();
		map<String, set<Integer>> map_financialMonth = new map<String, set<Integer>>();
		map<String, map<Integer, map<String, Manager_Forecast__c>>> map_year_month_profitCtr_managerFC = new map<String, map<Integer, map<String, Manager_Forecast__c>>>();
		list<Manager_Forecast__c> list_managerFC2Update = new list<Manager_Forecast__c>();
		
		for(Manager_Forecast__c mf : scope) {
			String year = mf.Fiscal_Year__c;
			Integer month = Integer.valueOf(mf.Fiscal_Month__c);
			String profitCtr = mf.forecast_Definition__r.Profit_Center__c;
			String region = mf.Forecast_Definition__r.Region__c;
			String profitCtr_region = mf.Forecast_Definition__r.Profit_Center_Region__c;
			String gsmKey = mf.Forecast_Definition__r.GSM__c + '-' + mf.Forecast_Definition__r.GSM_Name__c;
			
			//set_month.add(month);
			set_profitCtrs.add(profitCtr);
			if(!map_financialMonth.containsKey(year)) {
				map_financialMonth.put(year, new set<Integer>());
			}
			map_financialMonth.get(year).add(month);
			
			if(!map_year_month_profitCtr_managerFC.containsKey(year)) {
				map_year_month_profitCtr_managerFC.put(year, new map<Integer, map<String, Manager_Forecast__c>>());
			}
			if(!map_year_month_profitCtr_managerFC.get(year).containsKey(month)) {
				map_year_month_profitCtr_managerFC.get(year).put(month, new map<String, Manager_Forecast__c>());
			}
			if(!map_year_month_profitCtr_managerFC.get(year).get(month).containsKey(mf.forecast_Definition__r.Profit_Center__c)) {
				map_year_month_profitCtr_managerFC.get(year).get(month).put(mf.forecast_Definition__r.Profit_Center__c, mf);
			}
		}
		if(region == '' || map_financialMonth.isEmpty() || set_profitCtrs.isEmpty()) {
			return;
		}
	 	// get BBB by region and related profit centers in scope and date
	 	String str_monthFilter = CtrlAccountForecastUtil.buildMonthFilter(map_financialMonth);
	 	
	 	bbbMQuery =  ' Select sum(Forecast__c) fc , sum(Forecast_Previous_in_USD__c) fcprev, Fiscal_date__c fdate, ';
	 	bbbMQuery += '       IND_Profit_Centre_Groups__c center, Customer__r.IND_Billing_Region__c region ';
	 	bbbMQuery += ' From BBB_Month_Bill_Book_Cust__c ';
	 	bbbMQuery += ' where IND_Profit_Centre_Groups__c in: set_profitCtrs ';
	 	bbbMQuery += ' and Customer__r.IND_Billing_Region__c =: region ';
	 	bbbMQuery += ' and Monthly_BBB_External_Key__c != null ';
	 	bbbMQuery += (str_monthFilter == '' ? '' : ' And ' + str_monthFilter);
	 	bbbMQuery += ' group by Customer__r.IND_Billing_Region__c, IND_Profit_Centre_Groups__c, Fiscal_date__c ';
	 	
	 	system.debug('  bbbMQuery :: ' + bbbMQuery);
	 	for(AggregateResult result : database.query(bbbMQuery)) {
	 		Date fiscalDate = date.valueOf(result.get('fdate'));
			String year = String.valueOf(fiscalDate.year());
			Integer month = Integer.valueOf(fiscalDate.month());
			String profitCtr = String.valueOf(result.get('center'));
			String region = String.valueOf('region');
			String profitCtr_region = profitCtr + '_' + region;
			
			double newFC = double.valueOf((result.get('fc') == null ? 0 : result.get('fc')));
			double oldFC = double.valueOf((result.get('fcprev') == null ? 0 : result.get('fcprev')));
			double rate = (oldFC == 0 ? 1 : (newFC / oldFC));
			
			if(map_year_month_profitCtr_managerFC.containsKey(year) && map_year_month_profitCtr_managerFC.get(year).containsKey(month) && map_year_month_profitCtr_managerFC.get(year).get(month).containsKey(profitCtr)) {
				Manager_Forecast__c mf = map_year_month_profitCtr_managerFC.get(year).get(month).get(profitCtr);
				mf.Forecast_USD__c = (mf.Forecast_USD__c * rate);
				list_managerFC2Update.add(mf);
				if(map_pfCtrRegionKey_gsmKey.containsKey(profitCtr_region)) {
					for(String gsmKey : map_pfCtrRegionKey_gsmKey.get(profitCtr_region)) {
						if(!map_gsmKey_year_month_restItem.containsKey(gsmKey)) {
							map_gsmKey_year_month_restItem.put(gsmKey, new map<String, map<Integer, RestatementItem>>());
						}
						if(!map_gsmKey_year_month_restItem.get(gsmKey).containsKey(year)) {
							map_gsmKey_year_month_restItem.get(gsmKey).put(year, new map<Integer, RestatementItem>());
						}
						if(!map_gsmKey_year_month_restItem.get(gsmKey).get(year).containsKey(month)) {
							map_gsmKey_year_month_restItem.get(gsmKey).get(year).put(month, new RestatementItem());
						}
						RestatementItem item = map_gsmKey_year_month_restItem.get(gsmKey).get(year).get(month);
						item.newFC += newFC;
						item.oldFC += oldFC;
					}
				}
				
			}
	 	}
	 	
	 	
	 	// update scope base on rate above
	 	if(!list_managerFC2Update.isEmpty()) {
		 	database.update(list_managerFC2Update);
	 	}
	 	// save the rate for GSM in map map_gsm_rate
	}
	 
	global void finish(Database.BatchableContext BC){ 
	 	//remove the region in set and continue with other region
	 	list_regions.remove(0);
	 	if(list_regions.size() > 0) {
	 		ClsBatch_FinancialplanningRestatement batch = new ClsBatch_FinancialplanningRestatement();
	 		batch.map_gsmKey_year_month_restItem = map_gsmKey_year_month_restItem;
	 		batch.map_pfCtrRegionKey_gsmKey = map_pfCtrRegionKey_gsmKey;
	 		batch.list_regions = list_regions;
	 		batch.region = list_regions[0];
	 		database.executebatch(batch);
	 		//batch.currentYear = 
	 	}
	 	else {
	 		ClsBatch_GSMRestatement gsmBatch = new ClsBatch_GSMRestatement(map_gsmKey_year_month_restItem, map_pfCtrRegionKey_gsmKey);
	 		if(!test.isRunningTest()){
	 			database.executebatch(gsmBatch);
	 		}
	 	}
	 	// if no region left, continue with GSM map_gsm_rate
	}
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
    global class RestatementItem {
    	global double newFC {get; set;}
    	global double oldFC {get; set;}
    	global RestatementItem() {
    		newFC = 0;
    		oldFC = 0;
    	} 
    }
	///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************

}