/**
*  This test class used to test class ExtRecalculateBudget.
*
@author Bin Yuan
@created 2014-01-20
@version 1.0   
@since 28.0
*
@changelog
* coverage % 
* 
* 
2014-01-20 Bin Yuan <bin.yuan@itbconsult.com>
* - Created
*/
@isTest(seeAllData = true) 
private class CtrlAccountForecastUtil_Test {
	static testMethod void myUnitTest1() {
		Test.startTest();
		CtrlAccountForecast.PageConfig pageConf = new CtrlAccountForecast.PageConfig();
		CtrlAccountForecastUtil.setCurrent(pageConf);
		
		map<String, Set<Integer>> map_financialMonth = new map<String, Set<Integer>>();
		CtrlAccountForecastUtil.setfinancialMonths(map_financialMonth);
		
		CtrlAccountForecastUtil.buildMonthFilter(map_financialMonth);
		CtrlAccountForecastUtil.getCurrentMonthIndex(map_financialMonth, pageConf.currentYear, pageConf.currentMonth);
		Set<Date> set_date = new set<Date>();
		for(Integer i = 1; i <=12; i++) {
			CtrlAccountForecastUtil.setDate(i, Integer.valueOf(pageConf.currentYear), pageConf.currentMonth, set_date);
		}
		Test.stopTest();
	}
}