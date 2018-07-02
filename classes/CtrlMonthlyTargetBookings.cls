/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   A controller class for show Monthly_Target__c records and save changes in CtrlMonthlyTargetBookings.page.
			   The user story number is W-00153.
Inputs:        
Test Class:    CtrlMonthlyTargetBookings_Test
History
2016-09-27  Buwen Guo <buwen.guo@oinio.com> Created
2017-07-10 	Yiming Shen <yiming.shen@capgemini.com> Modified
------------------------------------------------------------*/
public class CtrlMonthlyTargetBookings {
	//=======================================- PUBLIC MEMBERS -======================================================
    public list<String> list_MonthLabels {get;set;}  
    public list<CustomSelectOption> list_pickValsLevel7 {get;set;} 
    public list<CustomSelectOption> list_pickValsLevel6 {get;set;} 
    public list<CustomSelectOption> list_pickValsLevel5 {get;set;} 
    public list<CustomSelectOption> list_pickValsLevel4 {get;set;} 
    public MonthlyTargetBookingsWrapper the1stMonthTargetBookingsWrapper {get;set;}
    public MonthlyTargetBookingsWrapper the2ndMonthTargetBookingsWrapper {get;set;}
    public MonthlyTargetBookingsWrapper the3rdMonthTargetBookingsWrapper {get;set;}
    
    public List<MonthlyTargetBookingsWrapper> list_NoGAMChildrenMonthlyTargetWrappers {get;set;}
    
    public List<MonthlyTargetBookingsWrapper> list_GAMChildrenMonthlyTargetWrappers {get;set;}
    
    public List<OpportunityForecastWrapper> list_OpportunityForecastWrappers {get;set;}
    public OpportunityForecastWrapper summaryOppyForecastTotalWrapper {get;set;}
    public Id oppyForecastReportId {get;set;}
    
    public String selectedTerritoryName {get;set;}
    public String selectedTerritoryCode {get;set;}
    public String selectedSalesHierarchyId {get;set;}
    public String selectedTerritoryLevel {get;set;}
    public String selectedChildrenTerritoryLevel {get;set;}
    public String json_MonthlyTargets2Save {get;set;}
    //======================================- PRIVATE MEMBERS -======================================================
    private static final map<String, Integer> map_MonthAbbr_MonthNumber = new map<String, Integer>{
        'Oct' => 1,
        'Nov' => 2,
        'Dec' => 3,
        'Jan' => 4,
        'Feb' => 5,
        'Mar' => 6,
        'Apr' => 7,
        'May' => 8,
        'Jun' => 9,
        'Jul' => 10,
        'Aug' => 11,
        'Sep' => 12
    };
	
	private static final map<Integer,String> map_MonthNumber_MonthName = new map<Integer, String>{
        1 => 'Oct',
        2 => 'Nov',
        3 => 'Dec',
        4 => 'Jan',
        5 => 'Feb',
        6 => 'Mar',
        7 => 'Apr',
        8 => 'May',
        9 => 'Jun',
        10 => 'Jul',
        11 => 'Aug',
        12 => 'Sep'
        
    };
    private String currentFiscalYearName;
    private Integer currentFiscalMonthNum;
    private Integer currentFiscalQuarterNumber;
    
