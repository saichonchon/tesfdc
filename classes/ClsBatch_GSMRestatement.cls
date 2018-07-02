/** 
*   A batch job to managerforecast on updata forecast USD field
*
@author Minghao Li
@created 2013-11-27
@version 1.0
@since 28.0 (Force.com ApiVersion)
*
@changelog
* 2013-11-27 Minghao Li <minghao.li@itbconsult.com>
* - Created
*/
global class ClsBatch_GSMRestatement implements Database.Batchable<SObject>, Database.stateful{
	
	
	global map<String, map<String, map<Integer, ClsBatch_FinancialplanningRestatement.RestatementItem>>> map_gsmKey_year_month_restItem;
	global map<String, set<String>> map_pfCtrRegionKey_gsmKey;
	public String query;
	public String currentYear;
	
	global ClsBatch_GSMRestatement(map<String, map<String, map<Integer, ClsBatch_FinancialplanningRestatement.RestatementItem>>> map_gsmKey_year_month_restItem,
									map<String, set<String>> map_pfCtrRegionKey_gsmKey){
		
		
		this.map_gsmKey_year_month_restItem = map_gsmKey_year_month_restItem;
		this.map_pfCtrRegionKey_gsmKey = map_pfCtrRegionKey_gsmKey;
		for (Period period : [select Id, FiscalYearSettings.Name, PeriodLabel from Period where StartDate<=Today and EndDate >=Today and Type = 'Month']) {
            if(period.FiscalYearSettings.Name != null){
                currentYear = period.FiscalYearSettings.Name;
            }
        }
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC){ 
		if(query == '' || query == null){
			query = 'Select id, Fiscal_Year__c, Fiscal_Month__c, Forecast_USD__c, '+
				    '       Fiscal_Date__c, GSM__c, GSM_Name__c '+
				    ' From Manager_Forecast__c '+
				    ' Where Fiscal_Year__c >= \''+currentYear+'\' and Fiscal_Year__c != null ' + 
				    ' and Fiscal_Month__c != null '+
				    ' and GSM__c != null '+
				    ' and GSM_Name__c != null '+
				    ' and Forecast_Definition__c = null ';
		}
		return Database.getQueryLocator(query);  
	}
	 
	global void execute(Database.BatchableContext BC, list<Manager_Forecast__c> scope){
		list<Manager_Forecast__c> list_gsmFC = new list<Manager_Forecast__c>();
		for(Manager_Forecast__c mf : scope) {
			String gsmKey = mf.GSM__c + '_' + mf.GSM_Name__c;
			String year = mf.Fiscal_Year__c;
			Integer month = Integer.valueOf(mf.Fiscal_Month__c);
			
			if(map_gsmKey_year_month_restItem.containsKey(gsmKey) && map_gsmKey_year_month_restItem.get(gsmKey).containsKey(year) && map_gsmKey_year_month_restItem.get(gsmKey).get(year).containsKey(month)) {
				ClsBatch_FinancialplanningRestatement.RestatementItem item = map_gsmKey_year_month_restItem.get(gsmKey).get(year).get(month);
				double newValue = item.newFC;
				double oldValue = item.oldFC;
				double rate = (oldValue == 0 ? 1 : (newValue / oldValue));
				mf.Forecast_USD__c = mf.Forecast_USD__c * rate;
				list_gsmFC.add(mf);
			}
			
		}
		database.update(list_gsmFC);
	}
	 
	global void finish(Database.BatchableContext BC){ 

	}
}