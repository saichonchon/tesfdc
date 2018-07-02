/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   A controller class for show Opportunity_Forecast__c records and save changes in ExtOpportunityForecasting.page.
			   The user story number is W-00145.
Inputs:        "stdCtrl" - ApexPages.standardController of Opportunity
Test Class:    ExtOpportunityForecasting_Test
History
2017-07-10 	Yiming Shen <yiming.shen@capgemini.com> Created
------------------------------------------------------------*/  
public with sharing class ExtOpportunityForecasting {
	//==================================================================================================================
	public List<BasicOppyForecastWrapper>  list_BasicOppyForecastWrappers2Show {get;set;}
	public List<DetailedOppyForecastWrapper> list_DetailedOppyForecastWrappers2Show {get;set;}
	public Opportunity oppy {get; set;}
	public Integer currentFiscalYear {get;set;}
	public String json_OppyForecasts2Save {get;set;}
	public List<SelectOption> list_ConfidenceLevelSelectOptions {get;set;}
	public String oppyConfidenceLevel {get;set;}
	public Boolean isShowOppyForecast {get;set;}
	public Opportunity primaryOppy {get;set;}
	public Id currentOppyId {get;set;}
	public Boolean isRefreshPage {get;set;}
	public static boolean isOppyForecastManagementSave = false;
	public String str_thousandSep {get; set;}
    public String str_decimalSep {get; set;}
	//==================================================================================================================
	private Map<Id,MonthlyForecastWrapper> map_ForecastId_OldMonthlyForecast;
	private Integer currentFiscalMonth;
	private Boolean isAllowToEditPastForecast;
	private Date currentDate2GetFiscalDate;
	private Date currentFiscalQuarterStartDate;
	private Opportunity currentOppy;
	private Integer currentFiscalQuarter;
	private final ApexPages.standardController stdCtrl;
	private static Set<String> set_AllFiscalYears = new Set<String>(); 
	private static Integer NumberOfNextFiscalYears = 6;
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
    
	public ExtOpportunityForecasting(ApexPages.standardController stdCtrl){
		this.stdCtrl = stdCtrl;    
        oppy = (Opportunity) stdCtrl.getRecord();
        currentOppyId = oppy.Id;
        currentOppy = [SELECT CloseDate, Probability__c, RecordType.DeveloperName, Master_Opportunity__c, StageName  
        				FROM Opportunity 
        				WHERE Id =: oppy.Id limit 1];
        isShowOppyForecast = (currentOppy.Master_Opportunity__c == null || currentOppy.StageName == 'Won')? true : false;
		if(currentOppy.Master_Opportunity__c != null && !isShowOppyForecast){
			primaryOppy = [SELECT Id,Name FROM Opportunity WHERE Id =: currentOppy.Master_Opportunity__c limit 1];
		}
		Map<String, Profiles_Allow_To_Edit_Past_Forecast__c> map_ProfileName_ProfileSetting = Profiles_Allow_To_Edit_Past_Forecast__c.getAll();
		Set<Id> set_ProfileIdsAllowEditPast = new Set<Id>();
		for(Profiles_Allow_To_Edit_Past_Forecast__c profileSetting : map_ProfileName_ProfileSetting.values()){
			set_ProfileIdsAllowEditPast.add(profileSetting.Profile_Id__c);
		}
		isAllowToEditPastForecast = (set_ProfileIdsAllowEditPast.contains(UserInfo.getProfileId()))? true : false;
        list_ConfidenceLevelSelectOptions = new List<SelectOption>();
        list_ConfidenceLevelSelectOptions = getFieldPicklistValues('Opportunity_Forecast__c','Confidence_Level__c');
        for(Integer i = 0; i < list_ConfidenceLevelSelectOptions.size(); i ++){
        	if(list_ConfidenceLevelSelectOptions.get(i).getLabel() == '0'
        	&& !currentOppy.StageName.containsIgnoreCase('Lost')){
        		list_ConfidenceLevelSelectOptions.remove(i);
        	}
        }
		list_BasicOppyForecastWrappers2Show = GetBasicOppyForecastWrappers();
		list_BasicOppyForecastWrappers2Show = GetBasicForecastAmounts(list_BasicOppyForecastWrappers2Show);
		list_DetailedOppyForecastWrappers2Show = getDetailedOppyForecastWrappers(list_BasicOppyForecastWrappers2Show);
		setThousandAndDecimalSep();
	}
	
	/*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to load Opportunity_Forecast__c records 
				   and wrap Opportunity_Forecast__c each Opportunity_Forecast__c record to BasicOppyForecastWrapper object.
	Inputs:        
	Returns:       List<BasicOppyForecastWrapper> - the list of BasicOppyForecastWrapper objects
	History
	2017-07-10 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
	public List<BasicOppyForecastWrapper> GetBasicOppyForecastWrappers(){
		if(currentOppy.CloseDate == null){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'Please populate CloseDate for this opportunity!'));
			return null;
		}
		oppyConfidenceLevel = currentOppy.Probability__c;
		List<BasicOppyForecastWrapper> list_BasicOppyForecastWrappers = new List<BasicOppyForecastWrapper>();
		Map<string,List<Period>> map_FiscalYear_list_Quarters = new Map<string,List<Period>>();
		Map<string,List<Period>> map_FiscalYear_list_Months = new Map<string,List<Period>>();
		
		for(Period currentPeriod : [SELECT EndDate, FiscalYearSettings.Name, Number, Id, PeriodLabel, 
									QuarterLabel, StartDate, Type 
									FROM Period 
									WHERE (Type = 'Year' OR Type = 'Quarter' OR Type = 'Month')  
									AND StartDate <=: currentOppy.CloseDate 
									AND EndDate >=: currentOppy.CloseDate ]){
			if(currentPeriod.Type == 'Year'){
				currentFiscalYear = Integer.valueOf(currentPeriod.FiscalYearSettings.Name);
			}else if(currentPeriod.Type == 'Quarter'){
				currentFiscalQuarter = currentPeriod.Number;
				currentFiscalQuarterStartDate = currentPeriod.StartDate;
			}else if(currentPeriod.Type == 'Month'){
				currentFiscalMonth = map_MonthAbbr_MonthNumber.get(currentPeriod.PeriodLabel);
			}
		} 
	
		if(currentFiscalYear == null){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'No such a period!'));
			return null;
		}
		
		Integer maxFiscalYear =	currentFiscalYear + NumberOfNextFiscalYears - 1;
		for(Integer i = 0; i <= NumberOfNextFiscalYears - 1; i++){
			Integer nextFiscalYear  = currentFiscalYear + i;
			set_AllFiscalYears.add(String.valueOf(nextFiscalYear));
		}
		
		//get next quarters after current quarter in set_AllFiscalYears
		for(Period quarterPeriod : [SELECT StartDate, EndDate, Number, FiscalYearSettings.Name 
									FROM Period 
									WHERE FiscalYearSettings.Name IN : set_AllFiscalYears 
									AND Type = 'Quarter' 
									order by StartDate]){
			if(!map_FiscalYear_list_Quarters.containsKey(quarterPeriod.FiscalYearSettings.Name)){
				map_FiscalYear_list_Quarters.put(quarterPeriod.FiscalYearSettings.Name, new list<Period>());
			}
			map_FiscalYear_list_Quarters.get(quarterPeriod.FiscalYearSettings.Name).add(quarterPeriod);
		}
		//get next months after current month in set_AllFiscalYears			
		for(Period monthPeriod : [SELECT StartDate, EndDate, Number, PeriodLabel, FiscalYearSettings.Name 
									FROM Period 
									WHERE FiscalYearSettings.Name IN : set_AllFiscalYears 
									AND Type = 'Month' 
									order by StartDate]){
				if(!map_FiscalYear_list_Months.containsKey(monthPeriod.FiscalYearSettings.Name)){
					map_FiscalYear_list_Months.put(monthPeriod.FiscalYearSettings.Name, new list<Period>());
				}
				map_FiscalYear_list_Months.get(monthPeriod.FiscalYearSettings.Name).add(monthPeriod);	
		}
		List<Period> list_Quarters = new List<Period>();
		List<Period> list_Months = new List<Period>();
		for(string fiscalYear : set_AllFiscalYears){
			 list_Quarters = map_FiscalYear_list_Quarters.get(fiscalYear);
			 list_Months = map_FiscalYear_list_Months.get(fiscalYear);
			 if(list_Months != null){
				 for(Period monthPeriod : list_Months){
					BasicOppyForecastWrapper basicOppyForecastWrapper = new BasicOppyForecastWrapper();
					BasicOppyForecastWrapper.FiscalYearLabel = fiscalyear;
					BasicOppyForecastWrapper.ForecastAmount = '';
					BasicOppyForecastWrapper.ActualAmount = '';
					if(monthPeriod.Number == null){
					 	BasicOppyForecastWrapper.FiscalMonthLabel = string.valueOf(map_MonthAbbr_MonthNumber.get(monthPeriod.PeriodLabel));
					}else{
						BasicOppyForecastWrapper.FiscalMonthLabel = string.valueOf(monthPeriod.Number);
					}
										
					for(Period quarterPeriod : list_Quarters){
						if(monthPeriod.StartDate >= quarterPeriod.StartDate 
							&& monthPeriod.EndDate <= quarterPeriod.EndDate){
							BasicOppyForecastWrapper.FiscalQuarterLabel = 'Q' + quarterPeriod.Number;
							break;
						}
					}
					list_BasicOppyForecastWrappers.add(BasicOppyForecastWrapper);	
				}	
			}		
		}
		return list_BasicOppyForecastWrappers;			
	}		
	
	/*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to get forccast value and confidence level from existing oppy forecast
				   and assign forecast amount to BasicOppyForecastWrapper object.
	Inputs:        list_BasicOppyForecastWrappers - the list of BasicOppyForecastWrapper objects
	Returns:       List<BasicOppyForecastWrapper> - the list of BasicOppyForecastWrapper objects
	History
	2017-07-10 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
	public List<BasicOppyForecastWrapper> GetBasicForecastAmounts(List<BasicOppyForecastWrapper> list_BasicOppyForecastWrappers){
		for(Opportunity_Forecast__c oppyForecast : [SELECT Id, Amount__c, Fiscal_Month__c, 
													Fiscal_Quarter__c, Fiscal_Year__c, Confidence_Level__c   
													FROM Opportunity_Forecast__c 
													WHERE Opportunity__c =: oppy.Id 
													AND Fiscal_Year__c IN: set_AllFiscalYears]){
			for(BasicOppyForecastWrapper basicOppyForecastWrapper : list_BasicOppyForecastWrappers){
				if(basicOppyForecastWrapper.FiscalYearLabel == oppyForecast.Fiscal_Year__c
				&& basicOppyForecastWrapper.FiscalQuarterLabel == oppyForecast.Fiscal_Quarter__c 
				&& String.isNotBlank(basicOppyForecastWrapper.FiscalMonthLabel)
				&& basicOppyForecastWrapper.FiscalMonthLabel == oppyForecast.Fiscal_Month__c){
					basicOppyForecastWrapper.ForecastAmount = String.valueOf(oppyForecast.Amount__c);
					if(String.isNotBlank(basicOppyForecastWrapper.ForecastAmount)){
						basicOppyForecastWrapper.ForecastAmount = String.valueOf(oppyForecast.Amount__c.round(System.RoundingMode.HALF_UP));
					}					
					basicOppyForecastWrapper.ConfidenceLevelValue = oppyForecast.Confidence_Level__c;
					basicOppyForecastWrapper.OppyForecastId = oppyForecast.Id;
				}
			}
		}	
		return list_BasicOppyForecastWrappers;
	}
	
	/*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to get forccast value and confidence level from existing oppy forecast
				   and assign forecast amount to BasicOppyForecastWrapper object.
	Inputs:        list_BasicOppyForecastWrappers - the list of BasicOppyForecastWrapper objects
	Returns:       List<BasicOppyForecastWrapper> - the list of BasicOppyForecastWrapper objects
	History
	2017-07-10 	Yiming Shen <yiming.shen@capgemini.com> Created
	------------------------------------------------------------*/
	public List<DetailedOppyForecastWrapper> getDetailedOppyForecastWrappers(List<BasicOppyForecastWrapper> list_BasicOppyForecastWrappers){
		
		List<DetailedOppyForecastWrapper> list_DetailedOppyForecastWrappers = new List<DetailedOppyForecastWrapper>();
		map_ForecastId_OldMonthlyForecast = new Map<Id,MonthlyForecastWrapper>();
		map<string,list<BasicOppyForecastWrapper>> map_FiscalYear_list_BasicForecasts = new map<string,list<BasicOppyForecastWrapper>>();
		
		//filter fc group by year
		for(BasicOppyForecastWrapper basicOppyForecastWrapper : list_BasicOppyForecastWrappers){
			if(!map_FiscalYear_list_BasicForecasts.containsKey(basicOppyForecastWrapper.FiscalYearLabel)){
				map_FiscalYear_list_BasicForecasts.put(basicOppyForecastWrapper.FiscalYearLabel, new List<BasicOppyForecastWrapper>());
			}
			map_FiscalYear_list_BasicForecasts.get(basicOppyForecastWrapper.FiscalYearLabel).add(basicOppyForecastWrapper);
		}
		
		//calculate quarter & Year Total
		for(string fiscalYear : map_FiscalYear_list_BasicForecasts.keySet()){
			DetailedOppyForecastWrapper detailedOppyForecastWrapper = new DetailedOppyForecastWrapper();			
			
			detailedOppyForecastWrapper.FiscalYearLabel = fiscalYear;
			detailedOppyForecastWrapper.list_MonthlyForecastWrappers = new List<MonthlyForecastWrapper>();
			for(Integer monthNumber : map_MonthNumber_MonthName.keySet()){
				MonthlyForecastWrapper tempMonthlyForecastWrapper = new MonthlyForecastWrapper();
				tempMonthlyForecastWrapper.YearName = fiscalYear;
				tempMonthlyForecastWrapper.MonthNumber = monthNumber;
				tempMonthlyForecastWrapper.MonthName = map_MonthNumber_MonthName.get(monthNumber);
				tempMonthlyForecastWrapper.isEditable = true;
				detailedOppyForecastWrapper.list_MonthlyForecastWrappers.add(tempMonthlyForecastWrapper);
			}
			//detailedOppyForecastWrapper.YearTotal = 0;
			detailedOppyForecastWrapper.isQ1Editable = (Integer.valueOf(fiscalYear) == currentFiscalYear && 1 < currentFiscalQuarter && !isAllowToEditPastForecast)? false : true;
			detailedOppyForecastWrapper.isQ2Editable = (Integer.valueOf(fiscalYear) == currentFiscalYear && 2 < currentFiscalQuarter && !isAllowToEditPastForecast)? false : true;
			detailedOppyForecastWrapper.isQ3Editable = (Integer.valueOf(fiscalYear) == currentFiscalYear && 3 < currentFiscalQuarter && !isAllowToEditPastForecast)? false : true;
			detailedOppyForecastWrapper.isQ4Editable = (Integer.valueOf(fiscalYear) == currentFiscalYear && 4 < currentFiscalQuarter && !isAllowToEditPastForecast)? false : true;
			
			for(BasicOppyForecastWrapper basicOppyForecastWrapper : map_FiscalYear_list_BasicForecasts.get(fiscalYear)){
				if(String.isNotBlank(basicOppyForecastWrapper.ForecastAmount)){
					if(detailedOppyForecastWrapper.YearTotal == null){
						detailedOppyForecastWrapper.YearTotal = 0;
					}
					detailedOppyForecastWrapper.YearTotal += decimal.valueOf(basicOppyForecastWrapper.ForecastAmount);
				}
				
				if(basicOppyForecastWrapper.FiscalQuarterLabel == 'Q1'){
					if(String.isNotBlank(basicOppyForecastWrapper.ForecastAmount) && detailedOppyForecastWrapper.isQ1Editable){
						if(detailedOppyForecastWrapper.Q1Total == null){
							detailedOppyForecastWrapper.Q1Total = 0;
						}
						detailedOppyForecastWrapper.Q1Total += decimal.valueOf(basicOppyForecastWrapper.ForecastAmount);
					}
				}else if(basicOppyForecastWrapper.FiscalQuarterLabel == 'Q2' && detailedOppyForecastWrapper.isQ2Editable){
					if(String.isNotBlank(basicOppyForecastWrapper.ForecastAmount)){
						if(detailedOppyForecastWrapper.Q2Total == null){
							detailedOppyForecastWrapper.Q2Total = 0;
						}
						detailedOppyForecastWrapper.Q2Total += decimal.valueOf(basicOppyForecastWrapper.ForecastAmount);
					}
				}else if(basicOppyForecastWrapper.FiscalQuarterLabel == 'Q3' && detailedOppyForecastWrapper.isQ3Editable){
					if(String.isNotBlank(basicOppyForecastWrapper.ForecastAmount)){
						if(detailedOppyForecastWrapper.Q3Total == null){
							detailedOppyForecastWrapper.Q3Total = 0;
						}
						detailedOppyForecastWrapper.Q3Total += decimal.valueOf(basicOppyForecastWrapper.ForecastAmount);
					}
				}else if(basicOppyForecastWrapper.FiscalQuarterLabel == 'Q4' && detailedOppyForecastWrapper.isQ4Editable){
					if(String.isNotBlank(basicOppyForecastWrapper.ForecastAmount)){
						if(detailedOppyForecastWrapper.Q4Total == null){
							detailedOppyForecastWrapper.Q4Total = 0;
						}
						detailedOppyForecastWrapper.Q4Total += decimal.valueOf(basicOppyForecastWrapper.ForecastAmount);
					}
				}
				
				for(MonthlyForecastWrapper monthlyForecastWrapper : detailedOppyForecastWrapper.list_MonthlyForecastWrappers){
					if(monthlyForecastWrapper.MonthNumber == Integer.valueOf(basicOppyForecastWrapper.FiscalMonthLabel)){
						monthlyForecastWrapper.QuarterName = basicOppyForecastWrapper.FiscalQuarterLabel;
						monthlyForecastWrapper.isEditable = (Integer.valueOf(fiscalYear) == currentFiscalYear && monthlyForecastWrapper.MonthNumber < currentFiscalMonth && !isAllowToEditPastForecast)? false : true;
						if(String.isNotBlank(basicOppyForecastWrapper.ForecastAmount) && monthlyForecastWrapper.isEditable){
						 	monthlyForecastWrapper.MonthlyForecastAmount = decimal.valueOf(basicOppyForecastWrapper.ForecastAmount);
						}
						monthlyForecastWrapper.ConfidenceLevel = basicOppyForecastWrapper.ConfidenceLevelValue;
						monthlyForecastWrapper.OppyForeCastId = basicOppyForecastWrapper.OppyForecastId;
						break;
					}
				}
			}
			list_DetailedOppyForecastWrappers.add(detailedOppyForecastWrapper);
		}
		system.debug('---list_DetailedOppyForecastWrappers:::' + list_DetailedOppyForecastWrappers);
		if(list_DetailedOppyForecastWrappers.size() > 0){
			for(DetailedOppyForecastWrapper detailedOppyForecastWrapper : list_DetailedOppyForecastWrappers){
				if(!detailedOppyForecastWrapper.list_MonthlyForecastWrappers.isEmpty()){
					for(MonthlyForecastWrapper monthlyForecastWrapper : detailedOppyForecastWrapper.list_MonthlyForecastWrappers){
						map_ForecastId_OldMonthlyForecast.put(monthlyForecastWrapper.OppyForeCastId, monthlyForecastWrapper);
					}
				}
			}
		}
		System.debug('---map_ForecastId_OldMonthlyForecast:::' + map_ForecastId_OldMonthlyForecast);
		return list_DetailedOppyForecastWrappers;
	}
	
	/*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to get values of picklist field.
	Inputs:        objectAPI - the API name of sobject
				   picklistField - the API name of picklist field 
	Returns:       list<SelectOption> - the list of selectOptions generated from picklist field values
	History
	2017-07-10 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
	public static list<SelectOption> getFieldPicklistValues(String objectAPI, String picklistField) {
		List<SelectOption> list_SelectOptions = new List<SelectOption>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectAPI);
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry>  controllingFieldValues = field_map.get(picklistField).getDescribe().getPickListValues();
        for(Schema.PicklistEntry pklVal : controllingFieldValues){
             list_SelectOptions.add(new SelectOption(pklVal.getValue(), pklVal.getLabel()));
        }
        return list_SelectOptions;
    }
    
    /*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to init Opportunity_Forecast__c records.
	Inputs:        
	Returns:       
	History
	2017-07-10 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
	public void initData(){
		list_BasicOppyForecastWrappers2Show.clear();
	  	list_DetailedOppyForecastWrappers2Show.clear();
	  	list_BasicOppyForecastWrappers2Show = GetBasicOppyForecastWrappers();
		list_BasicOppyForecastWrappers2Show = GetBasicForecastAmounts(list_BasicOppyForecastWrappers2Show);
		list_DetailedOppyForecastWrappers2Show = getDetailedOppyForecastWrappers(list_BasicOppyForecastWrappers2Show);
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Cancel successfully!'));
	}
	
	/*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to save Opportunity_Forecast__c records.
	Inputs:        
	Returns:       
	History
	2017-07-10 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
	public void SaveForecastValue(){
		isOppyForecastManagementSave = true;
		try{
			system.debug('---json_OppyForecasts2Save:::' + json_OppyForecasts2Save);
			List<MonthlyForecastWrapper> list_MonthlyForecastWrappers = (List<MonthlyForecastWrapper>)JSON.deserialize(json_OppyForecasts2Save, List<MonthlyForecastWrapper>.class);
			system.debug('---list_MonthlyForecastWrappers.size::' + list_MonthlyForecastWrappers.size());
		  	SaveForecastValueForOppyForecast(list_MonthlyForecastWrappers);
			list_BasicOppyForecastWrappers2Show.clear();
		  	list_DetailedOppyForecastWrappers2Show.clear();
		  	list_BasicOppyForecastWrappers2Show = GetBasicOppyForecastWrappers();
			list_BasicOppyForecastWrappers2Show = GetBasicForecastAmounts(list_BasicOppyForecastWrappers2Show);
			list_DetailedOppyForecastWrappers2Show = getDetailedOppyForecastWrappers(list_BasicOppyForecastWrappers2Show);
		  	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Saved successfully!'));
		  	isRefreshPage = true;
		  	System.debug('---isRefreshPage:::' + isRefreshPage);
		}catch(Exception ex){
			isRefreshPage = false; 
			system.debug('---error:::'+ex.getMessage() + ex.getStackTraceString());
			String vStrError = 'Error Type = ' + ex.getTypeName() + ' Error Line = ' + ex.getLineNumber() + '' + ' Error Stack = ' + ex.getStackTraceString() + ' Error Message = ' + ex.getMessage();
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError, '', '', '', '5','','','Exception', ex.getLineNumber() + '', ex.getStackTraceString());
			boolean isPassContactRoleCheck = checkContactRole(oppy.Id);
            if(isPassContactRoleCheck){
            	ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
            }else{
            	ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'Error: You must create a contact role on this opportunity before you can perform this operation.'));
            }
		}
	}
	
	/*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to insert and update Opportunity_Forecast__c records from MonthlyForecastWrapper objects.
	Inputs:        list_MonthlyForecastWrappers - the list of MonthlyForecastWrapper objects
	Returns:       
	History
	2017-07-10 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
	public void SaveForecastValueForOppyForecast(List<MonthlyForecastWrapper> list_MonthlyForecastWrappers){
		List<Opportunity_Forecast__c> list_OppyForecasts2Upsert = new List<Opportunity_Forecast__c>();
		map<String,MonthlyForecastWrapper> map_OppyForecastsId_MonthlyForecast = new map<String,MonthlyForecastWrapper>();	
		Id recordTypeId = Schema.SObjectType.Opportunity_Forecast__c.getRecordTypeInfosByName().get('Opportunity').getRecordTypeId();
		for(MonthlyForecastWrapper monthlyForecast : list_MonthlyForecastWrappers){
			if(String.isNotBlank(monthlyForecast.OppyForeCastId)){
				map_OppyForecastsId_MonthlyForecast.put(monthlyForecast.OppyForeCastId,monthlyForecast);
			}else{
				Opportunity_Forecast__c oppyForecast2Insert = new Opportunity_Forecast__c();
				oppyForecast2Insert.Opportunity__c = oppy.Id;
				oppyForecast2Insert.Fiscal_Year__c = monthlyForecast.YearName;
				oppyForecast2Insert.Fiscal_Quarter__c = monthlyForecast.QuarterName;
				oppyForecast2Insert.Fiscal_Month__c = String.valueOf(monthlyForecast.MonthNumber);
				oppyForecast2Insert.Amount__c = monthlyForecast.MonthlyForecastAmount;
				oppyForecast2Insert.CurrencyISOCode = 'USD';
				oppyForecast2Insert.RecordTypeId = recordTypeId;
				oppyForecast2Insert.FY_Start_Date__c = currentFiscalQuarterStartDate;
				oppyForecast2Insert.Confidence_Level__c = monthlyForecast.ConfidenceLevel;
				list_OppyForecasts2Upsert.add(oppyForecast2Insert);				
			}
		}
		system.debug('---map_OppyForecastsId_MonthlyForecast:::' + map_OppyForecastsId_MonthlyForecast);
		if(map_OppyForecastsId_MonthlyForecast.size() > 0){
			for(Opportunity_Forecast__c oppyForecast : [SELECT Id, Amount__c, Fiscal_Month__c,
														Fiscal_Quarter__c, Fiscal_Year__c  
														FROM Opportunity_Forecast__c 
														WHERE Opportunity__c =: oppy.Id 
														AND Id IN: map_OppyForecastsId_MonthlyForecast.keySet()]){
				oppyForecast.Amount__c = map_OppyForecastsId_MonthlyForecast.get(oppyForecast.Id).MonthlyForecastAmount;
				oppyForecast.Confidence_Level__c = map_OppyForecastsId_MonthlyForecast.get(oppyForecast.Id).ConfidenceLevel;
				if(map_ForecastId_OldMonthlyForecast.containsKey(oppyForecast.Id)){
					MonthlyForecastWrapper monthlyForecast = map_ForecastId_OldMonthlyForecast.get(oppyForecast.Id);
					if(monthlyForecast.MonthlyForecastAmount != oppyForecast.Amount__c
					|| monthlyForecast.ConfidenceLevel != oppyForecast.Confidence_Level__c){
						list_OppyForecasts2Upsert.add(oppyForecast);
					}
				}
			}
		}
		
		System.debug('---list_OppyForecasts2Upsert:::' + list_OppyForecasts2Upsert.size());
 		if(list_OppyForecasts2Upsert.size() > 0 ){ 
			upsert list_OppyForecasts2Upsert;
		}
	}
	
	/*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to check ContactRole records for Oppy.
	Inputs:        str_oppyId - the Id of current oppy
	Returns:       boolean - if error return false
	History
	2017-07-10 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
	public static boolean checkContactRole(String str_oppyId){
		Opportunity op;
		for(Opportunity opp :[select id,Probability from Opportunity where id =: str_oppyId]){
        	op = opp;
        }
		if(op != null){
    		list<OpportunityContactRole> list_ocr = new list<OpportunityContactRole>();
	    	for(OpportunityContactRole ocr : [select id,OpportunityId from OpportunityContactRole where OpportunityId =:str_oppyId]){
	    		list_ocr.add(ocr);
	    	}
	    	system.debug('checkContactRole::Probability::'+op.Probability+'::list_ocr::'+list_ocr.size());
	    	if(op.Probability >= 20 && list_ocr.size() < 1){
	    		return false;
	    	}else{
	    		return true;
	    	}
    	}else{
    		return true;
    	}
    }
    
    /*------------------------------------------------------------
	Author:        Tangyong Li <tangyong.li@capgemini.com>
	Description:   method to format number field
	Inputs:        
	Returns:       
	History
	2018-04-10     Tangyong Li <tangyong.li@capgemini.com> created
	------------------------------------------------------------*/
    public void setThousandAndDecimalSep(){
    	Decimal value = 1000.10;
	    String formattedValue = value.format();
	    String thousandSep = formattedValue.substring(1,2);
	    String decimalSep = formattedValue.substring(5,6);
	    this.str_thousandSep = thousandSep;
	    this.str_decimalSep = decimalSep;
    }
    
	public class BasicOppyForecastWrapper{
		public String FiscalYearLabel {get;set;}
		public String FiscalQuarterLabel {get;set;}
		public String FiscalMonthLabel {get;set;}
		public String ForecastAmount{get;set;}
		public String ActualAmount{get;set;}
		public String ConfidenceLevelValue {get;set;}
		public String OppyForecastId{get;set;}
	}
	
	public class DetailedOppyForecastWrapper{
		public String FiscalYearLabel {get;set;}
		public decimal YearTotal{get;set;}
		public decimal Q1Total {get;set;}
		public decimal Q2Total {get;set;}
		public decimal Q3Total {get;set;}
		public decimal Q4Total {get;set;}
		
		public Boolean isQ1Editable {get;set;}
		public Boolean isQ2Editable {get;set;}
		public Boolean isQ3Editable {get;set;}
		public Boolean isQ4Editable {get;set;}
		
		public List<MonthlyForecastWrapper> list_MonthlyForecastWrappers {get;set;}
	}
	
	public class MonthlyForecastWrapper{
		public String YearName {get;set;}
		public String QuarterName {get;set;}
		public Integer MonthNumber {get;set;}
		public String MonthName {get;set;}
		public String ConfidenceLevel {get;set;}
		public Boolean isEditable {get;set;}
		public decimal MonthlyForecastAmount {get;set;}
		public String OppyForeCastId{get;set;}
	}
}