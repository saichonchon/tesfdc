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
private class APL_CtrlChart_Test {   

    static testMethod void myUnitTest() {
        Test.startTest();
    	Apexpages.currentPage().getParameters().put('url', EncodingUtil.base64Encode(Blob.valueOf('RSM;RSMRelay')));
        APL_CtrlChart apl = new APL_CtrlChart();
        APL_CtrlChart.enCodeUrl('gam', 'test', UserInfo.getUserId());
        Test.stopTest();
    }
}