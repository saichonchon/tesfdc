/**
*	Test class Name: APL_ForecastAccuracyTest
@changelog
* - Test coverage 91%
* - 2016-11-10 Rajendra Shahane <rajendra.shahane@zensar.com>
* Modified for case 901021
*/
public class APL_ForecastAccuracy_Controller {
  public String territoryCode{get;set;}
    public String forecastType{get;set;}
    public List<APL_AM_Forecast_Accuracy__c> accuracyList{get;set;}
    public Boolean hasAccuracy {get;set;}
    Set<String> selectYearSet = new Set<String>();
    public String selectYear{get;set;}
    List<AggregateResult> accuracyYearList;
    Map<String,String> proHierarchyMap = new Map<String,String>();//CBC2,CBC2 Description
    public Decimal q1Total{get;set;}
    public Decimal q2Total{get;set;}
    public Decimal q3Total{get;set;}
    public Decimal q4Total{get;set;}
    public Decimal yearTotal{get;set;}
    
    public APL_ForecastAccuracy_Controller(){
        hasAccuracy = false;//initial value
        territoryCode = ApexPages.currentPage().getParameters().get('territoryCode');
        forecastType = ApexPages.currentPage().getParameters().get('type');
        q1Total = 0;
        q2Total = 0;
        q3Total = 0;
        q4Total = 0;
        yearTotal = 0;
        //get current fiscal year
        Period p =  [select FiscalYearSettingsId, FiscalYearSettings.Name, Number, PeriodLabel, StartDate, EndDate from Period where type = 'Month' and startdate <=: System.today() and enddate >=: System.today() limit 1];
        if(forecastType == 'AM'){
            accuracyList = [select Id,CBC2_Percentage__c,Fiscal_Year__c,one_month__c,two_month__c,three_month__c,Fiscal_Quarter__c,Product_family__c,Accuracy_for_CBC2__c from APL_AM_Forecast_Accuracy__c where Fiscal_Year__c =: p.FiscalYearSettings.Name and territory_Code__c =: territoryCode and type__c <> 'Relay Specilist' order by Product_family__c];
            //get the available fiscal year
            accuracyYearList = [select fiscal_year__c fYear,sum(one_month__c) from APL_AM_Forecast_Accuracy__c where territory_Code__c =: territoryCode and type__c <> 'Relay Specilist' group by fiscal_year__c];
        }else{
            accuracyList = [select Id,CBC2_Percentage__c,Fiscal_Year__c,one_month__c,two_month__c,three_month__c,Fiscal_Quarter__c,Product_family__c,Accuracy_for_CBC2__c from APL_AM_Forecast_Accuracy__c where Fiscal_Year__c =: p.FiscalYearSettings.Name and territory_Code__c =: territoryCode and type__c = 'Relay Specilist' order by Product_family__c];
            //get the available fiscal year
            accuracyYearList = [select fiscal_year__c fYear,sum(one_month__c) from APL_AM_Forecast_Accuracy__c where territory_Code__c =: territoryCode and type__c = 'Relay Specilist' group by fiscal_year__c];
        }
        
        if(accuracyList.size() > 0){
            hasAccuracy = true;
        }
        
        for(AggregateResult accuracyYear : accuracyYearList){
            selectYearSet.add((String)accuracyYear.get('fYear'));
        }
        
        List<Product_Hierarchy__c> proHierarchyList = [select CBC2__c,CBC2_Description__c from Product_Hierarchy__c where CBC2__c in ('30012','30015','30016','30017','30042')];
        for(Product_Hierarchy__c pro : proHierarchyList){
            proHierarchyMap.put(pro.CBC2__c,pro.CBC2_Description__c);
        }
    }
    
