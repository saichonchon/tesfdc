/**
 *  update the value of custome setting "APL_Fiscal_Year_Setting__c"
 *
 @  author Yimin Zheng
 @  created 2015-10-13
 @  version 1.0
 
 *
 @  changelog
 *  2015-10-13 Yimin zheng 
 *  - Created
 */
global class ClsScheduled_APLUpdateFiscalYearSetting implements Schedulable{
	
	global void execute(SchedulableContext sc) {
		//get the first day and last day of current fiscal year
		Period p = [Select p.Type, p.StartDate, p.PeriodLabel, p.Number, p.EndDate From Period p
			where p.type='Year' and p.StartDate <=: System.today() and p.EndDate >: System.today()][0];
		if(p.StartDate == System.today() || Test.isRunningTest()){
			//get the value of custom setting APL_Fiscal_Year_Setting__c
			APL_Fiscal_Year_Setting__c fiscalYearSetting = APL_Fiscal_Year_Setting__c.getOrgDefaults();
			fiscalYearSetting.first_day__c = p.StartDate;
			fiscalYearSetting.last_day__c = p.EndDate;
			update fiscalYearSetting;
		}
	}
}