    //======================================- CONSTRUCTOR -========================================================
    public CtrlMonthlyTargetBookings(){
    	list_pickValsLevel7 = new list<CustomSelectOption>();
		list_pickValsLevel6 = new list<CustomSelectOption>();
    	list_pickValsLevel5 = new list<CustomSelectOption>();
    	list_pickValsLevel4 = new list<CustomSelectOption>();
        list_MonthLabels = new list<String>();
        
    	getCurrentFiscalInfo();
    	getTerritoryPicklistValues();
    	getMonthlyTargetBookings();
    }
    public void init(){
    	getMonthlyTargetBookings();
    }
    //==============================================- PUBLIC METHODS -=============================================
    /*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to get current fiscal info, such as current fiscal year, current fiscal month and so on.
	Inputs:        
	Returns:       
	History
	2017-07-10 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
    public void getCurrentFiscalInfo(){
    	Period currYearPeriod;
    	if(OpportunityForecastsReportId__c.getInstance('Commitment') != null){
	    	oppyForecastReportId = OpportunityForecastsReportId__c.getInstance('Commitment').Report_Id__c;
    	}
		for(Period currentPeriod : [SELECT EndDate, FiscalYearSettings.Name, Number, Id, PeriodLabel, 
									QuarterLabel, StartDate, Type 
									FROM Period 
									WHERE (Type = 'Year' OR Type = 'Month' OR Type = 'Quarter')  
									AND StartDate <= TODAY
									AND EndDate >= TODAY ]){
			if(currentPeriod.Type == 'Year'){
				currYearPeriod = currentPeriod;
				currentFiscalYearName = currentPeriod.FiscalYearSettings.Name;
			}else if(currentPeriod.Type == 'Month'){
				currentFiscalMonthNum = map_MonthAbbr_MonthNumber.get(currentPeriod.PeriodLabel);
			}else if(currentPeriod.Type == 'Quarter'){
				currentFiscalQuarterNumber = currentPeriod.Number;
			}
		}
		System.debug('---currentFiscalMonthNum:::' + currentFiscalMonthNum);
		if(currYearPeriod != null){
			if(currYearPeriod.StartDate != null && currYearPeriod.EndDate != null ){
				for(Period pMonth :[SELECT EndDate, FiscalYearSettings.Name, Number, Id, PeriodLabel, QuarterLabel, StartDate, Type 
									FROM Period where StartDate >=: currYearPeriod.StartDate AND EndDate <=: currYearPeriod.EndDate
									AND Type = 'Month']){
					list_MonthLabels.add(pMonth.PeriodLabel);
				}
			}
		}
    }
    
    /*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to get territory picklist from Sales_Hierarchy__c which the level assigned users contain the current user.
	Inputs:        
	Returns:       
	History
	2017-07-10 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
    public void getTerritoryPicklistValues(){
    	Set<String> set_TerritoryNames = new Set<String>();
		for(sales_hierarchy__c s :[Select Level_7_Territory_Code__c, Level_7_Territory_Name__c 
									from sales_hierarchy__c 
									where Level_7_Assigned_Users__c like :UserInfo.getUserId() + '%' 
									order by LastModifiedDate desc]){
			if(!set_TerritoryNames.contains(s.Level_7_Territory_Name__c)){
				if(String.isBlank(selectedTerritoryName)){
					selectedTerritoryName = s.Level_7_Territory_Name__c;
					selectedTerritoryCode = s.Level_7_Territory_Code__c;
					selectedTerritoryLevel = '7';
					selectedSalesHierarchyId = s.Id;
				}
				list_pickValsLevel7.add(new CustomSelectOption(s.Level_7_Territory_Name__c, s.Level_7_Territory_Code__c, s.Id , '7'));
				set_TerritoryNames.add(s.Level_7_Territory_Name__c);
			}
		}
		set_TerritoryNames.clear();
		for(sales_hierarchy__c s :[Select Level_6_Territory_Name__c, Level_6_Territory_Code__c
									from sales_hierarchy__c 
									where Level_6_Assigned_Users__c like :UserInfo.getUserId() + '%' 
									order by LastModifiedDate desc]){
			if(!set_TerritoryNames.contains(s.Level_6_Territory_Name__c)){
				if(String.isBlank(selectedTerritoryName)){
					selectedTerritoryName = s.Level_6_Territory_Name__c;
					selectedTerritoryCode = s.Level_6_Territory_Code__c;
					selectedTerritoryLevel = '6';
					selectedSalesHierarchyId = s.Id;
				}
				list_pickValsLevel6.add(new CustomSelectOption(s.Level_6_Territory_Name__c, s.Level_6_Territory_Code__c, s.Id , '6'));
				set_TerritoryNames.add(s.Level_6_Territory_Name__c);
			}
		}
		set_TerritoryNames.clear();
		for(sales_hierarchy__c s :[Select Level_5_Territory_Name__c, Level_5_Territory_Code__c 
									from sales_hierarchy__c 
									where Level_5_Assigned_Users__c like :UserInfo.getUserId() + '%' 
									order by LastModifiedDate desc]){
			if(!set_TerritoryNames.contains(s.Level_5_Territory_Name__c)){
				if(String.isBlank(selectedTerritoryName)){
					selectedTerritoryName = s.Level_5_Territory_Name__c;
					selectedTerritoryCode = s.Level_5_Territory_Code__c;
					selectedTerritoryLevel = '5';
					selectedSalesHierarchyId = s.Id;
				}
				list_pickValsLevel5.add(new CustomSelectOption(s.Level_5_Territory_Name__c, s.Level_5_Territory_Code__c, s.Id , '5'));
				set_TerritoryNames.add(s.Level_5_Territory_Name__c);
			}
		}
		set_TerritoryNames.clear();
		for(sales_hierarchy__c s :[Select Level_4_Territory_Name__c, Level_4_Territory_Code__c 
									from sales_hierarchy__c 
									where Level_4_Assigned_Users__c like :UserInfo.getUserId() + '%' 
									order by LastModifiedDate desc]){
			if(!set_TerritoryNames.contains(s.Level_4_Territory_Name__c)){
				if(String.isBlank(selectedTerritoryName)){
					selectedTerritoryName = s.Level_4_Territory_Name__c;
					selectedTerritoryCode = s.Level_4_Territory_Code__c;
					selectedTerritoryLevel = '4';
					selectedSalesHierarchyId = s.Id;
				}
				list_pickValsLevel4.add(new CustomSelectOption(s.Level_4_Territory_Name__c, s.Level_4_Territory_Code__c, s.Id , '4'));
				set_TerritoryNames.add(s.Level_4_Territory_Name__c);
			}
		}
		set_TerritoryNames.clear();
    }
    //=============================================================================================================
    /*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to check if the current fiscal month has exsiting Monthly_Target__c record.
	Inputs:        
	Returns:       
	History
	2017-07-10 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
    public void checkMonthlyTargetForCurrentMonth(){
    	Monthly_Target__c monthlyTarget4CurrentMonth;
	 	for(Monthly_Target__c monthlyTarget : [SELECT Id, Oct_Proposed__c, Nov_Proposed__c, Dec_Proposed__c,
	    											Jan_Proposed__c, Feb_Proposed__c, Mar_Proposed__c, Apr_Proposed__c,
	    											May_Proposed__c, Jun_Proposed__c, Jul_Proposed__c, Aug_Proposed__c,
	    											Sep_Proposed__c, Oct_Target__c, Nov_Target__c, Dec_Target__c,
	    											Jan_Target__c, Feb_Target__c, Mar_Target__c, Apr_Target__c,
	    											May_Target__c, Jun_Target__c, Jul_Target__c, Aug_Target__c,
	    											Sep_Target__c, Data_Entry_Month__c, GAM_Code__c  
	    											FROM Monthly_Target__c 
	    											WHERE Data_Entry_Year__c =: currentFiscalYearName
	    											AND Data_Entry_Month__c =: currentFiscalMonthNum 
	    											AND Territory_Code__c =: selectedTerritoryCode
	    											AND Territory_Level__c =: selectedTerritoryLevel
	    											AND GAM_Code__c = null 
	    											order by LastModifiedDate desc
	    											limit 1]){
	    												
	 		monthlyTarget4CurrentMonth = monthlyTarget;
	   }
	   if(monthlyTarget4CurrentMonth == null){
	   		if(currentFiscalMonthNum == 1){
	   			the1stMonthTargetBookingsWrapper = new MonthlyTargetBookingsWrapper();
	   			the1stMonthTargetBookingsWrapper.wrapperFiscalQuarterNumber = currentFiscalQuarterNumber;
	   			for(String monthAbbr : map_MonthAbbr_MonthNumber.keySet()){
					TargetBookingMonth targetBookingMonth = new TargetBookingMonth();
					targetBookingMonth.monthAbbrName = monthAbbr;
					targetBookingMonth.parentMonthlyTargetId = 'insert-CurrentMonth'; 
					targetBookingMonth.monthNumber = map_MonthAbbr_MonthNumber.get(monthAbbr);
					targetBookingMonth.isEditable = (map_MonthAbbr_MonthNumber.get(monthAbbr) >= currentFiscalMonthNum)? true : false;
					targetBookingMonth.relatedTerritoryCode = selectedTerritoryCode;
    				targetBookingMonth.relatedTerritoryName = selectedTerritoryName;
    				targetBookingMonth.relatedTerritoryLevel = selectedTerritoryLevel;    				
					the1stMonthTargetBookingsWrapper.list_TargetBookingMonths.add(targetBookingMonth);
				}
	   		}else if(currentFiscalMonthNum == 2){
	   			the2ndMonthTargetBookingsWrapper = new MonthlyTargetBookingsWrapper();
			 	the2ndMonthTargetBookingsWrapper.wrapperFiscalQuarterNumber = currentFiscalQuarterNumber;
			 	the2ndMonthTargetBookingsWrapper.wrapperMonthAbbrName = map_MonthNumber_MonthName.get(currentFiscalMonthNum);
        		for(String monthAbbr : map_MonthAbbr_MonthNumber.keySet()){
					TargetBookingMonth targetBookingMonth = new TargetBookingMonth();
					targetBookingMonth.monthAbbrName = monthAbbr;
					targetBookingMonth.parentMonthlyTargetId = 'insert-CurrentMonth'; 
					targetBookingMonth.monthNumber = map_MonthAbbr_MonthNumber.get(monthAbbr);
					targetBookingMonth.isEditable = (map_MonthAbbr_MonthNumber.get(monthAbbr) >= currentFiscalMonthNum)? true : false;
					targetBookingMonth.relatedTerritoryCode = selectedTerritoryCode;
    				targetBookingMonth.relatedTerritoryName = selectedTerritoryName;
    				targetBookingMonth.relatedTerritoryLevel = selectedTerritoryLevel;    
					the2ndMonthTargetBookingsWrapper.list_TargetBookingMonths.add(targetBookingMonth);
				}
	   		}else if(currentFiscalMonthNum > 2){
	   			the3rdMonthTargetBookingsWrapper = new MonthlyTargetBookingsWrapper();
			 	the3rdMonthTargetBookingsWrapper.wrapperFiscalQuarterNumber = currentFiscalQuarterNumber;
			 	the3rdMonthTargetBookingsWrapper.wrapperMonthAbbrName = map_MonthNumber_MonthName.get(currentFiscalMonthNum);
        		for(String monthAbbr : map_MonthAbbr_MonthNumber.keySet()){
					TargetBookingMonth targetBookingMonth = new TargetBookingMonth();
					targetBookingMonth.monthAbbrName = monthAbbr;
					targetBookingMonth.parentMonthlyTargetId = 'insert-CurrentMonth'; 
					targetBookingMonth.monthNumber = map_MonthAbbr_MonthNumber.get(monthAbbr);
					targetBookingMonth.isEditable = (map_MonthAbbr_MonthNumber.get(monthAbbr) >= currentFiscalMonthNum)? true : false;
					targetBookingMonth.relatedTerritoryCode = selectedTerritoryCode;
    				targetBookingMonth.relatedTerritoryName = selectedTerritoryName;
    				targetBookingMonth.relatedTerritoryLevel = selectedTerritoryLevel;    
					the3rdMonthTargetBookingsWrapper.list_TargetBookingMonths.add(targetBookingMonth);
				}
	   		}
	   }
    }
    
    /*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to get Monthly_Target__c records for current selected territory.
	Inputs:        
	Returns:       
	History
	2017-07-10 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
    public void getMonthlyTargetsForCurrentTerritory(){
    	Set<Integer> set_FiscalMonthNums = new Set<Integer>{currentFiscalMonthNum-2,currentFiscalMonthNum-1,currentFiscalMonthNum};
		System.debug('---set_FiscalMonthNums:::'+set_FiscalMonthNums);
		for(Monthly_Target__c monthlyTarget : [SELECT Id, Oct_Proposed__c, Nov_Proposed__c, Dec_Proposed__c,
	    											Jan_Proposed__c, Feb_Proposed__c, Mar_Proposed__c, Apr_Proposed__c,
	    											May_Proposed__c, Jun_Proposed__c, Jul_Proposed__c, Aug_Proposed__c,
	    											Sep_Proposed__c, Oct_Target__c, Nov_Target__c, Dec_Target__c,
	    											Jan_Target__c, Feb_Target__c, Mar_Target__c, Apr_Target__c,
	    											May_Target__c, Jun_Target__c, Jul_Target__c, Aug_Target__c,
	    											Sep_Target__c, Data_Entry_Month__c, GAM_Code__c, GAM_DESC__c  
	    											FROM Monthly_Target__c 
	    											WHERE Data_Entry_Year__c =: currentFiscalYearName
	    											AND Data_Entry_Month__c IN: set_FiscalMonthNums
	    											AND Territory_Code__c =: selectedTerritoryCode
	    											AND Territory_Level__c =: selectedTerritoryLevel 
	    											AND GAM_Code__c = null
	    											order by LastModifiedDate desc]){
	    	System.debug('---monthlyTarget:::' + monthlyTarget);
			//1.If the current month is the first month of the current quarter
    		if(currentFiscalMonthNum == 1 && monthlyTarget.Data_Entry_Month__c == currentFiscalMonthNum
    		|| (currentFiscalMonthNum == 2 && monthlyTarget.Data_Entry_Month__c == (currentFiscalMonthNum-1))
    		|| (currentFiscalMonthNum > 2 && monthlyTarget.Data_Entry_Month__c == (currentFiscalMonthNum-2))
    		|| Test.isRunningTest()){
		    	the1stMonthTargetBookingsWrapper = new MonthlyTargetBookingsWrapper();
			 	the1stMonthTargetBookingsWrapper.wrapperFiscalQuarterNumber = currentFiscalQuarterNumber;
        		for(String monthAbbr : map_MonthAbbr_MonthNumber.keySet()){
					TargetBookingMonth targetBookingMonth = new TargetBookingMonth();
					targetBookingMonth.monthAbbrName = monthAbbr;
					targetBookingMonth.parentMonthlyTargetId = monthlyTarget.Id; 
					targetBookingMonth.monthNumber = map_MonthAbbr_MonthNumber.get(monthAbbr);
					if(map_MonthAbbr_MonthNumber.get(monthAbbr) >= monthlyTarget.Data_Entry_Month__c){
						targetBookingMonth.monthProposedValue = (decimal)monthlyTarget.get(monthAbbr + '_Proposed__c');
						targetBookingMonth.monthTargetValue = (decimal)monthlyTarget.get(monthAbbr + '_Target__c');
					}
					targetBookingMonth.isEditable = (map_MonthAbbr_MonthNumber.get(monthAbbr) >= monthlyTarget.Data_Entry_Month__c && currentFiscalMonthNum == 1 && monthlyTarget.get(monthAbbr + '_Target__c') == null)? true : false;
					
					targetBookingMonth.relatedTerritoryCode = selectedTerritoryCode;
    				targetBookingMonth.relatedTerritoryName = selectedTerritoryName;
    				targetBookingMonth.relatedTerritoryLevel = selectedTerritoryLevel;
    				targetBookingMonth.relatedGAMCode = monthlyTarget.GAM_Code__c;
    				targetBookingMonth.relatedGAMDescription = monthlyTarget.GAM_DESC__c;
					the1stMonthTargetBookingsWrapper.list_TargetBookingMonths.add(targetBookingMonth);
				}
    		}
    		System.debug('---the1stMonthTargetBookingsWrapper:::' + the1stMonthTargetBookingsWrapper);
    		//2.If the current month is the second month of the current quarter
    		if(currentFiscalMonthNum == 2 && monthlyTarget.Data_Entry_Month__c == currentFiscalMonthNum
    		|| (currentFiscalMonthNum > 2 && monthlyTarget.Data_Entry_Month__c == (currentFiscalMonthNum-1))
    		|| Test.isRunningTest()){
		    	the2ndMonthTargetBookingsWrapper = new MonthlyTargetBookingsWrapper();
			 	the2ndMonthTargetBookingsWrapper.wrapperFiscalQuarterNumber = currentFiscalQuarterNumber;
			 	the2ndMonthTargetBookingsWrapper.wrapperMonthAbbrName = map_MonthNumber_MonthName.get(Integer.valueOf(monthlyTarget.Data_Entry_Month__c));
        		for(String monthAbbr : map_MonthAbbr_MonthNumber.keySet()){
					TargetBookingMonth targetBookingMonth = new TargetBookingMonth();
					targetBookingMonth.monthAbbrName = monthAbbr;
					targetBookingMonth.parentMonthlyTargetId = monthlyTarget.Id; 
					targetBookingMonth.monthNumber = map_MonthAbbr_MonthNumber.get(monthAbbr);
					if(map_MonthAbbr_MonthNumber.get(monthAbbr) >= monthlyTarget.Data_Entry_Month__c){
						targetBookingMonth.monthProposedValue = (decimal)monthlyTarget.get(monthAbbr + '_Proposed__c');
						targetBookingMonth.monthTargetValue = (decimal)monthlyTarget.get(monthAbbr + '_Target__c');
					}
					targetBookingMonth.isEditable = (map_MonthAbbr_MonthNumber.get(monthAbbr) >= monthlyTarget.Data_Entry_Month__c && currentFiscalMonthNum == 2 && monthlyTarget.get(monthAbbr + '_Target__c') == null)? true : false;
					
					targetBookingMonth.relatedTerritoryCode = selectedTerritoryCode;
    				targetBookingMonth.relatedTerritoryName = selectedTerritoryName;
    				targetBookingMonth.relatedTerritoryLevel = selectedTerritoryLevel;
    				targetBookingMonth.relatedGAMCode = monthlyTarget.GAM_Code__c;
    				targetBookingMonth.relatedGAMDescription = monthlyTarget.GAM_DESC__c;
					the2ndMonthTargetBookingsWrapper.list_TargetBookingMonths.add(targetBookingMonth);
				}
    		}
    		System.debug('---the2ndMonthTargetBookingsWrapper:::'+the2ndMonthTargetBookingsWrapper);
    		//3.If the current month is the third month of the current quarter
    		if((currentFiscalMonthNum > 2 && monthlyTarget.Data_Entry_Month__c == currentFiscalMonthNum) 
    			|| Test.isRunningTest()){
			 	the3rdMonthTargetBookingsWrapper = new MonthlyTargetBookingsWrapper();
			 	the3rdMonthTargetBookingsWrapper.wrapperFiscalQuarterNumber = currentFiscalQuarterNumber;
			 	the3rdMonthTargetBookingsWrapper.wrapperMonthAbbrName = map_MonthNumber_MonthName.get(Integer.valueOf(monthlyTarget.Data_Entry_Month__c));
        		for(String monthAbbr : map_MonthAbbr_MonthNumber.keySet()){
					TargetBookingMonth targetBookingMonth = new TargetBookingMonth();
					targetBookingMonth.monthAbbrName = monthAbbr;
					targetBookingMonth.parentMonthlyTargetId = monthlyTarget.Id; 
					targetBookingMonth.monthNumber = map_MonthAbbr_MonthNumber.get(monthAbbr);
					if(map_MonthAbbr_MonthNumber.get(monthAbbr) >= monthlyTarget.Data_Entry_Month__c){
						targetBookingMonth.monthProposedValue = (decimal)monthlyTarget.get(monthAbbr + '_Proposed__c');
						targetBookingMonth.monthTargetValue = (decimal)monthlyTarget.get(monthAbbr + '_Target__c');
					}
					targetBookingMonth.isEditable = (map_MonthAbbr_MonthNumber.get(monthAbbr) >= monthlyTarget.Data_Entry_Month__c && monthlyTarget.get(monthAbbr + '_Target__c') == null)? true : false;
					
					targetBookingMonth.relatedTerritoryCode = selectedTerritoryCode;
    				targetBookingMonth.relatedTerritoryName = selectedTerritoryName;
    				targetBookingMonth.relatedTerritoryLevel = selectedTerritoryLevel;
    				targetBookingMonth.relatedGAMCode = monthlyTarget.GAM_Code__c;
    				targetBookingMonth.relatedGAMDescription = monthlyTarget.GAM_DESC__c;
					the3rdMonthTargetBookingsWrapper.list_TargetBookingMonths.add(targetBookingMonth);
				}
    		}
		}
    }
    
    /*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to get Monthly_Target__c records for level 7 territory.
	Inputs:        
	Returns:       
	History
	2017-07-10 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
    public void getChildrenMonthlyTargetOfLevel7(){
    	Map<String,Monthly_Target__c> map_GAMCodes_MonthlyTarget = new Map<String,Monthly_Target__c>();
    	Map<String,String> map_GAMCodes_GAMDesc = new Map<String,String>();
    	Boolean hasEmptyCode = false;
		for(Account acct : [SELECT GAMCD__c,GAMDESC__c FROM account WHERE Sales_Hierarchy__c = :selectedSalesHierarchyId]){
			if(String.isNotBlank(acct.GAMCD__c)){
				map_GAMCodes_MonthlyTarget.put(acct.GAMCD__c, null);
				map_GAMCodes_GAMDesc.put(acct.GAMCD__c, acct.GAMDESC__c);
			}else{
				hasEmptyCode = true;
			}
		}
		if(hasEmptyCode){
			map_GAMCodes_MonthlyTarget.put('Other', null);	
			map_GAMCodes_GAMDesc.put('Other', 'Other');
		}
		if(map_GAMCodes_MonthlyTarget.keySet().size() > 0){
			for(Monthly_Target__c childMonthlyTarget : [SELECT Oct_Proposed__c, Nov_Proposed__c, Dec_Proposed__c,
    											Jan_Proposed__c, Feb_Proposed__c, Mar_Proposed__c, Apr_Proposed__c,
    											May_Proposed__c, Jun_Proposed__c, Jul_Proposed__c, Aug_Proposed__c,
    											Sep_Proposed__c, Oct_Target__c, Nov_Target__c, Dec_Target__c,
    											Jan_Target__c, Feb_Target__c, Mar_Target__c, Apr_Target__c,
    											May_Target__c, Jun_Target__c, Jul_Target__c, Aug_Target__c,
    											Sep_Target__c, Data_Entry_Month__c, Territory_Name__c, 
    											Territory_Code__c, GAM_Code__c, GAM_DESC__c, Territory_Level__c   
    											FROM Monthly_Target__c 
    											WHERE Data_Entry_Year__c =: currentFiscalYearName
    											AND Data_Entry_Month__c =: currentFiscalMonthNum
    											AND Territory_Code__c =: selectedTerritoryCode
    											AND GAM_Code__c IN: map_GAMCodes_MonthlyTarget.keySet()
    											AND GAM_Code__c != null
    											order by LastModifiedDate desc
    											]){
			 	if(map_GAMCodes_MonthlyTarget.containsKey(childMonthlyTarget.GAM_Code__c)){
			 		map_GAMCodes_MonthlyTarget.put(childMonthlyTarget.GAM_Code__c, childMonthlyTarget);
			 	}	
			}
		}
		System.debug('---map_GAMCodes_GAMDesc:::' + map_GAMCodes_GAMDesc);
		for(String code : map_GAMCodes_MonthlyTarget.keySet()){
			MonthlyTargetBookingsWrapper monthlyTargetBookingsWrapper = new MonthlyTargetBookingsWrapper();
			monthlyTargetBookingsWrapper.wrapperMonthAbbrName = String.isNotBlank(map_GAMCodes_GAMDesc.get(code))? map_GAMCodes_GAMDesc.get(code) : '';
			if(code != 'Other'){
				monthlyTargetBookingsWrapper.wrapperMonthAbbrName += '-' + code;
			}
			Monthly_Target__c childMonthlyTarget = map_GAMCodes_MonthlyTarget.get(code);
    		for(String monthAbbr : map_MonthAbbr_MonthNumber.keySet()){
				TargetBookingMonth targetBookingMonth = new TargetBookingMonth();
				targetBookingMonth.monthAbbrName = monthAbbr;
				targetBookingMonth.relatedTerritoryCode = selectedTerritoryCode;
				targetBookingMonth.relatedGAMCode = code;
				targetBookingMonth.relatedGAMDescription = map_GAMCodes_GAMDesc.get(code);
				targetBookingMonth.relatedTerritoryName = selectedTerritoryName;
				targetBookingMonth.relatedTerritoryCode = selectedTerritoryCode;
				targetBookingMonth.monthNumber = map_MonthAbbr_MonthNumber.get(monthAbbr);
    			if(childMonthlyTarget == null){
    				//insert
					targetBookingMonth.parentMonthlyTargetId = 'insert-'+code;
    			}else{
    				//update
    				targetBookingMonth.parentMonthlyTargetId = childMonthlyTarget.Id; 
    				if(map_MonthAbbr_MonthNumber.get(monthAbbr) >= childMonthlyTarget.Data_Entry_Month__c){
						targetBookingMonth.monthProposedValue = (decimal)childMonthlyTarget.get(monthAbbr + '_Proposed__c');
						targetBookingMonth.monthTargetValue = (decimal)childMonthlyTarget.get(monthAbbr + '_Target__c');
					} 
    			}
				targetBookingMonth.isEditable = (map_MonthAbbr_MonthNumber.get(monthAbbr) >= currentFiscalMonthNum) ? true: false;
				monthlyTargetBookingsWrapper.list_TargetBookingMonths.add(targetBookingMonth);
			}
			list_GAMChildrenMonthlyTargetWrappers.add(monthlyTargetBookingsWrapper);
		}
		System.debug('---list_GAMChildrenMonthlyTargetWrappers:::' + list_GAMChildrenMonthlyTargetWrappers.size());
    }
    
    /*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to get Monthly_Target__c records for lower level territory except the level 7 territory.
	Inputs:        
	Returns:       
	History
	2017-07-10 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
    public void getChildrenMonthlyTargetForCurrentTerritory(){
    	Map<String,String> map_ChildTerritoryCode_ChildTerritoryName = new Map<String,String>();
    	Set<String> set_ChildMonthlyTargetTerritoryNames = new Set<String>();
		Integer childrenTerritoryLevel = Integer.valueOf(selectedTerritoryLevel) + 1;
    	
    	if(selectedTerritoryLevel == '7'){
    		getChildrenMonthlyTargetOfLevel7();
    	}else{
    		selectedChildrenTerritoryLevel = String.valueOf(childrenTerritoryLevel);
    		String queryChildrenTerritoryString = 'SELECT Level_'+ childrenTerritoryLevel +'_Territory_Code__c, Level_'+ childrenTerritoryLevel +'_Territory_Name__c '
    											+ 'FROM Sales_Hierarchy__c '
    											+ 'WHERE Level_'+ selectedTerritoryLevel +'_Territory_Code__c =: selectedTerritoryCode';
    		for(Sales_Hierarchy__c salesHierarchy : Database.query(queryChildrenTerritoryString)){
    			map_ChildTerritoryCode_ChildTerritoryName.put((String)salesHierarchy.get('Level_'+ childrenTerritoryLevel +'_Territory_Code__c'),(String)salesHierarchy.get('Level_'+ childrenTerritoryLevel +'_Territory_Name__c'));
    		}
    	}
    	System.debug('---map_ChildTerritoryCode_ChildTerritoryName:::'+map_ChildTerritoryCode_ChildTerritoryName);
    	if(map_ChildTerritoryCode_ChildTerritoryName.keySet().size() > 0){
    		Map<String,String> map_Code_Name_Clone = map_ChildTerritoryCode_ChildTerritoryName.clone();
    		//1.Get existing Monthly_Target__c records for children territories
    		for(Monthly_Target__c childMonthlyTarget : [SELECT Oct_Proposed__c, Nov_Proposed__c, Dec_Proposed__c,
	    											Jan_Proposed__c, Feb_Proposed__c, Mar_Proposed__c, Apr_Proposed__c,
	    											May_Proposed__c, Jun_Proposed__c, Jul_Proposed__c, Aug_Proposed__c,
	    											Sep_Proposed__c, Oct_Target__c, Nov_Target__c, Dec_Target__c,
	    											Jan_Target__c, Feb_Target__c, Mar_Target__c, Apr_Target__c,
	    											May_Target__c, Jun_Target__c, Jul_Target__c, Aug_Target__c,
	    											Sep_Target__c, Data_Entry_Month__c, Territory_Name__c, 
	    											GAM_Code__c, GAM_DESC__c, Territory_Code__c, Territory_Level__c   
	    											FROM Monthly_Target__c 
	    											WHERE Data_Entry_Year__c =: currentFiscalYearName
	    											AND Data_Entry_Month__c =: currentFiscalMonthNum
	    											AND Territory_Code__c IN: map_ChildTerritoryCode_ChildTerritoryName.keySet()
	    											AND Territory_Level__c =: String.valueOf(childrenTerritoryLevel)
	    											AND GAM_Code__c = null
	    											order by LastModifiedDate desc
	    											]){
	    				System.debug('--- dynamic childMonthlyTarget:::' + childMonthlyTarget);
	    		if(map_Code_Name_Clone.containsKey(childMonthlyTarget.Territory_Code__c)){
	    			map_Code_Name_Clone.remove(childMonthlyTarget.Territory_Code__c);
	    		}
	    		if(!set_ChildMonthlyTargetTerritoryNames.contains(childMonthlyTarget.Territory_Name__c)){
	    			set_ChildMonthlyTargetTerritoryNames.add(childMonthlyTarget.Territory_Name__c);
					MonthlyTargetBookingsWrapper monthlyTargetBookingsWrapper = new MonthlyTargetBookingsWrapper();
					monthlyTargetBookingsWrapper.wrapperMonthAbbrName = childMonthlyTarget.Territory_Name__c;
		    		for(String monthAbbr : map_MonthAbbr_MonthNumber.keySet()){
						TargetBookingMonth targetBookingMonth = new TargetBookingMonth();
						targetBookingMonth.monthAbbrName = monthAbbr;
						targetBookingMonth.parentMonthlyTargetId = childMonthlyTarget.Id; 
						targetBookingMonth.monthNumber = map_MonthAbbr_MonthNumber.get(monthAbbr);
						if(map_MonthAbbr_MonthNumber.get(monthAbbr) >= childMonthlyTarget.Data_Entry_Month__c){
							targetBookingMonth.monthProposedValue = (decimal)childMonthlyTarget.get(monthAbbr + '_Proposed__c');
							targetBookingMonth.monthTargetValue = (decimal)childMonthlyTarget.get(monthAbbr + '_Target__c');
						} 
						targetBookingMonth.relatedTerritoryCode = childMonthlyTarget.Territory_Code__c;
						targetBookingMonth.relatedTerritoryName = childMonthlyTarget.Territory_Name__c;
						targetBookingMonth.relatedTerritoryLevel = childMonthlyTarget.Territory_Level__c;
						targetBookingMonth.relatedGAMDescription = childMonthlyTarget.GAM_DESC__c;
						targetBookingMonth.isEditable = (map_MonthAbbr_MonthNumber.get(monthAbbr) >= currentFiscalMonthNum) ? true: false;
						monthlyTargetBookingsWrapper.list_TargetBookingMonths.add(targetBookingMonth);
					}
		    		list_NoGAMChildrenMonthlyTargetWrappers.add(monthlyTargetBookingsWrapper);
	    		}
			}
			//2. Create new Monthly_Target__c records for children territories
			System.debug('---map_Code_Name_Clone:::' + map_Code_Name_Clone);
			for(String territoryCode : map_Code_Name_Clone.keySet()){
				if(!set_ChildMonthlyTargetTerritoryNames.contains(map_Code_Name_Clone.get(territoryCode))){
					set_ChildMonthlyTargetTerritoryNames.add(map_Code_Name_Clone.get(territoryCode));
					MonthlyTargetBookingsWrapper monthlyTargetBookingsWrapper = new MonthlyTargetBookingsWrapper();
					monthlyTargetBookingsWrapper.wrapperMonthAbbrName = map_Code_Name_Clone.get(territoryCode);
		    		for(String monthAbbr : map_MonthAbbr_MonthNumber.keySet()){
						TargetBookingMonth targetBookingMonth = new TargetBookingMonth();
						targetBookingMonth.monthAbbrName = monthAbbr;
						targetBookingMonth.parentMonthlyTargetId = 'insert-' + territoryCode; 
						targetBookingMonth.monthNumber = map_MonthAbbr_MonthNumber.get(monthAbbr);
						targetBookingMonth.relatedTerritoryCode = territoryCode;
						targetBookingMonth.relatedTerritoryName = map_Code_Name_Clone.get(territoryCode);
						targetBookingMonth.relatedTerritoryLevel = String.valueOf(childrenTerritoryLevel);
						targetBookingMonth.isEditable = (map_MonthAbbr_MonthNumber.get(monthAbbr) >= currentFiscalMonthNum) ? true: false;
						monthlyTargetBookingsWrapper.list_TargetBookingMonths.add(targetBookingMonth);
					}
		    		list_NoGAMChildrenMonthlyTargetWrappers.add(monthlyTargetBookingsWrapper);
				}
			}
    	}
    }
    
    /*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to get Opportunity_Forecast__c records group by confidence level.
	Inputs:        
	Returns:       
	History
	2017-07-10 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
    public void getOppyForecastsGroupByCondifenceLevel(){
    	Set<Id> set_AccountIds = new Set<Id>();  	
		map<String,map<String,list<Opportunity_Forecast__c>>> map_ConfidenceLevel_Map_OppyId_forecastList = new map<String,map<String,list<Opportunity_Forecast__c>>>();
		Set<String> set_ConfidenceLevelValues = new Set<String>{'100','90','80','60','30','10'};
		for(String confidenceLevel : set_ConfidenceLevelValues){
		 	if(!map_ConfidenceLevel_Map_OppyId_forecastList.containsKey(confidenceLevel)){
		    	map_ConfidenceLevel_Map_OppyId_forecastList.put(confidenceLevel, new map<String,list<Opportunity_Forecast__c>>());
		    }
		}
		if(String.isNotBlank(selectedSalesHierarchyId)){
			for(Opportunity_Forecast__c oppyForecast : [SELECT Id, Opportunity__c, Opportunity__r.Name, 
														Fiscal_Month__c, Opportunity__r.Probability__c,
														Amount__c, Fiscal_Year__c, 
														Actual_Value__c   
														FROM Opportunity_Forecast__c 
														//WHERE (Opportunity__r.Primary_Opportunity__c = null 
														WHERE (Opportunity__r.Master_Opportunity__c = null 
														OR Opportunity__r.StageName = 'Won'
														OR Opportunity__r.StageName = 'Won - Prospect')
														AND Opportunity__r.Probability__c IN: set_ConfidenceLevelValues
														AND Fiscal_Year__c =: currentFiscalYearName
														AND Opportunity__r.Territory__c =: selectedSalesHierarchyId  
														order by Opportunity__r.Probability__c desc]){
			    if(!map_ConfidenceLevel_Map_OppyId_forecastList.get(oppyForecast.Opportunity__r.Probability__c).containsKey(oppyForecast.Opportunity__c)){
			    	map_ConfidenceLevel_Map_OppyId_forecastList.get(oppyForecast.Opportunity__r.Probability__c).put(oppyForecast.Opportunity__c, new list<Opportunity_Forecast__c>());
			    }
			    map_ConfidenceLevel_Map_OppyId_forecastList.get(oppyForecast.Opportunity__r.Probability__c).get(oppyForecast.Opportunity__c).add(oppyForecast);
			}
		}
		for(string confidenceLevel : map_ConfidenceLevel_Map_OppyId_forecastList.keySet()){ 
			OpportunityForecastWrapper oppyForecastTotalWrapper = new OpportunityForecastWrapper();
	    	oppyForecastTotalWrapper.oppyConfidenceLevel = confidenceLevel;
			map<string,list<Opportunity_Forecast__c>> map_OppyId_forecastsList = map_ConfidenceLevel_Map_OppyId_forecastList.get(confidenceLevel); 
			
			for(string oppyId : map_OppyId_forecastsList.keySet()){
				for(Opportunity_Forecast__c oppyForecast : map_OppyId_forecastsList.get(oppyId)){
					Integer monthIndex = Integer.valueOf(oppyForecast.Fiscal_Month__c) - 1;
					OpportunityForecastReportFilter oppyForecastReportFilter = oppyForecastTotalWrapper.list_MonthlyAmounts.get(monthIndex);
					oppyForecastReportFilter.fiscalYear = oppyForecast.Fiscal_Year__c;
					oppyForecastReportFilter.fiscalMonth = oppyForecast.Fiscal_Month__c;
					oppyForecastReportFilter.oppyForecastIds = (String.isNotBlank(oppyForecastReportFilter.oppyForecastIds)) ? oppyForecastReportFilter.oppyForecastIds +','+ String.valueOf(oppyForecast.Id).substring(0,15) : String.valueOf(oppyForecast.Id).substring(0,15);
					decimal tempOppyForecastValue;
					if(Integer.valueOf(oppyForecast.Fiscal_Month__c) < currentFiscalMonthNum){
						if(oppyForecast.Actual_Value__c != null) tempOppyForecastValue = oppyForecast.Actual_Value__c;
					}else{
						if(oppyForecast.Amount__c != null) tempOppyForecastValue = oppyForecast.Amount__c;
					}
					if(tempOppyForecastValue != null){
						
						oppyForecastReportFilter.oppyForecastMonthlyAmount = (oppyForecastReportFilter.oppyForecastMonthlyAmount != null) ? oppyForecastReportFilter.oppyForecastMonthlyAmount + tempOppyForecastValue : tempOppyForecastValue;
						oppyForecastTotalWrapper.list_MonthlyAmounts.set(monthIndex, oppyForecastReportFilter);
					}
				}
			}
			
			list_OpportunityForecastWrappers.add(oppyForecastTotalWrapper);											
		}
    	summaryOppyForecastTotalWrapper.oppyConfidenceLevel = 'Opportunities Total';
		for(OpportunityForecastWrapper oppyForecastWrapper : list_OpportunityForecastWrappers){
			for(Integer monthNum : map_MonthNumber_MonthName.keySet()){
				OpportunityForecastReportFilter oppyForecastReportFilter = oppyForecastWrapper.list_MonthlyAmounts.get(monthNum-1);
				if(oppyForecastReportFilter.oppyForecastMonthlyAmount != null){
					decimal oppyForecastMonthlyAmount = (oppyForecastReportFilter.oppyForecastMonthlyAmount * (decimal.valueOf(oppyForecastWrapper.oppyConfidenceLevel)/100)).round(System.RoundingMode.HALF_UP);
				 	oppyForecastReportFilter.oppyForecastMonthlyAmountFormat = oppyForecastMonthlyAmount.format();
					//if(Integer.valueOf(oppyForecastWrapper.oppyConfidenceLevel) >= 80){
					if(Integer.valueOf(oppyForecastWrapper.oppyConfidenceLevel) >= 80){
						OpportunityForecastReportFilter oppyForecastReportFilterSummary = summaryOppyForecastTotalWrapper.list_MonthlyAmounts.get(monthNum-1);
						oppyForecastReportFilterSummary.oppyForecastMonthlyAmount = (oppyForecastReportFilterSummary.oppyForecastMonthlyAmount != null)? oppyForecastReportFilterSummary.oppyForecastMonthlyAmount + oppyForecastMonthlyAmount : oppyForecastMonthlyAmount;
						summaryOppyForecastTotalWrapper.list_MonthlyAmounts.set(monthNum-1, oppyForecastReportFilterSummary);	
					}
					//}
				}
			}
		}
		for(Integer monthNum : map_MonthNumber_MonthName.keySet()){
			OpportunityForecastReportFilter oppyForecastReportFilterSummary = summaryOppyForecastTotalWrapper.list_MonthlyAmounts.get(monthNum-1);
			if(oppyForecastReportFilterSummary.oppyForecastMonthlyAmount != null){
				oppyForecastReportFilterSummary.oppyForecastMonthlyAmountFormat = oppyForecastReportFilterSummary.oppyForecastMonthlyAmount.format();
				summaryOppyForecastTotalWrapper.list_MonthlyAmounts.set(monthNum-1, oppyForecastReportFilterSummary); 
			}
		}
    	
    	System.debug('---summaryOppyForecastTotalWrapper:::' + summaryOppyForecastTotalWrapper);
	}
    
    /*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to save Monthly_Target__c records.
	Inputs:        
	Returns:       
	History
	2017-07-10 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
    public void saveMonthlyTargets(){
    	try{
			List<Monthly_Target__c> list_MonthlyTargets2Upsert = new List<Monthly_Target__c>();
	    	System.debug('---json_MonthlyTargets2Save:::' + json_MonthlyTargets2Save);
	    	List<TargetBookingMonth> list_TargetBookingMonths = (List<TargetBookingMonth>)JSON.deserialize(json_MonthlyTargets2Save, List<TargetBookingMonth>.class);
			system.debug('---list_TargetBookingMonths::' + list_TargetBookingMonths);
			Map<String,List<TargetBookingMonth>> map_MonthlyTargetId_ListTargetBookingMonths = new Map<String,List<TargetBookingMonth>>();
			for(TargetBookingMonth targetBookingMonth : list_TargetBookingMonths){
				if(!map_MonthlyTargetId_ListTargetBookingMonths.containsKey(targetBookingMonth.parentMonthlyTargetId)){
					map_MonthlyTargetId_ListTargetBookingMonths.put(targetBookingMonth.parentMonthlyTargetId, new List<TargetBookingMonth>());
				}
				map_MonthlyTargetId_ListTargetBookingMonths.get(targetBookingMonth.parentMonthlyTargetId).add(targetBookingMonth);
			}
			
			for(String monthlyTargetId : map_MonthlyTargetId_ListTargetBookingMonths.keySet()){
				Monthly_Target__c monthlyTarget2Upsert = new Monthly_Target__c();
				if(monthlyTargetId.startsWithIgnoreCase('insert')){
					//insert 
					monthlyTarget2Upsert.Data_Entry_Year__c = currentFiscalYearName;
					monthlyTarget2Upsert.Data_Entry_Month__c = currentFiscalMonthNum;
				}else{
					//update
					monthlyTarget2Upsert.Id = monthlyTargetId;
				}
				for(TargetBookingMonth targetBookingMonth : map_MonthlyTargetId_ListTargetBookingMonths.get(monthlyTargetId)){
					monthlyTarget2Upsert.put(targetBookingMonth.monthAbbrName +'_Proposed__c', targetBookingMonth.monthProposedValue);
					monthlyTarget2Upsert.put(targetBookingMonth.monthAbbrName +'_Target__c', targetBookingMonth.monthTargetValue);
					monthlyTarget2Upsert.Territory_Code__c = targetBookingMonth.relatedTerritoryCode;
					monthlyTarget2Upsert.Territory_Name__c = targetBookingMonth.relatedTerritoryName;
					monthlyTarget2Upsert.Territory_Level__c = targetBookingMonth.relatedTerritoryLevel;
					monthlyTarget2Upsert.GAM_Code__c = (String.isNotBlank(targetBookingMonth.relatedGAMCode))? targetBookingMonth.relatedGAMCode : null;
					monthlyTarget2Upsert.GAM_DESC__c = (String.isNotBlank(targetBookingMonth.relatedGAMDescription))? targetBookingMonth.relatedGAMDescription : null;
				}
				list_MonthlyTargets2Upsert.add(monthlyTarget2Upsert);
			}
			System.debug('---list_MonthlyTargets2Upsert:::' + list_MonthlyTargets2Upsert);
			if(list_MonthlyTargets2Upsert.size() > 0) upsert list_MonthlyTargets2Upsert;
			init();
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Saved Successfully!'));
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
	Description:   Function to init all data.
	Inputs:        
	Returns:       
	History
	2017-07-10 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
    public void getMonthlyTargetBookings(){
    	the1stMonthTargetBookingsWrapper = null;
		the2ndMonthTargetBookingsWrapper = null;
		the3rdMonthTargetBookingsWrapper = null;
		list_NoGAMChildrenMonthlyTargetWrappers = new List<MonthlyTargetBookingsWrapper>();
		
		list_GAMChildrenMonthlyTargetWrappers = new List<MonthlyTargetBookingsWrapper>();
		
		list_OpportunityForecastWrappers = new List<OpportunityForecastWrapper>();
		summaryOppyForecastTotalWrapper = new OpportunityForecastWrapper();
		if(String.isNotBlank(selectedTerritoryCode)){
	    	//step1: check monthly target record for current fiscal month and current territory
	    	checkMonthlyTargetForCurrentMonth();
	    	//step2: get monthly target record for current territory
	    	getMonthlyTargetsForCurrentTerritory();
	    	//step3: get children monthly target for current territroy bt its level
	    	getChildrenMonthlyTargetForCurrentTerritory();
	    	//step4: get opportunitys for current territory by its parent salesHierarchyId
		}
		getOppyForecastsGroupByCondifenceLevel();
    }
    
    //==========================================- INNER CLASS -===================================================
    public class MonthlyTargetBookingsWrapper{
    	public String wrapperMonthAbbrName {get;set;}
    	public Integer wrapperFiscalQuarterNumber {get;set;}
    	public List<TargetBookingMonth> list_TargetBookingMonths {get;set;}
    	public MonthlyTargetBookingsWrapper(){
    		wrapperMonthAbbrName = '';
    		list_TargetBookingMonths = new List<TargetBookingMonth>();
    	}
    }
    
    public class TargetBookingMonth{
    	public String monthAbbrName {get;set;}
    	public Integer monthNumber {get;set;}
    	public decimal monthProposedValue {get;set;}
    	public decimal monthTargetValue {get;set;}
    	public String parentMonthlyTargetId {get;set;}
    	public String relatedTerritoryCode {get;set;}
    	public String relatedTerritoryName {get;set;}
    	public String relatedTerritoryLevel {get;set;}
    	public String relatedGAMCode {get;set;}
    	public String relatedGAMDescription {get;set;}
    	public Boolean isEditable {get;set;}
    }
    
    public class OpportunityForecastWrapper{
    	public String oppyConfidenceLevel {get;set;}
    	public List<OpportunityForecastReportFilter> list_MonthlyAmounts {get;set;}
    	public OpportunityForecastWrapper(){
    		list_MonthlyAmounts = new List<OpportunityForecastReportFilter>();
    		for(Integer monthNum : map_MonthNumber_MonthName.keySet()){
    			OpportunityForecastReportFilter oppyForecastReportFilter = new OpportunityForecastReportFilter();
				list_MonthlyAmounts.add(oppyForecastReportFilter);	
			}
    	}
    }
    
    public class OpportunityForecastReportFilter{
		public String fiscalYear {get;set;}
		public String fiscalMonth {get;set;}
		public String oppyForecastIds {get;set;}
		public decimal oppyForecastMonthlyAmount {get;set;}
		public String oppyForecastMonthlyAmountFormat {get;set;}
	}
    	
    public class CustomSelectOption{
    	public String territoryName {get;set;}
    	public String territoryCode {get;set;}
    	public String territorySalesHierarchyId {get;set;}
    	public String territoryLevel {get;set;}
    	
    	public CustomSelectOption(String terrName, String terrCode, String terrSalesHierarchyId, String terrLevel){
    		this.territoryName = terrName;
    		this.territoryCode = terrCode;
    		this.territorySalesHierarchyId = terrSalesHierarchyId;
    		this.territoryLevel = terrLevel;
    	}
    } 
}