    //show data
    public List<ShowTemplate> getShowTemplates(){
        Map<String,ShowTemplate> templateMap = new Map<String,ShowTemplate>();
        system.debug('@@excecuted');		
        for(APL_AM_Forecast_Accuracy__c accuracy : accuracyList){
            ShowTemplate show = templateMap.get(accuracy.Product_family__c);
			if(show == null) show = templateMap.get(proHierarchyMap.get(accuracy.Product_family__c));//Added by Rajendra for case 901021
            if(show == null){
                show = new ShowTemplate();
                String productFamilyName = proHierarchyMap.get(accuracy.Product_family__c);
                if(productFamilyName == null){ 
                    show.productFamily = accuracy.Product_family__c;
                }else{
                    show.productFamily = productFamilyName;
                }				
            }            
            
            if(show.q1Accuracy == null){
                show.q1Accuracy = 0;
            }
            if(show.q2Accuracy == null){
                show.q2Accuracy = 0;
            }
            if(show.q3Accuracy == null){
                show.q3Accuracy = 0;
            }
            if(show.q4Accuracy == null){
                show.q4Accuracy = 0;
            }
			if(accuracy.fiscal_quarter__c == '1'){
                show.q1ThreeMonth = accuracy.three_month__c.setScale(2);
                show.q1TwoMonth = accuracy.two_month__c.setScale(2);
                show.q1OneMonth = accuracy.one_month__c.setScale(2);
                show.q1Accuracy = accuracy.Accuracy_for_CBC2__c.setScale(2);
				q1Total += (show.q1Accuracy * accuracy.CBC2_Percentage__c/100).setScale(2);//Added by Rajendra for case 901021
            }else if(accuracy.fiscal_quarter__c == '2'){
                show.q2ThreeMonth = accuracy.three_month__c.setScale(2);
                show.q2TwoMonth = accuracy.two_month__c.setScale(2);
                show.q2OneMonth = accuracy.one_month__c.setScale(2);
                show.q2Accuracy = accuracy.Accuracy_for_CBC2__c.setScale(2);
				q2Total += (show.q2Accuracy * accuracy.CBC2_Percentage__c/100).setScale(2);//Added by Rajendra for case 901021
            }else if(accuracy.fiscal_quarter__c == '3'){
                show.q3ThreeMonth = accuracy.three_month__c.setScale(2);
                show.q3TwoMonth = accuracy.two_month__c.setScale(2);
                show.q3OneMonth = accuracy.one_month__c.setScale(2);
                show.q3Accuracy = accuracy.Accuracy_for_CBC2__c.setScale(2);
				q3Total += (show.q3Accuracy * accuracy.CBC2_Percentage__c/100).setScale(2);//Added by Rajendra for case 901021
            }else if(accuracy.fiscal_quarter__c == '4'){
                show.q4ThreeMonth = accuracy.three_month__c.setScale(2);
                show.q4TwoMonth = accuracy.two_month__c.setScale(2);
                show.q4OneMonth = accuracy.one_month__c.setScale(2);
                show.q4Accuracy = accuracy.Accuracy_for_CBC2__c.setScale(2);
				q4Total += (show.q4Accuracy * accuracy.CBC2_Percentage__c/100).setScale(2);//Added by Rajendra for case 901021
            }
            show.yearToDay = ((show.q1Accuracy + show.q2Accuracy + show.q3Accuracy + show.q4Accuracy) * 0.25).setScale(2);
			//q1Total += (show.q1Accuracy * accuracy.CBC2_Percentage__c/100).setScale(2);//commented by Rajendra Shahane for case 901021
			//q2Total += (show.q2Accuracy * accuracy.CBC2_Percentage__c/100).setScale(2);//commented by Rajendra Shahane for case 901021
			//q3Total += (show.q3Accuracy * accuracy.CBC2_Percentage__c/100).setScale(2);//commented by Rajendra Shahane for case 901021
			//q4Total += (show.q4Accuracy * accuracy.CBC2_Percentage__c/100).setScale(2);//commented by Rajendra Shahane for case 901021
			yearTotal = ((q1Total + q2Total + q3Total + q4Total)*0.25).setScale(2);
			if(!templateMap.containskey(show.productFamily))//Added by Rajendra for case 901021
				templateMap.put(show.productFamily,show);
        }
		
        return templateMap.values();
    }
    
    
    //available year
    public List<SelectOption> getYears(){
        
        List<SelectOption> options = new List<SelectOption>();
        
        if(selectYearSet.size() > 0){
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
        //Start: Added by Rajendra for case 901021
         q1Total = 0;
         q2Total = 0;
         q3Total = 0;
         q4Total = 0;
         yearTotal = 0;
        //End: Added by Rajendra for case 901021
        accuracyList = new list<APL_AM_Forecast_Accuracy__c>();
        if(forecastType == 'AM'){
            accuracyList = [select Id,Fiscal_Year__c,one_month__c,two_month__c,three_month__c,Fiscal_Quarter__c,Product_family__c,Accuracy_for_CBC2__c,CBC2_Percentage__c from APL_AM_Forecast_Accuracy__c where Fiscal_Year__c =: selectYear and territory_Code__c =: territoryCode and type__c <> 'Relay Specilist' order by Product_family__c];
        }else{
            accuracyList = [select Id,Fiscal_Year__c,one_month__c,two_month__c,three_month__c,Fiscal_Quarter__c,Product_family__c,Accuracy_for_CBC2__c,CBC2_Percentage__c from APL_AM_Forecast_Accuracy__c where Fiscal_Year__c =: selectYear and territory_Code__c =: territoryCode and type__c = 'Relay Specilist' order by Product_family__c];
        }
        
        if(accuracyList.size() > 0){
            hasAccuracy = true;
            //getShowTemplates();//Commented by Rajendra for case 901021
        }
        return null;
    }
    
    public class ShowTemplate{
        public String productFamily{get;set;}
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