/**
*  This test class used to test class ClsAPLRSMForecastUtil.
*
@author Lili Zhao
@created 2014-08-15
*
@changelog
* coverage  100%
*  
2014-08-15 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest
private class APL_CtrlExportCSVFile_Test {

    static testMethod void myUnitTest() {
    	Test.startTest();
    	Apexpages.currentPage().getParameters().put('exp', 'test11111');
        APL_CtrlExportCSVFile apl = new APL_CtrlExportCSVFile();
        
        Test.stopTest();
        
    }
}