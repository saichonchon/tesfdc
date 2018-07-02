public class APL_ForecastAccuracy_RSM_Controller {
	public String territoryCode{get;set;}
	public String forecastType{get;set;}
	public Set<String> territoryCodeSet{get;set;}
	public List<APL_AM_Forecast_Accuracy__c> accuracyList{get;set;}
	public Boolean hasAccuracy {get;set;}
	public Set<String> selectYearSet{get;set;}
	public String selectYear{get;set;}
	List<AggregateResult> accuracyYearList;
	
	public APL_ForecastAccuracy_RSM_Controller(){
		hasAccuracy = false;//initial value
		territoryCode = ApexPages.currentPage().getParameters().get('territoryCode');
		territoryCodeSet = new Set<String>();
		String[] temp = territoryCode.split(',');
		for(String tmp : temp){
			if(tmp.indexOf('name=') > -1 && tmp.indexOf('displayName=') == -1){
				territoryCodeSet.add(tmp.replace('name=','').trim());
			}
		}
		forecastType = ApexPages.currentPage().getParameters().get('type');
		selectYearSet = new Set<String>();
		//get current fiscal year
		Period p =  [select FiscalYearSettingsId, FiscalYearSettings.Name, Number, PeriodLabel, StartDate, EndDate from Period where type = 'Month' and startdate <=: System.today() and enddate >=: System.today() limit 1];
		if(forecastType == 'AM'){
			accuracyList = [select Id,AM__r.Name,territory_Code__c,CBC2_Percentage__c,Billing__c,Fiscal_Year__c,one_month__c,two_month__c,three_month__c,Fiscal_Quarter__c,Product_family__c,Accuracy_for_CBC2__c from APL_AM_Forecast_Accuracy__c where Fiscal_Year__c =: p.FiscalYearSettings.Name and territory_Code__c in: territoryCodeSet and type__c <> 'Relay Specilist' order by AM__r.Name];
			//get the available fiscal year
			accuracyYearList = [select fiscal_year__c fYear,sum(one_month__c) from APL_AM_Forecast_Accuracy__c where territory_Code__c in: territoryCodeSet and type__c <> 'Relay Specilist' group by fiscal_year__c];
		}else{
			accuracyList = [select Id,AM__r.Name,CBC2_Percentage__c,territory_Code__c,Billing__c,Fiscal_Year__c,one_month__c,two_month__c,three_month__c,Fiscal_Quarter__c,Product_family__c,Accuracy_for_CBC2__c from APL_AM_Forecast_Accuracy__c where Fiscal_Year__c =: p.FiscalYearSettings.Name and territory_Code__c in: territoryCodeSet and type__c = 'Relay Specilist' order by AM__r.Name];
			//get the available fiscal year
			accuracyYearList = [select fiscal_year__c fYear,sum(one_month__c) from APL_AM_Forecast_Accuracy__c where territory_Code__c in: territoryCodeSet and type__c = 'Relay Specilist' group by fiscal_year__c];
		}
		
		if(accuracyList.size() > 0){
			hasAccuracy = true;
		}
		
		for(AggregateResult accuracyYear : accuracyYearList){
			selectYearSet.add((String)accuracyYear.get('fYear'));
		}
		
	}
	
	//show data
	public List<ShowTemplate> getShowTemplates(){
		
		Map<String,ShowTemplate> templateMap = new Map<String,ShowTemplate>();
		Map<String,Decimal> territoryCodeBillingMap = new Map<String,Decimal>();
		Decimal totalBilling = 0;
		
		for(APL_AM_Forecast_Accuracy__c accuracy : accuracyList){
			ShowTemplate temp = templateMap.get(accuracy.territory_code__c);
			if(temp == null){
				temp = new ShowTemplate();
				temp.TerritoryCodeName = accuracy.AM__r.Name;
			}
			
			if(accuracy.three_month__c == null){
				accuracy.three_month__c = 0;
			}
			
			if(accuracy.two_month__c == null){
				accuracy.two_month__c = 0;
			}
			
			if(accuracy.one_month__c == null){
				accuracy.one_month__c = 0;
			}
			
			if(accuracy.CBC2_Percentage__c == null){
				accuracy.CBC2_Percentage__c = 0;
			}
			
			if(accuracy.fiscal_quarter__c == '1'){
				temp.q1ThreeMonth += (accuracy.three_month__c*accuracy.CBC2_Percentage__c/100).setScale(2);
				temp.q1TwoMonth += (accuracy.two_month__c*accuracy.CBC2_Percentage__c/100).setScale(2);
				temp.q1OneMonth += (accuracy.one_month__c*accuracy.CBC2_Percentage__c/100).setScale(2);
				temp.q1Accuracy += (accuracy.Accuracy_for_CBC2__c*accuracy.CBC2_Percentage__c/100).setScale(2);
			}else if(accuracy.fiscal_quarter__c == '2'){
				temp.q2ThreeMonth += (accuracy.three_month__c*accuracy.CBC2_Percentage__c/100).setScale(2);
				temp.q2TwoMonth += (accuracy.two_month__c*accuracy.CBC2_Percentage__c/100).setScale(2);
				temp.q2OneMonth += (accuracy.one_month__c*accuracy.CBC2_Percentage__c/100).setScale(2);
				temp.q2Accuracy += (accuracy.Accuracy_for_CBC2__c*accuracy.CBC2_Percentage__c/100).setScale(2);
			}else if(accuracy.fiscal_quarter__c == '3'){
				temp.q3ThreeMonth += (accuracy.three_month__c*accuracy.CBC2_Percentage__c/100).setScale(2);
				temp.q3TwoMonth += (accuracy.two_month__c*accuracy.CBC2_Percentage__c/100).setScale(2);
				temp.q3OneMonth += (accuracy.one_month__c*accuracy.CBC2_Percentage__c/100).setScale(2);
				temp.q3Accuracy += (accuracy.Accuracy_for_CBC2__c*accuracy.CBC2_Percentage__c/100).setScale(2);
			}else if(accuracy.fiscal_quarter__c == '4'){
				temp.q4ThreeMonth += (accuracy.three_month__c*accuracy.CBC2_Percentage__c/100).setScale(2);
				temp.q4TwoMonth += (accuracy.two_month__c*accuracy.CBC2_Percentage__c/100).setScale(2);
				temp.q4OneMonth += (accuracy.one_month__c*accuracy.CBC2_Percentage__c/100).setScale(2);
				temp.q4Accuracy += (accuracy.Accuracy_for_CBC2__c*accuracy.CBC2_Percentage__c/100).setScale(2);
			}
			temp.yearToDay = ((temp.q1Accuracy + temp.q2Accuracy + temp.q3Accuracy + temp.q4Accuracy)*0.25).setScale(2);
			templateMap.put(accuracy.territory_code__c,temp);
			
			Decimal billing = territoryCodeBillingMap.get(accuracy.territory_code__c);
			if(billing == null){
				billing = 0;
			}
			billing += accuracy.billing__c;
			totalBilling += accuracy.billing__c;
			territoryCodeBillingMap.put(accuracy.territory_code__c,billing);
		}
		
		//figure out each territory code percentage
		for(String key : territoryCodeBillingMap.keySet()){
			Decimal billing = territoryCodeBillingMap.get(key);
			Decimal percent = billing / totalBilling;
			territoryCodeBillingMap.put(key,percent);
		}
		
		ShowTemplate temp = new ShowTemplate();
		temp.TerritoryCodeName = 'Total';
		for(String key : templateMap.keySet()){
			ShowTemplate t = templateMap.get(key);
			
			temp.q1ThreeMonth += (t.q1ThreeMonth * territoryCodeBillingMap.get(key)).setScale(2);
			temp.q1TwoMonth += (t.q1TwoMonth * territoryCodeBillingMap.get(key)).setScale(2);
			temp.q1OneMonth += (t.q1OneMonth * territoryCodeBillingMap.get(key)).setScale(2);
			temp.q1Accuracy += (t.q1Accuracy * territoryCodeBillingMap.get(key)).setScale(2);
			temp.q2ThreeMonth += (t.q2ThreeMonth * territoryCodeBillingMap.get(key)).setScale(2);
			temp.q2TwoMonth += (t.q2TwoMonth * territoryCodeBillingMap.get(key)).setScale(2);
			temp.q2OneMonth += (t.q2OneMonth * territoryCodeBillingMap.get(key)).setScale(2);
			temp.q2Accuracy += (t.q2Accuracy * territoryCodeBillingMap.get(key)).setScale(2);
			temp.q3ThreeMonth += (t.q3ThreeMonth * territoryCodeBillingMap.get(key)).setScale(2);
			temp.q3TwoMonth += (t.q3TwoMonth * territoryCodeBillingMap.get(key)).setScale(2);
			temp.q3OneMonth += (t.q3OneMonth * territoryCodeBillingMap.get(key)).setScale(2);
			temp.q3Accuracy += (t.q3Accuracy * territoryCodeBillingMap.get(key)).setScale(2);
			temp.q4ThreeMonth += (t.q4ThreeMonth * territoryCodeBillingMap.get(key)).setScale(2);
			temp.q4TwoMonth += (t.q4TwoMonth * territoryCodeBillingMap.get(key)).setScale(2);
			temp.q4OneMonth += (t.q4OneMonth * territoryCodeBillingMap.get(key)).setScale(2);
			temp.q4Accuracy += (t.q4Accuracy * territoryCodeBillingMap.get(key)).setScale(2);
			temp.yearToDay += (t.yearToDay * territoryCodeBillingMap.get(key)).setScale(2);
		}
		
		templateMap.put(temp.TerritoryCodeName,temp);
		
		return templateMap.values();
	}
	
	//available year
	public List<SelectOption> getYears(){
		
		List<SelectOption> options = new List<SelectOption>();
		
		if(selectYearSet != null && selectYearSet.size() > 0){
			for(String year : selectYearSet){
				options.add(new SelectOption(year,year));
			}
		}else{
			options.add(new SelectOption('no value','no value'));
		}
		
		return options;
	}
	
	//when user select different fiscal year, query the accuracy again
	public PageReference queryAccuracyByYear(){
		hasAccuracy = false;
		if(forecastType == 'AM'){
			accuracyList = [select Id,AM__r.Name,CBC2_Percentage__c,Billing__c,territory_Code__c,Fiscal_Year__c,one_month__c,two_month__c,three_month__c,Fiscal_Quarter__c,Product_family__c,Accuracy_for_CBC2__c from APL_AM_Forecast_Accuracy__c where Fiscal_Year__c =: selectYear and territory_Code__c in: territoryCodeSet and type__c <> 'Relay Specilist' order by AM__r.Name];
		}else{
			accuracyList = [select Id,AM__r.Name,CBC2_Percentage__c,Billing__c,territory_Code__c,Fiscal_Year__c,one_month__c,two_month__c,three_month__c,Fiscal_Quarter__c,Product_family__c,Accuracy_for_CBC2__c from APL_AM_Forecast_Accuracy__c where Fiscal_Year__c =: selectYear and territory_Code__c in: territoryCodeSet and type__c = 'Relay Specilist' order by AM__r.Name];
		}
		
		if(accuracyList.size() > 0){
			hasAccuracy = true;
			getShowTemplates();
		}
		return null;
	}
	
	public class ShowTemplate{
		public String TerritoryCodeName{get;set;}
		public Decimal q1ThreeMonth{get;set;}
		public Decimal q1TwoMonth{get;set;}
		public Decimal q1OneMonth{get;set;}
		public Decimal q1Accuracy{get;set;}
		public Decimal q2ThreeMonth{get;set;}
		public Decimal q2TwoMonth{get;set;}
		public Decimal q2OneMonth{get;set;}
		public Decimal q2Accuracy{get;set;}
		public Decimal q3ThreeMonth{get;set;}
		public Decimal q3TwoMonth{get;set;}
		public Decimal q3OneMonth{get;set;}
		public Decimal q3Accuracy{get;set;}
		public Decimal q4ThreeMonth{get;set;}
		public Decimal q4TwoMonth{get;set;}
		public Decimal q4OneMonth{get;set;}
		public Decimal q4Accuracy{get;set;}
		public Decimal yearToDay{get;set;}
		
		ShowTemplate(){
			q1ThreeMonth = 0.00;
			q1TwoMonth = 0.00;
			q1OneMonth = 0.00;
			q1Accuracy = 0.00;
			q2ThreeMonth = 0.00;
			q2TwoMonth = 0.00;
			q2OneMonth = 0.00;
			q2Accuracy = 0.00;
			q3ThreeMonth = 0.00;
			q3TwoMonth = 0.00;
			q3OneMonth = 0.00;
			q3Accuracy = 0.00;
			q4ThreeMonth = 0.00;
			q4TwoMonth = 0.00;
			q4OneMonth = 0.00;
			q4Accuracy = 0.00;
			yearToDay = 0.00;
		}
	}
}