/**
*  This test class is for ClsBatch_GSMRestatement.
*
@author Di Chen
@created 2014-01-21
@version 1.0
@since 20.0
*
@changelog
* 2014-01-21 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage  100%
*/
@isTest
private class ClsBatch_GSMRestatement_Test {

    static testMethod void testBatch() {
    	
    	Forecast_Definition__c fd = new Forecast_Definition__c();
    	fd.Region__c = 'Americas';
    	fd.Profit_Center__c = 'A&C';
    	fd.GSM__c = UserInfo.getUserId();
    	fd.GSM_Name__c = '1234';
    	insert fd;
    	
        Manager_Forecast__c manForecast = new Manager_Forecast__c();
        manForecast.Fiscal_Year__c = '2014';
        manForecast.Fiscal_Month__c = 2;
        manForecast.Forecast_Definition__c = fd.Id;
        manForecast.Fiscal_Month__c = 1;
        manForecast.Forecast_USD__c = 1;
		insert manForecast;	 
		
		List<Manager_Forecast__c> list_manForecast = new List<Manager_Forecast__c>();
        list_manForecast.add(manForecast);
        
        String gsmKey = manForecast.GSM__c + '_' + manForecast.GSM_Name__c;
        
        map<String, map<String, map<Integer, ClsBatch_FinancialplanningRestatement.RestatementItem>>> map_gsmKey_year_month_restItem = new map<String, map<String, map<Integer, ClsBatch_FinancialplanningRestatement.RestatementItem>>>();
        map<String, map<Integer, ClsBatch_FinancialplanningRestatement.RestatementItem>> map_year_month_restItem = new map<String, map<Integer, ClsBatch_FinancialplanningRestatement.RestatementItem>>();
        map<Integer, ClsBatch_FinancialplanningRestatement.RestatementItem> map_month_restItem = new map<Integer, ClsBatch_FinancialplanningRestatement.RestatementItem>();
        ClsBatch_FinancialplanningRestatement.RestatementItem cls = new ClsBatch_FinancialplanningRestatement.RestatementItem();
        map_month_restItem.put(1,cls);
        map_year_month_restItem.put('2014',map_month_restItem);
        map_gsmKey_year_month_restItem.put(gsmKey,map_year_month_restItem);
        		
        map<String, set<String>> map_pfCtrRegionKey_gsmKey = new map<String, set<String>>();	
        		
		Test.startTest();
		
		ClsBatch_GSMRestatement clsBatch = new ClsBatch_GSMRestatement(map_gsmKey_year_month_restItem,map_pfCtrRegionKey_gsmKey);
        Database.BatchableContext BC;
        clsBatch.start(BC);
        clsBatch.execute(BC, list_manForecast);
        clsBatch.finish(BC);
		
		system.assert(true);
		Test.stopTest();
    }
}