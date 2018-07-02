/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   A controller class for show Opportunity_Forecast__c records, Monthly_Target__c records
			   and Month_Forecast__c records in CtrlOppyMonthlyFCSummary.page.
			   The user story number is W-00146.
Inputs:        
Test Class:    CtrlOppyMonthlyFCSummaryTest.cls
History
2017-07-31 	Yiming Shen <yiming.shen@capgemini.com> Created
------------------------------------------------------------*/
public with sharing class CtrlOppyMonthlyFCSummary {
//====================================Public Members=========================================================
	public string selectedMonthLabel {get;set;}
	//Opportunity Table Part Start
    public List<list<MonthlyForcecastWrapper>> list_ListOpportunityForecastWrappers {get;set;}
	public String json_MonthlyOppyForecasts2Save {get;set;}
	public MonthlyForcecastWrapper mfcFooterTotal {get;set;}
	public MonthlyForcecastWrapper mfcFooterForecastInputTotal {get;set;}
	public string forecastInputValue {get;set;}
	public String iframeURL {get;set;}
	//Opportunity Table Part End
    //Month Picklist Part Start 
	public list<SelectOptionWraper> list_ddl_months {get;set;}
	public Integer currentFiscalMonth {get;set;}
	public string selectedMonthValue {get;set;}
	//Month Picklist Part End 
	//Territory Picklist Part Start
	public list<SelectOption> list_pickValsLevel7 {get;set;} 
    public list<SelectOption> list_pickValsLevel6 {get;set;} 
    public list<SelectOption> list_pickValsLevel5 {get;set;} 
    public list<SelectOption> list_pickValsLevel4 {get;set;} 
    public String selectedTerritoryName {get;set;}
    public String selectedTerritoryLevel {get;set;}
    //Territory Picklist Part End
	//Chart Part Start
	public List<String> list_ChartFiscalMonthLabels {get;set;}
	public decimal firstMonthTargetValue {get;set;}
	public decimal secondMonthTargetValue {get;set;}
	public decimal thirdMonthTargetValue {get;set;}
	public decimal currentQuarterTargetValue {get;set;}
	
	public decimal firstMonthActualBookingValue {get;set;}
	public decimal secondMonthActualBookingValue {get;set;}
	public decimal thirdMonthActualBookingValue {get;set;}
	public decimal currentQuarterActualBookingValue {get;set;}
	
	public decimal firstMonthDeltaBookingValue {get;set;}
	public decimal secondMonthDeltaBookingValue {get;set;}
	public decimal thirdMonthDeltaBookingValue {get;set;}
	public decimal currentQuarterDeltaBookingValue {get;set;}
	//Chart Part End
	public static final map<String, Integer> map_MonthAbbr_MonthNumber = new map<String, Integer>{
        'Jan' => 4,
        'Feb' => 5,
        'Mar' => 6,
        'Apr' => 7,
        'May' => 8,
        'Jun' => 9,
        'Jul' => 10,
        'Aug' => 11,
        'Sep' => 12,
        'Oct' => 1,
        'Nov' => 2,
        'Dec' => 3
    };
	
	public static final map<Integer,String> map_MonthNumber_MonthName = new map<Integer, String>{
        1 => 'October',
        2 => 'November',
        3 => 'December',
        4 => 'January',
        5 => 'February',
        6 => 'March',
        7 => 'April',
        8 => 'May',
        9 => 'June',
        10 => 'July',
        11 => 'August',
        12 => 'September'
    };
    public Integer currentFiscalYear;
//==========================================Private Members===================================================	
	private static Integer NumberOfNextFiscalMonth = 3;
	private static Integer MaxMonthNum = 12 ;
	private Period currentFiscalQuarterPeriod;
	private set<Id> set_oppyIds;
	private set<Id> set_acctIds;
	private map<Integer,set<string>> map_month_set_level {get;set;}
	private map<string,string> map_month_year;
	private Map<Integer,String> map_FiscalMonthNum_FiscalMonthAbbrs;
	private static set<string> set_first_monthLevel = new set<string>{
		'100',
		'90',
		'80',
		'60'
	};
	
	private static set<string> set_second_monthLevel = new set<string>{
		'100',
		'90',
		'80',
		'60',
		'30'
	};
	
	private static set<string> set_third_monthLevel = new set<string>{
		'100',
		'90',
		'80',
		'60',
		'30',
		'10'
	};
	
//==========================================Constructor==================================================
	public CtrlOppyMonthlyFCSummary(){
		map_month_year = new map<string,string>();
		list_ListOpportunityForecastWrappers = new List<list<MonthlyForcecastWrapper>>();
		mfcFooterTotal = new MonthlyForcecastWrapper();
		mfcFooterForecastInputTotal = new MonthlyForcecastWrapper();
		list_ddl_months = new list<SelectOptionWraper>();
		set_oppyIds = new set<Id>();
		set_acctIds = new set<Id>();
		map_month_set_level = new map<Integer,set<string>>();
		list_ChartFiscalMonthLabels = new List<String>();
		map_FiscalMonthNum_FiscalMonthAbbrs = new Map<Integer,String>();
		
		getTerritoryPicklistValues();
		GetFiscalMonthsAndFiscalYears();
		selectedMonthLabel = map_MonthNumber_MonthName.get(currentFiscalMonth);
		selectedMonthValue = string.valueOf(currentFiscalMonth);
		GetAccountsByCurrentUser();
		GetOpportunityByAccounts(set_acctIds);	
		CalculateOppyForecastSummaryByLevelAndMonth();
	}
	
	/*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to get territory picklist from Sales_Hierarchy__c which Level Assigned Users contain the current user.
	Inputs:        
	Returns:       
	History
	2017-07-31 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
	public void getTerritoryPicklistValues(){
    	list_pickValsLevel7 = new List<SelectOption>();
		list_pickValsLevel6 = new List<SelectOption>();
    	list_pickValsLevel5 = new List<SelectOption>();
    	list_pickValsLevel4 = new List<SelectOption>();
    	Set<String> set_TerritoryNames = new Set<String>();
		for(sales_hierarchy__c s :[Select Level_7_Territory_Name__c,Level_7_Territory_Code__c
									from sales_hierarchy__c 
									where Level_7_Assigned_Users__c like :UserInfo.getUserId() + '%' 
									order by LastModifiedDate desc]){
			if(!set_TerritoryNames.contains(s.Level_7_Territory_Name__c)){
				if(String.isBlank(selectedTerritoryName)){
					selectedTerritoryName = s.Level_7_Territory_Name__c;
					selectedTerritoryLevel = '7'+s.Level_7_Territory_Code__c;
				}
				list_pickValsLevel7.add(new SelectOption('7'+s.Level_7_Territory_Code__c, s.Level_7_Territory_Name__c));
				set_TerritoryNames.add(s.Level_7_Territory_Name__c);
			}
		}
		set_TerritoryNames.clear();
		for(sales_hierarchy__c s :[Select Level_6_Territory_Name__c,Level_6_Territory_Code__c
									from sales_hierarchy__c 
									where Level_6_Assigned_Users__c like :UserInfo.getUserId() + '%' 
									order by LastModifiedDate desc]){
			if(!set_TerritoryNames.contains(s.Level_6_Territory_Name__c)){
				if(String.isBlank(selectedTerritoryName)){
					selectedTerritoryName = s.Level_6_Territory_Name__c;
					selectedTerritoryLevel = '6'+s.Level_6_Territory_Code__c;
				}
				list_pickValsLevel6.add(new SelectOption('6'+s.Level_6_Territory_Code__c,s.Level_6_Territory_Name__c));
				set_TerritoryNames.add(s.Level_6_Territory_Name__c);
			}
		}
		set_TerritoryNames.clear();
		for(sales_hierarchy__c s :[Select Level_5_Territory_Name__c ,Level_5_Territory_Code__c
									from sales_hierarchy__c 
									where Level_5_Assigned_Users__c like :UserInfo.getUserId() + '%' 
									order by LastModifiedDate desc]){
			if(!set_TerritoryNames.contains(s.Level_5_Territory_Name__c)){
				if(String.isBlank(selectedTerritoryName)){
					selectedTerritoryName = s.Level_5_Territory_Name__c;
					selectedTerritoryLevel = '5'+s.Level_5_Territory_Code__c;
				}
				list_pickValsLevel5.add(new SelectOption('5'+s.Level_5_Territory_Code__c,s.Level_5_Territory_Name__c));
				set_TerritoryNames.add(s.Level_5_Territory_Name__c);
			}
		} 
		set_TerritoryNames.clear();
		for(sales_hierarchy__c s :[Select Level_4_Territory_Name__c ,Level_4_Territory_Code__c
									from sales_hierarchy__c 
									where Level_4_Assigned_Users__c like :UserInfo.getUserId() + '%' 
									order by LastModifiedDate desc]){
			if(!set_TerritoryNames.contains(s.Level_4_Territory_Name__c)){
				if(String.isBlank(selectedTerritoryName)){
					selectedTerritoryName = s.Level_4_Territory_Name__c;
					selectedTerritoryLevel = '4'+s.Level_4_Territory_Code__c;
				}
				list_pickValsLevel4.add(new SelectOption('4'+s.Level_4_Territory_Code__c,s.Level_4_Territory_Name__c));
				set_TerritoryNames.add(s.Level_4_Territory_Name__c);
			}
		} 
		set_TerritoryNames.clear();
    }
    
    /*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to get Account Ids which Owner is the current user.
	Inputs:        
	Returns:       
	History
	2017-07-31 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
	public void GetAccountsByCurrentUser(){
	    for(Account acct :[select Id,OwnerId from Account Where OwnerId =: UserInfo.getUserId()]){
			set_acctIds.add(acct.Id);
		}
	}
	
	/*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to get Opportunity Ids from Accounts owner by the current user.
	Inputs:        
	Returns:       
	History
	2017-07-31 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
	public void GetOpportunityByAccounts(set<Id> set_acctIds){
		
		for(Opportunity opp : [select Id,AccountId from Opportunity Where AccountId IN: set_acctIds]){
			set_oppyIds.add(opp.Id);
		}
	}
	
	/*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to get the current fiscal month and fiscal year.
	Inputs:        
	Returns:       
	History
	2017-07-31 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
	public void GetFiscalMonthsAndFiscalYears(){
	    set<string> set_months = new set<string>();
		map<string,string> map_index_month = new map<string,string>();
		
		for(Period currentPeriod : [SELECT EndDate, FiscalYearSettings.Name, Number, Id, PeriodLabel, 
									QuarterLabel, StartDate, Type 
									FROM Period 
									WHERE (Type = 'Year' OR Type = 'Quarter' OR Type = 'Month')  
									AND StartDate <= TODAY
									AND EndDate >= TODAY ]){
			if(currentPeriod.Type == 'Year'){
				currentFiscalYear = Integer.valueOf(currentPeriod.FiscalYearSettings.Name);
			}else if(currentPeriod.Type == 'Month'){
				currentFiscalMonth = map_MonthAbbr_MonthNumber.get(currentPeriod.PeriodLabel);
			}else if(currentPeriod.Type == 'Quarter'){
				currentFiscalQuarterPeriod = currentPeriod;
			}
		}
		System.debug('---currentFiscalQuarterPeriod:::' + currentFiscalQuarterPeriod);
		Integer tempMonth =	currentFiscalMonth;	 
				
		for(Integer i=0;i<NumberOfNextFiscalMonth;i++){
			Integer nextMonth = currentFiscalMonth +i;			
			if(nextMonth > MaxMonthNum){
				set_months.add(string.valueOf(nextMonth-MaxMonthNum));
				tempMonth = nextMonth-MaxMonthNum;
				map_month_year.put(string.valueOf(nextMonth-MaxMonthNum),string.valueOf(currentFiscalYear+1));
				map_index_month.put(string.valueOf(i+1),string.valueOf(nextMonth-MaxMonthNum));
				
			}else{
				set_months.add(string.valueOf(nextMonth));
				map_index_month.put(string.valueOf(i+1),string.valueOf(nextMonth));
				map_month_year.put(string.valueOf(nextMonth),string.valueOf(currentFiscalYear));
				tempMonth = nextMonth;
			}
			
			if(i == 0){
				map_month_set_level.put(tempMonth,set_first_monthLevel);
			}
			
			if(i == 1){
				map_month_set_level.put(tempMonth,set_second_monthLevel);
			}
			
			if(i == 2){
				map_month_set_level.put(tempMonth,set_third_monthLevel);
			}			
			
		}
		
		system.debug('map_month_set_level::'+map_month_set_level);
				
		//init dropdownlist month
		for(string month : set_months){
			SelectOptionWraper sow = new SelectOptionWraper();
			if(month == string.valueOf(currentFiscalMonth)){
				sow.IsCurrent = true;
			}else{
				sow.IsCurrent = false;
			}
			sow.Value = month;
			sow.Text = map_MonthNumber_MonthName.get(integer.valueOf(month));
			list_ddl_months.add(sow);
		}	
	}
	
	/*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to get month forecast value from Month_Forecast__c records.
	Inputs:        
	Returns:       
	History
	2017-07-31 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
	public decimal GetMonthForecastValue(){
		decimal inputvalue = 0;
		String str_selectedFiscalYear = map_month_year.get(selectedMonthValue);
		if(String.isNotBlank(selectedTerritoryLevel)){
			string selectedLevel = selectedTerritoryLevel.substring(0,1);
			string selectedTerrcode = selectedTerritoryLevel.substring(1);
			for(Month_Forecast__c mfc :[select User__c,Year__c,Month__c,Forecast_Override__c from Month_Forecast__c
		                            Where User__c =: UserInfo.getUserId()
		                            AND Year__c =: str_selectedFiscalYear
		                            AND Month__c =: Integer.valueOf(selectedMonthValue)
		                            AND Territory_Level_5_6_or_7__c =: selectedLevel
		                            AND Territory_Code__c =: selectedTerrcode
		                           ]){
				if(mfc.Forecast_Override__c != null){
					inputvalue = mfc.Forecast_Override__c.round(System.RoundingMode.HALF_UP);
				}
			}		
		}
		         
		return inputvalue;
	}	
	
	/*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to save month forecast value.
	Inputs:        
	Returns:       
	History
	2017-07-31 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
	public void SaveMonthFcValue(){
		String str_selectedFiscalYear = map_month_year.get(selectedMonthValue);
		Decimal dec_InputValue = 0;
		if(string.isNotBlank(this.forecastInputValue)){
			dec_InputValue = Decimal.valueOf(this.forecastInputValue.replaceAll(',' , ''));
		}
		List<Month_Forecast__c> list_mfc = new List<Month_Forecast__c>();
		
		if(String.isNotBlank(selectedTerritoryLevel)){
			
			string selectedLevel = selectedTerritoryLevel.substring(0,1);
			string selectedTerrcode = selectedTerritoryLevel.substring(1);
			
			for(Month_Forecast__c mfc :[select User__c,Year__c,Month__c,Forecast_Override__c from Month_Forecast__c
		                             Where User__c =: UserInfo.getUserId()
		                             AND Year__c =: str_selectedFiscalYear
		                             AND Month__c =: Integer.valueOf(selectedMonthValue)
		                             AND Territory_Level_5_6_or_7__c =: selectedLevel
		                             AND Territory_Code__c =: selectedTerrcode
		                             ]){
		               mfc.Forecast_Override__c = dec_InputValue;
		               list_mfc.add(mfc);
		     }
		    try{        
				if(list_mfc.size() > 0){
					update list_mfc;
				}else{			
					Month_Forecast__c new_mfc = new Month_Forecast__c();
					new_mfc.User__c = UserInfo.getUserId();
					new_mfc.Month__c = Integer.valueOf(selectedMonthValue);
					new_mfc.Year__c = str_selectedFiscalYear;
					new_mfc.Forecast_Override__c = dec_InputValue;
					new_mfc.Territory_Code__c = selectedTerrcode;
					new_mfc.Territory_Level_5_6_or_7__c = selectedLevel;
					new_mfc.Territory_Name__c = selectedTerritoryName; 
					insert new_mfc;
				}
			}catch(Exception e){
				String vStrError = 'Error Type = ' + e.getTypeName() + ' Error Line = ' + e.getLineNumber() + '' + ' Error Stack = ' + e.getStackTraceString() + ' Error Message = ' + e.getMessage();
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '', e.getStackTraceString());
				ErrorLogging.Log(e);
			}			
		}
	}
	
	/*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to save opporutnity forecast value.
	Inputs:        
	Returns:       
	History
	2017-07-31 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
	public void saveOpportunityForecastValue(){
		try{
			List<Opportunity_Forecast__c> list_OpportunityForecasts2Update = new List<Opportunity_Forecast__c>();
	    	List<MonthlyForcecastWrapper> list_MonthlyForcecastWrappers = (List<MonthlyForcecastWrapper>)JSON.deserialize(json_MonthlyOppyForecasts2Save, List<MonthlyForcecastWrapper>.class);
			system.debug('---list_MonthlyForcecastWrappers::' + list_MonthlyForcecastWrappers);
			for(MonthlyForcecastWrapper monthlyForcecastWrapper : list_MonthlyForcecastWrappers){
				Opportunity_Forecast__c opportunityForecast2Update = new Opportunity_Forecast__c();
				opportunityForecast2Update.Id = monthlyForcecastWrapper.oppForId;
				opportunityForecast2Update.Amount__c = monthlyForcecastWrapper.FcValue;
				list_OpportunityForecasts2Update.add(opportunityForecast2Update);
			}
			
			if(list_OpportunityForecasts2Update.size() > 0){
				update list_OpportunityForecasts2Update;
			}
			System.debug('---update success:::');
    	}catch(Exception e){
    		System.debug('---e:::'+e.getMessage());
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
    		String vStrError = 'Error Type = ' + e.getTypeName() + ' Error Line = ' + e.getLineNumber() + '' + ' Error Stack = ' + e.getStackTraceString() + ' Error Message = ' + e.getMessage();
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '', e.getStackTraceString());
    		//ErrorLogging.Log(e);
    	}
	}
	
	/*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to get Opporutnity_Forecast__c records group by confidence level and month.
	Inputs:        
	Returns:       
	History
	2017-07-31 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
	public void CalculateOppyForecastSummaryByLevelAndMonth(){
		list_ListOpportunityForecastWrappers.clear();
		String str_selectedFiscalYear = map_month_year.get(selectedMonthValue);
		currentFiscalMonth =  Integer.valueOf(selectedMonthValue);
		system.debug('str_selectedFiscalYear' + str_selectedFiscalYear);
		system.debug('map_month_set_level::' + map_month_set_level);
		populateValueForChart();
		map<string,list<Opportunity_Forecast__c>> map_level_list_oppfc = new map<string,list<Opportunity_Forecast__c>>();
		
		String queryString = 'SELECT Id, Amount__c, Opportunity__c, Confidence_Level__c, Opportunity__r.Name, '
							+'Opportunity__r.AccountId, Opportunity__r.Account.Name, '
							+'Fiscal_Month__c, Fiscal_Year__c, Opportunity__r.Account.Sales_Hierarchy_GAM__c, '
							+'Opportunity__r.Account.Sales_Hierarchy_GAM__r.Name, Opportunity__r.CloseDate '  
							+'FROM Opportunity_Forecast__c ' 
							//+'WHERE (Opportunity__r.Primary_Opportunity__c = null '
							+'WHERE (Opportunity__r.Master_Opportunity__c = null '
							+'OR Opportunity__r.StageName = \'Won\' '
							+'OR Opportunity__r.StageName = \'Won - Prospect\') '
							+'AND Fiscal_Month__c =: selectedMonthValue '
							+'AND Confidence_Level__c != \'0\' '
							+'AND Amount__c > 0 '
							+'AND Fiscal_Year__c =: str_selectedFiscalYear ';
		if(String.isNotBlank(selectedTerritoryLevel)){
			//get the selected terriority level			
			string level = selectedTerritoryLevel.substring(0,1);
			queryString += 'AND Opportunity__r.Territory__r.Level_'+ level +'_Territory_Name__c =: selectedTerritoryName ';
		}else{
			return ;
		}
		queryString += 'order by Confidence_Level__c desc';
		for(Opportunity_Forecast__c opfc : Database.query(queryString)){
			if(!map_level_list_oppfc.containsKey(opfc.Confidence_Level__c)){
			 	map_level_list_oppfc.put(opfc.Confidence_Level__c,new list<Opportunity_Forecast__c>());
			}
			map_level_list_oppfc.get(opfc.Confidence_Level__c).add(opfc);		
	   	}
	   
	    mfcFooterTotal.IsTotal = false;
		mfcFooterTotal.FcValue = 0;
			
		mfcFooterForecastInputTotal.IsTotal = false;
		mfcFooterForecastInputTotal.FcValue = GetMonthForecastValue();
		
		for(string level : map_level_list_oppfc.keySet()){
			System.debug('---level:::' +level);
			List<MonthlyForcecastWrapper> list_month_fc_total = new List<MonthlyForcecastWrapper>();
			MonthlyForcecastWrapper mfcTotal = new MonthlyForcecastWrapper();
			mfcTotal.Level = level;
			mfcTotal.IsTotal = true;
			mfcTotal.FcValue = 0;
			
			list<MonthlyForcecastWrapper> list_month_oppyfc_inner = new list<MonthlyForcecastWrapper>();
			
			for(Opportunity_Forecast__c oppfc : map_level_list_oppfc.get(level)){
				
				decimal opfcval = 0;
				if(oppfc.Amount__c != null){
					opfcval = oppfc.Amount__c;
				}
								
				MonthlyForcecastWrapper mfcinner = new MonthlyForcecastWrapper();
				mfcinner.OppyId = oppfc.Opportunity__c;
				mfcinner.FcValue = opfcval.round(System.RoundingMode.HALF_UP);
				mfcinner.IsTotal = false;
				mfcinner.Level = level;
				mfcinner.AcctName = oppfc.Opportunity__r.Account.Name;
				mfcinner.AcctId = oppfc.Opportunity__r.AccountId;
				mfcinner.oppForId = oppfc.Id;
				mfcinner.OppyName = oppfc.Opportunity__r.Name;
				mfcinner.OppyCloseDate = oppfc.Opportunity__r.CloseDate.format();
				mfcinner.SalesHierarchyName = oppfc.Opportunity__r.Account.Sales_Hierarchy_GAM__r.Name;
				mfcinner.SalesHierarchyId = oppfc.Opportunity__r.Account.Sales_Hierarchy_GAM__c;
				mfcTotal.FcValue += mfcinner.FcValue;
			    list_month_oppyfc_inner.add(mfcinner);
			    					
			}
			mfcTotal.FcValue = mfcTotal.FcValue * (Double.valueOf(level)/100);
			System.debug('---mfcTotal.FcValue:::' + mfcTotal.FcValue);
			//calculate forecast value based on selected month			
			if(map_month_set_level.get(currentFiscalMonth).contains(level)){
				mfcFooterTotal.FcValue += mfcTotal.FcValue;
			}
			System.debug('---mfcFooterTotal.FcValue:::' + mfcFooterTotal.FcValue);
			//list_month_fc_total.add(mfcTotal);											
		    //list_month_fc_total.addAll(list_month_oppyfc_inner);
		    
		    list_month_fc_total.add(mfcTotal);											
			Integer requiredListNumber = list_month_oppyfc_inner.size() / 1000;
			System.debug('---requiredListNumber:::' + requiredListNumber);
	    	list_month_fc_total.addAll(list_month_oppyfc_inner);
			if(requiredListNumber == 0){
		    	System.debug('---list_month_fc_total:::' + list_month_fc_total);
		    	list_ListOpportunityForecastWrappers.add(list_month_fc_total);
			}else{
				for(Integer num = 0; num < requiredListNumber; num++){
					List<MonthlyForcecastWrapper> list_TempOpportunityForecastWrappers = new List<MonthlyForcecastWrapper>();
					if(list_month_fc_total.size() > 0){
						Integer totalNum = (list_month_fc_total.size() > 1000)? 1000 : list_month_fc_total.size();
						for(Integer index = 0; index < totalNum; index++){
							list_TempOpportunityForecastWrappers.add(list_month_fc_total.get(0));
							list_month_fc_total.remove(0);				
						}
						list_ListOpportunityForecastWrappers.add(list_TempOpportunityForecastWrappers);
					}
				}
			}
		}
		
		this.selectedMonthLabel = map_MonthNumber_MonthName.get(Integer.valueOf(selectedMonthValue));
	}
	
	/*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to get actual bookings value and target value of three months.
	Inputs:        
	Returns:       
	History
	2017-07-31 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
	public void populateValueForChart(){
		System.debug('---currentFiscalQuarterPeriod:::' + currentFiscalQuarterPeriod);
		if(currentFiscalQuarterPeriod != null){
			for(Period pMonth :[SELECT EndDate, FiscalYearSettings.Name, Number, Id, PeriodLabel, 
								QuarterLabel, StartDate, Type 
								FROM Period 
								WHERE StartDate >= :currentFiscalQuarterPeriod.StartDate
								AND EndDate <= :currentFiscalQuarterPeriod.EndDate 
								AND Type = 'Month']){
				map_FiscalMonthNum_FiscalMonthAbbrs.put(map_MonthAbbr_MonthNumber.get(pMonth.PeriodLabel), pMonth.PeriodLabel);
			}
			System.debug('---map_FiscalMonthNum_FiscalMonthAbbrs:::' + map_FiscalMonthNum_FiscalMonthAbbrs);
			list_ChartFiscalMonthLabels = map_FiscalMonthNum_FiscalMonthAbbrs.values();
			list_ChartFiscalMonthLabels.add('Q'+currentFiscalQuarterPeriod.Number);
			if(String.isNotBlank(selectedTerritoryLevel)){
				//1.
				getMonthlyBookingTargetsOfCurrentQuarter();
				//2.
				getMonthlyActualBookingsOfCurrentQuarter();
				//3.
				calculateDeltaToBookingsOfCurrentQuarter();
				//4.
				getIframeURL();
			}
		}
	}
	
	/*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to get Booking Target values for fiscal months in the current fiscal quarter.
	Inputs:        
	Returns:       
	History
	2017-07-31 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
	public void getMonthlyBookingTargetsOfCurrentQuarter(){
		firstMonthTargetValue = null;
		secondMonthTargetValue = null;
		thirdMonthTargetValue = null;
		currentQuarterTargetValue = null;
		
		String queryMonthlyTargetStatement = 'SELECT ';
		String theFirstFiscalMonthNum;
		for(String fiscalMonthAbbr: map_FiscalMonthNum_FiscalMonthAbbrs.values()){
			queryMonthlyTargetStatement += fiscalMonthAbbr + '_Target__c, ';
		}
		queryMonthlyTargetStatement += 'Data_Entry_Month__c, Data_Entry_Year__c, Id FROM Monthly_Target__c ';
		for(Integer fiscalMonthNum : map_FiscalMonthNum_FiscalMonthAbbrs.keySet()){
			if(Math.mod(Integer.valueOf(fiscalMonthNum),3) == 1){
				theFirstFiscalMonthNum = String.valueOf(fiscalMonthNum);
			}
		}	
		if(String.isNotBlank(theFirstFiscalMonthNum)){
			queryMonthlyTargetStatement +=	'WHERE Data_Entry_Month__c = ' + theFirstFiscalMonthNum + ' ' + 
											'AND Data_Entry_Year__c = \''+ String.valueOf(currentFiscalYear) + '\' '+
											'AND Territory_Code__c = \'' + selectedTerritoryLevel.subString(1) + '\' '+
											'AND Territory_Level__c = \'' + selectedTerritoryLevel.subString(0,1) + '\' '+
											'order by LastModifiedDate desc ' +
											'limit 1';
			System.debug('---queryMonthlyTargetStatement:::' + queryMonthlyTargetStatement);
			for(Monthly_Target__c monthlyTarget : Database.query(queryMonthlyTargetStatement)){
				System.debug('---monthlyTarget:::' + monthlyTarget);
				firstMonthTargetValue = (decimal)monthlyTarget.get(map_FiscalMonthNum_FiscalMonthAbbrs.get(Integer.valueOf(monthlyTarget.Data_Entry_Month__c)) + '_Target__c');
				secondMonthTargetValue = (decimal)monthlyTarget.get(map_FiscalMonthNum_FiscalMonthAbbrs.get(Integer.valueOf(monthlyTarget.Data_Entry_Month__c) + 1) + '_Target__c');
				thirdMonthTargetValue = (decimal)monthlyTarget.get(map_FiscalMonthNum_FiscalMonthAbbrs.get(Integer.valueOf(monthlyTarget.Data_Entry_Month__c) + 2) + '_Target__c');
			}
		}
		if(secondMonthTargetValue == null){
			secondMonthTargetValue = firstMonthTargetValue;
		}
		if(thirdMonthTargetValue == null){
			thirdMonthTargetValue = secondMonthTargetValue;
		}
		if(firstMonthTargetValue != null
		|| secondMonthTargetValue != null
		|| thirdMonthTargetValue != null){
			currentQuarterTargetValue = 0;
			currentQuarterTargetValue += (firstMonthTargetValue != null)? firstMonthTargetValue : 0;
			currentQuarterTargetValue += (secondMonthTargetValue != null)? secondMonthTargetValue : 0;
			currentQuarterTargetValue += (thirdMonthTargetValue != null)? thirdMonthTargetValue : 0;
		}
	}
	
	/*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to get Actual Booking values for fiscal months in the current fiscal quarter.
	Inputs:        
	Returns:       
	History
	2017-07-31 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
	public void getMonthlyActualBookingsOfCurrentQuarter(){
		firstMonthActualBookingValue = null;
		secondMonthActualBookingValue = null;
		thirdMonthActualBookingValue = null;
		currentQuarterActualBookingValue = null;
		Set<Integer> set_FiscalMonths = map_FiscalMonthNum_FiscalMonthAbbrs.keySet();
		System.debug('---set_FiscalMonths:::' + set_FiscalMonths);
		String queryActualBookingStatement = 'SELECT Book_Amount_USD__c, Fiscal_Month__c '+
											'FROM BBB_Month_Bill_Book_Cust__c '+
											'WHERE Fiscal_Year__c = \''+ String.valueOf(currentFiscalYear) + '\' '+
											'AND Fiscal_Month__c IN: set_FiscalMonths '+
											'AND Book_Amount_USD__c > 0 '+
											'AND Customer__r.Sales_Hierarchy__r.level_'+ selectedTerritoryLevel.subString(0,1) +'_territory_code__c = \'' + selectedTerritoryLevel.subString(1) + '\'';
		System.debug('---queryActualBookingStatement:::' + queryActualBookingStatement);
		for(BBB_Month_Bill_Book_Cust__c monthBook: Database.query(queryActualBookingStatement)){
			if(Math.mod(Integer.valueOf(monthBook.Fiscal_Month__c),3) == 1){
				if(firstMonthActualBookingValue == null){
					firstMonthActualBookingValue = 0;
				}
				firstMonthActualBookingValue += monthBook.Book_Amount_USD__c;
			}else if(Math.mod(Integer.valueOf(monthBook.Fiscal_Month__c),3) == 2){
				if(secondMonthActualBookingValue == null){
					secondMonthActualBookingValue = 0;
				}
				secondMonthActualBookingValue += monthBook.Book_Amount_USD__c;
			}else if(Math.mod(Integer.valueOf(monthBook.Fiscal_Month__c),3) == 0){
				if(thirdMonthActualBookingValue == null){
					thirdMonthActualBookingValue = 0;
				}
				thirdMonthActualBookingValue += monthBook.Book_Amount_USD__c;
			}
		}
		if(firstMonthActualBookingValue != null
		|| secondMonthActualBookingValue != null
		|| thirdMonthActualBookingValue != null){
			currentQuarterActualBookingValue = 0;
			currentQuarterActualBookingValue += (firstMonthActualBookingValue != null)? firstMonthActualBookingValue : 0;
			currentQuarterActualBookingValue += (secondMonthActualBookingValue != null)? secondMonthActualBookingValue : 0;
			currentQuarterActualBookingValue += (thirdMonthActualBookingValue != null)? thirdMonthActualBookingValue : 0;
		}
	}
	
	/*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to calculate the Delta based on the Target - Actual Bookings.
	Inputs:        
	Returns:       
	History
	2017-11-21 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
	public void calculateDeltaToBookingsOfCurrentQuarter(){
		firstMonthDeltaBookingValue = firstMonthTargetValue;
		secondMonthDeltaBookingValue = secondMonthTargetValue;
		thirdMonthDeltaBookingValue = thirdMonthTargetValue;
		if(firstMonthActualBookingValue != null){
			firstMonthDeltaBookingValue = (firstMonthDeltaBookingValue != null)? firstMonthDeltaBookingValue - firstMonthActualBookingValue: -firstMonthActualBookingValue;
		}
		if(secondMonthActualBookingValue != null){
			secondMonthDeltaBookingValue = (secondMonthDeltaBookingValue != null)? secondMonthDeltaBookingValue - secondMonthActualBookingValue: -secondMonthActualBookingValue;
		}
		if(thirdMonthActualBookingValue != null){
			thirdMonthDeltaBookingValue = (thirdMonthDeltaBookingValue != null)? thirdMonthDeltaBookingValue - thirdMonthActualBookingValue: -thirdMonthActualBookingValue;
		}
		if(firstMonthDeltaBookingValue != null
		|| secondMonthDeltaBookingValue != null
		|| thirdMonthDeltaBookingValue != null){ 
			currentQuarterDeltaBookingValue = 0;
			currentQuarterDeltaBookingValue += (firstMonthDeltaBookingValue != null)? firstMonthDeltaBookingValue : 0;
			currentQuarterDeltaBookingValue += (secondMonthDeltaBookingValue != null)? secondMonthDeltaBookingValue : 0;
			currentQuarterDeltaBookingValue += (thirdMonthDeltaBookingValue != null)? thirdMonthDeltaBookingValue : 0;
		}
	}
	
	/*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to get TableauURL__c URL from TableauURL__c custom setting to show the iframe in page.
	Inputs:        
	Returns:       
	History
	2017-07-31 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
	public void getIframeURL(){
		if(String.isBlank(iframeURL) && TableauURL__c.getInstance('Weekly Tracker') != null){
			iframeURL = TableauURL__c.getInstance('Weekly Tracker').value__c;
		} 
		iframeURL+= '&param_choose_level=DD' + selectedTerritoryLevel.subString(0,1) + '&calc_choose_level=' + selectedTerritoryName;
		System.debug('---iframeURL:::' + iframeURL);
	}
	
//==============================================Inner Class============================================================		
	public class MonthlyForcecastWrapper{
		public string Level {get;set;}
		public string OppyName {get;set;}
		public String OppyCloseDate {get;set;}
		public string OppyId {get;set;}
		public decimal FcValue{get;set;}
		public boolean IsTotal {get;set;}		
		public string oppForId {get;set;}
		public string AcctName {get;set;}
		public string AcctId {get;set;}
		public string SalesHierarchyName {get;set;}
		public string SalesHierarchyId {get;set;}
	}
	
	public class SelectOptionWraper{
		public boolean IsCurrent {get;set;}
		public string Text {get;set;}
		public string Value {get;set;}
	}
	
}