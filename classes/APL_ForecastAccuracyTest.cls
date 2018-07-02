@isTest
private class APL_ForecastAccuracyTest {

    static testMethod void myUnitTest() {
    	
    	List<APL_Forecast_Management__c> l = new List<APL_Forecast_Management__c>();
    	APL_Forecast_Management__c apl = new APL_Forecast_Management__c();
    	apl.Name = 'testName';
    	apl.A6_Code__c = '123456';
    	apl.Manager__c = userInfo.getUserId();  
    	apl.RecordTypeId = '012E0000000NDPf';
    	l.add(apl);
    	
    	APL_Forecast_Management__c apl1 = new APL_Forecast_Management__c();
    	apl1.Name = 'testName1';
    	apl1.A6_Code__c = '1234567';
    	apl1.Manager__c = userInfo.getUserId();
    	apl1.RecordTypeId = '012E0000000NDPh';
    	l.add(apl1);
    	
    	insert l;
    	
    	Period p =  [select FiscalYearSettingsId, FiscalYearSettings.Name, Number, PeriodLabel, StartDate, EndDate from Period where type = 'Month' and startdate <=: System.today() and enddate >=: System.today() limit 1];
    	List<APL_AM_Forecast_Accuracy__c> aplList = new List<APL_AM_Forecast_Accuracy__c>();
        APL_AM_Forecast_Accuracy__c acc1 = new APL_AM_Forecast_Accuracy__c();
        acc1.am__c = apl.Id;
        acc1.Billing__c = 100;
        acc1.CBC2_Percentage__c = 20;
        acc1.Fiscal_Quarter__c = '1';
        acc1.Fiscal_Year__c = p.FiscalYearSettings.Name;
        acc1.one_month__c = 10;
        acc1.one_month_forecast__c = 100;
        acc1.Product_Family__c = 'test';
        acc1.Quantity__c = 100;
        acc1.Territory_Code__c = '123456';
        acc1.three_month__c = 10;
        acc1.three_month_forecast__c = 100;
        acc1.two_month__c = 10;
        acc1.two_month_forecast__c = 100;
        acc1.Type__c = 'Non-Relay';
        aplList.add(acc1);
        
        APL_AM_Forecast_Accuracy__c acc3 = new APL_AM_Forecast_Accuracy__c();
        acc3.am__c = apl.Id;
        acc3.Billing__c = 100;
        acc3.CBC2_Percentage__c = 20;
        acc3.Fiscal_Quarter__c = '2';
        acc3.Fiscal_Year__c = p.FiscalYearSettings.Name;
        acc3.one_month__c = 10;
        acc3.one_month_forecast__c = 100;
        acc3.Product_Family__c = 'test';
        acc3.Quantity__c = 100;
        acc3.Territory_Code__c = '123456';
        acc3.three_month__c = 10;
        acc3.three_month_forecast__c = 100;
        acc3.two_month__c = 10;
        acc3.two_month_forecast__c = 100;
        acc3.Type__c = 'Non-Relay';
        aplList.add(acc3);
        
        APL_AM_Forecast_Accuracy__c acc4 = new APL_AM_Forecast_Accuracy__c();
        acc4.am__c = apl.Id;
        acc4.Billing__c = 100;
        acc4.CBC2_Percentage__c = 20;
        acc4.Fiscal_Quarter__c = '3';
        acc4.Fiscal_Year__c = p.FiscalYearSettings.Name;
        acc4.one_month__c = 10;
        acc4.one_month_forecast__c = 100;
        acc4.Product_Family__c = 'test';
        acc4.Quantity__c = 100;
        acc4.Territory_Code__c = '123456';
        acc4.three_month__c = 10;
        acc4.three_month_forecast__c = 100;
        acc4.two_month__c = 10;
        acc4.two_month_forecast__c = 100;
        acc4.Type__c = 'Non-Relay';
        aplList.add(acc4);
        
        APL_AM_Forecast_Accuracy__c acc5 = new APL_AM_Forecast_Accuracy__c();
        acc5.am__c = apl.Id;
        acc5.Billing__c = 100;
        acc5.CBC2_Percentage__c = 20;
        acc5.Fiscal_Quarter__c = '4';
        acc5.Fiscal_Year__c = p.FiscalYearSettings.Name;
        acc5.one_month__c = 10;
        acc5.one_month_forecast__c = 100;
        acc5.Product_Family__c = 'test';
        acc5.Quantity__c = 100;
        acc5.Territory_Code__c = '123456';
        acc5.three_month__c = 10;
        acc5.three_month_forecast__c = 100;
        acc5.two_month__c = 10;
        acc5.two_month_forecast__c = 100;
        acc5.Type__c = 'Non-Relay';
        aplList.add(acc5);
        
        APL_AM_Forecast_Accuracy__c acc2 = new APL_AM_Forecast_Accuracy__c();
        acc2.am__c = apl.Id;
        acc2.Billing__c = 100;
        acc2.CBC2_Percentage__c = 20;
        acc2.Fiscal_Quarter__c = '3';
        acc2.Fiscal_Year__c = p.FiscalYearSettings.Name;
        acc2.one_month__c = 10;
        acc2.one_month_forecast__c = 100;
        acc2.Product_Family__c = 'test';
        acc2.Quantity__c = 100;
        acc2.Territory_Code__c = '1234567';
        acc2.three_month__c = 10;
        acc2.three_month_forecast__c = 100;
        acc2.two_month__c = 10;
        acc2.two_month_forecast__c = 100;
        acc2.Type__c = 'Relay Specilist';
        aplList.add(acc2);
        
        insert aplList;
        
        PageReference pageRef = ApexPages.currentPage();
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('territoryCode', '123456');
		ApexPages.currentPage().getParameters().put('type', 'AM');
        APL_ForecastAccuracy_Controller am = new APL_ForecastAccuracy_Controller();
        am.getShowTemplates();
        am.getYears();
        am.queryAccuracyByYear();
    	
    }
}