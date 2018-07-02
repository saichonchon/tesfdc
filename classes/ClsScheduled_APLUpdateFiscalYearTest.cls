/**
 *  test class for ClsScheduled_APLUpdateFiscalYearSetting
 *
 @  author Yimin Zheng
 @  created 2015-10-13
 @  version 1.0
 
 *
 @  changelog
 *  2015-10-13 Yimin zheng 
 *  - Created
 */
@isTest
private class ClsScheduled_APLUpdateFiscalYearTest {

    static testMethod void myUnitTest() {
        DateTime currTime = DateTime.now();
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        String sch;
        
        if(min <= 58)
            sch = '0 '+ (min + 1) + ' ' + hour + ' * * ? '+ currTime.year();
        else          
            sch = '0 0 '+ (hour + 1) + ' * * ? '+ currTime.year();
            
        APL_Fiscal_Year_Setting__c fiscalYear = new APL_Fiscal_Year_Setting__c();
        fiscalYear.first_day__c = System.today();
		fiscalYear.last_day__c = System.today() + 1;
		insert fiscalYear;
        
        Test.startTest();
        
        ClsScheduled_APLUpdateFiscalYearSetting obj = new ClsScheduled_APLUpdateFiscalYearSetting();                
        String jobId = system.schedule('test_NPSMSG', sch, obj); 
        
        Test.stopTest();
    }
}